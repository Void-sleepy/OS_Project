#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int main(int ac, char **av) {
    int fds[2];
    int a = 10;
    int b = 6;
    int summm;

    pipe(fds); 

    if (fork() == 0) {  
    
        close(fds[1]);
        read(fds[0], &a, sizeof(int));  
        read(fds[0], &b, sizeof(int));  

        summm = a + b;
        printf("\nChild Process: %d\n", summm);
        
        exit(0);  
    } else {  
    
        close(fds[0]);

        write(fds[1], &a, sizeof(int));  
        write(fds[1], &b, sizeof(int));  

        exit(0);  
    }
}
