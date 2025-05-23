
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
    800000d6:	57e50513          	addi	a0,a0,1406 # 8000a650 <kmem>
    800000da:	217050ef          	jal	80005af0 <initlock>
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
    8000010a:	267050ef          	jal	80005b70 <acquire>
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
    8000035c:	77d010ef          	jal	800022d8 <binit>
    iinit();         // inode table
    80000360:	56e020ef          	jal	800028ce <iinit>
    fileinit();      // file table
    80000364:	31a030ef          	jal	8000367e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000368:	0b1040ef          	jal	80004c18 <virtio_disk_init>
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
    80000c94:	9e050513          	addi	a0,a0,-1568 # 8000a670 <pid_lock>
    80000c98:	659040ef          	jal	80005af0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000c9c:	00006597          	auipc	a1,0x6
    80000ca0:	51c58593          	addi	a1,a1,1308 # 800071b8 <etext+0x1b8>
    80000ca4:	0000a517          	auipc	a0,0xa
    80000ca8:	9e450513          	addi	a0,a0,-1564 # 8000a688 <wait_lock>
    80000cac:	645040ef          	jal	80005af0 <initlock>
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
    80000d60:	5d1040ef          	jal	80005b30 <push_off>
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
    80000dae:	2b5010ef          	jal	80002862 <fsinit>
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
    80000dd6:	59b040ef          	jal	80005b70 <acquire>
  pid = nextpid;
    80000dda:	00009797          	auipc	a5,0x9
    80000dde:	7da78793          	addi	a5,a5,2010 # 8000a5b4 <nextpid>
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
    80000f28:	b7c48493          	addi	s1,s1,-1156 # 8000aaa0 <proc>
    80000f2c:	0000f917          	auipc	s2,0xf
    80000f30:	77490913          	addi	s2,s2,1908 # 800106a0 <tickslock>
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
    80001014:	15c020ef          	jal	80003170 <namei>
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
    80001126:	5da020ef          	jal	80003700 <filedup>
    8000112a:	00a93023          	sd	a0,0(s2)
    8000112e:	b7f5                	j	8000111a <fork+0x9a>
  np->cwd = idup(p->cwd);
    80001130:	150ab503          	ld	a0,336(s5)
    80001134:	12d010ef          	jal	80002a60 <idup>
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
    80001158:	53448493          	addi	s1,s1,1332 # 8000a688 <wait_lock>
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
    8000125e:	0a9040ef          	jal	80005b06 <holding>
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
    80001470:	3d2040ef          	jal	80005842 <panic>
      fileclose(f);
    80001474:	2d2020ef          	jal	80003746 <fileclose>
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
    80001488:	6a5010ef          	jal	8000332c <begin_op>
  iput(p->cwd);
    8000148c:	1509b503          	ld	a0,336(s3)
    80001490:	788010ef          	jal	80002c18 <iput>
  end_op();
    80001494:	703010ef          	jal	80003396 <end_op>
  p->cwd = 0;
    80001498:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000149c:	00009497          	auipc	s1,0x9
    800014a0:	1ec48493          	addi	s1,s1,492 # 8000a688 <wait_lock>
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
    800014f2:	5b248493          	addi	s1,s1,1458 # 8000aaa0 <proc>
    800014f6:	0000f997          	auipc	s3,0xf
    800014fa:	1aa98993          	addi	s3,s3,426 # 800106a0 <tickslock>
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
    800015b6:	0d650513          	addi	a0,a0,214 # 8000a688 <wait_lock>
    800015ba:	5b6040ef          	jal	80005b70 <acquire>
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
    800015fa:	60e040ef          	jal	80005c08 <release>
          release(&wait_lock);
    800015fe:	00009517          	auipc	a0,0x9
    80001602:	08a50513          	addi	a0,a0,138 # 8000a688 <wait_lock>
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
    8000162e:	05e50513          	addi	a0,a0,94 # 8000a688 <wait_lock>
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
    80001676:	42e48493          	addi	s1,s1,1070 # 8000aaa0 <proc>
    8000167a:	b7e1                	j	80001642 <wait+0xb0>
      release(&wait_lock);
    8000167c:	00009517          	auipc	a0,0x9
    80001680:	00c50513          	addi	a0,a0,12 # 8000a688 <wait_lock>
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
    80001842:	e6250513          	addi	a0,a0,-414 # 800106a0 <tickslock>
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
    8000192a:	d7a48493          	addi	s1,s1,-646 # 800106a0 <tickslock>
    8000192e:	8526                	mv	a0,s1
    80001930:	240040ef          	jal	80005b70 <acquire>
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
    80001b88:	4bb030ef          	jal	80005842 <panic>

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
    80001ca0:	4765                	li	a4,25
    80001ca2:	04f76f63          	bltu	a4,a5,80001d00 <syscall+0x82>
    80001ca6:	00391713          	slli	a4,s2,0x3
    80001caa:	00006797          	auipc	a5,0x6
    80001cae:	c7e78793          	addi	a5,a5,-898 # 80007928 <syscalls>
    80001cb2:	97ba                	add	a5,a5,a4
    80001cb4:	639c                	ld	a5,0(a5)
    80001cb6:	c7a9                	beqz	a5,80001d00 <syscall+0x82>
    // Save the system call number
    p->trapframe->a0 = syscalls[num]();
    80001cb8:	9782                	jalr	a5
    80001cba:	06a9b823          	sd	a0,112(s3)
    
    // Increment the count for this system call
    syscall_counts[num]++;
    80001cbe:	00391713          	slli	a4,s2,0x3
    80001cc2:	0000f797          	auipc	a5,0xf
    80001cc6:	9f678793          	addi	a5,a5,-1546 # 800106b8 <syscall_counts>
    80001cca:	97ba                	add	a5,a5,a4
    80001ccc:	6398                	ld	a4,0(a5)
    80001cce:	0705                	addi	a4,a4,1
    80001cd0:	e398                	sd	a4,0(a5)
    
    // If process is being traced and the mask includes this syscall
    if(p->trace_mask & (1 << num)) {
    80001cd2:	1684a783          	lw	a5,360(s1)
    80001cd6:	4127d7bb          	sraw	a5,a5,s2
    80001cda:	8b85                	andi	a5,a5,1
    80001cdc:	cf9d                	beqz	a5,80001d1a <syscall+0x9c>
      printf("%d: syscall %s -> %ld\n", p->pid, syscall_names[num], p->trapframe->a0);
    80001cde:	6cb8                	ld	a4,88(s1)
    80001ce0:	090e                	slli	s2,s2,0x3
    80001ce2:	00006797          	auipc	a5,0x6
    80001ce6:	c4678793          	addi	a5,a5,-954 # 80007928 <syscalls>
    80001cea:	97ca                	add	a5,a5,s2
    80001cec:	7b34                	ld	a3,112(a4)
    80001cee:	6ff0                	ld	a2,216(a5)
    80001cf0:	588c                	lw	a1,48(s1)
    80001cf2:	00005517          	auipc	a0,0x5
    80001cf6:	6ce50513          	addi	a0,a0,1742 # 800073c0 <etext+0x3c0>
    80001cfa:	077030ef          	jal	80005570 <printf>
    80001cfe:	a831                	j	80001d1a <syscall+0x9c>
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001d00:	86ca                	mv	a3,s2
    80001d02:	15848613          	addi	a2,s1,344
    80001d06:	588c                	lw	a1,48(s1)
    80001d08:	00005517          	auipc	a0,0x5
    80001d0c:	6d050513          	addi	a0,a0,1744 # 800073d8 <etext+0x3d8>
    80001d10:	061030ef          	jal	80005570 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d14:	6cbc                	ld	a5,88(s1)
    80001d16:	577d                	li	a4,-1
    80001d18:	fbb8                	sd	a4,112(a5)
  }
}
    80001d1a:	70a2                	ld	ra,40(sp)
    80001d1c:	7402                	ld	s0,32(sp)
    80001d1e:	64e2                	ld	s1,24(sp)
    80001d20:	6942                	ld	s2,16(sp)
    80001d22:	69a2                	ld	s3,8(sp)
    80001d24:	6145                	addi	sp,sp,48
    80001d26:	8082                	ret

0000000080001d28 <read_string>:


///////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
// Read null-terminated string from user space
int read_string(struct proc *p, uint64 addr, char *buf, int max) {
    80001d28:	715d                	addi	sp,sp,-80
    80001d2a:	e486                	sd	ra,72(sp)
    80001d2c:	e0a2                	sd	s0,64(sp)
    80001d2e:	f84a                	sd	s2,48(sp)
    80001d30:	0880                	addi	s0,sp,80
  
  if(addr >= p->sz)
    80001d32:	653c                	ld	a5,72(a0)
    80001d34:	08f5f563          	bgeu	a1,a5,80001dbe <read_string+0x96>
    80001d38:	f052                	sd	s4,32(sp)
    80001d3a:	ec56                	sd	s5,24(sp)
    80001d3c:	e45e                	sd	s7,8(sp)
    80001d3e:	8aaa                	mv	s5,a0
    80001d40:	8bb2                	mv	s7,a2
    80001d42:	8a36                	mv	s4,a3
  {
    return -1; }
  int n = 0;
  while(n < max) {
    80001d44:	06d05763          	blez	a3,80001db2 <read_string+0x8a>
    80001d48:	fc26                	sd	s1,56(sp)
    80001d4a:	f44e                	sd	s3,40(sp)
    80001d4c:	e85a                	sd	s6,16(sp)
    80001d4e:	84b2                	mv	s1,a2
  int n = 0;
    80001d50:	4901                	li	s2,0
    if(copyin(p->pagetable, buf + n, addr + n, 1) == -1) {
    80001d52:	40c589b3          	sub	s3,a1,a2
    80001d56:	5b7d                	li	s6,-1
    80001d58:	4685                	li	a3,1
    80001d5a:	00998633          	add	a2,s3,s1
    80001d5e:	85a6                	mv	a1,s1
    80001d60:	050ab503          	ld	a0,80(s5)
    80001d64:	d3bfe0ef          	jal	80000a9e <copyin>
    80001d68:	03650463          	beq	a0,s6,80001d90 <read_string+0x68>
      break;
    }
    if(buf[n] == '\0'){
    80001d6c:	0004c783          	lbu	a5,0(s1)
    80001d70:	c385                	beqz	a5,80001d90 <read_string+0x68>
      break;
    }
    n++;
    80001d72:	2905                	addiw	s2,s2,1
  while(n < max) {
    80001d74:	0485                	addi	s1,s1,1
    80001d76:	ff2a11e3          	bne	s4,s2,80001d58 <read_string+0x30>
    80001d7a:	8952                	mv	s2,s4
    80001d7c:	74e2                	ld	s1,56(sp)
    80001d7e:	79a2                	ld	s3,40(sp)
    80001d80:	6b42                	ld	s6,16(sp)
  }
  if(n < max){
    buf[n] = '\0';
  } else {
    buf[max-1] = '\0';
    80001d82:	9bd2                	add	s7,s7,s4
    80001d84:	fe0b8fa3          	sb	zero,-1(s7)
    80001d88:	7a02                	ld	s4,32(sp)
    80001d8a:	6ae2                	ld	s5,24(sp)
    80001d8c:	6ba2                	ld	s7,8(sp)
    80001d8e:	a821                	j	80001da6 <read_string+0x7e>
  if(n < max){
    80001d90:	03495363          	bge	s2,s4,80001db6 <read_string+0x8e>
    buf[n] = '\0';
    80001d94:	9bca                	add	s7,s7,s2
    80001d96:	000b8023          	sb	zero,0(s7)
    80001d9a:	74e2                	ld	s1,56(sp)
    80001d9c:	79a2                	ld	s3,40(sp)
    80001d9e:	7a02                	ld	s4,32(sp)
    80001da0:	6ae2                	ld	s5,24(sp)
    80001da2:	6b42                	ld	s6,16(sp)
    80001da4:	6ba2                	ld	s7,8(sp)
  } 
  return n;
}
    80001da6:	854a                	mv	a0,s2
    80001da8:	60a6                	ld	ra,72(sp)
    80001daa:	6406                	ld	s0,64(sp)
    80001dac:	7942                	ld	s2,48(sp)
    80001dae:	6161                	addi	sp,sp,80
    80001db0:	8082                	ret
  int n = 0;
    80001db2:	4901                	li	s2,0
    80001db4:	b7f9                	j	80001d82 <read_string+0x5a>
    80001db6:	74e2                	ld	s1,56(sp)
    80001db8:	79a2                	ld	s3,40(sp)
    80001dba:	6b42                	ld	s6,16(sp)
    80001dbc:	b7d9                	j	80001d82 <read_string+0x5a>
    return -1; }
    80001dbe:	597d                	li	s2,-1
    80001dc0:	b7dd                	j	80001da6 <read_string+0x7e>

0000000080001dc2 <read_memory>:

////////////////////////////////////////////////////////////////////////////////////////////////////
// Read arbitrary memory from user space
int read_memory(struct proc *p, uint64 addr, char *buf, int n) {
    80001dc2:	87ae                	mv	a5,a1

  if(addr >= p->sz || addr + n > p->sz)
    80001dc4:	6538                	ld	a4,72(a0)
    80001dc6:	02e5fa63          	bgeu	a1,a4,80001dfa <read_memory+0x38>
int read_memory(struct proc *p, uint64 addr, char *buf, int n) {
    80001dca:	1101                	addi	sp,sp,-32
    80001dcc:	ec06                	sd	ra,24(sp)
    80001dce:	e822                	sd	s0,16(sp)
    80001dd0:	e426                	sd	s1,8(sp)
    80001dd2:	1000                	addi	s0,sp,32
    80001dd4:	85b2                	mv	a1,a2
    80001dd6:	84b6                	mv	s1,a3
  if(addr >= p->sz || addr + n > p->sz)
    80001dd8:	96be                	add	a3,a3,a5
    80001dda:	02d76263          	bltu	a4,a3,80001dfe <read_memory+0x3c>
    return -1;

  if(copyin(p->pagetable, buf, addr, n) == -1)
    80001dde:	86a6                	mv	a3,s1
    80001de0:	863e                	mv	a2,a5
    80001de2:	6928                	ld	a0,80(a0)
    80001de4:	cbbfe0ef          	jal	80000a9e <copyin>
    80001de8:	57fd                	li	a5,-1
    80001dea:	00f50363          	beq	a0,a5,80001df0 <read_memory+0x2e>
    return -1;

  return n;
    80001dee:	8526                	mv	a0,s1
}
    80001df0:	60e2                	ld	ra,24(sp)
    80001df2:	6442                	ld	s0,16(sp)
    80001df4:	64a2                	ld	s1,8(sp)
    80001df6:	6105                	addi	sp,sp,32
    80001df8:	8082                	ret
    return -1;
    80001dfa:	557d                	li	a0,-1
}
    80001dfc:	8082                	ret
    return -1;
    80001dfe:	557d                	li	a0,-1
    80001e00:	bfc5                	j	80001df0 <read_memory+0x2e>

0000000080001e02 <print_syscall>:

//////////////////////////////////////////////////////////////


// Print system call details (enhanced for open's mode)
void print_syscall(struct proc *p, int num, uint64 ret) {
    80001e02:	7159                	addi	sp,sp,-112
    80001e04:	f486                	sd	ra,104(sp)
    80001e06:	f0a2                	sd	s0,96(sp)
    80001e08:	eca6                	sd	s1,88(sp)
    80001e0a:	e8ca                	sd	s2,80(sp)
    80001e0c:	e4ce                	sd	s3,72(sp)
    80001e0e:	1880                	addi	s0,sp,112
    80001e10:	84aa                	mv	s1,a0
    80001e12:	892e                	mv	s2,a1
    80001e14:	89b2                	mv	s3,a2
    printf("%d: %s(", p->pid, syscall_names[num]);
    80001e16:	00359713          	slli	a4,a1,0x3
    80001e1a:	00006797          	auipc	a5,0x6
    80001e1e:	b0e78793          	addi	a5,a5,-1266 # 80007928 <syscalls>
    80001e22:	97ba                	add	a5,a5,a4
    80001e24:	6ff0                	ld	a2,216(a5)
    80001e26:	590c                	lw	a1,48(a0)
    80001e28:	00005517          	auipc	a0,0x5
    80001e2c:	5d050513          	addi	a0,a0,1488 # 800073f8 <etext+0x3f8>
    80001e30:	740030ef          	jal	80005570 <printf>
    switch (num) {
    80001e34:	47bd                	li	a5,15
    80001e36:	08f90063          	beq	s2,a5,80001eb6 <print_syscall+0xb4>
    80001e3a:	47c1                	li	a5,16
    80001e3c:	0ef90963          	beq	s2,a5,80001f2e <print_syscall+0x12c>
    80001e40:	4795                	li	a5,5
    80001e42:	0af91663          	bne	s2,a5,80001eee <print_syscall+0xec>
        }
        printf(", %ld, 0%lo", p->trapframe->a1, p->trapframe->a2); // CHANGED: Added mode
        break;
    }
    case SYS_read: {
        printf("%ld, 0x%lx, %ld", p->trapframe->a0, p->trapframe->a1, p->trapframe->a2);
    80001e46:	6cbc                	ld	a5,88(s1)
    80001e48:	63d4                	ld	a3,128(a5)
    80001e4a:	7fb0                	ld	a2,120(a5)
    80001e4c:	7bac                	ld	a1,112(a5)
    80001e4e:	00005517          	auipc	a0,0x5
    80001e52:	5d250513          	addi	a0,a0,1490 # 80007420 <etext+0x420>
    80001e56:	71a030ef          	jal	80005570 <printf>
        if ((int)ret > 0 && (int)ret <= 32) {
    80001e5a:	fff9879b          	addiw	a5,s3,-1
    80001e5e:	477d                	li	a4,31
    80001e60:	08f76763          	bltu	a4,a5,80001eee <print_syscall+0xec>
            char buf[33];
            if (read_memory(p, p->trapframe->a1, buf, ret) >= 0) {
    80001e64:	6cbc                	ld	a5,88(s1)
    80001e66:	0009869b          	sext.w	a3,s3
    80001e6a:	f9040613          	addi	a2,s0,-112
    80001e6e:	7fac                	ld	a1,120(a5)
    80001e70:	8526                	mv	a0,s1
    80001e72:	f51ff0ef          	jal	80001dc2 <read_memory>
    80001e76:	0a054363          	bltz	a0,80001f1c <print_syscall+0x11a>
                buf[ret] = '\0';
    80001e7a:	fd098793          	addi	a5,s3,-48
    80001e7e:	97a2                	add	a5,a5,s0
    80001e80:	fc078023          	sb	zero,-64(a5)
                int is_string = 1;
                for (int i = 0; i < ret; i++) {
    80001e84:	f9040713          	addi	a4,s0,-112
    80001e88:	00e98633          	add	a2,s3,a4
                    if (buf[i] < 32 || buf[i] > 126) {
    80001e8c:	05e00693          	li	a3,94
    80001e90:	00074783          	lbu	a5,0(a4)
    80001e94:	3781                	addiw	a5,a5,-32
    80001e96:	0ff7f793          	zext.b	a5,a5
    80001e9a:	10f6ee63          	bltu	a3,a5,80001fb6 <print_syscall+0x1b4>
                for (int i = 0; i < ret; i++) {
    80001e9e:	0705                	addi	a4,a4,1
    80001ea0:	fec718e3          	bne	a4,a2,80001e90 <print_syscall+0x8e>
                        is_string = 0;
                        break;
                    }
                }
                if (is_string) printf(" → \"%s\"", buf);
    80001ea4:	f9040593          	addi	a1,s0,-112
    80001ea8:	00005517          	auipc	a0,0x5
    80001eac:	5c050513          	addi	a0,a0,1472 # 80007468 <etext+0x468>
    80001eb0:	6c0030ef          	jal	80005570 <printf>
    80001eb4:	a82d                	j	80001eee <print_syscall+0xec>
        if (read_string(p, p->trapframe->a0, filename, sizeof(filename)) >= 0) {
    80001eb6:	6cbc                	ld	a5,88(s1)
    80001eb8:	04000693          	li	a3,64
    80001ebc:	f9040613          	addi	a2,s0,-112
    80001ec0:	7bac                	ld	a1,112(a5)
    80001ec2:	8526                	mv	a0,s1
    80001ec4:	e65ff0ef          	jal	80001d28 <read_string>
    80001ec8:	04054163          	bltz	a0,80001f0a <print_syscall+0x108>
            printf("\"%s\"", filename);
    80001ecc:	f9040593          	addi	a1,s0,-112
    80001ed0:	00005517          	auipc	a0,0x5
    80001ed4:	53050513          	addi	a0,a0,1328 # 80007400 <etext+0x400>
    80001ed8:	698030ef          	jal	80005570 <printf>
        printf(", %ld, 0%lo", p->trapframe->a1, p->trapframe->a2); // CHANGED: Added mode
    80001edc:	6cbc                	ld	a5,88(s1)
    80001ede:	63d0                	ld	a2,128(a5)
    80001ee0:	7fac                	ld	a1,120(a5)
    80001ee2:	00005517          	auipc	a0,0x5
    80001ee6:	52e50513          	addi	a0,a0,1326 # 80007410 <etext+0x410>
    80001eea:	686030ef          	jal	80005570 <printf>
        break;
    }
    default:
        break;
    }
    printf(") = %ld\n", ret); // CHANGED: Aligned with strace format
    80001eee:	85ce                	mv	a1,s3
    80001ef0:	00005517          	auipc	a0,0x5
    80001ef4:	56850513          	addi	a0,a0,1384 # 80007458 <etext+0x458>
    80001ef8:	678030ef          	jal	80005570 <printf>
}
    80001efc:	70a6                	ld	ra,104(sp)
    80001efe:	7406                	ld	s0,96(sp)
    80001f00:	64e6                	ld	s1,88(sp)
    80001f02:	6946                	ld	s2,80(sp)
    80001f04:	69a6                	ld	s3,72(sp)
    80001f06:	6165                	addi	sp,sp,112
    80001f08:	8082                	ret
            printf("0x%lx", p->trapframe->a0);
    80001f0a:	6cbc                	ld	a5,88(s1)
    80001f0c:	7bac                	ld	a1,112(a5)
    80001f0e:	00005517          	auipc	a0,0x5
    80001f12:	4fa50513          	addi	a0,a0,1274 # 80007408 <etext+0x408>
    80001f16:	65a030ef          	jal	80005570 <printf>
    80001f1a:	b7c9                	j	80001edc <print_syscall+0xda>
                printf(" → 0x%lx", p->trapframe->a1); // CHANGED: Added fallback
    80001f1c:	6cbc                	ld	a5,88(s1)
    80001f1e:	7fac                	ld	a1,120(a5)
    80001f20:	00005517          	auipc	a0,0x5
    80001f24:	51050513          	addi	a0,a0,1296 # 80007430 <etext+0x430>
    80001f28:	648030ef          	jal	80005570 <printf>
    80001f2c:	b7c9                	j	80001eee <print_syscall+0xec>
        printf("%ld, ", p->trapframe->a0);
    80001f2e:	6cbc                	ld	a5,88(s1)
    80001f30:	7bac                	ld	a1,112(a5)
    80001f32:	00005517          	auipc	a0,0x5
    80001f36:	50e50513          	addi	a0,a0,1294 # 80007440 <etext+0x440>
    80001f3a:	636030ef          	jal	80005570 <printf>
        int n = p->trapframe->a2 > 32 ? 32 : p->trapframe->a2;
    80001f3e:	6cbc                	ld	a5,88(s1)
    80001f40:	63d4                	ld	a3,128(a5)
    80001f42:	02000713          	li	a4,32
    80001f46:	00d77463          	bgeu	a4,a3,80001f4e <print_syscall+0x14c>
    80001f4a:	02000693          	li	a3,32
    80001f4e:	0006891b          	sext.w	s2,a3
        if (read_memory(p, p->trapframe->a1, buf, n) >= 0) {
    80001f52:	86ca                	mv	a3,s2
    80001f54:	f9040613          	addi	a2,s0,-112
    80001f58:	7fac                	ld	a1,120(a5)
    80001f5a:	8526                	mv	a0,s1
    80001f5c:	e67ff0ef          	jal	80001dc2 <read_memory>
    80001f60:	02054a63          	bltz	a0,80001f94 <print_syscall+0x192>
            buf[n] = '\0';
    80001f64:	fd090793          	addi	a5,s2,-48
    80001f68:	97a2                	add	a5,a5,s0
    80001f6a:	fc078023          	sb	zero,-64(a5)
            printf("\"%s\"", buf);
    80001f6e:	f9040593          	addi	a1,s0,-112
    80001f72:	00005517          	auipc	a0,0x5
    80001f76:	48e50513          	addi	a0,a0,1166 # 80007400 <etext+0x400>
    80001f7a:	5f6030ef          	jal	80005570 <printf>
            if (n < p->trapframe->a2) printf("...");
    80001f7e:	6cbc                	ld	a5,88(s1)
    80001f80:	63dc                	ld	a5,128(a5)
    80001f82:	02f97163          	bgeu	s2,a5,80001fa4 <print_syscall+0x1a2>
    80001f86:	00005517          	auipc	a0,0x5
    80001f8a:	4c250513          	addi	a0,a0,1218 # 80007448 <etext+0x448>
    80001f8e:	5e2030ef          	jal	80005570 <printf>
    80001f92:	a809                	j	80001fa4 <print_syscall+0x1a2>
            printf("0x%lx", p->trapframe->a1);
    80001f94:	6cbc                	ld	a5,88(s1)
    80001f96:	7fac                	ld	a1,120(a5)
    80001f98:	00005517          	auipc	a0,0x5
    80001f9c:	47050513          	addi	a0,a0,1136 # 80007408 <etext+0x408>
    80001fa0:	5d0030ef          	jal	80005570 <printf>
        printf(", %ld", p->trapframe->a2);
    80001fa4:	6cbc                	ld	a5,88(s1)
    80001fa6:	63cc                	ld	a1,128(a5)
    80001fa8:	00005517          	auipc	a0,0x5
    80001fac:	4a850513          	addi	a0,a0,1192 # 80007450 <etext+0x450>
    80001fb0:	5c0030ef          	jal	80005570 <printf>
        break;
    80001fb4:	bf2d                	j	80001eee <print_syscall+0xec>
                else printf(" → 0x%lx", p->trapframe->a1); // CHANGED: Added fallback
    80001fb6:	6cbc                	ld	a5,88(s1)
    80001fb8:	7fac                	ld	a1,120(a5)
    80001fba:	00005517          	auipc	a0,0x5
    80001fbe:	47650513          	addi	a0,a0,1142 # 80007430 <etext+0x430>
    80001fc2:	5ae030ef          	jal	80005570 <printf>
    80001fc6:	b725                	j	80001eee <print_syscall+0xec>

0000000080001fc8 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001fc8:	1101                	addi	sp,sp,-32
    80001fca:	ec06                	sd	ra,24(sp)
    80001fcc:	e822                	sd	s0,16(sp)
    80001fce:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001fd0:	fec40593          	addi	a1,s0,-20
    80001fd4:	4501                	li	a0,0
    80001fd6:	c41ff0ef          	jal	80001c16 <argint>
  exit(n);
    80001fda:	fec42503          	lw	a0,-20(s0)
    80001fde:	c5eff0ef          	jal	8000143c <exit>
  return 0;  // not reached
}
    80001fe2:	4501                	li	a0,0
    80001fe4:	60e2                	ld	ra,24(sp)
    80001fe6:	6442                	ld	s0,16(sp)
    80001fe8:	6105                	addi	sp,sp,32
    80001fea:	8082                	ret

0000000080001fec <sys_getpid>:

uint64
sys_getpid(void)
{
    80001fec:	1141                	addi	sp,sp,-16
    80001fee:	e406                	sd	ra,8(sp)
    80001ff0:	e022                	sd	s0,0(sp)
    80001ff2:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001ff4:	d63fe0ef          	jal	80000d56 <myproc>
}
    80001ff8:	5908                	lw	a0,48(a0)
    80001ffa:	60a2                	ld	ra,8(sp)
    80001ffc:	6402                	ld	s0,0(sp)
    80001ffe:	0141                	addi	sp,sp,16
    80002000:	8082                	ret

0000000080002002 <sys_fork>:

uint64
sys_fork(void)
{
    80002002:	1141                	addi	sp,sp,-16
    80002004:	e406                	sd	ra,8(sp)
    80002006:	e022                	sd	s0,0(sp)
    80002008:	0800                	addi	s0,sp,16
  return fork();
    8000200a:	876ff0ef          	jal	80001080 <fork>
}
    8000200e:	60a2                	ld	ra,8(sp)
    80002010:	6402                	ld	s0,0(sp)
    80002012:	0141                	addi	sp,sp,16
    80002014:	8082                	ret

0000000080002016 <sys_wait>:

uint64
sys_wait(void)
{
    80002016:	1101                	addi	sp,sp,-32
    80002018:	ec06                	sd	ra,24(sp)
    8000201a:	e822                	sd	s0,16(sp)
    8000201c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000201e:	fe840593          	addi	a1,s0,-24
    80002022:	4501                	li	a0,0
    80002024:	c0fff0ef          	jal	80001c32 <argaddr>
  return wait(p);
    80002028:	fe843503          	ld	a0,-24(s0)
    8000202c:	d66ff0ef          	jal	80001592 <wait>
}
    80002030:	60e2                	ld	ra,24(sp)
    80002032:	6442                	ld	s0,16(sp)
    80002034:	6105                	addi	sp,sp,32
    80002036:	8082                	ret

0000000080002038 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002038:	7179                	addi	sp,sp,-48
    8000203a:	f406                	sd	ra,40(sp)
    8000203c:	f022                	sd	s0,32(sp)
    8000203e:	ec26                	sd	s1,24(sp)
    80002040:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002042:	fdc40593          	addi	a1,s0,-36
    80002046:	4501                	li	a0,0
    80002048:	bcfff0ef          	jal	80001c16 <argint>
  addr = myproc()->sz;
    8000204c:	d0bfe0ef          	jal	80000d56 <myproc>
    80002050:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002052:	fdc42503          	lw	a0,-36(s0)
    80002056:	fdbfe0ef          	jal	80001030 <growproc>
    8000205a:	00054863          	bltz	a0,8000206a <sys_sbrk+0x32>
    return -1;
  return addr;
}
    8000205e:	8526                	mv	a0,s1
    80002060:	70a2                	ld	ra,40(sp)
    80002062:	7402                	ld	s0,32(sp)
    80002064:	64e2                	ld	s1,24(sp)
    80002066:	6145                	addi	sp,sp,48
    80002068:	8082                	ret
    return -1;
    8000206a:	54fd                	li	s1,-1
    8000206c:	bfcd                	j	8000205e <sys_sbrk+0x26>

000000008000206e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000206e:	7139                	addi	sp,sp,-64
    80002070:	fc06                	sd	ra,56(sp)
    80002072:	f822                	sd	s0,48(sp)
    80002074:	f04a                	sd	s2,32(sp)
    80002076:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002078:	fcc40593          	addi	a1,s0,-52
    8000207c:	4501                	li	a0,0
    8000207e:	b99ff0ef          	jal	80001c16 <argint>
  if(n < 0)
    80002082:	fcc42783          	lw	a5,-52(s0)
    80002086:	0607c763          	bltz	a5,800020f4 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    8000208a:	0000e517          	auipc	a0,0xe
    8000208e:	61650513          	addi	a0,a0,1558 # 800106a0 <tickslock>
    80002092:	2df030ef          	jal	80005b70 <acquire>
  ticks0 = ticks;
    80002096:	00008917          	auipc	s2,0x8
    8000209a:	5a292903          	lw	s2,1442(s2) # 8000a638 <ticks>
  while(ticks - ticks0 < n){
    8000209e:	fcc42783          	lw	a5,-52(s0)
    800020a2:	cf8d                	beqz	a5,800020dc <sys_sleep+0x6e>
    800020a4:	f426                	sd	s1,40(sp)
    800020a6:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800020a8:	0000e997          	auipc	s3,0xe
    800020ac:	5f898993          	addi	s3,s3,1528 # 800106a0 <tickslock>
    800020b0:	00008497          	auipc	s1,0x8
    800020b4:	58848493          	addi	s1,s1,1416 # 8000a638 <ticks>
    if(killed(myproc())){
    800020b8:	c9ffe0ef          	jal	80000d56 <myproc>
    800020bc:	cacff0ef          	jal	80001568 <killed>
    800020c0:	ed0d                	bnez	a0,800020fa <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    800020c2:	85ce                	mv	a1,s3
    800020c4:	8526                	mv	a0,s1
    800020c6:	a6aff0ef          	jal	80001330 <sleep>
  while(ticks - ticks0 < n){
    800020ca:	409c                	lw	a5,0(s1)
    800020cc:	412787bb          	subw	a5,a5,s2
    800020d0:	fcc42703          	lw	a4,-52(s0)
    800020d4:	fee7e2e3          	bltu	a5,a4,800020b8 <sys_sleep+0x4a>
    800020d8:	74a2                	ld	s1,40(sp)
    800020da:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800020dc:	0000e517          	auipc	a0,0xe
    800020e0:	5c450513          	addi	a0,a0,1476 # 800106a0 <tickslock>
    800020e4:	325030ef          	jal	80005c08 <release>
  return 0;
    800020e8:	4501                	li	a0,0
}
    800020ea:	70e2                	ld	ra,56(sp)
    800020ec:	7442                	ld	s0,48(sp)
    800020ee:	7902                	ld	s2,32(sp)
    800020f0:	6121                	addi	sp,sp,64
    800020f2:	8082                	ret
    n = 0;
    800020f4:	fc042623          	sw	zero,-52(s0)
    800020f8:	bf49                	j	8000208a <sys_sleep+0x1c>
      release(&tickslock);
    800020fa:	0000e517          	auipc	a0,0xe
    800020fe:	5a650513          	addi	a0,a0,1446 # 800106a0 <tickslock>
    80002102:	307030ef          	jal	80005c08 <release>
      return -1;
    80002106:	557d                	li	a0,-1
    80002108:	74a2                	ld	s1,40(sp)
    8000210a:	69e2                	ld	s3,24(sp)
    8000210c:	bff9                	j	800020ea <sys_sleep+0x7c>

000000008000210e <sys_kill>:

uint64
sys_kill(void)
{
    8000210e:	1101                	addi	sp,sp,-32
    80002110:	ec06                	sd	ra,24(sp)
    80002112:	e822                	sd	s0,16(sp)
    80002114:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002116:	fec40593          	addi	a1,s0,-20
    8000211a:	4501                	li	a0,0
    8000211c:	afbff0ef          	jal	80001c16 <argint>
  return kill(pid);
    80002120:	fec42503          	lw	a0,-20(s0)
    80002124:	bbaff0ef          	jal	800014de <kill>
}
    80002128:	60e2                	ld	ra,24(sp)
    8000212a:	6442                	ld	s0,16(sp)
    8000212c:	6105                	addi	sp,sp,32
    8000212e:	8082                	ret

0000000080002130 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002130:	1101                	addi	sp,sp,-32
    80002132:	ec06                	sd	ra,24(sp)
    80002134:	e822                	sd	s0,16(sp)
    80002136:	e426                	sd	s1,8(sp)
    80002138:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000213a:	0000e517          	auipc	a0,0xe
    8000213e:	56650513          	addi	a0,a0,1382 # 800106a0 <tickslock>
    80002142:	22f030ef          	jal	80005b70 <acquire>
  xticks = ticks;
    80002146:	00008497          	auipc	s1,0x8
    8000214a:	4f24a483          	lw	s1,1266(s1) # 8000a638 <ticks>
  release(&tickslock);
    8000214e:	0000e517          	auipc	a0,0xe
    80002152:	55250513          	addi	a0,a0,1362 # 800106a0 <tickslock>
    80002156:	2b3030ef          	jal	80005c08 <release>
  return xticks;
}
    8000215a:	02049513          	slli	a0,s1,0x20
    8000215e:	9101                	srli	a0,a0,0x20
    80002160:	60e2                	ld	ra,24(sp)
    80002162:	6442                	ld	s0,16(sp)
    80002164:	64a2                	ld	s1,8(sp)
    80002166:	6105                	addi	sp,sp,32
    80002168:	8082                	ret

000000008000216a <sys_trace>:

extern uint64 syscall_counts[];
extern char *syscall_names[];


uint64 sys_trace(void){
    8000216a:	1101                	addi	sp,sp,-32
    8000216c:	ec06                	sd	ra,24(sp)
    8000216e:	e822                	sd	s0,16(sp)
    80002170:	1000                	addi	s0,sp,32
  int mask;
  
  argint(0, &mask);
    80002172:	fec40593          	addi	a1,s0,-20
    80002176:	4501                	li	a0,0
    80002178:	a9fff0ef          	jal	80001c16 <argint>
  
  myproc()->trace_mask = mask;
    8000217c:	bdbfe0ef          	jal	80000d56 <myproc>
    80002180:	fec42783          	lw	a5,-20(s0)
    80002184:	16f52423          	sw	a5,360(a0)
  return 0;
}
    80002188:	4501                	li	a0,0
    8000218a:	60e2                	ld	ra,24(sp)
    8000218c:	6442                	ld	s0,16(sp)
    8000218e:	6105                	addi	sp,sp,32
    80002190:	8082                	ret

0000000080002192 <sys_stats>:


uint64 sys_stats(void) {
    80002192:	1141                	addi	sp,sp,-16
    80002194:	e422                	sd	s0,8(sp)
    80002196:	0800                	addi	s0,sp,16
  for(i = 1; i < SOL_SYSCALL; i++) {
    if(syscall_names[i])
      printf("%s: %d\n", syscall_names[i], (int) syscall_counts[i]);
  }
  return 0;
}
    80002198:	4501                	li	a0,0
    8000219a:	6422                	ld	s0,8(sp)
    8000219c:	0141                	addi	sp,sp,16
    8000219e:	8082                	ret

00000000800021a0 <sys_socket>:


uint64
sys_socket(void)
{
    800021a0:	1101                	addi	sp,sp,-32
    800021a2:	ec06                	sd	ra,24(sp)
    800021a4:	e822                	sd	s0,16(sp)
    800021a6:	1000                	addi	s0,sp,32
  int domain, type, protocol;
  
  argint(0, &domain);
    800021a8:	fec40593          	addi	a1,s0,-20
    800021ac:	4501                	li	a0,0
    800021ae:	a69ff0ef          	jal	80001c16 <argint>
  argint(1, &type);
    800021b2:	fe840593          	addi	a1,s0,-24
    800021b6:	4505                	li	a0,1
    800021b8:	a5fff0ef          	jal	80001c16 <argint>
  argint(2, &protocol);
    800021bc:	fe440593          	addi	a1,s0,-28
    800021c0:	4509                	li	a0,2
    800021c2:	a55ff0ef          	jal	80001c16 <argint>

  return -1;
}
    800021c6:	557d                	li	a0,-1
    800021c8:	60e2                	ld	ra,24(sp)
    800021ca:	6442                	ld	s0,16(sp)
    800021cc:	6105                	addi	sp,sp,32
    800021ce:	8082                	ret

00000000800021d0 <sys_gettimeofday>:
  int tz_dsttime;     // type of DST correction
};

uint64
sys_gettimeofday(void)
{
    800021d0:	7139                	addi	sp,sp,-64
    800021d2:	fc06                	sd	ra,56(sp)
    800021d4:	f822                	sd	s0,48(sp)
    800021d6:	0080                	addi	s0,sp,64
  uint64 tv_addr, tz_addr;
  struct timeval tv;
  
  argaddr(0, &tv_addr);
    800021d8:	fe840593          	addi	a1,s0,-24
    800021dc:	4501                	li	a0,0
    800021de:	a55ff0ef          	jal	80001c32 <argaddr>
  argaddr(1, &tz_addr);
    800021e2:	fe040593          	addi	a1,s0,-32
    800021e6:	4505                	li	a0,1
    800021e8:	a4bff0ef          	jal	80001c32 <argaddr>
  asm volatile("csrr %0, time" : "=r" (x) );
    800021ec:	c01027f3          	rdtime	a5
  
  // Get current ticks and convert to time
  // This is a simple implementation using system ticks
  uint64 ticks = r_time(); // or use uptime() function
  tv.tv_sec = ticks / 1000000; // assuming ticks are in microseconds
    800021f0:	000f4737          	lui	a4,0xf4
    800021f4:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800021f8:	02e7d6b3          	divu	a3,a5,a4
    800021fc:	fcd43823          	sd	a3,-48(s0)
  tv.tv_usec = ticks % 1000000;
    80002200:	02e7f7b3          	remu	a5,a5,a4
    80002204:	fcf43c23          	sd	a5,-40(s0)
  
  if(tv_addr != 0) {
    80002208:	fe843783          	ld	a5,-24(s0)
    8000220c:	eb81                	bnez	a5,8000221c <sys_gettimeofday+0x4c>
    if(copyout(myproc()->pagetable, tv_addr, (char*)&tv, sizeof(tv)) < 0)
      return -1;
  }
  
  // timezone is optional, usually set to NULL
  if(tz_addr != 0) {
    8000220e:	fe043503          	ld	a0,-32(s0)
    80002212:	e11d                	bnez	a0,80002238 <sys_gettimeofday+0x68>
    if(copyout(myproc()->pagetable, tz_addr, (char*)&tz, sizeof(tz)) < 0)
      return -1;
  }
  
  return 0;
}
    80002214:	70e2                	ld	ra,56(sp)
    80002216:	7442                	ld	s0,48(sp)
    80002218:	6121                	addi	sp,sp,64
    8000221a:	8082                	ret
    if(copyout(myproc()->pagetable, tv_addr, (char*)&tv, sizeof(tv)) < 0)
    8000221c:	b3bfe0ef          	jal	80000d56 <myproc>
    80002220:	46c1                	li	a3,16
    80002222:	fd040613          	addi	a2,s0,-48
    80002226:	fe843583          	ld	a1,-24(s0)
    8000222a:	6928                	ld	a0,80(a0)
    8000222c:	f9afe0ef          	jal	800009c6 <copyout>
    80002230:	fc055fe3          	bgez	a0,8000220e <sys_gettimeofday+0x3e>
      return -1;
    80002234:	557d                	li	a0,-1
    80002236:	bff9                	j	80002214 <sys_gettimeofday+0x44>
    struct timezone tz = {0, 0};
    80002238:	fc042423          	sw	zero,-56(s0)
    8000223c:	fc042623          	sw	zero,-52(s0)
    if(copyout(myproc()->pagetable, tz_addr, (char*)&tz, sizeof(tz)) < 0)
    80002240:	b17fe0ef          	jal	80000d56 <myproc>
    80002244:	46a1                	li	a3,8
    80002246:	fc840613          	addi	a2,s0,-56
    8000224a:	fe043583          	ld	a1,-32(s0)
    8000224e:	6928                	ld	a0,80(a0)
    80002250:	f76fe0ef          	jal	800009c6 <copyout>
      return -1;
    80002254:	957d                	srai	a0,a0,0x3f
    80002256:	bf7d                	j	80002214 <sys_gettimeofday+0x44>

0000000080002258 <sys_mmap>:

uint64
sys_mmap(void)
{
    80002258:	7139                	addi	sp,sp,-64
    8000225a:	fc06                	sd	ra,56(sp)
    8000225c:	f822                	sd	s0,48(sp)
    8000225e:	f04a                	sd	s2,32(sp)
    80002260:	0080                	addi	s0,sp,64
  uint64 addr;
  int length, prot, flags, fd, offset;
  
  argaddr(0, &addr);
    80002262:	fd840593          	addi	a1,s0,-40
    80002266:	4501                	li	a0,0
    80002268:	9cbff0ef          	jal	80001c32 <argaddr>
  argint(1, &length);
    8000226c:	fd440593          	addi	a1,s0,-44
    80002270:	4505                	li	a0,1
    80002272:	9a5ff0ef          	jal	80001c16 <argint>
  argint(2, &prot);
    80002276:	fd040593          	addi	a1,s0,-48
    8000227a:	4509                	li	a0,2
    8000227c:	99bff0ef          	jal	80001c16 <argint>
  argint(3, &flags);
    80002280:	fcc40593          	addi	a1,s0,-52
    80002284:	450d                	li	a0,3
    80002286:	991ff0ef          	jal	80001c16 <argint>
  argint(4, &fd);
    8000228a:	fc840593          	addi	a1,s0,-56
    8000228e:	4511                	li	a0,4
    80002290:	987ff0ef          	jal	80001c16 <argint>
  argint(5, &offset);
    80002294:	fc440593          	addi	a1,s0,-60
    80002298:	4515                	li	a0,5
    8000229a:	97dff0ef          	jal	80001c16 <argint>
  
  // For now, just allocate memory using sbrk-like mechanism
  // A full implementation would handle file mapping, permissions, etc.
  struct proc *p = myproc();
    8000229e:	ab9fe0ef          	jal	80000d56 <myproc>
  
  // Simple implementation: just extend process memory
  if(length <= 0)
    800022a2:	fd442603          	lw	a2,-44(s0)
    return -1;
    800022a6:	597d                	li	s2,-1
  if(length <= 0)
    800022a8:	00c05f63          	blez	a2,800022c6 <sys_mmap+0x6e>
    800022ac:	f426                	sd	s1,40(sp)
    800022ae:	84aa                	mv	s1,a0
    
  uint64 old_sz = p->sz;
    800022b0:	04853903          	ld	s2,72(a0)
  if((p->sz = uvmalloc(p->pagetable, p->sz, p->sz + length, PTE_W|PTE_R|PTE_U)) == 0) {
    800022b4:	46d9                	li	a3,22
    800022b6:	964a                	add	a2,a2,s2
    800022b8:	85ca                	mv	a1,s2
    800022ba:	6928                	ld	a0,80(a0)
    800022bc:	cfefe0ef          	jal	800007ba <uvmalloc>
    800022c0:	e4a8                	sd	a0,72(s1)
    800022c2:	c901                	beqz	a0,800022d2 <sys_mmap+0x7a>
    800022c4:	74a2                	ld	s1,40(sp)
    return -1;
  }
  
  return old_sz; // return the starting address of mapped region
    800022c6:	854a                	mv	a0,s2
    800022c8:	70e2                	ld	ra,56(sp)
    800022ca:	7442                	ld	s0,48(sp)
    800022cc:	7902                	ld	s2,32(sp)
    800022ce:	6121                	addi	sp,sp,64
    800022d0:	8082                	ret
    return -1;
    800022d2:	597d                	li	s2,-1
    800022d4:	74a2                	ld	s1,40(sp)
    800022d6:	bfc5                	j	800022c6 <sys_mmap+0x6e>

00000000800022d8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800022d8:	7179                	addi	sp,sp,-48
    800022da:	f406                	sd	ra,40(sp)
    800022dc:	f022                	sd	s0,32(sp)
    800022de:	ec26                	sd	s1,24(sp)
    800022e0:	e84a                	sd	s2,16(sp)
    800022e2:	e44e                	sd	s3,8(sp)
    800022e4:	e052                	sd	s4,0(sp)
    800022e6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800022e8:	00005597          	auipc	a1,0x5
    800022ec:	26058593          	addi	a1,a1,608 # 80007548 <etext+0x548>
    800022f0:	0000e517          	auipc	a0,0xe
    800022f4:	5c850513          	addi	a0,a0,1480 # 800108b8 <bcache>
    800022f8:	7f8030ef          	jal	80005af0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800022fc:	00016797          	auipc	a5,0x16
    80002300:	5bc78793          	addi	a5,a5,1468 # 800188b8 <bcache+0x8000>
    80002304:	00017717          	auipc	a4,0x17
    80002308:	81c70713          	addi	a4,a4,-2020 # 80018b20 <bcache+0x8268>
    8000230c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002310:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002314:	0000e497          	auipc	s1,0xe
    80002318:	5bc48493          	addi	s1,s1,1468 # 800108d0 <bcache+0x18>
    b->next = bcache.head.next;
    8000231c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000231e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002320:	00005a17          	auipc	s4,0x5
    80002324:	230a0a13          	addi	s4,s4,560 # 80007550 <etext+0x550>
    b->next = bcache.head.next;
    80002328:	2b893783          	ld	a5,696(s2)
    8000232c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000232e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002332:	85d2                	mv	a1,s4
    80002334:	01048513          	addi	a0,s1,16
    80002338:	248010ef          	jal	80003580 <initsleeplock>
    bcache.head.next->prev = b;
    8000233c:	2b893783          	ld	a5,696(s2)
    80002340:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002342:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002346:	45848493          	addi	s1,s1,1112
    8000234a:	fd349fe3          	bne	s1,s3,80002328 <binit+0x50>
  }
}
    8000234e:	70a2                	ld	ra,40(sp)
    80002350:	7402                	ld	s0,32(sp)
    80002352:	64e2                	ld	s1,24(sp)
    80002354:	6942                	ld	s2,16(sp)
    80002356:	69a2                	ld	s3,8(sp)
    80002358:	6a02                	ld	s4,0(sp)
    8000235a:	6145                	addi	sp,sp,48
    8000235c:	8082                	ret

000000008000235e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000235e:	7179                	addi	sp,sp,-48
    80002360:	f406                	sd	ra,40(sp)
    80002362:	f022                	sd	s0,32(sp)
    80002364:	ec26                	sd	s1,24(sp)
    80002366:	e84a                	sd	s2,16(sp)
    80002368:	e44e                	sd	s3,8(sp)
    8000236a:	1800                	addi	s0,sp,48
    8000236c:	892a                	mv	s2,a0
    8000236e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002370:	0000e517          	auipc	a0,0xe
    80002374:	54850513          	addi	a0,a0,1352 # 800108b8 <bcache>
    80002378:	7f8030ef          	jal	80005b70 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000237c:	00016497          	auipc	s1,0x16
    80002380:	7f44b483          	ld	s1,2036(s1) # 80018b70 <bcache+0x82b8>
    80002384:	00016797          	auipc	a5,0x16
    80002388:	79c78793          	addi	a5,a5,1948 # 80018b20 <bcache+0x8268>
    8000238c:	02f48b63          	beq	s1,a5,800023c2 <bread+0x64>
    80002390:	873e                	mv	a4,a5
    80002392:	a021                	j	8000239a <bread+0x3c>
    80002394:	68a4                	ld	s1,80(s1)
    80002396:	02e48663          	beq	s1,a4,800023c2 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    8000239a:	449c                	lw	a5,8(s1)
    8000239c:	ff279ce3          	bne	a5,s2,80002394 <bread+0x36>
    800023a0:	44dc                	lw	a5,12(s1)
    800023a2:	ff3799e3          	bne	a5,s3,80002394 <bread+0x36>
      b->refcnt++;
    800023a6:	40bc                	lw	a5,64(s1)
    800023a8:	2785                	addiw	a5,a5,1
    800023aa:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023ac:	0000e517          	auipc	a0,0xe
    800023b0:	50c50513          	addi	a0,a0,1292 # 800108b8 <bcache>
    800023b4:	055030ef          	jal	80005c08 <release>
      acquiresleep(&b->lock);
    800023b8:	01048513          	addi	a0,s1,16
    800023bc:	1fa010ef          	jal	800035b6 <acquiresleep>
      return b;
    800023c0:	a889                	j	80002412 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023c2:	00016497          	auipc	s1,0x16
    800023c6:	7a64b483          	ld	s1,1958(s1) # 80018b68 <bcache+0x82b0>
    800023ca:	00016797          	auipc	a5,0x16
    800023ce:	75678793          	addi	a5,a5,1878 # 80018b20 <bcache+0x8268>
    800023d2:	00f48863          	beq	s1,a5,800023e2 <bread+0x84>
    800023d6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800023d8:	40bc                	lw	a5,64(s1)
    800023da:	cb91                	beqz	a5,800023ee <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023dc:	64a4                	ld	s1,72(s1)
    800023de:	fee49de3          	bne	s1,a4,800023d8 <bread+0x7a>
  panic("bget: no buffers");
    800023e2:	00005517          	auipc	a0,0x5
    800023e6:	17650513          	addi	a0,a0,374 # 80007558 <etext+0x558>
    800023ea:	458030ef          	jal	80005842 <panic>
      b->dev = dev;
    800023ee:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800023f2:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800023f6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800023fa:	4785                	li	a5,1
    800023fc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023fe:	0000e517          	auipc	a0,0xe
    80002402:	4ba50513          	addi	a0,a0,1210 # 800108b8 <bcache>
    80002406:	003030ef          	jal	80005c08 <release>
      acquiresleep(&b->lock);
    8000240a:	01048513          	addi	a0,s1,16
    8000240e:	1a8010ef          	jal	800035b6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002412:	409c                	lw	a5,0(s1)
    80002414:	cb89                	beqz	a5,80002426 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002416:	8526                	mv	a0,s1
    80002418:	70a2                	ld	ra,40(sp)
    8000241a:	7402                	ld	s0,32(sp)
    8000241c:	64e2                	ld	s1,24(sp)
    8000241e:	6942                	ld	s2,16(sp)
    80002420:	69a2                	ld	s3,8(sp)
    80002422:	6145                	addi	sp,sp,48
    80002424:	8082                	ret
    virtio_disk_rw(b, 0);
    80002426:	4581                	li	a1,0
    80002428:	8526                	mv	a0,s1
    8000242a:	1e7020ef          	jal	80004e10 <virtio_disk_rw>
    b->valid = 1;
    8000242e:	4785                	li	a5,1
    80002430:	c09c                	sw	a5,0(s1)
  return b;
    80002432:	b7d5                	j	80002416 <bread+0xb8>

0000000080002434 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002434:	1101                	addi	sp,sp,-32
    80002436:	ec06                	sd	ra,24(sp)
    80002438:	e822                	sd	s0,16(sp)
    8000243a:	e426                	sd	s1,8(sp)
    8000243c:	1000                	addi	s0,sp,32
    8000243e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002440:	0541                	addi	a0,a0,16
    80002442:	1f2010ef          	jal	80003634 <holdingsleep>
    80002446:	c911                	beqz	a0,8000245a <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002448:	4585                	li	a1,1
    8000244a:	8526                	mv	a0,s1
    8000244c:	1c5020ef          	jal	80004e10 <virtio_disk_rw>
}
    80002450:	60e2                	ld	ra,24(sp)
    80002452:	6442                	ld	s0,16(sp)
    80002454:	64a2                	ld	s1,8(sp)
    80002456:	6105                	addi	sp,sp,32
    80002458:	8082                	ret
    panic("bwrite");
    8000245a:	00005517          	auipc	a0,0x5
    8000245e:	11650513          	addi	a0,a0,278 # 80007570 <etext+0x570>
    80002462:	3e0030ef          	jal	80005842 <panic>

