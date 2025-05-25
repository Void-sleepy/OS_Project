
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	75013103          	ld	sp,1872(sp) # 8000a750 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	108050ef          	jal	8000511e <start>

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
    80000034:	d1078793          	addi	a5,a5,-752 # 80023d40 <end>
    80000038:	02f56b63          	bltu	a0,a5,8000006e <kfree+0x52>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57763          	bgeu	a0,a5,8000006e <kfree+0x52>
  memset(pa, 1, PGSIZE);
#endif
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000044:	0000a917          	auipc	s2,0xa
    80000048:	75c90913          	addi	s2,s2,1884 # 8000a7a0 <kmem>
    8000004c:	854a                	mv	a0,s2
    8000004e:	333050ef          	jal	80005b80 <acquire>
  r->next = kmem.freelist;
    80000052:	01893783          	ld	a5,24(s2)
    80000056:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000058:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000005c:	854a                	mv	a0,s2
    8000005e:	3bb050ef          	jal	80005c18 <release>
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
    80000076:	7dc050ef          	jal	80005852 <panic>

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
    800000d6:	6ce50513          	addi	a0,a0,1742 # 8000a7a0 <kmem>
    800000da:	227050ef          	jal	80005b00 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000de:	45c5                	li	a1,17
    800000e0:	05ee                	slli	a1,a1,0x1b
    800000e2:	00024517          	auipc	a0,0x24
    800000e6:	c5e50513          	addi	a0,a0,-930 # 80023d40 <end>
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
    80000104:	6a048493          	addi	s1,s1,1696 # 8000a7a0 <kmem>
    80000108:	8526                	mv	a0,s1
    8000010a:	277050ef          	jal	80005b80 <acquire>
  r = kmem.freelist;
    8000010e:	6c84                	ld	s1,24(s1)
  if(r) {
    80000110:	c491                	beqz	s1,8000011c <kalloc+0x26>
    kmem.freelist = r->next;
    80000112:	609c                	ld	a5,0(s1)
    80000114:	0000a717          	auipc	a4,0xa
    80000118:	6af73223          	sd	a5,1700(a4) # 8000a7b8 <kmem+0x18>
  }
  release(&kmem.lock);
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	68450513          	addi	a0,a0,1668 # 8000a7a0 <kmem>
    80000124:	2f5050ef          	jal	80005c18 <release>
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
    800002de:	49670713          	addi	a4,a4,1174 # 8000a770 <started>
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
    800002fc:	284050ef          	jal	80005580 <printf>
    kvminithart();    // turn on paging
    80000300:	080000ef          	jal	80000380 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000304:	54e010ef          	jal	80001852 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000308:	031040ef          	jal	80004b38 <plicinithart>
  }

  scheduler();        
    8000030c:	68b000ef          	jal	80001196 <scheduler>
    consoleinit();
    80000310:	19a050ef          	jal	800054aa <consoleinit>
    printfinit();
    80000314:	578050ef          	jal	8000588c <printfinit>
    printf("\n");
    80000318:	00007517          	auipc	a0,0x7
    8000031c:	d0050513          	addi	a0,a0,-768 # 80007018 <etext+0x18>
    80000320:	260050ef          	jal	80005580 <printf>
    printf("xv6 kernel is booting\n");
    80000324:	00007517          	auipc	a0,0x7
    80000328:	cfc50513          	addi	a0,a0,-772 # 80007020 <etext+0x20>
    8000032c:	254050ef          	jal	80005580 <printf>
    printf("\n");
    80000330:	00007517          	auipc	a0,0x7
    80000334:	ce850513          	addi	a0,a0,-792 # 80007018 <etext+0x18>
    80000338:	248050ef          	jal	80005580 <printf>
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
    80000354:	7ca040ef          	jal	80004b1e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000358:	7e0040ef          	jal	80004b38 <plicinithart>
    binit();         // buffer cache
    8000035c:	6e5010ef          	jal	80002240 <binit>
    iinit();         // inode table
    80000360:	4d6020ef          	jal	80002836 <iinit>
    fileinit();      // file table
    80000364:	282030ef          	jal	800035e6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000368:	0c1040ef          	jal	80004c28 <virtio_disk_init>
    userinit();      // first user process
    8000036c:	457000ef          	jal	80000fc2 <userinit>
    __sync_synchronize();
    80000370:	0330000f          	fence	rw,rw
    started = 1;
    80000374:	4785                	li	a5,1
    80000376:	0000a717          	auipc	a4,0xa
    8000037a:	3ef72d23          	sw	a5,1018(a4) # 8000a770 <started>
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
    8000038e:	3ee7b783          	ld	a5,1006(a5) # 8000a778 <kernel_pagetable>
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
    800003d6:	47c050ef          	jal	80005852 <panic>
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
    800003fc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb2b7>
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
    800004ec:	366050ef          	jal	80005852 <panic>
    panic("mappages: size not aligned");
    800004f0:	00007517          	auipc	a0,0x7
    800004f4:	b8850513          	addi	a0,a0,-1144 # 80007078 <etext+0x78>
    800004f8:	35a050ef          	jal	80005852 <panic>
    panic("mappages: size");
    800004fc:	00007517          	auipc	a0,0x7
    80000500:	b9c50513          	addi	a0,a0,-1124 # 80007098 <etext+0x98>
    80000504:	34e050ef          	jal	80005852 <panic>
      panic("mappages: remap");
    80000508:	00007517          	auipc	a0,0x7
    8000050c:	ba050513          	addi	a0,a0,-1120 # 800070a8 <etext+0xa8>
    80000510:	342050ef          	jal	80005852 <panic>
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
    80000554:	2fe050ef          	jal	80005852 <panic>

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
    8000061a:	16a7b123          	sd	a0,354(a5) # 8000a778 <kernel_pagetable>
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
    8000066e:	1e4050ef          	jal	80005852 <panic>
      panic("uvmunmap: walk");
    80000672:	00007517          	auipc	a0,0x7
    80000676:	a6650513          	addi	a0,a0,-1434 # 800070d8 <etext+0xd8>
    8000067a:	1d8050ef          	jal	80005852 <panic>
      printf("va=%ld pte=%ld\n", a, *pte);
    8000067e:	85ca                	mv	a1,s2
    80000680:	00007517          	auipc	a0,0x7
    80000684:	a6850513          	addi	a0,a0,-1432 # 800070e8 <etext+0xe8>
    80000688:	6f9040ef          	jal	80005580 <printf>
      panic("uvmunmap: not mapped");
    8000068c:	00007517          	auipc	a0,0x7
    80000690:	a6c50513          	addi	a0,a0,-1428 # 800070f8 <etext+0xf8>
    80000694:	1be050ef          	jal	80005852 <panic>
      panic("uvmunmap: not a leaf");
    80000698:	00007517          	auipc	a0,0x7
    8000069c:	a7850513          	addi	a0,a0,-1416 # 80007110 <etext+0x110>
    800006a0:	1b2050ef          	jal	80005852 <panic>
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
    80000772:	0e0050ef          	jal	80005852 <panic>

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
    8000089e:	7b5040ef          	jal	80005852 <panic>
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
    8000095c:	6f7040ef          	jal	80005852 <panic>
      panic("uvmcopy: page not present");
    80000960:	00007517          	auipc	a0,0x7
    80000964:	81850513          	addi	a0,a0,-2024 # 80007178 <etext+0x178>
    80000968:	6eb040ef          	jal	80005852 <panic>
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
    800009c2:	691040ef          	jal	80005852 <panic>

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
    80000bf6:	ffe48493          	addi	s1,s1,-2 # 8000abf0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000bfa:	8b26                	mv	s6,s1
    80000bfc:	ff4df937          	lui	s2,0xff4df
    80000c00:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bac7d>
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
    80000c22:	bd2a8a93          	addi	s5,s5,-1070 # 800107f0 <tickslock>
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
    80000c70:	3e3040ef          	jal	80005852 <panic>

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
    80000c94:	b3050513          	addi	a0,a0,-1232 # 8000a7c0 <pid_lock>
    80000c98:	669040ef          	jal	80005b00 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000c9c:	00006597          	auipc	a1,0x6
    80000ca0:	51c58593          	addi	a1,a1,1308 # 800071b8 <etext+0x1b8>
    80000ca4:	0000a517          	auipc	a0,0xa
    80000ca8:	b3450513          	addi	a0,a0,-1228 # 8000a7d8 <wait_lock>
    80000cac:	655040ef          	jal	80005b00 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cb0:	0000a497          	auipc	s1,0xa
    80000cb4:	f4048493          	addi	s1,s1,-192 # 8000abf0 <proc>
      initlock(&p->lock, "proc");
    80000cb8:	00006b17          	auipc	s6,0x6
    80000cbc:	510b0b13          	addi	s6,s6,1296 # 800071c8 <etext+0x1c8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cc0:	8aa6                	mv	s5,s1
    80000cc2:	ff4df937          	lui	s2,0xff4df
    80000cc6:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bac7d>
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
    80000ce8:	b0ca0a13          	addi	s4,s4,-1268 # 800107f0 <tickslock>
      initlock(&p->lock, "proc");
    80000cec:	85da                	mv	a1,s6
    80000cee:	8526                	mv	a0,s1
    80000cf0:	611040ef          	jal	80005b00 <initlock>
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
    80000d4a:	aaa50513          	addi	a0,a0,-1366 # 8000a7f0 <cpus>
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
    80000d60:	5e1040ef          	jal	80005b40 <push_off>
    80000d64:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d66:	2781                	sext.w	a5,a5
    80000d68:	079e                	slli	a5,a5,0x7
    80000d6a:	0000a717          	auipc	a4,0xa
    80000d6e:	a5670713          	addi	a4,a4,-1450 # 8000a7c0 <pid_lock>
    80000d72:	97ba                	add	a5,a5,a4
    80000d74:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d76:	64f040ef          	jal	80005bc4 <pop_off>
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
    80000d92:	687040ef          	jal	80005c18 <release>

  if (first) {
    80000d96:	0000a797          	auipc	a5,0xa
    80000d9a:	96a7a783          	lw	a5,-1686(a5) # 8000a700 <first.1>
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
    80000dae:	21d010ef          	jal	800027ca <fsinit>
    first = 0;
    80000db2:	0000a797          	auipc	a5,0xa
    80000db6:	9407a723          	sw	zero,-1714(a5) # 8000a700 <first.1>
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
    80000dd0:	9f490913          	addi	s2,s2,-1548 # 8000a7c0 <pid_lock>
    80000dd4:	854a                	mv	a0,s2
    80000dd6:	5ab040ef          	jal	80005b80 <acquire>
  pid = nextpid;
    80000dda:	0000a797          	auipc	a5,0xa
    80000dde:	92a78793          	addi	a5,a5,-1750 # 8000a704 <nextpid>
    80000de2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000de4:	0014871b          	addiw	a4,s1,1
    80000de8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000dea:	854a                	mv	a0,s2
    80000dec:	62d040ef          	jal	80005c18 <release>
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
    80000f28:	ccc48493          	addi	s1,s1,-820 # 8000abf0 <proc>
    80000f2c:	00010917          	auipc	s2,0x10
    80000f30:	8c490913          	addi	s2,s2,-1852 # 800107f0 <tickslock>
    acquire(&p->lock);
    80000f34:	8526                	mv	a0,s1
    80000f36:	44b040ef          	jal	80005b80 <acquire>
    if(p->state == UNUSED) {
    80000f3a:	4c9c                	lw	a5,24(s1)
    80000f3c:	cb91                	beqz	a5,80000f50 <allocproc+0x38>
      release(&p->lock);
    80000f3e:	8526                	mv	a0,s1
    80000f40:	4d9040ef          	jal	80005c18 <release>
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
    80000faa:	46f040ef          	jal	80005c18 <release>
    return 0;
    80000fae:	84ca                	mv	s1,s2
    80000fb0:	b7d5                	j	80000f94 <allocproc+0x7c>
    freeproc(p);
    80000fb2:	8526                	mv	a0,s1
    80000fb4:	f15ff0ef          	jal	80000ec8 <freeproc>
    release(&p->lock);
    80000fb8:	8526                	mv	a0,s1
    80000fba:	45f040ef          	jal	80005c18 <release>
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
    80000fd6:	7aa7b723          	sd	a0,1966(a5) # 8000a780 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000fda:	03400613          	li	a2,52
    80000fde:	00009597          	auipc	a1,0x9
    80000fe2:	73258593          	addi	a1,a1,1842 # 8000a710 <initcode>
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
    80001014:	0c4020ef          	jal	800030d8 <namei>
    80001018:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000101c:	478d                	li	a5,3
    8000101e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001020:	8526                	mv	a0,s1
    80001022:	3f7040ef          	jal	80005c18 <release>
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
    80001110:	309040ef          	jal	80005c18 <release>
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
    80001126:	542020ef          	jal	80003668 <filedup>
    8000112a:	00a93023          	sd	a0,0(s2)
    8000112e:	b7f5                	j	8000111a <fork+0x9a>
  np->cwd = idup(p->cwd);
    80001130:	150ab503          	ld	a0,336(s5)
    80001134:	095010ef          	jal	800029c8 <idup>
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
    80001150:	2c9040ef          	jal	80005c18 <release>
  acquire(&wait_lock);
    80001154:	00009497          	auipc	s1,0x9
    80001158:	68448493          	addi	s1,s1,1668 # 8000a7d8 <wait_lock>
    8000115c:	8526                	mv	a0,s1
    8000115e:	223040ef          	jal	80005b80 <acquire>
  np->parent = p;
    80001162:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001166:	8526                	mv	a0,s1
    80001168:	2b1040ef          	jal	80005c18 <release>
  acquire(&np->lock);
    8000116c:	854e                	mv	a0,s3
    8000116e:	213040ef          	jal	80005b80 <acquire>
  np->state = RUNNABLE;
    80001172:	478d                	li	a5,3
    80001174:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001178:	854e                	mv	a0,s3
    8000117a:	29f040ef          	jal	80005c18 <release>
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
    800011ba:	60a70713          	addi	a4,a4,1546 # 8000a7c0 <pid_lock>
    800011be:	975a                	add	a4,a4,s6
    800011c0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011c4:	00009717          	auipc	a4,0x9
    800011c8:	63470713          	addi	a4,a4,1588 # 8000a7f8 <cpus+0x8>
    800011cc:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800011ce:	4c11                	li	s8,4
        c->proc = p;
    800011d0:	079e                	slli	a5,a5,0x7
    800011d2:	00009a17          	auipc	s4,0x9
    800011d6:	5eea0a13          	addi	s4,s4,1518 # 8000a7c0 <pid_lock>
    800011da:	9a3e                	add	s4,s4,a5
        found = 1;
    800011dc:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    800011de:	0000f997          	auipc	s3,0xf
    800011e2:	61298993          	addi	s3,s3,1554 # 800107f0 <tickslock>
    800011e6:	a0a9                	j	80001230 <scheduler+0x9a>
      release(&p->lock);
    800011e8:	8526                	mv	a0,s1
    800011ea:	22f040ef          	jal	80005c18 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011ee:	17048493          	addi	s1,s1,368
    800011f2:	03348563          	beq	s1,s3,8000121c <scheduler+0x86>
      acquire(&p->lock);
    800011f6:	8526                	mv	a0,s1
    800011f8:	189040ef          	jal	80005b80 <acquire>
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
    80001242:	9b248493          	addi	s1,s1,-1614 # 8000abf0 <proc>
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
    8000125e:	0b9040ef          	jal	80005b16 <holding>
    80001262:	c92d                	beqz	a0,800012d4 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001264:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001266:	2781                	sext.w	a5,a5
    80001268:	079e                	slli	a5,a5,0x7
    8000126a:	00009717          	auipc	a4,0x9
    8000126e:	55670713          	addi	a4,a4,1366 # 8000a7c0 <pid_lock>
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
    80001294:	53090913          	addi	s2,s2,1328 # 8000a7c0 <pid_lock>
    80001298:	2781                	sext.w	a5,a5
    8000129a:	079e                	slli	a5,a5,0x7
    8000129c:	97ca                	add	a5,a5,s2
    8000129e:	0ac7a983          	lw	s3,172(a5)
    800012a2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012a4:	2781                	sext.w	a5,a5
    800012a6:	079e                	slli	a5,a5,0x7
    800012a8:	00009597          	auipc	a1,0x9
    800012ac:	55058593          	addi	a1,a1,1360 # 8000a7f8 <cpus+0x8>
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
    800012dc:	576040ef          	jal	80005852 <panic>
    panic("sched locks");
    800012e0:	00006517          	auipc	a0,0x6
    800012e4:	f1850513          	addi	a0,a0,-232 # 800071f8 <etext+0x1f8>
    800012e8:	56a040ef          	jal	80005852 <panic>
    panic("sched running");
    800012ec:	00006517          	auipc	a0,0x6
    800012f0:	f1c50513          	addi	a0,a0,-228 # 80007208 <etext+0x208>
    800012f4:	55e040ef          	jal	80005852 <panic>
    panic("sched interruptible");
    800012f8:	00006517          	auipc	a0,0x6
    800012fc:	f2050513          	addi	a0,a0,-224 # 80007218 <etext+0x218>
    80001300:	552040ef          	jal	80005852 <panic>

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
    80001314:	06d040ef          	jal	80005b80 <acquire>
  p->state = RUNNABLE;
    80001318:	478d                	li	a5,3
    8000131a:	cc9c                	sw	a5,24(s1)
  sched();
    8000131c:	f2fff0ef          	jal	8000124a <sched>
  release(&p->lock);
    80001320:	8526                	mv	a0,s1
    80001322:	0f7040ef          	jal	80005c18 <release>
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
    80001348:	039040ef          	jal	80005b80 <acquire>
  release(lk);
    8000134c:	854a                	mv	a0,s2
    8000134e:	0cb040ef          	jal	80005c18 <release>

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
    80001364:	0b5040ef          	jal	80005c18 <release>
  acquire(lk);
    80001368:	854a                	mv	a0,s2
    8000136a:	017040ef          	jal	80005b80 <acquire>
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
    80001390:	0000a497          	auipc	s1,0xa
    80001394:	86048493          	addi	s1,s1,-1952 # 8000abf0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001398:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000139a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000139c:	0000f917          	auipc	s2,0xf
    800013a0:	45490913          	addi	s2,s2,1108 # 800107f0 <tickslock>
    800013a4:	a801                	j	800013b4 <wakeup+0x38>
      }
      release(&p->lock);
    800013a6:	8526                	mv	a0,s1
    800013a8:	071040ef          	jal	80005c18 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013ac:	17048493          	addi	s1,s1,368
    800013b0:	03248263          	beq	s1,s2,800013d4 <wakeup+0x58>
    if(p != myproc()){
    800013b4:	9a3ff0ef          	jal	80000d56 <myproc>
    800013b8:	fea48ae3          	beq	s1,a0,800013ac <wakeup+0x30>
      acquire(&p->lock);
    800013bc:	8526                	mv	a0,s1
    800013be:	7c2040ef          	jal	80005b80 <acquire>
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
    800013fc:	7f848493          	addi	s1,s1,2040 # 8000abf0 <proc>
      pp->parent = initproc;
    80001400:	00009a17          	auipc	s4,0x9
    80001404:	380a0a13          	addi	s4,s4,896 # 8000a780 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001408:	0000f997          	auipc	s3,0xf
    8000140c:	3e898993          	addi	s3,s3,1000 # 800107f0 <tickslock>
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
    80001458:	32c7b783          	ld	a5,812(a5) # 8000a780 <initproc>
    8000145c:	0d050493          	addi	s1,a0,208
    80001460:	15050913          	addi	s2,a0,336
    80001464:	00a79f63          	bne	a5,a0,80001482 <exit+0x46>
    panic("init exiting");
    80001468:	00006517          	auipc	a0,0x6
    8000146c:	dc850513          	addi	a0,a0,-568 # 80007230 <etext+0x230>
    80001470:	3e2040ef          	jal	80005852 <panic>
      fileclose(f);
    80001474:	23a020ef          	jal	800036ae <fileclose>
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
    80001488:	60d010ef          	jal	80003294 <begin_op>
  iput(p->cwd);
    8000148c:	1509b503          	ld	a0,336(s3)
    80001490:	6f0010ef          	jal	80002b80 <iput>
  end_op();
    80001494:	66b010ef          	jal	800032fe <end_op>
  p->cwd = 0;
    80001498:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000149c:	00009497          	auipc	s1,0x9
    800014a0:	33c48493          	addi	s1,s1,828 # 8000a7d8 <wait_lock>
    800014a4:	8526                	mv	a0,s1
    800014a6:	6da040ef          	jal	80005b80 <acquire>
  reparent(p);
    800014aa:	854e                	mv	a0,s3
    800014ac:	f3bff0ef          	jal	800013e6 <reparent>
  wakeup(p->parent);
    800014b0:	0389b503          	ld	a0,56(s3)
    800014b4:	ec9ff0ef          	jal	8000137c <wakeup>
  acquire(&p->lock);
    800014b8:	854e                	mv	a0,s3
    800014ba:	6c6040ef          	jal	80005b80 <acquire>
  p->xstate = status;
    800014be:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014c2:	4795                	li	a5,5
    800014c4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014c8:	8526                	mv	a0,s1
    800014ca:	74e040ef          	jal	80005c18 <release>
  sched();
    800014ce:	d7dff0ef          	jal	8000124a <sched>
  panic("zombie exit");
    800014d2:	00006517          	auipc	a0,0x6
    800014d6:	d6e50513          	addi	a0,a0,-658 # 80007240 <etext+0x240>
    800014da:	378040ef          	jal	80005852 <panic>

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
    800014f2:	70248493          	addi	s1,s1,1794 # 8000abf0 <proc>
    800014f6:	0000f997          	auipc	s3,0xf
    800014fa:	2fa98993          	addi	s3,s3,762 # 800107f0 <tickslock>
    acquire(&p->lock);
    800014fe:	8526                	mv	a0,s1
    80001500:	680040ef          	jal	80005b80 <acquire>
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
    8000150c:	70c040ef          	jal	80005c18 <release>
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
    8000152a:	6ee040ef          	jal	80005c18 <release>
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
    80001550:	630040ef          	jal	80005b80 <acquire>
  p->killed = 1;
    80001554:	4785                	li	a5,1
    80001556:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001558:	8526                	mv	a0,s1
    8000155a:	6be040ef          	jal	80005c18 <release>
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
    80001576:	60a040ef          	jal	80005b80 <acquire>
  k = p->killed;
    8000157a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000157e:	8526                	mv	a0,s1
    80001580:	698040ef          	jal	80005c18 <release>
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
    800015b6:	22650513          	addi	a0,a0,550 # 8000a7d8 <wait_lock>
    800015ba:	5c6040ef          	jal	80005b80 <acquire>
    havekids = 0;
    800015be:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800015c0:	4a15                	li	s4,5
        havekids = 1;
    800015c2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015c4:	0000f997          	auipc	s3,0xf
    800015c8:	22c98993          	addi	s3,s3,556 # 800107f0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015cc:	00009c17          	auipc	s8,0x9
    800015d0:	20cc0c13          	addi	s8,s8,524 # 8000a7d8 <wait_lock>
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
    800015fa:	61e040ef          	jal	80005c18 <release>
          release(&wait_lock);
    800015fe:	00009517          	auipc	a0,0x9
    80001602:	1da50513          	addi	a0,a0,474 # 8000a7d8 <wait_lock>
    80001606:	612040ef          	jal	80005c18 <release>
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
    80001626:	5f2040ef          	jal	80005c18 <release>
            release(&wait_lock);
    8000162a:	00009517          	auipc	a0,0x9
    8000162e:	1ae50513          	addi	a0,a0,430 # 8000a7d8 <wait_lock>
    80001632:	5e6040ef          	jal	80005c18 <release>
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
    8000164a:	536040ef          	jal	80005b80 <acquire>
        if(pp->state == ZOMBIE){
    8000164e:	4c9c                	lw	a5,24(s1)
    80001650:	f94783e3          	beq	a5,s4,800015d6 <wait+0x44>
        release(&pp->lock);
    80001654:	8526                	mv	a0,s1
    80001656:	5c2040ef          	jal	80005c18 <release>
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
    80001676:	57e48493          	addi	s1,s1,1406 # 8000abf0 <proc>
    8000167a:	b7e1                	j	80001642 <wait+0xb0>
      release(&wait_lock);
    8000167c:	00009517          	auipc	a0,0x9
    80001680:	15c50513          	addi	a0,a0,348 # 8000a7d8 <wait_lock>
    80001684:	594040ef          	jal	80005c18 <release>
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
    8000173e:	643030ef          	jal	80005580 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001742:	00009497          	auipc	s1,0x9
    80001746:	60648493          	addi	s1,s1,1542 # 8000ad48 <proc+0x158>
    8000174a:	0000f917          	auipc	s2,0xf
    8000174e:	1fe90913          	addi	s2,s2,510 # 80010948 <bcache+0xd0>
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
    80001770:	17cb8b93          	addi	s7,s7,380 # 800078e8 <states.0>
    80001774:	a829                	j	8000178e <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001776:	ed86a583          	lw	a1,-296(a3)
    8000177a:	8556                	mv	a0,s5
    8000177c:	605030ef          	jal	80005580 <printf>
    printf("\n");
    80001780:	8552                	mv	a0,s4
    80001782:	5ff030ef          	jal	80005580 <printf>
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
    80001842:	fb250513          	addi	a0,a0,-78 # 800107f0 <tickslock>
    80001846:	2ba040ef          	jal	80005b00 <initlock>
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
    8000185c:	26878793          	addi	a5,a5,616 # 80004ac0 <kernelvec>
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
    8000192a:	eca48493          	addi	s1,s1,-310 # 800107f0 <tickslock>
    8000192e:	8526                	mv	a0,s1
    80001930:	250040ef          	jal	80005b80 <acquire>
    ticks++;
    80001934:	00009517          	auipc	a0,0x9
    80001938:	e5450513          	addi	a0,a0,-428 # 8000a788 <ticks>
    8000193c:	411c                	lw	a5,0(a0)
    8000193e:	2785                	addiw	a5,a5,1
    80001940:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001942:	a3bff0ef          	jal	8000137c <wakeup>
    release(&tickslock);
    80001946:	8526                	mv	a0,s1
    80001948:	2d0040ef          	jal	80005c18 <release>
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
    8000197c:	1f0030ef          	jal	80004b6c <plic_claim>
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
    80001996:	12e040ef          	jal	80005ac4 <uartintr>
    if(irq)
    8000199a:	a819                	j	800019b0 <devintr+0x60>
      virtio_disk_intr();
    8000199c:	696030ef          	jal	80005032 <virtio_disk_intr>
    if(irq)
    800019a0:	a801                	j	800019b0 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019a2:	85a6                	mv	a1,s1
    800019a4:	00006517          	auipc	a0,0x6
    800019a8:	8fc50513          	addi	a0,a0,-1796 # 800072a0 <etext+0x2a0>
    800019ac:	3d5030ef          	jal	80005580 <printf>
      plic_complete(irq);
    800019b0:	8526                	mv	a0,s1
    800019b2:	1da030ef          	jal	80004b8c <plic_complete>
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
    800019de:	0e678793          	addi	a5,a5,230 # 80004ac0 <kernelvec>
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
    80001a18:	63b030ef          	jal	80005852 <panic>
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
    80001a36:	388000ef          	jal	80001dbe <syscall>
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
    80001a76:	30b030ef          	jal	80005580 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a7a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a7e:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a82:	00006517          	auipc	a0,0x6
    80001a86:	88e50513          	addi	a0,a0,-1906 # 80007310 <etext+0x310>
    80001a8a:	2f7030ef          	jal	80005580 <printf>
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
    80001aee:	565030ef          	jal	80005852 <panic>
    panic("kerneltrap: interrupts enabled");
    80001af2:	00006517          	auipc	a0,0x6
    80001af6:	86e50513          	addi	a0,a0,-1938 # 80007360 <etext+0x360>
    80001afa:	559030ef          	jal	80005852 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001afe:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b02:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b06:	85ce                	mv	a1,s3
    80001b08:	00006517          	auipc	a0,0x6
    80001b0c:	87850513          	addi	a0,a0,-1928 # 80007380 <etext+0x380>
    80001b10:	271030ef          	jal	80005580 <printf>
    panic("kerneltrap");
    80001b14:	00006517          	auipc	a0,0x6
    80001b18:	89450513          	addi	a0,a0,-1900 # 800073a8 <etext+0x3a8>
    80001b1c:	537030ef          	jal	80005852 <panic>
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
    80001b5c:	dc070713          	addi	a4,a4,-576 # 80007918 <states.0+0x30>
    80001b60:	94ba                	add	s1,s1,a4
    80001b62:	409c                	lw	a5,0(s1)
    80001b64:	97ba                	add	a5,a5,a4
    80001b66:	8782                	jr	a5
    panic("argraw: invalid proc or trapframe");
    80001b68:	00006517          	auipc	a0,0x6
    80001b6c:	85050513          	addi	a0,a0,-1968 # 800073b8 <etext+0x3b8>
    80001b70:	4e3030ef          	jal	80005852 <panic>
    panic("argraw: invalid n");
    80001b74:	00006517          	auipc	a0,0x6
    80001b78:	86c50513          	addi	a0,a0,-1940 # 800073e0 <etext+0x3e0>
    80001b7c:	4d7030ef          	jal	80005852 <panic>
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
    80001bd0:	c3c48493          	addi	s1,s1,-964 # 80010808 <syscall_counts>
    80001bd4:	00006917          	auipc	s2,0x6
    80001bd8:	d5c90913          	addi	s2,s2,-676 # 80007930 <syscall_names>
    80001bdc:	0000f997          	auipc	s3,0xf
    80001be0:	c9898993          	addi	s3,s3,-872 # 80010874 <syscall_counts+0x6c>
    if (syscall_counts[i] > 0) {
      printf("%s: %d calls\n", syscall_names[i] ? syscall_names[i] : "unknown", syscall_counts[i]);
    80001be4:	00006a17          	auipc	s4,0x6
    80001be8:	81ca0a13          	addi	s4,s4,-2020 # 80007400 <etext+0x400>
    80001bec:	00006a97          	auipc	s5,0x6
    80001bf0:	80ca8a93          	addi	s5,s5,-2036 # 800073f8 <etext+0x3f8>
    80001bf4:	a801                	j	80001c04 <sys_stats+0x4a>
    80001bf6:	8552                	mv	a0,s4
    80001bf8:	189030ef          	jal	80005580 <printf>
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

0000000080001dbe <syscall>:
////////////////[New sys call  the "coooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooler one" ]////////////////////////////////////////////
// System call dispatcher with statistics

void
syscall(void)
{
    80001dbe:	7179                	addi	sp,sp,-48
    80001dc0:	f406                	sd	ra,40(sp)
    80001dc2:	f022                	sd	s0,32(sp)
    80001dc4:	ec26                	sd	s1,24(sp)
    80001dc6:	e84a                	sd	s2,16(sp)
    80001dc8:	e44e                	sd	s3,8(sp)
    80001dca:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001dcc:	f8bfe0ef          	jal	80000d56 <myproc>
    80001dd0:	84aa                	mv	s1,a0
  int num = p->trapframe->a7;
    80001dd2:	05853983          	ld	s3,88(a0)
    80001dd6:	0a89b783          	ld	a5,168(s3)
    80001dda:	0007891b          	sext.w	s2,a5
    [SYS_chdir] "chdir", [SYS_dup] "dup", [SYS_getpid] "getpid",
    [SYS_sbrk] "sbrk", [SYS_sleep] "sleep", [SYS_uptime] "uptime",
    [SYS_trace] "trace", [SYS_stats] "stats", [SYS_socket] "socket",
    [SYS_gettime] "gettime", [SYS_mmap] "mmap"
  };
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001dde:	37fd                	addiw	a5,a5,-1
    80001de0:	4765                	li	a4,25
    80001de2:	06f76863          	bltu	a4,a5,80001e52 <syscall+0x94>
    80001de6:	00391713          	slli	a4,s2,0x3
    80001dea:	00006797          	auipc	a5,0x6
    80001dee:	b4678793          	addi	a5,a5,-1210 # 80007930 <syscall_names>
    80001df2:	97ba                	add	a5,a5,a4
    80001df4:	6ffc                	ld	a5,216(a5)
    80001df6:	cfb1                	beqz	a5,80001e52 <syscall+0x94>
    p->trapframe->a0 = syscalls[num]();
    80001df8:	9782                	jalr	a5
    80001dfa:	06a9b823          	sd	a0,112(s3)
    syscall_counts[num]++;
    80001dfe:	00291713          	slli	a4,s2,0x2
    80001e02:	0000f797          	auipc	a5,0xf
    80001e06:	a0678793          	addi	a5,a5,-1530 # 80010808 <syscall_counts>
    80001e0a:	97ba                	add	a5,a5,a4
    80001e0c:	4398                	lw	a4,0(a5)
    80001e0e:	2705                	addiw	a4,a4,1
    80001e10:	c398                	sw	a4,0(a5)
    if (p->trace_mask & (1 << num)) {
    80001e12:	4705                	li	a4,1
    80001e14:	0127173b          	sllw	a4,a4,s2
    80001e18:	1684a783          	lw	a5,360(s1)
    80001e1c:	8ff9                	and	a5,a5,a4
    80001e1e:	2781                	sext.w	a5,a5
    80001e20:	c7b1                	beqz	a5,80001e6c <syscall+0xae>
      printf("\n%d: %s -> %ld\n", p->pid, syscall_names[num] ? syscall_names[num] : "unknown", p->trapframe->a0);
    80001e22:	588c                	lw	a1,48(s1)
    80001e24:	090e                	slli	s2,s2,0x3
    80001e26:	00006797          	auipc	a5,0x6
    80001e2a:	b0a78793          	addi	a5,a5,-1270 # 80007930 <syscall_names>
    80001e2e:	97ca                	add	a5,a5,s2
    80001e30:	1b07b603          	ld	a2,432(a5)
    80001e34:	ca11                	beqz	a2,80001e48 <syscall+0x8a>
    80001e36:	6cbc                	ld	a5,88(s1)
    80001e38:	7bb4                	ld	a3,112(a5)
    80001e3a:	00005517          	auipc	a0,0x5
    80001e3e:	5d650513          	addi	a0,a0,1494 # 80007410 <etext+0x410>
    80001e42:	73e030ef          	jal	80005580 <printf>
    80001e46:	a01d                	j	80001e6c <syscall+0xae>
    80001e48:	00005617          	auipc	a2,0x5
    80001e4c:	5b060613          	addi	a2,a2,1456 # 800073f8 <etext+0x3f8>
    80001e50:	b7dd                	j	80001e36 <syscall+0x78>
    }
  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80001e52:	86ca                	mv	a3,s2
    80001e54:	15848613          	addi	a2,s1,344
    80001e58:	588c                	lw	a1,48(s1)
    80001e5a:	00005517          	auipc	a0,0x5
    80001e5e:	5c650513          	addi	a0,a0,1478 # 80007420 <etext+0x420>
    80001e62:	71e030ef          	jal	80005580 <printf>
    p->trapframe->a0 = -1;
    80001e66:	6cbc                	ld	a5,88(s1)
    80001e68:	577d                	li	a4,-1
    80001e6a:	fbb8                	sd	a4,112(a5)
  }
}
    80001e6c:	70a2                	ld	ra,40(sp)
    80001e6e:	7402                	ld	s0,32(sp)
    80001e70:	64e2                	ld	s1,24(sp)
    80001e72:	6942                	ld	s2,16(sp)
    80001e74:	69a2                	ld	s3,8(sp)
    80001e76:	6145                	addi	sp,sp,48
    80001e78:	8082                	ret

0000000080001e7a <read_string>:
///////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////
// Read null-terminated string from user space
int read_string(struct proc *p, uint64 addr, char *buf, int max) {
    80001e7a:	715d                	addi	sp,sp,-80
    80001e7c:	e486                	sd	ra,72(sp)
    80001e7e:	e0a2                	sd	s0,64(sp)
    80001e80:	f84a                	sd	s2,48(sp)
    80001e82:	0880                	addi	s0,sp,80
  
  if(addr >= p->sz)
    80001e84:	653c                	ld	a5,72(a0)
    80001e86:	08f5f563          	bgeu	a1,a5,80001f10 <read_string+0x96>
    80001e8a:	f052                	sd	s4,32(sp)
    80001e8c:	ec56                	sd	s5,24(sp)
    80001e8e:	e45e                	sd	s7,8(sp)
    80001e90:	8aaa                	mv	s5,a0
    80001e92:	8bb2                	mv	s7,a2
    80001e94:	8a36                	mv	s4,a3
  {
    return -1; }
  int n = 0;
  while(n < max) {
    80001e96:	06d05763          	blez	a3,80001f04 <read_string+0x8a>
    80001e9a:	fc26                	sd	s1,56(sp)
    80001e9c:	f44e                	sd	s3,40(sp)
    80001e9e:	e85a                	sd	s6,16(sp)
    80001ea0:	84b2                	mv	s1,a2
  int n = 0;
    80001ea2:	4901                	li	s2,0
    if(copyin(p->pagetable, buf + n, addr + n, 1) == -1) {
    80001ea4:	40c589b3          	sub	s3,a1,a2
    80001ea8:	5b7d                	li	s6,-1
    80001eaa:	4685                	li	a3,1
    80001eac:	00998633          	add	a2,s3,s1
    80001eb0:	85a6                	mv	a1,s1
    80001eb2:	050ab503          	ld	a0,80(s5)
    80001eb6:	be9fe0ef          	jal	80000a9e <copyin>
    80001eba:	03650463          	beq	a0,s6,80001ee2 <read_string+0x68>
      break;
    }
    if(buf[n] == '\0'){
    80001ebe:	0004c783          	lbu	a5,0(s1)
    80001ec2:	c385                	beqz	a5,80001ee2 <read_string+0x68>
      break;
    }
    n++;
    80001ec4:	2905                	addiw	s2,s2,1
  while(n < max) {
    80001ec6:	0485                	addi	s1,s1,1
    80001ec8:	ff2a11e3          	bne	s4,s2,80001eaa <read_string+0x30>
    80001ecc:	8952                	mv	s2,s4
    80001ece:	74e2                	ld	s1,56(sp)
    80001ed0:	79a2                	ld	s3,40(sp)
    80001ed2:	6b42                	ld	s6,16(sp)
  }
  if(n < max){
    buf[n] = '\0';
  } else {
    buf[max-1] = '\0';
    80001ed4:	9bd2                	add	s7,s7,s4
    80001ed6:	fe0b8fa3          	sb	zero,-1(s7)
    80001eda:	7a02                	ld	s4,32(sp)
    80001edc:	6ae2                	ld	s5,24(sp)
    80001ede:	6ba2                	ld	s7,8(sp)
    80001ee0:	a821                	j	80001ef8 <read_string+0x7e>
  if(n < max){
    80001ee2:	03495363          	bge	s2,s4,80001f08 <read_string+0x8e>
    buf[n] = '\0';
    80001ee6:	9bca                	add	s7,s7,s2
    80001ee8:	000b8023          	sb	zero,0(s7)
    80001eec:	74e2                	ld	s1,56(sp)
    80001eee:	79a2                	ld	s3,40(sp)
    80001ef0:	7a02                	ld	s4,32(sp)
    80001ef2:	6ae2                	ld	s5,24(sp)
    80001ef4:	6b42                	ld	s6,16(sp)
    80001ef6:	6ba2                	ld	s7,8(sp)
  } 
  return n;
}
    80001ef8:	854a                	mv	a0,s2
    80001efa:	60a6                	ld	ra,72(sp)
    80001efc:	6406                	ld	s0,64(sp)
    80001efe:	7942                	ld	s2,48(sp)
    80001f00:	6161                	addi	sp,sp,80
    80001f02:	8082                	ret
  int n = 0;
    80001f04:	4901                	li	s2,0
    80001f06:	b7f9                	j	80001ed4 <read_string+0x5a>
    80001f08:	74e2                	ld	s1,56(sp)
    80001f0a:	79a2                	ld	s3,40(sp)
    80001f0c:	6b42                	ld	s6,16(sp)
    80001f0e:	b7d9                	j	80001ed4 <read_string+0x5a>
    return -1; }
    80001f10:	597d                	li	s2,-1
    80001f12:	b7dd                	j	80001ef8 <read_string+0x7e>

0000000080001f14 <read_memory>:

////////////////////////////////////////////////////////////////////////////////////////////////////
// Read arbitrary memory from user space
int read_memory(struct proc *p, uint64 addr, char *buf, int n) {
    80001f14:	87ae                	mv	a5,a1

  if(addr >= p->sz || addr + n > p->sz)
    80001f16:	6538                	ld	a4,72(a0)
    80001f18:	02e5fa63          	bgeu	a1,a4,80001f4c <read_memory+0x38>
int read_memory(struct proc *p, uint64 addr, char *buf, int n) {
    80001f1c:	1101                	addi	sp,sp,-32
    80001f1e:	ec06                	sd	ra,24(sp)
    80001f20:	e822                	sd	s0,16(sp)
    80001f22:	e426                	sd	s1,8(sp)
    80001f24:	1000                	addi	s0,sp,32
    80001f26:	85b2                	mv	a1,a2
    80001f28:	84b6                	mv	s1,a3
  if(addr >= p->sz || addr + n > p->sz)
    80001f2a:	96be                	add	a3,a3,a5
    80001f2c:	02d76263          	bltu	a4,a3,80001f50 <read_memory+0x3c>
    return -1;

  if(copyin(p->pagetable, buf, addr, n) == -1)
    80001f30:	86a6                	mv	a3,s1
    80001f32:	863e                	mv	a2,a5
    80001f34:	6928                	ld	a0,80(a0)
    80001f36:	b69fe0ef          	jal	80000a9e <copyin>
    80001f3a:	57fd                	li	a5,-1
    80001f3c:	00f50363          	beq	a0,a5,80001f42 <read_memory+0x2e>
    return -1;

  return n;
    80001f40:	8526                	mv	a0,s1
}
    80001f42:	60e2                	ld	ra,24(sp)
    80001f44:	6442                	ld	s0,16(sp)
    80001f46:	64a2                	ld	s1,8(sp)
    80001f48:	6105                	addi	sp,sp,32
    80001f4a:	8082                	ret
    return -1;
    80001f4c:	557d                	li	a0,-1
}
    80001f4e:	8082                	ret
    return -1;
    80001f50:	557d                	li	a0,-1
    80001f52:	bfc5                	j	80001f42 <read_memory+0x2e>

0000000080001f54 <print_syscall>:

//////////////////////////////////////////////////////////////


// Print system call details (enhanced for open's mode)
void print_syscall(struct proc *p, int num, uint64 args[], uint64 ret) {
    80001f54:	7119                	addi	sp,sp,-128
    80001f56:	fc86                	sd	ra,120(sp)
    80001f58:	f8a2                	sd	s0,112(sp)
    80001f5a:	f4a6                	sd	s1,104(sp)
    80001f5c:	0100                	addi	s0,sp,128
    80001f5e:	84ae                	mv	s1,a1
    80001f60:	f8d43423          	sd	a3,-120(s0)
  if (p->trace_mask & (1 << num)) {
    80001f64:	4705                	li	a4,1
    80001f66:	00b7173b          	sllw	a4,a4,a1
    80001f6a:	16852783          	lw	a5,360(a0)
    80001f6e:	8ff9                	and	a5,a5,a4
    80001f70:	2781                	sext.w	a5,a5
    80001f72:	0e078463          	beqz	a5,8000205a <print_syscall+0x106>
    80001f76:	f0ca                	sd	s2,96(sp)
    80001f78:	ecce                	sd	s3,88(sp)
    80001f7a:	e8d2                	sd	s4,80(sp)
    80001f7c:	e4d6                	sd	s5,72(sp)
    80001f7e:	e0da                	sd	s6,64(sp)
    80001f80:	fc5e                	sd	s7,56(sp)
    80001f82:	f862                	sd	s8,48(sp)
    80001f84:	f466                	sd	s9,40(sp)
    80001f86:	f06a                	sd	s10,32(sp)
    80001f88:	ec6e                	sd	s11,24(sp)
    80001f8a:	8932                	mv	s2,a2
    printf("1: %s(", syscall_names[num] ? syscall_names[num] : "unknown");
    80001f8c:	00359713          	slli	a4,a1,0x3
    80001f90:	00006797          	auipc	a5,0x6
    80001f94:	9a078793          	addi	a5,a5,-1632 # 80007930 <syscall_names>
    80001f98:	97ba                	add	a5,a5,a4
    80001f9a:	638c                	ld	a1,0(a5)
    80001f9c:	cd8d                	beqz	a1,80001fd6 <print_syscall+0x82>
    80001f9e:	00005517          	auipc	a0,0x5
    80001fa2:	4a250513          	addi	a0,a0,1186 # 80007440 <etext+0x440>
    80001fa6:	5da030ef          	jal	80005580 <printf>
    for (int i = 0; i < 3 && argtypes[num][i]; i++) {
    80001faa:	00149b13          	slli	s6,s1,0x1
    80001fae:	9b26                	add	s6,s6,s1
    printf("1: %s(", syscall_names[num] ? syscall_names[num] : "unknown");
    80001fb0:	4981                	li	s3,0
    for (int i = 0; i < 3 && argtypes[num][i]; i++) {
    80001fb2:	00006b97          	auipc	s7,0x6
    80001fb6:	c06b8b93          	addi	s7,s7,-1018 # 80007bb8 <argtypes>
      if (i > 0) printf(", ");
    80001fba:	00005d97          	auipc	s11,0x5
    80001fbe:	48ed8d93          	addi	s11,s11,1166 # 80007448 <etext+0x448>
      if (argtypes[num][i] == 'i') printf("%d", (int)args[i]);
    80001fc2:	06900c93          	li	s9,105
      else if (argtypes[num][i] == 'a') printf("0x%lx", args[i]);
    80001fc6:	06100d13          	li	s10,97
      else printf("?");
    80001fca:	00005a97          	auipc	s5,0x5
    80001fce:	496a8a93          	addi	s5,s5,1174 # 80007460 <etext+0x460>
    for (int i = 0; i < 3 && argtypes[num][i]; i++) {
    80001fd2:	4c0d                	li	s8,3
    80001fd4:	a81d                	j	8000200a <print_syscall+0xb6>
    printf("1: %s(", syscall_names[num] ? syscall_names[num] : "unknown");
    80001fd6:	00005597          	auipc	a1,0x5
    80001fda:	42258593          	addi	a1,a1,1058 # 800073f8 <etext+0x3f8>
    80001fde:	b7c1                	j	80001f9e <print_syscall+0x4a>
      if (argtypes[num][i] == 'i') printf("%d", (int)args[i]);
    80001fe0:	00092583          	lw	a1,0(s2)
    80001fe4:	00005517          	auipc	a0,0x5
    80001fe8:	46c50513          	addi	a0,a0,1132 # 80007450 <etext+0x450>
    80001fec:	594030ef          	jal	80005580 <printf>
    80001ff0:	a809                	j	80002002 <print_syscall+0xae>
      else if (argtypes[num][i] == 'a') printf("0x%lx", args[i]);
    80001ff2:	00093583          	ld	a1,0(s2)
    80001ff6:	00005517          	auipc	a0,0x5
    80001ffa:	46250513          	addi	a0,a0,1122 # 80007458 <etext+0x458>
    80001ffe:	582030ef          	jal	80005580 <printf>
    for (int i = 0; i < 3 && argtypes[num][i]; i++) {
    80002002:	0985                	addi	s3,s3,1
    80002004:	0921                	addi	s2,s2,8
    80002006:	03898863          	beq	s3,s8,80002036 <print_syscall+0xe2>
    8000200a:	016987b3          	add	a5,s3,s6
    8000200e:	97de                	add	a5,a5,s7
    80002010:	0007ca03          	lbu	s4,0(a5)
    80002014:	020a0163          	beqz	s4,80002036 <print_syscall+0xe2>
      if (i > 0) printf(", ");
    80002018:	0009879b          	sext.w	a5,s3
    8000201c:	00f05563          	blez	a5,80002026 <print_syscall+0xd2>
    80002020:	856e                	mv	a0,s11
    80002022:	55e030ef          	jal	80005580 <printf>
      if (argtypes[num][i] == 'i') printf("%d", (int)args[i]);
    80002026:	fb9a0de3          	beq	s4,s9,80001fe0 <print_syscall+0x8c>
      else if (argtypes[num][i] == 'a') printf("0x%lx", args[i]);
    8000202a:	fdaa04e3          	beq	s4,s10,80001ff2 <print_syscall+0x9e>
      else printf("?");
    8000202e:	8556                	mv	a0,s5
    80002030:	550030ef          	jal	80005580 <printf>
    80002034:	b7f9                	j	80002002 <print_syscall+0xae>
    }
    printf(") = %ld\n", ret);
    80002036:	f8843583          	ld	a1,-120(s0)
    8000203a:	00005517          	auipc	a0,0x5
    8000203e:	42e50513          	addi	a0,a0,1070 # 80007468 <etext+0x468>
    80002042:	53e030ef          	jal	80005580 <printf>
    80002046:	7906                	ld	s2,96(sp)
    80002048:	69e6                	ld	s3,88(sp)
    8000204a:	6a46                	ld	s4,80(sp)
    8000204c:	6aa6                	ld	s5,72(sp)
    8000204e:	6b06                	ld	s6,64(sp)
    80002050:	7be2                	ld	s7,56(sp)
    80002052:	7c42                	ld	s8,48(sp)
    80002054:	7ca2                	ld	s9,40(sp)
    80002056:	7d02                	ld	s10,32(sp)
    80002058:	6de2                	ld	s11,24(sp)
  }
  syscall_counts[num]++;
    8000205a:	048a                	slli	s1,s1,0x2
    8000205c:	0000e797          	auipc	a5,0xe
    80002060:	7ac78793          	addi	a5,a5,1964 # 80010808 <syscall_counts>
    80002064:	97a6                	add	a5,a5,s1
    80002066:	4398                	lw	a4,0(a5)
    80002068:	2705                	addiw	a4,a4,1
    8000206a:	c398                	sw	a4,0(a5)
}
    8000206c:	70e6                	ld	ra,120(sp)
    8000206e:	7446                	ld	s0,112(sp)
    80002070:	74a6                	ld	s1,104(sp)
    80002072:	6109                	addi	sp,sp,128
    80002074:	8082                	ret

0000000080002076 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002076:	1101                	addi	sp,sp,-32
    80002078:	ec06                	sd	ra,24(sp)
    8000207a:	e822                	sd	s0,16(sp)
    8000207c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000207e:	fec40593          	addi	a1,s0,-20
    80002082:	4501                	li	a0,0
    80002084:	c55ff0ef          	jal	80001cd8 <argint>
  exit(n);
    80002088:	fec42503          	lw	a0,-20(s0)
    8000208c:	bb0ff0ef          	jal	8000143c <exit>
  return 0;  // not reached
}
    80002090:	4501                	li	a0,0
    80002092:	60e2                	ld	ra,24(sp)
    80002094:	6442                	ld	s0,16(sp)
    80002096:	6105                	addi	sp,sp,32
    80002098:	8082                	ret

000000008000209a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000209a:	1141                	addi	sp,sp,-16
    8000209c:	e406                	sd	ra,8(sp)
    8000209e:	e022                	sd	s0,0(sp)
    800020a0:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020a2:	cb5fe0ef          	jal	80000d56 <myproc>
}
    800020a6:	5908                	lw	a0,48(a0)
    800020a8:	60a2                	ld	ra,8(sp)
    800020aa:	6402                	ld	s0,0(sp)
    800020ac:	0141                	addi	sp,sp,16
    800020ae:	8082                	ret

00000000800020b0 <sys_fork>:

uint64
sys_fork(void)
{
    800020b0:	1141                	addi	sp,sp,-16
    800020b2:	e406                	sd	ra,8(sp)
    800020b4:	e022                	sd	s0,0(sp)
    800020b6:	0800                	addi	s0,sp,16
  return fork();
    800020b8:	fc9fe0ef          	jal	80001080 <fork>
}
    800020bc:	60a2                	ld	ra,8(sp)
    800020be:	6402                	ld	s0,0(sp)
    800020c0:	0141                	addi	sp,sp,16
    800020c2:	8082                	ret

00000000800020c4 <sys_wait>:

uint64
sys_wait(void)
{
    800020c4:	1101                	addi	sp,sp,-32
    800020c6:	ec06                	sd	ra,24(sp)
    800020c8:	e822                	sd	s0,16(sp)
    800020ca:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800020cc:	fe840593          	addi	a1,s0,-24
    800020d0:	4501                	li	a0,0
    800020d2:	ca9ff0ef          	jal	80001d7a <argaddr>
  return wait(p);
    800020d6:	fe843503          	ld	a0,-24(s0)
    800020da:	cb8ff0ef          	jal	80001592 <wait>
}
    800020de:	60e2                	ld	ra,24(sp)
    800020e0:	6442                	ld	s0,16(sp)
    800020e2:	6105                	addi	sp,sp,32
    800020e4:	8082                	ret

00000000800020e6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020e6:	7179                	addi	sp,sp,-48
    800020e8:	f406                	sd	ra,40(sp)
    800020ea:	f022                	sd	s0,32(sp)
    800020ec:	ec26                	sd	s1,24(sp)
    800020ee:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800020f0:	fdc40593          	addi	a1,s0,-36
    800020f4:	4501                	li	a0,0
    800020f6:	be3ff0ef          	jal	80001cd8 <argint>
  addr = myproc()->sz;
    800020fa:	c5dfe0ef          	jal	80000d56 <myproc>
    800020fe:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002100:	fdc42503          	lw	a0,-36(s0)
    80002104:	f2dfe0ef          	jal	80001030 <growproc>
    80002108:	00054863          	bltz	a0,80002118 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    8000210c:	8526                	mv	a0,s1
    8000210e:	70a2                	ld	ra,40(sp)
    80002110:	7402                	ld	s0,32(sp)
    80002112:	64e2                	ld	s1,24(sp)
    80002114:	6145                	addi	sp,sp,48
    80002116:	8082                	ret
    return -1;
    80002118:	54fd                	li	s1,-1
    8000211a:	bfcd                	j	8000210c <sys_sbrk+0x26>

000000008000211c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000211c:	7139                	addi	sp,sp,-64
    8000211e:	fc06                	sd	ra,56(sp)
    80002120:	f822                	sd	s0,48(sp)
    80002122:	f04a                	sd	s2,32(sp)
    80002124:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002126:	fcc40593          	addi	a1,s0,-52
    8000212a:	4501                	li	a0,0
    8000212c:	badff0ef          	jal	80001cd8 <argint>
  if(n < 0)
    80002130:	fcc42783          	lw	a5,-52(s0)
    80002134:	0607c763          	bltz	a5,800021a2 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002138:	0000e517          	auipc	a0,0xe
    8000213c:	6b850513          	addi	a0,a0,1720 # 800107f0 <tickslock>
    80002140:	241030ef          	jal	80005b80 <acquire>
  ticks0 = ticks;
    80002144:	00008917          	auipc	s2,0x8
    80002148:	64492903          	lw	s2,1604(s2) # 8000a788 <ticks>
  while(ticks - ticks0 < n){
    8000214c:	fcc42783          	lw	a5,-52(s0)
    80002150:	cf8d                	beqz	a5,8000218a <sys_sleep+0x6e>
    80002152:	f426                	sd	s1,40(sp)
    80002154:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002156:	0000e997          	auipc	s3,0xe
    8000215a:	69a98993          	addi	s3,s3,1690 # 800107f0 <tickslock>
    8000215e:	00008497          	auipc	s1,0x8
    80002162:	62a48493          	addi	s1,s1,1578 # 8000a788 <ticks>
    if(killed(myproc())){
    80002166:	bf1fe0ef          	jal	80000d56 <myproc>
    8000216a:	bfeff0ef          	jal	80001568 <killed>
    8000216e:	ed0d                	bnez	a0,800021a8 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002170:	85ce                	mv	a1,s3
    80002172:	8526                	mv	a0,s1
    80002174:	9bcff0ef          	jal	80001330 <sleep>
  while(ticks - ticks0 < n){
    80002178:	409c                	lw	a5,0(s1)
    8000217a:	412787bb          	subw	a5,a5,s2
    8000217e:	fcc42703          	lw	a4,-52(s0)
    80002182:	fee7e2e3          	bltu	a5,a4,80002166 <sys_sleep+0x4a>
    80002186:	74a2                	ld	s1,40(sp)
    80002188:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000218a:	0000e517          	auipc	a0,0xe
    8000218e:	66650513          	addi	a0,a0,1638 # 800107f0 <tickslock>
    80002192:	287030ef          	jal	80005c18 <release>
  return 0;
    80002196:	4501                	li	a0,0
}
    80002198:	70e2                	ld	ra,56(sp)
    8000219a:	7442                	ld	s0,48(sp)
    8000219c:	7902                	ld	s2,32(sp)
    8000219e:	6121                	addi	sp,sp,64
    800021a0:	8082                	ret
    n = 0;
    800021a2:	fc042623          	sw	zero,-52(s0)
    800021a6:	bf49                	j	80002138 <sys_sleep+0x1c>
      release(&tickslock);
    800021a8:	0000e517          	auipc	a0,0xe
    800021ac:	64850513          	addi	a0,a0,1608 # 800107f0 <tickslock>
    800021b0:	269030ef          	jal	80005c18 <release>
      return -1;
    800021b4:	557d                	li	a0,-1
    800021b6:	74a2                	ld	s1,40(sp)
    800021b8:	69e2                	ld	s3,24(sp)
    800021ba:	bff9                	j	80002198 <sys_sleep+0x7c>

00000000800021bc <sys_kill>:

uint64
sys_kill(void)
{
    800021bc:	1101                	addi	sp,sp,-32
    800021be:	ec06                	sd	ra,24(sp)
    800021c0:	e822                	sd	s0,16(sp)
    800021c2:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800021c4:	fec40593          	addi	a1,s0,-20
    800021c8:	4501                	li	a0,0
    800021ca:	b0fff0ef          	jal	80001cd8 <argint>
  return kill(pid);
    800021ce:	fec42503          	lw	a0,-20(s0)
    800021d2:	b0cff0ef          	jal	800014de <kill>
}
    800021d6:	60e2                	ld	ra,24(sp)
    800021d8:	6442                	ld	s0,16(sp)
    800021da:	6105                	addi	sp,sp,32
    800021dc:	8082                	ret

00000000800021de <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021de:	1101                	addi	sp,sp,-32
    800021e0:	ec06                	sd	ra,24(sp)
    800021e2:	e822                	sd	s0,16(sp)
    800021e4:	e426                	sd	s1,8(sp)
    800021e6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021e8:	0000e517          	auipc	a0,0xe
    800021ec:	60850513          	addi	a0,a0,1544 # 800107f0 <tickslock>
    800021f0:	191030ef          	jal	80005b80 <acquire>
  xticks = ticks;
    800021f4:	00008497          	auipc	s1,0x8
    800021f8:	5944a483          	lw	s1,1428(s1) # 8000a788 <ticks>
  release(&tickslock);
    800021fc:	0000e517          	auipc	a0,0xe
    80002200:	5f450513          	addi	a0,a0,1524 # 800107f0 <tickslock>
    80002204:	215030ef          	jal	80005c18 <release>
  return xticks;
}
    80002208:	02049513          	slli	a0,s1,0x20
    8000220c:	9101                	srli	a0,a0,0x20
    8000220e:	60e2                	ld	ra,24(sp)
    80002210:	6442                	ld	s0,16(sp)
    80002212:	64a2                	ld	s1,8(sp)
    80002214:	6105                	addi	sp,sp,32
    80002216:	8082                	ret

0000000080002218 <sys_trace>:

/////////////////////////////////////////////////////////////

uint64
sys_trace(void)
{
    80002218:	1101                	addi	sp,sp,-32
    8000221a:	ec06                	sd	ra,24(sp)
    8000221c:	e822                	sd	s0,16(sp)
    8000221e:	1000                	addi	s0,sp,32
  uint32 mask;  //  unsigned int
  argint(0, (int*)&mask);  // Cast to int* for argint
    80002220:	fec40593          	addi	a1,s0,-20
    80002224:	4501                	li	a0,0
    80002226:	ab3ff0ef          	jal	80001cd8 <argint>
  struct proc *p = myproc();
    8000222a:	b2dfe0ef          	jal	80000d56 <myproc>
  p->trace_mask = mask;
    8000222e:	fec42783          	lw	a5,-20(s0)
    80002232:	16f52423          	sw	a5,360(a0)
  return 0;
}
    80002236:	4501                	li	a0,0
    80002238:	60e2                	ld	ra,24(sp)
    8000223a:	6442                	ld	s0,16(sp)
    8000223c:	6105                	addi	sp,sp,32
    8000223e:	8082                	ret

0000000080002240 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002240:	7179                	addi	sp,sp,-48
    80002242:	f406                	sd	ra,40(sp)
    80002244:	f022                	sd	s0,32(sp)
    80002246:	ec26                	sd	s1,24(sp)
    80002248:	e84a                	sd	s2,16(sp)
    8000224a:	e44e                	sd	s3,8(sp)
    8000224c:	e052                	sd	s4,0(sp)
    8000224e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002250:	00005597          	auipc	a1,0x5
    80002254:	2f058593          	addi	a1,a1,752 # 80007540 <etext+0x540>
    80002258:	0000e517          	auipc	a0,0xe
    8000225c:	62050513          	addi	a0,a0,1568 # 80010878 <bcache>
    80002260:	0a1030ef          	jal	80005b00 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002264:	00016797          	auipc	a5,0x16
    80002268:	61478793          	addi	a5,a5,1556 # 80018878 <bcache+0x8000>
    8000226c:	00017717          	auipc	a4,0x17
    80002270:	87470713          	addi	a4,a4,-1932 # 80018ae0 <bcache+0x8268>
    80002274:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002278:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000227c:	0000e497          	auipc	s1,0xe
    80002280:	61448493          	addi	s1,s1,1556 # 80010890 <bcache+0x18>
    b->next = bcache.head.next;
    80002284:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002286:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002288:	00005a17          	auipc	s4,0x5
    8000228c:	2c0a0a13          	addi	s4,s4,704 # 80007548 <etext+0x548>
    b->next = bcache.head.next;
    80002290:	2b893783          	ld	a5,696(s2)
    80002294:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002296:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000229a:	85d2                	mv	a1,s4
    8000229c:	01048513          	addi	a0,s1,16
    800022a0:	248010ef          	jal	800034e8 <initsleeplock>
    bcache.head.next->prev = b;
    800022a4:	2b893783          	ld	a5,696(s2)
    800022a8:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022aa:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022ae:	45848493          	addi	s1,s1,1112
    800022b2:	fd349fe3          	bne	s1,s3,80002290 <binit+0x50>
  }
}
    800022b6:	70a2                	ld	ra,40(sp)
    800022b8:	7402                	ld	s0,32(sp)
    800022ba:	64e2                	ld	s1,24(sp)
    800022bc:	6942                	ld	s2,16(sp)
    800022be:	69a2                	ld	s3,8(sp)
    800022c0:	6a02                	ld	s4,0(sp)
    800022c2:	6145                	addi	sp,sp,48
    800022c4:	8082                	ret

00000000800022c6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022c6:	7179                	addi	sp,sp,-48
    800022c8:	f406                	sd	ra,40(sp)
    800022ca:	f022                	sd	s0,32(sp)
    800022cc:	ec26                	sd	s1,24(sp)
    800022ce:	e84a                	sd	s2,16(sp)
    800022d0:	e44e                	sd	s3,8(sp)
    800022d2:	1800                	addi	s0,sp,48
    800022d4:	892a                	mv	s2,a0
    800022d6:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022d8:	0000e517          	auipc	a0,0xe
    800022dc:	5a050513          	addi	a0,a0,1440 # 80010878 <bcache>
    800022e0:	0a1030ef          	jal	80005b80 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022e4:	00017497          	auipc	s1,0x17
    800022e8:	84c4b483          	ld	s1,-1972(s1) # 80018b30 <bcache+0x82b8>
    800022ec:	00016797          	auipc	a5,0x16
    800022f0:	7f478793          	addi	a5,a5,2036 # 80018ae0 <bcache+0x8268>
    800022f4:	02f48b63          	beq	s1,a5,8000232a <bread+0x64>
    800022f8:	873e                	mv	a4,a5
    800022fa:	a021                	j	80002302 <bread+0x3c>
    800022fc:	68a4                	ld	s1,80(s1)
    800022fe:	02e48663          	beq	s1,a4,8000232a <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002302:	449c                	lw	a5,8(s1)
    80002304:	ff279ce3          	bne	a5,s2,800022fc <bread+0x36>
    80002308:	44dc                	lw	a5,12(s1)
    8000230a:	ff3799e3          	bne	a5,s3,800022fc <bread+0x36>
      b->refcnt++;
    8000230e:	40bc                	lw	a5,64(s1)
    80002310:	2785                	addiw	a5,a5,1
    80002312:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002314:	0000e517          	auipc	a0,0xe
    80002318:	56450513          	addi	a0,a0,1380 # 80010878 <bcache>
    8000231c:	0fd030ef          	jal	80005c18 <release>
      acquiresleep(&b->lock);
    80002320:	01048513          	addi	a0,s1,16
    80002324:	1fa010ef          	jal	8000351e <acquiresleep>
      return b;
    80002328:	a889                	j	8000237a <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000232a:	00016497          	auipc	s1,0x16
    8000232e:	7fe4b483          	ld	s1,2046(s1) # 80018b28 <bcache+0x82b0>
    80002332:	00016797          	auipc	a5,0x16
    80002336:	7ae78793          	addi	a5,a5,1966 # 80018ae0 <bcache+0x8268>
    8000233a:	00f48863          	beq	s1,a5,8000234a <bread+0x84>
    8000233e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002340:	40bc                	lw	a5,64(s1)
    80002342:	cb91                	beqz	a5,80002356 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002344:	64a4                	ld	s1,72(s1)
    80002346:	fee49de3          	bne	s1,a4,80002340 <bread+0x7a>
  panic("bget: no buffers");
    8000234a:	00005517          	auipc	a0,0x5
    8000234e:	20650513          	addi	a0,a0,518 # 80007550 <etext+0x550>
    80002352:	500030ef          	jal	80005852 <panic>
      b->dev = dev;
    80002356:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000235a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000235e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002362:	4785                	li	a5,1
    80002364:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002366:	0000e517          	auipc	a0,0xe
    8000236a:	51250513          	addi	a0,a0,1298 # 80010878 <bcache>
    8000236e:	0ab030ef          	jal	80005c18 <release>
      acquiresleep(&b->lock);
    80002372:	01048513          	addi	a0,s1,16
    80002376:	1a8010ef          	jal	8000351e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000237a:	409c                	lw	a5,0(s1)
    8000237c:	cb89                	beqz	a5,8000238e <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000237e:	8526                	mv	a0,s1
    80002380:	70a2                	ld	ra,40(sp)
    80002382:	7402                	ld	s0,32(sp)
    80002384:	64e2                	ld	s1,24(sp)
    80002386:	6942                	ld	s2,16(sp)
    80002388:	69a2                	ld	s3,8(sp)
    8000238a:	6145                	addi	sp,sp,48
    8000238c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000238e:	4581                	li	a1,0
    80002390:	8526                	mv	a0,s1
    80002392:	28f020ef          	jal	80004e20 <virtio_disk_rw>
    b->valid = 1;
    80002396:	4785                	li	a5,1
    80002398:	c09c                	sw	a5,0(s1)
  return b;
    8000239a:	b7d5                	j	8000237e <bread+0xb8>

000000008000239c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000239c:	1101                	addi	sp,sp,-32
    8000239e:	ec06                	sd	ra,24(sp)
    800023a0:	e822                	sd	s0,16(sp)
    800023a2:	e426                	sd	s1,8(sp)
    800023a4:	1000                	addi	s0,sp,32
    800023a6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023a8:	0541                	addi	a0,a0,16
    800023aa:	1f2010ef          	jal	8000359c <holdingsleep>
    800023ae:	c911                	beqz	a0,800023c2 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023b0:	4585                	li	a1,1
    800023b2:	8526                	mv	a0,s1
    800023b4:	26d020ef          	jal	80004e20 <virtio_disk_rw>
}
    800023b8:	60e2                	ld	ra,24(sp)
    800023ba:	6442                	ld	s0,16(sp)
    800023bc:	64a2                	ld	s1,8(sp)
    800023be:	6105                	addi	sp,sp,32
    800023c0:	8082                	ret
    panic("bwrite");
    800023c2:	00005517          	auipc	a0,0x5
    800023c6:	1a650513          	addi	a0,a0,422 # 80007568 <etext+0x568>
    800023ca:	488030ef          	jal	80005852 <panic>

00000000800023ce <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800023ce:	1101                	addi	sp,sp,-32
    800023d0:	ec06                	sd	ra,24(sp)
    800023d2:	e822                	sd	s0,16(sp)
    800023d4:	e426                	sd	s1,8(sp)
    800023d6:	e04a                	sd	s2,0(sp)
    800023d8:	1000                	addi	s0,sp,32
    800023da:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023dc:	01050913          	addi	s2,a0,16
    800023e0:	854a                	mv	a0,s2
    800023e2:	1ba010ef          	jal	8000359c <holdingsleep>
    800023e6:	c135                	beqz	a0,8000244a <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    800023e8:	854a                	mv	a0,s2
    800023ea:	17a010ef          	jal	80003564 <releasesleep>

  acquire(&bcache.lock);
    800023ee:	0000e517          	auipc	a0,0xe
    800023f2:	48a50513          	addi	a0,a0,1162 # 80010878 <bcache>
    800023f6:	78a030ef          	jal	80005b80 <acquire>
  b->refcnt--;
    800023fa:	40bc                	lw	a5,64(s1)
    800023fc:	37fd                	addiw	a5,a5,-1
    800023fe:	0007871b          	sext.w	a4,a5
    80002402:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002404:	e71d                	bnez	a4,80002432 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002406:	68b8                	ld	a4,80(s1)
    80002408:	64bc                	ld	a5,72(s1)
    8000240a:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000240c:	68b8                	ld	a4,80(s1)
    8000240e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002410:	00016797          	auipc	a5,0x16
    80002414:	46878793          	addi	a5,a5,1128 # 80018878 <bcache+0x8000>
    80002418:	2b87b703          	ld	a4,696(a5)
    8000241c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000241e:	00016717          	auipc	a4,0x16
    80002422:	6c270713          	addi	a4,a4,1730 # 80018ae0 <bcache+0x8268>
    80002426:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002428:	2b87b703          	ld	a4,696(a5)
    8000242c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000242e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002432:	0000e517          	auipc	a0,0xe
    80002436:	44650513          	addi	a0,a0,1094 # 80010878 <bcache>
    8000243a:	7de030ef          	jal	80005c18 <release>
}
    8000243e:	60e2                	ld	ra,24(sp)
    80002440:	6442                	ld	s0,16(sp)
    80002442:	64a2                	ld	s1,8(sp)
    80002444:	6902                	ld	s2,0(sp)
    80002446:	6105                	addi	sp,sp,32
    80002448:	8082                	ret
    panic("brelse");
    8000244a:	00005517          	auipc	a0,0x5
    8000244e:	12650513          	addi	a0,a0,294 # 80007570 <etext+0x570>
    80002452:	400030ef          	jal	80005852 <panic>

0000000080002456 <bpin>:

void
bpin(struct buf *b) {
    80002456:	1101                	addi	sp,sp,-32
    80002458:	ec06                	sd	ra,24(sp)
    8000245a:	e822                	sd	s0,16(sp)
    8000245c:	e426                	sd	s1,8(sp)
    8000245e:	1000                	addi	s0,sp,32
    80002460:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002462:	0000e517          	auipc	a0,0xe
    80002466:	41650513          	addi	a0,a0,1046 # 80010878 <bcache>
    8000246a:	716030ef          	jal	80005b80 <acquire>
  b->refcnt++;
    8000246e:	40bc                	lw	a5,64(s1)
    80002470:	2785                	addiw	a5,a5,1
    80002472:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002474:	0000e517          	auipc	a0,0xe
    80002478:	40450513          	addi	a0,a0,1028 # 80010878 <bcache>
    8000247c:	79c030ef          	jal	80005c18 <release>
}
    80002480:	60e2                	ld	ra,24(sp)
    80002482:	6442                	ld	s0,16(sp)
    80002484:	64a2                	ld	s1,8(sp)
    80002486:	6105                	addi	sp,sp,32
    80002488:	8082                	ret

000000008000248a <bunpin>:

void
bunpin(struct buf *b) {
    8000248a:	1101                	addi	sp,sp,-32
    8000248c:	ec06                	sd	ra,24(sp)
    8000248e:	e822                	sd	s0,16(sp)
    80002490:	e426                	sd	s1,8(sp)
    80002492:	1000                	addi	s0,sp,32
    80002494:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002496:	0000e517          	auipc	a0,0xe
    8000249a:	3e250513          	addi	a0,a0,994 # 80010878 <bcache>
    8000249e:	6e2030ef          	jal	80005b80 <acquire>
  b->refcnt--;
    800024a2:	40bc                	lw	a5,64(s1)
    800024a4:	37fd                	addiw	a5,a5,-1
    800024a6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024a8:	0000e517          	auipc	a0,0xe
    800024ac:	3d050513          	addi	a0,a0,976 # 80010878 <bcache>
    800024b0:	768030ef          	jal	80005c18 <release>
}
    800024b4:	60e2                	ld	ra,24(sp)
    800024b6:	6442                	ld	s0,16(sp)
    800024b8:	64a2                	ld	s1,8(sp)
    800024ba:	6105                	addi	sp,sp,32
    800024bc:	8082                	ret

00000000800024be <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800024be:	1101                	addi	sp,sp,-32
    800024c0:	ec06                	sd	ra,24(sp)
    800024c2:	e822                	sd	s0,16(sp)
    800024c4:	e426                	sd	s1,8(sp)
    800024c6:	e04a                	sd	s2,0(sp)
    800024c8:	1000                	addi	s0,sp,32
    800024ca:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800024cc:	00d5d59b          	srliw	a1,a1,0xd
    800024d0:	00017797          	auipc	a5,0x17
    800024d4:	a847a783          	lw	a5,-1404(a5) # 80018f54 <sb+0x1c>
    800024d8:	9dbd                	addw	a1,a1,a5
    800024da:	dedff0ef          	jal	800022c6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800024de:	0074f713          	andi	a4,s1,7
    800024e2:	4785                	li	a5,1
    800024e4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800024e8:	14ce                	slli	s1,s1,0x33
    800024ea:	90d9                	srli	s1,s1,0x36
    800024ec:	00950733          	add	a4,a0,s1
    800024f0:	05874703          	lbu	a4,88(a4)
    800024f4:	00e7f6b3          	and	a3,a5,a4
    800024f8:	c29d                	beqz	a3,8000251e <bfree+0x60>
    800024fa:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800024fc:	94aa                	add	s1,s1,a0
    800024fe:	fff7c793          	not	a5,a5
    80002502:	8f7d                	and	a4,a4,a5
    80002504:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002508:	711000ef          	jal	80003418 <log_write>
  brelse(bp);
    8000250c:	854a                	mv	a0,s2
    8000250e:	ec1ff0ef          	jal	800023ce <brelse>
}
    80002512:	60e2                	ld	ra,24(sp)
    80002514:	6442                	ld	s0,16(sp)
    80002516:	64a2                	ld	s1,8(sp)
    80002518:	6902                	ld	s2,0(sp)
    8000251a:	6105                	addi	sp,sp,32
    8000251c:	8082                	ret
    panic("freeing free block");
    8000251e:	00005517          	auipc	a0,0x5
    80002522:	05a50513          	addi	a0,a0,90 # 80007578 <etext+0x578>
    80002526:	32c030ef          	jal	80005852 <panic>

000000008000252a <balloc>:
{
    8000252a:	711d                	addi	sp,sp,-96
    8000252c:	ec86                	sd	ra,88(sp)
    8000252e:	e8a2                	sd	s0,80(sp)
    80002530:	e4a6                	sd	s1,72(sp)
    80002532:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002534:	00017797          	auipc	a5,0x17
    80002538:	a087a783          	lw	a5,-1528(a5) # 80018f3c <sb+0x4>
    8000253c:	0e078f63          	beqz	a5,8000263a <balloc+0x110>
    80002540:	e0ca                	sd	s2,64(sp)
    80002542:	fc4e                	sd	s3,56(sp)
    80002544:	f852                	sd	s4,48(sp)
    80002546:	f456                	sd	s5,40(sp)
    80002548:	f05a                	sd	s6,32(sp)
    8000254a:	ec5e                	sd	s7,24(sp)
    8000254c:	e862                	sd	s8,16(sp)
    8000254e:	e466                	sd	s9,8(sp)
    80002550:	8baa                	mv	s7,a0
    80002552:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002554:	00017b17          	auipc	s6,0x17
    80002558:	9e4b0b13          	addi	s6,s6,-1564 # 80018f38 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000255c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000255e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002560:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002562:	6c89                	lui	s9,0x2
    80002564:	a0b5                	j	800025d0 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002566:	97ca                	add	a5,a5,s2
    80002568:	8e55                	or	a2,a2,a3
    8000256a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000256e:	854a                	mv	a0,s2
    80002570:	6a9000ef          	jal	80003418 <log_write>
        brelse(bp);
    80002574:	854a                	mv	a0,s2
    80002576:	e59ff0ef          	jal	800023ce <brelse>
  bp = bread(dev, bno);
    8000257a:	85a6                	mv	a1,s1
    8000257c:	855e                	mv	a0,s7
    8000257e:	d49ff0ef          	jal	800022c6 <bread>
    80002582:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002584:	40000613          	li	a2,1024
    80002588:	4581                	li	a1,0
    8000258a:	05850513          	addi	a0,a0,88
    8000258e:	ba7fd0ef          	jal	80000134 <memset>
  log_write(bp);
    80002592:	854a                	mv	a0,s2
    80002594:	685000ef          	jal	80003418 <log_write>
  brelse(bp);
    80002598:	854a                	mv	a0,s2
    8000259a:	e35ff0ef          	jal	800023ce <brelse>
}
    8000259e:	6906                	ld	s2,64(sp)
    800025a0:	79e2                	ld	s3,56(sp)
    800025a2:	7a42                	ld	s4,48(sp)
    800025a4:	7aa2                	ld	s5,40(sp)
    800025a6:	7b02                	ld	s6,32(sp)
    800025a8:	6be2                	ld	s7,24(sp)
    800025aa:	6c42                	ld	s8,16(sp)
    800025ac:	6ca2                	ld	s9,8(sp)
}
    800025ae:	8526                	mv	a0,s1
    800025b0:	60e6                	ld	ra,88(sp)
    800025b2:	6446                	ld	s0,80(sp)
    800025b4:	64a6                	ld	s1,72(sp)
    800025b6:	6125                	addi	sp,sp,96
    800025b8:	8082                	ret
    brelse(bp);
    800025ba:	854a                	mv	a0,s2
    800025bc:	e13ff0ef          	jal	800023ce <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800025c0:	015c87bb          	addw	a5,s9,s5
    800025c4:	00078a9b          	sext.w	s5,a5
    800025c8:	004b2703          	lw	a4,4(s6)
    800025cc:	04eaff63          	bgeu	s5,a4,8000262a <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800025d0:	41fad79b          	sraiw	a5,s5,0x1f
    800025d4:	0137d79b          	srliw	a5,a5,0x13
    800025d8:	015787bb          	addw	a5,a5,s5
    800025dc:	40d7d79b          	sraiw	a5,a5,0xd
    800025e0:	01cb2583          	lw	a1,28(s6)
    800025e4:	9dbd                	addw	a1,a1,a5
    800025e6:	855e                	mv	a0,s7
    800025e8:	cdfff0ef          	jal	800022c6 <bread>
    800025ec:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025ee:	004b2503          	lw	a0,4(s6)
    800025f2:	000a849b          	sext.w	s1,s5
    800025f6:	8762                	mv	a4,s8
    800025f8:	fca4f1e3          	bgeu	s1,a0,800025ba <balloc+0x90>
      m = 1 << (bi % 8);
    800025fc:	00777693          	andi	a3,a4,7
    80002600:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002604:	41f7579b          	sraiw	a5,a4,0x1f
    80002608:	01d7d79b          	srliw	a5,a5,0x1d
    8000260c:	9fb9                	addw	a5,a5,a4
    8000260e:	4037d79b          	sraiw	a5,a5,0x3
    80002612:	00f90633          	add	a2,s2,a5
    80002616:	05864603          	lbu	a2,88(a2)
    8000261a:	00c6f5b3          	and	a1,a3,a2
    8000261e:	d5a1                	beqz	a1,80002566 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002620:	2705                	addiw	a4,a4,1
    80002622:	2485                	addiw	s1,s1,1
    80002624:	fd471ae3          	bne	a4,s4,800025f8 <balloc+0xce>
    80002628:	bf49                	j	800025ba <balloc+0x90>
    8000262a:	6906                	ld	s2,64(sp)
    8000262c:	79e2                	ld	s3,56(sp)
    8000262e:	7a42                	ld	s4,48(sp)
    80002630:	7aa2                	ld	s5,40(sp)
    80002632:	7b02                	ld	s6,32(sp)
    80002634:	6be2                	ld	s7,24(sp)
    80002636:	6c42                	ld	s8,16(sp)
    80002638:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000263a:	00005517          	auipc	a0,0x5
    8000263e:	f5650513          	addi	a0,a0,-170 # 80007590 <etext+0x590>
    80002642:	73f020ef          	jal	80005580 <printf>
  return 0;
    80002646:	4481                	li	s1,0
    80002648:	b79d                	j	800025ae <balloc+0x84>

000000008000264a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000264a:	7179                	addi	sp,sp,-48
    8000264c:	f406                	sd	ra,40(sp)
    8000264e:	f022                	sd	s0,32(sp)
    80002650:	ec26                	sd	s1,24(sp)
    80002652:	e84a                	sd	s2,16(sp)
    80002654:	e44e                	sd	s3,8(sp)
    80002656:	1800                	addi	s0,sp,48
    80002658:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000265a:	47ad                	li	a5,11
    8000265c:	02b7e663          	bltu	a5,a1,80002688 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002660:	02059793          	slli	a5,a1,0x20
    80002664:	01e7d593          	srli	a1,a5,0x1e
    80002668:	00b504b3          	add	s1,a0,a1
    8000266c:	0504a903          	lw	s2,80(s1)
    80002670:	06091a63          	bnez	s2,800026e4 <bmap+0x9a>
      addr = balloc(ip->dev);
    80002674:	4108                	lw	a0,0(a0)
    80002676:	eb5ff0ef          	jal	8000252a <balloc>
    8000267a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000267e:	06090363          	beqz	s2,800026e4 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002682:	0524a823          	sw	s2,80(s1)
    80002686:	a8b9                	j	800026e4 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002688:	ff45849b          	addiw	s1,a1,-12
    8000268c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002690:	0ff00793          	li	a5,255
    80002694:	06e7ee63          	bltu	a5,a4,80002710 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002698:	08052903          	lw	s2,128(a0)
    8000269c:	00091d63          	bnez	s2,800026b6 <bmap+0x6c>
      addr = balloc(ip->dev);
    800026a0:	4108                	lw	a0,0(a0)
    800026a2:	e89ff0ef          	jal	8000252a <balloc>
    800026a6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800026aa:	02090d63          	beqz	s2,800026e4 <bmap+0x9a>
    800026ae:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800026b0:	0929a023          	sw	s2,128(s3)
    800026b4:	a011                	j	800026b8 <bmap+0x6e>
    800026b6:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800026b8:	85ca                	mv	a1,s2
    800026ba:	0009a503          	lw	a0,0(s3)
    800026be:	c09ff0ef          	jal	800022c6 <bread>
    800026c2:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800026c4:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800026c8:	02049713          	slli	a4,s1,0x20
    800026cc:	01e75593          	srli	a1,a4,0x1e
    800026d0:	00b784b3          	add	s1,a5,a1
    800026d4:	0004a903          	lw	s2,0(s1)
    800026d8:	00090e63          	beqz	s2,800026f4 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800026dc:	8552                	mv	a0,s4
    800026de:	cf1ff0ef          	jal	800023ce <brelse>
    return addr;
    800026e2:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800026e4:	854a                	mv	a0,s2
    800026e6:	70a2                	ld	ra,40(sp)
    800026e8:	7402                	ld	s0,32(sp)
    800026ea:	64e2                	ld	s1,24(sp)
    800026ec:	6942                	ld	s2,16(sp)
    800026ee:	69a2                	ld	s3,8(sp)
    800026f0:	6145                	addi	sp,sp,48
    800026f2:	8082                	ret
      addr = balloc(ip->dev);
    800026f4:	0009a503          	lw	a0,0(s3)
    800026f8:	e33ff0ef          	jal	8000252a <balloc>
    800026fc:	0005091b          	sext.w	s2,a0
      if(addr){
    80002700:	fc090ee3          	beqz	s2,800026dc <bmap+0x92>
        a[bn] = addr;
    80002704:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002708:	8552                	mv	a0,s4
    8000270a:	50f000ef          	jal	80003418 <log_write>
    8000270e:	b7f9                	j	800026dc <bmap+0x92>
    80002710:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002712:	00005517          	auipc	a0,0x5
    80002716:	e9650513          	addi	a0,a0,-362 # 800075a8 <etext+0x5a8>
    8000271a:	138030ef          	jal	80005852 <panic>

000000008000271e <iget>:
{
    8000271e:	7179                	addi	sp,sp,-48
    80002720:	f406                	sd	ra,40(sp)
    80002722:	f022                	sd	s0,32(sp)
    80002724:	ec26                	sd	s1,24(sp)
    80002726:	e84a                	sd	s2,16(sp)
    80002728:	e44e                	sd	s3,8(sp)
    8000272a:	e052                	sd	s4,0(sp)
    8000272c:	1800                	addi	s0,sp,48
    8000272e:	89aa                	mv	s3,a0
    80002730:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002732:	00017517          	auipc	a0,0x17
    80002736:	82650513          	addi	a0,a0,-2010 # 80018f58 <itable>
    8000273a:	446030ef          	jal	80005b80 <acquire>
  empty = 0;
    8000273e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002740:	00017497          	auipc	s1,0x17
    80002744:	83048493          	addi	s1,s1,-2000 # 80018f70 <itable+0x18>
    80002748:	00018697          	auipc	a3,0x18
    8000274c:	2b868693          	addi	a3,a3,696 # 8001aa00 <log>
    80002750:	a039                	j	8000275e <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002752:	02090963          	beqz	s2,80002784 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002756:	08848493          	addi	s1,s1,136
    8000275a:	02d48863          	beq	s1,a3,8000278a <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000275e:	449c                	lw	a5,8(s1)
    80002760:	fef059e3          	blez	a5,80002752 <iget+0x34>
    80002764:	4098                	lw	a4,0(s1)
    80002766:	ff3716e3          	bne	a4,s3,80002752 <iget+0x34>
    8000276a:	40d8                	lw	a4,4(s1)
    8000276c:	ff4713e3          	bne	a4,s4,80002752 <iget+0x34>
      ip->ref++;
    80002770:	2785                	addiw	a5,a5,1
    80002772:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002774:	00016517          	auipc	a0,0x16
    80002778:	7e450513          	addi	a0,a0,2020 # 80018f58 <itable>
    8000277c:	49c030ef          	jal	80005c18 <release>
      return ip;
    80002780:	8926                	mv	s2,s1
    80002782:	a02d                	j	800027ac <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002784:	fbe9                	bnez	a5,80002756 <iget+0x38>
      empty = ip;
    80002786:	8926                	mv	s2,s1
    80002788:	b7f9                	j	80002756 <iget+0x38>
  if(empty == 0)
    8000278a:	02090a63          	beqz	s2,800027be <iget+0xa0>
  ip->dev = dev;
    8000278e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002792:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002796:	4785                	li	a5,1
    80002798:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000279c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800027a0:	00016517          	auipc	a0,0x16
    800027a4:	7b850513          	addi	a0,a0,1976 # 80018f58 <itable>
    800027a8:	470030ef          	jal	80005c18 <release>
}
    800027ac:	854a                	mv	a0,s2
    800027ae:	70a2                	ld	ra,40(sp)
    800027b0:	7402                	ld	s0,32(sp)
    800027b2:	64e2                	ld	s1,24(sp)
    800027b4:	6942                	ld	s2,16(sp)
    800027b6:	69a2                	ld	s3,8(sp)
    800027b8:	6a02                	ld	s4,0(sp)
    800027ba:	6145                	addi	sp,sp,48
    800027bc:	8082                	ret
    panic("iget: no inodes");
    800027be:	00005517          	auipc	a0,0x5
    800027c2:	e0250513          	addi	a0,a0,-510 # 800075c0 <etext+0x5c0>
    800027c6:	08c030ef          	jal	80005852 <panic>

00000000800027ca <fsinit>:
fsinit(int dev) {
    800027ca:	7179                	addi	sp,sp,-48
    800027cc:	f406                	sd	ra,40(sp)
    800027ce:	f022                	sd	s0,32(sp)
    800027d0:	ec26                	sd	s1,24(sp)
    800027d2:	e84a                	sd	s2,16(sp)
    800027d4:	e44e                	sd	s3,8(sp)
    800027d6:	1800                	addi	s0,sp,48
    800027d8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800027da:	4585                	li	a1,1
    800027dc:	aebff0ef          	jal	800022c6 <bread>
    800027e0:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800027e2:	00016997          	auipc	s3,0x16
    800027e6:	75698993          	addi	s3,s3,1878 # 80018f38 <sb>
    800027ea:	02000613          	li	a2,32
    800027ee:	05850593          	addi	a1,a0,88
    800027f2:	854e                	mv	a0,s3
    800027f4:	99dfd0ef          	jal	80000190 <memmove>
  brelse(bp);
    800027f8:	8526                	mv	a0,s1
    800027fa:	bd5ff0ef          	jal	800023ce <brelse>
  if(sb.magic != FSMAGIC)
    800027fe:	0009a703          	lw	a4,0(s3)
    80002802:	102037b7          	lui	a5,0x10203
    80002806:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000280a:	02f71063          	bne	a4,a5,8000282a <fsinit+0x60>
  initlog(dev, &sb);
    8000280e:	00016597          	auipc	a1,0x16
    80002812:	72a58593          	addi	a1,a1,1834 # 80018f38 <sb>
    80002816:	854a                	mv	a0,s2
    80002818:	1f9000ef          	jal	80003210 <initlog>
}
    8000281c:	70a2                	ld	ra,40(sp)
    8000281e:	7402                	ld	s0,32(sp)
    80002820:	64e2                	ld	s1,24(sp)
    80002822:	6942                	ld	s2,16(sp)
    80002824:	69a2                	ld	s3,8(sp)
    80002826:	6145                	addi	sp,sp,48
    80002828:	8082                	ret
    panic("invalid file system");
    8000282a:	00005517          	auipc	a0,0x5
    8000282e:	da650513          	addi	a0,a0,-602 # 800075d0 <etext+0x5d0>
    80002832:	020030ef          	jal	80005852 <panic>

0000000080002836 <iinit>:
{
    80002836:	7179                	addi	sp,sp,-48
    80002838:	f406                	sd	ra,40(sp)
    8000283a:	f022                	sd	s0,32(sp)
    8000283c:	ec26                	sd	s1,24(sp)
    8000283e:	e84a                	sd	s2,16(sp)
    80002840:	e44e                	sd	s3,8(sp)
    80002842:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002844:	00005597          	auipc	a1,0x5
    80002848:	da458593          	addi	a1,a1,-604 # 800075e8 <etext+0x5e8>
    8000284c:	00016517          	auipc	a0,0x16
    80002850:	70c50513          	addi	a0,a0,1804 # 80018f58 <itable>
    80002854:	2ac030ef          	jal	80005b00 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002858:	00016497          	auipc	s1,0x16
    8000285c:	72848493          	addi	s1,s1,1832 # 80018f80 <itable+0x28>
    80002860:	00018997          	auipc	s3,0x18
    80002864:	1b098993          	addi	s3,s3,432 # 8001aa10 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002868:	00005917          	auipc	s2,0x5
    8000286c:	d8890913          	addi	s2,s2,-632 # 800075f0 <etext+0x5f0>
    80002870:	85ca                	mv	a1,s2
    80002872:	8526                	mv	a0,s1
    80002874:	475000ef          	jal	800034e8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002878:	08848493          	addi	s1,s1,136
    8000287c:	ff349ae3          	bne	s1,s3,80002870 <iinit+0x3a>
}
    80002880:	70a2                	ld	ra,40(sp)
    80002882:	7402                	ld	s0,32(sp)
    80002884:	64e2                	ld	s1,24(sp)
    80002886:	6942                	ld	s2,16(sp)
    80002888:	69a2                	ld	s3,8(sp)
    8000288a:	6145                	addi	sp,sp,48
    8000288c:	8082                	ret

000000008000288e <ialloc>:
{
    8000288e:	7139                	addi	sp,sp,-64
    80002890:	fc06                	sd	ra,56(sp)
    80002892:	f822                	sd	s0,48(sp)
    80002894:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002896:	00016717          	auipc	a4,0x16
    8000289a:	6ae72703          	lw	a4,1710(a4) # 80018f44 <sb+0xc>
    8000289e:	4785                	li	a5,1
    800028a0:	06e7f063          	bgeu	a5,a4,80002900 <ialloc+0x72>
    800028a4:	f426                	sd	s1,40(sp)
    800028a6:	f04a                	sd	s2,32(sp)
    800028a8:	ec4e                	sd	s3,24(sp)
    800028aa:	e852                	sd	s4,16(sp)
    800028ac:	e456                	sd	s5,8(sp)
    800028ae:	e05a                	sd	s6,0(sp)
    800028b0:	8aaa                	mv	s5,a0
    800028b2:	8b2e                	mv	s6,a1
    800028b4:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800028b6:	00016a17          	auipc	s4,0x16
    800028ba:	682a0a13          	addi	s4,s4,1666 # 80018f38 <sb>
    800028be:	00495593          	srli	a1,s2,0x4
    800028c2:	018a2783          	lw	a5,24(s4)
    800028c6:	9dbd                	addw	a1,a1,a5
    800028c8:	8556                	mv	a0,s5
    800028ca:	9fdff0ef          	jal	800022c6 <bread>
    800028ce:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800028d0:	05850993          	addi	s3,a0,88
    800028d4:	00f97793          	andi	a5,s2,15
    800028d8:	079a                	slli	a5,a5,0x6
    800028da:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800028dc:	00099783          	lh	a5,0(s3)
    800028e0:	cb9d                	beqz	a5,80002916 <ialloc+0x88>
    brelse(bp);
    800028e2:	aedff0ef          	jal	800023ce <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800028e6:	0905                	addi	s2,s2,1
    800028e8:	00ca2703          	lw	a4,12(s4)
    800028ec:	0009079b          	sext.w	a5,s2
    800028f0:	fce7e7e3          	bltu	a5,a4,800028be <ialloc+0x30>
    800028f4:	74a2                	ld	s1,40(sp)
    800028f6:	7902                	ld	s2,32(sp)
    800028f8:	69e2                	ld	s3,24(sp)
    800028fa:	6a42                	ld	s4,16(sp)
    800028fc:	6aa2                	ld	s5,8(sp)
    800028fe:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002900:	00005517          	auipc	a0,0x5
    80002904:	cf850513          	addi	a0,a0,-776 # 800075f8 <etext+0x5f8>
    80002908:	479020ef          	jal	80005580 <printf>
  return 0;
    8000290c:	4501                	li	a0,0
}
    8000290e:	70e2                	ld	ra,56(sp)
    80002910:	7442                	ld	s0,48(sp)
    80002912:	6121                	addi	sp,sp,64
    80002914:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002916:	04000613          	li	a2,64
    8000291a:	4581                	li	a1,0
    8000291c:	854e                	mv	a0,s3
    8000291e:	817fd0ef          	jal	80000134 <memset>
      dip->type = type;
    80002922:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002926:	8526                	mv	a0,s1
    80002928:	2f1000ef          	jal	80003418 <log_write>
      brelse(bp);
    8000292c:	8526                	mv	a0,s1
    8000292e:	aa1ff0ef          	jal	800023ce <brelse>
      return iget(dev, inum);
    80002932:	0009059b          	sext.w	a1,s2
    80002936:	8556                	mv	a0,s5
    80002938:	de7ff0ef          	jal	8000271e <iget>
    8000293c:	74a2                	ld	s1,40(sp)
    8000293e:	7902                	ld	s2,32(sp)
    80002940:	69e2                	ld	s3,24(sp)
    80002942:	6a42                	ld	s4,16(sp)
    80002944:	6aa2                	ld	s5,8(sp)
    80002946:	6b02                	ld	s6,0(sp)
    80002948:	b7d9                	j	8000290e <ialloc+0x80>

000000008000294a <iupdate>:
{
    8000294a:	1101                	addi	sp,sp,-32
    8000294c:	ec06                	sd	ra,24(sp)
    8000294e:	e822                	sd	s0,16(sp)
    80002950:	e426                	sd	s1,8(sp)
    80002952:	e04a                	sd	s2,0(sp)
    80002954:	1000                	addi	s0,sp,32
    80002956:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002958:	415c                	lw	a5,4(a0)
    8000295a:	0047d79b          	srliw	a5,a5,0x4
    8000295e:	00016597          	auipc	a1,0x16
    80002962:	5f25a583          	lw	a1,1522(a1) # 80018f50 <sb+0x18>
    80002966:	9dbd                	addw	a1,a1,a5
    80002968:	4108                	lw	a0,0(a0)
    8000296a:	95dff0ef          	jal	800022c6 <bread>
    8000296e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002970:	05850793          	addi	a5,a0,88
    80002974:	40d8                	lw	a4,4(s1)
    80002976:	8b3d                	andi	a4,a4,15
    80002978:	071a                	slli	a4,a4,0x6
    8000297a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000297c:	04449703          	lh	a4,68(s1)
    80002980:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002984:	04649703          	lh	a4,70(s1)
    80002988:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000298c:	04849703          	lh	a4,72(s1)
    80002990:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002994:	04a49703          	lh	a4,74(s1)
    80002998:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000299c:	44f8                	lw	a4,76(s1)
    8000299e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800029a0:	03400613          	li	a2,52
    800029a4:	05048593          	addi	a1,s1,80
    800029a8:	00c78513          	addi	a0,a5,12
    800029ac:	fe4fd0ef          	jal	80000190 <memmove>
  log_write(bp);
    800029b0:	854a                	mv	a0,s2
    800029b2:	267000ef          	jal	80003418 <log_write>
  brelse(bp);
    800029b6:	854a                	mv	a0,s2
    800029b8:	a17ff0ef          	jal	800023ce <brelse>
}
    800029bc:	60e2                	ld	ra,24(sp)
    800029be:	6442                	ld	s0,16(sp)
    800029c0:	64a2                	ld	s1,8(sp)
    800029c2:	6902                	ld	s2,0(sp)
    800029c4:	6105                	addi	sp,sp,32
    800029c6:	8082                	ret

00000000800029c8 <idup>:
{
    800029c8:	1101                	addi	sp,sp,-32
    800029ca:	ec06                	sd	ra,24(sp)
    800029cc:	e822                	sd	s0,16(sp)
    800029ce:	e426                	sd	s1,8(sp)
    800029d0:	1000                	addi	s0,sp,32
    800029d2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800029d4:	00016517          	auipc	a0,0x16
    800029d8:	58450513          	addi	a0,a0,1412 # 80018f58 <itable>
    800029dc:	1a4030ef          	jal	80005b80 <acquire>
  ip->ref++;
    800029e0:	449c                	lw	a5,8(s1)
    800029e2:	2785                	addiw	a5,a5,1
    800029e4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800029e6:	00016517          	auipc	a0,0x16
    800029ea:	57250513          	addi	a0,a0,1394 # 80018f58 <itable>
    800029ee:	22a030ef          	jal	80005c18 <release>
}
    800029f2:	8526                	mv	a0,s1
    800029f4:	60e2                	ld	ra,24(sp)
    800029f6:	6442                	ld	s0,16(sp)
    800029f8:	64a2                	ld	s1,8(sp)
    800029fa:	6105                	addi	sp,sp,32
    800029fc:	8082                	ret

00000000800029fe <ilock>:
{
    800029fe:	1101                	addi	sp,sp,-32
    80002a00:	ec06                	sd	ra,24(sp)
    80002a02:	e822                	sd	s0,16(sp)
    80002a04:	e426                	sd	s1,8(sp)
    80002a06:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002a08:	cd19                	beqz	a0,80002a26 <ilock+0x28>
    80002a0a:	84aa                	mv	s1,a0
    80002a0c:	451c                	lw	a5,8(a0)
    80002a0e:	00f05c63          	blez	a5,80002a26 <ilock+0x28>
  acquiresleep(&ip->lock);
    80002a12:	0541                	addi	a0,a0,16
    80002a14:	30b000ef          	jal	8000351e <acquiresleep>
  if(ip->valid == 0){
    80002a18:	40bc                	lw	a5,64(s1)
    80002a1a:	cf89                	beqz	a5,80002a34 <ilock+0x36>
}
    80002a1c:	60e2                	ld	ra,24(sp)
    80002a1e:	6442                	ld	s0,16(sp)
    80002a20:	64a2                	ld	s1,8(sp)
    80002a22:	6105                	addi	sp,sp,32
    80002a24:	8082                	ret
    80002a26:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002a28:	00005517          	auipc	a0,0x5
    80002a2c:	be850513          	addi	a0,a0,-1048 # 80007610 <etext+0x610>
    80002a30:	623020ef          	jal	80005852 <panic>
    80002a34:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a36:	40dc                	lw	a5,4(s1)
    80002a38:	0047d79b          	srliw	a5,a5,0x4
    80002a3c:	00016597          	auipc	a1,0x16
    80002a40:	5145a583          	lw	a1,1300(a1) # 80018f50 <sb+0x18>
    80002a44:	9dbd                	addw	a1,a1,a5
    80002a46:	4088                	lw	a0,0(s1)
    80002a48:	87fff0ef          	jal	800022c6 <bread>
    80002a4c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a4e:	05850593          	addi	a1,a0,88
    80002a52:	40dc                	lw	a5,4(s1)
    80002a54:	8bbd                	andi	a5,a5,15
    80002a56:	079a                	slli	a5,a5,0x6
    80002a58:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002a5a:	00059783          	lh	a5,0(a1)
    80002a5e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002a62:	00259783          	lh	a5,2(a1)
    80002a66:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002a6a:	00459783          	lh	a5,4(a1)
    80002a6e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002a72:	00659783          	lh	a5,6(a1)
    80002a76:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002a7a:	459c                	lw	a5,8(a1)
    80002a7c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002a7e:	03400613          	li	a2,52
    80002a82:	05b1                	addi	a1,a1,12
    80002a84:	05048513          	addi	a0,s1,80
    80002a88:	f08fd0ef          	jal	80000190 <memmove>
    brelse(bp);
    80002a8c:	854a                	mv	a0,s2
    80002a8e:	941ff0ef          	jal	800023ce <brelse>
    ip->valid = 1;
    80002a92:	4785                	li	a5,1
    80002a94:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002a96:	04449783          	lh	a5,68(s1)
    80002a9a:	c399                	beqz	a5,80002aa0 <ilock+0xa2>
    80002a9c:	6902                	ld	s2,0(sp)
    80002a9e:	bfbd                	j	80002a1c <ilock+0x1e>
      panic("ilock: no type");
    80002aa0:	00005517          	auipc	a0,0x5
    80002aa4:	b7850513          	addi	a0,a0,-1160 # 80007618 <etext+0x618>
    80002aa8:	5ab020ef          	jal	80005852 <panic>

0000000080002aac <iunlock>:
{
    80002aac:	1101                	addi	sp,sp,-32
    80002aae:	ec06                	sd	ra,24(sp)
    80002ab0:	e822                	sd	s0,16(sp)
    80002ab2:	e426                	sd	s1,8(sp)
    80002ab4:	e04a                	sd	s2,0(sp)
    80002ab6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ab8:	c505                	beqz	a0,80002ae0 <iunlock+0x34>
    80002aba:	84aa                	mv	s1,a0
    80002abc:	01050913          	addi	s2,a0,16
    80002ac0:	854a                	mv	a0,s2
    80002ac2:	2db000ef          	jal	8000359c <holdingsleep>
    80002ac6:	cd09                	beqz	a0,80002ae0 <iunlock+0x34>
    80002ac8:	449c                	lw	a5,8(s1)
    80002aca:	00f05b63          	blez	a5,80002ae0 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002ace:	854a                	mv	a0,s2
    80002ad0:	295000ef          	jal	80003564 <releasesleep>
}
    80002ad4:	60e2                	ld	ra,24(sp)
    80002ad6:	6442                	ld	s0,16(sp)
    80002ad8:	64a2                	ld	s1,8(sp)
    80002ada:	6902                	ld	s2,0(sp)
    80002adc:	6105                	addi	sp,sp,32
    80002ade:	8082                	ret
    panic("iunlock");
    80002ae0:	00005517          	auipc	a0,0x5
    80002ae4:	b4850513          	addi	a0,a0,-1208 # 80007628 <etext+0x628>
    80002ae8:	56b020ef          	jal	80005852 <panic>

0000000080002aec <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002aec:	7179                	addi	sp,sp,-48
    80002aee:	f406                	sd	ra,40(sp)
    80002af0:	f022                	sd	s0,32(sp)
    80002af2:	ec26                	sd	s1,24(sp)
    80002af4:	e84a                	sd	s2,16(sp)
    80002af6:	e44e                	sd	s3,8(sp)
    80002af8:	1800                	addi	s0,sp,48
    80002afa:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002afc:	05050493          	addi	s1,a0,80
    80002b00:	08050913          	addi	s2,a0,128
    80002b04:	a021                	j	80002b0c <itrunc+0x20>
    80002b06:	0491                	addi	s1,s1,4
    80002b08:	01248b63          	beq	s1,s2,80002b1e <itrunc+0x32>
    if(ip->addrs[i]){
    80002b0c:	408c                	lw	a1,0(s1)
    80002b0e:	dde5                	beqz	a1,80002b06 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002b10:	0009a503          	lw	a0,0(s3)
    80002b14:	9abff0ef          	jal	800024be <bfree>
      ip->addrs[i] = 0;
    80002b18:	0004a023          	sw	zero,0(s1)
    80002b1c:	b7ed                	j	80002b06 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002b1e:	0809a583          	lw	a1,128(s3)
    80002b22:	ed89                	bnez	a1,80002b3c <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002b24:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002b28:	854e                	mv	a0,s3
    80002b2a:	e21ff0ef          	jal	8000294a <iupdate>
}
    80002b2e:	70a2                	ld	ra,40(sp)
    80002b30:	7402                	ld	s0,32(sp)
    80002b32:	64e2                	ld	s1,24(sp)
    80002b34:	6942                	ld	s2,16(sp)
    80002b36:	69a2                	ld	s3,8(sp)
    80002b38:	6145                	addi	sp,sp,48
    80002b3a:	8082                	ret
    80002b3c:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002b3e:	0009a503          	lw	a0,0(s3)
    80002b42:	f84ff0ef          	jal	800022c6 <bread>
    80002b46:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002b48:	05850493          	addi	s1,a0,88
    80002b4c:	45850913          	addi	s2,a0,1112
    80002b50:	a021                	j	80002b58 <itrunc+0x6c>
    80002b52:	0491                	addi	s1,s1,4
    80002b54:	01248963          	beq	s1,s2,80002b66 <itrunc+0x7a>
      if(a[j])
    80002b58:	408c                	lw	a1,0(s1)
    80002b5a:	dde5                	beqz	a1,80002b52 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002b5c:	0009a503          	lw	a0,0(s3)
    80002b60:	95fff0ef          	jal	800024be <bfree>
    80002b64:	b7fd                	j	80002b52 <itrunc+0x66>
    brelse(bp);
    80002b66:	8552                	mv	a0,s4
    80002b68:	867ff0ef          	jal	800023ce <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002b6c:	0809a583          	lw	a1,128(s3)
    80002b70:	0009a503          	lw	a0,0(s3)
    80002b74:	94bff0ef          	jal	800024be <bfree>
    ip->addrs[NDIRECT] = 0;
    80002b78:	0809a023          	sw	zero,128(s3)
    80002b7c:	6a02                	ld	s4,0(sp)
    80002b7e:	b75d                	j	80002b24 <itrunc+0x38>

0000000080002b80 <iput>:
{
    80002b80:	1101                	addi	sp,sp,-32
    80002b82:	ec06                	sd	ra,24(sp)
    80002b84:	e822                	sd	s0,16(sp)
    80002b86:	e426                	sd	s1,8(sp)
    80002b88:	1000                	addi	s0,sp,32
    80002b8a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b8c:	00016517          	auipc	a0,0x16
    80002b90:	3cc50513          	addi	a0,a0,972 # 80018f58 <itable>
    80002b94:	7ed020ef          	jal	80005b80 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002b98:	4498                	lw	a4,8(s1)
    80002b9a:	4785                	li	a5,1
    80002b9c:	02f70063          	beq	a4,a5,80002bbc <iput+0x3c>
  ip->ref--;
    80002ba0:	449c                	lw	a5,8(s1)
    80002ba2:	37fd                	addiw	a5,a5,-1
    80002ba4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ba6:	00016517          	auipc	a0,0x16
    80002baa:	3b250513          	addi	a0,a0,946 # 80018f58 <itable>
    80002bae:	06a030ef          	jal	80005c18 <release>
}
    80002bb2:	60e2                	ld	ra,24(sp)
    80002bb4:	6442                	ld	s0,16(sp)
    80002bb6:	64a2                	ld	s1,8(sp)
    80002bb8:	6105                	addi	sp,sp,32
    80002bba:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002bbc:	40bc                	lw	a5,64(s1)
    80002bbe:	d3ed                	beqz	a5,80002ba0 <iput+0x20>
    80002bc0:	04a49783          	lh	a5,74(s1)
    80002bc4:	fff1                	bnez	a5,80002ba0 <iput+0x20>
    80002bc6:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002bc8:	01048913          	addi	s2,s1,16
    80002bcc:	854a                	mv	a0,s2
    80002bce:	151000ef          	jal	8000351e <acquiresleep>
    release(&itable.lock);
    80002bd2:	00016517          	auipc	a0,0x16
    80002bd6:	38650513          	addi	a0,a0,902 # 80018f58 <itable>
    80002bda:	03e030ef          	jal	80005c18 <release>
    itrunc(ip);
    80002bde:	8526                	mv	a0,s1
    80002be0:	f0dff0ef          	jal	80002aec <itrunc>
    ip->type = 0;
    80002be4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002be8:	8526                	mv	a0,s1
    80002bea:	d61ff0ef          	jal	8000294a <iupdate>
    ip->valid = 0;
    80002bee:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002bf2:	854a                	mv	a0,s2
    80002bf4:	171000ef          	jal	80003564 <releasesleep>
    acquire(&itable.lock);
    80002bf8:	00016517          	auipc	a0,0x16
    80002bfc:	36050513          	addi	a0,a0,864 # 80018f58 <itable>
    80002c00:	781020ef          	jal	80005b80 <acquire>
    80002c04:	6902                	ld	s2,0(sp)
    80002c06:	bf69                	j	80002ba0 <iput+0x20>

0000000080002c08 <iunlockput>:
{
    80002c08:	1101                	addi	sp,sp,-32
    80002c0a:	ec06                	sd	ra,24(sp)
    80002c0c:	e822                	sd	s0,16(sp)
    80002c0e:	e426                	sd	s1,8(sp)
    80002c10:	1000                	addi	s0,sp,32
    80002c12:	84aa                	mv	s1,a0
  iunlock(ip);
    80002c14:	e99ff0ef          	jal	80002aac <iunlock>
  iput(ip);
    80002c18:	8526                	mv	a0,s1
    80002c1a:	f67ff0ef          	jal	80002b80 <iput>
}
    80002c1e:	60e2                	ld	ra,24(sp)
    80002c20:	6442                	ld	s0,16(sp)
    80002c22:	64a2                	ld	s1,8(sp)
    80002c24:	6105                	addi	sp,sp,32
    80002c26:	8082                	ret

0000000080002c28 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002c28:	1141                	addi	sp,sp,-16
    80002c2a:	e422                	sd	s0,8(sp)
    80002c2c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002c2e:	411c                	lw	a5,0(a0)
    80002c30:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002c32:	415c                	lw	a5,4(a0)
    80002c34:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002c36:	04451783          	lh	a5,68(a0)
    80002c3a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002c3e:	04a51783          	lh	a5,74(a0)
    80002c42:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002c46:	04c56783          	lwu	a5,76(a0)
    80002c4a:	e99c                	sd	a5,16(a1)
}
    80002c4c:	6422                	ld	s0,8(sp)
    80002c4e:	0141                	addi	sp,sp,16
    80002c50:	8082                	ret

0000000080002c52 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002c52:	457c                	lw	a5,76(a0)
    80002c54:	0ed7eb63          	bltu	a5,a3,80002d4a <readi+0xf8>
{
    80002c58:	7159                	addi	sp,sp,-112
    80002c5a:	f486                	sd	ra,104(sp)
    80002c5c:	f0a2                	sd	s0,96(sp)
    80002c5e:	eca6                	sd	s1,88(sp)
    80002c60:	e0d2                	sd	s4,64(sp)
    80002c62:	fc56                	sd	s5,56(sp)
    80002c64:	f85a                	sd	s6,48(sp)
    80002c66:	f45e                	sd	s7,40(sp)
    80002c68:	1880                	addi	s0,sp,112
    80002c6a:	8b2a                	mv	s6,a0
    80002c6c:	8bae                	mv	s7,a1
    80002c6e:	8a32                	mv	s4,a2
    80002c70:	84b6                	mv	s1,a3
    80002c72:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002c74:	9f35                	addw	a4,a4,a3
    return 0;
    80002c76:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002c78:	0cd76063          	bltu	a4,a3,80002d38 <readi+0xe6>
    80002c7c:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002c7e:	00e7f463          	bgeu	a5,a4,80002c86 <readi+0x34>
    n = ip->size - off;
    80002c82:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002c86:	080a8f63          	beqz	s5,80002d24 <readi+0xd2>
    80002c8a:	e8ca                	sd	s2,80(sp)
    80002c8c:	f062                	sd	s8,32(sp)
    80002c8e:	ec66                	sd	s9,24(sp)
    80002c90:	e86a                	sd	s10,16(sp)
    80002c92:	e46e                	sd	s11,8(sp)
    80002c94:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c96:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002c9a:	5c7d                	li	s8,-1
    80002c9c:	a80d                	j	80002cce <readi+0x7c>
    80002c9e:	020d1d93          	slli	s11,s10,0x20
    80002ca2:	020ddd93          	srli	s11,s11,0x20
    80002ca6:	05890613          	addi	a2,s2,88
    80002caa:	86ee                	mv	a3,s11
    80002cac:	963a                	add	a2,a2,a4
    80002cae:	85d2                	mv	a1,s4
    80002cb0:	855e                	mv	a0,s7
    80002cb2:	9dbfe0ef          	jal	8000168c <either_copyout>
    80002cb6:	05850763          	beq	a0,s8,80002d04 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002cba:	854a                	mv	a0,s2
    80002cbc:	f12ff0ef          	jal	800023ce <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002cc0:	013d09bb          	addw	s3,s10,s3
    80002cc4:	009d04bb          	addw	s1,s10,s1
    80002cc8:	9a6e                	add	s4,s4,s11
    80002cca:	0559f763          	bgeu	s3,s5,80002d18 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002cce:	00a4d59b          	srliw	a1,s1,0xa
    80002cd2:	855a                	mv	a0,s6
    80002cd4:	977ff0ef          	jal	8000264a <bmap>
    80002cd8:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002cdc:	c5b1                	beqz	a1,80002d28 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002cde:	000b2503          	lw	a0,0(s6)
    80002ce2:	de4ff0ef          	jal	800022c6 <bread>
    80002ce6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ce8:	3ff4f713          	andi	a4,s1,1023
    80002cec:	40ec87bb          	subw	a5,s9,a4
    80002cf0:	413a86bb          	subw	a3,s5,s3
    80002cf4:	8d3e                	mv	s10,a5
    80002cf6:	2781                	sext.w	a5,a5
    80002cf8:	0006861b          	sext.w	a2,a3
    80002cfc:	faf671e3          	bgeu	a2,a5,80002c9e <readi+0x4c>
    80002d00:	8d36                	mv	s10,a3
    80002d02:	bf71                	j	80002c9e <readi+0x4c>
      brelse(bp);
    80002d04:	854a                	mv	a0,s2
    80002d06:	ec8ff0ef          	jal	800023ce <brelse>
      tot = -1;
    80002d0a:	59fd                	li	s3,-1
      break;
    80002d0c:	6946                	ld	s2,80(sp)
    80002d0e:	7c02                	ld	s8,32(sp)
    80002d10:	6ce2                	ld	s9,24(sp)
    80002d12:	6d42                	ld	s10,16(sp)
    80002d14:	6da2                	ld	s11,8(sp)
    80002d16:	a831                	j	80002d32 <readi+0xe0>
    80002d18:	6946                	ld	s2,80(sp)
    80002d1a:	7c02                	ld	s8,32(sp)
    80002d1c:	6ce2                	ld	s9,24(sp)
    80002d1e:	6d42                	ld	s10,16(sp)
    80002d20:	6da2                	ld	s11,8(sp)
    80002d22:	a801                	j	80002d32 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d24:	89d6                	mv	s3,s5
    80002d26:	a031                	j	80002d32 <readi+0xe0>
    80002d28:	6946                	ld	s2,80(sp)
    80002d2a:	7c02                	ld	s8,32(sp)
    80002d2c:	6ce2                	ld	s9,24(sp)
    80002d2e:	6d42                	ld	s10,16(sp)
    80002d30:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002d32:	0009851b          	sext.w	a0,s3
    80002d36:	69a6                	ld	s3,72(sp)
}
    80002d38:	70a6                	ld	ra,104(sp)
    80002d3a:	7406                	ld	s0,96(sp)
    80002d3c:	64e6                	ld	s1,88(sp)
    80002d3e:	6a06                	ld	s4,64(sp)
    80002d40:	7ae2                	ld	s5,56(sp)
    80002d42:	7b42                	ld	s6,48(sp)
    80002d44:	7ba2                	ld	s7,40(sp)
    80002d46:	6165                	addi	sp,sp,112
    80002d48:	8082                	ret
    return 0;
    80002d4a:	4501                	li	a0,0
}
    80002d4c:	8082                	ret

0000000080002d4e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d4e:	457c                	lw	a5,76(a0)
    80002d50:	10d7e063          	bltu	a5,a3,80002e50 <writei+0x102>
{
    80002d54:	7159                	addi	sp,sp,-112
    80002d56:	f486                	sd	ra,104(sp)
    80002d58:	f0a2                	sd	s0,96(sp)
    80002d5a:	e8ca                	sd	s2,80(sp)
    80002d5c:	e0d2                	sd	s4,64(sp)
    80002d5e:	fc56                	sd	s5,56(sp)
    80002d60:	f85a                	sd	s6,48(sp)
    80002d62:	f45e                	sd	s7,40(sp)
    80002d64:	1880                	addi	s0,sp,112
    80002d66:	8aaa                	mv	s5,a0
    80002d68:	8bae                	mv	s7,a1
    80002d6a:	8a32                	mv	s4,a2
    80002d6c:	8936                	mv	s2,a3
    80002d6e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002d70:	00e687bb          	addw	a5,a3,a4
    80002d74:	0ed7e063          	bltu	a5,a3,80002e54 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002d78:	00043737          	lui	a4,0x43
    80002d7c:	0cf76e63          	bltu	a4,a5,80002e58 <writei+0x10a>
    80002d80:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002d82:	0a0b0f63          	beqz	s6,80002e40 <writei+0xf2>
    80002d86:	eca6                	sd	s1,88(sp)
    80002d88:	f062                	sd	s8,32(sp)
    80002d8a:	ec66                	sd	s9,24(sp)
    80002d8c:	e86a                	sd	s10,16(sp)
    80002d8e:	e46e                	sd	s11,8(sp)
    80002d90:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002d92:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002d96:	5c7d                	li	s8,-1
    80002d98:	a825                	j	80002dd0 <writei+0x82>
    80002d9a:	020d1d93          	slli	s11,s10,0x20
    80002d9e:	020ddd93          	srli	s11,s11,0x20
    80002da2:	05848513          	addi	a0,s1,88
    80002da6:	86ee                	mv	a3,s11
    80002da8:	8652                	mv	a2,s4
    80002daa:	85de                	mv	a1,s7
    80002dac:	953a                	add	a0,a0,a4
    80002dae:	929fe0ef          	jal	800016d6 <either_copyin>
    80002db2:	05850a63          	beq	a0,s8,80002e06 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002db6:	8526                	mv	a0,s1
    80002db8:	660000ef          	jal	80003418 <log_write>
    brelse(bp);
    80002dbc:	8526                	mv	a0,s1
    80002dbe:	e10ff0ef          	jal	800023ce <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002dc2:	013d09bb          	addw	s3,s10,s3
    80002dc6:	012d093b          	addw	s2,s10,s2
    80002dca:	9a6e                	add	s4,s4,s11
    80002dcc:	0569f063          	bgeu	s3,s6,80002e0c <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002dd0:	00a9559b          	srliw	a1,s2,0xa
    80002dd4:	8556                	mv	a0,s5
    80002dd6:	875ff0ef          	jal	8000264a <bmap>
    80002dda:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002dde:	c59d                	beqz	a1,80002e0c <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002de0:	000aa503          	lw	a0,0(s5)
    80002de4:	ce2ff0ef          	jal	800022c6 <bread>
    80002de8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dea:	3ff97713          	andi	a4,s2,1023
    80002dee:	40ec87bb          	subw	a5,s9,a4
    80002df2:	413b06bb          	subw	a3,s6,s3
    80002df6:	8d3e                	mv	s10,a5
    80002df8:	2781                	sext.w	a5,a5
    80002dfa:	0006861b          	sext.w	a2,a3
    80002dfe:	f8f67ee3          	bgeu	a2,a5,80002d9a <writei+0x4c>
    80002e02:	8d36                	mv	s10,a3
    80002e04:	bf59                	j	80002d9a <writei+0x4c>
      brelse(bp);
    80002e06:	8526                	mv	a0,s1
    80002e08:	dc6ff0ef          	jal	800023ce <brelse>
  }

  if(off > ip->size)
    80002e0c:	04caa783          	lw	a5,76(s5)
    80002e10:	0327fa63          	bgeu	a5,s2,80002e44 <writei+0xf6>
    ip->size = off;
    80002e14:	052aa623          	sw	s2,76(s5)
    80002e18:	64e6                	ld	s1,88(sp)
    80002e1a:	7c02                	ld	s8,32(sp)
    80002e1c:	6ce2                	ld	s9,24(sp)
    80002e1e:	6d42                	ld	s10,16(sp)
    80002e20:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002e22:	8556                	mv	a0,s5
    80002e24:	b27ff0ef          	jal	8000294a <iupdate>

  return tot;
    80002e28:	0009851b          	sext.w	a0,s3
    80002e2c:	69a6                	ld	s3,72(sp)
}
    80002e2e:	70a6                	ld	ra,104(sp)
    80002e30:	7406                	ld	s0,96(sp)
    80002e32:	6946                	ld	s2,80(sp)
    80002e34:	6a06                	ld	s4,64(sp)
    80002e36:	7ae2                	ld	s5,56(sp)
    80002e38:	7b42                	ld	s6,48(sp)
    80002e3a:	7ba2                	ld	s7,40(sp)
    80002e3c:	6165                	addi	sp,sp,112
    80002e3e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e40:	89da                	mv	s3,s6
    80002e42:	b7c5                	j	80002e22 <writei+0xd4>
    80002e44:	64e6                	ld	s1,88(sp)
    80002e46:	7c02                	ld	s8,32(sp)
    80002e48:	6ce2                	ld	s9,24(sp)
    80002e4a:	6d42                	ld	s10,16(sp)
    80002e4c:	6da2                	ld	s11,8(sp)
    80002e4e:	bfd1                	j	80002e22 <writei+0xd4>
    return -1;
    80002e50:	557d                	li	a0,-1
}
    80002e52:	8082                	ret
    return -1;
    80002e54:	557d                	li	a0,-1
    80002e56:	bfe1                	j	80002e2e <writei+0xe0>
    return -1;
    80002e58:	557d                	li	a0,-1
    80002e5a:	bfd1                	j	80002e2e <writei+0xe0>

0000000080002e5c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002e5c:	1141                	addi	sp,sp,-16
    80002e5e:	e406                	sd	ra,8(sp)
    80002e60:	e022                	sd	s0,0(sp)
    80002e62:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002e64:	4639                	li	a2,14
    80002e66:	b9afd0ef          	jal	80000200 <strncmp>
}
    80002e6a:	60a2                	ld	ra,8(sp)
    80002e6c:	6402                	ld	s0,0(sp)
    80002e6e:	0141                	addi	sp,sp,16
    80002e70:	8082                	ret

0000000080002e72 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002e72:	7139                	addi	sp,sp,-64
    80002e74:	fc06                	sd	ra,56(sp)
    80002e76:	f822                	sd	s0,48(sp)
    80002e78:	f426                	sd	s1,40(sp)
    80002e7a:	f04a                	sd	s2,32(sp)
    80002e7c:	ec4e                	sd	s3,24(sp)
    80002e7e:	e852                	sd	s4,16(sp)
    80002e80:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002e82:	04451703          	lh	a4,68(a0)
    80002e86:	4785                	li	a5,1
    80002e88:	00f71a63          	bne	a4,a5,80002e9c <dirlookup+0x2a>
    80002e8c:	892a                	mv	s2,a0
    80002e8e:	89ae                	mv	s3,a1
    80002e90:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e92:	457c                	lw	a5,76(a0)
    80002e94:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002e96:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e98:	e39d                	bnez	a5,80002ebe <dirlookup+0x4c>
    80002e9a:	a095                	j	80002efe <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002e9c:	00004517          	auipc	a0,0x4
    80002ea0:	79450513          	addi	a0,a0,1940 # 80007630 <etext+0x630>
    80002ea4:	1af020ef          	jal	80005852 <panic>
      panic("dirlookup read");
    80002ea8:	00004517          	auipc	a0,0x4
    80002eac:	7a050513          	addi	a0,a0,1952 # 80007648 <etext+0x648>
    80002eb0:	1a3020ef          	jal	80005852 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002eb4:	24c1                	addiw	s1,s1,16
    80002eb6:	04c92783          	lw	a5,76(s2)
    80002eba:	04f4f163          	bgeu	s1,a5,80002efc <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002ebe:	4741                	li	a4,16
    80002ec0:	86a6                	mv	a3,s1
    80002ec2:	fc040613          	addi	a2,s0,-64
    80002ec6:	4581                	li	a1,0
    80002ec8:	854a                	mv	a0,s2
    80002eca:	d89ff0ef          	jal	80002c52 <readi>
    80002ece:	47c1                	li	a5,16
    80002ed0:	fcf51ce3          	bne	a0,a5,80002ea8 <dirlookup+0x36>
    if(de.inum == 0)
    80002ed4:	fc045783          	lhu	a5,-64(s0)
    80002ed8:	dff1                	beqz	a5,80002eb4 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002eda:	fc240593          	addi	a1,s0,-62
    80002ede:	854e                	mv	a0,s3
    80002ee0:	f7dff0ef          	jal	80002e5c <namecmp>
    80002ee4:	f961                	bnez	a0,80002eb4 <dirlookup+0x42>
      if(poff)
    80002ee6:	000a0463          	beqz	s4,80002eee <dirlookup+0x7c>
        *poff = off;
    80002eea:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002eee:	fc045583          	lhu	a1,-64(s0)
    80002ef2:	00092503          	lw	a0,0(s2)
    80002ef6:	829ff0ef          	jal	8000271e <iget>
    80002efa:	a011                	j	80002efe <dirlookup+0x8c>
  return 0;
    80002efc:	4501                	li	a0,0
}
    80002efe:	70e2                	ld	ra,56(sp)
    80002f00:	7442                	ld	s0,48(sp)
    80002f02:	74a2                	ld	s1,40(sp)
    80002f04:	7902                	ld	s2,32(sp)
    80002f06:	69e2                	ld	s3,24(sp)
    80002f08:	6a42                	ld	s4,16(sp)
    80002f0a:	6121                	addi	sp,sp,64
    80002f0c:	8082                	ret

0000000080002f0e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002f0e:	711d                	addi	sp,sp,-96
    80002f10:	ec86                	sd	ra,88(sp)
    80002f12:	e8a2                	sd	s0,80(sp)
    80002f14:	e4a6                	sd	s1,72(sp)
    80002f16:	e0ca                	sd	s2,64(sp)
    80002f18:	fc4e                	sd	s3,56(sp)
    80002f1a:	f852                	sd	s4,48(sp)
    80002f1c:	f456                	sd	s5,40(sp)
    80002f1e:	f05a                	sd	s6,32(sp)
    80002f20:	ec5e                	sd	s7,24(sp)
    80002f22:	e862                	sd	s8,16(sp)
    80002f24:	e466                	sd	s9,8(sp)
    80002f26:	1080                	addi	s0,sp,96
    80002f28:	84aa                	mv	s1,a0
    80002f2a:	8b2e                	mv	s6,a1
    80002f2c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002f2e:	00054703          	lbu	a4,0(a0)
    80002f32:	02f00793          	li	a5,47
    80002f36:	00f70e63          	beq	a4,a5,80002f52 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002f3a:	e1dfd0ef          	jal	80000d56 <myproc>
    80002f3e:	15053503          	ld	a0,336(a0)
    80002f42:	a87ff0ef          	jal	800029c8 <idup>
    80002f46:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002f48:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002f4c:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002f4e:	4b85                	li	s7,1
    80002f50:	a871                	j	80002fec <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002f52:	4585                	li	a1,1
    80002f54:	4505                	li	a0,1
    80002f56:	fc8ff0ef          	jal	8000271e <iget>
    80002f5a:	8a2a                	mv	s4,a0
    80002f5c:	b7f5                	j	80002f48 <namex+0x3a>
      iunlockput(ip);
    80002f5e:	8552                	mv	a0,s4
    80002f60:	ca9ff0ef          	jal	80002c08 <iunlockput>
      return 0;
    80002f64:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002f66:	8552                	mv	a0,s4
    80002f68:	60e6                	ld	ra,88(sp)
    80002f6a:	6446                	ld	s0,80(sp)
    80002f6c:	64a6                	ld	s1,72(sp)
    80002f6e:	6906                	ld	s2,64(sp)
    80002f70:	79e2                	ld	s3,56(sp)
    80002f72:	7a42                	ld	s4,48(sp)
    80002f74:	7aa2                	ld	s5,40(sp)
    80002f76:	7b02                	ld	s6,32(sp)
    80002f78:	6be2                	ld	s7,24(sp)
    80002f7a:	6c42                	ld	s8,16(sp)
    80002f7c:	6ca2                	ld	s9,8(sp)
    80002f7e:	6125                	addi	sp,sp,96
    80002f80:	8082                	ret
      iunlock(ip);
    80002f82:	8552                	mv	a0,s4
    80002f84:	b29ff0ef          	jal	80002aac <iunlock>
      return ip;
    80002f88:	bff9                	j	80002f66 <namex+0x58>
      iunlockput(ip);
    80002f8a:	8552                	mv	a0,s4
    80002f8c:	c7dff0ef          	jal	80002c08 <iunlockput>
      return 0;
    80002f90:	8a4e                	mv	s4,s3
    80002f92:	bfd1                	j	80002f66 <namex+0x58>
  len = path - s;
    80002f94:	40998633          	sub	a2,s3,s1
    80002f98:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002f9c:	099c5063          	bge	s8,s9,8000301c <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002fa0:	4639                	li	a2,14
    80002fa2:	85a6                	mv	a1,s1
    80002fa4:	8556                	mv	a0,s5
    80002fa6:	9eafd0ef          	jal	80000190 <memmove>
    80002faa:	84ce                	mv	s1,s3
  while(*path == '/')
    80002fac:	0004c783          	lbu	a5,0(s1)
    80002fb0:	01279763          	bne	a5,s2,80002fbe <namex+0xb0>
    path++;
    80002fb4:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002fb6:	0004c783          	lbu	a5,0(s1)
    80002fba:	ff278de3          	beq	a5,s2,80002fb4 <namex+0xa6>
    ilock(ip);
    80002fbe:	8552                	mv	a0,s4
    80002fc0:	a3fff0ef          	jal	800029fe <ilock>
    if(ip->type != T_DIR){
    80002fc4:	044a1783          	lh	a5,68(s4)
    80002fc8:	f9779be3          	bne	a5,s7,80002f5e <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002fcc:	000b0563          	beqz	s6,80002fd6 <namex+0xc8>
    80002fd0:	0004c783          	lbu	a5,0(s1)
    80002fd4:	d7dd                	beqz	a5,80002f82 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002fd6:	4601                	li	a2,0
    80002fd8:	85d6                	mv	a1,s5
    80002fda:	8552                	mv	a0,s4
    80002fdc:	e97ff0ef          	jal	80002e72 <dirlookup>
    80002fe0:	89aa                	mv	s3,a0
    80002fe2:	d545                	beqz	a0,80002f8a <namex+0x7c>
    iunlockput(ip);
    80002fe4:	8552                	mv	a0,s4
    80002fe6:	c23ff0ef          	jal	80002c08 <iunlockput>
    ip = next;
    80002fea:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002fec:	0004c783          	lbu	a5,0(s1)
    80002ff0:	01279763          	bne	a5,s2,80002ffe <namex+0xf0>
    path++;
    80002ff4:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002ff6:	0004c783          	lbu	a5,0(s1)
    80002ffa:	ff278de3          	beq	a5,s2,80002ff4 <namex+0xe6>
  if(*path == 0)
    80002ffe:	cb8d                	beqz	a5,80003030 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003000:	0004c783          	lbu	a5,0(s1)
    80003004:	89a6                	mv	s3,s1
  len = path - s;
    80003006:	4c81                	li	s9,0
    80003008:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000300a:	01278963          	beq	a5,s2,8000301c <namex+0x10e>
    8000300e:	d3d9                	beqz	a5,80002f94 <namex+0x86>
    path++;
    80003010:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003012:	0009c783          	lbu	a5,0(s3)
    80003016:	ff279ce3          	bne	a5,s2,8000300e <namex+0x100>
    8000301a:	bfad                	j	80002f94 <namex+0x86>
    memmove(name, s, len);
    8000301c:	2601                	sext.w	a2,a2
    8000301e:	85a6                	mv	a1,s1
    80003020:	8556                	mv	a0,s5
    80003022:	96efd0ef          	jal	80000190 <memmove>
    name[len] = 0;
    80003026:	9cd6                	add	s9,s9,s5
    80003028:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000302c:	84ce                	mv	s1,s3
    8000302e:	bfbd                	j	80002fac <namex+0x9e>
  if(nameiparent){
    80003030:	f20b0be3          	beqz	s6,80002f66 <namex+0x58>
    iput(ip);
    80003034:	8552                	mv	a0,s4
    80003036:	b4bff0ef          	jal	80002b80 <iput>
    return 0;
    8000303a:	4a01                	li	s4,0
    8000303c:	b72d                	j	80002f66 <namex+0x58>

000000008000303e <dirlink>:
{
    8000303e:	7139                	addi	sp,sp,-64
    80003040:	fc06                	sd	ra,56(sp)
    80003042:	f822                	sd	s0,48(sp)
    80003044:	f04a                	sd	s2,32(sp)
    80003046:	ec4e                	sd	s3,24(sp)
    80003048:	e852                	sd	s4,16(sp)
    8000304a:	0080                	addi	s0,sp,64
    8000304c:	892a                	mv	s2,a0
    8000304e:	8a2e                	mv	s4,a1
    80003050:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003052:	4601                	li	a2,0
    80003054:	e1fff0ef          	jal	80002e72 <dirlookup>
    80003058:	e535                	bnez	a0,800030c4 <dirlink+0x86>
    8000305a:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000305c:	04c92483          	lw	s1,76(s2)
    80003060:	c48d                	beqz	s1,8000308a <dirlink+0x4c>
    80003062:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003064:	4741                	li	a4,16
    80003066:	86a6                	mv	a3,s1
    80003068:	fc040613          	addi	a2,s0,-64
    8000306c:	4581                	li	a1,0
    8000306e:	854a                	mv	a0,s2
    80003070:	be3ff0ef          	jal	80002c52 <readi>
    80003074:	47c1                	li	a5,16
    80003076:	04f51b63          	bne	a0,a5,800030cc <dirlink+0x8e>
    if(de.inum == 0)
    8000307a:	fc045783          	lhu	a5,-64(s0)
    8000307e:	c791                	beqz	a5,8000308a <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003080:	24c1                	addiw	s1,s1,16
    80003082:	04c92783          	lw	a5,76(s2)
    80003086:	fcf4efe3          	bltu	s1,a5,80003064 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    8000308a:	4639                	li	a2,14
    8000308c:	85d2                	mv	a1,s4
    8000308e:	fc240513          	addi	a0,s0,-62
    80003092:	9a4fd0ef          	jal	80000236 <strncpy>
  de.inum = inum;
    80003096:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000309a:	4741                	li	a4,16
    8000309c:	86a6                	mv	a3,s1
    8000309e:	fc040613          	addi	a2,s0,-64
    800030a2:	4581                	li	a1,0
    800030a4:	854a                	mv	a0,s2
    800030a6:	ca9ff0ef          	jal	80002d4e <writei>
    800030aa:	1541                	addi	a0,a0,-16
    800030ac:	00a03533          	snez	a0,a0
    800030b0:	40a00533          	neg	a0,a0
    800030b4:	74a2                	ld	s1,40(sp)
}
    800030b6:	70e2                	ld	ra,56(sp)
    800030b8:	7442                	ld	s0,48(sp)
    800030ba:	7902                	ld	s2,32(sp)
    800030bc:	69e2                	ld	s3,24(sp)
    800030be:	6a42                	ld	s4,16(sp)
    800030c0:	6121                	addi	sp,sp,64
    800030c2:	8082                	ret
    iput(ip);
    800030c4:	abdff0ef          	jal	80002b80 <iput>
    return -1;
    800030c8:	557d                	li	a0,-1
    800030ca:	b7f5                	j	800030b6 <dirlink+0x78>
      panic("dirlink read");
    800030cc:	00004517          	auipc	a0,0x4
    800030d0:	58c50513          	addi	a0,a0,1420 # 80007658 <etext+0x658>
    800030d4:	77e020ef          	jal	80005852 <panic>

00000000800030d8 <namei>:

struct inode*
namei(char *path)
{
    800030d8:	1101                	addi	sp,sp,-32
    800030da:	ec06                	sd	ra,24(sp)
    800030dc:	e822                	sd	s0,16(sp)
    800030de:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800030e0:	fe040613          	addi	a2,s0,-32
    800030e4:	4581                	li	a1,0
    800030e6:	e29ff0ef          	jal	80002f0e <namex>
}
    800030ea:	60e2                	ld	ra,24(sp)
    800030ec:	6442                	ld	s0,16(sp)
    800030ee:	6105                	addi	sp,sp,32
    800030f0:	8082                	ret

00000000800030f2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800030f2:	1141                	addi	sp,sp,-16
    800030f4:	e406                	sd	ra,8(sp)
    800030f6:	e022                	sd	s0,0(sp)
    800030f8:	0800                	addi	s0,sp,16
    800030fa:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800030fc:	4585                	li	a1,1
    800030fe:	e11ff0ef          	jal	80002f0e <namex>
}
    80003102:	60a2                	ld	ra,8(sp)
    80003104:	6402                	ld	s0,0(sp)
    80003106:	0141                	addi	sp,sp,16
    80003108:	8082                	ret

000000008000310a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000310a:	1101                	addi	sp,sp,-32
    8000310c:	ec06                	sd	ra,24(sp)
    8000310e:	e822                	sd	s0,16(sp)
    80003110:	e426                	sd	s1,8(sp)
    80003112:	e04a                	sd	s2,0(sp)
    80003114:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003116:	00018917          	auipc	s2,0x18
    8000311a:	8ea90913          	addi	s2,s2,-1814 # 8001aa00 <log>
    8000311e:	01892583          	lw	a1,24(s2)
    80003122:	02892503          	lw	a0,40(s2)
    80003126:	9a0ff0ef          	jal	800022c6 <bread>
    8000312a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000312c:	02c92603          	lw	a2,44(s2)
    80003130:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003132:	00c05f63          	blez	a2,80003150 <write_head+0x46>
    80003136:	00018717          	auipc	a4,0x18
    8000313a:	8fa70713          	addi	a4,a4,-1798 # 8001aa30 <log+0x30>
    8000313e:	87aa                	mv	a5,a0
    80003140:	060a                	slli	a2,a2,0x2
    80003142:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003144:	4314                	lw	a3,0(a4)
    80003146:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003148:	0711                	addi	a4,a4,4
    8000314a:	0791                	addi	a5,a5,4
    8000314c:	fec79ce3          	bne	a5,a2,80003144 <write_head+0x3a>
  }
  bwrite(buf);
    80003150:	8526                	mv	a0,s1
    80003152:	a4aff0ef          	jal	8000239c <bwrite>
  brelse(buf);
    80003156:	8526                	mv	a0,s1
    80003158:	a76ff0ef          	jal	800023ce <brelse>
}
    8000315c:	60e2                	ld	ra,24(sp)
    8000315e:	6442                	ld	s0,16(sp)
    80003160:	64a2                	ld	s1,8(sp)
    80003162:	6902                	ld	s2,0(sp)
    80003164:	6105                	addi	sp,sp,32
    80003166:	8082                	ret

0000000080003168 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003168:	00018797          	auipc	a5,0x18
    8000316c:	8c47a783          	lw	a5,-1852(a5) # 8001aa2c <log+0x2c>
    80003170:	08f05f63          	blez	a5,8000320e <install_trans+0xa6>
{
    80003174:	7139                	addi	sp,sp,-64
    80003176:	fc06                	sd	ra,56(sp)
    80003178:	f822                	sd	s0,48(sp)
    8000317a:	f426                	sd	s1,40(sp)
    8000317c:	f04a                	sd	s2,32(sp)
    8000317e:	ec4e                	sd	s3,24(sp)
    80003180:	e852                	sd	s4,16(sp)
    80003182:	e456                	sd	s5,8(sp)
    80003184:	e05a                	sd	s6,0(sp)
    80003186:	0080                	addi	s0,sp,64
    80003188:	8b2a                	mv	s6,a0
    8000318a:	00018a97          	auipc	s5,0x18
    8000318e:	8a6a8a93          	addi	s5,s5,-1882 # 8001aa30 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003192:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003194:	00018997          	auipc	s3,0x18
    80003198:	86c98993          	addi	s3,s3,-1940 # 8001aa00 <log>
    8000319c:	a829                	j	800031b6 <install_trans+0x4e>
    brelse(lbuf);
    8000319e:	854a                	mv	a0,s2
    800031a0:	a2eff0ef          	jal	800023ce <brelse>
    brelse(dbuf);
    800031a4:	8526                	mv	a0,s1
    800031a6:	a28ff0ef          	jal	800023ce <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800031aa:	2a05                	addiw	s4,s4,1
    800031ac:	0a91                	addi	s5,s5,4
    800031ae:	02c9a783          	lw	a5,44(s3)
    800031b2:	04fa5463          	bge	s4,a5,800031fa <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800031b6:	0189a583          	lw	a1,24(s3)
    800031ba:	014585bb          	addw	a1,a1,s4
    800031be:	2585                	addiw	a1,a1,1
    800031c0:	0289a503          	lw	a0,40(s3)
    800031c4:	902ff0ef          	jal	800022c6 <bread>
    800031c8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800031ca:	000aa583          	lw	a1,0(s5)
    800031ce:	0289a503          	lw	a0,40(s3)
    800031d2:	8f4ff0ef          	jal	800022c6 <bread>
    800031d6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800031d8:	40000613          	li	a2,1024
    800031dc:	05890593          	addi	a1,s2,88
    800031e0:	05850513          	addi	a0,a0,88
    800031e4:	fadfc0ef          	jal	80000190 <memmove>
    bwrite(dbuf);  // write dst to disk
    800031e8:	8526                	mv	a0,s1
    800031ea:	9b2ff0ef          	jal	8000239c <bwrite>
    if(recovering == 0)
    800031ee:	fa0b18e3          	bnez	s6,8000319e <install_trans+0x36>
      bunpin(dbuf);
    800031f2:	8526                	mv	a0,s1
    800031f4:	a96ff0ef          	jal	8000248a <bunpin>
    800031f8:	b75d                	j	8000319e <install_trans+0x36>
}
    800031fa:	70e2                	ld	ra,56(sp)
    800031fc:	7442                	ld	s0,48(sp)
    800031fe:	74a2                	ld	s1,40(sp)
    80003200:	7902                	ld	s2,32(sp)
    80003202:	69e2                	ld	s3,24(sp)
    80003204:	6a42                	ld	s4,16(sp)
    80003206:	6aa2                	ld	s5,8(sp)
    80003208:	6b02                	ld	s6,0(sp)
    8000320a:	6121                	addi	sp,sp,64
    8000320c:	8082                	ret
    8000320e:	8082                	ret

0000000080003210 <initlog>:
{
    80003210:	7179                	addi	sp,sp,-48
    80003212:	f406                	sd	ra,40(sp)
    80003214:	f022                	sd	s0,32(sp)
    80003216:	ec26                	sd	s1,24(sp)
    80003218:	e84a                	sd	s2,16(sp)
    8000321a:	e44e                	sd	s3,8(sp)
    8000321c:	1800                	addi	s0,sp,48
    8000321e:	892a                	mv	s2,a0
    80003220:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003222:	00017497          	auipc	s1,0x17
    80003226:	7de48493          	addi	s1,s1,2014 # 8001aa00 <log>
    8000322a:	00004597          	auipc	a1,0x4
    8000322e:	43e58593          	addi	a1,a1,1086 # 80007668 <etext+0x668>
    80003232:	8526                	mv	a0,s1
    80003234:	0cd020ef          	jal	80005b00 <initlock>
  log.start = sb->logstart;
    80003238:	0149a583          	lw	a1,20(s3)
    8000323c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000323e:	0109a783          	lw	a5,16(s3)
    80003242:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003244:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003248:	854a                	mv	a0,s2
    8000324a:	87cff0ef          	jal	800022c6 <bread>
  log.lh.n = lh->n;
    8000324e:	4d30                	lw	a2,88(a0)
    80003250:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003252:	00c05f63          	blez	a2,80003270 <initlog+0x60>
    80003256:	87aa                	mv	a5,a0
    80003258:	00017717          	auipc	a4,0x17
    8000325c:	7d870713          	addi	a4,a4,2008 # 8001aa30 <log+0x30>
    80003260:	060a                	slli	a2,a2,0x2
    80003262:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003264:	4ff4                	lw	a3,92(a5)
    80003266:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003268:	0791                	addi	a5,a5,4
    8000326a:	0711                	addi	a4,a4,4
    8000326c:	fec79ce3          	bne	a5,a2,80003264 <initlog+0x54>
  brelse(buf);
    80003270:	95eff0ef          	jal	800023ce <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003274:	4505                	li	a0,1
    80003276:	ef3ff0ef          	jal	80003168 <install_trans>
  log.lh.n = 0;
    8000327a:	00017797          	auipc	a5,0x17
    8000327e:	7a07a923          	sw	zero,1970(a5) # 8001aa2c <log+0x2c>
  write_head(); // clear the log
    80003282:	e89ff0ef          	jal	8000310a <write_head>
}
    80003286:	70a2                	ld	ra,40(sp)
    80003288:	7402                	ld	s0,32(sp)
    8000328a:	64e2                	ld	s1,24(sp)
    8000328c:	6942                	ld	s2,16(sp)
    8000328e:	69a2                	ld	s3,8(sp)
    80003290:	6145                	addi	sp,sp,48
    80003292:	8082                	ret

0000000080003294 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003294:	1101                	addi	sp,sp,-32
    80003296:	ec06                	sd	ra,24(sp)
    80003298:	e822                	sd	s0,16(sp)
    8000329a:	e426                	sd	s1,8(sp)
    8000329c:	e04a                	sd	s2,0(sp)
    8000329e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800032a0:	00017517          	auipc	a0,0x17
    800032a4:	76050513          	addi	a0,a0,1888 # 8001aa00 <log>
    800032a8:	0d9020ef          	jal	80005b80 <acquire>
  while(1){
    if(log.committing){
    800032ac:	00017497          	auipc	s1,0x17
    800032b0:	75448493          	addi	s1,s1,1876 # 8001aa00 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800032b4:	4979                	li	s2,30
    800032b6:	a029                	j	800032c0 <begin_op+0x2c>
      sleep(&log, &log.lock);
    800032b8:	85a6                	mv	a1,s1
    800032ba:	8526                	mv	a0,s1
    800032bc:	874fe0ef          	jal	80001330 <sleep>
    if(log.committing){
    800032c0:	50dc                	lw	a5,36(s1)
    800032c2:	fbfd                	bnez	a5,800032b8 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800032c4:	5098                	lw	a4,32(s1)
    800032c6:	2705                	addiw	a4,a4,1
    800032c8:	0027179b          	slliw	a5,a4,0x2
    800032cc:	9fb9                	addw	a5,a5,a4
    800032ce:	0017979b          	slliw	a5,a5,0x1
    800032d2:	54d4                	lw	a3,44(s1)
    800032d4:	9fb5                	addw	a5,a5,a3
    800032d6:	00f95763          	bge	s2,a5,800032e4 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800032da:	85a6                	mv	a1,s1
    800032dc:	8526                	mv	a0,s1
    800032de:	852fe0ef          	jal	80001330 <sleep>
    800032e2:	bff9                	j	800032c0 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800032e4:	00017517          	auipc	a0,0x17
    800032e8:	71c50513          	addi	a0,a0,1820 # 8001aa00 <log>
    800032ec:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800032ee:	12b020ef          	jal	80005c18 <release>
      break;
    }
  }
}
    800032f2:	60e2                	ld	ra,24(sp)
    800032f4:	6442                	ld	s0,16(sp)
    800032f6:	64a2                	ld	s1,8(sp)
    800032f8:	6902                	ld	s2,0(sp)
    800032fa:	6105                	addi	sp,sp,32
    800032fc:	8082                	ret

00000000800032fe <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800032fe:	7139                	addi	sp,sp,-64
    80003300:	fc06                	sd	ra,56(sp)
    80003302:	f822                	sd	s0,48(sp)
    80003304:	f426                	sd	s1,40(sp)
    80003306:	f04a                	sd	s2,32(sp)
    80003308:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000330a:	00017497          	auipc	s1,0x17
    8000330e:	6f648493          	addi	s1,s1,1782 # 8001aa00 <log>
    80003312:	8526                	mv	a0,s1
    80003314:	06d020ef          	jal	80005b80 <acquire>
  log.outstanding -= 1;
    80003318:	509c                	lw	a5,32(s1)
    8000331a:	37fd                	addiw	a5,a5,-1
    8000331c:	0007891b          	sext.w	s2,a5
    80003320:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003322:	50dc                	lw	a5,36(s1)
    80003324:	ef9d                	bnez	a5,80003362 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003326:	04091763          	bnez	s2,80003374 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    8000332a:	00017497          	auipc	s1,0x17
    8000332e:	6d648493          	addi	s1,s1,1750 # 8001aa00 <log>
    80003332:	4785                	li	a5,1
    80003334:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003336:	8526                	mv	a0,s1
    80003338:	0e1020ef          	jal	80005c18 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000333c:	54dc                	lw	a5,44(s1)
    8000333e:	04f04b63          	bgtz	a5,80003394 <end_op+0x96>
    acquire(&log.lock);
    80003342:	00017497          	auipc	s1,0x17
    80003346:	6be48493          	addi	s1,s1,1726 # 8001aa00 <log>
    8000334a:	8526                	mv	a0,s1
    8000334c:	035020ef          	jal	80005b80 <acquire>
    log.committing = 0;
    80003350:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003354:	8526                	mv	a0,s1
    80003356:	826fe0ef          	jal	8000137c <wakeup>
    release(&log.lock);
    8000335a:	8526                	mv	a0,s1
    8000335c:	0bd020ef          	jal	80005c18 <release>
}
    80003360:	a025                	j	80003388 <end_op+0x8a>
    80003362:	ec4e                	sd	s3,24(sp)
    80003364:	e852                	sd	s4,16(sp)
    80003366:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003368:	00004517          	auipc	a0,0x4
    8000336c:	30850513          	addi	a0,a0,776 # 80007670 <etext+0x670>
    80003370:	4e2020ef          	jal	80005852 <panic>
    wakeup(&log);
    80003374:	00017497          	auipc	s1,0x17
    80003378:	68c48493          	addi	s1,s1,1676 # 8001aa00 <log>
    8000337c:	8526                	mv	a0,s1
    8000337e:	ffffd0ef          	jal	8000137c <wakeup>
  release(&log.lock);
    80003382:	8526                	mv	a0,s1
    80003384:	095020ef          	jal	80005c18 <release>
}
    80003388:	70e2                	ld	ra,56(sp)
    8000338a:	7442                	ld	s0,48(sp)
    8000338c:	74a2                	ld	s1,40(sp)
    8000338e:	7902                	ld	s2,32(sp)
    80003390:	6121                	addi	sp,sp,64
    80003392:	8082                	ret
    80003394:	ec4e                	sd	s3,24(sp)
    80003396:	e852                	sd	s4,16(sp)
    80003398:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000339a:	00017a97          	auipc	s5,0x17
    8000339e:	696a8a93          	addi	s5,s5,1686 # 8001aa30 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800033a2:	00017a17          	auipc	s4,0x17
    800033a6:	65ea0a13          	addi	s4,s4,1630 # 8001aa00 <log>
    800033aa:	018a2583          	lw	a1,24(s4)
    800033ae:	012585bb          	addw	a1,a1,s2
    800033b2:	2585                	addiw	a1,a1,1
    800033b4:	028a2503          	lw	a0,40(s4)
    800033b8:	f0ffe0ef          	jal	800022c6 <bread>
    800033bc:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800033be:	000aa583          	lw	a1,0(s5)
    800033c2:	028a2503          	lw	a0,40(s4)
    800033c6:	f01fe0ef          	jal	800022c6 <bread>
    800033ca:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800033cc:	40000613          	li	a2,1024
    800033d0:	05850593          	addi	a1,a0,88
    800033d4:	05848513          	addi	a0,s1,88
    800033d8:	db9fc0ef          	jal	80000190 <memmove>
    bwrite(to);  // write the log
    800033dc:	8526                	mv	a0,s1
    800033de:	fbffe0ef          	jal	8000239c <bwrite>
    brelse(from);
    800033e2:	854e                	mv	a0,s3
    800033e4:	febfe0ef          	jal	800023ce <brelse>
    brelse(to);
    800033e8:	8526                	mv	a0,s1
    800033ea:	fe5fe0ef          	jal	800023ce <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033ee:	2905                	addiw	s2,s2,1
    800033f0:	0a91                	addi	s5,s5,4
    800033f2:	02ca2783          	lw	a5,44(s4)
    800033f6:	faf94ae3          	blt	s2,a5,800033aa <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800033fa:	d11ff0ef          	jal	8000310a <write_head>
    install_trans(0); // Now install writes to home locations
    800033fe:	4501                	li	a0,0
    80003400:	d69ff0ef          	jal	80003168 <install_trans>
    log.lh.n = 0;
    80003404:	00017797          	auipc	a5,0x17
    80003408:	6207a423          	sw	zero,1576(a5) # 8001aa2c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000340c:	cffff0ef          	jal	8000310a <write_head>
    80003410:	69e2                	ld	s3,24(sp)
    80003412:	6a42                	ld	s4,16(sp)
    80003414:	6aa2                	ld	s5,8(sp)
    80003416:	b735                	j	80003342 <end_op+0x44>

0000000080003418 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003418:	1101                	addi	sp,sp,-32
    8000341a:	ec06                	sd	ra,24(sp)
    8000341c:	e822                	sd	s0,16(sp)
    8000341e:	e426                	sd	s1,8(sp)
    80003420:	e04a                	sd	s2,0(sp)
    80003422:	1000                	addi	s0,sp,32
    80003424:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003426:	00017917          	auipc	s2,0x17
    8000342a:	5da90913          	addi	s2,s2,1498 # 8001aa00 <log>
    8000342e:	854a                	mv	a0,s2
    80003430:	750020ef          	jal	80005b80 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003434:	02c92603          	lw	a2,44(s2)
    80003438:	47f5                	li	a5,29
    8000343a:	06c7c363          	blt	a5,a2,800034a0 <log_write+0x88>
    8000343e:	00017797          	auipc	a5,0x17
    80003442:	5de7a783          	lw	a5,1502(a5) # 8001aa1c <log+0x1c>
    80003446:	37fd                	addiw	a5,a5,-1
    80003448:	04f65c63          	bge	a2,a5,800034a0 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000344c:	00017797          	auipc	a5,0x17
    80003450:	5d47a783          	lw	a5,1492(a5) # 8001aa20 <log+0x20>
    80003454:	04f05c63          	blez	a5,800034ac <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003458:	4781                	li	a5,0
    8000345a:	04c05f63          	blez	a2,800034b8 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000345e:	44cc                	lw	a1,12(s1)
    80003460:	00017717          	auipc	a4,0x17
    80003464:	5d070713          	addi	a4,a4,1488 # 8001aa30 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003468:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000346a:	4314                	lw	a3,0(a4)
    8000346c:	04b68663          	beq	a3,a1,800034b8 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003470:	2785                	addiw	a5,a5,1
    80003472:	0711                	addi	a4,a4,4
    80003474:	fef61be3          	bne	a2,a5,8000346a <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003478:	0621                	addi	a2,a2,8
    8000347a:	060a                	slli	a2,a2,0x2
    8000347c:	00017797          	auipc	a5,0x17
    80003480:	58478793          	addi	a5,a5,1412 # 8001aa00 <log>
    80003484:	97b2                	add	a5,a5,a2
    80003486:	44d8                	lw	a4,12(s1)
    80003488:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000348a:	8526                	mv	a0,s1
    8000348c:	fcbfe0ef          	jal	80002456 <bpin>
    log.lh.n++;
    80003490:	00017717          	auipc	a4,0x17
    80003494:	57070713          	addi	a4,a4,1392 # 8001aa00 <log>
    80003498:	575c                	lw	a5,44(a4)
    8000349a:	2785                	addiw	a5,a5,1
    8000349c:	d75c                	sw	a5,44(a4)
    8000349e:	a80d                	j	800034d0 <log_write+0xb8>
    panic("too big a transaction");
    800034a0:	00004517          	auipc	a0,0x4
    800034a4:	1e050513          	addi	a0,a0,480 # 80007680 <etext+0x680>
    800034a8:	3aa020ef          	jal	80005852 <panic>
    panic("log_write outside of trans");
    800034ac:	00004517          	auipc	a0,0x4
    800034b0:	1ec50513          	addi	a0,a0,492 # 80007698 <etext+0x698>
    800034b4:	39e020ef          	jal	80005852 <panic>
  log.lh.block[i] = b->blockno;
    800034b8:	00878693          	addi	a3,a5,8
    800034bc:	068a                	slli	a3,a3,0x2
    800034be:	00017717          	auipc	a4,0x17
    800034c2:	54270713          	addi	a4,a4,1346 # 8001aa00 <log>
    800034c6:	9736                	add	a4,a4,a3
    800034c8:	44d4                	lw	a3,12(s1)
    800034ca:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800034cc:	faf60fe3          	beq	a2,a5,8000348a <log_write+0x72>
  }
  release(&log.lock);
    800034d0:	00017517          	auipc	a0,0x17
    800034d4:	53050513          	addi	a0,a0,1328 # 8001aa00 <log>
    800034d8:	740020ef          	jal	80005c18 <release>
}
    800034dc:	60e2                	ld	ra,24(sp)
    800034de:	6442                	ld	s0,16(sp)
    800034e0:	64a2                	ld	s1,8(sp)
    800034e2:	6902                	ld	s2,0(sp)
    800034e4:	6105                	addi	sp,sp,32
    800034e6:	8082                	ret

00000000800034e8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800034e8:	1101                	addi	sp,sp,-32
    800034ea:	ec06                	sd	ra,24(sp)
    800034ec:	e822                	sd	s0,16(sp)
    800034ee:	e426                	sd	s1,8(sp)
    800034f0:	e04a                	sd	s2,0(sp)
    800034f2:	1000                	addi	s0,sp,32
    800034f4:	84aa                	mv	s1,a0
    800034f6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800034f8:	00004597          	auipc	a1,0x4
    800034fc:	1c058593          	addi	a1,a1,448 # 800076b8 <etext+0x6b8>
    80003500:	0521                	addi	a0,a0,8
    80003502:	5fe020ef          	jal	80005b00 <initlock>
  lk->name = name;
    80003506:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000350a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000350e:	0204a423          	sw	zero,40(s1)
}
    80003512:	60e2                	ld	ra,24(sp)
    80003514:	6442                	ld	s0,16(sp)
    80003516:	64a2                	ld	s1,8(sp)
    80003518:	6902                	ld	s2,0(sp)
    8000351a:	6105                	addi	sp,sp,32
    8000351c:	8082                	ret

000000008000351e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000351e:	1101                	addi	sp,sp,-32
    80003520:	ec06                	sd	ra,24(sp)
    80003522:	e822                	sd	s0,16(sp)
    80003524:	e426                	sd	s1,8(sp)
    80003526:	e04a                	sd	s2,0(sp)
    80003528:	1000                	addi	s0,sp,32
    8000352a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000352c:	00850913          	addi	s2,a0,8
    80003530:	854a                	mv	a0,s2
    80003532:	64e020ef          	jal	80005b80 <acquire>
  while (lk->locked) {
    80003536:	409c                	lw	a5,0(s1)
    80003538:	c799                	beqz	a5,80003546 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000353a:	85ca                	mv	a1,s2
    8000353c:	8526                	mv	a0,s1
    8000353e:	df3fd0ef          	jal	80001330 <sleep>
  while (lk->locked) {
    80003542:	409c                	lw	a5,0(s1)
    80003544:	fbfd                	bnez	a5,8000353a <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003546:	4785                	li	a5,1
    80003548:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000354a:	80dfd0ef          	jal	80000d56 <myproc>
    8000354e:	591c                	lw	a5,48(a0)
    80003550:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003552:	854a                	mv	a0,s2
    80003554:	6c4020ef          	jal	80005c18 <release>
}
    80003558:	60e2                	ld	ra,24(sp)
    8000355a:	6442                	ld	s0,16(sp)
    8000355c:	64a2                	ld	s1,8(sp)
    8000355e:	6902                	ld	s2,0(sp)
    80003560:	6105                	addi	sp,sp,32
    80003562:	8082                	ret

0000000080003564 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003564:	1101                	addi	sp,sp,-32
    80003566:	ec06                	sd	ra,24(sp)
    80003568:	e822                	sd	s0,16(sp)
    8000356a:	e426                	sd	s1,8(sp)
    8000356c:	e04a                	sd	s2,0(sp)
    8000356e:	1000                	addi	s0,sp,32
    80003570:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003572:	00850913          	addi	s2,a0,8
    80003576:	854a                	mv	a0,s2
    80003578:	608020ef          	jal	80005b80 <acquire>
  lk->locked = 0;
    8000357c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003580:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003584:	8526                	mv	a0,s1
    80003586:	df7fd0ef          	jal	8000137c <wakeup>
  release(&lk->lk);
    8000358a:	854a                	mv	a0,s2
    8000358c:	68c020ef          	jal	80005c18 <release>
}
    80003590:	60e2                	ld	ra,24(sp)
    80003592:	6442                	ld	s0,16(sp)
    80003594:	64a2                	ld	s1,8(sp)
    80003596:	6902                	ld	s2,0(sp)
    80003598:	6105                	addi	sp,sp,32
    8000359a:	8082                	ret

000000008000359c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000359c:	7179                	addi	sp,sp,-48
    8000359e:	f406                	sd	ra,40(sp)
    800035a0:	f022                	sd	s0,32(sp)
    800035a2:	ec26                	sd	s1,24(sp)
    800035a4:	e84a                	sd	s2,16(sp)
    800035a6:	1800                	addi	s0,sp,48
    800035a8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800035aa:	00850913          	addi	s2,a0,8
    800035ae:	854a                	mv	a0,s2
    800035b0:	5d0020ef          	jal	80005b80 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800035b4:	409c                	lw	a5,0(s1)
    800035b6:	ef81                	bnez	a5,800035ce <holdingsleep+0x32>
    800035b8:	4481                	li	s1,0
  release(&lk->lk);
    800035ba:	854a                	mv	a0,s2
    800035bc:	65c020ef          	jal	80005c18 <release>
  return r;
}
    800035c0:	8526                	mv	a0,s1
    800035c2:	70a2                	ld	ra,40(sp)
    800035c4:	7402                	ld	s0,32(sp)
    800035c6:	64e2                	ld	s1,24(sp)
    800035c8:	6942                	ld	s2,16(sp)
    800035ca:	6145                	addi	sp,sp,48
    800035cc:	8082                	ret
    800035ce:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800035d0:	0284a983          	lw	s3,40(s1)
    800035d4:	f82fd0ef          	jal	80000d56 <myproc>
    800035d8:	5904                	lw	s1,48(a0)
    800035da:	413484b3          	sub	s1,s1,s3
    800035de:	0014b493          	seqz	s1,s1
    800035e2:	69a2                	ld	s3,8(sp)
    800035e4:	bfd9                	j	800035ba <holdingsleep+0x1e>

00000000800035e6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800035e6:	1141                	addi	sp,sp,-16
    800035e8:	e406                	sd	ra,8(sp)
    800035ea:	e022                	sd	s0,0(sp)
    800035ec:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800035ee:	00004597          	auipc	a1,0x4
    800035f2:	0da58593          	addi	a1,a1,218 # 800076c8 <etext+0x6c8>
    800035f6:	00017517          	auipc	a0,0x17
    800035fa:	55250513          	addi	a0,a0,1362 # 8001ab48 <ftable>
    800035fe:	502020ef          	jal	80005b00 <initlock>
}
    80003602:	60a2                	ld	ra,8(sp)
    80003604:	6402                	ld	s0,0(sp)
    80003606:	0141                	addi	sp,sp,16
    80003608:	8082                	ret

000000008000360a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000360a:	1101                	addi	sp,sp,-32
    8000360c:	ec06                	sd	ra,24(sp)
    8000360e:	e822                	sd	s0,16(sp)
    80003610:	e426                	sd	s1,8(sp)
    80003612:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003614:	00017517          	auipc	a0,0x17
    80003618:	53450513          	addi	a0,a0,1332 # 8001ab48 <ftable>
    8000361c:	564020ef          	jal	80005b80 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003620:	00017497          	auipc	s1,0x17
    80003624:	54048493          	addi	s1,s1,1344 # 8001ab60 <ftable+0x18>
    80003628:	00018717          	auipc	a4,0x18
    8000362c:	4d870713          	addi	a4,a4,1240 # 8001bb00 <disk>
    if(f->ref == 0){
    80003630:	40dc                	lw	a5,4(s1)
    80003632:	cf89                	beqz	a5,8000364c <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003634:	02848493          	addi	s1,s1,40
    80003638:	fee49ce3          	bne	s1,a4,80003630 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000363c:	00017517          	auipc	a0,0x17
    80003640:	50c50513          	addi	a0,a0,1292 # 8001ab48 <ftable>
    80003644:	5d4020ef          	jal	80005c18 <release>
  return 0;
    80003648:	4481                	li	s1,0
    8000364a:	a809                	j	8000365c <filealloc+0x52>
      f->ref = 1;
    8000364c:	4785                	li	a5,1
    8000364e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003650:	00017517          	auipc	a0,0x17
    80003654:	4f850513          	addi	a0,a0,1272 # 8001ab48 <ftable>
    80003658:	5c0020ef          	jal	80005c18 <release>
}
    8000365c:	8526                	mv	a0,s1
    8000365e:	60e2                	ld	ra,24(sp)
    80003660:	6442                	ld	s0,16(sp)
    80003662:	64a2                	ld	s1,8(sp)
    80003664:	6105                	addi	sp,sp,32
    80003666:	8082                	ret

0000000080003668 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003668:	1101                	addi	sp,sp,-32
    8000366a:	ec06                	sd	ra,24(sp)
    8000366c:	e822                	sd	s0,16(sp)
    8000366e:	e426                	sd	s1,8(sp)
    80003670:	1000                	addi	s0,sp,32
    80003672:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003674:	00017517          	auipc	a0,0x17
    80003678:	4d450513          	addi	a0,a0,1236 # 8001ab48 <ftable>
    8000367c:	504020ef          	jal	80005b80 <acquire>
  if(f->ref < 1)
    80003680:	40dc                	lw	a5,4(s1)
    80003682:	02f05063          	blez	a5,800036a2 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003686:	2785                	addiw	a5,a5,1
    80003688:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000368a:	00017517          	auipc	a0,0x17
    8000368e:	4be50513          	addi	a0,a0,1214 # 8001ab48 <ftable>
    80003692:	586020ef          	jal	80005c18 <release>
  return f;
}
    80003696:	8526                	mv	a0,s1
    80003698:	60e2                	ld	ra,24(sp)
    8000369a:	6442                	ld	s0,16(sp)
    8000369c:	64a2                	ld	s1,8(sp)
    8000369e:	6105                	addi	sp,sp,32
    800036a0:	8082                	ret
    panic("filedup");
    800036a2:	00004517          	auipc	a0,0x4
    800036a6:	02e50513          	addi	a0,a0,46 # 800076d0 <etext+0x6d0>
    800036aa:	1a8020ef          	jal	80005852 <panic>

00000000800036ae <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800036ae:	7139                	addi	sp,sp,-64
    800036b0:	fc06                	sd	ra,56(sp)
    800036b2:	f822                	sd	s0,48(sp)
    800036b4:	f426                	sd	s1,40(sp)
    800036b6:	0080                	addi	s0,sp,64
    800036b8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800036ba:	00017517          	auipc	a0,0x17
    800036be:	48e50513          	addi	a0,a0,1166 # 8001ab48 <ftable>
    800036c2:	4be020ef          	jal	80005b80 <acquire>
  if(f->ref < 1)
    800036c6:	40dc                	lw	a5,4(s1)
    800036c8:	04f05a63          	blez	a5,8000371c <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800036cc:	37fd                	addiw	a5,a5,-1
    800036ce:	0007871b          	sext.w	a4,a5
    800036d2:	c0dc                	sw	a5,4(s1)
    800036d4:	04e04e63          	bgtz	a4,80003730 <fileclose+0x82>
    800036d8:	f04a                	sd	s2,32(sp)
    800036da:	ec4e                	sd	s3,24(sp)
    800036dc:	e852                	sd	s4,16(sp)
    800036de:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800036e0:	0004a903          	lw	s2,0(s1)
    800036e4:	0094ca83          	lbu	s5,9(s1)
    800036e8:	0104ba03          	ld	s4,16(s1)
    800036ec:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800036f0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800036f4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800036f8:	00017517          	auipc	a0,0x17
    800036fc:	45050513          	addi	a0,a0,1104 # 8001ab48 <ftable>
    80003700:	518020ef          	jal	80005c18 <release>

  if(ff.type == FD_PIPE){
    80003704:	4785                	li	a5,1
    80003706:	04f90063          	beq	s2,a5,80003746 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000370a:	3979                	addiw	s2,s2,-2
    8000370c:	4785                	li	a5,1
    8000370e:	0527f563          	bgeu	a5,s2,80003758 <fileclose+0xaa>
    80003712:	7902                	ld	s2,32(sp)
    80003714:	69e2                	ld	s3,24(sp)
    80003716:	6a42                	ld	s4,16(sp)
    80003718:	6aa2                	ld	s5,8(sp)
    8000371a:	a00d                	j	8000373c <fileclose+0x8e>
    8000371c:	f04a                	sd	s2,32(sp)
    8000371e:	ec4e                	sd	s3,24(sp)
    80003720:	e852                	sd	s4,16(sp)
    80003722:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003724:	00004517          	auipc	a0,0x4
    80003728:	fb450513          	addi	a0,a0,-76 # 800076d8 <etext+0x6d8>
    8000372c:	126020ef          	jal	80005852 <panic>
    release(&ftable.lock);
    80003730:	00017517          	auipc	a0,0x17
    80003734:	41850513          	addi	a0,a0,1048 # 8001ab48 <ftable>
    80003738:	4e0020ef          	jal	80005c18 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000373c:	70e2                	ld	ra,56(sp)
    8000373e:	7442                	ld	s0,48(sp)
    80003740:	74a2                	ld	s1,40(sp)
    80003742:	6121                	addi	sp,sp,64
    80003744:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003746:	85d6                	mv	a1,s5
    80003748:	8552                	mv	a0,s4
    8000374a:	336000ef          	jal	80003a80 <pipeclose>
    8000374e:	7902                	ld	s2,32(sp)
    80003750:	69e2                	ld	s3,24(sp)
    80003752:	6a42                	ld	s4,16(sp)
    80003754:	6aa2                	ld	s5,8(sp)
    80003756:	b7dd                	j	8000373c <fileclose+0x8e>
    begin_op();
    80003758:	b3dff0ef          	jal	80003294 <begin_op>
    iput(ff.ip);
    8000375c:	854e                	mv	a0,s3
    8000375e:	c22ff0ef          	jal	80002b80 <iput>
    end_op();
    80003762:	b9dff0ef          	jal	800032fe <end_op>
    80003766:	7902                	ld	s2,32(sp)
    80003768:	69e2                	ld	s3,24(sp)
    8000376a:	6a42                	ld	s4,16(sp)
    8000376c:	6aa2                	ld	s5,8(sp)
    8000376e:	b7f9                	j	8000373c <fileclose+0x8e>

0000000080003770 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003770:	715d                	addi	sp,sp,-80
    80003772:	e486                	sd	ra,72(sp)
    80003774:	e0a2                	sd	s0,64(sp)
    80003776:	fc26                	sd	s1,56(sp)
    80003778:	f44e                	sd	s3,40(sp)
    8000377a:	0880                	addi	s0,sp,80
    8000377c:	84aa                	mv	s1,a0
    8000377e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003780:	dd6fd0ef          	jal	80000d56 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003784:	409c                	lw	a5,0(s1)
    80003786:	37f9                	addiw	a5,a5,-2
    80003788:	4705                	li	a4,1
    8000378a:	04f76063          	bltu	a4,a5,800037ca <filestat+0x5a>
    8000378e:	f84a                	sd	s2,48(sp)
    80003790:	892a                	mv	s2,a0
    ilock(f->ip);
    80003792:	6c88                	ld	a0,24(s1)
    80003794:	a6aff0ef          	jal	800029fe <ilock>
    stati(f->ip, &st);
    80003798:	fb840593          	addi	a1,s0,-72
    8000379c:	6c88                	ld	a0,24(s1)
    8000379e:	c8aff0ef          	jal	80002c28 <stati>
    iunlock(f->ip);
    800037a2:	6c88                	ld	a0,24(s1)
    800037a4:	b08ff0ef          	jal	80002aac <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800037a8:	46e1                	li	a3,24
    800037aa:	fb840613          	addi	a2,s0,-72
    800037ae:	85ce                	mv	a1,s3
    800037b0:	05093503          	ld	a0,80(s2)
    800037b4:	a12fd0ef          	jal	800009c6 <copyout>
    800037b8:	41f5551b          	sraiw	a0,a0,0x1f
    800037bc:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800037be:	60a6                	ld	ra,72(sp)
    800037c0:	6406                	ld	s0,64(sp)
    800037c2:	74e2                	ld	s1,56(sp)
    800037c4:	79a2                	ld	s3,40(sp)
    800037c6:	6161                	addi	sp,sp,80
    800037c8:	8082                	ret
  return -1;
    800037ca:	557d                	li	a0,-1
    800037cc:	bfcd                	j	800037be <filestat+0x4e>

00000000800037ce <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800037ce:	7179                	addi	sp,sp,-48
    800037d0:	f406                	sd	ra,40(sp)
    800037d2:	f022                	sd	s0,32(sp)
    800037d4:	e84a                	sd	s2,16(sp)
    800037d6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800037d8:	00854783          	lbu	a5,8(a0)
    800037dc:	cfd1                	beqz	a5,80003878 <fileread+0xaa>
    800037de:	ec26                	sd	s1,24(sp)
    800037e0:	e44e                	sd	s3,8(sp)
    800037e2:	84aa                	mv	s1,a0
    800037e4:	89ae                	mv	s3,a1
    800037e6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800037e8:	411c                	lw	a5,0(a0)
    800037ea:	4705                	li	a4,1
    800037ec:	04e78363          	beq	a5,a4,80003832 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800037f0:	470d                	li	a4,3
    800037f2:	04e78763          	beq	a5,a4,80003840 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800037f6:	4709                	li	a4,2
    800037f8:	06e79a63          	bne	a5,a4,8000386c <fileread+0x9e>
    ilock(f->ip);
    800037fc:	6d08                	ld	a0,24(a0)
    800037fe:	a00ff0ef          	jal	800029fe <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003802:	874a                	mv	a4,s2
    80003804:	5094                	lw	a3,32(s1)
    80003806:	864e                	mv	a2,s3
    80003808:	4585                	li	a1,1
    8000380a:	6c88                	ld	a0,24(s1)
    8000380c:	c46ff0ef          	jal	80002c52 <readi>
    80003810:	892a                	mv	s2,a0
    80003812:	00a05563          	blez	a0,8000381c <fileread+0x4e>
      f->off += r;
    80003816:	509c                	lw	a5,32(s1)
    80003818:	9fa9                	addw	a5,a5,a0
    8000381a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000381c:	6c88                	ld	a0,24(s1)
    8000381e:	a8eff0ef          	jal	80002aac <iunlock>
    80003822:	64e2                	ld	s1,24(sp)
    80003824:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003826:	854a                	mv	a0,s2
    80003828:	70a2                	ld	ra,40(sp)
    8000382a:	7402                	ld	s0,32(sp)
    8000382c:	6942                	ld	s2,16(sp)
    8000382e:	6145                	addi	sp,sp,48
    80003830:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003832:	6908                	ld	a0,16(a0)
    80003834:	388000ef          	jal	80003bbc <piperead>
    80003838:	892a                	mv	s2,a0
    8000383a:	64e2                	ld	s1,24(sp)
    8000383c:	69a2                	ld	s3,8(sp)
    8000383e:	b7e5                	j	80003826 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003840:	02451783          	lh	a5,36(a0)
    80003844:	03079693          	slli	a3,a5,0x30
    80003848:	92c1                	srli	a3,a3,0x30
    8000384a:	4725                	li	a4,9
    8000384c:	02d76863          	bltu	a4,a3,8000387c <fileread+0xae>
    80003850:	0792                	slli	a5,a5,0x4
    80003852:	00017717          	auipc	a4,0x17
    80003856:	25670713          	addi	a4,a4,598 # 8001aaa8 <devsw>
    8000385a:	97ba                	add	a5,a5,a4
    8000385c:	639c                	ld	a5,0(a5)
    8000385e:	c39d                	beqz	a5,80003884 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003860:	4505                	li	a0,1
    80003862:	9782                	jalr	a5
    80003864:	892a                	mv	s2,a0
    80003866:	64e2                	ld	s1,24(sp)
    80003868:	69a2                	ld	s3,8(sp)
    8000386a:	bf75                	j	80003826 <fileread+0x58>
    panic("fileread");
    8000386c:	00004517          	auipc	a0,0x4
    80003870:	e7c50513          	addi	a0,a0,-388 # 800076e8 <etext+0x6e8>
    80003874:	7df010ef          	jal	80005852 <panic>
    return -1;
    80003878:	597d                	li	s2,-1
    8000387a:	b775                	j	80003826 <fileread+0x58>
      return -1;
    8000387c:	597d                	li	s2,-1
    8000387e:	64e2                	ld	s1,24(sp)
    80003880:	69a2                	ld	s3,8(sp)
    80003882:	b755                	j	80003826 <fileread+0x58>
    80003884:	597d                	li	s2,-1
    80003886:	64e2                	ld	s1,24(sp)
    80003888:	69a2                	ld	s3,8(sp)
    8000388a:	bf71                	j	80003826 <fileread+0x58>

000000008000388c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000388c:	00954783          	lbu	a5,9(a0)
    80003890:	10078b63          	beqz	a5,800039a6 <filewrite+0x11a>
{
    80003894:	715d                	addi	sp,sp,-80
    80003896:	e486                	sd	ra,72(sp)
    80003898:	e0a2                	sd	s0,64(sp)
    8000389a:	f84a                	sd	s2,48(sp)
    8000389c:	f052                	sd	s4,32(sp)
    8000389e:	e85a                	sd	s6,16(sp)
    800038a0:	0880                	addi	s0,sp,80
    800038a2:	892a                	mv	s2,a0
    800038a4:	8b2e                	mv	s6,a1
    800038a6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800038a8:	411c                	lw	a5,0(a0)
    800038aa:	4705                	li	a4,1
    800038ac:	02e78763          	beq	a5,a4,800038da <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800038b0:	470d                	li	a4,3
    800038b2:	02e78863          	beq	a5,a4,800038e2 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800038b6:	4709                	li	a4,2
    800038b8:	0ce79c63          	bne	a5,a4,80003990 <filewrite+0x104>
    800038bc:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800038be:	0ac05863          	blez	a2,8000396e <filewrite+0xe2>
    800038c2:	fc26                	sd	s1,56(sp)
    800038c4:	ec56                	sd	s5,24(sp)
    800038c6:	e45e                	sd	s7,8(sp)
    800038c8:	e062                	sd	s8,0(sp)
    int i = 0;
    800038ca:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800038cc:	6b85                	lui	s7,0x1
    800038ce:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800038d2:	6c05                	lui	s8,0x1
    800038d4:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800038d8:	a8b5                	j	80003954 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800038da:	6908                	ld	a0,16(a0)
    800038dc:	1fc000ef          	jal	80003ad8 <pipewrite>
    800038e0:	a04d                	j	80003982 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800038e2:	02451783          	lh	a5,36(a0)
    800038e6:	03079693          	slli	a3,a5,0x30
    800038ea:	92c1                	srli	a3,a3,0x30
    800038ec:	4725                	li	a4,9
    800038ee:	0ad76e63          	bltu	a4,a3,800039aa <filewrite+0x11e>
    800038f2:	0792                	slli	a5,a5,0x4
    800038f4:	00017717          	auipc	a4,0x17
    800038f8:	1b470713          	addi	a4,a4,436 # 8001aaa8 <devsw>
    800038fc:	97ba                	add	a5,a5,a4
    800038fe:	679c                	ld	a5,8(a5)
    80003900:	c7dd                	beqz	a5,800039ae <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80003902:	4505                	li	a0,1
    80003904:	9782                	jalr	a5
    80003906:	a8b5                	j	80003982 <filewrite+0xf6>
      if(n1 > max)
    80003908:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    8000390c:	989ff0ef          	jal	80003294 <begin_op>
      ilock(f->ip);
    80003910:	01893503          	ld	a0,24(s2)
    80003914:	8eaff0ef          	jal	800029fe <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003918:	8756                	mv	a4,s5
    8000391a:	02092683          	lw	a3,32(s2)
    8000391e:	01698633          	add	a2,s3,s6
    80003922:	4585                	li	a1,1
    80003924:	01893503          	ld	a0,24(s2)
    80003928:	c26ff0ef          	jal	80002d4e <writei>
    8000392c:	84aa                	mv	s1,a0
    8000392e:	00a05763          	blez	a0,8000393c <filewrite+0xb0>
        f->off += r;
    80003932:	02092783          	lw	a5,32(s2)
    80003936:	9fa9                	addw	a5,a5,a0
    80003938:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000393c:	01893503          	ld	a0,24(s2)
    80003940:	96cff0ef          	jal	80002aac <iunlock>
      end_op();
    80003944:	9bbff0ef          	jal	800032fe <end_op>

      if(r != n1){
    80003948:	029a9563          	bne	s5,s1,80003972 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    8000394c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003950:	0149da63          	bge	s3,s4,80003964 <filewrite+0xd8>
      int n1 = n - i;
    80003954:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003958:	0004879b          	sext.w	a5,s1
    8000395c:	fafbd6e3          	bge	s7,a5,80003908 <filewrite+0x7c>
    80003960:	84e2                	mv	s1,s8
    80003962:	b75d                	j	80003908 <filewrite+0x7c>
    80003964:	74e2                	ld	s1,56(sp)
    80003966:	6ae2                	ld	s5,24(sp)
    80003968:	6ba2                	ld	s7,8(sp)
    8000396a:	6c02                	ld	s8,0(sp)
    8000396c:	a039                	j	8000397a <filewrite+0xee>
    int i = 0;
    8000396e:	4981                	li	s3,0
    80003970:	a029                	j	8000397a <filewrite+0xee>
    80003972:	74e2                	ld	s1,56(sp)
    80003974:	6ae2                	ld	s5,24(sp)
    80003976:	6ba2                	ld	s7,8(sp)
    80003978:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000397a:	033a1c63          	bne	s4,s3,800039b2 <filewrite+0x126>
    8000397e:	8552                	mv	a0,s4
    80003980:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003982:	60a6                	ld	ra,72(sp)
    80003984:	6406                	ld	s0,64(sp)
    80003986:	7942                	ld	s2,48(sp)
    80003988:	7a02                	ld	s4,32(sp)
    8000398a:	6b42                	ld	s6,16(sp)
    8000398c:	6161                	addi	sp,sp,80
    8000398e:	8082                	ret
    80003990:	fc26                	sd	s1,56(sp)
    80003992:	f44e                	sd	s3,40(sp)
    80003994:	ec56                	sd	s5,24(sp)
    80003996:	e45e                	sd	s7,8(sp)
    80003998:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000399a:	00004517          	auipc	a0,0x4
    8000399e:	d5e50513          	addi	a0,a0,-674 # 800076f8 <etext+0x6f8>
    800039a2:	6b1010ef          	jal	80005852 <panic>
    return -1;
    800039a6:	557d                	li	a0,-1
}
    800039a8:	8082                	ret
      return -1;
    800039aa:	557d                	li	a0,-1
    800039ac:	bfd9                	j	80003982 <filewrite+0xf6>
    800039ae:	557d                	li	a0,-1
    800039b0:	bfc9                	j	80003982 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800039b2:	557d                	li	a0,-1
    800039b4:	79a2                	ld	s3,40(sp)
    800039b6:	b7f1                	j	80003982 <filewrite+0xf6>

00000000800039b8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800039b8:	7179                	addi	sp,sp,-48
    800039ba:	f406                	sd	ra,40(sp)
    800039bc:	f022                	sd	s0,32(sp)
    800039be:	ec26                	sd	s1,24(sp)
    800039c0:	e052                	sd	s4,0(sp)
    800039c2:	1800                	addi	s0,sp,48
    800039c4:	84aa                	mv	s1,a0
    800039c6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800039c8:	0005b023          	sd	zero,0(a1)
    800039cc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800039d0:	c3bff0ef          	jal	8000360a <filealloc>
    800039d4:	e088                	sd	a0,0(s1)
    800039d6:	c549                	beqz	a0,80003a60 <pipealloc+0xa8>
    800039d8:	c33ff0ef          	jal	8000360a <filealloc>
    800039dc:	00aa3023          	sd	a0,0(s4)
    800039e0:	cd25                	beqz	a0,80003a58 <pipealloc+0xa0>
    800039e2:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800039e4:	f12fc0ef          	jal	800000f6 <kalloc>
    800039e8:	892a                	mv	s2,a0
    800039ea:	c12d                	beqz	a0,80003a4c <pipealloc+0x94>
    800039ec:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800039ee:	4985                	li	s3,1
    800039f0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800039f4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800039f8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800039fc:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003a00:	00004597          	auipc	a1,0x4
    80003a04:	a9058593          	addi	a1,a1,-1392 # 80007490 <etext+0x490>
    80003a08:	0f8020ef          	jal	80005b00 <initlock>
  (*f0)->type = FD_PIPE;
    80003a0c:	609c                	ld	a5,0(s1)
    80003a0e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003a12:	609c                	ld	a5,0(s1)
    80003a14:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003a18:	609c                	ld	a5,0(s1)
    80003a1a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003a1e:	609c                	ld	a5,0(s1)
    80003a20:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003a24:	000a3783          	ld	a5,0(s4)
    80003a28:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003a2c:	000a3783          	ld	a5,0(s4)
    80003a30:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003a34:	000a3783          	ld	a5,0(s4)
    80003a38:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003a3c:	000a3783          	ld	a5,0(s4)
    80003a40:	0127b823          	sd	s2,16(a5)
  return 0;
    80003a44:	4501                	li	a0,0
    80003a46:	6942                	ld	s2,16(sp)
    80003a48:	69a2                	ld	s3,8(sp)
    80003a4a:	a01d                	j	80003a70 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003a4c:	6088                	ld	a0,0(s1)
    80003a4e:	c119                	beqz	a0,80003a54 <pipealloc+0x9c>
    80003a50:	6942                	ld	s2,16(sp)
    80003a52:	a029                	j	80003a5c <pipealloc+0xa4>
    80003a54:	6942                	ld	s2,16(sp)
    80003a56:	a029                	j	80003a60 <pipealloc+0xa8>
    80003a58:	6088                	ld	a0,0(s1)
    80003a5a:	c10d                	beqz	a0,80003a7c <pipealloc+0xc4>
    fileclose(*f0);
    80003a5c:	c53ff0ef          	jal	800036ae <fileclose>
  if(*f1)
    80003a60:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003a64:	557d                	li	a0,-1
  if(*f1)
    80003a66:	c789                	beqz	a5,80003a70 <pipealloc+0xb8>
    fileclose(*f1);
    80003a68:	853e                	mv	a0,a5
    80003a6a:	c45ff0ef          	jal	800036ae <fileclose>
  return -1;
    80003a6e:	557d                	li	a0,-1
}
    80003a70:	70a2                	ld	ra,40(sp)
    80003a72:	7402                	ld	s0,32(sp)
    80003a74:	64e2                	ld	s1,24(sp)
    80003a76:	6a02                	ld	s4,0(sp)
    80003a78:	6145                	addi	sp,sp,48
    80003a7a:	8082                	ret
  return -1;
    80003a7c:	557d                	li	a0,-1
    80003a7e:	bfcd                	j	80003a70 <pipealloc+0xb8>

0000000080003a80 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003a80:	1101                	addi	sp,sp,-32
    80003a82:	ec06                	sd	ra,24(sp)
    80003a84:	e822                	sd	s0,16(sp)
    80003a86:	e426                	sd	s1,8(sp)
    80003a88:	e04a                	sd	s2,0(sp)
    80003a8a:	1000                	addi	s0,sp,32
    80003a8c:	84aa                	mv	s1,a0
    80003a8e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003a90:	0f0020ef          	jal	80005b80 <acquire>
  if(writable){
    80003a94:	02090763          	beqz	s2,80003ac2 <pipeclose+0x42>
    pi->writeopen = 0;
    80003a98:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003a9c:	21848513          	addi	a0,s1,536
    80003aa0:	8ddfd0ef          	jal	8000137c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003aa4:	2204b783          	ld	a5,544(s1)
    80003aa8:	e785                	bnez	a5,80003ad0 <pipeclose+0x50>
    release(&pi->lock);
    80003aaa:	8526                	mv	a0,s1
    80003aac:	16c020ef          	jal	80005c18 <release>
    kfree((char*)pi);
    80003ab0:	8526                	mv	a0,s1
    80003ab2:	d6afc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ab6:	60e2                	ld	ra,24(sp)
    80003ab8:	6442                	ld	s0,16(sp)
    80003aba:	64a2                	ld	s1,8(sp)
    80003abc:	6902                	ld	s2,0(sp)
    80003abe:	6105                	addi	sp,sp,32
    80003ac0:	8082                	ret
    pi->readopen = 0;
    80003ac2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ac6:	21c48513          	addi	a0,s1,540
    80003aca:	8b3fd0ef          	jal	8000137c <wakeup>
    80003ace:	bfd9                	j	80003aa4 <pipeclose+0x24>
    release(&pi->lock);
    80003ad0:	8526                	mv	a0,s1
    80003ad2:	146020ef          	jal	80005c18 <release>
}
    80003ad6:	b7c5                	j	80003ab6 <pipeclose+0x36>

0000000080003ad8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ad8:	711d                	addi	sp,sp,-96
    80003ada:	ec86                	sd	ra,88(sp)
    80003adc:	e8a2                	sd	s0,80(sp)
    80003ade:	e4a6                	sd	s1,72(sp)
    80003ae0:	e0ca                	sd	s2,64(sp)
    80003ae2:	fc4e                	sd	s3,56(sp)
    80003ae4:	f852                	sd	s4,48(sp)
    80003ae6:	f456                	sd	s5,40(sp)
    80003ae8:	1080                	addi	s0,sp,96
    80003aea:	84aa                	mv	s1,a0
    80003aec:	8aae                	mv	s5,a1
    80003aee:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003af0:	a66fd0ef          	jal	80000d56 <myproc>
    80003af4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003af6:	8526                	mv	a0,s1
    80003af8:	088020ef          	jal	80005b80 <acquire>
  while(i < n){
    80003afc:	0b405a63          	blez	s4,80003bb0 <pipewrite+0xd8>
    80003b00:	f05a                	sd	s6,32(sp)
    80003b02:	ec5e                	sd	s7,24(sp)
    80003b04:	e862                	sd	s8,16(sp)
  int i = 0;
    80003b06:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003b08:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003b0a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003b0e:	21c48b93          	addi	s7,s1,540
    80003b12:	a81d                	j	80003b48 <pipewrite+0x70>
      release(&pi->lock);
    80003b14:	8526                	mv	a0,s1
    80003b16:	102020ef          	jal	80005c18 <release>
      return -1;
    80003b1a:	597d                	li	s2,-1
    80003b1c:	7b02                	ld	s6,32(sp)
    80003b1e:	6be2                	ld	s7,24(sp)
    80003b20:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003b22:	854a                	mv	a0,s2
    80003b24:	60e6                	ld	ra,88(sp)
    80003b26:	6446                	ld	s0,80(sp)
    80003b28:	64a6                	ld	s1,72(sp)
    80003b2a:	6906                	ld	s2,64(sp)
    80003b2c:	79e2                	ld	s3,56(sp)
    80003b2e:	7a42                	ld	s4,48(sp)
    80003b30:	7aa2                	ld	s5,40(sp)
    80003b32:	6125                	addi	sp,sp,96
    80003b34:	8082                	ret
      wakeup(&pi->nread);
    80003b36:	8562                	mv	a0,s8
    80003b38:	845fd0ef          	jal	8000137c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003b3c:	85a6                	mv	a1,s1
    80003b3e:	855e                	mv	a0,s7
    80003b40:	ff0fd0ef          	jal	80001330 <sleep>
  while(i < n){
    80003b44:	05495b63          	bge	s2,s4,80003b9a <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003b48:	2204a783          	lw	a5,544(s1)
    80003b4c:	d7e1                	beqz	a5,80003b14 <pipewrite+0x3c>
    80003b4e:	854e                	mv	a0,s3
    80003b50:	a19fd0ef          	jal	80001568 <killed>
    80003b54:	f161                	bnez	a0,80003b14 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003b56:	2184a783          	lw	a5,536(s1)
    80003b5a:	21c4a703          	lw	a4,540(s1)
    80003b5e:	2007879b          	addiw	a5,a5,512
    80003b62:	fcf70ae3          	beq	a4,a5,80003b36 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003b66:	4685                	li	a3,1
    80003b68:	01590633          	add	a2,s2,s5
    80003b6c:	faf40593          	addi	a1,s0,-81
    80003b70:	0509b503          	ld	a0,80(s3)
    80003b74:	f2bfc0ef          	jal	80000a9e <copyin>
    80003b78:	03650e63          	beq	a0,s6,80003bb4 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003b7c:	21c4a783          	lw	a5,540(s1)
    80003b80:	0017871b          	addiw	a4,a5,1
    80003b84:	20e4ae23          	sw	a4,540(s1)
    80003b88:	1ff7f793          	andi	a5,a5,511
    80003b8c:	97a6                	add	a5,a5,s1
    80003b8e:	faf44703          	lbu	a4,-81(s0)
    80003b92:	00e78c23          	sb	a4,24(a5)
      i++;
    80003b96:	2905                	addiw	s2,s2,1
    80003b98:	b775                	j	80003b44 <pipewrite+0x6c>
    80003b9a:	7b02                	ld	s6,32(sp)
    80003b9c:	6be2                	ld	s7,24(sp)
    80003b9e:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003ba0:	21848513          	addi	a0,s1,536
    80003ba4:	fd8fd0ef          	jal	8000137c <wakeup>
  release(&pi->lock);
    80003ba8:	8526                	mv	a0,s1
    80003baa:	06e020ef          	jal	80005c18 <release>
  return i;
    80003bae:	bf95                	j	80003b22 <pipewrite+0x4a>
  int i = 0;
    80003bb0:	4901                	li	s2,0
    80003bb2:	b7fd                	j	80003ba0 <pipewrite+0xc8>
    80003bb4:	7b02                	ld	s6,32(sp)
    80003bb6:	6be2                	ld	s7,24(sp)
    80003bb8:	6c42                	ld	s8,16(sp)
    80003bba:	b7dd                	j	80003ba0 <pipewrite+0xc8>

0000000080003bbc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003bbc:	715d                	addi	sp,sp,-80
    80003bbe:	e486                	sd	ra,72(sp)
    80003bc0:	e0a2                	sd	s0,64(sp)
    80003bc2:	fc26                	sd	s1,56(sp)
    80003bc4:	f84a                	sd	s2,48(sp)
    80003bc6:	f44e                	sd	s3,40(sp)
    80003bc8:	f052                	sd	s4,32(sp)
    80003bca:	ec56                	sd	s5,24(sp)
    80003bcc:	0880                	addi	s0,sp,80
    80003bce:	84aa                	mv	s1,a0
    80003bd0:	892e                	mv	s2,a1
    80003bd2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003bd4:	982fd0ef          	jal	80000d56 <myproc>
    80003bd8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003bda:	8526                	mv	a0,s1
    80003bdc:	7a5010ef          	jal	80005b80 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003be0:	2184a703          	lw	a4,536(s1)
    80003be4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003be8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003bec:	02f71563          	bne	a4,a5,80003c16 <piperead+0x5a>
    80003bf0:	2244a783          	lw	a5,548(s1)
    80003bf4:	cb85                	beqz	a5,80003c24 <piperead+0x68>
    if(killed(pr)){
    80003bf6:	8552                	mv	a0,s4
    80003bf8:	971fd0ef          	jal	80001568 <killed>
    80003bfc:	ed19                	bnez	a0,80003c1a <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003bfe:	85a6                	mv	a1,s1
    80003c00:	854e                	mv	a0,s3
    80003c02:	f2efd0ef          	jal	80001330 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003c06:	2184a703          	lw	a4,536(s1)
    80003c0a:	21c4a783          	lw	a5,540(s1)
    80003c0e:	fef701e3          	beq	a4,a5,80003bf0 <piperead+0x34>
    80003c12:	e85a                	sd	s6,16(sp)
    80003c14:	a809                	j	80003c26 <piperead+0x6a>
    80003c16:	e85a                	sd	s6,16(sp)
    80003c18:	a039                	j	80003c26 <piperead+0x6a>
      release(&pi->lock);
    80003c1a:	8526                	mv	a0,s1
    80003c1c:	7fd010ef          	jal	80005c18 <release>
      return -1;
    80003c20:	59fd                	li	s3,-1
    80003c22:	a8b1                	j	80003c7e <piperead+0xc2>
    80003c24:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003c26:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003c28:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003c2a:	05505263          	blez	s5,80003c6e <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003c2e:	2184a783          	lw	a5,536(s1)
    80003c32:	21c4a703          	lw	a4,540(s1)
    80003c36:	02f70c63          	beq	a4,a5,80003c6e <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003c3a:	0017871b          	addiw	a4,a5,1
    80003c3e:	20e4ac23          	sw	a4,536(s1)
    80003c42:	1ff7f793          	andi	a5,a5,511
    80003c46:	97a6                	add	a5,a5,s1
    80003c48:	0187c783          	lbu	a5,24(a5)
    80003c4c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003c50:	4685                	li	a3,1
    80003c52:	fbf40613          	addi	a2,s0,-65
    80003c56:	85ca                	mv	a1,s2
    80003c58:	050a3503          	ld	a0,80(s4)
    80003c5c:	d6bfc0ef          	jal	800009c6 <copyout>
    80003c60:	01650763          	beq	a0,s6,80003c6e <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003c64:	2985                	addiw	s3,s3,1
    80003c66:	0905                	addi	s2,s2,1
    80003c68:	fd3a93e3          	bne	s5,s3,80003c2e <piperead+0x72>
    80003c6c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003c6e:	21c48513          	addi	a0,s1,540
    80003c72:	f0afd0ef          	jal	8000137c <wakeup>
  release(&pi->lock);
    80003c76:	8526                	mv	a0,s1
    80003c78:	7a1010ef          	jal	80005c18 <release>
    80003c7c:	6b42                	ld	s6,16(sp)
  return i;
}
    80003c7e:	854e                	mv	a0,s3
    80003c80:	60a6                	ld	ra,72(sp)
    80003c82:	6406                	ld	s0,64(sp)
    80003c84:	74e2                	ld	s1,56(sp)
    80003c86:	7942                	ld	s2,48(sp)
    80003c88:	79a2                	ld	s3,40(sp)
    80003c8a:	7a02                	ld	s4,32(sp)
    80003c8c:	6ae2                	ld	s5,24(sp)
    80003c8e:	6161                	addi	sp,sp,80
    80003c90:	8082                	ret

0000000080003c92 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003c92:	1141                	addi	sp,sp,-16
    80003c94:	e422                	sd	s0,8(sp)
    80003c96:	0800                	addi	s0,sp,16
    80003c98:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003c9a:	8905                	andi	a0,a0,1
    80003c9c:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003c9e:	8b89                	andi	a5,a5,2
    80003ca0:	c399                	beqz	a5,80003ca6 <flags2perm+0x14>
      perm |= PTE_W;
    80003ca2:	00456513          	ori	a0,a0,4
    return perm;
}
    80003ca6:	6422                	ld	s0,8(sp)
    80003ca8:	0141                	addi	sp,sp,16
    80003caa:	8082                	ret

0000000080003cac <exec>:

int
exec(char *path, char **argv)
{
    80003cac:	df010113          	addi	sp,sp,-528
    80003cb0:	20113423          	sd	ra,520(sp)
    80003cb4:	20813023          	sd	s0,512(sp)
    80003cb8:	ffa6                	sd	s1,504(sp)
    80003cba:	fbca                	sd	s2,496(sp)
    80003cbc:	0c00                	addi	s0,sp,528
    80003cbe:	892a                	mv	s2,a0
    80003cc0:	dea43c23          	sd	a0,-520(s0)
    80003cc4:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003cc8:	88efd0ef          	jal	80000d56 <myproc>
    80003ccc:	84aa                	mv	s1,a0

  begin_op();
    80003cce:	dc6ff0ef          	jal	80003294 <begin_op>

  if((ip = namei(path)) == 0){
    80003cd2:	854a                	mv	a0,s2
    80003cd4:	c04ff0ef          	jal	800030d8 <namei>
    80003cd8:	c931                	beqz	a0,80003d2c <exec+0x80>
    80003cda:	f3d2                	sd	s4,480(sp)
    80003cdc:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003cde:	d21fe0ef          	jal	800029fe <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003ce2:	04000713          	li	a4,64
    80003ce6:	4681                	li	a3,0
    80003ce8:	e5040613          	addi	a2,s0,-432
    80003cec:	4581                	li	a1,0
    80003cee:	8552                	mv	a0,s4
    80003cf0:	f63fe0ef          	jal	80002c52 <readi>
    80003cf4:	04000793          	li	a5,64
    80003cf8:	00f51a63          	bne	a0,a5,80003d0c <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003cfc:	e5042703          	lw	a4,-432(s0)
    80003d00:	464c47b7          	lui	a5,0x464c4
    80003d04:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003d08:	02f70663          	beq	a4,a5,80003d34 <exec+0x88>

bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003d0c:	8552                	mv	a0,s4
    80003d0e:	efbfe0ef          	jal	80002c08 <iunlockput>
    end_op();
    80003d12:	decff0ef          	jal	800032fe <end_op>
  }
  return -1;
    80003d16:	557d                	li	a0,-1
    80003d18:	7a1e                	ld	s4,480(sp)
}
    80003d1a:	20813083          	ld	ra,520(sp)
    80003d1e:	20013403          	ld	s0,512(sp)
    80003d22:	74fe                	ld	s1,504(sp)
    80003d24:	795e                	ld	s2,496(sp)
    80003d26:	21010113          	addi	sp,sp,528
    80003d2a:	8082                	ret
    end_op();
    80003d2c:	dd2ff0ef          	jal	800032fe <end_op>
    return -1;
    80003d30:	557d                	li	a0,-1
    80003d32:	b7e5                	j	80003d1a <exec+0x6e>
    80003d34:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003d36:	8526                	mv	a0,s1
    80003d38:	8c6fd0ef          	jal	80000dfe <proc_pagetable>
    80003d3c:	8b2a                	mv	s6,a0
    80003d3e:	38050363          	beqz	a0,800040c4 <exec+0x418>
    80003d42:	f7ce                	sd	s3,488(sp)
    80003d44:	efd6                	sd	s5,472(sp)
    80003d46:	e7de                	sd	s7,456(sp)
    80003d48:	e3e2                	sd	s8,448(sp)
    80003d4a:	ff66                	sd	s9,440(sp)
    80003d4c:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d4e:	e7042d03          	lw	s10,-400(s0)
    80003d52:	e8845783          	lhu	a5,-376(s0)
    80003d56:	12078863          	beqz	a5,80003e86 <exec+0x1da>
    80003d5a:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003d5c:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d5e:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003d60:	6c85                	lui	s9,0x1
    80003d62:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003d66:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003d6a:	6a85                	lui	s5,0x1
    80003d6c:	a085                	j	80003dcc <exec+0x120>
      panic("loadseg: address should exist");
    80003d6e:	00004517          	auipc	a0,0x4
    80003d72:	99a50513          	addi	a0,a0,-1638 # 80007708 <etext+0x708>
    80003d76:	2dd010ef          	jal	80005852 <panic>
    if(sz - i < PGSIZE)
    80003d7a:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003d7c:	8726                	mv	a4,s1
    80003d7e:	012c06bb          	addw	a3,s8,s2
    80003d82:	4581                	li	a1,0
    80003d84:	8552                	mv	a0,s4
    80003d86:	ecdfe0ef          	jal	80002c52 <readi>
    80003d8a:	2501                	sext.w	a0,a0
    80003d8c:	30a49263          	bne	s1,a0,80004090 <exec+0x3e4>
  for(i = 0; i < sz; i += PGSIZE){
    80003d90:	012a893b          	addw	s2,s5,s2
    80003d94:	03397363          	bgeu	s2,s3,80003dba <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003d98:	02091593          	slli	a1,s2,0x20
    80003d9c:	9181                	srli	a1,a1,0x20
    80003d9e:	95de                	add	a1,a1,s7
    80003da0:	855a                	mv	a0,s6
    80003da2:	ea0fc0ef          	jal	80000442 <walkaddr>
    80003da6:	862a                	mv	a2,a0
    if(pa == 0)
    80003da8:	d179                	beqz	a0,80003d6e <exec+0xc2>
    if(sz - i < PGSIZE)
    80003daa:	412984bb          	subw	s1,s3,s2
    80003dae:	0004879b          	sext.w	a5,s1
    80003db2:	fcfcf4e3          	bgeu	s9,a5,80003d7a <exec+0xce>
    80003db6:	84d6                	mv	s1,s5
    80003db8:	b7c9                	j	80003d7a <exec+0xce>
    sz = sz1;
    80003dba:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003dbe:	2d85                	addiw	s11,s11,1
    80003dc0:	038d0d1b          	addiw	s10,s10,56
    80003dc4:	e8845783          	lhu	a5,-376(s0)
    80003dc8:	08fdd063          	bge	s11,a5,80003e48 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003dcc:	2d01                	sext.w	s10,s10
    80003dce:	03800713          	li	a4,56
    80003dd2:	86ea                	mv	a3,s10
    80003dd4:	e1840613          	addi	a2,s0,-488
    80003dd8:	4581                	li	a1,0
    80003dda:	8552                	mv	a0,s4
    80003ddc:	e77fe0ef          	jal	80002c52 <readi>
    80003de0:	03800793          	li	a5,56
    80003de4:	26f51c63          	bne	a0,a5,8000405c <exec+0x3b0>
    if(ph.type != ELF_PROG_LOAD)
    80003de8:	e1842783          	lw	a5,-488(s0)
    80003dec:	4705                	li	a4,1
    80003dee:	fce798e3          	bne	a5,a4,80003dbe <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003df2:	e4043903          	ld	s2,-448(s0)
    80003df6:	e3843783          	ld	a5,-456(s0)
    80003dfa:	26f96563          	bltu	s2,a5,80004064 <exec+0x3b8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003dfe:	e2843783          	ld	a5,-472(s0)
    80003e02:	993e                	add	s2,s2,a5
    80003e04:	26f96463          	bltu	s2,a5,8000406c <exec+0x3c0>
    if(ph.vaddr % PGSIZE != 0)
    80003e08:	df043703          	ld	a4,-528(s0)
    80003e0c:	8ff9                	and	a5,a5,a4
    80003e0e:	26079363          	bnez	a5,80004074 <exec+0x3c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003e12:	e1c42503          	lw	a0,-484(s0)
    80003e16:	e7dff0ef          	jal	80003c92 <flags2perm>
    80003e1a:	86aa                	mv	a3,a0
    80003e1c:	864a                	mv	a2,s2
    80003e1e:	85a6                	mv	a1,s1
    80003e20:	855a                	mv	a0,s6
    80003e22:	999fc0ef          	jal	800007ba <uvmalloc>
    80003e26:	e0a43423          	sd	a0,-504(s0)
    80003e2a:	24050963          	beqz	a0,8000407c <exec+0x3d0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003e2e:	e2843b83          	ld	s7,-472(s0)
    80003e32:	e2042c03          	lw	s8,-480(s0)
    80003e36:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003e3a:	00098463          	beqz	s3,80003e42 <exec+0x196>
    80003e3e:	4901                	li	s2,0
    80003e40:	bfa1                	j	80003d98 <exec+0xec>
    sz = sz1;
    80003e42:	e0843483          	ld	s1,-504(s0)
    80003e46:	bfa5                	j	80003dbe <exec+0x112>
    80003e48:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003e4a:	8552                	mv	a0,s4
    80003e4c:	dbdfe0ef          	jal	80002c08 <iunlockput>
  end_op();
    80003e50:	caeff0ef          	jal	800032fe <end_op>
  p = myproc();
    80003e54:	f03fc0ef          	jal	80000d56 <myproc>
    80003e58:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80003e5a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003e5e:	6905                	lui	s2,0x1
    80003e60:	197d                	addi	s2,s2,-1 # fff <_entry-0x7ffff001>
    80003e62:	9926                	add	s2,s2,s1
    80003e64:	77fd                	lui	a5,0xfffff
    80003e66:	00f97933          	and	s2,s2,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003e6a:	4691                	li	a3,4
    80003e6c:	6609                	lui	a2,0x2
    80003e6e:	964a                	add	a2,a2,s2
    80003e70:	85ca                	mv	a1,s2
    80003e72:	855a                	mv	a0,s6
    80003e74:	947fc0ef          	jal	800007ba <uvmalloc>
    80003e78:	e0a43423          	sd	a0,-504(s0)
    80003e7c:	e519                	bnez	a0,80003e8a <exec+0x1de>
  if(pagetable)
    80003e7e:	e1243423          	sd	s2,-504(s0)
    80003e82:	4a01                	li	s4,0
    80003e84:	a439                	j	80004092 <exec+0x3e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003e86:	4481                	li	s1,0
    80003e88:	b7c9                	j	80003e4a <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003e8a:	75f9                	lui	a1,0xffffe
    80003e8c:	892a                	mv	s2,a0
    80003e8e:	95aa                	add	a1,a1,a0
    80003e90:	855a                	mv	a0,s6
    80003e92:	b0bfc0ef          	jal	8000099c <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003e96:	7c7d                	lui	s8,0xfffff
    80003e98:	9c4a                	add	s8,s8,s2
  for(argc = 0; argv[argc]; argc++) {
    80003e9a:	e0043983          	ld	s3,-512(s0)
    80003e9e:	0009b503          	ld	a0,0(s3)
    80003ea2:	22050663          	beqz	a0,800040ce <exec+0x422>
    80003ea6:	e9040a13          	addi	s4,s0,-368
    80003eaa:	4a81                	li	s5,0
    if(argc >= MAXARG)
    80003eac:	02000c93          	li	s9,32
    sp -= strlen(argv[argc]) + 1;
    80003eb0:	bf4fc0ef          	jal	800002a4 <strlen>
    80003eb4:	0015079b          	addiw	a5,a0,1
    80003eb8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003ebc:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003ec0:	1d896463          	bltu	s2,s8,80004088 <exec+0x3dc>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003ec4:	0009b483          	ld	s1,0(s3)
    80003ec8:	8526                	mv	a0,s1
    80003eca:	bdafc0ef          	jal	800002a4 <strlen>
    80003ece:	0015069b          	addiw	a3,a0,1
    80003ed2:	8626                	mv	a2,s1
    80003ed4:	85ca                	mv	a1,s2
    80003ed6:	855a                	mv	a0,s6
    80003ed8:	aeffc0ef          	jal	800009c6 <copyout>
    80003edc:	1a054863          	bltz	a0,8000408c <exec+0x3e0>
    ustack[argc] = sp;
    80003ee0:	012a3023          	sd	s2,0(s4)
  for(argc = 0; argv[argc]; argc++) {
    80003ee4:	001a8493          	addi	s1,s5,1 # 1001 <_entry-0x7fffefff>
    80003ee8:	09a1                	addi	s3,s3,8
    80003eea:	0009b503          	ld	a0,0(s3)
    80003eee:	c511                	beqz	a0,80003efa <exec+0x24e>
    if(argc >= MAXARG)
    80003ef0:	0a21                	addi	s4,s4,8
    80003ef2:	19948963          	beq	s1,s9,80004084 <exec+0x3d8>
    80003ef6:	8aa6                	mv	s5,s1
    80003ef8:	bf65                	j	80003eb0 <exec+0x204>
  ustack[argc] = 0;
    80003efa:	00349793          	slli	a5,s1,0x3
    80003efe:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb250>
    80003f02:	97a2                	add	a5,a5,s0
    80003f04:	f007b023          	sd	zero,-256(a5)
    80003f08:	e0043a03          	ld	s4,-512(s0)
    80003f0c:	4981                	li	s3,0
  if (strncmp(argv[i], "--trace-mask", 12) == 0 && i + 1 < argc) {  // Added 12 as the length
    80003f0e:	00004c97          	auipc	s9,0x4
    80003f12:	81ac8c93          	addi	s9,s9,-2022 # 80007728 <etext+0x728>
    80003f16:	a069                	j	80003fa0 <exec+0x2f4>
    char *mask_str = argv[i + 1];
    80003f18:	00198793          	addi	a5,s3,1
    80003f1c:	078e                	slli	a5,a5,0x3
    80003f1e:	e0043683          	ld	a3,-512(s0)
    80003f22:	97b6                	add	a5,a5,a3
    80003f24:	6390                	ld	a2,0(a5)
    while (*mask_str && *mask_str >= '0' && *mask_str <= '9') {
    80003f26:	00064783          	lbu	a5,0(a2) # 2000 <_entry-0x7fffe000>
    80003f2a:	fd07869b          	addiw	a3,a5,-48
    80003f2e:	0ff6f693          	zext.b	a3,a3
    80003f32:	45a5                	li	a1,9
    80003f34:	02d5e463          	bltu	a1,a3,80003f5c <exec+0x2b0>
      mask = mask * 10 + (*mask_str - '0');
    80003f38:	0025169b          	slliw	a3,a0,0x2
    80003f3c:	9ea9                	addw	a3,a3,a0
    80003f3e:	0016969b          	slliw	a3,a3,0x1
    80003f42:	fd07879b          	addiw	a5,a5,-48
    80003f46:	00d7853b          	addw	a0,a5,a3
      mask_str++;
    80003f4a:	0605                	addi	a2,a2,1
    while (*mask_str && *mask_str >= '0' && *mask_str <= '9') {
    80003f4c:	00064783          	lbu	a5,0(a2)
    80003f50:	fd07869b          	addiw	a3,a5,-48
    80003f54:	0ff6f693          	zext.b	a3,a3
    80003f58:	fed5f0e3          	bgeu	a1,a3,80003f38 <exec+0x28c>
    80003f5c:	00349693          	slli	a3,s1,0x3
      p->trace_mask = mask;
    80003f60:	16aba423          	sw	a0,360(s7)
      for (int j = i; j < argc - 2; j++) {
    80003f64:	fffa8493          	addi	s1,s5,-1
    80003f68:	00977e63          	bgeu	a4,s1,80003f84 <exec+0x2d8>
    80003f6c:	00371793          	slli	a5,a4,0x3
    80003f70:	e0043703          	ld	a4,-512(s0)
    80003f74:	97ba                	add	a5,a5,a4
    80003f76:	9736                	add	a4,a4,a3
    80003f78:	1741                	addi	a4,a4,-16
        argv[j] = argv[j + 2];
    80003f7a:	6b90                	ld	a2,16(a5)
    80003f7c:	e390                	sd	a2,0(a5)
      for (int j = i; j < argc - 2; j++) {
    80003f7e:	07a1                	addi	a5,a5,8
    80003f80:	fee79de3          	bne	a5,a4,80003f7a <exec+0x2ce>
      argv[argc - 2] = 0;
    80003f84:	e0043783          	ld	a5,-512(s0)
    80003f88:	97b6                	add	a5,a5,a3
    80003f8a:	fe07b823          	sd	zero,-16(a5)
      argv[argc - 1] = 0;
    80003f8e:	fe07bc23          	sd	zero,-8(a5)
      break;
    80003f92:	a025                	j	80003fba <exec+0x30e>
for (int i = 0; i < argc; i++) {
    80003f94:	00198793          	addi	a5,s3,1
    80003f98:	0a21                	addi	s4,s4,8
    80003f9a:	073a8063          	beq	s5,s3,80003ffa <exec+0x34e>
    80003f9e:	89be                	mv	s3,a5
  if (strncmp(argv[i], "--trace-mask", 12) == 0 && i + 1 < argc) {  // Added 12 as the length
    80003fa0:	4631                	li	a2,12
    80003fa2:	85e6                	mv	a1,s9
    80003fa4:	000a3503          	ld	a0,0(s4)
    80003fa8:	a58fc0ef          	jal	80000200 <strncmp>
    80003fac:	f565                	bnez	a0,80003f94 <exec+0x2e8>
    80003fae:	0009871b          	sext.w	a4,s3
    80003fb2:	0019879b          	addiw	a5,s3,1
    80003fb6:	f697e1e3          	bltu	a5,s1,80003f18 <exec+0x26c>
  sp -= (argc+1) * sizeof(uint64);
    80003fba:	00148693          	addi	a3,s1,1
    80003fbe:	068e                	slli	a3,a3,0x3
    80003fc0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003fc4:	ff097993          	andi	s3,s2,-16
  sz = sz1;
    80003fc8:	e0843903          	ld	s2,-504(s0)
  if(sp < stackbase)
    80003fcc:	eb89e9e3          	bltu	s3,s8,80003e7e <exec+0x1d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003fd0:	e9040613          	addi	a2,s0,-368
    80003fd4:	85ce                	mv	a1,s3
    80003fd6:	855a                	mv	a0,s6
    80003fd8:	9effc0ef          	jal	800009c6 <copyout>
    80003fdc:	0e054663          	bltz	a0,800040c8 <exec+0x41c>
  p->trapframe->a1 = sp;
    80003fe0:	058bb783          	ld	a5,88(s7)
    80003fe4:	0737bc23          	sd	s3,120(a5)
  for(last=s=path; *s; s++)
    80003fe8:	df843783          	ld	a5,-520(s0)
    80003fec:	0007c703          	lbu	a4,0(a5)
    80003ff0:	c305                	beqz	a4,80004010 <exec+0x364>
    80003ff2:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003ff4:	02f00693          	li	a3,47
    80003ff8:	a809                	j	8000400a <exec+0x35e>
    80003ffa:	84be                	mv	s1,a5
    80003ffc:	bf7d                	j	80003fba <exec+0x30e>
      last = s+1;
    80003ffe:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004002:	0785                	addi	a5,a5,1
    80004004:	fff7c703          	lbu	a4,-1(a5)
    80004008:	c701                	beqz	a4,80004010 <exec+0x364>
    if(*s == '/')
    8000400a:	fed71ce3          	bne	a4,a3,80004002 <exec+0x356>
    8000400e:	bfc5                	j	80003ffe <exec+0x352>
  safestrcpy(p->name, last, sizeof(p->name));
    80004010:	4641                	li	a2,16
    80004012:	df843583          	ld	a1,-520(s0)
    80004016:	158b8513          	addi	a0,s7,344
    8000401a:	a58fc0ef          	jal	80000272 <safestrcpy>
  oldpagetable = p->pagetable;
    8000401e:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004022:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004026:	e0843783          	ld	a5,-504(s0)
    8000402a:	04fbb423          	sd	a5,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000402e:	058bb783          	ld	a5,88(s7)
    80004032:	e6843703          	ld	a4,-408(s0)
    80004036:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004038:	058bb783          	ld	a5,88(s7)
    8000403c:	0337b823          	sd	s3,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004040:	85ea                	mv	a1,s10
    80004042:	e41fc0ef          	jal	80000e82 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004046:	0004851b          	sext.w	a0,s1
    8000404a:	79be                	ld	s3,488(sp)
    8000404c:	7a1e                	ld	s4,480(sp)
    8000404e:	6afe                	ld	s5,472(sp)
    80004050:	6b5e                	ld	s6,464(sp)
    80004052:	6bbe                	ld	s7,456(sp)
    80004054:	6c1e                	ld	s8,448(sp)
    80004056:	7cfa                	ld	s9,440(sp)
    80004058:	7d5a                	ld	s10,432(sp)
    8000405a:	b1c1                	j	80003d1a <exec+0x6e>
    8000405c:	e0943423          	sd	s1,-504(s0)
    80004060:	7dba                	ld	s11,424(sp)
    80004062:	a805                	j	80004092 <exec+0x3e6>
    80004064:	e0943423          	sd	s1,-504(s0)
    80004068:	7dba                	ld	s11,424(sp)
    8000406a:	a025                	j	80004092 <exec+0x3e6>
    8000406c:	e0943423          	sd	s1,-504(s0)
    80004070:	7dba                	ld	s11,424(sp)
    80004072:	a005                	j	80004092 <exec+0x3e6>
    80004074:	e0943423          	sd	s1,-504(s0)
    80004078:	7dba                	ld	s11,424(sp)
    8000407a:	a821                	j	80004092 <exec+0x3e6>
    8000407c:	e0943423          	sd	s1,-504(s0)
    80004080:	7dba                	ld	s11,424(sp)
    80004082:	a801                	j	80004092 <exec+0x3e6>
  ip = 0;
    80004084:	4a01                	li	s4,0
    80004086:	a031                	j	80004092 <exec+0x3e6>
    80004088:	4a01                	li	s4,0
    8000408a:	a021                	j	80004092 <exec+0x3e6>
    8000408c:	4a01                	li	s4,0
  if(pagetable)
    8000408e:	a011                	j	80004092 <exec+0x3e6>
    80004090:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004092:	e0843583          	ld	a1,-504(s0)
    80004096:	855a                	mv	a0,s6
    80004098:	debfc0ef          	jal	80000e82 <proc_freepagetable>
  return -1;
    8000409c:	557d                	li	a0,-1
  if(ip){
    8000409e:	000a1b63          	bnez	s4,800040b4 <exec+0x408>
    800040a2:	79be                	ld	s3,488(sp)
    800040a4:	7a1e                	ld	s4,480(sp)
    800040a6:	6afe                	ld	s5,472(sp)
    800040a8:	6b5e                	ld	s6,464(sp)
    800040aa:	6bbe                	ld	s7,456(sp)
    800040ac:	6c1e                	ld	s8,448(sp)
    800040ae:	7cfa                	ld	s9,440(sp)
    800040b0:	7d5a                	ld	s10,432(sp)
    800040b2:	b1a5                	j	80003d1a <exec+0x6e>
    800040b4:	79be                	ld	s3,488(sp)
    800040b6:	6afe                	ld	s5,472(sp)
    800040b8:	6b5e                	ld	s6,464(sp)
    800040ba:	6bbe                	ld	s7,456(sp)
    800040bc:	6c1e                	ld	s8,448(sp)
    800040be:	7cfa                	ld	s9,440(sp)
    800040c0:	7d5a                	ld	s10,432(sp)
    800040c2:	b1a9                	j	80003d0c <exec+0x60>
    800040c4:	6b5e                	ld	s6,464(sp)
    800040c6:	b199                	j	80003d0c <exec+0x60>
  sz = sz1;
    800040c8:	e0843903          	ld	s2,-504(s0)
    800040cc:	bb4d                	j	80003e7e <exec+0x1d2>
  ustack[argc] = 0;
    800040ce:	e8043823          	sd	zero,-368(s0)
  sp = sz;
    800040d2:	e0843903          	ld	s2,-504(s0)
  ustack[argc] = 0;
    800040d6:	4481                	li	s1,0
    800040d8:	b5cd                	j	80003fba <exec+0x30e>

00000000800040da <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800040da:	7179                	addi	sp,sp,-48
    800040dc:	f406                	sd	ra,40(sp)
    800040de:	f022                	sd	s0,32(sp)
    800040e0:	ec26                	sd	s1,24(sp)
    800040e2:	e84a                	sd	s2,16(sp)
    800040e4:	1800                	addi	s0,sp,48
    800040e6:	892e                	mv	s2,a1
    800040e8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800040ea:	fdc40593          	addi	a1,s0,-36
    800040ee:	bebfd0ef          	jal	80001cd8 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800040f2:	fdc42703          	lw	a4,-36(s0)
    800040f6:	47bd                	li	a5,15
    800040f8:	02e7e963          	bltu	a5,a4,8000412a <argfd+0x50>
    800040fc:	c5bfc0ef          	jal	80000d56 <myproc>
    80004100:	fdc42703          	lw	a4,-36(s0)
    80004104:	01a70793          	addi	a5,a4,26
    80004108:	078e                	slli	a5,a5,0x3
    8000410a:	953e                	add	a0,a0,a5
    8000410c:	611c                	ld	a5,0(a0)
    8000410e:	c385                	beqz	a5,8000412e <argfd+0x54>
    return -1;
  if(pfd)
    80004110:	00090463          	beqz	s2,80004118 <argfd+0x3e>
    *pfd = fd;
    80004114:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004118:	4501                	li	a0,0
  if(pf)
    8000411a:	c091                	beqz	s1,8000411e <argfd+0x44>
    *pf = f;
    8000411c:	e09c                	sd	a5,0(s1)
}
    8000411e:	70a2                	ld	ra,40(sp)
    80004120:	7402                	ld	s0,32(sp)
    80004122:	64e2                	ld	s1,24(sp)
    80004124:	6942                	ld	s2,16(sp)
    80004126:	6145                	addi	sp,sp,48
    80004128:	8082                	ret
    return -1;
    8000412a:	557d                	li	a0,-1
    8000412c:	bfcd                	j	8000411e <argfd+0x44>
    8000412e:	557d                	li	a0,-1
    80004130:	b7fd                	j	8000411e <argfd+0x44>

0000000080004132 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004132:	1101                	addi	sp,sp,-32
    80004134:	ec06                	sd	ra,24(sp)
    80004136:	e822                	sd	s0,16(sp)
    80004138:	e426                	sd	s1,8(sp)
    8000413a:	1000                	addi	s0,sp,32
    8000413c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000413e:	c19fc0ef          	jal	80000d56 <myproc>
    80004142:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004144:	0d050793          	addi	a5,a0,208
    80004148:	4501                	li	a0,0
    8000414a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000414c:	6398                	ld	a4,0(a5)
    8000414e:	cb19                	beqz	a4,80004164 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004150:	2505                	addiw	a0,a0,1
    80004152:	07a1                	addi	a5,a5,8
    80004154:	fed51ce3          	bne	a0,a3,8000414c <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004158:	557d                	li	a0,-1
}
    8000415a:	60e2                	ld	ra,24(sp)
    8000415c:	6442                	ld	s0,16(sp)
    8000415e:	64a2                	ld	s1,8(sp)
    80004160:	6105                	addi	sp,sp,32
    80004162:	8082                	ret
      p->ofile[fd] = f;
    80004164:	01a50793          	addi	a5,a0,26
    80004168:	078e                	slli	a5,a5,0x3
    8000416a:	963e                	add	a2,a2,a5
    8000416c:	e204                	sd	s1,0(a2)
      return fd;
    8000416e:	b7f5                	j	8000415a <fdalloc+0x28>

0000000080004170 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004170:	715d                	addi	sp,sp,-80
    80004172:	e486                	sd	ra,72(sp)
    80004174:	e0a2                	sd	s0,64(sp)
    80004176:	fc26                	sd	s1,56(sp)
    80004178:	f84a                	sd	s2,48(sp)
    8000417a:	f44e                	sd	s3,40(sp)
    8000417c:	ec56                	sd	s5,24(sp)
    8000417e:	e85a                	sd	s6,16(sp)
    80004180:	0880                	addi	s0,sp,80
    80004182:	8b2e                	mv	s6,a1
    80004184:	89b2                	mv	s3,a2
    80004186:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004188:	fb040593          	addi	a1,s0,-80
    8000418c:	f67fe0ef          	jal	800030f2 <nameiparent>
    80004190:	84aa                	mv	s1,a0
    80004192:	10050a63          	beqz	a0,800042a6 <create+0x136>
    return 0;

  ilock(dp);
    80004196:	869fe0ef          	jal	800029fe <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000419a:	4601                	li	a2,0
    8000419c:	fb040593          	addi	a1,s0,-80
    800041a0:	8526                	mv	a0,s1
    800041a2:	cd1fe0ef          	jal	80002e72 <dirlookup>
    800041a6:	8aaa                	mv	s5,a0
    800041a8:	c129                	beqz	a0,800041ea <create+0x7a>
    iunlockput(dp);
    800041aa:	8526                	mv	a0,s1
    800041ac:	a5dfe0ef          	jal	80002c08 <iunlockput>
    ilock(ip);
    800041b0:	8556                	mv	a0,s5
    800041b2:	84dfe0ef          	jal	800029fe <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800041b6:	4789                	li	a5,2
    800041b8:	02fb1463          	bne	s6,a5,800041e0 <create+0x70>
    800041bc:	044ad783          	lhu	a5,68(s5)
    800041c0:	37f9                	addiw	a5,a5,-2
    800041c2:	17c2                	slli	a5,a5,0x30
    800041c4:	93c1                	srli	a5,a5,0x30
    800041c6:	4705                	li	a4,1
    800041c8:	00f76c63          	bltu	a4,a5,800041e0 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800041cc:	8556                	mv	a0,s5
    800041ce:	60a6                	ld	ra,72(sp)
    800041d0:	6406                	ld	s0,64(sp)
    800041d2:	74e2                	ld	s1,56(sp)
    800041d4:	7942                	ld	s2,48(sp)
    800041d6:	79a2                	ld	s3,40(sp)
    800041d8:	6ae2                	ld	s5,24(sp)
    800041da:	6b42                	ld	s6,16(sp)
    800041dc:	6161                	addi	sp,sp,80
    800041de:	8082                	ret
    iunlockput(ip);
    800041e0:	8556                	mv	a0,s5
    800041e2:	a27fe0ef          	jal	80002c08 <iunlockput>
    return 0;
    800041e6:	4a81                	li	s5,0
    800041e8:	b7d5                	j	800041cc <create+0x5c>
    800041ea:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800041ec:	85da                	mv	a1,s6
    800041ee:	4088                	lw	a0,0(s1)
    800041f0:	e9efe0ef          	jal	8000288e <ialloc>
    800041f4:	8a2a                	mv	s4,a0
    800041f6:	cd15                	beqz	a0,80004232 <create+0xc2>
  ilock(ip);
    800041f8:	807fe0ef          	jal	800029fe <ilock>
  ip->major = major;
    800041fc:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004200:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004204:	4905                	li	s2,1
    80004206:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000420a:	8552                	mv	a0,s4
    8000420c:	f3efe0ef          	jal	8000294a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004210:	032b0763          	beq	s6,s2,8000423e <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004214:	004a2603          	lw	a2,4(s4)
    80004218:	fb040593          	addi	a1,s0,-80
    8000421c:	8526                	mv	a0,s1
    8000421e:	e21fe0ef          	jal	8000303e <dirlink>
    80004222:	06054563          	bltz	a0,8000428c <create+0x11c>
  iunlockput(dp);
    80004226:	8526                	mv	a0,s1
    80004228:	9e1fe0ef          	jal	80002c08 <iunlockput>
  return ip;
    8000422c:	8ad2                	mv	s5,s4
    8000422e:	7a02                	ld	s4,32(sp)
    80004230:	bf71                	j	800041cc <create+0x5c>
    iunlockput(dp);
    80004232:	8526                	mv	a0,s1
    80004234:	9d5fe0ef          	jal	80002c08 <iunlockput>
    return 0;
    80004238:	8ad2                	mv	s5,s4
    8000423a:	7a02                	ld	s4,32(sp)
    8000423c:	bf41                	j	800041cc <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000423e:	004a2603          	lw	a2,4(s4)
    80004242:	00003597          	auipc	a1,0x3
    80004246:	4f658593          	addi	a1,a1,1270 # 80007738 <etext+0x738>
    8000424a:	8552                	mv	a0,s4
    8000424c:	df3fe0ef          	jal	8000303e <dirlink>
    80004250:	02054e63          	bltz	a0,8000428c <create+0x11c>
    80004254:	40d0                	lw	a2,4(s1)
    80004256:	00003597          	auipc	a1,0x3
    8000425a:	4ea58593          	addi	a1,a1,1258 # 80007740 <etext+0x740>
    8000425e:	8552                	mv	a0,s4
    80004260:	ddffe0ef          	jal	8000303e <dirlink>
    80004264:	02054463          	bltz	a0,8000428c <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004268:	004a2603          	lw	a2,4(s4)
    8000426c:	fb040593          	addi	a1,s0,-80
    80004270:	8526                	mv	a0,s1
    80004272:	dcdfe0ef          	jal	8000303e <dirlink>
    80004276:	00054b63          	bltz	a0,8000428c <create+0x11c>
    dp->nlink++;  // for ".."
    8000427a:	04a4d783          	lhu	a5,74(s1)
    8000427e:	2785                	addiw	a5,a5,1
    80004280:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004284:	8526                	mv	a0,s1
    80004286:	ec4fe0ef          	jal	8000294a <iupdate>
    8000428a:	bf71                	j	80004226 <create+0xb6>
  ip->nlink = 0;
    8000428c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004290:	8552                	mv	a0,s4
    80004292:	eb8fe0ef          	jal	8000294a <iupdate>
  iunlockput(ip);
    80004296:	8552                	mv	a0,s4
    80004298:	971fe0ef          	jal	80002c08 <iunlockput>
  iunlockput(dp);
    8000429c:	8526                	mv	a0,s1
    8000429e:	96bfe0ef          	jal	80002c08 <iunlockput>
  return 0;
    800042a2:	7a02                	ld	s4,32(sp)
    800042a4:	b725                	j	800041cc <create+0x5c>
    return 0;
    800042a6:	8aaa                	mv	s5,a0
    800042a8:	b715                	j	800041cc <create+0x5c>

00000000800042aa <sys_dup>:
{
    800042aa:	7179                	addi	sp,sp,-48
    800042ac:	f406                	sd	ra,40(sp)
    800042ae:	f022                	sd	s0,32(sp)
    800042b0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800042b2:	fd840613          	addi	a2,s0,-40
    800042b6:	4581                	li	a1,0
    800042b8:	4501                	li	a0,0
    800042ba:	e21ff0ef          	jal	800040da <argfd>
    return -1;
    800042be:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800042c0:	02054363          	bltz	a0,800042e6 <sys_dup+0x3c>
    800042c4:	ec26                	sd	s1,24(sp)
    800042c6:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800042c8:	fd843903          	ld	s2,-40(s0)
    800042cc:	854a                	mv	a0,s2
    800042ce:	e65ff0ef          	jal	80004132 <fdalloc>
    800042d2:	84aa                	mv	s1,a0
    return -1;
    800042d4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800042d6:	00054d63          	bltz	a0,800042f0 <sys_dup+0x46>
  filedup(f);
    800042da:	854a                	mv	a0,s2
    800042dc:	b8cff0ef          	jal	80003668 <filedup>
  return fd;
    800042e0:	87a6                	mv	a5,s1
    800042e2:	64e2                	ld	s1,24(sp)
    800042e4:	6942                	ld	s2,16(sp)
}
    800042e6:	853e                	mv	a0,a5
    800042e8:	70a2                	ld	ra,40(sp)
    800042ea:	7402                	ld	s0,32(sp)
    800042ec:	6145                	addi	sp,sp,48
    800042ee:	8082                	ret
    800042f0:	64e2                	ld	s1,24(sp)
    800042f2:	6942                	ld	s2,16(sp)
    800042f4:	bfcd                	j	800042e6 <sys_dup+0x3c>

00000000800042f6 <sys_read>:
{
    800042f6:	7179                	addi	sp,sp,-48
    800042f8:	f406                	sd	ra,40(sp)
    800042fa:	f022                	sd	s0,32(sp)
    800042fc:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800042fe:	fd840593          	addi	a1,s0,-40
    80004302:	4505                	li	a0,1
    80004304:	a77fd0ef          	jal	80001d7a <argaddr>
  argint(2, &n);
    80004308:	fe440593          	addi	a1,s0,-28
    8000430c:	4509                	li	a0,2
    8000430e:	9cbfd0ef          	jal	80001cd8 <argint>
  if(argfd(0, 0, &f) < 0)
    80004312:	fe840613          	addi	a2,s0,-24
    80004316:	4581                	li	a1,0
    80004318:	4501                	li	a0,0
    8000431a:	dc1ff0ef          	jal	800040da <argfd>
    8000431e:	87aa                	mv	a5,a0
    return -1;
    80004320:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004322:	0007ca63          	bltz	a5,80004336 <sys_read+0x40>
  return fileread(f, p, n);
    80004326:	fe442603          	lw	a2,-28(s0)
    8000432a:	fd843583          	ld	a1,-40(s0)
    8000432e:	fe843503          	ld	a0,-24(s0)
    80004332:	c9cff0ef          	jal	800037ce <fileread>
}
    80004336:	70a2                	ld	ra,40(sp)
    80004338:	7402                	ld	s0,32(sp)
    8000433a:	6145                	addi	sp,sp,48
    8000433c:	8082                	ret

000000008000433e <sys_write>:
{
    8000433e:	7179                	addi	sp,sp,-48
    80004340:	f406                	sd	ra,40(sp)
    80004342:	f022                	sd	s0,32(sp)
    80004344:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004346:	fd840593          	addi	a1,s0,-40
    8000434a:	4505                	li	a0,1
    8000434c:	a2ffd0ef          	jal	80001d7a <argaddr>
  argint(2, &n);
    80004350:	fe440593          	addi	a1,s0,-28
    80004354:	4509                	li	a0,2
    80004356:	983fd0ef          	jal	80001cd8 <argint>
  if(argfd(0, 0, &f) < 0)
    8000435a:	fe840613          	addi	a2,s0,-24
    8000435e:	4581                	li	a1,0
    80004360:	4501                	li	a0,0
    80004362:	d79ff0ef          	jal	800040da <argfd>
    80004366:	87aa                	mv	a5,a0
    return -1;
    80004368:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000436a:	0007ca63          	bltz	a5,8000437e <sys_write+0x40>
  return filewrite(f, p, n);
    8000436e:	fe442603          	lw	a2,-28(s0)
    80004372:	fd843583          	ld	a1,-40(s0)
    80004376:	fe843503          	ld	a0,-24(s0)
    8000437a:	d12ff0ef          	jal	8000388c <filewrite>
}
    8000437e:	70a2                	ld	ra,40(sp)
    80004380:	7402                	ld	s0,32(sp)
    80004382:	6145                	addi	sp,sp,48
    80004384:	8082                	ret

0000000080004386 <sys_close>:
{
    80004386:	1101                	addi	sp,sp,-32
    80004388:	ec06                	sd	ra,24(sp)
    8000438a:	e822                	sd	s0,16(sp)
    8000438c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000438e:	fe040613          	addi	a2,s0,-32
    80004392:	fec40593          	addi	a1,s0,-20
    80004396:	4501                	li	a0,0
    80004398:	d43ff0ef          	jal	800040da <argfd>
    return -1;
    8000439c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000439e:	02054063          	bltz	a0,800043be <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    800043a2:	9b5fc0ef          	jal	80000d56 <myproc>
    800043a6:	fec42783          	lw	a5,-20(s0)
    800043aa:	07e9                	addi	a5,a5,26
    800043ac:	078e                	slli	a5,a5,0x3
    800043ae:	953e                	add	a0,a0,a5
    800043b0:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800043b4:	fe043503          	ld	a0,-32(s0)
    800043b8:	af6ff0ef          	jal	800036ae <fileclose>
  return 0;
    800043bc:	4781                	li	a5,0
}
    800043be:	853e                	mv	a0,a5
    800043c0:	60e2                	ld	ra,24(sp)
    800043c2:	6442                	ld	s0,16(sp)
    800043c4:	6105                	addi	sp,sp,32
    800043c6:	8082                	ret

00000000800043c8 <sys_fstat>:
{
    800043c8:	1101                	addi	sp,sp,-32
    800043ca:	ec06                	sd	ra,24(sp)
    800043cc:	e822                	sd	s0,16(sp)
    800043ce:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800043d0:	fe040593          	addi	a1,s0,-32
    800043d4:	4505                	li	a0,1
    800043d6:	9a5fd0ef          	jal	80001d7a <argaddr>
  if(argfd(0, 0, &f) < 0)
    800043da:	fe840613          	addi	a2,s0,-24
    800043de:	4581                	li	a1,0
    800043e0:	4501                	li	a0,0
    800043e2:	cf9ff0ef          	jal	800040da <argfd>
    800043e6:	87aa                	mv	a5,a0
    return -1;
    800043e8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800043ea:	0007c863          	bltz	a5,800043fa <sys_fstat+0x32>
  return filestat(f, st);
    800043ee:	fe043583          	ld	a1,-32(s0)
    800043f2:	fe843503          	ld	a0,-24(s0)
    800043f6:	b7aff0ef          	jal	80003770 <filestat>
}
    800043fa:	60e2                	ld	ra,24(sp)
    800043fc:	6442                	ld	s0,16(sp)
    800043fe:	6105                	addi	sp,sp,32
    80004400:	8082                	ret

0000000080004402 <sys_link>:
{
    80004402:	7169                	addi	sp,sp,-304
    80004404:	f606                	sd	ra,296(sp)
    80004406:	f222                	sd	s0,288(sp)
    80004408:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000440a:	08000613          	li	a2,128
    8000440e:	ed040593          	addi	a1,s0,-304
    80004412:	4501                	li	a0,0
    80004414:	97bfd0ef          	jal	80001d8e <argstr>
    return -1;
    80004418:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000441a:	0c054e63          	bltz	a0,800044f6 <sys_link+0xf4>
    8000441e:	08000613          	li	a2,128
    80004422:	f5040593          	addi	a1,s0,-176
    80004426:	4505                	li	a0,1
    80004428:	967fd0ef          	jal	80001d8e <argstr>
    return -1;
    8000442c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000442e:	0c054463          	bltz	a0,800044f6 <sys_link+0xf4>
    80004432:	ee26                	sd	s1,280(sp)
  begin_op();
    80004434:	e61fe0ef          	jal	80003294 <begin_op>
  if((ip = namei(old)) == 0){
    80004438:	ed040513          	addi	a0,s0,-304
    8000443c:	c9dfe0ef          	jal	800030d8 <namei>
    80004440:	84aa                	mv	s1,a0
    80004442:	c53d                	beqz	a0,800044b0 <sys_link+0xae>
  ilock(ip);
    80004444:	dbafe0ef          	jal	800029fe <ilock>
  if(ip->type == T_DIR){
    80004448:	04449703          	lh	a4,68(s1)
    8000444c:	4785                	li	a5,1
    8000444e:	06f70663          	beq	a4,a5,800044ba <sys_link+0xb8>
    80004452:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004454:	04a4d783          	lhu	a5,74(s1)
    80004458:	2785                	addiw	a5,a5,1
    8000445a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000445e:	8526                	mv	a0,s1
    80004460:	ceafe0ef          	jal	8000294a <iupdate>
  iunlock(ip);
    80004464:	8526                	mv	a0,s1
    80004466:	e46fe0ef          	jal	80002aac <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000446a:	fd040593          	addi	a1,s0,-48
    8000446e:	f5040513          	addi	a0,s0,-176
    80004472:	c81fe0ef          	jal	800030f2 <nameiparent>
    80004476:	892a                	mv	s2,a0
    80004478:	cd21                	beqz	a0,800044d0 <sys_link+0xce>
  ilock(dp);
    8000447a:	d84fe0ef          	jal	800029fe <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000447e:	00092703          	lw	a4,0(s2)
    80004482:	409c                	lw	a5,0(s1)
    80004484:	04f71363          	bne	a4,a5,800044ca <sys_link+0xc8>
    80004488:	40d0                	lw	a2,4(s1)
    8000448a:	fd040593          	addi	a1,s0,-48
    8000448e:	854a                	mv	a0,s2
    80004490:	baffe0ef          	jal	8000303e <dirlink>
    80004494:	02054b63          	bltz	a0,800044ca <sys_link+0xc8>
  iunlockput(dp);
    80004498:	854a                	mv	a0,s2
    8000449a:	f6efe0ef          	jal	80002c08 <iunlockput>
  iput(ip);
    8000449e:	8526                	mv	a0,s1
    800044a0:	ee0fe0ef          	jal	80002b80 <iput>
  end_op();
    800044a4:	e5bfe0ef          	jal	800032fe <end_op>
  return 0;
    800044a8:	4781                	li	a5,0
    800044aa:	64f2                	ld	s1,280(sp)
    800044ac:	6952                	ld	s2,272(sp)
    800044ae:	a0a1                	j	800044f6 <sys_link+0xf4>
    end_op();
    800044b0:	e4ffe0ef          	jal	800032fe <end_op>
    return -1;
    800044b4:	57fd                	li	a5,-1
    800044b6:	64f2                	ld	s1,280(sp)
    800044b8:	a83d                	j	800044f6 <sys_link+0xf4>
    iunlockput(ip);
    800044ba:	8526                	mv	a0,s1
    800044bc:	f4cfe0ef          	jal	80002c08 <iunlockput>
    end_op();
    800044c0:	e3ffe0ef          	jal	800032fe <end_op>
    return -1;
    800044c4:	57fd                	li	a5,-1
    800044c6:	64f2                	ld	s1,280(sp)
    800044c8:	a03d                	j	800044f6 <sys_link+0xf4>
    iunlockput(dp);
    800044ca:	854a                	mv	a0,s2
    800044cc:	f3cfe0ef          	jal	80002c08 <iunlockput>
  ilock(ip);
    800044d0:	8526                	mv	a0,s1
    800044d2:	d2cfe0ef          	jal	800029fe <ilock>
  ip->nlink--;
    800044d6:	04a4d783          	lhu	a5,74(s1)
    800044da:	37fd                	addiw	a5,a5,-1
    800044dc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800044e0:	8526                	mv	a0,s1
    800044e2:	c68fe0ef          	jal	8000294a <iupdate>
  iunlockput(ip);
    800044e6:	8526                	mv	a0,s1
    800044e8:	f20fe0ef          	jal	80002c08 <iunlockput>
  end_op();
    800044ec:	e13fe0ef          	jal	800032fe <end_op>
  return -1;
    800044f0:	57fd                	li	a5,-1
    800044f2:	64f2                	ld	s1,280(sp)
    800044f4:	6952                	ld	s2,272(sp)
}
    800044f6:	853e                	mv	a0,a5
    800044f8:	70b2                	ld	ra,296(sp)
    800044fa:	7412                	ld	s0,288(sp)
    800044fc:	6155                	addi	sp,sp,304
    800044fe:	8082                	ret

0000000080004500 <sys_unlink>:
{
    80004500:	7151                	addi	sp,sp,-240
    80004502:	f586                	sd	ra,232(sp)
    80004504:	f1a2                	sd	s0,224(sp)
    80004506:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004508:	08000613          	li	a2,128
    8000450c:	f3040593          	addi	a1,s0,-208
    80004510:	4501                	li	a0,0
    80004512:	87dfd0ef          	jal	80001d8e <argstr>
    80004516:	16054063          	bltz	a0,80004676 <sys_unlink+0x176>
    8000451a:	eda6                	sd	s1,216(sp)
  begin_op();
    8000451c:	d79fe0ef          	jal	80003294 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004520:	fb040593          	addi	a1,s0,-80
    80004524:	f3040513          	addi	a0,s0,-208
    80004528:	bcbfe0ef          	jal	800030f2 <nameiparent>
    8000452c:	84aa                	mv	s1,a0
    8000452e:	c945                	beqz	a0,800045de <sys_unlink+0xde>
  ilock(dp);
    80004530:	ccefe0ef          	jal	800029fe <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004534:	00003597          	auipc	a1,0x3
    80004538:	20458593          	addi	a1,a1,516 # 80007738 <etext+0x738>
    8000453c:	fb040513          	addi	a0,s0,-80
    80004540:	91dfe0ef          	jal	80002e5c <namecmp>
    80004544:	10050e63          	beqz	a0,80004660 <sys_unlink+0x160>
    80004548:	00003597          	auipc	a1,0x3
    8000454c:	1f858593          	addi	a1,a1,504 # 80007740 <etext+0x740>
    80004550:	fb040513          	addi	a0,s0,-80
    80004554:	909fe0ef          	jal	80002e5c <namecmp>
    80004558:	10050463          	beqz	a0,80004660 <sys_unlink+0x160>
    8000455c:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000455e:	f2c40613          	addi	a2,s0,-212
    80004562:	fb040593          	addi	a1,s0,-80
    80004566:	8526                	mv	a0,s1
    80004568:	90bfe0ef          	jal	80002e72 <dirlookup>
    8000456c:	892a                	mv	s2,a0
    8000456e:	0e050863          	beqz	a0,8000465e <sys_unlink+0x15e>
  ilock(ip);
    80004572:	c8cfe0ef          	jal	800029fe <ilock>
  if(ip->nlink < 1)
    80004576:	04a91783          	lh	a5,74(s2)
    8000457a:	06f05763          	blez	a5,800045e8 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000457e:	04491703          	lh	a4,68(s2)
    80004582:	4785                	li	a5,1
    80004584:	06f70963          	beq	a4,a5,800045f6 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004588:	4641                	li	a2,16
    8000458a:	4581                	li	a1,0
    8000458c:	fc040513          	addi	a0,s0,-64
    80004590:	ba5fb0ef          	jal	80000134 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004594:	4741                	li	a4,16
    80004596:	f2c42683          	lw	a3,-212(s0)
    8000459a:	fc040613          	addi	a2,s0,-64
    8000459e:	4581                	li	a1,0
    800045a0:	8526                	mv	a0,s1
    800045a2:	facfe0ef          	jal	80002d4e <writei>
    800045a6:	47c1                	li	a5,16
    800045a8:	08f51b63          	bne	a0,a5,8000463e <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    800045ac:	04491703          	lh	a4,68(s2)
    800045b0:	4785                	li	a5,1
    800045b2:	08f70d63          	beq	a4,a5,8000464c <sys_unlink+0x14c>
  iunlockput(dp);
    800045b6:	8526                	mv	a0,s1
    800045b8:	e50fe0ef          	jal	80002c08 <iunlockput>
  ip->nlink--;
    800045bc:	04a95783          	lhu	a5,74(s2)
    800045c0:	37fd                	addiw	a5,a5,-1
    800045c2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800045c6:	854a                	mv	a0,s2
    800045c8:	b82fe0ef          	jal	8000294a <iupdate>
  iunlockput(ip);
    800045cc:	854a                	mv	a0,s2
    800045ce:	e3afe0ef          	jal	80002c08 <iunlockput>
  end_op();
    800045d2:	d2dfe0ef          	jal	800032fe <end_op>
  return 0;
    800045d6:	4501                	li	a0,0
    800045d8:	64ee                	ld	s1,216(sp)
    800045da:	694e                	ld	s2,208(sp)
    800045dc:	a849                	j	8000466e <sys_unlink+0x16e>
    end_op();
    800045de:	d21fe0ef          	jal	800032fe <end_op>
    return -1;
    800045e2:	557d                	li	a0,-1
    800045e4:	64ee                	ld	s1,216(sp)
    800045e6:	a061                	j	8000466e <sys_unlink+0x16e>
    800045e8:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    800045ea:	00003517          	auipc	a0,0x3
    800045ee:	15e50513          	addi	a0,a0,350 # 80007748 <etext+0x748>
    800045f2:	260010ef          	jal	80005852 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800045f6:	04c92703          	lw	a4,76(s2)
    800045fa:	02000793          	li	a5,32
    800045fe:	f8e7f5e3          	bgeu	a5,a4,80004588 <sys_unlink+0x88>
    80004602:	e5ce                	sd	s3,200(sp)
    80004604:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004608:	4741                	li	a4,16
    8000460a:	86ce                	mv	a3,s3
    8000460c:	f1840613          	addi	a2,s0,-232
    80004610:	4581                	li	a1,0
    80004612:	854a                	mv	a0,s2
    80004614:	e3efe0ef          	jal	80002c52 <readi>
    80004618:	47c1                	li	a5,16
    8000461a:	00f51c63          	bne	a0,a5,80004632 <sys_unlink+0x132>
    if(de.inum != 0)
    8000461e:	f1845783          	lhu	a5,-232(s0)
    80004622:	efa1                	bnez	a5,8000467a <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004624:	29c1                	addiw	s3,s3,16
    80004626:	04c92783          	lw	a5,76(s2)
    8000462a:	fcf9efe3          	bltu	s3,a5,80004608 <sys_unlink+0x108>
    8000462e:	69ae                	ld	s3,200(sp)
    80004630:	bfa1                	j	80004588 <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004632:	00003517          	auipc	a0,0x3
    80004636:	12e50513          	addi	a0,a0,302 # 80007760 <etext+0x760>
    8000463a:	218010ef          	jal	80005852 <panic>
    8000463e:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004640:	00003517          	auipc	a0,0x3
    80004644:	13850513          	addi	a0,a0,312 # 80007778 <etext+0x778>
    80004648:	20a010ef          	jal	80005852 <panic>
    dp->nlink--;
    8000464c:	04a4d783          	lhu	a5,74(s1)
    80004650:	37fd                	addiw	a5,a5,-1
    80004652:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004656:	8526                	mv	a0,s1
    80004658:	af2fe0ef          	jal	8000294a <iupdate>
    8000465c:	bfa9                	j	800045b6 <sys_unlink+0xb6>
    8000465e:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004660:	8526                	mv	a0,s1
    80004662:	da6fe0ef          	jal	80002c08 <iunlockput>
  end_op();
    80004666:	c99fe0ef          	jal	800032fe <end_op>
  return -1;
    8000466a:	557d                	li	a0,-1
    8000466c:	64ee                	ld	s1,216(sp)
}
    8000466e:	70ae                	ld	ra,232(sp)
    80004670:	740e                	ld	s0,224(sp)
    80004672:	616d                	addi	sp,sp,240
    80004674:	8082                	ret
    return -1;
    80004676:	557d                	li	a0,-1
    80004678:	bfdd                	j	8000466e <sys_unlink+0x16e>
    iunlockput(ip);
    8000467a:	854a                	mv	a0,s2
    8000467c:	d8cfe0ef          	jal	80002c08 <iunlockput>
    goto bad;
    80004680:	694e                	ld	s2,208(sp)
    80004682:	69ae                	ld	s3,200(sp)
    80004684:	bff1                	j	80004660 <sys_unlink+0x160>

0000000080004686 <sys_open>:

uint64
sys_open(void)
{
    80004686:	7131                	addi	sp,sp,-192
    80004688:	fd06                	sd	ra,184(sp)
    8000468a:	f922                	sd	s0,176(sp)
    8000468c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000468e:	f4c40593          	addi	a1,s0,-180
    80004692:	4505                	li	a0,1
    80004694:	e44fd0ef          	jal	80001cd8 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004698:	08000613          	li	a2,128
    8000469c:	f5040593          	addi	a1,s0,-176
    800046a0:	4501                	li	a0,0
    800046a2:	eecfd0ef          	jal	80001d8e <argstr>
    800046a6:	87aa                	mv	a5,a0
    return -1;
    800046a8:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800046aa:	0a07c263          	bltz	a5,8000474e <sys_open+0xc8>
    800046ae:	f526                	sd	s1,168(sp)

  begin_op();
    800046b0:	be5fe0ef          	jal	80003294 <begin_op>

  if(omode & O_CREATE){
    800046b4:	f4c42783          	lw	a5,-180(s0)
    800046b8:	2007f793          	andi	a5,a5,512
    800046bc:	c3d5                	beqz	a5,80004760 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800046be:	4681                	li	a3,0
    800046c0:	4601                	li	a2,0
    800046c2:	4589                	li	a1,2
    800046c4:	f5040513          	addi	a0,s0,-176
    800046c8:	aa9ff0ef          	jal	80004170 <create>
    800046cc:	84aa                	mv	s1,a0
    if(ip == 0){
    800046ce:	c541                	beqz	a0,80004756 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800046d0:	04449703          	lh	a4,68(s1)
    800046d4:	478d                	li	a5,3
    800046d6:	00f71763          	bne	a4,a5,800046e4 <sys_open+0x5e>
    800046da:	0464d703          	lhu	a4,70(s1)
    800046de:	47a5                	li	a5,9
    800046e0:	0ae7ed63          	bltu	a5,a4,8000479a <sys_open+0x114>
    800046e4:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800046e6:	f25fe0ef          	jal	8000360a <filealloc>
    800046ea:	892a                	mv	s2,a0
    800046ec:	c179                	beqz	a0,800047b2 <sys_open+0x12c>
    800046ee:	ed4e                	sd	s3,152(sp)
    800046f0:	a43ff0ef          	jal	80004132 <fdalloc>
    800046f4:	89aa                	mv	s3,a0
    800046f6:	0a054a63          	bltz	a0,800047aa <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800046fa:	04449703          	lh	a4,68(s1)
    800046fe:	478d                	li	a5,3
    80004700:	0cf70263          	beq	a4,a5,800047c4 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004704:	4789                	li	a5,2
    80004706:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000470a:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000470e:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004712:	f4c42783          	lw	a5,-180(s0)
    80004716:	0017c713          	xori	a4,a5,1
    8000471a:	8b05                	andi	a4,a4,1
    8000471c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004720:	0037f713          	andi	a4,a5,3
    80004724:	00e03733          	snez	a4,a4
    80004728:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000472c:	4007f793          	andi	a5,a5,1024
    80004730:	c791                	beqz	a5,8000473c <sys_open+0xb6>
    80004732:	04449703          	lh	a4,68(s1)
    80004736:	4789                	li	a5,2
    80004738:	08f70d63          	beq	a4,a5,800047d2 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    8000473c:	8526                	mv	a0,s1
    8000473e:	b6efe0ef          	jal	80002aac <iunlock>
  end_op();
    80004742:	bbdfe0ef          	jal	800032fe <end_op>

  return fd;
    80004746:	854e                	mv	a0,s3
    80004748:	74aa                	ld	s1,168(sp)
    8000474a:	790a                	ld	s2,160(sp)
    8000474c:	69ea                	ld	s3,152(sp)
}
    8000474e:	70ea                	ld	ra,184(sp)
    80004750:	744a                	ld	s0,176(sp)
    80004752:	6129                	addi	sp,sp,192
    80004754:	8082                	ret
      end_op();
    80004756:	ba9fe0ef          	jal	800032fe <end_op>
      return -1;
    8000475a:	557d                	li	a0,-1
    8000475c:	74aa                	ld	s1,168(sp)
    8000475e:	bfc5                	j	8000474e <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004760:	f5040513          	addi	a0,s0,-176
    80004764:	975fe0ef          	jal	800030d8 <namei>
    80004768:	84aa                	mv	s1,a0
    8000476a:	c11d                	beqz	a0,80004790 <sys_open+0x10a>
    ilock(ip);
    8000476c:	a92fe0ef          	jal	800029fe <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004770:	04449703          	lh	a4,68(s1)
    80004774:	4785                	li	a5,1
    80004776:	f4f71de3          	bne	a4,a5,800046d0 <sys_open+0x4a>
    8000477a:	f4c42783          	lw	a5,-180(s0)
    8000477e:	d3bd                	beqz	a5,800046e4 <sys_open+0x5e>
      iunlockput(ip);
    80004780:	8526                	mv	a0,s1
    80004782:	c86fe0ef          	jal	80002c08 <iunlockput>
      end_op();
    80004786:	b79fe0ef          	jal	800032fe <end_op>
      return -1;
    8000478a:	557d                	li	a0,-1
    8000478c:	74aa                	ld	s1,168(sp)
    8000478e:	b7c1                	j	8000474e <sys_open+0xc8>
      end_op();
    80004790:	b6ffe0ef          	jal	800032fe <end_op>
      return -1;
    80004794:	557d                	li	a0,-1
    80004796:	74aa                	ld	s1,168(sp)
    80004798:	bf5d                	j	8000474e <sys_open+0xc8>
    iunlockput(ip);
    8000479a:	8526                	mv	a0,s1
    8000479c:	c6cfe0ef          	jal	80002c08 <iunlockput>
    end_op();
    800047a0:	b5ffe0ef          	jal	800032fe <end_op>
    return -1;
    800047a4:	557d                	li	a0,-1
    800047a6:	74aa                	ld	s1,168(sp)
    800047a8:	b75d                	j	8000474e <sys_open+0xc8>
      fileclose(f);
    800047aa:	854a                	mv	a0,s2
    800047ac:	f03fe0ef          	jal	800036ae <fileclose>
    800047b0:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800047b2:	8526                	mv	a0,s1
    800047b4:	c54fe0ef          	jal	80002c08 <iunlockput>
    end_op();
    800047b8:	b47fe0ef          	jal	800032fe <end_op>
    return -1;
    800047bc:	557d                	li	a0,-1
    800047be:	74aa                	ld	s1,168(sp)
    800047c0:	790a                	ld	s2,160(sp)
    800047c2:	b771                	j	8000474e <sys_open+0xc8>
    f->type = FD_DEVICE;
    800047c4:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800047c8:	04649783          	lh	a5,70(s1)
    800047cc:	02f91223          	sh	a5,36(s2)
    800047d0:	bf3d                	j	8000470e <sys_open+0x88>
    itrunc(ip);
    800047d2:	8526                	mv	a0,s1
    800047d4:	b18fe0ef          	jal	80002aec <itrunc>
    800047d8:	b795                	j	8000473c <sys_open+0xb6>

00000000800047da <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800047da:	7175                	addi	sp,sp,-144
    800047dc:	e506                	sd	ra,136(sp)
    800047de:	e122                	sd	s0,128(sp)
    800047e0:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800047e2:	ab3fe0ef          	jal	80003294 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800047e6:	08000613          	li	a2,128
    800047ea:	f7040593          	addi	a1,s0,-144
    800047ee:	4501                	li	a0,0
    800047f0:	d9efd0ef          	jal	80001d8e <argstr>
    800047f4:	02054363          	bltz	a0,8000481a <sys_mkdir+0x40>
    800047f8:	4681                	li	a3,0
    800047fa:	4601                	li	a2,0
    800047fc:	4585                	li	a1,1
    800047fe:	f7040513          	addi	a0,s0,-144
    80004802:	96fff0ef          	jal	80004170 <create>
    80004806:	c911                	beqz	a0,8000481a <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004808:	c00fe0ef          	jal	80002c08 <iunlockput>
  end_op();
    8000480c:	af3fe0ef          	jal	800032fe <end_op>
  return 0;
    80004810:	4501                	li	a0,0
}
    80004812:	60aa                	ld	ra,136(sp)
    80004814:	640a                	ld	s0,128(sp)
    80004816:	6149                	addi	sp,sp,144
    80004818:	8082                	ret
    end_op();
    8000481a:	ae5fe0ef          	jal	800032fe <end_op>
    return -1;
    8000481e:	557d                	li	a0,-1
    80004820:	bfcd                	j	80004812 <sys_mkdir+0x38>

0000000080004822 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004822:	7135                	addi	sp,sp,-160
    80004824:	ed06                	sd	ra,152(sp)
    80004826:	e922                	sd	s0,144(sp)
    80004828:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000482a:	a6bfe0ef          	jal	80003294 <begin_op>
  argint(1, &major);
    8000482e:	f6c40593          	addi	a1,s0,-148
    80004832:	4505                	li	a0,1
    80004834:	ca4fd0ef          	jal	80001cd8 <argint>
  argint(2, &minor);
    80004838:	f6840593          	addi	a1,s0,-152
    8000483c:	4509                	li	a0,2
    8000483e:	c9afd0ef          	jal	80001cd8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004842:	08000613          	li	a2,128
    80004846:	f7040593          	addi	a1,s0,-144
    8000484a:	4501                	li	a0,0
    8000484c:	d42fd0ef          	jal	80001d8e <argstr>
    80004850:	02054563          	bltz	a0,8000487a <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004854:	f6841683          	lh	a3,-152(s0)
    80004858:	f6c41603          	lh	a2,-148(s0)
    8000485c:	458d                	li	a1,3
    8000485e:	f7040513          	addi	a0,s0,-144
    80004862:	90fff0ef          	jal	80004170 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004866:	c911                	beqz	a0,8000487a <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004868:	ba0fe0ef          	jal	80002c08 <iunlockput>
  end_op();
    8000486c:	a93fe0ef          	jal	800032fe <end_op>
  return 0;
    80004870:	4501                	li	a0,0
}
    80004872:	60ea                	ld	ra,152(sp)
    80004874:	644a                	ld	s0,144(sp)
    80004876:	610d                	addi	sp,sp,160
    80004878:	8082                	ret
    end_op();
    8000487a:	a85fe0ef          	jal	800032fe <end_op>
    return -1;
    8000487e:	557d                	li	a0,-1
    80004880:	bfcd                	j	80004872 <sys_mknod+0x50>

0000000080004882 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004882:	7135                	addi	sp,sp,-160
    80004884:	ed06                	sd	ra,152(sp)
    80004886:	e922                	sd	s0,144(sp)
    80004888:	e14a                	sd	s2,128(sp)
    8000488a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000488c:	ccafc0ef          	jal	80000d56 <myproc>
    80004890:	892a                	mv	s2,a0
  
  begin_op();
    80004892:	a03fe0ef          	jal	80003294 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004896:	08000613          	li	a2,128
    8000489a:	f6040593          	addi	a1,s0,-160
    8000489e:	4501                	li	a0,0
    800048a0:	ceefd0ef          	jal	80001d8e <argstr>
    800048a4:	04054363          	bltz	a0,800048ea <sys_chdir+0x68>
    800048a8:	e526                	sd	s1,136(sp)
    800048aa:	f6040513          	addi	a0,s0,-160
    800048ae:	82bfe0ef          	jal	800030d8 <namei>
    800048b2:	84aa                	mv	s1,a0
    800048b4:	c915                	beqz	a0,800048e8 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800048b6:	948fe0ef          	jal	800029fe <ilock>
  if(ip->type != T_DIR){
    800048ba:	04449703          	lh	a4,68(s1)
    800048be:	4785                	li	a5,1
    800048c0:	02f71963          	bne	a4,a5,800048f2 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800048c4:	8526                	mv	a0,s1
    800048c6:	9e6fe0ef          	jal	80002aac <iunlock>
  iput(p->cwd);
    800048ca:	15093503          	ld	a0,336(s2)
    800048ce:	ab2fe0ef          	jal	80002b80 <iput>
  end_op();
    800048d2:	a2dfe0ef          	jal	800032fe <end_op>
  p->cwd = ip;
    800048d6:	14993823          	sd	s1,336(s2)
  return 0;
    800048da:	4501                	li	a0,0
    800048dc:	64aa                	ld	s1,136(sp)
}
    800048de:	60ea                	ld	ra,152(sp)
    800048e0:	644a                	ld	s0,144(sp)
    800048e2:	690a                	ld	s2,128(sp)
    800048e4:	610d                	addi	sp,sp,160
    800048e6:	8082                	ret
    800048e8:	64aa                	ld	s1,136(sp)
    end_op();
    800048ea:	a15fe0ef          	jal	800032fe <end_op>
    return -1;
    800048ee:	557d                	li	a0,-1
    800048f0:	b7fd                	j	800048de <sys_chdir+0x5c>
    iunlockput(ip);
    800048f2:	8526                	mv	a0,s1
    800048f4:	b14fe0ef          	jal	80002c08 <iunlockput>
    end_op();
    800048f8:	a07fe0ef          	jal	800032fe <end_op>
    return -1;
    800048fc:	557d                	li	a0,-1
    800048fe:	64aa                	ld	s1,136(sp)
    80004900:	bff9                	j	800048de <sys_chdir+0x5c>

0000000080004902 <sys_exec>:

///////////////////////////////////////

uint64
sys_exec(void)
{
    80004902:	7121                	addi	sp,sp,-448
    80004904:	ff06                	sd	ra,440(sp)
    80004906:	fb22                	sd	s0,432(sp)
    80004908:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000490a:	e4840593          	addi	a1,s0,-440
    8000490e:	4505                	li	a0,1
    80004910:	c6afd0ef          	jal	80001d7a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004914:	08000613          	li	a2,128
    80004918:	f5040593          	addi	a1,s0,-176
    8000491c:	4501                	li	a0,0
    8000491e:	c70fd0ef          	jal	80001d8e <argstr>
    80004922:	87aa                	mv	a5,a0
    return -1;
    80004924:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004926:	0a07cb63          	bltz	a5,800049dc <sys_exec+0xda>
    8000492a:	f726                	sd	s1,424(sp)
    8000492c:	f34a                	sd	s2,416(sp)
    8000492e:	ef4e                	sd	s3,408(sp)
    80004930:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004932:	10000613          	li	a2,256
    80004936:	4581                	li	a1,0
    80004938:	e5040513          	addi	a0,s0,-432
    8000493c:	ff8fb0ef          	jal	80000134 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004940:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004944:	89a6                	mv	s3,s1
    80004946:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004948:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000494c:	00391513          	slli	a0,s2,0x3
    80004950:	e4040593          	addi	a1,s0,-448
    80004954:	e4843783          	ld	a5,-440(s0)
    80004958:	953e                	add	a0,a0,a5
    8000495a:	af4fd0ef          	jal	80001c4e <fetchaddr>
    8000495e:	02054663          	bltz	a0,8000498a <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80004962:	e4043783          	ld	a5,-448(s0)
    80004966:	c3a9                	beqz	a5,800049a8 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004968:	f8efb0ef          	jal	800000f6 <kalloc>
    8000496c:	85aa                	mv	a1,a0
    8000496e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004972:	cd01                	beqz	a0,8000498a <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004974:	6605                	lui	a2,0x1
    80004976:	e4043503          	ld	a0,-448(s0)
    8000497a:	b1efd0ef          	jal	80001c98 <fetchstr>
    8000497e:	00054663          	bltz	a0,8000498a <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80004982:	0905                	addi	s2,s2,1
    80004984:	09a1                	addi	s3,s3,8
    80004986:	fd4913e3          	bne	s2,s4,8000494c <sys_exec+0x4a>

  // Free memory only if exec fails (handled in bad)
  return ret;

bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000498a:	f5040913          	addi	s2,s0,-176
    8000498e:	6088                	ld	a0,0(s1)
    80004990:	c129                	beqz	a0,800049d2 <sys_exec+0xd0>
    kfree(argv[i]);
    80004992:	e8afb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004996:	04a1                	addi	s1,s1,8
    80004998:	ff249be3          	bne	s1,s2,8000498e <sys_exec+0x8c>
  return -1;
    8000499c:	557d                	li	a0,-1
    8000499e:	74ba                	ld	s1,424(sp)
    800049a0:	791a                	ld	s2,416(sp)
    800049a2:	69fa                	ld	s3,408(sp)
    800049a4:	6a5a                	ld	s4,400(sp)
    800049a6:	a81d                	j	800049dc <sys_exec+0xda>
      argv[i] = 0;
    800049a8:	0009079b          	sext.w	a5,s2
    800049ac:	078e                	slli	a5,a5,0x3
    800049ae:	fd078793          	addi	a5,a5,-48
    800049b2:	97a2                	add	a5,a5,s0
    800049b4:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800049b8:	e5040593          	addi	a1,s0,-432
    800049bc:	f5040513          	addi	a0,s0,-176
    800049c0:	aecff0ef          	jal	80003cac <exec>
  if(ret < 0) {
    800049c4:	fc0543e3          	bltz	a0,8000498a <sys_exec+0x88>
    800049c8:	74ba                	ld	s1,424(sp)
    800049ca:	791a                	ld	s2,416(sp)
    800049cc:	69fa                	ld	s3,408(sp)
    800049ce:	6a5a                	ld	s4,400(sp)
    800049d0:	a031                	j	800049dc <sys_exec+0xda>
  return -1;
    800049d2:	557d                	li	a0,-1
    800049d4:	74ba                	ld	s1,424(sp)
    800049d6:	791a                	ld	s2,416(sp)
    800049d8:	69fa                	ld	s3,408(sp)
    800049da:	6a5a                	ld	s4,400(sp)
}
    800049dc:	70fa                	ld	ra,440(sp)
    800049de:	745a                	ld	s0,432(sp)
    800049e0:	6139                	addi	sp,sp,448
    800049e2:	8082                	ret

00000000800049e4 <sys_pipe>:

//////////////////////////

uint64
sys_pipe(void)
{
    800049e4:	7139                	addi	sp,sp,-64
    800049e6:	fc06                	sd	ra,56(sp)
    800049e8:	f822                	sd	s0,48(sp)
    800049ea:	f426                	sd	s1,40(sp)
    800049ec:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800049ee:	b68fc0ef          	jal	80000d56 <myproc>
    800049f2:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800049f4:	fd840593          	addi	a1,s0,-40
    800049f8:	4501                	li	a0,0
    800049fa:	b80fd0ef          	jal	80001d7a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800049fe:	fc840593          	addi	a1,s0,-56
    80004a02:	fd040513          	addi	a0,s0,-48
    80004a06:	fb3fe0ef          	jal	800039b8 <pipealloc>
    return -1;
    80004a0a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004a0c:	0a054463          	bltz	a0,80004ab4 <sys_pipe+0xd0>
  fd0 = -1;
    80004a10:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004a14:	fd043503          	ld	a0,-48(s0)
    80004a18:	f1aff0ef          	jal	80004132 <fdalloc>
    80004a1c:	fca42223          	sw	a0,-60(s0)
    80004a20:	08054163          	bltz	a0,80004aa2 <sys_pipe+0xbe>
    80004a24:	fc843503          	ld	a0,-56(s0)
    80004a28:	f0aff0ef          	jal	80004132 <fdalloc>
    80004a2c:	fca42023          	sw	a0,-64(s0)
    80004a30:	06054063          	bltz	a0,80004a90 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004a34:	4691                	li	a3,4
    80004a36:	fc440613          	addi	a2,s0,-60
    80004a3a:	fd843583          	ld	a1,-40(s0)
    80004a3e:	68a8                	ld	a0,80(s1)
    80004a40:	f87fb0ef          	jal	800009c6 <copyout>
    80004a44:	00054e63          	bltz	a0,80004a60 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004a48:	4691                	li	a3,4
    80004a4a:	fc040613          	addi	a2,s0,-64
    80004a4e:	fd843583          	ld	a1,-40(s0)
    80004a52:	0591                	addi	a1,a1,4
    80004a54:	68a8                	ld	a0,80(s1)
    80004a56:	f71fb0ef          	jal	800009c6 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004a5a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004a5c:	04055c63          	bgez	a0,80004ab4 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004a60:	fc442783          	lw	a5,-60(s0)
    80004a64:	07e9                	addi	a5,a5,26
    80004a66:	078e                	slli	a5,a5,0x3
    80004a68:	97a6                	add	a5,a5,s1
    80004a6a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004a6e:	fc042783          	lw	a5,-64(s0)
    80004a72:	07e9                	addi	a5,a5,26
    80004a74:	078e                	slli	a5,a5,0x3
    80004a76:	94be                	add	s1,s1,a5
    80004a78:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004a7c:	fd043503          	ld	a0,-48(s0)
    80004a80:	c2ffe0ef          	jal	800036ae <fileclose>
    fileclose(wf);
    80004a84:	fc843503          	ld	a0,-56(s0)
    80004a88:	c27fe0ef          	jal	800036ae <fileclose>
    return -1;
    80004a8c:	57fd                	li	a5,-1
    80004a8e:	a01d                	j	80004ab4 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004a90:	fc442783          	lw	a5,-60(s0)
    80004a94:	0007c763          	bltz	a5,80004aa2 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004a98:	07e9                	addi	a5,a5,26
    80004a9a:	078e                	slli	a5,a5,0x3
    80004a9c:	97a6                	add	a5,a5,s1
    80004a9e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004aa2:	fd043503          	ld	a0,-48(s0)
    80004aa6:	c09fe0ef          	jal	800036ae <fileclose>
    fileclose(wf);
    80004aaa:	fc843503          	ld	a0,-56(s0)
    80004aae:	c01fe0ef          	jal	800036ae <fileclose>
    return -1;
    80004ab2:	57fd                	li	a5,-1
}
    80004ab4:	853e                	mv	a0,a5
    80004ab6:	70e2                	ld	ra,56(sp)
    80004ab8:	7442                	ld	s0,48(sp)
    80004aba:	74a2                	ld	s1,40(sp)
    80004abc:	6121                	addi	sp,sp,64
    80004abe:	8082                	ret

0000000080004ac0 <kernelvec>:
    80004ac0:	7111                	addi	sp,sp,-256
    80004ac2:	e006                	sd	ra,0(sp)
    80004ac4:	e40a                	sd	sp,8(sp)
    80004ac6:	e80e                	sd	gp,16(sp)
    80004ac8:	ec12                	sd	tp,24(sp)
    80004aca:	f016                	sd	t0,32(sp)
    80004acc:	f41a                	sd	t1,40(sp)
    80004ace:	f81e                	sd	t2,48(sp)
    80004ad0:	e4aa                	sd	a0,72(sp)
    80004ad2:	e8ae                	sd	a1,80(sp)
    80004ad4:	ecb2                	sd	a2,88(sp)
    80004ad6:	f0b6                	sd	a3,96(sp)
    80004ad8:	f4ba                	sd	a4,104(sp)
    80004ada:	f8be                	sd	a5,112(sp)
    80004adc:	fcc2                	sd	a6,120(sp)
    80004ade:	e146                	sd	a7,128(sp)
    80004ae0:	edf2                	sd	t3,216(sp)
    80004ae2:	f1f6                	sd	t4,224(sp)
    80004ae4:	f5fa                	sd	t5,232(sp)
    80004ae6:	f9fe                	sd	t6,240(sp)
    80004ae8:	fb5fc0ef          	jal	80001a9c <kerneltrap>
    80004aec:	6082                	ld	ra,0(sp)
    80004aee:	6122                	ld	sp,8(sp)
    80004af0:	61c2                	ld	gp,16(sp)
    80004af2:	7282                	ld	t0,32(sp)
    80004af4:	7322                	ld	t1,40(sp)
    80004af6:	73c2                	ld	t2,48(sp)
    80004af8:	6526                	ld	a0,72(sp)
    80004afa:	65c6                	ld	a1,80(sp)
    80004afc:	6666                	ld	a2,88(sp)
    80004afe:	7686                	ld	a3,96(sp)
    80004b00:	7726                	ld	a4,104(sp)
    80004b02:	77c6                	ld	a5,112(sp)
    80004b04:	7866                	ld	a6,120(sp)
    80004b06:	688a                	ld	a7,128(sp)
    80004b08:	6e6e                	ld	t3,216(sp)
    80004b0a:	7e8e                	ld	t4,224(sp)
    80004b0c:	7f2e                	ld	t5,232(sp)
    80004b0e:	7fce                	ld	t6,240(sp)
    80004b10:	6111                	addi	sp,sp,256
    80004b12:	10200073          	sret
	...

0000000080004b1e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80004b1e:	1141                	addi	sp,sp,-16
    80004b20:	e422                	sd	s0,8(sp)
    80004b22:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004b24:	0c0007b7          	lui	a5,0xc000
    80004b28:	4705                	li	a4,1
    80004b2a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80004b2c:	0c0007b7          	lui	a5,0xc000
    80004b30:	c3d8                	sw	a4,4(a5)
}
    80004b32:	6422                	ld	s0,8(sp)
    80004b34:	0141                	addi	sp,sp,16
    80004b36:	8082                	ret

0000000080004b38 <plicinithart>:

void
plicinithart(void)
{
    80004b38:	1141                	addi	sp,sp,-16
    80004b3a:	e406                	sd	ra,8(sp)
    80004b3c:	e022                	sd	s0,0(sp)
    80004b3e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004b40:	9eafc0ef          	jal	80000d2a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004b44:	0085171b          	slliw	a4,a0,0x8
    80004b48:	0c0027b7          	lui	a5,0xc002
    80004b4c:	97ba                	add	a5,a5,a4
    80004b4e:	40200713          	li	a4,1026
    80004b52:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004b56:	00d5151b          	slliw	a0,a0,0xd
    80004b5a:	0c2017b7          	lui	a5,0xc201
    80004b5e:	97aa                	add	a5,a5,a0
    80004b60:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004b64:	60a2                	ld	ra,8(sp)
    80004b66:	6402                	ld	s0,0(sp)
    80004b68:	0141                	addi	sp,sp,16
    80004b6a:	8082                	ret

0000000080004b6c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004b6c:	1141                	addi	sp,sp,-16
    80004b6e:	e406                	sd	ra,8(sp)
    80004b70:	e022                	sd	s0,0(sp)
    80004b72:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004b74:	9b6fc0ef          	jal	80000d2a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004b78:	00d5151b          	slliw	a0,a0,0xd
    80004b7c:	0c2017b7          	lui	a5,0xc201
    80004b80:	97aa                	add	a5,a5,a0
  return irq;
}
    80004b82:	43c8                	lw	a0,4(a5)
    80004b84:	60a2                	ld	ra,8(sp)
    80004b86:	6402                	ld	s0,0(sp)
    80004b88:	0141                	addi	sp,sp,16
    80004b8a:	8082                	ret

0000000080004b8c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004b8c:	1101                	addi	sp,sp,-32
    80004b8e:	ec06                	sd	ra,24(sp)
    80004b90:	e822                	sd	s0,16(sp)
    80004b92:	e426                	sd	s1,8(sp)
    80004b94:	1000                	addi	s0,sp,32
    80004b96:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004b98:	992fc0ef          	jal	80000d2a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004b9c:	00d5151b          	slliw	a0,a0,0xd
    80004ba0:	0c2017b7          	lui	a5,0xc201
    80004ba4:	97aa                	add	a5,a5,a0
    80004ba6:	c3c4                	sw	s1,4(a5)
}
    80004ba8:	60e2                	ld	ra,24(sp)
    80004baa:	6442                	ld	s0,16(sp)
    80004bac:	64a2                	ld	s1,8(sp)
    80004bae:	6105                	addi	sp,sp,32
    80004bb0:	8082                	ret

0000000080004bb2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004bb2:	1141                	addi	sp,sp,-16
    80004bb4:	e406                	sd	ra,8(sp)
    80004bb6:	e022                	sd	s0,0(sp)
    80004bb8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004bba:	479d                	li	a5,7
    80004bbc:	04a7ca63          	blt	a5,a0,80004c10 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004bc0:	00017797          	auipc	a5,0x17
    80004bc4:	f4078793          	addi	a5,a5,-192 # 8001bb00 <disk>
    80004bc8:	97aa                	add	a5,a5,a0
    80004bca:	0187c783          	lbu	a5,24(a5)
    80004bce:	e7b9                	bnez	a5,80004c1c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004bd0:	00451693          	slli	a3,a0,0x4
    80004bd4:	00017797          	auipc	a5,0x17
    80004bd8:	f2c78793          	addi	a5,a5,-212 # 8001bb00 <disk>
    80004bdc:	6398                	ld	a4,0(a5)
    80004bde:	9736                	add	a4,a4,a3
    80004be0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004be4:	6398                	ld	a4,0(a5)
    80004be6:	9736                	add	a4,a4,a3
    80004be8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004bec:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004bf0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004bf4:	97aa                	add	a5,a5,a0
    80004bf6:	4705                	li	a4,1
    80004bf8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004bfc:	00017517          	auipc	a0,0x17
    80004c00:	f1c50513          	addi	a0,a0,-228 # 8001bb18 <disk+0x18>
    80004c04:	f78fc0ef          	jal	8000137c <wakeup>
}
    80004c08:	60a2                	ld	ra,8(sp)
    80004c0a:	6402                	ld	s0,0(sp)
    80004c0c:	0141                	addi	sp,sp,16
    80004c0e:	8082                	ret
    panic("free_desc 1");
    80004c10:	00003517          	auipc	a0,0x3
    80004c14:	b7850513          	addi	a0,a0,-1160 # 80007788 <etext+0x788>
    80004c18:	43b000ef          	jal	80005852 <panic>
    panic("free_desc 2");
    80004c1c:	00003517          	auipc	a0,0x3
    80004c20:	b7c50513          	addi	a0,a0,-1156 # 80007798 <etext+0x798>
    80004c24:	42f000ef          	jal	80005852 <panic>

0000000080004c28 <virtio_disk_init>:
{
    80004c28:	1101                	addi	sp,sp,-32
    80004c2a:	ec06                	sd	ra,24(sp)
    80004c2c:	e822                	sd	s0,16(sp)
    80004c2e:	e426                	sd	s1,8(sp)
    80004c30:	e04a                	sd	s2,0(sp)
    80004c32:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004c34:	00003597          	auipc	a1,0x3
    80004c38:	b7458593          	addi	a1,a1,-1164 # 800077a8 <etext+0x7a8>
    80004c3c:	00017517          	auipc	a0,0x17
    80004c40:	fec50513          	addi	a0,a0,-20 # 8001bc28 <disk+0x128>
    80004c44:	6bd000ef          	jal	80005b00 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004c48:	100017b7          	lui	a5,0x10001
    80004c4c:	4398                	lw	a4,0(a5)
    80004c4e:	2701                	sext.w	a4,a4
    80004c50:	747277b7          	lui	a5,0x74727
    80004c54:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004c58:	18f71063          	bne	a4,a5,80004dd8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004c5c:	100017b7          	lui	a5,0x10001
    80004c60:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004c62:	439c                	lw	a5,0(a5)
    80004c64:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004c66:	4709                	li	a4,2
    80004c68:	16e79863          	bne	a5,a4,80004dd8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004c6c:	100017b7          	lui	a5,0x10001
    80004c70:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004c72:	439c                	lw	a5,0(a5)
    80004c74:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004c76:	16e79163          	bne	a5,a4,80004dd8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004c7a:	100017b7          	lui	a5,0x10001
    80004c7e:	47d8                	lw	a4,12(a5)
    80004c80:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004c82:	554d47b7          	lui	a5,0x554d4
    80004c86:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004c8a:	14f71763          	bne	a4,a5,80004dd8 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c8e:	100017b7          	lui	a5,0x10001
    80004c92:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c96:	4705                	li	a4,1
    80004c98:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c9a:	470d                	li	a4,3
    80004c9c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004c9e:	10001737          	lui	a4,0x10001
    80004ca2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004ca4:	c7ffe737          	lui	a4,0xc7ffe
    80004ca8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdaa1f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004cac:	8ef9                	and	a3,a3,a4
    80004cae:	10001737          	lui	a4,0x10001
    80004cb2:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004cb4:	472d                	li	a4,11
    80004cb6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004cb8:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004cbc:	439c                	lw	a5,0(a5)
    80004cbe:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004cc2:	8ba1                	andi	a5,a5,8
    80004cc4:	12078063          	beqz	a5,80004de4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004cc8:	100017b7          	lui	a5,0x10001
    80004ccc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004cd0:	100017b7          	lui	a5,0x10001
    80004cd4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004cd8:	439c                	lw	a5,0(a5)
    80004cda:	2781                	sext.w	a5,a5
    80004cdc:	10079a63          	bnez	a5,80004df0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004ce0:	100017b7          	lui	a5,0x10001
    80004ce4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004ce8:	439c                	lw	a5,0(a5)
    80004cea:	2781                	sext.w	a5,a5
  if(max == 0)
    80004cec:	10078863          	beqz	a5,80004dfc <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004cf0:	471d                	li	a4,7
    80004cf2:	10f77b63          	bgeu	a4,a5,80004e08 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004cf6:	c00fb0ef          	jal	800000f6 <kalloc>
    80004cfa:	00017497          	auipc	s1,0x17
    80004cfe:	e0648493          	addi	s1,s1,-506 # 8001bb00 <disk>
    80004d02:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004d04:	bf2fb0ef          	jal	800000f6 <kalloc>
    80004d08:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004d0a:	becfb0ef          	jal	800000f6 <kalloc>
    80004d0e:	87aa                	mv	a5,a0
    80004d10:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004d12:	6088                	ld	a0,0(s1)
    80004d14:	10050063          	beqz	a0,80004e14 <virtio_disk_init+0x1ec>
    80004d18:	00017717          	auipc	a4,0x17
    80004d1c:	df073703          	ld	a4,-528(a4) # 8001bb08 <disk+0x8>
    80004d20:	0e070a63          	beqz	a4,80004e14 <virtio_disk_init+0x1ec>
    80004d24:	0e078863          	beqz	a5,80004e14 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004d28:	6605                	lui	a2,0x1
    80004d2a:	4581                	li	a1,0
    80004d2c:	c08fb0ef          	jal	80000134 <memset>
  memset(disk.avail, 0, PGSIZE);
    80004d30:	00017497          	auipc	s1,0x17
    80004d34:	dd048493          	addi	s1,s1,-560 # 8001bb00 <disk>
    80004d38:	6605                	lui	a2,0x1
    80004d3a:	4581                	li	a1,0
    80004d3c:	6488                	ld	a0,8(s1)
    80004d3e:	bf6fb0ef          	jal	80000134 <memset>
  memset(disk.used, 0, PGSIZE);
    80004d42:	6605                	lui	a2,0x1
    80004d44:	4581                	li	a1,0
    80004d46:	6888                	ld	a0,16(s1)
    80004d48:	becfb0ef          	jal	80000134 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004d4c:	100017b7          	lui	a5,0x10001
    80004d50:	4721                	li	a4,8
    80004d52:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004d54:	4098                	lw	a4,0(s1)
    80004d56:	100017b7          	lui	a5,0x10001
    80004d5a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004d5e:	40d8                	lw	a4,4(s1)
    80004d60:	100017b7          	lui	a5,0x10001
    80004d64:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004d68:	649c                	ld	a5,8(s1)
    80004d6a:	0007869b          	sext.w	a3,a5
    80004d6e:	10001737          	lui	a4,0x10001
    80004d72:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004d76:	9781                	srai	a5,a5,0x20
    80004d78:	10001737          	lui	a4,0x10001
    80004d7c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004d80:	689c                	ld	a5,16(s1)
    80004d82:	0007869b          	sext.w	a3,a5
    80004d86:	10001737          	lui	a4,0x10001
    80004d8a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004d8e:	9781                	srai	a5,a5,0x20
    80004d90:	10001737          	lui	a4,0x10001
    80004d94:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004d98:	10001737          	lui	a4,0x10001
    80004d9c:	4785                	li	a5,1
    80004d9e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004da0:	00f48c23          	sb	a5,24(s1)
    80004da4:	00f48ca3          	sb	a5,25(s1)
    80004da8:	00f48d23          	sb	a5,26(s1)
    80004dac:	00f48da3          	sb	a5,27(s1)
    80004db0:	00f48e23          	sb	a5,28(s1)
    80004db4:	00f48ea3          	sb	a5,29(s1)
    80004db8:	00f48f23          	sb	a5,30(s1)
    80004dbc:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004dc0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004dc4:	100017b7          	lui	a5,0x10001
    80004dc8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004dcc:	60e2                	ld	ra,24(sp)
    80004dce:	6442                	ld	s0,16(sp)
    80004dd0:	64a2                	ld	s1,8(sp)
    80004dd2:	6902                	ld	s2,0(sp)
    80004dd4:	6105                	addi	sp,sp,32
    80004dd6:	8082                	ret
    panic("could not find virtio disk");
    80004dd8:	00003517          	auipc	a0,0x3
    80004ddc:	9e050513          	addi	a0,a0,-1568 # 800077b8 <etext+0x7b8>
    80004de0:	273000ef          	jal	80005852 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004de4:	00003517          	auipc	a0,0x3
    80004de8:	9f450513          	addi	a0,a0,-1548 # 800077d8 <etext+0x7d8>
    80004dec:	267000ef          	jal	80005852 <panic>
    panic("virtio disk should not be ready");
    80004df0:	00003517          	auipc	a0,0x3
    80004df4:	a0850513          	addi	a0,a0,-1528 # 800077f8 <etext+0x7f8>
    80004df8:	25b000ef          	jal	80005852 <panic>
    panic("virtio disk has no queue 0");
    80004dfc:	00003517          	auipc	a0,0x3
    80004e00:	a1c50513          	addi	a0,a0,-1508 # 80007818 <etext+0x818>
    80004e04:	24f000ef          	jal	80005852 <panic>
    panic("virtio disk max queue too short");
    80004e08:	00003517          	auipc	a0,0x3
    80004e0c:	a3050513          	addi	a0,a0,-1488 # 80007838 <etext+0x838>
    80004e10:	243000ef          	jal	80005852 <panic>
    panic("virtio disk kalloc");
    80004e14:	00003517          	auipc	a0,0x3
    80004e18:	a4450513          	addi	a0,a0,-1468 # 80007858 <etext+0x858>
    80004e1c:	237000ef          	jal	80005852 <panic>

0000000080004e20 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004e20:	7159                	addi	sp,sp,-112
    80004e22:	f486                	sd	ra,104(sp)
    80004e24:	f0a2                	sd	s0,96(sp)
    80004e26:	eca6                	sd	s1,88(sp)
    80004e28:	e8ca                	sd	s2,80(sp)
    80004e2a:	e4ce                	sd	s3,72(sp)
    80004e2c:	e0d2                	sd	s4,64(sp)
    80004e2e:	fc56                	sd	s5,56(sp)
    80004e30:	f85a                	sd	s6,48(sp)
    80004e32:	f45e                	sd	s7,40(sp)
    80004e34:	f062                	sd	s8,32(sp)
    80004e36:	ec66                	sd	s9,24(sp)
    80004e38:	1880                	addi	s0,sp,112
    80004e3a:	8a2a                	mv	s4,a0
    80004e3c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004e3e:	00c52c83          	lw	s9,12(a0)
    80004e42:	001c9c9b          	slliw	s9,s9,0x1
    80004e46:	1c82                	slli	s9,s9,0x20
    80004e48:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004e4c:	00017517          	auipc	a0,0x17
    80004e50:	ddc50513          	addi	a0,a0,-548 # 8001bc28 <disk+0x128>
    80004e54:	52d000ef          	jal	80005b80 <acquire>
  for(int i = 0; i < 3; i++){
    80004e58:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004e5a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004e5c:	00017b17          	auipc	s6,0x17
    80004e60:	ca4b0b13          	addi	s6,s6,-860 # 8001bb00 <disk>
  for(int i = 0; i < 3; i++){
    80004e64:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004e66:	00017c17          	auipc	s8,0x17
    80004e6a:	dc2c0c13          	addi	s8,s8,-574 # 8001bc28 <disk+0x128>
    80004e6e:	a8b9                	j	80004ecc <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004e70:	00fb0733          	add	a4,s6,a5
    80004e74:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004e78:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004e7a:	0207c563          	bltz	a5,80004ea4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004e7e:	2905                	addiw	s2,s2,1
    80004e80:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004e82:	05590963          	beq	s2,s5,80004ed4 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004e86:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004e88:	00017717          	auipc	a4,0x17
    80004e8c:	c7870713          	addi	a4,a4,-904 # 8001bb00 <disk>
    80004e90:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004e92:	01874683          	lbu	a3,24(a4)
    80004e96:	fee9                	bnez	a3,80004e70 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004e98:	2785                	addiw	a5,a5,1
    80004e9a:	0705                	addi	a4,a4,1
    80004e9c:	fe979be3          	bne	a5,s1,80004e92 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004ea0:	57fd                	li	a5,-1
    80004ea2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004ea4:	01205d63          	blez	s2,80004ebe <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004ea8:	f9042503          	lw	a0,-112(s0)
    80004eac:	d07ff0ef          	jal	80004bb2 <free_desc>
      for(int j = 0; j < i; j++)
    80004eb0:	4785                	li	a5,1
    80004eb2:	0127d663          	bge	a5,s2,80004ebe <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004eb6:	f9442503          	lw	a0,-108(s0)
    80004eba:	cf9ff0ef          	jal	80004bb2 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004ebe:	85e2                	mv	a1,s8
    80004ec0:	00017517          	auipc	a0,0x17
    80004ec4:	c5850513          	addi	a0,a0,-936 # 8001bb18 <disk+0x18>
    80004ec8:	c68fc0ef          	jal	80001330 <sleep>
  for(int i = 0; i < 3; i++){
    80004ecc:	f9040613          	addi	a2,s0,-112
    80004ed0:	894e                	mv	s2,s3
    80004ed2:	bf55                	j	80004e86 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004ed4:	f9042503          	lw	a0,-112(s0)
    80004ed8:	00451693          	slli	a3,a0,0x4

  if(write)
    80004edc:	00017797          	auipc	a5,0x17
    80004ee0:	c2478793          	addi	a5,a5,-988 # 8001bb00 <disk>
    80004ee4:	00a50713          	addi	a4,a0,10
    80004ee8:	0712                	slli	a4,a4,0x4
    80004eea:	973e                	add	a4,a4,a5
    80004eec:	01703633          	snez	a2,s7
    80004ef0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004ef2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004ef6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004efa:	6398                	ld	a4,0(a5)
    80004efc:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004efe:	0a868613          	addi	a2,a3,168
    80004f02:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004f04:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004f06:	6390                	ld	a2,0(a5)
    80004f08:	00d605b3          	add	a1,a2,a3
    80004f0c:	4741                	li	a4,16
    80004f0e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004f10:	4805                	li	a6,1
    80004f12:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004f16:	f9442703          	lw	a4,-108(s0)
    80004f1a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004f1e:	0712                	slli	a4,a4,0x4
    80004f20:	963a                	add	a2,a2,a4
    80004f22:	058a0593          	addi	a1,s4,88
    80004f26:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004f28:	0007b883          	ld	a7,0(a5)
    80004f2c:	9746                	add	a4,a4,a7
    80004f2e:	40000613          	li	a2,1024
    80004f32:	c710                	sw	a2,8(a4)
  if(write)
    80004f34:	001bb613          	seqz	a2,s7
    80004f38:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004f3c:	00166613          	ori	a2,a2,1
    80004f40:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004f44:	f9842583          	lw	a1,-104(s0)
    80004f48:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004f4c:	00250613          	addi	a2,a0,2
    80004f50:	0612                	slli	a2,a2,0x4
    80004f52:	963e                	add	a2,a2,a5
    80004f54:	577d                	li	a4,-1
    80004f56:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004f5a:	0592                	slli	a1,a1,0x4
    80004f5c:	98ae                	add	a7,a7,a1
    80004f5e:	03068713          	addi	a4,a3,48
    80004f62:	973e                	add	a4,a4,a5
    80004f64:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004f68:	6398                	ld	a4,0(a5)
    80004f6a:	972e                	add	a4,a4,a1
    80004f6c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004f70:	4689                	li	a3,2
    80004f72:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004f76:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004f7a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004f7e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004f82:	6794                	ld	a3,8(a5)
    80004f84:	0026d703          	lhu	a4,2(a3)
    80004f88:	8b1d                	andi	a4,a4,7
    80004f8a:	0706                	slli	a4,a4,0x1
    80004f8c:	96ba                	add	a3,a3,a4
    80004f8e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004f92:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004f96:	6798                	ld	a4,8(a5)
    80004f98:	00275783          	lhu	a5,2(a4)
    80004f9c:	2785                	addiw	a5,a5,1
    80004f9e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004fa2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004fa6:	100017b7          	lui	a5,0x10001
    80004faa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004fae:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004fb2:	00017917          	auipc	s2,0x17
    80004fb6:	c7690913          	addi	s2,s2,-906 # 8001bc28 <disk+0x128>
  while(b->disk == 1) {
    80004fba:	4485                	li	s1,1
    80004fbc:	01079a63          	bne	a5,a6,80004fd0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004fc0:	85ca                	mv	a1,s2
    80004fc2:	8552                	mv	a0,s4
    80004fc4:	b6cfc0ef          	jal	80001330 <sleep>
  while(b->disk == 1) {
    80004fc8:	004a2783          	lw	a5,4(s4)
    80004fcc:	fe978ae3          	beq	a5,s1,80004fc0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004fd0:	f9042903          	lw	s2,-112(s0)
    80004fd4:	00290713          	addi	a4,s2,2
    80004fd8:	0712                	slli	a4,a4,0x4
    80004fda:	00017797          	auipc	a5,0x17
    80004fde:	b2678793          	addi	a5,a5,-1242 # 8001bb00 <disk>
    80004fe2:	97ba                	add	a5,a5,a4
    80004fe4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004fe8:	00017997          	auipc	s3,0x17
    80004fec:	b1898993          	addi	s3,s3,-1256 # 8001bb00 <disk>
    80004ff0:	00491713          	slli	a4,s2,0x4
    80004ff4:	0009b783          	ld	a5,0(s3)
    80004ff8:	97ba                	add	a5,a5,a4
    80004ffa:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004ffe:	854a                	mv	a0,s2
    80005000:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005004:	bafff0ef          	jal	80004bb2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005008:	8885                	andi	s1,s1,1
    8000500a:	f0fd                	bnez	s1,80004ff0 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000500c:	00017517          	auipc	a0,0x17
    80005010:	c1c50513          	addi	a0,a0,-996 # 8001bc28 <disk+0x128>
    80005014:	405000ef          	jal	80005c18 <release>
}
    80005018:	70a6                	ld	ra,104(sp)
    8000501a:	7406                	ld	s0,96(sp)
    8000501c:	64e6                	ld	s1,88(sp)
    8000501e:	6946                	ld	s2,80(sp)
    80005020:	69a6                	ld	s3,72(sp)
    80005022:	6a06                	ld	s4,64(sp)
    80005024:	7ae2                	ld	s5,56(sp)
    80005026:	7b42                	ld	s6,48(sp)
    80005028:	7ba2                	ld	s7,40(sp)
    8000502a:	7c02                	ld	s8,32(sp)
    8000502c:	6ce2                	ld	s9,24(sp)
    8000502e:	6165                	addi	sp,sp,112
    80005030:	8082                	ret

0000000080005032 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005032:	1101                	addi	sp,sp,-32
    80005034:	ec06                	sd	ra,24(sp)
    80005036:	e822                	sd	s0,16(sp)
    80005038:	e426                	sd	s1,8(sp)
    8000503a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000503c:	00017497          	auipc	s1,0x17
    80005040:	ac448493          	addi	s1,s1,-1340 # 8001bb00 <disk>
    80005044:	00017517          	auipc	a0,0x17
    80005048:	be450513          	addi	a0,a0,-1052 # 8001bc28 <disk+0x128>
    8000504c:	335000ef          	jal	80005b80 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005050:	100017b7          	lui	a5,0x10001
    80005054:	53b8                	lw	a4,96(a5)
    80005056:	8b0d                	andi	a4,a4,3
    80005058:	100017b7          	lui	a5,0x10001
    8000505c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    8000505e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005062:	689c                	ld	a5,16(s1)
    80005064:	0204d703          	lhu	a4,32(s1)
    80005068:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000506c:	04f70663          	beq	a4,a5,800050b8 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005070:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005074:	6898                	ld	a4,16(s1)
    80005076:	0204d783          	lhu	a5,32(s1)
    8000507a:	8b9d                	andi	a5,a5,7
    8000507c:	078e                	slli	a5,a5,0x3
    8000507e:	97ba                	add	a5,a5,a4
    80005080:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005082:	00278713          	addi	a4,a5,2
    80005086:	0712                	slli	a4,a4,0x4
    80005088:	9726                	add	a4,a4,s1
    8000508a:	01074703          	lbu	a4,16(a4)
    8000508e:	e321                	bnez	a4,800050ce <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005090:	0789                	addi	a5,a5,2
    80005092:	0792                	slli	a5,a5,0x4
    80005094:	97a6                	add	a5,a5,s1
    80005096:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005098:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000509c:	ae0fc0ef          	jal	8000137c <wakeup>

    disk.used_idx += 1;
    800050a0:	0204d783          	lhu	a5,32(s1)
    800050a4:	2785                	addiw	a5,a5,1
    800050a6:	17c2                	slli	a5,a5,0x30
    800050a8:	93c1                	srli	a5,a5,0x30
    800050aa:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800050ae:	6898                	ld	a4,16(s1)
    800050b0:	00275703          	lhu	a4,2(a4)
    800050b4:	faf71ee3          	bne	a4,a5,80005070 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800050b8:	00017517          	auipc	a0,0x17
    800050bc:	b7050513          	addi	a0,a0,-1168 # 8001bc28 <disk+0x128>
    800050c0:	359000ef          	jal	80005c18 <release>
}
    800050c4:	60e2                	ld	ra,24(sp)
    800050c6:	6442                	ld	s0,16(sp)
    800050c8:	64a2                	ld	s1,8(sp)
    800050ca:	6105                	addi	sp,sp,32
    800050cc:	8082                	ret
      panic("virtio_disk_intr status");
    800050ce:	00002517          	auipc	a0,0x2
    800050d2:	7a250513          	addi	a0,a0,1954 # 80007870 <etext+0x870>
    800050d6:	77c000ef          	jal	80005852 <panic>

00000000800050da <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    800050da:	1141                	addi	sp,sp,-16
    800050dc:	e422                	sd	s0,8(sp)
    800050de:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    800050e0:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    800050e4:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    800050e8:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    800050ec:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    800050f0:	577d                	li	a4,-1
    800050f2:	177e                	slli	a4,a4,0x3f
    800050f4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    800050f6:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    800050fa:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    800050fe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80005102:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80005106:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000510a:	000f4737          	lui	a4,0xf4
    8000510e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80005112:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80005114:	14d79073          	csrw	stimecmp,a5
}
    80005118:	6422                	ld	s0,8(sp)
    8000511a:	0141                	addi	sp,sp,16
    8000511c:	8082                	ret

000000008000511e <start>:
{
    8000511e:	1141                	addi	sp,sp,-16
    80005120:	e406                	sd	ra,8(sp)
    80005122:	e022                	sd	s0,0(sp)
    80005124:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005126:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000512a:	7779                	lui	a4,0xffffe
    8000512c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdaabf>
    80005130:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005132:	6705                	lui	a4,0x1
    80005134:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005138:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000513a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000513e:	ffffb797          	auipc	a5,0xffffb
    80005142:	19078793          	addi	a5,a5,400 # 800002ce <main>
    80005146:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000514a:	4781                	li	a5,0
    8000514c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005150:	67c1                	lui	a5,0x10
    80005152:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005154:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005158:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000515c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005160:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005164:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005168:	57fd                	li	a5,-1
    8000516a:	83a9                	srli	a5,a5,0xa
    8000516c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005170:	47bd                	li	a5,15
    80005172:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005176:	f65ff0ef          	jal	800050da <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000517a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000517e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005180:	823e                	mv	tp,a5
  asm volatile("mret");
    80005182:	30200073          	mret
}
    80005186:	60a2                	ld	ra,8(sp)
    80005188:	6402                	ld	s0,0(sp)
    8000518a:	0141                	addi	sp,sp,16
    8000518c:	8082                	ret

000000008000518e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000518e:	715d                	addi	sp,sp,-80
    80005190:	e486                	sd	ra,72(sp)
    80005192:	e0a2                	sd	s0,64(sp)
    80005194:	f84a                	sd	s2,48(sp)
    80005196:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005198:	04c05263          	blez	a2,800051dc <consolewrite+0x4e>
    8000519c:	fc26                	sd	s1,56(sp)
    8000519e:	f44e                	sd	s3,40(sp)
    800051a0:	f052                	sd	s4,32(sp)
    800051a2:	ec56                	sd	s5,24(sp)
    800051a4:	8a2a                	mv	s4,a0
    800051a6:	84ae                	mv	s1,a1
    800051a8:	89b2                	mv	s3,a2
    800051aa:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800051ac:	5afd                	li	s5,-1
    800051ae:	4685                	li	a3,1
    800051b0:	8626                	mv	a2,s1
    800051b2:	85d2                	mv	a1,s4
    800051b4:	fbf40513          	addi	a0,s0,-65
    800051b8:	d1efc0ef          	jal	800016d6 <either_copyin>
    800051bc:	03550263          	beq	a0,s5,800051e0 <consolewrite+0x52>
      break;
    uartputc(c);
    800051c0:	fbf44503          	lbu	a0,-65(s0)
    800051c4:	035000ef          	jal	800059f8 <uartputc>
  for(i = 0; i < n; i++){
    800051c8:	2905                	addiw	s2,s2,1
    800051ca:	0485                	addi	s1,s1,1
    800051cc:	ff2991e3          	bne	s3,s2,800051ae <consolewrite+0x20>
    800051d0:	894e                	mv	s2,s3
    800051d2:	74e2                	ld	s1,56(sp)
    800051d4:	79a2                	ld	s3,40(sp)
    800051d6:	7a02                	ld	s4,32(sp)
    800051d8:	6ae2                	ld	s5,24(sp)
    800051da:	a039                	j	800051e8 <consolewrite+0x5a>
    800051dc:	4901                	li	s2,0
    800051de:	a029                	j	800051e8 <consolewrite+0x5a>
    800051e0:	74e2                	ld	s1,56(sp)
    800051e2:	79a2                	ld	s3,40(sp)
    800051e4:	7a02                	ld	s4,32(sp)
    800051e6:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    800051e8:	854a                	mv	a0,s2
    800051ea:	60a6                	ld	ra,72(sp)
    800051ec:	6406                	ld	s0,64(sp)
    800051ee:	7942                	ld	s2,48(sp)
    800051f0:	6161                	addi	sp,sp,80
    800051f2:	8082                	ret

00000000800051f4 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800051f4:	711d                	addi	sp,sp,-96
    800051f6:	ec86                	sd	ra,88(sp)
    800051f8:	e8a2                	sd	s0,80(sp)
    800051fa:	e4a6                	sd	s1,72(sp)
    800051fc:	e0ca                	sd	s2,64(sp)
    800051fe:	fc4e                	sd	s3,56(sp)
    80005200:	f852                	sd	s4,48(sp)
    80005202:	f456                	sd	s5,40(sp)
    80005204:	f05a                	sd	s6,32(sp)
    80005206:	1080                	addi	s0,sp,96
    80005208:	8aaa                	mv	s5,a0
    8000520a:	8a2e                	mv	s4,a1
    8000520c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000520e:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005212:	0001f517          	auipc	a0,0x1f
    80005216:	a2e50513          	addi	a0,a0,-1490 # 80023c40 <cons>
    8000521a:	167000ef          	jal	80005b80 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000521e:	0001f497          	auipc	s1,0x1f
    80005222:	a2248493          	addi	s1,s1,-1502 # 80023c40 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005226:	0001f917          	auipc	s2,0x1f
    8000522a:	ab290913          	addi	s2,s2,-1358 # 80023cd8 <cons+0x98>
  while(n > 0){
    8000522e:	0b305d63          	blez	s3,800052e8 <consoleread+0xf4>
    while(cons.r == cons.w){
    80005232:	0984a783          	lw	a5,152(s1)
    80005236:	09c4a703          	lw	a4,156(s1)
    8000523a:	0af71263          	bne	a4,a5,800052de <consoleread+0xea>
      if(killed(myproc())){
    8000523e:	b19fb0ef          	jal	80000d56 <myproc>
    80005242:	b26fc0ef          	jal	80001568 <killed>
    80005246:	e12d                	bnez	a0,800052a8 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80005248:	85a6                	mv	a1,s1
    8000524a:	854a                	mv	a0,s2
    8000524c:	8e4fc0ef          	jal	80001330 <sleep>
    while(cons.r == cons.w){
    80005250:	0984a783          	lw	a5,152(s1)
    80005254:	09c4a703          	lw	a4,156(s1)
    80005258:	fef703e3          	beq	a4,a5,8000523e <consoleread+0x4a>
    8000525c:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000525e:	0001f717          	auipc	a4,0x1f
    80005262:	9e270713          	addi	a4,a4,-1566 # 80023c40 <cons>
    80005266:	0017869b          	addiw	a3,a5,1
    8000526a:	08d72c23          	sw	a3,152(a4)
    8000526e:	07f7f693          	andi	a3,a5,127
    80005272:	9736                	add	a4,a4,a3
    80005274:	01874703          	lbu	a4,24(a4)
    80005278:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    8000527c:	4691                	li	a3,4
    8000527e:	04db8663          	beq	s7,a3,800052ca <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005282:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005286:	4685                	li	a3,1
    80005288:	faf40613          	addi	a2,s0,-81
    8000528c:	85d2                	mv	a1,s4
    8000528e:	8556                	mv	a0,s5
    80005290:	bfcfc0ef          	jal	8000168c <either_copyout>
    80005294:	57fd                	li	a5,-1
    80005296:	04f50863          	beq	a0,a5,800052e6 <consoleread+0xf2>
      break;

    dst++;
    8000529a:	0a05                	addi	s4,s4,1
    --n;
    8000529c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000529e:	47a9                	li	a5,10
    800052a0:	04fb8d63          	beq	s7,a5,800052fa <consoleread+0x106>
    800052a4:	6be2                	ld	s7,24(sp)
    800052a6:	b761                	j	8000522e <consoleread+0x3a>
        release(&cons.lock);
    800052a8:	0001f517          	auipc	a0,0x1f
    800052ac:	99850513          	addi	a0,a0,-1640 # 80023c40 <cons>
    800052b0:	169000ef          	jal	80005c18 <release>
        return -1;
    800052b4:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800052b6:	60e6                	ld	ra,88(sp)
    800052b8:	6446                	ld	s0,80(sp)
    800052ba:	64a6                	ld	s1,72(sp)
    800052bc:	6906                	ld	s2,64(sp)
    800052be:	79e2                	ld	s3,56(sp)
    800052c0:	7a42                	ld	s4,48(sp)
    800052c2:	7aa2                	ld	s5,40(sp)
    800052c4:	7b02                	ld	s6,32(sp)
    800052c6:	6125                	addi	sp,sp,96
    800052c8:	8082                	ret
      if(n < target){
    800052ca:	0009871b          	sext.w	a4,s3
    800052ce:	01677a63          	bgeu	a4,s6,800052e2 <consoleread+0xee>
        cons.r--;
    800052d2:	0001f717          	auipc	a4,0x1f
    800052d6:	a0f72323          	sw	a5,-1530(a4) # 80023cd8 <cons+0x98>
    800052da:	6be2                	ld	s7,24(sp)
    800052dc:	a031                	j	800052e8 <consoleread+0xf4>
    800052de:	ec5e                	sd	s7,24(sp)
    800052e0:	bfbd                	j	8000525e <consoleread+0x6a>
    800052e2:	6be2                	ld	s7,24(sp)
    800052e4:	a011                	j	800052e8 <consoleread+0xf4>
    800052e6:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    800052e8:	0001f517          	auipc	a0,0x1f
    800052ec:	95850513          	addi	a0,a0,-1704 # 80023c40 <cons>
    800052f0:	129000ef          	jal	80005c18 <release>
  return target - n;
    800052f4:	413b053b          	subw	a0,s6,s3
    800052f8:	bf7d                	j	800052b6 <consoleread+0xc2>
    800052fa:	6be2                	ld	s7,24(sp)
    800052fc:	b7f5                	j	800052e8 <consoleread+0xf4>

00000000800052fe <consputc>:
{
    800052fe:	1141                	addi	sp,sp,-16
    80005300:	e406                	sd	ra,8(sp)
    80005302:	e022                	sd	s0,0(sp)
    80005304:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005306:	10000793          	li	a5,256
    8000530a:	00f50863          	beq	a0,a5,8000531a <consputc+0x1c>
    uartputc_sync(c);
    8000530e:	604000ef          	jal	80005912 <uartputc_sync>
}
    80005312:	60a2                	ld	ra,8(sp)
    80005314:	6402                	ld	s0,0(sp)
    80005316:	0141                	addi	sp,sp,16
    80005318:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000531a:	4521                	li	a0,8
    8000531c:	5f6000ef          	jal	80005912 <uartputc_sync>
    80005320:	02000513          	li	a0,32
    80005324:	5ee000ef          	jal	80005912 <uartputc_sync>
    80005328:	4521                	li	a0,8
    8000532a:	5e8000ef          	jal	80005912 <uartputc_sync>
    8000532e:	b7d5                	j	80005312 <consputc+0x14>

0000000080005330 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005330:	1101                	addi	sp,sp,-32
    80005332:	ec06                	sd	ra,24(sp)
    80005334:	e822                	sd	s0,16(sp)
    80005336:	e426                	sd	s1,8(sp)
    80005338:	1000                	addi	s0,sp,32
    8000533a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000533c:	0001f517          	auipc	a0,0x1f
    80005340:	90450513          	addi	a0,a0,-1788 # 80023c40 <cons>
    80005344:	03d000ef          	jal	80005b80 <acquire>

  switch(c){
    80005348:	47d5                	li	a5,21
    8000534a:	08f48f63          	beq	s1,a5,800053e8 <consoleintr+0xb8>
    8000534e:	0297c563          	blt	a5,s1,80005378 <consoleintr+0x48>
    80005352:	47a1                	li	a5,8
    80005354:	0ef48463          	beq	s1,a5,8000543c <consoleintr+0x10c>
    80005358:	47c1                	li	a5,16
    8000535a:	10f49563          	bne	s1,a5,80005464 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    8000535e:	bc2fc0ef          	jal	80001720 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005362:	0001f517          	auipc	a0,0x1f
    80005366:	8de50513          	addi	a0,a0,-1826 # 80023c40 <cons>
    8000536a:	0af000ef          	jal	80005c18 <release>
}
    8000536e:	60e2                	ld	ra,24(sp)
    80005370:	6442                	ld	s0,16(sp)
    80005372:	64a2                	ld	s1,8(sp)
    80005374:	6105                	addi	sp,sp,32
    80005376:	8082                	ret
  switch(c){
    80005378:	07f00793          	li	a5,127
    8000537c:	0cf48063          	beq	s1,a5,8000543c <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005380:	0001f717          	auipc	a4,0x1f
    80005384:	8c070713          	addi	a4,a4,-1856 # 80023c40 <cons>
    80005388:	0a072783          	lw	a5,160(a4)
    8000538c:	09872703          	lw	a4,152(a4)
    80005390:	9f99                	subw	a5,a5,a4
    80005392:	07f00713          	li	a4,127
    80005396:	fcf766e3          	bltu	a4,a5,80005362 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    8000539a:	47b5                	li	a5,13
    8000539c:	0cf48763          	beq	s1,a5,8000546a <consoleintr+0x13a>
      consputc(c);
    800053a0:	8526                	mv	a0,s1
    800053a2:	f5dff0ef          	jal	800052fe <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800053a6:	0001f797          	auipc	a5,0x1f
    800053aa:	89a78793          	addi	a5,a5,-1894 # 80023c40 <cons>
    800053ae:	0a07a683          	lw	a3,160(a5)
    800053b2:	0016871b          	addiw	a4,a3,1
    800053b6:	0007061b          	sext.w	a2,a4
    800053ba:	0ae7a023          	sw	a4,160(a5)
    800053be:	07f6f693          	andi	a3,a3,127
    800053c2:	97b6                	add	a5,a5,a3
    800053c4:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800053c8:	47a9                	li	a5,10
    800053ca:	0cf48563          	beq	s1,a5,80005494 <consoleintr+0x164>
    800053ce:	4791                	li	a5,4
    800053d0:	0cf48263          	beq	s1,a5,80005494 <consoleintr+0x164>
    800053d4:	0001f797          	auipc	a5,0x1f
    800053d8:	9047a783          	lw	a5,-1788(a5) # 80023cd8 <cons+0x98>
    800053dc:	9f1d                	subw	a4,a4,a5
    800053de:	08000793          	li	a5,128
    800053e2:	f8f710e3          	bne	a4,a5,80005362 <consoleintr+0x32>
    800053e6:	a07d                	j	80005494 <consoleintr+0x164>
    800053e8:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800053ea:	0001f717          	auipc	a4,0x1f
    800053ee:	85670713          	addi	a4,a4,-1962 # 80023c40 <cons>
    800053f2:	0a072783          	lw	a5,160(a4)
    800053f6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800053fa:	0001f497          	auipc	s1,0x1f
    800053fe:	84648493          	addi	s1,s1,-1978 # 80023c40 <cons>
    while(cons.e != cons.w &&
    80005402:	4929                	li	s2,10
    80005404:	02f70863          	beq	a4,a5,80005434 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005408:	37fd                	addiw	a5,a5,-1
    8000540a:	07f7f713          	andi	a4,a5,127
    8000540e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005410:	01874703          	lbu	a4,24(a4)
    80005414:	03270263          	beq	a4,s2,80005438 <consoleintr+0x108>
      cons.e--;
    80005418:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000541c:	10000513          	li	a0,256
    80005420:	edfff0ef          	jal	800052fe <consputc>
    while(cons.e != cons.w &&
    80005424:	0a04a783          	lw	a5,160(s1)
    80005428:	09c4a703          	lw	a4,156(s1)
    8000542c:	fcf71ee3          	bne	a4,a5,80005408 <consoleintr+0xd8>
    80005430:	6902                	ld	s2,0(sp)
    80005432:	bf05                	j	80005362 <consoleintr+0x32>
    80005434:	6902                	ld	s2,0(sp)
    80005436:	b735                	j	80005362 <consoleintr+0x32>
    80005438:	6902                	ld	s2,0(sp)
    8000543a:	b725                	j	80005362 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000543c:	0001f717          	auipc	a4,0x1f
    80005440:	80470713          	addi	a4,a4,-2044 # 80023c40 <cons>
    80005444:	0a072783          	lw	a5,160(a4)
    80005448:	09c72703          	lw	a4,156(a4)
    8000544c:	f0f70be3          	beq	a4,a5,80005362 <consoleintr+0x32>
      cons.e--;
    80005450:	37fd                	addiw	a5,a5,-1
    80005452:	0001f717          	auipc	a4,0x1f
    80005456:	88f72723          	sw	a5,-1906(a4) # 80023ce0 <cons+0xa0>
      consputc(BACKSPACE);
    8000545a:	10000513          	li	a0,256
    8000545e:	ea1ff0ef          	jal	800052fe <consputc>
    80005462:	b701                	j	80005362 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005464:	ee048fe3          	beqz	s1,80005362 <consoleintr+0x32>
    80005468:	bf21                	j	80005380 <consoleintr+0x50>
      consputc(c);
    8000546a:	4529                	li	a0,10
    8000546c:	e93ff0ef          	jal	800052fe <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005470:	0001e797          	auipc	a5,0x1e
    80005474:	7d078793          	addi	a5,a5,2000 # 80023c40 <cons>
    80005478:	0a07a703          	lw	a4,160(a5)
    8000547c:	0017069b          	addiw	a3,a4,1
    80005480:	0006861b          	sext.w	a2,a3
    80005484:	0ad7a023          	sw	a3,160(a5)
    80005488:	07f77713          	andi	a4,a4,127
    8000548c:	97ba                	add	a5,a5,a4
    8000548e:	4729                	li	a4,10
    80005490:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005494:	0001f797          	auipc	a5,0x1f
    80005498:	84c7a423          	sw	a2,-1976(a5) # 80023cdc <cons+0x9c>
        wakeup(&cons.r);
    8000549c:	0001f517          	auipc	a0,0x1f
    800054a0:	83c50513          	addi	a0,a0,-1988 # 80023cd8 <cons+0x98>
    800054a4:	ed9fb0ef          	jal	8000137c <wakeup>
    800054a8:	bd6d                	j	80005362 <consoleintr+0x32>

00000000800054aa <consoleinit>:

void
consoleinit(void)
{
    800054aa:	1141                	addi	sp,sp,-16
    800054ac:	e406                	sd	ra,8(sp)
    800054ae:	e022                	sd	s0,0(sp)
    800054b0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800054b2:	00002597          	auipc	a1,0x2
    800054b6:	3d658593          	addi	a1,a1,982 # 80007888 <etext+0x888>
    800054ba:	0001e517          	auipc	a0,0x1e
    800054be:	78650513          	addi	a0,a0,1926 # 80023c40 <cons>
    800054c2:	63e000ef          	jal	80005b00 <initlock>

  uartinit();
    800054c6:	3f4000ef          	jal	800058ba <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800054ca:	00015797          	auipc	a5,0x15
    800054ce:	5de78793          	addi	a5,a5,1502 # 8001aaa8 <devsw>
    800054d2:	00000717          	auipc	a4,0x0
    800054d6:	d2270713          	addi	a4,a4,-734 # 800051f4 <consoleread>
    800054da:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800054dc:	00000717          	auipc	a4,0x0
    800054e0:	cb270713          	addi	a4,a4,-846 # 8000518e <consolewrite>
    800054e4:	ef98                	sd	a4,24(a5)
}
    800054e6:	60a2                	ld	ra,8(sp)
    800054e8:	6402                	ld	s0,0(sp)
    800054ea:	0141                	addi	sp,sp,16
    800054ec:	8082                	ret

00000000800054ee <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800054ee:	7179                	addi	sp,sp,-48
    800054f0:	f406                	sd	ra,40(sp)
    800054f2:	f022                	sd	s0,32(sp)
    800054f4:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800054f6:	c219                	beqz	a2,800054fc <printint+0xe>
    800054f8:	08054063          	bltz	a0,80005578 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    800054fc:	4881                	li	a7,0
    800054fe:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005502:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005504:	00002617          	auipc	a2,0x2
    80005508:	70c60613          	addi	a2,a2,1804 # 80007c10 <digits>
    8000550c:	883e                	mv	a6,a5
    8000550e:	2785                	addiw	a5,a5,1
    80005510:	02b57733          	remu	a4,a0,a1
    80005514:	9732                	add	a4,a4,a2
    80005516:	00074703          	lbu	a4,0(a4)
    8000551a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000551e:	872a                	mv	a4,a0
    80005520:	02b55533          	divu	a0,a0,a1
    80005524:	0685                	addi	a3,a3,1
    80005526:	feb773e3          	bgeu	a4,a1,8000550c <printint+0x1e>

  if(sign)
    8000552a:	00088a63          	beqz	a7,8000553e <printint+0x50>
    buf[i++] = '-';
    8000552e:	1781                	addi	a5,a5,-32
    80005530:	97a2                	add	a5,a5,s0
    80005532:	02d00713          	li	a4,45
    80005536:	fee78823          	sb	a4,-16(a5)
    8000553a:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    8000553e:	02f05963          	blez	a5,80005570 <printint+0x82>
    80005542:	ec26                	sd	s1,24(sp)
    80005544:	e84a                	sd	s2,16(sp)
    80005546:	fd040713          	addi	a4,s0,-48
    8000554a:	00f704b3          	add	s1,a4,a5
    8000554e:	fff70913          	addi	s2,a4,-1
    80005552:	993e                	add	s2,s2,a5
    80005554:	37fd                	addiw	a5,a5,-1
    80005556:	1782                	slli	a5,a5,0x20
    80005558:	9381                	srli	a5,a5,0x20
    8000555a:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000555e:	fff4c503          	lbu	a0,-1(s1)
    80005562:	d9dff0ef          	jal	800052fe <consputc>
  while(--i >= 0)
    80005566:	14fd                	addi	s1,s1,-1
    80005568:	ff249be3          	bne	s1,s2,8000555e <printint+0x70>
    8000556c:	64e2                	ld	s1,24(sp)
    8000556e:	6942                	ld	s2,16(sp)
}
    80005570:	70a2                	ld	ra,40(sp)
    80005572:	7402                	ld	s0,32(sp)
    80005574:	6145                	addi	sp,sp,48
    80005576:	8082                	ret
    x = -xx;
    80005578:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000557c:	4885                	li	a7,1
    x = -xx;
    8000557e:	b741                	j	800054fe <printint+0x10>

0000000080005580 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005580:	7155                	addi	sp,sp,-208
    80005582:	e506                	sd	ra,136(sp)
    80005584:	e122                	sd	s0,128(sp)
    80005586:	f0d2                	sd	s4,96(sp)
    80005588:	0900                	addi	s0,sp,144
    8000558a:	8a2a                	mv	s4,a0
    8000558c:	e40c                	sd	a1,8(s0)
    8000558e:	e810                	sd	a2,16(s0)
    80005590:	ec14                	sd	a3,24(s0)
    80005592:	f018                	sd	a4,32(s0)
    80005594:	f41c                	sd	a5,40(s0)
    80005596:	03043823          	sd	a6,48(s0)
    8000559a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    8000559e:	0001e797          	auipc	a5,0x1e
    800055a2:	7627a783          	lw	a5,1890(a5) # 80023d00 <pr+0x18>
    800055a6:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800055aa:	e3a1                	bnez	a5,800055ea <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800055ac:	00840793          	addi	a5,s0,8
    800055b0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800055b4:	00054503          	lbu	a0,0(a0)
    800055b8:	26050763          	beqz	a0,80005826 <printf+0x2a6>
    800055bc:	fca6                	sd	s1,120(sp)
    800055be:	f8ca                	sd	s2,112(sp)
    800055c0:	f4ce                	sd	s3,104(sp)
    800055c2:	ecd6                	sd	s5,88(sp)
    800055c4:	e8da                	sd	s6,80(sp)
    800055c6:	e0e2                	sd	s8,64(sp)
    800055c8:	fc66                	sd	s9,56(sp)
    800055ca:	f86a                	sd	s10,48(sp)
    800055cc:	f46e                	sd	s11,40(sp)
    800055ce:	4981                	li	s3,0
    if(cx != '%'){
    800055d0:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800055d4:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800055d8:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800055dc:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800055e0:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800055e4:	07000d93          	li	s11,112
    800055e8:	a815                	j	8000561c <printf+0x9c>
    acquire(&pr.lock);
    800055ea:	0001e517          	auipc	a0,0x1e
    800055ee:	6fe50513          	addi	a0,a0,1790 # 80023ce8 <pr>
    800055f2:	58e000ef          	jal	80005b80 <acquire>
  va_start(ap, fmt);
    800055f6:	00840793          	addi	a5,s0,8
    800055fa:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800055fe:	000a4503          	lbu	a0,0(s4)
    80005602:	fd4d                	bnez	a0,800055bc <printf+0x3c>
    80005604:	a481                	j	80005844 <printf+0x2c4>
      consputc(cx);
    80005606:	cf9ff0ef          	jal	800052fe <consputc>
      continue;
    8000560a:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000560c:	0014899b          	addiw	s3,s1,1
    80005610:	013a07b3          	add	a5,s4,s3
    80005614:	0007c503          	lbu	a0,0(a5)
    80005618:	1e050b63          	beqz	a0,8000580e <printf+0x28e>
    if(cx != '%'){
    8000561c:	ff5515e3          	bne	a0,s5,80005606 <printf+0x86>
    i++;
    80005620:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80005624:	009a07b3          	add	a5,s4,s1
    80005628:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000562c:	1e090163          	beqz	s2,8000580e <printf+0x28e>
    80005630:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80005634:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80005636:	c789                	beqz	a5,80005640 <printf+0xc0>
    80005638:	009a0733          	add	a4,s4,s1
    8000563c:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005640:	03690763          	beq	s2,s6,8000566e <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80005644:	05890163          	beq	s2,s8,80005686 <printf+0x106>
    } else if(c0 == 'u'){
    80005648:	0d990b63          	beq	s2,s9,8000571e <printf+0x19e>
    } else if(c0 == 'x'){
    8000564c:	13a90163          	beq	s2,s10,8000576e <printf+0x1ee>
    } else if(c0 == 'p'){
    80005650:	13b90b63          	beq	s2,s11,80005786 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005654:	07300793          	li	a5,115
    80005658:	16f90a63          	beq	s2,a5,800057cc <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000565c:	1b590463          	beq	s2,s5,80005804 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005660:	8556                	mv	a0,s5
    80005662:	c9dff0ef          	jal	800052fe <consputc>
      consputc(c0);
    80005666:	854a                	mv	a0,s2
    80005668:	c97ff0ef          	jal	800052fe <consputc>
    8000566c:	b745                	j	8000560c <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    8000566e:	f8843783          	ld	a5,-120(s0)
    80005672:	00878713          	addi	a4,a5,8
    80005676:	f8e43423          	sd	a4,-120(s0)
    8000567a:	4605                	li	a2,1
    8000567c:	45a9                	li	a1,10
    8000567e:	4388                	lw	a0,0(a5)
    80005680:	e6fff0ef          	jal	800054ee <printint>
    80005684:	b761                	j	8000560c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    80005686:	03678663          	beq	a5,s6,800056b2 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000568a:	05878263          	beq	a5,s8,800056ce <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    8000568e:	0b978463          	beq	a5,s9,80005736 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    80005692:	fda797e3          	bne	a5,s10,80005660 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005696:	f8843783          	ld	a5,-120(s0)
    8000569a:	00878713          	addi	a4,a5,8
    8000569e:	f8e43423          	sd	a4,-120(s0)
    800056a2:	4601                	li	a2,0
    800056a4:	45c1                	li	a1,16
    800056a6:	6388                	ld	a0,0(a5)
    800056a8:	e47ff0ef          	jal	800054ee <printint>
      i += 1;
    800056ac:	0029849b          	addiw	s1,s3,2
    800056b0:	bfb1                	j	8000560c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800056b2:	f8843783          	ld	a5,-120(s0)
    800056b6:	00878713          	addi	a4,a5,8
    800056ba:	f8e43423          	sd	a4,-120(s0)
    800056be:	4605                	li	a2,1
    800056c0:	45a9                	li	a1,10
    800056c2:	6388                	ld	a0,0(a5)
    800056c4:	e2bff0ef          	jal	800054ee <printint>
      i += 1;
    800056c8:	0029849b          	addiw	s1,s3,2
    800056cc:	b781                	j	8000560c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800056ce:	06400793          	li	a5,100
    800056d2:	02f68863          	beq	a3,a5,80005702 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800056d6:	07500793          	li	a5,117
    800056da:	06f68c63          	beq	a3,a5,80005752 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800056de:	07800793          	li	a5,120
    800056e2:	f6f69fe3          	bne	a3,a5,80005660 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800056e6:	f8843783          	ld	a5,-120(s0)
    800056ea:	00878713          	addi	a4,a5,8
    800056ee:	f8e43423          	sd	a4,-120(s0)
    800056f2:	4601                	li	a2,0
    800056f4:	45c1                	li	a1,16
    800056f6:	6388                	ld	a0,0(a5)
    800056f8:	df7ff0ef          	jal	800054ee <printint>
      i += 2;
    800056fc:	0039849b          	addiw	s1,s3,3
    80005700:	b731                	j	8000560c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005702:	f8843783          	ld	a5,-120(s0)
    80005706:	00878713          	addi	a4,a5,8
    8000570a:	f8e43423          	sd	a4,-120(s0)
    8000570e:	4605                	li	a2,1
    80005710:	45a9                	li	a1,10
    80005712:	6388                	ld	a0,0(a5)
    80005714:	ddbff0ef          	jal	800054ee <printint>
      i += 2;
    80005718:	0039849b          	addiw	s1,s3,3
    8000571c:	bdc5                	j	8000560c <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    8000571e:	f8843783          	ld	a5,-120(s0)
    80005722:	00878713          	addi	a4,a5,8
    80005726:	f8e43423          	sd	a4,-120(s0)
    8000572a:	4601                	li	a2,0
    8000572c:	45a9                	li	a1,10
    8000572e:	4388                	lw	a0,0(a5)
    80005730:	dbfff0ef          	jal	800054ee <printint>
    80005734:	bde1                	j	8000560c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005736:	f8843783          	ld	a5,-120(s0)
    8000573a:	00878713          	addi	a4,a5,8
    8000573e:	f8e43423          	sd	a4,-120(s0)
    80005742:	4601                	li	a2,0
    80005744:	45a9                	li	a1,10
    80005746:	6388                	ld	a0,0(a5)
    80005748:	da7ff0ef          	jal	800054ee <printint>
      i += 1;
    8000574c:	0029849b          	addiw	s1,s3,2
    80005750:	bd75                	j	8000560c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005752:	f8843783          	ld	a5,-120(s0)
    80005756:	00878713          	addi	a4,a5,8
    8000575a:	f8e43423          	sd	a4,-120(s0)
    8000575e:	4601                	li	a2,0
    80005760:	45a9                	li	a1,10
    80005762:	6388                	ld	a0,0(a5)
    80005764:	d8bff0ef          	jal	800054ee <printint>
      i += 2;
    80005768:	0039849b          	addiw	s1,s3,3
    8000576c:	b545                	j	8000560c <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    8000576e:	f8843783          	ld	a5,-120(s0)
    80005772:	00878713          	addi	a4,a5,8
    80005776:	f8e43423          	sd	a4,-120(s0)
    8000577a:	4601                	li	a2,0
    8000577c:	45c1                	li	a1,16
    8000577e:	4388                	lw	a0,0(a5)
    80005780:	d6fff0ef          	jal	800054ee <printint>
    80005784:	b561                	j	8000560c <printf+0x8c>
    80005786:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    80005788:	f8843783          	ld	a5,-120(s0)
    8000578c:	00878713          	addi	a4,a5,8
    80005790:	f8e43423          	sd	a4,-120(s0)
    80005794:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005798:	03000513          	li	a0,48
    8000579c:	b63ff0ef          	jal	800052fe <consputc>
  consputc('x');
    800057a0:	07800513          	li	a0,120
    800057a4:	b5bff0ef          	jal	800052fe <consputc>
    800057a8:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800057aa:	00002b97          	auipc	s7,0x2
    800057ae:	466b8b93          	addi	s7,s7,1126 # 80007c10 <digits>
    800057b2:	03c9d793          	srli	a5,s3,0x3c
    800057b6:	97de                	add	a5,a5,s7
    800057b8:	0007c503          	lbu	a0,0(a5)
    800057bc:	b43ff0ef          	jal	800052fe <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800057c0:	0992                	slli	s3,s3,0x4
    800057c2:	397d                	addiw	s2,s2,-1
    800057c4:	fe0917e3          	bnez	s2,800057b2 <printf+0x232>
    800057c8:	6ba6                	ld	s7,72(sp)
    800057ca:	b589                	j	8000560c <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    800057cc:	f8843783          	ld	a5,-120(s0)
    800057d0:	00878713          	addi	a4,a5,8
    800057d4:	f8e43423          	sd	a4,-120(s0)
    800057d8:	0007b903          	ld	s2,0(a5)
    800057dc:	00090d63          	beqz	s2,800057f6 <printf+0x276>
      for(; *s; s++)
    800057e0:	00094503          	lbu	a0,0(s2)
    800057e4:	e20504e3          	beqz	a0,8000560c <printf+0x8c>
        consputc(*s);
    800057e8:	b17ff0ef          	jal	800052fe <consputc>
      for(; *s; s++)
    800057ec:	0905                	addi	s2,s2,1
    800057ee:	00094503          	lbu	a0,0(s2)
    800057f2:	f97d                	bnez	a0,800057e8 <printf+0x268>
    800057f4:	bd21                	j	8000560c <printf+0x8c>
        s = "(null)";
    800057f6:	00002917          	auipc	s2,0x2
    800057fa:	09a90913          	addi	s2,s2,154 # 80007890 <etext+0x890>
      for(; *s; s++)
    800057fe:	02800513          	li	a0,40
    80005802:	b7dd                	j	800057e8 <printf+0x268>
      consputc('%');
    80005804:	02500513          	li	a0,37
    80005808:	af7ff0ef          	jal	800052fe <consputc>
    8000580c:	b501                	j	8000560c <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000580e:	f7843783          	ld	a5,-136(s0)
    80005812:	e385                	bnez	a5,80005832 <printf+0x2b2>
    80005814:	74e6                	ld	s1,120(sp)
    80005816:	7946                	ld	s2,112(sp)
    80005818:	79a6                	ld	s3,104(sp)
    8000581a:	6ae6                	ld	s5,88(sp)
    8000581c:	6b46                	ld	s6,80(sp)
    8000581e:	6c06                	ld	s8,64(sp)
    80005820:	7ce2                	ld	s9,56(sp)
    80005822:	7d42                	ld	s10,48(sp)
    80005824:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80005826:	4501                	li	a0,0
    80005828:	60aa                	ld	ra,136(sp)
    8000582a:	640a                	ld	s0,128(sp)
    8000582c:	7a06                	ld	s4,96(sp)
    8000582e:	6169                	addi	sp,sp,208
    80005830:	8082                	ret
    80005832:	74e6                	ld	s1,120(sp)
    80005834:	7946                	ld	s2,112(sp)
    80005836:	79a6                	ld	s3,104(sp)
    80005838:	6ae6                	ld	s5,88(sp)
    8000583a:	6b46                	ld	s6,80(sp)
    8000583c:	6c06                	ld	s8,64(sp)
    8000583e:	7ce2                	ld	s9,56(sp)
    80005840:	7d42                	ld	s10,48(sp)
    80005842:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005844:	0001e517          	auipc	a0,0x1e
    80005848:	4a450513          	addi	a0,a0,1188 # 80023ce8 <pr>
    8000584c:	3cc000ef          	jal	80005c18 <release>
    80005850:	bfd9                	j	80005826 <printf+0x2a6>

0000000080005852 <panic>:

void
panic(char *s)
{
    80005852:	1101                	addi	sp,sp,-32
    80005854:	ec06                	sd	ra,24(sp)
    80005856:	e822                	sd	s0,16(sp)
    80005858:	e426                	sd	s1,8(sp)
    8000585a:	1000                	addi	s0,sp,32
    8000585c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000585e:	0001e797          	auipc	a5,0x1e
    80005862:	4a07a123          	sw	zero,1186(a5) # 80023d00 <pr+0x18>
  printf("panic: ");
    80005866:	00002517          	auipc	a0,0x2
    8000586a:	03250513          	addi	a0,a0,50 # 80007898 <etext+0x898>
    8000586e:	d13ff0ef          	jal	80005580 <printf>
  printf("%s\n", s);
    80005872:	85a6                	mv	a1,s1
    80005874:	00002517          	auipc	a0,0x2
    80005878:	02c50513          	addi	a0,a0,44 # 800078a0 <etext+0x8a0>
    8000587c:	d05ff0ef          	jal	80005580 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005880:	4785                	li	a5,1
    80005882:	00005717          	auipc	a4,0x5
    80005886:	f0f72523          	sw	a5,-246(a4) # 8000a78c <panicked>
  for(;;)
    8000588a:	a001                	j	8000588a <panic+0x38>

000000008000588c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000588c:	1101                	addi	sp,sp,-32
    8000588e:	ec06                	sd	ra,24(sp)
    80005890:	e822                	sd	s0,16(sp)
    80005892:	e426                	sd	s1,8(sp)
    80005894:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005896:	0001e497          	auipc	s1,0x1e
    8000589a:	45248493          	addi	s1,s1,1106 # 80023ce8 <pr>
    8000589e:	00002597          	auipc	a1,0x2
    800058a2:	00a58593          	addi	a1,a1,10 # 800078a8 <etext+0x8a8>
    800058a6:	8526                	mv	a0,s1
    800058a8:	258000ef          	jal	80005b00 <initlock>
  pr.locking = 1;
    800058ac:	4785                	li	a5,1
    800058ae:	cc9c                	sw	a5,24(s1)
}
    800058b0:	60e2                	ld	ra,24(sp)
    800058b2:	6442                	ld	s0,16(sp)
    800058b4:	64a2                	ld	s1,8(sp)
    800058b6:	6105                	addi	sp,sp,32
    800058b8:	8082                	ret

00000000800058ba <uartinit>:

void uartstart();

void
uartinit(void)
{
    800058ba:	1141                	addi	sp,sp,-16
    800058bc:	e406                	sd	ra,8(sp)
    800058be:	e022                	sd	s0,0(sp)
    800058c0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800058c2:	100007b7          	lui	a5,0x10000
    800058c6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800058ca:	10000737          	lui	a4,0x10000
    800058ce:	f8000693          	li	a3,-128
    800058d2:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800058d6:	468d                	li	a3,3
    800058d8:	10000637          	lui	a2,0x10000
    800058dc:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800058e0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800058e4:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800058e8:	10000737          	lui	a4,0x10000
    800058ec:	461d                	li	a2,7
    800058ee:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800058f2:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800058f6:	00002597          	auipc	a1,0x2
    800058fa:	fba58593          	addi	a1,a1,-70 # 800078b0 <etext+0x8b0>
    800058fe:	0001e517          	auipc	a0,0x1e
    80005902:	40a50513          	addi	a0,a0,1034 # 80023d08 <uart_tx_lock>
    80005906:	1fa000ef          	jal	80005b00 <initlock>
}
    8000590a:	60a2                	ld	ra,8(sp)
    8000590c:	6402                	ld	s0,0(sp)
    8000590e:	0141                	addi	sp,sp,16
    80005910:	8082                	ret

0000000080005912 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005912:	1101                	addi	sp,sp,-32
    80005914:	ec06                	sd	ra,24(sp)
    80005916:	e822                	sd	s0,16(sp)
    80005918:	e426                	sd	s1,8(sp)
    8000591a:	1000                	addi	s0,sp,32
    8000591c:	84aa                	mv	s1,a0
  push_off();
    8000591e:	222000ef          	jal	80005b40 <push_off>

  if(panicked){
    80005922:	00005797          	auipc	a5,0x5
    80005926:	e6a7a783          	lw	a5,-406(a5) # 8000a78c <panicked>
    8000592a:	e795                	bnez	a5,80005956 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000592c:	10000737          	lui	a4,0x10000
    80005930:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005932:	00074783          	lbu	a5,0(a4)
    80005936:	0207f793          	andi	a5,a5,32
    8000593a:	dfe5                	beqz	a5,80005932 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000593c:	0ff4f513          	zext.b	a0,s1
    80005940:	100007b7          	lui	a5,0x10000
    80005944:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005948:	27c000ef          	jal	80005bc4 <pop_off>
}
    8000594c:	60e2                	ld	ra,24(sp)
    8000594e:	6442                	ld	s0,16(sp)
    80005950:	64a2                	ld	s1,8(sp)
    80005952:	6105                	addi	sp,sp,32
    80005954:	8082                	ret
    for(;;)
    80005956:	a001                	j	80005956 <uartputc_sync+0x44>

0000000080005958 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005958:	00005797          	auipc	a5,0x5
    8000595c:	e387b783          	ld	a5,-456(a5) # 8000a790 <uart_tx_r>
    80005960:	00005717          	auipc	a4,0x5
    80005964:	e3873703          	ld	a4,-456(a4) # 8000a798 <uart_tx_w>
    80005968:	08f70263          	beq	a4,a5,800059ec <uartstart+0x94>
{
    8000596c:	7139                	addi	sp,sp,-64
    8000596e:	fc06                	sd	ra,56(sp)
    80005970:	f822                	sd	s0,48(sp)
    80005972:	f426                	sd	s1,40(sp)
    80005974:	f04a                	sd	s2,32(sp)
    80005976:	ec4e                	sd	s3,24(sp)
    80005978:	e852                	sd	s4,16(sp)
    8000597a:	e456                	sd	s5,8(sp)
    8000597c:	e05a                	sd	s6,0(sp)
    8000597e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005980:	10000937          	lui	s2,0x10000
    80005984:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005986:	0001ea97          	auipc	s5,0x1e
    8000598a:	382a8a93          	addi	s5,s5,898 # 80023d08 <uart_tx_lock>
    uart_tx_r += 1;
    8000598e:	00005497          	auipc	s1,0x5
    80005992:	e0248493          	addi	s1,s1,-510 # 8000a790 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005996:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000599a:	00005997          	auipc	s3,0x5
    8000599e:	dfe98993          	addi	s3,s3,-514 # 8000a798 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800059a2:	00094703          	lbu	a4,0(s2)
    800059a6:	02077713          	andi	a4,a4,32
    800059aa:	c71d                	beqz	a4,800059d8 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800059ac:	01f7f713          	andi	a4,a5,31
    800059b0:	9756                	add	a4,a4,s5
    800059b2:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800059b6:	0785                	addi	a5,a5,1
    800059b8:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800059ba:	8526                	mv	a0,s1
    800059bc:	9c1fb0ef          	jal	8000137c <wakeup>
    WriteReg(THR, c);
    800059c0:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800059c4:	609c                	ld	a5,0(s1)
    800059c6:	0009b703          	ld	a4,0(s3)
    800059ca:	fcf71ce3          	bne	a4,a5,800059a2 <uartstart+0x4a>
      ReadReg(ISR);
    800059ce:	100007b7          	lui	a5,0x10000
    800059d2:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800059d4:	0007c783          	lbu	a5,0(a5)
  }
}
    800059d8:	70e2                	ld	ra,56(sp)
    800059da:	7442                	ld	s0,48(sp)
    800059dc:	74a2                	ld	s1,40(sp)
    800059de:	7902                	ld	s2,32(sp)
    800059e0:	69e2                	ld	s3,24(sp)
    800059e2:	6a42                	ld	s4,16(sp)
    800059e4:	6aa2                	ld	s5,8(sp)
    800059e6:	6b02                	ld	s6,0(sp)
    800059e8:	6121                	addi	sp,sp,64
    800059ea:	8082                	ret
      ReadReg(ISR);
    800059ec:	100007b7          	lui	a5,0x10000
    800059f0:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800059f2:	0007c783          	lbu	a5,0(a5)
      return;
    800059f6:	8082                	ret

00000000800059f8 <uartputc>:
{
    800059f8:	7179                	addi	sp,sp,-48
    800059fa:	f406                	sd	ra,40(sp)
    800059fc:	f022                	sd	s0,32(sp)
    800059fe:	ec26                	sd	s1,24(sp)
    80005a00:	e84a                	sd	s2,16(sp)
    80005a02:	e44e                	sd	s3,8(sp)
    80005a04:	e052                	sd	s4,0(sp)
    80005a06:	1800                	addi	s0,sp,48
    80005a08:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005a0a:	0001e517          	auipc	a0,0x1e
    80005a0e:	2fe50513          	addi	a0,a0,766 # 80023d08 <uart_tx_lock>
    80005a12:	16e000ef          	jal	80005b80 <acquire>
  if(panicked){
    80005a16:	00005797          	auipc	a5,0x5
    80005a1a:	d767a783          	lw	a5,-650(a5) # 8000a78c <panicked>
    80005a1e:	efbd                	bnez	a5,80005a9c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005a20:	00005717          	auipc	a4,0x5
    80005a24:	d7873703          	ld	a4,-648(a4) # 8000a798 <uart_tx_w>
    80005a28:	00005797          	auipc	a5,0x5
    80005a2c:	d687b783          	ld	a5,-664(a5) # 8000a790 <uart_tx_r>
    80005a30:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005a34:	0001e997          	auipc	s3,0x1e
    80005a38:	2d498993          	addi	s3,s3,724 # 80023d08 <uart_tx_lock>
    80005a3c:	00005497          	auipc	s1,0x5
    80005a40:	d5448493          	addi	s1,s1,-684 # 8000a790 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005a44:	00005917          	auipc	s2,0x5
    80005a48:	d5490913          	addi	s2,s2,-684 # 8000a798 <uart_tx_w>
    80005a4c:	00e79d63          	bne	a5,a4,80005a66 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005a50:	85ce                	mv	a1,s3
    80005a52:	8526                	mv	a0,s1
    80005a54:	8ddfb0ef          	jal	80001330 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005a58:	00093703          	ld	a4,0(s2)
    80005a5c:	609c                	ld	a5,0(s1)
    80005a5e:	02078793          	addi	a5,a5,32
    80005a62:	fee787e3          	beq	a5,a4,80005a50 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005a66:	0001e497          	auipc	s1,0x1e
    80005a6a:	2a248493          	addi	s1,s1,674 # 80023d08 <uart_tx_lock>
    80005a6e:	01f77793          	andi	a5,a4,31
    80005a72:	97a6                	add	a5,a5,s1
    80005a74:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005a78:	0705                	addi	a4,a4,1
    80005a7a:	00005797          	auipc	a5,0x5
    80005a7e:	d0e7bf23          	sd	a4,-738(a5) # 8000a798 <uart_tx_w>
  uartstart();
    80005a82:	ed7ff0ef          	jal	80005958 <uartstart>
  release(&uart_tx_lock);
    80005a86:	8526                	mv	a0,s1
    80005a88:	190000ef          	jal	80005c18 <release>
}
    80005a8c:	70a2                	ld	ra,40(sp)
    80005a8e:	7402                	ld	s0,32(sp)
    80005a90:	64e2                	ld	s1,24(sp)
    80005a92:	6942                	ld	s2,16(sp)
    80005a94:	69a2                	ld	s3,8(sp)
    80005a96:	6a02                	ld	s4,0(sp)
    80005a98:	6145                	addi	sp,sp,48
    80005a9a:	8082                	ret
    for(;;)
    80005a9c:	a001                	j	80005a9c <uartputc+0xa4>

0000000080005a9e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005a9e:	1141                	addi	sp,sp,-16
    80005aa0:	e422                	sd	s0,8(sp)
    80005aa2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005aa4:	100007b7          	lui	a5,0x10000
    80005aa8:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80005aaa:	0007c783          	lbu	a5,0(a5)
    80005aae:	8b85                	andi	a5,a5,1
    80005ab0:	cb81                	beqz	a5,80005ac0 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005ab2:	100007b7          	lui	a5,0x10000
    80005ab6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005aba:	6422                	ld	s0,8(sp)
    80005abc:	0141                	addi	sp,sp,16
    80005abe:	8082                	ret
    return -1;
    80005ac0:	557d                	li	a0,-1
    80005ac2:	bfe5                	j	80005aba <uartgetc+0x1c>

0000000080005ac4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005ac4:	1101                	addi	sp,sp,-32
    80005ac6:	ec06                	sd	ra,24(sp)
    80005ac8:	e822                	sd	s0,16(sp)
    80005aca:	e426                	sd	s1,8(sp)
    80005acc:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005ace:	54fd                	li	s1,-1
    80005ad0:	a019                	j	80005ad6 <uartintr+0x12>
      break;
    consoleintr(c);
    80005ad2:	85fff0ef          	jal	80005330 <consoleintr>
    int c = uartgetc();
    80005ad6:	fc9ff0ef          	jal	80005a9e <uartgetc>
    if(c == -1)
    80005ada:	fe951ce3          	bne	a0,s1,80005ad2 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80005ade:	0001e497          	auipc	s1,0x1e
    80005ae2:	22a48493          	addi	s1,s1,554 # 80023d08 <uart_tx_lock>
    80005ae6:	8526                	mv	a0,s1
    80005ae8:	098000ef          	jal	80005b80 <acquire>
  uartstart();
    80005aec:	e6dff0ef          	jal	80005958 <uartstart>
  release(&uart_tx_lock);
    80005af0:	8526                	mv	a0,s1
    80005af2:	126000ef          	jal	80005c18 <release>
}
    80005af6:	60e2                	ld	ra,24(sp)
    80005af8:	6442                	ld	s0,16(sp)
    80005afa:	64a2                	ld	s1,8(sp)
    80005afc:	6105                	addi	sp,sp,32
    80005afe:	8082                	ret

0000000080005b00 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005b00:	1141                	addi	sp,sp,-16
    80005b02:	e422                	sd	s0,8(sp)
    80005b04:	0800                	addi	s0,sp,16
  lk->name = name;
    80005b06:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005b08:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005b0c:	00053823          	sd	zero,16(a0)
}
    80005b10:	6422                	ld	s0,8(sp)
    80005b12:	0141                	addi	sp,sp,16
    80005b14:	8082                	ret

0000000080005b16 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005b16:	411c                	lw	a5,0(a0)
    80005b18:	e399                	bnez	a5,80005b1e <holding+0x8>
    80005b1a:	4501                	li	a0,0
  return r;
}
    80005b1c:	8082                	ret
{
    80005b1e:	1101                	addi	sp,sp,-32
    80005b20:	ec06                	sd	ra,24(sp)
    80005b22:	e822                	sd	s0,16(sp)
    80005b24:	e426                	sd	s1,8(sp)
    80005b26:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005b28:	6904                	ld	s1,16(a0)
    80005b2a:	a10fb0ef          	jal	80000d3a <mycpu>
    80005b2e:	40a48533          	sub	a0,s1,a0
    80005b32:	00153513          	seqz	a0,a0
}
    80005b36:	60e2                	ld	ra,24(sp)
    80005b38:	6442                	ld	s0,16(sp)
    80005b3a:	64a2                	ld	s1,8(sp)
    80005b3c:	6105                	addi	sp,sp,32
    80005b3e:	8082                	ret

0000000080005b40 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005b40:	1101                	addi	sp,sp,-32
    80005b42:	ec06                	sd	ra,24(sp)
    80005b44:	e822                	sd	s0,16(sp)
    80005b46:	e426                	sd	s1,8(sp)
    80005b48:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005b4a:	100024f3          	csrr	s1,sstatus
    80005b4e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005b52:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005b54:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005b58:	9e2fb0ef          	jal	80000d3a <mycpu>
    80005b5c:	5d3c                	lw	a5,120(a0)
    80005b5e:	cb99                	beqz	a5,80005b74 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005b60:	9dafb0ef          	jal	80000d3a <mycpu>
    80005b64:	5d3c                	lw	a5,120(a0)
    80005b66:	2785                	addiw	a5,a5,1
    80005b68:	dd3c                	sw	a5,120(a0)
}
    80005b6a:	60e2                	ld	ra,24(sp)
    80005b6c:	6442                	ld	s0,16(sp)
    80005b6e:	64a2                	ld	s1,8(sp)
    80005b70:	6105                	addi	sp,sp,32
    80005b72:	8082                	ret
    mycpu()->intena = old;
    80005b74:	9c6fb0ef          	jal	80000d3a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005b78:	8085                	srli	s1,s1,0x1
    80005b7a:	8885                	andi	s1,s1,1
    80005b7c:	dd64                	sw	s1,124(a0)
    80005b7e:	b7cd                	j	80005b60 <push_off+0x20>

0000000080005b80 <acquire>:
{
    80005b80:	1101                	addi	sp,sp,-32
    80005b82:	ec06                	sd	ra,24(sp)
    80005b84:	e822                	sd	s0,16(sp)
    80005b86:	e426                	sd	s1,8(sp)
    80005b88:	1000                	addi	s0,sp,32
    80005b8a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005b8c:	fb5ff0ef          	jal	80005b40 <push_off>
  if(holding(lk))
    80005b90:	8526                	mv	a0,s1
    80005b92:	f85ff0ef          	jal	80005b16 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005b96:	4705                	li	a4,1
  if(holding(lk))
    80005b98:	e105                	bnez	a0,80005bb8 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005b9a:	87ba                	mv	a5,a4
    80005b9c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005ba0:	2781                	sext.w	a5,a5
    80005ba2:	ffe5                	bnez	a5,80005b9a <acquire+0x1a>
  __sync_synchronize();
    80005ba4:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005ba8:	992fb0ef          	jal	80000d3a <mycpu>
    80005bac:	e888                	sd	a0,16(s1)
}
    80005bae:	60e2                	ld	ra,24(sp)
    80005bb0:	6442                	ld	s0,16(sp)
    80005bb2:	64a2                	ld	s1,8(sp)
    80005bb4:	6105                	addi	sp,sp,32
    80005bb6:	8082                	ret
    panic("acquire");
    80005bb8:	00002517          	auipc	a0,0x2
    80005bbc:	d0050513          	addi	a0,a0,-768 # 800078b8 <etext+0x8b8>
    80005bc0:	c93ff0ef          	jal	80005852 <panic>

0000000080005bc4 <pop_off>:

void
pop_off(void)
{
    80005bc4:	1141                	addi	sp,sp,-16
    80005bc6:	e406                	sd	ra,8(sp)
    80005bc8:	e022                	sd	s0,0(sp)
    80005bca:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005bcc:	96efb0ef          	jal	80000d3a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005bd0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005bd4:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005bd6:	e78d                	bnez	a5,80005c00 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005bd8:	5d3c                	lw	a5,120(a0)
    80005bda:	02f05963          	blez	a5,80005c0c <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80005bde:	37fd                	addiw	a5,a5,-1
    80005be0:	0007871b          	sext.w	a4,a5
    80005be4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005be6:	eb09                	bnez	a4,80005bf8 <pop_off+0x34>
    80005be8:	5d7c                	lw	a5,124(a0)
    80005bea:	c799                	beqz	a5,80005bf8 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005bec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005bf0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005bf4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005bf8:	60a2                	ld	ra,8(sp)
    80005bfa:	6402                	ld	s0,0(sp)
    80005bfc:	0141                	addi	sp,sp,16
    80005bfe:	8082                	ret
    panic("pop_off - interruptible");
    80005c00:	00002517          	auipc	a0,0x2
    80005c04:	cc050513          	addi	a0,a0,-832 # 800078c0 <etext+0x8c0>
    80005c08:	c4bff0ef          	jal	80005852 <panic>
    panic("pop_off");
    80005c0c:	00002517          	auipc	a0,0x2
    80005c10:	ccc50513          	addi	a0,a0,-820 # 800078d8 <etext+0x8d8>
    80005c14:	c3fff0ef          	jal	80005852 <panic>

0000000080005c18 <release>:
{
    80005c18:	1101                	addi	sp,sp,-32
    80005c1a:	ec06                	sd	ra,24(sp)
    80005c1c:	e822                	sd	s0,16(sp)
    80005c1e:	e426                	sd	s1,8(sp)
    80005c20:	1000                	addi	s0,sp,32
    80005c22:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005c24:	ef3ff0ef          	jal	80005b16 <holding>
    80005c28:	c105                	beqz	a0,80005c48 <release+0x30>
  lk->cpu = 0;
    80005c2a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005c2e:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005c32:	0310000f          	fence	rw,w
    80005c36:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005c3a:	f8bff0ef          	jal	80005bc4 <pop_off>
}
    80005c3e:	60e2                	ld	ra,24(sp)
    80005c40:	6442                	ld	s0,16(sp)
    80005c42:	64a2                	ld	s1,8(sp)
    80005c44:	6105                	addi	sp,sp,32
    80005c46:	8082                	ret
    panic("release");
    80005c48:	00002517          	auipc	a0,0x2
    80005c4c:	c9850513          	addi	a0,a0,-872 # 800078e0 <etext+0x8e0>
    80005c50:	c03ff0ef          	jal	80005852 <panic>
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
