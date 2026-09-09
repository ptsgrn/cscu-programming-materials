"""
Lab 4 — shared plumbing. Nothing in here is your job.

What is already here:
  - the model call (talks to the course endpoint, same one as Lab 3)
  - the embedding model (runs locally, no key)
  - corpus loading, the 100-question exam, and the scoring

Read it anyway. It is not a framework.
"""

import csv
import os
import re
import time
import warnings
from collections import Counter
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

warnings.filterwarnings("ignore")

from dotenv import load_dotenv

ROOT = Path(__file__).resolve().parent.parent
RAW_DIR = ROOT / "data" / "raw"
INDEX_DIR = ROOT / "data" / "index"
MCQ_FILE = ROOT / "data" / "eval" / "mcq.csv"

load_dotenv(ROOT / ".env")

from langchain_chroma import Chroma
from langchain_community.embeddings.fastembed import FastEmbedEmbeddings
from langchain_core.documents import Document
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnablePassthrough
from langchain_openai import ChatOpenAI
from langchain_text_splitters import RecursiveCharacterTextSplitter


# ---------------------------------------------------------------------------
# The model. Paste today's key (from the LMS) into .env as COURSE_API_KEY.
# Same endpoint as Lab 3. A 401 means fetch today's.
# ---------------------------------------------------------------------------

MODEL = os.environ.get("COURSE_MODEL", "qwen3.5")
BASE_URL = os.environ.get("COURSE_BASE_URL", "http://161.200.93.57:4000/v1")


def get_llm(temperature=0.0, max_tokens=10000):
    return ChatOpenAI(
        model=MODEL,
        base_url=BASE_URL,
        api_key=os.environ.get("COURSE_API_KEY", "????"),
        temperature=temperature,
        max_tokens=max_tokens,
    )


# ---------------------------------------------------------------------------
# The embedding model. Local ONNX, ~130MB on first run. No key, no GPU.
# ---------------------------------------------------------------------------

EMBED_MODEL = "BAAI/bge-small-en-v1.5"
COLLECTION = "lab4"


def get_embeddings():
    return FastEmbedEmbeddings(model_name=EMBED_MODEL)


# ---------------------------------------------------------------------------
# Corpus and index
# ---------------------------------------------------------------------------

def load_documents():
    """One Document per markdown file, with metadata we can filter and cite on."""
    docs = []
    for path in sorted(RAW_DIR.glob("*.md")):
        docs.append(
            Document(
                page_content=path.read_text(encoding="utf-8"),
                metadata={
                    "source": path.name,
                    # Some documents are superseded revisions. Capture that now:
                    # you cannot filter on metadata you never stored.
                    "status": "archived" if path.stem.endswith("_archived") else "current",
                },
            )
        )
    return docs


def split_documents(docs, chunk_size=800, chunk_overlap=120):
    splitter = RecursiveCharacterTextSplitter(
        chunk_size=chunk_size, chunk_overlap=chunk_overlap
    )
    return splitter.split_documents(docs)


def get_vectorstore(chunks=None):
    """Open the index. Pass chunks to (re)build it from scratch."""
    store = Chroma(
        persist_directory=str(INDEX_DIR),
        collection_name=COLLECTION,
        embedding_function=get_embeddings(),
    )
    if chunks is None:
        return store
    # Wipe first, so re-running the script does not stack duplicate copies.
    store.delete_collection()
    return Chroma.from_documents(
        chunks,
        get_embeddings(),
        persist_directory=str(INDEX_DIR),
        collection_name=COLLECTION,
    )


# ---------------------------------------------------------------------------
# The exam. 100 multiple-choice questions written from data/raw.
#
#   simple   the answer is one fact in one document
#   complex  the answer needs a conclusion, not a quote
#   combine  the answer needs two or more documents
#
# Several wrong options are lifted from the corpus's own junk documents — the
# 2019 leave policy, the 2024 price list, the legacy RB-5 spec. A pipeline that
# retrieves the wrong document will pick a wrong letter.
# ---------------------------------------------------------------------------

def load_questions(kind=None):
    rows = []
    with MCQ_FILE.open(encoding="utf-8") as fh:
        for row in csv.DictReader(fh):
            row["gold_docs"] = row["gold_docs"].split(";")
            if kind is None or row["type"] == kind:
                rows.append(row)
    return rows


def format_question(item):
    return (
        f"{item['question']}\n"
        f"A) {item['option_a']}\n"
        f"B) {item['option_b']}\n"
        f"C) {item['option_c']}\n"
        f"D) {item['option_d']}"
    )


MCQ_SYSTEM = (
    "You are answering a multiple-choice question about an internal knowledge base.\n"
    "Use ONLY the context below. Do not use prior knowledge.\n"
    "Reply with a single letter: A, B, C or D. No explanation, no punctuation.\n\n"
    "Context:\n{context}"
)


def format_docs(docs):
    """Number the chunks so the model can cite them."""
    return "\n\n".join(
        f"[{i}] (source: {d.metadata['source']})\n{d.page_content}"
        for i, d in enumerate(docs, start=1)
    )