0000000080002466 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002466:	1101                	addi	sp,sp,-32
    80002468:	ec06                	sd	ra,24(sp)
    8000246a:	e822                	sd	s0,16(sp)
    8000246c:	e426                	sd	s1,8(sp)
    8000246e:	e04a                	sd	s2,0(sp)
    80002470:	1000                	addi	s0,sp,32
    80002472:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002474:	01050913          	addi	s2,a0,16
    80002478:	854a                	mv	a0,s2
    8000247a:	1ba010ef          	jal	80003634 <holdingsleep>
    8000247e:	c135                	beqz	a0,800024e2 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002480:	854a                	mv	a0,s2
    80002482:	17a010ef          	jal	800035fc <releasesleep>

  acquire(&bcache.lock);
    80002486:	0000e517          	auipc	a0,0xe
    8000248a:	43250513          	addi	a0,a0,1074 # 800108b8 <bcache>
    8000248e:	6e2030ef          	jal	80005b70 <acquire>
  b->refcnt--;
    80002492:	40bc                	lw	a5,64(s1)
    80002494:	37fd                	addiw	a5,a5,-1
    80002496:	0007871b          	sext.w	a4,a5
    8000249a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000249c:	e71d                	bnez	a4,800024ca <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000249e:	68b8                	ld	a4,80(s1)
    800024a0:	64bc                	ld	a5,72(s1)
    800024a2:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800024a4:	68b8                	ld	a4,80(s1)
    800024a6:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800024a8:	00016797          	auipc	a5,0x16
    800024ac:	41078793          	addi	a5,a5,1040 # 800188b8 <bcache+0x8000>
    800024b0:	2b87b703          	ld	a4,696(a5)
    800024b4:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800024b6:	00016717          	auipc	a4,0x16
    800024ba:	66a70713          	addi	a4,a4,1642 # 80018b20 <bcache+0x8268>
    800024be:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800024c0:	2b87b703          	ld	a4,696(a5)
    800024c4:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800024c6:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800024ca:	0000e517          	auipc	a0,0xe
    800024ce:	3ee50513          	addi	a0,a0,1006 # 800108b8 <bcache>
    800024d2:	736030ef          	jal	80005c08 <release>
}
    800024d6:	60e2                	ld	ra,24(sp)
    800024d8:	6442                	ld	s0,16(sp)
    800024da:	64a2                	ld	s1,8(sp)
    800024dc:	6902                	ld	s2,0(sp)
    800024de:	6105                	addi	sp,sp,32
    800024e0:	8082                	ret
    panic("brelse");
    800024e2:	00005517          	auipc	a0,0x5
    800024e6:	09650513          	addi	a0,a0,150 # 80007578 <etext+0x578>
    800024ea:	358030ef          	jal	80005842 <panic>

00000000800024ee <bpin>:

void
bpin(struct buf *b) {
    800024ee:	1101                	addi	sp,sp,-32
    800024f0:	ec06                	sd	ra,24(sp)
    800024f2:	e822                	sd	s0,16(sp)
    800024f4:	e426                	sd	s1,8(sp)
    800024f6:	1000                	addi	s0,sp,32
    800024f8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024fa:	0000e517          	auipc	a0,0xe
    800024fe:	3be50513          	addi	a0,a0,958 # 800108b8 <bcache>
    80002502:	66e030ef          	jal	80005b70 <acquire>
  b->refcnt++;
    80002506:	40bc                	lw	a5,64(s1)
    80002508:	2785                	addiw	a5,a5,1
    8000250a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000250c:	0000e517          	auipc	a0,0xe
    80002510:	3ac50513          	addi	a0,a0,940 # 800108b8 <bcache>
    80002514:	6f4030ef          	jal	80005c08 <release>
}
    80002518:	60e2                	ld	ra,24(sp)
    8000251a:	6442                	ld	s0,16(sp)
    8000251c:	64a2                	ld	s1,8(sp)
    8000251e:	6105                	addi	sp,sp,32
    80002520:	8082                	ret

0000000080002522 <bunpin>:

void
bunpin(struct buf *b) {
    80002522:	1101                	addi	sp,sp,-32
    80002524:	ec06                	sd	ra,24(sp)
    80002526:	e822                	sd	s0,16(sp)
    80002528:	e426                	sd	s1,8(sp)
    8000252a:	1000                	addi	s0,sp,32
    8000252c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000252e:	0000e517          	auipc	a0,0xe
    80002532:	38a50513          	addi	a0,a0,906 # 800108b8 <bcache>
    80002536:	63a030ef          	jal	80005b70 <acquire>
  b->refcnt--;
    8000253a:	40bc                	lw	a5,64(s1)
    8000253c:	37fd                	addiw	a5,a5,-1
    8000253e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002540:	0000e517          	auipc	a0,0xe
    80002544:	37850513          	addi	a0,a0,888 # 800108b8 <bcache>
    80002548:	6c0030ef          	jal	80005c08 <release>
}
    8000254c:	60e2                	ld	ra,24(sp)
    8000254e:	6442                	ld	s0,16(sp)
    80002550:	64a2                	ld	s1,8(sp)
    80002552:	6105                	addi	sp,sp,32
    80002554:	8082                	ret

0000000080002556 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002556:	1101                	addi	sp,sp,-32
    80002558:	ec06                	sd	ra,24(sp)
    8000255a:	e822                	sd	s0,16(sp)
    8000255c:	e426                	sd	s1,8(sp)
    8000255e:	e04a                	sd	s2,0(sp)
    80002560:	1000                	addi	s0,sp,32
    80002562:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002564:	00d5d59b          	srliw	a1,a1,0xd
    80002568:	00017797          	auipc	a5,0x17
    8000256c:	a2c7a783          	lw	a5,-1492(a5) # 80018f94 <sb+0x1c>
    80002570:	9dbd                	addw	a1,a1,a5
    80002572:	dedff0ef          	jal	8000235e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002576:	0074f713          	andi	a4,s1,7
    8000257a:	4785                	li	a5,1
    8000257c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002580:	14ce                	slli	s1,s1,0x33
    80002582:	90d9                	srli	s1,s1,0x36
    80002584:	00950733          	add	a4,a0,s1
    80002588:	05874703          	lbu	a4,88(a4)
    8000258c:	00e7f6b3          	and	a3,a5,a4
    80002590:	c29d                	beqz	a3,800025b6 <bfree+0x60>
    80002592:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002594:	94aa                	add	s1,s1,a0
    80002596:	fff7c793          	not	a5,a5
    8000259a:	8f7d                	and	a4,a4,a5
    8000259c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800025a0:	711000ef          	jal	800034b0 <log_write>
  brelse(bp);
    800025a4:	854a                	mv	a0,s2
    800025a6:	ec1ff0ef          	jal	80002466 <brelse>
}
    800025aa:	60e2                	ld	ra,24(sp)
    800025ac:	6442                	ld	s0,16(sp)
    800025ae:	64a2                	ld	s1,8(sp)
    800025b0:	6902                	ld	s2,0(sp)
    800025b2:	6105                	addi	sp,sp,32
    800025b4:	8082                	ret
    panic("freeing free block");
    800025b6:	00005517          	auipc	a0,0x5
    800025ba:	fca50513          	addi	a0,a0,-54 # 80007580 <etext+0x580>
    800025be:	284030ef          	jal	80005842 <panic>

00000000800025c2 <balloc>:
{
    800025c2:	711d                	addi	sp,sp,-96
    800025c4:	ec86                	sd	ra,88(sp)
    800025c6:	e8a2                	sd	s0,80(sp)
    800025c8:	e4a6                	sd	s1,72(sp)
    800025ca:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800025cc:	00017797          	auipc	a5,0x17
    800025d0:	9b07a783          	lw	a5,-1616(a5) # 80018f7c <sb+0x4>
    800025d4:	0e078f63          	beqz	a5,800026d2 <balloc+0x110>
    800025d8:	e0ca                	sd	s2,64(sp)
    800025da:	fc4e                	sd	s3,56(sp)
    800025dc:	f852                	sd	s4,48(sp)
    800025de:	f456                	sd	s5,40(sp)
    800025e0:	f05a                	sd	s6,32(sp)
    800025e2:	ec5e                	sd	s7,24(sp)
    800025e4:	e862                	sd	s8,16(sp)
    800025e6:	e466                	sd	s9,8(sp)
    800025e8:	8baa                	mv	s7,a0
    800025ea:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025ec:	00017b17          	auipc	s6,0x17
    800025f0:	98cb0b13          	addi	s6,s6,-1652 # 80018f78 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025f4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025f6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025f8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025fa:	6c89                	lui	s9,0x2
    800025fc:	a0b5                	j	80002668 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025fe:	97ca                	add	a5,a5,s2
    80002600:	8e55                	or	a2,a2,a3
    80002602:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002606:	854a                	mv	a0,s2
    80002608:	6a9000ef          	jal	800034b0 <log_write>
        brelse(bp);
    8000260c:	854a                	mv	a0,s2
    8000260e:	e59ff0ef          	jal	80002466 <brelse>
  bp = bread(dev, bno);
    80002612:	85a6                	mv	a1,s1
    80002614:	855e                	mv	a0,s7
    80002616:	d49ff0ef          	jal	8000235e <bread>
    8000261a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000261c:	40000613          	li	a2,1024
    80002620:	4581                	li	a1,0
    80002622:	05850513          	addi	a0,a0,88
    80002626:	b0ffd0ef          	jal	80000134 <memset>
  log_write(bp);
    8000262a:	854a                	mv	a0,s2
    8000262c:	685000ef          	jal	800034b0 <log_write>
  brelse(bp);
    80002630:	854a                	mv	a0,s2
    80002632:	e35ff0ef          	jal	80002466 <brelse>
}
    80002636:	6906                	ld	s2,64(sp)
    80002638:	79e2                	ld	s3,56(sp)
    8000263a:	7a42                	ld	s4,48(sp)
    8000263c:	7aa2                	ld	s5,40(sp)
    8000263e:	7b02                	ld	s6,32(sp)
    80002640:	6be2                	ld	s7,24(sp)
    80002642:	6c42                	ld	s8,16(sp)
    80002644:	6ca2                	ld	s9,8(sp)
}
    80002646:	8526                	mv	a0,s1
    80002648:	60e6                	ld	ra,88(sp)
    8000264a:	6446                	ld	s0,80(sp)
    8000264c:	64a6                	ld	s1,72(sp)
    8000264e:	6125                	addi	sp,sp,96
    80002650:	8082                	ret
    brelse(bp);
    80002652:	854a                	mv	a0,s2
    80002654:	e13ff0ef          	jal	80002466 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002658:	015c87bb          	addw	a5,s9,s5
    8000265c:	00078a9b          	sext.w	s5,a5
    80002660:	004b2703          	lw	a4,4(s6)
    80002664:	04eaff63          	bgeu	s5,a4,800026c2 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002668:	41fad79b          	sraiw	a5,s5,0x1f
    8000266c:	0137d79b          	srliw	a5,a5,0x13
    80002670:	015787bb          	addw	a5,a5,s5
    80002674:	40d7d79b          	sraiw	a5,a5,0xd
    80002678:	01cb2583          	lw	a1,28(s6)
    8000267c:	9dbd                	addw	a1,a1,a5
    8000267e:	855e                	mv	a0,s7
    80002680:	cdfff0ef          	jal	8000235e <bread>
    80002684:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002686:	004b2503          	lw	a0,4(s6)
    8000268a:	000a849b          	sext.w	s1,s5
    8000268e:	8762                	mv	a4,s8
    80002690:	fca4f1e3          	bgeu	s1,a0,80002652 <balloc+0x90>
      m = 1 << (bi % 8);
    80002694:	00777693          	andi	a3,a4,7
    80002698:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000269c:	41f7579b          	sraiw	a5,a4,0x1f
    800026a0:	01d7d79b          	srliw	a5,a5,0x1d
    800026a4:	9fb9                	addw	a5,a5,a4
    800026a6:	4037d79b          	sraiw	a5,a5,0x3
    800026aa:	00f90633          	add	a2,s2,a5
    800026ae:	05864603          	lbu	a2,88(a2)
    800026b2:	00c6f5b3          	and	a1,a3,a2
    800026b6:	d5a1                	beqz	a1,800025fe <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026b8:	2705                	addiw	a4,a4,1
    800026ba:	2485                	addiw	s1,s1,1
    800026bc:	fd471ae3          	bne	a4,s4,80002690 <balloc+0xce>
    800026c0:	bf49                	j	80002652 <balloc+0x90>
    800026c2:	6906                	ld	s2,64(sp)
    800026c4:	79e2                	ld	s3,56(sp)
    800026c6:	7a42                	ld	s4,48(sp)
    800026c8:	7aa2                	ld	s5,40(sp)
    800026ca:	7b02                	ld	s6,32(sp)
    800026cc:	6be2                	ld	s7,24(sp)
    800026ce:	6c42                	ld	s8,16(sp)
    800026d0:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800026d2:	00005517          	auipc	a0,0x5
    800026d6:	ec650513          	addi	a0,a0,-314 # 80007598 <etext+0x598>
    800026da:	697020ef          	jal	80005570 <printf>
  return 0;
    800026de:	4481                	li	s1,0
    800026e0:	b79d                	j	80002646 <balloc+0x84>

