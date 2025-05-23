
user/_secret:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/riscv.h"


int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  if(argc != 2){
   8:	4789                	li	a5,2
   a:	00f50d63          	beq	a0,a5,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
    printf("Usage: secret the-secret\n");
  12:	00001517          	auipc	a0,0x1
  16:	8ae50513          	addi	a0,a0,-1874 # 8c0 <malloc+0x106>
  1a:	6ec000ef          	jal	706 <printf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	2a6000ef          	jal	2c6 <exit>
  24:	e426                	sd	s1,8(sp)
  26:	e04a                	sd	s2,0(sp)
  28:	84ae                	mv	s1,a1
  }
  char *end = sbrk(PGSIZE*32);
  2a:	00020537          	lui	a0,0x20
  2e:	318000ef          	jal	346 <sbrk>
  32:	892a                	mv	s2,a0
  end = end + 9 * PGSIZE;
  strcpy(end, "my very very very secret pw is:   ");
  34:	02300613          	li	a2,35
  38:	00001597          	auipc	a1,0x1
  3c:	8a858593          	addi	a1,a1,-1880 # 8e0 <malloc+0x126>
  40:	6525                	lui	a0,0x9
  42:	954a                	add	a0,a0,s2
  44:	266000ef          	jal	2aa <memcpy>
  strcpy(end+32, argv[1]);
  48:	6525                	lui	a0,0x9
  4a:	02050513          	addi	a0,a0,32 # 9020 <base+0x8010>
  4e:	648c                	ld	a1,8(s1)
  50:	954a                	add	a0,a0,s2
  52:	01c000ef          	jal	6e <strcpy>
  exit(0);
  56:	4501                	li	a0,0
  58:	26e000ef          	jal	2c6 <exit>

000000000000005c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  5c:	1141                	addi	sp,sp,-16
  5e:	e406                	sd	ra,8(sp)
  60:	e022                	sd	s0,0(sp)
  62:	0800                	addi	s0,sp,16
  extern int main();
  main();
  64:	f9dff0ef          	jal	0 <main>
  exit(0);
  68:	4501                	li	a0,0
  6a:	25c000ef          	jal	2c6 <exit>

000000000000006e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  6e:	1141                	addi	sp,sp,-16
  70:	e422                	sd	s0,8(sp)
  72:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  74:	87aa                	mv	a5,a0
  76:	0585                	addi	a1,a1,1
  78:	0785                	addi	a5,a5,1
  7a:	fff5c703          	lbu	a4,-1(a1)
  7e:	fee78fa3          	sb	a4,-1(a5)
  82:	fb75                	bnez	a4,76 <strcpy+0x8>
    ;
  return os;
}
  84:	6422                	ld	s0,8(sp)
  86:	0141                	addi	sp,sp,16
  88:	8082                	ret

000000000000008a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8a:	1141                	addi	sp,sp,-16
  8c:	e422                	sd	s0,8(sp)
  8e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  90:	00054783          	lbu	a5,0(a0)
  94:	cb91                	beqz	a5,a8 <strcmp+0x1e>
  96:	0005c703          	lbu	a4,0(a1)
  9a:	00f71763          	bne	a4,a5,a8 <strcmp+0x1e>
    p++, q++;
  9e:	0505                	addi	a0,a0,1
  a0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a2:	00054783          	lbu	a5,0(a0)
  a6:	fbe5                	bnez	a5,96 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  a8:	0005c503          	lbu	a0,0(a1)
}
  ac:	40a7853b          	subw	a0,a5,a0
  b0:	6422                	ld	s0,8(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret

00000000000000b6 <strlen>:

uint
strlen(const char *s)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  bc:	00054783          	lbu	a5,0(a0)
  c0:	cf91                	beqz	a5,dc <strlen+0x26>
  c2:	0505                	addi	a0,a0,1
  c4:	87aa                	mv	a5,a0
  c6:	86be                	mv	a3,a5
  c8:	0785                	addi	a5,a5,1
  ca:	fff7c703          	lbu	a4,-1(a5)
  ce:	ff65                	bnez	a4,c6 <strlen+0x10>
  d0:	40a6853b          	subw	a0,a3,a0
  d4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  d6:	6422                	ld	s0,8(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret
  for(n = 0; s[n]; n++)
  dc:	4501                	li	a0,0
  de:	bfe5                	j	d6 <strlen+0x20>

00000000000000e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e0:	1141                	addi	sp,sp,-16
  e2:	e422                	sd	s0,8(sp)
  e4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e6:	ca19                	beqz	a2,fc <memset+0x1c>
  e8:	87aa                	mv	a5,a0
  ea:	1602                	slli	a2,a2,0x20
  ec:	9201                	srli	a2,a2,0x20
  ee:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f6:	0785                	addi	a5,a5,1
  f8:	fee79de3          	bne	a5,a4,f2 <memset+0x12>
  }
  return dst;
}
  fc:	6422                	ld	s0,8(sp)
  fe:	0141                	addi	sp,sp,16
 100:	8082                	ret

