#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"



int main(void) {
  
  int fd = socket(AF_INET, SOCK_STREAM, 0);
  
  printf("socket returned %d\n", fd);
  exit(0);
}