
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
  16:	88e50513          	addi	a0,a0,-1906 # 8a0 <malloc+0xfa>
  1a:	6d8000ef          	jal	6f2 <printf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	2a6000ef          	jal	2c6 <exit>
  24:	e426                	sd	s1,8(sp)
  26:	e04a                	sd	s2,0(sp)
  28:	84ae                	mv	s1,a1
  }
  char *end = sbrk(PGSIZE*32);
  2a:	00020537          	lui	a0,0x20
  2e:	320000ef          	jal	34e <sbrk>
  32:	892a                	mv	s2,a0
  end = end + 9 * PGSIZE;
  strcpy(end, "my very very very secret pw is:   ");
  34:	02300613          	li	a2,35
  38:	00001597          	auipc	a1,0x1
  3c:	88858593          	addi	a1,a1,-1912 # 8c0 <malloc+0x11a>
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
 1a4:	162000ef          	jal	306 <open>
  if(fd < 0)
 1a8:	02054263          	bltz	a0,1cc <stat+0x36>
 1ac:	e426                	sd	s1,8(sp)
 1ae:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b0:	85ca                	mv	a1,s2
 1b2:	16c000ef          	jal	31e <fstat>
 1b6:	892a                	mv	s2,a0
  close(fd);
 1b8:	8526                	mv	a0,s1
 1ba:	134000ef          	jal	2ee <close>
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

00000000000002ee <close>:
.global close
close:
 li a7, SYS_close
 2ee:	48d5                	li	a7,21
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2f6:	4899                	li	a7,6
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <exec>:
.global exec
exec:
 li a7, SYS_exec
 2fe:	489d                	li	a7,7
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <open>:
.global open
open:
 li a7, SYS_open
 306:	48bd                	li	a7,15
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 30e:	48c5                	li	a7,17
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 316:	48c9                	li	a7,18
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 31e:	48a1                	li	a7,8
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <link>:
.global link
link:
 li a7, SYS_link
 326:	48cd                	li	a7,19
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 32e:	48d1                	li	a7,20
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 336:	48a5                	li	a7,9
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <dup>:
.global dup
dup:
 li a7, SYS_dup
 33e:	48a9                	li	a7,10
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 346:	48ad                	li	a7,11
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 34e:	48b1                	li	a7,12
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 356:	48b5                	li	a7,13
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 35e:	48b9                	li	a7,14
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <trace>:
///////
.global trace
trace:
 li a7, SYS_trace
 366:	03300893          	li	a7,51
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <stats>:

.global stats
stats:
 li a7, SYS_stats
 370:	03400893          	li	a7,52
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 37a:	1101                	addi	sp,sp,-32
 37c:	ec06                	sd	ra,24(sp)
 37e:	e822                	sd	s0,16(sp)
 380:	1000                	addi	s0,sp,32
 382:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 386:	4605                	li	a2,1
 388:	fef40593          	addi	a1,s0,-17
 38c:	f5bff0ef          	jal	2e6 <write>
}
 390:	60e2                	ld	ra,24(sp)
 392:	6442                	ld	s0,16(sp)
 394:	6105                	addi	sp,sp,32
 396:	8082                	ret

