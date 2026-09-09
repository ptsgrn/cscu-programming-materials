"""
Lab 4, Part 1 — starter file.

Plain RAG. Nothing clever, nothing tuned.

  ingest  files -> split -> embed -> vector store
  query   question -> embed -> search -> chunks -> prompt -> LLM -> answer

What is already here:
  - the model call and the embedding model (lab_utils.py)
  - the corpus, the printing, and the 100-question exam

What is NOT here, and is your job:
  - the splitter
  - the index and the retriever
  - the prompt
  - the chain

First: paste today's key — it is in the LMS — into .env as COURSE_API_KEY.
Same endpoint as Lab 3. A 401 means fetch today's.

Then run it before you write anything:   python src/part1_basic_rag.py
It stops at the first TODO. Fill it in, run again, repeat.

At the end it sits a 100-question exam. Write the score down — it is the only
thing Part 2 has to beat.
"""

from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnablePassthrough

import lab_utils

CHUNK_SIZE = 800
CHUNK_OVERLAP = 120

TOP_K = 4

SYSTEM_PROMPT = (
    "You answer questions about an internal knowledge base.\n"
    "Rules:\n"
    # TODO 4: the rules. Answer only from the context, cite as [1] [2],
    #         and refuse with exactly:
    #         I don't have enough information in the provided context.
    "Answer only using the given text (grounding) — without this rule, the model answers from its own training instead, and you're no longer testing your retrieval."
    "Cite sources like [1], [2] (attribution) — without this, nobody can check the answer, and you can't debug it."
    "Give one exact sentence when it doesn't know (abstention) — without this, the model just makes something up. A fixed sentence also makes \"I don't know\" easy to check automatically."
    "If you don't have enough information in the provided context, say exactly: I don't have enough information in the provided context."
    "\n\n"
    "Context:\n{context}"
)


# ---------------------------------------------------------------------------
# Ingest: files -> chunks -> vectors -> index
# ---------------------------------------------------------------------------

def load_documents():
    """A Document is text plus metadata."""
    docs = lab_utils.load_documents()
    print(f"{len(docs)} documents")
    return docs


def split_documents(docs):
    """Split on structure — paragraphs first, then lines, then sentences."""
    # TODO 1: split the documents (lab_utils.split_documents)
    chunks = lab_utils.split_documents(
        docs, chunk_size=CHUNK_SIZE, chunk_overlap=CHUNK_OVERLAP)

    sizes = [len(c.page_content) for c in chunks]
    print(f"{len(docs)} documents -> {len(chunks)} chunks "
          f"(min {min(sizes)}, avg {sum(sizes)//len(sizes)}, max {max(sizes)} chars)")
    return chunks


def build_index(chunks):
    """Embed every chunk and store it. Takes ~30 seconds."""
    # TODO 2: build the index from the chunks (lab_utils.get_vectorstore)
    vectorstore = lab_utils.get_vectorstore(chunks)
    print(f"indexed: {vectorstore._collection.count()} chunks")
    return vectorstore


# ---------------------------------------------------------------------------
# Query: retrieve -> prompt -> answer
# ---------------------------------------------------------------------------

def build_retriever(vectorstore):
    """Nearest neighbours in the embedding space. That is the whole retriever."""
    # TODO 3: turn the store into a retriever returning TOP_K chunks
    retriever = vectorstore.as_retriever(search_kwargs={"k": TOP_K})
    return retriever


def format_docs(docs):
    """Number the chunks so the model can cite them.

    Whatever this returns is pasted into the prompt as text.
    """
    # TODO 5: one string, chunks numbered [1] [2] with their source
    formatted = ""
    for i, doc in enumerate(docs, start=1):
        formatted += f"[{i}] {doc.page_content} (source: {doc.metadata.get('source', 'unknown')})\n"
    return formatted.strip()


def build_chain(retriever):
    """LCEL pipes the stages with `|`. Read it left to right."""
    prompt = ChatPromptTemplate.from_messages([
        ("system", SYSTEM_PROMPT),
        ("human", "{question}"),
    ])
    # TODO 6: retrieve -> format_docs -> prompt -> lab_utils.get_llm()
    #         -> StrOutputParser()
    return (
        {"context": retriever | format_docs, "question": RunnablePassthrough()}
        | prompt
        | lab_utils.get_llm()
        | StrOutputParser()
    )


def ask(chain, retriever, question):
    """One question, with the chunks that produced it."""
    print(f"\nQ: {question}\n")
    lab_utils.show_docs(retriever.invoke(question))
    print(f"A: {chain.invoke(question)}")


# ---------------------------------------------------------------------------
# Score it
# ---------------------------------------------------------------------------

def evaluate(retriever):
    """100 multiple-choice questions, scored on the letter the model picks.

    Multiple choice because it is exactly checkable — no LLM judge, no
    argument about whether an answer was close enough.
    """
    # TODO 7: score the retriever on the exam (lab_utils.evaluate)
    result = lab_utils.evaluate("part1_basic_rag", retriever)
    print("\n" + lab_utils.table([result]))
    return result


def main():
    docs = load_documents()
    chunks = split_documents(docs)
    vectorstore = build_index(chunks)

    retriever = build_retriever(vectorstore)
    chain = build_chain(retriever)

    ask(chain, retriever, "Which robot should I use in a freezer and why?")

    print("\n" + "=" * 70)
    evaluate(retriever)


if __name__ == "__main__":
    main()