00000000800026e2 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800026e2:	7179                	addi	sp,sp,-48
    800026e4:	f406                	sd	ra,40(sp)
    800026e6:	f022                	sd	s0,32(sp)
    800026e8:	ec26                	sd	s1,24(sp)
    800026ea:	e84a                	sd	s2,16(sp)
    800026ec:	e44e                	sd	s3,8(sp)
    800026ee:	1800                	addi	s0,sp,48
    800026f0:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026f2:	47ad                	li	a5,11
    800026f4:	02b7e663          	bltu	a5,a1,80002720 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800026f8:	02059793          	slli	a5,a1,0x20
    800026fc:	01e7d593          	srli	a1,a5,0x1e
    80002700:	00b504b3          	add	s1,a0,a1
    80002704:	0504a903          	lw	s2,80(s1)
    80002708:	06091a63          	bnez	s2,8000277c <bmap+0x9a>
      addr = balloc(ip->dev);
    8000270c:	4108                	lw	a0,0(a0)
    8000270e:	eb5ff0ef          	jal	800025c2 <balloc>
    80002712:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002716:	06090363          	beqz	s2,8000277c <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    8000271a:	0524a823          	sw	s2,80(s1)
    8000271e:	a8b9                	j	8000277c <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002720:	ff45849b          	addiw	s1,a1,-12
    80002724:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002728:	0ff00793          	li	a5,255
    8000272c:	06e7ee63          	bltu	a5,a4,800027a8 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002730:	08052903          	lw	s2,128(a0)
    80002734:	00091d63          	bnez	s2,8000274e <bmap+0x6c>
      addr = balloc(ip->dev);
    80002738:	4108                	lw	a0,0(a0)
    8000273a:	e89ff0ef          	jal	800025c2 <balloc>
    8000273e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002742:	02090d63          	beqz	s2,8000277c <bmap+0x9a>
    80002746:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002748:	0929a023          	sw	s2,128(s3)
    8000274c:	a011                	j	80002750 <bmap+0x6e>
    8000274e:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002750:	85ca                	mv	a1,s2
    80002752:	0009a503          	lw	a0,0(s3)
    80002756:	c09ff0ef          	jal	8000235e <bread>
    8000275a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000275c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002760:	02049713          	slli	a4,s1,0x20
    80002764:	01e75593          	srli	a1,a4,0x1e
    80002768:	00b784b3          	add	s1,a5,a1
    8000276c:	0004a903          	lw	s2,0(s1)
    80002770:	00090e63          	beqz	s2,8000278c <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002774:	8552                	mv	a0,s4
    80002776:	cf1ff0ef          	jal	80002466 <brelse>
    return addr;
    8000277a:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000277c:	854a                	mv	a0,s2
    8000277e:	70a2                	ld	ra,40(sp)
    80002780:	7402                	ld	s0,32(sp)
    80002782:	64e2                	ld	s1,24(sp)
    80002784:	6942                	ld	s2,16(sp)
    80002786:	69a2                	ld	s3,8(sp)
    80002788:	6145                	addi	sp,sp,48
    8000278a:	8082                	ret
      addr = balloc(ip->dev);
    8000278c:	0009a503          	lw	a0,0(s3)
    80002790:	e33ff0ef          	jal	800025c2 <balloc>
    80002794:	0005091b          	sext.w	s2,a0
      if(addr){
    80002798:	fc090ee3          	beqz	s2,80002774 <bmap+0x92>
        a[bn] = addr;
    8000279c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800027a0:	8552                	mv	a0,s4
    800027a2:	50f000ef          	jal	800034b0 <log_write>
    800027a6:	b7f9                	j	80002774 <bmap+0x92>
    800027a8:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800027aa:	00005517          	auipc	a0,0x5
    800027ae:	e0650513          	addi	a0,a0,-506 # 800075b0 <etext+0x5b0>
    800027b2:	090030ef          	jal	80005842 <panic>

00000000800027b6 <iget>:
{
    800027b6:	7179                	addi	sp,sp,-48
    800027b8:	f406                	sd	ra,40(sp)
    800027ba:	f022                	sd	s0,32(sp)
    800027bc:	ec26                	sd	s1,24(sp)
    800027be:	e84a                	sd	s2,16(sp)
    800027c0:	e44e                	sd	s3,8(sp)
    800027c2:	e052                	sd	s4,0(sp)
    800027c4:	1800                	addi	s0,sp,48
    800027c6:	89aa                	mv	s3,a0
    800027c8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027ca:	00016517          	auipc	a0,0x16
    800027ce:	7ce50513          	addi	a0,a0,1998 # 80018f98 <itable>
    800027d2:	39e030ef          	jal	80005b70 <acquire>
  empty = 0;
    800027d6:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027d8:	00016497          	auipc	s1,0x16
    800027dc:	7d848493          	addi	s1,s1,2008 # 80018fb0 <itable+0x18>
    800027e0:	00018697          	auipc	a3,0x18
    800027e4:	26068693          	addi	a3,a3,608 # 8001aa40 <log>
    800027e8:	a039                	j	800027f6 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027ea:	02090963          	beqz	s2,8000281c <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027ee:	08848493          	addi	s1,s1,136
    800027f2:	02d48863          	beq	s1,a3,80002822 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027f6:	449c                	lw	a5,8(s1)
    800027f8:	fef059e3          	blez	a5,800027ea <iget+0x34>
    800027fc:	4098                	lw	a4,0(s1)
    800027fe:	ff3716e3          	bne	a4,s3,800027ea <iget+0x34>
    80002802:	40d8                	lw	a4,4(s1)
    80002804:	ff4713e3          	bne	a4,s4,800027ea <iget+0x34>
      ip->ref++;
    80002808:	2785                	addiw	a5,a5,1
    8000280a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000280c:	00016517          	auipc	a0,0x16
    80002810:	78c50513          	addi	a0,a0,1932 # 80018f98 <itable>
    80002814:	3f4030ef          	jal	80005c08 <release>
      return ip;
    80002818:	8926                	mv	s2,s1
    8000281a:	a02d                	j	80002844 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000281c:	fbe9                	bnez	a5,800027ee <iget+0x38>
      empty = ip;
    8000281e:	8926                	mv	s2,s1
    80002820:	b7f9                	j	800027ee <iget+0x38>
  if(empty == 0)
    80002822:	02090a63          	beqz	s2,80002856 <iget+0xa0>
  ip->dev = dev;
    80002826:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000282a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000282e:	4785                	li	a5,1
    80002830:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002834:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002838:	00016517          	auipc	a0,0x16
    8000283c:	76050513          	addi	a0,a0,1888 # 80018f98 <itable>
    80002840:	3c8030ef          	jal	80005c08 <release>
}
    80002844:	854a                	mv	a0,s2
    80002846:	70a2                	ld	ra,40(sp)
    80002848:	7402                	ld	s0,32(sp)
    8000284a:	64e2                	ld	s1,24(sp)
    8000284c:	6942                	ld	s2,16(sp)
    8000284e:	69a2                	ld	s3,8(sp)
    80002850:	6a02                	ld	s4,0(sp)
    80002852:	6145                	addi	sp,sp,48
    80002854:	8082                	ret
    panic("iget: no inodes");
    80002856:	00005517          	auipc	a0,0x5
    8000285a:	d7250513          	addi	a0,a0,-654 # 800075c8 <etext+0x5c8>
    8000285e:	7e5020ef          	jal	80005842 <panic>

0000000080002862 <fsinit>:
fsinit(int dev) {
    80002862:	7179                	addi	sp,sp,-48
    80002864:	f406                	sd	ra,40(sp)
    80002866:	f022                	sd	s0,32(sp)
    80002868:	ec26                	sd	s1,24(sp)
    8000286a:	e84a                	sd	s2,16(sp)
    8000286c:	e44e                	sd	s3,8(sp)
    8000286e:	1800                	addi	s0,sp,48
    80002870:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002872:	4585                	li	a1,1
    80002874:	aebff0ef          	jal	8000235e <bread>
    80002878:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000287a:	00016997          	auipc	s3,0x16
    8000287e:	6fe98993          	addi	s3,s3,1790 # 80018f78 <sb>
    80002882:	02000613          	li	a2,32
    80002886:	05850593          	addi	a1,a0,88
    8000288a:	854e                	mv	a0,s3
    8000288c:	905fd0ef          	jal	80000190 <memmove>
  brelse(bp);
    80002890:	8526                	mv	a0,s1
    80002892:	bd5ff0ef          	jal	80002466 <brelse>
  if(sb.magic != FSMAGIC)
    80002896:	0009a703          	lw	a4,0(s3)
    8000289a:	102037b7          	lui	a5,0x10203
    8000289e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028a2:	02f71063          	bne	a4,a5,800028c2 <fsinit+0x60>
  initlog(dev, &sb);
    800028a6:	00016597          	auipc	a1,0x16
    800028aa:	6d258593          	addi	a1,a1,1746 # 80018f78 <sb>
    800028ae:	854a                	mv	a0,s2
    800028b0:	1f9000ef          	jal	800032a8 <initlog>
}
    800028b4:	70a2                	ld	ra,40(sp)
    800028b6:	7402                	ld	s0,32(sp)
    800028b8:	64e2                	ld	s1,24(sp)
    800028ba:	6942                	ld	s2,16(sp)
    800028bc:	69a2                	ld	s3,8(sp)
    800028be:	6145                	addi	sp,sp,48
    800028c0:	8082                	ret
    panic("invalid file system");
    800028c2:	00005517          	auipc	a0,0x5
    800028c6:	d1650513          	addi	a0,a0,-746 # 800075d8 <etext+0x5d8>
    800028ca:	779020ef          	jal	80005842 <panic>

00000000800028ce <iinit>:
{
    800028ce:	7179                	addi	sp,sp,-48
    800028d0:	f406                	sd	ra,40(sp)
    800028d2:	f022                	sd	s0,32(sp)
    800028d4:	ec26                	sd	s1,24(sp)
    800028d6:	e84a                	sd	s2,16(sp)
    800028d8:	e44e                	sd	s3,8(sp)
    800028da:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800028dc:	00005597          	auipc	a1,0x5
    800028e0:	d1458593          	addi	a1,a1,-748 # 800075f0 <etext+0x5f0>
    800028e4:	00016517          	auipc	a0,0x16
    800028e8:	6b450513          	addi	a0,a0,1716 # 80018f98 <itable>
    800028ec:	204030ef          	jal	80005af0 <initlock>
  for(i = 0; i < NINODE; i++) {
    800028f0:	00016497          	auipc	s1,0x16
    800028f4:	6d048493          	addi	s1,s1,1744 # 80018fc0 <itable+0x28>
    800028f8:	00018997          	auipc	s3,0x18
    800028fc:	15898993          	addi	s3,s3,344 # 8001aa50 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002900:	00005917          	auipc	s2,0x5
    80002904:	cf890913          	addi	s2,s2,-776 # 800075f8 <etext+0x5f8>
    80002908:	85ca                	mv	a1,s2
    8000290a:	8526                	mv	a0,s1
    8000290c:	475000ef          	jal	80003580 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002910:	08848493          	addi	s1,s1,136
    80002914:	ff349ae3          	bne	s1,s3,80002908 <iinit+0x3a>
}
    80002918:	70a2                	ld	ra,40(sp)
    8000291a:	7402                	ld	s0,32(sp)
    8000291c:	64e2                	ld	s1,24(sp)
    8000291e:	6942                	ld	s2,16(sp)
    80002920:	69a2                	ld	s3,8(sp)
    80002922:	6145                	addi	sp,sp,48
    80002924:	8082                	ret

0000000080002926 <ialloc>:
{
    80002926:	7139                	addi	sp,sp,-64
    80002928:	fc06                	sd	ra,56(sp)
    8000292a:	f822                	sd	s0,48(sp)
    8000292c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000292e:	00016717          	auipc	a4,0x16
    80002932:	65672703          	lw	a4,1622(a4) # 80018f84 <sb+0xc>
    80002936:	4785                	li	a5,1
    80002938:	06e7f063          	bgeu	a5,a4,80002998 <ialloc+0x72>
    8000293c:	f426                	sd	s1,40(sp)
    8000293e:	f04a                	sd	s2,32(sp)
    80002940:	ec4e                	sd	s3,24(sp)
    80002942:	e852                	sd	s4,16(sp)
    80002944:	e456                	sd	s5,8(sp)
    80002946:	e05a                	sd	s6,0(sp)
    80002948:	8aaa                	mv	s5,a0
    8000294a:	8b2e                	mv	s6,a1
    8000294c:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000294e:	00016a17          	auipc	s4,0x16
    80002952:	62aa0a13          	addi	s4,s4,1578 # 80018f78 <sb>
    80002956:	00495593          	srli	a1,s2,0x4
    8000295a:	018a2783          	lw	a5,24(s4)
    8000295e:	9dbd                	addw	a1,a1,a5
    80002960:	8556                	mv	a0,s5
    80002962:	9fdff0ef          	jal	8000235e <bread>
    80002966:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002968:	05850993          	addi	s3,a0,88
    8000296c:	00f97793          	andi	a5,s2,15
    80002970:	079a                	slli	a5,a5,0x6
    80002972:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002974:	00099783          	lh	a5,0(s3)
    80002978:	cb9d                	beqz	a5,800029ae <ialloc+0x88>
    brelse(bp);
    8000297a:	aedff0ef          	jal	80002466 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000297e:	0905                	addi	s2,s2,1
    80002980:	00ca2703          	lw	a4,12(s4)
    80002984:	0009079b          	sext.w	a5,s2
    80002988:	fce7e7e3          	bltu	a5,a4,80002956 <ialloc+0x30>
    8000298c:	74a2                	ld	s1,40(sp)
    8000298e:	7902                	ld	s2,32(sp)
    80002990:	69e2                	ld	s3,24(sp)
    80002992:	6a42                	ld	s4,16(sp)
    80002994:	6aa2                	ld	s5,8(sp)
    80002996:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002998:	00005517          	auipc	a0,0x5
    8000299c:	c6850513          	addi	a0,a0,-920 # 80007600 <etext+0x600>
    800029a0:	3d1020ef          	jal	80005570 <printf>
  return 0;
    800029a4:	4501                	li	a0,0
}
    800029a6:	70e2                	ld	ra,56(sp)
    800029a8:	7442                	ld	s0,48(sp)
    800029aa:	6121                	addi	sp,sp,64
    800029ac:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800029ae:	04000613          	li	a2,64
    800029b2:	4581                	li	a1,0
    800029b4:	854e                	mv	a0,s3
    800029b6:	f7efd0ef          	jal	80000134 <memset>
      dip->type = type;
    800029ba:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800029be:	8526                	mv	a0,s1
    800029c0:	2f1000ef          	jal	800034b0 <log_write>
      brelse(bp);
    800029c4:	8526                	mv	a0,s1
    800029c6:	aa1ff0ef          	jal	80002466 <brelse>
      return iget(dev, inum);
    800029ca:	0009059b          	sext.w	a1,s2
    800029ce:	8556                	mv	a0,s5
    800029d0:	de7ff0ef          	jal	800027b6 <iget>
    800029d4:	74a2                	ld	s1,40(sp)
    800029d6:	7902                	ld	s2,32(sp)
    800029d8:	69e2                	ld	s3,24(sp)
    800029da:	6a42                	ld	s4,16(sp)
    800029dc:	6aa2                	ld	s5,8(sp)
    800029de:	6b02                	ld	s6,0(sp)
    800029e0:	b7d9                	j	800029a6 <ialloc+0x80>

00000000800029e2 <iupdate>:
{
    800029e2:	1101                	addi	sp,sp,-32
    800029e4:	ec06                	sd	ra,24(sp)
    800029e6:	e822                	sd	s0,16(sp)
    800029e8:	e426                	sd	s1,8(sp)
    800029ea:	e04a                	sd	s2,0(sp)
    800029ec:	1000                	addi	s0,sp,32
    800029ee:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800029f0:	415c                	lw	a5,4(a0)
    800029f2:	0047d79b          	srliw	a5,a5,0x4
    800029f6:	00016597          	auipc	a1,0x16
    800029fa:	59a5a583          	lw	a1,1434(a1) # 80018f90 <sb+0x18>
    800029fe:	9dbd                	addw	a1,a1,a5
    80002a00:	4108                	lw	a0,0(a0)
    80002a02:	95dff0ef          	jal	8000235e <bread>
    80002a06:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a08:	05850793          	addi	a5,a0,88
    80002a0c:	40d8                	lw	a4,4(s1)
    80002a0e:	8b3d                	andi	a4,a4,15
    80002a10:	071a                	slli	a4,a4,0x6
    80002a12:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002a14:	04449703          	lh	a4,68(s1)
    80002a18:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002a1c:	04649703          	lh	a4,70(s1)
    80002a20:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002a24:	04849703          	lh	a4,72(s1)
    80002a28:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002a2c:	04a49703          	lh	a4,74(s1)
    80002a30:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002a34:	44f8                	lw	a4,76(s1)
    80002a36:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a38:	03400613          	li	a2,52
    80002a3c:	05048593          	addi	a1,s1,80
    80002a40:	00c78513          	addi	a0,a5,12
    80002a44:	f4cfd0ef          	jal	80000190 <memmove>
  log_write(bp);
    80002a48:	854a                	mv	a0,s2
    80002a4a:	267000ef          	jal	800034b0 <log_write>
  brelse(bp);
    80002a4e:	854a                	mv	a0,s2
    80002a50:	a17ff0ef          	jal	80002466 <brelse>
}
    80002a54:	60e2                	ld	ra,24(sp)
    80002a56:	6442                	ld	s0,16(sp)
    80002a58:	64a2                	ld	s1,8(sp)
    80002a5a:	6902                	ld	s2,0(sp)
    80002a5c:	6105                	addi	sp,sp,32
    80002a5e:	8082                	ret

0000000080002a60 <idup>:
{
    80002a60:	1101                	addi	sp,sp,-32
    80002a62:	ec06                	sd	ra,24(sp)
    80002a64:	e822                	sd	s0,16(sp)
    80002a66:	e426                	sd	s1,8(sp)
    80002a68:	1000                	addi	s0,sp,32
    80002a6a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002a6c:	00016517          	auipc	a0,0x16
    80002a70:	52c50513          	addi	a0,a0,1324 # 80018f98 <itable>
    80002a74:	0fc030ef          	jal	80005b70 <acquire>
  ip->ref++;
    80002a78:	449c                	lw	a5,8(s1)
    80002a7a:	2785                	addiw	a5,a5,1
    80002a7c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002a7e:	00016517          	auipc	a0,0x16
    80002a82:	51a50513          	addi	a0,a0,1306 # 80018f98 <itable>
    80002a86:	182030ef          	jal	80005c08 <release>
}
    80002a8a:	8526                	mv	a0,s1
    80002a8c:	60e2                	ld	ra,24(sp)
    80002a8e:	6442                	ld	s0,16(sp)
    80002a90:	64a2                	ld	s1,8(sp)
    80002a92:	6105                	addi	sp,sp,32
    80002a94:	8082                	ret

0000000080002a96 <ilock>:
{
    80002a96:	1101                	addi	sp,sp,-32
    80002a98:	ec06                	sd	ra,24(sp)
    80002a9a:	e822                	sd	s0,16(sp)
    80002a9c:	e426                	sd	s1,8(sp)
    80002a9e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002aa0:	cd19                	beqz	a0,80002abe <ilock+0x28>
    80002aa2:	84aa                	mv	s1,a0
    80002aa4:	451c                	lw	a5,8(a0)
    80002aa6:	00f05c63          	blez	a5,80002abe <ilock+0x28>
  acquiresleep(&ip->lock);
    80002aaa:	0541                	addi	a0,a0,16
    80002aac:	30b000ef          	jal	800035b6 <acquiresleep>
  if(ip->valid == 0){
    80002ab0:	40bc                	lw	a5,64(s1)
    80002ab2:	cf89                	beqz	a5,80002acc <ilock+0x36>
}
    80002ab4:	60e2                	ld	ra,24(sp)
    80002ab6:	6442                	ld	s0,16(sp)
    80002ab8:	64a2                	ld	s1,8(sp)
    80002aba:	6105                	addi	sp,sp,32
    80002abc:	8082                	ret
    80002abe:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002ac0:	00005517          	auipc	a0,0x5
    80002ac4:	b5850513          	addi	a0,a0,-1192 # 80007618 <etext+0x618>
    80002ac8:	57b020ef          	jal	80005842 <panic>
    80002acc:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ace:	40dc                	lw	a5,4(s1)
    80002ad0:	0047d79b          	srliw	a5,a5,0x4
    80002ad4:	00016597          	auipc	a1,0x16
    80002ad8:	4bc5a583          	lw	a1,1212(a1) # 80018f90 <sb+0x18>
    80002adc:	9dbd                	addw	a1,a1,a5
    80002ade:	4088                	lw	a0,0(s1)
    80002ae0:	87fff0ef          	jal	8000235e <bread>
    80002ae4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ae6:	05850593          	addi	a1,a0,88
    80002aea:	40dc                	lw	a5,4(s1)
    80002aec:	8bbd                	andi	a5,a5,15
    80002aee:	079a                	slli	a5,a5,0x6
    80002af0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002af2:	00059783          	lh	a5,0(a1)
    80002af6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002afa:	00259783          	lh	a5,2(a1)
    80002afe:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b02:	00459783          	lh	a5,4(a1)
    80002b06:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b0a:	00659783          	lh	a5,6(a1)
    80002b0e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b12:	459c                	lw	a5,8(a1)
    80002b14:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b16:	03400613          	li	a2,52
    80002b1a:	05b1                	addi	a1,a1,12
    80002b1c:	05048513          	addi	a0,s1,80
    80002b20:	e70fd0ef          	jal	80000190 <memmove>
    brelse(bp);
    80002b24:	854a                	mv	a0,s2
    80002b26:	941ff0ef          	jal	80002466 <brelse>
    ip->valid = 1;
    80002b2a:	4785                	li	a5,1
    80002b2c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b2e:	04449783          	lh	a5,68(s1)
    80002b32:	c399                	beqz	a5,80002b38 <ilock+0xa2>
    80002b34:	6902                	ld	s2,0(sp)
    80002b36:	bfbd                	j	80002ab4 <ilock+0x1e>
      panic("ilock: no type");
    80002b38:	00005517          	auipc	a0,0x5
    80002b3c:	ae850513          	addi	a0,a0,-1304 # 80007620 <etext+0x620>
    80002b40:	503020ef          	jal	80005842 <panic>

0000000080002b44 <iunlock>:
{
    80002b44:	1101                	addi	sp,sp,-32
    80002b46:	ec06                	sd	ra,24(sp)
    80002b48:	e822                	sd	s0,16(sp)
    80002b4a:	e426                	sd	s1,8(sp)
    80002b4c:	e04a                	sd	s2,0(sp)
    80002b4e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002b50:	c505                	beqz	a0,80002b78 <iunlock+0x34>
    80002b52:	84aa                	mv	s1,a0
    80002b54:	01050913          	addi	s2,a0,16
    80002b58:	854a                	mv	a0,s2
    80002b5a:	2db000ef          	jal	80003634 <holdingsleep>
    80002b5e:	cd09                	beqz	a0,80002b78 <iunlock+0x34>
    80002b60:	449c                	lw	a5,8(s1)
    80002b62:	00f05b63          	blez	a5,80002b78 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002b66:	854a                	mv	a0,s2
    80002b68:	295000ef          	jal	800035fc <releasesleep>
}
    80002b6c:	60e2                	ld	ra,24(sp)
    80002b6e:	6442                	ld	s0,16(sp)
    80002b70:	64a2                	ld	s1,8(sp)
    80002b72:	6902                	ld	s2,0(sp)
    80002b74:	6105                	addi	sp,sp,32
    80002b76:	8082                	ret
    panic("iunlock");
    80002b78:	00005517          	auipc	a0,0x5
    80002b7c:	ab850513          	addi	a0,a0,-1352 # 80007630 <etext+0x630>
    80002b80:	4c3020ef          	jal	80005842 <panic>

0000000080002b84 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002b84:	7179                	addi	sp,sp,-48
    80002b86:	f406                	sd	ra,40(sp)
    80002b88:	f022                	sd	s0,32(sp)
    80002b8a:	ec26                	sd	s1,24(sp)
    80002b8c:	e84a                	sd	s2,16(sp)
    80002b8e:	e44e                	sd	s3,8(sp)
    80002b90:	1800                	addi	s0,sp,48
    80002b92:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002b94:	05050493          	addi	s1,a0,80
    80002b98:	08050913          	addi	s2,a0,128
    80002b9c:	a021                	j	80002ba4 <itrunc+0x20>
    80002b9e:	0491                	addi	s1,s1,4
    80002ba0:	01248b63          	beq	s1,s2,80002bb6 <itrunc+0x32>
    if(ip->addrs[i]){
    80002ba4:	408c                	lw	a1,0(s1)
    80002ba6:	dde5                	beqz	a1,80002b9e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002ba8:	0009a503          	lw	a0,0(s3)
    80002bac:	9abff0ef          	jal	80002556 <bfree>
      ip->addrs[i] = 0;
    80002bb0:	0004a023          	sw	zero,0(s1)
    80002bb4:	b7ed                	j	80002b9e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002bb6:	0809a583          	lw	a1,128(s3)
    80002bba:	ed89                	bnez	a1,80002bd4 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002bbc:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002bc0:	854e                	mv	a0,s3
    80002bc2:	e21ff0ef          	jal	800029e2 <iupdate>
}
    80002bc6:	70a2                	ld	ra,40(sp)
    80002bc8:	7402                	ld	s0,32(sp)
    80002bca:	64e2                	ld	s1,24(sp)
    80002bcc:	6942                	ld	s2,16(sp)
    80002bce:	69a2                	ld	s3,8(sp)
    80002bd0:	6145                	addi	sp,sp,48
    80002bd2:	8082                	ret
    80002bd4:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002bd6:	0009a503          	lw	a0,0(s3)
    80002bda:	f84ff0ef          	jal	8000235e <bread>
    80002bde:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002be0:	05850493          	addi	s1,a0,88
    80002be4:	45850913          	addi	s2,a0,1112
    80002be8:	a021                	j	80002bf0 <itrunc+0x6c>
    80002bea:	0491                	addi	s1,s1,4
    80002bec:	01248963          	beq	s1,s2,80002bfe <itrunc+0x7a>
      if(a[j])
    80002bf0:	408c                	lw	a1,0(s1)
    80002bf2:	dde5                	beqz	a1,80002bea <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002bf4:	0009a503          	lw	a0,0(s3)
    80002bf8:	95fff0ef          	jal	80002556 <bfree>
    80002bfc:	b7fd                	j	80002bea <itrunc+0x66>
    brelse(bp);
    80002bfe:	8552                	mv	a0,s4
    80002c00:	867ff0ef          	jal	80002466 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c04:	0809a583          	lw	a1,128(s3)
    80002c08:	0009a503          	lw	a0,0(s3)
    80002c0c:	94bff0ef          	jal	80002556 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c10:	0809a023          	sw	zero,128(s3)
    80002c14:	6a02                	ld	s4,0(sp)
    80002c16:	b75d                	j	80002bbc <itrunc+0x38>

0000000080002c18 <iput>:
{
    80002c18:	1101                	addi	sp,sp,-32
    80002c1a:	ec06                	sd	ra,24(sp)
    80002c1c:	e822                	sd	s0,16(sp)
    80002c1e:	e426                	sd	s1,8(sp)
    80002c20:	1000                	addi	s0,sp,32
    80002c22:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c24:	00016517          	auipc	a0,0x16
    80002c28:	37450513          	addi	a0,a0,884 # 80018f98 <itable>
    80002c2c:	745020ef          	jal	80005b70 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002c30:	4498                	lw	a4,8(s1)
    80002c32:	4785                	li	a5,1
    80002c34:	02f70063          	beq	a4,a5,80002c54 <iput+0x3c>
  ip->ref--;
    80002c38:	449c                	lw	a5,8(s1)
    80002c3a:	37fd                	addiw	a5,a5,-1
    80002c3c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c3e:	00016517          	auipc	a0,0x16
    80002c42:	35a50513          	addi	a0,a0,858 # 80018f98 <itable>
    80002c46:	7c3020ef          	jal	80005c08 <release>
}
    80002c4a:	60e2                	ld	ra,24(sp)
    80002c4c:	6442                	ld	s0,16(sp)
    80002c4e:	64a2                	ld	s1,8(sp)
    80002c50:	6105                	addi	sp,sp,32
    80002c52:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002c54:	40bc                	lw	a5,64(s1)
    80002c56:	d3ed                	beqz	a5,80002c38 <iput+0x20>
    80002c58:	04a49783          	lh	a5,74(s1)
    80002c5c:	fff1                	bnez	a5,80002c38 <iput+0x20>
    80002c5e:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002c60:	01048913          	addi	s2,s1,16
    80002c64:	854a                	mv	a0,s2
    80002c66:	151000ef          	jal	800035b6 <acquiresleep>
    release(&itable.lock);
    80002c6a:	00016517          	auipc	a0,0x16
    80002c6e:	32e50513          	addi	a0,a0,814 # 80018f98 <itable>
    80002c72:	797020ef          	jal	80005c08 <release>
    itrunc(ip);
    80002c76:	8526                	mv	a0,s1
    80002c78:	f0dff0ef          	jal	80002b84 <itrunc>
    ip->type = 0;
    80002c7c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002c80:	8526                	mv	a0,s1
    80002c82:	d61ff0ef          	jal	800029e2 <iupdate>
    ip->valid = 0;
    80002c86:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002c8a:	854a                	mv	a0,s2
    80002c8c:	171000ef          	jal	800035fc <releasesleep>
    acquire(&itable.lock);
    80002c90:	00016517          	auipc	a0,0x16
    80002c94:	30850513          	addi	a0,a0,776 # 80018f98 <itable>
    80002c98:	6d9020ef          	jal	80005b70 <acquire>
    80002c9c:	6902                	ld	s2,0(sp)
    80002c9e:	bf69                	j	80002c38 <iput+0x20>

0000000080002ca0 <iunlockput>:
{
    80002ca0:	1101                	addi	sp,sp,-32
    80002ca2:	ec06                	sd	ra,24(sp)
    80002ca4:	e822                	sd	s0,16(sp)
    80002ca6:	e426                	sd	s1,8(sp)
    80002ca8:	1000                	addi	s0,sp,32
    80002caa:	84aa                	mv	s1,a0
  iunlock(ip);
    80002cac:	e99ff0ef          	jal	80002b44 <iunlock>
  iput(ip);
    80002cb0:	8526                	mv	a0,s1
    80002cb2:	f67ff0ef          	jal	80002c18 <iput>
}
    80002cb6:	60e2                	ld	ra,24(sp)
    80002cb8:	6442                	ld	s0,16(sp)
    80002cba:	64a2                	ld	s1,8(sp)
    80002cbc:	6105                	addi	sp,sp,32
    80002cbe:	8082                	ret

0000000080002cc0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002cc0:	1141                	addi	sp,sp,-16
    80002cc2:	e422                	sd	s0,8(sp)
    80002cc4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002cc6:	411c                	lw	a5,0(a0)
    80002cc8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002cca:	415c                	lw	a5,4(a0)
    80002ccc:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002cce:	04451783          	lh	a5,68(a0)
    80002cd2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002cd6:	04a51783          	lh	a5,74(a0)
    80002cda:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002cde:	04c56783          	lwu	a5,76(a0)
    80002ce2:	e99c                	sd	a5,16(a1)
}
    80002ce4:	6422                	ld	s0,8(sp)
    80002ce6:	0141                	addi	sp,sp,16
    80002ce8:	8082                	ret

0000000080002cea <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002cea:	457c                	lw	a5,76(a0)
    80002cec:	0ed7eb63          	bltu	a5,a3,80002de2 <readi+0xf8>
{
    80002cf0:	7159                	addi	sp,sp,-112
    80002cf2:	f486                	sd	ra,104(sp)
    80002cf4:	f0a2                	sd	s0,96(sp)
    80002cf6:	eca6                	sd	s1,88(sp)
    80002cf8:	e0d2                	sd	s4,64(sp)
    80002cfa:	fc56                	sd	s5,56(sp)
    80002cfc:	f85a                	sd	s6,48(sp)
    80002cfe:	f45e                	sd	s7,40(sp)
    80002d00:	1880                	addi	s0,sp,112
    80002d02:	8b2a                	mv	s6,a0
    80002d04:	8bae                	mv	s7,a1
    80002d06:	8a32                	mv	s4,a2
    80002d08:	84b6                	mv	s1,a3
    80002d0a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002d0c:	9f35                	addw	a4,a4,a3
    return 0;
    80002d0e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002d10:	0cd76063          	bltu	a4,a3,80002dd0 <readi+0xe6>
    80002d14:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002d16:	00e7f463          	bgeu	a5,a4,80002d1e <readi+0x34>
    n = ip->size - off;
    80002d1a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d1e:	080a8f63          	beqz	s5,80002dbc <readi+0xd2>
    80002d22:	e8ca                	sd	s2,80(sp)
    80002d24:	f062                	sd	s8,32(sp)
    80002d26:	ec66                	sd	s9,24(sp)
    80002d28:	e86a                	sd	s10,16(sp)
    80002d2a:	e46e                	sd	s11,8(sp)
    80002d2c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002d2e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002d32:	5c7d                	li	s8,-1
    80002d34:	a80d                	j	80002d66 <readi+0x7c>
    80002d36:	020d1d93          	slli	s11,s10,0x20
    80002d3a:	020ddd93          	srli	s11,s11,0x20
    80002d3e:	05890613          	addi	a2,s2,88
    80002d42:	86ee                	mv	a3,s11
    80002d44:	963a                	add	a2,a2,a4
    80002d46:	85d2                	mv	a1,s4
    80002d48:	855e                	mv	a0,s7
    80002d4a:	943fe0ef          	jal	8000168c <either_copyout>
    80002d4e:	05850763          	beq	a0,s8,80002d9c <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002d52:	854a                	mv	a0,s2
    80002d54:	f12ff0ef          	jal	80002466 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d58:	013d09bb          	addw	s3,s10,s3
    80002d5c:	009d04bb          	addw	s1,s10,s1
    80002d60:	9a6e                	add	s4,s4,s11
    80002d62:	0559f763          	bgeu	s3,s5,80002db0 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002d66:	00a4d59b          	srliw	a1,s1,0xa
    80002d6a:	855a                	mv	a0,s6
    80002d6c:	977ff0ef          	jal	800026e2 <bmap>
    80002d70:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002d74:	c5b1                	beqz	a1,80002dc0 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002d76:	000b2503          	lw	a0,0(s6)
    80002d7a:	de4ff0ef          	jal	8000235e <bread>
    80002d7e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002d80:	3ff4f713          	andi	a4,s1,1023
    80002d84:	40ec87bb          	subw	a5,s9,a4
    80002d88:	413a86bb          	subw	a3,s5,s3
    80002d8c:	8d3e                	mv	s10,a5
    80002d8e:	2781                	sext.w	a5,a5
    80002d90:	0006861b          	sext.w	a2,a3
    80002d94:	faf671e3          	bgeu	a2,a5,80002d36 <readi+0x4c>
    80002d98:	8d36                	mv	s10,a3
    80002d9a:	bf71                	j	80002d36 <readi+0x4c>
      brelse(bp);
    80002d9c:	854a                	mv	a0,s2
    80002d9e:	ec8ff0ef          	jal	80002466 <brelse>
      tot = -1;
    80002da2:	59fd                	li	s3,-1
      break;
    80002da4:	6946                	ld	s2,80(sp)
    80002da6:	7c02                	ld	s8,32(sp)
    80002da8:	6ce2                	ld	s9,24(sp)
    80002daa:	6d42                	ld	s10,16(sp)
    80002dac:	6da2                	ld	s11,8(sp)
    80002dae:	a831                	j	80002dca <readi+0xe0>
    80002db0:	6946                	ld	s2,80(sp)
    80002db2:	7c02                	ld	s8,32(sp)
    80002db4:	6ce2                	ld	s9,24(sp)
    80002db6:	6d42                	ld	s10,16(sp)
    80002db8:	6da2                	ld	s11,8(sp)
    80002dba:	a801                	j	80002dca <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002dbc:	89d6                	mv	s3,s5
    80002dbe:	a031                	j	80002dca <readi+0xe0>
    80002dc0:	6946                	ld	s2,80(sp)
    80002dc2:	7c02                	ld	s8,32(sp)
    80002dc4:	6ce2                	ld	s9,24(sp)
    80002dc6:	6d42                	ld	s10,16(sp)
    80002dc8:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002dca:	0009851b          	sext.w	a0,s3
    80002dce:	69a6                	ld	s3,72(sp)
}
    80002dd0:	70a6                	ld	ra,104(sp)
    80002dd2:	7406                	ld	s0,96(sp)
    80002dd4:	64e6                	ld	s1,88(sp)
    80002dd6:	6a06                	ld	s4,64(sp)
    80002dd8:	7ae2                	ld	s5,56(sp)
    80002dda:	7b42                	ld	s6,48(sp)
    80002ddc:	7ba2                	ld	s7,40(sp)
    80002dde:	6165                	addi	sp,sp,112
    80002de0:	8082                	ret
    return 0;
    80002de2:	4501                	li	a0,0
}
    80002de4:	8082                	ret

0000000080002de6 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002de6:	457c                	lw	a5,76(a0)
    80002de8:	10d7e063          	bltu	a5,a3,80002ee8 <writei+0x102>
{
    80002dec:	7159                	addi	sp,sp,-112
    80002dee:	f486                	sd	ra,104(sp)
    80002df0:	f0a2                	sd	s0,96(sp)
    80002df2:	e8ca                	sd	s2,80(sp)
    80002df4:	e0d2                	sd	s4,64(sp)
    80002df6:	fc56                	sd	s5,56(sp)
    80002df8:	f85a                	sd	s6,48(sp)
    80002dfa:	f45e                	sd	s7,40(sp)
    80002dfc:	1880                	addi	s0,sp,112
    80002dfe:	8aaa                	mv	s5,a0
    80002e00:	8bae                	mv	s7,a1
    80002e02:	8a32                	mv	s4,a2
    80002e04:	8936                	mv	s2,a3
    80002e06:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e08:	00e687bb          	addw	a5,a3,a4
    80002e0c:	0ed7e063          	bltu	a5,a3,80002eec <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002e10:	00043737          	lui	a4,0x43
    80002e14:	0cf76e63          	bltu	a4,a5,80002ef0 <writei+0x10a>
    80002e18:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e1a:	0a0b0f63          	beqz	s6,80002ed8 <writei+0xf2>
    80002e1e:	eca6                	sd	s1,88(sp)
    80002e20:	f062                	sd	s8,32(sp)
    80002e22:	ec66                	sd	s9,24(sp)
    80002e24:	e86a                	sd	s10,16(sp)
    80002e26:	e46e                	sd	s11,8(sp)
    80002e28:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e2a:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002e2e:	5c7d                	li	s8,-1
    80002e30:	a825                	j	80002e68 <writei+0x82>
    80002e32:	020d1d93          	slli	s11,s10,0x20
    80002e36:	020ddd93          	srli	s11,s11,0x20
    80002e3a:	05848513          	addi	a0,s1,88
    80002e3e:	86ee                	mv	a3,s11
    80002e40:	8652                	mv	a2,s4
    80002e42:	85de                	mv	a1,s7
    80002e44:	953a                	add	a0,a0,a4
    80002e46:	891fe0ef          	jal	800016d6 <either_copyin>
    80002e4a:	05850a63          	beq	a0,s8,80002e9e <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002e4e:	8526                	mv	a0,s1
    80002e50:	660000ef          	jal	800034b0 <log_write>
    brelse(bp);
    80002e54:	8526                	mv	a0,s1
    80002e56:	e10ff0ef          	jal	80002466 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e5a:	013d09bb          	addw	s3,s10,s3
    80002e5e:	012d093b          	addw	s2,s10,s2
    80002e62:	9a6e                	add	s4,s4,s11
    80002e64:	0569f063          	bgeu	s3,s6,80002ea4 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002e68:	00a9559b          	srliw	a1,s2,0xa
    80002e6c:	8556                	mv	a0,s5
    80002e6e:	875ff0ef          	jal	800026e2 <bmap>
    80002e72:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e76:	c59d                	beqz	a1,80002ea4 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002e78:	000aa503          	lw	a0,0(s5)
    80002e7c:	ce2ff0ef          	jal	8000235e <bread>
    80002e80:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e82:	3ff97713          	andi	a4,s2,1023
    80002e86:	40ec87bb          	subw	a5,s9,a4
    80002e8a:	413b06bb          	subw	a3,s6,s3
    80002e8e:	8d3e                	mv	s10,a5
    80002e90:	2781                	sext.w	a5,a5
    80002e92:	0006861b          	sext.w	a2,a3
    80002e96:	f8f67ee3          	bgeu	a2,a5,80002e32 <writei+0x4c>
    80002e9a:	8d36                	mv	s10,a3
    80002e9c:	bf59                	j	80002e32 <writei+0x4c>
      brelse(bp);
    80002e9e:	8526                	mv	a0,s1
    80002ea0:	dc6ff0ef          	jal	80002466 <brelse>
  }

  if(off > ip->size)
    80002ea4:	04caa783          	lw	a5,76(s5)
    80002ea8:	0327fa63          	bgeu	a5,s2,80002edc <writei+0xf6>
    ip->size = off;
    80002eac:	052aa623          	sw	s2,76(s5)
    80002eb0:	64e6                	ld	s1,88(sp)
    80002eb2:	7c02                	ld	s8,32(sp)
    80002eb4:	6ce2                	ld	s9,24(sp)
    80002eb6:	6d42                	ld	s10,16(sp)
    80002eb8:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002eba:	8556                	mv	a0,s5
    80002ebc:	b27ff0ef          	jal	800029e2 <iupdate>

  return tot;
    80002ec0:	0009851b          	sext.w	a0,s3
    80002ec4:	69a6                	ld	s3,72(sp)
}
    80002ec6:	70a6                	ld	ra,104(sp)
    80002ec8:	7406                	ld	s0,96(sp)
    80002eca:	6946                	ld	s2,80(sp)
    80002ecc:	6a06                	ld	s4,64(sp)
    80002ece:	7ae2                	ld	s5,56(sp)
    80002ed0:	7b42                	ld	s6,48(sp)
    80002ed2:	7ba2                	ld	s7,40(sp)
    80002ed4:	6165                	addi	sp,sp,112
    80002ed6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ed8:	89da                	mv	s3,s6
    80002eda:	b7c5                	j	80002eba <writei+0xd4>
    80002edc:	64e6                	ld	s1,88(sp)
    80002ede:	7c02                	ld	s8,32(sp)
    80002ee0:	6ce2                	ld	s9,24(sp)
    80002ee2:	6d42                	ld	s10,16(sp)
    80002ee4:	6da2                	ld	s11,8(sp)
    80002ee6:	bfd1                	j	80002eba <writei+0xd4>
    return -1;
    80002ee8:	557d                	li	a0,-1
}
    80002eea:	8082                	ret
    return -1;
    80002eec:	557d                	li	a0,-1
    80002eee:	bfe1                	j	80002ec6 <writei+0xe0>
    return -1;
    80002ef0:	557d                	li	a0,-1
    80002ef2:	bfd1                	j	80002ec6 <writei+0xe0>

