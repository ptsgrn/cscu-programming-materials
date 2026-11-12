#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(int argc, char *argv[])
{                                        // Initialize the child number
  int N = argc > 1 ? atoi(argv[1]) : 10; // Default to 10 children if no argument is provided
  pid_t pid;

  for (int i = 0; i < N; i++)
  {
    pid = fork();
    if (pid < 0)
    {
      perror("Fork failed");
      return 1;
    }
    else if (pid == 0)
    {
      // simulate some work in the child process
      // sleep(rand() % 5 + 1);
      printf("I'm the child process number %d (pid %d)\n", i, (int)getpid());
      exit(0);
    }
  }

  for (int i = 0; i < N; i++)
  {
    wait(NULL);
  }

  printf("Parent terminates (pid %d)\n", getpid());

  return 0;
}