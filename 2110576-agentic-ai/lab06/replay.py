"""Replay chat_log.jsonl against the gateway to measure tokens and seconds per message.

Run:  python replay.py        (writes chat_log2.jsonl, prints a summary)

Per log line:
  - has "model"                      -> replay with that model
  - no "model", reply "You said:..." -> echo-bot era; copied with model null, no tokens
  - no "model", any other reply      -> it was qwen3.5; tagged and replayed with qwen3.5
Each output line keeps the original fields, plus model, tokens_in, tokens_out,
replay_reply, replay_seconds, replay_error, and model_stats (the aggregate for that
line's model, repeated on every line). chat_log.jsonl is only read, never written.

  python replay.py --stats-only    recompute model_stats in chat_log2.jsonl, no API calls
"""
import json
import statistics
import sys
import time

from bot import ask

SRC, DST = "chat_log.jsonl", "chat_log2.jsonl"
DEFAULT_MODEL = "qwen3.5"


def pick_model(rec):
    if rec.get("model"):
        return rec["model"]
    if rec["reply"].startswith("You said:"):
        return None
    return DEFAULT_MODEL


def replay(rec):
    out = dict(rec, model=pick_model(rec), tokens_in=None, tokens_out=None,
               replay_reply=None, replay_seconds=None, replay_error=None)
    if out["model"] is None:
        return out
    start = time.time()
    try:
        answer, usage = ask(rec["message"], out["model"])
        out["replay_reply"] = answer
        out["tokens_in"] = usage.get("prompt_tokens")
        out["tokens_out"] = usage.get("completion_tokens")
    except Exception as e:
        out["replay_error"] = str(e)
    out["replay_seconds"] = round(time.time() - start, 1)
    return out


def stats(label, values):
    values = [v for v in values if v is not None]
    if not values:
        return "  %-26s n/a" % label
    return "  %-26s median %.1f  mean %.1f  max %.1f  (n=%d)" % (
        label, statistics.median(values), statistics.mean(values), max(values), len(values))


def aggregate(values):
    values = [v for v in values if v is not None]
    if not values:
        return None
    return {"median": round(statistics.median(values), 1),
            "mean": round(statistics.mean(values), 1), "max": max(values), "n": len(values)}


def add_model_stats(rows):
    for model in {r["model"] for r in rows if r["model"]}:
        mine = [r for r in rows if r["model"] == model]
        ok = [r for r in mine if not r["replay_error"]]
        stat = {"replayed": len(mine), "failed": len(mine) - len(ok),
                "seconds": aggregate([r["replay_seconds"] for r in ok]),
                "tokens_in": aggregate([r["tokens_in"] for r in ok]),
                "tokens_out": aggregate([r["tokens_out"] for r in ok])}
        for r in mine:
            r["model_stats"] = stat
    for r in rows:
        r.setdefault("model_stats", None)


def write_rows(rows):
    with open(DST, "w", encoding="utf-8") as f:
        for r in rows:
            f.write(json.dumps(r, ensure_ascii=False) + "\n")


def summarize(rows):
    for model in sorted({r["model"] for r in rows if r["model"]}):
        mine = [r for r in rows if r["model"] == model]
        ok = [r for r in mine if not r["replay_error"]]
        print("\n%s: %d replayed, %d failed" % (model, len(mine), len(mine) - len(ok)))
        print(stats("seconds per reply", [r["replay_seconds"] for r in ok]))
        print(stats("tokens in per message", [r["tokens_in"] for r in ok]))
        print(stats("tokens out per reply", [r["tokens_out"] for r in ok]))
        errors = [r["replay_error"] for r in mine if r["replay_error"]]
        for e in sorted(set(errors)):
            print("  error x%d: %s" % (errors.count(e), e))


def main():
    if "--stats-only" in sys.argv:
        with open(DST, encoding="utf-8") as f:
            rows = [json.loads(line) for line in f if line.strip()]
        add_model_stats(rows)
        write_rows(rows)
        summarize(rows)
        return
    with open(SRC, encoding="utf-8") as f:
        records = [json.loads(line) for line in f if line.strip()]
    rows = []
    with open(DST, "w", encoding="utf-8") as f:
        for i, rec in enumerate(records, 1):
            row = replay(rec)
            rows.append(row)
            f.write(json.dumps(row, ensure_ascii=False) + "\n")
            f.flush()
            print("%2d/%d %-12s in=%s out=%s %ss %s" % (
                i, len(records), row["model"], row["tokens_in"], row["tokens_out"],
                row["replay_seconds"], row["replay_error"] or ""), flush=True)
    add_model_stats(rows)
    write_rows(rows)
    summarize(rows)


if __name__ == "__main__":
    main()
