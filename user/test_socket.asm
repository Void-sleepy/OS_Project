
user/_test_socket:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"



int main(void) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  
  int fd = socket(AF_INET, SOCK_STREAM, 0);
   8:	4601                	li	a2,0
   a:	4585                	li	a1,1
   c:	4509                	li	a0,2
   e:	32a000ef          	jal	338 <socket>
  12:	85aa                	mv	a1,a0
  
  printf("socket returned %d\n", fd);
  14:	00001517          	auipc	a0,0x1
  18:	86c50513          	addi	a0,a0,-1940 # 880 <malloc+0xfc>
  1c:	6b4000ef          	jal	6d0 <printf>
  exit(0);
  20:	4501                	li	a0,0
  22:	26e000ef          	jal	290 <exit>

0000000000000026 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  26:	1141                	addi	sp,sp,-16
  28:	e406                	sd	ra,8(sp)
  2a:	e022                	sd	s0,0(sp)
  2c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  2e:	fd3ff0ef          	jal	0 <main>
  exit(0);
  32:	4501                	li	a0,0
  34:	25c000ef          	jal	290 <exit>

0000000000000038 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  38:	1141                	addi	sp,sp,-16
  3a:	e422                	sd	s0,8(sp)
  3c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  3e:	87aa                	mv	a5,a0
  40:	0585                	addi	a1,a1,1
  42:	0785                	addi	a5,a5,1
  44:	fff5c703          	lbu	a4,-1(a1)
  48:	fee78fa3          	sb	a4,-1(a5)
  4c:	fb75                	bnez	a4,40 <strcpy+0x8>
    ;
  return os;
}
  4e:	6422                	ld	s0,8(sp)
  50:	0141                	addi	sp,sp,16
  52:	8082                	ret

0000000000000054 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  54:	1141                	addi	sp,sp,-16
  56:	e422                	sd	s0,8(sp)
  58:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  5a:	00054783          	lbu	a5,0(a0)
  5e:	cb91                	beqz	a5,72 <strcmp+0x1e>
  60:	0005c703          	lbu	a4,0(a1)
  64:	00f71763          	bne	a4,a5,72 <strcmp+0x1e>
    p++, q++;
  68:	0505                	addi	a0,a0,1
  6a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  6c:	00054783          	lbu	a5,0(a0)
  70:	fbe5                	bnez	a5,60 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  72:	0005c503          	lbu	a0,0(a1)
}
  76:	40a7853b          	subw	a0,a5,a0
  7a:	6422                	ld	s0,8(sp)
  7c:	0141                	addi	sp,sp,16
  7e:	8082                	ret

0000000000000080 <strlen>:

uint
strlen(const char *s)
{
  80:	1141                	addi	sp,sp,-16
  82:	e422                	sd	s0,8(sp)
  84:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cf91                	beqz	a5,a6 <strlen+0x26>
  8c:	0505                	addi	a0,a0,1
  8e:	87aa                	mv	a5,a0
  90:	86be                	mv	a3,a5
  92:	0785                	addi	a5,a5,1
  94:	fff7c703          	lbu	a4,-1(a5)
  98:	ff65                	bnez	a4,90 <strlen+0x10>
  9a:	40a6853b          	subw	a0,a3,a0
  9e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  a0:	6422                	ld	s0,8(sp)
  a2:	0141                	addi	sp,sp,16
  a4:	8082                	ret
  for(n = 0; s[n]; n++)
  a6:	4501                	li	a0,0
  a8:	bfe5                	j	a0 <strlen+0x20>

00000000000000aa <memset>:

void*
memset(void *dst, int c, uint n)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e422                	sd	s0,8(sp)
  ae:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  b0:	ca19                	beqz	a2,c6 <memset+0x1c>
  b2:	87aa                	mv	a5,a0
  b4:	1602                	slli	a2,a2,0x20
  b6:	9201                	srli	a2,a2,0x20
  b8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  bc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  c0:	0785                	addi	a5,a5,1
  c2:	fee79de3          	bne	a5,a4,bc <memset+0x12>
  }
  return dst;
}
  c6:	6422                	ld	s0,8(sp)
  c8:	0141                	addi	sp,sp,16
  ca:	8082                	ret

00000000000000cc <strchr>:

