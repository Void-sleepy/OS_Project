#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

#define SIZE 1000000

int main() {
    int *arr = malloc(SIZE * sizeof(int));
    int global_max = 0;
    int *aa_m = malloc(SIZE * sizeof(int));
    
    
    for (int i = 0; i < SIZE; i++) {
        arr[i] = rand() % 1000000;
    }

    int i;
    
    
    #pragma omp parallel
    {
        int local_max = 0;

        #pragma omp for
        for (i = 0; i < SIZE; i++) {
            if (arr[i] > local_max) {
                local_max = arr[i];
            }
        }
        // ========================================================
        
        
        
        
        // Combine local max to global max safely
         // #pragma omp critical
         
         
         
        for (i = 0; i < SIZE; i++) {
            if (local_max > global_max) {
                aa_m[i] = local_max;
            }

        }
                    printf("%d\n" ,aa_m[SIZE - 1]);
        }
          
    
    
    
  


    free(arr);
    free(aa_m);
    return 0;
}
