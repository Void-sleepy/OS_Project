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

static uint64
argraw(int n)
{
  struct proc *p = myproc();
  switch (n) {
  case 0:
    return p->trapframe->a0;
  case 1:
    return p->trapframe->a1;
  case 2:
    return p->trapframe->a2;
  case 3:
    return p->trapframe->a3;
  case 4:
    return p->trapframe->a4;
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
  *ip = argraw(n);
}

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
  *ip = argraw(n);
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

// An array mapping syscall numbers from syscall.h
// to the function that handles the system call.
static uint64 (*syscalls[])(void) = {
[SYS_fork]    sys_fork,
[SYS_exit]    sys_exit,
[SYS_wait]    sys_wait,
[SYS_pipe]    sys_pipe,
[SYS_read]    sys_read,
[SYS_kill]    sys_kill,
[SYS_exec]    sys_exec,
[SYS_fstat]   sys_fstat,
[SYS_chdir]   sys_chdir,
[SYS_dup]     sys_dup,
[SYS_getpid]  sys_getpid,
[SYS_sbrk]    sys_sbrk,
[SYS_sleep]   sys_sleep,
[SYS_uptime]  sys_uptime,
[SYS_open]    sys_open,
[SYS_write]   sys_write,
[SYS_mknod]   sys_mknod,
[SYS_unlink]  sys_unlink,
[SYS_link]    sys_link,
[SYS_mkdir]   sys_mkdir,
[SYS_close]   sys_close,
[SYS_stats]   sys_stats, // NEW: Added for statistics system call
};

//////////////////////////////////////////////////////////////////////////////////////

static char *syscall_names[] = {
  [SYS_fork]    = "fork",
  [SYS_exit]    = "exit",
  [SYS_wait]    = "wait",
  [SYS_pipe]    = "pipe",
  [SYS_read]    = "read",
  [SYS_kill]    = "kill",
  [SYS_exec]    = "exec",
  [SYS_fstat]   = "fstat",
  [SYS_chdir]   = "chdir",
  [SYS_dup]     = "dup",
  [SYS_getpid]  = "getpid",
  [SYS_sbrk]    = "sbrk",
  [SYS_sleep]   = "sleep",
  [SYS_uptime]  = "uptime",
  [SYS_open]    = "open",
  [SYS_write]   = "write",
  [SYS_mknod]   = "mknod",
  [SYS_unlink]  = "unlink",
  [SYS_link]    = "link",
  [SYS_mkdir]   = "mkdir",
  [SYS_close]   = "close",
  [SYS_trace]   = "trace",

  [SYS_close]   = "close",
  [SYS_trace]   = "trace",
  [SYS_lseek]   = "lseek",
  [SYS_stats]   = "stats", // NEW: Added for statistics system call
};

////////////////////////////////////////////////////////////////////////////////////////////

//[                                                                    ]//
int read_string(struct proc *p, uint64 addr, char *buf, int max);
int read_memory(struct proc *p, uint64 addr, char *buf, int n);
void print_syscall(struct proc *p, int num, uint64 ret);
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

// NEW: System call to print statistics
uint64 sys_stats(void) {
    for (int i = 0; i < NELEM(syscall_names); i++) {
        if (syscall_counts[i] && syscall_names[i]) {
            printf("%s: %ld calls\n", syscall_names[i], syscall_counts[i]);
        }
    }
    return 0;
}


void syscall(void)
{
    int num;
    struct proc *p = myproc();
    num = p->trapframe->a7;
    if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
        uint64 ret = syscalls[num]();
        p->trapframe->a0 = ret;
        if(p->trace_mask & (1 << num)) {
            print_syscall(p, num, ret);
        }
    } else {
        printf("%d: unknown sys call %d\n", p->pid, num);
        p->trapframe->a0 = -1;
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
void print_syscall(struct proc *p, int num, uint64 ret) {
    printf("%d: %s(", p->pid, syscall_names[num]);
    switch (num) {
    case SYS_open: {
        char filename[64];
        if (read_string(p, p->trapframe->a0, filename, sizeof(filename)) >= 0) {
            printf("\"%s\"", filename);
        } else {
            printf("0x%lx", p->trapframe->a0);
        }
        printf(", %ld, 0%o", p->trapframe->a1, p->trapframe->a2); // CHANGED: Added mode
        break;
    }
    case SYS_read: {
        printf("%ld, 0x%lx, %ld", p->trapframe->a0, p->trapframe->a1, p->trapframe->a2);
        if ((int)ret > 0 && (int)ret <= 32) {
            char buf[33];
            if (read_memory(p, p->trapframe->a1, buf, ret) >= 0) {
                buf[ret] = '\0';
                int is_string = 1;
                for (int i = 0; i < ret; i++) {
                    if (buf[i] < 32 || buf[i] > 126) {
                        is_string = 0;
                        break;
                    }
                }
                if (is_string) printf(" → \"%s\"", buf);
                else printf(" → 0x%lx", p->trapframe->a1); // CHANGED: Added fallback
            } else {
                printf(" → 0x%lx", p->trapframe->a1); // CHANGED: Added fallback
            }
        }
        break;
    }
    case SYS_write: {
        printf("%ld, ", p->trapframe->a0);
        char buf[33];
        int n = p->trapframe->a2 > 32 ? 32 : p->trapframe->a2;
        if (read_memory(p, p->trapframe->a1, buf, n) >= 0) {
            buf[n] = '\0';
            printf("\"%s\"", buf);
            if (n < p->trapframe->a2) printf("...");
        } else {
            printf("0x%lx", p->trapframe->a1);
        }
        printf(", %ld", p->trapframe->a2);
        break;
    }
    default:
        break;
    }
    printf(") = %ld\n", ret); // CHANGED: Aligned with strace format
}


// System call dispatcher with statistics
void syscall(void) {
    int num;
    struct proc *p = myproc();
    num = p->trapframe->a7;
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
        syscall_counts[num]++; // NEW: Increment counter
        uint64 ret = syscalls[num]();
        p->trapframe->a0 = ret;
        if (p->trace_mask & (1 << num)) {
            print_syscall(p, num, ret);
        }
    } else {
        printf("%d: unknown sys call %d\n", p->pid, num);
        p->trapframe->a0 = -1;
    }
}


///////////////////////////////////////////////////////////////////////////////
