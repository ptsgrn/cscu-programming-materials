"""tool.py: the team's program. Runs on the server, where the workbooks are.

The agent calls it as   ./wall <command> [arguments]   and receives exactly what this file prints to
standard output. Standard error stays on the server (the Operator reads it with team/errors).

Shipped with two commands. Everything else is the team's design.

    shape <file>              sheet names, sizes and header names of one workbook
    ask <file> "<question>"   hand the first sheet of the workbook to the local model and print its words
"""
import sys

import inside


def cmd_shape(file):
    for name, df in inside.load(file).items():
        print(f"{name}: {len(df)} rows x {len(df.columns)} columns; headers: {list(df.columns)}")


def cmd_ask(file, question):
    sheets = inside.load(file)
    name, df = next(iter(sheets.items()))
    answer = inside.ask_model(
        "You answer questions about a spreadsheet.",
        f"This is sheet '{name}' of {file}:\n\n{inside.sheet_text(df)}\n\nQuestion: {question}",
    )
    print(answer)


def main(argv):
    if len(argv) >= 2 and argv[0] == "shape":
        cmd_shape(argv[1])
    elif len(argv) >= 3 and argv[0] == "ask":
        cmd_ask(argv[1], " ".join(argv[2:]))
    else:
        print("usage: shape <file> | ask <file> \"<question>\"")
        sys.exit(2)


if __name__ == "__main__":
    main(sys.argv[1:])
