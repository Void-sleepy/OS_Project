#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define SIZE 10000000

int main() {
    int* array = malloc(SIZE * sizeof(int));
        clock_t start, end;

    start = clock();
    for (int i = SIZE - 1; i >= 0; i -= 1) {
    		array[i] += 1;

    		}
    		end = clock();
    	printf("Random access time: %f seconds\n", (double)(end - start) / CLOCKS_PER_SEC);


    free(array);
    return 0;
}


