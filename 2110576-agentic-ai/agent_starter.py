"""
Lab 3 — starter file.

What is already here:
  - the model call (talks to the course endpoint)
  - argument plumbing and the transcript printer

What is NOT here, and is your job:
  - the tools
  - the loop
  - the stopping condition
  - the system prompt

First: paste today's key — it is in the LMS — where this file says
PASTE-TODAYS-KEY. Yesterday's key is dead by design; a 401 means fetch today's.

Then run it, before you write anything:   python agent_starter.py "hello"
You should get a reply. If you don't, that's an environment problem — raise a hand.
"""

import argparse
import json
import os
from pathlib import Path

from openai import OpenAI

# ---------------------------------------------------------------------------
# The model. Paste today's key (from the LMS) below, or export COURSE_API_KEY.
# Nothing else here needs to change.
# ---------------------------------------------------------------------------

MODEL = os.environ.get("COURSE_MODEL", "qwen3.5")

client = OpenAI(
    base_url=os.environ.get("COURSE_BASE_URL", "http://161.200.93.57:4000/v1"),
    api_key=os.environ.get("COURSE_API_KEY", ""),
)


def call_model(messages, tools=None):
    """One request to the model. Returns the raw message object.

    `messages` is the whole conversation so far. Note that word: the whole
    conversation. Every time. The model is not remembering anything between
    calls — you are re-sending it. Look at what you pass here after five
    turns and you will understand something about how this works.
    """
    response = client.chat.completions.create(
        model=MODEL,
        messages=messages,
        tools=tools or None,
        temperature=0.0,
    )
    return response.choices[0].message


# ---------------------------------------------------------------------------
# Transcript printing. Use it. You cannot debug a loop you cannot see.
# ---------------------------------------------------------------------------

def show(step, kind, detail):
    detail = str(detail).replace("\n", " ")
    if len(detail) > 300:
        detail = detail[:300] + f"... [{len(detail)} chars total]"
    print(f"[{step:>2}] {kind:<12} {detail}")


# ---------------------------------------------------------------------------
# YOUR TOOLS GO HERE.
#
# A tool is two things that must agree with each other:
#   1. a Python function that does something
#   2. a description the model reads, to decide whether to call it
#
# If those two disagree, nothing will tell you. Nothing will error.
# ---------------------------------------------------------------------------

