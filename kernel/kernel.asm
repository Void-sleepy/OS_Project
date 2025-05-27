
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	65013103          	ld	sp,1616(sp) # 8000a650 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0f8050ef          	jal	8000510e <start>

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
    80000034:	c1078793          	addi	a5,a5,-1008 # 80023c40 <end>
    80000038:	02f56b63          	bltu	a0,a5,8000006e <kfree+0x52>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57763          	bgeu	a0,a5,8000006e <kfree+0x52>
  memset(pa, 1, PGSIZE);
#endif
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000044:	0000a917          	auipc	s2,0xa
    80000048:	65c90913          	addi	s2,s2,1628 # 8000a6a0 <kmem>
    8000004c:	854a                	mv	a0,s2
    8000004e:	323050ef          	jal	80005b70 <acquire>
  r->next = kmem.freelist;
    80000052:	01893783          	ld	a5,24(s2)
    80000056:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000058:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000005c:	854a                	mv	a0,s2
    8000005e:	3ab050ef          	jal	80005c08 <release>
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
    80000076:	7cc050ef          	jal	80005842 <panic>

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
    800000d6:	5ce50513          	addi	a0,a0,1486 # 8000a6a0 <kmem>
    800000da:	217050ef          	jal	80005af0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000de:	45c5                	li	a1,17
    800000e0:	05ee                	slli	a1,a1,0x1b
    800000e2:	00024517          	auipc	a0,0x24
    800000e6:	b5e50513          	addi	a0,a0,-1186 # 80023c40 <end>
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
    80000104:	5a048493          	addi	s1,s1,1440 # 8000a6a0 <kmem>
    80000108:	8526                	mv	a0,s1
    8000010a:	267050ef          	jal	80005b70 <acquire>
  r = kmem.freelist;
    8000010e:	6c84                	ld	s1,24(s1)
  if(r) {
    80000110:	c491                	beqz	s1,8000011c <kalloc+0x26>
    kmem.freelist = r->next;
    80000112:	609c                	ld	a5,0(s1)
    80000114:	0000a717          	auipc	a4,0xa
    80000118:	5af73223          	sd	a5,1444(a4) # 8000a6b8 <kmem+0x18>
  }
  release(&kmem.lock);
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	58450513          	addi	a0,a0,1412 # 8000a6a0 <kmem>
    80000124:	2e5050ef          	jal	80005c08 <release>
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
    800002de:	39670713          	addi	a4,a4,918 # 8000a670 <started>
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
    800002fc:	274050ef          	jal	80005570 <printf>
    kvminithart();    // turn on paging
    80000300:	080000ef          	jal	80000380 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000304:	54e010ef          	jal	80001852 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000308:	021040ef          	jal	80004b28 <plicinithart>
  }

  scheduler();        
    8000030c:	68b000ef          	jal	80001196 <scheduler>
    consoleinit();
    80000310:	18a050ef          	jal	8000549a <consoleinit>
    printfinit();
    80000314:	568050ef          	jal	8000587c <printfinit>
    printf("\n");
    80000318:	00007517          	auipc	a0,0x7
    8000031c:	d0050513          	addi	a0,a0,-768 # 80007018 <etext+0x18>
    80000320:	250050ef          	jal	80005570 <printf>
    printf("xv6 kernel is booting\n");
    80000324:	00007517          	auipc	a0,0x7
    80000328:	cfc50513          	addi	a0,a0,-772 # 80007020 <etext+0x20>
    8000032c:	244050ef          	jal	80005570 <printf>
    printf("\n");
    80000330:	00007517          	auipc	a0,0x7
    80000334:	ce850513          	addi	a0,a0,-792 # 80007018 <etext+0x18>
    80000338:	238050ef          	jal	80005570 <printf>
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
    80000354:	7ba040ef          	jal	80004b0e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000358:	7d0040ef          	jal	80004b28 <plicinithart>
    binit();         // buffer cache
    8000035c:	6d1010ef          	jal	8000222c <binit>
    iinit();         // inode table
    80000360:	4c2020ef          	jal	80002822 <iinit>
    fileinit();      // file table
    80000364:	26e030ef          	jal	800035d2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000368:	0b1040ef          	jal	80004c18 <virtio_disk_init>
    userinit();      // first user process
    8000036c:	457000ef          	jal	80000fc2 <userinit>
    __sync_synchronize();
    80000370:	0330000f          	fence	rw,rw
    started = 1;
    80000374:	4785                	li	a5,1
    80000376:	0000a717          	auipc	a4,0xa
    8000037a:	2ef72d23          	sw	a5,762(a4) # 8000a670 <started>
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
    8000038e:	2ee7b783          	ld	a5,750(a5) # 8000a678 <kernel_pagetable>
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
    800003d6:	46c050ef          	jal	80005842 <panic>
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
    800003fc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb3b7>
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
    800004ec:	356050ef          	jal	80005842 <panic>
    panic("mappages: size not aligned");
    800004f0:	00007517          	auipc	a0,0x7
    800004f4:	b8850513          	addi	a0,a0,-1144 # 80007078 <etext+0x78>
    800004f8:	34a050ef          	jal	80005842 <panic>
    panic("mappages: size");
    800004fc:	00007517          	auipc	a0,0x7
    80000500:	b9c50513          	addi	a0,a0,-1124 # 80007098 <etext+0x98>
    80000504:	33e050ef          	jal	80005842 <panic>
      panic("mappages: remap");
    80000508:	00007517          	auipc	a0,0x7
    8000050c:	ba050513          	addi	a0,a0,-1120 # 800070a8 <etext+0xa8>
    80000510:	332050ef          	jal	80005842 <panic>
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
    80000554:	2ee050ef          	jal	80005842 <panic>

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
    8000061a:	06a7b123          	sd	a0,98(a5) # 8000a678 <kernel_pagetable>
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
    8000066e:	1d4050ef          	jal	80005842 <panic>
      panic("uvmunmap: walk");
    80000672:	00007517          	auipc	a0,0x7
    80000676:	a6650513          	addi	a0,a0,-1434 # 800070d8 <etext+0xd8>
    8000067a:	1c8050ef          	jal	80005842 <panic>
      printf("va=%ld pte=%ld\n", a, *pte);
    8000067e:	85ca                	mv	a1,s2
    80000680:	00007517          	auipc	a0,0x7
    80000684:	a6850513          	addi	a0,a0,-1432 # 800070e8 <etext+0xe8>
    80000688:	6e9040ef          	jal	80005570 <printf>
      panic("uvmunmap: not mapped");
    8000068c:	00007517          	auipc	a0,0x7
    80000690:	a6c50513          	addi	a0,a0,-1428 # 800070f8 <etext+0xf8>
    80000694:	1ae050ef          	jal	80005842 <panic>
      panic("uvmunmap: not a leaf");
    80000698:	00007517          	auipc	a0,0x7
    8000069c:	a7850513          	addi	a0,a0,-1416 # 80007110 <etext+0x110>
    800006a0:	1a2050ef          	jal	80005842 <panic>
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
    80000772:	0d0050ef          	jal	80005842 <panic>

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
    8000089e:	7a5040ef          	jal	80005842 <panic>
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
    8000095c:	6e7040ef          	jal	80005842 <panic>
      panic("uvmcopy: page not present");
    80000960:	00007517          	auipc	a0,0x7
    80000964:	81850513          	addi	a0,a0,-2024 # 80007178 <etext+0x178>
    80000968:	6db040ef          	jal	80005842 <panic>
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
    800009c2:	681040ef          	jal	80005842 <panic>

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
    80000bf6:	efe48493          	addi	s1,s1,-258 # 8000aaf0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000bfa:	8b26                	mv	s6,s1
    80000bfc:	ff4df937          	lui	s2,0xff4df
    80000c00:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bad7d>
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
    80000c22:	ad2a8a93          	addi	s5,s5,-1326 # 800106f0 <tickslock>
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
    80000c70:	3d3040ef          	jal	80005842 <panic>

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
    80000c94:	a3050513          	addi	a0,a0,-1488 # 8000a6c0 <pid_lock>
    80000c98:	659040ef          	jal	80005af0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000c9c:	00006597          	auipc	a1,0x6
    80000ca0:	51c58593          	addi	a1,a1,1308 # 800071b8 <etext+0x1b8>
    80000ca4:	0000a517          	auipc	a0,0xa
    80000ca8:	a3450513          	addi	a0,a0,-1484 # 8000a6d8 <wait_lock>
    80000cac:	645040ef          	jal	80005af0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cb0:	0000a497          	auipc	s1,0xa
    80000cb4:	e4048493          	addi	s1,s1,-448 # 8000aaf0 <proc>
      initlock(&p->lock, "proc");
    80000cb8:	00006b17          	auipc	s6,0x6
    80000cbc:	510b0b13          	addi	s6,s6,1296 # 800071c8 <etext+0x1c8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cc0:	8aa6                	mv	s5,s1
    80000cc2:	ff4df937          	lui	s2,0xff4df
    80000cc6:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bad7d>
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
    80000ce8:	a0ca0a13          	addi	s4,s4,-1524 # 800106f0 <tickslock>
      initlock(&p->lock, "proc");
    80000cec:	85da                	mv	a1,s6
    80000cee:	8526                	mv	a0,s1
    80000cf0:	601040ef          	jal	80005af0 <initlock>
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
    80000d4a:	9aa50513          	addi	a0,a0,-1622 # 8000a6f0 <cpus>
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
    80000d60:	5d1040ef          	jal	80005b30 <push_off>
    80000d64:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d66:	2781                	sext.w	a5,a5
    80000d68:	079e                	slli	a5,a5,0x7
    80000d6a:	0000a717          	auipc	a4,0xa
    80000d6e:	95670713          	addi	a4,a4,-1706 # 8000a6c0 <pid_lock>
    80000d72:	97ba                	add	a5,a5,a4
    80000d74:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d76:	63f040ef          	jal	80005bb4 <pop_off>
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
    80000d92:	677040ef          	jal	80005c08 <release>

  if (first) {
    80000d96:	0000a797          	auipc	a5,0xa
    80000d9a:	86a7a783          	lw	a5,-1942(a5) # 8000a600 <first.1>
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
    80000dae:	209010ef          	jal	800027b6 <fsinit>
    first = 0;
    80000db2:	0000a797          	auipc	a5,0xa
    80000db6:	8407a723          	sw	zero,-1970(a5) # 8000a600 <first.1>
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
    80000dd0:	8f490913          	addi	s2,s2,-1804 # 8000a6c0 <pid_lock>
    80000dd4:	854a                	mv	a0,s2
    80000dd6:	59b040ef          	jal	80005b70 <acquire>
  pid = nextpid;
    80000dda:	0000a797          	auipc	a5,0xa
    80000dde:	82a78793          	addi	a5,a5,-2006 # 8000a604 <nextpid>
    80000de2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000de4:	0014871b          	addiw	a4,s1,1
    80000de8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000dea:	854a                	mv	a0,s2
    80000dec:	61d040ef          	jal	80005c08 <release>
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
    80000f28:	bcc48493          	addi	s1,s1,-1076 # 8000aaf0 <proc>
    80000f2c:	0000f917          	auipc	s2,0xf
    80000f30:	7c490913          	addi	s2,s2,1988 # 800106f0 <tickslock>
    acquire(&p->lock);
    80000f34:	8526                	mv	a0,s1
    80000f36:	43b040ef          	jal	80005b70 <acquire>
    if(p->state == UNUSED) {
    80000f3a:	4c9c                	lw	a5,24(s1)
    80000f3c:	cb91                	beqz	a5,80000f50 <allocproc+0x38>
      release(&p->lock);
    80000f3e:	8526                	mv	a0,s1
    80000f40:	4c9040ef          	jal	80005c08 <release>
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
    80000faa:	45f040ef          	jal	80005c08 <release>
    return 0;
    80000fae:	84ca                	mv	s1,s2
    80000fb0:	b7d5                	j	80000f94 <allocproc+0x7c>
    freeproc(p);
    80000fb2:	8526                	mv	a0,s1
    80000fb4:	f15ff0ef          	jal	80000ec8 <freeproc>
    release(&p->lock);
    80000fb8:	8526                	mv	a0,s1
    80000fba:	44f040ef          	jal	80005c08 <release>
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
    80000fd6:	6aa7b723          	sd	a0,1710(a5) # 8000a680 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000fda:	03400613          	li	a2,52
    80000fde:	00009597          	auipc	a1,0x9
    80000fe2:	63258593          	addi	a1,a1,1586 # 8000a610 <initcode>
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
    80001014:	0b0020ef          	jal	800030c4 <namei>
    80001018:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000101c:	478d                	li	a5,3
    8000101e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001020:	8526                	mv	a0,s1
    80001022:	3e7040ef          	jal	80005c08 <release>
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
    80001110:	2f9040ef          	jal	80005c08 <release>
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
    80001126:	52e020ef          	jal	80003654 <filedup>
    8000112a:	00a93023          	sd	a0,0(s2)
    8000112e:	b7f5                	j	8000111a <fork+0x9a>
  np->cwd = idup(p->cwd);
    80001130:	150ab503          	ld	a0,336(s5)
    80001134:	081010ef          	jal	800029b4 <idup>
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
    80001150:	2b9040ef          	jal	80005c08 <release>
  acquire(&wait_lock);
    80001154:	00009497          	auipc	s1,0x9
    80001158:	58448493          	addi	s1,s1,1412 # 8000a6d8 <wait_lock>
    8000115c:	8526                	mv	a0,s1
    8000115e:	213040ef          	jal	80005b70 <acquire>
  np->parent = p;
    80001162:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001166:	8526                	mv	a0,s1
    80001168:	2a1040ef          	jal	80005c08 <release>
  acquire(&np->lock);
    8000116c:	854e                	mv	a0,s3
    8000116e:	203040ef          	jal	80005b70 <acquire>
  np->state = RUNNABLE;
    80001172:	478d                	li	a5,3
    80001174:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001178:	854e                	mv	a0,s3
    8000117a:	28f040ef          	jal	80005c08 <release>
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
    800011ba:	50a70713          	addi	a4,a4,1290 # 8000a6c0 <pid_lock>
    800011be:	975a                	add	a4,a4,s6
    800011c0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011c4:	00009717          	auipc	a4,0x9
    800011c8:	53470713          	addi	a4,a4,1332 # 8000a6f8 <cpus+0x8>
    800011cc:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800011ce:	4c11                	li	s8,4
        c->proc = p;
    800011d0:	079e                	slli	a5,a5,0x7
    800011d2:	00009a17          	auipc	s4,0x9
    800011d6:	4eea0a13          	addi	s4,s4,1262 # 8000a6c0 <pid_lock>
    800011da:	9a3e                	add	s4,s4,a5
        found = 1;
    800011dc:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    800011de:	0000f997          	auipc	s3,0xf
    800011e2:	51298993          	addi	s3,s3,1298 # 800106f0 <tickslock>
    800011e6:	a0a9                	j	80001230 <scheduler+0x9a>
      release(&p->lock);
    800011e8:	8526                	mv	a0,s1
    800011ea:	21f040ef          	jal	80005c08 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011ee:	17048493          	addi	s1,s1,368
    800011f2:	03348563          	beq	s1,s3,8000121c <scheduler+0x86>
      acquire(&p->lock);
    800011f6:	8526                	mv	a0,s1
    800011f8:	179040ef          	jal	80005b70 <acquire>
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
    80001242:	8b248493          	addi	s1,s1,-1870 # 8000aaf0 <proc>
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
    8000125e:	0a9040ef          	jal	80005b06 <holding>
    80001262:	c92d                	beqz	a0,800012d4 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001264:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001266:	2781                	sext.w	a5,a5
    80001268:	079e                	slli	a5,a5,0x7
    8000126a:	00009717          	auipc	a4,0x9
    8000126e:	45670713          	addi	a4,a4,1110 # 8000a6c0 <pid_lock>
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
    80001294:	43090913          	addi	s2,s2,1072 # 8000a6c0 <pid_lock>
    80001298:	2781                	sext.w	a5,a5
    8000129a:	079e                	slli	a5,a5,0x7
    8000129c:	97ca                	add	a5,a5,s2
    8000129e:	0ac7a983          	lw	s3,172(a5)
    800012a2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012a4:	2781                	sext.w	a5,a5
    800012a6:	079e                	slli	a5,a5,0x7
    800012a8:	00009597          	auipc	a1,0x9
    800012ac:	45058593          	addi	a1,a1,1104 # 8000a6f8 <cpus+0x8>
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
    800012dc:	566040ef          	jal	80005842 <panic>
    panic("sched locks");
    800012e0:	00006517          	auipc	a0,0x6
    800012e4:	f1850513          	addi	a0,a0,-232 # 800071f8 <etext+0x1f8>
    800012e8:	55a040ef          	jal	80005842 <panic>
    panic("sched running");
    800012ec:	00006517          	auipc	a0,0x6
    800012f0:	f1c50513          	addi	a0,a0,-228 # 80007208 <etext+0x208>
    800012f4:	54e040ef          	jal	80005842 <panic>
    panic("sched interruptible");
    800012f8:	00006517          	auipc	a0,0x6
    800012fc:	f2050513          	addi	a0,a0,-224 # 80007218 <etext+0x218>
    80001300:	542040ef          	jal	80005842 <panic>

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
    80001314:	05d040ef          	jal	80005b70 <acquire>
  p->state = RUNNABLE;
    80001318:	478d                	li	a5,3
    8000131a:	cc9c                	sw	a5,24(s1)
  sched();
    8000131c:	f2fff0ef          	jal	8000124a <sched>
  release(&p->lock);
    80001320:	8526                	mv	a0,s1
    80001322:	0e7040ef          	jal	80005c08 <release>
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
    80001348:	029040ef          	jal	80005b70 <acquire>
  release(lk);
    8000134c:	854a                	mv	a0,s2
    8000134e:	0bb040ef          	jal	80005c08 <release>

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
    80001364:	0a5040ef          	jal	80005c08 <release>
  acquire(lk);
    80001368:	854a                	mv	a0,s2
    8000136a:	007040ef          	jal	80005b70 <acquire>
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
    80001394:	76048493          	addi	s1,s1,1888 # 8000aaf0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001398:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000139a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000139c:	0000f917          	auipc	s2,0xf
    800013a0:	35490913          	addi	s2,s2,852 # 800106f0 <tickslock>
    800013a4:	a801                	j	800013b4 <wakeup+0x38>
      }
      release(&p->lock);
    800013a6:	8526                	mv	a0,s1
    800013a8:	061040ef          	jal	80005c08 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013ac:	17048493          	addi	s1,s1,368
    800013b0:	03248263          	beq	s1,s2,800013d4 <wakeup+0x58>
    if(p != myproc()){
    800013b4:	9a3ff0ef          	jal	80000d56 <myproc>
    800013b8:	fea48ae3          	beq	s1,a0,800013ac <wakeup+0x30>
      acquire(&p->lock);
    800013bc:	8526                	mv	a0,s1
    800013be:	7b2040ef          	jal	80005b70 <acquire>
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
    800013fc:	6f848493          	addi	s1,s1,1784 # 8000aaf0 <proc>
      pp->parent = initproc;
    80001400:	00009a17          	auipc	s4,0x9
    80001404:	280a0a13          	addi	s4,s4,640 # 8000a680 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001408:	0000f997          	auipc	s3,0xf
    8000140c:	2e898993          	addi	s3,s3,744 # 800106f0 <tickslock>
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
    80001458:	22c7b783          	ld	a5,556(a5) # 8000a680 <initproc>
    8000145c:	0d050493          	addi	s1,a0,208
    80001460:	15050913          	addi	s2,a0,336
    80001464:	00a79f63          	bne	a5,a0,80001482 <exit+0x46>
    panic("init exiting");
    80001468:	00006517          	auipc	a0,0x6
    8000146c:	dc850513          	addi	a0,a0,-568 # 80007230 <etext+0x230>
    80001470:	3d2040ef          	jal	80005842 <panic>
      fileclose(f);
    80001474:	226020ef          	jal	8000369a <fileclose>
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
    80001488:	5f9010ef          	jal	80003280 <begin_op>
  iput(p->cwd);
    8000148c:	1509b503          	ld	a0,336(s3)
    80001490:	6dc010ef          	jal	80002b6c <iput>
  end_op();
    80001494:	657010ef          	jal	800032ea <end_op>
  p->cwd = 0;
    80001498:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000149c:	00009497          	auipc	s1,0x9
    800014a0:	23c48493          	addi	s1,s1,572 # 8000a6d8 <wait_lock>
    800014a4:	8526                	mv	a0,s1
    800014a6:	6ca040ef          	jal	80005b70 <acquire>
  reparent(p);
    800014aa:	854e                	mv	a0,s3
    800014ac:	f3bff0ef          	jal	800013e6 <reparent>
  wakeup(p->parent);
    800014b0:	0389b503          	ld	a0,56(s3)
    800014b4:	ec9ff0ef          	jal	8000137c <wakeup>
  acquire(&p->lock);
    800014b8:	854e                	mv	a0,s3
    800014ba:	6b6040ef          	jal	80005b70 <acquire>
  p->xstate = status;
    800014be:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014c2:	4795                	li	a5,5
    800014c4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014c8:	8526                	mv	a0,s1
    800014ca:	73e040ef          	jal	80005c08 <release>
  sched();
    800014ce:	d7dff0ef          	jal	8000124a <sched>
  panic("zombie exit");
    800014d2:	00006517          	auipc	a0,0x6
    800014d6:	d6e50513          	addi	a0,a0,-658 # 80007240 <etext+0x240>
    800014da:	368040ef          	jal	80005842 <panic>

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
    800014f2:	60248493          	addi	s1,s1,1538 # 8000aaf0 <proc>
    800014f6:	0000f997          	auipc	s3,0xf
    800014fa:	1fa98993          	addi	s3,s3,506 # 800106f0 <tickslock>
    acquire(&p->lock);
    800014fe:	8526                	mv	a0,s1
    80001500:	670040ef          	jal	80005b70 <acquire>
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
    8000150c:	6fc040ef          	jal	80005c08 <release>
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
    8000152a:	6de040ef          	jal	80005c08 <release>
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
    80001550:	620040ef          	jal	80005b70 <acquire>
  p->killed = 1;
    80001554:	4785                	li	a5,1
    80001556:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001558:	8526                	mv	a0,s1
    8000155a:	6ae040ef          	jal	80005c08 <release>
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
    80001576:	5fa040ef          	jal	80005b70 <acquire>
  k = p->killed;
    8000157a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000157e:	8526                	mv	a0,s1
    80001580:	688040ef          	jal	80005c08 <release>
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
    800015b6:	12650513          	addi	a0,a0,294 # 8000a6d8 <wait_lock>
    800015ba:	5b6040ef          	jal	80005b70 <acquire>
    havekids = 0;
    800015be:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800015c0:	4a15                	li	s4,5
        havekids = 1;
    800015c2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015c4:	0000f997          	auipc	s3,0xf
    800015c8:	12c98993          	addi	s3,s3,300 # 800106f0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015cc:	00009c17          	auipc	s8,0x9
    800015d0:	10cc0c13          	addi	s8,s8,268 # 8000a6d8 <wait_lock>
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
    800015fa:	60e040ef          	jal	80005c08 <release>
          release(&wait_lock);
    800015fe:	00009517          	auipc	a0,0x9
    80001602:	0da50513          	addi	a0,a0,218 # 8000a6d8 <wait_lock>
    80001606:	602040ef          	jal	80005c08 <release>
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
    80001626:	5e2040ef          	jal	80005c08 <release>
            release(&wait_lock);
    8000162a:	00009517          	auipc	a0,0x9
    8000162e:	0ae50513          	addi	a0,a0,174 # 8000a6d8 <wait_lock>
    80001632:	5d6040ef          	jal	80005c08 <release>
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
    8000164a:	526040ef          	jal	80005b70 <acquire>
        if(pp->state == ZOMBIE){
    8000164e:	4c9c                	lw	a5,24(s1)
    80001650:	f94783e3          	beq	a5,s4,800015d6 <wait+0x44>
        release(&pp->lock);
    80001654:	8526                	mv	a0,s1
    80001656:	5b2040ef          	jal	80005c08 <release>
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
    80001676:	47e48493          	addi	s1,s1,1150 # 8000aaf0 <proc>
    8000167a:	b7e1                	j	80001642 <wait+0xb0>
      release(&wait_lock);
    8000167c:	00009517          	auipc	a0,0x9
    80001680:	05c50513          	addi	a0,a0,92 # 8000a6d8 <wait_lock>
    80001684:	584040ef          	jal	80005c08 <release>
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
    8000173e:	633030ef          	jal	80005570 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001742:	00009497          	auipc	s1,0x9
    80001746:	50648493          	addi	s1,s1,1286 # 8000ac48 <proc+0x158>
    8000174a:	0000f917          	auipc	s2,0xf
    8000174e:	0fe90913          	addi	s2,s2,254 # 80010848 <bcache+0xd0>
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
    80001770:	14cb8b93          	addi	s7,s7,332 # 800078b8 <states.0>
    80001774:	a829                	j	8000178e <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001776:	ed86a583          	lw	a1,-296(a3)
    8000177a:	8556                	mv	a0,s5
    8000177c:	5f5030ef          	jal	80005570 <printf>
    printf("\n");
    80001780:	8552                	mv	a0,s4
    80001782:	5ef030ef          	jal	80005570 <printf>
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
    80001842:	eb250513          	addi	a0,a0,-334 # 800106f0 <tickslock>
    80001846:	2aa040ef          	jal	80005af0 <initlock>
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
    8000185c:	25878793          	addi	a5,a5,600 # 80004ab0 <kernelvec>
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
    8000192a:	dca48493          	addi	s1,s1,-566 # 800106f0 <tickslock>
    8000192e:	8526                	mv	a0,s1
    80001930:	240040ef          	jal	80005b70 <acquire>
    ticks++;
    80001934:	00009517          	auipc	a0,0x9
    80001938:	d5450513          	addi	a0,a0,-684 # 8000a688 <ticks>
    8000193c:	411c                	lw	a5,0(a0)
    8000193e:	2785                	addiw	a5,a5,1
    80001940:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001942:	a3bff0ef          	jal	8000137c <wakeup>
    release(&tickslock);
    80001946:	8526                	mv	a0,s1
    80001948:	2c0040ef          	jal	80005c08 <release>
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
    8000197c:	1e0030ef          	jal	80004b5c <plic_claim>
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
    80001996:	11e040ef          	jal	80005ab4 <uartintr>
    if(irq)
    8000199a:	a819                	j	800019b0 <devintr+0x60>
      virtio_disk_intr();
    8000199c:	686030ef          	jal	80005022 <virtio_disk_intr>
    if(irq)
    800019a0:	a801                	j	800019b0 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019a2:	85a6                	mv	a1,s1
    800019a4:	00006517          	auipc	a0,0x6
    800019a8:	8fc50513          	addi	a0,a0,-1796 # 800072a0 <etext+0x2a0>
    800019ac:	3c5030ef          	jal	80005570 <printf>
      plic_complete(irq);
    800019b0:	8526                	mv	a0,s1
    800019b2:	1ca030ef          	jal	80004b7c <plic_complete>
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
    800019de:	0d678793          	addi	a5,a5,214 # 80004ab0 <kernelvec>
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
    80001a18:	62b030ef          	jal	80005842 <panic>
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
    80001a36:	584000ef          	jal	80001fba <syscall>
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
    80001a76:	2fb030ef          	jal	80005570 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a7a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a7e:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a82:	00006517          	auipc	a0,0x6
    80001a86:	88e50513          	addi	a0,a0,-1906 # 80007310 <etext+0x310>
    80001a8a:	2e7030ef          	jal	80005570 <printf>
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
    80001aee:	555030ef          	jal	80005842 <panic>
    panic("kerneltrap: interrupts enabled");
    80001af2:	00006517          	auipc	a0,0x6
    80001af6:	86e50513          	addi	a0,a0,-1938 # 80007360 <etext+0x360>
    80001afa:	549030ef          	jal	80005842 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001afe:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b02:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b06:	85ce                	mv	a1,s3
    80001b08:	00006517          	auipc	a0,0x6
    80001b0c:	87850513          	addi	a0,a0,-1928 # 80007380 <etext+0x380>
    80001b10:	261030ef          	jal	80005570 <printf>
    panic("kerneltrap");
    80001b14:	00006517          	auipc	a0,0x6
    80001b18:	89450513          	addi	a0,a0,-1900 # 800073a8 <etext+0x3a8>
    80001b1c:	527030ef          	jal	80005842 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b20:	a36ff0ef          	jal	80000d56 <myproc>
    80001b24:	d555                	beqz	a0,80001ad0 <kerneltrap+0x34>
    yield();
    80001b26:	fdeff0ef          	jal	80001304 <yield>
    80001b2a:	b75d                	j	80001ad0 <kerneltrap+0x34>

0000000080001b2c <argraw>:
  return strlen(buf);
}

static void
argraw(int n, uint64 *ip)
{
    80001b2c:	1101                	addi	sp,sp,-32
    80001b2e:	ec06                	sd	ra,24(sp)
    80001b30:	e822                	sd	s0,16(sp)
    80001b32:	e426                	sd	s1,8(sp)
    80001b34:	e04a                	sd	s2,0(sp)
    80001b36:	1000                	addi	s0,sp,32
    80001b38:	84aa                	mv	s1,a0
    80001b3a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001b3c:	a1aff0ef          	jal	80000d56 <myproc>
  //printf("argraw: n=%d, proc=%p, trapframe=%p\n", n, p, p ? p->trapframe : 0);
  if (p == 0 || p->trapframe == 0) {
    80001b40:	c505                	beqz	a0,80001b68 <argraw+0x3c>
    80001b42:	6d34                	ld	a3,88(a0)
    80001b44:	c295                	beqz	a3,80001b68 <argraw+0x3c>
    panic("argraw: invalid proc or trapframe");
  }
  if (n < 0 || n > 5) {
    80001b46:	0004879b          	sext.w	a5,s1
    80001b4a:	4715                	li	a4,5
    80001b4c:	02f76463          	bltu	a4,a5,80001b74 <argraw+0x48>
    panic("argraw: invalid n");
  }
  switch (n) {
    80001b50:	4795                	li	a5,5
    80001b52:	0297ea63          	bltu	a5,s1,80001b86 <argraw+0x5a>
    80001b56:	048a                	slli	s1,s1,0x2
    80001b58:	00006717          	auipc	a4,0x6
    80001b5c:	d9070713          	addi	a4,a4,-624 # 800078e8 <states.0+0x30>
    80001b60:	94ba                	add	s1,s1,a4
    80001b62:	409c                	lw	a5,0(s1)
    80001b64:	97ba                	add	a5,a5,a4
    80001b66:	8782                	jr	a5
    panic("argraw: invalid proc or trapframe");
    80001b68:	00006517          	auipc	a0,0x6
    80001b6c:	85050513          	addi	a0,a0,-1968 # 800073b8 <etext+0x3b8>
    80001b70:	4d3030ef          	jal	80005842 <panic>
    panic("argraw: invalid n");
    80001b74:	00006517          	auipc	a0,0x6
    80001b78:	86c50513          	addi	a0,a0,-1940 # 800073e0 <etext+0x3e0>
    80001b7c:	4c7030ef          	jal	80005842 <panic>
    case 0: *ip = p->trapframe->a0; break;
    80001b80:	7abc                	ld	a5,112(a3)
    80001b82:	00f93023          	sd	a5,0(s2)
    case 2: *ip = p->trapframe->a2; break;
    case 3: *ip = p->trapframe->a3; break;
    case 4: *ip = p->trapframe->a4; break;
    case 5: *ip = p->trapframe->a5; break;
  }
}
    80001b86:	60e2                	ld	ra,24(sp)
    80001b88:	6442                	ld	s0,16(sp)
    80001b8a:	64a2                	ld	s1,8(sp)
    80001b8c:	6902                	ld	s2,0(sp)
    80001b8e:	6105                	addi	sp,sp,32
    80001b90:	8082                	ret
    case 1: *ip = p->trapframe->a1; break;
    80001b92:	7ebc                	ld	a5,120(a3)
    80001b94:	00f93023          	sd	a5,0(s2)
    80001b98:	b7fd                	j	80001b86 <argraw+0x5a>
    case 2: *ip = p->trapframe->a2; break;
    80001b9a:	62dc                	ld	a5,128(a3)
    80001b9c:	00f93023          	sd	a5,0(s2)
    80001ba0:	b7dd                	j	80001b86 <argraw+0x5a>
    case 3: *ip = p->trapframe->a3; break;
    80001ba2:	66dc                	ld	a5,136(a3)
    80001ba4:	00f93023          	sd	a5,0(s2)
    80001ba8:	bff9                	j	80001b86 <argraw+0x5a>
    case 4: *ip = p->trapframe->a4; break;
    80001baa:	6adc                	ld	a5,144(a3)
    80001bac:	00f93023          	sd	a5,0(s2)
    80001bb0:	bfd9                	j	80001b86 <argraw+0x5a>
    case 5: *ip = p->trapframe->a5; break;
    80001bb2:	6edc                	ld	a5,152(a3)
    80001bb4:	00f93023          	sd	a5,0(s2)
}
    80001bb8:	b7f9                	j	80001b86 <argraw+0x5a>

0000000080001bba <sys_stats>:
  argaddr(0, &tv_addr);
  argaddr(1, &tz_addr);
  return -1;
}

uint64 sys_stats(void) {
    80001bba:	7139                	addi	sp,sp,-64
    80001bbc:	fc06                	sd	ra,56(sp)
    80001bbe:	f822                	sd	s0,48(sp)
    80001bc0:	f426                	sd	s1,40(sp)
    80001bc2:	f04a                	sd	s2,32(sp)
    80001bc4:	ec4e                	sd	s3,24(sp)
    80001bc6:	e852                	sd	s4,16(sp)
    80001bc8:	e456                	sd	s5,8(sp)
    80001bca:	0080                	addi	s0,sp,64
  for (int i = 0; i < NELEM(syscalls); i++) {
    80001bcc:	0000f497          	auipc	s1,0xf
    80001bd0:	b3c48493          	addi	s1,s1,-1220 # 80010708 <syscall_counts>
    80001bd4:	00006917          	auipc	s2,0x6
    80001bd8:	d2c90913          	addi	s2,s2,-724 # 80007900 <syscall_names>
    80001bdc:	0000f997          	auipc	s3,0xf
    80001be0:	b9898993          	addi	s3,s3,-1128 # 80010774 <syscall_counts+0x6c>
    if (syscall_counts[i] > 0) {
      printf("%s: %d calls\n", syscall_names[i] ? syscall_names[i] : "unknown", syscall_counts[i]);
    80001be4:	00006a17          	auipc	s4,0x6
    80001be8:	81ca0a13          	addi	s4,s4,-2020 # 80007400 <etext+0x400>
    80001bec:	00006a97          	auipc	s5,0x6
    80001bf0:	80ca8a93          	addi	s5,s5,-2036 # 800073f8 <etext+0x3f8>
    80001bf4:	a801                	j	80001c04 <sys_stats+0x4a>
    80001bf6:	8552                	mv	a0,s4
    80001bf8:	179030ef          	jal	80005570 <printf>
  for (int i = 0; i < NELEM(syscalls); i++) {
    80001bfc:	0491                	addi	s1,s1,4
    80001bfe:	0921                	addi	s2,s2,8
    80001c00:	01348a63          	beq	s1,s3,80001c14 <sys_stats+0x5a>
    if (syscall_counts[i] > 0) {
    80001c04:	4090                	lw	a2,0(s1)
    80001c06:	fec05be3          	blez	a2,80001bfc <sys_stats+0x42>
      printf("%s: %d calls\n", syscall_names[i] ? syscall_names[i] : "unknown", syscall_counts[i]);
    80001c0a:	00093583          	ld	a1,0(s2)
    80001c0e:	f5e5                	bnez	a1,80001bf6 <sys_stats+0x3c>
    80001c10:	85d6                	mv	a1,s5
    80001c12:	b7d5                	j	80001bf6 <sys_stats+0x3c>
    }
  }
  return 0;
}
    80001c14:	4501                	li	a0,0
    80001c16:	70e2                	ld	ra,56(sp)
    80001c18:	7442                	ld	s0,48(sp)
    80001c1a:	74a2                	ld	s1,40(sp)
    80001c1c:	7902                	ld	s2,32(sp)
    80001c1e:	69e2                	ld	s3,24(sp)
    80001c20:	6a42                	ld	s4,16(sp)
    80001c22:	6aa2                	ld	s5,8(sp)
    80001c24:	6121                	addi	sp,sp,64
    80001c26:	8082                	ret

0000000080001c28 <sys_gettime>:
uint64 sys_gettime(void) {
    80001c28:	1101                	addi	sp,sp,-32
    80001c2a:	ec06                	sd	ra,24(sp)
    80001c2c:	e822                	sd	s0,16(sp)
    80001c2e:	1000                	addi	s0,sp,32
  argraw(n, ip);
    80001c30:	fe840593          	addi	a1,s0,-24
    80001c34:	4501                	li	a0,0
    80001c36:	ef7ff0ef          	jal	80001b2c <argraw>
    80001c3a:	fe040593          	addi	a1,s0,-32
    80001c3e:	4505                	li	a0,1
    80001c40:	eedff0ef          	jal	80001b2c <argraw>
}
    80001c44:	557d                	li	a0,-1
    80001c46:	60e2                	ld	ra,24(sp)
    80001c48:	6442                	ld	s0,16(sp)
    80001c4a:	6105                	addi	sp,sp,32
    80001c4c:	8082                	ret

0000000080001c4e <fetchaddr>:
{
    80001c4e:	1101                	addi	sp,sp,-32
    80001c50:	ec06                	sd	ra,24(sp)
    80001c52:	e822                	sd	s0,16(sp)
    80001c54:	e426                	sd	s1,8(sp)
    80001c56:	e04a                	sd	s2,0(sp)
    80001c58:	1000                	addi	s0,sp,32
    80001c5a:	84aa                	mv	s1,a0
    80001c5c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c5e:	8f8ff0ef          	jal	80000d56 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c62:	653c                	ld	a5,72(a0)
    80001c64:	02f4f663          	bgeu	s1,a5,80001c90 <fetchaddr+0x42>
    80001c68:	00848713          	addi	a4,s1,8
    80001c6c:	02e7e463          	bltu	a5,a4,80001c94 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c70:	46a1                	li	a3,8
    80001c72:	8626                	mv	a2,s1
    80001c74:	85ca                	mv	a1,s2
    80001c76:	6928                	ld	a0,80(a0)
    80001c78:	e27fe0ef          	jal	80000a9e <copyin>
    80001c7c:	00a03533          	snez	a0,a0
    80001c80:	40a00533          	neg	a0,a0
}
    80001c84:	60e2                	ld	ra,24(sp)
    80001c86:	6442                	ld	s0,16(sp)
    80001c88:	64a2                	ld	s1,8(sp)
    80001c8a:	6902                	ld	s2,0(sp)
    80001c8c:	6105                	addi	sp,sp,32
    80001c8e:	8082                	ret
    return -1;
    80001c90:	557d                	li	a0,-1
    80001c92:	bfcd                	j	80001c84 <fetchaddr+0x36>
    80001c94:	557d                	li	a0,-1
    80001c96:	b7fd                	j	80001c84 <fetchaddr+0x36>

0000000080001c98 <fetchstr>:
{
    80001c98:	7179                	addi	sp,sp,-48
    80001c9a:	f406                	sd	ra,40(sp)
    80001c9c:	f022                	sd	s0,32(sp)
    80001c9e:	ec26                	sd	s1,24(sp)
    80001ca0:	e84a                	sd	s2,16(sp)
    80001ca2:	e44e                	sd	s3,8(sp)
    80001ca4:	1800                	addi	s0,sp,48
    80001ca6:	892a                	mv	s2,a0
    80001ca8:	84ae                	mv	s1,a1
    80001caa:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001cac:	8aaff0ef          	jal	80000d56 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001cb0:	86ce                	mv	a3,s3
    80001cb2:	864a                	mv	a2,s2
    80001cb4:	85a6                	mv	a1,s1
    80001cb6:	6928                	ld	a0,80(a0)
    80001cb8:	e6dfe0ef          	jal	80000b24 <copyinstr>
    80001cbc:	00054c63          	bltz	a0,80001cd4 <fetchstr+0x3c>
  return strlen(buf);
    80001cc0:	8526                	mv	a0,s1
    80001cc2:	de2fe0ef          	jal	800002a4 <strlen>
}
    80001cc6:	70a2                	ld	ra,40(sp)
    80001cc8:	7402                	ld	s0,32(sp)
    80001cca:	64e2                	ld	s1,24(sp)
    80001ccc:	6942                	ld	s2,16(sp)
    80001cce:	69a2                	ld	s3,8(sp)
    80001cd0:	6145                	addi	sp,sp,48
    80001cd2:	8082                	ret
    return -1;
    80001cd4:	557d                	li	a0,-1
    80001cd6:	bfc5                	j	80001cc6 <fetchstr+0x2e>

0000000080001cd8 <argint>:
{
    80001cd8:	7179                	addi	sp,sp,-48
    80001cda:	f406                	sd	ra,40(sp)
    80001cdc:	f022                	sd	s0,32(sp)
    80001cde:	ec26                	sd	s1,24(sp)
    80001ce0:	1800                	addi	s0,sp,48
    80001ce2:	84ae                	mv	s1,a1
  argraw(n, &val);
    80001ce4:	fd840593          	addi	a1,s0,-40
    80001ce8:	e45ff0ef          	jal	80001b2c <argraw>
  *ip = (int)val;
    80001cec:	fd843783          	ld	a5,-40(s0)
    80001cf0:	c09c                	sw	a5,0(s1)
}
    80001cf2:	70a2                	ld	ra,40(sp)
    80001cf4:	7402                	ld	s0,32(sp)
    80001cf6:	64e2                	ld	s1,24(sp)
    80001cf8:	6145                	addi	sp,sp,48
    80001cfa:	8082                	ret

0000000080001cfc <sys_socket>:

uint64 sys_socket(void) {
    80001cfc:	1101                	addi	sp,sp,-32
    80001cfe:	ec06                	sd	ra,24(sp)
    80001d00:	e822                	sd	s0,16(sp)
    80001d02:	1000                	addi	s0,sp,32
  int domain, type, protocol;
  argint(0, &domain);
    80001d04:	fec40593          	addi	a1,s0,-20
    80001d08:	4501                	li	a0,0
    80001d0a:	fcfff0ef          	jal	80001cd8 <argint>
  argint(1, &type);
    80001d0e:	fe840593          	addi	a1,s0,-24
    80001d12:	4505                	li	a0,1
    80001d14:	fc5ff0ef          	jal	80001cd8 <argint>
  argint(2, &protocol);
    80001d18:	fe440593          	addi	a1,s0,-28
    80001d1c:	4509                	li	a0,2
    80001d1e:	fbbff0ef          	jal	80001cd8 <argint>
  return -1;
}
    80001d22:	557d                	li	a0,-1
    80001d24:	60e2                	ld	ra,24(sp)
    80001d26:	6442                	ld	s0,16(sp)
    80001d28:	6105                	addi	sp,sp,32
    80001d2a:	8082                	ret

0000000080001d2c <sys_mmap>:



uint64 sys_mmap(void) {
    80001d2c:	7179                	addi	sp,sp,-48
    80001d2e:	f406                	sd	ra,40(sp)
    80001d30:	f022                	sd	s0,32(sp)
    80001d32:	1800                	addi	s0,sp,48
  argraw(n, ip);
    80001d34:	fe840593          	addi	a1,s0,-24
    80001d38:	4501                	li	a0,0
    80001d3a:	df3ff0ef          	jal	80001b2c <argraw>
  uint64 addr;
  int length, prot, flags, fd, offset;
  argaddr(0, &addr);
  argint(1, &length);
    80001d3e:	fe440593          	addi	a1,s0,-28
    80001d42:	4505                	li	a0,1
    80001d44:	f95ff0ef          	jal	80001cd8 <argint>
  argint(2, &prot);
    80001d48:	fe040593          	addi	a1,s0,-32
    80001d4c:	4509                	li	a0,2
    80001d4e:	f8bff0ef          	jal	80001cd8 <argint>
  argint(3, &flags);
    80001d52:	fdc40593          	addi	a1,s0,-36
    80001d56:	450d                	li	a0,3
    80001d58:	f81ff0ef          	jal	80001cd8 <argint>
  argint(4, &fd);
    80001d5c:	fd840593          	addi	a1,s0,-40
    80001d60:	4511                	li	a0,4
    80001d62:	f77ff0ef          	jal	80001cd8 <argint>
  argint(5, &offset);
    80001d66:	fd440593          	addi	a1,s0,-44
    80001d6a:	4515                	li	a0,5
    80001d6c:	f6dff0ef          	jal	80001cd8 <argint>
  return -1;
}
    80001d70:	557d                	li	a0,-1
    80001d72:	70a2                	ld	ra,40(sp)
    80001d74:	7402                	ld	s0,32(sp)
    80001d76:	6145                	addi	sp,sp,48
    80001d78:	8082                	ret

0000000080001d7a <argaddr>:
{
    80001d7a:	1141                	addi	sp,sp,-16
    80001d7c:	e406                	sd	ra,8(sp)
    80001d7e:	e022                	sd	s0,0(sp)
    80001d80:	0800                	addi	s0,sp,16
  argraw(n, ip);
    80001d82:	dabff0ef          	jal	80001b2c <argraw>
}
    80001d86:	60a2                	ld	ra,8(sp)
    80001d88:	6402                	ld	s0,0(sp)
    80001d8a:	0141                	addi	sp,sp,16
    80001d8c:	8082                	ret

0000000080001d8e <argstr>:
{
    80001d8e:	7179                	addi	sp,sp,-48
    80001d90:	f406                	sd	ra,40(sp)
    80001d92:	f022                	sd	s0,32(sp)
    80001d94:	ec26                	sd	s1,24(sp)
    80001d96:	e84a                	sd	s2,16(sp)
    80001d98:	1800                	addi	s0,sp,48
    80001d9a:	84ae                	mv	s1,a1
    80001d9c:	8932                	mv	s2,a2
  argraw(n, ip);
    80001d9e:	fd840593          	addi	a1,s0,-40
    80001da2:	d8bff0ef          	jal	80001b2c <argraw>
  return fetchstr(addr, buf, max);
    80001da6:	864a                	mv	a2,s2
    80001da8:	85a6                	mv	a1,s1
    80001daa:	fd843503          	ld	a0,-40(s0)
    80001dae:	eebff0ef          	jal	80001c98 <fetchstr>
}
    80001db2:	70a2                	ld	ra,40(sp)
    80001db4:	7402                	ld	s0,32(sp)
    80001db6:	64e2                	ld	s1,24(sp)
    80001db8:	6942                	ld	s2,16(sp)
    80001dba:	6145                	addi	sp,sp,48
    80001dbc:	8082                	ret

0000000080001dbe <read_string>:
///////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////
// Read null-terminated string from user space
int read_string(struct proc *p, uint64 addr, char *buf, int max) {
    80001dbe:	715d                	addi	sp,sp,-80
    80001dc0:	e486                	sd	ra,72(sp)
    80001dc2:	e0a2                	sd	s0,64(sp)
    80001dc4:	f84a                	sd	s2,48(sp)
    80001dc6:	0880                	addi	s0,sp,80
  
  if(addr >= p->sz)
    80001dc8:	653c                	ld	a5,72(a0)
    80001dca:	08f5f563          	bgeu	a1,a5,80001e54 <read_string+0x96>
    80001dce:	f052                	sd	s4,32(sp)
    80001dd0:	ec56                	sd	s5,24(sp)
    80001dd2:	e45e                	sd	s7,8(sp)
    80001dd4:	8aaa                	mv	s5,a0
    80001dd6:	8bb2                	mv	s7,a2
    80001dd8:	8a36                	mv	s4,a3
  {
    return -1; }
  int n = 0;
  while(n < max) {
    80001dda:	06d05763          	blez	a3,80001e48 <read_string+0x8a>
    80001dde:	fc26                	sd	s1,56(sp)
    80001de0:	f44e                	sd	s3,40(sp)
    80001de2:	e85a                	sd	s6,16(sp)
    80001de4:	84b2                	mv	s1,a2
  int n = 0;
    80001de6:	4901                	li	s2,0
    if(copyin(p->pagetable, buf + n, addr + n, 1) == -1) {
    80001de8:	40c589b3          	sub	s3,a1,a2
    80001dec:	5b7d                	li	s6,-1
    80001dee:	4685                	li	a3,1
    80001df0:	00998633          	add	a2,s3,s1
    80001df4:	85a6                	mv	a1,s1
    80001df6:	050ab503          	ld	a0,80(s5)
    80001dfa:	ca5fe0ef          	jal	80000a9e <copyin>
    80001dfe:	03650463          	beq	a0,s6,80001e26 <read_string+0x68>
      break;
    }
    if(buf[n] == '\0'){
    80001e02:	0004c783          	lbu	a5,0(s1)
    80001e06:	c385                	beqz	a5,80001e26 <read_string+0x68>
      break;
    }
    n++;
    80001e08:	2905                	addiw	s2,s2,1
  while(n < max) {
    80001e0a:	0485                	addi	s1,s1,1
    80001e0c:	ff2a11e3          	bne	s4,s2,80001dee <read_string+0x30>
    80001e10:	8952                	mv	s2,s4
    80001e12:	74e2                	ld	s1,56(sp)
    80001e14:	79a2                	ld	s3,40(sp)
    80001e16:	6b42                	ld	s6,16(sp)
  }
  if(n < max){
    buf[n] = '\0';
  } else {
    buf[max-1] = '\0';
    80001e18:	9bd2                	add	s7,s7,s4
    80001e1a:	fe0b8fa3          	sb	zero,-1(s7)
    80001e1e:	7a02                	ld	s4,32(sp)
    80001e20:	6ae2                	ld	s5,24(sp)
    80001e22:	6ba2                	ld	s7,8(sp)
    80001e24:	a821                	j	80001e3c <read_string+0x7e>
  if(n < max){
    80001e26:	03495363          	bge	s2,s4,80001e4c <read_string+0x8e>
    buf[n] = '\0';
    80001e2a:	9bca                	add	s7,s7,s2
    80001e2c:	000b8023          	sb	zero,0(s7)
    80001e30:	74e2                	ld	s1,56(sp)
    80001e32:	79a2                	ld	s3,40(sp)
    80001e34:	7a02                	ld	s4,32(sp)
    80001e36:	6ae2                	ld	s5,24(sp)
    80001e38:	6b42                	ld	s6,16(sp)
    80001e3a:	6ba2                	ld	s7,8(sp)
  } 
  return n;
}
    80001e3c:	854a                	mv	a0,s2
    80001e3e:	60a6                	ld	ra,72(sp)
    80001e40:	6406                	ld	s0,64(sp)
    80001e42:	7942                	ld	s2,48(sp)
    80001e44:	6161                	addi	sp,sp,80
    80001e46:	8082                	ret
  int n = 0;
    80001e48:	4901                	li	s2,0
    80001e4a:	b7f9                	j	80001e18 <read_string+0x5a>
    80001e4c:	74e2                	ld	s1,56(sp)
    80001e4e:	79a2                	ld	s3,40(sp)
    80001e50:	6b42                	ld	s6,16(sp)
    80001e52:	b7d9                	j	80001e18 <read_string+0x5a>
    return -1; }
    80001e54:	597d                	li	s2,-1
    80001e56:	b7dd                	j	80001e3c <read_string+0x7e>

0000000080001e58 <read_memory>:

////////////////////////////////////////////////////////////////////////////////////////////////////
// Read arbitrary memory from user space
int read_memory(struct proc *p, uint64 addr, char *buf, int n) {
    80001e58:	87ae                	mv	a5,a1

  if(addr >= p->sz || addr + n > p->sz)
    80001e5a:	6538                	ld	a4,72(a0)
    80001e5c:	02e5fa63          	bgeu	a1,a4,80001e90 <read_memory+0x38>
int read_memory(struct proc *p, uint64 addr, char *buf, int n) {
    80001e60:	1101                	addi	sp,sp,-32
    80001e62:	ec06                	sd	ra,24(sp)
    80001e64:	e822                	sd	s0,16(sp)
    80001e66:	e426                	sd	s1,8(sp)
    80001e68:	1000                	addi	s0,sp,32
    80001e6a:	85b2                	mv	a1,a2
    80001e6c:	84b6                	mv	s1,a3
  if(addr >= p->sz || addr + n > p->sz)
    80001e6e:	96be                	add	a3,a3,a5
    80001e70:	02d76263          	bltu	a4,a3,80001e94 <read_memory+0x3c>
    return -1;

  if(copyin(p->pagetable, buf, addr, n) == -1)
    80001e74:	86a6                	mv	a3,s1
    80001e76:	863e                	mv	a2,a5
    80001e78:	6928                	ld	a0,80(a0)
    80001e7a:	c25fe0ef          	jal	80000a9e <copyin>
    80001e7e:	57fd                	li	a5,-1
    80001e80:	00f50363          	beq	a0,a5,80001e86 <read_memory+0x2e>
    return -1;

  return n;
    80001e84:	8526                	mv	a0,s1
}
    80001e86:	60e2                	ld	ra,24(sp)
    80001e88:	6442                	ld	s0,16(sp)
    80001e8a:	64a2                	ld	s1,8(sp)
    80001e8c:	6105                	addi	sp,sp,32
    80001e8e:	8082                	ret
    return -1;
    80001e90:	557d                	li	a0,-1
}
    80001e92:	8082                	ret
    return -1;
    80001e94:	557d                	li	a0,-1
    80001e96:	bfc5                	j	80001e86 <read_memory+0x2e>

0000000080001e98 <print_syscall>:

//////////////////////////////////////////////////////////////


// Print system call details (enhanced for open's mode)
void print_syscall(struct proc *p, int num, uint64 args[], uint64 ret) {
    80001e98:	7119                	addi	sp,sp,-128
    80001e9a:	fc86                	sd	ra,120(sp)
    80001e9c:	f8a2                	sd	s0,112(sp)
    80001e9e:	f4a6                	sd	s1,104(sp)
    80001ea0:	0100                	addi	s0,sp,128
    80001ea2:	84ae                	mv	s1,a1
    80001ea4:	f8d43423          	sd	a3,-120(s0)
  if (p->trace_mask & (1 << num)) {
    80001ea8:	4705                	li	a4,1
    80001eaa:	00b7173b          	sllw	a4,a4,a1
    80001eae:	16852783          	lw	a5,360(a0)
    80001eb2:	8ff9                	and	a5,a5,a4
    80001eb4:	2781                	sext.w	a5,a5
    80001eb6:	0e078463          	beqz	a5,80001f9e <print_syscall+0x106>
    80001eba:	f0ca                	sd	s2,96(sp)
    80001ebc:	ecce                	sd	s3,88(sp)
    80001ebe:	e8d2                	sd	s4,80(sp)
    80001ec0:	e4d6                	sd	s5,72(sp)
    80001ec2:	e0da                	sd	s6,64(sp)
    80001ec4:	fc5e                	sd	s7,56(sp)
    80001ec6:	f862                	sd	s8,48(sp)
    80001ec8:	f466                	sd	s9,40(sp)
    80001eca:	f06a                	sd	s10,32(sp)
    80001ecc:	ec6e                	sd	s11,24(sp)
    80001ece:	8932                	mv	s2,a2
    printf("1: %s(", syscall_names[num] ? syscall_names[num] : "unknown");
    80001ed0:	00359713          	slli	a4,a1,0x3
    80001ed4:	00006797          	auipc	a5,0x6
    80001ed8:	a2c78793          	addi	a5,a5,-1492 # 80007900 <syscall_names>
    80001edc:	97ba                	add	a5,a5,a4
    80001ede:	638c                	ld	a1,0(a5)
    80001ee0:	cd8d                	beqz	a1,80001f1a <print_syscall+0x82>
    80001ee2:	00005517          	auipc	a0,0x5
    80001ee6:	52e50513          	addi	a0,a0,1326 # 80007410 <etext+0x410>
    80001eea:	686030ef          	jal	80005570 <printf>
    for (int i = 0; i < 3 && argtypes[num][i]; i++) {
    80001eee:	00149b13          	slli	s6,s1,0x1
    80001ef2:	9b26                	add	s6,s6,s1
    printf("1: %s(", syscall_names[num] ? syscall_names[num] : "unknown");
    80001ef4:	4981                	li	s3,0
    for (int i = 0; i < 3 && argtypes[num][i]; i++) {
    80001ef6:	00006b97          	auipc	s7,0x6
    80001efa:	ae2b8b93          	addi	s7,s7,-1310 # 800079d8 <argtypes>
      if (i > 0) printf(", ");
    80001efe:	00005d97          	auipc	s11,0x5
    80001f02:	51ad8d93          	addi	s11,s11,1306 # 80007418 <etext+0x418>
      if (argtypes[num][i] == 'i') printf("%d", (int)args[i]);
    80001f06:	06900c93          	li	s9,105
      else if (argtypes[num][i] == 'a') printf("0x%lx", args[i]);
    80001f0a:	06100d13          	li	s10,97
      else printf("?");
    80001f0e:	00005a97          	auipc	s5,0x5
    80001f12:	522a8a93          	addi	s5,s5,1314 # 80007430 <etext+0x430>
    for (int i = 0; i < 3 && argtypes[num][i]; i++) {
    80001f16:	4c0d                	li	s8,3
    80001f18:	a81d                	j	80001f4e <print_syscall+0xb6>
    printf("1: %s(", syscall_names[num] ? syscall_names[num] : "unknown");
    80001f1a:	00005597          	auipc	a1,0x5
    80001f1e:	4de58593          	addi	a1,a1,1246 # 800073f8 <etext+0x3f8>
    80001f22:	b7c1                	j	80001ee2 <print_syscall+0x4a>
      if (argtypes[num][i] == 'i') printf("%d", (int)args[i]);
    80001f24:	00092583          	lw	a1,0(s2)
    80001f28:	00005517          	auipc	a0,0x5
    80001f2c:	4f850513          	addi	a0,a0,1272 # 80007420 <etext+0x420>
    80001f30:	640030ef          	jal	80005570 <printf>
    80001f34:	a809                	j	80001f46 <print_syscall+0xae>
      else if (argtypes[num][i] == 'a') printf("0x%lx", args[i]);
    80001f36:	00093583          	ld	a1,0(s2)
    80001f3a:	00005517          	auipc	a0,0x5
    80001f3e:	4ee50513          	addi	a0,a0,1262 # 80007428 <etext+0x428>
    80001f42:	62e030ef          	jal	80005570 <printf>
    for (int i = 0; i < 3 && argtypes[num][i]; i++) {
    80001f46:	0985                	addi	s3,s3,1
    80001f48:	0921                	addi	s2,s2,8
    80001f4a:	03898863          	beq	s3,s8,80001f7a <print_syscall+0xe2>
    80001f4e:	016987b3          	add	a5,s3,s6
    80001f52:	97de                	add	a5,a5,s7
    80001f54:	0007ca03          	lbu	s4,0(a5)
    80001f58:	020a0163          	beqz	s4,80001f7a <print_syscall+0xe2>
      if (i > 0) printf(", ");
    80001f5c:	0009879b          	sext.w	a5,s3
    80001f60:	00f05563          	blez	a5,80001f6a <print_syscall+0xd2>
    80001f64:	856e                	mv	a0,s11
    80001f66:	60a030ef          	jal	80005570 <printf>
      if (argtypes[num][i] == 'i') printf("%d", (int)args[i]);
    80001f6a:	fb9a0de3          	beq	s4,s9,80001f24 <print_syscall+0x8c>
      else if (argtypes[num][i] == 'a') printf("0x%lx", args[i]);
    80001f6e:	fdaa04e3          	beq	s4,s10,80001f36 <print_syscall+0x9e>
      else printf("?");
    80001f72:	8556                	mv	a0,s5
    80001f74:	5fc030ef          	jal	80005570 <printf>
    80001f78:	b7f9                	j	80001f46 <print_syscall+0xae>
    }
    printf(") = %ld\n", ret);
    80001f7a:	f8843583          	ld	a1,-120(s0)
    80001f7e:	00005517          	auipc	a0,0x5
    80001f82:	4ba50513          	addi	a0,a0,1210 # 80007438 <etext+0x438>
    80001f86:	5ea030ef          	jal	80005570 <printf>
    80001f8a:	7906                	ld	s2,96(sp)
    80001f8c:	69e6                	ld	s3,88(sp)
    80001f8e:	6a46                	ld	s4,80(sp)
    80001f90:	6aa6                	ld	s5,72(sp)
    80001f92:	6b06                	ld	s6,64(sp)
    80001f94:	7be2                	ld	s7,56(sp)
    80001f96:	7c42                	ld	s8,48(sp)
    80001f98:	7ca2                	ld	s9,40(sp)
    80001f9a:	7d02                	ld	s10,32(sp)
    80001f9c:	6de2                	ld	s11,24(sp)
  }
  syscall_counts[num]++;
    80001f9e:	048a                	slli	s1,s1,0x2
    80001fa0:	0000e797          	auipc	a5,0xe
    80001fa4:	76878793          	addi	a5,a5,1896 # 80010708 <syscall_counts>
    80001fa8:	97a6                	add	a5,a5,s1
    80001faa:	4398                	lw	a4,0(a5)
    80001fac:	2705                	addiw	a4,a4,1
    80001fae:	c398                	sw	a4,0(a5)
}
    80001fb0:	70e6                	ld	ra,120(sp)
    80001fb2:	7446                	ld	s0,112(sp)
    80001fb4:	74a6                	ld	s1,104(sp)
    80001fb6:	6109                	addi	sp,sp,128
    80001fb8:	8082                	ret

0000000080001fba <syscall>:
void syscall(void) {
    80001fba:	715d                	addi	sp,sp,-80
    80001fbc:	e486                	sd	ra,72(sp)
    80001fbe:	e0a2                	sd	s0,64(sp)
    80001fc0:	fc26                	sd	s1,56(sp)
    80001fc2:	f84a                	sd	s2,48(sp)
    80001fc4:	0880                	addi	s0,sp,80
    int num = myproc()->trapframe->a7;
    80001fc6:	d91fe0ef          	jal	80000d56 <myproc>
    80001fca:	6d3c                	ld	a5,88(a0)
    80001fcc:	0a87b903          	ld	s2,168(a5)
    struct proc *p = myproc();
    80001fd0:	d87fe0ef          	jal	80000d56 <myproc>
    80001fd4:	84aa                	mv	s1,a0
    uint64 args[3] = {0};
    80001fd6:	fa043c23          	sd	zero,-72(s0)
    80001fda:	fc043023          	sd	zero,-64(s0)
    80001fde:	fc043423          	sd	zero,-56(s0)
    for (int i = 0; i < 3; i++) argraw(i, &args[i]);
    80001fe2:	fb840593          	addi	a1,s0,-72
    80001fe6:	4501                	li	a0,0
    80001fe8:	b45ff0ef          	jal	80001b2c <argraw>
    80001fec:	fc040593          	addi	a1,s0,-64
    80001ff0:	4505                	li	a0,1
    80001ff2:	b3bff0ef          	jal	80001b2c <argraw>
    80001ff6:	fc840593          	addi	a1,s0,-56
    80001ffa:	4509                	li	a0,2
    80001ffc:	b31ff0ef          	jal	80001b2c <argraw>
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002000:	fff9071b          	addiw	a4,s2,-1
    80002004:	47e5                	li	a5,25
    80002006:	04e7e563          	bltu	a5,a4,80002050 <syscall+0x96>
    int num = myproc()->trapframe->a7;
    8000200a:	2901                	sext.w	s2,s2
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000200c:	00391713          	slli	a4,s2,0x3
    80002010:	00006797          	auipc	a5,0x6
    80002014:	8f078793          	addi	a5,a5,-1808 # 80007900 <syscall_names>
    80002018:	97ba                	add	a5,a5,a4
    8000201a:	1307b783          	ld	a5,304(a5)
    8000201e:	cb8d                	beqz	a5,80002050 <syscall+0x96>
    80002020:	f44e                	sd	s3,40(sp)
        uint64 ret = syscalls[num]();
    80002022:	9782                	jalr	a5
    80002024:	89aa                	mv	s3,a0
        if (p->trace_mask & (1 << num)) {
    80002026:	4705                	li	a4,1
    80002028:	0127173b          	sllw	a4,a4,s2
    8000202c:	1684a783          	lw	a5,360(s1)
    80002030:	8ff9                	and	a5,a5,a4
    80002032:	2781                	sext.w	a5,a5
    80002034:	e791                	bnez	a5,80002040 <syscall+0x86>
        p->trapframe->a0 = ret;
    80002036:	6cbc                	ld	a5,88(s1)
    80002038:	0737b823          	sd	s3,112(a5)
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000203c:	79a2                	ld	s3,40(sp)
    8000203e:	a821                	j	80002056 <syscall+0x9c>
            print_syscall(p, num, args, ret);
    80002040:	86aa                	mv	a3,a0
    80002042:	fb840613          	addi	a2,s0,-72
    80002046:	85ca                	mv	a1,s2
    80002048:	8526                	mv	a0,s1
    8000204a:	e4fff0ef          	jal	80001e98 <print_syscall>
    8000204e:	b7e5                	j	80002036 <syscall+0x7c>
        p->trapframe->a0 = -1;
    80002050:	6cbc                	ld	a5,88(s1)
    80002052:	577d                	li	a4,-1
    80002054:	fbb8                	sd	a4,112(a5)
}
    80002056:	60a6                	ld	ra,72(sp)
    80002058:	6406                	ld	s0,64(sp)
    8000205a:	74e2                	ld	s1,56(sp)
    8000205c:	7942                	ld	s2,48(sp)
    8000205e:	6161                	addi	sp,sp,80
    80002060:	8082                	ret

0000000080002062 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002062:	1101                	addi	sp,sp,-32
    80002064:	ec06                	sd	ra,24(sp)
    80002066:	e822                	sd	s0,16(sp)
    80002068:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000206a:	fec40593          	addi	a1,s0,-20
    8000206e:	4501                	li	a0,0
    80002070:	c69ff0ef          	jal	80001cd8 <argint>
  exit(n);
    80002074:	fec42503          	lw	a0,-20(s0)
    80002078:	bc4ff0ef          	jal	8000143c <exit>
  return 0;  // not reached
}
    8000207c:	4501                	li	a0,0
    8000207e:	60e2                	ld	ra,24(sp)
    80002080:	6442                	ld	s0,16(sp)
    80002082:	6105                	addi	sp,sp,32
    80002084:	8082                	ret

0000000080002086 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002086:	1141                	addi	sp,sp,-16
    80002088:	e406                	sd	ra,8(sp)
    8000208a:	e022                	sd	s0,0(sp)
    8000208c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000208e:	cc9fe0ef          	jal	80000d56 <myproc>
}
    80002092:	5908                	lw	a0,48(a0)
    80002094:	60a2                	ld	ra,8(sp)
    80002096:	6402                	ld	s0,0(sp)
    80002098:	0141                	addi	sp,sp,16
    8000209a:	8082                	ret

000000008000209c <sys_fork>:

uint64
sys_fork(void)
{
    8000209c:	1141                	addi	sp,sp,-16
    8000209e:	e406                	sd	ra,8(sp)
    800020a0:	e022                	sd	s0,0(sp)
    800020a2:	0800                	addi	s0,sp,16
  return fork();
    800020a4:	fddfe0ef          	jal	80001080 <fork>
}
    800020a8:	60a2                	ld	ra,8(sp)
    800020aa:	6402                	ld	s0,0(sp)
    800020ac:	0141                	addi	sp,sp,16
    800020ae:	8082                	ret

00000000800020b0 <sys_wait>:

uint64
sys_wait(void)
{
    800020b0:	1101                	addi	sp,sp,-32
    800020b2:	ec06                	sd	ra,24(sp)
    800020b4:	e822                	sd	s0,16(sp)
    800020b6:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800020b8:	fe840593          	addi	a1,s0,-24
    800020bc:	4501                	li	a0,0
    800020be:	cbdff0ef          	jal	80001d7a <argaddr>
  return wait(p);
    800020c2:	fe843503          	ld	a0,-24(s0)
    800020c6:	cccff0ef          	jal	80001592 <wait>
}
    800020ca:	60e2                	ld	ra,24(sp)
    800020cc:	6442                	ld	s0,16(sp)
    800020ce:	6105                	addi	sp,sp,32
    800020d0:	8082                	ret

00000000800020d2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020d2:	7179                	addi	sp,sp,-48
    800020d4:	f406                	sd	ra,40(sp)
    800020d6:	f022                	sd	s0,32(sp)
    800020d8:	ec26                	sd	s1,24(sp)
    800020da:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800020dc:	fdc40593          	addi	a1,s0,-36
    800020e0:	4501                	li	a0,0
    800020e2:	bf7ff0ef          	jal	80001cd8 <argint>
  addr = myproc()->sz;
    800020e6:	c71fe0ef          	jal	80000d56 <myproc>
    800020ea:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800020ec:	fdc42503          	lw	a0,-36(s0)
    800020f0:	f41fe0ef          	jal	80001030 <growproc>
    800020f4:	00054863          	bltz	a0,80002104 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    800020f8:	8526                	mv	a0,s1
    800020fa:	70a2                	ld	ra,40(sp)
    800020fc:	7402                	ld	s0,32(sp)
    800020fe:	64e2                	ld	s1,24(sp)
    80002100:	6145                	addi	sp,sp,48
    80002102:	8082                	ret
    return -1;
    80002104:	54fd                	li	s1,-1
    80002106:	bfcd                	j	800020f8 <sys_sbrk+0x26>

0000000080002108 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002108:	7139                	addi	sp,sp,-64
    8000210a:	fc06                	sd	ra,56(sp)
    8000210c:	f822                	sd	s0,48(sp)
    8000210e:	f04a                	sd	s2,32(sp)
    80002110:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002112:	fcc40593          	addi	a1,s0,-52
    80002116:	4501                	li	a0,0
    80002118:	bc1ff0ef          	jal	80001cd8 <argint>
  if(n < 0)
    8000211c:	fcc42783          	lw	a5,-52(s0)
    80002120:	0607c763          	bltz	a5,8000218e <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002124:	0000e517          	auipc	a0,0xe
    80002128:	5cc50513          	addi	a0,a0,1484 # 800106f0 <tickslock>
    8000212c:	245030ef          	jal	80005b70 <acquire>
  ticks0 = ticks;
    80002130:	00008917          	auipc	s2,0x8
    80002134:	55892903          	lw	s2,1368(s2) # 8000a688 <ticks>
  while(ticks - ticks0 < n){
    80002138:	fcc42783          	lw	a5,-52(s0)
    8000213c:	cf8d                	beqz	a5,80002176 <sys_sleep+0x6e>
    8000213e:	f426                	sd	s1,40(sp)
    80002140:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002142:	0000e997          	auipc	s3,0xe
    80002146:	5ae98993          	addi	s3,s3,1454 # 800106f0 <tickslock>
    8000214a:	00008497          	auipc	s1,0x8
    8000214e:	53e48493          	addi	s1,s1,1342 # 8000a688 <ticks>
    if(killed(myproc())){
    80002152:	c05fe0ef          	jal	80000d56 <myproc>
    80002156:	c12ff0ef          	jal	80001568 <killed>
    8000215a:	ed0d                	bnez	a0,80002194 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    8000215c:	85ce                	mv	a1,s3
    8000215e:	8526                	mv	a0,s1
    80002160:	9d0ff0ef          	jal	80001330 <sleep>
  while(ticks - ticks0 < n){
    80002164:	409c                	lw	a5,0(s1)
    80002166:	412787bb          	subw	a5,a5,s2
    8000216a:	fcc42703          	lw	a4,-52(s0)
    8000216e:	fee7e2e3          	bltu	a5,a4,80002152 <sys_sleep+0x4a>
    80002172:	74a2                	ld	s1,40(sp)
    80002174:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002176:	0000e517          	auipc	a0,0xe
    8000217a:	57a50513          	addi	a0,a0,1402 # 800106f0 <tickslock>
    8000217e:	28b030ef          	jal	80005c08 <release>
  return 0;
    80002182:	4501                	li	a0,0
}
    80002184:	70e2                	ld	ra,56(sp)
    80002186:	7442                	ld	s0,48(sp)
    80002188:	7902                	ld	s2,32(sp)
    8000218a:	6121                	addi	sp,sp,64
    8000218c:	8082                	ret
    n = 0;
    8000218e:	fc042623          	sw	zero,-52(s0)
    80002192:	bf49                	j	80002124 <sys_sleep+0x1c>
      release(&tickslock);
    80002194:	0000e517          	auipc	a0,0xe
    80002198:	55c50513          	addi	a0,a0,1372 # 800106f0 <tickslock>
    8000219c:	26d030ef          	jal	80005c08 <release>
      return -1;
    800021a0:	557d                	li	a0,-1
    800021a2:	74a2                	ld	s1,40(sp)
    800021a4:	69e2                	ld	s3,24(sp)
    800021a6:	bff9                	j	80002184 <sys_sleep+0x7c>

00000000800021a8 <sys_kill>:

uint64
sys_kill(void)
{
    800021a8:	1101                	addi	sp,sp,-32
    800021aa:	ec06                	sd	ra,24(sp)
    800021ac:	e822                	sd	s0,16(sp)
    800021ae:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800021b0:	fec40593          	addi	a1,s0,-20
    800021b4:	4501                	li	a0,0
    800021b6:	b23ff0ef          	jal	80001cd8 <argint>
  return kill(pid);
    800021ba:	fec42503          	lw	a0,-20(s0)
    800021be:	b20ff0ef          	jal	800014de <kill>
}
    800021c2:	60e2                	ld	ra,24(sp)
    800021c4:	6442                	ld	s0,16(sp)
    800021c6:	6105                	addi	sp,sp,32
    800021c8:	8082                	ret

00000000800021ca <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021ca:	1101                	addi	sp,sp,-32
    800021cc:	ec06                	sd	ra,24(sp)
    800021ce:	e822                	sd	s0,16(sp)
    800021d0:	e426                	sd	s1,8(sp)
    800021d2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021d4:	0000e517          	auipc	a0,0xe
    800021d8:	51c50513          	addi	a0,a0,1308 # 800106f0 <tickslock>
    800021dc:	195030ef          	jal	80005b70 <acquire>
  xticks = ticks;
    800021e0:	00008497          	auipc	s1,0x8
    800021e4:	4a84a483          	lw	s1,1192(s1) # 8000a688 <ticks>
  release(&tickslock);
    800021e8:	0000e517          	auipc	a0,0xe
    800021ec:	50850513          	addi	a0,a0,1288 # 800106f0 <tickslock>
    800021f0:	219030ef          	jal	80005c08 <release>
  return xticks;
}
    800021f4:	02049513          	slli	a0,s1,0x20
    800021f8:	9101                	srli	a0,a0,0x20
    800021fa:	60e2                	ld	ra,24(sp)
    800021fc:	6442                	ld	s0,16(sp)
    800021fe:	64a2                	ld	s1,8(sp)
    80002200:	6105                	addi	sp,sp,32
    80002202:	8082                	ret

0000000080002204 <sys_trace>:

/////////////////////////////////////////////////////////////

uint64
sys_trace(void)
{
    80002204:	1101                	addi	sp,sp,-32
    80002206:	ec06                	sd	ra,24(sp)
    80002208:	e822                	sd	s0,16(sp)
    8000220a:	1000                	addi	s0,sp,32
  uint32 mask;  //  unsigned int
  argint(0, (int*)&mask);  // Cast to int* for argint
    8000220c:	fec40593          	addi	a1,s0,-20
    80002210:	4501                	li	a0,0
    80002212:	ac7ff0ef          	jal	80001cd8 <argint>
  struct proc *p = myproc();
    80002216:	b41fe0ef          	jal	80000d56 <myproc>
  p->trace_mask = mask;
    8000221a:	fec42783          	lw	a5,-20(s0)
    8000221e:	16f52423          	sw	a5,360(a0)
  return 0;
}
    80002222:	4501                	li	a0,0
    80002224:	60e2                	ld	ra,24(sp)
    80002226:	6442                	ld	s0,16(sp)
    80002228:	6105                	addi	sp,sp,32
    8000222a:	8082                	ret

000000008000222c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000222c:	7179                	addi	sp,sp,-48
    8000222e:	f406                	sd	ra,40(sp)
    80002230:	f022                	sd	s0,32(sp)
    80002232:	ec26                	sd	s1,24(sp)
    80002234:	e84a                	sd	s2,16(sp)
    80002236:	e44e                	sd	s3,8(sp)
    80002238:	e052                	sd	s4,0(sp)
    8000223a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000223c:	00005597          	auipc	a1,0x5
    80002240:	2d458593          	addi	a1,a1,724 # 80007510 <etext+0x510>
    80002244:	0000e517          	auipc	a0,0xe
    80002248:	53450513          	addi	a0,a0,1332 # 80010778 <bcache>
    8000224c:	0a5030ef          	jal	80005af0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002250:	00016797          	auipc	a5,0x16
    80002254:	52878793          	addi	a5,a5,1320 # 80018778 <bcache+0x8000>
    80002258:	00016717          	auipc	a4,0x16
    8000225c:	78870713          	addi	a4,a4,1928 # 800189e0 <bcache+0x8268>
    80002260:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002264:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002268:	0000e497          	auipc	s1,0xe
    8000226c:	52848493          	addi	s1,s1,1320 # 80010790 <bcache+0x18>
    b->next = bcache.head.next;
    80002270:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002272:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002274:	00005a17          	auipc	s4,0x5
    80002278:	2a4a0a13          	addi	s4,s4,676 # 80007518 <etext+0x518>
    b->next = bcache.head.next;
    8000227c:	2b893783          	ld	a5,696(s2)
    80002280:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002282:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002286:	85d2                	mv	a1,s4
    80002288:	01048513          	addi	a0,s1,16
    8000228c:	248010ef          	jal	800034d4 <initsleeplock>
    bcache.head.next->prev = b;
    80002290:	2b893783          	ld	a5,696(s2)
    80002294:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002296:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000229a:	45848493          	addi	s1,s1,1112
    8000229e:	fd349fe3          	bne	s1,s3,8000227c <binit+0x50>
  }
}
    800022a2:	70a2                	ld	ra,40(sp)
    800022a4:	7402                	ld	s0,32(sp)
    800022a6:	64e2                	ld	s1,24(sp)
    800022a8:	6942                	ld	s2,16(sp)
    800022aa:	69a2                	ld	s3,8(sp)
    800022ac:	6a02                	ld	s4,0(sp)
    800022ae:	6145                	addi	sp,sp,48
    800022b0:	8082                	ret

00000000800022b2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022b2:	7179                	addi	sp,sp,-48
    800022b4:	f406                	sd	ra,40(sp)
    800022b6:	f022                	sd	s0,32(sp)
    800022b8:	ec26                	sd	s1,24(sp)
    800022ba:	e84a                	sd	s2,16(sp)
    800022bc:	e44e                	sd	s3,8(sp)
    800022be:	1800                	addi	s0,sp,48
    800022c0:	892a                	mv	s2,a0
    800022c2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022c4:	0000e517          	auipc	a0,0xe
    800022c8:	4b450513          	addi	a0,a0,1204 # 80010778 <bcache>
    800022cc:	0a5030ef          	jal	80005b70 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022d0:	00016497          	auipc	s1,0x16
    800022d4:	7604b483          	ld	s1,1888(s1) # 80018a30 <bcache+0x82b8>
    800022d8:	00016797          	auipc	a5,0x16
    800022dc:	70878793          	addi	a5,a5,1800 # 800189e0 <bcache+0x8268>
    800022e0:	02f48b63          	beq	s1,a5,80002316 <bread+0x64>
    800022e4:	873e                	mv	a4,a5
    800022e6:	a021                	j	800022ee <bread+0x3c>
    800022e8:	68a4                	ld	s1,80(s1)
    800022ea:	02e48663          	beq	s1,a4,80002316 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    800022ee:	449c                	lw	a5,8(s1)
    800022f0:	ff279ce3          	bne	a5,s2,800022e8 <bread+0x36>
    800022f4:	44dc                	lw	a5,12(s1)
    800022f6:	ff3799e3          	bne	a5,s3,800022e8 <bread+0x36>
      b->refcnt++;
    800022fa:	40bc                	lw	a5,64(s1)
    800022fc:	2785                	addiw	a5,a5,1
    800022fe:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002300:	0000e517          	auipc	a0,0xe
    80002304:	47850513          	addi	a0,a0,1144 # 80010778 <bcache>
    80002308:	101030ef          	jal	80005c08 <release>
      acquiresleep(&b->lock);
    8000230c:	01048513          	addi	a0,s1,16
    80002310:	1fa010ef          	jal	8000350a <acquiresleep>
      return b;
    80002314:	a889                	j	80002366 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002316:	00016497          	auipc	s1,0x16
    8000231a:	7124b483          	ld	s1,1810(s1) # 80018a28 <bcache+0x82b0>
    8000231e:	00016797          	auipc	a5,0x16
    80002322:	6c278793          	addi	a5,a5,1730 # 800189e0 <bcache+0x8268>
    80002326:	00f48863          	beq	s1,a5,80002336 <bread+0x84>
    8000232a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000232c:	40bc                	lw	a5,64(s1)
    8000232e:	cb91                	beqz	a5,80002342 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002330:	64a4                	ld	s1,72(s1)
    80002332:	fee49de3          	bne	s1,a4,8000232c <bread+0x7a>
  panic("bget: no buffers");
    80002336:	00005517          	auipc	a0,0x5
    8000233a:	1ea50513          	addi	a0,a0,490 # 80007520 <etext+0x520>
    8000233e:	504030ef          	jal	80005842 <panic>
      b->dev = dev;
    80002342:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002346:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000234a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000234e:	4785                	li	a5,1
    80002350:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002352:	0000e517          	auipc	a0,0xe
    80002356:	42650513          	addi	a0,a0,1062 # 80010778 <bcache>
    8000235a:	0af030ef          	jal	80005c08 <release>
      acquiresleep(&b->lock);
    8000235e:	01048513          	addi	a0,s1,16
    80002362:	1a8010ef          	jal	8000350a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002366:	409c                	lw	a5,0(s1)
    80002368:	cb89                	beqz	a5,8000237a <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000236a:	8526                	mv	a0,s1
    8000236c:	70a2                	ld	ra,40(sp)
    8000236e:	7402                	ld	s0,32(sp)
    80002370:	64e2                	ld	s1,24(sp)
    80002372:	6942                	ld	s2,16(sp)
    80002374:	69a2                	ld	s3,8(sp)
    80002376:	6145                	addi	sp,sp,48
    80002378:	8082                	ret
    virtio_disk_rw(b, 0);
    8000237a:	4581                	li	a1,0
    8000237c:	8526                	mv	a0,s1
    8000237e:	293020ef          	jal	80004e10 <virtio_disk_rw>
    b->valid = 1;
    80002382:	4785                	li	a5,1
    80002384:	c09c                	sw	a5,0(s1)
  return b;
    80002386:	b7d5                	j	8000236a <bread+0xb8>

0000000080002388 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002388:	1101                	addi	sp,sp,-32
    8000238a:	ec06                	sd	ra,24(sp)
    8000238c:	e822                	sd	s0,16(sp)
    8000238e:	e426                	sd	s1,8(sp)
    80002390:	1000                	addi	s0,sp,32
    80002392:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002394:	0541                	addi	a0,a0,16
    80002396:	1f2010ef          	jal	80003588 <holdingsleep>
    8000239a:	c911                	beqz	a0,800023ae <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000239c:	4585                	li	a1,1
    8000239e:	8526                	mv	a0,s1
    800023a0:	271020ef          	jal	80004e10 <virtio_disk_rw>
}
    800023a4:	60e2                	ld	ra,24(sp)
    800023a6:	6442                	ld	s0,16(sp)
    800023a8:	64a2                	ld	s1,8(sp)
    800023aa:	6105                	addi	sp,sp,32
    800023ac:	8082                	ret
    panic("bwrite");
    800023ae:	00005517          	auipc	a0,0x5
    800023b2:	18a50513          	addi	a0,a0,394 # 80007538 <etext+0x538>
    800023b6:	48c030ef          	jal	80005842 <panic>

00000000800023ba <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800023ba:	1101                	addi	sp,sp,-32
    800023bc:	ec06                	sd	ra,24(sp)
    800023be:	e822                	sd	s0,16(sp)
    800023c0:	e426                	sd	s1,8(sp)
    800023c2:	e04a                	sd	s2,0(sp)
    800023c4:	1000                	addi	s0,sp,32
    800023c6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023c8:	01050913          	addi	s2,a0,16
    800023cc:	854a                	mv	a0,s2
    800023ce:	1ba010ef          	jal	80003588 <holdingsleep>
    800023d2:	c135                	beqz	a0,80002436 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    800023d4:	854a                	mv	a0,s2
    800023d6:	17a010ef          	jal	80003550 <releasesleep>

  acquire(&bcache.lock);
    800023da:	0000e517          	auipc	a0,0xe
    800023de:	39e50513          	addi	a0,a0,926 # 80010778 <bcache>
    800023e2:	78e030ef          	jal	80005b70 <acquire>
  b->refcnt--;
    800023e6:	40bc                	lw	a5,64(s1)
    800023e8:	37fd                	addiw	a5,a5,-1
    800023ea:	0007871b          	sext.w	a4,a5
    800023ee:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800023f0:	e71d                	bnez	a4,8000241e <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800023f2:	68b8                	ld	a4,80(s1)
    800023f4:	64bc                	ld	a5,72(s1)
    800023f6:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800023f8:	68b8                	ld	a4,80(s1)
    800023fa:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800023fc:	00016797          	auipc	a5,0x16
    80002400:	37c78793          	addi	a5,a5,892 # 80018778 <bcache+0x8000>
    80002404:	2b87b703          	ld	a4,696(a5)
    80002408:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000240a:	00016717          	auipc	a4,0x16
    8000240e:	5d670713          	addi	a4,a4,1494 # 800189e0 <bcache+0x8268>
    80002412:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002414:	2b87b703          	ld	a4,696(a5)
    80002418:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000241a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000241e:	0000e517          	auipc	a0,0xe
    80002422:	35a50513          	addi	a0,a0,858 # 80010778 <bcache>
    80002426:	7e2030ef          	jal	80005c08 <release>
}
    8000242a:	60e2                	ld	ra,24(sp)
    8000242c:	6442                	ld	s0,16(sp)
    8000242e:	64a2                	ld	s1,8(sp)
    80002430:	6902                	ld	s2,0(sp)
    80002432:	6105                	addi	sp,sp,32
    80002434:	8082                	ret
    panic("brelse");
    80002436:	00005517          	auipc	a0,0x5
    8000243a:	10a50513          	addi	a0,a0,266 # 80007540 <etext+0x540>
    8000243e:	404030ef          	jal	80005842 <panic>

0000000080002442 <bpin>:

void
bpin(struct buf *b) {
    80002442:	1101                	addi	sp,sp,-32
    80002444:	ec06                	sd	ra,24(sp)
    80002446:	e822                	sd	s0,16(sp)
    80002448:	e426                	sd	s1,8(sp)
    8000244a:	1000                	addi	s0,sp,32
    8000244c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000244e:	0000e517          	auipc	a0,0xe
    80002452:	32a50513          	addi	a0,a0,810 # 80010778 <bcache>
    80002456:	71a030ef          	jal	80005b70 <acquire>
  b->refcnt++;
    8000245a:	40bc                	lw	a5,64(s1)
    8000245c:	2785                	addiw	a5,a5,1
    8000245e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002460:	0000e517          	auipc	a0,0xe
    80002464:	31850513          	addi	a0,a0,792 # 80010778 <bcache>
    80002468:	7a0030ef          	jal	80005c08 <release>
}
    8000246c:	60e2                	ld	ra,24(sp)
    8000246e:	6442                	ld	s0,16(sp)
    80002470:	64a2                	ld	s1,8(sp)
    80002472:	6105                	addi	sp,sp,32
    80002474:	8082                	ret

0000000080002476 <bunpin>:

void
bunpin(struct buf *b) {
    80002476:	1101                	addi	sp,sp,-32
    80002478:	ec06                	sd	ra,24(sp)
    8000247a:	e822                	sd	s0,16(sp)
    8000247c:	e426                	sd	s1,8(sp)
    8000247e:	1000                	addi	s0,sp,32
    80002480:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002482:	0000e517          	auipc	a0,0xe
    80002486:	2f650513          	addi	a0,a0,758 # 80010778 <bcache>
    8000248a:	6e6030ef          	jal	80005b70 <acquire>
  b->refcnt--;
    8000248e:	40bc                	lw	a5,64(s1)
    80002490:	37fd                	addiw	a5,a5,-1
    80002492:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002494:	0000e517          	auipc	a0,0xe
    80002498:	2e450513          	addi	a0,a0,740 # 80010778 <bcache>
    8000249c:	76c030ef          	jal	80005c08 <release>
}
    800024a0:	60e2                	ld	ra,24(sp)
    800024a2:	6442                	ld	s0,16(sp)
    800024a4:	64a2                	ld	s1,8(sp)
    800024a6:	6105                	addi	sp,sp,32
    800024a8:	8082                	ret

00000000800024aa <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800024aa:	1101                	addi	sp,sp,-32
    800024ac:	ec06                	sd	ra,24(sp)
    800024ae:	e822                	sd	s0,16(sp)
    800024b0:	e426                	sd	s1,8(sp)
    800024b2:	e04a                	sd	s2,0(sp)
    800024b4:	1000                	addi	s0,sp,32
    800024b6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800024b8:	00d5d59b          	srliw	a1,a1,0xd
    800024bc:	00017797          	auipc	a5,0x17
    800024c0:	9987a783          	lw	a5,-1640(a5) # 80018e54 <sb+0x1c>
    800024c4:	9dbd                	addw	a1,a1,a5
    800024c6:	dedff0ef          	jal	800022b2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800024ca:	0074f713          	andi	a4,s1,7
    800024ce:	4785                	li	a5,1
    800024d0:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800024d4:	14ce                	slli	s1,s1,0x33
    800024d6:	90d9                	srli	s1,s1,0x36
    800024d8:	00950733          	add	a4,a0,s1
    800024dc:	05874703          	lbu	a4,88(a4)
    800024e0:	00e7f6b3          	and	a3,a5,a4
    800024e4:	c29d                	beqz	a3,8000250a <bfree+0x60>
    800024e6:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800024e8:	94aa                	add	s1,s1,a0
    800024ea:	fff7c793          	not	a5,a5
    800024ee:	8f7d                	and	a4,a4,a5
    800024f0:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800024f4:	711000ef          	jal	80003404 <log_write>
  brelse(bp);
    800024f8:	854a                	mv	a0,s2
    800024fa:	ec1ff0ef          	jal	800023ba <brelse>
}
    800024fe:	60e2                	ld	ra,24(sp)
    80002500:	6442                	ld	s0,16(sp)
    80002502:	64a2                	ld	s1,8(sp)
    80002504:	6902                	ld	s2,0(sp)
    80002506:	6105                	addi	sp,sp,32
    80002508:	8082                	ret
    panic("freeing free block");
    8000250a:	00005517          	auipc	a0,0x5
    8000250e:	03e50513          	addi	a0,a0,62 # 80007548 <etext+0x548>
    80002512:	330030ef          	jal	80005842 <panic>

0000000080002516 <balloc>:
{
    80002516:	711d                	addi	sp,sp,-96
    80002518:	ec86                	sd	ra,88(sp)
    8000251a:	e8a2                	sd	s0,80(sp)
    8000251c:	e4a6                	sd	s1,72(sp)
    8000251e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002520:	00017797          	auipc	a5,0x17
    80002524:	91c7a783          	lw	a5,-1764(a5) # 80018e3c <sb+0x4>
    80002528:	0e078f63          	beqz	a5,80002626 <balloc+0x110>
    8000252c:	e0ca                	sd	s2,64(sp)
    8000252e:	fc4e                	sd	s3,56(sp)
    80002530:	f852                	sd	s4,48(sp)
    80002532:	f456                	sd	s5,40(sp)
    80002534:	f05a                	sd	s6,32(sp)
    80002536:	ec5e                	sd	s7,24(sp)
    80002538:	e862                	sd	s8,16(sp)
    8000253a:	e466                	sd	s9,8(sp)
    8000253c:	8baa                	mv	s7,a0
    8000253e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002540:	00017b17          	auipc	s6,0x17
    80002544:	8f8b0b13          	addi	s6,s6,-1800 # 80018e38 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002548:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000254a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000254c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000254e:	6c89                	lui	s9,0x2
    80002550:	a0b5                	j	800025bc <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002552:	97ca                	add	a5,a5,s2
    80002554:	8e55                	or	a2,a2,a3
    80002556:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000255a:	854a                	mv	a0,s2
    8000255c:	6a9000ef          	jal	80003404 <log_write>
        brelse(bp);
    80002560:	854a                	mv	a0,s2
    80002562:	e59ff0ef          	jal	800023ba <brelse>
  bp = bread(dev, bno);
    80002566:	85a6                	mv	a1,s1
    80002568:	855e                	mv	a0,s7
    8000256a:	d49ff0ef          	jal	800022b2 <bread>
    8000256e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002570:	40000613          	li	a2,1024
    80002574:	4581                	li	a1,0
    80002576:	05850513          	addi	a0,a0,88
    8000257a:	bbbfd0ef          	jal	80000134 <memset>
  log_write(bp);
    8000257e:	854a                	mv	a0,s2
    80002580:	685000ef          	jal	80003404 <log_write>
  brelse(bp);
    80002584:	854a                	mv	a0,s2
    80002586:	e35ff0ef          	jal	800023ba <brelse>
}
    8000258a:	6906                	ld	s2,64(sp)
    8000258c:	79e2                	ld	s3,56(sp)
    8000258e:	7a42                	ld	s4,48(sp)
    80002590:	7aa2                	ld	s5,40(sp)
    80002592:	7b02                	ld	s6,32(sp)
    80002594:	6be2                	ld	s7,24(sp)
    80002596:	6c42                	ld	s8,16(sp)
    80002598:	6ca2                	ld	s9,8(sp)
}
    8000259a:	8526                	mv	a0,s1
    8000259c:	60e6                	ld	ra,88(sp)
    8000259e:	6446                	ld	s0,80(sp)
    800025a0:	64a6                	ld	s1,72(sp)
    800025a2:	6125                	addi	sp,sp,96
    800025a4:	8082                	ret
    brelse(bp);
    800025a6:	854a                	mv	a0,s2
    800025a8:	e13ff0ef          	jal	800023ba <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800025ac:	015c87bb          	addw	a5,s9,s5
    800025b0:	00078a9b          	sext.w	s5,a5
    800025b4:	004b2703          	lw	a4,4(s6)
    800025b8:	04eaff63          	bgeu	s5,a4,80002616 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800025bc:	41fad79b          	sraiw	a5,s5,0x1f
    800025c0:	0137d79b          	srliw	a5,a5,0x13
    800025c4:	015787bb          	addw	a5,a5,s5
    800025c8:	40d7d79b          	sraiw	a5,a5,0xd
    800025cc:	01cb2583          	lw	a1,28(s6)
    800025d0:	9dbd                	addw	a1,a1,a5
    800025d2:	855e                	mv	a0,s7
    800025d4:	cdfff0ef          	jal	800022b2 <bread>
    800025d8:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025da:	004b2503          	lw	a0,4(s6)
    800025de:	000a849b          	sext.w	s1,s5
    800025e2:	8762                	mv	a4,s8
    800025e4:	fca4f1e3          	bgeu	s1,a0,800025a6 <balloc+0x90>
      m = 1 << (bi % 8);
    800025e8:	00777693          	andi	a3,a4,7
    800025ec:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800025f0:	41f7579b          	sraiw	a5,a4,0x1f
    800025f4:	01d7d79b          	srliw	a5,a5,0x1d
    800025f8:	9fb9                	addw	a5,a5,a4
    800025fa:	4037d79b          	sraiw	a5,a5,0x3
    800025fe:	00f90633          	add	a2,s2,a5
    80002602:	05864603          	lbu	a2,88(a2)
    80002606:	00c6f5b3          	and	a1,a3,a2
    8000260a:	d5a1                	beqz	a1,80002552 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000260c:	2705                	addiw	a4,a4,1
    8000260e:	2485                	addiw	s1,s1,1
    80002610:	fd471ae3          	bne	a4,s4,800025e4 <balloc+0xce>
    80002614:	bf49                	j	800025a6 <balloc+0x90>
    80002616:	6906                	ld	s2,64(sp)
    80002618:	79e2                	ld	s3,56(sp)
    8000261a:	7a42                	ld	s4,48(sp)
    8000261c:	7aa2                	ld	s5,40(sp)
    8000261e:	7b02                	ld	s6,32(sp)
    80002620:	6be2                	ld	s7,24(sp)
    80002622:	6c42                	ld	s8,16(sp)
    80002624:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002626:	00005517          	auipc	a0,0x5
    8000262a:	f3a50513          	addi	a0,a0,-198 # 80007560 <etext+0x560>
    8000262e:	743020ef          	jal	80005570 <printf>
  return 0;
    80002632:	4481                	li	s1,0
    80002634:	b79d                	j	8000259a <balloc+0x84>

0000000080002636 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002636:	7179                	addi	sp,sp,-48
    80002638:	f406                	sd	ra,40(sp)
    8000263a:	f022                	sd	s0,32(sp)
    8000263c:	ec26                	sd	s1,24(sp)
    8000263e:	e84a                	sd	s2,16(sp)
    80002640:	e44e                	sd	s3,8(sp)
    80002642:	1800                	addi	s0,sp,48
    80002644:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002646:	47ad                	li	a5,11
    80002648:	02b7e663          	bltu	a5,a1,80002674 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    8000264c:	02059793          	slli	a5,a1,0x20
    80002650:	01e7d593          	srli	a1,a5,0x1e
    80002654:	00b504b3          	add	s1,a0,a1
    80002658:	0504a903          	lw	s2,80(s1)
    8000265c:	06091a63          	bnez	s2,800026d0 <bmap+0x9a>
      addr = balloc(ip->dev);
    80002660:	4108                	lw	a0,0(a0)
    80002662:	eb5ff0ef          	jal	80002516 <balloc>
    80002666:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000266a:	06090363          	beqz	s2,800026d0 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    8000266e:	0524a823          	sw	s2,80(s1)
    80002672:	a8b9                	j	800026d0 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002674:	ff45849b          	addiw	s1,a1,-12
    80002678:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000267c:	0ff00793          	li	a5,255
    80002680:	06e7ee63          	bltu	a5,a4,800026fc <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002684:	08052903          	lw	s2,128(a0)
    80002688:	00091d63          	bnez	s2,800026a2 <bmap+0x6c>
      addr = balloc(ip->dev);
    8000268c:	4108                	lw	a0,0(a0)
    8000268e:	e89ff0ef          	jal	80002516 <balloc>
    80002692:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002696:	02090d63          	beqz	s2,800026d0 <bmap+0x9a>
    8000269a:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000269c:	0929a023          	sw	s2,128(s3)
    800026a0:	a011                	j	800026a4 <bmap+0x6e>
    800026a2:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800026a4:	85ca                	mv	a1,s2
    800026a6:	0009a503          	lw	a0,0(s3)
    800026aa:	c09ff0ef          	jal	800022b2 <bread>
    800026ae:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800026b0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800026b4:	02049713          	slli	a4,s1,0x20
    800026b8:	01e75593          	srli	a1,a4,0x1e
    800026bc:	00b784b3          	add	s1,a5,a1
    800026c0:	0004a903          	lw	s2,0(s1)
    800026c4:	00090e63          	beqz	s2,800026e0 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800026c8:	8552                	mv	a0,s4
    800026ca:	cf1ff0ef          	jal	800023ba <brelse>
    return addr;
    800026ce:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800026d0:	854a                	mv	a0,s2
    800026d2:	70a2                	ld	ra,40(sp)
    800026d4:	7402                	ld	s0,32(sp)
    800026d6:	64e2                	ld	s1,24(sp)
    800026d8:	6942                	ld	s2,16(sp)
    800026da:	69a2                	ld	s3,8(sp)
    800026dc:	6145                	addi	sp,sp,48
    800026de:	8082                	ret
      addr = balloc(ip->dev);
    800026e0:	0009a503          	lw	a0,0(s3)
    800026e4:	e33ff0ef          	jal	80002516 <balloc>
    800026e8:	0005091b          	sext.w	s2,a0
      if(addr){
    800026ec:	fc090ee3          	beqz	s2,800026c8 <bmap+0x92>
        a[bn] = addr;
    800026f0:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800026f4:	8552                	mv	a0,s4
    800026f6:	50f000ef          	jal	80003404 <log_write>
    800026fa:	b7f9                	j	800026c8 <bmap+0x92>
    800026fc:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800026fe:	00005517          	auipc	a0,0x5
    80002702:	e7a50513          	addi	a0,a0,-390 # 80007578 <etext+0x578>
    80002706:	13c030ef          	jal	80005842 <panic>

000000008000270a <iget>:
{
    8000270a:	7179                	addi	sp,sp,-48
    8000270c:	f406                	sd	ra,40(sp)
    8000270e:	f022                	sd	s0,32(sp)
    80002710:	ec26                	sd	s1,24(sp)
    80002712:	e84a                	sd	s2,16(sp)
    80002714:	e44e                	sd	s3,8(sp)
    80002716:	e052                	sd	s4,0(sp)
    80002718:	1800                	addi	s0,sp,48
    8000271a:	89aa                	mv	s3,a0
    8000271c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000271e:	00016517          	auipc	a0,0x16
    80002722:	73a50513          	addi	a0,a0,1850 # 80018e58 <itable>
    80002726:	44a030ef          	jal	80005b70 <acquire>
  empty = 0;
    8000272a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000272c:	00016497          	auipc	s1,0x16
    80002730:	74448493          	addi	s1,s1,1860 # 80018e70 <itable+0x18>
    80002734:	00018697          	auipc	a3,0x18
    80002738:	1cc68693          	addi	a3,a3,460 # 8001a900 <log>
    8000273c:	a039                	j	8000274a <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000273e:	02090963          	beqz	s2,80002770 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002742:	08848493          	addi	s1,s1,136
    80002746:	02d48863          	beq	s1,a3,80002776 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000274a:	449c                	lw	a5,8(s1)
    8000274c:	fef059e3          	blez	a5,8000273e <iget+0x34>
    80002750:	4098                	lw	a4,0(s1)
    80002752:	ff3716e3          	bne	a4,s3,8000273e <iget+0x34>
    80002756:	40d8                	lw	a4,4(s1)
    80002758:	ff4713e3          	bne	a4,s4,8000273e <iget+0x34>
      ip->ref++;
    8000275c:	2785                	addiw	a5,a5,1
    8000275e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002760:	00016517          	auipc	a0,0x16
    80002764:	6f850513          	addi	a0,a0,1784 # 80018e58 <itable>
    80002768:	4a0030ef          	jal	80005c08 <release>
      return ip;
    8000276c:	8926                	mv	s2,s1
    8000276e:	a02d                	j	80002798 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002770:	fbe9                	bnez	a5,80002742 <iget+0x38>
      empty = ip;
    80002772:	8926                	mv	s2,s1
    80002774:	b7f9                	j	80002742 <iget+0x38>
  if(empty == 0)
    80002776:	02090a63          	beqz	s2,800027aa <iget+0xa0>
  ip->dev = dev;
    8000277a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000277e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002782:	4785                	li	a5,1
    80002784:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002788:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000278c:	00016517          	auipc	a0,0x16
    80002790:	6cc50513          	addi	a0,a0,1740 # 80018e58 <itable>
    80002794:	474030ef          	jal	80005c08 <release>
}
    80002798:	854a                	mv	a0,s2
    8000279a:	70a2                	ld	ra,40(sp)
    8000279c:	7402                	ld	s0,32(sp)
    8000279e:	64e2                	ld	s1,24(sp)
    800027a0:	6942                	ld	s2,16(sp)
    800027a2:	69a2                	ld	s3,8(sp)
    800027a4:	6a02                	ld	s4,0(sp)
    800027a6:	6145                	addi	sp,sp,48
    800027a8:	8082                	ret
    panic("iget: no inodes");
    800027aa:	00005517          	auipc	a0,0x5
    800027ae:	de650513          	addi	a0,a0,-538 # 80007590 <etext+0x590>
    800027b2:	090030ef          	jal	80005842 <panic>

00000000800027b6 <fsinit>:
fsinit(int dev) {
    800027b6:	7179                	addi	sp,sp,-48
    800027b8:	f406                	sd	ra,40(sp)
    800027ba:	f022                	sd	s0,32(sp)
    800027bc:	ec26                	sd	s1,24(sp)
    800027be:	e84a                	sd	s2,16(sp)
    800027c0:	e44e                	sd	s3,8(sp)
    800027c2:	1800                	addi	s0,sp,48
    800027c4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800027c6:	4585                	li	a1,1
    800027c8:	aebff0ef          	jal	800022b2 <bread>
    800027cc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800027ce:	00016997          	auipc	s3,0x16
    800027d2:	66a98993          	addi	s3,s3,1642 # 80018e38 <sb>
    800027d6:	02000613          	li	a2,32
    800027da:	05850593          	addi	a1,a0,88
    800027de:	854e                	mv	a0,s3
    800027e0:	9b1fd0ef          	jal	80000190 <memmove>
  brelse(bp);
    800027e4:	8526                	mv	a0,s1
    800027e6:	bd5ff0ef          	jal	800023ba <brelse>
  if(sb.magic != FSMAGIC)
    800027ea:	0009a703          	lw	a4,0(s3)
    800027ee:	102037b7          	lui	a5,0x10203
    800027f2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800027f6:	02f71063          	bne	a4,a5,80002816 <fsinit+0x60>
  initlog(dev, &sb);
    800027fa:	00016597          	auipc	a1,0x16
    800027fe:	63e58593          	addi	a1,a1,1598 # 80018e38 <sb>
    80002802:	854a                	mv	a0,s2
    80002804:	1f9000ef          	jal	800031fc <initlog>
}
    80002808:	70a2                	ld	ra,40(sp)
    8000280a:	7402                	ld	s0,32(sp)
    8000280c:	64e2                	ld	s1,24(sp)
    8000280e:	6942                	ld	s2,16(sp)
    80002810:	69a2                	ld	s3,8(sp)
    80002812:	6145                	addi	sp,sp,48
    80002814:	8082                	ret
    panic("invalid file system");
    80002816:	00005517          	auipc	a0,0x5
    8000281a:	d8a50513          	addi	a0,a0,-630 # 800075a0 <etext+0x5a0>
    8000281e:	024030ef          	jal	80005842 <panic>

0000000080002822 <iinit>:
{
    80002822:	7179                	addi	sp,sp,-48
    80002824:	f406                	sd	ra,40(sp)
    80002826:	f022                	sd	s0,32(sp)
    80002828:	ec26                	sd	s1,24(sp)
    8000282a:	e84a                	sd	s2,16(sp)
    8000282c:	e44e                	sd	s3,8(sp)
    8000282e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002830:	00005597          	auipc	a1,0x5
    80002834:	d8858593          	addi	a1,a1,-632 # 800075b8 <etext+0x5b8>
    80002838:	00016517          	auipc	a0,0x16
    8000283c:	62050513          	addi	a0,a0,1568 # 80018e58 <itable>
    80002840:	2b0030ef          	jal	80005af0 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002844:	00016497          	auipc	s1,0x16
    80002848:	63c48493          	addi	s1,s1,1596 # 80018e80 <itable+0x28>
    8000284c:	00018997          	auipc	s3,0x18
    80002850:	0c498993          	addi	s3,s3,196 # 8001a910 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002854:	00005917          	auipc	s2,0x5
    80002858:	d6c90913          	addi	s2,s2,-660 # 800075c0 <etext+0x5c0>
    8000285c:	85ca                	mv	a1,s2
    8000285e:	8526                	mv	a0,s1
    80002860:	475000ef          	jal	800034d4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002864:	08848493          	addi	s1,s1,136
    80002868:	ff349ae3          	bne	s1,s3,8000285c <iinit+0x3a>
}
    8000286c:	70a2                	ld	ra,40(sp)
    8000286e:	7402                	ld	s0,32(sp)
    80002870:	64e2                	ld	s1,24(sp)
    80002872:	6942                	ld	s2,16(sp)
    80002874:	69a2                	ld	s3,8(sp)
    80002876:	6145                	addi	sp,sp,48
    80002878:	8082                	ret

000000008000287a <ialloc>:
{
    8000287a:	7139                	addi	sp,sp,-64
    8000287c:	fc06                	sd	ra,56(sp)
    8000287e:	f822                	sd	s0,48(sp)
    80002880:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002882:	00016717          	auipc	a4,0x16
    80002886:	5c272703          	lw	a4,1474(a4) # 80018e44 <sb+0xc>
    8000288a:	4785                	li	a5,1
    8000288c:	06e7f063          	bgeu	a5,a4,800028ec <ialloc+0x72>
    80002890:	f426                	sd	s1,40(sp)
    80002892:	f04a                	sd	s2,32(sp)
    80002894:	ec4e                	sd	s3,24(sp)
    80002896:	e852                	sd	s4,16(sp)
    80002898:	e456                	sd	s5,8(sp)
    8000289a:	e05a                	sd	s6,0(sp)
    8000289c:	8aaa                	mv	s5,a0
    8000289e:	8b2e                	mv	s6,a1
    800028a0:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800028a2:	00016a17          	auipc	s4,0x16
    800028a6:	596a0a13          	addi	s4,s4,1430 # 80018e38 <sb>
    800028aa:	00495593          	srli	a1,s2,0x4
    800028ae:	018a2783          	lw	a5,24(s4)
    800028b2:	9dbd                	addw	a1,a1,a5
    800028b4:	8556                	mv	a0,s5
    800028b6:	9fdff0ef          	jal	800022b2 <bread>
    800028ba:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800028bc:	05850993          	addi	s3,a0,88
    800028c0:	00f97793          	andi	a5,s2,15
    800028c4:	079a                	slli	a5,a5,0x6
    800028c6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800028c8:	00099783          	lh	a5,0(s3)
    800028cc:	cb9d                	beqz	a5,80002902 <ialloc+0x88>
    brelse(bp);
    800028ce:	aedff0ef          	jal	800023ba <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800028d2:	0905                	addi	s2,s2,1
    800028d4:	00ca2703          	lw	a4,12(s4)
    800028d8:	0009079b          	sext.w	a5,s2
    800028dc:	fce7e7e3          	bltu	a5,a4,800028aa <ialloc+0x30>
    800028e0:	74a2                	ld	s1,40(sp)
    800028e2:	7902                	ld	s2,32(sp)
    800028e4:	69e2                	ld	s3,24(sp)
    800028e6:	6a42                	ld	s4,16(sp)
    800028e8:	6aa2                	ld	s5,8(sp)
    800028ea:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800028ec:	00005517          	auipc	a0,0x5
    800028f0:	cdc50513          	addi	a0,a0,-804 # 800075c8 <etext+0x5c8>
    800028f4:	47d020ef          	jal	80005570 <printf>
  return 0;
    800028f8:	4501                	li	a0,0
}
    800028fa:	70e2                	ld	ra,56(sp)
    800028fc:	7442                	ld	s0,48(sp)
    800028fe:	6121                	addi	sp,sp,64
    80002900:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002902:	04000613          	li	a2,64
    80002906:	4581                	li	a1,0
    80002908:	854e                	mv	a0,s3
    8000290a:	82bfd0ef          	jal	80000134 <memset>
      dip->type = type;
    8000290e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002912:	8526                	mv	a0,s1
    80002914:	2f1000ef          	jal	80003404 <log_write>
      brelse(bp);
    80002918:	8526                	mv	a0,s1
    8000291a:	aa1ff0ef          	jal	800023ba <brelse>
      return iget(dev, inum);
    8000291e:	0009059b          	sext.w	a1,s2
    80002922:	8556                	mv	a0,s5
    80002924:	de7ff0ef          	jal	8000270a <iget>
    80002928:	74a2                	ld	s1,40(sp)
    8000292a:	7902                	ld	s2,32(sp)
    8000292c:	69e2                	ld	s3,24(sp)
    8000292e:	6a42                	ld	s4,16(sp)
    80002930:	6aa2                	ld	s5,8(sp)
    80002932:	6b02                	ld	s6,0(sp)
    80002934:	b7d9                	j	800028fa <ialloc+0x80>

0000000080002936 <iupdate>:
{
    80002936:	1101                	addi	sp,sp,-32
    80002938:	ec06                	sd	ra,24(sp)
    8000293a:	e822                	sd	s0,16(sp)
    8000293c:	e426                	sd	s1,8(sp)
    8000293e:	e04a                	sd	s2,0(sp)
    80002940:	1000                	addi	s0,sp,32
    80002942:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002944:	415c                	lw	a5,4(a0)
    80002946:	0047d79b          	srliw	a5,a5,0x4
    8000294a:	00016597          	auipc	a1,0x16
    8000294e:	5065a583          	lw	a1,1286(a1) # 80018e50 <sb+0x18>
    80002952:	9dbd                	addw	a1,a1,a5
    80002954:	4108                	lw	a0,0(a0)
    80002956:	95dff0ef          	jal	800022b2 <bread>
    8000295a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000295c:	05850793          	addi	a5,a0,88
    80002960:	40d8                	lw	a4,4(s1)
    80002962:	8b3d                	andi	a4,a4,15
    80002964:	071a                	slli	a4,a4,0x6
    80002966:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002968:	04449703          	lh	a4,68(s1)
    8000296c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002970:	04649703          	lh	a4,70(s1)
    80002974:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002978:	04849703          	lh	a4,72(s1)
    8000297c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002980:	04a49703          	lh	a4,74(s1)
    80002984:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002988:	44f8                	lw	a4,76(s1)
    8000298a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000298c:	03400613          	li	a2,52
    80002990:	05048593          	addi	a1,s1,80
    80002994:	00c78513          	addi	a0,a5,12
    80002998:	ff8fd0ef          	jal	80000190 <memmove>
  log_write(bp);
    8000299c:	854a                	mv	a0,s2
    8000299e:	267000ef          	jal	80003404 <log_write>
  brelse(bp);
    800029a2:	854a                	mv	a0,s2
    800029a4:	a17ff0ef          	jal	800023ba <brelse>
}
    800029a8:	60e2                	ld	ra,24(sp)
    800029aa:	6442                	ld	s0,16(sp)
    800029ac:	64a2                	ld	s1,8(sp)
    800029ae:	6902                	ld	s2,0(sp)
    800029b0:	6105                	addi	sp,sp,32
    800029b2:	8082                	ret

00000000800029b4 <idup>:
{
    800029b4:	1101                	addi	sp,sp,-32
    800029b6:	ec06                	sd	ra,24(sp)
    800029b8:	e822                	sd	s0,16(sp)
    800029ba:	e426                	sd	s1,8(sp)
    800029bc:	1000                	addi	s0,sp,32
    800029be:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800029c0:	00016517          	auipc	a0,0x16
    800029c4:	49850513          	addi	a0,a0,1176 # 80018e58 <itable>
    800029c8:	1a8030ef          	jal	80005b70 <acquire>
  ip->ref++;
    800029cc:	449c                	lw	a5,8(s1)
    800029ce:	2785                	addiw	a5,a5,1
    800029d0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800029d2:	00016517          	auipc	a0,0x16
    800029d6:	48650513          	addi	a0,a0,1158 # 80018e58 <itable>
    800029da:	22e030ef          	jal	80005c08 <release>
}
    800029de:	8526                	mv	a0,s1
    800029e0:	60e2                	ld	ra,24(sp)
    800029e2:	6442                	ld	s0,16(sp)
    800029e4:	64a2                	ld	s1,8(sp)
    800029e6:	6105                	addi	sp,sp,32
    800029e8:	8082                	ret

00000000800029ea <ilock>:
{
    800029ea:	1101                	addi	sp,sp,-32
    800029ec:	ec06                	sd	ra,24(sp)
    800029ee:	e822                	sd	s0,16(sp)
    800029f0:	e426                	sd	s1,8(sp)
    800029f2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800029f4:	cd19                	beqz	a0,80002a12 <ilock+0x28>
    800029f6:	84aa                	mv	s1,a0
    800029f8:	451c                	lw	a5,8(a0)
    800029fa:	00f05c63          	blez	a5,80002a12 <ilock+0x28>
  acquiresleep(&ip->lock);
    800029fe:	0541                	addi	a0,a0,16
    80002a00:	30b000ef          	jal	8000350a <acquiresleep>
  if(ip->valid == 0){
    80002a04:	40bc                	lw	a5,64(s1)
    80002a06:	cf89                	beqz	a5,80002a20 <ilock+0x36>
}
    80002a08:	60e2                	ld	ra,24(sp)
    80002a0a:	6442                	ld	s0,16(sp)
    80002a0c:	64a2                	ld	s1,8(sp)
    80002a0e:	6105                	addi	sp,sp,32
    80002a10:	8082                	ret
    80002a12:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002a14:	00005517          	auipc	a0,0x5
    80002a18:	bcc50513          	addi	a0,a0,-1076 # 800075e0 <etext+0x5e0>
    80002a1c:	627020ef          	jal	80005842 <panic>
    80002a20:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a22:	40dc                	lw	a5,4(s1)
    80002a24:	0047d79b          	srliw	a5,a5,0x4
    80002a28:	00016597          	auipc	a1,0x16
    80002a2c:	4285a583          	lw	a1,1064(a1) # 80018e50 <sb+0x18>
    80002a30:	9dbd                	addw	a1,a1,a5
    80002a32:	4088                	lw	a0,0(s1)
    80002a34:	87fff0ef          	jal	800022b2 <bread>
    80002a38:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a3a:	05850593          	addi	a1,a0,88
    80002a3e:	40dc                	lw	a5,4(s1)
    80002a40:	8bbd                	andi	a5,a5,15
    80002a42:	079a                	slli	a5,a5,0x6
    80002a44:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002a46:	00059783          	lh	a5,0(a1)
    80002a4a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002a4e:	00259783          	lh	a5,2(a1)
    80002a52:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002a56:	00459783          	lh	a5,4(a1)
    80002a5a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002a5e:	00659783          	lh	a5,6(a1)
    80002a62:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002a66:	459c                	lw	a5,8(a1)
    80002a68:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002a6a:	03400613          	li	a2,52
    80002a6e:	05b1                	addi	a1,a1,12
    80002a70:	05048513          	addi	a0,s1,80
    80002a74:	f1cfd0ef          	jal	80000190 <memmove>
    brelse(bp);
    80002a78:	854a                	mv	a0,s2
    80002a7a:	941ff0ef          	jal	800023ba <brelse>
    ip->valid = 1;
    80002a7e:	4785                	li	a5,1
    80002a80:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002a82:	04449783          	lh	a5,68(s1)
    80002a86:	c399                	beqz	a5,80002a8c <ilock+0xa2>
    80002a88:	6902                	ld	s2,0(sp)
    80002a8a:	bfbd                	j	80002a08 <ilock+0x1e>
      panic("ilock: no type");
    80002a8c:	00005517          	auipc	a0,0x5
    80002a90:	b5c50513          	addi	a0,a0,-1188 # 800075e8 <etext+0x5e8>
    80002a94:	5af020ef          	jal	80005842 <panic>

0000000080002a98 <iunlock>:
{
    80002a98:	1101                	addi	sp,sp,-32
    80002a9a:	ec06                	sd	ra,24(sp)
    80002a9c:	e822                	sd	s0,16(sp)
    80002a9e:	e426                	sd	s1,8(sp)
    80002aa0:	e04a                	sd	s2,0(sp)
    80002aa2:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002aa4:	c505                	beqz	a0,80002acc <iunlock+0x34>
    80002aa6:	84aa                	mv	s1,a0
    80002aa8:	01050913          	addi	s2,a0,16
    80002aac:	854a                	mv	a0,s2
    80002aae:	2db000ef          	jal	80003588 <holdingsleep>
    80002ab2:	cd09                	beqz	a0,80002acc <iunlock+0x34>
    80002ab4:	449c                	lw	a5,8(s1)
    80002ab6:	00f05b63          	blez	a5,80002acc <iunlock+0x34>
  releasesleep(&ip->lock);
    80002aba:	854a                	mv	a0,s2
    80002abc:	295000ef          	jal	80003550 <releasesleep>
}
    80002ac0:	60e2                	ld	ra,24(sp)
    80002ac2:	6442                	ld	s0,16(sp)
    80002ac4:	64a2                	ld	s1,8(sp)
    80002ac6:	6902                	ld	s2,0(sp)
    80002ac8:	6105                	addi	sp,sp,32
    80002aca:	8082                	ret
    panic("iunlock");
    80002acc:	00005517          	auipc	a0,0x5
    80002ad0:	b2c50513          	addi	a0,a0,-1236 # 800075f8 <etext+0x5f8>
    80002ad4:	56f020ef          	jal	80005842 <panic>

0000000080002ad8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002ad8:	7179                	addi	sp,sp,-48
    80002ada:	f406                	sd	ra,40(sp)
    80002adc:	f022                	sd	s0,32(sp)
    80002ade:	ec26                	sd	s1,24(sp)
    80002ae0:	e84a                	sd	s2,16(sp)
    80002ae2:	e44e                	sd	s3,8(sp)
    80002ae4:	1800                	addi	s0,sp,48
    80002ae6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ae8:	05050493          	addi	s1,a0,80
    80002aec:	08050913          	addi	s2,a0,128
    80002af0:	a021                	j	80002af8 <itrunc+0x20>
    80002af2:	0491                	addi	s1,s1,4
    80002af4:	01248b63          	beq	s1,s2,80002b0a <itrunc+0x32>
    if(ip->addrs[i]){
    80002af8:	408c                	lw	a1,0(s1)
    80002afa:	dde5                	beqz	a1,80002af2 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002afc:	0009a503          	lw	a0,0(s3)
    80002b00:	9abff0ef          	jal	800024aa <bfree>
      ip->addrs[i] = 0;
    80002b04:	0004a023          	sw	zero,0(s1)
    80002b08:	b7ed                	j	80002af2 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002b0a:	0809a583          	lw	a1,128(s3)
    80002b0e:	ed89                	bnez	a1,80002b28 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002b10:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002b14:	854e                	mv	a0,s3
    80002b16:	e21ff0ef          	jal	80002936 <iupdate>
}
    80002b1a:	70a2                	ld	ra,40(sp)
    80002b1c:	7402                	ld	s0,32(sp)
    80002b1e:	64e2                	ld	s1,24(sp)
    80002b20:	6942                	ld	s2,16(sp)
    80002b22:	69a2                	ld	s3,8(sp)
    80002b24:	6145                	addi	sp,sp,48
    80002b26:	8082                	ret
    80002b28:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002b2a:	0009a503          	lw	a0,0(s3)
    80002b2e:	f84ff0ef          	jal	800022b2 <bread>
    80002b32:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002b34:	05850493          	addi	s1,a0,88
    80002b38:	45850913          	addi	s2,a0,1112
    80002b3c:	a021                	j	80002b44 <itrunc+0x6c>
    80002b3e:	0491                	addi	s1,s1,4
    80002b40:	01248963          	beq	s1,s2,80002b52 <itrunc+0x7a>
      if(a[j])
    80002b44:	408c                	lw	a1,0(s1)
    80002b46:	dde5                	beqz	a1,80002b3e <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002b48:	0009a503          	lw	a0,0(s3)
    80002b4c:	95fff0ef          	jal	800024aa <bfree>
    80002b50:	b7fd                	j	80002b3e <itrunc+0x66>
    brelse(bp);
    80002b52:	8552                	mv	a0,s4
    80002b54:	867ff0ef          	jal	800023ba <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002b58:	0809a583          	lw	a1,128(s3)
    80002b5c:	0009a503          	lw	a0,0(s3)
    80002b60:	94bff0ef          	jal	800024aa <bfree>
    ip->addrs[NDIRECT] = 0;
    80002b64:	0809a023          	sw	zero,128(s3)
    80002b68:	6a02                	ld	s4,0(sp)
    80002b6a:	b75d                	j	80002b10 <itrunc+0x38>

0000000080002b6c <iput>:
{
    80002b6c:	1101                	addi	sp,sp,-32
    80002b6e:	ec06                	sd	ra,24(sp)
    80002b70:	e822                	sd	s0,16(sp)
    80002b72:	e426                	sd	s1,8(sp)
    80002b74:	1000                	addi	s0,sp,32
    80002b76:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b78:	00016517          	auipc	a0,0x16
    80002b7c:	2e050513          	addi	a0,a0,736 # 80018e58 <itable>
    80002b80:	7f1020ef          	jal	80005b70 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002b84:	4498                	lw	a4,8(s1)
    80002b86:	4785                	li	a5,1
    80002b88:	02f70063          	beq	a4,a5,80002ba8 <iput+0x3c>
  ip->ref--;
    80002b8c:	449c                	lw	a5,8(s1)
    80002b8e:	37fd                	addiw	a5,a5,-1
    80002b90:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b92:	00016517          	auipc	a0,0x16
    80002b96:	2c650513          	addi	a0,a0,710 # 80018e58 <itable>
    80002b9a:	06e030ef          	jal	80005c08 <release>
}
    80002b9e:	60e2                	ld	ra,24(sp)
    80002ba0:	6442                	ld	s0,16(sp)
    80002ba2:	64a2                	ld	s1,8(sp)
    80002ba4:	6105                	addi	sp,sp,32
    80002ba6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ba8:	40bc                	lw	a5,64(s1)
    80002baa:	d3ed                	beqz	a5,80002b8c <iput+0x20>
    80002bac:	04a49783          	lh	a5,74(s1)
    80002bb0:	fff1                	bnez	a5,80002b8c <iput+0x20>
    80002bb2:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002bb4:	01048913          	addi	s2,s1,16
    80002bb8:	854a                	mv	a0,s2
    80002bba:	151000ef          	jal	8000350a <acquiresleep>
    release(&itable.lock);
    80002bbe:	00016517          	auipc	a0,0x16
    80002bc2:	29a50513          	addi	a0,a0,666 # 80018e58 <itable>
    80002bc6:	042030ef          	jal	80005c08 <release>
    itrunc(ip);
    80002bca:	8526                	mv	a0,s1
    80002bcc:	f0dff0ef          	jal	80002ad8 <itrunc>
    ip->type = 0;
    80002bd0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002bd4:	8526                	mv	a0,s1
    80002bd6:	d61ff0ef          	jal	80002936 <iupdate>
    ip->valid = 0;
    80002bda:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002bde:	854a                	mv	a0,s2
    80002be0:	171000ef          	jal	80003550 <releasesleep>
    acquire(&itable.lock);
    80002be4:	00016517          	auipc	a0,0x16
    80002be8:	27450513          	addi	a0,a0,628 # 80018e58 <itable>
    80002bec:	785020ef          	jal	80005b70 <acquire>
    80002bf0:	6902                	ld	s2,0(sp)
    80002bf2:	bf69                	j	80002b8c <iput+0x20>

0000000080002bf4 <iunlockput>:
{
    80002bf4:	1101                	addi	sp,sp,-32
    80002bf6:	ec06                	sd	ra,24(sp)
    80002bf8:	e822                	sd	s0,16(sp)
    80002bfa:	e426                	sd	s1,8(sp)
    80002bfc:	1000                	addi	s0,sp,32
    80002bfe:	84aa                	mv	s1,a0
  iunlock(ip);
    80002c00:	e99ff0ef          	jal	80002a98 <iunlock>
  iput(ip);
    80002c04:	8526                	mv	a0,s1
    80002c06:	f67ff0ef          	jal	80002b6c <iput>
}
    80002c0a:	60e2                	ld	ra,24(sp)
    80002c0c:	6442                	ld	s0,16(sp)
    80002c0e:	64a2                	ld	s1,8(sp)
    80002c10:	6105                	addi	sp,sp,32
    80002c12:	8082                	ret

0000000080002c14 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002c14:	1141                	addi	sp,sp,-16
    80002c16:	e422                	sd	s0,8(sp)
    80002c18:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002c1a:	411c                	lw	a5,0(a0)
    80002c1c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002c1e:	415c                	lw	a5,4(a0)
    80002c20:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002c22:	04451783          	lh	a5,68(a0)
    80002c26:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002c2a:	04a51783          	lh	a5,74(a0)
    80002c2e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002c32:	04c56783          	lwu	a5,76(a0)
    80002c36:	e99c                	sd	a5,16(a1)
}
    80002c38:	6422                	ld	s0,8(sp)
    80002c3a:	0141                	addi	sp,sp,16
    80002c3c:	8082                	ret

0000000080002c3e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002c3e:	457c                	lw	a5,76(a0)
    80002c40:	0ed7eb63          	bltu	a5,a3,80002d36 <readi+0xf8>
{
    80002c44:	7159                	addi	sp,sp,-112
    80002c46:	f486                	sd	ra,104(sp)
    80002c48:	f0a2                	sd	s0,96(sp)
    80002c4a:	eca6                	sd	s1,88(sp)
    80002c4c:	e0d2                	sd	s4,64(sp)
    80002c4e:	fc56                	sd	s5,56(sp)
    80002c50:	f85a                	sd	s6,48(sp)
    80002c52:	f45e                	sd	s7,40(sp)
    80002c54:	1880                	addi	s0,sp,112
    80002c56:	8b2a                	mv	s6,a0
    80002c58:	8bae                	mv	s7,a1
    80002c5a:	8a32                	mv	s4,a2
    80002c5c:	84b6                	mv	s1,a3
    80002c5e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002c60:	9f35                	addw	a4,a4,a3
    return 0;
    80002c62:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002c64:	0cd76063          	bltu	a4,a3,80002d24 <readi+0xe6>
    80002c68:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002c6a:	00e7f463          	bgeu	a5,a4,80002c72 <readi+0x34>
    n = ip->size - off;
    80002c6e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002c72:	080a8f63          	beqz	s5,80002d10 <readi+0xd2>
    80002c76:	e8ca                	sd	s2,80(sp)
    80002c78:	f062                	sd	s8,32(sp)
    80002c7a:	ec66                	sd	s9,24(sp)
    80002c7c:	e86a                	sd	s10,16(sp)
    80002c7e:	e46e                	sd	s11,8(sp)
    80002c80:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c82:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002c86:	5c7d                	li	s8,-1
    80002c88:	a80d                	j	80002cba <readi+0x7c>
    80002c8a:	020d1d93          	slli	s11,s10,0x20
    80002c8e:	020ddd93          	srli	s11,s11,0x20
    80002c92:	05890613          	addi	a2,s2,88
    80002c96:	86ee                	mv	a3,s11
    80002c98:	963a                	add	a2,a2,a4
    80002c9a:	85d2                	mv	a1,s4
    80002c9c:	855e                	mv	a0,s7
    80002c9e:	9effe0ef          	jal	8000168c <either_copyout>
    80002ca2:	05850763          	beq	a0,s8,80002cf0 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ca6:	854a                	mv	a0,s2
    80002ca8:	f12ff0ef          	jal	800023ba <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002cac:	013d09bb          	addw	s3,s10,s3
    80002cb0:	009d04bb          	addw	s1,s10,s1
    80002cb4:	9a6e                	add	s4,s4,s11
    80002cb6:	0559f763          	bgeu	s3,s5,80002d04 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002cba:	00a4d59b          	srliw	a1,s1,0xa
    80002cbe:	855a                	mv	a0,s6
    80002cc0:	977ff0ef          	jal	80002636 <bmap>
    80002cc4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002cc8:	c5b1                	beqz	a1,80002d14 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002cca:	000b2503          	lw	a0,0(s6)
    80002cce:	de4ff0ef          	jal	800022b2 <bread>
    80002cd2:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002cd4:	3ff4f713          	andi	a4,s1,1023
    80002cd8:	40ec87bb          	subw	a5,s9,a4
    80002cdc:	413a86bb          	subw	a3,s5,s3
    80002ce0:	8d3e                	mv	s10,a5
    80002ce2:	2781                	sext.w	a5,a5
    80002ce4:	0006861b          	sext.w	a2,a3
    80002ce8:	faf671e3          	bgeu	a2,a5,80002c8a <readi+0x4c>
    80002cec:	8d36                	mv	s10,a3
    80002cee:	bf71                	j	80002c8a <readi+0x4c>
      brelse(bp);
    80002cf0:	854a                	mv	a0,s2
    80002cf2:	ec8ff0ef          	jal	800023ba <brelse>
      tot = -1;
    80002cf6:	59fd                	li	s3,-1
      break;
    80002cf8:	6946                	ld	s2,80(sp)
    80002cfa:	7c02                	ld	s8,32(sp)
    80002cfc:	6ce2                	ld	s9,24(sp)
    80002cfe:	6d42                	ld	s10,16(sp)
    80002d00:	6da2                	ld	s11,8(sp)
    80002d02:	a831                	j	80002d1e <readi+0xe0>
    80002d04:	6946                	ld	s2,80(sp)
    80002d06:	7c02                	ld	s8,32(sp)
    80002d08:	6ce2                	ld	s9,24(sp)
    80002d0a:	6d42                	ld	s10,16(sp)
    80002d0c:	6da2                	ld	s11,8(sp)
    80002d0e:	a801                	j	80002d1e <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d10:	89d6                	mv	s3,s5
    80002d12:	a031                	j	80002d1e <readi+0xe0>
    80002d14:	6946                	ld	s2,80(sp)
    80002d16:	7c02                	ld	s8,32(sp)
    80002d18:	6ce2                	ld	s9,24(sp)
    80002d1a:	6d42                	ld	s10,16(sp)
    80002d1c:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002d1e:	0009851b          	sext.w	a0,s3
    80002d22:	69a6                	ld	s3,72(sp)
}
    80002d24:	70a6                	ld	ra,104(sp)
    80002d26:	7406                	ld	s0,96(sp)
    80002d28:	64e6                	ld	s1,88(sp)
    80002d2a:	6a06                	ld	s4,64(sp)
    80002d2c:	7ae2                	ld	s5,56(sp)
    80002d2e:	7b42                	ld	s6,48(sp)
    80002d30:	7ba2                	ld	s7,40(sp)
    80002d32:	6165                	addi	sp,sp,112
    80002d34:	8082                	ret
    return 0;
    80002d36:	4501                	li	a0,0
}
    80002d38:	8082                	ret

0000000080002d3a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d3a:	457c                	lw	a5,76(a0)
    80002d3c:	10d7e063          	bltu	a5,a3,80002e3c <writei+0x102>
{
    80002d40:	7159                	addi	sp,sp,-112
    80002d42:	f486                	sd	ra,104(sp)
    80002d44:	f0a2                	sd	s0,96(sp)
    80002d46:	e8ca                	sd	s2,80(sp)
    80002d48:	e0d2                	sd	s4,64(sp)
    80002d4a:	fc56                	sd	s5,56(sp)
    80002d4c:	f85a                	sd	s6,48(sp)
    80002d4e:	f45e                	sd	s7,40(sp)
    80002d50:	1880                	addi	s0,sp,112
    80002d52:	8aaa                	mv	s5,a0
    80002d54:	8bae                	mv	s7,a1
    80002d56:	8a32                	mv	s4,a2
    80002d58:	8936                	mv	s2,a3
    80002d5a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002d5c:	00e687bb          	addw	a5,a3,a4
    80002d60:	0ed7e063          	bltu	a5,a3,80002e40 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002d64:	00043737          	lui	a4,0x43
    80002d68:	0cf76e63          	bltu	a4,a5,80002e44 <writei+0x10a>
    80002d6c:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002d6e:	0a0b0f63          	beqz	s6,80002e2c <writei+0xf2>
    80002d72:	eca6                	sd	s1,88(sp)
    80002d74:	f062                	sd	s8,32(sp)
    80002d76:	ec66                	sd	s9,24(sp)
    80002d78:	e86a                	sd	s10,16(sp)
    80002d7a:	e46e                	sd	s11,8(sp)
    80002d7c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002d7e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002d82:	5c7d                	li	s8,-1
    80002d84:	a825                	j	80002dbc <writei+0x82>
    80002d86:	020d1d93          	slli	s11,s10,0x20
    80002d8a:	020ddd93          	srli	s11,s11,0x20
    80002d8e:	05848513          	addi	a0,s1,88
    80002d92:	86ee                	mv	a3,s11
    80002d94:	8652                	mv	a2,s4
    80002d96:	85de                	mv	a1,s7
    80002d98:	953a                	add	a0,a0,a4
    80002d9a:	93dfe0ef          	jal	800016d6 <either_copyin>
    80002d9e:	05850a63          	beq	a0,s8,80002df2 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002da2:	8526                	mv	a0,s1
    80002da4:	660000ef          	jal	80003404 <log_write>
    brelse(bp);
    80002da8:	8526                	mv	a0,s1
    80002daa:	e10ff0ef          	jal	800023ba <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002dae:	013d09bb          	addw	s3,s10,s3
    80002db2:	012d093b          	addw	s2,s10,s2
    80002db6:	9a6e                	add	s4,s4,s11
    80002db8:	0569f063          	bgeu	s3,s6,80002df8 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002dbc:	00a9559b          	srliw	a1,s2,0xa
    80002dc0:	8556                	mv	a0,s5
    80002dc2:	875ff0ef          	jal	80002636 <bmap>
    80002dc6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002dca:	c59d                	beqz	a1,80002df8 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002dcc:	000aa503          	lw	a0,0(s5)
    80002dd0:	ce2ff0ef          	jal	800022b2 <bread>
    80002dd4:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dd6:	3ff97713          	andi	a4,s2,1023
    80002dda:	40ec87bb          	subw	a5,s9,a4
    80002dde:	413b06bb          	subw	a3,s6,s3
    80002de2:	8d3e                	mv	s10,a5
    80002de4:	2781                	sext.w	a5,a5
    80002de6:	0006861b          	sext.w	a2,a3
    80002dea:	f8f67ee3          	bgeu	a2,a5,80002d86 <writei+0x4c>
    80002dee:	8d36                	mv	s10,a3
    80002df0:	bf59                	j	80002d86 <writei+0x4c>
      brelse(bp);
    80002df2:	8526                	mv	a0,s1
    80002df4:	dc6ff0ef          	jal	800023ba <brelse>
  }

  if(off > ip->size)
    80002df8:	04caa783          	lw	a5,76(s5)
    80002dfc:	0327fa63          	bgeu	a5,s2,80002e30 <writei+0xf6>
    ip->size = off;
    80002e00:	052aa623          	sw	s2,76(s5)
    80002e04:	64e6                	ld	s1,88(sp)
    80002e06:	7c02                	ld	s8,32(sp)
    80002e08:	6ce2                	ld	s9,24(sp)
    80002e0a:	6d42                	ld	s10,16(sp)
    80002e0c:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002e0e:	8556                	mv	a0,s5
    80002e10:	b27ff0ef          	jal	80002936 <iupdate>

  return tot;
    80002e14:	0009851b          	sext.w	a0,s3
    80002e18:	69a6                	ld	s3,72(sp)
}
    80002e1a:	70a6                	ld	ra,104(sp)
    80002e1c:	7406                	ld	s0,96(sp)
    80002e1e:	6946                	ld	s2,80(sp)
    80002e20:	6a06                	ld	s4,64(sp)
    80002e22:	7ae2                	ld	s5,56(sp)
    80002e24:	7b42                	ld	s6,48(sp)
    80002e26:	7ba2                	ld	s7,40(sp)
    80002e28:	6165                	addi	sp,sp,112
    80002e2a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e2c:	89da                	mv	s3,s6
    80002e2e:	b7c5                	j	80002e0e <writei+0xd4>
    80002e30:	64e6                	ld	s1,88(sp)
    80002e32:	7c02                	ld	s8,32(sp)
    80002e34:	6ce2                	ld	s9,24(sp)
    80002e36:	6d42                	ld	s10,16(sp)
    80002e38:	6da2                	ld	s11,8(sp)
    80002e3a:	bfd1                	j	80002e0e <writei+0xd4>
    return -1;
    80002e3c:	557d                	li	a0,-1
}
    80002e3e:	8082                	ret
    return -1;
    80002e40:	557d                	li	a0,-1
    80002e42:	bfe1                	j	80002e1a <writei+0xe0>
    return -1;
    80002e44:	557d                	li	a0,-1
    80002e46:	bfd1                	j	80002e1a <writei+0xe0>

0000000080002e48 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002e48:	1141                	addi	sp,sp,-16
    80002e4a:	e406                	sd	ra,8(sp)
    80002e4c:	e022                	sd	s0,0(sp)
    80002e4e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002e50:	4639                	li	a2,14
    80002e52:	baefd0ef          	jal	80000200 <strncmp>
}
    80002e56:	60a2                	ld	ra,8(sp)
    80002e58:	6402                	ld	s0,0(sp)
    80002e5a:	0141                	addi	sp,sp,16
    80002e5c:	8082                	ret

0000000080002e5e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002e5e:	7139                	addi	sp,sp,-64
    80002e60:	fc06                	sd	ra,56(sp)
    80002e62:	f822                	sd	s0,48(sp)
    80002e64:	f426                	sd	s1,40(sp)
    80002e66:	f04a                	sd	s2,32(sp)
    80002e68:	ec4e                	sd	s3,24(sp)
    80002e6a:	e852                	sd	s4,16(sp)
    80002e6c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002e6e:	04451703          	lh	a4,68(a0)
    80002e72:	4785                	li	a5,1
    80002e74:	00f71a63          	bne	a4,a5,80002e88 <dirlookup+0x2a>
    80002e78:	892a                	mv	s2,a0
    80002e7a:	89ae                	mv	s3,a1
    80002e7c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e7e:	457c                	lw	a5,76(a0)
    80002e80:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002e82:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e84:	e39d                	bnez	a5,80002eaa <dirlookup+0x4c>
    80002e86:	a095                	j	80002eea <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002e88:	00004517          	auipc	a0,0x4
    80002e8c:	77850513          	addi	a0,a0,1912 # 80007600 <etext+0x600>
    80002e90:	1b3020ef          	jal	80005842 <panic>
      panic("dirlookup read");
    80002e94:	00004517          	auipc	a0,0x4
    80002e98:	78450513          	addi	a0,a0,1924 # 80007618 <etext+0x618>
    80002e9c:	1a7020ef          	jal	80005842 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ea0:	24c1                	addiw	s1,s1,16
    80002ea2:	04c92783          	lw	a5,76(s2)
    80002ea6:	04f4f163          	bgeu	s1,a5,80002ee8 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002eaa:	4741                	li	a4,16
    80002eac:	86a6                	mv	a3,s1
    80002eae:	fc040613          	addi	a2,s0,-64
    80002eb2:	4581                	li	a1,0
    80002eb4:	854a                	mv	a0,s2
    80002eb6:	d89ff0ef          	jal	80002c3e <readi>
    80002eba:	47c1                	li	a5,16
    80002ebc:	fcf51ce3          	bne	a0,a5,80002e94 <dirlookup+0x36>
    if(de.inum == 0)
    80002ec0:	fc045783          	lhu	a5,-64(s0)
    80002ec4:	dff1                	beqz	a5,80002ea0 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002ec6:	fc240593          	addi	a1,s0,-62
    80002eca:	854e                	mv	a0,s3
    80002ecc:	f7dff0ef          	jal	80002e48 <namecmp>
    80002ed0:	f961                	bnez	a0,80002ea0 <dirlookup+0x42>
      if(poff)
    80002ed2:	000a0463          	beqz	s4,80002eda <dirlookup+0x7c>
        *poff = off;
    80002ed6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002eda:	fc045583          	lhu	a1,-64(s0)
    80002ede:	00092503          	lw	a0,0(s2)
    80002ee2:	829ff0ef          	jal	8000270a <iget>
    80002ee6:	a011                	j	80002eea <dirlookup+0x8c>
  return 0;
    80002ee8:	4501                	li	a0,0
}
    80002eea:	70e2                	ld	ra,56(sp)
    80002eec:	7442                	ld	s0,48(sp)
    80002eee:	74a2                	ld	s1,40(sp)
    80002ef0:	7902                	ld	s2,32(sp)
    80002ef2:	69e2                	ld	s3,24(sp)
    80002ef4:	6a42                	ld	s4,16(sp)
    80002ef6:	6121                	addi	sp,sp,64
    80002ef8:	8082                	ret

0000000080002efa <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002efa:	711d                	addi	sp,sp,-96
    80002efc:	ec86                	sd	ra,88(sp)
    80002efe:	e8a2                	sd	s0,80(sp)
    80002f00:	e4a6                	sd	s1,72(sp)
    80002f02:	e0ca                	sd	s2,64(sp)
    80002f04:	fc4e                	sd	s3,56(sp)
    80002f06:	f852                	sd	s4,48(sp)
    80002f08:	f456                	sd	s5,40(sp)
    80002f0a:	f05a                	sd	s6,32(sp)
    80002f0c:	ec5e                	sd	s7,24(sp)
    80002f0e:	e862                	sd	s8,16(sp)
    80002f10:	e466                	sd	s9,8(sp)
    80002f12:	1080                	addi	s0,sp,96
    80002f14:	84aa                	mv	s1,a0
    80002f16:	8b2e                	mv	s6,a1
    80002f18:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002f1a:	00054703          	lbu	a4,0(a0)
    80002f1e:	02f00793          	li	a5,47
    80002f22:	00f70e63          	beq	a4,a5,80002f3e <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002f26:	e31fd0ef          	jal	80000d56 <myproc>
    80002f2a:	15053503          	ld	a0,336(a0)
    80002f2e:	a87ff0ef          	jal	800029b4 <idup>
    80002f32:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002f34:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002f38:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002f3a:	4b85                	li	s7,1
    80002f3c:	a871                	j	80002fd8 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002f3e:	4585                	li	a1,1
    80002f40:	4505                	li	a0,1
    80002f42:	fc8ff0ef          	jal	8000270a <iget>
    80002f46:	8a2a                	mv	s4,a0
    80002f48:	b7f5                	j	80002f34 <namex+0x3a>
      iunlockput(ip);
    80002f4a:	8552                	mv	a0,s4
    80002f4c:	ca9ff0ef          	jal	80002bf4 <iunlockput>
      return 0;
    80002f50:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002f52:	8552                	mv	a0,s4
    80002f54:	60e6                	ld	ra,88(sp)
    80002f56:	6446                	ld	s0,80(sp)
    80002f58:	64a6                	ld	s1,72(sp)
    80002f5a:	6906                	ld	s2,64(sp)
    80002f5c:	79e2                	ld	s3,56(sp)
    80002f5e:	7a42                	ld	s4,48(sp)
    80002f60:	7aa2                	ld	s5,40(sp)
    80002f62:	7b02                	ld	s6,32(sp)
    80002f64:	6be2                	ld	s7,24(sp)
    80002f66:	6c42                	ld	s8,16(sp)
    80002f68:	6ca2                	ld	s9,8(sp)
    80002f6a:	6125                	addi	sp,sp,96
    80002f6c:	8082                	ret
      iunlock(ip);
    80002f6e:	8552                	mv	a0,s4
    80002f70:	b29ff0ef          	jal	80002a98 <iunlock>
      return ip;
    80002f74:	bff9                	j	80002f52 <namex+0x58>
      iunlockput(ip);
    80002f76:	8552                	mv	a0,s4
    80002f78:	c7dff0ef          	jal	80002bf4 <iunlockput>
      return 0;
    80002f7c:	8a4e                	mv	s4,s3
    80002f7e:	bfd1                	j	80002f52 <namex+0x58>
  len = path - s;
    80002f80:	40998633          	sub	a2,s3,s1
    80002f84:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002f88:	099c5063          	bge	s8,s9,80003008 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002f8c:	4639                	li	a2,14
    80002f8e:	85a6                	mv	a1,s1
    80002f90:	8556                	mv	a0,s5
    80002f92:	9fefd0ef          	jal	80000190 <memmove>
    80002f96:	84ce                	mv	s1,s3
  while(*path == '/')
    80002f98:	0004c783          	lbu	a5,0(s1)
    80002f9c:	01279763          	bne	a5,s2,80002faa <namex+0xb0>
    path++;
    80002fa0:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002fa2:	0004c783          	lbu	a5,0(s1)
    80002fa6:	ff278de3          	beq	a5,s2,80002fa0 <namex+0xa6>
    ilock(ip);
    80002faa:	8552                	mv	a0,s4
    80002fac:	a3fff0ef          	jal	800029ea <ilock>
    if(ip->type != T_DIR){
    80002fb0:	044a1783          	lh	a5,68(s4)
    80002fb4:	f9779be3          	bne	a5,s7,80002f4a <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002fb8:	000b0563          	beqz	s6,80002fc2 <namex+0xc8>
    80002fbc:	0004c783          	lbu	a5,0(s1)
    80002fc0:	d7dd                	beqz	a5,80002f6e <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002fc2:	4601                	li	a2,0
    80002fc4:	85d6                	mv	a1,s5
    80002fc6:	8552                	mv	a0,s4
    80002fc8:	e97ff0ef          	jal	80002e5e <dirlookup>
    80002fcc:	89aa                	mv	s3,a0
    80002fce:	d545                	beqz	a0,80002f76 <namex+0x7c>
    iunlockput(ip);
    80002fd0:	8552                	mv	a0,s4
    80002fd2:	c23ff0ef          	jal	80002bf4 <iunlockput>
    ip = next;
    80002fd6:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002fd8:	0004c783          	lbu	a5,0(s1)
    80002fdc:	01279763          	bne	a5,s2,80002fea <namex+0xf0>
    path++;
    80002fe0:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002fe2:	0004c783          	lbu	a5,0(s1)
    80002fe6:	ff278de3          	beq	a5,s2,80002fe0 <namex+0xe6>
  if(*path == 0)
    80002fea:	cb8d                	beqz	a5,8000301c <namex+0x122>
  while(*path != '/' && *path != 0)
    80002fec:	0004c783          	lbu	a5,0(s1)
    80002ff0:	89a6                	mv	s3,s1
  len = path - s;
    80002ff2:	4c81                	li	s9,0
    80002ff4:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002ff6:	01278963          	beq	a5,s2,80003008 <namex+0x10e>
    80002ffa:	d3d9                	beqz	a5,80002f80 <namex+0x86>
    path++;
    80002ffc:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002ffe:	0009c783          	lbu	a5,0(s3)
    80003002:	ff279ce3          	bne	a5,s2,80002ffa <namex+0x100>
    80003006:	bfad                	j	80002f80 <namex+0x86>
    memmove(name, s, len);
    80003008:	2601                	sext.w	a2,a2
    8000300a:	85a6                	mv	a1,s1
    8000300c:	8556                	mv	a0,s5
    8000300e:	982fd0ef          	jal	80000190 <memmove>
    name[len] = 0;
    80003012:	9cd6                	add	s9,s9,s5
    80003014:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003018:	84ce                	mv	s1,s3
    8000301a:	bfbd                	j	80002f98 <namex+0x9e>
  if(nameiparent){
    8000301c:	f20b0be3          	beqz	s6,80002f52 <namex+0x58>
    iput(ip);
    80003020:	8552                	mv	a0,s4
    80003022:	b4bff0ef          	jal	80002b6c <iput>
    return 0;
    80003026:	4a01                	li	s4,0
    80003028:	b72d                	j	80002f52 <namex+0x58>

000000008000302a <dirlink>:
{
    8000302a:	7139                	addi	sp,sp,-64
    8000302c:	fc06                	sd	ra,56(sp)
    8000302e:	f822                	sd	s0,48(sp)
    80003030:	f04a                	sd	s2,32(sp)
    80003032:	ec4e                	sd	s3,24(sp)
    80003034:	e852                	sd	s4,16(sp)
    80003036:	0080                	addi	s0,sp,64
    80003038:	892a                	mv	s2,a0
    8000303a:	8a2e                	mv	s4,a1
    8000303c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000303e:	4601                	li	a2,0
    80003040:	e1fff0ef          	jal	80002e5e <dirlookup>
    80003044:	e535                	bnez	a0,800030b0 <dirlink+0x86>
    80003046:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003048:	04c92483          	lw	s1,76(s2)
    8000304c:	c48d                	beqz	s1,80003076 <dirlink+0x4c>
    8000304e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003050:	4741                	li	a4,16
    80003052:	86a6                	mv	a3,s1
    80003054:	fc040613          	addi	a2,s0,-64
    80003058:	4581                	li	a1,0
    8000305a:	854a                	mv	a0,s2
    8000305c:	be3ff0ef          	jal	80002c3e <readi>
    80003060:	47c1                	li	a5,16
    80003062:	04f51b63          	bne	a0,a5,800030b8 <dirlink+0x8e>
    if(de.inum == 0)
    80003066:	fc045783          	lhu	a5,-64(s0)
    8000306a:	c791                	beqz	a5,80003076 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000306c:	24c1                	addiw	s1,s1,16
    8000306e:	04c92783          	lw	a5,76(s2)
    80003072:	fcf4efe3          	bltu	s1,a5,80003050 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003076:	4639                	li	a2,14
    80003078:	85d2                	mv	a1,s4
    8000307a:	fc240513          	addi	a0,s0,-62
    8000307e:	9b8fd0ef          	jal	80000236 <strncpy>
  de.inum = inum;
    80003082:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003086:	4741                	li	a4,16
    80003088:	86a6                	mv	a3,s1
    8000308a:	fc040613          	addi	a2,s0,-64
    8000308e:	4581                	li	a1,0
    80003090:	854a                	mv	a0,s2
    80003092:	ca9ff0ef          	jal	80002d3a <writei>
    80003096:	1541                	addi	a0,a0,-16
    80003098:	00a03533          	snez	a0,a0
    8000309c:	40a00533          	neg	a0,a0
    800030a0:	74a2                	ld	s1,40(sp)
}
    800030a2:	70e2                	ld	ra,56(sp)
    800030a4:	7442                	ld	s0,48(sp)
    800030a6:	7902                	ld	s2,32(sp)
    800030a8:	69e2                	ld	s3,24(sp)
    800030aa:	6a42                	ld	s4,16(sp)
    800030ac:	6121                	addi	sp,sp,64
    800030ae:	8082                	ret
    iput(ip);
    800030b0:	abdff0ef          	jal	80002b6c <iput>
    return -1;
    800030b4:	557d                	li	a0,-1
    800030b6:	b7f5                	j	800030a2 <dirlink+0x78>
      panic("dirlink read");
    800030b8:	00004517          	auipc	a0,0x4
    800030bc:	57050513          	addi	a0,a0,1392 # 80007628 <etext+0x628>
    800030c0:	782020ef          	jal	80005842 <panic>

00000000800030c4 <namei>:

struct inode*
namei(char *path)
{
    800030c4:	1101                	addi	sp,sp,-32
    800030c6:	ec06                	sd	ra,24(sp)
    800030c8:	e822                	sd	s0,16(sp)
    800030ca:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800030cc:	fe040613          	addi	a2,s0,-32
    800030d0:	4581                	li	a1,0
    800030d2:	e29ff0ef          	jal	80002efa <namex>
}
    800030d6:	60e2                	ld	ra,24(sp)
    800030d8:	6442                	ld	s0,16(sp)
    800030da:	6105                	addi	sp,sp,32
    800030dc:	8082                	ret

00000000800030de <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800030de:	1141                	addi	sp,sp,-16
    800030e0:	e406                	sd	ra,8(sp)
    800030e2:	e022                	sd	s0,0(sp)
    800030e4:	0800                	addi	s0,sp,16
    800030e6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800030e8:	4585                	li	a1,1
    800030ea:	e11ff0ef          	jal	80002efa <namex>
}
    800030ee:	60a2                	ld	ra,8(sp)
    800030f0:	6402                	ld	s0,0(sp)
    800030f2:	0141                	addi	sp,sp,16
    800030f4:	8082                	ret

00000000800030f6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800030f6:	1101                	addi	sp,sp,-32
    800030f8:	ec06                	sd	ra,24(sp)
    800030fa:	e822                	sd	s0,16(sp)
    800030fc:	e426                	sd	s1,8(sp)
    800030fe:	e04a                	sd	s2,0(sp)
    80003100:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003102:	00017917          	auipc	s2,0x17
    80003106:	7fe90913          	addi	s2,s2,2046 # 8001a900 <log>
    8000310a:	01892583          	lw	a1,24(s2)
    8000310e:	02892503          	lw	a0,40(s2)
    80003112:	9a0ff0ef          	jal	800022b2 <bread>
    80003116:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003118:	02c92603          	lw	a2,44(s2)
    8000311c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000311e:	00c05f63          	blez	a2,8000313c <write_head+0x46>
    80003122:	00018717          	auipc	a4,0x18
    80003126:	80e70713          	addi	a4,a4,-2034 # 8001a930 <log+0x30>
    8000312a:	87aa                	mv	a5,a0
    8000312c:	060a                	slli	a2,a2,0x2
    8000312e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003130:	4314                	lw	a3,0(a4)
    80003132:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003134:	0711                	addi	a4,a4,4
    80003136:	0791                	addi	a5,a5,4
    80003138:	fec79ce3          	bne	a5,a2,80003130 <write_head+0x3a>
  }
  bwrite(buf);
    8000313c:	8526                	mv	a0,s1
    8000313e:	a4aff0ef          	jal	80002388 <bwrite>
  brelse(buf);
    80003142:	8526                	mv	a0,s1
    80003144:	a76ff0ef          	jal	800023ba <brelse>
}
    80003148:	60e2                	ld	ra,24(sp)
    8000314a:	6442                	ld	s0,16(sp)
    8000314c:	64a2                	ld	s1,8(sp)
    8000314e:	6902                	ld	s2,0(sp)
    80003150:	6105                	addi	sp,sp,32
    80003152:	8082                	ret

0000000080003154 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003154:	00017797          	auipc	a5,0x17
    80003158:	7d87a783          	lw	a5,2008(a5) # 8001a92c <log+0x2c>
    8000315c:	08f05f63          	blez	a5,800031fa <install_trans+0xa6>
{
    80003160:	7139                	addi	sp,sp,-64
    80003162:	fc06                	sd	ra,56(sp)
    80003164:	f822                	sd	s0,48(sp)
    80003166:	f426                	sd	s1,40(sp)
    80003168:	f04a                	sd	s2,32(sp)
    8000316a:	ec4e                	sd	s3,24(sp)
    8000316c:	e852                	sd	s4,16(sp)
    8000316e:	e456                	sd	s5,8(sp)
    80003170:	e05a                	sd	s6,0(sp)
    80003172:	0080                	addi	s0,sp,64
    80003174:	8b2a                	mv	s6,a0
    80003176:	00017a97          	auipc	s5,0x17
    8000317a:	7baa8a93          	addi	s5,s5,1978 # 8001a930 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000317e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003180:	00017997          	auipc	s3,0x17
    80003184:	78098993          	addi	s3,s3,1920 # 8001a900 <log>
    80003188:	a829                	j	800031a2 <install_trans+0x4e>
    brelse(lbuf);
    8000318a:	854a                	mv	a0,s2
    8000318c:	a2eff0ef          	jal	800023ba <brelse>
    brelse(dbuf);
    80003190:	8526                	mv	a0,s1
    80003192:	a28ff0ef          	jal	800023ba <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003196:	2a05                	addiw	s4,s4,1
    80003198:	0a91                	addi	s5,s5,4
    8000319a:	02c9a783          	lw	a5,44(s3)
    8000319e:	04fa5463          	bge	s4,a5,800031e6 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800031a2:	0189a583          	lw	a1,24(s3)
    800031a6:	014585bb          	addw	a1,a1,s4
    800031aa:	2585                	addiw	a1,a1,1
    800031ac:	0289a503          	lw	a0,40(s3)
    800031b0:	902ff0ef          	jal	800022b2 <bread>
    800031b4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800031b6:	000aa583          	lw	a1,0(s5)
    800031ba:	0289a503          	lw	a0,40(s3)
    800031be:	8f4ff0ef          	jal	800022b2 <bread>
    800031c2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800031c4:	40000613          	li	a2,1024
    800031c8:	05890593          	addi	a1,s2,88
    800031cc:	05850513          	addi	a0,a0,88
    800031d0:	fc1fc0ef          	jal	80000190 <memmove>
    bwrite(dbuf);  // write dst to disk
    800031d4:	8526                	mv	a0,s1
    800031d6:	9b2ff0ef          	jal	80002388 <bwrite>
    if(recovering == 0)
    800031da:	fa0b18e3          	bnez	s6,8000318a <install_trans+0x36>
      bunpin(dbuf);
    800031de:	8526                	mv	a0,s1
    800031e0:	a96ff0ef          	jal	80002476 <bunpin>
    800031e4:	b75d                	j	8000318a <install_trans+0x36>
}
    800031e6:	70e2                	ld	ra,56(sp)
    800031e8:	7442                	ld	s0,48(sp)
    800031ea:	74a2                	ld	s1,40(sp)
    800031ec:	7902                	ld	s2,32(sp)
    800031ee:	69e2                	ld	s3,24(sp)
    800031f0:	6a42                	ld	s4,16(sp)
    800031f2:	6aa2                	ld	s5,8(sp)
    800031f4:	6b02                	ld	s6,0(sp)
    800031f6:	6121                	addi	sp,sp,64
    800031f8:	8082                	ret
    800031fa:	8082                	ret

00000000800031fc <initlog>:
{
    800031fc:	7179                	addi	sp,sp,-48
    800031fe:	f406                	sd	ra,40(sp)
    80003200:	f022                	sd	s0,32(sp)
    80003202:	ec26                	sd	s1,24(sp)
    80003204:	e84a                	sd	s2,16(sp)
    80003206:	e44e                	sd	s3,8(sp)
    80003208:	1800                	addi	s0,sp,48
    8000320a:	892a                	mv	s2,a0
    8000320c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000320e:	00017497          	auipc	s1,0x17
    80003212:	6f248493          	addi	s1,s1,1778 # 8001a900 <log>
    80003216:	00004597          	auipc	a1,0x4
    8000321a:	42258593          	addi	a1,a1,1058 # 80007638 <etext+0x638>
    8000321e:	8526                	mv	a0,s1
    80003220:	0d1020ef          	jal	80005af0 <initlock>
  log.start = sb->logstart;
    80003224:	0149a583          	lw	a1,20(s3)
    80003228:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000322a:	0109a783          	lw	a5,16(s3)
    8000322e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003230:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003234:	854a                	mv	a0,s2
    80003236:	87cff0ef          	jal	800022b2 <bread>
  log.lh.n = lh->n;
    8000323a:	4d30                	lw	a2,88(a0)
    8000323c:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000323e:	00c05f63          	blez	a2,8000325c <initlog+0x60>
    80003242:	87aa                	mv	a5,a0
    80003244:	00017717          	auipc	a4,0x17
    80003248:	6ec70713          	addi	a4,a4,1772 # 8001a930 <log+0x30>
    8000324c:	060a                	slli	a2,a2,0x2
    8000324e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003250:	4ff4                	lw	a3,92(a5)
    80003252:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003254:	0791                	addi	a5,a5,4
    80003256:	0711                	addi	a4,a4,4
    80003258:	fec79ce3          	bne	a5,a2,80003250 <initlog+0x54>
  brelse(buf);
    8000325c:	95eff0ef          	jal	800023ba <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003260:	4505                	li	a0,1
    80003262:	ef3ff0ef          	jal	80003154 <install_trans>
  log.lh.n = 0;
    80003266:	00017797          	auipc	a5,0x17
    8000326a:	6c07a323          	sw	zero,1734(a5) # 8001a92c <log+0x2c>
  write_head(); // clear the log
    8000326e:	e89ff0ef          	jal	800030f6 <write_head>
}
    80003272:	70a2                	ld	ra,40(sp)
    80003274:	7402                	ld	s0,32(sp)
    80003276:	64e2                	ld	s1,24(sp)
    80003278:	6942                	ld	s2,16(sp)
    8000327a:	69a2                	ld	s3,8(sp)
    8000327c:	6145                	addi	sp,sp,48
    8000327e:	8082                	ret

0000000080003280 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003280:	1101                	addi	sp,sp,-32
    80003282:	ec06                	sd	ra,24(sp)
    80003284:	e822                	sd	s0,16(sp)
    80003286:	e426                	sd	s1,8(sp)
    80003288:	e04a                	sd	s2,0(sp)
    8000328a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000328c:	00017517          	auipc	a0,0x17
    80003290:	67450513          	addi	a0,a0,1652 # 8001a900 <log>
    80003294:	0dd020ef          	jal	80005b70 <acquire>
  while(1){
    if(log.committing){
    80003298:	00017497          	auipc	s1,0x17
    8000329c:	66848493          	addi	s1,s1,1640 # 8001a900 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800032a0:	4979                	li	s2,30
    800032a2:	a029                	j	800032ac <begin_op+0x2c>
      sleep(&log, &log.lock);
    800032a4:	85a6                	mv	a1,s1
    800032a6:	8526                	mv	a0,s1
    800032a8:	888fe0ef          	jal	80001330 <sleep>
    if(log.committing){
    800032ac:	50dc                	lw	a5,36(s1)
    800032ae:	fbfd                	bnez	a5,800032a4 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800032b0:	5098                	lw	a4,32(s1)
    800032b2:	2705                	addiw	a4,a4,1
    800032b4:	0027179b          	slliw	a5,a4,0x2
    800032b8:	9fb9                	addw	a5,a5,a4
    800032ba:	0017979b          	slliw	a5,a5,0x1
    800032be:	54d4                	lw	a3,44(s1)
    800032c0:	9fb5                	addw	a5,a5,a3
    800032c2:	00f95763          	bge	s2,a5,800032d0 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800032c6:	85a6                	mv	a1,s1
    800032c8:	8526                	mv	a0,s1
    800032ca:	866fe0ef          	jal	80001330 <sleep>
    800032ce:	bff9                	j	800032ac <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800032d0:	00017517          	auipc	a0,0x17
    800032d4:	63050513          	addi	a0,a0,1584 # 8001a900 <log>
    800032d8:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800032da:	12f020ef          	jal	80005c08 <release>
      break;
    }
  }
}
    800032de:	60e2                	ld	ra,24(sp)
    800032e0:	6442                	ld	s0,16(sp)
    800032e2:	64a2                	ld	s1,8(sp)
    800032e4:	6902                	ld	s2,0(sp)
    800032e6:	6105                	addi	sp,sp,32
    800032e8:	8082                	ret

00000000800032ea <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800032ea:	7139                	addi	sp,sp,-64
    800032ec:	fc06                	sd	ra,56(sp)
    800032ee:	f822                	sd	s0,48(sp)
    800032f0:	f426                	sd	s1,40(sp)
    800032f2:	f04a                	sd	s2,32(sp)
    800032f4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800032f6:	00017497          	auipc	s1,0x17
    800032fa:	60a48493          	addi	s1,s1,1546 # 8001a900 <log>
    800032fe:	8526                	mv	a0,s1
    80003300:	071020ef          	jal	80005b70 <acquire>
  log.outstanding -= 1;
    80003304:	509c                	lw	a5,32(s1)
    80003306:	37fd                	addiw	a5,a5,-1
    80003308:	0007891b          	sext.w	s2,a5
    8000330c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000330e:	50dc                	lw	a5,36(s1)
    80003310:	ef9d                	bnez	a5,8000334e <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003312:	04091763          	bnez	s2,80003360 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003316:	00017497          	auipc	s1,0x17
    8000331a:	5ea48493          	addi	s1,s1,1514 # 8001a900 <log>
    8000331e:	4785                	li	a5,1
    80003320:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003322:	8526                	mv	a0,s1
    80003324:	0e5020ef          	jal	80005c08 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003328:	54dc                	lw	a5,44(s1)
    8000332a:	04f04b63          	bgtz	a5,80003380 <end_op+0x96>
    acquire(&log.lock);
    8000332e:	00017497          	auipc	s1,0x17
    80003332:	5d248493          	addi	s1,s1,1490 # 8001a900 <log>
    80003336:	8526                	mv	a0,s1
    80003338:	039020ef          	jal	80005b70 <acquire>
    log.committing = 0;
    8000333c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003340:	8526                	mv	a0,s1
    80003342:	83afe0ef          	jal	8000137c <wakeup>
    release(&log.lock);
    80003346:	8526                	mv	a0,s1
    80003348:	0c1020ef          	jal	80005c08 <release>
}
    8000334c:	a025                	j	80003374 <end_op+0x8a>
    8000334e:	ec4e                	sd	s3,24(sp)
    80003350:	e852                	sd	s4,16(sp)
    80003352:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003354:	00004517          	auipc	a0,0x4
    80003358:	2ec50513          	addi	a0,a0,748 # 80007640 <etext+0x640>
    8000335c:	4e6020ef          	jal	80005842 <panic>
    wakeup(&log);
    80003360:	00017497          	auipc	s1,0x17
    80003364:	5a048493          	addi	s1,s1,1440 # 8001a900 <log>
    80003368:	8526                	mv	a0,s1
    8000336a:	812fe0ef          	jal	8000137c <wakeup>
  release(&log.lock);
    8000336e:	8526                	mv	a0,s1
    80003370:	099020ef          	jal	80005c08 <release>
}
    80003374:	70e2                	ld	ra,56(sp)
    80003376:	7442                	ld	s0,48(sp)
    80003378:	74a2                	ld	s1,40(sp)
    8000337a:	7902                	ld	s2,32(sp)
    8000337c:	6121                	addi	sp,sp,64
    8000337e:	8082                	ret
    80003380:	ec4e                	sd	s3,24(sp)
    80003382:	e852                	sd	s4,16(sp)
    80003384:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003386:	00017a97          	auipc	s5,0x17
    8000338a:	5aaa8a93          	addi	s5,s5,1450 # 8001a930 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000338e:	00017a17          	auipc	s4,0x17
    80003392:	572a0a13          	addi	s4,s4,1394 # 8001a900 <log>
    80003396:	018a2583          	lw	a1,24(s4)
    8000339a:	012585bb          	addw	a1,a1,s2
    8000339e:	2585                	addiw	a1,a1,1
    800033a0:	028a2503          	lw	a0,40(s4)
    800033a4:	f0ffe0ef          	jal	800022b2 <bread>
    800033a8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800033aa:	000aa583          	lw	a1,0(s5)
    800033ae:	028a2503          	lw	a0,40(s4)
    800033b2:	f01fe0ef          	jal	800022b2 <bread>
    800033b6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800033b8:	40000613          	li	a2,1024
    800033bc:	05850593          	addi	a1,a0,88
    800033c0:	05848513          	addi	a0,s1,88
    800033c4:	dcdfc0ef          	jal	80000190 <memmove>
    bwrite(to);  // write the log
    800033c8:	8526                	mv	a0,s1
    800033ca:	fbffe0ef          	jal	80002388 <bwrite>
    brelse(from);
    800033ce:	854e                	mv	a0,s3
    800033d0:	febfe0ef          	jal	800023ba <brelse>
    brelse(to);
    800033d4:	8526                	mv	a0,s1
    800033d6:	fe5fe0ef          	jal	800023ba <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033da:	2905                	addiw	s2,s2,1
    800033dc:	0a91                	addi	s5,s5,4
    800033de:	02ca2783          	lw	a5,44(s4)
    800033e2:	faf94ae3          	blt	s2,a5,80003396 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800033e6:	d11ff0ef          	jal	800030f6 <write_head>
    install_trans(0); // Now install writes to home locations
    800033ea:	4501                	li	a0,0
    800033ec:	d69ff0ef          	jal	80003154 <install_trans>
    log.lh.n = 0;
    800033f0:	00017797          	auipc	a5,0x17
    800033f4:	5207ae23          	sw	zero,1340(a5) # 8001a92c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800033f8:	cffff0ef          	jal	800030f6 <write_head>
    800033fc:	69e2                	ld	s3,24(sp)
    800033fe:	6a42                	ld	s4,16(sp)
    80003400:	6aa2                	ld	s5,8(sp)
    80003402:	b735                	j	8000332e <end_op+0x44>

0000000080003404 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003404:	1101                	addi	sp,sp,-32
    80003406:	ec06                	sd	ra,24(sp)
    80003408:	e822                	sd	s0,16(sp)
    8000340a:	e426                	sd	s1,8(sp)
    8000340c:	e04a                	sd	s2,0(sp)
    8000340e:	1000                	addi	s0,sp,32
    80003410:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003412:	00017917          	auipc	s2,0x17
    80003416:	4ee90913          	addi	s2,s2,1262 # 8001a900 <log>
    8000341a:	854a                	mv	a0,s2
    8000341c:	754020ef          	jal	80005b70 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003420:	02c92603          	lw	a2,44(s2)
    80003424:	47f5                	li	a5,29
    80003426:	06c7c363          	blt	a5,a2,8000348c <log_write+0x88>
    8000342a:	00017797          	auipc	a5,0x17
    8000342e:	4f27a783          	lw	a5,1266(a5) # 8001a91c <log+0x1c>
    80003432:	37fd                	addiw	a5,a5,-1
    80003434:	04f65c63          	bge	a2,a5,8000348c <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003438:	00017797          	auipc	a5,0x17
    8000343c:	4e87a783          	lw	a5,1256(a5) # 8001a920 <log+0x20>
    80003440:	04f05c63          	blez	a5,80003498 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003444:	4781                	li	a5,0
    80003446:	04c05f63          	blez	a2,800034a4 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000344a:	44cc                	lw	a1,12(s1)
    8000344c:	00017717          	auipc	a4,0x17
    80003450:	4e470713          	addi	a4,a4,1252 # 8001a930 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003454:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003456:	4314                	lw	a3,0(a4)
    80003458:	04b68663          	beq	a3,a1,800034a4 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    8000345c:	2785                	addiw	a5,a5,1
    8000345e:	0711                	addi	a4,a4,4
    80003460:	fef61be3          	bne	a2,a5,80003456 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003464:	0621                	addi	a2,a2,8
    80003466:	060a                	slli	a2,a2,0x2
    80003468:	00017797          	auipc	a5,0x17
    8000346c:	49878793          	addi	a5,a5,1176 # 8001a900 <log>
    80003470:	97b2                	add	a5,a5,a2
    80003472:	44d8                	lw	a4,12(s1)
    80003474:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003476:	8526                	mv	a0,s1
    80003478:	fcbfe0ef          	jal	80002442 <bpin>
    log.lh.n++;
    8000347c:	00017717          	auipc	a4,0x17
    80003480:	48470713          	addi	a4,a4,1156 # 8001a900 <log>
    80003484:	575c                	lw	a5,44(a4)
    80003486:	2785                	addiw	a5,a5,1
    80003488:	d75c                	sw	a5,44(a4)
    8000348a:	a80d                	j	800034bc <log_write+0xb8>
    panic("too big a transaction");
    8000348c:	00004517          	auipc	a0,0x4
    80003490:	1c450513          	addi	a0,a0,452 # 80007650 <etext+0x650>
    80003494:	3ae020ef          	jal	80005842 <panic>
    panic("log_write outside of trans");
    80003498:	00004517          	auipc	a0,0x4
    8000349c:	1d050513          	addi	a0,a0,464 # 80007668 <etext+0x668>
    800034a0:	3a2020ef          	jal	80005842 <panic>
  log.lh.block[i] = b->blockno;
    800034a4:	00878693          	addi	a3,a5,8
    800034a8:	068a                	slli	a3,a3,0x2
    800034aa:	00017717          	auipc	a4,0x17
    800034ae:	45670713          	addi	a4,a4,1110 # 8001a900 <log>
    800034b2:	9736                	add	a4,a4,a3
    800034b4:	44d4                	lw	a3,12(s1)
    800034b6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800034b8:	faf60fe3          	beq	a2,a5,80003476 <log_write+0x72>
  }
  release(&log.lock);
    800034bc:	00017517          	auipc	a0,0x17
    800034c0:	44450513          	addi	a0,a0,1092 # 8001a900 <log>
    800034c4:	744020ef          	jal	80005c08 <release>
}
    800034c8:	60e2                	ld	ra,24(sp)
    800034ca:	6442                	ld	s0,16(sp)
    800034cc:	64a2                	ld	s1,8(sp)
    800034ce:	6902                	ld	s2,0(sp)
    800034d0:	6105                	addi	sp,sp,32
    800034d2:	8082                	ret

00000000800034d4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800034d4:	1101                	addi	sp,sp,-32
    800034d6:	ec06                	sd	ra,24(sp)
    800034d8:	e822                	sd	s0,16(sp)
    800034da:	e426                	sd	s1,8(sp)
    800034dc:	e04a                	sd	s2,0(sp)
    800034de:	1000                	addi	s0,sp,32
    800034e0:	84aa                	mv	s1,a0
    800034e2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800034e4:	00004597          	auipc	a1,0x4
    800034e8:	1a458593          	addi	a1,a1,420 # 80007688 <etext+0x688>
    800034ec:	0521                	addi	a0,a0,8
    800034ee:	602020ef          	jal	80005af0 <initlock>
  lk->name = name;
    800034f2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800034f6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800034fa:	0204a423          	sw	zero,40(s1)
}
    800034fe:	60e2                	ld	ra,24(sp)
    80003500:	6442                	ld	s0,16(sp)
    80003502:	64a2                	ld	s1,8(sp)
    80003504:	6902                	ld	s2,0(sp)
    80003506:	6105                	addi	sp,sp,32
    80003508:	8082                	ret

000000008000350a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000350a:	1101                	addi	sp,sp,-32
    8000350c:	ec06                	sd	ra,24(sp)
    8000350e:	e822                	sd	s0,16(sp)
    80003510:	e426                	sd	s1,8(sp)
    80003512:	e04a                	sd	s2,0(sp)
    80003514:	1000                	addi	s0,sp,32
    80003516:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003518:	00850913          	addi	s2,a0,8
    8000351c:	854a                	mv	a0,s2
    8000351e:	652020ef          	jal	80005b70 <acquire>
  while (lk->locked) {
    80003522:	409c                	lw	a5,0(s1)
    80003524:	c799                	beqz	a5,80003532 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003526:	85ca                	mv	a1,s2
    80003528:	8526                	mv	a0,s1
    8000352a:	e07fd0ef          	jal	80001330 <sleep>
  while (lk->locked) {
    8000352e:	409c                	lw	a5,0(s1)
    80003530:	fbfd                	bnez	a5,80003526 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003532:	4785                	li	a5,1
    80003534:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003536:	821fd0ef          	jal	80000d56 <myproc>
    8000353a:	591c                	lw	a5,48(a0)
    8000353c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000353e:	854a                	mv	a0,s2
    80003540:	6c8020ef          	jal	80005c08 <release>
}
    80003544:	60e2                	ld	ra,24(sp)
    80003546:	6442                	ld	s0,16(sp)
    80003548:	64a2                	ld	s1,8(sp)
    8000354a:	6902                	ld	s2,0(sp)
    8000354c:	6105                	addi	sp,sp,32
    8000354e:	8082                	ret

0000000080003550 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003550:	1101                	addi	sp,sp,-32
    80003552:	ec06                	sd	ra,24(sp)
    80003554:	e822                	sd	s0,16(sp)
    80003556:	e426                	sd	s1,8(sp)
    80003558:	e04a                	sd	s2,0(sp)
    8000355a:	1000                	addi	s0,sp,32
    8000355c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000355e:	00850913          	addi	s2,a0,8
    80003562:	854a                	mv	a0,s2
    80003564:	60c020ef          	jal	80005b70 <acquire>
  lk->locked = 0;
    80003568:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000356c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003570:	8526                	mv	a0,s1
    80003572:	e0bfd0ef          	jal	8000137c <wakeup>
  release(&lk->lk);
    80003576:	854a                	mv	a0,s2
    80003578:	690020ef          	jal	80005c08 <release>
}
    8000357c:	60e2                	ld	ra,24(sp)
    8000357e:	6442                	ld	s0,16(sp)
    80003580:	64a2                	ld	s1,8(sp)
    80003582:	6902                	ld	s2,0(sp)
    80003584:	6105                	addi	sp,sp,32
    80003586:	8082                	ret

0000000080003588 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003588:	7179                	addi	sp,sp,-48
    8000358a:	f406                	sd	ra,40(sp)
    8000358c:	f022                	sd	s0,32(sp)
    8000358e:	ec26                	sd	s1,24(sp)
    80003590:	e84a                	sd	s2,16(sp)
    80003592:	1800                	addi	s0,sp,48
    80003594:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003596:	00850913          	addi	s2,a0,8
    8000359a:	854a                	mv	a0,s2
    8000359c:	5d4020ef          	jal	80005b70 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800035a0:	409c                	lw	a5,0(s1)
    800035a2:	ef81                	bnez	a5,800035ba <holdingsleep+0x32>
    800035a4:	4481                	li	s1,0
  release(&lk->lk);
    800035a6:	854a                	mv	a0,s2
    800035a8:	660020ef          	jal	80005c08 <release>
  return r;
}
    800035ac:	8526                	mv	a0,s1
    800035ae:	70a2                	ld	ra,40(sp)
    800035b0:	7402                	ld	s0,32(sp)
    800035b2:	64e2                	ld	s1,24(sp)
    800035b4:	6942                	ld	s2,16(sp)
    800035b6:	6145                	addi	sp,sp,48
    800035b8:	8082                	ret
    800035ba:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800035bc:	0284a983          	lw	s3,40(s1)
    800035c0:	f96fd0ef          	jal	80000d56 <myproc>
    800035c4:	5904                	lw	s1,48(a0)
    800035c6:	413484b3          	sub	s1,s1,s3
    800035ca:	0014b493          	seqz	s1,s1
    800035ce:	69a2                	ld	s3,8(sp)
    800035d0:	bfd9                	j	800035a6 <holdingsleep+0x1e>

00000000800035d2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800035d2:	1141                	addi	sp,sp,-16
    800035d4:	e406                	sd	ra,8(sp)
    800035d6:	e022                	sd	s0,0(sp)
    800035d8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800035da:	00004597          	auipc	a1,0x4
    800035de:	0be58593          	addi	a1,a1,190 # 80007698 <etext+0x698>
    800035e2:	00017517          	auipc	a0,0x17
    800035e6:	46650513          	addi	a0,a0,1126 # 8001aa48 <ftable>
    800035ea:	506020ef          	jal	80005af0 <initlock>
}
    800035ee:	60a2                	ld	ra,8(sp)
    800035f0:	6402                	ld	s0,0(sp)
    800035f2:	0141                	addi	sp,sp,16
    800035f4:	8082                	ret

00000000800035f6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800035f6:	1101                	addi	sp,sp,-32
    800035f8:	ec06                	sd	ra,24(sp)
    800035fa:	e822                	sd	s0,16(sp)
    800035fc:	e426                	sd	s1,8(sp)
    800035fe:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003600:	00017517          	auipc	a0,0x17
    80003604:	44850513          	addi	a0,a0,1096 # 8001aa48 <ftable>
    80003608:	568020ef          	jal	80005b70 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000360c:	00017497          	auipc	s1,0x17
    80003610:	45448493          	addi	s1,s1,1108 # 8001aa60 <ftable+0x18>
    80003614:	00018717          	auipc	a4,0x18
    80003618:	3ec70713          	addi	a4,a4,1004 # 8001ba00 <disk>
    if(f->ref == 0){
    8000361c:	40dc                	lw	a5,4(s1)
    8000361e:	cf89                	beqz	a5,80003638 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003620:	02848493          	addi	s1,s1,40
    80003624:	fee49ce3          	bne	s1,a4,8000361c <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003628:	00017517          	auipc	a0,0x17
    8000362c:	42050513          	addi	a0,a0,1056 # 8001aa48 <ftable>
    80003630:	5d8020ef          	jal	80005c08 <release>
  return 0;
    80003634:	4481                	li	s1,0
    80003636:	a809                	j	80003648 <filealloc+0x52>
      f->ref = 1;
    80003638:	4785                	li	a5,1
    8000363a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000363c:	00017517          	auipc	a0,0x17
    80003640:	40c50513          	addi	a0,a0,1036 # 8001aa48 <ftable>
    80003644:	5c4020ef          	jal	80005c08 <release>
}
    80003648:	8526                	mv	a0,s1
    8000364a:	60e2                	ld	ra,24(sp)
    8000364c:	6442                	ld	s0,16(sp)
    8000364e:	64a2                	ld	s1,8(sp)
    80003650:	6105                	addi	sp,sp,32
    80003652:	8082                	ret

0000000080003654 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003654:	1101                	addi	sp,sp,-32
    80003656:	ec06                	sd	ra,24(sp)
    80003658:	e822                	sd	s0,16(sp)
    8000365a:	e426                	sd	s1,8(sp)
    8000365c:	1000                	addi	s0,sp,32
    8000365e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003660:	00017517          	auipc	a0,0x17
    80003664:	3e850513          	addi	a0,a0,1000 # 8001aa48 <ftable>
    80003668:	508020ef          	jal	80005b70 <acquire>
  if(f->ref < 1)
    8000366c:	40dc                	lw	a5,4(s1)
    8000366e:	02f05063          	blez	a5,8000368e <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003672:	2785                	addiw	a5,a5,1
    80003674:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003676:	00017517          	auipc	a0,0x17
    8000367a:	3d250513          	addi	a0,a0,978 # 8001aa48 <ftable>
    8000367e:	58a020ef          	jal	80005c08 <release>
  return f;
}
    80003682:	8526                	mv	a0,s1
    80003684:	60e2                	ld	ra,24(sp)
    80003686:	6442                	ld	s0,16(sp)
    80003688:	64a2                	ld	s1,8(sp)
    8000368a:	6105                	addi	sp,sp,32
    8000368c:	8082                	ret
    panic("filedup");
    8000368e:	00004517          	auipc	a0,0x4
    80003692:	01250513          	addi	a0,a0,18 # 800076a0 <etext+0x6a0>
    80003696:	1ac020ef          	jal	80005842 <panic>

000000008000369a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000369a:	7139                	addi	sp,sp,-64
    8000369c:	fc06                	sd	ra,56(sp)
    8000369e:	f822                	sd	s0,48(sp)
    800036a0:	f426                	sd	s1,40(sp)
    800036a2:	0080                	addi	s0,sp,64
    800036a4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800036a6:	00017517          	auipc	a0,0x17
    800036aa:	3a250513          	addi	a0,a0,930 # 8001aa48 <ftable>
    800036ae:	4c2020ef          	jal	80005b70 <acquire>
  if(f->ref < 1)
    800036b2:	40dc                	lw	a5,4(s1)
    800036b4:	04f05a63          	blez	a5,80003708 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800036b8:	37fd                	addiw	a5,a5,-1
    800036ba:	0007871b          	sext.w	a4,a5
    800036be:	c0dc                	sw	a5,4(s1)
    800036c0:	04e04e63          	bgtz	a4,8000371c <fileclose+0x82>
    800036c4:	f04a                	sd	s2,32(sp)
    800036c6:	ec4e                	sd	s3,24(sp)
    800036c8:	e852                	sd	s4,16(sp)
    800036ca:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800036cc:	0004a903          	lw	s2,0(s1)
    800036d0:	0094ca83          	lbu	s5,9(s1)
    800036d4:	0104ba03          	ld	s4,16(s1)
    800036d8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800036dc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800036e0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800036e4:	00017517          	auipc	a0,0x17
    800036e8:	36450513          	addi	a0,a0,868 # 8001aa48 <ftable>
    800036ec:	51c020ef          	jal	80005c08 <release>

  if(ff.type == FD_PIPE){
    800036f0:	4785                	li	a5,1
    800036f2:	04f90063          	beq	s2,a5,80003732 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800036f6:	3979                	addiw	s2,s2,-2
    800036f8:	4785                	li	a5,1
    800036fa:	0527f563          	bgeu	a5,s2,80003744 <fileclose+0xaa>
    800036fe:	7902                	ld	s2,32(sp)
    80003700:	69e2                	ld	s3,24(sp)
    80003702:	6a42                	ld	s4,16(sp)
    80003704:	6aa2                	ld	s5,8(sp)
    80003706:	a00d                	j	80003728 <fileclose+0x8e>
    80003708:	f04a                	sd	s2,32(sp)
    8000370a:	ec4e                	sd	s3,24(sp)
    8000370c:	e852                	sd	s4,16(sp)
    8000370e:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003710:	00004517          	auipc	a0,0x4
    80003714:	f9850513          	addi	a0,a0,-104 # 800076a8 <etext+0x6a8>
    80003718:	12a020ef          	jal	80005842 <panic>
    release(&ftable.lock);
    8000371c:	00017517          	auipc	a0,0x17
    80003720:	32c50513          	addi	a0,a0,812 # 8001aa48 <ftable>
    80003724:	4e4020ef          	jal	80005c08 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003728:	70e2                	ld	ra,56(sp)
    8000372a:	7442                	ld	s0,48(sp)
    8000372c:	74a2                	ld	s1,40(sp)
    8000372e:	6121                	addi	sp,sp,64
    80003730:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003732:	85d6                	mv	a1,s5
    80003734:	8552                	mv	a0,s4
    80003736:	336000ef          	jal	80003a6c <pipeclose>
    8000373a:	7902                	ld	s2,32(sp)
    8000373c:	69e2                	ld	s3,24(sp)
    8000373e:	6a42                	ld	s4,16(sp)
    80003740:	6aa2                	ld	s5,8(sp)
    80003742:	b7dd                	j	80003728 <fileclose+0x8e>
    begin_op();
    80003744:	b3dff0ef          	jal	80003280 <begin_op>
    iput(ff.ip);
    80003748:	854e                	mv	a0,s3
    8000374a:	c22ff0ef          	jal	80002b6c <iput>
    end_op();
    8000374e:	b9dff0ef          	jal	800032ea <end_op>
    80003752:	7902                	ld	s2,32(sp)
    80003754:	69e2                	ld	s3,24(sp)
    80003756:	6a42                	ld	s4,16(sp)
    80003758:	6aa2                	ld	s5,8(sp)
    8000375a:	b7f9                	j	80003728 <fileclose+0x8e>

000000008000375c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000375c:	715d                	addi	sp,sp,-80
    8000375e:	e486                	sd	ra,72(sp)
    80003760:	e0a2                	sd	s0,64(sp)
    80003762:	fc26                	sd	s1,56(sp)
    80003764:	f44e                	sd	s3,40(sp)
    80003766:	0880                	addi	s0,sp,80
    80003768:	84aa                	mv	s1,a0
    8000376a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000376c:	deafd0ef          	jal	80000d56 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003770:	409c                	lw	a5,0(s1)
    80003772:	37f9                	addiw	a5,a5,-2
    80003774:	4705                	li	a4,1
    80003776:	04f76063          	bltu	a4,a5,800037b6 <filestat+0x5a>
    8000377a:	f84a                	sd	s2,48(sp)
    8000377c:	892a                	mv	s2,a0
    ilock(f->ip);
    8000377e:	6c88                	ld	a0,24(s1)
    80003780:	a6aff0ef          	jal	800029ea <ilock>
    stati(f->ip, &st);
    80003784:	fb840593          	addi	a1,s0,-72
    80003788:	6c88                	ld	a0,24(s1)
    8000378a:	c8aff0ef          	jal	80002c14 <stati>
    iunlock(f->ip);
    8000378e:	6c88                	ld	a0,24(s1)
    80003790:	b08ff0ef          	jal	80002a98 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003794:	46e1                	li	a3,24
    80003796:	fb840613          	addi	a2,s0,-72
    8000379a:	85ce                	mv	a1,s3
    8000379c:	05093503          	ld	a0,80(s2)
    800037a0:	a26fd0ef          	jal	800009c6 <copyout>
    800037a4:	41f5551b          	sraiw	a0,a0,0x1f
    800037a8:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800037aa:	60a6                	ld	ra,72(sp)
    800037ac:	6406                	ld	s0,64(sp)
    800037ae:	74e2                	ld	s1,56(sp)
    800037b0:	79a2                	ld	s3,40(sp)
    800037b2:	6161                	addi	sp,sp,80
    800037b4:	8082                	ret
  return -1;
    800037b6:	557d                	li	a0,-1
    800037b8:	bfcd                	j	800037aa <filestat+0x4e>

00000000800037ba <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800037ba:	7179                	addi	sp,sp,-48
    800037bc:	f406                	sd	ra,40(sp)
    800037be:	f022                	sd	s0,32(sp)
    800037c0:	e84a                	sd	s2,16(sp)
    800037c2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800037c4:	00854783          	lbu	a5,8(a0)
    800037c8:	cfd1                	beqz	a5,80003864 <fileread+0xaa>
    800037ca:	ec26                	sd	s1,24(sp)
    800037cc:	e44e                	sd	s3,8(sp)
    800037ce:	84aa                	mv	s1,a0
    800037d0:	89ae                	mv	s3,a1
    800037d2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800037d4:	411c                	lw	a5,0(a0)
    800037d6:	4705                	li	a4,1
    800037d8:	04e78363          	beq	a5,a4,8000381e <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800037dc:	470d                	li	a4,3
    800037de:	04e78763          	beq	a5,a4,8000382c <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800037e2:	4709                	li	a4,2
    800037e4:	06e79a63          	bne	a5,a4,80003858 <fileread+0x9e>
    ilock(f->ip);
    800037e8:	6d08                	ld	a0,24(a0)
    800037ea:	a00ff0ef          	jal	800029ea <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800037ee:	874a                	mv	a4,s2
    800037f0:	5094                	lw	a3,32(s1)
    800037f2:	864e                	mv	a2,s3
    800037f4:	4585                	li	a1,1
    800037f6:	6c88                	ld	a0,24(s1)
    800037f8:	c46ff0ef          	jal	80002c3e <readi>
    800037fc:	892a                	mv	s2,a0
    800037fe:	00a05563          	blez	a0,80003808 <fileread+0x4e>
      f->off += r;
    80003802:	509c                	lw	a5,32(s1)
    80003804:	9fa9                	addw	a5,a5,a0
    80003806:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003808:	6c88                	ld	a0,24(s1)
    8000380a:	a8eff0ef          	jal	80002a98 <iunlock>
    8000380e:	64e2                	ld	s1,24(sp)
    80003810:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003812:	854a                	mv	a0,s2
    80003814:	70a2                	ld	ra,40(sp)
    80003816:	7402                	ld	s0,32(sp)
    80003818:	6942                	ld	s2,16(sp)
    8000381a:	6145                	addi	sp,sp,48
    8000381c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000381e:	6908                	ld	a0,16(a0)
    80003820:	388000ef          	jal	80003ba8 <piperead>
    80003824:	892a                	mv	s2,a0
    80003826:	64e2                	ld	s1,24(sp)
    80003828:	69a2                	ld	s3,8(sp)
    8000382a:	b7e5                	j	80003812 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000382c:	02451783          	lh	a5,36(a0)
    80003830:	03079693          	slli	a3,a5,0x30
    80003834:	92c1                	srli	a3,a3,0x30
    80003836:	4725                	li	a4,9
    80003838:	02d76863          	bltu	a4,a3,80003868 <fileread+0xae>
    8000383c:	0792                	slli	a5,a5,0x4
    8000383e:	00017717          	auipc	a4,0x17
    80003842:	16a70713          	addi	a4,a4,362 # 8001a9a8 <devsw>
    80003846:	97ba                	add	a5,a5,a4
    80003848:	639c                	ld	a5,0(a5)
    8000384a:	c39d                	beqz	a5,80003870 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    8000384c:	4505                	li	a0,1
    8000384e:	9782                	jalr	a5
    80003850:	892a                	mv	s2,a0
    80003852:	64e2                	ld	s1,24(sp)
    80003854:	69a2                	ld	s3,8(sp)
    80003856:	bf75                	j	80003812 <fileread+0x58>
    panic("fileread");
    80003858:	00004517          	auipc	a0,0x4
    8000385c:	e6050513          	addi	a0,a0,-416 # 800076b8 <etext+0x6b8>
    80003860:	7e3010ef          	jal	80005842 <panic>
    return -1;
    80003864:	597d                	li	s2,-1
    80003866:	b775                	j	80003812 <fileread+0x58>
      return -1;
    80003868:	597d                	li	s2,-1
    8000386a:	64e2                	ld	s1,24(sp)
    8000386c:	69a2                	ld	s3,8(sp)
    8000386e:	b755                	j	80003812 <fileread+0x58>
    80003870:	597d                	li	s2,-1
    80003872:	64e2                	ld	s1,24(sp)
    80003874:	69a2                	ld	s3,8(sp)
    80003876:	bf71                	j	80003812 <fileread+0x58>

0000000080003878 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003878:	00954783          	lbu	a5,9(a0)
    8000387c:	10078b63          	beqz	a5,80003992 <filewrite+0x11a>
{
    80003880:	715d                	addi	sp,sp,-80
    80003882:	e486                	sd	ra,72(sp)
    80003884:	e0a2                	sd	s0,64(sp)
    80003886:	f84a                	sd	s2,48(sp)
    80003888:	f052                	sd	s4,32(sp)
    8000388a:	e85a                	sd	s6,16(sp)
    8000388c:	0880                	addi	s0,sp,80
    8000388e:	892a                	mv	s2,a0
    80003890:	8b2e                	mv	s6,a1
    80003892:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003894:	411c                	lw	a5,0(a0)
    80003896:	4705                	li	a4,1
    80003898:	02e78763          	beq	a5,a4,800038c6 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000389c:	470d                	li	a4,3
    8000389e:	02e78863          	beq	a5,a4,800038ce <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800038a2:	4709                	li	a4,2
    800038a4:	0ce79c63          	bne	a5,a4,8000397c <filewrite+0x104>
    800038a8:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800038aa:	0ac05863          	blez	a2,8000395a <filewrite+0xe2>
    800038ae:	fc26                	sd	s1,56(sp)
    800038b0:	ec56                	sd	s5,24(sp)
    800038b2:	e45e                	sd	s7,8(sp)
    800038b4:	e062                	sd	s8,0(sp)
    int i = 0;
    800038b6:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800038b8:	6b85                	lui	s7,0x1
    800038ba:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800038be:	6c05                	lui	s8,0x1
    800038c0:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800038c4:	a8b5                	j	80003940 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800038c6:	6908                	ld	a0,16(a0)
    800038c8:	1fc000ef          	jal	80003ac4 <pipewrite>
    800038cc:	a04d                	j	8000396e <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800038ce:	02451783          	lh	a5,36(a0)
    800038d2:	03079693          	slli	a3,a5,0x30
    800038d6:	92c1                	srli	a3,a3,0x30
    800038d8:	4725                	li	a4,9
    800038da:	0ad76e63          	bltu	a4,a3,80003996 <filewrite+0x11e>
    800038de:	0792                	slli	a5,a5,0x4
    800038e0:	00017717          	auipc	a4,0x17
    800038e4:	0c870713          	addi	a4,a4,200 # 8001a9a8 <devsw>
    800038e8:	97ba                	add	a5,a5,a4
    800038ea:	679c                	ld	a5,8(a5)
    800038ec:	c7dd                	beqz	a5,8000399a <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800038ee:	4505                	li	a0,1
    800038f0:	9782                	jalr	a5
    800038f2:	a8b5                	j	8000396e <filewrite+0xf6>
      if(n1 > max)
    800038f4:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800038f8:	989ff0ef          	jal	80003280 <begin_op>
      ilock(f->ip);
    800038fc:	01893503          	ld	a0,24(s2)
    80003900:	8eaff0ef          	jal	800029ea <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003904:	8756                	mv	a4,s5
    80003906:	02092683          	lw	a3,32(s2)
    8000390a:	01698633          	add	a2,s3,s6
    8000390e:	4585                	li	a1,1
    80003910:	01893503          	ld	a0,24(s2)
    80003914:	c26ff0ef          	jal	80002d3a <writei>
    80003918:	84aa                	mv	s1,a0
    8000391a:	00a05763          	blez	a0,80003928 <filewrite+0xb0>
        f->off += r;
    8000391e:	02092783          	lw	a5,32(s2)
    80003922:	9fa9                	addw	a5,a5,a0
    80003924:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003928:	01893503          	ld	a0,24(s2)
    8000392c:	96cff0ef          	jal	80002a98 <iunlock>
      end_op();
    80003930:	9bbff0ef          	jal	800032ea <end_op>

      if(r != n1){
    80003934:	029a9563          	bne	s5,s1,8000395e <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80003938:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000393c:	0149da63          	bge	s3,s4,80003950 <filewrite+0xd8>
      int n1 = n - i;
    80003940:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003944:	0004879b          	sext.w	a5,s1
    80003948:	fafbd6e3          	bge	s7,a5,800038f4 <filewrite+0x7c>
    8000394c:	84e2                	mv	s1,s8
    8000394e:	b75d                	j	800038f4 <filewrite+0x7c>
    80003950:	74e2                	ld	s1,56(sp)
    80003952:	6ae2                	ld	s5,24(sp)
    80003954:	6ba2                	ld	s7,8(sp)
    80003956:	6c02                	ld	s8,0(sp)
    80003958:	a039                	j	80003966 <filewrite+0xee>
    int i = 0;
    8000395a:	4981                	li	s3,0
    8000395c:	a029                	j	80003966 <filewrite+0xee>
    8000395e:	74e2                	ld	s1,56(sp)
    80003960:	6ae2                	ld	s5,24(sp)
    80003962:	6ba2                	ld	s7,8(sp)
    80003964:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003966:	033a1c63          	bne	s4,s3,8000399e <filewrite+0x126>
    8000396a:	8552                	mv	a0,s4
    8000396c:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000396e:	60a6                	ld	ra,72(sp)
    80003970:	6406                	ld	s0,64(sp)
    80003972:	7942                	ld	s2,48(sp)
    80003974:	7a02                	ld	s4,32(sp)
    80003976:	6b42                	ld	s6,16(sp)
    80003978:	6161                	addi	sp,sp,80
    8000397a:	8082                	ret
    8000397c:	fc26                	sd	s1,56(sp)
    8000397e:	f44e                	sd	s3,40(sp)
    80003980:	ec56                	sd	s5,24(sp)
    80003982:	e45e                	sd	s7,8(sp)
    80003984:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003986:	00004517          	auipc	a0,0x4
    8000398a:	d4250513          	addi	a0,a0,-702 # 800076c8 <etext+0x6c8>
    8000398e:	6b5010ef          	jal	80005842 <panic>
    return -1;
    80003992:	557d                	li	a0,-1
}
    80003994:	8082                	ret
      return -1;
    80003996:	557d                	li	a0,-1
    80003998:	bfd9                	j	8000396e <filewrite+0xf6>
    8000399a:	557d                	li	a0,-1
    8000399c:	bfc9                	j	8000396e <filewrite+0xf6>
    ret = (i == n ? n : -1);
    8000399e:	557d                	li	a0,-1
    800039a0:	79a2                	ld	s3,40(sp)
    800039a2:	b7f1                	j	8000396e <filewrite+0xf6>

00000000800039a4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800039a4:	7179                	addi	sp,sp,-48
    800039a6:	f406                	sd	ra,40(sp)
    800039a8:	f022                	sd	s0,32(sp)
    800039aa:	ec26                	sd	s1,24(sp)
    800039ac:	e052                	sd	s4,0(sp)
    800039ae:	1800                	addi	s0,sp,48
    800039b0:	84aa                	mv	s1,a0
    800039b2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800039b4:	0005b023          	sd	zero,0(a1)
    800039b8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800039bc:	c3bff0ef          	jal	800035f6 <filealloc>
    800039c0:	e088                	sd	a0,0(s1)
    800039c2:	c549                	beqz	a0,80003a4c <pipealloc+0xa8>
    800039c4:	c33ff0ef          	jal	800035f6 <filealloc>
    800039c8:	00aa3023          	sd	a0,0(s4)
    800039cc:	cd25                	beqz	a0,80003a44 <pipealloc+0xa0>
    800039ce:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800039d0:	f26fc0ef          	jal	800000f6 <kalloc>
    800039d4:	892a                	mv	s2,a0
    800039d6:	c12d                	beqz	a0,80003a38 <pipealloc+0x94>
    800039d8:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800039da:	4985                	li	s3,1
    800039dc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800039e0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800039e4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800039e8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800039ec:	00004597          	auipc	a1,0x4
    800039f0:	a7458593          	addi	a1,a1,-1420 # 80007460 <etext+0x460>
    800039f4:	0fc020ef          	jal	80005af0 <initlock>
  (*f0)->type = FD_PIPE;
    800039f8:	609c                	ld	a5,0(s1)
    800039fa:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800039fe:	609c                	ld	a5,0(s1)
    80003a00:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003a04:	609c                	ld	a5,0(s1)
    80003a06:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003a0a:	609c                	ld	a5,0(s1)
    80003a0c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003a10:	000a3783          	ld	a5,0(s4)
    80003a14:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003a18:	000a3783          	ld	a5,0(s4)
    80003a1c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003a20:	000a3783          	ld	a5,0(s4)
    80003a24:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003a28:	000a3783          	ld	a5,0(s4)
    80003a2c:	0127b823          	sd	s2,16(a5)
  return 0;
    80003a30:	4501                	li	a0,0
    80003a32:	6942                	ld	s2,16(sp)
    80003a34:	69a2                	ld	s3,8(sp)
    80003a36:	a01d                	j	80003a5c <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003a38:	6088                	ld	a0,0(s1)
    80003a3a:	c119                	beqz	a0,80003a40 <pipealloc+0x9c>
    80003a3c:	6942                	ld	s2,16(sp)
    80003a3e:	a029                	j	80003a48 <pipealloc+0xa4>
    80003a40:	6942                	ld	s2,16(sp)
    80003a42:	a029                	j	80003a4c <pipealloc+0xa8>
    80003a44:	6088                	ld	a0,0(s1)
    80003a46:	c10d                	beqz	a0,80003a68 <pipealloc+0xc4>
    fileclose(*f0);
    80003a48:	c53ff0ef          	jal	8000369a <fileclose>
  if(*f1)
    80003a4c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003a50:	557d                	li	a0,-1
  if(*f1)
    80003a52:	c789                	beqz	a5,80003a5c <pipealloc+0xb8>
    fileclose(*f1);
    80003a54:	853e                	mv	a0,a5
    80003a56:	c45ff0ef          	jal	8000369a <fileclose>
  return -1;
    80003a5a:	557d                	li	a0,-1
}
    80003a5c:	70a2                	ld	ra,40(sp)
    80003a5e:	7402                	ld	s0,32(sp)
    80003a60:	64e2                	ld	s1,24(sp)
    80003a62:	6a02                	ld	s4,0(sp)
    80003a64:	6145                	addi	sp,sp,48
    80003a66:	8082                	ret
  return -1;
    80003a68:	557d                	li	a0,-1
    80003a6a:	bfcd                	j	80003a5c <pipealloc+0xb8>

0000000080003a6c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003a6c:	1101                	addi	sp,sp,-32
    80003a6e:	ec06                	sd	ra,24(sp)
    80003a70:	e822                	sd	s0,16(sp)
    80003a72:	e426                	sd	s1,8(sp)
    80003a74:	e04a                	sd	s2,0(sp)
    80003a76:	1000                	addi	s0,sp,32
    80003a78:	84aa                	mv	s1,a0
    80003a7a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003a7c:	0f4020ef          	jal	80005b70 <acquire>
  if(writable){
    80003a80:	02090763          	beqz	s2,80003aae <pipeclose+0x42>
    pi->writeopen = 0;
    80003a84:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003a88:	21848513          	addi	a0,s1,536
    80003a8c:	8f1fd0ef          	jal	8000137c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003a90:	2204b783          	ld	a5,544(s1)
    80003a94:	e785                	bnez	a5,80003abc <pipeclose+0x50>
    release(&pi->lock);
    80003a96:	8526                	mv	a0,s1
    80003a98:	170020ef          	jal	80005c08 <release>
    kfree((char*)pi);
    80003a9c:	8526                	mv	a0,s1
    80003a9e:	d7efc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003aa2:	60e2                	ld	ra,24(sp)
    80003aa4:	6442                	ld	s0,16(sp)
    80003aa6:	64a2                	ld	s1,8(sp)
    80003aa8:	6902                	ld	s2,0(sp)
    80003aaa:	6105                	addi	sp,sp,32
    80003aac:	8082                	ret
    pi->readopen = 0;
    80003aae:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ab2:	21c48513          	addi	a0,s1,540
    80003ab6:	8c7fd0ef          	jal	8000137c <wakeup>
    80003aba:	bfd9                	j	80003a90 <pipeclose+0x24>
    release(&pi->lock);
    80003abc:	8526                	mv	a0,s1
    80003abe:	14a020ef          	jal	80005c08 <release>
}
    80003ac2:	b7c5                	j	80003aa2 <pipeclose+0x36>

0000000080003ac4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ac4:	711d                	addi	sp,sp,-96
    80003ac6:	ec86                	sd	ra,88(sp)
    80003ac8:	e8a2                	sd	s0,80(sp)
    80003aca:	e4a6                	sd	s1,72(sp)
    80003acc:	e0ca                	sd	s2,64(sp)
    80003ace:	fc4e                	sd	s3,56(sp)
    80003ad0:	f852                	sd	s4,48(sp)
    80003ad2:	f456                	sd	s5,40(sp)
    80003ad4:	1080                	addi	s0,sp,96
    80003ad6:	84aa                	mv	s1,a0
    80003ad8:	8aae                	mv	s5,a1
    80003ada:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003adc:	a7afd0ef          	jal	80000d56 <myproc>
    80003ae0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ae2:	8526                	mv	a0,s1
    80003ae4:	08c020ef          	jal	80005b70 <acquire>
  while(i < n){
    80003ae8:	0b405a63          	blez	s4,80003b9c <pipewrite+0xd8>
    80003aec:	f05a                	sd	s6,32(sp)
    80003aee:	ec5e                	sd	s7,24(sp)
    80003af0:	e862                	sd	s8,16(sp)
  int i = 0;
    80003af2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003af4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003af6:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003afa:	21c48b93          	addi	s7,s1,540
    80003afe:	a81d                	j	80003b34 <pipewrite+0x70>
      release(&pi->lock);
    80003b00:	8526                	mv	a0,s1
    80003b02:	106020ef          	jal	80005c08 <release>
      return -1;
    80003b06:	597d                	li	s2,-1
    80003b08:	7b02                	ld	s6,32(sp)
    80003b0a:	6be2                	ld	s7,24(sp)
    80003b0c:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003b0e:	854a                	mv	a0,s2
    80003b10:	60e6                	ld	ra,88(sp)
    80003b12:	6446                	ld	s0,80(sp)
    80003b14:	64a6                	ld	s1,72(sp)
    80003b16:	6906                	ld	s2,64(sp)
    80003b18:	79e2                	ld	s3,56(sp)
    80003b1a:	7a42                	ld	s4,48(sp)
    80003b1c:	7aa2                	ld	s5,40(sp)
    80003b1e:	6125                	addi	sp,sp,96
    80003b20:	8082                	ret
      wakeup(&pi->nread);
    80003b22:	8562                	mv	a0,s8
    80003b24:	859fd0ef          	jal	8000137c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003b28:	85a6                	mv	a1,s1
    80003b2a:	855e                	mv	a0,s7
    80003b2c:	805fd0ef          	jal	80001330 <sleep>
  while(i < n){
    80003b30:	05495b63          	bge	s2,s4,80003b86 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003b34:	2204a783          	lw	a5,544(s1)
    80003b38:	d7e1                	beqz	a5,80003b00 <pipewrite+0x3c>
    80003b3a:	854e                	mv	a0,s3
    80003b3c:	a2dfd0ef          	jal	80001568 <killed>
    80003b40:	f161                	bnez	a0,80003b00 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003b42:	2184a783          	lw	a5,536(s1)
    80003b46:	21c4a703          	lw	a4,540(s1)
    80003b4a:	2007879b          	addiw	a5,a5,512
    80003b4e:	fcf70ae3          	beq	a4,a5,80003b22 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003b52:	4685                	li	a3,1
    80003b54:	01590633          	add	a2,s2,s5
    80003b58:	faf40593          	addi	a1,s0,-81
    80003b5c:	0509b503          	ld	a0,80(s3)
    80003b60:	f3ffc0ef          	jal	80000a9e <copyin>
    80003b64:	03650e63          	beq	a0,s6,80003ba0 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003b68:	21c4a783          	lw	a5,540(s1)
    80003b6c:	0017871b          	addiw	a4,a5,1
    80003b70:	20e4ae23          	sw	a4,540(s1)
    80003b74:	1ff7f793          	andi	a5,a5,511
    80003b78:	97a6                	add	a5,a5,s1
    80003b7a:	faf44703          	lbu	a4,-81(s0)
    80003b7e:	00e78c23          	sb	a4,24(a5)
      i++;
    80003b82:	2905                	addiw	s2,s2,1
    80003b84:	b775                	j	80003b30 <pipewrite+0x6c>
    80003b86:	7b02                	ld	s6,32(sp)
    80003b88:	6be2                	ld	s7,24(sp)
    80003b8a:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003b8c:	21848513          	addi	a0,s1,536
    80003b90:	fecfd0ef          	jal	8000137c <wakeup>
  release(&pi->lock);
    80003b94:	8526                	mv	a0,s1
    80003b96:	072020ef          	jal	80005c08 <release>
  return i;
    80003b9a:	bf95                	j	80003b0e <pipewrite+0x4a>
  int i = 0;
    80003b9c:	4901                	li	s2,0
    80003b9e:	b7fd                	j	80003b8c <pipewrite+0xc8>
    80003ba0:	7b02                	ld	s6,32(sp)
    80003ba2:	6be2                	ld	s7,24(sp)
    80003ba4:	6c42                	ld	s8,16(sp)
    80003ba6:	b7dd                	j	80003b8c <pipewrite+0xc8>

0000000080003ba8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ba8:	715d                	addi	sp,sp,-80
    80003baa:	e486                	sd	ra,72(sp)
    80003bac:	e0a2                	sd	s0,64(sp)
    80003bae:	fc26                	sd	s1,56(sp)
    80003bb0:	f84a                	sd	s2,48(sp)
    80003bb2:	f44e                	sd	s3,40(sp)
    80003bb4:	f052                	sd	s4,32(sp)
    80003bb6:	ec56                	sd	s5,24(sp)
    80003bb8:	0880                	addi	s0,sp,80
    80003bba:	84aa                	mv	s1,a0
    80003bbc:	892e                	mv	s2,a1
    80003bbe:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003bc0:	996fd0ef          	jal	80000d56 <myproc>
    80003bc4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003bc6:	8526                	mv	a0,s1
    80003bc8:	7a9010ef          	jal	80005b70 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003bcc:	2184a703          	lw	a4,536(s1)
    80003bd0:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003bd4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003bd8:	02f71563          	bne	a4,a5,80003c02 <piperead+0x5a>
    80003bdc:	2244a783          	lw	a5,548(s1)
    80003be0:	cb85                	beqz	a5,80003c10 <piperead+0x68>
    if(killed(pr)){
    80003be2:	8552                	mv	a0,s4
    80003be4:	985fd0ef          	jal	80001568 <killed>
    80003be8:	ed19                	bnez	a0,80003c06 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003bea:	85a6                	mv	a1,s1
    80003bec:	854e                	mv	a0,s3
    80003bee:	f42fd0ef          	jal	80001330 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003bf2:	2184a703          	lw	a4,536(s1)
    80003bf6:	21c4a783          	lw	a5,540(s1)
    80003bfa:	fef701e3          	beq	a4,a5,80003bdc <piperead+0x34>
    80003bfe:	e85a                	sd	s6,16(sp)
    80003c00:	a809                	j	80003c12 <piperead+0x6a>
    80003c02:	e85a                	sd	s6,16(sp)
    80003c04:	a039                	j	80003c12 <piperead+0x6a>
      release(&pi->lock);
    80003c06:	8526                	mv	a0,s1
    80003c08:	000020ef          	jal	80005c08 <release>
      return -1;
    80003c0c:	59fd                	li	s3,-1
    80003c0e:	a8b1                	j	80003c6a <piperead+0xc2>
    80003c10:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003c12:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003c14:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003c16:	05505263          	blez	s5,80003c5a <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003c1a:	2184a783          	lw	a5,536(s1)
    80003c1e:	21c4a703          	lw	a4,540(s1)
    80003c22:	02f70c63          	beq	a4,a5,80003c5a <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003c26:	0017871b          	addiw	a4,a5,1
    80003c2a:	20e4ac23          	sw	a4,536(s1)
    80003c2e:	1ff7f793          	andi	a5,a5,511
    80003c32:	97a6                	add	a5,a5,s1
    80003c34:	0187c783          	lbu	a5,24(a5)
    80003c38:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003c3c:	4685                	li	a3,1
    80003c3e:	fbf40613          	addi	a2,s0,-65
    80003c42:	85ca                	mv	a1,s2
    80003c44:	050a3503          	ld	a0,80(s4)
    80003c48:	d7ffc0ef          	jal	800009c6 <copyout>
    80003c4c:	01650763          	beq	a0,s6,80003c5a <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003c50:	2985                	addiw	s3,s3,1
    80003c52:	0905                	addi	s2,s2,1
    80003c54:	fd3a93e3          	bne	s5,s3,80003c1a <piperead+0x72>
    80003c58:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003c5a:	21c48513          	addi	a0,s1,540
    80003c5e:	f1efd0ef          	jal	8000137c <wakeup>
  release(&pi->lock);
    80003c62:	8526                	mv	a0,s1
    80003c64:	7a5010ef          	jal	80005c08 <release>
    80003c68:	6b42                	ld	s6,16(sp)
  return i;
}
    80003c6a:	854e                	mv	a0,s3
    80003c6c:	60a6                	ld	ra,72(sp)
    80003c6e:	6406                	ld	s0,64(sp)
    80003c70:	74e2                	ld	s1,56(sp)
    80003c72:	7942                	ld	s2,48(sp)
    80003c74:	79a2                	ld	s3,40(sp)
    80003c76:	7a02                	ld	s4,32(sp)
    80003c78:	6ae2                	ld	s5,24(sp)
    80003c7a:	6161                	addi	sp,sp,80
    80003c7c:	8082                	ret

0000000080003c7e <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003c7e:	1141                	addi	sp,sp,-16
    80003c80:	e422                	sd	s0,8(sp)
    80003c82:	0800                	addi	s0,sp,16
    80003c84:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003c86:	8905                	andi	a0,a0,1
    80003c88:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003c8a:	8b89                	andi	a5,a5,2
    80003c8c:	c399                	beqz	a5,80003c92 <flags2perm+0x14>
      perm |= PTE_W;
    80003c8e:	00456513          	ori	a0,a0,4
    return perm;
}
    80003c92:	6422                	ld	s0,8(sp)
    80003c94:	0141                	addi	sp,sp,16
    80003c96:	8082                	ret

0000000080003c98 <exec>:

int
exec(char *path, char **argv)
{
    80003c98:	df010113          	addi	sp,sp,-528
    80003c9c:	20113423          	sd	ra,520(sp)
    80003ca0:	20813023          	sd	s0,512(sp)
    80003ca4:	ffa6                	sd	s1,504(sp)
    80003ca6:	fbca                	sd	s2,496(sp)
    80003ca8:	0c00                	addi	s0,sp,528
    80003caa:	892a                	mv	s2,a0
    80003cac:	dea43c23          	sd	a0,-520(s0)
    80003cb0:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003cb4:	8a2fd0ef          	jal	80000d56 <myproc>
    80003cb8:	84aa                	mv	s1,a0

  begin_op();
    80003cba:	dc6ff0ef          	jal	80003280 <begin_op>

  if((ip = namei(path)) == 0){
    80003cbe:	854a                	mv	a0,s2
    80003cc0:	c04ff0ef          	jal	800030c4 <namei>
    80003cc4:	c931                	beqz	a0,80003d18 <exec+0x80>
    80003cc6:	f3d2                	sd	s4,480(sp)
    80003cc8:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003cca:	d21fe0ef          	jal	800029ea <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003cce:	04000713          	li	a4,64
    80003cd2:	4681                	li	a3,0
    80003cd4:	e5040613          	addi	a2,s0,-432
    80003cd8:	4581                	li	a1,0
    80003cda:	8552                	mv	a0,s4
    80003cdc:	f63fe0ef          	jal	80002c3e <readi>
    80003ce0:	04000793          	li	a5,64
    80003ce4:	00f51a63          	bne	a0,a5,80003cf8 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003ce8:	e5042703          	lw	a4,-432(s0)
    80003cec:	464c47b7          	lui	a5,0x464c4
    80003cf0:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003cf4:	02f70663          	beq	a4,a5,80003d20 <exec+0x88>

bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003cf8:	8552                	mv	a0,s4
    80003cfa:	efbfe0ef          	jal	80002bf4 <iunlockput>
    end_op();
    80003cfe:	decff0ef          	jal	800032ea <end_op>
  }
  return -1;
    80003d02:	557d                	li	a0,-1
    80003d04:	7a1e                	ld	s4,480(sp)
}
    80003d06:	20813083          	ld	ra,520(sp)
    80003d0a:	20013403          	ld	s0,512(sp)
    80003d0e:	74fe                	ld	s1,504(sp)
    80003d10:	795e                	ld	s2,496(sp)
    80003d12:	21010113          	addi	sp,sp,528
    80003d16:	8082                	ret
    end_op();
    80003d18:	dd2ff0ef          	jal	800032ea <end_op>
    return -1;
    80003d1c:	557d                	li	a0,-1
    80003d1e:	b7e5                	j	80003d06 <exec+0x6e>
    80003d20:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003d22:	8526                	mv	a0,s1
    80003d24:	8dafd0ef          	jal	80000dfe <proc_pagetable>
    80003d28:	8b2a                	mv	s6,a0
    80003d2a:	38050363          	beqz	a0,800040b0 <exec+0x418>
    80003d2e:	f7ce                	sd	s3,488(sp)
    80003d30:	efd6                	sd	s5,472(sp)
    80003d32:	e7de                	sd	s7,456(sp)
    80003d34:	e3e2                	sd	s8,448(sp)
    80003d36:	ff66                	sd	s9,440(sp)
    80003d38:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d3a:	e7042d03          	lw	s10,-400(s0)
    80003d3e:	e8845783          	lhu	a5,-376(s0)
    80003d42:	12078863          	beqz	a5,80003e72 <exec+0x1da>
    80003d46:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003d48:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d4a:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003d4c:	6c85                	lui	s9,0x1
    80003d4e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003d52:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003d56:	6a85                	lui	s5,0x1
    80003d58:	a085                	j	80003db8 <exec+0x120>
      panic("loadseg: address should exist");
    80003d5a:	00004517          	auipc	a0,0x4
    80003d5e:	97e50513          	addi	a0,a0,-1666 # 800076d8 <etext+0x6d8>
    80003d62:	2e1010ef          	jal	80005842 <panic>
    if(sz - i < PGSIZE)
    80003d66:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003d68:	8726                	mv	a4,s1
    80003d6a:	012c06bb          	addw	a3,s8,s2
    80003d6e:	4581                	li	a1,0
    80003d70:	8552                	mv	a0,s4
    80003d72:	ecdfe0ef          	jal	80002c3e <readi>
    80003d76:	2501                	sext.w	a0,a0
    80003d78:	30a49263          	bne	s1,a0,8000407c <exec+0x3e4>
  for(i = 0; i < sz; i += PGSIZE){
    80003d7c:	012a893b          	addw	s2,s5,s2
    80003d80:	03397363          	bgeu	s2,s3,80003da6 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003d84:	02091593          	slli	a1,s2,0x20
    80003d88:	9181                	srli	a1,a1,0x20
    80003d8a:	95de                	add	a1,a1,s7
    80003d8c:	855a                	mv	a0,s6
    80003d8e:	eb4fc0ef          	jal	80000442 <walkaddr>
    80003d92:	862a                	mv	a2,a0
    if(pa == 0)
    80003d94:	d179                	beqz	a0,80003d5a <exec+0xc2>
    if(sz - i < PGSIZE)
    80003d96:	412984bb          	subw	s1,s3,s2
    80003d9a:	0004879b          	sext.w	a5,s1
    80003d9e:	fcfcf4e3          	bgeu	s9,a5,80003d66 <exec+0xce>
    80003da2:	84d6                	mv	s1,s5
    80003da4:	b7c9                	j	80003d66 <exec+0xce>
    sz = sz1;
    80003da6:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003daa:	2d85                	addiw	s11,s11,1
    80003dac:	038d0d1b          	addiw	s10,s10,56
    80003db0:	e8845783          	lhu	a5,-376(s0)
    80003db4:	08fdd063          	bge	s11,a5,80003e34 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003db8:	2d01                	sext.w	s10,s10
    80003dba:	03800713          	li	a4,56
    80003dbe:	86ea                	mv	a3,s10
    80003dc0:	e1840613          	addi	a2,s0,-488
    80003dc4:	4581                	li	a1,0
    80003dc6:	8552                	mv	a0,s4
    80003dc8:	e77fe0ef          	jal	80002c3e <readi>
    80003dcc:	03800793          	li	a5,56
    80003dd0:	26f51c63          	bne	a0,a5,80004048 <exec+0x3b0>
    if(ph.type != ELF_PROG_LOAD)
    80003dd4:	e1842783          	lw	a5,-488(s0)
    80003dd8:	4705                	li	a4,1
    80003dda:	fce798e3          	bne	a5,a4,80003daa <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003dde:	e4043903          	ld	s2,-448(s0)
    80003de2:	e3843783          	ld	a5,-456(s0)
    80003de6:	26f96563          	bltu	s2,a5,80004050 <exec+0x3b8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003dea:	e2843783          	ld	a5,-472(s0)
    80003dee:	993e                	add	s2,s2,a5
    80003df0:	26f96463          	bltu	s2,a5,80004058 <exec+0x3c0>
    if(ph.vaddr % PGSIZE != 0)
    80003df4:	df043703          	ld	a4,-528(s0)
    80003df8:	8ff9                	and	a5,a5,a4
    80003dfa:	26079363          	bnez	a5,80004060 <exec+0x3c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003dfe:	e1c42503          	lw	a0,-484(s0)
    80003e02:	e7dff0ef          	jal	80003c7e <flags2perm>
    80003e06:	86aa                	mv	a3,a0
    80003e08:	864a                	mv	a2,s2
    80003e0a:	85a6                	mv	a1,s1
    80003e0c:	855a                	mv	a0,s6
    80003e0e:	9adfc0ef          	jal	800007ba <uvmalloc>
    80003e12:	e0a43423          	sd	a0,-504(s0)
    80003e16:	24050963          	beqz	a0,80004068 <exec+0x3d0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003e1a:	e2843b83          	ld	s7,-472(s0)
    80003e1e:	e2042c03          	lw	s8,-480(s0)
    80003e22:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003e26:	00098463          	beqz	s3,80003e2e <exec+0x196>
    80003e2a:	4901                	li	s2,0
    80003e2c:	bfa1                	j	80003d84 <exec+0xec>
    sz = sz1;
    80003e2e:	e0843483          	ld	s1,-504(s0)
    80003e32:	bfa5                	j	80003daa <exec+0x112>
    80003e34:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003e36:	8552                	mv	a0,s4
    80003e38:	dbdfe0ef          	jal	80002bf4 <iunlockput>
  end_op();
    80003e3c:	caeff0ef          	jal	800032ea <end_op>
  p = myproc();
    80003e40:	f17fc0ef          	jal	80000d56 <myproc>
    80003e44:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80003e46:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003e4a:	6905                	lui	s2,0x1
    80003e4c:	197d                	addi	s2,s2,-1 # fff <_entry-0x7ffff001>
    80003e4e:	9926                	add	s2,s2,s1
    80003e50:	77fd                	lui	a5,0xfffff
    80003e52:	00f97933          	and	s2,s2,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003e56:	4691                	li	a3,4
    80003e58:	6609                	lui	a2,0x2
    80003e5a:	964a                	add	a2,a2,s2
    80003e5c:	85ca                	mv	a1,s2
    80003e5e:	855a                	mv	a0,s6
    80003e60:	95bfc0ef          	jal	800007ba <uvmalloc>
    80003e64:	e0a43423          	sd	a0,-504(s0)
    80003e68:	e519                	bnez	a0,80003e76 <exec+0x1de>
  if(pagetable)
    80003e6a:	e1243423          	sd	s2,-504(s0)
    80003e6e:	4a01                	li	s4,0
    80003e70:	a439                	j	8000407e <exec+0x3e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003e72:	4481                	li	s1,0
    80003e74:	b7c9                	j	80003e36 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003e76:	75f9                	lui	a1,0xffffe
    80003e78:	892a                	mv	s2,a0
    80003e7a:	95aa                	add	a1,a1,a0
    80003e7c:	855a                	mv	a0,s6
    80003e7e:	b1ffc0ef          	jal	8000099c <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003e82:	7c7d                	lui	s8,0xfffff
    80003e84:	9c4a                	add	s8,s8,s2
  for(argc = 0; argv[argc]; argc++) {
    80003e86:	e0043983          	ld	s3,-512(s0)
    80003e8a:	0009b503          	ld	a0,0(s3)
    80003e8e:	22050663          	beqz	a0,800040ba <exec+0x422>
    80003e92:	e9040a13          	addi	s4,s0,-368
    80003e96:	4a81                	li	s5,0
    if(argc >= MAXARG)
    80003e98:	02000c93          	li	s9,32
    sp -= strlen(argv[argc]) + 1;
    80003e9c:	c08fc0ef          	jal	800002a4 <strlen>
    80003ea0:	0015079b          	addiw	a5,a0,1
    80003ea4:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003ea8:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003eac:	1d896463          	bltu	s2,s8,80004074 <exec+0x3dc>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003eb0:	0009b483          	ld	s1,0(s3)
    80003eb4:	8526                	mv	a0,s1
    80003eb6:	beefc0ef          	jal	800002a4 <strlen>
    80003eba:	0015069b          	addiw	a3,a0,1
    80003ebe:	8626                	mv	a2,s1
    80003ec0:	85ca                	mv	a1,s2
    80003ec2:	855a                	mv	a0,s6
    80003ec4:	b03fc0ef          	jal	800009c6 <copyout>
    80003ec8:	1a054863          	bltz	a0,80004078 <exec+0x3e0>
    ustack[argc] = sp;
    80003ecc:	012a3023          	sd	s2,0(s4)
  for(argc = 0; argv[argc]; argc++) {
    80003ed0:	001a8493          	addi	s1,s5,1 # 1001 <_entry-0x7fffefff>
    80003ed4:	09a1                	addi	s3,s3,8
    80003ed6:	0009b503          	ld	a0,0(s3)
    80003eda:	c511                	beqz	a0,80003ee6 <exec+0x24e>
    if(argc >= MAXARG)
    80003edc:	0a21                	addi	s4,s4,8
    80003ede:	19948963          	beq	s1,s9,80004070 <exec+0x3d8>
    80003ee2:	8aa6                	mv	s5,s1
    80003ee4:	bf65                	j	80003e9c <exec+0x204>
  ustack[argc] = 0;
    80003ee6:	00349793          	slli	a5,s1,0x3
    80003eea:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb350>
    80003eee:	97a2                	add	a5,a5,s0
    80003ef0:	f007b023          	sd	zero,-256(a5)
    80003ef4:	e0043a03          	ld	s4,-512(s0)
    80003ef8:	4981                	li	s3,0
  if (strncmp(argv[i], "--trace-mask", 12) == 0 && i + 1 < argc) {  // Added 12 as the length
    80003efa:	00003c97          	auipc	s9,0x3
    80003efe:	7fec8c93          	addi	s9,s9,2046 # 800076f8 <etext+0x6f8>
    80003f02:	a069                	j	80003f8c <exec+0x2f4>
    char *mask_str = argv[i + 1];
    80003f04:	00198793          	addi	a5,s3,1
    80003f08:	078e                	slli	a5,a5,0x3
    80003f0a:	e0043683          	ld	a3,-512(s0)
    80003f0e:	97b6                	add	a5,a5,a3
    80003f10:	6390                	ld	a2,0(a5)
    while (*mask_str && *mask_str >= '0' && *mask_str <= '9') {
    80003f12:	00064783          	lbu	a5,0(a2) # 2000 <_entry-0x7fffe000>
    80003f16:	fd07869b          	addiw	a3,a5,-48
    80003f1a:	0ff6f693          	zext.b	a3,a3
    80003f1e:	45a5                	li	a1,9
    80003f20:	02d5e463          	bltu	a1,a3,80003f48 <exec+0x2b0>
      mask = mask * 10 + (*mask_str - '0');
    80003f24:	0025169b          	slliw	a3,a0,0x2
    80003f28:	9ea9                	addw	a3,a3,a0
    80003f2a:	0016969b          	slliw	a3,a3,0x1
    80003f2e:	fd07879b          	addiw	a5,a5,-48
    80003f32:	00d7853b          	addw	a0,a5,a3
      mask_str++;
    80003f36:	0605                	addi	a2,a2,1
    while (*mask_str && *mask_str >= '0' && *mask_str <= '9') {
    80003f38:	00064783          	lbu	a5,0(a2)
    80003f3c:	fd07869b          	addiw	a3,a5,-48
    80003f40:	0ff6f693          	zext.b	a3,a3
    80003f44:	fed5f0e3          	bgeu	a1,a3,80003f24 <exec+0x28c>
    80003f48:	00349693          	slli	a3,s1,0x3
      p->trace_mask = mask;
    80003f4c:	16aba423          	sw	a0,360(s7)
      for (int j = i; j < argc - 2; j++) {
    80003f50:	fffa8493          	addi	s1,s5,-1
    80003f54:	00977e63          	bgeu	a4,s1,80003f70 <exec+0x2d8>
    80003f58:	00371793          	slli	a5,a4,0x3
    80003f5c:	e0043703          	ld	a4,-512(s0)
    80003f60:	97ba                	add	a5,a5,a4
    80003f62:	9736                	add	a4,a4,a3
    80003f64:	1741                	addi	a4,a4,-16
        argv[j] = argv[j + 2];
    80003f66:	6b90                	ld	a2,16(a5)
    80003f68:	e390                	sd	a2,0(a5)
      for (int j = i; j < argc - 2; j++) {
    80003f6a:	07a1                	addi	a5,a5,8
    80003f6c:	fee79de3          	bne	a5,a4,80003f66 <exec+0x2ce>
      argv[argc - 2] = 0;
    80003f70:	e0043783          	ld	a5,-512(s0)
    80003f74:	97b6                	add	a5,a5,a3
    80003f76:	fe07b823          	sd	zero,-16(a5)
      argv[argc - 1] = 0;
    80003f7a:	fe07bc23          	sd	zero,-8(a5)
      break;
    80003f7e:	a025                	j	80003fa6 <exec+0x30e>
for (int i = 0; i < argc; i++) {
    80003f80:	00198793          	addi	a5,s3,1
    80003f84:	0a21                	addi	s4,s4,8
    80003f86:	073a8063          	beq	s5,s3,80003fe6 <exec+0x34e>
    80003f8a:	89be                	mv	s3,a5
  if (strncmp(argv[i], "--trace-mask", 12) == 0 && i + 1 < argc) {  // Added 12 as the length
    80003f8c:	4631                	li	a2,12
    80003f8e:	85e6                	mv	a1,s9
    80003f90:	000a3503          	ld	a0,0(s4)
    80003f94:	a6cfc0ef          	jal	80000200 <strncmp>
    80003f98:	f565                	bnez	a0,80003f80 <exec+0x2e8>
    80003f9a:	0009871b          	sext.w	a4,s3
    80003f9e:	0019879b          	addiw	a5,s3,1
    80003fa2:	f697e1e3          	bltu	a5,s1,80003f04 <exec+0x26c>
  sp -= (argc+1) * sizeof(uint64);
    80003fa6:	00148693          	addi	a3,s1,1
    80003faa:	068e                	slli	a3,a3,0x3
    80003fac:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003fb0:	ff097993          	andi	s3,s2,-16
  sz = sz1;
    80003fb4:	e0843903          	ld	s2,-504(s0)
  if(sp < stackbase)
    80003fb8:	eb89e9e3          	bltu	s3,s8,80003e6a <exec+0x1d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003fbc:	e9040613          	addi	a2,s0,-368
    80003fc0:	85ce                	mv	a1,s3
    80003fc2:	855a                	mv	a0,s6
    80003fc4:	a03fc0ef          	jal	800009c6 <copyout>
    80003fc8:	0e054663          	bltz	a0,800040b4 <exec+0x41c>
  p->trapframe->a1 = sp;
    80003fcc:	058bb783          	ld	a5,88(s7)
    80003fd0:	0737bc23          	sd	s3,120(a5)
  for(last=s=path; *s; s++)
    80003fd4:	df843783          	ld	a5,-520(s0)
    80003fd8:	0007c703          	lbu	a4,0(a5)
    80003fdc:	c305                	beqz	a4,80003ffc <exec+0x364>
    80003fde:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003fe0:	02f00693          	li	a3,47
    80003fe4:	a809                	j	80003ff6 <exec+0x35e>
    80003fe6:	84be                	mv	s1,a5
    80003fe8:	bf7d                	j	80003fa6 <exec+0x30e>
      last = s+1;
    80003fea:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003fee:	0785                	addi	a5,a5,1
    80003ff0:	fff7c703          	lbu	a4,-1(a5)
    80003ff4:	c701                	beqz	a4,80003ffc <exec+0x364>
    if(*s == '/')
    80003ff6:	fed71ce3          	bne	a4,a3,80003fee <exec+0x356>
    80003ffa:	bfc5                	j	80003fea <exec+0x352>
  safestrcpy(p->name, last, sizeof(p->name));
    80003ffc:	4641                	li	a2,16
    80003ffe:	df843583          	ld	a1,-520(s0)
    80004002:	158b8513          	addi	a0,s7,344
    80004006:	a6cfc0ef          	jal	80000272 <safestrcpy>
  oldpagetable = p->pagetable;
    8000400a:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000400e:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004012:	e0843783          	ld	a5,-504(s0)
    80004016:	04fbb423          	sd	a5,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000401a:	058bb783          	ld	a5,88(s7)
    8000401e:	e6843703          	ld	a4,-408(s0)
    80004022:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004024:	058bb783          	ld	a5,88(s7)
    80004028:	0337b823          	sd	s3,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000402c:	85ea                	mv	a1,s10
    8000402e:	e55fc0ef          	jal	80000e82 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004032:	0004851b          	sext.w	a0,s1
    80004036:	79be                	ld	s3,488(sp)
    80004038:	7a1e                	ld	s4,480(sp)
    8000403a:	6afe                	ld	s5,472(sp)
    8000403c:	6b5e                	ld	s6,464(sp)
    8000403e:	6bbe                	ld	s7,456(sp)
    80004040:	6c1e                	ld	s8,448(sp)
    80004042:	7cfa                	ld	s9,440(sp)
    80004044:	7d5a                	ld	s10,432(sp)
    80004046:	b1c1                	j	80003d06 <exec+0x6e>
    80004048:	e0943423          	sd	s1,-504(s0)
    8000404c:	7dba                	ld	s11,424(sp)
    8000404e:	a805                	j	8000407e <exec+0x3e6>
    80004050:	e0943423          	sd	s1,-504(s0)
    80004054:	7dba                	ld	s11,424(sp)
    80004056:	a025                	j	8000407e <exec+0x3e6>
    80004058:	e0943423          	sd	s1,-504(s0)
    8000405c:	7dba                	ld	s11,424(sp)
    8000405e:	a005                	j	8000407e <exec+0x3e6>
    80004060:	e0943423          	sd	s1,-504(s0)
    80004064:	7dba                	ld	s11,424(sp)
    80004066:	a821                	j	8000407e <exec+0x3e6>
    80004068:	e0943423          	sd	s1,-504(s0)
    8000406c:	7dba                	ld	s11,424(sp)
    8000406e:	a801                	j	8000407e <exec+0x3e6>
  ip = 0;
    80004070:	4a01                	li	s4,0
    80004072:	a031                	j	8000407e <exec+0x3e6>
    80004074:	4a01                	li	s4,0
    80004076:	a021                	j	8000407e <exec+0x3e6>
    80004078:	4a01                	li	s4,0
  if(pagetable)
    8000407a:	a011                	j	8000407e <exec+0x3e6>
    8000407c:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    8000407e:	e0843583          	ld	a1,-504(s0)
    80004082:	855a                	mv	a0,s6
    80004084:	dfffc0ef          	jal	80000e82 <proc_freepagetable>
  return -1;
    80004088:	557d                	li	a0,-1
  if(ip){
    8000408a:	000a1b63          	bnez	s4,800040a0 <exec+0x408>
    8000408e:	79be                	ld	s3,488(sp)
    80004090:	7a1e                	ld	s4,480(sp)
    80004092:	6afe                	ld	s5,472(sp)
    80004094:	6b5e                	ld	s6,464(sp)
    80004096:	6bbe                	ld	s7,456(sp)
    80004098:	6c1e                	ld	s8,448(sp)
    8000409a:	7cfa                	ld	s9,440(sp)
    8000409c:	7d5a                	ld	s10,432(sp)
    8000409e:	b1a5                	j	80003d06 <exec+0x6e>
    800040a0:	79be                	ld	s3,488(sp)
    800040a2:	6afe                	ld	s5,472(sp)
    800040a4:	6b5e                	ld	s6,464(sp)
    800040a6:	6bbe                	ld	s7,456(sp)
    800040a8:	6c1e                	ld	s8,448(sp)
    800040aa:	7cfa                	ld	s9,440(sp)
    800040ac:	7d5a                	ld	s10,432(sp)
    800040ae:	b1a9                	j	80003cf8 <exec+0x60>
    800040b0:	6b5e                	ld	s6,464(sp)
    800040b2:	b199                	j	80003cf8 <exec+0x60>
  sz = sz1;
    800040b4:	e0843903          	ld	s2,-504(s0)
    800040b8:	bb4d                	j	80003e6a <exec+0x1d2>
  ustack[argc] = 0;
    800040ba:	e8043823          	sd	zero,-368(s0)
  sp = sz;
    800040be:	e0843903          	ld	s2,-504(s0)
  ustack[argc] = 0;
    800040c2:	4481                	li	s1,0
    800040c4:	b5cd                	j	80003fa6 <exec+0x30e>

00000000800040c6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800040c6:	7179                	addi	sp,sp,-48
    800040c8:	f406                	sd	ra,40(sp)
    800040ca:	f022                	sd	s0,32(sp)
    800040cc:	ec26                	sd	s1,24(sp)
    800040ce:	e84a                	sd	s2,16(sp)
    800040d0:	1800                	addi	s0,sp,48
    800040d2:	892e                	mv	s2,a1
    800040d4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800040d6:	fdc40593          	addi	a1,s0,-36
    800040da:	bfffd0ef          	jal	80001cd8 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800040de:	fdc42703          	lw	a4,-36(s0)
    800040e2:	47bd                	li	a5,15
    800040e4:	02e7e963          	bltu	a5,a4,80004116 <argfd+0x50>
    800040e8:	c6ffc0ef          	jal	80000d56 <myproc>
    800040ec:	fdc42703          	lw	a4,-36(s0)
    800040f0:	01a70793          	addi	a5,a4,26
    800040f4:	078e                	slli	a5,a5,0x3
    800040f6:	953e                	add	a0,a0,a5
    800040f8:	611c                	ld	a5,0(a0)
    800040fa:	c385                	beqz	a5,8000411a <argfd+0x54>
    return -1;
  if(pfd)
    800040fc:	00090463          	beqz	s2,80004104 <argfd+0x3e>
    *pfd = fd;
    80004100:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004104:	4501                	li	a0,0
  if(pf)
    80004106:	c091                	beqz	s1,8000410a <argfd+0x44>
    *pf = f;
    80004108:	e09c                	sd	a5,0(s1)
}
    8000410a:	70a2                	ld	ra,40(sp)
    8000410c:	7402                	ld	s0,32(sp)
    8000410e:	64e2                	ld	s1,24(sp)
    80004110:	6942                	ld	s2,16(sp)
    80004112:	6145                	addi	sp,sp,48
    80004114:	8082                	ret
    return -1;
    80004116:	557d                	li	a0,-1
    80004118:	bfcd                	j	8000410a <argfd+0x44>
    8000411a:	557d                	li	a0,-1
    8000411c:	b7fd                	j	8000410a <argfd+0x44>

000000008000411e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000411e:	1101                	addi	sp,sp,-32
    80004120:	ec06                	sd	ra,24(sp)
    80004122:	e822                	sd	s0,16(sp)
    80004124:	e426                	sd	s1,8(sp)
    80004126:	1000                	addi	s0,sp,32
    80004128:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000412a:	c2dfc0ef          	jal	80000d56 <myproc>
    8000412e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004130:	0d050793          	addi	a5,a0,208
    80004134:	4501                	li	a0,0
    80004136:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004138:	6398                	ld	a4,0(a5)
    8000413a:	cb19                	beqz	a4,80004150 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    8000413c:	2505                	addiw	a0,a0,1
    8000413e:	07a1                	addi	a5,a5,8
    80004140:	fed51ce3          	bne	a0,a3,80004138 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004144:	557d                	li	a0,-1
}
    80004146:	60e2                	ld	ra,24(sp)
    80004148:	6442                	ld	s0,16(sp)
    8000414a:	64a2                	ld	s1,8(sp)
    8000414c:	6105                	addi	sp,sp,32
    8000414e:	8082                	ret
      p->ofile[fd] = f;
    80004150:	01a50793          	addi	a5,a0,26
    80004154:	078e                	slli	a5,a5,0x3
    80004156:	963e                	add	a2,a2,a5
    80004158:	e204                	sd	s1,0(a2)
      return fd;
    8000415a:	b7f5                	j	80004146 <fdalloc+0x28>

000000008000415c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000415c:	715d                	addi	sp,sp,-80
    8000415e:	e486                	sd	ra,72(sp)
    80004160:	e0a2                	sd	s0,64(sp)
    80004162:	fc26                	sd	s1,56(sp)
    80004164:	f84a                	sd	s2,48(sp)
    80004166:	f44e                	sd	s3,40(sp)
    80004168:	ec56                	sd	s5,24(sp)
    8000416a:	e85a                	sd	s6,16(sp)
    8000416c:	0880                	addi	s0,sp,80
    8000416e:	8b2e                	mv	s6,a1
    80004170:	89b2                	mv	s3,a2
    80004172:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004174:	fb040593          	addi	a1,s0,-80
    80004178:	f67fe0ef          	jal	800030de <nameiparent>
    8000417c:	84aa                	mv	s1,a0
    8000417e:	10050a63          	beqz	a0,80004292 <create+0x136>
    return 0;

  ilock(dp);
    80004182:	869fe0ef          	jal	800029ea <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004186:	4601                	li	a2,0
    80004188:	fb040593          	addi	a1,s0,-80
    8000418c:	8526                	mv	a0,s1
    8000418e:	cd1fe0ef          	jal	80002e5e <dirlookup>
    80004192:	8aaa                	mv	s5,a0
    80004194:	c129                	beqz	a0,800041d6 <create+0x7a>
    iunlockput(dp);
    80004196:	8526                	mv	a0,s1
    80004198:	a5dfe0ef          	jal	80002bf4 <iunlockput>
    ilock(ip);
    8000419c:	8556                	mv	a0,s5
    8000419e:	84dfe0ef          	jal	800029ea <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800041a2:	4789                	li	a5,2
    800041a4:	02fb1463          	bne	s6,a5,800041cc <create+0x70>
    800041a8:	044ad783          	lhu	a5,68(s5)
    800041ac:	37f9                	addiw	a5,a5,-2
    800041ae:	17c2                	slli	a5,a5,0x30
    800041b0:	93c1                	srli	a5,a5,0x30
    800041b2:	4705                	li	a4,1
    800041b4:	00f76c63          	bltu	a4,a5,800041cc <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800041b8:	8556                	mv	a0,s5
    800041ba:	60a6                	ld	ra,72(sp)
    800041bc:	6406                	ld	s0,64(sp)
    800041be:	74e2                	ld	s1,56(sp)
    800041c0:	7942                	ld	s2,48(sp)
    800041c2:	79a2                	ld	s3,40(sp)
    800041c4:	6ae2                	ld	s5,24(sp)
    800041c6:	6b42                	ld	s6,16(sp)
    800041c8:	6161                	addi	sp,sp,80
    800041ca:	8082                	ret
    iunlockput(ip);
    800041cc:	8556                	mv	a0,s5
    800041ce:	a27fe0ef          	jal	80002bf4 <iunlockput>
    return 0;
    800041d2:	4a81                	li	s5,0
    800041d4:	b7d5                	j	800041b8 <create+0x5c>
    800041d6:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800041d8:	85da                	mv	a1,s6
    800041da:	4088                	lw	a0,0(s1)
    800041dc:	e9efe0ef          	jal	8000287a <ialloc>
    800041e0:	8a2a                	mv	s4,a0
    800041e2:	cd15                	beqz	a0,8000421e <create+0xc2>
  ilock(ip);
    800041e4:	807fe0ef          	jal	800029ea <ilock>
  ip->major = major;
    800041e8:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800041ec:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800041f0:	4905                	li	s2,1
    800041f2:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800041f6:	8552                	mv	a0,s4
    800041f8:	f3efe0ef          	jal	80002936 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800041fc:	032b0763          	beq	s6,s2,8000422a <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004200:	004a2603          	lw	a2,4(s4)
    80004204:	fb040593          	addi	a1,s0,-80
    80004208:	8526                	mv	a0,s1
    8000420a:	e21fe0ef          	jal	8000302a <dirlink>
    8000420e:	06054563          	bltz	a0,80004278 <create+0x11c>
  iunlockput(dp);
    80004212:	8526                	mv	a0,s1
    80004214:	9e1fe0ef          	jal	80002bf4 <iunlockput>
  return ip;
    80004218:	8ad2                	mv	s5,s4
    8000421a:	7a02                	ld	s4,32(sp)
    8000421c:	bf71                	j	800041b8 <create+0x5c>
    iunlockput(dp);
    8000421e:	8526                	mv	a0,s1
    80004220:	9d5fe0ef          	jal	80002bf4 <iunlockput>
    return 0;
    80004224:	8ad2                	mv	s5,s4
    80004226:	7a02                	ld	s4,32(sp)
    80004228:	bf41                	j	800041b8 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000422a:	004a2603          	lw	a2,4(s4)
    8000422e:	00003597          	auipc	a1,0x3
    80004232:	4da58593          	addi	a1,a1,1242 # 80007708 <etext+0x708>
    80004236:	8552                	mv	a0,s4
    80004238:	df3fe0ef          	jal	8000302a <dirlink>
    8000423c:	02054e63          	bltz	a0,80004278 <create+0x11c>
    80004240:	40d0                	lw	a2,4(s1)
    80004242:	00003597          	auipc	a1,0x3
    80004246:	4ce58593          	addi	a1,a1,1230 # 80007710 <etext+0x710>
    8000424a:	8552                	mv	a0,s4
    8000424c:	ddffe0ef          	jal	8000302a <dirlink>
    80004250:	02054463          	bltz	a0,80004278 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004254:	004a2603          	lw	a2,4(s4)
    80004258:	fb040593          	addi	a1,s0,-80
    8000425c:	8526                	mv	a0,s1
    8000425e:	dcdfe0ef          	jal	8000302a <dirlink>
    80004262:	00054b63          	bltz	a0,80004278 <create+0x11c>
    dp->nlink++;  // for ".."
    80004266:	04a4d783          	lhu	a5,74(s1)
    8000426a:	2785                	addiw	a5,a5,1
    8000426c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004270:	8526                	mv	a0,s1
    80004272:	ec4fe0ef          	jal	80002936 <iupdate>
    80004276:	bf71                	j	80004212 <create+0xb6>
  ip->nlink = 0;
    80004278:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000427c:	8552                	mv	a0,s4
    8000427e:	eb8fe0ef          	jal	80002936 <iupdate>
  iunlockput(ip);
    80004282:	8552                	mv	a0,s4
    80004284:	971fe0ef          	jal	80002bf4 <iunlockput>
  iunlockput(dp);
    80004288:	8526                	mv	a0,s1
    8000428a:	96bfe0ef          	jal	80002bf4 <iunlockput>
  return 0;
    8000428e:	7a02                	ld	s4,32(sp)
    80004290:	b725                	j	800041b8 <create+0x5c>
    return 0;
    80004292:	8aaa                	mv	s5,a0
    80004294:	b715                	j	800041b8 <create+0x5c>

0000000080004296 <sys_dup>:
{
    80004296:	7179                	addi	sp,sp,-48
    80004298:	f406                	sd	ra,40(sp)
    8000429a:	f022                	sd	s0,32(sp)
    8000429c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000429e:	fd840613          	addi	a2,s0,-40
    800042a2:	4581                	li	a1,0
    800042a4:	4501                	li	a0,0
    800042a6:	e21ff0ef          	jal	800040c6 <argfd>
    return -1;
    800042aa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800042ac:	02054363          	bltz	a0,800042d2 <sys_dup+0x3c>
    800042b0:	ec26                	sd	s1,24(sp)
    800042b2:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800042b4:	fd843903          	ld	s2,-40(s0)
    800042b8:	854a                	mv	a0,s2
    800042ba:	e65ff0ef          	jal	8000411e <fdalloc>
    800042be:	84aa                	mv	s1,a0
    return -1;
    800042c0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800042c2:	00054d63          	bltz	a0,800042dc <sys_dup+0x46>
  filedup(f);
    800042c6:	854a                	mv	a0,s2
    800042c8:	b8cff0ef          	jal	80003654 <filedup>
  return fd;
    800042cc:	87a6                	mv	a5,s1
    800042ce:	64e2                	ld	s1,24(sp)
    800042d0:	6942                	ld	s2,16(sp)
}
    800042d2:	853e                	mv	a0,a5
    800042d4:	70a2                	ld	ra,40(sp)
    800042d6:	7402                	ld	s0,32(sp)
    800042d8:	6145                	addi	sp,sp,48
    800042da:	8082                	ret
    800042dc:	64e2                	ld	s1,24(sp)
    800042de:	6942                	ld	s2,16(sp)
    800042e0:	bfcd                	j	800042d2 <sys_dup+0x3c>

00000000800042e2 <sys_read>:
{
    800042e2:	7179                	addi	sp,sp,-48
    800042e4:	f406                	sd	ra,40(sp)
    800042e6:	f022                	sd	s0,32(sp)
    800042e8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800042ea:	fd840593          	addi	a1,s0,-40
    800042ee:	4505                	li	a0,1
    800042f0:	a8bfd0ef          	jal	80001d7a <argaddr>
  argint(2, &n);
    800042f4:	fe440593          	addi	a1,s0,-28
    800042f8:	4509                	li	a0,2
    800042fa:	9dffd0ef          	jal	80001cd8 <argint>
  if(argfd(0, 0, &f) < 0)
    800042fe:	fe840613          	addi	a2,s0,-24
    80004302:	4581                	li	a1,0
    80004304:	4501                	li	a0,0
    80004306:	dc1ff0ef          	jal	800040c6 <argfd>
    8000430a:	87aa                	mv	a5,a0
    return -1;
    8000430c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000430e:	0007ca63          	bltz	a5,80004322 <sys_read+0x40>
  return fileread(f, p, n);
    80004312:	fe442603          	lw	a2,-28(s0)
    80004316:	fd843583          	ld	a1,-40(s0)
    8000431a:	fe843503          	ld	a0,-24(s0)
    8000431e:	c9cff0ef          	jal	800037ba <fileread>
}
    80004322:	70a2                	ld	ra,40(sp)
    80004324:	7402                	ld	s0,32(sp)
    80004326:	6145                	addi	sp,sp,48
    80004328:	8082                	ret

000000008000432a <sys_write>:
{
    8000432a:	7179                	addi	sp,sp,-48
    8000432c:	f406                	sd	ra,40(sp)
    8000432e:	f022                	sd	s0,32(sp)
    80004330:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004332:	fd840593          	addi	a1,s0,-40
    80004336:	4505                	li	a0,1
    80004338:	a43fd0ef          	jal	80001d7a <argaddr>
  argint(2, &n);
    8000433c:	fe440593          	addi	a1,s0,-28
    80004340:	4509                	li	a0,2
    80004342:	997fd0ef          	jal	80001cd8 <argint>
  if(argfd(0, 0, &f) < 0)
    80004346:	fe840613          	addi	a2,s0,-24
    8000434a:	4581                	li	a1,0
    8000434c:	4501                	li	a0,0
    8000434e:	d79ff0ef          	jal	800040c6 <argfd>
    80004352:	87aa                	mv	a5,a0
    return -1;
    80004354:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004356:	0007ca63          	bltz	a5,8000436a <sys_write+0x40>
  return filewrite(f, p, n);
    8000435a:	fe442603          	lw	a2,-28(s0)
    8000435e:	fd843583          	ld	a1,-40(s0)
    80004362:	fe843503          	ld	a0,-24(s0)
    80004366:	d12ff0ef          	jal	80003878 <filewrite>
}
    8000436a:	70a2                	ld	ra,40(sp)
    8000436c:	7402                	ld	s0,32(sp)
    8000436e:	6145                	addi	sp,sp,48
    80004370:	8082                	ret

0000000080004372 <sys_close>:
{
    80004372:	1101                	addi	sp,sp,-32
    80004374:	ec06                	sd	ra,24(sp)
    80004376:	e822                	sd	s0,16(sp)
    80004378:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000437a:	fe040613          	addi	a2,s0,-32
    8000437e:	fec40593          	addi	a1,s0,-20
    80004382:	4501                	li	a0,0
    80004384:	d43ff0ef          	jal	800040c6 <argfd>
    return -1;
    80004388:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000438a:	02054063          	bltz	a0,800043aa <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000438e:	9c9fc0ef          	jal	80000d56 <myproc>
    80004392:	fec42783          	lw	a5,-20(s0)
    80004396:	07e9                	addi	a5,a5,26
    80004398:	078e                	slli	a5,a5,0x3
    8000439a:	953e                	add	a0,a0,a5
    8000439c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800043a0:	fe043503          	ld	a0,-32(s0)
    800043a4:	af6ff0ef          	jal	8000369a <fileclose>
  return 0;
    800043a8:	4781                	li	a5,0
}
    800043aa:	853e                	mv	a0,a5
    800043ac:	60e2                	ld	ra,24(sp)
    800043ae:	6442                	ld	s0,16(sp)
    800043b0:	6105                	addi	sp,sp,32
    800043b2:	8082                	ret

00000000800043b4 <sys_fstat>:
{
    800043b4:	1101                	addi	sp,sp,-32
    800043b6:	ec06                	sd	ra,24(sp)
    800043b8:	e822                	sd	s0,16(sp)
    800043ba:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800043bc:	fe040593          	addi	a1,s0,-32
    800043c0:	4505                	li	a0,1
    800043c2:	9b9fd0ef          	jal	80001d7a <argaddr>
  if(argfd(0, 0, &f) < 0)
    800043c6:	fe840613          	addi	a2,s0,-24
    800043ca:	4581                	li	a1,0
    800043cc:	4501                	li	a0,0
    800043ce:	cf9ff0ef          	jal	800040c6 <argfd>
    800043d2:	87aa                	mv	a5,a0
    return -1;
    800043d4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800043d6:	0007c863          	bltz	a5,800043e6 <sys_fstat+0x32>
  return filestat(f, st);
    800043da:	fe043583          	ld	a1,-32(s0)
    800043de:	fe843503          	ld	a0,-24(s0)
    800043e2:	b7aff0ef          	jal	8000375c <filestat>
}
    800043e6:	60e2                	ld	ra,24(sp)
    800043e8:	6442                	ld	s0,16(sp)
    800043ea:	6105                	addi	sp,sp,32
    800043ec:	8082                	ret

00000000800043ee <sys_link>:
{
    800043ee:	7169                	addi	sp,sp,-304
    800043f0:	f606                	sd	ra,296(sp)
    800043f2:	f222                	sd	s0,288(sp)
    800043f4:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800043f6:	08000613          	li	a2,128
    800043fa:	ed040593          	addi	a1,s0,-304
    800043fe:	4501                	li	a0,0
    80004400:	98ffd0ef          	jal	80001d8e <argstr>
    return -1;
    80004404:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004406:	0c054e63          	bltz	a0,800044e2 <sys_link+0xf4>
    8000440a:	08000613          	li	a2,128
    8000440e:	f5040593          	addi	a1,s0,-176
    80004412:	4505                	li	a0,1
    80004414:	97bfd0ef          	jal	80001d8e <argstr>
    return -1;
    80004418:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000441a:	0c054463          	bltz	a0,800044e2 <sys_link+0xf4>
    8000441e:	ee26                	sd	s1,280(sp)
  begin_op();
    80004420:	e61fe0ef          	jal	80003280 <begin_op>
  if((ip = namei(old)) == 0){
    80004424:	ed040513          	addi	a0,s0,-304
    80004428:	c9dfe0ef          	jal	800030c4 <namei>
    8000442c:	84aa                	mv	s1,a0
    8000442e:	c53d                	beqz	a0,8000449c <sys_link+0xae>
  ilock(ip);
    80004430:	dbafe0ef          	jal	800029ea <ilock>
  if(ip->type == T_DIR){
    80004434:	04449703          	lh	a4,68(s1)
    80004438:	4785                	li	a5,1
    8000443a:	06f70663          	beq	a4,a5,800044a6 <sys_link+0xb8>
    8000443e:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004440:	04a4d783          	lhu	a5,74(s1)
    80004444:	2785                	addiw	a5,a5,1
    80004446:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000444a:	8526                	mv	a0,s1
    8000444c:	ceafe0ef          	jal	80002936 <iupdate>
  iunlock(ip);
    80004450:	8526                	mv	a0,s1
    80004452:	e46fe0ef          	jal	80002a98 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004456:	fd040593          	addi	a1,s0,-48
    8000445a:	f5040513          	addi	a0,s0,-176
    8000445e:	c81fe0ef          	jal	800030de <nameiparent>
    80004462:	892a                	mv	s2,a0
    80004464:	cd21                	beqz	a0,800044bc <sys_link+0xce>
  ilock(dp);
    80004466:	d84fe0ef          	jal	800029ea <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000446a:	00092703          	lw	a4,0(s2)
    8000446e:	409c                	lw	a5,0(s1)
    80004470:	04f71363          	bne	a4,a5,800044b6 <sys_link+0xc8>
    80004474:	40d0                	lw	a2,4(s1)
    80004476:	fd040593          	addi	a1,s0,-48
    8000447a:	854a                	mv	a0,s2
    8000447c:	baffe0ef          	jal	8000302a <dirlink>
    80004480:	02054b63          	bltz	a0,800044b6 <sys_link+0xc8>
  iunlockput(dp);
    80004484:	854a                	mv	a0,s2
    80004486:	f6efe0ef          	jal	80002bf4 <iunlockput>
  iput(ip);
    8000448a:	8526                	mv	a0,s1
    8000448c:	ee0fe0ef          	jal	80002b6c <iput>
  end_op();
    80004490:	e5bfe0ef          	jal	800032ea <end_op>
  return 0;
    80004494:	4781                	li	a5,0
    80004496:	64f2                	ld	s1,280(sp)
    80004498:	6952                	ld	s2,272(sp)
    8000449a:	a0a1                	j	800044e2 <sys_link+0xf4>
    end_op();
    8000449c:	e4ffe0ef          	jal	800032ea <end_op>
    return -1;
    800044a0:	57fd                	li	a5,-1
    800044a2:	64f2                	ld	s1,280(sp)
    800044a4:	a83d                	j	800044e2 <sys_link+0xf4>
    iunlockput(ip);
    800044a6:	8526                	mv	a0,s1
    800044a8:	f4cfe0ef          	jal	80002bf4 <iunlockput>
    end_op();
    800044ac:	e3ffe0ef          	jal	800032ea <end_op>
    return -1;
    800044b0:	57fd                	li	a5,-1
    800044b2:	64f2                	ld	s1,280(sp)
    800044b4:	a03d                	j	800044e2 <sys_link+0xf4>
    iunlockput(dp);
    800044b6:	854a                	mv	a0,s2
    800044b8:	f3cfe0ef          	jal	80002bf4 <iunlockput>
  ilock(ip);
    800044bc:	8526                	mv	a0,s1
    800044be:	d2cfe0ef          	jal	800029ea <ilock>
  ip->nlink--;
    800044c2:	04a4d783          	lhu	a5,74(s1)
    800044c6:	37fd                	addiw	a5,a5,-1
    800044c8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800044cc:	8526                	mv	a0,s1
    800044ce:	c68fe0ef          	jal	80002936 <iupdate>
  iunlockput(ip);
    800044d2:	8526                	mv	a0,s1
    800044d4:	f20fe0ef          	jal	80002bf4 <iunlockput>
  end_op();
    800044d8:	e13fe0ef          	jal	800032ea <end_op>
  return -1;
    800044dc:	57fd                	li	a5,-1
    800044de:	64f2                	ld	s1,280(sp)
    800044e0:	6952                	ld	s2,272(sp)
}
    800044e2:	853e                	mv	a0,a5
    800044e4:	70b2                	ld	ra,296(sp)
    800044e6:	7412                	ld	s0,288(sp)
    800044e8:	6155                	addi	sp,sp,304
    800044ea:	8082                	ret

00000000800044ec <sys_unlink>:
{
    800044ec:	7151                	addi	sp,sp,-240
    800044ee:	f586                	sd	ra,232(sp)
    800044f0:	f1a2                	sd	s0,224(sp)
    800044f2:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800044f4:	08000613          	li	a2,128
    800044f8:	f3040593          	addi	a1,s0,-208
    800044fc:	4501                	li	a0,0
    800044fe:	891fd0ef          	jal	80001d8e <argstr>
    80004502:	16054063          	bltz	a0,80004662 <sys_unlink+0x176>
    80004506:	eda6                	sd	s1,216(sp)
  begin_op();
    80004508:	d79fe0ef          	jal	80003280 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000450c:	fb040593          	addi	a1,s0,-80
    80004510:	f3040513          	addi	a0,s0,-208
    80004514:	bcbfe0ef          	jal	800030de <nameiparent>
    80004518:	84aa                	mv	s1,a0
    8000451a:	c945                	beqz	a0,800045ca <sys_unlink+0xde>
  ilock(dp);
    8000451c:	ccefe0ef          	jal	800029ea <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004520:	00003597          	auipc	a1,0x3
    80004524:	1e858593          	addi	a1,a1,488 # 80007708 <etext+0x708>
    80004528:	fb040513          	addi	a0,s0,-80
    8000452c:	91dfe0ef          	jal	80002e48 <namecmp>
    80004530:	10050e63          	beqz	a0,8000464c <sys_unlink+0x160>
    80004534:	00003597          	auipc	a1,0x3
    80004538:	1dc58593          	addi	a1,a1,476 # 80007710 <etext+0x710>
    8000453c:	fb040513          	addi	a0,s0,-80
    80004540:	909fe0ef          	jal	80002e48 <namecmp>
    80004544:	10050463          	beqz	a0,8000464c <sys_unlink+0x160>
    80004548:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000454a:	f2c40613          	addi	a2,s0,-212
    8000454e:	fb040593          	addi	a1,s0,-80
    80004552:	8526                	mv	a0,s1
    80004554:	90bfe0ef          	jal	80002e5e <dirlookup>
    80004558:	892a                	mv	s2,a0
    8000455a:	0e050863          	beqz	a0,8000464a <sys_unlink+0x15e>
  ilock(ip);
    8000455e:	c8cfe0ef          	jal	800029ea <ilock>
  if(ip->nlink < 1)
    80004562:	04a91783          	lh	a5,74(s2)
    80004566:	06f05763          	blez	a5,800045d4 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000456a:	04491703          	lh	a4,68(s2)
    8000456e:	4785                	li	a5,1
    80004570:	06f70963          	beq	a4,a5,800045e2 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004574:	4641                	li	a2,16
    80004576:	4581                	li	a1,0
    80004578:	fc040513          	addi	a0,s0,-64
    8000457c:	bb9fb0ef          	jal	80000134 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004580:	4741                	li	a4,16
    80004582:	f2c42683          	lw	a3,-212(s0)
    80004586:	fc040613          	addi	a2,s0,-64
    8000458a:	4581                	li	a1,0
    8000458c:	8526                	mv	a0,s1
    8000458e:	facfe0ef          	jal	80002d3a <writei>
    80004592:	47c1                	li	a5,16
    80004594:	08f51b63          	bne	a0,a5,8000462a <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004598:	04491703          	lh	a4,68(s2)
    8000459c:	4785                	li	a5,1
    8000459e:	08f70d63          	beq	a4,a5,80004638 <sys_unlink+0x14c>
  iunlockput(dp);
    800045a2:	8526                	mv	a0,s1
    800045a4:	e50fe0ef          	jal	80002bf4 <iunlockput>
  ip->nlink--;
    800045a8:	04a95783          	lhu	a5,74(s2)
    800045ac:	37fd                	addiw	a5,a5,-1
    800045ae:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800045b2:	854a                	mv	a0,s2
    800045b4:	b82fe0ef          	jal	80002936 <iupdate>
  iunlockput(ip);
    800045b8:	854a                	mv	a0,s2
    800045ba:	e3afe0ef          	jal	80002bf4 <iunlockput>
  end_op();
    800045be:	d2dfe0ef          	jal	800032ea <end_op>
  return 0;
    800045c2:	4501                	li	a0,0
    800045c4:	64ee                	ld	s1,216(sp)
    800045c6:	694e                	ld	s2,208(sp)
    800045c8:	a849                	j	8000465a <sys_unlink+0x16e>
    end_op();
    800045ca:	d21fe0ef          	jal	800032ea <end_op>
    return -1;
    800045ce:	557d                	li	a0,-1
    800045d0:	64ee                	ld	s1,216(sp)
    800045d2:	a061                	j	8000465a <sys_unlink+0x16e>
    800045d4:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    800045d6:	00003517          	auipc	a0,0x3
    800045da:	14250513          	addi	a0,a0,322 # 80007718 <etext+0x718>
    800045de:	264010ef          	jal	80005842 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800045e2:	04c92703          	lw	a4,76(s2)
    800045e6:	02000793          	li	a5,32
    800045ea:	f8e7f5e3          	bgeu	a5,a4,80004574 <sys_unlink+0x88>
    800045ee:	e5ce                	sd	s3,200(sp)
    800045f0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800045f4:	4741                	li	a4,16
    800045f6:	86ce                	mv	a3,s3
    800045f8:	f1840613          	addi	a2,s0,-232
    800045fc:	4581                	li	a1,0
    800045fe:	854a                	mv	a0,s2
    80004600:	e3efe0ef          	jal	80002c3e <readi>
    80004604:	47c1                	li	a5,16
    80004606:	00f51c63          	bne	a0,a5,8000461e <sys_unlink+0x132>
    if(de.inum != 0)
    8000460a:	f1845783          	lhu	a5,-232(s0)
    8000460e:	efa1                	bnez	a5,80004666 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004610:	29c1                	addiw	s3,s3,16
    80004612:	04c92783          	lw	a5,76(s2)
    80004616:	fcf9efe3          	bltu	s3,a5,800045f4 <sys_unlink+0x108>
    8000461a:	69ae                	ld	s3,200(sp)
    8000461c:	bfa1                	j	80004574 <sys_unlink+0x88>
      panic("isdirempty: readi");
    8000461e:	00003517          	auipc	a0,0x3
    80004622:	11250513          	addi	a0,a0,274 # 80007730 <etext+0x730>
    80004626:	21c010ef          	jal	80005842 <panic>
    8000462a:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    8000462c:	00003517          	auipc	a0,0x3
    80004630:	11c50513          	addi	a0,a0,284 # 80007748 <etext+0x748>
    80004634:	20e010ef          	jal	80005842 <panic>
    dp->nlink--;
    80004638:	04a4d783          	lhu	a5,74(s1)
    8000463c:	37fd                	addiw	a5,a5,-1
    8000463e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004642:	8526                	mv	a0,s1
    80004644:	af2fe0ef          	jal	80002936 <iupdate>
    80004648:	bfa9                	j	800045a2 <sys_unlink+0xb6>
    8000464a:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    8000464c:	8526                	mv	a0,s1
    8000464e:	da6fe0ef          	jal	80002bf4 <iunlockput>
  end_op();
    80004652:	c99fe0ef          	jal	800032ea <end_op>
  return -1;
    80004656:	557d                	li	a0,-1
    80004658:	64ee                	ld	s1,216(sp)
}
    8000465a:	70ae                	ld	ra,232(sp)
    8000465c:	740e                	ld	s0,224(sp)
    8000465e:	616d                	addi	sp,sp,240
    80004660:	8082                	ret
    return -1;
    80004662:	557d                	li	a0,-1
    80004664:	bfdd                	j	8000465a <sys_unlink+0x16e>
    iunlockput(ip);
    80004666:	854a                	mv	a0,s2
    80004668:	d8cfe0ef          	jal	80002bf4 <iunlockput>
    goto bad;
    8000466c:	694e                	ld	s2,208(sp)
    8000466e:	69ae                	ld	s3,200(sp)
    80004670:	bff1                	j	8000464c <sys_unlink+0x160>

0000000080004672 <sys_open>:

uint64
sys_open(void)
{
    80004672:	7131                	addi	sp,sp,-192
    80004674:	fd06                	sd	ra,184(sp)
    80004676:	f922                	sd	s0,176(sp)
    80004678:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000467a:	f4c40593          	addi	a1,s0,-180
    8000467e:	4505                	li	a0,1
    80004680:	e58fd0ef          	jal	80001cd8 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004684:	08000613          	li	a2,128
    80004688:	f5040593          	addi	a1,s0,-176
    8000468c:	4501                	li	a0,0
    8000468e:	f00fd0ef          	jal	80001d8e <argstr>
    80004692:	87aa                	mv	a5,a0
    return -1;
    80004694:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004696:	0a07c263          	bltz	a5,8000473a <sys_open+0xc8>
    8000469a:	f526                	sd	s1,168(sp)

  begin_op();
    8000469c:	be5fe0ef          	jal	80003280 <begin_op>

  if(omode & O_CREATE){
    800046a0:	f4c42783          	lw	a5,-180(s0)
    800046a4:	2007f793          	andi	a5,a5,512
    800046a8:	c3d5                	beqz	a5,8000474c <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800046aa:	4681                	li	a3,0
    800046ac:	4601                	li	a2,0
    800046ae:	4589                	li	a1,2
    800046b0:	f5040513          	addi	a0,s0,-176
    800046b4:	aa9ff0ef          	jal	8000415c <create>
    800046b8:	84aa                	mv	s1,a0
    if(ip == 0){
    800046ba:	c541                	beqz	a0,80004742 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800046bc:	04449703          	lh	a4,68(s1)
    800046c0:	478d                	li	a5,3
    800046c2:	00f71763          	bne	a4,a5,800046d0 <sys_open+0x5e>
    800046c6:	0464d703          	lhu	a4,70(s1)
    800046ca:	47a5                	li	a5,9
    800046cc:	0ae7ed63          	bltu	a5,a4,80004786 <sys_open+0x114>
    800046d0:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800046d2:	f25fe0ef          	jal	800035f6 <filealloc>
    800046d6:	892a                	mv	s2,a0
    800046d8:	c179                	beqz	a0,8000479e <sys_open+0x12c>
    800046da:	ed4e                	sd	s3,152(sp)
    800046dc:	a43ff0ef          	jal	8000411e <fdalloc>
    800046e0:	89aa                	mv	s3,a0
    800046e2:	0a054a63          	bltz	a0,80004796 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800046e6:	04449703          	lh	a4,68(s1)
    800046ea:	478d                	li	a5,3
    800046ec:	0cf70263          	beq	a4,a5,800047b0 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800046f0:	4789                	li	a5,2
    800046f2:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800046f6:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800046fa:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800046fe:	f4c42783          	lw	a5,-180(s0)
    80004702:	0017c713          	xori	a4,a5,1
    80004706:	8b05                	andi	a4,a4,1
    80004708:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000470c:	0037f713          	andi	a4,a5,3
    80004710:	00e03733          	snez	a4,a4
    80004714:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004718:	4007f793          	andi	a5,a5,1024
    8000471c:	c791                	beqz	a5,80004728 <sys_open+0xb6>
    8000471e:	04449703          	lh	a4,68(s1)
    80004722:	4789                	li	a5,2
    80004724:	08f70d63          	beq	a4,a5,800047be <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004728:	8526                	mv	a0,s1
    8000472a:	b6efe0ef          	jal	80002a98 <iunlock>
  end_op();
    8000472e:	bbdfe0ef          	jal	800032ea <end_op>

  return fd;
    80004732:	854e                	mv	a0,s3
    80004734:	74aa                	ld	s1,168(sp)
    80004736:	790a                	ld	s2,160(sp)
    80004738:	69ea                	ld	s3,152(sp)
}
    8000473a:	70ea                	ld	ra,184(sp)
    8000473c:	744a                	ld	s0,176(sp)
    8000473e:	6129                	addi	sp,sp,192
    80004740:	8082                	ret
      end_op();
    80004742:	ba9fe0ef          	jal	800032ea <end_op>
      return -1;
    80004746:	557d                	li	a0,-1
    80004748:	74aa                	ld	s1,168(sp)
    8000474a:	bfc5                	j	8000473a <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    8000474c:	f5040513          	addi	a0,s0,-176
    80004750:	975fe0ef          	jal	800030c4 <namei>
    80004754:	84aa                	mv	s1,a0
    80004756:	c11d                	beqz	a0,8000477c <sys_open+0x10a>
    ilock(ip);
    80004758:	a92fe0ef          	jal	800029ea <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000475c:	04449703          	lh	a4,68(s1)
    80004760:	4785                	li	a5,1
    80004762:	f4f71de3          	bne	a4,a5,800046bc <sys_open+0x4a>
    80004766:	f4c42783          	lw	a5,-180(s0)
    8000476a:	d3bd                	beqz	a5,800046d0 <sys_open+0x5e>
      iunlockput(ip);
    8000476c:	8526                	mv	a0,s1
    8000476e:	c86fe0ef          	jal	80002bf4 <iunlockput>
      end_op();
    80004772:	b79fe0ef          	jal	800032ea <end_op>
      return -1;
    80004776:	557d                	li	a0,-1
    80004778:	74aa                	ld	s1,168(sp)
    8000477a:	b7c1                	j	8000473a <sys_open+0xc8>
      end_op();
    8000477c:	b6ffe0ef          	jal	800032ea <end_op>
      return -1;
    80004780:	557d                	li	a0,-1
    80004782:	74aa                	ld	s1,168(sp)
    80004784:	bf5d                	j	8000473a <sys_open+0xc8>
    iunlockput(ip);
    80004786:	8526                	mv	a0,s1
    80004788:	c6cfe0ef          	jal	80002bf4 <iunlockput>
    end_op();
    8000478c:	b5ffe0ef          	jal	800032ea <end_op>
    return -1;
    80004790:	557d                	li	a0,-1
    80004792:	74aa                	ld	s1,168(sp)
    80004794:	b75d                	j	8000473a <sys_open+0xc8>
      fileclose(f);
    80004796:	854a                	mv	a0,s2
    80004798:	f03fe0ef          	jal	8000369a <fileclose>
    8000479c:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000479e:	8526                	mv	a0,s1
    800047a0:	c54fe0ef          	jal	80002bf4 <iunlockput>
    end_op();
    800047a4:	b47fe0ef          	jal	800032ea <end_op>
    return -1;
    800047a8:	557d                	li	a0,-1
    800047aa:	74aa                	ld	s1,168(sp)
    800047ac:	790a                	ld	s2,160(sp)
    800047ae:	b771                	j	8000473a <sys_open+0xc8>
    f->type = FD_DEVICE;
    800047b0:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800047b4:	04649783          	lh	a5,70(s1)
    800047b8:	02f91223          	sh	a5,36(s2)
    800047bc:	bf3d                	j	800046fa <sys_open+0x88>
    itrunc(ip);
    800047be:	8526                	mv	a0,s1
    800047c0:	b18fe0ef          	jal	80002ad8 <itrunc>
    800047c4:	b795                	j	80004728 <sys_open+0xb6>

00000000800047c6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800047c6:	7175                	addi	sp,sp,-144
    800047c8:	e506                	sd	ra,136(sp)
    800047ca:	e122                	sd	s0,128(sp)
    800047cc:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800047ce:	ab3fe0ef          	jal	80003280 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800047d2:	08000613          	li	a2,128
    800047d6:	f7040593          	addi	a1,s0,-144
    800047da:	4501                	li	a0,0
    800047dc:	db2fd0ef          	jal	80001d8e <argstr>
    800047e0:	02054363          	bltz	a0,80004806 <sys_mkdir+0x40>
    800047e4:	4681                	li	a3,0
    800047e6:	4601                	li	a2,0
    800047e8:	4585                	li	a1,1
    800047ea:	f7040513          	addi	a0,s0,-144
    800047ee:	96fff0ef          	jal	8000415c <create>
    800047f2:	c911                	beqz	a0,80004806 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800047f4:	c00fe0ef          	jal	80002bf4 <iunlockput>
  end_op();
    800047f8:	af3fe0ef          	jal	800032ea <end_op>
  return 0;
    800047fc:	4501                	li	a0,0
}
    800047fe:	60aa                	ld	ra,136(sp)
    80004800:	640a                	ld	s0,128(sp)
    80004802:	6149                	addi	sp,sp,144
    80004804:	8082                	ret
    end_op();
    80004806:	ae5fe0ef          	jal	800032ea <end_op>
    return -1;
    8000480a:	557d                	li	a0,-1
    8000480c:	bfcd                	j	800047fe <sys_mkdir+0x38>

000000008000480e <sys_mknod>:

uint64
sys_mknod(void)
{
    8000480e:	7135                	addi	sp,sp,-160
    80004810:	ed06                	sd	ra,152(sp)
    80004812:	e922                	sd	s0,144(sp)
    80004814:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004816:	a6bfe0ef          	jal	80003280 <begin_op>
  argint(1, &major);
    8000481a:	f6c40593          	addi	a1,s0,-148
    8000481e:	4505                	li	a0,1
    80004820:	cb8fd0ef          	jal	80001cd8 <argint>
  argint(2, &minor);
    80004824:	f6840593          	addi	a1,s0,-152
    80004828:	4509                	li	a0,2
    8000482a:	caefd0ef          	jal	80001cd8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000482e:	08000613          	li	a2,128
    80004832:	f7040593          	addi	a1,s0,-144
    80004836:	4501                	li	a0,0
    80004838:	d56fd0ef          	jal	80001d8e <argstr>
    8000483c:	02054563          	bltz	a0,80004866 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004840:	f6841683          	lh	a3,-152(s0)
    80004844:	f6c41603          	lh	a2,-148(s0)
    80004848:	458d                	li	a1,3
    8000484a:	f7040513          	addi	a0,s0,-144
    8000484e:	90fff0ef          	jal	8000415c <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004852:	c911                	beqz	a0,80004866 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004854:	ba0fe0ef          	jal	80002bf4 <iunlockput>
  end_op();
    80004858:	a93fe0ef          	jal	800032ea <end_op>
  return 0;
    8000485c:	4501                	li	a0,0
}
    8000485e:	60ea                	ld	ra,152(sp)
    80004860:	644a                	ld	s0,144(sp)
    80004862:	610d                	addi	sp,sp,160
    80004864:	8082                	ret
    end_op();
    80004866:	a85fe0ef          	jal	800032ea <end_op>
    return -1;
    8000486a:	557d                	li	a0,-1
    8000486c:	bfcd                	j	8000485e <sys_mknod+0x50>

000000008000486e <sys_chdir>:

uint64
sys_chdir(void)
{
    8000486e:	7135                	addi	sp,sp,-160
    80004870:	ed06                	sd	ra,152(sp)
    80004872:	e922                	sd	s0,144(sp)
    80004874:	e14a                	sd	s2,128(sp)
    80004876:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004878:	cdefc0ef          	jal	80000d56 <myproc>
    8000487c:	892a                	mv	s2,a0
  
  begin_op();
    8000487e:	a03fe0ef          	jal	80003280 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004882:	08000613          	li	a2,128
    80004886:	f6040593          	addi	a1,s0,-160
    8000488a:	4501                	li	a0,0
    8000488c:	d02fd0ef          	jal	80001d8e <argstr>
    80004890:	04054363          	bltz	a0,800048d6 <sys_chdir+0x68>
    80004894:	e526                	sd	s1,136(sp)
    80004896:	f6040513          	addi	a0,s0,-160
    8000489a:	82bfe0ef          	jal	800030c4 <namei>
    8000489e:	84aa                	mv	s1,a0
    800048a0:	c915                	beqz	a0,800048d4 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800048a2:	948fe0ef          	jal	800029ea <ilock>
  if(ip->type != T_DIR){
    800048a6:	04449703          	lh	a4,68(s1)
    800048aa:	4785                	li	a5,1
    800048ac:	02f71963          	bne	a4,a5,800048de <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800048b0:	8526                	mv	a0,s1
    800048b2:	9e6fe0ef          	jal	80002a98 <iunlock>
  iput(p->cwd);
    800048b6:	15093503          	ld	a0,336(s2)
    800048ba:	ab2fe0ef          	jal	80002b6c <iput>
  end_op();
    800048be:	a2dfe0ef          	jal	800032ea <end_op>
  p->cwd = ip;
    800048c2:	14993823          	sd	s1,336(s2)
  return 0;
    800048c6:	4501                	li	a0,0
    800048c8:	64aa                	ld	s1,136(sp)
}
    800048ca:	60ea                	ld	ra,152(sp)
    800048cc:	644a                	ld	s0,144(sp)
    800048ce:	690a                	ld	s2,128(sp)
    800048d0:	610d                	addi	sp,sp,160
    800048d2:	8082                	ret
    800048d4:	64aa                	ld	s1,136(sp)
    end_op();
    800048d6:	a15fe0ef          	jal	800032ea <end_op>
    return -1;
    800048da:	557d                	li	a0,-1
    800048dc:	b7fd                	j	800048ca <sys_chdir+0x5c>
    iunlockput(ip);
    800048de:	8526                	mv	a0,s1
    800048e0:	b14fe0ef          	jal	80002bf4 <iunlockput>
    end_op();
    800048e4:	a07fe0ef          	jal	800032ea <end_op>
    return -1;
    800048e8:	557d                	li	a0,-1
    800048ea:	64aa                	ld	s1,136(sp)
    800048ec:	bff9                	j	800048ca <sys_chdir+0x5c>

00000000800048ee <sys_exec>:

///////////////////////////////////////

uint64
sys_exec(void)
{
    800048ee:	7121                	addi	sp,sp,-448
    800048f0:	ff06                	sd	ra,440(sp)
    800048f2:	fb22                	sd	s0,432(sp)
    800048f4:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800048f6:	e4840593          	addi	a1,s0,-440
    800048fa:	4505                	li	a0,1
    800048fc:	c7efd0ef          	jal	80001d7a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004900:	08000613          	li	a2,128
    80004904:	f5040593          	addi	a1,s0,-176
    80004908:	4501                	li	a0,0
    8000490a:	c84fd0ef          	jal	80001d8e <argstr>
    8000490e:	87aa                	mv	a5,a0
    return -1;
    80004910:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004912:	0a07cb63          	bltz	a5,800049c8 <sys_exec+0xda>
    80004916:	f726                	sd	s1,424(sp)
    80004918:	f34a                	sd	s2,416(sp)
    8000491a:	ef4e                	sd	s3,408(sp)
    8000491c:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000491e:	10000613          	li	a2,256
    80004922:	4581                	li	a1,0
    80004924:	e5040513          	addi	a0,s0,-432
    80004928:	80dfb0ef          	jal	80000134 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000492c:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004930:	89a6                	mv	s3,s1
    80004932:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004934:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004938:	00391513          	slli	a0,s2,0x3
    8000493c:	e4040593          	addi	a1,s0,-448
    80004940:	e4843783          	ld	a5,-440(s0)
    80004944:	953e                	add	a0,a0,a5
    80004946:	b08fd0ef          	jal	80001c4e <fetchaddr>
    8000494a:	02054663          	bltz	a0,80004976 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    8000494e:	e4043783          	ld	a5,-448(s0)
    80004952:	c3a9                	beqz	a5,80004994 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004954:	fa2fb0ef          	jal	800000f6 <kalloc>
    80004958:	85aa                	mv	a1,a0
    8000495a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000495e:	cd01                	beqz	a0,80004976 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004960:	6605                	lui	a2,0x1
    80004962:	e4043503          	ld	a0,-448(s0)
    80004966:	b32fd0ef          	jal	80001c98 <fetchstr>
    8000496a:	00054663          	bltz	a0,80004976 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    8000496e:	0905                	addi	s2,s2,1
    80004970:	09a1                	addi	s3,s3,8
    80004972:	fd4913e3          	bne	s2,s4,80004938 <sys_exec+0x4a>

  // Free memory only if exec fails (handled in bad)
  return ret;

bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004976:	f5040913          	addi	s2,s0,-176
    8000497a:	6088                	ld	a0,0(s1)
    8000497c:	c129                	beqz	a0,800049be <sys_exec+0xd0>
    kfree(argv[i]);
    8000497e:	e9efb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004982:	04a1                	addi	s1,s1,8
    80004984:	ff249be3          	bne	s1,s2,8000497a <sys_exec+0x8c>
  return -1;
    80004988:	557d                	li	a0,-1
    8000498a:	74ba                	ld	s1,424(sp)
    8000498c:	791a                	ld	s2,416(sp)
    8000498e:	69fa                	ld	s3,408(sp)
    80004990:	6a5a                	ld	s4,400(sp)
    80004992:	a81d                	j	800049c8 <sys_exec+0xda>
      argv[i] = 0;
    80004994:	0009079b          	sext.w	a5,s2
    80004998:	078e                	slli	a5,a5,0x3
    8000499a:	fd078793          	addi	a5,a5,-48
    8000499e:	97a2                	add	a5,a5,s0
    800049a0:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800049a4:	e5040593          	addi	a1,s0,-432
    800049a8:	f5040513          	addi	a0,s0,-176
    800049ac:	aecff0ef          	jal	80003c98 <exec>
  if(ret < 0) {
    800049b0:	fc0543e3          	bltz	a0,80004976 <sys_exec+0x88>
    800049b4:	74ba                	ld	s1,424(sp)
    800049b6:	791a                	ld	s2,416(sp)
    800049b8:	69fa                	ld	s3,408(sp)
    800049ba:	6a5a                	ld	s4,400(sp)
    800049bc:	a031                	j	800049c8 <sys_exec+0xda>
  return -1;
    800049be:	557d                	li	a0,-1
    800049c0:	74ba                	ld	s1,424(sp)
    800049c2:	791a                	ld	s2,416(sp)
    800049c4:	69fa                	ld	s3,408(sp)
    800049c6:	6a5a                	ld	s4,400(sp)
}
    800049c8:	70fa                	ld	ra,440(sp)
    800049ca:	745a                	ld	s0,432(sp)
    800049cc:	6139                	addi	sp,sp,448
    800049ce:	8082                	ret

00000000800049d0 <sys_pipe>:

//////////////////////////

uint64
sys_pipe(void)
{
    800049d0:	7139                	addi	sp,sp,-64
    800049d2:	fc06                	sd	ra,56(sp)
    800049d4:	f822                	sd	s0,48(sp)
    800049d6:	f426                	sd	s1,40(sp)
    800049d8:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800049da:	b7cfc0ef          	jal	80000d56 <myproc>
    800049de:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800049e0:	fd840593          	addi	a1,s0,-40
    800049e4:	4501                	li	a0,0
    800049e6:	b94fd0ef          	jal	80001d7a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800049ea:	fc840593          	addi	a1,s0,-56
    800049ee:	fd040513          	addi	a0,s0,-48
    800049f2:	fb3fe0ef          	jal	800039a4 <pipealloc>
    return -1;
    800049f6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800049f8:	0a054463          	bltz	a0,80004aa0 <sys_pipe+0xd0>
  fd0 = -1;
    800049fc:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004a00:	fd043503          	ld	a0,-48(s0)
    80004a04:	f1aff0ef          	jal	8000411e <fdalloc>
    80004a08:	fca42223          	sw	a0,-60(s0)
    80004a0c:	08054163          	bltz	a0,80004a8e <sys_pipe+0xbe>
    80004a10:	fc843503          	ld	a0,-56(s0)
    80004a14:	f0aff0ef          	jal	8000411e <fdalloc>
    80004a18:	fca42023          	sw	a0,-64(s0)
    80004a1c:	06054063          	bltz	a0,80004a7c <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004a20:	4691                	li	a3,4
    80004a22:	fc440613          	addi	a2,s0,-60
    80004a26:	fd843583          	ld	a1,-40(s0)
    80004a2a:	68a8                	ld	a0,80(s1)
    80004a2c:	f9bfb0ef          	jal	800009c6 <copyout>
    80004a30:	00054e63          	bltz	a0,80004a4c <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004a34:	4691                	li	a3,4
    80004a36:	fc040613          	addi	a2,s0,-64
    80004a3a:	fd843583          	ld	a1,-40(s0)
    80004a3e:	0591                	addi	a1,a1,4
    80004a40:	68a8                	ld	a0,80(s1)
    80004a42:	f85fb0ef          	jal	800009c6 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004a46:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004a48:	04055c63          	bgez	a0,80004aa0 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004a4c:	fc442783          	lw	a5,-60(s0)
    80004a50:	07e9                	addi	a5,a5,26
    80004a52:	078e                	slli	a5,a5,0x3
    80004a54:	97a6                	add	a5,a5,s1
    80004a56:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004a5a:	fc042783          	lw	a5,-64(s0)
    80004a5e:	07e9                	addi	a5,a5,26
    80004a60:	078e                	slli	a5,a5,0x3
    80004a62:	94be                	add	s1,s1,a5
    80004a64:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004a68:	fd043503          	ld	a0,-48(s0)
    80004a6c:	c2ffe0ef          	jal	8000369a <fileclose>
    fileclose(wf);
    80004a70:	fc843503          	ld	a0,-56(s0)
    80004a74:	c27fe0ef          	jal	8000369a <fileclose>
    return -1;
    80004a78:	57fd                	li	a5,-1
    80004a7a:	a01d                	j	80004aa0 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004a7c:	fc442783          	lw	a5,-60(s0)
    80004a80:	0007c763          	bltz	a5,80004a8e <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004a84:	07e9                	addi	a5,a5,26
    80004a86:	078e                	slli	a5,a5,0x3
    80004a88:	97a6                	add	a5,a5,s1
    80004a8a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004a8e:	fd043503          	ld	a0,-48(s0)
    80004a92:	c09fe0ef          	jal	8000369a <fileclose>
    fileclose(wf);
    80004a96:	fc843503          	ld	a0,-56(s0)
    80004a9a:	c01fe0ef          	jal	8000369a <fileclose>
    return -1;
    80004a9e:	57fd                	li	a5,-1
}
    80004aa0:	853e                	mv	a0,a5
    80004aa2:	70e2                	ld	ra,56(sp)
    80004aa4:	7442                	ld	s0,48(sp)
    80004aa6:	74a2                	ld	s1,40(sp)
    80004aa8:	6121                	addi	sp,sp,64
    80004aaa:	8082                	ret
    80004aac:	0000                	unimp
	...

0000000080004ab0 <kernelvec>:
    80004ab0:	7111                	addi	sp,sp,-256
    80004ab2:	e006                	sd	ra,0(sp)
    80004ab4:	e40a                	sd	sp,8(sp)
    80004ab6:	e80e                	sd	gp,16(sp)
    80004ab8:	ec12                	sd	tp,24(sp)
    80004aba:	f016                	sd	t0,32(sp)
    80004abc:	f41a                	sd	t1,40(sp)
    80004abe:	f81e                	sd	t2,48(sp)
    80004ac0:	e4aa                	sd	a0,72(sp)
    80004ac2:	e8ae                	sd	a1,80(sp)
    80004ac4:	ecb2                	sd	a2,88(sp)
    80004ac6:	f0b6                	sd	a3,96(sp)
    80004ac8:	f4ba                	sd	a4,104(sp)
    80004aca:	f8be                	sd	a5,112(sp)
    80004acc:	fcc2                	sd	a6,120(sp)
    80004ace:	e146                	sd	a7,128(sp)
    80004ad0:	edf2                	sd	t3,216(sp)
    80004ad2:	f1f6                	sd	t4,224(sp)
    80004ad4:	f5fa                	sd	t5,232(sp)
    80004ad6:	f9fe                	sd	t6,240(sp)
    80004ad8:	fc5fc0ef          	jal	80001a9c <kerneltrap>
    80004adc:	6082                	ld	ra,0(sp)
    80004ade:	6122                	ld	sp,8(sp)
    80004ae0:	61c2                	ld	gp,16(sp)
    80004ae2:	7282                	ld	t0,32(sp)
    80004ae4:	7322                	ld	t1,40(sp)
    80004ae6:	73c2                	ld	t2,48(sp)
    80004ae8:	6526                	ld	a0,72(sp)
    80004aea:	65c6                	ld	a1,80(sp)
    80004aec:	6666                	ld	a2,88(sp)
    80004aee:	7686                	ld	a3,96(sp)
    80004af0:	7726                	ld	a4,104(sp)
    80004af2:	77c6                	ld	a5,112(sp)
    80004af4:	7866                	ld	a6,120(sp)
    80004af6:	688a                	ld	a7,128(sp)
    80004af8:	6e6e                	ld	t3,216(sp)
    80004afa:	7e8e                	ld	t4,224(sp)
    80004afc:	7f2e                	ld	t5,232(sp)
    80004afe:	7fce                	ld	t6,240(sp)
    80004b00:	6111                	addi	sp,sp,256
    80004b02:	10200073          	sret
	...

0000000080004b0e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80004b0e:	1141                	addi	sp,sp,-16
    80004b10:	e422                	sd	s0,8(sp)
    80004b12:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004b14:	0c0007b7          	lui	a5,0xc000
    80004b18:	4705                	li	a4,1
    80004b1a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80004b1c:	0c0007b7          	lui	a5,0xc000
    80004b20:	c3d8                	sw	a4,4(a5)
}
    80004b22:	6422                	ld	s0,8(sp)
    80004b24:	0141                	addi	sp,sp,16
    80004b26:	8082                	ret

0000000080004b28 <plicinithart>:

void
plicinithart(void)
{
    80004b28:	1141                	addi	sp,sp,-16
    80004b2a:	e406                	sd	ra,8(sp)
    80004b2c:	e022                	sd	s0,0(sp)
    80004b2e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004b30:	9fafc0ef          	jal	80000d2a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004b34:	0085171b          	slliw	a4,a0,0x8
    80004b38:	0c0027b7          	lui	a5,0xc002
    80004b3c:	97ba                	add	a5,a5,a4
    80004b3e:	40200713          	li	a4,1026
    80004b42:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004b46:	00d5151b          	slliw	a0,a0,0xd
    80004b4a:	0c2017b7          	lui	a5,0xc201
    80004b4e:	97aa                	add	a5,a5,a0
    80004b50:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004b54:	60a2                	ld	ra,8(sp)
    80004b56:	6402                	ld	s0,0(sp)
    80004b58:	0141                	addi	sp,sp,16
    80004b5a:	8082                	ret

0000000080004b5c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004b5c:	1141                	addi	sp,sp,-16
    80004b5e:	e406                	sd	ra,8(sp)
    80004b60:	e022                	sd	s0,0(sp)
    80004b62:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004b64:	9c6fc0ef          	jal	80000d2a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004b68:	00d5151b          	slliw	a0,a0,0xd
    80004b6c:	0c2017b7          	lui	a5,0xc201
    80004b70:	97aa                	add	a5,a5,a0
  return irq;
}
    80004b72:	43c8                	lw	a0,4(a5)
    80004b74:	60a2                	ld	ra,8(sp)
    80004b76:	6402                	ld	s0,0(sp)
    80004b78:	0141                	addi	sp,sp,16
    80004b7a:	8082                	ret

0000000080004b7c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004b7c:	1101                	addi	sp,sp,-32
    80004b7e:	ec06                	sd	ra,24(sp)
    80004b80:	e822                	sd	s0,16(sp)
    80004b82:	e426                	sd	s1,8(sp)
    80004b84:	1000                	addi	s0,sp,32
    80004b86:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004b88:	9a2fc0ef          	jal	80000d2a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004b8c:	00d5151b          	slliw	a0,a0,0xd
    80004b90:	0c2017b7          	lui	a5,0xc201
    80004b94:	97aa                	add	a5,a5,a0
    80004b96:	c3c4                	sw	s1,4(a5)
}
    80004b98:	60e2                	ld	ra,24(sp)
    80004b9a:	6442                	ld	s0,16(sp)
    80004b9c:	64a2                	ld	s1,8(sp)
    80004b9e:	6105                	addi	sp,sp,32
    80004ba0:	8082                	ret

0000000080004ba2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004ba2:	1141                	addi	sp,sp,-16
    80004ba4:	e406                	sd	ra,8(sp)
    80004ba6:	e022                	sd	s0,0(sp)
    80004ba8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004baa:	479d                	li	a5,7
    80004bac:	04a7ca63          	blt	a5,a0,80004c00 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004bb0:	00017797          	auipc	a5,0x17
    80004bb4:	e5078793          	addi	a5,a5,-432 # 8001ba00 <disk>
    80004bb8:	97aa                	add	a5,a5,a0
    80004bba:	0187c783          	lbu	a5,24(a5)
    80004bbe:	e7b9                	bnez	a5,80004c0c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004bc0:	00451693          	slli	a3,a0,0x4
    80004bc4:	00017797          	auipc	a5,0x17
    80004bc8:	e3c78793          	addi	a5,a5,-452 # 8001ba00 <disk>
    80004bcc:	6398                	ld	a4,0(a5)
    80004bce:	9736                	add	a4,a4,a3
    80004bd0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004bd4:	6398                	ld	a4,0(a5)
    80004bd6:	9736                	add	a4,a4,a3
    80004bd8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004bdc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004be0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004be4:	97aa                	add	a5,a5,a0
    80004be6:	4705                	li	a4,1
    80004be8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004bec:	00017517          	auipc	a0,0x17
    80004bf0:	e2c50513          	addi	a0,a0,-468 # 8001ba18 <disk+0x18>
    80004bf4:	f88fc0ef          	jal	8000137c <wakeup>
}
    80004bf8:	60a2                	ld	ra,8(sp)
    80004bfa:	6402                	ld	s0,0(sp)
    80004bfc:	0141                	addi	sp,sp,16
    80004bfe:	8082                	ret
    panic("free_desc 1");
    80004c00:	00003517          	auipc	a0,0x3
    80004c04:	b5850513          	addi	a0,a0,-1192 # 80007758 <etext+0x758>
    80004c08:	43b000ef          	jal	80005842 <panic>
    panic("free_desc 2");
    80004c0c:	00003517          	auipc	a0,0x3
    80004c10:	b5c50513          	addi	a0,a0,-1188 # 80007768 <etext+0x768>
    80004c14:	42f000ef          	jal	80005842 <panic>

0000000080004c18 <virtio_disk_init>:
{
    80004c18:	1101                	addi	sp,sp,-32
    80004c1a:	ec06                	sd	ra,24(sp)
    80004c1c:	e822                	sd	s0,16(sp)
    80004c1e:	e426                	sd	s1,8(sp)
    80004c20:	e04a                	sd	s2,0(sp)
    80004c22:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004c24:	00003597          	auipc	a1,0x3
    80004c28:	b5458593          	addi	a1,a1,-1196 # 80007778 <etext+0x778>
    80004c2c:	00017517          	auipc	a0,0x17
    80004c30:	efc50513          	addi	a0,a0,-260 # 8001bb28 <disk+0x128>
    80004c34:	6bd000ef          	jal	80005af0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004c38:	100017b7          	lui	a5,0x10001
    80004c3c:	4398                	lw	a4,0(a5)
    80004c3e:	2701                	sext.w	a4,a4
    80004c40:	747277b7          	lui	a5,0x74727
    80004c44:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004c48:	18f71063          	bne	a4,a5,80004dc8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004c4c:	100017b7          	lui	a5,0x10001
    80004c50:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004c52:	439c                	lw	a5,0(a5)
    80004c54:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004c56:	4709                	li	a4,2
    80004c58:	16e79863          	bne	a5,a4,80004dc8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004c5c:	100017b7          	lui	a5,0x10001
    80004c60:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004c62:	439c                	lw	a5,0(a5)
    80004c64:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004c66:	16e79163          	bne	a5,a4,80004dc8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004c6a:	100017b7          	lui	a5,0x10001
    80004c6e:	47d8                	lw	a4,12(a5)
    80004c70:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004c72:	554d47b7          	lui	a5,0x554d4
    80004c76:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004c7a:	14f71763          	bne	a4,a5,80004dc8 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c7e:	100017b7          	lui	a5,0x10001
    80004c82:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c86:	4705                	li	a4,1
    80004c88:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c8a:	470d                	li	a4,3
    80004c8c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004c8e:	10001737          	lui	a4,0x10001
    80004c92:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004c94:	c7ffe737          	lui	a4,0xc7ffe
    80004c98:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdab1f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004c9c:	8ef9                	and	a3,a3,a4
    80004c9e:	10001737          	lui	a4,0x10001
    80004ca2:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ca4:	472d                	li	a4,11
    80004ca6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ca8:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004cac:	439c                	lw	a5,0(a5)
    80004cae:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004cb2:	8ba1                	andi	a5,a5,8
    80004cb4:	12078063          	beqz	a5,80004dd4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004cb8:	100017b7          	lui	a5,0x10001
    80004cbc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004cc0:	100017b7          	lui	a5,0x10001
    80004cc4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004cc8:	439c                	lw	a5,0(a5)
    80004cca:	2781                	sext.w	a5,a5
    80004ccc:	10079a63          	bnez	a5,80004de0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004cd0:	100017b7          	lui	a5,0x10001
    80004cd4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004cd8:	439c                	lw	a5,0(a5)
    80004cda:	2781                	sext.w	a5,a5
  if(max == 0)
    80004cdc:	10078863          	beqz	a5,80004dec <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004ce0:	471d                	li	a4,7
    80004ce2:	10f77b63          	bgeu	a4,a5,80004df8 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004ce6:	c10fb0ef          	jal	800000f6 <kalloc>
    80004cea:	00017497          	auipc	s1,0x17
    80004cee:	d1648493          	addi	s1,s1,-746 # 8001ba00 <disk>
    80004cf2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004cf4:	c02fb0ef          	jal	800000f6 <kalloc>
    80004cf8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004cfa:	bfcfb0ef          	jal	800000f6 <kalloc>
    80004cfe:	87aa                	mv	a5,a0
    80004d00:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004d02:	6088                	ld	a0,0(s1)
    80004d04:	10050063          	beqz	a0,80004e04 <virtio_disk_init+0x1ec>
    80004d08:	00017717          	auipc	a4,0x17
    80004d0c:	d0073703          	ld	a4,-768(a4) # 8001ba08 <disk+0x8>
    80004d10:	0e070a63          	beqz	a4,80004e04 <virtio_disk_init+0x1ec>
    80004d14:	0e078863          	beqz	a5,80004e04 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004d18:	6605                	lui	a2,0x1
    80004d1a:	4581                	li	a1,0
    80004d1c:	c18fb0ef          	jal	80000134 <memset>
  memset(disk.avail, 0, PGSIZE);
    80004d20:	00017497          	auipc	s1,0x17
    80004d24:	ce048493          	addi	s1,s1,-800 # 8001ba00 <disk>
    80004d28:	6605                	lui	a2,0x1
    80004d2a:	4581                	li	a1,0
    80004d2c:	6488                	ld	a0,8(s1)
    80004d2e:	c06fb0ef          	jal	80000134 <memset>
  memset(disk.used, 0, PGSIZE);
    80004d32:	6605                	lui	a2,0x1
    80004d34:	4581                	li	a1,0
    80004d36:	6888                	ld	a0,16(s1)
    80004d38:	bfcfb0ef          	jal	80000134 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004d3c:	100017b7          	lui	a5,0x10001
    80004d40:	4721                	li	a4,8
    80004d42:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004d44:	4098                	lw	a4,0(s1)
    80004d46:	100017b7          	lui	a5,0x10001
    80004d4a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004d4e:	40d8                	lw	a4,4(s1)
    80004d50:	100017b7          	lui	a5,0x10001
    80004d54:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004d58:	649c                	ld	a5,8(s1)
    80004d5a:	0007869b          	sext.w	a3,a5
    80004d5e:	10001737          	lui	a4,0x10001
    80004d62:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004d66:	9781                	srai	a5,a5,0x20
    80004d68:	10001737          	lui	a4,0x10001
    80004d6c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004d70:	689c                	ld	a5,16(s1)
    80004d72:	0007869b          	sext.w	a3,a5
    80004d76:	10001737          	lui	a4,0x10001
    80004d7a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004d7e:	9781                	srai	a5,a5,0x20
    80004d80:	10001737          	lui	a4,0x10001
    80004d84:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004d88:	10001737          	lui	a4,0x10001
    80004d8c:	4785                	li	a5,1
    80004d8e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004d90:	00f48c23          	sb	a5,24(s1)
    80004d94:	00f48ca3          	sb	a5,25(s1)
    80004d98:	00f48d23          	sb	a5,26(s1)
    80004d9c:	00f48da3          	sb	a5,27(s1)
    80004da0:	00f48e23          	sb	a5,28(s1)
    80004da4:	00f48ea3          	sb	a5,29(s1)
    80004da8:	00f48f23          	sb	a5,30(s1)
    80004dac:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004db0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004db4:	100017b7          	lui	a5,0x10001
    80004db8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004dbc:	60e2                	ld	ra,24(sp)
    80004dbe:	6442                	ld	s0,16(sp)
    80004dc0:	64a2                	ld	s1,8(sp)
    80004dc2:	6902                	ld	s2,0(sp)
    80004dc4:	6105                	addi	sp,sp,32
    80004dc6:	8082                	ret
    panic("could not find virtio disk");
    80004dc8:	00003517          	auipc	a0,0x3
    80004dcc:	9c050513          	addi	a0,a0,-1600 # 80007788 <etext+0x788>
    80004dd0:	273000ef          	jal	80005842 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004dd4:	00003517          	auipc	a0,0x3
    80004dd8:	9d450513          	addi	a0,a0,-1580 # 800077a8 <etext+0x7a8>
    80004ddc:	267000ef          	jal	80005842 <panic>
    panic("virtio disk should not be ready");
    80004de0:	00003517          	auipc	a0,0x3
    80004de4:	9e850513          	addi	a0,a0,-1560 # 800077c8 <etext+0x7c8>
    80004de8:	25b000ef          	jal	80005842 <panic>
    panic("virtio disk has no queue 0");
    80004dec:	00003517          	auipc	a0,0x3
    80004df0:	9fc50513          	addi	a0,a0,-1540 # 800077e8 <etext+0x7e8>
    80004df4:	24f000ef          	jal	80005842 <panic>
    panic("virtio disk max queue too short");
    80004df8:	00003517          	auipc	a0,0x3
    80004dfc:	a1050513          	addi	a0,a0,-1520 # 80007808 <etext+0x808>
    80004e00:	243000ef          	jal	80005842 <panic>
    panic("virtio disk kalloc");
    80004e04:	00003517          	auipc	a0,0x3
    80004e08:	a2450513          	addi	a0,a0,-1500 # 80007828 <etext+0x828>
    80004e0c:	237000ef          	jal	80005842 <panic>

0000000080004e10 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004e10:	7159                	addi	sp,sp,-112
    80004e12:	f486                	sd	ra,104(sp)
    80004e14:	f0a2                	sd	s0,96(sp)
    80004e16:	eca6                	sd	s1,88(sp)
    80004e18:	e8ca                	sd	s2,80(sp)
    80004e1a:	e4ce                	sd	s3,72(sp)
    80004e1c:	e0d2                	sd	s4,64(sp)
    80004e1e:	fc56                	sd	s5,56(sp)
    80004e20:	f85a                	sd	s6,48(sp)
    80004e22:	f45e                	sd	s7,40(sp)
    80004e24:	f062                	sd	s8,32(sp)
    80004e26:	ec66                	sd	s9,24(sp)
    80004e28:	1880                	addi	s0,sp,112
    80004e2a:	8a2a                	mv	s4,a0
    80004e2c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004e2e:	00c52c83          	lw	s9,12(a0)
    80004e32:	001c9c9b          	slliw	s9,s9,0x1
    80004e36:	1c82                	slli	s9,s9,0x20
    80004e38:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004e3c:	00017517          	auipc	a0,0x17
    80004e40:	cec50513          	addi	a0,a0,-788 # 8001bb28 <disk+0x128>
    80004e44:	52d000ef          	jal	80005b70 <acquire>
  for(int i = 0; i < 3; i++){
    80004e48:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004e4a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004e4c:	00017b17          	auipc	s6,0x17
    80004e50:	bb4b0b13          	addi	s6,s6,-1100 # 8001ba00 <disk>
  for(int i = 0; i < 3; i++){
    80004e54:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004e56:	00017c17          	auipc	s8,0x17
    80004e5a:	cd2c0c13          	addi	s8,s8,-814 # 8001bb28 <disk+0x128>
    80004e5e:	a8b9                	j	80004ebc <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004e60:	00fb0733          	add	a4,s6,a5
    80004e64:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004e68:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004e6a:	0207c563          	bltz	a5,80004e94 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004e6e:	2905                	addiw	s2,s2,1
    80004e70:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004e72:	05590963          	beq	s2,s5,80004ec4 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004e76:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004e78:	00017717          	auipc	a4,0x17
    80004e7c:	b8870713          	addi	a4,a4,-1144 # 8001ba00 <disk>
    80004e80:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004e82:	01874683          	lbu	a3,24(a4)
    80004e86:	fee9                	bnez	a3,80004e60 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004e88:	2785                	addiw	a5,a5,1
    80004e8a:	0705                	addi	a4,a4,1
    80004e8c:	fe979be3          	bne	a5,s1,80004e82 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004e90:	57fd                	li	a5,-1
    80004e92:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004e94:	01205d63          	blez	s2,80004eae <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004e98:	f9042503          	lw	a0,-112(s0)
    80004e9c:	d07ff0ef          	jal	80004ba2 <free_desc>
      for(int j = 0; j < i; j++)
    80004ea0:	4785                	li	a5,1
    80004ea2:	0127d663          	bge	a5,s2,80004eae <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004ea6:	f9442503          	lw	a0,-108(s0)
    80004eaa:	cf9ff0ef          	jal	80004ba2 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004eae:	85e2                	mv	a1,s8
    80004eb0:	00017517          	auipc	a0,0x17
    80004eb4:	b6850513          	addi	a0,a0,-1176 # 8001ba18 <disk+0x18>
    80004eb8:	c78fc0ef          	jal	80001330 <sleep>
  for(int i = 0; i < 3; i++){
    80004ebc:	f9040613          	addi	a2,s0,-112
    80004ec0:	894e                	mv	s2,s3
    80004ec2:	bf55                	j	80004e76 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004ec4:	f9042503          	lw	a0,-112(s0)
    80004ec8:	00451693          	slli	a3,a0,0x4

  if(write)
    80004ecc:	00017797          	auipc	a5,0x17
    80004ed0:	b3478793          	addi	a5,a5,-1228 # 8001ba00 <disk>
    80004ed4:	00a50713          	addi	a4,a0,10
    80004ed8:	0712                	slli	a4,a4,0x4
    80004eda:	973e                	add	a4,a4,a5
    80004edc:	01703633          	snez	a2,s7
    80004ee0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004ee2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004ee6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004eea:	6398                	ld	a4,0(a5)
    80004eec:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004eee:	0a868613          	addi	a2,a3,168
    80004ef2:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004ef4:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004ef6:	6390                	ld	a2,0(a5)
    80004ef8:	00d605b3          	add	a1,a2,a3
    80004efc:	4741                	li	a4,16
    80004efe:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004f00:	4805                	li	a6,1
    80004f02:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004f06:	f9442703          	lw	a4,-108(s0)
    80004f0a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004f0e:	0712                	slli	a4,a4,0x4
    80004f10:	963a                	add	a2,a2,a4
    80004f12:	058a0593          	addi	a1,s4,88
    80004f16:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004f18:	0007b883          	ld	a7,0(a5)
    80004f1c:	9746                	add	a4,a4,a7
    80004f1e:	40000613          	li	a2,1024
    80004f22:	c710                	sw	a2,8(a4)
  if(write)
    80004f24:	001bb613          	seqz	a2,s7
    80004f28:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004f2c:	00166613          	ori	a2,a2,1
    80004f30:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004f34:	f9842583          	lw	a1,-104(s0)
    80004f38:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004f3c:	00250613          	addi	a2,a0,2
    80004f40:	0612                	slli	a2,a2,0x4
    80004f42:	963e                	add	a2,a2,a5
    80004f44:	577d                	li	a4,-1
    80004f46:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004f4a:	0592                	slli	a1,a1,0x4
    80004f4c:	98ae                	add	a7,a7,a1
    80004f4e:	03068713          	addi	a4,a3,48
    80004f52:	973e                	add	a4,a4,a5
    80004f54:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004f58:	6398                	ld	a4,0(a5)
    80004f5a:	972e                	add	a4,a4,a1
    80004f5c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004f60:	4689                	li	a3,2
    80004f62:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004f66:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004f6a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004f6e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004f72:	6794                	ld	a3,8(a5)
    80004f74:	0026d703          	lhu	a4,2(a3)
    80004f78:	8b1d                	andi	a4,a4,7
    80004f7a:	0706                	slli	a4,a4,0x1
    80004f7c:	96ba                	add	a3,a3,a4
    80004f7e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004f82:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004f86:	6798                	ld	a4,8(a5)
    80004f88:	00275783          	lhu	a5,2(a4)
    80004f8c:	2785                	addiw	a5,a5,1
    80004f8e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004f92:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004f96:	100017b7          	lui	a5,0x10001
    80004f9a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004f9e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004fa2:	00017917          	auipc	s2,0x17
    80004fa6:	b8690913          	addi	s2,s2,-1146 # 8001bb28 <disk+0x128>
  while(b->disk == 1) {
    80004faa:	4485                	li	s1,1
    80004fac:	01079a63          	bne	a5,a6,80004fc0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004fb0:	85ca                	mv	a1,s2
    80004fb2:	8552                	mv	a0,s4
    80004fb4:	b7cfc0ef          	jal	80001330 <sleep>
  while(b->disk == 1) {
    80004fb8:	004a2783          	lw	a5,4(s4)
    80004fbc:	fe978ae3          	beq	a5,s1,80004fb0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004fc0:	f9042903          	lw	s2,-112(s0)
    80004fc4:	00290713          	addi	a4,s2,2
    80004fc8:	0712                	slli	a4,a4,0x4
    80004fca:	00017797          	auipc	a5,0x17
    80004fce:	a3678793          	addi	a5,a5,-1482 # 8001ba00 <disk>
    80004fd2:	97ba                	add	a5,a5,a4
    80004fd4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004fd8:	00017997          	auipc	s3,0x17
    80004fdc:	a2898993          	addi	s3,s3,-1496 # 8001ba00 <disk>
    80004fe0:	00491713          	slli	a4,s2,0x4
    80004fe4:	0009b783          	ld	a5,0(s3)
    80004fe8:	97ba                	add	a5,a5,a4
    80004fea:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004fee:	854a                	mv	a0,s2
    80004ff0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004ff4:	bafff0ef          	jal	80004ba2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004ff8:	8885                	andi	s1,s1,1
    80004ffa:	f0fd                	bnez	s1,80004fe0 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004ffc:	00017517          	auipc	a0,0x17
    80005000:	b2c50513          	addi	a0,a0,-1236 # 8001bb28 <disk+0x128>
    80005004:	405000ef          	jal	80005c08 <release>
}
    80005008:	70a6                	ld	ra,104(sp)
    8000500a:	7406                	ld	s0,96(sp)
    8000500c:	64e6                	ld	s1,88(sp)
    8000500e:	6946                	ld	s2,80(sp)
    80005010:	69a6                	ld	s3,72(sp)
    80005012:	6a06                	ld	s4,64(sp)
    80005014:	7ae2                	ld	s5,56(sp)
    80005016:	7b42                	ld	s6,48(sp)
    80005018:	7ba2                	ld	s7,40(sp)
    8000501a:	7c02                	ld	s8,32(sp)
    8000501c:	6ce2                	ld	s9,24(sp)
    8000501e:	6165                	addi	sp,sp,112
    80005020:	8082                	ret

0000000080005022 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005022:	1101                	addi	sp,sp,-32
    80005024:	ec06                	sd	ra,24(sp)
    80005026:	e822                	sd	s0,16(sp)
    80005028:	e426                	sd	s1,8(sp)
    8000502a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000502c:	00017497          	auipc	s1,0x17
    80005030:	9d448493          	addi	s1,s1,-1580 # 8001ba00 <disk>
    80005034:	00017517          	auipc	a0,0x17
    80005038:	af450513          	addi	a0,a0,-1292 # 8001bb28 <disk+0x128>
    8000503c:	335000ef          	jal	80005b70 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005040:	100017b7          	lui	a5,0x10001
    80005044:	53b8                	lw	a4,96(a5)
    80005046:	8b0d                	andi	a4,a4,3
    80005048:	100017b7          	lui	a5,0x10001
    8000504c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    8000504e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005052:	689c                	ld	a5,16(s1)
    80005054:	0204d703          	lhu	a4,32(s1)
    80005058:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000505c:	04f70663          	beq	a4,a5,800050a8 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005060:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005064:	6898                	ld	a4,16(s1)
    80005066:	0204d783          	lhu	a5,32(s1)
    8000506a:	8b9d                	andi	a5,a5,7
    8000506c:	078e                	slli	a5,a5,0x3
    8000506e:	97ba                	add	a5,a5,a4
    80005070:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005072:	00278713          	addi	a4,a5,2
    80005076:	0712                	slli	a4,a4,0x4
    80005078:	9726                	add	a4,a4,s1
    8000507a:	01074703          	lbu	a4,16(a4)
    8000507e:	e321                	bnez	a4,800050be <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005080:	0789                	addi	a5,a5,2
    80005082:	0792                	slli	a5,a5,0x4
    80005084:	97a6                	add	a5,a5,s1
    80005086:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005088:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000508c:	af0fc0ef          	jal	8000137c <wakeup>

    disk.used_idx += 1;
    80005090:	0204d783          	lhu	a5,32(s1)
    80005094:	2785                	addiw	a5,a5,1
    80005096:	17c2                	slli	a5,a5,0x30
    80005098:	93c1                	srli	a5,a5,0x30
    8000509a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000509e:	6898                	ld	a4,16(s1)
    800050a0:	00275703          	lhu	a4,2(a4)
    800050a4:	faf71ee3          	bne	a4,a5,80005060 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800050a8:	00017517          	auipc	a0,0x17
    800050ac:	a8050513          	addi	a0,a0,-1408 # 8001bb28 <disk+0x128>
    800050b0:	359000ef          	jal	80005c08 <release>
}
    800050b4:	60e2                	ld	ra,24(sp)
    800050b6:	6442                	ld	s0,16(sp)
    800050b8:	64a2                	ld	s1,8(sp)
    800050ba:	6105                	addi	sp,sp,32
    800050bc:	8082                	ret
      panic("virtio_disk_intr status");
    800050be:	00002517          	auipc	a0,0x2
    800050c2:	78250513          	addi	a0,a0,1922 # 80007840 <etext+0x840>
    800050c6:	77c000ef          	jal	80005842 <panic>

00000000800050ca <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    800050ca:	1141                	addi	sp,sp,-16
    800050cc:	e422                	sd	s0,8(sp)
    800050ce:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    800050d0:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    800050d4:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    800050d8:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    800050dc:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    800050e0:	577d                	li	a4,-1
    800050e2:	177e                	slli	a4,a4,0x3f
    800050e4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    800050e6:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    800050ea:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    800050ee:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    800050f2:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    800050f6:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    800050fa:	000f4737          	lui	a4,0xf4
    800050fe:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80005102:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80005104:	14d79073          	csrw	stimecmp,a5
}
    80005108:	6422                	ld	s0,8(sp)
    8000510a:	0141                	addi	sp,sp,16
    8000510c:	8082                	ret

000000008000510e <start>:
{
    8000510e:	1141                	addi	sp,sp,-16
    80005110:	e406                	sd	ra,8(sp)
    80005112:	e022                	sd	s0,0(sp)
    80005114:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005116:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000511a:	7779                	lui	a4,0xffffe
    8000511c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdabbf>
    80005120:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005122:	6705                	lui	a4,0x1
    80005124:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005128:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000512a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000512e:	ffffb797          	auipc	a5,0xffffb
    80005132:	1a078793          	addi	a5,a5,416 # 800002ce <main>
    80005136:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000513a:	4781                	li	a5,0
    8000513c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005140:	67c1                	lui	a5,0x10
    80005142:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005144:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005148:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000514c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005150:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005154:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005158:	57fd                	li	a5,-1
    8000515a:	83a9                	srli	a5,a5,0xa
    8000515c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005160:	47bd                	li	a5,15
    80005162:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005166:	f65ff0ef          	jal	800050ca <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000516a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000516e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005170:	823e                	mv	tp,a5
  asm volatile("mret");
    80005172:	30200073          	mret
}
    80005176:	60a2                	ld	ra,8(sp)
    80005178:	6402                	ld	s0,0(sp)
    8000517a:	0141                	addi	sp,sp,16
    8000517c:	8082                	ret

000000008000517e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000517e:	715d                	addi	sp,sp,-80
    80005180:	e486                	sd	ra,72(sp)
    80005182:	e0a2                	sd	s0,64(sp)
    80005184:	f84a                	sd	s2,48(sp)
    80005186:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005188:	04c05263          	blez	a2,800051cc <consolewrite+0x4e>
    8000518c:	fc26                	sd	s1,56(sp)
    8000518e:	f44e                	sd	s3,40(sp)
    80005190:	f052                	sd	s4,32(sp)
    80005192:	ec56                	sd	s5,24(sp)
    80005194:	8a2a                	mv	s4,a0
    80005196:	84ae                	mv	s1,a1
    80005198:	89b2                	mv	s3,a2
    8000519a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000519c:	5afd                	li	s5,-1
    8000519e:	4685                	li	a3,1
    800051a0:	8626                	mv	a2,s1
    800051a2:	85d2                	mv	a1,s4
    800051a4:	fbf40513          	addi	a0,s0,-65
    800051a8:	d2efc0ef          	jal	800016d6 <either_copyin>
    800051ac:	03550263          	beq	a0,s5,800051d0 <consolewrite+0x52>
      break;
    uartputc(c);
    800051b0:	fbf44503          	lbu	a0,-65(s0)
    800051b4:	035000ef          	jal	800059e8 <uartputc>
  for(i = 0; i < n; i++){
    800051b8:	2905                	addiw	s2,s2,1
    800051ba:	0485                	addi	s1,s1,1
    800051bc:	ff2991e3          	bne	s3,s2,8000519e <consolewrite+0x20>
    800051c0:	894e                	mv	s2,s3
    800051c2:	74e2                	ld	s1,56(sp)
    800051c4:	79a2                	ld	s3,40(sp)
    800051c6:	7a02                	ld	s4,32(sp)
    800051c8:	6ae2                	ld	s5,24(sp)
    800051ca:	a039                	j	800051d8 <consolewrite+0x5a>
    800051cc:	4901                	li	s2,0
    800051ce:	a029                	j	800051d8 <consolewrite+0x5a>
    800051d0:	74e2                	ld	s1,56(sp)
    800051d2:	79a2                	ld	s3,40(sp)
    800051d4:	7a02                	ld	s4,32(sp)
    800051d6:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    800051d8:	854a                	mv	a0,s2
    800051da:	60a6                	ld	ra,72(sp)
    800051dc:	6406                	ld	s0,64(sp)
    800051de:	7942                	ld	s2,48(sp)
    800051e0:	6161                	addi	sp,sp,80
    800051e2:	8082                	ret

00000000800051e4 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800051e4:	711d                	addi	sp,sp,-96
    800051e6:	ec86                	sd	ra,88(sp)
    800051e8:	e8a2                	sd	s0,80(sp)
    800051ea:	e4a6                	sd	s1,72(sp)
    800051ec:	e0ca                	sd	s2,64(sp)
    800051ee:	fc4e                	sd	s3,56(sp)
    800051f0:	f852                	sd	s4,48(sp)
    800051f2:	f456                	sd	s5,40(sp)
    800051f4:	f05a                	sd	s6,32(sp)
    800051f6:	1080                	addi	s0,sp,96
    800051f8:	8aaa                	mv	s5,a0
    800051fa:	8a2e                	mv	s4,a1
    800051fc:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800051fe:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005202:	0001f517          	auipc	a0,0x1f
    80005206:	93e50513          	addi	a0,a0,-1730 # 80023b40 <cons>
    8000520a:	167000ef          	jal	80005b70 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000520e:	0001f497          	auipc	s1,0x1f
    80005212:	93248493          	addi	s1,s1,-1742 # 80023b40 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005216:	0001f917          	auipc	s2,0x1f
    8000521a:	9c290913          	addi	s2,s2,-1598 # 80023bd8 <cons+0x98>
  while(n > 0){
    8000521e:	0b305d63          	blez	s3,800052d8 <consoleread+0xf4>
    while(cons.r == cons.w){
    80005222:	0984a783          	lw	a5,152(s1)
    80005226:	09c4a703          	lw	a4,156(s1)
    8000522a:	0af71263          	bne	a4,a5,800052ce <consoleread+0xea>
      if(killed(myproc())){
    8000522e:	b29fb0ef          	jal	80000d56 <myproc>
    80005232:	b36fc0ef          	jal	80001568 <killed>
    80005236:	e12d                	bnez	a0,80005298 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80005238:	85a6                	mv	a1,s1
    8000523a:	854a                	mv	a0,s2
    8000523c:	8f4fc0ef          	jal	80001330 <sleep>
    while(cons.r == cons.w){
    80005240:	0984a783          	lw	a5,152(s1)
    80005244:	09c4a703          	lw	a4,156(s1)
    80005248:	fef703e3          	beq	a4,a5,8000522e <consoleread+0x4a>
    8000524c:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000524e:	0001f717          	auipc	a4,0x1f
    80005252:	8f270713          	addi	a4,a4,-1806 # 80023b40 <cons>
    80005256:	0017869b          	addiw	a3,a5,1
    8000525a:	08d72c23          	sw	a3,152(a4)
    8000525e:	07f7f693          	andi	a3,a5,127
    80005262:	9736                	add	a4,a4,a3
    80005264:	01874703          	lbu	a4,24(a4)
    80005268:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    8000526c:	4691                	li	a3,4
    8000526e:	04db8663          	beq	s7,a3,800052ba <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005272:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005276:	4685                	li	a3,1
    80005278:	faf40613          	addi	a2,s0,-81
    8000527c:	85d2                	mv	a1,s4
    8000527e:	8556                	mv	a0,s5
    80005280:	c0cfc0ef          	jal	8000168c <either_copyout>
    80005284:	57fd                	li	a5,-1
    80005286:	04f50863          	beq	a0,a5,800052d6 <consoleread+0xf2>
      break;

    dst++;
    8000528a:	0a05                	addi	s4,s4,1
    --n;
    8000528c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000528e:	47a9                	li	a5,10
    80005290:	04fb8d63          	beq	s7,a5,800052ea <consoleread+0x106>
    80005294:	6be2                	ld	s7,24(sp)
    80005296:	b761                	j	8000521e <consoleread+0x3a>
        release(&cons.lock);
    80005298:	0001f517          	auipc	a0,0x1f
    8000529c:	8a850513          	addi	a0,a0,-1880 # 80023b40 <cons>
    800052a0:	169000ef          	jal	80005c08 <release>
        return -1;
    800052a4:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800052a6:	60e6                	ld	ra,88(sp)
    800052a8:	6446                	ld	s0,80(sp)
    800052aa:	64a6                	ld	s1,72(sp)
    800052ac:	6906                	ld	s2,64(sp)
    800052ae:	79e2                	ld	s3,56(sp)
    800052b0:	7a42                	ld	s4,48(sp)
    800052b2:	7aa2                	ld	s5,40(sp)
    800052b4:	7b02                	ld	s6,32(sp)
    800052b6:	6125                	addi	sp,sp,96
    800052b8:	8082                	ret
      if(n < target){
    800052ba:	0009871b          	sext.w	a4,s3
    800052be:	01677a63          	bgeu	a4,s6,800052d2 <consoleread+0xee>
        cons.r--;
    800052c2:	0001f717          	auipc	a4,0x1f
    800052c6:	90f72b23          	sw	a5,-1770(a4) # 80023bd8 <cons+0x98>
    800052ca:	6be2                	ld	s7,24(sp)
    800052cc:	a031                	j	800052d8 <consoleread+0xf4>
    800052ce:	ec5e                	sd	s7,24(sp)
    800052d0:	bfbd                	j	8000524e <consoleread+0x6a>
    800052d2:	6be2                	ld	s7,24(sp)
    800052d4:	a011                	j	800052d8 <consoleread+0xf4>
    800052d6:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    800052d8:	0001f517          	auipc	a0,0x1f
    800052dc:	86850513          	addi	a0,a0,-1944 # 80023b40 <cons>
    800052e0:	129000ef          	jal	80005c08 <release>
  return target - n;
    800052e4:	413b053b          	subw	a0,s6,s3
    800052e8:	bf7d                	j	800052a6 <consoleread+0xc2>
    800052ea:	6be2                	ld	s7,24(sp)
    800052ec:	b7f5                	j	800052d8 <consoleread+0xf4>

00000000800052ee <consputc>:
{
    800052ee:	1141                	addi	sp,sp,-16
    800052f0:	e406                	sd	ra,8(sp)
    800052f2:	e022                	sd	s0,0(sp)
    800052f4:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800052f6:	10000793          	li	a5,256
    800052fa:	00f50863          	beq	a0,a5,8000530a <consputc+0x1c>
    uartputc_sync(c);
    800052fe:	604000ef          	jal	80005902 <uartputc_sync>
}
    80005302:	60a2                	ld	ra,8(sp)
    80005304:	6402                	ld	s0,0(sp)
    80005306:	0141                	addi	sp,sp,16
    80005308:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000530a:	4521                	li	a0,8
    8000530c:	5f6000ef          	jal	80005902 <uartputc_sync>
    80005310:	02000513          	li	a0,32
    80005314:	5ee000ef          	jal	80005902 <uartputc_sync>
    80005318:	4521                	li	a0,8
    8000531a:	5e8000ef          	jal	80005902 <uartputc_sync>
    8000531e:	b7d5                	j	80005302 <consputc+0x14>

0000000080005320 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005320:	1101                	addi	sp,sp,-32
    80005322:	ec06                	sd	ra,24(sp)
    80005324:	e822                	sd	s0,16(sp)
    80005326:	e426                	sd	s1,8(sp)
    80005328:	1000                	addi	s0,sp,32
    8000532a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000532c:	0001f517          	auipc	a0,0x1f
    80005330:	81450513          	addi	a0,a0,-2028 # 80023b40 <cons>
    80005334:	03d000ef          	jal	80005b70 <acquire>

  switch(c){
    80005338:	47d5                	li	a5,21
    8000533a:	08f48f63          	beq	s1,a5,800053d8 <consoleintr+0xb8>
    8000533e:	0297c563          	blt	a5,s1,80005368 <consoleintr+0x48>
    80005342:	47a1                	li	a5,8
    80005344:	0ef48463          	beq	s1,a5,8000542c <consoleintr+0x10c>
    80005348:	47c1                	li	a5,16
    8000534a:	10f49563          	bne	s1,a5,80005454 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    8000534e:	bd2fc0ef          	jal	80001720 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005352:	0001e517          	auipc	a0,0x1e
    80005356:	7ee50513          	addi	a0,a0,2030 # 80023b40 <cons>
    8000535a:	0af000ef          	jal	80005c08 <release>
}
    8000535e:	60e2                	ld	ra,24(sp)
    80005360:	6442                	ld	s0,16(sp)
    80005362:	64a2                	ld	s1,8(sp)
    80005364:	6105                	addi	sp,sp,32
    80005366:	8082                	ret
  switch(c){
    80005368:	07f00793          	li	a5,127
    8000536c:	0cf48063          	beq	s1,a5,8000542c <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005370:	0001e717          	auipc	a4,0x1e
    80005374:	7d070713          	addi	a4,a4,2000 # 80023b40 <cons>
    80005378:	0a072783          	lw	a5,160(a4)
    8000537c:	09872703          	lw	a4,152(a4)
    80005380:	9f99                	subw	a5,a5,a4
    80005382:	07f00713          	li	a4,127
    80005386:	fcf766e3          	bltu	a4,a5,80005352 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    8000538a:	47b5                	li	a5,13
    8000538c:	0cf48763          	beq	s1,a5,8000545a <consoleintr+0x13a>
      consputc(c);
    80005390:	8526                	mv	a0,s1
    80005392:	f5dff0ef          	jal	800052ee <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005396:	0001e797          	auipc	a5,0x1e
    8000539a:	7aa78793          	addi	a5,a5,1962 # 80023b40 <cons>
    8000539e:	0a07a683          	lw	a3,160(a5)
    800053a2:	0016871b          	addiw	a4,a3,1
    800053a6:	0007061b          	sext.w	a2,a4
    800053aa:	0ae7a023          	sw	a4,160(a5)
    800053ae:	07f6f693          	andi	a3,a3,127
    800053b2:	97b6                	add	a5,a5,a3
    800053b4:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800053b8:	47a9                	li	a5,10
    800053ba:	0cf48563          	beq	s1,a5,80005484 <consoleintr+0x164>
    800053be:	4791                	li	a5,4
    800053c0:	0cf48263          	beq	s1,a5,80005484 <consoleintr+0x164>
    800053c4:	0001f797          	auipc	a5,0x1f
    800053c8:	8147a783          	lw	a5,-2028(a5) # 80023bd8 <cons+0x98>
    800053cc:	9f1d                	subw	a4,a4,a5
    800053ce:	08000793          	li	a5,128
    800053d2:	f8f710e3          	bne	a4,a5,80005352 <consoleintr+0x32>
    800053d6:	a07d                	j	80005484 <consoleintr+0x164>
    800053d8:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800053da:	0001e717          	auipc	a4,0x1e
    800053de:	76670713          	addi	a4,a4,1894 # 80023b40 <cons>
    800053e2:	0a072783          	lw	a5,160(a4)
    800053e6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800053ea:	0001e497          	auipc	s1,0x1e
    800053ee:	75648493          	addi	s1,s1,1878 # 80023b40 <cons>
    while(cons.e != cons.w &&
    800053f2:	4929                	li	s2,10
    800053f4:	02f70863          	beq	a4,a5,80005424 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800053f8:	37fd                	addiw	a5,a5,-1
    800053fa:	07f7f713          	andi	a4,a5,127
    800053fe:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005400:	01874703          	lbu	a4,24(a4)
    80005404:	03270263          	beq	a4,s2,80005428 <consoleintr+0x108>
      cons.e--;
    80005408:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000540c:	10000513          	li	a0,256
    80005410:	edfff0ef          	jal	800052ee <consputc>
    while(cons.e != cons.w &&
    80005414:	0a04a783          	lw	a5,160(s1)
    80005418:	09c4a703          	lw	a4,156(s1)
    8000541c:	fcf71ee3          	bne	a4,a5,800053f8 <consoleintr+0xd8>
    80005420:	6902                	ld	s2,0(sp)
    80005422:	bf05                	j	80005352 <consoleintr+0x32>
    80005424:	6902                	ld	s2,0(sp)
    80005426:	b735                	j	80005352 <consoleintr+0x32>
    80005428:	6902                	ld	s2,0(sp)
    8000542a:	b725                	j	80005352 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000542c:	0001e717          	auipc	a4,0x1e
    80005430:	71470713          	addi	a4,a4,1812 # 80023b40 <cons>
    80005434:	0a072783          	lw	a5,160(a4)
    80005438:	09c72703          	lw	a4,156(a4)
    8000543c:	f0f70be3          	beq	a4,a5,80005352 <consoleintr+0x32>
      cons.e--;
    80005440:	37fd                	addiw	a5,a5,-1
    80005442:	0001e717          	auipc	a4,0x1e
    80005446:	78f72f23          	sw	a5,1950(a4) # 80023be0 <cons+0xa0>
      consputc(BACKSPACE);
    8000544a:	10000513          	li	a0,256
    8000544e:	ea1ff0ef          	jal	800052ee <consputc>
    80005452:	b701                	j	80005352 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005454:	ee048fe3          	beqz	s1,80005352 <consoleintr+0x32>
    80005458:	bf21                	j	80005370 <consoleintr+0x50>
      consputc(c);
    8000545a:	4529                	li	a0,10
    8000545c:	e93ff0ef          	jal	800052ee <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005460:	0001e797          	auipc	a5,0x1e
    80005464:	6e078793          	addi	a5,a5,1760 # 80023b40 <cons>
    80005468:	0a07a703          	lw	a4,160(a5)
    8000546c:	0017069b          	addiw	a3,a4,1
    80005470:	0006861b          	sext.w	a2,a3
    80005474:	0ad7a023          	sw	a3,160(a5)
    80005478:	07f77713          	andi	a4,a4,127
    8000547c:	97ba                	add	a5,a5,a4
    8000547e:	4729                	li	a4,10
    80005480:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005484:	0001e797          	auipc	a5,0x1e
    80005488:	74c7ac23          	sw	a2,1880(a5) # 80023bdc <cons+0x9c>
        wakeup(&cons.r);
    8000548c:	0001e517          	auipc	a0,0x1e
    80005490:	74c50513          	addi	a0,a0,1868 # 80023bd8 <cons+0x98>
    80005494:	ee9fb0ef          	jal	8000137c <wakeup>
    80005498:	bd6d                	j	80005352 <consoleintr+0x32>

000000008000549a <consoleinit>:

void
consoleinit(void)
{
    8000549a:	1141                	addi	sp,sp,-16
    8000549c:	e406                	sd	ra,8(sp)
    8000549e:	e022                	sd	s0,0(sp)
    800054a0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800054a2:	00002597          	auipc	a1,0x2
    800054a6:	3b658593          	addi	a1,a1,950 # 80007858 <etext+0x858>
    800054aa:	0001e517          	auipc	a0,0x1e
    800054ae:	69650513          	addi	a0,a0,1686 # 80023b40 <cons>
    800054b2:	63e000ef          	jal	80005af0 <initlock>

  uartinit();
    800054b6:	3f4000ef          	jal	800058aa <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800054ba:	00015797          	auipc	a5,0x15
    800054be:	4ee78793          	addi	a5,a5,1262 # 8001a9a8 <devsw>
    800054c2:	00000717          	auipc	a4,0x0
    800054c6:	d2270713          	addi	a4,a4,-734 # 800051e4 <consoleread>
    800054ca:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800054cc:	00000717          	auipc	a4,0x0
    800054d0:	cb270713          	addi	a4,a4,-846 # 8000517e <consolewrite>
    800054d4:	ef98                	sd	a4,24(a5)
}
    800054d6:	60a2                	ld	ra,8(sp)
    800054d8:	6402                	ld	s0,0(sp)
    800054da:	0141                	addi	sp,sp,16
    800054dc:	8082                	ret

00000000800054de <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800054de:	7179                	addi	sp,sp,-48
    800054e0:	f406                	sd	ra,40(sp)
    800054e2:	f022                	sd	s0,32(sp)
    800054e4:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800054e6:	c219                	beqz	a2,800054ec <printint+0xe>
    800054e8:	08054063          	bltz	a0,80005568 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    800054ec:	4881                	li	a7,0
    800054ee:	fd040693          	addi	a3,s0,-48

  i = 0;
    800054f2:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800054f4:	00002617          	auipc	a2,0x2
    800054f8:	61460613          	addi	a2,a2,1556 # 80007b08 <digits>
    800054fc:	883e                	mv	a6,a5
    800054fe:	2785                	addiw	a5,a5,1
    80005500:	02b57733          	remu	a4,a0,a1
    80005504:	9732                	add	a4,a4,a2
    80005506:	00074703          	lbu	a4,0(a4)
    8000550a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000550e:	872a                	mv	a4,a0
    80005510:	02b55533          	divu	a0,a0,a1
    80005514:	0685                	addi	a3,a3,1
    80005516:	feb773e3          	bgeu	a4,a1,800054fc <printint+0x1e>

  if(sign)
    8000551a:	00088a63          	beqz	a7,8000552e <printint+0x50>
    buf[i++] = '-';
    8000551e:	1781                	addi	a5,a5,-32
    80005520:	97a2                	add	a5,a5,s0
    80005522:	02d00713          	li	a4,45
    80005526:	fee78823          	sb	a4,-16(a5)
    8000552a:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    8000552e:	02f05963          	blez	a5,80005560 <printint+0x82>
    80005532:	ec26                	sd	s1,24(sp)
    80005534:	e84a                	sd	s2,16(sp)
    80005536:	fd040713          	addi	a4,s0,-48
    8000553a:	00f704b3          	add	s1,a4,a5
    8000553e:	fff70913          	addi	s2,a4,-1
    80005542:	993e                	add	s2,s2,a5
    80005544:	37fd                	addiw	a5,a5,-1
    80005546:	1782                	slli	a5,a5,0x20
    80005548:	9381                	srli	a5,a5,0x20
    8000554a:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000554e:	fff4c503          	lbu	a0,-1(s1)
    80005552:	d9dff0ef          	jal	800052ee <consputc>
  while(--i >= 0)
    80005556:	14fd                	addi	s1,s1,-1
    80005558:	ff249be3          	bne	s1,s2,8000554e <printint+0x70>
    8000555c:	64e2                	ld	s1,24(sp)
    8000555e:	6942                	ld	s2,16(sp)
}
    80005560:	70a2                	ld	ra,40(sp)
    80005562:	7402                	ld	s0,32(sp)
    80005564:	6145                	addi	sp,sp,48
    80005566:	8082                	ret
    x = -xx;
    80005568:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000556c:	4885                	li	a7,1
    x = -xx;
    8000556e:	b741                	j	800054ee <printint+0x10>

0000000080005570 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005570:	7155                	addi	sp,sp,-208
    80005572:	e506                	sd	ra,136(sp)
    80005574:	e122                	sd	s0,128(sp)
    80005576:	f0d2                	sd	s4,96(sp)
    80005578:	0900                	addi	s0,sp,144
    8000557a:	8a2a                	mv	s4,a0
    8000557c:	e40c                	sd	a1,8(s0)
    8000557e:	e810                	sd	a2,16(s0)
    80005580:	ec14                	sd	a3,24(s0)
    80005582:	f018                	sd	a4,32(s0)
    80005584:	f41c                	sd	a5,40(s0)
    80005586:	03043823          	sd	a6,48(s0)
    8000558a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    8000558e:	0001e797          	auipc	a5,0x1e
    80005592:	6727a783          	lw	a5,1650(a5) # 80023c00 <pr+0x18>
    80005596:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8000559a:	e3a1                	bnez	a5,800055da <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000559c:	00840793          	addi	a5,s0,8
    800055a0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800055a4:	00054503          	lbu	a0,0(a0)
    800055a8:	26050763          	beqz	a0,80005816 <printf+0x2a6>
    800055ac:	fca6                	sd	s1,120(sp)
    800055ae:	f8ca                	sd	s2,112(sp)
    800055b0:	f4ce                	sd	s3,104(sp)
    800055b2:	ecd6                	sd	s5,88(sp)
    800055b4:	e8da                	sd	s6,80(sp)
    800055b6:	e0e2                	sd	s8,64(sp)
    800055b8:	fc66                	sd	s9,56(sp)
    800055ba:	f86a                	sd	s10,48(sp)
    800055bc:	f46e                	sd	s11,40(sp)
    800055be:	4981                	li	s3,0
    if(cx != '%'){
    800055c0:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800055c4:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800055c8:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800055cc:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800055d0:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800055d4:	07000d93          	li	s11,112
    800055d8:	a815                	j	8000560c <printf+0x9c>
    acquire(&pr.lock);
    800055da:	0001e517          	auipc	a0,0x1e
    800055de:	60e50513          	addi	a0,a0,1550 # 80023be8 <pr>
    800055e2:	58e000ef          	jal	80005b70 <acquire>
  va_start(ap, fmt);
    800055e6:	00840793          	addi	a5,s0,8
    800055ea:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800055ee:	000a4503          	lbu	a0,0(s4)
    800055f2:	fd4d                	bnez	a0,800055ac <printf+0x3c>
    800055f4:	a481                	j	80005834 <printf+0x2c4>
      consputc(cx);
    800055f6:	cf9ff0ef          	jal	800052ee <consputc>
      continue;
    800055fa:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800055fc:	0014899b          	addiw	s3,s1,1
    80005600:	013a07b3          	add	a5,s4,s3
    80005604:	0007c503          	lbu	a0,0(a5)
    80005608:	1e050b63          	beqz	a0,800057fe <printf+0x28e>
    if(cx != '%'){
    8000560c:	ff5515e3          	bne	a0,s5,800055f6 <printf+0x86>
    i++;
    80005610:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80005614:	009a07b3          	add	a5,s4,s1
    80005618:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000561c:	1e090163          	beqz	s2,800057fe <printf+0x28e>
    80005620:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80005624:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80005626:	c789                	beqz	a5,80005630 <printf+0xc0>
    80005628:	009a0733          	add	a4,s4,s1
    8000562c:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005630:	03690763          	beq	s2,s6,8000565e <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80005634:	05890163          	beq	s2,s8,80005676 <printf+0x106>
    } else if(c0 == 'u'){
    80005638:	0d990b63          	beq	s2,s9,8000570e <printf+0x19e>
    } else if(c0 == 'x'){
    8000563c:	13a90163          	beq	s2,s10,8000575e <printf+0x1ee>
    } else if(c0 == 'p'){
    80005640:	13b90b63          	beq	s2,s11,80005776 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005644:	07300793          	li	a5,115
    80005648:	16f90a63          	beq	s2,a5,800057bc <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000564c:	1b590463          	beq	s2,s5,800057f4 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005650:	8556                	mv	a0,s5
    80005652:	c9dff0ef          	jal	800052ee <consputc>
      consputc(c0);
    80005656:	854a                	mv	a0,s2
    80005658:	c97ff0ef          	jal	800052ee <consputc>
    8000565c:	b745                	j	800055fc <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    8000565e:	f8843783          	ld	a5,-120(s0)
    80005662:	00878713          	addi	a4,a5,8
    80005666:	f8e43423          	sd	a4,-120(s0)
    8000566a:	4605                	li	a2,1
    8000566c:	45a9                	li	a1,10
    8000566e:	4388                	lw	a0,0(a5)
    80005670:	e6fff0ef          	jal	800054de <printint>
    80005674:	b761                	j	800055fc <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    80005676:	03678663          	beq	a5,s6,800056a2 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000567a:	05878263          	beq	a5,s8,800056be <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    8000567e:	0b978463          	beq	a5,s9,80005726 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    80005682:	fda797e3          	bne	a5,s10,80005650 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005686:	f8843783          	ld	a5,-120(s0)
    8000568a:	00878713          	addi	a4,a5,8
    8000568e:	f8e43423          	sd	a4,-120(s0)
    80005692:	4601                	li	a2,0
    80005694:	45c1                	li	a1,16
    80005696:	6388                	ld	a0,0(a5)
    80005698:	e47ff0ef          	jal	800054de <printint>
      i += 1;
    8000569c:	0029849b          	addiw	s1,s3,2
    800056a0:	bfb1                	j	800055fc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800056a2:	f8843783          	ld	a5,-120(s0)
    800056a6:	00878713          	addi	a4,a5,8
    800056aa:	f8e43423          	sd	a4,-120(s0)
    800056ae:	4605                	li	a2,1
    800056b0:	45a9                	li	a1,10
    800056b2:	6388                	ld	a0,0(a5)
    800056b4:	e2bff0ef          	jal	800054de <printint>
      i += 1;
    800056b8:	0029849b          	addiw	s1,s3,2
    800056bc:	b781                	j	800055fc <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800056be:	06400793          	li	a5,100
    800056c2:	02f68863          	beq	a3,a5,800056f2 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800056c6:	07500793          	li	a5,117
    800056ca:	06f68c63          	beq	a3,a5,80005742 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800056ce:	07800793          	li	a5,120
    800056d2:	f6f69fe3          	bne	a3,a5,80005650 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800056d6:	f8843783          	ld	a5,-120(s0)
    800056da:	00878713          	addi	a4,a5,8
    800056de:	f8e43423          	sd	a4,-120(s0)
    800056e2:	4601                	li	a2,0
    800056e4:	45c1                	li	a1,16
    800056e6:	6388                	ld	a0,0(a5)
    800056e8:	df7ff0ef          	jal	800054de <printint>
      i += 2;
    800056ec:	0039849b          	addiw	s1,s3,3
    800056f0:	b731                	j	800055fc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800056f2:	f8843783          	ld	a5,-120(s0)
    800056f6:	00878713          	addi	a4,a5,8
    800056fa:	f8e43423          	sd	a4,-120(s0)
    800056fe:	4605                	li	a2,1
    80005700:	45a9                	li	a1,10
    80005702:	6388                	ld	a0,0(a5)
    80005704:	ddbff0ef          	jal	800054de <printint>
      i += 2;
    80005708:	0039849b          	addiw	s1,s3,3
    8000570c:	bdc5                	j	800055fc <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    8000570e:	f8843783          	ld	a5,-120(s0)
    80005712:	00878713          	addi	a4,a5,8
    80005716:	f8e43423          	sd	a4,-120(s0)
    8000571a:	4601                	li	a2,0
    8000571c:	45a9                	li	a1,10
    8000571e:	4388                	lw	a0,0(a5)
    80005720:	dbfff0ef          	jal	800054de <printint>
    80005724:	bde1                	j	800055fc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005726:	f8843783          	ld	a5,-120(s0)
    8000572a:	00878713          	addi	a4,a5,8
    8000572e:	f8e43423          	sd	a4,-120(s0)
    80005732:	4601                	li	a2,0
    80005734:	45a9                	li	a1,10
    80005736:	6388                	ld	a0,0(a5)
    80005738:	da7ff0ef          	jal	800054de <printint>
      i += 1;
    8000573c:	0029849b          	addiw	s1,s3,2
    80005740:	bd75                	j	800055fc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005742:	f8843783          	ld	a5,-120(s0)
    80005746:	00878713          	addi	a4,a5,8
    8000574a:	f8e43423          	sd	a4,-120(s0)
    8000574e:	4601                	li	a2,0
    80005750:	45a9                	li	a1,10
    80005752:	6388                	ld	a0,0(a5)
    80005754:	d8bff0ef          	jal	800054de <printint>
      i += 2;
    80005758:	0039849b          	addiw	s1,s3,3
    8000575c:	b545                	j	800055fc <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    8000575e:	f8843783          	ld	a5,-120(s0)
    80005762:	00878713          	addi	a4,a5,8
    80005766:	f8e43423          	sd	a4,-120(s0)
    8000576a:	4601                	li	a2,0
    8000576c:	45c1                	li	a1,16
    8000576e:	4388                	lw	a0,0(a5)
    80005770:	d6fff0ef          	jal	800054de <printint>
    80005774:	b561                	j	800055fc <printf+0x8c>
    80005776:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    80005778:	f8843783          	ld	a5,-120(s0)
    8000577c:	00878713          	addi	a4,a5,8
    80005780:	f8e43423          	sd	a4,-120(s0)
    80005784:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005788:	03000513          	li	a0,48
    8000578c:	b63ff0ef          	jal	800052ee <consputc>
  consputc('x');
    80005790:	07800513          	li	a0,120
    80005794:	b5bff0ef          	jal	800052ee <consputc>
    80005798:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000579a:	00002b97          	auipc	s7,0x2
    8000579e:	36eb8b93          	addi	s7,s7,878 # 80007b08 <digits>
    800057a2:	03c9d793          	srli	a5,s3,0x3c
    800057a6:	97de                	add	a5,a5,s7
    800057a8:	0007c503          	lbu	a0,0(a5)
    800057ac:	b43ff0ef          	jal	800052ee <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800057b0:	0992                	slli	s3,s3,0x4
    800057b2:	397d                	addiw	s2,s2,-1
    800057b4:	fe0917e3          	bnez	s2,800057a2 <printf+0x232>
    800057b8:	6ba6                	ld	s7,72(sp)
    800057ba:	b589                	j	800055fc <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    800057bc:	f8843783          	ld	a5,-120(s0)
    800057c0:	00878713          	addi	a4,a5,8
    800057c4:	f8e43423          	sd	a4,-120(s0)
    800057c8:	0007b903          	ld	s2,0(a5)
    800057cc:	00090d63          	beqz	s2,800057e6 <printf+0x276>
      for(; *s; s++)
    800057d0:	00094503          	lbu	a0,0(s2)
    800057d4:	e20504e3          	beqz	a0,800055fc <printf+0x8c>
        consputc(*s);
    800057d8:	b17ff0ef          	jal	800052ee <consputc>
      for(; *s; s++)
    800057dc:	0905                	addi	s2,s2,1
    800057de:	00094503          	lbu	a0,0(s2)
    800057e2:	f97d                	bnez	a0,800057d8 <printf+0x268>
    800057e4:	bd21                	j	800055fc <printf+0x8c>
        s = "(null)";
    800057e6:	00002917          	auipc	s2,0x2
    800057ea:	07a90913          	addi	s2,s2,122 # 80007860 <etext+0x860>
      for(; *s; s++)
    800057ee:	02800513          	li	a0,40
    800057f2:	b7dd                	j	800057d8 <printf+0x268>
      consputc('%');
    800057f4:	02500513          	li	a0,37
    800057f8:	af7ff0ef          	jal	800052ee <consputc>
    800057fc:	b501                	j	800055fc <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800057fe:	f7843783          	ld	a5,-136(s0)
    80005802:	e385                	bnez	a5,80005822 <printf+0x2b2>
    80005804:	74e6                	ld	s1,120(sp)
    80005806:	7946                	ld	s2,112(sp)
    80005808:	79a6                	ld	s3,104(sp)
    8000580a:	6ae6                	ld	s5,88(sp)
    8000580c:	6b46                	ld	s6,80(sp)
    8000580e:	6c06                	ld	s8,64(sp)
    80005810:	7ce2                	ld	s9,56(sp)
    80005812:	7d42                	ld	s10,48(sp)
    80005814:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80005816:	4501                	li	a0,0
    80005818:	60aa                	ld	ra,136(sp)
    8000581a:	640a                	ld	s0,128(sp)
    8000581c:	7a06                	ld	s4,96(sp)
    8000581e:	6169                	addi	sp,sp,208
    80005820:	8082                	ret
    80005822:	74e6                	ld	s1,120(sp)
    80005824:	7946                	ld	s2,112(sp)
    80005826:	79a6                	ld	s3,104(sp)
    80005828:	6ae6                	ld	s5,88(sp)
    8000582a:	6b46                	ld	s6,80(sp)
    8000582c:	6c06                	ld	s8,64(sp)
    8000582e:	7ce2                	ld	s9,56(sp)
    80005830:	7d42                	ld	s10,48(sp)
    80005832:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005834:	0001e517          	auipc	a0,0x1e
    80005838:	3b450513          	addi	a0,a0,948 # 80023be8 <pr>
    8000583c:	3cc000ef          	jal	80005c08 <release>
    80005840:	bfd9                	j	80005816 <printf+0x2a6>

0000000080005842 <panic>:

void
panic(char *s)
{
    80005842:	1101                	addi	sp,sp,-32
    80005844:	ec06                	sd	ra,24(sp)
    80005846:	e822                	sd	s0,16(sp)
    80005848:	e426                	sd	s1,8(sp)
    8000584a:	1000                	addi	s0,sp,32
    8000584c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000584e:	0001e797          	auipc	a5,0x1e
    80005852:	3a07a923          	sw	zero,946(a5) # 80023c00 <pr+0x18>
  printf("panic: ");
    80005856:	00002517          	auipc	a0,0x2
    8000585a:	01250513          	addi	a0,a0,18 # 80007868 <etext+0x868>
    8000585e:	d13ff0ef          	jal	80005570 <printf>
  printf("%s\n", s);
    80005862:	85a6                	mv	a1,s1
    80005864:	00002517          	auipc	a0,0x2
    80005868:	00c50513          	addi	a0,a0,12 # 80007870 <etext+0x870>
    8000586c:	d05ff0ef          	jal	80005570 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005870:	4785                	li	a5,1
    80005872:	00005717          	auipc	a4,0x5
    80005876:	e0f72d23          	sw	a5,-486(a4) # 8000a68c <panicked>
  for(;;)
    8000587a:	a001                	j	8000587a <panic+0x38>

000000008000587c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000587c:	1101                	addi	sp,sp,-32
    8000587e:	ec06                	sd	ra,24(sp)
    80005880:	e822                	sd	s0,16(sp)
    80005882:	e426                	sd	s1,8(sp)
    80005884:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005886:	0001e497          	auipc	s1,0x1e
    8000588a:	36248493          	addi	s1,s1,866 # 80023be8 <pr>
    8000588e:	00002597          	auipc	a1,0x2
    80005892:	fea58593          	addi	a1,a1,-22 # 80007878 <etext+0x878>
    80005896:	8526                	mv	a0,s1
    80005898:	258000ef          	jal	80005af0 <initlock>
  pr.locking = 1;
    8000589c:	4785                	li	a5,1
    8000589e:	cc9c                	sw	a5,24(s1)
}
    800058a0:	60e2                	ld	ra,24(sp)
    800058a2:	6442                	ld	s0,16(sp)
    800058a4:	64a2                	ld	s1,8(sp)
    800058a6:	6105                	addi	sp,sp,32
    800058a8:	8082                	ret

00000000800058aa <uartinit>:

void uartstart();

void
uartinit(void)
{
    800058aa:	1141                	addi	sp,sp,-16
    800058ac:	e406                	sd	ra,8(sp)
    800058ae:	e022                	sd	s0,0(sp)
    800058b0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800058b2:	100007b7          	lui	a5,0x10000
    800058b6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800058ba:	10000737          	lui	a4,0x10000
    800058be:	f8000693          	li	a3,-128
    800058c2:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800058c6:	468d                	li	a3,3
    800058c8:	10000637          	lui	a2,0x10000
    800058cc:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800058d0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800058d4:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800058d8:	10000737          	lui	a4,0x10000
    800058dc:	461d                	li	a2,7
    800058de:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800058e2:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800058e6:	00002597          	auipc	a1,0x2
    800058ea:	f9a58593          	addi	a1,a1,-102 # 80007880 <etext+0x880>
    800058ee:	0001e517          	auipc	a0,0x1e
    800058f2:	31a50513          	addi	a0,a0,794 # 80023c08 <uart_tx_lock>
    800058f6:	1fa000ef          	jal	80005af0 <initlock>
}
    800058fa:	60a2                	ld	ra,8(sp)
    800058fc:	6402                	ld	s0,0(sp)
    800058fe:	0141                	addi	sp,sp,16
    80005900:	8082                	ret

0000000080005902 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005902:	1101                	addi	sp,sp,-32
    80005904:	ec06                	sd	ra,24(sp)
    80005906:	e822                	sd	s0,16(sp)
    80005908:	e426                	sd	s1,8(sp)
    8000590a:	1000                	addi	s0,sp,32
    8000590c:	84aa                	mv	s1,a0
  push_off();
    8000590e:	222000ef          	jal	80005b30 <push_off>

  if(panicked){
    80005912:	00005797          	auipc	a5,0x5
    80005916:	d7a7a783          	lw	a5,-646(a5) # 8000a68c <panicked>
    8000591a:	e795                	bnez	a5,80005946 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000591c:	10000737          	lui	a4,0x10000
    80005920:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005922:	00074783          	lbu	a5,0(a4)
    80005926:	0207f793          	andi	a5,a5,32
    8000592a:	dfe5                	beqz	a5,80005922 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000592c:	0ff4f513          	zext.b	a0,s1
    80005930:	100007b7          	lui	a5,0x10000
    80005934:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005938:	27c000ef          	jal	80005bb4 <pop_off>
}
    8000593c:	60e2                	ld	ra,24(sp)
    8000593e:	6442                	ld	s0,16(sp)
    80005940:	64a2                	ld	s1,8(sp)
    80005942:	6105                	addi	sp,sp,32
    80005944:	8082                	ret
    for(;;)
    80005946:	a001                	j	80005946 <uartputc_sync+0x44>

0000000080005948 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005948:	00005797          	auipc	a5,0x5
    8000594c:	d487b783          	ld	a5,-696(a5) # 8000a690 <uart_tx_r>
    80005950:	00005717          	auipc	a4,0x5
    80005954:	d4873703          	ld	a4,-696(a4) # 8000a698 <uart_tx_w>
    80005958:	08f70263          	beq	a4,a5,800059dc <uartstart+0x94>
{
    8000595c:	7139                	addi	sp,sp,-64
    8000595e:	fc06                	sd	ra,56(sp)
    80005960:	f822                	sd	s0,48(sp)
    80005962:	f426                	sd	s1,40(sp)
    80005964:	f04a                	sd	s2,32(sp)
    80005966:	ec4e                	sd	s3,24(sp)
    80005968:	e852                	sd	s4,16(sp)
    8000596a:	e456                	sd	s5,8(sp)
    8000596c:	e05a                	sd	s6,0(sp)
    8000596e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005970:	10000937          	lui	s2,0x10000
    80005974:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005976:	0001ea97          	auipc	s5,0x1e
    8000597a:	292a8a93          	addi	s5,s5,658 # 80023c08 <uart_tx_lock>
    uart_tx_r += 1;
    8000597e:	00005497          	auipc	s1,0x5
    80005982:	d1248493          	addi	s1,s1,-750 # 8000a690 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005986:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000598a:	00005997          	auipc	s3,0x5
    8000598e:	d0e98993          	addi	s3,s3,-754 # 8000a698 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005992:	00094703          	lbu	a4,0(s2)
    80005996:	02077713          	andi	a4,a4,32
    8000599a:	c71d                	beqz	a4,800059c8 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000599c:	01f7f713          	andi	a4,a5,31
    800059a0:	9756                	add	a4,a4,s5
    800059a2:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800059a6:	0785                	addi	a5,a5,1
    800059a8:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800059aa:	8526                	mv	a0,s1
    800059ac:	9d1fb0ef          	jal	8000137c <wakeup>
    WriteReg(THR, c);
    800059b0:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800059b4:	609c                	ld	a5,0(s1)
    800059b6:	0009b703          	ld	a4,0(s3)
    800059ba:	fcf71ce3          	bne	a4,a5,80005992 <uartstart+0x4a>
      ReadReg(ISR);
    800059be:	100007b7          	lui	a5,0x10000
    800059c2:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800059c4:	0007c783          	lbu	a5,0(a5)
  }
}
    800059c8:	70e2                	ld	ra,56(sp)
    800059ca:	7442                	ld	s0,48(sp)
    800059cc:	74a2                	ld	s1,40(sp)
    800059ce:	7902                	ld	s2,32(sp)
    800059d0:	69e2                	ld	s3,24(sp)
    800059d2:	6a42                	ld	s4,16(sp)
    800059d4:	6aa2                	ld	s5,8(sp)
    800059d6:	6b02                	ld	s6,0(sp)
    800059d8:	6121                	addi	sp,sp,64
    800059da:	8082                	ret
      ReadReg(ISR);
    800059dc:	100007b7          	lui	a5,0x10000
    800059e0:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800059e2:	0007c783          	lbu	a5,0(a5)
      return;
    800059e6:	8082                	ret

00000000800059e8 <uartputc>:
{
    800059e8:	7179                	addi	sp,sp,-48
    800059ea:	f406                	sd	ra,40(sp)
    800059ec:	f022                	sd	s0,32(sp)
    800059ee:	ec26                	sd	s1,24(sp)
    800059f0:	e84a                	sd	s2,16(sp)
    800059f2:	e44e                	sd	s3,8(sp)
    800059f4:	e052                	sd	s4,0(sp)
    800059f6:	1800                	addi	s0,sp,48
    800059f8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800059fa:	0001e517          	auipc	a0,0x1e
    800059fe:	20e50513          	addi	a0,a0,526 # 80023c08 <uart_tx_lock>
    80005a02:	16e000ef          	jal	80005b70 <acquire>
  if(panicked){
    80005a06:	00005797          	auipc	a5,0x5
    80005a0a:	c867a783          	lw	a5,-890(a5) # 8000a68c <panicked>
    80005a0e:	efbd                	bnez	a5,80005a8c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005a10:	00005717          	auipc	a4,0x5
    80005a14:	c8873703          	ld	a4,-888(a4) # 8000a698 <uart_tx_w>
    80005a18:	00005797          	auipc	a5,0x5
    80005a1c:	c787b783          	ld	a5,-904(a5) # 8000a690 <uart_tx_r>
    80005a20:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005a24:	0001e997          	auipc	s3,0x1e
    80005a28:	1e498993          	addi	s3,s3,484 # 80023c08 <uart_tx_lock>
    80005a2c:	00005497          	auipc	s1,0x5
    80005a30:	c6448493          	addi	s1,s1,-924 # 8000a690 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005a34:	00005917          	auipc	s2,0x5
    80005a38:	c6490913          	addi	s2,s2,-924 # 8000a698 <uart_tx_w>
    80005a3c:	00e79d63          	bne	a5,a4,80005a56 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005a40:	85ce                	mv	a1,s3
    80005a42:	8526                	mv	a0,s1
    80005a44:	8edfb0ef          	jal	80001330 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005a48:	00093703          	ld	a4,0(s2)
    80005a4c:	609c                	ld	a5,0(s1)
    80005a4e:	02078793          	addi	a5,a5,32
    80005a52:	fee787e3          	beq	a5,a4,80005a40 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005a56:	0001e497          	auipc	s1,0x1e
    80005a5a:	1b248493          	addi	s1,s1,434 # 80023c08 <uart_tx_lock>
    80005a5e:	01f77793          	andi	a5,a4,31
    80005a62:	97a6                	add	a5,a5,s1
    80005a64:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005a68:	0705                	addi	a4,a4,1
    80005a6a:	00005797          	auipc	a5,0x5
    80005a6e:	c2e7b723          	sd	a4,-978(a5) # 8000a698 <uart_tx_w>
  uartstart();
    80005a72:	ed7ff0ef          	jal	80005948 <uartstart>
  release(&uart_tx_lock);
    80005a76:	8526                	mv	a0,s1
    80005a78:	190000ef          	jal	80005c08 <release>
}
    80005a7c:	70a2                	ld	ra,40(sp)
    80005a7e:	7402                	ld	s0,32(sp)
    80005a80:	64e2                	ld	s1,24(sp)
    80005a82:	6942                	ld	s2,16(sp)
    80005a84:	69a2                	ld	s3,8(sp)
    80005a86:	6a02                	ld	s4,0(sp)
    80005a88:	6145                	addi	sp,sp,48
    80005a8a:	8082                	ret
    for(;;)
    80005a8c:	a001                	j	80005a8c <uartputc+0xa4>

0000000080005a8e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005a8e:	1141                	addi	sp,sp,-16
    80005a90:	e422                	sd	s0,8(sp)
    80005a92:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005a94:	100007b7          	lui	a5,0x10000
    80005a98:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80005a9a:	0007c783          	lbu	a5,0(a5)
    80005a9e:	8b85                	andi	a5,a5,1
    80005aa0:	cb81                	beqz	a5,80005ab0 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005aa2:	100007b7          	lui	a5,0x10000
    80005aa6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005aaa:	6422                	ld	s0,8(sp)
    80005aac:	0141                	addi	sp,sp,16
    80005aae:	8082                	ret
    return -1;
    80005ab0:	557d                	li	a0,-1
    80005ab2:	bfe5                	j	80005aaa <uartgetc+0x1c>

0000000080005ab4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005ab4:	1101                	addi	sp,sp,-32
    80005ab6:	ec06                	sd	ra,24(sp)
    80005ab8:	e822                	sd	s0,16(sp)
    80005aba:	e426                	sd	s1,8(sp)
    80005abc:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005abe:	54fd                	li	s1,-1
    80005ac0:	a019                	j	80005ac6 <uartintr+0x12>
      break;
    consoleintr(c);
    80005ac2:	85fff0ef          	jal	80005320 <consoleintr>
    int c = uartgetc();
    80005ac6:	fc9ff0ef          	jal	80005a8e <uartgetc>
    if(c == -1)
    80005aca:	fe951ce3          	bne	a0,s1,80005ac2 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80005ace:	0001e497          	auipc	s1,0x1e
    80005ad2:	13a48493          	addi	s1,s1,314 # 80023c08 <uart_tx_lock>
    80005ad6:	8526                	mv	a0,s1
    80005ad8:	098000ef          	jal	80005b70 <acquire>
  uartstart();
    80005adc:	e6dff0ef          	jal	80005948 <uartstart>
  release(&uart_tx_lock);
    80005ae0:	8526                	mv	a0,s1
    80005ae2:	126000ef          	jal	80005c08 <release>
}
    80005ae6:	60e2                	ld	ra,24(sp)
    80005ae8:	6442                	ld	s0,16(sp)
    80005aea:	64a2                	ld	s1,8(sp)
    80005aec:	6105                	addi	sp,sp,32
    80005aee:	8082                	ret

0000000080005af0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005af0:	1141                	addi	sp,sp,-16
    80005af2:	e422                	sd	s0,8(sp)
    80005af4:	0800                	addi	s0,sp,16
  lk->name = name;
    80005af6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005af8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005afc:	00053823          	sd	zero,16(a0)
}
    80005b00:	6422                	ld	s0,8(sp)
    80005b02:	0141                	addi	sp,sp,16
    80005b04:	8082                	ret

0000000080005b06 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005b06:	411c                	lw	a5,0(a0)
    80005b08:	e399                	bnez	a5,80005b0e <holding+0x8>
    80005b0a:	4501                	li	a0,0
  return r;
}
    80005b0c:	8082                	ret
{
    80005b0e:	1101                	addi	sp,sp,-32
    80005b10:	ec06                	sd	ra,24(sp)
    80005b12:	e822                	sd	s0,16(sp)
    80005b14:	e426                	sd	s1,8(sp)
    80005b16:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005b18:	6904                	ld	s1,16(a0)
    80005b1a:	a20fb0ef          	jal	80000d3a <mycpu>
    80005b1e:	40a48533          	sub	a0,s1,a0
    80005b22:	00153513          	seqz	a0,a0
}
    80005b26:	60e2                	ld	ra,24(sp)
    80005b28:	6442                	ld	s0,16(sp)
    80005b2a:	64a2                	ld	s1,8(sp)
    80005b2c:	6105                	addi	sp,sp,32
    80005b2e:	8082                	ret

0000000080005b30 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005b30:	1101                	addi	sp,sp,-32
    80005b32:	ec06                	sd	ra,24(sp)
    80005b34:	e822                	sd	s0,16(sp)
    80005b36:	e426                	sd	s1,8(sp)
    80005b38:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005b3a:	100024f3          	csrr	s1,sstatus
    80005b3e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005b42:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005b44:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005b48:	9f2fb0ef          	jal	80000d3a <mycpu>
    80005b4c:	5d3c                	lw	a5,120(a0)
    80005b4e:	cb99                	beqz	a5,80005b64 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005b50:	9eafb0ef          	jal	80000d3a <mycpu>
    80005b54:	5d3c                	lw	a5,120(a0)
    80005b56:	2785                	addiw	a5,a5,1
    80005b58:	dd3c                	sw	a5,120(a0)
}
    80005b5a:	60e2                	ld	ra,24(sp)
    80005b5c:	6442                	ld	s0,16(sp)
    80005b5e:	64a2                	ld	s1,8(sp)
    80005b60:	6105                	addi	sp,sp,32
    80005b62:	8082                	ret
    mycpu()->intena = old;
    80005b64:	9d6fb0ef          	jal	80000d3a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005b68:	8085                	srli	s1,s1,0x1
    80005b6a:	8885                	andi	s1,s1,1
    80005b6c:	dd64                	sw	s1,124(a0)
    80005b6e:	b7cd                	j	80005b50 <push_off+0x20>

0000000080005b70 <acquire>:
{
    80005b70:	1101                	addi	sp,sp,-32
    80005b72:	ec06                	sd	ra,24(sp)
    80005b74:	e822                	sd	s0,16(sp)
    80005b76:	e426                	sd	s1,8(sp)
    80005b78:	1000                	addi	s0,sp,32
    80005b7a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005b7c:	fb5ff0ef          	jal	80005b30 <push_off>
  if(holding(lk))
    80005b80:	8526                	mv	a0,s1
    80005b82:	f85ff0ef          	jal	80005b06 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005b86:	4705                	li	a4,1
  if(holding(lk))
    80005b88:	e105                	bnez	a0,80005ba8 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005b8a:	87ba                	mv	a5,a4
    80005b8c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005b90:	2781                	sext.w	a5,a5
    80005b92:	ffe5                	bnez	a5,80005b8a <acquire+0x1a>
  __sync_synchronize();
    80005b94:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005b98:	9a2fb0ef          	jal	80000d3a <mycpu>
    80005b9c:	e888                	sd	a0,16(s1)
}
    80005b9e:	60e2                	ld	ra,24(sp)
    80005ba0:	6442                	ld	s0,16(sp)
    80005ba2:	64a2                	ld	s1,8(sp)
    80005ba4:	6105                	addi	sp,sp,32
    80005ba6:	8082                	ret
    panic("acquire");
    80005ba8:	00002517          	auipc	a0,0x2
    80005bac:	ce050513          	addi	a0,a0,-800 # 80007888 <etext+0x888>
    80005bb0:	c93ff0ef          	jal	80005842 <panic>

0000000080005bb4 <pop_off>:

void
pop_off(void)
{
    80005bb4:	1141                	addi	sp,sp,-16
    80005bb6:	e406                	sd	ra,8(sp)
    80005bb8:	e022                	sd	s0,0(sp)
    80005bba:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005bbc:	97efb0ef          	jal	80000d3a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005bc0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005bc4:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005bc6:	e78d                	bnez	a5,80005bf0 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005bc8:	5d3c                	lw	a5,120(a0)
    80005bca:	02f05963          	blez	a5,80005bfc <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80005bce:	37fd                	addiw	a5,a5,-1
    80005bd0:	0007871b          	sext.w	a4,a5
    80005bd4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005bd6:	eb09                	bnez	a4,80005be8 <pop_off+0x34>
    80005bd8:	5d7c                	lw	a5,124(a0)
    80005bda:	c799                	beqz	a5,80005be8 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005bdc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005be0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005be4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005be8:	60a2                	ld	ra,8(sp)
    80005bea:	6402                	ld	s0,0(sp)
    80005bec:	0141                	addi	sp,sp,16
    80005bee:	8082                	ret
    panic("pop_off - interruptible");
    80005bf0:	00002517          	auipc	a0,0x2
    80005bf4:	ca050513          	addi	a0,a0,-864 # 80007890 <etext+0x890>
    80005bf8:	c4bff0ef          	jal	80005842 <panic>
    panic("pop_off");
    80005bfc:	00002517          	auipc	a0,0x2
    80005c00:	cac50513          	addi	a0,a0,-852 # 800078a8 <etext+0x8a8>
    80005c04:	c3fff0ef          	jal	80005842 <panic>

0000000080005c08 <release>:
{
    80005c08:	1101                	addi	sp,sp,-32
    80005c0a:	ec06                	sd	ra,24(sp)
    80005c0c:	e822                	sd	s0,16(sp)
    80005c0e:	e426                	sd	s1,8(sp)
    80005c10:	1000                	addi	s0,sp,32
    80005c12:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005c14:	ef3ff0ef          	jal	80005b06 <holding>
    80005c18:	c105                	beqz	a0,80005c38 <release+0x30>
  lk->cpu = 0;
    80005c1a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005c1e:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005c22:	0310000f          	fence	rw,w
    80005c26:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005c2a:	f8bff0ef          	jal	80005bb4 <pop_off>
}
    80005c2e:	60e2                	ld	ra,24(sp)
    80005c30:	6442                	ld	s0,16(sp)
    80005c32:	64a2                	ld	s1,8(sp)
    80005c34:	6105                	addi	sp,sp,32
    80005c36:	8082                	ret
    panic("release");
    80005c38:	00002517          	auipc	a0,0x2
    80005c3c:	c7850513          	addi	a0,a0,-904 # 800078b0 <etext+0x8b0>
    80005c40:	c03ff0ef          	jal	80005842 <panic>
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
