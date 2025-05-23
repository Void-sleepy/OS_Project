#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(void) {
  void *addr = mmap(0, 4096, PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
  
  printf("mmap returned %p\n", addr);
  exit(0);
}