import os
import signal
import socket
import sys
import time

HOST = ""  # INADDR_ANY
PORT = 8888


def reap_children(signum, frame):
    """Reap finished children so they don't become zombies."""
    while True:
        try:
            pid, _ = os.waitpid(-1, os.WNOHANG)
        except ChildProcessError:
            return
        if pid == 0:
            return


def serve_client(conn: socket.socket, addr):
    """Child process: send the current date/time to the client every second."""
    ip, port = addr
    pid = os.getpid()

    # read the client's greeting
    data = conn.recv(1024)
    if data:
        print(f"[pid {pid}] {ip}:{port} says: {data.decode()}", flush=True)

    try:
        while True:
            now = time.strftime("%Y-%m-%d %H:%M:%S\n")
            conn.sendall(now.encode())
            time.sleep(1)
    except (BrokenPipeError, ConnectionResetError):
        pass

    print(f"[pid {pid}] {ip}:{port} disconnected", flush=True)
    conn.close()


def main():
    signal.signal(signal.SIGCHLD, reap_children)

    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEPORT, 1)
    server.bind((HOST, PORT))
    server.listen(10)
    print(f"Server listening on port {PORT}", flush=True)

    while True:
        # Python retries accept() automatically when interrupted by SIGCHLD
        conn, addr = server.accept()

        pid = os.fork()
        if pid == 0:
            # child: doesn't need the listening socket
            server.close()
            serve_client(conn, addr)
            os._exit(0)

        # parent: child owns the connection now
        conn.close()


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(0)