0000000000000398 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 398:	7139                	addi	sp,sp,-64
 39a:	fc06                	sd	ra,56(sp)
 39c:	f822                	sd	s0,48(sp)
 39e:	f426                	sd	s1,40(sp)
 3a0:	0080                	addi	s0,sp,64
 3a2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a4:	c299                	beqz	a3,3aa <printint+0x12>
 3a6:	0805c963          	bltz	a1,438 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3aa:	2581                	sext.w	a1,a1
  neg = 0;
 3ac:	4881                	li	a7,0
 3ae:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3b2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3b4:	2601                	sext.w	a2,a2
 3b6:	00000517          	auipc	a0,0x0
 3ba:	53a50513          	addi	a0,a0,1338 # 8f0 <digits>
 3be:	883a                	mv	a6,a4
 3c0:	2705                	addiw	a4,a4,1
 3c2:	02c5f7bb          	remuw	a5,a1,a2
 3c6:	1782                	slli	a5,a5,0x20
 3c8:	9381                	srli	a5,a5,0x20
 3ca:	97aa                	add	a5,a5,a0
 3cc:	0007c783          	lbu	a5,0(a5)
 3d0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3d4:	0005879b          	sext.w	a5,a1
 3d8:	02c5d5bb          	divuw	a1,a1,a2
 3dc:	0685                	addi	a3,a3,1
 3de:	fec7f0e3          	bgeu	a5,a2,3be <printint+0x26>
  if(neg)
 3e2:	00088c63          	beqz	a7,3fa <printint+0x62>
    buf[i++] = '-';
 3e6:	fd070793          	addi	a5,a4,-48
 3ea:	00878733          	add	a4,a5,s0
 3ee:	02d00793          	li	a5,45
 3f2:	fef70823          	sb	a5,-16(a4)
 3f6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3fa:	02e05a63          	blez	a4,42e <printint+0x96>
 3fe:	f04a                	sd	s2,32(sp)
 400:	ec4e                	sd	s3,24(sp)
 402:	fc040793          	addi	a5,s0,-64
 406:	00e78933          	add	s2,a5,a4
 40a:	fff78993          	addi	s3,a5,-1
 40e:	99ba                	add	s3,s3,a4
 410:	377d                	addiw	a4,a4,-1
 412:	1702                	slli	a4,a4,0x20
 414:	9301                	srli	a4,a4,0x20
 416:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 41a:	fff94583          	lbu	a1,-1(s2)
 41e:	8526                	mv	a0,s1
 420:	f5bff0ef          	jal	37a <putc>
  while(--i >= 0)
 424:	197d                	addi	s2,s2,-1
 426:	ff391ae3          	bne	s2,s3,41a <printint+0x82>
 42a:	7902                	ld	s2,32(sp)
 42c:	69e2                	ld	s3,24(sp)
}
 42e:	70e2                	ld	ra,56(sp)
 430:	7442                	ld	s0,48(sp)
 432:	74a2                	ld	s1,40(sp)
 434:	6121                	addi	sp,sp,64
 436:	8082                	ret
    x = -xx;
 438:	40b005bb          	negw	a1,a1
    neg = 1;
 43c:	4885                	li	a7,1
    x = -xx;
 43e:	bf85                	j	3ae <printint+0x16>

