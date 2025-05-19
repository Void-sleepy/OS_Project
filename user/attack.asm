
user/_attack:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"
#include "kernel/riscv.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  // your code here.  you should write the secret to fd 2 using write
  // (e.g., write(2, secret, 8)

  exit(1);
   8:	4505                	li	a0,1
   a:	26e000ef          	jal	278 <exit>

000000000000000e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
   e:	1141                	addi	sp,sp,-16
  10:	e406                	sd	ra,8(sp)
  12:	e022                	sd	s0,0(sp)
  14:	0800                	addi	s0,sp,16
  extern int main();
  main();
  16:	febff0ef          	jal	0 <main>
  exit(0);
  1a:	4501                	li	a0,0
  1c:	25c000ef          	jal	278 <exit>

0000000000000020 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  20:	1141                	addi	sp,sp,-16
  22:	e422                	sd	s0,8(sp)
  24:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  26:	87aa                	mv	a5,a0
  28:	0585                	addi	a1,a1,1
  2a:	0785                	addi	a5,a5,1
  2c:	fff5c703          	lbu	a4,-1(a1)
  30:	fee78fa3          	sb	a4,-1(a5)
  34:	fb75                	bnez	a4,28 <strcpy+0x8>
    ;
  return os;
}
  36:	6422                	ld	s0,8(sp)
  38:	0141                	addi	sp,sp,16
  3a:	8082                	ret

000000000000003c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  3c:	1141                	addi	sp,sp,-16
  3e:	e422                	sd	s0,8(sp)
  40:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  42:	00054783          	lbu	a5,0(a0)
  46:	cb91                	beqz	a5,5a <strcmp+0x1e>
  48:	0005c703          	lbu	a4,0(a1)
  4c:	00f71763          	bne	a4,a5,5a <strcmp+0x1e>
    p++, q++;
  50:	0505                	addi	a0,a0,1
  52:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  54:	00054783          	lbu	a5,0(a0)
  58:	fbe5                	bnez	a5,48 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  5a:	0005c503          	lbu	a0,0(a1)
}
  5e:	40a7853b          	subw	a0,a5,a0
  62:	6422                	ld	s0,8(sp)
  64:	0141                	addi	sp,sp,16
  66:	8082                	ret

0000000000000068 <strlen>:

