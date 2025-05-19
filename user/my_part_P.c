#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include <String.h>



// decode for print  "plls send help "

void sys_print() {


}




//  Rread Null string from user "emty"
int read_string(struct proc *p, uint64 addr, char *buf, int max) {
  
  if(addr >= p->sz)
  {
    return -1; }

  int n = 0;

  while(n < max) {
    if(copyin(p->pagetable, buf + n, addr + n, 1) == -1) {
      
      break;
    }

    if(buf[n] == '\0'){
      break;
    }

    n++;
  }

  if(n < max){

    buf[n] = '\0';

	} else {

    buf[max-1] = '\0';

	}	

  return n;

}


// 