0000000000000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	1141                	addi	sp,sp,-16
 104:	e422                	sd	s0,8(sp)
 106:	0800                	addi	s0,sp,16
  for(; *s; s++)
 108:	00054783          	lbu	a5,0(a0)
 10c:	cb99                	beqz	a5,122 <strchr+0x20>
    if(*s == c)
 10e:	00f58763          	beq	a1,a5,11c <strchr+0x1a>
  for(; *s; s++)
 112:	0505                	addi	a0,a0,1
 114:	00054783          	lbu	a5,0(a0)
 118:	fbfd                	bnez	a5,10e <strchr+0xc>
      return (char*)s;
  return 0;
 11a:	4501                	li	a0,0
}
 11c:	6422                	ld	s0,8(sp)
 11e:	0141                	addi	sp,sp,16
 120:	8082                	ret
  return 0;
 122:	4501                	li	a0,0
 124:	bfe5                	j	11c <strchr+0x1a>

0000000000000126 <gets>:

char*
gets(char *buf, int max)
{
 126:	711d                	addi	sp,sp,-96
 128:	ec86                	sd	ra,88(sp)
 12a:	e8a2                	sd	s0,80(sp)
 12c:	e4a6                	sd	s1,72(sp)
 12e:	e0ca                	sd	s2,64(sp)
 130:	fc4e                	sd	s3,56(sp)
 132:	f852                	sd	s4,48(sp)
 134:	f456                	sd	s5,40(sp)
 136:	f05a                	sd	s6,32(sp)
 138:	ec5e                	sd	s7,24(sp)
 13a:	1080                	addi	s0,sp,96
 13c:	8baa                	mv	s7,a0
 13e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 140:	892a                	mv	s2,a0
 142:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 144:	4aa9                	li	s5,10
 146:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 148:	89a6                	mv	s3,s1
 14a:	2485                	addiw	s1,s1,1
 14c:	0344d663          	bge	s1,s4,178 <gets+0x52>
    cc = read(0, &c, 1);
 150:	4605                	li	a2,1
 152:	faf40593          	addi	a1,s0,-81
 156:	4501                	li	a0,0
 158:	186000ef          	jal	2de <read>
    if(cc < 1)
 15c:	00a05e63          	blez	a0,178 <gets+0x52>
    buf[i++] = c;
 160:	faf44783          	lbu	a5,-81(s0)
 164:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 168:	01578763          	beq	a5,s5,176 <gets+0x50>
 16c:	0905                	addi	s2,s2,1
 16e:	fd679de3          	bne	a5,s6,148 <gets+0x22>
    buf[i++] = c;
 172:	89a6                	mv	s3,s1
 174:	a011                	j	178 <gets+0x52>
 176:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 178:	99de                	add	s3,s3,s7
 17a:	00098023          	sb	zero,0(s3)
  return buf;
}
 17e:	855e                	mv	a0,s7
 180:	60e6                	ld	ra,88(sp)
 182:	6446                	ld	s0,80(sp)
 184:	64a6                	ld	s1,72(sp)
 186:	6906                	ld	s2,64(sp)
 188:	79e2                	ld	s3,56(sp)
 18a:	7a42                	ld	s4,48(sp)
 18c:	7aa2                	ld	s5,40(sp)
 18e:	7b02                	ld	s6,32(sp)
 190:	6be2                	ld	s7,24(sp)
 192:	6125                	addi	sp,sp,96
 194:	8082                	ret

0000000000000196 <stat>:

int
stat(const char *n, struct stat *st)
{
 196:	1101                	addi	sp,sp,-32
 198:	ec06                	sd	ra,24(sp)
 19a:	e822                	sd	s0,16(sp)
 19c:	e04a                	sd	s2,0(sp)
 19e:	1000                	addi	s0,sp,32
 1a0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a2:	4581                	li	a1,0
 1a4:	15a000ef          	jal	2fe <open>
  if(fd < 0)
 1a8:	02054263          	bltz	a0,1cc <stat+0x36>
 1ac:	e426                	sd	s1,8(sp)
 1ae:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b0:	85ca                	mv	a1,s2
 1b2:	164000ef          	jal	316 <fstat>
 1b6:	892a                	mv	s2,a0
  close(fd);
 1b8:	8526                	mv	a0,s1
 1ba:	1a4000ef          	jal	35e <close>
  return r;
 1be:	64a2                	ld	s1,8(sp)
}
 1c0:	854a                	mv	a0,s2
 1c2:	60e2                	ld	ra,24(sp)
 1c4:	6442                	ld	s0,16(sp)
 1c6:	6902                	ld	s2,0(sp)
 1c8:	6105                	addi	sp,sp,32
 1ca:	8082                	ret
    return -1;
 1cc:	597d                	li	s2,-1
 1ce:	bfcd                	j	1c0 <stat+0x2a>

00000000000001d0 <atoi>:

