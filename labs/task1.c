#include  <stdio.h>
#include <stdlib.h>
#include <unistd.h>


int main(){


  pid_t pid = fork(); 
  

    for (int i = 1; i < 4; i++) {
        pid = fork();
        if (pid < 0) {
            perror("Fork failed");
            exit(1);
        }


        if (pid == 0) {
            printf("child process with PID: %d, created in iteration %d\n", getpid(), getpid());
            printf("waaaa \n");

        }
        else{
            printf("parent process with PID: %d, created in iteration %d\n", getpid(), getpid());
            break;
        }
    }



  return 0;
}
