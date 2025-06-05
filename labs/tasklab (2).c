#include "kernel/types.h"
#include "user/user.h"

int main(int ac , char **av){

  int fds[2];
  int a = 3;
  int b = 6;
  int sum , n;
  pipe(fds)
  
  write(fds[1], &a , 4);
  write(fds[1], &b , 4);
  
   n = read(fds[0], &a, 4);
  n = n + read(fds[0], &a, 4);
  
  printf("\n %d \n",n)
  
  
  
  
  
  
    exit(0);  
}