0000000080002ef4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002ef4:	1141                	addi	sp,sp,-16
    80002ef6:	e406                	sd	ra,8(sp)
    80002ef8:	e022                	sd	s0,0(sp)
    80002efa:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002efc:	4639                	li	a2,14
    80002efe:	b02fd0ef          	jal	80000200 <strncmp>
}
    80002f02:	60a2                	ld	ra,8(sp)
    80002f04:	6402                	ld	s0,0(sp)
    80002f06:	0141                	addi	sp,sp,16
    80002f08:	8082                	ret

0000000080002f0a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002f0a:	7139                	addi	sp,sp,-64
    80002f0c:	fc06                	sd	ra,56(sp)
    80002f0e:	f822                	sd	s0,48(sp)
    80002f10:	f426                	sd	s1,40(sp)
    80002f12:	f04a                	sd	s2,32(sp)
    80002f14:	ec4e                	sd	s3,24(sp)
    80002f16:	e852                	sd	s4,16(sp)
    80002f18:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002f1a:	04451703          	lh	a4,68(a0)
    80002f1e:	4785                	li	a5,1
    80002f20:	00f71a63          	bne	a4,a5,80002f34 <dirlookup+0x2a>
    80002f24:	892a                	mv	s2,a0
    80002f26:	89ae                	mv	s3,a1
    80002f28:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f2a:	457c                	lw	a5,76(a0)
    80002f2c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002f2e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f30:	e39d                	bnez	a5,80002f56 <dirlookup+0x4c>
    80002f32:	a095                	j	80002f96 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002f34:	00004517          	auipc	a0,0x4
    80002f38:	70450513          	addi	a0,a0,1796 # 80007638 <etext+0x638>
    80002f3c:	107020ef          	jal	80005842 <panic>
      panic("dirlookup read");
    80002f40:	00004517          	auipc	a0,0x4
    80002f44:	71050513          	addi	a0,a0,1808 # 80007650 <etext+0x650>
    80002f48:	0fb020ef          	jal	80005842 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f4c:	24c1                	addiw	s1,s1,16
    80002f4e:	04c92783          	lw	a5,76(s2)
    80002f52:	04f4f163          	bgeu	s1,a5,80002f94 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002f56:	4741                	li	a4,16
    80002f58:	86a6                	mv	a3,s1
    80002f5a:	fc040613          	addi	a2,s0,-64
    80002f5e:	4581                	li	a1,0
    80002f60:	854a                	mv	a0,s2
    80002f62:	d89ff0ef          	jal	80002cea <readi>
    80002f66:	47c1                	li	a5,16
    80002f68:	fcf51ce3          	bne	a0,a5,80002f40 <dirlookup+0x36>
    if(de.inum == 0)
    80002f6c:	fc045783          	lhu	a5,-64(s0)
    80002f70:	dff1                	beqz	a5,80002f4c <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002f72:	fc240593          	addi	a1,s0,-62
    80002f76:	854e                	mv	a0,s3
    80002f78:	f7dff0ef          	jal	80002ef4 <namecmp>
    80002f7c:	f961                	bnez	a0,80002f4c <dirlookup+0x42>
      if(poff)
    80002f7e:	000a0463          	beqz	s4,80002f86 <dirlookup+0x7c>
        *poff = off;
    80002f82:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002f86:	fc045583          	lhu	a1,-64(s0)
    80002f8a:	00092503          	lw	a0,0(s2)
    80002f8e:	829ff0ef          	jal	800027b6 <iget>
    80002f92:	a011                	j	80002f96 <dirlookup+0x8c>
  return 0;
    80002f94:	4501                	li	a0,0
}
    80002f96:	70e2                	ld	ra,56(sp)
    80002f98:	7442                	ld	s0,48(sp)
    80002f9a:	74a2                	ld	s1,40(sp)
    80002f9c:	7902                	ld	s2,32(sp)
    80002f9e:	69e2                	ld	s3,24(sp)
    80002fa0:	6a42                	ld	s4,16(sp)
    80002fa2:	6121                	addi	sp,sp,64
    80002fa4:	8082                	ret

0000000080002fa6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002fa6:	711d                	addi	sp,sp,-96
    80002fa8:	ec86                	sd	ra,88(sp)
    80002faa:	e8a2                	sd	s0,80(sp)
    80002fac:	e4a6                	sd	s1,72(sp)
    80002fae:	e0ca                	sd	s2,64(sp)
    80002fb0:	fc4e                	sd	s3,56(sp)
    80002fb2:	f852                	sd	s4,48(sp)
    80002fb4:	f456                	sd	s5,40(sp)
    80002fb6:	f05a                	sd	s6,32(sp)
    80002fb8:	ec5e                	sd	s7,24(sp)
    80002fba:	e862                	sd	s8,16(sp)
    80002fbc:	e466                	sd	s9,8(sp)
    80002fbe:	1080                	addi	s0,sp,96
    80002fc0:	84aa                	mv	s1,a0
    80002fc2:	8b2e                	mv	s6,a1
    80002fc4:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002fc6:	00054703          	lbu	a4,0(a0)
    80002fca:	02f00793          	li	a5,47
    80002fce:	00f70e63          	beq	a4,a5,80002fea <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002fd2:	d85fd0ef          	jal	80000d56 <myproc>
    80002fd6:	15053503          	ld	a0,336(a0)
    80002fda:	a87ff0ef          	jal	80002a60 <idup>
    80002fde:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002fe0:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002fe4:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002fe6:	4b85                	li	s7,1
    80002fe8:	a871                	j	80003084 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002fea:	4585                	li	a1,1
    80002fec:	4505                	li	a0,1
    80002fee:	fc8ff0ef          	jal	800027b6 <iget>
    80002ff2:	8a2a                	mv	s4,a0
    80002ff4:	b7f5                	j	80002fe0 <namex+0x3a>
      iunlockput(ip);
    80002ff6:	8552                	mv	a0,s4
    80002ff8:	ca9ff0ef          	jal	80002ca0 <iunlockput>
      return 0;
    80002ffc:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002ffe:	8552                	mv	a0,s4
    80003000:	60e6                	ld	ra,88(sp)
    80003002:	6446                	ld	s0,80(sp)
    80003004:	64a6                	ld	s1,72(sp)
    80003006:	6906                	ld	s2,64(sp)
    80003008:	79e2                	ld	s3,56(sp)
    8000300a:	7a42                	ld	s4,48(sp)
    8000300c:	7aa2                	ld	s5,40(sp)
    8000300e:	7b02                	ld	s6,32(sp)
    80003010:	6be2                	ld	s7,24(sp)
    80003012:	6c42                	ld	s8,16(sp)
    80003014:	6ca2                	ld	s9,8(sp)
    80003016:	6125                	addi	sp,sp,96
    80003018:	8082                	ret
      iunlock(ip);
    8000301a:	8552                	mv	a0,s4
    8000301c:	b29ff0ef          	jal	80002b44 <iunlock>
      return ip;
    80003020:	bff9                	j	80002ffe <namex+0x58>
      iunlockput(ip);
    80003022:	8552                	mv	a0,s4
    80003024:	c7dff0ef          	jal	80002ca0 <iunlockput>
      return 0;
    80003028:	8a4e                	mv	s4,s3
    8000302a:	bfd1                	j	80002ffe <namex+0x58>
  len = path - s;
    8000302c:	40998633          	sub	a2,s3,s1
    80003030:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003034:	099c5063          	bge	s8,s9,800030b4 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003038:	4639                	li	a2,14
    8000303a:	85a6                	mv	a1,s1
    8000303c:	8556                	mv	a0,s5
    8000303e:	952fd0ef          	jal	80000190 <memmove>
    80003042:	84ce                	mv	s1,s3
  while(*path == '/')
    80003044:	0004c783          	lbu	a5,0(s1)
    80003048:	01279763          	bne	a5,s2,80003056 <namex+0xb0>
    path++;
    8000304c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000304e:	0004c783          	lbu	a5,0(s1)
    80003052:	ff278de3          	beq	a5,s2,8000304c <namex+0xa6>
    ilock(ip);
    80003056:	8552                	mv	a0,s4
    80003058:	a3fff0ef          	jal	80002a96 <ilock>
    if(ip->type != T_DIR){
    8000305c:	044a1783          	lh	a5,68(s4)
    80003060:	f9779be3          	bne	a5,s7,80002ff6 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003064:	000b0563          	beqz	s6,8000306e <namex+0xc8>
    80003068:	0004c783          	lbu	a5,0(s1)
    8000306c:	d7dd                	beqz	a5,8000301a <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000306e:	4601                	li	a2,0
    80003070:	85d6                	mv	a1,s5
    80003072:	8552                	mv	a0,s4
    80003074:	e97ff0ef          	jal	80002f0a <dirlookup>
    80003078:	89aa                	mv	s3,a0
    8000307a:	d545                	beqz	a0,80003022 <namex+0x7c>
    iunlockput(ip);
    8000307c:	8552                	mv	a0,s4
    8000307e:	c23ff0ef          	jal	80002ca0 <iunlockput>
    ip = next;
    80003082:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003084:	0004c783          	lbu	a5,0(s1)
    80003088:	01279763          	bne	a5,s2,80003096 <namex+0xf0>
    path++;
    8000308c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000308e:	0004c783          	lbu	a5,0(s1)
    80003092:	ff278de3          	beq	a5,s2,8000308c <namex+0xe6>
  if(*path == 0)
    80003096:	cb8d                	beqz	a5,800030c8 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003098:	0004c783          	lbu	a5,0(s1)
    8000309c:	89a6                	mv	s3,s1
  len = path - s;
    8000309e:	4c81                	li	s9,0
    800030a0:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800030a2:	01278963          	beq	a5,s2,800030b4 <namex+0x10e>
    800030a6:	d3d9                	beqz	a5,8000302c <namex+0x86>
    path++;
    800030a8:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800030aa:	0009c783          	lbu	a5,0(s3)
    800030ae:	ff279ce3          	bne	a5,s2,800030a6 <namex+0x100>
    800030b2:	bfad                	j	8000302c <namex+0x86>
    memmove(name, s, len);
    800030b4:	2601                	sext.w	a2,a2
    800030b6:	85a6                	mv	a1,s1
    800030b8:	8556                	mv	a0,s5
    800030ba:	8d6fd0ef          	jal	80000190 <memmove>
    name[len] = 0;
    800030be:	9cd6                	add	s9,s9,s5
    800030c0:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800030c4:	84ce                	mv	s1,s3
    800030c6:	bfbd                	j	80003044 <namex+0x9e>
  if(nameiparent){
    800030c8:	f20b0be3          	beqz	s6,80002ffe <namex+0x58>
    iput(ip);
    800030cc:	8552                	mv	a0,s4
    800030ce:	b4bff0ef          	jal	80002c18 <iput>
    return 0;
    800030d2:	4a01                	li	s4,0
    800030d4:	b72d                	j	80002ffe <namex+0x58>

00000000800030d6 <dirlink>:
{
    800030d6:	7139                	addi	sp,sp,-64
    800030d8:	fc06                	sd	ra,56(sp)
    800030da:	f822                	sd	s0,48(sp)
    800030dc:	f04a                	sd	s2,32(sp)
    800030de:	ec4e                	sd	s3,24(sp)
    800030e0:	e852                	sd	s4,16(sp)
    800030e2:	0080                	addi	s0,sp,64
    800030e4:	892a                	mv	s2,a0
    800030e6:	8a2e                	mv	s4,a1
    800030e8:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800030ea:	4601                	li	a2,0
    800030ec:	e1fff0ef          	jal	80002f0a <dirlookup>
    800030f0:	e535                	bnez	a0,8000315c <dirlink+0x86>
    800030f2:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030f4:	04c92483          	lw	s1,76(s2)
    800030f8:	c48d                	beqz	s1,80003122 <dirlink+0x4c>
    800030fa:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030fc:	4741                	li	a4,16
    800030fe:	86a6                	mv	a3,s1
    80003100:	fc040613          	addi	a2,s0,-64
    80003104:	4581                	li	a1,0
    80003106:	854a                	mv	a0,s2
    80003108:	be3ff0ef          	jal	80002cea <readi>
    8000310c:	47c1                	li	a5,16
    8000310e:	04f51b63          	bne	a0,a5,80003164 <dirlink+0x8e>
    if(de.inum == 0)
    80003112:	fc045783          	lhu	a5,-64(s0)
    80003116:	c791                	beqz	a5,80003122 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003118:	24c1                	addiw	s1,s1,16
    8000311a:	04c92783          	lw	a5,76(s2)
    8000311e:	fcf4efe3          	bltu	s1,a5,800030fc <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003122:	4639                	li	a2,14
    80003124:	85d2                	mv	a1,s4
    80003126:	fc240513          	addi	a0,s0,-62
    8000312a:	90cfd0ef          	jal	80000236 <strncpy>
  de.inum = inum;
    8000312e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003132:	4741                	li	a4,16
    80003134:	86a6                	mv	a3,s1
    80003136:	fc040613          	addi	a2,s0,-64
    8000313a:	4581                	li	a1,0
    8000313c:	854a                	mv	a0,s2
    8000313e:	ca9ff0ef          	jal	80002de6 <writei>
    80003142:	1541                	addi	a0,a0,-16
    80003144:	00a03533          	snez	a0,a0
    80003148:	40a00533          	neg	a0,a0
    8000314c:	74a2                	ld	s1,40(sp)
}
    8000314e:	70e2                	ld	ra,56(sp)
    80003150:	7442                	ld	s0,48(sp)
    80003152:	7902                	ld	s2,32(sp)
    80003154:	69e2                	ld	s3,24(sp)
    80003156:	6a42                	ld	s4,16(sp)
    80003158:	6121                	addi	sp,sp,64
    8000315a:	8082                	ret
    iput(ip);
    8000315c:	abdff0ef          	jal	80002c18 <iput>
    return -1;
    80003160:	557d                	li	a0,-1
    80003162:	b7f5                	j	8000314e <dirlink+0x78>
      panic("dirlink read");
    80003164:	00004517          	auipc	a0,0x4
    80003168:	4fc50513          	addi	a0,a0,1276 # 80007660 <etext+0x660>
    8000316c:	6d6020ef          	jal	80005842 <panic>

0000000080003170 <namei>:

struct inode*
namei(char *path)
{
    80003170:	1101                	addi	sp,sp,-32
    80003172:	ec06                	sd	ra,24(sp)
    80003174:	e822                	sd	s0,16(sp)
    80003176:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003178:	fe040613          	addi	a2,s0,-32
    8000317c:	4581                	li	a1,0
    8000317e:	e29ff0ef          	jal	80002fa6 <namex>
}
    80003182:	60e2                	ld	ra,24(sp)
    80003184:	6442                	ld	s0,16(sp)
    80003186:	6105                	addi	sp,sp,32
    80003188:	8082                	ret

000000008000318a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000318a:	1141                	addi	sp,sp,-16
    8000318c:	e406                	sd	ra,8(sp)
    8000318e:	e022                	sd	s0,0(sp)
    80003190:	0800                	addi	s0,sp,16
    80003192:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003194:	4585                	li	a1,1
    80003196:	e11ff0ef          	jal	80002fa6 <namex>
}
    8000319a:	60a2                	ld	ra,8(sp)
    8000319c:	6402                	ld	s0,0(sp)
    8000319e:	0141                	addi	sp,sp,16
    800031a0:	8082                	ret

00000000800031a2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800031a2:	1101                	addi	sp,sp,-32
    800031a4:	ec06                	sd	ra,24(sp)
    800031a6:	e822                	sd	s0,16(sp)
    800031a8:	e426                	sd	s1,8(sp)
    800031aa:	e04a                	sd	s2,0(sp)
    800031ac:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800031ae:	00018917          	auipc	s2,0x18
    800031b2:	89290913          	addi	s2,s2,-1902 # 8001aa40 <log>
    800031b6:	01892583          	lw	a1,24(s2)
    800031ba:	02892503          	lw	a0,40(s2)
    800031be:	9a0ff0ef          	jal	8000235e <bread>
    800031c2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800031c4:	02c92603          	lw	a2,44(s2)
    800031c8:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800031ca:	00c05f63          	blez	a2,800031e8 <write_head+0x46>
    800031ce:	00018717          	auipc	a4,0x18
    800031d2:	8a270713          	addi	a4,a4,-1886 # 8001aa70 <log+0x30>
    800031d6:	87aa                	mv	a5,a0
    800031d8:	060a                	slli	a2,a2,0x2
    800031da:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800031dc:	4314                	lw	a3,0(a4)
    800031de:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800031e0:	0711                	addi	a4,a4,4
    800031e2:	0791                	addi	a5,a5,4
    800031e4:	fec79ce3          	bne	a5,a2,800031dc <write_head+0x3a>
  }
  bwrite(buf);
    800031e8:	8526                	mv	a0,s1
    800031ea:	a4aff0ef          	jal	80002434 <bwrite>
  brelse(buf);
    800031ee:	8526                	mv	a0,s1
    800031f0:	a76ff0ef          	jal	80002466 <brelse>
}
    800031f4:	60e2                	ld	ra,24(sp)
    800031f6:	6442                	ld	s0,16(sp)
    800031f8:	64a2                	ld	s1,8(sp)
    800031fa:	6902                	ld	s2,0(sp)
    800031fc:	6105                	addi	sp,sp,32
    800031fe:	8082                	ret

0000000080003200 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003200:	00018797          	auipc	a5,0x18
    80003204:	86c7a783          	lw	a5,-1940(a5) # 8001aa6c <log+0x2c>
    80003208:	08f05f63          	blez	a5,800032a6 <install_trans+0xa6>
{
    8000320c:	7139                	addi	sp,sp,-64
    8000320e:	fc06                	sd	ra,56(sp)
    80003210:	f822                	sd	s0,48(sp)
    80003212:	f426                	sd	s1,40(sp)
    80003214:	f04a                	sd	s2,32(sp)
    80003216:	ec4e                	sd	s3,24(sp)
    80003218:	e852                	sd	s4,16(sp)
    8000321a:	e456                	sd	s5,8(sp)
    8000321c:	e05a                	sd	s6,0(sp)
    8000321e:	0080                	addi	s0,sp,64
    80003220:	8b2a                	mv	s6,a0
    80003222:	00018a97          	auipc	s5,0x18
    80003226:	84ea8a93          	addi	s5,s5,-1970 # 8001aa70 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000322a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000322c:	00018997          	auipc	s3,0x18
    80003230:	81498993          	addi	s3,s3,-2028 # 8001aa40 <log>
    80003234:	a829                	j	8000324e <install_trans+0x4e>
    brelse(lbuf);
    80003236:	854a                	mv	a0,s2
    80003238:	a2eff0ef          	jal	80002466 <brelse>
    brelse(dbuf);
    8000323c:	8526                	mv	a0,s1
    8000323e:	a28ff0ef          	jal	80002466 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003242:	2a05                	addiw	s4,s4,1
    80003244:	0a91                	addi	s5,s5,4
    80003246:	02c9a783          	lw	a5,44(s3)
    8000324a:	04fa5463          	bge	s4,a5,80003292 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000324e:	0189a583          	lw	a1,24(s3)
    80003252:	014585bb          	addw	a1,a1,s4
    80003256:	2585                	addiw	a1,a1,1
    80003258:	0289a503          	lw	a0,40(s3)
    8000325c:	902ff0ef          	jal	8000235e <bread>
    80003260:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003262:	000aa583          	lw	a1,0(s5)
    80003266:	0289a503          	lw	a0,40(s3)
    8000326a:	8f4ff0ef          	jal	8000235e <bread>
    8000326e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003270:	40000613          	li	a2,1024
    80003274:	05890593          	addi	a1,s2,88
    80003278:	05850513          	addi	a0,a0,88
    8000327c:	f15fc0ef          	jal	80000190 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003280:	8526                	mv	a0,s1
    80003282:	9b2ff0ef          	jal	80002434 <bwrite>
    if(recovering == 0)
    80003286:	fa0b18e3          	bnez	s6,80003236 <install_trans+0x36>
      bunpin(dbuf);
    8000328a:	8526                	mv	a0,s1
    8000328c:	a96ff0ef          	jal	80002522 <bunpin>
    80003290:	b75d                	j	80003236 <install_trans+0x36>
}
    80003292:	70e2                	ld	ra,56(sp)
    80003294:	7442                	ld	s0,48(sp)
    80003296:	74a2                	ld	s1,40(sp)
    80003298:	7902                	ld	s2,32(sp)
    8000329a:	69e2                	ld	s3,24(sp)
    8000329c:	6a42                	ld	s4,16(sp)
    8000329e:	6aa2                	ld	s5,8(sp)
    800032a0:	6b02                	ld	s6,0(sp)
    800032a2:	6121                	addi	sp,sp,64
    800032a4:	8082                	ret
    800032a6:	8082                	ret

00000000800032a8 <initlog>:
{
    800032a8:	7179                	addi	sp,sp,-48
    800032aa:	f406                	sd	ra,40(sp)
    800032ac:	f022                	sd	s0,32(sp)
    800032ae:	ec26                	sd	s1,24(sp)
    800032b0:	e84a                	sd	s2,16(sp)
    800032b2:	e44e                	sd	s3,8(sp)
    800032b4:	1800                	addi	s0,sp,48
    800032b6:	892a                	mv	s2,a0
    800032b8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800032ba:	00017497          	auipc	s1,0x17
    800032be:	78648493          	addi	s1,s1,1926 # 8001aa40 <log>
    800032c2:	00004597          	auipc	a1,0x4
    800032c6:	3ae58593          	addi	a1,a1,942 # 80007670 <etext+0x670>
    800032ca:	8526                	mv	a0,s1
    800032cc:	025020ef          	jal	80005af0 <initlock>
  log.start = sb->logstart;
    800032d0:	0149a583          	lw	a1,20(s3)
    800032d4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800032d6:	0109a783          	lw	a5,16(s3)
    800032da:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800032dc:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800032e0:	854a                	mv	a0,s2
    800032e2:	87cff0ef          	jal	8000235e <bread>
  log.lh.n = lh->n;
    800032e6:	4d30                	lw	a2,88(a0)
    800032e8:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800032ea:	00c05f63          	blez	a2,80003308 <initlog+0x60>
    800032ee:	87aa                	mv	a5,a0
    800032f0:	00017717          	auipc	a4,0x17
    800032f4:	78070713          	addi	a4,a4,1920 # 8001aa70 <log+0x30>
    800032f8:	060a                	slli	a2,a2,0x2
    800032fa:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800032fc:	4ff4                	lw	a3,92(a5)
    800032fe:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003300:	0791                	addi	a5,a5,4
    80003302:	0711                	addi	a4,a4,4
    80003304:	fec79ce3          	bne	a5,a2,800032fc <initlog+0x54>
  brelse(buf);
    80003308:	95eff0ef          	jal	80002466 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000330c:	4505                	li	a0,1
    8000330e:	ef3ff0ef          	jal	80003200 <install_trans>
  log.lh.n = 0;
    80003312:	00017797          	auipc	a5,0x17
    80003316:	7407ad23          	sw	zero,1882(a5) # 8001aa6c <log+0x2c>
  write_head(); // clear the log
    8000331a:	e89ff0ef          	jal	800031a2 <write_head>
}
    8000331e:	70a2                	ld	ra,40(sp)
    80003320:	7402                	ld	s0,32(sp)
    80003322:	64e2                	ld	s1,24(sp)
    80003324:	6942                	ld	s2,16(sp)
    80003326:	69a2                	ld	s3,8(sp)
    80003328:	6145                	addi	sp,sp,48
    8000332a:	8082                	ret

000000008000332c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000332c:	1101                	addi	sp,sp,-32
    8000332e:	ec06                	sd	ra,24(sp)
    80003330:	e822                	sd	s0,16(sp)
    80003332:	e426                	sd	s1,8(sp)
    80003334:	e04a                	sd	s2,0(sp)
    80003336:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003338:	00017517          	auipc	a0,0x17
    8000333c:	70850513          	addi	a0,a0,1800 # 8001aa40 <log>
    80003340:	031020ef          	jal	80005b70 <acquire>
  while(1){
    if(log.committing){
    80003344:	00017497          	auipc	s1,0x17
    80003348:	6fc48493          	addi	s1,s1,1788 # 8001aa40 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000334c:	4979                	li	s2,30
    8000334e:	a029                	j	80003358 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003350:	85a6                	mv	a1,s1
    80003352:	8526                	mv	a0,s1
    80003354:	fddfd0ef          	jal	80001330 <sleep>
    if(log.committing){
    80003358:	50dc                	lw	a5,36(s1)
    8000335a:	fbfd                	bnez	a5,80003350 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000335c:	5098                	lw	a4,32(s1)
    8000335e:	2705                	addiw	a4,a4,1
    80003360:	0027179b          	slliw	a5,a4,0x2
    80003364:	9fb9                	addw	a5,a5,a4
    80003366:	0017979b          	slliw	a5,a5,0x1
    8000336a:	54d4                	lw	a3,44(s1)
    8000336c:	9fb5                	addw	a5,a5,a3
    8000336e:	00f95763          	bge	s2,a5,8000337c <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003372:	85a6                	mv	a1,s1
    80003374:	8526                	mv	a0,s1
    80003376:	fbbfd0ef          	jal	80001330 <sleep>
    8000337a:	bff9                	j	80003358 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    8000337c:	00017517          	auipc	a0,0x17
    80003380:	6c450513          	addi	a0,a0,1732 # 8001aa40 <log>
    80003384:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003386:	083020ef          	jal	80005c08 <release>
      break;
    }
  }
}
    8000338a:	60e2                	ld	ra,24(sp)
    8000338c:	6442                	ld	s0,16(sp)
    8000338e:	64a2                	ld	s1,8(sp)
    80003390:	6902                	ld	s2,0(sp)
    80003392:	6105                	addi	sp,sp,32
    80003394:	8082                	ret

