
user/_gdblab:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"



int main(){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16


  int t = 3;
  while(t--){
    printf("test\n");
   8:	00001517          	auipc	a0,0x1
   c:	88850513          	addi	a0,a0,-1912 # 890 <malloc+0x104>
  10:	6c8000ef          	jal	6d8 <printf>
  14:	00001517          	auipc	a0,0x1
  18:	87c50513          	addi	a0,a0,-1924 # 890 <malloc+0x104>
  1c:	6bc000ef          	jal	6d8 <printf>
  20:	00001517          	auipc	a0,0x1
  24:	87050513          	addi	a0,a0,-1936 # 890 <malloc+0x104>
  28:	6b0000ef          	jal	6d8 <printf>
  }


  return 0;
}
  2c:	4501                	li	a0,0
  2e:	60a2                	ld	ra,8(sp)
  30:	6402                	ld	s0,0(sp)
  32:	0141                	addi	sp,sp,16
  34:	8082                	ret

0000000000000036 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  36:	1141                	addi	sp,sp,-16
  38:	e406                	sd	ra,8(sp)
  3a:	e022                	sd	s0,0(sp)
  3c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  3e:	fc3ff0ef          	jal	0 <main>
  exit(0);
  42:	4501                	li	a0,0
  44:	25c000ef          	jal	2a0 <exit>

0000000000000048 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  48:	1141                	addi	sp,sp,-16
  4a:	e422                	sd	s0,8(sp)
  4c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4e:	87aa                	mv	a5,a0
  50:	0585                	addi	a1,a1,1
  52:	0785                	addi	a5,a5,1
  54:	fff5c703          	lbu	a4,-1(a1)
  58:	fee78fa3          	sb	a4,-1(a5)
  5c:	fb75                	bnez	a4,50 <strcpy+0x8>
    ;
  return os;
}
  5e:	6422                	ld	s0,8(sp)
  60:	0141                	addi	sp,sp,16
  62:	8082                	ret