char*
strchr(const char *s, char c)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e422                	sd	s0,8(sp)
  d0:	0800                	addi	s0,sp,16
  for(; *s; s++)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	cb99                	beqz	a5,ec <strchr+0x20>
    if(*s == c)
  d8:	00f58763          	beq	a1,a5,e6 <strchr+0x1a>
  for(; *s; s++)
  dc:	0505                	addi	a0,a0,1
  de:	00054783          	lbu	a5,0(a0)
  e2:	fbfd                	bnez	a5,d8 <strchr+0xc>
      return (char*)s;
  return 0;
  e4:	4501                	li	a0,0
}
  e6:	6422                	ld	s0,8(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret
  return 0;
  ec:	4501                	li	a0,0
  ee:	bfe5                	j	e6 <strchr+0x1a>

00000000000000f0 <gets>:

char*
gets(char *buf, int max)
{
  f0:	711d                	addi	sp,sp,-96
  f2:	ec86                	sd	ra,88(sp)
  f4:	e8a2                	sd	s0,80(sp)
  f6:	e4a6                	sd	s1,72(sp)
  f8:	e0ca                	sd	s2,64(sp)
  fa:	fc4e                	sd	s3,56(sp)
  fc:	f852                	sd	s4,48(sp)
  fe:	f456                	sd	s5,40(sp)
 100:	f05a                	sd	s6,32(sp)
 102:	ec5e                	sd	s7,24(sp)
 104:	1080                	addi	s0,sp,96
 106:	8baa                	mv	s7,a0
 108:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 10a:	892a                	mv	s2,a0
 10c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 10e:	4aa9                	li	s5,10
 110:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 112:	89a6                	mv	s3,s1
 114:	2485                	addiw	s1,s1,1
 116:	0344d663          	bge	s1,s4,142 <gets+0x52>
    cc = read(0, &c, 1);
 11a:	4605                	li	a2,1
 11c:	faf40593          	addi	a1,s0,-81
 120:	4501                	li	a0,0
 122:	186000ef          	jal	2a8 <read>
    if(cc < 1)
 126:	00a05e63          	blez	a0,142 <gets+0x52>
    buf[i++] = c;
 12a:	faf44783          	lbu	a5,-81(s0)
 12e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 132:	01578763          	beq	a5,s5,140 <gets+0x50>
 136:	0905                	addi	s2,s2,1
 138:	fd679de3          	bne	a5,s6,112 <gets+0x22>
    buf[i++] = c;
 13c:	89a6                	mv	s3,s1
 13e:	a011                	j	142 <gets+0x52>
 140:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 142:	99de                	add	s3,s3,s7
 144:	00098023          	sb	zero,0(s3)
  return buf;
}
 148:	855e                	mv	a0,s7
 14a:	60e6                	ld	ra,88(sp)
 14c:	6446                	ld	s0,80(sp)
 14e:	64a6                	ld	s1,72(sp)
 150:	6906                	ld	s2,64(sp)
 152:	79e2                	ld	s3,56(sp)
 154:	7a42                	ld	s4,48(sp)
 156:	7aa2                	ld	s5,40(sp)
 158:	7b02                	ld	s6,32(sp)
 15a:	6be2                	ld	s7,24(sp)
 15c:	6125                	addi	sp,sp,96
 15e:	8082                	ret

0000000000000160 <stat>:

int
stat(const char *n, struct stat *st)
{
 160:	1101                	addi	sp,sp,-32
 162:	ec06                	sd	ra,24(sp)
 164:	e822                	sd	s0,16(sp)
 166:	e04a                	sd	s2,0(sp)
 168:	1000                	addi	s0,sp,32
 16a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 16c:	4581                	li	a1,0
 16e:	162000ef          	jal	2d0 <open>
  if(fd < 0)
 172:	02054263          	bltz	a0,196 <stat+0x36>
 176:	e426                	sd	s1,8(sp)
 178:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 17a:	85ca                	mv	a1,s2
 17c:	16c000ef          	jal	2e8 <fstat>
 180:	892a                	mv	s2,a0
  close(fd);
 182:	8526                	mv	a0,s1
 184:	134000ef          	jal	2b8 <close>
  return r;
 188:	64a2                	ld	s1,8(sp)
}
 18a:	854a                	mv	a0,s2
 18c:	60e2                	ld	ra,24(sp)
 18e:	6442                	ld	s0,16(sp)
 190:	6902                	ld	s2,0(sp)
 192:	6105                	addi	sp,sp,32
 194:	8082                	ret
    return -1;
 196:	597d                	li	s2,-1
 198:	bfcd                	j	18a <stat+0x2a>

000000000000019a <atoi>:

int
atoi(const char *s)
{
 19a:	1141                	addi	sp,sp,-16
 19c:	e422                	sd	s0,8(sp)
 19e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a0:	00054683          	lbu	a3,0(a0)
 1a4:	fd06879b          	addiw	a5,a3,-48
 1a8:	0ff7f793          	zext.b	a5,a5
 1ac:	4625                	li	a2,9
 1ae:	02f66863          	bltu	a2,a5,1de <atoi+0x44>
 1b2:	872a                	mv	a4,a0
  n = 0;
 1b4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1b6:	0705                	addi	a4,a4,1
 1b8:	0025179b          	slliw	a5,a0,0x2
 1bc:	9fa9                	addw	a5,a5,a0
 1be:	0017979b          	slliw	a5,a5,0x1
 1c2:	9fb5                	addw	a5,a5,a3
 1c4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1c8:	00074683          	lbu	a3,0(a4)
 1cc:	fd06879b          	addiw	a5,a3,-48
 1d0:	0ff7f793          	zext.b	a5,a5
 1d4:	fef671e3          	bgeu	a2,a5,1b6 <atoi+0x1c>
  return n;
}
 1d8:	6422                	ld	s0,8(sp)
 1da:	0141                	addi	sp,sp,16
 1dc:	8082                	ret
  n = 0;
 1de:	4501                	li	a0,0
 1e0:	bfe5                	j	1d8 <atoi+0x3e>

00000000000001e2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e2:	1141                	addi	sp,sp,-16
 1e4:	e422                	sd	s0,8(sp)
 1e6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1e8:	02b57463          	bgeu	a0,a1,210 <memmove+0x2e>
    while(n-- > 0)
 1ec:	00c05f63          	blez	a2,20a <memmove+0x28>
 1f0:	1602                	slli	a2,a2,0x20
 1f2:	9201                	srli	a2,a2,0x20
 1f4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1f8:	872a                	mv	a4,a0
      *dst++ = *src++;
 1fa:	0585                	addi	a1,a1,1
 1fc:	0705                	addi	a4,a4,1
 1fe:	fff5c683          	lbu	a3,-1(a1)
 202:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 206:	fef71ae3          	bne	a4,a5,1fa <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 20a:	6422                	ld	s0,8(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret
    dst += n;
 210:	00c50733          	add	a4,a0,a2
    src += n;
 214:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 216:	fec05ae3          	blez	a2,20a <memmove+0x28>
 21a:	fff6079b          	addiw	a5,a2,-1
 21e:	1782                	slli	a5,a5,0x20
 220:	9381                	srli	a5,a5,0x20
 222:	fff7c793          	not	a5,a5
 226:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 228:	15fd                	addi	a1,a1,-1
 22a:	177d                	addi	a4,a4,-1
 22c:	0005c683          	lbu	a3,0(a1)
 230:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 234:	fee79ae3          	bne	a5,a4,228 <memmove+0x46>
 238:	bfc9                	j	20a <memmove+0x28>

000000000000023a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 23a:	1141                	addi	sp,sp,-16
 23c:	e422                	sd	s0,8(sp)
 23e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 240:	ca05                	beqz	a2,270 <memcmp+0x36>
 242:	fff6069b          	addiw	a3,a2,-1
 246:	1682                	slli	a3,a3,0x20
 248:	9281                	srli	a3,a3,0x20
 24a:	0685                	addi	a3,a3,1
 24c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 24e:	00054783          	lbu	a5,0(a0)
 252:	0005c703          	lbu	a4,0(a1)
 256:	00e79863          	bne	a5,a4,266 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 25a:	0505                	addi	a0,a0,1
    p2++;
 25c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 25e:	fed518e3          	bne	a0,a3,24e <memcmp+0x14>
  }
  return 0;
 262:	4501                	li	a0,0
 264:	a019                	j	26a <memcmp+0x30>
      return *p1 - *p2;
 266:	40e7853b          	subw	a0,a5,a4
}
 26a:	6422                	ld	s0,8(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret
  return 0;
 270:	4501                	li	a0,0
 272:	bfe5                	j	26a <memcmp+0x30>

0000000000000274 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 274:	1141                	addi	sp,sp,-16
 276:	e406                	sd	ra,8(sp)
 278:	e022                	sd	s0,0(sp)
 27a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 27c:	f67ff0ef          	jal	1e2 <memmove>
}
 280:	60a2                	ld	ra,8(sp)
 282:	6402                	ld	s0,0(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret

0000000000000288 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 288:	4885                	li	a7,1
 ecall
 28a:	00000073          	ecall
 ret
 28e:	8082                	ret

0000000000000290 <exit>:
.global exit
exit:
 li a7, SYS_exit
 290:	4889                	li	a7,2
 ecall
 292:	00000073          	ecall
 ret
 296:	8082                	ret

0000000000000298 <wait>:
.global wait
wait:
 li a7, SYS_wait
 298:	488d                	li	a7,3
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2a0:	4891                	li	a7,4
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <read>:
.global read
read:
 li a7, SYS_read
 2a8:	4895                	li	a7,5
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <write>:
.global write
write:
 li a7, SYS_write
 2b0:	48c1                	li	a7,16
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <close>:
.global close
close:
 li a7, SYS_close
 2b8:	48d5                	li	a7,21
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2c0:	4899                	li	a7,6
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2c8:	489d                	li	a7,7
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <open>:
.global open
open:
 li a7, SYS_open
 2d0:	48bd                	li	a7,15
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2d8:	48c5                	li	a7,17
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2e0:	48c9                	li	a7,18
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2e8:	48a1                	li	a7,8
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <link>:
.global link
link:
 li a7, SYS_link
 2f0:	48cd                	li	a7,19
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2f8:	48d1                	li	a7,20
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 300:	48a5                	li	a7,9
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <dup>:
.global dup
dup:
 li a7, SYS_dup
 308:	48a9                	li	a7,10
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 310:	48ad                	li	a7,11
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 318:	48b1                	li	a7,12
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 320:	48b5                	li	a7,13
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 328:	48b9                	li	a7,14
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <trace>:
.global trace
trace:
 li a7, SYS_trace
 330:	48d9                	li	a7,22
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <socket>:
.global socket
socket:
 li a7, SYS_socket
 338:	48e1                	li	a7,24
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <gettime>:
.global gettime
gettime:
 li a7, SYS_gettime
 340:	48e5                	li	a7,25
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 348:	48e9                	li	a7,26
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <stats>:
.global stats
stats:
    li a7, SYS_stats
 350:	48dd                	li	a7,23
    ecall
 352:	00000073          	ecall
    ret
 356:	8082                	ret

0000000000000358 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 358:	1101                	addi	sp,sp,-32
 35a:	ec06                	sd	ra,24(sp)
 35c:	e822                	sd	s0,16(sp)
 35e:	1000                	addi	s0,sp,32
 360:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 364:	4605                	li	a2,1
 366:	fef40593          	addi	a1,s0,-17
 36a:	f47ff0ef          	jal	2b0 <write>
}
 36e:	60e2                	ld	ra,24(sp)
 370:	6442                	ld	s0,16(sp)
 372:	6105                	addi	sp,sp,32
 374:	8082                	ret

