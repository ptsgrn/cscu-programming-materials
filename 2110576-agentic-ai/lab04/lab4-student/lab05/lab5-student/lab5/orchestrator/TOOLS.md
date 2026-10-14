# Tools

Two commands. Both are shell scripts in this folder, both talk to the server, and nothing
else in this folder can. Run them exactly as written. The project settings deny you
`python`, `curl`, `wget` and the `team/` and `tool/` folders, and the workbooks are not on this machine,
so there is no other route to the data.

| Command | What it does |
|---|---|
| `./workload-index` | Prints the twelve file names, one per line. Nothing else. |
| `./wall <command> [arguments]` | Sends the command and its arguments to the server, which runs the team's tool, `tool.py`, with them and sends back what the tool printed. One run per call. Two minutes maximum per run. |

## What the tool accepts

`tool.py` is the team's program. The Operator changes it during the lab, so the commands
below are what the tool accepted when this file was shipped. The current commands and what
they return are in `CLAUDE.md`, the agent's rules file, which the Scribe keeps current. If
the two disagree, `CLAUDE.md` wins.

As shipped:

| Call | Prints |
|---|---|
| `./wall shape toi18.xlsx` | the sheet names in that workbook, and for each sheet its size and its header names |
| `./wall ask toi18.xlsx "<question>"` | the local model's answer to the question, given a sheet of that workbook chosen by the tool |

## What a reply is

Whatever the tool printed to standard output, as text. If the tool failed, the reply is a
one-line error, not a traceback; the traceback stayed on the server, where the Operator can
read it. An empty reply is a reply.

## What you do not get

The rows. The file. A way to read the file yourself. A way to change `tool.py`: the Operator
edits it, in another session, on another laptop.
