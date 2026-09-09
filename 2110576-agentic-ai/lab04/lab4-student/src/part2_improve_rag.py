"""
Lab 4, Part 2 — starter file.

Same exam, same index, same 100 questions. The only thing that changes is the
retriever, one step at a time.

What is already here:
  - the scoring and the comparison table
  - the experiments, in the order to run them

What is NOT here, and is your job:
  - the retrievers each experiment measures

Run:  python src/part2_improve_rag.py   (after part1 has built the index)

One of these changes will make your score WORSE. Do not delete that row.
Working out why is the point of the afternoon.
"""

from langchain_classic.retrievers import ContextualCompressionRetriever, EnsembleRetriever
from langchain_community.document_compressors import FlashrankRerank
from langchain_community.retrievers import BM25Retriever

import lab_utils
from part1_basic_rag import TOP_K, build_retriever

RERANK_MODEL = "ms-marco-MiniLM-L-12-v2"
WIDE_K = 10          # candidates fetched before reranking
KEEP = 3             # how many survive into the prompt


# ---------------------------------------------------------------------------
# Retrievers. Each is one hypothesis about what limits Part 1.
# ---------------------------------------------------------------------------

def bm25_retriever(chunks, k):
    """Exact term matching — should catch ERR-5521 where embeddings fail."""
    retriever = BM25Retriever.from_documents(chunks)
    retriever.k = k
    return retriever


def hybrid_retriever(dense, bm25):
    """Reciprocal rank fusion — it only looks at positions."""
    return EnsembleRetriever(retrievers=[dense, bm25], weights=[0.5, 0.5])


def rerank(base_retriever, top_n):
    """A cross-encoder reads (question, chunk) together instead of separately:
    much more accurate, far too slow to run over a whole corpus. So a cheap
    retriever proposes candidates and this reorders them."""
    compressor = FlashrankRerank(model=RERANK_MODEL, top_n=top_n)
    return ContextualCompressionRetriever(
        base_compressor=compressor, base_retriever=base_retriever
    )


def current_only_retriever(vectorstore, k):
    """Same as dense, but skips superseded documents.

    Several wrong options in the exam are lifted straight out of the 2019 leave
    policy and the 2024 price list. Retrieving those documents is how you pick
    them.
    """
    return vectorstore.as_retriever(
        search_kwargs={"k": k, "filter": {"status": "current"}}
    )


# ---------------------------------------------------------------------------
# The experiments. Change one thing, measure, read the failures.
# ---------------------------------------------------------------------------

def measure_baseline(vectorstore, results):
    """Part 1's retriever, re-scored here so every row shares one table."""
    dense = build_retriever(vectorstore)
    results.append(lab_utils.evaluate("baseline (dense k=4)", dense))
    print(lab_utils.summary(results[-1]))
    return dense


def try_hybrid(dense, chunks, results):
    """Attempt #1: add keyword search. This is the standard advice."""
    hybrid = hybrid_retriever(dense, bm25_retriever(chunks, TOP_K))
    results.append(lab_utils.evaluate("+ hybrid (BM25)", hybrid))
    print(lab_utils.summary(results[-1]))


def try_rerank(vectorstore, chunks, results):
    """Attempt #2: the problem is ordering, not finding. Fetch 10, keep 3."""
    wide_dense = vectorstore.as_retriever(search_kwargs={"k": WIDE_K})
    results.append(lab_utils.evaluate("+ rerank (10 -> 3)", rerank(wide_dense, KEEP)))
    print(lab_utils.summary(results[-1]))

    # Watch the token column while you read the accuracy column. Fetching 10
    # candidates would normally cost more tokens, but the reranker discards 7
    # before the prompt. The price is latency.

    hybrid_wide = hybrid_retriever(wide_dense, bm25_retriever(chunks, WIDE_K))
    results.append(lab_utils.evaluate("+ hybrid + rerank", rerank(hybrid_wide, KEEP)))
    print(lab_utils.summary(results[-1]))


def try_metadata_filter(vectorstore, results):
    """Attempt #3: stop retrieving documents we know are out of date."""
    filtered = rerank(current_only_retriever(vectorstore, WIDE_K), KEEP)

    question = "How many annual leave days do I get?"
    print("\nwithout the filter:")
    lab_utils.show_docs(vectorstore.as_retriever(search_kwargs={"k": 3}).invoke(question))
    print("with the filter:")
    lab_utils.show_docs(filtered.invoke(question))

    results.append(lab_utils.evaluate("+ exclude archived", filtered))
    print(lab_utils.summary(results[-1]))

    return filtered


def sweep_keep(vectorstore):
    """Attempt #4: how many chunks does the prompt actually need?

    Scored on the `combine` questions only — they are the ones whose answer
    needs two documents, so they are where `keep` can actually bite. That also
    makes this sweep four times cheaper than running the full exam three times.
    """
    combine = lab_utils.load_questions(kind="combine")
    wide_dense = vectorstore.as_retriever(search_kwargs={"k": WIDE_K})

    print(f"\nsweeping `keep` on the {len(combine)} combine questions:")
    # keep=1 should hurt combine questions specifically — by definition they
    # need two or more documents, so keeping only one caps accuracy no matter
    # how good the reranker's top pick is.
    for keep in [1, 2, 3, 4, 5]:
        r = lab_utils.evaluate(f"keep={keep}", rerank(wide_dense, keep), combine)
        print(f"  keep={keep}  accuracy {r['accuracy']:.2f}  "
              f"retrieval {r['retrieval']:.2f}  {r['tokens']:.0f} tokens")


def main():
    docs = lab_utils.load_documents()
    chunks = lab_utils.split_documents(docs)
    vectorstore = lab_utils.get_vectorstore()          # index built in Part 1

    lab_utils.show_exam()
    print("=" * 70)

    results = []
    dense = measure_baseline(vectorstore, results)
    try_hybrid(dense, chunks, results)
    try_rerank(vectorstore, chunks, results)
    try_metadata_filter(vectorstore, results)
    sweep_keep(vectorstore)

    print("\n" + "=" * 70)
    print(lab_utils.table(results))


if __name__ == "__main__":
    main()