0000000000000064 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  64:	1141                	addi	sp,sp,-16
  66:	e422                	sd	s0,8(sp)
  68:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  6a:	00054783          	lbu	a5,0(a0)
  6e:	cb91                	beqz	a5,82 <strcmp+0x1e>
  70:	0005c703          	lbu	a4,0(a1)
  74:	00f71763          	bne	a4,a5,82 <strcmp+0x1e>
    p++, q++;
  78:	0505                	addi	a0,a0,1
  7a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  7c:	00054783          	lbu	a5,0(a0)
  80:	fbe5                	bnez	a5,70 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  82:	0005c503          	lbu	a0,0(a1)
}
  86:	40a7853b          	subw	a0,a5,a0
  8a:	6422                	ld	s0,8(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret

0000000000000090 <strlen>:

uint
strlen(const char *s)
{
  90:	1141                	addi	sp,sp,-16
  92:	e422                	sd	s0,8(sp)
  94:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  96:	00054783          	lbu	a5,0(a0)
  9a:	cf91                	beqz	a5,b6 <strlen+0x26>
  9c:	0505                	addi	a0,a0,1
  9e:	87aa                	mv	a5,a0
  a0:	86be                	mv	a3,a5
  a2:	0785                	addi	a5,a5,1
  a4:	fff7c703          	lbu	a4,-1(a5)
  a8:	ff65                	bnez	a4,a0 <strlen+0x10>
  aa:	40a6853b          	subw	a0,a3,a0
  ae:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  b0:	6422                	ld	s0,8(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret
  for(n = 0; s[n]; n++)
  b6:	4501                	li	a0,0
  b8:	bfe5                	j	b0 <strlen+0x20>

00000000000000ba <memset>:

void*
memset(void *dst, int c, uint n)
{
  ba:	1141                	addi	sp,sp,-16
  bc:	e422                	sd	s0,8(sp)
  be:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  c0:	ca19                	beqz	a2,d6 <memset+0x1c>
  c2:	87aa                	mv	a5,a0
  c4:	1602                	slli	a2,a2,0x20
  c6:	9201                	srli	a2,a2,0x20
  c8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  cc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  d0:	0785                	addi	a5,a5,1
  d2:	fee79de3          	bne	a5,a4,cc <memset+0x12>
  }
  return dst;
}
  d6:	6422                	ld	s0,8(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret

00000000000000dc <strchr>:

char*
strchr(const char *s, char c)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e422                	sd	s0,8(sp)
  e0:	0800                	addi	s0,sp,16
  for(; *s; s++)
  e2:	00054783          	lbu	a5,0(a0)
  e6:	cb99                	beqz	a5,fc <strchr+0x20>
    if(*s == c)
  e8:	00f58763          	beq	a1,a5,f6 <strchr+0x1a>
  for(; *s; s++)
  ec:	0505                	addi	a0,a0,1
  ee:	00054783          	lbu	a5,0(a0)
  f2:	fbfd                	bnez	a5,e8 <strchr+0xc>
      return (char*)s;
  return 0;
  f4:	4501                	li	a0,0
}
  f6:	6422                	ld	s0,8(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret
  return 0;
  fc:	4501                	li	a0,0
  fe:	bfe5                	j	f6 <strchr+0x1a>

0000000000000100 <gets>:

char*
gets(char *buf, int max)
{
 100:	711d                	addi	sp,sp,-96
 102:	ec86                	sd	ra,88(sp)
 104:	e8a2                	sd	s0,80(sp)
 106:	e4a6                	sd	s1,72(sp)
 108:	e0ca                	sd	s2,64(sp)
 10a:	fc4e                	sd	s3,56(sp)
 10c:	f852                	sd	s4,48(sp)
 10e:	f456                	sd	s5,40(sp)
 110:	f05a                	sd	s6,32(sp)
 112:	ec5e                	sd	s7,24(sp)
 114:	1080                	addi	s0,sp,96
 116:	8baa                	mv	s7,a0
 118:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11a:	892a                	mv	s2,a0
 11c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 11e:	4aa9                	li	s5,10
 120:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 122:	89a6                	mv	s3,s1
 124:	2485                	addiw	s1,s1,1
 126:	0344d663          	bge	s1,s4,152 <gets+0x52>
    cc = read(0, &c, 1);
 12a:	4605                	li	a2,1
 12c:	faf40593          	addi	a1,s0,-81
 130:	4501                	li	a0,0
 132:	186000ef          	jal	2b8 <read>
    if(cc < 1)
 136:	00a05e63          	blez	a0,152 <gets+0x52>
    buf[i++] = c;
 13a:	faf44783          	lbu	a5,-81(s0)
 13e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 142:	01578763          	beq	a5,s5,150 <gets+0x50>
 146:	0905                	addi	s2,s2,1
 148:	fd679de3          	bne	a5,s6,122 <gets+0x22>
    buf[i++] = c;
 14c:	89a6                	mv	s3,s1
 14e:	a011                	j	152 <gets+0x52>
 150:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 152:	99de                	add	s3,s3,s7
 154:	00098023          	sb	zero,0(s3)
  return buf;
}
 158:	855e                	mv	a0,s7
 15a:	60e6                	ld	ra,88(sp)
 15c:	6446                	ld	s0,80(sp)
 15e:	64a6                	ld	s1,72(sp)
 160:	6906                	ld	s2,64(sp)
 162:	79e2                	ld	s3,56(sp)
 164:	7a42                	ld	s4,48(sp)
 166:	7aa2                	ld	s5,40(sp)
 168:	7b02                	ld	s6,32(sp)
 16a:	6be2                	ld	s7,24(sp)
 16c:	6125                	addi	sp,sp,96
 16e:	8082                	ret

0000000000000170 <stat>:

int
stat(const char *n, struct stat *st)
{
 170:	1101                	addi	sp,sp,-32
 172:	ec06                	sd	ra,24(sp)
 174:	e822                	sd	s0,16(sp)
 176:	e04a                	sd	s2,0(sp)
 178:	1000                	addi	s0,sp,32
 17a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17c:	4581                	li	a1,0
 17e:	162000ef          	jal	2e0 <open>
  if(fd < 0)
 182:	02054263          	bltz	a0,1a6 <stat+0x36>
 186:	e426                	sd	s1,8(sp)
 188:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18a:	85ca                	mv	a1,s2
 18c:	16c000ef          	jal	2f8 <fstat>
 190:	892a                	mv	s2,a0
  close(fd);
 192:	8526                	mv	a0,s1
 194:	134000ef          	jal	2c8 <close>
  return r;
 198:	64a2                	ld	s1,8(sp)
}
 19a:	854a                	mv	a0,s2
 19c:	60e2                	ld	ra,24(sp)
 19e:	6442                	ld	s0,16(sp)
 1a0:	6902                	ld	s2,0(sp)
 1a2:	6105                	addi	sp,sp,32
 1a4:	8082                	ret
    return -1;
 1a6:	597d                	li	s2,-1
 1a8:	bfcd                	j	19a <stat+0x2a>

00000000000001aa <atoi>:

int
atoi(const char *s)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b0:	00054683          	lbu	a3,0(a0)
 1b4:	fd06879b          	addiw	a5,a3,-48
 1b8:	0ff7f793          	zext.b	a5,a5
 1bc:	4625                	li	a2,9
 1be:	02f66863          	bltu	a2,a5,1ee <atoi+0x44>
 1c2:	872a                	mv	a4,a0
  n = 0;
 1c4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1c6:	0705                	addi	a4,a4,1
 1c8:	0025179b          	slliw	a5,a0,0x2
 1cc:	9fa9                	addw	a5,a5,a0
 1ce:	0017979b          	slliw	a5,a5,0x1
 1d2:	9fb5                	addw	a5,a5,a3
 1d4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1d8:	00074683          	lbu	a3,0(a4)
 1dc:	fd06879b          	addiw	a5,a3,-48
 1e0:	0ff7f793          	zext.b	a5,a5
 1e4:	fef671e3          	bgeu	a2,a5,1c6 <atoi+0x1c>
  return n;
}
 1e8:	6422                	ld	s0,8(sp)
 1ea:	0141                	addi	sp,sp,16
 1ec:	8082                	ret
  n = 0;
 1ee:	4501                	li	a0,0
 1f0:	bfe5                	j	1e8 <atoi+0x3e>

00000000000001f2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e422                	sd	s0,8(sp)
 1f6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f8:	02b57463          	bgeu	a0,a1,220 <memmove+0x2e>
    while(n-- > 0)
 1fc:	00c05f63          	blez	a2,21a <memmove+0x28>
 200:	1602                	slli	a2,a2,0x20
 202:	9201                	srli	a2,a2,0x20
 204:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 208:	872a                	mv	a4,a0
      *dst++ = *src++;
 20a:	0585                	addi	a1,a1,1
 20c:	0705                	addi	a4,a4,1
 20e:	fff5c683          	lbu	a3,-1(a1)
 212:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 216:	fef71ae3          	bne	a4,a5,20a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 21a:	6422                	ld	s0,8(sp)
 21c:	0141                	addi	sp,sp,16
 21e:	8082                	ret
    dst += n;
 220:	00c50733          	add	a4,a0,a2
    src += n;
 224:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 226:	fec05ae3          	blez	a2,21a <memmove+0x28>
 22a:	fff6079b          	addiw	a5,a2,-1
 22e:	1782                	slli	a5,a5,0x20
 230:	9381                	srli	a5,a5,0x20
 232:	fff7c793          	not	a5,a5
 236:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 238:	15fd                	addi	a1,a1,-1
 23a:	177d                	addi	a4,a4,-1
 23c:	0005c683          	lbu	a3,0(a1)
 240:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 244:	fee79ae3          	bne	a5,a4,238 <memmove+0x46>
 248:	bfc9                	j	21a <memmove+0x28>

000000000000024a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e422                	sd	s0,8(sp)
 24e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 250:	ca05                	beqz	a2,280 <memcmp+0x36>
 252:	fff6069b          	addiw	a3,a2,-1
 256:	1682                	slli	a3,a3,0x20
 258:	9281                	srli	a3,a3,0x20
 25a:	0685                	addi	a3,a3,1
 25c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 25e:	00054783          	lbu	a5,0(a0)
 262:	0005c703          	lbu	a4,0(a1)
 266:	00e79863          	bne	a5,a4,276 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 26a:	0505                	addi	a0,a0,1
    p2++;
 26c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 26e:	fed518e3          	bne	a0,a3,25e <memcmp+0x14>
  }
  return 0;
 272:	4501                	li	a0,0
 274:	a019                	j	27a <memcmp+0x30>
      return *p1 - *p2;
 276:	40e7853b          	subw	a0,a5,a4
}
 27a:	6422                	ld	s0,8(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret
  return 0;
 280:	4501                	li	a0,0
 282:	bfe5                	j	27a <memcmp+0x30>

0000000000000284 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 284:	1141                	addi	sp,sp,-16
 286:	e406                	sd	ra,8(sp)
 288:	e022                	sd	s0,0(sp)
 28a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 28c:	f67ff0ef          	jal	1f2 <memmove>
}
 290:	60a2                	ld	ra,8(sp)
 292:	6402                	ld	s0,0(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret

0000000000000298 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 298:	4885                	li	a7,1
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2a0:	4889                	li	a7,2
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2a8:	488d                	li	a7,3
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2b0:	4891                	li	a7,4
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <read>:
.global read
read:
 li a7, SYS_read
 2b8:	4895                	li	a7,5
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <write>:
.global write
write:
 li a7, SYS_write
 2c0:	48c1                	li	a7,16
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <close>:
.global close
close:
 li a7, SYS_close
 2c8:	48d5                	li	a7,21
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2d0:	4899                	li	a7,6
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2d8:	489d                	li	a7,7
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <open>:
.global open
open:
 li a7, SYS_open
 2e0:	48bd                	li	a7,15
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2e8:	48c5                	li	a7,17
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2f0:	48c9                	li	a7,18
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2f8:	48a1                	li	a7,8
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <link>:
.global link
link:
 li a7, SYS_link
 300:	48cd                	li	a7,19
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 308:	48d1                	li	a7,20
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 310:	48a5                	li	a7,9
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <dup>:
.global dup
dup:
 li a7, SYS_dup
 318:	48a9                	li	a7,10
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 320:	48ad                	li	a7,11
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 328:	48b1                	li	a7,12
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 330:	48b5                	li	a7,13
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 338:	48b9                	li	a7,14
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <trace>:
.global trace
trace:
 li a7, SYS_trace
 340:	48d9                	li	a7,22
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <socket>:
.global socket
socket:
 li a7, SYS_socket
 348:	48e1                	li	a7,24
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <gettimeofday>:
.global gettimeofday
gettimeofday:
 li a7, SYS_gettimeofday
 350:	48e5                	li	a7,25
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 358:	48e9                	li	a7,26
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 360:	1101                	addi	sp,sp,-32
 362:	ec06                	sd	ra,24(sp)
 364:	e822                	sd	s0,16(sp)
 366:	1000                	addi	s0,sp,32
 368:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 36c:	4605                	li	a2,1
 36e:	fef40593          	addi	a1,s0,-17
 372:	f4fff0ef          	jal	2c0 <write>
}
 376:	60e2                	ld	ra,24(sp)
 378:	6442                	ld	s0,16(sp)
 37a:	6105                	addi	sp,sp,32
 37c:	8082                	ret

