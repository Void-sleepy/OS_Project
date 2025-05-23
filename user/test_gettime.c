#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(void) {
  struct timeval tv;
  struct timezone tz;
  int ret = gettimeofday(&tv, &tz);
  printf("gettimeofday returned %d\n", ret);
  exit(0);
}