uint
strlen(const char *s)
{
  68:	1141                	addi	sp,sp,-16
  6a:	e422                	sd	s0,8(sp)
  6c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  6e:	00054783          	lbu	a5,0(a0)
  72:	cf91                	beqz	a5,8e <strlen+0x26>
  74:	0505                	addi	a0,a0,1
  76:	87aa                	mv	a5,a0
  78:	86be                	mv	a3,a5
  7a:	0785                	addi	a5,a5,1
  7c:	fff7c703          	lbu	a4,-1(a5)
  80:	ff65                	bnez	a4,78 <strlen+0x10>
  82:	40a6853b          	subw	a0,a3,a0
  86:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  88:	6422                	ld	s0,8(sp)
  8a:	0141                	addi	sp,sp,16
  8c:	8082                	ret
  for(n = 0; s[n]; n++)
  8e:	4501                	li	a0,0
  90:	bfe5                	j	88 <strlen+0x20>

0000000000000092 <memset>:

void*
memset(void *dst, int c, uint n)
{
  92:	1141                	addi	sp,sp,-16
  94:	e422                	sd	s0,8(sp)
  96:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  98:	ca19                	beqz	a2,ae <memset+0x1c>
  9a:	87aa                	mv	a5,a0
  9c:	1602                	slli	a2,a2,0x20
  9e:	9201                	srli	a2,a2,0x20
  a0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  a4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  a8:	0785                	addi	a5,a5,1
  aa:	fee79de3          	bne	a5,a4,a4 <memset+0x12>
  }
  return dst;
}
  ae:	6422                	ld	s0,8(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret

00000000000000b4 <strchr>:

char*
strchr(const char *s, char c)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e422                	sd	s0,8(sp)
  b8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ba:	00054783          	lbu	a5,0(a0)
  be:	cb99                	beqz	a5,d4 <strchr+0x20>
    if(*s == c)
  c0:	00f58763          	beq	a1,a5,ce <strchr+0x1a>
  for(; *s; s++)
  c4:	0505                	addi	a0,a0,1
  c6:	00054783          	lbu	a5,0(a0)
  ca:	fbfd                	bnez	a5,c0 <strchr+0xc>
      return (char*)s;
  return 0;
  cc:	4501                	li	a0,0
}
  ce:	6422                	ld	s0,8(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret
  return 0;
  d4:	4501                	li	a0,0
  d6:	bfe5                	j	ce <strchr+0x1a>

00000000000000d8 <gets>:

char*
gets(char *buf, int max)
{
  d8:	711d                	addi	sp,sp,-96
  da:	ec86                	sd	ra,88(sp)
  dc:	e8a2                	sd	s0,80(sp)
  de:	e4a6                	sd	s1,72(sp)
  e0:	e0ca                	sd	s2,64(sp)
  e2:	fc4e                	sd	s3,56(sp)
  e4:	f852                	sd	s4,48(sp)
  e6:	f456                	sd	s5,40(sp)
  e8:	f05a                	sd	s6,32(sp)
  ea:	ec5e                	sd	s7,24(sp)
  ec:	1080                	addi	s0,sp,96
  ee:	8baa                	mv	s7,a0
  f0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f2:	892a                	mv	s2,a0
  f4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  f6:	4aa9                	li	s5,10
  f8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
  fa:	89a6                	mv	s3,s1
  fc:	2485                	addiw	s1,s1,1
  fe:	0344d663          	bge	s1,s4,12a <gets+0x52>
    cc = read(0, &c, 1);
 102:	4605                	li	a2,1
 104:	faf40593          	addi	a1,s0,-81
 108:	4501                	li	a0,0
 10a:	186000ef          	jal	290 <read>
    if(cc < 1)
 10e:	00a05e63          	blez	a0,12a <gets+0x52>
    buf[i++] = c;
 112:	faf44783          	lbu	a5,-81(s0)
 116:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 11a:	01578763          	beq	a5,s5,128 <gets+0x50>
 11e:	0905                	addi	s2,s2,1
 120:	fd679de3          	bne	a5,s6,fa <gets+0x22>
    buf[i++] = c;
 124:	89a6                	mv	s3,s1
 126:	a011                	j	12a <gets+0x52>
 128:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 12a:	99de                	add	s3,s3,s7
 12c:	00098023          	sb	zero,0(s3)
  return buf;
}
 130:	855e                	mv	a0,s7
 132:	60e6                	ld	ra,88(sp)
 134:	6446                	ld	s0,80(sp)
 136:	64a6                	ld	s1,72(sp)
 138:	6906                	ld	s2,64(sp)
 13a:	79e2                	ld	s3,56(sp)
 13c:	7a42                	ld	s4,48(sp)
 13e:	7aa2                	ld	s5,40(sp)
 140:	7b02                	ld	s6,32(sp)
 142:	6be2                	ld	s7,24(sp)
 144:	6125                	addi	sp,sp,96
 146:	8082                	ret

0000000000000148 <stat>:

int
stat(const char *n, struct stat *st)
{
 148:	1101                	addi	sp,sp,-32
 14a:	ec06                	sd	ra,24(sp)
 14c:	e822                	sd	s0,16(sp)
 14e:	e04a                	sd	s2,0(sp)
 150:	1000                	addi	s0,sp,32
 152:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 154:	4581                	li	a1,0
 156:	162000ef          	jal	2b8 <open>
  if(fd < 0)
 15a:	02054263          	bltz	a0,17e <stat+0x36>
 15e:	e426                	sd	s1,8(sp)
 160:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 162:	85ca                	mv	a1,s2
 164:	16c000ef          	jal	2d0 <fstat>
 168:	892a                	mv	s2,a0
  close(fd);
 16a:	8526                	mv	a0,s1
 16c:	134000ef          	jal	2a0 <close>
  return r;
 170:	64a2                	ld	s1,8(sp)
}
 172:	854a                	mv	a0,s2
 174:	60e2                	ld	ra,24(sp)
 176:	6442                	ld	s0,16(sp)
 178:	6902                	ld	s2,0(sp)
 17a:	6105                	addi	sp,sp,32
 17c:	8082                	ret
    return -1;
 17e:	597d                	li	s2,-1
 180:	bfcd                	j	172 <stat+0x2a>

0000000000000182 <atoi>:

int
atoi(const char *s)
{
 182:	1141                	addi	sp,sp,-16
 184:	e422                	sd	s0,8(sp)
 186:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 188:	00054683          	lbu	a3,0(a0)
 18c:	fd06879b          	addiw	a5,a3,-48
 190:	0ff7f793          	zext.b	a5,a5
 194:	4625                	li	a2,9
 196:	02f66863          	bltu	a2,a5,1c6 <atoi+0x44>
 19a:	872a                	mv	a4,a0
  n = 0;
 19c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 19e:	0705                	addi	a4,a4,1
 1a0:	0025179b          	slliw	a5,a0,0x2
 1a4:	9fa9                	addw	a5,a5,a0
 1a6:	0017979b          	slliw	a5,a5,0x1
 1aa:	9fb5                	addw	a5,a5,a3
 1ac:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1b0:	00074683          	lbu	a3,0(a4)
 1b4:	fd06879b          	addiw	a5,a3,-48
 1b8:	0ff7f793          	zext.b	a5,a5
 1bc:	fef671e3          	bgeu	a2,a5,19e <atoi+0x1c>
  return n;
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret
  n = 0;
 1c6:	4501                	li	a0,0
 1c8:	bfe5                	j	1c0 <atoi+0x3e>

00000000000001ca <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ca:	1141                	addi	sp,sp,-16
 1cc:	e422                	sd	s0,8(sp)
 1ce:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1d0:	02b57463          	bgeu	a0,a1,1f8 <memmove+0x2e>
    while(n-- > 0)
 1d4:	00c05f63          	blez	a2,1f2 <memmove+0x28>
 1d8:	1602                	slli	a2,a2,0x20
 1da:	9201                	srli	a2,a2,0x20
 1dc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1e0:	872a                	mv	a4,a0
      *dst++ = *src++;
 1e2:	0585                	addi	a1,a1,1
 1e4:	0705                	addi	a4,a4,1
 1e6:	fff5c683          	lbu	a3,-1(a1)
 1ea:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1ee:	fef71ae3          	bne	a4,a5,1e2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 1f2:	6422                	ld	s0,8(sp)
 1f4:	0141                	addi	sp,sp,16
 1f6:	8082                	ret
    dst += n;
 1f8:	00c50733          	add	a4,a0,a2
    src += n;
 1fc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 1fe:	fec05ae3          	blez	a2,1f2 <memmove+0x28>
 202:	fff6079b          	addiw	a5,a2,-1
 206:	1782                	slli	a5,a5,0x20
 208:	9381                	srli	a5,a5,0x20
 20a:	fff7c793          	not	a5,a5
 20e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 210:	15fd                	addi	a1,a1,-1
 212:	177d                	addi	a4,a4,-1
 214:	0005c683          	lbu	a3,0(a1)
 218:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 21c:	fee79ae3          	bne	a5,a4,210 <memmove+0x46>
 220:	bfc9                	j	1f2 <memmove+0x28>

0000000000000222 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 222:	1141                	addi	sp,sp,-16
 224:	e422                	sd	s0,8(sp)
 226:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 228:	ca05                	beqz	a2,258 <memcmp+0x36>
 22a:	fff6069b          	addiw	a3,a2,-1
 22e:	1682                	slli	a3,a3,0x20
 230:	9281                	srli	a3,a3,0x20
 232:	0685                	addi	a3,a3,1
 234:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 236:	00054783          	lbu	a5,0(a0)
 23a:	0005c703          	lbu	a4,0(a1)
 23e:	00e79863          	bne	a5,a4,24e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 242:	0505                	addi	a0,a0,1
    p2++;
 244:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 246:	fed518e3          	bne	a0,a3,236 <memcmp+0x14>
  }
  return 0;
 24a:	4501                	li	a0,0
 24c:	a019                	j	252 <memcmp+0x30>
      return *p1 - *p2;
 24e:	40e7853b          	subw	a0,a5,a4
}
 252:	6422                	ld	s0,8(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret
  return 0;
 258:	4501                	li	a0,0
 25a:	bfe5                	j	252 <memcmp+0x30>

000000000000025c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e406                	sd	ra,8(sp)
 260:	e022                	sd	s0,0(sp)
 262:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 264:	f67ff0ef          	jal	1ca <memmove>
}
 268:	60a2                	ld	ra,8(sp)
 26a:	6402                	ld	s0,0(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret

0000000000000270 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 270:	4885                	li	a7,1
 ecall
 272:	00000073          	ecall
 ret
 276:	8082                	ret

0000000000000278 <exit>:
.global exit
exit:
 li a7, SYS_exit
 278:	4889                	li	a7,2
 ecall
 27a:	00000073          	ecall
 ret
 27e:	8082                	ret

0000000000000280 <wait>:
.global wait
wait:
 li a7, SYS_wait
 280:	488d                	li	a7,3
 ecall
 282:	00000073          	ecall
 ret
 286:	8082                	ret

0000000000000288 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 288:	4891                	li	a7,4
 ecall
 28a:	00000073          	ecall
 ret
 28e:	8082                	ret

0000000000000290 <read>:
.global read
read:
 li a7, SYS_read
 290:	4895                	li	a7,5
 ecall
 292:	00000073          	ecall
 ret
 296:	8082                	ret

0000000000000298 <write>:
.global write
write:
 li a7, SYS_write
 298:	48c1                	li	a7,16
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <close>:
.global close
close:
 li a7, SYS_close
 2a0:	48d5                	li	a7,21
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2a8:	4899                	li	a7,6
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2b0:	489d                	li	a7,7
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <open>:
.global open
open:
 li a7, SYS_open
 2b8:	48bd                	li	a7,15
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2c0:	48c5                	li	a7,17
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2c8:	48c9                	li	a7,18
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2d0:	48a1                	li	a7,8
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <link>:
.global link
link:
 li a7, SYS_link
 2d8:	48cd                	li	a7,19
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2e0:	48d1                	li	a7,20
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2e8:	48a5                	li	a7,9
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 2f0:	48a9                	li	a7,10
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2f8:	48ad                	li	a7,11
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 300:	48b1                	li	a7,12
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 308:	48b5                	li	a7,13
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 310:	48b9                	li	a7,14
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <trace>:
///////
.global trace
trace:
  li a7, SYS_trace
 318:	03300893          	li	a7,51
  ecall
 31c:	00000073          	ecall
  ret
 320:	8082                	ret

0000000000000322 <stats>:

.global stats
stats:
  li a7, SYS_stats
 322:	03400893          	li	a7,52
  ecall
 326:	00000073          	ecall
  ret
 32a:	8082                	ret

000000000000032c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 32c:	1101                	addi	sp,sp,-32
 32e:	ec06                	sd	ra,24(sp)
 330:	e822                	sd	s0,16(sp)
 332:	1000                	addi	s0,sp,32
 334:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 338:	4605                	li	a2,1
 33a:	fef40593          	addi	a1,s0,-17
 33e:	f5bff0ef          	jal	298 <write>
}
 342:	60e2                	ld	ra,24(sp)
 344:	6442                	ld	s0,16(sp)
 346:	6105                	addi	sp,sp,32
 348:	8082                	ret

