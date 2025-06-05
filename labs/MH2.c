#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <unistd.h>

#define SHM_SIZE 1024



struct user {

    int x;
    char name[5];
};

int main() {
    key_t key = ftok("shmfile", 65);  // Generate the same key
    int shmid = shmget(key, SHM_SIZE, 0666);  // Get shared memory

    if (shmid == -1) {
        perror("shmget failed");
        exit(1);
    }
    
  //========================================================
  

    struct user *shm_ptr = (struct user *)shmat(shmid, NULL, 0);  // Attach shared memory

    if (shm_ptr == (void *)-1) {
        perror("shmat failed");
        exit(1);
    }

    printf("Data read from shared memory:\n");
    printf("Value: %d\n", shm_ptr->x);
    printf("Name: %s\n", shm_ptr->name);

  
    shmdt(shm_ptr);  // Detach shared memory
    shmctl(shmid, IPC_RMID, NULL);  // Destroy shared memory

    return 0;
}

