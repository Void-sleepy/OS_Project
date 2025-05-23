struct stat;



// system calls
int fork(void);
int exit(int) __attribute__((noreturn));
int wait(int*);
int pipe(int*);
int write(int, const void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(const char*, char**);
int open(const char*, int);
int mknod(const char*, short, short);
int unlink(const char*);
int fstat(int fd, struct stat*);
int link(const char*, const char*);
int mkdir(const char*);
int chdir(const char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);

// ulib.c
int stat(const char*, struct stat*);
char* strcpy(char*, const char*);
void *memmove(void*, const void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void fprintf(int, const char*, ...) __attribute__ ((format (printf, 2, 3)));
void printf(const char*, ...) __attribute__ ((format (printf, 1, 2)));
char* gets(char*, int max);
uint strlen(const char*);
void* memset(void*, int, uint);
int atoi(const char*);
int memcmp(const void *, const void *, uint);
void *memcpy(void *, const void *, uint);

// umalloc.c
void* malloc(uint);
void free(void*);


//////////

int trace(int);
int stats(void);

struct timeval {
  long tv_sec;   // seconds since Unix epoch
  long tv_usec;  // microseconds
};

struct timezone {
  int tz_minuteswest; // minutes west of Greenwich
  int tz_dsttime;     // type of DST correction
};

// Memory mapping constants for mmap
#define PROT_NONE  0x0    // no permissions
#define PROT_READ  0x1    // read permission
#define PROT_WRITE 0x2    // write permission
#define PROT_EXEC  0x4    // execute permission

#define MAP_SHARED    0x01  // shared mapping
#define MAP_PRIVATE   0x02  // private mapping
#define MAP_ANONYMOUS 0x20  // anonymous mapping

// Socket constants
#define AF_INET    2    // IPv4
#define AF_UNIX    1    // Unix domain sockets

#define SOCK_STREAM 1   // TCP
#define SOCK_DGRAM  2   // UDP

int socket(int domain, int type, int protocol);
int gettimeofday(struct timeval *tv, struct timezone *tz);
void* mmap(void *addr, int length, int prot, int flags, int fd, int offset);