import sys
import threading

from bot import handle

TIMEOUT_SECONDS = 60


def main():
    question = input("Enter your question: ")
    # Daemon thread, so a hung gateway call cannot keep the process alive after the timeout.
    worker = threading.Thread(target=handle, daemon=True, args=([{
        "type": "message",
        "message": {"type": "text", "text": question},
        "source": {"userId": "DEBUG"},
        "replyToken": "DEBUG",
    }],), kwargs={"reply": lambda _token, answer: print(answer)})
    worker.start()
    worker.join(TIMEOUT_SECONDS)
    if worker.is_alive():
        print("(timeout: no answer after %d seconds)" % TIMEOUT_SECONDS, file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
