#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>


#define NUM_THREADS 10
#define INCREMENTS_PER_THREAD 1000000
int counter = 0;
int j;



void* increment_counter(void* arg) {
          int* local_counter = (int*)arg  ;
          *local_counter = 0;
          for (int i = 0; i < INCREMENTS_PER_THREAD; i++) 
          {
              (*local_counter)++;
          }
          return NULL;
}


int main() {


          pthread_t my_thread[NUM_THREADS];
          int local_counters[NUM_THREADS]; 
     
      
   
          for ( j = 0; j < NUM_THREADS; j++) {
              pthread_create(&my_thread[j], NULL, increment_counter, &local_counters[j]);
          }
      
    
          for ( j = 0; j < NUM_THREADS; j++) {
              pthread_join(my_thread[j], NULL);
          }
  
          for ( j = 0; j < NUM_THREADS; j++) {
                    counter += local_counters[j];
          }
      
          printf("Expected counter value: %d\n", NUM_THREADS * INCREMENTS_PER_THREAD);
          printf("Actual counter value:   %d\n", counter);
      
          return 0;
      }



