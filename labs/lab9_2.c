#include <stdlib.h>
#include <stdio.h>

void memory_leak_example() {
    for (int i = 0; i < 1000; i++) {
        int* leak = (int*)malloc(1000 * sizeof(int)); // Not freed!

          free(leak);
    }
}

void fragmentation_example() {
    void* ptrs[1000];
    for (int i = 0; i < 1000; i++) {
        ptrs[i] = malloc(1000);

    }

//add you code here resolve the memory leakage issue
    for (int i = 0; i < 1000; i++)
    { 
            free(ptrs[i]);
    }
}

int main() {
    memory_leak_example();
    fragmentation_example();
    printf("Memory leak and fragmentation simulated.\n");
    return 0;
}

