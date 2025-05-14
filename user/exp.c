#include "kernel/types.h"
#include "user/user.h"

int a[3] = {1,2,3};
char b[3] = {'a','b','c'};

char *c[3]= {"test1","test2","test3"};

int main(int ac , char **av){

  printf("%d\n",a[0]);
  printf("%d\n",b[0]);
  printf("%s\n",c[0]);


  a[1] +=1;
  printf("%d\n",a[1]);
  return 0;
}
