
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	6a013103          	ld	sp,1696(sp) # 8000a6a0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0e8050ef          	jal	800050fe <start>

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
    80000034:	c6078793          	addi	a5,a5,-928 # 80023c90 <end>
    80000038:	02f56b63          	bltu	a0,a5,8000006e <kfree+0x52>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57763          	bgeu	a0,a5,8000006e <kfree+0x52>
  memset(pa, 1, PGSIZE);
#endif
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000044:	0000a917          	auipc	s2,0xa
    80000048:	6ac90913          	addi	s2,s2,1708 # 8000a6f0 <kmem>
    8000004c:	854a                	mv	a0,s2
    8000004e:	313050ef          	jal	80005b60 <acquire>
  r->next = kmem.freelist;
    80000052:	01893783          	ld	a5,24(s2)
    80000056:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000058:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000005c:	854a                	mv	a0,s2
    8000005e:	39b050ef          	jal	80005bf8 <release>
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
    80000076:	7bc050ef          	jal	80005832 <panic>

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
    800000d6:	61e50513          	addi	a0,a0,1566 # 8000a6f0 <kmem>
    800000da:	207050ef          	jal	80005ae0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000de:	45c5                	li	a1,17
    800000e0:	05ee                	slli	a1,a1,0x1b
    800000e2:	00024517          	auipc	a0,0x24
    800000e6:	bae50513          	addi	a0,a0,-1106 # 80023c90 <end>
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
    80000104:	5f048493          	addi	s1,s1,1520 # 8000a6f0 <kmem>
    80000108:	8526                	mv	a0,s1
    8000010a:	257050ef          	jal	80005b60 <acquire>
  r = kmem.freelist;
    8000010e:	6c84                	ld	s1,24(s1)
  if(r) {
    80000110:	c491                	beqz	s1,8000011c <kalloc+0x26>
    kmem.freelist = r->next;
    80000112:	609c                	ld	a5,0(s1)
    80000114:	0000a717          	auipc	a4,0xa
    80000118:	5ef73a23          	sd	a5,1524(a4) # 8000a708 <kmem+0x18>
  }
  release(&kmem.lock);
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	5d450513          	addi	a0,a0,1492 # 8000a6f0 <kmem>
    80000124:	2d5050ef          	jal	80005bf8 <release>
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
    800002de:	3e670713          	addi	a4,a4,998 # 8000a6c0 <started>
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
    800002fc:	264050ef          	jal	80005560 <printf>
    kvminithart();    // turn on paging
    80000300:	080000ef          	jal	80000380 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000304:	54e010ef          	jal	80001852 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000308:	011040ef          	jal	80004b18 <plicinithart>
  }

  scheduler();        
    8000030c:	68b000ef          	jal	80001196 <scheduler>
    consoleinit();
    80000310:	17a050ef          	jal	8000548a <consoleinit>
    printfinit();
    80000314:	558050ef          	jal	8000586c <printfinit>
    printf("\n");
    80000318:	00007517          	auipc	a0,0x7
    8000031c:	d0050513          	addi	a0,a0,-768 # 80007018 <etext+0x18>
    80000320:	240050ef          	jal	80005560 <printf>
    printf("xv6 kernel is booting\n");
    80000324:	00007517          	auipc	a0,0x7
    80000328:	cfc50513          	addi	a0,a0,-772 # 80007020 <etext+0x20>
    8000032c:	234050ef          	jal	80005560 <printf>
    printf("\n");
    80000330:	00007517          	auipc	a0,0x7
    80000334:	ce850513          	addi	a0,a0,-792 # 80007018 <etext+0x18>
    80000338:	228050ef          	jal	80005560 <printf>
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
    80000354:	7aa040ef          	jal	80004afe <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000358:	7c0040ef          	jal	80004b18 <plicinithart>
    binit();         // buffer cache
    8000035c:	6c5010ef          	jal	80002220 <binit>
    iinit();         // inode table
    80000360:	4b6020ef          	jal	80002816 <iinit>
    fileinit();      // file table
    80000364:	262030ef          	jal	800035c6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000368:	0a1040ef          	jal	80004c08 <virtio_disk_init>
    userinit();      // first user process
    8000036c:	457000ef          	jal	80000fc2 <userinit>
    __sync_synchronize();
    80000370:	0330000f          	fence	rw,rw
    started = 1;
    80000374:	4785                	li	a5,1
    80000376:	0000a717          	auipc	a4,0xa
    8000037a:	34f72523          	sw	a5,842(a4) # 8000a6c0 <started>
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
    8000038e:	33e7b783          	ld	a5,830(a5) # 8000a6c8 <kernel_pagetable>
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
    800003d6:	45c050ef          	jal	80005832 <panic>
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
    800003fc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb367>
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
    800004ec:	346050ef          	jal	80005832 <panic>
    panic("mappages: size not aligned");
    800004f0:	00007517          	auipc	a0,0x7
    800004f4:	b8850513          	addi	a0,a0,-1144 # 80007078 <etext+0x78>
    800004f8:	33a050ef          	jal	80005832 <panic>
    panic("mappages: size");
    800004fc:	00007517          	auipc	a0,0x7
    80000500:	b9c50513          	addi	a0,a0,-1124 # 80007098 <etext+0x98>
    80000504:	32e050ef          	jal	80005832 <panic>
      panic("mappages: remap");
    80000508:	00007517          	auipc	a0,0x7
    8000050c:	ba050513          	addi	a0,a0,-1120 # 800070a8 <etext+0xa8>
    80000510:	322050ef          	jal	80005832 <panic>
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
    80000554:	2de050ef          	jal	80005832 <panic>

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
    8000061a:	0aa7b923          	sd	a0,178(a5) # 8000a6c8 <kernel_pagetable>
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
    8000066e:	1c4050ef          	jal	80005832 <panic>
      panic("uvmunmap: walk");
    80000672:	00007517          	auipc	a0,0x7
    80000676:	a6650513          	addi	a0,a0,-1434 # 800070d8 <etext+0xd8>
    8000067a:	1b8050ef          	jal	80005832 <panic>
      printf("va=%ld pte=%ld\n", a, *pte);
    8000067e:	85ca                	mv	a1,s2
    80000680:	00007517          	auipc	a0,0x7
    80000684:	a6850513          	addi	a0,a0,-1432 # 800070e8 <etext+0xe8>
    80000688:	6d9040ef          	jal	80005560 <printf>
      panic("uvmunmap: not mapped");
    8000068c:	00007517          	auipc	a0,0x7
    80000690:	a6c50513          	addi	a0,a0,-1428 # 800070f8 <etext+0xf8>
    80000694:	19e050ef          	jal	80005832 <panic>
      panic("uvmunmap: not a leaf");
    80000698:	00007517          	auipc	a0,0x7
    8000069c:	a7850513          	addi	a0,a0,-1416 # 80007110 <etext+0x110>
    800006a0:	192050ef          	jal	80005832 <panic>
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
    80000772:	0c0050ef          	jal	80005832 <panic>

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
    8000089e:	795040ef          	jal	80005832 <panic>
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
    8000095c:	6d7040ef          	jal	80005832 <panic>
      panic("uvmcopy: page not present");
    80000960:	00007517          	auipc	a0,0x7
    80000964:	81850513          	addi	a0,a0,-2024 # 80007178 <etext+0x178>
    80000968:	6cb040ef          	jal	80005832 <panic>
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
    800009c2:	671040ef          	jal	80005832 <panic>

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
    80000bf6:	f4e48493          	addi	s1,s1,-178 # 8000ab40 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000bfa:	8b26                	mv	s6,s1
    80000bfc:	ff4df937          	lui	s2,0xff4df
    80000c00:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bad2d>
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
    80000c22:	b22a8a93          	addi	s5,s5,-1246 # 80010740 <tickslock>
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
    80000c70:	3c3040ef          	jal	80005832 <panic>

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
    80000c94:	a8050513          	addi	a0,a0,-1408 # 8000a710 <pid_lock>
    80000c98:	649040ef          	jal	80005ae0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000c9c:	00006597          	auipc	a1,0x6
    80000ca0:	51c58593          	addi	a1,a1,1308 # 800071b8 <etext+0x1b8>
    80000ca4:	0000a517          	auipc	a0,0xa
    80000ca8:	a8450513          	addi	a0,a0,-1404 # 8000a728 <wait_lock>
    80000cac:	635040ef          	jal	80005ae0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cb0:	0000a497          	auipc	s1,0xa
    80000cb4:	e9048493          	addi	s1,s1,-368 # 8000ab40 <proc>
      initlock(&p->lock, "proc");
    80000cb8:	00006b17          	auipc	s6,0x6
    80000cbc:	510b0b13          	addi	s6,s6,1296 # 800071c8 <etext+0x1c8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cc0:	8aa6                	mv	s5,s1
    80000cc2:	ff4df937          	lui	s2,0xff4df
    80000cc6:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bad2d>
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
    80000ce8:	a5ca0a13          	addi	s4,s4,-1444 # 80010740 <tickslock>
      initlock(&p->lock, "proc");
    80000cec:	85da                	mv	a1,s6
    80000cee:	8526                	mv	a0,s1
    80000cf0:	5f1040ef          	jal	80005ae0 <initlock>
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
    80000d4a:	9fa50513          	addi	a0,a0,-1542 # 8000a740 <cpus>
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
    80000d60:	5c1040ef          	jal	80005b20 <push_off>
    80000d64:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d66:	2781                	sext.w	a5,a5
    80000d68:	079e                	slli	a5,a5,0x7
    80000d6a:	0000a717          	auipc	a4,0xa
    80000d6e:	9a670713          	addi	a4,a4,-1626 # 8000a710 <pid_lock>
    80000d72:	97ba                	add	a5,a5,a4
    80000d74:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d76:	62f040ef          	jal	80005ba4 <pop_off>
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
    80000d92:	667040ef          	jal	80005bf8 <release>

  if (first) {
    80000d96:	0000a797          	auipc	a5,0xa
    80000d9a:	8ba7a783          	lw	a5,-1862(a5) # 8000a650 <first.1>
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
    80000dae:	1fd010ef          	jal	800027aa <fsinit>
    first = 0;
    80000db2:	0000a797          	auipc	a5,0xa
    80000db6:	8807af23          	sw	zero,-1890(a5) # 8000a650 <first.1>
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
    80000dd0:	94490913          	addi	s2,s2,-1724 # 8000a710 <pid_lock>
    80000dd4:	854a                	mv	a0,s2
    80000dd6:	58b040ef          	jal	80005b60 <acquire>
  pid = nextpid;
    80000dda:	0000a797          	auipc	a5,0xa
    80000dde:	87a78793          	addi	a5,a5,-1926 # 8000a654 <nextpid>
    80000de2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000de4:	0014871b          	addiw	a4,s1,1
    80000de8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000dea:	854a                	mv	a0,s2
    80000dec:	60d040ef          	jal	80005bf8 <release>
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
    80000f28:	c1c48493          	addi	s1,s1,-996 # 8000ab40 <proc>
    80000f2c:	00010917          	auipc	s2,0x10
    80000f30:	81490913          	addi	s2,s2,-2028 # 80010740 <tickslock>
    acquire(&p->lock);
    80000f34:	8526                	mv	a0,s1
    80000f36:	42b040ef          	jal	80005b60 <acquire>
    if(p->state == UNUSED) {
    80000f3a:	4c9c                	lw	a5,24(s1)
    80000f3c:	cb91                	beqz	a5,80000f50 <allocproc+0x38>
      release(&p->lock);
    80000f3e:	8526                	mv	a0,s1
    80000f40:	4b9040ef          	jal	80005bf8 <release>
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
    80000faa:	44f040ef          	jal	80005bf8 <release>
    return 0;
    80000fae:	84ca                	mv	s1,s2
    80000fb0:	b7d5                	j	80000f94 <allocproc+0x7c>
    freeproc(p);
    80000fb2:	8526                	mv	a0,s1
    80000fb4:	f15ff0ef          	jal	80000ec8 <freeproc>
    release(&p->lock);
    80000fb8:	8526                	mv	a0,s1
    80000fba:	43f040ef          	jal	80005bf8 <release>
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
    80000fd6:	6ea7bf23          	sd	a0,1790(a5) # 8000a6d0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000fda:	03400613          	li	a2,52
    80000fde:	00009597          	auipc	a1,0x9
    80000fe2:	68258593          	addi	a1,a1,1666 # 8000a660 <initcode>
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
    80001014:	0a4020ef          	jal	800030b8 <namei>
    80001018:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000101c:	478d                	li	a5,3
    8000101e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001020:	8526                	mv	a0,s1
    80001022:	3d7040ef          	jal	80005bf8 <release>
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
    80001110:	2e9040ef          	jal	80005bf8 <release>
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
    80001126:	522020ef          	jal	80003648 <filedup>
    8000112a:	00a93023          	sd	a0,0(s2)
    8000112e:	b7f5                	j	8000111a <fork+0x9a>
  np->cwd = idup(p->cwd);
    80001130:	150ab503          	ld	a0,336(s5)
    80001134:	075010ef          	jal	800029a8 <idup>
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
    80001150:	2a9040ef          	jal	80005bf8 <release>
  acquire(&wait_lock);
    80001154:	00009497          	auipc	s1,0x9
    80001158:	5d448493          	addi	s1,s1,1492 # 8000a728 <wait_lock>
    8000115c:	8526                	mv	a0,s1
    8000115e:	203040ef          	jal	80005b60 <acquire>
  np->parent = p;
    80001162:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001166:	8526                	mv	a0,s1
    80001168:	291040ef          	jal	80005bf8 <release>
  acquire(&np->lock);
    8000116c:	854e                	mv	a0,s3
    8000116e:	1f3040ef          	jal	80005b60 <acquire>
  np->state = RUNNABLE;
    80001172:	478d                	li	a5,3
    80001174:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001178:	854e                	mv	a0,s3
    8000117a:	27f040ef          	jal	80005bf8 <release>
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
    800011ba:	55a70713          	addi	a4,a4,1370 # 8000a710 <pid_lock>
    800011be:	975a                	add	a4,a4,s6
    800011c0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011c4:	00009717          	auipc	a4,0x9
    800011c8:	58470713          	addi	a4,a4,1412 # 8000a748 <cpus+0x8>
    800011cc:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800011ce:	4c11                	li	s8,4
        c->proc = p;
    800011d0:	079e                	slli	a5,a5,0x7
    800011d2:	00009a17          	auipc	s4,0x9
    800011d6:	53ea0a13          	addi	s4,s4,1342 # 8000a710 <pid_lock>
    800011da:	9a3e                	add	s4,s4,a5
        found = 1;
    800011dc:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    800011de:	0000f997          	auipc	s3,0xf
    800011e2:	56298993          	addi	s3,s3,1378 # 80010740 <tickslock>
    800011e6:	a0a9                	j	80001230 <scheduler+0x9a>
      release(&p->lock);
    800011e8:	8526                	mv	a0,s1
    800011ea:	20f040ef          	jal	80005bf8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011ee:	17048493          	addi	s1,s1,368
    800011f2:	03348563          	beq	s1,s3,8000121c <scheduler+0x86>
      acquire(&p->lock);
    800011f6:	8526                	mv	a0,s1
    800011f8:	169040ef          	jal	80005b60 <acquire>
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
    80001242:	90248493          	addi	s1,s1,-1790 # 8000ab40 <proc>
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
    8000125e:	099040ef          	jal	80005af6 <holding>
    80001262:	c92d                	beqz	a0,800012d4 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001264:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001266:	2781                	sext.w	a5,a5
    80001268:	079e                	slli	a5,a5,0x7
    8000126a:	00009717          	auipc	a4,0x9
    8000126e:	4a670713          	addi	a4,a4,1190 # 8000a710 <pid_lock>
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
    80001294:	48090913          	addi	s2,s2,1152 # 8000a710 <pid_lock>
    80001298:	2781                	sext.w	a5,a5
    8000129a:	079e                	slli	a5,a5,0x7
    8000129c:	97ca                	add	a5,a5,s2
    8000129e:	0ac7a983          	lw	s3,172(a5)
    800012a2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012a4:	2781                	sext.w	a5,a5
    800012a6:	079e                	slli	a5,a5,0x7
    800012a8:	00009597          	auipc	a1,0x9
    800012ac:	4a058593          	addi	a1,a1,1184 # 8000a748 <cpus+0x8>
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
    800012dc:	556040ef          	jal	80005832 <panic>
    panic("sched locks");
    800012e0:	00006517          	auipc	a0,0x6
    800012e4:	f1850513          	addi	a0,a0,-232 # 800071f8 <etext+0x1f8>
    800012e8:	54a040ef          	jal	80005832 <panic>
    panic("sched running");
    800012ec:	00006517          	auipc	a0,0x6
    800012f0:	f1c50513          	addi	a0,a0,-228 # 80007208 <etext+0x208>
    800012f4:	53e040ef          	jal	80005832 <panic>
    panic("sched interruptible");
    800012f8:	00006517          	auipc	a0,0x6
    800012fc:	f2050513          	addi	a0,a0,-224 # 80007218 <etext+0x218>
    80001300:	532040ef          	jal	80005832 <panic>

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
    80001314:	04d040ef          	jal	80005b60 <acquire>
  p->state = RUNNABLE;
    80001318:	478d                	li	a5,3
    8000131a:	cc9c                	sw	a5,24(s1)
  sched();
    8000131c:	f2fff0ef          	jal	8000124a <sched>
  release(&p->lock);
    80001320:	8526                	mv	a0,s1
    80001322:	0d7040ef          	jal	80005bf8 <release>
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
    80001348:	019040ef          	jal	80005b60 <acquire>
  release(lk);
    8000134c:	854a                	mv	a0,s2
    8000134e:	0ab040ef          	jal	80005bf8 <release>

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
    80001364:	095040ef          	jal	80005bf8 <release>
  acquire(lk);
    80001368:	854a                	mv	a0,s2
    8000136a:	7f6040ef          	jal	80005b60 <acquire>
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
    80001394:	7b048493          	addi	s1,s1,1968 # 8000ab40 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001398:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000139a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000139c:	0000f917          	auipc	s2,0xf
    800013a0:	3a490913          	addi	s2,s2,932 # 80010740 <tickslock>
    800013a4:	a801                	j	800013b4 <wakeup+0x38>
      }
      release(&p->lock);
    800013a6:	8526                	mv	a0,s1
    800013a8:	051040ef          	jal	80005bf8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013ac:	17048493          	addi	s1,s1,368
    800013b0:	03248263          	beq	s1,s2,800013d4 <wakeup+0x58>
    if(p != myproc()){
    800013b4:	9a3ff0ef          	jal	80000d56 <myproc>
    800013b8:	fea48ae3          	beq	s1,a0,800013ac <wakeup+0x30>
      acquire(&p->lock);
    800013bc:	8526                	mv	a0,s1
    800013be:	7a2040ef          	jal	80005b60 <acquire>
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
    800013fc:	74848493          	addi	s1,s1,1864 # 8000ab40 <proc>
      pp->parent = initproc;
    80001400:	00009a17          	auipc	s4,0x9
    80001404:	2d0a0a13          	addi	s4,s4,720 # 8000a6d0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001408:	0000f997          	auipc	s3,0xf
    8000140c:	33898993          	addi	s3,s3,824 # 80010740 <tickslock>
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
    80001458:	27c7b783          	ld	a5,636(a5) # 8000a6d0 <initproc>
    8000145c:	0d050493          	addi	s1,a0,208
    80001460:	15050913          	addi	s2,a0,336
    80001464:	00a79f63          	bne	a5,a0,80001482 <exit+0x46>
    panic("init exiting");
    80001468:	00006517          	auipc	a0,0x6
    8000146c:	dc850513          	addi	a0,a0,-568 # 80007230 <etext+0x230>
    80001470:	3c2040ef          	jal	80005832 <panic>
      fileclose(f);
    80001474:	21a020ef          	jal	8000368e <fileclose>
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
    80001488:	5ed010ef          	jal	80003274 <begin_op>
  iput(p->cwd);
    8000148c:	1509b503          	ld	a0,336(s3)
    80001490:	6d0010ef          	jal	80002b60 <iput>
  end_op();
    80001494:	64b010ef          	jal	800032de <end_op>
  p->cwd = 0;
    80001498:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000149c:	00009497          	auipc	s1,0x9
    800014a0:	28c48493          	addi	s1,s1,652 # 8000a728 <wait_lock>
    800014a4:	8526                	mv	a0,s1
    800014a6:	6ba040ef          	jal	80005b60 <acquire>
  reparent(p);
    800014aa:	854e                	mv	a0,s3
    800014ac:	f3bff0ef          	jal	800013e6 <reparent>
  wakeup(p->parent);
    800014b0:	0389b503          	ld	a0,56(s3)
    800014b4:	ec9ff0ef          	jal	8000137c <wakeup>
  acquire(&p->lock);
    800014b8:	854e                	mv	a0,s3
    800014ba:	6a6040ef          	jal	80005b60 <acquire>
  p->xstate = status;
    800014be:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014c2:	4795                	li	a5,5
    800014c4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014c8:	8526                	mv	a0,s1
    800014ca:	72e040ef          	jal	80005bf8 <release>
  sched();
    800014ce:	d7dff0ef          	jal	8000124a <sched>
  panic("zombie exit");
    800014d2:	00006517          	auipc	a0,0x6
    800014d6:	d6e50513          	addi	a0,a0,-658 # 80007240 <etext+0x240>
    800014da:	358040ef          	jal	80005832 <panic>

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
    800014f2:	65248493          	addi	s1,s1,1618 # 8000ab40 <proc>
    800014f6:	0000f997          	auipc	s3,0xf
    800014fa:	24a98993          	addi	s3,s3,586 # 80010740 <tickslock>
    acquire(&p->lock);
    800014fe:	8526                	mv	a0,s1
    80001500:	660040ef          	jal	80005b60 <acquire>
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
    8000150c:	6ec040ef          	jal	80005bf8 <release>
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
    8000152a:	6ce040ef          	jal	80005bf8 <release>
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
    80001550:	610040ef          	jal	80005b60 <acquire>
  p->killed = 1;
    80001554:	4785                	li	a5,1
    80001556:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001558:	8526                	mv	a0,s1
    8000155a:	69e040ef          	jal	80005bf8 <release>
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
    80001576:	5ea040ef          	jal	80005b60 <acquire>
  k = p->killed;
    8000157a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000157e:	8526                	mv	a0,s1
    80001580:	678040ef          	jal	80005bf8 <release>
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
    800015b6:	17650513          	addi	a0,a0,374 # 8000a728 <wait_lock>
    800015ba:	5a6040ef          	jal	80005b60 <acquire>
    havekids = 0;
    800015be:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800015c0:	4a15                	li	s4,5
        havekids = 1;
    800015c2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015c4:	0000f997          	auipc	s3,0xf
    800015c8:	17c98993          	addi	s3,s3,380 # 80010740 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015cc:	00009c17          	auipc	s8,0x9
    800015d0:	15cc0c13          	addi	s8,s8,348 # 8000a728 <wait_lock>
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
    800015fa:	5fe040ef          	jal	80005bf8 <release>
          release(&wait_lock);
    800015fe:	00009517          	auipc	a0,0x9
    80001602:	12a50513          	addi	a0,a0,298 # 8000a728 <wait_lock>
    80001606:	5f2040ef          	jal	80005bf8 <release>
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
    80001626:	5d2040ef          	jal	80005bf8 <release>
            release(&wait_lock);
    8000162a:	00009517          	auipc	a0,0x9
    8000162e:	0fe50513          	addi	a0,a0,254 # 8000a728 <wait_lock>
    80001632:	5c6040ef          	jal	80005bf8 <release>
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
    8000164a:	516040ef          	jal	80005b60 <acquire>
        if(pp->state == ZOMBIE){
    8000164e:	4c9c                	lw	a5,24(s1)
    80001650:	f94783e3          	beq	a5,s4,800015d6 <wait+0x44>
        release(&pp->lock);
    80001654:	8526                	mv	a0,s1
    80001656:	5a2040ef          	jal	80005bf8 <release>
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
    80001676:	4ce48493          	addi	s1,s1,1230 # 8000ab40 <proc>
    8000167a:	b7e1                	j	80001642 <wait+0xb0>
      release(&wait_lock);
    8000167c:	00009517          	auipc	a0,0x9
    80001680:	0ac50513          	addi	a0,a0,172 # 8000a728 <wait_lock>
    80001684:	574040ef          	jal	80005bf8 <release>
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
    8000173e:	623030ef          	jal	80005560 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001742:	00009497          	auipc	s1,0x9
    80001746:	55648493          	addi	s1,s1,1366 # 8000ac98 <proc+0x158>
    8000174a:	0000f917          	auipc	s2,0xf
    8000174e:	14e90913          	addi	s2,s2,334 # 80010898 <bcache+0xd0>
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
    80001770:	1a4b8b93          	addi	s7,s7,420 # 80007910 <states.0>
    80001774:	a829                	j	8000178e <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001776:	ed86a583          	lw	a1,-296(a3)
    8000177a:	8556                	mv	a0,s5
    8000177c:	5e5030ef          	jal	80005560 <printf>
    printf("\n");
    80001780:	8552                	mv	a0,s4
    80001782:	5df030ef          	jal	80005560 <printf>
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
    80001842:	f0250513          	addi	a0,a0,-254 # 80010740 <tickslock>
    80001846:	29a040ef          	jal	80005ae0 <initlock>
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
    8000185c:	24878793          	addi	a5,a5,584 # 80004aa0 <kernelvec>
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
    8000192a:	e1a48493          	addi	s1,s1,-486 # 80010740 <tickslock>
    8000192e:	8526                	mv	a0,s1
    80001930:	230040ef          	jal	80005b60 <acquire>
    ticks++;
    80001934:	00009517          	auipc	a0,0x9
    80001938:	da450513          	addi	a0,a0,-604 # 8000a6d8 <ticks>
    8000193c:	411c                	lw	a5,0(a0)
    8000193e:	2785                	addiw	a5,a5,1
    80001940:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001942:	a3bff0ef          	jal	8000137c <wakeup>
    release(&tickslock);
    80001946:	8526                	mv	a0,s1
    80001948:	2b0040ef          	jal	80005bf8 <release>
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
    8000197c:	1d0030ef          	jal	80004b4c <plic_claim>
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
    80001996:	10e040ef          	jal	80005aa4 <uartintr>
    if(irq)
    8000199a:	a819                	j	800019b0 <devintr+0x60>
      virtio_disk_intr();
    8000199c:	676030ef          	jal	80005012 <virtio_disk_intr>
    if(irq)
    800019a0:	a801                	j	800019b0 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019a2:	85a6                	mv	a1,s1
    800019a4:	00006517          	auipc	a0,0x6
    800019a8:	8fc50513          	addi	a0,a0,-1796 # 800072a0 <etext+0x2a0>
    800019ac:	3b5030ef          	jal	80005560 <printf>
      plic_complete(irq);
    800019b0:	8526                	mv	a0,s1
    800019b2:	1ba030ef          	jal	80004b6c <plic_complete>
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
    800019de:	0c678793          	addi	a5,a5,198 # 80004aa0 <kernelvec>
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
    80001a18:	61b030ef          	jal	80005832 <panic>
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
    80001a36:	3b4000ef          	jal	80001dea <syscall>
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
    80001a76:	2eb030ef          	jal	80005560 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a7a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a7e:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a82:	00006517          	auipc	a0,0x6
    80001a86:	88e50513          	addi	a0,a0,-1906 # 80007310 <etext+0x310>
    80001a8a:	2d7030ef          	jal	80005560 <printf>
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
    80001aee:	545030ef          	jal	80005832 <panic>
    panic("kerneltrap: interrupts enabled");
    80001af2:	00006517          	auipc	a0,0x6
    80001af6:	86e50513          	addi	a0,a0,-1938 # 80007360 <etext+0x360>
    80001afa:	539030ef          	jal	80005832 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001afe:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b02:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b06:	85ce                	mv	a1,s3
    80001b08:	00006517          	auipc	a0,0x6
    80001b0c:	87850513          	addi	a0,a0,-1928 # 80007380 <etext+0x380>
    80001b10:	251030ef          	jal	80005560 <printf>
    panic("kerneltrap");
    80001b14:	00006517          	auipc	a0,0x6
    80001b18:	89450513          	addi	a0,a0,-1900 # 800073a8 <etext+0x3a8>
    80001b1c:	517030ef          	jal	80005832 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b20:	a36ff0ef          	jal	80000d56 <myproc>
    80001b24:	d555                	beqz	a0,80001ad0 <kerneltrap+0x34>
    yield();
    80001b26:	fdeff0ef          	jal	80001304 <yield>
    80001b2a:	b75d                	j	80001ad0 <kerneltrap+0x34>

0000000080001b2c <sys_stats>:
  argaddr(0, &tv_addr);
  argaddr(1, &tz_addr);
  return -1;
}

uint64 sys_stats(void) {
    80001b2c:	7139                	addi	sp,sp,-64
    80001b2e:	fc06                	sd	ra,56(sp)
    80001b30:	f822                	sd	s0,48(sp)
    80001b32:	f426                	sd	s1,40(sp)
    80001b34:	f04a                	sd	s2,32(sp)
    80001b36:	ec4e                	sd	s3,24(sp)
    80001b38:	e852                	sd	s4,16(sp)
    80001b3a:	e456                	sd	s5,8(sp)
    80001b3c:	0080                	addi	s0,sp,64
  for (int i = 0; i < NELEM(syscalls); i++) {
    80001b3e:	0000f497          	auipc	s1,0xf
    80001b42:	c1a48493          	addi	s1,s1,-998 # 80010758 <syscall_counts>
    80001b46:	00006917          	auipc	s2,0x6
    80001b4a:	e1290913          	addi	s2,s2,-494 # 80007958 <syscall_names>
    80001b4e:	0000f997          	auipc	s3,0xf
    80001b52:	c7698993          	addi	s3,s3,-906 # 800107c4 <syscall_counts+0x6c>
    if (syscall_counts[i] > 0) {
      printf("%s: %d calls\n", syscall_names[i] ? syscall_names[i] : "unknown", syscall_counts[i]);
    80001b56:	00006a17          	auipc	s4,0x6
    80001b5a:	86aa0a13          	addi	s4,s4,-1942 # 800073c0 <etext+0x3c0>
    80001b5e:	00006a97          	auipc	s5,0x6
    80001b62:	85aa8a93          	addi	s5,s5,-1958 # 800073b8 <etext+0x3b8>
    80001b66:	a801                	j	80001b76 <sys_stats+0x4a>
    80001b68:	8552                	mv	a0,s4
    80001b6a:	1f7030ef          	jal	80005560 <printf>
  for (int i = 0; i < NELEM(syscalls); i++) {
    80001b6e:	0491                	addi	s1,s1,4
    80001b70:	0921                	addi	s2,s2,8
    80001b72:	01348a63          	beq	s1,s3,80001b86 <sys_stats+0x5a>
    if (syscall_counts[i] > 0) {
    80001b76:	4090                	lw	a2,0(s1)
    80001b78:	fec05be3          	blez	a2,80001b6e <sys_stats+0x42>
      printf("%s: %d calls\n", syscall_names[i] ? syscall_names[i] : "unknown", syscall_counts[i]);
    80001b7c:	00093583          	ld	a1,0(s2)
    80001b80:	f5e5                	bnez	a1,80001b68 <sys_stats+0x3c>
    80001b82:	85d6                	mv	a1,s5
    80001b84:	b7d5                	j	80001b68 <sys_stats+0x3c>
    }
  }
  return 0;
}
    80001b86:	4501                	li	a0,0
    80001b88:	70e2                	ld	ra,56(sp)
    80001b8a:	7442                	ld	s0,48(sp)
    80001b8c:	74a2                	ld	s1,40(sp)
    80001b8e:	7902                	ld	s2,32(sp)
    80001b90:	69e2                	ld	s3,24(sp)
    80001b92:	6a42                	ld	s4,16(sp)
    80001b94:	6aa2                	ld	s5,8(sp)
    80001b96:	6121                	addi	sp,sp,64
    80001b98:	8082                	ret

0000000080001b9a <argraw>:
{
    80001b9a:	7179                	addi	sp,sp,-48
    80001b9c:	f406                	sd	ra,40(sp)
    80001b9e:	f022                	sd	s0,32(sp)
    80001ba0:	ec26                	sd	s1,24(sp)
    80001ba2:	e84a                	sd	s2,16(sp)
    80001ba4:	e44e                	sd	s3,8(sp)
    80001ba6:	1800                	addi	s0,sp,48
    80001ba8:	84aa                	mv	s1,a0
    80001baa:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80001bac:	9aaff0ef          	jal	80000d56 <myproc>
  printf("argraw: n=%d, proc=%p, trapframe=%p\n", n, p, p ? p->trapframe : 0);
    80001bb0:	c159                	beqz	a0,80001c36 <argraw+0x9c>
    80001bb2:	892a                	mv	s2,a0
    80001bb4:	6d34                	ld	a3,88(a0)
    80001bb6:	862a                	mv	a2,a0
    80001bb8:	85a6                	mv	a1,s1
    80001bba:	00006517          	auipc	a0,0x6
    80001bbe:	81650513          	addi	a0,a0,-2026 # 800073d0 <etext+0x3d0>
    80001bc2:	19f030ef          	jal	80005560 <printf>
  if (p == 0 || p->trapframe == 0) {
    80001bc6:	05893683          	ld	a3,88(s2)
    80001bca:	cebd                	beqz	a3,80001c48 <argraw+0xae>
  if (n < 0 || n > 5) {
    80001bcc:	0004879b          	sext.w	a5,s1
    80001bd0:	4715                	li	a4,5
    80001bd2:	00f76e63          	bltu	a4,a5,80001bee <argraw+0x54>
  switch (n) {
    80001bd6:	4795                	li	a5,5
    80001bd8:	0297e463          	bltu	a5,s1,80001c00 <argraw+0x66>
    80001bdc:	048a                	slli	s1,s1,0x2
    80001bde:	00006717          	auipc	a4,0x6
    80001be2:	d6270713          	addi	a4,a4,-670 # 80007940 <states.0+0x30>
    80001be6:	94ba                	add	s1,s1,a4
    80001be8:	409c                	lw	a5,0(s1)
    80001bea:	97ba                	add	a5,a5,a4
    80001bec:	8782                	jr	a5
    panic("argraw: invalid n");
    80001bee:	00006517          	auipc	a0,0x6
    80001bf2:	83250513          	addi	a0,a0,-1998 # 80007420 <etext+0x420>
    80001bf6:	43d030ef          	jal	80005832 <panic>
    case 0: *ip = p->trapframe->a0; break;
    80001bfa:	7abc                	ld	a5,112(a3)
    80001bfc:	00f9b023          	sd	a5,0(s3)
}
    80001c00:	70a2                	ld	ra,40(sp)
    80001c02:	7402                	ld	s0,32(sp)
    80001c04:	64e2                	ld	s1,24(sp)
    80001c06:	6942                	ld	s2,16(sp)
    80001c08:	69a2                	ld	s3,8(sp)
    80001c0a:	6145                	addi	sp,sp,48
    80001c0c:	8082                	ret
    case 1: *ip = p->trapframe->a1; break;
    80001c0e:	7ebc                	ld	a5,120(a3)
    80001c10:	00f9b023          	sd	a5,0(s3)
    80001c14:	b7f5                	j	80001c00 <argraw+0x66>
    case 2: *ip = p->trapframe->a2; break;
    80001c16:	62dc                	ld	a5,128(a3)
    80001c18:	00f9b023          	sd	a5,0(s3)
    80001c1c:	b7d5                	j	80001c00 <argraw+0x66>
    case 3: *ip = p->trapframe->a3; break;
    80001c1e:	66dc                	ld	a5,136(a3)
    80001c20:	00f9b023          	sd	a5,0(s3)
    80001c24:	bff1                	j	80001c00 <argraw+0x66>
    case 4: *ip = p->trapframe->a4; break;
    80001c26:	6adc                	ld	a5,144(a3)
    80001c28:	00f9b023          	sd	a5,0(s3)
    80001c2c:	bfd1                	j	80001c00 <argraw+0x66>
    case 5: *ip = p->trapframe->a5; break;
    80001c2e:	6edc                	ld	a5,152(a3)
    80001c30:	00f9b023          	sd	a5,0(s3)
}
    80001c34:	b7f1                	j	80001c00 <argraw+0x66>
  printf("argraw: n=%d, proc=%p, trapframe=%p\n", n, p, p ? p->trapframe : 0);
    80001c36:	4681                	li	a3,0
    80001c38:	4601                	li	a2,0
    80001c3a:	85a6                	mv	a1,s1
    80001c3c:	00005517          	auipc	a0,0x5
    80001c40:	79450513          	addi	a0,a0,1940 # 800073d0 <etext+0x3d0>
    80001c44:	11d030ef          	jal	80005560 <printf>
    panic("argraw: invalid proc or trapframe");
    80001c48:	00005517          	auipc	a0,0x5
    80001c4c:	7b050513          	addi	a0,a0,1968 # 800073f8 <etext+0x3f8>
    80001c50:	3e3030ef          	jal	80005832 <panic>

0000000080001c54 <sys_gettime>:
uint64 sys_gettime(void) {
    80001c54:	1101                	addi	sp,sp,-32
    80001c56:	ec06                	sd	ra,24(sp)
    80001c58:	e822                	sd	s0,16(sp)
    80001c5a:	1000                	addi	s0,sp,32
    argraw(n, ip);
    80001c5c:	fe840593          	addi	a1,s0,-24
    80001c60:	4501                	li	a0,0
    80001c62:	f39ff0ef          	jal	80001b9a <argraw>
    80001c66:	fe040593          	addi	a1,s0,-32
    80001c6a:	4505                	li	a0,1
    80001c6c:	f2fff0ef          	jal	80001b9a <argraw>
}
    80001c70:	557d                	li	a0,-1
    80001c72:	60e2                	ld	ra,24(sp)
    80001c74:	6442                	ld	s0,16(sp)
    80001c76:	6105                	addi	sp,sp,32
    80001c78:	8082                	ret

0000000080001c7a <fetchaddr>:
{
    80001c7a:	1101                	addi	sp,sp,-32
    80001c7c:	ec06                	sd	ra,24(sp)
    80001c7e:	e822                	sd	s0,16(sp)
    80001c80:	e426                	sd	s1,8(sp)
    80001c82:	e04a                	sd	s2,0(sp)
    80001c84:	1000                	addi	s0,sp,32
    80001c86:	84aa                	mv	s1,a0
    80001c88:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c8a:	8ccff0ef          	jal	80000d56 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c8e:	653c                	ld	a5,72(a0)
    80001c90:	02f4f663          	bgeu	s1,a5,80001cbc <fetchaddr+0x42>
    80001c94:	00848713          	addi	a4,s1,8
    80001c98:	02e7e463          	bltu	a5,a4,80001cc0 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c9c:	46a1                	li	a3,8
    80001c9e:	8626                	mv	a2,s1
    80001ca0:	85ca                	mv	a1,s2
    80001ca2:	6928                	ld	a0,80(a0)
    80001ca4:	dfbfe0ef          	jal	80000a9e <copyin>
    80001ca8:	00a03533          	snez	a0,a0
    80001cac:	40a00533          	neg	a0,a0
}
    80001cb0:	60e2                	ld	ra,24(sp)
    80001cb2:	6442                	ld	s0,16(sp)
    80001cb4:	64a2                	ld	s1,8(sp)
    80001cb6:	6902                	ld	s2,0(sp)
    80001cb8:	6105                	addi	sp,sp,32
    80001cba:	8082                	ret
    return -1;
    80001cbc:	557d                	li	a0,-1
    80001cbe:	bfcd                	j	80001cb0 <fetchaddr+0x36>
    80001cc0:	557d                	li	a0,-1
    80001cc2:	b7fd                	j	80001cb0 <fetchaddr+0x36>

0000000080001cc4 <fetchstr>:
{
    80001cc4:	7179                	addi	sp,sp,-48
    80001cc6:	f406                	sd	ra,40(sp)
    80001cc8:	f022                	sd	s0,32(sp)
    80001cca:	ec26                	sd	s1,24(sp)
    80001ccc:	e84a                	sd	s2,16(sp)
    80001cce:	e44e                	sd	s3,8(sp)
    80001cd0:	1800                	addi	s0,sp,48
    80001cd2:	892a                	mv	s2,a0
    80001cd4:	84ae                	mv	s1,a1
    80001cd6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001cd8:	87eff0ef          	jal	80000d56 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001cdc:	86ce                	mv	a3,s3
    80001cde:	864a                	mv	a2,s2
    80001ce0:	85a6                	mv	a1,s1
    80001ce2:	6928                	ld	a0,80(a0)
    80001ce4:	e41fe0ef          	jal	80000b24 <copyinstr>
    80001ce8:	00054c63          	bltz	a0,80001d00 <fetchstr+0x3c>
  return strlen(buf);
    80001cec:	8526                	mv	a0,s1
    80001cee:	db6fe0ef          	jal	800002a4 <strlen>
}
    80001cf2:	70a2                	ld	ra,40(sp)
    80001cf4:	7402                	ld	s0,32(sp)
    80001cf6:	64e2                	ld	s1,24(sp)
    80001cf8:	6942                	ld	s2,16(sp)
    80001cfa:	69a2                	ld	s3,8(sp)
    80001cfc:	6145                	addi	sp,sp,48
    80001cfe:	8082                	ret
    return -1;
    80001d00:	557d                	li	a0,-1
    80001d02:	bfc5                	j	80001cf2 <fetchstr+0x2e>

0000000080001d04 <argint>:
{
    80001d04:	7179                	addi	sp,sp,-48
    80001d06:	f406                	sd	ra,40(sp)
    80001d08:	f022                	sd	s0,32(sp)
    80001d0a:	ec26                	sd	s1,24(sp)
    80001d0c:	1800                	addi	s0,sp,48
    80001d0e:	84ae                	mv	s1,a1
  argraw(n, &val);
    80001d10:	fd840593          	addi	a1,s0,-40
    80001d14:	e87ff0ef          	jal	80001b9a <argraw>
  *ip = (int)val;
    80001d18:	fd843783          	ld	a5,-40(s0)
    80001d1c:	c09c                	sw	a5,0(s1)
}
    80001d1e:	70a2                	ld	ra,40(sp)
    80001d20:	7402                	ld	s0,32(sp)
    80001d22:	64e2                	ld	s1,24(sp)
    80001d24:	6145                	addi	sp,sp,48
    80001d26:	8082                	ret

0000000080001d28 <sys_socket>:

uint64 sys_socket(void) {
    80001d28:	1101                	addi	sp,sp,-32
    80001d2a:	ec06                	sd	ra,24(sp)
    80001d2c:	e822                	sd	s0,16(sp)
    80001d2e:	1000                	addi	s0,sp,32
  int domain, type, protocol;
  argint(0, &domain);
    80001d30:	fec40593          	addi	a1,s0,-20
    80001d34:	4501                	li	a0,0
    80001d36:	fcfff0ef          	jal	80001d04 <argint>
  argint(1, &type);
    80001d3a:	fe840593          	addi	a1,s0,-24
    80001d3e:	4505                	li	a0,1
    80001d40:	fc5ff0ef          	jal	80001d04 <argint>
  argint(2, &protocol);
    80001d44:	fe440593          	addi	a1,s0,-28
    80001d48:	4509                	li	a0,2
    80001d4a:	fbbff0ef          	jal	80001d04 <argint>
  return -1;
}
    80001d4e:	557d                	li	a0,-1
    80001d50:	60e2                	ld	ra,24(sp)
    80001d52:	6442                	ld	s0,16(sp)
    80001d54:	6105                	addi	sp,sp,32
    80001d56:	8082                	ret

0000000080001d58 <sys_mmap>:



uint64 sys_mmap(void) {
    80001d58:	7179                	addi	sp,sp,-48
    80001d5a:	f406                	sd	ra,40(sp)
    80001d5c:	f022                	sd	s0,32(sp)
    80001d5e:	1800                	addi	s0,sp,48
    argraw(n, ip);
    80001d60:	fe840593          	addi	a1,s0,-24
    80001d64:	4501                	li	a0,0
    80001d66:	e35ff0ef          	jal	80001b9a <argraw>
  uint64 addr;
  int length, prot, flags, fd, offset;
  argaddr(0, &addr);
  argint(1, &length);
    80001d6a:	fe440593          	addi	a1,s0,-28
    80001d6e:	4505                	li	a0,1
    80001d70:	f95ff0ef          	jal	80001d04 <argint>
  argint(2, &prot);
    80001d74:	fe040593          	addi	a1,s0,-32
    80001d78:	4509                	li	a0,2
    80001d7a:	f8bff0ef          	jal	80001d04 <argint>
  argint(3, &flags);
    80001d7e:	fdc40593          	addi	a1,s0,-36
    80001d82:	450d                	li	a0,3
    80001d84:	f81ff0ef          	jal	80001d04 <argint>
  argint(4, &fd);
    80001d88:	fd840593          	addi	a1,s0,-40
    80001d8c:	4511                	li	a0,4
    80001d8e:	f77ff0ef          	jal	80001d04 <argint>
  argint(5, &offset);
    80001d92:	fd440593          	addi	a1,s0,-44
    80001d96:	4515                	li	a0,5
    80001d98:	f6dff0ef          	jal	80001d04 <argint>
  return -1;
}
    80001d9c:	557d                	li	a0,-1
    80001d9e:	70a2                	ld	ra,40(sp)
    80001da0:	7402                	ld	s0,32(sp)
    80001da2:	6145                	addi	sp,sp,48
    80001da4:	8082                	ret

0000000080001da6 <argaddr>:
{
    80001da6:	1141                	addi	sp,sp,-16
    80001da8:	e406                	sd	ra,8(sp)
    80001daa:	e022                	sd	s0,0(sp)
    80001dac:	0800                	addi	s0,sp,16
    argraw(n, ip);
    80001dae:	dedff0ef          	jal	80001b9a <argraw>
}
    80001db2:	60a2                	ld	ra,8(sp)
    80001db4:	6402                	ld	s0,0(sp)
    80001db6:	0141                	addi	sp,sp,16
    80001db8:	8082                	ret

0000000080001dba <argstr>:
{
    80001dba:	7179                	addi	sp,sp,-48
    80001dbc:	f406                	sd	ra,40(sp)
    80001dbe:	f022                	sd	s0,32(sp)
    80001dc0:	ec26                	sd	s1,24(sp)
    80001dc2:	e84a                	sd	s2,16(sp)
    80001dc4:	1800                	addi	s0,sp,48
    80001dc6:	84ae                	mv	s1,a1
    80001dc8:	8932                	mv	s2,a2
    argraw(n, ip);
    80001dca:	fd840593          	addi	a1,s0,-40
    80001dce:	dcdff0ef          	jal	80001b9a <argraw>
  return fetchstr(addr, buf, max);
    80001dd2:	864a                	mv	a2,s2
    80001dd4:	85a6                	mv	a1,s1
    80001dd6:	fd843503          	ld	a0,-40(s0)
    80001dda:	eebff0ef          	jal	80001cc4 <fetchstr>
}
    80001dde:	70a2                	ld	ra,40(sp)
    80001de0:	7402                	ld	s0,32(sp)
    80001de2:	64e2                	ld	s1,24(sp)
    80001de4:	6942                	ld	s2,16(sp)
    80001de6:	6145                	addi	sp,sp,48
    80001de8:	8082                	ret

0000000080001dea <syscall>:

////////////////[New sys call  the "coooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooler one" ]////////////////////////////////////////////
// System call dispatcher with statistics
void
syscall(void)
{
    80001dea:	1101                	addi	sp,sp,-32
    80001dec:	ec06                	sd	ra,24(sp)
    80001dee:	e822                	sd	s0,16(sp)
    80001df0:	e426                	sd	s1,8(sp)
    80001df2:	e04a                	sd	s2,0(sp)
    80001df4:	1000                	addi	s0,sp,32
  int num = myproc()->trapframe->a7;
    80001df6:	f61fe0ef          	jal	80000d56 <myproc>
    80001dfa:	6d3c                	ld	a5,88(a0)
    80001dfc:	77c4                	ld	s1,168(a5)
    80001dfe:	0004891b          	sext.w	s2,s1
  printf("syscall: num=%d\n", num);
    80001e02:	85ca                	mv	a1,s2
    80001e04:	00005517          	auipc	a0,0x5
    80001e08:	63450513          	addi	a0,a0,1588 # 80007438 <etext+0x438>
    80001e0c:	754030ef          	jal	80005560 <printf>
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001e10:	34fd                	addiw	s1,s1,-1
    80001e12:	47e5                	li	a5,25
    80001e14:	0297e363          	bltu	a5,s1,80001e3a <syscall+0x50>
    80001e18:	00391713          	slli	a4,s2,0x3
    80001e1c:	00006797          	auipc	a5,0x6
    80001e20:	b3c78793          	addi	a5,a5,-1220 # 80007958 <syscall_names>
    80001e24:	97ba                	add	a5,a5,a4
    80001e26:	6fe4                	ld	s1,216(a5)
    80001e28:	c889                	beqz	s1,80001e3a <syscall+0x50>
    myproc()->trapframe->a0 = syscalls[num]();
    80001e2a:	f2dfe0ef          	jal	80000d56 <myproc>
    80001e2e:	05853903          	ld	s2,88(a0)
    80001e32:	9482                	jalr	s1
    80001e34:	06a93823          	sd	a0,112(s2)
    80001e38:	a829                	j	80001e52 <syscall+0x68>
  } else {
    printf("unknown sys call %d\n", num);
    80001e3a:	85ca                	mv	a1,s2
    80001e3c:	00005517          	auipc	a0,0x5
    80001e40:	61450513          	addi	a0,a0,1556 # 80007450 <etext+0x450>
    80001e44:	71c030ef          	jal	80005560 <printf>
    myproc()->trapframe->a0 = -1;
    80001e48:	f0ffe0ef          	jal	80000d56 <myproc>
    80001e4c:	6d3c                	ld	a5,88(a0)
    80001e4e:	577d                	li	a4,-1
    80001e50:	fbb8                	sd	a4,112(a5)
  }
}
    80001e52:	60e2                	ld	ra,24(sp)
    80001e54:	6442                	ld	s0,16(sp)
    80001e56:	64a2                	ld	s1,8(sp)
    80001e58:	6902                	ld	s2,0(sp)
    80001e5a:	6105                	addi	sp,sp,32
    80001e5c:	8082                	ret

0000000080001e5e <read_string>:
///////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////
// Read null-terminated string from user space
int read_string(struct proc *p, uint64 addr, char *buf, int max) {
    80001e5e:	715d                	addi	sp,sp,-80
    80001e60:	e486                	sd	ra,72(sp)
    80001e62:	e0a2                	sd	s0,64(sp)
    80001e64:	f84a                	sd	s2,48(sp)
    80001e66:	0880                	addi	s0,sp,80
  
  if(addr >= p->sz)
    80001e68:	653c                	ld	a5,72(a0)
    80001e6a:	08f5f563          	bgeu	a1,a5,80001ef4 <read_string+0x96>
    80001e6e:	f052                	sd	s4,32(sp)
    80001e70:	ec56                	sd	s5,24(sp)
    80001e72:	e45e                	sd	s7,8(sp)
    80001e74:	8aaa                	mv	s5,a0
    80001e76:	8bb2                	mv	s7,a2
    80001e78:	8a36                	mv	s4,a3
  {
    return -1; }
  int n = 0;
  while(n < max) {
    80001e7a:	06d05763          	blez	a3,80001ee8 <read_string+0x8a>
    80001e7e:	fc26                	sd	s1,56(sp)
    80001e80:	f44e                	sd	s3,40(sp)
    80001e82:	e85a                	sd	s6,16(sp)
    80001e84:	84b2                	mv	s1,a2
  int n = 0;
    80001e86:	4901                	li	s2,0
    if(copyin(p->pagetable, buf + n, addr + n, 1) == -1) {
    80001e88:	40c589b3          	sub	s3,a1,a2
    80001e8c:	5b7d                	li	s6,-1
    80001e8e:	4685                	li	a3,1
    80001e90:	00998633          	add	a2,s3,s1
    80001e94:	85a6                	mv	a1,s1
    80001e96:	050ab503          	ld	a0,80(s5)
    80001e9a:	c05fe0ef          	jal	80000a9e <copyin>
    80001e9e:	03650463          	beq	a0,s6,80001ec6 <read_string+0x68>
      break;
    }
    if(buf[n] == '\0'){
    80001ea2:	0004c783          	lbu	a5,0(s1)
    80001ea6:	c385                	beqz	a5,80001ec6 <read_string+0x68>
      break;
    }
    n++;
    80001ea8:	2905                	addiw	s2,s2,1
  while(n < max) {
    80001eaa:	0485                	addi	s1,s1,1
    80001eac:	ff2a11e3          	bne	s4,s2,80001e8e <read_string+0x30>
    80001eb0:	8952                	mv	s2,s4
    80001eb2:	74e2                	ld	s1,56(sp)
    80001eb4:	79a2                	ld	s3,40(sp)
    80001eb6:	6b42                	ld	s6,16(sp)
  }
  if(n < max){
    buf[n] = '\0';
  } else {
    buf[max-1] = '\0';
    80001eb8:	9bd2                	add	s7,s7,s4
    80001eba:	fe0b8fa3          	sb	zero,-1(s7)
    80001ebe:	7a02                	ld	s4,32(sp)
    80001ec0:	6ae2                	ld	s5,24(sp)
    80001ec2:	6ba2                	ld	s7,8(sp)
    80001ec4:	a821                	j	80001edc <read_string+0x7e>
  if(n < max){
    80001ec6:	03495363          	bge	s2,s4,80001eec <read_string+0x8e>
    buf[n] = '\0';
    80001eca:	9bca                	add	s7,s7,s2
    80001ecc:	000b8023          	sb	zero,0(s7)
    80001ed0:	74e2                	ld	s1,56(sp)
    80001ed2:	79a2                	ld	s3,40(sp)
    80001ed4:	7a02                	ld	s4,32(sp)
    80001ed6:	6ae2                	ld	s5,24(sp)
    80001ed8:	6b42                	ld	s6,16(sp)
    80001eda:	6ba2                	ld	s7,8(sp)
  } 
  return n;
}
    80001edc:	854a                	mv	a0,s2
    80001ede:	60a6                	ld	ra,72(sp)
    80001ee0:	6406                	ld	s0,64(sp)
    80001ee2:	7942                	ld	s2,48(sp)
    80001ee4:	6161                	addi	sp,sp,80
    80001ee6:	8082                	ret
  int n = 0;
    80001ee8:	4901                	li	s2,0
    80001eea:	b7f9                	j	80001eb8 <read_string+0x5a>
    80001eec:	74e2                	ld	s1,56(sp)
    80001eee:	79a2                	ld	s3,40(sp)
    80001ef0:	6b42                	ld	s6,16(sp)
    80001ef2:	b7d9                	j	80001eb8 <read_string+0x5a>
    return -1; }
    80001ef4:	597d                	li	s2,-1
    80001ef6:	b7dd                	j	80001edc <read_string+0x7e>

0000000080001ef8 <read_memory>:

////////////////////////////////////////////////////////////////////////////////////////////////////
// Read arbitrary memory from user space
int read_memory(struct proc *p, uint64 addr, char *buf, int n) {
    80001ef8:	87ae                	mv	a5,a1

  if(addr >= p->sz || addr + n > p->sz)
    80001efa:	6538                	ld	a4,72(a0)
    80001efc:	02e5fa63          	bgeu	a1,a4,80001f30 <read_memory+0x38>
int read_memory(struct proc *p, uint64 addr, char *buf, int n) {
    80001f00:	1101                	addi	sp,sp,-32
    80001f02:	ec06                	sd	ra,24(sp)
    80001f04:	e822                	sd	s0,16(sp)
    80001f06:	e426                	sd	s1,8(sp)
    80001f08:	1000                	addi	s0,sp,32
    80001f0a:	85b2                	mv	a1,a2
    80001f0c:	84b6                	mv	s1,a3
  if(addr >= p->sz || addr + n > p->sz)
    80001f0e:	96be                	add	a3,a3,a5
    80001f10:	02d76263          	bltu	a4,a3,80001f34 <read_memory+0x3c>
    return -1;

  if(copyin(p->pagetable, buf, addr, n) == -1)
    80001f14:	86a6                	mv	a3,s1
    80001f16:	863e                	mv	a2,a5
    80001f18:	6928                	ld	a0,80(a0)
    80001f1a:	b85fe0ef          	jal	80000a9e <copyin>
    80001f1e:	57fd                	li	a5,-1
    80001f20:	00f50363          	beq	a0,a5,80001f26 <read_memory+0x2e>
    return -1;

  return n;
    80001f24:	8526                	mv	a0,s1
}
    80001f26:	60e2                	ld	ra,24(sp)
    80001f28:	6442                	ld	s0,16(sp)
    80001f2a:	64a2                	ld	s1,8(sp)
    80001f2c:	6105                	addi	sp,sp,32
    80001f2e:	8082                	ret
    return -1;
    80001f30:	557d                	li	a0,-1
}
    80001f32:	8082                	ret
    return -1;
    80001f34:	557d                	li	a0,-1
    80001f36:	bfc5                	j	80001f26 <read_memory+0x2e>

0000000080001f38 <print_syscall>:

//////////////////////////////////////////////////////////////


// Print system call details (enhanced for open's mode)
void print_syscall(struct proc *p, int num, uint64 args[], uint64 ret) {
    80001f38:	7119                	addi	sp,sp,-128
    80001f3a:	fc86                	sd	ra,120(sp)
    80001f3c:	f8a2                	sd	s0,112(sp)
    80001f3e:	f4a6                	sd	s1,104(sp)
    80001f40:	0100                	addi	s0,sp,128
    80001f42:	84ae                	mv	s1,a1
    80001f44:	f8d43423          	sd	a3,-120(s0)
  if (p->trace_mask & (1 << num)) {
    80001f48:	16852783          	lw	a5,360(a0)
    80001f4c:	40b7d7bb          	sraw	a5,a5,a1
    80001f50:	8b85                	andi	a5,a5,1
    80001f52:	0e078463          	beqz	a5,8000203a <print_syscall+0x102>
    80001f56:	f0ca                	sd	s2,96(sp)
    80001f58:	ecce                	sd	s3,88(sp)
    80001f5a:	e8d2                	sd	s4,80(sp)
    80001f5c:	e4d6                	sd	s5,72(sp)
    80001f5e:	e0da                	sd	s6,64(sp)
    80001f60:	fc5e                	sd	s7,56(sp)
    80001f62:	f862                	sd	s8,48(sp)
    80001f64:	f466                	sd	s9,40(sp)
    80001f66:	f06a                	sd	s10,32(sp)
    80001f68:	ec6e                	sd	s11,24(sp)
    80001f6a:	8932                	mv	s2,a2
    printf("1: %s(", syscall_names[num] ? syscall_names[num] : "unknown");
    80001f6c:	00359713          	slli	a4,a1,0x3
    80001f70:	00006797          	auipc	a5,0x6
    80001f74:	9e878793          	addi	a5,a5,-1560 # 80007958 <syscall_names>
    80001f78:	97ba                	add	a5,a5,a4
    80001f7a:	638c                	ld	a1,0(a5)
    80001f7c:	cd8d                	beqz	a1,80001fb6 <print_syscall+0x7e>
    80001f7e:	00005517          	auipc	a0,0x5
    80001f82:	4ea50513          	addi	a0,a0,1258 # 80007468 <etext+0x468>
    80001f86:	5da030ef          	jal	80005560 <printf>
    for (int i = 0; i < 3 && argtypes[num][i]; i++) {
    80001f8a:	00149b13          	slli	s6,s1,0x1
    80001f8e:	9b26                	add	s6,s6,s1
    printf("1: %s(", syscall_names[num] ? syscall_names[num] : "unknown");
    80001f90:	4981                	li	s3,0
    for (int i = 0; i < 3 && argtypes[num][i]; i++) {
    80001f92:	00006b97          	auipc	s7,0x6
    80001f96:	b76b8b93          	addi	s7,s7,-1162 # 80007b08 <argtypes>
      if (i > 0) printf(", ");
    80001f9a:	00005d97          	auipc	s11,0x5
    80001f9e:	4d6d8d93          	addi	s11,s11,1238 # 80007470 <etext+0x470>
      if (argtypes[num][i] == 'i') printf("%d", (int)args[i]);
    80001fa2:	06900c93          	li	s9,105
      else if (argtypes[num][i] == 'a') printf("0x%lx", args[i]);
    80001fa6:	06100d13          	li	s10,97
      else printf("?");
    80001faa:	00005a97          	auipc	s5,0x5
    80001fae:	4dea8a93          	addi	s5,s5,1246 # 80007488 <etext+0x488>
    for (int i = 0; i < 3 && argtypes[num][i]; i++) {
    80001fb2:	4c0d                	li	s8,3
    80001fb4:	a81d                	j	80001fea <print_syscall+0xb2>
    printf("1: %s(", syscall_names[num] ? syscall_names[num] : "unknown");
    80001fb6:	00005597          	auipc	a1,0x5
    80001fba:	40258593          	addi	a1,a1,1026 # 800073b8 <etext+0x3b8>
    80001fbe:	b7c1                	j	80001f7e <print_syscall+0x46>
      if (argtypes[num][i] == 'i') printf("%d", (int)args[i]);
    80001fc0:	00092583          	lw	a1,0(s2)
    80001fc4:	00005517          	auipc	a0,0x5
    80001fc8:	4b450513          	addi	a0,a0,1204 # 80007478 <etext+0x478>
    80001fcc:	594030ef          	jal	80005560 <printf>
    80001fd0:	a809                	j	80001fe2 <print_syscall+0xaa>
      else if (argtypes[num][i] == 'a') printf("0x%lx", args[i]);
    80001fd2:	00093583          	ld	a1,0(s2)
    80001fd6:	00005517          	auipc	a0,0x5
    80001fda:	4aa50513          	addi	a0,a0,1194 # 80007480 <etext+0x480>
    80001fde:	582030ef          	jal	80005560 <printf>
    for (int i = 0; i < 3 && argtypes[num][i]; i++) {
    80001fe2:	0985                	addi	s3,s3,1
    80001fe4:	0921                	addi	s2,s2,8
    80001fe6:	03898863          	beq	s3,s8,80002016 <print_syscall+0xde>
    80001fea:	016987b3          	add	a5,s3,s6
    80001fee:	97de                	add	a5,a5,s7
    80001ff0:	0007ca03          	lbu	s4,0(a5)
    80001ff4:	020a0163          	beqz	s4,80002016 <print_syscall+0xde>
      if (i > 0) printf(", ");
    80001ff8:	0009879b          	sext.w	a5,s3
    80001ffc:	00f05563          	blez	a5,80002006 <print_syscall+0xce>
    80002000:	856e                	mv	a0,s11
    80002002:	55e030ef          	jal	80005560 <printf>
      if (argtypes[num][i] == 'i') printf("%d", (int)args[i]);
    80002006:	fb9a0de3          	beq	s4,s9,80001fc0 <print_syscall+0x88>
      else if (argtypes[num][i] == 'a') printf("0x%lx", args[i]);
    8000200a:	fdaa04e3          	beq	s4,s10,80001fd2 <print_syscall+0x9a>
      else printf("?");
    8000200e:	8556                	mv	a0,s5
    80002010:	550030ef          	jal	80005560 <printf>
    80002014:	b7f9                	j	80001fe2 <print_syscall+0xaa>
    }
    printf(") = %ld\n", ret);
    80002016:	f8843583          	ld	a1,-120(s0)
    8000201a:	00005517          	auipc	a0,0x5
    8000201e:	47650513          	addi	a0,a0,1142 # 80007490 <etext+0x490>
    80002022:	53e030ef          	jal	80005560 <printf>
    80002026:	7906                	ld	s2,96(sp)
    80002028:	69e6                	ld	s3,88(sp)
    8000202a:	6a46                	ld	s4,80(sp)
    8000202c:	6aa6                	ld	s5,72(sp)
    8000202e:	6b06                	ld	s6,64(sp)
    80002030:	7be2                	ld	s7,56(sp)
    80002032:	7c42                	ld	s8,48(sp)
    80002034:	7ca2                	ld	s9,40(sp)
    80002036:	7d02                	ld	s10,32(sp)
    80002038:	6de2                	ld	s11,24(sp)
  }
  syscall_counts[num]++;
    8000203a:	048a                	slli	s1,s1,0x2
    8000203c:	0000e797          	auipc	a5,0xe
    80002040:	71c78793          	addi	a5,a5,1820 # 80010758 <syscall_counts>
    80002044:	97a6                	add	a5,a5,s1
    80002046:	4398                	lw	a4,0(a5)
    80002048:	2705                	addiw	a4,a4,1
    8000204a:	c398                	sw	a4,0(a5)
}
    8000204c:	70e6                	ld	ra,120(sp)
    8000204e:	7446                	ld	s0,112(sp)
    80002050:	74a6                	ld	s1,104(sp)
    80002052:	6109                	addi	sp,sp,128
    80002054:	8082                	ret

0000000080002056 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002056:	1101                	addi	sp,sp,-32
    80002058:	ec06                	sd	ra,24(sp)
    8000205a:	e822                	sd	s0,16(sp)
    8000205c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000205e:	fec40593          	addi	a1,s0,-20
    80002062:	4501                	li	a0,0
    80002064:	ca1ff0ef          	jal	80001d04 <argint>
  exit(n);
    80002068:	fec42503          	lw	a0,-20(s0)
    8000206c:	bd0ff0ef          	jal	8000143c <exit>
  return 0;  // not reached
}
    80002070:	4501                	li	a0,0
    80002072:	60e2                	ld	ra,24(sp)
    80002074:	6442                	ld	s0,16(sp)
    80002076:	6105                	addi	sp,sp,32
    80002078:	8082                	ret

000000008000207a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000207a:	1141                	addi	sp,sp,-16
    8000207c:	e406                	sd	ra,8(sp)
    8000207e:	e022                	sd	s0,0(sp)
    80002080:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002082:	cd5fe0ef          	jal	80000d56 <myproc>
}
    80002086:	5908                	lw	a0,48(a0)
    80002088:	60a2                	ld	ra,8(sp)
    8000208a:	6402                	ld	s0,0(sp)
    8000208c:	0141                	addi	sp,sp,16
    8000208e:	8082                	ret

0000000080002090 <sys_fork>:

uint64
sys_fork(void)
{
    80002090:	1141                	addi	sp,sp,-16
    80002092:	e406                	sd	ra,8(sp)
    80002094:	e022                	sd	s0,0(sp)
    80002096:	0800                	addi	s0,sp,16
  return fork();
    80002098:	fe9fe0ef          	jal	80001080 <fork>
}
    8000209c:	60a2                	ld	ra,8(sp)
    8000209e:	6402                	ld	s0,0(sp)
    800020a0:	0141                	addi	sp,sp,16
    800020a2:	8082                	ret

00000000800020a4 <sys_wait>:

uint64
sys_wait(void)
{
    800020a4:	1101                	addi	sp,sp,-32
    800020a6:	ec06                	sd	ra,24(sp)
    800020a8:	e822                	sd	s0,16(sp)
    800020aa:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800020ac:	fe840593          	addi	a1,s0,-24
    800020b0:	4501                	li	a0,0
    800020b2:	cf5ff0ef          	jal	80001da6 <argaddr>
  return wait(p);
    800020b6:	fe843503          	ld	a0,-24(s0)
    800020ba:	cd8ff0ef          	jal	80001592 <wait>
}
    800020be:	60e2                	ld	ra,24(sp)
    800020c0:	6442                	ld	s0,16(sp)
    800020c2:	6105                	addi	sp,sp,32
    800020c4:	8082                	ret

00000000800020c6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020c6:	7179                	addi	sp,sp,-48
    800020c8:	f406                	sd	ra,40(sp)
    800020ca:	f022                	sd	s0,32(sp)
    800020cc:	ec26                	sd	s1,24(sp)
    800020ce:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800020d0:	fdc40593          	addi	a1,s0,-36
    800020d4:	4501                	li	a0,0
    800020d6:	c2fff0ef          	jal	80001d04 <argint>
  addr = myproc()->sz;
    800020da:	c7dfe0ef          	jal	80000d56 <myproc>
    800020de:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800020e0:	fdc42503          	lw	a0,-36(s0)
    800020e4:	f4dfe0ef          	jal	80001030 <growproc>
    800020e8:	00054863          	bltz	a0,800020f8 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    800020ec:	8526                	mv	a0,s1
    800020ee:	70a2                	ld	ra,40(sp)
    800020f0:	7402                	ld	s0,32(sp)
    800020f2:	64e2                	ld	s1,24(sp)
    800020f4:	6145                	addi	sp,sp,48
    800020f6:	8082                	ret
    return -1;
    800020f8:	54fd                	li	s1,-1
    800020fa:	bfcd                	j	800020ec <sys_sbrk+0x26>

00000000800020fc <sys_sleep>:

uint64
sys_sleep(void)
{
    800020fc:	7139                	addi	sp,sp,-64
    800020fe:	fc06                	sd	ra,56(sp)
    80002100:	f822                	sd	s0,48(sp)
    80002102:	f04a                	sd	s2,32(sp)
    80002104:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002106:	fcc40593          	addi	a1,s0,-52
    8000210a:	4501                	li	a0,0
    8000210c:	bf9ff0ef          	jal	80001d04 <argint>
  if(n < 0)
    80002110:	fcc42783          	lw	a5,-52(s0)
    80002114:	0607c763          	bltz	a5,80002182 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002118:	0000e517          	auipc	a0,0xe
    8000211c:	62850513          	addi	a0,a0,1576 # 80010740 <tickslock>
    80002120:	241030ef          	jal	80005b60 <acquire>
  ticks0 = ticks;
    80002124:	00008917          	auipc	s2,0x8
    80002128:	5b492903          	lw	s2,1460(s2) # 8000a6d8 <ticks>
  while(ticks - ticks0 < n){
    8000212c:	fcc42783          	lw	a5,-52(s0)
    80002130:	cf8d                	beqz	a5,8000216a <sys_sleep+0x6e>
    80002132:	f426                	sd	s1,40(sp)
    80002134:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002136:	0000e997          	auipc	s3,0xe
    8000213a:	60a98993          	addi	s3,s3,1546 # 80010740 <tickslock>
    8000213e:	00008497          	auipc	s1,0x8
    80002142:	59a48493          	addi	s1,s1,1434 # 8000a6d8 <ticks>
    if(killed(myproc())){
    80002146:	c11fe0ef          	jal	80000d56 <myproc>
    8000214a:	c1eff0ef          	jal	80001568 <killed>
    8000214e:	ed0d                	bnez	a0,80002188 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002150:	85ce                	mv	a1,s3
    80002152:	8526                	mv	a0,s1
    80002154:	9dcff0ef          	jal	80001330 <sleep>
  while(ticks - ticks0 < n){
    80002158:	409c                	lw	a5,0(s1)
    8000215a:	412787bb          	subw	a5,a5,s2
    8000215e:	fcc42703          	lw	a4,-52(s0)
    80002162:	fee7e2e3          	bltu	a5,a4,80002146 <sys_sleep+0x4a>
    80002166:	74a2                	ld	s1,40(sp)
    80002168:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000216a:	0000e517          	auipc	a0,0xe
    8000216e:	5d650513          	addi	a0,a0,1494 # 80010740 <tickslock>
    80002172:	287030ef          	jal	80005bf8 <release>
  return 0;
    80002176:	4501                	li	a0,0
}
    80002178:	70e2                	ld	ra,56(sp)
    8000217a:	7442                	ld	s0,48(sp)
    8000217c:	7902                	ld	s2,32(sp)
    8000217e:	6121                	addi	sp,sp,64
    80002180:	8082                	ret
    n = 0;
    80002182:	fc042623          	sw	zero,-52(s0)
    80002186:	bf49                	j	80002118 <sys_sleep+0x1c>
      release(&tickslock);
    80002188:	0000e517          	auipc	a0,0xe
    8000218c:	5b850513          	addi	a0,a0,1464 # 80010740 <tickslock>
    80002190:	269030ef          	jal	80005bf8 <release>
      return -1;
    80002194:	557d                	li	a0,-1
    80002196:	74a2                	ld	s1,40(sp)
    80002198:	69e2                	ld	s3,24(sp)
    8000219a:	bff9                	j	80002178 <sys_sleep+0x7c>

000000008000219c <sys_kill>:

uint64
sys_kill(void)
{
    8000219c:	1101                	addi	sp,sp,-32
    8000219e:	ec06                	sd	ra,24(sp)
    800021a0:	e822                	sd	s0,16(sp)
    800021a2:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800021a4:	fec40593          	addi	a1,s0,-20
    800021a8:	4501                	li	a0,0
    800021aa:	b5bff0ef          	jal	80001d04 <argint>
  return kill(pid);
    800021ae:	fec42503          	lw	a0,-20(s0)
    800021b2:	b2cff0ef          	jal	800014de <kill>
}
    800021b6:	60e2                	ld	ra,24(sp)
    800021b8:	6442                	ld	s0,16(sp)
    800021ba:	6105                	addi	sp,sp,32
    800021bc:	8082                	ret

00000000800021be <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021be:	1101                	addi	sp,sp,-32
    800021c0:	ec06                	sd	ra,24(sp)
    800021c2:	e822                	sd	s0,16(sp)
    800021c4:	e426                	sd	s1,8(sp)
    800021c6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021c8:	0000e517          	auipc	a0,0xe
    800021cc:	57850513          	addi	a0,a0,1400 # 80010740 <tickslock>
    800021d0:	191030ef          	jal	80005b60 <acquire>
  xticks = ticks;
    800021d4:	00008497          	auipc	s1,0x8
    800021d8:	5044a483          	lw	s1,1284(s1) # 8000a6d8 <ticks>
  release(&tickslock);
    800021dc:	0000e517          	auipc	a0,0xe
    800021e0:	56450513          	addi	a0,a0,1380 # 80010740 <tickslock>
    800021e4:	215030ef          	jal	80005bf8 <release>
  return xticks;
}
    800021e8:	02049513          	slli	a0,s1,0x20
    800021ec:	9101                	srli	a0,a0,0x20
    800021ee:	60e2                	ld	ra,24(sp)
    800021f0:	6442                	ld	s0,16(sp)
    800021f2:	64a2                	ld	s1,8(sp)
    800021f4:	6105                	addi	sp,sp,32
    800021f6:	8082                	ret

00000000800021f8 <sys_trace>:

/////////////////////////////////////////////////////////////

uint64
sys_trace(void)
{
    800021f8:	1101                	addi	sp,sp,-32
    800021fa:	ec06                	sd	ra,24(sp)
    800021fc:	e822                	sd	s0,16(sp)
    800021fe:	1000                	addi	s0,sp,32
  int mask;
  argint(0, &mask);                       // Fetch the trace mask argument
    80002200:	fec40593          	addi	a1,s0,-20
    80002204:	4501                	li	a0,0
    80002206:	affff0ef          	jal	80001d04 <argint>
  struct proc *p = myproc();
    8000220a:	b4dfe0ef          	jal	80000d56 <myproc>
  p->trace_mask = mask;
    8000220e:	fec42783          	lw	a5,-20(s0)
    80002212:	16f52423          	sw	a5,360(a0)
  return 0;
}
    80002216:	4501                	li	a0,0
    80002218:	60e2                	ld	ra,24(sp)
    8000221a:	6442                	ld	s0,16(sp)
    8000221c:	6105                	addi	sp,sp,32
    8000221e:	8082                	ret

0000000080002220 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002220:	7179                	addi	sp,sp,-48
    80002222:	f406                	sd	ra,40(sp)
    80002224:	f022                	sd	s0,32(sp)
    80002226:	ec26                	sd	s1,24(sp)
    80002228:	e84a                	sd	s2,16(sp)
    8000222a:	e44e                	sd	s3,8(sp)
    8000222c:	e052                	sd	s4,0(sp)
    8000222e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002230:	00005597          	auipc	a1,0x5
    80002234:	33858593          	addi	a1,a1,824 # 80007568 <etext+0x568>
    80002238:	0000e517          	auipc	a0,0xe
    8000223c:	59050513          	addi	a0,a0,1424 # 800107c8 <bcache>
    80002240:	0a1030ef          	jal	80005ae0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002244:	00016797          	auipc	a5,0x16
    80002248:	58478793          	addi	a5,a5,1412 # 800187c8 <bcache+0x8000>
    8000224c:	00016717          	auipc	a4,0x16
    80002250:	7e470713          	addi	a4,a4,2020 # 80018a30 <bcache+0x8268>
    80002254:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002258:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000225c:	0000e497          	auipc	s1,0xe
    80002260:	58448493          	addi	s1,s1,1412 # 800107e0 <bcache+0x18>
    b->next = bcache.head.next;
    80002264:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002266:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002268:	00005a17          	auipc	s4,0x5
    8000226c:	308a0a13          	addi	s4,s4,776 # 80007570 <etext+0x570>
    b->next = bcache.head.next;
    80002270:	2b893783          	ld	a5,696(s2)
    80002274:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002276:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000227a:	85d2                	mv	a1,s4
    8000227c:	01048513          	addi	a0,s1,16
    80002280:	248010ef          	jal	800034c8 <initsleeplock>
    bcache.head.next->prev = b;
    80002284:	2b893783          	ld	a5,696(s2)
    80002288:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000228a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000228e:	45848493          	addi	s1,s1,1112
    80002292:	fd349fe3          	bne	s1,s3,80002270 <binit+0x50>
  }
}
    80002296:	70a2                	ld	ra,40(sp)
    80002298:	7402                	ld	s0,32(sp)
    8000229a:	64e2                	ld	s1,24(sp)
    8000229c:	6942                	ld	s2,16(sp)
    8000229e:	69a2                	ld	s3,8(sp)
    800022a0:	6a02                	ld	s4,0(sp)
    800022a2:	6145                	addi	sp,sp,48
    800022a4:	8082                	ret

00000000800022a6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022a6:	7179                	addi	sp,sp,-48
    800022a8:	f406                	sd	ra,40(sp)
    800022aa:	f022                	sd	s0,32(sp)
    800022ac:	ec26                	sd	s1,24(sp)
    800022ae:	e84a                	sd	s2,16(sp)
    800022b0:	e44e                	sd	s3,8(sp)
    800022b2:	1800                	addi	s0,sp,48
    800022b4:	892a                	mv	s2,a0
    800022b6:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022b8:	0000e517          	auipc	a0,0xe
    800022bc:	51050513          	addi	a0,a0,1296 # 800107c8 <bcache>
    800022c0:	0a1030ef          	jal	80005b60 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022c4:	00016497          	auipc	s1,0x16
    800022c8:	7bc4b483          	ld	s1,1980(s1) # 80018a80 <bcache+0x82b8>
    800022cc:	00016797          	auipc	a5,0x16
    800022d0:	76478793          	addi	a5,a5,1892 # 80018a30 <bcache+0x8268>
    800022d4:	02f48b63          	beq	s1,a5,8000230a <bread+0x64>
    800022d8:	873e                	mv	a4,a5
    800022da:	a021                	j	800022e2 <bread+0x3c>
    800022dc:	68a4                	ld	s1,80(s1)
    800022de:	02e48663          	beq	s1,a4,8000230a <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    800022e2:	449c                	lw	a5,8(s1)
    800022e4:	ff279ce3          	bne	a5,s2,800022dc <bread+0x36>
    800022e8:	44dc                	lw	a5,12(s1)
    800022ea:	ff3799e3          	bne	a5,s3,800022dc <bread+0x36>
      b->refcnt++;
    800022ee:	40bc                	lw	a5,64(s1)
    800022f0:	2785                	addiw	a5,a5,1
    800022f2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800022f4:	0000e517          	auipc	a0,0xe
    800022f8:	4d450513          	addi	a0,a0,1236 # 800107c8 <bcache>
    800022fc:	0fd030ef          	jal	80005bf8 <release>
      acquiresleep(&b->lock);
    80002300:	01048513          	addi	a0,s1,16
    80002304:	1fa010ef          	jal	800034fe <acquiresleep>
      return b;
    80002308:	a889                	j	8000235a <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000230a:	00016497          	auipc	s1,0x16
    8000230e:	76e4b483          	ld	s1,1902(s1) # 80018a78 <bcache+0x82b0>
    80002312:	00016797          	auipc	a5,0x16
    80002316:	71e78793          	addi	a5,a5,1822 # 80018a30 <bcache+0x8268>
    8000231a:	00f48863          	beq	s1,a5,8000232a <bread+0x84>
    8000231e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002320:	40bc                	lw	a5,64(s1)
    80002322:	cb91                	beqz	a5,80002336 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002324:	64a4                	ld	s1,72(s1)
    80002326:	fee49de3          	bne	s1,a4,80002320 <bread+0x7a>
  panic("bget: no buffers");
    8000232a:	00005517          	auipc	a0,0x5
    8000232e:	24e50513          	addi	a0,a0,590 # 80007578 <etext+0x578>
    80002332:	500030ef          	jal	80005832 <panic>
      b->dev = dev;
    80002336:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000233a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000233e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002342:	4785                	li	a5,1
    80002344:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002346:	0000e517          	auipc	a0,0xe
    8000234a:	48250513          	addi	a0,a0,1154 # 800107c8 <bcache>
    8000234e:	0ab030ef          	jal	80005bf8 <release>
      acquiresleep(&b->lock);
    80002352:	01048513          	addi	a0,s1,16
    80002356:	1a8010ef          	jal	800034fe <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000235a:	409c                	lw	a5,0(s1)
    8000235c:	cb89                	beqz	a5,8000236e <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000235e:	8526                	mv	a0,s1
    80002360:	70a2                	ld	ra,40(sp)
    80002362:	7402                	ld	s0,32(sp)
    80002364:	64e2                	ld	s1,24(sp)
    80002366:	6942                	ld	s2,16(sp)
    80002368:	69a2                	ld	s3,8(sp)
    8000236a:	6145                	addi	sp,sp,48
    8000236c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000236e:	4581                	li	a1,0
    80002370:	8526                	mv	a0,s1
    80002372:	28f020ef          	jal	80004e00 <virtio_disk_rw>
    b->valid = 1;
    80002376:	4785                	li	a5,1
    80002378:	c09c                	sw	a5,0(s1)
  return b;
    8000237a:	b7d5                	j	8000235e <bread+0xb8>

000000008000237c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000237c:	1101                	addi	sp,sp,-32
    8000237e:	ec06                	sd	ra,24(sp)
    80002380:	e822                	sd	s0,16(sp)
    80002382:	e426                	sd	s1,8(sp)
    80002384:	1000                	addi	s0,sp,32
    80002386:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002388:	0541                	addi	a0,a0,16
    8000238a:	1f2010ef          	jal	8000357c <holdingsleep>
    8000238e:	c911                	beqz	a0,800023a2 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002390:	4585                	li	a1,1
    80002392:	8526                	mv	a0,s1
    80002394:	26d020ef          	jal	80004e00 <virtio_disk_rw>
}
    80002398:	60e2                	ld	ra,24(sp)
    8000239a:	6442                	ld	s0,16(sp)
    8000239c:	64a2                	ld	s1,8(sp)
    8000239e:	6105                	addi	sp,sp,32
    800023a0:	8082                	ret
    panic("bwrite");
    800023a2:	00005517          	auipc	a0,0x5
    800023a6:	1ee50513          	addi	a0,a0,494 # 80007590 <etext+0x590>
    800023aa:	488030ef          	jal	80005832 <panic>

00000000800023ae <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800023ae:	1101                	addi	sp,sp,-32
    800023b0:	ec06                	sd	ra,24(sp)
    800023b2:	e822                	sd	s0,16(sp)
    800023b4:	e426                	sd	s1,8(sp)
    800023b6:	e04a                	sd	s2,0(sp)
    800023b8:	1000                	addi	s0,sp,32
    800023ba:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023bc:	01050913          	addi	s2,a0,16
    800023c0:	854a                	mv	a0,s2
    800023c2:	1ba010ef          	jal	8000357c <holdingsleep>
    800023c6:	c135                	beqz	a0,8000242a <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    800023c8:	854a                	mv	a0,s2
    800023ca:	17a010ef          	jal	80003544 <releasesleep>

  acquire(&bcache.lock);
    800023ce:	0000e517          	auipc	a0,0xe
    800023d2:	3fa50513          	addi	a0,a0,1018 # 800107c8 <bcache>
    800023d6:	78a030ef          	jal	80005b60 <acquire>
  b->refcnt--;
    800023da:	40bc                	lw	a5,64(s1)
    800023dc:	37fd                	addiw	a5,a5,-1
    800023de:	0007871b          	sext.w	a4,a5
    800023e2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800023e4:	e71d                	bnez	a4,80002412 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800023e6:	68b8                	ld	a4,80(s1)
    800023e8:	64bc                	ld	a5,72(s1)
    800023ea:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800023ec:	68b8                	ld	a4,80(s1)
    800023ee:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800023f0:	00016797          	auipc	a5,0x16
    800023f4:	3d878793          	addi	a5,a5,984 # 800187c8 <bcache+0x8000>
    800023f8:	2b87b703          	ld	a4,696(a5)
    800023fc:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800023fe:	00016717          	auipc	a4,0x16
    80002402:	63270713          	addi	a4,a4,1586 # 80018a30 <bcache+0x8268>
    80002406:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002408:	2b87b703          	ld	a4,696(a5)
    8000240c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000240e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002412:	0000e517          	auipc	a0,0xe
    80002416:	3b650513          	addi	a0,a0,950 # 800107c8 <bcache>
    8000241a:	7de030ef          	jal	80005bf8 <release>
}
    8000241e:	60e2                	ld	ra,24(sp)
    80002420:	6442                	ld	s0,16(sp)
    80002422:	64a2                	ld	s1,8(sp)
    80002424:	6902                	ld	s2,0(sp)
    80002426:	6105                	addi	sp,sp,32
    80002428:	8082                	ret
    panic("brelse");
    8000242a:	00005517          	auipc	a0,0x5
    8000242e:	16e50513          	addi	a0,a0,366 # 80007598 <etext+0x598>
    80002432:	400030ef          	jal	80005832 <panic>

0000000080002436 <bpin>:

void
bpin(struct buf *b) {
    80002436:	1101                	addi	sp,sp,-32
    80002438:	ec06                	sd	ra,24(sp)
    8000243a:	e822                	sd	s0,16(sp)
    8000243c:	e426                	sd	s1,8(sp)
    8000243e:	1000                	addi	s0,sp,32
    80002440:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002442:	0000e517          	auipc	a0,0xe
    80002446:	38650513          	addi	a0,a0,902 # 800107c8 <bcache>
    8000244a:	716030ef          	jal	80005b60 <acquire>
  b->refcnt++;
    8000244e:	40bc                	lw	a5,64(s1)
    80002450:	2785                	addiw	a5,a5,1
    80002452:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002454:	0000e517          	auipc	a0,0xe
    80002458:	37450513          	addi	a0,a0,884 # 800107c8 <bcache>
    8000245c:	79c030ef          	jal	80005bf8 <release>
}
    80002460:	60e2                	ld	ra,24(sp)
    80002462:	6442                	ld	s0,16(sp)
    80002464:	64a2                	ld	s1,8(sp)
    80002466:	6105                	addi	sp,sp,32
    80002468:	8082                	ret

000000008000246a <bunpin>:

void
bunpin(struct buf *b) {
    8000246a:	1101                	addi	sp,sp,-32
    8000246c:	ec06                	sd	ra,24(sp)
    8000246e:	e822                	sd	s0,16(sp)
    80002470:	e426                	sd	s1,8(sp)
    80002472:	1000                	addi	s0,sp,32
    80002474:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002476:	0000e517          	auipc	a0,0xe
    8000247a:	35250513          	addi	a0,a0,850 # 800107c8 <bcache>
    8000247e:	6e2030ef          	jal	80005b60 <acquire>
  b->refcnt--;
    80002482:	40bc                	lw	a5,64(s1)
    80002484:	37fd                	addiw	a5,a5,-1
    80002486:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002488:	0000e517          	auipc	a0,0xe
    8000248c:	34050513          	addi	a0,a0,832 # 800107c8 <bcache>
    80002490:	768030ef          	jal	80005bf8 <release>
}
    80002494:	60e2                	ld	ra,24(sp)
    80002496:	6442                	ld	s0,16(sp)
    80002498:	64a2                	ld	s1,8(sp)
    8000249a:	6105                	addi	sp,sp,32
    8000249c:	8082                	ret

000000008000249e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000249e:	1101                	addi	sp,sp,-32
    800024a0:	ec06                	sd	ra,24(sp)
    800024a2:	e822                	sd	s0,16(sp)
    800024a4:	e426                	sd	s1,8(sp)
    800024a6:	e04a                	sd	s2,0(sp)
    800024a8:	1000                	addi	s0,sp,32
    800024aa:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800024ac:	00d5d59b          	srliw	a1,a1,0xd
    800024b0:	00017797          	auipc	a5,0x17
    800024b4:	9f47a783          	lw	a5,-1548(a5) # 80018ea4 <sb+0x1c>
    800024b8:	9dbd                	addw	a1,a1,a5
    800024ba:	dedff0ef          	jal	800022a6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800024be:	0074f713          	andi	a4,s1,7
    800024c2:	4785                	li	a5,1
    800024c4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800024c8:	14ce                	slli	s1,s1,0x33
    800024ca:	90d9                	srli	s1,s1,0x36
    800024cc:	00950733          	add	a4,a0,s1
    800024d0:	05874703          	lbu	a4,88(a4)
    800024d4:	00e7f6b3          	and	a3,a5,a4
    800024d8:	c29d                	beqz	a3,800024fe <bfree+0x60>
    800024da:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800024dc:	94aa                	add	s1,s1,a0
    800024de:	fff7c793          	not	a5,a5
    800024e2:	8f7d                	and	a4,a4,a5
    800024e4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800024e8:	711000ef          	jal	800033f8 <log_write>
  brelse(bp);
    800024ec:	854a                	mv	a0,s2
    800024ee:	ec1ff0ef          	jal	800023ae <brelse>
}
    800024f2:	60e2                	ld	ra,24(sp)
    800024f4:	6442                	ld	s0,16(sp)
    800024f6:	64a2                	ld	s1,8(sp)
    800024f8:	6902                	ld	s2,0(sp)
    800024fa:	6105                	addi	sp,sp,32
    800024fc:	8082                	ret
    panic("freeing free block");
    800024fe:	00005517          	auipc	a0,0x5
    80002502:	0a250513          	addi	a0,a0,162 # 800075a0 <etext+0x5a0>
    80002506:	32c030ef          	jal	80005832 <panic>

000000008000250a <balloc>:
{
    8000250a:	711d                	addi	sp,sp,-96
    8000250c:	ec86                	sd	ra,88(sp)
    8000250e:	e8a2                	sd	s0,80(sp)
    80002510:	e4a6                	sd	s1,72(sp)
    80002512:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002514:	00017797          	auipc	a5,0x17
    80002518:	9787a783          	lw	a5,-1672(a5) # 80018e8c <sb+0x4>
    8000251c:	0e078f63          	beqz	a5,8000261a <balloc+0x110>
    80002520:	e0ca                	sd	s2,64(sp)
    80002522:	fc4e                	sd	s3,56(sp)
    80002524:	f852                	sd	s4,48(sp)
    80002526:	f456                	sd	s5,40(sp)
    80002528:	f05a                	sd	s6,32(sp)
    8000252a:	ec5e                	sd	s7,24(sp)
    8000252c:	e862                	sd	s8,16(sp)
    8000252e:	e466                	sd	s9,8(sp)
    80002530:	8baa                	mv	s7,a0
    80002532:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002534:	00017b17          	auipc	s6,0x17
    80002538:	954b0b13          	addi	s6,s6,-1708 # 80018e88 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000253c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000253e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002540:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002542:	6c89                	lui	s9,0x2
    80002544:	a0b5                	j	800025b0 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002546:	97ca                	add	a5,a5,s2
    80002548:	8e55                	or	a2,a2,a3
    8000254a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000254e:	854a                	mv	a0,s2
    80002550:	6a9000ef          	jal	800033f8 <log_write>
        brelse(bp);
    80002554:	854a                	mv	a0,s2
    80002556:	e59ff0ef          	jal	800023ae <brelse>
  bp = bread(dev, bno);
    8000255a:	85a6                	mv	a1,s1
    8000255c:	855e                	mv	a0,s7
    8000255e:	d49ff0ef          	jal	800022a6 <bread>
    80002562:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002564:	40000613          	li	a2,1024
    80002568:	4581                	li	a1,0
    8000256a:	05850513          	addi	a0,a0,88
    8000256e:	bc7fd0ef          	jal	80000134 <memset>
  log_write(bp);
    80002572:	854a                	mv	a0,s2
    80002574:	685000ef          	jal	800033f8 <log_write>
  brelse(bp);
    80002578:	854a                	mv	a0,s2
    8000257a:	e35ff0ef          	jal	800023ae <brelse>
}
    8000257e:	6906                	ld	s2,64(sp)
    80002580:	79e2                	ld	s3,56(sp)
    80002582:	7a42                	ld	s4,48(sp)
    80002584:	7aa2                	ld	s5,40(sp)
    80002586:	7b02                	ld	s6,32(sp)
    80002588:	6be2                	ld	s7,24(sp)
    8000258a:	6c42                	ld	s8,16(sp)
    8000258c:	6ca2                	ld	s9,8(sp)
}
    8000258e:	8526                	mv	a0,s1
    80002590:	60e6                	ld	ra,88(sp)
    80002592:	6446                	ld	s0,80(sp)
    80002594:	64a6                	ld	s1,72(sp)
    80002596:	6125                	addi	sp,sp,96
    80002598:	8082                	ret
    brelse(bp);
    8000259a:	854a                	mv	a0,s2
    8000259c:	e13ff0ef          	jal	800023ae <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800025a0:	015c87bb          	addw	a5,s9,s5
    800025a4:	00078a9b          	sext.w	s5,a5
    800025a8:	004b2703          	lw	a4,4(s6)
    800025ac:	04eaff63          	bgeu	s5,a4,8000260a <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800025b0:	41fad79b          	sraiw	a5,s5,0x1f
    800025b4:	0137d79b          	srliw	a5,a5,0x13
    800025b8:	015787bb          	addw	a5,a5,s5
    800025bc:	40d7d79b          	sraiw	a5,a5,0xd
    800025c0:	01cb2583          	lw	a1,28(s6)
    800025c4:	9dbd                	addw	a1,a1,a5
    800025c6:	855e                	mv	a0,s7
    800025c8:	cdfff0ef          	jal	800022a6 <bread>
    800025cc:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025ce:	004b2503          	lw	a0,4(s6)
    800025d2:	000a849b          	sext.w	s1,s5
    800025d6:	8762                	mv	a4,s8
    800025d8:	fca4f1e3          	bgeu	s1,a0,8000259a <balloc+0x90>
      m = 1 << (bi % 8);
    800025dc:	00777693          	andi	a3,a4,7
    800025e0:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800025e4:	41f7579b          	sraiw	a5,a4,0x1f
    800025e8:	01d7d79b          	srliw	a5,a5,0x1d
    800025ec:	9fb9                	addw	a5,a5,a4
    800025ee:	4037d79b          	sraiw	a5,a5,0x3
    800025f2:	00f90633          	add	a2,s2,a5
    800025f6:	05864603          	lbu	a2,88(a2)
    800025fa:	00c6f5b3          	and	a1,a3,a2
    800025fe:	d5a1                	beqz	a1,80002546 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002600:	2705                	addiw	a4,a4,1
    80002602:	2485                	addiw	s1,s1,1
    80002604:	fd471ae3          	bne	a4,s4,800025d8 <balloc+0xce>
    80002608:	bf49                	j	8000259a <balloc+0x90>
    8000260a:	6906                	ld	s2,64(sp)
    8000260c:	79e2                	ld	s3,56(sp)
    8000260e:	7a42                	ld	s4,48(sp)
    80002610:	7aa2                	ld	s5,40(sp)
    80002612:	7b02                	ld	s6,32(sp)
    80002614:	6be2                	ld	s7,24(sp)
    80002616:	6c42                	ld	s8,16(sp)
    80002618:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000261a:	00005517          	auipc	a0,0x5
    8000261e:	f9e50513          	addi	a0,a0,-98 # 800075b8 <etext+0x5b8>
    80002622:	73f020ef          	jal	80005560 <printf>
  return 0;
    80002626:	4481                	li	s1,0
    80002628:	b79d                	j	8000258e <balloc+0x84>

000000008000262a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000262a:	7179                	addi	sp,sp,-48
    8000262c:	f406                	sd	ra,40(sp)
    8000262e:	f022                	sd	s0,32(sp)
    80002630:	ec26                	sd	s1,24(sp)
    80002632:	e84a                	sd	s2,16(sp)
    80002634:	e44e                	sd	s3,8(sp)
    80002636:	1800                	addi	s0,sp,48
    80002638:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000263a:	47ad                	li	a5,11
    8000263c:	02b7e663          	bltu	a5,a1,80002668 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002640:	02059793          	slli	a5,a1,0x20
    80002644:	01e7d593          	srli	a1,a5,0x1e
    80002648:	00b504b3          	add	s1,a0,a1
    8000264c:	0504a903          	lw	s2,80(s1)
    80002650:	06091a63          	bnez	s2,800026c4 <bmap+0x9a>
      addr = balloc(ip->dev);
    80002654:	4108                	lw	a0,0(a0)
    80002656:	eb5ff0ef          	jal	8000250a <balloc>
    8000265a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000265e:	06090363          	beqz	s2,800026c4 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002662:	0524a823          	sw	s2,80(s1)
    80002666:	a8b9                	j	800026c4 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002668:	ff45849b          	addiw	s1,a1,-12
    8000266c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002670:	0ff00793          	li	a5,255
    80002674:	06e7ee63          	bltu	a5,a4,800026f0 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002678:	08052903          	lw	s2,128(a0)
    8000267c:	00091d63          	bnez	s2,80002696 <bmap+0x6c>
      addr = balloc(ip->dev);
    80002680:	4108                	lw	a0,0(a0)
    80002682:	e89ff0ef          	jal	8000250a <balloc>
    80002686:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000268a:	02090d63          	beqz	s2,800026c4 <bmap+0x9a>
    8000268e:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002690:	0929a023          	sw	s2,128(s3)
    80002694:	a011                	j	80002698 <bmap+0x6e>
    80002696:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002698:	85ca                	mv	a1,s2
    8000269a:	0009a503          	lw	a0,0(s3)
    8000269e:	c09ff0ef          	jal	800022a6 <bread>
    800026a2:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800026a4:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800026a8:	02049713          	slli	a4,s1,0x20
    800026ac:	01e75593          	srli	a1,a4,0x1e
    800026b0:	00b784b3          	add	s1,a5,a1
    800026b4:	0004a903          	lw	s2,0(s1)
    800026b8:	00090e63          	beqz	s2,800026d4 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800026bc:	8552                	mv	a0,s4
    800026be:	cf1ff0ef          	jal	800023ae <brelse>
    return addr;
    800026c2:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800026c4:	854a                	mv	a0,s2
    800026c6:	70a2                	ld	ra,40(sp)
    800026c8:	7402                	ld	s0,32(sp)
    800026ca:	64e2                	ld	s1,24(sp)
    800026cc:	6942                	ld	s2,16(sp)
    800026ce:	69a2                	ld	s3,8(sp)
    800026d0:	6145                	addi	sp,sp,48
    800026d2:	8082                	ret
      addr = balloc(ip->dev);
    800026d4:	0009a503          	lw	a0,0(s3)
    800026d8:	e33ff0ef          	jal	8000250a <balloc>
    800026dc:	0005091b          	sext.w	s2,a0
      if(addr){
    800026e0:	fc090ee3          	beqz	s2,800026bc <bmap+0x92>
        a[bn] = addr;
    800026e4:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800026e8:	8552                	mv	a0,s4
    800026ea:	50f000ef          	jal	800033f8 <log_write>
    800026ee:	b7f9                	j	800026bc <bmap+0x92>
    800026f0:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800026f2:	00005517          	auipc	a0,0x5
    800026f6:	ede50513          	addi	a0,a0,-290 # 800075d0 <etext+0x5d0>
    800026fa:	138030ef          	jal	80005832 <panic>

00000000800026fe <iget>:
{
    800026fe:	7179                	addi	sp,sp,-48
    80002700:	f406                	sd	ra,40(sp)
    80002702:	f022                	sd	s0,32(sp)
    80002704:	ec26                	sd	s1,24(sp)
    80002706:	e84a                	sd	s2,16(sp)
    80002708:	e44e                	sd	s3,8(sp)
    8000270a:	e052                	sd	s4,0(sp)
    8000270c:	1800                	addi	s0,sp,48
    8000270e:	89aa                	mv	s3,a0
    80002710:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002712:	00016517          	auipc	a0,0x16
    80002716:	79650513          	addi	a0,a0,1942 # 80018ea8 <itable>
    8000271a:	446030ef          	jal	80005b60 <acquire>
  empty = 0;
    8000271e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002720:	00016497          	auipc	s1,0x16
    80002724:	7a048493          	addi	s1,s1,1952 # 80018ec0 <itable+0x18>
    80002728:	00018697          	auipc	a3,0x18
    8000272c:	22868693          	addi	a3,a3,552 # 8001a950 <log>
    80002730:	a039                	j	8000273e <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002732:	02090963          	beqz	s2,80002764 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002736:	08848493          	addi	s1,s1,136
    8000273a:	02d48863          	beq	s1,a3,8000276a <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000273e:	449c                	lw	a5,8(s1)
    80002740:	fef059e3          	blez	a5,80002732 <iget+0x34>
    80002744:	4098                	lw	a4,0(s1)
    80002746:	ff3716e3          	bne	a4,s3,80002732 <iget+0x34>
    8000274a:	40d8                	lw	a4,4(s1)
    8000274c:	ff4713e3          	bne	a4,s4,80002732 <iget+0x34>
      ip->ref++;
    80002750:	2785                	addiw	a5,a5,1
    80002752:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002754:	00016517          	auipc	a0,0x16
    80002758:	75450513          	addi	a0,a0,1876 # 80018ea8 <itable>
    8000275c:	49c030ef          	jal	80005bf8 <release>
      return ip;
    80002760:	8926                	mv	s2,s1
    80002762:	a02d                	j	8000278c <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002764:	fbe9                	bnez	a5,80002736 <iget+0x38>
      empty = ip;
    80002766:	8926                	mv	s2,s1
    80002768:	b7f9                	j	80002736 <iget+0x38>
  if(empty == 0)
    8000276a:	02090a63          	beqz	s2,8000279e <iget+0xa0>
  ip->dev = dev;
    8000276e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002772:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002776:	4785                	li	a5,1
    80002778:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000277c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002780:	00016517          	auipc	a0,0x16
    80002784:	72850513          	addi	a0,a0,1832 # 80018ea8 <itable>
    80002788:	470030ef          	jal	80005bf8 <release>
}
    8000278c:	854a                	mv	a0,s2
    8000278e:	70a2                	ld	ra,40(sp)
    80002790:	7402                	ld	s0,32(sp)
    80002792:	64e2                	ld	s1,24(sp)
    80002794:	6942                	ld	s2,16(sp)
    80002796:	69a2                	ld	s3,8(sp)
    80002798:	6a02                	ld	s4,0(sp)
    8000279a:	6145                	addi	sp,sp,48
    8000279c:	8082                	ret
    panic("iget: no inodes");
    8000279e:	00005517          	auipc	a0,0x5
    800027a2:	e4a50513          	addi	a0,a0,-438 # 800075e8 <etext+0x5e8>
    800027a6:	08c030ef          	jal	80005832 <panic>

00000000800027aa <fsinit>:
fsinit(int dev) {
    800027aa:	7179                	addi	sp,sp,-48
    800027ac:	f406                	sd	ra,40(sp)
    800027ae:	f022                	sd	s0,32(sp)
    800027b0:	ec26                	sd	s1,24(sp)
    800027b2:	e84a                	sd	s2,16(sp)
    800027b4:	e44e                	sd	s3,8(sp)
    800027b6:	1800                	addi	s0,sp,48
    800027b8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800027ba:	4585                	li	a1,1
    800027bc:	aebff0ef          	jal	800022a6 <bread>
    800027c0:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800027c2:	00016997          	auipc	s3,0x16
    800027c6:	6c698993          	addi	s3,s3,1734 # 80018e88 <sb>
    800027ca:	02000613          	li	a2,32
    800027ce:	05850593          	addi	a1,a0,88
    800027d2:	854e                	mv	a0,s3
    800027d4:	9bdfd0ef          	jal	80000190 <memmove>
  brelse(bp);
    800027d8:	8526                	mv	a0,s1
    800027da:	bd5ff0ef          	jal	800023ae <brelse>
  if(sb.magic != FSMAGIC)
    800027de:	0009a703          	lw	a4,0(s3)
    800027e2:	102037b7          	lui	a5,0x10203
    800027e6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800027ea:	02f71063          	bne	a4,a5,8000280a <fsinit+0x60>
  initlog(dev, &sb);
    800027ee:	00016597          	auipc	a1,0x16
    800027f2:	69a58593          	addi	a1,a1,1690 # 80018e88 <sb>
    800027f6:	854a                	mv	a0,s2
    800027f8:	1f9000ef          	jal	800031f0 <initlog>
}
    800027fc:	70a2                	ld	ra,40(sp)
    800027fe:	7402                	ld	s0,32(sp)
    80002800:	64e2                	ld	s1,24(sp)
    80002802:	6942                	ld	s2,16(sp)
    80002804:	69a2                	ld	s3,8(sp)
    80002806:	6145                	addi	sp,sp,48
    80002808:	8082                	ret
    panic("invalid file system");
    8000280a:	00005517          	auipc	a0,0x5
    8000280e:	dee50513          	addi	a0,a0,-530 # 800075f8 <etext+0x5f8>
    80002812:	020030ef          	jal	80005832 <panic>

0000000080002816 <iinit>:
{
    80002816:	7179                	addi	sp,sp,-48
    80002818:	f406                	sd	ra,40(sp)
    8000281a:	f022                	sd	s0,32(sp)
    8000281c:	ec26                	sd	s1,24(sp)
    8000281e:	e84a                	sd	s2,16(sp)
    80002820:	e44e                	sd	s3,8(sp)
    80002822:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002824:	00005597          	auipc	a1,0x5
    80002828:	dec58593          	addi	a1,a1,-532 # 80007610 <etext+0x610>
    8000282c:	00016517          	auipc	a0,0x16
    80002830:	67c50513          	addi	a0,a0,1660 # 80018ea8 <itable>
    80002834:	2ac030ef          	jal	80005ae0 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002838:	00016497          	auipc	s1,0x16
    8000283c:	69848493          	addi	s1,s1,1688 # 80018ed0 <itable+0x28>
    80002840:	00018997          	auipc	s3,0x18
    80002844:	12098993          	addi	s3,s3,288 # 8001a960 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002848:	00005917          	auipc	s2,0x5
    8000284c:	dd090913          	addi	s2,s2,-560 # 80007618 <etext+0x618>
    80002850:	85ca                	mv	a1,s2
    80002852:	8526                	mv	a0,s1
    80002854:	475000ef          	jal	800034c8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002858:	08848493          	addi	s1,s1,136
    8000285c:	ff349ae3          	bne	s1,s3,80002850 <iinit+0x3a>
}
    80002860:	70a2                	ld	ra,40(sp)
    80002862:	7402                	ld	s0,32(sp)
    80002864:	64e2                	ld	s1,24(sp)
    80002866:	6942                	ld	s2,16(sp)
    80002868:	69a2                	ld	s3,8(sp)
    8000286a:	6145                	addi	sp,sp,48
    8000286c:	8082                	ret

000000008000286e <ialloc>:
{
    8000286e:	7139                	addi	sp,sp,-64
    80002870:	fc06                	sd	ra,56(sp)
    80002872:	f822                	sd	s0,48(sp)
    80002874:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002876:	00016717          	auipc	a4,0x16
    8000287a:	61e72703          	lw	a4,1566(a4) # 80018e94 <sb+0xc>
    8000287e:	4785                	li	a5,1
    80002880:	06e7f063          	bgeu	a5,a4,800028e0 <ialloc+0x72>
    80002884:	f426                	sd	s1,40(sp)
    80002886:	f04a                	sd	s2,32(sp)
    80002888:	ec4e                	sd	s3,24(sp)
    8000288a:	e852                	sd	s4,16(sp)
    8000288c:	e456                	sd	s5,8(sp)
    8000288e:	e05a                	sd	s6,0(sp)
    80002890:	8aaa                	mv	s5,a0
    80002892:	8b2e                	mv	s6,a1
    80002894:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002896:	00016a17          	auipc	s4,0x16
    8000289a:	5f2a0a13          	addi	s4,s4,1522 # 80018e88 <sb>
    8000289e:	00495593          	srli	a1,s2,0x4
    800028a2:	018a2783          	lw	a5,24(s4)
    800028a6:	9dbd                	addw	a1,a1,a5
    800028a8:	8556                	mv	a0,s5
    800028aa:	9fdff0ef          	jal	800022a6 <bread>
    800028ae:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800028b0:	05850993          	addi	s3,a0,88
    800028b4:	00f97793          	andi	a5,s2,15
    800028b8:	079a                	slli	a5,a5,0x6
    800028ba:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800028bc:	00099783          	lh	a5,0(s3)
    800028c0:	cb9d                	beqz	a5,800028f6 <ialloc+0x88>
    brelse(bp);
    800028c2:	aedff0ef          	jal	800023ae <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800028c6:	0905                	addi	s2,s2,1
    800028c8:	00ca2703          	lw	a4,12(s4)
    800028cc:	0009079b          	sext.w	a5,s2
    800028d0:	fce7e7e3          	bltu	a5,a4,8000289e <ialloc+0x30>
    800028d4:	74a2                	ld	s1,40(sp)
    800028d6:	7902                	ld	s2,32(sp)
    800028d8:	69e2                	ld	s3,24(sp)
    800028da:	6a42                	ld	s4,16(sp)
    800028dc:	6aa2                	ld	s5,8(sp)
    800028de:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800028e0:	00005517          	auipc	a0,0x5
    800028e4:	d4050513          	addi	a0,a0,-704 # 80007620 <etext+0x620>
    800028e8:	479020ef          	jal	80005560 <printf>
  return 0;
    800028ec:	4501                	li	a0,0
}
    800028ee:	70e2                	ld	ra,56(sp)
    800028f0:	7442                	ld	s0,48(sp)
    800028f2:	6121                	addi	sp,sp,64
    800028f4:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800028f6:	04000613          	li	a2,64
    800028fa:	4581                	li	a1,0
    800028fc:	854e                	mv	a0,s3
    800028fe:	837fd0ef          	jal	80000134 <memset>
      dip->type = type;
    80002902:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002906:	8526                	mv	a0,s1
    80002908:	2f1000ef          	jal	800033f8 <log_write>
      brelse(bp);
    8000290c:	8526                	mv	a0,s1
    8000290e:	aa1ff0ef          	jal	800023ae <brelse>
      return iget(dev, inum);
    80002912:	0009059b          	sext.w	a1,s2
    80002916:	8556                	mv	a0,s5
    80002918:	de7ff0ef          	jal	800026fe <iget>
    8000291c:	74a2                	ld	s1,40(sp)
    8000291e:	7902                	ld	s2,32(sp)
    80002920:	69e2                	ld	s3,24(sp)
    80002922:	6a42                	ld	s4,16(sp)
    80002924:	6aa2                	ld	s5,8(sp)
    80002926:	6b02                	ld	s6,0(sp)
    80002928:	b7d9                	j	800028ee <ialloc+0x80>

000000008000292a <iupdate>:
{
    8000292a:	1101                	addi	sp,sp,-32
    8000292c:	ec06                	sd	ra,24(sp)
    8000292e:	e822                	sd	s0,16(sp)
    80002930:	e426                	sd	s1,8(sp)
    80002932:	e04a                	sd	s2,0(sp)
    80002934:	1000                	addi	s0,sp,32
    80002936:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002938:	415c                	lw	a5,4(a0)
    8000293a:	0047d79b          	srliw	a5,a5,0x4
    8000293e:	00016597          	auipc	a1,0x16
    80002942:	5625a583          	lw	a1,1378(a1) # 80018ea0 <sb+0x18>
    80002946:	9dbd                	addw	a1,a1,a5
    80002948:	4108                	lw	a0,0(a0)
    8000294a:	95dff0ef          	jal	800022a6 <bread>
    8000294e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002950:	05850793          	addi	a5,a0,88
    80002954:	40d8                	lw	a4,4(s1)
    80002956:	8b3d                	andi	a4,a4,15
    80002958:	071a                	slli	a4,a4,0x6
    8000295a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000295c:	04449703          	lh	a4,68(s1)
    80002960:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002964:	04649703          	lh	a4,70(s1)
    80002968:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000296c:	04849703          	lh	a4,72(s1)
    80002970:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002974:	04a49703          	lh	a4,74(s1)
    80002978:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000297c:	44f8                	lw	a4,76(s1)
    8000297e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002980:	03400613          	li	a2,52
    80002984:	05048593          	addi	a1,s1,80
    80002988:	00c78513          	addi	a0,a5,12
    8000298c:	805fd0ef          	jal	80000190 <memmove>
  log_write(bp);
    80002990:	854a                	mv	a0,s2
    80002992:	267000ef          	jal	800033f8 <log_write>
  brelse(bp);
    80002996:	854a                	mv	a0,s2
    80002998:	a17ff0ef          	jal	800023ae <brelse>
}
    8000299c:	60e2                	ld	ra,24(sp)
    8000299e:	6442                	ld	s0,16(sp)
    800029a0:	64a2                	ld	s1,8(sp)
    800029a2:	6902                	ld	s2,0(sp)
    800029a4:	6105                	addi	sp,sp,32
    800029a6:	8082                	ret

00000000800029a8 <idup>:
{
    800029a8:	1101                	addi	sp,sp,-32
    800029aa:	ec06                	sd	ra,24(sp)
    800029ac:	e822                	sd	s0,16(sp)
    800029ae:	e426                	sd	s1,8(sp)
    800029b0:	1000                	addi	s0,sp,32
    800029b2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800029b4:	00016517          	auipc	a0,0x16
    800029b8:	4f450513          	addi	a0,a0,1268 # 80018ea8 <itable>
    800029bc:	1a4030ef          	jal	80005b60 <acquire>
  ip->ref++;
    800029c0:	449c                	lw	a5,8(s1)
    800029c2:	2785                	addiw	a5,a5,1
    800029c4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800029c6:	00016517          	auipc	a0,0x16
    800029ca:	4e250513          	addi	a0,a0,1250 # 80018ea8 <itable>
    800029ce:	22a030ef          	jal	80005bf8 <release>
}
    800029d2:	8526                	mv	a0,s1
    800029d4:	60e2                	ld	ra,24(sp)
    800029d6:	6442                	ld	s0,16(sp)
    800029d8:	64a2                	ld	s1,8(sp)
    800029da:	6105                	addi	sp,sp,32
    800029dc:	8082                	ret

00000000800029de <ilock>:
{
    800029de:	1101                	addi	sp,sp,-32
    800029e0:	ec06                	sd	ra,24(sp)
    800029e2:	e822                	sd	s0,16(sp)
    800029e4:	e426                	sd	s1,8(sp)
    800029e6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800029e8:	cd19                	beqz	a0,80002a06 <ilock+0x28>
    800029ea:	84aa                	mv	s1,a0
    800029ec:	451c                	lw	a5,8(a0)
    800029ee:	00f05c63          	blez	a5,80002a06 <ilock+0x28>
  acquiresleep(&ip->lock);
    800029f2:	0541                	addi	a0,a0,16
    800029f4:	30b000ef          	jal	800034fe <acquiresleep>
  if(ip->valid == 0){
    800029f8:	40bc                	lw	a5,64(s1)
    800029fa:	cf89                	beqz	a5,80002a14 <ilock+0x36>
}
    800029fc:	60e2                	ld	ra,24(sp)
    800029fe:	6442                	ld	s0,16(sp)
    80002a00:	64a2                	ld	s1,8(sp)
    80002a02:	6105                	addi	sp,sp,32
    80002a04:	8082                	ret
    80002a06:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002a08:	00005517          	auipc	a0,0x5
    80002a0c:	c3050513          	addi	a0,a0,-976 # 80007638 <etext+0x638>
    80002a10:	623020ef          	jal	80005832 <panic>
    80002a14:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a16:	40dc                	lw	a5,4(s1)
    80002a18:	0047d79b          	srliw	a5,a5,0x4
    80002a1c:	00016597          	auipc	a1,0x16
    80002a20:	4845a583          	lw	a1,1156(a1) # 80018ea0 <sb+0x18>
    80002a24:	9dbd                	addw	a1,a1,a5
    80002a26:	4088                	lw	a0,0(s1)
    80002a28:	87fff0ef          	jal	800022a6 <bread>
    80002a2c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a2e:	05850593          	addi	a1,a0,88
    80002a32:	40dc                	lw	a5,4(s1)
    80002a34:	8bbd                	andi	a5,a5,15
    80002a36:	079a                	slli	a5,a5,0x6
    80002a38:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002a3a:	00059783          	lh	a5,0(a1)
    80002a3e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002a42:	00259783          	lh	a5,2(a1)
    80002a46:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002a4a:	00459783          	lh	a5,4(a1)
    80002a4e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002a52:	00659783          	lh	a5,6(a1)
    80002a56:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002a5a:	459c                	lw	a5,8(a1)
    80002a5c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002a5e:	03400613          	li	a2,52
    80002a62:	05b1                	addi	a1,a1,12
    80002a64:	05048513          	addi	a0,s1,80
    80002a68:	f28fd0ef          	jal	80000190 <memmove>
    brelse(bp);
    80002a6c:	854a                	mv	a0,s2
    80002a6e:	941ff0ef          	jal	800023ae <brelse>
    ip->valid = 1;
    80002a72:	4785                	li	a5,1
    80002a74:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002a76:	04449783          	lh	a5,68(s1)
    80002a7a:	c399                	beqz	a5,80002a80 <ilock+0xa2>
    80002a7c:	6902                	ld	s2,0(sp)
    80002a7e:	bfbd                	j	800029fc <ilock+0x1e>
      panic("ilock: no type");
    80002a80:	00005517          	auipc	a0,0x5
    80002a84:	bc050513          	addi	a0,a0,-1088 # 80007640 <etext+0x640>
    80002a88:	5ab020ef          	jal	80005832 <panic>

0000000080002a8c <iunlock>:
{
    80002a8c:	1101                	addi	sp,sp,-32
    80002a8e:	ec06                	sd	ra,24(sp)
    80002a90:	e822                	sd	s0,16(sp)
    80002a92:	e426                	sd	s1,8(sp)
    80002a94:	e04a                	sd	s2,0(sp)
    80002a96:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002a98:	c505                	beqz	a0,80002ac0 <iunlock+0x34>
    80002a9a:	84aa                	mv	s1,a0
    80002a9c:	01050913          	addi	s2,a0,16
    80002aa0:	854a                	mv	a0,s2
    80002aa2:	2db000ef          	jal	8000357c <holdingsleep>
    80002aa6:	cd09                	beqz	a0,80002ac0 <iunlock+0x34>
    80002aa8:	449c                	lw	a5,8(s1)
    80002aaa:	00f05b63          	blez	a5,80002ac0 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002aae:	854a                	mv	a0,s2
    80002ab0:	295000ef          	jal	80003544 <releasesleep>
}
    80002ab4:	60e2                	ld	ra,24(sp)
    80002ab6:	6442                	ld	s0,16(sp)
    80002ab8:	64a2                	ld	s1,8(sp)
    80002aba:	6902                	ld	s2,0(sp)
    80002abc:	6105                	addi	sp,sp,32
    80002abe:	8082                	ret
    panic("iunlock");
    80002ac0:	00005517          	auipc	a0,0x5
    80002ac4:	b9050513          	addi	a0,a0,-1136 # 80007650 <etext+0x650>
    80002ac8:	56b020ef          	jal	80005832 <panic>

0000000080002acc <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002acc:	7179                	addi	sp,sp,-48
    80002ace:	f406                	sd	ra,40(sp)
    80002ad0:	f022                	sd	s0,32(sp)
    80002ad2:	ec26                	sd	s1,24(sp)
    80002ad4:	e84a                	sd	s2,16(sp)
    80002ad6:	e44e                	sd	s3,8(sp)
    80002ad8:	1800                	addi	s0,sp,48
    80002ada:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002adc:	05050493          	addi	s1,a0,80
    80002ae0:	08050913          	addi	s2,a0,128
    80002ae4:	a021                	j	80002aec <itrunc+0x20>
    80002ae6:	0491                	addi	s1,s1,4
    80002ae8:	01248b63          	beq	s1,s2,80002afe <itrunc+0x32>
    if(ip->addrs[i]){
    80002aec:	408c                	lw	a1,0(s1)
    80002aee:	dde5                	beqz	a1,80002ae6 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002af0:	0009a503          	lw	a0,0(s3)
    80002af4:	9abff0ef          	jal	8000249e <bfree>
      ip->addrs[i] = 0;
    80002af8:	0004a023          	sw	zero,0(s1)
    80002afc:	b7ed                	j	80002ae6 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002afe:	0809a583          	lw	a1,128(s3)
    80002b02:	ed89                	bnez	a1,80002b1c <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002b04:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002b08:	854e                	mv	a0,s3
    80002b0a:	e21ff0ef          	jal	8000292a <iupdate>
}
    80002b0e:	70a2                	ld	ra,40(sp)
    80002b10:	7402                	ld	s0,32(sp)
    80002b12:	64e2                	ld	s1,24(sp)
    80002b14:	6942                	ld	s2,16(sp)
    80002b16:	69a2                	ld	s3,8(sp)
    80002b18:	6145                	addi	sp,sp,48
    80002b1a:	8082                	ret
    80002b1c:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002b1e:	0009a503          	lw	a0,0(s3)
    80002b22:	f84ff0ef          	jal	800022a6 <bread>
    80002b26:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002b28:	05850493          	addi	s1,a0,88
    80002b2c:	45850913          	addi	s2,a0,1112
    80002b30:	a021                	j	80002b38 <itrunc+0x6c>
    80002b32:	0491                	addi	s1,s1,4
    80002b34:	01248963          	beq	s1,s2,80002b46 <itrunc+0x7a>
      if(a[j])
    80002b38:	408c                	lw	a1,0(s1)
    80002b3a:	dde5                	beqz	a1,80002b32 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002b3c:	0009a503          	lw	a0,0(s3)
    80002b40:	95fff0ef          	jal	8000249e <bfree>
    80002b44:	b7fd                	j	80002b32 <itrunc+0x66>
    brelse(bp);
    80002b46:	8552                	mv	a0,s4
    80002b48:	867ff0ef          	jal	800023ae <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002b4c:	0809a583          	lw	a1,128(s3)
    80002b50:	0009a503          	lw	a0,0(s3)
    80002b54:	94bff0ef          	jal	8000249e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002b58:	0809a023          	sw	zero,128(s3)
    80002b5c:	6a02                	ld	s4,0(sp)
    80002b5e:	b75d                	j	80002b04 <itrunc+0x38>

0000000080002b60 <iput>:
{
    80002b60:	1101                	addi	sp,sp,-32
    80002b62:	ec06                	sd	ra,24(sp)
    80002b64:	e822                	sd	s0,16(sp)
    80002b66:	e426                	sd	s1,8(sp)
    80002b68:	1000                	addi	s0,sp,32
    80002b6a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b6c:	00016517          	auipc	a0,0x16
    80002b70:	33c50513          	addi	a0,a0,828 # 80018ea8 <itable>
    80002b74:	7ed020ef          	jal	80005b60 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002b78:	4498                	lw	a4,8(s1)
    80002b7a:	4785                	li	a5,1
    80002b7c:	02f70063          	beq	a4,a5,80002b9c <iput+0x3c>
  ip->ref--;
    80002b80:	449c                	lw	a5,8(s1)
    80002b82:	37fd                	addiw	a5,a5,-1
    80002b84:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b86:	00016517          	auipc	a0,0x16
    80002b8a:	32250513          	addi	a0,a0,802 # 80018ea8 <itable>
    80002b8e:	06a030ef          	jal	80005bf8 <release>
}
    80002b92:	60e2                	ld	ra,24(sp)
    80002b94:	6442                	ld	s0,16(sp)
    80002b96:	64a2                	ld	s1,8(sp)
    80002b98:	6105                	addi	sp,sp,32
    80002b9a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002b9c:	40bc                	lw	a5,64(s1)
    80002b9e:	d3ed                	beqz	a5,80002b80 <iput+0x20>
    80002ba0:	04a49783          	lh	a5,74(s1)
    80002ba4:	fff1                	bnez	a5,80002b80 <iput+0x20>
    80002ba6:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002ba8:	01048913          	addi	s2,s1,16
    80002bac:	854a                	mv	a0,s2
    80002bae:	151000ef          	jal	800034fe <acquiresleep>
    release(&itable.lock);
    80002bb2:	00016517          	auipc	a0,0x16
    80002bb6:	2f650513          	addi	a0,a0,758 # 80018ea8 <itable>
    80002bba:	03e030ef          	jal	80005bf8 <release>
    itrunc(ip);
    80002bbe:	8526                	mv	a0,s1
    80002bc0:	f0dff0ef          	jal	80002acc <itrunc>
    ip->type = 0;
    80002bc4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002bc8:	8526                	mv	a0,s1
    80002bca:	d61ff0ef          	jal	8000292a <iupdate>
    ip->valid = 0;
    80002bce:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002bd2:	854a                	mv	a0,s2
    80002bd4:	171000ef          	jal	80003544 <releasesleep>
    acquire(&itable.lock);
    80002bd8:	00016517          	auipc	a0,0x16
    80002bdc:	2d050513          	addi	a0,a0,720 # 80018ea8 <itable>
    80002be0:	781020ef          	jal	80005b60 <acquire>
    80002be4:	6902                	ld	s2,0(sp)
    80002be6:	bf69                	j	80002b80 <iput+0x20>

0000000080002be8 <iunlockput>:
{
    80002be8:	1101                	addi	sp,sp,-32
    80002bea:	ec06                	sd	ra,24(sp)
    80002bec:	e822                	sd	s0,16(sp)
    80002bee:	e426                	sd	s1,8(sp)
    80002bf0:	1000                	addi	s0,sp,32
    80002bf2:	84aa                	mv	s1,a0
  iunlock(ip);
    80002bf4:	e99ff0ef          	jal	80002a8c <iunlock>
  iput(ip);
    80002bf8:	8526                	mv	a0,s1
    80002bfa:	f67ff0ef          	jal	80002b60 <iput>
}
    80002bfe:	60e2                	ld	ra,24(sp)
    80002c00:	6442                	ld	s0,16(sp)
    80002c02:	64a2                	ld	s1,8(sp)
    80002c04:	6105                	addi	sp,sp,32
    80002c06:	8082                	ret

0000000080002c08 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002c08:	1141                	addi	sp,sp,-16
    80002c0a:	e422                	sd	s0,8(sp)
    80002c0c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002c0e:	411c                	lw	a5,0(a0)
    80002c10:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002c12:	415c                	lw	a5,4(a0)
    80002c14:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002c16:	04451783          	lh	a5,68(a0)
    80002c1a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002c1e:	04a51783          	lh	a5,74(a0)
    80002c22:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002c26:	04c56783          	lwu	a5,76(a0)
    80002c2a:	e99c                	sd	a5,16(a1)
}
    80002c2c:	6422                	ld	s0,8(sp)
    80002c2e:	0141                	addi	sp,sp,16
    80002c30:	8082                	ret

0000000080002c32 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002c32:	457c                	lw	a5,76(a0)
    80002c34:	0ed7eb63          	bltu	a5,a3,80002d2a <readi+0xf8>
{
    80002c38:	7159                	addi	sp,sp,-112
    80002c3a:	f486                	sd	ra,104(sp)
    80002c3c:	f0a2                	sd	s0,96(sp)
    80002c3e:	eca6                	sd	s1,88(sp)
    80002c40:	e0d2                	sd	s4,64(sp)
    80002c42:	fc56                	sd	s5,56(sp)
    80002c44:	f85a                	sd	s6,48(sp)
    80002c46:	f45e                	sd	s7,40(sp)
    80002c48:	1880                	addi	s0,sp,112
    80002c4a:	8b2a                	mv	s6,a0
    80002c4c:	8bae                	mv	s7,a1
    80002c4e:	8a32                	mv	s4,a2
    80002c50:	84b6                	mv	s1,a3
    80002c52:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002c54:	9f35                	addw	a4,a4,a3
    return 0;
    80002c56:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002c58:	0cd76063          	bltu	a4,a3,80002d18 <readi+0xe6>
    80002c5c:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002c5e:	00e7f463          	bgeu	a5,a4,80002c66 <readi+0x34>
    n = ip->size - off;
    80002c62:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002c66:	080a8f63          	beqz	s5,80002d04 <readi+0xd2>
    80002c6a:	e8ca                	sd	s2,80(sp)
    80002c6c:	f062                	sd	s8,32(sp)
    80002c6e:	ec66                	sd	s9,24(sp)
    80002c70:	e86a                	sd	s10,16(sp)
    80002c72:	e46e                	sd	s11,8(sp)
    80002c74:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c76:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002c7a:	5c7d                	li	s8,-1
    80002c7c:	a80d                	j	80002cae <readi+0x7c>
    80002c7e:	020d1d93          	slli	s11,s10,0x20
    80002c82:	020ddd93          	srli	s11,s11,0x20
    80002c86:	05890613          	addi	a2,s2,88
    80002c8a:	86ee                	mv	a3,s11
    80002c8c:	963a                	add	a2,a2,a4
    80002c8e:	85d2                	mv	a1,s4
    80002c90:	855e                	mv	a0,s7
    80002c92:	9fbfe0ef          	jal	8000168c <either_copyout>
    80002c96:	05850763          	beq	a0,s8,80002ce4 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002c9a:	854a                	mv	a0,s2
    80002c9c:	f12ff0ef          	jal	800023ae <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ca0:	013d09bb          	addw	s3,s10,s3
    80002ca4:	009d04bb          	addw	s1,s10,s1
    80002ca8:	9a6e                	add	s4,s4,s11
    80002caa:	0559f763          	bgeu	s3,s5,80002cf8 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002cae:	00a4d59b          	srliw	a1,s1,0xa
    80002cb2:	855a                	mv	a0,s6
    80002cb4:	977ff0ef          	jal	8000262a <bmap>
    80002cb8:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002cbc:	c5b1                	beqz	a1,80002d08 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002cbe:	000b2503          	lw	a0,0(s6)
    80002cc2:	de4ff0ef          	jal	800022a6 <bread>
    80002cc6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002cc8:	3ff4f713          	andi	a4,s1,1023
    80002ccc:	40ec87bb          	subw	a5,s9,a4
    80002cd0:	413a86bb          	subw	a3,s5,s3
    80002cd4:	8d3e                	mv	s10,a5
    80002cd6:	2781                	sext.w	a5,a5
    80002cd8:	0006861b          	sext.w	a2,a3
    80002cdc:	faf671e3          	bgeu	a2,a5,80002c7e <readi+0x4c>
    80002ce0:	8d36                	mv	s10,a3
    80002ce2:	bf71                	j	80002c7e <readi+0x4c>
      brelse(bp);
    80002ce4:	854a                	mv	a0,s2
    80002ce6:	ec8ff0ef          	jal	800023ae <brelse>
      tot = -1;
    80002cea:	59fd                	li	s3,-1
      break;
    80002cec:	6946                	ld	s2,80(sp)
    80002cee:	7c02                	ld	s8,32(sp)
    80002cf0:	6ce2                	ld	s9,24(sp)
    80002cf2:	6d42                	ld	s10,16(sp)
    80002cf4:	6da2                	ld	s11,8(sp)
    80002cf6:	a831                	j	80002d12 <readi+0xe0>
    80002cf8:	6946                	ld	s2,80(sp)
    80002cfa:	7c02                	ld	s8,32(sp)
    80002cfc:	6ce2                	ld	s9,24(sp)
    80002cfe:	6d42                	ld	s10,16(sp)
    80002d00:	6da2                	ld	s11,8(sp)
    80002d02:	a801                	j	80002d12 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d04:	89d6                	mv	s3,s5
    80002d06:	a031                	j	80002d12 <readi+0xe0>
    80002d08:	6946                	ld	s2,80(sp)
    80002d0a:	7c02                	ld	s8,32(sp)
    80002d0c:	6ce2                	ld	s9,24(sp)
    80002d0e:	6d42                	ld	s10,16(sp)
    80002d10:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002d12:	0009851b          	sext.w	a0,s3
    80002d16:	69a6                	ld	s3,72(sp)
}
    80002d18:	70a6                	ld	ra,104(sp)
    80002d1a:	7406                	ld	s0,96(sp)
    80002d1c:	64e6                	ld	s1,88(sp)
    80002d1e:	6a06                	ld	s4,64(sp)
    80002d20:	7ae2                	ld	s5,56(sp)
    80002d22:	7b42                	ld	s6,48(sp)
    80002d24:	7ba2                	ld	s7,40(sp)
    80002d26:	6165                	addi	sp,sp,112
    80002d28:	8082                	ret
    return 0;
    80002d2a:	4501                	li	a0,0
}
    80002d2c:	8082                	ret

0000000080002d2e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d2e:	457c                	lw	a5,76(a0)
    80002d30:	10d7e063          	bltu	a5,a3,80002e30 <writei+0x102>
{
    80002d34:	7159                	addi	sp,sp,-112
    80002d36:	f486                	sd	ra,104(sp)
    80002d38:	f0a2                	sd	s0,96(sp)
    80002d3a:	e8ca                	sd	s2,80(sp)
    80002d3c:	e0d2                	sd	s4,64(sp)
    80002d3e:	fc56                	sd	s5,56(sp)
    80002d40:	f85a                	sd	s6,48(sp)
    80002d42:	f45e                	sd	s7,40(sp)
    80002d44:	1880                	addi	s0,sp,112
    80002d46:	8aaa                	mv	s5,a0
    80002d48:	8bae                	mv	s7,a1
    80002d4a:	8a32                	mv	s4,a2
    80002d4c:	8936                	mv	s2,a3
    80002d4e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002d50:	00e687bb          	addw	a5,a3,a4
    80002d54:	0ed7e063          	bltu	a5,a3,80002e34 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002d58:	00043737          	lui	a4,0x43
    80002d5c:	0cf76e63          	bltu	a4,a5,80002e38 <writei+0x10a>
    80002d60:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002d62:	0a0b0f63          	beqz	s6,80002e20 <writei+0xf2>
    80002d66:	eca6                	sd	s1,88(sp)
    80002d68:	f062                	sd	s8,32(sp)
    80002d6a:	ec66                	sd	s9,24(sp)
    80002d6c:	e86a                	sd	s10,16(sp)
    80002d6e:	e46e                	sd	s11,8(sp)
    80002d70:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002d72:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002d76:	5c7d                	li	s8,-1
    80002d78:	a825                	j	80002db0 <writei+0x82>
    80002d7a:	020d1d93          	slli	s11,s10,0x20
    80002d7e:	020ddd93          	srli	s11,s11,0x20
    80002d82:	05848513          	addi	a0,s1,88
    80002d86:	86ee                	mv	a3,s11
    80002d88:	8652                	mv	a2,s4
    80002d8a:	85de                	mv	a1,s7
    80002d8c:	953a                	add	a0,a0,a4
    80002d8e:	949fe0ef          	jal	800016d6 <either_copyin>
    80002d92:	05850a63          	beq	a0,s8,80002de6 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002d96:	8526                	mv	a0,s1
    80002d98:	660000ef          	jal	800033f8 <log_write>
    brelse(bp);
    80002d9c:	8526                	mv	a0,s1
    80002d9e:	e10ff0ef          	jal	800023ae <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002da2:	013d09bb          	addw	s3,s10,s3
    80002da6:	012d093b          	addw	s2,s10,s2
    80002daa:	9a6e                	add	s4,s4,s11
    80002dac:	0569f063          	bgeu	s3,s6,80002dec <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002db0:	00a9559b          	srliw	a1,s2,0xa
    80002db4:	8556                	mv	a0,s5
    80002db6:	875ff0ef          	jal	8000262a <bmap>
    80002dba:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002dbe:	c59d                	beqz	a1,80002dec <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002dc0:	000aa503          	lw	a0,0(s5)
    80002dc4:	ce2ff0ef          	jal	800022a6 <bread>
    80002dc8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dca:	3ff97713          	andi	a4,s2,1023
    80002dce:	40ec87bb          	subw	a5,s9,a4
    80002dd2:	413b06bb          	subw	a3,s6,s3
    80002dd6:	8d3e                	mv	s10,a5
    80002dd8:	2781                	sext.w	a5,a5
    80002dda:	0006861b          	sext.w	a2,a3
    80002dde:	f8f67ee3          	bgeu	a2,a5,80002d7a <writei+0x4c>
    80002de2:	8d36                	mv	s10,a3
    80002de4:	bf59                	j	80002d7a <writei+0x4c>
      brelse(bp);
    80002de6:	8526                	mv	a0,s1
    80002de8:	dc6ff0ef          	jal	800023ae <brelse>
  }

  if(off > ip->size)
    80002dec:	04caa783          	lw	a5,76(s5)
    80002df0:	0327fa63          	bgeu	a5,s2,80002e24 <writei+0xf6>
    ip->size = off;
    80002df4:	052aa623          	sw	s2,76(s5)
    80002df8:	64e6                	ld	s1,88(sp)
    80002dfa:	7c02                	ld	s8,32(sp)
    80002dfc:	6ce2                	ld	s9,24(sp)
    80002dfe:	6d42                	ld	s10,16(sp)
    80002e00:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002e02:	8556                	mv	a0,s5
    80002e04:	b27ff0ef          	jal	8000292a <iupdate>

  return tot;
    80002e08:	0009851b          	sext.w	a0,s3
    80002e0c:	69a6                	ld	s3,72(sp)
}
    80002e0e:	70a6                	ld	ra,104(sp)
    80002e10:	7406                	ld	s0,96(sp)
    80002e12:	6946                	ld	s2,80(sp)
    80002e14:	6a06                	ld	s4,64(sp)
    80002e16:	7ae2                	ld	s5,56(sp)
    80002e18:	7b42                	ld	s6,48(sp)
    80002e1a:	7ba2                	ld	s7,40(sp)
    80002e1c:	6165                	addi	sp,sp,112
    80002e1e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e20:	89da                	mv	s3,s6
    80002e22:	b7c5                	j	80002e02 <writei+0xd4>
    80002e24:	64e6                	ld	s1,88(sp)
    80002e26:	7c02                	ld	s8,32(sp)
    80002e28:	6ce2                	ld	s9,24(sp)
    80002e2a:	6d42                	ld	s10,16(sp)
    80002e2c:	6da2                	ld	s11,8(sp)
    80002e2e:	bfd1                	j	80002e02 <writei+0xd4>
    return -1;
    80002e30:	557d                	li	a0,-1
}
    80002e32:	8082                	ret
    return -1;
    80002e34:	557d                	li	a0,-1
    80002e36:	bfe1                	j	80002e0e <writei+0xe0>
    return -1;
    80002e38:	557d                	li	a0,-1
    80002e3a:	bfd1                	j	80002e0e <writei+0xe0>

0000000080002e3c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002e3c:	1141                	addi	sp,sp,-16
    80002e3e:	e406                	sd	ra,8(sp)
    80002e40:	e022                	sd	s0,0(sp)
    80002e42:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002e44:	4639                	li	a2,14
    80002e46:	bbafd0ef          	jal	80000200 <strncmp>
}
    80002e4a:	60a2                	ld	ra,8(sp)
    80002e4c:	6402                	ld	s0,0(sp)
    80002e4e:	0141                	addi	sp,sp,16
    80002e50:	8082                	ret

0000000080002e52 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002e52:	7139                	addi	sp,sp,-64
    80002e54:	fc06                	sd	ra,56(sp)
    80002e56:	f822                	sd	s0,48(sp)
    80002e58:	f426                	sd	s1,40(sp)
    80002e5a:	f04a                	sd	s2,32(sp)
    80002e5c:	ec4e                	sd	s3,24(sp)
    80002e5e:	e852                	sd	s4,16(sp)
    80002e60:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002e62:	04451703          	lh	a4,68(a0)
    80002e66:	4785                	li	a5,1
    80002e68:	00f71a63          	bne	a4,a5,80002e7c <dirlookup+0x2a>
    80002e6c:	892a                	mv	s2,a0
    80002e6e:	89ae                	mv	s3,a1
    80002e70:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e72:	457c                	lw	a5,76(a0)
    80002e74:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002e76:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e78:	e39d                	bnez	a5,80002e9e <dirlookup+0x4c>
    80002e7a:	a095                	j	80002ede <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002e7c:	00004517          	auipc	a0,0x4
    80002e80:	7dc50513          	addi	a0,a0,2012 # 80007658 <etext+0x658>
    80002e84:	1af020ef          	jal	80005832 <panic>
      panic("dirlookup read");
    80002e88:	00004517          	auipc	a0,0x4
    80002e8c:	7e850513          	addi	a0,a0,2024 # 80007670 <etext+0x670>
    80002e90:	1a3020ef          	jal	80005832 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e94:	24c1                	addiw	s1,s1,16
    80002e96:	04c92783          	lw	a5,76(s2)
    80002e9a:	04f4f163          	bgeu	s1,a5,80002edc <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e9e:	4741                	li	a4,16
    80002ea0:	86a6                	mv	a3,s1
    80002ea2:	fc040613          	addi	a2,s0,-64
    80002ea6:	4581                	li	a1,0
    80002ea8:	854a                	mv	a0,s2
    80002eaa:	d89ff0ef          	jal	80002c32 <readi>
    80002eae:	47c1                	li	a5,16
    80002eb0:	fcf51ce3          	bne	a0,a5,80002e88 <dirlookup+0x36>
    if(de.inum == 0)
    80002eb4:	fc045783          	lhu	a5,-64(s0)
    80002eb8:	dff1                	beqz	a5,80002e94 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002eba:	fc240593          	addi	a1,s0,-62
    80002ebe:	854e                	mv	a0,s3
    80002ec0:	f7dff0ef          	jal	80002e3c <namecmp>
    80002ec4:	f961                	bnez	a0,80002e94 <dirlookup+0x42>
      if(poff)
    80002ec6:	000a0463          	beqz	s4,80002ece <dirlookup+0x7c>
        *poff = off;
    80002eca:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002ece:	fc045583          	lhu	a1,-64(s0)
    80002ed2:	00092503          	lw	a0,0(s2)
    80002ed6:	829ff0ef          	jal	800026fe <iget>
    80002eda:	a011                	j	80002ede <dirlookup+0x8c>
  return 0;
    80002edc:	4501                	li	a0,0
}
    80002ede:	70e2                	ld	ra,56(sp)
    80002ee0:	7442                	ld	s0,48(sp)
    80002ee2:	74a2                	ld	s1,40(sp)
    80002ee4:	7902                	ld	s2,32(sp)
    80002ee6:	69e2                	ld	s3,24(sp)
    80002ee8:	6a42                	ld	s4,16(sp)
    80002eea:	6121                	addi	sp,sp,64
    80002eec:	8082                	ret

0000000080002eee <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002eee:	711d                	addi	sp,sp,-96
    80002ef0:	ec86                	sd	ra,88(sp)
    80002ef2:	e8a2                	sd	s0,80(sp)
    80002ef4:	e4a6                	sd	s1,72(sp)
    80002ef6:	e0ca                	sd	s2,64(sp)
    80002ef8:	fc4e                	sd	s3,56(sp)
    80002efa:	f852                	sd	s4,48(sp)
    80002efc:	f456                	sd	s5,40(sp)
    80002efe:	f05a                	sd	s6,32(sp)
    80002f00:	ec5e                	sd	s7,24(sp)
    80002f02:	e862                	sd	s8,16(sp)
    80002f04:	e466                	sd	s9,8(sp)
    80002f06:	1080                	addi	s0,sp,96
    80002f08:	84aa                	mv	s1,a0
    80002f0a:	8b2e                	mv	s6,a1
    80002f0c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002f0e:	00054703          	lbu	a4,0(a0)
    80002f12:	02f00793          	li	a5,47
    80002f16:	00f70e63          	beq	a4,a5,80002f32 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002f1a:	e3dfd0ef          	jal	80000d56 <myproc>
    80002f1e:	15053503          	ld	a0,336(a0)
    80002f22:	a87ff0ef          	jal	800029a8 <idup>
    80002f26:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002f28:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002f2c:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002f2e:	4b85                	li	s7,1
    80002f30:	a871                	j	80002fcc <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002f32:	4585                	li	a1,1
    80002f34:	4505                	li	a0,1
    80002f36:	fc8ff0ef          	jal	800026fe <iget>
    80002f3a:	8a2a                	mv	s4,a0
    80002f3c:	b7f5                	j	80002f28 <namex+0x3a>
      iunlockput(ip);
    80002f3e:	8552                	mv	a0,s4
    80002f40:	ca9ff0ef          	jal	80002be8 <iunlockput>
      return 0;
    80002f44:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002f46:	8552                	mv	a0,s4
    80002f48:	60e6                	ld	ra,88(sp)
    80002f4a:	6446                	ld	s0,80(sp)
    80002f4c:	64a6                	ld	s1,72(sp)
    80002f4e:	6906                	ld	s2,64(sp)
    80002f50:	79e2                	ld	s3,56(sp)
    80002f52:	7a42                	ld	s4,48(sp)
    80002f54:	7aa2                	ld	s5,40(sp)
    80002f56:	7b02                	ld	s6,32(sp)
    80002f58:	6be2                	ld	s7,24(sp)
    80002f5a:	6c42                	ld	s8,16(sp)
    80002f5c:	6ca2                	ld	s9,8(sp)
    80002f5e:	6125                	addi	sp,sp,96
    80002f60:	8082                	ret
      iunlock(ip);
    80002f62:	8552                	mv	a0,s4
    80002f64:	b29ff0ef          	jal	80002a8c <iunlock>
      return ip;
    80002f68:	bff9                	j	80002f46 <namex+0x58>
      iunlockput(ip);
    80002f6a:	8552                	mv	a0,s4
    80002f6c:	c7dff0ef          	jal	80002be8 <iunlockput>
      return 0;
    80002f70:	8a4e                	mv	s4,s3
    80002f72:	bfd1                	j	80002f46 <namex+0x58>
  len = path - s;
    80002f74:	40998633          	sub	a2,s3,s1
    80002f78:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002f7c:	099c5063          	bge	s8,s9,80002ffc <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002f80:	4639                	li	a2,14
    80002f82:	85a6                	mv	a1,s1
    80002f84:	8556                	mv	a0,s5
    80002f86:	a0afd0ef          	jal	80000190 <memmove>
    80002f8a:	84ce                	mv	s1,s3
  while(*path == '/')
    80002f8c:	0004c783          	lbu	a5,0(s1)
    80002f90:	01279763          	bne	a5,s2,80002f9e <namex+0xb0>
    path++;
    80002f94:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002f96:	0004c783          	lbu	a5,0(s1)
    80002f9a:	ff278de3          	beq	a5,s2,80002f94 <namex+0xa6>
    ilock(ip);
    80002f9e:	8552                	mv	a0,s4
    80002fa0:	a3fff0ef          	jal	800029de <ilock>
    if(ip->type != T_DIR){
    80002fa4:	044a1783          	lh	a5,68(s4)
    80002fa8:	f9779be3          	bne	a5,s7,80002f3e <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002fac:	000b0563          	beqz	s6,80002fb6 <namex+0xc8>
    80002fb0:	0004c783          	lbu	a5,0(s1)
    80002fb4:	d7dd                	beqz	a5,80002f62 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002fb6:	4601                	li	a2,0
    80002fb8:	85d6                	mv	a1,s5
    80002fba:	8552                	mv	a0,s4
    80002fbc:	e97ff0ef          	jal	80002e52 <dirlookup>
    80002fc0:	89aa                	mv	s3,a0
    80002fc2:	d545                	beqz	a0,80002f6a <namex+0x7c>
    iunlockput(ip);
    80002fc4:	8552                	mv	a0,s4
    80002fc6:	c23ff0ef          	jal	80002be8 <iunlockput>
    ip = next;
    80002fca:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002fcc:	0004c783          	lbu	a5,0(s1)
    80002fd0:	01279763          	bne	a5,s2,80002fde <namex+0xf0>
    path++;
    80002fd4:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002fd6:	0004c783          	lbu	a5,0(s1)
    80002fda:	ff278de3          	beq	a5,s2,80002fd4 <namex+0xe6>
  if(*path == 0)
    80002fde:	cb8d                	beqz	a5,80003010 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002fe0:	0004c783          	lbu	a5,0(s1)
    80002fe4:	89a6                	mv	s3,s1
  len = path - s;
    80002fe6:	4c81                	li	s9,0
    80002fe8:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002fea:	01278963          	beq	a5,s2,80002ffc <namex+0x10e>
    80002fee:	d3d9                	beqz	a5,80002f74 <namex+0x86>
    path++;
    80002ff0:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002ff2:	0009c783          	lbu	a5,0(s3)
    80002ff6:	ff279ce3          	bne	a5,s2,80002fee <namex+0x100>
    80002ffa:	bfad                	j	80002f74 <namex+0x86>
    memmove(name, s, len);
    80002ffc:	2601                	sext.w	a2,a2
    80002ffe:	85a6                	mv	a1,s1
    80003000:	8556                	mv	a0,s5
    80003002:	98efd0ef          	jal	80000190 <memmove>
    name[len] = 0;
    80003006:	9cd6                	add	s9,s9,s5
    80003008:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000300c:	84ce                	mv	s1,s3
    8000300e:	bfbd                	j	80002f8c <namex+0x9e>
  if(nameiparent){
    80003010:	f20b0be3          	beqz	s6,80002f46 <namex+0x58>
    iput(ip);
    80003014:	8552                	mv	a0,s4
    80003016:	b4bff0ef          	jal	80002b60 <iput>
    return 0;
    8000301a:	4a01                	li	s4,0
    8000301c:	b72d                	j	80002f46 <namex+0x58>

000000008000301e <dirlink>:
{
    8000301e:	7139                	addi	sp,sp,-64
    80003020:	fc06                	sd	ra,56(sp)
    80003022:	f822                	sd	s0,48(sp)
    80003024:	f04a                	sd	s2,32(sp)
    80003026:	ec4e                	sd	s3,24(sp)
    80003028:	e852                	sd	s4,16(sp)
    8000302a:	0080                	addi	s0,sp,64
    8000302c:	892a                	mv	s2,a0
    8000302e:	8a2e                	mv	s4,a1
    80003030:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003032:	4601                	li	a2,0
    80003034:	e1fff0ef          	jal	80002e52 <dirlookup>
    80003038:	e535                	bnez	a0,800030a4 <dirlink+0x86>
    8000303a:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000303c:	04c92483          	lw	s1,76(s2)
    80003040:	c48d                	beqz	s1,8000306a <dirlink+0x4c>
    80003042:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003044:	4741                	li	a4,16
    80003046:	86a6                	mv	a3,s1
    80003048:	fc040613          	addi	a2,s0,-64
    8000304c:	4581                	li	a1,0
    8000304e:	854a                	mv	a0,s2
    80003050:	be3ff0ef          	jal	80002c32 <readi>
    80003054:	47c1                	li	a5,16
    80003056:	04f51b63          	bne	a0,a5,800030ac <dirlink+0x8e>
    if(de.inum == 0)
    8000305a:	fc045783          	lhu	a5,-64(s0)
    8000305e:	c791                	beqz	a5,8000306a <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003060:	24c1                	addiw	s1,s1,16
    80003062:	04c92783          	lw	a5,76(s2)
    80003066:	fcf4efe3          	bltu	s1,a5,80003044 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    8000306a:	4639                	li	a2,14
    8000306c:	85d2                	mv	a1,s4
    8000306e:	fc240513          	addi	a0,s0,-62
    80003072:	9c4fd0ef          	jal	80000236 <strncpy>
  de.inum = inum;
    80003076:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000307a:	4741                	li	a4,16
    8000307c:	86a6                	mv	a3,s1
    8000307e:	fc040613          	addi	a2,s0,-64
    80003082:	4581                	li	a1,0
    80003084:	854a                	mv	a0,s2
    80003086:	ca9ff0ef          	jal	80002d2e <writei>
    8000308a:	1541                	addi	a0,a0,-16
    8000308c:	00a03533          	snez	a0,a0
    80003090:	40a00533          	neg	a0,a0
    80003094:	74a2                	ld	s1,40(sp)
}
    80003096:	70e2                	ld	ra,56(sp)
    80003098:	7442                	ld	s0,48(sp)
    8000309a:	7902                	ld	s2,32(sp)
    8000309c:	69e2                	ld	s3,24(sp)
    8000309e:	6a42                	ld	s4,16(sp)
    800030a0:	6121                	addi	sp,sp,64
    800030a2:	8082                	ret
    iput(ip);
    800030a4:	abdff0ef          	jal	80002b60 <iput>
    return -1;
    800030a8:	557d                	li	a0,-1
    800030aa:	b7f5                	j	80003096 <dirlink+0x78>
      panic("dirlink read");
    800030ac:	00004517          	auipc	a0,0x4
    800030b0:	5d450513          	addi	a0,a0,1492 # 80007680 <etext+0x680>
    800030b4:	77e020ef          	jal	80005832 <panic>

00000000800030b8 <namei>:

struct inode*
namei(char *path)
{
    800030b8:	1101                	addi	sp,sp,-32
    800030ba:	ec06                	sd	ra,24(sp)
    800030bc:	e822                	sd	s0,16(sp)
    800030be:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800030c0:	fe040613          	addi	a2,s0,-32
    800030c4:	4581                	li	a1,0
    800030c6:	e29ff0ef          	jal	80002eee <namex>
}
    800030ca:	60e2                	ld	ra,24(sp)
    800030cc:	6442                	ld	s0,16(sp)
    800030ce:	6105                	addi	sp,sp,32
    800030d0:	8082                	ret

00000000800030d2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800030d2:	1141                	addi	sp,sp,-16
    800030d4:	e406                	sd	ra,8(sp)
    800030d6:	e022                	sd	s0,0(sp)
    800030d8:	0800                	addi	s0,sp,16
    800030da:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800030dc:	4585                	li	a1,1
    800030de:	e11ff0ef          	jal	80002eee <namex>
}
    800030e2:	60a2                	ld	ra,8(sp)
    800030e4:	6402                	ld	s0,0(sp)
    800030e6:	0141                	addi	sp,sp,16
    800030e8:	8082                	ret

00000000800030ea <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800030ea:	1101                	addi	sp,sp,-32
    800030ec:	ec06                	sd	ra,24(sp)
    800030ee:	e822                	sd	s0,16(sp)
    800030f0:	e426                	sd	s1,8(sp)
    800030f2:	e04a                	sd	s2,0(sp)
    800030f4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800030f6:	00018917          	auipc	s2,0x18
    800030fa:	85a90913          	addi	s2,s2,-1958 # 8001a950 <log>
    800030fe:	01892583          	lw	a1,24(s2)
    80003102:	02892503          	lw	a0,40(s2)
    80003106:	9a0ff0ef          	jal	800022a6 <bread>
    8000310a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000310c:	02c92603          	lw	a2,44(s2)
    80003110:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003112:	00c05f63          	blez	a2,80003130 <write_head+0x46>
    80003116:	00018717          	auipc	a4,0x18
    8000311a:	86a70713          	addi	a4,a4,-1942 # 8001a980 <log+0x30>
    8000311e:	87aa                	mv	a5,a0
    80003120:	060a                	slli	a2,a2,0x2
    80003122:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003124:	4314                	lw	a3,0(a4)
    80003126:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003128:	0711                	addi	a4,a4,4
    8000312a:	0791                	addi	a5,a5,4
    8000312c:	fec79ce3          	bne	a5,a2,80003124 <write_head+0x3a>
  }
  bwrite(buf);
    80003130:	8526                	mv	a0,s1
    80003132:	a4aff0ef          	jal	8000237c <bwrite>
  brelse(buf);
    80003136:	8526                	mv	a0,s1
    80003138:	a76ff0ef          	jal	800023ae <brelse>
}
    8000313c:	60e2                	ld	ra,24(sp)
    8000313e:	6442                	ld	s0,16(sp)
    80003140:	64a2                	ld	s1,8(sp)
    80003142:	6902                	ld	s2,0(sp)
    80003144:	6105                	addi	sp,sp,32
    80003146:	8082                	ret

0000000080003148 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003148:	00018797          	auipc	a5,0x18
    8000314c:	8347a783          	lw	a5,-1996(a5) # 8001a97c <log+0x2c>
    80003150:	08f05f63          	blez	a5,800031ee <install_trans+0xa6>
{
    80003154:	7139                	addi	sp,sp,-64
    80003156:	fc06                	sd	ra,56(sp)
    80003158:	f822                	sd	s0,48(sp)
    8000315a:	f426                	sd	s1,40(sp)
    8000315c:	f04a                	sd	s2,32(sp)
    8000315e:	ec4e                	sd	s3,24(sp)
    80003160:	e852                	sd	s4,16(sp)
    80003162:	e456                	sd	s5,8(sp)
    80003164:	e05a                	sd	s6,0(sp)
    80003166:	0080                	addi	s0,sp,64
    80003168:	8b2a                	mv	s6,a0
    8000316a:	00018a97          	auipc	s5,0x18
    8000316e:	816a8a93          	addi	s5,s5,-2026 # 8001a980 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003172:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003174:	00017997          	auipc	s3,0x17
    80003178:	7dc98993          	addi	s3,s3,2012 # 8001a950 <log>
    8000317c:	a829                	j	80003196 <install_trans+0x4e>
    brelse(lbuf);
    8000317e:	854a                	mv	a0,s2
    80003180:	a2eff0ef          	jal	800023ae <brelse>
    brelse(dbuf);
    80003184:	8526                	mv	a0,s1
    80003186:	a28ff0ef          	jal	800023ae <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000318a:	2a05                	addiw	s4,s4,1
    8000318c:	0a91                	addi	s5,s5,4
    8000318e:	02c9a783          	lw	a5,44(s3)
    80003192:	04fa5463          	bge	s4,a5,800031da <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003196:	0189a583          	lw	a1,24(s3)
    8000319a:	014585bb          	addw	a1,a1,s4
    8000319e:	2585                	addiw	a1,a1,1
    800031a0:	0289a503          	lw	a0,40(s3)
    800031a4:	902ff0ef          	jal	800022a6 <bread>
    800031a8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800031aa:	000aa583          	lw	a1,0(s5)
    800031ae:	0289a503          	lw	a0,40(s3)
    800031b2:	8f4ff0ef          	jal	800022a6 <bread>
    800031b6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800031b8:	40000613          	li	a2,1024
    800031bc:	05890593          	addi	a1,s2,88
    800031c0:	05850513          	addi	a0,a0,88
    800031c4:	fcdfc0ef          	jal	80000190 <memmove>
    bwrite(dbuf);  // write dst to disk
    800031c8:	8526                	mv	a0,s1
    800031ca:	9b2ff0ef          	jal	8000237c <bwrite>
    if(recovering == 0)
    800031ce:	fa0b18e3          	bnez	s6,8000317e <install_trans+0x36>
      bunpin(dbuf);
    800031d2:	8526                	mv	a0,s1
    800031d4:	a96ff0ef          	jal	8000246a <bunpin>
    800031d8:	b75d                	j	8000317e <install_trans+0x36>
}
    800031da:	70e2                	ld	ra,56(sp)
    800031dc:	7442                	ld	s0,48(sp)
    800031de:	74a2                	ld	s1,40(sp)
    800031e0:	7902                	ld	s2,32(sp)
    800031e2:	69e2                	ld	s3,24(sp)
    800031e4:	6a42                	ld	s4,16(sp)
    800031e6:	6aa2                	ld	s5,8(sp)
    800031e8:	6b02                	ld	s6,0(sp)
    800031ea:	6121                	addi	sp,sp,64
    800031ec:	8082                	ret
    800031ee:	8082                	ret

00000000800031f0 <initlog>:
{
    800031f0:	7179                	addi	sp,sp,-48
    800031f2:	f406                	sd	ra,40(sp)
    800031f4:	f022                	sd	s0,32(sp)
    800031f6:	ec26                	sd	s1,24(sp)
    800031f8:	e84a                	sd	s2,16(sp)
    800031fa:	e44e                	sd	s3,8(sp)
    800031fc:	1800                	addi	s0,sp,48
    800031fe:	892a                	mv	s2,a0
    80003200:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003202:	00017497          	auipc	s1,0x17
    80003206:	74e48493          	addi	s1,s1,1870 # 8001a950 <log>
    8000320a:	00004597          	auipc	a1,0x4
    8000320e:	48658593          	addi	a1,a1,1158 # 80007690 <etext+0x690>
    80003212:	8526                	mv	a0,s1
    80003214:	0cd020ef          	jal	80005ae0 <initlock>
  log.start = sb->logstart;
    80003218:	0149a583          	lw	a1,20(s3)
    8000321c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000321e:	0109a783          	lw	a5,16(s3)
    80003222:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003224:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003228:	854a                	mv	a0,s2
    8000322a:	87cff0ef          	jal	800022a6 <bread>
  log.lh.n = lh->n;
    8000322e:	4d30                	lw	a2,88(a0)
    80003230:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003232:	00c05f63          	blez	a2,80003250 <initlog+0x60>
    80003236:	87aa                	mv	a5,a0
    80003238:	00017717          	auipc	a4,0x17
    8000323c:	74870713          	addi	a4,a4,1864 # 8001a980 <log+0x30>
    80003240:	060a                	slli	a2,a2,0x2
    80003242:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003244:	4ff4                	lw	a3,92(a5)
    80003246:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003248:	0791                	addi	a5,a5,4
    8000324a:	0711                	addi	a4,a4,4
    8000324c:	fec79ce3          	bne	a5,a2,80003244 <initlog+0x54>
  brelse(buf);
    80003250:	95eff0ef          	jal	800023ae <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003254:	4505                	li	a0,1
    80003256:	ef3ff0ef          	jal	80003148 <install_trans>
  log.lh.n = 0;
    8000325a:	00017797          	auipc	a5,0x17
    8000325e:	7207a123          	sw	zero,1826(a5) # 8001a97c <log+0x2c>
  write_head(); // clear the log
    80003262:	e89ff0ef          	jal	800030ea <write_head>
}
    80003266:	70a2                	ld	ra,40(sp)
    80003268:	7402                	ld	s0,32(sp)
    8000326a:	64e2                	ld	s1,24(sp)
    8000326c:	6942                	ld	s2,16(sp)
    8000326e:	69a2                	ld	s3,8(sp)
    80003270:	6145                	addi	sp,sp,48
    80003272:	8082                	ret

0000000080003274 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003274:	1101                	addi	sp,sp,-32
    80003276:	ec06                	sd	ra,24(sp)
    80003278:	e822                	sd	s0,16(sp)
    8000327a:	e426                	sd	s1,8(sp)
    8000327c:	e04a                	sd	s2,0(sp)
    8000327e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003280:	00017517          	auipc	a0,0x17
    80003284:	6d050513          	addi	a0,a0,1744 # 8001a950 <log>
    80003288:	0d9020ef          	jal	80005b60 <acquire>
  while(1){
    if(log.committing){
    8000328c:	00017497          	auipc	s1,0x17
    80003290:	6c448493          	addi	s1,s1,1732 # 8001a950 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003294:	4979                	li	s2,30
    80003296:	a029                	j	800032a0 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003298:	85a6                	mv	a1,s1
    8000329a:	8526                	mv	a0,s1
    8000329c:	894fe0ef          	jal	80001330 <sleep>
    if(log.committing){
    800032a0:	50dc                	lw	a5,36(s1)
    800032a2:	fbfd                	bnez	a5,80003298 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800032a4:	5098                	lw	a4,32(s1)
    800032a6:	2705                	addiw	a4,a4,1
    800032a8:	0027179b          	slliw	a5,a4,0x2
    800032ac:	9fb9                	addw	a5,a5,a4
    800032ae:	0017979b          	slliw	a5,a5,0x1
    800032b2:	54d4                	lw	a3,44(s1)
    800032b4:	9fb5                	addw	a5,a5,a3
    800032b6:	00f95763          	bge	s2,a5,800032c4 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800032ba:	85a6                	mv	a1,s1
    800032bc:	8526                	mv	a0,s1
    800032be:	872fe0ef          	jal	80001330 <sleep>
    800032c2:	bff9                	j	800032a0 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800032c4:	00017517          	auipc	a0,0x17
    800032c8:	68c50513          	addi	a0,a0,1676 # 8001a950 <log>
    800032cc:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800032ce:	12b020ef          	jal	80005bf8 <release>
      break;
    }
  }
}
    800032d2:	60e2                	ld	ra,24(sp)
    800032d4:	6442                	ld	s0,16(sp)
    800032d6:	64a2                	ld	s1,8(sp)
    800032d8:	6902                	ld	s2,0(sp)
    800032da:	6105                	addi	sp,sp,32
    800032dc:	8082                	ret

00000000800032de <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800032de:	7139                	addi	sp,sp,-64
    800032e0:	fc06                	sd	ra,56(sp)
    800032e2:	f822                	sd	s0,48(sp)
    800032e4:	f426                	sd	s1,40(sp)
    800032e6:	f04a                	sd	s2,32(sp)
    800032e8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800032ea:	00017497          	auipc	s1,0x17
    800032ee:	66648493          	addi	s1,s1,1638 # 8001a950 <log>
    800032f2:	8526                	mv	a0,s1
    800032f4:	06d020ef          	jal	80005b60 <acquire>
  log.outstanding -= 1;
    800032f8:	509c                	lw	a5,32(s1)
    800032fa:	37fd                	addiw	a5,a5,-1
    800032fc:	0007891b          	sext.w	s2,a5
    80003300:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003302:	50dc                	lw	a5,36(s1)
    80003304:	ef9d                	bnez	a5,80003342 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003306:	04091763          	bnez	s2,80003354 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    8000330a:	00017497          	auipc	s1,0x17
    8000330e:	64648493          	addi	s1,s1,1606 # 8001a950 <log>
    80003312:	4785                	li	a5,1
    80003314:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003316:	8526                	mv	a0,s1
    80003318:	0e1020ef          	jal	80005bf8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000331c:	54dc                	lw	a5,44(s1)
    8000331e:	04f04b63          	bgtz	a5,80003374 <end_op+0x96>
    acquire(&log.lock);
    80003322:	00017497          	auipc	s1,0x17
    80003326:	62e48493          	addi	s1,s1,1582 # 8001a950 <log>
    8000332a:	8526                	mv	a0,s1
    8000332c:	035020ef          	jal	80005b60 <acquire>
    log.committing = 0;
    80003330:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003334:	8526                	mv	a0,s1
    80003336:	846fe0ef          	jal	8000137c <wakeup>
    release(&log.lock);
    8000333a:	8526                	mv	a0,s1
    8000333c:	0bd020ef          	jal	80005bf8 <release>
}
    80003340:	a025                	j	80003368 <end_op+0x8a>
    80003342:	ec4e                	sd	s3,24(sp)
    80003344:	e852                	sd	s4,16(sp)
    80003346:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003348:	00004517          	auipc	a0,0x4
    8000334c:	35050513          	addi	a0,a0,848 # 80007698 <etext+0x698>
    80003350:	4e2020ef          	jal	80005832 <panic>
    wakeup(&log);
    80003354:	00017497          	auipc	s1,0x17
    80003358:	5fc48493          	addi	s1,s1,1532 # 8001a950 <log>
    8000335c:	8526                	mv	a0,s1
    8000335e:	81efe0ef          	jal	8000137c <wakeup>
  release(&log.lock);
    80003362:	8526                	mv	a0,s1
    80003364:	095020ef          	jal	80005bf8 <release>
}
    80003368:	70e2                	ld	ra,56(sp)
    8000336a:	7442                	ld	s0,48(sp)
    8000336c:	74a2                	ld	s1,40(sp)
    8000336e:	7902                	ld	s2,32(sp)
    80003370:	6121                	addi	sp,sp,64
    80003372:	8082                	ret
    80003374:	ec4e                	sd	s3,24(sp)
    80003376:	e852                	sd	s4,16(sp)
    80003378:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000337a:	00017a97          	auipc	s5,0x17
    8000337e:	606a8a93          	addi	s5,s5,1542 # 8001a980 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003382:	00017a17          	auipc	s4,0x17
    80003386:	5cea0a13          	addi	s4,s4,1486 # 8001a950 <log>
    8000338a:	018a2583          	lw	a1,24(s4)
    8000338e:	012585bb          	addw	a1,a1,s2
    80003392:	2585                	addiw	a1,a1,1
    80003394:	028a2503          	lw	a0,40(s4)
    80003398:	f0ffe0ef          	jal	800022a6 <bread>
    8000339c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000339e:	000aa583          	lw	a1,0(s5)
    800033a2:	028a2503          	lw	a0,40(s4)
    800033a6:	f01fe0ef          	jal	800022a6 <bread>
    800033aa:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800033ac:	40000613          	li	a2,1024
    800033b0:	05850593          	addi	a1,a0,88
    800033b4:	05848513          	addi	a0,s1,88
    800033b8:	dd9fc0ef          	jal	80000190 <memmove>
    bwrite(to);  // write the log
    800033bc:	8526                	mv	a0,s1
    800033be:	fbffe0ef          	jal	8000237c <bwrite>
    brelse(from);
    800033c2:	854e                	mv	a0,s3
    800033c4:	febfe0ef          	jal	800023ae <brelse>
    brelse(to);
    800033c8:	8526                	mv	a0,s1
    800033ca:	fe5fe0ef          	jal	800023ae <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033ce:	2905                	addiw	s2,s2,1
    800033d0:	0a91                	addi	s5,s5,4
    800033d2:	02ca2783          	lw	a5,44(s4)
    800033d6:	faf94ae3          	blt	s2,a5,8000338a <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800033da:	d11ff0ef          	jal	800030ea <write_head>
    install_trans(0); // Now install writes to home locations
    800033de:	4501                	li	a0,0
    800033e0:	d69ff0ef          	jal	80003148 <install_trans>
    log.lh.n = 0;
    800033e4:	00017797          	auipc	a5,0x17
    800033e8:	5807ac23          	sw	zero,1432(a5) # 8001a97c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800033ec:	cffff0ef          	jal	800030ea <write_head>
    800033f0:	69e2                	ld	s3,24(sp)
    800033f2:	6a42                	ld	s4,16(sp)
    800033f4:	6aa2                	ld	s5,8(sp)
    800033f6:	b735                	j	80003322 <end_op+0x44>

00000000800033f8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800033f8:	1101                	addi	sp,sp,-32
    800033fa:	ec06                	sd	ra,24(sp)
    800033fc:	e822                	sd	s0,16(sp)
    800033fe:	e426                	sd	s1,8(sp)
    80003400:	e04a                	sd	s2,0(sp)
    80003402:	1000                	addi	s0,sp,32
    80003404:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003406:	00017917          	auipc	s2,0x17
    8000340a:	54a90913          	addi	s2,s2,1354 # 8001a950 <log>
    8000340e:	854a                	mv	a0,s2
    80003410:	750020ef          	jal	80005b60 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003414:	02c92603          	lw	a2,44(s2)
    80003418:	47f5                	li	a5,29
    8000341a:	06c7c363          	blt	a5,a2,80003480 <log_write+0x88>
    8000341e:	00017797          	auipc	a5,0x17
    80003422:	54e7a783          	lw	a5,1358(a5) # 8001a96c <log+0x1c>
    80003426:	37fd                	addiw	a5,a5,-1
    80003428:	04f65c63          	bge	a2,a5,80003480 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000342c:	00017797          	auipc	a5,0x17
    80003430:	5447a783          	lw	a5,1348(a5) # 8001a970 <log+0x20>
    80003434:	04f05c63          	blez	a5,8000348c <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003438:	4781                	li	a5,0
    8000343a:	04c05f63          	blez	a2,80003498 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000343e:	44cc                	lw	a1,12(s1)
    80003440:	00017717          	auipc	a4,0x17
    80003444:	54070713          	addi	a4,a4,1344 # 8001a980 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003448:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000344a:	4314                	lw	a3,0(a4)
    8000344c:	04b68663          	beq	a3,a1,80003498 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003450:	2785                	addiw	a5,a5,1
    80003452:	0711                	addi	a4,a4,4
    80003454:	fef61be3          	bne	a2,a5,8000344a <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003458:	0621                	addi	a2,a2,8
    8000345a:	060a                	slli	a2,a2,0x2
    8000345c:	00017797          	auipc	a5,0x17
    80003460:	4f478793          	addi	a5,a5,1268 # 8001a950 <log>
    80003464:	97b2                	add	a5,a5,a2
    80003466:	44d8                	lw	a4,12(s1)
    80003468:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000346a:	8526                	mv	a0,s1
    8000346c:	fcbfe0ef          	jal	80002436 <bpin>
    log.lh.n++;
    80003470:	00017717          	auipc	a4,0x17
    80003474:	4e070713          	addi	a4,a4,1248 # 8001a950 <log>
    80003478:	575c                	lw	a5,44(a4)
    8000347a:	2785                	addiw	a5,a5,1
    8000347c:	d75c                	sw	a5,44(a4)
    8000347e:	a80d                	j	800034b0 <log_write+0xb8>
    panic("too big a transaction");
    80003480:	00004517          	auipc	a0,0x4
    80003484:	22850513          	addi	a0,a0,552 # 800076a8 <etext+0x6a8>
    80003488:	3aa020ef          	jal	80005832 <panic>
    panic("log_write outside of trans");
    8000348c:	00004517          	auipc	a0,0x4
    80003490:	23450513          	addi	a0,a0,564 # 800076c0 <etext+0x6c0>
    80003494:	39e020ef          	jal	80005832 <panic>
  log.lh.block[i] = b->blockno;
    80003498:	00878693          	addi	a3,a5,8
    8000349c:	068a                	slli	a3,a3,0x2
    8000349e:	00017717          	auipc	a4,0x17
    800034a2:	4b270713          	addi	a4,a4,1202 # 8001a950 <log>
    800034a6:	9736                	add	a4,a4,a3
    800034a8:	44d4                	lw	a3,12(s1)
    800034aa:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800034ac:	faf60fe3          	beq	a2,a5,8000346a <log_write+0x72>
  }
  release(&log.lock);
    800034b0:	00017517          	auipc	a0,0x17
    800034b4:	4a050513          	addi	a0,a0,1184 # 8001a950 <log>
    800034b8:	740020ef          	jal	80005bf8 <release>
}
    800034bc:	60e2                	ld	ra,24(sp)
    800034be:	6442                	ld	s0,16(sp)
    800034c0:	64a2                	ld	s1,8(sp)
    800034c2:	6902                	ld	s2,0(sp)
    800034c4:	6105                	addi	sp,sp,32
    800034c6:	8082                	ret

00000000800034c8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800034c8:	1101                	addi	sp,sp,-32
    800034ca:	ec06                	sd	ra,24(sp)
    800034cc:	e822                	sd	s0,16(sp)
    800034ce:	e426                	sd	s1,8(sp)
    800034d0:	e04a                	sd	s2,0(sp)
    800034d2:	1000                	addi	s0,sp,32
    800034d4:	84aa                	mv	s1,a0
    800034d6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800034d8:	00004597          	auipc	a1,0x4
    800034dc:	20858593          	addi	a1,a1,520 # 800076e0 <etext+0x6e0>
    800034e0:	0521                	addi	a0,a0,8
    800034e2:	5fe020ef          	jal	80005ae0 <initlock>
  lk->name = name;
    800034e6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800034ea:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800034ee:	0204a423          	sw	zero,40(s1)
}
    800034f2:	60e2                	ld	ra,24(sp)
    800034f4:	6442                	ld	s0,16(sp)
    800034f6:	64a2                	ld	s1,8(sp)
    800034f8:	6902                	ld	s2,0(sp)
    800034fa:	6105                	addi	sp,sp,32
    800034fc:	8082                	ret

00000000800034fe <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800034fe:	1101                	addi	sp,sp,-32
    80003500:	ec06                	sd	ra,24(sp)
    80003502:	e822                	sd	s0,16(sp)
    80003504:	e426                	sd	s1,8(sp)
    80003506:	e04a                	sd	s2,0(sp)
    80003508:	1000                	addi	s0,sp,32
    8000350a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000350c:	00850913          	addi	s2,a0,8
    80003510:	854a                	mv	a0,s2
    80003512:	64e020ef          	jal	80005b60 <acquire>
  while (lk->locked) {
    80003516:	409c                	lw	a5,0(s1)
    80003518:	c799                	beqz	a5,80003526 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000351a:	85ca                	mv	a1,s2
    8000351c:	8526                	mv	a0,s1
    8000351e:	e13fd0ef          	jal	80001330 <sleep>
  while (lk->locked) {
    80003522:	409c                	lw	a5,0(s1)
    80003524:	fbfd                	bnez	a5,8000351a <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003526:	4785                	li	a5,1
    80003528:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000352a:	82dfd0ef          	jal	80000d56 <myproc>
    8000352e:	591c                	lw	a5,48(a0)
    80003530:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003532:	854a                	mv	a0,s2
    80003534:	6c4020ef          	jal	80005bf8 <release>
}
    80003538:	60e2                	ld	ra,24(sp)
    8000353a:	6442                	ld	s0,16(sp)
    8000353c:	64a2                	ld	s1,8(sp)
    8000353e:	6902                	ld	s2,0(sp)
    80003540:	6105                	addi	sp,sp,32
    80003542:	8082                	ret

0000000080003544 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003544:	1101                	addi	sp,sp,-32
    80003546:	ec06                	sd	ra,24(sp)
    80003548:	e822                	sd	s0,16(sp)
    8000354a:	e426                	sd	s1,8(sp)
    8000354c:	e04a                	sd	s2,0(sp)
    8000354e:	1000                	addi	s0,sp,32
    80003550:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003552:	00850913          	addi	s2,a0,8
    80003556:	854a                	mv	a0,s2
    80003558:	608020ef          	jal	80005b60 <acquire>
  lk->locked = 0;
    8000355c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003560:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003564:	8526                	mv	a0,s1
    80003566:	e17fd0ef          	jal	8000137c <wakeup>
  release(&lk->lk);
    8000356a:	854a                	mv	a0,s2
    8000356c:	68c020ef          	jal	80005bf8 <release>
}
    80003570:	60e2                	ld	ra,24(sp)
    80003572:	6442                	ld	s0,16(sp)
    80003574:	64a2                	ld	s1,8(sp)
    80003576:	6902                	ld	s2,0(sp)
    80003578:	6105                	addi	sp,sp,32
    8000357a:	8082                	ret

000000008000357c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000357c:	7179                	addi	sp,sp,-48
    8000357e:	f406                	sd	ra,40(sp)
    80003580:	f022                	sd	s0,32(sp)
    80003582:	ec26                	sd	s1,24(sp)
    80003584:	e84a                	sd	s2,16(sp)
    80003586:	1800                	addi	s0,sp,48
    80003588:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000358a:	00850913          	addi	s2,a0,8
    8000358e:	854a                	mv	a0,s2
    80003590:	5d0020ef          	jal	80005b60 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003594:	409c                	lw	a5,0(s1)
    80003596:	ef81                	bnez	a5,800035ae <holdingsleep+0x32>
    80003598:	4481                	li	s1,0
  release(&lk->lk);
    8000359a:	854a                	mv	a0,s2
    8000359c:	65c020ef          	jal	80005bf8 <release>
  return r;
}
    800035a0:	8526                	mv	a0,s1
    800035a2:	70a2                	ld	ra,40(sp)
    800035a4:	7402                	ld	s0,32(sp)
    800035a6:	64e2                	ld	s1,24(sp)
    800035a8:	6942                	ld	s2,16(sp)
    800035aa:	6145                	addi	sp,sp,48
    800035ac:	8082                	ret
    800035ae:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800035b0:	0284a983          	lw	s3,40(s1)
    800035b4:	fa2fd0ef          	jal	80000d56 <myproc>
    800035b8:	5904                	lw	s1,48(a0)
    800035ba:	413484b3          	sub	s1,s1,s3
    800035be:	0014b493          	seqz	s1,s1
    800035c2:	69a2                	ld	s3,8(sp)
    800035c4:	bfd9                	j	8000359a <holdingsleep+0x1e>

00000000800035c6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800035c6:	1141                	addi	sp,sp,-16
    800035c8:	e406                	sd	ra,8(sp)
    800035ca:	e022                	sd	s0,0(sp)
    800035cc:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800035ce:	00004597          	auipc	a1,0x4
    800035d2:	12258593          	addi	a1,a1,290 # 800076f0 <etext+0x6f0>
    800035d6:	00017517          	auipc	a0,0x17
    800035da:	4c250513          	addi	a0,a0,1218 # 8001aa98 <ftable>
    800035de:	502020ef          	jal	80005ae0 <initlock>
}
    800035e2:	60a2                	ld	ra,8(sp)
    800035e4:	6402                	ld	s0,0(sp)
    800035e6:	0141                	addi	sp,sp,16
    800035e8:	8082                	ret

00000000800035ea <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800035ea:	1101                	addi	sp,sp,-32
    800035ec:	ec06                	sd	ra,24(sp)
    800035ee:	e822                	sd	s0,16(sp)
    800035f0:	e426                	sd	s1,8(sp)
    800035f2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800035f4:	00017517          	auipc	a0,0x17
    800035f8:	4a450513          	addi	a0,a0,1188 # 8001aa98 <ftable>
    800035fc:	564020ef          	jal	80005b60 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003600:	00017497          	auipc	s1,0x17
    80003604:	4b048493          	addi	s1,s1,1200 # 8001aab0 <ftable+0x18>
    80003608:	00018717          	auipc	a4,0x18
    8000360c:	44870713          	addi	a4,a4,1096 # 8001ba50 <disk>
    if(f->ref == 0){
    80003610:	40dc                	lw	a5,4(s1)
    80003612:	cf89                	beqz	a5,8000362c <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003614:	02848493          	addi	s1,s1,40
    80003618:	fee49ce3          	bne	s1,a4,80003610 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000361c:	00017517          	auipc	a0,0x17
    80003620:	47c50513          	addi	a0,a0,1148 # 8001aa98 <ftable>
    80003624:	5d4020ef          	jal	80005bf8 <release>
  return 0;
    80003628:	4481                	li	s1,0
    8000362a:	a809                	j	8000363c <filealloc+0x52>
      f->ref = 1;
    8000362c:	4785                	li	a5,1
    8000362e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003630:	00017517          	auipc	a0,0x17
    80003634:	46850513          	addi	a0,a0,1128 # 8001aa98 <ftable>
    80003638:	5c0020ef          	jal	80005bf8 <release>
}
    8000363c:	8526                	mv	a0,s1
    8000363e:	60e2                	ld	ra,24(sp)
    80003640:	6442                	ld	s0,16(sp)
    80003642:	64a2                	ld	s1,8(sp)
    80003644:	6105                	addi	sp,sp,32
    80003646:	8082                	ret

0000000080003648 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003648:	1101                	addi	sp,sp,-32
    8000364a:	ec06                	sd	ra,24(sp)
    8000364c:	e822                	sd	s0,16(sp)
    8000364e:	e426                	sd	s1,8(sp)
    80003650:	1000                	addi	s0,sp,32
    80003652:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003654:	00017517          	auipc	a0,0x17
    80003658:	44450513          	addi	a0,a0,1092 # 8001aa98 <ftable>
    8000365c:	504020ef          	jal	80005b60 <acquire>
  if(f->ref < 1)
    80003660:	40dc                	lw	a5,4(s1)
    80003662:	02f05063          	blez	a5,80003682 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003666:	2785                	addiw	a5,a5,1
    80003668:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000366a:	00017517          	auipc	a0,0x17
    8000366e:	42e50513          	addi	a0,a0,1070 # 8001aa98 <ftable>
    80003672:	586020ef          	jal	80005bf8 <release>
  return f;
}
    80003676:	8526                	mv	a0,s1
    80003678:	60e2                	ld	ra,24(sp)
    8000367a:	6442                	ld	s0,16(sp)
    8000367c:	64a2                	ld	s1,8(sp)
    8000367e:	6105                	addi	sp,sp,32
    80003680:	8082                	ret
    panic("filedup");
    80003682:	00004517          	auipc	a0,0x4
    80003686:	07650513          	addi	a0,a0,118 # 800076f8 <etext+0x6f8>
    8000368a:	1a8020ef          	jal	80005832 <panic>

000000008000368e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000368e:	7139                	addi	sp,sp,-64
    80003690:	fc06                	sd	ra,56(sp)
    80003692:	f822                	sd	s0,48(sp)
    80003694:	f426                	sd	s1,40(sp)
    80003696:	0080                	addi	s0,sp,64
    80003698:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000369a:	00017517          	auipc	a0,0x17
    8000369e:	3fe50513          	addi	a0,a0,1022 # 8001aa98 <ftable>
    800036a2:	4be020ef          	jal	80005b60 <acquire>
  if(f->ref < 1)
    800036a6:	40dc                	lw	a5,4(s1)
    800036a8:	04f05a63          	blez	a5,800036fc <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800036ac:	37fd                	addiw	a5,a5,-1
    800036ae:	0007871b          	sext.w	a4,a5
    800036b2:	c0dc                	sw	a5,4(s1)
    800036b4:	04e04e63          	bgtz	a4,80003710 <fileclose+0x82>
    800036b8:	f04a                	sd	s2,32(sp)
    800036ba:	ec4e                	sd	s3,24(sp)
    800036bc:	e852                	sd	s4,16(sp)
    800036be:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800036c0:	0004a903          	lw	s2,0(s1)
    800036c4:	0094ca83          	lbu	s5,9(s1)
    800036c8:	0104ba03          	ld	s4,16(s1)
    800036cc:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800036d0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800036d4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800036d8:	00017517          	auipc	a0,0x17
    800036dc:	3c050513          	addi	a0,a0,960 # 8001aa98 <ftable>
    800036e0:	518020ef          	jal	80005bf8 <release>

  if(ff.type == FD_PIPE){
    800036e4:	4785                	li	a5,1
    800036e6:	04f90063          	beq	s2,a5,80003726 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800036ea:	3979                	addiw	s2,s2,-2
    800036ec:	4785                	li	a5,1
    800036ee:	0527f563          	bgeu	a5,s2,80003738 <fileclose+0xaa>
    800036f2:	7902                	ld	s2,32(sp)
    800036f4:	69e2                	ld	s3,24(sp)
    800036f6:	6a42                	ld	s4,16(sp)
    800036f8:	6aa2                	ld	s5,8(sp)
    800036fa:	a00d                	j	8000371c <fileclose+0x8e>
    800036fc:	f04a                	sd	s2,32(sp)
    800036fe:	ec4e                	sd	s3,24(sp)
    80003700:	e852                	sd	s4,16(sp)
    80003702:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003704:	00004517          	auipc	a0,0x4
    80003708:	ffc50513          	addi	a0,a0,-4 # 80007700 <etext+0x700>
    8000370c:	126020ef          	jal	80005832 <panic>
    release(&ftable.lock);
    80003710:	00017517          	auipc	a0,0x17
    80003714:	38850513          	addi	a0,a0,904 # 8001aa98 <ftable>
    80003718:	4e0020ef          	jal	80005bf8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000371c:	70e2                	ld	ra,56(sp)
    8000371e:	7442                	ld	s0,48(sp)
    80003720:	74a2                	ld	s1,40(sp)
    80003722:	6121                	addi	sp,sp,64
    80003724:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003726:	85d6                	mv	a1,s5
    80003728:	8552                	mv	a0,s4
    8000372a:	336000ef          	jal	80003a60 <pipeclose>
    8000372e:	7902                	ld	s2,32(sp)
    80003730:	69e2                	ld	s3,24(sp)
    80003732:	6a42                	ld	s4,16(sp)
    80003734:	6aa2                	ld	s5,8(sp)
    80003736:	b7dd                	j	8000371c <fileclose+0x8e>
    begin_op();
    80003738:	b3dff0ef          	jal	80003274 <begin_op>
    iput(ff.ip);
    8000373c:	854e                	mv	a0,s3
    8000373e:	c22ff0ef          	jal	80002b60 <iput>
    end_op();
    80003742:	b9dff0ef          	jal	800032de <end_op>
    80003746:	7902                	ld	s2,32(sp)
    80003748:	69e2                	ld	s3,24(sp)
    8000374a:	6a42                	ld	s4,16(sp)
    8000374c:	6aa2                	ld	s5,8(sp)
    8000374e:	b7f9                	j	8000371c <fileclose+0x8e>

0000000080003750 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003750:	715d                	addi	sp,sp,-80
    80003752:	e486                	sd	ra,72(sp)
    80003754:	e0a2                	sd	s0,64(sp)
    80003756:	fc26                	sd	s1,56(sp)
    80003758:	f44e                	sd	s3,40(sp)
    8000375a:	0880                	addi	s0,sp,80
    8000375c:	84aa                	mv	s1,a0
    8000375e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003760:	df6fd0ef          	jal	80000d56 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003764:	409c                	lw	a5,0(s1)
    80003766:	37f9                	addiw	a5,a5,-2
    80003768:	4705                	li	a4,1
    8000376a:	04f76063          	bltu	a4,a5,800037aa <filestat+0x5a>
    8000376e:	f84a                	sd	s2,48(sp)
    80003770:	892a                	mv	s2,a0
    ilock(f->ip);
    80003772:	6c88                	ld	a0,24(s1)
    80003774:	a6aff0ef          	jal	800029de <ilock>
    stati(f->ip, &st);
    80003778:	fb840593          	addi	a1,s0,-72
    8000377c:	6c88                	ld	a0,24(s1)
    8000377e:	c8aff0ef          	jal	80002c08 <stati>
    iunlock(f->ip);
    80003782:	6c88                	ld	a0,24(s1)
    80003784:	b08ff0ef          	jal	80002a8c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003788:	46e1                	li	a3,24
    8000378a:	fb840613          	addi	a2,s0,-72
    8000378e:	85ce                	mv	a1,s3
    80003790:	05093503          	ld	a0,80(s2)
    80003794:	a32fd0ef          	jal	800009c6 <copyout>
    80003798:	41f5551b          	sraiw	a0,a0,0x1f
    8000379c:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000379e:	60a6                	ld	ra,72(sp)
    800037a0:	6406                	ld	s0,64(sp)
    800037a2:	74e2                	ld	s1,56(sp)
    800037a4:	79a2                	ld	s3,40(sp)
    800037a6:	6161                	addi	sp,sp,80
    800037a8:	8082                	ret
  return -1;
    800037aa:	557d                	li	a0,-1
    800037ac:	bfcd                	j	8000379e <filestat+0x4e>

00000000800037ae <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800037ae:	7179                	addi	sp,sp,-48
    800037b0:	f406                	sd	ra,40(sp)
    800037b2:	f022                	sd	s0,32(sp)
    800037b4:	e84a                	sd	s2,16(sp)
    800037b6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800037b8:	00854783          	lbu	a5,8(a0)
    800037bc:	cfd1                	beqz	a5,80003858 <fileread+0xaa>
    800037be:	ec26                	sd	s1,24(sp)
    800037c0:	e44e                	sd	s3,8(sp)
    800037c2:	84aa                	mv	s1,a0
    800037c4:	89ae                	mv	s3,a1
    800037c6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800037c8:	411c                	lw	a5,0(a0)
    800037ca:	4705                	li	a4,1
    800037cc:	04e78363          	beq	a5,a4,80003812 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800037d0:	470d                	li	a4,3
    800037d2:	04e78763          	beq	a5,a4,80003820 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800037d6:	4709                	li	a4,2
    800037d8:	06e79a63          	bne	a5,a4,8000384c <fileread+0x9e>
    ilock(f->ip);
    800037dc:	6d08                	ld	a0,24(a0)
    800037de:	a00ff0ef          	jal	800029de <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800037e2:	874a                	mv	a4,s2
    800037e4:	5094                	lw	a3,32(s1)
    800037e6:	864e                	mv	a2,s3
    800037e8:	4585                	li	a1,1
    800037ea:	6c88                	ld	a0,24(s1)
    800037ec:	c46ff0ef          	jal	80002c32 <readi>
    800037f0:	892a                	mv	s2,a0
    800037f2:	00a05563          	blez	a0,800037fc <fileread+0x4e>
      f->off += r;
    800037f6:	509c                	lw	a5,32(s1)
    800037f8:	9fa9                	addw	a5,a5,a0
    800037fa:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800037fc:	6c88                	ld	a0,24(s1)
    800037fe:	a8eff0ef          	jal	80002a8c <iunlock>
    80003802:	64e2                	ld	s1,24(sp)
    80003804:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003806:	854a                	mv	a0,s2
    80003808:	70a2                	ld	ra,40(sp)
    8000380a:	7402                	ld	s0,32(sp)
    8000380c:	6942                	ld	s2,16(sp)
    8000380e:	6145                	addi	sp,sp,48
    80003810:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003812:	6908                	ld	a0,16(a0)
    80003814:	388000ef          	jal	80003b9c <piperead>
    80003818:	892a                	mv	s2,a0
    8000381a:	64e2                	ld	s1,24(sp)
    8000381c:	69a2                	ld	s3,8(sp)
    8000381e:	b7e5                	j	80003806 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003820:	02451783          	lh	a5,36(a0)
    80003824:	03079693          	slli	a3,a5,0x30
    80003828:	92c1                	srli	a3,a3,0x30
    8000382a:	4725                	li	a4,9
    8000382c:	02d76863          	bltu	a4,a3,8000385c <fileread+0xae>
    80003830:	0792                	slli	a5,a5,0x4
    80003832:	00017717          	auipc	a4,0x17
    80003836:	1c670713          	addi	a4,a4,454 # 8001a9f8 <devsw>
    8000383a:	97ba                	add	a5,a5,a4
    8000383c:	639c                	ld	a5,0(a5)
    8000383e:	c39d                	beqz	a5,80003864 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003840:	4505                	li	a0,1
    80003842:	9782                	jalr	a5
    80003844:	892a                	mv	s2,a0
    80003846:	64e2                	ld	s1,24(sp)
    80003848:	69a2                	ld	s3,8(sp)
    8000384a:	bf75                	j	80003806 <fileread+0x58>
    panic("fileread");
    8000384c:	00004517          	auipc	a0,0x4
    80003850:	ec450513          	addi	a0,a0,-316 # 80007710 <etext+0x710>
    80003854:	7df010ef          	jal	80005832 <panic>
    return -1;
    80003858:	597d                	li	s2,-1
    8000385a:	b775                	j	80003806 <fileread+0x58>
      return -1;
    8000385c:	597d                	li	s2,-1
    8000385e:	64e2                	ld	s1,24(sp)
    80003860:	69a2                	ld	s3,8(sp)
    80003862:	b755                	j	80003806 <fileread+0x58>
    80003864:	597d                	li	s2,-1
    80003866:	64e2                	ld	s1,24(sp)
    80003868:	69a2                	ld	s3,8(sp)
    8000386a:	bf71                	j	80003806 <fileread+0x58>

000000008000386c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000386c:	00954783          	lbu	a5,9(a0)
    80003870:	10078b63          	beqz	a5,80003986 <filewrite+0x11a>
{
    80003874:	715d                	addi	sp,sp,-80
    80003876:	e486                	sd	ra,72(sp)
    80003878:	e0a2                	sd	s0,64(sp)
    8000387a:	f84a                	sd	s2,48(sp)
    8000387c:	f052                	sd	s4,32(sp)
    8000387e:	e85a                	sd	s6,16(sp)
    80003880:	0880                	addi	s0,sp,80
    80003882:	892a                	mv	s2,a0
    80003884:	8b2e                	mv	s6,a1
    80003886:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003888:	411c                	lw	a5,0(a0)
    8000388a:	4705                	li	a4,1
    8000388c:	02e78763          	beq	a5,a4,800038ba <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003890:	470d                	li	a4,3
    80003892:	02e78863          	beq	a5,a4,800038c2 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003896:	4709                	li	a4,2
    80003898:	0ce79c63          	bne	a5,a4,80003970 <filewrite+0x104>
    8000389c:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000389e:	0ac05863          	blez	a2,8000394e <filewrite+0xe2>
    800038a2:	fc26                	sd	s1,56(sp)
    800038a4:	ec56                	sd	s5,24(sp)
    800038a6:	e45e                	sd	s7,8(sp)
    800038a8:	e062                	sd	s8,0(sp)
    int i = 0;
    800038aa:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800038ac:	6b85                	lui	s7,0x1
    800038ae:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800038b2:	6c05                	lui	s8,0x1
    800038b4:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800038b8:	a8b5                	j	80003934 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800038ba:	6908                	ld	a0,16(a0)
    800038bc:	1fc000ef          	jal	80003ab8 <pipewrite>
    800038c0:	a04d                	j	80003962 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800038c2:	02451783          	lh	a5,36(a0)
    800038c6:	03079693          	slli	a3,a5,0x30
    800038ca:	92c1                	srli	a3,a3,0x30
    800038cc:	4725                	li	a4,9
    800038ce:	0ad76e63          	bltu	a4,a3,8000398a <filewrite+0x11e>
    800038d2:	0792                	slli	a5,a5,0x4
    800038d4:	00017717          	auipc	a4,0x17
    800038d8:	12470713          	addi	a4,a4,292 # 8001a9f8 <devsw>
    800038dc:	97ba                	add	a5,a5,a4
    800038de:	679c                	ld	a5,8(a5)
    800038e0:	c7dd                	beqz	a5,8000398e <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800038e2:	4505                	li	a0,1
    800038e4:	9782                	jalr	a5
    800038e6:	a8b5                	j	80003962 <filewrite+0xf6>
      if(n1 > max)
    800038e8:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800038ec:	989ff0ef          	jal	80003274 <begin_op>
      ilock(f->ip);
    800038f0:	01893503          	ld	a0,24(s2)
    800038f4:	8eaff0ef          	jal	800029de <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800038f8:	8756                	mv	a4,s5
    800038fa:	02092683          	lw	a3,32(s2)
    800038fe:	01698633          	add	a2,s3,s6
    80003902:	4585                	li	a1,1
    80003904:	01893503          	ld	a0,24(s2)
    80003908:	c26ff0ef          	jal	80002d2e <writei>
    8000390c:	84aa                	mv	s1,a0
    8000390e:	00a05763          	blez	a0,8000391c <filewrite+0xb0>
        f->off += r;
    80003912:	02092783          	lw	a5,32(s2)
    80003916:	9fa9                	addw	a5,a5,a0
    80003918:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000391c:	01893503          	ld	a0,24(s2)
    80003920:	96cff0ef          	jal	80002a8c <iunlock>
      end_op();
    80003924:	9bbff0ef          	jal	800032de <end_op>

      if(r != n1){
    80003928:	029a9563          	bne	s5,s1,80003952 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    8000392c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003930:	0149da63          	bge	s3,s4,80003944 <filewrite+0xd8>
      int n1 = n - i;
    80003934:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003938:	0004879b          	sext.w	a5,s1
    8000393c:	fafbd6e3          	bge	s7,a5,800038e8 <filewrite+0x7c>
    80003940:	84e2                	mv	s1,s8
    80003942:	b75d                	j	800038e8 <filewrite+0x7c>
    80003944:	74e2                	ld	s1,56(sp)
    80003946:	6ae2                	ld	s5,24(sp)
    80003948:	6ba2                	ld	s7,8(sp)
    8000394a:	6c02                	ld	s8,0(sp)
    8000394c:	a039                	j	8000395a <filewrite+0xee>
    int i = 0;
    8000394e:	4981                	li	s3,0
    80003950:	a029                	j	8000395a <filewrite+0xee>
    80003952:	74e2                	ld	s1,56(sp)
    80003954:	6ae2                	ld	s5,24(sp)
    80003956:	6ba2                	ld	s7,8(sp)
    80003958:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000395a:	033a1c63          	bne	s4,s3,80003992 <filewrite+0x126>
    8000395e:	8552                	mv	a0,s4
    80003960:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003962:	60a6                	ld	ra,72(sp)
    80003964:	6406                	ld	s0,64(sp)
    80003966:	7942                	ld	s2,48(sp)
    80003968:	7a02                	ld	s4,32(sp)
    8000396a:	6b42                	ld	s6,16(sp)
    8000396c:	6161                	addi	sp,sp,80
    8000396e:	8082                	ret
    80003970:	fc26                	sd	s1,56(sp)
    80003972:	f44e                	sd	s3,40(sp)
    80003974:	ec56                	sd	s5,24(sp)
    80003976:	e45e                	sd	s7,8(sp)
    80003978:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000397a:	00004517          	auipc	a0,0x4
    8000397e:	da650513          	addi	a0,a0,-602 # 80007720 <etext+0x720>
    80003982:	6b1010ef          	jal	80005832 <panic>
    return -1;
    80003986:	557d                	li	a0,-1
}
    80003988:	8082                	ret
      return -1;
    8000398a:	557d                	li	a0,-1
    8000398c:	bfd9                	j	80003962 <filewrite+0xf6>
    8000398e:	557d                	li	a0,-1
    80003990:	bfc9                	j	80003962 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80003992:	557d                	li	a0,-1
    80003994:	79a2                	ld	s3,40(sp)
    80003996:	b7f1                	j	80003962 <filewrite+0xf6>

0000000080003998 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003998:	7179                	addi	sp,sp,-48
    8000399a:	f406                	sd	ra,40(sp)
    8000399c:	f022                	sd	s0,32(sp)
    8000399e:	ec26                	sd	s1,24(sp)
    800039a0:	e052                	sd	s4,0(sp)
    800039a2:	1800                	addi	s0,sp,48
    800039a4:	84aa                	mv	s1,a0
    800039a6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800039a8:	0005b023          	sd	zero,0(a1)
    800039ac:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800039b0:	c3bff0ef          	jal	800035ea <filealloc>
    800039b4:	e088                	sd	a0,0(s1)
    800039b6:	c549                	beqz	a0,80003a40 <pipealloc+0xa8>
    800039b8:	c33ff0ef          	jal	800035ea <filealloc>
    800039bc:	00aa3023          	sd	a0,0(s4)
    800039c0:	cd25                	beqz	a0,80003a38 <pipealloc+0xa0>
    800039c2:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800039c4:	f32fc0ef          	jal	800000f6 <kalloc>
    800039c8:	892a                	mv	s2,a0
    800039ca:	c12d                	beqz	a0,80003a2c <pipealloc+0x94>
    800039cc:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800039ce:	4985                	li	s3,1
    800039d0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800039d4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800039d8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800039dc:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800039e0:	00004597          	auipc	a1,0x4
    800039e4:	ad858593          	addi	a1,a1,-1320 # 800074b8 <etext+0x4b8>
    800039e8:	0f8020ef          	jal	80005ae0 <initlock>
  (*f0)->type = FD_PIPE;
    800039ec:	609c                	ld	a5,0(s1)
    800039ee:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800039f2:	609c                	ld	a5,0(s1)
    800039f4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800039f8:	609c                	ld	a5,0(s1)
    800039fa:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800039fe:	609c                	ld	a5,0(s1)
    80003a00:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003a04:	000a3783          	ld	a5,0(s4)
    80003a08:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003a0c:	000a3783          	ld	a5,0(s4)
    80003a10:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003a14:	000a3783          	ld	a5,0(s4)
    80003a18:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003a1c:	000a3783          	ld	a5,0(s4)
    80003a20:	0127b823          	sd	s2,16(a5)
  return 0;
    80003a24:	4501                	li	a0,0
    80003a26:	6942                	ld	s2,16(sp)
    80003a28:	69a2                	ld	s3,8(sp)
    80003a2a:	a01d                	j	80003a50 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003a2c:	6088                	ld	a0,0(s1)
    80003a2e:	c119                	beqz	a0,80003a34 <pipealloc+0x9c>
    80003a30:	6942                	ld	s2,16(sp)
    80003a32:	a029                	j	80003a3c <pipealloc+0xa4>
    80003a34:	6942                	ld	s2,16(sp)
    80003a36:	a029                	j	80003a40 <pipealloc+0xa8>
    80003a38:	6088                	ld	a0,0(s1)
    80003a3a:	c10d                	beqz	a0,80003a5c <pipealloc+0xc4>
    fileclose(*f0);
    80003a3c:	c53ff0ef          	jal	8000368e <fileclose>
  if(*f1)
    80003a40:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003a44:	557d                	li	a0,-1
  if(*f1)
    80003a46:	c789                	beqz	a5,80003a50 <pipealloc+0xb8>
    fileclose(*f1);
    80003a48:	853e                	mv	a0,a5
    80003a4a:	c45ff0ef          	jal	8000368e <fileclose>
  return -1;
    80003a4e:	557d                	li	a0,-1
}
    80003a50:	70a2                	ld	ra,40(sp)
    80003a52:	7402                	ld	s0,32(sp)
    80003a54:	64e2                	ld	s1,24(sp)
    80003a56:	6a02                	ld	s4,0(sp)
    80003a58:	6145                	addi	sp,sp,48
    80003a5a:	8082                	ret
  return -1;
    80003a5c:	557d                	li	a0,-1
    80003a5e:	bfcd                	j	80003a50 <pipealloc+0xb8>

0000000080003a60 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003a60:	1101                	addi	sp,sp,-32
    80003a62:	ec06                	sd	ra,24(sp)
    80003a64:	e822                	sd	s0,16(sp)
    80003a66:	e426                	sd	s1,8(sp)
    80003a68:	e04a                	sd	s2,0(sp)
    80003a6a:	1000                	addi	s0,sp,32
    80003a6c:	84aa                	mv	s1,a0
    80003a6e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003a70:	0f0020ef          	jal	80005b60 <acquire>
  if(writable){
    80003a74:	02090763          	beqz	s2,80003aa2 <pipeclose+0x42>
    pi->writeopen = 0;
    80003a78:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003a7c:	21848513          	addi	a0,s1,536
    80003a80:	8fdfd0ef          	jal	8000137c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003a84:	2204b783          	ld	a5,544(s1)
    80003a88:	e785                	bnez	a5,80003ab0 <pipeclose+0x50>
    release(&pi->lock);
    80003a8a:	8526                	mv	a0,s1
    80003a8c:	16c020ef          	jal	80005bf8 <release>
    kfree((char*)pi);
    80003a90:	8526                	mv	a0,s1
    80003a92:	d8afc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003a96:	60e2                	ld	ra,24(sp)
    80003a98:	6442                	ld	s0,16(sp)
    80003a9a:	64a2                	ld	s1,8(sp)
    80003a9c:	6902                	ld	s2,0(sp)
    80003a9e:	6105                	addi	sp,sp,32
    80003aa0:	8082                	ret
    pi->readopen = 0;
    80003aa2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003aa6:	21c48513          	addi	a0,s1,540
    80003aaa:	8d3fd0ef          	jal	8000137c <wakeup>
    80003aae:	bfd9                	j	80003a84 <pipeclose+0x24>
    release(&pi->lock);
    80003ab0:	8526                	mv	a0,s1
    80003ab2:	146020ef          	jal	80005bf8 <release>
}
    80003ab6:	b7c5                	j	80003a96 <pipeclose+0x36>

0000000080003ab8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ab8:	711d                	addi	sp,sp,-96
    80003aba:	ec86                	sd	ra,88(sp)
    80003abc:	e8a2                	sd	s0,80(sp)
    80003abe:	e4a6                	sd	s1,72(sp)
    80003ac0:	e0ca                	sd	s2,64(sp)
    80003ac2:	fc4e                	sd	s3,56(sp)
    80003ac4:	f852                	sd	s4,48(sp)
    80003ac6:	f456                	sd	s5,40(sp)
    80003ac8:	1080                	addi	s0,sp,96
    80003aca:	84aa                	mv	s1,a0
    80003acc:	8aae                	mv	s5,a1
    80003ace:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ad0:	a86fd0ef          	jal	80000d56 <myproc>
    80003ad4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ad6:	8526                	mv	a0,s1
    80003ad8:	088020ef          	jal	80005b60 <acquire>
  while(i < n){
    80003adc:	0b405a63          	blez	s4,80003b90 <pipewrite+0xd8>
    80003ae0:	f05a                	sd	s6,32(sp)
    80003ae2:	ec5e                	sd	s7,24(sp)
    80003ae4:	e862                	sd	s8,16(sp)
  int i = 0;
    80003ae6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ae8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003aea:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003aee:	21c48b93          	addi	s7,s1,540
    80003af2:	a81d                	j	80003b28 <pipewrite+0x70>
      release(&pi->lock);
    80003af4:	8526                	mv	a0,s1
    80003af6:	102020ef          	jal	80005bf8 <release>
      return -1;
    80003afa:	597d                	li	s2,-1
    80003afc:	7b02                	ld	s6,32(sp)
    80003afe:	6be2                	ld	s7,24(sp)
    80003b00:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003b02:	854a                	mv	a0,s2
    80003b04:	60e6                	ld	ra,88(sp)
    80003b06:	6446                	ld	s0,80(sp)
    80003b08:	64a6                	ld	s1,72(sp)
    80003b0a:	6906                	ld	s2,64(sp)
    80003b0c:	79e2                	ld	s3,56(sp)
    80003b0e:	7a42                	ld	s4,48(sp)
    80003b10:	7aa2                	ld	s5,40(sp)
    80003b12:	6125                	addi	sp,sp,96
    80003b14:	8082                	ret
      wakeup(&pi->nread);
    80003b16:	8562                	mv	a0,s8
    80003b18:	865fd0ef          	jal	8000137c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003b1c:	85a6                	mv	a1,s1
    80003b1e:	855e                	mv	a0,s7
    80003b20:	811fd0ef          	jal	80001330 <sleep>
  while(i < n){
    80003b24:	05495b63          	bge	s2,s4,80003b7a <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003b28:	2204a783          	lw	a5,544(s1)
    80003b2c:	d7e1                	beqz	a5,80003af4 <pipewrite+0x3c>
    80003b2e:	854e                	mv	a0,s3
    80003b30:	a39fd0ef          	jal	80001568 <killed>
    80003b34:	f161                	bnez	a0,80003af4 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003b36:	2184a783          	lw	a5,536(s1)
    80003b3a:	21c4a703          	lw	a4,540(s1)
    80003b3e:	2007879b          	addiw	a5,a5,512
    80003b42:	fcf70ae3          	beq	a4,a5,80003b16 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003b46:	4685                	li	a3,1
    80003b48:	01590633          	add	a2,s2,s5
    80003b4c:	faf40593          	addi	a1,s0,-81
    80003b50:	0509b503          	ld	a0,80(s3)
    80003b54:	f4bfc0ef          	jal	80000a9e <copyin>
    80003b58:	03650e63          	beq	a0,s6,80003b94 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003b5c:	21c4a783          	lw	a5,540(s1)
    80003b60:	0017871b          	addiw	a4,a5,1
    80003b64:	20e4ae23          	sw	a4,540(s1)
    80003b68:	1ff7f793          	andi	a5,a5,511
    80003b6c:	97a6                	add	a5,a5,s1
    80003b6e:	faf44703          	lbu	a4,-81(s0)
    80003b72:	00e78c23          	sb	a4,24(a5)
      i++;
    80003b76:	2905                	addiw	s2,s2,1
    80003b78:	b775                	j	80003b24 <pipewrite+0x6c>
    80003b7a:	7b02                	ld	s6,32(sp)
    80003b7c:	6be2                	ld	s7,24(sp)
    80003b7e:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003b80:	21848513          	addi	a0,s1,536
    80003b84:	ff8fd0ef          	jal	8000137c <wakeup>
  release(&pi->lock);
    80003b88:	8526                	mv	a0,s1
    80003b8a:	06e020ef          	jal	80005bf8 <release>
  return i;
    80003b8e:	bf95                	j	80003b02 <pipewrite+0x4a>
  int i = 0;
    80003b90:	4901                	li	s2,0
    80003b92:	b7fd                	j	80003b80 <pipewrite+0xc8>
    80003b94:	7b02                	ld	s6,32(sp)
    80003b96:	6be2                	ld	s7,24(sp)
    80003b98:	6c42                	ld	s8,16(sp)
    80003b9a:	b7dd                	j	80003b80 <pipewrite+0xc8>

0000000080003b9c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003b9c:	715d                	addi	sp,sp,-80
    80003b9e:	e486                	sd	ra,72(sp)
    80003ba0:	e0a2                	sd	s0,64(sp)
    80003ba2:	fc26                	sd	s1,56(sp)
    80003ba4:	f84a                	sd	s2,48(sp)
    80003ba6:	f44e                	sd	s3,40(sp)
    80003ba8:	f052                	sd	s4,32(sp)
    80003baa:	ec56                	sd	s5,24(sp)
    80003bac:	0880                	addi	s0,sp,80
    80003bae:	84aa                	mv	s1,a0
    80003bb0:	892e                	mv	s2,a1
    80003bb2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003bb4:	9a2fd0ef          	jal	80000d56 <myproc>
    80003bb8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003bba:	8526                	mv	a0,s1
    80003bbc:	7a5010ef          	jal	80005b60 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003bc0:	2184a703          	lw	a4,536(s1)
    80003bc4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003bc8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003bcc:	02f71563          	bne	a4,a5,80003bf6 <piperead+0x5a>
    80003bd0:	2244a783          	lw	a5,548(s1)
    80003bd4:	cb85                	beqz	a5,80003c04 <piperead+0x68>
    if(killed(pr)){
    80003bd6:	8552                	mv	a0,s4
    80003bd8:	991fd0ef          	jal	80001568 <killed>
    80003bdc:	ed19                	bnez	a0,80003bfa <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003bde:	85a6                	mv	a1,s1
    80003be0:	854e                	mv	a0,s3
    80003be2:	f4efd0ef          	jal	80001330 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003be6:	2184a703          	lw	a4,536(s1)
    80003bea:	21c4a783          	lw	a5,540(s1)
    80003bee:	fef701e3          	beq	a4,a5,80003bd0 <piperead+0x34>
    80003bf2:	e85a                	sd	s6,16(sp)
    80003bf4:	a809                	j	80003c06 <piperead+0x6a>
    80003bf6:	e85a                	sd	s6,16(sp)
    80003bf8:	a039                	j	80003c06 <piperead+0x6a>
      release(&pi->lock);
    80003bfa:	8526                	mv	a0,s1
    80003bfc:	7fd010ef          	jal	80005bf8 <release>
      return -1;
    80003c00:	59fd                	li	s3,-1
    80003c02:	a8b1                	j	80003c5e <piperead+0xc2>
    80003c04:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003c06:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003c08:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003c0a:	05505263          	blez	s5,80003c4e <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003c0e:	2184a783          	lw	a5,536(s1)
    80003c12:	21c4a703          	lw	a4,540(s1)
    80003c16:	02f70c63          	beq	a4,a5,80003c4e <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003c1a:	0017871b          	addiw	a4,a5,1
    80003c1e:	20e4ac23          	sw	a4,536(s1)
    80003c22:	1ff7f793          	andi	a5,a5,511
    80003c26:	97a6                	add	a5,a5,s1
    80003c28:	0187c783          	lbu	a5,24(a5)
    80003c2c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003c30:	4685                	li	a3,1
    80003c32:	fbf40613          	addi	a2,s0,-65
    80003c36:	85ca                	mv	a1,s2
    80003c38:	050a3503          	ld	a0,80(s4)
    80003c3c:	d8bfc0ef          	jal	800009c6 <copyout>
    80003c40:	01650763          	beq	a0,s6,80003c4e <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003c44:	2985                	addiw	s3,s3,1
    80003c46:	0905                	addi	s2,s2,1
    80003c48:	fd3a93e3          	bne	s5,s3,80003c0e <piperead+0x72>
    80003c4c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003c4e:	21c48513          	addi	a0,s1,540
    80003c52:	f2afd0ef          	jal	8000137c <wakeup>
  release(&pi->lock);
    80003c56:	8526                	mv	a0,s1
    80003c58:	7a1010ef          	jal	80005bf8 <release>
    80003c5c:	6b42                	ld	s6,16(sp)
  return i;
}
    80003c5e:	854e                	mv	a0,s3
    80003c60:	60a6                	ld	ra,72(sp)
    80003c62:	6406                	ld	s0,64(sp)
    80003c64:	74e2                	ld	s1,56(sp)
    80003c66:	7942                	ld	s2,48(sp)
    80003c68:	79a2                	ld	s3,40(sp)
    80003c6a:	7a02                	ld	s4,32(sp)
    80003c6c:	6ae2                	ld	s5,24(sp)
    80003c6e:	6161                	addi	sp,sp,80
    80003c70:	8082                	ret

0000000080003c72 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003c72:	1141                	addi	sp,sp,-16
    80003c74:	e422                	sd	s0,8(sp)
    80003c76:	0800                	addi	s0,sp,16
    80003c78:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003c7a:	8905                	andi	a0,a0,1
    80003c7c:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003c7e:	8b89                	andi	a5,a5,2
    80003c80:	c399                	beqz	a5,80003c86 <flags2perm+0x14>
      perm |= PTE_W;
    80003c82:	00456513          	ori	a0,a0,4
    return perm;
}
    80003c86:	6422                	ld	s0,8(sp)
    80003c88:	0141                	addi	sp,sp,16
    80003c8a:	8082                	ret

0000000080003c8c <exec>:

int
exec(char *path, char **argv)
{
    80003c8c:	df010113          	addi	sp,sp,-528
    80003c90:	20113423          	sd	ra,520(sp)
    80003c94:	20813023          	sd	s0,512(sp)
    80003c98:	ffa6                	sd	s1,504(sp)
    80003c9a:	fbca                	sd	s2,496(sp)
    80003c9c:	0c00                	addi	s0,sp,528
    80003c9e:	892a                	mv	s2,a0
    80003ca0:	dea43c23          	sd	a0,-520(s0)
    80003ca4:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003ca8:	8aefd0ef          	jal	80000d56 <myproc>
    80003cac:	84aa                	mv	s1,a0

  begin_op();
    80003cae:	dc6ff0ef          	jal	80003274 <begin_op>

  if((ip = namei(path)) == 0){
    80003cb2:	854a                	mv	a0,s2
    80003cb4:	c04ff0ef          	jal	800030b8 <namei>
    80003cb8:	c931                	beqz	a0,80003d0c <exec+0x80>
    80003cba:	f3d2                	sd	s4,480(sp)
    80003cbc:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003cbe:	d21fe0ef          	jal	800029de <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003cc2:	04000713          	li	a4,64
    80003cc6:	4681                	li	a3,0
    80003cc8:	e5040613          	addi	a2,s0,-432
    80003ccc:	4581                	li	a1,0
    80003cce:	8552                	mv	a0,s4
    80003cd0:	f63fe0ef          	jal	80002c32 <readi>
    80003cd4:	04000793          	li	a5,64
    80003cd8:	00f51a63          	bne	a0,a5,80003cec <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003cdc:	e5042703          	lw	a4,-432(s0)
    80003ce0:	464c47b7          	lui	a5,0x464c4
    80003ce4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003ce8:	02f70663          	beq	a4,a5,80003d14 <exec+0x88>

bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003cec:	8552                	mv	a0,s4
    80003cee:	efbfe0ef          	jal	80002be8 <iunlockput>
    end_op();
    80003cf2:	decff0ef          	jal	800032de <end_op>
  }
  return -1;
    80003cf6:	557d                	li	a0,-1
    80003cf8:	7a1e                	ld	s4,480(sp)
}
    80003cfa:	20813083          	ld	ra,520(sp)
    80003cfe:	20013403          	ld	s0,512(sp)
    80003d02:	74fe                	ld	s1,504(sp)
    80003d04:	795e                	ld	s2,496(sp)
    80003d06:	21010113          	addi	sp,sp,528
    80003d0a:	8082                	ret
    end_op();
    80003d0c:	dd2ff0ef          	jal	800032de <end_op>
    return -1;
    80003d10:	557d                	li	a0,-1
    80003d12:	b7e5                	j	80003cfa <exec+0x6e>
    80003d14:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003d16:	8526                	mv	a0,s1
    80003d18:	8e6fd0ef          	jal	80000dfe <proc_pagetable>
    80003d1c:	8b2a                	mv	s6,a0
    80003d1e:	38050363          	beqz	a0,800040a4 <exec+0x418>
    80003d22:	f7ce                	sd	s3,488(sp)
    80003d24:	efd6                	sd	s5,472(sp)
    80003d26:	e7de                	sd	s7,456(sp)
    80003d28:	e3e2                	sd	s8,448(sp)
    80003d2a:	ff66                	sd	s9,440(sp)
    80003d2c:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d2e:	e7042d03          	lw	s10,-400(s0)
    80003d32:	e8845783          	lhu	a5,-376(s0)
    80003d36:	12078863          	beqz	a5,80003e66 <exec+0x1da>
    80003d3a:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003d3c:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d3e:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003d40:	6c85                	lui	s9,0x1
    80003d42:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003d46:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003d4a:	6a85                	lui	s5,0x1
    80003d4c:	a085                	j	80003dac <exec+0x120>
      panic("loadseg: address should exist");
    80003d4e:	00004517          	auipc	a0,0x4
    80003d52:	9e250513          	addi	a0,a0,-1566 # 80007730 <etext+0x730>
    80003d56:	2dd010ef          	jal	80005832 <panic>
    if(sz - i < PGSIZE)
    80003d5a:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003d5c:	8726                	mv	a4,s1
    80003d5e:	012c06bb          	addw	a3,s8,s2
    80003d62:	4581                	li	a1,0
    80003d64:	8552                	mv	a0,s4
    80003d66:	ecdfe0ef          	jal	80002c32 <readi>
    80003d6a:	2501                	sext.w	a0,a0
    80003d6c:	30a49263          	bne	s1,a0,80004070 <exec+0x3e4>
  for(i = 0; i < sz; i += PGSIZE){
    80003d70:	012a893b          	addw	s2,s5,s2
    80003d74:	03397363          	bgeu	s2,s3,80003d9a <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003d78:	02091593          	slli	a1,s2,0x20
    80003d7c:	9181                	srli	a1,a1,0x20
    80003d7e:	95de                	add	a1,a1,s7
    80003d80:	855a                	mv	a0,s6
    80003d82:	ec0fc0ef          	jal	80000442 <walkaddr>
    80003d86:	862a                	mv	a2,a0
    if(pa == 0)
    80003d88:	d179                	beqz	a0,80003d4e <exec+0xc2>
    if(sz - i < PGSIZE)
    80003d8a:	412984bb          	subw	s1,s3,s2
    80003d8e:	0004879b          	sext.w	a5,s1
    80003d92:	fcfcf4e3          	bgeu	s9,a5,80003d5a <exec+0xce>
    80003d96:	84d6                	mv	s1,s5
    80003d98:	b7c9                	j	80003d5a <exec+0xce>
    sz = sz1;
    80003d9a:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d9e:	2d85                	addiw	s11,s11,1
    80003da0:	038d0d1b          	addiw	s10,s10,56
    80003da4:	e8845783          	lhu	a5,-376(s0)
    80003da8:	08fdd063          	bge	s11,a5,80003e28 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003dac:	2d01                	sext.w	s10,s10
    80003dae:	03800713          	li	a4,56
    80003db2:	86ea                	mv	a3,s10
    80003db4:	e1840613          	addi	a2,s0,-488
    80003db8:	4581                	li	a1,0
    80003dba:	8552                	mv	a0,s4
    80003dbc:	e77fe0ef          	jal	80002c32 <readi>
    80003dc0:	03800793          	li	a5,56
    80003dc4:	26f51c63          	bne	a0,a5,8000403c <exec+0x3b0>
    if(ph.type != ELF_PROG_LOAD)
    80003dc8:	e1842783          	lw	a5,-488(s0)
    80003dcc:	4705                	li	a4,1
    80003dce:	fce798e3          	bne	a5,a4,80003d9e <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003dd2:	e4043903          	ld	s2,-448(s0)
    80003dd6:	e3843783          	ld	a5,-456(s0)
    80003dda:	26f96563          	bltu	s2,a5,80004044 <exec+0x3b8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003dde:	e2843783          	ld	a5,-472(s0)
    80003de2:	993e                	add	s2,s2,a5
    80003de4:	26f96463          	bltu	s2,a5,8000404c <exec+0x3c0>
    if(ph.vaddr % PGSIZE != 0)
    80003de8:	df043703          	ld	a4,-528(s0)
    80003dec:	8ff9                	and	a5,a5,a4
    80003dee:	26079363          	bnez	a5,80004054 <exec+0x3c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003df2:	e1c42503          	lw	a0,-484(s0)
    80003df6:	e7dff0ef          	jal	80003c72 <flags2perm>
    80003dfa:	86aa                	mv	a3,a0
    80003dfc:	864a                	mv	a2,s2
    80003dfe:	85a6                	mv	a1,s1
    80003e00:	855a                	mv	a0,s6
    80003e02:	9b9fc0ef          	jal	800007ba <uvmalloc>
    80003e06:	e0a43423          	sd	a0,-504(s0)
    80003e0a:	24050963          	beqz	a0,8000405c <exec+0x3d0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003e0e:	e2843b83          	ld	s7,-472(s0)
    80003e12:	e2042c03          	lw	s8,-480(s0)
    80003e16:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003e1a:	00098463          	beqz	s3,80003e22 <exec+0x196>
    80003e1e:	4901                	li	s2,0
    80003e20:	bfa1                	j	80003d78 <exec+0xec>
    sz = sz1;
    80003e22:	e0843483          	ld	s1,-504(s0)
    80003e26:	bfa5                	j	80003d9e <exec+0x112>
    80003e28:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003e2a:	8552                	mv	a0,s4
    80003e2c:	dbdfe0ef          	jal	80002be8 <iunlockput>
  end_op();
    80003e30:	caeff0ef          	jal	800032de <end_op>
  p = myproc();
    80003e34:	f23fc0ef          	jal	80000d56 <myproc>
    80003e38:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80003e3a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003e3e:	6905                	lui	s2,0x1
    80003e40:	197d                	addi	s2,s2,-1 # fff <_entry-0x7ffff001>
    80003e42:	9926                	add	s2,s2,s1
    80003e44:	77fd                	lui	a5,0xfffff
    80003e46:	00f97933          	and	s2,s2,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003e4a:	4691                	li	a3,4
    80003e4c:	6609                	lui	a2,0x2
    80003e4e:	964a                	add	a2,a2,s2
    80003e50:	85ca                	mv	a1,s2
    80003e52:	855a                	mv	a0,s6
    80003e54:	967fc0ef          	jal	800007ba <uvmalloc>
    80003e58:	e0a43423          	sd	a0,-504(s0)
    80003e5c:	e519                	bnez	a0,80003e6a <exec+0x1de>
  if(pagetable)
    80003e5e:	e1243423          	sd	s2,-504(s0)
    80003e62:	4a01                	li	s4,0
    80003e64:	a439                	j	80004072 <exec+0x3e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003e66:	4481                	li	s1,0
    80003e68:	b7c9                	j	80003e2a <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003e6a:	75f9                	lui	a1,0xffffe
    80003e6c:	892a                	mv	s2,a0
    80003e6e:	95aa                	add	a1,a1,a0
    80003e70:	855a                	mv	a0,s6
    80003e72:	b2bfc0ef          	jal	8000099c <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003e76:	7c7d                	lui	s8,0xfffff
    80003e78:	9c4a                	add	s8,s8,s2
  for(argc = 0; argv[argc]; argc++) {
    80003e7a:	e0043983          	ld	s3,-512(s0)
    80003e7e:	0009b503          	ld	a0,0(s3)
    80003e82:	22050663          	beqz	a0,800040ae <exec+0x422>
    80003e86:	e9040a13          	addi	s4,s0,-368
    80003e8a:	4a81                	li	s5,0
    if(argc >= MAXARG)
    80003e8c:	02000c93          	li	s9,32
    sp -= strlen(argv[argc]) + 1;
    80003e90:	c14fc0ef          	jal	800002a4 <strlen>
    80003e94:	0015079b          	addiw	a5,a0,1
    80003e98:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003e9c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003ea0:	1d896463          	bltu	s2,s8,80004068 <exec+0x3dc>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003ea4:	0009b483          	ld	s1,0(s3)
    80003ea8:	8526                	mv	a0,s1
    80003eaa:	bfafc0ef          	jal	800002a4 <strlen>
    80003eae:	0015069b          	addiw	a3,a0,1
    80003eb2:	8626                	mv	a2,s1
    80003eb4:	85ca                	mv	a1,s2
    80003eb6:	855a                	mv	a0,s6
    80003eb8:	b0ffc0ef          	jal	800009c6 <copyout>
    80003ebc:	1a054863          	bltz	a0,8000406c <exec+0x3e0>
    ustack[argc] = sp;
    80003ec0:	012a3023          	sd	s2,0(s4)
  for(argc = 0; argv[argc]; argc++) {
    80003ec4:	001a8493          	addi	s1,s5,1 # 1001 <_entry-0x7fffefff>
    80003ec8:	09a1                	addi	s3,s3,8
    80003eca:	0009b503          	ld	a0,0(s3)
    80003ece:	c511                	beqz	a0,80003eda <exec+0x24e>
    if(argc >= MAXARG)
    80003ed0:	0a21                	addi	s4,s4,8
    80003ed2:	19948963          	beq	s1,s9,80004064 <exec+0x3d8>
    80003ed6:	8aa6                	mv	s5,s1
    80003ed8:	bf65                	j	80003e90 <exec+0x204>
  ustack[argc] = 0;
    80003eda:	00349793          	slli	a5,s1,0x3
    80003ede:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb300>
    80003ee2:	97a2                	add	a5,a5,s0
    80003ee4:	f007b023          	sd	zero,-256(a5)
    80003ee8:	e0043a03          	ld	s4,-512(s0)
    80003eec:	4981                	li	s3,0
  if (strncmp(argv[i], "--trace-mask", 12) == 0 && i + 1 < argc) {  // Added 12 as the length
    80003eee:	00004c97          	auipc	s9,0x4
    80003ef2:	862c8c93          	addi	s9,s9,-1950 # 80007750 <etext+0x750>
    80003ef6:	a069                	j	80003f80 <exec+0x2f4>
    char *mask_str = argv[i + 1];
    80003ef8:	00198793          	addi	a5,s3,1
    80003efc:	078e                	slli	a5,a5,0x3
    80003efe:	e0043683          	ld	a3,-512(s0)
    80003f02:	97b6                	add	a5,a5,a3
    80003f04:	6390                	ld	a2,0(a5)
    while (*mask_str && *mask_str >= '0' && *mask_str <= '9') {
    80003f06:	00064783          	lbu	a5,0(a2) # 2000 <_entry-0x7fffe000>
    80003f0a:	fd07869b          	addiw	a3,a5,-48
    80003f0e:	0ff6f693          	zext.b	a3,a3
    80003f12:	45a5                	li	a1,9
    80003f14:	02d5e463          	bltu	a1,a3,80003f3c <exec+0x2b0>
      mask = mask * 10 + (*mask_str - '0');
    80003f18:	0025169b          	slliw	a3,a0,0x2
    80003f1c:	9ea9                	addw	a3,a3,a0
    80003f1e:	0016969b          	slliw	a3,a3,0x1
    80003f22:	fd07879b          	addiw	a5,a5,-48
    80003f26:	00d7853b          	addw	a0,a5,a3
      mask_str++;
    80003f2a:	0605                	addi	a2,a2,1
    while (*mask_str && *mask_str >= '0' && *mask_str <= '9') {
    80003f2c:	00064783          	lbu	a5,0(a2)
    80003f30:	fd07869b          	addiw	a3,a5,-48
    80003f34:	0ff6f693          	zext.b	a3,a3
    80003f38:	fed5f0e3          	bgeu	a1,a3,80003f18 <exec+0x28c>
    80003f3c:	00349693          	slli	a3,s1,0x3
      p->trace_mask = mask;
    80003f40:	16aba423          	sw	a0,360(s7)
      for (int j = i; j < argc - 2; j++) {
    80003f44:	fffa8493          	addi	s1,s5,-1
    80003f48:	00977e63          	bgeu	a4,s1,80003f64 <exec+0x2d8>
    80003f4c:	00371793          	slli	a5,a4,0x3
    80003f50:	e0043703          	ld	a4,-512(s0)
    80003f54:	97ba                	add	a5,a5,a4
    80003f56:	9736                	add	a4,a4,a3
    80003f58:	1741                	addi	a4,a4,-16
        argv[j] = argv[j + 2];
    80003f5a:	6b90                	ld	a2,16(a5)
    80003f5c:	e390                	sd	a2,0(a5)
      for (int j = i; j < argc - 2; j++) {
    80003f5e:	07a1                	addi	a5,a5,8
    80003f60:	fee79de3          	bne	a5,a4,80003f5a <exec+0x2ce>
      argv[argc - 2] = 0;
    80003f64:	e0043783          	ld	a5,-512(s0)
    80003f68:	97b6                	add	a5,a5,a3
    80003f6a:	fe07b823          	sd	zero,-16(a5)
      argv[argc - 1] = 0;
    80003f6e:	fe07bc23          	sd	zero,-8(a5)
      break;
    80003f72:	a025                	j	80003f9a <exec+0x30e>
for (int i = 0; i < argc; i++) {
    80003f74:	00198793          	addi	a5,s3,1
    80003f78:	0a21                	addi	s4,s4,8
    80003f7a:	073a8063          	beq	s5,s3,80003fda <exec+0x34e>
    80003f7e:	89be                	mv	s3,a5
  if (strncmp(argv[i], "--trace-mask", 12) == 0 && i + 1 < argc) {  // Added 12 as the length
    80003f80:	4631                	li	a2,12
    80003f82:	85e6                	mv	a1,s9
    80003f84:	000a3503          	ld	a0,0(s4)
    80003f88:	a78fc0ef          	jal	80000200 <strncmp>
    80003f8c:	f565                	bnez	a0,80003f74 <exec+0x2e8>
    80003f8e:	0009871b          	sext.w	a4,s3
    80003f92:	0019879b          	addiw	a5,s3,1
    80003f96:	f697e1e3          	bltu	a5,s1,80003ef8 <exec+0x26c>
  sp -= (argc+1) * sizeof(uint64);
    80003f9a:	00148693          	addi	a3,s1,1
    80003f9e:	068e                	slli	a3,a3,0x3
    80003fa0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003fa4:	ff097993          	andi	s3,s2,-16
  sz = sz1;
    80003fa8:	e0843903          	ld	s2,-504(s0)
  if(sp < stackbase)
    80003fac:	eb89e9e3          	bltu	s3,s8,80003e5e <exec+0x1d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003fb0:	e9040613          	addi	a2,s0,-368
    80003fb4:	85ce                	mv	a1,s3
    80003fb6:	855a                	mv	a0,s6
    80003fb8:	a0ffc0ef          	jal	800009c6 <copyout>
    80003fbc:	0e054663          	bltz	a0,800040a8 <exec+0x41c>
  p->trapframe->a1 = sp;
    80003fc0:	058bb783          	ld	a5,88(s7)
    80003fc4:	0737bc23          	sd	s3,120(a5)
  for(last=s=path; *s; s++)
    80003fc8:	df843783          	ld	a5,-520(s0)
    80003fcc:	0007c703          	lbu	a4,0(a5)
    80003fd0:	c305                	beqz	a4,80003ff0 <exec+0x364>
    80003fd2:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003fd4:	02f00693          	li	a3,47
    80003fd8:	a809                	j	80003fea <exec+0x35e>
    80003fda:	84be                	mv	s1,a5
    80003fdc:	bf7d                	j	80003f9a <exec+0x30e>
      last = s+1;
    80003fde:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003fe2:	0785                	addi	a5,a5,1
    80003fe4:	fff7c703          	lbu	a4,-1(a5)
    80003fe8:	c701                	beqz	a4,80003ff0 <exec+0x364>
    if(*s == '/')
    80003fea:	fed71ce3          	bne	a4,a3,80003fe2 <exec+0x356>
    80003fee:	bfc5                	j	80003fde <exec+0x352>
  safestrcpy(p->name, last, sizeof(p->name));
    80003ff0:	4641                	li	a2,16
    80003ff2:	df843583          	ld	a1,-520(s0)
    80003ff6:	158b8513          	addi	a0,s7,344
    80003ffa:	a78fc0ef          	jal	80000272 <safestrcpy>
  oldpagetable = p->pagetable;
    80003ffe:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004002:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004006:	e0843783          	ld	a5,-504(s0)
    8000400a:	04fbb423          	sd	a5,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000400e:	058bb783          	ld	a5,88(s7)
    80004012:	e6843703          	ld	a4,-408(s0)
    80004016:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004018:	058bb783          	ld	a5,88(s7)
    8000401c:	0337b823          	sd	s3,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004020:	85ea                	mv	a1,s10
    80004022:	e61fc0ef          	jal	80000e82 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004026:	0004851b          	sext.w	a0,s1
    8000402a:	79be                	ld	s3,488(sp)
    8000402c:	7a1e                	ld	s4,480(sp)
    8000402e:	6afe                	ld	s5,472(sp)
    80004030:	6b5e                	ld	s6,464(sp)
    80004032:	6bbe                	ld	s7,456(sp)
    80004034:	6c1e                	ld	s8,448(sp)
    80004036:	7cfa                	ld	s9,440(sp)
    80004038:	7d5a                	ld	s10,432(sp)
    8000403a:	b1c1                	j	80003cfa <exec+0x6e>
    8000403c:	e0943423          	sd	s1,-504(s0)
    80004040:	7dba                	ld	s11,424(sp)
    80004042:	a805                	j	80004072 <exec+0x3e6>
    80004044:	e0943423          	sd	s1,-504(s0)
    80004048:	7dba                	ld	s11,424(sp)
    8000404a:	a025                	j	80004072 <exec+0x3e6>
    8000404c:	e0943423          	sd	s1,-504(s0)
    80004050:	7dba                	ld	s11,424(sp)
    80004052:	a005                	j	80004072 <exec+0x3e6>
    80004054:	e0943423          	sd	s1,-504(s0)
    80004058:	7dba                	ld	s11,424(sp)
    8000405a:	a821                	j	80004072 <exec+0x3e6>
    8000405c:	e0943423          	sd	s1,-504(s0)
    80004060:	7dba                	ld	s11,424(sp)
    80004062:	a801                	j	80004072 <exec+0x3e6>
  ip = 0;
    80004064:	4a01                	li	s4,0
    80004066:	a031                	j	80004072 <exec+0x3e6>
    80004068:	4a01                	li	s4,0
    8000406a:	a021                	j	80004072 <exec+0x3e6>
    8000406c:	4a01                	li	s4,0
  if(pagetable)
    8000406e:	a011                	j	80004072 <exec+0x3e6>
    80004070:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004072:	e0843583          	ld	a1,-504(s0)
    80004076:	855a                	mv	a0,s6
    80004078:	e0bfc0ef          	jal	80000e82 <proc_freepagetable>
  return -1;
    8000407c:	557d                	li	a0,-1
  if(ip){
    8000407e:	000a1b63          	bnez	s4,80004094 <exec+0x408>
    80004082:	79be                	ld	s3,488(sp)
    80004084:	7a1e                	ld	s4,480(sp)
    80004086:	6afe                	ld	s5,472(sp)
    80004088:	6b5e                	ld	s6,464(sp)
    8000408a:	6bbe                	ld	s7,456(sp)
    8000408c:	6c1e                	ld	s8,448(sp)
    8000408e:	7cfa                	ld	s9,440(sp)
    80004090:	7d5a                	ld	s10,432(sp)
    80004092:	b1a5                	j	80003cfa <exec+0x6e>
    80004094:	79be                	ld	s3,488(sp)
    80004096:	6afe                	ld	s5,472(sp)
    80004098:	6b5e                	ld	s6,464(sp)
    8000409a:	6bbe                	ld	s7,456(sp)
    8000409c:	6c1e                	ld	s8,448(sp)
    8000409e:	7cfa                	ld	s9,440(sp)
    800040a0:	7d5a                	ld	s10,432(sp)
    800040a2:	b1a9                	j	80003cec <exec+0x60>
    800040a4:	6b5e                	ld	s6,464(sp)
    800040a6:	b199                	j	80003cec <exec+0x60>
  sz = sz1;
    800040a8:	e0843903          	ld	s2,-504(s0)
    800040ac:	bb4d                	j	80003e5e <exec+0x1d2>
  ustack[argc] = 0;
    800040ae:	e8043823          	sd	zero,-368(s0)
  sp = sz;
    800040b2:	e0843903          	ld	s2,-504(s0)
  ustack[argc] = 0;
    800040b6:	4481                	li	s1,0
    800040b8:	b5cd                	j	80003f9a <exec+0x30e>

00000000800040ba <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800040ba:	7179                	addi	sp,sp,-48
    800040bc:	f406                	sd	ra,40(sp)
    800040be:	f022                	sd	s0,32(sp)
    800040c0:	ec26                	sd	s1,24(sp)
    800040c2:	e84a                	sd	s2,16(sp)
    800040c4:	1800                	addi	s0,sp,48
    800040c6:	892e                	mv	s2,a1
    800040c8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800040ca:	fdc40593          	addi	a1,s0,-36
    800040ce:	c37fd0ef          	jal	80001d04 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800040d2:	fdc42703          	lw	a4,-36(s0)
    800040d6:	47bd                	li	a5,15
    800040d8:	02e7e963          	bltu	a5,a4,8000410a <argfd+0x50>
    800040dc:	c7bfc0ef          	jal	80000d56 <myproc>
    800040e0:	fdc42703          	lw	a4,-36(s0)
    800040e4:	01a70793          	addi	a5,a4,26
    800040e8:	078e                	slli	a5,a5,0x3
    800040ea:	953e                	add	a0,a0,a5
    800040ec:	611c                	ld	a5,0(a0)
    800040ee:	c385                	beqz	a5,8000410e <argfd+0x54>
    return -1;
  if(pfd)
    800040f0:	00090463          	beqz	s2,800040f8 <argfd+0x3e>
    *pfd = fd;
    800040f4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800040f8:	4501                	li	a0,0
  if(pf)
    800040fa:	c091                	beqz	s1,800040fe <argfd+0x44>
    *pf = f;
    800040fc:	e09c                	sd	a5,0(s1)
}
    800040fe:	70a2                	ld	ra,40(sp)
    80004100:	7402                	ld	s0,32(sp)
    80004102:	64e2                	ld	s1,24(sp)
    80004104:	6942                	ld	s2,16(sp)
    80004106:	6145                	addi	sp,sp,48
    80004108:	8082                	ret
    return -1;
    8000410a:	557d                	li	a0,-1
    8000410c:	bfcd                	j	800040fe <argfd+0x44>
    8000410e:	557d                	li	a0,-1
    80004110:	b7fd                	j	800040fe <argfd+0x44>

0000000080004112 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004112:	1101                	addi	sp,sp,-32
    80004114:	ec06                	sd	ra,24(sp)
    80004116:	e822                	sd	s0,16(sp)
    80004118:	e426                	sd	s1,8(sp)
    8000411a:	1000                	addi	s0,sp,32
    8000411c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000411e:	c39fc0ef          	jal	80000d56 <myproc>
    80004122:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004124:	0d050793          	addi	a5,a0,208
    80004128:	4501                	li	a0,0
    8000412a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000412c:	6398                	ld	a4,0(a5)
    8000412e:	cb19                	beqz	a4,80004144 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004130:	2505                	addiw	a0,a0,1
    80004132:	07a1                	addi	a5,a5,8
    80004134:	fed51ce3          	bne	a0,a3,8000412c <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004138:	557d                	li	a0,-1
}
    8000413a:	60e2                	ld	ra,24(sp)
    8000413c:	6442                	ld	s0,16(sp)
    8000413e:	64a2                	ld	s1,8(sp)
    80004140:	6105                	addi	sp,sp,32
    80004142:	8082                	ret
      p->ofile[fd] = f;
    80004144:	01a50793          	addi	a5,a0,26
    80004148:	078e                	slli	a5,a5,0x3
    8000414a:	963e                	add	a2,a2,a5
    8000414c:	e204                	sd	s1,0(a2)
      return fd;
    8000414e:	b7f5                	j	8000413a <fdalloc+0x28>

0000000080004150 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004150:	715d                	addi	sp,sp,-80
    80004152:	e486                	sd	ra,72(sp)
    80004154:	e0a2                	sd	s0,64(sp)
    80004156:	fc26                	sd	s1,56(sp)
    80004158:	f84a                	sd	s2,48(sp)
    8000415a:	f44e                	sd	s3,40(sp)
    8000415c:	ec56                	sd	s5,24(sp)
    8000415e:	e85a                	sd	s6,16(sp)
    80004160:	0880                	addi	s0,sp,80
    80004162:	8b2e                	mv	s6,a1
    80004164:	89b2                	mv	s3,a2
    80004166:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004168:	fb040593          	addi	a1,s0,-80
    8000416c:	f67fe0ef          	jal	800030d2 <nameiparent>
    80004170:	84aa                	mv	s1,a0
    80004172:	10050a63          	beqz	a0,80004286 <create+0x136>
    return 0;

  ilock(dp);
    80004176:	869fe0ef          	jal	800029de <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000417a:	4601                	li	a2,0
    8000417c:	fb040593          	addi	a1,s0,-80
    80004180:	8526                	mv	a0,s1
    80004182:	cd1fe0ef          	jal	80002e52 <dirlookup>
    80004186:	8aaa                	mv	s5,a0
    80004188:	c129                	beqz	a0,800041ca <create+0x7a>
    iunlockput(dp);
    8000418a:	8526                	mv	a0,s1
    8000418c:	a5dfe0ef          	jal	80002be8 <iunlockput>
    ilock(ip);
    80004190:	8556                	mv	a0,s5
    80004192:	84dfe0ef          	jal	800029de <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004196:	4789                	li	a5,2
    80004198:	02fb1463          	bne	s6,a5,800041c0 <create+0x70>
    8000419c:	044ad783          	lhu	a5,68(s5)
    800041a0:	37f9                	addiw	a5,a5,-2
    800041a2:	17c2                	slli	a5,a5,0x30
    800041a4:	93c1                	srli	a5,a5,0x30
    800041a6:	4705                	li	a4,1
    800041a8:	00f76c63          	bltu	a4,a5,800041c0 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800041ac:	8556                	mv	a0,s5
    800041ae:	60a6                	ld	ra,72(sp)
    800041b0:	6406                	ld	s0,64(sp)
    800041b2:	74e2                	ld	s1,56(sp)
    800041b4:	7942                	ld	s2,48(sp)
    800041b6:	79a2                	ld	s3,40(sp)
    800041b8:	6ae2                	ld	s5,24(sp)
    800041ba:	6b42                	ld	s6,16(sp)
    800041bc:	6161                	addi	sp,sp,80
    800041be:	8082                	ret
    iunlockput(ip);
    800041c0:	8556                	mv	a0,s5
    800041c2:	a27fe0ef          	jal	80002be8 <iunlockput>
    return 0;
    800041c6:	4a81                	li	s5,0
    800041c8:	b7d5                	j	800041ac <create+0x5c>
    800041ca:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800041cc:	85da                	mv	a1,s6
    800041ce:	4088                	lw	a0,0(s1)
    800041d0:	e9efe0ef          	jal	8000286e <ialloc>
    800041d4:	8a2a                	mv	s4,a0
    800041d6:	cd15                	beqz	a0,80004212 <create+0xc2>
  ilock(ip);
    800041d8:	807fe0ef          	jal	800029de <ilock>
  ip->major = major;
    800041dc:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800041e0:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800041e4:	4905                	li	s2,1
    800041e6:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800041ea:	8552                	mv	a0,s4
    800041ec:	f3efe0ef          	jal	8000292a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800041f0:	032b0763          	beq	s6,s2,8000421e <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    800041f4:	004a2603          	lw	a2,4(s4)
    800041f8:	fb040593          	addi	a1,s0,-80
    800041fc:	8526                	mv	a0,s1
    800041fe:	e21fe0ef          	jal	8000301e <dirlink>
    80004202:	06054563          	bltz	a0,8000426c <create+0x11c>
  iunlockput(dp);
    80004206:	8526                	mv	a0,s1
    80004208:	9e1fe0ef          	jal	80002be8 <iunlockput>
  return ip;
    8000420c:	8ad2                	mv	s5,s4
    8000420e:	7a02                	ld	s4,32(sp)
    80004210:	bf71                	j	800041ac <create+0x5c>
    iunlockput(dp);
    80004212:	8526                	mv	a0,s1
    80004214:	9d5fe0ef          	jal	80002be8 <iunlockput>
    return 0;
    80004218:	8ad2                	mv	s5,s4
    8000421a:	7a02                	ld	s4,32(sp)
    8000421c:	bf41                	j	800041ac <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000421e:	004a2603          	lw	a2,4(s4)
    80004222:	00003597          	auipc	a1,0x3
    80004226:	53e58593          	addi	a1,a1,1342 # 80007760 <etext+0x760>
    8000422a:	8552                	mv	a0,s4
    8000422c:	df3fe0ef          	jal	8000301e <dirlink>
    80004230:	02054e63          	bltz	a0,8000426c <create+0x11c>
    80004234:	40d0                	lw	a2,4(s1)
    80004236:	00003597          	auipc	a1,0x3
    8000423a:	53258593          	addi	a1,a1,1330 # 80007768 <etext+0x768>
    8000423e:	8552                	mv	a0,s4
    80004240:	ddffe0ef          	jal	8000301e <dirlink>
    80004244:	02054463          	bltz	a0,8000426c <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004248:	004a2603          	lw	a2,4(s4)
    8000424c:	fb040593          	addi	a1,s0,-80
    80004250:	8526                	mv	a0,s1
    80004252:	dcdfe0ef          	jal	8000301e <dirlink>
    80004256:	00054b63          	bltz	a0,8000426c <create+0x11c>
    dp->nlink++;  // for ".."
    8000425a:	04a4d783          	lhu	a5,74(s1)
    8000425e:	2785                	addiw	a5,a5,1
    80004260:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004264:	8526                	mv	a0,s1
    80004266:	ec4fe0ef          	jal	8000292a <iupdate>
    8000426a:	bf71                	j	80004206 <create+0xb6>
  ip->nlink = 0;
    8000426c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004270:	8552                	mv	a0,s4
    80004272:	eb8fe0ef          	jal	8000292a <iupdate>
  iunlockput(ip);
    80004276:	8552                	mv	a0,s4
    80004278:	971fe0ef          	jal	80002be8 <iunlockput>
  iunlockput(dp);
    8000427c:	8526                	mv	a0,s1
    8000427e:	96bfe0ef          	jal	80002be8 <iunlockput>
  return 0;
    80004282:	7a02                	ld	s4,32(sp)
    80004284:	b725                	j	800041ac <create+0x5c>
    return 0;
    80004286:	8aaa                	mv	s5,a0
    80004288:	b715                	j	800041ac <create+0x5c>

000000008000428a <sys_dup>:
{
    8000428a:	7179                	addi	sp,sp,-48
    8000428c:	f406                	sd	ra,40(sp)
    8000428e:	f022                	sd	s0,32(sp)
    80004290:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004292:	fd840613          	addi	a2,s0,-40
    80004296:	4581                	li	a1,0
    80004298:	4501                	li	a0,0
    8000429a:	e21ff0ef          	jal	800040ba <argfd>
    return -1;
    8000429e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800042a0:	02054363          	bltz	a0,800042c6 <sys_dup+0x3c>
    800042a4:	ec26                	sd	s1,24(sp)
    800042a6:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800042a8:	fd843903          	ld	s2,-40(s0)
    800042ac:	854a                	mv	a0,s2
    800042ae:	e65ff0ef          	jal	80004112 <fdalloc>
    800042b2:	84aa                	mv	s1,a0
    return -1;
    800042b4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800042b6:	00054d63          	bltz	a0,800042d0 <sys_dup+0x46>
  filedup(f);
    800042ba:	854a                	mv	a0,s2
    800042bc:	b8cff0ef          	jal	80003648 <filedup>
  return fd;
    800042c0:	87a6                	mv	a5,s1
    800042c2:	64e2                	ld	s1,24(sp)
    800042c4:	6942                	ld	s2,16(sp)
}
    800042c6:	853e                	mv	a0,a5
    800042c8:	70a2                	ld	ra,40(sp)
    800042ca:	7402                	ld	s0,32(sp)
    800042cc:	6145                	addi	sp,sp,48
    800042ce:	8082                	ret
    800042d0:	64e2                	ld	s1,24(sp)
    800042d2:	6942                	ld	s2,16(sp)
    800042d4:	bfcd                	j	800042c6 <sys_dup+0x3c>

00000000800042d6 <sys_read>:
{
    800042d6:	7179                	addi	sp,sp,-48
    800042d8:	f406                	sd	ra,40(sp)
    800042da:	f022                	sd	s0,32(sp)
    800042dc:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800042de:	fd840593          	addi	a1,s0,-40
    800042e2:	4505                	li	a0,1
    800042e4:	ac3fd0ef          	jal	80001da6 <argaddr>
  argint(2, &n);
    800042e8:	fe440593          	addi	a1,s0,-28
    800042ec:	4509                	li	a0,2
    800042ee:	a17fd0ef          	jal	80001d04 <argint>
  if(argfd(0, 0, &f) < 0)
    800042f2:	fe840613          	addi	a2,s0,-24
    800042f6:	4581                	li	a1,0
    800042f8:	4501                	li	a0,0
    800042fa:	dc1ff0ef          	jal	800040ba <argfd>
    800042fe:	87aa                	mv	a5,a0
    return -1;
    80004300:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004302:	0007ca63          	bltz	a5,80004316 <sys_read+0x40>
  return fileread(f, p, n);
    80004306:	fe442603          	lw	a2,-28(s0)
    8000430a:	fd843583          	ld	a1,-40(s0)
    8000430e:	fe843503          	ld	a0,-24(s0)
    80004312:	c9cff0ef          	jal	800037ae <fileread>
}
    80004316:	70a2                	ld	ra,40(sp)
    80004318:	7402                	ld	s0,32(sp)
    8000431a:	6145                	addi	sp,sp,48
    8000431c:	8082                	ret

000000008000431e <sys_write>:
{
    8000431e:	7179                	addi	sp,sp,-48
    80004320:	f406                	sd	ra,40(sp)
    80004322:	f022                	sd	s0,32(sp)
    80004324:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004326:	fd840593          	addi	a1,s0,-40
    8000432a:	4505                	li	a0,1
    8000432c:	a7bfd0ef          	jal	80001da6 <argaddr>
  argint(2, &n);
    80004330:	fe440593          	addi	a1,s0,-28
    80004334:	4509                	li	a0,2
    80004336:	9cffd0ef          	jal	80001d04 <argint>
  if(argfd(0, 0, &f) < 0)
    8000433a:	fe840613          	addi	a2,s0,-24
    8000433e:	4581                	li	a1,0
    80004340:	4501                	li	a0,0
    80004342:	d79ff0ef          	jal	800040ba <argfd>
    80004346:	87aa                	mv	a5,a0
    return -1;
    80004348:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000434a:	0007ca63          	bltz	a5,8000435e <sys_write+0x40>
  return filewrite(f, p, n);
    8000434e:	fe442603          	lw	a2,-28(s0)
    80004352:	fd843583          	ld	a1,-40(s0)
    80004356:	fe843503          	ld	a0,-24(s0)
    8000435a:	d12ff0ef          	jal	8000386c <filewrite>
}
    8000435e:	70a2                	ld	ra,40(sp)
    80004360:	7402                	ld	s0,32(sp)
    80004362:	6145                	addi	sp,sp,48
    80004364:	8082                	ret

0000000080004366 <sys_close>:
{
    80004366:	1101                	addi	sp,sp,-32
    80004368:	ec06                	sd	ra,24(sp)
    8000436a:	e822                	sd	s0,16(sp)
    8000436c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000436e:	fe040613          	addi	a2,s0,-32
    80004372:	fec40593          	addi	a1,s0,-20
    80004376:	4501                	li	a0,0
    80004378:	d43ff0ef          	jal	800040ba <argfd>
    return -1;
    8000437c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000437e:	02054063          	bltz	a0,8000439e <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004382:	9d5fc0ef          	jal	80000d56 <myproc>
    80004386:	fec42783          	lw	a5,-20(s0)
    8000438a:	07e9                	addi	a5,a5,26
    8000438c:	078e                	slli	a5,a5,0x3
    8000438e:	953e                	add	a0,a0,a5
    80004390:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004394:	fe043503          	ld	a0,-32(s0)
    80004398:	af6ff0ef          	jal	8000368e <fileclose>
  return 0;
    8000439c:	4781                	li	a5,0
}
    8000439e:	853e                	mv	a0,a5
    800043a0:	60e2                	ld	ra,24(sp)
    800043a2:	6442                	ld	s0,16(sp)
    800043a4:	6105                	addi	sp,sp,32
    800043a6:	8082                	ret

00000000800043a8 <sys_fstat>:
{
    800043a8:	1101                	addi	sp,sp,-32
    800043aa:	ec06                	sd	ra,24(sp)
    800043ac:	e822                	sd	s0,16(sp)
    800043ae:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800043b0:	fe040593          	addi	a1,s0,-32
    800043b4:	4505                	li	a0,1
    800043b6:	9f1fd0ef          	jal	80001da6 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800043ba:	fe840613          	addi	a2,s0,-24
    800043be:	4581                	li	a1,0
    800043c0:	4501                	li	a0,0
    800043c2:	cf9ff0ef          	jal	800040ba <argfd>
    800043c6:	87aa                	mv	a5,a0
    return -1;
    800043c8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800043ca:	0007c863          	bltz	a5,800043da <sys_fstat+0x32>
  return filestat(f, st);
    800043ce:	fe043583          	ld	a1,-32(s0)
    800043d2:	fe843503          	ld	a0,-24(s0)
    800043d6:	b7aff0ef          	jal	80003750 <filestat>
}
    800043da:	60e2                	ld	ra,24(sp)
    800043dc:	6442                	ld	s0,16(sp)
    800043de:	6105                	addi	sp,sp,32
    800043e0:	8082                	ret

00000000800043e2 <sys_link>:
{
    800043e2:	7169                	addi	sp,sp,-304
    800043e4:	f606                	sd	ra,296(sp)
    800043e6:	f222                	sd	s0,288(sp)
    800043e8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800043ea:	08000613          	li	a2,128
    800043ee:	ed040593          	addi	a1,s0,-304
    800043f2:	4501                	li	a0,0
    800043f4:	9c7fd0ef          	jal	80001dba <argstr>
    return -1;
    800043f8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800043fa:	0c054e63          	bltz	a0,800044d6 <sys_link+0xf4>
    800043fe:	08000613          	li	a2,128
    80004402:	f5040593          	addi	a1,s0,-176
    80004406:	4505                	li	a0,1
    80004408:	9b3fd0ef          	jal	80001dba <argstr>
    return -1;
    8000440c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000440e:	0c054463          	bltz	a0,800044d6 <sys_link+0xf4>
    80004412:	ee26                	sd	s1,280(sp)
  begin_op();
    80004414:	e61fe0ef          	jal	80003274 <begin_op>
  if((ip = namei(old)) == 0){
    80004418:	ed040513          	addi	a0,s0,-304
    8000441c:	c9dfe0ef          	jal	800030b8 <namei>
    80004420:	84aa                	mv	s1,a0
    80004422:	c53d                	beqz	a0,80004490 <sys_link+0xae>
  ilock(ip);
    80004424:	dbafe0ef          	jal	800029de <ilock>
  if(ip->type == T_DIR){
    80004428:	04449703          	lh	a4,68(s1)
    8000442c:	4785                	li	a5,1
    8000442e:	06f70663          	beq	a4,a5,8000449a <sys_link+0xb8>
    80004432:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004434:	04a4d783          	lhu	a5,74(s1)
    80004438:	2785                	addiw	a5,a5,1
    8000443a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000443e:	8526                	mv	a0,s1
    80004440:	ceafe0ef          	jal	8000292a <iupdate>
  iunlock(ip);
    80004444:	8526                	mv	a0,s1
    80004446:	e46fe0ef          	jal	80002a8c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000444a:	fd040593          	addi	a1,s0,-48
    8000444e:	f5040513          	addi	a0,s0,-176
    80004452:	c81fe0ef          	jal	800030d2 <nameiparent>
    80004456:	892a                	mv	s2,a0
    80004458:	cd21                	beqz	a0,800044b0 <sys_link+0xce>
  ilock(dp);
    8000445a:	d84fe0ef          	jal	800029de <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000445e:	00092703          	lw	a4,0(s2)
    80004462:	409c                	lw	a5,0(s1)
    80004464:	04f71363          	bne	a4,a5,800044aa <sys_link+0xc8>
    80004468:	40d0                	lw	a2,4(s1)
    8000446a:	fd040593          	addi	a1,s0,-48
    8000446e:	854a                	mv	a0,s2
    80004470:	baffe0ef          	jal	8000301e <dirlink>
    80004474:	02054b63          	bltz	a0,800044aa <sys_link+0xc8>
  iunlockput(dp);
    80004478:	854a                	mv	a0,s2
    8000447a:	f6efe0ef          	jal	80002be8 <iunlockput>
  iput(ip);
    8000447e:	8526                	mv	a0,s1
    80004480:	ee0fe0ef          	jal	80002b60 <iput>
  end_op();
    80004484:	e5bfe0ef          	jal	800032de <end_op>
  return 0;
    80004488:	4781                	li	a5,0
    8000448a:	64f2                	ld	s1,280(sp)
    8000448c:	6952                	ld	s2,272(sp)
    8000448e:	a0a1                	j	800044d6 <sys_link+0xf4>
    end_op();
    80004490:	e4ffe0ef          	jal	800032de <end_op>
    return -1;
    80004494:	57fd                	li	a5,-1
    80004496:	64f2                	ld	s1,280(sp)
    80004498:	a83d                	j	800044d6 <sys_link+0xf4>
    iunlockput(ip);
    8000449a:	8526                	mv	a0,s1
    8000449c:	f4cfe0ef          	jal	80002be8 <iunlockput>
    end_op();
    800044a0:	e3ffe0ef          	jal	800032de <end_op>
    return -1;
    800044a4:	57fd                	li	a5,-1
    800044a6:	64f2                	ld	s1,280(sp)
    800044a8:	a03d                	j	800044d6 <sys_link+0xf4>
    iunlockput(dp);
    800044aa:	854a                	mv	a0,s2
    800044ac:	f3cfe0ef          	jal	80002be8 <iunlockput>
  ilock(ip);
    800044b0:	8526                	mv	a0,s1
    800044b2:	d2cfe0ef          	jal	800029de <ilock>
  ip->nlink--;
    800044b6:	04a4d783          	lhu	a5,74(s1)
    800044ba:	37fd                	addiw	a5,a5,-1
    800044bc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800044c0:	8526                	mv	a0,s1
    800044c2:	c68fe0ef          	jal	8000292a <iupdate>
  iunlockput(ip);
    800044c6:	8526                	mv	a0,s1
    800044c8:	f20fe0ef          	jal	80002be8 <iunlockput>
  end_op();
    800044cc:	e13fe0ef          	jal	800032de <end_op>
  return -1;
    800044d0:	57fd                	li	a5,-1
    800044d2:	64f2                	ld	s1,280(sp)
    800044d4:	6952                	ld	s2,272(sp)
}
    800044d6:	853e                	mv	a0,a5
    800044d8:	70b2                	ld	ra,296(sp)
    800044da:	7412                	ld	s0,288(sp)
    800044dc:	6155                	addi	sp,sp,304
    800044de:	8082                	ret

00000000800044e0 <sys_unlink>:
{
    800044e0:	7151                	addi	sp,sp,-240
    800044e2:	f586                	sd	ra,232(sp)
    800044e4:	f1a2                	sd	s0,224(sp)
    800044e6:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800044e8:	08000613          	li	a2,128
    800044ec:	f3040593          	addi	a1,s0,-208
    800044f0:	4501                	li	a0,0
    800044f2:	8c9fd0ef          	jal	80001dba <argstr>
    800044f6:	16054063          	bltz	a0,80004656 <sys_unlink+0x176>
    800044fa:	eda6                	sd	s1,216(sp)
  begin_op();
    800044fc:	d79fe0ef          	jal	80003274 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004500:	fb040593          	addi	a1,s0,-80
    80004504:	f3040513          	addi	a0,s0,-208
    80004508:	bcbfe0ef          	jal	800030d2 <nameiparent>
    8000450c:	84aa                	mv	s1,a0
    8000450e:	c945                	beqz	a0,800045be <sys_unlink+0xde>
  ilock(dp);
    80004510:	ccefe0ef          	jal	800029de <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004514:	00003597          	auipc	a1,0x3
    80004518:	24c58593          	addi	a1,a1,588 # 80007760 <etext+0x760>
    8000451c:	fb040513          	addi	a0,s0,-80
    80004520:	91dfe0ef          	jal	80002e3c <namecmp>
    80004524:	10050e63          	beqz	a0,80004640 <sys_unlink+0x160>
    80004528:	00003597          	auipc	a1,0x3
    8000452c:	24058593          	addi	a1,a1,576 # 80007768 <etext+0x768>
    80004530:	fb040513          	addi	a0,s0,-80
    80004534:	909fe0ef          	jal	80002e3c <namecmp>
    80004538:	10050463          	beqz	a0,80004640 <sys_unlink+0x160>
    8000453c:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000453e:	f2c40613          	addi	a2,s0,-212
    80004542:	fb040593          	addi	a1,s0,-80
    80004546:	8526                	mv	a0,s1
    80004548:	90bfe0ef          	jal	80002e52 <dirlookup>
    8000454c:	892a                	mv	s2,a0
    8000454e:	0e050863          	beqz	a0,8000463e <sys_unlink+0x15e>
  ilock(ip);
    80004552:	c8cfe0ef          	jal	800029de <ilock>
  if(ip->nlink < 1)
    80004556:	04a91783          	lh	a5,74(s2)
    8000455a:	06f05763          	blez	a5,800045c8 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000455e:	04491703          	lh	a4,68(s2)
    80004562:	4785                	li	a5,1
    80004564:	06f70963          	beq	a4,a5,800045d6 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004568:	4641                	li	a2,16
    8000456a:	4581                	li	a1,0
    8000456c:	fc040513          	addi	a0,s0,-64
    80004570:	bc5fb0ef          	jal	80000134 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004574:	4741                	li	a4,16
    80004576:	f2c42683          	lw	a3,-212(s0)
    8000457a:	fc040613          	addi	a2,s0,-64
    8000457e:	4581                	li	a1,0
    80004580:	8526                	mv	a0,s1
    80004582:	facfe0ef          	jal	80002d2e <writei>
    80004586:	47c1                	li	a5,16
    80004588:	08f51b63          	bne	a0,a5,8000461e <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    8000458c:	04491703          	lh	a4,68(s2)
    80004590:	4785                	li	a5,1
    80004592:	08f70d63          	beq	a4,a5,8000462c <sys_unlink+0x14c>
  iunlockput(dp);
    80004596:	8526                	mv	a0,s1
    80004598:	e50fe0ef          	jal	80002be8 <iunlockput>
  ip->nlink--;
    8000459c:	04a95783          	lhu	a5,74(s2)
    800045a0:	37fd                	addiw	a5,a5,-1
    800045a2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800045a6:	854a                	mv	a0,s2
    800045a8:	b82fe0ef          	jal	8000292a <iupdate>
  iunlockput(ip);
    800045ac:	854a                	mv	a0,s2
    800045ae:	e3afe0ef          	jal	80002be8 <iunlockput>
  end_op();
    800045b2:	d2dfe0ef          	jal	800032de <end_op>
  return 0;
    800045b6:	4501                	li	a0,0
    800045b8:	64ee                	ld	s1,216(sp)
    800045ba:	694e                	ld	s2,208(sp)
    800045bc:	a849                	j	8000464e <sys_unlink+0x16e>
    end_op();
    800045be:	d21fe0ef          	jal	800032de <end_op>
    return -1;
    800045c2:	557d                	li	a0,-1
    800045c4:	64ee                	ld	s1,216(sp)
    800045c6:	a061                	j	8000464e <sys_unlink+0x16e>
    800045c8:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    800045ca:	00003517          	auipc	a0,0x3
    800045ce:	1a650513          	addi	a0,a0,422 # 80007770 <etext+0x770>
    800045d2:	260010ef          	jal	80005832 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800045d6:	04c92703          	lw	a4,76(s2)
    800045da:	02000793          	li	a5,32
    800045de:	f8e7f5e3          	bgeu	a5,a4,80004568 <sys_unlink+0x88>
    800045e2:	e5ce                	sd	s3,200(sp)
    800045e4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800045e8:	4741                	li	a4,16
    800045ea:	86ce                	mv	a3,s3
    800045ec:	f1840613          	addi	a2,s0,-232
    800045f0:	4581                	li	a1,0
    800045f2:	854a                	mv	a0,s2
    800045f4:	e3efe0ef          	jal	80002c32 <readi>
    800045f8:	47c1                	li	a5,16
    800045fa:	00f51c63          	bne	a0,a5,80004612 <sys_unlink+0x132>
    if(de.inum != 0)
    800045fe:	f1845783          	lhu	a5,-232(s0)
    80004602:	efa1                	bnez	a5,8000465a <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004604:	29c1                	addiw	s3,s3,16
    80004606:	04c92783          	lw	a5,76(s2)
    8000460a:	fcf9efe3          	bltu	s3,a5,800045e8 <sys_unlink+0x108>
    8000460e:	69ae                	ld	s3,200(sp)
    80004610:	bfa1                	j	80004568 <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004612:	00003517          	auipc	a0,0x3
    80004616:	17650513          	addi	a0,a0,374 # 80007788 <etext+0x788>
    8000461a:	218010ef          	jal	80005832 <panic>
    8000461e:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004620:	00003517          	auipc	a0,0x3
    80004624:	18050513          	addi	a0,a0,384 # 800077a0 <etext+0x7a0>
    80004628:	20a010ef          	jal	80005832 <panic>
    dp->nlink--;
    8000462c:	04a4d783          	lhu	a5,74(s1)
    80004630:	37fd                	addiw	a5,a5,-1
    80004632:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004636:	8526                	mv	a0,s1
    80004638:	af2fe0ef          	jal	8000292a <iupdate>
    8000463c:	bfa9                	j	80004596 <sys_unlink+0xb6>
    8000463e:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004640:	8526                	mv	a0,s1
    80004642:	da6fe0ef          	jal	80002be8 <iunlockput>
  end_op();
    80004646:	c99fe0ef          	jal	800032de <end_op>
  return -1;
    8000464a:	557d                	li	a0,-1
    8000464c:	64ee                	ld	s1,216(sp)
}
    8000464e:	70ae                	ld	ra,232(sp)
    80004650:	740e                	ld	s0,224(sp)
    80004652:	616d                	addi	sp,sp,240
    80004654:	8082                	ret
    return -1;
    80004656:	557d                	li	a0,-1
    80004658:	bfdd                	j	8000464e <sys_unlink+0x16e>
    iunlockput(ip);
    8000465a:	854a                	mv	a0,s2
    8000465c:	d8cfe0ef          	jal	80002be8 <iunlockput>
    goto bad;
    80004660:	694e                	ld	s2,208(sp)
    80004662:	69ae                	ld	s3,200(sp)
    80004664:	bff1                	j	80004640 <sys_unlink+0x160>

0000000080004666 <sys_open>:

uint64
sys_open(void)
{
    80004666:	7131                	addi	sp,sp,-192
    80004668:	fd06                	sd	ra,184(sp)
    8000466a:	f922                	sd	s0,176(sp)
    8000466c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000466e:	f4c40593          	addi	a1,s0,-180
    80004672:	4505                	li	a0,1
    80004674:	e90fd0ef          	jal	80001d04 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004678:	08000613          	li	a2,128
    8000467c:	f5040593          	addi	a1,s0,-176
    80004680:	4501                	li	a0,0
    80004682:	f38fd0ef          	jal	80001dba <argstr>
    80004686:	87aa                	mv	a5,a0
    return -1;
    80004688:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000468a:	0a07c263          	bltz	a5,8000472e <sys_open+0xc8>
    8000468e:	f526                	sd	s1,168(sp)

  begin_op();
    80004690:	be5fe0ef          	jal	80003274 <begin_op>

  if(omode & O_CREATE){
    80004694:	f4c42783          	lw	a5,-180(s0)
    80004698:	2007f793          	andi	a5,a5,512
    8000469c:	c3d5                	beqz	a5,80004740 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    8000469e:	4681                	li	a3,0
    800046a0:	4601                	li	a2,0
    800046a2:	4589                	li	a1,2
    800046a4:	f5040513          	addi	a0,s0,-176
    800046a8:	aa9ff0ef          	jal	80004150 <create>
    800046ac:	84aa                	mv	s1,a0
    if(ip == 0){
    800046ae:	c541                	beqz	a0,80004736 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800046b0:	04449703          	lh	a4,68(s1)
    800046b4:	478d                	li	a5,3
    800046b6:	00f71763          	bne	a4,a5,800046c4 <sys_open+0x5e>
    800046ba:	0464d703          	lhu	a4,70(s1)
    800046be:	47a5                	li	a5,9
    800046c0:	0ae7ed63          	bltu	a5,a4,8000477a <sys_open+0x114>
    800046c4:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800046c6:	f25fe0ef          	jal	800035ea <filealloc>
    800046ca:	892a                	mv	s2,a0
    800046cc:	c179                	beqz	a0,80004792 <sys_open+0x12c>
    800046ce:	ed4e                	sd	s3,152(sp)
    800046d0:	a43ff0ef          	jal	80004112 <fdalloc>
    800046d4:	89aa                	mv	s3,a0
    800046d6:	0a054a63          	bltz	a0,8000478a <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800046da:	04449703          	lh	a4,68(s1)
    800046de:	478d                	li	a5,3
    800046e0:	0cf70263          	beq	a4,a5,800047a4 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800046e4:	4789                	li	a5,2
    800046e6:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800046ea:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800046ee:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800046f2:	f4c42783          	lw	a5,-180(s0)
    800046f6:	0017c713          	xori	a4,a5,1
    800046fa:	8b05                	andi	a4,a4,1
    800046fc:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004700:	0037f713          	andi	a4,a5,3
    80004704:	00e03733          	snez	a4,a4
    80004708:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000470c:	4007f793          	andi	a5,a5,1024
    80004710:	c791                	beqz	a5,8000471c <sys_open+0xb6>
    80004712:	04449703          	lh	a4,68(s1)
    80004716:	4789                	li	a5,2
    80004718:	08f70d63          	beq	a4,a5,800047b2 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    8000471c:	8526                	mv	a0,s1
    8000471e:	b6efe0ef          	jal	80002a8c <iunlock>
  end_op();
    80004722:	bbdfe0ef          	jal	800032de <end_op>

  return fd;
    80004726:	854e                	mv	a0,s3
    80004728:	74aa                	ld	s1,168(sp)
    8000472a:	790a                	ld	s2,160(sp)
    8000472c:	69ea                	ld	s3,152(sp)
}
    8000472e:	70ea                	ld	ra,184(sp)
    80004730:	744a                	ld	s0,176(sp)
    80004732:	6129                	addi	sp,sp,192
    80004734:	8082                	ret
      end_op();
    80004736:	ba9fe0ef          	jal	800032de <end_op>
      return -1;
    8000473a:	557d                	li	a0,-1
    8000473c:	74aa                	ld	s1,168(sp)
    8000473e:	bfc5                	j	8000472e <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004740:	f5040513          	addi	a0,s0,-176
    80004744:	975fe0ef          	jal	800030b8 <namei>
    80004748:	84aa                	mv	s1,a0
    8000474a:	c11d                	beqz	a0,80004770 <sys_open+0x10a>
    ilock(ip);
    8000474c:	a92fe0ef          	jal	800029de <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004750:	04449703          	lh	a4,68(s1)
    80004754:	4785                	li	a5,1
    80004756:	f4f71de3          	bne	a4,a5,800046b0 <sys_open+0x4a>
    8000475a:	f4c42783          	lw	a5,-180(s0)
    8000475e:	d3bd                	beqz	a5,800046c4 <sys_open+0x5e>
      iunlockput(ip);
    80004760:	8526                	mv	a0,s1
    80004762:	c86fe0ef          	jal	80002be8 <iunlockput>
      end_op();
    80004766:	b79fe0ef          	jal	800032de <end_op>
      return -1;
    8000476a:	557d                	li	a0,-1
    8000476c:	74aa                	ld	s1,168(sp)
    8000476e:	b7c1                	j	8000472e <sys_open+0xc8>
      end_op();
    80004770:	b6ffe0ef          	jal	800032de <end_op>
      return -1;
    80004774:	557d                	li	a0,-1
    80004776:	74aa                	ld	s1,168(sp)
    80004778:	bf5d                	j	8000472e <sys_open+0xc8>
    iunlockput(ip);
    8000477a:	8526                	mv	a0,s1
    8000477c:	c6cfe0ef          	jal	80002be8 <iunlockput>
    end_op();
    80004780:	b5ffe0ef          	jal	800032de <end_op>
    return -1;
    80004784:	557d                	li	a0,-1
    80004786:	74aa                	ld	s1,168(sp)
    80004788:	b75d                	j	8000472e <sys_open+0xc8>
      fileclose(f);
    8000478a:	854a                	mv	a0,s2
    8000478c:	f03fe0ef          	jal	8000368e <fileclose>
    80004790:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004792:	8526                	mv	a0,s1
    80004794:	c54fe0ef          	jal	80002be8 <iunlockput>
    end_op();
    80004798:	b47fe0ef          	jal	800032de <end_op>
    return -1;
    8000479c:	557d                	li	a0,-1
    8000479e:	74aa                	ld	s1,168(sp)
    800047a0:	790a                	ld	s2,160(sp)
    800047a2:	b771                	j	8000472e <sys_open+0xc8>
    f->type = FD_DEVICE;
    800047a4:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800047a8:	04649783          	lh	a5,70(s1)
    800047ac:	02f91223          	sh	a5,36(s2)
    800047b0:	bf3d                	j	800046ee <sys_open+0x88>
    itrunc(ip);
    800047b2:	8526                	mv	a0,s1
    800047b4:	b18fe0ef          	jal	80002acc <itrunc>
    800047b8:	b795                	j	8000471c <sys_open+0xb6>

00000000800047ba <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800047ba:	7175                	addi	sp,sp,-144
    800047bc:	e506                	sd	ra,136(sp)
    800047be:	e122                	sd	s0,128(sp)
    800047c0:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800047c2:	ab3fe0ef          	jal	80003274 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800047c6:	08000613          	li	a2,128
    800047ca:	f7040593          	addi	a1,s0,-144
    800047ce:	4501                	li	a0,0
    800047d0:	deafd0ef          	jal	80001dba <argstr>
    800047d4:	02054363          	bltz	a0,800047fa <sys_mkdir+0x40>
    800047d8:	4681                	li	a3,0
    800047da:	4601                	li	a2,0
    800047dc:	4585                	li	a1,1
    800047de:	f7040513          	addi	a0,s0,-144
    800047e2:	96fff0ef          	jal	80004150 <create>
    800047e6:	c911                	beqz	a0,800047fa <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800047e8:	c00fe0ef          	jal	80002be8 <iunlockput>
  end_op();
    800047ec:	af3fe0ef          	jal	800032de <end_op>
  return 0;
    800047f0:	4501                	li	a0,0
}
    800047f2:	60aa                	ld	ra,136(sp)
    800047f4:	640a                	ld	s0,128(sp)
    800047f6:	6149                	addi	sp,sp,144
    800047f8:	8082                	ret
    end_op();
    800047fa:	ae5fe0ef          	jal	800032de <end_op>
    return -1;
    800047fe:	557d                	li	a0,-1
    80004800:	bfcd                	j	800047f2 <sys_mkdir+0x38>

0000000080004802 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004802:	7135                	addi	sp,sp,-160
    80004804:	ed06                	sd	ra,152(sp)
    80004806:	e922                	sd	s0,144(sp)
    80004808:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000480a:	a6bfe0ef          	jal	80003274 <begin_op>
  argint(1, &major);
    8000480e:	f6c40593          	addi	a1,s0,-148
    80004812:	4505                	li	a0,1
    80004814:	cf0fd0ef          	jal	80001d04 <argint>
  argint(2, &minor);
    80004818:	f6840593          	addi	a1,s0,-152
    8000481c:	4509                	li	a0,2
    8000481e:	ce6fd0ef          	jal	80001d04 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004822:	08000613          	li	a2,128
    80004826:	f7040593          	addi	a1,s0,-144
    8000482a:	4501                	li	a0,0
    8000482c:	d8efd0ef          	jal	80001dba <argstr>
    80004830:	02054563          	bltz	a0,8000485a <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004834:	f6841683          	lh	a3,-152(s0)
    80004838:	f6c41603          	lh	a2,-148(s0)
    8000483c:	458d                	li	a1,3
    8000483e:	f7040513          	addi	a0,s0,-144
    80004842:	90fff0ef          	jal	80004150 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004846:	c911                	beqz	a0,8000485a <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004848:	ba0fe0ef          	jal	80002be8 <iunlockput>
  end_op();
    8000484c:	a93fe0ef          	jal	800032de <end_op>
  return 0;
    80004850:	4501                	li	a0,0
}
    80004852:	60ea                	ld	ra,152(sp)
    80004854:	644a                	ld	s0,144(sp)
    80004856:	610d                	addi	sp,sp,160
    80004858:	8082                	ret
    end_op();
    8000485a:	a85fe0ef          	jal	800032de <end_op>
    return -1;
    8000485e:	557d                	li	a0,-1
    80004860:	bfcd                	j	80004852 <sys_mknod+0x50>

0000000080004862 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004862:	7135                	addi	sp,sp,-160
    80004864:	ed06                	sd	ra,152(sp)
    80004866:	e922                	sd	s0,144(sp)
    80004868:	e14a                	sd	s2,128(sp)
    8000486a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000486c:	ceafc0ef          	jal	80000d56 <myproc>
    80004870:	892a                	mv	s2,a0
  
  begin_op();
    80004872:	a03fe0ef          	jal	80003274 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004876:	08000613          	li	a2,128
    8000487a:	f6040593          	addi	a1,s0,-160
    8000487e:	4501                	li	a0,0
    80004880:	d3afd0ef          	jal	80001dba <argstr>
    80004884:	04054363          	bltz	a0,800048ca <sys_chdir+0x68>
    80004888:	e526                	sd	s1,136(sp)
    8000488a:	f6040513          	addi	a0,s0,-160
    8000488e:	82bfe0ef          	jal	800030b8 <namei>
    80004892:	84aa                	mv	s1,a0
    80004894:	c915                	beqz	a0,800048c8 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004896:	948fe0ef          	jal	800029de <ilock>
  if(ip->type != T_DIR){
    8000489a:	04449703          	lh	a4,68(s1)
    8000489e:	4785                	li	a5,1
    800048a0:	02f71963          	bne	a4,a5,800048d2 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800048a4:	8526                	mv	a0,s1
    800048a6:	9e6fe0ef          	jal	80002a8c <iunlock>
  iput(p->cwd);
    800048aa:	15093503          	ld	a0,336(s2)
    800048ae:	ab2fe0ef          	jal	80002b60 <iput>
  end_op();
    800048b2:	a2dfe0ef          	jal	800032de <end_op>
  p->cwd = ip;
    800048b6:	14993823          	sd	s1,336(s2)
  return 0;
    800048ba:	4501                	li	a0,0
    800048bc:	64aa                	ld	s1,136(sp)
}
    800048be:	60ea                	ld	ra,152(sp)
    800048c0:	644a                	ld	s0,144(sp)
    800048c2:	690a                	ld	s2,128(sp)
    800048c4:	610d                	addi	sp,sp,160
    800048c6:	8082                	ret
    800048c8:	64aa                	ld	s1,136(sp)
    end_op();
    800048ca:	a15fe0ef          	jal	800032de <end_op>
    return -1;
    800048ce:	557d                	li	a0,-1
    800048d0:	b7fd                	j	800048be <sys_chdir+0x5c>
    iunlockput(ip);
    800048d2:	8526                	mv	a0,s1
    800048d4:	b14fe0ef          	jal	80002be8 <iunlockput>
    end_op();
    800048d8:	a07fe0ef          	jal	800032de <end_op>
    return -1;
    800048dc:	557d                	li	a0,-1
    800048de:	64aa                	ld	s1,136(sp)
    800048e0:	bff9                	j	800048be <sys_chdir+0x5c>

00000000800048e2 <sys_exec>:

///////////////////////////////////////

uint64
sys_exec(void)
{
    800048e2:	7121                	addi	sp,sp,-448
    800048e4:	ff06                	sd	ra,440(sp)
    800048e6:	fb22                	sd	s0,432(sp)
    800048e8:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800048ea:	e4840593          	addi	a1,s0,-440
    800048ee:	4505                	li	a0,1
    800048f0:	cb6fd0ef          	jal	80001da6 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800048f4:	08000613          	li	a2,128
    800048f8:	f5040593          	addi	a1,s0,-176
    800048fc:	4501                	li	a0,0
    800048fe:	cbcfd0ef          	jal	80001dba <argstr>
    80004902:	87aa                	mv	a5,a0
    return -1;
    80004904:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004906:	0a07cb63          	bltz	a5,800049bc <sys_exec+0xda>
    8000490a:	f726                	sd	s1,424(sp)
    8000490c:	f34a                	sd	s2,416(sp)
    8000490e:	ef4e                	sd	s3,408(sp)
    80004910:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004912:	10000613          	li	a2,256
    80004916:	4581                	li	a1,0
    80004918:	e5040513          	addi	a0,s0,-432
    8000491c:	819fb0ef          	jal	80000134 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004920:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004924:	89a6                	mv	s3,s1
    80004926:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004928:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000492c:	00391513          	slli	a0,s2,0x3
    80004930:	e4040593          	addi	a1,s0,-448
    80004934:	e4843783          	ld	a5,-440(s0)
    80004938:	953e                	add	a0,a0,a5
    8000493a:	b40fd0ef          	jal	80001c7a <fetchaddr>
    8000493e:	02054663          	bltz	a0,8000496a <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80004942:	e4043783          	ld	a5,-448(s0)
    80004946:	c3a9                	beqz	a5,80004988 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004948:	faefb0ef          	jal	800000f6 <kalloc>
    8000494c:	85aa                	mv	a1,a0
    8000494e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004952:	cd01                	beqz	a0,8000496a <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004954:	6605                	lui	a2,0x1
    80004956:	e4043503          	ld	a0,-448(s0)
    8000495a:	b6afd0ef          	jal	80001cc4 <fetchstr>
    8000495e:	00054663          	bltz	a0,8000496a <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80004962:	0905                	addi	s2,s2,1
    80004964:	09a1                	addi	s3,s3,8
    80004966:	fd4913e3          	bne	s2,s4,8000492c <sys_exec+0x4a>

  // Free memory only if exec fails (handled in bad)
  return ret;

bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000496a:	f5040913          	addi	s2,s0,-176
    8000496e:	6088                	ld	a0,0(s1)
    80004970:	c129                	beqz	a0,800049b2 <sys_exec+0xd0>
    kfree(argv[i]);
    80004972:	eaafb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004976:	04a1                	addi	s1,s1,8
    80004978:	ff249be3          	bne	s1,s2,8000496e <sys_exec+0x8c>
  return -1;
    8000497c:	557d                	li	a0,-1
    8000497e:	74ba                	ld	s1,424(sp)
    80004980:	791a                	ld	s2,416(sp)
    80004982:	69fa                	ld	s3,408(sp)
    80004984:	6a5a                	ld	s4,400(sp)
    80004986:	a81d                	j	800049bc <sys_exec+0xda>
      argv[i] = 0;
    80004988:	0009079b          	sext.w	a5,s2
    8000498c:	078e                	slli	a5,a5,0x3
    8000498e:	fd078793          	addi	a5,a5,-48
    80004992:	97a2                	add	a5,a5,s0
    80004994:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004998:	e5040593          	addi	a1,s0,-432
    8000499c:	f5040513          	addi	a0,s0,-176
    800049a0:	aecff0ef          	jal	80003c8c <exec>
  if(ret < 0) {
    800049a4:	fc0543e3          	bltz	a0,8000496a <sys_exec+0x88>
    800049a8:	74ba                	ld	s1,424(sp)
    800049aa:	791a                	ld	s2,416(sp)
    800049ac:	69fa                	ld	s3,408(sp)
    800049ae:	6a5a                	ld	s4,400(sp)
    800049b0:	a031                	j	800049bc <sys_exec+0xda>
  return -1;
    800049b2:	557d                	li	a0,-1
    800049b4:	74ba                	ld	s1,424(sp)
    800049b6:	791a                	ld	s2,416(sp)
    800049b8:	69fa                	ld	s3,408(sp)
    800049ba:	6a5a                	ld	s4,400(sp)
}
    800049bc:	70fa                	ld	ra,440(sp)
    800049be:	745a                	ld	s0,432(sp)
    800049c0:	6139                	addi	sp,sp,448
    800049c2:	8082                	ret

00000000800049c4 <sys_pipe>:

//////////////////////////

uint64
sys_pipe(void)
{
    800049c4:	7139                	addi	sp,sp,-64
    800049c6:	fc06                	sd	ra,56(sp)
    800049c8:	f822                	sd	s0,48(sp)
    800049ca:	f426                	sd	s1,40(sp)
    800049cc:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800049ce:	b88fc0ef          	jal	80000d56 <myproc>
    800049d2:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800049d4:	fd840593          	addi	a1,s0,-40
    800049d8:	4501                	li	a0,0
    800049da:	bccfd0ef          	jal	80001da6 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800049de:	fc840593          	addi	a1,s0,-56
    800049e2:	fd040513          	addi	a0,s0,-48
    800049e6:	fb3fe0ef          	jal	80003998 <pipealloc>
    return -1;
    800049ea:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800049ec:	0a054463          	bltz	a0,80004a94 <sys_pipe+0xd0>
  fd0 = -1;
    800049f0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800049f4:	fd043503          	ld	a0,-48(s0)
    800049f8:	f1aff0ef          	jal	80004112 <fdalloc>
    800049fc:	fca42223          	sw	a0,-60(s0)
    80004a00:	08054163          	bltz	a0,80004a82 <sys_pipe+0xbe>
    80004a04:	fc843503          	ld	a0,-56(s0)
    80004a08:	f0aff0ef          	jal	80004112 <fdalloc>
    80004a0c:	fca42023          	sw	a0,-64(s0)
    80004a10:	06054063          	bltz	a0,80004a70 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004a14:	4691                	li	a3,4
    80004a16:	fc440613          	addi	a2,s0,-60
    80004a1a:	fd843583          	ld	a1,-40(s0)
    80004a1e:	68a8                	ld	a0,80(s1)
    80004a20:	fa7fb0ef          	jal	800009c6 <copyout>
    80004a24:	00054e63          	bltz	a0,80004a40 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004a28:	4691                	li	a3,4
    80004a2a:	fc040613          	addi	a2,s0,-64
    80004a2e:	fd843583          	ld	a1,-40(s0)
    80004a32:	0591                	addi	a1,a1,4
    80004a34:	68a8                	ld	a0,80(s1)
    80004a36:	f91fb0ef          	jal	800009c6 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004a3a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004a3c:	04055c63          	bgez	a0,80004a94 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004a40:	fc442783          	lw	a5,-60(s0)
    80004a44:	07e9                	addi	a5,a5,26
    80004a46:	078e                	slli	a5,a5,0x3
    80004a48:	97a6                	add	a5,a5,s1
    80004a4a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004a4e:	fc042783          	lw	a5,-64(s0)
    80004a52:	07e9                	addi	a5,a5,26
    80004a54:	078e                	slli	a5,a5,0x3
    80004a56:	94be                	add	s1,s1,a5
    80004a58:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004a5c:	fd043503          	ld	a0,-48(s0)
    80004a60:	c2ffe0ef          	jal	8000368e <fileclose>
    fileclose(wf);
    80004a64:	fc843503          	ld	a0,-56(s0)
    80004a68:	c27fe0ef          	jal	8000368e <fileclose>
    return -1;
    80004a6c:	57fd                	li	a5,-1
    80004a6e:	a01d                	j	80004a94 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004a70:	fc442783          	lw	a5,-60(s0)
    80004a74:	0007c763          	bltz	a5,80004a82 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004a78:	07e9                	addi	a5,a5,26
    80004a7a:	078e                	slli	a5,a5,0x3
    80004a7c:	97a6                	add	a5,a5,s1
    80004a7e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004a82:	fd043503          	ld	a0,-48(s0)
    80004a86:	c09fe0ef          	jal	8000368e <fileclose>
    fileclose(wf);
    80004a8a:	fc843503          	ld	a0,-56(s0)
    80004a8e:	c01fe0ef          	jal	8000368e <fileclose>
    return -1;
    80004a92:	57fd                	li	a5,-1
}
    80004a94:	853e                	mv	a0,a5
    80004a96:	70e2                	ld	ra,56(sp)
    80004a98:	7442                	ld	s0,48(sp)
    80004a9a:	74a2                	ld	s1,40(sp)
    80004a9c:	6121                	addi	sp,sp,64
    80004a9e:	8082                	ret

0000000080004aa0 <kernelvec>:
    80004aa0:	7111                	addi	sp,sp,-256
    80004aa2:	e006                	sd	ra,0(sp)
    80004aa4:	e40a                	sd	sp,8(sp)
    80004aa6:	e80e                	sd	gp,16(sp)
    80004aa8:	ec12                	sd	tp,24(sp)
    80004aaa:	f016                	sd	t0,32(sp)
    80004aac:	f41a                	sd	t1,40(sp)
    80004aae:	f81e                	sd	t2,48(sp)
    80004ab0:	e4aa                	sd	a0,72(sp)
    80004ab2:	e8ae                	sd	a1,80(sp)
    80004ab4:	ecb2                	sd	a2,88(sp)
    80004ab6:	f0b6                	sd	a3,96(sp)
    80004ab8:	f4ba                	sd	a4,104(sp)
    80004aba:	f8be                	sd	a5,112(sp)
    80004abc:	fcc2                	sd	a6,120(sp)
    80004abe:	e146                	sd	a7,128(sp)
    80004ac0:	edf2                	sd	t3,216(sp)
    80004ac2:	f1f6                	sd	t4,224(sp)
    80004ac4:	f5fa                	sd	t5,232(sp)
    80004ac6:	f9fe                	sd	t6,240(sp)
    80004ac8:	fd5fc0ef          	jal	80001a9c <kerneltrap>
    80004acc:	6082                	ld	ra,0(sp)
    80004ace:	6122                	ld	sp,8(sp)
    80004ad0:	61c2                	ld	gp,16(sp)
    80004ad2:	7282                	ld	t0,32(sp)
    80004ad4:	7322                	ld	t1,40(sp)
    80004ad6:	73c2                	ld	t2,48(sp)
    80004ad8:	6526                	ld	a0,72(sp)
    80004ada:	65c6                	ld	a1,80(sp)
    80004adc:	6666                	ld	a2,88(sp)
    80004ade:	7686                	ld	a3,96(sp)
    80004ae0:	7726                	ld	a4,104(sp)
    80004ae2:	77c6                	ld	a5,112(sp)
    80004ae4:	7866                	ld	a6,120(sp)
    80004ae6:	688a                	ld	a7,128(sp)
    80004ae8:	6e6e                	ld	t3,216(sp)
    80004aea:	7e8e                	ld	t4,224(sp)
    80004aec:	7f2e                	ld	t5,232(sp)
    80004aee:	7fce                	ld	t6,240(sp)
    80004af0:	6111                	addi	sp,sp,256
    80004af2:	10200073          	sret
	...

0000000080004afe <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80004afe:	1141                	addi	sp,sp,-16
    80004b00:	e422                	sd	s0,8(sp)
    80004b02:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004b04:	0c0007b7          	lui	a5,0xc000
    80004b08:	4705                	li	a4,1
    80004b0a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80004b0c:	0c0007b7          	lui	a5,0xc000
    80004b10:	c3d8                	sw	a4,4(a5)
}
    80004b12:	6422                	ld	s0,8(sp)
    80004b14:	0141                	addi	sp,sp,16
    80004b16:	8082                	ret

0000000080004b18 <plicinithart>:

void
plicinithart(void)
{
    80004b18:	1141                	addi	sp,sp,-16
    80004b1a:	e406                	sd	ra,8(sp)
    80004b1c:	e022                	sd	s0,0(sp)
    80004b1e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004b20:	a0afc0ef          	jal	80000d2a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004b24:	0085171b          	slliw	a4,a0,0x8
    80004b28:	0c0027b7          	lui	a5,0xc002
    80004b2c:	97ba                	add	a5,a5,a4
    80004b2e:	40200713          	li	a4,1026
    80004b32:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004b36:	00d5151b          	slliw	a0,a0,0xd
    80004b3a:	0c2017b7          	lui	a5,0xc201
    80004b3e:	97aa                	add	a5,a5,a0
    80004b40:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004b44:	60a2                	ld	ra,8(sp)
    80004b46:	6402                	ld	s0,0(sp)
    80004b48:	0141                	addi	sp,sp,16
    80004b4a:	8082                	ret

0000000080004b4c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004b4c:	1141                	addi	sp,sp,-16
    80004b4e:	e406                	sd	ra,8(sp)
    80004b50:	e022                	sd	s0,0(sp)
    80004b52:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004b54:	9d6fc0ef          	jal	80000d2a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004b58:	00d5151b          	slliw	a0,a0,0xd
    80004b5c:	0c2017b7          	lui	a5,0xc201
    80004b60:	97aa                	add	a5,a5,a0
  return irq;
}
    80004b62:	43c8                	lw	a0,4(a5)
    80004b64:	60a2                	ld	ra,8(sp)
    80004b66:	6402                	ld	s0,0(sp)
    80004b68:	0141                	addi	sp,sp,16
    80004b6a:	8082                	ret

0000000080004b6c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004b6c:	1101                	addi	sp,sp,-32
    80004b6e:	ec06                	sd	ra,24(sp)
    80004b70:	e822                	sd	s0,16(sp)
    80004b72:	e426                	sd	s1,8(sp)
    80004b74:	1000                	addi	s0,sp,32
    80004b76:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004b78:	9b2fc0ef          	jal	80000d2a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004b7c:	00d5151b          	slliw	a0,a0,0xd
    80004b80:	0c2017b7          	lui	a5,0xc201
    80004b84:	97aa                	add	a5,a5,a0
    80004b86:	c3c4                	sw	s1,4(a5)
}
    80004b88:	60e2                	ld	ra,24(sp)
    80004b8a:	6442                	ld	s0,16(sp)
    80004b8c:	64a2                	ld	s1,8(sp)
    80004b8e:	6105                	addi	sp,sp,32
    80004b90:	8082                	ret

0000000080004b92 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004b92:	1141                	addi	sp,sp,-16
    80004b94:	e406                	sd	ra,8(sp)
    80004b96:	e022                	sd	s0,0(sp)
    80004b98:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004b9a:	479d                	li	a5,7
    80004b9c:	04a7ca63          	blt	a5,a0,80004bf0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004ba0:	00017797          	auipc	a5,0x17
    80004ba4:	eb078793          	addi	a5,a5,-336 # 8001ba50 <disk>
    80004ba8:	97aa                	add	a5,a5,a0
    80004baa:	0187c783          	lbu	a5,24(a5)
    80004bae:	e7b9                	bnez	a5,80004bfc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004bb0:	00451693          	slli	a3,a0,0x4
    80004bb4:	00017797          	auipc	a5,0x17
    80004bb8:	e9c78793          	addi	a5,a5,-356 # 8001ba50 <disk>
    80004bbc:	6398                	ld	a4,0(a5)
    80004bbe:	9736                	add	a4,a4,a3
    80004bc0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004bc4:	6398                	ld	a4,0(a5)
    80004bc6:	9736                	add	a4,a4,a3
    80004bc8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004bcc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004bd0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004bd4:	97aa                	add	a5,a5,a0
    80004bd6:	4705                	li	a4,1
    80004bd8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004bdc:	00017517          	auipc	a0,0x17
    80004be0:	e8c50513          	addi	a0,a0,-372 # 8001ba68 <disk+0x18>
    80004be4:	f98fc0ef          	jal	8000137c <wakeup>
}
    80004be8:	60a2                	ld	ra,8(sp)
    80004bea:	6402                	ld	s0,0(sp)
    80004bec:	0141                	addi	sp,sp,16
    80004bee:	8082                	ret
    panic("free_desc 1");
    80004bf0:	00003517          	auipc	a0,0x3
    80004bf4:	bc050513          	addi	a0,a0,-1088 # 800077b0 <etext+0x7b0>
    80004bf8:	43b000ef          	jal	80005832 <panic>
    panic("free_desc 2");
    80004bfc:	00003517          	auipc	a0,0x3
    80004c00:	bc450513          	addi	a0,a0,-1084 # 800077c0 <etext+0x7c0>
    80004c04:	42f000ef          	jal	80005832 <panic>

0000000080004c08 <virtio_disk_init>:
{
    80004c08:	1101                	addi	sp,sp,-32
    80004c0a:	ec06                	sd	ra,24(sp)
    80004c0c:	e822                	sd	s0,16(sp)
    80004c0e:	e426                	sd	s1,8(sp)
    80004c10:	e04a                	sd	s2,0(sp)
    80004c12:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004c14:	00003597          	auipc	a1,0x3
    80004c18:	bbc58593          	addi	a1,a1,-1092 # 800077d0 <etext+0x7d0>
    80004c1c:	00017517          	auipc	a0,0x17
    80004c20:	f5c50513          	addi	a0,a0,-164 # 8001bb78 <disk+0x128>
    80004c24:	6bd000ef          	jal	80005ae0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004c28:	100017b7          	lui	a5,0x10001
    80004c2c:	4398                	lw	a4,0(a5)
    80004c2e:	2701                	sext.w	a4,a4
    80004c30:	747277b7          	lui	a5,0x74727
    80004c34:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004c38:	18f71063          	bne	a4,a5,80004db8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004c3c:	100017b7          	lui	a5,0x10001
    80004c40:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004c42:	439c                	lw	a5,0(a5)
    80004c44:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004c46:	4709                	li	a4,2
    80004c48:	16e79863          	bne	a5,a4,80004db8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004c4c:	100017b7          	lui	a5,0x10001
    80004c50:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004c52:	439c                	lw	a5,0(a5)
    80004c54:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004c56:	16e79163          	bne	a5,a4,80004db8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004c5a:	100017b7          	lui	a5,0x10001
    80004c5e:	47d8                	lw	a4,12(a5)
    80004c60:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004c62:	554d47b7          	lui	a5,0x554d4
    80004c66:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004c6a:	14f71763          	bne	a4,a5,80004db8 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c6e:	100017b7          	lui	a5,0x10001
    80004c72:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c76:	4705                	li	a4,1
    80004c78:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c7a:	470d                	li	a4,3
    80004c7c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004c7e:	10001737          	lui	a4,0x10001
    80004c82:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004c84:	c7ffe737          	lui	a4,0xc7ffe
    80004c88:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdaacf>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004c8c:	8ef9                	and	a3,a3,a4
    80004c8e:	10001737          	lui	a4,0x10001
    80004c92:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c94:	472d                	li	a4,11
    80004c96:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c98:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004c9c:	439c                	lw	a5,0(a5)
    80004c9e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004ca2:	8ba1                	andi	a5,a5,8
    80004ca4:	12078063          	beqz	a5,80004dc4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004ca8:	100017b7          	lui	a5,0x10001
    80004cac:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004cb0:	100017b7          	lui	a5,0x10001
    80004cb4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004cb8:	439c                	lw	a5,0(a5)
    80004cba:	2781                	sext.w	a5,a5
    80004cbc:	10079a63          	bnez	a5,80004dd0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004cc0:	100017b7          	lui	a5,0x10001
    80004cc4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004cc8:	439c                	lw	a5,0(a5)
    80004cca:	2781                	sext.w	a5,a5
  if(max == 0)
    80004ccc:	10078863          	beqz	a5,80004ddc <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004cd0:	471d                	li	a4,7
    80004cd2:	10f77b63          	bgeu	a4,a5,80004de8 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004cd6:	c20fb0ef          	jal	800000f6 <kalloc>
    80004cda:	00017497          	auipc	s1,0x17
    80004cde:	d7648493          	addi	s1,s1,-650 # 8001ba50 <disk>
    80004ce2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004ce4:	c12fb0ef          	jal	800000f6 <kalloc>
    80004ce8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004cea:	c0cfb0ef          	jal	800000f6 <kalloc>
    80004cee:	87aa                	mv	a5,a0
    80004cf0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004cf2:	6088                	ld	a0,0(s1)
    80004cf4:	10050063          	beqz	a0,80004df4 <virtio_disk_init+0x1ec>
    80004cf8:	00017717          	auipc	a4,0x17
    80004cfc:	d6073703          	ld	a4,-672(a4) # 8001ba58 <disk+0x8>
    80004d00:	0e070a63          	beqz	a4,80004df4 <virtio_disk_init+0x1ec>
    80004d04:	0e078863          	beqz	a5,80004df4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004d08:	6605                	lui	a2,0x1
    80004d0a:	4581                	li	a1,0
    80004d0c:	c28fb0ef          	jal	80000134 <memset>
  memset(disk.avail, 0, PGSIZE);
    80004d10:	00017497          	auipc	s1,0x17
    80004d14:	d4048493          	addi	s1,s1,-704 # 8001ba50 <disk>
    80004d18:	6605                	lui	a2,0x1
    80004d1a:	4581                	li	a1,0
    80004d1c:	6488                	ld	a0,8(s1)
    80004d1e:	c16fb0ef          	jal	80000134 <memset>
  memset(disk.used, 0, PGSIZE);
    80004d22:	6605                	lui	a2,0x1
    80004d24:	4581                	li	a1,0
    80004d26:	6888                	ld	a0,16(s1)
    80004d28:	c0cfb0ef          	jal	80000134 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004d2c:	100017b7          	lui	a5,0x10001
    80004d30:	4721                	li	a4,8
    80004d32:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004d34:	4098                	lw	a4,0(s1)
    80004d36:	100017b7          	lui	a5,0x10001
    80004d3a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004d3e:	40d8                	lw	a4,4(s1)
    80004d40:	100017b7          	lui	a5,0x10001
    80004d44:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004d48:	649c                	ld	a5,8(s1)
    80004d4a:	0007869b          	sext.w	a3,a5
    80004d4e:	10001737          	lui	a4,0x10001
    80004d52:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004d56:	9781                	srai	a5,a5,0x20
    80004d58:	10001737          	lui	a4,0x10001
    80004d5c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004d60:	689c                	ld	a5,16(s1)
    80004d62:	0007869b          	sext.w	a3,a5
    80004d66:	10001737          	lui	a4,0x10001
    80004d6a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004d6e:	9781                	srai	a5,a5,0x20
    80004d70:	10001737          	lui	a4,0x10001
    80004d74:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004d78:	10001737          	lui	a4,0x10001
    80004d7c:	4785                	li	a5,1
    80004d7e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004d80:	00f48c23          	sb	a5,24(s1)
    80004d84:	00f48ca3          	sb	a5,25(s1)
    80004d88:	00f48d23          	sb	a5,26(s1)
    80004d8c:	00f48da3          	sb	a5,27(s1)
    80004d90:	00f48e23          	sb	a5,28(s1)
    80004d94:	00f48ea3          	sb	a5,29(s1)
    80004d98:	00f48f23          	sb	a5,30(s1)
    80004d9c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004da0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004da4:	100017b7          	lui	a5,0x10001
    80004da8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004dac:	60e2                	ld	ra,24(sp)
    80004dae:	6442                	ld	s0,16(sp)
    80004db0:	64a2                	ld	s1,8(sp)
    80004db2:	6902                	ld	s2,0(sp)
    80004db4:	6105                	addi	sp,sp,32
    80004db6:	8082                	ret
    panic("could not find virtio disk");
    80004db8:	00003517          	auipc	a0,0x3
    80004dbc:	a2850513          	addi	a0,a0,-1496 # 800077e0 <etext+0x7e0>
    80004dc0:	273000ef          	jal	80005832 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004dc4:	00003517          	auipc	a0,0x3
    80004dc8:	a3c50513          	addi	a0,a0,-1476 # 80007800 <etext+0x800>
    80004dcc:	267000ef          	jal	80005832 <panic>
    panic("virtio disk should not be ready");
    80004dd0:	00003517          	auipc	a0,0x3
    80004dd4:	a5050513          	addi	a0,a0,-1456 # 80007820 <etext+0x820>
    80004dd8:	25b000ef          	jal	80005832 <panic>
    panic("virtio disk has no queue 0");
    80004ddc:	00003517          	auipc	a0,0x3
    80004de0:	a6450513          	addi	a0,a0,-1436 # 80007840 <etext+0x840>
    80004de4:	24f000ef          	jal	80005832 <panic>
    panic("virtio disk max queue too short");
    80004de8:	00003517          	auipc	a0,0x3
    80004dec:	a7850513          	addi	a0,a0,-1416 # 80007860 <etext+0x860>
    80004df0:	243000ef          	jal	80005832 <panic>
    panic("virtio disk kalloc");
    80004df4:	00003517          	auipc	a0,0x3
    80004df8:	a8c50513          	addi	a0,a0,-1396 # 80007880 <etext+0x880>
    80004dfc:	237000ef          	jal	80005832 <panic>

0000000080004e00 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004e00:	7159                	addi	sp,sp,-112
    80004e02:	f486                	sd	ra,104(sp)
    80004e04:	f0a2                	sd	s0,96(sp)
    80004e06:	eca6                	sd	s1,88(sp)
    80004e08:	e8ca                	sd	s2,80(sp)
    80004e0a:	e4ce                	sd	s3,72(sp)
    80004e0c:	e0d2                	sd	s4,64(sp)
    80004e0e:	fc56                	sd	s5,56(sp)
    80004e10:	f85a                	sd	s6,48(sp)
    80004e12:	f45e                	sd	s7,40(sp)
    80004e14:	f062                	sd	s8,32(sp)
    80004e16:	ec66                	sd	s9,24(sp)
    80004e18:	1880                	addi	s0,sp,112
    80004e1a:	8a2a                	mv	s4,a0
    80004e1c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004e1e:	00c52c83          	lw	s9,12(a0)
    80004e22:	001c9c9b          	slliw	s9,s9,0x1
    80004e26:	1c82                	slli	s9,s9,0x20
    80004e28:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004e2c:	00017517          	auipc	a0,0x17
    80004e30:	d4c50513          	addi	a0,a0,-692 # 8001bb78 <disk+0x128>
    80004e34:	52d000ef          	jal	80005b60 <acquire>
  for(int i = 0; i < 3; i++){
    80004e38:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004e3a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004e3c:	00017b17          	auipc	s6,0x17
    80004e40:	c14b0b13          	addi	s6,s6,-1004 # 8001ba50 <disk>
  for(int i = 0; i < 3; i++){
    80004e44:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004e46:	00017c17          	auipc	s8,0x17
    80004e4a:	d32c0c13          	addi	s8,s8,-718 # 8001bb78 <disk+0x128>
    80004e4e:	a8b9                	j	80004eac <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004e50:	00fb0733          	add	a4,s6,a5
    80004e54:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004e58:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004e5a:	0207c563          	bltz	a5,80004e84 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004e5e:	2905                	addiw	s2,s2,1
    80004e60:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004e62:	05590963          	beq	s2,s5,80004eb4 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004e66:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004e68:	00017717          	auipc	a4,0x17
    80004e6c:	be870713          	addi	a4,a4,-1048 # 8001ba50 <disk>
    80004e70:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004e72:	01874683          	lbu	a3,24(a4)
    80004e76:	fee9                	bnez	a3,80004e50 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004e78:	2785                	addiw	a5,a5,1
    80004e7a:	0705                	addi	a4,a4,1
    80004e7c:	fe979be3          	bne	a5,s1,80004e72 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004e80:	57fd                	li	a5,-1
    80004e82:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004e84:	01205d63          	blez	s2,80004e9e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004e88:	f9042503          	lw	a0,-112(s0)
    80004e8c:	d07ff0ef          	jal	80004b92 <free_desc>
      for(int j = 0; j < i; j++)
    80004e90:	4785                	li	a5,1
    80004e92:	0127d663          	bge	a5,s2,80004e9e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004e96:	f9442503          	lw	a0,-108(s0)
    80004e9a:	cf9ff0ef          	jal	80004b92 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004e9e:	85e2                	mv	a1,s8
    80004ea0:	00017517          	auipc	a0,0x17
    80004ea4:	bc850513          	addi	a0,a0,-1080 # 8001ba68 <disk+0x18>
    80004ea8:	c88fc0ef          	jal	80001330 <sleep>
  for(int i = 0; i < 3; i++){
    80004eac:	f9040613          	addi	a2,s0,-112
    80004eb0:	894e                	mv	s2,s3
    80004eb2:	bf55                	j	80004e66 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004eb4:	f9042503          	lw	a0,-112(s0)
    80004eb8:	00451693          	slli	a3,a0,0x4

  if(write)
    80004ebc:	00017797          	auipc	a5,0x17
    80004ec0:	b9478793          	addi	a5,a5,-1132 # 8001ba50 <disk>
    80004ec4:	00a50713          	addi	a4,a0,10
    80004ec8:	0712                	slli	a4,a4,0x4
    80004eca:	973e                	add	a4,a4,a5
    80004ecc:	01703633          	snez	a2,s7
    80004ed0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004ed2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004ed6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004eda:	6398                	ld	a4,0(a5)
    80004edc:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004ede:	0a868613          	addi	a2,a3,168
    80004ee2:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004ee4:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004ee6:	6390                	ld	a2,0(a5)
    80004ee8:	00d605b3          	add	a1,a2,a3
    80004eec:	4741                	li	a4,16
    80004eee:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004ef0:	4805                	li	a6,1
    80004ef2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004ef6:	f9442703          	lw	a4,-108(s0)
    80004efa:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004efe:	0712                	slli	a4,a4,0x4
    80004f00:	963a                	add	a2,a2,a4
    80004f02:	058a0593          	addi	a1,s4,88
    80004f06:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004f08:	0007b883          	ld	a7,0(a5)
    80004f0c:	9746                	add	a4,a4,a7
    80004f0e:	40000613          	li	a2,1024
    80004f12:	c710                	sw	a2,8(a4)
  if(write)
    80004f14:	001bb613          	seqz	a2,s7
    80004f18:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004f1c:	00166613          	ori	a2,a2,1
    80004f20:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004f24:	f9842583          	lw	a1,-104(s0)
    80004f28:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004f2c:	00250613          	addi	a2,a0,2
    80004f30:	0612                	slli	a2,a2,0x4
    80004f32:	963e                	add	a2,a2,a5
    80004f34:	577d                	li	a4,-1
    80004f36:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004f3a:	0592                	slli	a1,a1,0x4
    80004f3c:	98ae                	add	a7,a7,a1
    80004f3e:	03068713          	addi	a4,a3,48
    80004f42:	973e                	add	a4,a4,a5
    80004f44:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004f48:	6398                	ld	a4,0(a5)
    80004f4a:	972e                	add	a4,a4,a1
    80004f4c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004f50:	4689                	li	a3,2
    80004f52:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004f56:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004f5a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004f5e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004f62:	6794                	ld	a3,8(a5)
    80004f64:	0026d703          	lhu	a4,2(a3)
    80004f68:	8b1d                	andi	a4,a4,7
    80004f6a:	0706                	slli	a4,a4,0x1
    80004f6c:	96ba                	add	a3,a3,a4
    80004f6e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004f72:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004f76:	6798                	ld	a4,8(a5)
    80004f78:	00275783          	lhu	a5,2(a4)
    80004f7c:	2785                	addiw	a5,a5,1
    80004f7e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004f82:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004f86:	100017b7          	lui	a5,0x10001
    80004f8a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004f8e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004f92:	00017917          	auipc	s2,0x17
    80004f96:	be690913          	addi	s2,s2,-1050 # 8001bb78 <disk+0x128>
  while(b->disk == 1) {
    80004f9a:	4485                	li	s1,1
    80004f9c:	01079a63          	bne	a5,a6,80004fb0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004fa0:	85ca                	mv	a1,s2
    80004fa2:	8552                	mv	a0,s4
    80004fa4:	b8cfc0ef          	jal	80001330 <sleep>
  while(b->disk == 1) {
    80004fa8:	004a2783          	lw	a5,4(s4)
    80004fac:	fe978ae3          	beq	a5,s1,80004fa0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004fb0:	f9042903          	lw	s2,-112(s0)
    80004fb4:	00290713          	addi	a4,s2,2
    80004fb8:	0712                	slli	a4,a4,0x4
    80004fba:	00017797          	auipc	a5,0x17
    80004fbe:	a9678793          	addi	a5,a5,-1386 # 8001ba50 <disk>
    80004fc2:	97ba                	add	a5,a5,a4
    80004fc4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004fc8:	00017997          	auipc	s3,0x17
    80004fcc:	a8898993          	addi	s3,s3,-1400 # 8001ba50 <disk>
    80004fd0:	00491713          	slli	a4,s2,0x4
    80004fd4:	0009b783          	ld	a5,0(s3)
    80004fd8:	97ba                	add	a5,a5,a4
    80004fda:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004fde:	854a                	mv	a0,s2
    80004fe0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004fe4:	bafff0ef          	jal	80004b92 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004fe8:	8885                	andi	s1,s1,1
    80004fea:	f0fd                	bnez	s1,80004fd0 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004fec:	00017517          	auipc	a0,0x17
    80004ff0:	b8c50513          	addi	a0,a0,-1140 # 8001bb78 <disk+0x128>
    80004ff4:	405000ef          	jal	80005bf8 <release>
}
    80004ff8:	70a6                	ld	ra,104(sp)
    80004ffa:	7406                	ld	s0,96(sp)
    80004ffc:	64e6                	ld	s1,88(sp)
    80004ffe:	6946                	ld	s2,80(sp)
    80005000:	69a6                	ld	s3,72(sp)
    80005002:	6a06                	ld	s4,64(sp)
    80005004:	7ae2                	ld	s5,56(sp)
    80005006:	7b42                	ld	s6,48(sp)
    80005008:	7ba2                	ld	s7,40(sp)
    8000500a:	7c02                	ld	s8,32(sp)
    8000500c:	6ce2                	ld	s9,24(sp)
    8000500e:	6165                	addi	sp,sp,112
    80005010:	8082                	ret

0000000080005012 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005012:	1101                	addi	sp,sp,-32
    80005014:	ec06                	sd	ra,24(sp)
    80005016:	e822                	sd	s0,16(sp)
    80005018:	e426                	sd	s1,8(sp)
    8000501a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000501c:	00017497          	auipc	s1,0x17
    80005020:	a3448493          	addi	s1,s1,-1484 # 8001ba50 <disk>
    80005024:	00017517          	auipc	a0,0x17
    80005028:	b5450513          	addi	a0,a0,-1196 # 8001bb78 <disk+0x128>
    8000502c:	335000ef          	jal	80005b60 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005030:	100017b7          	lui	a5,0x10001
    80005034:	53b8                	lw	a4,96(a5)
    80005036:	8b0d                	andi	a4,a4,3
    80005038:	100017b7          	lui	a5,0x10001
    8000503c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    8000503e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005042:	689c                	ld	a5,16(s1)
    80005044:	0204d703          	lhu	a4,32(s1)
    80005048:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000504c:	04f70663          	beq	a4,a5,80005098 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005050:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005054:	6898                	ld	a4,16(s1)
    80005056:	0204d783          	lhu	a5,32(s1)
    8000505a:	8b9d                	andi	a5,a5,7
    8000505c:	078e                	slli	a5,a5,0x3
    8000505e:	97ba                	add	a5,a5,a4
    80005060:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005062:	00278713          	addi	a4,a5,2
    80005066:	0712                	slli	a4,a4,0x4
    80005068:	9726                	add	a4,a4,s1
    8000506a:	01074703          	lbu	a4,16(a4)
    8000506e:	e321                	bnez	a4,800050ae <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005070:	0789                	addi	a5,a5,2
    80005072:	0792                	slli	a5,a5,0x4
    80005074:	97a6                	add	a5,a5,s1
    80005076:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005078:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000507c:	b00fc0ef          	jal	8000137c <wakeup>

    disk.used_idx += 1;
    80005080:	0204d783          	lhu	a5,32(s1)
    80005084:	2785                	addiw	a5,a5,1
    80005086:	17c2                	slli	a5,a5,0x30
    80005088:	93c1                	srli	a5,a5,0x30
    8000508a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000508e:	6898                	ld	a4,16(s1)
    80005090:	00275703          	lhu	a4,2(a4)
    80005094:	faf71ee3          	bne	a4,a5,80005050 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005098:	00017517          	auipc	a0,0x17
    8000509c:	ae050513          	addi	a0,a0,-1312 # 8001bb78 <disk+0x128>
    800050a0:	359000ef          	jal	80005bf8 <release>
}
    800050a4:	60e2                	ld	ra,24(sp)
    800050a6:	6442                	ld	s0,16(sp)
    800050a8:	64a2                	ld	s1,8(sp)
    800050aa:	6105                	addi	sp,sp,32
    800050ac:	8082                	ret
      panic("virtio_disk_intr status");
    800050ae:	00002517          	auipc	a0,0x2
    800050b2:	7ea50513          	addi	a0,a0,2026 # 80007898 <etext+0x898>
    800050b6:	77c000ef          	jal	80005832 <panic>

00000000800050ba <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    800050ba:	1141                	addi	sp,sp,-16
    800050bc:	e422                	sd	s0,8(sp)
    800050be:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    800050c0:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    800050c4:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    800050c8:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    800050cc:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    800050d0:	577d                	li	a4,-1
    800050d2:	177e                	slli	a4,a4,0x3f
    800050d4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    800050d6:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    800050da:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    800050de:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    800050e2:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    800050e6:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    800050ea:	000f4737          	lui	a4,0xf4
    800050ee:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800050f2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800050f4:	14d79073          	csrw	stimecmp,a5
}
    800050f8:	6422                	ld	s0,8(sp)
    800050fa:	0141                	addi	sp,sp,16
    800050fc:	8082                	ret

00000000800050fe <start>:
{
    800050fe:	1141                	addi	sp,sp,-16
    80005100:	e406                	sd	ra,8(sp)
    80005102:	e022                	sd	s0,0(sp)
    80005104:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005106:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000510a:	7779                	lui	a4,0xffffe
    8000510c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdab6f>
    80005110:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005112:	6705                	lui	a4,0x1
    80005114:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005118:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000511a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000511e:	ffffb797          	auipc	a5,0xffffb
    80005122:	1b078793          	addi	a5,a5,432 # 800002ce <main>
    80005126:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000512a:	4781                	li	a5,0
    8000512c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005130:	67c1                	lui	a5,0x10
    80005132:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005134:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005138:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000513c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005140:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005144:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005148:	57fd                	li	a5,-1
    8000514a:	83a9                	srli	a5,a5,0xa
    8000514c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005150:	47bd                	li	a5,15
    80005152:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005156:	f65ff0ef          	jal	800050ba <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000515a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000515e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005160:	823e                	mv	tp,a5
  asm volatile("mret");
    80005162:	30200073          	mret
}
    80005166:	60a2                	ld	ra,8(sp)
    80005168:	6402                	ld	s0,0(sp)
    8000516a:	0141                	addi	sp,sp,16
    8000516c:	8082                	ret

000000008000516e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000516e:	715d                	addi	sp,sp,-80
    80005170:	e486                	sd	ra,72(sp)
    80005172:	e0a2                	sd	s0,64(sp)
    80005174:	f84a                	sd	s2,48(sp)
    80005176:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005178:	04c05263          	blez	a2,800051bc <consolewrite+0x4e>
    8000517c:	fc26                	sd	s1,56(sp)
    8000517e:	f44e                	sd	s3,40(sp)
    80005180:	f052                	sd	s4,32(sp)
    80005182:	ec56                	sd	s5,24(sp)
    80005184:	8a2a                	mv	s4,a0
    80005186:	84ae                	mv	s1,a1
    80005188:	89b2                	mv	s3,a2
    8000518a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000518c:	5afd                	li	s5,-1
    8000518e:	4685                	li	a3,1
    80005190:	8626                	mv	a2,s1
    80005192:	85d2                	mv	a1,s4
    80005194:	fbf40513          	addi	a0,s0,-65
    80005198:	d3efc0ef          	jal	800016d6 <either_copyin>
    8000519c:	03550263          	beq	a0,s5,800051c0 <consolewrite+0x52>
      break;
    uartputc(c);
    800051a0:	fbf44503          	lbu	a0,-65(s0)
    800051a4:	035000ef          	jal	800059d8 <uartputc>
  for(i = 0; i < n; i++){
    800051a8:	2905                	addiw	s2,s2,1
    800051aa:	0485                	addi	s1,s1,1
    800051ac:	ff2991e3          	bne	s3,s2,8000518e <consolewrite+0x20>
    800051b0:	894e                	mv	s2,s3
    800051b2:	74e2                	ld	s1,56(sp)
    800051b4:	79a2                	ld	s3,40(sp)
    800051b6:	7a02                	ld	s4,32(sp)
    800051b8:	6ae2                	ld	s5,24(sp)
    800051ba:	a039                	j	800051c8 <consolewrite+0x5a>
    800051bc:	4901                	li	s2,0
    800051be:	a029                	j	800051c8 <consolewrite+0x5a>
    800051c0:	74e2                	ld	s1,56(sp)
    800051c2:	79a2                	ld	s3,40(sp)
    800051c4:	7a02                	ld	s4,32(sp)
    800051c6:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    800051c8:	854a                	mv	a0,s2
    800051ca:	60a6                	ld	ra,72(sp)
    800051cc:	6406                	ld	s0,64(sp)
    800051ce:	7942                	ld	s2,48(sp)
    800051d0:	6161                	addi	sp,sp,80
    800051d2:	8082                	ret

00000000800051d4 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800051d4:	711d                	addi	sp,sp,-96
    800051d6:	ec86                	sd	ra,88(sp)
    800051d8:	e8a2                	sd	s0,80(sp)
    800051da:	e4a6                	sd	s1,72(sp)
    800051dc:	e0ca                	sd	s2,64(sp)
    800051de:	fc4e                	sd	s3,56(sp)
    800051e0:	f852                	sd	s4,48(sp)
    800051e2:	f456                	sd	s5,40(sp)
    800051e4:	f05a                	sd	s6,32(sp)
    800051e6:	1080                	addi	s0,sp,96
    800051e8:	8aaa                	mv	s5,a0
    800051ea:	8a2e                	mv	s4,a1
    800051ec:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800051ee:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800051f2:	0001f517          	auipc	a0,0x1f
    800051f6:	99e50513          	addi	a0,a0,-1634 # 80023b90 <cons>
    800051fa:	167000ef          	jal	80005b60 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800051fe:	0001f497          	auipc	s1,0x1f
    80005202:	99248493          	addi	s1,s1,-1646 # 80023b90 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005206:	0001f917          	auipc	s2,0x1f
    8000520a:	a2290913          	addi	s2,s2,-1502 # 80023c28 <cons+0x98>
  while(n > 0){
    8000520e:	0b305d63          	blez	s3,800052c8 <consoleread+0xf4>
    while(cons.r == cons.w){
    80005212:	0984a783          	lw	a5,152(s1)
    80005216:	09c4a703          	lw	a4,156(s1)
    8000521a:	0af71263          	bne	a4,a5,800052be <consoleread+0xea>
      if(killed(myproc())){
    8000521e:	b39fb0ef          	jal	80000d56 <myproc>
    80005222:	b46fc0ef          	jal	80001568 <killed>
    80005226:	e12d                	bnez	a0,80005288 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80005228:	85a6                	mv	a1,s1
    8000522a:	854a                	mv	a0,s2
    8000522c:	904fc0ef          	jal	80001330 <sleep>
    while(cons.r == cons.w){
    80005230:	0984a783          	lw	a5,152(s1)
    80005234:	09c4a703          	lw	a4,156(s1)
    80005238:	fef703e3          	beq	a4,a5,8000521e <consoleread+0x4a>
    8000523c:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000523e:	0001f717          	auipc	a4,0x1f
    80005242:	95270713          	addi	a4,a4,-1710 # 80023b90 <cons>
    80005246:	0017869b          	addiw	a3,a5,1
    8000524a:	08d72c23          	sw	a3,152(a4)
    8000524e:	07f7f693          	andi	a3,a5,127
    80005252:	9736                	add	a4,a4,a3
    80005254:	01874703          	lbu	a4,24(a4)
    80005258:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    8000525c:	4691                	li	a3,4
    8000525e:	04db8663          	beq	s7,a3,800052aa <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005262:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005266:	4685                	li	a3,1
    80005268:	faf40613          	addi	a2,s0,-81
    8000526c:	85d2                	mv	a1,s4
    8000526e:	8556                	mv	a0,s5
    80005270:	c1cfc0ef          	jal	8000168c <either_copyout>
    80005274:	57fd                	li	a5,-1
    80005276:	04f50863          	beq	a0,a5,800052c6 <consoleread+0xf2>
      break;

    dst++;
    8000527a:	0a05                	addi	s4,s4,1
    --n;
    8000527c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000527e:	47a9                	li	a5,10
    80005280:	04fb8d63          	beq	s7,a5,800052da <consoleread+0x106>
    80005284:	6be2                	ld	s7,24(sp)
    80005286:	b761                	j	8000520e <consoleread+0x3a>
        release(&cons.lock);
    80005288:	0001f517          	auipc	a0,0x1f
    8000528c:	90850513          	addi	a0,a0,-1784 # 80023b90 <cons>
    80005290:	169000ef          	jal	80005bf8 <release>
        return -1;
    80005294:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005296:	60e6                	ld	ra,88(sp)
    80005298:	6446                	ld	s0,80(sp)
    8000529a:	64a6                	ld	s1,72(sp)
    8000529c:	6906                	ld	s2,64(sp)
    8000529e:	79e2                	ld	s3,56(sp)
    800052a0:	7a42                	ld	s4,48(sp)
    800052a2:	7aa2                	ld	s5,40(sp)
    800052a4:	7b02                	ld	s6,32(sp)
    800052a6:	6125                	addi	sp,sp,96
    800052a8:	8082                	ret
      if(n < target){
    800052aa:	0009871b          	sext.w	a4,s3
    800052ae:	01677a63          	bgeu	a4,s6,800052c2 <consoleread+0xee>
        cons.r--;
    800052b2:	0001f717          	auipc	a4,0x1f
    800052b6:	96f72b23          	sw	a5,-1674(a4) # 80023c28 <cons+0x98>
    800052ba:	6be2                	ld	s7,24(sp)
    800052bc:	a031                	j	800052c8 <consoleread+0xf4>
    800052be:	ec5e                	sd	s7,24(sp)
    800052c0:	bfbd                	j	8000523e <consoleread+0x6a>
    800052c2:	6be2                	ld	s7,24(sp)
    800052c4:	a011                	j	800052c8 <consoleread+0xf4>
    800052c6:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    800052c8:	0001f517          	auipc	a0,0x1f
    800052cc:	8c850513          	addi	a0,a0,-1848 # 80023b90 <cons>
    800052d0:	129000ef          	jal	80005bf8 <release>
  return target - n;
    800052d4:	413b053b          	subw	a0,s6,s3
    800052d8:	bf7d                	j	80005296 <consoleread+0xc2>
    800052da:	6be2                	ld	s7,24(sp)
    800052dc:	b7f5                	j	800052c8 <consoleread+0xf4>

00000000800052de <consputc>:
{
    800052de:	1141                	addi	sp,sp,-16
    800052e0:	e406                	sd	ra,8(sp)
    800052e2:	e022                	sd	s0,0(sp)
    800052e4:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800052e6:	10000793          	li	a5,256
    800052ea:	00f50863          	beq	a0,a5,800052fa <consputc+0x1c>
    uartputc_sync(c);
    800052ee:	604000ef          	jal	800058f2 <uartputc_sync>
}
    800052f2:	60a2                	ld	ra,8(sp)
    800052f4:	6402                	ld	s0,0(sp)
    800052f6:	0141                	addi	sp,sp,16
    800052f8:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800052fa:	4521                	li	a0,8
    800052fc:	5f6000ef          	jal	800058f2 <uartputc_sync>
    80005300:	02000513          	li	a0,32
    80005304:	5ee000ef          	jal	800058f2 <uartputc_sync>
    80005308:	4521                	li	a0,8
    8000530a:	5e8000ef          	jal	800058f2 <uartputc_sync>
    8000530e:	b7d5                	j	800052f2 <consputc+0x14>

0000000080005310 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005310:	1101                	addi	sp,sp,-32
    80005312:	ec06                	sd	ra,24(sp)
    80005314:	e822                	sd	s0,16(sp)
    80005316:	e426                	sd	s1,8(sp)
    80005318:	1000                	addi	s0,sp,32
    8000531a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000531c:	0001f517          	auipc	a0,0x1f
    80005320:	87450513          	addi	a0,a0,-1932 # 80023b90 <cons>
    80005324:	03d000ef          	jal	80005b60 <acquire>

  switch(c){
    80005328:	47d5                	li	a5,21
    8000532a:	08f48f63          	beq	s1,a5,800053c8 <consoleintr+0xb8>
    8000532e:	0297c563          	blt	a5,s1,80005358 <consoleintr+0x48>
    80005332:	47a1                	li	a5,8
    80005334:	0ef48463          	beq	s1,a5,8000541c <consoleintr+0x10c>
    80005338:	47c1                	li	a5,16
    8000533a:	10f49563          	bne	s1,a5,80005444 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    8000533e:	be2fc0ef          	jal	80001720 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005342:	0001f517          	auipc	a0,0x1f
    80005346:	84e50513          	addi	a0,a0,-1970 # 80023b90 <cons>
    8000534a:	0af000ef          	jal	80005bf8 <release>
}
    8000534e:	60e2                	ld	ra,24(sp)
    80005350:	6442                	ld	s0,16(sp)
    80005352:	64a2                	ld	s1,8(sp)
    80005354:	6105                	addi	sp,sp,32
    80005356:	8082                	ret
  switch(c){
    80005358:	07f00793          	li	a5,127
    8000535c:	0cf48063          	beq	s1,a5,8000541c <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005360:	0001f717          	auipc	a4,0x1f
    80005364:	83070713          	addi	a4,a4,-2000 # 80023b90 <cons>
    80005368:	0a072783          	lw	a5,160(a4)
    8000536c:	09872703          	lw	a4,152(a4)
    80005370:	9f99                	subw	a5,a5,a4
    80005372:	07f00713          	li	a4,127
    80005376:	fcf766e3          	bltu	a4,a5,80005342 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    8000537a:	47b5                	li	a5,13
    8000537c:	0cf48763          	beq	s1,a5,8000544a <consoleintr+0x13a>
      consputc(c);
    80005380:	8526                	mv	a0,s1
    80005382:	f5dff0ef          	jal	800052de <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005386:	0001f797          	auipc	a5,0x1f
    8000538a:	80a78793          	addi	a5,a5,-2038 # 80023b90 <cons>
    8000538e:	0a07a683          	lw	a3,160(a5)
    80005392:	0016871b          	addiw	a4,a3,1
    80005396:	0007061b          	sext.w	a2,a4
    8000539a:	0ae7a023          	sw	a4,160(a5)
    8000539e:	07f6f693          	andi	a3,a3,127
    800053a2:	97b6                	add	a5,a5,a3
    800053a4:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800053a8:	47a9                	li	a5,10
    800053aa:	0cf48563          	beq	s1,a5,80005474 <consoleintr+0x164>
    800053ae:	4791                	li	a5,4
    800053b0:	0cf48263          	beq	s1,a5,80005474 <consoleintr+0x164>
    800053b4:	0001f797          	auipc	a5,0x1f
    800053b8:	8747a783          	lw	a5,-1932(a5) # 80023c28 <cons+0x98>
    800053bc:	9f1d                	subw	a4,a4,a5
    800053be:	08000793          	li	a5,128
    800053c2:	f8f710e3          	bne	a4,a5,80005342 <consoleintr+0x32>
    800053c6:	a07d                	j	80005474 <consoleintr+0x164>
    800053c8:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800053ca:	0001e717          	auipc	a4,0x1e
    800053ce:	7c670713          	addi	a4,a4,1990 # 80023b90 <cons>
    800053d2:	0a072783          	lw	a5,160(a4)
    800053d6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800053da:	0001e497          	auipc	s1,0x1e
    800053de:	7b648493          	addi	s1,s1,1974 # 80023b90 <cons>
    while(cons.e != cons.w &&
    800053e2:	4929                	li	s2,10
    800053e4:	02f70863          	beq	a4,a5,80005414 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800053e8:	37fd                	addiw	a5,a5,-1
    800053ea:	07f7f713          	andi	a4,a5,127
    800053ee:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800053f0:	01874703          	lbu	a4,24(a4)
    800053f4:	03270263          	beq	a4,s2,80005418 <consoleintr+0x108>
      cons.e--;
    800053f8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800053fc:	10000513          	li	a0,256
    80005400:	edfff0ef          	jal	800052de <consputc>
    while(cons.e != cons.w &&
    80005404:	0a04a783          	lw	a5,160(s1)
    80005408:	09c4a703          	lw	a4,156(s1)
    8000540c:	fcf71ee3          	bne	a4,a5,800053e8 <consoleintr+0xd8>
    80005410:	6902                	ld	s2,0(sp)
    80005412:	bf05                	j	80005342 <consoleintr+0x32>
    80005414:	6902                	ld	s2,0(sp)
    80005416:	b735                	j	80005342 <consoleintr+0x32>
    80005418:	6902                	ld	s2,0(sp)
    8000541a:	b725                	j	80005342 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000541c:	0001e717          	auipc	a4,0x1e
    80005420:	77470713          	addi	a4,a4,1908 # 80023b90 <cons>
    80005424:	0a072783          	lw	a5,160(a4)
    80005428:	09c72703          	lw	a4,156(a4)
    8000542c:	f0f70be3          	beq	a4,a5,80005342 <consoleintr+0x32>
      cons.e--;
    80005430:	37fd                	addiw	a5,a5,-1
    80005432:	0001e717          	auipc	a4,0x1e
    80005436:	7ef72f23          	sw	a5,2046(a4) # 80023c30 <cons+0xa0>
      consputc(BACKSPACE);
    8000543a:	10000513          	li	a0,256
    8000543e:	ea1ff0ef          	jal	800052de <consputc>
    80005442:	b701                	j	80005342 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005444:	ee048fe3          	beqz	s1,80005342 <consoleintr+0x32>
    80005448:	bf21                	j	80005360 <consoleintr+0x50>
      consputc(c);
    8000544a:	4529                	li	a0,10
    8000544c:	e93ff0ef          	jal	800052de <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005450:	0001e797          	auipc	a5,0x1e
    80005454:	74078793          	addi	a5,a5,1856 # 80023b90 <cons>
    80005458:	0a07a703          	lw	a4,160(a5)
    8000545c:	0017069b          	addiw	a3,a4,1
    80005460:	0006861b          	sext.w	a2,a3
    80005464:	0ad7a023          	sw	a3,160(a5)
    80005468:	07f77713          	andi	a4,a4,127
    8000546c:	97ba                	add	a5,a5,a4
    8000546e:	4729                	li	a4,10
    80005470:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005474:	0001e797          	auipc	a5,0x1e
    80005478:	7ac7ac23          	sw	a2,1976(a5) # 80023c2c <cons+0x9c>
        wakeup(&cons.r);
    8000547c:	0001e517          	auipc	a0,0x1e
    80005480:	7ac50513          	addi	a0,a0,1964 # 80023c28 <cons+0x98>
    80005484:	ef9fb0ef          	jal	8000137c <wakeup>
    80005488:	bd6d                	j	80005342 <consoleintr+0x32>

000000008000548a <consoleinit>:

void
consoleinit(void)
{
    8000548a:	1141                	addi	sp,sp,-16
    8000548c:	e406                	sd	ra,8(sp)
    8000548e:	e022                	sd	s0,0(sp)
    80005490:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005492:	00002597          	auipc	a1,0x2
    80005496:	41e58593          	addi	a1,a1,1054 # 800078b0 <etext+0x8b0>
    8000549a:	0001e517          	auipc	a0,0x1e
    8000549e:	6f650513          	addi	a0,a0,1782 # 80023b90 <cons>
    800054a2:	63e000ef          	jal	80005ae0 <initlock>

  uartinit();
    800054a6:	3f4000ef          	jal	8000589a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800054aa:	00015797          	auipc	a5,0x15
    800054ae:	54e78793          	addi	a5,a5,1358 # 8001a9f8 <devsw>
    800054b2:	00000717          	auipc	a4,0x0
    800054b6:	d2270713          	addi	a4,a4,-734 # 800051d4 <consoleread>
    800054ba:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800054bc:	00000717          	auipc	a4,0x0
    800054c0:	cb270713          	addi	a4,a4,-846 # 8000516e <consolewrite>
    800054c4:	ef98                	sd	a4,24(a5)
}
    800054c6:	60a2                	ld	ra,8(sp)
    800054c8:	6402                	ld	s0,0(sp)
    800054ca:	0141                	addi	sp,sp,16
    800054cc:	8082                	ret

00000000800054ce <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800054ce:	7179                	addi	sp,sp,-48
    800054d0:	f406                	sd	ra,40(sp)
    800054d2:	f022                	sd	s0,32(sp)
    800054d4:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800054d6:	c219                	beqz	a2,800054dc <printint+0xe>
    800054d8:	08054063          	bltz	a0,80005558 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    800054dc:	4881                	li	a7,0
    800054de:	fd040693          	addi	a3,s0,-48

  i = 0;
    800054e2:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800054e4:	00002617          	auipc	a2,0x2
    800054e8:	67c60613          	addi	a2,a2,1660 # 80007b60 <digits>
    800054ec:	883e                	mv	a6,a5
    800054ee:	2785                	addiw	a5,a5,1
    800054f0:	02b57733          	remu	a4,a0,a1
    800054f4:	9732                	add	a4,a4,a2
    800054f6:	00074703          	lbu	a4,0(a4)
    800054fa:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800054fe:	872a                	mv	a4,a0
    80005500:	02b55533          	divu	a0,a0,a1
    80005504:	0685                	addi	a3,a3,1
    80005506:	feb773e3          	bgeu	a4,a1,800054ec <printint+0x1e>

  if(sign)
    8000550a:	00088a63          	beqz	a7,8000551e <printint+0x50>
    buf[i++] = '-';
    8000550e:	1781                	addi	a5,a5,-32
    80005510:	97a2                	add	a5,a5,s0
    80005512:	02d00713          	li	a4,45
    80005516:	fee78823          	sb	a4,-16(a5)
    8000551a:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    8000551e:	02f05963          	blez	a5,80005550 <printint+0x82>
    80005522:	ec26                	sd	s1,24(sp)
    80005524:	e84a                	sd	s2,16(sp)
    80005526:	fd040713          	addi	a4,s0,-48
    8000552a:	00f704b3          	add	s1,a4,a5
    8000552e:	fff70913          	addi	s2,a4,-1
    80005532:	993e                	add	s2,s2,a5
    80005534:	37fd                	addiw	a5,a5,-1
    80005536:	1782                	slli	a5,a5,0x20
    80005538:	9381                	srli	a5,a5,0x20
    8000553a:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000553e:	fff4c503          	lbu	a0,-1(s1)
    80005542:	d9dff0ef          	jal	800052de <consputc>
  while(--i >= 0)
    80005546:	14fd                	addi	s1,s1,-1
    80005548:	ff249be3          	bne	s1,s2,8000553e <printint+0x70>
    8000554c:	64e2                	ld	s1,24(sp)
    8000554e:	6942                	ld	s2,16(sp)
}
    80005550:	70a2                	ld	ra,40(sp)
    80005552:	7402                	ld	s0,32(sp)
    80005554:	6145                	addi	sp,sp,48
    80005556:	8082                	ret
    x = -xx;
    80005558:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000555c:	4885                	li	a7,1
    x = -xx;
    8000555e:	b741                	j	800054de <printint+0x10>

0000000080005560 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005560:	7155                	addi	sp,sp,-208
    80005562:	e506                	sd	ra,136(sp)
    80005564:	e122                	sd	s0,128(sp)
    80005566:	f0d2                	sd	s4,96(sp)
    80005568:	0900                	addi	s0,sp,144
    8000556a:	8a2a                	mv	s4,a0
    8000556c:	e40c                	sd	a1,8(s0)
    8000556e:	e810                	sd	a2,16(s0)
    80005570:	ec14                	sd	a3,24(s0)
    80005572:	f018                	sd	a4,32(s0)
    80005574:	f41c                	sd	a5,40(s0)
    80005576:	03043823          	sd	a6,48(s0)
    8000557a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    8000557e:	0001e797          	auipc	a5,0x1e
    80005582:	6d27a783          	lw	a5,1746(a5) # 80023c50 <pr+0x18>
    80005586:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8000558a:	e3a1                	bnez	a5,800055ca <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000558c:	00840793          	addi	a5,s0,8
    80005590:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005594:	00054503          	lbu	a0,0(a0)
    80005598:	26050763          	beqz	a0,80005806 <printf+0x2a6>
    8000559c:	fca6                	sd	s1,120(sp)
    8000559e:	f8ca                	sd	s2,112(sp)
    800055a0:	f4ce                	sd	s3,104(sp)
    800055a2:	ecd6                	sd	s5,88(sp)
    800055a4:	e8da                	sd	s6,80(sp)
    800055a6:	e0e2                	sd	s8,64(sp)
    800055a8:	fc66                	sd	s9,56(sp)
    800055aa:	f86a                	sd	s10,48(sp)
    800055ac:	f46e                	sd	s11,40(sp)
    800055ae:	4981                	li	s3,0
    if(cx != '%'){
    800055b0:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800055b4:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800055b8:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800055bc:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800055c0:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800055c4:	07000d93          	li	s11,112
    800055c8:	a815                	j	800055fc <printf+0x9c>
    acquire(&pr.lock);
    800055ca:	0001e517          	auipc	a0,0x1e
    800055ce:	66e50513          	addi	a0,a0,1646 # 80023c38 <pr>
    800055d2:	58e000ef          	jal	80005b60 <acquire>
  va_start(ap, fmt);
    800055d6:	00840793          	addi	a5,s0,8
    800055da:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800055de:	000a4503          	lbu	a0,0(s4)
    800055e2:	fd4d                	bnez	a0,8000559c <printf+0x3c>
    800055e4:	a481                	j	80005824 <printf+0x2c4>
      consputc(cx);
    800055e6:	cf9ff0ef          	jal	800052de <consputc>
      continue;
    800055ea:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800055ec:	0014899b          	addiw	s3,s1,1
    800055f0:	013a07b3          	add	a5,s4,s3
    800055f4:	0007c503          	lbu	a0,0(a5)
    800055f8:	1e050b63          	beqz	a0,800057ee <printf+0x28e>
    if(cx != '%'){
    800055fc:	ff5515e3          	bne	a0,s5,800055e6 <printf+0x86>
    i++;
    80005600:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80005604:	009a07b3          	add	a5,s4,s1
    80005608:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000560c:	1e090163          	beqz	s2,800057ee <printf+0x28e>
    80005610:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80005614:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80005616:	c789                	beqz	a5,80005620 <printf+0xc0>
    80005618:	009a0733          	add	a4,s4,s1
    8000561c:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005620:	03690763          	beq	s2,s6,8000564e <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80005624:	05890163          	beq	s2,s8,80005666 <printf+0x106>
    } else if(c0 == 'u'){
    80005628:	0d990b63          	beq	s2,s9,800056fe <printf+0x19e>
    } else if(c0 == 'x'){
    8000562c:	13a90163          	beq	s2,s10,8000574e <printf+0x1ee>
    } else if(c0 == 'p'){
    80005630:	13b90b63          	beq	s2,s11,80005766 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005634:	07300793          	li	a5,115
    80005638:	16f90a63          	beq	s2,a5,800057ac <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000563c:	1b590463          	beq	s2,s5,800057e4 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005640:	8556                	mv	a0,s5
    80005642:	c9dff0ef          	jal	800052de <consputc>
      consputc(c0);
    80005646:	854a                	mv	a0,s2
    80005648:	c97ff0ef          	jal	800052de <consputc>
    8000564c:	b745                	j	800055ec <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    8000564e:	f8843783          	ld	a5,-120(s0)
    80005652:	00878713          	addi	a4,a5,8
    80005656:	f8e43423          	sd	a4,-120(s0)
    8000565a:	4605                	li	a2,1
    8000565c:	45a9                	li	a1,10
    8000565e:	4388                	lw	a0,0(a5)
    80005660:	e6fff0ef          	jal	800054ce <printint>
    80005664:	b761                	j	800055ec <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    80005666:	03678663          	beq	a5,s6,80005692 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000566a:	05878263          	beq	a5,s8,800056ae <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    8000566e:	0b978463          	beq	a5,s9,80005716 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    80005672:	fda797e3          	bne	a5,s10,80005640 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005676:	f8843783          	ld	a5,-120(s0)
    8000567a:	00878713          	addi	a4,a5,8
    8000567e:	f8e43423          	sd	a4,-120(s0)
    80005682:	4601                	li	a2,0
    80005684:	45c1                	li	a1,16
    80005686:	6388                	ld	a0,0(a5)
    80005688:	e47ff0ef          	jal	800054ce <printint>
      i += 1;
    8000568c:	0029849b          	addiw	s1,s3,2
    80005690:	bfb1                	j	800055ec <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005692:	f8843783          	ld	a5,-120(s0)
    80005696:	00878713          	addi	a4,a5,8
    8000569a:	f8e43423          	sd	a4,-120(s0)
    8000569e:	4605                	li	a2,1
    800056a0:	45a9                	li	a1,10
    800056a2:	6388                	ld	a0,0(a5)
    800056a4:	e2bff0ef          	jal	800054ce <printint>
      i += 1;
    800056a8:	0029849b          	addiw	s1,s3,2
    800056ac:	b781                	j	800055ec <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800056ae:	06400793          	li	a5,100
    800056b2:	02f68863          	beq	a3,a5,800056e2 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800056b6:	07500793          	li	a5,117
    800056ba:	06f68c63          	beq	a3,a5,80005732 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800056be:	07800793          	li	a5,120
    800056c2:	f6f69fe3          	bne	a3,a5,80005640 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800056c6:	f8843783          	ld	a5,-120(s0)
    800056ca:	00878713          	addi	a4,a5,8
    800056ce:	f8e43423          	sd	a4,-120(s0)
    800056d2:	4601                	li	a2,0
    800056d4:	45c1                	li	a1,16
    800056d6:	6388                	ld	a0,0(a5)
    800056d8:	df7ff0ef          	jal	800054ce <printint>
      i += 2;
    800056dc:	0039849b          	addiw	s1,s3,3
    800056e0:	b731                	j	800055ec <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800056e2:	f8843783          	ld	a5,-120(s0)
    800056e6:	00878713          	addi	a4,a5,8
    800056ea:	f8e43423          	sd	a4,-120(s0)
    800056ee:	4605                	li	a2,1
    800056f0:	45a9                	li	a1,10
    800056f2:	6388                	ld	a0,0(a5)
    800056f4:	ddbff0ef          	jal	800054ce <printint>
      i += 2;
    800056f8:	0039849b          	addiw	s1,s3,3
    800056fc:	bdc5                	j	800055ec <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800056fe:	f8843783          	ld	a5,-120(s0)
    80005702:	00878713          	addi	a4,a5,8
    80005706:	f8e43423          	sd	a4,-120(s0)
    8000570a:	4601                	li	a2,0
    8000570c:	45a9                	li	a1,10
    8000570e:	4388                	lw	a0,0(a5)
    80005710:	dbfff0ef          	jal	800054ce <printint>
    80005714:	bde1                	j	800055ec <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005716:	f8843783          	ld	a5,-120(s0)
    8000571a:	00878713          	addi	a4,a5,8
    8000571e:	f8e43423          	sd	a4,-120(s0)
    80005722:	4601                	li	a2,0
    80005724:	45a9                	li	a1,10
    80005726:	6388                	ld	a0,0(a5)
    80005728:	da7ff0ef          	jal	800054ce <printint>
      i += 1;
    8000572c:	0029849b          	addiw	s1,s3,2
    80005730:	bd75                	j	800055ec <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005732:	f8843783          	ld	a5,-120(s0)
    80005736:	00878713          	addi	a4,a5,8
    8000573a:	f8e43423          	sd	a4,-120(s0)
    8000573e:	4601                	li	a2,0
    80005740:	45a9                	li	a1,10
    80005742:	6388                	ld	a0,0(a5)
    80005744:	d8bff0ef          	jal	800054ce <printint>
      i += 2;
    80005748:	0039849b          	addiw	s1,s3,3
    8000574c:	b545                	j	800055ec <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    8000574e:	f8843783          	ld	a5,-120(s0)
    80005752:	00878713          	addi	a4,a5,8
    80005756:	f8e43423          	sd	a4,-120(s0)
    8000575a:	4601                	li	a2,0
    8000575c:	45c1                	li	a1,16
    8000575e:	4388                	lw	a0,0(a5)
    80005760:	d6fff0ef          	jal	800054ce <printint>
    80005764:	b561                	j	800055ec <printf+0x8c>
    80005766:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    80005768:	f8843783          	ld	a5,-120(s0)
    8000576c:	00878713          	addi	a4,a5,8
    80005770:	f8e43423          	sd	a4,-120(s0)
    80005774:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005778:	03000513          	li	a0,48
    8000577c:	b63ff0ef          	jal	800052de <consputc>
  consputc('x');
    80005780:	07800513          	li	a0,120
    80005784:	b5bff0ef          	jal	800052de <consputc>
    80005788:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000578a:	00002b97          	auipc	s7,0x2
    8000578e:	3d6b8b93          	addi	s7,s7,982 # 80007b60 <digits>
    80005792:	03c9d793          	srli	a5,s3,0x3c
    80005796:	97de                	add	a5,a5,s7
    80005798:	0007c503          	lbu	a0,0(a5)
    8000579c:	b43ff0ef          	jal	800052de <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800057a0:	0992                	slli	s3,s3,0x4
    800057a2:	397d                	addiw	s2,s2,-1
    800057a4:	fe0917e3          	bnez	s2,80005792 <printf+0x232>
    800057a8:	6ba6                	ld	s7,72(sp)
    800057aa:	b589                	j	800055ec <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    800057ac:	f8843783          	ld	a5,-120(s0)
    800057b0:	00878713          	addi	a4,a5,8
    800057b4:	f8e43423          	sd	a4,-120(s0)
    800057b8:	0007b903          	ld	s2,0(a5)
    800057bc:	00090d63          	beqz	s2,800057d6 <printf+0x276>
      for(; *s; s++)
    800057c0:	00094503          	lbu	a0,0(s2)
    800057c4:	e20504e3          	beqz	a0,800055ec <printf+0x8c>
        consputc(*s);
    800057c8:	b17ff0ef          	jal	800052de <consputc>
      for(; *s; s++)
    800057cc:	0905                	addi	s2,s2,1
    800057ce:	00094503          	lbu	a0,0(s2)
    800057d2:	f97d                	bnez	a0,800057c8 <printf+0x268>
    800057d4:	bd21                	j	800055ec <printf+0x8c>
        s = "(null)";
    800057d6:	00002917          	auipc	s2,0x2
    800057da:	0e290913          	addi	s2,s2,226 # 800078b8 <etext+0x8b8>
      for(; *s; s++)
    800057de:	02800513          	li	a0,40
    800057e2:	b7dd                	j	800057c8 <printf+0x268>
      consputc('%');
    800057e4:	02500513          	li	a0,37
    800057e8:	af7ff0ef          	jal	800052de <consputc>
    800057ec:	b501                	j	800055ec <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800057ee:	f7843783          	ld	a5,-136(s0)
    800057f2:	e385                	bnez	a5,80005812 <printf+0x2b2>
    800057f4:	74e6                	ld	s1,120(sp)
    800057f6:	7946                	ld	s2,112(sp)
    800057f8:	79a6                	ld	s3,104(sp)
    800057fa:	6ae6                	ld	s5,88(sp)
    800057fc:	6b46                	ld	s6,80(sp)
    800057fe:	6c06                	ld	s8,64(sp)
    80005800:	7ce2                	ld	s9,56(sp)
    80005802:	7d42                	ld	s10,48(sp)
    80005804:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80005806:	4501                	li	a0,0
    80005808:	60aa                	ld	ra,136(sp)
    8000580a:	640a                	ld	s0,128(sp)
    8000580c:	7a06                	ld	s4,96(sp)
    8000580e:	6169                	addi	sp,sp,208
    80005810:	8082                	ret
    80005812:	74e6                	ld	s1,120(sp)
    80005814:	7946                	ld	s2,112(sp)
    80005816:	79a6                	ld	s3,104(sp)
    80005818:	6ae6                	ld	s5,88(sp)
    8000581a:	6b46                	ld	s6,80(sp)
    8000581c:	6c06                	ld	s8,64(sp)
    8000581e:	7ce2                	ld	s9,56(sp)
    80005820:	7d42                	ld	s10,48(sp)
    80005822:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005824:	0001e517          	auipc	a0,0x1e
    80005828:	41450513          	addi	a0,a0,1044 # 80023c38 <pr>
    8000582c:	3cc000ef          	jal	80005bf8 <release>
    80005830:	bfd9                	j	80005806 <printf+0x2a6>

0000000080005832 <panic>:

void
panic(char *s)
{
    80005832:	1101                	addi	sp,sp,-32
    80005834:	ec06                	sd	ra,24(sp)
    80005836:	e822                	sd	s0,16(sp)
    80005838:	e426                	sd	s1,8(sp)
    8000583a:	1000                	addi	s0,sp,32
    8000583c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000583e:	0001e797          	auipc	a5,0x1e
    80005842:	4007a923          	sw	zero,1042(a5) # 80023c50 <pr+0x18>
  printf("panic: ");
    80005846:	00002517          	auipc	a0,0x2
    8000584a:	07a50513          	addi	a0,a0,122 # 800078c0 <etext+0x8c0>
    8000584e:	d13ff0ef          	jal	80005560 <printf>
  printf("%s\n", s);
    80005852:	85a6                	mv	a1,s1
    80005854:	00002517          	auipc	a0,0x2
    80005858:	07450513          	addi	a0,a0,116 # 800078c8 <etext+0x8c8>
    8000585c:	d05ff0ef          	jal	80005560 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005860:	4785                	li	a5,1
    80005862:	00005717          	auipc	a4,0x5
    80005866:	e6f72d23          	sw	a5,-390(a4) # 8000a6dc <panicked>
  for(;;)
    8000586a:	a001                	j	8000586a <panic+0x38>

000000008000586c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000586c:	1101                	addi	sp,sp,-32
    8000586e:	ec06                	sd	ra,24(sp)
    80005870:	e822                	sd	s0,16(sp)
    80005872:	e426                	sd	s1,8(sp)
    80005874:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005876:	0001e497          	auipc	s1,0x1e
    8000587a:	3c248493          	addi	s1,s1,962 # 80023c38 <pr>
    8000587e:	00002597          	auipc	a1,0x2
    80005882:	05258593          	addi	a1,a1,82 # 800078d0 <etext+0x8d0>
    80005886:	8526                	mv	a0,s1
    80005888:	258000ef          	jal	80005ae0 <initlock>
  pr.locking = 1;
    8000588c:	4785                	li	a5,1
    8000588e:	cc9c                	sw	a5,24(s1)
}
    80005890:	60e2                	ld	ra,24(sp)
    80005892:	6442                	ld	s0,16(sp)
    80005894:	64a2                	ld	s1,8(sp)
    80005896:	6105                	addi	sp,sp,32
    80005898:	8082                	ret

000000008000589a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000589a:	1141                	addi	sp,sp,-16
    8000589c:	e406                	sd	ra,8(sp)
    8000589e:	e022                	sd	s0,0(sp)
    800058a0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800058a2:	100007b7          	lui	a5,0x10000
    800058a6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800058aa:	10000737          	lui	a4,0x10000
    800058ae:	f8000693          	li	a3,-128
    800058b2:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800058b6:	468d                	li	a3,3
    800058b8:	10000637          	lui	a2,0x10000
    800058bc:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800058c0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800058c4:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800058c8:	10000737          	lui	a4,0x10000
    800058cc:	461d                	li	a2,7
    800058ce:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800058d2:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800058d6:	00002597          	auipc	a1,0x2
    800058da:	00258593          	addi	a1,a1,2 # 800078d8 <etext+0x8d8>
    800058de:	0001e517          	auipc	a0,0x1e
    800058e2:	37a50513          	addi	a0,a0,890 # 80023c58 <uart_tx_lock>
    800058e6:	1fa000ef          	jal	80005ae0 <initlock>
}
    800058ea:	60a2                	ld	ra,8(sp)
    800058ec:	6402                	ld	s0,0(sp)
    800058ee:	0141                	addi	sp,sp,16
    800058f0:	8082                	ret

00000000800058f2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800058f2:	1101                	addi	sp,sp,-32
    800058f4:	ec06                	sd	ra,24(sp)
    800058f6:	e822                	sd	s0,16(sp)
    800058f8:	e426                	sd	s1,8(sp)
    800058fa:	1000                	addi	s0,sp,32
    800058fc:	84aa                	mv	s1,a0
  push_off();
    800058fe:	222000ef          	jal	80005b20 <push_off>

  if(panicked){
    80005902:	00005797          	auipc	a5,0x5
    80005906:	dda7a783          	lw	a5,-550(a5) # 8000a6dc <panicked>
    8000590a:	e795                	bnez	a5,80005936 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000590c:	10000737          	lui	a4,0x10000
    80005910:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005912:	00074783          	lbu	a5,0(a4)
    80005916:	0207f793          	andi	a5,a5,32
    8000591a:	dfe5                	beqz	a5,80005912 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000591c:	0ff4f513          	zext.b	a0,s1
    80005920:	100007b7          	lui	a5,0x10000
    80005924:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005928:	27c000ef          	jal	80005ba4 <pop_off>
}
    8000592c:	60e2                	ld	ra,24(sp)
    8000592e:	6442                	ld	s0,16(sp)
    80005930:	64a2                	ld	s1,8(sp)
    80005932:	6105                	addi	sp,sp,32
    80005934:	8082                	ret
    for(;;)
    80005936:	a001                	j	80005936 <uartputc_sync+0x44>

0000000080005938 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005938:	00005797          	auipc	a5,0x5
    8000593c:	da87b783          	ld	a5,-600(a5) # 8000a6e0 <uart_tx_r>
    80005940:	00005717          	auipc	a4,0x5
    80005944:	da873703          	ld	a4,-600(a4) # 8000a6e8 <uart_tx_w>
    80005948:	08f70263          	beq	a4,a5,800059cc <uartstart+0x94>
{
    8000594c:	7139                	addi	sp,sp,-64
    8000594e:	fc06                	sd	ra,56(sp)
    80005950:	f822                	sd	s0,48(sp)
    80005952:	f426                	sd	s1,40(sp)
    80005954:	f04a                	sd	s2,32(sp)
    80005956:	ec4e                	sd	s3,24(sp)
    80005958:	e852                	sd	s4,16(sp)
    8000595a:	e456                	sd	s5,8(sp)
    8000595c:	e05a                	sd	s6,0(sp)
    8000595e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005960:	10000937          	lui	s2,0x10000
    80005964:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005966:	0001ea97          	auipc	s5,0x1e
    8000596a:	2f2a8a93          	addi	s5,s5,754 # 80023c58 <uart_tx_lock>
    uart_tx_r += 1;
    8000596e:	00005497          	auipc	s1,0x5
    80005972:	d7248493          	addi	s1,s1,-654 # 8000a6e0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005976:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000597a:	00005997          	auipc	s3,0x5
    8000597e:	d6e98993          	addi	s3,s3,-658 # 8000a6e8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005982:	00094703          	lbu	a4,0(s2)
    80005986:	02077713          	andi	a4,a4,32
    8000598a:	c71d                	beqz	a4,800059b8 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000598c:	01f7f713          	andi	a4,a5,31
    80005990:	9756                	add	a4,a4,s5
    80005992:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005996:	0785                	addi	a5,a5,1
    80005998:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000599a:	8526                	mv	a0,s1
    8000599c:	9e1fb0ef          	jal	8000137c <wakeup>
    WriteReg(THR, c);
    800059a0:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800059a4:	609c                	ld	a5,0(s1)
    800059a6:	0009b703          	ld	a4,0(s3)
    800059aa:	fcf71ce3          	bne	a4,a5,80005982 <uartstart+0x4a>
      ReadReg(ISR);
    800059ae:	100007b7          	lui	a5,0x10000
    800059b2:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800059b4:	0007c783          	lbu	a5,0(a5)
  }
}
    800059b8:	70e2                	ld	ra,56(sp)
    800059ba:	7442                	ld	s0,48(sp)
    800059bc:	74a2                	ld	s1,40(sp)
    800059be:	7902                	ld	s2,32(sp)
    800059c0:	69e2                	ld	s3,24(sp)
    800059c2:	6a42                	ld	s4,16(sp)
    800059c4:	6aa2                	ld	s5,8(sp)
    800059c6:	6b02                	ld	s6,0(sp)
    800059c8:	6121                	addi	sp,sp,64
    800059ca:	8082                	ret
      ReadReg(ISR);
    800059cc:	100007b7          	lui	a5,0x10000
    800059d0:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800059d2:	0007c783          	lbu	a5,0(a5)
      return;
    800059d6:	8082                	ret

00000000800059d8 <uartputc>:
{
    800059d8:	7179                	addi	sp,sp,-48
    800059da:	f406                	sd	ra,40(sp)
    800059dc:	f022                	sd	s0,32(sp)
    800059de:	ec26                	sd	s1,24(sp)
    800059e0:	e84a                	sd	s2,16(sp)
    800059e2:	e44e                	sd	s3,8(sp)
    800059e4:	e052                	sd	s4,0(sp)
    800059e6:	1800                	addi	s0,sp,48
    800059e8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800059ea:	0001e517          	auipc	a0,0x1e
    800059ee:	26e50513          	addi	a0,a0,622 # 80023c58 <uart_tx_lock>
    800059f2:	16e000ef          	jal	80005b60 <acquire>
  if(panicked){
    800059f6:	00005797          	auipc	a5,0x5
    800059fa:	ce67a783          	lw	a5,-794(a5) # 8000a6dc <panicked>
    800059fe:	efbd                	bnez	a5,80005a7c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005a00:	00005717          	auipc	a4,0x5
    80005a04:	ce873703          	ld	a4,-792(a4) # 8000a6e8 <uart_tx_w>
    80005a08:	00005797          	auipc	a5,0x5
    80005a0c:	cd87b783          	ld	a5,-808(a5) # 8000a6e0 <uart_tx_r>
    80005a10:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005a14:	0001e997          	auipc	s3,0x1e
    80005a18:	24498993          	addi	s3,s3,580 # 80023c58 <uart_tx_lock>
    80005a1c:	00005497          	auipc	s1,0x5
    80005a20:	cc448493          	addi	s1,s1,-828 # 8000a6e0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005a24:	00005917          	auipc	s2,0x5
    80005a28:	cc490913          	addi	s2,s2,-828 # 8000a6e8 <uart_tx_w>
    80005a2c:	00e79d63          	bne	a5,a4,80005a46 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005a30:	85ce                	mv	a1,s3
    80005a32:	8526                	mv	a0,s1
    80005a34:	8fdfb0ef          	jal	80001330 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005a38:	00093703          	ld	a4,0(s2)
    80005a3c:	609c                	ld	a5,0(s1)
    80005a3e:	02078793          	addi	a5,a5,32
    80005a42:	fee787e3          	beq	a5,a4,80005a30 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005a46:	0001e497          	auipc	s1,0x1e
    80005a4a:	21248493          	addi	s1,s1,530 # 80023c58 <uart_tx_lock>
    80005a4e:	01f77793          	andi	a5,a4,31
    80005a52:	97a6                	add	a5,a5,s1
    80005a54:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005a58:	0705                	addi	a4,a4,1
    80005a5a:	00005797          	auipc	a5,0x5
    80005a5e:	c8e7b723          	sd	a4,-882(a5) # 8000a6e8 <uart_tx_w>
  uartstart();
    80005a62:	ed7ff0ef          	jal	80005938 <uartstart>
  release(&uart_tx_lock);
    80005a66:	8526                	mv	a0,s1
    80005a68:	190000ef          	jal	80005bf8 <release>
}
    80005a6c:	70a2                	ld	ra,40(sp)
    80005a6e:	7402                	ld	s0,32(sp)
    80005a70:	64e2                	ld	s1,24(sp)
    80005a72:	6942                	ld	s2,16(sp)
    80005a74:	69a2                	ld	s3,8(sp)
    80005a76:	6a02                	ld	s4,0(sp)
    80005a78:	6145                	addi	sp,sp,48
    80005a7a:	8082                	ret
    for(;;)
    80005a7c:	a001                	j	80005a7c <uartputc+0xa4>

0000000080005a7e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005a7e:	1141                	addi	sp,sp,-16
    80005a80:	e422                	sd	s0,8(sp)
    80005a82:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005a84:	100007b7          	lui	a5,0x10000
    80005a88:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80005a8a:	0007c783          	lbu	a5,0(a5)
    80005a8e:	8b85                	andi	a5,a5,1
    80005a90:	cb81                	beqz	a5,80005aa0 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005a92:	100007b7          	lui	a5,0x10000
    80005a96:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005a9a:	6422                	ld	s0,8(sp)
    80005a9c:	0141                	addi	sp,sp,16
    80005a9e:	8082                	ret
    return -1;
    80005aa0:	557d                	li	a0,-1
    80005aa2:	bfe5                	j	80005a9a <uartgetc+0x1c>

0000000080005aa4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005aa4:	1101                	addi	sp,sp,-32
    80005aa6:	ec06                	sd	ra,24(sp)
    80005aa8:	e822                	sd	s0,16(sp)
    80005aaa:	e426                	sd	s1,8(sp)
    80005aac:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005aae:	54fd                	li	s1,-1
    80005ab0:	a019                	j	80005ab6 <uartintr+0x12>
      break;
    consoleintr(c);
    80005ab2:	85fff0ef          	jal	80005310 <consoleintr>
    int c = uartgetc();
    80005ab6:	fc9ff0ef          	jal	80005a7e <uartgetc>
    if(c == -1)
    80005aba:	fe951ce3          	bne	a0,s1,80005ab2 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80005abe:	0001e497          	auipc	s1,0x1e
    80005ac2:	19a48493          	addi	s1,s1,410 # 80023c58 <uart_tx_lock>
    80005ac6:	8526                	mv	a0,s1
    80005ac8:	098000ef          	jal	80005b60 <acquire>
  uartstart();
    80005acc:	e6dff0ef          	jal	80005938 <uartstart>
  release(&uart_tx_lock);
    80005ad0:	8526                	mv	a0,s1
    80005ad2:	126000ef          	jal	80005bf8 <release>
}
    80005ad6:	60e2                	ld	ra,24(sp)
    80005ad8:	6442                	ld	s0,16(sp)
    80005ada:	64a2                	ld	s1,8(sp)
    80005adc:	6105                	addi	sp,sp,32
    80005ade:	8082                	ret

0000000080005ae0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005ae0:	1141                	addi	sp,sp,-16
    80005ae2:	e422                	sd	s0,8(sp)
    80005ae4:	0800                	addi	s0,sp,16
  lk->name = name;
    80005ae6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005ae8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005aec:	00053823          	sd	zero,16(a0)
}
    80005af0:	6422                	ld	s0,8(sp)
    80005af2:	0141                	addi	sp,sp,16
    80005af4:	8082                	ret

0000000080005af6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005af6:	411c                	lw	a5,0(a0)
    80005af8:	e399                	bnez	a5,80005afe <holding+0x8>
    80005afa:	4501                	li	a0,0
  return r;
}
    80005afc:	8082                	ret
{
    80005afe:	1101                	addi	sp,sp,-32
    80005b00:	ec06                	sd	ra,24(sp)
    80005b02:	e822                	sd	s0,16(sp)
    80005b04:	e426                	sd	s1,8(sp)
    80005b06:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005b08:	6904                	ld	s1,16(a0)
    80005b0a:	a30fb0ef          	jal	80000d3a <mycpu>
    80005b0e:	40a48533          	sub	a0,s1,a0
    80005b12:	00153513          	seqz	a0,a0
}
    80005b16:	60e2                	ld	ra,24(sp)
    80005b18:	6442                	ld	s0,16(sp)
    80005b1a:	64a2                	ld	s1,8(sp)
    80005b1c:	6105                	addi	sp,sp,32
    80005b1e:	8082                	ret

0000000080005b20 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005b20:	1101                	addi	sp,sp,-32
    80005b22:	ec06                	sd	ra,24(sp)
    80005b24:	e822                	sd	s0,16(sp)
    80005b26:	e426                	sd	s1,8(sp)
    80005b28:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005b2a:	100024f3          	csrr	s1,sstatus
    80005b2e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005b32:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005b34:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005b38:	a02fb0ef          	jal	80000d3a <mycpu>
    80005b3c:	5d3c                	lw	a5,120(a0)
    80005b3e:	cb99                	beqz	a5,80005b54 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005b40:	9fafb0ef          	jal	80000d3a <mycpu>
    80005b44:	5d3c                	lw	a5,120(a0)
    80005b46:	2785                	addiw	a5,a5,1
    80005b48:	dd3c                	sw	a5,120(a0)
}
    80005b4a:	60e2                	ld	ra,24(sp)
    80005b4c:	6442                	ld	s0,16(sp)
    80005b4e:	64a2                	ld	s1,8(sp)
    80005b50:	6105                	addi	sp,sp,32
    80005b52:	8082                	ret
    mycpu()->intena = old;
    80005b54:	9e6fb0ef          	jal	80000d3a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005b58:	8085                	srli	s1,s1,0x1
    80005b5a:	8885                	andi	s1,s1,1
    80005b5c:	dd64                	sw	s1,124(a0)
    80005b5e:	b7cd                	j	80005b40 <push_off+0x20>

0000000080005b60 <acquire>:
{
    80005b60:	1101                	addi	sp,sp,-32
    80005b62:	ec06                	sd	ra,24(sp)
    80005b64:	e822                	sd	s0,16(sp)
    80005b66:	e426                	sd	s1,8(sp)
    80005b68:	1000                	addi	s0,sp,32
    80005b6a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005b6c:	fb5ff0ef          	jal	80005b20 <push_off>
  if(holding(lk))
    80005b70:	8526                	mv	a0,s1
    80005b72:	f85ff0ef          	jal	80005af6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005b76:	4705                	li	a4,1
  if(holding(lk))
    80005b78:	e105                	bnez	a0,80005b98 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005b7a:	87ba                	mv	a5,a4
    80005b7c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005b80:	2781                	sext.w	a5,a5
    80005b82:	ffe5                	bnez	a5,80005b7a <acquire+0x1a>
  __sync_synchronize();
    80005b84:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005b88:	9b2fb0ef          	jal	80000d3a <mycpu>
    80005b8c:	e888                	sd	a0,16(s1)
}
    80005b8e:	60e2                	ld	ra,24(sp)
    80005b90:	6442                	ld	s0,16(sp)
    80005b92:	64a2                	ld	s1,8(sp)
    80005b94:	6105                	addi	sp,sp,32
    80005b96:	8082                	ret
    panic("acquire");
    80005b98:	00002517          	auipc	a0,0x2
    80005b9c:	d4850513          	addi	a0,a0,-696 # 800078e0 <etext+0x8e0>
    80005ba0:	c93ff0ef          	jal	80005832 <panic>

0000000080005ba4 <pop_off>:

void
pop_off(void)
{
    80005ba4:	1141                	addi	sp,sp,-16
    80005ba6:	e406                	sd	ra,8(sp)
    80005ba8:	e022                	sd	s0,0(sp)
    80005baa:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005bac:	98efb0ef          	jal	80000d3a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005bb0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005bb4:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005bb6:	e78d                	bnez	a5,80005be0 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005bb8:	5d3c                	lw	a5,120(a0)
    80005bba:	02f05963          	blez	a5,80005bec <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80005bbe:	37fd                	addiw	a5,a5,-1
    80005bc0:	0007871b          	sext.w	a4,a5
    80005bc4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005bc6:	eb09                	bnez	a4,80005bd8 <pop_off+0x34>
    80005bc8:	5d7c                	lw	a5,124(a0)
    80005bca:	c799                	beqz	a5,80005bd8 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005bcc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005bd0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005bd4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005bd8:	60a2                	ld	ra,8(sp)
    80005bda:	6402                	ld	s0,0(sp)
    80005bdc:	0141                	addi	sp,sp,16
    80005bde:	8082                	ret
    panic("pop_off - interruptible");
    80005be0:	00002517          	auipc	a0,0x2
    80005be4:	d0850513          	addi	a0,a0,-760 # 800078e8 <etext+0x8e8>
    80005be8:	c4bff0ef          	jal	80005832 <panic>
    panic("pop_off");
    80005bec:	00002517          	auipc	a0,0x2
    80005bf0:	d1450513          	addi	a0,a0,-748 # 80007900 <etext+0x900>
    80005bf4:	c3fff0ef          	jal	80005832 <panic>

0000000080005bf8 <release>:
{
    80005bf8:	1101                	addi	sp,sp,-32
    80005bfa:	ec06                	sd	ra,24(sp)
    80005bfc:	e822                	sd	s0,16(sp)
    80005bfe:	e426                	sd	s1,8(sp)
    80005c00:	1000                	addi	s0,sp,32
    80005c02:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005c04:	ef3ff0ef          	jal	80005af6 <holding>
    80005c08:	c105                	beqz	a0,80005c28 <release+0x30>
  lk->cpu = 0;
    80005c0a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005c0e:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005c12:	0310000f          	fence	rw,w
    80005c16:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005c1a:	f8bff0ef          	jal	80005ba4 <pop_off>
}
    80005c1e:	60e2                	ld	ra,24(sp)
    80005c20:	6442                	ld	s0,16(sp)
    80005c22:	64a2                	ld	s1,8(sp)
    80005c24:	6105                	addi	sp,sp,32
    80005c26:	8082                	ret
    panic("release");
    80005c28:	00002517          	auipc	a0,0x2
    80005c2c:	ce050513          	addi	a0,a0,-800 # 80007908 <etext+0x908>
    80005c30:	c03ff0ef          	jal	80005832 <panic>
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