000000000000034a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 34a:	7139                	addi	sp,sp,-64
 34c:	fc06                	sd	ra,56(sp)
 34e:	f822                	sd	s0,48(sp)
 350:	f426                	sd	s1,40(sp)
 352:	0080                	addi	s0,sp,64
 354:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 356:	c299                	beqz	a3,35c <printint+0x12>
 358:	0805c963          	bltz	a1,3ea <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 35c:	2581                	sext.w	a1,a1
  neg = 0;
 35e:	4881                	li	a7,0
 360:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 364:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 366:	2601                	sext.w	a2,a2
 368:	00000517          	auipc	a0,0x0
 36c:	4f050513          	addi	a0,a0,1264 # 858 <digits>
 370:	883a                	mv	a6,a4
 372:	2705                	addiw	a4,a4,1
 374:	02c5f7bb          	remuw	a5,a1,a2
 378:	1782                	slli	a5,a5,0x20
 37a:	9381                	srli	a5,a5,0x20
 37c:	97aa                	add	a5,a5,a0
 37e:	0007c783          	lbu	a5,0(a5)
 382:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 386:	0005879b          	sext.w	a5,a1
 38a:	02c5d5bb          	divuw	a1,a1,a2
 38e:	0685                	addi	a3,a3,1
 390:	fec7f0e3          	bgeu	a5,a2,370 <printint+0x26>
  if(neg)
 394:	00088c63          	beqz	a7,3ac <printint+0x62>
    buf[i++] = '-';
 398:	fd070793          	addi	a5,a4,-48
 39c:	00878733          	add	a4,a5,s0
 3a0:	02d00793          	li	a5,45
 3a4:	fef70823          	sb	a5,-16(a4)
 3a8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3ac:	02e05a63          	blez	a4,3e0 <printint+0x96>
 3b0:	f04a                	sd	s2,32(sp)
 3b2:	ec4e                	sd	s3,24(sp)
 3b4:	fc040793          	addi	a5,s0,-64
 3b8:	00e78933          	add	s2,a5,a4
 3bc:	fff78993          	addi	s3,a5,-1
 3c0:	99ba                	add	s3,s3,a4
 3c2:	377d                	addiw	a4,a4,-1
 3c4:	1702                	slli	a4,a4,0x20
 3c6:	9301                	srli	a4,a4,0x20
 3c8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3cc:	fff94583          	lbu	a1,-1(s2)
 3d0:	8526                	mv	a0,s1
 3d2:	f5bff0ef          	jal	32c <putc>
  while(--i >= 0)
 3d6:	197d                	addi	s2,s2,-1
 3d8:	ff391ae3          	bne	s2,s3,3cc <printint+0x82>
 3dc:	7902                	ld	s2,32(sp)
 3de:	69e2                	ld	s3,24(sp)
}
 3e0:	70e2                	ld	ra,56(sp)
 3e2:	7442                	ld	s0,48(sp)
 3e4:	74a2                	ld	s1,40(sp)
 3e6:	6121                	addi	sp,sp,64
 3e8:	8082                	ret
    x = -xx;
 3ea:	40b005bb          	negw	a1,a1
    neg = 1;
 3ee:	4885                	li	a7,1
    x = -xx;
 3f0:	bf85                	j	360 <printint+0x16>

