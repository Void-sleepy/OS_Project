#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "syscall.h"
#include "defs.h"


// Fetch the uint64 at addr from the current process.
int
fetchaddr(uint64 addr, uint64 *ip)
{
  struct proc *p = myproc();
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    return -1;
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    return -1;
  return 0;
}

// Fetch the nul-terminated string at addr from the current process.
// Returns length of string, not including nul, or -1 for error.
int
fetchstr(uint64 addr, char *buf, int max)
{
  struct proc *p = myproc();
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    return -1;
  return strlen(buf);
}

static void
argraw(int n, uint64 *ip)
{
  struct proc *p = myproc();
  printf("argraw: n=%d, proc=%p, trapframe=%p\n", n, p, p ? p->trapframe : 0);
  if (p == 0 || p->trapframe == 0) {
    panic("argraw: invalid proc or trapframe");
  }
  if (n < 0 || n > 5) {
    panic("argraw: invalid n");
  }
  switch (n) {
    case 0: *ip = p->trapframe->a0; break;
    case 1: *ip = p->trapframe->a1; break;
    case 2: *ip = p->trapframe->a2; break;
    case 3: *ip = p->trapframe->a3; break;
    case 4: *ip = p->trapframe->a4; break;
    case 5: *ip = p->trapframe->a5; break;
  }
}

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
  uint64 val;
  argraw(n, &val);
  *ip = (int)val;
}

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    argraw(n, ip);
}

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
}

// Prototypes for the functions that handle system calls.
extern uint64 sys_fork(void);
extern uint64 sys_exit(void);
extern uint64 sys_wait(void);
extern uint64 sys_pipe(void);
extern uint64 sys_read(void);
extern uint64 sys_kill(void);
extern uint64 sys_exec(void);
extern uint64 sys_fstat(void);
extern uint64 sys_chdir(void);
extern uint64 sys_dup(void);
extern uint64 sys_getpid(void);
extern uint64 sys_sbrk(void);
extern uint64 sys_sleep(void);
extern uint64 sys_uptime(void);
extern uint64 sys_open(void);
extern uint64 sys_write(void);
extern uint64 sys_mknod(void);
extern uint64 sys_unlink(void);
extern uint64 sys_link(void);
extern uint64 sys_mkdir(void);
extern uint64 sys_close(void);
/////////////////////////////////
extern uint64 sys_trace(void);
extern uint64 sys_stats(void);

extern uint64 sys_socket(void);
extern uint64 sys_gettime(void);
extern uint64 sys_mmap(void);

// An array mapping syscall numbers from syscall.h
// to the function that handles the system call.
static uint64 (*syscalls[])(void) = {
[SYS_fork]        sys_fork,
[SYS_exit]        sys_exit,
[SYS_wait]        sys_wait,
[SYS_pipe]        sys_pipe,
[SYS_read]        sys_read,
[SYS_kill]        sys_kill,
[SYS_exec]        sys_exec,
[SYS_fstat]       sys_fstat,
[SYS_chdir]       sys_chdir,
[SYS_dup]         sys_dup,
[SYS_getpid]      sys_getpid,
[SYS_sbrk]        sys_sbrk,
[SYS_sleep]       sys_sleep,
[SYS_uptime]      sys_uptime,
[SYS_open]        sys_open,
[SYS_write]       sys_write,
[SYS_mknod]       sys_mknod,
[SYS_unlink]      sys_unlink,
[SYS_link]        sys_link,
[SYS_mkdir]       sys_mkdir,
[SYS_close]       sys_close,
[SYS_trace]       sys_trace,
[SYS_stats]       sys_stats,
[SYS_socket]      sys_socket,
[SYS_gettime]     sys_gettime,
[SYS_mmap]        sys_mmap,
};
//////////////////////////////////////////////////////////////////////////////////////

static int syscall_counts[NELEM(syscalls)] = {0};


///////////////////////////////////////////////////////////////
static char *syscall_names[] = {
  [SYS_fork]    "fork",
  [SYS_exit]    "exit",
  [SYS_wait]    "wait",
  [SYS_pipe]    "pipe",
  [SYS_read]    "read",
  [SYS_kill]    "kill",
  [SYS_exec]    "exec",
  [SYS_fstat]   "fstat",
  [SYS_chdir]   "chdir",
  [SYS_dup]     "dup",
  [SYS_getpid]  "getpid",
  [SYS_sbrk]    "sbrk",
  [SYS_sleep]   "sleep",
  [SYS_uptime]  "uptime",
  [SYS_open]    "open",
  [SYS_write]   "write",
  [SYS_mknod]   "mknod",
  [SYS_unlink]  "unlink",
  [SYS_link]    "link",
  [SYS_mkdir]   "mkdir",
  [SYS_close]   "close",
  [SYS_trace]   "trace",      // Your added system calls
  [SYS_stats]   "stats",
  [SYS_socket]  "socket",
  [SYS_gettime] "gettime",
  [SYS_mmap]    "mmap",
};