0000000000000440 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 440:	711d                	addi	sp,sp,-96
 442:	ec86                	sd	ra,88(sp)
 444:	e8a2                	sd	s0,80(sp)
 446:	e0ca                	sd	s2,64(sp)
 448:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 44a:	0005c903          	lbu	s2,0(a1)
 44e:	26090863          	beqz	s2,6be <vprintf+0x27e>
 452:	e4a6                	sd	s1,72(sp)
 454:	fc4e                	sd	s3,56(sp)
 456:	f852                	sd	s4,48(sp)
 458:	f456                	sd	s5,40(sp)
 45a:	f05a                	sd	s6,32(sp)
 45c:	ec5e                	sd	s7,24(sp)
 45e:	e862                	sd	s8,16(sp)
 460:	e466                	sd	s9,8(sp)
 462:	8b2a                	mv	s6,a0
 464:	8a2e                	mv	s4,a1
 466:	8bb2                	mv	s7,a2
  state = 0;
 468:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 46a:	4481                	li	s1,0
 46c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 46e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 472:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 476:	06c00c93          	li	s9,108
 47a:	a005                	j	49a <vprintf+0x5a>
        putc(fd, c0);
 47c:	85ca                	mv	a1,s2
 47e:	855a                	mv	a0,s6
 480:	efbff0ef          	jal	37a <putc>
 484:	a019                	j	48a <vprintf+0x4a>
    } else if(state == '%'){
 486:	03598263          	beq	s3,s5,4aa <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 48a:	2485                	addiw	s1,s1,1
 48c:	8726                	mv	a4,s1
 48e:	009a07b3          	add	a5,s4,s1
 492:	0007c903          	lbu	s2,0(a5)
 496:	20090c63          	beqz	s2,6ae <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 49a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 49e:	fe0994e3          	bnez	s3,486 <vprintf+0x46>
      if(c0 == '%'){
 4a2:	fd579de3          	bne	a5,s5,47c <vprintf+0x3c>
        state = '%';
 4a6:	89be                	mv	s3,a5
 4a8:	b7cd                	j	48a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4aa:	00ea06b3          	add	a3,s4,a4
 4ae:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4b2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4b4:	c681                	beqz	a3,4bc <vprintf+0x7c>
 4b6:	9752                	add	a4,a4,s4
 4b8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4bc:	03878f63          	beq	a5,s8,4fa <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4c0:	05978963          	beq	a5,s9,512 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4c4:	07500713          	li	a4,117
 4c8:	0ee78363          	beq	a5,a4,5ae <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4cc:	07800713          	li	a4,120
 4d0:	12e78563          	beq	a5,a4,5fa <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4d4:	07000713          	li	a4,112
 4d8:	14e78a63          	beq	a5,a4,62c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4dc:	07300713          	li	a4,115
 4e0:	18e78a63          	beq	a5,a4,674 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4e4:	02500713          	li	a4,37
 4e8:	04e79563          	bne	a5,a4,532 <vprintf+0xf2>
        putc(fd, '%');
 4ec:	02500593          	li	a1,37
 4f0:	855a                	mv	a0,s6
 4f2:	e89ff0ef          	jal	37a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4f6:	4981                	li	s3,0
 4f8:	bf49                	j	48a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4fa:	008b8913          	addi	s2,s7,8
 4fe:	4685                	li	a3,1
 500:	4629                	li	a2,10
 502:	000ba583          	lw	a1,0(s7)
 506:	855a                	mv	a0,s6
 508:	e91ff0ef          	jal	398 <printint>
 50c:	8bca                	mv	s7,s2
      state = 0;
 50e:	4981                	li	s3,0
 510:	bfad                	j	48a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 512:	06400793          	li	a5,100
 516:	02f68963          	beq	a3,a5,548 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 51a:	06c00793          	li	a5,108
 51e:	04f68263          	beq	a3,a5,562 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 522:	07500793          	li	a5,117
 526:	0af68063          	beq	a3,a5,5c6 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 52a:	07800793          	li	a5,120
 52e:	0ef68263          	beq	a3,a5,612 <vprintf+0x1d2>
        putc(fd, '%');
 532:	02500593          	li	a1,37
 536:	855a                	mv	a0,s6
 538:	e43ff0ef          	jal	37a <putc>
        putc(fd, c0);
 53c:	85ca                	mv	a1,s2
 53e:	855a                	mv	a0,s6
 540:	e3bff0ef          	jal	37a <putc>
      state = 0;
 544:	4981                	li	s3,0
 546:	b791                	j	48a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 548:	008b8913          	addi	s2,s7,8
 54c:	4685                	li	a3,1
 54e:	4629                	li	a2,10
 550:	000ba583          	lw	a1,0(s7)
 554:	855a                	mv	a0,s6
 556:	e43ff0ef          	jal	398 <printint>
        i += 1;
 55a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 55c:	8bca                	mv	s7,s2
      state = 0;
 55e:	4981                	li	s3,0
        i += 1;
 560:	b72d                	j	48a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 562:	06400793          	li	a5,100
 566:	02f60763          	beq	a2,a5,594 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 56a:	07500793          	li	a5,117
 56e:	06f60963          	beq	a2,a5,5e0 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 572:	07800793          	li	a5,120
 576:	faf61ee3          	bne	a2,a5,532 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 57a:	008b8913          	addi	s2,s7,8
 57e:	4681                	li	a3,0
 580:	4641                	li	a2,16
 582:	000ba583          	lw	a1,0(s7)
 586:	855a                	mv	a0,s6
 588:	e11ff0ef          	jal	398 <printint>
        i += 2;
 58c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 58e:	8bca                	mv	s7,s2
      state = 0;
 590:	4981                	li	s3,0
        i += 2;
 592:	bde5                	j	48a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 594:	008b8913          	addi	s2,s7,8
 598:	4685                	li	a3,1
 59a:	4629                	li	a2,10
 59c:	000ba583          	lw	a1,0(s7)
 5a0:	855a                	mv	a0,s6
 5a2:	df7ff0ef          	jal	398 <printint>
        i += 2;
 5a6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a8:	8bca                	mv	s7,s2
      state = 0;
 5aa:	4981                	li	s3,0
        i += 2;
 5ac:	bdf9                	j	48a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5ae:	008b8913          	addi	s2,s7,8
 5b2:	4681                	li	a3,0
 5b4:	4629                	li	a2,10
 5b6:	000ba583          	lw	a1,0(s7)
 5ba:	855a                	mv	a0,s6
 5bc:	dddff0ef          	jal	398 <printint>
 5c0:	8bca                	mv	s7,s2
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b5d9                	j	48a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c6:	008b8913          	addi	s2,s7,8
 5ca:	4681                	li	a3,0
 5cc:	4629                	li	a2,10
 5ce:	000ba583          	lw	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	dc5ff0ef          	jal	398 <printint>
        i += 1;
 5d8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5da:	8bca                	mv	s7,s2
      state = 0;
 5dc:	4981                	li	s3,0
        i += 1;
 5de:	b575                	j	48a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e0:	008b8913          	addi	s2,s7,8
 5e4:	4681                	li	a3,0
 5e6:	4629                	li	a2,10
 5e8:	000ba583          	lw	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	dabff0ef          	jal	398 <printint>
        i += 2;
 5f2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f4:	8bca                	mv	s7,s2
      state = 0;
 5f6:	4981                	li	s3,0
        i += 2;
 5f8:	bd49                	j	48a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5fa:	008b8913          	addi	s2,s7,8
 5fe:	4681                	li	a3,0
 600:	4641                	li	a2,16
 602:	000ba583          	lw	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	d91ff0ef          	jal	398 <printint>
 60c:	8bca                	mv	s7,s2
      state = 0;
 60e:	4981                	li	s3,0
 610:	bdad                	j	48a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 612:	008b8913          	addi	s2,s7,8
 616:	4681                	li	a3,0
 618:	4641                	li	a2,16
 61a:	000ba583          	lw	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	d79ff0ef          	jal	398 <printint>
        i += 1;
 624:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 626:	8bca                	mv	s7,s2
      state = 0;
 628:	4981                	li	s3,0
        i += 1;
 62a:	b585                	j	48a <vprintf+0x4a>
 62c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 62e:	008b8d13          	addi	s10,s7,8
 632:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 636:	03000593          	li	a1,48
 63a:	855a                	mv	a0,s6
 63c:	d3fff0ef          	jal	37a <putc>
  putc(fd, 'x');
 640:	07800593          	li	a1,120
 644:	855a                	mv	a0,s6
 646:	d35ff0ef          	jal	37a <putc>
 64a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 64c:	00000b97          	auipc	s7,0x0
 650:	2a4b8b93          	addi	s7,s7,676 # 8f0 <digits>
 654:	03c9d793          	srli	a5,s3,0x3c
 658:	97de                	add	a5,a5,s7
 65a:	0007c583          	lbu	a1,0(a5)
 65e:	855a                	mv	a0,s6
 660:	d1bff0ef          	jal	37a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 664:	0992                	slli	s3,s3,0x4
 666:	397d                	addiw	s2,s2,-1
 668:	fe0916e3          	bnez	s2,654 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 66c:	8bea                	mv	s7,s10
      state = 0;
 66e:	4981                	li	s3,0
 670:	6d02                	ld	s10,0(sp)
 672:	bd21                	j	48a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 674:	008b8993          	addi	s3,s7,8
 678:	000bb903          	ld	s2,0(s7)
 67c:	00090f63          	beqz	s2,69a <vprintf+0x25a>
        for(; *s; s++)
 680:	00094583          	lbu	a1,0(s2)
 684:	c195                	beqz	a1,6a8 <vprintf+0x268>
          putc(fd, *s);
 686:	855a                	mv	a0,s6
 688:	cf3ff0ef          	jal	37a <putc>
        for(; *s; s++)
 68c:	0905                	addi	s2,s2,1
 68e:	00094583          	lbu	a1,0(s2)
 692:	f9f5                	bnez	a1,686 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 694:	8bce                	mv	s7,s3
      state = 0;
 696:	4981                	li	s3,0
 698:	bbcd                	j	48a <vprintf+0x4a>
          s = "(null)";
 69a:	00000917          	auipc	s2,0x0
 69e:	24e90913          	addi	s2,s2,590 # 8e8 <malloc+0x142>
        for(; *s; s++)
 6a2:	02800593          	li	a1,40
 6a6:	b7c5                	j	686 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6a8:	8bce                	mv	s7,s3
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bbf9                	j	48a <vprintf+0x4a>
 6ae:	64a6                	ld	s1,72(sp)
 6b0:	79e2                	ld	s3,56(sp)
 6b2:	7a42                	ld	s4,48(sp)
 6b4:	7aa2                	ld	s5,40(sp)
 6b6:	7b02                	ld	s6,32(sp)
 6b8:	6be2                	ld	s7,24(sp)
 6ba:	6c42                	ld	s8,16(sp)
 6bc:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6be:	60e6                	ld	ra,88(sp)
 6c0:	6446                	ld	s0,80(sp)
 6c2:	6906                	ld	s2,64(sp)
 6c4:	6125                	addi	sp,sp,96
 6c6:	8082                	ret

00000000000006c8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6c8:	715d                	addi	sp,sp,-80
 6ca:	ec06                	sd	ra,24(sp)
 6cc:	e822                	sd	s0,16(sp)
 6ce:	1000                	addi	s0,sp,32
 6d0:	e010                	sd	a2,0(s0)
 6d2:	e414                	sd	a3,8(s0)
 6d4:	e818                	sd	a4,16(s0)
 6d6:	ec1c                	sd	a5,24(s0)
 6d8:	03043023          	sd	a6,32(s0)
 6dc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6e0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6e4:	8622                	mv	a2,s0
 6e6:	d5bff0ef          	jal	440 <vprintf>
}
 6ea:	60e2                	ld	ra,24(sp)
 6ec:	6442                	ld	s0,16(sp)
 6ee:	6161                	addi	sp,sp,80
 6f0:	8082                	ret

00000000000006f2 <printf>:

void
printf(const char *fmt, ...)
{
 6f2:	711d                	addi	sp,sp,-96
 6f4:	ec06                	sd	ra,24(sp)
 6f6:	e822                	sd	s0,16(sp)
 6f8:	1000                	addi	s0,sp,32
 6fa:	e40c                	sd	a1,8(s0)
 6fc:	e810                	sd	a2,16(s0)
 6fe:	ec14                	sd	a3,24(s0)
 700:	f018                	sd	a4,32(s0)
 702:	f41c                	sd	a5,40(s0)
 704:	03043823          	sd	a6,48(s0)
 708:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 70c:	00840613          	addi	a2,s0,8
 710:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 714:	85aa                	mv	a1,a0
 716:	4505                	li	a0,1
 718:	d29ff0ef          	jal	440 <vprintf>
}
 71c:	60e2                	ld	ra,24(sp)
 71e:	6442                	ld	s0,16(sp)
 720:	6125                	addi	sp,sp,96
 722:	8082                	ret

0000000000000724 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 724:	1141                	addi	sp,sp,-16
 726:	e422                	sd	s0,8(sp)
 728:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 72a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72e:	00001797          	auipc	a5,0x1
 732:	8d27b783          	ld	a5,-1838(a5) # 1000 <freep>
 736:	a02d                	j	760 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 738:	4618                	lw	a4,8(a2)
 73a:	9f2d                	addw	a4,a4,a1
 73c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 740:	6398                	ld	a4,0(a5)
 742:	6310                	ld	a2,0(a4)
 744:	a83d                	j	782 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 746:	ff852703          	lw	a4,-8(a0)
 74a:	9f31                	addw	a4,a4,a2
 74c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 74e:	ff053683          	ld	a3,-16(a0)
 752:	a091                	j	796 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 754:	6398                	ld	a4,0(a5)
 756:	00e7e463          	bltu	a5,a4,75e <free+0x3a>
 75a:	00e6ea63          	bltu	a3,a4,76e <free+0x4a>
{
 75e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 760:	fed7fae3          	bgeu	a5,a3,754 <free+0x30>
 764:	6398                	ld	a4,0(a5)
 766:	00e6e463          	bltu	a3,a4,76e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76a:	fee7eae3          	bltu	a5,a4,75e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 76e:	ff852583          	lw	a1,-8(a0)
 772:	6390                	ld	a2,0(a5)
 774:	02059813          	slli	a6,a1,0x20
 778:	01c85713          	srli	a4,a6,0x1c
 77c:	9736                	add	a4,a4,a3
 77e:	fae60de3          	beq	a2,a4,738 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 782:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 786:	4790                	lw	a2,8(a5)
 788:	02061593          	slli	a1,a2,0x20
 78c:	01c5d713          	srli	a4,a1,0x1c
 790:	973e                	add	a4,a4,a5
 792:	fae68ae3          	beq	a3,a4,746 <free+0x22>
    p->s.ptr = bp->s.ptr;
 796:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 798:	00001717          	auipc	a4,0x1
 79c:	86f73423          	sd	a5,-1944(a4) # 1000 <freep>
}
 7a0:	6422                	ld	s0,8(sp)
 7a2:	0141                	addi	sp,sp,16
 7a4:	8082                	ret

00000000000007a6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a6:	7139                	addi	sp,sp,-64
 7a8:	fc06                	sd	ra,56(sp)
 7aa:	f822                	sd	s0,48(sp)
 7ac:	f426                	sd	s1,40(sp)
 7ae:	ec4e                	sd	s3,24(sp)
 7b0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b2:	02051493          	slli	s1,a0,0x20
 7b6:	9081                	srli	s1,s1,0x20
 7b8:	04bd                	addi	s1,s1,15
 7ba:	8091                	srli	s1,s1,0x4
 7bc:	0014899b          	addiw	s3,s1,1
 7c0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7c2:	00001517          	auipc	a0,0x1
 7c6:	83e53503          	ld	a0,-1986(a0) # 1000 <freep>
 7ca:	c915                	beqz	a0,7fe <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ce:	4798                	lw	a4,8(a5)
 7d0:	08977a63          	bgeu	a4,s1,864 <malloc+0xbe>
 7d4:	f04a                	sd	s2,32(sp)
 7d6:	e852                	sd	s4,16(sp)
 7d8:	e456                	sd	s5,8(sp)
 7da:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7dc:	8a4e                	mv	s4,s3
 7de:	0009871b          	sext.w	a4,s3
 7e2:	6685                	lui	a3,0x1
 7e4:	00d77363          	bgeu	a4,a3,7ea <malloc+0x44>
 7e8:	6a05                	lui	s4,0x1
 7ea:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ee:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f2:	00001917          	auipc	s2,0x1
 7f6:	80e90913          	addi	s2,s2,-2034 # 1000 <freep>
  if(p == (char*)-1)
 7fa:	5afd                	li	s5,-1
 7fc:	a081                	j	83c <malloc+0x96>
 7fe:	f04a                	sd	s2,32(sp)
 800:	e852                	sd	s4,16(sp)
 802:	e456                	sd	s5,8(sp)
 804:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 806:	00001797          	auipc	a5,0x1
 80a:	80a78793          	addi	a5,a5,-2038 # 1010 <base>
 80e:	00000717          	auipc	a4,0x0
 812:	7ef73923          	sd	a5,2034(a4) # 1000 <freep>
 816:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 818:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 81c:	b7c1                	j	7dc <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 81e:	6398                	ld	a4,0(a5)
 820:	e118                	sd	a4,0(a0)
 822:	a8a9                	j	87c <malloc+0xd6>
  hp->s.size = nu;
 824:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 828:	0541                	addi	a0,a0,16
 82a:	efbff0ef          	jal	724 <free>
  return freep;
 82e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 832:	c12d                	beqz	a0,894 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 834:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 836:	4798                	lw	a4,8(a5)
 838:	02977263          	bgeu	a4,s1,85c <malloc+0xb6>
    if(p == freep)
 83c:	00093703          	ld	a4,0(s2)
 840:	853e                	mv	a0,a5
 842:	fef719e3          	bne	a4,a5,834 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 846:	8552                	mv	a0,s4
 848:	b07ff0ef          	jal	34e <sbrk>
  if(p == (char*)-1)
 84c:	fd551ce3          	bne	a0,s5,824 <malloc+0x7e>
        return 0;
 850:	4501                	li	a0,0
 852:	7902                	ld	s2,32(sp)
 854:	6a42                	ld	s4,16(sp)
 856:	6aa2                	ld	s5,8(sp)
 858:	6b02                	ld	s6,0(sp)
 85a:	a03d                	j	888 <malloc+0xe2>
 85c:	7902                	ld	s2,32(sp)
 85e:	6a42                	ld	s4,16(sp)
 860:	6aa2                	ld	s5,8(sp)
 862:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 864:	fae48de3          	beq	s1,a4,81e <malloc+0x78>
        p->s.size -= nunits;
 868:	4137073b          	subw	a4,a4,s3
 86c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 86e:	02071693          	slli	a3,a4,0x20
 872:	01c6d713          	srli	a4,a3,0x1c
 876:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 878:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 87c:	00000717          	auipc	a4,0x0
 880:	78a73223          	sd	a0,1924(a4) # 1000 <freep>
      return (void*)(p + 1);
 884:	01078513          	addi	a0,a5,16
  }
}
 888:	70e2                	ld	ra,56(sp)
 88a:	7442                	ld	s0,48(sp)
 88c:	74a2                	ld	s1,40(sp)
 88e:	69e2                	ld	s3,24(sp)
 890:	6121                	addi	sp,sp,64
 892:	8082                	ret
 894:	7902                	ld	s2,32(sp)
 896:	6a42                	ld	s4,16(sp)
 898:	6aa2                	ld	s5,8(sp)
 89a:	6b02                	ld	s6,0(sp)
 89c:	b7f5                	j	888 <malloc+0xe2>