0000000080003396 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003396:	7139                	addi	sp,sp,-64
    80003398:	fc06                	sd	ra,56(sp)
    8000339a:	f822                	sd	s0,48(sp)
    8000339c:	f426                	sd	s1,40(sp)
    8000339e:	f04a                	sd	s2,32(sp)
    800033a0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800033a2:	00017497          	auipc	s1,0x17
    800033a6:	69e48493          	addi	s1,s1,1694 # 8001aa40 <log>
    800033aa:	8526                	mv	a0,s1
    800033ac:	7c4020ef          	jal	80005b70 <acquire>
  log.outstanding -= 1;
    800033b0:	509c                	lw	a5,32(s1)
    800033b2:	37fd                	addiw	a5,a5,-1
    800033b4:	0007891b          	sext.w	s2,a5
    800033b8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800033ba:	50dc                	lw	a5,36(s1)
    800033bc:	ef9d                	bnez	a5,800033fa <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    800033be:	04091763          	bnez	s2,8000340c <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    800033c2:	00017497          	auipc	s1,0x17
    800033c6:	67e48493          	addi	s1,s1,1662 # 8001aa40 <log>
    800033ca:	4785                	li	a5,1
    800033cc:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800033ce:	8526                	mv	a0,s1
    800033d0:	039020ef          	jal	80005c08 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800033d4:	54dc                	lw	a5,44(s1)
    800033d6:	04f04b63          	bgtz	a5,8000342c <end_op+0x96>
    acquire(&log.lock);
    800033da:	00017497          	auipc	s1,0x17
    800033de:	66648493          	addi	s1,s1,1638 # 8001aa40 <log>
    800033e2:	8526                	mv	a0,s1
    800033e4:	78c020ef          	jal	80005b70 <acquire>
    log.committing = 0;
    800033e8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800033ec:	8526                	mv	a0,s1
    800033ee:	f8ffd0ef          	jal	8000137c <wakeup>
    release(&log.lock);
    800033f2:	8526                	mv	a0,s1
    800033f4:	015020ef          	jal	80005c08 <release>
}
    800033f8:	a025                	j	80003420 <end_op+0x8a>
    800033fa:	ec4e                	sd	s3,24(sp)
    800033fc:	e852                	sd	s4,16(sp)
    800033fe:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003400:	00004517          	auipc	a0,0x4
    80003404:	27850513          	addi	a0,a0,632 # 80007678 <etext+0x678>
    80003408:	43a020ef          	jal	80005842 <panic>
    wakeup(&log);
    8000340c:	00017497          	auipc	s1,0x17
    80003410:	63448493          	addi	s1,s1,1588 # 8001aa40 <log>
    80003414:	8526                	mv	a0,s1
    80003416:	f67fd0ef          	jal	8000137c <wakeup>
  release(&log.lock);
    8000341a:	8526                	mv	a0,s1
    8000341c:	7ec020ef          	jal	80005c08 <release>
}
    80003420:	70e2                	ld	ra,56(sp)
    80003422:	7442                	ld	s0,48(sp)
    80003424:	74a2                	ld	s1,40(sp)
    80003426:	7902                	ld	s2,32(sp)
    80003428:	6121                	addi	sp,sp,64
    8000342a:	8082                	ret
    8000342c:	ec4e                	sd	s3,24(sp)
    8000342e:	e852                	sd	s4,16(sp)
    80003430:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003432:	00017a97          	auipc	s5,0x17
    80003436:	63ea8a93          	addi	s5,s5,1598 # 8001aa70 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000343a:	00017a17          	auipc	s4,0x17
    8000343e:	606a0a13          	addi	s4,s4,1542 # 8001aa40 <log>
    80003442:	018a2583          	lw	a1,24(s4)
    80003446:	012585bb          	addw	a1,a1,s2
    8000344a:	2585                	addiw	a1,a1,1
    8000344c:	028a2503          	lw	a0,40(s4)
    80003450:	f0ffe0ef          	jal	8000235e <bread>
    80003454:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003456:	000aa583          	lw	a1,0(s5)
    8000345a:	028a2503          	lw	a0,40(s4)
    8000345e:	f01fe0ef          	jal	8000235e <bread>
    80003462:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003464:	40000613          	li	a2,1024
    80003468:	05850593          	addi	a1,a0,88
    8000346c:	05848513          	addi	a0,s1,88
    80003470:	d21fc0ef          	jal	80000190 <memmove>
    bwrite(to);  // write the log
    80003474:	8526                	mv	a0,s1
    80003476:	fbffe0ef          	jal	80002434 <bwrite>
    brelse(from);
    8000347a:	854e                	mv	a0,s3
    8000347c:	febfe0ef          	jal	80002466 <brelse>
    brelse(to);
    80003480:	8526                	mv	a0,s1
    80003482:	fe5fe0ef          	jal	80002466 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003486:	2905                	addiw	s2,s2,1
    80003488:	0a91                	addi	s5,s5,4
    8000348a:	02ca2783          	lw	a5,44(s4)
    8000348e:	faf94ae3          	blt	s2,a5,80003442 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003492:	d11ff0ef          	jal	800031a2 <write_head>
    install_trans(0); // Now install writes to home locations
    80003496:	4501                	li	a0,0
    80003498:	d69ff0ef          	jal	80003200 <install_trans>
    log.lh.n = 0;
    8000349c:	00017797          	auipc	a5,0x17
    800034a0:	5c07a823          	sw	zero,1488(a5) # 8001aa6c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800034a4:	cffff0ef          	jal	800031a2 <write_head>
    800034a8:	69e2                	ld	s3,24(sp)
    800034aa:	6a42                	ld	s4,16(sp)
    800034ac:	6aa2                	ld	s5,8(sp)
    800034ae:	b735                	j	800033da <end_op+0x44>

00000000800034b0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800034b0:	1101                	addi	sp,sp,-32
    800034b2:	ec06                	sd	ra,24(sp)
    800034b4:	e822                	sd	s0,16(sp)
    800034b6:	e426                	sd	s1,8(sp)
    800034b8:	e04a                	sd	s2,0(sp)
    800034ba:	1000                	addi	s0,sp,32
    800034bc:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800034be:	00017917          	auipc	s2,0x17
    800034c2:	58290913          	addi	s2,s2,1410 # 8001aa40 <log>
    800034c6:	854a                	mv	a0,s2
    800034c8:	6a8020ef          	jal	80005b70 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800034cc:	02c92603          	lw	a2,44(s2)
    800034d0:	47f5                	li	a5,29
    800034d2:	06c7c363          	blt	a5,a2,80003538 <log_write+0x88>
    800034d6:	00017797          	auipc	a5,0x17
    800034da:	5867a783          	lw	a5,1414(a5) # 8001aa5c <log+0x1c>
    800034de:	37fd                	addiw	a5,a5,-1
    800034e0:	04f65c63          	bge	a2,a5,80003538 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800034e4:	00017797          	auipc	a5,0x17
    800034e8:	57c7a783          	lw	a5,1404(a5) # 8001aa60 <log+0x20>
    800034ec:	04f05c63          	blez	a5,80003544 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800034f0:	4781                	li	a5,0
    800034f2:	04c05f63          	blez	a2,80003550 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800034f6:	44cc                	lw	a1,12(s1)
    800034f8:	00017717          	auipc	a4,0x17
    800034fc:	57870713          	addi	a4,a4,1400 # 8001aa70 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003500:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003502:	4314                	lw	a3,0(a4)
    80003504:	04b68663          	beq	a3,a1,80003550 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003508:	2785                	addiw	a5,a5,1
    8000350a:	0711                	addi	a4,a4,4
    8000350c:	fef61be3          	bne	a2,a5,80003502 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003510:	0621                	addi	a2,a2,8
    80003512:	060a                	slli	a2,a2,0x2
    80003514:	00017797          	auipc	a5,0x17
    80003518:	52c78793          	addi	a5,a5,1324 # 8001aa40 <log>
    8000351c:	97b2                	add	a5,a5,a2
    8000351e:	44d8                	lw	a4,12(s1)
    80003520:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003522:	8526                	mv	a0,s1
    80003524:	fcbfe0ef          	jal	800024ee <bpin>
    log.lh.n++;
    80003528:	00017717          	auipc	a4,0x17
    8000352c:	51870713          	addi	a4,a4,1304 # 8001aa40 <log>
    80003530:	575c                	lw	a5,44(a4)
    80003532:	2785                	addiw	a5,a5,1
    80003534:	d75c                	sw	a5,44(a4)
    80003536:	a80d                	j	80003568 <log_write+0xb8>
    panic("too big a transaction");
    80003538:	00004517          	auipc	a0,0x4
    8000353c:	15050513          	addi	a0,a0,336 # 80007688 <etext+0x688>
    80003540:	302020ef          	jal	80005842 <panic>
    panic("log_write outside of trans");
    80003544:	00004517          	auipc	a0,0x4
    80003548:	15c50513          	addi	a0,a0,348 # 800076a0 <etext+0x6a0>
    8000354c:	2f6020ef          	jal	80005842 <panic>
  log.lh.block[i] = b->blockno;
    80003550:	00878693          	addi	a3,a5,8
    80003554:	068a                	slli	a3,a3,0x2
    80003556:	00017717          	auipc	a4,0x17
    8000355a:	4ea70713          	addi	a4,a4,1258 # 8001aa40 <log>
    8000355e:	9736                	add	a4,a4,a3
    80003560:	44d4                	lw	a3,12(s1)
    80003562:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003564:	faf60fe3          	beq	a2,a5,80003522 <log_write+0x72>
  }
  release(&log.lock);
    80003568:	00017517          	auipc	a0,0x17
    8000356c:	4d850513          	addi	a0,a0,1240 # 8001aa40 <log>
    80003570:	698020ef          	jal	80005c08 <release>
}
    80003574:	60e2                	ld	ra,24(sp)
    80003576:	6442                	ld	s0,16(sp)
    80003578:	64a2                	ld	s1,8(sp)
    8000357a:	6902                	ld	s2,0(sp)
    8000357c:	6105                	addi	sp,sp,32
    8000357e:	8082                	ret

0000000080003580 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003580:	1101                	addi	sp,sp,-32
    80003582:	ec06                	sd	ra,24(sp)
    80003584:	e822                	sd	s0,16(sp)
    80003586:	e426                	sd	s1,8(sp)
    80003588:	e04a                	sd	s2,0(sp)
    8000358a:	1000                	addi	s0,sp,32
    8000358c:	84aa                	mv	s1,a0
    8000358e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003590:	00004597          	auipc	a1,0x4
    80003594:	13058593          	addi	a1,a1,304 # 800076c0 <etext+0x6c0>
    80003598:	0521                	addi	a0,a0,8
    8000359a:	556020ef          	jal	80005af0 <initlock>
  lk->name = name;
    8000359e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800035a2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800035a6:	0204a423          	sw	zero,40(s1)
}
    800035aa:	60e2                	ld	ra,24(sp)
    800035ac:	6442                	ld	s0,16(sp)
    800035ae:	64a2                	ld	s1,8(sp)
    800035b0:	6902                	ld	s2,0(sp)
    800035b2:	6105                	addi	sp,sp,32
    800035b4:	8082                	ret

00000000800035b6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800035b6:	1101                	addi	sp,sp,-32
    800035b8:	ec06                	sd	ra,24(sp)
    800035ba:	e822                	sd	s0,16(sp)
    800035bc:	e426                	sd	s1,8(sp)
    800035be:	e04a                	sd	s2,0(sp)
    800035c0:	1000                	addi	s0,sp,32
    800035c2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800035c4:	00850913          	addi	s2,a0,8
    800035c8:	854a                	mv	a0,s2
    800035ca:	5a6020ef          	jal	80005b70 <acquire>
  while (lk->locked) {
    800035ce:	409c                	lw	a5,0(s1)
    800035d0:	c799                	beqz	a5,800035de <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800035d2:	85ca                	mv	a1,s2
    800035d4:	8526                	mv	a0,s1
    800035d6:	d5bfd0ef          	jal	80001330 <sleep>
  while (lk->locked) {
    800035da:	409c                	lw	a5,0(s1)
    800035dc:	fbfd                	bnez	a5,800035d2 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800035de:	4785                	li	a5,1
    800035e0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800035e2:	f74fd0ef          	jal	80000d56 <myproc>
    800035e6:	591c                	lw	a5,48(a0)
    800035e8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800035ea:	854a                	mv	a0,s2
    800035ec:	61c020ef          	jal	80005c08 <release>
}
    800035f0:	60e2                	ld	ra,24(sp)
    800035f2:	6442                	ld	s0,16(sp)
    800035f4:	64a2                	ld	s1,8(sp)
    800035f6:	6902                	ld	s2,0(sp)
    800035f8:	6105                	addi	sp,sp,32
    800035fa:	8082                	ret

00000000800035fc <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800035fc:	1101                	addi	sp,sp,-32
    800035fe:	ec06                	sd	ra,24(sp)
    80003600:	e822                	sd	s0,16(sp)
    80003602:	e426                	sd	s1,8(sp)
    80003604:	e04a                	sd	s2,0(sp)
    80003606:	1000                	addi	s0,sp,32
    80003608:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000360a:	00850913          	addi	s2,a0,8
    8000360e:	854a                	mv	a0,s2
    80003610:	560020ef          	jal	80005b70 <acquire>
  lk->locked = 0;
    80003614:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003618:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000361c:	8526                	mv	a0,s1
    8000361e:	d5ffd0ef          	jal	8000137c <wakeup>
  release(&lk->lk);
    80003622:	854a                	mv	a0,s2
    80003624:	5e4020ef          	jal	80005c08 <release>
}
    80003628:	60e2                	ld	ra,24(sp)
    8000362a:	6442                	ld	s0,16(sp)
    8000362c:	64a2                	ld	s1,8(sp)
    8000362e:	6902                	ld	s2,0(sp)
    80003630:	6105                	addi	sp,sp,32
    80003632:	8082                	ret

0000000080003634 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003634:	7179                	addi	sp,sp,-48
    80003636:	f406                	sd	ra,40(sp)
    80003638:	f022                	sd	s0,32(sp)
    8000363a:	ec26                	sd	s1,24(sp)
    8000363c:	e84a                	sd	s2,16(sp)
    8000363e:	1800                	addi	s0,sp,48
    80003640:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003642:	00850913          	addi	s2,a0,8
    80003646:	854a                	mv	a0,s2
    80003648:	528020ef          	jal	80005b70 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000364c:	409c                	lw	a5,0(s1)
    8000364e:	ef81                	bnez	a5,80003666 <holdingsleep+0x32>
    80003650:	4481                	li	s1,0
  release(&lk->lk);
    80003652:	854a                	mv	a0,s2
    80003654:	5b4020ef          	jal	80005c08 <release>
  return r;
}
    80003658:	8526                	mv	a0,s1
    8000365a:	70a2                	ld	ra,40(sp)
    8000365c:	7402                	ld	s0,32(sp)
    8000365e:	64e2                	ld	s1,24(sp)
    80003660:	6942                	ld	s2,16(sp)
    80003662:	6145                	addi	sp,sp,48
    80003664:	8082                	ret
    80003666:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003668:	0284a983          	lw	s3,40(s1)
    8000366c:	eeafd0ef          	jal	80000d56 <myproc>
    80003670:	5904                	lw	s1,48(a0)
    80003672:	413484b3          	sub	s1,s1,s3
    80003676:	0014b493          	seqz	s1,s1
    8000367a:	69a2                	ld	s3,8(sp)
    8000367c:	bfd9                	j	80003652 <holdingsleep+0x1e>

000000008000367e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000367e:	1141                	addi	sp,sp,-16
    80003680:	e406                	sd	ra,8(sp)
    80003682:	e022                	sd	s0,0(sp)
    80003684:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003686:	00004597          	auipc	a1,0x4
    8000368a:	04a58593          	addi	a1,a1,74 # 800076d0 <etext+0x6d0>
    8000368e:	00017517          	auipc	a0,0x17
    80003692:	4fa50513          	addi	a0,a0,1274 # 8001ab88 <ftable>
    80003696:	45a020ef          	jal	80005af0 <initlock>
}
    8000369a:	60a2                	ld	ra,8(sp)
    8000369c:	6402                	ld	s0,0(sp)
    8000369e:	0141                	addi	sp,sp,16
    800036a0:	8082                	ret

00000000800036a2 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800036a2:	1101                	addi	sp,sp,-32
    800036a4:	ec06                	sd	ra,24(sp)
    800036a6:	e822                	sd	s0,16(sp)
    800036a8:	e426                	sd	s1,8(sp)
    800036aa:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800036ac:	00017517          	auipc	a0,0x17
    800036b0:	4dc50513          	addi	a0,a0,1244 # 8001ab88 <ftable>
    800036b4:	4bc020ef          	jal	80005b70 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800036b8:	00017497          	auipc	s1,0x17
    800036bc:	4e848493          	addi	s1,s1,1256 # 8001aba0 <ftable+0x18>
    800036c0:	00018717          	auipc	a4,0x18
    800036c4:	48070713          	addi	a4,a4,1152 # 8001bb40 <disk>
    if(f->ref == 0){
    800036c8:	40dc                	lw	a5,4(s1)
    800036ca:	cf89                	beqz	a5,800036e4 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800036cc:	02848493          	addi	s1,s1,40
    800036d0:	fee49ce3          	bne	s1,a4,800036c8 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800036d4:	00017517          	auipc	a0,0x17
    800036d8:	4b450513          	addi	a0,a0,1204 # 8001ab88 <ftable>
    800036dc:	52c020ef          	jal	80005c08 <release>
  return 0;
    800036e0:	4481                	li	s1,0
    800036e2:	a809                	j	800036f4 <filealloc+0x52>
      f->ref = 1;
    800036e4:	4785                	li	a5,1
    800036e6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800036e8:	00017517          	auipc	a0,0x17
    800036ec:	4a050513          	addi	a0,a0,1184 # 8001ab88 <ftable>
    800036f0:	518020ef          	jal	80005c08 <release>
}
    800036f4:	8526                	mv	a0,s1
    800036f6:	60e2                	ld	ra,24(sp)
    800036f8:	6442                	ld	s0,16(sp)
    800036fa:	64a2                	ld	s1,8(sp)
    800036fc:	6105                	addi	sp,sp,32
    800036fe:	8082                	ret

0000000080003700 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003700:	1101                	addi	sp,sp,-32
    80003702:	ec06                	sd	ra,24(sp)
    80003704:	e822                	sd	s0,16(sp)
    80003706:	e426                	sd	s1,8(sp)
    80003708:	1000                	addi	s0,sp,32
    8000370a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000370c:	00017517          	auipc	a0,0x17
    80003710:	47c50513          	addi	a0,a0,1148 # 8001ab88 <ftable>
    80003714:	45c020ef          	jal	80005b70 <acquire>
  if(f->ref < 1)
    80003718:	40dc                	lw	a5,4(s1)
    8000371a:	02f05063          	blez	a5,8000373a <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000371e:	2785                	addiw	a5,a5,1
    80003720:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003722:	00017517          	auipc	a0,0x17
    80003726:	46650513          	addi	a0,a0,1126 # 8001ab88 <ftable>
    8000372a:	4de020ef          	jal	80005c08 <release>
  return f;
}
    8000372e:	8526                	mv	a0,s1
    80003730:	60e2                	ld	ra,24(sp)
    80003732:	6442                	ld	s0,16(sp)
    80003734:	64a2                	ld	s1,8(sp)
    80003736:	6105                	addi	sp,sp,32
    80003738:	8082                	ret
    panic("filedup");
    8000373a:	00004517          	auipc	a0,0x4
    8000373e:	f9e50513          	addi	a0,a0,-98 # 800076d8 <etext+0x6d8>
    80003742:	100020ef          	jal	80005842 <panic>