TOOLS = [
    {
        "type": "function",
        "function": {
            "name": "read_sheet",
            "description": "Read data from a xlsx sheet file. The sheet is relative to current directory.",
            "parameters": {
                "type": "object",
                "properties": {"path": {"type": "string", "description": "The path of the xlsx file to read"},
                               "sheet": {"type": "string", "description": "The name of the sheet to read (optional); list available sheets if not specified"}},
                "required": ["path"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "list_files",
            "description": "List files in a directory.",
            "parameters": {
                "type": "object",
                "properties": {"path": {"type": "string", "description": "The path of the directory to list"}},
                "required": ["path"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "run_python",
            "description": "Run a Python snippet and return the output as a string.",
            "parameters": {
                "type": "object",
                "properties": {"code": {"type": "string", "description": "The Python code to execute"}},
                "required": ["code"],
            },
        },
    },
]


def run_tool(name, arguments):
    """Execute one tool call and return a string.

    A string. Not a DataFrame, not a dict, not an object. Whatever this
    returns gets appended to the conversation as text and sent back to the
    model. That constraint is not an inconvenience of this starter file —
    it is the shape of the thing you are building.
    """
    # An unknown tool raises here, then agent() turns it into a tool error.
    if name not in TOOL_FUNCTIONS:
        raise ValueError(f"Tool not found: {name}")
    return TOOL_FUNCTIONS[name](**arguments)


def list_tools():
    """Return a string listing the tools available to the model."""
    return "\n".join(f"- {t['function']['name']}: {t['function']['description']}" for t in TOOLS)


def read_sheet(path: str, sheet: str = None):
    """Read data from a xlsx sheet file. The sheet is relative to current directory."""
    import pandas as pd

    if not os.path.exists(path):
        return f"Error: File '{path}' does not exist."

    if sheet is None:
        # List sheets names if no sheet is specified
        xls = pd.ExcelFile(path)
        return f"Available sheets in '{path}': {', '.join(xls.sheet_names)}"

    # Read the specified sheet
    try:
        df = pd.read_excel(path, sheet_name=sheet)
        return df.to_string(index=False)
    except ValueError as e:
        return f"Error: {str(e)}"


def list_files(path: str):
    """List files in a directory."""
    path = Path(path)
    if not path.exists():
        return f"Error: Directory '{path}' does not exist."
    if not path.is_dir():
        return f"Error: '{path}' is not a directory."
    files = [f.name for f in path.iterdir() if f.is_file()]
    return "\n".join(files) if files else "No files found."


def run_python(code: str):
    """Run a Python snippet and return the output as a string."""
    import io
    import sys

    # Capture stdout and stderr
    old_stdout = sys.stdout
    old_stderr = sys.stderr
    sys.stdout = io.StringIO()
    sys.stderr = io.StringIO()

    try:
        exec(code, globals())
        output = sys.stdout.getvalue()
        error = sys.stderr.getvalue()
        if error:
            return f"Error: {error}"
        return output if output else "No output."
    except Exception as e:
        return f"Exception: {str(e)}"
    finally:
        # Restore stdout and stderr
        sys.stdout = old_stdout
        sys.stderr = old_stderr


TOOL_FUNCTIONS = {
    "read_sheet": read_sheet,
    "list_files": list_files,
    "run_python": run_python,
}


# ---------------------------------------------------------------------------
# YOUR SYSTEM PROMPT GOES HERE.
#
# In Lab 2 you measured this and could not read it. Now you write it.
# ---------------------------------------------------------------------------


SYSTEM_PROMPT = f"""You're a helpful assistant. You can call tools to get information or perform actions. Use the tools wisely and provide clear responses to the user.

Tools available:
{list_tools()}
"""
print("SYSTEM PROMPT:" + SYSTEM_PROMPT)


# ---------------------------------------------------------------------------
# YOUR LOOP GOES HERE.
#
# Send. Get a reply. If the reply asks for a tool, run it, append the result,
# send again. If it doesn't, you're done.
#
# Four questions the loop cannot avoid answering. Write your answer to each
# in a comment next to the line that decides it:
#   - what tells you the loop is finished?
#   - what is the maximum number of times round?
#   - what happens when a tool raises?
#   - what happens when the model asks for a tool that doesn't exist?
# ---------------------------------------------------------------------------


def agent(task):
    messages = [
        {"role": "system", "content": SYSTEM_PROMPT},
        {"role": "user", "content": task},
    ]

    max_tool_hops = 10
    max_model_rounds = max_tool_hops + 1

    # At most 11 rounds: 10 tool hops plus one forced final-answer round.
    for step in range(1, max_model_rounds + 1):
        # Keep tools available until the safety cap; then force a final answer.
        available_tools = TOOLS if step <= max_tool_hops else None
        reply = call_model(messages, available_tools)
        messages.append(reply.model_dump(exclude_none=True))

        tool_calls = reply.tool_calls or []
        if tool_calls:
            show(step, "model", f"requested {len(tool_calls)} tool(s)")
        else:
            show(step, "model", reply.content or "(empty response)")

        # Finished means the model replied without requesting another tool.
        if not tool_calls:
            return reply.content or "The model returned no answer."

        # At the safety cap, do not execute another tool request.
        if step > max_tool_hops:
            return reply.content or f"Stopped after reaching the {max_tool_hops}-tool-hop limit."

        for tool_call in tool_calls:
            name = tool_call.function.name
            raw_arguments = tool_call.function.arguments
            show(step, "tool call", f"{name}({raw_arguments})")

            try:
                arguments = json.loads(raw_arguments)
                if not isinstance(arguments, dict):
                    raise ValueError("tool arguments must be a JSON object")
                result = str(run_tool(name, arguments))
            # A raised exception becomes tool-result text for the final answer.
            except Exception as exc:
                result = f"Error: {type(exc).__name__}: {exc}"

            show(step, "tool result", result)
            messages.append(
                {
                    "role": "tool",
                    "tool_call_id": tool_call.id,
                    "content": result,
                }
            )

    return f"Stopped after reaching the {max_tool_hops}-tool-hop limit."


# ---------------------------------------------------------------------------


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("task", help="what to ask the agent")
    args = parser.parse_args()

    if not TOOL_FUNCTIONS:
        # Smoke test path, so you can confirm the endpoint works before
        # you have written anything. Delete this once you have tools.
        reply = call_model([{"role": "user", "content": args.task}])
        print(reply.content)
        return

    answer = agent(args.task)
    print("\n" + "=" * 70)
    print(answer)


if __name__ == "__main__":
    main()