00000000000003f2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3f2:	711d                	addi	sp,sp,-96
 3f4:	ec86                	sd	ra,88(sp)
 3f6:	e8a2                	sd	s0,80(sp)
 3f8:	e0ca                	sd	s2,64(sp)
 3fa:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 3fc:	0005c903          	lbu	s2,0(a1)
 400:	26090863          	beqz	s2,670 <vprintf+0x27e>
 404:	e4a6                	sd	s1,72(sp)
 406:	fc4e                	sd	s3,56(sp)
 408:	f852                	sd	s4,48(sp)
 40a:	f456                	sd	s5,40(sp)
 40c:	f05a                	sd	s6,32(sp)
 40e:	ec5e                	sd	s7,24(sp)
 410:	e862                	sd	s8,16(sp)
 412:	e466                	sd	s9,8(sp)
 414:	8b2a                	mv	s6,a0
 416:	8a2e                	mv	s4,a1
 418:	8bb2                	mv	s7,a2
  state = 0;
 41a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 41c:	4481                	li	s1,0
 41e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 420:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 424:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 428:	06c00c93          	li	s9,108
 42c:	a005                	j	44c <vprintf+0x5a>
        putc(fd, c0);
 42e:	85ca                	mv	a1,s2
 430:	855a                	mv	a0,s6
 432:	efbff0ef          	jal	32c <putc>
 436:	a019                	j	43c <vprintf+0x4a>
    } else if(state == '%'){
 438:	03598263          	beq	s3,s5,45c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 43c:	2485                	addiw	s1,s1,1
 43e:	8726                	mv	a4,s1
 440:	009a07b3          	add	a5,s4,s1
 444:	0007c903          	lbu	s2,0(a5)
 448:	20090c63          	beqz	s2,660 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 44c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 450:	fe0994e3          	bnez	s3,438 <vprintf+0x46>
      if(c0 == '%'){
 454:	fd579de3          	bne	a5,s5,42e <vprintf+0x3c>
        state = '%';
 458:	89be                	mv	s3,a5
 45a:	b7cd                	j	43c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 45c:	00ea06b3          	add	a3,s4,a4
 460:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 464:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 466:	c681                	beqz	a3,46e <vprintf+0x7c>
 468:	9752                	add	a4,a4,s4
 46a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 46e:	03878f63          	beq	a5,s8,4ac <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 472:	05978963          	beq	a5,s9,4c4 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 476:	07500713          	li	a4,117
 47a:	0ee78363          	beq	a5,a4,560 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 47e:	07800713          	li	a4,120
 482:	12e78563          	beq	a5,a4,5ac <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 486:	07000713          	li	a4,112
 48a:	14e78a63          	beq	a5,a4,5de <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 48e:	07300713          	li	a4,115
 492:	18e78a63          	beq	a5,a4,626 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 496:	02500713          	li	a4,37
 49a:	04e79563          	bne	a5,a4,4e4 <vprintf+0xf2>
        putc(fd, '%');
 49e:	02500593          	li	a1,37
 4a2:	855a                	mv	a0,s6
 4a4:	e89ff0ef          	jal	32c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4a8:	4981                	li	s3,0
 4aa:	bf49                	j	43c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4ac:	008b8913          	addi	s2,s7,8
 4b0:	4685                	li	a3,1
 4b2:	4629                	li	a2,10
 4b4:	000ba583          	lw	a1,0(s7)
 4b8:	855a                	mv	a0,s6
 4ba:	e91ff0ef          	jal	34a <printint>
 4be:	8bca                	mv	s7,s2
      state = 0;
 4c0:	4981                	li	s3,0
 4c2:	bfad                	j	43c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4c4:	06400793          	li	a5,100
 4c8:	02f68963          	beq	a3,a5,4fa <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4cc:	06c00793          	li	a5,108
 4d0:	04f68263          	beq	a3,a5,514 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 4d4:	07500793          	li	a5,117
 4d8:	0af68063          	beq	a3,a5,578 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 4dc:	07800793          	li	a5,120
 4e0:	0ef68263          	beq	a3,a5,5c4 <vprintf+0x1d2>
        putc(fd, '%');
 4e4:	02500593          	li	a1,37
 4e8:	855a                	mv	a0,s6
 4ea:	e43ff0ef          	jal	32c <putc>
        putc(fd, c0);
 4ee:	85ca                	mv	a1,s2
 4f0:	855a                	mv	a0,s6
 4f2:	e3bff0ef          	jal	32c <putc>
      state = 0;
 4f6:	4981                	li	s3,0
 4f8:	b791                	j	43c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4fa:	008b8913          	addi	s2,s7,8
 4fe:	4685                	li	a3,1
 500:	4629                	li	a2,10
 502:	000ba583          	lw	a1,0(s7)
 506:	855a                	mv	a0,s6
 508:	e43ff0ef          	jal	34a <printint>
        i += 1;
 50c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 50e:	8bca                	mv	s7,s2
      state = 0;
 510:	4981                	li	s3,0
        i += 1;
 512:	b72d                	j	43c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 514:	06400793          	li	a5,100
 518:	02f60763          	beq	a2,a5,546 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 51c:	07500793          	li	a5,117
 520:	06f60963          	beq	a2,a5,592 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 524:	07800793          	li	a5,120
 528:	faf61ee3          	bne	a2,a5,4e4 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 52c:	008b8913          	addi	s2,s7,8
 530:	4681                	li	a3,0
 532:	4641                	li	a2,16
 534:	000ba583          	lw	a1,0(s7)
 538:	855a                	mv	a0,s6
 53a:	e11ff0ef          	jal	34a <printint>
        i += 2;
 53e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 540:	8bca                	mv	s7,s2
      state = 0;
 542:	4981                	li	s3,0
        i += 2;
 544:	bde5                	j	43c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 546:	008b8913          	addi	s2,s7,8
 54a:	4685                	li	a3,1
 54c:	4629                	li	a2,10
 54e:	000ba583          	lw	a1,0(s7)
 552:	855a                	mv	a0,s6
 554:	df7ff0ef          	jal	34a <printint>
        i += 2;
 558:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 55a:	8bca                	mv	s7,s2
      state = 0;
 55c:	4981                	li	s3,0
        i += 2;
 55e:	bdf9                	j	43c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 560:	008b8913          	addi	s2,s7,8
 564:	4681                	li	a3,0
 566:	4629                	li	a2,10
 568:	000ba583          	lw	a1,0(s7)
 56c:	855a                	mv	a0,s6
 56e:	dddff0ef          	jal	34a <printint>
 572:	8bca                	mv	s7,s2
      state = 0;
 574:	4981                	li	s3,0
 576:	b5d9                	j	43c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 578:	008b8913          	addi	s2,s7,8
 57c:	4681                	li	a3,0
 57e:	4629                	li	a2,10
 580:	000ba583          	lw	a1,0(s7)
 584:	855a                	mv	a0,s6
 586:	dc5ff0ef          	jal	34a <printint>
        i += 1;
 58a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 58c:	8bca                	mv	s7,s2
      state = 0;
 58e:	4981                	li	s3,0
        i += 1;
 590:	b575                	j	43c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 592:	008b8913          	addi	s2,s7,8
 596:	4681                	li	a3,0
 598:	4629                	li	a2,10
 59a:	000ba583          	lw	a1,0(s7)
 59e:	855a                	mv	a0,s6
 5a0:	dabff0ef          	jal	34a <printint>
        i += 2;
 5a4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a6:	8bca                	mv	s7,s2
      state = 0;
 5a8:	4981                	li	s3,0
        i += 2;
 5aa:	bd49                	j	43c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5ac:	008b8913          	addi	s2,s7,8
 5b0:	4681                	li	a3,0
 5b2:	4641                	li	a2,16
 5b4:	000ba583          	lw	a1,0(s7)
 5b8:	855a                	mv	a0,s6
 5ba:	d91ff0ef          	jal	34a <printint>
 5be:	8bca                	mv	s7,s2
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	bdad                	j	43c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c4:	008b8913          	addi	s2,s7,8
 5c8:	4681                	li	a3,0
 5ca:	4641                	li	a2,16
 5cc:	000ba583          	lw	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	d79ff0ef          	jal	34a <printint>
        i += 1;
 5d6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d8:	8bca                	mv	s7,s2
      state = 0;
 5da:	4981                	li	s3,0
        i += 1;
 5dc:	b585                	j	43c <vprintf+0x4a>
 5de:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5e0:	008b8d13          	addi	s10,s7,8
 5e4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5e8:	03000593          	li	a1,48
 5ec:	855a                	mv	a0,s6
 5ee:	d3fff0ef          	jal	32c <putc>
  putc(fd, 'x');
 5f2:	07800593          	li	a1,120
 5f6:	855a                	mv	a0,s6
 5f8:	d35ff0ef          	jal	32c <putc>
 5fc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5fe:	00000b97          	auipc	s7,0x0
 602:	25ab8b93          	addi	s7,s7,602 # 858 <digits>
 606:	03c9d793          	srli	a5,s3,0x3c
 60a:	97de                	add	a5,a5,s7
 60c:	0007c583          	lbu	a1,0(a5)
 610:	855a                	mv	a0,s6
 612:	d1bff0ef          	jal	32c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 616:	0992                	slli	s3,s3,0x4
 618:	397d                	addiw	s2,s2,-1
 61a:	fe0916e3          	bnez	s2,606 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 61e:	8bea                	mv	s7,s10
      state = 0;
 620:	4981                	li	s3,0
 622:	6d02                	ld	s10,0(sp)
 624:	bd21                	j	43c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 626:	008b8993          	addi	s3,s7,8
 62a:	000bb903          	ld	s2,0(s7)
 62e:	00090f63          	beqz	s2,64c <vprintf+0x25a>
        for(; *s; s++)
 632:	00094583          	lbu	a1,0(s2)
 636:	c195                	beqz	a1,65a <vprintf+0x268>
          putc(fd, *s);
 638:	855a                	mv	a0,s6
 63a:	cf3ff0ef          	jal	32c <putc>
        for(; *s; s++)
 63e:	0905                	addi	s2,s2,1
 640:	00094583          	lbu	a1,0(s2)
 644:	f9f5                	bnez	a1,638 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 646:	8bce                	mv	s7,s3
      state = 0;
 648:	4981                	li	s3,0
 64a:	bbcd                	j	43c <vprintf+0x4a>
          s = "(null)";
 64c:	00000917          	auipc	s2,0x0
 650:	20490913          	addi	s2,s2,516 # 850 <malloc+0xf8>
        for(; *s; s++)
 654:	02800593          	li	a1,40
 658:	b7c5                	j	638 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 65a:	8bce                	mv	s7,s3
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bbf9                	j	43c <vprintf+0x4a>
 660:	64a6                	ld	s1,72(sp)
 662:	79e2                	ld	s3,56(sp)
 664:	7a42                	ld	s4,48(sp)
 666:	7aa2                	ld	s5,40(sp)
 668:	7b02                	ld	s6,32(sp)
 66a:	6be2                	ld	s7,24(sp)
 66c:	6c42                	ld	s8,16(sp)
 66e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 670:	60e6                	ld	ra,88(sp)
 672:	6446                	ld	s0,80(sp)
 674:	6906                	ld	s2,64(sp)
 676:	6125                	addi	sp,sp,96
 678:	8082                	ret

000000000000067a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 67a:	715d                	addi	sp,sp,-80
 67c:	ec06                	sd	ra,24(sp)
 67e:	e822                	sd	s0,16(sp)
 680:	1000                	addi	s0,sp,32
 682:	e010                	sd	a2,0(s0)
 684:	e414                	sd	a3,8(s0)
 686:	e818                	sd	a4,16(s0)
 688:	ec1c                	sd	a5,24(s0)
 68a:	03043023          	sd	a6,32(s0)
 68e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 692:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 696:	8622                	mv	a2,s0
 698:	d5bff0ef          	jal	3f2 <vprintf>
}
 69c:	60e2                	ld	ra,24(sp)
 69e:	6442                	ld	s0,16(sp)
 6a0:	6161                	addi	sp,sp,80
 6a2:	8082                	ret

00000000000006a4 <printf>:

void
printf(const char *fmt, ...)
{
 6a4:	711d                	addi	sp,sp,-96
 6a6:	ec06                	sd	ra,24(sp)
 6a8:	e822                	sd	s0,16(sp)
 6aa:	1000                	addi	s0,sp,32
 6ac:	e40c                	sd	a1,8(s0)
 6ae:	e810                	sd	a2,16(s0)
 6b0:	ec14                	sd	a3,24(s0)
 6b2:	f018                	sd	a4,32(s0)
 6b4:	f41c                	sd	a5,40(s0)
 6b6:	03043823          	sd	a6,48(s0)
 6ba:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6be:	00840613          	addi	a2,s0,8
 6c2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6c6:	85aa                	mv	a1,a0
 6c8:	4505                	li	a0,1
 6ca:	d29ff0ef          	jal	3f2 <vprintf>
}
 6ce:	60e2                	ld	ra,24(sp)
 6d0:	6442                	ld	s0,16(sp)
 6d2:	6125                	addi	sp,sp,96
 6d4:	8082                	ret

00000000000006d6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d6:	1141                	addi	sp,sp,-16
 6d8:	e422                	sd	s0,8(sp)
 6da:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6dc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e0:	00001797          	auipc	a5,0x1
 6e4:	9207b783          	ld	a5,-1760(a5) # 1000 <freep>
 6e8:	a02d                	j	712 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6ea:	4618                	lw	a4,8(a2)
 6ec:	9f2d                	addw	a4,a4,a1
 6ee:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f2:	6398                	ld	a4,0(a5)
 6f4:	6310                	ld	a2,0(a4)
 6f6:	a83d                	j	734 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6f8:	ff852703          	lw	a4,-8(a0)
 6fc:	9f31                	addw	a4,a4,a2
 6fe:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 700:	ff053683          	ld	a3,-16(a0)
 704:	a091                	j	748 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 706:	6398                	ld	a4,0(a5)
 708:	00e7e463          	bltu	a5,a4,710 <free+0x3a>
 70c:	00e6ea63          	bltu	a3,a4,720 <free+0x4a>
{
 710:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 712:	fed7fae3          	bgeu	a5,a3,706 <free+0x30>
 716:	6398                	ld	a4,0(a5)
 718:	00e6e463          	bltu	a3,a4,720 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71c:	fee7eae3          	bltu	a5,a4,710 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 720:	ff852583          	lw	a1,-8(a0)
 724:	6390                	ld	a2,0(a5)
 726:	02059813          	slli	a6,a1,0x20
 72a:	01c85713          	srli	a4,a6,0x1c
 72e:	9736                	add	a4,a4,a3
 730:	fae60de3          	beq	a2,a4,6ea <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 734:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 738:	4790                	lw	a2,8(a5)
 73a:	02061593          	slli	a1,a2,0x20
 73e:	01c5d713          	srli	a4,a1,0x1c
 742:	973e                	add	a4,a4,a5
 744:	fae68ae3          	beq	a3,a4,6f8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 748:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 74a:	00001717          	auipc	a4,0x1
 74e:	8af73b23          	sd	a5,-1866(a4) # 1000 <freep>
}
 752:	6422                	ld	s0,8(sp)
 754:	0141                	addi	sp,sp,16
 756:	8082                	ret

0000000000000758 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 758:	7139                	addi	sp,sp,-64
 75a:	fc06                	sd	ra,56(sp)
 75c:	f822                	sd	s0,48(sp)
 75e:	f426                	sd	s1,40(sp)
 760:	ec4e                	sd	s3,24(sp)
 762:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 764:	02051493          	slli	s1,a0,0x20
 768:	9081                	srli	s1,s1,0x20
 76a:	04bd                	addi	s1,s1,15
 76c:	8091                	srli	s1,s1,0x4
 76e:	0014899b          	addiw	s3,s1,1
 772:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 774:	00001517          	auipc	a0,0x1
 778:	88c53503          	ld	a0,-1908(a0) # 1000 <freep>
 77c:	c915                	beqz	a0,7b0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 77e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 780:	4798                	lw	a4,8(a5)
 782:	08977a63          	bgeu	a4,s1,816 <malloc+0xbe>
 786:	f04a                	sd	s2,32(sp)
 788:	e852                	sd	s4,16(sp)
 78a:	e456                	sd	s5,8(sp)
 78c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 78e:	8a4e                	mv	s4,s3
 790:	0009871b          	sext.w	a4,s3
 794:	6685                	lui	a3,0x1
 796:	00d77363          	bgeu	a4,a3,79c <malloc+0x44>
 79a:	6a05                	lui	s4,0x1
 79c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7a0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a4:	00001917          	auipc	s2,0x1
 7a8:	85c90913          	addi	s2,s2,-1956 # 1000 <freep>
  if(p == (char*)-1)
 7ac:	5afd                	li	s5,-1
 7ae:	a081                	j	7ee <malloc+0x96>
 7b0:	f04a                	sd	s2,32(sp)
 7b2:	e852                	sd	s4,16(sp)
 7b4:	e456                	sd	s5,8(sp)
 7b6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7b8:	00001797          	auipc	a5,0x1
 7bc:	85878793          	addi	a5,a5,-1960 # 1010 <base>
 7c0:	00001717          	auipc	a4,0x1
 7c4:	84f73023          	sd	a5,-1984(a4) # 1000 <freep>
 7c8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ca:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ce:	b7c1                	j	78e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7d0:	6398                	ld	a4,0(a5)
 7d2:	e118                	sd	a4,0(a0)
 7d4:	a8a9                	j	82e <malloc+0xd6>
  hp->s.size = nu;
 7d6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7da:	0541                	addi	a0,a0,16
 7dc:	efbff0ef          	jal	6d6 <free>
  return freep;
 7e0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7e4:	c12d                	beqz	a0,846 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e8:	4798                	lw	a4,8(a5)
 7ea:	02977263          	bgeu	a4,s1,80e <malloc+0xb6>
    if(p == freep)
 7ee:	00093703          	ld	a4,0(s2)
 7f2:	853e                	mv	a0,a5
 7f4:	fef719e3          	bne	a4,a5,7e6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7f8:	8552                	mv	a0,s4
 7fa:	b07ff0ef          	jal	300 <sbrk>
  if(p == (char*)-1)
 7fe:	fd551ce3          	bne	a0,s5,7d6 <malloc+0x7e>
        return 0;
 802:	4501                	li	a0,0
 804:	7902                	ld	s2,32(sp)
 806:	6a42                	ld	s4,16(sp)
 808:	6aa2                	ld	s5,8(sp)
 80a:	6b02                	ld	s6,0(sp)
 80c:	a03d                	j	83a <malloc+0xe2>
 80e:	7902                	ld	s2,32(sp)
 810:	6a42                	ld	s4,16(sp)
 812:	6aa2                	ld	s5,8(sp)
 814:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 816:	fae48de3          	beq	s1,a4,7d0 <malloc+0x78>
        p->s.size -= nunits;
 81a:	4137073b          	subw	a4,a4,s3
 81e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 820:	02071693          	slli	a3,a4,0x20
 824:	01c6d713          	srli	a4,a3,0x1c
 828:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 82a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 82e:	00000717          	auipc	a4,0x0
 832:	7ca73923          	sd	a0,2002(a4) # 1000 <freep>
      return (void*)(p + 1);
 836:	01078513          	addi	a0,a5,16
  }
}
 83a:	70e2                	ld	ra,56(sp)
 83c:	7442                	ld	s0,48(sp)
 83e:	74a2                	ld	s1,40(sp)
 840:	69e2                	ld	s3,24(sp)
 842:	6121                	addi	sp,sp,64
 844:	8082                	ret
 846:	7902                	ld	s2,32(sp)
 848:	6a42                	ld	s4,16(sp)
 84a:	6aa2                	ld	s5,8(sp)
 84c:	6b02                	ld	s6,0(sp)
 84e:	b7f5                	j	83a <malloc+0xe2>
