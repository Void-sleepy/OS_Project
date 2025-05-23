
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	60013103          	ld	sp,1536(sp) # 8000a600 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0b8050ef          	jal	800050ce <start>

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
    80000034:	d5078793          	addi	a5,a5,-688 # 80023d80 <end>
    80000038:	02f56b63          	bltu	a0,a5,8000006e <kfree+0x52>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57763          	bgeu	a0,a5,8000006e <kfree+0x52>
  memset(pa, 1, PGSIZE);
#endif
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000044:	0000a917          	auipc	s2,0xa
    80000048:	60c90913          	addi	s2,s2,1548 # 8000a650 <kmem>
    8000004c:	854a                	mv	a0,s2
    8000004e:	2e3050ef          	jal	80005b30 <acquire>
  r->next = kmem.freelist;
    80000052:	01893783          	ld	a5,24(s2)
    80000056:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000058:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000005c:	854a                	mv	a0,s2
    8000005e:	36b050ef          	jal	80005bc8 <release>
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
    80000076:	78c050ef          	jal	80005802 <panic>

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
    800000d6:	57e50513          	addi	a0,a0,1406 # 8000a650 <kmem>
    800000da:	1d7050ef          	jal	80005ab0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000de:	45c5                	li	a1,17
    800000e0:	05ee                	slli	a1,a1,0x1b
    800000e2:	00024517          	auipc	a0,0x24
    800000e6:	c9e50513          	addi	a0,a0,-866 # 80023d80 <end>
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
    80000104:	55048493          	addi	s1,s1,1360 # 8000a650 <kmem>
    80000108:	8526                	mv	a0,s1
    8000010a:	227050ef          	jal	80005b30 <acquire>
  r = kmem.freelist;
    8000010e:	6c84                	ld	s1,24(s1)
  if(r) {
    80000110:	c491                	beqz	s1,8000011c <kalloc+0x26>
    kmem.freelist = r->next;
    80000112:	609c                	ld	a5,0(s1)
    80000114:	0000a717          	auipc	a4,0xa
    80000118:	54f73a23          	sd	a5,1364(a4) # 8000a668 <kmem+0x18>
  }
  release(&kmem.lock);
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	53450513          	addi	a0,a0,1332 # 8000a650 <kmem>
    80000124:	2a5050ef          	jal	80005bc8 <release>
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
    800002de:	34670713          	addi	a4,a4,838 # 8000a620 <started>
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
    800002fc:	234050ef          	jal	80005530 <printf>
    kvminithart();    // turn on paging
    80000300:	080000ef          	jal	80000380 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000304:	54e010ef          	jal	80001852 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000308:	7e0040ef          	jal	80004ae8 <plicinithart>
  }

  scheduler();        
    8000030c:	68b000ef          	jal	80001196 <scheduler>
    consoleinit();
    80000310:	14a050ef          	jal	8000545a <consoleinit>
    printfinit();
    80000314:	528050ef          	jal	8000583c <printfinit>
    printf("\n");
    80000318:	00007517          	auipc	a0,0x7
    8000031c:	d0050513          	addi	a0,a0,-768 # 80007018 <etext+0x18>
    80000320:	210050ef          	jal	80005530 <printf>
    printf("xv6 kernel is booting\n");
    80000324:	00007517          	auipc	a0,0x7
    80000328:	cfc50513          	addi	a0,a0,-772 # 80007020 <etext+0x20>
    8000032c:	204050ef          	jal	80005530 <printf>
    printf("\n");
    80000330:	00007517          	auipc	a0,0x7
    80000334:	ce850513          	addi	a0,a0,-792 # 80007018 <etext+0x18>
    80000338:	1f8050ef          	jal	80005530 <printf>
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
    80000354:	77a040ef          	jal	80004ace <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000358:	790040ef          	jal	80004ae8 <plicinithart>
    binit();         // buffer cache
    8000035c:	739010ef          	jal	80002294 <binit>
    iinit();         // inode table
    80000360:	52a020ef          	jal	8000288a <iinit>
    fileinit();      // file table
    80000364:	2d6030ef          	jal	8000363a <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000368:	071040ef          	jal	80004bd8 <virtio_disk_init>
    userinit();      // first user process
    8000036c:	457000ef          	jal	80000fc2 <userinit>
    __sync_synchronize();
    80000370:	0330000f          	fence	rw,rw
    started = 1;
    80000374:	4785                	li	a5,1
    80000376:	0000a717          	auipc	a4,0xa
    8000037a:	2af72523          	sw	a5,682(a4) # 8000a620 <started>
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
    8000038e:	29e7b783          	ld	a5,670(a5) # 8000a628 <kernel_pagetable>
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
    800003d6:	42c050ef          	jal	80005802 <panic>
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
    800003fc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb277>
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
    800004ec:	316050ef          	jal	80005802 <panic>
    panic("mappages: size not aligned");
    800004f0:	00007517          	auipc	a0,0x7
    800004f4:	b8850513          	addi	a0,a0,-1144 # 80007078 <etext+0x78>
    800004f8:	30a050ef          	jal	80005802 <panic>
    panic("mappages: size");
    800004fc:	00007517          	auipc	a0,0x7
    80000500:	b9c50513          	addi	a0,a0,-1124 # 80007098 <etext+0x98>
    80000504:	2fe050ef          	jal	80005802 <panic>
      panic("mappages: remap");
    80000508:	00007517          	auipc	a0,0x7
    8000050c:	ba050513          	addi	a0,a0,-1120 # 800070a8 <etext+0xa8>
    80000510:	2f2050ef          	jal	80005802 <panic>
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
    80000554:	2ae050ef          	jal	80005802 <panic>

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
    8000061a:	00a7b923          	sd	a0,18(a5) # 8000a628 <kernel_pagetable>
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
    8000066e:	194050ef          	jal	80005802 <panic>
      panic("uvmunmap: walk");
    80000672:	00007517          	auipc	a0,0x7
    80000676:	a6650513          	addi	a0,a0,-1434 # 800070d8 <etext+0xd8>
    8000067a:	188050ef          	jal	80005802 <panic>
      printf("va=%ld pte=%ld\n", a, *pte);
    8000067e:	85ca                	mv	a1,s2
    80000680:	00007517          	auipc	a0,0x7
    80000684:	a6850513          	addi	a0,a0,-1432 # 800070e8 <etext+0xe8>
    80000688:	6a9040ef          	jal	80005530 <printf>
      panic("uvmunmap: not mapped");
    8000068c:	00007517          	auipc	a0,0x7
    80000690:	a6c50513          	addi	a0,a0,-1428 # 800070f8 <etext+0xf8>
    80000694:	16e050ef          	jal	80005802 <panic>
      panic("uvmunmap: not a leaf");
    80000698:	00007517          	auipc	a0,0x7
    8000069c:	a7850513          	addi	a0,a0,-1416 # 80007110 <etext+0x110>
    800006a0:	162050ef          	jal	80005802 <panic>
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
    80000772:	090050ef          	jal	80005802 <panic>

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
    8000089e:	765040ef          	jal	80005802 <panic>
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
    8000095c:	6a7040ef          	jal	80005802 <panic>
      panic("uvmcopy: page not present");
    80000960:	00007517          	auipc	a0,0x7
    80000964:	81850513          	addi	a0,a0,-2024 # 80007178 <etext+0x178>
    80000968:	69b040ef          	jal	80005802 <panic>
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
    800009c2:	641040ef          	jal	80005802 <panic>

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
    80000bf6:	eae48493          	addi	s1,s1,-338 # 8000aaa0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000bfa:	8b26                	mv	s6,s1
    80000bfc:	ff4df937          	lui	s2,0xff4df
    80000c00:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bac3d>
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
    80000c22:	a82a8a93          	addi	s5,s5,-1406 # 800106a0 <tickslock>
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
    80000c70:	393040ef          	jal	80005802 <panic>

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
    80000c94:	9e050513          	addi	a0,a0,-1568 # 8000a670 <pid_lock>
    80000c98:	619040ef          	jal	80005ab0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000c9c:	00006597          	auipc	a1,0x6
    80000ca0:	51c58593          	addi	a1,a1,1308 # 800071b8 <etext+0x1b8>
    80000ca4:	0000a517          	auipc	a0,0xa
    80000ca8:	9e450513          	addi	a0,a0,-1564 # 8000a688 <wait_lock>
    80000cac:	605040ef          	jal	80005ab0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cb0:	0000a497          	auipc	s1,0xa
    80000cb4:	df048493          	addi	s1,s1,-528 # 8000aaa0 <proc>
      initlock(&p->lock, "proc");
    80000cb8:	00006b17          	auipc	s6,0x6
    80000cbc:	510b0b13          	addi	s6,s6,1296 # 800071c8 <etext+0x1c8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cc0:	8aa6                	mv	s5,s1
    80000cc2:	ff4df937          	lui	s2,0xff4df
    80000cc6:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bac3d>
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
    80000ce8:	9bca0a13          	addi	s4,s4,-1604 # 800106a0 <tickslock>
      initlock(&p->lock, "proc");
    80000cec:	85da                	mv	a1,s6
    80000cee:	8526                	mv	a0,s1
    80000cf0:	5c1040ef          	jal	80005ab0 <initlock>
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
    80000d4a:	95a50513          	addi	a0,a0,-1702 # 8000a6a0 <cpus>
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
    80000d60:	591040ef          	jal	80005af0 <push_off>
    80000d64:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d66:	2781                	sext.w	a5,a5
    80000d68:	079e                	slli	a5,a5,0x7
    80000d6a:	0000a717          	auipc	a4,0xa
    80000d6e:	90670713          	addi	a4,a4,-1786 # 8000a670 <pid_lock>
    80000d72:	97ba                	add	a5,a5,a4
    80000d74:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d76:	5ff040ef          	jal	80005b74 <pop_off>
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
    80000d92:	637040ef          	jal	80005bc8 <release>

  if (first) {
    80000d96:	0000a797          	auipc	a5,0xa
    80000d9a:	81a7a783          	lw	a5,-2022(a5) # 8000a5b0 <first.1>
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
    80000dae:	271010ef          	jal	8000281e <fsinit>
    first = 0;
    80000db2:	00009797          	auipc	a5,0x9
    80000db6:	7e07af23          	sw	zero,2046(a5) # 8000a5b0 <first.1>
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
    80000dd0:	8a490913          	addi	s2,s2,-1884 # 8000a670 <pid_lock>
    80000dd4:	854a                	mv	a0,s2
    80000dd6:	55b040ef          	jal	80005b30 <acquire>
  pid = nextpid;
    80000dda:	00009797          	auipc	a5,0x9
    80000dde:	7da78793          	addi	a5,a5,2010 # 8000a5b4 <nextpid>
    80000de2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000de4:	0014871b          	addiw	a4,s1,1
    80000de8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000dea:	854a                	mv	a0,s2
    80000dec:	5dd040ef          	jal	80005bc8 <release>
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
    80000f28:	b7c48493          	addi	s1,s1,-1156 # 8000aaa0 <proc>
    80000f2c:	0000f917          	auipc	s2,0xf
    80000f30:	77490913          	addi	s2,s2,1908 # 800106a0 <tickslock>
    acquire(&p->lock);
    80000f34:	8526                	mv	a0,s1
    80000f36:	3fb040ef          	jal	80005b30 <acquire>
    if(p->state == UNUSED) {
    80000f3a:	4c9c                	lw	a5,24(s1)
    80000f3c:	cb91                	beqz	a5,80000f50 <allocproc+0x38>
      release(&p->lock);
    80000f3e:	8526                	mv	a0,s1
    80000f40:	489040ef          	jal	80005bc8 <release>
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
    80000faa:	41f040ef          	jal	80005bc8 <release>
    return 0;
    80000fae:	84ca                	mv	s1,s2
    80000fb0:	b7d5                	j	80000f94 <allocproc+0x7c>
    freeproc(p);
    80000fb2:	8526                	mv	a0,s1
    80000fb4:	f15ff0ef          	jal	80000ec8 <freeproc>
    release(&p->lock);
    80000fb8:	8526                	mv	a0,s1
    80000fba:	40f040ef          	jal	80005bc8 <release>
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
    80000fd6:	64a7bf23          	sd	a0,1630(a5) # 8000a630 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000fda:	03400613          	li	a2,52
    80000fde:	00009597          	auipc	a1,0x9
    80000fe2:	5e258593          	addi	a1,a1,1506 # 8000a5c0 <initcode>
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
    80001014:	118020ef          	jal	8000312c <namei>
    80001018:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000101c:	478d                	li	a5,3
    8000101e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001020:	8526                	mv	a0,s1
    80001022:	3a7040ef          	jal	80005bc8 <release>
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
    80001110:	2b9040ef          	jal	80005bc8 <release>
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
    80001126:	596020ef          	jal	800036bc <filedup>
    8000112a:	00a93023          	sd	a0,0(s2)
    8000112e:	b7f5                	j	8000111a <fork+0x9a>
  np->cwd = idup(p->cwd);
    80001130:	150ab503          	ld	a0,336(s5)
    80001134:	0e9010ef          	jal	80002a1c <idup>
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
    80001150:	279040ef          	jal	80005bc8 <release>
  acquire(&wait_lock);
    80001154:	00009497          	auipc	s1,0x9
    80001158:	53448493          	addi	s1,s1,1332 # 8000a688 <wait_lock>
    8000115c:	8526                	mv	a0,s1
    8000115e:	1d3040ef          	jal	80005b30 <acquire>
  np->parent = p;
    80001162:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001166:	8526                	mv	a0,s1
    80001168:	261040ef          	jal	80005bc8 <release>
  acquire(&np->lock);
    8000116c:	854e                	mv	a0,s3
    8000116e:	1c3040ef          	jal	80005b30 <acquire>
  np->state = RUNNABLE;
    80001172:	478d                	li	a5,3
    80001174:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001178:	854e                	mv	a0,s3
    8000117a:	24f040ef          	jal	80005bc8 <release>
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
    800011ba:	4ba70713          	addi	a4,a4,1210 # 8000a670 <pid_lock>
    800011be:	975a                	add	a4,a4,s6
    800011c0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011c4:	00009717          	auipc	a4,0x9
    800011c8:	4e470713          	addi	a4,a4,1252 # 8000a6a8 <cpus+0x8>
    800011cc:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800011ce:	4c11                	li	s8,4
        c->proc = p;
    800011d0:	079e                	slli	a5,a5,0x7
    800011d2:	00009a17          	auipc	s4,0x9
    800011d6:	49ea0a13          	addi	s4,s4,1182 # 8000a670 <pid_lock>
    800011da:	9a3e                	add	s4,s4,a5
        found = 1;
    800011dc:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    800011de:	0000f997          	auipc	s3,0xf
    800011e2:	4c298993          	addi	s3,s3,1218 # 800106a0 <tickslock>
    800011e6:	a0a9                	j	80001230 <scheduler+0x9a>
      release(&p->lock);
    800011e8:	8526                	mv	a0,s1
    800011ea:	1df040ef          	jal	80005bc8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011ee:	17048493          	addi	s1,s1,368
    800011f2:	03348563          	beq	s1,s3,8000121c <scheduler+0x86>
      acquire(&p->lock);
    800011f6:	8526                	mv	a0,s1
    800011f8:	139040ef          	jal	80005b30 <acquire>
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
    80001242:	86248493          	addi	s1,s1,-1950 # 8000aaa0 <proc>
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
    8000125e:	069040ef          	jal	80005ac6 <holding>
    80001262:	c92d                	beqz	a0,800012d4 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001264:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001266:	2781                	sext.w	a5,a5
    80001268:	079e                	slli	a5,a5,0x7
    8000126a:	00009717          	auipc	a4,0x9
    8000126e:	40670713          	addi	a4,a4,1030 # 8000a670 <pid_lock>
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
    80001294:	3e090913          	addi	s2,s2,992 # 8000a670 <pid_lock>
    80001298:	2781                	sext.w	a5,a5
    8000129a:	079e                	slli	a5,a5,0x7
    8000129c:	97ca                	add	a5,a5,s2
    8000129e:	0ac7a983          	lw	s3,172(a5)
    800012a2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012a4:	2781                	sext.w	a5,a5
    800012a6:	079e                	slli	a5,a5,0x7
    800012a8:	00009597          	auipc	a1,0x9
    800012ac:	40058593          	addi	a1,a1,1024 # 8000a6a8 <cpus+0x8>
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
    800012dc:	526040ef          	jal	80005802 <panic>
    panic("sched locks");
    800012e0:	00006517          	auipc	a0,0x6
    800012e4:	f1850513          	addi	a0,a0,-232 # 800071f8 <etext+0x1f8>
    800012e8:	51a040ef          	jal	80005802 <panic>
    panic("sched running");
    800012ec:	00006517          	auipc	a0,0x6
    800012f0:	f1c50513          	addi	a0,a0,-228 # 80007208 <etext+0x208>
    800012f4:	50e040ef          	jal	80005802 <panic>
    panic("sched interruptible");
    800012f8:	00006517          	auipc	a0,0x6
    800012fc:	f2050513          	addi	a0,a0,-224 # 80007218 <etext+0x218>
    80001300:	502040ef          	jal	80005802 <panic>

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
    80001314:	01d040ef          	jal	80005b30 <acquire>
  p->state = RUNNABLE;
    80001318:	478d                	li	a5,3
    8000131a:	cc9c                	sw	a5,24(s1)
  sched();
    8000131c:	f2fff0ef          	jal	8000124a <sched>
  release(&p->lock);
    80001320:	8526                	mv	a0,s1
    80001322:	0a7040ef          	jal	80005bc8 <release>
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
    80001348:	7e8040ef          	jal	80005b30 <acquire>
  release(lk);
    8000134c:	854a                	mv	a0,s2
    8000134e:	07b040ef          	jal	80005bc8 <release>

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
    80001364:	065040ef          	jal	80005bc8 <release>
  acquire(lk);
    80001368:	854a                	mv	a0,s2
    8000136a:	7c6040ef          	jal	80005b30 <acquire>
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
    80001394:	71048493          	addi	s1,s1,1808 # 8000aaa0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001398:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000139a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000139c:	0000f917          	auipc	s2,0xf
    800013a0:	30490913          	addi	s2,s2,772 # 800106a0 <tickslock>
    800013a4:	a801                	j	800013b4 <wakeup+0x38>
      }
      release(&p->lock);
    800013a6:	8526                	mv	a0,s1
    800013a8:	021040ef          	jal	80005bc8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013ac:	17048493          	addi	s1,s1,368
    800013b0:	03248263          	beq	s1,s2,800013d4 <wakeup+0x58>
    if(p != myproc()){
    800013b4:	9a3ff0ef          	jal	80000d56 <myproc>
    800013b8:	fea48ae3          	beq	s1,a0,800013ac <wakeup+0x30>
      acquire(&p->lock);
    800013bc:	8526                	mv	a0,s1
    800013be:	772040ef          	jal	80005b30 <acquire>
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
    800013fc:	6a848493          	addi	s1,s1,1704 # 8000aaa0 <proc>
      pp->parent = initproc;
    80001400:	00009a17          	auipc	s4,0x9
    80001404:	230a0a13          	addi	s4,s4,560 # 8000a630 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001408:	0000f997          	auipc	s3,0xf
    8000140c:	29898993          	addi	s3,s3,664 # 800106a0 <tickslock>
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
    80001458:	1dc7b783          	ld	a5,476(a5) # 8000a630 <initproc>
    8000145c:	0d050493          	addi	s1,a0,208
    80001460:	15050913          	addi	s2,a0,336
    80001464:	00a79f63          	bne	a5,a0,80001482 <exit+0x46>
    panic("init exiting");
    80001468:	00006517          	auipc	a0,0x6
    8000146c:	dc850513          	addi	a0,a0,-568 # 80007230 <etext+0x230>
    80001470:	392040ef          	jal	80005802 <panic>
      fileclose(f);
    80001474:	28e020ef          	jal	80003702 <fileclose>
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
    80001488:	661010ef          	jal	800032e8 <begin_op>
  iput(p->cwd);
    8000148c:	1509b503          	ld	a0,336(s3)
    80001490:	744010ef          	jal	80002bd4 <iput>
  end_op();
    80001494:	6bf010ef          	jal	80003352 <end_op>
  p->cwd = 0;
    80001498:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000149c:	00009497          	auipc	s1,0x9
    800014a0:	1ec48493          	addi	s1,s1,492 # 8000a688 <wait_lock>
    800014a4:	8526                	mv	a0,s1
    800014a6:	68a040ef          	jal	80005b30 <acquire>
  reparent(p);
    800014aa:	854e                	mv	a0,s3
    800014ac:	f3bff0ef          	jal	800013e6 <reparent>
  wakeup(p->parent);
    800014b0:	0389b503          	ld	a0,56(s3)
    800014b4:	ec9ff0ef          	jal	8000137c <wakeup>
  acquire(&p->lock);
    800014b8:	854e                	mv	a0,s3
    800014ba:	676040ef          	jal	80005b30 <acquire>
  p->xstate = status;
    800014be:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014c2:	4795                	li	a5,5
    800014c4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014c8:	8526                	mv	a0,s1
    800014ca:	6fe040ef          	jal	80005bc8 <release>
  sched();
    800014ce:	d7dff0ef          	jal	8000124a <sched>
  panic("zombie exit");
    800014d2:	00006517          	auipc	a0,0x6
    800014d6:	d6e50513          	addi	a0,a0,-658 # 80007240 <etext+0x240>
    800014da:	328040ef          	jal	80005802 <panic>

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
    800014f2:	5b248493          	addi	s1,s1,1458 # 8000aaa0 <proc>
    800014f6:	0000f997          	auipc	s3,0xf
    800014fa:	1aa98993          	addi	s3,s3,426 # 800106a0 <tickslock>
    acquire(&p->lock);
    800014fe:	8526                	mv	a0,s1
    80001500:	630040ef          	jal	80005b30 <acquire>
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
    8000150c:	6bc040ef          	jal	80005bc8 <release>
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
    8000152a:	69e040ef          	jal	80005bc8 <release>
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
    80001550:	5e0040ef          	jal	80005b30 <acquire>
  p->killed = 1;
    80001554:	4785                	li	a5,1
    80001556:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001558:	8526                	mv	a0,s1
    8000155a:	66e040ef          	jal	80005bc8 <release>
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
    80001576:	5ba040ef          	jal	80005b30 <acquire>
  k = p->killed;
    8000157a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000157e:	8526                	mv	a0,s1
    80001580:	648040ef          	jal	80005bc8 <release>
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
    800015b6:	0d650513          	addi	a0,a0,214 # 8000a688 <wait_lock>
    800015ba:	576040ef          	jal	80005b30 <acquire>
    havekids = 0;
    800015be:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800015c0:	4a15                	li	s4,5
        havekids = 1;
    800015c2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015c4:	0000f997          	auipc	s3,0xf
    800015c8:	0dc98993          	addi	s3,s3,220 # 800106a0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015cc:	00009c17          	auipc	s8,0x9
    800015d0:	0bcc0c13          	addi	s8,s8,188 # 8000a688 <wait_lock>
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
    800015fa:	5ce040ef          	jal	80005bc8 <release>
          release(&wait_lock);
    800015fe:	00009517          	auipc	a0,0x9
    80001602:	08a50513          	addi	a0,a0,138 # 8000a688 <wait_lock>
    80001606:	5c2040ef          	jal	80005bc8 <release>
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
    80001626:	5a2040ef          	jal	80005bc8 <release>
            release(&wait_lock);
    8000162a:	00009517          	auipc	a0,0x9
    8000162e:	05e50513          	addi	a0,a0,94 # 8000a688 <wait_lock>
    80001632:	596040ef          	jal	80005bc8 <release>
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
    8000164a:	4e6040ef          	jal	80005b30 <acquire>
        if(pp->state == ZOMBIE){
    8000164e:	4c9c                	lw	a5,24(s1)
    80001650:	f94783e3          	beq	a5,s4,800015d6 <wait+0x44>
        release(&pp->lock);
    80001654:	8526                	mv	a0,s1
    80001656:	572040ef          	jal	80005bc8 <release>
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
    80001676:	42e48493          	addi	s1,s1,1070 # 8000aaa0 <proc>
    8000167a:	b7e1                	j	80001642 <wait+0xb0>
      release(&wait_lock);
    8000167c:	00009517          	auipc	a0,0x9
    80001680:	00c50513          	addi	a0,a0,12 # 8000a688 <wait_lock>
    80001684:	544040ef          	jal	80005bc8 <release>
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
    8000173e:	5f3030ef          	jal	80005530 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001742:	00009497          	auipc	s1,0x9
    80001746:	4b648493          	addi	s1,s1,1206 # 8000abf8 <proc+0x158>
    8000174a:	0000f917          	auipc	s2,0xf
    8000174e:	0ae90913          	addi	s2,s2,174 # 800107f8 <syscall_counts+0x140>
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
    80001770:	174b8b93          	addi	s7,s7,372 # 800078e0 <states.0>
    80001774:	a829                	j	8000178e <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001776:	ed86a583          	lw	a1,-296(a3)
    8000177a:	8556                	mv	a0,s5
    8000177c:	5b5030ef          	jal	80005530 <printf>
    printf("\n");
    80001780:	8552                	mv	a0,s4
    80001782:	5af030ef          	jal	80005530 <printf>
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
    80001842:	e6250513          	addi	a0,a0,-414 # 800106a0 <tickslock>
    80001846:	26a040ef          	jal	80005ab0 <initlock>
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
    8000185c:	21878793          	addi	a5,a5,536 # 80004a70 <kernelvec>
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
    8000192a:	d7a48493          	addi	s1,s1,-646 # 800106a0 <tickslock>
    8000192e:	8526                	mv	a0,s1
    80001930:	200040ef          	jal	80005b30 <acquire>
    ticks++;
    80001934:	00009517          	auipc	a0,0x9
    80001938:	d0450513          	addi	a0,a0,-764 # 8000a638 <ticks>
    8000193c:	411c                	lw	a5,0(a0)
    8000193e:	2785                	addiw	a5,a5,1
    80001940:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001942:	a3bff0ef          	jal	8000137c <wakeup>
    release(&tickslock);
    80001946:	8526                	mv	a0,s1
    80001948:	280040ef          	jal	80005bc8 <release>
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
    8000197c:	1a0030ef          	jal	80004b1c <plic_claim>
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
    80001996:	0de040ef          	jal	80005a74 <uartintr>
    if(irq)
    8000199a:	a819                	j	800019b0 <devintr+0x60>
      virtio_disk_intr();
    8000199c:	646030ef          	jal	80004fe2 <virtio_disk_intr>
    if(irq)
    800019a0:	a801                	j	800019b0 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019a2:	85a6                	mv	a1,s1
    800019a4:	00006517          	auipc	a0,0x6
    800019a8:	8fc50513          	addi	a0,a0,-1796 # 800072a0 <etext+0x2a0>
    800019ac:	385030ef          	jal	80005530 <printf>
      plic_complete(irq);
    800019b0:	8526                	mv	a0,s1
    800019b2:	18a030ef          	jal	80004b3c <plic_complete>
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
    800019de:	09678793          	addi	a5,a5,150 # 80004a70 <kernelvec>
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
    80001a18:	5eb030ef          	jal	80005802 <panic>
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
    80001a36:	626000ef          	jal	8000205c <syscall>
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
    80001a76:	2bb030ef          	jal	80005530 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a7a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a7e:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a82:	00006517          	auipc	a0,0x6
    80001a86:	88e50513          	addi	a0,a0,-1906 # 80007310 <etext+0x310>
    80001a8a:	2a7030ef          	jal	80005530 <printf>
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
    80001aee:	515030ef          	jal	80005802 <panic>
    panic("kerneltrap: interrupts enabled");
    80001af2:	00006517          	auipc	a0,0x6
    80001af6:	86e50513          	addi	a0,a0,-1938 # 80007360 <etext+0x360>
    80001afa:	509030ef          	jal	80005802 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001afe:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b02:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b06:	85ce                	mv	a1,s3
    80001b08:	00006517          	auipc	a0,0x6
    80001b0c:	87850513          	addi	a0,a0,-1928 # 80007380 <etext+0x380>
    80001b10:	221030ef          	jal	80005530 <printf>
    panic("kerneltrap");
    80001b14:	00006517          	auipc	a0,0x6
    80001b18:	89450513          	addi	a0,a0,-1900 # 800073a8 <etext+0x3a8>
    80001b1c:	4e7030ef          	jal	80005802 <panic>
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
    80001b48:	dcc70713          	addi	a4,a4,-564 # 80007910 <states.0+0x30>
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
    80001b88:	47b030ef          	jal	80005802 <panic>

0000000080001b8c <sys_stats>:
};


uint64 syscall_counts[64] = {0};

uint64 sys_stats(void) {
    80001b8c:	7139                	addi	sp,sp,-64
    80001b8e:	fc06                	sd	ra,56(sp)
    80001b90:	f822                	sd	s0,48(sp)
    80001b92:	f426                	sd	s1,40(sp)
    80001b94:	f04a                	sd	s2,32(sp)
    80001b96:	ec4e                	sd	s3,24(sp)
    80001b98:	e852                	sd	s4,16(sp)
    80001b9a:	e456                	sd	s5,8(sp)
    80001b9c:	0080                	addi	s0,sp,64
  for (int i = 0; i < NSYSCALL; i++) {
    80001b9e:	0000f497          	auipc	s1,0xf
    80001ba2:	b1a48493          	addi	s1,s1,-1254 # 800106b8 <syscall_counts>
    80001ba6:	00006917          	auipc	s2,0x6
    80001baa:	d8290913          	addi	s2,s2,-638 # 80007928 <syscall_names>
    80001bae:	0000f997          	auipc	s3,0xf
    80001bb2:	be298993          	addi	s3,s3,-1054 # 80010790 <syscall_counts+0xd8>
    if (syscall_counts[i] > 0) {
      printf("%s: %ld calls\n", syscall_names[i] ? syscall_names[i] : "unknown", syscall_counts[i]);
    80001bb6:	00006a17          	auipc	s4,0x6
    80001bba:	812a0a13          	addi	s4,s4,-2030 # 800073c8 <etext+0x3c8>
    80001bbe:	00006a97          	auipc	s5,0x6
    80001bc2:	802a8a93          	addi	s5,s5,-2046 # 800073c0 <etext+0x3c0>
    80001bc6:	a801                	j	80001bd6 <sys_stats+0x4a>
    80001bc8:	8552                	mv	a0,s4
    80001bca:	167030ef          	jal	80005530 <printf>
  for (int i = 0; i < NSYSCALL; i++) {
    80001bce:	04a1                	addi	s1,s1,8
    80001bd0:	0921                	addi	s2,s2,8
    80001bd2:	01348963          	beq	s1,s3,80001be4 <sys_stats+0x58>
    if (syscall_counts[i] > 0) {
    80001bd6:	6090                	ld	a2,0(s1)
    80001bd8:	da7d                	beqz	a2,80001bce <sys_stats+0x42>
      printf("%s: %ld calls\n", syscall_names[i] ? syscall_names[i] : "unknown", syscall_counts[i]);
    80001bda:	00093583          	ld	a1,0(s2)
    80001bde:	f5ed                	bnez	a1,80001bc8 <sys_stats+0x3c>
    80001be0:	85d6                	mv	a1,s5
    80001be2:	b7dd                	j	80001bc8 <sys_stats+0x3c>
    }
  }
  return 0;
}
    80001be4:	4501                	li	a0,0
    80001be6:	70e2                	ld	ra,56(sp)
    80001be8:	7442                	ld	s0,48(sp)
    80001bea:	74a2                	ld	s1,40(sp)
    80001bec:	7902                	ld	s2,32(sp)
    80001bee:	69e2                	ld	s3,24(sp)
    80001bf0:	6a42                	ld	s4,16(sp)
    80001bf2:	6aa2                	ld	s5,8(sp)
    80001bf4:	6121                	addi	sp,sp,64
    80001bf6:	8082                	ret

0000000080001bf8 <fetchaddr>:
{
    80001bf8:	1101                	addi	sp,sp,-32
    80001bfa:	ec06                	sd	ra,24(sp)
    80001bfc:	e822                	sd	s0,16(sp)
    80001bfe:	e426                	sd	s1,8(sp)
    80001c00:	e04a                	sd	s2,0(sp)
    80001c02:	1000                	addi	s0,sp,32
    80001c04:	84aa                	mv	s1,a0
    80001c06:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c08:	94eff0ef          	jal	80000d56 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c0c:	653c                	ld	a5,72(a0)
    80001c0e:	02f4f663          	bgeu	s1,a5,80001c3a <fetchaddr+0x42>
    80001c12:	00848713          	addi	a4,s1,8
    80001c16:	02e7e463          	bltu	a5,a4,80001c3e <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c1a:	46a1                	li	a3,8
    80001c1c:	8626                	mv	a2,s1
    80001c1e:	85ca                	mv	a1,s2
    80001c20:	6928                	ld	a0,80(a0)
    80001c22:	e7dfe0ef          	jal	80000a9e <copyin>
    80001c26:	00a03533          	snez	a0,a0
    80001c2a:	40a00533          	neg	a0,a0
}
    80001c2e:	60e2                	ld	ra,24(sp)
    80001c30:	6442                	ld	s0,16(sp)
    80001c32:	64a2                	ld	s1,8(sp)
    80001c34:	6902                	ld	s2,0(sp)
    80001c36:	6105                	addi	sp,sp,32
    80001c38:	8082                	ret
    return -1;
    80001c3a:	557d                	li	a0,-1
    80001c3c:	bfcd                	j	80001c2e <fetchaddr+0x36>
    80001c3e:	557d                	li	a0,-1
    80001c40:	b7fd                	j	80001c2e <fetchaddr+0x36>

0000000080001c42 <fetchstr>:
{
    80001c42:	7179                	addi	sp,sp,-48
    80001c44:	f406                	sd	ra,40(sp)
    80001c46:	f022                	sd	s0,32(sp)
    80001c48:	ec26                	sd	s1,24(sp)
    80001c4a:	e84a                	sd	s2,16(sp)
    80001c4c:	e44e                	sd	s3,8(sp)
    80001c4e:	1800                	addi	s0,sp,48
    80001c50:	892a                	mv	s2,a0
    80001c52:	84ae                	mv	s1,a1
    80001c54:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001c56:	900ff0ef          	jal	80000d56 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c5a:	86ce                	mv	a3,s3
    80001c5c:	864a                	mv	a2,s2
    80001c5e:	85a6                	mv	a1,s1
    80001c60:	6928                	ld	a0,80(a0)
    80001c62:	ec3fe0ef          	jal	80000b24 <copyinstr>
    80001c66:	00054c63          	bltz	a0,80001c7e <fetchstr+0x3c>
  return strlen(buf);
    80001c6a:	8526                	mv	a0,s1
    80001c6c:	e38fe0ef          	jal	800002a4 <strlen>
}
    80001c70:	70a2                	ld	ra,40(sp)
    80001c72:	7402                	ld	s0,32(sp)
    80001c74:	64e2                	ld	s1,24(sp)
    80001c76:	6942                	ld	s2,16(sp)
    80001c78:	69a2                	ld	s3,8(sp)
    80001c7a:	6145                	addi	sp,sp,48
    80001c7c:	8082                	ret
    return -1;
    80001c7e:	557d                	li	a0,-1
    80001c80:	bfc5                	j	80001c70 <fetchstr+0x2e>

0000000080001c82 <argint>:
{
    80001c82:	1101                	addi	sp,sp,-32
    80001c84:	ec06                	sd	ra,24(sp)
    80001c86:	e822                	sd	s0,16(sp)
    80001c88:	e426                	sd	s1,8(sp)
    80001c8a:	1000                	addi	s0,sp,32
    80001c8c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c8e:	e9fff0ef          	jal	80001b2c <argraw>
    80001c92:	c088                	sw	a0,0(s1)
}
    80001c94:	60e2                	ld	ra,24(sp)
    80001c96:	6442                	ld	s0,16(sp)
    80001c98:	64a2                	ld	s1,8(sp)
    80001c9a:	6105                	addi	sp,sp,32
    80001c9c:	8082                	ret

0000000080001c9e <sys_socket>:

uint64 sys_socket(void) {
    80001c9e:	1101                	addi	sp,sp,-32
    80001ca0:	ec06                	sd	ra,24(sp)
    80001ca2:	e822                	sd	s0,16(sp)
    80001ca4:	1000                	addi	s0,sp,32
  int domain, type, protocol;
  argint(0, &domain);
    80001ca6:	fec40593          	addi	a1,s0,-20
    80001caa:	4501                	li	a0,0
    80001cac:	fd7ff0ef          	jal	80001c82 <argint>
  argint(1, &type);
    80001cb0:	fe840593          	addi	a1,s0,-24
    80001cb4:	4505                	li	a0,1
    80001cb6:	fcdff0ef          	jal	80001c82 <argint>
  argint(2, &protocol);
    80001cba:	fe440593          	addi	a1,s0,-28
    80001cbe:	4509                	li	a0,2
    80001cc0:	fc3ff0ef          	jal	80001c82 <argint>
  return -1;
}
    80001cc4:	557d                	li	a0,-1
    80001cc6:	60e2                	ld	ra,24(sp)
    80001cc8:	6442                	ld	s0,16(sp)
    80001cca:	6105                	addi	sp,sp,32
    80001ccc:	8082                	ret

0000000080001cce <sys_trace>:

///////////////////////////////////////////////////////////////



uint64 sys_trace(void) {
    80001cce:	7179                	addi	sp,sp,-48
    80001cd0:	f406                	sd	ra,40(sp)
    80001cd2:	f022                	sd	s0,32(sp)
    80001cd4:	ec26                	sd	s1,24(sp)
    80001cd6:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001cd8:	87eff0ef          	jal	80000d56 <myproc>
    80001cdc:	84aa                	mv	s1,a0
  int mask;
  argint(0, &mask);  
    80001cde:	fdc40593          	addi	a1,s0,-36
    80001ce2:	4501                	li	a0,0
    80001ce4:	f9fff0ef          	jal	80001c82 <argint>
  p->trace_mask = mask;
    80001ce8:	fdc42783          	lw	a5,-36(s0)
    80001cec:	16f4a423          	sw	a5,360(s1)
  return 0;
}
    80001cf0:	4501                	li	a0,0
    80001cf2:	70a2                	ld	ra,40(sp)
    80001cf4:	7402                	ld	s0,32(sp)
    80001cf6:	64e2                	ld	s1,24(sp)
    80001cf8:	6145                	addi	sp,sp,48
    80001cfa:	8082                	ret

0000000080001cfc <argaddr>:
{
    80001cfc:	1101                	addi	sp,sp,-32
    80001cfe:	ec06                	sd	ra,24(sp)
    80001d00:	e822                	sd	s0,16(sp)
    80001d02:	e426                	sd	s1,8(sp)
    80001d04:	1000                	addi	s0,sp,32
    80001d06:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d08:	e25ff0ef          	jal	80001b2c <argraw>
    80001d0c:	e088                	sd	a0,0(s1)
}
    80001d0e:	60e2                	ld	ra,24(sp)
    80001d10:	6442                	ld	s0,16(sp)
    80001d12:	64a2                	ld	s1,8(sp)
    80001d14:	6105                	addi	sp,sp,32
    80001d16:	8082                	ret

0000000080001d18 <sys_gettimeofday>:
uint64 sys_gettimeofday(void) {
    80001d18:	1101                	addi	sp,sp,-32
    80001d1a:	ec06                	sd	ra,24(sp)
    80001d1c:	e822                	sd	s0,16(sp)
    80001d1e:	1000                	addi	s0,sp,32
  argaddr(0, &tv_addr);
    80001d20:	fe840593          	addi	a1,s0,-24
    80001d24:	4501                	li	a0,0
    80001d26:	fd7ff0ef          	jal	80001cfc <argaddr>
  argaddr(1, &tz_addr);
    80001d2a:	fe040593          	addi	a1,s0,-32
    80001d2e:	4505                	li	a0,1
    80001d30:	fcdff0ef          	jal	80001cfc <argaddr>
}
    80001d34:	557d                	li	a0,-1
    80001d36:	60e2                	ld	ra,24(sp)
    80001d38:	6442                	ld	s0,16(sp)
    80001d3a:	6105                	addi	sp,sp,32
    80001d3c:	8082                	ret

0000000080001d3e <sys_mmap>:
uint64 sys_mmap(void) {
    80001d3e:	7179                	addi	sp,sp,-48
    80001d40:	f406                	sd	ra,40(sp)
    80001d42:	f022                	sd	s0,32(sp)
    80001d44:	1800                	addi	s0,sp,48
  argaddr(0, &addr);
    80001d46:	fe840593          	addi	a1,s0,-24
    80001d4a:	4501                	li	a0,0
    80001d4c:	fb1ff0ef          	jal	80001cfc <argaddr>
  argint(1, &length);
    80001d50:	fe440593          	addi	a1,s0,-28
    80001d54:	4505                	li	a0,1
    80001d56:	f2dff0ef          	jal	80001c82 <argint>
  argint(2, &prot);
    80001d5a:	fe040593          	addi	a1,s0,-32
    80001d5e:	4509                	li	a0,2
    80001d60:	f23ff0ef          	jal	80001c82 <argint>
  argint(3, &flags);
    80001d64:	fdc40593          	addi	a1,s0,-36
    80001d68:	450d                	li	a0,3
    80001d6a:	f19ff0ef          	jal	80001c82 <argint>
  argint(4, &fd);
    80001d6e:	fd840593          	addi	a1,s0,-40
    80001d72:	4511                	li	a0,4
    80001d74:	f0fff0ef          	jal	80001c82 <argint>
  argint(5, &offset);
    80001d78:	fd440593          	addi	a1,s0,-44
    80001d7c:	4515                	li	a0,5
    80001d7e:	f05ff0ef          	jal	80001c82 <argint>
}
    80001d82:	557d                	li	a0,-1
    80001d84:	70a2                	ld	ra,40(sp)
    80001d86:	7402                	ld	s0,32(sp)
    80001d88:	6145                	addi	sp,sp,48
    80001d8a:	8082                	ret

0000000080001d8c <argstr>:
{
    80001d8c:	7179                	addi	sp,sp,-48
    80001d8e:	f406                	sd	ra,40(sp)
    80001d90:	f022                	sd	s0,32(sp)
    80001d92:	ec26                	sd	s1,24(sp)
    80001d94:	e84a                	sd	s2,16(sp)
    80001d96:	1800                	addi	s0,sp,48
    80001d98:	84ae                	mv	s1,a1
    80001d9a:	8932                	mv	s2,a2
  argaddr(n, &addr);
    80001d9c:	fd840593          	addi	a1,s0,-40
    80001da0:	f5dff0ef          	jal	80001cfc <argaddr>
  return fetchstr(addr, buf, max);
    80001da4:	864a                	mv	a2,s2
    80001da6:	85a6                	mv	a1,s1
    80001da8:	fd843503          	ld	a0,-40(s0)
    80001dac:	e97ff0ef          	jal	80001c42 <fetchstr>
}
    80001db0:	70a2                	ld	ra,40(sp)
    80001db2:	7402                	ld	s0,32(sp)
    80001db4:	64e2                	ld	s1,24(sp)
    80001db6:	6942                	ld	s2,16(sp)
    80001db8:	6145                	addi	sp,sp,48
    80001dba:	8082                	ret

0000000080001dbc <read_string>:



////////////////////////////////////////////////////////////////////////////////////////////////////
// Read null-terminated string from user space
int read_string(struct proc *p, uint64 addr, char *buf, int max) {
    80001dbc:	715d                	addi	sp,sp,-80
    80001dbe:	e486                	sd	ra,72(sp)
    80001dc0:	e0a2                	sd	s0,64(sp)
    80001dc2:	f84a                	sd	s2,48(sp)
    80001dc4:	0880                	addi	s0,sp,80
  
  if(addr >= p->sz)
    80001dc6:	653c                	ld	a5,72(a0)
    80001dc8:	08f5f563          	bgeu	a1,a5,80001e52 <read_string+0x96>
    80001dcc:	f052                	sd	s4,32(sp)
    80001dce:	ec56                	sd	s5,24(sp)
    80001dd0:	e45e                	sd	s7,8(sp)
    80001dd2:	8aaa                	mv	s5,a0
    80001dd4:	8bb2                	mv	s7,a2
    80001dd6:	8a36                	mv	s4,a3
  {
    return -1; }
  int n = 0;
  while(n < max) {
    80001dd8:	06d05763          	blez	a3,80001e46 <read_string+0x8a>
    80001ddc:	fc26                	sd	s1,56(sp)
    80001dde:	f44e                	sd	s3,40(sp)
    80001de0:	e85a                	sd	s6,16(sp)
    80001de2:	84b2                	mv	s1,a2
  int n = 0;
    80001de4:	4901                	li	s2,0
    if(copyin(p->pagetable, buf + n, addr + n, 1) == -1) {
    80001de6:	40c589b3          	sub	s3,a1,a2
    80001dea:	5b7d                	li	s6,-1
    80001dec:	4685                	li	a3,1
    80001dee:	00998633          	add	a2,s3,s1
    80001df2:	85a6                	mv	a1,s1
    80001df4:	050ab503          	ld	a0,80(s5)
    80001df8:	ca7fe0ef          	jal	80000a9e <copyin>
    80001dfc:	03650463          	beq	a0,s6,80001e24 <read_string+0x68>
      break;
    }
    if(buf[n] == '\0'){
    80001e00:	0004c783          	lbu	a5,0(s1)
    80001e04:	c385                	beqz	a5,80001e24 <read_string+0x68>
      break;
    }
    n++;
    80001e06:	2905                	addiw	s2,s2,1
  while(n < max) {
    80001e08:	0485                	addi	s1,s1,1
    80001e0a:	ff2a11e3          	bne	s4,s2,80001dec <read_string+0x30>
    80001e0e:	8952                	mv	s2,s4
    80001e10:	74e2                	ld	s1,56(sp)
    80001e12:	79a2                	ld	s3,40(sp)
    80001e14:	6b42                	ld	s6,16(sp)
  }
  if(n < max){
    buf[n] = '\0';
  } else {
    buf[max-1] = '\0';
    80001e16:	9bd2                	add	s7,s7,s4
    80001e18:	fe0b8fa3          	sb	zero,-1(s7)
    80001e1c:	7a02                	ld	s4,32(sp)
    80001e1e:	6ae2                	ld	s5,24(sp)
    80001e20:	6ba2                	ld	s7,8(sp)
    80001e22:	a821                	j	80001e3a <read_string+0x7e>
  if(n < max){
    80001e24:	03495363          	bge	s2,s4,80001e4a <read_string+0x8e>
    buf[n] = '\0';
    80001e28:	9bca                	add	s7,s7,s2
    80001e2a:	000b8023          	sb	zero,0(s7)
    80001e2e:	74e2                	ld	s1,56(sp)
    80001e30:	79a2                	ld	s3,40(sp)
    80001e32:	7a02                	ld	s4,32(sp)
    80001e34:	6ae2                	ld	s5,24(sp)
    80001e36:	6b42                	ld	s6,16(sp)
    80001e38:	6ba2                	ld	s7,8(sp)
  } 
  return n;
}
    80001e3a:	854a                	mv	a0,s2
    80001e3c:	60a6                	ld	ra,72(sp)
    80001e3e:	6406                	ld	s0,64(sp)
    80001e40:	7942                	ld	s2,48(sp)
    80001e42:	6161                	addi	sp,sp,80
    80001e44:	8082                	ret
  int n = 0;
    80001e46:	4901                	li	s2,0
    80001e48:	b7f9                	j	80001e16 <read_string+0x5a>
    80001e4a:	74e2                	ld	s1,56(sp)
    80001e4c:	79a2                	ld	s3,40(sp)
    80001e4e:	6b42                	ld	s6,16(sp)
    80001e50:	b7d9                	j	80001e16 <read_string+0x5a>
    return -1; }
    80001e52:	597d                	li	s2,-1
    80001e54:	b7dd                	j	80001e3a <read_string+0x7e>

0000000080001e56 <read_memory>:

////////////////////////////////////////////////////////////////////////////////////////////////////
// Read arbitrary memory from user space
int read_memory(struct proc *p, uint64 addr, char *buf, int n) {
    80001e56:	87ae                	mv	a5,a1

  if(addr >= p->sz || addr + n > p->sz)
    80001e58:	6538                	ld	a4,72(a0)
    80001e5a:	02e5fa63          	bgeu	a1,a4,80001e8e <read_memory+0x38>
int read_memory(struct proc *p, uint64 addr, char *buf, int n) {
    80001e5e:	1101                	addi	sp,sp,-32
    80001e60:	ec06                	sd	ra,24(sp)
    80001e62:	e822                	sd	s0,16(sp)
    80001e64:	e426                	sd	s1,8(sp)
    80001e66:	1000                	addi	s0,sp,32
    80001e68:	85b2                	mv	a1,a2
    80001e6a:	84b6                	mv	s1,a3
  if(addr >= p->sz || addr + n > p->sz)
    80001e6c:	96be                	add	a3,a3,a5
    80001e6e:	02d76263          	bltu	a4,a3,80001e92 <read_memory+0x3c>
    return -1;

  if(copyin(p->pagetable, buf, addr, n) == -1)
    80001e72:	86a6                	mv	a3,s1
    80001e74:	863e                	mv	a2,a5
    80001e76:	6928                	ld	a0,80(a0)
    80001e78:	c27fe0ef          	jal	80000a9e <copyin>
    80001e7c:	57fd                	li	a5,-1
    80001e7e:	00f50363          	beq	a0,a5,80001e84 <read_memory+0x2e>
    return -1;

  return n;
    80001e82:	8526                	mv	a0,s1
}
    80001e84:	60e2                	ld	ra,24(sp)
    80001e86:	6442                	ld	s0,16(sp)
    80001e88:	64a2                	ld	s1,8(sp)
    80001e8a:	6105                	addi	sp,sp,32
    80001e8c:	8082                	ret
    return -1;
    80001e8e:	557d                	li	a0,-1
}
    80001e90:	8082                	ret
    return -1;
    80001e92:	557d                	li	a0,-1
    80001e94:	bfc5                	j	80001e84 <read_memory+0x2e>

0000000080001e96 <print_syscall>:

//////////////////////////////////////////////////////////////


// Print system call details (enhanced for open's mode)
void print_syscall(struct proc *p, int num, uint64 ret) {
    80001e96:	7159                	addi	sp,sp,-112
    80001e98:	f486                	sd	ra,104(sp)
    80001e9a:	f0a2                	sd	s0,96(sp)
    80001e9c:	eca6                	sd	s1,88(sp)
    80001e9e:	e8ca                	sd	s2,80(sp)
    80001ea0:	e4ce                	sd	s3,72(sp)
    80001ea2:	1880                	addi	s0,sp,112
    80001ea4:	84aa                	mv	s1,a0
    80001ea6:	892e                	mv	s2,a1
    80001ea8:	89b2                	mv	s3,a2
    printf("%d: %s(", p->pid, syscall_names[num]);
    80001eaa:	00359713          	slli	a4,a1,0x3
    80001eae:	00006797          	auipc	a5,0x6
    80001eb2:	a7a78793          	addi	a5,a5,-1414 # 80007928 <syscall_names>
    80001eb6:	97ba                	add	a5,a5,a4
    80001eb8:	6390                	ld	a2,0(a5)
    80001eba:	590c                	lw	a1,48(a0)
    80001ebc:	00005517          	auipc	a0,0x5
    80001ec0:	51c50513          	addi	a0,a0,1308 # 800073d8 <etext+0x3d8>
    80001ec4:	66c030ef          	jal	80005530 <printf>
    switch (num) {
    80001ec8:	47bd                	li	a5,15
    80001eca:	08f90063          	beq	s2,a5,80001f4a <print_syscall+0xb4>
    80001ece:	47c1                	li	a5,16
    80001ed0:	0ef90963          	beq	s2,a5,80001fc2 <print_syscall+0x12c>
    80001ed4:	4795                	li	a5,5
    80001ed6:	0af91663          	bne	s2,a5,80001f82 <print_syscall+0xec>
        }
        printf(", %ld, 0%lo", p->trapframe->a1, p->trapframe->a2); // CHANGED: Added mode
        break;
    }
    case SYS_read: {
        printf("%ld, 0x%lx, %ld", p->trapframe->a0, p->trapframe->a1, p->trapframe->a2);
    80001eda:	6cbc                	ld	a5,88(s1)
    80001edc:	63d4                	ld	a3,128(a5)
    80001ede:	7fb0                	ld	a2,120(a5)
    80001ee0:	7bac                	ld	a1,112(a5)
    80001ee2:	00005517          	auipc	a0,0x5
    80001ee6:	51e50513          	addi	a0,a0,1310 # 80007400 <etext+0x400>
    80001eea:	646030ef          	jal	80005530 <printf>
        if ((int)ret > 0 && (int)ret <= 32) {
    80001eee:	fff9879b          	addiw	a5,s3,-1
    80001ef2:	477d                	li	a4,31
    80001ef4:	08f76763          	bltu	a4,a5,80001f82 <print_syscall+0xec>
            char buf[33];
            if (read_memory(p, p->trapframe->a1, buf, ret) >= 0) {
    80001ef8:	6cbc                	ld	a5,88(s1)
    80001efa:	0009869b          	sext.w	a3,s3
    80001efe:	f9040613          	addi	a2,s0,-112
    80001f02:	7fac                	ld	a1,120(a5)
    80001f04:	8526                	mv	a0,s1
    80001f06:	f51ff0ef          	jal	80001e56 <read_memory>
    80001f0a:	0a054363          	bltz	a0,80001fb0 <print_syscall+0x11a>
                buf[ret] = '\0';
    80001f0e:	fd098793          	addi	a5,s3,-48
    80001f12:	97a2                	add	a5,a5,s0
    80001f14:	fc078023          	sb	zero,-64(a5)
                int is_string = 1;
                for (int i = 0; i < ret; i++) {
    80001f18:	f9040713          	addi	a4,s0,-112
    80001f1c:	00e98633          	add	a2,s3,a4
                    if (buf[i] < 32 || buf[i] > 126) {
    80001f20:	05e00693          	li	a3,94
    80001f24:	00074783          	lbu	a5,0(a4)
    80001f28:	3781                	addiw	a5,a5,-32
    80001f2a:	0ff7f793          	zext.b	a5,a5
    80001f2e:	10f6ee63          	bltu	a3,a5,8000204a <print_syscall+0x1b4>
                for (int i = 0; i < ret; i++) {
    80001f32:	0705                	addi	a4,a4,1
    80001f34:	fec718e3          	bne	a4,a2,80001f24 <print_syscall+0x8e>
                        is_string = 0;
                        break;
                    }
                }
                if (is_string) printf(" → \"%s\"", buf);
    80001f38:	f9040593          	addi	a1,s0,-112
    80001f3c:	00005517          	auipc	a0,0x5
    80001f40:	50c50513          	addi	a0,a0,1292 # 80007448 <etext+0x448>
    80001f44:	5ec030ef          	jal	80005530 <printf>
    80001f48:	a82d                	j	80001f82 <print_syscall+0xec>
        if (read_string(p, p->trapframe->a0, filename, sizeof(filename)) >= 0) {
    80001f4a:	6cbc                	ld	a5,88(s1)
    80001f4c:	04000693          	li	a3,64
    80001f50:	f9040613          	addi	a2,s0,-112
    80001f54:	7bac                	ld	a1,112(a5)
    80001f56:	8526                	mv	a0,s1
    80001f58:	e65ff0ef          	jal	80001dbc <read_string>
    80001f5c:	04054163          	bltz	a0,80001f9e <print_syscall+0x108>
            printf("\"%s\"", filename);
    80001f60:	f9040593          	addi	a1,s0,-112
    80001f64:	00005517          	auipc	a0,0x5
    80001f68:	47c50513          	addi	a0,a0,1148 # 800073e0 <etext+0x3e0>
    80001f6c:	5c4030ef          	jal	80005530 <printf>
        printf(", %ld, 0%lo", p->trapframe->a1, p->trapframe->a2); // CHANGED: Added mode
    80001f70:	6cbc                	ld	a5,88(s1)
    80001f72:	63d0                	ld	a2,128(a5)
    80001f74:	7fac                	ld	a1,120(a5)
    80001f76:	00005517          	auipc	a0,0x5
    80001f7a:	47a50513          	addi	a0,a0,1146 # 800073f0 <etext+0x3f0>
    80001f7e:	5b2030ef          	jal	80005530 <printf>
        break;
    }
    default:
        break;
    }
    printf(") = %ld\n", ret); // CHANGED: Aligned with strace format
    80001f82:	85ce                	mv	a1,s3
    80001f84:	00005517          	auipc	a0,0x5
    80001f88:	4b450513          	addi	a0,a0,1204 # 80007438 <etext+0x438>
    80001f8c:	5a4030ef          	jal	80005530 <printf>
}
    80001f90:	70a6                	ld	ra,104(sp)
    80001f92:	7406                	ld	s0,96(sp)
    80001f94:	64e6                	ld	s1,88(sp)
    80001f96:	6946                	ld	s2,80(sp)
    80001f98:	69a6                	ld	s3,72(sp)
    80001f9a:	6165                	addi	sp,sp,112
    80001f9c:	8082                	ret
            printf("0x%lx", p->trapframe->a0);
    80001f9e:	6cbc                	ld	a5,88(s1)
    80001fa0:	7bac                	ld	a1,112(a5)
    80001fa2:	00005517          	auipc	a0,0x5
    80001fa6:	44650513          	addi	a0,a0,1094 # 800073e8 <etext+0x3e8>
    80001faa:	586030ef          	jal	80005530 <printf>
    80001fae:	b7c9                	j	80001f70 <print_syscall+0xda>
                printf(" → 0x%lx", p->trapframe->a1); // CHANGED: Added fallback
    80001fb0:	6cbc                	ld	a5,88(s1)
    80001fb2:	7fac                	ld	a1,120(a5)
    80001fb4:	00005517          	auipc	a0,0x5
    80001fb8:	45c50513          	addi	a0,a0,1116 # 80007410 <etext+0x410>
    80001fbc:	574030ef          	jal	80005530 <printf>
    80001fc0:	b7c9                	j	80001f82 <print_syscall+0xec>
        printf("%ld, ", p->trapframe->a0);
    80001fc2:	6cbc                	ld	a5,88(s1)
    80001fc4:	7bac                	ld	a1,112(a5)
    80001fc6:	00005517          	auipc	a0,0x5
    80001fca:	45a50513          	addi	a0,a0,1114 # 80007420 <etext+0x420>
    80001fce:	562030ef          	jal	80005530 <printf>
        int n = p->trapframe->a2 > 32 ? 32 : p->trapframe->a2;
    80001fd2:	6cbc                	ld	a5,88(s1)
    80001fd4:	63d4                	ld	a3,128(a5)
    80001fd6:	02000713          	li	a4,32
    80001fda:	00d77463          	bgeu	a4,a3,80001fe2 <print_syscall+0x14c>
    80001fde:	02000693          	li	a3,32
    80001fe2:	0006891b          	sext.w	s2,a3
        if (read_memory(p, p->trapframe->a1, buf, n) >= 0) {
    80001fe6:	86ca                	mv	a3,s2
    80001fe8:	f9040613          	addi	a2,s0,-112
    80001fec:	7fac                	ld	a1,120(a5)
    80001fee:	8526                	mv	a0,s1
    80001ff0:	e67ff0ef          	jal	80001e56 <read_memory>
    80001ff4:	02054a63          	bltz	a0,80002028 <print_syscall+0x192>
            buf[n] = '\0';
    80001ff8:	fd090793          	addi	a5,s2,-48
    80001ffc:	97a2                	add	a5,a5,s0
    80001ffe:	fc078023          	sb	zero,-64(a5)
            printf("\"%s\"", buf);
    80002002:	f9040593          	addi	a1,s0,-112
    80002006:	00005517          	auipc	a0,0x5
    8000200a:	3da50513          	addi	a0,a0,986 # 800073e0 <etext+0x3e0>
    8000200e:	522030ef          	jal	80005530 <printf>
            if (n < p->trapframe->a2) printf("...");
    80002012:	6cbc                	ld	a5,88(s1)
    80002014:	63dc                	ld	a5,128(a5)
    80002016:	02f97163          	bgeu	s2,a5,80002038 <print_syscall+0x1a2>
    8000201a:	00005517          	auipc	a0,0x5
    8000201e:	40e50513          	addi	a0,a0,1038 # 80007428 <etext+0x428>
    80002022:	50e030ef          	jal	80005530 <printf>
    80002026:	a809                	j	80002038 <print_syscall+0x1a2>
            printf("0x%lx", p->trapframe->a1);
    80002028:	6cbc                	ld	a5,88(s1)
    8000202a:	7fac                	ld	a1,120(a5)
    8000202c:	00005517          	auipc	a0,0x5
    80002030:	3bc50513          	addi	a0,a0,956 # 800073e8 <etext+0x3e8>
    80002034:	4fc030ef          	jal	80005530 <printf>
        printf(", %ld", p->trapframe->a2);
    80002038:	6cbc                	ld	a5,88(s1)
    8000203a:	63cc                	ld	a1,128(a5)
    8000203c:	00005517          	auipc	a0,0x5
    80002040:	3f450513          	addi	a0,a0,1012 # 80007430 <etext+0x430>
    80002044:	4ec030ef          	jal	80005530 <printf>
        break;
    80002048:	bf2d                	j	80001f82 <print_syscall+0xec>
                else printf(" → 0x%lx", p->trapframe->a1); // CHANGED: Added fallback
    8000204a:	6cbc                	ld	a5,88(s1)
    8000204c:	7fac                	ld	a1,120(a5)
    8000204e:	00005517          	auipc	a0,0x5
    80002052:	3c250513          	addi	a0,a0,962 # 80007410 <etext+0x410>
    80002056:	4da030ef          	jal	80005530 <printf>
    8000205a:	b725                	j	80001f82 <print_syscall+0xec>

000000008000205c <syscall>:
{
    8000205c:	7179                	addi	sp,sp,-48
    8000205e:	f406                	sd	ra,40(sp)
    80002060:	f022                	sd	s0,32(sp)
    80002062:	ec26                	sd	s1,24(sp)
    80002064:	e84a                	sd	s2,16(sp)
    80002066:	e44e                	sd	s3,8(sp)
    80002068:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000206a:	cedfe0ef          	jal	80000d56 <myproc>
    8000206e:	84aa                	mv	s1,a0
  num = p->trapframe->a7;
    80002070:	05853983          	ld	s3,88(a0)
    80002074:	0a89b783          	ld	a5,168(s3)
    80002078:	0007891b          	sext.w	s2,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000207c:	37fd                	addiw	a5,a5,-1
    8000207e:	4765                	li	a4,25
    80002080:	04f76563          	bltu	a4,a5,800020ca <syscall+0x6e>
    80002084:	00391713          	slli	a4,s2,0x3
    80002088:	00006797          	auipc	a5,0x6
    8000208c:	8a078793          	addi	a5,a5,-1888 # 80007928 <syscall_names>
    80002090:	97ba                	add	a5,a5,a4
    80002092:	6ffc                	ld	a5,216(a5)
    80002094:	cb9d                	beqz	a5,800020ca <syscall+0x6e>
    p->trapframe->a0 = syscalls[num]();
    80002096:	9782                	jalr	a5
    80002098:	06a9b823          	sd	a0,112(s3)
    syscall_counts[num]++;
    8000209c:	00391713          	slli	a4,s2,0x3
    800020a0:	0000e797          	auipc	a5,0xe
    800020a4:	61878793          	addi	a5,a5,1560 # 800106b8 <syscall_counts>
    800020a8:	97ba                	add	a5,a5,a4
    800020aa:	6398                	ld	a4,0(a5)
    800020ac:	0705                	addi	a4,a4,1
    800020ae:	e398                	sd	a4,0(a5)
    if(p->trace_mask & (1 << num)) {
    800020b0:	1684a783          	lw	a5,360(s1)
    800020b4:	4127d7bb          	sraw	a5,a5,s2
    800020b8:	8b85                	andi	a5,a5,1
    800020ba:	c78d                	beqz	a5,800020e4 <syscall+0x88>
      print_syscall(p, num, p->trapframe->a0);
    800020bc:	6cbc                	ld	a5,88(s1)
    800020be:	7bb0                	ld	a2,112(a5)
    800020c0:	85ca                	mv	a1,s2
    800020c2:	8526                	mv	a0,s1
    800020c4:	dd3ff0ef          	jal	80001e96 <print_syscall>
    800020c8:	a831                	j	800020e4 <syscall+0x88>
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    800020ca:	86ca                	mv	a3,s2
    800020cc:	15848613          	addi	a2,s1,344
    800020d0:	588c                	lw	a1,48(s1)
    800020d2:	00005517          	auipc	a0,0x5
    800020d6:	38650513          	addi	a0,a0,902 # 80007458 <etext+0x458>
    800020da:	456030ef          	jal	80005530 <printf>
    p->trapframe->a0 = -1;
    800020de:	6cbc                	ld	a5,88(s1)
    800020e0:	577d                	li	a4,-1
    800020e2:	fbb8                	sd	a4,112(a5)
}
    800020e4:	70a2                	ld	ra,40(sp)
    800020e6:	7402                	ld	s0,32(sp)
    800020e8:	64e2                	ld	s1,24(sp)
    800020ea:	6942                	ld	s2,16(sp)
    800020ec:	69a2                	ld	s3,8(sp)
    800020ee:	6145                	addi	sp,sp,48
    800020f0:	8082                	ret

00000000800020f2 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020f2:	1101                	addi	sp,sp,-32
    800020f4:	ec06                	sd	ra,24(sp)
    800020f6:	e822                	sd	s0,16(sp)
    800020f8:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800020fa:	fec40593          	addi	a1,s0,-20
    800020fe:	4501                	li	a0,0
    80002100:	b83ff0ef          	jal	80001c82 <argint>
  exit(n);
    80002104:	fec42503          	lw	a0,-20(s0)
    80002108:	b34ff0ef          	jal	8000143c <exit>
  return 0;  // not reached
}
    8000210c:	4501                	li	a0,0
    8000210e:	60e2                	ld	ra,24(sp)
    80002110:	6442                	ld	s0,16(sp)
    80002112:	6105                	addi	sp,sp,32
    80002114:	8082                	ret

0000000080002116 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002116:	1141                	addi	sp,sp,-16
    80002118:	e406                	sd	ra,8(sp)
    8000211a:	e022                	sd	s0,0(sp)
    8000211c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000211e:	c39fe0ef          	jal	80000d56 <myproc>
}
    80002122:	5908                	lw	a0,48(a0)
    80002124:	60a2                	ld	ra,8(sp)
    80002126:	6402                	ld	s0,0(sp)
    80002128:	0141                	addi	sp,sp,16
    8000212a:	8082                	ret

000000008000212c <sys_fork>:

uint64
sys_fork(void)
{
    8000212c:	1141                	addi	sp,sp,-16
    8000212e:	e406                	sd	ra,8(sp)
    80002130:	e022                	sd	s0,0(sp)
    80002132:	0800                	addi	s0,sp,16
  return fork();
    80002134:	f4dfe0ef          	jal	80001080 <fork>
}
    80002138:	60a2                	ld	ra,8(sp)
    8000213a:	6402                	ld	s0,0(sp)
    8000213c:	0141                	addi	sp,sp,16
    8000213e:	8082                	ret

0000000080002140 <sys_wait>:

uint64
sys_wait(void)
{
    80002140:	1101                	addi	sp,sp,-32
    80002142:	ec06                	sd	ra,24(sp)
    80002144:	e822                	sd	s0,16(sp)
    80002146:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002148:	fe840593          	addi	a1,s0,-24
    8000214c:	4501                	li	a0,0
    8000214e:	bafff0ef          	jal	80001cfc <argaddr>
  return wait(p);
    80002152:	fe843503          	ld	a0,-24(s0)
    80002156:	c3cff0ef          	jal	80001592 <wait>
}
    8000215a:	60e2                	ld	ra,24(sp)
    8000215c:	6442                	ld	s0,16(sp)
    8000215e:	6105                	addi	sp,sp,32
    80002160:	8082                	ret

0000000080002162 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002162:	7179                	addi	sp,sp,-48
    80002164:	f406                	sd	ra,40(sp)
    80002166:	f022                	sd	s0,32(sp)
    80002168:	ec26                	sd	s1,24(sp)
    8000216a:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000216c:	fdc40593          	addi	a1,s0,-36
    80002170:	4501                	li	a0,0
    80002172:	b11ff0ef          	jal	80001c82 <argint>
  addr = myproc()->sz;
    80002176:	be1fe0ef          	jal	80000d56 <myproc>
    8000217a:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000217c:	fdc42503          	lw	a0,-36(s0)
    80002180:	eb1fe0ef          	jal	80001030 <growproc>
    80002184:	00054863          	bltz	a0,80002194 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002188:	8526                	mv	a0,s1
    8000218a:	70a2                	ld	ra,40(sp)
    8000218c:	7402                	ld	s0,32(sp)
    8000218e:	64e2                	ld	s1,24(sp)
    80002190:	6145                	addi	sp,sp,48
    80002192:	8082                	ret
    return -1;
    80002194:	54fd                	li	s1,-1
    80002196:	bfcd                	j	80002188 <sys_sbrk+0x26>

0000000080002198 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002198:	7139                	addi	sp,sp,-64
    8000219a:	fc06                	sd	ra,56(sp)
    8000219c:	f822                	sd	s0,48(sp)
    8000219e:	f04a                	sd	s2,32(sp)
    800021a0:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800021a2:	fcc40593          	addi	a1,s0,-52
    800021a6:	4501                	li	a0,0
    800021a8:	adbff0ef          	jal	80001c82 <argint>
  if(n < 0)
    800021ac:	fcc42783          	lw	a5,-52(s0)
    800021b0:	0607c763          	bltz	a5,8000221e <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    800021b4:	0000e517          	auipc	a0,0xe
    800021b8:	4ec50513          	addi	a0,a0,1260 # 800106a0 <tickslock>
    800021bc:	175030ef          	jal	80005b30 <acquire>
  ticks0 = ticks;
    800021c0:	00008917          	auipc	s2,0x8
    800021c4:	47892903          	lw	s2,1144(s2) # 8000a638 <ticks>
  while(ticks - ticks0 < n){
    800021c8:	fcc42783          	lw	a5,-52(s0)
    800021cc:	cf8d                	beqz	a5,80002206 <sys_sleep+0x6e>
    800021ce:	f426                	sd	s1,40(sp)
    800021d0:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021d2:	0000e997          	auipc	s3,0xe
    800021d6:	4ce98993          	addi	s3,s3,1230 # 800106a0 <tickslock>
    800021da:	00008497          	auipc	s1,0x8
    800021de:	45e48493          	addi	s1,s1,1118 # 8000a638 <ticks>
    if(killed(myproc())){
    800021e2:	b75fe0ef          	jal	80000d56 <myproc>
    800021e6:	b82ff0ef          	jal	80001568 <killed>
    800021ea:	ed0d                	bnez	a0,80002224 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    800021ec:	85ce                	mv	a1,s3
    800021ee:	8526                	mv	a0,s1
    800021f0:	940ff0ef          	jal	80001330 <sleep>
  while(ticks - ticks0 < n){
    800021f4:	409c                	lw	a5,0(s1)
    800021f6:	412787bb          	subw	a5,a5,s2
    800021fa:	fcc42703          	lw	a4,-52(s0)
    800021fe:	fee7e2e3          	bltu	a5,a4,800021e2 <sys_sleep+0x4a>
    80002202:	74a2                	ld	s1,40(sp)
    80002204:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002206:	0000e517          	auipc	a0,0xe
    8000220a:	49a50513          	addi	a0,a0,1178 # 800106a0 <tickslock>
    8000220e:	1bb030ef          	jal	80005bc8 <release>
  return 0;
    80002212:	4501                	li	a0,0
}
    80002214:	70e2                	ld	ra,56(sp)
    80002216:	7442                	ld	s0,48(sp)
    80002218:	7902                	ld	s2,32(sp)
    8000221a:	6121                	addi	sp,sp,64
    8000221c:	8082                	ret
    n = 0;
    8000221e:	fc042623          	sw	zero,-52(s0)
    80002222:	bf49                	j	800021b4 <sys_sleep+0x1c>
      release(&tickslock);
    80002224:	0000e517          	auipc	a0,0xe
    80002228:	47c50513          	addi	a0,a0,1148 # 800106a0 <tickslock>
    8000222c:	19d030ef          	jal	80005bc8 <release>
      return -1;
    80002230:	557d                	li	a0,-1
    80002232:	74a2                	ld	s1,40(sp)
    80002234:	69e2                	ld	s3,24(sp)
    80002236:	bff9                	j	80002214 <sys_sleep+0x7c>

0000000080002238 <sys_kill>:

uint64
sys_kill(void)
{
    80002238:	1101                	addi	sp,sp,-32
    8000223a:	ec06                	sd	ra,24(sp)
    8000223c:	e822                	sd	s0,16(sp)
    8000223e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002240:	fec40593          	addi	a1,s0,-20
    80002244:	4501                	li	a0,0
    80002246:	a3dff0ef          	jal	80001c82 <argint>
  return kill(pid);
    8000224a:	fec42503          	lw	a0,-20(s0)
    8000224e:	a90ff0ef          	jal	800014de <kill>
}
    80002252:	60e2                	ld	ra,24(sp)
    80002254:	6442                	ld	s0,16(sp)
    80002256:	6105                	addi	sp,sp,32
    80002258:	8082                	ret

000000008000225a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000225a:	1101                	addi	sp,sp,-32
    8000225c:	ec06                	sd	ra,24(sp)
    8000225e:	e822                	sd	s0,16(sp)
    80002260:	e426                	sd	s1,8(sp)
    80002262:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002264:	0000e517          	auipc	a0,0xe
    80002268:	43c50513          	addi	a0,a0,1084 # 800106a0 <tickslock>
    8000226c:	0c5030ef          	jal	80005b30 <acquire>
  xticks = ticks;
    80002270:	00008497          	auipc	s1,0x8
    80002274:	3c84a483          	lw	s1,968(s1) # 8000a638 <ticks>
  release(&tickslock);
    80002278:	0000e517          	auipc	a0,0xe
    8000227c:	42850513          	addi	a0,a0,1064 # 800106a0 <tickslock>
    80002280:	149030ef          	jal	80005bc8 <release>
  return xticks;
}
    80002284:	02049513          	slli	a0,s1,0x20
    80002288:	9101                	srli	a0,a0,0x20
    8000228a:	60e2                	ld	ra,24(sp)
    8000228c:	6442                	ld	s0,16(sp)
    8000228e:	64a2                	ld	s1,8(sp)
    80002290:	6105                	addi	sp,sp,32
    80002292:	8082                	ret

0000000080002294 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002294:	7179                	addi	sp,sp,-48
    80002296:	f406                	sd	ra,40(sp)
    80002298:	f022                	sd	s0,32(sp)
    8000229a:	ec26                	sd	s1,24(sp)
    8000229c:	e84a                	sd	s2,16(sp)
    8000229e:	e44e                	sd	s3,8(sp)
    800022a0:	e052                	sd	s4,0(sp)
    800022a2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800022a4:	00005597          	auipc	a1,0x5
    800022a8:	2a458593          	addi	a1,a1,676 # 80007548 <etext+0x548>
    800022ac:	0000e517          	auipc	a0,0xe
    800022b0:	60c50513          	addi	a0,a0,1548 # 800108b8 <bcache>
    800022b4:	7fc030ef          	jal	80005ab0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800022b8:	00016797          	auipc	a5,0x16
    800022bc:	60078793          	addi	a5,a5,1536 # 800188b8 <bcache+0x8000>
    800022c0:	00017717          	auipc	a4,0x17
    800022c4:	86070713          	addi	a4,a4,-1952 # 80018b20 <bcache+0x8268>
    800022c8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800022cc:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022d0:	0000e497          	auipc	s1,0xe
    800022d4:	60048493          	addi	s1,s1,1536 # 800108d0 <bcache+0x18>
    b->next = bcache.head.next;
    800022d8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800022da:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800022dc:	00005a17          	auipc	s4,0x5
    800022e0:	274a0a13          	addi	s4,s4,628 # 80007550 <etext+0x550>
    b->next = bcache.head.next;
    800022e4:	2b893783          	ld	a5,696(s2)
    800022e8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800022ea:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800022ee:	85d2                	mv	a1,s4
    800022f0:	01048513          	addi	a0,s1,16
    800022f4:	248010ef          	jal	8000353c <initsleeplock>
    bcache.head.next->prev = b;
    800022f8:	2b893783          	ld	a5,696(s2)
    800022fc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022fe:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002302:	45848493          	addi	s1,s1,1112
    80002306:	fd349fe3          	bne	s1,s3,800022e4 <binit+0x50>
  }
}
    8000230a:	70a2                	ld	ra,40(sp)
    8000230c:	7402                	ld	s0,32(sp)
    8000230e:	64e2                	ld	s1,24(sp)
    80002310:	6942                	ld	s2,16(sp)
    80002312:	69a2                	ld	s3,8(sp)
    80002314:	6a02                	ld	s4,0(sp)
    80002316:	6145                	addi	sp,sp,48
    80002318:	8082                	ret

000000008000231a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000231a:	7179                	addi	sp,sp,-48
    8000231c:	f406                	sd	ra,40(sp)
    8000231e:	f022                	sd	s0,32(sp)
    80002320:	ec26                	sd	s1,24(sp)
    80002322:	e84a                	sd	s2,16(sp)
    80002324:	e44e                	sd	s3,8(sp)
    80002326:	1800                	addi	s0,sp,48
    80002328:	892a                	mv	s2,a0
    8000232a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000232c:	0000e517          	auipc	a0,0xe
    80002330:	58c50513          	addi	a0,a0,1420 # 800108b8 <bcache>
    80002334:	7fc030ef          	jal	80005b30 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002338:	00017497          	auipc	s1,0x17
    8000233c:	8384b483          	ld	s1,-1992(s1) # 80018b70 <bcache+0x82b8>
    80002340:	00016797          	auipc	a5,0x16
    80002344:	7e078793          	addi	a5,a5,2016 # 80018b20 <bcache+0x8268>
    80002348:	02f48b63          	beq	s1,a5,8000237e <bread+0x64>
    8000234c:	873e                	mv	a4,a5
    8000234e:	a021                	j	80002356 <bread+0x3c>
    80002350:	68a4                	ld	s1,80(s1)
    80002352:	02e48663          	beq	s1,a4,8000237e <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002356:	449c                	lw	a5,8(s1)
    80002358:	ff279ce3          	bne	a5,s2,80002350 <bread+0x36>
    8000235c:	44dc                	lw	a5,12(s1)
    8000235e:	ff3799e3          	bne	a5,s3,80002350 <bread+0x36>
      b->refcnt++;
    80002362:	40bc                	lw	a5,64(s1)
    80002364:	2785                	addiw	a5,a5,1
    80002366:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002368:	0000e517          	auipc	a0,0xe
    8000236c:	55050513          	addi	a0,a0,1360 # 800108b8 <bcache>
    80002370:	059030ef          	jal	80005bc8 <release>
      acquiresleep(&b->lock);
    80002374:	01048513          	addi	a0,s1,16
    80002378:	1fa010ef          	jal	80003572 <acquiresleep>
      return b;
    8000237c:	a889                	j	800023ce <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000237e:	00016497          	auipc	s1,0x16
    80002382:	7ea4b483          	ld	s1,2026(s1) # 80018b68 <bcache+0x82b0>
    80002386:	00016797          	auipc	a5,0x16
    8000238a:	79a78793          	addi	a5,a5,1946 # 80018b20 <bcache+0x8268>
    8000238e:	00f48863          	beq	s1,a5,8000239e <bread+0x84>
    80002392:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002394:	40bc                	lw	a5,64(s1)
    80002396:	cb91                	beqz	a5,800023aa <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002398:	64a4                	ld	s1,72(s1)
    8000239a:	fee49de3          	bne	s1,a4,80002394 <bread+0x7a>
  panic("bget: no buffers");
    8000239e:	00005517          	auipc	a0,0x5
    800023a2:	1ba50513          	addi	a0,a0,442 # 80007558 <etext+0x558>
    800023a6:	45c030ef          	jal	80005802 <panic>
      b->dev = dev;
    800023aa:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800023ae:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800023b2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800023b6:	4785                	li	a5,1
    800023b8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023ba:	0000e517          	auipc	a0,0xe
    800023be:	4fe50513          	addi	a0,a0,1278 # 800108b8 <bcache>
    800023c2:	007030ef          	jal	80005bc8 <release>
      acquiresleep(&b->lock);
    800023c6:	01048513          	addi	a0,s1,16
    800023ca:	1a8010ef          	jal	80003572 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800023ce:	409c                	lw	a5,0(s1)
    800023d0:	cb89                	beqz	a5,800023e2 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800023d2:	8526                	mv	a0,s1
    800023d4:	70a2                	ld	ra,40(sp)
    800023d6:	7402                	ld	s0,32(sp)
    800023d8:	64e2                	ld	s1,24(sp)
    800023da:	6942                	ld	s2,16(sp)
    800023dc:	69a2                	ld	s3,8(sp)
    800023de:	6145                	addi	sp,sp,48
    800023e0:	8082                	ret
    virtio_disk_rw(b, 0);
    800023e2:	4581                	li	a1,0
    800023e4:	8526                	mv	a0,s1
    800023e6:	1eb020ef          	jal	80004dd0 <virtio_disk_rw>
    b->valid = 1;
    800023ea:	4785                	li	a5,1
    800023ec:	c09c                	sw	a5,0(s1)
  return b;
    800023ee:	b7d5                	j	800023d2 <bread+0xb8>

00000000800023f0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023f0:	1101                	addi	sp,sp,-32
    800023f2:	ec06                	sd	ra,24(sp)
    800023f4:	e822                	sd	s0,16(sp)
    800023f6:	e426                	sd	s1,8(sp)
    800023f8:	1000                	addi	s0,sp,32
    800023fa:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023fc:	0541                	addi	a0,a0,16
    800023fe:	1f2010ef          	jal	800035f0 <holdingsleep>
    80002402:	c911                	beqz	a0,80002416 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002404:	4585                	li	a1,1
    80002406:	8526                	mv	a0,s1
    80002408:	1c9020ef          	jal	80004dd0 <virtio_disk_rw>
}
    8000240c:	60e2                	ld	ra,24(sp)
    8000240e:	6442                	ld	s0,16(sp)
    80002410:	64a2                	ld	s1,8(sp)
    80002412:	6105                	addi	sp,sp,32
    80002414:	8082                	ret
    panic("bwrite");
    80002416:	00005517          	auipc	a0,0x5
    8000241a:	15a50513          	addi	a0,a0,346 # 80007570 <etext+0x570>
    8000241e:	3e4030ef          	jal	80005802 <panic>

0000000080002422 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002422:	1101                	addi	sp,sp,-32
    80002424:	ec06                	sd	ra,24(sp)
    80002426:	e822                	sd	s0,16(sp)
    80002428:	e426                	sd	s1,8(sp)
    8000242a:	e04a                	sd	s2,0(sp)
    8000242c:	1000                	addi	s0,sp,32
    8000242e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002430:	01050913          	addi	s2,a0,16
    80002434:	854a                	mv	a0,s2
    80002436:	1ba010ef          	jal	800035f0 <holdingsleep>
    8000243a:	c135                	beqz	a0,8000249e <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000243c:	854a                	mv	a0,s2
    8000243e:	17a010ef          	jal	800035b8 <releasesleep>

  acquire(&bcache.lock);
    80002442:	0000e517          	auipc	a0,0xe
    80002446:	47650513          	addi	a0,a0,1142 # 800108b8 <bcache>
    8000244a:	6e6030ef          	jal	80005b30 <acquire>
  b->refcnt--;
    8000244e:	40bc                	lw	a5,64(s1)
    80002450:	37fd                	addiw	a5,a5,-1
    80002452:	0007871b          	sext.w	a4,a5
    80002456:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002458:	e71d                	bnez	a4,80002486 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000245a:	68b8                	ld	a4,80(s1)
    8000245c:	64bc                	ld	a5,72(s1)
    8000245e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002460:	68b8                	ld	a4,80(s1)
    80002462:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002464:	00016797          	auipc	a5,0x16
    80002468:	45478793          	addi	a5,a5,1108 # 800188b8 <bcache+0x8000>
    8000246c:	2b87b703          	ld	a4,696(a5)
    80002470:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002472:	00016717          	auipc	a4,0x16
    80002476:	6ae70713          	addi	a4,a4,1710 # 80018b20 <bcache+0x8268>
    8000247a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000247c:	2b87b703          	ld	a4,696(a5)
    80002480:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002482:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002486:	0000e517          	auipc	a0,0xe
    8000248a:	43250513          	addi	a0,a0,1074 # 800108b8 <bcache>
    8000248e:	73a030ef          	jal	80005bc8 <release>
}
    80002492:	60e2                	ld	ra,24(sp)
    80002494:	6442                	ld	s0,16(sp)
    80002496:	64a2                	ld	s1,8(sp)
    80002498:	6902                	ld	s2,0(sp)
    8000249a:	6105                	addi	sp,sp,32
    8000249c:	8082                	ret
    panic("brelse");
    8000249e:	00005517          	auipc	a0,0x5
    800024a2:	0da50513          	addi	a0,a0,218 # 80007578 <etext+0x578>
    800024a6:	35c030ef          	jal	80005802 <panic>

00000000800024aa <bpin>:

void
bpin(struct buf *b) {
    800024aa:	1101                	addi	sp,sp,-32
    800024ac:	ec06                	sd	ra,24(sp)
    800024ae:	e822                	sd	s0,16(sp)
    800024b0:	e426                	sd	s1,8(sp)
    800024b2:	1000                	addi	s0,sp,32
    800024b4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024b6:	0000e517          	auipc	a0,0xe
    800024ba:	40250513          	addi	a0,a0,1026 # 800108b8 <bcache>
    800024be:	672030ef          	jal	80005b30 <acquire>
  b->refcnt++;
    800024c2:	40bc                	lw	a5,64(s1)
    800024c4:	2785                	addiw	a5,a5,1
    800024c6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024c8:	0000e517          	auipc	a0,0xe
    800024cc:	3f050513          	addi	a0,a0,1008 # 800108b8 <bcache>
    800024d0:	6f8030ef          	jal	80005bc8 <release>
}
    800024d4:	60e2                	ld	ra,24(sp)
    800024d6:	6442                	ld	s0,16(sp)
    800024d8:	64a2                	ld	s1,8(sp)
    800024da:	6105                	addi	sp,sp,32
    800024dc:	8082                	ret

00000000800024de <bunpin>:

void
bunpin(struct buf *b) {
    800024de:	1101                	addi	sp,sp,-32
    800024e0:	ec06                	sd	ra,24(sp)
    800024e2:	e822                	sd	s0,16(sp)
    800024e4:	e426                	sd	s1,8(sp)
    800024e6:	1000                	addi	s0,sp,32
    800024e8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024ea:	0000e517          	auipc	a0,0xe
    800024ee:	3ce50513          	addi	a0,a0,974 # 800108b8 <bcache>
    800024f2:	63e030ef          	jal	80005b30 <acquire>
  b->refcnt--;
    800024f6:	40bc                	lw	a5,64(s1)
    800024f8:	37fd                	addiw	a5,a5,-1
    800024fa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024fc:	0000e517          	auipc	a0,0xe
    80002500:	3bc50513          	addi	a0,a0,956 # 800108b8 <bcache>
    80002504:	6c4030ef          	jal	80005bc8 <release>
}
    80002508:	60e2                	ld	ra,24(sp)
    8000250a:	6442                	ld	s0,16(sp)
    8000250c:	64a2                	ld	s1,8(sp)
    8000250e:	6105                	addi	sp,sp,32
    80002510:	8082                	ret

0000000080002512 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002512:	1101                	addi	sp,sp,-32
    80002514:	ec06                	sd	ra,24(sp)
    80002516:	e822                	sd	s0,16(sp)
    80002518:	e426                	sd	s1,8(sp)
    8000251a:	e04a                	sd	s2,0(sp)
    8000251c:	1000                	addi	s0,sp,32
    8000251e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002520:	00d5d59b          	srliw	a1,a1,0xd
    80002524:	00017797          	auipc	a5,0x17
    80002528:	a707a783          	lw	a5,-1424(a5) # 80018f94 <sb+0x1c>
    8000252c:	9dbd                	addw	a1,a1,a5
    8000252e:	dedff0ef          	jal	8000231a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002532:	0074f713          	andi	a4,s1,7
    80002536:	4785                	li	a5,1
    80002538:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000253c:	14ce                	slli	s1,s1,0x33
    8000253e:	90d9                	srli	s1,s1,0x36
    80002540:	00950733          	add	a4,a0,s1
    80002544:	05874703          	lbu	a4,88(a4)
    80002548:	00e7f6b3          	and	a3,a5,a4
    8000254c:	c29d                	beqz	a3,80002572 <bfree+0x60>
    8000254e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002550:	94aa                	add	s1,s1,a0
    80002552:	fff7c793          	not	a5,a5
    80002556:	8f7d                	and	a4,a4,a5
    80002558:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000255c:	711000ef          	jal	8000346c <log_write>
  brelse(bp);
    80002560:	854a                	mv	a0,s2
    80002562:	ec1ff0ef          	jal	80002422 <brelse>
}
    80002566:	60e2                	ld	ra,24(sp)
    80002568:	6442                	ld	s0,16(sp)
    8000256a:	64a2                	ld	s1,8(sp)
    8000256c:	6902                	ld	s2,0(sp)
    8000256e:	6105                	addi	sp,sp,32
    80002570:	8082                	ret
    panic("freeing free block");
    80002572:	00005517          	auipc	a0,0x5
    80002576:	00e50513          	addi	a0,a0,14 # 80007580 <etext+0x580>
    8000257a:	288030ef          	jal	80005802 <panic>

000000008000257e <balloc>:
{
    8000257e:	711d                	addi	sp,sp,-96
    80002580:	ec86                	sd	ra,88(sp)
    80002582:	e8a2                	sd	s0,80(sp)
    80002584:	e4a6                	sd	s1,72(sp)
    80002586:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002588:	00017797          	auipc	a5,0x17
    8000258c:	9f47a783          	lw	a5,-1548(a5) # 80018f7c <sb+0x4>
    80002590:	0e078f63          	beqz	a5,8000268e <balloc+0x110>
    80002594:	e0ca                	sd	s2,64(sp)
    80002596:	fc4e                	sd	s3,56(sp)
    80002598:	f852                	sd	s4,48(sp)
    8000259a:	f456                	sd	s5,40(sp)
    8000259c:	f05a                	sd	s6,32(sp)
    8000259e:	ec5e                	sd	s7,24(sp)
    800025a0:	e862                	sd	s8,16(sp)
    800025a2:	e466                	sd	s9,8(sp)
    800025a4:	8baa                	mv	s7,a0
    800025a6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025a8:	00017b17          	auipc	s6,0x17
    800025ac:	9d0b0b13          	addi	s6,s6,-1584 # 80018f78 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025b0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025b2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025b4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025b6:	6c89                	lui	s9,0x2
    800025b8:	a0b5                	j	80002624 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025ba:	97ca                	add	a5,a5,s2
    800025bc:	8e55                	or	a2,a2,a3
    800025be:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800025c2:	854a                	mv	a0,s2
    800025c4:	6a9000ef          	jal	8000346c <log_write>
        brelse(bp);
    800025c8:	854a                	mv	a0,s2
    800025ca:	e59ff0ef          	jal	80002422 <brelse>
  bp = bread(dev, bno);
    800025ce:	85a6                	mv	a1,s1
    800025d0:	855e                	mv	a0,s7
    800025d2:	d49ff0ef          	jal	8000231a <bread>
    800025d6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800025d8:	40000613          	li	a2,1024
    800025dc:	4581                	li	a1,0
    800025de:	05850513          	addi	a0,a0,88
    800025e2:	b53fd0ef          	jal	80000134 <memset>
  log_write(bp);
    800025e6:	854a                	mv	a0,s2
    800025e8:	685000ef          	jal	8000346c <log_write>
  brelse(bp);
    800025ec:	854a                	mv	a0,s2
    800025ee:	e35ff0ef          	jal	80002422 <brelse>
}
    800025f2:	6906                	ld	s2,64(sp)
    800025f4:	79e2                	ld	s3,56(sp)
    800025f6:	7a42                	ld	s4,48(sp)
    800025f8:	7aa2                	ld	s5,40(sp)
    800025fa:	7b02                	ld	s6,32(sp)
    800025fc:	6be2                	ld	s7,24(sp)
    800025fe:	6c42                	ld	s8,16(sp)
    80002600:	6ca2                	ld	s9,8(sp)
}
    80002602:	8526                	mv	a0,s1
    80002604:	60e6                	ld	ra,88(sp)
    80002606:	6446                	ld	s0,80(sp)
    80002608:	64a6                	ld	s1,72(sp)
    8000260a:	6125                	addi	sp,sp,96
    8000260c:	8082                	ret
    brelse(bp);
    8000260e:	854a                	mv	a0,s2
    80002610:	e13ff0ef          	jal	80002422 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002614:	015c87bb          	addw	a5,s9,s5
    80002618:	00078a9b          	sext.w	s5,a5
    8000261c:	004b2703          	lw	a4,4(s6)
    80002620:	04eaff63          	bgeu	s5,a4,8000267e <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002624:	41fad79b          	sraiw	a5,s5,0x1f
    80002628:	0137d79b          	srliw	a5,a5,0x13
    8000262c:	015787bb          	addw	a5,a5,s5
    80002630:	40d7d79b          	sraiw	a5,a5,0xd
    80002634:	01cb2583          	lw	a1,28(s6)
    80002638:	9dbd                	addw	a1,a1,a5
    8000263a:	855e                	mv	a0,s7
    8000263c:	cdfff0ef          	jal	8000231a <bread>
    80002640:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002642:	004b2503          	lw	a0,4(s6)
    80002646:	000a849b          	sext.w	s1,s5
    8000264a:	8762                	mv	a4,s8
    8000264c:	fca4f1e3          	bgeu	s1,a0,8000260e <balloc+0x90>
      m = 1 << (bi % 8);
    80002650:	00777693          	andi	a3,a4,7
    80002654:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002658:	41f7579b          	sraiw	a5,a4,0x1f
    8000265c:	01d7d79b          	srliw	a5,a5,0x1d
    80002660:	9fb9                	addw	a5,a5,a4
    80002662:	4037d79b          	sraiw	a5,a5,0x3
    80002666:	00f90633          	add	a2,s2,a5
    8000266a:	05864603          	lbu	a2,88(a2)
    8000266e:	00c6f5b3          	and	a1,a3,a2
    80002672:	d5a1                	beqz	a1,800025ba <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002674:	2705                	addiw	a4,a4,1
    80002676:	2485                	addiw	s1,s1,1
    80002678:	fd471ae3          	bne	a4,s4,8000264c <balloc+0xce>
    8000267c:	bf49                	j	8000260e <balloc+0x90>
    8000267e:	6906                	ld	s2,64(sp)
    80002680:	79e2                	ld	s3,56(sp)
    80002682:	7a42                	ld	s4,48(sp)
    80002684:	7aa2                	ld	s5,40(sp)
    80002686:	7b02                	ld	s6,32(sp)
    80002688:	6be2                	ld	s7,24(sp)
    8000268a:	6c42                	ld	s8,16(sp)
    8000268c:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000268e:	00005517          	auipc	a0,0x5
    80002692:	f0a50513          	addi	a0,a0,-246 # 80007598 <etext+0x598>
    80002696:	69b020ef          	jal	80005530 <printf>
  return 0;
    8000269a:	4481                	li	s1,0
    8000269c:	b79d                	j	80002602 <balloc+0x84>

000000008000269e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000269e:	7179                	addi	sp,sp,-48
    800026a0:	f406                	sd	ra,40(sp)
    800026a2:	f022                	sd	s0,32(sp)
    800026a4:	ec26                	sd	s1,24(sp)
    800026a6:	e84a                	sd	s2,16(sp)
    800026a8:	e44e                	sd	s3,8(sp)
    800026aa:	1800                	addi	s0,sp,48
    800026ac:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026ae:	47ad                	li	a5,11
    800026b0:	02b7e663          	bltu	a5,a1,800026dc <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800026b4:	02059793          	slli	a5,a1,0x20
    800026b8:	01e7d593          	srli	a1,a5,0x1e
    800026bc:	00b504b3          	add	s1,a0,a1
    800026c0:	0504a903          	lw	s2,80(s1)
    800026c4:	06091a63          	bnez	s2,80002738 <bmap+0x9a>
      addr = balloc(ip->dev);
    800026c8:	4108                	lw	a0,0(a0)
    800026ca:	eb5ff0ef          	jal	8000257e <balloc>
    800026ce:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800026d2:	06090363          	beqz	s2,80002738 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800026d6:	0524a823          	sw	s2,80(s1)
    800026da:	a8b9                	j	80002738 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800026dc:	ff45849b          	addiw	s1,a1,-12
    800026e0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800026e4:	0ff00793          	li	a5,255
    800026e8:	06e7ee63          	bltu	a5,a4,80002764 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800026ec:	08052903          	lw	s2,128(a0)
    800026f0:	00091d63          	bnez	s2,8000270a <bmap+0x6c>
      addr = balloc(ip->dev);
    800026f4:	4108                	lw	a0,0(a0)
    800026f6:	e89ff0ef          	jal	8000257e <balloc>
    800026fa:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800026fe:	02090d63          	beqz	s2,80002738 <bmap+0x9a>
    80002702:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002704:	0929a023          	sw	s2,128(s3)
    80002708:	a011                	j	8000270c <bmap+0x6e>
    8000270a:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000270c:	85ca                	mv	a1,s2
    8000270e:	0009a503          	lw	a0,0(s3)
    80002712:	c09ff0ef          	jal	8000231a <bread>
    80002716:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002718:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000271c:	02049713          	slli	a4,s1,0x20
    80002720:	01e75593          	srli	a1,a4,0x1e
    80002724:	00b784b3          	add	s1,a5,a1
    80002728:	0004a903          	lw	s2,0(s1)
    8000272c:	00090e63          	beqz	s2,80002748 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002730:	8552                	mv	a0,s4
    80002732:	cf1ff0ef          	jal	80002422 <brelse>
    return addr;
    80002736:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002738:	854a                	mv	a0,s2
    8000273a:	70a2                	ld	ra,40(sp)
    8000273c:	7402                	ld	s0,32(sp)
    8000273e:	64e2                	ld	s1,24(sp)
    80002740:	6942                	ld	s2,16(sp)
    80002742:	69a2                	ld	s3,8(sp)
    80002744:	6145                	addi	sp,sp,48
    80002746:	8082                	ret
      addr = balloc(ip->dev);
    80002748:	0009a503          	lw	a0,0(s3)
    8000274c:	e33ff0ef          	jal	8000257e <balloc>
    80002750:	0005091b          	sext.w	s2,a0
      if(addr){
    80002754:	fc090ee3          	beqz	s2,80002730 <bmap+0x92>
        a[bn] = addr;
    80002758:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000275c:	8552                	mv	a0,s4
    8000275e:	50f000ef          	jal	8000346c <log_write>
    80002762:	b7f9                	j	80002730 <bmap+0x92>
    80002764:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002766:	00005517          	auipc	a0,0x5
    8000276a:	e4a50513          	addi	a0,a0,-438 # 800075b0 <etext+0x5b0>
    8000276e:	094030ef          	jal	80005802 <panic>

0000000080002772 <iget>:
{
    80002772:	7179                	addi	sp,sp,-48
    80002774:	f406                	sd	ra,40(sp)
    80002776:	f022                	sd	s0,32(sp)
    80002778:	ec26                	sd	s1,24(sp)
    8000277a:	e84a                	sd	s2,16(sp)
    8000277c:	e44e                	sd	s3,8(sp)
    8000277e:	e052                	sd	s4,0(sp)
    80002780:	1800                	addi	s0,sp,48
    80002782:	89aa                	mv	s3,a0
    80002784:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002786:	00017517          	auipc	a0,0x17
    8000278a:	81250513          	addi	a0,a0,-2030 # 80018f98 <itable>
    8000278e:	3a2030ef          	jal	80005b30 <acquire>
  empty = 0;
    80002792:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002794:	00017497          	auipc	s1,0x17
    80002798:	81c48493          	addi	s1,s1,-2020 # 80018fb0 <itable+0x18>
    8000279c:	00018697          	auipc	a3,0x18
    800027a0:	2a468693          	addi	a3,a3,676 # 8001aa40 <log>
    800027a4:	a039                	j	800027b2 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027a6:	02090963          	beqz	s2,800027d8 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027aa:	08848493          	addi	s1,s1,136
    800027ae:	02d48863          	beq	s1,a3,800027de <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027b2:	449c                	lw	a5,8(s1)
    800027b4:	fef059e3          	blez	a5,800027a6 <iget+0x34>
    800027b8:	4098                	lw	a4,0(s1)
    800027ba:	ff3716e3          	bne	a4,s3,800027a6 <iget+0x34>
    800027be:	40d8                	lw	a4,4(s1)
    800027c0:	ff4713e3          	bne	a4,s4,800027a6 <iget+0x34>
      ip->ref++;
    800027c4:	2785                	addiw	a5,a5,1
    800027c6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800027c8:	00016517          	auipc	a0,0x16
    800027cc:	7d050513          	addi	a0,a0,2000 # 80018f98 <itable>
    800027d0:	3f8030ef          	jal	80005bc8 <release>
      return ip;
    800027d4:	8926                	mv	s2,s1
    800027d6:	a02d                	j	80002800 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027d8:	fbe9                	bnez	a5,800027aa <iget+0x38>
      empty = ip;
    800027da:	8926                	mv	s2,s1
    800027dc:	b7f9                	j	800027aa <iget+0x38>
  if(empty == 0)
    800027de:	02090a63          	beqz	s2,80002812 <iget+0xa0>
  ip->dev = dev;
    800027e2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800027e6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800027ea:	4785                	li	a5,1
    800027ec:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800027f0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800027f4:	00016517          	auipc	a0,0x16
    800027f8:	7a450513          	addi	a0,a0,1956 # 80018f98 <itable>
    800027fc:	3cc030ef          	jal	80005bc8 <release>
}
    80002800:	854a                	mv	a0,s2
    80002802:	70a2                	ld	ra,40(sp)
    80002804:	7402                	ld	s0,32(sp)
    80002806:	64e2                	ld	s1,24(sp)
    80002808:	6942                	ld	s2,16(sp)
    8000280a:	69a2                	ld	s3,8(sp)
    8000280c:	6a02                	ld	s4,0(sp)
    8000280e:	6145                	addi	sp,sp,48
    80002810:	8082                	ret
    panic("iget: no inodes");
    80002812:	00005517          	auipc	a0,0x5
    80002816:	db650513          	addi	a0,a0,-586 # 800075c8 <etext+0x5c8>
    8000281a:	7e9020ef          	jal	80005802 <panic>

000000008000281e <fsinit>:
fsinit(int dev) {
    8000281e:	7179                	addi	sp,sp,-48
    80002820:	f406                	sd	ra,40(sp)
    80002822:	f022                	sd	s0,32(sp)
    80002824:	ec26                	sd	s1,24(sp)
    80002826:	e84a                	sd	s2,16(sp)
    80002828:	e44e                	sd	s3,8(sp)
    8000282a:	1800                	addi	s0,sp,48
    8000282c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000282e:	4585                	li	a1,1
    80002830:	aebff0ef          	jal	8000231a <bread>
    80002834:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002836:	00016997          	auipc	s3,0x16
    8000283a:	74298993          	addi	s3,s3,1858 # 80018f78 <sb>
    8000283e:	02000613          	li	a2,32
    80002842:	05850593          	addi	a1,a0,88
    80002846:	854e                	mv	a0,s3
    80002848:	949fd0ef          	jal	80000190 <memmove>
  brelse(bp);
    8000284c:	8526                	mv	a0,s1
    8000284e:	bd5ff0ef          	jal	80002422 <brelse>
  if(sb.magic != FSMAGIC)
    80002852:	0009a703          	lw	a4,0(s3)
    80002856:	102037b7          	lui	a5,0x10203
    8000285a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000285e:	02f71063          	bne	a4,a5,8000287e <fsinit+0x60>
  initlog(dev, &sb);
    80002862:	00016597          	auipc	a1,0x16
    80002866:	71658593          	addi	a1,a1,1814 # 80018f78 <sb>
    8000286a:	854a                	mv	a0,s2
    8000286c:	1f9000ef          	jal	80003264 <initlog>
}
    80002870:	70a2                	ld	ra,40(sp)
    80002872:	7402                	ld	s0,32(sp)
    80002874:	64e2                	ld	s1,24(sp)
    80002876:	6942                	ld	s2,16(sp)
    80002878:	69a2                	ld	s3,8(sp)
    8000287a:	6145                	addi	sp,sp,48
    8000287c:	8082                	ret
    panic("invalid file system");
    8000287e:	00005517          	auipc	a0,0x5
    80002882:	d5a50513          	addi	a0,a0,-678 # 800075d8 <etext+0x5d8>
    80002886:	77d020ef          	jal	80005802 <panic>

000000008000288a <iinit>:
{
    8000288a:	7179                	addi	sp,sp,-48
    8000288c:	f406                	sd	ra,40(sp)
    8000288e:	f022                	sd	s0,32(sp)
    80002890:	ec26                	sd	s1,24(sp)
    80002892:	e84a                	sd	s2,16(sp)
    80002894:	e44e                	sd	s3,8(sp)
    80002896:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002898:	00005597          	auipc	a1,0x5
    8000289c:	d5858593          	addi	a1,a1,-680 # 800075f0 <etext+0x5f0>
    800028a0:	00016517          	auipc	a0,0x16
    800028a4:	6f850513          	addi	a0,a0,1784 # 80018f98 <itable>
    800028a8:	208030ef          	jal	80005ab0 <initlock>
  for(i = 0; i < NINODE; i++) {
    800028ac:	00016497          	auipc	s1,0x16
    800028b0:	71448493          	addi	s1,s1,1812 # 80018fc0 <itable+0x28>
    800028b4:	00018997          	auipc	s3,0x18
    800028b8:	19c98993          	addi	s3,s3,412 # 8001aa50 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800028bc:	00005917          	auipc	s2,0x5
    800028c0:	d3c90913          	addi	s2,s2,-708 # 800075f8 <etext+0x5f8>
    800028c4:	85ca                	mv	a1,s2
    800028c6:	8526                	mv	a0,s1
    800028c8:	475000ef          	jal	8000353c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800028cc:	08848493          	addi	s1,s1,136
    800028d0:	ff349ae3          	bne	s1,s3,800028c4 <iinit+0x3a>
}
    800028d4:	70a2                	ld	ra,40(sp)
    800028d6:	7402                	ld	s0,32(sp)
    800028d8:	64e2                	ld	s1,24(sp)
    800028da:	6942                	ld	s2,16(sp)
    800028dc:	69a2                	ld	s3,8(sp)
    800028de:	6145                	addi	sp,sp,48
    800028e0:	8082                	ret

00000000800028e2 <ialloc>:
{
    800028e2:	7139                	addi	sp,sp,-64
    800028e4:	fc06                	sd	ra,56(sp)
    800028e6:	f822                	sd	s0,48(sp)
    800028e8:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800028ea:	00016717          	auipc	a4,0x16
    800028ee:	69a72703          	lw	a4,1690(a4) # 80018f84 <sb+0xc>
    800028f2:	4785                	li	a5,1
    800028f4:	06e7f063          	bgeu	a5,a4,80002954 <ialloc+0x72>
    800028f8:	f426                	sd	s1,40(sp)
    800028fa:	f04a                	sd	s2,32(sp)
    800028fc:	ec4e                	sd	s3,24(sp)
    800028fe:	e852                	sd	s4,16(sp)
    80002900:	e456                	sd	s5,8(sp)
    80002902:	e05a                	sd	s6,0(sp)
    80002904:	8aaa                	mv	s5,a0
    80002906:	8b2e                	mv	s6,a1
    80002908:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000290a:	00016a17          	auipc	s4,0x16
    8000290e:	66ea0a13          	addi	s4,s4,1646 # 80018f78 <sb>
    80002912:	00495593          	srli	a1,s2,0x4
    80002916:	018a2783          	lw	a5,24(s4)
    8000291a:	9dbd                	addw	a1,a1,a5
    8000291c:	8556                	mv	a0,s5
    8000291e:	9fdff0ef          	jal	8000231a <bread>
    80002922:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002924:	05850993          	addi	s3,a0,88
    80002928:	00f97793          	andi	a5,s2,15
    8000292c:	079a                	slli	a5,a5,0x6
    8000292e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002930:	00099783          	lh	a5,0(s3)
    80002934:	cb9d                	beqz	a5,8000296a <ialloc+0x88>
    brelse(bp);
    80002936:	aedff0ef          	jal	80002422 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000293a:	0905                	addi	s2,s2,1
    8000293c:	00ca2703          	lw	a4,12(s4)
    80002940:	0009079b          	sext.w	a5,s2
    80002944:	fce7e7e3          	bltu	a5,a4,80002912 <ialloc+0x30>
    80002948:	74a2                	ld	s1,40(sp)
    8000294a:	7902                	ld	s2,32(sp)
    8000294c:	69e2                	ld	s3,24(sp)
    8000294e:	6a42                	ld	s4,16(sp)
    80002950:	6aa2                	ld	s5,8(sp)
    80002952:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002954:	00005517          	auipc	a0,0x5
    80002958:	cac50513          	addi	a0,a0,-852 # 80007600 <etext+0x600>
    8000295c:	3d5020ef          	jal	80005530 <printf>
  return 0;
    80002960:	4501                	li	a0,0
}
    80002962:	70e2                	ld	ra,56(sp)
    80002964:	7442                	ld	s0,48(sp)
    80002966:	6121                	addi	sp,sp,64
    80002968:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000296a:	04000613          	li	a2,64
    8000296e:	4581                	li	a1,0
    80002970:	854e                	mv	a0,s3
    80002972:	fc2fd0ef          	jal	80000134 <memset>
      dip->type = type;
    80002976:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000297a:	8526                	mv	a0,s1
    8000297c:	2f1000ef          	jal	8000346c <log_write>
      brelse(bp);
    80002980:	8526                	mv	a0,s1
    80002982:	aa1ff0ef          	jal	80002422 <brelse>
      return iget(dev, inum);
    80002986:	0009059b          	sext.w	a1,s2
    8000298a:	8556                	mv	a0,s5
    8000298c:	de7ff0ef          	jal	80002772 <iget>
    80002990:	74a2                	ld	s1,40(sp)
    80002992:	7902                	ld	s2,32(sp)
    80002994:	69e2                	ld	s3,24(sp)
    80002996:	6a42                	ld	s4,16(sp)
    80002998:	6aa2                	ld	s5,8(sp)
    8000299a:	6b02                	ld	s6,0(sp)
    8000299c:	b7d9                	j	80002962 <ialloc+0x80>

000000008000299e <iupdate>:
{
    8000299e:	1101                	addi	sp,sp,-32
    800029a0:	ec06                	sd	ra,24(sp)
    800029a2:	e822                	sd	s0,16(sp)
    800029a4:	e426                	sd	s1,8(sp)
    800029a6:	e04a                	sd	s2,0(sp)
    800029a8:	1000                	addi	s0,sp,32
    800029aa:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800029ac:	415c                	lw	a5,4(a0)
    800029ae:	0047d79b          	srliw	a5,a5,0x4
    800029b2:	00016597          	auipc	a1,0x16
    800029b6:	5de5a583          	lw	a1,1502(a1) # 80018f90 <sb+0x18>
    800029ba:	9dbd                	addw	a1,a1,a5
    800029bc:	4108                	lw	a0,0(a0)
    800029be:	95dff0ef          	jal	8000231a <bread>
    800029c2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800029c4:	05850793          	addi	a5,a0,88
    800029c8:	40d8                	lw	a4,4(s1)
    800029ca:	8b3d                	andi	a4,a4,15
    800029cc:	071a                	slli	a4,a4,0x6
    800029ce:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800029d0:	04449703          	lh	a4,68(s1)
    800029d4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800029d8:	04649703          	lh	a4,70(s1)
    800029dc:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800029e0:	04849703          	lh	a4,72(s1)
    800029e4:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800029e8:	04a49703          	lh	a4,74(s1)
    800029ec:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800029f0:	44f8                	lw	a4,76(s1)
    800029f2:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800029f4:	03400613          	li	a2,52
    800029f8:	05048593          	addi	a1,s1,80
    800029fc:	00c78513          	addi	a0,a5,12
    80002a00:	f90fd0ef          	jal	80000190 <memmove>
  log_write(bp);
    80002a04:	854a                	mv	a0,s2
    80002a06:	267000ef          	jal	8000346c <log_write>
  brelse(bp);
    80002a0a:	854a                	mv	a0,s2
    80002a0c:	a17ff0ef          	jal	80002422 <brelse>
}
    80002a10:	60e2                	ld	ra,24(sp)
    80002a12:	6442                	ld	s0,16(sp)
    80002a14:	64a2                	ld	s1,8(sp)
    80002a16:	6902                	ld	s2,0(sp)
    80002a18:	6105                	addi	sp,sp,32
    80002a1a:	8082                	ret

0000000080002a1c <idup>:
{
    80002a1c:	1101                	addi	sp,sp,-32
    80002a1e:	ec06                	sd	ra,24(sp)
    80002a20:	e822                	sd	s0,16(sp)
    80002a22:	e426                	sd	s1,8(sp)
    80002a24:	1000                	addi	s0,sp,32
    80002a26:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002a28:	00016517          	auipc	a0,0x16
    80002a2c:	57050513          	addi	a0,a0,1392 # 80018f98 <itable>
    80002a30:	100030ef          	jal	80005b30 <acquire>
  ip->ref++;
    80002a34:	449c                	lw	a5,8(s1)
    80002a36:	2785                	addiw	a5,a5,1
    80002a38:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002a3a:	00016517          	auipc	a0,0x16
    80002a3e:	55e50513          	addi	a0,a0,1374 # 80018f98 <itable>
    80002a42:	186030ef          	jal	80005bc8 <release>
}
    80002a46:	8526                	mv	a0,s1
    80002a48:	60e2                	ld	ra,24(sp)
    80002a4a:	6442                	ld	s0,16(sp)
    80002a4c:	64a2                	ld	s1,8(sp)
    80002a4e:	6105                	addi	sp,sp,32
    80002a50:	8082                	ret

0000000080002a52 <ilock>:
{
    80002a52:	1101                	addi	sp,sp,-32
    80002a54:	ec06                	sd	ra,24(sp)
    80002a56:	e822                	sd	s0,16(sp)
    80002a58:	e426                	sd	s1,8(sp)
    80002a5a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002a5c:	cd19                	beqz	a0,80002a7a <ilock+0x28>
    80002a5e:	84aa                	mv	s1,a0
    80002a60:	451c                	lw	a5,8(a0)
    80002a62:	00f05c63          	blez	a5,80002a7a <ilock+0x28>
  acquiresleep(&ip->lock);
    80002a66:	0541                	addi	a0,a0,16
    80002a68:	30b000ef          	jal	80003572 <acquiresleep>
  if(ip->valid == 0){
    80002a6c:	40bc                	lw	a5,64(s1)
    80002a6e:	cf89                	beqz	a5,80002a88 <ilock+0x36>
}
    80002a70:	60e2                	ld	ra,24(sp)
    80002a72:	6442                	ld	s0,16(sp)
    80002a74:	64a2                	ld	s1,8(sp)
    80002a76:	6105                	addi	sp,sp,32
    80002a78:	8082                	ret
    80002a7a:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002a7c:	00005517          	auipc	a0,0x5
    80002a80:	b9c50513          	addi	a0,a0,-1124 # 80007618 <etext+0x618>
    80002a84:	57f020ef          	jal	80005802 <panic>
    80002a88:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a8a:	40dc                	lw	a5,4(s1)
    80002a8c:	0047d79b          	srliw	a5,a5,0x4
    80002a90:	00016597          	auipc	a1,0x16
    80002a94:	5005a583          	lw	a1,1280(a1) # 80018f90 <sb+0x18>
    80002a98:	9dbd                	addw	a1,a1,a5
    80002a9a:	4088                	lw	a0,0(s1)
    80002a9c:	87fff0ef          	jal	8000231a <bread>
    80002aa0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002aa2:	05850593          	addi	a1,a0,88
    80002aa6:	40dc                	lw	a5,4(s1)
    80002aa8:	8bbd                	andi	a5,a5,15
    80002aaa:	079a                	slli	a5,a5,0x6
    80002aac:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002aae:	00059783          	lh	a5,0(a1)
    80002ab2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002ab6:	00259783          	lh	a5,2(a1)
    80002aba:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002abe:	00459783          	lh	a5,4(a1)
    80002ac2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ac6:	00659783          	lh	a5,6(a1)
    80002aca:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002ace:	459c                	lw	a5,8(a1)
    80002ad0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002ad2:	03400613          	li	a2,52
    80002ad6:	05b1                	addi	a1,a1,12
    80002ad8:	05048513          	addi	a0,s1,80
    80002adc:	eb4fd0ef          	jal	80000190 <memmove>
    brelse(bp);
    80002ae0:	854a                	mv	a0,s2
    80002ae2:	941ff0ef          	jal	80002422 <brelse>
    ip->valid = 1;
    80002ae6:	4785                	li	a5,1
    80002ae8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002aea:	04449783          	lh	a5,68(s1)
    80002aee:	c399                	beqz	a5,80002af4 <ilock+0xa2>
    80002af0:	6902                	ld	s2,0(sp)
    80002af2:	bfbd                	j	80002a70 <ilock+0x1e>
      panic("ilock: no type");
    80002af4:	00005517          	auipc	a0,0x5
    80002af8:	b2c50513          	addi	a0,a0,-1236 # 80007620 <etext+0x620>
    80002afc:	507020ef          	jal	80005802 <panic>

0000000080002b00 <iunlock>:
{
    80002b00:	1101                	addi	sp,sp,-32
    80002b02:	ec06                	sd	ra,24(sp)
    80002b04:	e822                	sd	s0,16(sp)
    80002b06:	e426                	sd	s1,8(sp)
    80002b08:	e04a                	sd	s2,0(sp)
    80002b0a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002b0c:	c505                	beqz	a0,80002b34 <iunlock+0x34>
    80002b0e:	84aa                	mv	s1,a0
    80002b10:	01050913          	addi	s2,a0,16
    80002b14:	854a                	mv	a0,s2
    80002b16:	2db000ef          	jal	800035f0 <holdingsleep>
    80002b1a:	cd09                	beqz	a0,80002b34 <iunlock+0x34>
    80002b1c:	449c                	lw	a5,8(s1)
    80002b1e:	00f05b63          	blez	a5,80002b34 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002b22:	854a                	mv	a0,s2
    80002b24:	295000ef          	jal	800035b8 <releasesleep>
}
    80002b28:	60e2                	ld	ra,24(sp)
    80002b2a:	6442                	ld	s0,16(sp)
    80002b2c:	64a2                	ld	s1,8(sp)
    80002b2e:	6902                	ld	s2,0(sp)
    80002b30:	6105                	addi	sp,sp,32
    80002b32:	8082                	ret
    panic("iunlock");
    80002b34:	00005517          	auipc	a0,0x5
    80002b38:	afc50513          	addi	a0,a0,-1284 # 80007630 <etext+0x630>
    80002b3c:	4c7020ef          	jal	80005802 <panic>

0000000080002b40 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002b40:	7179                	addi	sp,sp,-48
    80002b42:	f406                	sd	ra,40(sp)
    80002b44:	f022                	sd	s0,32(sp)
    80002b46:	ec26                	sd	s1,24(sp)
    80002b48:	e84a                	sd	s2,16(sp)
    80002b4a:	e44e                	sd	s3,8(sp)
    80002b4c:	1800                	addi	s0,sp,48
    80002b4e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002b50:	05050493          	addi	s1,a0,80
    80002b54:	08050913          	addi	s2,a0,128
    80002b58:	a021                	j	80002b60 <itrunc+0x20>
    80002b5a:	0491                	addi	s1,s1,4
    80002b5c:	01248b63          	beq	s1,s2,80002b72 <itrunc+0x32>
    if(ip->addrs[i]){
    80002b60:	408c                	lw	a1,0(s1)
    80002b62:	dde5                	beqz	a1,80002b5a <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002b64:	0009a503          	lw	a0,0(s3)
    80002b68:	9abff0ef          	jal	80002512 <bfree>
      ip->addrs[i] = 0;
    80002b6c:	0004a023          	sw	zero,0(s1)
    80002b70:	b7ed                	j	80002b5a <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002b72:	0809a583          	lw	a1,128(s3)
    80002b76:	ed89                	bnez	a1,80002b90 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002b78:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002b7c:	854e                	mv	a0,s3
    80002b7e:	e21ff0ef          	jal	8000299e <iupdate>
}
    80002b82:	70a2                	ld	ra,40(sp)
    80002b84:	7402                	ld	s0,32(sp)
    80002b86:	64e2                	ld	s1,24(sp)
    80002b88:	6942                	ld	s2,16(sp)
    80002b8a:	69a2                	ld	s3,8(sp)
    80002b8c:	6145                	addi	sp,sp,48
    80002b8e:	8082                	ret
    80002b90:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002b92:	0009a503          	lw	a0,0(s3)
    80002b96:	f84ff0ef          	jal	8000231a <bread>
    80002b9a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002b9c:	05850493          	addi	s1,a0,88
    80002ba0:	45850913          	addi	s2,a0,1112
    80002ba4:	a021                	j	80002bac <itrunc+0x6c>
    80002ba6:	0491                	addi	s1,s1,4
    80002ba8:	01248963          	beq	s1,s2,80002bba <itrunc+0x7a>
      if(a[j])
    80002bac:	408c                	lw	a1,0(s1)
    80002bae:	dde5                	beqz	a1,80002ba6 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002bb0:	0009a503          	lw	a0,0(s3)
    80002bb4:	95fff0ef          	jal	80002512 <bfree>
    80002bb8:	b7fd                	j	80002ba6 <itrunc+0x66>
    brelse(bp);
    80002bba:	8552                	mv	a0,s4
    80002bbc:	867ff0ef          	jal	80002422 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002bc0:	0809a583          	lw	a1,128(s3)
    80002bc4:	0009a503          	lw	a0,0(s3)
    80002bc8:	94bff0ef          	jal	80002512 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002bcc:	0809a023          	sw	zero,128(s3)
    80002bd0:	6a02                	ld	s4,0(sp)
    80002bd2:	b75d                	j	80002b78 <itrunc+0x38>

0000000080002bd4 <iput>:
{
    80002bd4:	1101                	addi	sp,sp,-32
    80002bd6:	ec06                	sd	ra,24(sp)
    80002bd8:	e822                	sd	s0,16(sp)
    80002bda:	e426                	sd	s1,8(sp)
    80002bdc:	1000                	addi	s0,sp,32
    80002bde:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002be0:	00016517          	auipc	a0,0x16
    80002be4:	3b850513          	addi	a0,a0,952 # 80018f98 <itable>
    80002be8:	749020ef          	jal	80005b30 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002bec:	4498                	lw	a4,8(s1)
    80002bee:	4785                	li	a5,1
    80002bf0:	02f70063          	beq	a4,a5,80002c10 <iput+0x3c>
  ip->ref--;
    80002bf4:	449c                	lw	a5,8(s1)
    80002bf6:	37fd                	addiw	a5,a5,-1
    80002bf8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bfa:	00016517          	auipc	a0,0x16
    80002bfe:	39e50513          	addi	a0,a0,926 # 80018f98 <itable>
    80002c02:	7c7020ef          	jal	80005bc8 <release>
}
    80002c06:	60e2                	ld	ra,24(sp)
    80002c08:	6442                	ld	s0,16(sp)
    80002c0a:	64a2                	ld	s1,8(sp)
    80002c0c:	6105                	addi	sp,sp,32
    80002c0e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002c10:	40bc                	lw	a5,64(s1)
    80002c12:	d3ed                	beqz	a5,80002bf4 <iput+0x20>
    80002c14:	04a49783          	lh	a5,74(s1)
    80002c18:	fff1                	bnez	a5,80002bf4 <iput+0x20>
    80002c1a:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002c1c:	01048913          	addi	s2,s1,16
    80002c20:	854a                	mv	a0,s2
    80002c22:	151000ef          	jal	80003572 <acquiresleep>
    release(&itable.lock);
    80002c26:	00016517          	auipc	a0,0x16
    80002c2a:	37250513          	addi	a0,a0,882 # 80018f98 <itable>
    80002c2e:	79b020ef          	jal	80005bc8 <release>
    itrunc(ip);
    80002c32:	8526                	mv	a0,s1
    80002c34:	f0dff0ef          	jal	80002b40 <itrunc>
    ip->type = 0;
    80002c38:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002c3c:	8526                	mv	a0,s1
    80002c3e:	d61ff0ef          	jal	8000299e <iupdate>
    ip->valid = 0;
    80002c42:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002c46:	854a                	mv	a0,s2
    80002c48:	171000ef          	jal	800035b8 <releasesleep>
    acquire(&itable.lock);
    80002c4c:	00016517          	auipc	a0,0x16
    80002c50:	34c50513          	addi	a0,a0,844 # 80018f98 <itable>
    80002c54:	6dd020ef          	jal	80005b30 <acquire>
    80002c58:	6902                	ld	s2,0(sp)
    80002c5a:	bf69                	j	80002bf4 <iput+0x20>

0000000080002c5c <iunlockput>:
{
    80002c5c:	1101                	addi	sp,sp,-32
    80002c5e:	ec06                	sd	ra,24(sp)
    80002c60:	e822                	sd	s0,16(sp)
    80002c62:	e426                	sd	s1,8(sp)
    80002c64:	1000                	addi	s0,sp,32
    80002c66:	84aa                	mv	s1,a0
  iunlock(ip);
    80002c68:	e99ff0ef          	jal	80002b00 <iunlock>
  iput(ip);
    80002c6c:	8526                	mv	a0,s1
    80002c6e:	f67ff0ef          	jal	80002bd4 <iput>
}
    80002c72:	60e2                	ld	ra,24(sp)
    80002c74:	6442                	ld	s0,16(sp)
    80002c76:	64a2                	ld	s1,8(sp)
    80002c78:	6105                	addi	sp,sp,32
    80002c7a:	8082                	ret

0000000080002c7c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002c7c:	1141                	addi	sp,sp,-16
    80002c7e:	e422                	sd	s0,8(sp)
    80002c80:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002c82:	411c                	lw	a5,0(a0)
    80002c84:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002c86:	415c                	lw	a5,4(a0)
    80002c88:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002c8a:	04451783          	lh	a5,68(a0)
    80002c8e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002c92:	04a51783          	lh	a5,74(a0)
    80002c96:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002c9a:	04c56783          	lwu	a5,76(a0)
    80002c9e:	e99c                	sd	a5,16(a1)
}
    80002ca0:	6422                	ld	s0,8(sp)
    80002ca2:	0141                	addi	sp,sp,16
    80002ca4:	8082                	ret

0000000080002ca6 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ca6:	457c                	lw	a5,76(a0)
    80002ca8:	0ed7eb63          	bltu	a5,a3,80002d9e <readi+0xf8>
{
    80002cac:	7159                	addi	sp,sp,-112
    80002cae:	f486                	sd	ra,104(sp)
    80002cb0:	f0a2                	sd	s0,96(sp)
    80002cb2:	eca6                	sd	s1,88(sp)
    80002cb4:	e0d2                	sd	s4,64(sp)
    80002cb6:	fc56                	sd	s5,56(sp)
    80002cb8:	f85a                	sd	s6,48(sp)
    80002cba:	f45e                	sd	s7,40(sp)
    80002cbc:	1880                	addi	s0,sp,112
    80002cbe:	8b2a                	mv	s6,a0
    80002cc0:	8bae                	mv	s7,a1
    80002cc2:	8a32                	mv	s4,a2
    80002cc4:	84b6                	mv	s1,a3
    80002cc6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002cc8:	9f35                	addw	a4,a4,a3
    return 0;
    80002cca:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ccc:	0cd76063          	bltu	a4,a3,80002d8c <readi+0xe6>
    80002cd0:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002cd2:	00e7f463          	bgeu	a5,a4,80002cda <readi+0x34>
    n = ip->size - off;
    80002cd6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002cda:	080a8f63          	beqz	s5,80002d78 <readi+0xd2>
    80002cde:	e8ca                	sd	s2,80(sp)
    80002ce0:	f062                	sd	s8,32(sp)
    80002ce2:	ec66                	sd	s9,24(sp)
    80002ce4:	e86a                	sd	s10,16(sp)
    80002ce6:	e46e                	sd	s11,8(sp)
    80002ce8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002cea:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002cee:	5c7d                	li	s8,-1
    80002cf0:	a80d                	j	80002d22 <readi+0x7c>
    80002cf2:	020d1d93          	slli	s11,s10,0x20
    80002cf6:	020ddd93          	srli	s11,s11,0x20
    80002cfa:	05890613          	addi	a2,s2,88
    80002cfe:	86ee                	mv	a3,s11
    80002d00:	963a                	add	a2,a2,a4
    80002d02:	85d2                	mv	a1,s4
    80002d04:	855e                	mv	a0,s7
    80002d06:	987fe0ef          	jal	8000168c <either_copyout>
    80002d0a:	05850763          	beq	a0,s8,80002d58 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002d0e:	854a                	mv	a0,s2
    80002d10:	f12ff0ef          	jal	80002422 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d14:	013d09bb          	addw	s3,s10,s3
    80002d18:	009d04bb          	addw	s1,s10,s1
    80002d1c:	9a6e                	add	s4,s4,s11
    80002d1e:	0559f763          	bgeu	s3,s5,80002d6c <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002d22:	00a4d59b          	srliw	a1,s1,0xa
    80002d26:	855a                	mv	a0,s6
    80002d28:	977ff0ef          	jal	8000269e <bmap>
    80002d2c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002d30:	c5b1                	beqz	a1,80002d7c <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002d32:	000b2503          	lw	a0,0(s6)
    80002d36:	de4ff0ef          	jal	8000231a <bread>
    80002d3a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002d3c:	3ff4f713          	andi	a4,s1,1023
    80002d40:	40ec87bb          	subw	a5,s9,a4
    80002d44:	413a86bb          	subw	a3,s5,s3
    80002d48:	8d3e                	mv	s10,a5
    80002d4a:	2781                	sext.w	a5,a5
    80002d4c:	0006861b          	sext.w	a2,a3
    80002d50:	faf671e3          	bgeu	a2,a5,80002cf2 <readi+0x4c>
    80002d54:	8d36                	mv	s10,a3
    80002d56:	bf71                	j	80002cf2 <readi+0x4c>
      brelse(bp);
    80002d58:	854a                	mv	a0,s2
    80002d5a:	ec8ff0ef          	jal	80002422 <brelse>
      tot = -1;
    80002d5e:	59fd                	li	s3,-1
      break;
    80002d60:	6946                	ld	s2,80(sp)
    80002d62:	7c02                	ld	s8,32(sp)
    80002d64:	6ce2                	ld	s9,24(sp)
    80002d66:	6d42                	ld	s10,16(sp)
    80002d68:	6da2                	ld	s11,8(sp)
    80002d6a:	a831                	j	80002d86 <readi+0xe0>
    80002d6c:	6946                	ld	s2,80(sp)
    80002d6e:	7c02                	ld	s8,32(sp)
    80002d70:	6ce2                	ld	s9,24(sp)
    80002d72:	6d42                	ld	s10,16(sp)
    80002d74:	6da2                	ld	s11,8(sp)
    80002d76:	a801                	j	80002d86 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d78:	89d6                	mv	s3,s5
    80002d7a:	a031                	j	80002d86 <readi+0xe0>
    80002d7c:	6946                	ld	s2,80(sp)
    80002d7e:	7c02                	ld	s8,32(sp)
    80002d80:	6ce2                	ld	s9,24(sp)
    80002d82:	6d42                	ld	s10,16(sp)
    80002d84:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002d86:	0009851b          	sext.w	a0,s3
    80002d8a:	69a6                	ld	s3,72(sp)
}
    80002d8c:	70a6                	ld	ra,104(sp)
    80002d8e:	7406                	ld	s0,96(sp)
    80002d90:	64e6                	ld	s1,88(sp)
    80002d92:	6a06                	ld	s4,64(sp)
    80002d94:	7ae2                	ld	s5,56(sp)
    80002d96:	7b42                	ld	s6,48(sp)
    80002d98:	7ba2                	ld	s7,40(sp)
    80002d9a:	6165                	addi	sp,sp,112
    80002d9c:	8082                	ret
    return 0;
    80002d9e:	4501                	li	a0,0
}
    80002da0:	8082                	ret

0000000080002da2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002da2:	457c                	lw	a5,76(a0)
    80002da4:	10d7e063          	bltu	a5,a3,80002ea4 <writei+0x102>
{
    80002da8:	7159                	addi	sp,sp,-112
    80002daa:	f486                	sd	ra,104(sp)
    80002dac:	f0a2                	sd	s0,96(sp)
    80002dae:	e8ca                	sd	s2,80(sp)
    80002db0:	e0d2                	sd	s4,64(sp)
    80002db2:	fc56                	sd	s5,56(sp)
    80002db4:	f85a                	sd	s6,48(sp)
    80002db6:	f45e                	sd	s7,40(sp)
    80002db8:	1880                	addi	s0,sp,112
    80002dba:	8aaa                	mv	s5,a0
    80002dbc:	8bae                	mv	s7,a1
    80002dbe:	8a32                	mv	s4,a2
    80002dc0:	8936                	mv	s2,a3
    80002dc2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002dc4:	00e687bb          	addw	a5,a3,a4
    80002dc8:	0ed7e063          	bltu	a5,a3,80002ea8 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002dcc:	00043737          	lui	a4,0x43
    80002dd0:	0cf76e63          	bltu	a4,a5,80002eac <writei+0x10a>
    80002dd4:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002dd6:	0a0b0f63          	beqz	s6,80002e94 <writei+0xf2>
    80002dda:	eca6                	sd	s1,88(sp)
    80002ddc:	f062                	sd	s8,32(sp)
    80002dde:	ec66                	sd	s9,24(sp)
    80002de0:	e86a                	sd	s10,16(sp)
    80002de2:	e46e                	sd	s11,8(sp)
    80002de4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002de6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002dea:	5c7d                	li	s8,-1
    80002dec:	a825                	j	80002e24 <writei+0x82>
    80002dee:	020d1d93          	slli	s11,s10,0x20
    80002df2:	020ddd93          	srli	s11,s11,0x20
    80002df6:	05848513          	addi	a0,s1,88
    80002dfa:	86ee                	mv	a3,s11
    80002dfc:	8652                	mv	a2,s4
    80002dfe:	85de                	mv	a1,s7
    80002e00:	953a                	add	a0,a0,a4
    80002e02:	8d5fe0ef          	jal	800016d6 <either_copyin>
    80002e06:	05850a63          	beq	a0,s8,80002e5a <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002e0a:	8526                	mv	a0,s1
    80002e0c:	660000ef          	jal	8000346c <log_write>
    brelse(bp);
    80002e10:	8526                	mv	a0,s1
    80002e12:	e10ff0ef          	jal	80002422 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e16:	013d09bb          	addw	s3,s10,s3
    80002e1a:	012d093b          	addw	s2,s10,s2
    80002e1e:	9a6e                	add	s4,s4,s11
    80002e20:	0569f063          	bgeu	s3,s6,80002e60 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002e24:	00a9559b          	srliw	a1,s2,0xa
    80002e28:	8556                	mv	a0,s5
    80002e2a:	875ff0ef          	jal	8000269e <bmap>
    80002e2e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e32:	c59d                	beqz	a1,80002e60 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002e34:	000aa503          	lw	a0,0(s5)
    80002e38:	ce2ff0ef          	jal	8000231a <bread>
    80002e3c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e3e:	3ff97713          	andi	a4,s2,1023
    80002e42:	40ec87bb          	subw	a5,s9,a4
    80002e46:	413b06bb          	subw	a3,s6,s3
    80002e4a:	8d3e                	mv	s10,a5
    80002e4c:	2781                	sext.w	a5,a5
    80002e4e:	0006861b          	sext.w	a2,a3
    80002e52:	f8f67ee3          	bgeu	a2,a5,80002dee <writei+0x4c>
    80002e56:	8d36                	mv	s10,a3
    80002e58:	bf59                	j	80002dee <writei+0x4c>
      brelse(bp);
    80002e5a:	8526                	mv	a0,s1
    80002e5c:	dc6ff0ef          	jal	80002422 <brelse>
  }

  if(off > ip->size)
    80002e60:	04caa783          	lw	a5,76(s5)
    80002e64:	0327fa63          	bgeu	a5,s2,80002e98 <writei+0xf6>
    ip->size = off;
    80002e68:	052aa623          	sw	s2,76(s5)
    80002e6c:	64e6                	ld	s1,88(sp)
    80002e6e:	7c02                	ld	s8,32(sp)
    80002e70:	6ce2                	ld	s9,24(sp)
    80002e72:	6d42                	ld	s10,16(sp)
    80002e74:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002e76:	8556                	mv	a0,s5
    80002e78:	b27ff0ef          	jal	8000299e <iupdate>

  return tot;
    80002e7c:	0009851b          	sext.w	a0,s3
    80002e80:	69a6                	ld	s3,72(sp)
}
    80002e82:	70a6                	ld	ra,104(sp)
    80002e84:	7406                	ld	s0,96(sp)
    80002e86:	6946                	ld	s2,80(sp)
    80002e88:	6a06                	ld	s4,64(sp)
    80002e8a:	7ae2                	ld	s5,56(sp)
    80002e8c:	7b42                	ld	s6,48(sp)
    80002e8e:	7ba2                	ld	s7,40(sp)
    80002e90:	6165                	addi	sp,sp,112
    80002e92:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e94:	89da                	mv	s3,s6
    80002e96:	b7c5                	j	80002e76 <writei+0xd4>
    80002e98:	64e6                	ld	s1,88(sp)
    80002e9a:	7c02                	ld	s8,32(sp)
    80002e9c:	6ce2                	ld	s9,24(sp)
    80002e9e:	6d42                	ld	s10,16(sp)
    80002ea0:	6da2                	ld	s11,8(sp)
    80002ea2:	bfd1                	j	80002e76 <writei+0xd4>
    return -1;
    80002ea4:	557d                	li	a0,-1
}
    80002ea6:	8082                	ret
    return -1;
    80002ea8:	557d                	li	a0,-1
    80002eaa:	bfe1                	j	80002e82 <writei+0xe0>
    return -1;
    80002eac:	557d                	li	a0,-1
    80002eae:	bfd1                	j	80002e82 <writei+0xe0>

0000000080002eb0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002eb0:	1141                	addi	sp,sp,-16
    80002eb2:	e406                	sd	ra,8(sp)
    80002eb4:	e022                	sd	s0,0(sp)
    80002eb6:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002eb8:	4639                	li	a2,14
    80002eba:	b46fd0ef          	jal	80000200 <strncmp>
}
    80002ebe:	60a2                	ld	ra,8(sp)
    80002ec0:	6402                	ld	s0,0(sp)
    80002ec2:	0141                	addi	sp,sp,16
    80002ec4:	8082                	ret

0000000080002ec6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002ec6:	7139                	addi	sp,sp,-64
    80002ec8:	fc06                	sd	ra,56(sp)
    80002eca:	f822                	sd	s0,48(sp)
    80002ecc:	f426                	sd	s1,40(sp)
    80002ece:	f04a                	sd	s2,32(sp)
    80002ed0:	ec4e                	sd	s3,24(sp)
    80002ed2:	e852                	sd	s4,16(sp)
    80002ed4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002ed6:	04451703          	lh	a4,68(a0)
    80002eda:	4785                	li	a5,1
    80002edc:	00f71a63          	bne	a4,a5,80002ef0 <dirlookup+0x2a>
    80002ee0:	892a                	mv	s2,a0
    80002ee2:	89ae                	mv	s3,a1
    80002ee4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ee6:	457c                	lw	a5,76(a0)
    80002ee8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002eea:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002eec:	e39d                	bnez	a5,80002f12 <dirlookup+0x4c>
    80002eee:	a095                	j	80002f52 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002ef0:	00004517          	auipc	a0,0x4
    80002ef4:	74850513          	addi	a0,a0,1864 # 80007638 <etext+0x638>
    80002ef8:	10b020ef          	jal	80005802 <panic>
      panic("dirlookup read");
    80002efc:	00004517          	auipc	a0,0x4
    80002f00:	75450513          	addi	a0,a0,1876 # 80007650 <etext+0x650>
    80002f04:	0ff020ef          	jal	80005802 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f08:	24c1                	addiw	s1,s1,16
    80002f0a:	04c92783          	lw	a5,76(s2)
    80002f0e:	04f4f163          	bgeu	s1,a5,80002f50 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002f12:	4741                	li	a4,16
    80002f14:	86a6                	mv	a3,s1
    80002f16:	fc040613          	addi	a2,s0,-64
    80002f1a:	4581                	li	a1,0
    80002f1c:	854a                	mv	a0,s2
    80002f1e:	d89ff0ef          	jal	80002ca6 <readi>
    80002f22:	47c1                	li	a5,16
    80002f24:	fcf51ce3          	bne	a0,a5,80002efc <dirlookup+0x36>
    if(de.inum == 0)
    80002f28:	fc045783          	lhu	a5,-64(s0)
    80002f2c:	dff1                	beqz	a5,80002f08 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002f2e:	fc240593          	addi	a1,s0,-62
    80002f32:	854e                	mv	a0,s3
    80002f34:	f7dff0ef          	jal	80002eb0 <namecmp>
    80002f38:	f961                	bnez	a0,80002f08 <dirlookup+0x42>
      if(poff)
    80002f3a:	000a0463          	beqz	s4,80002f42 <dirlookup+0x7c>
        *poff = off;
    80002f3e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002f42:	fc045583          	lhu	a1,-64(s0)
    80002f46:	00092503          	lw	a0,0(s2)
    80002f4a:	829ff0ef          	jal	80002772 <iget>
    80002f4e:	a011                	j	80002f52 <dirlookup+0x8c>
  return 0;
    80002f50:	4501                	li	a0,0
}
    80002f52:	70e2                	ld	ra,56(sp)
    80002f54:	7442                	ld	s0,48(sp)
    80002f56:	74a2                	ld	s1,40(sp)
    80002f58:	7902                	ld	s2,32(sp)
    80002f5a:	69e2                	ld	s3,24(sp)
    80002f5c:	6a42                	ld	s4,16(sp)
    80002f5e:	6121                	addi	sp,sp,64
    80002f60:	8082                	ret

0000000080002f62 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002f62:	711d                	addi	sp,sp,-96
    80002f64:	ec86                	sd	ra,88(sp)
    80002f66:	e8a2                	sd	s0,80(sp)
    80002f68:	e4a6                	sd	s1,72(sp)
    80002f6a:	e0ca                	sd	s2,64(sp)
    80002f6c:	fc4e                	sd	s3,56(sp)
    80002f6e:	f852                	sd	s4,48(sp)
    80002f70:	f456                	sd	s5,40(sp)
    80002f72:	f05a                	sd	s6,32(sp)
    80002f74:	ec5e                	sd	s7,24(sp)
    80002f76:	e862                	sd	s8,16(sp)
    80002f78:	e466                	sd	s9,8(sp)
    80002f7a:	1080                	addi	s0,sp,96
    80002f7c:	84aa                	mv	s1,a0
    80002f7e:	8b2e                	mv	s6,a1
    80002f80:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002f82:	00054703          	lbu	a4,0(a0)
    80002f86:	02f00793          	li	a5,47
    80002f8a:	00f70e63          	beq	a4,a5,80002fa6 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002f8e:	dc9fd0ef          	jal	80000d56 <myproc>
    80002f92:	15053503          	ld	a0,336(a0)
    80002f96:	a87ff0ef          	jal	80002a1c <idup>
    80002f9a:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002f9c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002fa0:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002fa2:	4b85                	li	s7,1
    80002fa4:	a871                	j	80003040 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002fa6:	4585                	li	a1,1
    80002fa8:	4505                	li	a0,1
    80002faa:	fc8ff0ef          	jal	80002772 <iget>
    80002fae:	8a2a                	mv	s4,a0
    80002fb0:	b7f5                	j	80002f9c <namex+0x3a>
      iunlockput(ip);
    80002fb2:	8552                	mv	a0,s4
    80002fb4:	ca9ff0ef          	jal	80002c5c <iunlockput>
      return 0;
    80002fb8:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002fba:	8552                	mv	a0,s4
    80002fbc:	60e6                	ld	ra,88(sp)
    80002fbe:	6446                	ld	s0,80(sp)
    80002fc0:	64a6                	ld	s1,72(sp)
    80002fc2:	6906                	ld	s2,64(sp)
    80002fc4:	79e2                	ld	s3,56(sp)
    80002fc6:	7a42                	ld	s4,48(sp)
    80002fc8:	7aa2                	ld	s5,40(sp)
    80002fca:	7b02                	ld	s6,32(sp)
    80002fcc:	6be2                	ld	s7,24(sp)
    80002fce:	6c42                	ld	s8,16(sp)
    80002fd0:	6ca2                	ld	s9,8(sp)
    80002fd2:	6125                	addi	sp,sp,96
    80002fd4:	8082                	ret
      iunlock(ip);
    80002fd6:	8552                	mv	a0,s4
    80002fd8:	b29ff0ef          	jal	80002b00 <iunlock>
      return ip;
    80002fdc:	bff9                	j	80002fba <namex+0x58>
      iunlockput(ip);
    80002fde:	8552                	mv	a0,s4
    80002fe0:	c7dff0ef          	jal	80002c5c <iunlockput>
      return 0;
    80002fe4:	8a4e                	mv	s4,s3
    80002fe6:	bfd1                	j	80002fba <namex+0x58>
  len = path - s;
    80002fe8:	40998633          	sub	a2,s3,s1
    80002fec:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002ff0:	099c5063          	bge	s8,s9,80003070 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002ff4:	4639                	li	a2,14
    80002ff6:	85a6                	mv	a1,s1
    80002ff8:	8556                	mv	a0,s5
    80002ffa:	996fd0ef          	jal	80000190 <memmove>
    80002ffe:	84ce                	mv	s1,s3
  while(*path == '/')
    80003000:	0004c783          	lbu	a5,0(s1)
    80003004:	01279763          	bne	a5,s2,80003012 <namex+0xb0>
    path++;
    80003008:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000300a:	0004c783          	lbu	a5,0(s1)
    8000300e:	ff278de3          	beq	a5,s2,80003008 <namex+0xa6>
    ilock(ip);
    80003012:	8552                	mv	a0,s4
    80003014:	a3fff0ef          	jal	80002a52 <ilock>
    if(ip->type != T_DIR){
    80003018:	044a1783          	lh	a5,68(s4)
    8000301c:	f9779be3          	bne	a5,s7,80002fb2 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003020:	000b0563          	beqz	s6,8000302a <namex+0xc8>
    80003024:	0004c783          	lbu	a5,0(s1)
    80003028:	d7dd                	beqz	a5,80002fd6 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000302a:	4601                	li	a2,0
    8000302c:	85d6                	mv	a1,s5
    8000302e:	8552                	mv	a0,s4
    80003030:	e97ff0ef          	jal	80002ec6 <dirlookup>
    80003034:	89aa                	mv	s3,a0
    80003036:	d545                	beqz	a0,80002fde <namex+0x7c>
    iunlockput(ip);
    80003038:	8552                	mv	a0,s4
    8000303a:	c23ff0ef          	jal	80002c5c <iunlockput>
    ip = next;
    8000303e:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003040:	0004c783          	lbu	a5,0(s1)
    80003044:	01279763          	bne	a5,s2,80003052 <namex+0xf0>
    path++;
    80003048:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000304a:	0004c783          	lbu	a5,0(s1)
    8000304e:	ff278de3          	beq	a5,s2,80003048 <namex+0xe6>
  if(*path == 0)
    80003052:	cb8d                	beqz	a5,80003084 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003054:	0004c783          	lbu	a5,0(s1)
    80003058:	89a6                	mv	s3,s1
  len = path - s;
    8000305a:	4c81                	li	s9,0
    8000305c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000305e:	01278963          	beq	a5,s2,80003070 <namex+0x10e>
    80003062:	d3d9                	beqz	a5,80002fe8 <namex+0x86>
    path++;
    80003064:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003066:	0009c783          	lbu	a5,0(s3)
    8000306a:	ff279ce3          	bne	a5,s2,80003062 <namex+0x100>
    8000306e:	bfad                	j	80002fe8 <namex+0x86>
    memmove(name, s, len);
    80003070:	2601                	sext.w	a2,a2
    80003072:	85a6                	mv	a1,s1
    80003074:	8556                	mv	a0,s5
    80003076:	91afd0ef          	jal	80000190 <memmove>
    name[len] = 0;
    8000307a:	9cd6                	add	s9,s9,s5
    8000307c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003080:	84ce                	mv	s1,s3
    80003082:	bfbd                	j	80003000 <namex+0x9e>
  if(nameiparent){
    80003084:	f20b0be3          	beqz	s6,80002fba <namex+0x58>
    iput(ip);
    80003088:	8552                	mv	a0,s4
    8000308a:	b4bff0ef          	jal	80002bd4 <iput>
    return 0;
    8000308e:	4a01                	li	s4,0
    80003090:	b72d                	j	80002fba <namex+0x58>

0000000080003092 <dirlink>:
{
    80003092:	7139                	addi	sp,sp,-64
    80003094:	fc06                	sd	ra,56(sp)
    80003096:	f822                	sd	s0,48(sp)
    80003098:	f04a                	sd	s2,32(sp)
    8000309a:	ec4e                	sd	s3,24(sp)
    8000309c:	e852                	sd	s4,16(sp)
    8000309e:	0080                	addi	s0,sp,64
    800030a0:	892a                	mv	s2,a0
    800030a2:	8a2e                	mv	s4,a1
    800030a4:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800030a6:	4601                	li	a2,0
    800030a8:	e1fff0ef          	jal	80002ec6 <dirlookup>
    800030ac:	e535                	bnez	a0,80003118 <dirlink+0x86>
    800030ae:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030b0:	04c92483          	lw	s1,76(s2)
    800030b4:	c48d                	beqz	s1,800030de <dirlink+0x4c>
    800030b6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030b8:	4741                	li	a4,16
    800030ba:	86a6                	mv	a3,s1
    800030bc:	fc040613          	addi	a2,s0,-64
    800030c0:	4581                	li	a1,0
    800030c2:	854a                	mv	a0,s2
    800030c4:	be3ff0ef          	jal	80002ca6 <readi>
    800030c8:	47c1                	li	a5,16
    800030ca:	04f51b63          	bne	a0,a5,80003120 <dirlink+0x8e>
    if(de.inum == 0)
    800030ce:	fc045783          	lhu	a5,-64(s0)
    800030d2:	c791                	beqz	a5,800030de <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030d4:	24c1                	addiw	s1,s1,16
    800030d6:	04c92783          	lw	a5,76(s2)
    800030da:	fcf4efe3          	bltu	s1,a5,800030b8 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    800030de:	4639                	li	a2,14
    800030e0:	85d2                	mv	a1,s4
    800030e2:	fc240513          	addi	a0,s0,-62
    800030e6:	950fd0ef          	jal	80000236 <strncpy>
  de.inum = inum;
    800030ea:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030ee:	4741                	li	a4,16
    800030f0:	86a6                	mv	a3,s1
    800030f2:	fc040613          	addi	a2,s0,-64
    800030f6:	4581                	li	a1,0
    800030f8:	854a                	mv	a0,s2
    800030fa:	ca9ff0ef          	jal	80002da2 <writei>
    800030fe:	1541                	addi	a0,a0,-16
    80003100:	00a03533          	snez	a0,a0
    80003104:	40a00533          	neg	a0,a0
    80003108:	74a2                	ld	s1,40(sp)
}
    8000310a:	70e2                	ld	ra,56(sp)
    8000310c:	7442                	ld	s0,48(sp)
    8000310e:	7902                	ld	s2,32(sp)
    80003110:	69e2                	ld	s3,24(sp)
    80003112:	6a42                	ld	s4,16(sp)
    80003114:	6121                	addi	sp,sp,64
    80003116:	8082                	ret
    iput(ip);
    80003118:	abdff0ef          	jal	80002bd4 <iput>
    return -1;
    8000311c:	557d                	li	a0,-1
    8000311e:	b7f5                	j	8000310a <dirlink+0x78>
      panic("dirlink read");
    80003120:	00004517          	auipc	a0,0x4
    80003124:	54050513          	addi	a0,a0,1344 # 80007660 <etext+0x660>
    80003128:	6da020ef          	jal	80005802 <panic>

000000008000312c <namei>:

struct inode*
namei(char *path)
{
    8000312c:	1101                	addi	sp,sp,-32
    8000312e:	ec06                	sd	ra,24(sp)
    80003130:	e822                	sd	s0,16(sp)
    80003132:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003134:	fe040613          	addi	a2,s0,-32
    80003138:	4581                	li	a1,0
    8000313a:	e29ff0ef          	jal	80002f62 <namex>
}
    8000313e:	60e2                	ld	ra,24(sp)
    80003140:	6442                	ld	s0,16(sp)
    80003142:	6105                	addi	sp,sp,32
    80003144:	8082                	ret

0000000080003146 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003146:	1141                	addi	sp,sp,-16
    80003148:	e406                	sd	ra,8(sp)
    8000314a:	e022                	sd	s0,0(sp)
    8000314c:	0800                	addi	s0,sp,16
    8000314e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003150:	4585                	li	a1,1
    80003152:	e11ff0ef          	jal	80002f62 <namex>
}
    80003156:	60a2                	ld	ra,8(sp)
    80003158:	6402                	ld	s0,0(sp)
    8000315a:	0141                	addi	sp,sp,16
    8000315c:	8082                	ret

000000008000315e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000315e:	1101                	addi	sp,sp,-32
    80003160:	ec06                	sd	ra,24(sp)
    80003162:	e822                	sd	s0,16(sp)
    80003164:	e426                	sd	s1,8(sp)
    80003166:	e04a                	sd	s2,0(sp)
    80003168:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000316a:	00018917          	auipc	s2,0x18
    8000316e:	8d690913          	addi	s2,s2,-1834 # 8001aa40 <log>
    80003172:	01892583          	lw	a1,24(s2)
    80003176:	02892503          	lw	a0,40(s2)
    8000317a:	9a0ff0ef          	jal	8000231a <bread>
    8000317e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003180:	02c92603          	lw	a2,44(s2)
    80003184:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003186:	00c05f63          	blez	a2,800031a4 <write_head+0x46>
    8000318a:	00018717          	auipc	a4,0x18
    8000318e:	8e670713          	addi	a4,a4,-1818 # 8001aa70 <log+0x30>
    80003192:	87aa                	mv	a5,a0
    80003194:	060a                	slli	a2,a2,0x2
    80003196:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003198:	4314                	lw	a3,0(a4)
    8000319a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000319c:	0711                	addi	a4,a4,4
    8000319e:	0791                	addi	a5,a5,4
    800031a0:	fec79ce3          	bne	a5,a2,80003198 <write_head+0x3a>
  }
  bwrite(buf);
    800031a4:	8526                	mv	a0,s1
    800031a6:	a4aff0ef          	jal	800023f0 <bwrite>
  brelse(buf);
    800031aa:	8526                	mv	a0,s1
    800031ac:	a76ff0ef          	jal	80002422 <brelse>
}
    800031b0:	60e2                	ld	ra,24(sp)
    800031b2:	6442                	ld	s0,16(sp)
    800031b4:	64a2                	ld	s1,8(sp)
    800031b6:	6902                	ld	s2,0(sp)
    800031b8:	6105                	addi	sp,sp,32
    800031ba:	8082                	ret

00000000800031bc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800031bc:	00018797          	auipc	a5,0x18
    800031c0:	8b07a783          	lw	a5,-1872(a5) # 8001aa6c <log+0x2c>
    800031c4:	08f05f63          	blez	a5,80003262 <install_trans+0xa6>
{
    800031c8:	7139                	addi	sp,sp,-64
    800031ca:	fc06                	sd	ra,56(sp)
    800031cc:	f822                	sd	s0,48(sp)
    800031ce:	f426                	sd	s1,40(sp)
    800031d0:	f04a                	sd	s2,32(sp)
    800031d2:	ec4e                	sd	s3,24(sp)
    800031d4:	e852                	sd	s4,16(sp)
    800031d6:	e456                	sd	s5,8(sp)
    800031d8:	e05a                	sd	s6,0(sp)
    800031da:	0080                	addi	s0,sp,64
    800031dc:	8b2a                	mv	s6,a0
    800031de:	00018a97          	auipc	s5,0x18
    800031e2:	892a8a93          	addi	s5,s5,-1902 # 8001aa70 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800031e6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800031e8:	00018997          	auipc	s3,0x18
    800031ec:	85898993          	addi	s3,s3,-1960 # 8001aa40 <log>
    800031f0:	a829                	j	8000320a <install_trans+0x4e>
    brelse(lbuf);
    800031f2:	854a                	mv	a0,s2
    800031f4:	a2eff0ef          	jal	80002422 <brelse>
    brelse(dbuf);
    800031f8:	8526                	mv	a0,s1
    800031fa:	a28ff0ef          	jal	80002422 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800031fe:	2a05                	addiw	s4,s4,1
    80003200:	0a91                	addi	s5,s5,4
    80003202:	02c9a783          	lw	a5,44(s3)
    80003206:	04fa5463          	bge	s4,a5,8000324e <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000320a:	0189a583          	lw	a1,24(s3)
    8000320e:	014585bb          	addw	a1,a1,s4
    80003212:	2585                	addiw	a1,a1,1
    80003214:	0289a503          	lw	a0,40(s3)
    80003218:	902ff0ef          	jal	8000231a <bread>
    8000321c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000321e:	000aa583          	lw	a1,0(s5)
    80003222:	0289a503          	lw	a0,40(s3)
    80003226:	8f4ff0ef          	jal	8000231a <bread>
    8000322a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000322c:	40000613          	li	a2,1024
    80003230:	05890593          	addi	a1,s2,88
    80003234:	05850513          	addi	a0,a0,88
    80003238:	f59fc0ef          	jal	80000190 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000323c:	8526                	mv	a0,s1
    8000323e:	9b2ff0ef          	jal	800023f0 <bwrite>
    if(recovering == 0)
    80003242:	fa0b18e3          	bnez	s6,800031f2 <install_trans+0x36>
      bunpin(dbuf);
    80003246:	8526                	mv	a0,s1
    80003248:	a96ff0ef          	jal	800024de <bunpin>
    8000324c:	b75d                	j	800031f2 <install_trans+0x36>
}
    8000324e:	70e2                	ld	ra,56(sp)
    80003250:	7442                	ld	s0,48(sp)
    80003252:	74a2                	ld	s1,40(sp)
    80003254:	7902                	ld	s2,32(sp)
    80003256:	69e2                	ld	s3,24(sp)
    80003258:	6a42                	ld	s4,16(sp)
    8000325a:	6aa2                	ld	s5,8(sp)
    8000325c:	6b02                	ld	s6,0(sp)
    8000325e:	6121                	addi	sp,sp,64
    80003260:	8082                	ret
    80003262:	8082                	ret

0000000080003264 <initlog>:
{
    80003264:	7179                	addi	sp,sp,-48
    80003266:	f406                	sd	ra,40(sp)
    80003268:	f022                	sd	s0,32(sp)
    8000326a:	ec26                	sd	s1,24(sp)
    8000326c:	e84a                	sd	s2,16(sp)
    8000326e:	e44e                	sd	s3,8(sp)
    80003270:	1800                	addi	s0,sp,48
    80003272:	892a                	mv	s2,a0
    80003274:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003276:	00017497          	auipc	s1,0x17
    8000327a:	7ca48493          	addi	s1,s1,1994 # 8001aa40 <log>
    8000327e:	00004597          	auipc	a1,0x4
    80003282:	3f258593          	addi	a1,a1,1010 # 80007670 <etext+0x670>
    80003286:	8526                	mv	a0,s1
    80003288:	029020ef          	jal	80005ab0 <initlock>
  log.start = sb->logstart;
    8000328c:	0149a583          	lw	a1,20(s3)
    80003290:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003292:	0109a783          	lw	a5,16(s3)
    80003296:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003298:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000329c:	854a                	mv	a0,s2
    8000329e:	87cff0ef          	jal	8000231a <bread>
  log.lh.n = lh->n;
    800032a2:	4d30                	lw	a2,88(a0)
    800032a4:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800032a6:	00c05f63          	blez	a2,800032c4 <initlog+0x60>
    800032aa:	87aa                	mv	a5,a0
    800032ac:	00017717          	auipc	a4,0x17
    800032b0:	7c470713          	addi	a4,a4,1988 # 8001aa70 <log+0x30>
    800032b4:	060a                	slli	a2,a2,0x2
    800032b6:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800032b8:	4ff4                	lw	a3,92(a5)
    800032ba:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800032bc:	0791                	addi	a5,a5,4
    800032be:	0711                	addi	a4,a4,4
    800032c0:	fec79ce3          	bne	a5,a2,800032b8 <initlog+0x54>
  brelse(buf);
    800032c4:	95eff0ef          	jal	80002422 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800032c8:	4505                	li	a0,1
    800032ca:	ef3ff0ef          	jal	800031bc <install_trans>
  log.lh.n = 0;
    800032ce:	00017797          	auipc	a5,0x17
    800032d2:	7807af23          	sw	zero,1950(a5) # 8001aa6c <log+0x2c>
  write_head(); // clear the log
    800032d6:	e89ff0ef          	jal	8000315e <write_head>
}
    800032da:	70a2                	ld	ra,40(sp)
    800032dc:	7402                	ld	s0,32(sp)
    800032de:	64e2                	ld	s1,24(sp)
    800032e0:	6942                	ld	s2,16(sp)
    800032e2:	69a2                	ld	s3,8(sp)
    800032e4:	6145                	addi	sp,sp,48
    800032e6:	8082                	ret

00000000800032e8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800032e8:	1101                	addi	sp,sp,-32
    800032ea:	ec06                	sd	ra,24(sp)
    800032ec:	e822                	sd	s0,16(sp)
    800032ee:	e426                	sd	s1,8(sp)
    800032f0:	e04a                	sd	s2,0(sp)
    800032f2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800032f4:	00017517          	auipc	a0,0x17
    800032f8:	74c50513          	addi	a0,a0,1868 # 8001aa40 <log>
    800032fc:	035020ef          	jal	80005b30 <acquire>
  while(1){
    if(log.committing){
    80003300:	00017497          	auipc	s1,0x17
    80003304:	74048493          	addi	s1,s1,1856 # 8001aa40 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003308:	4979                	li	s2,30
    8000330a:	a029                	j	80003314 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000330c:	85a6                	mv	a1,s1
    8000330e:	8526                	mv	a0,s1
    80003310:	820fe0ef          	jal	80001330 <sleep>
    if(log.committing){
    80003314:	50dc                	lw	a5,36(s1)
    80003316:	fbfd                	bnez	a5,8000330c <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003318:	5098                	lw	a4,32(s1)
    8000331a:	2705                	addiw	a4,a4,1
    8000331c:	0027179b          	slliw	a5,a4,0x2
    80003320:	9fb9                	addw	a5,a5,a4
    80003322:	0017979b          	slliw	a5,a5,0x1
    80003326:	54d4                	lw	a3,44(s1)
    80003328:	9fb5                	addw	a5,a5,a3
    8000332a:	00f95763          	bge	s2,a5,80003338 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000332e:	85a6                	mv	a1,s1
    80003330:	8526                	mv	a0,s1
    80003332:	ffffd0ef          	jal	80001330 <sleep>
    80003336:	bff9                	j	80003314 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003338:	00017517          	auipc	a0,0x17
    8000333c:	70850513          	addi	a0,a0,1800 # 8001aa40 <log>
    80003340:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003342:	087020ef          	jal	80005bc8 <release>
      break;
    }
  }
}
    80003346:	60e2                	ld	ra,24(sp)
    80003348:	6442                	ld	s0,16(sp)
    8000334a:	64a2                	ld	s1,8(sp)
    8000334c:	6902                	ld	s2,0(sp)
    8000334e:	6105                	addi	sp,sp,32
    80003350:	8082                	ret

0000000080003352 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003352:	7139                	addi	sp,sp,-64
    80003354:	fc06                	sd	ra,56(sp)
    80003356:	f822                	sd	s0,48(sp)
    80003358:	f426                	sd	s1,40(sp)
    8000335a:	f04a                	sd	s2,32(sp)
    8000335c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000335e:	00017497          	auipc	s1,0x17
    80003362:	6e248493          	addi	s1,s1,1762 # 8001aa40 <log>
    80003366:	8526                	mv	a0,s1
    80003368:	7c8020ef          	jal	80005b30 <acquire>
  log.outstanding -= 1;
    8000336c:	509c                	lw	a5,32(s1)
    8000336e:	37fd                	addiw	a5,a5,-1
    80003370:	0007891b          	sext.w	s2,a5
    80003374:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003376:	50dc                	lw	a5,36(s1)
    80003378:	ef9d                	bnez	a5,800033b6 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    8000337a:	04091763          	bnez	s2,800033c8 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    8000337e:	00017497          	auipc	s1,0x17
    80003382:	6c248493          	addi	s1,s1,1730 # 8001aa40 <log>
    80003386:	4785                	li	a5,1
    80003388:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000338a:	8526                	mv	a0,s1
    8000338c:	03d020ef          	jal	80005bc8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003390:	54dc                	lw	a5,44(s1)
    80003392:	04f04b63          	bgtz	a5,800033e8 <end_op+0x96>
    acquire(&log.lock);
    80003396:	00017497          	auipc	s1,0x17
    8000339a:	6aa48493          	addi	s1,s1,1706 # 8001aa40 <log>
    8000339e:	8526                	mv	a0,s1
    800033a0:	790020ef          	jal	80005b30 <acquire>
    log.committing = 0;
    800033a4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800033a8:	8526                	mv	a0,s1
    800033aa:	fd3fd0ef          	jal	8000137c <wakeup>
    release(&log.lock);
    800033ae:	8526                	mv	a0,s1
    800033b0:	019020ef          	jal	80005bc8 <release>
}
    800033b4:	a025                	j	800033dc <end_op+0x8a>
    800033b6:	ec4e                	sd	s3,24(sp)
    800033b8:	e852                	sd	s4,16(sp)
    800033ba:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800033bc:	00004517          	auipc	a0,0x4
    800033c0:	2bc50513          	addi	a0,a0,700 # 80007678 <etext+0x678>
    800033c4:	43e020ef          	jal	80005802 <panic>
    wakeup(&log);
    800033c8:	00017497          	auipc	s1,0x17
    800033cc:	67848493          	addi	s1,s1,1656 # 8001aa40 <log>
    800033d0:	8526                	mv	a0,s1
    800033d2:	fabfd0ef          	jal	8000137c <wakeup>
  release(&log.lock);
    800033d6:	8526                	mv	a0,s1
    800033d8:	7f0020ef          	jal	80005bc8 <release>
}
    800033dc:	70e2                	ld	ra,56(sp)
    800033de:	7442                	ld	s0,48(sp)
    800033e0:	74a2                	ld	s1,40(sp)
    800033e2:	7902                	ld	s2,32(sp)
    800033e4:	6121                	addi	sp,sp,64
    800033e6:	8082                	ret
    800033e8:	ec4e                	sd	s3,24(sp)
    800033ea:	e852                	sd	s4,16(sp)
    800033ec:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800033ee:	00017a97          	auipc	s5,0x17
    800033f2:	682a8a93          	addi	s5,s5,1666 # 8001aa70 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800033f6:	00017a17          	auipc	s4,0x17
    800033fa:	64aa0a13          	addi	s4,s4,1610 # 8001aa40 <log>
    800033fe:	018a2583          	lw	a1,24(s4)
    80003402:	012585bb          	addw	a1,a1,s2
    80003406:	2585                	addiw	a1,a1,1
    80003408:	028a2503          	lw	a0,40(s4)
    8000340c:	f0ffe0ef          	jal	8000231a <bread>
    80003410:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003412:	000aa583          	lw	a1,0(s5)
    80003416:	028a2503          	lw	a0,40(s4)
    8000341a:	f01fe0ef          	jal	8000231a <bread>
    8000341e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003420:	40000613          	li	a2,1024
    80003424:	05850593          	addi	a1,a0,88
    80003428:	05848513          	addi	a0,s1,88
    8000342c:	d65fc0ef          	jal	80000190 <memmove>
    bwrite(to);  // write the log
    80003430:	8526                	mv	a0,s1
    80003432:	fbffe0ef          	jal	800023f0 <bwrite>
    brelse(from);
    80003436:	854e                	mv	a0,s3
    80003438:	febfe0ef          	jal	80002422 <brelse>
    brelse(to);
    8000343c:	8526                	mv	a0,s1
    8000343e:	fe5fe0ef          	jal	80002422 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003442:	2905                	addiw	s2,s2,1
    80003444:	0a91                	addi	s5,s5,4
    80003446:	02ca2783          	lw	a5,44(s4)
    8000344a:	faf94ae3          	blt	s2,a5,800033fe <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000344e:	d11ff0ef          	jal	8000315e <write_head>
    install_trans(0); // Now install writes to home locations
    80003452:	4501                	li	a0,0
    80003454:	d69ff0ef          	jal	800031bc <install_trans>
    log.lh.n = 0;
    80003458:	00017797          	auipc	a5,0x17
    8000345c:	6007aa23          	sw	zero,1556(a5) # 8001aa6c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003460:	cffff0ef          	jal	8000315e <write_head>
    80003464:	69e2                	ld	s3,24(sp)
    80003466:	6a42                	ld	s4,16(sp)
    80003468:	6aa2                	ld	s5,8(sp)
    8000346a:	b735                	j	80003396 <end_op+0x44>

000000008000346c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000346c:	1101                	addi	sp,sp,-32
    8000346e:	ec06                	sd	ra,24(sp)
    80003470:	e822                	sd	s0,16(sp)
    80003472:	e426                	sd	s1,8(sp)
    80003474:	e04a                	sd	s2,0(sp)
    80003476:	1000                	addi	s0,sp,32
    80003478:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000347a:	00017917          	auipc	s2,0x17
    8000347e:	5c690913          	addi	s2,s2,1478 # 8001aa40 <log>
    80003482:	854a                	mv	a0,s2
    80003484:	6ac020ef          	jal	80005b30 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003488:	02c92603          	lw	a2,44(s2)
    8000348c:	47f5                	li	a5,29
    8000348e:	06c7c363          	blt	a5,a2,800034f4 <log_write+0x88>
    80003492:	00017797          	auipc	a5,0x17
    80003496:	5ca7a783          	lw	a5,1482(a5) # 8001aa5c <log+0x1c>
    8000349a:	37fd                	addiw	a5,a5,-1
    8000349c:	04f65c63          	bge	a2,a5,800034f4 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800034a0:	00017797          	auipc	a5,0x17
    800034a4:	5c07a783          	lw	a5,1472(a5) # 8001aa60 <log+0x20>
    800034a8:	04f05c63          	blez	a5,80003500 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800034ac:	4781                	li	a5,0
    800034ae:	04c05f63          	blez	a2,8000350c <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800034b2:	44cc                	lw	a1,12(s1)
    800034b4:	00017717          	auipc	a4,0x17
    800034b8:	5bc70713          	addi	a4,a4,1468 # 8001aa70 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800034bc:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800034be:	4314                	lw	a3,0(a4)
    800034c0:	04b68663          	beq	a3,a1,8000350c <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800034c4:	2785                	addiw	a5,a5,1
    800034c6:	0711                	addi	a4,a4,4
    800034c8:	fef61be3          	bne	a2,a5,800034be <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800034cc:	0621                	addi	a2,a2,8
    800034ce:	060a                	slli	a2,a2,0x2
    800034d0:	00017797          	auipc	a5,0x17
    800034d4:	57078793          	addi	a5,a5,1392 # 8001aa40 <log>
    800034d8:	97b2                	add	a5,a5,a2
    800034da:	44d8                	lw	a4,12(s1)
    800034dc:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800034de:	8526                	mv	a0,s1
    800034e0:	fcbfe0ef          	jal	800024aa <bpin>
    log.lh.n++;
    800034e4:	00017717          	auipc	a4,0x17
    800034e8:	55c70713          	addi	a4,a4,1372 # 8001aa40 <log>
    800034ec:	575c                	lw	a5,44(a4)
    800034ee:	2785                	addiw	a5,a5,1
    800034f0:	d75c                	sw	a5,44(a4)
    800034f2:	a80d                	j	80003524 <log_write+0xb8>
    panic("too big a transaction");
    800034f4:	00004517          	auipc	a0,0x4
    800034f8:	19450513          	addi	a0,a0,404 # 80007688 <etext+0x688>
    800034fc:	306020ef          	jal	80005802 <panic>
    panic("log_write outside of trans");
    80003500:	00004517          	auipc	a0,0x4
    80003504:	1a050513          	addi	a0,a0,416 # 800076a0 <etext+0x6a0>
    80003508:	2fa020ef          	jal	80005802 <panic>
  log.lh.block[i] = b->blockno;
    8000350c:	00878693          	addi	a3,a5,8
    80003510:	068a                	slli	a3,a3,0x2
    80003512:	00017717          	auipc	a4,0x17
    80003516:	52e70713          	addi	a4,a4,1326 # 8001aa40 <log>
    8000351a:	9736                	add	a4,a4,a3
    8000351c:	44d4                	lw	a3,12(s1)
    8000351e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003520:	faf60fe3          	beq	a2,a5,800034de <log_write+0x72>
  }
  release(&log.lock);
    80003524:	00017517          	auipc	a0,0x17
    80003528:	51c50513          	addi	a0,a0,1308 # 8001aa40 <log>
    8000352c:	69c020ef          	jal	80005bc8 <release>
}
    80003530:	60e2                	ld	ra,24(sp)
    80003532:	6442                	ld	s0,16(sp)
    80003534:	64a2                	ld	s1,8(sp)
    80003536:	6902                	ld	s2,0(sp)
    80003538:	6105                	addi	sp,sp,32
    8000353a:	8082                	ret

000000008000353c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000353c:	1101                	addi	sp,sp,-32
    8000353e:	ec06                	sd	ra,24(sp)
    80003540:	e822                	sd	s0,16(sp)
    80003542:	e426                	sd	s1,8(sp)
    80003544:	e04a                	sd	s2,0(sp)
    80003546:	1000                	addi	s0,sp,32
    80003548:	84aa                	mv	s1,a0
    8000354a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000354c:	00004597          	auipc	a1,0x4
    80003550:	17458593          	addi	a1,a1,372 # 800076c0 <etext+0x6c0>
    80003554:	0521                	addi	a0,a0,8
    80003556:	55a020ef          	jal	80005ab0 <initlock>
  lk->name = name;
    8000355a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000355e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003562:	0204a423          	sw	zero,40(s1)
}
    80003566:	60e2                	ld	ra,24(sp)
    80003568:	6442                	ld	s0,16(sp)
    8000356a:	64a2                	ld	s1,8(sp)
    8000356c:	6902                	ld	s2,0(sp)
    8000356e:	6105                	addi	sp,sp,32
    80003570:	8082                	ret

0000000080003572 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003572:	1101                	addi	sp,sp,-32
    80003574:	ec06                	sd	ra,24(sp)
    80003576:	e822                	sd	s0,16(sp)
    80003578:	e426                	sd	s1,8(sp)
    8000357a:	e04a                	sd	s2,0(sp)
    8000357c:	1000                	addi	s0,sp,32
    8000357e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003580:	00850913          	addi	s2,a0,8
    80003584:	854a                	mv	a0,s2
    80003586:	5aa020ef          	jal	80005b30 <acquire>
  while (lk->locked) {
    8000358a:	409c                	lw	a5,0(s1)
    8000358c:	c799                	beqz	a5,8000359a <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000358e:	85ca                	mv	a1,s2
    80003590:	8526                	mv	a0,s1
    80003592:	d9ffd0ef          	jal	80001330 <sleep>
  while (lk->locked) {
    80003596:	409c                	lw	a5,0(s1)
    80003598:	fbfd                	bnez	a5,8000358e <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000359a:	4785                	li	a5,1
    8000359c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000359e:	fb8fd0ef          	jal	80000d56 <myproc>
    800035a2:	591c                	lw	a5,48(a0)
    800035a4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800035a6:	854a                	mv	a0,s2
    800035a8:	620020ef          	jal	80005bc8 <release>
}
    800035ac:	60e2                	ld	ra,24(sp)
    800035ae:	6442                	ld	s0,16(sp)
    800035b0:	64a2                	ld	s1,8(sp)
    800035b2:	6902                	ld	s2,0(sp)
    800035b4:	6105                	addi	sp,sp,32
    800035b6:	8082                	ret

00000000800035b8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800035b8:	1101                	addi	sp,sp,-32
    800035ba:	ec06                	sd	ra,24(sp)
    800035bc:	e822                	sd	s0,16(sp)
    800035be:	e426                	sd	s1,8(sp)
    800035c0:	e04a                	sd	s2,0(sp)
    800035c2:	1000                	addi	s0,sp,32
    800035c4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800035c6:	00850913          	addi	s2,a0,8
    800035ca:	854a                	mv	a0,s2
    800035cc:	564020ef          	jal	80005b30 <acquire>
  lk->locked = 0;
    800035d0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800035d4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800035d8:	8526                	mv	a0,s1
    800035da:	da3fd0ef          	jal	8000137c <wakeup>
  release(&lk->lk);
    800035de:	854a                	mv	a0,s2
    800035e0:	5e8020ef          	jal	80005bc8 <release>
}
    800035e4:	60e2                	ld	ra,24(sp)
    800035e6:	6442                	ld	s0,16(sp)
    800035e8:	64a2                	ld	s1,8(sp)
    800035ea:	6902                	ld	s2,0(sp)
    800035ec:	6105                	addi	sp,sp,32
    800035ee:	8082                	ret

00000000800035f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800035f0:	7179                	addi	sp,sp,-48
    800035f2:	f406                	sd	ra,40(sp)
    800035f4:	f022                	sd	s0,32(sp)
    800035f6:	ec26                	sd	s1,24(sp)
    800035f8:	e84a                	sd	s2,16(sp)
    800035fa:	1800                	addi	s0,sp,48
    800035fc:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800035fe:	00850913          	addi	s2,a0,8
    80003602:	854a                	mv	a0,s2
    80003604:	52c020ef          	jal	80005b30 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003608:	409c                	lw	a5,0(s1)
    8000360a:	ef81                	bnez	a5,80003622 <holdingsleep+0x32>
    8000360c:	4481                	li	s1,0
  release(&lk->lk);
    8000360e:	854a                	mv	a0,s2
    80003610:	5b8020ef          	jal	80005bc8 <release>
  return r;
}
    80003614:	8526                	mv	a0,s1
    80003616:	70a2                	ld	ra,40(sp)
    80003618:	7402                	ld	s0,32(sp)
    8000361a:	64e2                	ld	s1,24(sp)
    8000361c:	6942                	ld	s2,16(sp)
    8000361e:	6145                	addi	sp,sp,48
    80003620:	8082                	ret
    80003622:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003624:	0284a983          	lw	s3,40(s1)
    80003628:	f2efd0ef          	jal	80000d56 <myproc>
    8000362c:	5904                	lw	s1,48(a0)
    8000362e:	413484b3          	sub	s1,s1,s3
    80003632:	0014b493          	seqz	s1,s1
    80003636:	69a2                	ld	s3,8(sp)
    80003638:	bfd9                	j	8000360e <holdingsleep+0x1e>

000000008000363a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000363a:	1141                	addi	sp,sp,-16
    8000363c:	e406                	sd	ra,8(sp)
    8000363e:	e022                	sd	s0,0(sp)
    80003640:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003642:	00004597          	auipc	a1,0x4
    80003646:	08e58593          	addi	a1,a1,142 # 800076d0 <etext+0x6d0>
    8000364a:	00017517          	auipc	a0,0x17
    8000364e:	53e50513          	addi	a0,a0,1342 # 8001ab88 <ftable>
    80003652:	45e020ef          	jal	80005ab0 <initlock>
}
    80003656:	60a2                	ld	ra,8(sp)
    80003658:	6402                	ld	s0,0(sp)
    8000365a:	0141                	addi	sp,sp,16
    8000365c:	8082                	ret

000000008000365e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000365e:	1101                	addi	sp,sp,-32
    80003660:	ec06                	sd	ra,24(sp)
    80003662:	e822                	sd	s0,16(sp)
    80003664:	e426                	sd	s1,8(sp)
    80003666:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003668:	00017517          	auipc	a0,0x17
    8000366c:	52050513          	addi	a0,a0,1312 # 8001ab88 <ftable>
    80003670:	4c0020ef          	jal	80005b30 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003674:	00017497          	auipc	s1,0x17
    80003678:	52c48493          	addi	s1,s1,1324 # 8001aba0 <ftable+0x18>
    8000367c:	00018717          	auipc	a4,0x18
    80003680:	4c470713          	addi	a4,a4,1220 # 8001bb40 <disk>
    if(f->ref == 0){
    80003684:	40dc                	lw	a5,4(s1)
    80003686:	cf89                	beqz	a5,800036a0 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003688:	02848493          	addi	s1,s1,40
    8000368c:	fee49ce3          	bne	s1,a4,80003684 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003690:	00017517          	auipc	a0,0x17
    80003694:	4f850513          	addi	a0,a0,1272 # 8001ab88 <ftable>
    80003698:	530020ef          	jal	80005bc8 <release>
  return 0;
    8000369c:	4481                	li	s1,0
    8000369e:	a809                	j	800036b0 <filealloc+0x52>
      f->ref = 1;
    800036a0:	4785                	li	a5,1
    800036a2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800036a4:	00017517          	auipc	a0,0x17
    800036a8:	4e450513          	addi	a0,a0,1252 # 8001ab88 <ftable>
    800036ac:	51c020ef          	jal	80005bc8 <release>
}
    800036b0:	8526                	mv	a0,s1
    800036b2:	60e2                	ld	ra,24(sp)
    800036b4:	6442                	ld	s0,16(sp)
    800036b6:	64a2                	ld	s1,8(sp)
    800036b8:	6105                	addi	sp,sp,32
    800036ba:	8082                	ret

00000000800036bc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800036bc:	1101                	addi	sp,sp,-32
    800036be:	ec06                	sd	ra,24(sp)
    800036c0:	e822                	sd	s0,16(sp)
    800036c2:	e426                	sd	s1,8(sp)
    800036c4:	1000                	addi	s0,sp,32
    800036c6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800036c8:	00017517          	auipc	a0,0x17
    800036cc:	4c050513          	addi	a0,a0,1216 # 8001ab88 <ftable>
    800036d0:	460020ef          	jal	80005b30 <acquire>
  if(f->ref < 1)
    800036d4:	40dc                	lw	a5,4(s1)
    800036d6:	02f05063          	blez	a5,800036f6 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800036da:	2785                	addiw	a5,a5,1
    800036dc:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800036de:	00017517          	auipc	a0,0x17
    800036e2:	4aa50513          	addi	a0,a0,1194 # 8001ab88 <ftable>
    800036e6:	4e2020ef          	jal	80005bc8 <release>
  return f;
}
    800036ea:	8526                	mv	a0,s1
    800036ec:	60e2                	ld	ra,24(sp)
    800036ee:	6442                	ld	s0,16(sp)
    800036f0:	64a2                	ld	s1,8(sp)
    800036f2:	6105                	addi	sp,sp,32
    800036f4:	8082                	ret
    panic("filedup");
    800036f6:	00004517          	auipc	a0,0x4
    800036fa:	fe250513          	addi	a0,a0,-30 # 800076d8 <etext+0x6d8>
    800036fe:	104020ef          	jal	80005802 <panic>

0000000080003702 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003702:	7139                	addi	sp,sp,-64
    80003704:	fc06                	sd	ra,56(sp)
    80003706:	f822                	sd	s0,48(sp)
    80003708:	f426                	sd	s1,40(sp)
    8000370a:	0080                	addi	s0,sp,64
    8000370c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000370e:	00017517          	auipc	a0,0x17
    80003712:	47a50513          	addi	a0,a0,1146 # 8001ab88 <ftable>
    80003716:	41a020ef          	jal	80005b30 <acquire>
  if(f->ref < 1)
    8000371a:	40dc                	lw	a5,4(s1)
    8000371c:	04f05a63          	blez	a5,80003770 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003720:	37fd                	addiw	a5,a5,-1
    80003722:	0007871b          	sext.w	a4,a5
    80003726:	c0dc                	sw	a5,4(s1)
    80003728:	04e04e63          	bgtz	a4,80003784 <fileclose+0x82>
    8000372c:	f04a                	sd	s2,32(sp)
    8000372e:	ec4e                	sd	s3,24(sp)
    80003730:	e852                	sd	s4,16(sp)
    80003732:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003734:	0004a903          	lw	s2,0(s1)
    80003738:	0094ca83          	lbu	s5,9(s1)
    8000373c:	0104ba03          	ld	s4,16(s1)
    80003740:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003744:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003748:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000374c:	00017517          	auipc	a0,0x17
    80003750:	43c50513          	addi	a0,a0,1084 # 8001ab88 <ftable>
    80003754:	474020ef          	jal	80005bc8 <release>

  if(ff.type == FD_PIPE){
    80003758:	4785                	li	a5,1
    8000375a:	04f90063          	beq	s2,a5,8000379a <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000375e:	3979                	addiw	s2,s2,-2
    80003760:	4785                	li	a5,1
    80003762:	0527f563          	bgeu	a5,s2,800037ac <fileclose+0xaa>
    80003766:	7902                	ld	s2,32(sp)
    80003768:	69e2                	ld	s3,24(sp)
    8000376a:	6a42                	ld	s4,16(sp)
    8000376c:	6aa2                	ld	s5,8(sp)
    8000376e:	a00d                	j	80003790 <fileclose+0x8e>
    80003770:	f04a                	sd	s2,32(sp)
    80003772:	ec4e                	sd	s3,24(sp)
    80003774:	e852                	sd	s4,16(sp)
    80003776:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003778:	00004517          	auipc	a0,0x4
    8000377c:	f6850513          	addi	a0,a0,-152 # 800076e0 <etext+0x6e0>
    80003780:	082020ef          	jal	80005802 <panic>
    release(&ftable.lock);
    80003784:	00017517          	auipc	a0,0x17
    80003788:	40450513          	addi	a0,a0,1028 # 8001ab88 <ftable>
    8000378c:	43c020ef          	jal	80005bc8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003790:	70e2                	ld	ra,56(sp)
    80003792:	7442                	ld	s0,48(sp)
    80003794:	74a2                	ld	s1,40(sp)
    80003796:	6121                	addi	sp,sp,64
    80003798:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000379a:	85d6                	mv	a1,s5
    8000379c:	8552                	mv	a0,s4
    8000379e:	336000ef          	jal	80003ad4 <pipeclose>
    800037a2:	7902                	ld	s2,32(sp)
    800037a4:	69e2                	ld	s3,24(sp)
    800037a6:	6a42                	ld	s4,16(sp)
    800037a8:	6aa2                	ld	s5,8(sp)
    800037aa:	b7dd                	j	80003790 <fileclose+0x8e>
    begin_op();
    800037ac:	b3dff0ef          	jal	800032e8 <begin_op>
    iput(ff.ip);
    800037b0:	854e                	mv	a0,s3
    800037b2:	c22ff0ef          	jal	80002bd4 <iput>
    end_op();
    800037b6:	b9dff0ef          	jal	80003352 <end_op>
    800037ba:	7902                	ld	s2,32(sp)
    800037bc:	69e2                	ld	s3,24(sp)
    800037be:	6a42                	ld	s4,16(sp)
    800037c0:	6aa2                	ld	s5,8(sp)
    800037c2:	b7f9                	j	80003790 <fileclose+0x8e>

00000000800037c4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800037c4:	715d                	addi	sp,sp,-80
    800037c6:	e486                	sd	ra,72(sp)
    800037c8:	e0a2                	sd	s0,64(sp)
    800037ca:	fc26                	sd	s1,56(sp)
    800037cc:	f44e                	sd	s3,40(sp)
    800037ce:	0880                	addi	s0,sp,80
    800037d0:	84aa                	mv	s1,a0
    800037d2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800037d4:	d82fd0ef          	jal	80000d56 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800037d8:	409c                	lw	a5,0(s1)
    800037da:	37f9                	addiw	a5,a5,-2
    800037dc:	4705                	li	a4,1
    800037de:	04f76063          	bltu	a4,a5,8000381e <filestat+0x5a>
    800037e2:	f84a                	sd	s2,48(sp)
    800037e4:	892a                	mv	s2,a0
    ilock(f->ip);
    800037e6:	6c88                	ld	a0,24(s1)
    800037e8:	a6aff0ef          	jal	80002a52 <ilock>
    stati(f->ip, &st);
    800037ec:	fb840593          	addi	a1,s0,-72
    800037f0:	6c88                	ld	a0,24(s1)
    800037f2:	c8aff0ef          	jal	80002c7c <stati>
    iunlock(f->ip);
    800037f6:	6c88                	ld	a0,24(s1)
    800037f8:	b08ff0ef          	jal	80002b00 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800037fc:	46e1                	li	a3,24
    800037fe:	fb840613          	addi	a2,s0,-72
    80003802:	85ce                	mv	a1,s3
    80003804:	05093503          	ld	a0,80(s2)
    80003808:	9befd0ef          	jal	800009c6 <copyout>
    8000380c:	41f5551b          	sraiw	a0,a0,0x1f
    80003810:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003812:	60a6                	ld	ra,72(sp)
    80003814:	6406                	ld	s0,64(sp)
    80003816:	74e2                	ld	s1,56(sp)
    80003818:	79a2                	ld	s3,40(sp)
    8000381a:	6161                	addi	sp,sp,80
    8000381c:	8082                	ret
  return -1;
    8000381e:	557d                	li	a0,-1
    80003820:	bfcd                	j	80003812 <filestat+0x4e>

0000000080003822 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003822:	7179                	addi	sp,sp,-48
    80003824:	f406                	sd	ra,40(sp)
    80003826:	f022                	sd	s0,32(sp)
    80003828:	e84a                	sd	s2,16(sp)
    8000382a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000382c:	00854783          	lbu	a5,8(a0)
    80003830:	cfd1                	beqz	a5,800038cc <fileread+0xaa>
    80003832:	ec26                	sd	s1,24(sp)
    80003834:	e44e                	sd	s3,8(sp)
    80003836:	84aa                	mv	s1,a0
    80003838:	89ae                	mv	s3,a1
    8000383a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000383c:	411c                	lw	a5,0(a0)
    8000383e:	4705                	li	a4,1
    80003840:	04e78363          	beq	a5,a4,80003886 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003844:	470d                	li	a4,3
    80003846:	04e78763          	beq	a5,a4,80003894 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000384a:	4709                	li	a4,2
    8000384c:	06e79a63          	bne	a5,a4,800038c0 <fileread+0x9e>
    ilock(f->ip);
    80003850:	6d08                	ld	a0,24(a0)
    80003852:	a00ff0ef          	jal	80002a52 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003856:	874a                	mv	a4,s2
    80003858:	5094                	lw	a3,32(s1)
    8000385a:	864e                	mv	a2,s3
    8000385c:	4585                	li	a1,1
    8000385e:	6c88                	ld	a0,24(s1)
    80003860:	c46ff0ef          	jal	80002ca6 <readi>
    80003864:	892a                	mv	s2,a0
    80003866:	00a05563          	blez	a0,80003870 <fileread+0x4e>
      f->off += r;
    8000386a:	509c                	lw	a5,32(s1)
    8000386c:	9fa9                	addw	a5,a5,a0
    8000386e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003870:	6c88                	ld	a0,24(s1)
    80003872:	a8eff0ef          	jal	80002b00 <iunlock>
    80003876:	64e2                	ld	s1,24(sp)
    80003878:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000387a:	854a                	mv	a0,s2
    8000387c:	70a2                	ld	ra,40(sp)
    8000387e:	7402                	ld	s0,32(sp)
    80003880:	6942                	ld	s2,16(sp)
    80003882:	6145                	addi	sp,sp,48
    80003884:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003886:	6908                	ld	a0,16(a0)
    80003888:	388000ef          	jal	80003c10 <piperead>
    8000388c:	892a                	mv	s2,a0
    8000388e:	64e2                	ld	s1,24(sp)
    80003890:	69a2                	ld	s3,8(sp)
    80003892:	b7e5                	j	8000387a <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003894:	02451783          	lh	a5,36(a0)
    80003898:	03079693          	slli	a3,a5,0x30
    8000389c:	92c1                	srli	a3,a3,0x30
    8000389e:	4725                	li	a4,9
    800038a0:	02d76863          	bltu	a4,a3,800038d0 <fileread+0xae>
    800038a4:	0792                	slli	a5,a5,0x4
    800038a6:	00017717          	auipc	a4,0x17
    800038aa:	24270713          	addi	a4,a4,578 # 8001aae8 <devsw>
    800038ae:	97ba                	add	a5,a5,a4
    800038b0:	639c                	ld	a5,0(a5)
    800038b2:	c39d                	beqz	a5,800038d8 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800038b4:	4505                	li	a0,1
    800038b6:	9782                	jalr	a5
    800038b8:	892a                	mv	s2,a0
    800038ba:	64e2                	ld	s1,24(sp)
    800038bc:	69a2                	ld	s3,8(sp)
    800038be:	bf75                	j	8000387a <fileread+0x58>
    panic("fileread");
    800038c0:	00004517          	auipc	a0,0x4
    800038c4:	e3050513          	addi	a0,a0,-464 # 800076f0 <etext+0x6f0>
    800038c8:	73b010ef          	jal	80005802 <panic>
    return -1;
    800038cc:	597d                	li	s2,-1
    800038ce:	b775                	j	8000387a <fileread+0x58>
      return -1;
    800038d0:	597d                	li	s2,-1
    800038d2:	64e2                	ld	s1,24(sp)
    800038d4:	69a2                	ld	s3,8(sp)
    800038d6:	b755                	j	8000387a <fileread+0x58>
    800038d8:	597d                	li	s2,-1
    800038da:	64e2                	ld	s1,24(sp)
    800038dc:	69a2                	ld	s3,8(sp)
    800038de:	bf71                	j	8000387a <fileread+0x58>

00000000800038e0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800038e0:	00954783          	lbu	a5,9(a0)
    800038e4:	10078b63          	beqz	a5,800039fa <filewrite+0x11a>
{
    800038e8:	715d                	addi	sp,sp,-80
    800038ea:	e486                	sd	ra,72(sp)
    800038ec:	e0a2                	sd	s0,64(sp)
    800038ee:	f84a                	sd	s2,48(sp)
    800038f0:	f052                	sd	s4,32(sp)
    800038f2:	e85a                	sd	s6,16(sp)
    800038f4:	0880                	addi	s0,sp,80
    800038f6:	892a                	mv	s2,a0
    800038f8:	8b2e                	mv	s6,a1
    800038fa:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800038fc:	411c                	lw	a5,0(a0)
    800038fe:	4705                	li	a4,1
    80003900:	02e78763          	beq	a5,a4,8000392e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003904:	470d                	li	a4,3
    80003906:	02e78863          	beq	a5,a4,80003936 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000390a:	4709                	li	a4,2
    8000390c:	0ce79c63          	bne	a5,a4,800039e4 <filewrite+0x104>
    80003910:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003912:	0ac05863          	blez	a2,800039c2 <filewrite+0xe2>
    80003916:	fc26                	sd	s1,56(sp)
    80003918:	ec56                	sd	s5,24(sp)
    8000391a:	e45e                	sd	s7,8(sp)
    8000391c:	e062                	sd	s8,0(sp)
    int i = 0;
    8000391e:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003920:	6b85                	lui	s7,0x1
    80003922:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003926:	6c05                	lui	s8,0x1
    80003928:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000392c:	a8b5                	j	800039a8 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    8000392e:	6908                	ld	a0,16(a0)
    80003930:	1fc000ef          	jal	80003b2c <pipewrite>
    80003934:	a04d                	j	800039d6 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003936:	02451783          	lh	a5,36(a0)
    8000393a:	03079693          	slli	a3,a5,0x30
    8000393e:	92c1                	srli	a3,a3,0x30
    80003940:	4725                	li	a4,9
    80003942:	0ad76e63          	bltu	a4,a3,800039fe <filewrite+0x11e>
    80003946:	0792                	slli	a5,a5,0x4
    80003948:	00017717          	auipc	a4,0x17
    8000394c:	1a070713          	addi	a4,a4,416 # 8001aae8 <devsw>
    80003950:	97ba                	add	a5,a5,a4
    80003952:	679c                	ld	a5,8(a5)
    80003954:	c7dd                	beqz	a5,80003a02 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80003956:	4505                	li	a0,1
    80003958:	9782                	jalr	a5
    8000395a:	a8b5                	j	800039d6 <filewrite+0xf6>
      if(n1 > max)
    8000395c:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003960:	989ff0ef          	jal	800032e8 <begin_op>
      ilock(f->ip);
    80003964:	01893503          	ld	a0,24(s2)
    80003968:	8eaff0ef          	jal	80002a52 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000396c:	8756                	mv	a4,s5
    8000396e:	02092683          	lw	a3,32(s2)
    80003972:	01698633          	add	a2,s3,s6
    80003976:	4585                	li	a1,1
    80003978:	01893503          	ld	a0,24(s2)
    8000397c:	c26ff0ef          	jal	80002da2 <writei>
    80003980:	84aa                	mv	s1,a0
    80003982:	00a05763          	blez	a0,80003990 <filewrite+0xb0>
        f->off += r;
    80003986:	02092783          	lw	a5,32(s2)
    8000398a:	9fa9                	addw	a5,a5,a0
    8000398c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003990:	01893503          	ld	a0,24(s2)
    80003994:	96cff0ef          	jal	80002b00 <iunlock>
      end_op();
    80003998:	9bbff0ef          	jal	80003352 <end_op>

      if(r != n1){
    8000399c:	029a9563          	bne	s5,s1,800039c6 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800039a0:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800039a4:	0149da63          	bge	s3,s4,800039b8 <filewrite+0xd8>
      int n1 = n - i;
    800039a8:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800039ac:	0004879b          	sext.w	a5,s1
    800039b0:	fafbd6e3          	bge	s7,a5,8000395c <filewrite+0x7c>
    800039b4:	84e2                	mv	s1,s8
    800039b6:	b75d                	j	8000395c <filewrite+0x7c>
    800039b8:	74e2                	ld	s1,56(sp)
    800039ba:	6ae2                	ld	s5,24(sp)
    800039bc:	6ba2                	ld	s7,8(sp)
    800039be:	6c02                	ld	s8,0(sp)
    800039c0:	a039                	j	800039ce <filewrite+0xee>
    int i = 0;
    800039c2:	4981                	li	s3,0
    800039c4:	a029                	j	800039ce <filewrite+0xee>
    800039c6:	74e2                	ld	s1,56(sp)
    800039c8:	6ae2                	ld	s5,24(sp)
    800039ca:	6ba2                	ld	s7,8(sp)
    800039cc:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800039ce:	033a1c63          	bne	s4,s3,80003a06 <filewrite+0x126>
    800039d2:	8552                	mv	a0,s4
    800039d4:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800039d6:	60a6                	ld	ra,72(sp)
    800039d8:	6406                	ld	s0,64(sp)
    800039da:	7942                	ld	s2,48(sp)
    800039dc:	7a02                	ld	s4,32(sp)
    800039de:	6b42                	ld	s6,16(sp)
    800039e0:	6161                	addi	sp,sp,80
    800039e2:	8082                	ret
    800039e4:	fc26                	sd	s1,56(sp)
    800039e6:	f44e                	sd	s3,40(sp)
    800039e8:	ec56                	sd	s5,24(sp)
    800039ea:	e45e                	sd	s7,8(sp)
    800039ec:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800039ee:	00004517          	auipc	a0,0x4
    800039f2:	d1250513          	addi	a0,a0,-750 # 80007700 <etext+0x700>
    800039f6:	60d010ef          	jal	80005802 <panic>
    return -1;
    800039fa:	557d                	li	a0,-1
}
    800039fc:	8082                	ret
      return -1;
    800039fe:	557d                	li	a0,-1
    80003a00:	bfd9                	j	800039d6 <filewrite+0xf6>
    80003a02:	557d                	li	a0,-1
    80003a04:	bfc9                	j	800039d6 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80003a06:	557d                	li	a0,-1
    80003a08:	79a2                	ld	s3,40(sp)
    80003a0a:	b7f1                	j	800039d6 <filewrite+0xf6>

0000000080003a0c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003a0c:	7179                	addi	sp,sp,-48
    80003a0e:	f406                	sd	ra,40(sp)
    80003a10:	f022                	sd	s0,32(sp)
    80003a12:	ec26                	sd	s1,24(sp)
    80003a14:	e052                	sd	s4,0(sp)
    80003a16:	1800                	addi	s0,sp,48
    80003a18:	84aa                	mv	s1,a0
    80003a1a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003a1c:	0005b023          	sd	zero,0(a1)
    80003a20:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003a24:	c3bff0ef          	jal	8000365e <filealloc>
    80003a28:	e088                	sd	a0,0(s1)
    80003a2a:	c549                	beqz	a0,80003ab4 <pipealloc+0xa8>
    80003a2c:	c33ff0ef          	jal	8000365e <filealloc>
    80003a30:	00aa3023          	sd	a0,0(s4)
    80003a34:	cd25                	beqz	a0,80003aac <pipealloc+0xa0>
    80003a36:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003a38:	ebefc0ef          	jal	800000f6 <kalloc>
    80003a3c:	892a                	mv	s2,a0
    80003a3e:	c12d                	beqz	a0,80003aa0 <pipealloc+0x94>
    80003a40:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003a42:	4985                	li	s3,1
    80003a44:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003a48:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003a4c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003a50:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003a54:	00004597          	auipc	a1,0x4
    80003a58:	a3c58593          	addi	a1,a1,-1476 # 80007490 <etext+0x490>
    80003a5c:	054020ef          	jal	80005ab0 <initlock>
  (*f0)->type = FD_PIPE;
    80003a60:	609c                	ld	a5,0(s1)
    80003a62:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003a66:	609c                	ld	a5,0(s1)
    80003a68:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003a6c:	609c                	ld	a5,0(s1)
    80003a6e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003a72:	609c                	ld	a5,0(s1)
    80003a74:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003a78:	000a3783          	ld	a5,0(s4)
    80003a7c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003a80:	000a3783          	ld	a5,0(s4)
    80003a84:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003a88:	000a3783          	ld	a5,0(s4)
    80003a8c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003a90:	000a3783          	ld	a5,0(s4)
    80003a94:	0127b823          	sd	s2,16(a5)
  return 0;
    80003a98:	4501                	li	a0,0
    80003a9a:	6942                	ld	s2,16(sp)
    80003a9c:	69a2                	ld	s3,8(sp)
    80003a9e:	a01d                	j	80003ac4 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003aa0:	6088                	ld	a0,0(s1)
    80003aa2:	c119                	beqz	a0,80003aa8 <pipealloc+0x9c>
    80003aa4:	6942                	ld	s2,16(sp)
    80003aa6:	a029                	j	80003ab0 <pipealloc+0xa4>
    80003aa8:	6942                	ld	s2,16(sp)
    80003aaa:	a029                	j	80003ab4 <pipealloc+0xa8>
    80003aac:	6088                	ld	a0,0(s1)
    80003aae:	c10d                	beqz	a0,80003ad0 <pipealloc+0xc4>
    fileclose(*f0);
    80003ab0:	c53ff0ef          	jal	80003702 <fileclose>
  if(*f1)
    80003ab4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ab8:	557d                	li	a0,-1
  if(*f1)
    80003aba:	c789                	beqz	a5,80003ac4 <pipealloc+0xb8>
    fileclose(*f1);
    80003abc:	853e                	mv	a0,a5
    80003abe:	c45ff0ef          	jal	80003702 <fileclose>
  return -1;
    80003ac2:	557d                	li	a0,-1
}
    80003ac4:	70a2                	ld	ra,40(sp)
    80003ac6:	7402                	ld	s0,32(sp)
    80003ac8:	64e2                	ld	s1,24(sp)
    80003aca:	6a02                	ld	s4,0(sp)
    80003acc:	6145                	addi	sp,sp,48
    80003ace:	8082                	ret
  return -1;
    80003ad0:	557d                	li	a0,-1
    80003ad2:	bfcd                	j	80003ac4 <pipealloc+0xb8>

0000000080003ad4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ad4:	1101                	addi	sp,sp,-32
    80003ad6:	ec06                	sd	ra,24(sp)
    80003ad8:	e822                	sd	s0,16(sp)
    80003ada:	e426                	sd	s1,8(sp)
    80003adc:	e04a                	sd	s2,0(sp)
    80003ade:	1000                	addi	s0,sp,32
    80003ae0:	84aa                	mv	s1,a0
    80003ae2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ae4:	04c020ef          	jal	80005b30 <acquire>
  if(writable){
    80003ae8:	02090763          	beqz	s2,80003b16 <pipeclose+0x42>
    pi->writeopen = 0;
    80003aec:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003af0:	21848513          	addi	a0,s1,536
    80003af4:	889fd0ef          	jal	8000137c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003af8:	2204b783          	ld	a5,544(s1)
    80003afc:	e785                	bnez	a5,80003b24 <pipeclose+0x50>
    release(&pi->lock);
    80003afe:	8526                	mv	a0,s1
    80003b00:	0c8020ef          	jal	80005bc8 <release>
    kfree((char*)pi);
    80003b04:	8526                	mv	a0,s1
    80003b06:	d16fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003b0a:	60e2                	ld	ra,24(sp)
    80003b0c:	6442                	ld	s0,16(sp)
    80003b0e:	64a2                	ld	s1,8(sp)
    80003b10:	6902                	ld	s2,0(sp)
    80003b12:	6105                	addi	sp,sp,32
    80003b14:	8082                	ret
    pi->readopen = 0;
    80003b16:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003b1a:	21c48513          	addi	a0,s1,540
    80003b1e:	85ffd0ef          	jal	8000137c <wakeup>
    80003b22:	bfd9                	j	80003af8 <pipeclose+0x24>
    release(&pi->lock);
    80003b24:	8526                	mv	a0,s1
    80003b26:	0a2020ef          	jal	80005bc8 <release>
}
    80003b2a:	b7c5                	j	80003b0a <pipeclose+0x36>

0000000080003b2c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003b2c:	711d                	addi	sp,sp,-96
    80003b2e:	ec86                	sd	ra,88(sp)
    80003b30:	e8a2                	sd	s0,80(sp)
    80003b32:	e4a6                	sd	s1,72(sp)
    80003b34:	e0ca                	sd	s2,64(sp)
    80003b36:	fc4e                	sd	s3,56(sp)
    80003b38:	f852                	sd	s4,48(sp)
    80003b3a:	f456                	sd	s5,40(sp)
    80003b3c:	1080                	addi	s0,sp,96
    80003b3e:	84aa                	mv	s1,a0
    80003b40:	8aae                	mv	s5,a1
    80003b42:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003b44:	a12fd0ef          	jal	80000d56 <myproc>
    80003b48:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003b4a:	8526                	mv	a0,s1
    80003b4c:	7e5010ef          	jal	80005b30 <acquire>
  while(i < n){
    80003b50:	0b405a63          	blez	s4,80003c04 <pipewrite+0xd8>
    80003b54:	f05a                	sd	s6,32(sp)
    80003b56:	ec5e                	sd	s7,24(sp)
    80003b58:	e862                	sd	s8,16(sp)
  int i = 0;
    80003b5a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003b5c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003b5e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003b62:	21c48b93          	addi	s7,s1,540
    80003b66:	a81d                	j	80003b9c <pipewrite+0x70>
      release(&pi->lock);
    80003b68:	8526                	mv	a0,s1
    80003b6a:	05e020ef          	jal	80005bc8 <release>
      return -1;
    80003b6e:	597d                	li	s2,-1
    80003b70:	7b02                	ld	s6,32(sp)
    80003b72:	6be2                	ld	s7,24(sp)
    80003b74:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003b76:	854a                	mv	a0,s2
    80003b78:	60e6                	ld	ra,88(sp)
    80003b7a:	6446                	ld	s0,80(sp)
    80003b7c:	64a6                	ld	s1,72(sp)
    80003b7e:	6906                	ld	s2,64(sp)
    80003b80:	79e2                	ld	s3,56(sp)
    80003b82:	7a42                	ld	s4,48(sp)
    80003b84:	7aa2                	ld	s5,40(sp)
    80003b86:	6125                	addi	sp,sp,96
    80003b88:	8082                	ret
      wakeup(&pi->nread);
    80003b8a:	8562                	mv	a0,s8
    80003b8c:	ff0fd0ef          	jal	8000137c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003b90:	85a6                	mv	a1,s1
    80003b92:	855e                	mv	a0,s7
    80003b94:	f9cfd0ef          	jal	80001330 <sleep>
  while(i < n){
    80003b98:	05495b63          	bge	s2,s4,80003bee <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003b9c:	2204a783          	lw	a5,544(s1)
    80003ba0:	d7e1                	beqz	a5,80003b68 <pipewrite+0x3c>
    80003ba2:	854e                	mv	a0,s3
    80003ba4:	9c5fd0ef          	jal	80001568 <killed>
    80003ba8:	f161                	bnez	a0,80003b68 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003baa:	2184a783          	lw	a5,536(s1)
    80003bae:	21c4a703          	lw	a4,540(s1)
    80003bb2:	2007879b          	addiw	a5,a5,512
    80003bb6:	fcf70ae3          	beq	a4,a5,80003b8a <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003bba:	4685                	li	a3,1
    80003bbc:	01590633          	add	a2,s2,s5
    80003bc0:	faf40593          	addi	a1,s0,-81
    80003bc4:	0509b503          	ld	a0,80(s3)
    80003bc8:	ed7fc0ef          	jal	80000a9e <copyin>
    80003bcc:	03650e63          	beq	a0,s6,80003c08 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003bd0:	21c4a783          	lw	a5,540(s1)
    80003bd4:	0017871b          	addiw	a4,a5,1
    80003bd8:	20e4ae23          	sw	a4,540(s1)
    80003bdc:	1ff7f793          	andi	a5,a5,511
    80003be0:	97a6                	add	a5,a5,s1
    80003be2:	faf44703          	lbu	a4,-81(s0)
    80003be6:	00e78c23          	sb	a4,24(a5)
      i++;
    80003bea:	2905                	addiw	s2,s2,1
    80003bec:	b775                	j	80003b98 <pipewrite+0x6c>
    80003bee:	7b02                	ld	s6,32(sp)
    80003bf0:	6be2                	ld	s7,24(sp)
    80003bf2:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003bf4:	21848513          	addi	a0,s1,536
    80003bf8:	f84fd0ef          	jal	8000137c <wakeup>
  release(&pi->lock);
    80003bfc:	8526                	mv	a0,s1
    80003bfe:	7cb010ef          	jal	80005bc8 <release>
  return i;
    80003c02:	bf95                	j	80003b76 <pipewrite+0x4a>
  int i = 0;
    80003c04:	4901                	li	s2,0
    80003c06:	b7fd                	j	80003bf4 <pipewrite+0xc8>
    80003c08:	7b02                	ld	s6,32(sp)
    80003c0a:	6be2                	ld	s7,24(sp)
    80003c0c:	6c42                	ld	s8,16(sp)
    80003c0e:	b7dd                	j	80003bf4 <pipewrite+0xc8>

0000000080003c10 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003c10:	715d                	addi	sp,sp,-80
    80003c12:	e486                	sd	ra,72(sp)
    80003c14:	e0a2                	sd	s0,64(sp)
    80003c16:	fc26                	sd	s1,56(sp)
    80003c18:	f84a                	sd	s2,48(sp)
    80003c1a:	f44e                	sd	s3,40(sp)
    80003c1c:	f052                	sd	s4,32(sp)
    80003c1e:	ec56                	sd	s5,24(sp)
    80003c20:	0880                	addi	s0,sp,80
    80003c22:	84aa                	mv	s1,a0
    80003c24:	892e                	mv	s2,a1
    80003c26:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003c28:	92efd0ef          	jal	80000d56 <myproc>
    80003c2c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003c2e:	8526                	mv	a0,s1
    80003c30:	701010ef          	jal	80005b30 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003c34:	2184a703          	lw	a4,536(s1)
    80003c38:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003c3c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003c40:	02f71563          	bne	a4,a5,80003c6a <piperead+0x5a>
    80003c44:	2244a783          	lw	a5,548(s1)
    80003c48:	cb85                	beqz	a5,80003c78 <piperead+0x68>
    if(killed(pr)){
    80003c4a:	8552                	mv	a0,s4
    80003c4c:	91dfd0ef          	jal	80001568 <killed>
    80003c50:	ed19                	bnez	a0,80003c6e <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003c52:	85a6                	mv	a1,s1
    80003c54:	854e                	mv	a0,s3
    80003c56:	edafd0ef          	jal	80001330 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003c5a:	2184a703          	lw	a4,536(s1)
    80003c5e:	21c4a783          	lw	a5,540(s1)
    80003c62:	fef701e3          	beq	a4,a5,80003c44 <piperead+0x34>
    80003c66:	e85a                	sd	s6,16(sp)
    80003c68:	a809                	j	80003c7a <piperead+0x6a>
    80003c6a:	e85a                	sd	s6,16(sp)
    80003c6c:	a039                	j	80003c7a <piperead+0x6a>
      release(&pi->lock);
    80003c6e:	8526                	mv	a0,s1
    80003c70:	759010ef          	jal	80005bc8 <release>
      return -1;
    80003c74:	59fd                	li	s3,-1
    80003c76:	a8b1                	j	80003cd2 <piperead+0xc2>
    80003c78:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003c7a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003c7c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003c7e:	05505263          	blez	s5,80003cc2 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003c82:	2184a783          	lw	a5,536(s1)
    80003c86:	21c4a703          	lw	a4,540(s1)
    80003c8a:	02f70c63          	beq	a4,a5,80003cc2 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003c8e:	0017871b          	addiw	a4,a5,1
    80003c92:	20e4ac23          	sw	a4,536(s1)
    80003c96:	1ff7f793          	andi	a5,a5,511
    80003c9a:	97a6                	add	a5,a5,s1
    80003c9c:	0187c783          	lbu	a5,24(a5)
    80003ca0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003ca4:	4685                	li	a3,1
    80003ca6:	fbf40613          	addi	a2,s0,-65
    80003caa:	85ca                	mv	a1,s2
    80003cac:	050a3503          	ld	a0,80(s4)
    80003cb0:	d17fc0ef          	jal	800009c6 <copyout>
    80003cb4:	01650763          	beq	a0,s6,80003cc2 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003cb8:	2985                	addiw	s3,s3,1
    80003cba:	0905                	addi	s2,s2,1
    80003cbc:	fd3a93e3          	bne	s5,s3,80003c82 <piperead+0x72>
    80003cc0:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003cc2:	21c48513          	addi	a0,s1,540
    80003cc6:	eb6fd0ef          	jal	8000137c <wakeup>
  release(&pi->lock);
    80003cca:	8526                	mv	a0,s1
    80003ccc:	6fd010ef          	jal	80005bc8 <release>
    80003cd0:	6b42                	ld	s6,16(sp)
  return i;
}
    80003cd2:	854e                	mv	a0,s3
    80003cd4:	60a6                	ld	ra,72(sp)
    80003cd6:	6406                	ld	s0,64(sp)
    80003cd8:	74e2                	ld	s1,56(sp)
    80003cda:	7942                	ld	s2,48(sp)
    80003cdc:	79a2                	ld	s3,40(sp)
    80003cde:	7a02                	ld	s4,32(sp)
    80003ce0:	6ae2                	ld	s5,24(sp)
    80003ce2:	6161                	addi	sp,sp,80
    80003ce4:	8082                	ret

0000000080003ce6 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003ce6:	1141                	addi	sp,sp,-16
    80003ce8:	e422                	sd	s0,8(sp)
    80003cea:	0800                	addi	s0,sp,16
    80003cec:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003cee:	8905                	andi	a0,a0,1
    80003cf0:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003cf2:	8b89                	andi	a5,a5,2
    80003cf4:	c399                	beqz	a5,80003cfa <flags2perm+0x14>
      perm |= PTE_W;
    80003cf6:	00456513          	ori	a0,a0,4
    return perm;
}
    80003cfa:	6422                	ld	s0,8(sp)
    80003cfc:	0141                	addi	sp,sp,16
    80003cfe:	8082                	ret

0000000080003d00 <exec>:

int
exec(char *path, char **argv)
{
    80003d00:	df010113          	addi	sp,sp,-528
    80003d04:	20113423          	sd	ra,520(sp)
    80003d08:	20813023          	sd	s0,512(sp)
    80003d0c:	ffa6                	sd	s1,504(sp)
    80003d0e:	fbca                	sd	s2,496(sp)
    80003d10:	0c00                	addi	s0,sp,528
    80003d12:	892a                	mv	s2,a0
    80003d14:	dea43c23          	sd	a0,-520(s0)
    80003d18:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003d1c:	83afd0ef          	jal	80000d56 <myproc>
    80003d20:	84aa                	mv	s1,a0

  begin_op();
    80003d22:	dc6ff0ef          	jal	800032e8 <begin_op>

  if((ip = namei(path)) == 0){
    80003d26:	854a                	mv	a0,s2
    80003d28:	c04ff0ef          	jal	8000312c <namei>
    80003d2c:	c931                	beqz	a0,80003d80 <exec+0x80>
    80003d2e:	f3d2                	sd	s4,480(sp)
    80003d30:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003d32:	d21fe0ef          	jal	80002a52 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003d36:	04000713          	li	a4,64
    80003d3a:	4681                	li	a3,0
    80003d3c:	e5040613          	addi	a2,s0,-432
    80003d40:	4581                	li	a1,0
    80003d42:	8552                	mv	a0,s4
    80003d44:	f63fe0ef          	jal	80002ca6 <readi>
    80003d48:	04000793          	li	a5,64
    80003d4c:	00f51a63          	bne	a0,a5,80003d60 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003d50:	e5042703          	lw	a4,-432(s0)
    80003d54:	464c47b7          	lui	a5,0x464c4
    80003d58:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003d5c:	02f70663          	beq	a4,a5,80003d88 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003d60:	8552                	mv	a0,s4
    80003d62:	efbfe0ef          	jal	80002c5c <iunlockput>
    end_op();
    80003d66:	decff0ef          	jal	80003352 <end_op>
  }
  return -1;
    80003d6a:	557d                	li	a0,-1
    80003d6c:	7a1e                	ld	s4,480(sp)
}
    80003d6e:	20813083          	ld	ra,520(sp)
    80003d72:	20013403          	ld	s0,512(sp)
    80003d76:	74fe                	ld	s1,504(sp)
    80003d78:	795e                	ld	s2,496(sp)
    80003d7a:	21010113          	addi	sp,sp,528
    80003d7e:	8082                	ret
    end_op();
    80003d80:	dd2ff0ef          	jal	80003352 <end_op>
    return -1;
    80003d84:	557d                	li	a0,-1
    80003d86:	b7e5                	j	80003d6e <exec+0x6e>
    80003d88:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003d8a:	8526                	mv	a0,s1
    80003d8c:	872fd0ef          	jal	80000dfe <proc_pagetable>
    80003d90:	8b2a                	mv	s6,a0
    80003d92:	2c050b63          	beqz	a0,80004068 <exec+0x368>
    80003d96:	f7ce                	sd	s3,488(sp)
    80003d98:	efd6                	sd	s5,472(sp)
    80003d9a:	e7de                	sd	s7,456(sp)
    80003d9c:	e3e2                	sd	s8,448(sp)
    80003d9e:	ff66                	sd	s9,440(sp)
    80003da0:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003da2:	e7042d03          	lw	s10,-400(s0)
    80003da6:	e8845783          	lhu	a5,-376(s0)
    80003daa:	12078963          	beqz	a5,80003edc <exec+0x1dc>
    80003dae:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003db0:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003db2:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003db4:	6c85                	lui	s9,0x1
    80003db6:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003dba:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003dbe:	6a85                	lui	s5,0x1
    80003dc0:	a085                	j	80003e20 <exec+0x120>
      panic("loadseg: address should exist");
    80003dc2:	00004517          	auipc	a0,0x4
    80003dc6:	94e50513          	addi	a0,a0,-1714 # 80007710 <etext+0x710>
    80003dca:	239010ef          	jal	80005802 <panic>
    if(sz - i < PGSIZE)
    80003dce:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003dd0:	8726                	mv	a4,s1
    80003dd2:	012c06bb          	addw	a3,s8,s2
    80003dd6:	4581                	li	a1,0
    80003dd8:	8552                	mv	a0,s4
    80003dda:	ecdfe0ef          	jal	80002ca6 <readi>
    80003dde:	2501                	sext.w	a0,a0
    80003de0:	24a49a63          	bne	s1,a0,80004034 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003de4:	012a893b          	addw	s2,s5,s2
    80003de8:	03397363          	bgeu	s2,s3,80003e0e <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003dec:	02091593          	slli	a1,s2,0x20
    80003df0:	9181                	srli	a1,a1,0x20
    80003df2:	95de                	add	a1,a1,s7
    80003df4:	855a                	mv	a0,s6
    80003df6:	e4cfc0ef          	jal	80000442 <walkaddr>
    80003dfa:	862a                	mv	a2,a0
    if(pa == 0)
    80003dfc:	d179                	beqz	a0,80003dc2 <exec+0xc2>
    if(sz - i < PGSIZE)
    80003dfe:	412984bb          	subw	s1,s3,s2
    80003e02:	0004879b          	sext.w	a5,s1
    80003e06:	fcfcf4e3          	bgeu	s9,a5,80003dce <exec+0xce>
    80003e0a:	84d6                	mv	s1,s5
    80003e0c:	b7c9                	j	80003dce <exec+0xce>
    sz = sz1;
    80003e0e:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003e12:	2d85                	addiw	s11,s11,1
    80003e14:	038d0d1b          	addiw	s10,s10,56
    80003e18:	e8845783          	lhu	a5,-376(s0)
    80003e1c:	08fdd063          	bge	s11,a5,80003e9c <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003e20:	2d01                	sext.w	s10,s10
    80003e22:	03800713          	li	a4,56
    80003e26:	86ea                	mv	a3,s10
    80003e28:	e1840613          	addi	a2,s0,-488
    80003e2c:	4581                	li	a1,0
    80003e2e:	8552                	mv	a0,s4
    80003e30:	e77fe0ef          	jal	80002ca6 <readi>
    80003e34:	03800793          	li	a5,56
    80003e38:	1cf51663          	bne	a0,a5,80004004 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003e3c:	e1842783          	lw	a5,-488(s0)
    80003e40:	4705                	li	a4,1
    80003e42:	fce798e3          	bne	a5,a4,80003e12 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003e46:	e4043483          	ld	s1,-448(s0)
    80003e4a:	e3843783          	ld	a5,-456(s0)
    80003e4e:	1af4ef63          	bltu	s1,a5,8000400c <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003e52:	e2843783          	ld	a5,-472(s0)
    80003e56:	94be                	add	s1,s1,a5
    80003e58:	1af4ee63          	bltu	s1,a5,80004014 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003e5c:	df043703          	ld	a4,-528(s0)
    80003e60:	8ff9                	and	a5,a5,a4
    80003e62:	1a079d63          	bnez	a5,8000401c <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003e66:	e1c42503          	lw	a0,-484(s0)
    80003e6a:	e7dff0ef          	jal	80003ce6 <flags2perm>
    80003e6e:	86aa                	mv	a3,a0
    80003e70:	8626                	mv	a2,s1
    80003e72:	85ca                	mv	a1,s2
    80003e74:	855a                	mv	a0,s6
    80003e76:	945fc0ef          	jal	800007ba <uvmalloc>
    80003e7a:	e0a43423          	sd	a0,-504(s0)
    80003e7e:	1a050363          	beqz	a0,80004024 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003e82:	e2843b83          	ld	s7,-472(s0)
    80003e86:	e2042c03          	lw	s8,-480(s0)
    80003e8a:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003e8e:	00098463          	beqz	s3,80003e96 <exec+0x196>
    80003e92:	4901                	li	s2,0
    80003e94:	bfa1                	j	80003dec <exec+0xec>
    sz = sz1;
    80003e96:	e0843903          	ld	s2,-504(s0)
    80003e9a:	bfa5                	j	80003e12 <exec+0x112>
    80003e9c:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003e9e:	8552                	mv	a0,s4
    80003ea0:	dbdfe0ef          	jal	80002c5c <iunlockput>
  end_op();
    80003ea4:	caeff0ef          	jal	80003352 <end_op>
  p = myproc();
    80003ea8:	eaffc0ef          	jal	80000d56 <myproc>
    80003eac:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003eae:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003eb2:	6985                	lui	s3,0x1
    80003eb4:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003eb6:	99ca                	add	s3,s3,s2
    80003eb8:	77fd                	lui	a5,0xfffff
    80003eba:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003ebe:	4691                	li	a3,4
    80003ec0:	6609                	lui	a2,0x2
    80003ec2:	964e                	add	a2,a2,s3
    80003ec4:	85ce                	mv	a1,s3
    80003ec6:	855a                	mv	a0,s6
    80003ec8:	8f3fc0ef          	jal	800007ba <uvmalloc>
    80003ecc:	892a                	mv	s2,a0
    80003ece:	e0a43423          	sd	a0,-504(s0)
    80003ed2:	e519                	bnez	a0,80003ee0 <exec+0x1e0>
  if(pagetable)
    80003ed4:	e1343423          	sd	s3,-504(s0)
    80003ed8:	4a01                	li	s4,0
    80003eda:	aab1                	j	80004036 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003edc:	4901                	li	s2,0
    80003ede:	b7c1                	j	80003e9e <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003ee0:	75f9                	lui	a1,0xffffe
    80003ee2:	95aa                	add	a1,a1,a0
    80003ee4:	855a                	mv	a0,s6
    80003ee6:	ab7fc0ef          	jal	8000099c <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003eea:	7bfd                	lui	s7,0xfffff
    80003eec:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003eee:	e0043783          	ld	a5,-512(s0)
    80003ef2:	6388                	ld	a0,0(a5)
    80003ef4:	cd39                	beqz	a0,80003f52 <exec+0x252>
    80003ef6:	e9040993          	addi	s3,s0,-368
    80003efa:	f9040c13          	addi	s8,s0,-112
    80003efe:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003f00:	ba4fc0ef          	jal	800002a4 <strlen>
    80003f04:	0015079b          	addiw	a5,a0,1
    80003f08:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003f0c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003f10:	11796e63          	bltu	s2,s7,8000402c <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003f14:	e0043d03          	ld	s10,-512(s0)
    80003f18:	000d3a03          	ld	s4,0(s10)
    80003f1c:	8552                	mv	a0,s4
    80003f1e:	b86fc0ef          	jal	800002a4 <strlen>
    80003f22:	0015069b          	addiw	a3,a0,1
    80003f26:	8652                	mv	a2,s4
    80003f28:	85ca                	mv	a1,s2
    80003f2a:	855a                	mv	a0,s6
    80003f2c:	a9bfc0ef          	jal	800009c6 <copyout>
    80003f30:	10054063          	bltz	a0,80004030 <exec+0x330>
    ustack[argc] = sp;
    80003f34:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003f38:	0485                	addi	s1,s1,1
    80003f3a:	008d0793          	addi	a5,s10,8
    80003f3e:	e0f43023          	sd	a5,-512(s0)
    80003f42:	008d3503          	ld	a0,8(s10)
    80003f46:	c909                	beqz	a0,80003f58 <exec+0x258>
    if(argc >= MAXARG)
    80003f48:	09a1                	addi	s3,s3,8
    80003f4a:	fb899be3          	bne	s3,s8,80003f00 <exec+0x200>
  ip = 0;
    80003f4e:	4a01                	li	s4,0
    80003f50:	a0dd                	j	80004036 <exec+0x336>
  sp = sz;
    80003f52:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003f56:	4481                	li	s1,0
  ustack[argc] = 0;
    80003f58:	00349793          	slli	a5,s1,0x3
    80003f5c:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb210>
    80003f60:	97a2                	add	a5,a5,s0
    80003f62:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003f66:	00148693          	addi	a3,s1,1
    80003f6a:	068e                	slli	a3,a3,0x3
    80003f6c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003f70:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003f74:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003f78:	f5796ee3          	bltu	s2,s7,80003ed4 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003f7c:	e9040613          	addi	a2,s0,-368
    80003f80:	85ca                	mv	a1,s2
    80003f82:	855a                	mv	a0,s6
    80003f84:	a43fc0ef          	jal	800009c6 <copyout>
    80003f88:	0e054263          	bltz	a0,8000406c <exec+0x36c>
  p->trapframe->a1 = sp;
    80003f8c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003f90:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003f94:	df843783          	ld	a5,-520(s0)
    80003f98:	0007c703          	lbu	a4,0(a5)
    80003f9c:	cf11                	beqz	a4,80003fb8 <exec+0x2b8>
    80003f9e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003fa0:	02f00693          	li	a3,47
    80003fa4:	a039                	j	80003fb2 <exec+0x2b2>
      last = s+1;
    80003fa6:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003faa:	0785                	addi	a5,a5,1
    80003fac:	fff7c703          	lbu	a4,-1(a5)
    80003fb0:	c701                	beqz	a4,80003fb8 <exec+0x2b8>
    if(*s == '/')
    80003fb2:	fed71ce3          	bne	a4,a3,80003faa <exec+0x2aa>
    80003fb6:	bfc5                	j	80003fa6 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003fb8:	4641                	li	a2,16
    80003fba:	df843583          	ld	a1,-520(s0)
    80003fbe:	158a8513          	addi	a0,s5,344
    80003fc2:	ab0fc0ef          	jal	80000272 <safestrcpy>
  oldpagetable = p->pagetable;
    80003fc6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003fca:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003fce:	e0843783          	ld	a5,-504(s0)
    80003fd2:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003fd6:	058ab783          	ld	a5,88(s5)
    80003fda:	e6843703          	ld	a4,-408(s0)
    80003fde:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003fe0:	058ab783          	ld	a5,88(s5)
    80003fe4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003fe8:	85e6                	mv	a1,s9
    80003fea:	e99fc0ef          	jal	80000e82 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003fee:	0004851b          	sext.w	a0,s1
    80003ff2:	79be                	ld	s3,488(sp)
    80003ff4:	7a1e                	ld	s4,480(sp)
    80003ff6:	6afe                	ld	s5,472(sp)
    80003ff8:	6b5e                	ld	s6,464(sp)
    80003ffa:	6bbe                	ld	s7,456(sp)
    80003ffc:	6c1e                	ld	s8,448(sp)
    80003ffe:	7cfa                	ld	s9,440(sp)
    80004000:	7d5a                	ld	s10,432(sp)
    80004002:	b3b5                	j	80003d6e <exec+0x6e>
    80004004:	e1243423          	sd	s2,-504(s0)
    80004008:	7dba                	ld	s11,424(sp)
    8000400a:	a035                	j	80004036 <exec+0x336>
    8000400c:	e1243423          	sd	s2,-504(s0)
    80004010:	7dba                	ld	s11,424(sp)
    80004012:	a015                	j	80004036 <exec+0x336>
    80004014:	e1243423          	sd	s2,-504(s0)
    80004018:	7dba                	ld	s11,424(sp)
    8000401a:	a831                	j	80004036 <exec+0x336>
    8000401c:	e1243423          	sd	s2,-504(s0)
    80004020:	7dba                	ld	s11,424(sp)
    80004022:	a811                	j	80004036 <exec+0x336>
    80004024:	e1243423          	sd	s2,-504(s0)
    80004028:	7dba                	ld	s11,424(sp)
    8000402a:	a031                	j	80004036 <exec+0x336>
  ip = 0;
    8000402c:	4a01                	li	s4,0
    8000402e:	a021                	j	80004036 <exec+0x336>
    80004030:	4a01                	li	s4,0
  if(pagetable)
    80004032:	a011                	j	80004036 <exec+0x336>
    80004034:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004036:	e0843583          	ld	a1,-504(s0)
    8000403a:	855a                	mv	a0,s6
    8000403c:	e47fc0ef          	jal	80000e82 <proc_freepagetable>
  return -1;
    80004040:	557d                	li	a0,-1
  if(ip){
    80004042:	000a1b63          	bnez	s4,80004058 <exec+0x358>
    80004046:	79be                	ld	s3,488(sp)
    80004048:	7a1e                	ld	s4,480(sp)
    8000404a:	6afe                	ld	s5,472(sp)
    8000404c:	6b5e                	ld	s6,464(sp)
    8000404e:	6bbe                	ld	s7,456(sp)
    80004050:	6c1e                	ld	s8,448(sp)
    80004052:	7cfa                	ld	s9,440(sp)
    80004054:	7d5a                	ld	s10,432(sp)
    80004056:	bb21                	j	80003d6e <exec+0x6e>
    80004058:	79be                	ld	s3,488(sp)
    8000405a:	6afe                	ld	s5,472(sp)
    8000405c:	6b5e                	ld	s6,464(sp)
    8000405e:	6bbe                	ld	s7,456(sp)
    80004060:	6c1e                	ld	s8,448(sp)
    80004062:	7cfa                	ld	s9,440(sp)
    80004064:	7d5a                	ld	s10,432(sp)
    80004066:	b9ed                	j	80003d60 <exec+0x60>
    80004068:	6b5e                	ld	s6,464(sp)
    8000406a:	b9dd                	j	80003d60 <exec+0x60>
  sz = sz1;
    8000406c:	e0843983          	ld	s3,-504(s0)
    80004070:	b595                	j	80003ed4 <exec+0x1d4>

0000000080004072 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004072:	7179                	addi	sp,sp,-48
    80004074:	f406                	sd	ra,40(sp)
    80004076:	f022                	sd	s0,32(sp)
    80004078:	ec26                	sd	s1,24(sp)
    8000407a:	e84a                	sd	s2,16(sp)
    8000407c:	1800                	addi	s0,sp,48
    8000407e:	892e                	mv	s2,a1
    80004080:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004082:	fdc40593          	addi	a1,s0,-36
    80004086:	bfdfd0ef          	jal	80001c82 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000408a:	fdc42703          	lw	a4,-36(s0)
    8000408e:	47bd                	li	a5,15
    80004090:	02e7e963          	bltu	a5,a4,800040c2 <argfd+0x50>
    80004094:	cc3fc0ef          	jal	80000d56 <myproc>
    80004098:	fdc42703          	lw	a4,-36(s0)
    8000409c:	01a70793          	addi	a5,a4,26
    800040a0:	078e                	slli	a5,a5,0x3
    800040a2:	953e                	add	a0,a0,a5
    800040a4:	611c                	ld	a5,0(a0)
    800040a6:	c385                	beqz	a5,800040c6 <argfd+0x54>
    return -1;
  if(pfd)
    800040a8:	00090463          	beqz	s2,800040b0 <argfd+0x3e>
    *pfd = fd;
    800040ac:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800040b0:	4501                	li	a0,0
  if(pf)
    800040b2:	c091                	beqz	s1,800040b6 <argfd+0x44>
    *pf = f;
    800040b4:	e09c                	sd	a5,0(s1)
}
    800040b6:	70a2                	ld	ra,40(sp)
    800040b8:	7402                	ld	s0,32(sp)
    800040ba:	64e2                	ld	s1,24(sp)
    800040bc:	6942                	ld	s2,16(sp)
    800040be:	6145                	addi	sp,sp,48
    800040c0:	8082                	ret
    return -1;
    800040c2:	557d                	li	a0,-1
    800040c4:	bfcd                	j	800040b6 <argfd+0x44>
    800040c6:	557d                	li	a0,-1
    800040c8:	b7fd                	j	800040b6 <argfd+0x44>

00000000800040ca <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800040ca:	1101                	addi	sp,sp,-32
    800040cc:	ec06                	sd	ra,24(sp)
    800040ce:	e822                	sd	s0,16(sp)
    800040d0:	e426                	sd	s1,8(sp)
    800040d2:	1000                	addi	s0,sp,32
    800040d4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800040d6:	c81fc0ef          	jal	80000d56 <myproc>
    800040da:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800040dc:	0d050793          	addi	a5,a0,208
    800040e0:	4501                	li	a0,0
    800040e2:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800040e4:	6398                	ld	a4,0(a5)
    800040e6:	cb19                	beqz	a4,800040fc <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    800040e8:	2505                	addiw	a0,a0,1
    800040ea:	07a1                	addi	a5,a5,8
    800040ec:	fed51ce3          	bne	a0,a3,800040e4 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800040f0:	557d                	li	a0,-1
}
    800040f2:	60e2                	ld	ra,24(sp)
    800040f4:	6442                	ld	s0,16(sp)
    800040f6:	64a2                	ld	s1,8(sp)
    800040f8:	6105                	addi	sp,sp,32
    800040fa:	8082                	ret
      p->ofile[fd] = f;
    800040fc:	01a50793          	addi	a5,a0,26
    80004100:	078e                	slli	a5,a5,0x3
    80004102:	963e                	add	a2,a2,a5
    80004104:	e204                	sd	s1,0(a2)
      return fd;
    80004106:	b7f5                	j	800040f2 <fdalloc+0x28>

0000000080004108 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004108:	715d                	addi	sp,sp,-80
    8000410a:	e486                	sd	ra,72(sp)
    8000410c:	e0a2                	sd	s0,64(sp)
    8000410e:	fc26                	sd	s1,56(sp)
    80004110:	f84a                	sd	s2,48(sp)
    80004112:	f44e                	sd	s3,40(sp)
    80004114:	ec56                	sd	s5,24(sp)
    80004116:	e85a                	sd	s6,16(sp)
    80004118:	0880                	addi	s0,sp,80
    8000411a:	8b2e                	mv	s6,a1
    8000411c:	89b2                	mv	s3,a2
    8000411e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004120:	fb040593          	addi	a1,s0,-80
    80004124:	822ff0ef          	jal	80003146 <nameiparent>
    80004128:	84aa                	mv	s1,a0
    8000412a:	10050a63          	beqz	a0,8000423e <create+0x136>
    return 0;

  ilock(dp);
    8000412e:	925fe0ef          	jal	80002a52 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004132:	4601                	li	a2,0
    80004134:	fb040593          	addi	a1,s0,-80
    80004138:	8526                	mv	a0,s1
    8000413a:	d8dfe0ef          	jal	80002ec6 <dirlookup>
    8000413e:	8aaa                	mv	s5,a0
    80004140:	c129                	beqz	a0,80004182 <create+0x7a>
    iunlockput(dp);
    80004142:	8526                	mv	a0,s1
    80004144:	b19fe0ef          	jal	80002c5c <iunlockput>
    ilock(ip);
    80004148:	8556                	mv	a0,s5
    8000414a:	909fe0ef          	jal	80002a52 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000414e:	4789                	li	a5,2
    80004150:	02fb1463          	bne	s6,a5,80004178 <create+0x70>
    80004154:	044ad783          	lhu	a5,68(s5)
    80004158:	37f9                	addiw	a5,a5,-2
    8000415a:	17c2                	slli	a5,a5,0x30
    8000415c:	93c1                	srli	a5,a5,0x30
    8000415e:	4705                	li	a4,1
    80004160:	00f76c63          	bltu	a4,a5,80004178 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004164:	8556                	mv	a0,s5
    80004166:	60a6                	ld	ra,72(sp)
    80004168:	6406                	ld	s0,64(sp)
    8000416a:	74e2                	ld	s1,56(sp)
    8000416c:	7942                	ld	s2,48(sp)
    8000416e:	79a2                	ld	s3,40(sp)
    80004170:	6ae2                	ld	s5,24(sp)
    80004172:	6b42                	ld	s6,16(sp)
    80004174:	6161                	addi	sp,sp,80
    80004176:	8082                	ret
    iunlockput(ip);
    80004178:	8556                	mv	a0,s5
    8000417a:	ae3fe0ef          	jal	80002c5c <iunlockput>
    return 0;
    8000417e:	4a81                	li	s5,0
    80004180:	b7d5                	j	80004164 <create+0x5c>
    80004182:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004184:	85da                	mv	a1,s6
    80004186:	4088                	lw	a0,0(s1)
    80004188:	f5afe0ef          	jal	800028e2 <ialloc>
    8000418c:	8a2a                	mv	s4,a0
    8000418e:	cd15                	beqz	a0,800041ca <create+0xc2>
  ilock(ip);
    80004190:	8c3fe0ef          	jal	80002a52 <ilock>
  ip->major = major;
    80004194:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004198:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000419c:	4905                	li	s2,1
    8000419e:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800041a2:	8552                	mv	a0,s4
    800041a4:	ffafe0ef          	jal	8000299e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800041a8:	032b0763          	beq	s6,s2,800041d6 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    800041ac:	004a2603          	lw	a2,4(s4)
    800041b0:	fb040593          	addi	a1,s0,-80
    800041b4:	8526                	mv	a0,s1
    800041b6:	eddfe0ef          	jal	80003092 <dirlink>
    800041ba:	06054563          	bltz	a0,80004224 <create+0x11c>
  iunlockput(dp);
    800041be:	8526                	mv	a0,s1
    800041c0:	a9dfe0ef          	jal	80002c5c <iunlockput>
  return ip;
    800041c4:	8ad2                	mv	s5,s4
    800041c6:	7a02                	ld	s4,32(sp)
    800041c8:	bf71                	j	80004164 <create+0x5c>
    iunlockput(dp);
    800041ca:	8526                	mv	a0,s1
    800041cc:	a91fe0ef          	jal	80002c5c <iunlockput>
    return 0;
    800041d0:	8ad2                	mv	s5,s4
    800041d2:	7a02                	ld	s4,32(sp)
    800041d4:	bf41                	j	80004164 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800041d6:	004a2603          	lw	a2,4(s4)
    800041da:	00003597          	auipc	a1,0x3
    800041de:	55658593          	addi	a1,a1,1366 # 80007730 <etext+0x730>
    800041e2:	8552                	mv	a0,s4
    800041e4:	eaffe0ef          	jal	80003092 <dirlink>
    800041e8:	02054e63          	bltz	a0,80004224 <create+0x11c>
    800041ec:	40d0                	lw	a2,4(s1)
    800041ee:	00003597          	auipc	a1,0x3
    800041f2:	54a58593          	addi	a1,a1,1354 # 80007738 <etext+0x738>
    800041f6:	8552                	mv	a0,s4
    800041f8:	e9bfe0ef          	jal	80003092 <dirlink>
    800041fc:	02054463          	bltz	a0,80004224 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004200:	004a2603          	lw	a2,4(s4)
    80004204:	fb040593          	addi	a1,s0,-80
    80004208:	8526                	mv	a0,s1
    8000420a:	e89fe0ef          	jal	80003092 <dirlink>
    8000420e:	00054b63          	bltz	a0,80004224 <create+0x11c>
    dp->nlink++;  // for ".."
    80004212:	04a4d783          	lhu	a5,74(s1)
    80004216:	2785                	addiw	a5,a5,1
    80004218:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000421c:	8526                	mv	a0,s1
    8000421e:	f80fe0ef          	jal	8000299e <iupdate>
    80004222:	bf71                	j	800041be <create+0xb6>
  ip->nlink = 0;
    80004224:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004228:	8552                	mv	a0,s4
    8000422a:	f74fe0ef          	jal	8000299e <iupdate>
  iunlockput(ip);
    8000422e:	8552                	mv	a0,s4
    80004230:	a2dfe0ef          	jal	80002c5c <iunlockput>
  iunlockput(dp);
    80004234:	8526                	mv	a0,s1
    80004236:	a27fe0ef          	jal	80002c5c <iunlockput>
  return 0;
    8000423a:	7a02                	ld	s4,32(sp)
    8000423c:	b725                	j	80004164 <create+0x5c>
    return 0;
    8000423e:	8aaa                	mv	s5,a0
    80004240:	b715                	j	80004164 <create+0x5c>

0000000080004242 <sys_dup>:
{
    80004242:	7179                	addi	sp,sp,-48
    80004244:	f406                	sd	ra,40(sp)
    80004246:	f022                	sd	s0,32(sp)
    80004248:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000424a:	fd840613          	addi	a2,s0,-40
    8000424e:	4581                	li	a1,0
    80004250:	4501                	li	a0,0
    80004252:	e21ff0ef          	jal	80004072 <argfd>
    return -1;
    80004256:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004258:	02054363          	bltz	a0,8000427e <sys_dup+0x3c>
    8000425c:	ec26                	sd	s1,24(sp)
    8000425e:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004260:	fd843903          	ld	s2,-40(s0)
    80004264:	854a                	mv	a0,s2
    80004266:	e65ff0ef          	jal	800040ca <fdalloc>
    8000426a:	84aa                	mv	s1,a0
    return -1;
    8000426c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000426e:	00054d63          	bltz	a0,80004288 <sys_dup+0x46>
  filedup(f);
    80004272:	854a                	mv	a0,s2
    80004274:	c48ff0ef          	jal	800036bc <filedup>
  return fd;
    80004278:	87a6                	mv	a5,s1
    8000427a:	64e2                	ld	s1,24(sp)
    8000427c:	6942                	ld	s2,16(sp)
}
    8000427e:	853e                	mv	a0,a5
    80004280:	70a2                	ld	ra,40(sp)
    80004282:	7402                	ld	s0,32(sp)
    80004284:	6145                	addi	sp,sp,48
    80004286:	8082                	ret
    80004288:	64e2                	ld	s1,24(sp)
    8000428a:	6942                	ld	s2,16(sp)
    8000428c:	bfcd                	j	8000427e <sys_dup+0x3c>

000000008000428e <sys_read>:
{
    8000428e:	7179                	addi	sp,sp,-48
    80004290:	f406                	sd	ra,40(sp)
    80004292:	f022                	sd	s0,32(sp)
    80004294:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004296:	fd840593          	addi	a1,s0,-40
    8000429a:	4505                	li	a0,1
    8000429c:	a61fd0ef          	jal	80001cfc <argaddr>
  argint(2, &n);
    800042a0:	fe440593          	addi	a1,s0,-28
    800042a4:	4509                	li	a0,2
    800042a6:	9ddfd0ef          	jal	80001c82 <argint>
  if(argfd(0, 0, &f) < 0)
    800042aa:	fe840613          	addi	a2,s0,-24
    800042ae:	4581                	li	a1,0
    800042b0:	4501                	li	a0,0
    800042b2:	dc1ff0ef          	jal	80004072 <argfd>
    800042b6:	87aa                	mv	a5,a0
    return -1;
    800042b8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800042ba:	0007ca63          	bltz	a5,800042ce <sys_read+0x40>
  return fileread(f, p, n);
    800042be:	fe442603          	lw	a2,-28(s0)
    800042c2:	fd843583          	ld	a1,-40(s0)
    800042c6:	fe843503          	ld	a0,-24(s0)
    800042ca:	d58ff0ef          	jal	80003822 <fileread>
}
    800042ce:	70a2                	ld	ra,40(sp)
    800042d0:	7402                	ld	s0,32(sp)
    800042d2:	6145                	addi	sp,sp,48
    800042d4:	8082                	ret

00000000800042d6 <sys_write>:
{
    800042d6:	7179                	addi	sp,sp,-48
    800042d8:	f406                	sd	ra,40(sp)
    800042da:	f022                	sd	s0,32(sp)
    800042dc:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800042de:	fd840593          	addi	a1,s0,-40
    800042e2:	4505                	li	a0,1
    800042e4:	a19fd0ef          	jal	80001cfc <argaddr>
  argint(2, &n);
    800042e8:	fe440593          	addi	a1,s0,-28
    800042ec:	4509                	li	a0,2
    800042ee:	995fd0ef          	jal	80001c82 <argint>
  if(argfd(0, 0, &f) < 0)
    800042f2:	fe840613          	addi	a2,s0,-24
    800042f6:	4581                	li	a1,0
    800042f8:	4501                	li	a0,0
    800042fa:	d79ff0ef          	jal	80004072 <argfd>
    800042fe:	87aa                	mv	a5,a0
    return -1;
    80004300:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004302:	0007ca63          	bltz	a5,80004316 <sys_write+0x40>
  return filewrite(f, p, n);
    80004306:	fe442603          	lw	a2,-28(s0)
    8000430a:	fd843583          	ld	a1,-40(s0)
    8000430e:	fe843503          	ld	a0,-24(s0)
    80004312:	dceff0ef          	jal	800038e0 <filewrite>
}
    80004316:	70a2                	ld	ra,40(sp)
    80004318:	7402                	ld	s0,32(sp)
    8000431a:	6145                	addi	sp,sp,48
    8000431c:	8082                	ret

000000008000431e <sys_close>:
{
    8000431e:	1101                	addi	sp,sp,-32
    80004320:	ec06                	sd	ra,24(sp)
    80004322:	e822                	sd	s0,16(sp)
    80004324:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004326:	fe040613          	addi	a2,s0,-32
    8000432a:	fec40593          	addi	a1,s0,-20
    8000432e:	4501                	li	a0,0
    80004330:	d43ff0ef          	jal	80004072 <argfd>
    return -1;
    80004334:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004336:	02054063          	bltz	a0,80004356 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000433a:	a1dfc0ef          	jal	80000d56 <myproc>
    8000433e:	fec42783          	lw	a5,-20(s0)
    80004342:	07e9                	addi	a5,a5,26
    80004344:	078e                	slli	a5,a5,0x3
    80004346:	953e                	add	a0,a0,a5
    80004348:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000434c:	fe043503          	ld	a0,-32(s0)
    80004350:	bb2ff0ef          	jal	80003702 <fileclose>
  return 0;
    80004354:	4781                	li	a5,0
}
    80004356:	853e                	mv	a0,a5
    80004358:	60e2                	ld	ra,24(sp)
    8000435a:	6442                	ld	s0,16(sp)
    8000435c:	6105                	addi	sp,sp,32
    8000435e:	8082                	ret

0000000080004360 <sys_fstat>:
{
    80004360:	1101                	addi	sp,sp,-32
    80004362:	ec06                	sd	ra,24(sp)
    80004364:	e822                	sd	s0,16(sp)
    80004366:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004368:	fe040593          	addi	a1,s0,-32
    8000436c:	4505                	li	a0,1
    8000436e:	98ffd0ef          	jal	80001cfc <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004372:	fe840613          	addi	a2,s0,-24
    80004376:	4581                	li	a1,0
    80004378:	4501                	li	a0,0
    8000437a:	cf9ff0ef          	jal	80004072 <argfd>
    8000437e:	87aa                	mv	a5,a0
    return -1;
    80004380:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004382:	0007c863          	bltz	a5,80004392 <sys_fstat+0x32>
  return filestat(f, st);
    80004386:	fe043583          	ld	a1,-32(s0)
    8000438a:	fe843503          	ld	a0,-24(s0)
    8000438e:	c36ff0ef          	jal	800037c4 <filestat>
}
    80004392:	60e2                	ld	ra,24(sp)
    80004394:	6442                	ld	s0,16(sp)
    80004396:	6105                	addi	sp,sp,32
    80004398:	8082                	ret

000000008000439a <sys_link>:
{
    8000439a:	7169                	addi	sp,sp,-304
    8000439c:	f606                	sd	ra,296(sp)
    8000439e:	f222                	sd	s0,288(sp)
    800043a0:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800043a2:	08000613          	li	a2,128
    800043a6:	ed040593          	addi	a1,s0,-304
    800043aa:	4501                	li	a0,0
    800043ac:	9e1fd0ef          	jal	80001d8c <argstr>
    return -1;
    800043b0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800043b2:	0c054e63          	bltz	a0,8000448e <sys_link+0xf4>
    800043b6:	08000613          	li	a2,128
    800043ba:	f5040593          	addi	a1,s0,-176
    800043be:	4505                	li	a0,1
    800043c0:	9cdfd0ef          	jal	80001d8c <argstr>
    return -1;
    800043c4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800043c6:	0c054463          	bltz	a0,8000448e <sys_link+0xf4>
    800043ca:	ee26                	sd	s1,280(sp)
  begin_op();
    800043cc:	f1dfe0ef          	jal	800032e8 <begin_op>
  if((ip = namei(old)) == 0){
    800043d0:	ed040513          	addi	a0,s0,-304
    800043d4:	d59fe0ef          	jal	8000312c <namei>
    800043d8:	84aa                	mv	s1,a0
    800043da:	c53d                	beqz	a0,80004448 <sys_link+0xae>
  ilock(ip);
    800043dc:	e76fe0ef          	jal	80002a52 <ilock>
  if(ip->type == T_DIR){
    800043e0:	04449703          	lh	a4,68(s1)
    800043e4:	4785                	li	a5,1
    800043e6:	06f70663          	beq	a4,a5,80004452 <sys_link+0xb8>
    800043ea:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800043ec:	04a4d783          	lhu	a5,74(s1)
    800043f0:	2785                	addiw	a5,a5,1
    800043f2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800043f6:	8526                	mv	a0,s1
    800043f8:	da6fe0ef          	jal	8000299e <iupdate>
  iunlock(ip);
    800043fc:	8526                	mv	a0,s1
    800043fe:	f02fe0ef          	jal	80002b00 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004402:	fd040593          	addi	a1,s0,-48
    80004406:	f5040513          	addi	a0,s0,-176
    8000440a:	d3dfe0ef          	jal	80003146 <nameiparent>
    8000440e:	892a                	mv	s2,a0
    80004410:	cd21                	beqz	a0,80004468 <sys_link+0xce>
  ilock(dp);
    80004412:	e40fe0ef          	jal	80002a52 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004416:	00092703          	lw	a4,0(s2)
    8000441a:	409c                	lw	a5,0(s1)
    8000441c:	04f71363          	bne	a4,a5,80004462 <sys_link+0xc8>
    80004420:	40d0                	lw	a2,4(s1)
    80004422:	fd040593          	addi	a1,s0,-48
    80004426:	854a                	mv	a0,s2
    80004428:	c6bfe0ef          	jal	80003092 <dirlink>
    8000442c:	02054b63          	bltz	a0,80004462 <sys_link+0xc8>
  iunlockput(dp);
    80004430:	854a                	mv	a0,s2
    80004432:	82bfe0ef          	jal	80002c5c <iunlockput>
  iput(ip);
    80004436:	8526                	mv	a0,s1
    80004438:	f9cfe0ef          	jal	80002bd4 <iput>
  end_op();
    8000443c:	f17fe0ef          	jal	80003352 <end_op>
  return 0;
    80004440:	4781                	li	a5,0
    80004442:	64f2                	ld	s1,280(sp)
    80004444:	6952                	ld	s2,272(sp)
    80004446:	a0a1                	j	8000448e <sys_link+0xf4>
    end_op();
    80004448:	f0bfe0ef          	jal	80003352 <end_op>
    return -1;
    8000444c:	57fd                	li	a5,-1
    8000444e:	64f2                	ld	s1,280(sp)
    80004450:	a83d                	j	8000448e <sys_link+0xf4>
    iunlockput(ip);
    80004452:	8526                	mv	a0,s1
    80004454:	809fe0ef          	jal	80002c5c <iunlockput>
    end_op();
    80004458:	efbfe0ef          	jal	80003352 <end_op>
    return -1;
    8000445c:	57fd                	li	a5,-1
    8000445e:	64f2                	ld	s1,280(sp)
    80004460:	a03d                	j	8000448e <sys_link+0xf4>
    iunlockput(dp);
    80004462:	854a                	mv	a0,s2
    80004464:	ff8fe0ef          	jal	80002c5c <iunlockput>
  ilock(ip);
    80004468:	8526                	mv	a0,s1
    8000446a:	de8fe0ef          	jal	80002a52 <ilock>
  ip->nlink--;
    8000446e:	04a4d783          	lhu	a5,74(s1)
    80004472:	37fd                	addiw	a5,a5,-1
    80004474:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004478:	8526                	mv	a0,s1
    8000447a:	d24fe0ef          	jal	8000299e <iupdate>
  iunlockput(ip);
    8000447e:	8526                	mv	a0,s1
    80004480:	fdcfe0ef          	jal	80002c5c <iunlockput>
  end_op();
    80004484:	ecffe0ef          	jal	80003352 <end_op>
  return -1;
    80004488:	57fd                	li	a5,-1
    8000448a:	64f2                	ld	s1,280(sp)
    8000448c:	6952                	ld	s2,272(sp)
}
    8000448e:	853e                	mv	a0,a5
    80004490:	70b2                	ld	ra,296(sp)
    80004492:	7412                	ld	s0,288(sp)
    80004494:	6155                	addi	sp,sp,304
    80004496:	8082                	ret

0000000080004498 <sys_unlink>:
{
    80004498:	7151                	addi	sp,sp,-240
    8000449a:	f586                	sd	ra,232(sp)
    8000449c:	f1a2                	sd	s0,224(sp)
    8000449e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800044a0:	08000613          	li	a2,128
    800044a4:	f3040593          	addi	a1,s0,-208
    800044a8:	4501                	li	a0,0
    800044aa:	8e3fd0ef          	jal	80001d8c <argstr>
    800044ae:	16054063          	bltz	a0,8000460e <sys_unlink+0x176>
    800044b2:	eda6                	sd	s1,216(sp)
  begin_op();
    800044b4:	e35fe0ef          	jal	800032e8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800044b8:	fb040593          	addi	a1,s0,-80
    800044bc:	f3040513          	addi	a0,s0,-208
    800044c0:	c87fe0ef          	jal	80003146 <nameiparent>
    800044c4:	84aa                	mv	s1,a0
    800044c6:	c945                	beqz	a0,80004576 <sys_unlink+0xde>
  ilock(dp);
    800044c8:	d8afe0ef          	jal	80002a52 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800044cc:	00003597          	auipc	a1,0x3
    800044d0:	26458593          	addi	a1,a1,612 # 80007730 <etext+0x730>
    800044d4:	fb040513          	addi	a0,s0,-80
    800044d8:	9d9fe0ef          	jal	80002eb0 <namecmp>
    800044dc:	10050e63          	beqz	a0,800045f8 <sys_unlink+0x160>
    800044e0:	00003597          	auipc	a1,0x3
    800044e4:	25858593          	addi	a1,a1,600 # 80007738 <etext+0x738>
    800044e8:	fb040513          	addi	a0,s0,-80
    800044ec:	9c5fe0ef          	jal	80002eb0 <namecmp>
    800044f0:	10050463          	beqz	a0,800045f8 <sys_unlink+0x160>
    800044f4:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800044f6:	f2c40613          	addi	a2,s0,-212
    800044fa:	fb040593          	addi	a1,s0,-80
    800044fe:	8526                	mv	a0,s1
    80004500:	9c7fe0ef          	jal	80002ec6 <dirlookup>
    80004504:	892a                	mv	s2,a0
    80004506:	0e050863          	beqz	a0,800045f6 <sys_unlink+0x15e>
  ilock(ip);
    8000450a:	d48fe0ef          	jal	80002a52 <ilock>
  if(ip->nlink < 1)
    8000450e:	04a91783          	lh	a5,74(s2)
    80004512:	06f05763          	blez	a5,80004580 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004516:	04491703          	lh	a4,68(s2)
    8000451a:	4785                	li	a5,1
    8000451c:	06f70963          	beq	a4,a5,8000458e <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004520:	4641                	li	a2,16
    80004522:	4581                	li	a1,0
    80004524:	fc040513          	addi	a0,s0,-64
    80004528:	c0dfb0ef          	jal	80000134 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000452c:	4741                	li	a4,16
    8000452e:	f2c42683          	lw	a3,-212(s0)
    80004532:	fc040613          	addi	a2,s0,-64
    80004536:	4581                	li	a1,0
    80004538:	8526                	mv	a0,s1
    8000453a:	869fe0ef          	jal	80002da2 <writei>
    8000453e:	47c1                	li	a5,16
    80004540:	08f51b63          	bne	a0,a5,800045d6 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004544:	04491703          	lh	a4,68(s2)
    80004548:	4785                	li	a5,1
    8000454a:	08f70d63          	beq	a4,a5,800045e4 <sys_unlink+0x14c>
  iunlockput(dp);
    8000454e:	8526                	mv	a0,s1
    80004550:	f0cfe0ef          	jal	80002c5c <iunlockput>
  ip->nlink--;
    80004554:	04a95783          	lhu	a5,74(s2)
    80004558:	37fd                	addiw	a5,a5,-1
    8000455a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000455e:	854a                	mv	a0,s2
    80004560:	c3efe0ef          	jal	8000299e <iupdate>
  iunlockput(ip);
    80004564:	854a                	mv	a0,s2
    80004566:	ef6fe0ef          	jal	80002c5c <iunlockput>
  end_op();
    8000456a:	de9fe0ef          	jal	80003352 <end_op>
  return 0;
    8000456e:	4501                	li	a0,0
    80004570:	64ee                	ld	s1,216(sp)
    80004572:	694e                	ld	s2,208(sp)
    80004574:	a849                	j	80004606 <sys_unlink+0x16e>
    end_op();
    80004576:	dddfe0ef          	jal	80003352 <end_op>
    return -1;
    8000457a:	557d                	li	a0,-1
    8000457c:	64ee                	ld	s1,216(sp)
    8000457e:	a061                	j	80004606 <sys_unlink+0x16e>
    80004580:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004582:	00003517          	auipc	a0,0x3
    80004586:	1be50513          	addi	a0,a0,446 # 80007740 <etext+0x740>
    8000458a:	278010ef          	jal	80005802 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000458e:	04c92703          	lw	a4,76(s2)
    80004592:	02000793          	li	a5,32
    80004596:	f8e7f5e3          	bgeu	a5,a4,80004520 <sys_unlink+0x88>
    8000459a:	e5ce                	sd	s3,200(sp)
    8000459c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800045a0:	4741                	li	a4,16
    800045a2:	86ce                	mv	a3,s3
    800045a4:	f1840613          	addi	a2,s0,-232
    800045a8:	4581                	li	a1,0
    800045aa:	854a                	mv	a0,s2
    800045ac:	efafe0ef          	jal	80002ca6 <readi>
    800045b0:	47c1                	li	a5,16
    800045b2:	00f51c63          	bne	a0,a5,800045ca <sys_unlink+0x132>
    if(de.inum != 0)
    800045b6:	f1845783          	lhu	a5,-232(s0)
    800045ba:	efa1                	bnez	a5,80004612 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800045bc:	29c1                	addiw	s3,s3,16
    800045be:	04c92783          	lw	a5,76(s2)
    800045c2:	fcf9efe3          	bltu	s3,a5,800045a0 <sys_unlink+0x108>
    800045c6:	69ae                	ld	s3,200(sp)
    800045c8:	bfa1                	j	80004520 <sys_unlink+0x88>
      panic("isdirempty: readi");
    800045ca:	00003517          	auipc	a0,0x3
    800045ce:	18e50513          	addi	a0,a0,398 # 80007758 <etext+0x758>
    800045d2:	230010ef          	jal	80005802 <panic>
    800045d6:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800045d8:	00003517          	auipc	a0,0x3
    800045dc:	19850513          	addi	a0,a0,408 # 80007770 <etext+0x770>
    800045e0:	222010ef          	jal	80005802 <panic>
    dp->nlink--;
    800045e4:	04a4d783          	lhu	a5,74(s1)
    800045e8:	37fd                	addiw	a5,a5,-1
    800045ea:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800045ee:	8526                	mv	a0,s1
    800045f0:	baefe0ef          	jal	8000299e <iupdate>
    800045f4:	bfa9                	j	8000454e <sys_unlink+0xb6>
    800045f6:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800045f8:	8526                	mv	a0,s1
    800045fa:	e62fe0ef          	jal	80002c5c <iunlockput>
  end_op();
    800045fe:	d55fe0ef          	jal	80003352 <end_op>
  return -1;
    80004602:	557d                	li	a0,-1
    80004604:	64ee                	ld	s1,216(sp)
}
    80004606:	70ae                	ld	ra,232(sp)
    80004608:	740e                	ld	s0,224(sp)
    8000460a:	616d                	addi	sp,sp,240
    8000460c:	8082                	ret
    return -1;
    8000460e:	557d                	li	a0,-1
    80004610:	bfdd                	j	80004606 <sys_unlink+0x16e>
    iunlockput(ip);
    80004612:	854a                	mv	a0,s2
    80004614:	e48fe0ef          	jal	80002c5c <iunlockput>
    goto bad;
    80004618:	694e                	ld	s2,208(sp)
    8000461a:	69ae                	ld	s3,200(sp)
    8000461c:	bff1                	j	800045f8 <sys_unlink+0x160>

000000008000461e <sys_open>:

uint64
sys_open(void)
{
    8000461e:	7131                	addi	sp,sp,-192
    80004620:	fd06                	sd	ra,184(sp)
    80004622:	f922                	sd	s0,176(sp)
    80004624:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004626:	f4c40593          	addi	a1,s0,-180
    8000462a:	4505                	li	a0,1
    8000462c:	e56fd0ef          	jal	80001c82 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004630:	08000613          	li	a2,128
    80004634:	f5040593          	addi	a1,s0,-176
    80004638:	4501                	li	a0,0
    8000463a:	f52fd0ef          	jal	80001d8c <argstr>
    8000463e:	87aa                	mv	a5,a0
    return -1;
    80004640:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004642:	0a07c263          	bltz	a5,800046e6 <sys_open+0xc8>
    80004646:	f526                	sd	s1,168(sp)

  begin_op();
    80004648:	ca1fe0ef          	jal	800032e8 <begin_op>

  if(omode & O_CREATE){
    8000464c:	f4c42783          	lw	a5,-180(s0)
    80004650:	2007f793          	andi	a5,a5,512
    80004654:	c3d5                	beqz	a5,800046f8 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004656:	4681                	li	a3,0
    80004658:	4601                	li	a2,0
    8000465a:	4589                	li	a1,2
    8000465c:	f5040513          	addi	a0,s0,-176
    80004660:	aa9ff0ef          	jal	80004108 <create>
    80004664:	84aa                	mv	s1,a0
    if(ip == 0){
    80004666:	c541                	beqz	a0,800046ee <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004668:	04449703          	lh	a4,68(s1)
    8000466c:	478d                	li	a5,3
    8000466e:	00f71763          	bne	a4,a5,8000467c <sys_open+0x5e>
    80004672:	0464d703          	lhu	a4,70(s1)
    80004676:	47a5                	li	a5,9
    80004678:	0ae7ed63          	bltu	a5,a4,80004732 <sys_open+0x114>
    8000467c:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000467e:	fe1fe0ef          	jal	8000365e <filealloc>
    80004682:	892a                	mv	s2,a0
    80004684:	c179                	beqz	a0,8000474a <sys_open+0x12c>
    80004686:	ed4e                	sd	s3,152(sp)
    80004688:	a43ff0ef          	jal	800040ca <fdalloc>
    8000468c:	89aa                	mv	s3,a0
    8000468e:	0a054a63          	bltz	a0,80004742 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004692:	04449703          	lh	a4,68(s1)
    80004696:	478d                	li	a5,3
    80004698:	0cf70263          	beq	a4,a5,8000475c <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000469c:	4789                	li	a5,2
    8000469e:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800046a2:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800046a6:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800046aa:	f4c42783          	lw	a5,-180(s0)
    800046ae:	0017c713          	xori	a4,a5,1
    800046b2:	8b05                	andi	a4,a4,1
    800046b4:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800046b8:	0037f713          	andi	a4,a5,3
    800046bc:	00e03733          	snez	a4,a4
    800046c0:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800046c4:	4007f793          	andi	a5,a5,1024
    800046c8:	c791                	beqz	a5,800046d4 <sys_open+0xb6>
    800046ca:	04449703          	lh	a4,68(s1)
    800046ce:	4789                	li	a5,2
    800046d0:	08f70d63          	beq	a4,a5,8000476a <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800046d4:	8526                	mv	a0,s1
    800046d6:	c2afe0ef          	jal	80002b00 <iunlock>
  end_op();
    800046da:	c79fe0ef          	jal	80003352 <end_op>

  return fd;
    800046de:	854e                	mv	a0,s3
    800046e0:	74aa                	ld	s1,168(sp)
    800046e2:	790a                	ld	s2,160(sp)
    800046e4:	69ea                	ld	s3,152(sp)
}
    800046e6:	70ea                	ld	ra,184(sp)
    800046e8:	744a                	ld	s0,176(sp)
    800046ea:	6129                	addi	sp,sp,192
    800046ec:	8082                	ret
      end_op();
    800046ee:	c65fe0ef          	jal	80003352 <end_op>
      return -1;
    800046f2:	557d                	li	a0,-1
    800046f4:	74aa                	ld	s1,168(sp)
    800046f6:	bfc5                	j	800046e6 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800046f8:	f5040513          	addi	a0,s0,-176
    800046fc:	a31fe0ef          	jal	8000312c <namei>
    80004700:	84aa                	mv	s1,a0
    80004702:	c11d                	beqz	a0,80004728 <sys_open+0x10a>
    ilock(ip);
    80004704:	b4efe0ef          	jal	80002a52 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004708:	04449703          	lh	a4,68(s1)
    8000470c:	4785                	li	a5,1
    8000470e:	f4f71de3          	bne	a4,a5,80004668 <sys_open+0x4a>
    80004712:	f4c42783          	lw	a5,-180(s0)
    80004716:	d3bd                	beqz	a5,8000467c <sys_open+0x5e>
      iunlockput(ip);
    80004718:	8526                	mv	a0,s1
    8000471a:	d42fe0ef          	jal	80002c5c <iunlockput>
      end_op();
    8000471e:	c35fe0ef          	jal	80003352 <end_op>
      return -1;
    80004722:	557d                	li	a0,-1
    80004724:	74aa                	ld	s1,168(sp)
    80004726:	b7c1                	j	800046e6 <sys_open+0xc8>
      end_op();
    80004728:	c2bfe0ef          	jal	80003352 <end_op>
      return -1;
    8000472c:	557d                	li	a0,-1
    8000472e:	74aa                	ld	s1,168(sp)
    80004730:	bf5d                	j	800046e6 <sys_open+0xc8>
    iunlockput(ip);
    80004732:	8526                	mv	a0,s1
    80004734:	d28fe0ef          	jal	80002c5c <iunlockput>
    end_op();
    80004738:	c1bfe0ef          	jal	80003352 <end_op>
    return -1;
    8000473c:	557d                	li	a0,-1
    8000473e:	74aa                	ld	s1,168(sp)
    80004740:	b75d                	j	800046e6 <sys_open+0xc8>
      fileclose(f);
    80004742:	854a                	mv	a0,s2
    80004744:	fbffe0ef          	jal	80003702 <fileclose>
    80004748:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000474a:	8526                	mv	a0,s1
    8000474c:	d10fe0ef          	jal	80002c5c <iunlockput>
    end_op();
    80004750:	c03fe0ef          	jal	80003352 <end_op>
    return -1;
    80004754:	557d                	li	a0,-1
    80004756:	74aa                	ld	s1,168(sp)
    80004758:	790a                	ld	s2,160(sp)
    8000475a:	b771                	j	800046e6 <sys_open+0xc8>
    f->type = FD_DEVICE;
    8000475c:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004760:	04649783          	lh	a5,70(s1)
    80004764:	02f91223          	sh	a5,36(s2)
    80004768:	bf3d                	j	800046a6 <sys_open+0x88>
    itrunc(ip);
    8000476a:	8526                	mv	a0,s1
    8000476c:	bd4fe0ef          	jal	80002b40 <itrunc>
    80004770:	b795                	j	800046d4 <sys_open+0xb6>

0000000080004772 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004772:	7175                	addi	sp,sp,-144
    80004774:	e506                	sd	ra,136(sp)
    80004776:	e122                	sd	s0,128(sp)
    80004778:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000477a:	b6ffe0ef          	jal	800032e8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000477e:	08000613          	li	a2,128
    80004782:	f7040593          	addi	a1,s0,-144
    80004786:	4501                	li	a0,0
    80004788:	e04fd0ef          	jal	80001d8c <argstr>
    8000478c:	02054363          	bltz	a0,800047b2 <sys_mkdir+0x40>
    80004790:	4681                	li	a3,0
    80004792:	4601                	li	a2,0
    80004794:	4585                	li	a1,1
    80004796:	f7040513          	addi	a0,s0,-144
    8000479a:	96fff0ef          	jal	80004108 <create>
    8000479e:	c911                	beqz	a0,800047b2 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800047a0:	cbcfe0ef          	jal	80002c5c <iunlockput>
  end_op();
    800047a4:	baffe0ef          	jal	80003352 <end_op>
  return 0;
    800047a8:	4501                	li	a0,0
}
    800047aa:	60aa                	ld	ra,136(sp)
    800047ac:	640a                	ld	s0,128(sp)
    800047ae:	6149                	addi	sp,sp,144
    800047b0:	8082                	ret
    end_op();
    800047b2:	ba1fe0ef          	jal	80003352 <end_op>
    return -1;
    800047b6:	557d                	li	a0,-1
    800047b8:	bfcd                	j	800047aa <sys_mkdir+0x38>

00000000800047ba <sys_mknod>:

uint64
sys_mknod(void)
{
    800047ba:	7135                	addi	sp,sp,-160
    800047bc:	ed06                	sd	ra,152(sp)
    800047be:	e922                	sd	s0,144(sp)
    800047c0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800047c2:	b27fe0ef          	jal	800032e8 <begin_op>
  argint(1, &major);
    800047c6:	f6c40593          	addi	a1,s0,-148
    800047ca:	4505                	li	a0,1
    800047cc:	cb6fd0ef          	jal	80001c82 <argint>
  argint(2, &minor);
    800047d0:	f6840593          	addi	a1,s0,-152
    800047d4:	4509                	li	a0,2
    800047d6:	cacfd0ef          	jal	80001c82 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800047da:	08000613          	li	a2,128
    800047de:	f7040593          	addi	a1,s0,-144
    800047e2:	4501                	li	a0,0
    800047e4:	da8fd0ef          	jal	80001d8c <argstr>
    800047e8:	02054563          	bltz	a0,80004812 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800047ec:	f6841683          	lh	a3,-152(s0)
    800047f0:	f6c41603          	lh	a2,-148(s0)
    800047f4:	458d                	li	a1,3
    800047f6:	f7040513          	addi	a0,s0,-144
    800047fa:	90fff0ef          	jal	80004108 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800047fe:	c911                	beqz	a0,80004812 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004800:	c5cfe0ef          	jal	80002c5c <iunlockput>
  end_op();
    80004804:	b4ffe0ef          	jal	80003352 <end_op>
  return 0;
    80004808:	4501                	li	a0,0
}
    8000480a:	60ea                	ld	ra,152(sp)
    8000480c:	644a                	ld	s0,144(sp)
    8000480e:	610d                	addi	sp,sp,160
    80004810:	8082                	ret
    end_op();
    80004812:	b41fe0ef          	jal	80003352 <end_op>
    return -1;
    80004816:	557d                	li	a0,-1
    80004818:	bfcd                	j	8000480a <sys_mknod+0x50>

000000008000481a <sys_chdir>:

uint64
sys_chdir(void)
{
    8000481a:	7135                	addi	sp,sp,-160
    8000481c:	ed06                	sd	ra,152(sp)
    8000481e:	e922                	sd	s0,144(sp)
    80004820:	e14a                	sd	s2,128(sp)
    80004822:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004824:	d32fc0ef          	jal	80000d56 <myproc>
    80004828:	892a                	mv	s2,a0
  
  begin_op();
    8000482a:	abffe0ef          	jal	800032e8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000482e:	08000613          	li	a2,128
    80004832:	f6040593          	addi	a1,s0,-160
    80004836:	4501                	li	a0,0
    80004838:	d54fd0ef          	jal	80001d8c <argstr>
    8000483c:	04054363          	bltz	a0,80004882 <sys_chdir+0x68>
    80004840:	e526                	sd	s1,136(sp)
    80004842:	f6040513          	addi	a0,s0,-160
    80004846:	8e7fe0ef          	jal	8000312c <namei>
    8000484a:	84aa                	mv	s1,a0
    8000484c:	c915                	beqz	a0,80004880 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    8000484e:	a04fe0ef          	jal	80002a52 <ilock>
  if(ip->type != T_DIR){
    80004852:	04449703          	lh	a4,68(s1)
    80004856:	4785                	li	a5,1
    80004858:	02f71963          	bne	a4,a5,8000488a <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000485c:	8526                	mv	a0,s1
    8000485e:	aa2fe0ef          	jal	80002b00 <iunlock>
  iput(p->cwd);
    80004862:	15093503          	ld	a0,336(s2)
    80004866:	b6efe0ef          	jal	80002bd4 <iput>
  end_op();
    8000486a:	ae9fe0ef          	jal	80003352 <end_op>
  p->cwd = ip;
    8000486e:	14993823          	sd	s1,336(s2)
  return 0;
    80004872:	4501                	li	a0,0
    80004874:	64aa                	ld	s1,136(sp)
}
    80004876:	60ea                	ld	ra,152(sp)
    80004878:	644a                	ld	s0,144(sp)
    8000487a:	690a                	ld	s2,128(sp)
    8000487c:	610d                	addi	sp,sp,160
    8000487e:	8082                	ret
    80004880:	64aa                	ld	s1,136(sp)
    end_op();
    80004882:	ad1fe0ef          	jal	80003352 <end_op>
    return -1;
    80004886:	557d                	li	a0,-1
    80004888:	b7fd                	j	80004876 <sys_chdir+0x5c>
    iunlockput(ip);
    8000488a:	8526                	mv	a0,s1
    8000488c:	bd0fe0ef          	jal	80002c5c <iunlockput>
    end_op();
    80004890:	ac3fe0ef          	jal	80003352 <end_op>
    return -1;
    80004894:	557d                	li	a0,-1
    80004896:	64aa                	ld	s1,136(sp)
    80004898:	bff9                	j	80004876 <sys_chdir+0x5c>

000000008000489a <sys_exec>:

uint64
sys_exec(void)
{
    8000489a:	7121                	addi	sp,sp,-448
    8000489c:	ff06                	sd	ra,440(sp)
    8000489e:	fb22                	sd	s0,432(sp)
    800048a0:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800048a2:	e4840593          	addi	a1,s0,-440
    800048a6:	4505                	li	a0,1
    800048a8:	c54fd0ef          	jal	80001cfc <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800048ac:	08000613          	li	a2,128
    800048b0:	f5040593          	addi	a1,s0,-176
    800048b4:	4501                	li	a0,0
    800048b6:	cd6fd0ef          	jal	80001d8c <argstr>
    800048ba:	87aa                	mv	a5,a0
    return -1;
    800048bc:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800048be:	0c07c463          	bltz	a5,80004986 <sys_exec+0xec>
    800048c2:	f726                	sd	s1,424(sp)
    800048c4:	f34a                	sd	s2,416(sp)
    800048c6:	ef4e                	sd	s3,408(sp)
    800048c8:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800048ca:	10000613          	li	a2,256
    800048ce:	4581                	li	a1,0
    800048d0:	e5040513          	addi	a0,s0,-432
    800048d4:	861fb0ef          	jal	80000134 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800048d8:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800048dc:	89a6                	mv	s3,s1
    800048de:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800048e0:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800048e4:	00391513          	slli	a0,s2,0x3
    800048e8:	e4040593          	addi	a1,s0,-448
    800048ec:	e4843783          	ld	a5,-440(s0)
    800048f0:	953e                	add	a0,a0,a5
    800048f2:	b06fd0ef          	jal	80001bf8 <fetchaddr>
    800048f6:	02054663          	bltz	a0,80004922 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800048fa:	e4043783          	ld	a5,-448(s0)
    800048fe:	c3a9                	beqz	a5,80004940 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004900:	ff6fb0ef          	jal	800000f6 <kalloc>
    80004904:	85aa                	mv	a1,a0
    80004906:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000490a:	cd01                	beqz	a0,80004922 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000490c:	6605                	lui	a2,0x1
    8000490e:	e4043503          	ld	a0,-448(s0)
    80004912:	b30fd0ef          	jal	80001c42 <fetchstr>
    80004916:	00054663          	bltz	a0,80004922 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    8000491a:	0905                	addi	s2,s2,1
    8000491c:	09a1                	addi	s3,s3,8
    8000491e:	fd4913e3          	bne	s2,s4,800048e4 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004922:	f5040913          	addi	s2,s0,-176
    80004926:	6088                	ld	a0,0(s1)
    80004928:	c931                	beqz	a0,8000497c <sys_exec+0xe2>
    kfree(argv[i]);
    8000492a:	ef2fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000492e:	04a1                	addi	s1,s1,8
    80004930:	ff249be3          	bne	s1,s2,80004926 <sys_exec+0x8c>
  return -1;
    80004934:	557d                	li	a0,-1
    80004936:	74ba                	ld	s1,424(sp)
    80004938:	791a                	ld	s2,416(sp)
    8000493a:	69fa                	ld	s3,408(sp)
    8000493c:	6a5a                	ld	s4,400(sp)
    8000493e:	a0a1                	j	80004986 <sys_exec+0xec>
      argv[i] = 0;
    80004940:	0009079b          	sext.w	a5,s2
    80004944:	078e                	slli	a5,a5,0x3
    80004946:	fd078793          	addi	a5,a5,-48
    8000494a:	97a2                	add	a5,a5,s0
    8000494c:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004950:	e5040593          	addi	a1,s0,-432
    80004954:	f5040513          	addi	a0,s0,-176
    80004958:	ba8ff0ef          	jal	80003d00 <exec>
    8000495c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000495e:	f5040993          	addi	s3,s0,-176
    80004962:	6088                	ld	a0,0(s1)
    80004964:	c511                	beqz	a0,80004970 <sys_exec+0xd6>
    kfree(argv[i]);
    80004966:	eb6fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000496a:	04a1                	addi	s1,s1,8
    8000496c:	ff349be3          	bne	s1,s3,80004962 <sys_exec+0xc8>
  return ret;
    80004970:	854a                	mv	a0,s2
    80004972:	74ba                	ld	s1,424(sp)
    80004974:	791a                	ld	s2,416(sp)
    80004976:	69fa                	ld	s3,408(sp)
    80004978:	6a5a                	ld	s4,400(sp)
    8000497a:	a031                	j	80004986 <sys_exec+0xec>
  return -1;
    8000497c:	557d                	li	a0,-1
    8000497e:	74ba                	ld	s1,424(sp)
    80004980:	791a                	ld	s2,416(sp)
    80004982:	69fa                	ld	s3,408(sp)
    80004984:	6a5a                	ld	s4,400(sp)
}
    80004986:	70fa                	ld	ra,440(sp)
    80004988:	745a                	ld	s0,432(sp)
    8000498a:	6139                	addi	sp,sp,448
    8000498c:	8082                	ret

000000008000498e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000498e:	7139                	addi	sp,sp,-64
    80004990:	fc06                	sd	ra,56(sp)
    80004992:	f822                	sd	s0,48(sp)
    80004994:	f426                	sd	s1,40(sp)
    80004996:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004998:	bbefc0ef          	jal	80000d56 <myproc>
    8000499c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000499e:	fd840593          	addi	a1,s0,-40
    800049a2:	4501                	li	a0,0
    800049a4:	b58fd0ef          	jal	80001cfc <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800049a8:	fc840593          	addi	a1,s0,-56
    800049ac:	fd040513          	addi	a0,s0,-48
    800049b0:	85cff0ef          	jal	80003a0c <pipealloc>
    return -1;
    800049b4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800049b6:	0a054463          	bltz	a0,80004a5e <sys_pipe+0xd0>
  fd0 = -1;
    800049ba:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800049be:	fd043503          	ld	a0,-48(s0)
    800049c2:	f08ff0ef          	jal	800040ca <fdalloc>
    800049c6:	fca42223          	sw	a0,-60(s0)
    800049ca:	08054163          	bltz	a0,80004a4c <sys_pipe+0xbe>
    800049ce:	fc843503          	ld	a0,-56(s0)
    800049d2:	ef8ff0ef          	jal	800040ca <fdalloc>
    800049d6:	fca42023          	sw	a0,-64(s0)
    800049da:	06054063          	bltz	a0,80004a3a <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800049de:	4691                	li	a3,4
    800049e0:	fc440613          	addi	a2,s0,-60
    800049e4:	fd843583          	ld	a1,-40(s0)
    800049e8:	68a8                	ld	a0,80(s1)
    800049ea:	fddfb0ef          	jal	800009c6 <copyout>
    800049ee:	00054e63          	bltz	a0,80004a0a <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800049f2:	4691                	li	a3,4
    800049f4:	fc040613          	addi	a2,s0,-64
    800049f8:	fd843583          	ld	a1,-40(s0)
    800049fc:	0591                	addi	a1,a1,4
    800049fe:	68a8                	ld	a0,80(s1)
    80004a00:	fc7fb0ef          	jal	800009c6 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004a04:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004a06:	04055c63          	bgez	a0,80004a5e <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004a0a:	fc442783          	lw	a5,-60(s0)
    80004a0e:	07e9                	addi	a5,a5,26
    80004a10:	078e                	slli	a5,a5,0x3
    80004a12:	97a6                	add	a5,a5,s1
    80004a14:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004a18:	fc042783          	lw	a5,-64(s0)
    80004a1c:	07e9                	addi	a5,a5,26
    80004a1e:	078e                	slli	a5,a5,0x3
    80004a20:	94be                	add	s1,s1,a5
    80004a22:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004a26:	fd043503          	ld	a0,-48(s0)
    80004a2a:	cd9fe0ef          	jal	80003702 <fileclose>
    fileclose(wf);
    80004a2e:	fc843503          	ld	a0,-56(s0)
    80004a32:	cd1fe0ef          	jal	80003702 <fileclose>
    return -1;
    80004a36:	57fd                	li	a5,-1
    80004a38:	a01d                	j	80004a5e <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004a3a:	fc442783          	lw	a5,-60(s0)
    80004a3e:	0007c763          	bltz	a5,80004a4c <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004a42:	07e9                	addi	a5,a5,26
    80004a44:	078e                	slli	a5,a5,0x3
    80004a46:	97a6                	add	a5,a5,s1
    80004a48:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004a4c:	fd043503          	ld	a0,-48(s0)
    80004a50:	cb3fe0ef          	jal	80003702 <fileclose>
    fileclose(wf);
    80004a54:	fc843503          	ld	a0,-56(s0)
    80004a58:	cabfe0ef          	jal	80003702 <fileclose>
    return -1;
    80004a5c:	57fd                	li	a5,-1
}
    80004a5e:	853e                	mv	a0,a5
    80004a60:	70e2                	ld	ra,56(sp)
    80004a62:	7442                	ld	s0,48(sp)
    80004a64:	74a2                	ld	s1,40(sp)
    80004a66:	6121                	addi	sp,sp,64
    80004a68:	8082                	ret
    80004a6a:	0000                	unimp
    80004a6c:	0000                	unimp
	...

0000000080004a70 <kernelvec>:
    80004a70:	7111                	addi	sp,sp,-256
    80004a72:	e006                	sd	ra,0(sp)
    80004a74:	e40a                	sd	sp,8(sp)
    80004a76:	e80e                	sd	gp,16(sp)
    80004a78:	ec12                	sd	tp,24(sp)
    80004a7a:	f016                	sd	t0,32(sp)
    80004a7c:	f41a                	sd	t1,40(sp)
    80004a7e:	f81e                	sd	t2,48(sp)
    80004a80:	e4aa                	sd	a0,72(sp)
    80004a82:	e8ae                	sd	a1,80(sp)
    80004a84:	ecb2                	sd	a2,88(sp)
    80004a86:	f0b6                	sd	a3,96(sp)
    80004a88:	f4ba                	sd	a4,104(sp)
    80004a8a:	f8be                	sd	a5,112(sp)
    80004a8c:	fcc2                	sd	a6,120(sp)
    80004a8e:	e146                	sd	a7,128(sp)
    80004a90:	edf2                	sd	t3,216(sp)
    80004a92:	f1f6                	sd	t4,224(sp)
    80004a94:	f5fa                	sd	t5,232(sp)
    80004a96:	f9fe                	sd	t6,240(sp)
    80004a98:	804fd0ef          	jal	80001a9c <kerneltrap>
    80004a9c:	6082                	ld	ra,0(sp)
    80004a9e:	6122                	ld	sp,8(sp)
    80004aa0:	61c2                	ld	gp,16(sp)
    80004aa2:	7282                	ld	t0,32(sp)
    80004aa4:	7322                	ld	t1,40(sp)
    80004aa6:	73c2                	ld	t2,48(sp)
    80004aa8:	6526                	ld	a0,72(sp)
    80004aaa:	65c6                	ld	a1,80(sp)
    80004aac:	6666                	ld	a2,88(sp)
    80004aae:	7686                	ld	a3,96(sp)
    80004ab0:	7726                	ld	a4,104(sp)
    80004ab2:	77c6                	ld	a5,112(sp)
    80004ab4:	7866                	ld	a6,120(sp)
    80004ab6:	688a                	ld	a7,128(sp)
    80004ab8:	6e6e                	ld	t3,216(sp)
    80004aba:	7e8e                	ld	t4,224(sp)
    80004abc:	7f2e                	ld	t5,232(sp)
    80004abe:	7fce                	ld	t6,240(sp)
    80004ac0:	6111                	addi	sp,sp,256
    80004ac2:	10200073          	sret
	...

0000000080004ace <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80004ace:	1141                	addi	sp,sp,-16
    80004ad0:	e422                	sd	s0,8(sp)
    80004ad2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004ad4:	0c0007b7          	lui	a5,0xc000
    80004ad8:	4705                	li	a4,1
    80004ada:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80004adc:	0c0007b7          	lui	a5,0xc000
    80004ae0:	c3d8                	sw	a4,4(a5)
}
    80004ae2:	6422                	ld	s0,8(sp)
    80004ae4:	0141                	addi	sp,sp,16
    80004ae6:	8082                	ret

0000000080004ae8 <plicinithart>:

void
plicinithart(void)
{
    80004ae8:	1141                	addi	sp,sp,-16
    80004aea:	e406                	sd	ra,8(sp)
    80004aec:	e022                	sd	s0,0(sp)
    80004aee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004af0:	a3afc0ef          	jal	80000d2a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004af4:	0085171b          	slliw	a4,a0,0x8
    80004af8:	0c0027b7          	lui	a5,0xc002
    80004afc:	97ba                	add	a5,a5,a4
    80004afe:	40200713          	li	a4,1026
    80004b02:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004b06:	00d5151b          	slliw	a0,a0,0xd
    80004b0a:	0c2017b7          	lui	a5,0xc201
    80004b0e:	97aa                	add	a5,a5,a0
    80004b10:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004b14:	60a2                	ld	ra,8(sp)
    80004b16:	6402                	ld	s0,0(sp)
    80004b18:	0141                	addi	sp,sp,16
    80004b1a:	8082                	ret

0000000080004b1c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004b1c:	1141                	addi	sp,sp,-16
    80004b1e:	e406                	sd	ra,8(sp)
    80004b20:	e022                	sd	s0,0(sp)
    80004b22:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004b24:	a06fc0ef          	jal	80000d2a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004b28:	00d5151b          	slliw	a0,a0,0xd
    80004b2c:	0c2017b7          	lui	a5,0xc201
    80004b30:	97aa                	add	a5,a5,a0
  return irq;
}
    80004b32:	43c8                	lw	a0,4(a5)
    80004b34:	60a2                	ld	ra,8(sp)
    80004b36:	6402                	ld	s0,0(sp)
    80004b38:	0141                	addi	sp,sp,16
    80004b3a:	8082                	ret

0000000080004b3c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004b3c:	1101                	addi	sp,sp,-32
    80004b3e:	ec06                	sd	ra,24(sp)
    80004b40:	e822                	sd	s0,16(sp)
    80004b42:	e426                	sd	s1,8(sp)
    80004b44:	1000                	addi	s0,sp,32
    80004b46:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004b48:	9e2fc0ef          	jal	80000d2a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004b4c:	00d5151b          	slliw	a0,a0,0xd
    80004b50:	0c2017b7          	lui	a5,0xc201
    80004b54:	97aa                	add	a5,a5,a0
    80004b56:	c3c4                	sw	s1,4(a5)
}
    80004b58:	60e2                	ld	ra,24(sp)
    80004b5a:	6442                	ld	s0,16(sp)
    80004b5c:	64a2                	ld	s1,8(sp)
    80004b5e:	6105                	addi	sp,sp,32
    80004b60:	8082                	ret

0000000080004b62 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004b62:	1141                	addi	sp,sp,-16
    80004b64:	e406                	sd	ra,8(sp)
    80004b66:	e022                	sd	s0,0(sp)
    80004b68:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004b6a:	479d                	li	a5,7
    80004b6c:	04a7ca63          	blt	a5,a0,80004bc0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004b70:	00017797          	auipc	a5,0x17
    80004b74:	fd078793          	addi	a5,a5,-48 # 8001bb40 <disk>
    80004b78:	97aa                	add	a5,a5,a0
    80004b7a:	0187c783          	lbu	a5,24(a5)
    80004b7e:	e7b9                	bnez	a5,80004bcc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004b80:	00451693          	slli	a3,a0,0x4
    80004b84:	00017797          	auipc	a5,0x17
    80004b88:	fbc78793          	addi	a5,a5,-68 # 8001bb40 <disk>
    80004b8c:	6398                	ld	a4,0(a5)
    80004b8e:	9736                	add	a4,a4,a3
    80004b90:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004b94:	6398                	ld	a4,0(a5)
    80004b96:	9736                	add	a4,a4,a3
    80004b98:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004b9c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004ba0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004ba4:	97aa                	add	a5,a5,a0
    80004ba6:	4705                	li	a4,1
    80004ba8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004bac:	00017517          	auipc	a0,0x17
    80004bb0:	fac50513          	addi	a0,a0,-84 # 8001bb58 <disk+0x18>
    80004bb4:	fc8fc0ef          	jal	8000137c <wakeup>
}
    80004bb8:	60a2                	ld	ra,8(sp)
    80004bba:	6402                	ld	s0,0(sp)
    80004bbc:	0141                	addi	sp,sp,16
    80004bbe:	8082                	ret
    panic("free_desc 1");
    80004bc0:	00003517          	auipc	a0,0x3
    80004bc4:	bc050513          	addi	a0,a0,-1088 # 80007780 <etext+0x780>
    80004bc8:	43b000ef          	jal	80005802 <panic>
    panic("free_desc 2");
    80004bcc:	00003517          	auipc	a0,0x3
    80004bd0:	bc450513          	addi	a0,a0,-1084 # 80007790 <etext+0x790>
    80004bd4:	42f000ef          	jal	80005802 <panic>

0000000080004bd8 <virtio_disk_init>:
{
    80004bd8:	1101                	addi	sp,sp,-32
    80004bda:	ec06                	sd	ra,24(sp)
    80004bdc:	e822                	sd	s0,16(sp)
    80004bde:	e426                	sd	s1,8(sp)
    80004be0:	e04a                	sd	s2,0(sp)
    80004be2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004be4:	00003597          	auipc	a1,0x3
    80004be8:	bbc58593          	addi	a1,a1,-1092 # 800077a0 <etext+0x7a0>
    80004bec:	00017517          	auipc	a0,0x17
    80004bf0:	07c50513          	addi	a0,a0,124 # 8001bc68 <disk+0x128>
    80004bf4:	6bd000ef          	jal	80005ab0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004bf8:	100017b7          	lui	a5,0x10001
    80004bfc:	4398                	lw	a4,0(a5)
    80004bfe:	2701                	sext.w	a4,a4
    80004c00:	747277b7          	lui	a5,0x74727
    80004c04:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004c08:	18f71063          	bne	a4,a5,80004d88 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004c0c:	100017b7          	lui	a5,0x10001
    80004c10:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004c12:	439c                	lw	a5,0(a5)
    80004c14:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004c16:	4709                	li	a4,2
    80004c18:	16e79863          	bne	a5,a4,80004d88 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004c1c:	100017b7          	lui	a5,0x10001
    80004c20:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004c22:	439c                	lw	a5,0(a5)
    80004c24:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004c26:	16e79163          	bne	a5,a4,80004d88 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004c2a:	100017b7          	lui	a5,0x10001
    80004c2e:	47d8                	lw	a4,12(a5)
    80004c30:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004c32:	554d47b7          	lui	a5,0x554d4
    80004c36:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004c3a:	14f71763          	bne	a4,a5,80004d88 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c3e:	100017b7          	lui	a5,0x10001
    80004c42:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c46:	4705                	li	a4,1
    80004c48:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c4a:	470d                	li	a4,3
    80004c4c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004c4e:	10001737          	lui	a4,0x10001
    80004c52:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004c54:	c7ffe737          	lui	a4,0xc7ffe
    80004c58:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fda9df>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004c5c:	8ef9                	and	a3,a3,a4
    80004c5e:	10001737          	lui	a4,0x10001
    80004c62:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c64:	472d                	li	a4,11
    80004c66:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c68:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004c6c:	439c                	lw	a5,0(a5)
    80004c6e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004c72:	8ba1                	andi	a5,a5,8
    80004c74:	12078063          	beqz	a5,80004d94 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004c78:	100017b7          	lui	a5,0x10001
    80004c7c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004c80:	100017b7          	lui	a5,0x10001
    80004c84:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004c88:	439c                	lw	a5,0(a5)
    80004c8a:	2781                	sext.w	a5,a5
    80004c8c:	10079a63          	bnez	a5,80004da0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004c90:	100017b7          	lui	a5,0x10001
    80004c94:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004c98:	439c                	lw	a5,0(a5)
    80004c9a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004c9c:	10078863          	beqz	a5,80004dac <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004ca0:	471d                	li	a4,7
    80004ca2:	10f77b63          	bgeu	a4,a5,80004db8 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004ca6:	c50fb0ef          	jal	800000f6 <kalloc>
    80004caa:	00017497          	auipc	s1,0x17
    80004cae:	e9648493          	addi	s1,s1,-362 # 8001bb40 <disk>
    80004cb2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004cb4:	c42fb0ef          	jal	800000f6 <kalloc>
    80004cb8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004cba:	c3cfb0ef          	jal	800000f6 <kalloc>
    80004cbe:	87aa                	mv	a5,a0
    80004cc0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004cc2:	6088                	ld	a0,0(s1)
    80004cc4:	10050063          	beqz	a0,80004dc4 <virtio_disk_init+0x1ec>
    80004cc8:	00017717          	auipc	a4,0x17
    80004ccc:	e8073703          	ld	a4,-384(a4) # 8001bb48 <disk+0x8>
    80004cd0:	0e070a63          	beqz	a4,80004dc4 <virtio_disk_init+0x1ec>
    80004cd4:	0e078863          	beqz	a5,80004dc4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004cd8:	6605                	lui	a2,0x1
    80004cda:	4581                	li	a1,0
    80004cdc:	c58fb0ef          	jal	80000134 <memset>
  memset(disk.avail, 0, PGSIZE);
    80004ce0:	00017497          	auipc	s1,0x17
    80004ce4:	e6048493          	addi	s1,s1,-416 # 8001bb40 <disk>
    80004ce8:	6605                	lui	a2,0x1
    80004cea:	4581                	li	a1,0
    80004cec:	6488                	ld	a0,8(s1)
    80004cee:	c46fb0ef          	jal	80000134 <memset>
  memset(disk.used, 0, PGSIZE);
    80004cf2:	6605                	lui	a2,0x1
    80004cf4:	4581                	li	a1,0
    80004cf6:	6888                	ld	a0,16(s1)
    80004cf8:	c3cfb0ef          	jal	80000134 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004cfc:	100017b7          	lui	a5,0x10001
    80004d00:	4721                	li	a4,8
    80004d02:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004d04:	4098                	lw	a4,0(s1)
    80004d06:	100017b7          	lui	a5,0x10001
    80004d0a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004d0e:	40d8                	lw	a4,4(s1)
    80004d10:	100017b7          	lui	a5,0x10001
    80004d14:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004d18:	649c                	ld	a5,8(s1)
    80004d1a:	0007869b          	sext.w	a3,a5
    80004d1e:	10001737          	lui	a4,0x10001
    80004d22:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004d26:	9781                	srai	a5,a5,0x20
    80004d28:	10001737          	lui	a4,0x10001
    80004d2c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004d30:	689c                	ld	a5,16(s1)
    80004d32:	0007869b          	sext.w	a3,a5
    80004d36:	10001737          	lui	a4,0x10001
    80004d3a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004d3e:	9781                	srai	a5,a5,0x20
    80004d40:	10001737          	lui	a4,0x10001
    80004d44:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004d48:	10001737          	lui	a4,0x10001
    80004d4c:	4785                	li	a5,1
    80004d4e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004d50:	00f48c23          	sb	a5,24(s1)
    80004d54:	00f48ca3          	sb	a5,25(s1)
    80004d58:	00f48d23          	sb	a5,26(s1)
    80004d5c:	00f48da3          	sb	a5,27(s1)
    80004d60:	00f48e23          	sb	a5,28(s1)
    80004d64:	00f48ea3          	sb	a5,29(s1)
    80004d68:	00f48f23          	sb	a5,30(s1)
    80004d6c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004d70:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004d74:	100017b7          	lui	a5,0x10001
    80004d78:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004d7c:	60e2                	ld	ra,24(sp)
    80004d7e:	6442                	ld	s0,16(sp)
    80004d80:	64a2                	ld	s1,8(sp)
    80004d82:	6902                	ld	s2,0(sp)
    80004d84:	6105                	addi	sp,sp,32
    80004d86:	8082                	ret
    panic("could not find virtio disk");
    80004d88:	00003517          	auipc	a0,0x3
    80004d8c:	a2850513          	addi	a0,a0,-1496 # 800077b0 <etext+0x7b0>
    80004d90:	273000ef          	jal	80005802 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004d94:	00003517          	auipc	a0,0x3
    80004d98:	a3c50513          	addi	a0,a0,-1476 # 800077d0 <etext+0x7d0>
    80004d9c:	267000ef          	jal	80005802 <panic>
    panic("virtio disk should not be ready");
    80004da0:	00003517          	auipc	a0,0x3
    80004da4:	a5050513          	addi	a0,a0,-1456 # 800077f0 <etext+0x7f0>
    80004da8:	25b000ef          	jal	80005802 <panic>
    panic("virtio disk has no queue 0");
    80004dac:	00003517          	auipc	a0,0x3
    80004db0:	a6450513          	addi	a0,a0,-1436 # 80007810 <etext+0x810>
    80004db4:	24f000ef          	jal	80005802 <panic>
    panic("virtio disk max queue too short");
    80004db8:	00003517          	auipc	a0,0x3
    80004dbc:	a7850513          	addi	a0,a0,-1416 # 80007830 <etext+0x830>
    80004dc0:	243000ef          	jal	80005802 <panic>
    panic("virtio disk kalloc");
    80004dc4:	00003517          	auipc	a0,0x3
    80004dc8:	a8c50513          	addi	a0,a0,-1396 # 80007850 <etext+0x850>
    80004dcc:	237000ef          	jal	80005802 <panic>

0000000080004dd0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004dd0:	7159                	addi	sp,sp,-112
    80004dd2:	f486                	sd	ra,104(sp)
    80004dd4:	f0a2                	sd	s0,96(sp)
    80004dd6:	eca6                	sd	s1,88(sp)
    80004dd8:	e8ca                	sd	s2,80(sp)
    80004dda:	e4ce                	sd	s3,72(sp)
    80004ddc:	e0d2                	sd	s4,64(sp)
    80004dde:	fc56                	sd	s5,56(sp)
    80004de0:	f85a                	sd	s6,48(sp)
    80004de2:	f45e                	sd	s7,40(sp)
    80004de4:	f062                	sd	s8,32(sp)
    80004de6:	ec66                	sd	s9,24(sp)
    80004de8:	1880                	addi	s0,sp,112
    80004dea:	8a2a                	mv	s4,a0
    80004dec:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004dee:	00c52c83          	lw	s9,12(a0)
    80004df2:	001c9c9b          	slliw	s9,s9,0x1
    80004df6:	1c82                	slli	s9,s9,0x20
    80004df8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004dfc:	00017517          	auipc	a0,0x17
    80004e00:	e6c50513          	addi	a0,a0,-404 # 8001bc68 <disk+0x128>
    80004e04:	52d000ef          	jal	80005b30 <acquire>
  for(int i = 0; i < 3; i++){
    80004e08:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004e0a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004e0c:	00017b17          	auipc	s6,0x17
    80004e10:	d34b0b13          	addi	s6,s6,-716 # 8001bb40 <disk>
  for(int i = 0; i < 3; i++){
    80004e14:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004e16:	00017c17          	auipc	s8,0x17
    80004e1a:	e52c0c13          	addi	s8,s8,-430 # 8001bc68 <disk+0x128>
    80004e1e:	a8b9                	j	80004e7c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004e20:	00fb0733          	add	a4,s6,a5
    80004e24:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004e28:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004e2a:	0207c563          	bltz	a5,80004e54 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004e2e:	2905                	addiw	s2,s2,1
    80004e30:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004e32:	05590963          	beq	s2,s5,80004e84 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004e36:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004e38:	00017717          	auipc	a4,0x17
    80004e3c:	d0870713          	addi	a4,a4,-760 # 8001bb40 <disk>
    80004e40:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004e42:	01874683          	lbu	a3,24(a4)
    80004e46:	fee9                	bnez	a3,80004e20 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004e48:	2785                	addiw	a5,a5,1
    80004e4a:	0705                	addi	a4,a4,1
    80004e4c:	fe979be3          	bne	a5,s1,80004e42 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004e50:	57fd                	li	a5,-1
    80004e52:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004e54:	01205d63          	blez	s2,80004e6e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004e58:	f9042503          	lw	a0,-112(s0)
    80004e5c:	d07ff0ef          	jal	80004b62 <free_desc>
      for(int j = 0; j < i; j++)
    80004e60:	4785                	li	a5,1
    80004e62:	0127d663          	bge	a5,s2,80004e6e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004e66:	f9442503          	lw	a0,-108(s0)
    80004e6a:	cf9ff0ef          	jal	80004b62 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004e6e:	85e2                	mv	a1,s8
    80004e70:	00017517          	auipc	a0,0x17
    80004e74:	ce850513          	addi	a0,a0,-792 # 8001bb58 <disk+0x18>
    80004e78:	cb8fc0ef          	jal	80001330 <sleep>
  for(int i = 0; i < 3; i++){
    80004e7c:	f9040613          	addi	a2,s0,-112
    80004e80:	894e                	mv	s2,s3
    80004e82:	bf55                	j	80004e36 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004e84:	f9042503          	lw	a0,-112(s0)
    80004e88:	00451693          	slli	a3,a0,0x4

  if(write)
    80004e8c:	00017797          	auipc	a5,0x17
    80004e90:	cb478793          	addi	a5,a5,-844 # 8001bb40 <disk>
    80004e94:	00a50713          	addi	a4,a0,10
    80004e98:	0712                	slli	a4,a4,0x4
    80004e9a:	973e                	add	a4,a4,a5
    80004e9c:	01703633          	snez	a2,s7
    80004ea0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004ea2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004ea6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004eaa:	6398                	ld	a4,0(a5)
    80004eac:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004eae:	0a868613          	addi	a2,a3,168
    80004eb2:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004eb4:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004eb6:	6390                	ld	a2,0(a5)
    80004eb8:	00d605b3          	add	a1,a2,a3
    80004ebc:	4741                	li	a4,16
    80004ebe:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004ec0:	4805                	li	a6,1
    80004ec2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004ec6:	f9442703          	lw	a4,-108(s0)
    80004eca:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004ece:	0712                	slli	a4,a4,0x4
    80004ed0:	963a                	add	a2,a2,a4
    80004ed2:	058a0593          	addi	a1,s4,88
    80004ed6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004ed8:	0007b883          	ld	a7,0(a5)
    80004edc:	9746                	add	a4,a4,a7
    80004ede:	40000613          	li	a2,1024
    80004ee2:	c710                	sw	a2,8(a4)
  if(write)
    80004ee4:	001bb613          	seqz	a2,s7
    80004ee8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004eec:	00166613          	ori	a2,a2,1
    80004ef0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004ef4:	f9842583          	lw	a1,-104(s0)
    80004ef8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004efc:	00250613          	addi	a2,a0,2
    80004f00:	0612                	slli	a2,a2,0x4
    80004f02:	963e                	add	a2,a2,a5
    80004f04:	577d                	li	a4,-1
    80004f06:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004f0a:	0592                	slli	a1,a1,0x4
    80004f0c:	98ae                	add	a7,a7,a1
    80004f0e:	03068713          	addi	a4,a3,48
    80004f12:	973e                	add	a4,a4,a5
    80004f14:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004f18:	6398                	ld	a4,0(a5)
    80004f1a:	972e                	add	a4,a4,a1
    80004f1c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004f20:	4689                	li	a3,2
    80004f22:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004f26:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004f2a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004f2e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004f32:	6794                	ld	a3,8(a5)
    80004f34:	0026d703          	lhu	a4,2(a3)
    80004f38:	8b1d                	andi	a4,a4,7
    80004f3a:	0706                	slli	a4,a4,0x1
    80004f3c:	96ba                	add	a3,a3,a4
    80004f3e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004f42:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004f46:	6798                	ld	a4,8(a5)
    80004f48:	00275783          	lhu	a5,2(a4)
    80004f4c:	2785                	addiw	a5,a5,1
    80004f4e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004f52:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004f56:	100017b7          	lui	a5,0x10001
    80004f5a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004f5e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004f62:	00017917          	auipc	s2,0x17
    80004f66:	d0690913          	addi	s2,s2,-762 # 8001bc68 <disk+0x128>
  while(b->disk == 1) {
    80004f6a:	4485                	li	s1,1
    80004f6c:	01079a63          	bne	a5,a6,80004f80 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004f70:	85ca                	mv	a1,s2
    80004f72:	8552                	mv	a0,s4
    80004f74:	bbcfc0ef          	jal	80001330 <sleep>
  while(b->disk == 1) {
    80004f78:	004a2783          	lw	a5,4(s4)
    80004f7c:	fe978ae3          	beq	a5,s1,80004f70 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004f80:	f9042903          	lw	s2,-112(s0)
    80004f84:	00290713          	addi	a4,s2,2
    80004f88:	0712                	slli	a4,a4,0x4
    80004f8a:	00017797          	auipc	a5,0x17
    80004f8e:	bb678793          	addi	a5,a5,-1098 # 8001bb40 <disk>
    80004f92:	97ba                	add	a5,a5,a4
    80004f94:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004f98:	00017997          	auipc	s3,0x17
    80004f9c:	ba898993          	addi	s3,s3,-1112 # 8001bb40 <disk>
    80004fa0:	00491713          	slli	a4,s2,0x4
    80004fa4:	0009b783          	ld	a5,0(s3)
    80004fa8:	97ba                	add	a5,a5,a4
    80004faa:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004fae:	854a                	mv	a0,s2
    80004fb0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004fb4:	bafff0ef          	jal	80004b62 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004fb8:	8885                	andi	s1,s1,1
    80004fba:	f0fd                	bnez	s1,80004fa0 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004fbc:	00017517          	auipc	a0,0x17
    80004fc0:	cac50513          	addi	a0,a0,-852 # 8001bc68 <disk+0x128>
    80004fc4:	405000ef          	jal	80005bc8 <release>
}
    80004fc8:	70a6                	ld	ra,104(sp)
    80004fca:	7406                	ld	s0,96(sp)
    80004fcc:	64e6                	ld	s1,88(sp)
    80004fce:	6946                	ld	s2,80(sp)
    80004fd0:	69a6                	ld	s3,72(sp)
    80004fd2:	6a06                	ld	s4,64(sp)
    80004fd4:	7ae2                	ld	s5,56(sp)
    80004fd6:	7b42                	ld	s6,48(sp)
    80004fd8:	7ba2                	ld	s7,40(sp)
    80004fda:	7c02                	ld	s8,32(sp)
    80004fdc:	6ce2                	ld	s9,24(sp)
    80004fde:	6165                	addi	sp,sp,112
    80004fe0:	8082                	ret

0000000080004fe2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004fe2:	1101                	addi	sp,sp,-32
    80004fe4:	ec06                	sd	ra,24(sp)
    80004fe6:	e822                	sd	s0,16(sp)
    80004fe8:	e426                	sd	s1,8(sp)
    80004fea:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004fec:	00017497          	auipc	s1,0x17
    80004ff0:	b5448493          	addi	s1,s1,-1196 # 8001bb40 <disk>
    80004ff4:	00017517          	auipc	a0,0x17
    80004ff8:	c7450513          	addi	a0,a0,-908 # 8001bc68 <disk+0x128>
    80004ffc:	335000ef          	jal	80005b30 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005000:	100017b7          	lui	a5,0x10001
    80005004:	53b8                	lw	a4,96(a5)
    80005006:	8b0d                	andi	a4,a4,3
    80005008:	100017b7          	lui	a5,0x10001
    8000500c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    8000500e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005012:	689c                	ld	a5,16(s1)
    80005014:	0204d703          	lhu	a4,32(s1)
    80005018:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000501c:	04f70663          	beq	a4,a5,80005068 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005020:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005024:	6898                	ld	a4,16(s1)
    80005026:	0204d783          	lhu	a5,32(s1)
    8000502a:	8b9d                	andi	a5,a5,7
    8000502c:	078e                	slli	a5,a5,0x3
    8000502e:	97ba                	add	a5,a5,a4
    80005030:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005032:	00278713          	addi	a4,a5,2
    80005036:	0712                	slli	a4,a4,0x4
    80005038:	9726                	add	a4,a4,s1
    8000503a:	01074703          	lbu	a4,16(a4)
    8000503e:	e321                	bnez	a4,8000507e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005040:	0789                	addi	a5,a5,2
    80005042:	0792                	slli	a5,a5,0x4
    80005044:	97a6                	add	a5,a5,s1
    80005046:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005048:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000504c:	b30fc0ef          	jal	8000137c <wakeup>

    disk.used_idx += 1;
    80005050:	0204d783          	lhu	a5,32(s1)
    80005054:	2785                	addiw	a5,a5,1
    80005056:	17c2                	slli	a5,a5,0x30
    80005058:	93c1                	srli	a5,a5,0x30
    8000505a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000505e:	6898                	ld	a4,16(s1)
    80005060:	00275703          	lhu	a4,2(a4)
    80005064:	faf71ee3          	bne	a4,a5,80005020 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005068:	00017517          	auipc	a0,0x17
    8000506c:	c0050513          	addi	a0,a0,-1024 # 8001bc68 <disk+0x128>
    80005070:	359000ef          	jal	80005bc8 <release>
}
    80005074:	60e2                	ld	ra,24(sp)
    80005076:	6442                	ld	s0,16(sp)
    80005078:	64a2                	ld	s1,8(sp)
    8000507a:	6105                	addi	sp,sp,32
    8000507c:	8082                	ret
      panic("virtio_disk_intr status");
    8000507e:	00002517          	auipc	a0,0x2
    80005082:	7ea50513          	addi	a0,a0,2026 # 80007868 <etext+0x868>
    80005086:	77c000ef          	jal	80005802 <panic>

000000008000508a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000508a:	1141                	addi	sp,sp,-16
    8000508c:	e422                	sd	s0,8(sp)
    8000508e:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005090:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80005094:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    80005098:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000509c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    800050a0:	577d                	li	a4,-1
    800050a2:	177e                	slli	a4,a4,0x3f
    800050a4:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    800050a6:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    800050aa:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    800050ae:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    800050b2:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    800050b6:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    800050ba:	000f4737          	lui	a4,0xf4
    800050be:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800050c2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800050c4:	14d79073          	csrw	stimecmp,a5
}
    800050c8:	6422                	ld	s0,8(sp)
    800050ca:	0141                	addi	sp,sp,16
    800050cc:	8082                	ret

00000000800050ce <start>:
{
    800050ce:	1141                	addi	sp,sp,-16
    800050d0:	e406                	sd	ra,8(sp)
    800050d2:	e022                	sd	s0,0(sp)
    800050d4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800050d6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800050da:	7779                	lui	a4,0xffffe
    800050dc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdaa7f>
    800050e0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800050e2:	6705                	lui	a4,0x1
    800050e4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800050e8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800050ea:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800050ee:	ffffb797          	auipc	a5,0xffffb
    800050f2:	1e078793          	addi	a5,a5,480 # 800002ce <main>
    800050f6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800050fa:	4781                	li	a5,0
    800050fc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005100:	67c1                	lui	a5,0x10
    80005102:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005104:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005108:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000510c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005110:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005114:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005118:	57fd                	li	a5,-1
    8000511a:	83a9                	srli	a5,a5,0xa
    8000511c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005120:	47bd                	li	a5,15
    80005122:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005126:	f65ff0ef          	jal	8000508a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000512a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000512e:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    80005130:	823e                	mv	tp,a5
  asm volatile("mret");
    80005132:	30200073          	mret
}
    80005136:	60a2                	ld	ra,8(sp)
    80005138:	6402                	ld	s0,0(sp)
    8000513a:	0141                	addi	sp,sp,16
    8000513c:	8082                	ret

000000008000513e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000513e:	715d                	addi	sp,sp,-80
    80005140:	e486                	sd	ra,72(sp)
    80005142:	e0a2                	sd	s0,64(sp)
    80005144:	f84a                	sd	s2,48(sp)
    80005146:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005148:	04c05263          	blez	a2,8000518c <consolewrite+0x4e>
    8000514c:	fc26                	sd	s1,56(sp)
    8000514e:	f44e                	sd	s3,40(sp)
    80005150:	f052                	sd	s4,32(sp)
    80005152:	ec56                	sd	s5,24(sp)
    80005154:	8a2a                	mv	s4,a0
    80005156:	84ae                	mv	s1,a1
    80005158:	89b2                	mv	s3,a2
    8000515a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000515c:	5afd                	li	s5,-1
    8000515e:	4685                	li	a3,1
    80005160:	8626                	mv	a2,s1
    80005162:	85d2                	mv	a1,s4
    80005164:	fbf40513          	addi	a0,s0,-65
    80005168:	d6efc0ef          	jal	800016d6 <either_copyin>
    8000516c:	03550263          	beq	a0,s5,80005190 <consolewrite+0x52>
      break;
    uartputc(c);
    80005170:	fbf44503          	lbu	a0,-65(s0)
    80005174:	035000ef          	jal	800059a8 <uartputc>
  for(i = 0; i < n; i++){
    80005178:	2905                	addiw	s2,s2,1
    8000517a:	0485                	addi	s1,s1,1
    8000517c:	ff2991e3          	bne	s3,s2,8000515e <consolewrite+0x20>
    80005180:	894e                	mv	s2,s3
    80005182:	74e2                	ld	s1,56(sp)
    80005184:	79a2                	ld	s3,40(sp)
    80005186:	7a02                	ld	s4,32(sp)
    80005188:	6ae2                	ld	s5,24(sp)
    8000518a:	a039                	j	80005198 <consolewrite+0x5a>
    8000518c:	4901                	li	s2,0
    8000518e:	a029                	j	80005198 <consolewrite+0x5a>
    80005190:	74e2                	ld	s1,56(sp)
    80005192:	79a2                	ld	s3,40(sp)
    80005194:	7a02                	ld	s4,32(sp)
    80005196:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005198:	854a                	mv	a0,s2
    8000519a:	60a6                	ld	ra,72(sp)
    8000519c:	6406                	ld	s0,64(sp)
    8000519e:	7942                	ld	s2,48(sp)
    800051a0:	6161                	addi	sp,sp,80
    800051a2:	8082                	ret

00000000800051a4 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800051a4:	711d                	addi	sp,sp,-96
    800051a6:	ec86                	sd	ra,88(sp)
    800051a8:	e8a2                	sd	s0,80(sp)
    800051aa:	e4a6                	sd	s1,72(sp)
    800051ac:	e0ca                	sd	s2,64(sp)
    800051ae:	fc4e                	sd	s3,56(sp)
    800051b0:	f852                	sd	s4,48(sp)
    800051b2:	f456                	sd	s5,40(sp)
    800051b4:	f05a                	sd	s6,32(sp)
    800051b6:	1080                	addi	s0,sp,96
    800051b8:	8aaa                	mv	s5,a0
    800051ba:	8a2e                	mv	s4,a1
    800051bc:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800051be:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800051c2:	0001f517          	auipc	a0,0x1f
    800051c6:	abe50513          	addi	a0,a0,-1346 # 80023c80 <cons>
    800051ca:	167000ef          	jal	80005b30 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800051ce:	0001f497          	auipc	s1,0x1f
    800051d2:	ab248493          	addi	s1,s1,-1358 # 80023c80 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800051d6:	0001f917          	auipc	s2,0x1f
    800051da:	b4290913          	addi	s2,s2,-1214 # 80023d18 <cons+0x98>
  while(n > 0){
    800051de:	0b305d63          	blez	s3,80005298 <consoleread+0xf4>
    while(cons.r == cons.w){
    800051e2:	0984a783          	lw	a5,152(s1)
    800051e6:	09c4a703          	lw	a4,156(s1)
    800051ea:	0af71263          	bne	a4,a5,8000528e <consoleread+0xea>
      if(killed(myproc())){
    800051ee:	b69fb0ef          	jal	80000d56 <myproc>
    800051f2:	b76fc0ef          	jal	80001568 <killed>
    800051f6:	e12d                	bnez	a0,80005258 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    800051f8:	85a6                	mv	a1,s1
    800051fa:	854a                	mv	a0,s2
    800051fc:	934fc0ef          	jal	80001330 <sleep>
    while(cons.r == cons.w){
    80005200:	0984a783          	lw	a5,152(s1)
    80005204:	09c4a703          	lw	a4,156(s1)
    80005208:	fef703e3          	beq	a4,a5,800051ee <consoleread+0x4a>
    8000520c:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000520e:	0001f717          	auipc	a4,0x1f
    80005212:	a7270713          	addi	a4,a4,-1422 # 80023c80 <cons>
    80005216:	0017869b          	addiw	a3,a5,1
    8000521a:	08d72c23          	sw	a3,152(a4)
    8000521e:	07f7f693          	andi	a3,a5,127
    80005222:	9736                	add	a4,a4,a3
    80005224:	01874703          	lbu	a4,24(a4)
    80005228:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    8000522c:	4691                	li	a3,4
    8000522e:	04db8663          	beq	s7,a3,8000527a <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005232:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005236:	4685                	li	a3,1
    80005238:	faf40613          	addi	a2,s0,-81
    8000523c:	85d2                	mv	a1,s4
    8000523e:	8556                	mv	a0,s5
    80005240:	c4cfc0ef          	jal	8000168c <either_copyout>
    80005244:	57fd                	li	a5,-1
    80005246:	04f50863          	beq	a0,a5,80005296 <consoleread+0xf2>
      break;

    dst++;
    8000524a:	0a05                	addi	s4,s4,1
    --n;
    8000524c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000524e:	47a9                	li	a5,10
    80005250:	04fb8d63          	beq	s7,a5,800052aa <consoleread+0x106>
    80005254:	6be2                	ld	s7,24(sp)
    80005256:	b761                	j	800051de <consoleread+0x3a>
        release(&cons.lock);
    80005258:	0001f517          	auipc	a0,0x1f
    8000525c:	a2850513          	addi	a0,a0,-1496 # 80023c80 <cons>
    80005260:	169000ef          	jal	80005bc8 <release>
        return -1;
    80005264:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005266:	60e6                	ld	ra,88(sp)
    80005268:	6446                	ld	s0,80(sp)
    8000526a:	64a6                	ld	s1,72(sp)
    8000526c:	6906                	ld	s2,64(sp)
    8000526e:	79e2                	ld	s3,56(sp)
    80005270:	7a42                	ld	s4,48(sp)
    80005272:	7aa2                	ld	s5,40(sp)
    80005274:	7b02                	ld	s6,32(sp)
    80005276:	6125                	addi	sp,sp,96
    80005278:	8082                	ret
      if(n < target){
    8000527a:	0009871b          	sext.w	a4,s3
    8000527e:	01677a63          	bgeu	a4,s6,80005292 <consoleread+0xee>
        cons.r--;
    80005282:	0001f717          	auipc	a4,0x1f
    80005286:	a8f72b23          	sw	a5,-1386(a4) # 80023d18 <cons+0x98>
    8000528a:	6be2                	ld	s7,24(sp)
    8000528c:	a031                	j	80005298 <consoleread+0xf4>
    8000528e:	ec5e                	sd	s7,24(sp)
    80005290:	bfbd                	j	8000520e <consoleread+0x6a>
    80005292:	6be2                	ld	s7,24(sp)
    80005294:	a011                	j	80005298 <consoleread+0xf4>
    80005296:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005298:	0001f517          	auipc	a0,0x1f
    8000529c:	9e850513          	addi	a0,a0,-1560 # 80023c80 <cons>
    800052a0:	129000ef          	jal	80005bc8 <release>
  return target - n;
    800052a4:	413b053b          	subw	a0,s6,s3
    800052a8:	bf7d                	j	80005266 <consoleread+0xc2>
    800052aa:	6be2                	ld	s7,24(sp)
    800052ac:	b7f5                	j	80005298 <consoleread+0xf4>

00000000800052ae <consputc>:
{
    800052ae:	1141                	addi	sp,sp,-16
    800052b0:	e406                	sd	ra,8(sp)
    800052b2:	e022                	sd	s0,0(sp)
    800052b4:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800052b6:	10000793          	li	a5,256
    800052ba:	00f50863          	beq	a0,a5,800052ca <consputc+0x1c>
    uartputc_sync(c);
    800052be:	604000ef          	jal	800058c2 <uartputc_sync>
}
    800052c2:	60a2                	ld	ra,8(sp)
    800052c4:	6402                	ld	s0,0(sp)
    800052c6:	0141                	addi	sp,sp,16
    800052c8:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800052ca:	4521                	li	a0,8
    800052cc:	5f6000ef          	jal	800058c2 <uartputc_sync>
    800052d0:	02000513          	li	a0,32
    800052d4:	5ee000ef          	jal	800058c2 <uartputc_sync>
    800052d8:	4521                	li	a0,8
    800052da:	5e8000ef          	jal	800058c2 <uartputc_sync>
    800052de:	b7d5                	j	800052c2 <consputc+0x14>

00000000800052e0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800052e0:	1101                	addi	sp,sp,-32
    800052e2:	ec06                	sd	ra,24(sp)
    800052e4:	e822                	sd	s0,16(sp)
    800052e6:	e426                	sd	s1,8(sp)
    800052e8:	1000                	addi	s0,sp,32
    800052ea:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800052ec:	0001f517          	auipc	a0,0x1f
    800052f0:	99450513          	addi	a0,a0,-1644 # 80023c80 <cons>
    800052f4:	03d000ef          	jal	80005b30 <acquire>

  switch(c){
    800052f8:	47d5                	li	a5,21
    800052fa:	08f48f63          	beq	s1,a5,80005398 <consoleintr+0xb8>
    800052fe:	0297c563          	blt	a5,s1,80005328 <consoleintr+0x48>
    80005302:	47a1                	li	a5,8
    80005304:	0ef48463          	beq	s1,a5,800053ec <consoleintr+0x10c>
    80005308:	47c1                	li	a5,16
    8000530a:	10f49563          	bne	s1,a5,80005414 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    8000530e:	c12fc0ef          	jal	80001720 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005312:	0001f517          	auipc	a0,0x1f
    80005316:	96e50513          	addi	a0,a0,-1682 # 80023c80 <cons>
    8000531a:	0af000ef          	jal	80005bc8 <release>
}
    8000531e:	60e2                	ld	ra,24(sp)
    80005320:	6442                	ld	s0,16(sp)
    80005322:	64a2                	ld	s1,8(sp)
    80005324:	6105                	addi	sp,sp,32
    80005326:	8082                	ret
  switch(c){
    80005328:	07f00793          	li	a5,127
    8000532c:	0cf48063          	beq	s1,a5,800053ec <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005330:	0001f717          	auipc	a4,0x1f
    80005334:	95070713          	addi	a4,a4,-1712 # 80023c80 <cons>
    80005338:	0a072783          	lw	a5,160(a4)
    8000533c:	09872703          	lw	a4,152(a4)
    80005340:	9f99                	subw	a5,a5,a4
    80005342:	07f00713          	li	a4,127
    80005346:	fcf766e3          	bltu	a4,a5,80005312 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    8000534a:	47b5                	li	a5,13
    8000534c:	0cf48763          	beq	s1,a5,8000541a <consoleintr+0x13a>
      consputc(c);
    80005350:	8526                	mv	a0,s1
    80005352:	f5dff0ef          	jal	800052ae <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005356:	0001f797          	auipc	a5,0x1f
    8000535a:	92a78793          	addi	a5,a5,-1750 # 80023c80 <cons>
    8000535e:	0a07a683          	lw	a3,160(a5)
    80005362:	0016871b          	addiw	a4,a3,1
    80005366:	0007061b          	sext.w	a2,a4
    8000536a:	0ae7a023          	sw	a4,160(a5)
    8000536e:	07f6f693          	andi	a3,a3,127
    80005372:	97b6                	add	a5,a5,a3
    80005374:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005378:	47a9                	li	a5,10
    8000537a:	0cf48563          	beq	s1,a5,80005444 <consoleintr+0x164>
    8000537e:	4791                	li	a5,4
    80005380:	0cf48263          	beq	s1,a5,80005444 <consoleintr+0x164>
    80005384:	0001f797          	auipc	a5,0x1f
    80005388:	9947a783          	lw	a5,-1644(a5) # 80023d18 <cons+0x98>
    8000538c:	9f1d                	subw	a4,a4,a5
    8000538e:	08000793          	li	a5,128
    80005392:	f8f710e3          	bne	a4,a5,80005312 <consoleintr+0x32>
    80005396:	a07d                	j	80005444 <consoleintr+0x164>
    80005398:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000539a:	0001f717          	auipc	a4,0x1f
    8000539e:	8e670713          	addi	a4,a4,-1818 # 80023c80 <cons>
    800053a2:	0a072783          	lw	a5,160(a4)
    800053a6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800053aa:	0001f497          	auipc	s1,0x1f
    800053ae:	8d648493          	addi	s1,s1,-1834 # 80023c80 <cons>
    while(cons.e != cons.w &&
    800053b2:	4929                	li	s2,10
    800053b4:	02f70863          	beq	a4,a5,800053e4 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800053b8:	37fd                	addiw	a5,a5,-1
    800053ba:	07f7f713          	andi	a4,a5,127
    800053be:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800053c0:	01874703          	lbu	a4,24(a4)
    800053c4:	03270263          	beq	a4,s2,800053e8 <consoleintr+0x108>
      cons.e--;
    800053c8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800053cc:	10000513          	li	a0,256
    800053d0:	edfff0ef          	jal	800052ae <consputc>
    while(cons.e != cons.w &&
    800053d4:	0a04a783          	lw	a5,160(s1)
    800053d8:	09c4a703          	lw	a4,156(s1)
    800053dc:	fcf71ee3          	bne	a4,a5,800053b8 <consoleintr+0xd8>
    800053e0:	6902                	ld	s2,0(sp)
    800053e2:	bf05                	j	80005312 <consoleintr+0x32>
    800053e4:	6902                	ld	s2,0(sp)
    800053e6:	b735                	j	80005312 <consoleintr+0x32>
    800053e8:	6902                	ld	s2,0(sp)
    800053ea:	b725                	j	80005312 <consoleintr+0x32>
    if(cons.e != cons.w){
    800053ec:	0001f717          	auipc	a4,0x1f
    800053f0:	89470713          	addi	a4,a4,-1900 # 80023c80 <cons>
    800053f4:	0a072783          	lw	a5,160(a4)
    800053f8:	09c72703          	lw	a4,156(a4)
    800053fc:	f0f70be3          	beq	a4,a5,80005312 <consoleintr+0x32>
      cons.e--;
    80005400:	37fd                	addiw	a5,a5,-1
    80005402:	0001f717          	auipc	a4,0x1f
    80005406:	90f72f23          	sw	a5,-1762(a4) # 80023d20 <cons+0xa0>
      consputc(BACKSPACE);
    8000540a:	10000513          	li	a0,256
    8000540e:	ea1ff0ef          	jal	800052ae <consputc>
    80005412:	b701                	j	80005312 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005414:	ee048fe3          	beqz	s1,80005312 <consoleintr+0x32>
    80005418:	bf21                	j	80005330 <consoleintr+0x50>
      consputc(c);
    8000541a:	4529                	li	a0,10
    8000541c:	e93ff0ef          	jal	800052ae <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005420:	0001f797          	auipc	a5,0x1f
    80005424:	86078793          	addi	a5,a5,-1952 # 80023c80 <cons>
    80005428:	0a07a703          	lw	a4,160(a5)
    8000542c:	0017069b          	addiw	a3,a4,1
    80005430:	0006861b          	sext.w	a2,a3
    80005434:	0ad7a023          	sw	a3,160(a5)
    80005438:	07f77713          	andi	a4,a4,127
    8000543c:	97ba                	add	a5,a5,a4
    8000543e:	4729                	li	a4,10
    80005440:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005444:	0001f797          	auipc	a5,0x1f
    80005448:	8cc7ac23          	sw	a2,-1832(a5) # 80023d1c <cons+0x9c>
        wakeup(&cons.r);
    8000544c:	0001f517          	auipc	a0,0x1f
    80005450:	8cc50513          	addi	a0,a0,-1844 # 80023d18 <cons+0x98>
    80005454:	f29fb0ef          	jal	8000137c <wakeup>
    80005458:	bd6d                	j	80005312 <consoleintr+0x32>

000000008000545a <consoleinit>:

void
consoleinit(void)
{
    8000545a:	1141                	addi	sp,sp,-16
    8000545c:	e406                	sd	ra,8(sp)
    8000545e:	e022                	sd	s0,0(sp)
    80005460:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005462:	00002597          	auipc	a1,0x2
    80005466:	41e58593          	addi	a1,a1,1054 # 80007880 <etext+0x880>
    8000546a:	0001f517          	auipc	a0,0x1f
    8000546e:	81650513          	addi	a0,a0,-2026 # 80023c80 <cons>
    80005472:	63e000ef          	jal	80005ab0 <initlock>

  uartinit();
    80005476:	3f4000ef          	jal	8000586a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000547a:	00015797          	auipc	a5,0x15
    8000547e:	66e78793          	addi	a5,a5,1646 # 8001aae8 <devsw>
    80005482:	00000717          	auipc	a4,0x0
    80005486:	d2270713          	addi	a4,a4,-734 # 800051a4 <consoleread>
    8000548a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000548c:	00000717          	auipc	a4,0x0
    80005490:	cb270713          	addi	a4,a4,-846 # 8000513e <consolewrite>
    80005494:	ef98                	sd	a4,24(a5)
}
    80005496:	60a2                	ld	ra,8(sp)
    80005498:	6402                	ld	s0,0(sp)
    8000549a:	0141                	addi	sp,sp,16
    8000549c:	8082                	ret

000000008000549e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000549e:	7179                	addi	sp,sp,-48
    800054a0:	f406                	sd	ra,40(sp)
    800054a2:	f022                	sd	s0,32(sp)
    800054a4:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800054a6:	c219                	beqz	a2,800054ac <printint+0xe>
    800054a8:	08054063          	bltz	a0,80005528 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    800054ac:	4881                	li	a7,0
    800054ae:	fd040693          	addi	a3,s0,-48

  i = 0;
    800054b2:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800054b4:	00002617          	auipc	a2,0x2
    800054b8:	62460613          	addi	a2,a2,1572 # 80007ad8 <digits>
    800054bc:	883e                	mv	a6,a5
    800054be:	2785                	addiw	a5,a5,1
    800054c0:	02b57733          	remu	a4,a0,a1
    800054c4:	9732                	add	a4,a4,a2
    800054c6:	00074703          	lbu	a4,0(a4)
    800054ca:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800054ce:	872a                	mv	a4,a0
    800054d0:	02b55533          	divu	a0,a0,a1
    800054d4:	0685                	addi	a3,a3,1
    800054d6:	feb773e3          	bgeu	a4,a1,800054bc <printint+0x1e>

  if(sign)
    800054da:	00088a63          	beqz	a7,800054ee <printint+0x50>
    buf[i++] = '-';
    800054de:	1781                	addi	a5,a5,-32
    800054e0:	97a2                	add	a5,a5,s0
    800054e2:	02d00713          	li	a4,45
    800054e6:	fee78823          	sb	a4,-16(a5)
    800054ea:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800054ee:	02f05963          	blez	a5,80005520 <printint+0x82>
    800054f2:	ec26                	sd	s1,24(sp)
    800054f4:	e84a                	sd	s2,16(sp)
    800054f6:	fd040713          	addi	a4,s0,-48
    800054fa:	00f704b3          	add	s1,a4,a5
    800054fe:	fff70913          	addi	s2,a4,-1
    80005502:	993e                	add	s2,s2,a5
    80005504:	37fd                	addiw	a5,a5,-1
    80005506:	1782                	slli	a5,a5,0x20
    80005508:	9381                	srli	a5,a5,0x20
    8000550a:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000550e:	fff4c503          	lbu	a0,-1(s1)
    80005512:	d9dff0ef          	jal	800052ae <consputc>
  while(--i >= 0)
    80005516:	14fd                	addi	s1,s1,-1
    80005518:	ff249be3          	bne	s1,s2,8000550e <printint+0x70>
    8000551c:	64e2                	ld	s1,24(sp)
    8000551e:	6942                	ld	s2,16(sp)
}
    80005520:	70a2                	ld	ra,40(sp)
    80005522:	7402                	ld	s0,32(sp)
    80005524:	6145                	addi	sp,sp,48
    80005526:	8082                	ret
    x = -xx;
    80005528:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000552c:	4885                	li	a7,1
    x = -xx;
    8000552e:	b741                	j	800054ae <printint+0x10>

0000000080005530 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005530:	7155                	addi	sp,sp,-208
    80005532:	e506                	sd	ra,136(sp)
    80005534:	e122                	sd	s0,128(sp)
    80005536:	f0d2                	sd	s4,96(sp)
    80005538:	0900                	addi	s0,sp,144
    8000553a:	8a2a                	mv	s4,a0
    8000553c:	e40c                	sd	a1,8(s0)
    8000553e:	e810                	sd	a2,16(s0)
    80005540:	ec14                	sd	a3,24(s0)
    80005542:	f018                	sd	a4,32(s0)
    80005544:	f41c                	sd	a5,40(s0)
    80005546:	03043823          	sd	a6,48(s0)
    8000554a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    8000554e:	0001e797          	auipc	a5,0x1e
    80005552:	7f27a783          	lw	a5,2034(a5) # 80023d40 <pr+0x18>
    80005556:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8000555a:	e3a1                	bnez	a5,8000559a <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000555c:	00840793          	addi	a5,s0,8
    80005560:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005564:	00054503          	lbu	a0,0(a0)
    80005568:	26050763          	beqz	a0,800057d6 <printf+0x2a6>
    8000556c:	fca6                	sd	s1,120(sp)
    8000556e:	f8ca                	sd	s2,112(sp)
    80005570:	f4ce                	sd	s3,104(sp)
    80005572:	ecd6                	sd	s5,88(sp)
    80005574:	e8da                	sd	s6,80(sp)
    80005576:	e0e2                	sd	s8,64(sp)
    80005578:	fc66                	sd	s9,56(sp)
    8000557a:	f86a                	sd	s10,48(sp)
    8000557c:	f46e                	sd	s11,40(sp)
    8000557e:	4981                	li	s3,0
    if(cx != '%'){
    80005580:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005584:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005588:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000558c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005590:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005594:	07000d93          	li	s11,112
    80005598:	a815                	j	800055cc <printf+0x9c>
    acquire(&pr.lock);
    8000559a:	0001e517          	auipc	a0,0x1e
    8000559e:	78e50513          	addi	a0,a0,1934 # 80023d28 <pr>
    800055a2:	58e000ef          	jal	80005b30 <acquire>
  va_start(ap, fmt);
    800055a6:	00840793          	addi	a5,s0,8
    800055aa:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800055ae:	000a4503          	lbu	a0,0(s4)
    800055b2:	fd4d                	bnez	a0,8000556c <printf+0x3c>
    800055b4:	a481                	j	800057f4 <printf+0x2c4>
      consputc(cx);
    800055b6:	cf9ff0ef          	jal	800052ae <consputc>
      continue;
    800055ba:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800055bc:	0014899b          	addiw	s3,s1,1
    800055c0:	013a07b3          	add	a5,s4,s3
    800055c4:	0007c503          	lbu	a0,0(a5)
    800055c8:	1e050b63          	beqz	a0,800057be <printf+0x28e>
    if(cx != '%'){
    800055cc:	ff5515e3          	bne	a0,s5,800055b6 <printf+0x86>
    i++;
    800055d0:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800055d4:	009a07b3          	add	a5,s4,s1
    800055d8:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800055dc:	1e090163          	beqz	s2,800057be <printf+0x28e>
    800055e0:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800055e4:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800055e6:	c789                	beqz	a5,800055f0 <printf+0xc0>
    800055e8:	009a0733          	add	a4,s4,s1
    800055ec:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800055f0:	03690763          	beq	s2,s6,8000561e <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    800055f4:	05890163          	beq	s2,s8,80005636 <printf+0x106>
    } else if(c0 == 'u'){
    800055f8:	0d990b63          	beq	s2,s9,800056ce <printf+0x19e>
    } else if(c0 == 'x'){
    800055fc:	13a90163          	beq	s2,s10,8000571e <printf+0x1ee>
    } else if(c0 == 'p'){
    80005600:	13b90b63          	beq	s2,s11,80005736 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005604:	07300793          	li	a5,115
    80005608:	16f90a63          	beq	s2,a5,8000577c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000560c:	1b590463          	beq	s2,s5,800057b4 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005610:	8556                	mv	a0,s5
    80005612:	c9dff0ef          	jal	800052ae <consputc>
      consputc(c0);
    80005616:	854a                	mv	a0,s2
    80005618:	c97ff0ef          	jal	800052ae <consputc>
    8000561c:	b745                	j	800055bc <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    8000561e:	f8843783          	ld	a5,-120(s0)
    80005622:	00878713          	addi	a4,a5,8
    80005626:	f8e43423          	sd	a4,-120(s0)
    8000562a:	4605                	li	a2,1
    8000562c:	45a9                	li	a1,10
    8000562e:	4388                	lw	a0,0(a5)
    80005630:	e6fff0ef          	jal	8000549e <printint>
    80005634:	b761                	j	800055bc <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    80005636:	03678663          	beq	a5,s6,80005662 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000563a:	05878263          	beq	a5,s8,8000567e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    8000563e:	0b978463          	beq	a5,s9,800056e6 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    80005642:	fda797e3          	bne	a5,s10,80005610 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005646:	f8843783          	ld	a5,-120(s0)
    8000564a:	00878713          	addi	a4,a5,8
    8000564e:	f8e43423          	sd	a4,-120(s0)
    80005652:	4601                	li	a2,0
    80005654:	45c1                	li	a1,16
    80005656:	6388                	ld	a0,0(a5)
    80005658:	e47ff0ef          	jal	8000549e <printint>
      i += 1;
    8000565c:	0029849b          	addiw	s1,s3,2
    80005660:	bfb1                	j	800055bc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005662:	f8843783          	ld	a5,-120(s0)
    80005666:	00878713          	addi	a4,a5,8
    8000566a:	f8e43423          	sd	a4,-120(s0)
    8000566e:	4605                	li	a2,1
    80005670:	45a9                	li	a1,10
    80005672:	6388                	ld	a0,0(a5)
    80005674:	e2bff0ef          	jal	8000549e <printint>
      i += 1;
    80005678:	0029849b          	addiw	s1,s3,2
    8000567c:	b781                	j	800055bc <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000567e:	06400793          	li	a5,100
    80005682:	02f68863          	beq	a3,a5,800056b2 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005686:	07500793          	li	a5,117
    8000568a:	06f68c63          	beq	a3,a5,80005702 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000568e:	07800793          	li	a5,120
    80005692:	f6f69fe3          	bne	a3,a5,80005610 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005696:	f8843783          	ld	a5,-120(s0)
    8000569a:	00878713          	addi	a4,a5,8
    8000569e:	f8e43423          	sd	a4,-120(s0)
    800056a2:	4601                	li	a2,0
    800056a4:	45c1                	li	a1,16
    800056a6:	6388                	ld	a0,0(a5)
    800056a8:	df7ff0ef          	jal	8000549e <printint>
      i += 2;
    800056ac:	0039849b          	addiw	s1,s3,3
    800056b0:	b731                	j	800055bc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800056b2:	f8843783          	ld	a5,-120(s0)
    800056b6:	00878713          	addi	a4,a5,8
    800056ba:	f8e43423          	sd	a4,-120(s0)
    800056be:	4605                	li	a2,1
    800056c0:	45a9                	li	a1,10
    800056c2:	6388                	ld	a0,0(a5)
    800056c4:	ddbff0ef          	jal	8000549e <printint>
      i += 2;
    800056c8:	0039849b          	addiw	s1,s3,3
    800056cc:	bdc5                	j	800055bc <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800056ce:	f8843783          	ld	a5,-120(s0)
    800056d2:	00878713          	addi	a4,a5,8
    800056d6:	f8e43423          	sd	a4,-120(s0)
    800056da:	4601                	li	a2,0
    800056dc:	45a9                	li	a1,10
    800056de:	4388                	lw	a0,0(a5)
    800056e0:	dbfff0ef          	jal	8000549e <printint>
    800056e4:	bde1                	j	800055bc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800056e6:	f8843783          	ld	a5,-120(s0)
    800056ea:	00878713          	addi	a4,a5,8
    800056ee:	f8e43423          	sd	a4,-120(s0)
    800056f2:	4601                	li	a2,0
    800056f4:	45a9                	li	a1,10
    800056f6:	6388                	ld	a0,0(a5)
    800056f8:	da7ff0ef          	jal	8000549e <printint>
      i += 1;
    800056fc:	0029849b          	addiw	s1,s3,2
    80005700:	bd75                	j	800055bc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005702:	f8843783          	ld	a5,-120(s0)
    80005706:	00878713          	addi	a4,a5,8
    8000570a:	f8e43423          	sd	a4,-120(s0)
    8000570e:	4601                	li	a2,0
    80005710:	45a9                	li	a1,10
    80005712:	6388                	ld	a0,0(a5)
    80005714:	d8bff0ef          	jal	8000549e <printint>
      i += 2;
    80005718:	0039849b          	addiw	s1,s3,3
    8000571c:	b545                	j	800055bc <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    8000571e:	f8843783          	ld	a5,-120(s0)
    80005722:	00878713          	addi	a4,a5,8
    80005726:	f8e43423          	sd	a4,-120(s0)
    8000572a:	4601                	li	a2,0
    8000572c:	45c1                	li	a1,16
    8000572e:	4388                	lw	a0,0(a5)
    80005730:	d6fff0ef          	jal	8000549e <printint>
    80005734:	b561                	j	800055bc <printf+0x8c>
    80005736:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    80005738:	f8843783          	ld	a5,-120(s0)
    8000573c:	00878713          	addi	a4,a5,8
    80005740:	f8e43423          	sd	a4,-120(s0)
    80005744:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005748:	03000513          	li	a0,48
    8000574c:	b63ff0ef          	jal	800052ae <consputc>
  consputc('x');
    80005750:	07800513          	li	a0,120
    80005754:	b5bff0ef          	jal	800052ae <consputc>
    80005758:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000575a:	00002b97          	auipc	s7,0x2
    8000575e:	37eb8b93          	addi	s7,s7,894 # 80007ad8 <digits>
    80005762:	03c9d793          	srli	a5,s3,0x3c
    80005766:	97de                	add	a5,a5,s7
    80005768:	0007c503          	lbu	a0,0(a5)
    8000576c:	b43ff0ef          	jal	800052ae <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005770:	0992                	slli	s3,s3,0x4
    80005772:	397d                	addiw	s2,s2,-1
    80005774:	fe0917e3          	bnez	s2,80005762 <printf+0x232>
    80005778:	6ba6                	ld	s7,72(sp)
    8000577a:	b589                	j	800055bc <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000577c:	f8843783          	ld	a5,-120(s0)
    80005780:	00878713          	addi	a4,a5,8
    80005784:	f8e43423          	sd	a4,-120(s0)
    80005788:	0007b903          	ld	s2,0(a5)
    8000578c:	00090d63          	beqz	s2,800057a6 <printf+0x276>
      for(; *s; s++)
    80005790:	00094503          	lbu	a0,0(s2)
    80005794:	e20504e3          	beqz	a0,800055bc <printf+0x8c>
        consputc(*s);
    80005798:	b17ff0ef          	jal	800052ae <consputc>
      for(; *s; s++)
    8000579c:	0905                	addi	s2,s2,1
    8000579e:	00094503          	lbu	a0,0(s2)
    800057a2:	f97d                	bnez	a0,80005798 <printf+0x268>
    800057a4:	bd21                	j	800055bc <printf+0x8c>
        s = "(null)";
    800057a6:	00002917          	auipc	s2,0x2
    800057aa:	0e290913          	addi	s2,s2,226 # 80007888 <etext+0x888>
      for(; *s; s++)
    800057ae:	02800513          	li	a0,40
    800057b2:	b7dd                	j	80005798 <printf+0x268>
      consputc('%');
    800057b4:	02500513          	li	a0,37
    800057b8:	af7ff0ef          	jal	800052ae <consputc>
    800057bc:	b501                	j	800055bc <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800057be:	f7843783          	ld	a5,-136(s0)
    800057c2:	e385                	bnez	a5,800057e2 <printf+0x2b2>
    800057c4:	74e6                	ld	s1,120(sp)
    800057c6:	7946                	ld	s2,112(sp)
    800057c8:	79a6                	ld	s3,104(sp)
    800057ca:	6ae6                	ld	s5,88(sp)
    800057cc:	6b46                	ld	s6,80(sp)
    800057ce:	6c06                	ld	s8,64(sp)
    800057d0:	7ce2                	ld	s9,56(sp)
    800057d2:	7d42                	ld	s10,48(sp)
    800057d4:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800057d6:	4501                	li	a0,0
    800057d8:	60aa                	ld	ra,136(sp)
    800057da:	640a                	ld	s0,128(sp)
    800057dc:	7a06                	ld	s4,96(sp)
    800057de:	6169                	addi	sp,sp,208
    800057e0:	8082                	ret
    800057e2:	74e6                	ld	s1,120(sp)
    800057e4:	7946                	ld	s2,112(sp)
    800057e6:	79a6                	ld	s3,104(sp)
    800057e8:	6ae6                	ld	s5,88(sp)
    800057ea:	6b46                	ld	s6,80(sp)
    800057ec:	6c06                	ld	s8,64(sp)
    800057ee:	7ce2                	ld	s9,56(sp)
    800057f0:	7d42                	ld	s10,48(sp)
    800057f2:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    800057f4:	0001e517          	auipc	a0,0x1e
    800057f8:	53450513          	addi	a0,a0,1332 # 80023d28 <pr>
    800057fc:	3cc000ef          	jal	80005bc8 <release>
    80005800:	bfd9                	j	800057d6 <printf+0x2a6>

0000000080005802 <panic>:

void
panic(char *s)
{
    80005802:	1101                	addi	sp,sp,-32
    80005804:	ec06                	sd	ra,24(sp)
    80005806:	e822                	sd	s0,16(sp)
    80005808:	e426                	sd	s1,8(sp)
    8000580a:	1000                	addi	s0,sp,32
    8000580c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000580e:	0001e797          	auipc	a5,0x1e
    80005812:	5207a923          	sw	zero,1330(a5) # 80023d40 <pr+0x18>
  printf("panic: ");
    80005816:	00002517          	auipc	a0,0x2
    8000581a:	07a50513          	addi	a0,a0,122 # 80007890 <etext+0x890>
    8000581e:	d13ff0ef          	jal	80005530 <printf>
  printf("%s\n", s);
    80005822:	85a6                	mv	a1,s1
    80005824:	00002517          	auipc	a0,0x2
    80005828:	07450513          	addi	a0,a0,116 # 80007898 <etext+0x898>
    8000582c:	d05ff0ef          	jal	80005530 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005830:	4785                	li	a5,1
    80005832:	00005717          	auipc	a4,0x5
    80005836:	e0f72523          	sw	a5,-502(a4) # 8000a63c <panicked>
  for(;;)
    8000583a:	a001                	j	8000583a <panic+0x38>

000000008000583c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000583c:	1101                	addi	sp,sp,-32
    8000583e:	ec06                	sd	ra,24(sp)
    80005840:	e822                	sd	s0,16(sp)
    80005842:	e426                	sd	s1,8(sp)
    80005844:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005846:	0001e497          	auipc	s1,0x1e
    8000584a:	4e248493          	addi	s1,s1,1250 # 80023d28 <pr>
    8000584e:	00002597          	auipc	a1,0x2
    80005852:	05258593          	addi	a1,a1,82 # 800078a0 <etext+0x8a0>
    80005856:	8526                	mv	a0,s1
    80005858:	258000ef          	jal	80005ab0 <initlock>
  pr.locking = 1;
    8000585c:	4785                	li	a5,1
    8000585e:	cc9c                	sw	a5,24(s1)
}
    80005860:	60e2                	ld	ra,24(sp)
    80005862:	6442                	ld	s0,16(sp)
    80005864:	64a2                	ld	s1,8(sp)
    80005866:	6105                	addi	sp,sp,32
    80005868:	8082                	ret

000000008000586a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000586a:	1141                	addi	sp,sp,-16
    8000586c:	e406                	sd	ra,8(sp)
    8000586e:	e022                	sd	s0,0(sp)
    80005870:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005872:	100007b7          	lui	a5,0x10000
    80005876:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000587a:	10000737          	lui	a4,0x10000
    8000587e:	f8000693          	li	a3,-128
    80005882:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005886:	468d                	li	a3,3
    80005888:	10000637          	lui	a2,0x10000
    8000588c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005890:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005894:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005898:	10000737          	lui	a4,0x10000
    8000589c:	461d                	li	a2,7
    8000589e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800058a2:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800058a6:	00002597          	auipc	a1,0x2
    800058aa:	00258593          	addi	a1,a1,2 # 800078a8 <etext+0x8a8>
    800058ae:	0001e517          	auipc	a0,0x1e
    800058b2:	49a50513          	addi	a0,a0,1178 # 80023d48 <uart_tx_lock>
    800058b6:	1fa000ef          	jal	80005ab0 <initlock>
}
    800058ba:	60a2                	ld	ra,8(sp)
    800058bc:	6402                	ld	s0,0(sp)
    800058be:	0141                	addi	sp,sp,16
    800058c0:	8082                	ret

00000000800058c2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800058c2:	1101                	addi	sp,sp,-32
    800058c4:	ec06                	sd	ra,24(sp)
    800058c6:	e822                	sd	s0,16(sp)
    800058c8:	e426                	sd	s1,8(sp)
    800058ca:	1000                	addi	s0,sp,32
    800058cc:	84aa                	mv	s1,a0
  push_off();
    800058ce:	222000ef          	jal	80005af0 <push_off>

  if(panicked){
    800058d2:	00005797          	auipc	a5,0x5
    800058d6:	d6a7a783          	lw	a5,-662(a5) # 8000a63c <panicked>
    800058da:	e795                	bnez	a5,80005906 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800058dc:	10000737          	lui	a4,0x10000
    800058e0:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800058e2:	00074783          	lbu	a5,0(a4)
    800058e6:	0207f793          	andi	a5,a5,32
    800058ea:	dfe5                	beqz	a5,800058e2 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800058ec:	0ff4f513          	zext.b	a0,s1
    800058f0:	100007b7          	lui	a5,0x10000
    800058f4:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800058f8:	27c000ef          	jal	80005b74 <pop_off>
}
    800058fc:	60e2                	ld	ra,24(sp)
    800058fe:	6442                	ld	s0,16(sp)
    80005900:	64a2                	ld	s1,8(sp)
    80005902:	6105                	addi	sp,sp,32
    80005904:	8082                	ret
    for(;;)
    80005906:	a001                	j	80005906 <uartputc_sync+0x44>

0000000080005908 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005908:	00005797          	auipc	a5,0x5
    8000590c:	d387b783          	ld	a5,-712(a5) # 8000a640 <uart_tx_r>
    80005910:	00005717          	auipc	a4,0x5
    80005914:	d3873703          	ld	a4,-712(a4) # 8000a648 <uart_tx_w>
    80005918:	08f70263          	beq	a4,a5,8000599c <uartstart+0x94>
{
    8000591c:	7139                	addi	sp,sp,-64
    8000591e:	fc06                	sd	ra,56(sp)
    80005920:	f822                	sd	s0,48(sp)
    80005922:	f426                	sd	s1,40(sp)
    80005924:	f04a                	sd	s2,32(sp)
    80005926:	ec4e                	sd	s3,24(sp)
    80005928:	e852                	sd	s4,16(sp)
    8000592a:	e456                	sd	s5,8(sp)
    8000592c:	e05a                	sd	s6,0(sp)
    8000592e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005930:	10000937          	lui	s2,0x10000
    80005934:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005936:	0001ea97          	auipc	s5,0x1e
    8000593a:	412a8a93          	addi	s5,s5,1042 # 80023d48 <uart_tx_lock>
    uart_tx_r += 1;
    8000593e:	00005497          	auipc	s1,0x5
    80005942:	d0248493          	addi	s1,s1,-766 # 8000a640 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005946:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000594a:	00005997          	auipc	s3,0x5
    8000594e:	cfe98993          	addi	s3,s3,-770 # 8000a648 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005952:	00094703          	lbu	a4,0(s2)
    80005956:	02077713          	andi	a4,a4,32
    8000595a:	c71d                	beqz	a4,80005988 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000595c:	01f7f713          	andi	a4,a5,31
    80005960:	9756                	add	a4,a4,s5
    80005962:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005966:	0785                	addi	a5,a5,1
    80005968:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000596a:	8526                	mv	a0,s1
    8000596c:	a11fb0ef          	jal	8000137c <wakeup>
    WriteReg(THR, c);
    80005970:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005974:	609c                	ld	a5,0(s1)
    80005976:	0009b703          	ld	a4,0(s3)
    8000597a:	fcf71ce3          	bne	a4,a5,80005952 <uartstart+0x4a>
      ReadReg(ISR);
    8000597e:	100007b7          	lui	a5,0x10000
    80005982:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005984:	0007c783          	lbu	a5,0(a5)
  }
}
    80005988:	70e2                	ld	ra,56(sp)
    8000598a:	7442                	ld	s0,48(sp)
    8000598c:	74a2                	ld	s1,40(sp)
    8000598e:	7902                	ld	s2,32(sp)
    80005990:	69e2                	ld	s3,24(sp)
    80005992:	6a42                	ld	s4,16(sp)
    80005994:	6aa2                	ld	s5,8(sp)
    80005996:	6b02                	ld	s6,0(sp)
    80005998:	6121                	addi	sp,sp,64
    8000599a:	8082                	ret
      ReadReg(ISR);
    8000599c:	100007b7          	lui	a5,0x10000
    800059a0:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800059a2:	0007c783          	lbu	a5,0(a5)
      return;
    800059a6:	8082                	ret

00000000800059a8 <uartputc>:
{
    800059a8:	7179                	addi	sp,sp,-48
    800059aa:	f406                	sd	ra,40(sp)
    800059ac:	f022                	sd	s0,32(sp)
    800059ae:	ec26                	sd	s1,24(sp)
    800059b0:	e84a                	sd	s2,16(sp)
    800059b2:	e44e                	sd	s3,8(sp)
    800059b4:	e052                	sd	s4,0(sp)
    800059b6:	1800                	addi	s0,sp,48
    800059b8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800059ba:	0001e517          	auipc	a0,0x1e
    800059be:	38e50513          	addi	a0,a0,910 # 80023d48 <uart_tx_lock>
    800059c2:	16e000ef          	jal	80005b30 <acquire>
  if(panicked){
    800059c6:	00005797          	auipc	a5,0x5
    800059ca:	c767a783          	lw	a5,-906(a5) # 8000a63c <panicked>
    800059ce:	efbd                	bnez	a5,80005a4c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800059d0:	00005717          	auipc	a4,0x5
    800059d4:	c7873703          	ld	a4,-904(a4) # 8000a648 <uart_tx_w>
    800059d8:	00005797          	auipc	a5,0x5
    800059dc:	c687b783          	ld	a5,-920(a5) # 8000a640 <uart_tx_r>
    800059e0:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800059e4:	0001e997          	auipc	s3,0x1e
    800059e8:	36498993          	addi	s3,s3,868 # 80023d48 <uart_tx_lock>
    800059ec:	00005497          	auipc	s1,0x5
    800059f0:	c5448493          	addi	s1,s1,-940 # 8000a640 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800059f4:	00005917          	auipc	s2,0x5
    800059f8:	c5490913          	addi	s2,s2,-940 # 8000a648 <uart_tx_w>
    800059fc:	00e79d63          	bne	a5,a4,80005a16 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005a00:	85ce                	mv	a1,s3
    80005a02:	8526                	mv	a0,s1
    80005a04:	92dfb0ef          	jal	80001330 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005a08:	00093703          	ld	a4,0(s2)
    80005a0c:	609c                	ld	a5,0(s1)
    80005a0e:	02078793          	addi	a5,a5,32
    80005a12:	fee787e3          	beq	a5,a4,80005a00 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005a16:	0001e497          	auipc	s1,0x1e
    80005a1a:	33248493          	addi	s1,s1,818 # 80023d48 <uart_tx_lock>
    80005a1e:	01f77793          	andi	a5,a4,31
    80005a22:	97a6                	add	a5,a5,s1
    80005a24:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005a28:	0705                	addi	a4,a4,1
    80005a2a:	00005797          	auipc	a5,0x5
    80005a2e:	c0e7bf23          	sd	a4,-994(a5) # 8000a648 <uart_tx_w>
  uartstart();
    80005a32:	ed7ff0ef          	jal	80005908 <uartstart>
  release(&uart_tx_lock);
    80005a36:	8526                	mv	a0,s1
    80005a38:	190000ef          	jal	80005bc8 <release>
}
    80005a3c:	70a2                	ld	ra,40(sp)
    80005a3e:	7402                	ld	s0,32(sp)
    80005a40:	64e2                	ld	s1,24(sp)
    80005a42:	6942                	ld	s2,16(sp)
    80005a44:	69a2                	ld	s3,8(sp)
    80005a46:	6a02                	ld	s4,0(sp)
    80005a48:	6145                	addi	sp,sp,48
    80005a4a:	8082                	ret
    for(;;)
    80005a4c:	a001                	j	80005a4c <uartputc+0xa4>

0000000080005a4e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005a4e:	1141                	addi	sp,sp,-16
    80005a50:	e422                	sd	s0,8(sp)
    80005a52:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005a54:	100007b7          	lui	a5,0x10000
    80005a58:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80005a5a:	0007c783          	lbu	a5,0(a5)
    80005a5e:	8b85                	andi	a5,a5,1
    80005a60:	cb81                	beqz	a5,80005a70 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005a62:	100007b7          	lui	a5,0x10000
    80005a66:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005a6a:	6422                	ld	s0,8(sp)
    80005a6c:	0141                	addi	sp,sp,16
    80005a6e:	8082                	ret
    return -1;
    80005a70:	557d                	li	a0,-1
    80005a72:	bfe5                	j	80005a6a <uartgetc+0x1c>

0000000080005a74 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005a74:	1101                	addi	sp,sp,-32
    80005a76:	ec06                	sd	ra,24(sp)
    80005a78:	e822                	sd	s0,16(sp)
    80005a7a:	e426                	sd	s1,8(sp)
    80005a7c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005a7e:	54fd                	li	s1,-1
    80005a80:	a019                	j	80005a86 <uartintr+0x12>
      break;
    consoleintr(c);
    80005a82:	85fff0ef          	jal	800052e0 <consoleintr>
    int c = uartgetc();
    80005a86:	fc9ff0ef          	jal	80005a4e <uartgetc>
    if(c == -1)
    80005a8a:	fe951ce3          	bne	a0,s1,80005a82 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80005a8e:	0001e497          	auipc	s1,0x1e
    80005a92:	2ba48493          	addi	s1,s1,698 # 80023d48 <uart_tx_lock>
    80005a96:	8526                	mv	a0,s1
    80005a98:	098000ef          	jal	80005b30 <acquire>
  uartstart();
    80005a9c:	e6dff0ef          	jal	80005908 <uartstart>
  release(&uart_tx_lock);
    80005aa0:	8526                	mv	a0,s1
    80005aa2:	126000ef          	jal	80005bc8 <release>
}
    80005aa6:	60e2                	ld	ra,24(sp)
    80005aa8:	6442                	ld	s0,16(sp)
    80005aaa:	64a2                	ld	s1,8(sp)
    80005aac:	6105                	addi	sp,sp,32
    80005aae:	8082                	ret

0000000080005ab0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005ab0:	1141                	addi	sp,sp,-16
    80005ab2:	e422                	sd	s0,8(sp)
    80005ab4:	0800                	addi	s0,sp,16
  lk->name = name;
    80005ab6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005ab8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005abc:	00053823          	sd	zero,16(a0)
}
    80005ac0:	6422                	ld	s0,8(sp)
    80005ac2:	0141                	addi	sp,sp,16
    80005ac4:	8082                	ret

0000000080005ac6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005ac6:	411c                	lw	a5,0(a0)
    80005ac8:	e399                	bnez	a5,80005ace <holding+0x8>
    80005aca:	4501                	li	a0,0
  return r;
}
    80005acc:	8082                	ret
{
    80005ace:	1101                	addi	sp,sp,-32
    80005ad0:	ec06                	sd	ra,24(sp)
    80005ad2:	e822                	sd	s0,16(sp)
    80005ad4:	e426                	sd	s1,8(sp)
    80005ad6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005ad8:	6904                	ld	s1,16(a0)
    80005ada:	a60fb0ef          	jal	80000d3a <mycpu>
    80005ade:	40a48533          	sub	a0,s1,a0
    80005ae2:	00153513          	seqz	a0,a0
}
    80005ae6:	60e2                	ld	ra,24(sp)
    80005ae8:	6442                	ld	s0,16(sp)
    80005aea:	64a2                	ld	s1,8(sp)
    80005aec:	6105                	addi	sp,sp,32
    80005aee:	8082                	ret

0000000080005af0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005af0:	1101                	addi	sp,sp,-32
    80005af2:	ec06                	sd	ra,24(sp)
    80005af4:	e822                	sd	s0,16(sp)
    80005af6:	e426                	sd	s1,8(sp)
    80005af8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005afa:	100024f3          	csrr	s1,sstatus
    80005afe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005b02:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005b04:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005b08:	a32fb0ef          	jal	80000d3a <mycpu>
    80005b0c:	5d3c                	lw	a5,120(a0)
    80005b0e:	cb99                	beqz	a5,80005b24 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005b10:	a2afb0ef          	jal	80000d3a <mycpu>
    80005b14:	5d3c                	lw	a5,120(a0)
    80005b16:	2785                	addiw	a5,a5,1
    80005b18:	dd3c                	sw	a5,120(a0)
}
    80005b1a:	60e2                	ld	ra,24(sp)
    80005b1c:	6442                	ld	s0,16(sp)
    80005b1e:	64a2                	ld	s1,8(sp)
    80005b20:	6105                	addi	sp,sp,32
    80005b22:	8082                	ret
    mycpu()->intena = old;
    80005b24:	a16fb0ef          	jal	80000d3a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005b28:	8085                	srli	s1,s1,0x1
    80005b2a:	8885                	andi	s1,s1,1
    80005b2c:	dd64                	sw	s1,124(a0)
    80005b2e:	b7cd                	j	80005b10 <push_off+0x20>

0000000080005b30 <acquire>:
{
    80005b30:	1101                	addi	sp,sp,-32
    80005b32:	ec06                	sd	ra,24(sp)
    80005b34:	e822                	sd	s0,16(sp)
    80005b36:	e426                	sd	s1,8(sp)
    80005b38:	1000                	addi	s0,sp,32
    80005b3a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005b3c:	fb5ff0ef          	jal	80005af0 <push_off>
  if(holding(lk))
    80005b40:	8526                	mv	a0,s1
    80005b42:	f85ff0ef          	jal	80005ac6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005b46:	4705                	li	a4,1
  if(holding(lk))
    80005b48:	e105                	bnez	a0,80005b68 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005b4a:	87ba                	mv	a5,a4
    80005b4c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005b50:	2781                	sext.w	a5,a5
    80005b52:	ffe5                	bnez	a5,80005b4a <acquire+0x1a>
  __sync_synchronize();
    80005b54:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005b58:	9e2fb0ef          	jal	80000d3a <mycpu>
    80005b5c:	e888                	sd	a0,16(s1)
}
    80005b5e:	60e2                	ld	ra,24(sp)
    80005b60:	6442                	ld	s0,16(sp)
    80005b62:	64a2                	ld	s1,8(sp)
    80005b64:	6105                	addi	sp,sp,32
    80005b66:	8082                	ret
    panic("acquire");
    80005b68:	00002517          	auipc	a0,0x2
    80005b6c:	d4850513          	addi	a0,a0,-696 # 800078b0 <etext+0x8b0>
    80005b70:	c93ff0ef          	jal	80005802 <panic>

0000000080005b74 <pop_off>:

void
pop_off(void)
{
    80005b74:	1141                	addi	sp,sp,-16
    80005b76:	e406                	sd	ra,8(sp)
    80005b78:	e022                	sd	s0,0(sp)
    80005b7a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005b7c:	9befb0ef          	jal	80000d3a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005b80:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005b84:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005b86:	e78d                	bnez	a5,80005bb0 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005b88:	5d3c                	lw	a5,120(a0)
    80005b8a:	02f05963          	blez	a5,80005bbc <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80005b8e:	37fd                	addiw	a5,a5,-1
    80005b90:	0007871b          	sext.w	a4,a5
    80005b94:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005b96:	eb09                	bnez	a4,80005ba8 <pop_off+0x34>
    80005b98:	5d7c                	lw	a5,124(a0)
    80005b9a:	c799                	beqz	a5,80005ba8 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005b9c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005ba0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005ba4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005ba8:	60a2                	ld	ra,8(sp)
    80005baa:	6402                	ld	s0,0(sp)
    80005bac:	0141                	addi	sp,sp,16
    80005bae:	8082                	ret
    panic("pop_off - interruptible");
    80005bb0:	00002517          	auipc	a0,0x2
    80005bb4:	d0850513          	addi	a0,a0,-760 # 800078b8 <etext+0x8b8>
    80005bb8:	c4bff0ef          	jal	80005802 <panic>
    panic("pop_off");
    80005bbc:	00002517          	auipc	a0,0x2
    80005bc0:	d1450513          	addi	a0,a0,-748 # 800078d0 <etext+0x8d0>
    80005bc4:	c3fff0ef          	jal	80005802 <panic>

0000000080005bc8 <release>:
{
    80005bc8:	1101                	addi	sp,sp,-32
    80005bca:	ec06                	sd	ra,24(sp)
    80005bcc:	e822                	sd	s0,16(sp)
    80005bce:	e426                	sd	s1,8(sp)
    80005bd0:	1000                	addi	s0,sp,32
    80005bd2:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005bd4:	ef3ff0ef          	jal	80005ac6 <holding>
    80005bd8:	c105                	beqz	a0,80005bf8 <release+0x30>
  lk->cpu = 0;
    80005bda:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005bde:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005be2:	0310000f          	fence	rw,w
    80005be6:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005bea:	f8bff0ef          	jal	80005b74 <pop_off>
}
    80005bee:	60e2                	ld	ra,24(sp)
    80005bf0:	6442                	ld	s0,16(sp)
    80005bf2:	64a2                	ld	s1,8(sp)
    80005bf4:	6105                	addi	sp,sp,32
    80005bf6:	8082                	ret
    panic("release");
    80005bf8:	00002517          	auipc	a0,0x2
    80005bfc:	ce050513          	addi	a0,a0,-800 # 800078d8 <etext+0x8d8>
    80005c00:	c03ff0ef          	jal	80005802 <panic>
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
