#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
    
long counter = 0;


pthread_mutex_t lock;
sem_t sem;



void* increment(void* arg) {
    for (long i = 0; i < 1000000; i++) {
        sem_wait(&sem);
        //pthread_mutex_lock(&lock);
        counter++;
        

        //pthread_mutex_unlock(&lock);
    }
    return NULL;
}
    
int main() {
        
        
        
        //pthread_mutex_init(&lock , NULL);
        
        
        sem_init(&sem, 0, 1);
        pthread_t t1, t2;
        pthread_create(&t1, NULL, increment, NULL);
        pthread_create(&t2, NULL, increment, NULL);
        
        
        
        
    
        pthread_join(t1, NULL);
        pthread_join(t2, NULL);
        
        
        
        //pthread_mutex_destroy(&lock);
        sem_destroy(&sem);
        printf("Final counter value: %ld\n", counter);
        return 0;
}
