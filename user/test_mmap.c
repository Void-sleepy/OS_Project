#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(void) {
  // Simple mmap test
  void *addr = mmap(0, 4096, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
  if (addr == (void*)-1) {
    printf("mmap failed\n");
    exit(1);
  }
  
  printf("mmap succeeded, address: %p\n", addr);
  
  // Try to write to the mapped memory
  char *ptr = (char*)addr;
  ptr[0] = 'H';
  ptr[1] = 'i';
  ptr[2] = '\0';
  
  printf("Wrote to mapped memory: %s\n", ptr);
  
  exit(0);
}