int
atoi(const char *s)
{
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e422                	sd	s0,8(sp)
 1d4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d6:	00054683          	lbu	a3,0(a0)
 1da:	fd06879b          	addiw	a5,a3,-48
 1de:	0ff7f793          	zext.b	a5,a5
 1e2:	4625                	li	a2,9
 1e4:	02f66863          	bltu	a2,a5,214 <atoi+0x44>
 1e8:	872a                	mv	a4,a0
  n = 0;
 1ea:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ec:	0705                	addi	a4,a4,1
 1ee:	0025179b          	slliw	a5,a0,0x2
 1f2:	9fa9                	addw	a5,a5,a0
 1f4:	0017979b          	slliw	a5,a5,0x1
 1f8:	9fb5                	addw	a5,a5,a3
 1fa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1fe:	00074683          	lbu	a3,0(a4)
 202:	fd06879b          	addiw	a5,a3,-48
 206:	0ff7f793          	zext.b	a5,a5
 20a:	fef671e3          	bgeu	a2,a5,1ec <atoi+0x1c>
  return n;
}
 20e:	6422                	ld	s0,8(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret
  n = 0;
 214:	4501                	li	a0,0
 216:	bfe5                	j	20e <atoi+0x3e>

0000000000000218 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e422                	sd	s0,8(sp)
 21c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 21e:	02b57463          	bgeu	a0,a1,246 <memmove+0x2e>
    while(n-- > 0)
 222:	00c05f63          	blez	a2,240 <memmove+0x28>
 226:	1602                	slli	a2,a2,0x20
 228:	9201                	srli	a2,a2,0x20
 22a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 22e:	872a                	mv	a4,a0
      *dst++ = *src++;
 230:	0585                	addi	a1,a1,1
 232:	0705                	addi	a4,a4,1
 234:	fff5c683          	lbu	a3,-1(a1)
 238:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 23c:	fef71ae3          	bne	a4,a5,230 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 240:	6422                	ld	s0,8(sp)
 242:	0141                	addi	sp,sp,16
 244:	8082                	ret
    dst += n;
 246:	00c50733          	add	a4,a0,a2
    src += n;
 24a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 24c:	fec05ae3          	blez	a2,240 <memmove+0x28>
 250:	fff6079b          	addiw	a5,a2,-1
 254:	1782                	slli	a5,a5,0x20
 256:	9381                	srli	a5,a5,0x20
 258:	fff7c793          	not	a5,a5
 25c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 25e:	15fd                	addi	a1,a1,-1
 260:	177d                	addi	a4,a4,-1
 262:	0005c683          	lbu	a3,0(a1)
 266:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 26a:	fee79ae3          	bne	a5,a4,25e <memmove+0x46>
 26e:	bfc9                	j	240 <memmove+0x28>

0000000000000270 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 270:	1141                	addi	sp,sp,-16
 272:	e422                	sd	s0,8(sp)
 274:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 276:	ca05                	beqz	a2,2a6 <memcmp+0x36>
 278:	fff6069b          	addiw	a3,a2,-1
 27c:	1682                	slli	a3,a3,0x20
 27e:	9281                	srli	a3,a3,0x20
 280:	0685                	addi	a3,a3,1
 282:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 284:	00054783          	lbu	a5,0(a0)
 288:	0005c703          	lbu	a4,0(a1)
 28c:	00e79863          	bne	a5,a4,29c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 290:	0505                	addi	a0,a0,1
    p2++;
 292:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 294:	fed518e3          	bne	a0,a3,284 <memcmp+0x14>
  }
  return 0;
 298:	4501                	li	a0,0
 29a:	a019                	j	2a0 <memcmp+0x30>
      return *p1 - *p2;
 29c:	40e7853b          	subw	a0,a5,a4
}
 2a0:	6422                	ld	s0,8(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret
  return 0;
 2a6:	4501                	li	a0,0
 2a8:	bfe5                	j	2a0 <memcmp+0x30>

00000000000002aa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2b2:	f67ff0ef          	jal	218 <memmove>
}
 2b6:	60a2                	ld	ra,8(sp)
 2b8:	6402                	ld	s0,0(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret

00000000000002be <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2be:	4885                	li	a7,1
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c6:	4889                	li	a7,2
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ce:	488d                	li	a7,3
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2d6:	4891                	li	a7,4
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <read>:
.global read
read:
 li a7, SYS_read
 2de:	4895                	li	a7,5
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <write>:
.global write
write:
 li a7, SYS_write
 2e6:	48c1                	li	a7,16
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ee:	4899                	li	a7,6
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f6:	489d                	li	a7,7
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <open>:
.global open
open:
 li a7, SYS_open
 2fe:	48bd                	li	a7,15
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 306:	48c5                	li	a7,17
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 30e:	48c9                	li	a7,18
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 316:	48a1                	li	a7,8
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <link>:
.global link
link:
 li a7, SYS_link
 31e:	48cd                	li	a7,19
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 326:	48d1                	li	a7,20
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 32e:	48a5                	li	a7,9
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <dup>:
.global dup
dup:
 li a7, SYS_dup
 336:	48a9                	li	a7,10
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 33e:	48ad                	li	a7,11
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 346:	48b1                	li	a7,12
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 34e:	48b5                	li	a7,13
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 356:	48b9                	li	a7,14
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <close>:
.global close
close:
 li a7, SYS_close
 35e:	48d5                	li	a7,21
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <trace>:
.global trace
trace:
 li a7, SYS_trace
 366:	48d9                	li	a7,22
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <stats>:
.global stats
stats:
 li a7, SYS_stats
 36e:	48dd                	li	a7,23
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <socket>:
 
.global socket
socket:
 li a7, SYS_socket
 376:	48e1                	li	a7,24
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <gettimeofday>:
.global gettimeofday
gettimeofday:
 li a7, SYS_gettimeofday
 37e:	48e5                	li	a7,25
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 386:	48e9                	li	a7,26
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 38e:	1101                	addi	sp,sp,-32
 390:	ec06                	sd	ra,24(sp)
 392:	e822                	sd	s0,16(sp)
 394:	1000                	addi	s0,sp,32
 396:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 39a:	4605                	li	a2,1
 39c:	fef40593          	addi	a1,s0,-17
 3a0:	f47ff0ef          	jal	2e6 <write>
}
 3a4:	60e2                	ld	ra,24(sp)
 3a6:	6442                	ld	s0,16(sp)
 3a8:	6105                	addi	sp,sp,32
 3aa:	8082                	ret