0000000000000376 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 376:	7139                	addi	sp,sp,-64
 378:	fc06                	sd	ra,56(sp)
 37a:	f822                	sd	s0,48(sp)
 37c:	f426                	sd	s1,40(sp)
 37e:	0080                	addi	s0,sp,64
 380:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 382:	c299                	beqz	a3,388 <printint+0x12>
 384:	0805c963          	bltz	a1,416 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 388:	2581                	sext.w	a1,a1
  neg = 0;
 38a:	4881                	li	a7,0
 38c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 390:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 392:	2601                	sext.w	a2,a2
 394:	00000517          	auipc	a0,0x0
 398:	50c50513          	addi	a0,a0,1292 # 8a0 <digits>
 39c:	883a                	mv	a6,a4
 39e:	2705                	addiw	a4,a4,1
 3a0:	02c5f7bb          	remuw	a5,a1,a2
 3a4:	1782                	slli	a5,a5,0x20
 3a6:	9381                	srli	a5,a5,0x20
 3a8:	97aa                	add	a5,a5,a0
 3aa:	0007c783          	lbu	a5,0(a5)
 3ae:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3b2:	0005879b          	sext.w	a5,a1
 3b6:	02c5d5bb          	divuw	a1,a1,a2
 3ba:	0685                	addi	a3,a3,1
 3bc:	fec7f0e3          	bgeu	a5,a2,39c <printint+0x26>
  if(neg)
 3c0:	00088c63          	beqz	a7,3d8 <printint+0x62>
    buf[i++] = '-';
 3c4:	fd070793          	addi	a5,a4,-48
 3c8:	00878733          	add	a4,a5,s0
 3cc:	02d00793          	li	a5,45
 3d0:	fef70823          	sb	a5,-16(a4)
 3d4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3d8:	02e05a63          	blez	a4,40c <printint+0x96>
 3dc:	f04a                	sd	s2,32(sp)
 3de:	ec4e                	sd	s3,24(sp)
 3e0:	fc040793          	addi	a5,s0,-64
 3e4:	00e78933          	add	s2,a5,a4
 3e8:	fff78993          	addi	s3,a5,-1
 3ec:	99ba                	add	s3,s3,a4
 3ee:	377d                	addiw	a4,a4,-1
 3f0:	1702                	slli	a4,a4,0x20
 3f2:	9301                	srli	a4,a4,0x20
 3f4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3f8:	fff94583          	lbu	a1,-1(s2)
 3fc:	8526                	mv	a0,s1
 3fe:	f5bff0ef          	jal	358 <putc>
  while(--i >= 0)
 402:	197d                	addi	s2,s2,-1
 404:	ff391ae3          	bne	s2,s3,3f8 <printint+0x82>
 408:	7902                	ld	s2,32(sp)
 40a:	69e2                	ld	s3,24(sp)
}
 40c:	70e2                	ld	ra,56(sp)
 40e:	7442                	ld	s0,48(sp)
 410:	74a2                	ld	s1,40(sp)
 412:	6121                	addi	sp,sp,64
 414:	8082                	ret
    x = -xx;
 416:	40b005bb          	negw	a1,a1
    neg = 1;
 41a:	4885                	li	a7,1
    x = -xx;
 41c:	bf85                	j	38c <printint+0x16>

