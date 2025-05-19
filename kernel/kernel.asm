
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	6e013103          	ld	sp,1760(sp) # 8000a6e0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	7c9040ef          	jal	80004fde <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e3a9                	bnez	a5,8000006e <kfree+0x52>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00024797          	auipc	a5,0x24
    80000034:	e3078793          	addi	a5,a5,-464 # 80023e60 <end>
    80000038:	02f56b63          	bltu	a0,a5,8000006e <kfree+0x52>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57763          	bgeu	a0,a5,8000006e <kfree+0x52>
  memset(pa, 1, PGSIZE);
#endif
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000044:	0000a917          	auipc	s2,0xa
    80000048:	6ec90913          	addi	s2,s2,1772 # 8000a730 <kmem>
    8000004c:	854a                	mv	a0,s2
    8000004e:	1f3050ef          	jal	80005a40 <acquire>
  r->next = kmem.freelist;
    80000052:	01893783          	ld	a5,24(s2)
    80000056:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000058:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000005c:	854a                	mv	a0,s2
    8000005e:	27b050ef          	jal	80005ad8 <release>
}
    80000062:	60e2                	ld	ra,24(sp)
    80000064:	6442                	ld	s0,16(sp)
    80000066:	64a2                	ld	s1,8(sp)
    80000068:	6902                	ld	s2,0(sp)
    8000006a:	6105                	addi	sp,sp,32
    8000006c:	8082                	ret
    panic("kfree");
    8000006e:	00007517          	auipc	a0,0x7
    80000072:	f9250513          	addi	a0,a0,-110 # 80007000 <etext>
    80000076:	69c050ef          	jal	80005712 <panic>

000000008000007a <freerange>:
{
    8000007a:	7179                	addi	sp,sp,-48
    8000007c:	f406                	sd	ra,40(sp)
    8000007e:	f022                	sd	s0,32(sp)
    80000080:	ec26                	sd	s1,24(sp)
    80000082:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000084:	6785                	lui	a5,0x1
    80000086:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    8000008a:	00e504b3          	add	s1,a0,a4
    8000008e:	777d                	lui	a4,0xfffff
    80000090:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000092:	94be                	add	s1,s1,a5
    80000094:	0295e263          	bltu	a1,s1,800000b8 <freerange+0x3e>
    80000098:	e84a                	sd	s2,16(sp)
    8000009a:	e44e                	sd	s3,8(sp)
    8000009c:	e052                	sd	s4,0(sp)
    8000009e:	892e                	mv	s2,a1
    kfree(p);
    800000a0:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000a2:	6985                	lui	s3,0x1
    kfree(p);
    800000a4:	01448533          	add	a0,s1,s4
    800000a8:	f75ff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000ac:	94ce                	add	s1,s1,s3
    800000ae:	fe997be3          	bgeu	s2,s1,800000a4 <freerange+0x2a>
    800000b2:	6942                	ld	s2,16(sp)
    800000b4:	69a2                	ld	s3,8(sp)
    800000b6:	6a02                	ld	s4,0(sp)
}
    800000b8:	70a2                	ld	ra,40(sp)
    800000ba:	7402                	ld	s0,32(sp)
    800000bc:	64e2                	ld	s1,24(sp)
    800000be:	6145                	addi	sp,sp,48
    800000c0:	8082                	ret

00000000800000c2 <kinit>:
{
    800000c2:	1141                	addi	sp,sp,-16
    800000c4:	e406                	sd	ra,8(sp)
    800000c6:	e022                	sd	s0,0(sp)
    800000c8:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000ca:	00007597          	auipc	a1,0x7
    800000ce:	f4658593          	addi	a1,a1,-186 # 80007010 <etext+0x10>
    800000d2:	0000a517          	auipc	a0,0xa
    800000d6:	65e50513          	addi	a0,a0,1630 # 8000a730 <kmem>
    800000da:	0e7050ef          	jal	800059c0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000de:	45c5                	li	a1,17
    800000e0:	05ee                	slli	a1,a1,0x1b
    800000e2:	00024517          	auipc	a0,0x24
    800000e6:	d7e50513          	addi	a0,a0,-642 # 80023e60 <end>
    800000ea:	f91ff0ef          	jal	8000007a <freerange>
}
    800000ee:	60a2                	ld	ra,8(sp)
    800000f0:	6402                	ld	s0,0(sp)
    800000f2:	0141                	addi	sp,sp,16
    800000f4:	8082                	ret

00000000800000f6 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000f6:	1101                	addi	sp,sp,-32
    800000f8:	ec06                	sd	ra,24(sp)
    800000fa:	e822                	sd	s0,16(sp)
    800000fc:	e426                	sd	s1,8(sp)
    800000fe:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000100:	0000a497          	auipc	s1,0xa
    80000104:	63048493          	addi	s1,s1,1584 # 8000a730 <kmem>
    80000108:	8526                	mv	a0,s1
    8000010a:	137050ef          	jal	80005a40 <acquire>
  r = kmem.freelist;
    8000010e:	6c84                	ld	s1,24(s1)
  if(r) {
    80000110:	c491                	beqz	s1,8000011c <kalloc+0x26>
    kmem.freelist = r->next;
    80000112:	609c                	ld	a5,0(s1)
    80000114:	0000a717          	auipc	a4,0xa
    80000118:	62f73a23          	sd	a5,1588(a4) # 8000a748 <kmem+0x18>
  }
  release(&kmem.lock);
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	61450513          	addi	a0,a0,1556 # 8000a730 <kmem>
    80000124:	1b5050ef          	jal	80005ad8 <release>
#ifndef LAB_SYSCALL
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
#endif
  return (void*)r;
}
    80000128:	8526                	mv	a0,s1
    8000012a:	60e2                	ld	ra,24(sp)
    8000012c:	6442                	ld	s0,16(sp)
    8000012e:	64a2                	ld	s1,8(sp)
    80000130:	6105                	addi	sp,sp,32
    80000132:	8082                	ret

0000000080000134 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000134:	1141                	addi	sp,sp,-16
    80000136:	e422                	sd	s0,8(sp)
    80000138:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000013a:	ca19                	beqz	a2,80000150 <memset+0x1c>
    8000013c:	87aa                	mv	a5,a0
    8000013e:	1602                	slli	a2,a2,0x20
    80000140:	9201                	srli	a2,a2,0x20
    80000142:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000146:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000014a:	0785                	addi	a5,a5,1
    8000014c:	fee79de3          	bne	a5,a4,80000146 <memset+0x12>
  }
  return dst;
}
    80000150:	6422                	ld	s0,8(sp)
    80000152:	0141                	addi	sp,sp,16
    80000154:	8082                	ret

0000000080000156 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000156:	1141                	addi	sp,sp,-16
    80000158:	e422                	sd	s0,8(sp)
    8000015a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000015c:	ca05                	beqz	a2,8000018c <memcmp+0x36>
    8000015e:	fff6069b          	addiw	a3,a2,-1
    80000162:	1682                	slli	a3,a3,0x20
    80000164:	9281                	srli	a3,a3,0x20
    80000166:	0685                	addi	a3,a3,1
    80000168:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000016a:	00054783          	lbu	a5,0(a0)
    8000016e:	0005c703          	lbu	a4,0(a1)
    80000172:	00e79863          	bne	a5,a4,80000182 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000176:	0505                	addi	a0,a0,1
    80000178:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000017a:	fed518e3          	bne	a0,a3,8000016a <memcmp+0x14>
  }

  return 0;
    8000017e:	4501                	li	a0,0
    80000180:	a019                	j	80000186 <memcmp+0x30>
      return *s1 - *s2;
    80000182:	40e7853b          	subw	a0,a5,a4
}
    80000186:	6422                	ld	s0,8(sp)
    80000188:	0141                	addi	sp,sp,16
    8000018a:	8082                	ret
  return 0;
    8000018c:	4501                	li	a0,0
    8000018e:	bfe5                	j	80000186 <memcmp+0x30>

0000000080000190 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000190:	1141                	addi	sp,sp,-16
    80000192:	e422                	sd	s0,8(sp)
    80000194:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000196:	c205                	beqz	a2,800001b6 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000198:	02a5e263          	bltu	a1,a0,800001bc <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000019c:	1602                	slli	a2,a2,0x20
    8000019e:	9201                	srli	a2,a2,0x20
    800001a0:	00c587b3          	add	a5,a1,a2
{
    800001a4:	872a                	mv	a4,a0
      *d++ = *s++;
    800001a6:	0585                	addi	a1,a1,1
    800001a8:	0705                	addi	a4,a4,1
    800001aa:	fff5c683          	lbu	a3,-1(a1)
    800001ae:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001b2:	feb79ae3          	bne	a5,a1,800001a6 <memmove+0x16>

  return dst;
}
    800001b6:	6422                	ld	s0,8(sp)
    800001b8:	0141                	addi	sp,sp,16
    800001ba:	8082                	ret
  if(s < d && s + n > d){
    800001bc:	02061693          	slli	a3,a2,0x20
    800001c0:	9281                	srli	a3,a3,0x20
    800001c2:	00d58733          	add	a4,a1,a3
    800001c6:	fce57be3          	bgeu	a0,a4,8000019c <memmove+0xc>
    d += n;
    800001ca:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001cc:	fff6079b          	addiw	a5,a2,-1
    800001d0:	1782                	slli	a5,a5,0x20
    800001d2:	9381                	srli	a5,a5,0x20
    800001d4:	fff7c793          	not	a5,a5
    800001d8:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001da:	177d                	addi	a4,a4,-1
    800001dc:	16fd                	addi	a3,a3,-1
    800001de:	00074603          	lbu	a2,0(a4)
    800001e2:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800001e6:	fef71ae3          	bne	a4,a5,800001da <memmove+0x4a>
    800001ea:	b7f1                	j	800001b6 <memmove+0x26>

00000000800001ec <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800001ec:	1141                	addi	sp,sp,-16
    800001ee:	e406                	sd	ra,8(sp)
    800001f0:	e022                	sd	s0,0(sp)
    800001f2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800001f4:	f9dff0ef          	jal	80000190 <memmove>
}
    800001f8:	60a2                	ld	ra,8(sp)
    800001fa:	6402                	ld	s0,0(sp)
    800001fc:	0141                	addi	sp,sp,16
    800001fe:	8082                	ret

0000000080000200 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000200:	1141                	addi	sp,sp,-16
    80000202:	e422                	sd	s0,8(sp)
    80000204:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000206:	ce11                	beqz	a2,80000222 <strncmp+0x22>
    80000208:	00054783          	lbu	a5,0(a0)
    8000020c:	cf89                	beqz	a5,80000226 <strncmp+0x26>
    8000020e:	0005c703          	lbu	a4,0(a1)
    80000212:	00f71a63          	bne	a4,a5,80000226 <strncmp+0x26>
    n--, p++, q++;
    80000216:	367d                	addiw	a2,a2,-1
    80000218:	0505                	addi	a0,a0,1
    8000021a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000021c:	f675                	bnez	a2,80000208 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000021e:	4501                	li	a0,0
    80000220:	a801                	j	80000230 <strncmp+0x30>
    80000222:	4501                	li	a0,0
    80000224:	a031                	j	80000230 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000226:	00054503          	lbu	a0,0(a0)
    8000022a:	0005c783          	lbu	a5,0(a1)
    8000022e:	9d1d                	subw	a0,a0,a5
}
    80000230:	6422                	ld	s0,8(sp)
    80000232:	0141                	addi	sp,sp,16
    80000234:	8082                	ret

0000000080000236 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000236:	1141                	addi	sp,sp,-16
    80000238:	e422                	sd	s0,8(sp)
    8000023a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000023c:	87aa                	mv	a5,a0
    8000023e:	86b2                	mv	a3,a2
    80000240:	367d                	addiw	a2,a2,-1
    80000242:	02d05563          	blez	a3,8000026c <strncpy+0x36>
    80000246:	0785                	addi	a5,a5,1
    80000248:	0005c703          	lbu	a4,0(a1)
    8000024c:	fee78fa3          	sb	a4,-1(a5)
    80000250:	0585                	addi	a1,a1,1
    80000252:	f775                	bnez	a4,8000023e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000254:	873e                	mv	a4,a5
    80000256:	9fb5                	addw	a5,a5,a3
    80000258:	37fd                	addiw	a5,a5,-1
    8000025a:	00c05963          	blez	a2,8000026c <strncpy+0x36>
    *s++ = 0;
    8000025e:	0705                	addi	a4,a4,1
    80000260:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000264:	40e786bb          	subw	a3,a5,a4
    80000268:	fed04be3          	bgtz	a3,8000025e <strncpy+0x28>
  return os;
}
    8000026c:	6422                	ld	s0,8(sp)
    8000026e:	0141                	addi	sp,sp,16
    80000270:	8082                	ret

0000000080000272 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000272:	1141                	addi	sp,sp,-16
    80000274:	e422                	sd	s0,8(sp)
    80000276:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000278:	02c05363          	blez	a2,8000029e <safestrcpy+0x2c>
    8000027c:	fff6069b          	addiw	a3,a2,-1
    80000280:	1682                	slli	a3,a3,0x20
    80000282:	9281                	srli	a3,a3,0x20
    80000284:	96ae                	add	a3,a3,a1
    80000286:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000288:	00d58963          	beq	a1,a3,8000029a <safestrcpy+0x28>
    8000028c:	0585                	addi	a1,a1,1
    8000028e:	0785                	addi	a5,a5,1
    80000290:	fff5c703          	lbu	a4,-1(a1)
    80000294:	fee78fa3          	sb	a4,-1(a5)
    80000298:	fb65                	bnez	a4,80000288 <safestrcpy+0x16>
    ;
  *s = 0;
    8000029a:	00078023          	sb	zero,0(a5)
  return os;
}
    8000029e:	6422                	ld	s0,8(sp)
    800002a0:	0141                	addi	sp,sp,16
    800002a2:	8082                	ret

00000000800002a4 <strlen>:

int
strlen(const char *s)
{
    800002a4:	1141                	addi	sp,sp,-16
    800002a6:	e422                	sd	s0,8(sp)
    800002a8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002aa:	00054783          	lbu	a5,0(a0)
    800002ae:	cf91                	beqz	a5,800002ca <strlen+0x26>
    800002b0:	0505                	addi	a0,a0,1
    800002b2:	87aa                	mv	a5,a0
    800002b4:	86be                	mv	a3,a5
    800002b6:	0785                	addi	a5,a5,1
    800002b8:	fff7c703          	lbu	a4,-1(a5)
    800002bc:	ff65                	bnez	a4,800002b4 <strlen+0x10>
    800002be:	40a6853b          	subw	a0,a3,a0
    800002c2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret
  for(n = 0; s[n]; n++)
    800002ca:	4501                	li	a0,0
    800002cc:	bfe5                	j	800002c4 <strlen+0x20>

00000000800002ce <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002ce:	1141                	addi	sp,sp,-16
    800002d0:	e406                	sd	ra,8(sp)
    800002d2:	e022                	sd	s0,0(sp)
    800002d4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002d6:	255000ef          	jal	80000d2a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002da:	0000a717          	auipc	a4,0xa
    800002de:	42670713          	addi	a4,a4,1062 # 8000a700 <started>
  if(cpuid() == 0){
    800002e2:	c51d                	beqz	a0,80000310 <main+0x42>
    while(started == 0)
    800002e4:	431c                	lw	a5,0(a4)
    800002e6:	2781                	sext.w	a5,a5
    800002e8:	dff5                	beqz	a5,800002e4 <main+0x16>
      ;
    __sync_synchronize();
    800002ea:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    800002ee:	23d000ef          	jal	80000d2a <cpuid>
    800002f2:	85aa                	mv	a1,a0
    800002f4:	00007517          	auipc	a0,0x7
    800002f8:	d4450513          	addi	a0,a0,-700 # 80007038 <etext+0x38>
    800002fc:	144050ef          	jal	80005440 <printf>
    kvminithart();    // turn on paging
    80000300:	080000ef          	jal	80000380 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000304:	54e010ef          	jal	80001852 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000308:	6f0040ef          	jal	800049f8 <plicinithart>
  }

  scheduler();        
    8000030c:	68b000ef          	jal	80001196 <scheduler>
    consoleinit();
    80000310:	05a050ef          	jal	8000536a <consoleinit>
    printfinit();
    80000314:	438050ef          	jal	8000574c <printfinit>
    printf("\n");
    80000318:	00007517          	auipc	a0,0x7
    8000031c:	d0050513          	addi	a0,a0,-768 # 80007018 <etext+0x18>
    80000320:	120050ef          	jal	80005440 <printf>
    printf("xv6 kernel is booting\n");
    80000324:	00007517          	auipc	a0,0x7
    80000328:	cfc50513          	addi	a0,a0,-772 # 80007020 <etext+0x20>
    8000032c:	114050ef          	jal	80005440 <printf>
    printf("\n");
    80000330:	00007517          	auipc	a0,0x7
    80000334:	ce850513          	addi	a0,a0,-792 # 80007018 <etext+0x18>
    80000338:	108050ef          	jal	80005440 <printf>
    kinit();         // physical page allocator
    8000033c:	d87ff0ef          	jal	800000c2 <kinit>
    kvminit();       // create kernel page table
    80000340:	2ca000ef          	jal	8000060a <kvminit>
    kvminithart();   // turn on paging
    80000344:	03c000ef          	jal	80000380 <kvminithart>
    procinit();      // process table
    80000348:	12d000ef          	jal	80000c74 <procinit>
    trapinit();      // trap vectors
    8000034c:	4e2010ef          	jal	8000182e <trapinit>
    trapinithart();  // install kernel trap vector
    80000350:	502010ef          	jal	80001852 <trapinithart>
    plicinit();      // set up interrupt controller
    80000354:	68a040ef          	jal	800049de <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000358:	6a0040ef          	jal	800049f8 <plicinithart>
    binit();         // buffer cache
    8000035c:	64b010ef          	jal	800021a6 <binit>
    iinit();         // inode table
    80000360:	43c020ef          	jal	8000279c <iinit>
    fileinit();      // file table
    80000364:	1e8030ef          	jal	8000354c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000368:	780040ef          	jal	80004ae8 <virtio_disk_init>
    userinit();      // first user process
    8000036c:	457000ef          	jal	80000fc2 <userinit>
    __sync_synchronize();
    80000370:	0330000f          	fence	rw,rw
    started = 1;
    80000374:	4785                	li	a5,1
    80000376:	0000a717          	auipc	a4,0xa
    8000037a:	38f72523          	sw	a5,906(a4) # 8000a700 <started>
    8000037e:	b779                	j	8000030c <main+0x3e>

0000000080000380 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000380:	1141                	addi	sp,sp,-16
    80000382:	e422                	sd	s0,8(sp)
    80000384:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000386:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000038a:	0000a797          	auipc	a5,0xa
    8000038e:	37e7b783          	ld	a5,894(a5) # 8000a708 <kernel_pagetable>
    80000392:	83b1                	srli	a5,a5,0xc
    80000394:	577d                	li	a4,-1
    80000396:	177e                	slli	a4,a4,0x3f
    80000398:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000039a:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000039e:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003a2:	6422                	ld	s0,8(sp)
    800003a4:	0141                	addi	sp,sp,16
    800003a6:	8082                	ret

00000000800003a8 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003a8:	7139                	addi	sp,sp,-64
    800003aa:	fc06                	sd	ra,56(sp)
    800003ac:	f822                	sd	s0,48(sp)
    800003ae:	f426                	sd	s1,40(sp)
    800003b0:	f04a                	sd	s2,32(sp)
    800003b2:	ec4e                	sd	s3,24(sp)
    800003b4:	e852                	sd	s4,16(sp)
    800003b6:	e456                	sd	s5,8(sp)
    800003b8:	e05a                	sd	s6,0(sp)
    800003ba:	0080                	addi	s0,sp,64
    800003bc:	84aa                	mv	s1,a0
    800003be:	89ae                	mv	s3,a1
    800003c0:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003c2:	57fd                	li	a5,-1
    800003c4:	83e9                	srli	a5,a5,0x1a
    800003c6:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003c8:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003ca:	02b7fc63          	bgeu	a5,a1,80000402 <walk+0x5a>
    panic("walk");
    800003ce:	00007517          	auipc	a0,0x7
    800003d2:	c8250513          	addi	a0,a0,-894 # 80007050 <etext+0x50>
    800003d6:	33c050ef          	jal	80005712 <panic>
      if(PTE_LEAF(*pte)) {
        return pte;
      }
#endif
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800003da:	060a8263          	beqz	s5,8000043e <walk+0x96>
    800003de:	d19ff0ef          	jal	800000f6 <kalloc>
    800003e2:	84aa                	mv	s1,a0
    800003e4:	c139                	beqz	a0,8000042a <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800003e6:	6605                	lui	a2,0x1
    800003e8:	4581                	li	a1,0
    800003ea:	d4bff0ef          	jal	80000134 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800003ee:	00c4d793          	srli	a5,s1,0xc
    800003f2:	07aa                	slli	a5,a5,0xa
    800003f4:	0017e793          	ori	a5,a5,1
    800003f8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800003fc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb197>
    800003fe:	036a0063          	beq	s4,s6,8000041e <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000402:	0149d933          	srl	s2,s3,s4
    80000406:	1ff97913          	andi	s2,s2,511
    8000040a:	090e                	slli	s2,s2,0x3
    8000040c:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000040e:	00093483          	ld	s1,0(s2)
    80000412:	0014f793          	andi	a5,s1,1
    80000416:	d3f1                	beqz	a5,800003da <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000418:	80a9                	srli	s1,s1,0xa
    8000041a:	04b2                	slli	s1,s1,0xc
    8000041c:	b7c5                	j	800003fc <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    8000041e:	00c9d513          	srli	a0,s3,0xc
    80000422:	1ff57513          	andi	a0,a0,511
    80000426:	050e                	slli	a0,a0,0x3
    80000428:	9526                	add	a0,a0,s1
}
    8000042a:	70e2                	ld	ra,56(sp)
    8000042c:	7442                	ld	s0,48(sp)
    8000042e:	74a2                	ld	s1,40(sp)
    80000430:	7902                	ld	s2,32(sp)
    80000432:	69e2                	ld	s3,24(sp)
    80000434:	6a42                	ld	s4,16(sp)
    80000436:	6aa2                	ld	s5,8(sp)
    80000438:	6b02                	ld	s6,0(sp)
    8000043a:	6121                	addi	sp,sp,64
    8000043c:	8082                	ret
        return 0;
    8000043e:	4501                	li	a0,0
    80000440:	b7ed                	j	8000042a <walk+0x82>

0000000080000442 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000442:	57fd                	li	a5,-1
    80000444:	83e9                	srli	a5,a5,0x1a
    80000446:	00b7f463          	bgeu	a5,a1,8000044e <walkaddr+0xc>
    return 0;
    8000044a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000044c:	8082                	ret
{
    8000044e:	1141                	addi	sp,sp,-16
    80000450:	e406                	sd	ra,8(sp)
    80000452:	e022                	sd	s0,0(sp)
    80000454:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000456:	4601                	li	a2,0
    80000458:	f51ff0ef          	jal	800003a8 <walk>
  if(pte == 0)
    8000045c:	c105                	beqz	a0,8000047c <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    8000045e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000460:	0117f693          	andi	a3,a5,17
    80000464:	4745                	li	a4,17
    return 0;
    80000466:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000468:	00e68663          	beq	a3,a4,80000474 <walkaddr+0x32>
}
    8000046c:	60a2                	ld	ra,8(sp)
    8000046e:	6402                	ld	s0,0(sp)
    80000470:	0141                	addi	sp,sp,16
    80000472:	8082                	ret
  pa = PTE2PA(*pte);
    80000474:	83a9                	srli	a5,a5,0xa
    80000476:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000047a:	bfcd                	j	8000046c <walkaddr+0x2a>
    return 0;
    8000047c:	4501                	li	a0,0
    8000047e:	b7fd                	j	8000046c <walkaddr+0x2a>

0000000080000480 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000480:	715d                	addi	sp,sp,-80
    80000482:	e486                	sd	ra,72(sp)
    80000484:	e0a2                	sd	s0,64(sp)
    80000486:	fc26                	sd	s1,56(sp)
    80000488:	f84a                	sd	s2,48(sp)
    8000048a:	f44e                	sd	s3,40(sp)
    8000048c:	f052                	sd	s4,32(sp)
    8000048e:	ec56                	sd	s5,24(sp)
    80000490:	e85a                	sd	s6,16(sp)
    80000492:	e45e                	sd	s7,8(sp)
    80000494:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000496:	03459793          	slli	a5,a1,0x34
    8000049a:	e7a9                	bnez	a5,800004e4 <mappages+0x64>
    8000049c:	8aaa                	mv	s5,a0
    8000049e:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004a0:	03461793          	slli	a5,a2,0x34
    800004a4:	e7b1                	bnez	a5,800004f0 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004a6:	ca39                	beqz	a2,800004fc <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004a8:	77fd                	lui	a5,0xfffff
    800004aa:	963e                	add	a2,a2,a5
    800004ac:	00b609b3          	add	s3,a2,a1
  a = va;
    800004b0:	892e                	mv	s2,a1
    800004b2:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004b6:	6b85                	lui	s7,0x1
    800004b8:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004bc:	4605                	li	a2,1
    800004be:	85ca                	mv	a1,s2
    800004c0:	8556                	mv	a0,s5
    800004c2:	ee7ff0ef          	jal	800003a8 <walk>
    800004c6:	c539                	beqz	a0,80000514 <mappages+0x94>
    if(*pte & PTE_V)
    800004c8:	611c                	ld	a5,0(a0)
    800004ca:	8b85                	andi	a5,a5,1
    800004cc:	ef95                	bnez	a5,80000508 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800004ce:	80b1                	srli	s1,s1,0xc
    800004d0:	04aa                	slli	s1,s1,0xa
    800004d2:	0164e4b3          	or	s1,s1,s6
    800004d6:	0014e493          	ori	s1,s1,1
    800004da:	e104                	sd	s1,0(a0)
    if(a == last)
    800004dc:	05390863          	beq	s2,s3,8000052c <mappages+0xac>
    a += PGSIZE;
    800004e0:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800004e2:	bfd9                	j	800004b8 <mappages+0x38>
    panic("mappages: va not aligned");
    800004e4:	00007517          	auipc	a0,0x7
    800004e8:	b7450513          	addi	a0,a0,-1164 # 80007058 <etext+0x58>
    800004ec:	226050ef          	jal	80005712 <panic>
    panic("mappages: size not aligned");
    800004f0:	00007517          	auipc	a0,0x7
    800004f4:	b8850513          	addi	a0,a0,-1144 # 80007078 <etext+0x78>
    800004f8:	21a050ef          	jal	80005712 <panic>
    panic("mappages: size");
    800004fc:	00007517          	auipc	a0,0x7
    80000500:	b9c50513          	addi	a0,a0,-1124 # 80007098 <etext+0x98>
    80000504:	20e050ef          	jal	80005712 <panic>
      panic("mappages: remap");
    80000508:	00007517          	auipc	a0,0x7
    8000050c:	ba050513          	addi	a0,a0,-1120 # 800070a8 <etext+0xa8>
    80000510:	202050ef          	jal	80005712 <panic>
      return -1;
    80000514:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000516:	60a6                	ld	ra,72(sp)
    80000518:	6406                	ld	s0,64(sp)
    8000051a:	74e2                	ld	s1,56(sp)
    8000051c:	7942                	ld	s2,48(sp)
    8000051e:	79a2                	ld	s3,40(sp)
    80000520:	7a02                	ld	s4,32(sp)
    80000522:	6ae2                	ld	s5,24(sp)
    80000524:	6b42                	ld	s6,16(sp)
    80000526:	6ba2                	ld	s7,8(sp)
    80000528:	6161                	addi	sp,sp,80
    8000052a:	8082                	ret
  return 0;
    8000052c:	4501                	li	a0,0
    8000052e:	b7e5                	j	80000516 <mappages+0x96>

0000000080000530 <kvmmap>:
{
    80000530:	1141                	addi	sp,sp,-16
    80000532:	e406                	sd	ra,8(sp)
    80000534:	e022                	sd	s0,0(sp)
    80000536:	0800                	addi	s0,sp,16
    80000538:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000053a:	86b2                	mv	a3,a2
    8000053c:	863e                	mv	a2,a5
    8000053e:	f43ff0ef          	jal	80000480 <mappages>
    80000542:	e509                	bnez	a0,8000054c <kvmmap+0x1c>
}
    80000544:	60a2                	ld	ra,8(sp)
    80000546:	6402                	ld	s0,0(sp)
    80000548:	0141                	addi	sp,sp,16
    8000054a:	8082                	ret
    panic("kvmmap");
    8000054c:	00007517          	auipc	a0,0x7
    80000550:	b6c50513          	addi	a0,a0,-1172 # 800070b8 <etext+0xb8>
    80000554:	1be050ef          	jal	80005712 <panic>

0000000080000558 <kvmmake>:
{
    80000558:	1101                	addi	sp,sp,-32
    8000055a:	ec06                	sd	ra,24(sp)
    8000055c:	e822                	sd	s0,16(sp)
    8000055e:	e426                	sd	s1,8(sp)
    80000560:	e04a                	sd	s2,0(sp)
    80000562:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000564:	b93ff0ef          	jal	800000f6 <kalloc>
    80000568:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000056a:	6605                	lui	a2,0x1
    8000056c:	4581                	li	a1,0
    8000056e:	bc7ff0ef          	jal	80000134 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000572:	4719                	li	a4,6
    80000574:	6685                	lui	a3,0x1
    80000576:	10000637          	lui	a2,0x10000
    8000057a:	100005b7          	lui	a1,0x10000
    8000057e:	8526                	mv	a0,s1
    80000580:	fb1ff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000584:	4719                	li	a4,6
    80000586:	6685                	lui	a3,0x1
    80000588:	10001637          	lui	a2,0x10001
    8000058c:	100015b7          	lui	a1,0x10001
    80000590:	8526                	mv	a0,s1
    80000592:	f9fff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80000596:	4719                	li	a4,6
    80000598:	040006b7          	lui	a3,0x4000
    8000059c:	0c000637          	lui	a2,0xc000
    800005a0:	0c0005b7          	lui	a1,0xc000
    800005a4:	8526                	mv	a0,s1
    800005a6:	f8bff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005aa:	00007917          	auipc	s2,0x7
    800005ae:	a5690913          	addi	s2,s2,-1450 # 80007000 <etext>
    800005b2:	4729                	li	a4,10
    800005b4:	80007697          	auipc	a3,0x80007
    800005b8:	a4c68693          	addi	a3,a3,-1460 # 7000 <_entry-0x7fff9000>
    800005bc:	4605                	li	a2,1
    800005be:	067e                	slli	a2,a2,0x1f
    800005c0:	85b2                	mv	a1,a2
    800005c2:	8526                	mv	a0,s1
    800005c4:	f6dff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005c8:	46c5                	li	a3,17
    800005ca:	06ee                	slli	a3,a3,0x1b
    800005cc:	4719                	li	a4,6
    800005ce:	412686b3          	sub	a3,a3,s2
    800005d2:	864a                	mv	a2,s2
    800005d4:	85ca                	mv	a1,s2
    800005d6:	8526                	mv	a0,s1
    800005d8:	f59ff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800005dc:	4729                	li	a4,10
    800005de:	6685                	lui	a3,0x1
    800005e0:	00006617          	auipc	a2,0x6
    800005e4:	a2060613          	addi	a2,a2,-1504 # 80006000 <_trampoline>
    800005e8:	040005b7          	lui	a1,0x4000
    800005ec:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800005ee:	05b2                	slli	a1,a1,0xc
    800005f0:	8526                	mv	a0,s1
    800005f2:	f3fff0ef          	jal	80000530 <kvmmap>
  proc_mapstacks(kpgtbl);
    800005f6:	8526                	mv	a0,s1
    800005f8:	5e4000ef          	jal	80000bdc <proc_mapstacks>
}
    800005fc:	8526                	mv	a0,s1
    800005fe:	60e2                	ld	ra,24(sp)
    80000600:	6442                	ld	s0,16(sp)
    80000602:	64a2                	ld	s1,8(sp)
    80000604:	6902                	ld	s2,0(sp)
    80000606:	6105                	addi	sp,sp,32
    80000608:	8082                	ret

000000008000060a <kvminit>:
{
    8000060a:	1141                	addi	sp,sp,-16
    8000060c:	e406                	sd	ra,8(sp)
    8000060e:	e022                	sd	s0,0(sp)
    80000610:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000612:	f47ff0ef          	jal	80000558 <kvmmake>
    80000616:	0000a797          	auipc	a5,0xa
    8000061a:	0ea7b923          	sd	a0,242(a5) # 8000a708 <kernel_pagetable>
}
    8000061e:	60a2                	ld	ra,8(sp)
    80000620:	6402                	ld	s0,0(sp)
    80000622:	0141                	addi	sp,sp,16
    80000624:	8082                	ret

0000000080000626 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000626:	715d                	addi	sp,sp,-80
    80000628:	e486                	sd	ra,72(sp)
    8000062a:	e0a2                	sd	s0,64(sp)
    8000062c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz;

  if((va % PGSIZE) != 0)
    8000062e:	03459793          	slli	a5,a1,0x34
    80000632:	e39d                	bnez	a5,80000658 <uvmunmap+0x32>
    80000634:	f84a                	sd	s2,48(sp)
    80000636:	f44e                	sd	s3,40(sp)
    80000638:	f052                	sd	s4,32(sp)
    8000063a:	ec56                	sd	s5,24(sp)
    8000063c:	e85a                	sd	s6,16(sp)
    8000063e:	e45e                	sd	s7,8(sp)
    80000640:	8a2a                	mv	s4,a0
    80000642:	892e                	mv	s2,a1
    80000644:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000646:	0632                	slli	a2,a2,0xc
    80000648:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%ld pte=%ld\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    8000064c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    8000064e:	6b05                	lui	s6,0x1
    80000650:	0935f763          	bgeu	a1,s3,800006de <uvmunmap+0xb8>
    80000654:	fc26                	sd	s1,56(sp)
    80000656:	a8a1                	j	800006ae <uvmunmap+0x88>
    80000658:	fc26                	sd	s1,56(sp)
    8000065a:	f84a                	sd	s2,48(sp)
    8000065c:	f44e                	sd	s3,40(sp)
    8000065e:	f052                	sd	s4,32(sp)
    80000660:	ec56                	sd	s5,24(sp)
    80000662:	e85a                	sd	s6,16(sp)
    80000664:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000666:	00007517          	auipc	a0,0x7
    8000066a:	a5a50513          	addi	a0,a0,-1446 # 800070c0 <etext+0xc0>
    8000066e:	0a4050ef          	jal	80005712 <panic>
      panic("uvmunmap: walk");
    80000672:	00007517          	auipc	a0,0x7
    80000676:	a6650513          	addi	a0,a0,-1434 # 800070d8 <etext+0xd8>
    8000067a:	098050ef          	jal	80005712 <panic>
      printf("va=%ld pte=%ld\n", a, *pte);
    8000067e:	85ca                	mv	a1,s2
    80000680:	00007517          	auipc	a0,0x7
    80000684:	a6850513          	addi	a0,a0,-1432 # 800070e8 <etext+0xe8>
    80000688:	5b9040ef          	jal	80005440 <printf>
      panic("uvmunmap: not mapped");
    8000068c:	00007517          	auipc	a0,0x7
    80000690:	a6c50513          	addi	a0,a0,-1428 # 800070f8 <etext+0xf8>
    80000694:	07e050ef          	jal	80005712 <panic>
      panic("uvmunmap: not a leaf");
    80000698:	00007517          	auipc	a0,0x7
    8000069c:	a7850513          	addi	a0,a0,-1416 # 80007110 <etext+0x110>
    800006a0:	072050ef          	jal	80005712 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006a4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006a8:	995a                	add	s2,s2,s6
    800006aa:	03397963          	bgeu	s2,s3,800006dc <uvmunmap+0xb6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006ae:	4601                	li	a2,0
    800006b0:	85ca                	mv	a1,s2
    800006b2:	8552                	mv	a0,s4
    800006b4:	cf5ff0ef          	jal	800003a8 <walk>
    800006b8:	84aa                	mv	s1,a0
    800006ba:	dd45                	beqz	a0,80000672 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0) {
    800006bc:	6110                	ld	a2,0(a0)
    800006be:	00167793          	andi	a5,a2,1
    800006c2:	dfd5                	beqz	a5,8000067e <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006c4:	3ff67793          	andi	a5,a2,1023
    800006c8:	fd7788e3          	beq	a5,s7,80000698 <uvmunmap+0x72>
    if(do_free){
    800006cc:	fc0a8ce3          	beqz	s5,800006a4 <uvmunmap+0x7e>
      uint64 pa = PTE2PA(*pte);
    800006d0:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    800006d2:	00c61513          	slli	a0,a2,0xc
    800006d6:	947ff0ef          	jal	8000001c <kfree>
    800006da:	b7e9                	j	800006a4 <uvmunmap+0x7e>
    800006dc:	74e2                	ld	s1,56(sp)
    800006de:	7942                	ld	s2,48(sp)
    800006e0:	79a2                	ld	s3,40(sp)
    800006e2:	7a02                	ld	s4,32(sp)
    800006e4:	6ae2                	ld	s5,24(sp)
    800006e6:	6b42                	ld	s6,16(sp)
    800006e8:	6ba2                	ld	s7,8(sp)
  }
}
    800006ea:	60a6                	ld	ra,72(sp)
    800006ec:	6406                	ld	s0,64(sp)
    800006ee:	6161                	addi	sp,sp,80
    800006f0:	8082                	ret

00000000800006f2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800006f2:	1101                	addi	sp,sp,-32
    800006f4:	ec06                	sd	ra,24(sp)
    800006f6:	e822                	sd	s0,16(sp)
    800006f8:	e426                	sd	s1,8(sp)
    800006fa:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800006fc:	9fbff0ef          	jal	800000f6 <kalloc>
    80000700:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000702:	c509                	beqz	a0,8000070c <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000704:	6605                	lui	a2,0x1
    80000706:	4581                	li	a1,0
    80000708:	a2dff0ef          	jal	80000134 <memset>
  return pagetable;
}
    8000070c:	8526                	mv	a0,s1
    8000070e:	60e2                	ld	ra,24(sp)
    80000710:	6442                	ld	s0,16(sp)
    80000712:	64a2                	ld	s1,8(sp)
    80000714:	6105                	addi	sp,sp,32
    80000716:	8082                	ret

0000000080000718 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000718:	7179                	addi	sp,sp,-48
    8000071a:	f406                	sd	ra,40(sp)
    8000071c:	f022                	sd	s0,32(sp)
    8000071e:	ec26                	sd	s1,24(sp)
    80000720:	e84a                	sd	s2,16(sp)
    80000722:	e44e                	sd	s3,8(sp)
    80000724:	e052                	sd	s4,0(sp)
    80000726:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000728:	6785                	lui	a5,0x1
    8000072a:	04f67063          	bgeu	a2,a5,8000076a <uvmfirst+0x52>
    8000072e:	8a2a                	mv	s4,a0
    80000730:	89ae                	mv	s3,a1
    80000732:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000734:	9c3ff0ef          	jal	800000f6 <kalloc>
    80000738:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000073a:	6605                	lui	a2,0x1
    8000073c:	4581                	li	a1,0
    8000073e:	9f7ff0ef          	jal	80000134 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000742:	4779                	li	a4,30
    80000744:	86ca                	mv	a3,s2
    80000746:	6605                	lui	a2,0x1
    80000748:	4581                	li	a1,0
    8000074a:	8552                	mv	a0,s4
    8000074c:	d35ff0ef          	jal	80000480 <mappages>
  memmove(mem, src, sz);
    80000750:	8626                	mv	a2,s1
    80000752:	85ce                	mv	a1,s3
    80000754:	854a                	mv	a0,s2
    80000756:	a3bff0ef          	jal	80000190 <memmove>
}
    8000075a:	70a2                	ld	ra,40(sp)
    8000075c:	7402                	ld	s0,32(sp)
    8000075e:	64e2                	ld	s1,24(sp)
    80000760:	6942                	ld	s2,16(sp)
    80000762:	69a2                	ld	s3,8(sp)
    80000764:	6a02                	ld	s4,0(sp)
    80000766:	6145                	addi	sp,sp,48
    80000768:	8082                	ret
    panic("uvmfirst: more than a page");
    8000076a:	00007517          	auipc	a0,0x7
    8000076e:	9be50513          	addi	a0,a0,-1602 # 80007128 <etext+0x128>
    80000772:	7a1040ef          	jal	80005712 <panic>

0000000080000776 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000776:	1101                	addi	sp,sp,-32
    80000778:	ec06                	sd	ra,24(sp)
    8000077a:	e822                	sd	s0,16(sp)
    8000077c:	e426                	sd	s1,8(sp)
    8000077e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000780:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000782:	00b67d63          	bgeu	a2,a1,8000079c <uvmdealloc+0x26>
    80000786:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000788:	6785                	lui	a5,0x1
    8000078a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000078c:	00f60733          	add	a4,a2,a5
    80000790:	76fd                	lui	a3,0xfffff
    80000792:	8f75                	and	a4,a4,a3
    80000794:	97ae                	add	a5,a5,a1
    80000796:	8ff5                	and	a5,a5,a3
    80000798:	00f76863          	bltu	a4,a5,800007a8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000079c:	8526                	mv	a0,s1
    8000079e:	60e2                	ld	ra,24(sp)
    800007a0:	6442                	ld	s0,16(sp)
    800007a2:	64a2                	ld	s1,8(sp)
    800007a4:	6105                	addi	sp,sp,32
    800007a6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007a8:	8f99                	sub	a5,a5,a4
    800007aa:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007ac:	4685                	li	a3,1
    800007ae:	0007861b          	sext.w	a2,a5
    800007b2:	85ba                	mv	a1,a4
    800007b4:	e73ff0ef          	jal	80000626 <uvmunmap>
    800007b8:	b7d5                	j	8000079c <uvmdealloc+0x26>

00000000800007ba <uvmalloc>:
  if(newsz < oldsz)
    800007ba:	08b66b63          	bltu	a2,a1,80000850 <uvmalloc+0x96>
{
    800007be:	7139                	addi	sp,sp,-64
    800007c0:	fc06                	sd	ra,56(sp)
    800007c2:	f822                	sd	s0,48(sp)
    800007c4:	ec4e                	sd	s3,24(sp)
    800007c6:	e852                	sd	s4,16(sp)
    800007c8:	e456                	sd	s5,8(sp)
    800007ca:	0080                	addi	s0,sp,64
    800007cc:	8aaa                	mv	s5,a0
    800007ce:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800007d0:	6785                	lui	a5,0x1
    800007d2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007d4:	95be                	add	a1,a1,a5
    800007d6:	77fd                	lui	a5,0xfffff
    800007d8:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += sz){
    800007dc:	06c9fc63          	bgeu	s3,a2,80000854 <uvmalloc+0x9a>
    800007e0:	f426                	sd	s1,40(sp)
    800007e2:	f04a                	sd	s2,32(sp)
    800007e4:	e05a                	sd	s6,0(sp)
    800007e6:	894e                	mv	s2,s3
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007e8:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800007ec:	90bff0ef          	jal	800000f6 <kalloc>
    800007f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800007f2:	c115                	beqz	a0,80000816 <uvmalloc+0x5c>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007f4:	875a                	mv	a4,s6
    800007f6:	86aa                	mv	a3,a0
    800007f8:	6605                	lui	a2,0x1
    800007fa:	85ca                	mv	a1,s2
    800007fc:	8556                	mv	a0,s5
    800007fe:	c83ff0ef          	jal	80000480 <mappages>
    80000802:	e915                	bnez	a0,80000836 <uvmalloc+0x7c>
  for(a = oldsz; a < newsz; a += sz){
    80000804:	6785                	lui	a5,0x1
    80000806:	993e                	add	s2,s2,a5
    80000808:	ff4962e3          	bltu	s2,s4,800007ec <uvmalloc+0x32>
  return newsz;
    8000080c:	8552                	mv	a0,s4
    8000080e:	74a2                	ld	s1,40(sp)
    80000810:	7902                	ld	s2,32(sp)
    80000812:	6b02                	ld	s6,0(sp)
    80000814:	a811                	j	80000828 <uvmalloc+0x6e>
      uvmdealloc(pagetable, a, oldsz);
    80000816:	864e                	mv	a2,s3
    80000818:	85ca                	mv	a1,s2
    8000081a:	8556                	mv	a0,s5
    8000081c:	f5bff0ef          	jal	80000776 <uvmdealloc>
      return 0;
    80000820:	4501                	li	a0,0
    80000822:	74a2                	ld	s1,40(sp)
    80000824:	7902                	ld	s2,32(sp)
    80000826:	6b02                	ld	s6,0(sp)
}
    80000828:	70e2                	ld	ra,56(sp)
    8000082a:	7442                	ld	s0,48(sp)
    8000082c:	69e2                	ld	s3,24(sp)
    8000082e:	6a42                	ld	s4,16(sp)
    80000830:	6aa2                	ld	s5,8(sp)
    80000832:	6121                	addi	sp,sp,64
    80000834:	8082                	ret
      kfree(mem);
    80000836:	8526                	mv	a0,s1
    80000838:	fe4ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000083c:	864e                	mv	a2,s3
    8000083e:	85ca                	mv	a1,s2
    80000840:	8556                	mv	a0,s5
    80000842:	f35ff0ef          	jal	80000776 <uvmdealloc>
      return 0;
    80000846:	4501                	li	a0,0
    80000848:	74a2                	ld	s1,40(sp)
    8000084a:	7902                	ld	s2,32(sp)
    8000084c:	6b02                	ld	s6,0(sp)
    8000084e:	bfe9                	j	80000828 <uvmalloc+0x6e>
    return oldsz;
    80000850:	852e                	mv	a0,a1
}
    80000852:	8082                	ret
  return newsz;
    80000854:	8532                	mv	a0,a2
    80000856:	bfc9                	j	80000828 <uvmalloc+0x6e>

0000000080000858 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000858:	7179                	addi	sp,sp,-48
    8000085a:	f406                	sd	ra,40(sp)
    8000085c:	f022                	sd	s0,32(sp)
    8000085e:	ec26                	sd	s1,24(sp)
    80000860:	e84a                	sd	s2,16(sp)
    80000862:	e44e                	sd	s3,8(sp)
    80000864:	e052                	sd	s4,0(sp)
    80000866:	1800                	addi	s0,sp,48
    80000868:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000086a:	84aa                	mv	s1,a0
    8000086c:	6905                	lui	s2,0x1
    8000086e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000870:	4985                	li	s3,1
    80000872:	a819                	j	80000888 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000874:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000876:	00c79513          	slli	a0,a5,0xc
    8000087a:	fdfff0ef          	jal	80000858 <freewalk>
      pagetable[i] = 0;
    8000087e:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000882:	04a1                	addi	s1,s1,8
    80000884:	01248f63          	beq	s1,s2,800008a2 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80000888:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000088a:	00f7f713          	andi	a4,a5,15
    8000088e:	ff3703e3          	beq	a4,s3,80000874 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000892:	8b85                	andi	a5,a5,1
    80000894:	d7fd                	beqz	a5,80000882 <freewalk+0x2a>
      panic("freewalk: leaf");
    80000896:	00007517          	auipc	a0,0x7
    8000089a:	8b250513          	addi	a0,a0,-1870 # 80007148 <etext+0x148>
    8000089e:	675040ef          	jal	80005712 <panic>
    }
  }
  kfree((void*)pagetable);
    800008a2:	8552                	mv	a0,s4
    800008a4:	f78ff0ef          	jal	8000001c <kfree>
}
    800008a8:	70a2                	ld	ra,40(sp)
    800008aa:	7402                	ld	s0,32(sp)
    800008ac:	64e2                	ld	s1,24(sp)
    800008ae:	6942                	ld	s2,16(sp)
    800008b0:	69a2                	ld	s3,8(sp)
    800008b2:	6a02                	ld	s4,0(sp)
    800008b4:	6145                	addi	sp,sp,48
    800008b6:	8082                	ret

00000000800008b8 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008b8:	1101                	addi	sp,sp,-32
    800008ba:	ec06                	sd	ra,24(sp)
    800008bc:	e822                	sd	s0,16(sp)
    800008be:	e426                	sd	s1,8(sp)
    800008c0:	1000                	addi	s0,sp,32
    800008c2:	84aa                	mv	s1,a0
  if(sz > 0)
    800008c4:	e989                	bnez	a1,800008d6 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800008c6:	8526                	mv	a0,s1
    800008c8:	f91ff0ef          	jal	80000858 <freewalk>
}
    800008cc:	60e2                	ld	ra,24(sp)
    800008ce:	6442                	ld	s0,16(sp)
    800008d0:	64a2                	ld	s1,8(sp)
    800008d2:	6105                	addi	sp,sp,32
    800008d4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800008d6:	6785                	lui	a5,0x1
    800008d8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008da:	95be                	add	a1,a1,a5
    800008dc:	4685                	li	a3,1
    800008de:	00c5d613          	srli	a2,a1,0xc
    800008e2:	4581                	li	a1,0
    800008e4:	d43ff0ef          	jal	80000626 <uvmunmap>
    800008e8:	bff9                	j	800008c6 <uvmfree+0xe>

00000000800008ea <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc;

  for(i = 0; i < sz; i += szinc){
    800008ea:	c65d                	beqz	a2,80000998 <uvmcopy+0xae>
{
    800008ec:	715d                	addi	sp,sp,-80
    800008ee:	e486                	sd	ra,72(sp)
    800008f0:	e0a2                	sd	s0,64(sp)
    800008f2:	fc26                	sd	s1,56(sp)
    800008f4:	f84a                	sd	s2,48(sp)
    800008f6:	f44e                	sd	s3,40(sp)
    800008f8:	f052                	sd	s4,32(sp)
    800008fa:	ec56                	sd	s5,24(sp)
    800008fc:	e85a                	sd	s6,16(sp)
    800008fe:	e45e                	sd	s7,8(sp)
    80000900:	0880                	addi	s0,sp,80
    80000902:	8b2a                	mv	s6,a0
    80000904:	8aae                	mv	s5,a1
    80000906:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += szinc){
    80000908:	4981                	li	s3,0
    szinc = PGSIZE;
    szinc = PGSIZE;
    if((pte = walk(old, i, 0)) == 0)
    8000090a:	4601                	li	a2,0
    8000090c:	85ce                	mv	a1,s3
    8000090e:	855a                	mv	a0,s6
    80000910:	a99ff0ef          	jal	800003a8 <walk>
    80000914:	c121                	beqz	a0,80000954 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000916:	6118                	ld	a4,0(a0)
    80000918:	00177793          	andi	a5,a4,1
    8000091c:	c3b1                	beqz	a5,80000960 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000091e:	00a75593          	srli	a1,a4,0xa
    80000922:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000926:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000092a:	fccff0ef          	jal	800000f6 <kalloc>
    8000092e:	892a                	mv	s2,a0
    80000930:	c129                	beqz	a0,80000972 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000932:	6605                	lui	a2,0x1
    80000934:	85de                	mv	a1,s7
    80000936:	85bff0ef          	jal	80000190 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000093a:	8726                	mv	a4,s1
    8000093c:	86ca                	mv	a3,s2
    8000093e:	6605                	lui	a2,0x1
    80000940:	85ce                	mv	a1,s3
    80000942:	8556                	mv	a0,s5
    80000944:	b3dff0ef          	jal	80000480 <mappages>
    80000948:	e115                	bnez	a0,8000096c <uvmcopy+0x82>
  for(i = 0; i < sz; i += szinc){
    8000094a:	6785                	lui	a5,0x1
    8000094c:	99be                	add	s3,s3,a5
    8000094e:	fb49eee3          	bltu	s3,s4,8000090a <uvmcopy+0x20>
    80000952:	a805                	j	80000982 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80000954:	00007517          	auipc	a0,0x7
    80000958:	80450513          	addi	a0,a0,-2044 # 80007158 <etext+0x158>
    8000095c:	5b7040ef          	jal	80005712 <panic>
      panic("uvmcopy: page not present");
    80000960:	00007517          	auipc	a0,0x7
    80000964:	81850513          	addi	a0,a0,-2024 # 80007178 <etext+0x178>
    80000968:	5ab040ef          	jal	80005712 <panic>
      kfree(mem);
    8000096c:	854a                	mv	a0,s2
    8000096e:	eaeff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000972:	4685                	li	a3,1
    80000974:	00c9d613          	srli	a2,s3,0xc
    80000978:	4581                	li	a1,0
    8000097a:	8556                	mv	a0,s5
    8000097c:	cabff0ef          	jal	80000626 <uvmunmap>
  return -1;
    80000980:	557d                	li	a0,-1
}
    80000982:	60a6                	ld	ra,72(sp)
    80000984:	6406                	ld	s0,64(sp)
    80000986:	74e2                	ld	s1,56(sp)
    80000988:	7942                	ld	s2,48(sp)
    8000098a:	79a2                	ld	s3,40(sp)
    8000098c:	7a02                	ld	s4,32(sp)
    8000098e:	6ae2                	ld	s5,24(sp)
    80000990:	6b42                	ld	s6,16(sp)
    80000992:	6ba2                	ld	s7,8(sp)
    80000994:	6161                	addi	sp,sp,80
    80000996:	8082                	ret
  return 0;
    80000998:	4501                	li	a0,0
}
    8000099a:	8082                	ret

000000008000099c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000099c:	1141                	addi	sp,sp,-16
    8000099e:	e406                	sd	ra,8(sp)
    800009a0:	e022                	sd	s0,0(sp)
    800009a2:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009a4:	4601                	li	a2,0
    800009a6:	a03ff0ef          	jal	800003a8 <walk>
  if(pte == 0)
    800009aa:	c901                	beqz	a0,800009ba <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009ac:	611c                	ld	a5,0(a0)
    800009ae:	9bbd                	andi	a5,a5,-17
    800009b0:	e11c                	sd	a5,0(a0)
}
    800009b2:	60a2                	ld	ra,8(sp)
    800009b4:	6402                	ld	s0,0(sp)
    800009b6:	0141                	addi	sp,sp,16
    800009b8:	8082                	ret
    panic("uvmclear");
    800009ba:	00006517          	auipc	a0,0x6
    800009be:	7de50513          	addi	a0,a0,2014 # 80007198 <etext+0x198>
    800009c2:	551040ef          	jal	80005712 <panic>

00000000800009c6 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    800009c6:	cac1                	beqz	a3,80000a56 <copyout+0x90>
{
    800009c8:	711d                	addi	sp,sp,-96
    800009ca:	ec86                	sd	ra,88(sp)
    800009cc:	e8a2                	sd	s0,80(sp)
    800009ce:	e4a6                	sd	s1,72(sp)
    800009d0:	fc4e                	sd	s3,56(sp)
    800009d2:	f852                	sd	s4,48(sp)
    800009d4:	f456                	sd	s5,40(sp)
    800009d6:	f05a                	sd	s6,32(sp)
    800009d8:	1080                	addi	s0,sp,96
    800009da:	8b2a                	mv	s6,a0
    800009dc:	8a2e                	mv	s4,a1
    800009de:	8ab2                	mv	s5,a2
    800009e0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800009e2:	74fd                	lui	s1,0xfffff
    800009e4:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA)
    800009e6:	57fd                	li	a5,-1
    800009e8:	83e9                	srli	a5,a5,0x1a
    800009ea:	0697e863          	bltu	a5,s1,80000a5a <copyout+0x94>
    800009ee:	e0ca                	sd	s2,64(sp)
    800009f0:	ec5e                	sd	s7,24(sp)
    800009f2:	e862                	sd	s8,16(sp)
    800009f4:	e466                	sd	s9,8(sp)
    800009f6:	6c05                	lui	s8,0x1
    800009f8:	8bbe                	mv	s7,a5
    800009fa:	a015                	j	80000a1e <copyout+0x58>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800009fc:	409a04b3          	sub	s1,s4,s1
    80000a00:	0009061b          	sext.w	a2,s2
    80000a04:	85d6                	mv	a1,s5
    80000a06:	9526                	add	a0,a0,s1
    80000a08:	f88ff0ef          	jal	80000190 <memmove>

    len -= n;
    80000a0c:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a10:	9aca                	add	s5,s5,s2
  while(len > 0){
    80000a12:	02098c63          	beqz	s3,80000a4a <copyout+0x84>
    if (va0 >= MAXVA)
    80000a16:	059be463          	bltu	s7,s9,80000a5e <copyout+0x98>
    80000a1a:	84e6                	mv	s1,s9
    80000a1c:	8a66                	mv	s4,s9
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000a1e:	4601                	li	a2,0
    80000a20:	85a6                	mv	a1,s1
    80000a22:	855a                	mv	a0,s6
    80000a24:	985ff0ef          	jal	800003a8 <walk>
    80000a28:	c129                	beqz	a0,80000a6a <copyout+0xa4>
    if((*pte & PTE_W) == 0)
    80000a2a:	611c                	ld	a5,0(a0)
    80000a2c:	8b91                	andi	a5,a5,4
    80000a2e:	cfa1                	beqz	a5,80000a86 <copyout+0xc0>
    pa0 = walkaddr(pagetable, va0);
    80000a30:	85a6                	mv	a1,s1
    80000a32:	855a                	mv	a0,s6
    80000a34:	a0fff0ef          	jal	80000442 <walkaddr>
    if(pa0 == 0)
    80000a38:	cd29                	beqz	a0,80000a92 <copyout+0xcc>
    n = PGSIZE - (dstva - va0);
    80000a3a:	01848cb3          	add	s9,s1,s8
    80000a3e:	414c8933          	sub	s2,s9,s4
    if(n > len)
    80000a42:	fb29fde3          	bgeu	s3,s2,800009fc <copyout+0x36>
    80000a46:	894e                	mv	s2,s3
    80000a48:	bf55                	j	800009fc <copyout+0x36>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000a4a:	4501                	li	a0,0
    80000a4c:	6906                	ld	s2,64(sp)
    80000a4e:	6be2                	ld	s7,24(sp)
    80000a50:	6c42                	ld	s8,16(sp)
    80000a52:	6ca2                	ld	s9,8(sp)
    80000a54:	a005                	j	80000a74 <copyout+0xae>
    80000a56:	4501                	li	a0,0
}
    80000a58:	8082                	ret
      return -1;
    80000a5a:	557d                	li	a0,-1
    80000a5c:	a821                	j	80000a74 <copyout+0xae>
    80000a5e:	557d                	li	a0,-1
    80000a60:	6906                	ld	s2,64(sp)
    80000a62:	6be2                	ld	s7,24(sp)
    80000a64:	6c42                	ld	s8,16(sp)
    80000a66:	6ca2                	ld	s9,8(sp)
    80000a68:	a031                	j	80000a74 <copyout+0xae>
      return -1;
    80000a6a:	557d                	li	a0,-1
    80000a6c:	6906                	ld	s2,64(sp)
    80000a6e:	6be2                	ld	s7,24(sp)
    80000a70:	6c42                	ld	s8,16(sp)
    80000a72:	6ca2                	ld	s9,8(sp)
}
    80000a74:	60e6                	ld	ra,88(sp)
    80000a76:	6446                	ld	s0,80(sp)
    80000a78:	64a6                	ld	s1,72(sp)
    80000a7a:	79e2                	ld	s3,56(sp)
    80000a7c:	7a42                	ld	s4,48(sp)
    80000a7e:	7aa2                	ld	s5,40(sp)
    80000a80:	7b02                	ld	s6,32(sp)
    80000a82:	6125                	addi	sp,sp,96
    80000a84:	8082                	ret
      return -1;
    80000a86:	557d                	li	a0,-1
    80000a88:	6906                	ld	s2,64(sp)
    80000a8a:	6be2                	ld	s7,24(sp)
    80000a8c:	6c42                	ld	s8,16(sp)
    80000a8e:	6ca2                	ld	s9,8(sp)
    80000a90:	b7d5                	j	80000a74 <copyout+0xae>
      return -1;
    80000a92:	557d                	li	a0,-1
    80000a94:	6906                	ld	s2,64(sp)
    80000a96:	6be2                	ld	s7,24(sp)
    80000a98:	6c42                	ld	s8,16(sp)
    80000a9a:	6ca2                	ld	s9,8(sp)
    80000a9c:	bfe1                	j	80000a74 <copyout+0xae>

0000000080000a9e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000a9e:	c6a5                	beqz	a3,80000b06 <copyin+0x68>
{
    80000aa0:	715d                	addi	sp,sp,-80
    80000aa2:	e486                	sd	ra,72(sp)
    80000aa4:	e0a2                	sd	s0,64(sp)
    80000aa6:	fc26                	sd	s1,56(sp)
    80000aa8:	f84a                	sd	s2,48(sp)
    80000aaa:	f44e                	sd	s3,40(sp)
    80000aac:	f052                	sd	s4,32(sp)
    80000aae:	ec56                	sd	s5,24(sp)
    80000ab0:	e85a                	sd	s6,16(sp)
    80000ab2:	e45e                	sd	s7,8(sp)
    80000ab4:	e062                	sd	s8,0(sp)
    80000ab6:	0880                	addi	s0,sp,80
    80000ab8:	8b2a                	mv	s6,a0
    80000aba:	8a2e                	mv	s4,a1
    80000abc:	8c32                	mv	s8,a2
    80000abe:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ac0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ac2:	6a85                	lui	s5,0x1
    80000ac4:	a00d                	j	80000ae6 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ac6:	018505b3          	add	a1,a0,s8
    80000aca:	0004861b          	sext.w	a2,s1
    80000ace:	412585b3          	sub	a1,a1,s2
    80000ad2:	8552                	mv	a0,s4
    80000ad4:	ebcff0ef          	jal	80000190 <memmove>

    len -= n;
    80000ad8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000adc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000ade:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ae2:	02098063          	beqz	s3,80000b02 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000ae6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000aea:	85ca                	mv	a1,s2
    80000aec:	855a                	mv	a0,s6
    80000aee:	955ff0ef          	jal	80000442 <walkaddr>
    if(pa0 == 0)
    80000af2:	cd01                	beqz	a0,80000b0a <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000af4:	418904b3          	sub	s1,s2,s8
    80000af8:	94d6                	add	s1,s1,s5
    if(n > len)
    80000afa:	fc99f6e3          	bgeu	s3,s1,80000ac6 <copyin+0x28>
    80000afe:	84ce                	mv	s1,s3
    80000b00:	b7d9                	j	80000ac6 <copyin+0x28>
  }
  return 0;
    80000b02:	4501                	li	a0,0
    80000b04:	a021                	j	80000b0c <copyin+0x6e>
    80000b06:	4501                	li	a0,0
}
    80000b08:	8082                	ret
      return -1;
    80000b0a:	557d                	li	a0,-1
}
    80000b0c:	60a6                	ld	ra,72(sp)
    80000b0e:	6406                	ld	s0,64(sp)
    80000b10:	74e2                	ld	s1,56(sp)
    80000b12:	7942                	ld	s2,48(sp)
    80000b14:	79a2                	ld	s3,40(sp)
    80000b16:	7a02                	ld	s4,32(sp)
    80000b18:	6ae2                	ld	s5,24(sp)
    80000b1a:	6b42                	ld	s6,16(sp)
    80000b1c:	6ba2                	ld	s7,8(sp)
    80000b1e:	6c02                	ld	s8,0(sp)
    80000b20:	6161                	addi	sp,sp,80
    80000b22:	8082                	ret

0000000080000b24 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b24:	c6dd                	beqz	a3,80000bd2 <copyinstr+0xae>
{
    80000b26:	715d                	addi	sp,sp,-80
    80000b28:	e486                	sd	ra,72(sp)
    80000b2a:	e0a2                	sd	s0,64(sp)
    80000b2c:	fc26                	sd	s1,56(sp)
    80000b2e:	f84a                	sd	s2,48(sp)
    80000b30:	f44e                	sd	s3,40(sp)
    80000b32:	f052                	sd	s4,32(sp)
    80000b34:	ec56                	sd	s5,24(sp)
    80000b36:	e85a                	sd	s6,16(sp)
    80000b38:	e45e                	sd	s7,8(sp)
    80000b3a:	0880                	addi	s0,sp,80
    80000b3c:	8a2a                	mv	s4,a0
    80000b3e:	8b2e                	mv	s6,a1
    80000b40:	8bb2                	mv	s7,a2
    80000b42:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000b44:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b46:	6985                	lui	s3,0x1
    80000b48:	a825                	j	80000b80 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b4a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000b4e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b50:	37fd                	addiw	a5,a5,-1
    80000b52:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b56:	60a6                	ld	ra,72(sp)
    80000b58:	6406                	ld	s0,64(sp)
    80000b5a:	74e2                	ld	s1,56(sp)
    80000b5c:	7942                	ld	s2,48(sp)
    80000b5e:	79a2                	ld	s3,40(sp)
    80000b60:	7a02                	ld	s4,32(sp)
    80000b62:	6ae2                	ld	s5,24(sp)
    80000b64:	6b42                	ld	s6,16(sp)
    80000b66:	6ba2                	ld	s7,8(sp)
    80000b68:	6161                	addi	sp,sp,80
    80000b6a:	8082                	ret
    80000b6c:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000b70:	9742                	add	a4,a4,a6
      --max;
    80000b72:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000b76:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000b7a:	04e58463          	beq	a1,a4,80000bc2 <copyinstr+0x9e>
{
    80000b7e:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000b80:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000b84:	85a6                	mv	a1,s1
    80000b86:	8552                	mv	a0,s4
    80000b88:	8bbff0ef          	jal	80000442 <walkaddr>
    if(pa0 == 0)
    80000b8c:	cd0d                	beqz	a0,80000bc6 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000b8e:	417486b3          	sub	a3,s1,s7
    80000b92:	96ce                	add	a3,a3,s3
    if(n > max)
    80000b94:	00d97363          	bgeu	s2,a3,80000b9a <copyinstr+0x76>
    80000b98:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000b9a:	955e                	add	a0,a0,s7
    80000b9c:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000b9e:	c695                	beqz	a3,80000bca <copyinstr+0xa6>
    80000ba0:	87da                	mv	a5,s6
    80000ba2:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000ba4:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000ba8:	96da                	add	a3,a3,s6
    80000baa:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bac:	00f60733          	add	a4,a2,a5
    80000bb0:	00074703          	lbu	a4,0(a4)
    80000bb4:	db59                	beqz	a4,80000b4a <copyinstr+0x26>
        *dst = *p;
    80000bb6:	00e78023          	sb	a4,0(a5)
      dst++;
    80000bba:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bbc:	fed797e3          	bne	a5,a3,80000baa <copyinstr+0x86>
    80000bc0:	b775                	j	80000b6c <copyinstr+0x48>
    80000bc2:	4781                	li	a5,0
    80000bc4:	b771                	j	80000b50 <copyinstr+0x2c>
      return -1;
    80000bc6:	557d                	li	a0,-1
    80000bc8:	b779                	j	80000b56 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000bca:	6b85                	lui	s7,0x1
    80000bcc:	9ba6                	add	s7,s7,s1
    80000bce:	87da                	mv	a5,s6
    80000bd0:	b77d                	j	80000b7e <copyinstr+0x5a>
  int got_null = 0;
    80000bd2:	4781                	li	a5,0
  if(got_null){
    80000bd4:	37fd                	addiw	a5,a5,-1
    80000bd6:	0007851b          	sext.w	a0,a5
}
    80000bda:	8082                	ret

0000000080000bdc <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000bdc:	7139                	addi	sp,sp,-64
    80000bde:	fc06                	sd	ra,56(sp)
    80000be0:	f822                	sd	s0,48(sp)
    80000be2:	f426                	sd	s1,40(sp)
    80000be4:	f04a                	sd	s2,32(sp)
    80000be6:	ec4e                	sd	s3,24(sp)
    80000be8:	e852                	sd	s4,16(sp)
    80000bea:	e456                	sd	s5,8(sp)
    80000bec:	e05a                	sd	s6,0(sp)
    80000bee:	0080                	addi	s0,sp,64
    80000bf0:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000bf2:	0000a497          	auipc	s1,0xa
    80000bf6:	f8e48493          	addi	s1,s1,-114 # 8000ab80 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000bfa:	8b26                	mv	s6,s1
    80000bfc:	ff4df937          	lui	s2,0xff4df
    80000c00:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bab5d>
    80000c04:	0936                	slli	s2,s2,0xd
    80000c06:	6f590913          	addi	s2,s2,1781
    80000c0a:	0936                	slli	s2,s2,0xd
    80000c0c:	bd390913          	addi	s2,s2,-1069
    80000c10:	0932                	slli	s2,s2,0xc
    80000c12:	7a790913          	addi	s2,s2,1959
    80000c16:	040009b7          	lui	s3,0x4000
    80000c1a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c1c:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c1e:	00010a97          	auipc	s5,0x10
    80000c22:	b62a8a93          	addi	s5,s5,-1182 # 80010780 <tickslock>
    char *pa = kalloc();
    80000c26:	cd0ff0ef          	jal	800000f6 <kalloc>
    80000c2a:	862a                	mv	a2,a0
    if(pa == 0)
    80000c2c:	cd15                	beqz	a0,80000c68 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c2e:	416485b3          	sub	a1,s1,s6
    80000c32:	8591                	srai	a1,a1,0x4
    80000c34:	032585b3          	mul	a1,a1,s2
    80000c38:	2585                	addiw	a1,a1,1
    80000c3a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c3e:	4719                	li	a4,6
    80000c40:	6685                	lui	a3,0x1
    80000c42:	40b985b3          	sub	a1,s3,a1
    80000c46:	8552                	mv	a0,s4
    80000c48:	8e9ff0ef          	jal	80000530 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c4c:	17048493          	addi	s1,s1,368
    80000c50:	fd549be3          	bne	s1,s5,80000c26 <proc_mapstacks+0x4a>
  }
}
    80000c54:	70e2                	ld	ra,56(sp)
    80000c56:	7442                	ld	s0,48(sp)
    80000c58:	74a2                	ld	s1,40(sp)
    80000c5a:	7902                	ld	s2,32(sp)
    80000c5c:	69e2                	ld	s3,24(sp)
    80000c5e:	6a42                	ld	s4,16(sp)
    80000c60:	6aa2                	ld	s5,8(sp)
    80000c62:	6b02                	ld	s6,0(sp)
    80000c64:	6121                	addi	sp,sp,64
    80000c66:	8082                	ret
      panic("kalloc");
    80000c68:	00006517          	auipc	a0,0x6
    80000c6c:	54050513          	addi	a0,a0,1344 # 800071a8 <etext+0x1a8>
    80000c70:	2a3040ef          	jal	80005712 <panic>

0000000080000c74 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c74:	7139                	addi	sp,sp,-64
    80000c76:	fc06                	sd	ra,56(sp)
    80000c78:	f822                	sd	s0,48(sp)
    80000c7a:	f426                	sd	s1,40(sp)
    80000c7c:	f04a                	sd	s2,32(sp)
    80000c7e:	ec4e                	sd	s3,24(sp)
    80000c80:	e852                	sd	s4,16(sp)
    80000c82:	e456                	sd	s5,8(sp)
    80000c84:	e05a                	sd	s6,0(sp)
    80000c86:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000c88:	00006597          	auipc	a1,0x6
    80000c8c:	52858593          	addi	a1,a1,1320 # 800071b0 <etext+0x1b0>
    80000c90:	0000a517          	auipc	a0,0xa
    80000c94:	ac050513          	addi	a0,a0,-1344 # 8000a750 <pid_lock>
    80000c98:	529040ef          	jal	800059c0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000c9c:	00006597          	auipc	a1,0x6
    80000ca0:	51c58593          	addi	a1,a1,1308 # 800071b8 <etext+0x1b8>
    80000ca4:	0000a517          	auipc	a0,0xa
    80000ca8:	ac450513          	addi	a0,a0,-1340 # 8000a768 <wait_lock>
    80000cac:	515040ef          	jal	800059c0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cb0:	0000a497          	auipc	s1,0xa
    80000cb4:	ed048493          	addi	s1,s1,-304 # 8000ab80 <proc>
      initlock(&p->lock, "proc");
    80000cb8:	00006b17          	auipc	s6,0x6
    80000cbc:	510b0b13          	addi	s6,s6,1296 # 800071c8 <etext+0x1c8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cc0:	8aa6                	mv	s5,s1
    80000cc2:	ff4df937          	lui	s2,0xff4df
    80000cc6:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bab5d>
    80000cca:	0936                	slli	s2,s2,0xd
    80000ccc:	6f590913          	addi	s2,s2,1781
    80000cd0:	0936                	slli	s2,s2,0xd
    80000cd2:	bd390913          	addi	s2,s2,-1069
    80000cd6:	0932                	slli	s2,s2,0xc
    80000cd8:	7a790913          	addi	s2,s2,1959
    80000cdc:	040009b7          	lui	s3,0x4000
    80000ce0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000ce2:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce4:	00010a17          	auipc	s4,0x10
    80000ce8:	a9ca0a13          	addi	s4,s4,-1380 # 80010780 <tickslock>
      initlock(&p->lock, "proc");
    80000cec:	85da                	mv	a1,s6
    80000cee:	8526                	mv	a0,s1
    80000cf0:	4d1040ef          	jal	800059c0 <initlock>
      p->state = UNUSED;
    80000cf4:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000cf8:	415487b3          	sub	a5,s1,s5
    80000cfc:	8791                	srai	a5,a5,0x4
    80000cfe:	032787b3          	mul	a5,a5,s2
    80000d02:	2785                	addiw	a5,a5,1
    80000d04:	00d7979b          	slliw	a5,a5,0xd
    80000d08:	40f987b3          	sub	a5,s3,a5
    80000d0c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0e:	17048493          	addi	s1,s1,368
    80000d12:	fd449de3          	bne	s1,s4,80000cec <procinit+0x78>
  }
}
    80000d16:	70e2                	ld	ra,56(sp)
    80000d18:	7442                	ld	s0,48(sp)
    80000d1a:	74a2                	ld	s1,40(sp)
    80000d1c:	7902                	ld	s2,32(sp)
    80000d1e:	69e2                	ld	s3,24(sp)
    80000d20:	6a42                	ld	s4,16(sp)
    80000d22:	6aa2                	ld	s5,8(sp)
    80000d24:	6b02                	ld	s6,0(sp)
    80000d26:	6121                	addi	sp,sp,64
    80000d28:	8082                	ret

0000000080000d2a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d2a:	1141                	addi	sp,sp,-16
    80000d2c:	e422                	sd	s0,8(sp)
    80000d2e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d30:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d32:	2501                	sext.w	a0,a0
    80000d34:	6422                	ld	s0,8(sp)
    80000d36:	0141                	addi	sp,sp,16
    80000d38:	8082                	ret

0000000080000d3a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d3a:	1141                	addi	sp,sp,-16
    80000d3c:	e422                	sd	s0,8(sp)
    80000d3e:	0800                	addi	s0,sp,16
    80000d40:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d42:	2781                	sext.w	a5,a5
    80000d44:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d46:	0000a517          	auipc	a0,0xa
    80000d4a:	a3a50513          	addi	a0,a0,-1478 # 8000a780 <cpus>
    80000d4e:	953e                	add	a0,a0,a5
    80000d50:	6422                	ld	s0,8(sp)
    80000d52:	0141                	addi	sp,sp,16
    80000d54:	8082                	ret

0000000080000d56 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d56:	1101                	addi	sp,sp,-32
    80000d58:	ec06                	sd	ra,24(sp)
    80000d5a:	e822                	sd	s0,16(sp)
    80000d5c:	e426                	sd	s1,8(sp)
    80000d5e:	1000                	addi	s0,sp,32
  push_off();
    80000d60:	4a1040ef          	jal	80005a00 <push_off>
    80000d64:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d66:	2781                	sext.w	a5,a5
    80000d68:	079e                	slli	a5,a5,0x7
    80000d6a:	0000a717          	auipc	a4,0xa
    80000d6e:	9e670713          	addi	a4,a4,-1562 # 8000a750 <pid_lock>
    80000d72:	97ba                	add	a5,a5,a4
    80000d74:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d76:	50f040ef          	jal	80005a84 <pop_off>
  return p;
}
    80000d7a:	8526                	mv	a0,s1
    80000d7c:	60e2                	ld	ra,24(sp)
    80000d7e:	6442                	ld	s0,16(sp)
    80000d80:	64a2                	ld	s1,8(sp)
    80000d82:	6105                	addi	sp,sp,32
    80000d84:	8082                	ret

0000000080000d86 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000d86:	1141                	addi	sp,sp,-16
    80000d88:	e406                	sd	ra,8(sp)
    80000d8a:	e022                	sd	s0,0(sp)
    80000d8c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000d8e:	fc9ff0ef          	jal	80000d56 <myproc>
    80000d92:	547040ef          	jal	80005ad8 <release>

  if (first) {
    80000d96:	0000a797          	auipc	a5,0xa
    80000d9a:	8fa7a783          	lw	a5,-1798(a5) # 8000a690 <first.1>
    80000d9e:	e799                	bnez	a5,80000dac <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000da0:	2cb000ef          	jal	8000186a <usertrapret>
}
    80000da4:	60a2                	ld	ra,8(sp)
    80000da6:	6402                	ld	s0,0(sp)
    80000da8:	0141                	addi	sp,sp,16
    80000daa:	8082                	ret
    fsinit(ROOTDEV);
    80000dac:	4505                	li	a0,1
    80000dae:	183010ef          	jal	80002730 <fsinit>
    first = 0;
    80000db2:	0000a797          	auipc	a5,0xa
    80000db6:	8c07af23          	sw	zero,-1826(a5) # 8000a690 <first.1>
    __sync_synchronize();
    80000dba:	0330000f          	fence	rw,rw
    80000dbe:	b7cd                	j	80000da0 <forkret+0x1a>

0000000080000dc0 <allocpid>:
{
    80000dc0:	1101                	addi	sp,sp,-32
    80000dc2:	ec06                	sd	ra,24(sp)
    80000dc4:	e822                	sd	s0,16(sp)
    80000dc6:	e426                	sd	s1,8(sp)
    80000dc8:	e04a                	sd	s2,0(sp)
    80000dca:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000dcc:	0000a917          	auipc	s2,0xa
    80000dd0:	98490913          	addi	s2,s2,-1660 # 8000a750 <pid_lock>
    80000dd4:	854a                	mv	a0,s2
    80000dd6:	46b040ef          	jal	80005a40 <acquire>
  pid = nextpid;
    80000dda:	0000a797          	auipc	a5,0xa
    80000dde:	8ba78793          	addi	a5,a5,-1862 # 8000a694 <nextpid>
    80000de2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000de4:	0014871b          	addiw	a4,s1,1
    80000de8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000dea:	854a                	mv	a0,s2
    80000dec:	4ed040ef          	jal	80005ad8 <release>
}
    80000df0:	8526                	mv	a0,s1
    80000df2:	60e2                	ld	ra,24(sp)
    80000df4:	6442                	ld	s0,16(sp)
    80000df6:	64a2                	ld	s1,8(sp)
    80000df8:	6902                	ld	s2,0(sp)
    80000dfa:	6105                	addi	sp,sp,32
    80000dfc:	8082                	ret

0000000080000dfe <proc_pagetable>:
{
    80000dfe:	1101                	addi	sp,sp,-32
    80000e00:	ec06                	sd	ra,24(sp)
    80000e02:	e822                	sd	s0,16(sp)
    80000e04:	e426                	sd	s1,8(sp)
    80000e06:	e04a                	sd	s2,0(sp)
    80000e08:	1000                	addi	s0,sp,32
    80000e0a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e0c:	8e7ff0ef          	jal	800006f2 <uvmcreate>
    80000e10:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e12:	cd05                	beqz	a0,80000e4a <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e14:	4729                	li	a4,10
    80000e16:	00005697          	auipc	a3,0x5
    80000e1a:	1ea68693          	addi	a3,a3,490 # 80006000 <_trampoline>
    80000e1e:	6605                	lui	a2,0x1
    80000e20:	040005b7          	lui	a1,0x4000
    80000e24:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e26:	05b2                	slli	a1,a1,0xc
    80000e28:	e58ff0ef          	jal	80000480 <mappages>
    80000e2c:	02054663          	bltz	a0,80000e58 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e30:	4719                	li	a4,6
    80000e32:	05893683          	ld	a3,88(s2)
    80000e36:	6605                	lui	a2,0x1
    80000e38:	020005b7          	lui	a1,0x2000
    80000e3c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e3e:	05b6                	slli	a1,a1,0xd
    80000e40:	8526                	mv	a0,s1
    80000e42:	e3eff0ef          	jal	80000480 <mappages>
    80000e46:	00054f63          	bltz	a0,80000e64 <proc_pagetable+0x66>
}
    80000e4a:	8526                	mv	a0,s1
    80000e4c:	60e2                	ld	ra,24(sp)
    80000e4e:	6442                	ld	s0,16(sp)
    80000e50:	64a2                	ld	s1,8(sp)
    80000e52:	6902                	ld	s2,0(sp)
    80000e54:	6105                	addi	sp,sp,32
    80000e56:	8082                	ret
    uvmfree(pagetable, 0);
    80000e58:	4581                	li	a1,0
    80000e5a:	8526                	mv	a0,s1
    80000e5c:	a5dff0ef          	jal	800008b8 <uvmfree>
    return 0;
    80000e60:	4481                	li	s1,0
    80000e62:	b7e5                	j	80000e4a <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e64:	4681                	li	a3,0
    80000e66:	4605                	li	a2,1
    80000e68:	040005b7          	lui	a1,0x4000
    80000e6c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e6e:	05b2                	slli	a1,a1,0xc
    80000e70:	8526                	mv	a0,s1
    80000e72:	fb4ff0ef          	jal	80000626 <uvmunmap>
    uvmfree(pagetable, 0);
    80000e76:	4581                	li	a1,0
    80000e78:	8526                	mv	a0,s1
    80000e7a:	a3fff0ef          	jal	800008b8 <uvmfree>
    return 0;
    80000e7e:	4481                	li	s1,0
    80000e80:	b7e9                	j	80000e4a <proc_pagetable+0x4c>

0000000080000e82 <proc_freepagetable>:
{
    80000e82:	1101                	addi	sp,sp,-32
    80000e84:	ec06                	sd	ra,24(sp)
    80000e86:	e822                	sd	s0,16(sp)
    80000e88:	e426                	sd	s1,8(sp)
    80000e8a:	e04a                	sd	s2,0(sp)
    80000e8c:	1000                	addi	s0,sp,32
    80000e8e:	84aa                	mv	s1,a0
    80000e90:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e92:	4681                	li	a3,0
    80000e94:	4605                	li	a2,1
    80000e96:	040005b7          	lui	a1,0x4000
    80000e9a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e9c:	05b2                	slli	a1,a1,0xc
    80000e9e:	f88ff0ef          	jal	80000626 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ea2:	4681                	li	a3,0
    80000ea4:	4605                	li	a2,1
    80000ea6:	020005b7          	lui	a1,0x2000
    80000eaa:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000eac:	05b6                	slli	a1,a1,0xd
    80000eae:	8526                	mv	a0,s1
    80000eb0:	f76ff0ef          	jal	80000626 <uvmunmap>
  uvmfree(pagetable, sz);
    80000eb4:	85ca                	mv	a1,s2
    80000eb6:	8526                	mv	a0,s1
    80000eb8:	a01ff0ef          	jal	800008b8 <uvmfree>
}
    80000ebc:	60e2                	ld	ra,24(sp)
    80000ebe:	6442                	ld	s0,16(sp)
    80000ec0:	64a2                	ld	s1,8(sp)
    80000ec2:	6902                	ld	s2,0(sp)
    80000ec4:	6105                	addi	sp,sp,32
    80000ec6:	8082                	ret

0000000080000ec8 <freeproc>:
{
    80000ec8:	1101                	addi	sp,sp,-32
    80000eca:	ec06                	sd	ra,24(sp)
    80000ecc:	e822                	sd	s0,16(sp)
    80000ece:	e426                	sd	s1,8(sp)
    80000ed0:	1000                	addi	s0,sp,32
    80000ed2:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000ed4:	6d28                	ld	a0,88(a0)
    80000ed6:	c119                	beqz	a0,80000edc <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000ed8:	944ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000edc:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000ee0:	68a8                	ld	a0,80(s1)
    80000ee2:	c501                	beqz	a0,80000eea <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000ee4:	64ac                	ld	a1,72(s1)
    80000ee6:	f9dff0ef          	jal	80000e82 <proc_freepagetable>
  p->pagetable = 0;
    80000eea:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000eee:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000ef2:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000ef6:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000efa:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000efe:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f02:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f06:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f0a:	0004ac23          	sw	zero,24(s1)
}
    80000f0e:	60e2                	ld	ra,24(sp)
    80000f10:	6442                	ld	s0,16(sp)
    80000f12:	64a2                	ld	s1,8(sp)
    80000f14:	6105                	addi	sp,sp,32
    80000f16:	8082                	ret

0000000080000f18 <allocproc>:
{
    80000f18:	1101                	addi	sp,sp,-32
    80000f1a:	ec06                	sd	ra,24(sp)
    80000f1c:	e822                	sd	s0,16(sp)
    80000f1e:	e426                	sd	s1,8(sp)
    80000f20:	e04a                	sd	s2,0(sp)
    80000f22:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f24:	0000a497          	auipc	s1,0xa
    80000f28:	c5c48493          	addi	s1,s1,-932 # 8000ab80 <proc>
    80000f2c:	00010917          	auipc	s2,0x10
    80000f30:	85490913          	addi	s2,s2,-1964 # 80010780 <tickslock>
    acquire(&p->lock);
    80000f34:	8526                	mv	a0,s1
    80000f36:	30b040ef          	jal	80005a40 <acquire>
    if(p->state == UNUSED) {
    80000f3a:	4c9c                	lw	a5,24(s1)
    80000f3c:	cb91                	beqz	a5,80000f50 <allocproc+0x38>
      release(&p->lock);
    80000f3e:	8526                	mv	a0,s1
    80000f40:	399040ef          	jal	80005ad8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f44:	17048493          	addi	s1,s1,368
    80000f48:	ff2496e3          	bne	s1,s2,80000f34 <allocproc+0x1c>
  return 0;
    80000f4c:	4481                	li	s1,0
    80000f4e:	a099                	j	80000f94 <allocproc+0x7c>
  p->pid = allocpid();
    80000f50:	e71ff0ef          	jal	80000dc0 <allocpid>
    80000f54:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f56:	4785                	li	a5,1
    80000f58:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f5a:	99cff0ef          	jal	800000f6 <kalloc>
    80000f5e:	892a                	mv	s2,a0
    80000f60:	eca8                	sd	a0,88(s1)
    80000f62:	c121                	beqz	a0,80000fa2 <allocproc+0x8a>
  p->pagetable = proc_pagetable(p);
    80000f64:	8526                	mv	a0,s1
    80000f66:	e99ff0ef          	jal	80000dfe <proc_pagetable>
    80000f6a:	892a                	mv	s2,a0
    80000f6c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000f6e:	c131                	beqz	a0,80000fb2 <allocproc+0x9a>
  memset(&p->context, 0, sizeof(p->context));
    80000f70:	07000613          	li	a2,112
    80000f74:	4581                	li	a1,0
    80000f76:	06048513          	addi	a0,s1,96
    80000f7a:	9baff0ef          	jal	80000134 <memset>
  p->context.ra = (uint64)forkret;
    80000f7e:	00000797          	auipc	a5,0x0
    80000f82:	e0878793          	addi	a5,a5,-504 # 80000d86 <forkret>
    80000f86:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000f88:	60bc                	ld	a5,64(s1)
    80000f8a:	6705                	lui	a4,0x1
    80000f8c:	97ba                	add	a5,a5,a4
    80000f8e:	f4bc                	sd	a5,104(s1)
  p->trace_mask = 0;
    80000f90:	1604a423          	sw	zero,360(s1)
}
    80000f94:	8526                	mv	a0,s1
    80000f96:	60e2                	ld	ra,24(sp)
    80000f98:	6442                	ld	s0,16(sp)
    80000f9a:	64a2                	ld	s1,8(sp)
    80000f9c:	6902                	ld	s2,0(sp)
    80000f9e:	6105                	addi	sp,sp,32
    80000fa0:	8082                	ret
    freeproc(p);
    80000fa2:	8526                	mv	a0,s1
    80000fa4:	f25ff0ef          	jal	80000ec8 <freeproc>
    release(&p->lock);
    80000fa8:	8526                	mv	a0,s1
    80000faa:	32f040ef          	jal	80005ad8 <release>
    return 0;
    80000fae:	84ca                	mv	s1,s2
    80000fb0:	b7d5                	j	80000f94 <allocproc+0x7c>
    freeproc(p);
    80000fb2:	8526                	mv	a0,s1
    80000fb4:	f15ff0ef          	jal	80000ec8 <freeproc>
    release(&p->lock);
    80000fb8:	8526                	mv	a0,s1
    80000fba:	31f040ef          	jal	80005ad8 <release>
    return 0;
    80000fbe:	84ca                	mv	s1,s2
    80000fc0:	bfd1                	j	80000f94 <allocproc+0x7c>

0000000080000fc2 <userinit>:
{
    80000fc2:	1101                	addi	sp,sp,-32
    80000fc4:	ec06                	sd	ra,24(sp)
    80000fc6:	e822                	sd	s0,16(sp)
    80000fc8:	e426                	sd	s1,8(sp)
    80000fca:	1000                	addi	s0,sp,32
  p = allocproc();
    80000fcc:	f4dff0ef          	jal	80000f18 <allocproc>
    80000fd0:	84aa                	mv	s1,a0
  initproc = p;
    80000fd2:	00009797          	auipc	a5,0x9
    80000fd6:	72a7bf23          	sd	a0,1854(a5) # 8000a710 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000fda:	03400613          	li	a2,52
    80000fde:	00009597          	auipc	a1,0x9
    80000fe2:	6c258593          	addi	a1,a1,1730 # 8000a6a0 <initcode>
    80000fe6:	6928                	ld	a0,80(a0)
    80000fe8:	f30ff0ef          	jal	80000718 <uvmfirst>
  p->sz = PGSIZE;
    80000fec:	6785                	lui	a5,0x1
    80000fee:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80000ff0:	6cb8                	ld	a4,88(s1)
    80000ff2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80000ff6:	6cb8                	ld	a4,88(s1)
    80000ff8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80000ffa:	4641                	li	a2,16
    80000ffc:	00006597          	auipc	a1,0x6
    80001000:	1d458593          	addi	a1,a1,468 # 800071d0 <etext+0x1d0>
    80001004:	15848513          	addi	a0,s1,344
    80001008:	a6aff0ef          	jal	80000272 <safestrcpy>
  p->cwd = namei("/");
    8000100c:	00006517          	auipc	a0,0x6
    80001010:	1d450513          	addi	a0,a0,468 # 800071e0 <etext+0x1e0>
    80001014:	02a020ef          	jal	8000303e <namei>
    80001018:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000101c:	478d                	li	a5,3
    8000101e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001020:	8526                	mv	a0,s1
    80001022:	2b7040ef          	jal	80005ad8 <release>
}
    80001026:	60e2                	ld	ra,24(sp)
    80001028:	6442                	ld	s0,16(sp)
    8000102a:	64a2                	ld	s1,8(sp)
    8000102c:	6105                	addi	sp,sp,32
    8000102e:	8082                	ret

0000000080001030 <growproc>:
{
    80001030:	1101                	addi	sp,sp,-32
    80001032:	ec06                	sd	ra,24(sp)
    80001034:	e822                	sd	s0,16(sp)
    80001036:	e426                	sd	s1,8(sp)
    80001038:	e04a                	sd	s2,0(sp)
    8000103a:	1000                	addi	s0,sp,32
    8000103c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000103e:	d19ff0ef          	jal	80000d56 <myproc>
    80001042:	84aa                	mv	s1,a0
  sz = p->sz;
    80001044:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001046:	01204c63          	bgtz	s2,8000105e <growproc+0x2e>
  } else if(n < 0){
    8000104a:	02094463          	bltz	s2,80001072 <growproc+0x42>
  p->sz = sz;
    8000104e:	e4ac                	sd	a1,72(s1)
  return 0;
    80001050:	4501                	li	a0,0
}
    80001052:	60e2                	ld	ra,24(sp)
    80001054:	6442                	ld	s0,16(sp)
    80001056:	64a2                	ld	s1,8(sp)
    80001058:	6902                	ld	s2,0(sp)
    8000105a:	6105                	addi	sp,sp,32
    8000105c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000105e:	4691                	li	a3,4
    80001060:	00b90633          	add	a2,s2,a1
    80001064:	6928                	ld	a0,80(a0)
    80001066:	f54ff0ef          	jal	800007ba <uvmalloc>
    8000106a:	85aa                	mv	a1,a0
    8000106c:	f16d                	bnez	a0,8000104e <growproc+0x1e>
      return -1;
    8000106e:	557d                	li	a0,-1
    80001070:	b7cd                	j	80001052 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001072:	00b90633          	add	a2,s2,a1
    80001076:	6928                	ld	a0,80(a0)
    80001078:	efeff0ef          	jal	80000776 <uvmdealloc>
    8000107c:	85aa                	mv	a1,a0
    8000107e:	bfc1                	j	8000104e <growproc+0x1e>

0000000080001080 <fork>:
{
    80001080:	7139                	addi	sp,sp,-64
    80001082:	fc06                	sd	ra,56(sp)
    80001084:	f822                	sd	s0,48(sp)
    80001086:	f04a                	sd	s2,32(sp)
    80001088:	e456                	sd	s5,8(sp)
    8000108a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000108c:	ccbff0ef          	jal	80000d56 <myproc>
    80001090:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001092:	e87ff0ef          	jal	80000f18 <allocproc>
    80001096:	0e050e63          	beqz	a0,80001192 <fork+0x112>
    8000109a:	ec4e                	sd	s3,24(sp)
    8000109c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000109e:	048ab603          	ld	a2,72(s5)
    800010a2:	692c                	ld	a1,80(a0)
    800010a4:	050ab503          	ld	a0,80(s5)
    800010a8:	843ff0ef          	jal	800008ea <uvmcopy>
    800010ac:	04054e63          	bltz	a0,80001108 <fork+0x88>
    800010b0:	f426                	sd	s1,40(sp)
    800010b2:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    800010b4:	048ab783          	ld	a5,72(s5)
    800010b8:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800010bc:	058ab683          	ld	a3,88(s5)
    800010c0:	87b6                	mv	a5,a3
    800010c2:	0589b703          	ld	a4,88(s3)
    800010c6:	12068693          	addi	a3,a3,288
    800010ca:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800010ce:	6788                	ld	a0,8(a5)
    800010d0:	6b8c                	ld	a1,16(a5)
    800010d2:	6f90                	ld	a2,24(a5)
    800010d4:	01073023          	sd	a6,0(a4)
    800010d8:	e708                	sd	a0,8(a4)
    800010da:	eb0c                	sd	a1,16(a4)
    800010dc:	ef10                	sd	a2,24(a4)
    800010de:	02078793          	addi	a5,a5,32
    800010e2:	02070713          	addi	a4,a4,32
    800010e6:	fed792e3          	bne	a5,a3,800010ca <fork+0x4a>
  np->trapframe->a0 = 0;
    800010ea:	0589b783          	ld	a5,88(s3)
    800010ee:	0607b823          	sd	zero,112(a5)
  np->trace_mask = p->trace_mask;
    800010f2:	168aa783          	lw	a5,360(s5)
    800010f6:	16f9a423          	sw	a5,360(s3)
  for(i = 0; i < NOFILE; i++)
    800010fa:	0d0a8493          	addi	s1,s5,208
    800010fe:	0d098913          	addi	s2,s3,208
    80001102:	150a8a13          	addi	s4,s5,336
    80001106:	a831                	j	80001122 <fork+0xa2>
    freeproc(np);
    80001108:	854e                	mv	a0,s3
    8000110a:	dbfff0ef          	jal	80000ec8 <freeproc>
    release(&np->lock);
    8000110e:	854e                	mv	a0,s3
    80001110:	1c9040ef          	jal	80005ad8 <release>
    return -1;
    80001114:	597d                	li	s2,-1
    80001116:	69e2                	ld	s3,24(sp)
    80001118:	a0b5                	j	80001184 <fork+0x104>
  for(i = 0; i < NOFILE; i++)
    8000111a:	04a1                	addi	s1,s1,8
    8000111c:	0921                	addi	s2,s2,8
    8000111e:	01448963          	beq	s1,s4,80001130 <fork+0xb0>
    if(p->ofile[i])
    80001122:	6088                	ld	a0,0(s1)
    80001124:	d97d                	beqz	a0,8000111a <fork+0x9a>
      np->ofile[i] = filedup(p->ofile[i]);
    80001126:	4a8020ef          	jal	800035ce <filedup>
    8000112a:	00a93023          	sd	a0,0(s2)
    8000112e:	b7f5                	j	8000111a <fork+0x9a>
  np->cwd = idup(p->cwd);
    80001130:	150ab503          	ld	a0,336(s5)
    80001134:	7fa010ef          	jal	8000292e <idup>
    80001138:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000113c:	4641                	li	a2,16
    8000113e:	158a8593          	addi	a1,s5,344
    80001142:	15898513          	addi	a0,s3,344
    80001146:	92cff0ef          	jal	80000272 <safestrcpy>
  pid = np->pid;
    8000114a:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000114e:	854e                	mv	a0,s3
    80001150:	189040ef          	jal	80005ad8 <release>
  acquire(&wait_lock);
    80001154:	00009497          	auipc	s1,0x9
    80001158:	61448493          	addi	s1,s1,1556 # 8000a768 <wait_lock>
    8000115c:	8526                	mv	a0,s1
    8000115e:	0e3040ef          	jal	80005a40 <acquire>
  np->parent = p;
    80001162:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001166:	8526                	mv	a0,s1
    80001168:	171040ef          	jal	80005ad8 <release>
  acquire(&np->lock);
    8000116c:	854e                	mv	a0,s3
    8000116e:	0d3040ef          	jal	80005a40 <acquire>
  np->state = RUNNABLE;
    80001172:	478d                	li	a5,3
    80001174:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001178:	854e                	mv	a0,s3
    8000117a:	15f040ef          	jal	80005ad8 <release>
  return pid;
    8000117e:	74a2                	ld	s1,40(sp)
    80001180:	69e2                	ld	s3,24(sp)
    80001182:	6a42                	ld	s4,16(sp)
}
    80001184:	854a                	mv	a0,s2
    80001186:	70e2                	ld	ra,56(sp)
    80001188:	7442                	ld	s0,48(sp)
    8000118a:	7902                	ld	s2,32(sp)
    8000118c:	6aa2                	ld	s5,8(sp)
    8000118e:	6121                	addi	sp,sp,64
    80001190:	8082                	ret
    return -1;
    80001192:	597d                	li	s2,-1
    80001194:	bfc5                	j	80001184 <fork+0x104>

0000000080001196 <scheduler>:
{
    80001196:	715d                	addi	sp,sp,-80
    80001198:	e486                	sd	ra,72(sp)
    8000119a:	e0a2                	sd	s0,64(sp)
    8000119c:	fc26                	sd	s1,56(sp)
    8000119e:	f84a                	sd	s2,48(sp)
    800011a0:	f44e                	sd	s3,40(sp)
    800011a2:	f052                	sd	s4,32(sp)
    800011a4:	ec56                	sd	s5,24(sp)
    800011a6:	e85a                	sd	s6,16(sp)
    800011a8:	e45e                	sd	s7,8(sp)
    800011aa:	e062                	sd	s8,0(sp)
    800011ac:	0880                	addi	s0,sp,80
    800011ae:	8792                	mv	a5,tp
  int id = r_tp();
    800011b0:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011b2:	00779b13          	slli	s6,a5,0x7
    800011b6:	00009717          	auipc	a4,0x9
    800011ba:	59a70713          	addi	a4,a4,1434 # 8000a750 <pid_lock>
    800011be:	975a                	add	a4,a4,s6
    800011c0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011c4:	00009717          	auipc	a4,0x9
    800011c8:	5c470713          	addi	a4,a4,1476 # 8000a788 <cpus+0x8>
    800011cc:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800011ce:	4c11                	li	s8,4
        c->proc = p;
    800011d0:	079e                	slli	a5,a5,0x7
    800011d2:	00009a17          	auipc	s4,0x9
    800011d6:	57ea0a13          	addi	s4,s4,1406 # 8000a750 <pid_lock>
    800011da:	9a3e                	add	s4,s4,a5
        found = 1;
    800011dc:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    800011de:	0000f997          	auipc	s3,0xf
    800011e2:	5a298993          	addi	s3,s3,1442 # 80010780 <tickslock>
    800011e6:	a0a9                	j	80001230 <scheduler+0x9a>
      release(&p->lock);
    800011e8:	8526                	mv	a0,s1
    800011ea:	0ef040ef          	jal	80005ad8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011ee:	17048493          	addi	s1,s1,368
    800011f2:	03348563          	beq	s1,s3,8000121c <scheduler+0x86>
      acquire(&p->lock);
    800011f6:	8526                	mv	a0,s1
    800011f8:	049040ef          	jal	80005a40 <acquire>
      if(p->state == RUNNABLE) {
    800011fc:	4c9c                	lw	a5,24(s1)
    800011fe:	ff2795e3          	bne	a5,s2,800011e8 <scheduler+0x52>
        p->state = RUNNING;
    80001202:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001206:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000120a:	06048593          	addi	a1,s1,96
    8000120e:	855a                	mv	a0,s6
    80001210:	5b4000ef          	jal	800017c4 <swtch>
        c->proc = 0;
    80001214:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001218:	8ade                	mv	s5,s7
    8000121a:	b7f9                	j	800011e8 <scheduler+0x52>
    if(found == 0) {
    8000121c:	000a9a63          	bnez	s5,80001230 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001220:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001224:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001228:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000122c:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001230:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001234:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001238:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000123c:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000123e:	0000a497          	auipc	s1,0xa
    80001242:	94248493          	addi	s1,s1,-1726 # 8000ab80 <proc>
      if(p->state == RUNNABLE) {
    80001246:	490d                	li	s2,3
    80001248:	b77d                	j	800011f6 <scheduler+0x60>

000000008000124a <sched>:
{
    8000124a:	7179                	addi	sp,sp,-48
    8000124c:	f406                	sd	ra,40(sp)
    8000124e:	f022                	sd	s0,32(sp)
    80001250:	ec26                	sd	s1,24(sp)
    80001252:	e84a                	sd	s2,16(sp)
    80001254:	e44e                	sd	s3,8(sp)
    80001256:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001258:	affff0ef          	jal	80000d56 <myproc>
    8000125c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000125e:	778040ef          	jal	800059d6 <holding>
    80001262:	c92d                	beqz	a0,800012d4 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001264:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001266:	2781                	sext.w	a5,a5
    80001268:	079e                	slli	a5,a5,0x7
    8000126a:	00009717          	auipc	a4,0x9
    8000126e:	4e670713          	addi	a4,a4,1254 # 8000a750 <pid_lock>
    80001272:	97ba                	add	a5,a5,a4
    80001274:	0a87a703          	lw	a4,168(a5)
    80001278:	4785                	li	a5,1
    8000127a:	06f71363          	bne	a4,a5,800012e0 <sched+0x96>
  if(p->state == RUNNING)
    8000127e:	4c98                	lw	a4,24(s1)
    80001280:	4791                	li	a5,4
    80001282:	06f70563          	beq	a4,a5,800012ec <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001286:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000128a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000128c:	e7b5                	bnez	a5,800012f8 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000128e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001290:	00009917          	auipc	s2,0x9
    80001294:	4c090913          	addi	s2,s2,1216 # 8000a750 <pid_lock>
    80001298:	2781                	sext.w	a5,a5
    8000129a:	079e                	slli	a5,a5,0x7
    8000129c:	97ca                	add	a5,a5,s2
    8000129e:	0ac7a983          	lw	s3,172(a5)
    800012a2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012a4:	2781                	sext.w	a5,a5
    800012a6:	079e                	slli	a5,a5,0x7
    800012a8:	00009597          	auipc	a1,0x9
    800012ac:	4e058593          	addi	a1,a1,1248 # 8000a788 <cpus+0x8>
    800012b0:	95be                	add	a1,a1,a5
    800012b2:	06048513          	addi	a0,s1,96
    800012b6:	50e000ef          	jal	800017c4 <swtch>
    800012ba:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012bc:	2781                	sext.w	a5,a5
    800012be:	079e                	slli	a5,a5,0x7
    800012c0:	993e                	add	s2,s2,a5
    800012c2:	0b392623          	sw	s3,172(s2)
}
    800012c6:	70a2                	ld	ra,40(sp)
    800012c8:	7402                	ld	s0,32(sp)
    800012ca:	64e2                	ld	s1,24(sp)
    800012cc:	6942                	ld	s2,16(sp)
    800012ce:	69a2                	ld	s3,8(sp)
    800012d0:	6145                	addi	sp,sp,48
    800012d2:	8082                	ret
    panic("sched p->lock");
    800012d4:	00006517          	auipc	a0,0x6
    800012d8:	f1450513          	addi	a0,a0,-236 # 800071e8 <etext+0x1e8>
    800012dc:	436040ef          	jal	80005712 <panic>
    panic("sched locks");
    800012e0:	00006517          	auipc	a0,0x6
    800012e4:	f1850513          	addi	a0,a0,-232 # 800071f8 <etext+0x1f8>
    800012e8:	42a040ef          	jal	80005712 <panic>
    panic("sched running");
    800012ec:	00006517          	auipc	a0,0x6
    800012f0:	f1c50513          	addi	a0,a0,-228 # 80007208 <etext+0x208>
    800012f4:	41e040ef          	jal	80005712 <panic>
    panic("sched interruptible");
    800012f8:	00006517          	auipc	a0,0x6
    800012fc:	f2050513          	addi	a0,a0,-224 # 80007218 <etext+0x218>
    80001300:	412040ef          	jal	80005712 <panic>

0000000080001304 <yield>:
{
    80001304:	1101                	addi	sp,sp,-32
    80001306:	ec06                	sd	ra,24(sp)
    80001308:	e822                	sd	s0,16(sp)
    8000130a:	e426                	sd	s1,8(sp)
    8000130c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000130e:	a49ff0ef          	jal	80000d56 <myproc>
    80001312:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001314:	72c040ef          	jal	80005a40 <acquire>
  p->state = RUNNABLE;
    80001318:	478d                	li	a5,3
    8000131a:	cc9c                	sw	a5,24(s1)
  sched();
    8000131c:	f2fff0ef          	jal	8000124a <sched>
  release(&p->lock);
    80001320:	8526                	mv	a0,s1
    80001322:	7b6040ef          	jal	80005ad8 <release>
}
    80001326:	60e2                	ld	ra,24(sp)
    80001328:	6442                	ld	s0,16(sp)
    8000132a:	64a2                	ld	s1,8(sp)
    8000132c:	6105                	addi	sp,sp,32
    8000132e:	8082                	ret

0000000080001330 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001330:	7179                	addi	sp,sp,-48
    80001332:	f406                	sd	ra,40(sp)
    80001334:	f022                	sd	s0,32(sp)
    80001336:	ec26                	sd	s1,24(sp)
    80001338:	e84a                	sd	s2,16(sp)
    8000133a:	e44e                	sd	s3,8(sp)
    8000133c:	1800                	addi	s0,sp,48
    8000133e:	89aa                	mv	s3,a0
    80001340:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001342:	a15ff0ef          	jal	80000d56 <myproc>
    80001346:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001348:	6f8040ef          	jal	80005a40 <acquire>
  release(lk);
    8000134c:	854a                	mv	a0,s2
    8000134e:	78a040ef          	jal	80005ad8 <release>

  // Go to sleep.
  p->chan = chan;
    80001352:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001356:	4789                	li	a5,2
    80001358:	cc9c                	sw	a5,24(s1)

  sched();
    8000135a:	ef1ff0ef          	jal	8000124a <sched>

  // Tidy up.
  p->chan = 0;
    8000135e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001362:	8526                	mv	a0,s1
    80001364:	774040ef          	jal	80005ad8 <release>
  acquire(lk);
    80001368:	854a                	mv	a0,s2
    8000136a:	6d6040ef          	jal	80005a40 <acquire>
}
    8000136e:	70a2                	ld	ra,40(sp)
    80001370:	7402                	ld	s0,32(sp)
    80001372:	64e2                	ld	s1,24(sp)
    80001374:	6942                	ld	s2,16(sp)
    80001376:	69a2                	ld	s3,8(sp)
    80001378:	6145                	addi	sp,sp,48
    8000137a:	8082                	ret

000000008000137c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000137c:	7139                	addi	sp,sp,-64
    8000137e:	fc06                	sd	ra,56(sp)
    80001380:	f822                	sd	s0,48(sp)
    80001382:	f426                	sd	s1,40(sp)
    80001384:	f04a                	sd	s2,32(sp)
    80001386:	ec4e                	sd	s3,24(sp)
    80001388:	e852                	sd	s4,16(sp)
    8000138a:	e456                	sd	s5,8(sp)
    8000138c:	0080                	addi	s0,sp,64
    8000138e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001390:	00009497          	auipc	s1,0x9
    80001394:	7f048493          	addi	s1,s1,2032 # 8000ab80 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001398:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000139a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000139c:	0000f917          	auipc	s2,0xf
    800013a0:	3e490913          	addi	s2,s2,996 # 80010780 <tickslock>
    800013a4:	a801                	j	800013b4 <wakeup+0x38>
      }
      release(&p->lock);
    800013a6:	8526                	mv	a0,s1
    800013a8:	730040ef          	jal	80005ad8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013ac:	17048493          	addi	s1,s1,368
    800013b0:	03248263          	beq	s1,s2,800013d4 <wakeup+0x58>
    if(p != myproc()){
    800013b4:	9a3ff0ef          	jal	80000d56 <myproc>
    800013b8:	fea48ae3          	beq	s1,a0,800013ac <wakeup+0x30>
      acquire(&p->lock);
    800013bc:	8526                	mv	a0,s1
    800013be:	682040ef          	jal	80005a40 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800013c2:	4c9c                	lw	a5,24(s1)
    800013c4:	ff3791e3          	bne	a5,s3,800013a6 <wakeup+0x2a>
    800013c8:	709c                	ld	a5,32(s1)
    800013ca:	fd479ee3          	bne	a5,s4,800013a6 <wakeup+0x2a>
        p->state = RUNNABLE;
    800013ce:	0154ac23          	sw	s5,24(s1)
    800013d2:	bfd1                	j	800013a6 <wakeup+0x2a>
    }
  }
}
    800013d4:	70e2                	ld	ra,56(sp)
    800013d6:	7442                	ld	s0,48(sp)
    800013d8:	74a2                	ld	s1,40(sp)
    800013da:	7902                	ld	s2,32(sp)
    800013dc:	69e2                	ld	s3,24(sp)
    800013de:	6a42                	ld	s4,16(sp)
    800013e0:	6aa2                	ld	s5,8(sp)
    800013e2:	6121                	addi	sp,sp,64
    800013e4:	8082                	ret

00000000800013e6 <reparent>:
{
    800013e6:	7179                	addi	sp,sp,-48
    800013e8:	f406                	sd	ra,40(sp)
    800013ea:	f022                	sd	s0,32(sp)
    800013ec:	ec26                	sd	s1,24(sp)
    800013ee:	e84a                	sd	s2,16(sp)
    800013f0:	e44e                	sd	s3,8(sp)
    800013f2:	e052                	sd	s4,0(sp)
    800013f4:	1800                	addi	s0,sp,48
    800013f6:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013f8:	00009497          	auipc	s1,0x9
    800013fc:	78848493          	addi	s1,s1,1928 # 8000ab80 <proc>
      pp->parent = initproc;
    80001400:	00009a17          	auipc	s4,0x9
    80001404:	310a0a13          	addi	s4,s4,784 # 8000a710 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001408:	0000f997          	auipc	s3,0xf
    8000140c:	37898993          	addi	s3,s3,888 # 80010780 <tickslock>
    80001410:	a029                	j	8000141a <reparent+0x34>
    80001412:	17048493          	addi	s1,s1,368
    80001416:	01348b63          	beq	s1,s3,8000142c <reparent+0x46>
    if(pp->parent == p){
    8000141a:	7c9c                	ld	a5,56(s1)
    8000141c:	ff279be3          	bne	a5,s2,80001412 <reparent+0x2c>
      pp->parent = initproc;
    80001420:	000a3503          	ld	a0,0(s4)
    80001424:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001426:	f57ff0ef          	jal	8000137c <wakeup>
    8000142a:	b7e5                	j	80001412 <reparent+0x2c>
}
    8000142c:	70a2                	ld	ra,40(sp)
    8000142e:	7402                	ld	s0,32(sp)
    80001430:	64e2                	ld	s1,24(sp)
    80001432:	6942                	ld	s2,16(sp)
    80001434:	69a2                	ld	s3,8(sp)
    80001436:	6a02                	ld	s4,0(sp)
    80001438:	6145                	addi	sp,sp,48
    8000143a:	8082                	ret

000000008000143c <exit>:
{
    8000143c:	7179                	addi	sp,sp,-48
    8000143e:	f406                	sd	ra,40(sp)
    80001440:	f022                	sd	s0,32(sp)
    80001442:	ec26                	sd	s1,24(sp)
    80001444:	e84a                	sd	s2,16(sp)
    80001446:	e44e                	sd	s3,8(sp)
    80001448:	e052                	sd	s4,0(sp)
    8000144a:	1800                	addi	s0,sp,48
    8000144c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000144e:	909ff0ef          	jal	80000d56 <myproc>
    80001452:	89aa                	mv	s3,a0
  if(p == initproc)
    80001454:	00009797          	auipc	a5,0x9
    80001458:	2bc7b783          	ld	a5,700(a5) # 8000a710 <initproc>
    8000145c:	0d050493          	addi	s1,a0,208
    80001460:	15050913          	addi	s2,a0,336
    80001464:	00a79f63          	bne	a5,a0,80001482 <exit+0x46>
    panic("init exiting");
    80001468:	00006517          	auipc	a0,0x6
    8000146c:	dc850513          	addi	a0,a0,-568 # 80007230 <etext+0x230>
    80001470:	2a2040ef          	jal	80005712 <panic>
      fileclose(f);
    80001474:	1a0020ef          	jal	80003614 <fileclose>
      p->ofile[fd] = 0;
    80001478:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000147c:	04a1                	addi	s1,s1,8
    8000147e:	01248563          	beq	s1,s2,80001488 <exit+0x4c>
    if(p->ofile[fd]){
    80001482:	6088                	ld	a0,0(s1)
    80001484:	f965                	bnez	a0,80001474 <exit+0x38>
    80001486:	bfdd                	j	8000147c <exit+0x40>
  begin_op();
    80001488:	573010ef          	jal	800031fa <begin_op>
  iput(p->cwd);
    8000148c:	1509b503          	ld	a0,336(s3)
    80001490:	656010ef          	jal	80002ae6 <iput>
  end_op();
    80001494:	5d1010ef          	jal	80003264 <end_op>
  p->cwd = 0;
    80001498:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000149c:	00009497          	auipc	s1,0x9
    800014a0:	2cc48493          	addi	s1,s1,716 # 8000a768 <wait_lock>
    800014a4:	8526                	mv	a0,s1
    800014a6:	59a040ef          	jal	80005a40 <acquire>
  reparent(p);
    800014aa:	854e                	mv	a0,s3
    800014ac:	f3bff0ef          	jal	800013e6 <reparent>
  wakeup(p->parent);
    800014b0:	0389b503          	ld	a0,56(s3)
    800014b4:	ec9ff0ef          	jal	8000137c <wakeup>
  acquire(&p->lock);
    800014b8:	854e                	mv	a0,s3
    800014ba:	586040ef          	jal	80005a40 <acquire>
  p->xstate = status;
    800014be:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014c2:	4795                	li	a5,5
    800014c4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014c8:	8526                	mv	a0,s1
    800014ca:	60e040ef          	jal	80005ad8 <release>
  sched();
    800014ce:	d7dff0ef          	jal	8000124a <sched>
  panic("zombie exit");
    800014d2:	00006517          	auipc	a0,0x6
    800014d6:	d6e50513          	addi	a0,a0,-658 # 80007240 <etext+0x240>
    800014da:	238040ef          	jal	80005712 <panic>

00000000800014de <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800014de:	7179                	addi	sp,sp,-48
    800014e0:	f406                	sd	ra,40(sp)
    800014e2:	f022                	sd	s0,32(sp)
    800014e4:	ec26                	sd	s1,24(sp)
    800014e6:	e84a                	sd	s2,16(sp)
    800014e8:	e44e                	sd	s3,8(sp)
    800014ea:	1800                	addi	s0,sp,48
    800014ec:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800014ee:	00009497          	auipc	s1,0x9
    800014f2:	69248493          	addi	s1,s1,1682 # 8000ab80 <proc>
    800014f6:	0000f997          	auipc	s3,0xf
    800014fa:	28a98993          	addi	s3,s3,650 # 80010780 <tickslock>
    acquire(&p->lock);
    800014fe:	8526                	mv	a0,s1
    80001500:	540040ef          	jal	80005a40 <acquire>
    if(p->pid == pid){
    80001504:	589c                	lw	a5,48(s1)
    80001506:	01278b63          	beq	a5,s2,8000151c <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000150a:	8526                	mv	a0,s1
    8000150c:	5cc040ef          	jal	80005ad8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001510:	17048493          	addi	s1,s1,368
    80001514:	ff3495e3          	bne	s1,s3,800014fe <kill+0x20>
  }
  return -1;
    80001518:	557d                	li	a0,-1
    8000151a:	a819                	j	80001530 <kill+0x52>
      p->killed = 1;
    8000151c:	4785                	li	a5,1
    8000151e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001520:	4c98                	lw	a4,24(s1)
    80001522:	4789                	li	a5,2
    80001524:	00f70d63          	beq	a4,a5,8000153e <kill+0x60>
      release(&p->lock);
    80001528:	8526                	mv	a0,s1
    8000152a:	5ae040ef          	jal	80005ad8 <release>
      return 0;
    8000152e:	4501                	li	a0,0
}
    80001530:	70a2                	ld	ra,40(sp)
    80001532:	7402                	ld	s0,32(sp)
    80001534:	64e2                	ld	s1,24(sp)
    80001536:	6942                	ld	s2,16(sp)
    80001538:	69a2                	ld	s3,8(sp)
    8000153a:	6145                	addi	sp,sp,48
    8000153c:	8082                	ret
        p->state = RUNNABLE;
    8000153e:	478d                	li	a5,3
    80001540:	cc9c                	sw	a5,24(s1)
    80001542:	b7dd                	j	80001528 <kill+0x4a>

0000000080001544 <setkilled>:

void
setkilled(struct proc *p)
{
    80001544:	1101                	addi	sp,sp,-32
    80001546:	ec06                	sd	ra,24(sp)
    80001548:	e822                	sd	s0,16(sp)
    8000154a:	e426                	sd	s1,8(sp)
    8000154c:	1000                	addi	s0,sp,32
    8000154e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001550:	4f0040ef          	jal	80005a40 <acquire>
  p->killed = 1;
    80001554:	4785                	li	a5,1
    80001556:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001558:	8526                	mv	a0,s1
    8000155a:	57e040ef          	jal	80005ad8 <release>
}
    8000155e:	60e2                	ld	ra,24(sp)
    80001560:	6442                	ld	s0,16(sp)
    80001562:	64a2                	ld	s1,8(sp)
    80001564:	6105                	addi	sp,sp,32
    80001566:	8082                	ret

0000000080001568 <killed>:

int
killed(struct proc *p)
{
    80001568:	1101                	addi	sp,sp,-32
    8000156a:	ec06                	sd	ra,24(sp)
    8000156c:	e822                	sd	s0,16(sp)
    8000156e:	e426                	sd	s1,8(sp)
    80001570:	e04a                	sd	s2,0(sp)
    80001572:	1000                	addi	s0,sp,32
    80001574:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001576:	4ca040ef          	jal	80005a40 <acquire>
  k = p->killed;
    8000157a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000157e:	8526                	mv	a0,s1
    80001580:	558040ef          	jal	80005ad8 <release>
  return k;
}
    80001584:	854a                	mv	a0,s2
    80001586:	60e2                	ld	ra,24(sp)
    80001588:	6442                	ld	s0,16(sp)
    8000158a:	64a2                	ld	s1,8(sp)
    8000158c:	6902                	ld	s2,0(sp)
    8000158e:	6105                	addi	sp,sp,32
    80001590:	8082                	ret

0000000080001592 <wait>:
{
    80001592:	715d                	addi	sp,sp,-80
    80001594:	e486                	sd	ra,72(sp)
    80001596:	e0a2                	sd	s0,64(sp)
    80001598:	fc26                	sd	s1,56(sp)
    8000159a:	f84a                	sd	s2,48(sp)
    8000159c:	f44e                	sd	s3,40(sp)
    8000159e:	f052                	sd	s4,32(sp)
    800015a0:	ec56                	sd	s5,24(sp)
    800015a2:	e85a                	sd	s6,16(sp)
    800015a4:	e45e                	sd	s7,8(sp)
    800015a6:	e062                	sd	s8,0(sp)
    800015a8:	0880                	addi	s0,sp,80
    800015aa:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015ac:	faaff0ef          	jal	80000d56 <myproc>
    800015b0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015b2:	00009517          	auipc	a0,0x9
    800015b6:	1b650513          	addi	a0,a0,438 # 8000a768 <wait_lock>
    800015ba:	486040ef          	jal	80005a40 <acquire>
    havekids = 0;
    800015be:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800015c0:	4a15                	li	s4,5
        havekids = 1;
    800015c2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015c4:	0000f997          	auipc	s3,0xf
    800015c8:	1bc98993          	addi	s3,s3,444 # 80010780 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015cc:	00009c17          	auipc	s8,0x9
    800015d0:	19cc0c13          	addi	s8,s8,412 # 8000a768 <wait_lock>
    800015d4:	a871                	j	80001670 <wait+0xde>
          pid = pp->pid;
    800015d6:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800015da:	000b0c63          	beqz	s6,800015f2 <wait+0x60>
    800015de:	4691                	li	a3,4
    800015e0:	02c48613          	addi	a2,s1,44
    800015e4:	85da                	mv	a1,s6
    800015e6:	05093503          	ld	a0,80(s2)
    800015ea:	bdcff0ef          	jal	800009c6 <copyout>
    800015ee:	02054b63          	bltz	a0,80001624 <wait+0x92>
          freeproc(pp);
    800015f2:	8526                	mv	a0,s1
    800015f4:	8d5ff0ef          	jal	80000ec8 <freeproc>
          release(&pp->lock);
    800015f8:	8526                	mv	a0,s1
    800015fa:	4de040ef          	jal	80005ad8 <release>
          release(&wait_lock);
    800015fe:	00009517          	auipc	a0,0x9
    80001602:	16a50513          	addi	a0,a0,362 # 8000a768 <wait_lock>
    80001606:	4d2040ef          	jal	80005ad8 <release>
}
    8000160a:	854e                	mv	a0,s3
    8000160c:	60a6                	ld	ra,72(sp)
    8000160e:	6406                	ld	s0,64(sp)
    80001610:	74e2                	ld	s1,56(sp)
    80001612:	7942                	ld	s2,48(sp)
    80001614:	79a2                	ld	s3,40(sp)
    80001616:	7a02                	ld	s4,32(sp)
    80001618:	6ae2                	ld	s5,24(sp)
    8000161a:	6b42                	ld	s6,16(sp)
    8000161c:	6ba2                	ld	s7,8(sp)
    8000161e:	6c02                	ld	s8,0(sp)
    80001620:	6161                	addi	sp,sp,80
    80001622:	8082                	ret
            release(&pp->lock);
    80001624:	8526                	mv	a0,s1
    80001626:	4b2040ef          	jal	80005ad8 <release>
            release(&wait_lock);
    8000162a:	00009517          	auipc	a0,0x9
    8000162e:	13e50513          	addi	a0,a0,318 # 8000a768 <wait_lock>
    80001632:	4a6040ef          	jal	80005ad8 <release>
            return -1;
    80001636:	59fd                	li	s3,-1
    80001638:	bfc9                	j	8000160a <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000163a:	17048493          	addi	s1,s1,368
    8000163e:	03348063          	beq	s1,s3,8000165e <wait+0xcc>
      if(pp->parent == p){
    80001642:	7c9c                	ld	a5,56(s1)
    80001644:	ff279be3          	bne	a5,s2,8000163a <wait+0xa8>
        acquire(&pp->lock);
    80001648:	8526                	mv	a0,s1
    8000164a:	3f6040ef          	jal	80005a40 <acquire>
        if(pp->state == ZOMBIE){
    8000164e:	4c9c                	lw	a5,24(s1)
    80001650:	f94783e3          	beq	a5,s4,800015d6 <wait+0x44>
        release(&pp->lock);
    80001654:	8526                	mv	a0,s1
    80001656:	482040ef          	jal	80005ad8 <release>
        havekids = 1;
    8000165a:	8756                	mv	a4,s5
    8000165c:	bff9                	j	8000163a <wait+0xa8>
    if(!havekids || killed(p)){
    8000165e:	cf19                	beqz	a4,8000167c <wait+0xea>
    80001660:	854a                	mv	a0,s2
    80001662:	f07ff0ef          	jal	80001568 <killed>
    80001666:	e919                	bnez	a0,8000167c <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001668:	85e2                	mv	a1,s8
    8000166a:	854a                	mv	a0,s2
    8000166c:	cc5ff0ef          	jal	80001330 <sleep>
    havekids = 0;
    80001670:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001672:	00009497          	auipc	s1,0x9
    80001676:	50e48493          	addi	s1,s1,1294 # 8000ab80 <proc>
    8000167a:	b7e1                	j	80001642 <wait+0xb0>
      release(&wait_lock);
    8000167c:	00009517          	auipc	a0,0x9
    80001680:	0ec50513          	addi	a0,a0,236 # 8000a768 <wait_lock>
    80001684:	454040ef          	jal	80005ad8 <release>
      return -1;
    80001688:	59fd                	li	s3,-1
    8000168a:	b741                	j	8000160a <wait+0x78>

000000008000168c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000168c:	7179                	addi	sp,sp,-48
    8000168e:	f406                	sd	ra,40(sp)
    80001690:	f022                	sd	s0,32(sp)
    80001692:	ec26                	sd	s1,24(sp)
    80001694:	e84a                	sd	s2,16(sp)
    80001696:	e44e                	sd	s3,8(sp)
    80001698:	e052                	sd	s4,0(sp)
    8000169a:	1800                	addi	s0,sp,48
    8000169c:	84aa                	mv	s1,a0
    8000169e:	892e                	mv	s2,a1
    800016a0:	89b2                	mv	s3,a2
    800016a2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016a4:	eb2ff0ef          	jal	80000d56 <myproc>
  if(user_dst){
    800016a8:	cc99                	beqz	s1,800016c6 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016aa:	86d2                	mv	a3,s4
    800016ac:	864e                	mv	a2,s3
    800016ae:	85ca                	mv	a1,s2
    800016b0:	6928                	ld	a0,80(a0)
    800016b2:	b14ff0ef          	jal	800009c6 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016b6:	70a2                	ld	ra,40(sp)
    800016b8:	7402                	ld	s0,32(sp)
    800016ba:	64e2                	ld	s1,24(sp)
    800016bc:	6942                	ld	s2,16(sp)
    800016be:	69a2                	ld	s3,8(sp)
    800016c0:	6a02                	ld	s4,0(sp)
    800016c2:	6145                	addi	sp,sp,48
    800016c4:	8082                	ret
    memmove((char *)dst, src, len);
    800016c6:	000a061b          	sext.w	a2,s4
    800016ca:	85ce                	mv	a1,s3
    800016cc:	854a                	mv	a0,s2
    800016ce:	ac3fe0ef          	jal	80000190 <memmove>
    return 0;
    800016d2:	8526                	mv	a0,s1
    800016d4:	b7cd                	j	800016b6 <either_copyout+0x2a>

00000000800016d6 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800016d6:	7179                	addi	sp,sp,-48
    800016d8:	f406                	sd	ra,40(sp)
    800016da:	f022                	sd	s0,32(sp)
    800016dc:	ec26                	sd	s1,24(sp)
    800016de:	e84a                	sd	s2,16(sp)
    800016e0:	e44e                	sd	s3,8(sp)
    800016e2:	e052                	sd	s4,0(sp)
    800016e4:	1800                	addi	s0,sp,48
    800016e6:	892a                	mv	s2,a0
    800016e8:	84ae                	mv	s1,a1
    800016ea:	89b2                	mv	s3,a2
    800016ec:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016ee:	e68ff0ef          	jal	80000d56 <myproc>
  if(user_src){
    800016f2:	cc99                	beqz	s1,80001710 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800016f4:	86d2                	mv	a3,s4
    800016f6:	864e                	mv	a2,s3
    800016f8:	85ca                	mv	a1,s2
    800016fa:	6928                	ld	a0,80(a0)
    800016fc:	ba2ff0ef          	jal	80000a9e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001700:	70a2                	ld	ra,40(sp)
    80001702:	7402                	ld	s0,32(sp)
    80001704:	64e2                	ld	s1,24(sp)
    80001706:	6942                	ld	s2,16(sp)
    80001708:	69a2                	ld	s3,8(sp)
    8000170a:	6a02                	ld	s4,0(sp)
    8000170c:	6145                	addi	sp,sp,48
    8000170e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001710:	000a061b          	sext.w	a2,s4
    80001714:	85ce                	mv	a1,s3
    80001716:	854a                	mv	a0,s2
    80001718:	a79fe0ef          	jal	80000190 <memmove>
    return 0;
    8000171c:	8526                	mv	a0,s1
    8000171e:	b7cd                	j	80001700 <either_copyin+0x2a>

0000000080001720 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001720:	715d                	addi	sp,sp,-80
    80001722:	e486                	sd	ra,72(sp)
    80001724:	e0a2                	sd	s0,64(sp)
    80001726:	fc26                	sd	s1,56(sp)
    80001728:	f84a                	sd	s2,48(sp)
    8000172a:	f44e                	sd	s3,40(sp)
    8000172c:	f052                	sd	s4,32(sp)
    8000172e:	ec56                	sd	s5,24(sp)
    80001730:	e85a                	sd	s6,16(sp)
    80001732:	e45e                	sd	s7,8(sp)
    80001734:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001736:	00006517          	auipc	a0,0x6
    8000173a:	8e250513          	addi	a0,a0,-1822 # 80007018 <etext+0x18>
    8000173e:	503030ef          	jal	80005440 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001742:	00009497          	auipc	s1,0x9
    80001746:	59648493          	addi	s1,s1,1430 # 8000acd8 <proc+0x158>
    8000174a:	0000f917          	auipc	s2,0xf
    8000174e:	18e90913          	addi	s2,s2,398 # 800108d8 <syscall_counts+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001752:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001754:	00006997          	auipc	s3,0x6
    80001758:	afc98993          	addi	s3,s3,-1284 # 80007250 <etext+0x250>
    printf("%d %s %s", p->pid, state, p->name);
    8000175c:	00006a97          	auipc	s5,0x6
    80001760:	afca8a93          	addi	s5,s5,-1284 # 80007258 <etext+0x258>
    printf("\n");
    80001764:	00006a17          	auipc	s4,0x6
    80001768:	8b4a0a13          	addi	s4,s4,-1868 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000176c:	00006b97          	auipc	s7,0x6
    80001770:	15cb8b93          	addi	s7,s7,348 # 800078c8 <states.0>
    80001774:	a829                	j	8000178e <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001776:	ed86a583          	lw	a1,-296(a3)
    8000177a:	8556                	mv	a0,s5
    8000177c:	4c5030ef          	jal	80005440 <printf>
    printf("\n");
    80001780:	8552                	mv	a0,s4
    80001782:	4bf030ef          	jal	80005440 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001786:	17048493          	addi	s1,s1,368
    8000178a:	03248263          	beq	s1,s2,800017ae <procdump+0x8e>
    if(p->state == UNUSED)
    8000178e:	86a6                	mv	a3,s1
    80001790:	ec04a783          	lw	a5,-320(s1)
    80001794:	dbed                	beqz	a5,80001786 <procdump+0x66>
      state = "???";
    80001796:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001798:	fcfb6fe3          	bltu	s6,a5,80001776 <procdump+0x56>
    8000179c:	02079713          	slli	a4,a5,0x20
    800017a0:	01d75793          	srli	a5,a4,0x1d
    800017a4:	97de                	add	a5,a5,s7
    800017a6:	6390                	ld	a2,0(a5)
    800017a8:	f679                	bnez	a2,80001776 <procdump+0x56>
      state = "???";
    800017aa:	864e                	mv	a2,s3
    800017ac:	b7e9                	j	80001776 <procdump+0x56>
  }
}
    800017ae:	60a6                	ld	ra,72(sp)
    800017b0:	6406                	ld	s0,64(sp)
    800017b2:	74e2                	ld	s1,56(sp)
    800017b4:	7942                	ld	s2,48(sp)
    800017b6:	79a2                	ld	s3,40(sp)
    800017b8:	7a02                	ld	s4,32(sp)
    800017ba:	6ae2                	ld	s5,24(sp)
    800017bc:	6b42                	ld	s6,16(sp)
    800017be:	6ba2                	ld	s7,8(sp)
    800017c0:	6161                	addi	sp,sp,80
    800017c2:	8082                	ret

00000000800017c4 <swtch>:
    800017c4:	00153023          	sd	ra,0(a0)
    800017c8:	00253423          	sd	sp,8(a0)
    800017cc:	e900                	sd	s0,16(a0)
    800017ce:	ed04                	sd	s1,24(a0)
    800017d0:	03253023          	sd	s2,32(a0)
    800017d4:	03353423          	sd	s3,40(a0)
    800017d8:	03453823          	sd	s4,48(a0)
    800017dc:	03553c23          	sd	s5,56(a0)
    800017e0:	05653023          	sd	s6,64(a0)
    800017e4:	05753423          	sd	s7,72(a0)
    800017e8:	05853823          	sd	s8,80(a0)
    800017ec:	05953c23          	sd	s9,88(a0)
    800017f0:	07a53023          	sd	s10,96(a0)
    800017f4:	07b53423          	sd	s11,104(a0)
    800017f8:	0005b083          	ld	ra,0(a1)
    800017fc:	0085b103          	ld	sp,8(a1)
    80001800:	6980                	ld	s0,16(a1)
    80001802:	6d84                	ld	s1,24(a1)
    80001804:	0205b903          	ld	s2,32(a1)
    80001808:	0285b983          	ld	s3,40(a1)
    8000180c:	0305ba03          	ld	s4,48(a1)
    80001810:	0385ba83          	ld	s5,56(a1)
    80001814:	0405bb03          	ld	s6,64(a1)
    80001818:	0485bb83          	ld	s7,72(a1)
    8000181c:	0505bc03          	ld	s8,80(a1)
    80001820:	0585bc83          	ld	s9,88(a1)
    80001824:	0605bd03          	ld	s10,96(a1)
    80001828:	0685bd83          	ld	s11,104(a1)
    8000182c:	8082                	ret

000000008000182e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000182e:	1141                	addi	sp,sp,-16
    80001830:	e406                	sd	ra,8(sp)
    80001832:	e022                	sd	s0,0(sp)
    80001834:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001836:	00006597          	auipc	a1,0x6
    8000183a:	a6258593          	addi	a1,a1,-1438 # 80007298 <etext+0x298>
    8000183e:	0000f517          	auipc	a0,0xf
    80001842:	f4250513          	addi	a0,a0,-190 # 80010780 <tickslock>
    80001846:	17a040ef          	jal	800059c0 <initlock>
}
    8000184a:	60a2                	ld	ra,8(sp)
    8000184c:	6402                	ld	s0,0(sp)
    8000184e:	0141                	addi	sp,sp,16
    80001850:	8082                	ret

0000000080001852 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001852:	1141                	addi	sp,sp,-16
    80001854:	e422                	sd	s0,8(sp)
    80001856:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001858:	00003797          	auipc	a5,0x3
    8000185c:	12878793          	addi	a5,a5,296 # 80004980 <kernelvec>
    80001860:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001864:	6422                	ld	s0,8(sp)
    80001866:	0141                	addi	sp,sp,16
    80001868:	8082                	ret

000000008000186a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000186a:	1141                	addi	sp,sp,-16
    8000186c:	e406                	sd	ra,8(sp)
    8000186e:	e022                	sd	s0,0(sp)
    80001870:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001872:	ce4ff0ef          	jal	80000d56 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001876:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000187a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000187c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001880:	00004697          	auipc	a3,0x4
    80001884:	78068693          	addi	a3,a3,1920 # 80006000 <_trampoline>
    80001888:	00004717          	auipc	a4,0x4
    8000188c:	77870713          	addi	a4,a4,1912 # 80006000 <_trampoline>
    80001890:	8f15                	sub	a4,a4,a3
    80001892:	040007b7          	lui	a5,0x4000
    80001896:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001898:	07b2                	slli	a5,a5,0xc
    8000189a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000189c:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800018a0:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800018a2:	18002673          	csrr	a2,satp
    800018a6:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800018a8:	6d30                	ld	a2,88(a0)
    800018aa:	6138                	ld	a4,64(a0)
    800018ac:	6585                	lui	a1,0x1
    800018ae:	972e                	add	a4,a4,a1
    800018b0:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800018b2:	6d38                	ld	a4,88(a0)
    800018b4:	00000617          	auipc	a2,0x0
    800018b8:	11060613          	addi	a2,a2,272 # 800019c4 <usertrap>
    800018bc:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800018be:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800018c0:	8612                	mv	a2,tp
    800018c2:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018c4:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800018c8:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800018cc:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018d0:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800018d4:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800018d6:	6f18                	ld	a4,24(a4)
    800018d8:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800018dc:	6928                	ld	a0,80(a0)
    800018de:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800018e0:	00004717          	auipc	a4,0x4
    800018e4:	7bc70713          	addi	a4,a4,1980 # 8000609c <userret>
    800018e8:	8f15                	sub	a4,a4,a3
    800018ea:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800018ec:	577d                	li	a4,-1
    800018ee:	177e                	slli	a4,a4,0x3f
    800018f0:	8d59                	or	a0,a0,a4
    800018f2:	9782                	jalr	a5
}
    800018f4:	60a2                	ld	ra,8(sp)
    800018f6:	6402                	ld	s0,0(sp)
    800018f8:	0141                	addi	sp,sp,16
    800018fa:	8082                	ret

00000000800018fc <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800018fc:	1101                	addi	sp,sp,-32
    800018fe:	ec06                	sd	ra,24(sp)
    80001900:	e822                	sd	s0,16(sp)
    80001902:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001904:	c26ff0ef          	jal	80000d2a <cpuid>
    80001908:	cd11                	beqz	a0,80001924 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000190a:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000190e:	000f4737          	lui	a4,0xf4
    80001912:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001916:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001918:	14d79073          	csrw	stimecmp,a5
}
    8000191c:	60e2                	ld	ra,24(sp)
    8000191e:	6442                	ld	s0,16(sp)
    80001920:	6105                	addi	sp,sp,32
    80001922:	8082                	ret
    80001924:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80001926:	0000f497          	auipc	s1,0xf
    8000192a:	e5a48493          	addi	s1,s1,-422 # 80010780 <tickslock>
    8000192e:	8526                	mv	a0,s1
    80001930:	110040ef          	jal	80005a40 <acquire>
    ticks++;
    80001934:	00009517          	auipc	a0,0x9
    80001938:	de450513          	addi	a0,a0,-540 # 8000a718 <ticks>
    8000193c:	411c                	lw	a5,0(a0)
    8000193e:	2785                	addiw	a5,a5,1
    80001940:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001942:	a3bff0ef          	jal	8000137c <wakeup>
    release(&tickslock);
    80001946:	8526                	mv	a0,s1
    80001948:	190040ef          	jal	80005ad8 <release>
    8000194c:	64a2                	ld	s1,8(sp)
    8000194e:	bf75                	j	8000190a <clockintr+0xe>

0000000080001950 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001950:	1101                	addi	sp,sp,-32
    80001952:	ec06                	sd	ra,24(sp)
    80001954:	e822                	sd	s0,16(sp)
    80001956:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001958:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    8000195c:	57fd                	li	a5,-1
    8000195e:	17fe                	slli	a5,a5,0x3f
    80001960:	07a5                	addi	a5,a5,9
    80001962:	00f70c63          	beq	a4,a5,8000197a <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001966:	57fd                	li	a5,-1
    80001968:	17fe                	slli	a5,a5,0x3f
    8000196a:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000196c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000196e:	04f70763          	beq	a4,a5,800019bc <devintr+0x6c>
  }
}
    80001972:	60e2                	ld	ra,24(sp)
    80001974:	6442                	ld	s0,16(sp)
    80001976:	6105                	addi	sp,sp,32
    80001978:	8082                	ret
    8000197a:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    8000197c:	0b0030ef          	jal	80004a2c <plic_claim>
    80001980:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001982:	47a9                	li	a5,10
    80001984:	00f50963          	beq	a0,a5,80001996 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001988:	4785                	li	a5,1
    8000198a:	00f50963          	beq	a0,a5,8000199c <devintr+0x4c>
    return 1;
    8000198e:	4505                	li	a0,1
    } else if(irq){
    80001990:	e889                	bnez	s1,800019a2 <devintr+0x52>
    80001992:	64a2                	ld	s1,8(sp)
    80001994:	bff9                	j	80001972 <devintr+0x22>
      uartintr();
    80001996:	7ef030ef          	jal	80005984 <uartintr>
    if(irq)
    8000199a:	a819                	j	800019b0 <devintr+0x60>
      virtio_disk_intr();
    8000199c:	556030ef          	jal	80004ef2 <virtio_disk_intr>
    if(irq)
    800019a0:	a801                	j	800019b0 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019a2:	85a6                	mv	a1,s1
    800019a4:	00006517          	auipc	a0,0x6
    800019a8:	8fc50513          	addi	a0,a0,-1796 # 800072a0 <etext+0x2a0>
    800019ac:	295030ef          	jal	80005440 <printf>
      plic_complete(irq);
    800019b0:	8526                	mv	a0,s1
    800019b2:	09a030ef          	jal	80004a4c <plic_complete>
    return 1;
    800019b6:	4505                	li	a0,1
    800019b8:	64a2                	ld	s1,8(sp)
    800019ba:	bf65                	j	80001972 <devintr+0x22>
    clockintr();
    800019bc:	f41ff0ef          	jal	800018fc <clockintr>
    return 2;
    800019c0:	4509                	li	a0,2
    800019c2:	bf45                	j	80001972 <devintr+0x22>

00000000800019c4 <usertrap>:
{
    800019c4:	1101                	addi	sp,sp,-32
    800019c6:	ec06                	sd	ra,24(sp)
    800019c8:	e822                	sd	s0,16(sp)
    800019ca:	e426                	sd	s1,8(sp)
    800019cc:	e04a                	sd	s2,0(sp)
    800019ce:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019d0:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800019d4:	1007f793          	andi	a5,a5,256
    800019d8:	ef85                	bnez	a5,80001a10 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800019da:	00003797          	auipc	a5,0x3
    800019de:	fa678793          	addi	a5,a5,-90 # 80004980 <kernelvec>
    800019e2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800019e6:	b70ff0ef          	jal	80000d56 <myproc>
    800019ea:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800019ec:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800019ee:	14102773          	csrr	a4,sepc
    800019f2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019f4:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800019f8:	47a1                	li	a5,8
    800019fa:	02f70163          	beq	a4,a5,80001a1c <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800019fe:	f53ff0ef          	jal	80001950 <devintr>
    80001a02:	892a                	mv	s2,a0
    80001a04:	c135                	beqz	a0,80001a68 <usertrap+0xa4>
  if(killed(p))
    80001a06:	8526                	mv	a0,s1
    80001a08:	b61ff0ef          	jal	80001568 <killed>
    80001a0c:	cd1d                	beqz	a0,80001a4a <usertrap+0x86>
    80001a0e:	a81d                	j	80001a44 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001a10:	00006517          	auipc	a0,0x6
    80001a14:	8b050513          	addi	a0,a0,-1872 # 800072c0 <etext+0x2c0>
    80001a18:	4fb030ef          	jal	80005712 <panic>
    if(killed(p))
    80001a1c:	b4dff0ef          	jal	80001568 <killed>
    80001a20:	e121                	bnez	a0,80001a60 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001a22:	6cb8                	ld	a4,88(s1)
    80001a24:	6f1c                	ld	a5,24(a4)
    80001a26:	0791                	addi	a5,a5,4
    80001a28:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a2a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a2e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a32:	10079073          	csrw	sstatus,a5
    syscall();
    80001a36:	248000ef          	jal	80001c7e <syscall>
  if(killed(p))
    80001a3a:	8526                	mv	a0,s1
    80001a3c:	b2dff0ef          	jal	80001568 <killed>
    80001a40:	c901                	beqz	a0,80001a50 <usertrap+0x8c>
    80001a42:	4901                	li	s2,0
    exit(-1);
    80001a44:	557d                	li	a0,-1
    80001a46:	9f7ff0ef          	jal	8000143c <exit>
  if(which_dev == 2)
    80001a4a:	4789                	li	a5,2
    80001a4c:	04f90563          	beq	s2,a5,80001a96 <usertrap+0xd2>
  usertrapret();
    80001a50:	e1bff0ef          	jal	8000186a <usertrapret>
}
    80001a54:	60e2                	ld	ra,24(sp)
    80001a56:	6442                	ld	s0,16(sp)
    80001a58:	64a2                	ld	s1,8(sp)
    80001a5a:	6902                	ld	s2,0(sp)
    80001a5c:	6105                	addi	sp,sp,32
    80001a5e:	8082                	ret
      exit(-1);
    80001a60:	557d                	li	a0,-1
    80001a62:	9dbff0ef          	jal	8000143c <exit>
    80001a66:	bf75                	j	80001a22 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a68:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a6c:	5890                	lw	a2,48(s1)
    80001a6e:	00006517          	auipc	a0,0x6
    80001a72:	87250513          	addi	a0,a0,-1934 # 800072e0 <etext+0x2e0>
    80001a76:	1cb030ef          	jal	80005440 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a7a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a7e:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a82:	00006517          	auipc	a0,0x6
    80001a86:	88e50513          	addi	a0,a0,-1906 # 80007310 <etext+0x310>
    80001a8a:	1b7030ef          	jal	80005440 <printf>
    setkilled(p);
    80001a8e:	8526                	mv	a0,s1
    80001a90:	ab5ff0ef          	jal	80001544 <setkilled>
    80001a94:	b75d                	j	80001a3a <usertrap+0x76>
    yield();
    80001a96:	86fff0ef          	jal	80001304 <yield>
    80001a9a:	bf5d                	j	80001a50 <usertrap+0x8c>

0000000080001a9c <kerneltrap>:
{
    80001a9c:	7179                	addi	sp,sp,-48
    80001a9e:	f406                	sd	ra,40(sp)
    80001aa0:	f022                	sd	s0,32(sp)
    80001aa2:	ec26                	sd	s1,24(sp)
    80001aa4:	e84a                	sd	s2,16(sp)
    80001aa6:	e44e                	sd	s3,8(sp)
    80001aa8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001aaa:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aae:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ab2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001ab6:	1004f793          	andi	a5,s1,256
    80001aba:	c795                	beqz	a5,80001ae6 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001abc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ac0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ac2:	eb85                	bnez	a5,80001af2 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001ac4:	e8dff0ef          	jal	80001950 <devintr>
    80001ac8:	c91d                	beqz	a0,80001afe <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001aca:	4789                	li	a5,2
    80001acc:	04f50a63          	beq	a0,a5,80001b20 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ad0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ad4:	10049073          	csrw	sstatus,s1
}
    80001ad8:	70a2                	ld	ra,40(sp)
    80001ada:	7402                	ld	s0,32(sp)
    80001adc:	64e2                	ld	s1,24(sp)
    80001ade:	6942                	ld	s2,16(sp)
    80001ae0:	69a2                	ld	s3,8(sp)
    80001ae2:	6145                	addi	sp,sp,48
    80001ae4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ae6:	00006517          	auipc	a0,0x6
    80001aea:	85250513          	addi	a0,a0,-1966 # 80007338 <etext+0x338>
    80001aee:	425030ef          	jal	80005712 <panic>
    panic("kerneltrap: interrupts enabled");
    80001af2:	00006517          	auipc	a0,0x6
    80001af6:	86e50513          	addi	a0,a0,-1938 # 80007360 <etext+0x360>
    80001afa:	419030ef          	jal	80005712 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001afe:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b02:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b06:	85ce                	mv	a1,s3
    80001b08:	00006517          	auipc	a0,0x6
    80001b0c:	87850513          	addi	a0,a0,-1928 # 80007380 <etext+0x380>
    80001b10:	131030ef          	jal	80005440 <printf>
    panic("kerneltrap");
    80001b14:	00006517          	auipc	a0,0x6
    80001b18:	89450513          	addi	a0,a0,-1900 # 800073a8 <etext+0x3a8>
    80001b1c:	3f7030ef          	jal	80005712 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b20:	a36ff0ef          	jal	80000d56 <myproc>
    80001b24:	d555                	beqz	a0,80001ad0 <kerneltrap+0x34>
    yield();
    80001b26:	fdeff0ef          	jal	80001304 <yield>
    80001b2a:	b75d                	j	80001ad0 <kerneltrap+0x34>

0000000080001b2c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b2c:	1101                	addi	sp,sp,-32
    80001b2e:	ec06                	sd	ra,24(sp)
    80001b30:	e822                	sd	s0,16(sp)
    80001b32:	e426                	sd	s1,8(sp)
    80001b34:	1000                	addi	s0,sp,32
    80001b36:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b38:	a1eff0ef          	jal	80000d56 <myproc>
  switch (n) {
    80001b3c:	4795                	li	a5,5
    80001b3e:	0497e163          	bltu	a5,s1,80001b80 <argraw+0x54>
    80001b42:	048a                	slli	s1,s1,0x2
    80001b44:	00006717          	auipc	a4,0x6
    80001b48:	db470713          	addi	a4,a4,-588 # 800078f8 <states.0+0x30>
    80001b4c:	94ba                	add	s1,s1,a4
    80001b4e:	409c                	lw	a5,0(s1)
    80001b50:	97ba                	add	a5,a5,a4
    80001b52:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001b54:	6d3c                	ld	a5,88(a0)
    80001b56:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001b58:	60e2                	ld	ra,24(sp)
    80001b5a:	6442                	ld	s0,16(sp)
    80001b5c:	64a2                	ld	s1,8(sp)
    80001b5e:	6105                	addi	sp,sp,32
    80001b60:	8082                	ret
    return p->trapframe->a1;
    80001b62:	6d3c                	ld	a5,88(a0)
    80001b64:	7fa8                	ld	a0,120(a5)
    80001b66:	bfcd                	j	80001b58 <argraw+0x2c>
    return p->trapframe->a2;
    80001b68:	6d3c                	ld	a5,88(a0)
    80001b6a:	63c8                	ld	a0,128(a5)
    80001b6c:	b7f5                	j	80001b58 <argraw+0x2c>
    return p->trapframe->a3;
    80001b6e:	6d3c                	ld	a5,88(a0)
    80001b70:	67c8                	ld	a0,136(a5)
    80001b72:	b7dd                	j	80001b58 <argraw+0x2c>
    return p->trapframe->a4;
    80001b74:	6d3c                	ld	a5,88(a0)
    80001b76:	6bc8                	ld	a0,144(a5)
    80001b78:	b7c5                	j	80001b58 <argraw+0x2c>
    return p->trapframe->a5;
    80001b7a:	6d3c                	ld	a5,88(a0)
    80001b7c:	6fc8                	ld	a0,152(a5)
    80001b7e:	bfe9                	j	80001b58 <argraw+0x2c>
  panic("argraw");
    80001b80:	00006517          	auipc	a0,0x6
    80001b84:	83850513          	addi	a0,a0,-1992 # 800073b8 <etext+0x3b8>
    80001b88:	38b030ef          	jal	80005712 <panic>

0000000080001b8c <fetchaddr>:
{
    80001b8c:	1101                	addi	sp,sp,-32
    80001b8e:	ec06                	sd	ra,24(sp)
    80001b90:	e822                	sd	s0,16(sp)
    80001b92:	e426                	sd	s1,8(sp)
    80001b94:	e04a                	sd	s2,0(sp)
    80001b96:	1000                	addi	s0,sp,32
    80001b98:	84aa                	mv	s1,a0
    80001b9a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001b9c:	9baff0ef          	jal	80000d56 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ba0:	653c                	ld	a5,72(a0)
    80001ba2:	02f4f663          	bgeu	s1,a5,80001bce <fetchaddr+0x42>
    80001ba6:	00848713          	addi	a4,s1,8
    80001baa:	02e7e463          	bltu	a5,a4,80001bd2 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001bae:	46a1                	li	a3,8
    80001bb0:	8626                	mv	a2,s1
    80001bb2:	85ca                	mv	a1,s2
    80001bb4:	6928                	ld	a0,80(a0)
    80001bb6:	ee9fe0ef          	jal	80000a9e <copyin>
    80001bba:	00a03533          	snez	a0,a0
    80001bbe:	40a00533          	neg	a0,a0
}
    80001bc2:	60e2                	ld	ra,24(sp)
    80001bc4:	6442                	ld	s0,16(sp)
    80001bc6:	64a2                	ld	s1,8(sp)
    80001bc8:	6902                	ld	s2,0(sp)
    80001bca:	6105                	addi	sp,sp,32
    80001bcc:	8082                	ret
    return -1;
    80001bce:	557d                	li	a0,-1
    80001bd0:	bfcd                	j	80001bc2 <fetchaddr+0x36>
    80001bd2:	557d                	li	a0,-1
    80001bd4:	b7fd                	j	80001bc2 <fetchaddr+0x36>

0000000080001bd6 <fetchstr>:
{
    80001bd6:	7179                	addi	sp,sp,-48
    80001bd8:	f406                	sd	ra,40(sp)
    80001bda:	f022                	sd	s0,32(sp)
    80001bdc:	ec26                	sd	s1,24(sp)
    80001bde:	e84a                	sd	s2,16(sp)
    80001be0:	e44e                	sd	s3,8(sp)
    80001be2:	1800                	addi	s0,sp,48
    80001be4:	892a                	mv	s2,a0
    80001be6:	84ae                	mv	s1,a1
    80001be8:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001bea:	96cff0ef          	jal	80000d56 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001bee:	86ce                	mv	a3,s3
    80001bf0:	864a                	mv	a2,s2
    80001bf2:	85a6                	mv	a1,s1
    80001bf4:	6928                	ld	a0,80(a0)
    80001bf6:	f2ffe0ef          	jal	80000b24 <copyinstr>
    80001bfa:	00054c63          	bltz	a0,80001c12 <fetchstr+0x3c>
  return strlen(buf);
    80001bfe:	8526                	mv	a0,s1
    80001c00:	ea4fe0ef          	jal	800002a4 <strlen>
}
    80001c04:	70a2                	ld	ra,40(sp)
    80001c06:	7402                	ld	s0,32(sp)
    80001c08:	64e2                	ld	s1,24(sp)
    80001c0a:	6942                	ld	s2,16(sp)
    80001c0c:	69a2                	ld	s3,8(sp)
    80001c0e:	6145                	addi	sp,sp,48
    80001c10:	8082                	ret
    return -1;
    80001c12:	557d                	li	a0,-1
    80001c14:	bfc5                	j	80001c04 <fetchstr+0x2e>

0000000080001c16 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c16:	1101                	addi	sp,sp,-32
    80001c18:	ec06                	sd	ra,24(sp)
    80001c1a:	e822                	sd	s0,16(sp)
    80001c1c:	e426                	sd	s1,8(sp)
    80001c1e:	1000                	addi	s0,sp,32
    80001c20:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c22:	f0bff0ef          	jal	80001b2c <argraw>
    80001c26:	c088                	sw	a0,0(s1)
}
    80001c28:	60e2                	ld	ra,24(sp)
    80001c2a:	6442                	ld	s0,16(sp)
    80001c2c:	64a2                	ld	s1,8(sp)
    80001c2e:	6105                	addi	sp,sp,32
    80001c30:	8082                	ret

0000000080001c32 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001c32:	1101                	addi	sp,sp,-32
    80001c34:	ec06                	sd	ra,24(sp)
    80001c36:	e822                	sd	s0,16(sp)
    80001c38:	e426                	sd	s1,8(sp)
    80001c3a:	1000                	addi	s0,sp,32
    80001c3c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c3e:	eefff0ef          	jal	80001b2c <argraw>
    80001c42:	e088                	sd	a0,0(s1)
}
    80001c44:	60e2                	ld	ra,24(sp)
    80001c46:	6442                	ld	s0,16(sp)
    80001c48:	64a2                	ld	s1,8(sp)
    80001c4a:	6105                	addi	sp,sp,32
    80001c4c:	8082                	ret

0000000080001c4e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001c4e:	7179                	addi	sp,sp,-48
    80001c50:	f406                	sd	ra,40(sp)
    80001c52:	f022                	sd	s0,32(sp)
    80001c54:	ec26                	sd	s1,24(sp)
    80001c56:	e84a                	sd	s2,16(sp)
    80001c58:	1800                	addi	s0,sp,48
    80001c5a:	84ae                	mv	s1,a1
    80001c5c:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001c5e:	fd840593          	addi	a1,s0,-40
    80001c62:	fd1ff0ef          	jal	80001c32 <argaddr>
  return fetchstr(addr, buf, max);
    80001c66:	864a                	mv	a2,s2
    80001c68:	85a6                	mv	a1,s1
    80001c6a:	fd843503          	ld	a0,-40(s0)
    80001c6e:	f69ff0ef          	jal	80001bd6 <fetchstr>
}
    80001c72:	70a2                	ld	ra,40(sp)
    80001c74:	7402                	ld	s0,32(sp)
    80001c76:	64e2                	ld	s1,24(sp)
    80001c78:	6942                	ld	s2,16(sp)
    80001c7a:	6145                	addi	sp,sp,48
    80001c7c:	8082                	ret

0000000080001c7e <syscall>:
*/

////////////////[New sys call  the "coooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooler one" ]////////////////////////////////////////////
// System call dispatcher with statistics
void syscall(void)
{
    80001c7e:	7179                	addi	sp,sp,-48
    80001c80:	f406                	sd	ra,40(sp)
    80001c82:	f022                	sd	s0,32(sp)
    80001c84:	ec26                	sd	s1,24(sp)
    80001c86:	e84a                	sd	s2,16(sp)
    80001c88:	e44e                	sd	s3,8(sp)
    80001c8a:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001c8c:	8caff0ef          	jal	80000d56 <myproc>
    80001c90:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001c92:	05853983          	ld	s3,88(a0)
    80001c96:	0a89b783          	ld	a5,168(s3)
    80001c9a:	0007891b          	sext.w	s2,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001c9e:	37fd                	addiw	a5,a5,-1
    80001ca0:	03300713          	li	a4,51
    80001ca4:	06f76063          	bltu	a4,a5,80001d04 <syscall+0x86>
    80001ca8:	00391713          	slli	a4,s2,0x3
    80001cac:	00006797          	auipc	a5,0x6
    80001cb0:	c6478793          	addi	a5,a5,-924 # 80007910 <syscalls>
    80001cb4:	97ba                	add	a5,a5,a4
    80001cb6:	639c                	ld	a5,0(a5)
    80001cb8:	c7b1                	beqz	a5,80001d04 <syscall+0x86>
    // Save the system call number
    p->trapframe->a0 = syscalls[num]();
    80001cba:	9782                	jalr	a5
    80001cbc:	06a9b823          	sd	a0,112(s3)
    
    // Increment the count for this system call
    syscall_counts[num]++;
    80001cc0:	00391713          	slli	a4,s2,0x3
    80001cc4:	0000f797          	auipc	a5,0xf
    80001cc8:	ad478793          	addi	a5,a5,-1324 # 80010798 <syscall_counts>
    80001ccc:	97ba                	add	a5,a5,a4
    80001cce:	6398                	ld	a4,0(a5)
    80001cd0:	0705                	addi	a4,a4,1
    80001cd2:	e398                	sd	a4,0(a5)
    
    // If process is being traced and the mask includes this syscall
    if(p->trace_mask & (1 << num)) {
    80001cd4:	1684a783          	lw	a5,360(s1)
    80001cd8:	4127d7bb          	sraw	a5,a5,s2
    80001cdc:	8b85                	andi	a5,a5,1
    80001cde:	c3a1                	beqz	a5,80001d1e <syscall+0xa0>
      printf("%d: syscall %s -> %ld\n", p->pid, syscall_names[num], p->trapframe->a0);
    80001ce0:	6cb8                	ld	a4,88(s1)
    80001ce2:	090e                	slli	s2,s2,0x3
    80001ce4:	00006797          	auipc	a5,0x6
    80001ce8:	c2c78793          	addi	a5,a5,-980 # 80007910 <syscalls>
    80001cec:	97ca                	add	a5,a5,s2
    80001cee:	7b34                	ld	a3,112(a4)
    80001cf0:	1a87b603          	ld	a2,424(a5)
    80001cf4:	588c                	lw	a1,48(s1)
    80001cf6:	00005517          	auipc	a0,0x5
    80001cfa:	6ca50513          	addi	a0,a0,1738 # 800073c0 <etext+0x3c0>
    80001cfe:	742030ef          	jal	80005440 <printf>
    80001d02:	a831                	j	80001d1e <syscall+0xa0>
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001d04:	86ca                	mv	a3,s2
    80001d06:	15848613          	addi	a2,s1,344
    80001d0a:	588c                	lw	a1,48(s1)
    80001d0c:	00005517          	auipc	a0,0x5
    80001d10:	6cc50513          	addi	a0,a0,1740 # 800073d8 <etext+0x3d8>
    80001d14:	72c030ef          	jal	80005440 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d18:	6cbc                	ld	a5,88(s1)
    80001d1a:	577d                	li	a4,-1
    80001d1c:	fbb8                	sd	a4,112(a5)
  }
}
    80001d1e:	70a2                	ld	ra,40(sp)
    80001d20:	7402                	ld	s0,32(sp)
    80001d22:	64e2                	ld	s1,24(sp)
    80001d24:	6942                	ld	s2,16(sp)
    80001d26:	69a2                	ld	s3,8(sp)
    80001d28:	6145                	addi	sp,sp,48
    80001d2a:	8082                	ret

0000000080001d2c <read_string>:


///////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
// Read null-terminated string from user space
int read_string(struct proc *p, uint64 addr, char *buf, int max) {
    80001d2c:	715d                	addi	sp,sp,-80
    80001d2e:	e486                	sd	ra,72(sp)
    80001d30:	e0a2                	sd	s0,64(sp)
    80001d32:	f84a                	sd	s2,48(sp)
    80001d34:	0880                	addi	s0,sp,80
  
  if(addr >= p->sz)
    80001d36:	653c                	ld	a5,72(a0)
    80001d38:	08f5f563          	bgeu	a1,a5,80001dc2 <read_string+0x96>
    80001d3c:	f052                	sd	s4,32(sp)
    80001d3e:	ec56                	sd	s5,24(sp)
    80001d40:	e45e                	sd	s7,8(sp)
    80001d42:	8aaa                	mv	s5,a0
    80001d44:	8bb2                	mv	s7,a2
    80001d46:	8a36                	mv	s4,a3
  {
    return -1; }
  int n = 0;
  while(n < max) {
    80001d48:	06d05763          	blez	a3,80001db6 <read_string+0x8a>
    80001d4c:	fc26                	sd	s1,56(sp)
    80001d4e:	f44e                	sd	s3,40(sp)
    80001d50:	e85a                	sd	s6,16(sp)
    80001d52:	84b2                	mv	s1,a2
  int n = 0;
    80001d54:	4901                	li	s2,0
    if(copyin(p->pagetable, buf + n, addr + n, 1) == -1) {
    80001d56:	40c589b3          	sub	s3,a1,a2
    80001d5a:	5b7d                	li	s6,-1
    80001d5c:	4685                	li	a3,1
    80001d5e:	00998633          	add	a2,s3,s1
    80001d62:	85a6                	mv	a1,s1
    80001d64:	050ab503          	ld	a0,80(s5)
    80001d68:	d37fe0ef          	jal	80000a9e <copyin>
    80001d6c:	03650463          	beq	a0,s6,80001d94 <read_string+0x68>
      break;
    }
    if(buf[n] == '\0'){
    80001d70:	0004c783          	lbu	a5,0(s1)
    80001d74:	c385                	beqz	a5,80001d94 <read_string+0x68>
      break;
    }
    n++;
    80001d76:	2905                	addiw	s2,s2,1
  while(n < max) {
    80001d78:	0485                	addi	s1,s1,1
    80001d7a:	ff2a11e3          	bne	s4,s2,80001d5c <read_string+0x30>
    80001d7e:	8952                	mv	s2,s4
    80001d80:	74e2                	ld	s1,56(sp)
    80001d82:	79a2                	ld	s3,40(sp)
    80001d84:	6b42                	ld	s6,16(sp)
  }
  if(n < max){
    buf[n] = '\0';
  } else {
    buf[max-1] = '\0';
    80001d86:	9bd2                	add	s7,s7,s4
    80001d88:	fe0b8fa3          	sb	zero,-1(s7)
    80001d8c:	7a02                	ld	s4,32(sp)
    80001d8e:	6ae2                	ld	s5,24(sp)
    80001d90:	6ba2                	ld	s7,8(sp)
    80001d92:	a821                	j	80001daa <read_string+0x7e>
  if(n < max){
    80001d94:	03495363          	bge	s2,s4,80001dba <read_string+0x8e>
    buf[n] = '\0';
    80001d98:	9bca                	add	s7,s7,s2
    80001d9a:	000b8023          	sb	zero,0(s7)
    80001d9e:	74e2                	ld	s1,56(sp)
    80001da0:	79a2                	ld	s3,40(sp)
    80001da2:	7a02                	ld	s4,32(sp)
    80001da4:	6ae2                	ld	s5,24(sp)
    80001da6:	6b42                	ld	s6,16(sp)
    80001da8:	6ba2                	ld	s7,8(sp)
  } 
  return n;
}
    80001daa:	854a                	mv	a0,s2
    80001dac:	60a6                	ld	ra,72(sp)
    80001dae:	6406                	ld	s0,64(sp)
    80001db0:	7942                	ld	s2,48(sp)
    80001db2:	6161                	addi	sp,sp,80
    80001db4:	8082                	ret
  int n = 0;
    80001db6:	4901                	li	s2,0
    80001db8:	b7f9                	j	80001d86 <read_string+0x5a>
    80001dba:	74e2                	ld	s1,56(sp)
    80001dbc:	79a2                	ld	s3,40(sp)
    80001dbe:	6b42                	ld	s6,16(sp)
    80001dc0:	b7d9                	j	80001d86 <read_string+0x5a>
    return -1; }
    80001dc2:	597d                	li	s2,-1
    80001dc4:	b7dd                	j	80001daa <read_string+0x7e>

0000000080001dc6 <read_memory>:

////////////////////////////////////////////////////////////////////////////////////////////////////
// Read arbitrary memory from user space
int read_memory(struct proc *p, uint64 addr, char *buf, int n) {
    80001dc6:	87ae                	mv	a5,a1

  if(addr >= p->sz || addr + n > p->sz)
    80001dc8:	6538                	ld	a4,72(a0)
    80001dca:	02e5fa63          	bgeu	a1,a4,80001dfe <read_memory+0x38>
int read_memory(struct proc *p, uint64 addr, char *buf, int n) {
    80001dce:	1101                	addi	sp,sp,-32
    80001dd0:	ec06                	sd	ra,24(sp)
    80001dd2:	e822                	sd	s0,16(sp)
    80001dd4:	e426                	sd	s1,8(sp)
    80001dd6:	1000                	addi	s0,sp,32
    80001dd8:	85b2                	mv	a1,a2
    80001dda:	84b6                	mv	s1,a3
  if(addr >= p->sz || addr + n > p->sz)
    80001ddc:	96be                	add	a3,a3,a5
    80001dde:	02d76263          	bltu	a4,a3,80001e02 <read_memory+0x3c>
    return -1;

  if(copyin(p->pagetable, buf, addr, n) == -1)
    80001de2:	86a6                	mv	a3,s1
    80001de4:	863e                	mv	a2,a5
    80001de6:	6928                	ld	a0,80(a0)
    80001de8:	cb7fe0ef          	jal	80000a9e <copyin>
    80001dec:	57fd                	li	a5,-1
    80001dee:	00f50363          	beq	a0,a5,80001df4 <read_memory+0x2e>
    return -1;

  return n;
    80001df2:	8526                	mv	a0,s1
}
    80001df4:	60e2                	ld	ra,24(sp)
    80001df6:	6442                	ld	s0,16(sp)
    80001df8:	64a2                	ld	s1,8(sp)
    80001dfa:	6105                	addi	sp,sp,32
    80001dfc:	8082                	ret
    return -1;
    80001dfe:	557d                	li	a0,-1
}
    80001e00:	8082                	ret
    return -1;
    80001e02:	557d                	li	a0,-1
    80001e04:	bfc5                	j	80001df4 <read_memory+0x2e>

0000000080001e06 <print_syscall>:

//////////////////////////////////////////////////////////////


// Print system call details (enhanced for open's mode)
void print_syscall(struct proc *p, int num, uint64 ret) {
    80001e06:	7159                	addi	sp,sp,-112
    80001e08:	f486                	sd	ra,104(sp)
    80001e0a:	f0a2                	sd	s0,96(sp)
    80001e0c:	eca6                	sd	s1,88(sp)
    80001e0e:	e8ca                	sd	s2,80(sp)
    80001e10:	e4ce                	sd	s3,72(sp)
    80001e12:	1880                	addi	s0,sp,112
    80001e14:	84aa                	mv	s1,a0
    80001e16:	892e                	mv	s2,a1
    80001e18:	89b2                	mv	s3,a2
    printf("%d: %s(", p->pid, syscall_names[num]);
    80001e1a:	00359713          	slli	a4,a1,0x3
    80001e1e:	00006797          	auipc	a5,0x6
    80001e22:	af278793          	addi	a5,a5,-1294 # 80007910 <syscalls>
    80001e26:	97ba                	add	a5,a5,a4
    80001e28:	1a87b603          	ld	a2,424(a5)
    80001e2c:	590c                	lw	a1,48(a0)
    80001e2e:	00005517          	auipc	a0,0x5
    80001e32:	5ca50513          	addi	a0,a0,1482 # 800073f8 <etext+0x3f8>
    80001e36:	60a030ef          	jal	80005440 <printf>
    switch (num) {
    80001e3a:	47bd                	li	a5,15
    80001e3c:	08f90063          	beq	s2,a5,80001ebc <print_syscall+0xb6>
    80001e40:	47c1                	li	a5,16
    80001e42:	0ef90963          	beq	s2,a5,80001f34 <print_syscall+0x12e>
    80001e46:	4795                	li	a5,5
    80001e48:	0af91663          	bne	s2,a5,80001ef4 <print_syscall+0xee>
        }
        printf(", %ld, 0%lo", p->trapframe->a1, p->trapframe->a2); // CHANGED: Added mode
        break;
    }
    case SYS_read: {
        printf("%ld, 0x%lx, %ld", p->trapframe->a0, p->trapframe->a1, p->trapframe->a2);
    80001e4c:	6cbc                	ld	a5,88(s1)
    80001e4e:	63d4                	ld	a3,128(a5)
    80001e50:	7fb0                	ld	a2,120(a5)
    80001e52:	7bac                	ld	a1,112(a5)
    80001e54:	00005517          	auipc	a0,0x5
    80001e58:	5cc50513          	addi	a0,a0,1484 # 80007420 <etext+0x420>
    80001e5c:	5e4030ef          	jal	80005440 <printf>
        if ((int)ret > 0 && (int)ret <= 32) {
    80001e60:	fff9879b          	addiw	a5,s3,-1
    80001e64:	477d                	li	a4,31
    80001e66:	08f76763          	bltu	a4,a5,80001ef4 <print_syscall+0xee>
            char buf[33];
            if (read_memory(p, p->trapframe->a1, buf, ret) >= 0) {
    80001e6a:	6cbc                	ld	a5,88(s1)
    80001e6c:	0009869b          	sext.w	a3,s3
    80001e70:	f9040613          	addi	a2,s0,-112
    80001e74:	7fac                	ld	a1,120(a5)
    80001e76:	8526                	mv	a0,s1
    80001e78:	f4fff0ef          	jal	80001dc6 <read_memory>
    80001e7c:	0a054363          	bltz	a0,80001f22 <print_syscall+0x11c>
                buf[ret] = '\0';
    80001e80:	fd098793          	addi	a5,s3,-48
    80001e84:	97a2                	add	a5,a5,s0
    80001e86:	fc078023          	sb	zero,-64(a5)
                int is_string = 1;
                for (int i = 0; i < ret; i++) {
    80001e8a:	f9040713          	addi	a4,s0,-112
    80001e8e:	00e98633          	add	a2,s3,a4
                    if (buf[i] < 32 || buf[i] > 126) {
    80001e92:	05e00693          	li	a3,94
    80001e96:	00074783          	lbu	a5,0(a4)
    80001e9a:	3781                	addiw	a5,a5,-32
    80001e9c:	0ff7f793          	zext.b	a5,a5
    80001ea0:	10f6ee63          	bltu	a3,a5,80001fbc <print_syscall+0x1b6>
                for (int i = 0; i < ret; i++) {
    80001ea4:	0705                	addi	a4,a4,1
    80001ea6:	fec718e3          	bne	a4,a2,80001e96 <print_syscall+0x90>
                        is_string = 0;
                        break;
                    }
                }
                if (is_string) printf(" → \"%s\"", buf);
    80001eaa:	f9040593          	addi	a1,s0,-112
    80001eae:	00005517          	auipc	a0,0x5
    80001eb2:	5ba50513          	addi	a0,a0,1466 # 80007468 <etext+0x468>
    80001eb6:	58a030ef          	jal	80005440 <printf>
    80001eba:	a82d                	j	80001ef4 <print_syscall+0xee>
        if (read_string(p, p->trapframe->a0, filename, sizeof(filename)) >= 0) {
    80001ebc:	6cbc                	ld	a5,88(s1)
    80001ebe:	04000693          	li	a3,64
    80001ec2:	f9040613          	addi	a2,s0,-112
    80001ec6:	7bac                	ld	a1,112(a5)
    80001ec8:	8526                	mv	a0,s1
    80001eca:	e63ff0ef          	jal	80001d2c <read_string>
    80001ece:	04054163          	bltz	a0,80001f10 <print_syscall+0x10a>
            printf("\"%s\"", filename);
    80001ed2:	f9040593          	addi	a1,s0,-112
    80001ed6:	00005517          	auipc	a0,0x5
    80001eda:	52a50513          	addi	a0,a0,1322 # 80007400 <etext+0x400>
    80001ede:	562030ef          	jal	80005440 <printf>
        printf(", %ld, 0%lo", p->trapframe->a1, p->trapframe->a2); // CHANGED: Added mode
    80001ee2:	6cbc                	ld	a5,88(s1)
    80001ee4:	63d0                	ld	a2,128(a5)
    80001ee6:	7fac                	ld	a1,120(a5)
    80001ee8:	00005517          	auipc	a0,0x5
    80001eec:	52850513          	addi	a0,a0,1320 # 80007410 <etext+0x410>
    80001ef0:	550030ef          	jal	80005440 <printf>
        break;
    }
    default:
        break;
    }
    printf(") = %ld\n", ret); // CHANGED: Aligned with strace format
    80001ef4:	85ce                	mv	a1,s3
    80001ef6:	00005517          	auipc	a0,0x5
    80001efa:	56250513          	addi	a0,a0,1378 # 80007458 <etext+0x458>
    80001efe:	542030ef          	jal	80005440 <printf>
}
    80001f02:	70a6                	ld	ra,104(sp)
    80001f04:	7406                	ld	s0,96(sp)
    80001f06:	64e6                	ld	s1,88(sp)
    80001f08:	6946                	ld	s2,80(sp)
    80001f0a:	69a6                	ld	s3,72(sp)
    80001f0c:	6165                	addi	sp,sp,112
    80001f0e:	8082                	ret
            printf("0x%lx", p->trapframe->a0);
    80001f10:	6cbc                	ld	a5,88(s1)
    80001f12:	7bac                	ld	a1,112(a5)
    80001f14:	00005517          	auipc	a0,0x5
    80001f18:	4f450513          	addi	a0,a0,1268 # 80007408 <etext+0x408>
    80001f1c:	524030ef          	jal	80005440 <printf>
    80001f20:	b7c9                	j	80001ee2 <print_syscall+0xdc>
                printf(" → 0x%lx", p->trapframe->a1); // CHANGED: Added fallback
    80001f22:	6cbc                	ld	a5,88(s1)
    80001f24:	7fac                	ld	a1,120(a5)
    80001f26:	00005517          	auipc	a0,0x5
    80001f2a:	50a50513          	addi	a0,a0,1290 # 80007430 <etext+0x430>
    80001f2e:	512030ef          	jal	80005440 <printf>
    80001f32:	b7c9                	j	80001ef4 <print_syscall+0xee>
        printf("%ld, ", p->trapframe->a0);
    80001f34:	6cbc                	ld	a5,88(s1)
    80001f36:	7bac                	ld	a1,112(a5)
    80001f38:	00005517          	auipc	a0,0x5
    80001f3c:	50850513          	addi	a0,a0,1288 # 80007440 <etext+0x440>
    80001f40:	500030ef          	jal	80005440 <printf>
        int n = p->trapframe->a2 > 32 ? 32 : p->trapframe->a2;
    80001f44:	6cbc                	ld	a5,88(s1)
    80001f46:	63d4                	ld	a3,128(a5)
    80001f48:	02000713          	li	a4,32
    80001f4c:	00d77463          	bgeu	a4,a3,80001f54 <print_syscall+0x14e>
    80001f50:	02000693          	li	a3,32
    80001f54:	0006891b          	sext.w	s2,a3
        if (read_memory(p, p->trapframe->a1, buf, n) >= 0) {
    80001f58:	86ca                	mv	a3,s2
    80001f5a:	f9040613          	addi	a2,s0,-112
    80001f5e:	7fac                	ld	a1,120(a5)
    80001f60:	8526                	mv	a0,s1
    80001f62:	e65ff0ef          	jal	80001dc6 <read_memory>
    80001f66:	02054a63          	bltz	a0,80001f9a <print_syscall+0x194>
            buf[n] = '\0';
    80001f6a:	fd090793          	addi	a5,s2,-48
    80001f6e:	97a2                	add	a5,a5,s0
    80001f70:	fc078023          	sb	zero,-64(a5)
            printf("\"%s\"", buf);
    80001f74:	f9040593          	addi	a1,s0,-112
    80001f78:	00005517          	auipc	a0,0x5
    80001f7c:	48850513          	addi	a0,a0,1160 # 80007400 <etext+0x400>
    80001f80:	4c0030ef          	jal	80005440 <printf>
            if (n < p->trapframe->a2) printf("...");
    80001f84:	6cbc                	ld	a5,88(s1)
    80001f86:	63dc                	ld	a5,128(a5)
    80001f88:	02f97163          	bgeu	s2,a5,80001faa <print_syscall+0x1a4>
    80001f8c:	00005517          	auipc	a0,0x5
    80001f90:	4bc50513          	addi	a0,a0,1212 # 80007448 <etext+0x448>
    80001f94:	4ac030ef          	jal	80005440 <printf>
    80001f98:	a809                	j	80001faa <print_syscall+0x1a4>
            printf("0x%lx", p->trapframe->a1);
    80001f9a:	6cbc                	ld	a5,88(s1)
    80001f9c:	7fac                	ld	a1,120(a5)
    80001f9e:	00005517          	auipc	a0,0x5
    80001fa2:	46a50513          	addi	a0,a0,1130 # 80007408 <etext+0x408>
    80001fa6:	49a030ef          	jal	80005440 <printf>
        printf(", %ld", p->trapframe->a2);
    80001faa:	6cbc                	ld	a5,88(s1)
    80001fac:	63cc                	ld	a1,128(a5)
    80001fae:	00005517          	auipc	a0,0x5
    80001fb2:	4a250513          	addi	a0,a0,1186 # 80007450 <etext+0x450>
    80001fb6:	48a030ef          	jal	80005440 <printf>
        break;
    80001fba:	bf2d                	j	80001ef4 <print_syscall+0xee>
                else printf(" → 0x%lx", p->trapframe->a1); // CHANGED: Added fallback
    80001fbc:	6cbc                	ld	a5,88(s1)
    80001fbe:	7fac                	ld	a1,120(a5)
    80001fc0:	00005517          	auipc	a0,0x5
    80001fc4:	47050513          	addi	a0,a0,1136 # 80007430 <etext+0x430>
    80001fc8:	478030ef          	jal	80005440 <printf>
    80001fcc:	b725                	j	80001ef4 <print_syscall+0xee>

0000000080001fce <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001fce:	1101                	addi	sp,sp,-32
    80001fd0:	ec06                	sd	ra,24(sp)
    80001fd2:	e822                	sd	s0,16(sp)
    80001fd4:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001fd6:	fec40593          	addi	a1,s0,-20
    80001fda:	4501                	li	a0,0
    80001fdc:	c3bff0ef          	jal	80001c16 <argint>
  exit(n);
    80001fe0:	fec42503          	lw	a0,-20(s0)
    80001fe4:	c58ff0ef          	jal	8000143c <exit>
  return 0;  // not reached
}
    80001fe8:	4501                	li	a0,0
    80001fea:	60e2                	ld	ra,24(sp)
    80001fec:	6442                	ld	s0,16(sp)
    80001fee:	6105                	addi	sp,sp,32
    80001ff0:	8082                	ret

0000000080001ff2 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001ff2:	1141                	addi	sp,sp,-16
    80001ff4:	e406                	sd	ra,8(sp)
    80001ff6:	e022                	sd	s0,0(sp)
    80001ff8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001ffa:	d5dfe0ef          	jal	80000d56 <myproc>
}
    80001ffe:	5908                	lw	a0,48(a0)
    80002000:	60a2                	ld	ra,8(sp)
    80002002:	6402                	ld	s0,0(sp)
    80002004:	0141                	addi	sp,sp,16
    80002006:	8082                	ret

0000000080002008 <sys_fork>:

uint64
sys_fork(void)
{
    80002008:	1141                	addi	sp,sp,-16
    8000200a:	e406                	sd	ra,8(sp)
    8000200c:	e022                	sd	s0,0(sp)
    8000200e:	0800                	addi	s0,sp,16
  return fork();
    80002010:	870ff0ef          	jal	80001080 <fork>
}
    80002014:	60a2                	ld	ra,8(sp)
    80002016:	6402                	ld	s0,0(sp)
    80002018:	0141                	addi	sp,sp,16
    8000201a:	8082                	ret

000000008000201c <sys_wait>:

uint64
sys_wait(void)
{
    8000201c:	1101                	addi	sp,sp,-32
    8000201e:	ec06                	sd	ra,24(sp)
    80002020:	e822                	sd	s0,16(sp)
    80002022:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002024:	fe840593          	addi	a1,s0,-24
    80002028:	4501                	li	a0,0
    8000202a:	c09ff0ef          	jal	80001c32 <argaddr>
  return wait(p);
    8000202e:	fe843503          	ld	a0,-24(s0)
    80002032:	d60ff0ef          	jal	80001592 <wait>
}
    80002036:	60e2                	ld	ra,24(sp)
    80002038:	6442                	ld	s0,16(sp)
    8000203a:	6105                	addi	sp,sp,32
    8000203c:	8082                	ret

000000008000203e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000203e:	7179                	addi	sp,sp,-48
    80002040:	f406                	sd	ra,40(sp)
    80002042:	f022                	sd	s0,32(sp)
    80002044:	ec26                	sd	s1,24(sp)
    80002046:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002048:	fdc40593          	addi	a1,s0,-36
    8000204c:	4501                	li	a0,0
    8000204e:	bc9ff0ef          	jal	80001c16 <argint>
  addr = myproc()->sz;
    80002052:	d05fe0ef          	jal	80000d56 <myproc>
    80002056:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002058:	fdc42503          	lw	a0,-36(s0)
    8000205c:	fd5fe0ef          	jal	80001030 <growproc>
    80002060:	00054863          	bltz	a0,80002070 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002064:	8526                	mv	a0,s1
    80002066:	70a2                	ld	ra,40(sp)
    80002068:	7402                	ld	s0,32(sp)
    8000206a:	64e2                	ld	s1,24(sp)
    8000206c:	6145                	addi	sp,sp,48
    8000206e:	8082                	ret
    return -1;
    80002070:	54fd                	li	s1,-1
    80002072:	bfcd                	j	80002064 <sys_sbrk+0x26>

0000000080002074 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002074:	7139                	addi	sp,sp,-64
    80002076:	fc06                	sd	ra,56(sp)
    80002078:	f822                	sd	s0,48(sp)
    8000207a:	f04a                	sd	s2,32(sp)
    8000207c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000207e:	fcc40593          	addi	a1,s0,-52
    80002082:	4501                	li	a0,0
    80002084:	b93ff0ef          	jal	80001c16 <argint>
  if(n < 0)
    80002088:	fcc42783          	lw	a5,-52(s0)
    8000208c:	0607c763          	bltz	a5,800020fa <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002090:	0000e517          	auipc	a0,0xe
    80002094:	6f050513          	addi	a0,a0,1776 # 80010780 <tickslock>
    80002098:	1a9030ef          	jal	80005a40 <acquire>
  ticks0 = ticks;
    8000209c:	00008917          	auipc	s2,0x8
    800020a0:	67c92903          	lw	s2,1660(s2) # 8000a718 <ticks>
  while(ticks - ticks0 < n){
    800020a4:	fcc42783          	lw	a5,-52(s0)
    800020a8:	cf8d                	beqz	a5,800020e2 <sys_sleep+0x6e>
    800020aa:	f426                	sd	s1,40(sp)
    800020ac:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800020ae:	0000e997          	auipc	s3,0xe
    800020b2:	6d298993          	addi	s3,s3,1746 # 80010780 <tickslock>
    800020b6:	00008497          	auipc	s1,0x8
    800020ba:	66248493          	addi	s1,s1,1634 # 8000a718 <ticks>
    if(killed(myproc())){
    800020be:	c99fe0ef          	jal	80000d56 <myproc>
    800020c2:	ca6ff0ef          	jal	80001568 <killed>
    800020c6:	ed0d                	bnez	a0,80002100 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    800020c8:	85ce                	mv	a1,s3
    800020ca:	8526                	mv	a0,s1
    800020cc:	a64ff0ef          	jal	80001330 <sleep>
  while(ticks - ticks0 < n){
    800020d0:	409c                	lw	a5,0(s1)
    800020d2:	412787bb          	subw	a5,a5,s2
    800020d6:	fcc42703          	lw	a4,-52(s0)
    800020da:	fee7e2e3          	bltu	a5,a4,800020be <sys_sleep+0x4a>
    800020de:	74a2                	ld	s1,40(sp)
    800020e0:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800020e2:	0000e517          	auipc	a0,0xe
    800020e6:	69e50513          	addi	a0,a0,1694 # 80010780 <tickslock>
    800020ea:	1ef030ef          	jal	80005ad8 <release>
  return 0;
    800020ee:	4501                	li	a0,0
}
    800020f0:	70e2                	ld	ra,56(sp)
    800020f2:	7442                	ld	s0,48(sp)
    800020f4:	7902                	ld	s2,32(sp)
    800020f6:	6121                	addi	sp,sp,64
    800020f8:	8082                	ret
    n = 0;
    800020fa:	fc042623          	sw	zero,-52(s0)
    800020fe:	bf49                	j	80002090 <sys_sleep+0x1c>
      release(&tickslock);
    80002100:	0000e517          	auipc	a0,0xe
    80002104:	68050513          	addi	a0,a0,1664 # 80010780 <tickslock>
    80002108:	1d1030ef          	jal	80005ad8 <release>
      return -1;
    8000210c:	557d                	li	a0,-1
    8000210e:	74a2                	ld	s1,40(sp)
    80002110:	69e2                	ld	s3,24(sp)
    80002112:	bff9                	j	800020f0 <sys_sleep+0x7c>

0000000080002114 <sys_kill>:

uint64
sys_kill(void)
{
    80002114:	1101                	addi	sp,sp,-32
    80002116:	ec06                	sd	ra,24(sp)
    80002118:	e822                	sd	s0,16(sp)
    8000211a:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000211c:	fec40593          	addi	a1,s0,-20
    80002120:	4501                	li	a0,0
    80002122:	af5ff0ef          	jal	80001c16 <argint>
  return kill(pid);
    80002126:	fec42503          	lw	a0,-20(s0)
    8000212a:	bb4ff0ef          	jal	800014de <kill>
}
    8000212e:	60e2                	ld	ra,24(sp)
    80002130:	6442                	ld	s0,16(sp)
    80002132:	6105                	addi	sp,sp,32
    80002134:	8082                	ret

0000000080002136 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002136:	1101                	addi	sp,sp,-32
    80002138:	ec06                	sd	ra,24(sp)
    8000213a:	e822                	sd	s0,16(sp)
    8000213c:	e426                	sd	s1,8(sp)
    8000213e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002140:	0000e517          	auipc	a0,0xe
    80002144:	64050513          	addi	a0,a0,1600 # 80010780 <tickslock>
    80002148:	0f9030ef          	jal	80005a40 <acquire>
  xticks = ticks;
    8000214c:	00008497          	auipc	s1,0x8
    80002150:	5cc4a483          	lw	s1,1484(s1) # 8000a718 <ticks>
  release(&tickslock);
    80002154:	0000e517          	auipc	a0,0xe
    80002158:	62c50513          	addi	a0,a0,1580 # 80010780 <tickslock>
    8000215c:	17d030ef          	jal	80005ad8 <release>
  return xticks;
}
    80002160:	02049513          	slli	a0,s1,0x20
    80002164:	9101                	srli	a0,a0,0x20
    80002166:	60e2                	ld	ra,24(sp)
    80002168:	6442                	ld	s0,16(sp)
    8000216a:	64a2                	ld	s1,8(sp)
    8000216c:	6105                	addi	sp,sp,32
    8000216e:	8082                	ret

0000000080002170 <sys_trace>:

extern uint64 syscall_counts[];
extern char *syscall_names[];


uint64 sys_trace(void){
    80002170:	1101                	addi	sp,sp,-32
    80002172:	ec06                	sd	ra,24(sp)
    80002174:	e822                	sd	s0,16(sp)
    80002176:	1000                	addi	s0,sp,32
  int mask;
  
  argint(0, &mask);
    80002178:	fec40593          	addi	a1,s0,-20
    8000217c:	4501                	li	a0,0
    8000217e:	a99ff0ef          	jal	80001c16 <argint>
  
  myproc()->trace_mask = mask;
    80002182:	bd5fe0ef          	jal	80000d56 <myproc>
    80002186:	fec42783          	lw	a5,-20(s0)
    8000218a:	16f52423          	sw	a5,360(a0)
  return 0;
}
    8000218e:	4501                	li	a0,0
    80002190:	60e2                	ld	ra,24(sp)
    80002192:	6442                	ld	s0,16(sp)
    80002194:	6105                	addi	sp,sp,32
    80002196:	8082                	ret

0000000080002198 <sys_stats>:


uint64 sys_stats(void) {
    80002198:	1141                	addi	sp,sp,-16
    8000219a:	e422                	sd	s0,8(sp)
    8000219c:	0800                	addi	s0,sp,16
  for(i = 1; i < SOL_SYSCALL; i++) {
    if(syscall_names[i])
      printf("%s: %d\n", syscall_names[i], (int) syscall_counts[i]);
  }
  return 0;
}
    8000219e:	4501                	li	a0,0
    800021a0:	6422                	ld	s0,8(sp)
    800021a2:	0141                	addi	sp,sp,16
    800021a4:	8082                	ret

00000000800021a6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800021a6:	7179                	addi	sp,sp,-48
    800021a8:	f406                	sd	ra,40(sp)
    800021aa:	f022                	sd	s0,32(sp)
    800021ac:	ec26                	sd	s1,24(sp)
    800021ae:	e84a                	sd	s2,16(sp)
    800021b0:	e44e                	sd	s3,8(sp)
    800021b2:	e052                	sd	s4,0(sp)
    800021b4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800021b6:	00005597          	auipc	a1,0x5
    800021ba:	37a58593          	addi	a1,a1,890 # 80007530 <etext+0x530>
    800021be:	0000e517          	auipc	a0,0xe
    800021c2:	7da50513          	addi	a0,a0,2010 # 80010998 <bcache>
    800021c6:	7fa030ef          	jal	800059c0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800021ca:	00016797          	auipc	a5,0x16
    800021ce:	7ce78793          	addi	a5,a5,1998 # 80018998 <bcache+0x8000>
    800021d2:	00017717          	auipc	a4,0x17
    800021d6:	a2e70713          	addi	a4,a4,-1490 # 80018c00 <bcache+0x8268>
    800021da:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800021de:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800021e2:	0000e497          	auipc	s1,0xe
    800021e6:	7ce48493          	addi	s1,s1,1998 # 800109b0 <bcache+0x18>
    b->next = bcache.head.next;
    800021ea:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800021ec:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800021ee:	00005a17          	auipc	s4,0x5
    800021f2:	34aa0a13          	addi	s4,s4,842 # 80007538 <etext+0x538>
    b->next = bcache.head.next;
    800021f6:	2b893783          	ld	a5,696(s2)
    800021fa:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800021fc:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002200:	85d2                	mv	a1,s4
    80002202:	01048513          	addi	a0,s1,16
    80002206:	248010ef          	jal	8000344e <initsleeplock>
    bcache.head.next->prev = b;
    8000220a:	2b893783          	ld	a5,696(s2)
    8000220e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002210:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002214:	45848493          	addi	s1,s1,1112
    80002218:	fd349fe3          	bne	s1,s3,800021f6 <binit+0x50>
  }
}
    8000221c:	70a2                	ld	ra,40(sp)
    8000221e:	7402                	ld	s0,32(sp)
    80002220:	64e2                	ld	s1,24(sp)
    80002222:	6942                	ld	s2,16(sp)
    80002224:	69a2                	ld	s3,8(sp)
    80002226:	6a02                	ld	s4,0(sp)
    80002228:	6145                	addi	sp,sp,48
    8000222a:	8082                	ret

000000008000222c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000222c:	7179                	addi	sp,sp,-48
    8000222e:	f406                	sd	ra,40(sp)
    80002230:	f022                	sd	s0,32(sp)
    80002232:	ec26                	sd	s1,24(sp)
    80002234:	e84a                	sd	s2,16(sp)
    80002236:	e44e                	sd	s3,8(sp)
    80002238:	1800                	addi	s0,sp,48
    8000223a:	892a                	mv	s2,a0
    8000223c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000223e:	0000e517          	auipc	a0,0xe
    80002242:	75a50513          	addi	a0,a0,1882 # 80010998 <bcache>
    80002246:	7fa030ef          	jal	80005a40 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000224a:	00017497          	auipc	s1,0x17
    8000224e:	a064b483          	ld	s1,-1530(s1) # 80018c50 <bcache+0x82b8>
    80002252:	00017797          	auipc	a5,0x17
    80002256:	9ae78793          	addi	a5,a5,-1618 # 80018c00 <bcache+0x8268>
    8000225a:	02f48b63          	beq	s1,a5,80002290 <bread+0x64>
    8000225e:	873e                	mv	a4,a5
    80002260:	a021                	j	80002268 <bread+0x3c>
    80002262:	68a4                	ld	s1,80(s1)
    80002264:	02e48663          	beq	s1,a4,80002290 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002268:	449c                	lw	a5,8(s1)
    8000226a:	ff279ce3          	bne	a5,s2,80002262 <bread+0x36>
    8000226e:	44dc                	lw	a5,12(s1)
    80002270:	ff3799e3          	bne	a5,s3,80002262 <bread+0x36>
      b->refcnt++;
    80002274:	40bc                	lw	a5,64(s1)
    80002276:	2785                	addiw	a5,a5,1
    80002278:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000227a:	0000e517          	auipc	a0,0xe
    8000227e:	71e50513          	addi	a0,a0,1822 # 80010998 <bcache>
    80002282:	057030ef          	jal	80005ad8 <release>
      acquiresleep(&b->lock);
    80002286:	01048513          	addi	a0,s1,16
    8000228a:	1fa010ef          	jal	80003484 <acquiresleep>
      return b;
    8000228e:	a889                	j	800022e0 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002290:	00017497          	auipc	s1,0x17
    80002294:	9b84b483          	ld	s1,-1608(s1) # 80018c48 <bcache+0x82b0>
    80002298:	00017797          	auipc	a5,0x17
    8000229c:	96878793          	addi	a5,a5,-1688 # 80018c00 <bcache+0x8268>
    800022a0:	00f48863          	beq	s1,a5,800022b0 <bread+0x84>
    800022a4:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800022a6:	40bc                	lw	a5,64(s1)
    800022a8:	cb91                	beqz	a5,800022bc <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022aa:	64a4                	ld	s1,72(s1)
    800022ac:	fee49de3          	bne	s1,a4,800022a6 <bread+0x7a>
  panic("bget: no buffers");
    800022b0:	00005517          	auipc	a0,0x5
    800022b4:	29050513          	addi	a0,a0,656 # 80007540 <etext+0x540>
    800022b8:	45a030ef          	jal	80005712 <panic>
      b->dev = dev;
    800022bc:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800022c0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800022c4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800022c8:	4785                	li	a5,1
    800022ca:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800022cc:	0000e517          	auipc	a0,0xe
    800022d0:	6cc50513          	addi	a0,a0,1740 # 80010998 <bcache>
    800022d4:	005030ef          	jal	80005ad8 <release>
      acquiresleep(&b->lock);
    800022d8:	01048513          	addi	a0,s1,16
    800022dc:	1a8010ef          	jal	80003484 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800022e0:	409c                	lw	a5,0(s1)
    800022e2:	cb89                	beqz	a5,800022f4 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800022e4:	8526                	mv	a0,s1
    800022e6:	70a2                	ld	ra,40(sp)
    800022e8:	7402                	ld	s0,32(sp)
    800022ea:	64e2                	ld	s1,24(sp)
    800022ec:	6942                	ld	s2,16(sp)
    800022ee:	69a2                	ld	s3,8(sp)
    800022f0:	6145                	addi	sp,sp,48
    800022f2:	8082                	ret
    virtio_disk_rw(b, 0);
    800022f4:	4581                	li	a1,0
    800022f6:	8526                	mv	a0,s1
    800022f8:	1e9020ef          	jal	80004ce0 <virtio_disk_rw>
    b->valid = 1;
    800022fc:	4785                	li	a5,1
    800022fe:	c09c                	sw	a5,0(s1)
  return b;
    80002300:	b7d5                	j	800022e4 <bread+0xb8>

0000000080002302 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002302:	1101                	addi	sp,sp,-32
    80002304:	ec06                	sd	ra,24(sp)
    80002306:	e822                	sd	s0,16(sp)
    80002308:	e426                	sd	s1,8(sp)
    8000230a:	1000                	addi	s0,sp,32
    8000230c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000230e:	0541                	addi	a0,a0,16
    80002310:	1f2010ef          	jal	80003502 <holdingsleep>
    80002314:	c911                	beqz	a0,80002328 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002316:	4585                	li	a1,1
    80002318:	8526                	mv	a0,s1
    8000231a:	1c7020ef          	jal	80004ce0 <virtio_disk_rw>
}
    8000231e:	60e2                	ld	ra,24(sp)
    80002320:	6442                	ld	s0,16(sp)
    80002322:	64a2                	ld	s1,8(sp)
    80002324:	6105                	addi	sp,sp,32
    80002326:	8082                	ret
    panic("bwrite");
    80002328:	00005517          	auipc	a0,0x5
    8000232c:	23050513          	addi	a0,a0,560 # 80007558 <etext+0x558>
    80002330:	3e2030ef          	jal	80005712 <panic>

0000000080002334 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002334:	1101                	addi	sp,sp,-32
    80002336:	ec06                	sd	ra,24(sp)
    80002338:	e822                	sd	s0,16(sp)
    8000233a:	e426                	sd	s1,8(sp)
    8000233c:	e04a                	sd	s2,0(sp)
    8000233e:	1000                	addi	s0,sp,32
    80002340:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002342:	01050913          	addi	s2,a0,16
    80002346:	854a                	mv	a0,s2
    80002348:	1ba010ef          	jal	80003502 <holdingsleep>
    8000234c:	c135                	beqz	a0,800023b0 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000234e:	854a                	mv	a0,s2
    80002350:	17a010ef          	jal	800034ca <releasesleep>

  acquire(&bcache.lock);
    80002354:	0000e517          	auipc	a0,0xe
    80002358:	64450513          	addi	a0,a0,1604 # 80010998 <bcache>
    8000235c:	6e4030ef          	jal	80005a40 <acquire>
  b->refcnt--;
    80002360:	40bc                	lw	a5,64(s1)
    80002362:	37fd                	addiw	a5,a5,-1
    80002364:	0007871b          	sext.w	a4,a5
    80002368:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000236a:	e71d                	bnez	a4,80002398 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000236c:	68b8                	ld	a4,80(s1)
    8000236e:	64bc                	ld	a5,72(s1)
    80002370:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002372:	68b8                	ld	a4,80(s1)
    80002374:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002376:	00016797          	auipc	a5,0x16
    8000237a:	62278793          	addi	a5,a5,1570 # 80018998 <bcache+0x8000>
    8000237e:	2b87b703          	ld	a4,696(a5)
    80002382:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002384:	00017717          	auipc	a4,0x17
    80002388:	87c70713          	addi	a4,a4,-1924 # 80018c00 <bcache+0x8268>
    8000238c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000238e:	2b87b703          	ld	a4,696(a5)
    80002392:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002394:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002398:	0000e517          	auipc	a0,0xe
    8000239c:	60050513          	addi	a0,a0,1536 # 80010998 <bcache>
    800023a0:	738030ef          	jal	80005ad8 <release>
}
    800023a4:	60e2                	ld	ra,24(sp)
    800023a6:	6442                	ld	s0,16(sp)
    800023a8:	64a2                	ld	s1,8(sp)
    800023aa:	6902                	ld	s2,0(sp)
    800023ac:	6105                	addi	sp,sp,32
    800023ae:	8082                	ret
    panic("brelse");
    800023b0:	00005517          	auipc	a0,0x5
    800023b4:	1b050513          	addi	a0,a0,432 # 80007560 <etext+0x560>
    800023b8:	35a030ef          	jal	80005712 <panic>

00000000800023bc <bpin>:

void
bpin(struct buf *b) {
    800023bc:	1101                	addi	sp,sp,-32
    800023be:	ec06                	sd	ra,24(sp)
    800023c0:	e822                	sd	s0,16(sp)
    800023c2:	e426                	sd	s1,8(sp)
    800023c4:	1000                	addi	s0,sp,32
    800023c6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800023c8:	0000e517          	auipc	a0,0xe
    800023cc:	5d050513          	addi	a0,a0,1488 # 80010998 <bcache>
    800023d0:	670030ef          	jal	80005a40 <acquire>
  b->refcnt++;
    800023d4:	40bc                	lw	a5,64(s1)
    800023d6:	2785                	addiw	a5,a5,1
    800023d8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800023da:	0000e517          	auipc	a0,0xe
    800023de:	5be50513          	addi	a0,a0,1470 # 80010998 <bcache>
    800023e2:	6f6030ef          	jal	80005ad8 <release>
}
    800023e6:	60e2                	ld	ra,24(sp)
    800023e8:	6442                	ld	s0,16(sp)
    800023ea:	64a2                	ld	s1,8(sp)
    800023ec:	6105                	addi	sp,sp,32
    800023ee:	8082                	ret

00000000800023f0 <bunpin>:

void
bunpin(struct buf *b) {
    800023f0:	1101                	addi	sp,sp,-32
    800023f2:	ec06                	sd	ra,24(sp)
    800023f4:	e822                	sd	s0,16(sp)
    800023f6:	e426                	sd	s1,8(sp)
    800023f8:	1000                	addi	s0,sp,32
    800023fa:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800023fc:	0000e517          	auipc	a0,0xe
    80002400:	59c50513          	addi	a0,a0,1436 # 80010998 <bcache>
    80002404:	63c030ef          	jal	80005a40 <acquire>
  b->refcnt--;
    80002408:	40bc                	lw	a5,64(s1)
    8000240a:	37fd                	addiw	a5,a5,-1
    8000240c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000240e:	0000e517          	auipc	a0,0xe
    80002412:	58a50513          	addi	a0,a0,1418 # 80010998 <bcache>
    80002416:	6c2030ef          	jal	80005ad8 <release>
}
    8000241a:	60e2                	ld	ra,24(sp)
    8000241c:	6442                	ld	s0,16(sp)
    8000241e:	64a2                	ld	s1,8(sp)
    80002420:	6105                	addi	sp,sp,32
    80002422:	8082                	ret

0000000080002424 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002424:	1101                	addi	sp,sp,-32
    80002426:	ec06                	sd	ra,24(sp)
    80002428:	e822                	sd	s0,16(sp)
    8000242a:	e426                	sd	s1,8(sp)
    8000242c:	e04a                	sd	s2,0(sp)
    8000242e:	1000                	addi	s0,sp,32
    80002430:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002432:	00d5d59b          	srliw	a1,a1,0xd
    80002436:	00017797          	auipc	a5,0x17
    8000243a:	c3e7a783          	lw	a5,-962(a5) # 80019074 <sb+0x1c>
    8000243e:	9dbd                	addw	a1,a1,a5
    80002440:	dedff0ef          	jal	8000222c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002444:	0074f713          	andi	a4,s1,7
    80002448:	4785                	li	a5,1
    8000244a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000244e:	14ce                	slli	s1,s1,0x33
    80002450:	90d9                	srli	s1,s1,0x36
    80002452:	00950733          	add	a4,a0,s1
    80002456:	05874703          	lbu	a4,88(a4)
    8000245a:	00e7f6b3          	and	a3,a5,a4
    8000245e:	c29d                	beqz	a3,80002484 <bfree+0x60>
    80002460:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002462:	94aa                	add	s1,s1,a0
    80002464:	fff7c793          	not	a5,a5
    80002468:	8f7d                	and	a4,a4,a5
    8000246a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000246e:	711000ef          	jal	8000337e <log_write>
  brelse(bp);
    80002472:	854a                	mv	a0,s2
    80002474:	ec1ff0ef          	jal	80002334 <brelse>
}
    80002478:	60e2                	ld	ra,24(sp)
    8000247a:	6442                	ld	s0,16(sp)
    8000247c:	64a2                	ld	s1,8(sp)
    8000247e:	6902                	ld	s2,0(sp)
    80002480:	6105                	addi	sp,sp,32
    80002482:	8082                	ret
    panic("freeing free block");
    80002484:	00005517          	auipc	a0,0x5
    80002488:	0e450513          	addi	a0,a0,228 # 80007568 <etext+0x568>
    8000248c:	286030ef          	jal	80005712 <panic>

0000000080002490 <balloc>:
{
    80002490:	711d                	addi	sp,sp,-96
    80002492:	ec86                	sd	ra,88(sp)
    80002494:	e8a2                	sd	s0,80(sp)
    80002496:	e4a6                	sd	s1,72(sp)
    80002498:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000249a:	00017797          	auipc	a5,0x17
    8000249e:	bc27a783          	lw	a5,-1086(a5) # 8001905c <sb+0x4>
    800024a2:	0e078f63          	beqz	a5,800025a0 <balloc+0x110>
    800024a6:	e0ca                	sd	s2,64(sp)
    800024a8:	fc4e                	sd	s3,56(sp)
    800024aa:	f852                	sd	s4,48(sp)
    800024ac:	f456                	sd	s5,40(sp)
    800024ae:	f05a                	sd	s6,32(sp)
    800024b0:	ec5e                	sd	s7,24(sp)
    800024b2:	e862                	sd	s8,16(sp)
    800024b4:	e466                	sd	s9,8(sp)
    800024b6:	8baa                	mv	s7,a0
    800024b8:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800024ba:	00017b17          	auipc	s6,0x17
    800024be:	b9eb0b13          	addi	s6,s6,-1122 # 80019058 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800024c2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800024c4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800024c6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800024c8:	6c89                	lui	s9,0x2
    800024ca:	a0b5                	j	80002536 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800024cc:	97ca                	add	a5,a5,s2
    800024ce:	8e55                	or	a2,a2,a3
    800024d0:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800024d4:	854a                	mv	a0,s2
    800024d6:	6a9000ef          	jal	8000337e <log_write>
        brelse(bp);
    800024da:	854a                	mv	a0,s2
    800024dc:	e59ff0ef          	jal	80002334 <brelse>
  bp = bread(dev, bno);
    800024e0:	85a6                	mv	a1,s1
    800024e2:	855e                	mv	a0,s7
    800024e4:	d49ff0ef          	jal	8000222c <bread>
    800024e8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800024ea:	40000613          	li	a2,1024
    800024ee:	4581                	li	a1,0
    800024f0:	05850513          	addi	a0,a0,88
    800024f4:	c41fd0ef          	jal	80000134 <memset>
  log_write(bp);
    800024f8:	854a                	mv	a0,s2
    800024fa:	685000ef          	jal	8000337e <log_write>
  brelse(bp);
    800024fe:	854a                	mv	a0,s2
    80002500:	e35ff0ef          	jal	80002334 <brelse>
}
    80002504:	6906                	ld	s2,64(sp)
    80002506:	79e2                	ld	s3,56(sp)
    80002508:	7a42                	ld	s4,48(sp)
    8000250a:	7aa2                	ld	s5,40(sp)
    8000250c:	7b02                	ld	s6,32(sp)
    8000250e:	6be2                	ld	s7,24(sp)
    80002510:	6c42                	ld	s8,16(sp)
    80002512:	6ca2                	ld	s9,8(sp)
}
    80002514:	8526                	mv	a0,s1
    80002516:	60e6                	ld	ra,88(sp)
    80002518:	6446                	ld	s0,80(sp)
    8000251a:	64a6                	ld	s1,72(sp)
    8000251c:	6125                	addi	sp,sp,96
    8000251e:	8082                	ret
    brelse(bp);
    80002520:	854a                	mv	a0,s2
    80002522:	e13ff0ef          	jal	80002334 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002526:	015c87bb          	addw	a5,s9,s5
    8000252a:	00078a9b          	sext.w	s5,a5
    8000252e:	004b2703          	lw	a4,4(s6)
    80002532:	04eaff63          	bgeu	s5,a4,80002590 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002536:	41fad79b          	sraiw	a5,s5,0x1f
    8000253a:	0137d79b          	srliw	a5,a5,0x13
    8000253e:	015787bb          	addw	a5,a5,s5
    80002542:	40d7d79b          	sraiw	a5,a5,0xd
    80002546:	01cb2583          	lw	a1,28(s6)
    8000254a:	9dbd                	addw	a1,a1,a5
    8000254c:	855e                	mv	a0,s7
    8000254e:	cdfff0ef          	jal	8000222c <bread>
    80002552:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002554:	004b2503          	lw	a0,4(s6)
    80002558:	000a849b          	sext.w	s1,s5
    8000255c:	8762                	mv	a4,s8
    8000255e:	fca4f1e3          	bgeu	s1,a0,80002520 <balloc+0x90>
      m = 1 << (bi % 8);
    80002562:	00777693          	andi	a3,a4,7
    80002566:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000256a:	41f7579b          	sraiw	a5,a4,0x1f
    8000256e:	01d7d79b          	srliw	a5,a5,0x1d
    80002572:	9fb9                	addw	a5,a5,a4
    80002574:	4037d79b          	sraiw	a5,a5,0x3
    80002578:	00f90633          	add	a2,s2,a5
    8000257c:	05864603          	lbu	a2,88(a2)
    80002580:	00c6f5b3          	and	a1,a3,a2
    80002584:	d5a1                	beqz	a1,800024cc <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002586:	2705                	addiw	a4,a4,1
    80002588:	2485                	addiw	s1,s1,1
    8000258a:	fd471ae3          	bne	a4,s4,8000255e <balloc+0xce>
    8000258e:	bf49                	j	80002520 <balloc+0x90>
    80002590:	6906                	ld	s2,64(sp)
    80002592:	79e2                	ld	s3,56(sp)
    80002594:	7a42                	ld	s4,48(sp)
    80002596:	7aa2                	ld	s5,40(sp)
    80002598:	7b02                	ld	s6,32(sp)
    8000259a:	6be2                	ld	s7,24(sp)
    8000259c:	6c42                	ld	s8,16(sp)
    8000259e:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800025a0:	00005517          	auipc	a0,0x5
    800025a4:	fe050513          	addi	a0,a0,-32 # 80007580 <etext+0x580>
    800025a8:	699020ef          	jal	80005440 <printf>
  return 0;
    800025ac:	4481                	li	s1,0
    800025ae:	b79d                	j	80002514 <balloc+0x84>

00000000800025b0 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800025b0:	7179                	addi	sp,sp,-48
    800025b2:	f406                	sd	ra,40(sp)
    800025b4:	f022                	sd	s0,32(sp)
    800025b6:	ec26                	sd	s1,24(sp)
    800025b8:	e84a                	sd	s2,16(sp)
    800025ba:	e44e                	sd	s3,8(sp)
    800025bc:	1800                	addi	s0,sp,48
    800025be:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800025c0:	47ad                	li	a5,11
    800025c2:	02b7e663          	bltu	a5,a1,800025ee <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800025c6:	02059793          	slli	a5,a1,0x20
    800025ca:	01e7d593          	srli	a1,a5,0x1e
    800025ce:	00b504b3          	add	s1,a0,a1
    800025d2:	0504a903          	lw	s2,80(s1)
    800025d6:	06091a63          	bnez	s2,8000264a <bmap+0x9a>
      addr = balloc(ip->dev);
    800025da:	4108                	lw	a0,0(a0)
    800025dc:	eb5ff0ef          	jal	80002490 <balloc>
    800025e0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800025e4:	06090363          	beqz	s2,8000264a <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800025e8:	0524a823          	sw	s2,80(s1)
    800025ec:	a8b9                	j	8000264a <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800025ee:	ff45849b          	addiw	s1,a1,-12
    800025f2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800025f6:	0ff00793          	li	a5,255
    800025fa:	06e7ee63          	bltu	a5,a4,80002676 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800025fe:	08052903          	lw	s2,128(a0)
    80002602:	00091d63          	bnez	s2,8000261c <bmap+0x6c>
      addr = balloc(ip->dev);
    80002606:	4108                	lw	a0,0(a0)
    80002608:	e89ff0ef          	jal	80002490 <balloc>
    8000260c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002610:	02090d63          	beqz	s2,8000264a <bmap+0x9a>
    80002614:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002616:	0929a023          	sw	s2,128(s3)
    8000261a:	a011                	j	8000261e <bmap+0x6e>
    8000261c:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000261e:	85ca                	mv	a1,s2
    80002620:	0009a503          	lw	a0,0(s3)
    80002624:	c09ff0ef          	jal	8000222c <bread>
    80002628:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000262a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000262e:	02049713          	slli	a4,s1,0x20
    80002632:	01e75593          	srli	a1,a4,0x1e
    80002636:	00b784b3          	add	s1,a5,a1
    8000263a:	0004a903          	lw	s2,0(s1)
    8000263e:	00090e63          	beqz	s2,8000265a <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002642:	8552                	mv	a0,s4
    80002644:	cf1ff0ef          	jal	80002334 <brelse>
    return addr;
    80002648:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000264a:	854a                	mv	a0,s2
    8000264c:	70a2                	ld	ra,40(sp)
    8000264e:	7402                	ld	s0,32(sp)
    80002650:	64e2                	ld	s1,24(sp)
    80002652:	6942                	ld	s2,16(sp)
    80002654:	69a2                	ld	s3,8(sp)
    80002656:	6145                	addi	sp,sp,48
    80002658:	8082                	ret
      addr = balloc(ip->dev);
    8000265a:	0009a503          	lw	a0,0(s3)
    8000265e:	e33ff0ef          	jal	80002490 <balloc>
    80002662:	0005091b          	sext.w	s2,a0
      if(addr){
    80002666:	fc090ee3          	beqz	s2,80002642 <bmap+0x92>
        a[bn] = addr;
    8000266a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000266e:	8552                	mv	a0,s4
    80002670:	50f000ef          	jal	8000337e <log_write>
    80002674:	b7f9                	j	80002642 <bmap+0x92>
    80002676:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002678:	00005517          	auipc	a0,0x5
    8000267c:	f2050513          	addi	a0,a0,-224 # 80007598 <etext+0x598>
    80002680:	092030ef          	jal	80005712 <panic>

0000000080002684 <iget>:
{
    80002684:	7179                	addi	sp,sp,-48
    80002686:	f406                	sd	ra,40(sp)
    80002688:	f022                	sd	s0,32(sp)
    8000268a:	ec26                	sd	s1,24(sp)
    8000268c:	e84a                	sd	s2,16(sp)
    8000268e:	e44e                	sd	s3,8(sp)
    80002690:	e052                	sd	s4,0(sp)
    80002692:	1800                	addi	s0,sp,48
    80002694:	89aa                	mv	s3,a0
    80002696:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002698:	00017517          	auipc	a0,0x17
    8000269c:	9e050513          	addi	a0,a0,-1568 # 80019078 <itable>
    800026a0:	3a0030ef          	jal	80005a40 <acquire>
  empty = 0;
    800026a4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800026a6:	00017497          	auipc	s1,0x17
    800026aa:	9ea48493          	addi	s1,s1,-1558 # 80019090 <itable+0x18>
    800026ae:	00018697          	auipc	a3,0x18
    800026b2:	47268693          	addi	a3,a3,1138 # 8001ab20 <log>
    800026b6:	a039                	j	800026c4 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800026b8:	02090963          	beqz	s2,800026ea <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800026bc:	08848493          	addi	s1,s1,136
    800026c0:	02d48863          	beq	s1,a3,800026f0 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800026c4:	449c                	lw	a5,8(s1)
    800026c6:	fef059e3          	blez	a5,800026b8 <iget+0x34>
    800026ca:	4098                	lw	a4,0(s1)
    800026cc:	ff3716e3          	bne	a4,s3,800026b8 <iget+0x34>
    800026d0:	40d8                	lw	a4,4(s1)
    800026d2:	ff4713e3          	bne	a4,s4,800026b8 <iget+0x34>
      ip->ref++;
    800026d6:	2785                	addiw	a5,a5,1
    800026d8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800026da:	00017517          	auipc	a0,0x17
    800026de:	99e50513          	addi	a0,a0,-1634 # 80019078 <itable>
    800026e2:	3f6030ef          	jal	80005ad8 <release>
      return ip;
    800026e6:	8926                	mv	s2,s1
    800026e8:	a02d                	j	80002712 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800026ea:	fbe9                	bnez	a5,800026bc <iget+0x38>
      empty = ip;
    800026ec:	8926                	mv	s2,s1
    800026ee:	b7f9                	j	800026bc <iget+0x38>
  if(empty == 0)
    800026f0:	02090a63          	beqz	s2,80002724 <iget+0xa0>
  ip->dev = dev;
    800026f4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800026f8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800026fc:	4785                	li	a5,1
    800026fe:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002702:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002706:	00017517          	auipc	a0,0x17
    8000270a:	97250513          	addi	a0,a0,-1678 # 80019078 <itable>
    8000270e:	3ca030ef          	jal	80005ad8 <release>
}
    80002712:	854a                	mv	a0,s2
    80002714:	70a2                	ld	ra,40(sp)
    80002716:	7402                	ld	s0,32(sp)
    80002718:	64e2                	ld	s1,24(sp)
    8000271a:	6942                	ld	s2,16(sp)
    8000271c:	69a2                	ld	s3,8(sp)
    8000271e:	6a02                	ld	s4,0(sp)
    80002720:	6145                	addi	sp,sp,48
    80002722:	8082                	ret
    panic("iget: no inodes");
    80002724:	00005517          	auipc	a0,0x5
    80002728:	e8c50513          	addi	a0,a0,-372 # 800075b0 <etext+0x5b0>
    8000272c:	7e7020ef          	jal	80005712 <panic>

0000000080002730 <fsinit>:
fsinit(int dev) {
    80002730:	7179                	addi	sp,sp,-48
    80002732:	f406                	sd	ra,40(sp)
    80002734:	f022                	sd	s0,32(sp)
    80002736:	ec26                	sd	s1,24(sp)
    80002738:	e84a                	sd	s2,16(sp)
    8000273a:	e44e                	sd	s3,8(sp)
    8000273c:	1800                	addi	s0,sp,48
    8000273e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002740:	4585                	li	a1,1
    80002742:	aebff0ef          	jal	8000222c <bread>
    80002746:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002748:	00017997          	auipc	s3,0x17
    8000274c:	91098993          	addi	s3,s3,-1776 # 80019058 <sb>
    80002750:	02000613          	li	a2,32
    80002754:	05850593          	addi	a1,a0,88
    80002758:	854e                	mv	a0,s3
    8000275a:	a37fd0ef          	jal	80000190 <memmove>
  brelse(bp);
    8000275e:	8526                	mv	a0,s1
    80002760:	bd5ff0ef          	jal	80002334 <brelse>
  if(sb.magic != FSMAGIC)
    80002764:	0009a703          	lw	a4,0(s3)
    80002768:	102037b7          	lui	a5,0x10203
    8000276c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002770:	02f71063          	bne	a4,a5,80002790 <fsinit+0x60>
  initlog(dev, &sb);
    80002774:	00017597          	auipc	a1,0x17
    80002778:	8e458593          	addi	a1,a1,-1820 # 80019058 <sb>
    8000277c:	854a                	mv	a0,s2
    8000277e:	1f9000ef          	jal	80003176 <initlog>
}
    80002782:	70a2                	ld	ra,40(sp)
    80002784:	7402                	ld	s0,32(sp)
    80002786:	64e2                	ld	s1,24(sp)
    80002788:	6942                	ld	s2,16(sp)
    8000278a:	69a2                	ld	s3,8(sp)
    8000278c:	6145                	addi	sp,sp,48
    8000278e:	8082                	ret
    panic("invalid file system");
    80002790:	00005517          	auipc	a0,0x5
    80002794:	e3050513          	addi	a0,a0,-464 # 800075c0 <etext+0x5c0>
    80002798:	77b020ef          	jal	80005712 <panic>

000000008000279c <iinit>:
{
    8000279c:	7179                	addi	sp,sp,-48
    8000279e:	f406                	sd	ra,40(sp)
    800027a0:	f022                	sd	s0,32(sp)
    800027a2:	ec26                	sd	s1,24(sp)
    800027a4:	e84a                	sd	s2,16(sp)
    800027a6:	e44e                	sd	s3,8(sp)
    800027a8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800027aa:	00005597          	auipc	a1,0x5
    800027ae:	e2e58593          	addi	a1,a1,-466 # 800075d8 <etext+0x5d8>
    800027b2:	00017517          	auipc	a0,0x17
    800027b6:	8c650513          	addi	a0,a0,-1850 # 80019078 <itable>
    800027ba:	206030ef          	jal	800059c0 <initlock>
  for(i = 0; i < NINODE; i++) {
    800027be:	00017497          	auipc	s1,0x17
    800027c2:	8e248493          	addi	s1,s1,-1822 # 800190a0 <itable+0x28>
    800027c6:	00018997          	auipc	s3,0x18
    800027ca:	36a98993          	addi	s3,s3,874 # 8001ab30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800027ce:	00005917          	auipc	s2,0x5
    800027d2:	e1290913          	addi	s2,s2,-494 # 800075e0 <etext+0x5e0>
    800027d6:	85ca                	mv	a1,s2
    800027d8:	8526                	mv	a0,s1
    800027da:	475000ef          	jal	8000344e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800027de:	08848493          	addi	s1,s1,136
    800027e2:	ff349ae3          	bne	s1,s3,800027d6 <iinit+0x3a>
}
    800027e6:	70a2                	ld	ra,40(sp)
    800027e8:	7402                	ld	s0,32(sp)
    800027ea:	64e2                	ld	s1,24(sp)
    800027ec:	6942                	ld	s2,16(sp)
    800027ee:	69a2                	ld	s3,8(sp)
    800027f0:	6145                	addi	sp,sp,48
    800027f2:	8082                	ret

00000000800027f4 <ialloc>:
{
    800027f4:	7139                	addi	sp,sp,-64
    800027f6:	fc06                	sd	ra,56(sp)
    800027f8:	f822                	sd	s0,48(sp)
    800027fa:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800027fc:	00017717          	auipc	a4,0x17
    80002800:	86872703          	lw	a4,-1944(a4) # 80019064 <sb+0xc>
    80002804:	4785                	li	a5,1
    80002806:	06e7f063          	bgeu	a5,a4,80002866 <ialloc+0x72>
    8000280a:	f426                	sd	s1,40(sp)
    8000280c:	f04a                	sd	s2,32(sp)
    8000280e:	ec4e                	sd	s3,24(sp)
    80002810:	e852                	sd	s4,16(sp)
    80002812:	e456                	sd	s5,8(sp)
    80002814:	e05a                	sd	s6,0(sp)
    80002816:	8aaa                	mv	s5,a0
    80002818:	8b2e                	mv	s6,a1
    8000281a:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000281c:	00017a17          	auipc	s4,0x17
    80002820:	83ca0a13          	addi	s4,s4,-1988 # 80019058 <sb>
    80002824:	00495593          	srli	a1,s2,0x4
    80002828:	018a2783          	lw	a5,24(s4)
    8000282c:	9dbd                	addw	a1,a1,a5
    8000282e:	8556                	mv	a0,s5
    80002830:	9fdff0ef          	jal	8000222c <bread>
    80002834:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002836:	05850993          	addi	s3,a0,88
    8000283a:	00f97793          	andi	a5,s2,15
    8000283e:	079a                	slli	a5,a5,0x6
    80002840:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002842:	00099783          	lh	a5,0(s3)
    80002846:	cb9d                	beqz	a5,8000287c <ialloc+0x88>
    brelse(bp);
    80002848:	aedff0ef          	jal	80002334 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000284c:	0905                	addi	s2,s2,1
    8000284e:	00ca2703          	lw	a4,12(s4)
    80002852:	0009079b          	sext.w	a5,s2
    80002856:	fce7e7e3          	bltu	a5,a4,80002824 <ialloc+0x30>
    8000285a:	74a2                	ld	s1,40(sp)
    8000285c:	7902                	ld	s2,32(sp)
    8000285e:	69e2                	ld	s3,24(sp)
    80002860:	6a42                	ld	s4,16(sp)
    80002862:	6aa2                	ld	s5,8(sp)
    80002864:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002866:	00005517          	auipc	a0,0x5
    8000286a:	d8250513          	addi	a0,a0,-638 # 800075e8 <etext+0x5e8>
    8000286e:	3d3020ef          	jal	80005440 <printf>
  return 0;
    80002872:	4501                	li	a0,0
}
    80002874:	70e2                	ld	ra,56(sp)
    80002876:	7442                	ld	s0,48(sp)
    80002878:	6121                	addi	sp,sp,64
    8000287a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000287c:	04000613          	li	a2,64
    80002880:	4581                	li	a1,0
    80002882:	854e                	mv	a0,s3
    80002884:	8b1fd0ef          	jal	80000134 <memset>
      dip->type = type;
    80002888:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000288c:	8526                	mv	a0,s1
    8000288e:	2f1000ef          	jal	8000337e <log_write>
      brelse(bp);
    80002892:	8526                	mv	a0,s1
    80002894:	aa1ff0ef          	jal	80002334 <brelse>
      return iget(dev, inum);
    80002898:	0009059b          	sext.w	a1,s2
    8000289c:	8556                	mv	a0,s5
    8000289e:	de7ff0ef          	jal	80002684 <iget>
    800028a2:	74a2                	ld	s1,40(sp)
    800028a4:	7902                	ld	s2,32(sp)
    800028a6:	69e2                	ld	s3,24(sp)
    800028a8:	6a42                	ld	s4,16(sp)
    800028aa:	6aa2                	ld	s5,8(sp)
    800028ac:	6b02                	ld	s6,0(sp)
    800028ae:	b7d9                	j	80002874 <ialloc+0x80>

00000000800028b0 <iupdate>:
{
    800028b0:	1101                	addi	sp,sp,-32
    800028b2:	ec06                	sd	ra,24(sp)
    800028b4:	e822                	sd	s0,16(sp)
    800028b6:	e426                	sd	s1,8(sp)
    800028b8:	e04a                	sd	s2,0(sp)
    800028ba:	1000                	addi	s0,sp,32
    800028bc:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800028be:	415c                	lw	a5,4(a0)
    800028c0:	0047d79b          	srliw	a5,a5,0x4
    800028c4:	00016597          	auipc	a1,0x16
    800028c8:	7ac5a583          	lw	a1,1964(a1) # 80019070 <sb+0x18>
    800028cc:	9dbd                	addw	a1,a1,a5
    800028ce:	4108                	lw	a0,0(a0)
    800028d0:	95dff0ef          	jal	8000222c <bread>
    800028d4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800028d6:	05850793          	addi	a5,a0,88
    800028da:	40d8                	lw	a4,4(s1)
    800028dc:	8b3d                	andi	a4,a4,15
    800028de:	071a                	slli	a4,a4,0x6
    800028e0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800028e2:	04449703          	lh	a4,68(s1)
    800028e6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800028ea:	04649703          	lh	a4,70(s1)
    800028ee:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800028f2:	04849703          	lh	a4,72(s1)
    800028f6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800028fa:	04a49703          	lh	a4,74(s1)
    800028fe:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002902:	44f8                	lw	a4,76(s1)
    80002904:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002906:	03400613          	li	a2,52
    8000290a:	05048593          	addi	a1,s1,80
    8000290e:	00c78513          	addi	a0,a5,12
    80002912:	87ffd0ef          	jal	80000190 <memmove>
  log_write(bp);
    80002916:	854a                	mv	a0,s2
    80002918:	267000ef          	jal	8000337e <log_write>
  brelse(bp);
    8000291c:	854a                	mv	a0,s2
    8000291e:	a17ff0ef          	jal	80002334 <brelse>
}
    80002922:	60e2                	ld	ra,24(sp)
    80002924:	6442                	ld	s0,16(sp)
    80002926:	64a2                	ld	s1,8(sp)
    80002928:	6902                	ld	s2,0(sp)
    8000292a:	6105                	addi	sp,sp,32
    8000292c:	8082                	ret

000000008000292e <idup>:
{
    8000292e:	1101                	addi	sp,sp,-32
    80002930:	ec06                	sd	ra,24(sp)
    80002932:	e822                	sd	s0,16(sp)
    80002934:	e426                	sd	s1,8(sp)
    80002936:	1000                	addi	s0,sp,32
    80002938:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000293a:	00016517          	auipc	a0,0x16
    8000293e:	73e50513          	addi	a0,a0,1854 # 80019078 <itable>
    80002942:	0fe030ef          	jal	80005a40 <acquire>
  ip->ref++;
    80002946:	449c                	lw	a5,8(s1)
    80002948:	2785                	addiw	a5,a5,1
    8000294a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000294c:	00016517          	auipc	a0,0x16
    80002950:	72c50513          	addi	a0,a0,1836 # 80019078 <itable>
    80002954:	184030ef          	jal	80005ad8 <release>
}
    80002958:	8526                	mv	a0,s1
    8000295a:	60e2                	ld	ra,24(sp)
    8000295c:	6442                	ld	s0,16(sp)
    8000295e:	64a2                	ld	s1,8(sp)
    80002960:	6105                	addi	sp,sp,32
    80002962:	8082                	ret

0000000080002964 <ilock>:
{
    80002964:	1101                	addi	sp,sp,-32
    80002966:	ec06                	sd	ra,24(sp)
    80002968:	e822                	sd	s0,16(sp)
    8000296a:	e426                	sd	s1,8(sp)
    8000296c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000296e:	cd19                	beqz	a0,8000298c <ilock+0x28>
    80002970:	84aa                	mv	s1,a0
    80002972:	451c                	lw	a5,8(a0)
    80002974:	00f05c63          	blez	a5,8000298c <ilock+0x28>
  acquiresleep(&ip->lock);
    80002978:	0541                	addi	a0,a0,16
    8000297a:	30b000ef          	jal	80003484 <acquiresleep>
  if(ip->valid == 0){
    8000297e:	40bc                	lw	a5,64(s1)
    80002980:	cf89                	beqz	a5,8000299a <ilock+0x36>
}
    80002982:	60e2                	ld	ra,24(sp)
    80002984:	6442                	ld	s0,16(sp)
    80002986:	64a2                	ld	s1,8(sp)
    80002988:	6105                	addi	sp,sp,32
    8000298a:	8082                	ret
    8000298c:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000298e:	00005517          	auipc	a0,0x5
    80002992:	c7250513          	addi	a0,a0,-910 # 80007600 <etext+0x600>
    80002996:	57d020ef          	jal	80005712 <panic>
    8000299a:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000299c:	40dc                	lw	a5,4(s1)
    8000299e:	0047d79b          	srliw	a5,a5,0x4
    800029a2:	00016597          	auipc	a1,0x16
    800029a6:	6ce5a583          	lw	a1,1742(a1) # 80019070 <sb+0x18>
    800029aa:	9dbd                	addw	a1,a1,a5
    800029ac:	4088                	lw	a0,0(s1)
    800029ae:	87fff0ef          	jal	8000222c <bread>
    800029b2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800029b4:	05850593          	addi	a1,a0,88
    800029b8:	40dc                	lw	a5,4(s1)
    800029ba:	8bbd                	andi	a5,a5,15
    800029bc:	079a                	slli	a5,a5,0x6
    800029be:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800029c0:	00059783          	lh	a5,0(a1)
    800029c4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800029c8:	00259783          	lh	a5,2(a1)
    800029cc:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800029d0:	00459783          	lh	a5,4(a1)
    800029d4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800029d8:	00659783          	lh	a5,6(a1)
    800029dc:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800029e0:	459c                	lw	a5,8(a1)
    800029e2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800029e4:	03400613          	li	a2,52
    800029e8:	05b1                	addi	a1,a1,12
    800029ea:	05048513          	addi	a0,s1,80
    800029ee:	fa2fd0ef          	jal	80000190 <memmove>
    brelse(bp);
    800029f2:	854a                	mv	a0,s2
    800029f4:	941ff0ef          	jal	80002334 <brelse>
    ip->valid = 1;
    800029f8:	4785                	li	a5,1
    800029fa:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800029fc:	04449783          	lh	a5,68(s1)
    80002a00:	c399                	beqz	a5,80002a06 <ilock+0xa2>
    80002a02:	6902                	ld	s2,0(sp)
    80002a04:	bfbd                	j	80002982 <ilock+0x1e>
      panic("ilock: no type");
    80002a06:	00005517          	auipc	a0,0x5
    80002a0a:	c0250513          	addi	a0,a0,-1022 # 80007608 <etext+0x608>
    80002a0e:	505020ef          	jal	80005712 <panic>

0000000080002a12 <iunlock>:
{
    80002a12:	1101                	addi	sp,sp,-32
    80002a14:	ec06                	sd	ra,24(sp)
    80002a16:	e822                	sd	s0,16(sp)
    80002a18:	e426                	sd	s1,8(sp)
    80002a1a:	e04a                	sd	s2,0(sp)
    80002a1c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002a1e:	c505                	beqz	a0,80002a46 <iunlock+0x34>
    80002a20:	84aa                	mv	s1,a0
    80002a22:	01050913          	addi	s2,a0,16
    80002a26:	854a                	mv	a0,s2
    80002a28:	2db000ef          	jal	80003502 <holdingsleep>
    80002a2c:	cd09                	beqz	a0,80002a46 <iunlock+0x34>
    80002a2e:	449c                	lw	a5,8(s1)
    80002a30:	00f05b63          	blez	a5,80002a46 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002a34:	854a                	mv	a0,s2
    80002a36:	295000ef          	jal	800034ca <releasesleep>
}
    80002a3a:	60e2                	ld	ra,24(sp)
    80002a3c:	6442                	ld	s0,16(sp)
    80002a3e:	64a2                	ld	s1,8(sp)
    80002a40:	6902                	ld	s2,0(sp)
    80002a42:	6105                	addi	sp,sp,32
    80002a44:	8082                	ret
    panic("iunlock");
    80002a46:	00005517          	auipc	a0,0x5
    80002a4a:	bd250513          	addi	a0,a0,-1070 # 80007618 <etext+0x618>
    80002a4e:	4c5020ef          	jal	80005712 <panic>

0000000080002a52 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002a52:	7179                	addi	sp,sp,-48
    80002a54:	f406                	sd	ra,40(sp)
    80002a56:	f022                	sd	s0,32(sp)
    80002a58:	ec26                	sd	s1,24(sp)
    80002a5a:	e84a                	sd	s2,16(sp)
    80002a5c:	e44e                	sd	s3,8(sp)
    80002a5e:	1800                	addi	s0,sp,48
    80002a60:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002a62:	05050493          	addi	s1,a0,80
    80002a66:	08050913          	addi	s2,a0,128
    80002a6a:	a021                	j	80002a72 <itrunc+0x20>
    80002a6c:	0491                	addi	s1,s1,4
    80002a6e:	01248b63          	beq	s1,s2,80002a84 <itrunc+0x32>
    if(ip->addrs[i]){
    80002a72:	408c                	lw	a1,0(s1)
    80002a74:	dde5                	beqz	a1,80002a6c <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002a76:	0009a503          	lw	a0,0(s3)
    80002a7a:	9abff0ef          	jal	80002424 <bfree>
      ip->addrs[i] = 0;
    80002a7e:	0004a023          	sw	zero,0(s1)
    80002a82:	b7ed                	j	80002a6c <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002a84:	0809a583          	lw	a1,128(s3)
    80002a88:	ed89                	bnez	a1,80002aa2 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002a8a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002a8e:	854e                	mv	a0,s3
    80002a90:	e21ff0ef          	jal	800028b0 <iupdate>
}
    80002a94:	70a2                	ld	ra,40(sp)
    80002a96:	7402                	ld	s0,32(sp)
    80002a98:	64e2                	ld	s1,24(sp)
    80002a9a:	6942                	ld	s2,16(sp)
    80002a9c:	69a2                	ld	s3,8(sp)
    80002a9e:	6145                	addi	sp,sp,48
    80002aa0:	8082                	ret
    80002aa2:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002aa4:	0009a503          	lw	a0,0(s3)
    80002aa8:	f84ff0ef          	jal	8000222c <bread>
    80002aac:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002aae:	05850493          	addi	s1,a0,88
    80002ab2:	45850913          	addi	s2,a0,1112
    80002ab6:	a021                	j	80002abe <itrunc+0x6c>
    80002ab8:	0491                	addi	s1,s1,4
    80002aba:	01248963          	beq	s1,s2,80002acc <itrunc+0x7a>
      if(a[j])
    80002abe:	408c                	lw	a1,0(s1)
    80002ac0:	dde5                	beqz	a1,80002ab8 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002ac2:	0009a503          	lw	a0,0(s3)
    80002ac6:	95fff0ef          	jal	80002424 <bfree>
    80002aca:	b7fd                	j	80002ab8 <itrunc+0x66>
    brelse(bp);
    80002acc:	8552                	mv	a0,s4
    80002ace:	867ff0ef          	jal	80002334 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ad2:	0809a583          	lw	a1,128(s3)
    80002ad6:	0009a503          	lw	a0,0(s3)
    80002ada:	94bff0ef          	jal	80002424 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ade:	0809a023          	sw	zero,128(s3)
    80002ae2:	6a02                	ld	s4,0(sp)
    80002ae4:	b75d                	j	80002a8a <itrunc+0x38>

0000000080002ae6 <iput>:
{
    80002ae6:	1101                	addi	sp,sp,-32
    80002ae8:	ec06                	sd	ra,24(sp)
    80002aea:	e822                	sd	s0,16(sp)
    80002aec:	e426                	sd	s1,8(sp)
    80002aee:	1000                	addi	s0,sp,32
    80002af0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002af2:	00016517          	auipc	a0,0x16
    80002af6:	58650513          	addi	a0,a0,1414 # 80019078 <itable>
    80002afa:	747020ef          	jal	80005a40 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002afe:	4498                	lw	a4,8(s1)
    80002b00:	4785                	li	a5,1
    80002b02:	02f70063          	beq	a4,a5,80002b22 <iput+0x3c>
  ip->ref--;
    80002b06:	449c                	lw	a5,8(s1)
    80002b08:	37fd                	addiw	a5,a5,-1
    80002b0a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b0c:	00016517          	auipc	a0,0x16
    80002b10:	56c50513          	addi	a0,a0,1388 # 80019078 <itable>
    80002b14:	7c5020ef          	jal	80005ad8 <release>
}
    80002b18:	60e2                	ld	ra,24(sp)
    80002b1a:	6442                	ld	s0,16(sp)
    80002b1c:	64a2                	ld	s1,8(sp)
    80002b1e:	6105                	addi	sp,sp,32
    80002b20:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002b22:	40bc                	lw	a5,64(s1)
    80002b24:	d3ed                	beqz	a5,80002b06 <iput+0x20>
    80002b26:	04a49783          	lh	a5,74(s1)
    80002b2a:	fff1                	bnez	a5,80002b06 <iput+0x20>
    80002b2c:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002b2e:	01048913          	addi	s2,s1,16
    80002b32:	854a                	mv	a0,s2
    80002b34:	151000ef          	jal	80003484 <acquiresleep>
    release(&itable.lock);
    80002b38:	00016517          	auipc	a0,0x16
    80002b3c:	54050513          	addi	a0,a0,1344 # 80019078 <itable>
    80002b40:	799020ef          	jal	80005ad8 <release>
    itrunc(ip);
    80002b44:	8526                	mv	a0,s1
    80002b46:	f0dff0ef          	jal	80002a52 <itrunc>
    ip->type = 0;
    80002b4a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002b4e:	8526                	mv	a0,s1
    80002b50:	d61ff0ef          	jal	800028b0 <iupdate>
    ip->valid = 0;
    80002b54:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002b58:	854a                	mv	a0,s2
    80002b5a:	171000ef          	jal	800034ca <releasesleep>
    acquire(&itable.lock);
    80002b5e:	00016517          	auipc	a0,0x16
    80002b62:	51a50513          	addi	a0,a0,1306 # 80019078 <itable>
    80002b66:	6db020ef          	jal	80005a40 <acquire>
    80002b6a:	6902                	ld	s2,0(sp)
    80002b6c:	bf69                	j	80002b06 <iput+0x20>

0000000080002b6e <iunlockput>:
{
    80002b6e:	1101                	addi	sp,sp,-32
    80002b70:	ec06                	sd	ra,24(sp)
    80002b72:	e822                	sd	s0,16(sp)
    80002b74:	e426                	sd	s1,8(sp)
    80002b76:	1000                	addi	s0,sp,32
    80002b78:	84aa                	mv	s1,a0
  iunlock(ip);
    80002b7a:	e99ff0ef          	jal	80002a12 <iunlock>
  iput(ip);
    80002b7e:	8526                	mv	a0,s1
    80002b80:	f67ff0ef          	jal	80002ae6 <iput>
}
    80002b84:	60e2                	ld	ra,24(sp)
    80002b86:	6442                	ld	s0,16(sp)
    80002b88:	64a2                	ld	s1,8(sp)
    80002b8a:	6105                	addi	sp,sp,32
    80002b8c:	8082                	ret

0000000080002b8e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002b8e:	1141                	addi	sp,sp,-16
    80002b90:	e422                	sd	s0,8(sp)
    80002b92:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002b94:	411c                	lw	a5,0(a0)
    80002b96:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002b98:	415c                	lw	a5,4(a0)
    80002b9a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002b9c:	04451783          	lh	a5,68(a0)
    80002ba0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ba4:	04a51783          	lh	a5,74(a0)
    80002ba8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002bac:	04c56783          	lwu	a5,76(a0)
    80002bb0:	e99c                	sd	a5,16(a1)
}
    80002bb2:	6422                	ld	s0,8(sp)
    80002bb4:	0141                	addi	sp,sp,16
    80002bb6:	8082                	ret

0000000080002bb8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002bb8:	457c                	lw	a5,76(a0)
    80002bba:	0ed7eb63          	bltu	a5,a3,80002cb0 <readi+0xf8>
{
    80002bbe:	7159                	addi	sp,sp,-112
    80002bc0:	f486                	sd	ra,104(sp)
    80002bc2:	f0a2                	sd	s0,96(sp)
    80002bc4:	eca6                	sd	s1,88(sp)
    80002bc6:	e0d2                	sd	s4,64(sp)
    80002bc8:	fc56                	sd	s5,56(sp)
    80002bca:	f85a                	sd	s6,48(sp)
    80002bcc:	f45e                	sd	s7,40(sp)
    80002bce:	1880                	addi	s0,sp,112
    80002bd0:	8b2a                	mv	s6,a0
    80002bd2:	8bae                	mv	s7,a1
    80002bd4:	8a32                	mv	s4,a2
    80002bd6:	84b6                	mv	s1,a3
    80002bd8:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002bda:	9f35                	addw	a4,a4,a3
    return 0;
    80002bdc:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002bde:	0cd76063          	bltu	a4,a3,80002c9e <readi+0xe6>
    80002be2:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002be4:	00e7f463          	bgeu	a5,a4,80002bec <readi+0x34>
    n = ip->size - off;
    80002be8:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002bec:	080a8f63          	beqz	s5,80002c8a <readi+0xd2>
    80002bf0:	e8ca                	sd	s2,80(sp)
    80002bf2:	f062                	sd	s8,32(sp)
    80002bf4:	ec66                	sd	s9,24(sp)
    80002bf6:	e86a                	sd	s10,16(sp)
    80002bf8:	e46e                	sd	s11,8(sp)
    80002bfa:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002bfc:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002c00:	5c7d                	li	s8,-1
    80002c02:	a80d                	j	80002c34 <readi+0x7c>
    80002c04:	020d1d93          	slli	s11,s10,0x20
    80002c08:	020ddd93          	srli	s11,s11,0x20
    80002c0c:	05890613          	addi	a2,s2,88
    80002c10:	86ee                	mv	a3,s11
    80002c12:	963a                	add	a2,a2,a4
    80002c14:	85d2                	mv	a1,s4
    80002c16:	855e                	mv	a0,s7
    80002c18:	a75fe0ef          	jal	8000168c <either_copyout>
    80002c1c:	05850763          	beq	a0,s8,80002c6a <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002c20:	854a                	mv	a0,s2
    80002c22:	f12ff0ef          	jal	80002334 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002c26:	013d09bb          	addw	s3,s10,s3
    80002c2a:	009d04bb          	addw	s1,s10,s1
    80002c2e:	9a6e                	add	s4,s4,s11
    80002c30:	0559f763          	bgeu	s3,s5,80002c7e <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002c34:	00a4d59b          	srliw	a1,s1,0xa
    80002c38:	855a                	mv	a0,s6
    80002c3a:	977ff0ef          	jal	800025b0 <bmap>
    80002c3e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002c42:	c5b1                	beqz	a1,80002c8e <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002c44:	000b2503          	lw	a0,0(s6)
    80002c48:	de4ff0ef          	jal	8000222c <bread>
    80002c4c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c4e:	3ff4f713          	andi	a4,s1,1023
    80002c52:	40ec87bb          	subw	a5,s9,a4
    80002c56:	413a86bb          	subw	a3,s5,s3
    80002c5a:	8d3e                	mv	s10,a5
    80002c5c:	2781                	sext.w	a5,a5
    80002c5e:	0006861b          	sext.w	a2,a3
    80002c62:	faf671e3          	bgeu	a2,a5,80002c04 <readi+0x4c>
    80002c66:	8d36                	mv	s10,a3
    80002c68:	bf71                	j	80002c04 <readi+0x4c>
      brelse(bp);
    80002c6a:	854a                	mv	a0,s2
    80002c6c:	ec8ff0ef          	jal	80002334 <brelse>
      tot = -1;
    80002c70:	59fd                	li	s3,-1
      break;
    80002c72:	6946                	ld	s2,80(sp)
    80002c74:	7c02                	ld	s8,32(sp)
    80002c76:	6ce2                	ld	s9,24(sp)
    80002c78:	6d42                	ld	s10,16(sp)
    80002c7a:	6da2                	ld	s11,8(sp)
    80002c7c:	a831                	j	80002c98 <readi+0xe0>
    80002c7e:	6946                	ld	s2,80(sp)
    80002c80:	7c02                	ld	s8,32(sp)
    80002c82:	6ce2                	ld	s9,24(sp)
    80002c84:	6d42                	ld	s10,16(sp)
    80002c86:	6da2                	ld	s11,8(sp)
    80002c88:	a801                	j	80002c98 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002c8a:	89d6                	mv	s3,s5
    80002c8c:	a031                	j	80002c98 <readi+0xe0>
    80002c8e:	6946                	ld	s2,80(sp)
    80002c90:	7c02                	ld	s8,32(sp)
    80002c92:	6ce2                	ld	s9,24(sp)
    80002c94:	6d42                	ld	s10,16(sp)
    80002c96:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002c98:	0009851b          	sext.w	a0,s3
    80002c9c:	69a6                	ld	s3,72(sp)
}
    80002c9e:	70a6                	ld	ra,104(sp)
    80002ca0:	7406                	ld	s0,96(sp)
    80002ca2:	64e6                	ld	s1,88(sp)
    80002ca4:	6a06                	ld	s4,64(sp)
    80002ca6:	7ae2                	ld	s5,56(sp)
    80002ca8:	7b42                	ld	s6,48(sp)
    80002caa:	7ba2                	ld	s7,40(sp)
    80002cac:	6165                	addi	sp,sp,112
    80002cae:	8082                	ret
    return 0;
    80002cb0:	4501                	li	a0,0
}
    80002cb2:	8082                	ret

0000000080002cb4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002cb4:	457c                	lw	a5,76(a0)
    80002cb6:	10d7e063          	bltu	a5,a3,80002db6 <writei+0x102>
{
    80002cba:	7159                	addi	sp,sp,-112
    80002cbc:	f486                	sd	ra,104(sp)
    80002cbe:	f0a2                	sd	s0,96(sp)
    80002cc0:	e8ca                	sd	s2,80(sp)
    80002cc2:	e0d2                	sd	s4,64(sp)
    80002cc4:	fc56                	sd	s5,56(sp)
    80002cc6:	f85a                	sd	s6,48(sp)
    80002cc8:	f45e                	sd	s7,40(sp)
    80002cca:	1880                	addi	s0,sp,112
    80002ccc:	8aaa                	mv	s5,a0
    80002cce:	8bae                	mv	s7,a1
    80002cd0:	8a32                	mv	s4,a2
    80002cd2:	8936                	mv	s2,a3
    80002cd4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002cd6:	00e687bb          	addw	a5,a3,a4
    80002cda:	0ed7e063          	bltu	a5,a3,80002dba <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002cde:	00043737          	lui	a4,0x43
    80002ce2:	0cf76e63          	bltu	a4,a5,80002dbe <writei+0x10a>
    80002ce6:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ce8:	0a0b0f63          	beqz	s6,80002da6 <writei+0xf2>
    80002cec:	eca6                	sd	s1,88(sp)
    80002cee:	f062                	sd	s8,32(sp)
    80002cf0:	ec66                	sd	s9,24(sp)
    80002cf2:	e86a                	sd	s10,16(sp)
    80002cf4:	e46e                	sd	s11,8(sp)
    80002cf6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002cf8:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002cfc:	5c7d                	li	s8,-1
    80002cfe:	a825                	j	80002d36 <writei+0x82>
    80002d00:	020d1d93          	slli	s11,s10,0x20
    80002d04:	020ddd93          	srli	s11,s11,0x20
    80002d08:	05848513          	addi	a0,s1,88
    80002d0c:	86ee                	mv	a3,s11
    80002d0e:	8652                	mv	a2,s4
    80002d10:	85de                	mv	a1,s7
    80002d12:	953a                	add	a0,a0,a4
    80002d14:	9c3fe0ef          	jal	800016d6 <either_copyin>
    80002d18:	05850a63          	beq	a0,s8,80002d6c <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002d1c:	8526                	mv	a0,s1
    80002d1e:	660000ef          	jal	8000337e <log_write>
    brelse(bp);
    80002d22:	8526                	mv	a0,s1
    80002d24:	e10ff0ef          	jal	80002334 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002d28:	013d09bb          	addw	s3,s10,s3
    80002d2c:	012d093b          	addw	s2,s10,s2
    80002d30:	9a6e                	add	s4,s4,s11
    80002d32:	0569f063          	bgeu	s3,s6,80002d72 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002d36:	00a9559b          	srliw	a1,s2,0xa
    80002d3a:	8556                	mv	a0,s5
    80002d3c:	875ff0ef          	jal	800025b0 <bmap>
    80002d40:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002d44:	c59d                	beqz	a1,80002d72 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002d46:	000aa503          	lw	a0,0(s5)
    80002d4a:	ce2ff0ef          	jal	8000222c <bread>
    80002d4e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002d50:	3ff97713          	andi	a4,s2,1023
    80002d54:	40ec87bb          	subw	a5,s9,a4
    80002d58:	413b06bb          	subw	a3,s6,s3
    80002d5c:	8d3e                	mv	s10,a5
    80002d5e:	2781                	sext.w	a5,a5
    80002d60:	0006861b          	sext.w	a2,a3
    80002d64:	f8f67ee3          	bgeu	a2,a5,80002d00 <writei+0x4c>
    80002d68:	8d36                	mv	s10,a3
    80002d6a:	bf59                	j	80002d00 <writei+0x4c>
      brelse(bp);
    80002d6c:	8526                	mv	a0,s1
    80002d6e:	dc6ff0ef          	jal	80002334 <brelse>
  }

  if(off > ip->size)
    80002d72:	04caa783          	lw	a5,76(s5)
    80002d76:	0327fa63          	bgeu	a5,s2,80002daa <writei+0xf6>
    ip->size = off;
    80002d7a:	052aa623          	sw	s2,76(s5)
    80002d7e:	64e6                	ld	s1,88(sp)
    80002d80:	7c02                	ld	s8,32(sp)
    80002d82:	6ce2                	ld	s9,24(sp)
    80002d84:	6d42                	ld	s10,16(sp)
    80002d86:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002d88:	8556                	mv	a0,s5
    80002d8a:	b27ff0ef          	jal	800028b0 <iupdate>

  return tot;
    80002d8e:	0009851b          	sext.w	a0,s3
    80002d92:	69a6                	ld	s3,72(sp)
}
    80002d94:	70a6                	ld	ra,104(sp)
    80002d96:	7406                	ld	s0,96(sp)
    80002d98:	6946                	ld	s2,80(sp)
    80002d9a:	6a06                	ld	s4,64(sp)
    80002d9c:	7ae2                	ld	s5,56(sp)
    80002d9e:	7b42                	ld	s6,48(sp)
    80002da0:	7ba2                	ld	s7,40(sp)
    80002da2:	6165                	addi	sp,sp,112
    80002da4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002da6:	89da                	mv	s3,s6
    80002da8:	b7c5                	j	80002d88 <writei+0xd4>
    80002daa:	64e6                	ld	s1,88(sp)
    80002dac:	7c02                	ld	s8,32(sp)
    80002dae:	6ce2                	ld	s9,24(sp)
    80002db0:	6d42                	ld	s10,16(sp)
    80002db2:	6da2                	ld	s11,8(sp)
    80002db4:	bfd1                	j	80002d88 <writei+0xd4>
    return -1;
    80002db6:	557d                	li	a0,-1
}
    80002db8:	8082                	ret
    return -1;
    80002dba:	557d                	li	a0,-1
    80002dbc:	bfe1                	j	80002d94 <writei+0xe0>
    return -1;
    80002dbe:	557d                	li	a0,-1
    80002dc0:	bfd1                	j	80002d94 <writei+0xe0>

0000000080002dc2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002dc2:	1141                	addi	sp,sp,-16
    80002dc4:	e406                	sd	ra,8(sp)
    80002dc6:	e022                	sd	s0,0(sp)
    80002dc8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002dca:	4639                	li	a2,14
    80002dcc:	c34fd0ef          	jal	80000200 <strncmp>
}
    80002dd0:	60a2                	ld	ra,8(sp)
    80002dd2:	6402                	ld	s0,0(sp)
    80002dd4:	0141                	addi	sp,sp,16
    80002dd6:	8082                	ret

0000000080002dd8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002dd8:	7139                	addi	sp,sp,-64
    80002dda:	fc06                	sd	ra,56(sp)
    80002ddc:	f822                	sd	s0,48(sp)
    80002dde:	f426                	sd	s1,40(sp)
    80002de0:	f04a                	sd	s2,32(sp)
    80002de2:	ec4e                	sd	s3,24(sp)
    80002de4:	e852                	sd	s4,16(sp)
    80002de6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002de8:	04451703          	lh	a4,68(a0)
    80002dec:	4785                	li	a5,1
    80002dee:	00f71a63          	bne	a4,a5,80002e02 <dirlookup+0x2a>
    80002df2:	892a                	mv	s2,a0
    80002df4:	89ae                	mv	s3,a1
    80002df6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002df8:	457c                	lw	a5,76(a0)
    80002dfa:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002dfc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002dfe:	e39d                	bnez	a5,80002e24 <dirlookup+0x4c>
    80002e00:	a095                	j	80002e64 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002e02:	00005517          	auipc	a0,0x5
    80002e06:	81e50513          	addi	a0,a0,-2018 # 80007620 <etext+0x620>
    80002e0a:	109020ef          	jal	80005712 <panic>
      panic("dirlookup read");
    80002e0e:	00005517          	auipc	a0,0x5
    80002e12:	82a50513          	addi	a0,a0,-2006 # 80007638 <etext+0x638>
    80002e16:	0fd020ef          	jal	80005712 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e1a:	24c1                	addiw	s1,s1,16
    80002e1c:	04c92783          	lw	a5,76(s2)
    80002e20:	04f4f163          	bgeu	s1,a5,80002e62 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e24:	4741                	li	a4,16
    80002e26:	86a6                	mv	a3,s1
    80002e28:	fc040613          	addi	a2,s0,-64
    80002e2c:	4581                	li	a1,0
    80002e2e:	854a                	mv	a0,s2
    80002e30:	d89ff0ef          	jal	80002bb8 <readi>
    80002e34:	47c1                	li	a5,16
    80002e36:	fcf51ce3          	bne	a0,a5,80002e0e <dirlookup+0x36>
    if(de.inum == 0)
    80002e3a:	fc045783          	lhu	a5,-64(s0)
    80002e3e:	dff1                	beqz	a5,80002e1a <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002e40:	fc240593          	addi	a1,s0,-62
    80002e44:	854e                	mv	a0,s3
    80002e46:	f7dff0ef          	jal	80002dc2 <namecmp>
    80002e4a:	f961                	bnez	a0,80002e1a <dirlookup+0x42>
      if(poff)
    80002e4c:	000a0463          	beqz	s4,80002e54 <dirlookup+0x7c>
        *poff = off;
    80002e50:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002e54:	fc045583          	lhu	a1,-64(s0)
    80002e58:	00092503          	lw	a0,0(s2)
    80002e5c:	829ff0ef          	jal	80002684 <iget>
    80002e60:	a011                	j	80002e64 <dirlookup+0x8c>
  return 0;
    80002e62:	4501                	li	a0,0
}
    80002e64:	70e2                	ld	ra,56(sp)
    80002e66:	7442                	ld	s0,48(sp)
    80002e68:	74a2                	ld	s1,40(sp)
    80002e6a:	7902                	ld	s2,32(sp)
    80002e6c:	69e2                	ld	s3,24(sp)
    80002e6e:	6a42                	ld	s4,16(sp)
    80002e70:	6121                	addi	sp,sp,64
    80002e72:	8082                	ret

0000000080002e74 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002e74:	711d                	addi	sp,sp,-96
    80002e76:	ec86                	sd	ra,88(sp)
    80002e78:	e8a2                	sd	s0,80(sp)
    80002e7a:	e4a6                	sd	s1,72(sp)
    80002e7c:	e0ca                	sd	s2,64(sp)
    80002e7e:	fc4e                	sd	s3,56(sp)
    80002e80:	f852                	sd	s4,48(sp)
    80002e82:	f456                	sd	s5,40(sp)
    80002e84:	f05a                	sd	s6,32(sp)
    80002e86:	ec5e                	sd	s7,24(sp)
    80002e88:	e862                	sd	s8,16(sp)
    80002e8a:	e466                	sd	s9,8(sp)
    80002e8c:	1080                	addi	s0,sp,96
    80002e8e:	84aa                	mv	s1,a0
    80002e90:	8b2e                	mv	s6,a1
    80002e92:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002e94:	00054703          	lbu	a4,0(a0)
    80002e98:	02f00793          	li	a5,47
    80002e9c:	00f70e63          	beq	a4,a5,80002eb8 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002ea0:	eb7fd0ef          	jal	80000d56 <myproc>
    80002ea4:	15053503          	ld	a0,336(a0)
    80002ea8:	a87ff0ef          	jal	8000292e <idup>
    80002eac:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002eae:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002eb2:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002eb4:	4b85                	li	s7,1
    80002eb6:	a871                	j	80002f52 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002eb8:	4585                	li	a1,1
    80002eba:	4505                	li	a0,1
    80002ebc:	fc8ff0ef          	jal	80002684 <iget>
    80002ec0:	8a2a                	mv	s4,a0
    80002ec2:	b7f5                	j	80002eae <namex+0x3a>
      iunlockput(ip);
    80002ec4:	8552                	mv	a0,s4
    80002ec6:	ca9ff0ef          	jal	80002b6e <iunlockput>
      return 0;
    80002eca:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002ecc:	8552                	mv	a0,s4
    80002ece:	60e6                	ld	ra,88(sp)
    80002ed0:	6446                	ld	s0,80(sp)
    80002ed2:	64a6                	ld	s1,72(sp)
    80002ed4:	6906                	ld	s2,64(sp)
    80002ed6:	79e2                	ld	s3,56(sp)
    80002ed8:	7a42                	ld	s4,48(sp)
    80002eda:	7aa2                	ld	s5,40(sp)
    80002edc:	7b02                	ld	s6,32(sp)
    80002ede:	6be2                	ld	s7,24(sp)
    80002ee0:	6c42                	ld	s8,16(sp)
    80002ee2:	6ca2                	ld	s9,8(sp)
    80002ee4:	6125                	addi	sp,sp,96
    80002ee6:	8082                	ret
      iunlock(ip);
    80002ee8:	8552                	mv	a0,s4
    80002eea:	b29ff0ef          	jal	80002a12 <iunlock>
      return ip;
    80002eee:	bff9                	j	80002ecc <namex+0x58>
      iunlockput(ip);
    80002ef0:	8552                	mv	a0,s4
    80002ef2:	c7dff0ef          	jal	80002b6e <iunlockput>
      return 0;
    80002ef6:	8a4e                	mv	s4,s3
    80002ef8:	bfd1                	j	80002ecc <namex+0x58>
  len = path - s;
    80002efa:	40998633          	sub	a2,s3,s1
    80002efe:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002f02:	099c5063          	bge	s8,s9,80002f82 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002f06:	4639                	li	a2,14
    80002f08:	85a6                	mv	a1,s1
    80002f0a:	8556                	mv	a0,s5
    80002f0c:	a84fd0ef          	jal	80000190 <memmove>
    80002f10:	84ce                	mv	s1,s3
  while(*path == '/')
    80002f12:	0004c783          	lbu	a5,0(s1)
    80002f16:	01279763          	bne	a5,s2,80002f24 <namex+0xb0>
    path++;
    80002f1a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002f1c:	0004c783          	lbu	a5,0(s1)
    80002f20:	ff278de3          	beq	a5,s2,80002f1a <namex+0xa6>
    ilock(ip);
    80002f24:	8552                	mv	a0,s4
    80002f26:	a3fff0ef          	jal	80002964 <ilock>
    if(ip->type != T_DIR){
    80002f2a:	044a1783          	lh	a5,68(s4)
    80002f2e:	f9779be3          	bne	a5,s7,80002ec4 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002f32:	000b0563          	beqz	s6,80002f3c <namex+0xc8>
    80002f36:	0004c783          	lbu	a5,0(s1)
    80002f3a:	d7dd                	beqz	a5,80002ee8 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002f3c:	4601                	li	a2,0
    80002f3e:	85d6                	mv	a1,s5
    80002f40:	8552                	mv	a0,s4
    80002f42:	e97ff0ef          	jal	80002dd8 <dirlookup>
    80002f46:	89aa                	mv	s3,a0
    80002f48:	d545                	beqz	a0,80002ef0 <namex+0x7c>
    iunlockput(ip);
    80002f4a:	8552                	mv	a0,s4
    80002f4c:	c23ff0ef          	jal	80002b6e <iunlockput>
    ip = next;
    80002f50:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002f52:	0004c783          	lbu	a5,0(s1)
    80002f56:	01279763          	bne	a5,s2,80002f64 <namex+0xf0>
    path++;
    80002f5a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002f5c:	0004c783          	lbu	a5,0(s1)
    80002f60:	ff278de3          	beq	a5,s2,80002f5a <namex+0xe6>
  if(*path == 0)
    80002f64:	cb8d                	beqz	a5,80002f96 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002f66:	0004c783          	lbu	a5,0(s1)
    80002f6a:	89a6                	mv	s3,s1
  len = path - s;
    80002f6c:	4c81                	li	s9,0
    80002f6e:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002f70:	01278963          	beq	a5,s2,80002f82 <namex+0x10e>
    80002f74:	d3d9                	beqz	a5,80002efa <namex+0x86>
    path++;
    80002f76:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002f78:	0009c783          	lbu	a5,0(s3)
    80002f7c:	ff279ce3          	bne	a5,s2,80002f74 <namex+0x100>
    80002f80:	bfad                	j	80002efa <namex+0x86>
    memmove(name, s, len);
    80002f82:	2601                	sext.w	a2,a2
    80002f84:	85a6                	mv	a1,s1
    80002f86:	8556                	mv	a0,s5
    80002f88:	a08fd0ef          	jal	80000190 <memmove>
    name[len] = 0;
    80002f8c:	9cd6                	add	s9,s9,s5
    80002f8e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002f92:	84ce                	mv	s1,s3
    80002f94:	bfbd                	j	80002f12 <namex+0x9e>
  if(nameiparent){
    80002f96:	f20b0be3          	beqz	s6,80002ecc <namex+0x58>
    iput(ip);
    80002f9a:	8552                	mv	a0,s4
    80002f9c:	b4bff0ef          	jal	80002ae6 <iput>
    return 0;
    80002fa0:	4a01                	li	s4,0
    80002fa2:	b72d                	j	80002ecc <namex+0x58>

0000000080002fa4 <dirlink>:
{
    80002fa4:	7139                	addi	sp,sp,-64
    80002fa6:	fc06                	sd	ra,56(sp)
    80002fa8:	f822                	sd	s0,48(sp)
    80002faa:	f04a                	sd	s2,32(sp)
    80002fac:	ec4e                	sd	s3,24(sp)
    80002fae:	e852                	sd	s4,16(sp)
    80002fb0:	0080                	addi	s0,sp,64
    80002fb2:	892a                	mv	s2,a0
    80002fb4:	8a2e                	mv	s4,a1
    80002fb6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002fb8:	4601                	li	a2,0
    80002fba:	e1fff0ef          	jal	80002dd8 <dirlookup>
    80002fbe:	e535                	bnez	a0,8000302a <dirlink+0x86>
    80002fc0:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fc2:	04c92483          	lw	s1,76(s2)
    80002fc6:	c48d                	beqz	s1,80002ff0 <dirlink+0x4c>
    80002fc8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002fca:	4741                	li	a4,16
    80002fcc:	86a6                	mv	a3,s1
    80002fce:	fc040613          	addi	a2,s0,-64
    80002fd2:	4581                	li	a1,0
    80002fd4:	854a                	mv	a0,s2
    80002fd6:	be3ff0ef          	jal	80002bb8 <readi>
    80002fda:	47c1                	li	a5,16
    80002fdc:	04f51b63          	bne	a0,a5,80003032 <dirlink+0x8e>
    if(de.inum == 0)
    80002fe0:	fc045783          	lhu	a5,-64(s0)
    80002fe4:	c791                	beqz	a5,80002ff0 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fe6:	24c1                	addiw	s1,s1,16
    80002fe8:	04c92783          	lw	a5,76(s2)
    80002fec:	fcf4efe3          	bltu	s1,a5,80002fca <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002ff0:	4639                	li	a2,14
    80002ff2:	85d2                	mv	a1,s4
    80002ff4:	fc240513          	addi	a0,s0,-62
    80002ff8:	a3efd0ef          	jal	80000236 <strncpy>
  de.inum = inum;
    80002ffc:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003000:	4741                	li	a4,16
    80003002:	86a6                	mv	a3,s1
    80003004:	fc040613          	addi	a2,s0,-64
    80003008:	4581                	li	a1,0
    8000300a:	854a                	mv	a0,s2
    8000300c:	ca9ff0ef          	jal	80002cb4 <writei>
    80003010:	1541                	addi	a0,a0,-16
    80003012:	00a03533          	snez	a0,a0
    80003016:	40a00533          	neg	a0,a0
    8000301a:	74a2                	ld	s1,40(sp)
}
    8000301c:	70e2                	ld	ra,56(sp)
    8000301e:	7442                	ld	s0,48(sp)
    80003020:	7902                	ld	s2,32(sp)
    80003022:	69e2                	ld	s3,24(sp)
    80003024:	6a42                	ld	s4,16(sp)
    80003026:	6121                	addi	sp,sp,64
    80003028:	8082                	ret
    iput(ip);
    8000302a:	abdff0ef          	jal	80002ae6 <iput>
    return -1;
    8000302e:	557d                	li	a0,-1
    80003030:	b7f5                	j	8000301c <dirlink+0x78>
      panic("dirlink read");
    80003032:	00004517          	auipc	a0,0x4
    80003036:	61650513          	addi	a0,a0,1558 # 80007648 <etext+0x648>
    8000303a:	6d8020ef          	jal	80005712 <panic>

000000008000303e <namei>:

struct inode*
namei(char *path)
{
    8000303e:	1101                	addi	sp,sp,-32
    80003040:	ec06                	sd	ra,24(sp)
    80003042:	e822                	sd	s0,16(sp)
    80003044:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003046:	fe040613          	addi	a2,s0,-32
    8000304a:	4581                	li	a1,0
    8000304c:	e29ff0ef          	jal	80002e74 <namex>
}
    80003050:	60e2                	ld	ra,24(sp)
    80003052:	6442                	ld	s0,16(sp)
    80003054:	6105                	addi	sp,sp,32
    80003056:	8082                	ret

0000000080003058 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003058:	1141                	addi	sp,sp,-16
    8000305a:	e406                	sd	ra,8(sp)
    8000305c:	e022                	sd	s0,0(sp)
    8000305e:	0800                	addi	s0,sp,16
    80003060:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003062:	4585                	li	a1,1
    80003064:	e11ff0ef          	jal	80002e74 <namex>
}
    80003068:	60a2                	ld	ra,8(sp)
    8000306a:	6402                	ld	s0,0(sp)
    8000306c:	0141                	addi	sp,sp,16
    8000306e:	8082                	ret

0000000080003070 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003070:	1101                	addi	sp,sp,-32
    80003072:	ec06                	sd	ra,24(sp)
    80003074:	e822                	sd	s0,16(sp)
    80003076:	e426                	sd	s1,8(sp)
    80003078:	e04a                	sd	s2,0(sp)
    8000307a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000307c:	00018917          	auipc	s2,0x18
    80003080:	aa490913          	addi	s2,s2,-1372 # 8001ab20 <log>
    80003084:	01892583          	lw	a1,24(s2)
    80003088:	02892503          	lw	a0,40(s2)
    8000308c:	9a0ff0ef          	jal	8000222c <bread>
    80003090:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003092:	02c92603          	lw	a2,44(s2)
    80003096:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003098:	00c05f63          	blez	a2,800030b6 <write_head+0x46>
    8000309c:	00018717          	auipc	a4,0x18
    800030a0:	ab470713          	addi	a4,a4,-1356 # 8001ab50 <log+0x30>
    800030a4:	87aa                	mv	a5,a0
    800030a6:	060a                	slli	a2,a2,0x2
    800030a8:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800030aa:	4314                	lw	a3,0(a4)
    800030ac:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800030ae:	0711                	addi	a4,a4,4
    800030b0:	0791                	addi	a5,a5,4
    800030b2:	fec79ce3          	bne	a5,a2,800030aa <write_head+0x3a>
  }
  bwrite(buf);
    800030b6:	8526                	mv	a0,s1
    800030b8:	a4aff0ef          	jal	80002302 <bwrite>
  brelse(buf);
    800030bc:	8526                	mv	a0,s1
    800030be:	a76ff0ef          	jal	80002334 <brelse>
}
    800030c2:	60e2                	ld	ra,24(sp)
    800030c4:	6442                	ld	s0,16(sp)
    800030c6:	64a2                	ld	s1,8(sp)
    800030c8:	6902                	ld	s2,0(sp)
    800030ca:	6105                	addi	sp,sp,32
    800030cc:	8082                	ret

00000000800030ce <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800030ce:	00018797          	auipc	a5,0x18
    800030d2:	a7e7a783          	lw	a5,-1410(a5) # 8001ab4c <log+0x2c>
    800030d6:	08f05f63          	blez	a5,80003174 <install_trans+0xa6>
{
    800030da:	7139                	addi	sp,sp,-64
    800030dc:	fc06                	sd	ra,56(sp)
    800030de:	f822                	sd	s0,48(sp)
    800030e0:	f426                	sd	s1,40(sp)
    800030e2:	f04a                	sd	s2,32(sp)
    800030e4:	ec4e                	sd	s3,24(sp)
    800030e6:	e852                	sd	s4,16(sp)
    800030e8:	e456                	sd	s5,8(sp)
    800030ea:	e05a                	sd	s6,0(sp)
    800030ec:	0080                	addi	s0,sp,64
    800030ee:	8b2a                	mv	s6,a0
    800030f0:	00018a97          	auipc	s5,0x18
    800030f4:	a60a8a93          	addi	s5,s5,-1440 # 8001ab50 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800030f8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800030fa:	00018997          	auipc	s3,0x18
    800030fe:	a2698993          	addi	s3,s3,-1498 # 8001ab20 <log>
    80003102:	a829                	j	8000311c <install_trans+0x4e>
    brelse(lbuf);
    80003104:	854a                	mv	a0,s2
    80003106:	a2eff0ef          	jal	80002334 <brelse>
    brelse(dbuf);
    8000310a:	8526                	mv	a0,s1
    8000310c:	a28ff0ef          	jal	80002334 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003110:	2a05                	addiw	s4,s4,1
    80003112:	0a91                	addi	s5,s5,4
    80003114:	02c9a783          	lw	a5,44(s3)
    80003118:	04fa5463          	bge	s4,a5,80003160 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000311c:	0189a583          	lw	a1,24(s3)
    80003120:	014585bb          	addw	a1,a1,s4
    80003124:	2585                	addiw	a1,a1,1
    80003126:	0289a503          	lw	a0,40(s3)
    8000312a:	902ff0ef          	jal	8000222c <bread>
    8000312e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003130:	000aa583          	lw	a1,0(s5)
    80003134:	0289a503          	lw	a0,40(s3)
    80003138:	8f4ff0ef          	jal	8000222c <bread>
    8000313c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000313e:	40000613          	li	a2,1024
    80003142:	05890593          	addi	a1,s2,88
    80003146:	05850513          	addi	a0,a0,88
    8000314a:	846fd0ef          	jal	80000190 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000314e:	8526                	mv	a0,s1
    80003150:	9b2ff0ef          	jal	80002302 <bwrite>
    if(recovering == 0)
    80003154:	fa0b18e3          	bnez	s6,80003104 <install_trans+0x36>
      bunpin(dbuf);
    80003158:	8526                	mv	a0,s1
    8000315a:	a96ff0ef          	jal	800023f0 <bunpin>
    8000315e:	b75d                	j	80003104 <install_trans+0x36>
}
    80003160:	70e2                	ld	ra,56(sp)
    80003162:	7442                	ld	s0,48(sp)
    80003164:	74a2                	ld	s1,40(sp)
    80003166:	7902                	ld	s2,32(sp)
    80003168:	69e2                	ld	s3,24(sp)
    8000316a:	6a42                	ld	s4,16(sp)
    8000316c:	6aa2                	ld	s5,8(sp)
    8000316e:	6b02                	ld	s6,0(sp)
    80003170:	6121                	addi	sp,sp,64
    80003172:	8082                	ret
    80003174:	8082                	ret

0000000080003176 <initlog>:
{
    80003176:	7179                	addi	sp,sp,-48
    80003178:	f406                	sd	ra,40(sp)
    8000317a:	f022                	sd	s0,32(sp)
    8000317c:	ec26                	sd	s1,24(sp)
    8000317e:	e84a                	sd	s2,16(sp)
    80003180:	e44e                	sd	s3,8(sp)
    80003182:	1800                	addi	s0,sp,48
    80003184:	892a                	mv	s2,a0
    80003186:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003188:	00018497          	auipc	s1,0x18
    8000318c:	99848493          	addi	s1,s1,-1640 # 8001ab20 <log>
    80003190:	00004597          	auipc	a1,0x4
    80003194:	4c858593          	addi	a1,a1,1224 # 80007658 <etext+0x658>
    80003198:	8526                	mv	a0,s1
    8000319a:	027020ef          	jal	800059c0 <initlock>
  log.start = sb->logstart;
    8000319e:	0149a583          	lw	a1,20(s3)
    800031a2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800031a4:	0109a783          	lw	a5,16(s3)
    800031a8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800031aa:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800031ae:	854a                	mv	a0,s2
    800031b0:	87cff0ef          	jal	8000222c <bread>
  log.lh.n = lh->n;
    800031b4:	4d30                	lw	a2,88(a0)
    800031b6:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800031b8:	00c05f63          	blez	a2,800031d6 <initlog+0x60>
    800031bc:	87aa                	mv	a5,a0
    800031be:	00018717          	auipc	a4,0x18
    800031c2:	99270713          	addi	a4,a4,-1646 # 8001ab50 <log+0x30>
    800031c6:	060a                	slli	a2,a2,0x2
    800031c8:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800031ca:	4ff4                	lw	a3,92(a5)
    800031cc:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800031ce:	0791                	addi	a5,a5,4
    800031d0:	0711                	addi	a4,a4,4
    800031d2:	fec79ce3          	bne	a5,a2,800031ca <initlog+0x54>
  brelse(buf);
    800031d6:	95eff0ef          	jal	80002334 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800031da:	4505                	li	a0,1
    800031dc:	ef3ff0ef          	jal	800030ce <install_trans>
  log.lh.n = 0;
    800031e0:	00018797          	auipc	a5,0x18
    800031e4:	9607a623          	sw	zero,-1684(a5) # 8001ab4c <log+0x2c>
  write_head(); // clear the log
    800031e8:	e89ff0ef          	jal	80003070 <write_head>
}
    800031ec:	70a2                	ld	ra,40(sp)
    800031ee:	7402                	ld	s0,32(sp)
    800031f0:	64e2                	ld	s1,24(sp)
    800031f2:	6942                	ld	s2,16(sp)
    800031f4:	69a2                	ld	s3,8(sp)
    800031f6:	6145                	addi	sp,sp,48
    800031f8:	8082                	ret

00000000800031fa <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800031fa:	1101                	addi	sp,sp,-32
    800031fc:	ec06                	sd	ra,24(sp)
    800031fe:	e822                	sd	s0,16(sp)
    80003200:	e426                	sd	s1,8(sp)
    80003202:	e04a                	sd	s2,0(sp)
    80003204:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003206:	00018517          	auipc	a0,0x18
    8000320a:	91a50513          	addi	a0,a0,-1766 # 8001ab20 <log>
    8000320e:	033020ef          	jal	80005a40 <acquire>
  while(1){
    if(log.committing){
    80003212:	00018497          	auipc	s1,0x18
    80003216:	90e48493          	addi	s1,s1,-1778 # 8001ab20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000321a:	4979                	li	s2,30
    8000321c:	a029                	j	80003226 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000321e:	85a6                	mv	a1,s1
    80003220:	8526                	mv	a0,s1
    80003222:	90efe0ef          	jal	80001330 <sleep>
    if(log.committing){
    80003226:	50dc                	lw	a5,36(s1)
    80003228:	fbfd                	bnez	a5,8000321e <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000322a:	5098                	lw	a4,32(s1)
    8000322c:	2705                	addiw	a4,a4,1
    8000322e:	0027179b          	slliw	a5,a4,0x2
    80003232:	9fb9                	addw	a5,a5,a4
    80003234:	0017979b          	slliw	a5,a5,0x1
    80003238:	54d4                	lw	a3,44(s1)
    8000323a:	9fb5                	addw	a5,a5,a3
    8000323c:	00f95763          	bge	s2,a5,8000324a <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003240:	85a6                	mv	a1,s1
    80003242:	8526                	mv	a0,s1
    80003244:	8ecfe0ef          	jal	80001330 <sleep>
    80003248:	bff9                	j	80003226 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    8000324a:	00018517          	auipc	a0,0x18
    8000324e:	8d650513          	addi	a0,a0,-1834 # 8001ab20 <log>
    80003252:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003254:	085020ef          	jal	80005ad8 <release>
      break;
    }
  }
}
    80003258:	60e2                	ld	ra,24(sp)
    8000325a:	6442                	ld	s0,16(sp)
    8000325c:	64a2                	ld	s1,8(sp)
    8000325e:	6902                	ld	s2,0(sp)
    80003260:	6105                	addi	sp,sp,32
    80003262:	8082                	ret

0000000080003264 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003264:	7139                	addi	sp,sp,-64
    80003266:	fc06                	sd	ra,56(sp)
    80003268:	f822                	sd	s0,48(sp)
    8000326a:	f426                	sd	s1,40(sp)
    8000326c:	f04a                	sd	s2,32(sp)
    8000326e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003270:	00018497          	auipc	s1,0x18
    80003274:	8b048493          	addi	s1,s1,-1872 # 8001ab20 <log>
    80003278:	8526                	mv	a0,s1
    8000327a:	7c6020ef          	jal	80005a40 <acquire>
  log.outstanding -= 1;
    8000327e:	509c                	lw	a5,32(s1)
    80003280:	37fd                	addiw	a5,a5,-1
    80003282:	0007891b          	sext.w	s2,a5
    80003286:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003288:	50dc                	lw	a5,36(s1)
    8000328a:	ef9d                	bnez	a5,800032c8 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    8000328c:	04091763          	bnez	s2,800032da <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003290:	00018497          	auipc	s1,0x18
    80003294:	89048493          	addi	s1,s1,-1904 # 8001ab20 <log>
    80003298:	4785                	li	a5,1
    8000329a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000329c:	8526                	mv	a0,s1
    8000329e:	03b020ef          	jal	80005ad8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800032a2:	54dc                	lw	a5,44(s1)
    800032a4:	04f04b63          	bgtz	a5,800032fa <end_op+0x96>
    acquire(&log.lock);
    800032a8:	00018497          	auipc	s1,0x18
    800032ac:	87848493          	addi	s1,s1,-1928 # 8001ab20 <log>
    800032b0:	8526                	mv	a0,s1
    800032b2:	78e020ef          	jal	80005a40 <acquire>
    log.committing = 0;
    800032b6:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800032ba:	8526                	mv	a0,s1
    800032bc:	8c0fe0ef          	jal	8000137c <wakeup>
    release(&log.lock);
    800032c0:	8526                	mv	a0,s1
    800032c2:	017020ef          	jal	80005ad8 <release>
}
    800032c6:	a025                	j	800032ee <end_op+0x8a>
    800032c8:	ec4e                	sd	s3,24(sp)
    800032ca:	e852                	sd	s4,16(sp)
    800032cc:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800032ce:	00004517          	auipc	a0,0x4
    800032d2:	39250513          	addi	a0,a0,914 # 80007660 <etext+0x660>
    800032d6:	43c020ef          	jal	80005712 <panic>
    wakeup(&log);
    800032da:	00018497          	auipc	s1,0x18
    800032de:	84648493          	addi	s1,s1,-1978 # 8001ab20 <log>
    800032e2:	8526                	mv	a0,s1
    800032e4:	898fe0ef          	jal	8000137c <wakeup>
  release(&log.lock);
    800032e8:	8526                	mv	a0,s1
    800032ea:	7ee020ef          	jal	80005ad8 <release>
}
    800032ee:	70e2                	ld	ra,56(sp)
    800032f0:	7442                	ld	s0,48(sp)
    800032f2:	74a2                	ld	s1,40(sp)
    800032f4:	7902                	ld	s2,32(sp)
    800032f6:	6121                	addi	sp,sp,64
    800032f8:	8082                	ret
    800032fa:	ec4e                	sd	s3,24(sp)
    800032fc:	e852                	sd	s4,16(sp)
    800032fe:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003300:	00018a97          	auipc	s5,0x18
    80003304:	850a8a93          	addi	s5,s5,-1968 # 8001ab50 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003308:	00018a17          	auipc	s4,0x18
    8000330c:	818a0a13          	addi	s4,s4,-2024 # 8001ab20 <log>
    80003310:	018a2583          	lw	a1,24(s4)
    80003314:	012585bb          	addw	a1,a1,s2
    80003318:	2585                	addiw	a1,a1,1
    8000331a:	028a2503          	lw	a0,40(s4)
    8000331e:	f0ffe0ef          	jal	8000222c <bread>
    80003322:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003324:	000aa583          	lw	a1,0(s5)
    80003328:	028a2503          	lw	a0,40(s4)
    8000332c:	f01fe0ef          	jal	8000222c <bread>
    80003330:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003332:	40000613          	li	a2,1024
    80003336:	05850593          	addi	a1,a0,88
    8000333a:	05848513          	addi	a0,s1,88
    8000333e:	e53fc0ef          	jal	80000190 <memmove>
    bwrite(to);  // write the log
    80003342:	8526                	mv	a0,s1
    80003344:	fbffe0ef          	jal	80002302 <bwrite>
    brelse(from);
    80003348:	854e                	mv	a0,s3
    8000334a:	febfe0ef          	jal	80002334 <brelse>
    brelse(to);
    8000334e:	8526                	mv	a0,s1
    80003350:	fe5fe0ef          	jal	80002334 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003354:	2905                	addiw	s2,s2,1
    80003356:	0a91                	addi	s5,s5,4
    80003358:	02ca2783          	lw	a5,44(s4)
    8000335c:	faf94ae3          	blt	s2,a5,80003310 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003360:	d11ff0ef          	jal	80003070 <write_head>
    install_trans(0); // Now install writes to home locations
    80003364:	4501                	li	a0,0
    80003366:	d69ff0ef          	jal	800030ce <install_trans>
    log.lh.n = 0;
    8000336a:	00017797          	auipc	a5,0x17
    8000336e:	7e07a123          	sw	zero,2018(a5) # 8001ab4c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003372:	cffff0ef          	jal	80003070 <write_head>
    80003376:	69e2                	ld	s3,24(sp)
    80003378:	6a42                	ld	s4,16(sp)
    8000337a:	6aa2                	ld	s5,8(sp)
    8000337c:	b735                	j	800032a8 <end_op+0x44>

000000008000337e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000337e:	1101                	addi	sp,sp,-32
    80003380:	ec06                	sd	ra,24(sp)
    80003382:	e822                	sd	s0,16(sp)
    80003384:	e426                	sd	s1,8(sp)
    80003386:	e04a                	sd	s2,0(sp)
    80003388:	1000                	addi	s0,sp,32
    8000338a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000338c:	00017917          	auipc	s2,0x17
    80003390:	79490913          	addi	s2,s2,1940 # 8001ab20 <log>
    80003394:	854a                	mv	a0,s2
    80003396:	6aa020ef          	jal	80005a40 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000339a:	02c92603          	lw	a2,44(s2)
    8000339e:	47f5                	li	a5,29
    800033a0:	06c7c363          	blt	a5,a2,80003406 <log_write+0x88>
    800033a4:	00017797          	auipc	a5,0x17
    800033a8:	7987a783          	lw	a5,1944(a5) # 8001ab3c <log+0x1c>
    800033ac:	37fd                	addiw	a5,a5,-1
    800033ae:	04f65c63          	bge	a2,a5,80003406 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800033b2:	00017797          	auipc	a5,0x17
    800033b6:	78e7a783          	lw	a5,1934(a5) # 8001ab40 <log+0x20>
    800033ba:	04f05c63          	blez	a5,80003412 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800033be:	4781                	li	a5,0
    800033c0:	04c05f63          	blez	a2,8000341e <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800033c4:	44cc                	lw	a1,12(s1)
    800033c6:	00017717          	auipc	a4,0x17
    800033ca:	78a70713          	addi	a4,a4,1930 # 8001ab50 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800033ce:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800033d0:	4314                	lw	a3,0(a4)
    800033d2:	04b68663          	beq	a3,a1,8000341e <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800033d6:	2785                	addiw	a5,a5,1
    800033d8:	0711                	addi	a4,a4,4
    800033da:	fef61be3          	bne	a2,a5,800033d0 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800033de:	0621                	addi	a2,a2,8
    800033e0:	060a                	slli	a2,a2,0x2
    800033e2:	00017797          	auipc	a5,0x17
    800033e6:	73e78793          	addi	a5,a5,1854 # 8001ab20 <log>
    800033ea:	97b2                	add	a5,a5,a2
    800033ec:	44d8                	lw	a4,12(s1)
    800033ee:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800033f0:	8526                	mv	a0,s1
    800033f2:	fcbfe0ef          	jal	800023bc <bpin>
    log.lh.n++;
    800033f6:	00017717          	auipc	a4,0x17
    800033fa:	72a70713          	addi	a4,a4,1834 # 8001ab20 <log>
    800033fe:	575c                	lw	a5,44(a4)
    80003400:	2785                	addiw	a5,a5,1
    80003402:	d75c                	sw	a5,44(a4)
    80003404:	a80d                	j	80003436 <log_write+0xb8>
    panic("too big a transaction");
    80003406:	00004517          	auipc	a0,0x4
    8000340a:	26a50513          	addi	a0,a0,618 # 80007670 <etext+0x670>
    8000340e:	304020ef          	jal	80005712 <panic>
    panic("log_write outside of trans");
    80003412:	00004517          	auipc	a0,0x4
    80003416:	27650513          	addi	a0,a0,630 # 80007688 <etext+0x688>
    8000341a:	2f8020ef          	jal	80005712 <panic>
  log.lh.block[i] = b->blockno;
    8000341e:	00878693          	addi	a3,a5,8
    80003422:	068a                	slli	a3,a3,0x2
    80003424:	00017717          	auipc	a4,0x17
    80003428:	6fc70713          	addi	a4,a4,1788 # 8001ab20 <log>
    8000342c:	9736                	add	a4,a4,a3
    8000342e:	44d4                	lw	a3,12(s1)
    80003430:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003432:	faf60fe3          	beq	a2,a5,800033f0 <log_write+0x72>
  }
  release(&log.lock);
    80003436:	00017517          	auipc	a0,0x17
    8000343a:	6ea50513          	addi	a0,a0,1770 # 8001ab20 <log>
    8000343e:	69a020ef          	jal	80005ad8 <release>
}
    80003442:	60e2                	ld	ra,24(sp)
    80003444:	6442                	ld	s0,16(sp)
    80003446:	64a2                	ld	s1,8(sp)
    80003448:	6902                	ld	s2,0(sp)
    8000344a:	6105                	addi	sp,sp,32
    8000344c:	8082                	ret

000000008000344e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000344e:	1101                	addi	sp,sp,-32
    80003450:	ec06                	sd	ra,24(sp)
    80003452:	e822                	sd	s0,16(sp)
    80003454:	e426                	sd	s1,8(sp)
    80003456:	e04a                	sd	s2,0(sp)
    80003458:	1000                	addi	s0,sp,32
    8000345a:	84aa                	mv	s1,a0
    8000345c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000345e:	00004597          	auipc	a1,0x4
    80003462:	24a58593          	addi	a1,a1,586 # 800076a8 <etext+0x6a8>
    80003466:	0521                	addi	a0,a0,8
    80003468:	558020ef          	jal	800059c0 <initlock>
  lk->name = name;
    8000346c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003470:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003474:	0204a423          	sw	zero,40(s1)
}
    80003478:	60e2                	ld	ra,24(sp)
    8000347a:	6442                	ld	s0,16(sp)
    8000347c:	64a2                	ld	s1,8(sp)
    8000347e:	6902                	ld	s2,0(sp)
    80003480:	6105                	addi	sp,sp,32
    80003482:	8082                	ret

0000000080003484 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003484:	1101                	addi	sp,sp,-32
    80003486:	ec06                	sd	ra,24(sp)
    80003488:	e822                	sd	s0,16(sp)
    8000348a:	e426                	sd	s1,8(sp)
    8000348c:	e04a                	sd	s2,0(sp)
    8000348e:	1000                	addi	s0,sp,32
    80003490:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003492:	00850913          	addi	s2,a0,8
    80003496:	854a                	mv	a0,s2
    80003498:	5a8020ef          	jal	80005a40 <acquire>
  while (lk->locked) {
    8000349c:	409c                	lw	a5,0(s1)
    8000349e:	c799                	beqz	a5,800034ac <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800034a0:	85ca                	mv	a1,s2
    800034a2:	8526                	mv	a0,s1
    800034a4:	e8dfd0ef          	jal	80001330 <sleep>
  while (lk->locked) {
    800034a8:	409c                	lw	a5,0(s1)
    800034aa:	fbfd                	bnez	a5,800034a0 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800034ac:	4785                	li	a5,1
    800034ae:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800034b0:	8a7fd0ef          	jal	80000d56 <myproc>
    800034b4:	591c                	lw	a5,48(a0)
    800034b6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800034b8:	854a                	mv	a0,s2
    800034ba:	61e020ef          	jal	80005ad8 <release>
}
    800034be:	60e2                	ld	ra,24(sp)
    800034c0:	6442                	ld	s0,16(sp)
    800034c2:	64a2                	ld	s1,8(sp)
    800034c4:	6902                	ld	s2,0(sp)
    800034c6:	6105                	addi	sp,sp,32
    800034c8:	8082                	ret

00000000800034ca <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800034ca:	1101                	addi	sp,sp,-32
    800034cc:	ec06                	sd	ra,24(sp)
    800034ce:	e822                	sd	s0,16(sp)
    800034d0:	e426                	sd	s1,8(sp)
    800034d2:	e04a                	sd	s2,0(sp)
    800034d4:	1000                	addi	s0,sp,32
    800034d6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800034d8:	00850913          	addi	s2,a0,8
    800034dc:	854a                	mv	a0,s2
    800034de:	562020ef          	jal	80005a40 <acquire>
  lk->locked = 0;
    800034e2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800034e6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800034ea:	8526                	mv	a0,s1
    800034ec:	e91fd0ef          	jal	8000137c <wakeup>
  release(&lk->lk);
    800034f0:	854a                	mv	a0,s2
    800034f2:	5e6020ef          	jal	80005ad8 <release>
}
    800034f6:	60e2                	ld	ra,24(sp)
    800034f8:	6442                	ld	s0,16(sp)
    800034fa:	64a2                	ld	s1,8(sp)
    800034fc:	6902                	ld	s2,0(sp)
    800034fe:	6105                	addi	sp,sp,32
    80003500:	8082                	ret

0000000080003502 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003502:	7179                	addi	sp,sp,-48
    80003504:	f406                	sd	ra,40(sp)
    80003506:	f022                	sd	s0,32(sp)
    80003508:	ec26                	sd	s1,24(sp)
    8000350a:	e84a                	sd	s2,16(sp)
    8000350c:	1800                	addi	s0,sp,48
    8000350e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003510:	00850913          	addi	s2,a0,8
    80003514:	854a                	mv	a0,s2
    80003516:	52a020ef          	jal	80005a40 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000351a:	409c                	lw	a5,0(s1)
    8000351c:	ef81                	bnez	a5,80003534 <holdingsleep+0x32>
    8000351e:	4481                	li	s1,0
  release(&lk->lk);
    80003520:	854a                	mv	a0,s2
    80003522:	5b6020ef          	jal	80005ad8 <release>
  return r;
}
    80003526:	8526                	mv	a0,s1
    80003528:	70a2                	ld	ra,40(sp)
    8000352a:	7402                	ld	s0,32(sp)
    8000352c:	64e2                	ld	s1,24(sp)
    8000352e:	6942                	ld	s2,16(sp)
    80003530:	6145                	addi	sp,sp,48
    80003532:	8082                	ret
    80003534:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003536:	0284a983          	lw	s3,40(s1)
    8000353a:	81dfd0ef          	jal	80000d56 <myproc>
    8000353e:	5904                	lw	s1,48(a0)
    80003540:	413484b3          	sub	s1,s1,s3
    80003544:	0014b493          	seqz	s1,s1
    80003548:	69a2                	ld	s3,8(sp)
    8000354a:	bfd9                	j	80003520 <holdingsleep+0x1e>

000000008000354c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000354c:	1141                	addi	sp,sp,-16
    8000354e:	e406                	sd	ra,8(sp)
    80003550:	e022                	sd	s0,0(sp)
    80003552:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003554:	00004597          	auipc	a1,0x4
    80003558:	16458593          	addi	a1,a1,356 # 800076b8 <etext+0x6b8>
    8000355c:	00017517          	auipc	a0,0x17
    80003560:	70c50513          	addi	a0,a0,1804 # 8001ac68 <ftable>
    80003564:	45c020ef          	jal	800059c0 <initlock>
}
    80003568:	60a2                	ld	ra,8(sp)
    8000356a:	6402                	ld	s0,0(sp)
    8000356c:	0141                	addi	sp,sp,16
    8000356e:	8082                	ret

0000000080003570 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003570:	1101                	addi	sp,sp,-32
    80003572:	ec06                	sd	ra,24(sp)
    80003574:	e822                	sd	s0,16(sp)
    80003576:	e426                	sd	s1,8(sp)
    80003578:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000357a:	00017517          	auipc	a0,0x17
    8000357e:	6ee50513          	addi	a0,a0,1774 # 8001ac68 <ftable>
    80003582:	4be020ef          	jal	80005a40 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003586:	00017497          	auipc	s1,0x17
    8000358a:	6fa48493          	addi	s1,s1,1786 # 8001ac80 <ftable+0x18>
    8000358e:	00018717          	auipc	a4,0x18
    80003592:	69270713          	addi	a4,a4,1682 # 8001bc20 <disk>
    if(f->ref == 0){
    80003596:	40dc                	lw	a5,4(s1)
    80003598:	cf89                	beqz	a5,800035b2 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000359a:	02848493          	addi	s1,s1,40
    8000359e:	fee49ce3          	bne	s1,a4,80003596 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800035a2:	00017517          	auipc	a0,0x17
    800035a6:	6c650513          	addi	a0,a0,1734 # 8001ac68 <ftable>
    800035aa:	52e020ef          	jal	80005ad8 <release>
  return 0;
    800035ae:	4481                	li	s1,0
    800035b0:	a809                	j	800035c2 <filealloc+0x52>
      f->ref = 1;
    800035b2:	4785                	li	a5,1
    800035b4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800035b6:	00017517          	auipc	a0,0x17
    800035ba:	6b250513          	addi	a0,a0,1714 # 8001ac68 <ftable>
    800035be:	51a020ef          	jal	80005ad8 <release>
}
    800035c2:	8526                	mv	a0,s1
    800035c4:	60e2                	ld	ra,24(sp)
    800035c6:	6442                	ld	s0,16(sp)
    800035c8:	64a2                	ld	s1,8(sp)
    800035ca:	6105                	addi	sp,sp,32
    800035cc:	8082                	ret

00000000800035ce <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800035ce:	1101                	addi	sp,sp,-32
    800035d0:	ec06                	sd	ra,24(sp)
    800035d2:	e822                	sd	s0,16(sp)
    800035d4:	e426                	sd	s1,8(sp)
    800035d6:	1000                	addi	s0,sp,32
    800035d8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800035da:	00017517          	auipc	a0,0x17
    800035de:	68e50513          	addi	a0,a0,1678 # 8001ac68 <ftable>
    800035e2:	45e020ef          	jal	80005a40 <acquire>
  if(f->ref < 1)
    800035e6:	40dc                	lw	a5,4(s1)
    800035e8:	02f05063          	blez	a5,80003608 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800035ec:	2785                	addiw	a5,a5,1
    800035ee:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800035f0:	00017517          	auipc	a0,0x17
    800035f4:	67850513          	addi	a0,a0,1656 # 8001ac68 <ftable>
    800035f8:	4e0020ef          	jal	80005ad8 <release>
  return f;
}
    800035fc:	8526                	mv	a0,s1
    800035fe:	60e2                	ld	ra,24(sp)
    80003600:	6442                	ld	s0,16(sp)
    80003602:	64a2                	ld	s1,8(sp)
    80003604:	6105                	addi	sp,sp,32
    80003606:	8082                	ret
    panic("filedup");
    80003608:	00004517          	auipc	a0,0x4
    8000360c:	0b850513          	addi	a0,a0,184 # 800076c0 <etext+0x6c0>
    80003610:	102020ef          	jal	80005712 <panic>

0000000080003614 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003614:	7139                	addi	sp,sp,-64
    80003616:	fc06                	sd	ra,56(sp)
    80003618:	f822                	sd	s0,48(sp)
    8000361a:	f426                	sd	s1,40(sp)
    8000361c:	0080                	addi	s0,sp,64
    8000361e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003620:	00017517          	auipc	a0,0x17
    80003624:	64850513          	addi	a0,a0,1608 # 8001ac68 <ftable>
    80003628:	418020ef          	jal	80005a40 <acquire>
  if(f->ref < 1)
    8000362c:	40dc                	lw	a5,4(s1)
    8000362e:	04f05a63          	blez	a5,80003682 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003632:	37fd                	addiw	a5,a5,-1
    80003634:	0007871b          	sext.w	a4,a5
    80003638:	c0dc                	sw	a5,4(s1)
    8000363a:	04e04e63          	bgtz	a4,80003696 <fileclose+0x82>
    8000363e:	f04a                	sd	s2,32(sp)
    80003640:	ec4e                	sd	s3,24(sp)
    80003642:	e852                	sd	s4,16(sp)
    80003644:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003646:	0004a903          	lw	s2,0(s1)
    8000364a:	0094ca83          	lbu	s5,9(s1)
    8000364e:	0104ba03          	ld	s4,16(s1)
    80003652:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003656:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000365a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000365e:	00017517          	auipc	a0,0x17
    80003662:	60a50513          	addi	a0,a0,1546 # 8001ac68 <ftable>
    80003666:	472020ef          	jal	80005ad8 <release>

  if(ff.type == FD_PIPE){
    8000366a:	4785                	li	a5,1
    8000366c:	04f90063          	beq	s2,a5,800036ac <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003670:	3979                	addiw	s2,s2,-2
    80003672:	4785                	li	a5,1
    80003674:	0527f563          	bgeu	a5,s2,800036be <fileclose+0xaa>
    80003678:	7902                	ld	s2,32(sp)
    8000367a:	69e2                	ld	s3,24(sp)
    8000367c:	6a42                	ld	s4,16(sp)
    8000367e:	6aa2                	ld	s5,8(sp)
    80003680:	a00d                	j	800036a2 <fileclose+0x8e>
    80003682:	f04a                	sd	s2,32(sp)
    80003684:	ec4e                	sd	s3,24(sp)
    80003686:	e852                	sd	s4,16(sp)
    80003688:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000368a:	00004517          	auipc	a0,0x4
    8000368e:	03e50513          	addi	a0,a0,62 # 800076c8 <etext+0x6c8>
    80003692:	080020ef          	jal	80005712 <panic>
    release(&ftable.lock);
    80003696:	00017517          	auipc	a0,0x17
    8000369a:	5d250513          	addi	a0,a0,1490 # 8001ac68 <ftable>
    8000369e:	43a020ef          	jal	80005ad8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800036a2:	70e2                	ld	ra,56(sp)
    800036a4:	7442                	ld	s0,48(sp)
    800036a6:	74a2                	ld	s1,40(sp)
    800036a8:	6121                	addi	sp,sp,64
    800036aa:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800036ac:	85d6                	mv	a1,s5
    800036ae:	8552                	mv	a0,s4
    800036b0:	336000ef          	jal	800039e6 <pipeclose>
    800036b4:	7902                	ld	s2,32(sp)
    800036b6:	69e2                	ld	s3,24(sp)
    800036b8:	6a42                	ld	s4,16(sp)
    800036ba:	6aa2                	ld	s5,8(sp)
    800036bc:	b7dd                	j	800036a2 <fileclose+0x8e>
    begin_op();
    800036be:	b3dff0ef          	jal	800031fa <begin_op>
    iput(ff.ip);
    800036c2:	854e                	mv	a0,s3
    800036c4:	c22ff0ef          	jal	80002ae6 <iput>
    end_op();
    800036c8:	b9dff0ef          	jal	80003264 <end_op>
    800036cc:	7902                	ld	s2,32(sp)
    800036ce:	69e2                	ld	s3,24(sp)
    800036d0:	6a42                	ld	s4,16(sp)
    800036d2:	6aa2                	ld	s5,8(sp)
    800036d4:	b7f9                	j	800036a2 <fileclose+0x8e>

00000000800036d6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800036d6:	715d                	addi	sp,sp,-80
    800036d8:	e486                	sd	ra,72(sp)
    800036da:	e0a2                	sd	s0,64(sp)
    800036dc:	fc26                	sd	s1,56(sp)
    800036de:	f44e                	sd	s3,40(sp)
    800036e0:	0880                	addi	s0,sp,80
    800036e2:	84aa                	mv	s1,a0
    800036e4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800036e6:	e70fd0ef          	jal	80000d56 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800036ea:	409c                	lw	a5,0(s1)
    800036ec:	37f9                	addiw	a5,a5,-2
    800036ee:	4705                	li	a4,1
    800036f0:	04f76063          	bltu	a4,a5,80003730 <filestat+0x5a>
    800036f4:	f84a                	sd	s2,48(sp)
    800036f6:	892a                	mv	s2,a0
    ilock(f->ip);
    800036f8:	6c88                	ld	a0,24(s1)
    800036fa:	a6aff0ef          	jal	80002964 <ilock>
    stati(f->ip, &st);
    800036fe:	fb840593          	addi	a1,s0,-72
    80003702:	6c88                	ld	a0,24(s1)
    80003704:	c8aff0ef          	jal	80002b8e <stati>
    iunlock(f->ip);
    80003708:	6c88                	ld	a0,24(s1)
    8000370a:	b08ff0ef          	jal	80002a12 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000370e:	46e1                	li	a3,24
    80003710:	fb840613          	addi	a2,s0,-72
    80003714:	85ce                	mv	a1,s3
    80003716:	05093503          	ld	a0,80(s2)
    8000371a:	aacfd0ef          	jal	800009c6 <copyout>
    8000371e:	41f5551b          	sraiw	a0,a0,0x1f
    80003722:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003724:	60a6                	ld	ra,72(sp)
    80003726:	6406                	ld	s0,64(sp)
    80003728:	74e2                	ld	s1,56(sp)
    8000372a:	79a2                	ld	s3,40(sp)
    8000372c:	6161                	addi	sp,sp,80
    8000372e:	8082                	ret
  return -1;
    80003730:	557d                	li	a0,-1
    80003732:	bfcd                	j	80003724 <filestat+0x4e>

0000000080003734 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003734:	7179                	addi	sp,sp,-48
    80003736:	f406                	sd	ra,40(sp)
    80003738:	f022                	sd	s0,32(sp)
    8000373a:	e84a                	sd	s2,16(sp)
    8000373c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000373e:	00854783          	lbu	a5,8(a0)
    80003742:	cfd1                	beqz	a5,800037de <fileread+0xaa>
    80003744:	ec26                	sd	s1,24(sp)
    80003746:	e44e                	sd	s3,8(sp)
    80003748:	84aa                	mv	s1,a0
    8000374a:	89ae                	mv	s3,a1
    8000374c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000374e:	411c                	lw	a5,0(a0)
    80003750:	4705                	li	a4,1
    80003752:	04e78363          	beq	a5,a4,80003798 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003756:	470d                	li	a4,3
    80003758:	04e78763          	beq	a5,a4,800037a6 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000375c:	4709                	li	a4,2
    8000375e:	06e79a63          	bne	a5,a4,800037d2 <fileread+0x9e>
    ilock(f->ip);
    80003762:	6d08                	ld	a0,24(a0)
    80003764:	a00ff0ef          	jal	80002964 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003768:	874a                	mv	a4,s2
    8000376a:	5094                	lw	a3,32(s1)
    8000376c:	864e                	mv	a2,s3
    8000376e:	4585                	li	a1,1
    80003770:	6c88                	ld	a0,24(s1)
    80003772:	c46ff0ef          	jal	80002bb8 <readi>
    80003776:	892a                	mv	s2,a0
    80003778:	00a05563          	blez	a0,80003782 <fileread+0x4e>
      f->off += r;
    8000377c:	509c                	lw	a5,32(s1)
    8000377e:	9fa9                	addw	a5,a5,a0
    80003780:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003782:	6c88                	ld	a0,24(s1)
    80003784:	a8eff0ef          	jal	80002a12 <iunlock>
    80003788:	64e2                	ld	s1,24(sp)
    8000378a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000378c:	854a                	mv	a0,s2
    8000378e:	70a2                	ld	ra,40(sp)
    80003790:	7402                	ld	s0,32(sp)
    80003792:	6942                	ld	s2,16(sp)
    80003794:	6145                	addi	sp,sp,48
    80003796:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003798:	6908                	ld	a0,16(a0)
    8000379a:	388000ef          	jal	80003b22 <piperead>
    8000379e:	892a                	mv	s2,a0
    800037a0:	64e2                	ld	s1,24(sp)
    800037a2:	69a2                	ld	s3,8(sp)
    800037a4:	b7e5                	j	8000378c <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800037a6:	02451783          	lh	a5,36(a0)
    800037aa:	03079693          	slli	a3,a5,0x30
    800037ae:	92c1                	srli	a3,a3,0x30
    800037b0:	4725                	li	a4,9
    800037b2:	02d76863          	bltu	a4,a3,800037e2 <fileread+0xae>
    800037b6:	0792                	slli	a5,a5,0x4
    800037b8:	00017717          	auipc	a4,0x17
    800037bc:	41070713          	addi	a4,a4,1040 # 8001abc8 <devsw>
    800037c0:	97ba                	add	a5,a5,a4
    800037c2:	639c                	ld	a5,0(a5)
    800037c4:	c39d                	beqz	a5,800037ea <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800037c6:	4505                	li	a0,1
    800037c8:	9782                	jalr	a5
    800037ca:	892a                	mv	s2,a0
    800037cc:	64e2                	ld	s1,24(sp)
    800037ce:	69a2                	ld	s3,8(sp)
    800037d0:	bf75                	j	8000378c <fileread+0x58>
    panic("fileread");
    800037d2:	00004517          	auipc	a0,0x4
    800037d6:	f0650513          	addi	a0,a0,-250 # 800076d8 <etext+0x6d8>
    800037da:	739010ef          	jal	80005712 <panic>
    return -1;
    800037de:	597d                	li	s2,-1
    800037e0:	b775                	j	8000378c <fileread+0x58>
      return -1;
    800037e2:	597d                	li	s2,-1
    800037e4:	64e2                	ld	s1,24(sp)
    800037e6:	69a2                	ld	s3,8(sp)
    800037e8:	b755                	j	8000378c <fileread+0x58>
    800037ea:	597d                	li	s2,-1
    800037ec:	64e2                	ld	s1,24(sp)
    800037ee:	69a2                	ld	s3,8(sp)
    800037f0:	bf71                	j	8000378c <fileread+0x58>

00000000800037f2 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800037f2:	00954783          	lbu	a5,9(a0)
    800037f6:	10078b63          	beqz	a5,8000390c <filewrite+0x11a>
{
    800037fa:	715d                	addi	sp,sp,-80
    800037fc:	e486                	sd	ra,72(sp)
    800037fe:	e0a2                	sd	s0,64(sp)
    80003800:	f84a                	sd	s2,48(sp)
    80003802:	f052                	sd	s4,32(sp)
    80003804:	e85a                	sd	s6,16(sp)
    80003806:	0880                	addi	s0,sp,80
    80003808:	892a                	mv	s2,a0
    8000380a:	8b2e                	mv	s6,a1
    8000380c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000380e:	411c                	lw	a5,0(a0)
    80003810:	4705                	li	a4,1
    80003812:	02e78763          	beq	a5,a4,80003840 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003816:	470d                	li	a4,3
    80003818:	02e78863          	beq	a5,a4,80003848 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000381c:	4709                	li	a4,2
    8000381e:	0ce79c63          	bne	a5,a4,800038f6 <filewrite+0x104>
    80003822:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003824:	0ac05863          	blez	a2,800038d4 <filewrite+0xe2>
    80003828:	fc26                	sd	s1,56(sp)
    8000382a:	ec56                	sd	s5,24(sp)
    8000382c:	e45e                	sd	s7,8(sp)
    8000382e:	e062                	sd	s8,0(sp)
    int i = 0;
    80003830:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003832:	6b85                	lui	s7,0x1
    80003834:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003838:	6c05                	lui	s8,0x1
    8000383a:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000383e:	a8b5                	j	800038ba <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80003840:	6908                	ld	a0,16(a0)
    80003842:	1fc000ef          	jal	80003a3e <pipewrite>
    80003846:	a04d                	j	800038e8 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003848:	02451783          	lh	a5,36(a0)
    8000384c:	03079693          	slli	a3,a5,0x30
    80003850:	92c1                	srli	a3,a3,0x30
    80003852:	4725                	li	a4,9
    80003854:	0ad76e63          	bltu	a4,a3,80003910 <filewrite+0x11e>
    80003858:	0792                	slli	a5,a5,0x4
    8000385a:	00017717          	auipc	a4,0x17
    8000385e:	36e70713          	addi	a4,a4,878 # 8001abc8 <devsw>
    80003862:	97ba                	add	a5,a5,a4
    80003864:	679c                	ld	a5,8(a5)
    80003866:	c7dd                	beqz	a5,80003914 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80003868:	4505                	li	a0,1
    8000386a:	9782                	jalr	a5
    8000386c:	a8b5                	j	800038e8 <filewrite+0xf6>
      if(n1 > max)
    8000386e:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003872:	989ff0ef          	jal	800031fa <begin_op>
      ilock(f->ip);
    80003876:	01893503          	ld	a0,24(s2)
    8000387a:	8eaff0ef          	jal	80002964 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000387e:	8756                	mv	a4,s5
    80003880:	02092683          	lw	a3,32(s2)
    80003884:	01698633          	add	a2,s3,s6
    80003888:	4585                	li	a1,1
    8000388a:	01893503          	ld	a0,24(s2)
    8000388e:	c26ff0ef          	jal	80002cb4 <writei>
    80003892:	84aa                	mv	s1,a0
    80003894:	00a05763          	blez	a0,800038a2 <filewrite+0xb0>
        f->off += r;
    80003898:	02092783          	lw	a5,32(s2)
    8000389c:	9fa9                	addw	a5,a5,a0
    8000389e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800038a2:	01893503          	ld	a0,24(s2)
    800038a6:	96cff0ef          	jal	80002a12 <iunlock>
      end_op();
    800038aa:	9bbff0ef          	jal	80003264 <end_op>

      if(r != n1){
    800038ae:	029a9563          	bne	s5,s1,800038d8 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800038b2:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800038b6:	0149da63          	bge	s3,s4,800038ca <filewrite+0xd8>
      int n1 = n - i;
    800038ba:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800038be:	0004879b          	sext.w	a5,s1
    800038c2:	fafbd6e3          	bge	s7,a5,8000386e <filewrite+0x7c>
    800038c6:	84e2                	mv	s1,s8
    800038c8:	b75d                	j	8000386e <filewrite+0x7c>
    800038ca:	74e2                	ld	s1,56(sp)
    800038cc:	6ae2                	ld	s5,24(sp)
    800038ce:	6ba2                	ld	s7,8(sp)
    800038d0:	6c02                	ld	s8,0(sp)
    800038d2:	a039                	j	800038e0 <filewrite+0xee>
    int i = 0;
    800038d4:	4981                	li	s3,0
    800038d6:	a029                	j	800038e0 <filewrite+0xee>
    800038d8:	74e2                	ld	s1,56(sp)
    800038da:	6ae2                	ld	s5,24(sp)
    800038dc:	6ba2                	ld	s7,8(sp)
    800038de:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800038e0:	033a1c63          	bne	s4,s3,80003918 <filewrite+0x126>
    800038e4:	8552                	mv	a0,s4
    800038e6:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800038e8:	60a6                	ld	ra,72(sp)
    800038ea:	6406                	ld	s0,64(sp)
    800038ec:	7942                	ld	s2,48(sp)
    800038ee:	7a02                	ld	s4,32(sp)
    800038f0:	6b42                	ld	s6,16(sp)
    800038f2:	6161                	addi	sp,sp,80
    800038f4:	8082                	ret
    800038f6:	fc26                	sd	s1,56(sp)
    800038f8:	f44e                	sd	s3,40(sp)
    800038fa:	ec56                	sd	s5,24(sp)
    800038fc:	e45e                	sd	s7,8(sp)
    800038fe:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003900:	00004517          	auipc	a0,0x4
    80003904:	de850513          	addi	a0,a0,-536 # 800076e8 <etext+0x6e8>
    80003908:	60b010ef          	jal	80005712 <panic>
    return -1;
    8000390c:	557d                	li	a0,-1
}
    8000390e:	8082                	ret
      return -1;
    80003910:	557d                	li	a0,-1
    80003912:	bfd9                	j	800038e8 <filewrite+0xf6>
    80003914:	557d                	li	a0,-1
    80003916:	bfc9                	j	800038e8 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80003918:	557d                	li	a0,-1
    8000391a:	79a2                	ld	s3,40(sp)
    8000391c:	b7f1                	j	800038e8 <filewrite+0xf6>

000000008000391e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000391e:	7179                	addi	sp,sp,-48
    80003920:	f406                	sd	ra,40(sp)
    80003922:	f022                	sd	s0,32(sp)
    80003924:	ec26                	sd	s1,24(sp)
    80003926:	e052                	sd	s4,0(sp)
    80003928:	1800                	addi	s0,sp,48
    8000392a:	84aa                	mv	s1,a0
    8000392c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000392e:	0005b023          	sd	zero,0(a1)
    80003932:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003936:	c3bff0ef          	jal	80003570 <filealloc>
    8000393a:	e088                	sd	a0,0(s1)
    8000393c:	c549                	beqz	a0,800039c6 <pipealloc+0xa8>
    8000393e:	c33ff0ef          	jal	80003570 <filealloc>
    80003942:	00aa3023          	sd	a0,0(s4)
    80003946:	cd25                	beqz	a0,800039be <pipealloc+0xa0>
    80003948:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000394a:	facfc0ef          	jal	800000f6 <kalloc>
    8000394e:	892a                	mv	s2,a0
    80003950:	c12d                	beqz	a0,800039b2 <pipealloc+0x94>
    80003952:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003954:	4985                	li	s3,1
    80003956:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000395a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000395e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003962:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003966:	00004597          	auipc	a1,0x4
    8000396a:	b2a58593          	addi	a1,a1,-1238 # 80007490 <etext+0x490>
    8000396e:	052020ef          	jal	800059c0 <initlock>
  (*f0)->type = FD_PIPE;
    80003972:	609c                	ld	a5,0(s1)
    80003974:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003978:	609c                	ld	a5,0(s1)
    8000397a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000397e:	609c                	ld	a5,0(s1)
    80003980:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003984:	609c                	ld	a5,0(s1)
    80003986:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000398a:	000a3783          	ld	a5,0(s4)
    8000398e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003992:	000a3783          	ld	a5,0(s4)
    80003996:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000399a:	000a3783          	ld	a5,0(s4)
    8000399e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800039a2:	000a3783          	ld	a5,0(s4)
    800039a6:	0127b823          	sd	s2,16(a5)
  return 0;
    800039aa:	4501                	li	a0,0
    800039ac:	6942                	ld	s2,16(sp)
    800039ae:	69a2                	ld	s3,8(sp)
    800039b0:	a01d                	j	800039d6 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800039b2:	6088                	ld	a0,0(s1)
    800039b4:	c119                	beqz	a0,800039ba <pipealloc+0x9c>
    800039b6:	6942                	ld	s2,16(sp)
    800039b8:	a029                	j	800039c2 <pipealloc+0xa4>
    800039ba:	6942                	ld	s2,16(sp)
    800039bc:	a029                	j	800039c6 <pipealloc+0xa8>
    800039be:	6088                	ld	a0,0(s1)
    800039c0:	c10d                	beqz	a0,800039e2 <pipealloc+0xc4>
    fileclose(*f0);
    800039c2:	c53ff0ef          	jal	80003614 <fileclose>
  if(*f1)
    800039c6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800039ca:	557d                	li	a0,-1
  if(*f1)
    800039cc:	c789                	beqz	a5,800039d6 <pipealloc+0xb8>
    fileclose(*f1);
    800039ce:	853e                	mv	a0,a5
    800039d0:	c45ff0ef          	jal	80003614 <fileclose>
  return -1;
    800039d4:	557d                	li	a0,-1
}
    800039d6:	70a2                	ld	ra,40(sp)
    800039d8:	7402                	ld	s0,32(sp)
    800039da:	64e2                	ld	s1,24(sp)
    800039dc:	6a02                	ld	s4,0(sp)
    800039de:	6145                	addi	sp,sp,48
    800039e0:	8082                	ret
  return -1;
    800039e2:	557d                	li	a0,-1
    800039e4:	bfcd                	j	800039d6 <pipealloc+0xb8>

00000000800039e6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800039e6:	1101                	addi	sp,sp,-32
    800039e8:	ec06                	sd	ra,24(sp)
    800039ea:	e822                	sd	s0,16(sp)
    800039ec:	e426                	sd	s1,8(sp)
    800039ee:	e04a                	sd	s2,0(sp)
    800039f0:	1000                	addi	s0,sp,32
    800039f2:	84aa                	mv	s1,a0
    800039f4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800039f6:	04a020ef          	jal	80005a40 <acquire>
  if(writable){
    800039fa:	02090763          	beqz	s2,80003a28 <pipeclose+0x42>
    pi->writeopen = 0;
    800039fe:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003a02:	21848513          	addi	a0,s1,536
    80003a06:	977fd0ef          	jal	8000137c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003a0a:	2204b783          	ld	a5,544(s1)
    80003a0e:	e785                	bnez	a5,80003a36 <pipeclose+0x50>
    release(&pi->lock);
    80003a10:	8526                	mv	a0,s1
    80003a12:	0c6020ef          	jal	80005ad8 <release>
    kfree((char*)pi);
    80003a16:	8526                	mv	a0,s1
    80003a18:	e04fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003a1c:	60e2                	ld	ra,24(sp)
    80003a1e:	6442                	ld	s0,16(sp)
    80003a20:	64a2                	ld	s1,8(sp)
    80003a22:	6902                	ld	s2,0(sp)
    80003a24:	6105                	addi	sp,sp,32
    80003a26:	8082                	ret
    pi->readopen = 0;
    80003a28:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003a2c:	21c48513          	addi	a0,s1,540
    80003a30:	94dfd0ef          	jal	8000137c <wakeup>
    80003a34:	bfd9                	j	80003a0a <pipeclose+0x24>
    release(&pi->lock);
    80003a36:	8526                	mv	a0,s1
    80003a38:	0a0020ef          	jal	80005ad8 <release>
}
    80003a3c:	b7c5                	j	80003a1c <pipeclose+0x36>

0000000080003a3e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003a3e:	711d                	addi	sp,sp,-96
    80003a40:	ec86                	sd	ra,88(sp)
    80003a42:	e8a2                	sd	s0,80(sp)
    80003a44:	e4a6                	sd	s1,72(sp)
    80003a46:	e0ca                	sd	s2,64(sp)
    80003a48:	fc4e                	sd	s3,56(sp)
    80003a4a:	f852                	sd	s4,48(sp)
    80003a4c:	f456                	sd	s5,40(sp)
    80003a4e:	1080                	addi	s0,sp,96
    80003a50:	84aa                	mv	s1,a0
    80003a52:	8aae                	mv	s5,a1
    80003a54:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003a56:	b00fd0ef          	jal	80000d56 <myproc>
    80003a5a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003a5c:	8526                	mv	a0,s1
    80003a5e:	7e3010ef          	jal	80005a40 <acquire>
  while(i < n){
    80003a62:	0b405a63          	blez	s4,80003b16 <pipewrite+0xd8>
    80003a66:	f05a                	sd	s6,32(sp)
    80003a68:	ec5e                	sd	s7,24(sp)
    80003a6a:	e862                	sd	s8,16(sp)
  int i = 0;
    80003a6c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003a6e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003a70:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003a74:	21c48b93          	addi	s7,s1,540
    80003a78:	a81d                	j	80003aae <pipewrite+0x70>
      release(&pi->lock);
    80003a7a:	8526                	mv	a0,s1
    80003a7c:	05c020ef          	jal	80005ad8 <release>
      return -1;
    80003a80:	597d                	li	s2,-1
    80003a82:	7b02                	ld	s6,32(sp)
    80003a84:	6be2                	ld	s7,24(sp)
    80003a86:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003a88:	854a                	mv	a0,s2
    80003a8a:	60e6                	ld	ra,88(sp)
    80003a8c:	6446                	ld	s0,80(sp)
    80003a8e:	64a6                	ld	s1,72(sp)
    80003a90:	6906                	ld	s2,64(sp)
    80003a92:	79e2                	ld	s3,56(sp)
    80003a94:	7a42                	ld	s4,48(sp)
    80003a96:	7aa2                	ld	s5,40(sp)
    80003a98:	6125                	addi	sp,sp,96
    80003a9a:	8082                	ret
      wakeup(&pi->nread);
    80003a9c:	8562                	mv	a0,s8
    80003a9e:	8dffd0ef          	jal	8000137c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003aa2:	85a6                	mv	a1,s1
    80003aa4:	855e                	mv	a0,s7
    80003aa6:	88bfd0ef          	jal	80001330 <sleep>
  while(i < n){
    80003aaa:	05495b63          	bge	s2,s4,80003b00 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003aae:	2204a783          	lw	a5,544(s1)
    80003ab2:	d7e1                	beqz	a5,80003a7a <pipewrite+0x3c>
    80003ab4:	854e                	mv	a0,s3
    80003ab6:	ab3fd0ef          	jal	80001568 <killed>
    80003aba:	f161                	bnez	a0,80003a7a <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003abc:	2184a783          	lw	a5,536(s1)
    80003ac0:	21c4a703          	lw	a4,540(s1)
    80003ac4:	2007879b          	addiw	a5,a5,512
    80003ac8:	fcf70ae3          	beq	a4,a5,80003a9c <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003acc:	4685                	li	a3,1
    80003ace:	01590633          	add	a2,s2,s5
    80003ad2:	faf40593          	addi	a1,s0,-81
    80003ad6:	0509b503          	ld	a0,80(s3)
    80003ada:	fc5fc0ef          	jal	80000a9e <copyin>
    80003ade:	03650e63          	beq	a0,s6,80003b1a <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ae2:	21c4a783          	lw	a5,540(s1)
    80003ae6:	0017871b          	addiw	a4,a5,1
    80003aea:	20e4ae23          	sw	a4,540(s1)
    80003aee:	1ff7f793          	andi	a5,a5,511
    80003af2:	97a6                	add	a5,a5,s1
    80003af4:	faf44703          	lbu	a4,-81(s0)
    80003af8:	00e78c23          	sb	a4,24(a5)
      i++;
    80003afc:	2905                	addiw	s2,s2,1
    80003afe:	b775                	j	80003aaa <pipewrite+0x6c>
    80003b00:	7b02                	ld	s6,32(sp)
    80003b02:	6be2                	ld	s7,24(sp)
    80003b04:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003b06:	21848513          	addi	a0,s1,536
    80003b0a:	873fd0ef          	jal	8000137c <wakeup>
  release(&pi->lock);
    80003b0e:	8526                	mv	a0,s1
    80003b10:	7c9010ef          	jal	80005ad8 <release>
  return i;
    80003b14:	bf95                	j	80003a88 <pipewrite+0x4a>
  int i = 0;
    80003b16:	4901                	li	s2,0
    80003b18:	b7fd                	j	80003b06 <pipewrite+0xc8>
    80003b1a:	7b02                	ld	s6,32(sp)
    80003b1c:	6be2                	ld	s7,24(sp)
    80003b1e:	6c42                	ld	s8,16(sp)
    80003b20:	b7dd                	j	80003b06 <pipewrite+0xc8>

0000000080003b22 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003b22:	715d                	addi	sp,sp,-80
    80003b24:	e486                	sd	ra,72(sp)
    80003b26:	e0a2                	sd	s0,64(sp)
    80003b28:	fc26                	sd	s1,56(sp)
    80003b2a:	f84a                	sd	s2,48(sp)
    80003b2c:	f44e                	sd	s3,40(sp)
    80003b2e:	f052                	sd	s4,32(sp)
    80003b30:	ec56                	sd	s5,24(sp)
    80003b32:	0880                	addi	s0,sp,80
    80003b34:	84aa                	mv	s1,a0
    80003b36:	892e                	mv	s2,a1
    80003b38:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003b3a:	a1cfd0ef          	jal	80000d56 <myproc>
    80003b3e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003b40:	8526                	mv	a0,s1
    80003b42:	6ff010ef          	jal	80005a40 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b46:	2184a703          	lw	a4,536(s1)
    80003b4a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003b4e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b52:	02f71563          	bne	a4,a5,80003b7c <piperead+0x5a>
    80003b56:	2244a783          	lw	a5,548(s1)
    80003b5a:	cb85                	beqz	a5,80003b8a <piperead+0x68>
    if(killed(pr)){
    80003b5c:	8552                	mv	a0,s4
    80003b5e:	a0bfd0ef          	jal	80001568 <killed>
    80003b62:	ed19                	bnez	a0,80003b80 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003b64:	85a6                	mv	a1,s1
    80003b66:	854e                	mv	a0,s3
    80003b68:	fc8fd0ef          	jal	80001330 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b6c:	2184a703          	lw	a4,536(s1)
    80003b70:	21c4a783          	lw	a5,540(s1)
    80003b74:	fef701e3          	beq	a4,a5,80003b56 <piperead+0x34>
    80003b78:	e85a                	sd	s6,16(sp)
    80003b7a:	a809                	j	80003b8c <piperead+0x6a>
    80003b7c:	e85a                	sd	s6,16(sp)
    80003b7e:	a039                	j	80003b8c <piperead+0x6a>
      release(&pi->lock);
    80003b80:	8526                	mv	a0,s1
    80003b82:	757010ef          	jal	80005ad8 <release>
      return -1;
    80003b86:	59fd                	li	s3,-1
    80003b88:	a8b1                	j	80003be4 <piperead+0xc2>
    80003b8a:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b8c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003b8e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b90:	05505263          	blez	s5,80003bd4 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003b94:	2184a783          	lw	a5,536(s1)
    80003b98:	21c4a703          	lw	a4,540(s1)
    80003b9c:	02f70c63          	beq	a4,a5,80003bd4 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003ba0:	0017871b          	addiw	a4,a5,1
    80003ba4:	20e4ac23          	sw	a4,536(s1)
    80003ba8:	1ff7f793          	andi	a5,a5,511
    80003bac:	97a6                	add	a5,a5,s1
    80003bae:	0187c783          	lbu	a5,24(a5)
    80003bb2:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003bb6:	4685                	li	a3,1
    80003bb8:	fbf40613          	addi	a2,s0,-65
    80003bbc:	85ca                	mv	a1,s2
    80003bbe:	050a3503          	ld	a0,80(s4)
    80003bc2:	e05fc0ef          	jal	800009c6 <copyout>
    80003bc6:	01650763          	beq	a0,s6,80003bd4 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003bca:	2985                	addiw	s3,s3,1
    80003bcc:	0905                	addi	s2,s2,1
    80003bce:	fd3a93e3          	bne	s5,s3,80003b94 <piperead+0x72>
    80003bd2:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003bd4:	21c48513          	addi	a0,s1,540
    80003bd8:	fa4fd0ef          	jal	8000137c <wakeup>
  release(&pi->lock);
    80003bdc:	8526                	mv	a0,s1
    80003bde:	6fb010ef          	jal	80005ad8 <release>
    80003be2:	6b42                	ld	s6,16(sp)
  return i;
}
    80003be4:	854e                	mv	a0,s3
    80003be6:	60a6                	ld	ra,72(sp)
    80003be8:	6406                	ld	s0,64(sp)
    80003bea:	74e2                	ld	s1,56(sp)
    80003bec:	7942                	ld	s2,48(sp)
    80003bee:	79a2                	ld	s3,40(sp)
    80003bf0:	7a02                	ld	s4,32(sp)
    80003bf2:	6ae2                	ld	s5,24(sp)
    80003bf4:	6161                	addi	sp,sp,80
    80003bf6:	8082                	ret

0000000080003bf8 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003bf8:	1141                	addi	sp,sp,-16
    80003bfa:	e422                	sd	s0,8(sp)
    80003bfc:	0800                	addi	s0,sp,16
    80003bfe:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003c00:	8905                	andi	a0,a0,1
    80003c02:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003c04:	8b89                	andi	a5,a5,2
    80003c06:	c399                	beqz	a5,80003c0c <flags2perm+0x14>
      perm |= PTE_W;
    80003c08:	00456513          	ori	a0,a0,4
    return perm;
}
    80003c0c:	6422                	ld	s0,8(sp)
    80003c0e:	0141                	addi	sp,sp,16
    80003c10:	8082                	ret

0000000080003c12 <exec>:

int
exec(char *path, char **argv)
{
    80003c12:	df010113          	addi	sp,sp,-528
    80003c16:	20113423          	sd	ra,520(sp)
    80003c1a:	20813023          	sd	s0,512(sp)
    80003c1e:	ffa6                	sd	s1,504(sp)
    80003c20:	fbca                	sd	s2,496(sp)
    80003c22:	0c00                	addi	s0,sp,528
    80003c24:	892a                	mv	s2,a0
    80003c26:	dea43c23          	sd	a0,-520(s0)
    80003c2a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003c2e:	928fd0ef          	jal	80000d56 <myproc>
    80003c32:	84aa                	mv	s1,a0

  begin_op();
    80003c34:	dc6ff0ef          	jal	800031fa <begin_op>

  if((ip = namei(path)) == 0){
    80003c38:	854a                	mv	a0,s2
    80003c3a:	c04ff0ef          	jal	8000303e <namei>
    80003c3e:	c931                	beqz	a0,80003c92 <exec+0x80>
    80003c40:	f3d2                	sd	s4,480(sp)
    80003c42:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003c44:	d21fe0ef          	jal	80002964 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003c48:	04000713          	li	a4,64
    80003c4c:	4681                	li	a3,0
    80003c4e:	e5040613          	addi	a2,s0,-432
    80003c52:	4581                	li	a1,0
    80003c54:	8552                	mv	a0,s4
    80003c56:	f63fe0ef          	jal	80002bb8 <readi>
    80003c5a:	04000793          	li	a5,64
    80003c5e:	00f51a63          	bne	a0,a5,80003c72 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003c62:	e5042703          	lw	a4,-432(s0)
    80003c66:	464c47b7          	lui	a5,0x464c4
    80003c6a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003c6e:	02f70663          	beq	a4,a5,80003c9a <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003c72:	8552                	mv	a0,s4
    80003c74:	efbfe0ef          	jal	80002b6e <iunlockput>
    end_op();
    80003c78:	decff0ef          	jal	80003264 <end_op>
  }
  return -1;
    80003c7c:	557d                	li	a0,-1
    80003c7e:	7a1e                	ld	s4,480(sp)
}
    80003c80:	20813083          	ld	ra,520(sp)
    80003c84:	20013403          	ld	s0,512(sp)
    80003c88:	74fe                	ld	s1,504(sp)
    80003c8a:	795e                	ld	s2,496(sp)
    80003c8c:	21010113          	addi	sp,sp,528
    80003c90:	8082                	ret
    end_op();
    80003c92:	dd2ff0ef          	jal	80003264 <end_op>
    return -1;
    80003c96:	557d                	li	a0,-1
    80003c98:	b7e5                	j	80003c80 <exec+0x6e>
    80003c9a:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003c9c:	8526                	mv	a0,s1
    80003c9e:	960fd0ef          	jal	80000dfe <proc_pagetable>
    80003ca2:	8b2a                	mv	s6,a0
    80003ca4:	2c050b63          	beqz	a0,80003f7a <exec+0x368>
    80003ca8:	f7ce                	sd	s3,488(sp)
    80003caa:	efd6                	sd	s5,472(sp)
    80003cac:	e7de                	sd	s7,456(sp)
    80003cae:	e3e2                	sd	s8,448(sp)
    80003cb0:	ff66                	sd	s9,440(sp)
    80003cb2:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003cb4:	e7042d03          	lw	s10,-400(s0)
    80003cb8:	e8845783          	lhu	a5,-376(s0)
    80003cbc:	12078963          	beqz	a5,80003dee <exec+0x1dc>
    80003cc0:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003cc2:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003cc4:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003cc6:	6c85                	lui	s9,0x1
    80003cc8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003ccc:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003cd0:	6a85                	lui	s5,0x1
    80003cd2:	a085                	j	80003d32 <exec+0x120>
      panic("loadseg: address should exist");
    80003cd4:	00004517          	auipc	a0,0x4
    80003cd8:	a2450513          	addi	a0,a0,-1500 # 800076f8 <etext+0x6f8>
    80003cdc:	237010ef          	jal	80005712 <panic>
    if(sz - i < PGSIZE)
    80003ce0:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003ce2:	8726                	mv	a4,s1
    80003ce4:	012c06bb          	addw	a3,s8,s2
    80003ce8:	4581                	li	a1,0
    80003cea:	8552                	mv	a0,s4
    80003cec:	ecdfe0ef          	jal	80002bb8 <readi>
    80003cf0:	2501                	sext.w	a0,a0
    80003cf2:	24a49a63          	bne	s1,a0,80003f46 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003cf6:	012a893b          	addw	s2,s5,s2
    80003cfa:	03397363          	bgeu	s2,s3,80003d20 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003cfe:	02091593          	slli	a1,s2,0x20
    80003d02:	9181                	srli	a1,a1,0x20
    80003d04:	95de                	add	a1,a1,s7
    80003d06:	855a                	mv	a0,s6
    80003d08:	f3afc0ef          	jal	80000442 <walkaddr>
    80003d0c:	862a                	mv	a2,a0
    if(pa == 0)
    80003d0e:	d179                	beqz	a0,80003cd4 <exec+0xc2>
    if(sz - i < PGSIZE)
    80003d10:	412984bb          	subw	s1,s3,s2
    80003d14:	0004879b          	sext.w	a5,s1
    80003d18:	fcfcf4e3          	bgeu	s9,a5,80003ce0 <exec+0xce>
    80003d1c:	84d6                	mv	s1,s5
    80003d1e:	b7c9                	j	80003ce0 <exec+0xce>
    sz = sz1;
    80003d20:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d24:	2d85                	addiw	s11,s11,1
    80003d26:	038d0d1b          	addiw	s10,s10,56
    80003d2a:	e8845783          	lhu	a5,-376(s0)
    80003d2e:	08fdd063          	bge	s11,a5,80003dae <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003d32:	2d01                	sext.w	s10,s10
    80003d34:	03800713          	li	a4,56
    80003d38:	86ea                	mv	a3,s10
    80003d3a:	e1840613          	addi	a2,s0,-488
    80003d3e:	4581                	li	a1,0
    80003d40:	8552                	mv	a0,s4
    80003d42:	e77fe0ef          	jal	80002bb8 <readi>
    80003d46:	03800793          	li	a5,56
    80003d4a:	1cf51663          	bne	a0,a5,80003f16 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003d4e:	e1842783          	lw	a5,-488(s0)
    80003d52:	4705                	li	a4,1
    80003d54:	fce798e3          	bne	a5,a4,80003d24 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003d58:	e4043483          	ld	s1,-448(s0)
    80003d5c:	e3843783          	ld	a5,-456(s0)
    80003d60:	1af4ef63          	bltu	s1,a5,80003f1e <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003d64:	e2843783          	ld	a5,-472(s0)
    80003d68:	94be                	add	s1,s1,a5
    80003d6a:	1af4ee63          	bltu	s1,a5,80003f26 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003d6e:	df043703          	ld	a4,-528(s0)
    80003d72:	8ff9                	and	a5,a5,a4
    80003d74:	1a079d63          	bnez	a5,80003f2e <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003d78:	e1c42503          	lw	a0,-484(s0)
    80003d7c:	e7dff0ef          	jal	80003bf8 <flags2perm>
    80003d80:	86aa                	mv	a3,a0
    80003d82:	8626                	mv	a2,s1
    80003d84:	85ca                	mv	a1,s2
    80003d86:	855a                	mv	a0,s6
    80003d88:	a33fc0ef          	jal	800007ba <uvmalloc>
    80003d8c:	e0a43423          	sd	a0,-504(s0)
    80003d90:	1a050363          	beqz	a0,80003f36 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003d94:	e2843b83          	ld	s7,-472(s0)
    80003d98:	e2042c03          	lw	s8,-480(s0)
    80003d9c:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003da0:	00098463          	beqz	s3,80003da8 <exec+0x196>
    80003da4:	4901                	li	s2,0
    80003da6:	bfa1                	j	80003cfe <exec+0xec>
    sz = sz1;
    80003da8:	e0843903          	ld	s2,-504(s0)
    80003dac:	bfa5                	j	80003d24 <exec+0x112>
    80003dae:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003db0:	8552                	mv	a0,s4
    80003db2:	dbdfe0ef          	jal	80002b6e <iunlockput>
  end_op();
    80003db6:	caeff0ef          	jal	80003264 <end_op>
  p = myproc();
    80003dba:	f9dfc0ef          	jal	80000d56 <myproc>
    80003dbe:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003dc0:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003dc4:	6985                	lui	s3,0x1
    80003dc6:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003dc8:	99ca                	add	s3,s3,s2
    80003dca:	77fd                	lui	a5,0xfffff
    80003dcc:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003dd0:	4691                	li	a3,4
    80003dd2:	6609                	lui	a2,0x2
    80003dd4:	964e                	add	a2,a2,s3
    80003dd6:	85ce                	mv	a1,s3
    80003dd8:	855a                	mv	a0,s6
    80003dda:	9e1fc0ef          	jal	800007ba <uvmalloc>
    80003dde:	892a                	mv	s2,a0
    80003de0:	e0a43423          	sd	a0,-504(s0)
    80003de4:	e519                	bnez	a0,80003df2 <exec+0x1e0>
  if(pagetable)
    80003de6:	e1343423          	sd	s3,-504(s0)
    80003dea:	4a01                	li	s4,0
    80003dec:	aab1                	j	80003f48 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003dee:	4901                	li	s2,0
    80003df0:	b7c1                	j	80003db0 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003df2:	75f9                	lui	a1,0xffffe
    80003df4:	95aa                	add	a1,a1,a0
    80003df6:	855a                	mv	a0,s6
    80003df8:	ba5fc0ef          	jal	8000099c <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003dfc:	7bfd                	lui	s7,0xfffff
    80003dfe:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003e00:	e0043783          	ld	a5,-512(s0)
    80003e04:	6388                	ld	a0,0(a5)
    80003e06:	cd39                	beqz	a0,80003e64 <exec+0x252>
    80003e08:	e9040993          	addi	s3,s0,-368
    80003e0c:	f9040c13          	addi	s8,s0,-112
    80003e10:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003e12:	c92fc0ef          	jal	800002a4 <strlen>
    80003e16:	0015079b          	addiw	a5,a0,1
    80003e1a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003e1e:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003e22:	11796e63          	bltu	s2,s7,80003f3e <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003e26:	e0043d03          	ld	s10,-512(s0)
    80003e2a:	000d3a03          	ld	s4,0(s10)
    80003e2e:	8552                	mv	a0,s4
    80003e30:	c74fc0ef          	jal	800002a4 <strlen>
    80003e34:	0015069b          	addiw	a3,a0,1
    80003e38:	8652                	mv	a2,s4
    80003e3a:	85ca                	mv	a1,s2
    80003e3c:	855a                	mv	a0,s6
    80003e3e:	b89fc0ef          	jal	800009c6 <copyout>
    80003e42:	10054063          	bltz	a0,80003f42 <exec+0x330>
    ustack[argc] = sp;
    80003e46:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003e4a:	0485                	addi	s1,s1,1
    80003e4c:	008d0793          	addi	a5,s10,8
    80003e50:	e0f43023          	sd	a5,-512(s0)
    80003e54:	008d3503          	ld	a0,8(s10)
    80003e58:	c909                	beqz	a0,80003e6a <exec+0x258>
    if(argc >= MAXARG)
    80003e5a:	09a1                	addi	s3,s3,8
    80003e5c:	fb899be3          	bne	s3,s8,80003e12 <exec+0x200>
  ip = 0;
    80003e60:	4a01                	li	s4,0
    80003e62:	a0dd                	j	80003f48 <exec+0x336>
  sp = sz;
    80003e64:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003e68:	4481                	li	s1,0
  ustack[argc] = 0;
    80003e6a:	00349793          	slli	a5,s1,0x3
    80003e6e:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb130>
    80003e72:	97a2                	add	a5,a5,s0
    80003e74:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003e78:	00148693          	addi	a3,s1,1
    80003e7c:	068e                	slli	a3,a3,0x3
    80003e7e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003e82:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003e86:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003e8a:	f5796ee3          	bltu	s2,s7,80003de6 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003e8e:	e9040613          	addi	a2,s0,-368
    80003e92:	85ca                	mv	a1,s2
    80003e94:	855a                	mv	a0,s6
    80003e96:	b31fc0ef          	jal	800009c6 <copyout>
    80003e9a:	0e054263          	bltz	a0,80003f7e <exec+0x36c>
  p->trapframe->a1 = sp;
    80003e9e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003ea2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003ea6:	df843783          	ld	a5,-520(s0)
    80003eaa:	0007c703          	lbu	a4,0(a5)
    80003eae:	cf11                	beqz	a4,80003eca <exec+0x2b8>
    80003eb0:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003eb2:	02f00693          	li	a3,47
    80003eb6:	a039                	j	80003ec4 <exec+0x2b2>
      last = s+1;
    80003eb8:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003ebc:	0785                	addi	a5,a5,1
    80003ebe:	fff7c703          	lbu	a4,-1(a5)
    80003ec2:	c701                	beqz	a4,80003eca <exec+0x2b8>
    if(*s == '/')
    80003ec4:	fed71ce3          	bne	a4,a3,80003ebc <exec+0x2aa>
    80003ec8:	bfc5                	j	80003eb8 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003eca:	4641                	li	a2,16
    80003ecc:	df843583          	ld	a1,-520(s0)
    80003ed0:	158a8513          	addi	a0,s5,344
    80003ed4:	b9efc0ef          	jal	80000272 <safestrcpy>
  oldpagetable = p->pagetable;
    80003ed8:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003edc:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003ee0:	e0843783          	ld	a5,-504(s0)
    80003ee4:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003ee8:	058ab783          	ld	a5,88(s5)
    80003eec:	e6843703          	ld	a4,-408(s0)
    80003ef0:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003ef2:	058ab783          	ld	a5,88(s5)
    80003ef6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003efa:	85e6                	mv	a1,s9
    80003efc:	f87fc0ef          	jal	80000e82 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003f00:	0004851b          	sext.w	a0,s1
    80003f04:	79be                	ld	s3,488(sp)
    80003f06:	7a1e                	ld	s4,480(sp)
    80003f08:	6afe                	ld	s5,472(sp)
    80003f0a:	6b5e                	ld	s6,464(sp)
    80003f0c:	6bbe                	ld	s7,456(sp)
    80003f0e:	6c1e                	ld	s8,448(sp)
    80003f10:	7cfa                	ld	s9,440(sp)
    80003f12:	7d5a                	ld	s10,432(sp)
    80003f14:	b3b5                	j	80003c80 <exec+0x6e>
    80003f16:	e1243423          	sd	s2,-504(s0)
    80003f1a:	7dba                	ld	s11,424(sp)
    80003f1c:	a035                	j	80003f48 <exec+0x336>
    80003f1e:	e1243423          	sd	s2,-504(s0)
    80003f22:	7dba                	ld	s11,424(sp)
    80003f24:	a015                	j	80003f48 <exec+0x336>
    80003f26:	e1243423          	sd	s2,-504(s0)
    80003f2a:	7dba                	ld	s11,424(sp)
    80003f2c:	a831                	j	80003f48 <exec+0x336>
    80003f2e:	e1243423          	sd	s2,-504(s0)
    80003f32:	7dba                	ld	s11,424(sp)
    80003f34:	a811                	j	80003f48 <exec+0x336>
    80003f36:	e1243423          	sd	s2,-504(s0)
    80003f3a:	7dba                	ld	s11,424(sp)
    80003f3c:	a031                	j	80003f48 <exec+0x336>
  ip = 0;
    80003f3e:	4a01                	li	s4,0
    80003f40:	a021                	j	80003f48 <exec+0x336>
    80003f42:	4a01                	li	s4,0
  if(pagetable)
    80003f44:	a011                	j	80003f48 <exec+0x336>
    80003f46:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003f48:	e0843583          	ld	a1,-504(s0)
    80003f4c:	855a                	mv	a0,s6
    80003f4e:	f35fc0ef          	jal	80000e82 <proc_freepagetable>
  return -1;
    80003f52:	557d                	li	a0,-1
  if(ip){
    80003f54:	000a1b63          	bnez	s4,80003f6a <exec+0x358>
    80003f58:	79be                	ld	s3,488(sp)
    80003f5a:	7a1e                	ld	s4,480(sp)
    80003f5c:	6afe                	ld	s5,472(sp)
    80003f5e:	6b5e                	ld	s6,464(sp)
    80003f60:	6bbe                	ld	s7,456(sp)
    80003f62:	6c1e                	ld	s8,448(sp)
    80003f64:	7cfa                	ld	s9,440(sp)
    80003f66:	7d5a                	ld	s10,432(sp)
    80003f68:	bb21                	j	80003c80 <exec+0x6e>
    80003f6a:	79be                	ld	s3,488(sp)
    80003f6c:	6afe                	ld	s5,472(sp)
    80003f6e:	6b5e                	ld	s6,464(sp)
    80003f70:	6bbe                	ld	s7,456(sp)
    80003f72:	6c1e                	ld	s8,448(sp)
    80003f74:	7cfa                	ld	s9,440(sp)
    80003f76:	7d5a                	ld	s10,432(sp)
    80003f78:	b9ed                	j	80003c72 <exec+0x60>
    80003f7a:	6b5e                	ld	s6,464(sp)
    80003f7c:	b9dd                	j	80003c72 <exec+0x60>
  sz = sz1;
    80003f7e:	e0843983          	ld	s3,-504(s0)
    80003f82:	b595                	j	80003de6 <exec+0x1d4>

0000000080003f84 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003f84:	7179                	addi	sp,sp,-48
    80003f86:	f406                	sd	ra,40(sp)
    80003f88:	f022                	sd	s0,32(sp)
    80003f8a:	ec26                	sd	s1,24(sp)
    80003f8c:	e84a                	sd	s2,16(sp)
    80003f8e:	1800                	addi	s0,sp,48
    80003f90:	892e                	mv	s2,a1
    80003f92:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003f94:	fdc40593          	addi	a1,s0,-36
    80003f98:	c7ffd0ef          	jal	80001c16 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003f9c:	fdc42703          	lw	a4,-36(s0)
    80003fa0:	47bd                	li	a5,15
    80003fa2:	02e7e963          	bltu	a5,a4,80003fd4 <argfd+0x50>
    80003fa6:	db1fc0ef          	jal	80000d56 <myproc>
    80003faa:	fdc42703          	lw	a4,-36(s0)
    80003fae:	01a70793          	addi	a5,a4,26
    80003fb2:	078e                	slli	a5,a5,0x3
    80003fb4:	953e                	add	a0,a0,a5
    80003fb6:	611c                	ld	a5,0(a0)
    80003fb8:	c385                	beqz	a5,80003fd8 <argfd+0x54>
    return -1;
  if(pfd)
    80003fba:	00090463          	beqz	s2,80003fc2 <argfd+0x3e>
    *pfd = fd;
    80003fbe:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003fc2:	4501                	li	a0,0
  if(pf)
    80003fc4:	c091                	beqz	s1,80003fc8 <argfd+0x44>
    *pf = f;
    80003fc6:	e09c                	sd	a5,0(s1)
}
    80003fc8:	70a2                	ld	ra,40(sp)
    80003fca:	7402                	ld	s0,32(sp)
    80003fcc:	64e2                	ld	s1,24(sp)
    80003fce:	6942                	ld	s2,16(sp)
    80003fd0:	6145                	addi	sp,sp,48
    80003fd2:	8082                	ret
    return -1;
    80003fd4:	557d                	li	a0,-1
    80003fd6:	bfcd                	j	80003fc8 <argfd+0x44>
    80003fd8:	557d                	li	a0,-1
    80003fda:	b7fd                	j	80003fc8 <argfd+0x44>

0000000080003fdc <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003fdc:	1101                	addi	sp,sp,-32
    80003fde:	ec06                	sd	ra,24(sp)
    80003fe0:	e822                	sd	s0,16(sp)
    80003fe2:	e426                	sd	s1,8(sp)
    80003fe4:	1000                	addi	s0,sp,32
    80003fe6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003fe8:	d6ffc0ef          	jal	80000d56 <myproc>
    80003fec:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003fee:	0d050793          	addi	a5,a0,208
    80003ff2:	4501                	li	a0,0
    80003ff4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003ff6:	6398                	ld	a4,0(a5)
    80003ff8:	cb19                	beqz	a4,8000400e <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003ffa:	2505                	addiw	a0,a0,1
    80003ffc:	07a1                	addi	a5,a5,8
    80003ffe:	fed51ce3          	bne	a0,a3,80003ff6 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004002:	557d                	li	a0,-1
}
    80004004:	60e2                	ld	ra,24(sp)
    80004006:	6442                	ld	s0,16(sp)
    80004008:	64a2                	ld	s1,8(sp)
    8000400a:	6105                	addi	sp,sp,32
    8000400c:	8082                	ret
      p->ofile[fd] = f;
    8000400e:	01a50793          	addi	a5,a0,26
    80004012:	078e                	slli	a5,a5,0x3
    80004014:	963e                	add	a2,a2,a5
    80004016:	e204                	sd	s1,0(a2)
      return fd;
    80004018:	b7f5                	j	80004004 <fdalloc+0x28>

000000008000401a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000401a:	715d                	addi	sp,sp,-80
    8000401c:	e486                	sd	ra,72(sp)
    8000401e:	e0a2                	sd	s0,64(sp)
    80004020:	fc26                	sd	s1,56(sp)
    80004022:	f84a                	sd	s2,48(sp)
    80004024:	f44e                	sd	s3,40(sp)
    80004026:	ec56                	sd	s5,24(sp)
    80004028:	e85a                	sd	s6,16(sp)
    8000402a:	0880                	addi	s0,sp,80
    8000402c:	8b2e                	mv	s6,a1
    8000402e:	89b2                	mv	s3,a2
    80004030:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004032:	fb040593          	addi	a1,s0,-80
    80004036:	822ff0ef          	jal	80003058 <nameiparent>
    8000403a:	84aa                	mv	s1,a0
    8000403c:	10050a63          	beqz	a0,80004150 <create+0x136>
    return 0;

  ilock(dp);
    80004040:	925fe0ef          	jal	80002964 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004044:	4601                	li	a2,0
    80004046:	fb040593          	addi	a1,s0,-80
    8000404a:	8526                	mv	a0,s1
    8000404c:	d8dfe0ef          	jal	80002dd8 <dirlookup>
    80004050:	8aaa                	mv	s5,a0
    80004052:	c129                	beqz	a0,80004094 <create+0x7a>
    iunlockput(dp);
    80004054:	8526                	mv	a0,s1
    80004056:	b19fe0ef          	jal	80002b6e <iunlockput>
    ilock(ip);
    8000405a:	8556                	mv	a0,s5
    8000405c:	909fe0ef          	jal	80002964 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004060:	4789                	li	a5,2
    80004062:	02fb1463          	bne	s6,a5,8000408a <create+0x70>
    80004066:	044ad783          	lhu	a5,68(s5)
    8000406a:	37f9                	addiw	a5,a5,-2
    8000406c:	17c2                	slli	a5,a5,0x30
    8000406e:	93c1                	srli	a5,a5,0x30
    80004070:	4705                	li	a4,1
    80004072:	00f76c63          	bltu	a4,a5,8000408a <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004076:	8556                	mv	a0,s5
    80004078:	60a6                	ld	ra,72(sp)
    8000407a:	6406                	ld	s0,64(sp)
    8000407c:	74e2                	ld	s1,56(sp)
    8000407e:	7942                	ld	s2,48(sp)
    80004080:	79a2                	ld	s3,40(sp)
    80004082:	6ae2                	ld	s5,24(sp)
    80004084:	6b42                	ld	s6,16(sp)
    80004086:	6161                	addi	sp,sp,80
    80004088:	8082                	ret
    iunlockput(ip);
    8000408a:	8556                	mv	a0,s5
    8000408c:	ae3fe0ef          	jal	80002b6e <iunlockput>
    return 0;
    80004090:	4a81                	li	s5,0
    80004092:	b7d5                	j	80004076 <create+0x5c>
    80004094:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004096:	85da                	mv	a1,s6
    80004098:	4088                	lw	a0,0(s1)
    8000409a:	f5afe0ef          	jal	800027f4 <ialloc>
    8000409e:	8a2a                	mv	s4,a0
    800040a0:	cd15                	beqz	a0,800040dc <create+0xc2>
  ilock(ip);
    800040a2:	8c3fe0ef          	jal	80002964 <ilock>
  ip->major = major;
    800040a6:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800040aa:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800040ae:	4905                	li	s2,1
    800040b0:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800040b4:	8552                	mv	a0,s4
    800040b6:	ffafe0ef          	jal	800028b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800040ba:	032b0763          	beq	s6,s2,800040e8 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    800040be:	004a2603          	lw	a2,4(s4)
    800040c2:	fb040593          	addi	a1,s0,-80
    800040c6:	8526                	mv	a0,s1
    800040c8:	eddfe0ef          	jal	80002fa4 <dirlink>
    800040cc:	06054563          	bltz	a0,80004136 <create+0x11c>
  iunlockput(dp);
    800040d0:	8526                	mv	a0,s1
    800040d2:	a9dfe0ef          	jal	80002b6e <iunlockput>
  return ip;
    800040d6:	8ad2                	mv	s5,s4
    800040d8:	7a02                	ld	s4,32(sp)
    800040da:	bf71                	j	80004076 <create+0x5c>
    iunlockput(dp);
    800040dc:	8526                	mv	a0,s1
    800040de:	a91fe0ef          	jal	80002b6e <iunlockput>
    return 0;
    800040e2:	8ad2                	mv	s5,s4
    800040e4:	7a02                	ld	s4,32(sp)
    800040e6:	bf41                	j	80004076 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800040e8:	004a2603          	lw	a2,4(s4)
    800040ec:	00003597          	auipc	a1,0x3
    800040f0:	62c58593          	addi	a1,a1,1580 # 80007718 <etext+0x718>
    800040f4:	8552                	mv	a0,s4
    800040f6:	eaffe0ef          	jal	80002fa4 <dirlink>
    800040fa:	02054e63          	bltz	a0,80004136 <create+0x11c>
    800040fe:	40d0                	lw	a2,4(s1)
    80004100:	00003597          	auipc	a1,0x3
    80004104:	62058593          	addi	a1,a1,1568 # 80007720 <etext+0x720>
    80004108:	8552                	mv	a0,s4
    8000410a:	e9bfe0ef          	jal	80002fa4 <dirlink>
    8000410e:	02054463          	bltz	a0,80004136 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004112:	004a2603          	lw	a2,4(s4)
    80004116:	fb040593          	addi	a1,s0,-80
    8000411a:	8526                	mv	a0,s1
    8000411c:	e89fe0ef          	jal	80002fa4 <dirlink>
    80004120:	00054b63          	bltz	a0,80004136 <create+0x11c>
    dp->nlink++;  // for ".."
    80004124:	04a4d783          	lhu	a5,74(s1)
    80004128:	2785                	addiw	a5,a5,1
    8000412a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000412e:	8526                	mv	a0,s1
    80004130:	f80fe0ef          	jal	800028b0 <iupdate>
    80004134:	bf71                	j	800040d0 <create+0xb6>
  ip->nlink = 0;
    80004136:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000413a:	8552                	mv	a0,s4
    8000413c:	f74fe0ef          	jal	800028b0 <iupdate>
  iunlockput(ip);
    80004140:	8552                	mv	a0,s4
    80004142:	a2dfe0ef          	jal	80002b6e <iunlockput>
  iunlockput(dp);
    80004146:	8526                	mv	a0,s1
    80004148:	a27fe0ef          	jal	80002b6e <iunlockput>
  return 0;
    8000414c:	7a02                	ld	s4,32(sp)
    8000414e:	b725                	j	80004076 <create+0x5c>
    return 0;
    80004150:	8aaa                	mv	s5,a0
    80004152:	b715                	j	80004076 <create+0x5c>

0000000080004154 <sys_dup>:
{
    80004154:	7179                	addi	sp,sp,-48
    80004156:	f406                	sd	ra,40(sp)
    80004158:	f022                	sd	s0,32(sp)
    8000415a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000415c:	fd840613          	addi	a2,s0,-40
    80004160:	4581                	li	a1,0
    80004162:	4501                	li	a0,0
    80004164:	e21ff0ef          	jal	80003f84 <argfd>
    return -1;
    80004168:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000416a:	02054363          	bltz	a0,80004190 <sys_dup+0x3c>
    8000416e:	ec26                	sd	s1,24(sp)
    80004170:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004172:	fd843903          	ld	s2,-40(s0)
    80004176:	854a                	mv	a0,s2
    80004178:	e65ff0ef          	jal	80003fdc <fdalloc>
    8000417c:	84aa                	mv	s1,a0
    return -1;
    8000417e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004180:	00054d63          	bltz	a0,8000419a <sys_dup+0x46>
  filedup(f);
    80004184:	854a                	mv	a0,s2
    80004186:	c48ff0ef          	jal	800035ce <filedup>
  return fd;
    8000418a:	87a6                	mv	a5,s1
    8000418c:	64e2                	ld	s1,24(sp)
    8000418e:	6942                	ld	s2,16(sp)
}
    80004190:	853e                	mv	a0,a5
    80004192:	70a2                	ld	ra,40(sp)
    80004194:	7402                	ld	s0,32(sp)
    80004196:	6145                	addi	sp,sp,48
    80004198:	8082                	ret
    8000419a:	64e2                	ld	s1,24(sp)
    8000419c:	6942                	ld	s2,16(sp)
    8000419e:	bfcd                	j	80004190 <sys_dup+0x3c>

00000000800041a0 <sys_read>:
{
    800041a0:	7179                	addi	sp,sp,-48
    800041a2:	f406                	sd	ra,40(sp)
    800041a4:	f022                	sd	s0,32(sp)
    800041a6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800041a8:	fd840593          	addi	a1,s0,-40
    800041ac:	4505                	li	a0,1
    800041ae:	a85fd0ef          	jal	80001c32 <argaddr>
  argint(2, &n);
    800041b2:	fe440593          	addi	a1,s0,-28
    800041b6:	4509                	li	a0,2
    800041b8:	a5ffd0ef          	jal	80001c16 <argint>
  if(argfd(0, 0, &f) < 0)
    800041bc:	fe840613          	addi	a2,s0,-24
    800041c0:	4581                	li	a1,0
    800041c2:	4501                	li	a0,0
    800041c4:	dc1ff0ef          	jal	80003f84 <argfd>
    800041c8:	87aa                	mv	a5,a0
    return -1;
    800041ca:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800041cc:	0007ca63          	bltz	a5,800041e0 <sys_read+0x40>
  return fileread(f, p, n);
    800041d0:	fe442603          	lw	a2,-28(s0)
    800041d4:	fd843583          	ld	a1,-40(s0)
    800041d8:	fe843503          	ld	a0,-24(s0)
    800041dc:	d58ff0ef          	jal	80003734 <fileread>
}
    800041e0:	70a2                	ld	ra,40(sp)
    800041e2:	7402                	ld	s0,32(sp)
    800041e4:	6145                	addi	sp,sp,48
    800041e6:	8082                	ret

00000000800041e8 <sys_write>:
{
    800041e8:	7179                	addi	sp,sp,-48
    800041ea:	f406                	sd	ra,40(sp)
    800041ec:	f022                	sd	s0,32(sp)
    800041ee:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800041f0:	fd840593          	addi	a1,s0,-40
    800041f4:	4505                	li	a0,1
    800041f6:	a3dfd0ef          	jal	80001c32 <argaddr>
  argint(2, &n);
    800041fa:	fe440593          	addi	a1,s0,-28
    800041fe:	4509                	li	a0,2
    80004200:	a17fd0ef          	jal	80001c16 <argint>
  if(argfd(0, 0, &f) < 0)
    80004204:	fe840613          	addi	a2,s0,-24
    80004208:	4581                	li	a1,0
    8000420a:	4501                	li	a0,0
    8000420c:	d79ff0ef          	jal	80003f84 <argfd>
    80004210:	87aa                	mv	a5,a0
    return -1;
    80004212:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004214:	0007ca63          	bltz	a5,80004228 <sys_write+0x40>
  return filewrite(f, p, n);
    80004218:	fe442603          	lw	a2,-28(s0)
    8000421c:	fd843583          	ld	a1,-40(s0)
    80004220:	fe843503          	ld	a0,-24(s0)
    80004224:	dceff0ef          	jal	800037f2 <filewrite>
}
    80004228:	70a2                	ld	ra,40(sp)
    8000422a:	7402                	ld	s0,32(sp)
    8000422c:	6145                	addi	sp,sp,48
    8000422e:	8082                	ret

0000000080004230 <sys_close>:
{
    80004230:	1101                	addi	sp,sp,-32
    80004232:	ec06                	sd	ra,24(sp)
    80004234:	e822                	sd	s0,16(sp)
    80004236:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004238:	fe040613          	addi	a2,s0,-32
    8000423c:	fec40593          	addi	a1,s0,-20
    80004240:	4501                	li	a0,0
    80004242:	d43ff0ef          	jal	80003f84 <argfd>
    return -1;
    80004246:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004248:	02054063          	bltz	a0,80004268 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000424c:	b0bfc0ef          	jal	80000d56 <myproc>
    80004250:	fec42783          	lw	a5,-20(s0)
    80004254:	07e9                	addi	a5,a5,26
    80004256:	078e                	slli	a5,a5,0x3
    80004258:	953e                	add	a0,a0,a5
    8000425a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000425e:	fe043503          	ld	a0,-32(s0)
    80004262:	bb2ff0ef          	jal	80003614 <fileclose>
  return 0;
    80004266:	4781                	li	a5,0
}
    80004268:	853e                	mv	a0,a5
    8000426a:	60e2                	ld	ra,24(sp)
    8000426c:	6442                	ld	s0,16(sp)
    8000426e:	6105                	addi	sp,sp,32
    80004270:	8082                	ret

0000000080004272 <sys_fstat>:
{
    80004272:	1101                	addi	sp,sp,-32
    80004274:	ec06                	sd	ra,24(sp)
    80004276:	e822                	sd	s0,16(sp)
    80004278:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000427a:	fe040593          	addi	a1,s0,-32
    8000427e:	4505                	li	a0,1
    80004280:	9b3fd0ef          	jal	80001c32 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004284:	fe840613          	addi	a2,s0,-24
    80004288:	4581                	li	a1,0
    8000428a:	4501                	li	a0,0
    8000428c:	cf9ff0ef          	jal	80003f84 <argfd>
    80004290:	87aa                	mv	a5,a0
    return -1;
    80004292:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004294:	0007c863          	bltz	a5,800042a4 <sys_fstat+0x32>
  return filestat(f, st);
    80004298:	fe043583          	ld	a1,-32(s0)
    8000429c:	fe843503          	ld	a0,-24(s0)
    800042a0:	c36ff0ef          	jal	800036d6 <filestat>
}
    800042a4:	60e2                	ld	ra,24(sp)
    800042a6:	6442                	ld	s0,16(sp)
    800042a8:	6105                	addi	sp,sp,32
    800042aa:	8082                	ret

00000000800042ac <sys_link>:
{
    800042ac:	7169                	addi	sp,sp,-304
    800042ae:	f606                	sd	ra,296(sp)
    800042b0:	f222                	sd	s0,288(sp)
    800042b2:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800042b4:	08000613          	li	a2,128
    800042b8:	ed040593          	addi	a1,s0,-304
    800042bc:	4501                	li	a0,0
    800042be:	991fd0ef          	jal	80001c4e <argstr>
    return -1;
    800042c2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800042c4:	0c054e63          	bltz	a0,800043a0 <sys_link+0xf4>
    800042c8:	08000613          	li	a2,128
    800042cc:	f5040593          	addi	a1,s0,-176
    800042d0:	4505                	li	a0,1
    800042d2:	97dfd0ef          	jal	80001c4e <argstr>
    return -1;
    800042d6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800042d8:	0c054463          	bltz	a0,800043a0 <sys_link+0xf4>
    800042dc:	ee26                	sd	s1,280(sp)
  begin_op();
    800042de:	f1dfe0ef          	jal	800031fa <begin_op>
  if((ip = namei(old)) == 0){
    800042e2:	ed040513          	addi	a0,s0,-304
    800042e6:	d59fe0ef          	jal	8000303e <namei>
    800042ea:	84aa                	mv	s1,a0
    800042ec:	c53d                	beqz	a0,8000435a <sys_link+0xae>
  ilock(ip);
    800042ee:	e76fe0ef          	jal	80002964 <ilock>
  if(ip->type == T_DIR){
    800042f2:	04449703          	lh	a4,68(s1)
    800042f6:	4785                	li	a5,1
    800042f8:	06f70663          	beq	a4,a5,80004364 <sys_link+0xb8>
    800042fc:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800042fe:	04a4d783          	lhu	a5,74(s1)
    80004302:	2785                	addiw	a5,a5,1
    80004304:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004308:	8526                	mv	a0,s1
    8000430a:	da6fe0ef          	jal	800028b0 <iupdate>
  iunlock(ip);
    8000430e:	8526                	mv	a0,s1
    80004310:	f02fe0ef          	jal	80002a12 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004314:	fd040593          	addi	a1,s0,-48
    80004318:	f5040513          	addi	a0,s0,-176
    8000431c:	d3dfe0ef          	jal	80003058 <nameiparent>
    80004320:	892a                	mv	s2,a0
    80004322:	cd21                	beqz	a0,8000437a <sys_link+0xce>
  ilock(dp);
    80004324:	e40fe0ef          	jal	80002964 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004328:	00092703          	lw	a4,0(s2)
    8000432c:	409c                	lw	a5,0(s1)
    8000432e:	04f71363          	bne	a4,a5,80004374 <sys_link+0xc8>
    80004332:	40d0                	lw	a2,4(s1)
    80004334:	fd040593          	addi	a1,s0,-48
    80004338:	854a                	mv	a0,s2
    8000433a:	c6bfe0ef          	jal	80002fa4 <dirlink>
    8000433e:	02054b63          	bltz	a0,80004374 <sys_link+0xc8>
  iunlockput(dp);
    80004342:	854a                	mv	a0,s2
    80004344:	82bfe0ef          	jal	80002b6e <iunlockput>
  iput(ip);
    80004348:	8526                	mv	a0,s1
    8000434a:	f9cfe0ef          	jal	80002ae6 <iput>
  end_op();
    8000434e:	f17fe0ef          	jal	80003264 <end_op>
  return 0;
    80004352:	4781                	li	a5,0
    80004354:	64f2                	ld	s1,280(sp)
    80004356:	6952                	ld	s2,272(sp)
    80004358:	a0a1                	j	800043a0 <sys_link+0xf4>
    end_op();
    8000435a:	f0bfe0ef          	jal	80003264 <end_op>
    return -1;
    8000435e:	57fd                	li	a5,-1
    80004360:	64f2                	ld	s1,280(sp)
    80004362:	a83d                	j	800043a0 <sys_link+0xf4>
    iunlockput(ip);
    80004364:	8526                	mv	a0,s1
    80004366:	809fe0ef          	jal	80002b6e <iunlockput>
    end_op();
    8000436a:	efbfe0ef          	jal	80003264 <end_op>
    return -1;
    8000436e:	57fd                	li	a5,-1
    80004370:	64f2                	ld	s1,280(sp)
    80004372:	a03d                	j	800043a0 <sys_link+0xf4>
    iunlockput(dp);
    80004374:	854a                	mv	a0,s2
    80004376:	ff8fe0ef          	jal	80002b6e <iunlockput>
  ilock(ip);
    8000437a:	8526                	mv	a0,s1
    8000437c:	de8fe0ef          	jal	80002964 <ilock>
  ip->nlink--;
    80004380:	04a4d783          	lhu	a5,74(s1)
    80004384:	37fd                	addiw	a5,a5,-1
    80004386:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000438a:	8526                	mv	a0,s1
    8000438c:	d24fe0ef          	jal	800028b0 <iupdate>
  iunlockput(ip);
    80004390:	8526                	mv	a0,s1
    80004392:	fdcfe0ef          	jal	80002b6e <iunlockput>
  end_op();
    80004396:	ecffe0ef          	jal	80003264 <end_op>
  return -1;
    8000439a:	57fd                	li	a5,-1
    8000439c:	64f2                	ld	s1,280(sp)
    8000439e:	6952                	ld	s2,272(sp)
}
    800043a0:	853e                	mv	a0,a5
    800043a2:	70b2                	ld	ra,296(sp)
    800043a4:	7412                	ld	s0,288(sp)
    800043a6:	6155                	addi	sp,sp,304
    800043a8:	8082                	ret

00000000800043aa <sys_unlink>:
{
    800043aa:	7151                	addi	sp,sp,-240
    800043ac:	f586                	sd	ra,232(sp)
    800043ae:	f1a2                	sd	s0,224(sp)
    800043b0:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800043b2:	08000613          	li	a2,128
    800043b6:	f3040593          	addi	a1,s0,-208
    800043ba:	4501                	li	a0,0
    800043bc:	893fd0ef          	jal	80001c4e <argstr>
    800043c0:	16054063          	bltz	a0,80004520 <sys_unlink+0x176>
    800043c4:	eda6                	sd	s1,216(sp)
  begin_op();
    800043c6:	e35fe0ef          	jal	800031fa <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800043ca:	fb040593          	addi	a1,s0,-80
    800043ce:	f3040513          	addi	a0,s0,-208
    800043d2:	c87fe0ef          	jal	80003058 <nameiparent>
    800043d6:	84aa                	mv	s1,a0
    800043d8:	c945                	beqz	a0,80004488 <sys_unlink+0xde>
  ilock(dp);
    800043da:	d8afe0ef          	jal	80002964 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800043de:	00003597          	auipc	a1,0x3
    800043e2:	33a58593          	addi	a1,a1,826 # 80007718 <etext+0x718>
    800043e6:	fb040513          	addi	a0,s0,-80
    800043ea:	9d9fe0ef          	jal	80002dc2 <namecmp>
    800043ee:	10050e63          	beqz	a0,8000450a <sys_unlink+0x160>
    800043f2:	00003597          	auipc	a1,0x3
    800043f6:	32e58593          	addi	a1,a1,814 # 80007720 <etext+0x720>
    800043fa:	fb040513          	addi	a0,s0,-80
    800043fe:	9c5fe0ef          	jal	80002dc2 <namecmp>
    80004402:	10050463          	beqz	a0,8000450a <sys_unlink+0x160>
    80004406:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004408:	f2c40613          	addi	a2,s0,-212
    8000440c:	fb040593          	addi	a1,s0,-80
    80004410:	8526                	mv	a0,s1
    80004412:	9c7fe0ef          	jal	80002dd8 <dirlookup>
    80004416:	892a                	mv	s2,a0
    80004418:	0e050863          	beqz	a0,80004508 <sys_unlink+0x15e>
  ilock(ip);
    8000441c:	d48fe0ef          	jal	80002964 <ilock>
  if(ip->nlink < 1)
    80004420:	04a91783          	lh	a5,74(s2)
    80004424:	06f05763          	blez	a5,80004492 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004428:	04491703          	lh	a4,68(s2)
    8000442c:	4785                	li	a5,1
    8000442e:	06f70963          	beq	a4,a5,800044a0 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004432:	4641                	li	a2,16
    80004434:	4581                	li	a1,0
    80004436:	fc040513          	addi	a0,s0,-64
    8000443a:	cfbfb0ef          	jal	80000134 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000443e:	4741                	li	a4,16
    80004440:	f2c42683          	lw	a3,-212(s0)
    80004444:	fc040613          	addi	a2,s0,-64
    80004448:	4581                	li	a1,0
    8000444a:	8526                	mv	a0,s1
    8000444c:	869fe0ef          	jal	80002cb4 <writei>
    80004450:	47c1                	li	a5,16
    80004452:	08f51b63          	bne	a0,a5,800044e8 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004456:	04491703          	lh	a4,68(s2)
    8000445a:	4785                	li	a5,1
    8000445c:	08f70d63          	beq	a4,a5,800044f6 <sys_unlink+0x14c>
  iunlockput(dp);
    80004460:	8526                	mv	a0,s1
    80004462:	f0cfe0ef          	jal	80002b6e <iunlockput>
  ip->nlink--;
    80004466:	04a95783          	lhu	a5,74(s2)
    8000446a:	37fd                	addiw	a5,a5,-1
    8000446c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004470:	854a                	mv	a0,s2
    80004472:	c3efe0ef          	jal	800028b0 <iupdate>
  iunlockput(ip);
    80004476:	854a                	mv	a0,s2
    80004478:	ef6fe0ef          	jal	80002b6e <iunlockput>
  end_op();
    8000447c:	de9fe0ef          	jal	80003264 <end_op>
  return 0;
    80004480:	4501                	li	a0,0
    80004482:	64ee                	ld	s1,216(sp)
    80004484:	694e                	ld	s2,208(sp)
    80004486:	a849                	j	80004518 <sys_unlink+0x16e>
    end_op();
    80004488:	dddfe0ef          	jal	80003264 <end_op>
    return -1;
    8000448c:	557d                	li	a0,-1
    8000448e:	64ee                	ld	s1,216(sp)
    80004490:	a061                	j	80004518 <sys_unlink+0x16e>
    80004492:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004494:	00003517          	auipc	a0,0x3
    80004498:	29450513          	addi	a0,a0,660 # 80007728 <etext+0x728>
    8000449c:	276010ef          	jal	80005712 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800044a0:	04c92703          	lw	a4,76(s2)
    800044a4:	02000793          	li	a5,32
    800044a8:	f8e7f5e3          	bgeu	a5,a4,80004432 <sys_unlink+0x88>
    800044ac:	e5ce                	sd	s3,200(sp)
    800044ae:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800044b2:	4741                	li	a4,16
    800044b4:	86ce                	mv	a3,s3
    800044b6:	f1840613          	addi	a2,s0,-232
    800044ba:	4581                	li	a1,0
    800044bc:	854a                	mv	a0,s2
    800044be:	efafe0ef          	jal	80002bb8 <readi>
    800044c2:	47c1                	li	a5,16
    800044c4:	00f51c63          	bne	a0,a5,800044dc <sys_unlink+0x132>
    if(de.inum != 0)
    800044c8:	f1845783          	lhu	a5,-232(s0)
    800044cc:	efa1                	bnez	a5,80004524 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800044ce:	29c1                	addiw	s3,s3,16
    800044d0:	04c92783          	lw	a5,76(s2)
    800044d4:	fcf9efe3          	bltu	s3,a5,800044b2 <sys_unlink+0x108>
    800044d8:	69ae                	ld	s3,200(sp)
    800044da:	bfa1                	j	80004432 <sys_unlink+0x88>
      panic("isdirempty: readi");
    800044dc:	00003517          	auipc	a0,0x3
    800044e0:	26450513          	addi	a0,a0,612 # 80007740 <etext+0x740>
    800044e4:	22e010ef          	jal	80005712 <panic>
    800044e8:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800044ea:	00003517          	auipc	a0,0x3
    800044ee:	26e50513          	addi	a0,a0,622 # 80007758 <etext+0x758>
    800044f2:	220010ef          	jal	80005712 <panic>
    dp->nlink--;
    800044f6:	04a4d783          	lhu	a5,74(s1)
    800044fa:	37fd                	addiw	a5,a5,-1
    800044fc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004500:	8526                	mv	a0,s1
    80004502:	baefe0ef          	jal	800028b0 <iupdate>
    80004506:	bfa9                	j	80004460 <sys_unlink+0xb6>
    80004508:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    8000450a:	8526                	mv	a0,s1
    8000450c:	e62fe0ef          	jal	80002b6e <iunlockput>
  end_op();
    80004510:	d55fe0ef          	jal	80003264 <end_op>
  return -1;
    80004514:	557d                	li	a0,-1
    80004516:	64ee                	ld	s1,216(sp)
}
    80004518:	70ae                	ld	ra,232(sp)
    8000451a:	740e                	ld	s0,224(sp)
    8000451c:	616d                	addi	sp,sp,240
    8000451e:	8082                	ret
    return -1;
    80004520:	557d                	li	a0,-1
    80004522:	bfdd                	j	80004518 <sys_unlink+0x16e>
    iunlockput(ip);
    80004524:	854a                	mv	a0,s2
    80004526:	e48fe0ef          	jal	80002b6e <iunlockput>
    goto bad;
    8000452a:	694e                	ld	s2,208(sp)
    8000452c:	69ae                	ld	s3,200(sp)
    8000452e:	bff1                	j	8000450a <sys_unlink+0x160>

0000000080004530 <sys_open>:

uint64
sys_open(void)
{
    80004530:	7131                	addi	sp,sp,-192
    80004532:	fd06                	sd	ra,184(sp)
    80004534:	f922                	sd	s0,176(sp)
    80004536:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004538:	f4c40593          	addi	a1,s0,-180
    8000453c:	4505                	li	a0,1
    8000453e:	ed8fd0ef          	jal	80001c16 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004542:	08000613          	li	a2,128
    80004546:	f5040593          	addi	a1,s0,-176
    8000454a:	4501                	li	a0,0
    8000454c:	f02fd0ef          	jal	80001c4e <argstr>
    80004550:	87aa                	mv	a5,a0
    return -1;
    80004552:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004554:	0a07c263          	bltz	a5,800045f8 <sys_open+0xc8>
    80004558:	f526                	sd	s1,168(sp)

  begin_op();
    8000455a:	ca1fe0ef          	jal	800031fa <begin_op>

  if(omode & O_CREATE){
    8000455e:	f4c42783          	lw	a5,-180(s0)
    80004562:	2007f793          	andi	a5,a5,512
    80004566:	c3d5                	beqz	a5,8000460a <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004568:	4681                	li	a3,0
    8000456a:	4601                	li	a2,0
    8000456c:	4589                	li	a1,2
    8000456e:	f5040513          	addi	a0,s0,-176
    80004572:	aa9ff0ef          	jal	8000401a <create>
    80004576:	84aa                	mv	s1,a0
    if(ip == 0){
    80004578:	c541                	beqz	a0,80004600 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000457a:	04449703          	lh	a4,68(s1)
    8000457e:	478d                	li	a5,3
    80004580:	00f71763          	bne	a4,a5,8000458e <sys_open+0x5e>
    80004584:	0464d703          	lhu	a4,70(s1)
    80004588:	47a5                	li	a5,9
    8000458a:	0ae7ed63          	bltu	a5,a4,80004644 <sys_open+0x114>
    8000458e:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004590:	fe1fe0ef          	jal	80003570 <filealloc>
    80004594:	892a                	mv	s2,a0
    80004596:	c179                	beqz	a0,8000465c <sys_open+0x12c>
    80004598:	ed4e                	sd	s3,152(sp)
    8000459a:	a43ff0ef          	jal	80003fdc <fdalloc>
    8000459e:	89aa                	mv	s3,a0
    800045a0:	0a054a63          	bltz	a0,80004654 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800045a4:	04449703          	lh	a4,68(s1)
    800045a8:	478d                	li	a5,3
    800045aa:	0cf70263          	beq	a4,a5,8000466e <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800045ae:	4789                	li	a5,2
    800045b0:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800045b4:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800045b8:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800045bc:	f4c42783          	lw	a5,-180(s0)
    800045c0:	0017c713          	xori	a4,a5,1
    800045c4:	8b05                	andi	a4,a4,1
    800045c6:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800045ca:	0037f713          	andi	a4,a5,3
    800045ce:	00e03733          	snez	a4,a4
    800045d2:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800045d6:	4007f793          	andi	a5,a5,1024
    800045da:	c791                	beqz	a5,800045e6 <sys_open+0xb6>
    800045dc:	04449703          	lh	a4,68(s1)
    800045e0:	4789                	li	a5,2
    800045e2:	08f70d63          	beq	a4,a5,8000467c <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800045e6:	8526                	mv	a0,s1
    800045e8:	c2afe0ef          	jal	80002a12 <iunlock>
  end_op();
    800045ec:	c79fe0ef          	jal	80003264 <end_op>

  return fd;
    800045f0:	854e                	mv	a0,s3
    800045f2:	74aa                	ld	s1,168(sp)
    800045f4:	790a                	ld	s2,160(sp)
    800045f6:	69ea                	ld	s3,152(sp)
}
    800045f8:	70ea                	ld	ra,184(sp)
    800045fa:	744a                	ld	s0,176(sp)
    800045fc:	6129                	addi	sp,sp,192
    800045fe:	8082                	ret
      end_op();
    80004600:	c65fe0ef          	jal	80003264 <end_op>
      return -1;
    80004604:	557d                	li	a0,-1
    80004606:	74aa                	ld	s1,168(sp)
    80004608:	bfc5                	j	800045f8 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    8000460a:	f5040513          	addi	a0,s0,-176
    8000460e:	a31fe0ef          	jal	8000303e <namei>
    80004612:	84aa                	mv	s1,a0
    80004614:	c11d                	beqz	a0,8000463a <sys_open+0x10a>
    ilock(ip);
    80004616:	b4efe0ef          	jal	80002964 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000461a:	04449703          	lh	a4,68(s1)
    8000461e:	4785                	li	a5,1
    80004620:	f4f71de3          	bne	a4,a5,8000457a <sys_open+0x4a>
    80004624:	f4c42783          	lw	a5,-180(s0)
    80004628:	d3bd                	beqz	a5,8000458e <sys_open+0x5e>
      iunlockput(ip);
    8000462a:	8526                	mv	a0,s1
    8000462c:	d42fe0ef          	jal	80002b6e <iunlockput>
      end_op();
    80004630:	c35fe0ef          	jal	80003264 <end_op>
      return -1;
    80004634:	557d                	li	a0,-1
    80004636:	74aa                	ld	s1,168(sp)
    80004638:	b7c1                	j	800045f8 <sys_open+0xc8>
      end_op();
    8000463a:	c2bfe0ef          	jal	80003264 <end_op>
      return -1;
    8000463e:	557d                	li	a0,-1
    80004640:	74aa                	ld	s1,168(sp)
    80004642:	bf5d                	j	800045f8 <sys_open+0xc8>
    iunlockput(ip);
    80004644:	8526                	mv	a0,s1
    80004646:	d28fe0ef          	jal	80002b6e <iunlockput>
    end_op();
    8000464a:	c1bfe0ef          	jal	80003264 <end_op>
    return -1;
    8000464e:	557d                	li	a0,-1
    80004650:	74aa                	ld	s1,168(sp)
    80004652:	b75d                	j	800045f8 <sys_open+0xc8>
      fileclose(f);
    80004654:	854a                	mv	a0,s2
    80004656:	fbffe0ef          	jal	80003614 <fileclose>
    8000465a:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000465c:	8526                	mv	a0,s1
    8000465e:	d10fe0ef          	jal	80002b6e <iunlockput>
    end_op();
    80004662:	c03fe0ef          	jal	80003264 <end_op>
    return -1;
    80004666:	557d                	li	a0,-1
    80004668:	74aa                	ld	s1,168(sp)
    8000466a:	790a                	ld	s2,160(sp)
    8000466c:	b771                	j	800045f8 <sys_open+0xc8>
    f->type = FD_DEVICE;
    8000466e:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004672:	04649783          	lh	a5,70(s1)
    80004676:	02f91223          	sh	a5,36(s2)
    8000467a:	bf3d                	j	800045b8 <sys_open+0x88>
    itrunc(ip);
    8000467c:	8526                	mv	a0,s1
    8000467e:	bd4fe0ef          	jal	80002a52 <itrunc>
    80004682:	b795                	j	800045e6 <sys_open+0xb6>

0000000080004684 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004684:	7175                	addi	sp,sp,-144
    80004686:	e506                	sd	ra,136(sp)
    80004688:	e122                	sd	s0,128(sp)
    8000468a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000468c:	b6ffe0ef          	jal	800031fa <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004690:	08000613          	li	a2,128
    80004694:	f7040593          	addi	a1,s0,-144
    80004698:	4501                	li	a0,0
    8000469a:	db4fd0ef          	jal	80001c4e <argstr>
    8000469e:	02054363          	bltz	a0,800046c4 <sys_mkdir+0x40>
    800046a2:	4681                	li	a3,0
    800046a4:	4601                	li	a2,0
    800046a6:	4585                	li	a1,1
    800046a8:	f7040513          	addi	a0,s0,-144
    800046ac:	96fff0ef          	jal	8000401a <create>
    800046b0:	c911                	beqz	a0,800046c4 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800046b2:	cbcfe0ef          	jal	80002b6e <iunlockput>
  end_op();
    800046b6:	baffe0ef          	jal	80003264 <end_op>
  return 0;
    800046ba:	4501                	li	a0,0
}
    800046bc:	60aa                	ld	ra,136(sp)
    800046be:	640a                	ld	s0,128(sp)
    800046c0:	6149                	addi	sp,sp,144
    800046c2:	8082                	ret
    end_op();
    800046c4:	ba1fe0ef          	jal	80003264 <end_op>
    return -1;
    800046c8:	557d                	li	a0,-1
    800046ca:	bfcd                	j	800046bc <sys_mkdir+0x38>

00000000800046cc <sys_mknod>:

uint64
sys_mknod(void)
{
    800046cc:	7135                	addi	sp,sp,-160
    800046ce:	ed06                	sd	ra,152(sp)
    800046d0:	e922                	sd	s0,144(sp)
    800046d2:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800046d4:	b27fe0ef          	jal	800031fa <begin_op>
  argint(1, &major);
    800046d8:	f6c40593          	addi	a1,s0,-148
    800046dc:	4505                	li	a0,1
    800046de:	d38fd0ef          	jal	80001c16 <argint>
  argint(2, &minor);
    800046e2:	f6840593          	addi	a1,s0,-152
    800046e6:	4509                	li	a0,2
    800046e8:	d2efd0ef          	jal	80001c16 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800046ec:	08000613          	li	a2,128
    800046f0:	f7040593          	addi	a1,s0,-144
    800046f4:	4501                	li	a0,0
    800046f6:	d58fd0ef          	jal	80001c4e <argstr>
    800046fa:	02054563          	bltz	a0,80004724 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800046fe:	f6841683          	lh	a3,-152(s0)
    80004702:	f6c41603          	lh	a2,-148(s0)
    80004706:	458d                	li	a1,3
    80004708:	f7040513          	addi	a0,s0,-144
    8000470c:	90fff0ef          	jal	8000401a <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004710:	c911                	beqz	a0,80004724 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004712:	c5cfe0ef          	jal	80002b6e <iunlockput>
  end_op();
    80004716:	b4ffe0ef          	jal	80003264 <end_op>
  return 0;
    8000471a:	4501                	li	a0,0
}
    8000471c:	60ea                	ld	ra,152(sp)
    8000471e:	644a                	ld	s0,144(sp)
    80004720:	610d                	addi	sp,sp,160
    80004722:	8082                	ret
    end_op();
    80004724:	b41fe0ef          	jal	80003264 <end_op>
    return -1;
    80004728:	557d                	li	a0,-1
    8000472a:	bfcd                	j	8000471c <sys_mknod+0x50>

000000008000472c <sys_chdir>:

uint64
sys_chdir(void)
{
    8000472c:	7135                	addi	sp,sp,-160
    8000472e:	ed06                	sd	ra,152(sp)
    80004730:	e922                	sd	s0,144(sp)
    80004732:	e14a                	sd	s2,128(sp)
    80004734:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004736:	e20fc0ef          	jal	80000d56 <myproc>
    8000473a:	892a                	mv	s2,a0
  
  begin_op();
    8000473c:	abffe0ef          	jal	800031fa <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004740:	08000613          	li	a2,128
    80004744:	f6040593          	addi	a1,s0,-160
    80004748:	4501                	li	a0,0
    8000474a:	d04fd0ef          	jal	80001c4e <argstr>
    8000474e:	04054363          	bltz	a0,80004794 <sys_chdir+0x68>
    80004752:	e526                	sd	s1,136(sp)
    80004754:	f6040513          	addi	a0,s0,-160
    80004758:	8e7fe0ef          	jal	8000303e <namei>
    8000475c:	84aa                	mv	s1,a0
    8000475e:	c915                	beqz	a0,80004792 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004760:	a04fe0ef          	jal	80002964 <ilock>
  if(ip->type != T_DIR){
    80004764:	04449703          	lh	a4,68(s1)
    80004768:	4785                	li	a5,1
    8000476a:	02f71963          	bne	a4,a5,8000479c <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000476e:	8526                	mv	a0,s1
    80004770:	aa2fe0ef          	jal	80002a12 <iunlock>
  iput(p->cwd);
    80004774:	15093503          	ld	a0,336(s2)
    80004778:	b6efe0ef          	jal	80002ae6 <iput>
  end_op();
    8000477c:	ae9fe0ef          	jal	80003264 <end_op>
  p->cwd = ip;
    80004780:	14993823          	sd	s1,336(s2)
  return 0;
    80004784:	4501                	li	a0,0
    80004786:	64aa                	ld	s1,136(sp)
}
    80004788:	60ea                	ld	ra,152(sp)
    8000478a:	644a                	ld	s0,144(sp)
    8000478c:	690a                	ld	s2,128(sp)
    8000478e:	610d                	addi	sp,sp,160
    80004790:	8082                	ret
    80004792:	64aa                	ld	s1,136(sp)
    end_op();
    80004794:	ad1fe0ef          	jal	80003264 <end_op>
    return -1;
    80004798:	557d                	li	a0,-1
    8000479a:	b7fd                	j	80004788 <sys_chdir+0x5c>
    iunlockput(ip);
    8000479c:	8526                	mv	a0,s1
    8000479e:	bd0fe0ef          	jal	80002b6e <iunlockput>
    end_op();
    800047a2:	ac3fe0ef          	jal	80003264 <end_op>
    return -1;
    800047a6:	557d                	li	a0,-1
    800047a8:	64aa                	ld	s1,136(sp)
    800047aa:	bff9                	j	80004788 <sys_chdir+0x5c>

00000000800047ac <sys_exec>:

uint64
sys_exec(void)
{
    800047ac:	7121                	addi	sp,sp,-448
    800047ae:	ff06                	sd	ra,440(sp)
    800047b0:	fb22                	sd	s0,432(sp)
    800047b2:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800047b4:	e4840593          	addi	a1,s0,-440
    800047b8:	4505                	li	a0,1
    800047ba:	c78fd0ef          	jal	80001c32 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800047be:	08000613          	li	a2,128
    800047c2:	f5040593          	addi	a1,s0,-176
    800047c6:	4501                	li	a0,0
    800047c8:	c86fd0ef          	jal	80001c4e <argstr>
    800047cc:	87aa                	mv	a5,a0
    return -1;
    800047ce:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800047d0:	0c07c463          	bltz	a5,80004898 <sys_exec+0xec>
    800047d4:	f726                	sd	s1,424(sp)
    800047d6:	f34a                	sd	s2,416(sp)
    800047d8:	ef4e                	sd	s3,408(sp)
    800047da:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800047dc:	10000613          	li	a2,256
    800047e0:	4581                	li	a1,0
    800047e2:	e5040513          	addi	a0,s0,-432
    800047e6:	94ffb0ef          	jal	80000134 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800047ea:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800047ee:	89a6                	mv	s3,s1
    800047f0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800047f2:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800047f6:	00391513          	slli	a0,s2,0x3
    800047fa:	e4040593          	addi	a1,s0,-448
    800047fe:	e4843783          	ld	a5,-440(s0)
    80004802:	953e                	add	a0,a0,a5
    80004804:	b88fd0ef          	jal	80001b8c <fetchaddr>
    80004808:	02054663          	bltz	a0,80004834 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    8000480c:	e4043783          	ld	a5,-448(s0)
    80004810:	c3a9                	beqz	a5,80004852 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004812:	8e5fb0ef          	jal	800000f6 <kalloc>
    80004816:	85aa                	mv	a1,a0
    80004818:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000481c:	cd01                	beqz	a0,80004834 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000481e:	6605                	lui	a2,0x1
    80004820:	e4043503          	ld	a0,-448(s0)
    80004824:	bb2fd0ef          	jal	80001bd6 <fetchstr>
    80004828:	00054663          	bltz	a0,80004834 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    8000482c:	0905                	addi	s2,s2,1
    8000482e:	09a1                	addi	s3,s3,8
    80004830:	fd4913e3          	bne	s2,s4,800047f6 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004834:	f5040913          	addi	s2,s0,-176
    80004838:	6088                	ld	a0,0(s1)
    8000483a:	c931                	beqz	a0,8000488e <sys_exec+0xe2>
    kfree(argv[i]);
    8000483c:	fe0fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004840:	04a1                	addi	s1,s1,8
    80004842:	ff249be3          	bne	s1,s2,80004838 <sys_exec+0x8c>
  return -1;
    80004846:	557d                	li	a0,-1
    80004848:	74ba                	ld	s1,424(sp)
    8000484a:	791a                	ld	s2,416(sp)
    8000484c:	69fa                	ld	s3,408(sp)
    8000484e:	6a5a                	ld	s4,400(sp)
    80004850:	a0a1                	j	80004898 <sys_exec+0xec>
      argv[i] = 0;
    80004852:	0009079b          	sext.w	a5,s2
    80004856:	078e                	slli	a5,a5,0x3
    80004858:	fd078793          	addi	a5,a5,-48
    8000485c:	97a2                	add	a5,a5,s0
    8000485e:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004862:	e5040593          	addi	a1,s0,-432
    80004866:	f5040513          	addi	a0,s0,-176
    8000486a:	ba8ff0ef          	jal	80003c12 <exec>
    8000486e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004870:	f5040993          	addi	s3,s0,-176
    80004874:	6088                	ld	a0,0(s1)
    80004876:	c511                	beqz	a0,80004882 <sys_exec+0xd6>
    kfree(argv[i]);
    80004878:	fa4fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000487c:	04a1                	addi	s1,s1,8
    8000487e:	ff349be3          	bne	s1,s3,80004874 <sys_exec+0xc8>
  return ret;
    80004882:	854a                	mv	a0,s2
    80004884:	74ba                	ld	s1,424(sp)
    80004886:	791a                	ld	s2,416(sp)
    80004888:	69fa                	ld	s3,408(sp)
    8000488a:	6a5a                	ld	s4,400(sp)
    8000488c:	a031                	j	80004898 <sys_exec+0xec>
  return -1;
    8000488e:	557d                	li	a0,-1
    80004890:	74ba                	ld	s1,424(sp)
    80004892:	791a                	ld	s2,416(sp)
    80004894:	69fa                	ld	s3,408(sp)
    80004896:	6a5a                	ld	s4,400(sp)
}
    80004898:	70fa                	ld	ra,440(sp)
    8000489a:	745a                	ld	s0,432(sp)
    8000489c:	6139                	addi	sp,sp,448
    8000489e:	8082                	ret

00000000800048a0 <sys_pipe>:

uint64
sys_pipe(void)
{
    800048a0:	7139                	addi	sp,sp,-64
    800048a2:	fc06                	sd	ra,56(sp)
    800048a4:	f822                	sd	s0,48(sp)
    800048a6:	f426                	sd	s1,40(sp)
    800048a8:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800048aa:	cacfc0ef          	jal	80000d56 <myproc>
    800048ae:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800048b0:	fd840593          	addi	a1,s0,-40
    800048b4:	4501                	li	a0,0
    800048b6:	b7cfd0ef          	jal	80001c32 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800048ba:	fc840593          	addi	a1,s0,-56
    800048be:	fd040513          	addi	a0,s0,-48
    800048c2:	85cff0ef          	jal	8000391e <pipealloc>
    return -1;
    800048c6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800048c8:	0a054463          	bltz	a0,80004970 <sys_pipe+0xd0>
  fd0 = -1;
    800048cc:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800048d0:	fd043503          	ld	a0,-48(s0)
    800048d4:	f08ff0ef          	jal	80003fdc <fdalloc>
    800048d8:	fca42223          	sw	a0,-60(s0)
    800048dc:	08054163          	bltz	a0,8000495e <sys_pipe+0xbe>
    800048e0:	fc843503          	ld	a0,-56(s0)
    800048e4:	ef8ff0ef          	jal	80003fdc <fdalloc>
    800048e8:	fca42023          	sw	a0,-64(s0)
    800048ec:	06054063          	bltz	a0,8000494c <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800048f0:	4691                	li	a3,4
    800048f2:	fc440613          	addi	a2,s0,-60
    800048f6:	fd843583          	ld	a1,-40(s0)
    800048fa:	68a8                	ld	a0,80(s1)
    800048fc:	8cafc0ef          	jal	800009c6 <copyout>
    80004900:	00054e63          	bltz	a0,8000491c <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004904:	4691                	li	a3,4
    80004906:	fc040613          	addi	a2,s0,-64
    8000490a:	fd843583          	ld	a1,-40(s0)
    8000490e:	0591                	addi	a1,a1,4
    80004910:	68a8                	ld	a0,80(s1)
    80004912:	8b4fc0ef          	jal	800009c6 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004916:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004918:	04055c63          	bgez	a0,80004970 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000491c:	fc442783          	lw	a5,-60(s0)
    80004920:	07e9                	addi	a5,a5,26
    80004922:	078e                	slli	a5,a5,0x3
    80004924:	97a6                	add	a5,a5,s1
    80004926:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000492a:	fc042783          	lw	a5,-64(s0)
    8000492e:	07e9                	addi	a5,a5,26
    80004930:	078e                	slli	a5,a5,0x3
    80004932:	94be                	add	s1,s1,a5
    80004934:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004938:	fd043503          	ld	a0,-48(s0)
    8000493c:	cd9fe0ef          	jal	80003614 <fileclose>
    fileclose(wf);
    80004940:	fc843503          	ld	a0,-56(s0)
    80004944:	cd1fe0ef          	jal	80003614 <fileclose>
    return -1;
    80004948:	57fd                	li	a5,-1
    8000494a:	a01d                	j	80004970 <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000494c:	fc442783          	lw	a5,-60(s0)
    80004950:	0007c763          	bltz	a5,8000495e <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004954:	07e9                	addi	a5,a5,26
    80004956:	078e                	slli	a5,a5,0x3
    80004958:	97a6                	add	a5,a5,s1
    8000495a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000495e:	fd043503          	ld	a0,-48(s0)
    80004962:	cb3fe0ef          	jal	80003614 <fileclose>
    fileclose(wf);
    80004966:	fc843503          	ld	a0,-56(s0)
    8000496a:	cabfe0ef          	jal	80003614 <fileclose>
    return -1;
    8000496e:	57fd                	li	a5,-1
}
    80004970:	853e                	mv	a0,a5
    80004972:	70e2                	ld	ra,56(sp)
    80004974:	7442                	ld	s0,48(sp)
    80004976:	74a2                	ld	s1,40(sp)
    80004978:	6121                	addi	sp,sp,64
    8000497a:	8082                	ret
    8000497c:	0000                	unimp
	...

0000000080004980 <kernelvec>:
    80004980:	7111                	addi	sp,sp,-256
    80004982:	e006                	sd	ra,0(sp)
    80004984:	e40a                	sd	sp,8(sp)
    80004986:	e80e                	sd	gp,16(sp)
    80004988:	ec12                	sd	tp,24(sp)
    8000498a:	f016                	sd	t0,32(sp)
    8000498c:	f41a                	sd	t1,40(sp)
    8000498e:	f81e                	sd	t2,48(sp)
    80004990:	e4aa                	sd	a0,72(sp)
    80004992:	e8ae                	sd	a1,80(sp)
    80004994:	ecb2                	sd	a2,88(sp)
    80004996:	f0b6                	sd	a3,96(sp)
    80004998:	f4ba                	sd	a4,104(sp)
    8000499a:	f8be                	sd	a5,112(sp)
    8000499c:	fcc2                	sd	a6,120(sp)
    8000499e:	e146                	sd	a7,128(sp)
    800049a0:	edf2                	sd	t3,216(sp)
    800049a2:	f1f6                	sd	t4,224(sp)
    800049a4:	f5fa                	sd	t5,232(sp)
    800049a6:	f9fe                	sd	t6,240(sp)
    800049a8:	8f4fd0ef          	jal	80001a9c <kerneltrap>
    800049ac:	6082                	ld	ra,0(sp)
    800049ae:	6122                	ld	sp,8(sp)
    800049b0:	61c2                	ld	gp,16(sp)
    800049b2:	7282                	ld	t0,32(sp)
    800049b4:	7322                	ld	t1,40(sp)
    800049b6:	73c2                	ld	t2,48(sp)
    800049b8:	6526                	ld	a0,72(sp)
    800049ba:	65c6                	ld	a1,80(sp)
    800049bc:	6666                	ld	a2,88(sp)
    800049be:	7686                	ld	a3,96(sp)
    800049c0:	7726                	ld	a4,104(sp)
    800049c2:	77c6                	ld	a5,112(sp)
    800049c4:	7866                	ld	a6,120(sp)
    800049c6:	688a                	ld	a7,128(sp)
    800049c8:	6e6e                	ld	t3,216(sp)
    800049ca:	7e8e                	ld	t4,224(sp)
    800049cc:	7f2e                	ld	t5,232(sp)
    800049ce:	7fce                	ld	t6,240(sp)
    800049d0:	6111                	addi	sp,sp,256
    800049d2:	10200073          	sret
	...

00000000800049de <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800049de:	1141                	addi	sp,sp,-16
    800049e0:	e422                	sd	s0,8(sp)
    800049e2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800049e4:	0c0007b7          	lui	a5,0xc000
    800049e8:	4705                	li	a4,1
    800049ea:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800049ec:	0c0007b7          	lui	a5,0xc000
    800049f0:	c3d8                	sw	a4,4(a5)
}
    800049f2:	6422                	ld	s0,8(sp)
    800049f4:	0141                	addi	sp,sp,16
    800049f6:	8082                	ret

00000000800049f8 <plicinithart>:

void
plicinithart(void)
{
    800049f8:	1141                	addi	sp,sp,-16
    800049fa:	e406                	sd	ra,8(sp)
    800049fc:	e022                	sd	s0,0(sp)
    800049fe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004a00:	b2afc0ef          	jal	80000d2a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004a04:	0085171b          	slliw	a4,a0,0x8
    80004a08:	0c0027b7          	lui	a5,0xc002
    80004a0c:	97ba                	add	a5,a5,a4
    80004a0e:	40200713          	li	a4,1026
    80004a12:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004a16:	00d5151b          	slliw	a0,a0,0xd
    80004a1a:	0c2017b7          	lui	a5,0xc201
    80004a1e:	97aa                	add	a5,a5,a0
    80004a20:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004a24:	60a2                	ld	ra,8(sp)
    80004a26:	6402                	ld	s0,0(sp)
    80004a28:	0141                	addi	sp,sp,16
    80004a2a:	8082                	ret

0000000080004a2c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004a2c:	1141                	addi	sp,sp,-16
    80004a2e:	e406                	sd	ra,8(sp)
    80004a30:	e022                	sd	s0,0(sp)
    80004a32:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004a34:	af6fc0ef          	jal	80000d2a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004a38:	00d5151b          	slliw	a0,a0,0xd
    80004a3c:	0c2017b7          	lui	a5,0xc201
    80004a40:	97aa                	add	a5,a5,a0
  return irq;
}
    80004a42:	43c8                	lw	a0,4(a5)
    80004a44:	60a2                	ld	ra,8(sp)
    80004a46:	6402                	ld	s0,0(sp)
    80004a48:	0141                	addi	sp,sp,16
    80004a4a:	8082                	ret

0000000080004a4c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004a4c:	1101                	addi	sp,sp,-32
    80004a4e:	ec06                	sd	ra,24(sp)
    80004a50:	e822                	sd	s0,16(sp)
    80004a52:	e426                	sd	s1,8(sp)
    80004a54:	1000                	addi	s0,sp,32
    80004a56:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004a58:	ad2fc0ef          	jal	80000d2a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004a5c:	00d5151b          	slliw	a0,a0,0xd
    80004a60:	0c2017b7          	lui	a5,0xc201
    80004a64:	97aa                	add	a5,a5,a0
    80004a66:	c3c4                	sw	s1,4(a5)
}
    80004a68:	60e2                	ld	ra,24(sp)
    80004a6a:	6442                	ld	s0,16(sp)
    80004a6c:	64a2                	ld	s1,8(sp)
    80004a6e:	6105                	addi	sp,sp,32
    80004a70:	8082                	ret

0000000080004a72 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004a72:	1141                	addi	sp,sp,-16
    80004a74:	e406                	sd	ra,8(sp)
    80004a76:	e022                	sd	s0,0(sp)
    80004a78:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004a7a:	479d                	li	a5,7
    80004a7c:	04a7ca63          	blt	a5,a0,80004ad0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004a80:	00017797          	auipc	a5,0x17
    80004a84:	1a078793          	addi	a5,a5,416 # 8001bc20 <disk>
    80004a88:	97aa                	add	a5,a5,a0
    80004a8a:	0187c783          	lbu	a5,24(a5)
    80004a8e:	e7b9                	bnez	a5,80004adc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004a90:	00451693          	slli	a3,a0,0x4
    80004a94:	00017797          	auipc	a5,0x17
    80004a98:	18c78793          	addi	a5,a5,396 # 8001bc20 <disk>
    80004a9c:	6398                	ld	a4,0(a5)
    80004a9e:	9736                	add	a4,a4,a3
    80004aa0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004aa4:	6398                	ld	a4,0(a5)
    80004aa6:	9736                	add	a4,a4,a3
    80004aa8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004aac:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004ab0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004ab4:	97aa                	add	a5,a5,a0
    80004ab6:	4705                	li	a4,1
    80004ab8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004abc:	00017517          	auipc	a0,0x17
    80004ac0:	17c50513          	addi	a0,a0,380 # 8001bc38 <disk+0x18>
    80004ac4:	8b9fc0ef          	jal	8000137c <wakeup>
}
    80004ac8:	60a2                	ld	ra,8(sp)
    80004aca:	6402                	ld	s0,0(sp)
    80004acc:	0141                	addi	sp,sp,16
    80004ace:	8082                	ret
    panic("free_desc 1");
    80004ad0:	00003517          	auipc	a0,0x3
    80004ad4:	c9850513          	addi	a0,a0,-872 # 80007768 <etext+0x768>
    80004ad8:	43b000ef          	jal	80005712 <panic>
    panic("free_desc 2");
    80004adc:	00003517          	auipc	a0,0x3
    80004ae0:	c9c50513          	addi	a0,a0,-868 # 80007778 <etext+0x778>
    80004ae4:	42f000ef          	jal	80005712 <panic>

0000000080004ae8 <virtio_disk_init>:
{
    80004ae8:	1101                	addi	sp,sp,-32
    80004aea:	ec06                	sd	ra,24(sp)
    80004aec:	e822                	sd	s0,16(sp)
    80004aee:	e426                	sd	s1,8(sp)
    80004af0:	e04a                	sd	s2,0(sp)
    80004af2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004af4:	00003597          	auipc	a1,0x3
    80004af8:	c9458593          	addi	a1,a1,-876 # 80007788 <etext+0x788>
    80004afc:	00017517          	auipc	a0,0x17
    80004b00:	24c50513          	addi	a0,a0,588 # 8001bd48 <disk+0x128>
    80004b04:	6bd000ef          	jal	800059c0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004b08:	100017b7          	lui	a5,0x10001
    80004b0c:	4398                	lw	a4,0(a5)
    80004b0e:	2701                	sext.w	a4,a4
    80004b10:	747277b7          	lui	a5,0x74727
    80004b14:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004b18:	18f71063          	bne	a4,a5,80004c98 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004b1c:	100017b7          	lui	a5,0x10001
    80004b20:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004b22:	439c                	lw	a5,0(a5)
    80004b24:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004b26:	4709                	li	a4,2
    80004b28:	16e79863          	bne	a5,a4,80004c98 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004b2c:	100017b7          	lui	a5,0x10001
    80004b30:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004b32:	439c                	lw	a5,0(a5)
    80004b34:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004b36:	16e79163          	bne	a5,a4,80004c98 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004b3a:	100017b7          	lui	a5,0x10001
    80004b3e:	47d8                	lw	a4,12(a5)
    80004b40:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004b42:	554d47b7          	lui	a5,0x554d4
    80004b46:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004b4a:	14f71763          	bne	a4,a5,80004c98 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b4e:	100017b7          	lui	a5,0x10001
    80004b52:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b56:	4705                	li	a4,1
    80004b58:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b5a:	470d                	li	a4,3
    80004b5c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004b5e:	10001737          	lui	a4,0x10001
    80004b62:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004b64:	c7ffe737          	lui	a4,0xc7ffe
    80004b68:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fda8ff>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004b6c:	8ef9                	and	a3,a3,a4
    80004b6e:	10001737          	lui	a4,0x10001
    80004b72:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b74:	472d                	li	a4,11
    80004b76:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b78:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004b7c:	439c                	lw	a5,0(a5)
    80004b7e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004b82:	8ba1                	andi	a5,a5,8
    80004b84:	12078063          	beqz	a5,80004ca4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004b88:	100017b7          	lui	a5,0x10001
    80004b8c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004b90:	100017b7          	lui	a5,0x10001
    80004b94:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004b98:	439c                	lw	a5,0(a5)
    80004b9a:	2781                	sext.w	a5,a5
    80004b9c:	10079a63          	bnez	a5,80004cb0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004ba0:	100017b7          	lui	a5,0x10001
    80004ba4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004ba8:	439c                	lw	a5,0(a5)
    80004baa:	2781                	sext.w	a5,a5
  if(max == 0)
    80004bac:	10078863          	beqz	a5,80004cbc <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004bb0:	471d                	li	a4,7
    80004bb2:	10f77b63          	bgeu	a4,a5,80004cc8 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004bb6:	d40fb0ef          	jal	800000f6 <kalloc>
    80004bba:	00017497          	auipc	s1,0x17
    80004bbe:	06648493          	addi	s1,s1,102 # 8001bc20 <disk>
    80004bc2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004bc4:	d32fb0ef          	jal	800000f6 <kalloc>
    80004bc8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004bca:	d2cfb0ef          	jal	800000f6 <kalloc>
    80004bce:	87aa                	mv	a5,a0
    80004bd0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004bd2:	6088                	ld	a0,0(s1)
    80004bd4:	10050063          	beqz	a0,80004cd4 <virtio_disk_init+0x1ec>
    80004bd8:	00017717          	auipc	a4,0x17
    80004bdc:	05073703          	ld	a4,80(a4) # 8001bc28 <disk+0x8>
    80004be0:	0e070a63          	beqz	a4,80004cd4 <virtio_disk_init+0x1ec>
    80004be4:	0e078863          	beqz	a5,80004cd4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004be8:	6605                	lui	a2,0x1
    80004bea:	4581                	li	a1,0
    80004bec:	d48fb0ef          	jal	80000134 <memset>
  memset(disk.avail, 0, PGSIZE);
    80004bf0:	00017497          	auipc	s1,0x17
    80004bf4:	03048493          	addi	s1,s1,48 # 8001bc20 <disk>
    80004bf8:	6605                	lui	a2,0x1
    80004bfa:	4581                	li	a1,0
    80004bfc:	6488                	ld	a0,8(s1)
    80004bfe:	d36fb0ef          	jal	80000134 <memset>
  memset(disk.used, 0, PGSIZE);
    80004c02:	6605                	lui	a2,0x1
    80004c04:	4581                	li	a1,0
    80004c06:	6888                	ld	a0,16(s1)
    80004c08:	d2cfb0ef          	jal	80000134 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004c0c:	100017b7          	lui	a5,0x10001
    80004c10:	4721                	li	a4,8
    80004c12:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004c14:	4098                	lw	a4,0(s1)
    80004c16:	100017b7          	lui	a5,0x10001
    80004c1a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004c1e:	40d8                	lw	a4,4(s1)
    80004c20:	100017b7          	lui	a5,0x10001
    80004c24:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004c28:	649c                	ld	a5,8(s1)
    80004c2a:	0007869b          	sext.w	a3,a5
    80004c2e:	10001737          	lui	a4,0x10001
    80004c32:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004c36:	9781                	srai	a5,a5,0x20
    80004c38:	10001737          	lui	a4,0x10001
    80004c3c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004c40:	689c                	ld	a5,16(s1)
    80004c42:	0007869b          	sext.w	a3,a5
    80004c46:	10001737          	lui	a4,0x10001
    80004c4a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004c4e:	9781                	srai	a5,a5,0x20
    80004c50:	10001737          	lui	a4,0x10001
    80004c54:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004c58:	10001737          	lui	a4,0x10001
    80004c5c:	4785                	li	a5,1
    80004c5e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004c60:	00f48c23          	sb	a5,24(s1)
    80004c64:	00f48ca3          	sb	a5,25(s1)
    80004c68:	00f48d23          	sb	a5,26(s1)
    80004c6c:	00f48da3          	sb	a5,27(s1)
    80004c70:	00f48e23          	sb	a5,28(s1)
    80004c74:	00f48ea3          	sb	a5,29(s1)
    80004c78:	00f48f23          	sb	a5,30(s1)
    80004c7c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004c80:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c84:	100017b7          	lui	a5,0x10001
    80004c88:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004c8c:	60e2                	ld	ra,24(sp)
    80004c8e:	6442                	ld	s0,16(sp)
    80004c90:	64a2                	ld	s1,8(sp)
    80004c92:	6902                	ld	s2,0(sp)
    80004c94:	6105                	addi	sp,sp,32
    80004c96:	8082                	ret
    panic("could not find virtio disk");
    80004c98:	00003517          	auipc	a0,0x3
    80004c9c:	b0050513          	addi	a0,a0,-1280 # 80007798 <etext+0x798>
    80004ca0:	273000ef          	jal	80005712 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004ca4:	00003517          	auipc	a0,0x3
    80004ca8:	b1450513          	addi	a0,a0,-1260 # 800077b8 <etext+0x7b8>
    80004cac:	267000ef          	jal	80005712 <panic>
    panic("virtio disk should not be ready");
    80004cb0:	00003517          	auipc	a0,0x3
    80004cb4:	b2850513          	addi	a0,a0,-1240 # 800077d8 <etext+0x7d8>
    80004cb8:	25b000ef          	jal	80005712 <panic>
    panic("virtio disk has no queue 0");
    80004cbc:	00003517          	auipc	a0,0x3
    80004cc0:	b3c50513          	addi	a0,a0,-1220 # 800077f8 <etext+0x7f8>
    80004cc4:	24f000ef          	jal	80005712 <panic>
    panic("virtio disk max queue too short");
    80004cc8:	00003517          	auipc	a0,0x3
    80004ccc:	b5050513          	addi	a0,a0,-1200 # 80007818 <etext+0x818>
    80004cd0:	243000ef          	jal	80005712 <panic>
    panic("virtio disk kalloc");
    80004cd4:	00003517          	auipc	a0,0x3
    80004cd8:	b6450513          	addi	a0,a0,-1180 # 80007838 <etext+0x838>
    80004cdc:	237000ef          	jal	80005712 <panic>

0000000080004ce0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004ce0:	7159                	addi	sp,sp,-112
    80004ce2:	f486                	sd	ra,104(sp)
    80004ce4:	f0a2                	sd	s0,96(sp)
    80004ce6:	eca6                	sd	s1,88(sp)
    80004ce8:	e8ca                	sd	s2,80(sp)
    80004cea:	e4ce                	sd	s3,72(sp)
    80004cec:	e0d2                	sd	s4,64(sp)
    80004cee:	fc56                	sd	s5,56(sp)
    80004cf0:	f85a                	sd	s6,48(sp)
    80004cf2:	f45e                	sd	s7,40(sp)
    80004cf4:	f062                	sd	s8,32(sp)
    80004cf6:	ec66                	sd	s9,24(sp)
    80004cf8:	1880                	addi	s0,sp,112
    80004cfa:	8a2a                	mv	s4,a0
    80004cfc:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004cfe:	00c52c83          	lw	s9,12(a0)
    80004d02:	001c9c9b          	slliw	s9,s9,0x1
    80004d06:	1c82                	slli	s9,s9,0x20
    80004d08:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004d0c:	00017517          	auipc	a0,0x17
    80004d10:	03c50513          	addi	a0,a0,60 # 8001bd48 <disk+0x128>
    80004d14:	52d000ef          	jal	80005a40 <acquire>
  for(int i = 0; i < 3; i++){
    80004d18:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004d1a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004d1c:	00017b17          	auipc	s6,0x17
    80004d20:	f04b0b13          	addi	s6,s6,-252 # 8001bc20 <disk>
  for(int i = 0; i < 3; i++){
    80004d24:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004d26:	00017c17          	auipc	s8,0x17
    80004d2a:	022c0c13          	addi	s8,s8,34 # 8001bd48 <disk+0x128>
    80004d2e:	a8b9                	j	80004d8c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004d30:	00fb0733          	add	a4,s6,a5
    80004d34:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004d38:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004d3a:	0207c563          	bltz	a5,80004d64 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004d3e:	2905                	addiw	s2,s2,1
    80004d40:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004d42:	05590963          	beq	s2,s5,80004d94 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004d46:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004d48:	00017717          	auipc	a4,0x17
    80004d4c:	ed870713          	addi	a4,a4,-296 # 8001bc20 <disk>
    80004d50:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004d52:	01874683          	lbu	a3,24(a4)
    80004d56:	fee9                	bnez	a3,80004d30 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004d58:	2785                	addiw	a5,a5,1
    80004d5a:	0705                	addi	a4,a4,1
    80004d5c:	fe979be3          	bne	a5,s1,80004d52 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004d60:	57fd                	li	a5,-1
    80004d62:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004d64:	01205d63          	blez	s2,80004d7e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004d68:	f9042503          	lw	a0,-112(s0)
    80004d6c:	d07ff0ef          	jal	80004a72 <free_desc>
      for(int j = 0; j < i; j++)
    80004d70:	4785                	li	a5,1
    80004d72:	0127d663          	bge	a5,s2,80004d7e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004d76:	f9442503          	lw	a0,-108(s0)
    80004d7a:	cf9ff0ef          	jal	80004a72 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004d7e:	85e2                	mv	a1,s8
    80004d80:	00017517          	auipc	a0,0x17
    80004d84:	eb850513          	addi	a0,a0,-328 # 8001bc38 <disk+0x18>
    80004d88:	da8fc0ef          	jal	80001330 <sleep>
  for(int i = 0; i < 3; i++){
    80004d8c:	f9040613          	addi	a2,s0,-112
    80004d90:	894e                	mv	s2,s3
    80004d92:	bf55                	j	80004d46 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004d94:	f9042503          	lw	a0,-112(s0)
    80004d98:	00451693          	slli	a3,a0,0x4

  if(write)
    80004d9c:	00017797          	auipc	a5,0x17
    80004da0:	e8478793          	addi	a5,a5,-380 # 8001bc20 <disk>
    80004da4:	00a50713          	addi	a4,a0,10
    80004da8:	0712                	slli	a4,a4,0x4
    80004daa:	973e                	add	a4,a4,a5
    80004dac:	01703633          	snez	a2,s7
    80004db0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004db2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004db6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004dba:	6398                	ld	a4,0(a5)
    80004dbc:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004dbe:	0a868613          	addi	a2,a3,168
    80004dc2:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004dc4:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004dc6:	6390                	ld	a2,0(a5)
    80004dc8:	00d605b3          	add	a1,a2,a3
    80004dcc:	4741                	li	a4,16
    80004dce:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004dd0:	4805                	li	a6,1
    80004dd2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004dd6:	f9442703          	lw	a4,-108(s0)
    80004dda:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004dde:	0712                	slli	a4,a4,0x4
    80004de0:	963a                	add	a2,a2,a4
    80004de2:	058a0593          	addi	a1,s4,88
    80004de6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004de8:	0007b883          	ld	a7,0(a5)
    80004dec:	9746                	add	a4,a4,a7
    80004dee:	40000613          	li	a2,1024
    80004df2:	c710                	sw	a2,8(a4)
  if(write)
    80004df4:	001bb613          	seqz	a2,s7
    80004df8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004dfc:	00166613          	ori	a2,a2,1
    80004e00:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004e04:	f9842583          	lw	a1,-104(s0)
    80004e08:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004e0c:	00250613          	addi	a2,a0,2
    80004e10:	0612                	slli	a2,a2,0x4
    80004e12:	963e                	add	a2,a2,a5
    80004e14:	577d                	li	a4,-1
    80004e16:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004e1a:	0592                	slli	a1,a1,0x4
    80004e1c:	98ae                	add	a7,a7,a1
    80004e1e:	03068713          	addi	a4,a3,48
    80004e22:	973e                	add	a4,a4,a5
    80004e24:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004e28:	6398                	ld	a4,0(a5)
    80004e2a:	972e                	add	a4,a4,a1
    80004e2c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004e30:	4689                	li	a3,2
    80004e32:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004e36:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004e3a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004e3e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004e42:	6794                	ld	a3,8(a5)
    80004e44:	0026d703          	lhu	a4,2(a3)
    80004e48:	8b1d                	andi	a4,a4,7
    80004e4a:	0706                	slli	a4,a4,0x1
    80004e4c:	96ba                	add	a3,a3,a4
    80004e4e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004e52:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004e56:	6798                	ld	a4,8(a5)
    80004e58:	00275783          	lhu	a5,2(a4)
    80004e5c:	2785                	addiw	a5,a5,1
    80004e5e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004e62:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004e66:	100017b7          	lui	a5,0x10001
    80004e6a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004e6e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004e72:	00017917          	auipc	s2,0x17
    80004e76:	ed690913          	addi	s2,s2,-298 # 8001bd48 <disk+0x128>
  while(b->disk == 1) {
    80004e7a:	4485                	li	s1,1
    80004e7c:	01079a63          	bne	a5,a6,80004e90 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004e80:	85ca                	mv	a1,s2
    80004e82:	8552                	mv	a0,s4
    80004e84:	cacfc0ef          	jal	80001330 <sleep>
  while(b->disk == 1) {
    80004e88:	004a2783          	lw	a5,4(s4)
    80004e8c:	fe978ae3          	beq	a5,s1,80004e80 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004e90:	f9042903          	lw	s2,-112(s0)
    80004e94:	00290713          	addi	a4,s2,2
    80004e98:	0712                	slli	a4,a4,0x4
    80004e9a:	00017797          	auipc	a5,0x17
    80004e9e:	d8678793          	addi	a5,a5,-634 # 8001bc20 <disk>
    80004ea2:	97ba                	add	a5,a5,a4
    80004ea4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004ea8:	00017997          	auipc	s3,0x17
    80004eac:	d7898993          	addi	s3,s3,-648 # 8001bc20 <disk>
    80004eb0:	00491713          	slli	a4,s2,0x4
    80004eb4:	0009b783          	ld	a5,0(s3)
    80004eb8:	97ba                	add	a5,a5,a4
    80004eba:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004ebe:	854a                	mv	a0,s2
    80004ec0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004ec4:	bafff0ef          	jal	80004a72 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004ec8:	8885                	andi	s1,s1,1
    80004eca:	f0fd                	bnez	s1,80004eb0 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004ecc:	00017517          	auipc	a0,0x17
    80004ed0:	e7c50513          	addi	a0,a0,-388 # 8001bd48 <disk+0x128>
    80004ed4:	405000ef          	jal	80005ad8 <release>
}
    80004ed8:	70a6                	ld	ra,104(sp)
    80004eda:	7406                	ld	s0,96(sp)
    80004edc:	64e6                	ld	s1,88(sp)
    80004ede:	6946                	ld	s2,80(sp)
    80004ee0:	69a6                	ld	s3,72(sp)
    80004ee2:	6a06                	ld	s4,64(sp)
    80004ee4:	7ae2                	ld	s5,56(sp)
    80004ee6:	7b42                	ld	s6,48(sp)
    80004ee8:	7ba2                	ld	s7,40(sp)
    80004eea:	7c02                	ld	s8,32(sp)
    80004eec:	6ce2                	ld	s9,24(sp)
    80004eee:	6165                	addi	sp,sp,112
    80004ef0:	8082                	ret

0000000080004ef2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004ef2:	1101                	addi	sp,sp,-32
    80004ef4:	ec06                	sd	ra,24(sp)
    80004ef6:	e822                	sd	s0,16(sp)
    80004ef8:	e426                	sd	s1,8(sp)
    80004efa:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004efc:	00017497          	auipc	s1,0x17
    80004f00:	d2448493          	addi	s1,s1,-732 # 8001bc20 <disk>
    80004f04:	00017517          	auipc	a0,0x17
    80004f08:	e4450513          	addi	a0,a0,-444 # 8001bd48 <disk+0x128>
    80004f0c:	335000ef          	jal	80005a40 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004f10:	100017b7          	lui	a5,0x10001
    80004f14:	53b8                	lw	a4,96(a5)
    80004f16:	8b0d                	andi	a4,a4,3
    80004f18:	100017b7          	lui	a5,0x10001
    80004f1c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004f1e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004f22:	689c                	ld	a5,16(s1)
    80004f24:	0204d703          	lhu	a4,32(s1)
    80004f28:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004f2c:	04f70663          	beq	a4,a5,80004f78 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004f30:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004f34:	6898                	ld	a4,16(s1)
    80004f36:	0204d783          	lhu	a5,32(s1)
    80004f3a:	8b9d                	andi	a5,a5,7
    80004f3c:	078e                	slli	a5,a5,0x3
    80004f3e:	97ba                	add	a5,a5,a4
    80004f40:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004f42:	00278713          	addi	a4,a5,2
    80004f46:	0712                	slli	a4,a4,0x4
    80004f48:	9726                	add	a4,a4,s1
    80004f4a:	01074703          	lbu	a4,16(a4)
    80004f4e:	e321                	bnez	a4,80004f8e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004f50:	0789                	addi	a5,a5,2
    80004f52:	0792                	slli	a5,a5,0x4
    80004f54:	97a6                	add	a5,a5,s1
    80004f56:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004f58:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004f5c:	c20fc0ef          	jal	8000137c <wakeup>

    disk.used_idx += 1;
    80004f60:	0204d783          	lhu	a5,32(s1)
    80004f64:	2785                	addiw	a5,a5,1
    80004f66:	17c2                	slli	a5,a5,0x30
    80004f68:	93c1                	srli	a5,a5,0x30
    80004f6a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004f6e:	6898                	ld	a4,16(s1)
    80004f70:	00275703          	lhu	a4,2(a4)
    80004f74:	faf71ee3          	bne	a4,a5,80004f30 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004f78:	00017517          	auipc	a0,0x17
    80004f7c:	dd050513          	addi	a0,a0,-560 # 8001bd48 <disk+0x128>
    80004f80:	359000ef          	jal	80005ad8 <release>
}
    80004f84:	60e2                	ld	ra,24(sp)
    80004f86:	6442                	ld	s0,16(sp)
    80004f88:	64a2                	ld	s1,8(sp)
    80004f8a:	6105                	addi	sp,sp,32
    80004f8c:	8082                	ret
      panic("virtio_disk_intr status");
    80004f8e:	00003517          	auipc	a0,0x3
    80004f92:	8c250513          	addi	a0,a0,-1854 # 80007850 <etext+0x850>
    80004f96:	77c000ef          	jal	80005712 <panic>

0000000080004f9a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004f9a:	1141                	addi	sp,sp,-16
    80004f9c:	e422                	sd	s0,8(sp)
    80004f9e:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004fa0:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004fa4:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    80004fa8:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004fac:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004fb0:	577d                	li	a4,-1
    80004fb2:	177e                	slli	a4,a4,0x3f
    80004fb4:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004fb6:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004fba:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004fbe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004fc2:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80004fc6:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004fca:	000f4737          	lui	a4,0xf4
    80004fce:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004fd2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004fd4:	14d79073          	csrw	stimecmp,a5
}
    80004fd8:	6422                	ld	s0,8(sp)
    80004fda:	0141                	addi	sp,sp,16
    80004fdc:	8082                	ret

0000000080004fde <start>:
{
    80004fde:	1141                	addi	sp,sp,-16
    80004fe0:	e406                	sd	ra,8(sp)
    80004fe2:	e022                	sd	s0,0(sp)
    80004fe4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004fe6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004fea:	7779                	lui	a4,0xffffe
    80004fec:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffda99f>
    80004ff0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004ff2:	6705                	lui	a4,0x1
    80004ff4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004ff8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004ffa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004ffe:	ffffb797          	auipc	a5,0xffffb
    80005002:	2d078793          	addi	a5,a5,720 # 800002ce <main>
    80005006:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000500a:	4781                	li	a5,0
    8000500c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005010:	67c1                	lui	a5,0x10
    80005012:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005014:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005018:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000501c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005020:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005024:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005028:	57fd                	li	a5,-1
    8000502a:	83a9                	srli	a5,a5,0xa
    8000502c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005030:	47bd                	li	a5,15
    80005032:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005036:	f65ff0ef          	jal	80004f9a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000503a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000503e:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    80005040:	823e                	mv	tp,a5
  asm volatile("mret");
    80005042:	30200073          	mret
}
    80005046:	60a2                	ld	ra,8(sp)
    80005048:	6402                	ld	s0,0(sp)
    8000504a:	0141                	addi	sp,sp,16
    8000504c:	8082                	ret

000000008000504e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000504e:	715d                	addi	sp,sp,-80
    80005050:	e486                	sd	ra,72(sp)
    80005052:	e0a2                	sd	s0,64(sp)
    80005054:	f84a                	sd	s2,48(sp)
    80005056:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005058:	04c05263          	blez	a2,8000509c <consolewrite+0x4e>
    8000505c:	fc26                	sd	s1,56(sp)
    8000505e:	f44e                	sd	s3,40(sp)
    80005060:	f052                	sd	s4,32(sp)
    80005062:	ec56                	sd	s5,24(sp)
    80005064:	8a2a                	mv	s4,a0
    80005066:	84ae                	mv	s1,a1
    80005068:	89b2                	mv	s3,a2
    8000506a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000506c:	5afd                	li	s5,-1
    8000506e:	4685                	li	a3,1
    80005070:	8626                	mv	a2,s1
    80005072:	85d2                	mv	a1,s4
    80005074:	fbf40513          	addi	a0,s0,-65
    80005078:	e5efc0ef          	jal	800016d6 <either_copyin>
    8000507c:	03550263          	beq	a0,s5,800050a0 <consolewrite+0x52>
      break;
    uartputc(c);
    80005080:	fbf44503          	lbu	a0,-65(s0)
    80005084:	035000ef          	jal	800058b8 <uartputc>
  for(i = 0; i < n; i++){
    80005088:	2905                	addiw	s2,s2,1
    8000508a:	0485                	addi	s1,s1,1
    8000508c:	ff2991e3          	bne	s3,s2,8000506e <consolewrite+0x20>
    80005090:	894e                	mv	s2,s3
    80005092:	74e2                	ld	s1,56(sp)
    80005094:	79a2                	ld	s3,40(sp)
    80005096:	7a02                	ld	s4,32(sp)
    80005098:	6ae2                	ld	s5,24(sp)
    8000509a:	a039                	j	800050a8 <consolewrite+0x5a>
    8000509c:	4901                	li	s2,0
    8000509e:	a029                	j	800050a8 <consolewrite+0x5a>
    800050a0:	74e2                	ld	s1,56(sp)
    800050a2:	79a2                	ld	s3,40(sp)
    800050a4:	7a02                	ld	s4,32(sp)
    800050a6:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    800050a8:	854a                	mv	a0,s2
    800050aa:	60a6                	ld	ra,72(sp)
    800050ac:	6406                	ld	s0,64(sp)
    800050ae:	7942                	ld	s2,48(sp)
    800050b0:	6161                	addi	sp,sp,80
    800050b2:	8082                	ret

00000000800050b4 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800050b4:	711d                	addi	sp,sp,-96
    800050b6:	ec86                	sd	ra,88(sp)
    800050b8:	e8a2                	sd	s0,80(sp)
    800050ba:	e4a6                	sd	s1,72(sp)
    800050bc:	e0ca                	sd	s2,64(sp)
    800050be:	fc4e                	sd	s3,56(sp)
    800050c0:	f852                	sd	s4,48(sp)
    800050c2:	f456                	sd	s5,40(sp)
    800050c4:	f05a                	sd	s6,32(sp)
    800050c6:	1080                	addi	s0,sp,96
    800050c8:	8aaa                	mv	s5,a0
    800050ca:	8a2e                	mv	s4,a1
    800050cc:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800050ce:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800050d2:	0001f517          	auipc	a0,0x1f
    800050d6:	c8e50513          	addi	a0,a0,-882 # 80023d60 <cons>
    800050da:	167000ef          	jal	80005a40 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800050de:	0001f497          	auipc	s1,0x1f
    800050e2:	c8248493          	addi	s1,s1,-894 # 80023d60 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800050e6:	0001f917          	auipc	s2,0x1f
    800050ea:	d1290913          	addi	s2,s2,-750 # 80023df8 <cons+0x98>
  while(n > 0){
    800050ee:	0b305d63          	blez	s3,800051a8 <consoleread+0xf4>
    while(cons.r == cons.w){
    800050f2:	0984a783          	lw	a5,152(s1)
    800050f6:	09c4a703          	lw	a4,156(s1)
    800050fa:	0af71263          	bne	a4,a5,8000519e <consoleread+0xea>
      if(killed(myproc())){
    800050fe:	c59fb0ef          	jal	80000d56 <myproc>
    80005102:	c66fc0ef          	jal	80001568 <killed>
    80005106:	e12d                	bnez	a0,80005168 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80005108:	85a6                	mv	a1,s1
    8000510a:	854a                	mv	a0,s2
    8000510c:	a24fc0ef          	jal	80001330 <sleep>
    while(cons.r == cons.w){
    80005110:	0984a783          	lw	a5,152(s1)
    80005114:	09c4a703          	lw	a4,156(s1)
    80005118:	fef703e3          	beq	a4,a5,800050fe <consoleread+0x4a>
    8000511c:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000511e:	0001f717          	auipc	a4,0x1f
    80005122:	c4270713          	addi	a4,a4,-958 # 80023d60 <cons>
    80005126:	0017869b          	addiw	a3,a5,1
    8000512a:	08d72c23          	sw	a3,152(a4)
    8000512e:	07f7f693          	andi	a3,a5,127
    80005132:	9736                	add	a4,a4,a3
    80005134:	01874703          	lbu	a4,24(a4)
    80005138:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    8000513c:	4691                	li	a3,4
    8000513e:	04db8663          	beq	s7,a3,8000518a <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005142:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005146:	4685                	li	a3,1
    80005148:	faf40613          	addi	a2,s0,-81
    8000514c:	85d2                	mv	a1,s4
    8000514e:	8556                	mv	a0,s5
    80005150:	d3cfc0ef          	jal	8000168c <either_copyout>
    80005154:	57fd                	li	a5,-1
    80005156:	04f50863          	beq	a0,a5,800051a6 <consoleread+0xf2>
      break;

    dst++;
    8000515a:	0a05                	addi	s4,s4,1
    --n;
    8000515c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000515e:	47a9                	li	a5,10
    80005160:	04fb8d63          	beq	s7,a5,800051ba <consoleread+0x106>
    80005164:	6be2                	ld	s7,24(sp)
    80005166:	b761                	j	800050ee <consoleread+0x3a>
        release(&cons.lock);
    80005168:	0001f517          	auipc	a0,0x1f
    8000516c:	bf850513          	addi	a0,a0,-1032 # 80023d60 <cons>
    80005170:	169000ef          	jal	80005ad8 <release>
        return -1;
    80005174:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005176:	60e6                	ld	ra,88(sp)
    80005178:	6446                	ld	s0,80(sp)
    8000517a:	64a6                	ld	s1,72(sp)
    8000517c:	6906                	ld	s2,64(sp)
    8000517e:	79e2                	ld	s3,56(sp)
    80005180:	7a42                	ld	s4,48(sp)
    80005182:	7aa2                	ld	s5,40(sp)
    80005184:	7b02                	ld	s6,32(sp)
    80005186:	6125                	addi	sp,sp,96
    80005188:	8082                	ret
      if(n < target){
    8000518a:	0009871b          	sext.w	a4,s3
    8000518e:	01677a63          	bgeu	a4,s6,800051a2 <consoleread+0xee>
        cons.r--;
    80005192:	0001f717          	auipc	a4,0x1f
    80005196:	c6f72323          	sw	a5,-922(a4) # 80023df8 <cons+0x98>
    8000519a:	6be2                	ld	s7,24(sp)
    8000519c:	a031                	j	800051a8 <consoleread+0xf4>
    8000519e:	ec5e                	sd	s7,24(sp)
    800051a0:	bfbd                	j	8000511e <consoleread+0x6a>
    800051a2:	6be2                	ld	s7,24(sp)
    800051a4:	a011                	j	800051a8 <consoleread+0xf4>
    800051a6:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    800051a8:	0001f517          	auipc	a0,0x1f
    800051ac:	bb850513          	addi	a0,a0,-1096 # 80023d60 <cons>
    800051b0:	129000ef          	jal	80005ad8 <release>
  return target - n;
    800051b4:	413b053b          	subw	a0,s6,s3
    800051b8:	bf7d                	j	80005176 <consoleread+0xc2>
    800051ba:	6be2                	ld	s7,24(sp)
    800051bc:	b7f5                	j	800051a8 <consoleread+0xf4>

00000000800051be <consputc>:
{
    800051be:	1141                	addi	sp,sp,-16
    800051c0:	e406                	sd	ra,8(sp)
    800051c2:	e022                	sd	s0,0(sp)
    800051c4:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800051c6:	10000793          	li	a5,256
    800051ca:	00f50863          	beq	a0,a5,800051da <consputc+0x1c>
    uartputc_sync(c);
    800051ce:	604000ef          	jal	800057d2 <uartputc_sync>
}
    800051d2:	60a2                	ld	ra,8(sp)
    800051d4:	6402                	ld	s0,0(sp)
    800051d6:	0141                	addi	sp,sp,16
    800051d8:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800051da:	4521                	li	a0,8
    800051dc:	5f6000ef          	jal	800057d2 <uartputc_sync>
    800051e0:	02000513          	li	a0,32
    800051e4:	5ee000ef          	jal	800057d2 <uartputc_sync>
    800051e8:	4521                	li	a0,8
    800051ea:	5e8000ef          	jal	800057d2 <uartputc_sync>
    800051ee:	b7d5                	j	800051d2 <consputc+0x14>

00000000800051f0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800051f0:	1101                	addi	sp,sp,-32
    800051f2:	ec06                	sd	ra,24(sp)
    800051f4:	e822                	sd	s0,16(sp)
    800051f6:	e426                	sd	s1,8(sp)
    800051f8:	1000                	addi	s0,sp,32
    800051fa:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800051fc:	0001f517          	auipc	a0,0x1f
    80005200:	b6450513          	addi	a0,a0,-1180 # 80023d60 <cons>
    80005204:	03d000ef          	jal	80005a40 <acquire>

  switch(c){
    80005208:	47d5                	li	a5,21
    8000520a:	08f48f63          	beq	s1,a5,800052a8 <consoleintr+0xb8>
    8000520e:	0297c563          	blt	a5,s1,80005238 <consoleintr+0x48>
    80005212:	47a1                	li	a5,8
    80005214:	0ef48463          	beq	s1,a5,800052fc <consoleintr+0x10c>
    80005218:	47c1                	li	a5,16
    8000521a:	10f49563          	bne	s1,a5,80005324 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    8000521e:	d02fc0ef          	jal	80001720 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005222:	0001f517          	auipc	a0,0x1f
    80005226:	b3e50513          	addi	a0,a0,-1218 # 80023d60 <cons>
    8000522a:	0af000ef          	jal	80005ad8 <release>
}
    8000522e:	60e2                	ld	ra,24(sp)
    80005230:	6442                	ld	s0,16(sp)
    80005232:	64a2                	ld	s1,8(sp)
    80005234:	6105                	addi	sp,sp,32
    80005236:	8082                	ret
  switch(c){
    80005238:	07f00793          	li	a5,127
    8000523c:	0cf48063          	beq	s1,a5,800052fc <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005240:	0001f717          	auipc	a4,0x1f
    80005244:	b2070713          	addi	a4,a4,-1248 # 80023d60 <cons>
    80005248:	0a072783          	lw	a5,160(a4)
    8000524c:	09872703          	lw	a4,152(a4)
    80005250:	9f99                	subw	a5,a5,a4
    80005252:	07f00713          	li	a4,127
    80005256:	fcf766e3          	bltu	a4,a5,80005222 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    8000525a:	47b5                	li	a5,13
    8000525c:	0cf48763          	beq	s1,a5,8000532a <consoleintr+0x13a>
      consputc(c);
    80005260:	8526                	mv	a0,s1
    80005262:	f5dff0ef          	jal	800051be <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005266:	0001f797          	auipc	a5,0x1f
    8000526a:	afa78793          	addi	a5,a5,-1286 # 80023d60 <cons>
    8000526e:	0a07a683          	lw	a3,160(a5)
    80005272:	0016871b          	addiw	a4,a3,1
    80005276:	0007061b          	sext.w	a2,a4
    8000527a:	0ae7a023          	sw	a4,160(a5)
    8000527e:	07f6f693          	andi	a3,a3,127
    80005282:	97b6                	add	a5,a5,a3
    80005284:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005288:	47a9                	li	a5,10
    8000528a:	0cf48563          	beq	s1,a5,80005354 <consoleintr+0x164>
    8000528e:	4791                	li	a5,4
    80005290:	0cf48263          	beq	s1,a5,80005354 <consoleintr+0x164>
    80005294:	0001f797          	auipc	a5,0x1f
    80005298:	b647a783          	lw	a5,-1180(a5) # 80023df8 <cons+0x98>
    8000529c:	9f1d                	subw	a4,a4,a5
    8000529e:	08000793          	li	a5,128
    800052a2:	f8f710e3          	bne	a4,a5,80005222 <consoleintr+0x32>
    800052a6:	a07d                	j	80005354 <consoleintr+0x164>
    800052a8:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800052aa:	0001f717          	auipc	a4,0x1f
    800052ae:	ab670713          	addi	a4,a4,-1354 # 80023d60 <cons>
    800052b2:	0a072783          	lw	a5,160(a4)
    800052b6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800052ba:	0001f497          	auipc	s1,0x1f
    800052be:	aa648493          	addi	s1,s1,-1370 # 80023d60 <cons>
    while(cons.e != cons.w &&
    800052c2:	4929                	li	s2,10
    800052c4:	02f70863          	beq	a4,a5,800052f4 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800052c8:	37fd                	addiw	a5,a5,-1
    800052ca:	07f7f713          	andi	a4,a5,127
    800052ce:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800052d0:	01874703          	lbu	a4,24(a4)
    800052d4:	03270263          	beq	a4,s2,800052f8 <consoleintr+0x108>
      cons.e--;
    800052d8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800052dc:	10000513          	li	a0,256
    800052e0:	edfff0ef          	jal	800051be <consputc>
    while(cons.e != cons.w &&
    800052e4:	0a04a783          	lw	a5,160(s1)
    800052e8:	09c4a703          	lw	a4,156(s1)
    800052ec:	fcf71ee3          	bne	a4,a5,800052c8 <consoleintr+0xd8>
    800052f0:	6902                	ld	s2,0(sp)
    800052f2:	bf05                	j	80005222 <consoleintr+0x32>
    800052f4:	6902                	ld	s2,0(sp)
    800052f6:	b735                	j	80005222 <consoleintr+0x32>
    800052f8:	6902                	ld	s2,0(sp)
    800052fa:	b725                	j	80005222 <consoleintr+0x32>
    if(cons.e != cons.w){
    800052fc:	0001f717          	auipc	a4,0x1f
    80005300:	a6470713          	addi	a4,a4,-1436 # 80023d60 <cons>
    80005304:	0a072783          	lw	a5,160(a4)
    80005308:	09c72703          	lw	a4,156(a4)
    8000530c:	f0f70be3          	beq	a4,a5,80005222 <consoleintr+0x32>
      cons.e--;
    80005310:	37fd                	addiw	a5,a5,-1
    80005312:	0001f717          	auipc	a4,0x1f
    80005316:	aef72723          	sw	a5,-1298(a4) # 80023e00 <cons+0xa0>
      consputc(BACKSPACE);
    8000531a:	10000513          	li	a0,256
    8000531e:	ea1ff0ef          	jal	800051be <consputc>
    80005322:	b701                	j	80005222 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005324:	ee048fe3          	beqz	s1,80005222 <consoleintr+0x32>
    80005328:	bf21                	j	80005240 <consoleintr+0x50>
      consputc(c);
    8000532a:	4529                	li	a0,10
    8000532c:	e93ff0ef          	jal	800051be <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005330:	0001f797          	auipc	a5,0x1f
    80005334:	a3078793          	addi	a5,a5,-1488 # 80023d60 <cons>
    80005338:	0a07a703          	lw	a4,160(a5)
    8000533c:	0017069b          	addiw	a3,a4,1
    80005340:	0006861b          	sext.w	a2,a3
    80005344:	0ad7a023          	sw	a3,160(a5)
    80005348:	07f77713          	andi	a4,a4,127
    8000534c:	97ba                	add	a5,a5,a4
    8000534e:	4729                	li	a4,10
    80005350:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005354:	0001f797          	auipc	a5,0x1f
    80005358:	aac7a423          	sw	a2,-1368(a5) # 80023dfc <cons+0x9c>
        wakeup(&cons.r);
    8000535c:	0001f517          	auipc	a0,0x1f
    80005360:	a9c50513          	addi	a0,a0,-1380 # 80023df8 <cons+0x98>
    80005364:	818fc0ef          	jal	8000137c <wakeup>
    80005368:	bd6d                	j	80005222 <consoleintr+0x32>

000000008000536a <consoleinit>:

void
consoleinit(void)
{
    8000536a:	1141                	addi	sp,sp,-16
    8000536c:	e406                	sd	ra,8(sp)
    8000536e:	e022                	sd	s0,0(sp)
    80005370:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005372:	00002597          	auipc	a1,0x2
    80005376:	4f658593          	addi	a1,a1,1270 # 80007868 <etext+0x868>
    8000537a:	0001f517          	auipc	a0,0x1f
    8000537e:	9e650513          	addi	a0,a0,-1562 # 80023d60 <cons>
    80005382:	63e000ef          	jal	800059c0 <initlock>

  uartinit();
    80005386:	3f4000ef          	jal	8000577a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000538a:	00016797          	auipc	a5,0x16
    8000538e:	83e78793          	addi	a5,a5,-1986 # 8001abc8 <devsw>
    80005392:	00000717          	auipc	a4,0x0
    80005396:	d2270713          	addi	a4,a4,-734 # 800050b4 <consoleread>
    8000539a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000539c:	00000717          	auipc	a4,0x0
    800053a0:	cb270713          	addi	a4,a4,-846 # 8000504e <consolewrite>
    800053a4:	ef98                	sd	a4,24(a5)
}
    800053a6:	60a2                	ld	ra,8(sp)
    800053a8:	6402                	ld	s0,0(sp)
    800053aa:	0141                	addi	sp,sp,16
    800053ac:	8082                	ret

00000000800053ae <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800053ae:	7179                	addi	sp,sp,-48
    800053b0:	f406                	sd	ra,40(sp)
    800053b2:	f022                	sd	s0,32(sp)
    800053b4:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800053b6:	c219                	beqz	a2,800053bc <printint+0xe>
    800053b8:	08054063          	bltz	a0,80005438 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    800053bc:	4881                	li	a7,0
    800053be:	fd040693          	addi	a3,s0,-48

  i = 0;
    800053c2:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800053c4:	00003617          	auipc	a2,0x3
    800053c8:	89460613          	addi	a2,a2,-1900 # 80007c58 <digits>
    800053cc:	883e                	mv	a6,a5
    800053ce:	2785                	addiw	a5,a5,1
    800053d0:	02b57733          	remu	a4,a0,a1
    800053d4:	9732                	add	a4,a4,a2
    800053d6:	00074703          	lbu	a4,0(a4)
    800053da:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800053de:	872a                	mv	a4,a0
    800053e0:	02b55533          	divu	a0,a0,a1
    800053e4:	0685                	addi	a3,a3,1
    800053e6:	feb773e3          	bgeu	a4,a1,800053cc <printint+0x1e>

  if(sign)
    800053ea:	00088a63          	beqz	a7,800053fe <printint+0x50>
    buf[i++] = '-';
    800053ee:	1781                	addi	a5,a5,-32
    800053f0:	97a2                	add	a5,a5,s0
    800053f2:	02d00713          	li	a4,45
    800053f6:	fee78823          	sb	a4,-16(a5)
    800053fa:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800053fe:	02f05963          	blez	a5,80005430 <printint+0x82>
    80005402:	ec26                	sd	s1,24(sp)
    80005404:	e84a                	sd	s2,16(sp)
    80005406:	fd040713          	addi	a4,s0,-48
    8000540a:	00f704b3          	add	s1,a4,a5
    8000540e:	fff70913          	addi	s2,a4,-1
    80005412:	993e                	add	s2,s2,a5
    80005414:	37fd                	addiw	a5,a5,-1
    80005416:	1782                	slli	a5,a5,0x20
    80005418:	9381                	srli	a5,a5,0x20
    8000541a:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000541e:	fff4c503          	lbu	a0,-1(s1)
    80005422:	d9dff0ef          	jal	800051be <consputc>
  while(--i >= 0)
    80005426:	14fd                	addi	s1,s1,-1
    80005428:	ff249be3          	bne	s1,s2,8000541e <printint+0x70>
    8000542c:	64e2                	ld	s1,24(sp)
    8000542e:	6942                	ld	s2,16(sp)
}
    80005430:	70a2                	ld	ra,40(sp)
    80005432:	7402                	ld	s0,32(sp)
    80005434:	6145                	addi	sp,sp,48
    80005436:	8082                	ret
    x = -xx;
    80005438:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000543c:	4885                	li	a7,1
    x = -xx;
    8000543e:	b741                	j	800053be <printint+0x10>

0000000080005440 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005440:	7155                	addi	sp,sp,-208
    80005442:	e506                	sd	ra,136(sp)
    80005444:	e122                	sd	s0,128(sp)
    80005446:	f0d2                	sd	s4,96(sp)
    80005448:	0900                	addi	s0,sp,144
    8000544a:	8a2a                	mv	s4,a0
    8000544c:	e40c                	sd	a1,8(s0)
    8000544e:	e810                	sd	a2,16(s0)
    80005450:	ec14                	sd	a3,24(s0)
    80005452:	f018                	sd	a4,32(s0)
    80005454:	f41c                	sd	a5,40(s0)
    80005456:	03043823          	sd	a6,48(s0)
    8000545a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    8000545e:	0001f797          	auipc	a5,0x1f
    80005462:	9c27a783          	lw	a5,-1598(a5) # 80023e20 <pr+0x18>
    80005466:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8000546a:	e3a1                	bnez	a5,800054aa <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000546c:	00840793          	addi	a5,s0,8
    80005470:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005474:	00054503          	lbu	a0,0(a0)
    80005478:	26050763          	beqz	a0,800056e6 <printf+0x2a6>
    8000547c:	fca6                	sd	s1,120(sp)
    8000547e:	f8ca                	sd	s2,112(sp)
    80005480:	f4ce                	sd	s3,104(sp)
    80005482:	ecd6                	sd	s5,88(sp)
    80005484:	e8da                	sd	s6,80(sp)
    80005486:	e0e2                	sd	s8,64(sp)
    80005488:	fc66                	sd	s9,56(sp)
    8000548a:	f86a                	sd	s10,48(sp)
    8000548c:	f46e                	sd	s11,40(sp)
    8000548e:	4981                	li	s3,0
    if(cx != '%'){
    80005490:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005494:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005498:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000549c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800054a0:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800054a4:	07000d93          	li	s11,112
    800054a8:	a815                	j	800054dc <printf+0x9c>
    acquire(&pr.lock);
    800054aa:	0001f517          	auipc	a0,0x1f
    800054ae:	95e50513          	addi	a0,a0,-1698 # 80023e08 <pr>
    800054b2:	58e000ef          	jal	80005a40 <acquire>
  va_start(ap, fmt);
    800054b6:	00840793          	addi	a5,s0,8
    800054ba:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800054be:	000a4503          	lbu	a0,0(s4)
    800054c2:	fd4d                	bnez	a0,8000547c <printf+0x3c>
    800054c4:	a481                	j	80005704 <printf+0x2c4>
      consputc(cx);
    800054c6:	cf9ff0ef          	jal	800051be <consputc>
      continue;
    800054ca:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800054cc:	0014899b          	addiw	s3,s1,1
    800054d0:	013a07b3          	add	a5,s4,s3
    800054d4:	0007c503          	lbu	a0,0(a5)
    800054d8:	1e050b63          	beqz	a0,800056ce <printf+0x28e>
    if(cx != '%'){
    800054dc:	ff5515e3          	bne	a0,s5,800054c6 <printf+0x86>
    i++;
    800054e0:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800054e4:	009a07b3          	add	a5,s4,s1
    800054e8:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800054ec:	1e090163          	beqz	s2,800056ce <printf+0x28e>
    800054f0:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800054f4:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800054f6:	c789                	beqz	a5,80005500 <printf+0xc0>
    800054f8:	009a0733          	add	a4,s4,s1
    800054fc:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005500:	03690763          	beq	s2,s6,8000552e <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80005504:	05890163          	beq	s2,s8,80005546 <printf+0x106>
    } else if(c0 == 'u'){
    80005508:	0d990b63          	beq	s2,s9,800055de <printf+0x19e>
    } else if(c0 == 'x'){
    8000550c:	13a90163          	beq	s2,s10,8000562e <printf+0x1ee>
    } else if(c0 == 'p'){
    80005510:	13b90b63          	beq	s2,s11,80005646 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005514:	07300793          	li	a5,115
    80005518:	16f90a63          	beq	s2,a5,8000568c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000551c:	1b590463          	beq	s2,s5,800056c4 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005520:	8556                	mv	a0,s5
    80005522:	c9dff0ef          	jal	800051be <consputc>
      consputc(c0);
    80005526:	854a                	mv	a0,s2
    80005528:	c97ff0ef          	jal	800051be <consputc>
    8000552c:	b745                	j	800054cc <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    8000552e:	f8843783          	ld	a5,-120(s0)
    80005532:	00878713          	addi	a4,a5,8
    80005536:	f8e43423          	sd	a4,-120(s0)
    8000553a:	4605                	li	a2,1
    8000553c:	45a9                	li	a1,10
    8000553e:	4388                	lw	a0,0(a5)
    80005540:	e6fff0ef          	jal	800053ae <printint>
    80005544:	b761                	j	800054cc <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    80005546:	03678663          	beq	a5,s6,80005572 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000554a:	05878263          	beq	a5,s8,8000558e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    8000554e:	0b978463          	beq	a5,s9,800055f6 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    80005552:	fda797e3          	bne	a5,s10,80005520 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005556:	f8843783          	ld	a5,-120(s0)
    8000555a:	00878713          	addi	a4,a5,8
    8000555e:	f8e43423          	sd	a4,-120(s0)
    80005562:	4601                	li	a2,0
    80005564:	45c1                	li	a1,16
    80005566:	6388                	ld	a0,0(a5)
    80005568:	e47ff0ef          	jal	800053ae <printint>
      i += 1;
    8000556c:	0029849b          	addiw	s1,s3,2
    80005570:	bfb1                	j	800054cc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005572:	f8843783          	ld	a5,-120(s0)
    80005576:	00878713          	addi	a4,a5,8
    8000557a:	f8e43423          	sd	a4,-120(s0)
    8000557e:	4605                	li	a2,1
    80005580:	45a9                	li	a1,10
    80005582:	6388                	ld	a0,0(a5)
    80005584:	e2bff0ef          	jal	800053ae <printint>
      i += 1;
    80005588:	0029849b          	addiw	s1,s3,2
    8000558c:	b781                	j	800054cc <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000558e:	06400793          	li	a5,100
    80005592:	02f68863          	beq	a3,a5,800055c2 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005596:	07500793          	li	a5,117
    8000559a:	06f68c63          	beq	a3,a5,80005612 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000559e:	07800793          	li	a5,120
    800055a2:	f6f69fe3          	bne	a3,a5,80005520 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800055a6:	f8843783          	ld	a5,-120(s0)
    800055aa:	00878713          	addi	a4,a5,8
    800055ae:	f8e43423          	sd	a4,-120(s0)
    800055b2:	4601                	li	a2,0
    800055b4:	45c1                	li	a1,16
    800055b6:	6388                	ld	a0,0(a5)
    800055b8:	df7ff0ef          	jal	800053ae <printint>
      i += 2;
    800055bc:	0039849b          	addiw	s1,s3,3
    800055c0:	b731                	j	800054cc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800055c2:	f8843783          	ld	a5,-120(s0)
    800055c6:	00878713          	addi	a4,a5,8
    800055ca:	f8e43423          	sd	a4,-120(s0)
    800055ce:	4605                	li	a2,1
    800055d0:	45a9                	li	a1,10
    800055d2:	6388                	ld	a0,0(a5)
    800055d4:	ddbff0ef          	jal	800053ae <printint>
      i += 2;
    800055d8:	0039849b          	addiw	s1,s3,3
    800055dc:	bdc5                	j	800054cc <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800055de:	f8843783          	ld	a5,-120(s0)
    800055e2:	00878713          	addi	a4,a5,8
    800055e6:	f8e43423          	sd	a4,-120(s0)
    800055ea:	4601                	li	a2,0
    800055ec:	45a9                	li	a1,10
    800055ee:	4388                	lw	a0,0(a5)
    800055f0:	dbfff0ef          	jal	800053ae <printint>
    800055f4:	bde1                	j	800054cc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800055f6:	f8843783          	ld	a5,-120(s0)
    800055fa:	00878713          	addi	a4,a5,8
    800055fe:	f8e43423          	sd	a4,-120(s0)
    80005602:	4601                	li	a2,0
    80005604:	45a9                	li	a1,10
    80005606:	6388                	ld	a0,0(a5)
    80005608:	da7ff0ef          	jal	800053ae <printint>
      i += 1;
    8000560c:	0029849b          	addiw	s1,s3,2
    80005610:	bd75                	j	800054cc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005612:	f8843783          	ld	a5,-120(s0)
    80005616:	00878713          	addi	a4,a5,8
    8000561a:	f8e43423          	sd	a4,-120(s0)
    8000561e:	4601                	li	a2,0
    80005620:	45a9                	li	a1,10
    80005622:	6388                	ld	a0,0(a5)
    80005624:	d8bff0ef          	jal	800053ae <printint>
      i += 2;
    80005628:	0039849b          	addiw	s1,s3,3
    8000562c:	b545                	j	800054cc <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    8000562e:	f8843783          	ld	a5,-120(s0)
    80005632:	00878713          	addi	a4,a5,8
    80005636:	f8e43423          	sd	a4,-120(s0)
    8000563a:	4601                	li	a2,0
    8000563c:	45c1                	li	a1,16
    8000563e:	4388                	lw	a0,0(a5)
    80005640:	d6fff0ef          	jal	800053ae <printint>
    80005644:	b561                	j	800054cc <printf+0x8c>
    80005646:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    80005648:	f8843783          	ld	a5,-120(s0)
    8000564c:	00878713          	addi	a4,a5,8
    80005650:	f8e43423          	sd	a4,-120(s0)
    80005654:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005658:	03000513          	li	a0,48
    8000565c:	b63ff0ef          	jal	800051be <consputc>
  consputc('x');
    80005660:	07800513          	li	a0,120
    80005664:	b5bff0ef          	jal	800051be <consputc>
    80005668:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000566a:	00002b97          	auipc	s7,0x2
    8000566e:	5eeb8b93          	addi	s7,s7,1518 # 80007c58 <digits>
    80005672:	03c9d793          	srli	a5,s3,0x3c
    80005676:	97de                	add	a5,a5,s7
    80005678:	0007c503          	lbu	a0,0(a5)
    8000567c:	b43ff0ef          	jal	800051be <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005680:	0992                	slli	s3,s3,0x4
    80005682:	397d                	addiw	s2,s2,-1
    80005684:	fe0917e3          	bnez	s2,80005672 <printf+0x232>
    80005688:	6ba6                	ld	s7,72(sp)
    8000568a:	b589                	j	800054cc <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000568c:	f8843783          	ld	a5,-120(s0)
    80005690:	00878713          	addi	a4,a5,8
    80005694:	f8e43423          	sd	a4,-120(s0)
    80005698:	0007b903          	ld	s2,0(a5)
    8000569c:	00090d63          	beqz	s2,800056b6 <printf+0x276>
      for(; *s; s++)
    800056a0:	00094503          	lbu	a0,0(s2)
    800056a4:	e20504e3          	beqz	a0,800054cc <printf+0x8c>
        consputc(*s);
    800056a8:	b17ff0ef          	jal	800051be <consputc>
      for(; *s; s++)
    800056ac:	0905                	addi	s2,s2,1
    800056ae:	00094503          	lbu	a0,0(s2)
    800056b2:	f97d                	bnez	a0,800056a8 <printf+0x268>
    800056b4:	bd21                	j	800054cc <printf+0x8c>
        s = "(null)";
    800056b6:	00002917          	auipc	s2,0x2
    800056ba:	1ba90913          	addi	s2,s2,442 # 80007870 <etext+0x870>
      for(; *s; s++)
    800056be:	02800513          	li	a0,40
    800056c2:	b7dd                	j	800056a8 <printf+0x268>
      consputc('%');
    800056c4:	02500513          	li	a0,37
    800056c8:	af7ff0ef          	jal	800051be <consputc>
    800056cc:	b501                	j	800054cc <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800056ce:	f7843783          	ld	a5,-136(s0)
    800056d2:	e385                	bnez	a5,800056f2 <printf+0x2b2>
    800056d4:	74e6                	ld	s1,120(sp)
    800056d6:	7946                	ld	s2,112(sp)
    800056d8:	79a6                	ld	s3,104(sp)
    800056da:	6ae6                	ld	s5,88(sp)
    800056dc:	6b46                	ld	s6,80(sp)
    800056de:	6c06                	ld	s8,64(sp)
    800056e0:	7ce2                	ld	s9,56(sp)
    800056e2:	7d42                	ld	s10,48(sp)
    800056e4:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800056e6:	4501                	li	a0,0
    800056e8:	60aa                	ld	ra,136(sp)
    800056ea:	640a                	ld	s0,128(sp)
    800056ec:	7a06                	ld	s4,96(sp)
    800056ee:	6169                	addi	sp,sp,208
    800056f0:	8082                	ret
    800056f2:	74e6                	ld	s1,120(sp)
    800056f4:	7946                	ld	s2,112(sp)
    800056f6:	79a6                	ld	s3,104(sp)
    800056f8:	6ae6                	ld	s5,88(sp)
    800056fa:	6b46                	ld	s6,80(sp)
    800056fc:	6c06                	ld	s8,64(sp)
    800056fe:	7ce2                	ld	s9,56(sp)
    80005700:	7d42                	ld	s10,48(sp)
    80005702:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005704:	0001e517          	auipc	a0,0x1e
    80005708:	70450513          	addi	a0,a0,1796 # 80023e08 <pr>
    8000570c:	3cc000ef          	jal	80005ad8 <release>
    80005710:	bfd9                	j	800056e6 <printf+0x2a6>

0000000080005712 <panic>:

void
panic(char *s)
{
    80005712:	1101                	addi	sp,sp,-32
    80005714:	ec06                	sd	ra,24(sp)
    80005716:	e822                	sd	s0,16(sp)
    80005718:	e426                	sd	s1,8(sp)
    8000571a:	1000                	addi	s0,sp,32
    8000571c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000571e:	0001e797          	auipc	a5,0x1e
    80005722:	7007a123          	sw	zero,1794(a5) # 80023e20 <pr+0x18>
  printf("panic: ");
    80005726:	00002517          	auipc	a0,0x2
    8000572a:	15250513          	addi	a0,a0,338 # 80007878 <etext+0x878>
    8000572e:	d13ff0ef          	jal	80005440 <printf>
  printf("%s\n", s);
    80005732:	85a6                	mv	a1,s1
    80005734:	00002517          	auipc	a0,0x2
    80005738:	14c50513          	addi	a0,a0,332 # 80007880 <etext+0x880>
    8000573c:	d05ff0ef          	jal	80005440 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005740:	4785                	li	a5,1
    80005742:	00005717          	auipc	a4,0x5
    80005746:	fcf72d23          	sw	a5,-38(a4) # 8000a71c <panicked>
  for(;;)
    8000574a:	a001                	j	8000574a <panic+0x38>

000000008000574c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000574c:	1101                	addi	sp,sp,-32
    8000574e:	ec06                	sd	ra,24(sp)
    80005750:	e822                	sd	s0,16(sp)
    80005752:	e426                	sd	s1,8(sp)
    80005754:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005756:	0001e497          	auipc	s1,0x1e
    8000575a:	6b248493          	addi	s1,s1,1714 # 80023e08 <pr>
    8000575e:	00002597          	auipc	a1,0x2
    80005762:	12a58593          	addi	a1,a1,298 # 80007888 <etext+0x888>
    80005766:	8526                	mv	a0,s1
    80005768:	258000ef          	jal	800059c0 <initlock>
  pr.locking = 1;
    8000576c:	4785                	li	a5,1
    8000576e:	cc9c                	sw	a5,24(s1)
}
    80005770:	60e2                	ld	ra,24(sp)
    80005772:	6442                	ld	s0,16(sp)
    80005774:	64a2                	ld	s1,8(sp)
    80005776:	6105                	addi	sp,sp,32
    80005778:	8082                	ret

000000008000577a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000577a:	1141                	addi	sp,sp,-16
    8000577c:	e406                	sd	ra,8(sp)
    8000577e:	e022                	sd	s0,0(sp)
    80005780:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005782:	100007b7          	lui	a5,0x10000
    80005786:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000578a:	10000737          	lui	a4,0x10000
    8000578e:	f8000693          	li	a3,-128
    80005792:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005796:	468d                	li	a3,3
    80005798:	10000637          	lui	a2,0x10000
    8000579c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800057a0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800057a4:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800057a8:	10000737          	lui	a4,0x10000
    800057ac:	461d                	li	a2,7
    800057ae:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800057b2:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800057b6:	00002597          	auipc	a1,0x2
    800057ba:	0da58593          	addi	a1,a1,218 # 80007890 <etext+0x890>
    800057be:	0001e517          	auipc	a0,0x1e
    800057c2:	66a50513          	addi	a0,a0,1642 # 80023e28 <uart_tx_lock>
    800057c6:	1fa000ef          	jal	800059c0 <initlock>
}
    800057ca:	60a2                	ld	ra,8(sp)
    800057cc:	6402                	ld	s0,0(sp)
    800057ce:	0141                	addi	sp,sp,16
    800057d0:	8082                	ret

00000000800057d2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800057d2:	1101                	addi	sp,sp,-32
    800057d4:	ec06                	sd	ra,24(sp)
    800057d6:	e822                	sd	s0,16(sp)
    800057d8:	e426                	sd	s1,8(sp)
    800057da:	1000                	addi	s0,sp,32
    800057dc:	84aa                	mv	s1,a0
  push_off();
    800057de:	222000ef          	jal	80005a00 <push_off>

  if(panicked){
    800057e2:	00005797          	auipc	a5,0x5
    800057e6:	f3a7a783          	lw	a5,-198(a5) # 8000a71c <panicked>
    800057ea:	e795                	bnez	a5,80005816 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800057ec:	10000737          	lui	a4,0x10000
    800057f0:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800057f2:	00074783          	lbu	a5,0(a4)
    800057f6:	0207f793          	andi	a5,a5,32
    800057fa:	dfe5                	beqz	a5,800057f2 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800057fc:	0ff4f513          	zext.b	a0,s1
    80005800:	100007b7          	lui	a5,0x10000
    80005804:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005808:	27c000ef          	jal	80005a84 <pop_off>
}
    8000580c:	60e2                	ld	ra,24(sp)
    8000580e:	6442                	ld	s0,16(sp)
    80005810:	64a2                	ld	s1,8(sp)
    80005812:	6105                	addi	sp,sp,32
    80005814:	8082                	ret
    for(;;)
    80005816:	a001                	j	80005816 <uartputc_sync+0x44>

0000000080005818 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005818:	00005797          	auipc	a5,0x5
    8000581c:	f087b783          	ld	a5,-248(a5) # 8000a720 <uart_tx_r>
    80005820:	00005717          	auipc	a4,0x5
    80005824:	f0873703          	ld	a4,-248(a4) # 8000a728 <uart_tx_w>
    80005828:	08f70263          	beq	a4,a5,800058ac <uartstart+0x94>
{
    8000582c:	7139                	addi	sp,sp,-64
    8000582e:	fc06                	sd	ra,56(sp)
    80005830:	f822                	sd	s0,48(sp)
    80005832:	f426                	sd	s1,40(sp)
    80005834:	f04a                	sd	s2,32(sp)
    80005836:	ec4e                	sd	s3,24(sp)
    80005838:	e852                	sd	s4,16(sp)
    8000583a:	e456                	sd	s5,8(sp)
    8000583c:	e05a                	sd	s6,0(sp)
    8000583e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005840:	10000937          	lui	s2,0x10000
    80005844:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005846:	0001ea97          	auipc	s5,0x1e
    8000584a:	5e2a8a93          	addi	s5,s5,1506 # 80023e28 <uart_tx_lock>
    uart_tx_r += 1;
    8000584e:	00005497          	auipc	s1,0x5
    80005852:	ed248493          	addi	s1,s1,-302 # 8000a720 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005856:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000585a:	00005997          	auipc	s3,0x5
    8000585e:	ece98993          	addi	s3,s3,-306 # 8000a728 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005862:	00094703          	lbu	a4,0(s2)
    80005866:	02077713          	andi	a4,a4,32
    8000586a:	c71d                	beqz	a4,80005898 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000586c:	01f7f713          	andi	a4,a5,31
    80005870:	9756                	add	a4,a4,s5
    80005872:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005876:	0785                	addi	a5,a5,1
    80005878:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000587a:	8526                	mv	a0,s1
    8000587c:	b01fb0ef          	jal	8000137c <wakeup>
    WriteReg(THR, c);
    80005880:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005884:	609c                	ld	a5,0(s1)
    80005886:	0009b703          	ld	a4,0(s3)
    8000588a:	fcf71ce3          	bne	a4,a5,80005862 <uartstart+0x4a>
      ReadReg(ISR);
    8000588e:	100007b7          	lui	a5,0x10000
    80005892:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005894:	0007c783          	lbu	a5,0(a5)
  }
}
    80005898:	70e2                	ld	ra,56(sp)
    8000589a:	7442                	ld	s0,48(sp)
    8000589c:	74a2                	ld	s1,40(sp)
    8000589e:	7902                	ld	s2,32(sp)
    800058a0:	69e2                	ld	s3,24(sp)
    800058a2:	6a42                	ld	s4,16(sp)
    800058a4:	6aa2                	ld	s5,8(sp)
    800058a6:	6b02                	ld	s6,0(sp)
    800058a8:	6121                	addi	sp,sp,64
    800058aa:	8082                	ret
      ReadReg(ISR);
    800058ac:	100007b7          	lui	a5,0x10000
    800058b0:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800058b2:	0007c783          	lbu	a5,0(a5)
      return;
    800058b6:	8082                	ret

00000000800058b8 <uartputc>:
{
    800058b8:	7179                	addi	sp,sp,-48
    800058ba:	f406                	sd	ra,40(sp)
    800058bc:	f022                	sd	s0,32(sp)
    800058be:	ec26                	sd	s1,24(sp)
    800058c0:	e84a                	sd	s2,16(sp)
    800058c2:	e44e                	sd	s3,8(sp)
    800058c4:	e052                	sd	s4,0(sp)
    800058c6:	1800                	addi	s0,sp,48
    800058c8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800058ca:	0001e517          	auipc	a0,0x1e
    800058ce:	55e50513          	addi	a0,a0,1374 # 80023e28 <uart_tx_lock>
    800058d2:	16e000ef          	jal	80005a40 <acquire>
  if(panicked){
    800058d6:	00005797          	auipc	a5,0x5
    800058da:	e467a783          	lw	a5,-442(a5) # 8000a71c <panicked>
    800058de:	efbd                	bnez	a5,8000595c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800058e0:	00005717          	auipc	a4,0x5
    800058e4:	e4873703          	ld	a4,-440(a4) # 8000a728 <uart_tx_w>
    800058e8:	00005797          	auipc	a5,0x5
    800058ec:	e387b783          	ld	a5,-456(a5) # 8000a720 <uart_tx_r>
    800058f0:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800058f4:	0001e997          	auipc	s3,0x1e
    800058f8:	53498993          	addi	s3,s3,1332 # 80023e28 <uart_tx_lock>
    800058fc:	00005497          	auipc	s1,0x5
    80005900:	e2448493          	addi	s1,s1,-476 # 8000a720 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005904:	00005917          	auipc	s2,0x5
    80005908:	e2490913          	addi	s2,s2,-476 # 8000a728 <uart_tx_w>
    8000590c:	00e79d63          	bne	a5,a4,80005926 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005910:	85ce                	mv	a1,s3
    80005912:	8526                	mv	a0,s1
    80005914:	a1dfb0ef          	jal	80001330 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005918:	00093703          	ld	a4,0(s2)
    8000591c:	609c                	ld	a5,0(s1)
    8000591e:	02078793          	addi	a5,a5,32
    80005922:	fee787e3          	beq	a5,a4,80005910 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005926:	0001e497          	auipc	s1,0x1e
    8000592a:	50248493          	addi	s1,s1,1282 # 80023e28 <uart_tx_lock>
    8000592e:	01f77793          	andi	a5,a4,31
    80005932:	97a6                	add	a5,a5,s1
    80005934:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005938:	0705                	addi	a4,a4,1
    8000593a:	00005797          	auipc	a5,0x5
    8000593e:	dee7b723          	sd	a4,-530(a5) # 8000a728 <uart_tx_w>
  uartstart();
    80005942:	ed7ff0ef          	jal	80005818 <uartstart>
  release(&uart_tx_lock);
    80005946:	8526                	mv	a0,s1
    80005948:	190000ef          	jal	80005ad8 <release>
}
    8000594c:	70a2                	ld	ra,40(sp)
    8000594e:	7402                	ld	s0,32(sp)
    80005950:	64e2                	ld	s1,24(sp)
    80005952:	6942                	ld	s2,16(sp)
    80005954:	69a2                	ld	s3,8(sp)
    80005956:	6a02                	ld	s4,0(sp)
    80005958:	6145                	addi	sp,sp,48
    8000595a:	8082                	ret
    for(;;)
    8000595c:	a001                	j	8000595c <uartputc+0xa4>

000000008000595e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000595e:	1141                	addi	sp,sp,-16
    80005960:	e422                	sd	s0,8(sp)
    80005962:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005964:	100007b7          	lui	a5,0x10000
    80005968:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000596a:	0007c783          	lbu	a5,0(a5)
    8000596e:	8b85                	andi	a5,a5,1
    80005970:	cb81                	beqz	a5,80005980 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005972:	100007b7          	lui	a5,0x10000
    80005976:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000597a:	6422                	ld	s0,8(sp)
    8000597c:	0141                	addi	sp,sp,16
    8000597e:	8082                	ret
    return -1;
    80005980:	557d                	li	a0,-1
    80005982:	bfe5                	j	8000597a <uartgetc+0x1c>

0000000080005984 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005984:	1101                	addi	sp,sp,-32
    80005986:	ec06                	sd	ra,24(sp)
    80005988:	e822                	sd	s0,16(sp)
    8000598a:	e426                	sd	s1,8(sp)
    8000598c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000598e:	54fd                	li	s1,-1
    80005990:	a019                	j	80005996 <uartintr+0x12>
      break;
    consoleintr(c);
    80005992:	85fff0ef          	jal	800051f0 <consoleintr>
    int c = uartgetc();
    80005996:	fc9ff0ef          	jal	8000595e <uartgetc>
    if(c == -1)
    8000599a:	fe951ce3          	bne	a0,s1,80005992 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000599e:	0001e497          	auipc	s1,0x1e
    800059a2:	48a48493          	addi	s1,s1,1162 # 80023e28 <uart_tx_lock>
    800059a6:	8526                	mv	a0,s1
    800059a8:	098000ef          	jal	80005a40 <acquire>
  uartstart();
    800059ac:	e6dff0ef          	jal	80005818 <uartstart>
  release(&uart_tx_lock);
    800059b0:	8526                	mv	a0,s1
    800059b2:	126000ef          	jal	80005ad8 <release>
}
    800059b6:	60e2                	ld	ra,24(sp)
    800059b8:	6442                	ld	s0,16(sp)
    800059ba:	64a2                	ld	s1,8(sp)
    800059bc:	6105                	addi	sp,sp,32
    800059be:	8082                	ret

00000000800059c0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800059c0:	1141                	addi	sp,sp,-16
    800059c2:	e422                	sd	s0,8(sp)
    800059c4:	0800                	addi	s0,sp,16
  lk->name = name;
    800059c6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800059c8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800059cc:	00053823          	sd	zero,16(a0)
}
    800059d0:	6422                	ld	s0,8(sp)
    800059d2:	0141                	addi	sp,sp,16
    800059d4:	8082                	ret

00000000800059d6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800059d6:	411c                	lw	a5,0(a0)
    800059d8:	e399                	bnez	a5,800059de <holding+0x8>
    800059da:	4501                	li	a0,0
  return r;
}
    800059dc:	8082                	ret
{
    800059de:	1101                	addi	sp,sp,-32
    800059e0:	ec06                	sd	ra,24(sp)
    800059e2:	e822                	sd	s0,16(sp)
    800059e4:	e426                	sd	s1,8(sp)
    800059e6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800059e8:	6904                	ld	s1,16(a0)
    800059ea:	b50fb0ef          	jal	80000d3a <mycpu>
    800059ee:	40a48533          	sub	a0,s1,a0
    800059f2:	00153513          	seqz	a0,a0
}
    800059f6:	60e2                	ld	ra,24(sp)
    800059f8:	6442                	ld	s0,16(sp)
    800059fa:	64a2                	ld	s1,8(sp)
    800059fc:	6105                	addi	sp,sp,32
    800059fe:	8082                	ret

0000000080005a00 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005a00:	1101                	addi	sp,sp,-32
    80005a02:	ec06                	sd	ra,24(sp)
    80005a04:	e822                	sd	s0,16(sp)
    80005a06:	e426                	sd	s1,8(sp)
    80005a08:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005a0a:	100024f3          	csrr	s1,sstatus
    80005a0e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005a12:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005a14:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005a18:	b22fb0ef          	jal	80000d3a <mycpu>
    80005a1c:	5d3c                	lw	a5,120(a0)
    80005a1e:	cb99                	beqz	a5,80005a34 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005a20:	b1afb0ef          	jal	80000d3a <mycpu>
    80005a24:	5d3c                	lw	a5,120(a0)
    80005a26:	2785                	addiw	a5,a5,1
    80005a28:	dd3c                	sw	a5,120(a0)
}
    80005a2a:	60e2                	ld	ra,24(sp)
    80005a2c:	6442                	ld	s0,16(sp)
    80005a2e:	64a2                	ld	s1,8(sp)
    80005a30:	6105                	addi	sp,sp,32
    80005a32:	8082                	ret
    mycpu()->intena = old;
    80005a34:	b06fb0ef          	jal	80000d3a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005a38:	8085                	srli	s1,s1,0x1
    80005a3a:	8885                	andi	s1,s1,1
    80005a3c:	dd64                	sw	s1,124(a0)
    80005a3e:	b7cd                	j	80005a20 <push_off+0x20>

0000000080005a40 <acquire>:
{
    80005a40:	1101                	addi	sp,sp,-32
    80005a42:	ec06                	sd	ra,24(sp)
    80005a44:	e822                	sd	s0,16(sp)
    80005a46:	e426                	sd	s1,8(sp)
    80005a48:	1000                	addi	s0,sp,32
    80005a4a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005a4c:	fb5ff0ef          	jal	80005a00 <push_off>
  if(holding(lk))
    80005a50:	8526                	mv	a0,s1
    80005a52:	f85ff0ef          	jal	800059d6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005a56:	4705                	li	a4,1
  if(holding(lk))
    80005a58:	e105                	bnez	a0,80005a78 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005a5a:	87ba                	mv	a5,a4
    80005a5c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005a60:	2781                	sext.w	a5,a5
    80005a62:	ffe5                	bnez	a5,80005a5a <acquire+0x1a>
  __sync_synchronize();
    80005a64:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005a68:	ad2fb0ef          	jal	80000d3a <mycpu>
    80005a6c:	e888                	sd	a0,16(s1)
}
    80005a6e:	60e2                	ld	ra,24(sp)
    80005a70:	6442                	ld	s0,16(sp)
    80005a72:	64a2                	ld	s1,8(sp)
    80005a74:	6105                	addi	sp,sp,32
    80005a76:	8082                	ret
    panic("acquire");
    80005a78:	00002517          	auipc	a0,0x2
    80005a7c:	e2050513          	addi	a0,a0,-480 # 80007898 <etext+0x898>
    80005a80:	c93ff0ef          	jal	80005712 <panic>

0000000080005a84 <pop_off>:

void
pop_off(void)
{
    80005a84:	1141                	addi	sp,sp,-16
    80005a86:	e406                	sd	ra,8(sp)
    80005a88:	e022                	sd	s0,0(sp)
    80005a8a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005a8c:	aaefb0ef          	jal	80000d3a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005a90:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005a94:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005a96:	e78d                	bnez	a5,80005ac0 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005a98:	5d3c                	lw	a5,120(a0)
    80005a9a:	02f05963          	blez	a5,80005acc <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80005a9e:	37fd                	addiw	a5,a5,-1
    80005aa0:	0007871b          	sext.w	a4,a5
    80005aa4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005aa6:	eb09                	bnez	a4,80005ab8 <pop_off+0x34>
    80005aa8:	5d7c                	lw	a5,124(a0)
    80005aaa:	c799                	beqz	a5,80005ab8 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005aac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005ab0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005ab4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005ab8:	60a2                	ld	ra,8(sp)
    80005aba:	6402                	ld	s0,0(sp)
    80005abc:	0141                	addi	sp,sp,16
    80005abe:	8082                	ret
    panic("pop_off - interruptible");
    80005ac0:	00002517          	auipc	a0,0x2
    80005ac4:	de050513          	addi	a0,a0,-544 # 800078a0 <etext+0x8a0>
    80005ac8:	c4bff0ef          	jal	80005712 <panic>
    panic("pop_off");
    80005acc:	00002517          	auipc	a0,0x2
    80005ad0:	dec50513          	addi	a0,a0,-532 # 800078b8 <etext+0x8b8>
    80005ad4:	c3fff0ef          	jal	80005712 <panic>

0000000080005ad8 <release>:
{
    80005ad8:	1101                	addi	sp,sp,-32
    80005ada:	ec06                	sd	ra,24(sp)
    80005adc:	e822                	sd	s0,16(sp)
    80005ade:	e426                	sd	s1,8(sp)
    80005ae0:	1000                	addi	s0,sp,32
    80005ae2:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005ae4:	ef3ff0ef          	jal	800059d6 <holding>
    80005ae8:	c105                	beqz	a0,80005b08 <release+0x30>
  lk->cpu = 0;
    80005aea:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005aee:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005af2:	0310000f          	fence	rw,w
    80005af6:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005afa:	f8bff0ef          	jal	80005a84 <pop_off>
}
    80005afe:	60e2                	ld	ra,24(sp)
    80005b00:	6442                	ld	s0,16(sp)
    80005b02:	64a2                	ld	s1,8(sp)
    80005b04:	6105                	addi	sp,sp,32
    80005b06:	8082                	ret
    panic("release");
    80005b08:	00002517          	auipc	a0,0x2
    80005b0c:	db850513          	addi	a0,a0,-584 # 800078c0 <etext+0x8c0>
    80005b10:	c03ff0ef          	jal	80005712 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