00000000000003ac <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ac:	7139                	addi	sp,sp,-64
 3ae:	fc06                	sd	ra,56(sp)
 3b0:	f822                	sd	s0,48(sp)
 3b2:	f426                	sd	s1,40(sp)
 3b4:	0080                	addi	s0,sp,64
 3b6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3b8:	c299                	beqz	a3,3be <printint+0x12>
 3ba:	0805c963          	bltz	a1,44c <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3be:	2581                	sext.w	a1,a1
  neg = 0;
 3c0:	4881                	li	a7,0
 3c2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3c6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3c8:	2601                	sext.w	a2,a2
 3ca:	00000517          	auipc	a0,0x0
 3ce:	54650513          	addi	a0,a0,1350 # 910 <digits>
 3d2:	883a                	mv	a6,a4
 3d4:	2705                	addiw	a4,a4,1
 3d6:	02c5f7bb          	remuw	a5,a1,a2
 3da:	1782                	slli	a5,a5,0x20
 3dc:	9381                	srli	a5,a5,0x20
 3de:	97aa                	add	a5,a5,a0
 3e0:	0007c783          	lbu	a5,0(a5)
 3e4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3e8:	0005879b          	sext.w	a5,a1
 3ec:	02c5d5bb          	divuw	a1,a1,a2
 3f0:	0685                	addi	a3,a3,1
 3f2:	fec7f0e3          	bgeu	a5,a2,3d2 <printint+0x26>
  if(neg)
 3f6:	00088c63          	beqz	a7,40e <printint+0x62>
    buf[i++] = '-';
 3fa:	fd070793          	addi	a5,a4,-48
 3fe:	00878733          	add	a4,a5,s0
 402:	02d00793          	li	a5,45
 406:	fef70823          	sb	a5,-16(a4)
 40a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 40e:	02e05a63          	blez	a4,442 <printint+0x96>
 412:	f04a                	sd	s2,32(sp)
 414:	ec4e                	sd	s3,24(sp)
 416:	fc040793          	addi	a5,s0,-64
 41a:	00e78933          	add	s2,a5,a4
 41e:	fff78993          	addi	s3,a5,-1
 422:	99ba                	add	s3,s3,a4
 424:	377d                	addiw	a4,a4,-1
 426:	1702                	slli	a4,a4,0x20
 428:	9301                	srli	a4,a4,0x20
 42a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 42e:	fff94583          	lbu	a1,-1(s2)
 432:	8526                	mv	a0,s1
 434:	f5bff0ef          	jal	38e <putc>
  while(--i >= 0)
 438:	197d                	addi	s2,s2,-1
 43a:	ff391ae3          	bne	s2,s3,42e <printint+0x82>
 43e:	7902                	ld	s2,32(sp)
 440:	69e2                	ld	s3,24(sp)
}
 442:	70e2                	ld	ra,56(sp)
 444:	7442                	ld	s0,48(sp)
 446:	74a2                	ld	s1,40(sp)
 448:	6121                	addi	sp,sp,64
 44a:	8082                	ret
    x = -xx;
 44c:	40b005bb          	negw	a1,a1
    neg = 1;
 450:	4885                	li	a7,1
    x = -xx;
 452:	bf85                	j	3c2 <printint+0x16>