// argument types: 'i' for integer, 'a' for address, 0 for none    [waaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa ]
static char argtypes[][3] = {
  [SYS_fork]    {0, 0, 0},
  [SYS_exit]    {'i', 0, 0},
  [SYS_wait]    {0, 0, 0},
  [SYS_pipe]    {'a', 0, 0},
  [SYS_read]    {'i', 'a', 'i'},
  [SYS_kill]    {'i', 0, 0},
  [SYS_exec]    {'a', 'a', 0},
  [SYS_fstat]   {'i', 'a', 0},
  [SYS_chdir]   {'a', 0, 0},
  [SYS_dup]     {'i', 0, 0},
  [SYS_getpid]  {0, 0, 0},
  [SYS_sbrk]    {'i', 0, 0},
  [SYS_sleep]   {'i', 0, 0},
  [SYS_uptime]  {0, 0, 0},
  [SYS_open]    {'a', 'i', 'i'},
  [SYS_write]   {'i', 'a', 'i'},
  [SYS_mknod]   {'a', 'i', 'i'},
  [SYS_unlink]  {'a', 0, 0},
  [SYS_link]    {'a', 'a', 0},
  [SYS_mkdir]   {'a', 0, 0},
  [SYS_close]   {'i', 0, 0},
  [SYS_trace]   {'i', 0, 0},
  [SYS_stats]   {0, 0, 0},
  [SYS_socket]  {'i', 'i', 'i'},
  [SYS_gettime] {'a', 'a', 0},
  [SYS_mmap]    {'a', 'i', 'i'},
};





uint64 sys_gettime(void) {
  uint64 tv_addr, tz_addr;
  argaddr(0, &tv_addr);
  argaddr(1, &tz_addr);
  return -1;
}

uint64 sys_stats(void) {
  for (int i = 0; i < NELEM(syscalls); i++) {
    if (syscall_counts[i] > 0) {
      printf("%s: %d calls\n", syscall_names[i] ? syscall_names[i] : "unknown", syscall_counts[i]);
    }
  }
  return 0;
}

uint64 sys_socket(void) {
  int domain, type, protocol;
  argint(0, &domain);
  argint(1, &type);
  argint(2, &protocol);
  return -1;
}



uint64 sys_mmap(void) {
  uint64 addr;
  int length, prot, flags, fd, offset;
  argaddr(0, &addr);
  argint(1, &length);
  argint(2, &prot);
  argint(3, &flags);
  argint(4, &fd);
  argint(5, &offset);
  return -1;
}


////////////////////////////////////////////////////////////////////////////////////////////

//[                                                                    ]//
int read_string(struct proc *p, uint64 addr, char *buf, int max);
int read_memory(struct proc *p, uint64 addr, char *buf, int n);
void print_syscall(struct proc *p, int num, uint64 args[], uint64 ret);

//[                                                                    ]//


////////////[OLD SYS CALL ]/////////////////////////////////////////////////////
/*
void
syscall(void)
{
  int num;
  struct proc *p = myproc();

  num = p->trapframe->a7;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
  } else {
    printf("%d %s: unknown sys call %d\n",
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
  }
}

*/

////////////////[New sys call  the "coooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooler one" ]////////////////////////////////////////////
// System call dispatcher with statistics
void
syscall(void)
{
  int num = myproc()->trapframe->a7;
  printf("syscall: num=%d\n", num);
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    myproc()->trapframe->a0 = syscalls[num]();
  } else {
    printf("unknown sys call %d\n", num);
    myproc()->trapframe->a0 = -1;
  }
}

///////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////
// Read null-terminated string from user space
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

////////////////////////////////////////////////////////////////////////////////////////////////////
// Read arbitrary memory from user space
int read_memory(struct proc *p, uint64 addr, char *buf, int n) {

  if(addr >= p->sz || addr + n > p->sz)
    return -1;

  if(copyin(p->pagetable, buf, addr, n) == -1)
    return -1;

  return n;
}

//////////////////////////////////////////////////////////////


// Print system call details (enhanced for open's mode)
void print_syscall(struct proc *p, int num, uint64 args[], uint64 ret) {
  if (p->trace_mask & (1 << num)) {
    printf("1: %s(", syscall_names[num] ? syscall_names[num] : "unknown");
    for (int i = 0; i < 3 && argtypes[num][i]; i++) {
      if (i > 0) printf(", ");
      if (argtypes[num][i] == 'i') printf("%d", (int)args[i]);
      else if (argtypes[num][i] == 'a') printf("0x%lx", args[i]);
      else printf("?");
    }
    printf(") = %ld\n", ret);
  }
  syscall_counts[num]++;
}
///////////////////////////////////////////////////////////////////////////////
