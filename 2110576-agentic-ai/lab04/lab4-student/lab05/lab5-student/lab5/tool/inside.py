"""inside.py: the helper shipped with the starter. Two things: load a workbook, call the local model.

This file runs on the server, inside the wall, where the workbooks and the model key are. The Operator
may change it (push it with team/push together with tool.py). Nothing here decides what leaves the
server; that is tool.py's job.
"""
import json
import os
import sys
import time
import urllib.error
import urllib.request

import pandas as pd

DATA_DIR = os.environ.get("DATA_DIR", ".")
MODEL = os.environ.get("QWEN_MODEL", "qwen3.5")


def path(file):
    """The workbook's path on the server. Bare file names only, like toi18.xlsx."""
    name = os.path.basename(file)
    if not name.endswith(".xlsx"):
        raise ValueError(f"not a workbook name: {file}")
    p = os.path.join(DATA_DIR, name)
    if not os.path.exists(p):
        raise FileNotFoundError(f"no such workbook on the server: {name}")
    return p


def load(file):
    """All sheets of one workbook, as a dict of sheet name -> DataFrame (first row taken as the header)."""
    return pd.read_excel(path(file), sheet_name=None)


def sheet_text(df):
    """A sheet rendered as text, for handing to the model."""
    return df.to_csv(index=False)


def ask_model(system, user, max_tokens=4096, temperature=0.2, **extra):
    """One call to the local model through the gateway. Returns the model's text.

    The gateway serves the model in reasoning mode: its thinking counts against max_tokens, so a small
    budget can come back as an empty string. Extra keyword arguments are added to the request body
    unchanged; chat_template_kwargs={"enable_thinking": False} switches the thinking off, which makes a
    short structured answer many times faster and cheaper. A line about tokens and time goes to stderr
    for the Operator (team/errors), never to stdout.
    """
    base = os.environ.get("QWEN_BASE_URL", "").rstrip("/")
    key = os.environ.get("QWEN_API_KEY", "")
    if not base or not key:
        raise RuntimeError("the server has no model credentials (QWEN_BASE_URL / QWEN_API_KEY)")
    payload = {"model": MODEL, "messages": [{"role": "system", "content": system}, {"role": "user", "content": user}],
               "max_tokens": max_tokens, "temperature": temperature, **extra}
    req = urllib.request.Request(base + "/chat/completions", data=json.dumps(payload).encode("utf-8"),
                                 headers={"Authorization": f"Bearer {key}", "Content-Type": "application/json"}, method="POST")
    t0 = time.time()
    try:
        with urllib.request.urlopen(req, timeout=110) as resp:
            body = json.load(resp)
    except urllib.error.HTTPError as e:
        raise RuntimeError(f"model gateway HTTP {e.code}: {e.read().decode(errors='replace')[:300]}") from None
    except urllib.error.URLError as e:
        raise RuntimeError(f"could not reach the model gateway: {e.reason}") from None
    choice = body["choices"][0]
    usage = body.get("usage", {})
    print(f"[inside] model call: prompt_tokens={usage.get('prompt_tokens')} completion_tokens={usage.get('completion_tokens')} "
          f"finish={choice.get('finish_reason')} {time.time() - t0:.1f}s", file=sys.stderr)
    return (choice["message"].get("content") or "").strip()
