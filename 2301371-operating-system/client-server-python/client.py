import os
import socket
import sys

HOST = "127.0.0.1"
PORT = 8888


def main():
    try:
        client = socket.create_connection((HOST, PORT))
    except OSError:
        print("\nConnection Failed")
        return 1

    client.sendall(b"Hello from client")
    print("Hello message sent", flush=True)

    # keep printing whatever the server sends (date/time every second)
    # until the server closes the connection
    pid = os.getpid()
    while data := client.recv(1024):
        print(f"[pid {pid}] {data.decode()}", end="", flush=True)

    client.close()
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.exit(0)