0000000000000454 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 454:	711d                	addi	sp,sp,-96
 456:	ec86                	sd	ra,88(sp)
 458:	e8a2                	sd	s0,80(sp)
 45a:	e0ca                	sd	s2,64(sp)
 45c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 45e:	0005c903          	lbu	s2,0(a1)
 462:	26090863          	beqz	s2,6d2 <vprintf+0x27e>
 466:	e4a6                	sd	s1,72(sp)
 468:	fc4e                	sd	s3,56(sp)
 46a:	f852                	sd	s4,48(sp)
 46c:	f456                	sd	s5,40(sp)
 46e:	f05a                	sd	s6,32(sp)
 470:	ec5e                	sd	s7,24(sp)
 472:	e862                	sd	s8,16(sp)
 474:	e466                	sd	s9,8(sp)
 476:	8b2a                	mv	s6,a0
 478:	8a2e                	mv	s4,a1
 47a:	8bb2                	mv	s7,a2
  state = 0;
 47c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 47e:	4481                	li	s1,0
 480:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 482:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 486:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 48a:	06c00c93          	li	s9,108
 48e:	a005                	j	4ae <vprintf+0x5a>
        putc(fd, c0);
 490:	85ca                	mv	a1,s2
 492:	855a                	mv	a0,s6
 494:	efbff0ef          	jal	38e <putc>
 498:	a019                	j	49e <vprintf+0x4a>
    } else if(state == '%'){
 49a:	03598263          	beq	s3,s5,4be <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 49e:	2485                	addiw	s1,s1,1
 4a0:	8726                	mv	a4,s1
 4a2:	009a07b3          	add	a5,s4,s1
 4a6:	0007c903          	lbu	s2,0(a5)
 4aa:	20090c63          	beqz	s2,6c2 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 4ae:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4b2:	fe0994e3          	bnez	s3,49a <vprintf+0x46>
      if(c0 == '%'){
 4b6:	fd579de3          	bne	a5,s5,490 <vprintf+0x3c>
        state = '%';
 4ba:	89be                	mv	s3,a5
 4bc:	b7cd                	j	49e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4be:	00ea06b3          	add	a3,s4,a4
 4c2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4c6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4c8:	c681                	beqz	a3,4d0 <vprintf+0x7c>
 4ca:	9752                	add	a4,a4,s4
 4cc:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4d0:	03878f63          	beq	a5,s8,50e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4d4:	05978963          	beq	a5,s9,526 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4d8:	07500713          	li	a4,117
 4dc:	0ee78363          	beq	a5,a4,5c2 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4e0:	07800713          	li	a4,120
 4e4:	12e78563          	beq	a5,a4,60e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4e8:	07000713          	li	a4,112
 4ec:	14e78a63          	beq	a5,a4,640 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4f0:	07300713          	li	a4,115
 4f4:	18e78a63          	beq	a5,a4,688 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4f8:	02500713          	li	a4,37
 4fc:	04e79563          	bne	a5,a4,546 <vprintf+0xf2>
        putc(fd, '%');
 500:	02500593          	li	a1,37
 504:	855a                	mv	a0,s6
 506:	e89ff0ef          	jal	38e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 50a:	4981                	li	s3,0
 50c:	bf49                	j	49e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 50e:	008b8913          	addi	s2,s7,8
 512:	4685                	li	a3,1
 514:	4629                	li	a2,10
 516:	000ba583          	lw	a1,0(s7)
 51a:	855a                	mv	a0,s6
 51c:	e91ff0ef          	jal	3ac <printint>
 520:	8bca                	mv	s7,s2
      state = 0;
 522:	4981                	li	s3,0
 524:	bfad                	j	49e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 526:	06400793          	li	a5,100
 52a:	02f68963          	beq	a3,a5,55c <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 52e:	06c00793          	li	a5,108
 532:	04f68263          	beq	a3,a5,576 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 536:	07500793          	li	a5,117
 53a:	0af68063          	beq	a3,a5,5da <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 53e:	07800793          	li	a5,120
 542:	0ef68263          	beq	a3,a5,626 <vprintf+0x1d2>
        putc(fd, '%');
 546:	02500593          	li	a1,37
 54a:	855a                	mv	a0,s6
 54c:	e43ff0ef          	jal	38e <putc>
        putc(fd, c0);
 550:	85ca                	mv	a1,s2
 552:	855a                	mv	a0,s6
 554:	e3bff0ef          	jal	38e <putc>
      state = 0;
 558:	4981                	li	s3,0
 55a:	b791                	j	49e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 55c:	008b8913          	addi	s2,s7,8
 560:	4685                	li	a3,1
 562:	4629                	li	a2,10
 564:	000ba583          	lw	a1,0(s7)
 568:	855a                	mv	a0,s6
 56a:	e43ff0ef          	jal	3ac <printint>
        i += 1;
 56e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 570:	8bca                	mv	s7,s2
      state = 0;
 572:	4981                	li	s3,0
        i += 1;
 574:	b72d                	j	49e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 576:	06400793          	li	a5,100
 57a:	02f60763          	beq	a2,a5,5a8 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 57e:	07500793          	li	a5,117
 582:	06f60963          	beq	a2,a5,5f4 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 586:	07800793          	li	a5,120
 58a:	faf61ee3          	bne	a2,a5,546 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 58e:	008b8913          	addi	s2,s7,8
 592:	4681                	li	a3,0
 594:	4641                	li	a2,16
 596:	000ba583          	lw	a1,0(s7)
 59a:	855a                	mv	a0,s6
 59c:	e11ff0ef          	jal	3ac <printint>
        i += 2;
 5a0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a2:	8bca                	mv	s7,s2
      state = 0;
 5a4:	4981                	li	s3,0
        i += 2;
 5a6:	bde5                	j	49e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a8:	008b8913          	addi	s2,s7,8
 5ac:	4685                	li	a3,1
 5ae:	4629                	li	a2,10
 5b0:	000ba583          	lw	a1,0(s7)
 5b4:	855a                	mv	a0,s6
 5b6:	df7ff0ef          	jal	3ac <printint>
        i += 2;
 5ba:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5bc:	8bca                	mv	s7,s2
      state = 0;
 5be:	4981                	li	s3,0
        i += 2;
 5c0:	bdf9                	j	49e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5c2:	008b8913          	addi	s2,s7,8
 5c6:	4681                	li	a3,0
 5c8:	4629                	li	a2,10
 5ca:	000ba583          	lw	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	dddff0ef          	jal	3ac <printint>
 5d4:	8bca                	mv	s7,s2
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	b5d9                	j	49e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5da:	008b8913          	addi	s2,s7,8
 5de:	4681                	li	a3,0
 5e0:	4629                	li	a2,10
 5e2:	000ba583          	lw	a1,0(s7)
 5e6:	855a                	mv	a0,s6
 5e8:	dc5ff0ef          	jal	3ac <printint>
        i += 1;
 5ec:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ee:	8bca                	mv	s7,s2
      state = 0;
 5f0:	4981                	li	s3,0
        i += 1;
 5f2:	b575                	j	49e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f4:	008b8913          	addi	s2,s7,8
 5f8:	4681                	li	a3,0
 5fa:	4629                	li	a2,10
 5fc:	000ba583          	lw	a1,0(s7)
 600:	855a                	mv	a0,s6
 602:	dabff0ef          	jal	3ac <printint>
        i += 2;
 606:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 608:	8bca                	mv	s7,s2
      state = 0;
 60a:	4981                	li	s3,0
        i += 2;
 60c:	bd49                	j	49e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 60e:	008b8913          	addi	s2,s7,8
 612:	4681                	li	a3,0
 614:	4641                	li	a2,16
 616:	000ba583          	lw	a1,0(s7)
 61a:	855a                	mv	a0,s6
 61c:	d91ff0ef          	jal	3ac <printint>
 620:	8bca                	mv	s7,s2
      state = 0;
 622:	4981                	li	s3,0
 624:	bdad                	j	49e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 626:	008b8913          	addi	s2,s7,8
 62a:	4681                	li	a3,0
 62c:	4641                	li	a2,16
 62e:	000ba583          	lw	a1,0(s7)
 632:	855a                	mv	a0,s6
 634:	d79ff0ef          	jal	3ac <printint>
        i += 1;
 638:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 63a:	8bca                	mv	s7,s2
      state = 0;
 63c:	4981                	li	s3,0
        i += 1;
 63e:	b585                	j	49e <vprintf+0x4a>
 640:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 642:	008b8d13          	addi	s10,s7,8
 646:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 64a:	03000593          	li	a1,48
 64e:	855a                	mv	a0,s6
 650:	d3fff0ef          	jal	38e <putc>
  putc(fd, 'x');
 654:	07800593          	li	a1,120
 658:	855a                	mv	a0,s6
 65a:	d35ff0ef          	jal	38e <putc>
 65e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 660:	00000b97          	auipc	s7,0x0
 664:	2b0b8b93          	addi	s7,s7,688 # 910 <digits>
 668:	03c9d793          	srli	a5,s3,0x3c
 66c:	97de                	add	a5,a5,s7
 66e:	0007c583          	lbu	a1,0(a5)
 672:	855a                	mv	a0,s6
 674:	d1bff0ef          	jal	38e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 678:	0992                	slli	s3,s3,0x4
 67a:	397d                	addiw	s2,s2,-1
 67c:	fe0916e3          	bnez	s2,668 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 680:	8bea                	mv	s7,s10
      state = 0;
 682:	4981                	li	s3,0
 684:	6d02                	ld	s10,0(sp)
 686:	bd21                	j	49e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 688:	008b8993          	addi	s3,s7,8
 68c:	000bb903          	ld	s2,0(s7)
 690:	00090f63          	beqz	s2,6ae <vprintf+0x25a>
        for(; *s; s++)
 694:	00094583          	lbu	a1,0(s2)
 698:	c195                	beqz	a1,6bc <vprintf+0x268>
          putc(fd, *s);
 69a:	855a                	mv	a0,s6
 69c:	cf3ff0ef          	jal	38e <putc>
        for(; *s; s++)
 6a0:	0905                	addi	s2,s2,1
 6a2:	00094583          	lbu	a1,0(s2)
 6a6:	f9f5                	bnez	a1,69a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6a8:	8bce                	mv	s7,s3
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bbcd                	j	49e <vprintf+0x4a>
          s = "(null)";
 6ae:	00000917          	auipc	s2,0x0
 6b2:	25a90913          	addi	s2,s2,602 # 908 <malloc+0x14e>
        for(; *s; s++)
 6b6:	02800593          	li	a1,40
 6ba:	b7c5                	j	69a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6bc:	8bce                	mv	s7,s3
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	bbf9                	j	49e <vprintf+0x4a>
 6c2:	64a6                	ld	s1,72(sp)
 6c4:	79e2                	ld	s3,56(sp)
 6c6:	7a42                	ld	s4,48(sp)
 6c8:	7aa2                	ld	s5,40(sp)
 6ca:	7b02                	ld	s6,32(sp)
 6cc:	6be2                	ld	s7,24(sp)
 6ce:	6c42                	ld	s8,16(sp)
 6d0:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6d2:	60e6                	ld	ra,88(sp)
 6d4:	6446                	ld	s0,80(sp)
 6d6:	6906                	ld	s2,64(sp)
 6d8:	6125                	addi	sp,sp,96
 6da:	8082                	ret

00000000000006dc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6dc:	715d                	addi	sp,sp,-80
 6de:	ec06                	sd	ra,24(sp)
 6e0:	e822                	sd	s0,16(sp)
 6e2:	1000                	addi	s0,sp,32
 6e4:	e010                	sd	a2,0(s0)
 6e6:	e414                	sd	a3,8(s0)
 6e8:	e818                	sd	a4,16(s0)
 6ea:	ec1c                	sd	a5,24(s0)
 6ec:	03043023          	sd	a6,32(s0)
 6f0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6f4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6f8:	8622                	mv	a2,s0
 6fa:	d5bff0ef          	jal	454 <vprintf>
}
 6fe:	60e2                	ld	ra,24(sp)
 700:	6442                	ld	s0,16(sp)
 702:	6161                	addi	sp,sp,80
 704:	8082                	ret

0000000000000706 <printf>:

void
printf(const char *fmt, ...)
{
 706:	711d                	addi	sp,sp,-96
 708:	ec06                	sd	ra,24(sp)
 70a:	e822                	sd	s0,16(sp)
 70c:	1000                	addi	s0,sp,32
 70e:	e40c                	sd	a1,8(s0)
 710:	e810                	sd	a2,16(s0)
 712:	ec14                	sd	a3,24(s0)
 714:	f018                	sd	a4,32(s0)
 716:	f41c                	sd	a5,40(s0)
 718:	03043823          	sd	a6,48(s0)
 71c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 720:	00840613          	addi	a2,s0,8
 724:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 728:	85aa                	mv	a1,a0
 72a:	4505                	li	a0,1
 72c:	d29ff0ef          	jal	454 <vprintf>
}
 730:	60e2                	ld	ra,24(sp)
 732:	6442                	ld	s0,16(sp)
 734:	6125                	addi	sp,sp,96
 736:	8082                	ret

0000000000000738 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 738:	1141                	addi	sp,sp,-16
 73a:	e422                	sd	s0,8(sp)
 73c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 73e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 742:	00001797          	auipc	a5,0x1
 746:	8be7b783          	ld	a5,-1858(a5) # 1000 <freep>
 74a:	a02d                	j	774 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 74c:	4618                	lw	a4,8(a2)
 74e:	9f2d                	addw	a4,a4,a1
 750:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 754:	6398                	ld	a4,0(a5)
 756:	6310                	ld	a2,0(a4)
 758:	a83d                	j	796 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 75a:	ff852703          	lw	a4,-8(a0)
 75e:	9f31                	addw	a4,a4,a2
 760:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 762:	ff053683          	ld	a3,-16(a0)
 766:	a091                	j	7aa <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 768:	6398                	ld	a4,0(a5)
 76a:	00e7e463          	bltu	a5,a4,772 <free+0x3a>
 76e:	00e6ea63          	bltu	a3,a4,782 <free+0x4a>
{
 772:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 774:	fed7fae3          	bgeu	a5,a3,768 <free+0x30>
 778:	6398                	ld	a4,0(a5)
 77a:	00e6e463          	bltu	a3,a4,782 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77e:	fee7eae3          	bltu	a5,a4,772 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 782:	ff852583          	lw	a1,-8(a0)
 786:	6390                	ld	a2,0(a5)
 788:	02059813          	slli	a6,a1,0x20
 78c:	01c85713          	srli	a4,a6,0x1c
 790:	9736                	add	a4,a4,a3
 792:	fae60de3          	beq	a2,a4,74c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 796:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 79a:	4790                	lw	a2,8(a5)
 79c:	02061593          	slli	a1,a2,0x20
 7a0:	01c5d713          	srli	a4,a1,0x1c
 7a4:	973e                	add	a4,a4,a5
 7a6:	fae68ae3          	beq	a3,a4,75a <free+0x22>
    p->s.ptr = bp->s.ptr;
 7aa:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ac:	00001717          	auipc	a4,0x1
 7b0:	84f73a23          	sd	a5,-1964(a4) # 1000 <freep>
}
 7b4:	6422                	ld	s0,8(sp)
 7b6:	0141                	addi	sp,sp,16
 7b8:	8082                	ret

00000000000007ba <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7ba:	7139                	addi	sp,sp,-64
 7bc:	fc06                	sd	ra,56(sp)
 7be:	f822                	sd	s0,48(sp)
 7c0:	f426                	sd	s1,40(sp)
 7c2:	ec4e                	sd	s3,24(sp)
 7c4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c6:	02051493          	slli	s1,a0,0x20
 7ca:	9081                	srli	s1,s1,0x20
 7cc:	04bd                	addi	s1,s1,15
 7ce:	8091                	srli	s1,s1,0x4
 7d0:	0014899b          	addiw	s3,s1,1
 7d4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7d6:	00001517          	auipc	a0,0x1
 7da:	82a53503          	ld	a0,-2006(a0) # 1000 <freep>
 7de:	c915                	beqz	a0,812 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e2:	4798                	lw	a4,8(a5)
 7e4:	08977a63          	bgeu	a4,s1,878 <malloc+0xbe>
 7e8:	f04a                	sd	s2,32(sp)
 7ea:	e852                	sd	s4,16(sp)
 7ec:	e456                	sd	s5,8(sp)
 7ee:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7f0:	8a4e                	mv	s4,s3
 7f2:	0009871b          	sext.w	a4,s3
 7f6:	6685                	lui	a3,0x1
 7f8:	00d77363          	bgeu	a4,a3,7fe <malloc+0x44>
 7fc:	6a05                	lui	s4,0x1
 7fe:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 802:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 806:	00000917          	auipc	s2,0x0
 80a:	7fa90913          	addi	s2,s2,2042 # 1000 <freep>
  if(p == (char*)-1)
 80e:	5afd                	li	s5,-1
 810:	a081                	j	850 <malloc+0x96>
 812:	f04a                	sd	s2,32(sp)
 814:	e852                	sd	s4,16(sp)
 816:	e456                	sd	s5,8(sp)
 818:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 81a:	00000797          	auipc	a5,0x0
 81e:	7f678793          	addi	a5,a5,2038 # 1010 <base>
 822:	00000717          	auipc	a4,0x0
 826:	7cf73f23          	sd	a5,2014(a4) # 1000 <freep>
 82a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 82c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 830:	b7c1                	j	7f0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 832:	6398                	ld	a4,0(a5)
 834:	e118                	sd	a4,0(a0)
 836:	a8a9                	j	890 <malloc+0xd6>
  hp->s.size = nu;
 838:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 83c:	0541                	addi	a0,a0,16
 83e:	efbff0ef          	jal	738 <free>
  return freep;
 842:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 846:	c12d                	beqz	a0,8a8 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 848:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 84a:	4798                	lw	a4,8(a5)
 84c:	02977263          	bgeu	a4,s1,870 <malloc+0xb6>
    if(p == freep)
 850:	00093703          	ld	a4,0(s2)
 854:	853e                	mv	a0,a5
 856:	fef719e3          	bne	a4,a5,848 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 85a:	8552                	mv	a0,s4
 85c:	aebff0ef          	jal	346 <sbrk>
  if(p == (char*)-1)
 860:	fd551ce3          	bne	a0,s5,838 <malloc+0x7e>
        return 0;
 864:	4501                	li	a0,0
 866:	7902                	ld	s2,32(sp)
 868:	6a42                	ld	s4,16(sp)
 86a:	6aa2                	ld	s5,8(sp)
 86c:	6b02                	ld	s6,0(sp)
 86e:	a03d                	j	89c <malloc+0xe2>
 870:	7902                	ld	s2,32(sp)
 872:	6a42                	ld	s4,16(sp)
 874:	6aa2                	ld	s5,8(sp)
 876:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 878:	fae48de3          	beq	s1,a4,832 <malloc+0x78>
        p->s.size -= nunits;
 87c:	4137073b          	subw	a4,a4,s3
 880:	c798                	sw	a4,8(a5)
        p += p->s.size;
 882:	02071693          	slli	a3,a4,0x20
 886:	01c6d713          	srli	a4,a3,0x1c
 88a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 88c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 890:	00000717          	auipc	a4,0x0
 894:	76a73823          	sd	a0,1904(a4) # 1000 <freep>
      return (void*)(p + 1);
 898:	01078513          	addi	a0,a5,16
  }
}
 89c:	70e2                	ld	ra,56(sp)
 89e:	7442                	ld	s0,48(sp)
 8a0:	74a2                	ld	s1,40(sp)
 8a2:	69e2                	ld	s3,24(sp)
 8a4:	6121                	addi	sp,sp,64
 8a6:	8082                	ret
 8a8:	7902                	ld	s2,32(sp)
 8aa:	6a42                	ld	s4,16(sp)
 8ac:	6aa2                	ld	s5,8(sp)
 8ae:	6b02                	ld	s6,0(sp)
 8b0:	b7f5                	j	89c <malloc+0xe2>
