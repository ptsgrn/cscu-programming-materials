#define _DEFAULT_SOURCE // for fork(), sigaction(), localtime_r() under -std=c99

#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define PORT 8888

/** Reap finished children so they don't become zombies. */
static void sigchld_handler(int sig)
{
  (void)sig;
  int saved_errno = errno;
  while (waitpid(-1, NULL, WNOHANG) > 0)
    ;
  errno = saved_errno;
}

/** Child process: send the current date/time to the client every second. */
static void serve_client(int sock, struct sockaddr_in *peer)
{
  char buffer[1024] = {0};
  char ip[INET_ADDRSTRLEN];
  inet_ntop(AF_INET, &peer->sin_addr, ip, sizeof(ip));
  int port = ntohs(peer->sin_port);

  // read the client's greeting
  ssize_t valread = read(sock, buffer, sizeof(buffer) - 1);
  if (valread > 0)
  {
    printf("[pid %d] %s:%d says: %s\n", getpid(), ip, port, buffer);
    fflush(stdout);
  }

  for (;;)
  {
    time_t now = time(NULL);
    struct tm tm;
    localtime_r(&now, &tm);

    char msg[64];
    size_t len = strftime(msg, sizeof(msg), "%Y-%m-%d %H:%M:%S\n", &tm);

    // MSG_NOSIGNAL: don't get killed by SIGPIPE when the client leaves
    if (send(sock, msg, len, MSG_NOSIGNAL) < 0)
      break;
    sleep(1);
  }

  printf("[pid %d] %s:%d disconnected\n", getpid(), ip, port);
  close(sock);
}

/** https://www.geeksforgeeks.org/c/socket-programming-cc/ */
int main(void)
{
  int server_fd, new_socket;
  struct sockaddr_in address, client_addr;
  int opt = 1;
  socklen_t addrlen;

  // Creating socket file descriptor
  if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
  {
    perror("socket failed");
    exit(EXIT_FAILURE);
  }

  if (setsockopt(server_fd, SOL_SOCKET,
                 SO_REUSEADDR | SO_REUSEPORT, &opt,
                 sizeof(opt)))
  {
    perror("setsockopt");
    exit(EXIT_FAILURE);
  }
  memset(&address, 0, sizeof(address));
  address.sin_family = AF_INET;
  address.sin_addr.s_addr = INADDR_ANY;
  address.sin_port = htons(PORT);

  if (bind(server_fd, (struct sockaddr *)&address,
           sizeof(address)) < 0)
  {
    perror("bind failed");
    exit(EXIT_FAILURE);
  }
  if (listen(server_fd, 10) < 0)
  {
    perror("listen");
    exit(EXIT_FAILURE);
  }

  // install SIGCHLD handler to reap child processes
  struct sigaction sa;
  memset(&sa, 0, sizeof(sa));
  sa.sa_handler = sigchld_handler;
  sigemptyset(&sa.sa_mask);
  sa.sa_flags = SA_RESTART;
  if (sigaction(SIGCHLD, &sa, NULL) < 0)
  {
    perror("sigaction");
    exit(EXIT_FAILURE);
  }

  printf("Server listening on port %d\n", PORT);
  fflush(stdout);

  while (1)
  {
    addrlen = sizeof(client_addr);
    if ((new_socket = accept(server_fd, (struct sockaddr *)&client_addr,
                             &addrlen)) < 0)
    {
      if (errno == EINTR)
        continue;
      perror("accept");
      continue;
    }

    pid_t pid = fork();
    if (pid < 0)
    {
      perror("fork");
      close(new_socket);
      continue;
    }
    if (pid == 0)
    {
      // child: doesn't need the listening socket
      close(server_fd);
      serve_client(new_socket, &client_addr);
      exit(EXIT_SUCCESS);
    }

    // parent: child owns the connection now
    close(new_socket);
  }
}