def _parse_letter(text):
    """Pull the answer letter out of whatever the model replied."""
    match = re.search(r"\b([ABCD])\b", text.strip().upper())
    return match.group(1) if match else "?"


def evaluate(name, retriever, questions=None, workers=8):
    """Run the exam through a retriever and score it.

    Two numbers, and the gap between them is the interesting part:

      retrieval  did the right document come back at all?  (free, no model calls)
      accuracy   did the model then pick the right letter? (one call per question)

    High retrieval with low accuracy means the chunks were there and the model
    could not use them. Low retrieval caps accuracy no matter how good the model is.
    """
    questions = questions or load_questions()
    prompt = ChatPromptTemplate.from_messages(
        [("system", MCQ_SYSTEM), ("human", "{question}")]
    )
    # Note there is no retriever in this chain. We retrieve once, below, and
    # feed the same chunks to both the scor  prompt = ChatPromptTemplate.from_messages(e and the prompt — piping the
    # retriever in here would run it a second time per question, which doubles
    # the work and lets the two numbers describe different retrievals.
    chain = prompt | get_llm(max_tokens=1000) | StrOutputParser()

    start = time.perf_counter()

    # Phase 1 — retrieve, one at a time. Retrieval is CPU-bound, and the
    # cross-encoder reranker is not thread-safe: running it across threads is
    # both slower (they fight over the same ONNX session) and prone to crashing
    # on exit. Threads do not speed up work that is already saturating a core.
    retrieved_docs = [retriever.invoke(item["question"]) for item in questions]

    # Phase 2 — ask the model, concurrently. This one IS worth parallelising:
    # it is a network round-trip, so the threads spend their time waiting.
    def answer_one(pair):
        item, docs = pair
        try:
            reply = chain.invoke(
                {"context": format_docs(docs), "question": format_question(item)}
            )
            letter = _parse_letter(reply)
        except Exception:
            letter = "?"
        found = {d.metadata.get("source") for d in docs}
        return {
            "type": item["type"],
            "correct": 1.0 if letter == item["answer"] else 0.0,
            # Every gold document, not just one of them — a `combine` question
            # whose answer needs two is not served by finding one.
            "retrieved": 1.0 if set(item["gold_docs"]) <= found else 0.0,
            "chars": sum(len(d.page_content) for d in docs),
        }

    with ThreadPoolExecutor(max_workers=workers) as pool:
        results = list(pool.map(answer_one, zip(questions, retrieved_docs)))
    elapsed = time.perf_counter() - start

    by_type = {}
    for kind in ["simple", "complex", "combine"]:
        rows = [r for r in results if r["type"] == kind]
        by_type[kind] = sum(r["correct"] for r in rows) / len(rows) if rows else 0.0

    n = len(results)
    return {
        "variant": name,
        "accuracy": sum(r["correct"] for r in results) / n,
        "retrieval": sum(r["retrieved"] for r in results) / n,
        "tokens": sum(r["chars"] for r in results) / n / 4,  # ~4 chars per token
        "seconds": elapsed,
        "n": n,
        "by_type": by_type,
    }


def table(rows):
    """Markdown comparison table, everything relative to the first row."""
    base = rows[0]
    out = [
        "| variant | accuracy | simple | complex | combine | retrieval | tokens | vs baseline |",
        "|---|---|---|---|---|---|---|---|",
    ]
    for r in rows:
        delta = (
            "-"
            if r is base
            else f"{(r['accuracy'] - base['accuracy']) / max(base['accuracy'], 1e-9):+.0%} accuracy"
        )
        out.append(
            f"| {r['variant']} | **{r['accuracy']:.2f}** | "
            f"{r['by_type']['simple']:.2f} | {r['by_type']['complex']:.2f} | "
            f"{r['by_type']['combine']:.2f} | {r['retrieval']:.2f} | "
            f"{r['tokens']:.0f} | {delta} |"
        )
    return "\n".join(out)


def summary(result):
    return (
        f"{result['variant']}: accuracy {result['accuracy']:.2f} "
        f"({result['n']} questions, {result['seconds']:.0f}s) · "
        f"retrieval {result['retrieval']:.2f} · {result['tokens']:.0f} context tokens"
    )


# ---------------------------------------------------------------------------
# Printing. You cannot debug retrieval you cannot see.
# ---------------------------------------------------------------------------

def show_docs(docs, width=110):
    for i, d in enumerate(docs, start=1):
        flag = "  [ARCHIVED]" if d.metadata.get("status") == "archived" else ""
        text = " ".join(d.page_content.split())[:width]
        print(f"[{i}] {d.metadata.get('source')}{flag}\n    {text}...\n")


def show_exam():
    questions = load_questions()
    print(f"{len(questions)} questions: {dict(Counter(q['type'] for q in questions))}\n")
    print(format_question(questions[0]))
    print(f"answer: {questions[0]['answer']}")
