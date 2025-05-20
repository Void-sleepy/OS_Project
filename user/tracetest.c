#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  printf("Showing system call statistics:\n");
  
  getpid();
  sleep(1);
  fork();
  wait(0);
  
  stats();
  
  exit(0);
}