000000000000041e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 41e:	711d                	addi	sp,sp,-96
 420:	ec86                	sd	ra,88(sp)
 422:	e8a2                	sd	s0,80(sp)
 424:	e0ca                	sd	s2,64(sp)
 426:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 428:	0005c903          	lbu	s2,0(a1)
 42c:	26090863          	beqz	s2,69c <vprintf+0x27e>
 430:	e4a6                	sd	s1,72(sp)
 432:	fc4e                	sd	s3,56(sp)
 434:	f852                	sd	s4,48(sp)
 436:	f456                	sd	s5,40(sp)
 438:	f05a                	sd	s6,32(sp)
 43a:	ec5e                	sd	s7,24(sp)
 43c:	e862                	sd	s8,16(sp)
 43e:	e466                	sd	s9,8(sp)
 440:	8b2a                	mv	s6,a0
 442:	8a2e                	mv	s4,a1
 444:	8bb2                	mv	s7,a2
  state = 0;
 446:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 448:	4481                	li	s1,0
 44a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 44c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 450:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 454:	06c00c93          	li	s9,108
 458:	a005                	j	478 <vprintf+0x5a>
        putc(fd, c0);
 45a:	85ca                	mv	a1,s2
 45c:	855a                	mv	a0,s6
 45e:	efbff0ef          	jal	358 <putc>
 462:	a019                	j	468 <vprintf+0x4a>
    } else if(state == '%'){
 464:	03598263          	beq	s3,s5,488 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 468:	2485                	addiw	s1,s1,1
 46a:	8726                	mv	a4,s1
 46c:	009a07b3          	add	a5,s4,s1
 470:	0007c903          	lbu	s2,0(a5)
 474:	20090c63          	beqz	s2,68c <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 478:	0009079b          	sext.w	a5,s2
    if(state == 0){
 47c:	fe0994e3          	bnez	s3,464 <vprintf+0x46>
      if(c0 == '%'){
 480:	fd579de3          	bne	a5,s5,45a <vprintf+0x3c>
        state = '%';
 484:	89be                	mv	s3,a5
 486:	b7cd                	j	468 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 488:	00ea06b3          	add	a3,s4,a4
 48c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 490:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 492:	c681                	beqz	a3,49a <vprintf+0x7c>
 494:	9752                	add	a4,a4,s4
 496:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 49a:	03878f63          	beq	a5,s8,4d8 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 49e:	05978963          	beq	a5,s9,4f0 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4a2:	07500713          	li	a4,117
 4a6:	0ee78363          	beq	a5,a4,58c <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4aa:	07800713          	li	a4,120
 4ae:	12e78563          	beq	a5,a4,5d8 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4b2:	07000713          	li	a4,112
 4b6:	14e78a63          	beq	a5,a4,60a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4ba:	07300713          	li	a4,115
 4be:	18e78a63          	beq	a5,a4,652 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4c2:	02500713          	li	a4,37
 4c6:	04e79563          	bne	a5,a4,510 <vprintf+0xf2>
        putc(fd, '%');
 4ca:	02500593          	li	a1,37
 4ce:	855a                	mv	a0,s6
 4d0:	e89ff0ef          	jal	358 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4d4:	4981                	li	s3,0
 4d6:	bf49                	j	468 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4d8:	008b8913          	addi	s2,s7,8
 4dc:	4685                	li	a3,1
 4de:	4629                	li	a2,10
 4e0:	000ba583          	lw	a1,0(s7)
 4e4:	855a                	mv	a0,s6
 4e6:	e91ff0ef          	jal	376 <printint>
 4ea:	8bca                	mv	s7,s2
      state = 0;
 4ec:	4981                	li	s3,0
 4ee:	bfad                	j	468 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4f0:	06400793          	li	a5,100
 4f4:	02f68963          	beq	a3,a5,526 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4f8:	06c00793          	li	a5,108
 4fc:	04f68263          	beq	a3,a5,540 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 500:	07500793          	li	a5,117
 504:	0af68063          	beq	a3,a5,5a4 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 508:	07800793          	li	a5,120
 50c:	0ef68263          	beq	a3,a5,5f0 <vprintf+0x1d2>
        putc(fd, '%');
 510:	02500593          	li	a1,37
 514:	855a                	mv	a0,s6
 516:	e43ff0ef          	jal	358 <putc>
        putc(fd, c0);
 51a:	85ca                	mv	a1,s2
 51c:	855a                	mv	a0,s6
 51e:	e3bff0ef          	jal	358 <putc>
      state = 0;
 522:	4981                	li	s3,0
 524:	b791                	j	468 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 526:	008b8913          	addi	s2,s7,8
 52a:	4685                	li	a3,1
 52c:	4629                	li	a2,10
 52e:	000ba583          	lw	a1,0(s7)
 532:	855a                	mv	a0,s6
 534:	e43ff0ef          	jal	376 <printint>
        i += 1;
 538:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 53a:	8bca                	mv	s7,s2
      state = 0;
 53c:	4981                	li	s3,0
        i += 1;
 53e:	b72d                	j	468 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 540:	06400793          	li	a5,100
 544:	02f60763          	beq	a2,a5,572 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 548:	07500793          	li	a5,117
 54c:	06f60963          	beq	a2,a5,5be <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 550:	07800793          	li	a5,120
 554:	faf61ee3          	bne	a2,a5,510 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 558:	008b8913          	addi	s2,s7,8
 55c:	4681                	li	a3,0
 55e:	4641                	li	a2,16
 560:	000ba583          	lw	a1,0(s7)
 564:	855a                	mv	a0,s6
 566:	e11ff0ef          	jal	376 <printint>
        i += 2;
 56a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 56c:	8bca                	mv	s7,s2
      state = 0;
 56e:	4981                	li	s3,0
        i += 2;
 570:	bde5                	j	468 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 572:	008b8913          	addi	s2,s7,8
 576:	4685                	li	a3,1
 578:	4629                	li	a2,10
 57a:	000ba583          	lw	a1,0(s7)
 57e:	855a                	mv	a0,s6
 580:	df7ff0ef          	jal	376 <printint>
        i += 2;
 584:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 586:	8bca                	mv	s7,s2
      state = 0;
 588:	4981                	li	s3,0
        i += 2;
 58a:	bdf9                	j	468 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 58c:	008b8913          	addi	s2,s7,8
 590:	4681                	li	a3,0
 592:	4629                	li	a2,10
 594:	000ba583          	lw	a1,0(s7)
 598:	855a                	mv	a0,s6
 59a:	dddff0ef          	jal	376 <printint>
 59e:	8bca                	mv	s7,s2
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	b5d9                	j	468 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a4:	008b8913          	addi	s2,s7,8
 5a8:	4681                	li	a3,0
 5aa:	4629                	li	a2,10
 5ac:	000ba583          	lw	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	dc5ff0ef          	jal	376 <printint>
        i += 1;
 5b6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b8:	8bca                	mv	s7,s2
      state = 0;
 5ba:	4981                	li	s3,0
        i += 1;
 5bc:	b575                	j	468 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5be:	008b8913          	addi	s2,s7,8
 5c2:	4681                	li	a3,0
 5c4:	4629                	li	a2,10
 5c6:	000ba583          	lw	a1,0(s7)
 5ca:	855a                	mv	a0,s6
 5cc:	dabff0ef          	jal	376 <printint>
        i += 2;
 5d0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d2:	8bca                	mv	s7,s2
      state = 0;
 5d4:	4981                	li	s3,0
        i += 2;
 5d6:	bd49                	j	468 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5d8:	008b8913          	addi	s2,s7,8
 5dc:	4681                	li	a3,0
 5de:	4641                	li	a2,16
 5e0:	000ba583          	lw	a1,0(s7)
 5e4:	855a                	mv	a0,s6
 5e6:	d91ff0ef          	jal	376 <printint>
 5ea:	8bca                	mv	s7,s2
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	bdad                	j	468 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f0:	008b8913          	addi	s2,s7,8
 5f4:	4681                	li	a3,0
 5f6:	4641                	li	a2,16
 5f8:	000ba583          	lw	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	d79ff0ef          	jal	376 <printint>
        i += 1;
 602:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 604:	8bca                	mv	s7,s2
      state = 0;
 606:	4981                	li	s3,0
        i += 1;
 608:	b585                	j	468 <vprintf+0x4a>
 60a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 60c:	008b8d13          	addi	s10,s7,8
 610:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 614:	03000593          	li	a1,48
 618:	855a                	mv	a0,s6
 61a:	d3fff0ef          	jal	358 <putc>
  putc(fd, 'x');
 61e:	07800593          	li	a1,120
 622:	855a                	mv	a0,s6
 624:	d35ff0ef          	jal	358 <putc>
 628:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 62a:	00000b97          	auipc	s7,0x0
 62e:	276b8b93          	addi	s7,s7,630 # 8a0 <digits>
 632:	03c9d793          	srli	a5,s3,0x3c
 636:	97de                	add	a5,a5,s7
 638:	0007c583          	lbu	a1,0(a5)
 63c:	855a                	mv	a0,s6
 63e:	d1bff0ef          	jal	358 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 642:	0992                	slli	s3,s3,0x4
 644:	397d                	addiw	s2,s2,-1
 646:	fe0916e3          	bnez	s2,632 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 64a:	8bea                	mv	s7,s10
      state = 0;
 64c:	4981                	li	s3,0
 64e:	6d02                	ld	s10,0(sp)
 650:	bd21                	j	468 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 652:	008b8993          	addi	s3,s7,8
 656:	000bb903          	ld	s2,0(s7)
 65a:	00090f63          	beqz	s2,678 <vprintf+0x25a>
        for(; *s; s++)
 65e:	00094583          	lbu	a1,0(s2)
 662:	c195                	beqz	a1,686 <vprintf+0x268>
          putc(fd, *s);
 664:	855a                	mv	a0,s6
 666:	cf3ff0ef          	jal	358 <putc>
        for(; *s; s++)
 66a:	0905                	addi	s2,s2,1
 66c:	00094583          	lbu	a1,0(s2)
 670:	f9f5                	bnez	a1,664 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 672:	8bce                	mv	s7,s3
      state = 0;
 674:	4981                	li	s3,0
 676:	bbcd                	j	468 <vprintf+0x4a>
          s = "(null)";
 678:	00000917          	auipc	s2,0x0
 67c:	22090913          	addi	s2,s2,544 # 898 <malloc+0x114>
        for(; *s; s++)
 680:	02800593          	li	a1,40
 684:	b7c5                	j	664 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 686:	8bce                	mv	s7,s3
      state = 0;
 688:	4981                	li	s3,0
 68a:	bbf9                	j	468 <vprintf+0x4a>
 68c:	64a6                	ld	s1,72(sp)
 68e:	79e2                	ld	s3,56(sp)
 690:	7a42                	ld	s4,48(sp)
 692:	7aa2                	ld	s5,40(sp)
 694:	7b02                	ld	s6,32(sp)
 696:	6be2                	ld	s7,24(sp)
 698:	6c42                	ld	s8,16(sp)
 69a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 69c:	60e6                	ld	ra,88(sp)
 69e:	6446                	ld	s0,80(sp)
 6a0:	6906                	ld	s2,64(sp)
 6a2:	6125                	addi	sp,sp,96
 6a4:	8082                	ret

00000000000006a6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6a6:	715d                	addi	sp,sp,-80
 6a8:	ec06                	sd	ra,24(sp)
 6aa:	e822                	sd	s0,16(sp)
 6ac:	1000                	addi	s0,sp,32
 6ae:	e010                	sd	a2,0(s0)
 6b0:	e414                	sd	a3,8(s0)
 6b2:	e818                	sd	a4,16(s0)
 6b4:	ec1c                	sd	a5,24(s0)
 6b6:	03043023          	sd	a6,32(s0)
 6ba:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6be:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6c2:	8622                	mv	a2,s0
 6c4:	d5bff0ef          	jal	41e <vprintf>
}
 6c8:	60e2                	ld	ra,24(sp)
 6ca:	6442                	ld	s0,16(sp)
 6cc:	6161                	addi	sp,sp,80
 6ce:	8082                	ret

00000000000006d0 <printf>:

void
printf(const char *fmt, ...)
{
 6d0:	711d                	addi	sp,sp,-96
 6d2:	ec06                	sd	ra,24(sp)
 6d4:	e822                	sd	s0,16(sp)
 6d6:	1000                	addi	s0,sp,32
 6d8:	e40c                	sd	a1,8(s0)
 6da:	e810                	sd	a2,16(s0)
 6dc:	ec14                	sd	a3,24(s0)
 6de:	f018                	sd	a4,32(s0)
 6e0:	f41c                	sd	a5,40(s0)
 6e2:	03043823          	sd	a6,48(s0)
 6e6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ea:	00840613          	addi	a2,s0,8
 6ee:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6f2:	85aa                	mv	a1,a0
 6f4:	4505                	li	a0,1
 6f6:	d29ff0ef          	jal	41e <vprintf>
}
 6fa:	60e2                	ld	ra,24(sp)
 6fc:	6442                	ld	s0,16(sp)
 6fe:	6125                	addi	sp,sp,96
 700:	8082                	ret

0000000000000702 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 702:	1141                	addi	sp,sp,-16
 704:	e422                	sd	s0,8(sp)
 706:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 708:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70c:	00001797          	auipc	a5,0x1
 710:	8f47b783          	ld	a5,-1804(a5) # 1000 <freep>
 714:	a02d                	j	73e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 716:	4618                	lw	a4,8(a2)
 718:	9f2d                	addw	a4,a4,a1
 71a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 71e:	6398                	ld	a4,0(a5)
 720:	6310                	ld	a2,0(a4)
 722:	a83d                	j	760 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 724:	ff852703          	lw	a4,-8(a0)
 728:	9f31                	addw	a4,a4,a2
 72a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 72c:	ff053683          	ld	a3,-16(a0)
 730:	a091                	j	774 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 732:	6398                	ld	a4,0(a5)
 734:	00e7e463          	bltu	a5,a4,73c <free+0x3a>
 738:	00e6ea63          	bltu	a3,a4,74c <free+0x4a>
{
 73c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73e:	fed7fae3          	bgeu	a5,a3,732 <free+0x30>
 742:	6398                	ld	a4,0(a5)
 744:	00e6e463          	bltu	a3,a4,74c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 748:	fee7eae3          	bltu	a5,a4,73c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 74c:	ff852583          	lw	a1,-8(a0)
 750:	6390                	ld	a2,0(a5)
 752:	02059813          	slli	a6,a1,0x20
 756:	01c85713          	srli	a4,a6,0x1c
 75a:	9736                	add	a4,a4,a3
 75c:	fae60de3          	beq	a2,a4,716 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 760:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 764:	4790                	lw	a2,8(a5)
 766:	02061593          	slli	a1,a2,0x20
 76a:	01c5d713          	srli	a4,a1,0x1c
 76e:	973e                	add	a4,a4,a5
 770:	fae68ae3          	beq	a3,a4,724 <free+0x22>
    p->s.ptr = bp->s.ptr;
 774:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 776:	00001717          	auipc	a4,0x1
 77a:	88f73523          	sd	a5,-1910(a4) # 1000 <freep>
}
 77e:	6422                	ld	s0,8(sp)
 780:	0141                	addi	sp,sp,16
 782:	8082                	ret

0000000000000784 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 784:	7139                	addi	sp,sp,-64
 786:	fc06                	sd	ra,56(sp)
 788:	f822                	sd	s0,48(sp)
 78a:	f426                	sd	s1,40(sp)
 78c:	ec4e                	sd	s3,24(sp)
 78e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 790:	02051493          	slli	s1,a0,0x20
 794:	9081                	srli	s1,s1,0x20
 796:	04bd                	addi	s1,s1,15
 798:	8091                	srli	s1,s1,0x4
 79a:	0014899b          	addiw	s3,s1,1
 79e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7a0:	00001517          	auipc	a0,0x1
 7a4:	86053503          	ld	a0,-1952(a0) # 1000 <freep>
 7a8:	c915                	beqz	a0,7dc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7aa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ac:	4798                	lw	a4,8(a5)
 7ae:	08977a63          	bgeu	a4,s1,842 <malloc+0xbe>
 7b2:	f04a                	sd	s2,32(sp)
 7b4:	e852                	sd	s4,16(sp)
 7b6:	e456                	sd	s5,8(sp)
 7b8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7ba:	8a4e                	mv	s4,s3
 7bc:	0009871b          	sext.w	a4,s3
 7c0:	6685                	lui	a3,0x1
 7c2:	00d77363          	bgeu	a4,a3,7c8 <malloc+0x44>
 7c6:	6a05                	lui	s4,0x1
 7c8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7cc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7d0:	00001917          	auipc	s2,0x1
 7d4:	83090913          	addi	s2,s2,-2000 # 1000 <freep>
  if(p == (char*)-1)
 7d8:	5afd                	li	s5,-1
 7da:	a081                	j	81a <malloc+0x96>
 7dc:	f04a                	sd	s2,32(sp)
 7de:	e852                	sd	s4,16(sp)
 7e0:	e456                	sd	s5,8(sp)
 7e2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7e4:	00001797          	auipc	a5,0x1
 7e8:	82c78793          	addi	a5,a5,-2004 # 1010 <base>
 7ec:	00001717          	auipc	a4,0x1
 7f0:	80f73a23          	sd	a5,-2028(a4) # 1000 <freep>
 7f4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7f6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7fa:	b7c1                	j	7ba <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7fc:	6398                	ld	a4,0(a5)
 7fe:	e118                	sd	a4,0(a0)
 800:	a8a9                	j	85a <malloc+0xd6>
  hp->s.size = nu;
 802:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 806:	0541                	addi	a0,a0,16
 808:	efbff0ef          	jal	702 <free>
  return freep;
 80c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 810:	c12d                	beqz	a0,872 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 812:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 814:	4798                	lw	a4,8(a5)
 816:	02977263          	bgeu	a4,s1,83a <malloc+0xb6>
    if(p == freep)
 81a:	00093703          	ld	a4,0(s2)
 81e:	853e                	mv	a0,a5
 820:	fef719e3          	bne	a4,a5,812 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 824:	8552                	mv	a0,s4
 826:	af3ff0ef          	jal	318 <sbrk>
  if(p == (char*)-1)
 82a:	fd551ce3          	bne	a0,s5,802 <malloc+0x7e>
        return 0;
 82e:	4501                	li	a0,0
 830:	7902                	ld	s2,32(sp)
 832:	6a42                	ld	s4,16(sp)
 834:	6aa2                	ld	s5,8(sp)
 836:	6b02                	ld	s6,0(sp)
 838:	a03d                	j	866 <malloc+0xe2>
 83a:	7902                	ld	s2,32(sp)
 83c:	6a42                	ld	s4,16(sp)
 83e:	6aa2                	ld	s5,8(sp)
 840:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 842:	fae48de3          	beq	s1,a4,7fc <malloc+0x78>
        p->s.size -= nunits;
 846:	4137073b          	subw	a4,a4,s3
 84a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 84c:	02071693          	slli	a3,a4,0x20
 850:	01c6d713          	srli	a4,a3,0x1c
 854:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 856:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 85a:	00000717          	auipc	a4,0x0
 85e:	7aa73323          	sd	a0,1958(a4) # 1000 <freep>
      return (void*)(p + 1);
 862:	01078513          	addi	a0,a5,16
  }
}
 866:	70e2                	ld	ra,56(sp)
 868:	7442                	ld	s0,48(sp)
 86a:	74a2                	ld	s1,40(sp)
 86c:	69e2                	ld	s3,24(sp)
 86e:	6121                	addi	sp,sp,64
 870:	8082                	ret
 872:	7902                	ld	s2,32(sp)
 874:	6a42                	ld	s4,16(sp)
 876:	6aa2                	ld	s5,8(sp)
 878:	6b02                	ld	s6,0(sp)
 87a:	b7f5                	j	866 <malloc+0xe2>
