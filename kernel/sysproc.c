#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}




/////////////////////////////////////////////////////////////


extern uint64 syscall_counts[];
extern char *syscall_names[];



uint64 sys_trace(void) {
  struct proc *p = myproc();  // Fixed: use pointer, not struct
  int mask;
  if (argint(0, &mask) < 0) return -1;  // Fixed: argint returns void
  p->trace_mask = mask;
  return 0;
}



uint64 sys_stats(void) {
  struct proc *p = myproc();  
  
  #ifndef NSYSCALL
  #define NSYSCALL 23  // Adjust this to match your syscall count
  #endif
  
  for (int i = 0; i < NSYSCALL; i++) {  // Fixed: use NSYSCALL instead of SOL_SYSCALL
    if (syscall_counts[i] > 0) {
      printf("%s: %ld calls\n", syscall_names[i] ? syscall_names[i] : "unknown", syscall_counts[i]);  // Fixed: use %ld for uint64
    }
  }
  return 0;
}


uint64
sys_socket(void)
{
  int domain, type, protocol;
  
  argint(0, &domain);
  argint(1, &type);
  argint(2, &protocol);

  return -1;
}

struct timeval {
  long tv_sec;   // seconds
  long tv_usec;  // microseconds
};

struct timezone {
  int tz_minuteswest; // minutes west of Greenwich
  int tz_dsttime;     // type of DST correction
};

uint64
sys_gettimeofday(void)
{
  uint64 tv_addr, tz_addr;
  struct timeval tv;
  
  argaddr(0, &tv_addr);
  argaddr(1, &tz_addr);
  
  // Get current ticks and convert to time
  // This is a simple implementation using system ticks
  uint64 ticks = r_time(); // or use uptime() function
  tv.tv_sec = ticks / 1000000; // assuming ticks are in microseconds
  tv.tv_usec = ticks % 1000000;
  
  if(tv_addr != 0) {
    if(copyout(myproc()->pagetable, tv_addr, (char*)&tv, sizeof(tv)) < 0)
      return -1;
  }
  
  // timezone is optional, usually set to NULL
  if(tz_addr != 0) {
    struct timezone tz = {0, 0};
    if(copyout(myproc()->pagetable, tz_addr, (char*)&tz, sizeof(tz)) < 0)
      return -1;
  }
  
  return 0;
}

uint64
sys_mmap(void)
{
  uint64 addr;
  int length, prot, flags, fd, offset;
  
  argaddr(0, &addr);
  argint(1, &length);
  argint(2, &prot);
  argint(3, &flags);
  argint(4, &fd);
  argint(5, &offset);
  
  // For now, just allocate memory using sbrk-like mechanism
  // A full implementation would handle file mapping, permissions, etc.
  struct proc *p = myproc();
  
  // Simple implementation: just extend process memory
  if(length <= 0)
    return -1;
    
  uint64 old_sz = p->sz;
  if((p->sz = uvmalloc(p->pagetable, p->sz, p->sz + length, PTE_W|PTE_R|PTE_U)) == 0) {
    return -1;
  }
  
  return old_sz; // return the starting address of mapped region
}