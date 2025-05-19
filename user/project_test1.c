#include "kernel/types.h"
#include "user/user.h"


int main() {
  trace(0x7); 
  int fd = open("test.txt", 0);
  if (fd < 0) {
    printf("open failed\n");
    return 1;
  }
  char buf[100];
  int n = read(fd, buf, 100);
  write(1, buf, n);
  close(fd);
  stats();
  return 0;
}
