#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <string.h>
#include <unistd.h>

#define SHM_SIZE 1024

struct usea {

    int v;
    char name[5];
};


int main() {
    
    key_t key = ftok("shmfile", 65);  // Generate unique key
    int shmid = shmget(key, SHM_SIZE, 0666 | IPC_CREAT);  // Create shared memory

    if (shmid == -1) {
        perror("shmget failed");
        exit(1);
    }

      struct usea *test  = (struct usea *)shmat(shmid, NULL, 0);  // Attach shared memory
       
      if (test == (void *)-1) {  // pointer vs in is no no
        perror("shmat failed");
        exit(1);
    }

    printf("Enter a value: ");
    scanf("%d", &test->v);
    getchar(); 
    printf("Enter a litter max 3: ");
    fgets(test->name, sizeof(test->name), stdin);
    
    
    
    printf("V: %d\n", test->v);
    printf("Name: %s\n", test->name);
    

// ====================================================================

    shmdt(test);  // Detach shared memory

    return 0;
}