0000000080003746 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003746:	7139                	addi	sp,sp,-64
    80003748:	fc06                	sd	ra,56(sp)
    8000374a:	f822                	sd	s0,48(sp)
    8000374c:	f426                	sd	s1,40(sp)
    8000374e:	0080                	addi	s0,sp,64
    80003750:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003752:	00017517          	auipc	a0,0x17
    80003756:	43650513          	addi	a0,a0,1078 # 8001ab88 <ftable>
    8000375a:	416020ef          	jal	80005b70 <acquire>
  if(f->ref < 1)
    8000375e:	40dc                	lw	a5,4(s1)
    80003760:	04f05a63          	blez	a5,800037b4 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003764:	37fd                	addiw	a5,a5,-1
    80003766:	0007871b          	sext.w	a4,a5
    8000376a:	c0dc                	sw	a5,4(s1)
    8000376c:	04e04e63          	bgtz	a4,800037c8 <fileclose+0x82>
    80003770:	f04a                	sd	s2,32(sp)
    80003772:	ec4e                	sd	s3,24(sp)
    80003774:	e852                	sd	s4,16(sp)
    80003776:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003778:	0004a903          	lw	s2,0(s1)
    8000377c:	0094ca83          	lbu	s5,9(s1)
    80003780:	0104ba03          	ld	s4,16(s1)
    80003784:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003788:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000378c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003790:	00017517          	auipc	a0,0x17
    80003794:	3f850513          	addi	a0,a0,1016 # 8001ab88 <ftable>
    80003798:	470020ef          	jal	80005c08 <release>

  if(ff.type == FD_PIPE){
    8000379c:	4785                	li	a5,1
    8000379e:	04f90063          	beq	s2,a5,800037de <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800037a2:	3979                	addiw	s2,s2,-2
    800037a4:	4785                	li	a5,1
    800037a6:	0527f563          	bgeu	a5,s2,800037f0 <fileclose+0xaa>
    800037aa:	7902                	ld	s2,32(sp)
    800037ac:	69e2                	ld	s3,24(sp)
    800037ae:	6a42                	ld	s4,16(sp)
    800037b0:	6aa2                	ld	s5,8(sp)
    800037b2:	a00d                	j	800037d4 <fileclose+0x8e>
    800037b4:	f04a                	sd	s2,32(sp)
    800037b6:	ec4e                	sd	s3,24(sp)
    800037b8:	e852                	sd	s4,16(sp)
    800037ba:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800037bc:	00004517          	auipc	a0,0x4
    800037c0:	f2450513          	addi	a0,a0,-220 # 800076e0 <etext+0x6e0>
    800037c4:	07e020ef          	jal	80005842 <panic>
    release(&ftable.lock);
    800037c8:	00017517          	auipc	a0,0x17
    800037cc:	3c050513          	addi	a0,a0,960 # 8001ab88 <ftable>
    800037d0:	438020ef          	jal	80005c08 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800037d4:	70e2                	ld	ra,56(sp)
    800037d6:	7442                	ld	s0,48(sp)
    800037d8:	74a2                	ld	s1,40(sp)
    800037da:	6121                	addi	sp,sp,64
    800037dc:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800037de:	85d6                	mv	a1,s5
    800037e0:	8552                	mv	a0,s4
    800037e2:	336000ef          	jal	80003b18 <pipeclose>
    800037e6:	7902                	ld	s2,32(sp)
    800037e8:	69e2                	ld	s3,24(sp)
    800037ea:	6a42                	ld	s4,16(sp)
    800037ec:	6aa2                	ld	s5,8(sp)
    800037ee:	b7dd                	j	800037d4 <fileclose+0x8e>
    begin_op();
    800037f0:	b3dff0ef          	jal	8000332c <begin_op>
    iput(ff.ip);
    800037f4:	854e                	mv	a0,s3
    800037f6:	c22ff0ef          	jal	80002c18 <iput>
    end_op();
    800037fa:	b9dff0ef          	jal	80003396 <end_op>
    800037fe:	7902                	ld	s2,32(sp)
    80003800:	69e2                	ld	s3,24(sp)
    80003802:	6a42                	ld	s4,16(sp)
    80003804:	6aa2                	ld	s5,8(sp)
    80003806:	b7f9                	j	800037d4 <fileclose+0x8e>

0000000080003808 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003808:	715d                	addi	sp,sp,-80
    8000380a:	e486                	sd	ra,72(sp)
    8000380c:	e0a2                	sd	s0,64(sp)
    8000380e:	fc26                	sd	s1,56(sp)
    80003810:	f44e                	sd	s3,40(sp)
    80003812:	0880                	addi	s0,sp,80
    80003814:	84aa                	mv	s1,a0
    80003816:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003818:	d3efd0ef          	jal	80000d56 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000381c:	409c                	lw	a5,0(s1)
    8000381e:	37f9                	addiw	a5,a5,-2
    80003820:	4705                	li	a4,1
    80003822:	04f76063          	bltu	a4,a5,80003862 <filestat+0x5a>
    80003826:	f84a                	sd	s2,48(sp)
    80003828:	892a                	mv	s2,a0
    ilock(f->ip);
    8000382a:	6c88                	ld	a0,24(s1)
    8000382c:	a6aff0ef          	jal	80002a96 <ilock>
    stati(f->ip, &st);
    80003830:	fb840593          	addi	a1,s0,-72
    80003834:	6c88                	ld	a0,24(s1)
    80003836:	c8aff0ef          	jal	80002cc0 <stati>
    iunlock(f->ip);
    8000383a:	6c88                	ld	a0,24(s1)
    8000383c:	b08ff0ef          	jal	80002b44 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003840:	46e1                	li	a3,24
    80003842:	fb840613          	addi	a2,s0,-72
    80003846:	85ce                	mv	a1,s3
    80003848:	05093503          	ld	a0,80(s2)
    8000384c:	97afd0ef          	jal	800009c6 <copyout>
    80003850:	41f5551b          	sraiw	a0,a0,0x1f
    80003854:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003856:	60a6                	ld	ra,72(sp)
    80003858:	6406                	ld	s0,64(sp)
    8000385a:	74e2                	ld	s1,56(sp)
    8000385c:	79a2                	ld	s3,40(sp)
    8000385e:	6161                	addi	sp,sp,80
    80003860:	8082                	ret
  return -1;
    80003862:	557d                	li	a0,-1
    80003864:	bfcd                	j	80003856 <filestat+0x4e>

0000000080003866 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003866:	7179                	addi	sp,sp,-48
    80003868:	f406                	sd	ra,40(sp)
    8000386a:	f022                	sd	s0,32(sp)
    8000386c:	e84a                	sd	s2,16(sp)
    8000386e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003870:	00854783          	lbu	a5,8(a0)
    80003874:	cfd1                	beqz	a5,80003910 <fileread+0xaa>
    80003876:	ec26                	sd	s1,24(sp)
    80003878:	e44e                	sd	s3,8(sp)
    8000387a:	84aa                	mv	s1,a0
    8000387c:	89ae                	mv	s3,a1
    8000387e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003880:	411c                	lw	a5,0(a0)
    80003882:	4705                	li	a4,1
    80003884:	04e78363          	beq	a5,a4,800038ca <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003888:	470d                	li	a4,3
    8000388a:	04e78763          	beq	a5,a4,800038d8 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000388e:	4709                	li	a4,2
    80003890:	06e79a63          	bne	a5,a4,80003904 <fileread+0x9e>
    ilock(f->ip);
    80003894:	6d08                	ld	a0,24(a0)
    80003896:	a00ff0ef          	jal	80002a96 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000389a:	874a                	mv	a4,s2
    8000389c:	5094                	lw	a3,32(s1)
    8000389e:	864e                	mv	a2,s3
    800038a0:	4585                	li	a1,1
    800038a2:	6c88                	ld	a0,24(s1)
    800038a4:	c46ff0ef          	jal	80002cea <readi>
    800038a8:	892a                	mv	s2,a0
    800038aa:	00a05563          	blez	a0,800038b4 <fileread+0x4e>
      f->off += r;
    800038ae:	509c                	lw	a5,32(s1)
    800038b0:	9fa9                	addw	a5,a5,a0
    800038b2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800038b4:	6c88                	ld	a0,24(s1)
    800038b6:	a8eff0ef          	jal	80002b44 <iunlock>
    800038ba:	64e2                	ld	s1,24(sp)
    800038bc:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800038be:	854a                	mv	a0,s2
    800038c0:	70a2                	ld	ra,40(sp)
    800038c2:	7402                	ld	s0,32(sp)
    800038c4:	6942                	ld	s2,16(sp)
    800038c6:	6145                	addi	sp,sp,48
    800038c8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800038ca:	6908                	ld	a0,16(a0)
    800038cc:	388000ef          	jal	80003c54 <piperead>
    800038d0:	892a                	mv	s2,a0
    800038d2:	64e2                	ld	s1,24(sp)
    800038d4:	69a2                	ld	s3,8(sp)
    800038d6:	b7e5                	j	800038be <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800038d8:	02451783          	lh	a5,36(a0)
    800038dc:	03079693          	slli	a3,a5,0x30
    800038e0:	92c1                	srli	a3,a3,0x30
    800038e2:	4725                	li	a4,9
    800038e4:	02d76863          	bltu	a4,a3,80003914 <fileread+0xae>
    800038e8:	0792                	slli	a5,a5,0x4
    800038ea:	00017717          	auipc	a4,0x17
    800038ee:	1fe70713          	addi	a4,a4,510 # 8001aae8 <devsw>
    800038f2:	97ba                	add	a5,a5,a4
    800038f4:	639c                	ld	a5,0(a5)
    800038f6:	c39d                	beqz	a5,8000391c <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800038f8:	4505                	li	a0,1
    800038fa:	9782                	jalr	a5
    800038fc:	892a                	mv	s2,a0
    800038fe:	64e2                	ld	s1,24(sp)
    80003900:	69a2                	ld	s3,8(sp)
    80003902:	bf75                	j	800038be <fileread+0x58>
    panic("fileread");
    80003904:	00004517          	auipc	a0,0x4
    80003908:	dec50513          	addi	a0,a0,-532 # 800076f0 <etext+0x6f0>
    8000390c:	737010ef          	jal	80005842 <panic>
    return -1;
    80003910:	597d                	li	s2,-1
    80003912:	b775                	j	800038be <fileread+0x58>
      return -1;
    80003914:	597d                	li	s2,-1
    80003916:	64e2                	ld	s1,24(sp)
    80003918:	69a2                	ld	s3,8(sp)
    8000391a:	b755                	j	800038be <fileread+0x58>
    8000391c:	597d                	li	s2,-1
    8000391e:	64e2                	ld	s1,24(sp)
    80003920:	69a2                	ld	s3,8(sp)
    80003922:	bf71                	j	800038be <fileread+0x58>

0000000080003924 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003924:	00954783          	lbu	a5,9(a0)
    80003928:	10078b63          	beqz	a5,80003a3e <filewrite+0x11a>
{
    8000392c:	715d                	addi	sp,sp,-80
    8000392e:	e486                	sd	ra,72(sp)
    80003930:	e0a2                	sd	s0,64(sp)
    80003932:	f84a                	sd	s2,48(sp)
    80003934:	f052                	sd	s4,32(sp)
    80003936:	e85a                	sd	s6,16(sp)
    80003938:	0880                	addi	s0,sp,80
    8000393a:	892a                	mv	s2,a0
    8000393c:	8b2e                	mv	s6,a1
    8000393e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003940:	411c                	lw	a5,0(a0)
    80003942:	4705                	li	a4,1
    80003944:	02e78763          	beq	a5,a4,80003972 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003948:	470d                	li	a4,3
    8000394a:	02e78863          	beq	a5,a4,8000397a <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000394e:	4709                	li	a4,2
    80003950:	0ce79c63          	bne	a5,a4,80003a28 <filewrite+0x104>
    80003954:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003956:	0ac05863          	blez	a2,80003a06 <filewrite+0xe2>
    8000395a:	fc26                	sd	s1,56(sp)
    8000395c:	ec56                	sd	s5,24(sp)
    8000395e:	e45e                	sd	s7,8(sp)
    80003960:	e062                	sd	s8,0(sp)
    int i = 0;
    80003962:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003964:	6b85                	lui	s7,0x1
    80003966:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000396a:	6c05                	lui	s8,0x1
    8000396c:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003970:	a8b5                	j	800039ec <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80003972:	6908                	ld	a0,16(a0)
    80003974:	1fc000ef          	jal	80003b70 <pipewrite>
    80003978:	a04d                	j	80003a1a <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000397a:	02451783          	lh	a5,36(a0)
    8000397e:	03079693          	slli	a3,a5,0x30
    80003982:	92c1                	srli	a3,a3,0x30
    80003984:	4725                	li	a4,9
    80003986:	0ad76e63          	bltu	a4,a3,80003a42 <filewrite+0x11e>
    8000398a:	0792                	slli	a5,a5,0x4
    8000398c:	00017717          	auipc	a4,0x17
    80003990:	15c70713          	addi	a4,a4,348 # 8001aae8 <devsw>
    80003994:	97ba                	add	a5,a5,a4
    80003996:	679c                	ld	a5,8(a5)
    80003998:	c7dd                	beqz	a5,80003a46 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    8000399a:	4505                	li	a0,1
    8000399c:	9782                	jalr	a5
    8000399e:	a8b5                	j	80003a1a <filewrite+0xf6>
      if(n1 > max)
    800039a0:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800039a4:	989ff0ef          	jal	8000332c <begin_op>
      ilock(f->ip);
    800039a8:	01893503          	ld	a0,24(s2)
    800039ac:	8eaff0ef          	jal	80002a96 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800039b0:	8756                	mv	a4,s5
    800039b2:	02092683          	lw	a3,32(s2)
    800039b6:	01698633          	add	a2,s3,s6
    800039ba:	4585                	li	a1,1
    800039bc:	01893503          	ld	a0,24(s2)
    800039c0:	c26ff0ef          	jal	80002de6 <writei>
    800039c4:	84aa                	mv	s1,a0
    800039c6:	00a05763          	blez	a0,800039d4 <filewrite+0xb0>
        f->off += r;
    800039ca:	02092783          	lw	a5,32(s2)
    800039ce:	9fa9                	addw	a5,a5,a0
    800039d0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800039d4:	01893503          	ld	a0,24(s2)
    800039d8:	96cff0ef          	jal	80002b44 <iunlock>
      end_op();
    800039dc:	9bbff0ef          	jal	80003396 <end_op>

      if(r != n1){
    800039e0:	029a9563          	bne	s5,s1,80003a0a <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800039e4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800039e8:	0149da63          	bge	s3,s4,800039fc <filewrite+0xd8>
      int n1 = n - i;
    800039ec:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800039f0:	0004879b          	sext.w	a5,s1
    800039f4:	fafbd6e3          	bge	s7,a5,800039a0 <filewrite+0x7c>
    800039f8:	84e2                	mv	s1,s8
    800039fa:	b75d                	j	800039a0 <filewrite+0x7c>
    800039fc:	74e2                	ld	s1,56(sp)
    800039fe:	6ae2                	ld	s5,24(sp)
    80003a00:	6ba2                	ld	s7,8(sp)
    80003a02:	6c02                	ld	s8,0(sp)
    80003a04:	a039                	j	80003a12 <filewrite+0xee>
    int i = 0;
    80003a06:	4981                	li	s3,0
    80003a08:	a029                	j	80003a12 <filewrite+0xee>
    80003a0a:	74e2                	ld	s1,56(sp)
    80003a0c:	6ae2                	ld	s5,24(sp)
    80003a0e:	6ba2                	ld	s7,8(sp)
    80003a10:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003a12:	033a1c63          	bne	s4,s3,80003a4a <filewrite+0x126>
    80003a16:	8552                	mv	a0,s4
    80003a18:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003a1a:	60a6                	ld	ra,72(sp)
    80003a1c:	6406                	ld	s0,64(sp)
    80003a1e:	7942                	ld	s2,48(sp)
    80003a20:	7a02                	ld	s4,32(sp)
    80003a22:	6b42                	ld	s6,16(sp)
    80003a24:	6161                	addi	sp,sp,80
    80003a26:	8082                	ret
    80003a28:	fc26                	sd	s1,56(sp)
    80003a2a:	f44e                	sd	s3,40(sp)
    80003a2c:	ec56                	sd	s5,24(sp)
    80003a2e:	e45e                	sd	s7,8(sp)
    80003a30:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003a32:	00004517          	auipc	a0,0x4
    80003a36:	cce50513          	addi	a0,a0,-818 # 80007700 <etext+0x700>
    80003a3a:	609010ef          	jal	80005842 <panic>
    return -1;
    80003a3e:	557d                	li	a0,-1
}
    80003a40:	8082                	ret
      return -1;
    80003a42:	557d                	li	a0,-1
    80003a44:	bfd9                	j	80003a1a <filewrite+0xf6>
    80003a46:	557d                	li	a0,-1
    80003a48:	bfc9                	j	80003a1a <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80003a4a:	557d                	li	a0,-1
    80003a4c:	79a2                	ld	s3,40(sp)
    80003a4e:	b7f1                	j	80003a1a <filewrite+0xf6>

0000000080003a50 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003a50:	7179                	addi	sp,sp,-48
    80003a52:	f406                	sd	ra,40(sp)
    80003a54:	f022                	sd	s0,32(sp)
    80003a56:	ec26                	sd	s1,24(sp)
    80003a58:	e052                	sd	s4,0(sp)
    80003a5a:	1800                	addi	s0,sp,48
    80003a5c:	84aa                	mv	s1,a0
    80003a5e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003a60:	0005b023          	sd	zero,0(a1)
    80003a64:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003a68:	c3bff0ef          	jal	800036a2 <filealloc>
    80003a6c:	e088                	sd	a0,0(s1)
    80003a6e:	c549                	beqz	a0,80003af8 <pipealloc+0xa8>
    80003a70:	c33ff0ef          	jal	800036a2 <filealloc>
    80003a74:	00aa3023          	sd	a0,0(s4)
    80003a78:	cd25                	beqz	a0,80003af0 <pipealloc+0xa0>
    80003a7a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003a7c:	e7afc0ef          	jal	800000f6 <kalloc>
    80003a80:	892a                	mv	s2,a0
    80003a82:	c12d                	beqz	a0,80003ae4 <pipealloc+0x94>
    80003a84:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003a86:	4985                	li	s3,1
    80003a88:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003a8c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003a90:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003a94:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003a98:	00004597          	auipc	a1,0x4
    80003a9c:	9f858593          	addi	a1,a1,-1544 # 80007490 <etext+0x490>
    80003aa0:	050020ef          	jal	80005af0 <initlock>
  (*f0)->type = FD_PIPE;
    80003aa4:	609c                	ld	a5,0(s1)
    80003aa6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003aaa:	609c                	ld	a5,0(s1)
    80003aac:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ab0:	609c                	ld	a5,0(s1)
    80003ab2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ab6:	609c                	ld	a5,0(s1)
    80003ab8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003abc:	000a3783          	ld	a5,0(s4)
    80003ac0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ac4:	000a3783          	ld	a5,0(s4)
    80003ac8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003acc:	000a3783          	ld	a5,0(s4)
    80003ad0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ad4:	000a3783          	ld	a5,0(s4)
    80003ad8:	0127b823          	sd	s2,16(a5)
  return 0;
    80003adc:	4501                	li	a0,0
    80003ade:	6942                	ld	s2,16(sp)
    80003ae0:	69a2                	ld	s3,8(sp)
    80003ae2:	a01d                	j	80003b08 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ae4:	6088                	ld	a0,0(s1)
    80003ae6:	c119                	beqz	a0,80003aec <pipealloc+0x9c>
    80003ae8:	6942                	ld	s2,16(sp)
    80003aea:	a029                	j	80003af4 <pipealloc+0xa4>
    80003aec:	6942                	ld	s2,16(sp)
    80003aee:	a029                	j	80003af8 <pipealloc+0xa8>
    80003af0:	6088                	ld	a0,0(s1)
    80003af2:	c10d                	beqz	a0,80003b14 <pipealloc+0xc4>
    fileclose(*f0);
    80003af4:	c53ff0ef          	jal	80003746 <fileclose>
  if(*f1)
    80003af8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003afc:	557d                	li	a0,-1
  if(*f1)
    80003afe:	c789                	beqz	a5,80003b08 <pipealloc+0xb8>
    fileclose(*f1);
    80003b00:	853e                	mv	a0,a5
    80003b02:	c45ff0ef          	jal	80003746 <fileclose>
  return -1;
    80003b06:	557d                	li	a0,-1
}
    80003b08:	70a2                	ld	ra,40(sp)
    80003b0a:	7402                	ld	s0,32(sp)
    80003b0c:	64e2                	ld	s1,24(sp)
    80003b0e:	6a02                	ld	s4,0(sp)
    80003b10:	6145                	addi	sp,sp,48
    80003b12:	8082                	ret
  return -1;
    80003b14:	557d                	li	a0,-1
    80003b16:	bfcd                	j	80003b08 <pipealloc+0xb8>

0000000080003b18 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003b18:	1101                	addi	sp,sp,-32
    80003b1a:	ec06                	sd	ra,24(sp)
    80003b1c:	e822                	sd	s0,16(sp)
    80003b1e:	e426                	sd	s1,8(sp)
    80003b20:	e04a                	sd	s2,0(sp)
    80003b22:	1000                	addi	s0,sp,32
    80003b24:	84aa                	mv	s1,a0
    80003b26:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003b28:	048020ef          	jal	80005b70 <acquire>
  if(writable){
    80003b2c:	02090763          	beqz	s2,80003b5a <pipeclose+0x42>
    pi->writeopen = 0;
    80003b30:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003b34:	21848513          	addi	a0,s1,536
    80003b38:	845fd0ef          	jal	8000137c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003b3c:	2204b783          	ld	a5,544(s1)
    80003b40:	e785                	bnez	a5,80003b68 <pipeclose+0x50>
    release(&pi->lock);
    80003b42:	8526                	mv	a0,s1
    80003b44:	0c4020ef          	jal	80005c08 <release>
    kfree((char*)pi);
    80003b48:	8526                	mv	a0,s1
    80003b4a:	cd2fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003b4e:	60e2                	ld	ra,24(sp)
    80003b50:	6442                	ld	s0,16(sp)
    80003b52:	64a2                	ld	s1,8(sp)
    80003b54:	6902                	ld	s2,0(sp)
    80003b56:	6105                	addi	sp,sp,32
    80003b58:	8082                	ret
    pi->readopen = 0;
    80003b5a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003b5e:	21c48513          	addi	a0,s1,540
    80003b62:	81bfd0ef          	jal	8000137c <wakeup>
    80003b66:	bfd9                	j	80003b3c <pipeclose+0x24>
    release(&pi->lock);
    80003b68:	8526                	mv	a0,s1
    80003b6a:	09e020ef          	jal	80005c08 <release>
}
    80003b6e:	b7c5                	j	80003b4e <pipeclose+0x36>

0000000080003b70 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003b70:	711d                	addi	sp,sp,-96
    80003b72:	ec86                	sd	ra,88(sp)
    80003b74:	e8a2                	sd	s0,80(sp)
    80003b76:	e4a6                	sd	s1,72(sp)
    80003b78:	e0ca                	sd	s2,64(sp)
    80003b7a:	fc4e                	sd	s3,56(sp)
    80003b7c:	f852                	sd	s4,48(sp)
    80003b7e:	f456                	sd	s5,40(sp)
    80003b80:	1080                	addi	s0,sp,96
    80003b82:	84aa                	mv	s1,a0
    80003b84:	8aae                	mv	s5,a1
    80003b86:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003b88:	9cefd0ef          	jal	80000d56 <myproc>
    80003b8c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003b8e:	8526                	mv	a0,s1
    80003b90:	7e1010ef          	jal	80005b70 <acquire>
  while(i < n){
    80003b94:	0b405a63          	blez	s4,80003c48 <pipewrite+0xd8>
    80003b98:	f05a                	sd	s6,32(sp)
    80003b9a:	ec5e                	sd	s7,24(sp)
    80003b9c:	e862                	sd	s8,16(sp)
  int i = 0;
    80003b9e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ba0:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ba2:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003ba6:	21c48b93          	addi	s7,s1,540
    80003baa:	a81d                	j	80003be0 <pipewrite+0x70>
      release(&pi->lock);
    80003bac:	8526                	mv	a0,s1
    80003bae:	05a020ef          	jal	80005c08 <release>
      return -1;
    80003bb2:	597d                	li	s2,-1
    80003bb4:	7b02                	ld	s6,32(sp)
    80003bb6:	6be2                	ld	s7,24(sp)
    80003bb8:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003bba:	854a                	mv	a0,s2
    80003bbc:	60e6                	ld	ra,88(sp)
    80003bbe:	6446                	ld	s0,80(sp)
    80003bc0:	64a6                	ld	s1,72(sp)
    80003bc2:	6906                	ld	s2,64(sp)
    80003bc4:	79e2                	ld	s3,56(sp)
    80003bc6:	7a42                	ld	s4,48(sp)
    80003bc8:	7aa2                	ld	s5,40(sp)
    80003bca:	6125                	addi	sp,sp,96
    80003bcc:	8082                	ret
      wakeup(&pi->nread);
    80003bce:	8562                	mv	a0,s8
    80003bd0:	facfd0ef          	jal	8000137c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003bd4:	85a6                	mv	a1,s1
    80003bd6:	855e                	mv	a0,s7
    80003bd8:	f58fd0ef          	jal	80001330 <sleep>
  while(i < n){
    80003bdc:	05495b63          	bge	s2,s4,80003c32 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003be0:	2204a783          	lw	a5,544(s1)
    80003be4:	d7e1                	beqz	a5,80003bac <pipewrite+0x3c>
    80003be6:	854e                	mv	a0,s3
    80003be8:	981fd0ef          	jal	80001568 <killed>
    80003bec:	f161                	bnez	a0,80003bac <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003bee:	2184a783          	lw	a5,536(s1)
    80003bf2:	21c4a703          	lw	a4,540(s1)
    80003bf6:	2007879b          	addiw	a5,a5,512
    80003bfa:	fcf70ae3          	beq	a4,a5,80003bce <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003bfe:	4685                	li	a3,1
    80003c00:	01590633          	add	a2,s2,s5
    80003c04:	faf40593          	addi	a1,s0,-81
    80003c08:	0509b503          	ld	a0,80(s3)
    80003c0c:	e93fc0ef          	jal	80000a9e <copyin>
    80003c10:	03650e63          	beq	a0,s6,80003c4c <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003c14:	21c4a783          	lw	a5,540(s1)
    80003c18:	0017871b          	addiw	a4,a5,1
    80003c1c:	20e4ae23          	sw	a4,540(s1)
    80003c20:	1ff7f793          	andi	a5,a5,511
    80003c24:	97a6                	add	a5,a5,s1
    80003c26:	faf44703          	lbu	a4,-81(s0)
    80003c2a:	00e78c23          	sb	a4,24(a5)
      i++;
    80003c2e:	2905                	addiw	s2,s2,1
    80003c30:	b775                	j	80003bdc <pipewrite+0x6c>
    80003c32:	7b02                	ld	s6,32(sp)
    80003c34:	6be2                	ld	s7,24(sp)
    80003c36:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003c38:	21848513          	addi	a0,s1,536
    80003c3c:	f40fd0ef          	jal	8000137c <wakeup>
  release(&pi->lock);
    80003c40:	8526                	mv	a0,s1
    80003c42:	7c7010ef          	jal	80005c08 <release>
  return i;
    80003c46:	bf95                	j	80003bba <pipewrite+0x4a>
  int i = 0;
    80003c48:	4901                	li	s2,0
    80003c4a:	b7fd                	j	80003c38 <pipewrite+0xc8>
    80003c4c:	7b02                	ld	s6,32(sp)
    80003c4e:	6be2                	ld	s7,24(sp)
    80003c50:	6c42                	ld	s8,16(sp)
    80003c52:	b7dd                	j	80003c38 <pipewrite+0xc8>

0000000080003c54 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003c54:	715d                	addi	sp,sp,-80
    80003c56:	e486                	sd	ra,72(sp)
    80003c58:	e0a2                	sd	s0,64(sp)
    80003c5a:	fc26                	sd	s1,56(sp)
    80003c5c:	f84a                	sd	s2,48(sp)
    80003c5e:	f44e                	sd	s3,40(sp)
    80003c60:	f052                	sd	s4,32(sp)
    80003c62:	ec56                	sd	s5,24(sp)
    80003c64:	0880                	addi	s0,sp,80
    80003c66:	84aa                	mv	s1,a0
    80003c68:	892e                	mv	s2,a1
    80003c6a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003c6c:	8eafd0ef          	jal	80000d56 <myproc>
    80003c70:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003c72:	8526                	mv	a0,s1
    80003c74:	6fd010ef          	jal	80005b70 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003c78:	2184a703          	lw	a4,536(s1)
    80003c7c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003c80:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003c84:	02f71563          	bne	a4,a5,80003cae <piperead+0x5a>
    80003c88:	2244a783          	lw	a5,548(s1)
    80003c8c:	cb85                	beqz	a5,80003cbc <piperead+0x68>
    if(killed(pr)){
    80003c8e:	8552                	mv	a0,s4
    80003c90:	8d9fd0ef          	jal	80001568 <killed>
    80003c94:	ed19                	bnez	a0,80003cb2 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003c96:	85a6                	mv	a1,s1
    80003c98:	854e                	mv	a0,s3
    80003c9a:	e96fd0ef          	jal	80001330 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003c9e:	2184a703          	lw	a4,536(s1)
    80003ca2:	21c4a783          	lw	a5,540(s1)
    80003ca6:	fef701e3          	beq	a4,a5,80003c88 <piperead+0x34>
    80003caa:	e85a                	sd	s6,16(sp)
    80003cac:	a809                	j	80003cbe <piperead+0x6a>
    80003cae:	e85a                	sd	s6,16(sp)
    80003cb0:	a039                	j	80003cbe <piperead+0x6a>
      release(&pi->lock);
    80003cb2:	8526                	mv	a0,s1
    80003cb4:	755010ef          	jal	80005c08 <release>
      return -1;
    80003cb8:	59fd                	li	s3,-1
    80003cba:	a8b1                	j	80003d16 <piperead+0xc2>
    80003cbc:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003cbe:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003cc0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003cc2:	05505263          	blez	s5,80003d06 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003cc6:	2184a783          	lw	a5,536(s1)
    80003cca:	21c4a703          	lw	a4,540(s1)
    80003cce:	02f70c63          	beq	a4,a5,80003d06 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003cd2:	0017871b          	addiw	a4,a5,1
    80003cd6:	20e4ac23          	sw	a4,536(s1)
    80003cda:	1ff7f793          	andi	a5,a5,511
    80003cde:	97a6                	add	a5,a5,s1
    80003ce0:	0187c783          	lbu	a5,24(a5)
    80003ce4:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003ce8:	4685                	li	a3,1
    80003cea:	fbf40613          	addi	a2,s0,-65
    80003cee:	85ca                	mv	a1,s2
    80003cf0:	050a3503          	ld	a0,80(s4)
    80003cf4:	cd3fc0ef          	jal	800009c6 <copyout>
    80003cf8:	01650763          	beq	a0,s6,80003d06 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003cfc:	2985                	addiw	s3,s3,1
    80003cfe:	0905                	addi	s2,s2,1
    80003d00:	fd3a93e3          	bne	s5,s3,80003cc6 <piperead+0x72>
    80003d04:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003d06:	21c48513          	addi	a0,s1,540
    80003d0a:	e72fd0ef          	jal	8000137c <wakeup>
  release(&pi->lock);
    80003d0e:	8526                	mv	a0,s1
    80003d10:	6f9010ef          	jal	80005c08 <release>
    80003d14:	6b42                	ld	s6,16(sp)
  return i;
}
    80003d16:	854e                	mv	a0,s3
    80003d18:	60a6                	ld	ra,72(sp)
    80003d1a:	6406                	ld	s0,64(sp)
    80003d1c:	74e2                	ld	s1,56(sp)
    80003d1e:	7942                	ld	s2,48(sp)
    80003d20:	79a2                	ld	s3,40(sp)
    80003d22:	7a02                	ld	s4,32(sp)
    80003d24:	6ae2                	ld	s5,24(sp)
    80003d26:	6161                	addi	sp,sp,80
    80003d28:	8082                	ret

0000000080003d2a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003d2a:	1141                	addi	sp,sp,-16
    80003d2c:	e422                	sd	s0,8(sp)
    80003d2e:	0800                	addi	s0,sp,16
    80003d30:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003d32:	8905                	andi	a0,a0,1
    80003d34:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003d36:	8b89                	andi	a5,a5,2
    80003d38:	c399                	beqz	a5,80003d3e <flags2perm+0x14>
      perm |= PTE_W;
    80003d3a:	00456513          	ori	a0,a0,4
    return perm;
}
    80003d3e:	6422                	ld	s0,8(sp)
    80003d40:	0141                	addi	sp,sp,16
    80003d42:	8082                	ret

0000000080003d44 <exec>:

int
exec(char *path, char **argv)
{
    80003d44:	df010113          	addi	sp,sp,-528
    80003d48:	20113423          	sd	ra,520(sp)
    80003d4c:	20813023          	sd	s0,512(sp)
    80003d50:	ffa6                	sd	s1,504(sp)
    80003d52:	fbca                	sd	s2,496(sp)
    80003d54:	0c00                	addi	s0,sp,528
    80003d56:	892a                	mv	s2,a0
    80003d58:	dea43c23          	sd	a0,-520(s0)
    80003d5c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003d60:	ff7fc0ef          	jal	80000d56 <myproc>
    80003d64:	84aa                	mv	s1,a0

  begin_op();
    80003d66:	dc6ff0ef          	jal	8000332c <begin_op>

  if((ip = namei(path)) == 0){
    80003d6a:	854a                	mv	a0,s2
    80003d6c:	c04ff0ef          	jal	80003170 <namei>
    80003d70:	c931                	beqz	a0,80003dc4 <exec+0x80>
    80003d72:	f3d2                	sd	s4,480(sp)
    80003d74:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003d76:	d21fe0ef          	jal	80002a96 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003d7a:	04000713          	li	a4,64
    80003d7e:	4681                	li	a3,0
    80003d80:	e5040613          	addi	a2,s0,-432
    80003d84:	4581                	li	a1,0
    80003d86:	8552                	mv	a0,s4
    80003d88:	f63fe0ef          	jal	80002cea <readi>
    80003d8c:	04000793          	li	a5,64
    80003d90:	00f51a63          	bne	a0,a5,80003da4 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003d94:	e5042703          	lw	a4,-432(s0)
    80003d98:	464c47b7          	lui	a5,0x464c4
    80003d9c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003da0:	02f70663          	beq	a4,a5,80003dcc <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003da4:	8552                	mv	a0,s4
    80003da6:	efbfe0ef          	jal	80002ca0 <iunlockput>
    end_op();
    80003daa:	decff0ef          	jal	80003396 <end_op>
  }
  return -1;
    80003dae:	557d                	li	a0,-1
    80003db0:	7a1e                	ld	s4,480(sp)
}
    80003db2:	20813083          	ld	ra,520(sp)
    80003db6:	20013403          	ld	s0,512(sp)
    80003dba:	74fe                	ld	s1,504(sp)
    80003dbc:	795e                	ld	s2,496(sp)
    80003dbe:	21010113          	addi	sp,sp,528
    80003dc2:	8082                	ret
    end_op();
    80003dc4:	dd2ff0ef          	jal	80003396 <end_op>
    return -1;
    80003dc8:	557d                	li	a0,-1
    80003dca:	b7e5                	j	80003db2 <exec+0x6e>
    80003dcc:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003dce:	8526                	mv	a0,s1
    80003dd0:	82efd0ef          	jal	80000dfe <proc_pagetable>
    80003dd4:	8b2a                	mv	s6,a0
    80003dd6:	2c050b63          	beqz	a0,800040ac <exec+0x368>
    80003dda:	f7ce                	sd	s3,488(sp)
    80003ddc:	efd6                	sd	s5,472(sp)
    80003dde:	e7de                	sd	s7,456(sp)
    80003de0:	e3e2                	sd	s8,448(sp)
    80003de2:	ff66                	sd	s9,440(sp)
    80003de4:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003de6:	e7042d03          	lw	s10,-400(s0)
    80003dea:	e8845783          	lhu	a5,-376(s0)
    80003dee:	12078963          	beqz	a5,80003f20 <exec+0x1dc>
    80003df2:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003df4:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003df6:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003df8:	6c85                	lui	s9,0x1
    80003dfa:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003dfe:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003e02:	6a85                	lui	s5,0x1
    80003e04:	a085                	j	80003e64 <exec+0x120>
      panic("loadseg: address should exist");
    80003e06:	00004517          	auipc	a0,0x4
    80003e0a:	90a50513          	addi	a0,a0,-1782 # 80007710 <etext+0x710>
    80003e0e:	235010ef          	jal	80005842 <panic>
    if(sz - i < PGSIZE)
    80003e12:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003e14:	8726                	mv	a4,s1
    80003e16:	012c06bb          	addw	a3,s8,s2
    80003e1a:	4581                	li	a1,0
    80003e1c:	8552                	mv	a0,s4
    80003e1e:	ecdfe0ef          	jal	80002cea <readi>
    80003e22:	2501                	sext.w	a0,a0
    80003e24:	24a49a63          	bne	s1,a0,80004078 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003e28:	012a893b          	addw	s2,s5,s2
    80003e2c:	03397363          	bgeu	s2,s3,80003e52 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003e30:	02091593          	slli	a1,s2,0x20
    80003e34:	9181                	srli	a1,a1,0x20
    80003e36:	95de                	add	a1,a1,s7
    80003e38:	855a                	mv	a0,s6
    80003e3a:	e08fc0ef          	jal	80000442 <walkaddr>
    80003e3e:	862a                	mv	a2,a0
    if(pa == 0)
    80003e40:	d179                	beqz	a0,80003e06 <exec+0xc2>
    if(sz - i < PGSIZE)
    80003e42:	412984bb          	subw	s1,s3,s2
    80003e46:	0004879b          	sext.w	a5,s1
    80003e4a:	fcfcf4e3          	bgeu	s9,a5,80003e12 <exec+0xce>
    80003e4e:	84d6                	mv	s1,s5
    80003e50:	b7c9                	j	80003e12 <exec+0xce>
    sz = sz1;
    80003e52:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003e56:	2d85                	addiw	s11,s11,1
    80003e58:	038d0d1b          	addiw	s10,s10,56
    80003e5c:	e8845783          	lhu	a5,-376(s0)
    80003e60:	08fdd063          	bge	s11,a5,80003ee0 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003e64:	2d01                	sext.w	s10,s10
    80003e66:	03800713          	li	a4,56
    80003e6a:	86ea                	mv	a3,s10
    80003e6c:	e1840613          	addi	a2,s0,-488
    80003e70:	4581                	li	a1,0
    80003e72:	8552                	mv	a0,s4
    80003e74:	e77fe0ef          	jal	80002cea <readi>
    80003e78:	03800793          	li	a5,56
    80003e7c:	1cf51663          	bne	a0,a5,80004048 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003e80:	e1842783          	lw	a5,-488(s0)
    80003e84:	4705                	li	a4,1
    80003e86:	fce798e3          	bne	a5,a4,80003e56 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003e8a:	e4043483          	ld	s1,-448(s0)
    80003e8e:	e3843783          	ld	a5,-456(s0)
    80003e92:	1af4ef63          	bltu	s1,a5,80004050 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003e96:	e2843783          	ld	a5,-472(s0)
    80003e9a:	94be                	add	s1,s1,a5
    80003e9c:	1af4ee63          	bltu	s1,a5,80004058 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003ea0:	df043703          	ld	a4,-528(s0)
    80003ea4:	8ff9                	and	a5,a5,a4
    80003ea6:	1a079d63          	bnez	a5,80004060 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003eaa:	e1c42503          	lw	a0,-484(s0)
    80003eae:	e7dff0ef          	jal	80003d2a <flags2perm>
    80003eb2:	86aa                	mv	a3,a0
    80003eb4:	8626                	mv	a2,s1
    80003eb6:	85ca                	mv	a1,s2
    80003eb8:	855a                	mv	a0,s6
    80003eba:	901fc0ef          	jal	800007ba <uvmalloc>
    80003ebe:	e0a43423          	sd	a0,-504(s0)
    80003ec2:	1a050363          	beqz	a0,80004068 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003ec6:	e2843b83          	ld	s7,-472(s0)
    80003eca:	e2042c03          	lw	s8,-480(s0)
    80003ece:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003ed2:	00098463          	beqz	s3,80003eda <exec+0x196>
    80003ed6:	4901                	li	s2,0
    80003ed8:	bfa1                	j	80003e30 <exec+0xec>
    sz = sz1;
    80003eda:	e0843903          	ld	s2,-504(s0)
    80003ede:	bfa5                	j	80003e56 <exec+0x112>
    80003ee0:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003ee2:	8552                	mv	a0,s4
    80003ee4:	dbdfe0ef          	jal	80002ca0 <iunlockput>
  end_op();
    80003ee8:	caeff0ef          	jal	80003396 <end_op>
  p = myproc();
    80003eec:	e6bfc0ef          	jal	80000d56 <myproc>
    80003ef0:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003ef2:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003ef6:	6985                	lui	s3,0x1
    80003ef8:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003efa:	99ca                	add	s3,s3,s2
    80003efc:	77fd                	lui	a5,0xfffff
    80003efe:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003f02:	4691                	li	a3,4
    80003f04:	6609                	lui	a2,0x2
    80003f06:	964e                	add	a2,a2,s3
    80003f08:	85ce                	mv	a1,s3
    80003f0a:	855a                	mv	a0,s6
    80003f0c:	8affc0ef          	jal	800007ba <uvmalloc>
    80003f10:	892a                	mv	s2,a0
    80003f12:	e0a43423          	sd	a0,-504(s0)
    80003f16:	e519                	bnez	a0,80003f24 <exec+0x1e0>
  if(pagetable)
    80003f18:	e1343423          	sd	s3,-504(s0)
    80003f1c:	4a01                	li	s4,0
    80003f1e:	aab1                	j	8000407a <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003f20:	4901                	li	s2,0
    80003f22:	b7c1                	j	80003ee2 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003f24:	75f9                	lui	a1,0xffffe
    80003f26:	95aa                	add	a1,a1,a0
    80003f28:	855a                	mv	a0,s6
    80003f2a:	a73fc0ef          	jal	8000099c <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003f2e:	7bfd                	lui	s7,0xfffff
    80003f30:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003f32:	e0043783          	ld	a5,-512(s0)
    80003f36:	6388                	ld	a0,0(a5)
    80003f38:	cd39                	beqz	a0,80003f96 <exec+0x252>
    80003f3a:	e9040993          	addi	s3,s0,-368
    80003f3e:	f9040c13          	addi	s8,s0,-112
    80003f42:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003f44:	b60fc0ef          	jal	800002a4 <strlen>
    80003f48:	0015079b          	addiw	a5,a0,1
    80003f4c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003f50:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003f54:	11796e63          	bltu	s2,s7,80004070 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003f58:	e0043d03          	ld	s10,-512(s0)
    80003f5c:	000d3a03          	ld	s4,0(s10)
    80003f60:	8552                	mv	a0,s4
    80003f62:	b42fc0ef          	jal	800002a4 <strlen>
    80003f66:	0015069b          	addiw	a3,a0,1
    80003f6a:	8652                	mv	a2,s4
    80003f6c:	85ca                	mv	a1,s2
    80003f6e:	855a                	mv	a0,s6
    80003f70:	a57fc0ef          	jal	800009c6 <copyout>
    80003f74:	10054063          	bltz	a0,80004074 <exec+0x330>
    ustack[argc] = sp;
    80003f78:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003f7c:	0485                	addi	s1,s1,1
    80003f7e:	008d0793          	addi	a5,s10,8
    80003f82:	e0f43023          	sd	a5,-512(s0)
    80003f86:	008d3503          	ld	a0,8(s10)
    80003f8a:	c909                	beqz	a0,80003f9c <exec+0x258>
    if(argc >= MAXARG)
    80003f8c:	09a1                	addi	s3,s3,8
    80003f8e:	fb899be3          	bne	s3,s8,80003f44 <exec+0x200>
  ip = 0;
    80003f92:	4a01                	li	s4,0
    80003f94:	a0dd                	j	8000407a <exec+0x336>
  sp = sz;
    80003f96:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003f9a:	4481                	li	s1,0
  ustack[argc] = 0;
    80003f9c:	00349793          	slli	a5,s1,0x3
    80003fa0:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb210>
    80003fa4:	97a2                	add	a5,a5,s0
    80003fa6:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003faa:	00148693          	addi	a3,s1,1
    80003fae:	068e                	slli	a3,a3,0x3
    80003fb0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003fb4:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003fb8:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003fbc:	f5796ee3          	bltu	s2,s7,80003f18 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003fc0:	e9040613          	addi	a2,s0,-368
    80003fc4:	85ca                	mv	a1,s2
    80003fc6:	855a                	mv	a0,s6
    80003fc8:	9fffc0ef          	jal	800009c6 <copyout>
    80003fcc:	0e054263          	bltz	a0,800040b0 <exec+0x36c>
  p->trapframe->a1 = sp;
    80003fd0:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003fd4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003fd8:	df843783          	ld	a5,-520(s0)
    80003fdc:	0007c703          	lbu	a4,0(a5)
    80003fe0:	cf11                	beqz	a4,80003ffc <exec+0x2b8>
    80003fe2:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003fe4:	02f00693          	li	a3,47
    80003fe8:	a039                	j	80003ff6 <exec+0x2b2>
      last = s+1;
    80003fea:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003fee:	0785                	addi	a5,a5,1
    80003ff0:	fff7c703          	lbu	a4,-1(a5)
    80003ff4:	c701                	beqz	a4,80003ffc <exec+0x2b8>
    if(*s == '/')
    80003ff6:	fed71ce3          	bne	a4,a3,80003fee <exec+0x2aa>
    80003ffa:	bfc5                	j	80003fea <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003ffc:	4641                	li	a2,16
    80003ffe:	df843583          	ld	a1,-520(s0)
    80004002:	158a8513          	addi	a0,s5,344
    80004006:	a6cfc0ef          	jal	80000272 <safestrcpy>
  oldpagetable = p->pagetable;
    8000400a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000400e:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004012:	e0843783          	ld	a5,-504(s0)
    80004016:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000401a:	058ab783          	ld	a5,88(s5)
    8000401e:	e6843703          	ld	a4,-408(s0)
    80004022:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004024:	058ab783          	ld	a5,88(s5)
    80004028:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000402c:	85e6                	mv	a1,s9
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
    80004046:	b3b5                	j	80003db2 <exec+0x6e>
    80004048:	e1243423          	sd	s2,-504(s0)
    8000404c:	7dba                	ld	s11,424(sp)
    8000404e:	a035                	j	8000407a <exec+0x336>
    80004050:	e1243423          	sd	s2,-504(s0)
    80004054:	7dba                	ld	s11,424(sp)
    80004056:	a015                	j	8000407a <exec+0x336>
    80004058:	e1243423          	sd	s2,-504(s0)
    8000405c:	7dba                	ld	s11,424(sp)
    8000405e:	a831                	j	8000407a <exec+0x336>
    80004060:	e1243423          	sd	s2,-504(s0)
    80004064:	7dba                	ld	s11,424(sp)
    80004066:	a811                	j	8000407a <exec+0x336>
    80004068:	e1243423          	sd	s2,-504(s0)
    8000406c:	7dba                	ld	s11,424(sp)
    8000406e:	a031                	j	8000407a <exec+0x336>
  ip = 0;
    80004070:	4a01                	li	s4,0
    80004072:	a021                	j	8000407a <exec+0x336>
    80004074:	4a01                	li	s4,0
  if(pagetable)
    80004076:	a011                	j	8000407a <exec+0x336>
    80004078:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    8000407a:	e0843583          	ld	a1,-504(s0)
    8000407e:	855a                	mv	a0,s6
    80004080:	e03fc0ef          	jal	80000e82 <proc_freepagetable>
  return -1;
    80004084:	557d                	li	a0,-1
  if(ip){
    80004086:	000a1b63          	bnez	s4,8000409c <exec+0x358>
    8000408a:	79be                	ld	s3,488(sp)
    8000408c:	7a1e                	ld	s4,480(sp)
    8000408e:	6afe                	ld	s5,472(sp)
    80004090:	6b5e                	ld	s6,464(sp)
    80004092:	6bbe                	ld	s7,456(sp)
    80004094:	6c1e                	ld	s8,448(sp)
    80004096:	7cfa                	ld	s9,440(sp)
    80004098:	7d5a                	ld	s10,432(sp)
    8000409a:	bb21                	j	80003db2 <exec+0x6e>
    8000409c:	79be                	ld	s3,488(sp)
    8000409e:	6afe                	ld	s5,472(sp)
    800040a0:	6b5e                	ld	s6,464(sp)
    800040a2:	6bbe                	ld	s7,456(sp)
    800040a4:	6c1e                	ld	s8,448(sp)
    800040a6:	7cfa                	ld	s9,440(sp)
    800040a8:	7d5a                	ld	s10,432(sp)
    800040aa:	b9ed                	j	80003da4 <exec+0x60>
    800040ac:	6b5e                	ld	s6,464(sp)
    800040ae:	b9dd                	j	80003da4 <exec+0x60>
  sz = sz1;
    800040b0:	e0843983          	ld	s3,-504(s0)
    800040b4:	b595                	j	80003f18 <exec+0x1d4>

00000000800040b6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800040b6:	7179                	addi	sp,sp,-48
    800040b8:	f406                	sd	ra,40(sp)
    800040ba:	f022                	sd	s0,32(sp)
    800040bc:	ec26                	sd	s1,24(sp)
    800040be:	e84a                	sd	s2,16(sp)
    800040c0:	1800                	addi	s0,sp,48
    800040c2:	892e                	mv	s2,a1
    800040c4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800040c6:	fdc40593          	addi	a1,s0,-36
    800040ca:	b4dfd0ef          	jal	80001c16 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800040ce:	fdc42703          	lw	a4,-36(s0)
    800040d2:	47bd                	li	a5,15
    800040d4:	02e7e963          	bltu	a5,a4,80004106 <argfd+0x50>
    800040d8:	c7ffc0ef          	jal	80000d56 <myproc>
    800040dc:	fdc42703          	lw	a4,-36(s0)
    800040e0:	01a70793          	addi	a5,a4,26
    800040e4:	078e                	slli	a5,a5,0x3
    800040e6:	953e                	add	a0,a0,a5
    800040e8:	611c                	ld	a5,0(a0)
    800040ea:	c385                	beqz	a5,8000410a <argfd+0x54>
    return -1;
  if(pfd)
    800040ec:	00090463          	beqz	s2,800040f4 <argfd+0x3e>
    *pfd = fd;
    800040f0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800040f4:	4501                	li	a0,0
  if(pf)
    800040f6:	c091                	beqz	s1,800040fa <argfd+0x44>
    *pf = f;
    800040f8:	e09c                	sd	a5,0(s1)
}
    800040fa:	70a2                	ld	ra,40(sp)
    800040fc:	7402                	ld	s0,32(sp)
    800040fe:	64e2                	ld	s1,24(sp)
    80004100:	6942                	ld	s2,16(sp)
    80004102:	6145                	addi	sp,sp,48
    80004104:	8082                	ret
    return -1;
    80004106:	557d                	li	a0,-1
    80004108:	bfcd                	j	800040fa <argfd+0x44>
    8000410a:	557d                	li	a0,-1
    8000410c:	b7fd                	j	800040fa <argfd+0x44>

000000008000410e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000410e:	1101                	addi	sp,sp,-32
    80004110:	ec06                	sd	ra,24(sp)
    80004112:	e822                	sd	s0,16(sp)
    80004114:	e426                	sd	s1,8(sp)
    80004116:	1000                	addi	s0,sp,32
    80004118:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000411a:	c3dfc0ef          	jal	80000d56 <myproc>
    8000411e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004120:	0d050793          	addi	a5,a0,208
    80004124:	4501                	li	a0,0
    80004126:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004128:	6398                	ld	a4,0(a5)
    8000412a:	cb19                	beqz	a4,80004140 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    8000412c:	2505                	addiw	a0,a0,1
    8000412e:	07a1                	addi	a5,a5,8
    80004130:	fed51ce3          	bne	a0,a3,80004128 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004134:	557d                	li	a0,-1
}
    80004136:	60e2                	ld	ra,24(sp)
    80004138:	6442                	ld	s0,16(sp)
    8000413a:	64a2                	ld	s1,8(sp)
    8000413c:	6105                	addi	sp,sp,32
    8000413e:	8082                	ret
      p->ofile[fd] = f;
    80004140:	01a50793          	addi	a5,a0,26
    80004144:	078e                	slli	a5,a5,0x3
    80004146:	963e                	add	a2,a2,a5
    80004148:	e204                	sd	s1,0(a2)
      return fd;
    8000414a:	b7f5                	j	80004136 <fdalloc+0x28>

000000008000414c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000414c:	715d                	addi	sp,sp,-80
    8000414e:	e486                	sd	ra,72(sp)
    80004150:	e0a2                	sd	s0,64(sp)
    80004152:	fc26                	sd	s1,56(sp)
    80004154:	f84a                	sd	s2,48(sp)
    80004156:	f44e                	sd	s3,40(sp)
    80004158:	ec56                	sd	s5,24(sp)
    8000415a:	e85a                	sd	s6,16(sp)
    8000415c:	0880                	addi	s0,sp,80
    8000415e:	8b2e                	mv	s6,a1
    80004160:	89b2                	mv	s3,a2
    80004162:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004164:	fb040593          	addi	a1,s0,-80
    80004168:	822ff0ef          	jal	8000318a <nameiparent>
    8000416c:	84aa                	mv	s1,a0
    8000416e:	10050a63          	beqz	a0,80004282 <create+0x136>
    return 0;

  ilock(dp);
    80004172:	925fe0ef          	jal	80002a96 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004176:	4601                	li	a2,0
    80004178:	fb040593          	addi	a1,s0,-80
    8000417c:	8526                	mv	a0,s1
    8000417e:	d8dfe0ef          	jal	80002f0a <dirlookup>
    80004182:	8aaa                	mv	s5,a0
    80004184:	c129                	beqz	a0,800041c6 <create+0x7a>
    iunlockput(dp);
    80004186:	8526                	mv	a0,s1
    80004188:	b19fe0ef          	jal	80002ca0 <iunlockput>
    ilock(ip);
    8000418c:	8556                	mv	a0,s5
    8000418e:	909fe0ef          	jal	80002a96 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004192:	4789                	li	a5,2
    80004194:	02fb1463          	bne	s6,a5,800041bc <create+0x70>
    80004198:	044ad783          	lhu	a5,68(s5)
    8000419c:	37f9                	addiw	a5,a5,-2
    8000419e:	17c2                	slli	a5,a5,0x30
    800041a0:	93c1                	srli	a5,a5,0x30
    800041a2:	4705                	li	a4,1
    800041a4:	00f76c63          	bltu	a4,a5,800041bc <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800041a8:	8556                	mv	a0,s5
    800041aa:	60a6                	ld	ra,72(sp)
    800041ac:	6406                	ld	s0,64(sp)
    800041ae:	74e2                	ld	s1,56(sp)
    800041b0:	7942                	ld	s2,48(sp)
    800041b2:	79a2                	ld	s3,40(sp)
    800041b4:	6ae2                	ld	s5,24(sp)
    800041b6:	6b42                	ld	s6,16(sp)
    800041b8:	6161                	addi	sp,sp,80
    800041ba:	8082                	ret
    iunlockput(ip);
    800041bc:	8556                	mv	a0,s5
    800041be:	ae3fe0ef          	jal	80002ca0 <iunlockput>
    return 0;
    800041c2:	4a81                	li	s5,0
    800041c4:	b7d5                	j	800041a8 <create+0x5c>
    800041c6:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800041c8:	85da                	mv	a1,s6
    800041ca:	4088                	lw	a0,0(s1)
    800041cc:	f5afe0ef          	jal	80002926 <ialloc>
    800041d0:	8a2a                	mv	s4,a0
    800041d2:	cd15                	beqz	a0,8000420e <create+0xc2>
  ilock(ip);
    800041d4:	8c3fe0ef          	jal	80002a96 <ilock>
  ip->major = major;
    800041d8:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800041dc:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800041e0:	4905                	li	s2,1
    800041e2:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800041e6:	8552                	mv	a0,s4
    800041e8:	ffafe0ef          	jal	800029e2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800041ec:	032b0763          	beq	s6,s2,8000421a <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    800041f0:	004a2603          	lw	a2,4(s4)
    800041f4:	fb040593          	addi	a1,s0,-80
    800041f8:	8526                	mv	a0,s1
    800041fa:	eddfe0ef          	jal	800030d6 <dirlink>
    800041fe:	06054563          	bltz	a0,80004268 <create+0x11c>
  iunlockput(dp);
    80004202:	8526                	mv	a0,s1
    80004204:	a9dfe0ef          	jal	80002ca0 <iunlockput>
  return ip;
    80004208:	8ad2                	mv	s5,s4
    8000420a:	7a02                	ld	s4,32(sp)
    8000420c:	bf71                	j	800041a8 <create+0x5c>
    iunlockput(dp);
    8000420e:	8526                	mv	a0,s1
    80004210:	a91fe0ef          	jal	80002ca0 <iunlockput>
    return 0;
    80004214:	8ad2                	mv	s5,s4
    80004216:	7a02                	ld	s4,32(sp)
    80004218:	bf41                	j	800041a8 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000421a:	004a2603          	lw	a2,4(s4)
    8000421e:	00003597          	auipc	a1,0x3
    80004222:	51258593          	addi	a1,a1,1298 # 80007730 <etext+0x730>
    80004226:	8552                	mv	a0,s4
    80004228:	eaffe0ef          	jal	800030d6 <dirlink>
    8000422c:	02054e63          	bltz	a0,80004268 <create+0x11c>
    80004230:	40d0                	lw	a2,4(s1)
    80004232:	00003597          	auipc	a1,0x3
    80004236:	50658593          	addi	a1,a1,1286 # 80007738 <etext+0x738>
    8000423a:	8552                	mv	a0,s4
    8000423c:	e9bfe0ef          	jal	800030d6 <dirlink>
    80004240:	02054463          	bltz	a0,80004268 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004244:	004a2603          	lw	a2,4(s4)
    80004248:	fb040593          	addi	a1,s0,-80
    8000424c:	8526                	mv	a0,s1
    8000424e:	e89fe0ef          	jal	800030d6 <dirlink>
    80004252:	00054b63          	bltz	a0,80004268 <create+0x11c>
    dp->nlink++;  // for ".."
    80004256:	04a4d783          	lhu	a5,74(s1)
    8000425a:	2785                	addiw	a5,a5,1
    8000425c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004260:	8526                	mv	a0,s1
    80004262:	f80fe0ef          	jal	800029e2 <iupdate>
    80004266:	bf71                	j	80004202 <create+0xb6>
  ip->nlink = 0;
    80004268:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000426c:	8552                	mv	a0,s4
    8000426e:	f74fe0ef          	jal	800029e2 <iupdate>
  iunlockput(ip);
    80004272:	8552                	mv	a0,s4
    80004274:	a2dfe0ef          	jal	80002ca0 <iunlockput>
  iunlockput(dp);
    80004278:	8526                	mv	a0,s1
    8000427a:	a27fe0ef          	jal	80002ca0 <iunlockput>
  return 0;
    8000427e:	7a02                	ld	s4,32(sp)
    80004280:	b725                	j	800041a8 <create+0x5c>
    return 0;
    80004282:	8aaa                	mv	s5,a0
    80004284:	b715                	j	800041a8 <create+0x5c>

0000000080004286 <sys_dup>:
{
    80004286:	7179                	addi	sp,sp,-48
    80004288:	f406                	sd	ra,40(sp)
    8000428a:	f022                	sd	s0,32(sp)
    8000428c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000428e:	fd840613          	addi	a2,s0,-40
    80004292:	4581                	li	a1,0
    80004294:	4501                	li	a0,0
    80004296:	e21ff0ef          	jal	800040b6 <argfd>
    return -1;
    8000429a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000429c:	02054363          	bltz	a0,800042c2 <sys_dup+0x3c>
    800042a0:	ec26                	sd	s1,24(sp)
    800042a2:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800042a4:	fd843903          	ld	s2,-40(s0)
    800042a8:	854a                	mv	a0,s2
    800042aa:	e65ff0ef          	jal	8000410e <fdalloc>
    800042ae:	84aa                	mv	s1,a0
    return -1;
    800042b0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800042b2:	00054d63          	bltz	a0,800042cc <sys_dup+0x46>
  filedup(f);
    800042b6:	854a                	mv	a0,s2
    800042b8:	c48ff0ef          	jal	80003700 <filedup>
  return fd;
    800042bc:	87a6                	mv	a5,s1
    800042be:	64e2                	ld	s1,24(sp)
    800042c0:	6942                	ld	s2,16(sp)
}
    800042c2:	853e                	mv	a0,a5
    800042c4:	70a2                	ld	ra,40(sp)
    800042c6:	7402                	ld	s0,32(sp)
    800042c8:	6145                	addi	sp,sp,48
    800042ca:	8082                	ret
    800042cc:	64e2                	ld	s1,24(sp)
    800042ce:	6942                	ld	s2,16(sp)
    800042d0:	bfcd                	j	800042c2 <sys_dup+0x3c>

00000000800042d2 <sys_read>:
{
    800042d2:	7179                	addi	sp,sp,-48
    800042d4:	f406                	sd	ra,40(sp)
    800042d6:	f022                	sd	s0,32(sp)
    800042d8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800042da:	fd840593          	addi	a1,s0,-40
    800042de:	4505                	li	a0,1
    800042e0:	953fd0ef          	jal	80001c32 <argaddr>
  argint(2, &n);
    800042e4:	fe440593          	addi	a1,s0,-28
    800042e8:	4509                	li	a0,2
    800042ea:	92dfd0ef          	jal	80001c16 <argint>
  if(argfd(0, 0, &f) < 0)
    800042ee:	fe840613          	addi	a2,s0,-24
    800042f2:	4581                	li	a1,0
    800042f4:	4501                	li	a0,0
    800042f6:	dc1ff0ef          	jal	800040b6 <argfd>
    800042fa:	87aa                	mv	a5,a0
    return -1;
    800042fc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800042fe:	0007ca63          	bltz	a5,80004312 <sys_read+0x40>
  return fileread(f, p, n);
    80004302:	fe442603          	lw	a2,-28(s0)
    80004306:	fd843583          	ld	a1,-40(s0)
    8000430a:	fe843503          	ld	a0,-24(s0)
    8000430e:	d58ff0ef          	jal	80003866 <fileread>
}
    80004312:	70a2                	ld	ra,40(sp)
    80004314:	7402                	ld	s0,32(sp)
    80004316:	6145                	addi	sp,sp,48
    80004318:	8082                	ret

000000008000431a <sys_write>:
{
    8000431a:	7179                	addi	sp,sp,-48
    8000431c:	f406                	sd	ra,40(sp)
    8000431e:	f022                	sd	s0,32(sp)
    80004320:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004322:	fd840593          	addi	a1,s0,-40
    80004326:	4505                	li	a0,1
    80004328:	90bfd0ef          	jal	80001c32 <argaddr>
  argint(2, &n);
    8000432c:	fe440593          	addi	a1,s0,-28
    80004330:	4509                	li	a0,2
    80004332:	8e5fd0ef          	jal	80001c16 <argint>
  if(argfd(0, 0, &f) < 0)
    80004336:	fe840613          	addi	a2,s0,-24
    8000433a:	4581                	li	a1,0
    8000433c:	4501                	li	a0,0
    8000433e:	d79ff0ef          	jal	800040b6 <argfd>
    80004342:	87aa                	mv	a5,a0
    return -1;
    80004344:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004346:	0007ca63          	bltz	a5,8000435a <sys_write+0x40>
  return filewrite(f, p, n);
    8000434a:	fe442603          	lw	a2,-28(s0)
    8000434e:	fd843583          	ld	a1,-40(s0)
    80004352:	fe843503          	ld	a0,-24(s0)
    80004356:	dceff0ef          	jal	80003924 <filewrite>
}
    8000435a:	70a2                	ld	ra,40(sp)
    8000435c:	7402                	ld	s0,32(sp)
    8000435e:	6145                	addi	sp,sp,48
    80004360:	8082                	ret

0000000080004362 <sys_close>:
{
    80004362:	1101                	addi	sp,sp,-32
    80004364:	ec06                	sd	ra,24(sp)
    80004366:	e822                	sd	s0,16(sp)
    80004368:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000436a:	fe040613          	addi	a2,s0,-32
    8000436e:	fec40593          	addi	a1,s0,-20
    80004372:	4501                	li	a0,0
    80004374:	d43ff0ef          	jal	800040b6 <argfd>
    return -1;
    80004378:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000437a:	02054063          	bltz	a0,8000439a <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000437e:	9d9fc0ef          	jal	80000d56 <myproc>
    80004382:	fec42783          	lw	a5,-20(s0)
    80004386:	07e9                	addi	a5,a5,26
    80004388:	078e                	slli	a5,a5,0x3
    8000438a:	953e                	add	a0,a0,a5
    8000438c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004390:	fe043503          	ld	a0,-32(s0)
    80004394:	bb2ff0ef          	jal	80003746 <fileclose>
  return 0;
    80004398:	4781                	li	a5,0
}
    8000439a:	853e                	mv	a0,a5
    8000439c:	60e2                	ld	ra,24(sp)
    8000439e:	6442                	ld	s0,16(sp)
    800043a0:	6105                	addi	sp,sp,32
    800043a2:	8082                	ret

00000000800043a4 <sys_fstat>:
{
    800043a4:	1101                	addi	sp,sp,-32
    800043a6:	ec06                	sd	ra,24(sp)
    800043a8:	e822                	sd	s0,16(sp)
    800043aa:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800043ac:	fe040593          	addi	a1,s0,-32
    800043b0:	4505                	li	a0,1
    800043b2:	881fd0ef          	jal	80001c32 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800043b6:	fe840613          	addi	a2,s0,-24
    800043ba:	4581                	li	a1,0
    800043bc:	4501                	li	a0,0
    800043be:	cf9ff0ef          	jal	800040b6 <argfd>
    800043c2:	87aa                	mv	a5,a0
    return -1;
    800043c4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800043c6:	0007c863          	bltz	a5,800043d6 <sys_fstat+0x32>
  return filestat(f, st);
    800043ca:	fe043583          	ld	a1,-32(s0)
    800043ce:	fe843503          	ld	a0,-24(s0)
    800043d2:	c36ff0ef          	jal	80003808 <filestat>
}
    800043d6:	60e2                	ld	ra,24(sp)
    800043d8:	6442                	ld	s0,16(sp)
    800043da:	6105                	addi	sp,sp,32
    800043dc:	8082                	ret

00000000800043de <sys_link>:
{
    800043de:	7169                	addi	sp,sp,-304
    800043e0:	f606                	sd	ra,296(sp)
    800043e2:	f222                	sd	s0,288(sp)
    800043e4:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800043e6:	08000613          	li	a2,128
    800043ea:	ed040593          	addi	a1,s0,-304
    800043ee:	4501                	li	a0,0
    800043f0:	85ffd0ef          	jal	80001c4e <argstr>
    return -1;
    800043f4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800043f6:	0c054e63          	bltz	a0,800044d2 <sys_link+0xf4>
    800043fa:	08000613          	li	a2,128
    800043fe:	f5040593          	addi	a1,s0,-176
    80004402:	4505                	li	a0,1
    80004404:	84bfd0ef          	jal	80001c4e <argstr>
    return -1;
    80004408:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000440a:	0c054463          	bltz	a0,800044d2 <sys_link+0xf4>
    8000440e:	ee26                	sd	s1,280(sp)
  begin_op();
    80004410:	f1dfe0ef          	jal	8000332c <begin_op>
  if((ip = namei(old)) == 0){
    80004414:	ed040513          	addi	a0,s0,-304
    80004418:	d59fe0ef          	jal	80003170 <namei>
    8000441c:	84aa                	mv	s1,a0
    8000441e:	c53d                	beqz	a0,8000448c <sys_link+0xae>
  ilock(ip);
    80004420:	e76fe0ef          	jal	80002a96 <ilock>
  if(ip->type == T_DIR){
    80004424:	04449703          	lh	a4,68(s1)
    80004428:	4785                	li	a5,1
    8000442a:	06f70663          	beq	a4,a5,80004496 <sys_link+0xb8>
    8000442e:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004430:	04a4d783          	lhu	a5,74(s1)
    80004434:	2785                	addiw	a5,a5,1
    80004436:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000443a:	8526                	mv	a0,s1
    8000443c:	da6fe0ef          	jal	800029e2 <iupdate>
  iunlock(ip);
    80004440:	8526                	mv	a0,s1
    80004442:	f02fe0ef          	jal	80002b44 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004446:	fd040593          	addi	a1,s0,-48
    8000444a:	f5040513          	addi	a0,s0,-176
    8000444e:	d3dfe0ef          	jal	8000318a <nameiparent>
    80004452:	892a                	mv	s2,a0
    80004454:	cd21                	beqz	a0,800044ac <sys_link+0xce>
  ilock(dp);
    80004456:	e40fe0ef          	jal	80002a96 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000445a:	00092703          	lw	a4,0(s2)
    8000445e:	409c                	lw	a5,0(s1)
    80004460:	04f71363          	bne	a4,a5,800044a6 <sys_link+0xc8>
    80004464:	40d0                	lw	a2,4(s1)
    80004466:	fd040593          	addi	a1,s0,-48
    8000446a:	854a                	mv	a0,s2
    8000446c:	c6bfe0ef          	jal	800030d6 <dirlink>
    80004470:	02054b63          	bltz	a0,800044a6 <sys_link+0xc8>
  iunlockput(dp);
    80004474:	854a                	mv	a0,s2
    80004476:	82bfe0ef          	jal	80002ca0 <iunlockput>
  iput(ip);
    8000447a:	8526                	mv	a0,s1
    8000447c:	f9cfe0ef          	jal	80002c18 <iput>
  end_op();
    80004480:	f17fe0ef          	jal	80003396 <end_op>
  return 0;
    80004484:	4781                	li	a5,0
    80004486:	64f2                	ld	s1,280(sp)
    80004488:	6952                	ld	s2,272(sp)
    8000448a:	a0a1                	j	800044d2 <sys_link+0xf4>
    end_op();
    8000448c:	f0bfe0ef          	jal	80003396 <end_op>
    return -1;
    80004490:	57fd                	li	a5,-1
    80004492:	64f2                	ld	s1,280(sp)
    80004494:	a83d                	j	800044d2 <sys_link+0xf4>
    iunlockput(ip);
    80004496:	8526                	mv	a0,s1
    80004498:	809fe0ef          	jal	80002ca0 <iunlockput>
    end_op();
    8000449c:	efbfe0ef          	jal	80003396 <end_op>
    return -1;
    800044a0:	57fd                	li	a5,-1
    800044a2:	64f2                	ld	s1,280(sp)
    800044a4:	a03d                	j	800044d2 <sys_link+0xf4>
    iunlockput(dp);
    800044a6:	854a                	mv	a0,s2
    800044a8:	ff8fe0ef          	jal	80002ca0 <iunlockput>
  ilock(ip);
    800044ac:	8526                	mv	a0,s1
    800044ae:	de8fe0ef          	jal	80002a96 <ilock>
  ip->nlink--;
    800044b2:	04a4d783          	lhu	a5,74(s1)
    800044b6:	37fd                	addiw	a5,a5,-1
    800044b8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800044bc:	8526                	mv	a0,s1
    800044be:	d24fe0ef          	jal	800029e2 <iupdate>
  iunlockput(ip);
    800044c2:	8526                	mv	a0,s1
    800044c4:	fdcfe0ef          	jal	80002ca0 <iunlockput>
  end_op();
    800044c8:	ecffe0ef          	jal	80003396 <end_op>
  return -1;
    800044cc:	57fd                	li	a5,-1
    800044ce:	64f2                	ld	s1,280(sp)
    800044d0:	6952                	ld	s2,272(sp)
}
    800044d2:	853e                	mv	a0,a5
    800044d4:	70b2                	ld	ra,296(sp)
    800044d6:	7412                	ld	s0,288(sp)
    800044d8:	6155                	addi	sp,sp,304
    800044da:	8082                	ret

00000000800044dc <sys_unlink>:
{
    800044dc:	7151                	addi	sp,sp,-240
    800044de:	f586                	sd	ra,232(sp)
    800044e0:	f1a2                	sd	s0,224(sp)
    800044e2:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800044e4:	08000613          	li	a2,128
    800044e8:	f3040593          	addi	a1,s0,-208
    800044ec:	4501                	li	a0,0
    800044ee:	f60fd0ef          	jal	80001c4e <argstr>
    800044f2:	16054063          	bltz	a0,80004652 <sys_unlink+0x176>
    800044f6:	eda6                	sd	s1,216(sp)
  begin_op();
    800044f8:	e35fe0ef          	jal	8000332c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800044fc:	fb040593          	addi	a1,s0,-80
    80004500:	f3040513          	addi	a0,s0,-208
    80004504:	c87fe0ef          	jal	8000318a <nameiparent>
    80004508:	84aa                	mv	s1,a0
    8000450a:	c945                	beqz	a0,800045ba <sys_unlink+0xde>
  ilock(dp);
    8000450c:	d8afe0ef          	jal	80002a96 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004510:	00003597          	auipc	a1,0x3
    80004514:	22058593          	addi	a1,a1,544 # 80007730 <etext+0x730>
    80004518:	fb040513          	addi	a0,s0,-80
    8000451c:	9d9fe0ef          	jal	80002ef4 <namecmp>
    80004520:	10050e63          	beqz	a0,8000463c <sys_unlink+0x160>
    80004524:	00003597          	auipc	a1,0x3
    80004528:	21458593          	addi	a1,a1,532 # 80007738 <etext+0x738>
    8000452c:	fb040513          	addi	a0,s0,-80
    80004530:	9c5fe0ef          	jal	80002ef4 <namecmp>
    80004534:	10050463          	beqz	a0,8000463c <sys_unlink+0x160>
    80004538:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000453a:	f2c40613          	addi	a2,s0,-212
    8000453e:	fb040593          	addi	a1,s0,-80
    80004542:	8526                	mv	a0,s1
    80004544:	9c7fe0ef          	jal	80002f0a <dirlookup>
    80004548:	892a                	mv	s2,a0
    8000454a:	0e050863          	beqz	a0,8000463a <sys_unlink+0x15e>
  ilock(ip);
    8000454e:	d48fe0ef          	jal	80002a96 <ilock>
  if(ip->nlink < 1)
    80004552:	04a91783          	lh	a5,74(s2)
    80004556:	06f05763          	blez	a5,800045c4 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000455a:	04491703          	lh	a4,68(s2)
    8000455e:	4785                	li	a5,1
    80004560:	06f70963          	beq	a4,a5,800045d2 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004564:	4641                	li	a2,16
    80004566:	4581                	li	a1,0
    80004568:	fc040513          	addi	a0,s0,-64
    8000456c:	bc9fb0ef          	jal	80000134 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004570:	4741                	li	a4,16
    80004572:	f2c42683          	lw	a3,-212(s0)
    80004576:	fc040613          	addi	a2,s0,-64
    8000457a:	4581                	li	a1,0
    8000457c:	8526                	mv	a0,s1
    8000457e:	869fe0ef          	jal	80002de6 <writei>
    80004582:	47c1                	li	a5,16
    80004584:	08f51b63          	bne	a0,a5,8000461a <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004588:	04491703          	lh	a4,68(s2)
    8000458c:	4785                	li	a5,1
    8000458e:	08f70d63          	beq	a4,a5,80004628 <sys_unlink+0x14c>
  iunlockput(dp);
    80004592:	8526                	mv	a0,s1
    80004594:	f0cfe0ef          	jal	80002ca0 <iunlockput>
  ip->nlink--;
    80004598:	04a95783          	lhu	a5,74(s2)
    8000459c:	37fd                	addiw	a5,a5,-1
    8000459e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800045a2:	854a                	mv	a0,s2
    800045a4:	c3efe0ef          	jal	800029e2 <iupdate>
  iunlockput(ip);
    800045a8:	854a                	mv	a0,s2
    800045aa:	ef6fe0ef          	jal	80002ca0 <iunlockput>
  end_op();
    800045ae:	de9fe0ef          	jal	80003396 <end_op>
  return 0;
    800045b2:	4501                	li	a0,0
    800045b4:	64ee                	ld	s1,216(sp)
    800045b6:	694e                	ld	s2,208(sp)
    800045b8:	a849                	j	8000464a <sys_unlink+0x16e>
    end_op();
    800045ba:	dddfe0ef          	jal	80003396 <end_op>
    return -1;
    800045be:	557d                	li	a0,-1
    800045c0:	64ee                	ld	s1,216(sp)
    800045c2:	a061                	j	8000464a <sys_unlink+0x16e>
    800045c4:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    800045c6:	00003517          	auipc	a0,0x3
    800045ca:	17a50513          	addi	a0,a0,378 # 80007740 <etext+0x740>
    800045ce:	274010ef          	jal	80005842 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800045d2:	04c92703          	lw	a4,76(s2)
    800045d6:	02000793          	li	a5,32
    800045da:	f8e7f5e3          	bgeu	a5,a4,80004564 <sys_unlink+0x88>
    800045de:	e5ce                	sd	s3,200(sp)
    800045e0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800045e4:	4741                	li	a4,16
    800045e6:	86ce                	mv	a3,s3
    800045e8:	f1840613          	addi	a2,s0,-232
    800045ec:	4581                	li	a1,0
    800045ee:	854a                	mv	a0,s2
    800045f0:	efafe0ef          	jal	80002cea <readi>
    800045f4:	47c1                	li	a5,16
    800045f6:	00f51c63          	bne	a0,a5,8000460e <sys_unlink+0x132>
    if(de.inum != 0)
    800045fa:	f1845783          	lhu	a5,-232(s0)
    800045fe:	efa1                	bnez	a5,80004656 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004600:	29c1                	addiw	s3,s3,16
    80004602:	04c92783          	lw	a5,76(s2)
    80004606:	fcf9efe3          	bltu	s3,a5,800045e4 <sys_unlink+0x108>
    8000460a:	69ae                	ld	s3,200(sp)
    8000460c:	bfa1                	j	80004564 <sys_unlink+0x88>
      panic("isdirempty: readi");
    8000460e:	00003517          	auipc	a0,0x3
    80004612:	14a50513          	addi	a0,a0,330 # 80007758 <etext+0x758>
    80004616:	22c010ef          	jal	80005842 <panic>
    8000461a:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    8000461c:	00003517          	auipc	a0,0x3
    80004620:	15450513          	addi	a0,a0,340 # 80007770 <etext+0x770>
    80004624:	21e010ef          	jal	80005842 <panic>
    dp->nlink--;
    80004628:	04a4d783          	lhu	a5,74(s1)
    8000462c:	37fd                	addiw	a5,a5,-1
    8000462e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004632:	8526                	mv	a0,s1
    80004634:	baefe0ef          	jal	800029e2 <iupdate>
    80004638:	bfa9                	j	80004592 <sys_unlink+0xb6>
    8000463a:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    8000463c:	8526                	mv	a0,s1
    8000463e:	e62fe0ef          	jal	80002ca0 <iunlockput>
  end_op();
    80004642:	d55fe0ef          	jal	80003396 <end_op>
  return -1;
    80004646:	557d                	li	a0,-1
    80004648:	64ee                	ld	s1,216(sp)
}
    8000464a:	70ae                	ld	ra,232(sp)
    8000464c:	740e                	ld	s0,224(sp)
    8000464e:	616d                	addi	sp,sp,240
    80004650:	8082                	ret
    return -1;
    80004652:	557d                	li	a0,-1
    80004654:	bfdd                	j	8000464a <sys_unlink+0x16e>
    iunlockput(ip);
    80004656:	854a                	mv	a0,s2
    80004658:	e48fe0ef          	jal	80002ca0 <iunlockput>
    goto bad;
    8000465c:	694e                	ld	s2,208(sp)
    8000465e:	69ae                	ld	s3,200(sp)
    80004660:	bff1                	j	8000463c <sys_unlink+0x160>

0000000080004662 <sys_open>:

uint64
sys_open(void)
{
    80004662:	7131                	addi	sp,sp,-192
    80004664:	fd06                	sd	ra,184(sp)
    80004666:	f922                	sd	s0,176(sp)
    80004668:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000466a:	f4c40593          	addi	a1,s0,-180
    8000466e:	4505                	li	a0,1
    80004670:	da6fd0ef          	jal	80001c16 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004674:	08000613          	li	a2,128
    80004678:	f5040593          	addi	a1,s0,-176
    8000467c:	4501                	li	a0,0
    8000467e:	dd0fd0ef          	jal	80001c4e <argstr>
    80004682:	87aa                	mv	a5,a0
    return -1;
    80004684:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004686:	0a07c263          	bltz	a5,8000472a <sys_open+0xc8>
    8000468a:	f526                	sd	s1,168(sp)

  begin_op();
    8000468c:	ca1fe0ef          	jal	8000332c <begin_op>

  if(omode & O_CREATE){
    80004690:	f4c42783          	lw	a5,-180(s0)
    80004694:	2007f793          	andi	a5,a5,512
    80004698:	c3d5                	beqz	a5,8000473c <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    8000469a:	4681                	li	a3,0
    8000469c:	4601                	li	a2,0
    8000469e:	4589                	li	a1,2
    800046a0:	f5040513          	addi	a0,s0,-176
    800046a4:	aa9ff0ef          	jal	8000414c <create>
    800046a8:	84aa                	mv	s1,a0
    if(ip == 0){
    800046aa:	c541                	beqz	a0,80004732 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800046ac:	04449703          	lh	a4,68(s1)
    800046b0:	478d                	li	a5,3
    800046b2:	00f71763          	bne	a4,a5,800046c0 <sys_open+0x5e>
    800046b6:	0464d703          	lhu	a4,70(s1)
    800046ba:	47a5                	li	a5,9
    800046bc:	0ae7ed63          	bltu	a5,a4,80004776 <sys_open+0x114>
    800046c0:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800046c2:	fe1fe0ef          	jal	800036a2 <filealloc>
    800046c6:	892a                	mv	s2,a0
    800046c8:	c179                	beqz	a0,8000478e <sys_open+0x12c>
    800046ca:	ed4e                	sd	s3,152(sp)
    800046cc:	a43ff0ef          	jal	8000410e <fdalloc>
    800046d0:	89aa                	mv	s3,a0
    800046d2:	0a054a63          	bltz	a0,80004786 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800046d6:	04449703          	lh	a4,68(s1)
    800046da:	478d                	li	a5,3
    800046dc:	0cf70263          	beq	a4,a5,800047a0 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800046e0:	4789                	li	a5,2
    800046e2:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800046e6:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800046ea:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800046ee:	f4c42783          	lw	a5,-180(s0)
    800046f2:	0017c713          	xori	a4,a5,1
    800046f6:	8b05                	andi	a4,a4,1
    800046f8:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800046fc:	0037f713          	andi	a4,a5,3
    80004700:	00e03733          	snez	a4,a4
    80004704:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004708:	4007f793          	andi	a5,a5,1024
    8000470c:	c791                	beqz	a5,80004718 <sys_open+0xb6>
    8000470e:	04449703          	lh	a4,68(s1)
    80004712:	4789                	li	a5,2
    80004714:	08f70d63          	beq	a4,a5,800047ae <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004718:	8526                	mv	a0,s1
    8000471a:	c2afe0ef          	jal	80002b44 <iunlock>
  end_op();
    8000471e:	c79fe0ef          	jal	80003396 <end_op>

  return fd;
    80004722:	854e                	mv	a0,s3
    80004724:	74aa                	ld	s1,168(sp)
    80004726:	790a                	ld	s2,160(sp)
    80004728:	69ea                	ld	s3,152(sp)
}
    8000472a:	70ea                	ld	ra,184(sp)
    8000472c:	744a                	ld	s0,176(sp)
    8000472e:	6129                	addi	sp,sp,192
    80004730:	8082                	ret
      end_op();
    80004732:	c65fe0ef          	jal	80003396 <end_op>
      return -1;
    80004736:	557d                	li	a0,-1
    80004738:	74aa                	ld	s1,168(sp)
    8000473a:	bfc5                	j	8000472a <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    8000473c:	f5040513          	addi	a0,s0,-176
    80004740:	a31fe0ef          	jal	80003170 <namei>
    80004744:	84aa                	mv	s1,a0
    80004746:	c11d                	beqz	a0,8000476c <sys_open+0x10a>
    ilock(ip);
    80004748:	b4efe0ef          	jal	80002a96 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000474c:	04449703          	lh	a4,68(s1)
    80004750:	4785                	li	a5,1
    80004752:	f4f71de3          	bne	a4,a5,800046ac <sys_open+0x4a>
    80004756:	f4c42783          	lw	a5,-180(s0)
    8000475a:	d3bd                	beqz	a5,800046c0 <sys_open+0x5e>
      iunlockput(ip);
    8000475c:	8526                	mv	a0,s1
    8000475e:	d42fe0ef          	jal	80002ca0 <iunlockput>
      end_op();
    80004762:	c35fe0ef          	jal	80003396 <end_op>
      return -1;
    80004766:	557d                	li	a0,-1
    80004768:	74aa                	ld	s1,168(sp)
    8000476a:	b7c1                	j	8000472a <sys_open+0xc8>
      end_op();
    8000476c:	c2bfe0ef          	jal	80003396 <end_op>
      return -1;
    80004770:	557d                	li	a0,-1
    80004772:	74aa                	ld	s1,168(sp)
    80004774:	bf5d                	j	8000472a <sys_open+0xc8>
    iunlockput(ip);
    80004776:	8526                	mv	a0,s1
    80004778:	d28fe0ef          	jal	80002ca0 <iunlockput>
    end_op();
    8000477c:	c1bfe0ef          	jal	80003396 <end_op>
    return -1;
    80004780:	557d                	li	a0,-1
    80004782:	74aa                	ld	s1,168(sp)
    80004784:	b75d                	j	8000472a <sys_open+0xc8>
      fileclose(f);
    80004786:	854a                	mv	a0,s2
    80004788:	fbffe0ef          	jal	80003746 <fileclose>
    8000478c:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000478e:	8526                	mv	a0,s1
    80004790:	d10fe0ef          	jal	80002ca0 <iunlockput>
    end_op();
    80004794:	c03fe0ef          	jal	80003396 <end_op>
    return -1;
    80004798:	557d                	li	a0,-1
    8000479a:	74aa                	ld	s1,168(sp)
    8000479c:	790a                	ld	s2,160(sp)
    8000479e:	b771                	j	8000472a <sys_open+0xc8>
    f->type = FD_DEVICE;
    800047a0:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800047a4:	04649783          	lh	a5,70(s1)
    800047a8:	02f91223          	sh	a5,36(s2)
    800047ac:	bf3d                	j	800046ea <sys_open+0x88>
    itrunc(ip);
    800047ae:	8526                	mv	a0,s1
    800047b0:	bd4fe0ef          	jal	80002b84 <itrunc>
    800047b4:	b795                	j	80004718 <sys_open+0xb6>

00000000800047b6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800047b6:	7175                	addi	sp,sp,-144
    800047b8:	e506                	sd	ra,136(sp)
    800047ba:	e122                	sd	s0,128(sp)
    800047bc:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800047be:	b6ffe0ef          	jal	8000332c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800047c2:	08000613          	li	a2,128
    800047c6:	f7040593          	addi	a1,s0,-144
    800047ca:	4501                	li	a0,0
    800047cc:	c82fd0ef          	jal	80001c4e <argstr>
    800047d0:	02054363          	bltz	a0,800047f6 <sys_mkdir+0x40>
    800047d4:	4681                	li	a3,0
    800047d6:	4601                	li	a2,0
    800047d8:	4585                	li	a1,1
    800047da:	f7040513          	addi	a0,s0,-144
    800047de:	96fff0ef          	jal	8000414c <create>
    800047e2:	c911                	beqz	a0,800047f6 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800047e4:	cbcfe0ef          	jal	80002ca0 <iunlockput>
  end_op();
    800047e8:	baffe0ef          	jal	80003396 <end_op>
  return 0;
    800047ec:	4501                	li	a0,0
}
    800047ee:	60aa                	ld	ra,136(sp)
    800047f0:	640a                	ld	s0,128(sp)
    800047f2:	6149                	addi	sp,sp,144
    800047f4:	8082                	ret
    end_op();
    800047f6:	ba1fe0ef          	jal	80003396 <end_op>
    return -1;
    800047fa:	557d                	li	a0,-1
    800047fc:	bfcd                	j	800047ee <sys_mkdir+0x38>

00000000800047fe <sys_mknod>:

uint64
sys_mknod(void)
{
    800047fe:	7135                	addi	sp,sp,-160
    80004800:	ed06                	sd	ra,152(sp)
    80004802:	e922                	sd	s0,144(sp)
    80004804:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004806:	b27fe0ef          	jal	8000332c <begin_op>
  argint(1, &major);
    8000480a:	f6c40593          	addi	a1,s0,-148
    8000480e:	4505                	li	a0,1
    80004810:	c06fd0ef          	jal	80001c16 <argint>
  argint(2, &minor);
    80004814:	f6840593          	addi	a1,s0,-152
    80004818:	4509                	li	a0,2
    8000481a:	bfcfd0ef          	jal	80001c16 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000481e:	08000613          	li	a2,128
    80004822:	f7040593          	addi	a1,s0,-144
    80004826:	4501                	li	a0,0
    80004828:	c26fd0ef          	jal	80001c4e <argstr>
    8000482c:	02054563          	bltz	a0,80004856 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004830:	f6841683          	lh	a3,-152(s0)
    80004834:	f6c41603          	lh	a2,-148(s0)
    80004838:	458d                	li	a1,3
    8000483a:	f7040513          	addi	a0,s0,-144
    8000483e:	90fff0ef          	jal	8000414c <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004842:	c911                	beqz	a0,80004856 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004844:	c5cfe0ef          	jal	80002ca0 <iunlockput>
  end_op();
    80004848:	b4ffe0ef          	jal	80003396 <end_op>
  return 0;
    8000484c:	4501                	li	a0,0
}
    8000484e:	60ea                	ld	ra,152(sp)
    80004850:	644a                	ld	s0,144(sp)
    80004852:	610d                	addi	sp,sp,160
    80004854:	8082                	ret
    end_op();
    80004856:	b41fe0ef          	jal	80003396 <end_op>
    return -1;
    8000485a:	557d                	li	a0,-1
    8000485c:	bfcd                	j	8000484e <sys_mknod+0x50>

000000008000485e <sys_chdir>:

uint64
sys_chdir(void)
{
    8000485e:	7135                	addi	sp,sp,-160
    80004860:	ed06                	sd	ra,152(sp)
    80004862:	e922                	sd	s0,144(sp)
    80004864:	e14a                	sd	s2,128(sp)
    80004866:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004868:	ceefc0ef          	jal	80000d56 <myproc>
    8000486c:	892a                	mv	s2,a0
  
  begin_op();
    8000486e:	abffe0ef          	jal	8000332c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004872:	08000613          	li	a2,128
    80004876:	f6040593          	addi	a1,s0,-160
    8000487a:	4501                	li	a0,0
    8000487c:	bd2fd0ef          	jal	80001c4e <argstr>
    80004880:	04054363          	bltz	a0,800048c6 <sys_chdir+0x68>
    80004884:	e526                	sd	s1,136(sp)
    80004886:	f6040513          	addi	a0,s0,-160
    8000488a:	8e7fe0ef          	jal	80003170 <namei>
    8000488e:	84aa                	mv	s1,a0
    80004890:	c915                	beqz	a0,800048c4 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004892:	a04fe0ef          	jal	80002a96 <ilock>
  if(ip->type != T_DIR){
    80004896:	04449703          	lh	a4,68(s1)
    8000489a:	4785                	li	a5,1
    8000489c:	02f71963          	bne	a4,a5,800048ce <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800048a0:	8526                	mv	a0,s1
    800048a2:	aa2fe0ef          	jal	80002b44 <iunlock>
  iput(p->cwd);
    800048a6:	15093503          	ld	a0,336(s2)
    800048aa:	b6efe0ef          	jal	80002c18 <iput>
  end_op();
    800048ae:	ae9fe0ef          	jal	80003396 <end_op>
  p->cwd = ip;
    800048b2:	14993823          	sd	s1,336(s2)
  return 0;
    800048b6:	4501                	li	a0,0
    800048b8:	64aa                	ld	s1,136(sp)
}
    800048ba:	60ea                	ld	ra,152(sp)
    800048bc:	644a                	ld	s0,144(sp)
    800048be:	690a                	ld	s2,128(sp)
    800048c0:	610d                	addi	sp,sp,160
    800048c2:	8082                	ret
    800048c4:	64aa                	ld	s1,136(sp)
    end_op();
    800048c6:	ad1fe0ef          	jal	80003396 <end_op>
    return -1;
    800048ca:	557d                	li	a0,-1
    800048cc:	b7fd                	j	800048ba <sys_chdir+0x5c>
    iunlockput(ip);
    800048ce:	8526                	mv	a0,s1
    800048d0:	bd0fe0ef          	jal	80002ca0 <iunlockput>
    end_op();
    800048d4:	ac3fe0ef          	jal	80003396 <end_op>
    return -1;
    800048d8:	557d                	li	a0,-1
    800048da:	64aa                	ld	s1,136(sp)
    800048dc:	bff9                	j	800048ba <sys_chdir+0x5c>

00000000800048de <sys_exec>:

uint64
sys_exec(void)
{
    800048de:	7121                	addi	sp,sp,-448
    800048e0:	ff06                	sd	ra,440(sp)
    800048e2:	fb22                	sd	s0,432(sp)
    800048e4:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800048e6:	e4840593          	addi	a1,s0,-440
    800048ea:	4505                	li	a0,1
    800048ec:	b46fd0ef          	jal	80001c32 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800048f0:	08000613          	li	a2,128
    800048f4:	f5040593          	addi	a1,s0,-176
    800048f8:	4501                	li	a0,0
    800048fa:	b54fd0ef          	jal	80001c4e <argstr>
    800048fe:	87aa                	mv	a5,a0
    return -1;
    80004900:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004902:	0c07c463          	bltz	a5,800049ca <sys_exec+0xec>
    80004906:	f726                	sd	s1,424(sp)
    80004908:	f34a                	sd	s2,416(sp)
    8000490a:	ef4e                	sd	s3,408(sp)
    8000490c:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000490e:	10000613          	li	a2,256
    80004912:	4581                	li	a1,0
    80004914:	e5040513          	addi	a0,s0,-432
    80004918:	81dfb0ef          	jal	80000134 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000491c:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004920:	89a6                	mv	s3,s1
    80004922:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004924:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004928:	00391513          	slli	a0,s2,0x3
    8000492c:	e4040593          	addi	a1,s0,-448
    80004930:	e4843783          	ld	a5,-440(s0)
    80004934:	953e                	add	a0,a0,a5
    80004936:	a56fd0ef          	jal	80001b8c <fetchaddr>
    8000493a:	02054663          	bltz	a0,80004966 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    8000493e:	e4043783          	ld	a5,-448(s0)
    80004942:	c3a9                	beqz	a5,80004984 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004944:	fb2fb0ef          	jal	800000f6 <kalloc>
    80004948:	85aa                	mv	a1,a0
    8000494a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000494e:	cd01                	beqz	a0,80004966 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004950:	6605                	lui	a2,0x1
    80004952:	e4043503          	ld	a0,-448(s0)
    80004956:	a80fd0ef          	jal	80001bd6 <fetchstr>
    8000495a:	00054663          	bltz	a0,80004966 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    8000495e:	0905                	addi	s2,s2,1
    80004960:	09a1                	addi	s3,s3,8
    80004962:	fd4913e3          	bne	s2,s4,80004928 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004966:	f5040913          	addi	s2,s0,-176
    8000496a:	6088                	ld	a0,0(s1)
    8000496c:	c931                	beqz	a0,800049c0 <sys_exec+0xe2>
    kfree(argv[i]);
    8000496e:	eaefb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004972:	04a1                	addi	s1,s1,8
    80004974:	ff249be3          	bne	s1,s2,8000496a <sys_exec+0x8c>
  return -1;
    80004978:	557d                	li	a0,-1
    8000497a:	74ba                	ld	s1,424(sp)
    8000497c:	791a                	ld	s2,416(sp)
    8000497e:	69fa                	ld	s3,408(sp)
    80004980:	6a5a                	ld	s4,400(sp)
    80004982:	a0a1                	j	800049ca <sys_exec+0xec>
      argv[i] = 0;
    80004984:	0009079b          	sext.w	a5,s2
    80004988:	078e                	slli	a5,a5,0x3
    8000498a:	fd078793          	addi	a5,a5,-48
    8000498e:	97a2                	add	a5,a5,s0
    80004990:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004994:	e5040593          	addi	a1,s0,-432
    80004998:	f5040513          	addi	a0,s0,-176
    8000499c:	ba8ff0ef          	jal	80003d44 <exec>
    800049a0:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800049a2:	f5040993          	addi	s3,s0,-176
    800049a6:	6088                	ld	a0,0(s1)
    800049a8:	c511                	beqz	a0,800049b4 <sys_exec+0xd6>
    kfree(argv[i]);
    800049aa:	e72fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800049ae:	04a1                	addi	s1,s1,8
    800049b0:	ff349be3          	bne	s1,s3,800049a6 <sys_exec+0xc8>
  return ret;
    800049b4:	854a                	mv	a0,s2
    800049b6:	74ba                	ld	s1,424(sp)
    800049b8:	791a                	ld	s2,416(sp)
    800049ba:	69fa                	ld	s3,408(sp)
    800049bc:	6a5a                	ld	s4,400(sp)
    800049be:	a031                	j	800049ca <sys_exec+0xec>
  return -1;
    800049c0:	557d                	li	a0,-1
    800049c2:	74ba                	ld	s1,424(sp)
    800049c4:	791a                	ld	s2,416(sp)
    800049c6:	69fa                	ld	s3,408(sp)
    800049c8:	6a5a                	ld	s4,400(sp)
}
    800049ca:	70fa                	ld	ra,440(sp)
    800049cc:	745a                	ld	s0,432(sp)
    800049ce:	6139                	addi	sp,sp,448
    800049d0:	8082                	ret

00000000800049d2 <sys_pipe>:

uint64
sys_pipe(void)
{
    800049d2:	7139                	addi	sp,sp,-64
    800049d4:	fc06                	sd	ra,56(sp)
    800049d6:	f822                	sd	s0,48(sp)
    800049d8:	f426                	sd	s1,40(sp)
    800049da:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800049dc:	b7afc0ef          	jal	80000d56 <myproc>
    800049e0:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800049e2:	fd840593          	addi	a1,s0,-40
    800049e6:	4501                	li	a0,0
    800049e8:	a4afd0ef          	jal	80001c32 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800049ec:	fc840593          	addi	a1,s0,-56
    800049f0:	fd040513          	addi	a0,s0,-48
    800049f4:	85cff0ef          	jal	80003a50 <pipealloc>
    return -1;
    800049f8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800049fa:	0a054463          	bltz	a0,80004aa2 <sys_pipe+0xd0>
  fd0 = -1;
    800049fe:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004a02:	fd043503          	ld	a0,-48(s0)
    80004a06:	f08ff0ef          	jal	8000410e <fdalloc>
    80004a0a:	fca42223          	sw	a0,-60(s0)
    80004a0e:	08054163          	bltz	a0,80004a90 <sys_pipe+0xbe>
    80004a12:	fc843503          	ld	a0,-56(s0)
    80004a16:	ef8ff0ef          	jal	8000410e <fdalloc>
    80004a1a:	fca42023          	sw	a0,-64(s0)
    80004a1e:	06054063          	bltz	a0,80004a7e <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004a22:	4691                	li	a3,4
    80004a24:	fc440613          	addi	a2,s0,-60
    80004a28:	fd843583          	ld	a1,-40(s0)
    80004a2c:	68a8                	ld	a0,80(s1)
    80004a2e:	f99fb0ef          	jal	800009c6 <copyout>
    80004a32:	00054e63          	bltz	a0,80004a4e <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004a36:	4691                	li	a3,4
    80004a38:	fc040613          	addi	a2,s0,-64
    80004a3c:	fd843583          	ld	a1,-40(s0)
    80004a40:	0591                	addi	a1,a1,4
    80004a42:	68a8                	ld	a0,80(s1)
    80004a44:	f83fb0ef          	jal	800009c6 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004a48:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004a4a:	04055c63          	bgez	a0,80004aa2 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004a4e:	fc442783          	lw	a5,-60(s0)
    80004a52:	07e9                	addi	a5,a5,26
    80004a54:	078e                	slli	a5,a5,0x3
    80004a56:	97a6                	add	a5,a5,s1
    80004a58:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004a5c:	fc042783          	lw	a5,-64(s0)
    80004a60:	07e9                	addi	a5,a5,26
    80004a62:	078e                	slli	a5,a5,0x3
    80004a64:	94be                	add	s1,s1,a5
    80004a66:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004a6a:	fd043503          	ld	a0,-48(s0)
    80004a6e:	cd9fe0ef          	jal	80003746 <fileclose>
    fileclose(wf);
    80004a72:	fc843503          	ld	a0,-56(s0)
    80004a76:	cd1fe0ef          	jal	80003746 <fileclose>
    return -1;
    80004a7a:	57fd                	li	a5,-1
    80004a7c:	a01d                	j	80004aa2 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004a7e:	fc442783          	lw	a5,-60(s0)
    80004a82:	0007c763          	bltz	a5,80004a90 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004a86:	07e9                	addi	a5,a5,26
    80004a88:	078e                	slli	a5,a5,0x3
    80004a8a:	97a6                	add	a5,a5,s1
    80004a8c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004a90:	fd043503          	ld	a0,-48(s0)
    80004a94:	cb3fe0ef          	jal	80003746 <fileclose>
    fileclose(wf);
    80004a98:	fc843503          	ld	a0,-56(s0)
    80004a9c:	cabfe0ef          	jal	80003746 <fileclose>
    return -1;
    80004aa0:	57fd                	li	a5,-1
}
    80004aa2:	853e                	mv	a0,a5
    80004aa4:	70e2                	ld	ra,56(sp)
    80004aa6:	7442                	ld	s0,48(sp)
    80004aa8:	74a2                	ld	s1,40(sp)
    80004aaa:	6121                	addi	sp,sp,64
    80004aac:	8082                	ret
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
    80004bb4:	f9078793          	addi	a5,a5,-112 # 8001bb40 <disk>
    80004bb8:	97aa                	add	a5,a5,a0
    80004bba:	0187c783          	lbu	a5,24(a5)
    80004bbe:	e7b9                	bnez	a5,80004c0c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004bc0:	00451693          	slli	a3,a0,0x4
    80004bc4:	00017797          	auipc	a5,0x17
    80004bc8:	f7c78793          	addi	a5,a5,-132 # 8001bb40 <disk>
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
    80004bf0:	f6c50513          	addi	a0,a0,-148 # 8001bb58 <disk+0x18>
    80004bf4:	f88fc0ef          	jal	8000137c <wakeup>
}
    80004bf8:	60a2                	ld	ra,8(sp)
    80004bfa:	6402                	ld	s0,0(sp)
    80004bfc:	0141                	addi	sp,sp,16
    80004bfe:	8082                	ret
    panic("free_desc 1");
    80004c00:	00003517          	auipc	a0,0x3
    80004c04:	b8050513          	addi	a0,a0,-1152 # 80007780 <etext+0x780>
    80004c08:	43b000ef          	jal	80005842 <panic>
    panic("free_desc 2");
    80004c0c:	00003517          	auipc	a0,0x3
    80004c10:	b8450513          	addi	a0,a0,-1148 # 80007790 <etext+0x790>
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
    80004c28:	b7c58593          	addi	a1,a1,-1156 # 800077a0 <etext+0x7a0>
    80004c2c:	00017517          	auipc	a0,0x17
    80004c30:	03c50513          	addi	a0,a0,60 # 8001bc68 <disk+0x128>
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
    80004c98:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fda9df>
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
    80004cee:	e5648493          	addi	s1,s1,-426 # 8001bb40 <disk>
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
    80004d0c:	e4073703          	ld	a4,-448(a4) # 8001bb48 <disk+0x8>
    80004d10:	0e070a63          	beqz	a4,80004e04 <virtio_disk_init+0x1ec>
    80004d14:	0e078863          	beqz	a5,80004e04 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004d18:	6605                	lui	a2,0x1
    80004d1a:	4581                	li	a1,0
    80004d1c:	c18fb0ef          	jal	80000134 <memset>
  memset(disk.avail, 0, PGSIZE);
    80004d20:	00017497          	auipc	s1,0x17
    80004d24:	e2048493          	addi	s1,s1,-480 # 8001bb40 <disk>
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
    80004dcc:	9e850513          	addi	a0,a0,-1560 # 800077b0 <etext+0x7b0>
    80004dd0:	273000ef          	jal	80005842 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004dd4:	00003517          	auipc	a0,0x3
    80004dd8:	9fc50513          	addi	a0,a0,-1540 # 800077d0 <etext+0x7d0>
    80004ddc:	267000ef          	jal	80005842 <panic>
    panic("virtio disk should not be ready");
    80004de0:	00003517          	auipc	a0,0x3
    80004de4:	a1050513          	addi	a0,a0,-1520 # 800077f0 <etext+0x7f0>
    80004de8:	25b000ef          	jal	80005842 <panic>
    panic("virtio disk has no queue 0");
    80004dec:	00003517          	auipc	a0,0x3
    80004df0:	a2450513          	addi	a0,a0,-1500 # 80007810 <etext+0x810>
    80004df4:	24f000ef          	jal	80005842 <panic>
    panic("virtio disk max queue too short");
    80004df8:	00003517          	auipc	a0,0x3
    80004dfc:	a3850513          	addi	a0,a0,-1480 # 80007830 <etext+0x830>
    80004e00:	243000ef          	jal	80005842 <panic>
    panic("virtio disk kalloc");
    80004e04:	00003517          	auipc	a0,0x3
    80004e08:	a4c50513          	addi	a0,a0,-1460 # 80007850 <etext+0x850>
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
    80004e40:	e2c50513          	addi	a0,a0,-468 # 8001bc68 <disk+0x128>
    80004e44:	52d000ef          	jal	80005b70 <acquire>
  for(int i = 0; i < 3; i++){
    80004e48:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004e4a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004e4c:	00017b17          	auipc	s6,0x17
    80004e50:	cf4b0b13          	addi	s6,s6,-780 # 8001bb40 <disk>
  for(int i = 0; i < 3; i++){
    80004e54:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004e56:	00017c17          	auipc	s8,0x17
    80004e5a:	e12c0c13          	addi	s8,s8,-494 # 8001bc68 <disk+0x128>
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
    80004e7c:	cc870713          	addi	a4,a4,-824 # 8001bb40 <disk>
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
    80004eb4:	ca850513          	addi	a0,a0,-856 # 8001bb58 <disk+0x18>
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
    80004ed0:	c7478793          	addi	a5,a5,-908 # 8001bb40 <disk>
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
    80004fa6:	cc690913          	addi	s2,s2,-826 # 8001bc68 <disk+0x128>
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
    80004fce:	b7678793          	addi	a5,a5,-1162 # 8001bb40 <disk>
    80004fd2:	97ba                	add	a5,a5,a4
    80004fd4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004fd8:	00017997          	auipc	s3,0x17
    80004fdc:	b6898993          	addi	s3,s3,-1176 # 8001bb40 <disk>
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
    80005000:	c6c50513          	addi	a0,a0,-916 # 8001bc68 <disk+0x128>
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
    80005030:	b1448493          	addi	s1,s1,-1260 # 8001bb40 <disk>
    80005034:	00017517          	auipc	a0,0x17
    80005038:	c3450513          	addi	a0,a0,-972 # 8001bc68 <disk+0x128>
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
    800050ac:	bc050513          	addi	a0,a0,-1088 # 8001bc68 <disk+0x128>
    800050b0:	359000ef          	jal	80005c08 <release>
}
    800050b4:	60e2                	ld	ra,24(sp)
    800050b6:	6442                	ld	s0,16(sp)
    800050b8:	64a2                	ld	s1,8(sp)
    800050ba:	6105                	addi	sp,sp,32
    800050bc:	8082                	ret
      panic("virtio_disk_intr status");
    800050be:	00002517          	auipc	a0,0x2
    800050c2:	7aa50513          	addi	a0,a0,1962 # 80007868 <etext+0x868>
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
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    800050d0:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    800050d4:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    800050d8:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    800050dc:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    800050e0:	577d                	li	a4,-1
    800050e2:	177e                	slli	a4,a4,0x3f
    800050e4:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    800050e6:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    800050ea:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    800050ee:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    800050f2:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
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
    8000511c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdaa7f>
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
}

static inline void 
w_tp(uint64 x)
{
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
    80005206:	a7e50513          	addi	a0,a0,-1410 # 80023c80 <cons>
    8000520a:	167000ef          	jal	80005b70 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000520e:	0001f497          	auipc	s1,0x1f
    80005212:	a7248493          	addi	s1,s1,-1422 # 80023c80 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005216:	0001f917          	auipc	s2,0x1f
    8000521a:	b0290913          	addi	s2,s2,-1278 # 80023d18 <cons+0x98>
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
    80005252:	a3270713          	addi	a4,a4,-1486 # 80023c80 <cons>
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
    8000529c:	9e850513          	addi	a0,a0,-1560 # 80023c80 <cons>
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
    800052c6:	a4f72b23          	sw	a5,-1450(a4) # 80023d18 <cons+0x98>
    800052ca:	6be2                	ld	s7,24(sp)
    800052cc:	a031                	j	800052d8 <consoleread+0xf4>
    800052ce:	ec5e                	sd	s7,24(sp)
    800052d0:	bfbd                	j	8000524e <consoleread+0x6a>
    800052d2:	6be2                	ld	s7,24(sp)
    800052d4:	a011                	j	800052d8 <consoleread+0xf4>
    800052d6:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    800052d8:	0001f517          	auipc	a0,0x1f
    800052dc:	9a850513          	addi	a0,a0,-1624 # 80023c80 <cons>
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
    80005330:	95450513          	addi	a0,a0,-1708 # 80023c80 <cons>
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
    80005352:	0001f517          	auipc	a0,0x1f
    80005356:	92e50513          	addi	a0,a0,-1746 # 80023c80 <cons>
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
    80005370:	0001f717          	auipc	a4,0x1f
    80005374:	91070713          	addi	a4,a4,-1776 # 80023c80 <cons>
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
    80005396:	0001f797          	auipc	a5,0x1f
    8000539a:	8ea78793          	addi	a5,a5,-1814 # 80023c80 <cons>
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
    800053c8:	9547a783          	lw	a5,-1708(a5) # 80023d18 <cons+0x98>
    800053cc:	9f1d                	subw	a4,a4,a5
    800053ce:	08000793          	li	a5,128
    800053d2:	f8f710e3          	bne	a4,a5,80005352 <consoleintr+0x32>
    800053d6:	a07d                	j	80005484 <consoleintr+0x164>
    800053d8:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800053da:	0001f717          	auipc	a4,0x1f
    800053de:	8a670713          	addi	a4,a4,-1882 # 80023c80 <cons>
    800053e2:	0a072783          	lw	a5,160(a4)
    800053e6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800053ea:	0001f497          	auipc	s1,0x1f
    800053ee:	89648493          	addi	s1,s1,-1898 # 80023c80 <cons>
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
    8000542c:	0001f717          	auipc	a4,0x1f
    80005430:	85470713          	addi	a4,a4,-1964 # 80023c80 <cons>
    80005434:	0a072783          	lw	a5,160(a4)
    80005438:	09c72703          	lw	a4,156(a4)
    8000543c:	f0f70be3          	beq	a4,a5,80005352 <consoleintr+0x32>
      cons.e--;
    80005440:	37fd                	addiw	a5,a5,-1
    80005442:	0001f717          	auipc	a4,0x1f
    80005446:	8cf72f23          	sw	a5,-1826(a4) # 80023d20 <cons+0xa0>
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
    80005460:	0001f797          	auipc	a5,0x1f
    80005464:	82078793          	addi	a5,a5,-2016 # 80023c80 <cons>
    80005468:	0a07a703          	lw	a4,160(a5)
    8000546c:	0017069b          	addiw	a3,a4,1
    80005470:	0006861b          	sext.w	a2,a3
    80005474:	0ad7a023          	sw	a3,160(a5)
    80005478:	07f77713          	andi	a4,a4,127
    8000547c:	97ba                	add	a5,a5,a4
    8000547e:	4729                	li	a4,10
    80005480:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005484:	0001f797          	auipc	a5,0x1f
    80005488:	88c7ac23          	sw	a2,-1896(a5) # 80023d1c <cons+0x9c>
        wakeup(&cons.r);
    8000548c:	0001f517          	auipc	a0,0x1f
    80005490:	88c50513          	addi	a0,a0,-1908 # 80023d18 <cons+0x98>
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
    800054a6:	3de58593          	addi	a1,a1,990 # 80007880 <etext+0x880>
    800054aa:	0001e517          	auipc	a0,0x1e
    800054ae:	7d650513          	addi	a0,a0,2006 # 80023c80 <cons>
    800054b2:	63e000ef          	jal	80005af0 <initlock>

  uartinit();
    800054b6:	3f4000ef          	jal	800058aa <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800054ba:	00015797          	auipc	a5,0x15
    800054be:	62e78793          	addi	a5,a5,1582 # 8001aae8 <devsw>
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
    800054f8:	5e460613          	addi	a2,a2,1508 # 80007ad8 <digits>
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
    80005592:	7b27a783          	lw	a5,1970(a5) # 80023d40 <pr+0x18>
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
    800055de:	74e50513          	addi	a0,a0,1870 # 80023d28 <pr>
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
    8000579e:	33eb8b93          	addi	s7,s7,830 # 80007ad8 <digits>
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
    800057ea:	0a290913          	addi	s2,s2,162 # 80007888 <etext+0x888>
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
    80005838:	4f450513          	addi	a0,a0,1268 # 80023d28 <pr>
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
    80005852:	4e07a923          	sw	zero,1266(a5) # 80023d40 <pr+0x18>
  printf("panic: ");
    80005856:	00002517          	auipc	a0,0x2
    8000585a:	03a50513          	addi	a0,a0,58 # 80007890 <etext+0x890>
    8000585e:	d13ff0ef          	jal	80005570 <printf>
  printf("%s\n", s);
    80005862:	85a6                	mv	a1,s1
    80005864:	00002517          	auipc	a0,0x2
    80005868:	03450513          	addi	a0,a0,52 # 80007898 <etext+0x898>
    8000586c:	d05ff0ef          	jal	80005570 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005870:	4785                	li	a5,1
    80005872:	00005717          	auipc	a4,0x5
    80005876:	dcf72523          	sw	a5,-566(a4) # 8000a63c <panicked>
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
    8000588a:	4a248493          	addi	s1,s1,1186 # 80023d28 <pr>
    8000588e:	00002597          	auipc	a1,0x2
    80005892:	01258593          	addi	a1,a1,18 # 800078a0 <etext+0x8a0>
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
    800058ea:	fc258593          	addi	a1,a1,-62 # 800078a8 <etext+0x8a8>
    800058ee:	0001e517          	auipc	a0,0x1e
    800058f2:	45a50513          	addi	a0,a0,1114 # 80023d48 <uart_tx_lock>
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
    80005916:	d2a7a783          	lw	a5,-726(a5) # 8000a63c <panicked>
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
    8000594c:	cf87b783          	ld	a5,-776(a5) # 8000a640 <uart_tx_r>
    80005950:	00005717          	auipc	a4,0x5
    80005954:	cf873703          	ld	a4,-776(a4) # 8000a648 <uart_tx_w>
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
    8000597a:	3d2a8a93          	addi	s5,s5,978 # 80023d48 <uart_tx_lock>
    uart_tx_r += 1;
    8000597e:	00005497          	auipc	s1,0x5
    80005982:	cc248493          	addi	s1,s1,-830 # 8000a640 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005986:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000598a:	00005997          	auipc	s3,0x5
    8000598e:	cbe98993          	addi	s3,s3,-834 # 8000a648 <uart_tx_w>
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
    800059fe:	34e50513          	addi	a0,a0,846 # 80023d48 <uart_tx_lock>
    80005a02:	16e000ef          	jal	80005b70 <acquire>
  if(panicked){
    80005a06:	00005797          	auipc	a5,0x5
    80005a0a:	c367a783          	lw	a5,-970(a5) # 8000a63c <panicked>
    80005a0e:	efbd                	bnez	a5,80005a8c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005a10:	00005717          	auipc	a4,0x5
    80005a14:	c3873703          	ld	a4,-968(a4) # 8000a648 <uart_tx_w>
    80005a18:	00005797          	auipc	a5,0x5
    80005a1c:	c287b783          	ld	a5,-984(a5) # 8000a640 <uart_tx_r>
    80005a20:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005a24:	0001e997          	auipc	s3,0x1e
    80005a28:	32498993          	addi	s3,s3,804 # 80023d48 <uart_tx_lock>
    80005a2c:	00005497          	auipc	s1,0x5
    80005a30:	c1448493          	addi	s1,s1,-1004 # 8000a640 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005a34:	00005917          	auipc	s2,0x5
    80005a38:	c1490913          	addi	s2,s2,-1004 # 8000a648 <uart_tx_w>
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
    80005a5a:	2f248493          	addi	s1,s1,754 # 80023d48 <uart_tx_lock>
    80005a5e:	01f77793          	andi	a5,a4,31
    80005a62:	97a6                	add	a5,a5,s1
    80005a64:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005a68:	0705                	addi	a4,a4,1
    80005a6a:	00005797          	auipc	a5,0x5
    80005a6e:	bce7bf23          	sd	a4,-1058(a5) # 8000a648 <uart_tx_w>
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
    80005ad2:	27a48493          	addi	s1,s1,634 # 80023d48 <uart_tx_lock>
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
    80005bac:	d0850513          	addi	a0,a0,-760 # 800078b0 <etext+0x8b0>
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
    80005bf4:	cc850513          	addi	a0,a0,-824 # 800078b8 <etext+0x8b8>
    80005bf8:	c4bff0ef          	jal	80005842 <panic>
    panic("pop_off");
    80005bfc:	00002517          	auipc	a0,0x2
    80005c00:	cd450513          	addi	a0,a0,-812 # 800078d0 <etext+0x8d0>
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
    80005c3c:	ca050513          	addi	a0,a0,-864 # 800078d8 <etext+0x8d8>
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
