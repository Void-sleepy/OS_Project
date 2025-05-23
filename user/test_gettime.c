#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(void) {
  struct timeval tv;
  struct timezone tz;
  int ret = gettime(&tv, &tz);
  printf("gettimeofday returned %d\n", ret);
  exit(0);
}