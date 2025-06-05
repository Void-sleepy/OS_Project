
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>

int main() {

    int* x = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, 
                  MAP_SHARED | MAP_ANONYMOUS, -1, 0);
    *x = 100;


    pid_t pid = fork();
    if (pid == 0) {
      *x =200;
        printf("Child: x = %d\n", *x);
    } else {
        sleep(1);
        printf("Parent: x = %d\n", *x);
    }


    munmap(x, sizeof(int));
    return 0;
}


