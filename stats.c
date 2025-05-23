#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
  if (argc != 1) {
    printf("Usage: stats\n");
    exit(1);
  }

  if (stats() < 0) {
    printf("stats failed\n");
    exit(1);
  }

  exit(0);
}