000000000000037e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 37e:	7139                	addi	sp,sp,-64
 380:	fc06                	sd	ra,56(sp)
 382:	f822                	sd	s0,48(sp)
 384:	f426                	sd	s1,40(sp)
 386:	0080                	addi	s0,sp,64
 388:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 38a:	c299                	beqz	a3,390 <printint+0x12>
 38c:	0805c963          	bltz	a1,41e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 390:	2581                	sext.w	a1,a1
  neg = 0;
 392:	4881                	li	a7,0
 394:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 398:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 39a:	2601                	sext.w	a2,a2
 39c:	00000517          	auipc	a0,0x0
 3a0:	50450513          	addi	a0,a0,1284 # 8a0 <digits>
 3a4:	883a                	mv	a6,a4
 3a6:	2705                	addiw	a4,a4,1
 3a8:	02c5f7bb          	remuw	a5,a1,a2
 3ac:	1782                	slli	a5,a5,0x20
 3ae:	9381                	srli	a5,a5,0x20
 3b0:	97aa                	add	a5,a5,a0
 3b2:	0007c783          	lbu	a5,0(a5)
 3b6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ba:	0005879b          	sext.w	a5,a1
 3be:	02c5d5bb          	divuw	a1,a1,a2
 3c2:	0685                	addi	a3,a3,1
 3c4:	fec7f0e3          	bgeu	a5,a2,3a4 <printint+0x26>
  if(neg)
 3c8:	00088c63          	beqz	a7,3e0 <printint+0x62>
    buf[i++] = '-';
 3cc:	fd070793          	addi	a5,a4,-48
 3d0:	00878733          	add	a4,a5,s0
 3d4:	02d00793          	li	a5,45
 3d8:	fef70823          	sb	a5,-16(a4)
 3dc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3e0:	02e05a63          	blez	a4,414 <printint+0x96>
 3e4:	f04a                	sd	s2,32(sp)
 3e6:	ec4e                	sd	s3,24(sp)
 3e8:	fc040793          	addi	a5,s0,-64
 3ec:	00e78933          	add	s2,a5,a4
 3f0:	fff78993          	addi	s3,a5,-1
 3f4:	99ba                	add	s3,s3,a4
 3f6:	377d                	addiw	a4,a4,-1
 3f8:	1702                	slli	a4,a4,0x20
 3fa:	9301                	srli	a4,a4,0x20
 3fc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 400:	fff94583          	lbu	a1,-1(s2)
 404:	8526                	mv	a0,s1
 406:	f5bff0ef          	jal	360 <putc>
  while(--i >= 0)
 40a:	197d                	addi	s2,s2,-1
 40c:	ff391ae3          	bne	s2,s3,400 <printint+0x82>
 410:	7902                	ld	s2,32(sp)
 412:	69e2                	ld	s3,24(sp)
}
 414:	70e2                	ld	ra,56(sp)
 416:	7442                	ld	s0,48(sp)
 418:	74a2                	ld	s1,40(sp)
 41a:	6121                	addi	sp,sp,64
 41c:	8082                	ret
    x = -xx;
 41e:	40b005bb          	negw	a1,a1
    neg = 1;
 422:	4885                	li	a7,1
    x = -xx;
 424:	bf85                	j	394 <printint+0x16>

0000000000000426 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 426:	711d                	addi	sp,sp,-96
 428:	ec86                	sd	ra,88(sp)
 42a:	e8a2                	sd	s0,80(sp)
 42c:	e0ca                	sd	s2,64(sp)
 42e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 430:	0005c903          	lbu	s2,0(a1)
 434:	26090863          	beqz	s2,6a4 <vprintf+0x27e>
 438:	e4a6                	sd	s1,72(sp)
 43a:	fc4e                	sd	s3,56(sp)
 43c:	f852                	sd	s4,48(sp)
 43e:	f456                	sd	s5,40(sp)
 440:	f05a                	sd	s6,32(sp)
 442:	ec5e                	sd	s7,24(sp)
 444:	e862                	sd	s8,16(sp)
 446:	e466                	sd	s9,8(sp)
 448:	8b2a                	mv	s6,a0
 44a:	8a2e                	mv	s4,a1
 44c:	8bb2                	mv	s7,a2
  state = 0;
 44e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 450:	4481                	li	s1,0
 452:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 454:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 458:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 45c:	06c00c93          	li	s9,108
 460:	a005                	j	480 <vprintf+0x5a>
        putc(fd, c0);
 462:	85ca                	mv	a1,s2
 464:	855a                	mv	a0,s6
 466:	efbff0ef          	jal	360 <putc>
 46a:	a019                	j	470 <vprintf+0x4a>
    } else if(state == '%'){
 46c:	03598263          	beq	s3,s5,490 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 470:	2485                	addiw	s1,s1,1
 472:	8726                	mv	a4,s1
 474:	009a07b3          	add	a5,s4,s1
 478:	0007c903          	lbu	s2,0(a5)
 47c:	20090c63          	beqz	s2,694 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 480:	0009079b          	sext.w	a5,s2
    if(state == 0){
 484:	fe0994e3          	bnez	s3,46c <vprintf+0x46>
      if(c0 == '%'){
 488:	fd579de3          	bne	a5,s5,462 <vprintf+0x3c>
        state = '%';
 48c:	89be                	mv	s3,a5
 48e:	b7cd                	j	470 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 490:	00ea06b3          	add	a3,s4,a4
 494:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 498:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 49a:	c681                	beqz	a3,4a2 <vprintf+0x7c>
 49c:	9752                	add	a4,a4,s4
 49e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4a2:	03878f63          	beq	a5,s8,4e0 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4a6:	05978963          	beq	a5,s9,4f8 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4aa:	07500713          	li	a4,117
 4ae:	0ee78363          	beq	a5,a4,594 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4b2:	07800713          	li	a4,120
 4b6:	12e78563          	beq	a5,a4,5e0 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4ba:	07000713          	li	a4,112
 4be:	14e78a63          	beq	a5,a4,612 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4c2:	07300713          	li	a4,115
 4c6:	18e78a63          	beq	a5,a4,65a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4ca:	02500713          	li	a4,37
 4ce:	04e79563          	bne	a5,a4,518 <vprintf+0xf2>
        putc(fd, '%');
 4d2:	02500593          	li	a1,37
 4d6:	855a                	mv	a0,s6
 4d8:	e89ff0ef          	jal	360 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4dc:	4981                	li	s3,0
 4de:	bf49                	j	470 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4e0:	008b8913          	addi	s2,s7,8
 4e4:	4685                	li	a3,1
 4e6:	4629                	li	a2,10
 4e8:	000ba583          	lw	a1,0(s7)
 4ec:	855a                	mv	a0,s6
 4ee:	e91ff0ef          	jal	37e <printint>
 4f2:	8bca                	mv	s7,s2
      state = 0;
 4f4:	4981                	li	s3,0
 4f6:	bfad                	j	470 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4f8:	06400793          	li	a5,100
 4fc:	02f68963          	beq	a3,a5,52e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 500:	06c00793          	li	a5,108
 504:	04f68263          	beq	a3,a5,548 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 508:	07500793          	li	a5,117
 50c:	0af68063          	beq	a3,a5,5ac <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 510:	07800793          	li	a5,120
 514:	0ef68263          	beq	a3,a5,5f8 <vprintf+0x1d2>
        putc(fd, '%');
 518:	02500593          	li	a1,37
 51c:	855a                	mv	a0,s6
 51e:	e43ff0ef          	jal	360 <putc>
        putc(fd, c0);
 522:	85ca                	mv	a1,s2
 524:	855a                	mv	a0,s6
 526:	e3bff0ef          	jal	360 <putc>
      state = 0;
 52a:	4981                	li	s3,0
 52c:	b791                	j	470 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 52e:	008b8913          	addi	s2,s7,8
 532:	4685                	li	a3,1
 534:	4629                	li	a2,10
 536:	000ba583          	lw	a1,0(s7)
 53a:	855a                	mv	a0,s6
 53c:	e43ff0ef          	jal	37e <printint>
        i += 1;
 540:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 542:	8bca                	mv	s7,s2
      state = 0;
 544:	4981                	li	s3,0
        i += 1;
 546:	b72d                	j	470 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 548:	06400793          	li	a5,100
 54c:	02f60763          	beq	a2,a5,57a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 550:	07500793          	li	a5,117
 554:	06f60963          	beq	a2,a5,5c6 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 558:	07800793          	li	a5,120
 55c:	faf61ee3          	bne	a2,a5,518 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 560:	008b8913          	addi	s2,s7,8
 564:	4681                	li	a3,0
 566:	4641                	li	a2,16
 568:	000ba583          	lw	a1,0(s7)
 56c:	855a                	mv	a0,s6
 56e:	e11ff0ef          	jal	37e <printint>
        i += 2;
 572:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 574:	8bca                	mv	s7,s2
      state = 0;
 576:	4981                	li	s3,0
        i += 2;
 578:	bde5                	j	470 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 57a:	008b8913          	addi	s2,s7,8
 57e:	4685                	li	a3,1
 580:	4629                	li	a2,10
 582:	000ba583          	lw	a1,0(s7)
 586:	855a                	mv	a0,s6
 588:	df7ff0ef          	jal	37e <printint>
        i += 2;
 58c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 58e:	8bca                	mv	s7,s2
      state = 0;
 590:	4981                	li	s3,0
        i += 2;
 592:	bdf9                	j	470 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 594:	008b8913          	addi	s2,s7,8
 598:	4681                	li	a3,0
 59a:	4629                	li	a2,10
 59c:	000ba583          	lw	a1,0(s7)
 5a0:	855a                	mv	a0,s6
 5a2:	dddff0ef          	jal	37e <printint>
 5a6:	8bca                	mv	s7,s2
      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	b5d9                	j	470 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ac:	008b8913          	addi	s2,s7,8
 5b0:	4681                	li	a3,0
 5b2:	4629                	li	a2,10
 5b4:	000ba583          	lw	a1,0(s7)
 5b8:	855a                	mv	a0,s6
 5ba:	dc5ff0ef          	jal	37e <printint>
        i += 1;
 5be:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c0:	8bca                	mv	s7,s2
      state = 0;
 5c2:	4981                	li	s3,0
        i += 1;
 5c4:	b575                	j	470 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c6:	008b8913          	addi	s2,s7,8
 5ca:	4681                	li	a3,0
 5cc:	4629                	li	a2,10
 5ce:	000ba583          	lw	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	dabff0ef          	jal	37e <printint>
        i += 2;
 5d8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5da:	8bca                	mv	s7,s2
      state = 0;
 5dc:	4981                	li	s3,0
        i += 2;
 5de:	bd49                	j	470 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5e0:	008b8913          	addi	s2,s7,8
 5e4:	4681                	li	a3,0
 5e6:	4641                	li	a2,16
 5e8:	000ba583          	lw	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	d91ff0ef          	jal	37e <printint>
 5f2:	8bca                	mv	s7,s2
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	bdad                	j	470 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f8:	008b8913          	addi	s2,s7,8
 5fc:	4681                	li	a3,0
 5fe:	4641                	li	a2,16
 600:	000ba583          	lw	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	d79ff0ef          	jal	37e <printint>
        i += 1;
 60a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 60c:	8bca                	mv	s7,s2
      state = 0;
 60e:	4981                	li	s3,0
        i += 1;
 610:	b585                	j	470 <vprintf+0x4a>
 612:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 614:	008b8d13          	addi	s10,s7,8
 618:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 61c:	03000593          	li	a1,48
 620:	855a                	mv	a0,s6
 622:	d3fff0ef          	jal	360 <putc>
  putc(fd, 'x');
 626:	07800593          	li	a1,120
 62a:	855a                	mv	a0,s6
 62c:	d35ff0ef          	jal	360 <putc>
 630:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 632:	00000b97          	auipc	s7,0x0
 636:	26eb8b93          	addi	s7,s7,622 # 8a0 <digits>
 63a:	03c9d793          	srli	a5,s3,0x3c
 63e:	97de                	add	a5,a5,s7
 640:	0007c583          	lbu	a1,0(a5)
 644:	855a                	mv	a0,s6
 646:	d1bff0ef          	jal	360 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 64a:	0992                	slli	s3,s3,0x4
 64c:	397d                	addiw	s2,s2,-1
 64e:	fe0916e3          	bnez	s2,63a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 652:	8bea                	mv	s7,s10
      state = 0;
 654:	4981                	li	s3,0
 656:	6d02                	ld	s10,0(sp)
 658:	bd21                	j	470 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 65a:	008b8993          	addi	s3,s7,8
 65e:	000bb903          	ld	s2,0(s7)
 662:	00090f63          	beqz	s2,680 <vprintf+0x25a>
        for(; *s; s++)
 666:	00094583          	lbu	a1,0(s2)
 66a:	c195                	beqz	a1,68e <vprintf+0x268>
          putc(fd, *s);
 66c:	855a                	mv	a0,s6
 66e:	cf3ff0ef          	jal	360 <putc>
        for(; *s; s++)
 672:	0905                	addi	s2,s2,1
 674:	00094583          	lbu	a1,0(s2)
 678:	f9f5                	bnez	a1,66c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 67a:	8bce                	mv	s7,s3
      state = 0;
 67c:	4981                	li	s3,0
 67e:	bbcd                	j	470 <vprintf+0x4a>
          s = "(null)";
 680:	00000917          	auipc	s2,0x0
 684:	21890913          	addi	s2,s2,536 # 898 <malloc+0x10c>
        for(; *s; s++)
 688:	02800593          	li	a1,40
 68c:	b7c5                	j	66c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 68e:	8bce                	mv	s7,s3
      state = 0;
 690:	4981                	li	s3,0
 692:	bbf9                	j	470 <vprintf+0x4a>
 694:	64a6                	ld	s1,72(sp)
 696:	79e2                	ld	s3,56(sp)
 698:	7a42                	ld	s4,48(sp)
 69a:	7aa2                	ld	s5,40(sp)
 69c:	7b02                	ld	s6,32(sp)
 69e:	6be2                	ld	s7,24(sp)
 6a0:	6c42                	ld	s8,16(sp)
 6a2:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6a4:	60e6                	ld	ra,88(sp)
 6a6:	6446                	ld	s0,80(sp)
 6a8:	6906                	ld	s2,64(sp)
 6aa:	6125                	addi	sp,sp,96
 6ac:	8082                	ret

00000000000006ae <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ae:	715d                	addi	sp,sp,-80
 6b0:	ec06                	sd	ra,24(sp)
 6b2:	e822                	sd	s0,16(sp)
 6b4:	1000                	addi	s0,sp,32
 6b6:	e010                	sd	a2,0(s0)
 6b8:	e414                	sd	a3,8(s0)
 6ba:	e818                	sd	a4,16(s0)
 6bc:	ec1c                	sd	a5,24(s0)
 6be:	03043023          	sd	a6,32(s0)
 6c2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6c6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ca:	8622                	mv	a2,s0
 6cc:	d5bff0ef          	jal	426 <vprintf>
}
 6d0:	60e2                	ld	ra,24(sp)
 6d2:	6442                	ld	s0,16(sp)
 6d4:	6161                	addi	sp,sp,80
 6d6:	8082                	ret

00000000000006d8 <printf>:

void
printf(const char *fmt, ...)
{
 6d8:	711d                	addi	sp,sp,-96
 6da:	ec06                	sd	ra,24(sp)
 6dc:	e822                	sd	s0,16(sp)
 6de:	1000                	addi	s0,sp,32
 6e0:	e40c                	sd	a1,8(s0)
 6e2:	e810                	sd	a2,16(s0)
 6e4:	ec14                	sd	a3,24(s0)
 6e6:	f018                	sd	a4,32(s0)
 6e8:	f41c                	sd	a5,40(s0)
 6ea:	03043823          	sd	a6,48(s0)
 6ee:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6f2:	00840613          	addi	a2,s0,8
 6f6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6fa:	85aa                	mv	a1,a0
 6fc:	4505                	li	a0,1
 6fe:	d29ff0ef          	jal	426 <vprintf>
}
 702:	60e2                	ld	ra,24(sp)
 704:	6442                	ld	s0,16(sp)
 706:	6125                	addi	sp,sp,96
 708:	8082                	ret

000000000000070a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 70a:	1141                	addi	sp,sp,-16
 70c:	e422                	sd	s0,8(sp)
 70e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 710:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 714:	00001797          	auipc	a5,0x1
 718:	8ec7b783          	ld	a5,-1812(a5) # 1000 <freep>
 71c:	a02d                	j	746 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 71e:	4618                	lw	a4,8(a2)
 720:	9f2d                	addw	a4,a4,a1
 722:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 726:	6398                	ld	a4,0(a5)
 728:	6310                	ld	a2,0(a4)
 72a:	a83d                	j	768 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 72c:	ff852703          	lw	a4,-8(a0)
 730:	9f31                	addw	a4,a4,a2
 732:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 734:	ff053683          	ld	a3,-16(a0)
 738:	a091                	j	77c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73a:	6398                	ld	a4,0(a5)
 73c:	00e7e463          	bltu	a5,a4,744 <free+0x3a>
 740:	00e6ea63          	bltu	a3,a4,754 <free+0x4a>
{
 744:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 746:	fed7fae3          	bgeu	a5,a3,73a <free+0x30>
 74a:	6398                	ld	a4,0(a5)
 74c:	00e6e463          	bltu	a3,a4,754 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 750:	fee7eae3          	bltu	a5,a4,744 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 754:	ff852583          	lw	a1,-8(a0)
 758:	6390                	ld	a2,0(a5)
 75a:	02059813          	slli	a6,a1,0x20
 75e:	01c85713          	srli	a4,a6,0x1c
 762:	9736                	add	a4,a4,a3
 764:	fae60de3          	beq	a2,a4,71e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 768:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 76c:	4790                	lw	a2,8(a5)
 76e:	02061593          	slli	a1,a2,0x20
 772:	01c5d713          	srli	a4,a1,0x1c
 776:	973e                	add	a4,a4,a5
 778:	fae68ae3          	beq	a3,a4,72c <free+0x22>
    p->s.ptr = bp->s.ptr;
 77c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 77e:	00001717          	auipc	a4,0x1
 782:	88f73123          	sd	a5,-1918(a4) # 1000 <freep>
}
 786:	6422                	ld	s0,8(sp)
 788:	0141                	addi	sp,sp,16
 78a:	8082                	ret

000000000000078c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 78c:	7139                	addi	sp,sp,-64
 78e:	fc06                	sd	ra,56(sp)
 790:	f822                	sd	s0,48(sp)
 792:	f426                	sd	s1,40(sp)
 794:	ec4e                	sd	s3,24(sp)
 796:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 798:	02051493          	slli	s1,a0,0x20
 79c:	9081                	srli	s1,s1,0x20
 79e:	04bd                	addi	s1,s1,15
 7a0:	8091                	srli	s1,s1,0x4
 7a2:	0014899b          	addiw	s3,s1,1
 7a6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7a8:	00001517          	auipc	a0,0x1
 7ac:	85853503          	ld	a0,-1960(a0) # 1000 <freep>
 7b0:	c915                	beqz	a0,7e4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b4:	4798                	lw	a4,8(a5)
 7b6:	08977a63          	bgeu	a4,s1,84a <malloc+0xbe>
 7ba:	f04a                	sd	s2,32(sp)
 7bc:	e852                	sd	s4,16(sp)
 7be:	e456                	sd	s5,8(sp)
 7c0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7c2:	8a4e                	mv	s4,s3
 7c4:	0009871b          	sext.w	a4,s3
 7c8:	6685                	lui	a3,0x1
 7ca:	00d77363          	bgeu	a4,a3,7d0 <malloc+0x44>
 7ce:	6a05                	lui	s4,0x1
 7d0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7d4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7d8:	00001917          	auipc	s2,0x1
 7dc:	82890913          	addi	s2,s2,-2008 # 1000 <freep>
  if(p == (char*)-1)
 7e0:	5afd                	li	s5,-1
 7e2:	a081                	j	822 <malloc+0x96>
 7e4:	f04a                	sd	s2,32(sp)
 7e6:	e852                	sd	s4,16(sp)
 7e8:	e456                	sd	s5,8(sp)
 7ea:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7ec:	00001797          	auipc	a5,0x1
 7f0:	82478793          	addi	a5,a5,-2012 # 1010 <base>
 7f4:	00001717          	auipc	a4,0x1
 7f8:	80f73623          	sd	a5,-2036(a4) # 1000 <freep>
 7fc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7fe:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 802:	b7c1                	j	7c2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 804:	6398                	ld	a4,0(a5)
 806:	e118                	sd	a4,0(a0)
 808:	a8a9                	j	862 <malloc+0xd6>
  hp->s.size = nu;
 80a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 80e:	0541                	addi	a0,a0,16
 810:	efbff0ef          	jal	70a <free>
  return freep;
 814:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 818:	c12d                	beqz	a0,87a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81c:	4798                	lw	a4,8(a5)
 81e:	02977263          	bgeu	a4,s1,842 <malloc+0xb6>
    if(p == freep)
 822:	00093703          	ld	a4,0(s2)
 826:	853e                	mv	a0,a5
 828:	fef719e3          	bne	a4,a5,81a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 82c:	8552                	mv	a0,s4
 82e:	afbff0ef          	jal	328 <sbrk>
  if(p == (char*)-1)
 832:	fd551ce3          	bne	a0,s5,80a <malloc+0x7e>
        return 0;
 836:	4501                	li	a0,0
 838:	7902                	ld	s2,32(sp)
 83a:	6a42                	ld	s4,16(sp)
 83c:	6aa2                	ld	s5,8(sp)
 83e:	6b02                	ld	s6,0(sp)
 840:	a03d                	j	86e <malloc+0xe2>
 842:	7902                	ld	s2,32(sp)
 844:	6a42                	ld	s4,16(sp)
 846:	6aa2                	ld	s5,8(sp)
 848:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 84a:	fae48de3          	beq	s1,a4,804 <malloc+0x78>
        p->s.size -= nunits;
 84e:	4137073b          	subw	a4,a4,s3
 852:	c798                	sw	a4,8(a5)
        p += p->s.size;
 854:	02071693          	slli	a3,a4,0x20
 858:	01c6d713          	srli	a4,a3,0x1c
 85c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 85e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 862:	00000717          	auipc	a4,0x0
 866:	78a73f23          	sd	a0,1950(a4) # 1000 <freep>
      return (void*)(p + 1);
 86a:	01078513          	addi	a0,a5,16
  }
}
 86e:	70e2                	ld	ra,56(sp)
 870:	7442                	ld	s0,48(sp)
 872:	74a2                	ld	s1,40(sp)
 874:	69e2                	ld	s3,24(sp)
 876:	6121                	addi	sp,sp,64
 878:	8082                	ret
 87a:	7902                	ld	s2,32(sp)
 87c:	6a42                	ld	s4,16(sp)
 87e:	6aa2                	ld	s5,8(sp)
 880:	6b02                	ld	s6,0(sp)
 882:	b7f5                	j	86e <malloc+0xe2>
