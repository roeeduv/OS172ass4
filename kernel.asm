
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 c0 10 00       	mov    $0x10c000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 e6 10 80       	mov    $0x8010e650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 3a 10 80       	mov    $0x80103af0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 7c 99 10 80       	push   $0x8010997c
80100042:	68 80 e6 10 80       	push   $0x8010e680
80100047:	e8 8b 62 00 00       	call   801062d7 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 25 11 80 84 	movl   $0x80112584,0x80112590
80100056:	25 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 25 11 80 84 	movl   $0x80112584,0x80112594
80100060:	25 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 e6 10 80 	movl   $0x8010e6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 25 11 80    	mov    0x80112594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 25 11 80 	movl   $0x80112584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 25 11 80       	mov    0x80112594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 25 11 80       	mov    %eax,0x80112594

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 84 25 11 80       	mov    $0x80112584,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  // Assignment 4 - adding code here
  free_block_number = NBUF;
801000b0:	c7 05 60 e6 10 80 1e 	movl   $0x1e,0x8010e660
801000b7:	00 00 00 
  number_of_block_acsses = 0;
801000ba:	c7 05 64 e6 10 80 00 	movl   $0x0,0x8010e664
801000c1:	00 00 00 
  number_of_hits = 0;
801000c4:	c7 05 9c 27 11 80 00 	movl   $0x0,0x8011279c
801000cb:	00 00 00 
  // finish
}
801000ce:	90                   	nop
801000cf:	c9                   	leave  
801000d0:	c3                   	ret    

801000d1 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000d1:	55                   	push   %ebp
801000d2:	89 e5                	mov    %esp,%ebp
801000d4:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000d7:	83 ec 0c             	sub    $0xc,%esp
801000da:	68 80 e6 10 80       	push   $0x8010e680
801000df:	e8 15 62 00 00       	call   801062f9 <acquire>
801000e4:	83 c4 10             	add    $0x10,%esp
  // Assignment 4 - adding code here
  number_of_block_acsses++; // each time we are in bget - we make block access
801000e7:	a1 64 e6 10 80       	mov    0x8010e664,%eax
801000ec:	83 c0 01             	add    $0x1,%eax
801000ef:	a3 64 e6 10 80       	mov    %eax,0x8010e664
  //finish

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000f4:	a1 94 25 11 80       	mov    0x80112594,%eax
801000f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000fc:	e9 84 00 00 00       	jmp    80100185 <bget+0xb4>
    if(b->dev == dev && b->sector == sector){
80100101:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100104:	8b 40 04             	mov    0x4(%eax),%eax
80100107:	3b 45 08             	cmp    0x8(%ebp),%eax
8010010a:	75 70                	jne    8010017c <bget+0xab>
8010010c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010f:	8b 40 08             	mov    0x8(%eax),%eax
80100112:	3b 45 0c             	cmp    0xc(%ebp),%eax
80100115:	75 65                	jne    8010017c <bget+0xab>
      if(!(b->flags & B_BUSY)){
80100117:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011a:	8b 00                	mov    (%eax),%eax
8010011c:	83 e0 01             	and    $0x1,%eax
8010011f:	85 c0                	test   %eax,%eax
80100121:	75 41                	jne    80100164 <bget+0x93>
        b->flags |= B_BUSY;
80100123:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100126:	8b 00                	mov    (%eax),%eax
80100128:	83 c8 01             	or     $0x1,%eax
8010012b:	89 c2                	mov    %eax,%edx
8010012d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100130:	89 10                	mov    %edx,(%eax)
        // Assignment 4 - adding code here
        number_of_hits++; // we found the sector in cache - that a hit!
80100132:	a1 9c 27 11 80       	mov    0x8011279c,%eax
80100137:	83 c0 01             	add    $0x1,%eax
8010013a:	a3 9c 27 11 80       	mov    %eax,0x8011279c
        free_block_number--;
8010013f:	a1 60 e6 10 80       	mov    0x8010e660,%eax
80100144:	83 e8 01             	sub    $0x1,%eax
80100147:	a3 60 e6 10 80       	mov    %eax,0x8010e660
        //finish
        release(&bcache.lock);
8010014c:	83 ec 0c             	sub    $0xc,%esp
8010014f:	68 80 e6 10 80       	push   $0x8010e680
80100154:	e8 07 62 00 00       	call   80106360 <release>
80100159:	83 c4 10             	add    $0x10,%esp
        return b;
8010015c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015f:	e9 ac 00 00 00       	jmp    80100210 <bget+0x13f>
      }
      sleep(b, &bcache.lock);
80100164:	83 ec 08             	sub    $0x8,%esp
80100167:	68 80 e6 10 80       	push   $0x8010e680
8010016c:	ff 75 f4             	pushl  -0xc(%ebp)
8010016f:	e8 e8 4d 00 00       	call   80104f5c <sleep>
80100174:	83 c4 10             	add    $0x10,%esp
      goto loop;
80100177:	e9 78 ff ff ff       	jmp    801000f4 <bget+0x23>
  number_of_block_acsses++; // each time we are in bget - we make block access
  //finish

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010017c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017f:	8b 40 10             	mov    0x10(%eax),%eax
80100182:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100185:	81 7d f4 84 25 11 80 	cmpl   $0x80112584,-0xc(%ebp)
8010018c:	0f 85 6f ff ff ff    	jne    80100101 <bget+0x30>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100192:	a1 90 25 11 80       	mov    0x80112590,%eax
80100197:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019a:	eb 5e                	jmp    801001fa <bget+0x129>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010019c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010019f:	8b 00                	mov    (%eax),%eax
801001a1:	83 e0 01             	and    $0x1,%eax
801001a4:	85 c0                	test   %eax,%eax
801001a6:	75 49                	jne    801001f1 <bget+0x120>
801001a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001ab:	8b 00                	mov    (%eax),%eax
801001ad:	83 e0 04             	and    $0x4,%eax
801001b0:	85 c0                	test   %eax,%eax
801001b2:	75 3d                	jne    801001f1 <bget+0x120>
      b->dev = dev;
801001b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b7:	8b 55 08             	mov    0x8(%ebp),%edx
801001ba:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
801001bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c0:	8b 55 0c             	mov    0xc(%ebp),%edx
801001c3:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
801001c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      // Assignment 4 - adding code here
      free_block_number--; // we now bring the sector
801001cf:	a1 60 e6 10 80       	mov    0x8010e660,%eax
801001d4:	83 e8 01             	sub    $0x1,%eax
801001d7:	a3 60 e6 10 80       	mov    %eax,0x8010e660
      //finish
      release(&bcache.lock);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	68 80 e6 10 80       	push   $0x8010e680
801001e4:	e8 77 61 00 00       	call   80106360 <release>
801001e9:	83 c4 10             	add    $0x10,%esp
      return b;
801001ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001ef:	eb 1f                	jmp    80100210 <bget+0x13f>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801001f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001f4:	8b 40 0c             	mov    0xc(%eax),%eax
801001f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001fa:	81 7d f4 84 25 11 80 	cmpl   $0x80112584,-0xc(%ebp)
80100201:	75 99                	jne    8010019c <bget+0xcb>
      //finish
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100203:	83 ec 0c             	sub    $0xc,%esp
80100206:	68 83 99 10 80       	push   $0x80109983
8010020b:	e8 e7 03 00 00       	call   801005f7 <panic>
}
80100210:	c9                   	leave  
80100211:	c3                   	ret    

80100212 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
80100212:	55                   	push   %ebp
80100213:	89 e5                	mov    %esp,%ebp
80100215:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, sector);
80100218:	83 ec 08             	sub    $0x8,%esp
8010021b:	ff 75 0c             	pushl  0xc(%ebp)
8010021e:	ff 75 08             	pushl  0x8(%ebp)
80100221:	e8 ab fe ff ff       	call   801000d1 <bget>
80100226:	83 c4 10             	add    $0x10,%esp
80100229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
8010022c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010022f:	8b 00                	mov    (%eax),%eax
80100231:	83 e0 02             	and    $0x2,%eax
80100234:	85 c0                	test   %eax,%eax
80100236:	75 0e                	jne    80100246 <bread+0x34>
    iderw(b);
80100238:	83 ec 0c             	sub    $0xc,%esp
8010023b:	ff 75 f4             	pushl  -0xc(%ebp)
8010023e:	e8 23 29 00 00       	call   80102b66 <iderw>
80100243:	83 c4 10             	add    $0x10,%esp
  return b;
80100246:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100249:	c9                   	leave  
8010024a:	c3                   	ret    

8010024b <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
8010024b:	55                   	push   %ebp
8010024c:	89 e5                	mov    %esp,%ebp
8010024e:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100251:	8b 45 08             	mov    0x8(%ebp),%eax
80100254:	8b 00                	mov    (%eax),%eax
80100256:	83 e0 01             	and    $0x1,%eax
80100259:	85 c0                	test   %eax,%eax
8010025b:	75 0d                	jne    8010026a <bwrite+0x1f>
    panic("bwrite");
8010025d:	83 ec 0c             	sub    $0xc,%esp
80100260:	68 94 99 10 80       	push   $0x80109994
80100265:	e8 8d 03 00 00       	call   801005f7 <panic>
  b->flags |= B_DIRTY;
8010026a:	8b 45 08             	mov    0x8(%ebp),%eax
8010026d:	8b 00                	mov    (%eax),%eax
8010026f:	83 c8 04             	or     $0x4,%eax
80100272:	89 c2                	mov    %eax,%edx
80100274:	8b 45 08             	mov    0x8(%ebp),%eax
80100277:	89 10                	mov    %edx,(%eax)
  iderw(b);
80100279:	83 ec 0c             	sub    $0xc,%esp
8010027c:	ff 75 08             	pushl  0x8(%ebp)
8010027f:	e8 e2 28 00 00       	call   80102b66 <iderw>
80100284:	83 c4 10             	add    $0x10,%esp
}
80100287:	90                   	nop
80100288:	c9                   	leave  
80100289:	c3                   	ret    

8010028a <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010028a:	55                   	push   %ebp
8010028b:	89 e5                	mov    %esp,%ebp
8010028d:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100290:	8b 45 08             	mov    0x8(%ebp),%eax
80100293:	8b 00                	mov    (%eax),%eax
80100295:	83 e0 01             	and    $0x1,%eax
80100298:	85 c0                	test   %eax,%eax
8010029a:	75 0d                	jne    801002a9 <brelse+0x1f>
    panic("brelse");
8010029c:	83 ec 0c             	sub    $0xc,%esp
8010029f:	68 9b 99 10 80       	push   $0x8010999b
801002a4:	e8 4e 03 00 00       	call   801005f7 <panic>

  acquire(&bcache.lock);
801002a9:	83 ec 0c             	sub    $0xc,%esp
801002ac:	68 80 e6 10 80       	push   $0x8010e680
801002b1:	e8 43 60 00 00       	call   801062f9 <acquire>
801002b6:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
801002b9:	8b 45 08             	mov    0x8(%ebp),%eax
801002bc:	8b 40 10             	mov    0x10(%eax),%eax
801002bf:	8b 55 08             	mov    0x8(%ebp),%edx
801002c2:	8b 52 0c             	mov    0xc(%edx),%edx
801002c5:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
801002c8:	8b 45 08             	mov    0x8(%ebp),%eax
801002cb:	8b 40 0c             	mov    0xc(%eax),%eax
801002ce:	8b 55 08             	mov    0x8(%ebp),%edx
801002d1:	8b 52 10             	mov    0x10(%edx),%edx
801002d4:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
801002d7:	8b 15 94 25 11 80    	mov    0x80112594,%edx
801002dd:	8b 45 08             	mov    0x8(%ebp),%eax
801002e0:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
801002e3:	8b 45 08             	mov    0x8(%ebp),%eax
801002e6:	c7 40 0c 84 25 11 80 	movl   $0x80112584,0xc(%eax)
  bcache.head.next->prev = b;
801002ed:	a1 94 25 11 80       	mov    0x80112594,%eax
801002f2:	8b 55 08             	mov    0x8(%ebp),%edx
801002f5:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
801002f8:	8b 45 08             	mov    0x8(%ebp),%eax
801002fb:	a3 94 25 11 80       	mov    %eax,0x80112594

  b->flags &= ~B_BUSY;
80100300:	8b 45 08             	mov    0x8(%ebp),%eax
80100303:	8b 00                	mov    (%eax),%eax
80100305:	83 e0 fe             	and    $0xfffffffe,%eax
80100308:	89 c2                	mov    %eax,%edx
8010030a:	8b 45 08             	mov    0x8(%ebp),%eax
8010030d:	89 10                	mov    %edx,(%eax)
  // Assignment 4 - adding code here
  free_block_number++; // the block is free now!
8010030f:	a1 60 e6 10 80       	mov    0x8010e660,%eax
80100314:	83 c0 01             	add    $0x1,%eax
80100317:	a3 60 e6 10 80       	mov    %eax,0x8010e660
  //finish
  wakeup(b);
8010031c:	83 ec 0c             	sub    $0xc,%esp
8010031f:	ff 75 08             	pushl  0x8(%ebp)
80100322:	e8 20 4d 00 00       	call   80105047 <wakeup>
80100327:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
8010032a:	83 ec 0c             	sub    $0xc,%esp
8010032d:	68 80 e6 10 80       	push   $0x8010e680
80100332:	e8 29 60 00 00       	call   80106360 <release>
80100337:	83 c4 10             	add    $0x10,%esp
}
8010033a:	90                   	nop
8010033b:	c9                   	leave  
8010033c:	c3                   	ret    

8010033d <get_free_block_number>:
//PAGEBREAK!
// Blank page.

// Assignment 4 - adding code here
// this function is to retriv all our data
int get_free_block_number(){
8010033d:	55                   	push   %ebp
8010033e:	89 e5                	mov    %esp,%ebp
  return free_block_number;
80100340:	a1 60 e6 10 80       	mov    0x8010e660,%eax
}
80100345:	5d                   	pop    %ebp
80100346:	c3                   	ret    

80100347 <get_total_block_number>:

int get_total_block_number(){
80100347:	55                   	push   %ebp
80100348:	89 e5                	mov    %esp,%ebp
  return NBUF;
8010034a:	b8 1e 00 00 00       	mov    $0x1e,%eax
}
8010034f:	5d                   	pop    %ebp
80100350:	c3                   	ret    

80100351 <get_number_of_block_acsses>:

int get_number_of_block_acsses(){
80100351:	55                   	push   %ebp
80100352:	89 e5                	mov    %esp,%ebp
  return number_of_block_acsses;
80100354:	a1 64 e6 10 80       	mov    0x8010e664,%eax
}
80100359:	5d                   	pop    %ebp
8010035a:	c3                   	ret    

8010035b <get_number_of_hits>:

int get_number_of_hits(){
8010035b:	55                   	push   %ebp
8010035c:	89 e5                	mov    %esp,%ebp
  return number_of_hits;
8010035e:	a1 9c 27 11 80       	mov    0x8011279c,%eax
}
80100363:	5d                   	pop    %ebp
80100364:	c3                   	ret    

80100365 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80100365:	55                   	push   %ebp
80100366:	89 e5                	mov    %esp,%ebp
80100368:	83 ec 14             	sub    $0x14,%esp
8010036b:	8b 45 08             	mov    0x8(%ebp),%eax
8010036e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100372:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80100376:	89 c2                	mov    %eax,%edx
80100378:	ec                   	in     (%dx),%al
80100379:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010037c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80100380:	c9                   	leave  
80100381:	c3                   	ret    

80100382 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80100382:	55                   	push   %ebp
80100383:	89 e5                	mov    %esp,%ebp
80100385:	83 ec 08             	sub    $0x8,%esp
80100388:	8b 55 08             	mov    0x8(%ebp),%edx
8010038b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010038e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100392:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100395:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100399:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010039d:	ee                   	out    %al,(%dx)
}
8010039e:	90                   	nop
8010039f:	c9                   	leave  
801003a0:	c3                   	ret    

801003a1 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801003a1:	55                   	push   %ebp
801003a2:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801003a4:	fa                   	cli    
}
801003a5:	90                   	nop
801003a6:	5d                   	pop    %ebp
801003a7:	c3                   	ret    

801003a8 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801003a8:	55                   	push   %ebp
801003a9:	89 e5                	mov    %esp,%ebp
801003ab:	53                   	push   %ebx
801003ac:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801003af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003b3:	74 1c                	je     801003d1 <printint+0x29>
801003b5:	8b 45 08             	mov    0x8(%ebp),%eax
801003b8:	c1 e8 1f             	shr    $0x1f,%eax
801003bb:	0f b6 c0             	movzbl %al,%eax
801003be:	89 45 10             	mov    %eax,0x10(%ebp)
801003c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003c5:	74 0a                	je     801003d1 <printint+0x29>
    x = -xx;
801003c7:	8b 45 08             	mov    0x8(%ebp),%eax
801003ca:	f7 d8                	neg    %eax
801003cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003cf:	eb 06                	jmp    801003d7 <printint+0x2f>
  else
    x = xx;
801003d1:	8b 45 08             	mov    0x8(%ebp),%eax
801003d4:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
801003d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
801003de:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801003e1:	8d 41 01             	lea    0x1(%ecx),%eax
801003e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801003e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801003ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003ed:	ba 00 00 00 00       	mov    $0x0,%edx
801003f2:	f7 f3                	div    %ebx
801003f4:	89 d0                	mov    %edx,%eax
801003f6:	0f b6 80 04 b0 10 80 	movzbl -0x7fef4ffc(%eax),%eax
801003fd:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100401:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100404:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100407:	ba 00 00 00 00       	mov    $0x0,%edx
8010040c:	f7 f3                	div    %ebx
8010040e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100411:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100415:	75 c7                	jne    801003de <printint+0x36>

  if(sign)
80100417:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010041b:	74 2a                	je     80100447 <printint+0x9f>
    buf[i++] = '-';
8010041d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100420:	8d 50 01             	lea    0x1(%eax),%edx
80100423:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100426:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010042b:	eb 1a                	jmp    80100447 <printint+0x9f>
    consputc(buf[i]);
8010042d:	8d 55 e0             	lea    -0x20(%ebp),%edx
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	83 ec 0c             	sub    $0xc,%esp
8010043e:	50                   	push   %eax
8010043f:	e8 c3 03 00 00       	call   80100807 <consputc>
80100444:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
80100447:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010044b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010044f:	79 dc                	jns    8010042d <printint+0x85>
    consputc(buf[i]);
}
80100451:	90                   	nop
80100452:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100455:	c9                   	leave  
80100456:	c3                   	ret    

80100457 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100457:	55                   	push   %ebp
80100458:	89 e5                	mov    %esp,%ebp
8010045a:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
8010045d:	a1 f4 d5 10 80       	mov    0x8010d5f4,%eax
80100462:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
80100465:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100469:	74 10                	je     8010047b <cprintf+0x24>
    acquire(&cons.lock);
8010046b:	83 ec 0c             	sub    $0xc,%esp
8010046e:	68 c0 d5 10 80       	push   $0x8010d5c0
80100473:	e8 81 5e 00 00       	call   801062f9 <acquire>
80100478:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
8010047b:	8b 45 08             	mov    0x8(%ebp),%eax
8010047e:	85 c0                	test   %eax,%eax
80100480:	75 0d                	jne    8010048f <cprintf+0x38>
    panic("null fmt");
80100482:	83 ec 0c             	sub    $0xc,%esp
80100485:	68 a2 99 10 80       	push   $0x801099a2
8010048a:	e8 68 01 00 00       	call   801005f7 <panic>

  argp = (uint*)(void*)(&fmt + 1);
8010048f:	8d 45 0c             	lea    0xc(%ebp),%eax
80100492:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100495:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010049c:	e9 1a 01 00 00       	jmp    801005bb <cprintf+0x164>
    if(c != '%'){
801004a1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801004a5:	74 13                	je     801004ba <cprintf+0x63>
      consputc(c);
801004a7:	83 ec 0c             	sub    $0xc,%esp
801004aa:	ff 75 e4             	pushl  -0x1c(%ebp)
801004ad:	e8 55 03 00 00       	call   80100807 <consputc>
801004b2:	83 c4 10             	add    $0x10,%esp
      continue;
801004b5:	e9 fd 00 00 00       	jmp    801005b7 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
801004ba:	8b 55 08             	mov    0x8(%ebp),%edx
801004bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801004c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801004c4:	01 d0                	add    %edx,%eax
801004c6:	0f b6 00             	movzbl (%eax),%eax
801004c9:	0f be c0             	movsbl %al,%eax
801004cc:	25 ff 00 00 00       	and    $0xff,%eax
801004d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
801004d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801004d8:	0f 84 ff 00 00 00    	je     801005dd <cprintf+0x186>
      break;
    switch(c){
801004de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004e1:	83 f8 70             	cmp    $0x70,%eax
801004e4:	74 47                	je     8010052d <cprintf+0xd6>
801004e6:	83 f8 70             	cmp    $0x70,%eax
801004e9:	7f 13                	jg     801004fe <cprintf+0xa7>
801004eb:	83 f8 25             	cmp    $0x25,%eax
801004ee:	0f 84 98 00 00 00    	je     8010058c <cprintf+0x135>
801004f4:	83 f8 64             	cmp    $0x64,%eax
801004f7:	74 14                	je     8010050d <cprintf+0xb6>
801004f9:	e9 9d 00 00 00       	jmp    8010059b <cprintf+0x144>
801004fe:	83 f8 73             	cmp    $0x73,%eax
80100501:	74 47                	je     8010054a <cprintf+0xf3>
80100503:	83 f8 78             	cmp    $0x78,%eax
80100506:	74 25                	je     8010052d <cprintf+0xd6>
80100508:	e9 8e 00 00 00       	jmp    8010059b <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010050d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100510:	8d 50 04             	lea    0x4(%eax),%edx
80100513:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100516:	8b 00                	mov    (%eax),%eax
80100518:	83 ec 04             	sub    $0x4,%esp
8010051b:	6a 01                	push   $0x1
8010051d:	6a 0a                	push   $0xa
8010051f:	50                   	push   %eax
80100520:	e8 83 fe ff ff       	call   801003a8 <printint>
80100525:	83 c4 10             	add    $0x10,%esp
      break;
80100528:	e9 8a 00 00 00       	jmp    801005b7 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010052d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100530:	8d 50 04             	lea    0x4(%eax),%edx
80100533:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100536:	8b 00                	mov    (%eax),%eax
80100538:	83 ec 04             	sub    $0x4,%esp
8010053b:	6a 00                	push   $0x0
8010053d:	6a 10                	push   $0x10
8010053f:	50                   	push   %eax
80100540:	e8 63 fe ff ff       	call   801003a8 <printint>
80100545:	83 c4 10             	add    $0x10,%esp
      break;
80100548:	eb 6d                	jmp    801005b7 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
8010054a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010054d:	8d 50 04             	lea    0x4(%eax),%edx
80100550:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100553:	8b 00                	mov    (%eax),%eax
80100555:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100558:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010055c:	75 22                	jne    80100580 <cprintf+0x129>
        s = "(null)";
8010055e:	c7 45 ec ab 99 10 80 	movl   $0x801099ab,-0x14(%ebp)
      for(; *s; s++)
80100565:	eb 19                	jmp    80100580 <cprintf+0x129>
        consputc(*s);
80100567:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010056a:	0f b6 00             	movzbl (%eax),%eax
8010056d:	0f be c0             	movsbl %al,%eax
80100570:	83 ec 0c             	sub    $0xc,%esp
80100573:	50                   	push   %eax
80100574:	e8 8e 02 00 00       	call   80100807 <consputc>
80100579:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
8010057c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100580:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100583:	0f b6 00             	movzbl (%eax),%eax
80100586:	84 c0                	test   %al,%al
80100588:	75 dd                	jne    80100567 <cprintf+0x110>
        consputc(*s);
      break;
8010058a:	eb 2b                	jmp    801005b7 <cprintf+0x160>
    case '%':
      consputc('%');
8010058c:	83 ec 0c             	sub    $0xc,%esp
8010058f:	6a 25                	push   $0x25
80100591:	e8 71 02 00 00       	call   80100807 <consputc>
80100596:	83 c4 10             	add    $0x10,%esp
      break;
80100599:	eb 1c                	jmp    801005b7 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010059b:	83 ec 0c             	sub    $0xc,%esp
8010059e:	6a 25                	push   $0x25
801005a0:	e8 62 02 00 00       	call   80100807 <consputc>
801005a5:	83 c4 10             	add    $0x10,%esp
      consputc(c);
801005a8:	83 ec 0c             	sub    $0xc,%esp
801005ab:	ff 75 e4             	pushl  -0x1c(%ebp)
801005ae:	e8 54 02 00 00       	call   80100807 <consputc>
801005b3:	83 c4 10             	add    $0x10,%esp
      break;
801005b6:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801005b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005bb:	8b 55 08             	mov    0x8(%ebp),%edx
801005be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005c1:	01 d0                	add    %edx,%eax
801005c3:	0f b6 00             	movzbl (%eax),%eax
801005c6:	0f be c0             	movsbl %al,%eax
801005c9:	25 ff 00 00 00       	and    $0xff,%eax
801005ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801005d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801005d5:	0f 85 c6 fe ff ff    	jne    801004a1 <cprintf+0x4a>
801005db:	eb 01                	jmp    801005de <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
801005dd:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
801005de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801005e2:	74 10                	je     801005f4 <cprintf+0x19d>
    release(&cons.lock);
801005e4:	83 ec 0c             	sub    $0xc,%esp
801005e7:	68 c0 d5 10 80       	push   $0x8010d5c0
801005ec:	e8 6f 5d 00 00       	call   80106360 <release>
801005f1:	83 c4 10             	add    $0x10,%esp
}
801005f4:	90                   	nop
801005f5:	c9                   	leave  
801005f6:	c3                   	ret    

801005f7 <panic>:

void
panic(char *s)
{
801005f7:	55                   	push   %ebp
801005f8:	89 e5                	mov    %esp,%ebp
801005fa:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
801005fd:	e8 9f fd ff ff       	call   801003a1 <cli>
  cons.locking = 0;
80100602:	c7 05 f4 d5 10 80 00 	movl   $0x0,0x8010d5f4
80100609:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010060c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100612:	0f b6 00             	movzbl (%eax),%eax
80100615:	0f b6 c0             	movzbl %al,%eax
80100618:	83 ec 08             	sub    $0x8,%esp
8010061b:	50                   	push   %eax
8010061c:	68 b2 99 10 80       	push   $0x801099b2
80100621:	e8 31 fe ff ff       	call   80100457 <cprintf>
80100626:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100629:	8b 45 08             	mov    0x8(%ebp),%eax
8010062c:	83 ec 0c             	sub    $0xc,%esp
8010062f:	50                   	push   %eax
80100630:	e8 22 fe ff ff       	call   80100457 <cprintf>
80100635:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80100638:	83 ec 0c             	sub    $0xc,%esp
8010063b:	68 c1 99 10 80       	push   $0x801099c1
80100640:	e8 12 fe ff ff       	call   80100457 <cprintf>
80100645:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
80100648:	83 ec 08             	sub    $0x8,%esp
8010064b:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010064e:	50                   	push   %eax
8010064f:	8d 45 08             	lea    0x8(%ebp),%eax
80100652:	50                   	push   %eax
80100653:	e8 5a 5d 00 00       	call   801063b2 <getcallerpcs>
80100658:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
8010065b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100662:	eb 1c                	jmp    80100680 <panic+0x89>
    cprintf(" %p", pcs[i]);
80100664:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100667:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
8010066b:	83 ec 08             	sub    $0x8,%esp
8010066e:	50                   	push   %eax
8010066f:	68 c3 99 10 80       	push   $0x801099c3
80100674:	e8 de fd ff ff       	call   80100457 <cprintf>
80100679:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
8010067c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100680:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80100684:	7e de                	jle    80100664 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
80100686:	c7 05 a0 d5 10 80 01 	movl   $0x1,0x8010d5a0
8010068d:	00 00 00 
  for(;;)
    ;
80100690:	eb fe                	jmp    80100690 <panic+0x99>

80100692 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100692:	55                   	push   %ebp
80100693:	89 e5                	mov    %esp,%ebp
80100695:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100698:	6a 0e                	push   $0xe
8010069a:	68 d4 03 00 00       	push   $0x3d4
8010069f:	e8 de fc ff ff       	call   80100382 <outb>
801006a4:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
801006a7:	68 d5 03 00 00       	push   $0x3d5
801006ac:	e8 b4 fc ff ff       	call   80100365 <inb>
801006b1:	83 c4 04             	add    $0x4,%esp
801006b4:	0f b6 c0             	movzbl %al,%eax
801006b7:	c1 e0 08             	shl    $0x8,%eax
801006ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801006bd:	6a 0f                	push   $0xf
801006bf:	68 d4 03 00 00       	push   $0x3d4
801006c4:	e8 b9 fc ff ff       	call   80100382 <outb>
801006c9:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
801006cc:	68 d5 03 00 00       	push   $0x3d5
801006d1:	e8 8f fc ff ff       	call   80100365 <inb>
801006d6:	83 c4 04             	add    $0x4,%esp
801006d9:	0f b6 c0             	movzbl %al,%eax
801006dc:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
801006df:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
801006e3:	75 30                	jne    80100715 <cgaputc+0x83>
    pos += 80 - pos%80;
801006e5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006e8:	ba 67 66 66 66       	mov    $0x66666667,%edx
801006ed:	89 c8                	mov    %ecx,%eax
801006ef:	f7 ea                	imul   %edx
801006f1:	c1 fa 05             	sar    $0x5,%edx
801006f4:	89 c8                	mov    %ecx,%eax
801006f6:	c1 f8 1f             	sar    $0x1f,%eax
801006f9:	29 c2                	sub    %eax,%edx
801006fb:	89 d0                	mov    %edx,%eax
801006fd:	c1 e0 02             	shl    $0x2,%eax
80100700:	01 d0                	add    %edx,%eax
80100702:	c1 e0 04             	shl    $0x4,%eax
80100705:	29 c1                	sub    %eax,%ecx
80100707:	89 ca                	mov    %ecx,%edx
80100709:	b8 50 00 00 00       	mov    $0x50,%eax
8010070e:	29 d0                	sub    %edx,%eax
80100710:	01 45 f4             	add    %eax,-0xc(%ebp)
80100713:	eb 34                	jmp    80100749 <cgaputc+0xb7>
  else if(c == BACKSPACE){
80100715:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010071c:	75 0c                	jne    8010072a <cgaputc+0x98>
    if(pos > 0) --pos;
8010071e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100722:	7e 25                	jle    80100749 <cgaputc+0xb7>
80100724:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100728:	eb 1f                	jmp    80100749 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010072a:	8b 0d 00 b0 10 80    	mov    0x8010b000,%ecx
80100730:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100733:	8d 50 01             	lea    0x1(%eax),%edx
80100736:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100739:	01 c0                	add    %eax,%eax
8010073b:	01 c8                	add    %ecx,%eax
8010073d:	8b 55 08             	mov    0x8(%ebp),%edx
80100740:	0f b6 d2             	movzbl %dl,%edx
80100743:	80 ce 07             	or     $0x7,%dh
80100746:	66 89 10             	mov    %dx,(%eax)
  
  if((pos/80) >= 24){  // Scroll up.
80100749:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100750:	7e 4c                	jle    8010079e <cgaputc+0x10c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100752:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100757:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010075d:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100762:	83 ec 04             	sub    $0x4,%esp
80100765:	68 60 0e 00 00       	push   $0xe60
8010076a:	52                   	push   %edx
8010076b:	50                   	push   %eax
8010076c:	e8 aa 5e 00 00       	call   8010661b <memmove>
80100771:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
80100774:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100778:	b8 80 07 00 00       	mov    $0x780,%eax
8010077d:	2b 45 f4             	sub    -0xc(%ebp),%eax
80100780:	8d 14 00             	lea    (%eax,%eax,1),%edx
80100783:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100788:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010078b:	01 c9                	add    %ecx,%ecx
8010078d:	01 c8                	add    %ecx,%eax
8010078f:	83 ec 04             	sub    $0x4,%esp
80100792:	52                   	push   %edx
80100793:	6a 00                	push   $0x0
80100795:	50                   	push   %eax
80100796:	e8 c1 5d 00 00       	call   8010655c <memset>
8010079b:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
8010079e:	83 ec 08             	sub    $0x8,%esp
801007a1:	6a 0e                	push   $0xe
801007a3:	68 d4 03 00 00       	push   $0x3d4
801007a8:	e8 d5 fb ff ff       	call   80100382 <outb>
801007ad:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
801007b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007b3:	c1 f8 08             	sar    $0x8,%eax
801007b6:	0f b6 c0             	movzbl %al,%eax
801007b9:	83 ec 08             	sub    $0x8,%esp
801007bc:	50                   	push   %eax
801007bd:	68 d5 03 00 00       	push   $0x3d5
801007c2:	e8 bb fb ff ff       	call   80100382 <outb>
801007c7:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
801007ca:	83 ec 08             	sub    $0x8,%esp
801007cd:	6a 0f                	push   $0xf
801007cf:	68 d4 03 00 00       	push   $0x3d4
801007d4:	e8 a9 fb ff ff       	call   80100382 <outb>
801007d9:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
801007dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007df:	0f b6 c0             	movzbl %al,%eax
801007e2:	83 ec 08             	sub    $0x8,%esp
801007e5:	50                   	push   %eax
801007e6:	68 d5 03 00 00       	push   $0x3d5
801007eb:	e8 92 fb ff ff       	call   80100382 <outb>
801007f0:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
801007f3:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801007f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801007fb:	01 d2                	add    %edx,%edx
801007fd:	01 d0                	add    %edx,%eax
801007ff:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100804:	90                   	nop
80100805:	c9                   	leave  
80100806:	c3                   	ret    

80100807 <consputc>:

void
consputc(int c)
{
80100807:	55                   	push   %ebp
80100808:	89 e5                	mov    %esp,%ebp
8010080a:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
8010080d:	a1 a0 d5 10 80       	mov    0x8010d5a0,%eax
80100812:	85 c0                	test   %eax,%eax
80100814:	74 07                	je     8010081d <consputc+0x16>
    cli();
80100816:	e8 86 fb ff ff       	call   801003a1 <cli>
    for(;;)
      ;
8010081b:	eb fe                	jmp    8010081b <consputc+0x14>
  }

  if(c == BACKSPACE){
8010081d:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100824:	75 29                	jne    8010084f <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100826:	83 ec 0c             	sub    $0xc,%esp
80100829:	6a 08                	push   $0x8
8010082b:	e8 d3 77 00 00       	call   80108003 <uartputc>
80100830:	83 c4 10             	add    $0x10,%esp
80100833:	83 ec 0c             	sub    $0xc,%esp
80100836:	6a 20                	push   $0x20
80100838:	e8 c6 77 00 00       	call   80108003 <uartputc>
8010083d:	83 c4 10             	add    $0x10,%esp
80100840:	83 ec 0c             	sub    $0xc,%esp
80100843:	6a 08                	push   $0x8
80100845:	e8 b9 77 00 00       	call   80108003 <uartputc>
8010084a:	83 c4 10             	add    $0x10,%esp
8010084d:	eb 0e                	jmp    8010085d <consputc+0x56>
  } else
    uartputc(c);
8010084f:	83 ec 0c             	sub    $0xc,%esp
80100852:	ff 75 08             	pushl  0x8(%ebp)
80100855:	e8 a9 77 00 00       	call   80108003 <uartputc>
8010085a:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
8010085d:	83 ec 0c             	sub    $0xc,%esp
80100860:	ff 75 08             	pushl  0x8(%ebp)
80100863:	e8 2a fe ff ff       	call   80100692 <cgaputc>
80100868:	83 c4 10             	add    $0x10,%esp
}
8010086b:	90                   	nop
8010086c:	c9                   	leave  
8010086d:	c3                   	ret    

8010086e <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
8010086e:	55                   	push   %ebp
8010086f:	89 e5                	mov    %esp,%ebp
80100871:	83 ec 18             	sub    $0x18,%esp
  int c;

  acquire(&input.lock);
80100874:	83 ec 0c             	sub    $0xc,%esp
80100877:	68 a0 27 11 80       	push   $0x801127a0
8010087c:	e8 78 5a 00 00       	call   801062f9 <acquire>
80100881:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100884:	e9 42 01 00 00       	jmp    801009cb <consoleintr+0x15d>
    switch(c){
80100889:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010088c:	83 f8 10             	cmp    $0x10,%eax
8010088f:	74 1e                	je     801008af <consoleintr+0x41>
80100891:	83 f8 10             	cmp    $0x10,%eax
80100894:	7f 0a                	jg     801008a0 <consoleintr+0x32>
80100896:	83 f8 08             	cmp    $0x8,%eax
80100899:	74 69                	je     80100904 <consoleintr+0x96>
8010089b:	e9 99 00 00 00       	jmp    80100939 <consoleintr+0xcb>
801008a0:	83 f8 15             	cmp    $0x15,%eax
801008a3:	74 31                	je     801008d6 <consoleintr+0x68>
801008a5:	83 f8 7f             	cmp    $0x7f,%eax
801008a8:	74 5a                	je     80100904 <consoleintr+0x96>
801008aa:	e9 8a 00 00 00       	jmp    80100939 <consoleintr+0xcb>
    case C('P'):  // Process listing.
      procdump();
801008af:	e8 4e 48 00 00       	call   80105102 <procdump>
      break;
801008b4:	e9 12 01 00 00       	jmp    801009cb <consoleintr+0x15d>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008b9:	a1 5c 28 11 80       	mov    0x8011285c,%eax
801008be:	83 e8 01             	sub    $0x1,%eax
801008c1:	a3 5c 28 11 80       	mov    %eax,0x8011285c
        consputc(BACKSPACE);
801008c6:	83 ec 0c             	sub    $0xc,%esp
801008c9:	68 00 01 00 00       	push   $0x100
801008ce:	e8 34 ff ff ff       	call   80100807 <consputc>
801008d3:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008d6:	8b 15 5c 28 11 80    	mov    0x8011285c,%edx
801008dc:	a1 58 28 11 80       	mov    0x80112858,%eax
801008e1:	39 c2                	cmp    %eax,%edx
801008e3:	0f 84 e2 00 00 00    	je     801009cb <consoleintr+0x15d>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008e9:	a1 5c 28 11 80       	mov    0x8011285c,%eax
801008ee:	83 e8 01             	sub    $0x1,%eax
801008f1:	83 e0 7f             	and    $0x7f,%eax
801008f4:	0f b6 80 d4 27 11 80 	movzbl -0x7feed82c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008fb:	3c 0a                	cmp    $0xa,%al
801008fd:	75 ba                	jne    801008b9 <consoleintr+0x4b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008ff:	e9 c7 00 00 00       	jmp    801009cb <consoleintr+0x15d>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100904:	8b 15 5c 28 11 80    	mov    0x8011285c,%edx
8010090a:	a1 58 28 11 80       	mov    0x80112858,%eax
8010090f:	39 c2                	cmp    %eax,%edx
80100911:	0f 84 b4 00 00 00    	je     801009cb <consoleintr+0x15d>
        input.e--;
80100917:	a1 5c 28 11 80       	mov    0x8011285c,%eax
8010091c:	83 e8 01             	sub    $0x1,%eax
8010091f:	a3 5c 28 11 80       	mov    %eax,0x8011285c
        consputc(BACKSPACE);
80100924:	83 ec 0c             	sub    $0xc,%esp
80100927:	68 00 01 00 00       	push   $0x100
8010092c:	e8 d6 fe ff ff       	call   80100807 <consputc>
80100931:	83 c4 10             	add    $0x10,%esp
      }
      break;
80100934:	e9 92 00 00 00       	jmp    801009cb <consoleintr+0x15d>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100939:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010093d:	0f 84 87 00 00 00    	je     801009ca <consoleintr+0x15c>
80100943:	8b 15 5c 28 11 80    	mov    0x8011285c,%edx
80100949:	a1 54 28 11 80       	mov    0x80112854,%eax
8010094e:	29 c2                	sub    %eax,%edx
80100950:	89 d0                	mov    %edx,%eax
80100952:	83 f8 7f             	cmp    $0x7f,%eax
80100955:	77 73                	ja     801009ca <consoleintr+0x15c>
        c = (c == '\r') ? '\n' : c;
80100957:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
8010095b:	74 05                	je     80100962 <consoleintr+0xf4>
8010095d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100960:	eb 05                	jmp    80100967 <consoleintr+0xf9>
80100962:	b8 0a 00 00 00       	mov    $0xa,%eax
80100967:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010096a:	a1 5c 28 11 80       	mov    0x8011285c,%eax
8010096f:	8d 50 01             	lea    0x1(%eax),%edx
80100972:	89 15 5c 28 11 80    	mov    %edx,0x8011285c
80100978:	83 e0 7f             	and    $0x7f,%eax
8010097b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010097e:	88 90 d4 27 11 80    	mov    %dl,-0x7feed82c(%eax)
        consputc(c);
80100984:	83 ec 0c             	sub    $0xc,%esp
80100987:	ff 75 f4             	pushl  -0xc(%ebp)
8010098a:	e8 78 fe ff ff       	call   80100807 <consputc>
8010098f:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100992:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
80100996:	74 18                	je     801009b0 <consoleintr+0x142>
80100998:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
8010099c:	74 12                	je     801009b0 <consoleintr+0x142>
8010099e:	a1 5c 28 11 80       	mov    0x8011285c,%eax
801009a3:	8b 15 54 28 11 80    	mov    0x80112854,%edx
801009a9:	83 ea 80             	sub    $0xffffff80,%edx
801009ac:	39 d0                	cmp    %edx,%eax
801009ae:	75 1a                	jne    801009ca <consoleintr+0x15c>
          input.w = input.e;
801009b0:	a1 5c 28 11 80       	mov    0x8011285c,%eax
801009b5:	a3 58 28 11 80       	mov    %eax,0x80112858
          wakeup(&input.r);
801009ba:	83 ec 0c             	sub    $0xc,%esp
801009bd:	68 54 28 11 80       	push   $0x80112854
801009c2:	e8 80 46 00 00       	call   80105047 <wakeup>
801009c7:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
801009ca:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
801009cb:	8b 45 08             	mov    0x8(%ebp),%eax
801009ce:	ff d0                	call   *%eax
801009d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801009d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009d7:	0f 89 ac fe ff ff    	jns    80100889 <consoleintr+0x1b>
        }
      }
      break;
    }
  }
  release(&input.lock);
801009dd:	83 ec 0c             	sub    $0xc,%esp
801009e0:	68 a0 27 11 80       	push   $0x801127a0
801009e5:	e8 76 59 00 00       	call   80106360 <release>
801009ea:	83 c4 10             	add    $0x10,%esp
}
801009ed:	90                   	nop
801009ee:	c9                   	leave  
801009ef:	c3                   	ret    

801009f0 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int off, int n)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
801009f6:	83 ec 0c             	sub    $0xc,%esp
801009f9:	ff 75 08             	pushl  0x8(%ebp)
801009fc:	e8 28 11 00 00       	call   80101b29 <iunlock>
80100a01:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a04:	8b 45 14             	mov    0x14(%ebp),%eax
80100a07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100a0a:	83 ec 0c             	sub    $0xc,%esp
80100a0d:	68 a0 27 11 80       	push   $0x801127a0
80100a12:	e8 e2 58 00 00       	call   801062f9 <acquire>
80100a17:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a1a:	e9 ac 00 00 00       	jmp    80100acb <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
80100a1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100a25:	8b 40 24             	mov    0x24(%eax),%eax
80100a28:	85 c0                	test   %eax,%eax
80100a2a:	74 28                	je     80100a54 <consoleread+0x64>
        release(&input.lock);
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	68 a0 27 11 80       	push   $0x801127a0
80100a34:	e8 27 59 00 00       	call   80106360 <release>
80100a39:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a3c:	83 ec 0c             	sub    $0xc,%esp
80100a3f:	ff 75 08             	pushl  0x8(%ebp)
80100a42:	e8 8a 0f 00 00       	call   801019d1 <ilock>
80100a47:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a4f:	e9 ab 00 00 00       	jmp    80100aff <consoleread+0x10f>
      }
      sleep(&input.r, &input.lock);
80100a54:	83 ec 08             	sub    $0x8,%esp
80100a57:	68 a0 27 11 80       	push   $0x801127a0
80100a5c:	68 54 28 11 80       	push   $0x80112854
80100a61:	e8 f6 44 00 00       	call   80104f5c <sleep>
80100a66:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100a69:	8b 15 54 28 11 80    	mov    0x80112854,%edx
80100a6f:	a1 58 28 11 80       	mov    0x80112858,%eax
80100a74:	39 c2                	cmp    %eax,%edx
80100a76:	74 a7                	je     80100a1f <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a78:	a1 54 28 11 80       	mov    0x80112854,%eax
80100a7d:	8d 50 01             	lea    0x1(%eax),%edx
80100a80:	89 15 54 28 11 80    	mov    %edx,0x80112854
80100a86:	83 e0 7f             	and    $0x7f,%eax
80100a89:	0f b6 80 d4 27 11 80 	movzbl -0x7feed82c(%eax),%eax
80100a90:	0f be c0             	movsbl %al,%eax
80100a93:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a96:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a9a:	75 17                	jne    80100ab3 <consoleread+0xc3>
      if(n < target){
80100a9c:	8b 45 14             	mov    0x14(%ebp),%eax
80100a9f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100aa2:	73 2f                	jae    80100ad3 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100aa4:	a1 54 28 11 80       	mov    0x80112854,%eax
80100aa9:	83 e8 01             	sub    $0x1,%eax
80100aac:	a3 54 28 11 80       	mov    %eax,0x80112854
      }
      break;
80100ab1:	eb 20                	jmp    80100ad3 <consoleread+0xe3>
    }
    *dst++ = c;
80100ab3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ab6:	8d 50 01             	lea    0x1(%eax),%edx
80100ab9:	89 55 0c             	mov    %edx,0xc(%ebp)
80100abc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100abf:	88 10                	mov    %dl,(%eax)
    --n;
80100ac1:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
    if(c == '\n')
80100ac5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100ac9:	74 0b                	je     80100ad6 <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
80100acb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80100acf:	7f 98                	jg     80100a69 <consoleread+0x79>
80100ad1:	eb 04                	jmp    80100ad7 <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100ad3:	90                   	nop
80100ad4:	eb 01                	jmp    80100ad7 <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100ad6:	90                   	nop
  }
  release(&input.lock);
80100ad7:	83 ec 0c             	sub    $0xc,%esp
80100ada:	68 a0 27 11 80       	push   $0x801127a0
80100adf:	e8 7c 58 00 00       	call   80106360 <release>
80100ae4:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ae7:	83 ec 0c             	sub    $0xc,%esp
80100aea:	ff 75 08             	pushl  0x8(%ebp)
80100aed:	e8 df 0e 00 00       	call   801019d1 <ilock>
80100af2:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100af5:	8b 45 14             	mov    0x14(%ebp),%eax
80100af8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100afb:	29 c2                	sub    %eax,%edx
80100afd:	89 d0                	mov    %edx,%eax
}
80100aff:	c9                   	leave  
80100b00:	c3                   	ret    

80100b01 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100b01:	55                   	push   %ebp
80100b02:	89 e5                	mov    %esp,%ebp
80100b04:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100b07:	83 ec 0c             	sub    $0xc,%esp
80100b0a:	ff 75 08             	pushl  0x8(%ebp)
80100b0d:	e8 17 10 00 00       	call   80101b29 <iunlock>
80100b12:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b15:	83 ec 0c             	sub    $0xc,%esp
80100b18:	68 c0 d5 10 80       	push   $0x8010d5c0
80100b1d:	e8 d7 57 00 00       	call   801062f9 <acquire>
80100b22:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b2c:	eb 21                	jmp    80100b4f <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100b2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b31:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b34:	01 d0                	add    %edx,%eax
80100b36:	0f b6 00             	movzbl (%eax),%eax
80100b39:	0f be c0             	movsbl %al,%eax
80100b3c:	0f b6 c0             	movzbl %al,%eax
80100b3f:	83 ec 0c             	sub    $0xc,%esp
80100b42:	50                   	push   %eax
80100b43:	e8 bf fc ff ff       	call   80100807 <consputc>
80100b48:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100b4b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b52:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b55:	7c d7                	jl     80100b2e <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100b57:	83 ec 0c             	sub    $0xc,%esp
80100b5a:	68 c0 d5 10 80       	push   $0x8010d5c0
80100b5f:	e8 fc 57 00 00       	call   80106360 <release>
80100b64:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b67:	83 ec 0c             	sub    $0xc,%esp
80100b6a:	ff 75 08             	pushl  0x8(%ebp)
80100b6d:	e8 5f 0e 00 00       	call   801019d1 <ilock>
80100b72:	83 c4 10             	add    $0x10,%esp

  return n;
80100b75:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b78:	c9                   	leave  
80100b79:	c3                   	ret    

80100b7a <consoleinit>:

void
consoleinit(void)
{
80100b7a:	55                   	push   %ebp
80100b7b:	89 e5                	mov    %esp,%ebp
80100b7d:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b80:	83 ec 08             	sub    $0x8,%esp
80100b83:	68 c7 99 10 80       	push   $0x801099c7
80100b88:	68 c0 d5 10 80       	push   $0x8010d5c0
80100b8d:	e8 45 57 00 00       	call   801062d7 <initlock>
80100b92:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100b95:	83 ec 08             	sub    $0x8,%esp
80100b98:	68 cf 99 10 80       	push   $0x801099cf
80100b9d:	68 a0 27 11 80       	push   $0x801127a0
80100ba2:	e8 30 57 00 00       	call   801062d7 <initlock>
80100ba7:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100baa:	c7 05 1c 32 11 80 01 	movl   $0x80100b01,0x8011321c
80100bb1:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100bb4:	c7 05 18 32 11 80 f0 	movl   $0x801009f0,0x80113218
80100bbb:	09 10 80 
  cons.locking = 1;
80100bbe:	c7 05 f4 d5 10 80 01 	movl   $0x1,0x8010d5f4
80100bc5:	00 00 00 

  picenable(IRQ_KBD);
80100bc8:	83 ec 0c             	sub    $0xc,%esp
80100bcb:	6a 01                	push   $0x1
80100bcd:	e8 c4 35 00 00       	call   80104196 <picenable>
80100bd2:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100bd5:	83 ec 08             	sub    $0x8,%esp
80100bd8:	6a 00                	push   $0x0
80100bda:	6a 01                	push   $0x1
80100bdc:	e8 52 21 00 00       	call   80102d33 <ioapicenable>
80100be1:	83 c4 10             	add    $0x10,%esp
}
80100be4:	90                   	nop
80100be5:	c9                   	leave  
80100be6:	c3                   	ret    

80100be7 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100be7:	55                   	push   %ebp
80100be8:	89 e5                	mov    %esp,%ebp
80100bea:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100bf0:	e8 b9 2b 00 00       	call   801037ae <begin_op>
  if((ip = namei(path)) == 0){
80100bf5:	83 ec 0c             	sub    $0xc,%esp
80100bf8:	ff 75 08             	pushl  0x8(%ebp)
80100bfb:	e8 a7 1a 00 00       	call   801026a7 <namei>
80100c00:	83 c4 10             	add    $0x10,%esp
80100c03:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c06:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c0a:	75 0f                	jne    80100c1b <exec+0x34>
    end_op();
80100c0c:	e8 29 2c 00 00       	call   8010383a <end_op>
    return -1;
80100c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c16:	e9 ce 03 00 00       	jmp    80100fe9 <exec+0x402>
  }
  ilock(ip);
80100c1b:	83 ec 0c             	sub    $0xc,%esp
80100c1e:	ff 75 d8             	pushl  -0x28(%ebp)
80100c21:	e8 ab 0d 00 00       	call   801019d1 <ilock>
80100c26:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c29:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100c30:	6a 34                	push   $0x34
80100c32:	6a 00                	push   $0x0
80100c34:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100c3a:	50                   	push   %eax
80100c3b:	ff 75 d8             	pushl  -0x28(%ebp)
80100c3e:	e8 f6 12 00 00       	call   80101f39 <readi>
80100c43:	83 c4 10             	add    $0x10,%esp
80100c46:	83 f8 33             	cmp    $0x33,%eax
80100c49:	0f 86 49 03 00 00    	jbe    80100f98 <exec+0x3b1>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c4f:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c55:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c5a:	0f 85 3b 03 00 00    	jne    80100f9b <exec+0x3b4>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c60:	e8 f3 84 00 00       	call   80109158 <setupkvm>
80100c65:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c68:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c6c:	0f 84 2c 03 00 00    	je     80100f9e <exec+0x3b7>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c72:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c79:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c80:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100c86:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c89:	e9 ab 00 00 00       	jmp    80100d39 <exec+0x152>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c91:	6a 20                	push   $0x20
80100c93:	50                   	push   %eax
80100c94:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c9a:	50                   	push   %eax
80100c9b:	ff 75 d8             	pushl  -0x28(%ebp)
80100c9e:	e8 96 12 00 00       	call   80101f39 <readi>
80100ca3:	83 c4 10             	add    $0x10,%esp
80100ca6:	83 f8 20             	cmp    $0x20,%eax
80100ca9:	0f 85 f2 02 00 00    	jne    80100fa1 <exec+0x3ba>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100caf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100cb5:	83 f8 01             	cmp    $0x1,%eax
80100cb8:	75 71                	jne    80100d2b <exec+0x144>
      continue;
    if(ph.memsz < ph.filesz)
80100cba:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100cc0:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cc6:	39 c2                	cmp    %eax,%edx
80100cc8:	0f 82 d6 02 00 00    	jb     80100fa4 <exec+0x3bd>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cce:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100cd4:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100cda:	01 d0                	add    %edx,%eax
80100cdc:	83 ec 04             	sub    $0x4,%esp
80100cdf:	50                   	push   %eax
80100ce0:	ff 75 e0             	pushl  -0x20(%ebp)
80100ce3:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ce6:	e8 14 88 00 00       	call   801094ff <allocuvm>
80100ceb:	83 c4 10             	add    $0x10,%esp
80100cee:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cf1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cf5:	0f 84 ac 02 00 00    	je     80100fa7 <exec+0x3c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100cfb:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100d01:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d07:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100d0d:	83 ec 0c             	sub    $0xc,%esp
80100d10:	52                   	push   %edx
80100d11:	50                   	push   %eax
80100d12:	ff 75 d8             	pushl  -0x28(%ebp)
80100d15:	51                   	push   %ecx
80100d16:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d19:	e8 0a 87 00 00       	call   80109428 <loaduvm>
80100d1e:	83 c4 20             	add    $0x20,%esp
80100d21:	85 c0                	test   %eax,%eax
80100d23:	0f 88 81 02 00 00    	js     80100faa <exec+0x3c3>
80100d29:	eb 01                	jmp    80100d2c <exec+0x145>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100d2b:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d2c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d30:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d33:	83 c0 20             	add    $0x20,%eax
80100d36:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d39:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100d40:	0f b7 c0             	movzwl %ax,%eax
80100d43:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100d46:	0f 8f 42 ff ff ff    	jg     80100c8e <exec+0xa7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100d4c:	83 ec 0c             	sub    $0xc,%esp
80100d4f:	ff 75 d8             	pushl  -0x28(%ebp)
80100d52:	e8 34 0f 00 00       	call   80101c8b <iunlockput>
80100d57:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d5a:	e8 db 2a 00 00       	call   8010383a <end_op>
  ip = 0;
80100d5f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d66:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d69:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d6e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d73:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d76:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d79:	05 00 20 00 00       	add    $0x2000,%eax
80100d7e:	83 ec 04             	sub    $0x4,%esp
80100d81:	50                   	push   %eax
80100d82:	ff 75 e0             	pushl  -0x20(%ebp)
80100d85:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d88:	e8 72 87 00 00       	call   801094ff <allocuvm>
80100d8d:	83 c4 10             	add    $0x10,%esp
80100d90:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d93:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d97:	0f 84 10 02 00 00    	je     80100fad <exec+0x3c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100da0:	2d 00 20 00 00       	sub    $0x2000,%eax
80100da5:	83 ec 08             	sub    $0x8,%esp
80100da8:	50                   	push   %eax
80100da9:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dac:	e8 74 89 00 00       	call   80109725 <clearpteu>
80100db1:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100db4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100db7:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100dba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100dc1:	e9 96 00 00 00       	jmp    80100e5c <exec+0x275>
    if(argc >= MAXARG)
80100dc6:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100dca:	0f 87 e0 01 00 00    	ja     80100fb0 <exec+0x3c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dda:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ddd:	01 d0                	add    %edx,%eax
80100ddf:	8b 00                	mov    (%eax),%eax
80100de1:	83 ec 0c             	sub    $0xc,%esp
80100de4:	50                   	push   %eax
80100de5:	e8 bf 59 00 00       	call   801067a9 <strlen>
80100dea:	83 c4 10             	add    $0x10,%esp
80100ded:	89 c2                	mov    %eax,%edx
80100def:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100df2:	29 d0                	sub    %edx,%eax
80100df4:	83 e8 01             	sub    $0x1,%eax
80100df7:	83 e0 fc             	and    $0xfffffffc,%eax
80100dfa:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e00:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e07:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e0a:	01 d0                	add    %edx,%eax
80100e0c:	8b 00                	mov    (%eax),%eax
80100e0e:	83 ec 0c             	sub    $0xc,%esp
80100e11:	50                   	push   %eax
80100e12:	e8 92 59 00 00       	call   801067a9 <strlen>
80100e17:	83 c4 10             	add    $0x10,%esp
80100e1a:	83 c0 01             	add    $0x1,%eax
80100e1d:	89 c1                	mov    %eax,%ecx
80100e1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e29:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e2c:	01 d0                	add    %edx,%eax
80100e2e:	8b 00                	mov    (%eax),%eax
80100e30:	51                   	push   %ecx
80100e31:	50                   	push   %eax
80100e32:	ff 75 dc             	pushl  -0x24(%ebp)
80100e35:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e38:	e8 9f 8a 00 00       	call   801098dc <copyout>
80100e3d:	83 c4 10             	add    $0x10,%esp
80100e40:	85 c0                	test   %eax,%eax
80100e42:	0f 88 6b 01 00 00    	js     80100fb3 <exec+0x3cc>
      goto bad;
    ustack[3+argc] = sp;
80100e48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4b:	8d 50 03             	lea    0x3(%eax),%edx
80100e4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e51:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e58:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e5f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e66:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e69:	01 d0                	add    %edx,%eax
80100e6b:	8b 00                	mov    (%eax),%eax
80100e6d:	85 c0                	test   %eax,%eax
80100e6f:	0f 85 51 ff ff ff    	jne    80100dc6 <exec+0x1df>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100e75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e78:	83 c0 03             	add    $0x3,%eax
80100e7b:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100e82:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e86:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e8d:	ff ff ff 
  ustack[1] = argc;
80100e90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e93:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e9c:	83 c0 01             	add    $0x1,%eax
80100e9f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ea6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ea9:	29 d0                	sub    %edx,%eax
80100eab:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100eb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eb4:	83 c0 04             	add    $0x4,%eax
80100eb7:	c1 e0 02             	shl    $0x2,%eax
80100eba:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ebd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ec0:	83 c0 04             	add    $0x4,%eax
80100ec3:	c1 e0 02             	shl    $0x2,%eax
80100ec6:	50                   	push   %eax
80100ec7:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100ecd:	50                   	push   %eax
80100ece:	ff 75 dc             	pushl  -0x24(%ebp)
80100ed1:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ed4:	e8 03 8a 00 00       	call   801098dc <copyout>
80100ed9:	83 c4 10             	add    $0x10,%esp
80100edc:	85 c0                	test   %eax,%eax
80100ede:	0f 88 d2 00 00 00    	js     80100fb6 <exec+0x3cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ee4:	8b 45 08             	mov    0x8(%ebp),%eax
80100ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eed:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ef0:	eb 17                	jmp    80100f09 <exec+0x322>
    if(*s == '/')
80100ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ef5:	0f b6 00             	movzbl (%eax),%eax
80100ef8:	3c 2f                	cmp    $0x2f,%al
80100efa:	75 09                	jne    80100f05 <exec+0x31e>
      last = s+1;
80100efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eff:	83 c0 01             	add    $0x1,%eax
80100f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f05:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f0c:	0f b6 00             	movzbl (%eax),%eax
80100f0f:	84 c0                	test   %al,%al
80100f11:	75 df                	jne    80100ef2 <exec+0x30b>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100f13:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f19:	83 c0 6c             	add    $0x6c,%eax
80100f1c:	83 ec 04             	sub    $0x4,%esp
80100f1f:	6a 10                	push   $0x10
80100f21:	ff 75 f0             	pushl  -0x10(%ebp)
80100f24:	50                   	push   %eax
80100f25:	e8 35 58 00 00       	call   8010675f <safestrcpy>
80100f2a:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100f2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f33:	8b 40 04             	mov    0x4(%eax),%eax
80100f36:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100f39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f3f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f42:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100f45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f4b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f4e:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100f50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f56:	8b 40 18             	mov    0x18(%eax),%eax
80100f59:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100f5f:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f62:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f68:	8b 40 18             	mov    0x18(%eax),%eax
80100f6b:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f6e:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f71:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f77:	83 ec 0c             	sub    $0xc,%esp
80100f7a:	50                   	push   %eax
80100f7b:	e8 bf 82 00 00       	call   8010923f <switchuvm>
80100f80:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f83:	83 ec 0c             	sub    $0xc,%esp
80100f86:	ff 75 d0             	pushl  -0x30(%ebp)
80100f89:	e8 f7 86 00 00       	call   80109685 <freevm>
80100f8e:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f91:	b8 00 00 00 00       	mov    $0x0,%eax
80100f96:	eb 51                	jmp    80100fe9 <exec+0x402>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100f98:	90                   	nop
80100f99:	eb 1c                	jmp    80100fb7 <exec+0x3d0>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100f9b:	90                   	nop
80100f9c:	eb 19                	jmp    80100fb7 <exec+0x3d0>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100f9e:	90                   	nop
80100f9f:	eb 16                	jmp    80100fb7 <exec+0x3d0>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100fa1:	90                   	nop
80100fa2:	eb 13                	jmp    80100fb7 <exec+0x3d0>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100fa4:	90                   	nop
80100fa5:	eb 10                	jmp    80100fb7 <exec+0x3d0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100fa7:	90                   	nop
80100fa8:	eb 0d                	jmp    80100fb7 <exec+0x3d0>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100faa:	90                   	nop
80100fab:	eb 0a                	jmp    80100fb7 <exec+0x3d0>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100fad:	90                   	nop
80100fae:	eb 07                	jmp    80100fb7 <exec+0x3d0>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100fb0:	90                   	nop
80100fb1:	eb 04                	jmp    80100fb7 <exec+0x3d0>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100fb3:	90                   	nop
80100fb4:	eb 01                	jmp    80100fb7 <exec+0x3d0>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100fb6:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100fb7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100fbb:	74 0e                	je     80100fcb <exec+0x3e4>
    freevm(pgdir);
80100fbd:	83 ec 0c             	sub    $0xc,%esp
80100fc0:	ff 75 d4             	pushl  -0x2c(%ebp)
80100fc3:	e8 bd 86 00 00       	call   80109685 <freevm>
80100fc8:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100fcb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fcf:	74 13                	je     80100fe4 <exec+0x3fd>
    iunlockput(ip);
80100fd1:	83 ec 0c             	sub    $0xc,%esp
80100fd4:	ff 75 d8             	pushl  -0x28(%ebp)
80100fd7:	e8 af 0c 00 00       	call   80101c8b <iunlockput>
80100fdc:	83 c4 10             	add    $0x10,%esp
    end_op();
80100fdf:	e8 56 28 00 00       	call   8010383a <end_op>
  }
  return -1;
80100fe4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe9:	c9                   	leave  
80100fea:	c3                   	ret    

80100feb <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100feb:	55                   	push   %ebp
80100fec:	89 e5                	mov    %esp,%ebp
80100fee:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100ff1:	83 ec 08             	sub    $0x8,%esp
80100ff4:	68 d5 99 10 80       	push   $0x801099d5
80100ff9:	68 60 28 11 80       	push   $0x80112860
80100ffe:	e8 d4 52 00 00       	call   801062d7 <initlock>
80101003:	83 c4 10             	add    $0x10,%esp
}
80101006:	90                   	nop
80101007:	c9                   	leave  
80101008:	c3                   	ret    

80101009 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101009:	55                   	push   %ebp
8010100a:	89 e5                	mov    %esp,%ebp
8010100c:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
8010100f:	83 ec 0c             	sub    $0xc,%esp
80101012:	68 60 28 11 80       	push   $0x80112860
80101017:	e8 dd 52 00 00       	call   801062f9 <acquire>
8010101c:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010101f:	c7 45 f4 94 28 11 80 	movl   $0x80112894,-0xc(%ebp)
80101026:	eb 2d                	jmp    80101055 <filealloc+0x4c>
    if(f->ref == 0){
80101028:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010102b:	8b 40 04             	mov    0x4(%eax),%eax
8010102e:	85 c0                	test   %eax,%eax
80101030:	75 1f                	jne    80101051 <filealloc+0x48>
      f->ref = 1;
80101032:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101035:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	68 60 28 11 80       	push   $0x80112860
80101044:	e8 17 53 00 00       	call   80106360 <release>
80101049:	83 c4 10             	add    $0x10,%esp
      return f;
8010104c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010104f:	eb 23                	jmp    80101074 <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101051:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101055:	b8 f4 31 11 80       	mov    $0x801131f4,%eax
8010105a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010105d:	72 c9                	jb     80101028 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
8010105f:	83 ec 0c             	sub    $0xc,%esp
80101062:	68 60 28 11 80       	push   $0x80112860
80101067:	e8 f4 52 00 00       	call   80106360 <release>
8010106c:	83 c4 10             	add    $0x10,%esp
  return 0;
8010106f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101074:	c9                   	leave  
80101075:	c3                   	ret    

80101076 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101076:	55                   	push   %ebp
80101077:	89 e5                	mov    %esp,%ebp
80101079:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
8010107c:	83 ec 0c             	sub    $0xc,%esp
8010107f:	68 60 28 11 80       	push   $0x80112860
80101084:	e8 70 52 00 00       	call   801062f9 <acquire>
80101089:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010108c:	8b 45 08             	mov    0x8(%ebp),%eax
8010108f:	8b 40 04             	mov    0x4(%eax),%eax
80101092:	85 c0                	test   %eax,%eax
80101094:	7f 0d                	jg     801010a3 <filedup+0x2d>
    panic("filedup");
80101096:	83 ec 0c             	sub    $0xc,%esp
80101099:	68 dc 99 10 80       	push   $0x801099dc
8010109e:	e8 54 f5 ff ff       	call   801005f7 <panic>
  f->ref++;
801010a3:	8b 45 08             	mov    0x8(%ebp),%eax
801010a6:	8b 40 04             	mov    0x4(%eax),%eax
801010a9:	8d 50 01             	lea    0x1(%eax),%edx
801010ac:	8b 45 08             	mov    0x8(%ebp),%eax
801010af:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010b2:	83 ec 0c             	sub    $0xc,%esp
801010b5:	68 60 28 11 80       	push   $0x80112860
801010ba:	e8 a1 52 00 00       	call   80106360 <release>
801010bf:	83 c4 10             	add    $0x10,%esp
  return f;
801010c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010c5:	c9                   	leave  
801010c6:	c3                   	ret    

801010c7 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010c7:	55                   	push   %ebp
801010c8:	89 e5                	mov    %esp,%ebp
801010ca:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801010cd:	83 ec 0c             	sub    $0xc,%esp
801010d0:	68 60 28 11 80       	push   $0x80112860
801010d5:	e8 1f 52 00 00       	call   801062f9 <acquire>
801010da:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010dd:	8b 45 08             	mov    0x8(%ebp),%eax
801010e0:	8b 40 04             	mov    0x4(%eax),%eax
801010e3:	85 c0                	test   %eax,%eax
801010e5:	7f 0d                	jg     801010f4 <fileclose+0x2d>
    panic("fileclose");
801010e7:	83 ec 0c             	sub    $0xc,%esp
801010ea:	68 e4 99 10 80       	push   $0x801099e4
801010ef:	e8 03 f5 ff ff       	call   801005f7 <panic>
  if(--f->ref > 0){
801010f4:	8b 45 08             	mov    0x8(%ebp),%eax
801010f7:	8b 40 04             	mov    0x4(%eax),%eax
801010fa:	8d 50 ff             	lea    -0x1(%eax),%edx
801010fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101100:	89 50 04             	mov    %edx,0x4(%eax)
80101103:	8b 45 08             	mov    0x8(%ebp),%eax
80101106:	8b 40 04             	mov    0x4(%eax),%eax
80101109:	85 c0                	test   %eax,%eax
8010110b:	7e 15                	jle    80101122 <fileclose+0x5b>
    release(&ftable.lock);
8010110d:	83 ec 0c             	sub    $0xc,%esp
80101110:	68 60 28 11 80       	push   $0x80112860
80101115:	e8 46 52 00 00       	call   80106360 <release>
8010111a:	83 c4 10             	add    $0x10,%esp
8010111d:	e9 8b 00 00 00       	jmp    801011ad <fileclose+0xe6>
    return;
  }
  ff = *f;
80101122:	8b 45 08             	mov    0x8(%ebp),%eax
80101125:	8b 10                	mov    (%eax),%edx
80101127:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010112a:	8b 50 04             	mov    0x4(%eax),%edx
8010112d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101130:	8b 50 08             	mov    0x8(%eax),%edx
80101133:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101136:	8b 50 0c             	mov    0xc(%eax),%edx
80101139:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010113c:	8b 50 10             	mov    0x10(%eax),%edx
8010113f:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101142:	8b 40 14             	mov    0x14(%eax),%eax
80101145:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101148:	8b 45 08             	mov    0x8(%ebp),%eax
8010114b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101152:	8b 45 08             	mov    0x8(%ebp),%eax
80101155:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010115b:	83 ec 0c             	sub    $0xc,%esp
8010115e:	68 60 28 11 80       	push   $0x80112860
80101163:	e8 f8 51 00 00       	call   80106360 <release>
80101168:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
8010116b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010116e:	83 f8 01             	cmp    $0x1,%eax
80101171:	75 19                	jne    8010118c <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
80101173:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101177:	0f be d0             	movsbl %al,%edx
8010117a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010117d:	83 ec 08             	sub    $0x8,%esp
80101180:	52                   	push   %edx
80101181:	50                   	push   %eax
80101182:	e8 78 32 00 00       	call   801043ff <pipeclose>
80101187:	83 c4 10             	add    $0x10,%esp
8010118a:	eb 21                	jmp    801011ad <fileclose+0xe6>
  else if(ff.type == FD_INODE){
8010118c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010118f:	83 f8 02             	cmp    $0x2,%eax
80101192:	75 19                	jne    801011ad <fileclose+0xe6>
    begin_op();
80101194:	e8 15 26 00 00       	call   801037ae <begin_op>
    iput(ff.ip);
80101199:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010119c:	83 ec 0c             	sub    $0xc,%esp
8010119f:	50                   	push   %eax
801011a0:	e8 f6 09 00 00       	call   80101b9b <iput>
801011a5:	83 c4 10             	add    $0x10,%esp
    end_op();
801011a8:	e8 8d 26 00 00       	call   8010383a <end_op>
  }
}
801011ad:	c9                   	leave  
801011ae:	c3                   	ret    

801011af <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011af:	55                   	push   %ebp
801011b0:	89 e5                	mov    %esp,%ebp
801011b2:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801011b5:	8b 45 08             	mov    0x8(%ebp),%eax
801011b8:	8b 00                	mov    (%eax),%eax
801011ba:	83 f8 02             	cmp    $0x2,%eax
801011bd:	75 40                	jne    801011ff <filestat+0x50>
    ilock(f->ip);
801011bf:	8b 45 08             	mov    0x8(%ebp),%eax
801011c2:	8b 40 10             	mov    0x10(%eax),%eax
801011c5:	83 ec 0c             	sub    $0xc,%esp
801011c8:	50                   	push   %eax
801011c9:	e8 03 08 00 00       	call   801019d1 <ilock>
801011ce:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801011d1:	8b 45 08             	mov    0x8(%ebp),%eax
801011d4:	8b 40 10             	mov    0x10(%eax),%eax
801011d7:	83 ec 08             	sub    $0x8,%esp
801011da:	ff 75 0c             	pushl  0xc(%ebp)
801011dd:	50                   	push   %eax
801011de:	e8 10 0d 00 00       	call   80101ef3 <stati>
801011e3:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801011e6:	8b 45 08             	mov    0x8(%ebp),%eax
801011e9:	8b 40 10             	mov    0x10(%eax),%eax
801011ec:	83 ec 0c             	sub    $0xc,%esp
801011ef:	50                   	push   %eax
801011f0:	e8 34 09 00 00       	call   80101b29 <iunlock>
801011f5:	83 c4 10             	add    $0x10,%esp
    return 0;
801011f8:	b8 00 00 00 00       	mov    $0x0,%eax
801011fd:	eb 05                	jmp    80101204 <filestat+0x55>
  }
  return -1;
801011ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101204:	c9                   	leave  
80101205:	c3                   	ret    

80101206 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101206:	55                   	push   %ebp
80101207:	89 e5                	mov    %esp,%ebp
80101209:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
8010120c:	8b 45 08             	mov    0x8(%ebp),%eax
8010120f:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101213:	84 c0                	test   %al,%al
80101215:	75 0a                	jne    80101221 <fileread+0x1b>
    return -1;
80101217:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010121c:	e9 9b 00 00 00       	jmp    801012bc <fileread+0xb6>
  if(f->type == FD_PIPE)
80101221:	8b 45 08             	mov    0x8(%ebp),%eax
80101224:	8b 00                	mov    (%eax),%eax
80101226:	83 f8 01             	cmp    $0x1,%eax
80101229:	75 1a                	jne    80101245 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
8010122b:	8b 45 08             	mov    0x8(%ebp),%eax
8010122e:	8b 40 0c             	mov    0xc(%eax),%eax
80101231:	83 ec 04             	sub    $0x4,%esp
80101234:	ff 75 10             	pushl  0x10(%ebp)
80101237:	ff 75 0c             	pushl  0xc(%ebp)
8010123a:	50                   	push   %eax
8010123b:	e8 67 33 00 00       	call   801045a7 <piperead>
80101240:	83 c4 10             	add    $0x10,%esp
80101243:	eb 77                	jmp    801012bc <fileread+0xb6>
  if(f->type == FD_INODE){
80101245:	8b 45 08             	mov    0x8(%ebp),%eax
80101248:	8b 00                	mov    (%eax),%eax
8010124a:	83 f8 02             	cmp    $0x2,%eax
8010124d:	75 60                	jne    801012af <fileread+0xa9>
    ilock(f->ip);
8010124f:	8b 45 08             	mov    0x8(%ebp),%eax
80101252:	8b 40 10             	mov    0x10(%eax),%eax
80101255:	83 ec 0c             	sub    $0xc,%esp
80101258:	50                   	push   %eax
80101259:	e8 73 07 00 00       	call   801019d1 <ilock>
8010125e:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101261:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101264:	8b 45 08             	mov    0x8(%ebp),%eax
80101267:	8b 50 14             	mov    0x14(%eax),%edx
8010126a:	8b 45 08             	mov    0x8(%ebp),%eax
8010126d:	8b 40 10             	mov    0x10(%eax),%eax
80101270:	51                   	push   %ecx
80101271:	52                   	push   %edx
80101272:	ff 75 0c             	pushl  0xc(%ebp)
80101275:	50                   	push   %eax
80101276:	e8 be 0c 00 00       	call   80101f39 <readi>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101281:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101285:	7e 11                	jle    80101298 <fileread+0x92>
      f->off += r;
80101287:	8b 45 08             	mov    0x8(%ebp),%eax
8010128a:	8b 50 14             	mov    0x14(%eax),%edx
8010128d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101290:	01 c2                	add    %eax,%edx
80101292:	8b 45 08             	mov    0x8(%ebp),%eax
80101295:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101298:	8b 45 08             	mov    0x8(%ebp),%eax
8010129b:	8b 40 10             	mov    0x10(%eax),%eax
8010129e:	83 ec 0c             	sub    $0xc,%esp
801012a1:	50                   	push   %eax
801012a2:	e8 82 08 00 00       	call   80101b29 <iunlock>
801012a7:	83 c4 10             	add    $0x10,%esp
    return r;
801012aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012ad:	eb 0d                	jmp    801012bc <fileread+0xb6>
  }
  panic("fileread");
801012af:	83 ec 0c             	sub    $0xc,%esp
801012b2:	68 ee 99 10 80       	push   $0x801099ee
801012b7:	e8 3b f3 ff ff       	call   801005f7 <panic>
}
801012bc:	c9                   	leave  
801012bd:	c3                   	ret    

801012be <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012be:	55                   	push   %ebp
801012bf:	89 e5                	mov    %esp,%ebp
801012c1:	53                   	push   %ebx
801012c2:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801012c5:	8b 45 08             	mov    0x8(%ebp),%eax
801012c8:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012cc:	84 c0                	test   %al,%al
801012ce:	75 0a                	jne    801012da <filewrite+0x1c>
    return -1;
801012d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012d5:	e9 1b 01 00 00       	jmp    801013f5 <filewrite+0x137>
  if(f->type == FD_PIPE)
801012da:	8b 45 08             	mov    0x8(%ebp),%eax
801012dd:	8b 00                	mov    (%eax),%eax
801012df:	83 f8 01             	cmp    $0x1,%eax
801012e2:	75 1d                	jne    80101301 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
801012e4:	8b 45 08             	mov    0x8(%ebp),%eax
801012e7:	8b 40 0c             	mov    0xc(%eax),%eax
801012ea:	83 ec 04             	sub    $0x4,%esp
801012ed:	ff 75 10             	pushl  0x10(%ebp)
801012f0:	ff 75 0c             	pushl  0xc(%ebp)
801012f3:	50                   	push   %eax
801012f4:	e8 b0 31 00 00       	call   801044a9 <pipewrite>
801012f9:	83 c4 10             	add    $0x10,%esp
801012fc:	e9 f4 00 00 00       	jmp    801013f5 <filewrite+0x137>
  if(f->type == FD_INODE){
80101301:	8b 45 08             	mov    0x8(%ebp),%eax
80101304:	8b 00                	mov    (%eax),%eax
80101306:	83 f8 02             	cmp    $0x2,%eax
80101309:	0f 85 d9 00 00 00    	jne    801013e8 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010130f:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101316:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010131d:	e9 a3 00 00 00       	jmp    801013c5 <filewrite+0x107>
      int n1 = n - i;
80101322:	8b 45 10             	mov    0x10(%ebp),%eax
80101325:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101328:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010132b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010132e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101331:	7e 06                	jle    80101339 <filewrite+0x7b>
        n1 = max;
80101333:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101336:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101339:	e8 70 24 00 00       	call   801037ae <begin_op>
      ilock(f->ip);
8010133e:	8b 45 08             	mov    0x8(%ebp),%eax
80101341:	8b 40 10             	mov    0x10(%eax),%eax
80101344:	83 ec 0c             	sub    $0xc,%esp
80101347:	50                   	push   %eax
80101348:	e8 84 06 00 00       	call   801019d1 <ilock>
8010134d:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101350:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101353:	8b 45 08             	mov    0x8(%ebp),%eax
80101356:	8b 50 14             	mov    0x14(%eax),%edx
80101359:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010135c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010135f:	01 c3                	add    %eax,%ebx
80101361:	8b 45 08             	mov    0x8(%ebp),%eax
80101364:	8b 40 10             	mov    0x10(%eax),%eax
80101367:	51                   	push   %ecx
80101368:	52                   	push   %edx
80101369:	53                   	push   %ebx
8010136a:	50                   	push   %eax
8010136b:	e8 27 0d 00 00       	call   80102097 <writei>
80101370:	83 c4 10             	add    $0x10,%esp
80101373:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101376:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010137a:	7e 11                	jle    8010138d <filewrite+0xcf>
        f->off += r;
8010137c:	8b 45 08             	mov    0x8(%ebp),%eax
8010137f:	8b 50 14             	mov    0x14(%eax),%edx
80101382:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101385:	01 c2                	add    %eax,%edx
80101387:	8b 45 08             	mov    0x8(%ebp),%eax
8010138a:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010138d:	8b 45 08             	mov    0x8(%ebp),%eax
80101390:	8b 40 10             	mov    0x10(%eax),%eax
80101393:	83 ec 0c             	sub    $0xc,%esp
80101396:	50                   	push   %eax
80101397:	e8 8d 07 00 00       	call   80101b29 <iunlock>
8010139c:	83 c4 10             	add    $0x10,%esp
      end_op();
8010139f:	e8 96 24 00 00       	call   8010383a <end_op>

      if(r < 0)
801013a4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013a8:	78 29                	js     801013d3 <filewrite+0x115>
        break;
      if(r != n1)
801013aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801013b0:	74 0d                	je     801013bf <filewrite+0x101>
        panic("short filewrite");
801013b2:	83 ec 0c             	sub    $0xc,%esp
801013b5:	68 f7 99 10 80       	push   $0x801099f7
801013ba:	e8 38 f2 ff ff       	call   801005f7 <panic>
      i += r;
801013bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013c2:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013c8:	3b 45 10             	cmp    0x10(%ebp),%eax
801013cb:	0f 8c 51 ff ff ff    	jl     80101322 <filewrite+0x64>
801013d1:	eb 01                	jmp    801013d4 <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
801013d3:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801013d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013d7:	3b 45 10             	cmp    0x10(%ebp),%eax
801013da:	75 05                	jne    801013e1 <filewrite+0x123>
801013dc:	8b 45 10             	mov    0x10(%ebp),%eax
801013df:	eb 14                	jmp    801013f5 <filewrite+0x137>
801013e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013e6:	eb 0d                	jmp    801013f5 <filewrite+0x137>
  }
  panic("filewrite");
801013e8:	83 ec 0c             	sub    $0xc,%esp
801013eb:	68 07 9a 10 80       	push   $0x80109a07
801013f0:	e8 02 f2 ff ff       	call   801005f7 <panic>
}
801013f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013f8:	c9                   	leave  
801013f9:	c3                   	ret    

801013fa <fileType>:

char* fileType(struct file *f) {
801013fa:	55                   	push   %ebp
801013fb:	89 e5                	mov    %esp,%ebp
 switch(f->type) {
801013fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101400:	8b 00                	mov    (%eax),%eax
80101402:	83 f8 01             	cmp    $0x1,%eax
80101405:	74 13                	je     8010141a <fileType+0x20>
80101407:	83 f8 01             	cmp    $0x1,%eax
8010140a:	72 07                	jb     80101413 <fileType+0x19>
8010140c:	83 f8 02             	cmp    $0x2,%eax
8010140f:	74 10                	je     80101421 <fileType+0x27>
80101411:	eb 15                	jmp    80101428 <fileType+0x2e>
  case FD_NONE:
  return "FD_NONE";
80101413:	b8 11 9a 10 80       	mov    $0x80109a11,%eax
80101418:	eb 13                	jmp    8010142d <fileType+0x33>
  break;
  case FD_PIPE:
  return "FD_PIPE";
8010141a:	b8 19 9a 10 80       	mov    $0x80109a19,%eax
8010141f:	eb 0c                	jmp    8010142d <fileType+0x33>
  break;
  case FD_INODE:
  return "FD_INODE";
80101421:	b8 21 9a 10 80       	mov    $0x80109a21,%eax
80101426:	eb 05                	jmp    8010142d <fileType+0x33>
  break;
  default:
  return "unknown type";
80101428:	b8 2a 9a 10 80       	mov    $0x80109a2a,%eax
 }
}
8010142d:	5d                   	pop    %ebp
8010142e:	c3                   	ret    

8010142f <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010142f:	55                   	push   %ebp
80101430:	89 e5                	mov    %esp,%ebp
80101432:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101435:	8b 45 08             	mov    0x8(%ebp),%eax
80101438:	83 ec 08             	sub    $0x8,%esp
8010143b:	6a 01                	push   $0x1
8010143d:	50                   	push   %eax
8010143e:	e8 cf ed ff ff       	call   80100212 <bread>
80101443:	83 c4 10             	add    $0x10,%esp
80101446:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101449:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010144c:	83 c0 18             	add    $0x18,%eax
8010144f:	83 ec 04             	sub    $0x4,%esp
80101452:	6a 10                	push   $0x10
80101454:	50                   	push   %eax
80101455:	ff 75 0c             	pushl  0xc(%ebp)
80101458:	e8 be 51 00 00       	call   8010661b <memmove>
8010145d:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101460:	83 ec 0c             	sub    $0xc,%esp
80101463:	ff 75 f4             	pushl  -0xc(%ebp)
80101466:	e8 1f ee ff ff       	call   8010028a <brelse>
8010146b:	83 c4 10             	add    $0x10,%esp
}
8010146e:	90                   	nop
8010146f:	c9                   	leave  
80101470:	c3                   	ret    

80101471 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101471:	55                   	push   %ebp
80101472:	89 e5                	mov    %esp,%ebp
80101474:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101477:	8b 55 0c             	mov    0xc(%ebp),%edx
8010147a:	8b 45 08             	mov    0x8(%ebp),%eax
8010147d:	83 ec 08             	sub    $0x8,%esp
80101480:	52                   	push   %edx
80101481:	50                   	push   %eax
80101482:	e8 8b ed ff ff       	call   80100212 <bread>
80101487:	83 c4 10             	add    $0x10,%esp
8010148a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010148d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101490:	83 c0 18             	add    $0x18,%eax
80101493:	83 ec 04             	sub    $0x4,%esp
80101496:	68 00 02 00 00       	push   $0x200
8010149b:	6a 00                	push   $0x0
8010149d:	50                   	push   %eax
8010149e:	e8 b9 50 00 00       	call   8010655c <memset>
801014a3:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801014a6:	83 ec 0c             	sub    $0xc,%esp
801014a9:	ff 75 f4             	pushl  -0xc(%ebp)
801014ac:	e8 35 25 00 00       	call   801039e6 <log_write>
801014b1:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801014b4:	83 ec 0c             	sub    $0xc,%esp
801014b7:	ff 75 f4             	pushl  -0xc(%ebp)
801014ba:	e8 cb ed ff ff       	call   8010028a <brelse>
801014bf:	83 c4 10             	add    $0x10,%esp
}
801014c2:	90                   	nop
801014c3:	c9                   	leave  
801014c4:	c3                   	ret    

801014c5 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801014c5:	55                   	push   %ebp
801014c6:	89 e5                	mov    %esp,%ebp
801014c8:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
801014cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801014d2:	8b 45 08             	mov    0x8(%ebp),%eax
801014d5:	83 ec 08             	sub    $0x8,%esp
801014d8:	8d 55 d8             	lea    -0x28(%ebp),%edx
801014db:	52                   	push   %edx
801014dc:	50                   	push   %eax
801014dd:	e8 4d ff ff ff       	call   8010142f <readsb>
801014e2:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
801014e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801014ec:	e9 15 01 00 00       	jmp    80101606 <balloc+0x141>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801014f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014f4:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801014fa:	85 c0                	test   %eax,%eax
801014fc:	0f 48 c2             	cmovs  %edx,%eax
801014ff:	c1 f8 0c             	sar    $0xc,%eax
80101502:	89 c2                	mov    %eax,%edx
80101504:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101507:	c1 e8 03             	shr    $0x3,%eax
8010150a:	01 d0                	add    %edx,%eax
8010150c:	83 c0 03             	add    $0x3,%eax
8010150f:	83 ec 08             	sub    $0x8,%esp
80101512:	50                   	push   %eax
80101513:	ff 75 08             	pushl  0x8(%ebp)
80101516:	e8 f7 ec ff ff       	call   80100212 <bread>
8010151b:	83 c4 10             	add    $0x10,%esp
8010151e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101521:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101528:	e9 a6 00 00 00       	jmp    801015d3 <balloc+0x10e>
      m = 1 << (bi % 8);
8010152d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101530:	99                   	cltd   
80101531:	c1 ea 1d             	shr    $0x1d,%edx
80101534:	01 d0                	add    %edx,%eax
80101536:	83 e0 07             	and    $0x7,%eax
80101539:	29 d0                	sub    %edx,%eax
8010153b:	ba 01 00 00 00       	mov    $0x1,%edx
80101540:	89 c1                	mov    %eax,%ecx
80101542:	d3 e2                	shl    %cl,%edx
80101544:	89 d0                	mov    %edx,%eax
80101546:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101549:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010154c:	8d 50 07             	lea    0x7(%eax),%edx
8010154f:	85 c0                	test   %eax,%eax
80101551:	0f 48 c2             	cmovs  %edx,%eax
80101554:	c1 f8 03             	sar    $0x3,%eax
80101557:	89 c2                	mov    %eax,%edx
80101559:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010155c:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101561:	0f b6 c0             	movzbl %al,%eax
80101564:	23 45 e8             	and    -0x18(%ebp),%eax
80101567:	85 c0                	test   %eax,%eax
80101569:	75 64                	jne    801015cf <balloc+0x10a>
        bp->data[bi/8] |= m;  // Mark block in use.
8010156b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010156e:	8d 50 07             	lea    0x7(%eax),%edx
80101571:	85 c0                	test   %eax,%eax
80101573:	0f 48 c2             	cmovs  %edx,%eax
80101576:	c1 f8 03             	sar    $0x3,%eax
80101579:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010157c:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101581:	89 d1                	mov    %edx,%ecx
80101583:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101586:	09 ca                	or     %ecx,%edx
80101588:	89 d1                	mov    %edx,%ecx
8010158a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010158d:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101591:	83 ec 0c             	sub    $0xc,%esp
80101594:	ff 75 ec             	pushl  -0x14(%ebp)
80101597:	e8 4a 24 00 00       	call   801039e6 <log_write>
8010159c:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
8010159f:	83 ec 0c             	sub    $0xc,%esp
801015a2:	ff 75 ec             	pushl  -0x14(%ebp)
801015a5:	e8 e0 ec ff ff       	call   8010028a <brelse>
801015aa:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801015ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015b3:	01 c2                	add    %eax,%edx
801015b5:	8b 45 08             	mov    0x8(%ebp),%eax
801015b8:	83 ec 08             	sub    $0x8,%esp
801015bb:	52                   	push   %edx
801015bc:	50                   	push   %eax
801015bd:	e8 af fe ff ff       	call   80101471 <bzero>
801015c2:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801015c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015cb:	01 d0                	add    %edx,%eax
801015cd:	eb 52                	jmp    80101621 <balloc+0x15c>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015cf:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801015d3:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801015da:	7f 15                	jg     801015f1 <balloc+0x12c>
801015dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015e2:	01 d0                	add    %edx,%eax
801015e4:	89 c2                	mov    %eax,%edx
801015e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
801015e9:	39 c2                	cmp    %eax,%edx
801015eb:	0f 82 3c ff ff ff    	jb     8010152d <balloc+0x68>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801015f1:	83 ec 0c             	sub    $0xc,%esp
801015f4:	ff 75 ec             	pushl  -0x14(%ebp)
801015f7:	e8 8e ec ff ff       	call   8010028a <brelse>
801015fc:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801015ff:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101606:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101609:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010160c:	39 c2                	cmp    %eax,%edx
8010160e:	0f 87 dd fe ff ff    	ja     801014f1 <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101614:	83 ec 0c             	sub    $0xc,%esp
80101617:	68 37 9a 10 80       	push   $0x80109a37
8010161c:	e8 d6 ef ff ff       	call   801005f7 <panic>
}
80101621:	c9                   	leave  
80101622:	c3                   	ret    

80101623 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101623:	55                   	push   %ebp
80101624:	89 e5                	mov    %esp,%ebp
80101626:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010162f:	50                   	push   %eax
80101630:	ff 75 08             	pushl  0x8(%ebp)
80101633:	e8 f7 fd ff ff       	call   8010142f <readsb>
80101638:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb.ninodes));
8010163b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010163e:	c1 e8 0c             	shr    $0xc,%eax
80101641:	89 c2                	mov    %eax,%edx
80101643:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101646:	c1 e8 03             	shr    $0x3,%eax
80101649:	01 d0                	add    %edx,%eax
8010164b:	8d 50 03             	lea    0x3(%eax),%edx
8010164e:	8b 45 08             	mov    0x8(%ebp),%eax
80101651:	83 ec 08             	sub    $0x8,%esp
80101654:	52                   	push   %edx
80101655:	50                   	push   %eax
80101656:	e8 b7 eb ff ff       	call   80100212 <bread>
8010165b:	83 c4 10             	add    $0x10,%esp
8010165e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101661:	8b 45 0c             	mov    0xc(%ebp),%eax
80101664:	25 ff 0f 00 00       	and    $0xfff,%eax
80101669:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010166c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010166f:	99                   	cltd   
80101670:	c1 ea 1d             	shr    $0x1d,%edx
80101673:	01 d0                	add    %edx,%eax
80101675:	83 e0 07             	and    $0x7,%eax
80101678:	29 d0                	sub    %edx,%eax
8010167a:	ba 01 00 00 00       	mov    $0x1,%edx
8010167f:	89 c1                	mov    %eax,%ecx
80101681:	d3 e2                	shl    %cl,%edx
80101683:	89 d0                	mov    %edx,%eax
80101685:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101688:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010168b:	8d 50 07             	lea    0x7(%eax),%edx
8010168e:	85 c0                	test   %eax,%eax
80101690:	0f 48 c2             	cmovs  %edx,%eax
80101693:	c1 f8 03             	sar    $0x3,%eax
80101696:	89 c2                	mov    %eax,%edx
80101698:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010169b:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801016a0:	0f b6 c0             	movzbl %al,%eax
801016a3:	23 45 ec             	and    -0x14(%ebp),%eax
801016a6:	85 c0                	test   %eax,%eax
801016a8:	75 0d                	jne    801016b7 <bfree+0x94>
    panic("freeing free block");
801016aa:	83 ec 0c             	sub    $0xc,%esp
801016ad:	68 4d 9a 10 80       	push   $0x80109a4d
801016b2:	e8 40 ef ff ff       	call   801005f7 <panic>
  bp->data[bi/8] &= ~m;
801016b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016ba:	8d 50 07             	lea    0x7(%eax),%edx
801016bd:	85 c0                	test   %eax,%eax
801016bf:	0f 48 c2             	cmovs  %edx,%eax
801016c2:	c1 f8 03             	sar    $0x3,%eax
801016c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016c8:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801016cd:	89 d1                	mov    %edx,%ecx
801016cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016d2:	f7 d2                	not    %edx
801016d4:	21 ca                	and    %ecx,%edx
801016d6:	89 d1                	mov    %edx,%ecx
801016d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016db:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801016df:	83 ec 0c             	sub    $0xc,%esp
801016e2:	ff 75 f4             	pushl  -0xc(%ebp)
801016e5:	e8 fc 22 00 00       	call   801039e6 <log_write>
801016ea:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801016ed:	83 ec 0c             	sub    $0xc,%esp
801016f0:	ff 75 f4             	pushl  -0xc(%ebp)
801016f3:	e8 92 eb ff ff       	call   8010028a <brelse>
801016f8:	83 c4 10             	add    $0x10,%esp
}
801016fb:	90                   	nop
801016fc:	c9                   	leave  
801016fd:	c3                   	ret    

801016fe <iinit>:
} icache;


void
iinit(void)
{
801016fe:	55                   	push   %ebp
801016ff:	89 e5                	mov    %esp,%ebp
80101701:	83 ec 08             	sub    $0x8,%esp
  initlock(&icache.lock, "icache");
80101704:	83 ec 08             	sub    $0x8,%esp
80101707:	68 60 9a 10 80       	push   $0x80109a60
8010170c:	68 a0 32 11 80       	push   $0x801132a0
80101711:	e8 c1 4b 00 00       	call   801062d7 <initlock>
80101716:	83 c4 10             	add    $0x10,%esp
}
80101719:	90                   	nop
8010171a:	c9                   	leave  
8010171b:	c3                   	ret    

8010171c <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
8010171c:	55                   	push   %ebp
8010171d:	89 e5                	mov    %esp,%ebp
8010171f:	83 ec 38             	sub    $0x38,%esp
80101722:	8b 45 0c             	mov    0xc(%ebp),%eax
80101725:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
80101729:	8b 45 08             	mov    0x8(%ebp),%eax
8010172c:	83 ec 08             	sub    $0x8,%esp
8010172f:	8d 55 dc             	lea    -0x24(%ebp),%edx
80101732:	52                   	push   %edx
80101733:	50                   	push   %eax
80101734:	e8 f6 fc ff ff       	call   8010142f <readsb>
80101739:	83 c4 10             	add    $0x10,%esp

  for(inum = 1; inum < sb.ninodes; inum++){
8010173c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101743:	e9 98 00 00 00       	jmp    801017e0 <ialloc+0xc4>
    bp = bread(dev, IBLOCK(inum));
80101748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010174b:	c1 e8 03             	shr    $0x3,%eax
8010174e:	83 c0 02             	add    $0x2,%eax
80101751:	83 ec 08             	sub    $0x8,%esp
80101754:	50                   	push   %eax
80101755:	ff 75 08             	pushl  0x8(%ebp)
80101758:	e8 b5 ea ff ff       	call   80100212 <bread>
8010175d:	83 c4 10             	add    $0x10,%esp
80101760:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101763:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101766:	8d 50 18             	lea    0x18(%eax),%edx
80101769:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010176c:	83 e0 07             	and    $0x7,%eax
8010176f:	c1 e0 06             	shl    $0x6,%eax
80101772:	01 d0                	add    %edx,%eax
80101774:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101777:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010177a:	0f b7 00             	movzwl (%eax),%eax
8010177d:	66 85 c0             	test   %ax,%ax
80101780:	75 4c                	jne    801017ce <ialloc+0xb2>
      memset(dip, 0, sizeof(*dip));
80101782:	83 ec 04             	sub    $0x4,%esp
80101785:	6a 40                	push   $0x40
80101787:	6a 00                	push   $0x0
80101789:	ff 75 ec             	pushl  -0x14(%ebp)
8010178c:	e8 cb 4d 00 00       	call   8010655c <memset>
80101791:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101794:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101797:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
8010179b:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
8010179e:	83 ec 0c             	sub    $0xc,%esp
801017a1:	ff 75 f0             	pushl  -0x10(%ebp)
801017a4:	e8 3d 22 00 00       	call   801039e6 <log_write>
801017a9:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801017ac:	83 ec 0c             	sub    $0xc,%esp
801017af:	ff 75 f0             	pushl  -0x10(%ebp)
801017b2:	e8 d3 ea ff ff       	call   8010028a <brelse>
801017b7:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017bd:	83 ec 08             	sub    $0x8,%esp
801017c0:	50                   	push   %eax
801017c1:	ff 75 08             	pushl  0x8(%ebp)
801017c4:	e8 ef 00 00 00       	call   801018b8 <iget>
801017c9:	83 c4 10             	add    $0x10,%esp
801017cc:	eb 2d                	jmp    801017fb <ialloc+0xdf>
    }
    brelse(bp);
801017ce:	83 ec 0c             	sub    $0xc,%esp
801017d1:	ff 75 f0             	pushl  -0x10(%ebp)
801017d4:	e8 b1 ea ff ff       	call   8010028a <brelse>
801017d9:	83 c4 10             	add    $0x10,%esp
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
801017dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801017e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801017e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e6:	39 c2                	cmp    %eax,%edx
801017e8:	0f 87 5a ff ff ff    	ja     80101748 <ialloc+0x2c>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801017ee:	83 ec 0c             	sub    $0xc,%esp
801017f1:	68 67 9a 10 80       	push   $0x80109a67
801017f6:	e8 fc ed ff ff       	call   801005f7 <panic>
}
801017fb:	c9                   	leave  
801017fc:	c3                   	ret    

801017fd <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801017fd:	55                   	push   %ebp
801017fe:	89 e5                	mov    %esp,%ebp
80101800:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
80101803:	8b 45 08             	mov    0x8(%ebp),%eax
80101806:	8b 40 04             	mov    0x4(%eax),%eax
80101809:	c1 e8 03             	shr    $0x3,%eax
8010180c:	8d 50 02             	lea    0x2(%eax),%edx
8010180f:	8b 45 08             	mov    0x8(%ebp),%eax
80101812:	8b 00                	mov    (%eax),%eax
80101814:	83 ec 08             	sub    $0x8,%esp
80101817:	52                   	push   %edx
80101818:	50                   	push   %eax
80101819:	e8 f4 e9 ff ff       	call   80100212 <bread>
8010181e:	83 c4 10             	add    $0x10,%esp
80101821:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101824:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101827:	8d 50 18             	lea    0x18(%eax),%edx
8010182a:	8b 45 08             	mov    0x8(%ebp),%eax
8010182d:	8b 40 04             	mov    0x4(%eax),%eax
80101830:	83 e0 07             	and    $0x7,%eax
80101833:	c1 e0 06             	shl    $0x6,%eax
80101836:	01 d0                	add    %edx,%eax
80101838:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010183b:	8b 45 08             	mov    0x8(%ebp),%eax
8010183e:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101842:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101845:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101848:	8b 45 08             	mov    0x8(%ebp),%eax
8010184b:	0f b7 50 12          	movzwl 0x12(%eax),%edx
8010184f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101852:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101856:	8b 45 08             	mov    0x8(%ebp),%eax
80101859:	0f b7 50 14          	movzwl 0x14(%eax),%edx
8010185d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101860:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101864:	8b 45 08             	mov    0x8(%ebp),%eax
80101867:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010186b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010186e:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101872:	8b 45 08             	mov    0x8(%ebp),%eax
80101875:	8b 50 18             	mov    0x18(%eax),%edx
80101878:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010187b:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010187e:	8b 45 08             	mov    0x8(%ebp),%eax
80101881:	8d 50 1c             	lea    0x1c(%eax),%edx
80101884:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101887:	83 c0 0c             	add    $0xc,%eax
8010188a:	83 ec 04             	sub    $0x4,%esp
8010188d:	6a 34                	push   $0x34
8010188f:	52                   	push   %edx
80101890:	50                   	push   %eax
80101891:	e8 85 4d 00 00       	call   8010661b <memmove>
80101896:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101899:	83 ec 0c             	sub    $0xc,%esp
8010189c:	ff 75 f4             	pushl  -0xc(%ebp)
8010189f:	e8 42 21 00 00       	call   801039e6 <log_write>
801018a4:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018a7:	83 ec 0c             	sub    $0xc,%esp
801018aa:	ff 75 f4             	pushl  -0xc(%ebp)
801018ad:	e8 d8 e9 ff ff       	call   8010028a <brelse>
801018b2:	83 c4 10             	add    $0x10,%esp
}
801018b5:	90                   	nop
801018b6:	c9                   	leave  
801018b7:	c3                   	ret    

801018b8 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018b8:	55                   	push   %ebp
801018b9:	89 e5                	mov    %esp,%ebp
801018bb:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801018be:	83 ec 0c             	sub    $0xc,%esp
801018c1:	68 a0 32 11 80       	push   $0x801132a0
801018c6:	e8 2e 4a 00 00       	call   801062f9 <acquire>
801018cb:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801018ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018d5:	c7 45 f4 d4 32 11 80 	movl   $0x801132d4,-0xc(%ebp)
801018dc:	eb 5d                	jmp    8010193b <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018e1:	8b 40 08             	mov    0x8(%eax),%eax
801018e4:	85 c0                	test   %eax,%eax
801018e6:	7e 39                	jle    80101921 <iget+0x69>
801018e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018eb:	8b 00                	mov    (%eax),%eax
801018ed:	3b 45 08             	cmp    0x8(%ebp),%eax
801018f0:	75 2f                	jne    80101921 <iget+0x69>
801018f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018f5:	8b 40 04             	mov    0x4(%eax),%eax
801018f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
801018fb:	75 24                	jne    80101921 <iget+0x69>
      ip->ref++;
801018fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101900:	8b 40 08             	mov    0x8(%eax),%eax
80101903:	8d 50 01             	lea    0x1(%eax),%edx
80101906:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101909:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
8010190c:	83 ec 0c             	sub    $0xc,%esp
8010190f:	68 a0 32 11 80       	push   $0x801132a0
80101914:	e8 47 4a 00 00       	call   80106360 <release>
80101919:	83 c4 10             	add    $0x10,%esp
      return ip;
8010191c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191f:	eb 74                	jmp    80101995 <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101921:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101925:	75 10                	jne    80101937 <iget+0x7f>
80101927:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010192a:	8b 40 08             	mov    0x8(%eax),%eax
8010192d:	85 c0                	test   %eax,%eax
8010192f:	75 06                	jne    80101937 <iget+0x7f>
      empty = ip;
80101931:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101934:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101937:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
8010193b:	81 7d f4 74 42 11 80 	cmpl   $0x80114274,-0xc(%ebp)
80101942:	72 9a                	jb     801018de <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101944:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101948:	75 0d                	jne    80101957 <iget+0x9f>
    panic("iget: no inodes");
8010194a:	83 ec 0c             	sub    $0xc,%esp
8010194d:	68 79 9a 10 80       	push   $0x80109a79
80101952:	e8 a0 ec ff ff       	call   801005f7 <panic>

  ip = empty;
80101957:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010195a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
8010195d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101960:	8b 55 08             	mov    0x8(%ebp),%edx
80101963:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101965:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101968:	8b 55 0c             	mov    0xc(%ebp),%edx
8010196b:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
8010196e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101971:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101978:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010197b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101982:	83 ec 0c             	sub    $0xc,%esp
80101985:	68 a0 32 11 80       	push   $0x801132a0
8010198a:	e8 d1 49 00 00       	call   80106360 <release>
8010198f:	83 c4 10             	add    $0x10,%esp

  return ip;
80101992:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101995:	c9                   	leave  
80101996:	c3                   	ret    

80101997 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101997:	55                   	push   %ebp
80101998:	89 e5                	mov    %esp,%ebp
8010199a:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
8010199d:	83 ec 0c             	sub    $0xc,%esp
801019a0:	68 a0 32 11 80       	push   $0x801132a0
801019a5:	e8 4f 49 00 00       	call   801062f9 <acquire>
801019aa:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019ad:	8b 45 08             	mov    0x8(%ebp),%eax
801019b0:	8b 40 08             	mov    0x8(%eax),%eax
801019b3:	8d 50 01             	lea    0x1(%eax),%edx
801019b6:	8b 45 08             	mov    0x8(%ebp),%eax
801019b9:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019bc:	83 ec 0c             	sub    $0xc,%esp
801019bf:	68 a0 32 11 80       	push   $0x801132a0
801019c4:	e8 97 49 00 00       	call   80106360 <release>
801019c9:	83 c4 10             	add    $0x10,%esp
  return ip;
801019cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
801019cf:	c9                   	leave  
801019d0:	c3                   	ret    

801019d1 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801019d1:	55                   	push   %ebp
801019d2:	89 e5                	mov    %esp,%ebp
801019d4:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801019d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019db:	74 0a                	je     801019e7 <ilock+0x16>
801019dd:	8b 45 08             	mov    0x8(%ebp),%eax
801019e0:	8b 40 08             	mov    0x8(%eax),%eax
801019e3:	85 c0                	test   %eax,%eax
801019e5:	7f 0d                	jg     801019f4 <ilock+0x23>
    panic("ilock");
801019e7:	83 ec 0c             	sub    $0xc,%esp
801019ea:	68 89 9a 10 80       	push   $0x80109a89
801019ef:	e8 03 ec ff ff       	call   801005f7 <panic>

  acquire(&icache.lock);
801019f4:	83 ec 0c             	sub    $0xc,%esp
801019f7:	68 a0 32 11 80       	push   $0x801132a0
801019fc:	e8 f8 48 00 00       	call   801062f9 <acquire>
80101a01:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a04:	eb 13                	jmp    80101a19 <ilock+0x48>
    sleep(ip, &icache.lock);
80101a06:	83 ec 08             	sub    $0x8,%esp
80101a09:	68 a0 32 11 80       	push   $0x801132a0
80101a0e:	ff 75 08             	pushl  0x8(%ebp)
80101a11:	e8 46 35 00 00       	call   80104f5c <sleep>
80101a16:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101a19:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1c:	8b 40 0c             	mov    0xc(%eax),%eax
80101a1f:	83 e0 01             	and    $0x1,%eax
80101a22:	85 c0                	test   %eax,%eax
80101a24:	75 e0                	jne    80101a06 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101a26:	8b 45 08             	mov    0x8(%ebp),%eax
80101a29:	8b 40 0c             	mov    0xc(%eax),%eax
80101a2c:	83 c8 01             	or     $0x1,%eax
80101a2f:	89 c2                	mov    %eax,%edx
80101a31:	8b 45 08             	mov    0x8(%ebp),%eax
80101a34:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101a37:	83 ec 0c             	sub    $0xc,%esp
80101a3a:	68 a0 32 11 80       	push   $0x801132a0
80101a3f:	e8 1c 49 00 00       	call   80106360 <release>
80101a44:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101a47:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4a:	8b 40 0c             	mov    0xc(%eax),%eax
80101a4d:	83 e0 02             	and    $0x2,%eax
80101a50:	85 c0                	test   %eax,%eax
80101a52:	0f 85 ce 00 00 00    	jne    80101b26 <ilock+0x155>
    bp = bread(ip->dev, IBLOCK(ip->inum));
80101a58:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5b:	8b 40 04             	mov    0x4(%eax),%eax
80101a5e:	c1 e8 03             	shr    $0x3,%eax
80101a61:	8d 50 02             	lea    0x2(%eax),%edx
80101a64:	8b 45 08             	mov    0x8(%ebp),%eax
80101a67:	8b 00                	mov    (%eax),%eax
80101a69:	83 ec 08             	sub    $0x8,%esp
80101a6c:	52                   	push   %edx
80101a6d:	50                   	push   %eax
80101a6e:	e8 9f e7 ff ff       	call   80100212 <bread>
80101a73:	83 c4 10             	add    $0x10,%esp
80101a76:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a7c:	8d 50 18             	lea    0x18(%eax),%edx
80101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a82:	8b 40 04             	mov    0x4(%eax),%eax
80101a85:	83 e0 07             	and    $0x7,%eax
80101a88:	c1 e0 06             	shl    $0x6,%eax
80101a8b:	01 d0                	add    %edx,%eax
80101a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a93:	0f b7 10             	movzwl (%eax),%edx
80101a96:	8b 45 08             	mov    0x8(%ebp),%eax
80101a99:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aa0:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa7:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aae:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab5:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101abc:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101ac0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac3:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aca:	8b 50 08             	mov    0x8(%eax),%edx
80101acd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad0:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ad6:	8d 50 0c             	lea    0xc(%eax),%edx
80101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
80101adc:	83 c0 1c             	add    $0x1c,%eax
80101adf:	83 ec 04             	sub    $0x4,%esp
80101ae2:	6a 34                	push   $0x34
80101ae4:	52                   	push   %edx
80101ae5:	50                   	push   %eax
80101ae6:	e8 30 4b 00 00       	call   8010661b <memmove>
80101aeb:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101aee:	83 ec 0c             	sub    $0xc,%esp
80101af1:	ff 75 f4             	pushl  -0xc(%ebp)
80101af4:	e8 91 e7 ff ff       	call   8010028a <brelse>
80101af9:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101afc:	8b 45 08             	mov    0x8(%ebp),%eax
80101aff:	8b 40 0c             	mov    0xc(%eax),%eax
80101b02:	83 c8 02             	or     $0x2,%eax
80101b05:	89 c2                	mov    %eax,%edx
80101b07:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0a:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101b0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b10:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101b14:	66 85 c0             	test   %ax,%ax
80101b17:	75 0d                	jne    80101b26 <ilock+0x155>
      panic("ilock: no type");
80101b19:	83 ec 0c             	sub    $0xc,%esp
80101b1c:	68 8f 9a 10 80       	push   $0x80109a8f
80101b21:	e8 d1 ea ff ff       	call   801005f7 <panic>
  }
}
80101b26:	90                   	nop
80101b27:	c9                   	leave  
80101b28:	c3                   	ret    

80101b29 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b29:	55                   	push   %ebp
80101b2a:	89 e5                	mov    %esp,%ebp
80101b2c:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101b2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b33:	74 17                	je     80101b4c <iunlock+0x23>
80101b35:	8b 45 08             	mov    0x8(%ebp),%eax
80101b38:	8b 40 0c             	mov    0xc(%eax),%eax
80101b3b:	83 e0 01             	and    $0x1,%eax
80101b3e:	85 c0                	test   %eax,%eax
80101b40:	74 0a                	je     80101b4c <iunlock+0x23>
80101b42:	8b 45 08             	mov    0x8(%ebp),%eax
80101b45:	8b 40 08             	mov    0x8(%eax),%eax
80101b48:	85 c0                	test   %eax,%eax
80101b4a:	7f 0d                	jg     80101b59 <iunlock+0x30>
    panic("iunlock");
80101b4c:	83 ec 0c             	sub    $0xc,%esp
80101b4f:	68 9e 9a 10 80       	push   $0x80109a9e
80101b54:	e8 9e ea ff ff       	call   801005f7 <panic>

  acquire(&icache.lock);
80101b59:	83 ec 0c             	sub    $0xc,%esp
80101b5c:	68 a0 32 11 80       	push   $0x801132a0
80101b61:	e8 93 47 00 00       	call   801062f9 <acquire>
80101b66:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101b69:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6c:	8b 40 0c             	mov    0xc(%eax),%eax
80101b6f:	83 e0 fe             	and    $0xfffffffe,%eax
80101b72:	89 c2                	mov    %eax,%edx
80101b74:	8b 45 08             	mov    0x8(%ebp),%eax
80101b77:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101b7a:	83 ec 0c             	sub    $0xc,%esp
80101b7d:	ff 75 08             	pushl  0x8(%ebp)
80101b80:	e8 c2 34 00 00       	call   80105047 <wakeup>
80101b85:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101b88:	83 ec 0c             	sub    $0xc,%esp
80101b8b:	68 a0 32 11 80       	push   $0x801132a0
80101b90:	e8 cb 47 00 00       	call   80106360 <release>
80101b95:	83 c4 10             	add    $0x10,%esp
}
80101b98:	90                   	nop
80101b99:	c9                   	leave  
80101b9a:	c3                   	ret    

80101b9b <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b9b:	55                   	push   %ebp
80101b9c:	89 e5                	mov    %esp,%ebp
80101b9e:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101ba1:	83 ec 0c             	sub    $0xc,%esp
80101ba4:	68 a0 32 11 80       	push   $0x801132a0
80101ba9:	e8 4b 47 00 00       	call   801062f9 <acquire>
80101bae:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101bb1:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb4:	8b 40 08             	mov    0x8(%eax),%eax
80101bb7:	83 f8 01             	cmp    $0x1,%eax
80101bba:	0f 85 a9 00 00 00    	jne    80101c69 <iput+0xce>
80101bc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc3:	8b 40 0c             	mov    0xc(%eax),%eax
80101bc6:	83 e0 02             	and    $0x2,%eax
80101bc9:	85 c0                	test   %eax,%eax
80101bcb:	0f 84 98 00 00 00    	je     80101c69 <iput+0xce>
80101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd4:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101bd8:	66 85 c0             	test   %ax,%ax
80101bdb:	0f 85 88 00 00 00    	jne    80101c69 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101be1:	8b 45 08             	mov    0x8(%ebp),%eax
80101be4:	8b 40 0c             	mov    0xc(%eax),%eax
80101be7:	83 e0 01             	and    $0x1,%eax
80101bea:	85 c0                	test   %eax,%eax
80101bec:	74 0d                	je     80101bfb <iput+0x60>
      panic("iput busy");
80101bee:	83 ec 0c             	sub    $0xc,%esp
80101bf1:	68 a6 9a 10 80       	push   $0x80109aa6
80101bf6:	e8 fc e9 ff ff       	call   801005f7 <panic>
    ip->flags |= I_BUSY;
80101bfb:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfe:	8b 40 0c             	mov    0xc(%eax),%eax
80101c01:	83 c8 01             	or     $0x1,%eax
80101c04:	89 c2                	mov    %eax,%edx
80101c06:	8b 45 08             	mov    0x8(%ebp),%eax
80101c09:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101c0c:	83 ec 0c             	sub    $0xc,%esp
80101c0f:	68 a0 32 11 80       	push   $0x801132a0
80101c14:	e8 47 47 00 00       	call   80106360 <release>
80101c19:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101c1c:	83 ec 0c             	sub    $0xc,%esp
80101c1f:	ff 75 08             	pushl  0x8(%ebp)
80101c22:	e8 a8 01 00 00       	call   80101dcf <itrunc>
80101c27:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101c2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2d:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101c33:	83 ec 0c             	sub    $0xc,%esp
80101c36:	ff 75 08             	pushl  0x8(%ebp)
80101c39:	e8 bf fb ff ff       	call   801017fd <iupdate>
80101c3e:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101c41:	83 ec 0c             	sub    $0xc,%esp
80101c44:	68 a0 32 11 80       	push   $0x801132a0
80101c49:	e8 ab 46 00 00       	call   801062f9 <acquire>
80101c4e:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c51:	8b 45 08             	mov    0x8(%ebp),%eax
80101c54:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101c5b:	83 ec 0c             	sub    $0xc,%esp
80101c5e:	ff 75 08             	pushl  0x8(%ebp)
80101c61:	e8 e1 33 00 00       	call   80105047 <wakeup>
80101c66:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101c69:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6c:	8b 40 08             	mov    0x8(%eax),%eax
80101c6f:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c72:	8b 45 08             	mov    0x8(%ebp),%eax
80101c75:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c78:	83 ec 0c             	sub    $0xc,%esp
80101c7b:	68 a0 32 11 80       	push   $0x801132a0
80101c80:	e8 db 46 00 00       	call   80106360 <release>
80101c85:	83 c4 10             	add    $0x10,%esp
}
80101c88:	90                   	nop
80101c89:	c9                   	leave  
80101c8a:	c3                   	ret    

80101c8b <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c8b:	55                   	push   %ebp
80101c8c:	89 e5                	mov    %esp,%ebp
80101c8e:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c91:	83 ec 0c             	sub    $0xc,%esp
80101c94:	ff 75 08             	pushl  0x8(%ebp)
80101c97:	e8 8d fe ff ff       	call   80101b29 <iunlock>
80101c9c:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c9f:	83 ec 0c             	sub    $0xc,%esp
80101ca2:	ff 75 08             	pushl  0x8(%ebp)
80101ca5:	e8 f1 fe ff ff       	call   80101b9b <iput>
80101caa:	83 c4 10             	add    $0x10,%esp
}
80101cad:	90                   	nop
80101cae:	c9                   	leave  
80101caf:	c3                   	ret    

80101cb0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	53                   	push   %ebx
80101cb4:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101cb7:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101cbb:	77 42                	ja     80101cff <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101cbd:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc0:	8b 55 0c             	mov    0xc(%ebp),%edx
80101cc3:	83 c2 04             	add    $0x4,%edx
80101cc6:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ccd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cd1:	75 24                	jne    80101cf7 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101cd3:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd6:	8b 00                	mov    (%eax),%eax
80101cd8:	83 ec 0c             	sub    $0xc,%esp
80101cdb:	50                   	push   %eax
80101cdc:	e8 e4 f7 ff ff       	call   801014c5 <balloc>
80101ce1:	83 c4 10             	add    $0x10,%esp
80101ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ce7:	8b 45 08             	mov    0x8(%ebp),%eax
80101cea:	8b 55 0c             	mov    0xc(%ebp),%edx
80101ced:	8d 4a 04             	lea    0x4(%edx),%ecx
80101cf0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cf3:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cfa:	e9 cb 00 00 00       	jmp    80101dca <bmap+0x11a>
  }
  bn -= NDIRECT;
80101cff:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101d03:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101d07:	0f 87 b0 00 00 00    	ja     80101dbd <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101d0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d10:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d13:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d1a:	75 1d                	jne    80101d39 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101d1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1f:	8b 00                	mov    (%eax),%eax
80101d21:	83 ec 0c             	sub    $0xc,%esp
80101d24:	50                   	push   %eax
80101d25:	e8 9b f7 ff ff       	call   801014c5 <balloc>
80101d2a:	83 c4 10             	add    $0x10,%esp
80101d2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d30:	8b 45 08             	mov    0x8(%ebp),%eax
80101d33:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d36:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101d39:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3c:	8b 00                	mov    (%eax),%eax
80101d3e:	83 ec 08             	sub    $0x8,%esp
80101d41:	ff 75 f4             	pushl  -0xc(%ebp)
80101d44:	50                   	push   %eax
80101d45:	e8 c8 e4 ff ff       	call   80100212 <bread>
80101d4a:	83 c4 10             	add    $0x10,%esp
80101d4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d53:	83 c0 18             	add    $0x18,%eax
80101d56:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d59:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d5c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d63:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d66:	01 d0                	add    %edx,%eax
80101d68:	8b 00                	mov    (%eax),%eax
80101d6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d71:	75 37                	jne    80101daa <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101d73:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d76:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d80:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101d83:	8b 45 08             	mov    0x8(%ebp),%eax
80101d86:	8b 00                	mov    (%eax),%eax
80101d88:	83 ec 0c             	sub    $0xc,%esp
80101d8b:	50                   	push   %eax
80101d8c:	e8 34 f7 ff ff       	call   801014c5 <balloc>
80101d91:	83 c4 10             	add    $0x10,%esp
80101d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d9a:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101d9c:	83 ec 0c             	sub    $0xc,%esp
80101d9f:	ff 75 f0             	pushl  -0x10(%ebp)
80101da2:	e8 3f 1c 00 00       	call   801039e6 <log_write>
80101da7:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101daa:	83 ec 0c             	sub    $0xc,%esp
80101dad:	ff 75 f0             	pushl  -0x10(%ebp)
80101db0:	e8 d5 e4 ff ff       	call   8010028a <brelse>
80101db5:	83 c4 10             	add    $0x10,%esp
    return addr;
80101db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101dbb:	eb 0d                	jmp    80101dca <bmap+0x11a>
  }

  panic("bmap: out of range");
80101dbd:	83 ec 0c             	sub    $0xc,%esp
80101dc0:	68 b0 9a 10 80       	push   $0x80109ab0
80101dc5:	e8 2d e8 ff ff       	call   801005f7 <panic>
}
80101dca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101dcd:	c9                   	leave  
80101dce:	c3                   	ret    

80101dcf <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101dcf:	55                   	push   %ebp
80101dd0:	89 e5                	mov    %esp,%ebp
80101dd2:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101dd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ddc:	eb 45                	jmp    80101e23 <itrunc+0x54>
    if(ip->addrs[i]){
80101dde:	8b 45 08             	mov    0x8(%ebp),%eax
80101de1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101de4:	83 c2 04             	add    $0x4,%edx
80101de7:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101deb:	85 c0                	test   %eax,%eax
80101ded:	74 30                	je     80101e1f <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101def:	8b 45 08             	mov    0x8(%ebp),%eax
80101df2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101df5:	83 c2 04             	add    $0x4,%edx
80101df8:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101dfc:	8b 55 08             	mov    0x8(%ebp),%edx
80101dff:	8b 12                	mov    (%edx),%edx
80101e01:	83 ec 08             	sub    $0x8,%esp
80101e04:	50                   	push   %eax
80101e05:	52                   	push   %edx
80101e06:	e8 18 f8 ff ff       	call   80101623 <bfree>
80101e0b:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101e0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e11:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e14:	83 c2 04             	add    $0x4,%edx
80101e17:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101e1e:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e1f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101e23:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101e27:	7e b5                	jle    80101dde <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
80101e29:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2c:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e2f:	85 c0                	test   %eax,%eax
80101e31:	0f 84 a1 00 00 00    	je     80101ed8 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e37:	8b 45 08             	mov    0x8(%ebp),%eax
80101e3a:	8b 50 4c             	mov    0x4c(%eax),%edx
80101e3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e40:	8b 00                	mov    (%eax),%eax
80101e42:	83 ec 08             	sub    $0x8,%esp
80101e45:	52                   	push   %edx
80101e46:	50                   	push   %eax
80101e47:	e8 c6 e3 ff ff       	call   80100212 <bread>
80101e4c:	83 c4 10             	add    $0x10,%esp
80101e4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e52:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e55:	83 c0 18             	add    $0x18,%eax
80101e58:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e5b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e62:	eb 3c                	jmp    80101ea0 <itrunc+0xd1>
      if(a[j])
80101e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e67:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e71:	01 d0                	add    %edx,%eax
80101e73:	8b 00                	mov    (%eax),%eax
80101e75:	85 c0                	test   %eax,%eax
80101e77:	74 23                	je     80101e9c <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e7c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e83:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e86:	01 d0                	add    %edx,%eax
80101e88:	8b 00                	mov    (%eax),%eax
80101e8a:	8b 55 08             	mov    0x8(%ebp),%edx
80101e8d:	8b 12                	mov    (%edx),%edx
80101e8f:	83 ec 08             	sub    $0x8,%esp
80101e92:	50                   	push   %eax
80101e93:	52                   	push   %edx
80101e94:	e8 8a f7 ff ff       	call   80101623 <bfree>
80101e99:	83 c4 10             	add    $0x10,%esp
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101e9c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ea3:	83 f8 7f             	cmp    $0x7f,%eax
80101ea6:	76 bc                	jbe    80101e64 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101ea8:	83 ec 0c             	sub    $0xc,%esp
80101eab:	ff 75 ec             	pushl  -0x14(%ebp)
80101eae:	e8 d7 e3 ff ff       	call   8010028a <brelse>
80101eb3:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101eb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb9:	8b 40 4c             	mov    0x4c(%eax),%eax
80101ebc:	8b 55 08             	mov    0x8(%ebp),%edx
80101ebf:	8b 12                	mov    (%edx),%edx
80101ec1:	83 ec 08             	sub    $0x8,%esp
80101ec4:	50                   	push   %eax
80101ec5:	52                   	push   %edx
80101ec6:	e8 58 f7 ff ff       	call   80101623 <bfree>
80101ecb:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101ece:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed1:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101ed8:	8b 45 08             	mov    0x8(%ebp),%eax
80101edb:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101ee2:	83 ec 0c             	sub    $0xc,%esp
80101ee5:	ff 75 08             	pushl  0x8(%ebp)
80101ee8:	e8 10 f9 ff ff       	call   801017fd <iupdate>
80101eed:	83 c4 10             	add    $0x10,%esp
}
80101ef0:	90                   	nop
80101ef1:	c9                   	leave  
80101ef2:	c3                   	ret    

80101ef3 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101ef3:	55                   	push   %ebp
80101ef4:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101ef6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef9:	8b 00                	mov    (%eax),%eax
80101efb:	89 c2                	mov    %eax,%edx
80101efd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f00:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101f03:	8b 45 08             	mov    0x8(%ebp),%eax
80101f06:	8b 50 04             	mov    0x4(%eax),%edx
80101f09:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f0c:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101f0f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f12:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101f16:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f19:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101f1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1f:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101f23:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f26:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101f2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2d:	8b 50 18             	mov    0x18(%eax),%edx
80101f30:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f33:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f36:	90                   	nop
80101f37:	5d                   	pop    %ebp
80101f38:	c3                   	ret    

80101f39 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f39:	55                   	push   %ebp
80101f3a:	89 e5                	mov    %esp,%ebp
80101f3c:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f42:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f46:	66 83 f8 03          	cmp    $0x3,%ax
80101f4a:	75 63                	jne    80101faf <readi+0x76>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f53:	66 85 c0             	test   %ax,%ax
80101f56:	78 23                	js     80101f7b <readi+0x42>
80101f58:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f5f:	66 83 f8 09          	cmp    $0x9,%ax
80101f63:	7f 16                	jg     80101f7b <readi+0x42>
80101f65:	8b 45 08             	mov    0x8(%ebp),%eax
80101f68:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f6c:	98                   	cwtl   
80101f6d:	c1 e0 04             	shl    $0x4,%eax
80101f70:	05 08 32 11 80       	add    $0x80113208,%eax
80101f75:	8b 00                	mov    (%eax),%eax
80101f77:	85 c0                	test   %eax,%eax
80101f79:	75 0a                	jne    80101f85 <readi+0x4c>
      return -1;
80101f7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f80:	e9 10 01 00 00       	jmp    80102095 <readi+0x15c>
    return devsw[ip->major].read(ip, dst, off, n);
80101f85:	8b 45 08             	mov    0x8(%ebp),%eax
80101f88:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f8c:	98                   	cwtl   
80101f8d:	c1 e0 04             	shl    $0x4,%eax
80101f90:	05 08 32 11 80       	add    $0x80113208,%eax
80101f95:	8b 00                	mov    (%eax),%eax
80101f97:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101f9a:	8b 55 10             	mov    0x10(%ebp),%edx
80101f9d:	51                   	push   %ecx
80101f9e:	52                   	push   %edx
80101f9f:	ff 75 0c             	pushl  0xc(%ebp)
80101fa2:	ff 75 08             	pushl  0x8(%ebp)
80101fa5:	ff d0                	call   *%eax
80101fa7:	83 c4 10             	add    $0x10,%esp
80101faa:	e9 e6 00 00 00       	jmp    80102095 <readi+0x15c>
  }

  if(off > ip->size || off + n < off)
80101faf:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb2:	8b 40 18             	mov    0x18(%eax),%eax
80101fb5:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fb8:	72 0d                	jb     80101fc7 <readi+0x8e>
80101fba:	8b 55 10             	mov    0x10(%ebp),%edx
80101fbd:	8b 45 14             	mov    0x14(%ebp),%eax
80101fc0:	01 d0                	add    %edx,%eax
80101fc2:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fc5:	73 0a                	jae    80101fd1 <readi+0x98>
    return -1;
80101fc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fcc:	e9 c4 00 00 00       	jmp    80102095 <readi+0x15c>
  if(off + n > ip->size)
80101fd1:	8b 55 10             	mov    0x10(%ebp),%edx
80101fd4:	8b 45 14             	mov    0x14(%ebp),%eax
80101fd7:	01 c2                	add    %eax,%edx
80101fd9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fdc:	8b 40 18             	mov    0x18(%eax),%eax
80101fdf:	39 c2                	cmp    %eax,%edx
80101fe1:	76 0c                	jbe    80101fef <readi+0xb6>
    n = ip->size - off;
80101fe3:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe6:	8b 40 18             	mov    0x18(%eax),%eax
80101fe9:	2b 45 10             	sub    0x10(%ebp),%eax
80101fec:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ff6:	e9 8b 00 00 00       	jmp    80102086 <readi+0x14d>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ffb:	8b 45 10             	mov    0x10(%ebp),%eax
80101ffe:	c1 e8 09             	shr    $0x9,%eax
80102001:	83 ec 08             	sub    $0x8,%esp
80102004:	50                   	push   %eax
80102005:	ff 75 08             	pushl  0x8(%ebp)
80102008:	e8 a3 fc ff ff       	call   80101cb0 <bmap>
8010200d:	83 c4 10             	add    $0x10,%esp
80102010:	89 c2                	mov    %eax,%edx
80102012:	8b 45 08             	mov    0x8(%ebp),%eax
80102015:	8b 00                	mov    (%eax),%eax
80102017:	83 ec 08             	sub    $0x8,%esp
8010201a:	52                   	push   %edx
8010201b:	50                   	push   %eax
8010201c:	e8 f1 e1 ff ff       	call   80100212 <bread>
80102021:	83 c4 10             	add    $0x10,%esp
80102024:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102027:	8b 45 10             	mov    0x10(%ebp),%eax
8010202a:	25 ff 01 00 00       	and    $0x1ff,%eax
8010202f:	ba 00 02 00 00       	mov    $0x200,%edx
80102034:	29 c2                	sub    %eax,%edx
80102036:	8b 45 14             	mov    0x14(%ebp),%eax
80102039:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010203c:	39 c2                	cmp    %eax,%edx
8010203e:	0f 46 c2             	cmovbe %edx,%eax
80102041:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80102044:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102047:	8d 50 18             	lea    0x18(%eax),%edx
8010204a:	8b 45 10             	mov    0x10(%ebp),%eax
8010204d:	25 ff 01 00 00       	and    $0x1ff,%eax
80102052:	01 d0                	add    %edx,%eax
80102054:	83 ec 04             	sub    $0x4,%esp
80102057:	ff 75 ec             	pushl  -0x14(%ebp)
8010205a:	50                   	push   %eax
8010205b:	ff 75 0c             	pushl  0xc(%ebp)
8010205e:	e8 b8 45 00 00       	call   8010661b <memmove>
80102063:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102066:	83 ec 0c             	sub    $0xc,%esp
80102069:	ff 75 f0             	pushl  -0x10(%ebp)
8010206c:	e8 19 e2 ff ff       	call   8010028a <brelse>
80102071:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102074:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102077:	01 45 f4             	add    %eax,-0xc(%ebp)
8010207a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010207d:	01 45 10             	add    %eax,0x10(%ebp)
80102080:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102083:	01 45 0c             	add    %eax,0xc(%ebp)
80102086:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102089:	3b 45 14             	cmp    0x14(%ebp),%eax
8010208c:	0f 82 69 ff ff ff    	jb     80101ffb <readi+0xc2>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80102092:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102095:	c9                   	leave  
80102096:	c3                   	ret    

80102097 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102097:	55                   	push   %ebp
80102098:	89 e5                	mov    %esp,%ebp
8010209a:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010209d:	8b 45 08             	mov    0x8(%ebp),%eax
801020a0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020a4:	66 83 f8 03          	cmp    $0x3,%ax
801020a8:	75 62                	jne    8010210c <writei+0x75>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801020aa:	8b 45 08             	mov    0x8(%ebp),%eax
801020ad:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020b1:	66 85 c0             	test   %ax,%ax
801020b4:	78 23                	js     801020d9 <writei+0x42>
801020b6:	8b 45 08             	mov    0x8(%ebp),%eax
801020b9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020bd:	66 83 f8 09          	cmp    $0x9,%ax
801020c1:	7f 16                	jg     801020d9 <writei+0x42>
801020c3:	8b 45 08             	mov    0x8(%ebp),%eax
801020c6:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020ca:	98                   	cwtl   
801020cb:	c1 e0 04             	shl    $0x4,%eax
801020ce:	05 0c 32 11 80       	add    $0x8011320c,%eax
801020d3:	8b 00                	mov    (%eax),%eax
801020d5:	85 c0                	test   %eax,%eax
801020d7:	75 0a                	jne    801020e3 <writei+0x4c>
      return -1;
801020d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020de:	e9 40 01 00 00       	jmp    80102223 <writei+0x18c>
    return devsw[ip->major].write(ip, src, n);
801020e3:	8b 45 08             	mov    0x8(%ebp),%eax
801020e6:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020ea:	98                   	cwtl   
801020eb:	c1 e0 04             	shl    $0x4,%eax
801020ee:	05 0c 32 11 80       	add    $0x8011320c,%eax
801020f3:	8b 00                	mov    (%eax),%eax
801020f5:	8b 55 14             	mov    0x14(%ebp),%edx
801020f8:	83 ec 04             	sub    $0x4,%esp
801020fb:	52                   	push   %edx
801020fc:	ff 75 0c             	pushl  0xc(%ebp)
801020ff:	ff 75 08             	pushl  0x8(%ebp)
80102102:	ff d0                	call   *%eax
80102104:	83 c4 10             	add    $0x10,%esp
80102107:	e9 17 01 00 00       	jmp    80102223 <writei+0x18c>
  }

  if(off > ip->size || off + n < off)
8010210c:	8b 45 08             	mov    0x8(%ebp),%eax
8010210f:	8b 40 18             	mov    0x18(%eax),%eax
80102112:	3b 45 10             	cmp    0x10(%ebp),%eax
80102115:	72 0d                	jb     80102124 <writei+0x8d>
80102117:	8b 55 10             	mov    0x10(%ebp),%edx
8010211a:	8b 45 14             	mov    0x14(%ebp),%eax
8010211d:	01 d0                	add    %edx,%eax
8010211f:	3b 45 10             	cmp    0x10(%ebp),%eax
80102122:	73 0a                	jae    8010212e <writei+0x97>
    return -1;
80102124:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102129:	e9 f5 00 00 00       	jmp    80102223 <writei+0x18c>
  if(off + n > MAXFILE*BSIZE)
8010212e:	8b 55 10             	mov    0x10(%ebp),%edx
80102131:	8b 45 14             	mov    0x14(%ebp),%eax
80102134:	01 d0                	add    %edx,%eax
80102136:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010213b:	76 0a                	jbe    80102147 <writei+0xb0>
    return -1;
8010213d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102142:	e9 dc 00 00 00       	jmp    80102223 <writei+0x18c>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102147:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010214e:	e9 99 00 00 00       	jmp    801021ec <writei+0x155>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102153:	8b 45 10             	mov    0x10(%ebp),%eax
80102156:	c1 e8 09             	shr    $0x9,%eax
80102159:	83 ec 08             	sub    $0x8,%esp
8010215c:	50                   	push   %eax
8010215d:	ff 75 08             	pushl  0x8(%ebp)
80102160:	e8 4b fb ff ff       	call   80101cb0 <bmap>
80102165:	83 c4 10             	add    $0x10,%esp
80102168:	89 c2                	mov    %eax,%edx
8010216a:	8b 45 08             	mov    0x8(%ebp),%eax
8010216d:	8b 00                	mov    (%eax),%eax
8010216f:	83 ec 08             	sub    $0x8,%esp
80102172:	52                   	push   %edx
80102173:	50                   	push   %eax
80102174:	e8 99 e0 ff ff       	call   80100212 <bread>
80102179:	83 c4 10             	add    $0x10,%esp
8010217c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010217f:	8b 45 10             	mov    0x10(%ebp),%eax
80102182:	25 ff 01 00 00       	and    $0x1ff,%eax
80102187:	ba 00 02 00 00       	mov    $0x200,%edx
8010218c:	29 c2                	sub    %eax,%edx
8010218e:	8b 45 14             	mov    0x14(%ebp),%eax
80102191:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102194:	39 c2                	cmp    %eax,%edx
80102196:	0f 46 c2             	cmovbe %edx,%eax
80102199:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010219c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010219f:	8d 50 18             	lea    0x18(%eax),%edx
801021a2:	8b 45 10             	mov    0x10(%ebp),%eax
801021a5:	25 ff 01 00 00       	and    $0x1ff,%eax
801021aa:	01 d0                	add    %edx,%eax
801021ac:	83 ec 04             	sub    $0x4,%esp
801021af:	ff 75 ec             	pushl  -0x14(%ebp)
801021b2:	ff 75 0c             	pushl  0xc(%ebp)
801021b5:	50                   	push   %eax
801021b6:	e8 60 44 00 00       	call   8010661b <memmove>
801021bb:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801021be:	83 ec 0c             	sub    $0xc,%esp
801021c1:	ff 75 f0             	pushl  -0x10(%ebp)
801021c4:	e8 1d 18 00 00       	call   801039e6 <log_write>
801021c9:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801021cc:	83 ec 0c             	sub    $0xc,%esp
801021cf:	ff 75 f0             	pushl  -0x10(%ebp)
801021d2:	e8 b3 e0 ff ff       	call   8010028a <brelse>
801021d7:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801021da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021dd:	01 45 f4             	add    %eax,-0xc(%ebp)
801021e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021e3:	01 45 10             	add    %eax,0x10(%ebp)
801021e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021e9:	01 45 0c             	add    %eax,0xc(%ebp)
801021ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021ef:	3b 45 14             	cmp    0x14(%ebp),%eax
801021f2:	0f 82 5b ff ff ff    	jb     80102153 <writei+0xbc>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801021f8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801021fc:	74 22                	je     80102220 <writei+0x189>
801021fe:	8b 45 08             	mov    0x8(%ebp),%eax
80102201:	8b 40 18             	mov    0x18(%eax),%eax
80102204:	3b 45 10             	cmp    0x10(%ebp),%eax
80102207:	73 17                	jae    80102220 <writei+0x189>
    ip->size = off;
80102209:	8b 45 08             	mov    0x8(%ebp),%eax
8010220c:	8b 55 10             	mov    0x10(%ebp),%edx
8010220f:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102212:	83 ec 0c             	sub    $0xc,%esp
80102215:	ff 75 08             	pushl  0x8(%ebp)
80102218:	e8 e0 f5 ff ff       	call   801017fd <iupdate>
8010221d:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102220:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102223:	c9                   	leave  
80102224:	c3                   	ret    

80102225 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102225:	55                   	push   %ebp
80102226:	89 e5                	mov    %esp,%ebp
80102228:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
8010222b:	83 ec 04             	sub    $0x4,%esp
8010222e:	6a 0e                	push   $0xe
80102230:	ff 75 0c             	pushl  0xc(%ebp)
80102233:	ff 75 08             	pushl  0x8(%ebp)
80102236:	e8 76 44 00 00       	call   801066b1 <strncmp>
8010223b:	83 c4 10             	add    $0x10,%esp
}
8010223e:	c9                   	leave  
8010223f:	c3                   	ret    

80102240 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;
  struct inode *ip;

  if(dp->type != T_DIR && !IS_DEV_DIR(dp))
80102246:	8b 45 08             	mov    0x8(%ebp),%eax
80102249:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010224d:	66 83 f8 01          	cmp    $0x1,%ax
80102251:	74 51                	je     801022a4 <dirlookup+0x64>
80102253:	8b 45 08             	mov    0x8(%ebp),%eax
80102256:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010225a:	66 83 f8 03          	cmp    $0x3,%ax
8010225e:	75 37                	jne    80102297 <dirlookup+0x57>
80102260:	8b 45 08             	mov    0x8(%ebp),%eax
80102263:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102267:	98                   	cwtl   
80102268:	c1 e0 04             	shl    $0x4,%eax
8010226b:	05 00 32 11 80       	add    $0x80113200,%eax
80102270:	8b 00                	mov    (%eax),%eax
80102272:	85 c0                	test   %eax,%eax
80102274:	74 21                	je     80102297 <dirlookup+0x57>
80102276:	8b 45 08             	mov    0x8(%ebp),%eax
80102279:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010227d:	98                   	cwtl   
8010227e:	c1 e0 04             	shl    $0x4,%eax
80102281:	05 00 32 11 80       	add    $0x80113200,%eax
80102286:	8b 00                	mov    (%eax),%eax
80102288:	83 ec 0c             	sub    $0xc,%esp
8010228b:	ff 75 08             	pushl  0x8(%ebp)
8010228e:	ff d0                	call   *%eax
80102290:	83 c4 10             	add    $0x10,%esp
80102293:	85 c0                	test   %eax,%eax
80102295:	75 0d                	jne    801022a4 <dirlookup+0x64>
    panic("dirlookup not DIR");
80102297:	83 ec 0c             	sub    $0xc,%esp
8010229a:	68 c3 9a 10 80       	push   $0x80109ac3
8010229f:	e8 53 e3 ff ff       	call   801005f7 <panic>

  for(off = 0; off < dp->size || dp->type == T_DEV; off += sizeof(de)){
801022a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022ab:	e9 f0 00 00 00       	jmp    801023a0 <dirlookup+0x160>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
801022b0:	6a 10                	push   $0x10
801022b2:	ff 75 f4             	pushl  -0xc(%ebp)
801022b5:	8d 45 dc             	lea    -0x24(%ebp),%eax
801022b8:	50                   	push   %eax
801022b9:	ff 75 08             	pushl  0x8(%ebp)
801022bc:	e8 78 fc ff ff       	call   80101f39 <readi>
801022c1:	83 c4 10             	add    $0x10,%esp
801022c4:	83 f8 10             	cmp    $0x10,%eax
801022c7:	74 24                	je     801022ed <dirlookup+0xad>
      if (dp->type == T_DEV)
801022c9:	8b 45 08             	mov    0x8(%ebp),%eax
801022cc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801022d0:	66 83 f8 03          	cmp    $0x3,%ax
801022d4:	75 0a                	jne    801022e0 <dirlookup+0xa0>
        return 0;
801022d6:	b8 00 00 00 00       	mov    $0x0,%eax
801022db:	e9 e5 00 00 00       	jmp    801023c5 <dirlookup+0x185>
      else
        panic("dirlink read");
801022e0:	83 ec 0c             	sub    $0xc,%esp
801022e3:	68 d5 9a 10 80       	push   $0x80109ad5
801022e8:	e8 0a e3 ff ff       	call   801005f7 <panic>
    }
    if(de.inum == 0)
801022ed:	0f b7 45 dc          	movzwl -0x24(%ebp),%eax
801022f1:	66 85 c0             	test   %ax,%ax
801022f4:	0f 84 a1 00 00 00    	je     8010239b <dirlookup+0x15b>
      continue;
    if(namecmp(name, de.name) == 0){
801022fa:	83 ec 08             	sub    $0x8,%esp
801022fd:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102300:	83 c0 02             	add    $0x2,%eax
80102303:	50                   	push   %eax
80102304:	ff 75 0c             	pushl  0xc(%ebp)
80102307:	e8 19 ff ff ff       	call   80102225 <namecmp>
8010230c:	83 c4 10             	add    $0x10,%esp
8010230f:	85 c0                	test   %eax,%eax
80102311:	0f 85 85 00 00 00    	jne    8010239c <dirlookup+0x15c>
      // entry matches path element
      if(poff)
80102317:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010231b:	74 08                	je     80102325 <dirlookup+0xe5>
        *poff = off;
8010231d:	8b 45 10             	mov    0x10(%ebp),%eax
80102320:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102323:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102325:	0f b7 45 dc          	movzwl -0x24(%ebp),%eax
80102329:	0f b7 c0             	movzwl %ax,%eax
8010232c:	89 45 f0             	mov    %eax,-0x10(%ebp)
      ip = iget(dp->dev, inum);
8010232f:	8b 45 08             	mov    0x8(%ebp),%eax
80102332:	8b 00                	mov    (%eax),%eax
80102334:	83 ec 08             	sub    $0x8,%esp
80102337:	ff 75 f0             	pushl  -0x10(%ebp)
8010233a:	50                   	push   %eax
8010233b:	e8 78 f5 ff ff       	call   801018b8 <iget>
80102340:	83 c4 10             	add    $0x10,%esp
80102343:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if (!(ip->flags & I_VALID) && dp->type == T_DEV && devsw[dp->major].iread) {
80102346:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102349:	8b 40 0c             	mov    0xc(%eax),%eax
8010234c:	83 e0 02             	and    $0x2,%eax
8010234f:	85 c0                	test   %eax,%eax
80102351:	75 43                	jne    80102396 <dirlookup+0x156>
80102353:	8b 45 08             	mov    0x8(%ebp),%eax
80102356:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010235a:	66 83 f8 03          	cmp    $0x3,%ax
8010235e:	75 36                	jne    80102396 <dirlookup+0x156>
80102360:	8b 45 08             	mov    0x8(%ebp),%eax
80102363:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102367:	98                   	cwtl   
80102368:	c1 e0 04             	shl    $0x4,%eax
8010236b:	05 04 32 11 80       	add    $0x80113204,%eax
80102370:	8b 00                	mov    (%eax),%eax
80102372:	85 c0                	test   %eax,%eax
80102374:	74 20                	je     80102396 <dirlookup+0x156>
        devsw[dp->major].iread(dp, ip);
80102376:	8b 45 08             	mov    0x8(%ebp),%eax
80102379:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010237d:	98                   	cwtl   
8010237e:	c1 e0 04             	shl    $0x4,%eax
80102381:	05 04 32 11 80       	add    $0x80113204,%eax
80102386:	8b 00                	mov    (%eax),%eax
80102388:	83 ec 08             	sub    $0x8,%esp
8010238b:	ff 75 ec             	pushl  -0x14(%ebp)
8010238e:	ff 75 08             	pushl  0x8(%ebp)
80102391:	ff d0                	call   *%eax
80102393:	83 c4 10             	add    $0x10,%esp
      }
      return ip;
80102396:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102399:	eb 2a                	jmp    801023c5 <dirlookup+0x185>
        return 0;
      else
        panic("dirlink read");
    }
    if(de.inum == 0)
      continue;
8010239b:	90                   	nop
  struct inode *ip;

  if(dp->type != T_DIR && !IS_DEV_DIR(dp))
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size || dp->type == T_DEV; off += sizeof(de)){
8010239c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801023a0:	8b 45 08             	mov    0x8(%ebp),%eax
801023a3:	8b 40 18             	mov    0x18(%eax),%eax
801023a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801023a9:	0f 87 01 ff ff ff    	ja     801022b0 <dirlookup+0x70>
801023af:	8b 45 08             	mov    0x8(%ebp),%eax
801023b2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023b6:	66 83 f8 03          	cmp    $0x3,%ax
801023ba:	0f 84 f0 fe ff ff    	je     801022b0 <dirlookup+0x70>
      }
      return ip;
    }
  }

  return 0;
801023c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023c5:	c9                   	leave  
801023c6:	c3                   	ret    

801023c7 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801023c7:	55                   	push   %ebp
801023c8:	89 e5                	mov    %esp,%ebp
801023ca:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801023cd:	83 ec 04             	sub    $0x4,%esp
801023d0:	6a 00                	push   $0x0
801023d2:	ff 75 0c             	pushl  0xc(%ebp)
801023d5:	ff 75 08             	pushl  0x8(%ebp)
801023d8:	e8 63 fe ff ff       	call   80102240 <dirlookup>
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023e7:	74 18                	je     80102401 <dirlink+0x3a>
    iput(ip);
801023e9:	83 ec 0c             	sub    $0xc,%esp
801023ec:	ff 75 f0             	pushl  -0x10(%ebp)
801023ef:	e8 a7 f7 ff ff       	call   80101b9b <iput>
801023f4:	83 c4 10             	add    $0x10,%esp
    return -1;
801023f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801023fc:	e9 9c 00 00 00       	jmp    8010249d <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102408:	eb 39                	jmp    80102443 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010240d:	6a 10                	push   $0x10
8010240f:	50                   	push   %eax
80102410:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102413:	50                   	push   %eax
80102414:	ff 75 08             	pushl  0x8(%ebp)
80102417:	e8 1d fb ff ff       	call   80101f39 <readi>
8010241c:	83 c4 10             	add    $0x10,%esp
8010241f:	83 f8 10             	cmp    $0x10,%eax
80102422:	74 0d                	je     80102431 <dirlink+0x6a>
      panic("dirlink read");
80102424:	83 ec 0c             	sub    $0xc,%esp
80102427:	68 d5 9a 10 80       	push   $0x80109ad5
8010242c:	e8 c6 e1 ff ff       	call   801005f7 <panic>
    if(de.inum == 0)
80102431:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102435:	66 85 c0             	test   %ax,%ax
80102438:	74 18                	je     80102452 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010243d:	83 c0 10             	add    $0x10,%eax
80102440:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102443:	8b 45 08             	mov    0x8(%ebp),%eax
80102446:	8b 50 18             	mov    0x18(%eax),%edx
80102449:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010244c:	39 c2                	cmp    %eax,%edx
8010244e:	77 ba                	ja     8010240a <dirlink+0x43>
80102450:	eb 01                	jmp    80102453 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
80102452:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102453:	83 ec 04             	sub    $0x4,%esp
80102456:	6a 0e                	push   $0xe
80102458:	ff 75 0c             	pushl  0xc(%ebp)
8010245b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010245e:	83 c0 02             	add    $0x2,%eax
80102461:	50                   	push   %eax
80102462:	e8 a0 42 00 00       	call   80106707 <strncpy>
80102467:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
8010246a:	8b 45 10             	mov    0x10(%ebp),%eax
8010246d:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102471:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102474:	6a 10                	push   $0x10
80102476:	50                   	push   %eax
80102477:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010247a:	50                   	push   %eax
8010247b:	ff 75 08             	pushl  0x8(%ebp)
8010247e:	e8 14 fc ff ff       	call   80102097 <writei>
80102483:	83 c4 10             	add    $0x10,%esp
80102486:	83 f8 10             	cmp    $0x10,%eax
80102489:	74 0d                	je     80102498 <dirlink+0xd1>
    panic("dirlink");
8010248b:	83 ec 0c             	sub    $0xc,%esp
8010248e:	68 e2 9a 10 80       	push   $0x80109ae2
80102493:	e8 5f e1 ff ff       	call   801005f7 <panic>

  return 0;
80102498:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010249d:	c9                   	leave  
8010249e:	c3                   	ret    

8010249f <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010249f:	55                   	push   %ebp
801024a0:	89 e5                	mov    %esp,%ebp
801024a2:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
801024a5:	eb 04                	jmp    801024ab <skipelem+0xc>
    path++;
801024a7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801024ab:	8b 45 08             	mov    0x8(%ebp),%eax
801024ae:	0f b6 00             	movzbl (%eax),%eax
801024b1:	3c 2f                	cmp    $0x2f,%al
801024b3:	74 f2                	je     801024a7 <skipelem+0x8>
    path++;
  if(*path == 0)
801024b5:	8b 45 08             	mov    0x8(%ebp),%eax
801024b8:	0f b6 00             	movzbl (%eax),%eax
801024bb:	84 c0                	test   %al,%al
801024bd:	75 07                	jne    801024c6 <skipelem+0x27>
    return 0;
801024bf:	b8 00 00 00 00       	mov    $0x0,%eax
801024c4:	eb 7b                	jmp    80102541 <skipelem+0xa2>
  s = path;
801024c6:	8b 45 08             	mov    0x8(%ebp),%eax
801024c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801024cc:	eb 04                	jmp    801024d2 <skipelem+0x33>
    path++;
801024ce:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801024d2:	8b 45 08             	mov    0x8(%ebp),%eax
801024d5:	0f b6 00             	movzbl (%eax),%eax
801024d8:	3c 2f                	cmp    $0x2f,%al
801024da:	74 0a                	je     801024e6 <skipelem+0x47>
801024dc:	8b 45 08             	mov    0x8(%ebp),%eax
801024df:	0f b6 00             	movzbl (%eax),%eax
801024e2:	84 c0                	test   %al,%al
801024e4:	75 e8                	jne    801024ce <skipelem+0x2f>
    path++;
  len = path - s;
801024e6:	8b 55 08             	mov    0x8(%ebp),%edx
801024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024ec:	29 c2                	sub    %eax,%edx
801024ee:	89 d0                	mov    %edx,%eax
801024f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801024f3:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801024f7:	7e 15                	jle    8010250e <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
801024f9:	83 ec 04             	sub    $0x4,%esp
801024fc:	6a 0e                	push   $0xe
801024fe:	ff 75 f4             	pushl  -0xc(%ebp)
80102501:	ff 75 0c             	pushl  0xc(%ebp)
80102504:	e8 12 41 00 00       	call   8010661b <memmove>
80102509:	83 c4 10             	add    $0x10,%esp
8010250c:	eb 26                	jmp    80102534 <skipelem+0x95>
  else {
    memmove(name, s, len);
8010250e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102511:	83 ec 04             	sub    $0x4,%esp
80102514:	50                   	push   %eax
80102515:	ff 75 f4             	pushl  -0xc(%ebp)
80102518:	ff 75 0c             	pushl  0xc(%ebp)
8010251b:	e8 fb 40 00 00       	call   8010661b <memmove>
80102520:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102523:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102526:	8b 45 0c             	mov    0xc(%ebp),%eax
80102529:	01 d0                	add    %edx,%eax
8010252b:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010252e:	eb 04                	jmp    80102534 <skipelem+0x95>
    path++;
80102530:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102534:	8b 45 08             	mov    0x8(%ebp),%eax
80102537:	0f b6 00             	movzbl (%eax),%eax
8010253a:	3c 2f                	cmp    $0x2f,%al
8010253c:	74 f2                	je     80102530 <skipelem+0x91>
    path++;
  return path;
8010253e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102541:	c9                   	leave  
80102542:	c3                   	ret    

80102543 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102543:	55                   	push   %ebp
80102544:	89 e5                	mov    %esp,%ebp
80102546:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102549:	8b 45 08             	mov    0x8(%ebp),%eax
8010254c:	0f b6 00             	movzbl (%eax),%eax
8010254f:	3c 2f                	cmp    $0x2f,%al
80102551:	75 17                	jne    8010256a <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
80102553:	83 ec 08             	sub    $0x8,%esp
80102556:	6a 01                	push   $0x1
80102558:	6a 01                	push   $0x1
8010255a:	e8 59 f3 ff ff       	call   801018b8 <iget>
8010255f:	83 c4 10             	add    $0x10,%esp
80102562:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102565:	e9 ff 00 00 00       	jmp    80102669 <namex+0x126>
  else
    ip = idup(proc->cwd);
8010256a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102570:	8b 40 68             	mov    0x68(%eax),%eax
80102573:	83 ec 0c             	sub    $0xc,%esp
80102576:	50                   	push   %eax
80102577:	e8 1b f4 ff ff       	call   80101997 <idup>
8010257c:	83 c4 10             	add    $0x10,%esp
8010257f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102582:	e9 e2 00 00 00       	jmp    80102669 <namex+0x126>
    ilock(ip);
80102587:	83 ec 0c             	sub    $0xc,%esp
8010258a:	ff 75 f4             	pushl  -0xc(%ebp)
8010258d:	e8 3f f4 ff ff       	call   801019d1 <ilock>
80102592:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR && !IS_DEV_DIR(ip)){
80102595:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102598:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010259c:	66 83 f8 01          	cmp    $0x1,%ax
801025a0:	74 5c                	je     801025fe <namex+0xbb>
801025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025a5:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801025a9:	66 83 f8 03          	cmp    $0x3,%ax
801025ad:	75 37                	jne    801025e6 <namex+0xa3>
801025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025b2:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801025b6:	98                   	cwtl   
801025b7:	c1 e0 04             	shl    $0x4,%eax
801025ba:	05 00 32 11 80       	add    $0x80113200,%eax
801025bf:	8b 00                	mov    (%eax),%eax
801025c1:	85 c0                	test   %eax,%eax
801025c3:	74 21                	je     801025e6 <namex+0xa3>
801025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025c8:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801025cc:	98                   	cwtl   
801025cd:	c1 e0 04             	shl    $0x4,%eax
801025d0:	05 00 32 11 80       	add    $0x80113200,%eax
801025d5:	8b 00                	mov    (%eax),%eax
801025d7:	83 ec 0c             	sub    $0xc,%esp
801025da:	ff 75 f4             	pushl  -0xc(%ebp)
801025dd:	ff d0                	call   *%eax
801025df:	83 c4 10             	add    $0x10,%esp
801025e2:	85 c0                	test   %eax,%eax
801025e4:	75 18                	jne    801025fe <namex+0xbb>
      iunlockput(ip);
801025e6:	83 ec 0c             	sub    $0xc,%esp
801025e9:	ff 75 f4             	pushl  -0xc(%ebp)
801025ec:	e8 9a f6 ff ff       	call   80101c8b <iunlockput>
801025f1:	83 c4 10             	add    $0x10,%esp
      return 0;
801025f4:	b8 00 00 00 00       	mov    $0x0,%eax
801025f9:	e9 a7 00 00 00       	jmp    801026a5 <namex+0x162>
    }
    if(nameiparent && *path == '\0'){
801025fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102602:	74 20                	je     80102624 <namex+0xe1>
80102604:	8b 45 08             	mov    0x8(%ebp),%eax
80102607:	0f b6 00             	movzbl (%eax),%eax
8010260a:	84 c0                	test   %al,%al
8010260c:	75 16                	jne    80102624 <namex+0xe1>
      // Stop one level early.
      iunlock(ip);
8010260e:	83 ec 0c             	sub    $0xc,%esp
80102611:	ff 75 f4             	pushl  -0xc(%ebp)
80102614:	e8 10 f5 ff ff       	call   80101b29 <iunlock>
80102619:	83 c4 10             	add    $0x10,%esp
      return ip;
8010261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010261f:	e9 81 00 00 00       	jmp    801026a5 <namex+0x162>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102624:	83 ec 04             	sub    $0x4,%esp
80102627:	6a 00                	push   $0x0
80102629:	ff 75 10             	pushl  0x10(%ebp)
8010262c:	ff 75 f4             	pushl  -0xc(%ebp)
8010262f:	e8 0c fc ff ff       	call   80102240 <dirlookup>
80102634:	83 c4 10             	add    $0x10,%esp
80102637:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010263a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010263e:	75 15                	jne    80102655 <namex+0x112>
      iunlockput(ip);
80102640:	83 ec 0c             	sub    $0xc,%esp
80102643:	ff 75 f4             	pushl  -0xc(%ebp)
80102646:	e8 40 f6 ff ff       	call   80101c8b <iunlockput>
8010264b:	83 c4 10             	add    $0x10,%esp
      return 0;
8010264e:	b8 00 00 00 00       	mov    $0x0,%eax
80102653:	eb 50                	jmp    801026a5 <namex+0x162>
    }
    iunlockput(ip);
80102655:	83 ec 0c             	sub    $0xc,%esp
80102658:	ff 75 f4             	pushl  -0xc(%ebp)
8010265b:	e8 2b f6 ff ff       	call   80101c8b <iunlockput>
80102660:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102663:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102666:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102669:	83 ec 08             	sub    $0x8,%esp
8010266c:	ff 75 10             	pushl  0x10(%ebp)
8010266f:	ff 75 08             	pushl  0x8(%ebp)
80102672:	e8 28 fe ff ff       	call   8010249f <skipelem>
80102677:	83 c4 10             	add    $0x10,%esp
8010267a:	89 45 08             	mov    %eax,0x8(%ebp)
8010267d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102681:	0f 85 00 ff ff ff    	jne    80102587 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102687:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010268b:	74 15                	je     801026a2 <namex+0x15f>
    iput(ip);
8010268d:	83 ec 0c             	sub    $0xc,%esp
80102690:	ff 75 f4             	pushl  -0xc(%ebp)
80102693:	e8 03 f5 ff ff       	call   80101b9b <iput>
80102698:	83 c4 10             	add    $0x10,%esp
    return 0;
8010269b:	b8 00 00 00 00       	mov    $0x0,%eax
801026a0:	eb 03                	jmp    801026a5 <namex+0x162>
  }
  return ip;
801026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801026a5:	c9                   	leave  
801026a6:	c3                   	ret    

801026a7 <namei>:

struct inode*
namei(char *path)
{
801026a7:	55                   	push   %ebp
801026a8:	89 e5                	mov    %esp,%ebp
801026aa:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801026ad:	83 ec 04             	sub    $0x4,%esp
801026b0:	8d 45 ea             	lea    -0x16(%ebp),%eax
801026b3:	50                   	push   %eax
801026b4:	6a 00                	push   $0x0
801026b6:	ff 75 08             	pushl  0x8(%ebp)
801026b9:	e8 85 fe ff ff       	call   80102543 <namex>
801026be:	83 c4 10             	add    $0x10,%esp
}
801026c1:	c9                   	leave  
801026c2:	c3                   	ret    

801026c3 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801026c3:	55                   	push   %ebp
801026c4:	89 e5                	mov    %esp,%ebp
801026c6:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801026c9:	83 ec 04             	sub    $0x4,%esp
801026cc:	ff 75 0c             	pushl  0xc(%ebp)
801026cf:	6a 01                	push   $0x1
801026d1:	ff 75 08             	pushl  0x8(%ebp)
801026d4:	e8 6a fe ff ff       	call   80102543 <namex>
801026d9:	83 c4 10             	add    $0x10,%esp
}
801026dc:	c9                   	leave  
801026dd:	c3                   	ret    

801026de <get_number_of_free_inode>:


// Assignment 4 - adding code here
int get_number_of_free_inode(){
801026de:	55                   	push   %ebp
801026df:	89 e5                	mov    %esp,%ebp
801026e1:	83 ec 18             	sub    $0x18,%esp
  int number_of_free_inode = 0;
801026e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  struct inode *ip;
  acquire(&icache.lock);
801026eb:	83 ec 0c             	sub    $0xc,%esp
801026ee:	68 a0 32 11 80       	push   $0x801132a0
801026f3:	e8 01 3c 00 00       	call   801062f9 <acquire>
801026f8:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801026fb:	c7 45 f0 d4 32 11 80 	movl   $0x801132d4,-0x10(%ebp)
80102702:	eb 12                	jmp    80102716 <get_number_of_free_inode+0x38>
    // need to check if to change to ref
    if(ip->flags == 0){
80102704:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102707:	8b 40 0c             	mov    0xc(%eax),%eax
8010270a:	85 c0                	test   %eax,%eax
8010270c:	75 04                	jne    80102712 <get_number_of_free_inode+0x34>
      number_of_free_inode++;
8010270e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
// Assignment 4 - adding code here
int get_number_of_free_inode(){
  int number_of_free_inode = 0;
  struct inode *ip;
  acquire(&icache.lock);
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102712:	83 45 f0 50          	addl   $0x50,-0x10(%ebp)
80102716:	81 7d f0 74 42 11 80 	cmpl   $0x80114274,-0x10(%ebp)
8010271d:	72 e5                	jb     80102704 <get_number_of_free_inode+0x26>
    // need to check if to change to ref
    if(ip->flags == 0){
      number_of_free_inode++;
    }
  }
  release(&icache.lock);
8010271f:	83 ec 0c             	sub    $0xc,%esp
80102722:	68 a0 32 11 80       	push   $0x801132a0
80102727:	e8 34 3c 00 00       	call   80106360 <release>
8010272c:	83 c4 10             	add    $0x10,%esp
  return number_of_free_inode;
8010272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102732:	c9                   	leave  
80102733:	c3                   	ret    

80102734 <number_of_valid_inode>:


int number_of_valid_inode(){
80102734:	55                   	push   %ebp
80102735:	89 e5                	mov    %esp,%ebp
80102737:	83 ec 18             	sub    $0x18,%esp
  int number_of_valid_inode = 0;
8010273a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  struct inode *ip;
  acquire(&icache.lock);
80102741:	83 ec 0c             	sub    $0xc,%esp
80102744:	68 a0 32 11 80       	push   $0x801132a0
80102749:	e8 ab 3b 00 00       	call   801062f9 <acquire>
8010274e:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102751:	c7 45 f0 d4 32 11 80 	movl   $0x801132d4,-0x10(%ebp)
80102758:	eb 15                	jmp    8010276f <number_of_valid_inode+0x3b>
    if(ip->flags & I_VALID){
8010275a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010275d:	8b 40 0c             	mov    0xc(%eax),%eax
80102760:	83 e0 02             	and    $0x2,%eax
80102763:	85 c0                	test   %eax,%eax
80102765:	74 04                	je     8010276b <number_of_valid_inode+0x37>
      number_of_valid_inode++;
80102767:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

int number_of_valid_inode(){
  int number_of_valid_inode = 0;
  struct inode *ip;
  acquire(&icache.lock);
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010276b:	83 45 f0 50          	addl   $0x50,-0x10(%ebp)
8010276f:	81 7d f0 74 42 11 80 	cmpl   $0x80114274,-0x10(%ebp)
80102776:	72 e2                	jb     8010275a <number_of_valid_inode+0x26>
    if(ip->flags & I_VALID){
      number_of_valid_inode++;
    }
  }
  release(&icache.lock);
80102778:	83 ec 0c             	sub    $0xc,%esp
8010277b:	68 a0 32 11 80       	push   $0x801132a0
80102780:	e8 db 3b 00 00       	call   80106360 <release>
80102785:	83 c4 10             	add    $0x10,%esp
  return number_of_valid_inode;
80102788:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010278b:	c9                   	leave  
8010278c:	c3                   	ret    

8010278d <get_number_of_ref>:

int get_number_of_ref(){
8010278d:	55                   	push   %ebp
8010278e:	89 e5                	mov    %esp,%ebp
80102790:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  int number_of_ref = 0;
80102793:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  acquire(&icache.lock);
8010279a:	83 ec 0c             	sub    $0xc,%esp
8010279d:	68 a0 32 11 80       	push   $0x801132a0
801027a2:	e8 52 3b 00 00       	call   801062f9 <acquire>
801027a7:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801027aa:	c7 45 f4 d4 32 11 80 	movl   $0x801132d4,-0xc(%ebp)
801027b1:	eb 0d                	jmp    801027c0 <get_number_of_ref+0x33>
      number_of_ref += ip->ref;
801027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027b6:	8b 40 08             	mov    0x8(%eax),%eax
801027b9:	01 45 f0             	add    %eax,-0x10(%ebp)

int get_number_of_ref(){
  struct inode *ip;
  int number_of_ref = 0;
  acquire(&icache.lock);
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801027bc:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801027c0:	81 7d f4 74 42 11 80 	cmpl   $0x80114274,-0xc(%ebp)
801027c7:	72 ea                	jb     801027b3 <get_number_of_ref+0x26>
      number_of_ref += ip->ref;
  }
  release(&icache.lock);
801027c9:	83 ec 0c             	sub    $0xc,%esp
801027cc:	68 a0 32 11 80       	push   $0x801132a0
801027d1:	e8 8a 3b 00 00       	call   80106360 <release>
801027d6:	83 c4 10             	add    $0x10,%esp
  return number_of_ref;
801027d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801027dc:	c9                   	leave  
801027dd:	c3                   	ret    

801027de <get_number_of_active_inode>:

int get_number_of_active_inode(){
801027de:	55                   	push   %ebp
801027df:	89 e5                	mov    %esp,%ebp
801027e1:	83 ec 08             	sub    $0x8,%esp
  return NINODE - get_number_of_free_inode();
801027e4:	e8 f5 fe ff ff       	call   801026de <get_number_of_free_inode>
801027e9:	ba 32 00 00 00       	mov    $0x32,%edx
801027ee:	29 c2                	sub    %eax,%edx
801027f0:	89 d0                	mov    %edx,%eax
}
801027f2:	c9                   	leave  
801027f3:	c3                   	ret    

801027f4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801027f4:	55                   	push   %ebp
801027f5:	89 e5                	mov    %esp,%ebp
801027f7:	83 ec 14             	sub    $0x14,%esp
801027fa:	8b 45 08             	mov    0x8(%ebp),%eax
801027fd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102801:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102805:	89 c2                	mov    %eax,%edx
80102807:	ec                   	in     (%dx),%al
80102808:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010280b:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010280f:	c9                   	leave  
80102810:	c3                   	ret    

80102811 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102811:	55                   	push   %ebp
80102812:	89 e5                	mov    %esp,%ebp
80102814:	57                   	push   %edi
80102815:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102816:	8b 55 08             	mov    0x8(%ebp),%edx
80102819:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010281c:	8b 45 10             	mov    0x10(%ebp),%eax
8010281f:	89 cb                	mov    %ecx,%ebx
80102821:	89 df                	mov    %ebx,%edi
80102823:	89 c1                	mov    %eax,%ecx
80102825:	fc                   	cld    
80102826:	f3 6d                	rep insl (%dx),%es:(%edi)
80102828:	89 c8                	mov    %ecx,%eax
8010282a:	89 fb                	mov    %edi,%ebx
8010282c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010282f:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102832:	90                   	nop
80102833:	5b                   	pop    %ebx
80102834:	5f                   	pop    %edi
80102835:	5d                   	pop    %ebp
80102836:	c3                   	ret    

80102837 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102837:	55                   	push   %ebp
80102838:	89 e5                	mov    %esp,%ebp
8010283a:	83 ec 08             	sub    $0x8,%esp
8010283d:	8b 55 08             	mov    0x8(%ebp),%edx
80102840:	8b 45 0c             	mov    0xc(%ebp),%eax
80102843:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102847:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010284a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010284e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102852:	ee                   	out    %al,(%dx)
}
80102853:	90                   	nop
80102854:	c9                   	leave  
80102855:	c3                   	ret    

80102856 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102856:	55                   	push   %ebp
80102857:	89 e5                	mov    %esp,%ebp
80102859:	56                   	push   %esi
8010285a:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
8010285b:	8b 55 08             	mov    0x8(%ebp),%edx
8010285e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102861:	8b 45 10             	mov    0x10(%ebp),%eax
80102864:	89 cb                	mov    %ecx,%ebx
80102866:	89 de                	mov    %ebx,%esi
80102868:	89 c1                	mov    %eax,%ecx
8010286a:	fc                   	cld    
8010286b:	f3 6f                	rep outsl %ds:(%esi),(%dx)
8010286d:	89 c8                	mov    %ecx,%eax
8010286f:	89 f3                	mov    %esi,%ebx
80102871:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102874:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102877:	90                   	nop
80102878:	5b                   	pop    %ebx
80102879:	5e                   	pop    %esi
8010287a:	5d                   	pop    %ebp
8010287b:	c3                   	ret    

8010287c <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
8010287c:	55                   	push   %ebp
8010287d:	89 e5                	mov    %esp,%ebp
8010287f:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102882:	90                   	nop
80102883:	68 f7 01 00 00       	push   $0x1f7
80102888:	e8 67 ff ff ff       	call   801027f4 <inb>
8010288d:	83 c4 04             	add    $0x4,%esp
80102890:	0f b6 c0             	movzbl %al,%eax
80102893:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102896:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102899:	25 c0 00 00 00       	and    $0xc0,%eax
8010289e:	83 f8 40             	cmp    $0x40,%eax
801028a1:	75 e0                	jne    80102883 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801028a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801028a7:	74 11                	je     801028ba <idewait+0x3e>
801028a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801028ac:	83 e0 21             	and    $0x21,%eax
801028af:	85 c0                	test   %eax,%eax
801028b1:	74 07                	je     801028ba <idewait+0x3e>
    return -1;
801028b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801028b8:	eb 05                	jmp    801028bf <idewait+0x43>
  return 0;
801028ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
801028bf:	c9                   	leave  
801028c0:	c3                   	ret    

801028c1 <ideinit>:

void
ideinit(void)
{
801028c1:	55                   	push   %ebp
801028c2:	89 e5                	mov    %esp,%ebp
801028c4:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
801028c7:	83 ec 08             	sub    $0x8,%esp
801028ca:	68 ea 9a 10 80       	push   $0x80109aea
801028cf:	68 00 d6 10 80       	push   $0x8010d600
801028d4:	e8 fe 39 00 00       	call   801062d7 <initlock>
801028d9:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801028dc:	83 ec 0c             	sub    $0xc,%esp
801028df:	6a 0e                	push   $0xe
801028e1:	e8 b0 18 00 00       	call   80104196 <picenable>
801028e6:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801028e9:	a1 a0 49 11 80       	mov    0x801149a0,%eax
801028ee:	83 e8 01             	sub    $0x1,%eax
801028f1:	83 ec 08             	sub    $0x8,%esp
801028f4:	50                   	push   %eax
801028f5:	6a 0e                	push   $0xe
801028f7:	e8 37 04 00 00       	call   80102d33 <ioapicenable>
801028fc:	83 c4 10             	add    $0x10,%esp
  idewait(0);
801028ff:	83 ec 0c             	sub    $0xc,%esp
80102902:	6a 00                	push   $0x0
80102904:	e8 73 ff ff ff       	call   8010287c <idewait>
80102909:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010290c:	83 ec 08             	sub    $0x8,%esp
8010290f:	68 f0 00 00 00       	push   $0xf0
80102914:	68 f6 01 00 00       	push   $0x1f6
80102919:	e8 19 ff ff ff       	call   80102837 <outb>
8010291e:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102921:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102928:	eb 24                	jmp    8010294e <ideinit+0x8d>
    if(inb(0x1f7) != 0){
8010292a:	83 ec 0c             	sub    $0xc,%esp
8010292d:	68 f7 01 00 00       	push   $0x1f7
80102932:	e8 bd fe ff ff       	call   801027f4 <inb>
80102937:	83 c4 10             	add    $0x10,%esp
8010293a:	84 c0                	test   %al,%al
8010293c:	74 0c                	je     8010294a <ideinit+0x89>
      havedisk1 = 1;
8010293e:	c7 05 38 d6 10 80 01 	movl   $0x1,0x8010d638
80102945:	00 00 00 
      break;
80102948:	eb 0d                	jmp    80102957 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010294a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010294e:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102955:	7e d3                	jle    8010292a <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102957:	83 ec 08             	sub    $0x8,%esp
8010295a:	68 e0 00 00 00       	push   $0xe0
8010295f:	68 f6 01 00 00       	push   $0x1f6
80102964:	e8 ce fe ff ff       	call   80102837 <outb>
80102969:	83 c4 10             	add    $0x10,%esp
}
8010296c:	90                   	nop
8010296d:	c9                   	leave  
8010296e:	c3                   	ret    

8010296f <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010296f:	55                   	push   %ebp
80102970:	89 e5                	mov    %esp,%ebp
80102972:	83 ec 08             	sub    $0x8,%esp
  if(b == 0)
80102975:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102979:	75 0d                	jne    80102988 <idestart+0x19>
    panic("idestart");
8010297b:	83 ec 0c             	sub    $0xc,%esp
8010297e:	68 ee 9a 10 80       	push   $0x80109aee
80102983:	e8 6f dc ff ff       	call   801005f7 <panic>

  idewait(0);
80102988:	83 ec 0c             	sub    $0xc,%esp
8010298b:	6a 00                	push   $0x0
8010298d:	e8 ea fe ff ff       	call   8010287c <idewait>
80102992:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102995:	83 ec 08             	sub    $0x8,%esp
80102998:	6a 00                	push   $0x0
8010299a:	68 f6 03 00 00       	push   $0x3f6
8010299f:	e8 93 fe ff ff       	call   80102837 <outb>
801029a4:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, 1);  // number of sectors
801029a7:	83 ec 08             	sub    $0x8,%esp
801029aa:	6a 01                	push   $0x1
801029ac:	68 f2 01 00 00       	push   $0x1f2
801029b1:	e8 81 fe ff ff       	call   80102837 <outb>
801029b6:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, b->sector & 0xff);
801029b9:	8b 45 08             	mov    0x8(%ebp),%eax
801029bc:	8b 40 08             	mov    0x8(%eax),%eax
801029bf:	0f b6 c0             	movzbl %al,%eax
801029c2:	83 ec 08             	sub    $0x8,%esp
801029c5:	50                   	push   %eax
801029c6:	68 f3 01 00 00       	push   $0x1f3
801029cb:	e8 67 fe ff ff       	call   80102837 <outb>
801029d0:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (b->sector >> 8) & 0xff);
801029d3:	8b 45 08             	mov    0x8(%ebp),%eax
801029d6:	8b 40 08             	mov    0x8(%eax),%eax
801029d9:	c1 e8 08             	shr    $0x8,%eax
801029dc:	0f b6 c0             	movzbl %al,%eax
801029df:	83 ec 08             	sub    $0x8,%esp
801029e2:	50                   	push   %eax
801029e3:	68 f4 01 00 00       	push   $0x1f4
801029e8:	e8 4a fe ff ff       	call   80102837 <outb>
801029ed:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (b->sector >> 16) & 0xff);
801029f0:	8b 45 08             	mov    0x8(%ebp),%eax
801029f3:	8b 40 08             	mov    0x8(%eax),%eax
801029f6:	c1 e8 10             	shr    $0x10,%eax
801029f9:	0f b6 c0             	movzbl %al,%eax
801029fc:	83 ec 08             	sub    $0x8,%esp
801029ff:	50                   	push   %eax
80102a00:	68 f5 01 00 00       	push   $0x1f5
80102a05:	e8 2d fe ff ff       	call   80102837 <outb>
80102a0a:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102a0d:	8b 45 08             	mov    0x8(%ebp),%eax
80102a10:	8b 40 04             	mov    0x4(%eax),%eax
80102a13:	83 e0 01             	and    $0x1,%eax
80102a16:	c1 e0 04             	shl    $0x4,%eax
80102a19:	89 c2                	mov    %eax,%edx
80102a1b:	8b 45 08             	mov    0x8(%ebp),%eax
80102a1e:	8b 40 08             	mov    0x8(%eax),%eax
80102a21:	c1 e8 18             	shr    $0x18,%eax
80102a24:	83 e0 0f             	and    $0xf,%eax
80102a27:	09 d0                	or     %edx,%eax
80102a29:	83 c8 e0             	or     $0xffffffe0,%eax
80102a2c:	0f b6 c0             	movzbl %al,%eax
80102a2f:	83 ec 08             	sub    $0x8,%esp
80102a32:	50                   	push   %eax
80102a33:	68 f6 01 00 00       	push   $0x1f6
80102a38:	e8 fa fd ff ff       	call   80102837 <outb>
80102a3d:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102a40:	8b 45 08             	mov    0x8(%ebp),%eax
80102a43:	8b 00                	mov    (%eax),%eax
80102a45:	83 e0 04             	and    $0x4,%eax
80102a48:	85 c0                	test   %eax,%eax
80102a4a:	74 30                	je     80102a7c <idestart+0x10d>
    outb(0x1f7, IDE_CMD_WRITE);
80102a4c:	83 ec 08             	sub    $0x8,%esp
80102a4f:	6a 30                	push   $0x30
80102a51:	68 f7 01 00 00       	push   $0x1f7
80102a56:	e8 dc fd ff ff       	call   80102837 <outb>
80102a5b:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, 512/4);
80102a5e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a61:	83 c0 18             	add    $0x18,%eax
80102a64:	83 ec 04             	sub    $0x4,%esp
80102a67:	68 80 00 00 00       	push   $0x80
80102a6c:	50                   	push   %eax
80102a6d:	68 f0 01 00 00       	push   $0x1f0
80102a72:	e8 df fd ff ff       	call   80102856 <outsl>
80102a77:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102a7a:	eb 12                	jmp    80102a8e <idestart+0x11f>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, 512/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102a7c:	83 ec 08             	sub    $0x8,%esp
80102a7f:	6a 20                	push   $0x20
80102a81:	68 f7 01 00 00       	push   $0x1f7
80102a86:	e8 ac fd ff ff       	call   80102837 <outb>
80102a8b:	83 c4 10             	add    $0x10,%esp
  }
}
80102a8e:	90                   	nop
80102a8f:	c9                   	leave  
80102a90:	c3                   	ret    

80102a91 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102a91:	55                   	push   %ebp
80102a92:	89 e5                	mov    %esp,%ebp
80102a94:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102a97:	83 ec 0c             	sub    $0xc,%esp
80102a9a:	68 00 d6 10 80       	push   $0x8010d600
80102a9f:	e8 55 38 00 00       	call   801062f9 <acquire>
80102aa4:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102aa7:	a1 34 d6 10 80       	mov    0x8010d634,%eax
80102aac:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102aaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102ab3:	75 15                	jne    80102aca <ideintr+0x39>
    release(&idelock);
80102ab5:	83 ec 0c             	sub    $0xc,%esp
80102ab8:	68 00 d6 10 80       	push   $0x8010d600
80102abd:	e8 9e 38 00 00       	call   80106360 <release>
80102ac2:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102ac5:	e9 9a 00 00 00       	jmp    80102b64 <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102acd:	8b 40 14             	mov    0x14(%eax),%eax
80102ad0:	a3 34 d6 10 80       	mov    %eax,0x8010d634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad8:	8b 00                	mov    (%eax),%eax
80102ada:	83 e0 04             	and    $0x4,%eax
80102add:	85 c0                	test   %eax,%eax
80102adf:	75 2d                	jne    80102b0e <ideintr+0x7d>
80102ae1:	83 ec 0c             	sub    $0xc,%esp
80102ae4:	6a 01                	push   $0x1
80102ae6:	e8 91 fd ff ff       	call   8010287c <idewait>
80102aeb:	83 c4 10             	add    $0x10,%esp
80102aee:	85 c0                	test   %eax,%eax
80102af0:	78 1c                	js     80102b0e <ideintr+0x7d>
    insl(0x1f0, b->data, 512/4);
80102af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102af5:	83 c0 18             	add    $0x18,%eax
80102af8:	83 ec 04             	sub    $0x4,%esp
80102afb:	68 80 00 00 00       	push   $0x80
80102b00:	50                   	push   %eax
80102b01:	68 f0 01 00 00       	push   $0x1f0
80102b06:	e8 06 fd ff ff       	call   80102811 <insl>
80102b0b:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b11:	8b 00                	mov    (%eax),%eax
80102b13:	83 c8 02             	or     $0x2,%eax
80102b16:	89 c2                	mov    %eax,%edx
80102b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b1b:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b20:	8b 00                	mov    (%eax),%eax
80102b22:	83 e0 fb             	and    $0xfffffffb,%eax
80102b25:	89 c2                	mov    %eax,%edx
80102b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b2a:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102b2c:	83 ec 0c             	sub    $0xc,%esp
80102b2f:	ff 75 f4             	pushl  -0xc(%ebp)
80102b32:	e8 10 25 00 00       	call   80105047 <wakeup>
80102b37:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102b3a:	a1 34 d6 10 80       	mov    0x8010d634,%eax
80102b3f:	85 c0                	test   %eax,%eax
80102b41:	74 11                	je     80102b54 <ideintr+0xc3>
    idestart(idequeue);
80102b43:	a1 34 d6 10 80       	mov    0x8010d634,%eax
80102b48:	83 ec 0c             	sub    $0xc,%esp
80102b4b:	50                   	push   %eax
80102b4c:	e8 1e fe ff ff       	call   8010296f <idestart>
80102b51:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102b54:	83 ec 0c             	sub    $0xc,%esp
80102b57:	68 00 d6 10 80       	push   $0x8010d600
80102b5c:	e8 ff 37 00 00       	call   80106360 <release>
80102b61:	83 c4 10             	add    $0x10,%esp
}
80102b64:	c9                   	leave  
80102b65:	c3                   	ret    

80102b66 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102b66:	55                   	push   %ebp
80102b67:	89 e5                	mov    %esp,%ebp
80102b69:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102b6c:	8b 45 08             	mov    0x8(%ebp),%eax
80102b6f:	8b 00                	mov    (%eax),%eax
80102b71:	83 e0 01             	and    $0x1,%eax
80102b74:	85 c0                	test   %eax,%eax
80102b76:	75 0d                	jne    80102b85 <iderw+0x1f>
    panic("iderw: buf not busy");
80102b78:	83 ec 0c             	sub    $0xc,%esp
80102b7b:	68 f7 9a 10 80       	push   $0x80109af7
80102b80:	e8 72 da ff ff       	call   801005f7 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102b85:	8b 45 08             	mov    0x8(%ebp),%eax
80102b88:	8b 00                	mov    (%eax),%eax
80102b8a:	83 e0 06             	and    $0x6,%eax
80102b8d:	83 f8 02             	cmp    $0x2,%eax
80102b90:	75 0d                	jne    80102b9f <iderw+0x39>
    panic("iderw: nothing to do");
80102b92:	83 ec 0c             	sub    $0xc,%esp
80102b95:	68 0b 9b 10 80       	push   $0x80109b0b
80102b9a:	e8 58 da ff ff       	call   801005f7 <panic>
  if(b->dev != 0 && !havedisk1)
80102b9f:	8b 45 08             	mov    0x8(%ebp),%eax
80102ba2:	8b 40 04             	mov    0x4(%eax),%eax
80102ba5:	85 c0                	test   %eax,%eax
80102ba7:	74 16                	je     80102bbf <iderw+0x59>
80102ba9:	a1 38 d6 10 80       	mov    0x8010d638,%eax
80102bae:	85 c0                	test   %eax,%eax
80102bb0:	75 0d                	jne    80102bbf <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102bb2:	83 ec 0c             	sub    $0xc,%esp
80102bb5:	68 20 9b 10 80       	push   $0x80109b20
80102bba:	e8 38 da ff ff       	call   801005f7 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102bbf:	83 ec 0c             	sub    $0xc,%esp
80102bc2:	68 00 d6 10 80       	push   $0x8010d600
80102bc7:	e8 2d 37 00 00       	call   801062f9 <acquire>
80102bcc:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102bcf:	8b 45 08             	mov    0x8(%ebp),%eax
80102bd2:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102bd9:	c7 45 f4 34 d6 10 80 	movl   $0x8010d634,-0xc(%ebp)
80102be0:	eb 0b                	jmp    80102bed <iderw+0x87>
80102be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102be5:	8b 00                	mov    (%eax),%eax
80102be7:	83 c0 14             	add    $0x14,%eax
80102bea:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bf0:	8b 00                	mov    (%eax),%eax
80102bf2:	85 c0                	test   %eax,%eax
80102bf4:	75 ec                	jne    80102be2 <iderw+0x7c>
    ;
  *pp = b;
80102bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bf9:	8b 55 08             	mov    0x8(%ebp),%edx
80102bfc:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102bfe:	a1 34 d6 10 80       	mov    0x8010d634,%eax
80102c03:	3b 45 08             	cmp    0x8(%ebp),%eax
80102c06:	75 23                	jne    80102c2b <iderw+0xc5>
    idestart(b);
80102c08:	83 ec 0c             	sub    $0xc,%esp
80102c0b:	ff 75 08             	pushl  0x8(%ebp)
80102c0e:	e8 5c fd ff ff       	call   8010296f <idestart>
80102c13:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102c16:	eb 13                	jmp    80102c2b <iderw+0xc5>
    sleep(b, &idelock);
80102c18:	83 ec 08             	sub    $0x8,%esp
80102c1b:	68 00 d6 10 80       	push   $0x8010d600
80102c20:	ff 75 08             	pushl  0x8(%ebp)
80102c23:	e8 34 23 00 00       	call   80104f5c <sleep>
80102c28:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102c2b:	8b 45 08             	mov    0x8(%ebp),%eax
80102c2e:	8b 00                	mov    (%eax),%eax
80102c30:	83 e0 06             	and    $0x6,%eax
80102c33:	83 f8 02             	cmp    $0x2,%eax
80102c36:	75 e0                	jne    80102c18 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102c38:	83 ec 0c             	sub    $0xc,%esp
80102c3b:	68 00 d6 10 80       	push   $0x8010d600
80102c40:	e8 1b 37 00 00       	call   80106360 <release>
80102c45:	83 c4 10             	add    $0x10,%esp
}
80102c48:	90                   	nop
80102c49:	c9                   	leave  
80102c4a:	c3                   	ret    

80102c4b <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102c4b:	55                   	push   %ebp
80102c4c:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102c4e:	a1 74 42 11 80       	mov    0x80114274,%eax
80102c53:	8b 55 08             	mov    0x8(%ebp),%edx
80102c56:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102c58:	a1 74 42 11 80       	mov    0x80114274,%eax
80102c5d:	8b 40 10             	mov    0x10(%eax),%eax
}
80102c60:	5d                   	pop    %ebp
80102c61:	c3                   	ret    

80102c62 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102c62:	55                   	push   %ebp
80102c63:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102c65:	a1 74 42 11 80       	mov    0x80114274,%eax
80102c6a:	8b 55 08             	mov    0x8(%ebp),%edx
80102c6d:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102c6f:	a1 74 42 11 80       	mov    0x80114274,%eax
80102c74:	8b 55 0c             	mov    0xc(%ebp),%edx
80102c77:	89 50 10             	mov    %edx,0x10(%eax)
}
80102c7a:	90                   	nop
80102c7b:	5d                   	pop    %ebp
80102c7c:	c3                   	ret    

80102c7d <ioapicinit>:

void
ioapicinit(void)
{
80102c7d:	55                   	push   %ebp
80102c7e:	89 e5                	mov    %esp,%ebp
80102c80:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102c83:	a1 a4 43 11 80       	mov    0x801143a4,%eax
80102c88:	85 c0                	test   %eax,%eax
80102c8a:	0f 84 a0 00 00 00    	je     80102d30 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102c90:	c7 05 74 42 11 80 00 	movl   $0xfec00000,0x80114274
80102c97:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102c9a:	6a 01                	push   $0x1
80102c9c:	e8 aa ff ff ff       	call   80102c4b <ioapicread>
80102ca1:	83 c4 04             	add    $0x4,%esp
80102ca4:	c1 e8 10             	shr    $0x10,%eax
80102ca7:	25 ff 00 00 00       	and    $0xff,%eax
80102cac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102caf:	6a 00                	push   $0x0
80102cb1:	e8 95 ff ff ff       	call   80102c4b <ioapicread>
80102cb6:	83 c4 04             	add    $0x4,%esp
80102cb9:	c1 e8 18             	shr    $0x18,%eax
80102cbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102cbf:	0f b6 05 a0 43 11 80 	movzbl 0x801143a0,%eax
80102cc6:	0f b6 c0             	movzbl %al,%eax
80102cc9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102ccc:	74 10                	je     80102cde <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102cce:	83 ec 0c             	sub    $0xc,%esp
80102cd1:	68 40 9b 10 80       	push   $0x80109b40
80102cd6:	e8 7c d7 ff ff       	call   80100457 <cprintf>
80102cdb:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102cde:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102ce5:	eb 3f                	jmp    80102d26 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cea:	83 c0 20             	add    $0x20,%eax
80102ced:	0d 00 00 01 00       	or     $0x10000,%eax
80102cf2:	89 c2                	mov    %eax,%edx
80102cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cf7:	83 c0 08             	add    $0x8,%eax
80102cfa:	01 c0                	add    %eax,%eax
80102cfc:	83 ec 08             	sub    $0x8,%esp
80102cff:	52                   	push   %edx
80102d00:	50                   	push   %eax
80102d01:	e8 5c ff ff ff       	call   80102c62 <ioapicwrite>
80102d06:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d0c:	83 c0 08             	add    $0x8,%eax
80102d0f:	01 c0                	add    %eax,%eax
80102d11:	83 c0 01             	add    $0x1,%eax
80102d14:	83 ec 08             	sub    $0x8,%esp
80102d17:	6a 00                	push   $0x0
80102d19:	50                   	push   %eax
80102d1a:	e8 43 ff ff ff       	call   80102c62 <ioapicwrite>
80102d1f:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102d22:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102d2c:	7e b9                	jle    80102ce7 <ioapicinit+0x6a>
80102d2e:	eb 01                	jmp    80102d31 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102d30:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102d31:	c9                   	leave  
80102d32:	c3                   	ret    

80102d33 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102d33:	55                   	push   %ebp
80102d34:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102d36:	a1 a4 43 11 80       	mov    0x801143a4,%eax
80102d3b:	85 c0                	test   %eax,%eax
80102d3d:	74 39                	je     80102d78 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80102d42:	83 c0 20             	add    $0x20,%eax
80102d45:	89 c2                	mov    %eax,%edx
80102d47:	8b 45 08             	mov    0x8(%ebp),%eax
80102d4a:	83 c0 08             	add    $0x8,%eax
80102d4d:	01 c0                	add    %eax,%eax
80102d4f:	52                   	push   %edx
80102d50:	50                   	push   %eax
80102d51:	e8 0c ff ff ff       	call   80102c62 <ioapicwrite>
80102d56:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102d59:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d5c:	c1 e0 18             	shl    $0x18,%eax
80102d5f:	89 c2                	mov    %eax,%edx
80102d61:	8b 45 08             	mov    0x8(%ebp),%eax
80102d64:	83 c0 08             	add    $0x8,%eax
80102d67:	01 c0                	add    %eax,%eax
80102d69:	83 c0 01             	add    $0x1,%eax
80102d6c:	52                   	push   %edx
80102d6d:	50                   	push   %eax
80102d6e:	e8 ef fe ff ff       	call   80102c62 <ioapicwrite>
80102d73:	83 c4 08             	add    $0x8,%esp
80102d76:	eb 01                	jmp    80102d79 <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102d78:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102d79:	c9                   	leave  
80102d7a:	c3                   	ret    

80102d7b <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102d7b:	55                   	push   %ebp
80102d7c:	89 e5                	mov    %esp,%ebp
80102d7e:	8b 45 08             	mov    0x8(%ebp),%eax
80102d81:	05 00 00 00 80       	add    $0x80000000,%eax
80102d86:	5d                   	pop    %ebp
80102d87:	c3                   	ret    

80102d88 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102d88:	55                   	push   %ebp
80102d89:	89 e5                	mov    %esp,%ebp
80102d8b:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102d8e:	83 ec 08             	sub    $0x8,%esp
80102d91:	68 72 9b 10 80       	push   $0x80109b72
80102d96:	68 80 42 11 80       	push   $0x80114280
80102d9b:	e8 37 35 00 00       	call   801062d7 <initlock>
80102da0:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102da3:	c7 05 b4 42 11 80 00 	movl   $0x0,0x801142b4
80102daa:	00 00 00 
  freerange(vstart, vend);
80102dad:	83 ec 08             	sub    $0x8,%esp
80102db0:	ff 75 0c             	pushl  0xc(%ebp)
80102db3:	ff 75 08             	pushl  0x8(%ebp)
80102db6:	e8 2a 00 00 00       	call   80102de5 <freerange>
80102dbb:	83 c4 10             	add    $0x10,%esp
}
80102dbe:	90                   	nop
80102dbf:	c9                   	leave  
80102dc0:	c3                   	ret    

80102dc1 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102dc1:	55                   	push   %ebp
80102dc2:	89 e5                	mov    %esp,%ebp
80102dc4:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102dc7:	83 ec 08             	sub    $0x8,%esp
80102dca:	ff 75 0c             	pushl  0xc(%ebp)
80102dcd:	ff 75 08             	pushl  0x8(%ebp)
80102dd0:	e8 10 00 00 00       	call   80102de5 <freerange>
80102dd5:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102dd8:	c7 05 b4 42 11 80 01 	movl   $0x1,0x801142b4
80102ddf:	00 00 00 
}
80102de2:	90                   	nop
80102de3:	c9                   	leave  
80102de4:	c3                   	ret    

80102de5 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102de5:	55                   	push   %ebp
80102de6:	89 e5                	mov    %esp,%ebp
80102de8:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102deb:	8b 45 08             	mov    0x8(%ebp),%eax
80102dee:	05 ff 0f 00 00       	add    $0xfff,%eax
80102df3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102dfb:	eb 15                	jmp    80102e12 <freerange+0x2d>
    kfree(p);
80102dfd:	83 ec 0c             	sub    $0xc,%esp
80102e00:	ff 75 f4             	pushl  -0xc(%ebp)
80102e03:	e8 1a 00 00 00       	call   80102e22 <kfree>
80102e08:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e0b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e15:	05 00 10 00 00       	add    $0x1000,%eax
80102e1a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102e1d:	76 de                	jbe    80102dfd <freerange+0x18>
    kfree(p);
}
80102e1f:	90                   	nop
80102e20:	c9                   	leave  
80102e21:	c3                   	ret    

80102e22 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102e22:	55                   	push   %ebp
80102e23:	89 e5                	mov    %esp,%ebp
80102e25:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102e28:	8b 45 08             	mov    0x8(%ebp),%eax
80102e2b:	25 ff 0f 00 00       	and    $0xfff,%eax
80102e30:	85 c0                	test   %eax,%eax
80102e32:	75 1b                	jne    80102e4f <kfree+0x2d>
80102e34:	81 7d 08 9c 71 11 80 	cmpl   $0x8011719c,0x8(%ebp)
80102e3b:	72 12                	jb     80102e4f <kfree+0x2d>
80102e3d:	ff 75 08             	pushl  0x8(%ebp)
80102e40:	e8 36 ff ff ff       	call   80102d7b <v2p>
80102e45:	83 c4 04             	add    $0x4,%esp
80102e48:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102e4d:	76 0d                	jbe    80102e5c <kfree+0x3a>
    panic("kfree");
80102e4f:	83 ec 0c             	sub    $0xc,%esp
80102e52:	68 77 9b 10 80       	push   $0x80109b77
80102e57:	e8 9b d7 ff ff       	call   801005f7 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102e5c:	83 ec 04             	sub    $0x4,%esp
80102e5f:	68 00 10 00 00       	push   $0x1000
80102e64:	6a 01                	push   $0x1
80102e66:	ff 75 08             	pushl  0x8(%ebp)
80102e69:	e8 ee 36 00 00       	call   8010655c <memset>
80102e6e:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102e71:	a1 b4 42 11 80       	mov    0x801142b4,%eax
80102e76:	85 c0                	test   %eax,%eax
80102e78:	74 10                	je     80102e8a <kfree+0x68>
    acquire(&kmem.lock);
80102e7a:	83 ec 0c             	sub    $0xc,%esp
80102e7d:	68 80 42 11 80       	push   $0x80114280
80102e82:	e8 72 34 00 00       	call   801062f9 <acquire>
80102e87:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102e8a:	8b 45 08             	mov    0x8(%ebp),%eax
80102e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102e90:	8b 15 b8 42 11 80    	mov    0x801142b8,%edx
80102e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e99:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e9e:	a3 b8 42 11 80       	mov    %eax,0x801142b8
  if(kmem.use_lock)
80102ea3:	a1 b4 42 11 80       	mov    0x801142b4,%eax
80102ea8:	85 c0                	test   %eax,%eax
80102eaa:	74 10                	je     80102ebc <kfree+0x9a>
    release(&kmem.lock);
80102eac:	83 ec 0c             	sub    $0xc,%esp
80102eaf:	68 80 42 11 80       	push   $0x80114280
80102eb4:	e8 a7 34 00 00       	call   80106360 <release>
80102eb9:	83 c4 10             	add    $0x10,%esp
}
80102ebc:	90                   	nop
80102ebd:	c9                   	leave  
80102ebe:	c3                   	ret    

80102ebf <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102ebf:	55                   	push   %ebp
80102ec0:	89 e5                	mov    %esp,%ebp
80102ec2:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102ec5:	a1 b4 42 11 80       	mov    0x801142b4,%eax
80102eca:	85 c0                	test   %eax,%eax
80102ecc:	74 10                	je     80102ede <kalloc+0x1f>
    acquire(&kmem.lock);
80102ece:	83 ec 0c             	sub    $0xc,%esp
80102ed1:	68 80 42 11 80       	push   $0x80114280
80102ed6:	e8 1e 34 00 00       	call   801062f9 <acquire>
80102edb:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102ede:	a1 b8 42 11 80       	mov    0x801142b8,%eax
80102ee3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102ee6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102eea:	74 0a                	je     80102ef6 <kalloc+0x37>
    kmem.freelist = r->next;
80102eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102eef:	8b 00                	mov    (%eax),%eax
80102ef1:	a3 b8 42 11 80       	mov    %eax,0x801142b8
  if(kmem.use_lock)
80102ef6:	a1 b4 42 11 80       	mov    0x801142b4,%eax
80102efb:	85 c0                	test   %eax,%eax
80102efd:	74 10                	je     80102f0f <kalloc+0x50>
    release(&kmem.lock);
80102eff:	83 ec 0c             	sub    $0xc,%esp
80102f02:	68 80 42 11 80       	push   $0x80114280
80102f07:	e8 54 34 00 00       	call   80106360 <release>
80102f0c:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102f12:	c9                   	leave  
80102f13:	c3                   	ret    

80102f14 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102f14:	55                   	push   %ebp
80102f15:	89 e5                	mov    %esp,%ebp
80102f17:	83 ec 14             	sub    $0x14,%esp
80102f1a:	8b 45 08             	mov    0x8(%ebp),%eax
80102f1d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f21:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102f25:	89 c2                	mov    %eax,%edx
80102f27:	ec                   	in     (%dx),%al
80102f28:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102f2b:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102f2f:	c9                   	leave  
80102f30:	c3                   	ret    

80102f31 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102f31:	55                   	push   %ebp
80102f32:	89 e5                	mov    %esp,%ebp
80102f34:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102f37:	6a 64                	push   $0x64
80102f39:	e8 d6 ff ff ff       	call   80102f14 <inb>
80102f3e:	83 c4 04             	add    $0x4,%esp
80102f41:	0f b6 c0             	movzbl %al,%eax
80102f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f4a:	83 e0 01             	and    $0x1,%eax
80102f4d:	85 c0                	test   %eax,%eax
80102f4f:	75 0a                	jne    80102f5b <kbdgetc+0x2a>
    return -1;
80102f51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102f56:	e9 23 01 00 00       	jmp    8010307e <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102f5b:	6a 60                	push   $0x60
80102f5d:	e8 b2 ff ff ff       	call   80102f14 <inb>
80102f62:	83 c4 04             	add    $0x4,%esp
80102f65:	0f b6 c0             	movzbl %al,%eax
80102f68:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102f6b:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102f72:	75 17                	jne    80102f8b <kbdgetc+0x5a>
    shift |= E0ESC;
80102f74:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80102f79:	83 c8 40             	or     $0x40,%eax
80102f7c:	a3 3c d6 10 80       	mov    %eax,0x8010d63c
    return 0;
80102f81:	b8 00 00 00 00       	mov    $0x0,%eax
80102f86:	e9 f3 00 00 00       	jmp    8010307e <kbdgetc+0x14d>
  } else if(data & 0x80){
80102f8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f8e:	25 80 00 00 00       	and    $0x80,%eax
80102f93:	85 c0                	test   %eax,%eax
80102f95:	74 45                	je     80102fdc <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102f97:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80102f9c:	83 e0 40             	and    $0x40,%eax
80102f9f:	85 c0                	test   %eax,%eax
80102fa1:	75 08                	jne    80102fab <kbdgetc+0x7a>
80102fa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102fa6:	83 e0 7f             	and    $0x7f,%eax
80102fa9:	eb 03                	jmp    80102fae <kbdgetc+0x7d>
80102fab:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102fae:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102fb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102fb4:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102fb9:	0f b6 00             	movzbl (%eax),%eax
80102fbc:	83 c8 40             	or     $0x40,%eax
80102fbf:	0f b6 c0             	movzbl %al,%eax
80102fc2:	f7 d0                	not    %eax
80102fc4:	89 c2                	mov    %eax,%edx
80102fc6:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80102fcb:	21 d0                	and    %edx,%eax
80102fcd:	a3 3c d6 10 80       	mov    %eax,0x8010d63c
    return 0;
80102fd2:	b8 00 00 00 00       	mov    $0x0,%eax
80102fd7:	e9 a2 00 00 00       	jmp    8010307e <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102fdc:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80102fe1:	83 e0 40             	and    $0x40,%eax
80102fe4:	85 c0                	test   %eax,%eax
80102fe6:	74 14                	je     80102ffc <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102fe8:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102fef:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80102ff4:	83 e0 bf             	and    $0xffffffbf,%eax
80102ff7:	a3 3c d6 10 80       	mov    %eax,0x8010d63c
  }

  shift |= shiftcode[data];
80102ffc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102fff:	05 20 b0 10 80       	add    $0x8010b020,%eax
80103004:	0f b6 00             	movzbl (%eax),%eax
80103007:	0f b6 d0             	movzbl %al,%edx
8010300a:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
8010300f:	09 d0                	or     %edx,%eax
80103011:	a3 3c d6 10 80       	mov    %eax,0x8010d63c
  shift ^= togglecode[data];
80103016:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103019:	05 20 b1 10 80       	add    $0x8010b120,%eax
8010301e:	0f b6 00             	movzbl (%eax),%eax
80103021:	0f b6 d0             	movzbl %al,%edx
80103024:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80103029:	31 d0                	xor    %edx,%eax
8010302b:	a3 3c d6 10 80       	mov    %eax,0x8010d63c
  c = charcode[shift & (CTL | SHIFT)][data];
80103030:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80103035:	83 e0 03             	and    $0x3,%eax
80103038:	8b 14 85 20 b5 10 80 	mov    -0x7fef4ae0(,%eax,4),%edx
8010303f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103042:	01 d0                	add    %edx,%eax
80103044:	0f b6 00             	movzbl (%eax),%eax
80103047:	0f b6 c0             	movzbl %al,%eax
8010304a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
8010304d:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80103052:	83 e0 08             	and    $0x8,%eax
80103055:	85 c0                	test   %eax,%eax
80103057:	74 22                	je     8010307b <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80103059:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
8010305d:	76 0c                	jbe    8010306b <kbdgetc+0x13a>
8010305f:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80103063:	77 06                	ja     8010306b <kbdgetc+0x13a>
      c += 'A' - 'a';
80103065:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80103069:	eb 10                	jmp    8010307b <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
8010306b:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
8010306f:	76 0a                	jbe    8010307b <kbdgetc+0x14a>
80103071:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80103075:	77 04                	ja     8010307b <kbdgetc+0x14a>
      c += 'a' - 'A';
80103077:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
8010307b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010307e:	c9                   	leave  
8010307f:	c3                   	ret    

80103080 <kbdintr>:

void
kbdintr(void)
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80103086:	83 ec 0c             	sub    $0xc,%esp
80103089:	68 31 2f 10 80       	push   $0x80102f31
8010308e:	e8 db d7 ff ff       	call   8010086e <consoleintr>
80103093:	83 c4 10             	add    $0x10,%esp
}
80103096:	90                   	nop
80103097:	c9                   	leave  
80103098:	c3                   	ret    

80103099 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103099:	55                   	push   %ebp
8010309a:	89 e5                	mov    %esp,%ebp
8010309c:	83 ec 14             	sub    $0x14,%esp
8010309f:	8b 45 08             	mov    0x8(%ebp),%eax
801030a2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030a6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801030aa:	89 c2                	mov    %eax,%edx
801030ac:	ec                   	in     (%dx),%al
801030ad:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801030b0:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801030b4:	c9                   	leave  
801030b5:	c3                   	ret    

801030b6 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801030b6:	55                   	push   %ebp
801030b7:	89 e5                	mov    %esp,%ebp
801030b9:	83 ec 08             	sub    $0x8,%esp
801030bc:	8b 55 08             	mov    0x8(%ebp),%edx
801030bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801030c2:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801030c6:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030c9:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801030cd:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801030d1:	ee                   	out    %al,(%dx)
}
801030d2:	90                   	nop
801030d3:	c9                   	leave  
801030d4:	c3                   	ret    

801030d5 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801030d5:	55                   	push   %ebp
801030d6:	89 e5                	mov    %esp,%ebp
801030d8:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801030db:	9c                   	pushf  
801030dc:	58                   	pop    %eax
801030dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801030e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801030e3:	c9                   	leave  
801030e4:	c3                   	ret    

801030e5 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
801030e5:	55                   	push   %ebp
801030e6:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
801030e8:	a1 bc 42 11 80       	mov    0x801142bc,%eax
801030ed:	8b 55 08             	mov    0x8(%ebp),%edx
801030f0:	c1 e2 02             	shl    $0x2,%edx
801030f3:	01 c2                	add    %eax,%edx
801030f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801030f8:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
801030fa:	a1 bc 42 11 80       	mov    0x801142bc,%eax
801030ff:	83 c0 20             	add    $0x20,%eax
80103102:	8b 00                	mov    (%eax),%eax
}
80103104:	90                   	nop
80103105:	5d                   	pop    %ebp
80103106:	c3                   	ret    

80103107 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80103107:	55                   	push   %ebp
80103108:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
8010310a:	a1 bc 42 11 80       	mov    0x801142bc,%eax
8010310f:	85 c0                	test   %eax,%eax
80103111:	0f 84 0b 01 00 00    	je     80103222 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80103117:	68 3f 01 00 00       	push   $0x13f
8010311c:	6a 3c                	push   $0x3c
8010311e:	e8 c2 ff ff ff       	call   801030e5 <lapicw>
80103123:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80103126:	6a 0b                	push   $0xb
80103128:	68 f8 00 00 00       	push   $0xf8
8010312d:	e8 b3 ff ff ff       	call   801030e5 <lapicw>
80103132:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80103135:	68 20 00 02 00       	push   $0x20020
8010313a:	68 c8 00 00 00       	push   $0xc8
8010313f:	e8 a1 ff ff ff       	call   801030e5 <lapicw>
80103144:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80103147:	68 80 96 98 00       	push   $0x989680
8010314c:	68 e0 00 00 00       	push   $0xe0
80103151:	e8 8f ff ff ff       	call   801030e5 <lapicw>
80103156:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80103159:	68 00 00 01 00       	push   $0x10000
8010315e:	68 d4 00 00 00       	push   $0xd4
80103163:	e8 7d ff ff ff       	call   801030e5 <lapicw>
80103168:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
8010316b:	68 00 00 01 00       	push   $0x10000
80103170:	68 d8 00 00 00       	push   $0xd8
80103175:	e8 6b ff ff ff       	call   801030e5 <lapicw>
8010317a:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010317d:	a1 bc 42 11 80       	mov    0x801142bc,%eax
80103182:	83 c0 30             	add    $0x30,%eax
80103185:	8b 00                	mov    (%eax),%eax
80103187:	c1 e8 10             	shr    $0x10,%eax
8010318a:	0f b6 c0             	movzbl %al,%eax
8010318d:	83 f8 03             	cmp    $0x3,%eax
80103190:	76 12                	jbe    801031a4 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80103192:	68 00 00 01 00       	push   $0x10000
80103197:	68 d0 00 00 00       	push   $0xd0
8010319c:	e8 44 ff ff ff       	call   801030e5 <lapicw>
801031a1:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801031a4:	6a 33                	push   $0x33
801031a6:	68 dc 00 00 00       	push   $0xdc
801031ab:	e8 35 ff ff ff       	call   801030e5 <lapicw>
801031b0:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
801031b3:	6a 00                	push   $0x0
801031b5:	68 a0 00 00 00       	push   $0xa0
801031ba:	e8 26 ff ff ff       	call   801030e5 <lapicw>
801031bf:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
801031c2:	6a 00                	push   $0x0
801031c4:	68 a0 00 00 00       	push   $0xa0
801031c9:	e8 17 ff ff ff       	call   801030e5 <lapicw>
801031ce:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
801031d1:	6a 00                	push   $0x0
801031d3:	6a 2c                	push   $0x2c
801031d5:	e8 0b ff ff ff       	call   801030e5 <lapicw>
801031da:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
801031dd:	6a 00                	push   $0x0
801031df:	68 c4 00 00 00       	push   $0xc4
801031e4:	e8 fc fe ff ff       	call   801030e5 <lapicw>
801031e9:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
801031ec:	68 00 85 08 00       	push   $0x88500
801031f1:	68 c0 00 00 00       	push   $0xc0
801031f6:	e8 ea fe ff ff       	call   801030e5 <lapicw>
801031fb:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
801031fe:	90                   	nop
801031ff:	a1 bc 42 11 80       	mov    0x801142bc,%eax
80103204:	05 00 03 00 00       	add    $0x300,%eax
80103209:	8b 00                	mov    (%eax),%eax
8010320b:	25 00 10 00 00       	and    $0x1000,%eax
80103210:	85 c0                	test   %eax,%eax
80103212:	75 eb                	jne    801031ff <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80103214:	6a 00                	push   $0x0
80103216:	6a 20                	push   $0x20
80103218:	e8 c8 fe ff ff       	call   801030e5 <lapicw>
8010321d:	83 c4 08             	add    $0x8,%esp
80103220:	eb 01                	jmp    80103223 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80103222:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103223:	c9                   	leave  
80103224:	c3                   	ret    

80103225 <cpunum>:

int
cpunum(void)
{
80103225:	55                   	push   %ebp
80103226:	89 e5                	mov    %esp,%ebp
80103228:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
8010322b:	e8 a5 fe ff ff       	call   801030d5 <readeflags>
80103230:	25 00 02 00 00       	and    $0x200,%eax
80103235:	85 c0                	test   %eax,%eax
80103237:	74 26                	je     8010325f <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80103239:	a1 40 d6 10 80       	mov    0x8010d640,%eax
8010323e:	8d 50 01             	lea    0x1(%eax),%edx
80103241:	89 15 40 d6 10 80    	mov    %edx,0x8010d640
80103247:	85 c0                	test   %eax,%eax
80103249:	75 14                	jne    8010325f <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
8010324b:	8b 45 04             	mov    0x4(%ebp),%eax
8010324e:	83 ec 08             	sub    $0x8,%esp
80103251:	50                   	push   %eax
80103252:	68 80 9b 10 80       	push   $0x80109b80
80103257:	e8 fb d1 ff ff       	call   80100457 <cprintf>
8010325c:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
8010325f:	a1 bc 42 11 80       	mov    0x801142bc,%eax
80103264:	85 c0                	test   %eax,%eax
80103266:	74 0f                	je     80103277 <cpunum+0x52>
    return lapic[ID]>>24;
80103268:	a1 bc 42 11 80       	mov    0x801142bc,%eax
8010326d:	83 c0 20             	add    $0x20,%eax
80103270:	8b 00                	mov    (%eax),%eax
80103272:	c1 e8 18             	shr    $0x18,%eax
80103275:	eb 05                	jmp    8010327c <cpunum+0x57>
  return 0;
80103277:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010327c:	c9                   	leave  
8010327d:	c3                   	ret    

8010327e <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
8010327e:	55                   	push   %ebp
8010327f:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103281:	a1 bc 42 11 80       	mov    0x801142bc,%eax
80103286:	85 c0                	test   %eax,%eax
80103288:	74 0c                	je     80103296 <lapiceoi+0x18>
    lapicw(EOI, 0);
8010328a:	6a 00                	push   $0x0
8010328c:	6a 2c                	push   $0x2c
8010328e:	e8 52 fe ff ff       	call   801030e5 <lapicw>
80103293:	83 c4 08             	add    $0x8,%esp
}
80103296:	90                   	nop
80103297:	c9                   	leave  
80103298:	c3                   	ret    

80103299 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103299:	55                   	push   %ebp
8010329a:	89 e5                	mov    %esp,%ebp
}
8010329c:	90                   	nop
8010329d:	5d                   	pop    %ebp
8010329e:	c3                   	ret    

8010329f <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
8010329f:	55                   	push   %ebp
801032a0:	89 e5                	mov    %esp,%ebp
801032a2:	83 ec 14             	sub    $0x14,%esp
801032a5:	8b 45 08             	mov    0x8(%ebp),%eax
801032a8:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801032ab:	6a 0f                	push   $0xf
801032ad:	6a 70                	push   $0x70
801032af:	e8 02 fe ff ff       	call   801030b6 <outb>
801032b4:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
801032b7:	6a 0a                	push   $0xa
801032b9:	6a 71                	push   $0x71
801032bb:	e8 f6 fd ff ff       	call   801030b6 <outb>
801032c0:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
801032c3:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801032ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
801032cd:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801032d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
801032d5:	83 c0 02             	add    $0x2,%eax
801032d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801032db:	c1 ea 04             	shr    $0x4,%edx
801032de:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801032e1:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801032e5:	c1 e0 18             	shl    $0x18,%eax
801032e8:	50                   	push   %eax
801032e9:	68 c4 00 00 00       	push   $0xc4
801032ee:	e8 f2 fd ff ff       	call   801030e5 <lapicw>
801032f3:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801032f6:	68 00 c5 00 00       	push   $0xc500
801032fb:	68 c0 00 00 00       	push   $0xc0
80103300:	e8 e0 fd ff ff       	call   801030e5 <lapicw>
80103305:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103308:	68 c8 00 00 00       	push   $0xc8
8010330d:	e8 87 ff ff ff       	call   80103299 <microdelay>
80103312:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103315:	68 00 85 00 00       	push   $0x8500
8010331a:	68 c0 00 00 00       	push   $0xc0
8010331f:	e8 c1 fd ff ff       	call   801030e5 <lapicw>
80103324:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103327:	6a 64                	push   $0x64
80103329:	e8 6b ff ff ff       	call   80103299 <microdelay>
8010332e:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103331:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103338:	eb 3d                	jmp    80103377 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
8010333a:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010333e:	c1 e0 18             	shl    $0x18,%eax
80103341:	50                   	push   %eax
80103342:	68 c4 00 00 00       	push   $0xc4
80103347:	e8 99 fd ff ff       	call   801030e5 <lapicw>
8010334c:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
8010334f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103352:	c1 e8 0c             	shr    $0xc,%eax
80103355:	80 cc 06             	or     $0x6,%ah
80103358:	50                   	push   %eax
80103359:	68 c0 00 00 00       	push   $0xc0
8010335e:	e8 82 fd ff ff       	call   801030e5 <lapicw>
80103363:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103366:	68 c8 00 00 00       	push   $0xc8
8010336b:	e8 29 ff ff ff       	call   80103299 <microdelay>
80103370:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103373:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103377:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010337b:	7e bd                	jle    8010333a <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010337d:	90                   	nop
8010337e:	c9                   	leave  
8010337f:	c3                   	ret    

80103380 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103383:	8b 45 08             	mov    0x8(%ebp),%eax
80103386:	0f b6 c0             	movzbl %al,%eax
80103389:	50                   	push   %eax
8010338a:	6a 70                	push   $0x70
8010338c:	e8 25 fd ff ff       	call   801030b6 <outb>
80103391:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103394:	68 c8 00 00 00       	push   $0xc8
80103399:	e8 fb fe ff ff       	call   80103299 <microdelay>
8010339e:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801033a1:	6a 71                	push   $0x71
801033a3:	e8 f1 fc ff ff       	call   80103099 <inb>
801033a8:	83 c4 04             	add    $0x4,%esp
801033ab:	0f b6 c0             	movzbl %al,%eax
}
801033ae:	c9                   	leave  
801033af:	c3                   	ret    

801033b0 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801033b0:	55                   	push   %ebp
801033b1:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
801033b3:	6a 00                	push   $0x0
801033b5:	e8 c6 ff ff ff       	call   80103380 <cmos_read>
801033ba:	83 c4 04             	add    $0x4,%esp
801033bd:	89 c2                	mov    %eax,%edx
801033bf:	8b 45 08             	mov    0x8(%ebp),%eax
801033c2:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
801033c4:	6a 02                	push   $0x2
801033c6:	e8 b5 ff ff ff       	call   80103380 <cmos_read>
801033cb:	83 c4 04             	add    $0x4,%esp
801033ce:	89 c2                	mov    %eax,%edx
801033d0:	8b 45 08             	mov    0x8(%ebp),%eax
801033d3:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
801033d6:	6a 04                	push   $0x4
801033d8:	e8 a3 ff ff ff       	call   80103380 <cmos_read>
801033dd:	83 c4 04             	add    $0x4,%esp
801033e0:	89 c2                	mov    %eax,%edx
801033e2:	8b 45 08             	mov    0x8(%ebp),%eax
801033e5:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
801033e8:	6a 07                	push   $0x7
801033ea:	e8 91 ff ff ff       	call   80103380 <cmos_read>
801033ef:	83 c4 04             	add    $0x4,%esp
801033f2:	89 c2                	mov    %eax,%edx
801033f4:	8b 45 08             	mov    0x8(%ebp),%eax
801033f7:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
801033fa:	6a 08                	push   $0x8
801033fc:	e8 7f ff ff ff       	call   80103380 <cmos_read>
80103401:	83 c4 04             	add    $0x4,%esp
80103404:	89 c2                	mov    %eax,%edx
80103406:	8b 45 08             	mov    0x8(%ebp),%eax
80103409:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
8010340c:	6a 09                	push   $0x9
8010340e:	e8 6d ff ff ff       	call   80103380 <cmos_read>
80103413:	83 c4 04             	add    $0x4,%esp
80103416:	89 c2                	mov    %eax,%edx
80103418:	8b 45 08             	mov    0x8(%ebp),%eax
8010341b:	89 50 14             	mov    %edx,0x14(%eax)
}
8010341e:	90                   	nop
8010341f:	c9                   	leave  
80103420:	c3                   	ret    

80103421 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103421:	55                   	push   %ebp
80103422:	89 e5                	mov    %esp,%ebp
80103424:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103427:	6a 0b                	push   $0xb
80103429:	e8 52 ff ff ff       	call   80103380 <cmos_read>
8010342e:	83 c4 04             	add    $0x4,%esp
80103431:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103434:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103437:	83 e0 04             	and    $0x4,%eax
8010343a:	85 c0                	test   %eax,%eax
8010343c:	0f 94 c0             	sete   %al
8010343f:	0f b6 c0             	movzbl %al,%eax
80103442:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103445:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103448:	50                   	push   %eax
80103449:	e8 62 ff ff ff       	call   801033b0 <fill_rtcdate>
8010344e:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103451:	6a 0a                	push   $0xa
80103453:	e8 28 ff ff ff       	call   80103380 <cmos_read>
80103458:	83 c4 04             	add    $0x4,%esp
8010345b:	25 80 00 00 00       	and    $0x80,%eax
80103460:	85 c0                	test   %eax,%eax
80103462:	75 27                	jne    8010348b <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80103464:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103467:	50                   	push   %eax
80103468:	e8 43 ff ff ff       	call   801033b0 <fill_rtcdate>
8010346d:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103470:	83 ec 04             	sub    $0x4,%esp
80103473:	6a 18                	push   $0x18
80103475:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103478:	50                   	push   %eax
80103479:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010347c:	50                   	push   %eax
8010347d:	e8 41 31 00 00       	call   801065c3 <memcmp>
80103482:	83 c4 10             	add    $0x10,%esp
80103485:	85 c0                	test   %eax,%eax
80103487:	74 05                	je     8010348e <cmostime+0x6d>
80103489:	eb ba                	jmp    80103445 <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
8010348b:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
8010348c:	eb b7                	jmp    80103445 <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
8010348e:	90                   	nop
  }

  // convert
  if (bcd) {
8010348f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103493:	0f 84 b4 00 00 00    	je     8010354d <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103499:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010349c:	c1 e8 04             	shr    $0x4,%eax
8010349f:	89 c2                	mov    %eax,%edx
801034a1:	89 d0                	mov    %edx,%eax
801034a3:	c1 e0 02             	shl    $0x2,%eax
801034a6:	01 d0                	add    %edx,%eax
801034a8:	01 c0                	add    %eax,%eax
801034aa:	89 c2                	mov    %eax,%edx
801034ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
801034af:	83 e0 0f             	and    $0xf,%eax
801034b2:	01 d0                	add    %edx,%eax
801034b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801034b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801034ba:	c1 e8 04             	shr    $0x4,%eax
801034bd:	89 c2                	mov    %eax,%edx
801034bf:	89 d0                	mov    %edx,%eax
801034c1:	c1 e0 02             	shl    $0x2,%eax
801034c4:	01 d0                	add    %edx,%eax
801034c6:	01 c0                	add    %eax,%eax
801034c8:	89 c2                	mov    %eax,%edx
801034ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
801034cd:	83 e0 0f             	and    $0xf,%eax
801034d0:	01 d0                	add    %edx,%eax
801034d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801034d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801034d8:	c1 e8 04             	shr    $0x4,%eax
801034db:	89 c2                	mov    %eax,%edx
801034dd:	89 d0                	mov    %edx,%eax
801034df:	c1 e0 02             	shl    $0x2,%eax
801034e2:	01 d0                	add    %edx,%eax
801034e4:	01 c0                	add    %eax,%eax
801034e6:	89 c2                	mov    %eax,%edx
801034e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801034eb:	83 e0 0f             	and    $0xf,%eax
801034ee:	01 d0                	add    %edx,%eax
801034f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801034f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034f6:	c1 e8 04             	shr    $0x4,%eax
801034f9:	89 c2                	mov    %eax,%edx
801034fb:	89 d0                	mov    %edx,%eax
801034fd:	c1 e0 02             	shl    $0x2,%eax
80103500:	01 d0                	add    %edx,%eax
80103502:	01 c0                	add    %eax,%eax
80103504:	89 c2                	mov    %eax,%edx
80103506:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103509:	83 e0 0f             	and    $0xf,%eax
8010350c:	01 d0                	add    %edx,%eax
8010350e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103511:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103514:	c1 e8 04             	shr    $0x4,%eax
80103517:	89 c2                	mov    %eax,%edx
80103519:	89 d0                	mov    %edx,%eax
8010351b:	c1 e0 02             	shl    $0x2,%eax
8010351e:	01 d0                	add    %edx,%eax
80103520:	01 c0                	add    %eax,%eax
80103522:	89 c2                	mov    %eax,%edx
80103524:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103527:	83 e0 0f             	and    $0xf,%eax
8010352a:	01 d0                	add    %edx,%eax
8010352c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
8010352f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103532:	c1 e8 04             	shr    $0x4,%eax
80103535:	89 c2                	mov    %eax,%edx
80103537:	89 d0                	mov    %edx,%eax
80103539:	c1 e0 02             	shl    $0x2,%eax
8010353c:	01 d0                	add    %edx,%eax
8010353e:	01 c0                	add    %eax,%eax
80103540:	89 c2                	mov    %eax,%edx
80103542:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103545:	83 e0 0f             	and    $0xf,%eax
80103548:	01 d0                	add    %edx,%eax
8010354a:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
8010354d:	8b 45 08             	mov    0x8(%ebp),%eax
80103550:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103553:	89 10                	mov    %edx,(%eax)
80103555:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103558:	89 50 04             	mov    %edx,0x4(%eax)
8010355b:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010355e:	89 50 08             	mov    %edx,0x8(%eax)
80103561:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103564:	89 50 0c             	mov    %edx,0xc(%eax)
80103567:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010356a:	89 50 10             	mov    %edx,0x10(%eax)
8010356d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103570:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103573:	8b 45 08             	mov    0x8(%ebp),%eax
80103576:	8b 40 14             	mov    0x14(%eax),%eax
80103579:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010357f:	8b 45 08             	mov    0x8(%ebp),%eax
80103582:	89 50 14             	mov    %edx,0x14(%eax)
}
80103585:	90                   	nop
80103586:	c9                   	leave  
80103587:	c3                   	ret    

80103588 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(void)
{
80103588:	55                   	push   %ebp
80103589:	89 e5                	mov    %esp,%ebp
8010358b:	83 ec 18             	sub    $0x18,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010358e:	83 ec 08             	sub    $0x8,%esp
80103591:	68 ac 9b 10 80       	push   $0x80109bac
80103596:	68 c0 42 11 80       	push   $0x801142c0
8010359b:	e8 37 2d 00 00       	call   801062d7 <initlock>
801035a0:	83 c4 10             	add    $0x10,%esp
  readsb(ROOTDEV, &sb);
801035a3:	83 ec 08             	sub    $0x8,%esp
801035a6:	8d 45 e8             	lea    -0x18(%ebp),%eax
801035a9:	50                   	push   %eax
801035aa:	6a 01                	push   $0x1
801035ac:	e8 7e de ff ff       	call   8010142f <readsb>
801035b1:	83 c4 10             	add    $0x10,%esp
  log.start = sb.size - sb.nlog;
801035b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
801035b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035ba:	29 c2                	sub    %eax,%edx
801035bc:	89 d0                	mov    %edx,%eax
801035be:	a3 f4 42 11 80       	mov    %eax,0x801142f4
  log.size = sb.nlog;
801035c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035c6:	a3 f8 42 11 80       	mov    %eax,0x801142f8
  log.dev = ROOTDEV;
801035cb:	c7 05 04 43 11 80 01 	movl   $0x1,0x80114304
801035d2:	00 00 00 
  recover_from_log();
801035d5:	e8 b2 01 00 00       	call   8010378c <recover_from_log>
}
801035da:	90                   	nop
801035db:	c9                   	leave  
801035dc:	c3                   	ret    

801035dd <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801035dd:	55                   	push   %ebp
801035de:	89 e5                	mov    %esp,%ebp
801035e0:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801035e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801035ea:	e9 95 00 00 00       	jmp    80103684 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801035ef:	8b 15 f4 42 11 80    	mov    0x801142f4,%edx
801035f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035f8:	01 d0                	add    %edx,%eax
801035fa:	83 c0 01             	add    $0x1,%eax
801035fd:	89 c2                	mov    %eax,%edx
801035ff:	a1 04 43 11 80       	mov    0x80114304,%eax
80103604:	83 ec 08             	sub    $0x8,%esp
80103607:	52                   	push   %edx
80103608:	50                   	push   %eax
80103609:	e8 04 cc ff ff       	call   80100212 <bread>
8010360e:	83 c4 10             	add    $0x10,%esp
80103611:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
80103614:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103617:	83 c0 10             	add    $0x10,%eax
8010361a:	8b 04 85 cc 42 11 80 	mov    -0x7feebd34(,%eax,4),%eax
80103621:	89 c2                	mov    %eax,%edx
80103623:	a1 04 43 11 80       	mov    0x80114304,%eax
80103628:	83 ec 08             	sub    $0x8,%esp
8010362b:	52                   	push   %edx
8010362c:	50                   	push   %eax
8010362d:	e8 e0 cb ff ff       	call   80100212 <bread>
80103632:	83 c4 10             	add    $0x10,%esp
80103635:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103638:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010363b:	8d 50 18             	lea    0x18(%eax),%edx
8010363e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103641:	83 c0 18             	add    $0x18,%eax
80103644:	83 ec 04             	sub    $0x4,%esp
80103647:	68 00 02 00 00       	push   $0x200
8010364c:	52                   	push   %edx
8010364d:	50                   	push   %eax
8010364e:	e8 c8 2f 00 00       	call   8010661b <memmove>
80103653:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80103656:	83 ec 0c             	sub    $0xc,%esp
80103659:	ff 75 ec             	pushl  -0x14(%ebp)
8010365c:	e8 ea cb ff ff       	call   8010024b <bwrite>
80103661:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
80103664:	83 ec 0c             	sub    $0xc,%esp
80103667:	ff 75 f0             	pushl  -0x10(%ebp)
8010366a:	e8 1b cc ff ff       	call   8010028a <brelse>
8010366f:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103672:	83 ec 0c             	sub    $0xc,%esp
80103675:	ff 75 ec             	pushl  -0x14(%ebp)
80103678:	e8 0d cc ff ff       	call   8010028a <brelse>
8010367d:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103680:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103684:	a1 08 43 11 80       	mov    0x80114308,%eax
80103689:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010368c:	0f 8f 5d ff ff ff    	jg     801035ef <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103692:	90                   	nop
80103693:	c9                   	leave  
80103694:	c3                   	ret    

80103695 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103695:	55                   	push   %ebp
80103696:	89 e5                	mov    %esp,%ebp
80103698:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010369b:	a1 f4 42 11 80       	mov    0x801142f4,%eax
801036a0:	89 c2                	mov    %eax,%edx
801036a2:	a1 04 43 11 80       	mov    0x80114304,%eax
801036a7:	83 ec 08             	sub    $0x8,%esp
801036aa:	52                   	push   %edx
801036ab:	50                   	push   %eax
801036ac:	e8 61 cb ff ff       	call   80100212 <bread>
801036b1:	83 c4 10             	add    $0x10,%esp
801036b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801036b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036ba:	83 c0 18             	add    $0x18,%eax
801036bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801036c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036c3:	8b 00                	mov    (%eax),%eax
801036c5:	a3 08 43 11 80       	mov    %eax,0x80114308
  for (i = 0; i < log.lh.n; i++) {
801036ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036d1:	eb 1b                	jmp    801036ee <read_head+0x59>
    log.lh.sector[i] = lh->sector[i];
801036d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036d9:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801036dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036e0:	83 c2 10             	add    $0x10,%edx
801036e3:	89 04 95 cc 42 11 80 	mov    %eax,-0x7feebd34(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801036ea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036ee:	a1 08 43 11 80       	mov    0x80114308,%eax
801036f3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036f6:	7f db                	jg     801036d3 <read_head+0x3e>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
801036f8:	83 ec 0c             	sub    $0xc,%esp
801036fb:	ff 75 f0             	pushl  -0x10(%ebp)
801036fe:	e8 87 cb ff ff       	call   8010028a <brelse>
80103703:	83 c4 10             	add    $0x10,%esp
}
80103706:	90                   	nop
80103707:	c9                   	leave  
80103708:	c3                   	ret    

80103709 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103709:	55                   	push   %ebp
8010370a:	89 e5                	mov    %esp,%ebp
8010370c:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010370f:	a1 f4 42 11 80       	mov    0x801142f4,%eax
80103714:	89 c2                	mov    %eax,%edx
80103716:	a1 04 43 11 80       	mov    0x80114304,%eax
8010371b:	83 ec 08             	sub    $0x8,%esp
8010371e:	52                   	push   %edx
8010371f:	50                   	push   %eax
80103720:	e8 ed ca ff ff       	call   80100212 <bread>
80103725:	83 c4 10             	add    $0x10,%esp
80103728:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010372b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010372e:	83 c0 18             	add    $0x18,%eax
80103731:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103734:	8b 15 08 43 11 80    	mov    0x80114308,%edx
8010373a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010373d:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010373f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103746:	eb 1b                	jmp    80103763 <write_head+0x5a>
    hb->sector[i] = log.lh.sector[i];
80103748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010374b:	83 c0 10             	add    $0x10,%eax
8010374e:	8b 0c 85 cc 42 11 80 	mov    -0x7feebd34(,%eax,4),%ecx
80103755:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103758:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010375b:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
8010375f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103763:	a1 08 43 11 80       	mov    0x80114308,%eax
80103768:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010376b:	7f db                	jg     80103748 <write_head+0x3f>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
8010376d:	83 ec 0c             	sub    $0xc,%esp
80103770:	ff 75 f0             	pushl  -0x10(%ebp)
80103773:	e8 d3 ca ff ff       	call   8010024b <bwrite>
80103778:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
8010377b:	83 ec 0c             	sub    $0xc,%esp
8010377e:	ff 75 f0             	pushl  -0x10(%ebp)
80103781:	e8 04 cb ff ff       	call   8010028a <brelse>
80103786:	83 c4 10             	add    $0x10,%esp
}
80103789:	90                   	nop
8010378a:	c9                   	leave  
8010378b:	c3                   	ret    

8010378c <recover_from_log>:

static void
recover_from_log(void)
{
8010378c:	55                   	push   %ebp
8010378d:	89 e5                	mov    %esp,%ebp
8010378f:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103792:	e8 fe fe ff ff       	call   80103695 <read_head>
  install_trans(); // if committed, copy from log to disk
80103797:	e8 41 fe ff ff       	call   801035dd <install_trans>
  log.lh.n = 0;
8010379c:	c7 05 08 43 11 80 00 	movl   $0x0,0x80114308
801037a3:	00 00 00 
  write_head(); // clear the log
801037a6:	e8 5e ff ff ff       	call   80103709 <write_head>
}
801037ab:	90                   	nop
801037ac:	c9                   	leave  
801037ad:	c3                   	ret    

801037ae <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801037ae:	55                   	push   %ebp
801037af:	89 e5                	mov    %esp,%ebp
801037b1:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801037b4:	83 ec 0c             	sub    $0xc,%esp
801037b7:	68 c0 42 11 80       	push   $0x801142c0
801037bc:	e8 38 2b 00 00       	call   801062f9 <acquire>
801037c1:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801037c4:	a1 00 43 11 80       	mov    0x80114300,%eax
801037c9:	85 c0                	test   %eax,%eax
801037cb:	74 17                	je     801037e4 <begin_op+0x36>
      sleep(&log, &log.lock);
801037cd:	83 ec 08             	sub    $0x8,%esp
801037d0:	68 c0 42 11 80       	push   $0x801142c0
801037d5:	68 c0 42 11 80       	push   $0x801142c0
801037da:	e8 7d 17 00 00       	call   80104f5c <sleep>
801037df:	83 c4 10             	add    $0x10,%esp
801037e2:	eb e0                	jmp    801037c4 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801037e4:	8b 0d 08 43 11 80    	mov    0x80114308,%ecx
801037ea:	a1 fc 42 11 80       	mov    0x801142fc,%eax
801037ef:	8d 50 01             	lea    0x1(%eax),%edx
801037f2:	89 d0                	mov    %edx,%eax
801037f4:	c1 e0 02             	shl    $0x2,%eax
801037f7:	01 d0                	add    %edx,%eax
801037f9:	01 c0                	add    %eax,%eax
801037fb:	01 c8                	add    %ecx,%eax
801037fd:	83 f8 1e             	cmp    $0x1e,%eax
80103800:	7e 17                	jle    80103819 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103802:	83 ec 08             	sub    $0x8,%esp
80103805:	68 c0 42 11 80       	push   $0x801142c0
8010380a:	68 c0 42 11 80       	push   $0x801142c0
8010380f:	e8 48 17 00 00       	call   80104f5c <sleep>
80103814:	83 c4 10             	add    $0x10,%esp
80103817:	eb ab                	jmp    801037c4 <begin_op+0x16>
    } else {
      log.outstanding += 1;
80103819:	a1 fc 42 11 80       	mov    0x801142fc,%eax
8010381e:	83 c0 01             	add    $0x1,%eax
80103821:	a3 fc 42 11 80       	mov    %eax,0x801142fc
      release(&log.lock);
80103826:	83 ec 0c             	sub    $0xc,%esp
80103829:	68 c0 42 11 80       	push   $0x801142c0
8010382e:	e8 2d 2b 00 00       	call   80106360 <release>
80103833:	83 c4 10             	add    $0x10,%esp
      break;
80103836:	90                   	nop
    }
  }
}
80103837:	90                   	nop
80103838:	c9                   	leave  
80103839:	c3                   	ret    

8010383a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010383a:	55                   	push   %ebp
8010383b:	89 e5                	mov    %esp,%ebp
8010383d:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103840:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103847:	83 ec 0c             	sub    $0xc,%esp
8010384a:	68 c0 42 11 80       	push   $0x801142c0
8010384f:	e8 a5 2a 00 00       	call   801062f9 <acquire>
80103854:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103857:	a1 fc 42 11 80       	mov    0x801142fc,%eax
8010385c:	83 e8 01             	sub    $0x1,%eax
8010385f:	a3 fc 42 11 80       	mov    %eax,0x801142fc
  if(log.committing)
80103864:	a1 00 43 11 80       	mov    0x80114300,%eax
80103869:	85 c0                	test   %eax,%eax
8010386b:	74 0d                	je     8010387a <end_op+0x40>
    panic("log.committing");
8010386d:	83 ec 0c             	sub    $0xc,%esp
80103870:	68 b0 9b 10 80       	push   $0x80109bb0
80103875:	e8 7d cd ff ff       	call   801005f7 <panic>
  if(log.outstanding == 0){
8010387a:	a1 fc 42 11 80       	mov    0x801142fc,%eax
8010387f:	85 c0                	test   %eax,%eax
80103881:	75 13                	jne    80103896 <end_op+0x5c>
    do_commit = 1;
80103883:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
8010388a:	c7 05 00 43 11 80 01 	movl   $0x1,0x80114300
80103891:	00 00 00 
80103894:	eb 10                	jmp    801038a6 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103896:	83 ec 0c             	sub    $0xc,%esp
80103899:	68 c0 42 11 80       	push   $0x801142c0
8010389e:	e8 a4 17 00 00       	call   80105047 <wakeup>
801038a3:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801038a6:	83 ec 0c             	sub    $0xc,%esp
801038a9:	68 c0 42 11 80       	push   $0x801142c0
801038ae:	e8 ad 2a 00 00       	call   80106360 <release>
801038b3:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801038b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801038ba:	74 3f                	je     801038fb <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801038bc:	e8 f5 00 00 00       	call   801039b6 <commit>
    acquire(&log.lock);
801038c1:	83 ec 0c             	sub    $0xc,%esp
801038c4:	68 c0 42 11 80       	push   $0x801142c0
801038c9:	e8 2b 2a 00 00       	call   801062f9 <acquire>
801038ce:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801038d1:	c7 05 00 43 11 80 00 	movl   $0x0,0x80114300
801038d8:	00 00 00 
    wakeup(&log);
801038db:	83 ec 0c             	sub    $0xc,%esp
801038de:	68 c0 42 11 80       	push   $0x801142c0
801038e3:	e8 5f 17 00 00       	call   80105047 <wakeup>
801038e8:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801038eb:	83 ec 0c             	sub    $0xc,%esp
801038ee:	68 c0 42 11 80       	push   $0x801142c0
801038f3:	e8 68 2a 00 00       	call   80106360 <release>
801038f8:	83 c4 10             	add    $0x10,%esp
  }
}
801038fb:	90                   	nop
801038fc:	c9                   	leave  
801038fd:	c3                   	ret    

801038fe <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801038fe:	55                   	push   %ebp
801038ff:	89 e5                	mov    %esp,%ebp
80103901:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103904:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010390b:	e9 95 00 00 00       	jmp    801039a5 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103910:	8b 15 f4 42 11 80    	mov    0x801142f4,%edx
80103916:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103919:	01 d0                	add    %edx,%eax
8010391b:	83 c0 01             	add    $0x1,%eax
8010391e:	89 c2                	mov    %eax,%edx
80103920:	a1 04 43 11 80       	mov    0x80114304,%eax
80103925:	83 ec 08             	sub    $0x8,%esp
80103928:	52                   	push   %edx
80103929:	50                   	push   %eax
8010392a:	e8 e3 c8 ff ff       	call   80100212 <bread>
8010392f:	83 c4 10             	add    $0x10,%esp
80103932:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.sector[tail]); // cache block
80103935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103938:	83 c0 10             	add    $0x10,%eax
8010393b:	8b 04 85 cc 42 11 80 	mov    -0x7feebd34(,%eax,4),%eax
80103942:	89 c2                	mov    %eax,%edx
80103944:	a1 04 43 11 80       	mov    0x80114304,%eax
80103949:	83 ec 08             	sub    $0x8,%esp
8010394c:	52                   	push   %edx
8010394d:	50                   	push   %eax
8010394e:	e8 bf c8 ff ff       	call   80100212 <bread>
80103953:	83 c4 10             	add    $0x10,%esp
80103956:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103959:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010395c:	8d 50 18             	lea    0x18(%eax),%edx
8010395f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103962:	83 c0 18             	add    $0x18,%eax
80103965:	83 ec 04             	sub    $0x4,%esp
80103968:	68 00 02 00 00       	push   $0x200
8010396d:	52                   	push   %edx
8010396e:	50                   	push   %eax
8010396f:	e8 a7 2c 00 00       	call   8010661b <memmove>
80103974:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103977:	83 ec 0c             	sub    $0xc,%esp
8010397a:	ff 75 f0             	pushl  -0x10(%ebp)
8010397d:	e8 c9 c8 ff ff       	call   8010024b <bwrite>
80103982:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
80103985:	83 ec 0c             	sub    $0xc,%esp
80103988:	ff 75 ec             	pushl  -0x14(%ebp)
8010398b:	e8 fa c8 ff ff       	call   8010028a <brelse>
80103990:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103993:	83 ec 0c             	sub    $0xc,%esp
80103996:	ff 75 f0             	pushl  -0x10(%ebp)
80103999:	e8 ec c8 ff ff       	call   8010028a <brelse>
8010399e:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801039a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801039a5:	a1 08 43 11 80       	mov    0x80114308,%eax
801039aa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801039ad:	0f 8f 5d ff ff ff    	jg     80103910 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801039b3:	90                   	nop
801039b4:	c9                   	leave  
801039b5:	c3                   	ret    

801039b6 <commit>:

static void
commit()
{
801039b6:	55                   	push   %ebp
801039b7:	89 e5                	mov    %esp,%ebp
801039b9:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801039bc:	a1 08 43 11 80       	mov    0x80114308,%eax
801039c1:	85 c0                	test   %eax,%eax
801039c3:	7e 1e                	jle    801039e3 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
801039c5:	e8 34 ff ff ff       	call   801038fe <write_log>
    write_head();    // Write header to disk -- the real commit
801039ca:	e8 3a fd ff ff       	call   80103709 <write_head>
    install_trans(); // Now install writes to home locations
801039cf:	e8 09 fc ff ff       	call   801035dd <install_trans>
    log.lh.n = 0; 
801039d4:	c7 05 08 43 11 80 00 	movl   $0x0,0x80114308
801039db:	00 00 00 
    write_head();    // Erase the transaction from the log
801039de:	e8 26 fd ff ff       	call   80103709 <write_head>
  }
}
801039e3:	90                   	nop
801039e4:	c9                   	leave  
801039e5:	c3                   	ret    

801039e6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801039e6:	55                   	push   %ebp
801039e7:	89 e5                	mov    %esp,%ebp
801039e9:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801039ec:	a1 08 43 11 80       	mov    0x80114308,%eax
801039f1:	83 f8 1d             	cmp    $0x1d,%eax
801039f4:	7f 12                	jg     80103a08 <log_write+0x22>
801039f6:	a1 08 43 11 80       	mov    0x80114308,%eax
801039fb:	8b 15 f8 42 11 80    	mov    0x801142f8,%edx
80103a01:	83 ea 01             	sub    $0x1,%edx
80103a04:	39 d0                	cmp    %edx,%eax
80103a06:	7c 0d                	jl     80103a15 <log_write+0x2f>
    panic("too big a transaction");
80103a08:	83 ec 0c             	sub    $0xc,%esp
80103a0b:	68 bf 9b 10 80       	push   $0x80109bbf
80103a10:	e8 e2 cb ff ff       	call   801005f7 <panic>
  if (log.outstanding < 1)
80103a15:	a1 fc 42 11 80       	mov    0x801142fc,%eax
80103a1a:	85 c0                	test   %eax,%eax
80103a1c:	7f 0d                	jg     80103a2b <log_write+0x45>
    panic("log_write outside of trans");
80103a1e:	83 ec 0c             	sub    $0xc,%esp
80103a21:	68 d5 9b 10 80       	push   $0x80109bd5
80103a26:	e8 cc cb ff ff       	call   801005f7 <panic>

  acquire(&log.lock);
80103a2b:	83 ec 0c             	sub    $0xc,%esp
80103a2e:	68 c0 42 11 80       	push   $0x801142c0
80103a33:	e8 c1 28 00 00       	call   801062f9 <acquire>
80103a38:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103a3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103a42:	eb 1d                	jmp    80103a61 <log_write+0x7b>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
80103a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a47:	83 c0 10             	add    $0x10,%eax
80103a4a:	8b 04 85 cc 42 11 80 	mov    -0x7feebd34(,%eax,4),%eax
80103a51:	89 c2                	mov    %eax,%edx
80103a53:	8b 45 08             	mov    0x8(%ebp),%eax
80103a56:	8b 40 08             	mov    0x8(%eax),%eax
80103a59:	39 c2                	cmp    %eax,%edx
80103a5b:	74 10                	je     80103a6d <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103a5d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a61:	a1 08 43 11 80       	mov    0x80114308,%eax
80103a66:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a69:	7f d9                	jg     80103a44 <log_write+0x5e>
80103a6b:	eb 01                	jmp    80103a6e <log_write+0x88>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
      break;
80103a6d:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
80103a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80103a71:	8b 40 08             	mov    0x8(%eax),%eax
80103a74:	89 c2                	mov    %eax,%edx
80103a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a79:	83 c0 10             	add    $0x10,%eax
80103a7c:	89 14 85 cc 42 11 80 	mov    %edx,-0x7feebd34(,%eax,4)
  if (i == log.lh.n)
80103a83:	a1 08 43 11 80       	mov    0x80114308,%eax
80103a88:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a8b:	75 0d                	jne    80103a9a <log_write+0xb4>
    log.lh.n++;
80103a8d:	a1 08 43 11 80       	mov    0x80114308,%eax
80103a92:	83 c0 01             	add    $0x1,%eax
80103a95:	a3 08 43 11 80       	mov    %eax,0x80114308
  b->flags |= B_DIRTY; // prevent eviction
80103a9a:	8b 45 08             	mov    0x8(%ebp),%eax
80103a9d:	8b 00                	mov    (%eax),%eax
80103a9f:	83 c8 04             	or     $0x4,%eax
80103aa2:	89 c2                	mov    %eax,%edx
80103aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80103aa7:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103aa9:	83 ec 0c             	sub    $0xc,%esp
80103aac:	68 c0 42 11 80       	push   $0x801142c0
80103ab1:	e8 aa 28 00 00       	call   80106360 <release>
80103ab6:	83 c4 10             	add    $0x10,%esp
}
80103ab9:	90                   	nop
80103aba:	c9                   	leave  
80103abb:	c3                   	ret    

80103abc <v2p>:
80103abc:	55                   	push   %ebp
80103abd:	89 e5                	mov    %esp,%ebp
80103abf:	8b 45 08             	mov    0x8(%ebp),%eax
80103ac2:	05 00 00 00 80       	add    $0x80000000,%eax
80103ac7:	5d                   	pop    %ebp
80103ac8:	c3                   	ret    

80103ac9 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103ac9:	55                   	push   %ebp
80103aca:	89 e5                	mov    %esp,%ebp
80103acc:	8b 45 08             	mov    0x8(%ebp),%eax
80103acf:	05 00 00 00 80       	add    $0x80000000,%eax
80103ad4:	5d                   	pop    %ebp
80103ad5:	c3                   	ret    

80103ad6 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103ad6:	55                   	push   %ebp
80103ad7:	89 e5                	mov    %esp,%ebp
80103ad9:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103adc:	8b 55 08             	mov    0x8(%ebp),%edx
80103adf:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ae2:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103ae5:	f0 87 02             	lock xchg %eax,(%edx)
80103ae8:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103aeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103aee:	c9                   	leave  
80103aef:	c3                   	ret    

80103af0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103af0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103af4:	83 e4 f0             	and    $0xfffffff0,%esp
80103af7:	ff 71 fc             	pushl  -0x4(%ecx)
80103afa:	55                   	push   %ebp
80103afb:	89 e5                	mov    %esp,%ebp
80103afd:	51                   	push   %ecx
80103afe:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103b01:	83 ec 08             	sub    $0x8,%esp
80103b04:	68 00 00 40 80       	push   $0x80400000
80103b09:	68 9c 71 11 80       	push   $0x8011719c
80103b0e:	e8 75 f2 ff ff       	call   80102d88 <kinit1>
80103b13:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103b16:	e8 ef 56 00 00       	call   8010920a <kvmalloc>
  mpinit();        // collect info about this machine
80103b1b:	e8 4d 04 00 00       	call   80103f6d <mpinit>
  lapicinit();
80103b20:	e8 e2 f5 ff ff       	call   80103107 <lapicinit>
  seginit();       // set up segments
80103b25:	e8 89 50 00 00       	call   80108bb3 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103b2a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103b30:	0f b6 00             	movzbl (%eax),%eax
80103b33:	0f b6 c0             	movzbl %al,%eax
80103b36:	83 ec 08             	sub    $0x8,%esp
80103b39:	50                   	push   %eax
80103b3a:	68 f0 9b 10 80       	push   $0x80109bf0
80103b3f:	e8 13 c9 ff ff       	call   80100457 <cprintf>
80103b44:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103b47:	e8 77 06 00 00       	call   801041c3 <picinit>
  ioapicinit();    // another interrupt controller
80103b4c:	e8 2c f1 ff ff       	call   80102c7d <ioapicinit>
  procfsinit();
80103b51:	e8 1b 27 00 00       	call   80106271 <procfsinit>
  consoleinit();   // I/O devices & their interrupts
80103b56:	e8 1f d0 ff ff       	call   80100b7a <consoleinit>
  uartinit();      // serial port
80103b5b:	e8 af 43 00 00       	call   80107f0f <uartinit>
  pinit();         // process table
80103b60:	e8 5b 0b 00 00       	call   801046c0 <pinit>
  tvinit();        // trap vectors
80103b65:	e8 6f 3f 00 00       	call   80107ad9 <tvinit>
  binit();         // buffer cache
80103b6a:	e8 c5 c4 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103b6f:	e8 77 d4 ff ff       	call   80100feb <fileinit>
  iinit();         // inode cache
80103b74:	e8 85 db ff ff       	call   801016fe <iinit>
  ideinit();       // disk
80103b79:	e8 43 ed ff ff       	call   801028c1 <ideinit>
  if(!ismp)
80103b7e:	a1 a4 43 11 80       	mov    0x801143a4,%eax
80103b83:	85 c0                	test   %eax,%eax
80103b85:	75 05                	jne    80103b8c <main+0x9c>
    timerinit();   // uniprocessor timer
80103b87:	e8 aa 3e 00 00       	call   80107a36 <timerinit>
  startothers();   // start other processors
80103b8c:	e8 7f 00 00 00       	call   80103c10 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103b91:	83 ec 08             	sub    $0x8,%esp
80103b94:	68 00 00 00 8e       	push   $0x8e000000
80103b99:	68 00 00 40 80       	push   $0x80400000
80103b9e:	e8 1e f2 ff ff       	call   80102dc1 <kinit2>
80103ba3:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103ba6:	e8 39 0c 00 00       	call   801047e4 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103bab:	e8 1a 00 00 00       	call   80103bca <mpmain>

80103bb0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103bb6:	e8 67 56 00 00       	call   80109222 <switchkvm>
  seginit();
80103bbb:	e8 f3 4f 00 00       	call   80108bb3 <seginit>
  lapicinit();
80103bc0:	e8 42 f5 ff ff       	call   80103107 <lapicinit>
  mpmain();
80103bc5:	e8 00 00 00 00       	call   80103bca <mpmain>

80103bca <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103bca:	55                   	push   %ebp
80103bcb:	89 e5                	mov    %esp,%ebp
80103bcd:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103bd0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103bd6:	0f b6 00             	movzbl (%eax),%eax
80103bd9:	0f b6 c0             	movzbl %al,%eax
80103bdc:	83 ec 08             	sub    $0x8,%esp
80103bdf:	50                   	push   %eax
80103be0:	68 07 9c 10 80       	push   $0x80109c07
80103be5:	e8 6d c8 ff ff       	call   80100457 <cprintf>
80103bea:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103bed:	e8 5d 40 00 00       	call   80107c4f <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103bf2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103bf8:	05 a8 00 00 00       	add    $0xa8,%eax
80103bfd:	83 ec 08             	sub    $0x8,%esp
80103c00:	6a 01                	push   $0x1
80103c02:	50                   	push   %eax
80103c03:	e8 ce fe ff ff       	call   80103ad6 <xchg>
80103c08:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103c0b:	e8 7f 11 00 00       	call   80104d8f <scheduler>

80103c10 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	53                   	push   %ebx
80103c14:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103c17:	68 00 70 00 00       	push   $0x7000
80103c1c:	e8 a8 fe ff ff       	call   80103ac9 <p2v>
80103c21:	83 c4 04             	add    $0x4,%esp
80103c24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103c27:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103c2c:	83 ec 04             	sub    $0x4,%esp
80103c2f:	50                   	push   %eax
80103c30:	68 0c d5 10 80       	push   $0x8010d50c
80103c35:	ff 75 f0             	pushl  -0x10(%ebp)
80103c38:	e8 de 29 00 00       	call   8010661b <memmove>
80103c3d:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103c40:	c7 45 f4 c0 43 11 80 	movl   $0x801143c0,-0xc(%ebp)
80103c47:	e9 90 00 00 00       	jmp    80103cdc <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103c4c:	e8 d4 f5 ff ff       	call   80103225 <cpunum>
80103c51:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103c57:	05 c0 43 11 80       	add    $0x801143c0,%eax
80103c5c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103c5f:	74 73                	je     80103cd4 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103c61:	e8 59 f2 ff ff       	call   80102ebf <kalloc>
80103c66:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c6c:	83 e8 04             	sub    $0x4,%eax
80103c6f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103c72:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103c78:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c7d:	83 e8 08             	sub    $0x8,%eax
80103c80:	c7 00 b0 3b 10 80    	movl   $0x80103bb0,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c89:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103c8c:	83 ec 0c             	sub    $0xc,%esp
80103c8f:	68 00 c0 10 80       	push   $0x8010c000
80103c94:	e8 23 fe ff ff       	call   80103abc <v2p>
80103c99:	83 c4 10             	add    $0x10,%esp
80103c9c:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103c9e:	83 ec 0c             	sub    $0xc,%esp
80103ca1:	ff 75 f0             	pushl  -0x10(%ebp)
80103ca4:	e8 13 fe ff ff       	call   80103abc <v2p>
80103ca9:	83 c4 10             	add    $0x10,%esp
80103cac:	89 c2                	mov    %eax,%edx
80103cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb1:	0f b6 00             	movzbl (%eax),%eax
80103cb4:	0f b6 c0             	movzbl %al,%eax
80103cb7:	83 ec 08             	sub    $0x8,%esp
80103cba:	52                   	push   %edx
80103cbb:	50                   	push   %eax
80103cbc:	e8 de f5 ff ff       	call   8010329f <lapicstartap>
80103cc1:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103cc4:	90                   	nop
80103cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc8:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103cce:	85 c0                	test   %eax,%eax
80103cd0:	74 f3                	je     80103cc5 <startothers+0xb5>
80103cd2:	eb 01                	jmp    80103cd5 <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103cd4:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103cd5:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103cdc:	a1 a0 49 11 80       	mov    0x801149a0,%eax
80103ce1:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103ce7:	05 c0 43 11 80       	add    $0x801143c0,%eax
80103cec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103cef:	0f 87 57 ff ff ff    	ja     80103c4c <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103cf5:	90                   	nop
80103cf6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cf9:	c9                   	leave  
80103cfa:	c3                   	ret    

80103cfb <p2v>:
80103cfb:	55                   	push   %ebp
80103cfc:	89 e5                	mov    %esp,%ebp
80103cfe:	8b 45 08             	mov    0x8(%ebp),%eax
80103d01:	05 00 00 00 80       	add    $0x80000000,%eax
80103d06:	5d                   	pop    %ebp
80103d07:	c3                   	ret    

80103d08 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103d08:	55                   	push   %ebp
80103d09:	89 e5                	mov    %esp,%ebp
80103d0b:	83 ec 14             	sub    $0x14,%esp
80103d0e:	8b 45 08             	mov    0x8(%ebp),%eax
80103d11:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d15:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103d19:	89 c2                	mov    %eax,%edx
80103d1b:	ec                   	in     (%dx),%al
80103d1c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103d1f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103d23:	c9                   	leave  
80103d24:	c3                   	ret    

80103d25 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103d25:	55                   	push   %ebp
80103d26:	89 e5                	mov    %esp,%ebp
80103d28:	83 ec 08             	sub    $0x8,%esp
80103d2b:	8b 55 08             	mov    0x8(%ebp),%edx
80103d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d31:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103d35:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d38:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103d3c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103d40:	ee                   	out    %al,(%dx)
}
80103d41:	90                   	nop
80103d42:	c9                   	leave  
80103d43:	c3                   	ret    

80103d44 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103d44:	55                   	push   %ebp
80103d45:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103d47:	a1 44 d6 10 80       	mov    0x8010d644,%eax
80103d4c:	89 c2                	mov    %eax,%edx
80103d4e:	b8 c0 43 11 80       	mov    $0x801143c0,%eax
80103d53:	29 c2                	sub    %eax,%edx
80103d55:	89 d0                	mov    %edx,%eax
80103d57:	c1 f8 02             	sar    $0x2,%eax
80103d5a:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103d60:	5d                   	pop    %ebp
80103d61:	c3                   	ret    

80103d62 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103d62:	55                   	push   %ebp
80103d63:	89 e5                	mov    %esp,%ebp
80103d65:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103d68:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103d6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103d76:	eb 15                	jmp    80103d8d <sum+0x2b>
    sum += addr[i];
80103d78:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103d7b:	8b 45 08             	mov    0x8(%ebp),%eax
80103d7e:	01 d0                	add    %edx,%eax
80103d80:	0f b6 00             	movzbl (%eax),%eax
80103d83:	0f b6 c0             	movzbl %al,%eax
80103d86:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103d89:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103d8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103d90:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103d93:	7c e3                	jl     80103d78 <sum+0x16>
    sum += addr[i];
  return sum;
80103d95:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103d98:	c9                   	leave  
80103d99:	c3                   	ret    

80103d9a <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103d9a:	55                   	push   %ebp
80103d9b:	89 e5                	mov    %esp,%ebp
80103d9d:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103da0:	ff 75 08             	pushl  0x8(%ebp)
80103da3:	e8 53 ff ff ff       	call   80103cfb <p2v>
80103da8:	83 c4 04             	add    $0x4,%esp
80103dab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103dae:	8b 55 0c             	mov    0xc(%ebp),%edx
80103db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103db4:	01 d0                	add    %edx,%eax
80103db6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103dbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103dbf:	eb 36                	jmp    80103df7 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103dc1:	83 ec 04             	sub    $0x4,%esp
80103dc4:	6a 04                	push   $0x4
80103dc6:	68 18 9c 10 80       	push   $0x80109c18
80103dcb:	ff 75 f4             	pushl  -0xc(%ebp)
80103dce:	e8 f0 27 00 00       	call   801065c3 <memcmp>
80103dd3:	83 c4 10             	add    $0x10,%esp
80103dd6:	85 c0                	test   %eax,%eax
80103dd8:	75 19                	jne    80103df3 <mpsearch1+0x59>
80103dda:	83 ec 08             	sub    $0x8,%esp
80103ddd:	6a 10                	push   $0x10
80103ddf:	ff 75 f4             	pushl  -0xc(%ebp)
80103de2:	e8 7b ff ff ff       	call   80103d62 <sum>
80103de7:	83 c4 10             	add    $0x10,%esp
80103dea:	84 c0                	test   %al,%al
80103dec:	75 05                	jne    80103df3 <mpsearch1+0x59>
      return (struct mp*)p;
80103dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103df1:	eb 11                	jmp    80103e04 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103df3:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dfa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103dfd:	72 c2                	jb     80103dc1 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103dff:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103e04:	c9                   	leave  
80103e05:	c3                   	ret    

80103e06 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103e06:	55                   	push   %ebp
80103e07:	89 e5                	mov    %esp,%ebp
80103e09:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103e0c:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e16:	83 c0 0f             	add    $0xf,%eax
80103e19:	0f b6 00             	movzbl (%eax),%eax
80103e1c:	0f b6 c0             	movzbl %al,%eax
80103e1f:	c1 e0 08             	shl    $0x8,%eax
80103e22:	89 c2                	mov    %eax,%edx
80103e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e27:	83 c0 0e             	add    $0xe,%eax
80103e2a:	0f b6 00             	movzbl (%eax),%eax
80103e2d:	0f b6 c0             	movzbl %al,%eax
80103e30:	09 d0                	or     %edx,%eax
80103e32:	c1 e0 04             	shl    $0x4,%eax
80103e35:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103e38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103e3c:	74 21                	je     80103e5f <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103e3e:	83 ec 08             	sub    $0x8,%esp
80103e41:	68 00 04 00 00       	push   $0x400
80103e46:	ff 75 f0             	pushl  -0x10(%ebp)
80103e49:	e8 4c ff ff ff       	call   80103d9a <mpsearch1>
80103e4e:	83 c4 10             	add    $0x10,%esp
80103e51:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103e54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103e58:	74 51                	je     80103eab <mpsearch+0xa5>
      return mp;
80103e5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103e5d:	eb 61                	jmp    80103ec0 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e62:	83 c0 14             	add    $0x14,%eax
80103e65:	0f b6 00             	movzbl (%eax),%eax
80103e68:	0f b6 c0             	movzbl %al,%eax
80103e6b:	c1 e0 08             	shl    $0x8,%eax
80103e6e:	89 c2                	mov    %eax,%edx
80103e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e73:	83 c0 13             	add    $0x13,%eax
80103e76:	0f b6 00             	movzbl (%eax),%eax
80103e79:	0f b6 c0             	movzbl %al,%eax
80103e7c:	09 d0                	or     %edx,%eax
80103e7e:	c1 e0 0a             	shl    $0xa,%eax
80103e81:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e87:	2d 00 04 00 00       	sub    $0x400,%eax
80103e8c:	83 ec 08             	sub    $0x8,%esp
80103e8f:	68 00 04 00 00       	push   $0x400
80103e94:	50                   	push   %eax
80103e95:	e8 00 ff ff ff       	call   80103d9a <mpsearch1>
80103e9a:	83 c4 10             	add    $0x10,%esp
80103e9d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ea0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103ea4:	74 05                	je     80103eab <mpsearch+0xa5>
      return mp;
80103ea6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ea9:	eb 15                	jmp    80103ec0 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103eab:	83 ec 08             	sub    $0x8,%esp
80103eae:	68 00 00 01 00       	push   $0x10000
80103eb3:	68 00 00 0f 00       	push   $0xf0000
80103eb8:	e8 dd fe ff ff       	call   80103d9a <mpsearch1>
80103ebd:	83 c4 10             	add    $0x10,%esp
}
80103ec0:	c9                   	leave  
80103ec1:	c3                   	ret    

80103ec2 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103ec2:	55                   	push   %ebp
80103ec3:	89 e5                	mov    %esp,%ebp
80103ec5:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103ec8:	e8 39 ff ff ff       	call   80103e06 <mpsearch>
80103ecd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ed0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103ed4:	74 0a                	je     80103ee0 <mpconfig+0x1e>
80103ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed9:	8b 40 04             	mov    0x4(%eax),%eax
80103edc:	85 c0                	test   %eax,%eax
80103ede:	75 0a                	jne    80103eea <mpconfig+0x28>
    return 0;
80103ee0:	b8 00 00 00 00       	mov    $0x0,%eax
80103ee5:	e9 81 00 00 00       	jmp    80103f6b <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103eed:	8b 40 04             	mov    0x4(%eax),%eax
80103ef0:	83 ec 0c             	sub    $0xc,%esp
80103ef3:	50                   	push   %eax
80103ef4:	e8 02 fe ff ff       	call   80103cfb <p2v>
80103ef9:	83 c4 10             	add    $0x10,%esp
80103efc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103eff:	83 ec 04             	sub    $0x4,%esp
80103f02:	6a 04                	push   $0x4
80103f04:	68 1d 9c 10 80       	push   $0x80109c1d
80103f09:	ff 75 f0             	pushl  -0x10(%ebp)
80103f0c:	e8 b2 26 00 00       	call   801065c3 <memcmp>
80103f11:	83 c4 10             	add    $0x10,%esp
80103f14:	85 c0                	test   %eax,%eax
80103f16:	74 07                	je     80103f1f <mpconfig+0x5d>
    return 0;
80103f18:	b8 00 00 00 00       	mov    $0x0,%eax
80103f1d:	eb 4c                	jmp    80103f6b <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f22:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103f26:	3c 01                	cmp    $0x1,%al
80103f28:	74 12                	je     80103f3c <mpconfig+0x7a>
80103f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f2d:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103f31:	3c 04                	cmp    $0x4,%al
80103f33:	74 07                	je     80103f3c <mpconfig+0x7a>
    return 0;
80103f35:	b8 00 00 00 00       	mov    $0x0,%eax
80103f3a:	eb 2f                	jmp    80103f6b <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f3f:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103f43:	0f b7 c0             	movzwl %ax,%eax
80103f46:	83 ec 08             	sub    $0x8,%esp
80103f49:	50                   	push   %eax
80103f4a:	ff 75 f0             	pushl  -0x10(%ebp)
80103f4d:	e8 10 fe ff ff       	call   80103d62 <sum>
80103f52:	83 c4 10             	add    $0x10,%esp
80103f55:	84 c0                	test   %al,%al
80103f57:	74 07                	je     80103f60 <mpconfig+0x9e>
    return 0;
80103f59:	b8 00 00 00 00       	mov    $0x0,%eax
80103f5e:	eb 0b                	jmp    80103f6b <mpconfig+0xa9>
  *pmp = mp;
80103f60:	8b 45 08             	mov    0x8(%ebp),%eax
80103f63:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f66:	89 10                	mov    %edx,(%eax)
  return conf;
80103f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103f6b:	c9                   	leave  
80103f6c:	c3                   	ret    

80103f6d <mpinit>:

void
mpinit(void)
{
80103f6d:	55                   	push   %ebp
80103f6e:	89 e5                	mov    %esp,%ebp
80103f70:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103f73:	c7 05 44 d6 10 80 c0 	movl   $0x801143c0,0x8010d644
80103f7a:	43 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103f7d:	83 ec 0c             	sub    $0xc,%esp
80103f80:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103f83:	50                   	push   %eax
80103f84:	e8 39 ff ff ff       	call   80103ec2 <mpconfig>
80103f89:	83 c4 10             	add    $0x10,%esp
80103f8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103f8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103f93:	0f 84 96 01 00 00    	je     8010412f <mpinit+0x1c2>
    return;
  ismp = 1;
80103f99:	c7 05 a4 43 11 80 01 	movl   $0x1,0x801143a4
80103fa0:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103fa6:	8b 40 24             	mov    0x24(%eax),%eax
80103fa9:	a3 bc 42 11 80       	mov    %eax,0x801142bc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103fb1:	83 c0 2c             	add    $0x2c,%eax
80103fb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103fb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103fba:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103fbe:	0f b7 d0             	movzwl %ax,%edx
80103fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103fc4:	01 d0                	add    %edx,%eax
80103fc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103fc9:	e9 f2 00 00 00       	jmp    801040c0 <mpinit+0x153>
    switch(*p){
80103fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fd1:	0f b6 00             	movzbl (%eax),%eax
80103fd4:	0f b6 c0             	movzbl %al,%eax
80103fd7:	83 f8 04             	cmp    $0x4,%eax
80103fda:	0f 87 bc 00 00 00    	ja     8010409c <mpinit+0x12f>
80103fe0:	8b 04 85 60 9c 10 80 	mov    -0x7fef63a0(,%eax,4),%eax
80103fe7:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fec:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103fef:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103ff2:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103ff6:	0f b6 d0             	movzbl %al,%edx
80103ff9:	a1 a0 49 11 80       	mov    0x801149a0,%eax
80103ffe:	39 c2                	cmp    %eax,%edx
80104000:	74 2b                	je     8010402d <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80104002:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104005:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80104009:	0f b6 d0             	movzbl %al,%edx
8010400c:	a1 a0 49 11 80       	mov    0x801149a0,%eax
80104011:	83 ec 04             	sub    $0x4,%esp
80104014:	52                   	push   %edx
80104015:	50                   	push   %eax
80104016:	68 22 9c 10 80       	push   $0x80109c22
8010401b:	e8 37 c4 ff ff       	call   80100457 <cprintf>
80104020:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80104023:	c7 05 a4 43 11 80 00 	movl   $0x0,0x801143a4
8010402a:	00 00 00 
      }
      if(proc->flags & MPBOOT)
8010402d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104030:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80104034:	0f b6 c0             	movzbl %al,%eax
80104037:	83 e0 02             	and    $0x2,%eax
8010403a:	85 c0                	test   %eax,%eax
8010403c:	74 15                	je     80104053 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
8010403e:	a1 a0 49 11 80       	mov    0x801149a0,%eax
80104043:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80104049:	05 c0 43 11 80       	add    $0x801143c0,%eax
8010404e:	a3 44 d6 10 80       	mov    %eax,0x8010d644
      cpus[ncpu].id = ncpu;
80104053:	a1 a0 49 11 80       	mov    0x801149a0,%eax
80104058:	8b 15 a0 49 11 80    	mov    0x801149a0,%edx
8010405e:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80104064:	05 c0 43 11 80       	add    $0x801143c0,%eax
80104069:	88 10                	mov    %dl,(%eax)
      ncpu++;
8010406b:	a1 a0 49 11 80       	mov    0x801149a0,%eax
80104070:	83 c0 01             	add    $0x1,%eax
80104073:	a3 a0 49 11 80       	mov    %eax,0x801149a0
      p += sizeof(struct mpproc);
80104078:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
8010407c:	eb 42                	jmp    801040c0 <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
8010407e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104081:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80104084:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104087:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010408b:	a2 a0 43 11 80       	mov    %al,0x801143a0
      p += sizeof(struct mpioapic);
80104090:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80104094:	eb 2a                	jmp    801040c0 <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80104096:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
8010409a:	eb 24                	jmp    801040c0 <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
8010409c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010409f:	0f b6 00             	movzbl (%eax),%eax
801040a2:	0f b6 c0             	movzbl %al,%eax
801040a5:	83 ec 08             	sub    $0x8,%esp
801040a8:	50                   	push   %eax
801040a9:	68 40 9c 10 80       	push   $0x80109c40
801040ae:	e8 a4 c3 ff ff       	call   80100457 <cprintf>
801040b3:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
801040b6:	c7 05 a4 43 11 80 00 	movl   $0x0,0x801143a4
801040bd:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801040c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801040c6:	0f 82 02 ff ff ff    	jb     80103fce <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
801040cc:	a1 a4 43 11 80       	mov    0x801143a4,%eax
801040d1:	85 c0                	test   %eax,%eax
801040d3:	75 1d                	jne    801040f2 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801040d5:	c7 05 a0 49 11 80 01 	movl   $0x1,0x801149a0
801040dc:	00 00 00 
    lapic = 0;
801040df:	c7 05 bc 42 11 80 00 	movl   $0x0,0x801142bc
801040e6:	00 00 00 
    ioapicid = 0;
801040e9:	c6 05 a0 43 11 80 00 	movb   $0x0,0x801143a0
    return;
801040f0:	eb 3e                	jmp    80104130 <mpinit+0x1c3>
  }

  if(mp->imcrp){
801040f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801040f5:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801040f9:	84 c0                	test   %al,%al
801040fb:	74 33                	je     80104130 <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
801040fd:	83 ec 08             	sub    $0x8,%esp
80104100:	6a 70                	push   $0x70
80104102:	6a 22                	push   $0x22
80104104:	e8 1c fc ff ff       	call   80103d25 <outb>
80104109:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010410c:	83 ec 0c             	sub    $0xc,%esp
8010410f:	6a 23                	push   $0x23
80104111:	e8 f2 fb ff ff       	call   80103d08 <inb>
80104116:	83 c4 10             	add    $0x10,%esp
80104119:	83 c8 01             	or     $0x1,%eax
8010411c:	0f b6 c0             	movzbl %al,%eax
8010411f:	83 ec 08             	sub    $0x8,%esp
80104122:	50                   	push   %eax
80104123:	6a 23                	push   $0x23
80104125:	e8 fb fb ff ff       	call   80103d25 <outb>
8010412a:	83 c4 10             	add    $0x10,%esp
8010412d:	eb 01                	jmp    80104130 <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
8010412f:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80104130:	c9                   	leave  
80104131:	c3                   	ret    

80104132 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80104132:	55                   	push   %ebp
80104133:	89 e5                	mov    %esp,%ebp
80104135:	83 ec 08             	sub    $0x8,%esp
80104138:	8b 55 08             	mov    0x8(%ebp),%edx
8010413b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010413e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80104142:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104145:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80104149:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010414d:	ee                   	out    %al,(%dx)
}
8010414e:	90                   	nop
8010414f:	c9                   	leave  
80104150:	c3                   	ret    

80104151 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80104151:	55                   	push   %ebp
80104152:	89 e5                	mov    %esp,%ebp
80104154:	83 ec 04             	sub    $0x4,%esp
80104157:	8b 45 08             	mov    0x8(%ebp),%eax
8010415a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
8010415e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80104162:	66 a3 00 d0 10 80    	mov    %ax,0x8010d000
  outb(IO_PIC1+1, mask);
80104168:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010416c:	0f b6 c0             	movzbl %al,%eax
8010416f:	50                   	push   %eax
80104170:	6a 21                	push   $0x21
80104172:	e8 bb ff ff ff       	call   80104132 <outb>
80104177:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
8010417a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010417e:	66 c1 e8 08          	shr    $0x8,%ax
80104182:	0f b6 c0             	movzbl %al,%eax
80104185:	50                   	push   %eax
80104186:	68 a1 00 00 00       	push   $0xa1
8010418b:	e8 a2 ff ff ff       	call   80104132 <outb>
80104190:	83 c4 08             	add    $0x8,%esp
}
80104193:	90                   	nop
80104194:	c9                   	leave  
80104195:	c3                   	ret    

80104196 <picenable>:

void
picenable(int irq)
{
80104196:	55                   	push   %ebp
80104197:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80104199:	8b 45 08             	mov    0x8(%ebp),%eax
8010419c:	ba 01 00 00 00       	mov    $0x1,%edx
801041a1:	89 c1                	mov    %eax,%ecx
801041a3:	d3 e2                	shl    %cl,%edx
801041a5:	89 d0                	mov    %edx,%eax
801041a7:	f7 d0                	not    %eax
801041a9:	89 c2                	mov    %eax,%edx
801041ab:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
801041b2:	21 d0                	and    %edx,%eax
801041b4:	0f b7 c0             	movzwl %ax,%eax
801041b7:	50                   	push   %eax
801041b8:	e8 94 ff ff ff       	call   80104151 <picsetmask>
801041bd:	83 c4 04             	add    $0x4,%esp
}
801041c0:	90                   	nop
801041c1:	c9                   	leave  
801041c2:	c3                   	ret    

801041c3 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
801041c3:	55                   	push   %ebp
801041c4:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
801041c6:	68 ff 00 00 00       	push   $0xff
801041cb:	6a 21                	push   $0x21
801041cd:	e8 60 ff ff ff       	call   80104132 <outb>
801041d2:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
801041d5:	68 ff 00 00 00       	push   $0xff
801041da:	68 a1 00 00 00       	push   $0xa1
801041df:	e8 4e ff ff ff       	call   80104132 <outb>
801041e4:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
801041e7:	6a 11                	push   $0x11
801041e9:	6a 20                	push   $0x20
801041eb:	e8 42 ff ff ff       	call   80104132 <outb>
801041f0:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
801041f3:	6a 20                	push   $0x20
801041f5:	6a 21                	push   $0x21
801041f7:	e8 36 ff ff ff       	call   80104132 <outb>
801041fc:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
801041ff:	6a 04                	push   $0x4
80104201:	6a 21                	push   $0x21
80104203:	e8 2a ff ff ff       	call   80104132 <outb>
80104208:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
8010420b:	6a 03                	push   $0x3
8010420d:	6a 21                	push   $0x21
8010420f:	e8 1e ff ff ff       	call   80104132 <outb>
80104214:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80104217:	6a 11                	push   $0x11
80104219:	68 a0 00 00 00       	push   $0xa0
8010421e:	e8 0f ff ff ff       	call   80104132 <outb>
80104223:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80104226:	6a 28                	push   $0x28
80104228:	68 a1 00 00 00       	push   $0xa1
8010422d:	e8 00 ff ff ff       	call   80104132 <outb>
80104232:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80104235:	6a 02                	push   $0x2
80104237:	68 a1 00 00 00       	push   $0xa1
8010423c:	e8 f1 fe ff ff       	call   80104132 <outb>
80104241:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80104244:	6a 03                	push   $0x3
80104246:	68 a1 00 00 00       	push   $0xa1
8010424b:	e8 e2 fe ff ff       	call   80104132 <outb>
80104250:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80104253:	6a 68                	push   $0x68
80104255:	6a 20                	push   $0x20
80104257:	e8 d6 fe ff ff       	call   80104132 <outb>
8010425c:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
8010425f:	6a 0a                	push   $0xa
80104261:	6a 20                	push   $0x20
80104263:	e8 ca fe ff ff       	call   80104132 <outb>
80104268:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
8010426b:	6a 68                	push   $0x68
8010426d:	68 a0 00 00 00       	push   $0xa0
80104272:	e8 bb fe ff ff       	call   80104132 <outb>
80104277:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
8010427a:	6a 0a                	push   $0xa
8010427c:	68 a0 00 00 00       	push   $0xa0
80104281:	e8 ac fe ff ff       	call   80104132 <outb>
80104286:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80104289:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
80104290:	66 83 f8 ff          	cmp    $0xffff,%ax
80104294:	74 13                	je     801042a9 <picinit+0xe6>
    picsetmask(irqmask);
80104296:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
8010429d:	0f b7 c0             	movzwl %ax,%eax
801042a0:	50                   	push   %eax
801042a1:	e8 ab fe ff ff       	call   80104151 <picsetmask>
801042a6:	83 c4 04             	add    $0x4,%esp
}
801042a9:	90                   	nop
801042aa:	c9                   	leave  
801042ab:	c3                   	ret    

801042ac <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801042ac:	55                   	push   %ebp
801042ad:	89 e5                	mov    %esp,%ebp
801042af:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
801042b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
801042b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801042bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801042c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801042c5:	8b 10                	mov    (%eax),%edx
801042c7:	8b 45 08             	mov    0x8(%ebp),%eax
801042ca:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801042cc:	e8 38 cd ff ff       	call   80101009 <filealloc>
801042d1:	89 c2                	mov    %eax,%edx
801042d3:	8b 45 08             	mov    0x8(%ebp),%eax
801042d6:	89 10                	mov    %edx,(%eax)
801042d8:	8b 45 08             	mov    0x8(%ebp),%eax
801042db:	8b 00                	mov    (%eax),%eax
801042dd:	85 c0                	test   %eax,%eax
801042df:	0f 84 cb 00 00 00    	je     801043b0 <pipealloc+0x104>
801042e5:	e8 1f cd ff ff       	call   80101009 <filealloc>
801042ea:	89 c2                	mov    %eax,%edx
801042ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801042ef:	89 10                	mov    %edx,(%eax)
801042f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801042f4:	8b 00                	mov    (%eax),%eax
801042f6:	85 c0                	test   %eax,%eax
801042f8:	0f 84 b2 00 00 00    	je     801043b0 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801042fe:	e8 bc eb ff ff       	call   80102ebf <kalloc>
80104303:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104306:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010430a:	0f 84 9f 00 00 00    	je     801043af <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
80104310:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104313:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010431a:	00 00 00 
  p->writeopen = 1;
8010431d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104320:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104327:	00 00 00 
  p->nwrite = 0;
8010432a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010432d:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104334:	00 00 00 
  p->nread = 0;
80104337:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010433a:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104341:	00 00 00 
  initlock(&p->lock, "pipe");
80104344:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104347:	83 ec 08             	sub    $0x8,%esp
8010434a:	68 74 9c 10 80       	push   $0x80109c74
8010434f:	50                   	push   %eax
80104350:	e8 82 1f 00 00       	call   801062d7 <initlock>
80104355:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104358:	8b 45 08             	mov    0x8(%ebp),%eax
8010435b:	8b 00                	mov    (%eax),%eax
8010435d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104363:	8b 45 08             	mov    0x8(%ebp),%eax
80104366:	8b 00                	mov    (%eax),%eax
80104368:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010436c:	8b 45 08             	mov    0x8(%ebp),%eax
8010436f:	8b 00                	mov    (%eax),%eax
80104371:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104375:	8b 45 08             	mov    0x8(%ebp),%eax
80104378:	8b 00                	mov    (%eax),%eax
8010437a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010437d:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104380:	8b 45 0c             	mov    0xc(%ebp),%eax
80104383:	8b 00                	mov    (%eax),%eax
80104385:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010438b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010438e:	8b 00                	mov    (%eax),%eax
80104390:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104394:	8b 45 0c             	mov    0xc(%ebp),%eax
80104397:	8b 00                	mov    (%eax),%eax
80104399:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010439d:	8b 45 0c             	mov    0xc(%ebp),%eax
801043a0:	8b 00                	mov    (%eax),%eax
801043a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043a5:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801043a8:	b8 00 00 00 00       	mov    $0x0,%eax
801043ad:	eb 4e                	jmp    801043fd <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
801043af:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
801043b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801043b4:	74 0e                	je     801043c4 <pipealloc+0x118>
    kfree((char*)p);
801043b6:	83 ec 0c             	sub    $0xc,%esp
801043b9:	ff 75 f4             	pushl  -0xc(%ebp)
801043bc:	e8 61 ea ff ff       	call   80102e22 <kfree>
801043c1:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801043c4:	8b 45 08             	mov    0x8(%ebp),%eax
801043c7:	8b 00                	mov    (%eax),%eax
801043c9:	85 c0                	test   %eax,%eax
801043cb:	74 11                	je     801043de <pipealloc+0x132>
    fileclose(*f0);
801043cd:	8b 45 08             	mov    0x8(%ebp),%eax
801043d0:	8b 00                	mov    (%eax),%eax
801043d2:	83 ec 0c             	sub    $0xc,%esp
801043d5:	50                   	push   %eax
801043d6:	e8 ec cc ff ff       	call   801010c7 <fileclose>
801043db:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801043de:	8b 45 0c             	mov    0xc(%ebp),%eax
801043e1:	8b 00                	mov    (%eax),%eax
801043e3:	85 c0                	test   %eax,%eax
801043e5:	74 11                	je     801043f8 <pipealloc+0x14c>
    fileclose(*f1);
801043e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801043ea:	8b 00                	mov    (%eax),%eax
801043ec:	83 ec 0c             	sub    $0xc,%esp
801043ef:	50                   	push   %eax
801043f0:	e8 d2 cc ff ff       	call   801010c7 <fileclose>
801043f5:	83 c4 10             	add    $0x10,%esp
  return -1;
801043f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043fd:	c9                   	leave  
801043fe:	c3                   	ret    

801043ff <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801043ff:	55                   	push   %ebp
80104400:	89 e5                	mov    %esp,%ebp
80104402:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80104405:	8b 45 08             	mov    0x8(%ebp),%eax
80104408:	83 ec 0c             	sub    $0xc,%esp
8010440b:	50                   	push   %eax
8010440c:	e8 e8 1e 00 00       	call   801062f9 <acquire>
80104411:	83 c4 10             	add    $0x10,%esp
  if(writable){
80104414:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104418:	74 23                	je     8010443d <pipeclose+0x3e>
    p->writeopen = 0;
8010441a:	8b 45 08             	mov    0x8(%ebp),%eax
8010441d:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104424:	00 00 00 
    wakeup(&p->nread);
80104427:	8b 45 08             	mov    0x8(%ebp),%eax
8010442a:	05 34 02 00 00       	add    $0x234,%eax
8010442f:	83 ec 0c             	sub    $0xc,%esp
80104432:	50                   	push   %eax
80104433:	e8 0f 0c 00 00       	call   80105047 <wakeup>
80104438:	83 c4 10             	add    $0x10,%esp
8010443b:	eb 21                	jmp    8010445e <pipeclose+0x5f>
  } else {
    p->readopen = 0;
8010443d:	8b 45 08             	mov    0x8(%ebp),%eax
80104440:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104447:	00 00 00 
    wakeup(&p->nwrite);
8010444a:	8b 45 08             	mov    0x8(%ebp),%eax
8010444d:	05 38 02 00 00       	add    $0x238,%eax
80104452:	83 ec 0c             	sub    $0xc,%esp
80104455:	50                   	push   %eax
80104456:	e8 ec 0b 00 00       	call   80105047 <wakeup>
8010445b:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010445e:	8b 45 08             	mov    0x8(%ebp),%eax
80104461:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104467:	85 c0                	test   %eax,%eax
80104469:	75 2c                	jne    80104497 <pipeclose+0x98>
8010446b:	8b 45 08             	mov    0x8(%ebp),%eax
8010446e:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104474:	85 c0                	test   %eax,%eax
80104476:	75 1f                	jne    80104497 <pipeclose+0x98>
    release(&p->lock);
80104478:	8b 45 08             	mov    0x8(%ebp),%eax
8010447b:	83 ec 0c             	sub    $0xc,%esp
8010447e:	50                   	push   %eax
8010447f:	e8 dc 1e 00 00       	call   80106360 <release>
80104484:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80104487:	83 ec 0c             	sub    $0xc,%esp
8010448a:	ff 75 08             	pushl  0x8(%ebp)
8010448d:	e8 90 e9 ff ff       	call   80102e22 <kfree>
80104492:	83 c4 10             	add    $0x10,%esp
80104495:	eb 0f                	jmp    801044a6 <pipeclose+0xa7>
  } else
    release(&p->lock);
80104497:	8b 45 08             	mov    0x8(%ebp),%eax
8010449a:	83 ec 0c             	sub    $0xc,%esp
8010449d:	50                   	push   %eax
8010449e:	e8 bd 1e 00 00       	call   80106360 <release>
801044a3:	83 c4 10             	add    $0x10,%esp
}
801044a6:	90                   	nop
801044a7:	c9                   	leave  
801044a8:	c3                   	ret    

801044a9 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801044a9:	55                   	push   %ebp
801044aa:	89 e5                	mov    %esp,%ebp
801044ac:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801044af:	8b 45 08             	mov    0x8(%ebp),%eax
801044b2:	83 ec 0c             	sub    $0xc,%esp
801044b5:	50                   	push   %eax
801044b6:	e8 3e 1e 00 00       	call   801062f9 <acquire>
801044bb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801044be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801044c5:	e9 ad 00 00 00       	jmp    80104577 <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801044ca:	8b 45 08             	mov    0x8(%ebp),%eax
801044cd:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801044d3:	85 c0                	test   %eax,%eax
801044d5:	74 0d                	je     801044e4 <pipewrite+0x3b>
801044d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044dd:	8b 40 24             	mov    0x24(%eax),%eax
801044e0:	85 c0                	test   %eax,%eax
801044e2:	74 19                	je     801044fd <pipewrite+0x54>
        release(&p->lock);
801044e4:	8b 45 08             	mov    0x8(%ebp),%eax
801044e7:	83 ec 0c             	sub    $0xc,%esp
801044ea:	50                   	push   %eax
801044eb:	e8 70 1e 00 00       	call   80106360 <release>
801044f0:	83 c4 10             	add    $0x10,%esp
        return -1;
801044f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044f8:	e9 a8 00 00 00       	jmp    801045a5 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
801044fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104500:	05 34 02 00 00       	add    $0x234,%eax
80104505:	83 ec 0c             	sub    $0xc,%esp
80104508:	50                   	push   %eax
80104509:	e8 39 0b 00 00       	call   80105047 <wakeup>
8010450e:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104511:	8b 45 08             	mov    0x8(%ebp),%eax
80104514:	8b 55 08             	mov    0x8(%ebp),%edx
80104517:	81 c2 38 02 00 00    	add    $0x238,%edx
8010451d:	83 ec 08             	sub    $0x8,%esp
80104520:	50                   	push   %eax
80104521:	52                   	push   %edx
80104522:	e8 35 0a 00 00       	call   80104f5c <sleep>
80104527:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010452a:	8b 45 08             	mov    0x8(%ebp),%eax
8010452d:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104533:	8b 45 08             	mov    0x8(%ebp),%eax
80104536:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010453c:	05 00 02 00 00       	add    $0x200,%eax
80104541:	39 c2                	cmp    %eax,%edx
80104543:	74 85                	je     801044ca <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104545:	8b 45 08             	mov    0x8(%ebp),%eax
80104548:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010454e:	8d 48 01             	lea    0x1(%eax),%ecx
80104551:	8b 55 08             	mov    0x8(%ebp),%edx
80104554:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
8010455a:	25 ff 01 00 00       	and    $0x1ff,%eax
8010455f:	89 c1                	mov    %eax,%ecx
80104561:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104564:	8b 45 0c             	mov    0xc(%ebp),%eax
80104567:	01 d0                	add    %edx,%eax
80104569:	0f b6 10             	movzbl (%eax),%edx
8010456c:	8b 45 08             	mov    0x8(%ebp),%eax
8010456f:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104573:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104577:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010457a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010457d:	7c ab                	jl     8010452a <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010457f:	8b 45 08             	mov    0x8(%ebp),%eax
80104582:	05 34 02 00 00       	add    $0x234,%eax
80104587:	83 ec 0c             	sub    $0xc,%esp
8010458a:	50                   	push   %eax
8010458b:	e8 b7 0a 00 00       	call   80105047 <wakeup>
80104590:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104593:	8b 45 08             	mov    0x8(%ebp),%eax
80104596:	83 ec 0c             	sub    $0xc,%esp
80104599:	50                   	push   %eax
8010459a:	e8 c1 1d 00 00       	call   80106360 <release>
8010459f:	83 c4 10             	add    $0x10,%esp
  return n;
801045a2:	8b 45 10             	mov    0x10(%ebp),%eax
}
801045a5:	c9                   	leave  
801045a6:	c3                   	ret    

801045a7 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801045a7:	55                   	push   %ebp
801045a8:	89 e5                	mov    %esp,%ebp
801045aa:	53                   	push   %ebx
801045ab:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801045ae:	8b 45 08             	mov    0x8(%ebp),%eax
801045b1:	83 ec 0c             	sub    $0xc,%esp
801045b4:	50                   	push   %eax
801045b5:	e8 3f 1d 00 00       	call   801062f9 <acquire>
801045ba:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801045bd:	eb 3f                	jmp    801045fe <piperead+0x57>
    if(proc->killed){
801045bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045c5:	8b 40 24             	mov    0x24(%eax),%eax
801045c8:	85 c0                	test   %eax,%eax
801045ca:	74 19                	je     801045e5 <piperead+0x3e>
      release(&p->lock);
801045cc:	8b 45 08             	mov    0x8(%ebp),%eax
801045cf:	83 ec 0c             	sub    $0xc,%esp
801045d2:	50                   	push   %eax
801045d3:	e8 88 1d 00 00       	call   80106360 <release>
801045d8:	83 c4 10             	add    $0x10,%esp
      return -1;
801045db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045e0:	e9 bf 00 00 00       	jmp    801046a4 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801045e5:	8b 45 08             	mov    0x8(%ebp),%eax
801045e8:	8b 55 08             	mov    0x8(%ebp),%edx
801045eb:	81 c2 34 02 00 00    	add    $0x234,%edx
801045f1:	83 ec 08             	sub    $0x8,%esp
801045f4:	50                   	push   %eax
801045f5:	52                   	push   %edx
801045f6:	e8 61 09 00 00       	call   80104f5c <sleep>
801045fb:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801045fe:	8b 45 08             	mov    0x8(%ebp),%eax
80104601:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104607:	8b 45 08             	mov    0x8(%ebp),%eax
8010460a:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104610:	39 c2                	cmp    %eax,%edx
80104612:	75 0d                	jne    80104621 <piperead+0x7a>
80104614:	8b 45 08             	mov    0x8(%ebp),%eax
80104617:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010461d:	85 c0                	test   %eax,%eax
8010461f:	75 9e                	jne    801045bf <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104621:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104628:	eb 49                	jmp    80104673 <piperead+0xcc>
    if(p->nread == p->nwrite)
8010462a:	8b 45 08             	mov    0x8(%ebp),%eax
8010462d:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104633:	8b 45 08             	mov    0x8(%ebp),%eax
80104636:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010463c:	39 c2                	cmp    %eax,%edx
8010463e:	74 3d                	je     8010467d <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104640:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104643:	8b 45 0c             	mov    0xc(%ebp),%eax
80104646:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104649:	8b 45 08             	mov    0x8(%ebp),%eax
8010464c:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104652:	8d 48 01             	lea    0x1(%eax),%ecx
80104655:	8b 55 08             	mov    0x8(%ebp),%edx
80104658:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010465e:	25 ff 01 00 00       	and    $0x1ff,%eax
80104663:	89 c2                	mov    %eax,%edx
80104665:	8b 45 08             	mov    0x8(%ebp),%eax
80104668:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
8010466d:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010466f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104673:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104676:	3b 45 10             	cmp    0x10(%ebp),%eax
80104679:	7c af                	jl     8010462a <piperead+0x83>
8010467b:	eb 01                	jmp    8010467e <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
8010467d:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010467e:	8b 45 08             	mov    0x8(%ebp),%eax
80104681:	05 38 02 00 00       	add    $0x238,%eax
80104686:	83 ec 0c             	sub    $0xc,%esp
80104689:	50                   	push   %eax
8010468a:	e8 b8 09 00 00       	call   80105047 <wakeup>
8010468f:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104692:	8b 45 08             	mov    0x8(%ebp),%eax
80104695:	83 ec 0c             	sub    $0xc,%esp
80104698:	50                   	push   %eax
80104699:	e8 c2 1c 00 00       	call   80106360 <release>
8010469e:	83 c4 10             	add    $0x10,%esp
  return i;
801046a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801046a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046a7:	c9                   	leave  
801046a8:	c3                   	ret    

801046a9 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801046a9:	55                   	push   %ebp
801046aa:	89 e5                	mov    %esp,%ebp
801046ac:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046af:	9c                   	pushf  
801046b0:	58                   	pop    %eax
801046b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801046b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801046b7:	c9                   	leave  
801046b8:	c3                   	ret    

801046b9 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801046b9:	55                   	push   %ebp
801046ba:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801046bc:	fb                   	sti    
}
801046bd:	90                   	nop
801046be:	5d                   	pop    %ebp
801046bf:	c3                   	ret    

801046c0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801046c6:	83 ec 08             	sub    $0x8,%esp
801046c9:	68 7c 9c 10 80       	push   $0x80109c7c
801046ce:	68 c0 49 11 80       	push   $0x801149c0
801046d3:	e8 ff 1b 00 00       	call   801062d7 <initlock>
801046d8:	83 c4 10             	add    $0x10,%esp
}
801046db:	90                   	nop
801046dc:	c9                   	leave  
801046dd:	c3                   	ret    

801046de <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801046de:	55                   	push   %ebp
801046df:	89 e5                	mov    %esp,%ebp
801046e1:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801046e4:	83 ec 0c             	sub    $0xc,%esp
801046e7:	68 c0 49 11 80       	push   $0x801149c0
801046ec:	e8 08 1c 00 00       	call   801062f9 <acquire>
801046f1:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046f4:	c7 45 f4 f4 49 11 80 	movl   $0x801149f4,-0xc(%ebp)
801046fb:	eb 0e                	jmp    8010470b <allocproc+0x2d>
    if(p->state == UNUSED)
801046fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104700:	8b 40 0c             	mov    0xc(%eax),%eax
80104703:	85 c0                	test   %eax,%eax
80104705:	74 27                	je     8010472e <allocproc+0x50>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104707:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010470b:	81 7d f4 f4 68 11 80 	cmpl   $0x801168f4,-0xc(%ebp)
80104712:	72 e9                	jb     801046fd <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104714:	83 ec 0c             	sub    $0xc,%esp
80104717:	68 c0 49 11 80       	push   $0x801149c0
8010471c:	e8 3f 1c 00 00       	call   80106360 <release>
80104721:	83 c4 10             	add    $0x10,%esp
  return 0;
80104724:	b8 00 00 00 00       	mov    $0x0,%eax
80104729:	e9 b4 00 00 00       	jmp    801047e2 <allocproc+0x104>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
8010472e:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010472f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104732:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104739:	a1 04 d0 10 80       	mov    0x8010d004,%eax
8010473e:	8d 50 01             	lea    0x1(%eax),%edx
80104741:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
80104747:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010474a:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
8010474d:	83 ec 0c             	sub    $0xc,%esp
80104750:	68 c0 49 11 80       	push   $0x801149c0
80104755:	e8 06 1c 00 00       	call   80106360 <release>
8010475a:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010475d:	e8 5d e7 ff ff       	call   80102ebf <kalloc>
80104762:	89 c2                	mov    %eax,%edx
80104764:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104767:	89 50 08             	mov    %edx,0x8(%eax)
8010476a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010476d:	8b 40 08             	mov    0x8(%eax),%eax
80104770:	85 c0                	test   %eax,%eax
80104772:	75 11                	jne    80104785 <allocproc+0xa7>
    p->state = UNUSED;
80104774:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104777:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
8010477e:	b8 00 00 00 00       	mov    $0x0,%eax
80104783:	eb 5d                	jmp    801047e2 <allocproc+0x104>
  }
  sp = p->kstack + KSTACKSIZE;
80104785:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104788:	8b 40 08             	mov    0x8(%eax),%eax
8010478b:	05 00 10 00 00       	add    $0x1000,%eax
80104790:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104793:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104797:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010479a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010479d:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801047a0:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801047a4:	ba 93 7a 10 80       	mov    $0x80107a93,%edx
801047a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047ac:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801047ae:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801047b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801047b8:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801047bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047be:	8b 40 1c             	mov    0x1c(%eax),%eax
801047c1:	83 ec 04             	sub    $0x4,%esp
801047c4:	6a 14                	push   $0x14
801047c6:	6a 00                	push   $0x0
801047c8:	50                   	push   %eax
801047c9:	e8 8e 1d 00 00       	call   8010655c <memset>
801047ce:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801047d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d4:	8b 40 1c             	mov    0x1c(%eax),%eax
801047d7:	ba 2b 4f 10 80       	mov    $0x80104f2b,%edx
801047dc:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801047df:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801047e2:	c9                   	leave  
801047e3:	c3                   	ret    

801047e4 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801047e4:	55                   	push   %ebp
801047e5:	89 e5                	mov    %esp,%ebp
801047e7:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
801047ea:	e8 ef fe ff ff       	call   801046de <allocproc>
801047ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801047f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f5:	a3 48 d6 10 80       	mov    %eax,0x8010d648
  if((p->pgdir = setupkvm()) == 0)
801047fa:	e8 59 49 00 00       	call   80109158 <setupkvm>
801047ff:	89 c2                	mov    %eax,%edx
80104801:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104804:	89 50 04             	mov    %edx,0x4(%eax)
80104807:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010480a:	8b 40 04             	mov    0x4(%eax),%eax
8010480d:	85 c0                	test   %eax,%eax
8010480f:	75 0d                	jne    8010481e <userinit+0x3a>
    panic("userinit: out of memory?");
80104811:	83 ec 0c             	sub    $0xc,%esp
80104814:	68 83 9c 10 80       	push   $0x80109c83
80104819:	e8 d9 bd ff ff       	call   801005f7 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010481e:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104823:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104826:	8b 40 04             	mov    0x4(%eax),%eax
80104829:	83 ec 04             	sub    $0x4,%esp
8010482c:	52                   	push   %edx
8010482d:	68 e0 d4 10 80       	push   $0x8010d4e0
80104832:	50                   	push   %eax
80104833:	e8 7a 4b 00 00       	call   801093b2 <inituvm>
80104838:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
8010483b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010483e:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104844:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104847:	8b 40 18             	mov    0x18(%eax),%eax
8010484a:	83 ec 04             	sub    $0x4,%esp
8010484d:	6a 4c                	push   $0x4c
8010484f:	6a 00                	push   $0x0
80104851:	50                   	push   %eax
80104852:	e8 05 1d 00 00       	call   8010655c <memset>
80104857:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010485a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010485d:	8b 40 18             	mov    0x18(%eax),%eax
80104860:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104866:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104869:	8b 40 18             	mov    0x18(%eax),%eax
8010486c:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104872:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104875:	8b 40 18             	mov    0x18(%eax),%eax
80104878:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010487b:	8b 52 18             	mov    0x18(%edx),%edx
8010487e:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104882:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104886:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104889:	8b 40 18             	mov    0x18(%eax),%eax
8010488c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010488f:	8b 52 18             	mov    0x18(%edx),%edx
80104892:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104896:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010489a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010489d:	8b 40 18             	mov    0x18(%eax),%eax
801048a0:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801048a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048aa:	8b 40 18             	mov    0x18(%eax),%eax
801048ad:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801048b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b7:	8b 40 18             	mov    0x18(%eax),%eax
801048ba:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801048c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c4:	83 c0 6c             	add    $0x6c,%eax
801048c7:	83 ec 04             	sub    $0x4,%esp
801048ca:	6a 10                	push   $0x10
801048cc:	68 9c 9c 10 80       	push   $0x80109c9c
801048d1:	50                   	push   %eax
801048d2:	e8 88 1e 00 00       	call   8010675f <safestrcpy>
801048d7:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801048da:	83 ec 0c             	sub    $0xc,%esp
801048dd:	68 a5 9c 10 80       	push   $0x80109ca5
801048e2:	e8 c0 dd ff ff       	call   801026a7 <namei>
801048e7:	83 c4 10             	add    $0x10,%esp
801048ea:	89 c2                	mov    %eax,%edx
801048ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ef:	89 50 68             	mov    %edx,0x68(%eax)

  p->state = RUNNABLE;
801048f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
801048fc:	90                   	nop
801048fd:	c9                   	leave  
801048fe:	c3                   	ret    

801048ff <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801048ff:	55                   	push   %ebp
80104900:	89 e5                	mov    %esp,%ebp
80104902:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
80104905:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010490b:	8b 00                	mov    (%eax),%eax
8010490d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104910:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104914:	7e 31                	jle    80104947 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104916:	8b 55 08             	mov    0x8(%ebp),%edx
80104919:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010491c:	01 c2                	add    %eax,%edx
8010491e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104924:	8b 40 04             	mov    0x4(%eax),%eax
80104927:	83 ec 04             	sub    $0x4,%esp
8010492a:	52                   	push   %edx
8010492b:	ff 75 f4             	pushl  -0xc(%ebp)
8010492e:	50                   	push   %eax
8010492f:	e8 cb 4b 00 00       	call   801094ff <allocuvm>
80104934:	83 c4 10             	add    $0x10,%esp
80104937:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010493a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010493e:	75 3e                	jne    8010497e <growproc+0x7f>
      return -1;
80104940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104945:	eb 59                	jmp    801049a0 <growproc+0xa1>
  } else if(n < 0){
80104947:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010494b:	79 31                	jns    8010497e <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010494d:	8b 55 08             	mov    0x8(%ebp),%edx
80104950:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104953:	01 c2                	add    %eax,%edx
80104955:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010495b:	8b 40 04             	mov    0x4(%eax),%eax
8010495e:	83 ec 04             	sub    $0x4,%esp
80104961:	52                   	push   %edx
80104962:	ff 75 f4             	pushl  -0xc(%ebp)
80104965:	50                   	push   %eax
80104966:	e8 5d 4c 00 00       	call   801095c8 <deallocuvm>
8010496b:	83 c4 10             	add    $0x10,%esp
8010496e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104971:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104975:	75 07                	jne    8010497e <growproc+0x7f>
      return -1;
80104977:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010497c:	eb 22                	jmp    801049a0 <growproc+0xa1>
  }
  proc->sz = sz;
8010497e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104984:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104987:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104989:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010498f:	83 ec 0c             	sub    $0xc,%esp
80104992:	50                   	push   %eax
80104993:	e8 a7 48 00 00       	call   8010923f <switchuvm>
80104998:	83 c4 10             	add    $0x10,%esp
  return 0;
8010499b:	b8 00 00 00 00       	mov    $0x0,%eax
}
801049a0:	c9                   	leave  
801049a1:	c3                   	ret    

801049a2 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801049a2:	55                   	push   %ebp
801049a3:	89 e5                	mov    %esp,%ebp
801049a5:	57                   	push   %edi
801049a6:	56                   	push   %esi
801049a7:	53                   	push   %ebx
801049a8:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801049ab:	e8 2e fd ff ff       	call   801046de <allocproc>
801049b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801049b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801049b7:	75 0a                	jne    801049c3 <fork+0x21>
    return -1;
801049b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049be:	e9 68 01 00 00       	jmp    80104b2b <fork+0x189>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801049c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049c9:	8b 10                	mov    (%eax),%edx
801049cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049d1:	8b 40 04             	mov    0x4(%eax),%eax
801049d4:	83 ec 08             	sub    $0x8,%esp
801049d7:	52                   	push   %edx
801049d8:	50                   	push   %eax
801049d9:	e8 88 4d 00 00       	call   80109766 <copyuvm>
801049de:	83 c4 10             	add    $0x10,%esp
801049e1:	89 c2                	mov    %eax,%edx
801049e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049e6:	89 50 04             	mov    %edx,0x4(%eax)
801049e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049ec:	8b 40 04             	mov    0x4(%eax),%eax
801049ef:	85 c0                	test   %eax,%eax
801049f1:	75 30                	jne    80104a23 <fork+0x81>
    kfree(np->kstack);
801049f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049f6:	8b 40 08             	mov    0x8(%eax),%eax
801049f9:	83 ec 0c             	sub    $0xc,%esp
801049fc:	50                   	push   %eax
801049fd:	e8 20 e4 ff ff       	call   80102e22 <kfree>
80104a02:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104a05:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a08:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104a0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a12:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104a19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a1e:	e9 08 01 00 00       	jmp    80104b2b <fork+0x189>
  }
  np->sz = proc->sz;
80104a23:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a29:	8b 10                	mov    (%eax),%edx
80104a2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a2e:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104a30:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a37:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a3a:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104a3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a40:	8b 50 18             	mov    0x18(%eax),%edx
80104a43:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a49:	8b 40 18             	mov    0x18(%eax),%eax
80104a4c:	89 c3                	mov    %eax,%ebx
80104a4e:	b8 13 00 00 00       	mov    $0x13,%eax
80104a53:	89 d7                	mov    %edx,%edi
80104a55:	89 de                	mov    %ebx,%esi
80104a57:	89 c1                	mov    %eax,%ecx
80104a59:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104a5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a5e:	8b 40 18             	mov    0x18(%eax),%eax
80104a61:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104a68:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104a6f:	eb 43                	jmp    80104ab4 <fork+0x112>
    if(proc->ofile[i])
80104a71:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104a7a:	83 c2 08             	add    $0x8,%edx
80104a7d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a81:	85 c0                	test   %eax,%eax
80104a83:	74 2b                	je     80104ab0 <fork+0x10e>
      np->ofile[i] = filedup(proc->ofile[i]);
80104a85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a8b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104a8e:	83 c2 08             	add    $0x8,%edx
80104a91:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a95:	83 ec 0c             	sub    $0xc,%esp
80104a98:	50                   	push   %eax
80104a99:	e8 d8 c5 ff ff       	call   80101076 <filedup>
80104a9e:	83 c4 10             	add    $0x10,%esp
80104aa1:	89 c1                	mov    %eax,%ecx
80104aa3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104aa6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104aa9:	83 c2 08             	add    $0x8,%edx
80104aac:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104ab0:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104ab4:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104ab8:	7e b7                	jle    80104a71 <fork+0xcf>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104aba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ac0:	8b 40 68             	mov    0x68(%eax),%eax
80104ac3:	83 ec 0c             	sub    $0xc,%esp
80104ac6:	50                   	push   %eax
80104ac7:	e8 cb ce ff ff       	call   80101997 <idup>
80104acc:	83 c4 10             	add    $0x10,%esp
80104acf:	89 c2                	mov    %eax,%edx
80104ad1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ad4:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104ad7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104add:	8d 50 6c             	lea    0x6c(%eax),%edx
80104ae0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ae3:	83 c0 6c             	add    $0x6c,%eax
80104ae6:	83 ec 04             	sub    $0x4,%esp
80104ae9:	6a 10                	push   $0x10
80104aeb:	52                   	push   %edx
80104aec:	50                   	push   %eax
80104aed:	e8 6d 1c 00 00       	call   8010675f <safestrcpy>
80104af2:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104af5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104af8:	8b 40 10             	mov    0x10(%eax),%eax
80104afb:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104afe:	83 ec 0c             	sub    $0xc,%esp
80104b01:	68 c0 49 11 80       	push   $0x801149c0
80104b06:	e8 ee 17 00 00       	call   801062f9 <acquire>
80104b0b:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80104b0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b11:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104b18:	83 ec 0c             	sub    $0xc,%esp
80104b1b:	68 c0 49 11 80       	push   $0x801149c0
80104b20:	e8 3b 18 00 00       	call   80106360 <release>
80104b25:	83 c4 10             	add    $0x10,%esp
  
  return pid;
80104b28:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104b2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b2e:	5b                   	pop    %ebx
80104b2f:	5e                   	pop    %esi
80104b30:	5f                   	pop    %edi
80104b31:	5d                   	pop    %ebp
80104b32:	c3                   	ret    

80104b33 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104b33:	55                   	push   %ebp
80104b34:	89 e5                	mov    %esp,%ebp
80104b36:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104b39:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104b40:	a1 48 d6 10 80       	mov    0x8010d648,%eax
80104b45:	39 c2                	cmp    %eax,%edx
80104b47:	75 0d                	jne    80104b56 <exit+0x23>
    panic("init exiting");
80104b49:	83 ec 0c             	sub    $0xc,%esp
80104b4c:	68 a7 9c 10 80       	push   $0x80109ca7
80104b51:	e8 a1 ba ff ff       	call   801005f7 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104b56:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104b5d:	eb 48                	jmp    80104ba7 <exit+0x74>
    if(proc->ofile[fd]){
80104b5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b65:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b68:	83 c2 08             	add    $0x8,%edx
80104b6b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b6f:	85 c0                	test   %eax,%eax
80104b71:	74 30                	je     80104ba3 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104b73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b79:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b7c:	83 c2 08             	add    $0x8,%edx
80104b7f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b83:	83 ec 0c             	sub    $0xc,%esp
80104b86:	50                   	push   %eax
80104b87:	e8 3b c5 ff ff       	call   801010c7 <fileclose>
80104b8c:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104b8f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b95:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b98:	83 c2 08             	add    $0x8,%edx
80104b9b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104ba2:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104ba3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104ba7:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104bab:	7e b2                	jle    80104b5f <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104bad:	e8 fc eb ff ff       	call   801037ae <begin_op>
  iput(proc->cwd);
80104bb2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bb8:	8b 40 68             	mov    0x68(%eax),%eax
80104bbb:	83 ec 0c             	sub    $0xc,%esp
80104bbe:	50                   	push   %eax
80104bbf:	e8 d7 cf ff ff       	call   80101b9b <iput>
80104bc4:	83 c4 10             	add    $0x10,%esp
  end_op();
80104bc7:	e8 6e ec ff ff       	call   8010383a <end_op>
  proc->cwd = 0;
80104bcc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bd2:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104bd9:	83 ec 0c             	sub    $0xc,%esp
80104bdc:	68 c0 49 11 80       	push   $0x801149c0
80104be1:	e8 13 17 00 00       	call   801062f9 <acquire>
80104be6:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104be9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bef:	8b 40 14             	mov    0x14(%eax),%eax
80104bf2:	83 ec 0c             	sub    $0xc,%esp
80104bf5:	50                   	push   %eax
80104bf6:	e8 0d 04 00 00       	call   80105008 <wakeup1>
80104bfb:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bfe:	c7 45 f4 f4 49 11 80 	movl   $0x801149f4,-0xc(%ebp)
80104c05:	eb 3c                	jmp    80104c43 <exit+0x110>
    if(p->parent == proc){
80104c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c0a:	8b 50 14             	mov    0x14(%eax),%edx
80104c0d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c13:	39 c2                	cmp    %eax,%edx
80104c15:	75 28                	jne    80104c3f <exit+0x10c>
      p->parent = initproc;
80104c17:	8b 15 48 d6 10 80    	mov    0x8010d648,%edx
80104c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c20:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c26:	8b 40 0c             	mov    0xc(%eax),%eax
80104c29:	83 f8 05             	cmp    $0x5,%eax
80104c2c:	75 11                	jne    80104c3f <exit+0x10c>
        wakeup1(initproc);
80104c2e:	a1 48 d6 10 80       	mov    0x8010d648,%eax
80104c33:	83 ec 0c             	sub    $0xc,%esp
80104c36:	50                   	push   %eax
80104c37:	e8 cc 03 00 00       	call   80105008 <wakeup1>
80104c3c:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c3f:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104c43:	81 7d f4 f4 68 11 80 	cmpl   $0x801168f4,-0xc(%ebp)
80104c4a:	72 bb                	jb     80104c07 <exit+0xd4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104c4c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c52:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104c59:	e8 d6 01 00 00       	call   80104e34 <sched>
  panic("zombie exit");
80104c5e:	83 ec 0c             	sub    $0xc,%esp
80104c61:	68 b4 9c 10 80       	push   $0x80109cb4
80104c66:	e8 8c b9 ff ff       	call   801005f7 <panic>

80104c6b <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104c6b:	55                   	push   %ebp
80104c6c:	89 e5                	mov    %esp,%ebp
80104c6e:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104c71:	83 ec 0c             	sub    $0xc,%esp
80104c74:	68 c0 49 11 80       	push   $0x801149c0
80104c79:	e8 7b 16 00 00       	call   801062f9 <acquire>
80104c7e:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104c81:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c88:	c7 45 f4 f4 49 11 80 	movl   $0x801149f4,-0xc(%ebp)
80104c8f:	e9 a6 00 00 00       	jmp    80104d3a <wait+0xcf>
      if(p->parent != proc)
80104c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c97:	8b 50 14             	mov    0x14(%eax),%edx
80104c9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ca0:	39 c2                	cmp    %eax,%edx
80104ca2:	0f 85 8d 00 00 00    	jne    80104d35 <wait+0xca>
        continue;
      havekids = 1;
80104ca8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cb2:	8b 40 0c             	mov    0xc(%eax),%eax
80104cb5:	83 f8 05             	cmp    $0x5,%eax
80104cb8:	75 7c                	jne    80104d36 <wait+0xcb>
        // Found one.
        pid = p->pid;
80104cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cbd:	8b 40 10             	mov    0x10(%eax),%eax
80104cc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cc6:	8b 40 08             	mov    0x8(%eax),%eax
80104cc9:	83 ec 0c             	sub    $0xc,%esp
80104ccc:	50                   	push   %eax
80104ccd:	e8 50 e1 ff ff       	call   80102e22 <kfree>
80104cd2:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cd8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ce2:	8b 40 04             	mov    0x4(%eax),%eax
80104ce5:	83 ec 0c             	sub    $0xc,%esp
80104ce8:	50                   	push   %eax
80104ce9:	e8 97 49 00 00       	call   80109685 <freevm>
80104cee:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cfe:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d08:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d12:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d19:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104d20:	83 ec 0c             	sub    $0xc,%esp
80104d23:	68 c0 49 11 80       	push   $0x801149c0
80104d28:	e8 33 16 00 00       	call   80106360 <release>
80104d2d:	83 c4 10             	add    $0x10,%esp
        return pid;
80104d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d33:	eb 58                	jmp    80104d8d <wait+0x122>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104d35:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d36:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104d3a:	81 7d f4 f4 68 11 80 	cmpl   $0x801168f4,-0xc(%ebp)
80104d41:	0f 82 4d ff ff ff    	jb     80104c94 <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104d47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104d4b:	74 0d                	je     80104d5a <wait+0xef>
80104d4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d53:	8b 40 24             	mov    0x24(%eax),%eax
80104d56:	85 c0                	test   %eax,%eax
80104d58:	74 17                	je     80104d71 <wait+0x106>
      release(&ptable.lock);
80104d5a:	83 ec 0c             	sub    $0xc,%esp
80104d5d:	68 c0 49 11 80       	push   $0x801149c0
80104d62:	e8 f9 15 00 00       	call   80106360 <release>
80104d67:	83 c4 10             	add    $0x10,%esp
      return -1;
80104d6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d6f:	eb 1c                	jmp    80104d8d <wait+0x122>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104d71:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d77:	83 ec 08             	sub    $0x8,%esp
80104d7a:	68 c0 49 11 80       	push   $0x801149c0
80104d7f:	50                   	push   %eax
80104d80:	e8 d7 01 00 00       	call   80104f5c <sleep>
80104d85:	83 c4 10             	add    $0x10,%esp
  }
80104d88:	e9 f4 fe ff ff       	jmp    80104c81 <wait+0x16>
}
80104d8d:	c9                   	leave  
80104d8e:	c3                   	ret    

80104d8f <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104d8f:	55                   	push   %ebp
80104d90:	89 e5                	mov    %esp,%ebp
80104d92:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104d95:	e8 1f f9 ff ff       	call   801046b9 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104d9a:	83 ec 0c             	sub    $0xc,%esp
80104d9d:	68 c0 49 11 80       	push   $0x801149c0
80104da2:	e8 52 15 00 00       	call   801062f9 <acquire>
80104da7:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104daa:	c7 45 f4 f4 49 11 80 	movl   $0x801149f4,-0xc(%ebp)
80104db1:	eb 63                	jmp    80104e16 <scheduler+0x87>
      if(p->state != RUNNABLE)
80104db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db6:	8b 40 0c             	mov    0xc(%eax),%eax
80104db9:	83 f8 03             	cmp    $0x3,%eax
80104dbc:	75 53                	jne    80104e11 <scheduler+0x82>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dc1:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104dc7:	83 ec 0c             	sub    $0xc,%esp
80104dca:	ff 75 f4             	pushl  -0xc(%ebp)
80104dcd:	e8 6d 44 00 00       	call   8010923f <switchuvm>
80104dd2:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd8:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104ddf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104de5:	8b 40 1c             	mov    0x1c(%eax),%eax
80104de8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104def:	83 c2 04             	add    $0x4,%edx
80104df2:	83 ec 08             	sub    $0x8,%esp
80104df5:	50                   	push   %eax
80104df6:	52                   	push   %edx
80104df7:	e8 c5 1a 00 00       	call   801068c1 <swtch>
80104dfc:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104dff:	e8 1e 44 00 00       	call   80109222 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104e04:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104e0b:	00 00 00 00 
80104e0f:	eb 01                	jmp    80104e12 <scheduler+0x83>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104e11:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e12:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104e16:	81 7d f4 f4 68 11 80 	cmpl   $0x801168f4,-0xc(%ebp)
80104e1d:	72 94                	jb     80104db3 <scheduler+0x24>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104e1f:	83 ec 0c             	sub    $0xc,%esp
80104e22:	68 c0 49 11 80       	push   $0x801149c0
80104e27:	e8 34 15 00 00       	call   80106360 <release>
80104e2c:	83 c4 10             	add    $0x10,%esp

  }
80104e2f:	e9 61 ff ff ff       	jmp    80104d95 <scheduler+0x6>

80104e34 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104e34:	55                   	push   %ebp
80104e35:	89 e5                	mov    %esp,%ebp
80104e37:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104e3a:	83 ec 0c             	sub    $0xc,%esp
80104e3d:	68 c0 49 11 80       	push   $0x801149c0
80104e42:	e8 e5 15 00 00       	call   8010642c <holding>
80104e47:	83 c4 10             	add    $0x10,%esp
80104e4a:	85 c0                	test   %eax,%eax
80104e4c:	75 0d                	jne    80104e5b <sched+0x27>
    panic("sched ptable.lock");
80104e4e:	83 ec 0c             	sub    $0xc,%esp
80104e51:	68 c0 9c 10 80       	push   $0x80109cc0
80104e56:	e8 9c b7 ff ff       	call   801005f7 <panic>
  if(cpu->ncli != 1)
80104e5b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e61:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104e67:	83 f8 01             	cmp    $0x1,%eax
80104e6a:	74 0d                	je     80104e79 <sched+0x45>
    panic("sched locks");
80104e6c:	83 ec 0c             	sub    $0xc,%esp
80104e6f:	68 d2 9c 10 80       	push   $0x80109cd2
80104e74:	e8 7e b7 ff ff       	call   801005f7 <panic>
  if(proc->state == RUNNING)
80104e79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e7f:	8b 40 0c             	mov    0xc(%eax),%eax
80104e82:	83 f8 04             	cmp    $0x4,%eax
80104e85:	75 0d                	jne    80104e94 <sched+0x60>
    panic("sched running");
80104e87:	83 ec 0c             	sub    $0xc,%esp
80104e8a:	68 de 9c 10 80       	push   $0x80109cde
80104e8f:	e8 63 b7 ff ff       	call   801005f7 <panic>
  if(readeflags()&FL_IF)
80104e94:	e8 10 f8 ff ff       	call   801046a9 <readeflags>
80104e99:	25 00 02 00 00       	and    $0x200,%eax
80104e9e:	85 c0                	test   %eax,%eax
80104ea0:	74 0d                	je     80104eaf <sched+0x7b>
    panic("sched interruptible");
80104ea2:	83 ec 0c             	sub    $0xc,%esp
80104ea5:	68 ec 9c 10 80       	push   $0x80109cec
80104eaa:	e8 48 b7 ff ff       	call   801005f7 <panic>
  intena = cpu->intena;
80104eaf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104eb5:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104ebb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104ebe:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ec4:	8b 40 04             	mov    0x4(%eax),%eax
80104ec7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ece:	83 c2 1c             	add    $0x1c,%edx
80104ed1:	83 ec 08             	sub    $0x8,%esp
80104ed4:	50                   	push   %eax
80104ed5:	52                   	push   %edx
80104ed6:	e8 e6 19 00 00       	call   801068c1 <swtch>
80104edb:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104ede:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ee4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ee7:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104eed:	90                   	nop
80104eee:	c9                   	leave  
80104eef:	c3                   	ret    

80104ef0 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104ef6:	83 ec 0c             	sub    $0xc,%esp
80104ef9:	68 c0 49 11 80       	push   $0x801149c0
80104efe:	e8 f6 13 00 00       	call   801062f9 <acquire>
80104f03:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104f06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f0c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104f13:	e8 1c ff ff ff       	call   80104e34 <sched>
  release(&ptable.lock);
80104f18:	83 ec 0c             	sub    $0xc,%esp
80104f1b:	68 c0 49 11 80       	push   $0x801149c0
80104f20:	e8 3b 14 00 00       	call   80106360 <release>
80104f25:	83 c4 10             	add    $0x10,%esp
}
80104f28:	90                   	nop
80104f29:	c9                   	leave  
80104f2a:	c3                   	ret    

80104f2b <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104f2b:	55                   	push   %ebp
80104f2c:	89 e5                	mov    %esp,%ebp
80104f2e:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104f31:	83 ec 0c             	sub    $0xc,%esp
80104f34:	68 c0 49 11 80       	push   $0x801149c0
80104f39:	e8 22 14 00 00       	call   80106360 <release>
80104f3e:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104f41:	a1 08 d0 10 80       	mov    0x8010d008,%eax
80104f46:	85 c0                	test   %eax,%eax
80104f48:	74 0f                	je     80104f59 <forkret+0x2e>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104f4a:	c7 05 08 d0 10 80 00 	movl   $0x0,0x8010d008
80104f51:	00 00 00 
    initlog();
80104f54:	e8 2f e6 ff ff       	call   80103588 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104f59:	90                   	nop
80104f5a:	c9                   	leave  
80104f5b:	c3                   	ret    

80104f5c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104f5c:	55                   	push   %ebp
80104f5d:	89 e5                	mov    %esp,%ebp
80104f5f:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104f62:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f68:	85 c0                	test   %eax,%eax
80104f6a:	75 0d                	jne    80104f79 <sleep+0x1d>
    panic("sleep");
80104f6c:	83 ec 0c             	sub    $0xc,%esp
80104f6f:	68 00 9d 10 80       	push   $0x80109d00
80104f74:	e8 7e b6 ff ff       	call   801005f7 <panic>

  if(lk == 0)
80104f79:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104f7d:	75 0d                	jne    80104f8c <sleep+0x30>
    panic("sleep without lk");
80104f7f:	83 ec 0c             	sub    $0xc,%esp
80104f82:	68 06 9d 10 80       	push   $0x80109d06
80104f87:	e8 6b b6 ff ff       	call   801005f7 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104f8c:	81 7d 0c c0 49 11 80 	cmpl   $0x801149c0,0xc(%ebp)
80104f93:	74 1e                	je     80104fb3 <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104f95:	83 ec 0c             	sub    $0xc,%esp
80104f98:	68 c0 49 11 80       	push   $0x801149c0
80104f9d:	e8 57 13 00 00       	call   801062f9 <acquire>
80104fa2:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104fa5:	83 ec 0c             	sub    $0xc,%esp
80104fa8:	ff 75 0c             	pushl  0xc(%ebp)
80104fab:	e8 b0 13 00 00       	call   80106360 <release>
80104fb0:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104fb3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fb9:	8b 55 08             	mov    0x8(%ebp),%edx
80104fbc:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104fbf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fc5:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104fcc:	e8 63 fe ff ff       	call   80104e34 <sched>

  // Tidy up.
  proc->chan = 0;
80104fd1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fd7:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104fde:	81 7d 0c c0 49 11 80 	cmpl   $0x801149c0,0xc(%ebp)
80104fe5:	74 1e                	je     80105005 <sleep+0xa9>
    release(&ptable.lock);
80104fe7:	83 ec 0c             	sub    $0xc,%esp
80104fea:	68 c0 49 11 80       	push   $0x801149c0
80104fef:	e8 6c 13 00 00       	call   80106360 <release>
80104ff4:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104ff7:	83 ec 0c             	sub    $0xc,%esp
80104ffa:	ff 75 0c             	pushl  0xc(%ebp)
80104ffd:	e8 f7 12 00 00       	call   801062f9 <acquire>
80105002:	83 c4 10             	add    $0x10,%esp
  }
}
80105005:	90                   	nop
80105006:	c9                   	leave  
80105007:	c3                   	ret    

80105008 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80105008:	55                   	push   %ebp
80105009:	89 e5                	mov    %esp,%ebp
8010500b:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010500e:	c7 45 fc f4 49 11 80 	movl   $0x801149f4,-0x4(%ebp)
80105015:	eb 24                	jmp    8010503b <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80105017:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010501a:	8b 40 0c             	mov    0xc(%eax),%eax
8010501d:	83 f8 02             	cmp    $0x2,%eax
80105020:	75 15                	jne    80105037 <wakeup1+0x2f>
80105022:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105025:	8b 40 20             	mov    0x20(%eax),%eax
80105028:	3b 45 08             	cmp    0x8(%ebp),%eax
8010502b:	75 0a                	jne    80105037 <wakeup1+0x2f>
      p->state = RUNNABLE;
8010502d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105030:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105037:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
8010503b:	81 7d fc f4 68 11 80 	cmpl   $0x801168f4,-0x4(%ebp)
80105042:	72 d3                	jb     80105017 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80105044:	90                   	nop
80105045:	c9                   	leave  
80105046:	c3                   	ret    

80105047 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105047:	55                   	push   %ebp
80105048:	89 e5                	mov    %esp,%ebp
8010504a:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
8010504d:	83 ec 0c             	sub    $0xc,%esp
80105050:	68 c0 49 11 80       	push   $0x801149c0
80105055:	e8 9f 12 00 00       	call   801062f9 <acquire>
8010505a:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
8010505d:	83 ec 0c             	sub    $0xc,%esp
80105060:	ff 75 08             	pushl  0x8(%ebp)
80105063:	e8 a0 ff ff ff       	call   80105008 <wakeup1>
80105068:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
8010506b:	83 ec 0c             	sub    $0xc,%esp
8010506e:	68 c0 49 11 80       	push   $0x801149c0
80105073:	e8 e8 12 00 00       	call   80106360 <release>
80105078:	83 c4 10             	add    $0x10,%esp
}
8010507b:	90                   	nop
8010507c:	c9                   	leave  
8010507d:	c3                   	ret    

8010507e <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
8010507e:	55                   	push   %ebp
8010507f:	89 e5                	mov    %esp,%ebp
80105081:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80105084:	83 ec 0c             	sub    $0xc,%esp
80105087:	68 c0 49 11 80       	push   $0x801149c0
8010508c:	e8 68 12 00 00       	call   801062f9 <acquire>
80105091:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105094:	c7 45 f4 f4 49 11 80 	movl   $0x801149f4,-0xc(%ebp)
8010509b:	eb 45                	jmp    801050e2 <kill+0x64>
    if(p->pid == pid){
8010509d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050a0:	8b 40 10             	mov    0x10(%eax),%eax
801050a3:	3b 45 08             	cmp    0x8(%ebp),%eax
801050a6:	75 36                	jne    801050de <kill+0x60>
      p->killed = 1;
801050a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050ab:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801050b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050b5:	8b 40 0c             	mov    0xc(%eax),%eax
801050b8:	83 f8 02             	cmp    $0x2,%eax
801050bb:	75 0a                	jne    801050c7 <kill+0x49>
        p->state = RUNNABLE;
801050bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050c0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801050c7:	83 ec 0c             	sub    $0xc,%esp
801050ca:	68 c0 49 11 80       	push   $0x801149c0
801050cf:	e8 8c 12 00 00       	call   80106360 <release>
801050d4:	83 c4 10             	add    $0x10,%esp
      return 0;
801050d7:	b8 00 00 00 00       	mov    $0x0,%eax
801050dc:	eb 22                	jmp    80105100 <kill+0x82>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050de:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801050e2:	81 7d f4 f4 68 11 80 	cmpl   $0x801168f4,-0xc(%ebp)
801050e9:	72 b2                	jb     8010509d <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801050eb:	83 ec 0c             	sub    $0xc,%esp
801050ee:	68 c0 49 11 80       	push   $0x801149c0
801050f3:	e8 68 12 00 00       	call   80106360 <release>
801050f8:	83 c4 10             	add    $0x10,%esp
  return -1;
801050fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105100:	c9                   	leave  
80105101:	c3                   	ret    

80105102 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105102:	55                   	push   %ebp
80105103:	89 e5                	mov    %esp,%ebp
80105105:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105108:	c7 45 f0 f4 49 11 80 	movl   $0x801149f4,-0x10(%ebp)
8010510f:	e9 d7 00 00 00       	jmp    801051eb <procdump+0xe9>
    if(p->state == UNUSED)
80105114:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105117:	8b 40 0c             	mov    0xc(%eax),%eax
8010511a:	85 c0                	test   %eax,%eax
8010511c:	0f 84 c4 00 00 00    	je     801051e6 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105122:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105125:	8b 40 0c             	mov    0xc(%eax),%eax
80105128:	83 f8 05             	cmp    $0x5,%eax
8010512b:	77 23                	ja     80105150 <procdump+0x4e>
8010512d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105130:	8b 40 0c             	mov    0xc(%eax),%eax
80105133:	8b 04 85 0c d0 10 80 	mov    -0x7fef2ff4(,%eax,4),%eax
8010513a:	85 c0                	test   %eax,%eax
8010513c:	74 12                	je     80105150 <procdump+0x4e>
      state = states[p->state];
8010513e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105141:	8b 40 0c             	mov    0xc(%eax),%eax
80105144:	8b 04 85 0c d0 10 80 	mov    -0x7fef2ff4(,%eax,4),%eax
8010514b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010514e:	eb 07                	jmp    80105157 <procdump+0x55>
    else
      state = "???";
80105150:	c7 45 ec 17 9d 10 80 	movl   $0x80109d17,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80105157:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010515a:	8d 50 6c             	lea    0x6c(%eax),%edx
8010515d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105160:	8b 40 10             	mov    0x10(%eax),%eax
80105163:	52                   	push   %edx
80105164:	ff 75 ec             	pushl  -0x14(%ebp)
80105167:	50                   	push   %eax
80105168:	68 1b 9d 10 80       	push   $0x80109d1b
8010516d:	e8 e5 b2 ff ff       	call   80100457 <cprintf>
80105172:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80105175:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105178:	8b 40 0c             	mov    0xc(%eax),%eax
8010517b:	83 f8 02             	cmp    $0x2,%eax
8010517e:	75 54                	jne    801051d4 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105180:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105183:	8b 40 1c             	mov    0x1c(%eax),%eax
80105186:	8b 40 0c             	mov    0xc(%eax),%eax
80105189:	83 c0 08             	add    $0x8,%eax
8010518c:	89 c2                	mov    %eax,%edx
8010518e:	83 ec 08             	sub    $0x8,%esp
80105191:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105194:	50                   	push   %eax
80105195:	52                   	push   %edx
80105196:	e8 17 12 00 00       	call   801063b2 <getcallerpcs>
8010519b:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010519e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801051a5:	eb 1c                	jmp    801051c3 <procdump+0xc1>
        cprintf(" %p", pc[i]);
801051a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051aa:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801051ae:	83 ec 08             	sub    $0x8,%esp
801051b1:	50                   	push   %eax
801051b2:	68 24 9d 10 80       	push   $0x80109d24
801051b7:	e8 9b b2 ff ff       	call   80100457 <cprintf>
801051bc:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801051bf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801051c3:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801051c7:	7f 0b                	jg     801051d4 <procdump+0xd2>
801051c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051cc:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801051d0:	85 c0                	test   %eax,%eax
801051d2:	75 d3                	jne    801051a7 <procdump+0xa5>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801051d4:	83 ec 0c             	sub    $0xc,%esp
801051d7:	68 28 9d 10 80       	push   $0x80109d28
801051dc:	e8 76 b2 ff ff       	call   80100457 <cprintf>
801051e1:	83 c4 10             	add    $0x10,%esp
801051e4:	eb 01                	jmp    801051e7 <procdump+0xe5>
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
801051e6:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051e7:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
801051eb:	81 7d f0 f4 68 11 80 	cmpl   $0x801168f4,-0x10(%ebp)
801051f2:	0f 82 1c ff ff ff    	jb     80105114 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801051f8:	90                   	nop
801051f9:	c9                   	leave  
801051fa:	c3                   	ret    

801051fb <getProc>:

struct proc *getProc(int i) {
801051fb:	55                   	push   %ebp
801051fc:	89 e5                	mov    %esp,%ebp
  return &ptable.proc[i];
801051fe:	8b 45 08             	mov    0x8(%ebp),%eax
80105201:	89 c2                	mov    %eax,%edx
80105203:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
8010520a:	89 c2                	mov    %eax,%edx
8010520c:	89 d0                	mov    %edx,%eax
8010520e:	c1 e0 05             	shl    $0x5,%eax
80105211:	29 d0                	sub    %edx,%eax
80105213:	83 c0 30             	add    $0x30,%eax
80105216:	05 c0 49 11 80       	add    $0x801149c0,%eax
8010521b:	83 c0 04             	add    $0x4,%eax

}
8010521e:	5d                   	pop    %ebp
8010521f:	c3                   	ret    

80105220 <getProcByPID>:
struct proc *getProcByPID(int pid){
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	83 ec 18             	sub    $0x18,%esp
	struct proc *myproc;
	struct proc *p;
	acquire(&ptable.lock);
80105226:	83 ec 0c             	sub    $0xc,%esp
80105229:	68 c0 49 11 80       	push   $0x801149c0
8010522e:	e8 c6 10 00 00       	call   801062f9 <acquire>
80105233:	83 c4 10             	add    $0x10,%esp
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105236:	c7 45 f0 f4 49 11 80 	movl   $0x801149f4,-0x10(%ebp)
8010523d:	eb 17                	jmp    80105256 <getProcByPID+0x36>
		if (p->pid == pid){
8010523f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105242:	8b 40 10             	mov    0x10(%eax),%eax
80105245:	3b 45 08             	cmp    0x8(%ebp),%eax
80105248:	75 08                	jne    80105252 <getProcByPID+0x32>
			myproc = p;
8010524a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010524d:	89 45 f4             	mov    %eax,-0xc(%ebp)
			break;
80105250:	eb 0d                	jmp    8010525f <getProcByPID+0x3f>
}
struct proc *getProcByPID(int pid){
	struct proc *myproc;
	struct proc *p;
	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105252:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80105256:	81 7d f0 f4 68 11 80 	cmpl   $0x801168f4,-0x10(%ebp)
8010525d:	72 e0                	jb     8010523f <getProcByPID+0x1f>
		if (p->pid == pid){
			myproc = p;
			break;
		}
	}
	release(&ptable.lock);
8010525f:	83 ec 0c             	sub    $0xc,%esp
80105262:	68 c0 49 11 80       	push   $0x801149c0
80105267:	e8 f4 10 00 00       	call   80106360 <release>
8010526c:	83 c4 10             	add    $0x10,%esp
	return myproc;
8010526f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105272:	c9                   	leave  
80105273:	c3                   	ret    

80105274 <getProcState>:

char* getProcState(struct proc *p) {
80105274:	55                   	push   %ebp
80105275:	89 e5                	mov    %esp,%ebp
 switch(p->state) {
80105277:	8b 45 08             	mov    0x8(%ebp),%eax
8010527a:	8b 40 0c             	mov    0xc(%eax),%eax
8010527d:	83 f8 05             	cmp    $0x5,%eax
80105280:	77 33                	ja     801052b5 <getProcState+0x41>
80105282:	8b 04 85 5c 9d 10 80 	mov    -0x7fef62a4(,%eax,4),%eax
80105289:	ff e0                	jmp    *%eax
    case UNUSED:
    return "UNUSED";
8010528b:	b8 2a 9d 10 80       	mov    $0x80109d2a,%eax
80105290:	eb 28                	jmp    801052ba <getProcState+0x46>
    break;
    case EMBRYO:
    return "EMBRYO";
80105292:	b8 31 9d 10 80       	mov    $0x80109d31,%eax
80105297:	eb 21                	jmp    801052ba <getProcState+0x46>
    break;
    case SLEEPING:
    return "SLEEPING";
80105299:	b8 38 9d 10 80       	mov    $0x80109d38,%eax
8010529e:	eb 1a                	jmp    801052ba <getProcState+0x46>
    break;
    case RUNNABLE:
    return "RUNNABLE";
801052a0:	b8 41 9d 10 80       	mov    $0x80109d41,%eax
801052a5:	eb 13                	jmp    801052ba <getProcState+0x46>
    break;
    case RUNNING:
    return "RUNNING";
801052a7:	b8 4a 9d 10 80       	mov    $0x80109d4a,%eax
801052ac:	eb 0c                	jmp    801052ba <getProcState+0x46>
    break;
    case ZOMBIE:
    return "ZOMBIE";
801052ae:	b8 52 9d 10 80       	mov    $0x80109d52,%eax
801052b3:	eb 05                	jmp    801052ba <getProcState+0x46>
    break;
    default:
    return "???";
801052b5:	b8 17 9d 10 80       	mov    $0x80109d17,%eax
  }
801052ba:	5d                   	pop    %ebp
801052bb:	c3                   	ret    

801052bc <initProc>:
extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

int initProc(char *buf,struct inode *ip) {
801052bc:	55                   	push   %ebp
801052bd:	89 e5                	mov    %esp,%ebp
801052bf:	83 ec 28             	sub    $0x28,%esp
  int index;
  struct dirent de;
  struct proc *p;
  // insert "."
  de.inum = ip->inum;
801052c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801052c5:	8b 40 04             	mov    0x4(%eax),%eax
801052c8:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  strncpy(de.name, ".\0", DIRSIZ);
801052cc:	83 ec 04             	sub    $0x4,%esp
801052cf:	6a 0e                	push   $0xe
801052d1:	68 9e 9d 10 80       	push   $0x80109d9e
801052d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801052d9:	83 c0 02             	add    $0x2,%eax
801052dc:	50                   	push   %eax
801052dd:	e8 25 14 00 00       	call   80106707 <strncpy>
801052e2:	83 c4 10             	add    $0x10,%esp
  memmove(buf, (char *)&de, DIRENTSZ);
801052e5:	83 ec 04             	sub    $0x4,%esp
801052e8:	6a 10                	push   $0x10
801052ea:	8d 45 e0             	lea    -0x20(%ebp),%eax
801052ed:	50                   	push   %eax
801052ee:	ff 75 08             	pushl  0x8(%ebp)
801052f1:	e8 25 13 00 00       	call   8010661b <memmove>
801052f6:	83 c4 10             	add    $0x10,%esp
  // insert ".."
  de.inum = ROOTINO;
801052f9:	66 c7 45 e0 01 00    	movw   $0x1,-0x20(%ebp)
  strncpy(de.name, "..\0", DIRSIZ);
801052ff:	83 ec 04             	sub    $0x4,%esp
80105302:	6a 0e                	push   $0xe
80105304:	68 a1 9d 10 80       	push   $0x80109da1
80105309:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010530c:	83 c0 02             	add    $0x2,%eax
8010530f:	50                   	push   %eax
80105310:	e8 f2 13 00 00       	call   80106707 <strncpy>
80105315:	83 c4 10             	add    $0x10,%esp
  memmove(buf + DIRENTSZ, (char *)&de, DIRENTSZ);
80105318:	8b 45 08             	mov    0x8(%ebp),%eax
8010531b:	8d 50 10             	lea    0x10(%eax),%edx
8010531e:	83 ec 04             	sub    $0x4,%esp
80105321:	6a 10                	push   $0x10
80105323:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105326:	50                   	push   %eax
80105327:	52                   	push   %edx
80105328:	e8 ee 12 00 00       	call   8010661b <memmove>
8010532d:	83 c4 10             	add    $0x10,%esp
  // insert "blockstat"
  de.inum = 660;
80105330:	66 c7 45 e0 94 02    	movw   $0x294,-0x20(%ebp)
  strncpy(de.name, "blockstat\0", DIRSIZ);
80105336:	83 ec 04             	sub    $0x4,%esp
80105339:	6a 0e                	push   $0xe
8010533b:	68 a5 9d 10 80       	push   $0x80109da5
80105340:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105343:	83 c0 02             	add    $0x2,%eax
80105346:	50                   	push   %eax
80105347:	e8 bb 13 00 00       	call   80106707 <strncpy>
8010534c:	83 c4 10             	add    $0x10,%esp
  memmove(buf + DIRENTSZ * 2, (char *)&de, DIRENTSZ);
8010534f:	8b 45 08             	mov    0x8(%ebp),%eax
80105352:	8d 50 20             	lea    0x20(%eax),%edx
80105355:	83 ec 04             	sub    $0x4,%esp
80105358:	6a 10                	push   $0x10
8010535a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010535d:	50                   	push   %eax
8010535e:	52                   	push   %edx
8010535f:	e8 b7 12 00 00       	call   8010661b <memmove>
80105364:	83 c4 10             	add    $0x10,%esp
  // insert "inodestat"
  de.inum = 670;
80105367:	66 c7 45 e0 9e 02    	movw   $0x29e,-0x20(%ebp)
  strncpy(de.name, "inodestat\0", DIRSIZ);
8010536d:	83 ec 04             	sub    $0x4,%esp
80105370:	6a 0e                	push   $0xe
80105372:	68 b0 9d 10 80       	push   $0x80109db0
80105377:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010537a:	83 c0 02             	add    $0x2,%eax
8010537d:	50                   	push   %eax
8010537e:	e8 84 13 00 00       	call   80106707 <strncpy>
80105383:	83 c4 10             	add    $0x10,%esp
  memmove(buf + DIRENTSZ * 3, (char *)&de, DIRENTSZ);
80105386:	8b 45 08             	mov    0x8(%ebp),%eax
80105389:	8d 50 30             	lea    0x30(%eax),%edx
8010538c:	83 ec 04             	sub    $0x4,%esp
8010538f:	6a 10                	push   $0x10
80105391:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105394:	50                   	push   %eax
80105395:	52                   	push   %edx
80105396:	e8 80 12 00 00       	call   8010661b <memmove>
8010539b:	83 c4 10             	add    $0x10,%esp
  index = 4;
8010539e:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
  acquire(&ptable.lock);
801053a5:	83 ec 0c             	sub    $0xc,%esp
801053a8:	68 c0 49 11 80       	push   $0x801149c0
801053ad:	e8 47 0f 00 00       	call   801062f9 <acquire>
801053b2:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801053b5:	c7 45 f0 f4 49 11 80 	movl   $0x801149f4,-0x10(%ebp)
801053bc:	eb 5c                	jmp    8010541a <initProc+0x15e>
    if(p->state == UNUSED )
801053be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053c1:	8b 40 0c             	mov    0xc(%eax),%eax
801053c4:	85 c0                	test   %eax,%eax
801053c6:	74 4d                	je     80105415 <initProc+0x159>
    continue;
    else {
      de.inum = 700 *  p->pid;
801053c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053cb:	8b 40 10             	mov    0x10(%eax),%eax
801053ce:	66 69 c0 bc 02       	imul   $0x2bc,%ax,%ax
801053d3:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
      itoa(p->pid, de.name);
801053d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053da:	8b 40 10             	mov    0x10(%eax),%eax
801053dd:	83 ec 08             	sub    $0x8,%esp
801053e0:	8d 55 e0             	lea    -0x20(%ebp),%edx
801053e3:	83 c2 02             	add    $0x2,%edx
801053e6:	52                   	push   %edx
801053e7:	50                   	push   %eax
801053e8:	e8 e3 13 00 00       	call   801067d0 <itoa>
801053ed:	83 c4 10             	add    $0x10,%esp
      memmove(buf + (DIRENTSZ * index), (char *)&de, DIRENTSZ);
801053f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053f3:	c1 e0 04             	shl    $0x4,%eax
801053f6:	89 c2                	mov    %eax,%edx
801053f8:	8b 45 08             	mov    0x8(%ebp),%eax
801053fb:	01 c2                	add    %eax,%edx
801053fd:	83 ec 04             	sub    $0x4,%esp
80105400:	6a 10                	push   $0x10
80105402:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105405:	50                   	push   %eax
80105406:	52                   	push   %edx
80105407:	e8 0f 12 00 00       	call   8010661b <memmove>
8010540c:	83 c4 10             	add    $0x10,%esp
      index++;
8010540f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105413:	eb 01                	jmp    80105416 <initProc+0x15a>
  memmove(buf + DIRENTSZ * 3, (char *)&de, DIRENTSZ);
  index = 4;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED )
    continue;
80105415:	90                   	nop
  de.inum = 670;
  strncpy(de.name, "inodestat\0", DIRSIZ);
  memmove(buf + DIRENTSZ * 3, (char *)&de, DIRENTSZ);
  index = 4;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105416:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
8010541a:	81 7d f0 f4 68 11 80 	cmpl   $0x801168f4,-0x10(%ebp)
80105421:	72 9b                	jb     801053be <initProc+0x102>
      itoa(p->pid, de.name);
      memmove(buf + (DIRENTSZ * index), (char *)&de, DIRENTSZ);
      index++;
    }
  }
  release(&ptable.lock);
80105423:	83 ec 0c             	sub    $0xc,%esp
80105426:	68 c0 49 11 80       	push   $0x801149c0
8010542b:	e8 30 0f 00 00       	call   80106360 <release>
80105430:	83 c4 10             	add    $0x10,%esp

  return index * DIRENTSZ;
80105433:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105436:	c1 e0 04             	shl    $0x4,%eax
}
80105439:	c9                   	leave  
8010543a:	c3                   	ret    

8010543b <initPID>:

int initPID(int inum, char *buf) {
8010543b:	55                   	push   %ebp
8010543c:	89 e5                	mov    %esp,%ebp
8010543e:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  struct dirent de;

  de.inum = inum;
80105441:	8b 45 08             	mov    0x8(%ebp),%eax
80105444:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  strncpy(de.name, ".\0", DIRSIZ);
80105448:	83 ec 04             	sub    $0x4,%esp
8010544b:	6a 0e                	push   $0xe
8010544d:	68 9e 9d 10 80       	push   $0x80109d9e
80105452:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105455:	83 c0 02             	add    $0x2,%eax
80105458:	50                   	push   %eax
80105459:	e8 a9 12 00 00       	call   80106707 <strncpy>
8010545e:	83 c4 10             	add    $0x10,%esp
  memmove(buf, (char *)&de, DIRENTSZ);
80105461:	83 ec 04             	sub    $0x4,%esp
80105464:	6a 10                	push   $0x10
80105466:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105469:	50                   	push   %eax
8010546a:	ff 75 0c             	pushl  0xc(%ebp)
8010546d:	e8 a9 11 00 00       	call   8010661b <memmove>
80105472:	83 c4 10             	add    $0x10,%esp

  de.inum = currentInode;
80105475:	a1 24 d0 10 80       	mov    0x8010d024,%eax
8010547a:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  strncpy(de.name, "..\0", DIRSIZ);
8010547e:	83 ec 04             	sub    $0x4,%esp
80105481:	6a 0e                	push   $0xe
80105483:	68 a1 9d 10 80       	push   $0x80109da1
80105488:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010548b:	83 c0 02             	add    $0x2,%eax
8010548e:	50                   	push   %eax
8010548f:	e8 73 12 00 00       	call   80106707 <strncpy>
80105494:	83 c4 10             	add    $0x10,%esp
  memmove(buf + DIRENTSZ, (char *)&de, DIRENTSZ);
80105497:	8b 45 0c             	mov    0xc(%ebp),%eax
8010549a:	8d 50 10             	lea    0x10(%eax),%edx
8010549d:	83 ec 04             	sub    $0x4,%esp
801054a0:	6a 10                	push   $0x10
801054a2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054a5:	50                   	push   %eax
801054a6:	52                   	push   %edx
801054a7:	e8 6f 11 00 00       	call   8010661b <memmove>
801054ac:	83 c4 10             	add    $0x10,%esp

  p = getProcByPID(inum / 700);
801054af:	8b 4d 08             	mov    0x8(%ebp),%ecx
801054b2:	ba 91 73 9f 5d       	mov    $0x5d9f7391,%edx
801054b7:	89 c8                	mov    %ecx,%eax
801054b9:	f7 ea                	imul   %edx
801054bb:	c1 fa 08             	sar    $0x8,%edx
801054be:	89 c8                	mov    %ecx,%eax
801054c0:	c1 f8 1f             	sar    $0x1f,%eax
801054c3:	29 c2                	sub    %eax,%edx
801054c5:	89 d0                	mov    %edx,%eax
801054c7:	83 ec 0c             	sub    $0xc,%esp
801054ca:	50                   	push   %eax
801054cb:	e8 50 fd ff ff       	call   80105220 <getProcByPID>
801054d0:	83 c4 10             	add    $0x10,%esp
801054d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

  de.inum = 10 + inum;
801054d6:	8b 45 08             	mov    0x8(%ebp),%eax
801054d9:	83 c0 0a             	add    $0xa,%eax
801054dc:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  strncpy(de.name, "status\0", DIRSIZ);
801054e0:	83 ec 04             	sub    $0x4,%esp
801054e3:	6a 0e                	push   $0xe
801054e5:	68 bb 9d 10 80       	push   $0x80109dbb
801054ea:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054ed:	83 c0 02             	add    $0x2,%eax
801054f0:	50                   	push   %eax
801054f1:	e8 11 12 00 00       	call   80106707 <strncpy>
801054f6:	83 c4 10             	add    $0x10,%esp
  memmove(buf + DIRENTSZ * 2, (char *)&de, DIRENTSZ);
801054f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801054fc:	8d 50 20             	lea    0x20(%eax),%edx
801054ff:	83 ec 04             	sub    $0x4,%esp
80105502:	6a 10                	push   $0x10
80105504:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105507:	50                   	push   %eax
80105508:	52                   	push   %edx
80105509:	e8 0d 11 00 00       	call   8010661b <memmove>
8010550e:	83 c4 10             	add    $0x10,%esp

  de.inum = 20 + inum;
80105511:	8b 45 08             	mov    0x8(%ebp),%eax
80105514:	83 c0 14             	add    $0x14,%eax
80105517:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  strncpy(de.name, "fdinfo\0", DIRSIZ);
8010551b:	83 ec 04             	sub    $0x4,%esp
8010551e:	6a 0e                	push   $0xe
80105520:	68 c3 9d 10 80       	push   $0x80109dc3
80105525:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105528:	83 c0 02             	add    $0x2,%eax
8010552b:	50                   	push   %eax
8010552c:	e8 d6 11 00 00       	call   80106707 <strncpy>
80105531:	83 c4 10             	add    $0x10,%esp
  memmove(buf + DIRENTSZ * 3, (char *)&de, DIRENTSZ);
80105534:	8b 45 0c             	mov    0xc(%ebp),%eax
80105537:	8d 50 30             	lea    0x30(%eax),%edx
8010553a:	83 ec 04             	sub    $0x4,%esp
8010553d:	6a 10                	push   $0x10
8010553f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105542:	50                   	push   %eax
80105543:	52                   	push   %edx
80105544:	e8 d2 10 00 00       	call   8010661b <memmove>
80105549:	83 c4 10             	add    $0x10,%esp

  if (p->cwd) {
8010554c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010554f:	8b 40 68             	mov    0x68(%eax),%eax
80105552:	85 c0                	test   %eax,%eax
80105554:	74 3e                	je     80105594 <initPID+0x159>
    de.inum = p->cwd->inum;
80105556:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105559:	8b 40 68             	mov    0x68(%eax),%eax
8010555c:	8b 40 04             	mov    0x4(%eax),%eax
8010555f:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
    strncpy(de.name, "cwd", DIRSIZ);
80105563:	83 ec 04             	sub    $0x4,%esp
80105566:	6a 0e                	push   $0xe
80105568:	68 cb 9d 10 80       	push   $0x80109dcb
8010556d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105570:	83 c0 02             	add    $0x2,%eax
80105573:	50                   	push   %eax
80105574:	e8 8e 11 00 00       	call   80106707 <strncpy>
80105579:	83 c4 10             	add    $0x10,%esp
    memmove(buf + DIRENTSZ * 4, (char *)&de, DIRENTSZ);
8010557c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010557f:	8d 50 40             	lea    0x40(%eax),%edx
80105582:	83 ec 04             	sub    $0x4,%esp
80105585:	6a 10                	push   $0x10
80105587:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010558a:	50                   	push   %eax
8010558b:	52                   	push   %edx
8010558c:	e8 8a 10 00 00       	call   8010661b <memmove>
80105591:	83 c4 10             	add    $0x10,%esp
  }

  return DIRENTSZ * 5;
80105594:	b8 50 00 00 00       	mov    $0x50,%eax
}
80105599:	c9                   	leave  
8010559a:	c3                   	ret    

8010559b <status>:

int status(char *buf,int pid){
8010559b:	55                   	push   %ebp
8010559c:	89 e5                	mov    %esp,%ebp
8010559e:	53                   	push   %ebx
8010559f:	83 ec 24             	sub    $0x24,%esp
  char sz[20];

  struct proc *p=getProc(pid/700);
801055a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801055a5:	ba 91 73 9f 5d       	mov    $0x5d9f7391,%edx
801055aa:	89 c8                	mov    %ecx,%eax
801055ac:	f7 ea                	imul   %edx
801055ae:	c1 fa 08             	sar    $0x8,%edx
801055b1:	89 c8                	mov    %ecx,%eax
801055b3:	c1 f8 1f             	sar    $0x1f,%eax
801055b6:	29 c2                	sub    %eax,%edx
801055b8:	89 d0                	mov    %edx,%eax
801055ba:	83 ec 0c             	sub    $0xc,%esp
801055bd:	50                   	push   %eax
801055be:	e8 38 fc ff ff       	call   801051fb <getProc>
801055c3:	83 c4 10             	add    $0x10,%esp
801055c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char* procstat = getProcState(p);
801055c9:	83 ec 0c             	sub    $0xc,%esp
801055cc:	ff 75 f4             	pushl  -0xc(%ebp)
801055cf:	e8 a0 fc ff ff       	call   80105274 <getProcState>
801055d4:	83 c4 10             	add    $0x10,%esp
801055d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  itoa(p->sz, sz);
801055da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055dd:	8b 00                	mov    (%eax),%eax
801055df:	89 c2                	mov    %eax,%edx
801055e1:	83 ec 08             	sub    $0x8,%esp
801055e4:	8d 45 dc             	lea    -0x24(%ebp),%eax
801055e7:	50                   	push   %eax
801055e8:	52                   	push   %edx
801055e9:	e8 e2 11 00 00       	call   801067d0 <itoa>
801055ee:	83 c4 10             	add    $0x10,%esp
  strncpy(buf, "Status: ", strlen("Status:  "));
801055f1:	83 ec 0c             	sub    $0xc,%esp
801055f4:	68 cf 9d 10 80       	push   $0x80109dcf
801055f9:	e8 ab 11 00 00       	call   801067a9 <strlen>
801055fe:	83 c4 10             	add    $0x10,%esp
80105601:	83 ec 04             	sub    $0x4,%esp
80105604:	50                   	push   %eax
80105605:	68 d9 9d 10 80       	push   $0x80109dd9
8010560a:	ff 75 08             	pushl  0x8(%ebp)
8010560d:	e8 f5 10 00 00       	call   80106707 <strncpy>
80105612:	83 c4 10             	add    $0x10,%esp
  strncpy(buf + strlen(buf),procstat, strlen(procstat)+1);
80105615:	83 ec 0c             	sub    $0xc,%esp
80105618:	ff 75 f0             	pushl  -0x10(%ebp)
8010561b:	e8 89 11 00 00       	call   801067a9 <strlen>
80105620:	83 c4 10             	add    $0x10,%esp
80105623:	8d 58 01             	lea    0x1(%eax),%ebx
80105626:	83 ec 0c             	sub    $0xc,%esp
80105629:	ff 75 08             	pushl  0x8(%ebp)
8010562c:	e8 78 11 00 00       	call   801067a9 <strlen>
80105631:	83 c4 10             	add    $0x10,%esp
80105634:	89 c2                	mov    %eax,%edx
80105636:	8b 45 08             	mov    0x8(%ebp),%eax
80105639:	01 d0                	add    %edx,%eax
8010563b:	83 ec 04             	sub    $0x4,%esp
8010563e:	53                   	push   %ebx
8010563f:	ff 75 f0             	pushl  -0x10(%ebp)
80105642:	50                   	push   %eax
80105643:	e8 bf 10 00 00       	call   80106707 <strncpy>
80105648:	83 c4 10             	add    $0x10,%esp
  strncpy(buf + strlen(buf), " Size: ", strlen(" Size:  "));
8010564b:	83 ec 0c             	sub    $0xc,%esp
8010564e:	68 e2 9d 10 80       	push   $0x80109de2
80105653:	e8 51 11 00 00       	call   801067a9 <strlen>
80105658:	83 c4 10             	add    $0x10,%esp
8010565b:	89 c3                	mov    %eax,%ebx
8010565d:	83 ec 0c             	sub    $0xc,%esp
80105660:	ff 75 08             	pushl  0x8(%ebp)
80105663:	e8 41 11 00 00       	call   801067a9 <strlen>
80105668:	83 c4 10             	add    $0x10,%esp
8010566b:	89 c2                	mov    %eax,%edx
8010566d:	8b 45 08             	mov    0x8(%ebp),%eax
80105670:	01 d0                	add    %edx,%eax
80105672:	83 ec 04             	sub    $0x4,%esp
80105675:	53                   	push   %ebx
80105676:	68 eb 9d 10 80       	push   $0x80109deb
8010567b:	50                   	push   %eax
8010567c:	e8 86 10 00 00       	call   80106707 <strncpy>
80105681:	83 c4 10             	add    $0x10,%esp
  strncpy(buf + strlen(buf), sz, strlen(sz)+1);
80105684:	83 ec 0c             	sub    $0xc,%esp
80105687:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010568a:	50                   	push   %eax
8010568b:	e8 19 11 00 00       	call   801067a9 <strlen>
80105690:	83 c4 10             	add    $0x10,%esp
80105693:	8d 58 01             	lea    0x1(%eax),%ebx
80105696:	83 ec 0c             	sub    $0xc,%esp
80105699:	ff 75 08             	pushl  0x8(%ebp)
8010569c:	e8 08 11 00 00       	call   801067a9 <strlen>
801056a1:	83 c4 10             	add    $0x10,%esp
801056a4:	89 c2                	mov    %eax,%edx
801056a6:	8b 45 08             	mov    0x8(%ebp),%eax
801056a9:	01 c2                	add    %eax,%edx
801056ab:	83 ec 04             	sub    $0x4,%esp
801056ae:	53                   	push   %ebx
801056af:	8d 45 dc             	lea    -0x24(%ebp),%eax
801056b2:	50                   	push   %eax
801056b3:	52                   	push   %edx
801056b4:	e8 4e 10 00 00       	call   80106707 <strncpy>
801056b9:	83 c4 10             	add    $0x10,%esp
  strncpy(buf + strlen(buf), "\n", strlen("\n "));
801056bc:	83 ec 0c             	sub    $0xc,%esp
801056bf:	68 f3 9d 10 80       	push   $0x80109df3
801056c4:	e8 e0 10 00 00       	call   801067a9 <strlen>
801056c9:	83 c4 10             	add    $0x10,%esp
801056cc:	89 c3                	mov    %eax,%ebx
801056ce:	83 ec 0c             	sub    $0xc,%esp
801056d1:	ff 75 08             	pushl  0x8(%ebp)
801056d4:	e8 d0 10 00 00       	call   801067a9 <strlen>
801056d9:	83 c4 10             	add    $0x10,%esp
801056dc:	89 c2                	mov    %eax,%edx
801056de:	8b 45 08             	mov    0x8(%ebp),%eax
801056e1:	01 d0                	add    %edx,%eax
801056e3:	83 ec 04             	sub    $0x4,%esp
801056e6:	53                   	push   %ebx
801056e7:	68 f6 9d 10 80       	push   $0x80109df6
801056ec:	50                   	push   %eax
801056ed:	e8 15 10 00 00       	call   80106707 <strncpy>
801056f2:	83 c4 10             	add    $0x10,%esp
  return strlen(buf);
801056f5:	83 ec 0c             	sub    $0xc,%esp
801056f8:	ff 75 08             	pushl  0x8(%ebp)
801056fb:	e8 a9 10 00 00       	call   801067a9 <strlen>
80105700:	83 c4 10             	add    $0x10,%esp
}
80105703:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105706:	c9                   	leave  
80105707:	c3                   	ret    

80105708 <fdinfo>:

int fdinfo(char *buf,int pid){
80105708:	55                   	push   %ebp
80105709:	89 e5                	mov    %esp,%ebp
8010570b:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  struct dirent de;

  int index=2;
8010570e:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
  de.inum = pid;
80105715:	8b 45 0c             	mov    0xc(%ebp),%eax
80105718:	66 89 45 dc          	mov    %ax,-0x24(%ebp)
  strncpy(de.name, ".\0", DIRSIZ);
8010571c:	83 ec 04             	sub    $0x4,%esp
8010571f:	6a 0e                	push   $0xe
80105721:	68 9e 9d 10 80       	push   $0x80109d9e
80105726:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105729:	83 c0 02             	add    $0x2,%eax
8010572c:	50                   	push   %eax
8010572d:	e8 d5 0f 00 00       	call   80106707 <strncpy>
80105732:	83 c4 10             	add    $0x10,%esp
  memmove(buf, (char *)&de, DIRENTSZ);
80105735:	83 ec 04             	sub    $0x4,%esp
80105738:	6a 10                	push   $0x10
8010573a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010573d:	50                   	push   %eax
8010573e:	ff 75 08             	pushl  0x8(%ebp)
80105741:	e8 d5 0e 00 00       	call   8010661b <memmove>
80105746:	83 c4 10             	add    $0x10,%esp
  de.inum = pid -20;
80105749:	8b 45 0c             	mov    0xc(%ebp),%eax
8010574c:	83 e8 14             	sub    $0x14,%eax
8010574f:	66 89 45 dc          	mov    %ax,-0x24(%ebp)
  strncpy(de.name, "..\0", DIRSIZ);
80105753:	83 ec 04             	sub    $0x4,%esp
80105756:	6a 0e                	push   $0xe
80105758:	68 a1 9d 10 80       	push   $0x80109da1
8010575d:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105760:	83 c0 02             	add    $0x2,%eax
80105763:	50                   	push   %eax
80105764:	e8 9e 0f 00 00       	call   80106707 <strncpy>
80105769:	83 c4 10             	add    $0x10,%esp
  memmove(buf + DIRENTSZ, (char *)&de, DIRENTSZ);
8010576c:	8b 45 08             	mov    0x8(%ebp),%eax
8010576f:	8d 50 10             	lea    0x10(%eax),%edx
80105772:	83 ec 04             	sub    $0x4,%esp
80105775:	6a 10                	push   $0x10
80105777:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010577a:	50                   	push   %eax
8010577b:	52                   	push   %edx
8010577c:	e8 9a 0e 00 00       	call   8010661b <memmove>
80105781:	83 c4 10             	add    $0x10,%esp
  p=getProc(pid/700);
80105784:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105787:	ba 91 73 9f 5d       	mov    $0x5d9f7391,%edx
8010578c:	89 c8                	mov    %ecx,%eax
8010578e:	f7 ea                	imul   %edx
80105790:	c1 fa 08             	sar    $0x8,%edx
80105793:	89 c8                	mov    %ecx,%eax
80105795:	c1 f8 1f             	sar    $0x1f,%eax
80105798:	29 c2                	sub    %eax,%edx
8010579a:	89 d0                	mov    %edx,%eax
8010579c:	83 ec 0c             	sub    $0xc,%esp
8010579f:	50                   	push   %eax
801057a0:	e8 56 fa ff ff       	call   801051fb <getProc>
801057a5:	83 c4 10             	add    $0x10,%esp
801057a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for (int i=0;i<NOFILE;i++){
801057ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801057b2:	eb 61                	jmp    80105815 <fdinfo+0x10d>
    if (p->ofile[i]== 0){
801057b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801057b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057ba:	83 c2 08             	add    $0x8,%edx
801057bd:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801057c1:	85 c0                	test   %eax,%eax
801057c3:	74 4b                	je     80105810 <fdinfo+0x108>
      continue;
    }
    de.inum=pid+i+1;
801057c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801057c8:	89 c2                	mov    %eax,%edx
801057ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057cd:	01 d0                	add    %edx,%eax
801057cf:	83 c0 01             	add    $0x1,%eax
801057d2:	66 89 45 dc          	mov    %ax,-0x24(%ebp)
    itoa(i, de.name);
801057d6:	83 ec 08             	sub    $0x8,%esp
801057d9:	8d 45 dc             	lea    -0x24(%ebp),%eax
801057dc:	83 c0 02             	add    $0x2,%eax
801057df:	50                   	push   %eax
801057e0:	ff 75 f0             	pushl  -0x10(%ebp)
801057e3:	e8 e8 0f 00 00       	call   801067d0 <itoa>
801057e8:	83 c4 10             	add    $0x10,%esp
    memmove(buf + DIRENTSZ * index, (char *)&de, DIRENTSZ);
801057eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ee:	c1 e0 04             	shl    $0x4,%eax
801057f1:	89 c2                	mov    %eax,%edx
801057f3:	8b 45 08             	mov    0x8(%ebp),%eax
801057f6:	01 c2                	add    %eax,%edx
801057f8:	83 ec 04             	sub    $0x4,%esp
801057fb:	6a 10                	push   $0x10
801057fd:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105800:	50                   	push   %eax
80105801:	52                   	push   %edx
80105802:	e8 14 0e 00 00       	call   8010661b <memmove>
80105807:	83 c4 10             	add    $0x10,%esp
    index++;
8010580a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010580e:	eb 01                	jmp    80105811 <fdinfo+0x109>
  strncpy(de.name, "..\0", DIRSIZ);
  memmove(buf + DIRENTSZ, (char *)&de, DIRENTSZ);
  p=getProc(pid/700);
  for (int i=0;i<NOFILE;i++){
    if (p->ofile[i]== 0){
      continue;
80105810:	90                   	nop
  memmove(buf, (char *)&de, DIRENTSZ);
  de.inum = pid -20;
  strncpy(de.name, "..\0", DIRSIZ);
  memmove(buf + DIRENTSZ, (char *)&de, DIRENTSZ);
  p=getProc(pid/700);
  for (int i=0;i<NOFILE;i++){
80105811:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105815:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80105819:	7e 99                	jle    801057b4 <fdinfo+0xac>
    de.inum=pid+i+1;
    itoa(i, de.name);
    memmove(buf + DIRENTSZ * index, (char *)&de, DIRENTSZ);
    index++;
  }
  return index* DIRENTSZ;
8010581b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010581e:	c1 e0 04             	shl    $0x4,%eax
}
80105821:	c9                   	leave  
80105822:	c3                   	ret    

80105823 <filesContent>:

int filesContent(char *buf,int pid){
80105823:	55                   	push   %ebp
80105824:	89 e5                	mov    %esp,%ebp
80105826:	53                   	push   %ebx
80105827:	83 ec 14             	sub    $0x14,%esp
  struct proc *p = getProc(pid/700);
8010582a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010582d:	ba 91 73 9f 5d       	mov    $0x5d9f7391,%edx
80105832:	89 c8                	mov    %ecx,%eax
80105834:	f7 ea                	imul   %edx
80105836:	c1 fa 08             	sar    $0x8,%edx
80105839:	89 c8                	mov    %ecx,%eax
8010583b:	c1 f8 1f             	sar    $0x1f,%eax
8010583e:	29 c2                	sub    %eax,%edx
80105840:	89 d0                	mov    %edx,%eax
80105842:	83 ec 0c             	sub    $0xc,%esp
80105845:	50                   	push   %eax
80105846:	e8 b0 f9 ff ff       	call   801051fb <getProc>
8010584b:	83 c4 10             	add    $0x10,%esp
8010584e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int fd = ((pid %700)-20) % NOFILE;
80105851:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105854:	ba 91 73 9f 5d       	mov    $0x5d9f7391,%edx
80105859:	89 c8                	mov    %ecx,%eax
8010585b:	f7 ea                	imul   %edx
8010585d:	c1 fa 08             	sar    $0x8,%edx
80105860:	89 c8                	mov    %ecx,%eax
80105862:	c1 f8 1f             	sar    $0x1f,%eax
80105865:	29 c2                	sub    %eax,%edx
80105867:	89 d0                	mov    %edx,%eax
80105869:	69 c0 bc 02 00 00    	imul   $0x2bc,%eax,%eax
8010586f:	29 c1                	sub    %eax,%ecx
80105871:	89 c8                	mov    %ecx,%eax
80105873:	8d 50 ec             	lea    -0x14(%eax),%edx
80105876:	89 d0                	mov    %edx,%eax
80105878:	c1 f8 1f             	sar    $0x1f,%eax
8010587b:	c1 e8 1c             	shr    $0x1c,%eax
8010587e:	01 c2                	add    %eax,%edx
80105880:	83 e2 0f             	and    $0xf,%edx
80105883:	29 c2                	sub    %eax,%edx
80105885:	89 d0                	mov    %edx,%eax
80105887:	89 45 f0             	mov    %eax,-0x10(%ebp)
  //cprintf("in files content   pid= %d  proc pid = %d  fd =%d \n",pid,p->pid,fd);
  strncpy(buf,"TYPE: ", strlen("TYPE:  "));
8010588a:	83 ec 0c             	sub    $0xc,%esp
8010588d:	68 f8 9d 10 80       	push   $0x80109df8
80105892:	e8 12 0f 00 00       	call   801067a9 <strlen>
80105897:	83 c4 10             	add    $0x10,%esp
8010589a:	83 ec 04             	sub    $0x4,%esp
8010589d:	50                   	push   %eax
8010589e:	68 00 9e 10 80       	push   $0x80109e00
801058a3:	ff 75 08             	pushl  0x8(%ebp)
801058a6:	e8 5c 0e 00 00       	call   80106707 <strncpy>
801058ab:	83 c4 10             	add    $0x10,%esp
  char* type = fileType(p->ofile[fd-1]);
801058ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058b1:	8d 50 ff             	lea    -0x1(%eax),%edx
801058b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058b7:	83 c2 08             	add    $0x8,%edx
801058ba:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801058be:	83 ec 0c             	sub    $0xc,%esp
801058c1:	50                   	push   %eax
801058c2:	e8 33 bb ff ff       	call   801013fa <fileType>
801058c7:	83 c4 10             	add    $0x10,%esp
801058ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  strncpy(buf+strlen(buf), type, strlen(type)+1);
801058cd:	83 ec 0c             	sub    $0xc,%esp
801058d0:	ff 75 ec             	pushl  -0x14(%ebp)
801058d3:	e8 d1 0e 00 00       	call   801067a9 <strlen>
801058d8:	83 c4 10             	add    $0x10,%esp
801058db:	8d 58 01             	lea    0x1(%eax),%ebx
801058de:	83 ec 0c             	sub    $0xc,%esp
801058e1:	ff 75 08             	pushl  0x8(%ebp)
801058e4:	e8 c0 0e 00 00       	call   801067a9 <strlen>
801058e9:	83 c4 10             	add    $0x10,%esp
801058ec:	89 c2                	mov    %eax,%edx
801058ee:	8b 45 08             	mov    0x8(%ebp),%eax
801058f1:	01 d0                	add    %edx,%eax
801058f3:	83 ec 04             	sub    $0x4,%esp
801058f6:	53                   	push   %ebx
801058f7:	ff 75 ec             	pushl  -0x14(%ebp)
801058fa:	50                   	push   %eax
801058fb:	e8 07 0e 00 00       	call   80106707 <strncpy>
80105900:	83 c4 10             	add    $0x10,%esp
  strncpy(buf + strlen(buf), "\nPOSITION: ", strlen("\nPOSITION:  "));
80105903:	83 ec 0c             	sub    $0xc,%esp
80105906:	68 07 9e 10 80       	push   $0x80109e07
8010590b:	e8 99 0e 00 00       	call   801067a9 <strlen>
80105910:	83 c4 10             	add    $0x10,%esp
80105913:	89 c3                	mov    %eax,%ebx
80105915:	83 ec 0c             	sub    $0xc,%esp
80105918:	ff 75 08             	pushl  0x8(%ebp)
8010591b:	e8 89 0e 00 00       	call   801067a9 <strlen>
80105920:	83 c4 10             	add    $0x10,%esp
80105923:	89 c2                	mov    %eax,%edx
80105925:	8b 45 08             	mov    0x8(%ebp),%eax
80105928:	01 d0                	add    %edx,%eax
8010592a:	83 ec 04             	sub    $0x4,%esp
8010592d:	53                   	push   %ebx
8010592e:	68 14 9e 10 80       	push   $0x80109e14
80105933:	50                   	push   %eax
80105934:	e8 ce 0d 00 00       	call   80106707 <strncpy>
80105939:	83 c4 10             	add    $0x10,%esp
  itoa(p->ofile[fd-1]->off, buf + strlen(buf));
8010593c:	83 ec 0c             	sub    $0xc,%esp
8010593f:	ff 75 08             	pushl  0x8(%ebp)
80105942:	e8 62 0e 00 00       	call   801067a9 <strlen>
80105947:	83 c4 10             	add    $0x10,%esp
8010594a:	89 c2                	mov    %eax,%edx
8010594c:	8b 45 08             	mov    0x8(%ebp),%eax
8010594f:	01 c2                	add    %eax,%edx
80105951:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105954:	8d 48 ff             	lea    -0x1(%eax),%ecx
80105957:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010595a:	83 c1 08             	add    $0x8,%ecx
8010595d:	8b 44 88 08          	mov    0x8(%eax,%ecx,4),%eax
80105961:	8b 40 14             	mov    0x14(%eax),%eax
80105964:	83 ec 08             	sub    $0x8,%esp
80105967:	52                   	push   %edx
80105968:	50                   	push   %eax
80105969:	e8 62 0e 00 00       	call   801067d0 <itoa>
8010596e:	83 c4 10             	add    $0x10,%esp
  strncpy(buf + strlen(buf), "\nflags: ", strlen("\nflags:  "));
80105971:	83 ec 0c             	sub    $0xc,%esp
80105974:	68 20 9e 10 80       	push   $0x80109e20
80105979:	e8 2b 0e 00 00       	call   801067a9 <strlen>
8010597e:	83 c4 10             	add    $0x10,%esp
80105981:	89 c3                	mov    %eax,%ebx
80105983:	83 ec 0c             	sub    $0xc,%esp
80105986:	ff 75 08             	pushl  0x8(%ebp)
80105989:	e8 1b 0e 00 00       	call   801067a9 <strlen>
8010598e:	83 c4 10             	add    $0x10,%esp
80105991:	89 c2                	mov    %eax,%edx
80105993:	8b 45 08             	mov    0x8(%ebp),%eax
80105996:	01 d0                	add    %edx,%eax
80105998:	83 ec 04             	sub    $0x4,%esp
8010599b:	53                   	push   %ebx
8010599c:	68 2a 9e 10 80       	push   $0x80109e2a
801059a1:	50                   	push   %eax
801059a2:	e8 60 0d 00 00       	call   80106707 <strncpy>
801059a7:	83 c4 10             	add    $0x10,%esp
  if(p->ofile[fd-1]->readable == 1 && p->ofile[fd-1]->writable == 1)
801059aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059ad:	8d 50 ff             	lea    -0x1(%eax),%edx
801059b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059b3:	83 c2 08             	add    $0x8,%edx
801059b6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801059ba:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801059be:	3c 01                	cmp    $0x1,%al
801059c0:	75 56                	jne    80105a18 <filesContent+0x1f5>
801059c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059c5:	8d 50 ff             	lea    -0x1(%eax),%edx
801059c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059cb:	83 c2 08             	add    $0x8,%edx
801059ce:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801059d2:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801059d6:	3c 01                	cmp    $0x1,%al
801059d8:	75 3e                	jne    80105a18 <filesContent+0x1f5>
  strncpy(buf + strlen(buf), "RDWR", strlen("RDWR "));
801059da:	83 ec 0c             	sub    $0xc,%esp
801059dd:	68 33 9e 10 80       	push   $0x80109e33
801059e2:	e8 c2 0d 00 00       	call   801067a9 <strlen>
801059e7:	83 c4 10             	add    $0x10,%esp
801059ea:	89 c3                	mov    %eax,%ebx
801059ec:	83 ec 0c             	sub    $0xc,%esp
801059ef:	ff 75 08             	pushl  0x8(%ebp)
801059f2:	e8 b2 0d 00 00       	call   801067a9 <strlen>
801059f7:	83 c4 10             	add    $0x10,%esp
801059fa:	89 c2                	mov    %eax,%edx
801059fc:	8b 45 08             	mov    0x8(%ebp),%eax
801059ff:	01 d0                	add    %edx,%eax
80105a01:	83 ec 04             	sub    $0x4,%esp
80105a04:	53                   	push   %ebx
80105a05:	68 39 9e 10 80       	push   $0x80109e39
80105a0a:	50                   	push   %eax
80105a0b:	e8 f7 0c 00 00       	call   80106707 <strncpy>
80105a10:	83 c4 10             	add    $0x10,%esp
80105a13:	e9 12 01 00 00       	jmp    80105b2a <filesContent+0x307>
  else if(p->ofile[fd-1]->readable == 0 && p->ofile[fd-1]->writable == 1)
80105a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a1b:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a21:	83 c2 08             	add    $0x8,%edx
80105a24:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105a28:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80105a2c:	84 c0                	test   %al,%al
80105a2e:	75 56                	jne    80105a86 <filesContent+0x263>
80105a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a33:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a39:	83 c2 08             	add    $0x8,%edx
80105a3c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105a40:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80105a44:	3c 01                	cmp    $0x1,%al
80105a46:	75 3e                	jne    80105a86 <filesContent+0x263>
  strncpy(buf + strlen(buf), "RDONLY", strlen("RDONLY "));
80105a48:	83 ec 0c             	sub    $0xc,%esp
80105a4b:	68 3e 9e 10 80       	push   $0x80109e3e
80105a50:	e8 54 0d 00 00       	call   801067a9 <strlen>
80105a55:	83 c4 10             	add    $0x10,%esp
80105a58:	89 c3                	mov    %eax,%ebx
80105a5a:	83 ec 0c             	sub    $0xc,%esp
80105a5d:	ff 75 08             	pushl  0x8(%ebp)
80105a60:	e8 44 0d 00 00       	call   801067a9 <strlen>
80105a65:	83 c4 10             	add    $0x10,%esp
80105a68:	89 c2                	mov    %eax,%edx
80105a6a:	8b 45 08             	mov    0x8(%ebp),%eax
80105a6d:	01 d0                	add    %edx,%eax
80105a6f:	83 ec 04             	sub    $0x4,%esp
80105a72:	53                   	push   %ebx
80105a73:	68 46 9e 10 80       	push   $0x80109e46
80105a78:	50                   	push   %eax
80105a79:	e8 89 0c 00 00       	call   80106707 <strncpy>
80105a7e:	83 c4 10             	add    $0x10,%esp
80105a81:	e9 a4 00 00 00       	jmp    80105b2a <filesContent+0x307>
  else if(p->ofile[fd-1]->readable == 1 && p->ofile[fd-1]->writable == 0)
80105a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a89:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a8f:	83 c2 08             	add    $0x8,%edx
80105a92:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105a96:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80105a9a:	3c 01                	cmp    $0x1,%al
80105a9c:	75 53                	jne    80105af1 <filesContent+0x2ce>
80105a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aa1:	8d 50 ff             	lea    -0x1(%eax),%edx
80105aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aa7:	83 c2 08             	add    $0x8,%edx
80105aaa:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105aae:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80105ab2:	84 c0                	test   %al,%al
80105ab4:	75 3b                	jne    80105af1 <filesContent+0x2ce>
  strncpy(buf + strlen(buf), "WRONLY", strlen("WRONLY "));
80105ab6:	83 ec 0c             	sub    $0xc,%esp
80105ab9:	68 4d 9e 10 80       	push   $0x80109e4d
80105abe:	e8 e6 0c 00 00       	call   801067a9 <strlen>
80105ac3:	83 c4 10             	add    $0x10,%esp
80105ac6:	89 c3                	mov    %eax,%ebx
80105ac8:	83 ec 0c             	sub    $0xc,%esp
80105acb:	ff 75 08             	pushl  0x8(%ebp)
80105ace:	e8 d6 0c 00 00       	call   801067a9 <strlen>
80105ad3:	83 c4 10             	add    $0x10,%esp
80105ad6:	89 c2                	mov    %eax,%edx
80105ad8:	8b 45 08             	mov    0x8(%ebp),%eax
80105adb:	01 d0                	add    %edx,%eax
80105add:	83 ec 04             	sub    $0x4,%esp
80105ae0:	53                   	push   %ebx
80105ae1:	68 55 9e 10 80       	push   $0x80109e55
80105ae6:	50                   	push   %eax
80105ae7:	e8 1b 0c 00 00       	call   80106707 <strncpy>
80105aec:	83 c4 10             	add    $0x10,%esp
80105aef:	eb 39                	jmp    80105b2a <filesContent+0x307>
  else
  strncpy(buf + strlen(buf), "no flags , sad so sad", strlen("no flags , sad so sad "));
80105af1:	83 ec 0c             	sub    $0xc,%esp
80105af4:	68 5c 9e 10 80       	push   $0x80109e5c
80105af9:	e8 ab 0c 00 00       	call   801067a9 <strlen>
80105afe:	83 c4 10             	add    $0x10,%esp
80105b01:	89 c3                	mov    %eax,%ebx
80105b03:	83 ec 0c             	sub    $0xc,%esp
80105b06:	ff 75 08             	pushl  0x8(%ebp)
80105b09:	e8 9b 0c 00 00       	call   801067a9 <strlen>
80105b0e:	83 c4 10             	add    $0x10,%esp
80105b11:	89 c2                	mov    %eax,%edx
80105b13:	8b 45 08             	mov    0x8(%ebp),%eax
80105b16:	01 d0                	add    %edx,%eax
80105b18:	83 ec 04             	sub    $0x4,%esp
80105b1b:	53                   	push   %ebx
80105b1c:	68 73 9e 10 80       	push   $0x80109e73
80105b21:	50                   	push   %eax
80105b22:	e8 e0 0b 00 00       	call   80106707 <strncpy>
80105b27:	83 c4 10             	add    $0x10,%esp
  if (p->ofile[fd-1]->type == FD_INODE){
80105b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b2d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b33:	83 c2 08             	add    $0x8,%edx
80105b36:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105b3a:	8b 00                	mov    (%eax),%eax
80105b3c:	83 f8 02             	cmp    $0x2,%eax
80105b3f:	75 71                	jne    80105bb2 <filesContent+0x38f>
    strncpy(buf + strlen(buf), "\nINODE NUMBER: ", strlen("\nINODE NUMBER:  "));
80105b41:	83 ec 0c             	sub    $0xc,%esp
80105b44:	68 89 9e 10 80       	push   $0x80109e89
80105b49:	e8 5b 0c 00 00       	call   801067a9 <strlen>
80105b4e:	83 c4 10             	add    $0x10,%esp
80105b51:	89 c3                	mov    %eax,%ebx
80105b53:	83 ec 0c             	sub    $0xc,%esp
80105b56:	ff 75 08             	pushl  0x8(%ebp)
80105b59:	e8 4b 0c 00 00       	call   801067a9 <strlen>
80105b5e:	83 c4 10             	add    $0x10,%esp
80105b61:	89 c2                	mov    %eax,%edx
80105b63:	8b 45 08             	mov    0x8(%ebp),%eax
80105b66:	01 d0                	add    %edx,%eax
80105b68:	83 ec 04             	sub    $0x4,%esp
80105b6b:	53                   	push   %ebx
80105b6c:	68 9a 9e 10 80       	push   $0x80109e9a
80105b71:	50                   	push   %eax
80105b72:	e8 90 0b 00 00       	call   80106707 <strncpy>
80105b77:	83 c4 10             	add    $0x10,%esp
    itoa(p->ofile[fd-1]->ip->inum, buf + strlen(buf));
80105b7a:	83 ec 0c             	sub    $0xc,%esp
80105b7d:	ff 75 08             	pushl  0x8(%ebp)
80105b80:	e8 24 0c 00 00       	call   801067a9 <strlen>
80105b85:	83 c4 10             	add    $0x10,%esp
80105b88:	89 c2                	mov    %eax,%edx
80105b8a:	8b 45 08             	mov    0x8(%ebp),%eax
80105b8d:	01 c2                	add    %eax,%edx
80105b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b92:	8d 48 ff             	lea    -0x1(%eax),%ecx
80105b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b98:	83 c1 08             	add    $0x8,%ecx
80105b9b:	8b 44 88 08          	mov    0x8(%eax,%ecx,4),%eax
80105b9f:	8b 40 10             	mov    0x10(%eax),%eax
80105ba2:	8b 40 04             	mov    0x4(%eax),%eax
80105ba5:	83 ec 08             	sub    $0x8,%esp
80105ba8:	52                   	push   %edx
80105ba9:	50                   	push   %eax
80105baa:	e8 21 0c 00 00       	call   801067d0 <itoa>
80105baf:	83 c4 10             	add    $0x10,%esp
  }
  strncpy(buf + strlen(buf), "\nREFERENCE COUNT: ", strlen("\nREFERENCE COUNT:  "));
80105bb2:	83 ec 0c             	sub    $0xc,%esp
80105bb5:	68 aa 9e 10 80       	push   $0x80109eaa
80105bba:	e8 ea 0b 00 00       	call   801067a9 <strlen>
80105bbf:	83 c4 10             	add    $0x10,%esp
80105bc2:	89 c3                	mov    %eax,%ebx
80105bc4:	83 ec 0c             	sub    $0xc,%esp
80105bc7:	ff 75 08             	pushl  0x8(%ebp)
80105bca:	e8 da 0b 00 00       	call   801067a9 <strlen>
80105bcf:	83 c4 10             	add    $0x10,%esp
80105bd2:	89 c2                	mov    %eax,%edx
80105bd4:	8b 45 08             	mov    0x8(%ebp),%eax
80105bd7:	01 d0                	add    %edx,%eax
80105bd9:	83 ec 04             	sub    $0x4,%esp
80105bdc:	53                   	push   %ebx
80105bdd:	68 be 9e 10 80       	push   $0x80109ebe
80105be2:	50                   	push   %eax
80105be3:	e8 1f 0b 00 00       	call   80106707 <strncpy>
80105be8:	83 c4 10             	add    $0x10,%esp
  itoa(p->ofile[fd-1]->ip->ref, buf + strlen(buf));
80105beb:	83 ec 0c             	sub    $0xc,%esp
80105bee:	ff 75 08             	pushl  0x8(%ebp)
80105bf1:	e8 b3 0b 00 00       	call   801067a9 <strlen>
80105bf6:	83 c4 10             	add    $0x10,%esp
80105bf9:	89 c2                	mov    %eax,%edx
80105bfb:	8b 45 08             	mov    0x8(%ebp),%eax
80105bfe:	01 c2                	add    %eax,%edx
80105c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c03:	8d 48 ff             	lea    -0x1(%eax),%ecx
80105c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c09:	83 c1 08             	add    $0x8,%ecx
80105c0c:	8b 44 88 08          	mov    0x8(%eax,%ecx,4),%eax
80105c10:	8b 40 10             	mov    0x10(%eax),%eax
80105c13:	8b 40 08             	mov    0x8(%eax),%eax
80105c16:	83 ec 08             	sub    $0x8,%esp
80105c19:	52                   	push   %edx
80105c1a:	50                   	push   %eax
80105c1b:	e8 b0 0b 00 00       	call   801067d0 <itoa>
80105c20:	83 c4 10             	add    $0x10,%esp
  strncpy(buf + strlen(buf), "\n", strlen(" \n "));
80105c23:	83 ec 0c             	sub    $0xc,%esp
80105c26:	68 d1 9e 10 80       	push   $0x80109ed1
80105c2b:	e8 79 0b 00 00       	call   801067a9 <strlen>
80105c30:	83 c4 10             	add    $0x10,%esp
80105c33:	89 c3                	mov    %eax,%ebx
80105c35:	83 ec 0c             	sub    $0xc,%esp
80105c38:	ff 75 08             	pushl  0x8(%ebp)
80105c3b:	e8 69 0b 00 00       	call   801067a9 <strlen>
80105c40:	83 c4 10             	add    $0x10,%esp
80105c43:	89 c2                	mov    %eax,%edx
80105c45:	8b 45 08             	mov    0x8(%ebp),%eax
80105c48:	01 d0                	add    %edx,%eax
80105c4a:	83 ec 04             	sub    $0x4,%esp
80105c4d:	53                   	push   %ebx
80105c4e:	68 f6 9d 10 80       	push   $0x80109df6
80105c53:	50                   	push   %eax
80105c54:	e8 ae 0a 00 00       	call   80106707 <strncpy>
80105c59:	83 c4 10             	add    $0x10,%esp
  return strlen(buf);
80105c5c:	83 ec 0c             	sub    $0xc,%esp
80105c5f:	ff 75 08             	pushl  0x8(%ebp)
80105c62:	e8 42 0b 00 00       	call   801067a9 <strlen>
80105c67:	83 c4 10             	add    $0x10,%esp
}
80105c6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c6d:	c9                   	leave  
80105c6e:	c3                   	ret    

80105c6f <blockstat>:
//  int bytes = readi(p->cwd, buf, off, n);
//      iunlock(p->cwd);
// return bytes;
// }

int blockstat(char* buf){
80105c6f:	55                   	push   %ebp
80105c70:	89 e5                	mov    %esp,%ebp
80105c72:	53                   	push   %ebx
80105c73:	83 ec 04             	sub    $0x4,%esp
  strncpy(buf, "Free blocks: ", strlen("Free blocks:  "));
80105c76:	83 ec 0c             	sub    $0xc,%esp
80105c79:	68 d5 9e 10 80       	push   $0x80109ed5
80105c7e:	e8 26 0b 00 00       	call   801067a9 <strlen>
80105c83:	83 c4 10             	add    $0x10,%esp
80105c86:	83 ec 04             	sub    $0x4,%esp
80105c89:	50                   	push   %eax
80105c8a:	68 e4 9e 10 80       	push   $0x80109ee4
80105c8f:	ff 75 08             	pushl  0x8(%ebp)
80105c92:	e8 70 0a 00 00       	call   80106707 <strncpy>
80105c97:	83 c4 10             	add    $0x10,%esp
  itoa(get_free_block_number(), buf + strlen(buf));
80105c9a:	83 ec 0c             	sub    $0xc,%esp
80105c9d:	ff 75 08             	pushl  0x8(%ebp)
80105ca0:	e8 04 0b 00 00       	call   801067a9 <strlen>
80105ca5:	83 c4 10             	add    $0x10,%esp
80105ca8:	89 c2                	mov    %eax,%edx
80105caa:	8b 45 08             	mov    0x8(%ebp),%eax
80105cad:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80105cb0:	e8 88 a6 ff ff       	call   8010033d <get_free_block_number>
80105cb5:	83 ec 08             	sub    $0x8,%esp
80105cb8:	53                   	push   %ebx
80105cb9:	50                   	push   %eax
80105cba:	e8 11 0b 00 00       	call   801067d0 <itoa>
80105cbf:	83 c4 10             	add    $0x10,%esp
  strncpy(buf + strlen(buf),"\nTotal blocks: ", strlen("\nTotal blocks:  "));
80105cc2:	83 ec 0c             	sub    $0xc,%esp
80105cc5:	68 f2 9e 10 80       	push   $0x80109ef2
80105cca:	e8 da 0a 00 00       	call   801067a9 <strlen>
80105ccf:	83 c4 10             	add    $0x10,%esp
80105cd2:	89 c3                	mov    %eax,%ebx
80105cd4:	83 ec 0c             	sub    $0xc,%esp
80105cd7:	ff 75 08             	pushl  0x8(%ebp)
80105cda:	e8 ca 0a 00 00       	call   801067a9 <strlen>
80105cdf:	83 c4 10             	add    $0x10,%esp
80105ce2:	89 c2                	mov    %eax,%edx
80105ce4:	8b 45 08             	mov    0x8(%ebp),%eax
80105ce7:	01 d0                	add    %edx,%eax
80105ce9:	83 ec 04             	sub    $0x4,%esp
80105cec:	53                   	push   %ebx
80105ced:	68 03 9f 10 80       	push   $0x80109f03
80105cf2:	50                   	push   %eax
80105cf3:	e8 0f 0a 00 00       	call   80106707 <strncpy>
80105cf8:	83 c4 10             	add    $0x10,%esp
  itoa(get_total_block_number(), buf + strlen(buf));
80105cfb:	83 ec 0c             	sub    $0xc,%esp
80105cfe:	ff 75 08             	pushl  0x8(%ebp)
80105d01:	e8 a3 0a 00 00       	call   801067a9 <strlen>
80105d06:	83 c4 10             	add    $0x10,%esp
80105d09:	89 c2                	mov    %eax,%edx
80105d0b:	8b 45 08             	mov    0x8(%ebp),%eax
80105d0e:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80105d11:	e8 31 a6 ff ff       	call   80100347 <get_total_block_number>
80105d16:	83 ec 08             	sub    $0x8,%esp
80105d19:	53                   	push   %ebx
80105d1a:	50                   	push   %eax
80105d1b:	e8 b0 0a 00 00       	call   801067d0 <itoa>
80105d20:	83 c4 10             	add    $0x10,%esp
  strncpy(buf + strlen(buf), "\nHits ratio: ", strlen("\nHits ratio:  "));
80105d23:	83 ec 0c             	sub    $0xc,%esp
80105d26:	68 13 9f 10 80       	push   $0x80109f13
80105d2b:	e8 79 0a 00 00       	call   801067a9 <strlen>
80105d30:	83 c4 10             	add    $0x10,%esp
80105d33:	89 c3                	mov    %eax,%ebx
80105d35:	83 ec 0c             	sub    $0xc,%esp
80105d38:	ff 75 08             	pushl  0x8(%ebp)
80105d3b:	e8 69 0a 00 00       	call   801067a9 <strlen>
80105d40:	83 c4 10             	add    $0x10,%esp
80105d43:	89 c2                	mov    %eax,%edx
80105d45:	8b 45 08             	mov    0x8(%ebp),%eax
80105d48:	01 d0                	add    %edx,%eax
80105d4a:	83 ec 04             	sub    $0x4,%esp
80105d4d:	53                   	push   %ebx
80105d4e:	68 22 9f 10 80       	push   $0x80109f22
80105d53:	50                   	push   %eax
80105d54:	e8 ae 09 00 00       	call   80106707 <strncpy>
80105d59:	83 c4 10             	add    $0x10,%esp
  itoa(get_number_of_hits(), buf + strlen(buf));
80105d5c:	83 ec 0c             	sub    $0xc,%esp
80105d5f:	ff 75 08             	pushl  0x8(%ebp)
80105d62:	e8 42 0a 00 00       	call   801067a9 <strlen>
80105d67:	83 c4 10             	add    $0x10,%esp
80105d6a:	89 c2                	mov    %eax,%edx
80105d6c:	8b 45 08             	mov    0x8(%ebp),%eax
80105d6f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80105d72:	e8 e4 a5 ff ff       	call   8010035b <get_number_of_hits>
80105d77:	83 ec 08             	sub    $0x8,%esp
80105d7a:	53                   	push   %ebx
80105d7b:	50                   	push   %eax
80105d7c:	e8 4f 0a 00 00       	call   801067d0 <itoa>
80105d81:	83 c4 10             	add    $0x10,%esp
  strncpy(buf + strlen(buf), "/", strlen("/ "));
80105d84:	83 ec 0c             	sub    $0xc,%esp
80105d87:	68 30 9f 10 80       	push   $0x80109f30
80105d8c:	e8 18 0a 00 00       	call   801067a9 <strlen>
80105d91:	83 c4 10             	add    $0x10,%esp
80105d94:	89 c3                	mov    %eax,%ebx
80105d96:	83 ec 0c             	sub    $0xc,%esp
80105d99:	ff 75 08             	pushl  0x8(%ebp)
80105d9c:	e8 08 0a 00 00       	call   801067a9 <strlen>
80105da1:	83 c4 10             	add    $0x10,%esp
80105da4:	89 c2                	mov    %eax,%edx
80105da6:	8b 45 08             	mov    0x8(%ebp),%eax
80105da9:	01 d0                	add    %edx,%eax
80105dab:	83 ec 04             	sub    $0x4,%esp
80105dae:	53                   	push   %ebx
80105daf:	68 33 9f 10 80       	push   $0x80109f33
80105db4:	50                   	push   %eax
80105db5:	e8 4d 09 00 00       	call   80106707 <strncpy>
80105dba:	83 c4 10             	add    $0x10,%esp
  itoa(get_number_of_block_acsses(), buf + strlen(buf));
80105dbd:	83 ec 0c             	sub    $0xc,%esp
80105dc0:	ff 75 08             	pushl  0x8(%ebp)
80105dc3:	e8 e1 09 00 00       	call   801067a9 <strlen>
80105dc8:	83 c4 10             	add    $0x10,%esp
80105dcb:	89 c2                	mov    %eax,%edx
80105dcd:	8b 45 08             	mov    0x8(%ebp),%eax
80105dd0:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80105dd3:	e8 79 a5 ff ff       	call   80100351 <get_number_of_block_acsses>
80105dd8:	83 ec 08             	sub    $0x8,%esp
80105ddb:	53                   	push   %ebx
80105ddc:	50                   	push   %eax
80105ddd:	e8 ee 09 00 00       	call   801067d0 <itoa>
80105de2:	83 c4 10             	add    $0x10,%esp
  strncpy(buf + strlen(buf), "\n", strlen(" \n "));
80105de5:	83 ec 0c             	sub    $0xc,%esp
80105de8:	68 d1 9e 10 80       	push   $0x80109ed1
80105ded:	e8 b7 09 00 00       	call   801067a9 <strlen>
80105df2:	83 c4 10             	add    $0x10,%esp
80105df5:	89 c3                	mov    %eax,%ebx
80105df7:	83 ec 0c             	sub    $0xc,%esp
80105dfa:	ff 75 08             	pushl  0x8(%ebp)
80105dfd:	e8 a7 09 00 00       	call   801067a9 <strlen>
80105e02:	83 c4 10             	add    $0x10,%esp
80105e05:	89 c2                	mov    %eax,%edx
80105e07:	8b 45 08             	mov    0x8(%ebp),%eax
80105e0a:	01 d0                	add    %edx,%eax
80105e0c:	83 ec 04             	sub    $0x4,%esp
80105e0f:	53                   	push   %ebx
80105e10:	68 f6 9d 10 80       	push   $0x80109df6
80105e15:	50                   	push   %eax
80105e16:	e8 ec 08 00 00       	call   80106707 <strncpy>
80105e1b:	83 c4 10             	add    $0x10,%esp
  return strlen(buf);
80105e1e:	83 ec 0c             	sub    $0xc,%esp
80105e21:	ff 75 08             	pushl  0x8(%ebp)
80105e24:	e8 80 09 00 00       	call   801067a9 <strlen>
80105e29:	83 c4 10             	add    $0x10,%esp
}
80105e2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e2f:	c9                   	leave  
80105e30:	c3                   	ret    

80105e31 <inodestat>:

int inodestat(char* buf){
80105e31:	55                   	push   %ebp
80105e32:	89 e5                	mov    %esp,%ebp
80105e34:	53                   	push   %ebx
80105e35:	83 ec 04             	sub    $0x4,%esp
  strncpy(buf, "Free inodes: ", strlen("Free inodes:  "));
80105e38:	83 ec 0c             	sub    $0xc,%esp
80105e3b:	68 35 9f 10 80       	push   $0x80109f35
80105e40:	e8 64 09 00 00       	call   801067a9 <strlen>
80105e45:	83 c4 10             	add    $0x10,%esp
80105e48:	83 ec 04             	sub    $0x4,%esp
80105e4b:	50                   	push   %eax
80105e4c:	68 44 9f 10 80       	push   $0x80109f44
80105e51:	ff 75 08             	pushl  0x8(%ebp)
80105e54:	e8 ae 08 00 00       	call   80106707 <strncpy>
80105e59:	83 c4 10             	add    $0x10,%esp
  itoa(get_number_of_free_inode(), buf + strlen(buf));
80105e5c:	83 ec 0c             	sub    $0xc,%esp
80105e5f:	ff 75 08             	pushl  0x8(%ebp)
80105e62:	e8 42 09 00 00       	call   801067a9 <strlen>
80105e67:	83 c4 10             	add    $0x10,%esp
80105e6a:	89 c2                	mov    %eax,%edx
80105e6c:	8b 45 08             	mov    0x8(%ebp),%eax
80105e6f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80105e72:	e8 67 c8 ff ff       	call   801026de <get_number_of_free_inode>
80105e77:	83 ec 08             	sub    $0x8,%esp
80105e7a:	53                   	push   %ebx
80105e7b:	50                   	push   %eax
80105e7c:	e8 4f 09 00 00       	call   801067d0 <itoa>
80105e81:	83 c4 10             	add    $0x10,%esp
  strncpy(buf + strlen(buf),"\nValid inode: ", strlen("\nValid inode:  "));
80105e84:	83 ec 0c             	sub    $0xc,%esp
80105e87:	68 52 9f 10 80       	push   $0x80109f52
80105e8c:	e8 18 09 00 00       	call   801067a9 <strlen>
80105e91:	83 c4 10             	add    $0x10,%esp
80105e94:	89 c3                	mov    %eax,%ebx
80105e96:	83 ec 0c             	sub    $0xc,%esp
80105e99:	ff 75 08             	pushl  0x8(%ebp)
80105e9c:	e8 08 09 00 00       	call   801067a9 <strlen>
80105ea1:	83 c4 10             	add    $0x10,%esp
80105ea4:	89 c2                	mov    %eax,%edx
80105ea6:	8b 45 08             	mov    0x8(%ebp),%eax
80105ea9:	01 d0                	add    %edx,%eax
80105eab:	83 ec 04             	sub    $0x4,%esp
80105eae:	53                   	push   %ebx
80105eaf:	68 62 9f 10 80       	push   $0x80109f62
80105eb4:	50                   	push   %eax
80105eb5:	e8 4d 08 00 00       	call   80106707 <strncpy>
80105eba:	83 c4 10             	add    $0x10,%esp
  itoa(number_of_valid_inode(), buf + strlen(buf));
80105ebd:	83 ec 0c             	sub    $0xc,%esp
80105ec0:	ff 75 08             	pushl  0x8(%ebp)
80105ec3:	e8 e1 08 00 00       	call   801067a9 <strlen>
80105ec8:	83 c4 10             	add    $0x10,%esp
80105ecb:	89 c2                	mov    %eax,%edx
80105ecd:	8b 45 08             	mov    0x8(%ebp),%eax
80105ed0:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80105ed3:	e8 5c c8 ff ff       	call   80102734 <number_of_valid_inode>
80105ed8:	83 ec 08             	sub    $0x8,%esp
80105edb:	53                   	push   %ebx
80105edc:	50                   	push   %eax
80105edd:	e8 ee 08 00 00       	call   801067d0 <itoa>
80105ee2:	83 c4 10             	add    $0x10,%esp
  strncpy(buf + strlen(buf), "\nRefs per inode: ", strlen("\nRefs per inode:  "));
80105ee5:	83 ec 0c             	sub    $0xc,%esp
80105ee8:	68 71 9f 10 80       	push   $0x80109f71
80105eed:	e8 b7 08 00 00       	call   801067a9 <strlen>
80105ef2:	83 c4 10             	add    $0x10,%esp
80105ef5:	89 c3                	mov    %eax,%ebx
80105ef7:	83 ec 0c             	sub    $0xc,%esp
80105efa:	ff 75 08             	pushl  0x8(%ebp)
80105efd:	e8 a7 08 00 00       	call   801067a9 <strlen>
80105f02:	83 c4 10             	add    $0x10,%esp
80105f05:	89 c2                	mov    %eax,%edx
80105f07:	8b 45 08             	mov    0x8(%ebp),%eax
80105f0a:	01 d0                	add    %edx,%eax
80105f0c:	83 ec 04             	sub    $0x4,%esp
80105f0f:	53                   	push   %ebx
80105f10:	68 84 9f 10 80       	push   $0x80109f84
80105f15:	50                   	push   %eax
80105f16:	e8 ec 07 00 00       	call   80106707 <strncpy>
80105f1b:	83 c4 10             	add    $0x10,%esp
  itoa(get_number_of_ref(), buf + strlen(buf));
80105f1e:	83 ec 0c             	sub    $0xc,%esp
80105f21:	ff 75 08             	pushl  0x8(%ebp)
80105f24:	e8 80 08 00 00       	call   801067a9 <strlen>
80105f29:	83 c4 10             	add    $0x10,%esp
80105f2c:	89 c2                	mov    %eax,%edx
80105f2e:	8b 45 08             	mov    0x8(%ebp),%eax
80105f31:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80105f34:	e8 54 c8 ff ff       	call   8010278d <get_number_of_ref>
80105f39:	83 ec 08             	sub    $0x8,%esp
80105f3c:	53                   	push   %ebx
80105f3d:	50                   	push   %eax
80105f3e:	e8 8d 08 00 00       	call   801067d0 <itoa>
80105f43:	83 c4 10             	add    $0x10,%esp
  strncpy(buf + strlen(buf), "/", strlen("/ "));
80105f46:	83 ec 0c             	sub    $0xc,%esp
80105f49:	68 30 9f 10 80       	push   $0x80109f30
80105f4e:	e8 56 08 00 00       	call   801067a9 <strlen>
80105f53:	83 c4 10             	add    $0x10,%esp
80105f56:	89 c3                	mov    %eax,%ebx
80105f58:	83 ec 0c             	sub    $0xc,%esp
80105f5b:	ff 75 08             	pushl  0x8(%ebp)
80105f5e:	e8 46 08 00 00       	call   801067a9 <strlen>
80105f63:	83 c4 10             	add    $0x10,%esp
80105f66:	89 c2                	mov    %eax,%edx
80105f68:	8b 45 08             	mov    0x8(%ebp),%eax
80105f6b:	01 d0                	add    %edx,%eax
80105f6d:	83 ec 04             	sub    $0x4,%esp
80105f70:	53                   	push   %ebx
80105f71:	68 33 9f 10 80       	push   $0x80109f33
80105f76:	50                   	push   %eax
80105f77:	e8 8b 07 00 00       	call   80106707 <strncpy>
80105f7c:	83 c4 10             	add    $0x10,%esp
  itoa(get_number_of_active_inode(), buf + strlen(buf));
80105f7f:	83 ec 0c             	sub    $0xc,%esp
80105f82:	ff 75 08             	pushl  0x8(%ebp)
80105f85:	e8 1f 08 00 00       	call   801067a9 <strlen>
80105f8a:	83 c4 10             	add    $0x10,%esp
80105f8d:	89 c2                	mov    %eax,%edx
80105f8f:	8b 45 08             	mov    0x8(%ebp),%eax
80105f92:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80105f95:	e8 44 c8 ff ff       	call   801027de <get_number_of_active_inode>
80105f9a:	83 ec 08             	sub    $0x8,%esp
80105f9d:	53                   	push   %ebx
80105f9e:	50                   	push   %eax
80105f9f:	e8 2c 08 00 00       	call   801067d0 <itoa>
80105fa4:	83 c4 10             	add    $0x10,%esp
  strncpy(buf + strlen(buf), "\n", strlen(" \n "));
80105fa7:	83 ec 0c             	sub    $0xc,%esp
80105faa:	68 d1 9e 10 80       	push   $0x80109ed1
80105faf:	e8 f5 07 00 00       	call   801067a9 <strlen>
80105fb4:	83 c4 10             	add    $0x10,%esp
80105fb7:	89 c3                	mov    %eax,%ebx
80105fb9:	83 ec 0c             	sub    $0xc,%esp
80105fbc:	ff 75 08             	pushl  0x8(%ebp)
80105fbf:	e8 e5 07 00 00       	call   801067a9 <strlen>
80105fc4:	83 c4 10             	add    $0x10,%esp
80105fc7:	89 c2                	mov    %eax,%edx
80105fc9:	8b 45 08             	mov    0x8(%ebp),%eax
80105fcc:	01 d0                	add    %edx,%eax
80105fce:	83 ec 04             	sub    $0x4,%esp
80105fd1:	53                   	push   %ebx
80105fd2:	68 f6 9d 10 80       	push   $0x80109df6
80105fd7:	50                   	push   %eax
80105fd8:	e8 2a 07 00 00       	call   80106707 <strncpy>
80105fdd:	83 c4 10             	add    $0x10,%esp
  return strlen(buf);
80105fe0:	83 ec 0c             	sub    $0xc,%esp
80105fe3:	ff 75 08             	pushl  0x8(%ebp)
80105fe6:	e8 be 07 00 00       	call   801067a9 <strlen>
80105feb:	83 c4 10             	add    $0x10,%esp
}
80105fee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ff1:	c9                   	leave  
80105ff2:	c3                   	ret    

80105ff3 <procfsisdir>:

int procfsisdir(struct inode *ip) {
80105ff3:	55                   	push   %ebp
80105ff4:	89 e5                	mov    %esp,%ebp
  //proc minor is never initilized , all other inodes are initlitzed
  return (ip->minor == 0  || ip->minor == T_DIR );
80105ff6:	8b 45 08             	mov    0x8(%ebp),%eax
80105ff9:	0f b7 40 14          	movzwl 0x14(%eax),%eax
80105ffd:	66 85 c0             	test   %ax,%ax
80106000:	74 0d                	je     8010600f <procfsisdir+0x1c>
80106002:	8b 45 08             	mov    0x8(%ebp),%eax
80106005:	0f b7 40 14          	movzwl 0x14(%eax),%eax
80106009:	66 83 f8 01          	cmp    $0x1,%ax
8010600d:	75 07                	jne    80106016 <procfsisdir+0x23>
8010600f:	b8 01 00 00 00       	mov    $0x1,%eax
80106014:	eb 05                	jmp    8010601b <procfsisdir+0x28>
80106016:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010601b:	5d                   	pop    %ebp
8010601c:	c3                   	ret    

8010601d <procfsiread>:

void
procfsiread(struct inode* dp, struct inode *ip) {
8010601d:	55                   	push   %ebp
8010601e:	89 e5                	mov    %esp,%ebp
  ip->type = T_DEV;
80106020:	8b 45 0c             	mov    0xc(%ebp),%eax
80106023:	66 c7 40 10 03 00    	movw   $0x3,0x10(%eax)
  ip->major = PROCFS;
80106029:	8b 45 0c             	mov    0xc(%ebp),%eax
8010602c:	66 c7 40 12 02 00    	movw   $0x2,0x12(%eax)
  ip->size = 0;
80106032:	8b 45 0c             	mov    0xc(%ebp),%eax
80106035:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  ip->nlink = 1;
8010603c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010603f:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  ip->flags = I_VALID;
80106045:	8b 45 0c             	mov    0xc(%ebp),%eax
80106048:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  ip->ref = 1 ;
8010604f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106052:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

  if ( (ip->inum == 19) || (ip->inum%700 == 0) || (ip->inum%700 == 20))
80106059:	8b 45 0c             	mov    0xc(%ebp),%eax
8010605c:	8b 40 04             	mov    0x4(%eax),%eax
8010605f:	83 f8 13             	cmp    $0x13,%eax
80106062:	74 45                	je     801060a9 <procfsiread+0x8c>
80106064:	8b 45 0c             	mov    0xc(%ebp),%eax
80106067:	8b 48 04             	mov    0x4(%eax),%ecx
8010606a:	ba 91 73 9f 5d       	mov    $0x5d9f7391,%edx
8010606f:	89 c8                	mov    %ecx,%eax
80106071:	f7 e2                	mul    %edx
80106073:	89 d0                	mov    %edx,%eax
80106075:	c1 e8 08             	shr    $0x8,%eax
80106078:	69 c0 bc 02 00 00    	imul   $0x2bc,%eax,%eax
8010607e:	29 c1                	sub    %eax,%ecx
80106080:	89 c8                	mov    %ecx,%eax
80106082:	85 c0                	test   %eax,%eax
80106084:	74 23                	je     801060a9 <procfsiread+0x8c>
80106086:	8b 45 0c             	mov    0xc(%ebp),%eax
80106089:	8b 48 04             	mov    0x4(%eax),%ecx
8010608c:	ba 91 73 9f 5d       	mov    $0x5d9f7391,%edx
80106091:	89 c8                	mov    %ecx,%eax
80106093:	f7 e2                	mul    %edx
80106095:	89 d0                	mov    %edx,%eax
80106097:	c1 e8 08             	shr    $0x8,%eax
8010609a:	69 c0 bc 02 00 00    	imul   $0x2bc,%eax,%eax
801060a0:	29 c1                	sub    %eax,%ecx
801060a2:	89 c8                	mov    %ecx,%eax
801060a4:	83 f8 14             	cmp    $0x14,%eax
801060a7:	75 0b                	jne    801060b4 <procfsiread+0x97>
  ip->minor = T_DIR;
801060a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801060ac:	66 c7 40 14 01 00    	movw   $0x1,0x14(%eax)
801060b2:	eb 09                	jmp    801060bd <procfsiread+0xa0>
  else
  ip->minor = T_FILE;
801060b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801060b7:	66 c7 40 14 02 00    	movw   $0x2,0x14(%eax)
}
801060bd:	90                   	nop
801060be:	5d                   	pop    %ebp
801060bf:	c3                   	ret    

801060c0 <procfsread>:

int procfsread(struct inode *ip, char *dst, int off, int n) {
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	81 ec 38 04 00 00    	sub    $0x438,%esp
  int size = 0;
801060c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int nr;

  int command=ip->inum%700;
801060d0:	8b 45 08             	mov    0x8(%ebp),%eax
801060d3:	8b 48 04             	mov    0x4(%eax),%ecx
801060d6:	ba 91 73 9f 5d       	mov    $0x5d9f7391,%edx
801060db:	89 c8                	mov    %ecx,%eax
801060dd:	f7 e2                	mul    %edx
801060df:	89 d0                	mov    %edx,%eax
801060e1:	c1 e8 08             	shr    $0x8,%eax
801060e4:	69 c0 bc 02 00 00    	imul   $0x2bc,%eax,%eax
801060ea:	29 c1                	sub    %eax,%ecx
801060ec:	89 c8                	mov    %ecx,%eax
801060ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  char buf[BUFFSIZE];
  if (command >= 21 && command <= 36)
801060f1:	83 7d ec 14          	cmpl   $0x14,-0x14(%ebp)
801060f5:	7e 0d                	jle    80106104 <procfsread+0x44>
801060f7:	83 7d ec 24          	cmpl   $0x24,-0x14(%ebp)
801060fb:	7f 07                	jg     80106104 <procfsread+0x44>
  command = 21;
801060fd:	c7 45 ec 15 00 00 00 	movl   $0x15,-0x14(%ebp)

  switch(command){
80106104:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106107:	83 f8 14             	cmp    $0x14,%eax
8010610a:	0f 84 a5 00 00 00    	je     801061b5 <procfsread+0xf5>
80106110:	83 f8 14             	cmp    $0x14,%eax
80106113:	7f 13                	jg     80106128 <procfsread+0x68>
80106115:	83 f8 0a             	cmp    $0xa,%eax
80106118:	74 7d                	je     80106197 <procfsread+0xd7>
8010611a:	83 f8 13             	cmp    $0x13,%eax
8010611d:	74 2d                	je     8010614c <procfsread+0x8c>
8010611f:	85 c0                	test   %eax,%eax
80106121:	74 51                	je     80106174 <procfsread+0xb4>
80106123:	e9 f6 00 00 00       	jmp    8010621e <procfsread+0x15e>
80106128:	3d 94 02 00 00       	cmp    $0x294,%eax
8010612d:	0f 84 a0 00 00 00    	je     801061d3 <procfsread+0x113>
80106133:	3d 9e 02 00 00       	cmp    $0x29e,%eax
80106138:	0f 84 ac 00 00 00    	je     801061ea <procfsread+0x12a>
8010613e:	83 f8 15             	cmp    $0x15,%eax
80106141:	0f 84 ba 00 00 00    	je     80106201 <procfsread+0x141>
80106147:	e9 d2 00 00 00       	jmp    8010621e <procfsread+0x15e>
    case 19:
    // proc
    currentInode = ip->inum;
8010614c:	8b 45 08             	mov    0x8(%ebp),%eax
8010614f:	8b 40 04             	mov    0x4(%eax),%eax
80106152:	a3 24 d0 10 80       	mov    %eax,0x8010d024
    size = initProc(buf,ip);
80106157:	83 ec 08             	sub    $0x8,%esp
8010615a:	ff 75 08             	pushl  0x8(%ebp)
8010615d:	8d 85 cc fb ff ff    	lea    -0x434(%ebp),%eax
80106163:	50                   	push   %eax
80106164:	e8 53 f1 ff ff       	call   801052bc <initProc>
80106169:	83 c4 10             	add    $0x10,%esp
8010616c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    break;
8010616f:	e9 aa 00 00 00       	jmp    8010621e <procfsread+0x15e>
    case 0:
    // case /proc/pid
    size = initPID(ip->inum, buf);
80106174:	8b 45 08             	mov    0x8(%ebp),%eax
80106177:	8b 40 04             	mov    0x4(%eax),%eax
8010617a:	89 c2                	mov    %eax,%edx
8010617c:	83 ec 08             	sub    $0x8,%esp
8010617f:	8d 85 cc fb ff ff    	lea    -0x434(%ebp),%eax
80106185:	50                   	push   %eax
80106186:	52                   	push   %edx
80106187:	e8 af f2 ff ff       	call   8010543b <initPID>
8010618c:	83 c4 10             	add    $0x10,%esp
8010618f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    break;
80106192:	e9 87 00 00 00       	jmp    8010621e <procfsread+0x15e>
    case 10:
    size = status(buf,ip->inum);
80106197:	8b 45 08             	mov    0x8(%ebp),%eax
8010619a:	8b 40 04             	mov    0x4(%eax),%eax
8010619d:	83 ec 08             	sub    $0x8,%esp
801061a0:	50                   	push   %eax
801061a1:	8d 85 cc fb ff ff    	lea    -0x434(%ebp),%eax
801061a7:	50                   	push   %eax
801061a8:	e8 ee f3 ff ff       	call   8010559b <status>
801061ad:	83 c4 10             	add    $0x10,%esp
801061b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    break;
801061b3:	eb 69                	jmp    8010621e <procfsread+0x15e>
    case 20:
    size = fdinfo(buf,ip->inum);
801061b5:	8b 45 08             	mov    0x8(%ebp),%eax
801061b8:	8b 40 04             	mov    0x4(%eax),%eax
801061bb:	83 ec 08             	sub    $0x8,%esp
801061be:	50                   	push   %eax
801061bf:	8d 85 cc fb ff ff    	lea    -0x434(%ebp),%eax
801061c5:	50                   	push   %eax
801061c6:	e8 3d f5 ff ff       	call   80105708 <fdinfo>
801061cb:	83 c4 10             	add    $0x10,%esp
801061ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    break;
801061d1:	eb 4b                	jmp    8010621e <procfsread+0x15e>
    case 660:
    size = blockstat(buf);
801061d3:	83 ec 0c             	sub    $0xc,%esp
801061d6:	8d 85 cc fb ff ff    	lea    -0x434(%ebp),%eax
801061dc:	50                   	push   %eax
801061dd:	e8 8d fa ff ff       	call   80105c6f <blockstat>
801061e2:	83 c4 10             	add    $0x10,%esp
801061e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    break;
801061e8:	eb 34                	jmp    8010621e <procfsread+0x15e>
    case 670:
    size =inodestat(buf);
801061ea:	83 ec 0c             	sub    $0xc,%esp
801061ed:	8d 85 cc fb ff ff    	lea    -0x434(%ebp),%eax
801061f3:	50                   	push   %eax
801061f4:	e8 38 fc ff ff       	call   80105e31 <inodestat>
801061f9:	83 c4 10             	add    $0x10,%esp
801061fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    break;
801061ff:	eb 1d                	jmp    8010621e <procfsread+0x15e>
    case 21:
    size= filesContent(buf,ip->inum);
80106201:	8b 45 08             	mov    0x8(%ebp),%eax
80106204:	8b 40 04             	mov    0x4(%eax),%eax
80106207:	83 ec 08             	sub    $0x8,%esp
8010620a:	50                   	push   %eax
8010620b:	8d 85 cc fb ff ff    	lea    -0x434(%ebp),%eax
80106211:	50                   	push   %eax
80106212:	e8 0c f6 ff ff       	call   80105823 <filesContent>
80106217:	83 c4 10             	add    $0x10,%esp
8010621a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    break;
8010621d:	90                   	nop
    //
    // size= cwd(buf,ip->inum,off,n);
    // break;

  }
  if (off < size) {
8010621e:	8b 45 10             	mov    0x10(%ebp),%eax
80106221:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106224:	7d 3a                	jge    80106260 <procfsread+0x1a0>
    nr = size - off;
80106226:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106229:	2b 45 10             	sub    0x10(%ebp),%eax
8010622c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n < nr) {
8010622f:	8b 45 14             	mov    0x14(%ebp),%eax
80106232:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80106235:	7d 06                	jge    8010623d <procfsread+0x17d>
      nr = n;
80106237:	8b 45 14             	mov    0x14(%ebp),%eax
8010623a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    memmove(dst, buf + off, nr);
8010623d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106240:	8b 55 10             	mov    0x10(%ebp),%edx
80106243:	8d 8d cc fb ff ff    	lea    -0x434(%ebp),%ecx
80106249:	01 ca                	add    %ecx,%edx
8010624b:	83 ec 04             	sub    $0x4,%esp
8010624e:	50                   	push   %eax
8010624f:	52                   	push   %edx
80106250:	ff 75 0c             	pushl  0xc(%ebp)
80106253:	e8 c3 03 00 00       	call   8010661b <memmove>
80106258:	83 c4 10             	add    $0x10,%esp
    return nr;
8010625b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010625e:	eb 05                	jmp    80106265 <procfsread+0x1a5>
  }
  return 0;
80106260:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106265:	c9                   	leave  
80106266:	c3                   	ret    

80106267 <procfswrite>:

int
procfswrite(struct inode *ip, char *buf, int n)
{
80106267:	55                   	push   %ebp
80106268:	89 e5                	mov    %esp,%ebp
  return 0;
8010626a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010626f:	5d                   	pop    %ebp
80106270:	c3                   	ret    

80106271 <procfsinit>:

void
procfsinit(void)
{
80106271:	55                   	push   %ebp
80106272:	89 e5                	mov    %esp,%ebp
  devsw[PROCFS].isdir = procfsisdir;
80106274:	c7 05 20 32 11 80 f3 	movl   $0x80105ff3,0x80113220
8010627b:	5f 10 80 
  devsw[PROCFS].iread = procfsiread;
8010627e:	c7 05 24 32 11 80 1d 	movl   $0x8010601d,0x80113224
80106285:	60 10 80 
  devsw[PROCFS].write = procfswrite;
80106288:	c7 05 2c 32 11 80 67 	movl   $0x80106267,0x8011322c
8010628f:	62 10 80 
  devsw[PROCFS].read = procfsread;
80106292:	c7 05 28 32 11 80 c0 	movl   $0x801060c0,0x80113228
80106299:	60 10 80 
}
8010629c:	90                   	nop
8010629d:	5d                   	pop    %ebp
8010629e:	c3                   	ret    

8010629f <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010629f:	55                   	push   %ebp
801062a0:	89 e5                	mov    %esp,%ebp
801062a2:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801062a5:	9c                   	pushf  
801062a6:	58                   	pop    %eax
801062a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801062aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801062ad:	c9                   	leave  
801062ae:	c3                   	ret    

801062af <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801062af:	55                   	push   %ebp
801062b0:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801062b2:	fa                   	cli    
}
801062b3:	90                   	nop
801062b4:	5d                   	pop    %ebp
801062b5:	c3                   	ret    

801062b6 <sti>:

static inline void
sti(void)
{
801062b6:	55                   	push   %ebp
801062b7:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801062b9:	fb                   	sti    
}
801062ba:	90                   	nop
801062bb:	5d                   	pop    %ebp
801062bc:	c3                   	ret    

801062bd <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801062bd:	55                   	push   %ebp
801062be:	89 e5                	mov    %esp,%ebp
801062c0:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801062c3:	8b 55 08             	mov    0x8(%ebp),%edx
801062c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801062c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801062cc:	f0 87 02             	lock xchg %eax,(%edx)
801062cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801062d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801062d5:	c9                   	leave  
801062d6:	c3                   	ret    

801062d7 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801062d7:	55                   	push   %ebp
801062d8:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801062da:	8b 45 08             	mov    0x8(%ebp),%eax
801062dd:	8b 55 0c             	mov    0xc(%ebp),%edx
801062e0:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801062e3:	8b 45 08             	mov    0x8(%ebp),%eax
801062e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801062ec:	8b 45 08             	mov    0x8(%ebp),%eax
801062ef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801062f6:	90                   	nop
801062f7:	5d                   	pop    %ebp
801062f8:	c3                   	ret    

801062f9 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801062f9:	55                   	push   %ebp
801062fa:	89 e5                	mov    %esp,%ebp
801062fc:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801062ff:	e8 52 01 00 00       	call   80106456 <pushcli>
  if(holding(lk))
80106304:	8b 45 08             	mov    0x8(%ebp),%eax
80106307:	83 ec 0c             	sub    $0xc,%esp
8010630a:	50                   	push   %eax
8010630b:	e8 1c 01 00 00       	call   8010642c <holding>
80106310:	83 c4 10             	add    $0x10,%esp
80106313:	85 c0                	test   %eax,%eax
80106315:	74 0d                	je     80106324 <acquire+0x2b>
    panic("acquire");
80106317:	83 ec 0c             	sub    $0xc,%esp
8010631a:	68 96 9f 10 80       	push   $0x80109f96
8010631f:	e8 d3 a2 ff ff       	call   801005f7 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80106324:	90                   	nop
80106325:	8b 45 08             	mov    0x8(%ebp),%eax
80106328:	83 ec 08             	sub    $0x8,%esp
8010632b:	6a 01                	push   $0x1
8010632d:	50                   	push   %eax
8010632e:	e8 8a ff ff ff       	call   801062bd <xchg>
80106333:	83 c4 10             	add    $0x10,%esp
80106336:	85 c0                	test   %eax,%eax
80106338:	75 eb                	jne    80106325 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010633a:	8b 45 08             	mov    0x8(%ebp),%eax
8010633d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106344:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80106347:	8b 45 08             	mov    0x8(%ebp),%eax
8010634a:	83 c0 0c             	add    $0xc,%eax
8010634d:	83 ec 08             	sub    $0x8,%esp
80106350:	50                   	push   %eax
80106351:	8d 45 08             	lea    0x8(%ebp),%eax
80106354:	50                   	push   %eax
80106355:	e8 58 00 00 00       	call   801063b2 <getcallerpcs>
8010635a:	83 c4 10             	add    $0x10,%esp
}
8010635d:	90                   	nop
8010635e:	c9                   	leave  
8010635f:	c3                   	ret    

80106360 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80106360:	55                   	push   %ebp
80106361:	89 e5                	mov    %esp,%ebp
80106363:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80106366:	83 ec 0c             	sub    $0xc,%esp
80106369:	ff 75 08             	pushl  0x8(%ebp)
8010636c:	e8 bb 00 00 00       	call   8010642c <holding>
80106371:	83 c4 10             	add    $0x10,%esp
80106374:	85 c0                	test   %eax,%eax
80106376:	75 0d                	jne    80106385 <release+0x25>
    panic("release");
80106378:	83 ec 0c             	sub    $0xc,%esp
8010637b:	68 9e 9f 10 80       	push   $0x80109f9e
80106380:	e8 72 a2 ff ff       	call   801005f7 <panic>

  lk->pcs[0] = 0;
80106385:	8b 45 08             	mov    0x8(%ebp),%eax
80106388:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010638f:	8b 45 08             	mov    0x8(%ebp),%eax
80106392:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80106399:	8b 45 08             	mov    0x8(%ebp),%eax
8010639c:	83 ec 08             	sub    $0x8,%esp
8010639f:	6a 00                	push   $0x0
801063a1:	50                   	push   %eax
801063a2:	e8 16 ff ff ff       	call   801062bd <xchg>
801063a7:	83 c4 10             	add    $0x10,%esp

  popcli();
801063aa:	e8 ec 00 00 00       	call   8010649b <popcli>
}
801063af:	90                   	nop
801063b0:	c9                   	leave  
801063b1:	c3                   	ret    

801063b2 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801063b2:	55                   	push   %ebp
801063b3:	89 e5                	mov    %esp,%ebp
801063b5:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801063b8:	8b 45 08             	mov    0x8(%ebp),%eax
801063bb:	83 e8 08             	sub    $0x8,%eax
801063be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801063c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801063c8:	eb 38                	jmp    80106402 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801063ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801063ce:	74 53                	je     80106423 <getcallerpcs+0x71>
801063d0:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801063d7:	76 4a                	jbe    80106423 <getcallerpcs+0x71>
801063d9:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801063dd:	74 44                	je     80106423 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
801063df:	8b 45 f8             	mov    -0x8(%ebp),%eax
801063e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801063e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801063ec:	01 c2                	add    %eax,%edx
801063ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
801063f1:	8b 40 04             	mov    0x4(%eax),%eax
801063f4:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801063f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801063f9:	8b 00                	mov    (%eax),%eax
801063fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801063fe:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106402:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80106406:	7e c2                	jle    801063ca <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106408:	eb 19                	jmp    80106423 <getcallerpcs+0x71>
    pcs[i] = 0;
8010640a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010640d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106414:	8b 45 0c             	mov    0xc(%ebp),%eax
80106417:	01 d0                	add    %edx,%eax
80106419:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010641f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106423:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80106427:	7e e1                	jle    8010640a <getcallerpcs+0x58>
    pcs[i] = 0;
}
80106429:	90                   	nop
8010642a:	c9                   	leave  
8010642b:	c3                   	ret    

8010642c <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010642c:	55                   	push   %ebp
8010642d:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
8010642f:	8b 45 08             	mov    0x8(%ebp),%eax
80106432:	8b 00                	mov    (%eax),%eax
80106434:	85 c0                	test   %eax,%eax
80106436:	74 17                	je     8010644f <holding+0x23>
80106438:	8b 45 08             	mov    0x8(%ebp),%eax
8010643b:	8b 50 08             	mov    0x8(%eax),%edx
8010643e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106444:	39 c2                	cmp    %eax,%edx
80106446:	75 07                	jne    8010644f <holding+0x23>
80106448:	b8 01 00 00 00       	mov    $0x1,%eax
8010644d:	eb 05                	jmp    80106454 <holding+0x28>
8010644f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106454:	5d                   	pop    %ebp
80106455:	c3                   	ret    

80106456 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80106456:	55                   	push   %ebp
80106457:	89 e5                	mov    %esp,%ebp
80106459:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
8010645c:	e8 3e fe ff ff       	call   8010629f <readeflags>
80106461:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80106464:	e8 46 fe ff ff       	call   801062af <cli>
  if(cpu->ncli++ == 0)
80106469:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106470:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80106476:	8d 48 01             	lea    0x1(%eax),%ecx
80106479:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
8010647f:	85 c0                	test   %eax,%eax
80106481:	75 15                	jne    80106498 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80106483:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106489:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010648c:	81 e2 00 02 00 00    	and    $0x200,%edx
80106492:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80106498:	90                   	nop
80106499:	c9                   	leave  
8010649a:	c3                   	ret    

8010649b <popcli>:

void
popcli(void)
{
8010649b:	55                   	push   %ebp
8010649c:	89 e5                	mov    %esp,%ebp
8010649e:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801064a1:	e8 f9 fd ff ff       	call   8010629f <readeflags>
801064a6:	25 00 02 00 00       	and    $0x200,%eax
801064ab:	85 c0                	test   %eax,%eax
801064ad:	74 0d                	je     801064bc <popcli+0x21>
    panic("popcli - interruptible");
801064af:	83 ec 0c             	sub    $0xc,%esp
801064b2:	68 a6 9f 10 80       	push   $0x80109fa6
801064b7:	e8 3b a1 ff ff       	call   801005f7 <panic>
  if(--cpu->ncli < 0)
801064bc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801064c2:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801064c8:	83 ea 01             	sub    $0x1,%edx
801064cb:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801064d1:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801064d7:	85 c0                	test   %eax,%eax
801064d9:	79 0d                	jns    801064e8 <popcli+0x4d>
    panic("popcli");
801064db:	83 ec 0c             	sub    $0xc,%esp
801064de:	68 bd 9f 10 80       	push   $0x80109fbd
801064e3:	e8 0f a1 ff ff       	call   801005f7 <panic>
  if(cpu->ncli == 0 && cpu->intena)
801064e8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801064ee:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801064f4:	85 c0                	test   %eax,%eax
801064f6:	75 15                	jne    8010650d <popcli+0x72>
801064f8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801064fe:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80106504:	85 c0                	test   %eax,%eax
80106506:	74 05                	je     8010650d <popcli+0x72>
    sti();
80106508:	e8 a9 fd ff ff       	call   801062b6 <sti>
}
8010650d:	90                   	nop
8010650e:	c9                   	leave  
8010650f:	c3                   	ret    

80106510 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80106510:	55                   	push   %ebp
80106511:	89 e5                	mov    %esp,%ebp
80106513:	57                   	push   %edi
80106514:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80106515:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106518:	8b 55 10             	mov    0x10(%ebp),%edx
8010651b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010651e:	89 cb                	mov    %ecx,%ebx
80106520:	89 df                	mov    %ebx,%edi
80106522:	89 d1                	mov    %edx,%ecx
80106524:	fc                   	cld    
80106525:	f3 aa                	rep stos %al,%es:(%edi)
80106527:	89 ca                	mov    %ecx,%edx
80106529:	89 fb                	mov    %edi,%ebx
8010652b:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010652e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106531:	90                   	nop
80106532:	5b                   	pop    %ebx
80106533:	5f                   	pop    %edi
80106534:	5d                   	pop    %ebp
80106535:	c3                   	ret    

80106536 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80106536:	55                   	push   %ebp
80106537:	89 e5                	mov    %esp,%ebp
80106539:	57                   	push   %edi
8010653a:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
8010653b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010653e:	8b 55 10             	mov    0x10(%ebp),%edx
80106541:	8b 45 0c             	mov    0xc(%ebp),%eax
80106544:	89 cb                	mov    %ecx,%ebx
80106546:	89 df                	mov    %ebx,%edi
80106548:	89 d1                	mov    %edx,%ecx
8010654a:	fc                   	cld    
8010654b:	f3 ab                	rep stos %eax,%es:(%edi)
8010654d:	89 ca                	mov    %ecx,%edx
8010654f:	89 fb                	mov    %edi,%ebx
80106551:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106554:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106557:	90                   	nop
80106558:	5b                   	pop    %ebx
80106559:	5f                   	pop    %edi
8010655a:	5d                   	pop    %ebp
8010655b:	c3                   	ret    

8010655c <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010655c:	55                   	push   %ebp
8010655d:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
8010655f:	8b 45 08             	mov    0x8(%ebp),%eax
80106562:	83 e0 03             	and    $0x3,%eax
80106565:	85 c0                	test   %eax,%eax
80106567:	75 43                	jne    801065ac <memset+0x50>
80106569:	8b 45 10             	mov    0x10(%ebp),%eax
8010656c:	83 e0 03             	and    $0x3,%eax
8010656f:	85 c0                	test   %eax,%eax
80106571:	75 39                	jne    801065ac <memset+0x50>
    c &= 0xFF;
80106573:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010657a:	8b 45 10             	mov    0x10(%ebp),%eax
8010657d:	c1 e8 02             	shr    $0x2,%eax
80106580:	89 c1                	mov    %eax,%ecx
80106582:	8b 45 0c             	mov    0xc(%ebp),%eax
80106585:	c1 e0 18             	shl    $0x18,%eax
80106588:	89 c2                	mov    %eax,%edx
8010658a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010658d:	c1 e0 10             	shl    $0x10,%eax
80106590:	09 c2                	or     %eax,%edx
80106592:	8b 45 0c             	mov    0xc(%ebp),%eax
80106595:	c1 e0 08             	shl    $0x8,%eax
80106598:	09 d0                	or     %edx,%eax
8010659a:	0b 45 0c             	or     0xc(%ebp),%eax
8010659d:	51                   	push   %ecx
8010659e:	50                   	push   %eax
8010659f:	ff 75 08             	pushl  0x8(%ebp)
801065a2:	e8 8f ff ff ff       	call   80106536 <stosl>
801065a7:	83 c4 0c             	add    $0xc,%esp
801065aa:	eb 12                	jmp    801065be <memset+0x62>
  } else
    stosb(dst, c, n);
801065ac:	8b 45 10             	mov    0x10(%ebp),%eax
801065af:	50                   	push   %eax
801065b0:	ff 75 0c             	pushl  0xc(%ebp)
801065b3:	ff 75 08             	pushl  0x8(%ebp)
801065b6:	e8 55 ff ff ff       	call   80106510 <stosb>
801065bb:	83 c4 0c             	add    $0xc,%esp
  return dst;
801065be:	8b 45 08             	mov    0x8(%ebp),%eax
}
801065c1:	c9                   	leave  
801065c2:	c3                   	ret    

801065c3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801065c3:	55                   	push   %ebp
801065c4:	89 e5                	mov    %esp,%ebp
801065c6:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801065c9:	8b 45 08             	mov    0x8(%ebp),%eax
801065cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801065cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801065d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801065d5:	eb 30                	jmp    80106607 <memcmp+0x44>
    if(*s1 != *s2)
801065d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801065da:	0f b6 10             	movzbl (%eax),%edx
801065dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
801065e0:	0f b6 00             	movzbl (%eax),%eax
801065e3:	38 c2                	cmp    %al,%dl
801065e5:	74 18                	je     801065ff <memcmp+0x3c>
      return *s1 - *s2;
801065e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801065ea:	0f b6 00             	movzbl (%eax),%eax
801065ed:	0f b6 d0             	movzbl %al,%edx
801065f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
801065f3:	0f b6 00             	movzbl (%eax),%eax
801065f6:	0f b6 c0             	movzbl %al,%eax
801065f9:	29 c2                	sub    %eax,%edx
801065fb:	89 d0                	mov    %edx,%eax
801065fd:	eb 1a                	jmp    80106619 <memcmp+0x56>
    s1++, s2++;
801065ff:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106603:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80106607:	8b 45 10             	mov    0x10(%ebp),%eax
8010660a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010660d:	89 55 10             	mov    %edx,0x10(%ebp)
80106610:	85 c0                	test   %eax,%eax
80106612:	75 c3                	jne    801065d7 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80106614:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106619:	c9                   	leave  
8010661a:	c3                   	ret    

8010661b <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
8010661b:	55                   	push   %ebp
8010661c:	89 e5                	mov    %esp,%ebp
8010661e:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80106621:	8b 45 0c             	mov    0xc(%ebp),%eax
80106624:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80106627:	8b 45 08             	mov    0x8(%ebp),%eax
8010662a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
8010662d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106630:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106633:	73 54                	jae    80106689 <memmove+0x6e>
80106635:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106638:	8b 45 10             	mov    0x10(%ebp),%eax
8010663b:	01 d0                	add    %edx,%eax
8010663d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106640:	76 47                	jbe    80106689 <memmove+0x6e>
    s += n;
80106642:	8b 45 10             	mov    0x10(%ebp),%eax
80106645:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80106648:	8b 45 10             	mov    0x10(%ebp),%eax
8010664b:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010664e:	eb 13                	jmp    80106663 <memmove+0x48>
      *--d = *--s;
80106650:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80106654:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80106658:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010665b:	0f b6 10             	movzbl (%eax),%edx
8010665e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106661:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80106663:	8b 45 10             	mov    0x10(%ebp),%eax
80106666:	8d 50 ff             	lea    -0x1(%eax),%edx
80106669:	89 55 10             	mov    %edx,0x10(%ebp)
8010666c:	85 c0                	test   %eax,%eax
8010666e:	75 e0                	jne    80106650 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80106670:	eb 24                	jmp    80106696 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80106672:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106675:	8d 50 01             	lea    0x1(%eax),%edx
80106678:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010667b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010667e:	8d 4a 01             	lea    0x1(%edx),%ecx
80106681:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80106684:	0f b6 12             	movzbl (%edx),%edx
80106687:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80106689:	8b 45 10             	mov    0x10(%ebp),%eax
8010668c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010668f:	89 55 10             	mov    %edx,0x10(%ebp)
80106692:	85 c0                	test   %eax,%eax
80106694:	75 dc                	jne    80106672 <memmove+0x57>
      *d++ = *s++;

  return dst;
80106696:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106699:	c9                   	leave  
8010669a:	c3                   	ret    

8010669b <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010669b:	55                   	push   %ebp
8010669c:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
8010669e:	ff 75 10             	pushl  0x10(%ebp)
801066a1:	ff 75 0c             	pushl  0xc(%ebp)
801066a4:	ff 75 08             	pushl  0x8(%ebp)
801066a7:	e8 6f ff ff ff       	call   8010661b <memmove>
801066ac:	83 c4 0c             	add    $0xc,%esp
}
801066af:	c9                   	leave  
801066b0:	c3                   	ret    

801066b1 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801066b1:	55                   	push   %ebp
801066b2:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801066b4:	eb 0c                	jmp    801066c2 <strncmp+0x11>
    n--, p++, q++;
801066b6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801066ba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801066be:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801066c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801066c6:	74 1a                	je     801066e2 <strncmp+0x31>
801066c8:	8b 45 08             	mov    0x8(%ebp),%eax
801066cb:	0f b6 00             	movzbl (%eax),%eax
801066ce:	84 c0                	test   %al,%al
801066d0:	74 10                	je     801066e2 <strncmp+0x31>
801066d2:	8b 45 08             	mov    0x8(%ebp),%eax
801066d5:	0f b6 10             	movzbl (%eax),%edx
801066d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801066db:	0f b6 00             	movzbl (%eax),%eax
801066de:	38 c2                	cmp    %al,%dl
801066e0:	74 d4                	je     801066b6 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801066e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801066e6:	75 07                	jne    801066ef <strncmp+0x3e>
    return 0;
801066e8:	b8 00 00 00 00       	mov    $0x0,%eax
801066ed:	eb 16                	jmp    80106705 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801066ef:	8b 45 08             	mov    0x8(%ebp),%eax
801066f2:	0f b6 00             	movzbl (%eax),%eax
801066f5:	0f b6 d0             	movzbl %al,%edx
801066f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801066fb:	0f b6 00             	movzbl (%eax),%eax
801066fe:	0f b6 c0             	movzbl %al,%eax
80106701:	29 c2                	sub    %eax,%edx
80106703:	89 d0                	mov    %edx,%eax
}
80106705:	5d                   	pop    %ebp
80106706:	c3                   	ret    

80106707 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106707:	55                   	push   %ebp
80106708:	89 e5                	mov    %esp,%ebp
8010670a:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010670d:	8b 45 08             	mov    0x8(%ebp),%eax
80106710:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80106713:	90                   	nop
80106714:	8b 45 10             	mov    0x10(%ebp),%eax
80106717:	8d 50 ff             	lea    -0x1(%eax),%edx
8010671a:	89 55 10             	mov    %edx,0x10(%ebp)
8010671d:	85 c0                	test   %eax,%eax
8010671f:	7e 2c                	jle    8010674d <strncpy+0x46>
80106721:	8b 45 08             	mov    0x8(%ebp),%eax
80106724:	8d 50 01             	lea    0x1(%eax),%edx
80106727:	89 55 08             	mov    %edx,0x8(%ebp)
8010672a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010672d:	8d 4a 01             	lea    0x1(%edx),%ecx
80106730:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106733:	0f b6 12             	movzbl (%edx),%edx
80106736:	88 10                	mov    %dl,(%eax)
80106738:	0f b6 00             	movzbl (%eax),%eax
8010673b:	84 c0                	test   %al,%al
8010673d:	75 d5                	jne    80106714 <strncpy+0xd>
    ;
  while(n-- > 0)
8010673f:	eb 0c                	jmp    8010674d <strncpy+0x46>
    *s++ = 0;
80106741:	8b 45 08             	mov    0x8(%ebp),%eax
80106744:	8d 50 01             	lea    0x1(%eax),%edx
80106747:	89 55 08             	mov    %edx,0x8(%ebp)
8010674a:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010674d:	8b 45 10             	mov    0x10(%ebp),%eax
80106750:	8d 50 ff             	lea    -0x1(%eax),%edx
80106753:	89 55 10             	mov    %edx,0x10(%ebp)
80106756:	85 c0                	test   %eax,%eax
80106758:	7f e7                	jg     80106741 <strncpy+0x3a>
    *s++ = 0;
  return os;
8010675a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010675d:	c9                   	leave  
8010675e:	c3                   	ret    

8010675f <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010675f:	55                   	push   %ebp
80106760:	89 e5                	mov    %esp,%ebp
80106762:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106765:	8b 45 08             	mov    0x8(%ebp),%eax
80106768:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
8010676b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010676f:	7f 05                	jg     80106776 <safestrcpy+0x17>
    return os;
80106771:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106774:	eb 31                	jmp    801067a7 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80106776:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010677a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010677e:	7e 1e                	jle    8010679e <safestrcpy+0x3f>
80106780:	8b 45 08             	mov    0x8(%ebp),%eax
80106783:	8d 50 01             	lea    0x1(%eax),%edx
80106786:	89 55 08             	mov    %edx,0x8(%ebp)
80106789:	8b 55 0c             	mov    0xc(%ebp),%edx
8010678c:	8d 4a 01             	lea    0x1(%edx),%ecx
8010678f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106792:	0f b6 12             	movzbl (%edx),%edx
80106795:	88 10                	mov    %dl,(%eax)
80106797:	0f b6 00             	movzbl (%eax),%eax
8010679a:	84 c0                	test   %al,%al
8010679c:	75 d8                	jne    80106776 <safestrcpy+0x17>
    ;
  *s = 0;
8010679e:	8b 45 08             	mov    0x8(%ebp),%eax
801067a1:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801067a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801067a7:	c9                   	leave  
801067a8:	c3                   	ret    

801067a9 <strlen>:

int
strlen(const char *s)
{
801067a9:	55                   	push   %ebp
801067aa:	89 e5                	mov    %esp,%ebp
801067ac:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801067af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801067b6:	eb 04                	jmp    801067bc <strlen+0x13>
801067b8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801067bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
801067bf:	8b 45 08             	mov    0x8(%ebp),%eax
801067c2:	01 d0                	add    %edx,%eax
801067c4:	0f b6 00             	movzbl (%eax),%eax
801067c7:	84 c0                	test   %al,%al
801067c9:	75 ed                	jne    801067b8 <strlen+0xf>
    ;
  return n;
801067cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801067ce:	c9                   	leave  
801067cf:	c3                   	ret    

801067d0 <itoa>:

void itoa(int x, char *buf) {
801067d0:	55                   	push   %ebp
801067d1:	89 e5                	mov    %esp,%ebp
801067d3:	53                   	push   %ebx
801067d4:	83 ec 10             	sub    $0x10,%esp
  static char digits[] = "0123456789";
  int i = 0;
801067d7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  char tmp;

  do{
    buf[i++] = digits[x % 10];
801067de:	8b 45 f8             	mov    -0x8(%ebp),%eax
801067e1:	8d 50 01             	lea    0x1(%eax),%edx
801067e4:	89 55 f8             	mov    %edx,-0x8(%ebp)
801067e7:	89 c2                	mov    %eax,%edx
801067e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801067ec:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801067ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
801067f2:	ba 67 66 66 66       	mov    $0x66666667,%edx
801067f7:	89 c8                	mov    %ecx,%eax
801067f9:	f7 ea                	imul   %edx
801067fb:	c1 fa 02             	sar    $0x2,%edx
801067fe:	89 c8                	mov    %ecx,%eax
80106800:	c1 f8 1f             	sar    $0x1f,%eax
80106803:	29 c2                	sub    %eax,%edx
80106805:	89 d0                	mov    %edx,%eax
80106807:	c1 e0 02             	shl    $0x2,%eax
8010680a:	01 d0                	add    %edx,%eax
8010680c:	01 c0                	add    %eax,%eax
8010680e:	29 c1                	sub    %eax,%ecx
80106810:	89 ca                	mov    %ecx,%edx
80106812:	0f b6 82 28 d0 10 80 	movzbl -0x7fef2fd8(%edx),%eax
80106819:	88 03                	mov    %al,(%ebx)
  }while((x /= 10) != 0);
8010681b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010681e:	ba 67 66 66 66       	mov    $0x66666667,%edx
80106823:	89 c8                	mov    %ecx,%eax
80106825:	f7 ea                	imul   %edx
80106827:	c1 fa 02             	sar    $0x2,%edx
8010682a:	89 c8                	mov    %ecx,%eax
8010682c:	c1 f8 1f             	sar    $0x1f,%eax
8010682f:	29 c2                	sub    %eax,%edx
80106831:	89 d0                	mov    %edx,%eax
80106833:	89 45 08             	mov    %eax,0x8(%ebp)
80106836:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010683a:	75 a2                	jne    801067de <itoa+0xe>
  buf[i] = '\0';
8010683c:	8b 55 f8             	mov    -0x8(%ebp),%edx
8010683f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106842:	01 d0                	add    %edx,%eax
80106844:	c6 00 00             	movb   $0x0,(%eax)

  for (i = 0; i < strlen(buf) / 2; i++) {
80106847:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010684e:	eb 52                	jmp    801068a2 <itoa+0xd2>
    tmp = buf[i];
80106850:	8b 55 f8             	mov    -0x8(%ebp),%edx
80106853:	8b 45 0c             	mov    0xc(%ebp),%eax
80106856:	01 d0                	add    %edx,%eax
80106858:	0f b6 00             	movzbl (%eax),%eax
8010685b:	88 45 f7             	mov    %al,-0x9(%ebp)
    buf[i] = buf[strlen(buf) - i - 1];
8010685e:	8b 55 f8             	mov    -0x8(%ebp),%edx
80106861:	8b 45 0c             	mov    0xc(%ebp),%eax
80106864:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80106867:	ff 75 0c             	pushl  0xc(%ebp)
8010686a:	e8 3a ff ff ff       	call   801067a9 <strlen>
8010686f:	83 c4 04             	add    $0x4,%esp
80106872:	2b 45 f8             	sub    -0x8(%ebp),%eax
80106875:	8d 50 ff             	lea    -0x1(%eax),%edx
80106878:	8b 45 0c             	mov    0xc(%ebp),%eax
8010687b:	01 d0                	add    %edx,%eax
8010687d:	0f b6 00             	movzbl (%eax),%eax
80106880:	88 03                	mov    %al,(%ebx)
    buf[strlen(buf) - i - 1] = tmp;
80106882:	ff 75 0c             	pushl  0xc(%ebp)
80106885:	e8 1f ff ff ff       	call   801067a9 <strlen>
8010688a:	83 c4 04             	add    $0x4,%esp
8010688d:	2b 45 f8             	sub    -0x8(%ebp),%eax
80106890:	8d 50 ff             	lea    -0x1(%eax),%edx
80106893:	8b 45 0c             	mov    0xc(%ebp),%eax
80106896:	01 c2                	add    %eax,%edx
80106898:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
8010689c:	88 02                	mov    %al,(%edx)
  do{
    buf[i++] = digits[x % 10];
  }while((x /= 10) != 0);
  buf[i] = '\0';

  for (i = 0; i < strlen(buf) / 2; i++) {
8010689e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801068a2:	ff 75 0c             	pushl  0xc(%ebp)
801068a5:	e8 ff fe ff ff       	call   801067a9 <strlen>
801068aa:	83 c4 04             	add    $0x4,%esp
801068ad:	89 c2                	mov    %eax,%edx
801068af:	c1 ea 1f             	shr    $0x1f,%edx
801068b2:	01 d0                	add    %edx,%eax
801068b4:	d1 f8                	sar    %eax
801068b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801068b9:	7f 95                	jg     80106850 <itoa+0x80>
    tmp = buf[i];
    buf[i] = buf[strlen(buf) - i - 1];
    buf[strlen(buf) - i - 1] = tmp;
  }
801068bb:	90                   	nop
801068bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801068bf:	c9                   	leave  
801068c0:	c3                   	ret    

801068c1 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801068c1:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801068c5:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801068c9:	55                   	push   %ebp
  pushl %ebx
801068ca:	53                   	push   %ebx
  pushl %esi
801068cb:	56                   	push   %esi
  pushl %edi
801068cc:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801068cd:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801068cf:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801068d1:	5f                   	pop    %edi
  popl %esi
801068d2:	5e                   	pop    %esi
  popl %ebx
801068d3:	5b                   	pop    %ebx
  popl %ebp
801068d4:	5d                   	pop    %ebp
  ret
801068d5:	c3                   	ret    

801068d6 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801068d6:	55                   	push   %ebp
801068d7:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801068d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068df:	8b 00                	mov    (%eax),%eax
801068e1:	3b 45 08             	cmp    0x8(%ebp),%eax
801068e4:	76 12                	jbe    801068f8 <fetchint+0x22>
801068e6:	8b 45 08             	mov    0x8(%ebp),%eax
801068e9:	8d 50 04             	lea    0x4(%eax),%edx
801068ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068f2:	8b 00                	mov    (%eax),%eax
801068f4:	39 c2                	cmp    %eax,%edx
801068f6:	76 07                	jbe    801068ff <fetchint+0x29>
    return -1;
801068f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068fd:	eb 0f                	jmp    8010690e <fetchint+0x38>
  *ip = *(int*)(addr);
801068ff:	8b 45 08             	mov    0x8(%ebp),%eax
80106902:	8b 10                	mov    (%eax),%edx
80106904:	8b 45 0c             	mov    0xc(%ebp),%eax
80106907:	89 10                	mov    %edx,(%eax)
  return 0;
80106909:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010690e:	5d                   	pop    %ebp
8010690f:	c3                   	ret    

80106910 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80106916:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010691c:	8b 00                	mov    (%eax),%eax
8010691e:	3b 45 08             	cmp    0x8(%ebp),%eax
80106921:	77 07                	ja     8010692a <fetchstr+0x1a>
    return -1;
80106923:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106928:	eb 46                	jmp    80106970 <fetchstr+0x60>
  *pp = (char*)addr;
8010692a:	8b 55 08             	mov    0x8(%ebp),%edx
8010692d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106930:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80106932:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106938:	8b 00                	mov    (%eax),%eax
8010693a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
8010693d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106940:	8b 00                	mov    (%eax),%eax
80106942:	89 45 fc             	mov    %eax,-0x4(%ebp)
80106945:	eb 1c                	jmp    80106963 <fetchstr+0x53>
    if(*s == 0)
80106947:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010694a:	0f b6 00             	movzbl (%eax),%eax
8010694d:	84 c0                	test   %al,%al
8010694f:	75 0e                	jne    8010695f <fetchstr+0x4f>
      return s - *pp;
80106951:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106954:	8b 45 0c             	mov    0xc(%ebp),%eax
80106957:	8b 00                	mov    (%eax),%eax
80106959:	29 c2                	sub    %eax,%edx
8010695b:	89 d0                	mov    %edx,%eax
8010695d:	eb 11                	jmp    80106970 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
8010695f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106963:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106966:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106969:	72 dc                	jb     80106947 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
8010696b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106970:	c9                   	leave  
80106971:	c3                   	ret    

80106972 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106972:	55                   	push   %ebp
80106973:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80106975:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010697b:	8b 40 18             	mov    0x18(%eax),%eax
8010697e:	8b 40 44             	mov    0x44(%eax),%eax
80106981:	8b 55 08             	mov    0x8(%ebp),%edx
80106984:	c1 e2 02             	shl    $0x2,%edx
80106987:	01 d0                	add    %edx,%eax
80106989:	83 c0 04             	add    $0x4,%eax
8010698c:	ff 75 0c             	pushl  0xc(%ebp)
8010698f:	50                   	push   %eax
80106990:	e8 41 ff ff ff       	call   801068d6 <fetchint>
80106995:	83 c4 08             	add    $0x8,%esp
}
80106998:	c9                   	leave  
80106999:	c3                   	ret    

8010699a <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010699a:	55                   	push   %ebp
8010699b:	89 e5                	mov    %esp,%ebp
8010699d:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
801069a0:	8d 45 fc             	lea    -0x4(%ebp),%eax
801069a3:	50                   	push   %eax
801069a4:	ff 75 08             	pushl  0x8(%ebp)
801069a7:	e8 c6 ff ff ff       	call   80106972 <argint>
801069ac:	83 c4 08             	add    $0x8,%esp
801069af:	85 c0                	test   %eax,%eax
801069b1:	79 07                	jns    801069ba <argptr+0x20>
    return -1;
801069b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069b8:	eb 3b                	jmp    801069f5 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801069ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069c0:	8b 00                	mov    (%eax),%eax
801069c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801069c5:	39 d0                	cmp    %edx,%eax
801069c7:	76 16                	jbe    801069df <argptr+0x45>
801069c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801069cc:	89 c2                	mov    %eax,%edx
801069ce:	8b 45 10             	mov    0x10(%ebp),%eax
801069d1:	01 c2                	add    %eax,%edx
801069d3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069d9:	8b 00                	mov    (%eax),%eax
801069db:	39 c2                	cmp    %eax,%edx
801069dd:	76 07                	jbe    801069e6 <argptr+0x4c>
    return -1;
801069df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069e4:	eb 0f                	jmp    801069f5 <argptr+0x5b>
  *pp = (char*)i;
801069e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801069e9:	89 c2                	mov    %eax,%edx
801069eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801069ee:	89 10                	mov    %edx,(%eax)
  return 0;
801069f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069f5:	c9                   	leave  
801069f6:	c3                   	ret    

801069f7 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801069f7:	55                   	push   %ebp
801069f8:	89 e5                	mov    %esp,%ebp
801069fa:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
801069fd:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106a00:	50                   	push   %eax
80106a01:	ff 75 08             	pushl  0x8(%ebp)
80106a04:	e8 69 ff ff ff       	call   80106972 <argint>
80106a09:	83 c4 08             	add    $0x8,%esp
80106a0c:	85 c0                	test   %eax,%eax
80106a0e:	79 07                	jns    80106a17 <argstr+0x20>
    return -1;
80106a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a15:	eb 0f                	jmp    80106a26 <argstr+0x2f>
  return fetchstr(addr, pp);
80106a17:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106a1a:	ff 75 0c             	pushl  0xc(%ebp)
80106a1d:	50                   	push   %eax
80106a1e:	e8 ed fe ff ff       	call   80106910 <fetchstr>
80106a23:	83 c4 08             	add    $0x8,%esp
}
80106a26:	c9                   	leave  
80106a27:	c3                   	ret    

80106a28 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80106a28:	55                   	push   %ebp
80106a29:	89 e5                	mov    %esp,%ebp
80106a2b:	53                   	push   %ebx
80106a2c:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80106a2f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a35:	8b 40 18             	mov    0x18(%eax),%eax
80106a38:	8b 40 1c             	mov    0x1c(%eax),%eax
80106a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106a3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a42:	7e 30                	jle    80106a74 <syscall+0x4c>
80106a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a47:	83 f8 15             	cmp    $0x15,%eax
80106a4a:	77 28                	ja     80106a74 <syscall+0x4c>
80106a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a4f:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106a56:	85 c0                	test   %eax,%eax
80106a58:	74 1a                	je     80106a74 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80106a5a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a60:	8b 58 18             	mov    0x18(%eax),%ebx
80106a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a66:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106a6d:	ff d0                	call   *%eax
80106a6f:	89 43 1c             	mov    %eax,0x1c(%ebx)
80106a72:	eb 34                	jmp    80106aa8 <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80106a74:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a7a:	8d 50 6c             	lea    0x6c(%eax),%edx
80106a7d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80106a83:	8b 40 10             	mov    0x10(%eax),%eax
80106a86:	ff 75 f4             	pushl  -0xc(%ebp)
80106a89:	52                   	push   %edx
80106a8a:	50                   	push   %eax
80106a8b:	68 c4 9f 10 80       	push   $0x80109fc4
80106a90:	e8 c2 99 ff ff       	call   80100457 <cprintf>
80106a95:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80106a98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a9e:	8b 40 18             	mov    0x18(%eax),%eax
80106aa1:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80106aa8:	90                   	nop
80106aa9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106aac:	c9                   	leave  
80106aad:	c3                   	ret    

80106aae <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80106aae:	55                   	push   %ebp
80106aaf:	89 e5                	mov    %esp,%ebp
80106ab1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80106ab4:	83 ec 08             	sub    $0x8,%esp
80106ab7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106aba:	50                   	push   %eax
80106abb:	ff 75 08             	pushl  0x8(%ebp)
80106abe:	e8 af fe ff ff       	call   80106972 <argint>
80106ac3:	83 c4 10             	add    $0x10,%esp
80106ac6:	85 c0                	test   %eax,%eax
80106ac8:	79 07                	jns    80106ad1 <argfd+0x23>
    return -1;
80106aca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106acf:	eb 50                	jmp    80106b21 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80106ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ad4:	85 c0                	test   %eax,%eax
80106ad6:	78 21                	js     80106af9 <argfd+0x4b>
80106ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106adb:	83 f8 0f             	cmp    $0xf,%eax
80106ade:	7f 19                	jg     80106af9 <argfd+0x4b>
80106ae0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ae6:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106ae9:	83 c2 08             	add    $0x8,%edx
80106aec:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106af3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106af7:	75 07                	jne    80106b00 <argfd+0x52>
    return -1;
80106af9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106afe:	eb 21                	jmp    80106b21 <argfd+0x73>
  if(pfd)
80106b00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106b04:	74 08                	je     80106b0e <argfd+0x60>
    *pfd = fd;
80106b06:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106b09:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b0c:	89 10                	mov    %edx,(%eax)
  if(pf)
80106b0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106b12:	74 08                	je     80106b1c <argfd+0x6e>
    *pf = f;
80106b14:	8b 45 10             	mov    0x10(%ebp),%eax
80106b17:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b1a:	89 10                	mov    %edx,(%eax)
  return 0;
80106b1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b21:	c9                   	leave  
80106b22:	c3                   	ret    

80106b23 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80106b23:	55                   	push   %ebp
80106b24:	89 e5                	mov    %esp,%ebp
80106b26:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106b29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106b30:	eb 30                	jmp    80106b62 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80106b32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b38:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106b3b:	83 c2 08             	add    $0x8,%edx
80106b3e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106b42:	85 c0                	test   %eax,%eax
80106b44:	75 18                	jne    80106b5e <fdalloc+0x3b>
      proc->ofile[fd] = f;
80106b46:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b4c:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106b4f:	8d 4a 08             	lea    0x8(%edx),%ecx
80106b52:	8b 55 08             	mov    0x8(%ebp),%edx
80106b55:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80106b59:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106b5c:	eb 0f                	jmp    80106b6d <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106b5e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106b62:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80106b66:	7e ca                	jle    80106b32 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80106b68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b6d:	c9                   	leave  
80106b6e:	c3                   	ret    

80106b6f <sys_dup>:

int
sys_dup(void)
{
80106b6f:	55                   	push   %ebp
80106b70:	89 e5                	mov    %esp,%ebp
80106b72:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80106b75:	83 ec 04             	sub    $0x4,%esp
80106b78:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b7b:	50                   	push   %eax
80106b7c:	6a 00                	push   $0x0
80106b7e:	6a 00                	push   $0x0
80106b80:	e8 29 ff ff ff       	call   80106aae <argfd>
80106b85:	83 c4 10             	add    $0x10,%esp
80106b88:	85 c0                	test   %eax,%eax
80106b8a:	79 07                	jns    80106b93 <sys_dup+0x24>
    return -1;
80106b8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b91:	eb 31                	jmp    80106bc4 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80106b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b96:	83 ec 0c             	sub    $0xc,%esp
80106b99:	50                   	push   %eax
80106b9a:	e8 84 ff ff ff       	call   80106b23 <fdalloc>
80106b9f:	83 c4 10             	add    $0x10,%esp
80106ba2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106ba5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106ba9:	79 07                	jns    80106bb2 <sys_dup+0x43>
    return -1;
80106bab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bb0:	eb 12                	jmp    80106bc4 <sys_dup+0x55>
  filedup(f);
80106bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bb5:	83 ec 0c             	sub    $0xc,%esp
80106bb8:	50                   	push   %eax
80106bb9:	e8 b8 a4 ff ff       	call   80101076 <filedup>
80106bbe:	83 c4 10             	add    $0x10,%esp
  return fd;
80106bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106bc4:	c9                   	leave  
80106bc5:	c3                   	ret    

80106bc6 <sys_read>:

int
sys_read(void)
{
80106bc6:	55                   	push   %ebp
80106bc7:	89 e5                	mov    %esp,%ebp
80106bc9:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106bcc:	83 ec 04             	sub    $0x4,%esp
80106bcf:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bd2:	50                   	push   %eax
80106bd3:	6a 00                	push   $0x0
80106bd5:	6a 00                	push   $0x0
80106bd7:	e8 d2 fe ff ff       	call   80106aae <argfd>
80106bdc:	83 c4 10             	add    $0x10,%esp
80106bdf:	85 c0                	test   %eax,%eax
80106be1:	78 2e                	js     80106c11 <sys_read+0x4b>
80106be3:	83 ec 08             	sub    $0x8,%esp
80106be6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106be9:	50                   	push   %eax
80106bea:	6a 02                	push   $0x2
80106bec:	e8 81 fd ff ff       	call   80106972 <argint>
80106bf1:	83 c4 10             	add    $0x10,%esp
80106bf4:	85 c0                	test   %eax,%eax
80106bf6:	78 19                	js     80106c11 <sys_read+0x4b>
80106bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bfb:	83 ec 04             	sub    $0x4,%esp
80106bfe:	50                   	push   %eax
80106bff:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106c02:	50                   	push   %eax
80106c03:	6a 01                	push   $0x1
80106c05:	e8 90 fd ff ff       	call   8010699a <argptr>
80106c0a:	83 c4 10             	add    $0x10,%esp
80106c0d:	85 c0                	test   %eax,%eax
80106c0f:	79 07                	jns    80106c18 <sys_read+0x52>
    return -1;
80106c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c16:	eb 17                	jmp    80106c2f <sys_read+0x69>
  return fileread(f, p, n);
80106c18:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106c1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c21:	83 ec 04             	sub    $0x4,%esp
80106c24:	51                   	push   %ecx
80106c25:	52                   	push   %edx
80106c26:	50                   	push   %eax
80106c27:	e8 da a5 ff ff       	call   80101206 <fileread>
80106c2c:	83 c4 10             	add    $0x10,%esp
}
80106c2f:	c9                   	leave  
80106c30:	c3                   	ret    

80106c31 <sys_write>:

int
sys_write(void)
{
80106c31:	55                   	push   %ebp
80106c32:	89 e5                	mov    %esp,%ebp
80106c34:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106c37:	83 ec 04             	sub    $0x4,%esp
80106c3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c3d:	50                   	push   %eax
80106c3e:	6a 00                	push   $0x0
80106c40:	6a 00                	push   $0x0
80106c42:	e8 67 fe ff ff       	call   80106aae <argfd>
80106c47:	83 c4 10             	add    $0x10,%esp
80106c4a:	85 c0                	test   %eax,%eax
80106c4c:	78 2e                	js     80106c7c <sys_write+0x4b>
80106c4e:	83 ec 08             	sub    $0x8,%esp
80106c51:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c54:	50                   	push   %eax
80106c55:	6a 02                	push   $0x2
80106c57:	e8 16 fd ff ff       	call   80106972 <argint>
80106c5c:	83 c4 10             	add    $0x10,%esp
80106c5f:	85 c0                	test   %eax,%eax
80106c61:	78 19                	js     80106c7c <sys_write+0x4b>
80106c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c66:	83 ec 04             	sub    $0x4,%esp
80106c69:	50                   	push   %eax
80106c6a:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106c6d:	50                   	push   %eax
80106c6e:	6a 01                	push   $0x1
80106c70:	e8 25 fd ff ff       	call   8010699a <argptr>
80106c75:	83 c4 10             	add    $0x10,%esp
80106c78:	85 c0                	test   %eax,%eax
80106c7a:	79 07                	jns    80106c83 <sys_write+0x52>
    return -1;
80106c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c81:	eb 17                	jmp    80106c9a <sys_write+0x69>
  return filewrite(f, p, n);
80106c83:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106c86:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c8c:	83 ec 04             	sub    $0x4,%esp
80106c8f:	51                   	push   %ecx
80106c90:	52                   	push   %edx
80106c91:	50                   	push   %eax
80106c92:	e8 27 a6 ff ff       	call   801012be <filewrite>
80106c97:	83 c4 10             	add    $0x10,%esp
}
80106c9a:	c9                   	leave  
80106c9b:	c3                   	ret    

80106c9c <sys_close>:

int
sys_close(void)
{
80106c9c:	55                   	push   %ebp
80106c9d:	89 e5                	mov    %esp,%ebp
80106c9f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80106ca2:	83 ec 04             	sub    $0x4,%esp
80106ca5:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ca8:	50                   	push   %eax
80106ca9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106cac:	50                   	push   %eax
80106cad:	6a 00                	push   $0x0
80106caf:	e8 fa fd ff ff       	call   80106aae <argfd>
80106cb4:	83 c4 10             	add    $0x10,%esp
80106cb7:	85 c0                	test   %eax,%eax
80106cb9:	79 07                	jns    80106cc2 <sys_close+0x26>
    return -1;
80106cbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cc0:	eb 28                	jmp    80106cea <sys_close+0x4e>
  proc->ofile[fd] = 0;
80106cc2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ccb:	83 c2 08             	add    $0x8,%edx
80106cce:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106cd5:	00 
  fileclose(f);
80106cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cd9:	83 ec 0c             	sub    $0xc,%esp
80106cdc:	50                   	push   %eax
80106cdd:	e8 e5 a3 ff ff       	call   801010c7 <fileclose>
80106ce2:	83 c4 10             	add    $0x10,%esp
  return 0;
80106ce5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106cea:	c9                   	leave  
80106ceb:	c3                   	ret    

80106cec <sys_fstat>:

int
sys_fstat(void)
{
80106cec:	55                   	push   %ebp
80106ced:	89 e5                	mov    %esp,%ebp
80106cef:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106cf2:	83 ec 04             	sub    $0x4,%esp
80106cf5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106cf8:	50                   	push   %eax
80106cf9:	6a 00                	push   $0x0
80106cfb:	6a 00                	push   $0x0
80106cfd:	e8 ac fd ff ff       	call   80106aae <argfd>
80106d02:	83 c4 10             	add    $0x10,%esp
80106d05:	85 c0                	test   %eax,%eax
80106d07:	78 17                	js     80106d20 <sys_fstat+0x34>
80106d09:	83 ec 04             	sub    $0x4,%esp
80106d0c:	6a 14                	push   $0x14
80106d0e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d11:	50                   	push   %eax
80106d12:	6a 01                	push   $0x1
80106d14:	e8 81 fc ff ff       	call   8010699a <argptr>
80106d19:	83 c4 10             	add    $0x10,%esp
80106d1c:	85 c0                	test   %eax,%eax
80106d1e:	79 07                	jns    80106d27 <sys_fstat+0x3b>
    return -1;
80106d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d25:	eb 13                	jmp    80106d3a <sys_fstat+0x4e>
  return filestat(f, st);
80106d27:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d2d:	83 ec 08             	sub    $0x8,%esp
80106d30:	52                   	push   %edx
80106d31:	50                   	push   %eax
80106d32:	e8 78 a4 ff ff       	call   801011af <filestat>
80106d37:	83 c4 10             	add    $0x10,%esp
}
80106d3a:	c9                   	leave  
80106d3b:	c3                   	ret    

80106d3c <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106d3c:	55                   	push   %ebp
80106d3d:	89 e5                	mov    %esp,%ebp
80106d3f:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106d42:	83 ec 08             	sub    $0x8,%esp
80106d45:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106d48:	50                   	push   %eax
80106d49:	6a 00                	push   $0x0
80106d4b:	e8 a7 fc ff ff       	call   801069f7 <argstr>
80106d50:	83 c4 10             	add    $0x10,%esp
80106d53:	85 c0                	test   %eax,%eax
80106d55:	78 15                	js     80106d6c <sys_link+0x30>
80106d57:	83 ec 08             	sub    $0x8,%esp
80106d5a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106d5d:	50                   	push   %eax
80106d5e:	6a 01                	push   $0x1
80106d60:	e8 92 fc ff ff       	call   801069f7 <argstr>
80106d65:	83 c4 10             	add    $0x10,%esp
80106d68:	85 c0                	test   %eax,%eax
80106d6a:	79 0a                	jns    80106d76 <sys_link+0x3a>
    return -1;
80106d6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d71:	e9 68 01 00 00       	jmp    80106ede <sys_link+0x1a2>

  begin_op();
80106d76:	e8 33 ca ff ff       	call   801037ae <begin_op>
  if((ip = namei(old)) == 0){
80106d7b:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106d7e:	83 ec 0c             	sub    $0xc,%esp
80106d81:	50                   	push   %eax
80106d82:	e8 20 b9 ff ff       	call   801026a7 <namei>
80106d87:	83 c4 10             	add    $0x10,%esp
80106d8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106d8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106d91:	75 0f                	jne    80106da2 <sys_link+0x66>
    end_op();
80106d93:	e8 a2 ca ff ff       	call   8010383a <end_op>
    return -1;
80106d98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d9d:	e9 3c 01 00 00       	jmp    80106ede <sys_link+0x1a2>
  }

  ilock(ip);
80106da2:	83 ec 0c             	sub    $0xc,%esp
80106da5:	ff 75 f4             	pushl  -0xc(%ebp)
80106da8:	e8 24 ac ff ff       	call   801019d1 <ilock>
80106dad:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80106db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106db3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106db7:	66 83 f8 01          	cmp    $0x1,%ax
80106dbb:	75 1d                	jne    80106dda <sys_link+0x9e>
    iunlockput(ip);
80106dbd:	83 ec 0c             	sub    $0xc,%esp
80106dc0:	ff 75 f4             	pushl  -0xc(%ebp)
80106dc3:	e8 c3 ae ff ff       	call   80101c8b <iunlockput>
80106dc8:	83 c4 10             	add    $0x10,%esp
    end_op();
80106dcb:	e8 6a ca ff ff       	call   8010383a <end_op>
    return -1;
80106dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dd5:	e9 04 01 00 00       	jmp    80106ede <sys_link+0x1a2>
  }

  ip->nlink++;
80106dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ddd:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106de1:	83 c0 01             	add    $0x1,%eax
80106de4:	89 c2                	mov    %eax,%edx
80106de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106de9:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106ded:	83 ec 0c             	sub    $0xc,%esp
80106df0:	ff 75 f4             	pushl  -0xc(%ebp)
80106df3:	e8 05 aa ff ff       	call   801017fd <iupdate>
80106df8:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106dfb:	83 ec 0c             	sub    $0xc,%esp
80106dfe:	ff 75 f4             	pushl  -0xc(%ebp)
80106e01:	e8 23 ad ff ff       	call   80101b29 <iunlock>
80106e06:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106e09:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106e0c:	83 ec 08             	sub    $0x8,%esp
80106e0f:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106e12:	52                   	push   %edx
80106e13:	50                   	push   %eax
80106e14:	e8 aa b8 ff ff       	call   801026c3 <nameiparent>
80106e19:	83 c4 10             	add    $0x10,%esp
80106e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106e1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106e23:	74 71                	je     80106e96 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80106e25:	83 ec 0c             	sub    $0xc,%esp
80106e28:	ff 75 f0             	pushl  -0x10(%ebp)
80106e2b:	e8 a1 ab ff ff       	call   801019d1 <ilock>
80106e30:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e36:	8b 10                	mov    (%eax),%edx
80106e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e3b:	8b 00                	mov    (%eax),%eax
80106e3d:	39 c2                	cmp    %eax,%edx
80106e3f:	75 1d                	jne    80106e5e <sys_link+0x122>
80106e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e44:	8b 40 04             	mov    0x4(%eax),%eax
80106e47:	83 ec 04             	sub    $0x4,%esp
80106e4a:	50                   	push   %eax
80106e4b:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106e4e:	50                   	push   %eax
80106e4f:	ff 75 f0             	pushl  -0x10(%ebp)
80106e52:	e8 70 b5 ff ff       	call   801023c7 <dirlink>
80106e57:	83 c4 10             	add    $0x10,%esp
80106e5a:	85 c0                	test   %eax,%eax
80106e5c:	79 10                	jns    80106e6e <sys_link+0x132>
    iunlockput(dp);
80106e5e:	83 ec 0c             	sub    $0xc,%esp
80106e61:	ff 75 f0             	pushl  -0x10(%ebp)
80106e64:	e8 22 ae ff ff       	call   80101c8b <iunlockput>
80106e69:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106e6c:	eb 29                	jmp    80106e97 <sys_link+0x15b>
  }
  iunlockput(dp);
80106e6e:	83 ec 0c             	sub    $0xc,%esp
80106e71:	ff 75 f0             	pushl  -0x10(%ebp)
80106e74:	e8 12 ae ff ff       	call   80101c8b <iunlockput>
80106e79:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80106e7c:	83 ec 0c             	sub    $0xc,%esp
80106e7f:	ff 75 f4             	pushl  -0xc(%ebp)
80106e82:	e8 14 ad ff ff       	call   80101b9b <iput>
80106e87:	83 c4 10             	add    $0x10,%esp

  end_op();
80106e8a:	e8 ab c9 ff ff       	call   8010383a <end_op>

  return 0;
80106e8f:	b8 00 00 00 00       	mov    $0x0,%eax
80106e94:	eb 48                	jmp    80106ede <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80106e96:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80106e97:	83 ec 0c             	sub    $0xc,%esp
80106e9a:	ff 75 f4             	pushl  -0xc(%ebp)
80106e9d:	e8 2f ab ff ff       	call   801019d1 <ilock>
80106ea2:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80106ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ea8:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106eac:	83 e8 01             	sub    $0x1,%eax
80106eaf:	89 c2                	mov    %eax,%edx
80106eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106eb4:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106eb8:	83 ec 0c             	sub    $0xc,%esp
80106ebb:	ff 75 f4             	pushl  -0xc(%ebp)
80106ebe:	e8 3a a9 ff ff       	call   801017fd <iupdate>
80106ec3:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106ec6:	83 ec 0c             	sub    $0xc,%esp
80106ec9:	ff 75 f4             	pushl  -0xc(%ebp)
80106ecc:	e8 ba ad ff ff       	call   80101c8b <iunlockput>
80106ed1:	83 c4 10             	add    $0x10,%esp
  end_op();
80106ed4:	e8 61 c9 ff ff       	call   8010383a <end_op>
  return -1;
80106ed9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ede:	c9                   	leave  
80106edf:	c3                   	ret    

80106ee0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106ee0:	55                   	push   %ebp
80106ee1:	89 e5                	mov    %esp,%ebp
80106ee3:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106ee6:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106eed:	eb 40                	jmp    80106f2f <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ef2:	6a 10                	push   $0x10
80106ef4:	50                   	push   %eax
80106ef5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106ef8:	50                   	push   %eax
80106ef9:	ff 75 08             	pushl  0x8(%ebp)
80106efc:	e8 38 b0 ff ff       	call   80101f39 <readi>
80106f01:	83 c4 10             	add    $0x10,%esp
80106f04:	83 f8 10             	cmp    $0x10,%eax
80106f07:	74 0d                	je     80106f16 <isdirempty+0x36>
      panic("isdirempty: readi");
80106f09:	83 ec 0c             	sub    $0xc,%esp
80106f0c:	68 e0 9f 10 80       	push   $0x80109fe0
80106f11:	e8 e1 96 ff ff       	call   801005f7 <panic>
    if(de.inum != 0)
80106f16:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106f1a:	66 85 c0             	test   %ax,%ax
80106f1d:	74 07                	je     80106f26 <isdirempty+0x46>
      return 0;
80106f1f:	b8 00 00 00 00       	mov    $0x0,%eax
80106f24:	eb 1b                	jmp    80106f41 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f29:	83 c0 10             	add    $0x10,%eax
80106f2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106f2f:	8b 45 08             	mov    0x8(%ebp),%eax
80106f32:	8b 50 18             	mov    0x18(%eax),%edx
80106f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f38:	39 c2                	cmp    %eax,%edx
80106f3a:	77 b3                	ja     80106eef <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106f3c:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106f41:	c9                   	leave  
80106f42:	c3                   	ret    

80106f43 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80106f43:	55                   	push   %ebp
80106f44:	89 e5                	mov    %esp,%ebp
80106f46:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106f49:	83 ec 08             	sub    $0x8,%esp
80106f4c:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106f4f:	50                   	push   %eax
80106f50:	6a 00                	push   $0x0
80106f52:	e8 a0 fa ff ff       	call   801069f7 <argstr>
80106f57:	83 c4 10             	add    $0x10,%esp
80106f5a:	85 c0                	test   %eax,%eax
80106f5c:	79 0a                	jns    80106f68 <sys_unlink+0x25>
    return -1;
80106f5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f63:	e9 bc 01 00 00       	jmp    80107124 <sys_unlink+0x1e1>

  begin_op();
80106f68:	e8 41 c8 ff ff       	call   801037ae <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106f6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106f70:	83 ec 08             	sub    $0x8,%esp
80106f73:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80106f76:	52                   	push   %edx
80106f77:	50                   	push   %eax
80106f78:	e8 46 b7 ff ff       	call   801026c3 <nameiparent>
80106f7d:	83 c4 10             	add    $0x10,%esp
80106f80:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106f83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106f87:	75 0f                	jne    80106f98 <sys_unlink+0x55>
    end_op();
80106f89:	e8 ac c8 ff ff       	call   8010383a <end_op>
    return -1;
80106f8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f93:	e9 8c 01 00 00       	jmp    80107124 <sys_unlink+0x1e1>
  }

  ilock(dp);
80106f98:	83 ec 0c             	sub    $0xc,%esp
80106f9b:	ff 75 f4             	pushl  -0xc(%ebp)
80106f9e:	e8 2e aa ff ff       	call   801019d1 <ilock>
80106fa3:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106fa6:	83 ec 08             	sub    $0x8,%esp
80106fa9:	68 f2 9f 10 80       	push   $0x80109ff2
80106fae:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106fb1:	50                   	push   %eax
80106fb2:	e8 6e b2 ff ff       	call   80102225 <namecmp>
80106fb7:	83 c4 10             	add    $0x10,%esp
80106fba:	85 c0                	test   %eax,%eax
80106fbc:	0f 84 4a 01 00 00    	je     8010710c <sys_unlink+0x1c9>
80106fc2:	83 ec 08             	sub    $0x8,%esp
80106fc5:	68 f4 9f 10 80       	push   $0x80109ff4
80106fca:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106fcd:	50                   	push   %eax
80106fce:	e8 52 b2 ff ff       	call   80102225 <namecmp>
80106fd3:	83 c4 10             	add    $0x10,%esp
80106fd6:	85 c0                	test   %eax,%eax
80106fd8:	0f 84 2e 01 00 00    	je     8010710c <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106fde:	83 ec 04             	sub    $0x4,%esp
80106fe1:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106fe4:	50                   	push   %eax
80106fe5:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106fe8:	50                   	push   %eax
80106fe9:	ff 75 f4             	pushl  -0xc(%ebp)
80106fec:	e8 4f b2 ff ff       	call   80102240 <dirlookup>
80106ff1:	83 c4 10             	add    $0x10,%esp
80106ff4:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106ff7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106ffb:	0f 84 0a 01 00 00    	je     8010710b <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80107001:	83 ec 0c             	sub    $0xc,%esp
80107004:	ff 75 f0             	pushl  -0x10(%ebp)
80107007:	e8 c5 a9 ff ff       	call   801019d1 <ilock>
8010700c:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
8010700f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107012:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107016:	66 85 c0             	test   %ax,%ax
80107019:	7f 0d                	jg     80107028 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
8010701b:	83 ec 0c             	sub    $0xc,%esp
8010701e:	68 f7 9f 10 80       	push   $0x80109ff7
80107023:	e8 cf 95 ff ff       	call   801005f7 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80107028:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010702b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010702f:	66 83 f8 01          	cmp    $0x1,%ax
80107033:	75 25                	jne    8010705a <sys_unlink+0x117>
80107035:	83 ec 0c             	sub    $0xc,%esp
80107038:	ff 75 f0             	pushl  -0x10(%ebp)
8010703b:	e8 a0 fe ff ff       	call   80106ee0 <isdirempty>
80107040:	83 c4 10             	add    $0x10,%esp
80107043:	85 c0                	test   %eax,%eax
80107045:	75 13                	jne    8010705a <sys_unlink+0x117>
    iunlockput(ip);
80107047:	83 ec 0c             	sub    $0xc,%esp
8010704a:	ff 75 f0             	pushl  -0x10(%ebp)
8010704d:	e8 39 ac ff ff       	call   80101c8b <iunlockput>
80107052:	83 c4 10             	add    $0x10,%esp
    goto bad;
80107055:	e9 b2 00 00 00       	jmp    8010710c <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
8010705a:	83 ec 04             	sub    $0x4,%esp
8010705d:	6a 10                	push   $0x10
8010705f:	6a 00                	push   $0x0
80107061:	8d 45 e0             	lea    -0x20(%ebp),%eax
80107064:	50                   	push   %eax
80107065:	e8 f2 f4 ff ff       	call   8010655c <memset>
8010706a:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010706d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80107070:	6a 10                	push   $0x10
80107072:	50                   	push   %eax
80107073:	8d 45 e0             	lea    -0x20(%ebp),%eax
80107076:	50                   	push   %eax
80107077:	ff 75 f4             	pushl  -0xc(%ebp)
8010707a:	e8 18 b0 ff ff       	call   80102097 <writei>
8010707f:	83 c4 10             	add    $0x10,%esp
80107082:	83 f8 10             	cmp    $0x10,%eax
80107085:	74 0d                	je     80107094 <sys_unlink+0x151>
    panic("unlink: writei");
80107087:	83 ec 0c             	sub    $0xc,%esp
8010708a:	68 09 a0 10 80       	push   $0x8010a009
8010708f:	e8 63 95 ff ff       	call   801005f7 <panic>
  if(ip->type == T_DIR){
80107094:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107097:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010709b:	66 83 f8 01          	cmp    $0x1,%ax
8010709f:	75 21                	jne    801070c2 <sys_unlink+0x17f>
    dp->nlink--;
801070a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070a4:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801070a8:	83 e8 01             	sub    $0x1,%eax
801070ab:	89 c2                	mov    %eax,%edx
801070ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070b0:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801070b4:	83 ec 0c             	sub    $0xc,%esp
801070b7:	ff 75 f4             	pushl  -0xc(%ebp)
801070ba:	e8 3e a7 ff ff       	call   801017fd <iupdate>
801070bf:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801070c2:	83 ec 0c             	sub    $0xc,%esp
801070c5:	ff 75 f4             	pushl  -0xc(%ebp)
801070c8:	e8 be ab ff ff       	call   80101c8b <iunlockput>
801070cd:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
801070d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070d3:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801070d7:	83 e8 01             	sub    $0x1,%eax
801070da:	89 c2                	mov    %eax,%edx
801070dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070df:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801070e3:	83 ec 0c             	sub    $0xc,%esp
801070e6:	ff 75 f0             	pushl  -0x10(%ebp)
801070e9:	e8 0f a7 ff ff       	call   801017fd <iupdate>
801070ee:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801070f1:	83 ec 0c             	sub    $0xc,%esp
801070f4:	ff 75 f0             	pushl  -0x10(%ebp)
801070f7:	e8 8f ab ff ff       	call   80101c8b <iunlockput>
801070fc:	83 c4 10             	add    $0x10,%esp

  end_op();
801070ff:	e8 36 c7 ff ff       	call   8010383a <end_op>

  return 0;
80107104:	b8 00 00 00 00       	mov    $0x0,%eax
80107109:	eb 19                	jmp    80107124 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
8010710b:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
8010710c:	83 ec 0c             	sub    $0xc,%esp
8010710f:	ff 75 f4             	pushl  -0xc(%ebp)
80107112:	e8 74 ab ff ff       	call   80101c8b <iunlockput>
80107117:	83 c4 10             	add    $0x10,%esp
  end_op();
8010711a:	e8 1b c7 ff ff       	call   8010383a <end_op>
  return -1;
8010711f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107124:	c9                   	leave  
80107125:	c3                   	ret    

80107126 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80107126:	55                   	push   %ebp
80107127:	89 e5                	mov    %esp,%ebp
80107129:	83 ec 38             	sub    $0x38,%esp
8010712c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010712f:	8b 55 10             	mov    0x10(%ebp),%edx
80107132:	8b 45 14             	mov    0x14(%ebp),%eax
80107135:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80107139:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010713d:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80107141:	83 ec 08             	sub    $0x8,%esp
80107144:	8d 45 de             	lea    -0x22(%ebp),%eax
80107147:	50                   	push   %eax
80107148:	ff 75 08             	pushl  0x8(%ebp)
8010714b:	e8 73 b5 ff ff       	call   801026c3 <nameiparent>
80107150:	83 c4 10             	add    $0x10,%esp
80107153:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107156:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010715a:	75 0a                	jne    80107166 <create+0x40>
    return 0;
8010715c:	b8 00 00 00 00       	mov    $0x0,%eax
80107161:	e9 b5 01 00 00       	jmp    8010731b <create+0x1f5>
  ilock(dp);
80107166:	83 ec 0c             	sub    $0xc,%esp
80107169:	ff 75 f4             	pushl  -0xc(%ebp)
8010716c:	e8 60 a8 ff ff       	call   801019d1 <ilock>
80107171:	83 c4 10             	add    $0x10,%esp

  if (dp->type == T_DEV) {
80107174:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107177:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010717b:	66 83 f8 03          	cmp    $0x3,%ax
8010717f:	75 18                	jne    80107199 <create+0x73>
    iunlockput(dp);
80107181:	83 ec 0c             	sub    $0xc,%esp
80107184:	ff 75 f4             	pushl  -0xc(%ebp)
80107187:	e8 ff aa ff ff       	call   80101c8b <iunlockput>
8010718c:	83 c4 10             	add    $0x10,%esp
    return 0;
8010718f:	b8 00 00 00 00       	mov    $0x0,%eax
80107194:	e9 82 01 00 00       	jmp    8010731b <create+0x1f5>
  }

  if((ip = dirlookup(dp, name, &off)) != 0){
80107199:	83 ec 04             	sub    $0x4,%esp
8010719c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010719f:	50                   	push   %eax
801071a0:	8d 45 de             	lea    -0x22(%ebp),%eax
801071a3:	50                   	push   %eax
801071a4:	ff 75 f4             	pushl  -0xc(%ebp)
801071a7:	e8 94 b0 ff ff       	call   80102240 <dirlookup>
801071ac:	83 c4 10             	add    $0x10,%esp
801071af:	89 45 f0             	mov    %eax,-0x10(%ebp)
801071b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801071b6:	74 50                	je     80107208 <create+0xe2>
    iunlockput(dp);
801071b8:	83 ec 0c             	sub    $0xc,%esp
801071bb:	ff 75 f4             	pushl  -0xc(%ebp)
801071be:	e8 c8 aa ff ff       	call   80101c8b <iunlockput>
801071c3:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801071c6:	83 ec 0c             	sub    $0xc,%esp
801071c9:	ff 75 f0             	pushl  -0x10(%ebp)
801071cc:	e8 00 a8 ff ff       	call   801019d1 <ilock>
801071d1:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801071d4:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801071d9:	75 15                	jne    801071f0 <create+0xca>
801071db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071de:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801071e2:	66 83 f8 02          	cmp    $0x2,%ax
801071e6:	75 08                	jne    801071f0 <create+0xca>
      return ip;
801071e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071eb:	e9 2b 01 00 00       	jmp    8010731b <create+0x1f5>
    iunlockput(ip);
801071f0:	83 ec 0c             	sub    $0xc,%esp
801071f3:	ff 75 f0             	pushl  -0x10(%ebp)
801071f6:	e8 90 aa ff ff       	call   80101c8b <iunlockput>
801071fb:	83 c4 10             	add    $0x10,%esp
    return 0;
801071fe:	b8 00 00 00 00       	mov    $0x0,%eax
80107203:	e9 13 01 00 00       	jmp    8010731b <create+0x1f5>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80107208:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010720c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010720f:	8b 00                	mov    (%eax),%eax
80107211:	83 ec 08             	sub    $0x8,%esp
80107214:	52                   	push   %edx
80107215:	50                   	push   %eax
80107216:	e8 01 a5 ff ff       	call   8010171c <ialloc>
8010721b:	83 c4 10             	add    $0x10,%esp
8010721e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107221:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107225:	75 0d                	jne    80107234 <create+0x10e>
    panic("create: ialloc");
80107227:	83 ec 0c             	sub    $0xc,%esp
8010722a:	68 18 a0 10 80       	push   $0x8010a018
8010722f:	e8 c3 93 ff ff       	call   801005f7 <panic>

  ilock(ip);
80107234:	83 ec 0c             	sub    $0xc,%esp
80107237:	ff 75 f0             	pushl  -0x10(%ebp)
8010723a:	e8 92 a7 ff ff       	call   801019d1 <ilock>
8010723f:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80107242:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107245:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80107249:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
8010724d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107250:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80107254:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80107258:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010725b:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80107261:	83 ec 0c             	sub    $0xc,%esp
80107264:	ff 75 f0             	pushl  -0x10(%ebp)
80107267:	e8 91 a5 ff ff       	call   801017fd <iupdate>
8010726c:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
8010726f:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80107274:	75 6a                	jne    801072e0 <create+0x1ba>
    dp->nlink++;  // for ".."
80107276:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107279:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010727d:	83 c0 01             	add    $0x1,%eax
80107280:	89 c2                	mov    %eax,%edx
80107282:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107285:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80107289:	83 ec 0c             	sub    $0xc,%esp
8010728c:	ff 75 f4             	pushl  -0xc(%ebp)
8010728f:	e8 69 a5 ff ff       	call   801017fd <iupdate>
80107294:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80107297:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010729a:	8b 40 04             	mov    0x4(%eax),%eax
8010729d:	83 ec 04             	sub    $0x4,%esp
801072a0:	50                   	push   %eax
801072a1:	68 f2 9f 10 80       	push   $0x80109ff2
801072a6:	ff 75 f0             	pushl  -0x10(%ebp)
801072a9:	e8 19 b1 ff ff       	call   801023c7 <dirlink>
801072ae:	83 c4 10             	add    $0x10,%esp
801072b1:	85 c0                	test   %eax,%eax
801072b3:	78 1e                	js     801072d3 <create+0x1ad>
801072b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072b8:	8b 40 04             	mov    0x4(%eax),%eax
801072bb:	83 ec 04             	sub    $0x4,%esp
801072be:	50                   	push   %eax
801072bf:	68 f4 9f 10 80       	push   $0x80109ff4
801072c4:	ff 75 f0             	pushl  -0x10(%ebp)
801072c7:	e8 fb b0 ff ff       	call   801023c7 <dirlink>
801072cc:	83 c4 10             	add    $0x10,%esp
801072cf:	85 c0                	test   %eax,%eax
801072d1:	79 0d                	jns    801072e0 <create+0x1ba>
      panic("create dots");
801072d3:	83 ec 0c             	sub    $0xc,%esp
801072d6:	68 27 a0 10 80       	push   $0x8010a027
801072db:	e8 17 93 ff ff       	call   801005f7 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801072e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072e3:	8b 40 04             	mov    0x4(%eax),%eax
801072e6:	83 ec 04             	sub    $0x4,%esp
801072e9:	50                   	push   %eax
801072ea:	8d 45 de             	lea    -0x22(%ebp),%eax
801072ed:	50                   	push   %eax
801072ee:	ff 75 f4             	pushl  -0xc(%ebp)
801072f1:	e8 d1 b0 ff ff       	call   801023c7 <dirlink>
801072f6:	83 c4 10             	add    $0x10,%esp
801072f9:	85 c0                	test   %eax,%eax
801072fb:	79 0d                	jns    8010730a <create+0x1e4>
    panic("create: dirlink");
801072fd:	83 ec 0c             	sub    $0xc,%esp
80107300:	68 33 a0 10 80       	push   $0x8010a033
80107305:	e8 ed 92 ff ff       	call   801005f7 <panic>

  iunlockput(dp);
8010730a:	83 ec 0c             	sub    $0xc,%esp
8010730d:	ff 75 f4             	pushl  -0xc(%ebp)
80107310:	e8 76 a9 ff ff       	call   80101c8b <iunlockput>
80107315:	83 c4 10             	add    $0x10,%esp

  return ip;
80107318:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010731b:	c9                   	leave  
8010731c:	c3                   	ret    

8010731d <sys_open>:

int
sys_open(void)
{
8010731d:	55                   	push   %ebp
8010731e:	89 e5                	mov    %esp,%ebp
80107320:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80107323:	83 ec 08             	sub    $0x8,%esp
80107326:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107329:	50                   	push   %eax
8010732a:	6a 00                	push   $0x0
8010732c:	e8 c6 f6 ff ff       	call   801069f7 <argstr>
80107331:	83 c4 10             	add    $0x10,%esp
80107334:	85 c0                	test   %eax,%eax
80107336:	78 15                	js     8010734d <sys_open+0x30>
80107338:	83 ec 08             	sub    $0x8,%esp
8010733b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010733e:	50                   	push   %eax
8010733f:	6a 01                	push   $0x1
80107341:	e8 2c f6 ff ff       	call   80106972 <argint>
80107346:	83 c4 10             	add    $0x10,%esp
80107349:	85 c0                	test   %eax,%eax
8010734b:	79 0a                	jns    80107357 <sys_open+0x3a>
    return -1;
8010734d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107352:	e9 61 01 00 00       	jmp    801074b8 <sys_open+0x19b>

  begin_op();
80107357:	e8 52 c4 ff ff       	call   801037ae <begin_op>

  if(omode & O_CREATE){
8010735c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010735f:	25 00 02 00 00       	and    $0x200,%eax
80107364:	85 c0                	test   %eax,%eax
80107366:	74 2a                	je     80107392 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80107368:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010736b:	6a 00                	push   $0x0
8010736d:	6a 00                	push   $0x0
8010736f:	6a 02                	push   $0x2
80107371:	50                   	push   %eax
80107372:	e8 af fd ff ff       	call   80107126 <create>
80107377:	83 c4 10             	add    $0x10,%esp
8010737a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010737d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107381:	75 75                	jne    801073f8 <sys_open+0xdb>
      end_op();
80107383:	e8 b2 c4 ff ff       	call   8010383a <end_op>
      return -1;
80107388:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010738d:	e9 26 01 00 00       	jmp    801074b8 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80107392:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107395:	83 ec 0c             	sub    $0xc,%esp
80107398:	50                   	push   %eax
80107399:	e8 09 b3 ff ff       	call   801026a7 <namei>
8010739e:	83 c4 10             	add    $0x10,%esp
801073a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801073a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801073a8:	75 0f                	jne    801073b9 <sys_open+0x9c>
      end_op();
801073aa:	e8 8b c4 ff ff       	call   8010383a <end_op>
      return -1;
801073af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073b4:	e9 ff 00 00 00       	jmp    801074b8 <sys_open+0x19b>
    }
    ilock(ip);
801073b9:	83 ec 0c             	sub    $0xc,%esp
801073bc:	ff 75 f4             	pushl  -0xc(%ebp)
801073bf:	e8 0d a6 ff ff       	call   801019d1 <ilock>
801073c4:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801073c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073ca:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801073ce:	66 83 f8 01          	cmp    $0x1,%ax
801073d2:	75 24                	jne    801073f8 <sys_open+0xdb>
801073d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073d7:	85 c0                	test   %eax,%eax
801073d9:	74 1d                	je     801073f8 <sys_open+0xdb>
      iunlockput(ip);
801073db:	83 ec 0c             	sub    $0xc,%esp
801073de:	ff 75 f4             	pushl  -0xc(%ebp)
801073e1:	e8 a5 a8 ff ff       	call   80101c8b <iunlockput>
801073e6:	83 c4 10             	add    $0x10,%esp
      end_op();
801073e9:	e8 4c c4 ff ff       	call   8010383a <end_op>
      return -1;
801073ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073f3:	e9 c0 00 00 00       	jmp    801074b8 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801073f8:	e8 0c 9c ff ff       	call   80101009 <filealloc>
801073fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107400:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107404:	74 17                	je     8010741d <sys_open+0x100>
80107406:	83 ec 0c             	sub    $0xc,%esp
80107409:	ff 75 f0             	pushl  -0x10(%ebp)
8010740c:	e8 12 f7 ff ff       	call   80106b23 <fdalloc>
80107411:	83 c4 10             	add    $0x10,%esp
80107414:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107417:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010741b:	79 2e                	jns    8010744b <sys_open+0x12e>
    if(f)
8010741d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107421:	74 0e                	je     80107431 <sys_open+0x114>
      fileclose(f);
80107423:	83 ec 0c             	sub    $0xc,%esp
80107426:	ff 75 f0             	pushl  -0x10(%ebp)
80107429:	e8 99 9c ff ff       	call   801010c7 <fileclose>
8010742e:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80107431:	83 ec 0c             	sub    $0xc,%esp
80107434:	ff 75 f4             	pushl  -0xc(%ebp)
80107437:	e8 4f a8 ff ff       	call   80101c8b <iunlockput>
8010743c:	83 c4 10             	add    $0x10,%esp
    end_op();
8010743f:	e8 f6 c3 ff ff       	call   8010383a <end_op>
    return -1;
80107444:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107449:	eb 6d                	jmp    801074b8 <sys_open+0x19b>
  }
  iunlock(ip);
8010744b:	83 ec 0c             	sub    $0xc,%esp
8010744e:	ff 75 f4             	pushl  -0xc(%ebp)
80107451:	e8 d3 a6 ff ff       	call   80101b29 <iunlock>
80107456:	83 c4 10             	add    $0x10,%esp
  end_op();
80107459:	e8 dc c3 ff ff       	call   8010383a <end_op>

  f->type = FD_INODE;
8010745e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107461:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80107467:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010746a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010746d:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80107470:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107473:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010747a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010747d:	83 e0 01             	and    $0x1,%eax
80107480:	85 c0                	test   %eax,%eax
80107482:	0f 94 c0             	sete   %al
80107485:	89 c2                	mov    %eax,%edx
80107487:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010748a:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010748d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107490:	83 e0 01             	and    $0x1,%eax
80107493:	85 c0                	test   %eax,%eax
80107495:	75 0a                	jne    801074a1 <sys_open+0x184>
80107497:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010749a:	83 e0 02             	and    $0x2,%eax
8010749d:	85 c0                	test   %eax,%eax
8010749f:	74 07                	je     801074a8 <sys_open+0x18b>
801074a1:	b8 01 00 00 00       	mov    $0x1,%eax
801074a6:	eb 05                	jmp    801074ad <sys_open+0x190>
801074a8:	b8 00 00 00 00       	mov    $0x0,%eax
801074ad:	89 c2                	mov    %eax,%edx
801074af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074b2:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801074b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801074b8:	c9                   	leave  
801074b9:	c3                   	ret    

801074ba <sys_mkdir>:

int
sys_mkdir(void)
{
801074ba:	55                   	push   %ebp
801074bb:	89 e5                	mov    %esp,%ebp
801074bd:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801074c0:	e8 e9 c2 ff ff       	call   801037ae <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801074c5:	83 ec 08             	sub    $0x8,%esp
801074c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801074cb:	50                   	push   %eax
801074cc:	6a 00                	push   $0x0
801074ce:	e8 24 f5 ff ff       	call   801069f7 <argstr>
801074d3:	83 c4 10             	add    $0x10,%esp
801074d6:	85 c0                	test   %eax,%eax
801074d8:	78 1b                	js     801074f5 <sys_mkdir+0x3b>
801074da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074dd:	6a 00                	push   $0x0
801074df:	6a 00                	push   $0x0
801074e1:	6a 01                	push   $0x1
801074e3:	50                   	push   %eax
801074e4:	e8 3d fc ff ff       	call   80107126 <create>
801074e9:	83 c4 10             	add    $0x10,%esp
801074ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
801074ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801074f3:	75 0c                	jne    80107501 <sys_mkdir+0x47>
    end_op();
801074f5:	e8 40 c3 ff ff       	call   8010383a <end_op>
    return -1;
801074fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074ff:	eb 18                	jmp    80107519 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80107501:	83 ec 0c             	sub    $0xc,%esp
80107504:	ff 75 f4             	pushl  -0xc(%ebp)
80107507:	e8 7f a7 ff ff       	call   80101c8b <iunlockput>
8010750c:	83 c4 10             	add    $0x10,%esp
  end_op();
8010750f:	e8 26 c3 ff ff       	call   8010383a <end_op>
  return 0;
80107514:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107519:	c9                   	leave  
8010751a:	c3                   	ret    

8010751b <sys_mknod>:

int
sys_mknod(void)
{
8010751b:	55                   	push   %ebp
8010751c:	89 e5                	mov    %esp,%ebp
8010751e:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80107521:	e8 88 c2 ff ff       	call   801037ae <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80107526:	83 ec 08             	sub    $0x8,%esp
80107529:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010752c:	50                   	push   %eax
8010752d:	6a 00                	push   $0x0
8010752f:	e8 c3 f4 ff ff       	call   801069f7 <argstr>
80107534:	83 c4 10             	add    $0x10,%esp
80107537:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010753a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010753e:	78 4f                	js     8010758f <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80107540:	83 ec 08             	sub    $0x8,%esp
80107543:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107546:	50                   	push   %eax
80107547:	6a 01                	push   $0x1
80107549:	e8 24 f4 ff ff       	call   80106972 <argint>
8010754e:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80107551:	85 c0                	test   %eax,%eax
80107553:	78 3a                	js     8010758f <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107555:	83 ec 08             	sub    $0x8,%esp
80107558:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010755b:	50                   	push   %eax
8010755c:	6a 02                	push   $0x2
8010755e:	e8 0f f4 ff ff       	call   80106972 <argint>
80107563:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80107566:	85 c0                	test   %eax,%eax
80107568:	78 25                	js     8010758f <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
8010756a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010756d:	0f bf c8             	movswl %ax,%ecx
80107570:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107573:	0f bf d0             	movswl %ax,%edx
80107576:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107579:	51                   	push   %ecx
8010757a:	52                   	push   %edx
8010757b:	6a 03                	push   $0x3
8010757d:	50                   	push   %eax
8010757e:	e8 a3 fb ff ff       	call   80107126 <create>
80107583:	83 c4 10             	add    $0x10,%esp
80107586:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107589:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010758d:	75 0c                	jne    8010759b <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
8010758f:	e8 a6 c2 ff ff       	call   8010383a <end_op>
    return -1;
80107594:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107599:	eb 18                	jmp    801075b3 <sys_mknod+0x98>
  }
  iunlockput(ip);
8010759b:	83 ec 0c             	sub    $0xc,%esp
8010759e:	ff 75 f0             	pushl  -0x10(%ebp)
801075a1:	e8 e5 a6 ff ff       	call   80101c8b <iunlockput>
801075a6:	83 c4 10             	add    $0x10,%esp
  end_op();
801075a9:	e8 8c c2 ff ff       	call   8010383a <end_op>
  return 0;
801075ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
801075b3:	c9                   	leave  
801075b4:	c3                   	ret    

801075b5 <sys_chdir>:

int
sys_chdir(void)
{
801075b5:	55                   	push   %ebp
801075b6:	89 e5                	mov    %esp,%ebp
801075b8:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801075bb:	e8 ee c1 ff ff       	call   801037ae <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801075c0:	83 ec 08             	sub    $0x8,%esp
801075c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801075c6:	50                   	push   %eax
801075c7:	6a 00                	push   $0x0
801075c9:	e8 29 f4 ff ff       	call   801069f7 <argstr>
801075ce:	83 c4 10             	add    $0x10,%esp
801075d1:	85 c0                	test   %eax,%eax
801075d3:	78 18                	js     801075ed <sys_chdir+0x38>
801075d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801075d8:	83 ec 0c             	sub    $0xc,%esp
801075db:	50                   	push   %eax
801075dc:	e8 c6 b0 ff ff       	call   801026a7 <namei>
801075e1:	83 c4 10             	add    $0x10,%esp
801075e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801075e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801075eb:	75 0f                	jne    801075fc <sys_chdir+0x47>
    end_op();
801075ed:	e8 48 c2 ff ff       	call   8010383a <end_op>
    return -1;
801075f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075f7:	e9 b2 00 00 00       	jmp    801076ae <sys_chdir+0xf9>
  }
  ilock(ip);
801075fc:	83 ec 0c             	sub    $0xc,%esp
801075ff:	ff 75 f4             	pushl  -0xc(%ebp)
80107602:	e8 ca a3 ff ff       	call   801019d1 <ilock>
80107607:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR && !IS_DEV_DIR(ip)) {
8010760a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010760d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107611:	66 83 f8 01          	cmp    $0x1,%ax
80107615:	74 5e                	je     80107675 <sys_chdir+0xc0>
80107617:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010761a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010761e:	66 83 f8 03          	cmp    $0x3,%ax
80107622:	75 37                	jne    8010765b <sys_chdir+0xa6>
80107624:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107627:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010762b:	98                   	cwtl   
8010762c:	c1 e0 04             	shl    $0x4,%eax
8010762f:	05 00 32 11 80       	add    $0x80113200,%eax
80107634:	8b 00                	mov    (%eax),%eax
80107636:	85 c0                	test   %eax,%eax
80107638:	74 21                	je     8010765b <sys_chdir+0xa6>
8010763a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010763d:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80107641:	98                   	cwtl   
80107642:	c1 e0 04             	shl    $0x4,%eax
80107645:	05 00 32 11 80       	add    $0x80113200,%eax
8010764a:	8b 00                	mov    (%eax),%eax
8010764c:	83 ec 0c             	sub    $0xc,%esp
8010764f:	ff 75 f4             	pushl  -0xc(%ebp)
80107652:	ff d0                	call   *%eax
80107654:	83 c4 10             	add    $0x10,%esp
80107657:	85 c0                	test   %eax,%eax
80107659:	75 1a                	jne    80107675 <sys_chdir+0xc0>
    iunlockput(ip);
8010765b:	83 ec 0c             	sub    $0xc,%esp
8010765e:	ff 75 f4             	pushl  -0xc(%ebp)
80107661:	e8 25 a6 ff ff       	call   80101c8b <iunlockput>
80107666:	83 c4 10             	add    $0x10,%esp
    end_op();
80107669:	e8 cc c1 ff ff       	call   8010383a <end_op>
    return -1;
8010766e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107673:	eb 39                	jmp    801076ae <sys_chdir+0xf9>
  }
  iunlock(ip);
80107675:	83 ec 0c             	sub    $0xc,%esp
80107678:	ff 75 f4             	pushl  -0xc(%ebp)
8010767b:	e8 a9 a4 ff ff       	call   80101b29 <iunlock>
80107680:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80107683:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107689:	8b 40 68             	mov    0x68(%eax),%eax
8010768c:	83 ec 0c             	sub    $0xc,%esp
8010768f:	50                   	push   %eax
80107690:	e8 06 a5 ff ff       	call   80101b9b <iput>
80107695:	83 c4 10             	add    $0x10,%esp
  end_op();
80107698:	e8 9d c1 ff ff       	call   8010383a <end_op>
  proc->cwd = ip;
8010769d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801076a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801076a6:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801076a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801076ae:	c9                   	leave  
801076af:	c3                   	ret    

801076b0 <sys_exec>:

int
sys_exec(void)
{
801076b0:	55                   	push   %ebp
801076b1:	89 e5                	mov    %esp,%ebp
801076b3:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801076b9:	83 ec 08             	sub    $0x8,%esp
801076bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801076bf:	50                   	push   %eax
801076c0:	6a 00                	push   $0x0
801076c2:	e8 30 f3 ff ff       	call   801069f7 <argstr>
801076c7:	83 c4 10             	add    $0x10,%esp
801076ca:	85 c0                	test   %eax,%eax
801076cc:	78 18                	js     801076e6 <sys_exec+0x36>
801076ce:	83 ec 08             	sub    $0x8,%esp
801076d1:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801076d7:	50                   	push   %eax
801076d8:	6a 01                	push   $0x1
801076da:	e8 93 f2 ff ff       	call   80106972 <argint>
801076df:	83 c4 10             	add    $0x10,%esp
801076e2:	85 c0                	test   %eax,%eax
801076e4:	79 0a                	jns    801076f0 <sys_exec+0x40>
    return -1;
801076e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801076eb:	e9 c6 00 00 00       	jmp    801077b6 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
801076f0:	83 ec 04             	sub    $0x4,%esp
801076f3:	68 80 00 00 00       	push   $0x80
801076f8:	6a 00                	push   $0x0
801076fa:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107700:	50                   	push   %eax
80107701:	e8 56 ee ff ff       	call   8010655c <memset>
80107706:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80107709:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80107710:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107713:	83 f8 1f             	cmp    $0x1f,%eax
80107716:	76 0a                	jbe    80107722 <sys_exec+0x72>
      return -1;
80107718:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010771d:	e9 94 00 00 00       	jmp    801077b6 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107722:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107725:	c1 e0 02             	shl    $0x2,%eax
80107728:	89 c2                	mov    %eax,%edx
8010772a:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80107730:	01 c2                	add    %eax,%edx
80107732:	83 ec 08             	sub    $0x8,%esp
80107735:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010773b:	50                   	push   %eax
8010773c:	52                   	push   %edx
8010773d:	e8 94 f1 ff ff       	call   801068d6 <fetchint>
80107742:	83 c4 10             	add    $0x10,%esp
80107745:	85 c0                	test   %eax,%eax
80107747:	79 07                	jns    80107750 <sys_exec+0xa0>
      return -1;
80107749:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010774e:	eb 66                	jmp    801077b6 <sys_exec+0x106>
    if(uarg == 0){
80107750:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107756:	85 c0                	test   %eax,%eax
80107758:	75 27                	jne    80107781 <sys_exec+0xd1>
      argv[i] = 0;
8010775a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010775d:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80107764:	00 00 00 00 
      break;
80107768:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107769:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010776c:	83 ec 08             	sub    $0x8,%esp
8010776f:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80107775:	52                   	push   %edx
80107776:	50                   	push   %eax
80107777:	e8 6b 94 ff ff       	call   80100be7 <exec>
8010777c:	83 c4 10             	add    $0x10,%esp
8010777f:	eb 35                	jmp    801077b6 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80107781:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107787:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010778a:	c1 e2 02             	shl    $0x2,%edx
8010778d:	01 c2                	add    %eax,%edx
8010778f:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107795:	83 ec 08             	sub    $0x8,%esp
80107798:	52                   	push   %edx
80107799:	50                   	push   %eax
8010779a:	e8 71 f1 ff ff       	call   80106910 <fetchstr>
8010779f:	83 c4 10             	add    $0x10,%esp
801077a2:	85 c0                	test   %eax,%eax
801077a4:	79 07                	jns    801077ad <sys_exec+0xfd>
      return -1;
801077a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077ab:	eb 09                	jmp    801077b6 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801077ad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801077b1:	e9 5a ff ff ff       	jmp    80107710 <sys_exec+0x60>
  return exec(path, argv);
}
801077b6:	c9                   	leave  
801077b7:	c3                   	ret    

801077b8 <sys_pipe>:

int
sys_pipe(void)
{
801077b8:	55                   	push   %ebp
801077b9:	89 e5                	mov    %esp,%ebp
801077bb:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801077be:	83 ec 04             	sub    $0x4,%esp
801077c1:	6a 08                	push   $0x8
801077c3:	8d 45 ec             	lea    -0x14(%ebp),%eax
801077c6:	50                   	push   %eax
801077c7:	6a 00                	push   $0x0
801077c9:	e8 cc f1 ff ff       	call   8010699a <argptr>
801077ce:	83 c4 10             	add    $0x10,%esp
801077d1:	85 c0                	test   %eax,%eax
801077d3:	79 0a                	jns    801077df <sys_pipe+0x27>
    return -1;
801077d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077da:	e9 af 00 00 00       	jmp    8010788e <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
801077df:	83 ec 08             	sub    $0x8,%esp
801077e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801077e5:	50                   	push   %eax
801077e6:	8d 45 e8             	lea    -0x18(%ebp),%eax
801077e9:	50                   	push   %eax
801077ea:	e8 bd ca ff ff       	call   801042ac <pipealloc>
801077ef:	83 c4 10             	add    $0x10,%esp
801077f2:	85 c0                	test   %eax,%eax
801077f4:	79 0a                	jns    80107800 <sys_pipe+0x48>
    return -1;
801077f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077fb:	e9 8e 00 00 00       	jmp    8010788e <sys_pipe+0xd6>
  fd0 = -1;
80107800:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107807:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010780a:	83 ec 0c             	sub    $0xc,%esp
8010780d:	50                   	push   %eax
8010780e:	e8 10 f3 ff ff       	call   80106b23 <fdalloc>
80107813:	83 c4 10             	add    $0x10,%esp
80107816:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107819:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010781d:	78 18                	js     80107837 <sys_pipe+0x7f>
8010781f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107822:	83 ec 0c             	sub    $0xc,%esp
80107825:	50                   	push   %eax
80107826:	e8 f8 f2 ff ff       	call   80106b23 <fdalloc>
8010782b:	83 c4 10             	add    $0x10,%esp
8010782e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107831:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107835:	79 3f                	jns    80107876 <sys_pipe+0xbe>
    if(fd0 >= 0)
80107837:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010783b:	78 14                	js     80107851 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
8010783d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107843:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107846:	83 c2 08             	add    $0x8,%edx
80107849:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107850:	00 
    fileclose(rf);
80107851:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107854:	83 ec 0c             	sub    $0xc,%esp
80107857:	50                   	push   %eax
80107858:	e8 6a 98 ff ff       	call   801010c7 <fileclose>
8010785d:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80107860:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107863:	83 ec 0c             	sub    $0xc,%esp
80107866:	50                   	push   %eax
80107867:	e8 5b 98 ff ff       	call   801010c7 <fileclose>
8010786c:	83 c4 10             	add    $0x10,%esp
    return -1;
8010786f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107874:	eb 18                	jmp    8010788e <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80107876:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107879:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010787c:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010787e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107881:	8d 50 04             	lea    0x4(%eax),%edx
80107884:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107887:	89 02                	mov    %eax,(%edx)
  return 0;
80107889:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010788e:	c9                   	leave  
8010788f:	c3                   	ret    

80107890 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80107890:	55                   	push   %ebp
80107891:	89 e5                	mov    %esp,%ebp
80107893:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107896:	e8 07 d1 ff ff       	call   801049a2 <fork>
}
8010789b:	c9                   	leave  
8010789c:	c3                   	ret    

8010789d <sys_exit>:

int
sys_exit(void)
{
8010789d:	55                   	push   %ebp
8010789e:	89 e5                	mov    %esp,%ebp
801078a0:	83 ec 08             	sub    $0x8,%esp
  exit();
801078a3:	e8 8b d2 ff ff       	call   80104b33 <exit>
  return 0;  // not reached
801078a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801078ad:	c9                   	leave  
801078ae:	c3                   	ret    

801078af <sys_wait>:

int
sys_wait(void)
{
801078af:	55                   	push   %ebp
801078b0:	89 e5                	mov    %esp,%ebp
801078b2:	83 ec 08             	sub    $0x8,%esp
  return wait();
801078b5:	e8 b1 d3 ff ff       	call   80104c6b <wait>
}
801078ba:	c9                   	leave  
801078bb:	c3                   	ret    

801078bc <sys_kill>:

int
sys_kill(void)
{
801078bc:	55                   	push   %ebp
801078bd:	89 e5                	mov    %esp,%ebp
801078bf:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801078c2:	83 ec 08             	sub    $0x8,%esp
801078c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801078c8:	50                   	push   %eax
801078c9:	6a 00                	push   $0x0
801078cb:	e8 a2 f0 ff ff       	call   80106972 <argint>
801078d0:	83 c4 10             	add    $0x10,%esp
801078d3:	85 c0                	test   %eax,%eax
801078d5:	79 07                	jns    801078de <sys_kill+0x22>
    return -1;
801078d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078dc:	eb 0f                	jmp    801078ed <sys_kill+0x31>
  return kill(pid);
801078de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e1:	83 ec 0c             	sub    $0xc,%esp
801078e4:	50                   	push   %eax
801078e5:	e8 94 d7 ff ff       	call   8010507e <kill>
801078ea:	83 c4 10             	add    $0x10,%esp
}
801078ed:	c9                   	leave  
801078ee:	c3                   	ret    

801078ef <sys_getpid>:

int
sys_getpid(void)
{
801078ef:	55                   	push   %ebp
801078f0:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801078f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801078f8:	8b 40 10             	mov    0x10(%eax),%eax
}
801078fb:	5d                   	pop    %ebp
801078fc:	c3                   	ret    

801078fd <sys_sbrk>:

int
sys_sbrk(void)
{
801078fd:	55                   	push   %ebp
801078fe:	89 e5                	mov    %esp,%ebp
80107900:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107903:	83 ec 08             	sub    $0x8,%esp
80107906:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107909:	50                   	push   %eax
8010790a:	6a 00                	push   $0x0
8010790c:	e8 61 f0 ff ff       	call   80106972 <argint>
80107911:	83 c4 10             	add    $0x10,%esp
80107914:	85 c0                	test   %eax,%eax
80107916:	79 07                	jns    8010791f <sys_sbrk+0x22>
    return -1;
80107918:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010791d:	eb 28                	jmp    80107947 <sys_sbrk+0x4a>
  addr = proc->sz;
8010791f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107925:	8b 00                	mov    (%eax),%eax
80107927:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
8010792a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010792d:	83 ec 0c             	sub    $0xc,%esp
80107930:	50                   	push   %eax
80107931:	e8 c9 cf ff ff       	call   801048ff <growproc>
80107936:	83 c4 10             	add    $0x10,%esp
80107939:	85 c0                	test   %eax,%eax
8010793b:	79 07                	jns    80107944 <sys_sbrk+0x47>
    return -1;
8010793d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107942:	eb 03                	jmp    80107947 <sys_sbrk+0x4a>
  return addr;
80107944:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107947:	c9                   	leave  
80107948:	c3                   	ret    

80107949 <sys_sleep>:

int
sys_sleep(void)
{
80107949:	55                   	push   %ebp
8010794a:	89 e5                	mov    %esp,%ebp
8010794c:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010794f:	83 ec 08             	sub    $0x8,%esp
80107952:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107955:	50                   	push   %eax
80107956:	6a 00                	push   $0x0
80107958:	e8 15 f0 ff ff       	call   80106972 <argint>
8010795d:	83 c4 10             	add    $0x10,%esp
80107960:	85 c0                	test   %eax,%eax
80107962:	79 07                	jns    8010796b <sys_sleep+0x22>
    return -1;
80107964:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107969:	eb 77                	jmp    801079e2 <sys_sleep+0x99>
  acquire(&tickslock);
8010796b:	83 ec 0c             	sub    $0xc,%esp
8010796e:	68 00 69 11 80       	push   $0x80116900
80107973:	e8 81 e9 ff ff       	call   801062f9 <acquire>
80107978:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
8010797b:	a1 40 71 11 80       	mov    0x80117140,%eax
80107980:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80107983:	eb 39                	jmp    801079be <sys_sleep+0x75>
    if(proc->killed){
80107985:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010798b:	8b 40 24             	mov    0x24(%eax),%eax
8010798e:	85 c0                	test   %eax,%eax
80107990:	74 17                	je     801079a9 <sys_sleep+0x60>
      release(&tickslock);
80107992:	83 ec 0c             	sub    $0xc,%esp
80107995:	68 00 69 11 80       	push   $0x80116900
8010799a:	e8 c1 e9 ff ff       	call   80106360 <release>
8010799f:	83 c4 10             	add    $0x10,%esp
      return -1;
801079a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079a7:	eb 39                	jmp    801079e2 <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
801079a9:	83 ec 08             	sub    $0x8,%esp
801079ac:	68 00 69 11 80       	push   $0x80116900
801079b1:	68 40 71 11 80       	push   $0x80117140
801079b6:	e8 a1 d5 ff ff       	call   80104f5c <sleep>
801079bb:	83 c4 10             	add    $0x10,%esp
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801079be:	a1 40 71 11 80       	mov    0x80117140,%eax
801079c3:	2b 45 f4             	sub    -0xc(%ebp),%eax
801079c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801079c9:	39 d0                	cmp    %edx,%eax
801079cb:	72 b8                	jb     80107985 <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801079cd:	83 ec 0c             	sub    $0xc,%esp
801079d0:	68 00 69 11 80       	push   $0x80116900
801079d5:	e8 86 e9 ff ff       	call   80106360 <release>
801079da:	83 c4 10             	add    $0x10,%esp
  return 0;
801079dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801079e2:	c9                   	leave  
801079e3:	c3                   	ret    

801079e4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801079e4:	55                   	push   %ebp
801079e5:	89 e5                	mov    %esp,%ebp
801079e7:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
801079ea:	83 ec 0c             	sub    $0xc,%esp
801079ed:	68 00 69 11 80       	push   $0x80116900
801079f2:	e8 02 e9 ff ff       	call   801062f9 <acquire>
801079f7:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
801079fa:	a1 40 71 11 80       	mov    0x80117140,%eax
801079ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80107a02:	83 ec 0c             	sub    $0xc,%esp
80107a05:	68 00 69 11 80       	push   $0x80116900
80107a0a:	e8 51 e9 ff ff       	call   80106360 <release>
80107a0f:	83 c4 10             	add    $0x10,%esp
  return xticks;
80107a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107a15:	c9                   	leave  
80107a16:	c3                   	ret    

80107a17 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107a17:	55                   	push   %ebp
80107a18:	89 e5                	mov    %esp,%ebp
80107a1a:	83 ec 08             	sub    $0x8,%esp
80107a1d:	8b 55 08             	mov    0x8(%ebp),%edx
80107a20:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a23:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107a27:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107a2a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107a2e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107a32:	ee                   	out    %al,(%dx)
}
80107a33:	90                   	nop
80107a34:	c9                   	leave  
80107a35:	c3                   	ret    

80107a36 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80107a36:	55                   	push   %ebp
80107a37:	89 e5                	mov    %esp,%ebp
80107a39:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80107a3c:	6a 34                	push   $0x34
80107a3e:	6a 43                	push   $0x43
80107a40:	e8 d2 ff ff ff       	call   80107a17 <outb>
80107a45:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80107a48:	68 9c 00 00 00       	push   $0x9c
80107a4d:	6a 40                	push   $0x40
80107a4f:	e8 c3 ff ff ff       	call   80107a17 <outb>
80107a54:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80107a57:	6a 2e                	push   $0x2e
80107a59:	6a 40                	push   $0x40
80107a5b:	e8 b7 ff ff ff       	call   80107a17 <outb>
80107a60:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80107a63:	83 ec 0c             	sub    $0xc,%esp
80107a66:	6a 00                	push   $0x0
80107a68:	e8 29 c7 ff ff       	call   80104196 <picenable>
80107a6d:	83 c4 10             	add    $0x10,%esp
}
80107a70:	90                   	nop
80107a71:	c9                   	leave  
80107a72:	c3                   	ret    

80107a73 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80107a73:	1e                   	push   %ds
  pushl %es
80107a74:	06                   	push   %es
  pushl %fs
80107a75:	0f a0                	push   %fs
  pushl %gs
80107a77:	0f a8                	push   %gs
  pushal
80107a79:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80107a7a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80107a7e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80107a80:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80107a82:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80107a86:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80107a88:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80107a8a:	54                   	push   %esp
  call trap
80107a8b:	e8 d7 01 00 00       	call   80107c67 <trap>
  addl $4, %esp
80107a90:	83 c4 04             	add    $0x4,%esp

80107a93 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80107a93:	61                   	popa   
  popl %gs
80107a94:	0f a9                	pop    %gs
  popl %fs
80107a96:	0f a1                	pop    %fs
  popl %es
80107a98:	07                   	pop    %es
  popl %ds
80107a99:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107a9a:	83 c4 08             	add    $0x8,%esp
  iret
80107a9d:	cf                   	iret   

80107a9e <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80107a9e:	55                   	push   %ebp
80107a9f:	89 e5                	mov    %esp,%ebp
80107aa1:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
80107aa7:	83 e8 01             	sub    $0x1,%eax
80107aaa:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107aae:	8b 45 08             	mov    0x8(%ebp),%eax
80107ab1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107ab5:	8b 45 08             	mov    0x8(%ebp),%eax
80107ab8:	c1 e8 10             	shr    $0x10,%eax
80107abb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80107abf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107ac2:	0f 01 18             	lidtl  (%eax)
}
80107ac5:	90                   	nop
80107ac6:	c9                   	leave  
80107ac7:	c3                   	ret    

80107ac8 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80107ac8:	55                   	push   %ebp
80107ac9:	89 e5                	mov    %esp,%ebp
80107acb:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107ace:	0f 20 d0             	mov    %cr2,%eax
80107ad1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80107ad4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107ad7:	c9                   	leave  
80107ad8:	c3                   	ret    

80107ad9 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80107ad9:	55                   	push   %ebp
80107ada:	89 e5                	mov    %esp,%ebp
80107adc:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80107adf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107ae6:	e9 c3 00 00 00       	jmp    80107bae <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aee:	8b 04 85 98 d0 10 80 	mov    -0x7fef2f68(,%eax,4),%eax
80107af5:	89 c2                	mov    %eax,%edx
80107af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107afa:	66 89 14 c5 40 69 11 	mov    %dx,-0x7fee96c0(,%eax,8)
80107b01:	80 
80107b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b05:	66 c7 04 c5 42 69 11 	movw   $0x8,-0x7fee96be(,%eax,8)
80107b0c:	80 08 00 
80107b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b12:	0f b6 14 c5 44 69 11 	movzbl -0x7fee96bc(,%eax,8),%edx
80107b19:	80 
80107b1a:	83 e2 e0             	and    $0xffffffe0,%edx
80107b1d:	88 14 c5 44 69 11 80 	mov    %dl,-0x7fee96bc(,%eax,8)
80107b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b27:	0f b6 14 c5 44 69 11 	movzbl -0x7fee96bc(,%eax,8),%edx
80107b2e:	80 
80107b2f:	83 e2 1f             	and    $0x1f,%edx
80107b32:	88 14 c5 44 69 11 80 	mov    %dl,-0x7fee96bc(,%eax,8)
80107b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b3c:	0f b6 14 c5 45 69 11 	movzbl -0x7fee96bb(,%eax,8),%edx
80107b43:	80 
80107b44:	83 e2 f0             	and    $0xfffffff0,%edx
80107b47:	83 ca 0e             	or     $0xe,%edx
80107b4a:	88 14 c5 45 69 11 80 	mov    %dl,-0x7fee96bb(,%eax,8)
80107b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b54:	0f b6 14 c5 45 69 11 	movzbl -0x7fee96bb(,%eax,8),%edx
80107b5b:	80 
80107b5c:	83 e2 ef             	and    $0xffffffef,%edx
80107b5f:	88 14 c5 45 69 11 80 	mov    %dl,-0x7fee96bb(,%eax,8)
80107b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b69:	0f b6 14 c5 45 69 11 	movzbl -0x7fee96bb(,%eax,8),%edx
80107b70:	80 
80107b71:	83 e2 9f             	and    $0xffffff9f,%edx
80107b74:	88 14 c5 45 69 11 80 	mov    %dl,-0x7fee96bb(,%eax,8)
80107b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b7e:	0f b6 14 c5 45 69 11 	movzbl -0x7fee96bb(,%eax,8),%edx
80107b85:	80 
80107b86:	83 ca 80             	or     $0xffffff80,%edx
80107b89:	88 14 c5 45 69 11 80 	mov    %dl,-0x7fee96bb(,%eax,8)
80107b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b93:	8b 04 85 98 d0 10 80 	mov    -0x7fef2f68(,%eax,4),%eax
80107b9a:	c1 e8 10             	shr    $0x10,%eax
80107b9d:	89 c2                	mov    %eax,%edx
80107b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ba2:	66 89 14 c5 46 69 11 	mov    %dx,-0x7fee96ba(,%eax,8)
80107ba9:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80107baa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107bae:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80107bb5:	0f 8e 30 ff ff ff    	jle    80107aeb <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107bbb:	a1 98 d1 10 80       	mov    0x8010d198,%eax
80107bc0:	66 a3 40 6b 11 80    	mov    %ax,0x80116b40
80107bc6:	66 c7 05 42 6b 11 80 	movw   $0x8,0x80116b42
80107bcd:	08 00 
80107bcf:	0f b6 05 44 6b 11 80 	movzbl 0x80116b44,%eax
80107bd6:	83 e0 e0             	and    $0xffffffe0,%eax
80107bd9:	a2 44 6b 11 80       	mov    %al,0x80116b44
80107bde:	0f b6 05 44 6b 11 80 	movzbl 0x80116b44,%eax
80107be5:	83 e0 1f             	and    $0x1f,%eax
80107be8:	a2 44 6b 11 80       	mov    %al,0x80116b44
80107bed:	0f b6 05 45 6b 11 80 	movzbl 0x80116b45,%eax
80107bf4:	83 c8 0f             	or     $0xf,%eax
80107bf7:	a2 45 6b 11 80       	mov    %al,0x80116b45
80107bfc:	0f b6 05 45 6b 11 80 	movzbl 0x80116b45,%eax
80107c03:	83 e0 ef             	and    $0xffffffef,%eax
80107c06:	a2 45 6b 11 80       	mov    %al,0x80116b45
80107c0b:	0f b6 05 45 6b 11 80 	movzbl 0x80116b45,%eax
80107c12:	83 c8 60             	or     $0x60,%eax
80107c15:	a2 45 6b 11 80       	mov    %al,0x80116b45
80107c1a:	0f b6 05 45 6b 11 80 	movzbl 0x80116b45,%eax
80107c21:	83 c8 80             	or     $0xffffff80,%eax
80107c24:	a2 45 6b 11 80       	mov    %al,0x80116b45
80107c29:	a1 98 d1 10 80       	mov    0x8010d198,%eax
80107c2e:	c1 e8 10             	shr    $0x10,%eax
80107c31:	66 a3 46 6b 11 80    	mov    %ax,0x80116b46
  
  initlock(&tickslock, "time");
80107c37:	83 ec 08             	sub    $0x8,%esp
80107c3a:	68 44 a0 10 80       	push   $0x8010a044
80107c3f:	68 00 69 11 80       	push   $0x80116900
80107c44:	e8 8e e6 ff ff       	call   801062d7 <initlock>
80107c49:	83 c4 10             	add    $0x10,%esp
}
80107c4c:	90                   	nop
80107c4d:	c9                   	leave  
80107c4e:	c3                   	ret    

80107c4f <idtinit>:

void
idtinit(void)
{
80107c4f:	55                   	push   %ebp
80107c50:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80107c52:	68 00 08 00 00       	push   $0x800
80107c57:	68 40 69 11 80       	push   $0x80116940
80107c5c:	e8 3d fe ff ff       	call   80107a9e <lidt>
80107c61:	83 c4 08             	add    $0x8,%esp
}
80107c64:	90                   	nop
80107c65:	c9                   	leave  
80107c66:	c3                   	ret    

80107c67 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107c67:	55                   	push   %ebp
80107c68:	89 e5                	mov    %esp,%ebp
80107c6a:	57                   	push   %edi
80107c6b:	56                   	push   %esi
80107c6c:	53                   	push   %ebx
80107c6d:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80107c70:	8b 45 08             	mov    0x8(%ebp),%eax
80107c73:	8b 40 30             	mov    0x30(%eax),%eax
80107c76:	83 f8 40             	cmp    $0x40,%eax
80107c79:	75 3e                	jne    80107cb9 <trap+0x52>
    if(proc->killed)
80107c7b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c81:	8b 40 24             	mov    0x24(%eax),%eax
80107c84:	85 c0                	test   %eax,%eax
80107c86:	74 05                	je     80107c8d <trap+0x26>
      exit();
80107c88:	e8 a6 ce ff ff       	call   80104b33 <exit>
    proc->tf = tf;
80107c8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c93:	8b 55 08             	mov    0x8(%ebp),%edx
80107c96:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80107c99:	e8 8a ed ff ff       	call   80106a28 <syscall>
    if(proc->killed)
80107c9e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ca4:	8b 40 24             	mov    0x24(%eax),%eax
80107ca7:	85 c0                	test   %eax,%eax
80107ca9:	0f 84 1b 02 00 00    	je     80107eca <trap+0x263>
      exit();
80107caf:	e8 7f ce ff ff       	call   80104b33 <exit>
    return;
80107cb4:	e9 11 02 00 00       	jmp    80107eca <trap+0x263>
  }

  switch(tf->trapno){
80107cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80107cbc:	8b 40 30             	mov    0x30(%eax),%eax
80107cbf:	83 e8 20             	sub    $0x20,%eax
80107cc2:	83 f8 1f             	cmp    $0x1f,%eax
80107cc5:	0f 87 c0 00 00 00    	ja     80107d8b <trap+0x124>
80107ccb:	8b 04 85 ec a0 10 80 	mov    -0x7fef5f14(,%eax,4),%eax
80107cd2:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80107cd4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107cda:	0f b6 00             	movzbl (%eax),%eax
80107cdd:	84 c0                	test   %al,%al
80107cdf:	75 3d                	jne    80107d1e <trap+0xb7>
      acquire(&tickslock);
80107ce1:	83 ec 0c             	sub    $0xc,%esp
80107ce4:	68 00 69 11 80       	push   $0x80116900
80107ce9:	e8 0b e6 ff ff       	call   801062f9 <acquire>
80107cee:	83 c4 10             	add    $0x10,%esp
      ticks++;
80107cf1:	a1 40 71 11 80       	mov    0x80117140,%eax
80107cf6:	83 c0 01             	add    $0x1,%eax
80107cf9:	a3 40 71 11 80       	mov    %eax,0x80117140
      wakeup(&ticks);
80107cfe:	83 ec 0c             	sub    $0xc,%esp
80107d01:	68 40 71 11 80       	push   $0x80117140
80107d06:	e8 3c d3 ff ff       	call   80105047 <wakeup>
80107d0b:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80107d0e:	83 ec 0c             	sub    $0xc,%esp
80107d11:	68 00 69 11 80       	push   $0x80116900
80107d16:	e8 45 e6 ff ff       	call   80106360 <release>
80107d1b:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80107d1e:	e8 5b b5 ff ff       	call   8010327e <lapiceoi>
    break;
80107d23:	e9 1c 01 00 00       	jmp    80107e44 <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107d28:	e8 64 ad ff ff       	call   80102a91 <ideintr>
    lapiceoi();
80107d2d:	e8 4c b5 ff ff       	call   8010327e <lapiceoi>
    break;
80107d32:	e9 0d 01 00 00       	jmp    80107e44 <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107d37:	e8 44 b3 ff ff       	call   80103080 <kbdintr>
    lapiceoi();
80107d3c:	e8 3d b5 ff ff       	call   8010327e <lapiceoi>
    break;
80107d41:	e9 fe 00 00 00       	jmp    80107e44 <trap+0x1dd>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107d46:	e8 60 03 00 00       	call   801080ab <uartintr>
    lapiceoi();
80107d4b:	e8 2e b5 ff ff       	call   8010327e <lapiceoi>
    break;
80107d50:	e9 ef 00 00 00       	jmp    80107e44 <trap+0x1dd>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107d55:	8b 45 08             	mov    0x8(%ebp),%eax
80107d58:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107d5b:	8b 45 08             	mov    0x8(%ebp),%eax
80107d5e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107d62:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80107d65:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107d6b:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107d6e:	0f b6 c0             	movzbl %al,%eax
80107d71:	51                   	push   %ecx
80107d72:	52                   	push   %edx
80107d73:	50                   	push   %eax
80107d74:	68 4c a0 10 80       	push   $0x8010a04c
80107d79:	e8 d9 86 ff ff       	call   80100457 <cprintf>
80107d7e:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80107d81:	e8 f8 b4 ff ff       	call   8010327e <lapiceoi>
    break;
80107d86:	e9 b9 00 00 00       	jmp    80107e44 <trap+0x1dd>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107d8b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d91:	85 c0                	test   %eax,%eax
80107d93:	74 11                	je     80107da6 <trap+0x13f>
80107d95:	8b 45 08             	mov    0x8(%ebp),%eax
80107d98:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107d9c:	0f b7 c0             	movzwl %ax,%eax
80107d9f:	83 e0 03             	and    $0x3,%eax
80107da2:	85 c0                	test   %eax,%eax
80107da4:	75 40                	jne    80107de6 <trap+0x17f>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107da6:	e8 1d fd ff ff       	call   80107ac8 <rcr2>
80107dab:	89 c3                	mov    %eax,%ebx
80107dad:	8b 45 08             	mov    0x8(%ebp),%eax
80107db0:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80107db3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107db9:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107dbc:	0f b6 d0             	movzbl %al,%edx
80107dbf:	8b 45 08             	mov    0x8(%ebp),%eax
80107dc2:	8b 40 30             	mov    0x30(%eax),%eax
80107dc5:	83 ec 0c             	sub    $0xc,%esp
80107dc8:	53                   	push   %ebx
80107dc9:	51                   	push   %ecx
80107dca:	52                   	push   %edx
80107dcb:	50                   	push   %eax
80107dcc:	68 70 a0 10 80       	push   $0x8010a070
80107dd1:	e8 81 86 ff ff       	call   80100457 <cprintf>
80107dd6:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80107dd9:	83 ec 0c             	sub    $0xc,%esp
80107ddc:	68 a2 a0 10 80       	push   $0x8010a0a2
80107de1:	e8 11 88 ff ff       	call   801005f7 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107de6:	e8 dd fc ff ff       	call   80107ac8 <rcr2>
80107deb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107dee:	8b 45 08             	mov    0x8(%ebp),%eax
80107df1:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107df4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107dfa:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107dfd:	0f b6 d8             	movzbl %al,%ebx
80107e00:	8b 45 08             	mov    0x8(%ebp),%eax
80107e03:	8b 48 34             	mov    0x34(%eax),%ecx
80107e06:	8b 45 08             	mov    0x8(%ebp),%eax
80107e09:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107e0c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e12:	8d 78 6c             	lea    0x6c(%eax),%edi
80107e15:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107e1b:	8b 40 10             	mov    0x10(%eax),%eax
80107e1e:	ff 75 e4             	pushl  -0x1c(%ebp)
80107e21:	56                   	push   %esi
80107e22:	53                   	push   %ebx
80107e23:	51                   	push   %ecx
80107e24:	52                   	push   %edx
80107e25:	57                   	push   %edi
80107e26:	50                   	push   %eax
80107e27:	68 a8 a0 10 80       	push   $0x8010a0a8
80107e2c:	e8 26 86 ff ff       	call   80100457 <cprintf>
80107e31:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80107e34:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e3a:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107e41:	eb 01                	jmp    80107e44 <trap+0x1dd>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80107e43:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107e44:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e4a:	85 c0                	test   %eax,%eax
80107e4c:	74 24                	je     80107e72 <trap+0x20b>
80107e4e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e54:	8b 40 24             	mov    0x24(%eax),%eax
80107e57:	85 c0                	test   %eax,%eax
80107e59:	74 17                	je     80107e72 <trap+0x20b>
80107e5b:	8b 45 08             	mov    0x8(%ebp),%eax
80107e5e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107e62:	0f b7 c0             	movzwl %ax,%eax
80107e65:	83 e0 03             	and    $0x3,%eax
80107e68:	83 f8 03             	cmp    $0x3,%eax
80107e6b:	75 05                	jne    80107e72 <trap+0x20b>
    exit();
80107e6d:	e8 c1 cc ff ff       	call   80104b33 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80107e72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e78:	85 c0                	test   %eax,%eax
80107e7a:	74 1e                	je     80107e9a <trap+0x233>
80107e7c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e82:	8b 40 0c             	mov    0xc(%eax),%eax
80107e85:	83 f8 04             	cmp    $0x4,%eax
80107e88:	75 10                	jne    80107e9a <trap+0x233>
80107e8a:	8b 45 08             	mov    0x8(%ebp),%eax
80107e8d:	8b 40 30             	mov    0x30(%eax),%eax
80107e90:	83 f8 20             	cmp    $0x20,%eax
80107e93:	75 05                	jne    80107e9a <trap+0x233>
    yield();
80107e95:	e8 56 d0 ff ff       	call   80104ef0 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107e9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ea0:	85 c0                	test   %eax,%eax
80107ea2:	74 27                	je     80107ecb <trap+0x264>
80107ea4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107eaa:	8b 40 24             	mov    0x24(%eax),%eax
80107ead:	85 c0                	test   %eax,%eax
80107eaf:	74 1a                	je     80107ecb <trap+0x264>
80107eb1:	8b 45 08             	mov    0x8(%ebp),%eax
80107eb4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107eb8:	0f b7 c0             	movzwl %ax,%eax
80107ebb:	83 e0 03             	and    $0x3,%eax
80107ebe:	83 f8 03             	cmp    $0x3,%eax
80107ec1:	75 08                	jne    80107ecb <trap+0x264>
    exit();
80107ec3:	e8 6b cc ff ff       	call   80104b33 <exit>
80107ec8:	eb 01                	jmp    80107ecb <trap+0x264>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80107eca:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80107ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ece:	5b                   	pop    %ebx
80107ecf:	5e                   	pop    %esi
80107ed0:	5f                   	pop    %edi
80107ed1:	5d                   	pop    %ebp
80107ed2:	c3                   	ret    

80107ed3 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80107ed3:	55                   	push   %ebp
80107ed4:	89 e5                	mov    %esp,%ebp
80107ed6:	83 ec 14             	sub    $0x14,%esp
80107ed9:	8b 45 08             	mov    0x8(%ebp),%eax
80107edc:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107ee0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107ee4:	89 c2                	mov    %eax,%edx
80107ee6:	ec                   	in     (%dx),%al
80107ee7:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107eea:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107eee:	c9                   	leave  
80107eef:	c3                   	ret    

80107ef0 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107ef0:	55                   	push   %ebp
80107ef1:	89 e5                	mov    %esp,%ebp
80107ef3:	83 ec 08             	sub    $0x8,%esp
80107ef6:	8b 55 08             	mov    0x8(%ebp),%edx
80107ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107efc:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107f00:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107f03:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107f07:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107f0b:	ee                   	out    %al,(%dx)
}
80107f0c:	90                   	nop
80107f0d:	c9                   	leave  
80107f0e:	c3                   	ret    

80107f0f <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107f0f:	55                   	push   %ebp
80107f10:	89 e5                	mov    %esp,%ebp
80107f12:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107f15:	6a 00                	push   $0x0
80107f17:	68 fa 03 00 00       	push   $0x3fa
80107f1c:	e8 cf ff ff ff       	call   80107ef0 <outb>
80107f21:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107f24:	68 80 00 00 00       	push   $0x80
80107f29:	68 fb 03 00 00       	push   $0x3fb
80107f2e:	e8 bd ff ff ff       	call   80107ef0 <outb>
80107f33:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107f36:	6a 0c                	push   $0xc
80107f38:	68 f8 03 00 00       	push   $0x3f8
80107f3d:	e8 ae ff ff ff       	call   80107ef0 <outb>
80107f42:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107f45:	6a 00                	push   $0x0
80107f47:	68 f9 03 00 00       	push   $0x3f9
80107f4c:	e8 9f ff ff ff       	call   80107ef0 <outb>
80107f51:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107f54:	6a 03                	push   $0x3
80107f56:	68 fb 03 00 00       	push   $0x3fb
80107f5b:	e8 90 ff ff ff       	call   80107ef0 <outb>
80107f60:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107f63:	6a 00                	push   $0x0
80107f65:	68 fc 03 00 00       	push   $0x3fc
80107f6a:	e8 81 ff ff ff       	call   80107ef0 <outb>
80107f6f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107f72:	6a 01                	push   $0x1
80107f74:	68 f9 03 00 00       	push   $0x3f9
80107f79:	e8 72 ff ff ff       	call   80107ef0 <outb>
80107f7e:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107f81:	68 fd 03 00 00       	push   $0x3fd
80107f86:	e8 48 ff ff ff       	call   80107ed3 <inb>
80107f8b:	83 c4 04             	add    $0x4,%esp
80107f8e:	3c ff                	cmp    $0xff,%al
80107f90:	74 6e                	je     80108000 <uartinit+0xf1>
    return;
  uart = 1;
80107f92:	c7 05 4c d6 10 80 01 	movl   $0x1,0x8010d64c
80107f99:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107f9c:	68 fa 03 00 00       	push   $0x3fa
80107fa1:	e8 2d ff ff ff       	call   80107ed3 <inb>
80107fa6:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80107fa9:	68 f8 03 00 00       	push   $0x3f8
80107fae:	e8 20 ff ff ff       	call   80107ed3 <inb>
80107fb3:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80107fb6:	83 ec 0c             	sub    $0xc,%esp
80107fb9:	6a 04                	push   $0x4
80107fbb:	e8 d6 c1 ff ff       	call   80104196 <picenable>
80107fc0:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80107fc3:	83 ec 08             	sub    $0x8,%esp
80107fc6:	6a 00                	push   $0x0
80107fc8:	6a 04                	push   $0x4
80107fca:	e8 64 ad ff ff       	call   80102d33 <ioapicenable>
80107fcf:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107fd2:	c7 45 f4 6c a1 10 80 	movl   $0x8010a16c,-0xc(%ebp)
80107fd9:	eb 19                	jmp    80107ff4 <uartinit+0xe5>
    uartputc(*p);
80107fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fde:	0f b6 00             	movzbl (%eax),%eax
80107fe1:	0f be c0             	movsbl %al,%eax
80107fe4:	83 ec 0c             	sub    $0xc,%esp
80107fe7:	50                   	push   %eax
80107fe8:	e8 16 00 00 00       	call   80108003 <uartputc>
80107fed:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107ff0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff7:	0f b6 00             	movzbl (%eax),%eax
80107ffa:	84 c0                	test   %al,%al
80107ffc:	75 dd                	jne    80107fdb <uartinit+0xcc>
80107ffe:	eb 01                	jmp    80108001 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80108000:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80108001:	c9                   	leave  
80108002:	c3                   	ret    

80108003 <uartputc>:

void
uartputc(int c)
{
80108003:	55                   	push   %ebp
80108004:	89 e5                	mov    %esp,%ebp
80108006:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80108009:	a1 4c d6 10 80       	mov    0x8010d64c,%eax
8010800e:	85 c0                	test   %eax,%eax
80108010:	74 53                	je     80108065 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108012:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108019:	eb 11                	jmp    8010802c <uartputc+0x29>
    microdelay(10);
8010801b:	83 ec 0c             	sub    $0xc,%esp
8010801e:	6a 0a                	push   $0xa
80108020:	e8 74 b2 ff ff       	call   80103299 <microdelay>
80108025:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108028:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010802c:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80108030:	7f 1a                	jg     8010804c <uartputc+0x49>
80108032:	83 ec 0c             	sub    $0xc,%esp
80108035:	68 fd 03 00 00       	push   $0x3fd
8010803a:	e8 94 fe ff ff       	call   80107ed3 <inb>
8010803f:	83 c4 10             	add    $0x10,%esp
80108042:	0f b6 c0             	movzbl %al,%eax
80108045:	83 e0 20             	and    $0x20,%eax
80108048:	85 c0                	test   %eax,%eax
8010804a:	74 cf                	je     8010801b <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
8010804c:	8b 45 08             	mov    0x8(%ebp),%eax
8010804f:	0f b6 c0             	movzbl %al,%eax
80108052:	83 ec 08             	sub    $0x8,%esp
80108055:	50                   	push   %eax
80108056:	68 f8 03 00 00       	push   $0x3f8
8010805b:	e8 90 fe ff ff       	call   80107ef0 <outb>
80108060:	83 c4 10             	add    $0x10,%esp
80108063:	eb 01                	jmp    80108066 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80108065:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80108066:	c9                   	leave  
80108067:	c3                   	ret    

80108068 <uartgetc>:

static int
uartgetc(void)
{
80108068:	55                   	push   %ebp
80108069:	89 e5                	mov    %esp,%ebp
  if(!uart)
8010806b:	a1 4c d6 10 80       	mov    0x8010d64c,%eax
80108070:	85 c0                	test   %eax,%eax
80108072:	75 07                	jne    8010807b <uartgetc+0x13>
    return -1;
80108074:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108079:	eb 2e                	jmp    801080a9 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
8010807b:	68 fd 03 00 00       	push   $0x3fd
80108080:	e8 4e fe ff ff       	call   80107ed3 <inb>
80108085:	83 c4 04             	add    $0x4,%esp
80108088:	0f b6 c0             	movzbl %al,%eax
8010808b:	83 e0 01             	and    $0x1,%eax
8010808e:	85 c0                	test   %eax,%eax
80108090:	75 07                	jne    80108099 <uartgetc+0x31>
    return -1;
80108092:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108097:	eb 10                	jmp    801080a9 <uartgetc+0x41>
  return inb(COM1+0);
80108099:	68 f8 03 00 00       	push   $0x3f8
8010809e:	e8 30 fe ff ff       	call   80107ed3 <inb>
801080a3:	83 c4 04             	add    $0x4,%esp
801080a6:	0f b6 c0             	movzbl %al,%eax
}
801080a9:	c9                   	leave  
801080aa:	c3                   	ret    

801080ab <uartintr>:

void
uartintr(void)
{
801080ab:	55                   	push   %ebp
801080ac:	89 e5                	mov    %esp,%ebp
801080ae:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801080b1:	83 ec 0c             	sub    $0xc,%esp
801080b4:	68 68 80 10 80       	push   $0x80108068
801080b9:	e8 b0 87 ff ff       	call   8010086e <consoleintr>
801080be:	83 c4 10             	add    $0x10,%esp
}
801080c1:	90                   	nop
801080c2:	c9                   	leave  
801080c3:	c3                   	ret    

801080c4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801080c4:	6a 00                	push   $0x0
  pushl $0
801080c6:	6a 00                	push   $0x0
  jmp alltraps
801080c8:	e9 a6 f9 ff ff       	jmp    80107a73 <alltraps>

801080cd <vector1>:
.globl vector1
vector1:
  pushl $0
801080cd:	6a 00                	push   $0x0
  pushl $1
801080cf:	6a 01                	push   $0x1
  jmp alltraps
801080d1:	e9 9d f9 ff ff       	jmp    80107a73 <alltraps>

801080d6 <vector2>:
.globl vector2
vector2:
  pushl $0
801080d6:	6a 00                	push   $0x0
  pushl $2
801080d8:	6a 02                	push   $0x2
  jmp alltraps
801080da:	e9 94 f9 ff ff       	jmp    80107a73 <alltraps>

801080df <vector3>:
.globl vector3
vector3:
  pushl $0
801080df:	6a 00                	push   $0x0
  pushl $3
801080e1:	6a 03                	push   $0x3
  jmp alltraps
801080e3:	e9 8b f9 ff ff       	jmp    80107a73 <alltraps>

801080e8 <vector4>:
.globl vector4
vector4:
  pushl $0
801080e8:	6a 00                	push   $0x0
  pushl $4
801080ea:	6a 04                	push   $0x4
  jmp alltraps
801080ec:	e9 82 f9 ff ff       	jmp    80107a73 <alltraps>

801080f1 <vector5>:
.globl vector5
vector5:
  pushl $0
801080f1:	6a 00                	push   $0x0
  pushl $5
801080f3:	6a 05                	push   $0x5
  jmp alltraps
801080f5:	e9 79 f9 ff ff       	jmp    80107a73 <alltraps>

801080fa <vector6>:
.globl vector6
vector6:
  pushl $0
801080fa:	6a 00                	push   $0x0
  pushl $6
801080fc:	6a 06                	push   $0x6
  jmp alltraps
801080fe:	e9 70 f9 ff ff       	jmp    80107a73 <alltraps>

80108103 <vector7>:
.globl vector7
vector7:
  pushl $0
80108103:	6a 00                	push   $0x0
  pushl $7
80108105:	6a 07                	push   $0x7
  jmp alltraps
80108107:	e9 67 f9 ff ff       	jmp    80107a73 <alltraps>

8010810c <vector8>:
.globl vector8
vector8:
  pushl $8
8010810c:	6a 08                	push   $0x8
  jmp alltraps
8010810e:	e9 60 f9 ff ff       	jmp    80107a73 <alltraps>

80108113 <vector9>:
.globl vector9
vector9:
  pushl $0
80108113:	6a 00                	push   $0x0
  pushl $9
80108115:	6a 09                	push   $0x9
  jmp alltraps
80108117:	e9 57 f9 ff ff       	jmp    80107a73 <alltraps>

8010811c <vector10>:
.globl vector10
vector10:
  pushl $10
8010811c:	6a 0a                	push   $0xa
  jmp alltraps
8010811e:	e9 50 f9 ff ff       	jmp    80107a73 <alltraps>

80108123 <vector11>:
.globl vector11
vector11:
  pushl $11
80108123:	6a 0b                	push   $0xb
  jmp alltraps
80108125:	e9 49 f9 ff ff       	jmp    80107a73 <alltraps>

8010812a <vector12>:
.globl vector12
vector12:
  pushl $12
8010812a:	6a 0c                	push   $0xc
  jmp alltraps
8010812c:	e9 42 f9 ff ff       	jmp    80107a73 <alltraps>

80108131 <vector13>:
.globl vector13
vector13:
  pushl $13
80108131:	6a 0d                	push   $0xd
  jmp alltraps
80108133:	e9 3b f9 ff ff       	jmp    80107a73 <alltraps>

80108138 <vector14>:
.globl vector14
vector14:
  pushl $14
80108138:	6a 0e                	push   $0xe
  jmp alltraps
8010813a:	e9 34 f9 ff ff       	jmp    80107a73 <alltraps>

8010813f <vector15>:
.globl vector15
vector15:
  pushl $0
8010813f:	6a 00                	push   $0x0
  pushl $15
80108141:	6a 0f                	push   $0xf
  jmp alltraps
80108143:	e9 2b f9 ff ff       	jmp    80107a73 <alltraps>

80108148 <vector16>:
.globl vector16
vector16:
  pushl $0
80108148:	6a 00                	push   $0x0
  pushl $16
8010814a:	6a 10                	push   $0x10
  jmp alltraps
8010814c:	e9 22 f9 ff ff       	jmp    80107a73 <alltraps>

80108151 <vector17>:
.globl vector17
vector17:
  pushl $17
80108151:	6a 11                	push   $0x11
  jmp alltraps
80108153:	e9 1b f9 ff ff       	jmp    80107a73 <alltraps>

80108158 <vector18>:
.globl vector18
vector18:
  pushl $0
80108158:	6a 00                	push   $0x0
  pushl $18
8010815a:	6a 12                	push   $0x12
  jmp alltraps
8010815c:	e9 12 f9 ff ff       	jmp    80107a73 <alltraps>

80108161 <vector19>:
.globl vector19
vector19:
  pushl $0
80108161:	6a 00                	push   $0x0
  pushl $19
80108163:	6a 13                	push   $0x13
  jmp alltraps
80108165:	e9 09 f9 ff ff       	jmp    80107a73 <alltraps>

8010816a <vector20>:
.globl vector20
vector20:
  pushl $0
8010816a:	6a 00                	push   $0x0
  pushl $20
8010816c:	6a 14                	push   $0x14
  jmp alltraps
8010816e:	e9 00 f9 ff ff       	jmp    80107a73 <alltraps>

80108173 <vector21>:
.globl vector21
vector21:
  pushl $0
80108173:	6a 00                	push   $0x0
  pushl $21
80108175:	6a 15                	push   $0x15
  jmp alltraps
80108177:	e9 f7 f8 ff ff       	jmp    80107a73 <alltraps>

8010817c <vector22>:
.globl vector22
vector22:
  pushl $0
8010817c:	6a 00                	push   $0x0
  pushl $22
8010817e:	6a 16                	push   $0x16
  jmp alltraps
80108180:	e9 ee f8 ff ff       	jmp    80107a73 <alltraps>

80108185 <vector23>:
.globl vector23
vector23:
  pushl $0
80108185:	6a 00                	push   $0x0
  pushl $23
80108187:	6a 17                	push   $0x17
  jmp alltraps
80108189:	e9 e5 f8 ff ff       	jmp    80107a73 <alltraps>

8010818e <vector24>:
.globl vector24
vector24:
  pushl $0
8010818e:	6a 00                	push   $0x0
  pushl $24
80108190:	6a 18                	push   $0x18
  jmp alltraps
80108192:	e9 dc f8 ff ff       	jmp    80107a73 <alltraps>

80108197 <vector25>:
.globl vector25
vector25:
  pushl $0
80108197:	6a 00                	push   $0x0
  pushl $25
80108199:	6a 19                	push   $0x19
  jmp alltraps
8010819b:	e9 d3 f8 ff ff       	jmp    80107a73 <alltraps>

801081a0 <vector26>:
.globl vector26
vector26:
  pushl $0
801081a0:	6a 00                	push   $0x0
  pushl $26
801081a2:	6a 1a                	push   $0x1a
  jmp alltraps
801081a4:	e9 ca f8 ff ff       	jmp    80107a73 <alltraps>

801081a9 <vector27>:
.globl vector27
vector27:
  pushl $0
801081a9:	6a 00                	push   $0x0
  pushl $27
801081ab:	6a 1b                	push   $0x1b
  jmp alltraps
801081ad:	e9 c1 f8 ff ff       	jmp    80107a73 <alltraps>

801081b2 <vector28>:
.globl vector28
vector28:
  pushl $0
801081b2:	6a 00                	push   $0x0
  pushl $28
801081b4:	6a 1c                	push   $0x1c
  jmp alltraps
801081b6:	e9 b8 f8 ff ff       	jmp    80107a73 <alltraps>

801081bb <vector29>:
.globl vector29
vector29:
  pushl $0
801081bb:	6a 00                	push   $0x0
  pushl $29
801081bd:	6a 1d                	push   $0x1d
  jmp alltraps
801081bf:	e9 af f8 ff ff       	jmp    80107a73 <alltraps>

801081c4 <vector30>:
.globl vector30
vector30:
  pushl $0
801081c4:	6a 00                	push   $0x0
  pushl $30
801081c6:	6a 1e                	push   $0x1e
  jmp alltraps
801081c8:	e9 a6 f8 ff ff       	jmp    80107a73 <alltraps>

801081cd <vector31>:
.globl vector31
vector31:
  pushl $0
801081cd:	6a 00                	push   $0x0
  pushl $31
801081cf:	6a 1f                	push   $0x1f
  jmp alltraps
801081d1:	e9 9d f8 ff ff       	jmp    80107a73 <alltraps>

801081d6 <vector32>:
.globl vector32
vector32:
  pushl $0
801081d6:	6a 00                	push   $0x0
  pushl $32
801081d8:	6a 20                	push   $0x20
  jmp alltraps
801081da:	e9 94 f8 ff ff       	jmp    80107a73 <alltraps>

801081df <vector33>:
.globl vector33
vector33:
  pushl $0
801081df:	6a 00                	push   $0x0
  pushl $33
801081e1:	6a 21                	push   $0x21
  jmp alltraps
801081e3:	e9 8b f8 ff ff       	jmp    80107a73 <alltraps>

801081e8 <vector34>:
.globl vector34
vector34:
  pushl $0
801081e8:	6a 00                	push   $0x0
  pushl $34
801081ea:	6a 22                	push   $0x22
  jmp alltraps
801081ec:	e9 82 f8 ff ff       	jmp    80107a73 <alltraps>

801081f1 <vector35>:
.globl vector35
vector35:
  pushl $0
801081f1:	6a 00                	push   $0x0
  pushl $35
801081f3:	6a 23                	push   $0x23
  jmp alltraps
801081f5:	e9 79 f8 ff ff       	jmp    80107a73 <alltraps>

801081fa <vector36>:
.globl vector36
vector36:
  pushl $0
801081fa:	6a 00                	push   $0x0
  pushl $36
801081fc:	6a 24                	push   $0x24
  jmp alltraps
801081fe:	e9 70 f8 ff ff       	jmp    80107a73 <alltraps>

80108203 <vector37>:
.globl vector37
vector37:
  pushl $0
80108203:	6a 00                	push   $0x0
  pushl $37
80108205:	6a 25                	push   $0x25
  jmp alltraps
80108207:	e9 67 f8 ff ff       	jmp    80107a73 <alltraps>

8010820c <vector38>:
.globl vector38
vector38:
  pushl $0
8010820c:	6a 00                	push   $0x0
  pushl $38
8010820e:	6a 26                	push   $0x26
  jmp alltraps
80108210:	e9 5e f8 ff ff       	jmp    80107a73 <alltraps>

80108215 <vector39>:
.globl vector39
vector39:
  pushl $0
80108215:	6a 00                	push   $0x0
  pushl $39
80108217:	6a 27                	push   $0x27
  jmp alltraps
80108219:	e9 55 f8 ff ff       	jmp    80107a73 <alltraps>

8010821e <vector40>:
.globl vector40
vector40:
  pushl $0
8010821e:	6a 00                	push   $0x0
  pushl $40
80108220:	6a 28                	push   $0x28
  jmp alltraps
80108222:	e9 4c f8 ff ff       	jmp    80107a73 <alltraps>

80108227 <vector41>:
.globl vector41
vector41:
  pushl $0
80108227:	6a 00                	push   $0x0
  pushl $41
80108229:	6a 29                	push   $0x29
  jmp alltraps
8010822b:	e9 43 f8 ff ff       	jmp    80107a73 <alltraps>

80108230 <vector42>:
.globl vector42
vector42:
  pushl $0
80108230:	6a 00                	push   $0x0
  pushl $42
80108232:	6a 2a                	push   $0x2a
  jmp alltraps
80108234:	e9 3a f8 ff ff       	jmp    80107a73 <alltraps>

80108239 <vector43>:
.globl vector43
vector43:
  pushl $0
80108239:	6a 00                	push   $0x0
  pushl $43
8010823b:	6a 2b                	push   $0x2b
  jmp alltraps
8010823d:	e9 31 f8 ff ff       	jmp    80107a73 <alltraps>

80108242 <vector44>:
.globl vector44
vector44:
  pushl $0
80108242:	6a 00                	push   $0x0
  pushl $44
80108244:	6a 2c                	push   $0x2c
  jmp alltraps
80108246:	e9 28 f8 ff ff       	jmp    80107a73 <alltraps>

8010824b <vector45>:
.globl vector45
vector45:
  pushl $0
8010824b:	6a 00                	push   $0x0
  pushl $45
8010824d:	6a 2d                	push   $0x2d
  jmp alltraps
8010824f:	e9 1f f8 ff ff       	jmp    80107a73 <alltraps>

80108254 <vector46>:
.globl vector46
vector46:
  pushl $0
80108254:	6a 00                	push   $0x0
  pushl $46
80108256:	6a 2e                	push   $0x2e
  jmp alltraps
80108258:	e9 16 f8 ff ff       	jmp    80107a73 <alltraps>

8010825d <vector47>:
.globl vector47
vector47:
  pushl $0
8010825d:	6a 00                	push   $0x0
  pushl $47
8010825f:	6a 2f                	push   $0x2f
  jmp alltraps
80108261:	e9 0d f8 ff ff       	jmp    80107a73 <alltraps>

80108266 <vector48>:
.globl vector48
vector48:
  pushl $0
80108266:	6a 00                	push   $0x0
  pushl $48
80108268:	6a 30                	push   $0x30
  jmp alltraps
8010826a:	e9 04 f8 ff ff       	jmp    80107a73 <alltraps>

8010826f <vector49>:
.globl vector49
vector49:
  pushl $0
8010826f:	6a 00                	push   $0x0
  pushl $49
80108271:	6a 31                	push   $0x31
  jmp alltraps
80108273:	e9 fb f7 ff ff       	jmp    80107a73 <alltraps>

80108278 <vector50>:
.globl vector50
vector50:
  pushl $0
80108278:	6a 00                	push   $0x0
  pushl $50
8010827a:	6a 32                	push   $0x32
  jmp alltraps
8010827c:	e9 f2 f7 ff ff       	jmp    80107a73 <alltraps>

80108281 <vector51>:
.globl vector51
vector51:
  pushl $0
80108281:	6a 00                	push   $0x0
  pushl $51
80108283:	6a 33                	push   $0x33
  jmp alltraps
80108285:	e9 e9 f7 ff ff       	jmp    80107a73 <alltraps>

8010828a <vector52>:
.globl vector52
vector52:
  pushl $0
8010828a:	6a 00                	push   $0x0
  pushl $52
8010828c:	6a 34                	push   $0x34
  jmp alltraps
8010828e:	e9 e0 f7 ff ff       	jmp    80107a73 <alltraps>

80108293 <vector53>:
.globl vector53
vector53:
  pushl $0
80108293:	6a 00                	push   $0x0
  pushl $53
80108295:	6a 35                	push   $0x35
  jmp alltraps
80108297:	e9 d7 f7 ff ff       	jmp    80107a73 <alltraps>

8010829c <vector54>:
.globl vector54
vector54:
  pushl $0
8010829c:	6a 00                	push   $0x0
  pushl $54
8010829e:	6a 36                	push   $0x36
  jmp alltraps
801082a0:	e9 ce f7 ff ff       	jmp    80107a73 <alltraps>

801082a5 <vector55>:
.globl vector55
vector55:
  pushl $0
801082a5:	6a 00                	push   $0x0
  pushl $55
801082a7:	6a 37                	push   $0x37
  jmp alltraps
801082a9:	e9 c5 f7 ff ff       	jmp    80107a73 <alltraps>

801082ae <vector56>:
.globl vector56
vector56:
  pushl $0
801082ae:	6a 00                	push   $0x0
  pushl $56
801082b0:	6a 38                	push   $0x38
  jmp alltraps
801082b2:	e9 bc f7 ff ff       	jmp    80107a73 <alltraps>

801082b7 <vector57>:
.globl vector57
vector57:
  pushl $0
801082b7:	6a 00                	push   $0x0
  pushl $57
801082b9:	6a 39                	push   $0x39
  jmp alltraps
801082bb:	e9 b3 f7 ff ff       	jmp    80107a73 <alltraps>

801082c0 <vector58>:
.globl vector58
vector58:
  pushl $0
801082c0:	6a 00                	push   $0x0
  pushl $58
801082c2:	6a 3a                	push   $0x3a
  jmp alltraps
801082c4:	e9 aa f7 ff ff       	jmp    80107a73 <alltraps>

801082c9 <vector59>:
.globl vector59
vector59:
  pushl $0
801082c9:	6a 00                	push   $0x0
  pushl $59
801082cb:	6a 3b                	push   $0x3b
  jmp alltraps
801082cd:	e9 a1 f7 ff ff       	jmp    80107a73 <alltraps>

801082d2 <vector60>:
.globl vector60
vector60:
  pushl $0
801082d2:	6a 00                	push   $0x0
  pushl $60
801082d4:	6a 3c                	push   $0x3c
  jmp alltraps
801082d6:	e9 98 f7 ff ff       	jmp    80107a73 <alltraps>

801082db <vector61>:
.globl vector61
vector61:
  pushl $0
801082db:	6a 00                	push   $0x0
  pushl $61
801082dd:	6a 3d                	push   $0x3d
  jmp alltraps
801082df:	e9 8f f7 ff ff       	jmp    80107a73 <alltraps>

801082e4 <vector62>:
.globl vector62
vector62:
  pushl $0
801082e4:	6a 00                	push   $0x0
  pushl $62
801082e6:	6a 3e                	push   $0x3e
  jmp alltraps
801082e8:	e9 86 f7 ff ff       	jmp    80107a73 <alltraps>

801082ed <vector63>:
.globl vector63
vector63:
  pushl $0
801082ed:	6a 00                	push   $0x0
  pushl $63
801082ef:	6a 3f                	push   $0x3f
  jmp alltraps
801082f1:	e9 7d f7 ff ff       	jmp    80107a73 <alltraps>

801082f6 <vector64>:
.globl vector64
vector64:
  pushl $0
801082f6:	6a 00                	push   $0x0
  pushl $64
801082f8:	6a 40                	push   $0x40
  jmp alltraps
801082fa:	e9 74 f7 ff ff       	jmp    80107a73 <alltraps>

801082ff <vector65>:
.globl vector65
vector65:
  pushl $0
801082ff:	6a 00                	push   $0x0
  pushl $65
80108301:	6a 41                	push   $0x41
  jmp alltraps
80108303:	e9 6b f7 ff ff       	jmp    80107a73 <alltraps>

80108308 <vector66>:
.globl vector66
vector66:
  pushl $0
80108308:	6a 00                	push   $0x0
  pushl $66
8010830a:	6a 42                	push   $0x42
  jmp alltraps
8010830c:	e9 62 f7 ff ff       	jmp    80107a73 <alltraps>

80108311 <vector67>:
.globl vector67
vector67:
  pushl $0
80108311:	6a 00                	push   $0x0
  pushl $67
80108313:	6a 43                	push   $0x43
  jmp alltraps
80108315:	e9 59 f7 ff ff       	jmp    80107a73 <alltraps>

8010831a <vector68>:
.globl vector68
vector68:
  pushl $0
8010831a:	6a 00                	push   $0x0
  pushl $68
8010831c:	6a 44                	push   $0x44
  jmp alltraps
8010831e:	e9 50 f7 ff ff       	jmp    80107a73 <alltraps>

80108323 <vector69>:
.globl vector69
vector69:
  pushl $0
80108323:	6a 00                	push   $0x0
  pushl $69
80108325:	6a 45                	push   $0x45
  jmp alltraps
80108327:	e9 47 f7 ff ff       	jmp    80107a73 <alltraps>

8010832c <vector70>:
.globl vector70
vector70:
  pushl $0
8010832c:	6a 00                	push   $0x0
  pushl $70
8010832e:	6a 46                	push   $0x46
  jmp alltraps
80108330:	e9 3e f7 ff ff       	jmp    80107a73 <alltraps>

80108335 <vector71>:
.globl vector71
vector71:
  pushl $0
80108335:	6a 00                	push   $0x0
  pushl $71
80108337:	6a 47                	push   $0x47
  jmp alltraps
80108339:	e9 35 f7 ff ff       	jmp    80107a73 <alltraps>

8010833e <vector72>:
.globl vector72
vector72:
  pushl $0
8010833e:	6a 00                	push   $0x0
  pushl $72
80108340:	6a 48                	push   $0x48
  jmp alltraps
80108342:	e9 2c f7 ff ff       	jmp    80107a73 <alltraps>

80108347 <vector73>:
.globl vector73
vector73:
  pushl $0
80108347:	6a 00                	push   $0x0
  pushl $73
80108349:	6a 49                	push   $0x49
  jmp alltraps
8010834b:	e9 23 f7 ff ff       	jmp    80107a73 <alltraps>

80108350 <vector74>:
.globl vector74
vector74:
  pushl $0
80108350:	6a 00                	push   $0x0
  pushl $74
80108352:	6a 4a                	push   $0x4a
  jmp alltraps
80108354:	e9 1a f7 ff ff       	jmp    80107a73 <alltraps>

80108359 <vector75>:
.globl vector75
vector75:
  pushl $0
80108359:	6a 00                	push   $0x0
  pushl $75
8010835b:	6a 4b                	push   $0x4b
  jmp alltraps
8010835d:	e9 11 f7 ff ff       	jmp    80107a73 <alltraps>

80108362 <vector76>:
.globl vector76
vector76:
  pushl $0
80108362:	6a 00                	push   $0x0
  pushl $76
80108364:	6a 4c                	push   $0x4c
  jmp alltraps
80108366:	e9 08 f7 ff ff       	jmp    80107a73 <alltraps>

8010836b <vector77>:
.globl vector77
vector77:
  pushl $0
8010836b:	6a 00                	push   $0x0
  pushl $77
8010836d:	6a 4d                	push   $0x4d
  jmp alltraps
8010836f:	e9 ff f6 ff ff       	jmp    80107a73 <alltraps>

80108374 <vector78>:
.globl vector78
vector78:
  pushl $0
80108374:	6a 00                	push   $0x0
  pushl $78
80108376:	6a 4e                	push   $0x4e
  jmp alltraps
80108378:	e9 f6 f6 ff ff       	jmp    80107a73 <alltraps>

8010837d <vector79>:
.globl vector79
vector79:
  pushl $0
8010837d:	6a 00                	push   $0x0
  pushl $79
8010837f:	6a 4f                	push   $0x4f
  jmp alltraps
80108381:	e9 ed f6 ff ff       	jmp    80107a73 <alltraps>

80108386 <vector80>:
.globl vector80
vector80:
  pushl $0
80108386:	6a 00                	push   $0x0
  pushl $80
80108388:	6a 50                	push   $0x50
  jmp alltraps
8010838a:	e9 e4 f6 ff ff       	jmp    80107a73 <alltraps>

8010838f <vector81>:
.globl vector81
vector81:
  pushl $0
8010838f:	6a 00                	push   $0x0
  pushl $81
80108391:	6a 51                	push   $0x51
  jmp alltraps
80108393:	e9 db f6 ff ff       	jmp    80107a73 <alltraps>

80108398 <vector82>:
.globl vector82
vector82:
  pushl $0
80108398:	6a 00                	push   $0x0
  pushl $82
8010839a:	6a 52                	push   $0x52
  jmp alltraps
8010839c:	e9 d2 f6 ff ff       	jmp    80107a73 <alltraps>

801083a1 <vector83>:
.globl vector83
vector83:
  pushl $0
801083a1:	6a 00                	push   $0x0
  pushl $83
801083a3:	6a 53                	push   $0x53
  jmp alltraps
801083a5:	e9 c9 f6 ff ff       	jmp    80107a73 <alltraps>

801083aa <vector84>:
.globl vector84
vector84:
  pushl $0
801083aa:	6a 00                	push   $0x0
  pushl $84
801083ac:	6a 54                	push   $0x54
  jmp alltraps
801083ae:	e9 c0 f6 ff ff       	jmp    80107a73 <alltraps>

801083b3 <vector85>:
.globl vector85
vector85:
  pushl $0
801083b3:	6a 00                	push   $0x0
  pushl $85
801083b5:	6a 55                	push   $0x55
  jmp alltraps
801083b7:	e9 b7 f6 ff ff       	jmp    80107a73 <alltraps>

801083bc <vector86>:
.globl vector86
vector86:
  pushl $0
801083bc:	6a 00                	push   $0x0
  pushl $86
801083be:	6a 56                	push   $0x56
  jmp alltraps
801083c0:	e9 ae f6 ff ff       	jmp    80107a73 <alltraps>

801083c5 <vector87>:
.globl vector87
vector87:
  pushl $0
801083c5:	6a 00                	push   $0x0
  pushl $87
801083c7:	6a 57                	push   $0x57
  jmp alltraps
801083c9:	e9 a5 f6 ff ff       	jmp    80107a73 <alltraps>

801083ce <vector88>:
.globl vector88
vector88:
  pushl $0
801083ce:	6a 00                	push   $0x0
  pushl $88
801083d0:	6a 58                	push   $0x58
  jmp alltraps
801083d2:	e9 9c f6 ff ff       	jmp    80107a73 <alltraps>

801083d7 <vector89>:
.globl vector89
vector89:
  pushl $0
801083d7:	6a 00                	push   $0x0
  pushl $89
801083d9:	6a 59                	push   $0x59
  jmp alltraps
801083db:	e9 93 f6 ff ff       	jmp    80107a73 <alltraps>

801083e0 <vector90>:
.globl vector90
vector90:
  pushl $0
801083e0:	6a 00                	push   $0x0
  pushl $90
801083e2:	6a 5a                	push   $0x5a
  jmp alltraps
801083e4:	e9 8a f6 ff ff       	jmp    80107a73 <alltraps>

801083e9 <vector91>:
.globl vector91
vector91:
  pushl $0
801083e9:	6a 00                	push   $0x0
  pushl $91
801083eb:	6a 5b                	push   $0x5b
  jmp alltraps
801083ed:	e9 81 f6 ff ff       	jmp    80107a73 <alltraps>

801083f2 <vector92>:
.globl vector92
vector92:
  pushl $0
801083f2:	6a 00                	push   $0x0
  pushl $92
801083f4:	6a 5c                	push   $0x5c
  jmp alltraps
801083f6:	e9 78 f6 ff ff       	jmp    80107a73 <alltraps>

801083fb <vector93>:
.globl vector93
vector93:
  pushl $0
801083fb:	6a 00                	push   $0x0
  pushl $93
801083fd:	6a 5d                	push   $0x5d
  jmp alltraps
801083ff:	e9 6f f6 ff ff       	jmp    80107a73 <alltraps>

80108404 <vector94>:
.globl vector94
vector94:
  pushl $0
80108404:	6a 00                	push   $0x0
  pushl $94
80108406:	6a 5e                	push   $0x5e
  jmp alltraps
80108408:	e9 66 f6 ff ff       	jmp    80107a73 <alltraps>

8010840d <vector95>:
.globl vector95
vector95:
  pushl $0
8010840d:	6a 00                	push   $0x0
  pushl $95
8010840f:	6a 5f                	push   $0x5f
  jmp alltraps
80108411:	e9 5d f6 ff ff       	jmp    80107a73 <alltraps>

80108416 <vector96>:
.globl vector96
vector96:
  pushl $0
80108416:	6a 00                	push   $0x0
  pushl $96
80108418:	6a 60                	push   $0x60
  jmp alltraps
8010841a:	e9 54 f6 ff ff       	jmp    80107a73 <alltraps>

8010841f <vector97>:
.globl vector97
vector97:
  pushl $0
8010841f:	6a 00                	push   $0x0
  pushl $97
80108421:	6a 61                	push   $0x61
  jmp alltraps
80108423:	e9 4b f6 ff ff       	jmp    80107a73 <alltraps>

80108428 <vector98>:
.globl vector98
vector98:
  pushl $0
80108428:	6a 00                	push   $0x0
  pushl $98
8010842a:	6a 62                	push   $0x62
  jmp alltraps
8010842c:	e9 42 f6 ff ff       	jmp    80107a73 <alltraps>

80108431 <vector99>:
.globl vector99
vector99:
  pushl $0
80108431:	6a 00                	push   $0x0
  pushl $99
80108433:	6a 63                	push   $0x63
  jmp alltraps
80108435:	e9 39 f6 ff ff       	jmp    80107a73 <alltraps>

8010843a <vector100>:
.globl vector100
vector100:
  pushl $0
8010843a:	6a 00                	push   $0x0
  pushl $100
8010843c:	6a 64                	push   $0x64
  jmp alltraps
8010843e:	e9 30 f6 ff ff       	jmp    80107a73 <alltraps>

80108443 <vector101>:
.globl vector101
vector101:
  pushl $0
80108443:	6a 00                	push   $0x0
  pushl $101
80108445:	6a 65                	push   $0x65
  jmp alltraps
80108447:	e9 27 f6 ff ff       	jmp    80107a73 <alltraps>

8010844c <vector102>:
.globl vector102
vector102:
  pushl $0
8010844c:	6a 00                	push   $0x0
  pushl $102
8010844e:	6a 66                	push   $0x66
  jmp alltraps
80108450:	e9 1e f6 ff ff       	jmp    80107a73 <alltraps>

80108455 <vector103>:
.globl vector103
vector103:
  pushl $0
80108455:	6a 00                	push   $0x0
  pushl $103
80108457:	6a 67                	push   $0x67
  jmp alltraps
80108459:	e9 15 f6 ff ff       	jmp    80107a73 <alltraps>

8010845e <vector104>:
.globl vector104
vector104:
  pushl $0
8010845e:	6a 00                	push   $0x0
  pushl $104
80108460:	6a 68                	push   $0x68
  jmp alltraps
80108462:	e9 0c f6 ff ff       	jmp    80107a73 <alltraps>

80108467 <vector105>:
.globl vector105
vector105:
  pushl $0
80108467:	6a 00                	push   $0x0
  pushl $105
80108469:	6a 69                	push   $0x69
  jmp alltraps
8010846b:	e9 03 f6 ff ff       	jmp    80107a73 <alltraps>

80108470 <vector106>:
.globl vector106
vector106:
  pushl $0
80108470:	6a 00                	push   $0x0
  pushl $106
80108472:	6a 6a                	push   $0x6a
  jmp alltraps
80108474:	e9 fa f5 ff ff       	jmp    80107a73 <alltraps>

80108479 <vector107>:
.globl vector107
vector107:
  pushl $0
80108479:	6a 00                	push   $0x0
  pushl $107
8010847b:	6a 6b                	push   $0x6b
  jmp alltraps
8010847d:	e9 f1 f5 ff ff       	jmp    80107a73 <alltraps>

80108482 <vector108>:
.globl vector108
vector108:
  pushl $0
80108482:	6a 00                	push   $0x0
  pushl $108
80108484:	6a 6c                	push   $0x6c
  jmp alltraps
80108486:	e9 e8 f5 ff ff       	jmp    80107a73 <alltraps>

8010848b <vector109>:
.globl vector109
vector109:
  pushl $0
8010848b:	6a 00                	push   $0x0
  pushl $109
8010848d:	6a 6d                	push   $0x6d
  jmp alltraps
8010848f:	e9 df f5 ff ff       	jmp    80107a73 <alltraps>

80108494 <vector110>:
.globl vector110
vector110:
  pushl $0
80108494:	6a 00                	push   $0x0
  pushl $110
80108496:	6a 6e                	push   $0x6e
  jmp alltraps
80108498:	e9 d6 f5 ff ff       	jmp    80107a73 <alltraps>

8010849d <vector111>:
.globl vector111
vector111:
  pushl $0
8010849d:	6a 00                	push   $0x0
  pushl $111
8010849f:	6a 6f                	push   $0x6f
  jmp alltraps
801084a1:	e9 cd f5 ff ff       	jmp    80107a73 <alltraps>

801084a6 <vector112>:
.globl vector112
vector112:
  pushl $0
801084a6:	6a 00                	push   $0x0
  pushl $112
801084a8:	6a 70                	push   $0x70
  jmp alltraps
801084aa:	e9 c4 f5 ff ff       	jmp    80107a73 <alltraps>

801084af <vector113>:
.globl vector113
vector113:
  pushl $0
801084af:	6a 00                	push   $0x0
  pushl $113
801084b1:	6a 71                	push   $0x71
  jmp alltraps
801084b3:	e9 bb f5 ff ff       	jmp    80107a73 <alltraps>

801084b8 <vector114>:
.globl vector114
vector114:
  pushl $0
801084b8:	6a 00                	push   $0x0
  pushl $114
801084ba:	6a 72                	push   $0x72
  jmp alltraps
801084bc:	e9 b2 f5 ff ff       	jmp    80107a73 <alltraps>

801084c1 <vector115>:
.globl vector115
vector115:
  pushl $0
801084c1:	6a 00                	push   $0x0
  pushl $115
801084c3:	6a 73                	push   $0x73
  jmp alltraps
801084c5:	e9 a9 f5 ff ff       	jmp    80107a73 <alltraps>

801084ca <vector116>:
.globl vector116
vector116:
  pushl $0
801084ca:	6a 00                	push   $0x0
  pushl $116
801084cc:	6a 74                	push   $0x74
  jmp alltraps
801084ce:	e9 a0 f5 ff ff       	jmp    80107a73 <alltraps>

801084d3 <vector117>:
.globl vector117
vector117:
  pushl $0
801084d3:	6a 00                	push   $0x0
  pushl $117
801084d5:	6a 75                	push   $0x75
  jmp alltraps
801084d7:	e9 97 f5 ff ff       	jmp    80107a73 <alltraps>

801084dc <vector118>:
.globl vector118
vector118:
  pushl $0
801084dc:	6a 00                	push   $0x0
  pushl $118
801084de:	6a 76                	push   $0x76
  jmp alltraps
801084e0:	e9 8e f5 ff ff       	jmp    80107a73 <alltraps>

801084e5 <vector119>:
.globl vector119
vector119:
  pushl $0
801084e5:	6a 00                	push   $0x0
  pushl $119
801084e7:	6a 77                	push   $0x77
  jmp alltraps
801084e9:	e9 85 f5 ff ff       	jmp    80107a73 <alltraps>

801084ee <vector120>:
.globl vector120
vector120:
  pushl $0
801084ee:	6a 00                	push   $0x0
  pushl $120
801084f0:	6a 78                	push   $0x78
  jmp alltraps
801084f2:	e9 7c f5 ff ff       	jmp    80107a73 <alltraps>

801084f7 <vector121>:
.globl vector121
vector121:
  pushl $0
801084f7:	6a 00                	push   $0x0
  pushl $121
801084f9:	6a 79                	push   $0x79
  jmp alltraps
801084fb:	e9 73 f5 ff ff       	jmp    80107a73 <alltraps>

80108500 <vector122>:
.globl vector122
vector122:
  pushl $0
80108500:	6a 00                	push   $0x0
  pushl $122
80108502:	6a 7a                	push   $0x7a
  jmp alltraps
80108504:	e9 6a f5 ff ff       	jmp    80107a73 <alltraps>

80108509 <vector123>:
.globl vector123
vector123:
  pushl $0
80108509:	6a 00                	push   $0x0
  pushl $123
8010850b:	6a 7b                	push   $0x7b
  jmp alltraps
8010850d:	e9 61 f5 ff ff       	jmp    80107a73 <alltraps>

80108512 <vector124>:
.globl vector124
vector124:
  pushl $0
80108512:	6a 00                	push   $0x0
  pushl $124
80108514:	6a 7c                	push   $0x7c
  jmp alltraps
80108516:	e9 58 f5 ff ff       	jmp    80107a73 <alltraps>

8010851b <vector125>:
.globl vector125
vector125:
  pushl $0
8010851b:	6a 00                	push   $0x0
  pushl $125
8010851d:	6a 7d                	push   $0x7d
  jmp alltraps
8010851f:	e9 4f f5 ff ff       	jmp    80107a73 <alltraps>

80108524 <vector126>:
.globl vector126
vector126:
  pushl $0
80108524:	6a 00                	push   $0x0
  pushl $126
80108526:	6a 7e                	push   $0x7e
  jmp alltraps
80108528:	e9 46 f5 ff ff       	jmp    80107a73 <alltraps>

8010852d <vector127>:
.globl vector127
vector127:
  pushl $0
8010852d:	6a 00                	push   $0x0
  pushl $127
8010852f:	6a 7f                	push   $0x7f
  jmp alltraps
80108531:	e9 3d f5 ff ff       	jmp    80107a73 <alltraps>

80108536 <vector128>:
.globl vector128
vector128:
  pushl $0
80108536:	6a 00                	push   $0x0
  pushl $128
80108538:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010853d:	e9 31 f5 ff ff       	jmp    80107a73 <alltraps>

80108542 <vector129>:
.globl vector129
vector129:
  pushl $0
80108542:	6a 00                	push   $0x0
  pushl $129
80108544:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80108549:	e9 25 f5 ff ff       	jmp    80107a73 <alltraps>

8010854e <vector130>:
.globl vector130
vector130:
  pushl $0
8010854e:	6a 00                	push   $0x0
  pushl $130
80108550:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108555:	e9 19 f5 ff ff       	jmp    80107a73 <alltraps>

8010855a <vector131>:
.globl vector131
vector131:
  pushl $0
8010855a:	6a 00                	push   $0x0
  pushl $131
8010855c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108561:	e9 0d f5 ff ff       	jmp    80107a73 <alltraps>

80108566 <vector132>:
.globl vector132
vector132:
  pushl $0
80108566:	6a 00                	push   $0x0
  pushl $132
80108568:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010856d:	e9 01 f5 ff ff       	jmp    80107a73 <alltraps>

80108572 <vector133>:
.globl vector133
vector133:
  pushl $0
80108572:	6a 00                	push   $0x0
  pushl $133
80108574:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80108579:	e9 f5 f4 ff ff       	jmp    80107a73 <alltraps>

8010857e <vector134>:
.globl vector134
vector134:
  pushl $0
8010857e:	6a 00                	push   $0x0
  pushl $134
80108580:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108585:	e9 e9 f4 ff ff       	jmp    80107a73 <alltraps>

8010858a <vector135>:
.globl vector135
vector135:
  pushl $0
8010858a:	6a 00                	push   $0x0
  pushl $135
8010858c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80108591:	e9 dd f4 ff ff       	jmp    80107a73 <alltraps>

80108596 <vector136>:
.globl vector136
vector136:
  pushl $0
80108596:	6a 00                	push   $0x0
  pushl $136
80108598:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010859d:	e9 d1 f4 ff ff       	jmp    80107a73 <alltraps>

801085a2 <vector137>:
.globl vector137
vector137:
  pushl $0
801085a2:	6a 00                	push   $0x0
  pushl $137
801085a4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801085a9:	e9 c5 f4 ff ff       	jmp    80107a73 <alltraps>

801085ae <vector138>:
.globl vector138
vector138:
  pushl $0
801085ae:	6a 00                	push   $0x0
  pushl $138
801085b0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801085b5:	e9 b9 f4 ff ff       	jmp    80107a73 <alltraps>

801085ba <vector139>:
.globl vector139
vector139:
  pushl $0
801085ba:	6a 00                	push   $0x0
  pushl $139
801085bc:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801085c1:	e9 ad f4 ff ff       	jmp    80107a73 <alltraps>

801085c6 <vector140>:
.globl vector140
vector140:
  pushl $0
801085c6:	6a 00                	push   $0x0
  pushl $140
801085c8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801085cd:	e9 a1 f4 ff ff       	jmp    80107a73 <alltraps>

801085d2 <vector141>:
.globl vector141
vector141:
  pushl $0
801085d2:	6a 00                	push   $0x0
  pushl $141
801085d4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801085d9:	e9 95 f4 ff ff       	jmp    80107a73 <alltraps>

801085de <vector142>:
.globl vector142
vector142:
  pushl $0
801085de:	6a 00                	push   $0x0
  pushl $142
801085e0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801085e5:	e9 89 f4 ff ff       	jmp    80107a73 <alltraps>

801085ea <vector143>:
.globl vector143
vector143:
  pushl $0
801085ea:	6a 00                	push   $0x0
  pushl $143
801085ec:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801085f1:	e9 7d f4 ff ff       	jmp    80107a73 <alltraps>

801085f6 <vector144>:
.globl vector144
vector144:
  pushl $0
801085f6:	6a 00                	push   $0x0
  pushl $144
801085f8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801085fd:	e9 71 f4 ff ff       	jmp    80107a73 <alltraps>

80108602 <vector145>:
.globl vector145
vector145:
  pushl $0
80108602:	6a 00                	push   $0x0
  pushl $145
80108604:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80108609:	e9 65 f4 ff ff       	jmp    80107a73 <alltraps>

8010860e <vector146>:
.globl vector146
vector146:
  pushl $0
8010860e:	6a 00                	push   $0x0
  pushl $146
80108610:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108615:	e9 59 f4 ff ff       	jmp    80107a73 <alltraps>

8010861a <vector147>:
.globl vector147
vector147:
  pushl $0
8010861a:	6a 00                	push   $0x0
  pushl $147
8010861c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108621:	e9 4d f4 ff ff       	jmp    80107a73 <alltraps>

80108626 <vector148>:
.globl vector148
vector148:
  pushl $0
80108626:	6a 00                	push   $0x0
  pushl $148
80108628:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010862d:	e9 41 f4 ff ff       	jmp    80107a73 <alltraps>

80108632 <vector149>:
.globl vector149
vector149:
  pushl $0
80108632:	6a 00                	push   $0x0
  pushl $149
80108634:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80108639:	e9 35 f4 ff ff       	jmp    80107a73 <alltraps>

8010863e <vector150>:
.globl vector150
vector150:
  pushl $0
8010863e:	6a 00                	push   $0x0
  pushl $150
80108640:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108645:	e9 29 f4 ff ff       	jmp    80107a73 <alltraps>

8010864a <vector151>:
.globl vector151
vector151:
  pushl $0
8010864a:	6a 00                	push   $0x0
  pushl $151
8010864c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108651:	e9 1d f4 ff ff       	jmp    80107a73 <alltraps>

80108656 <vector152>:
.globl vector152
vector152:
  pushl $0
80108656:	6a 00                	push   $0x0
  pushl $152
80108658:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010865d:	e9 11 f4 ff ff       	jmp    80107a73 <alltraps>

80108662 <vector153>:
.globl vector153
vector153:
  pushl $0
80108662:	6a 00                	push   $0x0
  pushl $153
80108664:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80108669:	e9 05 f4 ff ff       	jmp    80107a73 <alltraps>

8010866e <vector154>:
.globl vector154
vector154:
  pushl $0
8010866e:	6a 00                	push   $0x0
  pushl $154
80108670:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108675:	e9 f9 f3 ff ff       	jmp    80107a73 <alltraps>

8010867a <vector155>:
.globl vector155
vector155:
  pushl $0
8010867a:	6a 00                	push   $0x0
  pushl $155
8010867c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80108681:	e9 ed f3 ff ff       	jmp    80107a73 <alltraps>

80108686 <vector156>:
.globl vector156
vector156:
  pushl $0
80108686:	6a 00                	push   $0x0
  pushl $156
80108688:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010868d:	e9 e1 f3 ff ff       	jmp    80107a73 <alltraps>

80108692 <vector157>:
.globl vector157
vector157:
  pushl $0
80108692:	6a 00                	push   $0x0
  pushl $157
80108694:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80108699:	e9 d5 f3 ff ff       	jmp    80107a73 <alltraps>

8010869e <vector158>:
.globl vector158
vector158:
  pushl $0
8010869e:	6a 00                	push   $0x0
  pushl $158
801086a0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801086a5:	e9 c9 f3 ff ff       	jmp    80107a73 <alltraps>

801086aa <vector159>:
.globl vector159
vector159:
  pushl $0
801086aa:	6a 00                	push   $0x0
  pushl $159
801086ac:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801086b1:	e9 bd f3 ff ff       	jmp    80107a73 <alltraps>

801086b6 <vector160>:
.globl vector160
vector160:
  pushl $0
801086b6:	6a 00                	push   $0x0
  pushl $160
801086b8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801086bd:	e9 b1 f3 ff ff       	jmp    80107a73 <alltraps>

801086c2 <vector161>:
.globl vector161
vector161:
  pushl $0
801086c2:	6a 00                	push   $0x0
  pushl $161
801086c4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801086c9:	e9 a5 f3 ff ff       	jmp    80107a73 <alltraps>

801086ce <vector162>:
.globl vector162
vector162:
  pushl $0
801086ce:	6a 00                	push   $0x0
  pushl $162
801086d0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801086d5:	e9 99 f3 ff ff       	jmp    80107a73 <alltraps>

801086da <vector163>:
.globl vector163
vector163:
  pushl $0
801086da:	6a 00                	push   $0x0
  pushl $163
801086dc:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801086e1:	e9 8d f3 ff ff       	jmp    80107a73 <alltraps>

801086e6 <vector164>:
.globl vector164
vector164:
  pushl $0
801086e6:	6a 00                	push   $0x0
  pushl $164
801086e8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801086ed:	e9 81 f3 ff ff       	jmp    80107a73 <alltraps>

801086f2 <vector165>:
.globl vector165
vector165:
  pushl $0
801086f2:	6a 00                	push   $0x0
  pushl $165
801086f4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801086f9:	e9 75 f3 ff ff       	jmp    80107a73 <alltraps>

801086fe <vector166>:
.globl vector166
vector166:
  pushl $0
801086fe:	6a 00                	push   $0x0
  pushl $166
80108700:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108705:	e9 69 f3 ff ff       	jmp    80107a73 <alltraps>

8010870a <vector167>:
.globl vector167
vector167:
  pushl $0
8010870a:	6a 00                	push   $0x0
  pushl $167
8010870c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108711:	e9 5d f3 ff ff       	jmp    80107a73 <alltraps>

80108716 <vector168>:
.globl vector168
vector168:
  pushl $0
80108716:	6a 00                	push   $0x0
  pushl $168
80108718:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010871d:	e9 51 f3 ff ff       	jmp    80107a73 <alltraps>

80108722 <vector169>:
.globl vector169
vector169:
  pushl $0
80108722:	6a 00                	push   $0x0
  pushl $169
80108724:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80108729:	e9 45 f3 ff ff       	jmp    80107a73 <alltraps>

8010872e <vector170>:
.globl vector170
vector170:
  pushl $0
8010872e:	6a 00                	push   $0x0
  pushl $170
80108730:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108735:	e9 39 f3 ff ff       	jmp    80107a73 <alltraps>

8010873a <vector171>:
.globl vector171
vector171:
  pushl $0
8010873a:	6a 00                	push   $0x0
  pushl $171
8010873c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108741:	e9 2d f3 ff ff       	jmp    80107a73 <alltraps>

80108746 <vector172>:
.globl vector172
vector172:
  pushl $0
80108746:	6a 00                	push   $0x0
  pushl $172
80108748:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010874d:	e9 21 f3 ff ff       	jmp    80107a73 <alltraps>

80108752 <vector173>:
.globl vector173
vector173:
  pushl $0
80108752:	6a 00                	push   $0x0
  pushl $173
80108754:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80108759:	e9 15 f3 ff ff       	jmp    80107a73 <alltraps>

8010875e <vector174>:
.globl vector174
vector174:
  pushl $0
8010875e:	6a 00                	push   $0x0
  pushl $174
80108760:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108765:	e9 09 f3 ff ff       	jmp    80107a73 <alltraps>

8010876a <vector175>:
.globl vector175
vector175:
  pushl $0
8010876a:	6a 00                	push   $0x0
  pushl $175
8010876c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108771:	e9 fd f2 ff ff       	jmp    80107a73 <alltraps>

80108776 <vector176>:
.globl vector176
vector176:
  pushl $0
80108776:	6a 00                	push   $0x0
  pushl $176
80108778:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010877d:	e9 f1 f2 ff ff       	jmp    80107a73 <alltraps>

80108782 <vector177>:
.globl vector177
vector177:
  pushl $0
80108782:	6a 00                	push   $0x0
  pushl $177
80108784:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80108789:	e9 e5 f2 ff ff       	jmp    80107a73 <alltraps>

8010878e <vector178>:
.globl vector178
vector178:
  pushl $0
8010878e:	6a 00                	push   $0x0
  pushl $178
80108790:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108795:	e9 d9 f2 ff ff       	jmp    80107a73 <alltraps>

8010879a <vector179>:
.globl vector179
vector179:
  pushl $0
8010879a:	6a 00                	push   $0x0
  pushl $179
8010879c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801087a1:	e9 cd f2 ff ff       	jmp    80107a73 <alltraps>

801087a6 <vector180>:
.globl vector180
vector180:
  pushl $0
801087a6:	6a 00                	push   $0x0
  pushl $180
801087a8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801087ad:	e9 c1 f2 ff ff       	jmp    80107a73 <alltraps>

801087b2 <vector181>:
.globl vector181
vector181:
  pushl $0
801087b2:	6a 00                	push   $0x0
  pushl $181
801087b4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801087b9:	e9 b5 f2 ff ff       	jmp    80107a73 <alltraps>

801087be <vector182>:
.globl vector182
vector182:
  pushl $0
801087be:	6a 00                	push   $0x0
  pushl $182
801087c0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801087c5:	e9 a9 f2 ff ff       	jmp    80107a73 <alltraps>

801087ca <vector183>:
.globl vector183
vector183:
  pushl $0
801087ca:	6a 00                	push   $0x0
  pushl $183
801087cc:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801087d1:	e9 9d f2 ff ff       	jmp    80107a73 <alltraps>

801087d6 <vector184>:
.globl vector184
vector184:
  pushl $0
801087d6:	6a 00                	push   $0x0
  pushl $184
801087d8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801087dd:	e9 91 f2 ff ff       	jmp    80107a73 <alltraps>

801087e2 <vector185>:
.globl vector185
vector185:
  pushl $0
801087e2:	6a 00                	push   $0x0
  pushl $185
801087e4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801087e9:	e9 85 f2 ff ff       	jmp    80107a73 <alltraps>

801087ee <vector186>:
.globl vector186
vector186:
  pushl $0
801087ee:	6a 00                	push   $0x0
  pushl $186
801087f0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801087f5:	e9 79 f2 ff ff       	jmp    80107a73 <alltraps>

801087fa <vector187>:
.globl vector187
vector187:
  pushl $0
801087fa:	6a 00                	push   $0x0
  pushl $187
801087fc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108801:	e9 6d f2 ff ff       	jmp    80107a73 <alltraps>

80108806 <vector188>:
.globl vector188
vector188:
  pushl $0
80108806:	6a 00                	push   $0x0
  pushl $188
80108808:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010880d:	e9 61 f2 ff ff       	jmp    80107a73 <alltraps>

80108812 <vector189>:
.globl vector189
vector189:
  pushl $0
80108812:	6a 00                	push   $0x0
  pushl $189
80108814:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80108819:	e9 55 f2 ff ff       	jmp    80107a73 <alltraps>

8010881e <vector190>:
.globl vector190
vector190:
  pushl $0
8010881e:	6a 00                	push   $0x0
  pushl $190
80108820:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108825:	e9 49 f2 ff ff       	jmp    80107a73 <alltraps>

8010882a <vector191>:
.globl vector191
vector191:
  pushl $0
8010882a:	6a 00                	push   $0x0
  pushl $191
8010882c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108831:	e9 3d f2 ff ff       	jmp    80107a73 <alltraps>

80108836 <vector192>:
.globl vector192
vector192:
  pushl $0
80108836:	6a 00                	push   $0x0
  pushl $192
80108838:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010883d:	e9 31 f2 ff ff       	jmp    80107a73 <alltraps>

80108842 <vector193>:
.globl vector193
vector193:
  pushl $0
80108842:	6a 00                	push   $0x0
  pushl $193
80108844:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80108849:	e9 25 f2 ff ff       	jmp    80107a73 <alltraps>

8010884e <vector194>:
.globl vector194
vector194:
  pushl $0
8010884e:	6a 00                	push   $0x0
  pushl $194
80108850:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108855:	e9 19 f2 ff ff       	jmp    80107a73 <alltraps>

8010885a <vector195>:
.globl vector195
vector195:
  pushl $0
8010885a:	6a 00                	push   $0x0
  pushl $195
8010885c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108861:	e9 0d f2 ff ff       	jmp    80107a73 <alltraps>

80108866 <vector196>:
.globl vector196
vector196:
  pushl $0
80108866:	6a 00                	push   $0x0
  pushl $196
80108868:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010886d:	e9 01 f2 ff ff       	jmp    80107a73 <alltraps>

80108872 <vector197>:
.globl vector197
vector197:
  pushl $0
80108872:	6a 00                	push   $0x0
  pushl $197
80108874:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80108879:	e9 f5 f1 ff ff       	jmp    80107a73 <alltraps>

8010887e <vector198>:
.globl vector198
vector198:
  pushl $0
8010887e:	6a 00                	push   $0x0
  pushl $198
80108880:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108885:	e9 e9 f1 ff ff       	jmp    80107a73 <alltraps>

8010888a <vector199>:
.globl vector199
vector199:
  pushl $0
8010888a:	6a 00                	push   $0x0
  pushl $199
8010888c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108891:	e9 dd f1 ff ff       	jmp    80107a73 <alltraps>

80108896 <vector200>:
.globl vector200
vector200:
  pushl $0
80108896:	6a 00                	push   $0x0
  pushl $200
80108898:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010889d:	e9 d1 f1 ff ff       	jmp    80107a73 <alltraps>

801088a2 <vector201>:
.globl vector201
vector201:
  pushl $0
801088a2:	6a 00                	push   $0x0
  pushl $201
801088a4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801088a9:	e9 c5 f1 ff ff       	jmp    80107a73 <alltraps>

801088ae <vector202>:
.globl vector202
vector202:
  pushl $0
801088ae:	6a 00                	push   $0x0
  pushl $202
801088b0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801088b5:	e9 b9 f1 ff ff       	jmp    80107a73 <alltraps>

801088ba <vector203>:
.globl vector203
vector203:
  pushl $0
801088ba:	6a 00                	push   $0x0
  pushl $203
801088bc:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801088c1:	e9 ad f1 ff ff       	jmp    80107a73 <alltraps>

801088c6 <vector204>:
.globl vector204
vector204:
  pushl $0
801088c6:	6a 00                	push   $0x0
  pushl $204
801088c8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801088cd:	e9 a1 f1 ff ff       	jmp    80107a73 <alltraps>

801088d2 <vector205>:
.globl vector205
vector205:
  pushl $0
801088d2:	6a 00                	push   $0x0
  pushl $205
801088d4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801088d9:	e9 95 f1 ff ff       	jmp    80107a73 <alltraps>

801088de <vector206>:
.globl vector206
vector206:
  pushl $0
801088de:	6a 00                	push   $0x0
  pushl $206
801088e0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801088e5:	e9 89 f1 ff ff       	jmp    80107a73 <alltraps>

801088ea <vector207>:
.globl vector207
vector207:
  pushl $0
801088ea:	6a 00                	push   $0x0
  pushl $207
801088ec:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801088f1:	e9 7d f1 ff ff       	jmp    80107a73 <alltraps>

801088f6 <vector208>:
.globl vector208
vector208:
  pushl $0
801088f6:	6a 00                	push   $0x0
  pushl $208
801088f8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801088fd:	e9 71 f1 ff ff       	jmp    80107a73 <alltraps>

80108902 <vector209>:
.globl vector209
vector209:
  pushl $0
80108902:	6a 00                	push   $0x0
  pushl $209
80108904:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80108909:	e9 65 f1 ff ff       	jmp    80107a73 <alltraps>

8010890e <vector210>:
.globl vector210
vector210:
  pushl $0
8010890e:	6a 00                	push   $0x0
  pushl $210
80108910:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108915:	e9 59 f1 ff ff       	jmp    80107a73 <alltraps>

8010891a <vector211>:
.globl vector211
vector211:
  pushl $0
8010891a:	6a 00                	push   $0x0
  pushl $211
8010891c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108921:	e9 4d f1 ff ff       	jmp    80107a73 <alltraps>

80108926 <vector212>:
.globl vector212
vector212:
  pushl $0
80108926:	6a 00                	push   $0x0
  pushl $212
80108928:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010892d:	e9 41 f1 ff ff       	jmp    80107a73 <alltraps>

80108932 <vector213>:
.globl vector213
vector213:
  pushl $0
80108932:	6a 00                	push   $0x0
  pushl $213
80108934:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80108939:	e9 35 f1 ff ff       	jmp    80107a73 <alltraps>

8010893e <vector214>:
.globl vector214
vector214:
  pushl $0
8010893e:	6a 00                	push   $0x0
  pushl $214
80108940:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108945:	e9 29 f1 ff ff       	jmp    80107a73 <alltraps>

8010894a <vector215>:
.globl vector215
vector215:
  pushl $0
8010894a:	6a 00                	push   $0x0
  pushl $215
8010894c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108951:	e9 1d f1 ff ff       	jmp    80107a73 <alltraps>

80108956 <vector216>:
.globl vector216
vector216:
  pushl $0
80108956:	6a 00                	push   $0x0
  pushl $216
80108958:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010895d:	e9 11 f1 ff ff       	jmp    80107a73 <alltraps>

80108962 <vector217>:
.globl vector217
vector217:
  pushl $0
80108962:	6a 00                	push   $0x0
  pushl $217
80108964:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80108969:	e9 05 f1 ff ff       	jmp    80107a73 <alltraps>

8010896e <vector218>:
.globl vector218
vector218:
  pushl $0
8010896e:	6a 00                	push   $0x0
  pushl $218
80108970:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108975:	e9 f9 f0 ff ff       	jmp    80107a73 <alltraps>

8010897a <vector219>:
.globl vector219
vector219:
  pushl $0
8010897a:	6a 00                	push   $0x0
  pushl $219
8010897c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80108981:	e9 ed f0 ff ff       	jmp    80107a73 <alltraps>

80108986 <vector220>:
.globl vector220
vector220:
  pushl $0
80108986:	6a 00                	push   $0x0
  pushl $220
80108988:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010898d:	e9 e1 f0 ff ff       	jmp    80107a73 <alltraps>

80108992 <vector221>:
.globl vector221
vector221:
  pushl $0
80108992:	6a 00                	push   $0x0
  pushl $221
80108994:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80108999:	e9 d5 f0 ff ff       	jmp    80107a73 <alltraps>

8010899e <vector222>:
.globl vector222
vector222:
  pushl $0
8010899e:	6a 00                	push   $0x0
  pushl $222
801089a0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801089a5:	e9 c9 f0 ff ff       	jmp    80107a73 <alltraps>

801089aa <vector223>:
.globl vector223
vector223:
  pushl $0
801089aa:	6a 00                	push   $0x0
  pushl $223
801089ac:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801089b1:	e9 bd f0 ff ff       	jmp    80107a73 <alltraps>

801089b6 <vector224>:
.globl vector224
vector224:
  pushl $0
801089b6:	6a 00                	push   $0x0
  pushl $224
801089b8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801089bd:	e9 b1 f0 ff ff       	jmp    80107a73 <alltraps>

801089c2 <vector225>:
.globl vector225
vector225:
  pushl $0
801089c2:	6a 00                	push   $0x0
  pushl $225
801089c4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801089c9:	e9 a5 f0 ff ff       	jmp    80107a73 <alltraps>

801089ce <vector226>:
.globl vector226
vector226:
  pushl $0
801089ce:	6a 00                	push   $0x0
  pushl $226
801089d0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801089d5:	e9 99 f0 ff ff       	jmp    80107a73 <alltraps>

801089da <vector227>:
.globl vector227
vector227:
  pushl $0
801089da:	6a 00                	push   $0x0
  pushl $227
801089dc:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801089e1:	e9 8d f0 ff ff       	jmp    80107a73 <alltraps>

801089e6 <vector228>:
.globl vector228
vector228:
  pushl $0
801089e6:	6a 00                	push   $0x0
  pushl $228
801089e8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801089ed:	e9 81 f0 ff ff       	jmp    80107a73 <alltraps>

801089f2 <vector229>:
.globl vector229
vector229:
  pushl $0
801089f2:	6a 00                	push   $0x0
  pushl $229
801089f4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801089f9:	e9 75 f0 ff ff       	jmp    80107a73 <alltraps>

801089fe <vector230>:
.globl vector230
vector230:
  pushl $0
801089fe:	6a 00                	push   $0x0
  pushl $230
80108a00:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108a05:	e9 69 f0 ff ff       	jmp    80107a73 <alltraps>

80108a0a <vector231>:
.globl vector231
vector231:
  pushl $0
80108a0a:	6a 00                	push   $0x0
  pushl $231
80108a0c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108a11:	e9 5d f0 ff ff       	jmp    80107a73 <alltraps>

80108a16 <vector232>:
.globl vector232
vector232:
  pushl $0
80108a16:	6a 00                	push   $0x0
  pushl $232
80108a18:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80108a1d:	e9 51 f0 ff ff       	jmp    80107a73 <alltraps>

80108a22 <vector233>:
.globl vector233
vector233:
  pushl $0
80108a22:	6a 00                	push   $0x0
  pushl $233
80108a24:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80108a29:	e9 45 f0 ff ff       	jmp    80107a73 <alltraps>

80108a2e <vector234>:
.globl vector234
vector234:
  pushl $0
80108a2e:	6a 00                	push   $0x0
  pushl $234
80108a30:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108a35:	e9 39 f0 ff ff       	jmp    80107a73 <alltraps>

80108a3a <vector235>:
.globl vector235
vector235:
  pushl $0
80108a3a:	6a 00                	push   $0x0
  pushl $235
80108a3c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108a41:	e9 2d f0 ff ff       	jmp    80107a73 <alltraps>

80108a46 <vector236>:
.globl vector236
vector236:
  pushl $0
80108a46:	6a 00                	push   $0x0
  pushl $236
80108a48:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80108a4d:	e9 21 f0 ff ff       	jmp    80107a73 <alltraps>

80108a52 <vector237>:
.globl vector237
vector237:
  pushl $0
80108a52:	6a 00                	push   $0x0
  pushl $237
80108a54:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80108a59:	e9 15 f0 ff ff       	jmp    80107a73 <alltraps>

80108a5e <vector238>:
.globl vector238
vector238:
  pushl $0
80108a5e:	6a 00                	push   $0x0
  pushl $238
80108a60:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108a65:	e9 09 f0 ff ff       	jmp    80107a73 <alltraps>

80108a6a <vector239>:
.globl vector239
vector239:
  pushl $0
80108a6a:	6a 00                	push   $0x0
  pushl $239
80108a6c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108a71:	e9 fd ef ff ff       	jmp    80107a73 <alltraps>

80108a76 <vector240>:
.globl vector240
vector240:
  pushl $0
80108a76:	6a 00                	push   $0x0
  pushl $240
80108a78:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108a7d:	e9 f1 ef ff ff       	jmp    80107a73 <alltraps>

80108a82 <vector241>:
.globl vector241
vector241:
  pushl $0
80108a82:	6a 00                	push   $0x0
  pushl $241
80108a84:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80108a89:	e9 e5 ef ff ff       	jmp    80107a73 <alltraps>

80108a8e <vector242>:
.globl vector242
vector242:
  pushl $0
80108a8e:	6a 00                	push   $0x0
  pushl $242
80108a90:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108a95:	e9 d9 ef ff ff       	jmp    80107a73 <alltraps>

80108a9a <vector243>:
.globl vector243
vector243:
  pushl $0
80108a9a:	6a 00                	push   $0x0
  pushl $243
80108a9c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108aa1:	e9 cd ef ff ff       	jmp    80107a73 <alltraps>

80108aa6 <vector244>:
.globl vector244
vector244:
  pushl $0
80108aa6:	6a 00                	push   $0x0
  pushl $244
80108aa8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108aad:	e9 c1 ef ff ff       	jmp    80107a73 <alltraps>

80108ab2 <vector245>:
.globl vector245
vector245:
  pushl $0
80108ab2:	6a 00                	push   $0x0
  pushl $245
80108ab4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80108ab9:	e9 b5 ef ff ff       	jmp    80107a73 <alltraps>

80108abe <vector246>:
.globl vector246
vector246:
  pushl $0
80108abe:	6a 00                	push   $0x0
  pushl $246
80108ac0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108ac5:	e9 a9 ef ff ff       	jmp    80107a73 <alltraps>

80108aca <vector247>:
.globl vector247
vector247:
  pushl $0
80108aca:	6a 00                	push   $0x0
  pushl $247
80108acc:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108ad1:	e9 9d ef ff ff       	jmp    80107a73 <alltraps>

80108ad6 <vector248>:
.globl vector248
vector248:
  pushl $0
80108ad6:	6a 00                	push   $0x0
  pushl $248
80108ad8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108add:	e9 91 ef ff ff       	jmp    80107a73 <alltraps>

80108ae2 <vector249>:
.globl vector249
vector249:
  pushl $0
80108ae2:	6a 00                	push   $0x0
  pushl $249
80108ae4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80108ae9:	e9 85 ef ff ff       	jmp    80107a73 <alltraps>

80108aee <vector250>:
.globl vector250
vector250:
  pushl $0
80108aee:	6a 00                	push   $0x0
  pushl $250
80108af0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108af5:	e9 79 ef ff ff       	jmp    80107a73 <alltraps>

80108afa <vector251>:
.globl vector251
vector251:
  pushl $0
80108afa:	6a 00                	push   $0x0
  pushl $251
80108afc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108b01:	e9 6d ef ff ff       	jmp    80107a73 <alltraps>

80108b06 <vector252>:
.globl vector252
vector252:
  pushl $0
80108b06:	6a 00                	push   $0x0
  pushl $252
80108b08:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108b0d:	e9 61 ef ff ff       	jmp    80107a73 <alltraps>

80108b12 <vector253>:
.globl vector253
vector253:
  pushl $0
80108b12:	6a 00                	push   $0x0
  pushl $253
80108b14:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80108b19:	e9 55 ef ff ff       	jmp    80107a73 <alltraps>

80108b1e <vector254>:
.globl vector254
vector254:
  pushl $0
80108b1e:	6a 00                	push   $0x0
  pushl $254
80108b20:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108b25:	e9 49 ef ff ff       	jmp    80107a73 <alltraps>

80108b2a <vector255>:
.globl vector255
vector255:
  pushl $0
80108b2a:	6a 00                	push   $0x0
  pushl $255
80108b2c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108b31:	e9 3d ef ff ff       	jmp    80107a73 <alltraps>

80108b36 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80108b36:	55                   	push   %ebp
80108b37:	89 e5                	mov    %esp,%ebp
80108b39:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80108b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b3f:	83 e8 01             	sub    $0x1,%eax
80108b42:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80108b46:	8b 45 08             	mov    0x8(%ebp),%eax
80108b49:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108b4d:	8b 45 08             	mov    0x8(%ebp),%eax
80108b50:	c1 e8 10             	shr    $0x10,%eax
80108b53:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80108b57:	8d 45 fa             	lea    -0x6(%ebp),%eax
80108b5a:	0f 01 10             	lgdtl  (%eax)
}
80108b5d:	90                   	nop
80108b5e:	c9                   	leave  
80108b5f:	c3                   	ret    

80108b60 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80108b60:	55                   	push   %ebp
80108b61:	89 e5                	mov    %esp,%ebp
80108b63:	83 ec 04             	sub    $0x4,%esp
80108b66:	8b 45 08             	mov    0x8(%ebp),%eax
80108b69:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80108b6d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108b71:	0f 00 d8             	ltr    %ax
}
80108b74:	90                   	nop
80108b75:	c9                   	leave  
80108b76:	c3                   	ret    

80108b77 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80108b77:	55                   	push   %ebp
80108b78:	89 e5                	mov    %esp,%ebp
80108b7a:	83 ec 04             	sub    $0x4,%esp
80108b7d:	8b 45 08             	mov    0x8(%ebp),%eax
80108b80:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80108b84:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108b88:	8e e8                	mov    %eax,%gs
}
80108b8a:	90                   	nop
80108b8b:	c9                   	leave  
80108b8c:	c3                   	ret    

80108b8d <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80108b8d:	55                   	push   %ebp
80108b8e:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108b90:	8b 45 08             	mov    0x8(%ebp),%eax
80108b93:	0f 22 d8             	mov    %eax,%cr3
}
80108b96:	90                   	nop
80108b97:	5d                   	pop    %ebp
80108b98:	c3                   	ret    

80108b99 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80108b99:	55                   	push   %ebp
80108b9a:	89 e5                	mov    %esp,%ebp
80108b9c:	8b 45 08             	mov    0x8(%ebp),%eax
80108b9f:	05 00 00 00 80       	add    $0x80000000,%eax
80108ba4:	5d                   	pop    %ebp
80108ba5:	c3                   	ret    

80108ba6 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80108ba6:	55                   	push   %ebp
80108ba7:	89 e5                	mov    %esp,%ebp
80108ba9:	8b 45 08             	mov    0x8(%ebp),%eax
80108bac:	05 00 00 00 80       	add    $0x80000000,%eax
80108bb1:	5d                   	pop    %ebp
80108bb2:	c3                   	ret    

80108bb3 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80108bb3:	55                   	push   %ebp
80108bb4:	89 e5                	mov    %esp,%ebp
80108bb6:	53                   	push   %ebx
80108bb7:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80108bba:	e8 66 a6 ff ff       	call   80103225 <cpunum>
80108bbf:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80108bc5:	05 c0 43 11 80       	add    $0x801143c0,%eax
80108bca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bd0:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80108bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bd9:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108be2:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108be9:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108bed:	83 e2 f0             	and    $0xfffffff0,%edx
80108bf0:	83 ca 0a             	or     $0xa,%edx
80108bf3:	88 50 7d             	mov    %dl,0x7d(%eax)
80108bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bf9:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108bfd:	83 ca 10             	or     $0x10,%edx
80108c00:	88 50 7d             	mov    %dl,0x7d(%eax)
80108c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c06:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108c0a:	83 e2 9f             	and    $0xffffff9f,%edx
80108c0d:	88 50 7d             	mov    %dl,0x7d(%eax)
80108c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c13:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108c17:	83 ca 80             	or     $0xffffff80,%edx
80108c1a:	88 50 7d             	mov    %dl,0x7d(%eax)
80108c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c20:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108c24:	83 ca 0f             	or     $0xf,%edx
80108c27:	88 50 7e             	mov    %dl,0x7e(%eax)
80108c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c2d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108c31:	83 e2 ef             	and    $0xffffffef,%edx
80108c34:	88 50 7e             	mov    %dl,0x7e(%eax)
80108c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c3a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108c3e:	83 e2 df             	and    $0xffffffdf,%edx
80108c41:	88 50 7e             	mov    %dl,0x7e(%eax)
80108c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c47:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108c4b:	83 ca 40             	or     $0x40,%edx
80108c4e:	88 50 7e             	mov    %dl,0x7e(%eax)
80108c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c54:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108c58:	83 ca 80             	or     $0xffffff80,%edx
80108c5b:	88 50 7e             	mov    %dl,0x7e(%eax)
80108c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c61:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c68:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80108c6f:	ff ff 
80108c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c74:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108c7b:	00 00 
80108c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c80:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c8a:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108c91:	83 e2 f0             	and    $0xfffffff0,%edx
80108c94:	83 ca 02             	or     $0x2,%edx
80108c97:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ca0:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108ca7:	83 ca 10             	or     $0x10,%edx
80108caa:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cb3:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108cba:	83 e2 9f             	and    $0xffffff9f,%edx
80108cbd:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cc6:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108ccd:	83 ca 80             	or     $0xffffff80,%edx
80108cd0:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cd9:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108ce0:	83 ca 0f             	or     $0xf,%edx
80108ce3:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cec:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108cf3:	83 e2 ef             	and    $0xffffffef,%edx
80108cf6:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cff:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d06:	83 e2 df             	and    $0xffffffdf,%edx
80108d09:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d12:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d19:	83 ca 40             	or     $0x40,%edx
80108d1c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d25:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d2c:	83 ca 80             	or     $0xffffff80,%edx
80108d2f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d38:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d42:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108d49:	ff ff 
80108d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d4e:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108d55:	00 00 
80108d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d5a:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d64:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108d6b:	83 e2 f0             	and    $0xfffffff0,%edx
80108d6e:	83 ca 0a             	or     $0xa,%edx
80108d71:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d7a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108d81:	83 ca 10             	or     $0x10,%edx
80108d84:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d8d:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108d94:	83 ca 60             	or     $0x60,%edx
80108d97:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108da0:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108da7:	83 ca 80             	or     $0xffffff80,%edx
80108daa:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108db3:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108dba:	83 ca 0f             	or     $0xf,%edx
80108dbd:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dc6:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108dcd:	83 e2 ef             	and    $0xffffffef,%edx
80108dd0:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dd9:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108de0:	83 e2 df             	and    $0xffffffdf,%edx
80108de3:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dec:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108df3:	83 ca 40             	or     $0x40,%edx
80108df6:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dff:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e06:	83 ca 80             	or     $0xffffff80,%edx
80108e09:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e12:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e1c:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80108e23:	ff ff 
80108e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e28:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108e2f:	00 00 
80108e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e34:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e3e:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108e45:	83 e2 f0             	and    $0xfffffff0,%edx
80108e48:	83 ca 02             	or     $0x2,%edx
80108e4b:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e54:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108e5b:	83 ca 10             	or     $0x10,%edx
80108e5e:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e67:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108e6e:	83 ca 60             	or     $0x60,%edx
80108e71:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e7a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108e81:	83 ca 80             	or     $0xffffff80,%edx
80108e84:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e8d:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108e94:	83 ca 0f             	or     $0xf,%edx
80108e97:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ea0:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108ea7:	83 e2 ef             	and    $0xffffffef,%edx
80108eaa:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eb3:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108eba:	83 e2 df             	and    $0xffffffdf,%edx
80108ebd:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ec6:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108ecd:	83 ca 40             	or     $0x40,%edx
80108ed0:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ed9:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108ee0:	83 ca 80             	or     $0xffffff80,%edx
80108ee3:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eec:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ef6:	05 b4 00 00 00       	add    $0xb4,%eax
80108efb:	89 c3                	mov    %eax,%ebx
80108efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f00:	05 b4 00 00 00       	add    $0xb4,%eax
80108f05:	c1 e8 10             	shr    $0x10,%eax
80108f08:	89 c2                	mov    %eax,%edx
80108f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f0d:	05 b4 00 00 00       	add    $0xb4,%eax
80108f12:	c1 e8 18             	shr    $0x18,%eax
80108f15:	89 c1                	mov    %eax,%ecx
80108f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f1a:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108f21:	00 00 
80108f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f26:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f30:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80108f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f39:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108f40:	83 e2 f0             	and    $0xfffffff0,%edx
80108f43:	83 ca 02             	or     $0x2,%edx
80108f46:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f4f:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108f56:	83 ca 10             	or     $0x10,%edx
80108f59:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f62:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108f69:	83 e2 9f             	and    $0xffffff9f,%edx
80108f6c:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f75:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108f7c:	83 ca 80             	or     $0xffffff80,%edx
80108f7f:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f88:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108f8f:	83 e2 f0             	and    $0xfffffff0,%edx
80108f92:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f9b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108fa2:	83 e2 ef             	and    $0xffffffef,%edx
80108fa5:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fae:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108fb5:	83 e2 df             	and    $0xffffffdf,%edx
80108fb8:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fc1:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108fc8:	83 ca 40             	or     $0x40,%edx
80108fcb:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fd4:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108fdb:	83 ca 80             	or     $0xffffff80,%edx
80108fde:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fe7:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ff0:	83 c0 70             	add    $0x70,%eax
80108ff3:	83 ec 08             	sub    $0x8,%esp
80108ff6:	6a 38                	push   $0x38
80108ff8:	50                   	push   %eax
80108ff9:	e8 38 fb ff ff       	call   80108b36 <lgdt>
80108ffe:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80109001:	83 ec 0c             	sub    $0xc,%esp
80109004:	6a 18                	push   $0x18
80109006:	e8 6c fb ff ff       	call   80108b77 <loadgs>
8010900b:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
8010900e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109011:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80109017:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010901e:	00 00 00 00 
}
80109022:	90                   	nop
80109023:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109026:	c9                   	leave  
80109027:	c3                   	ret    

80109028 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80109028:	55                   	push   %ebp
80109029:	89 e5                	mov    %esp,%ebp
8010902b:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010902e:	8b 45 0c             	mov    0xc(%ebp),%eax
80109031:	c1 e8 16             	shr    $0x16,%eax
80109034:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010903b:	8b 45 08             	mov    0x8(%ebp),%eax
8010903e:	01 d0                	add    %edx,%eax
80109040:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80109043:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109046:	8b 00                	mov    (%eax),%eax
80109048:	83 e0 01             	and    $0x1,%eax
8010904b:	85 c0                	test   %eax,%eax
8010904d:	74 18                	je     80109067 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
8010904f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109052:	8b 00                	mov    (%eax),%eax
80109054:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109059:	50                   	push   %eax
8010905a:	e8 47 fb ff ff       	call   80108ba6 <p2v>
8010905f:	83 c4 04             	add    $0x4,%esp
80109062:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109065:	eb 48                	jmp    801090af <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80109067:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010906b:	74 0e                	je     8010907b <walkpgdir+0x53>
8010906d:	e8 4d 9e ff ff       	call   80102ebf <kalloc>
80109072:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109075:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109079:	75 07                	jne    80109082 <walkpgdir+0x5a>
      return 0;
8010907b:	b8 00 00 00 00       	mov    $0x0,%eax
80109080:	eb 44                	jmp    801090c6 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80109082:	83 ec 04             	sub    $0x4,%esp
80109085:	68 00 10 00 00       	push   $0x1000
8010908a:	6a 00                	push   $0x0
8010908c:	ff 75 f4             	pushl  -0xc(%ebp)
8010908f:	e8 c8 d4 ff ff       	call   8010655c <memset>
80109094:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80109097:	83 ec 0c             	sub    $0xc,%esp
8010909a:	ff 75 f4             	pushl  -0xc(%ebp)
8010909d:	e8 f7 fa ff ff       	call   80108b99 <v2p>
801090a2:	83 c4 10             	add    $0x10,%esp
801090a5:	83 c8 07             	or     $0x7,%eax
801090a8:	89 c2                	mov    %eax,%edx
801090aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090ad:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801090af:	8b 45 0c             	mov    0xc(%ebp),%eax
801090b2:	c1 e8 0c             	shr    $0xc,%eax
801090b5:	25 ff 03 00 00       	and    $0x3ff,%eax
801090ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801090c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090c4:	01 d0                	add    %edx,%eax
}
801090c6:	c9                   	leave  
801090c7:	c3                   	ret    

801090c8 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801090c8:	55                   	push   %ebp
801090c9:	89 e5                	mov    %esp,%ebp
801090cb:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801090ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801090d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801090d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801090d9:	8b 55 0c             	mov    0xc(%ebp),%edx
801090dc:	8b 45 10             	mov    0x10(%ebp),%eax
801090df:	01 d0                	add    %edx,%eax
801090e1:	83 e8 01             	sub    $0x1,%eax
801090e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801090e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801090ec:	83 ec 04             	sub    $0x4,%esp
801090ef:	6a 01                	push   $0x1
801090f1:	ff 75 f4             	pushl  -0xc(%ebp)
801090f4:	ff 75 08             	pushl  0x8(%ebp)
801090f7:	e8 2c ff ff ff       	call   80109028 <walkpgdir>
801090fc:	83 c4 10             	add    $0x10,%esp
801090ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109102:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109106:	75 07                	jne    8010910f <mappages+0x47>
      return -1;
80109108:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010910d:	eb 47                	jmp    80109156 <mappages+0x8e>
    if(*pte & PTE_P)
8010910f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109112:	8b 00                	mov    (%eax),%eax
80109114:	83 e0 01             	and    $0x1,%eax
80109117:	85 c0                	test   %eax,%eax
80109119:	74 0d                	je     80109128 <mappages+0x60>
      panic("remap");
8010911b:	83 ec 0c             	sub    $0xc,%esp
8010911e:	68 74 a1 10 80       	push   $0x8010a174
80109123:	e8 cf 74 ff ff       	call   801005f7 <panic>
    *pte = pa | perm | PTE_P;
80109128:	8b 45 18             	mov    0x18(%ebp),%eax
8010912b:	0b 45 14             	or     0x14(%ebp),%eax
8010912e:	83 c8 01             	or     $0x1,%eax
80109131:	89 c2                	mov    %eax,%edx
80109133:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109136:	89 10                	mov    %edx,(%eax)
    if(a == last)
80109138:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010913b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010913e:	74 10                	je     80109150 <mappages+0x88>
      break;
    a += PGSIZE;
80109140:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80109147:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010914e:	eb 9c                	jmp    801090ec <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80109150:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80109151:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109156:	c9                   	leave  
80109157:	c3                   	ret    

80109158 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80109158:	55                   	push   %ebp
80109159:	89 e5                	mov    %esp,%ebp
8010915b:	53                   	push   %ebx
8010915c:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
8010915f:	e8 5b 9d ff ff       	call   80102ebf <kalloc>
80109164:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109167:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010916b:	75 0a                	jne    80109177 <setupkvm+0x1f>
    return 0;
8010916d:	b8 00 00 00 00       	mov    $0x0,%eax
80109172:	e9 8e 00 00 00       	jmp    80109205 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80109177:	83 ec 04             	sub    $0x4,%esp
8010917a:	68 00 10 00 00       	push   $0x1000
8010917f:	6a 00                	push   $0x0
80109181:	ff 75 f0             	pushl  -0x10(%ebp)
80109184:	e8 d3 d3 ff ff       	call   8010655c <memset>
80109189:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
8010918c:	83 ec 0c             	sub    $0xc,%esp
8010918f:	68 00 00 00 0e       	push   $0xe000000
80109194:	e8 0d fa ff ff       	call   80108ba6 <p2v>
80109199:	83 c4 10             	add    $0x10,%esp
8010919c:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801091a1:	76 0d                	jbe    801091b0 <setupkvm+0x58>
    panic("PHYSTOP too high");
801091a3:	83 ec 0c             	sub    $0xc,%esp
801091a6:	68 7a a1 10 80       	push   $0x8010a17a
801091ab:	e8 47 74 ff ff       	call   801005f7 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801091b0:	c7 45 f4 a0 d4 10 80 	movl   $0x8010d4a0,-0xc(%ebp)
801091b7:	eb 40                	jmp    801091f9 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801091b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091bc:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801091bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091c2:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801091c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091c8:	8b 58 08             	mov    0x8(%eax),%ebx
801091cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091ce:	8b 40 04             	mov    0x4(%eax),%eax
801091d1:	29 c3                	sub    %eax,%ebx
801091d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091d6:	8b 00                	mov    (%eax),%eax
801091d8:	83 ec 0c             	sub    $0xc,%esp
801091db:	51                   	push   %ecx
801091dc:	52                   	push   %edx
801091dd:	53                   	push   %ebx
801091de:	50                   	push   %eax
801091df:	ff 75 f0             	pushl  -0x10(%ebp)
801091e2:	e8 e1 fe ff ff       	call   801090c8 <mappages>
801091e7:	83 c4 20             	add    $0x20,%esp
801091ea:	85 c0                	test   %eax,%eax
801091ec:	79 07                	jns    801091f5 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
801091ee:	b8 00 00 00 00       	mov    $0x0,%eax
801091f3:	eb 10                	jmp    80109205 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801091f5:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801091f9:	81 7d f4 e0 d4 10 80 	cmpl   $0x8010d4e0,-0xc(%ebp)
80109200:	72 b7                	jb     801091b9 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80109202:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80109205:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109208:	c9                   	leave  
80109209:	c3                   	ret    

8010920a <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010920a:	55                   	push   %ebp
8010920b:	89 e5                	mov    %esp,%ebp
8010920d:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80109210:	e8 43 ff ff ff       	call   80109158 <setupkvm>
80109215:	a3 98 71 11 80       	mov    %eax,0x80117198
  switchkvm();
8010921a:	e8 03 00 00 00       	call   80109222 <switchkvm>
}
8010921f:	90                   	nop
80109220:	c9                   	leave  
80109221:	c3                   	ret    

80109222 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80109222:	55                   	push   %ebp
80109223:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80109225:	a1 98 71 11 80       	mov    0x80117198,%eax
8010922a:	50                   	push   %eax
8010922b:	e8 69 f9 ff ff       	call   80108b99 <v2p>
80109230:	83 c4 04             	add    $0x4,%esp
80109233:	50                   	push   %eax
80109234:	e8 54 f9 ff ff       	call   80108b8d <lcr3>
80109239:	83 c4 04             	add    $0x4,%esp
}
8010923c:	90                   	nop
8010923d:	c9                   	leave  
8010923e:	c3                   	ret    

8010923f <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010923f:	55                   	push   %ebp
80109240:	89 e5                	mov    %esp,%ebp
80109242:	56                   	push   %esi
80109243:	53                   	push   %ebx
  pushcli();
80109244:	e8 0d d2 ff ff       	call   80106456 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80109249:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010924f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109256:	83 c2 08             	add    $0x8,%edx
80109259:	89 d6                	mov    %edx,%esi
8010925b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109262:	83 c2 08             	add    $0x8,%edx
80109265:	c1 ea 10             	shr    $0x10,%edx
80109268:	89 d3                	mov    %edx,%ebx
8010926a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109271:	83 c2 08             	add    $0x8,%edx
80109274:	c1 ea 18             	shr    $0x18,%edx
80109277:	89 d1                	mov    %edx,%ecx
80109279:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80109280:	67 00 
80109282:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80109289:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
8010928f:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109296:	83 e2 f0             	and    $0xfffffff0,%edx
80109299:	83 ca 09             	or     $0x9,%edx
8010929c:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801092a2:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801092a9:	83 ca 10             	or     $0x10,%edx
801092ac:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801092b2:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801092b9:	83 e2 9f             	and    $0xffffff9f,%edx
801092bc:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801092c2:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801092c9:	83 ca 80             	or     $0xffffff80,%edx
801092cc:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801092d2:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801092d9:	83 e2 f0             	and    $0xfffffff0,%edx
801092dc:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801092e2:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801092e9:	83 e2 ef             	and    $0xffffffef,%edx
801092ec:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801092f2:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801092f9:	83 e2 df             	and    $0xffffffdf,%edx
801092fc:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109302:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109309:	83 ca 40             	or     $0x40,%edx
8010930c:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109312:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109319:	83 e2 7f             	and    $0x7f,%edx
8010931c:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109322:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80109328:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010932e:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109335:	83 e2 ef             	and    $0xffffffef,%edx
80109338:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
8010933e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109344:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
8010934a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109350:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80109357:	8b 52 08             	mov    0x8(%edx),%edx
8010935a:	81 c2 00 10 00 00    	add    $0x1000,%edx
80109360:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80109363:	83 ec 0c             	sub    $0xc,%esp
80109366:	6a 30                	push   $0x30
80109368:	e8 f3 f7 ff ff       	call   80108b60 <ltr>
8010936d:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80109370:	8b 45 08             	mov    0x8(%ebp),%eax
80109373:	8b 40 04             	mov    0x4(%eax),%eax
80109376:	85 c0                	test   %eax,%eax
80109378:	75 0d                	jne    80109387 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
8010937a:	83 ec 0c             	sub    $0xc,%esp
8010937d:	68 8b a1 10 80       	push   $0x8010a18b
80109382:	e8 70 72 ff ff       	call   801005f7 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80109387:	8b 45 08             	mov    0x8(%ebp),%eax
8010938a:	8b 40 04             	mov    0x4(%eax),%eax
8010938d:	83 ec 0c             	sub    $0xc,%esp
80109390:	50                   	push   %eax
80109391:	e8 03 f8 ff ff       	call   80108b99 <v2p>
80109396:	83 c4 10             	add    $0x10,%esp
80109399:	83 ec 0c             	sub    $0xc,%esp
8010939c:	50                   	push   %eax
8010939d:	e8 eb f7 ff ff       	call   80108b8d <lcr3>
801093a2:	83 c4 10             	add    $0x10,%esp
  popcli();
801093a5:	e8 f1 d0 ff ff       	call   8010649b <popcli>
}
801093aa:	90                   	nop
801093ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
801093ae:	5b                   	pop    %ebx
801093af:	5e                   	pop    %esi
801093b0:	5d                   	pop    %ebp
801093b1:	c3                   	ret    

801093b2 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801093b2:	55                   	push   %ebp
801093b3:	89 e5                	mov    %esp,%ebp
801093b5:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801093b8:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801093bf:	76 0d                	jbe    801093ce <inituvm+0x1c>
    panic("inituvm: more than a page");
801093c1:	83 ec 0c             	sub    $0xc,%esp
801093c4:	68 9f a1 10 80       	push   $0x8010a19f
801093c9:	e8 29 72 ff ff       	call   801005f7 <panic>
  mem = kalloc();
801093ce:	e8 ec 9a ff ff       	call   80102ebf <kalloc>
801093d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801093d6:	83 ec 04             	sub    $0x4,%esp
801093d9:	68 00 10 00 00       	push   $0x1000
801093de:	6a 00                	push   $0x0
801093e0:	ff 75 f4             	pushl  -0xc(%ebp)
801093e3:	e8 74 d1 ff ff       	call   8010655c <memset>
801093e8:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801093eb:	83 ec 0c             	sub    $0xc,%esp
801093ee:	ff 75 f4             	pushl  -0xc(%ebp)
801093f1:	e8 a3 f7 ff ff       	call   80108b99 <v2p>
801093f6:	83 c4 10             	add    $0x10,%esp
801093f9:	83 ec 0c             	sub    $0xc,%esp
801093fc:	6a 06                	push   $0x6
801093fe:	50                   	push   %eax
801093ff:	68 00 10 00 00       	push   $0x1000
80109404:	6a 00                	push   $0x0
80109406:	ff 75 08             	pushl  0x8(%ebp)
80109409:	e8 ba fc ff ff       	call   801090c8 <mappages>
8010940e:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80109411:	83 ec 04             	sub    $0x4,%esp
80109414:	ff 75 10             	pushl  0x10(%ebp)
80109417:	ff 75 0c             	pushl  0xc(%ebp)
8010941a:	ff 75 f4             	pushl  -0xc(%ebp)
8010941d:	e8 f9 d1 ff ff       	call   8010661b <memmove>
80109422:	83 c4 10             	add    $0x10,%esp
}
80109425:	90                   	nop
80109426:	c9                   	leave  
80109427:	c3                   	ret    

80109428 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80109428:	55                   	push   %ebp
80109429:	89 e5                	mov    %esp,%ebp
8010942b:	53                   	push   %ebx
8010942c:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010942f:	8b 45 0c             	mov    0xc(%ebp),%eax
80109432:	25 ff 0f 00 00       	and    $0xfff,%eax
80109437:	85 c0                	test   %eax,%eax
80109439:	74 0d                	je     80109448 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
8010943b:	83 ec 0c             	sub    $0xc,%esp
8010943e:	68 bc a1 10 80       	push   $0x8010a1bc
80109443:	e8 af 71 ff ff       	call   801005f7 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80109448:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010944f:	e9 95 00 00 00       	jmp    801094e9 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80109454:	8b 55 0c             	mov    0xc(%ebp),%edx
80109457:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010945a:	01 d0                	add    %edx,%eax
8010945c:	83 ec 04             	sub    $0x4,%esp
8010945f:	6a 00                	push   $0x0
80109461:	50                   	push   %eax
80109462:	ff 75 08             	pushl  0x8(%ebp)
80109465:	e8 be fb ff ff       	call   80109028 <walkpgdir>
8010946a:	83 c4 10             	add    $0x10,%esp
8010946d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109470:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109474:	75 0d                	jne    80109483 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80109476:	83 ec 0c             	sub    $0xc,%esp
80109479:	68 df a1 10 80       	push   $0x8010a1df
8010947e:	e8 74 71 ff ff       	call   801005f7 <panic>
    pa = PTE_ADDR(*pte);
80109483:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109486:	8b 00                	mov    (%eax),%eax
80109488:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010948d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80109490:	8b 45 18             	mov    0x18(%ebp),%eax
80109493:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109496:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010949b:	77 0b                	ja     801094a8 <loaduvm+0x80>
      n = sz - i;
8010949d:	8b 45 18             	mov    0x18(%ebp),%eax
801094a0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801094a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801094a6:	eb 07                	jmp    801094af <loaduvm+0x87>
    else
      n = PGSIZE;
801094a8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801094af:	8b 55 14             	mov    0x14(%ebp),%edx
801094b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094b5:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801094b8:	83 ec 0c             	sub    $0xc,%esp
801094bb:	ff 75 e8             	pushl  -0x18(%ebp)
801094be:	e8 e3 f6 ff ff       	call   80108ba6 <p2v>
801094c3:	83 c4 10             	add    $0x10,%esp
801094c6:	ff 75 f0             	pushl  -0x10(%ebp)
801094c9:	53                   	push   %ebx
801094ca:	50                   	push   %eax
801094cb:	ff 75 10             	pushl  0x10(%ebp)
801094ce:	e8 66 8a ff ff       	call   80101f39 <readi>
801094d3:	83 c4 10             	add    $0x10,%esp
801094d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801094d9:	74 07                	je     801094e2 <loaduvm+0xba>
      return -1;
801094db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801094e0:	eb 18                	jmp    801094fa <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801094e2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801094e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094ec:	3b 45 18             	cmp    0x18(%ebp),%eax
801094ef:	0f 82 5f ff ff ff    	jb     80109454 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801094f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801094fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801094fd:	c9                   	leave  
801094fe:	c3                   	ret    

801094ff <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801094ff:	55                   	push   %ebp
80109500:	89 e5                	mov    %esp,%ebp
80109502:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80109505:	8b 45 10             	mov    0x10(%ebp),%eax
80109508:	85 c0                	test   %eax,%eax
8010950a:	79 0a                	jns    80109516 <allocuvm+0x17>
    return 0;
8010950c:	b8 00 00 00 00       	mov    $0x0,%eax
80109511:	e9 b0 00 00 00       	jmp    801095c6 <allocuvm+0xc7>
  if(newsz < oldsz)
80109516:	8b 45 10             	mov    0x10(%ebp),%eax
80109519:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010951c:	73 08                	jae    80109526 <allocuvm+0x27>
    return oldsz;
8010951e:	8b 45 0c             	mov    0xc(%ebp),%eax
80109521:	e9 a0 00 00 00       	jmp    801095c6 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80109526:	8b 45 0c             	mov    0xc(%ebp),%eax
80109529:	05 ff 0f 00 00       	add    $0xfff,%eax
8010952e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109533:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80109536:	eb 7f                	jmp    801095b7 <allocuvm+0xb8>
    mem = kalloc();
80109538:	e8 82 99 ff ff       	call   80102ebf <kalloc>
8010953d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80109540:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109544:	75 2b                	jne    80109571 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80109546:	83 ec 0c             	sub    $0xc,%esp
80109549:	68 fd a1 10 80       	push   $0x8010a1fd
8010954e:	e8 04 6f ff ff       	call   80100457 <cprintf>
80109553:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80109556:	83 ec 04             	sub    $0x4,%esp
80109559:	ff 75 0c             	pushl  0xc(%ebp)
8010955c:	ff 75 10             	pushl  0x10(%ebp)
8010955f:	ff 75 08             	pushl  0x8(%ebp)
80109562:	e8 61 00 00 00       	call   801095c8 <deallocuvm>
80109567:	83 c4 10             	add    $0x10,%esp
      return 0;
8010956a:	b8 00 00 00 00       	mov    $0x0,%eax
8010956f:	eb 55                	jmp    801095c6 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80109571:	83 ec 04             	sub    $0x4,%esp
80109574:	68 00 10 00 00       	push   $0x1000
80109579:	6a 00                	push   $0x0
8010957b:	ff 75 f0             	pushl  -0x10(%ebp)
8010957e:	e8 d9 cf ff ff       	call   8010655c <memset>
80109583:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109586:	83 ec 0c             	sub    $0xc,%esp
80109589:	ff 75 f0             	pushl  -0x10(%ebp)
8010958c:	e8 08 f6 ff ff       	call   80108b99 <v2p>
80109591:	83 c4 10             	add    $0x10,%esp
80109594:	89 c2                	mov    %eax,%edx
80109596:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109599:	83 ec 0c             	sub    $0xc,%esp
8010959c:	6a 06                	push   $0x6
8010959e:	52                   	push   %edx
8010959f:	68 00 10 00 00       	push   $0x1000
801095a4:	50                   	push   %eax
801095a5:	ff 75 08             	pushl  0x8(%ebp)
801095a8:	e8 1b fb ff ff       	call   801090c8 <mappages>
801095ad:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801095b0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801095b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095ba:	3b 45 10             	cmp    0x10(%ebp),%eax
801095bd:	0f 82 75 ff ff ff    	jb     80109538 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801095c3:	8b 45 10             	mov    0x10(%ebp),%eax
}
801095c6:	c9                   	leave  
801095c7:	c3                   	ret    

801095c8 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801095c8:	55                   	push   %ebp
801095c9:	89 e5                	mov    %esp,%ebp
801095cb:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801095ce:	8b 45 10             	mov    0x10(%ebp),%eax
801095d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801095d4:	72 08                	jb     801095de <deallocuvm+0x16>
    return oldsz;
801095d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801095d9:	e9 a5 00 00 00       	jmp    80109683 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
801095de:	8b 45 10             	mov    0x10(%ebp),%eax
801095e1:	05 ff 0f 00 00       	add    $0xfff,%eax
801095e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801095eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801095ee:	e9 81 00 00 00       	jmp    80109674 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
801095f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095f6:	83 ec 04             	sub    $0x4,%esp
801095f9:	6a 00                	push   $0x0
801095fb:	50                   	push   %eax
801095fc:	ff 75 08             	pushl  0x8(%ebp)
801095ff:	e8 24 fa ff ff       	call   80109028 <walkpgdir>
80109604:	83 c4 10             	add    $0x10,%esp
80109607:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010960a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010960e:	75 09                	jne    80109619 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80109610:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80109617:	eb 54                	jmp    8010966d <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80109619:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010961c:	8b 00                	mov    (%eax),%eax
8010961e:	83 e0 01             	and    $0x1,%eax
80109621:	85 c0                	test   %eax,%eax
80109623:	74 48                	je     8010966d <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80109625:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109628:	8b 00                	mov    (%eax),%eax
8010962a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010962f:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109632:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109636:	75 0d                	jne    80109645 <deallocuvm+0x7d>
        panic("kfree");
80109638:	83 ec 0c             	sub    $0xc,%esp
8010963b:	68 15 a2 10 80       	push   $0x8010a215
80109640:	e8 b2 6f ff ff       	call   801005f7 <panic>
      char *v = p2v(pa);
80109645:	83 ec 0c             	sub    $0xc,%esp
80109648:	ff 75 ec             	pushl  -0x14(%ebp)
8010964b:	e8 56 f5 ff ff       	call   80108ba6 <p2v>
80109650:	83 c4 10             	add    $0x10,%esp
80109653:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80109656:	83 ec 0c             	sub    $0xc,%esp
80109659:	ff 75 e8             	pushl  -0x18(%ebp)
8010965c:	e8 c1 97 ff ff       	call   80102e22 <kfree>
80109661:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80109664:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109667:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010966d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109674:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109677:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010967a:	0f 82 73 ff ff ff    	jb     801095f3 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80109680:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109683:	c9                   	leave  
80109684:	c3                   	ret    

80109685 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80109685:	55                   	push   %ebp
80109686:	89 e5                	mov    %esp,%ebp
80109688:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
8010968b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010968f:	75 0d                	jne    8010969e <freevm+0x19>
    panic("freevm: no pgdir");
80109691:	83 ec 0c             	sub    $0xc,%esp
80109694:	68 1b a2 10 80       	push   $0x8010a21b
80109699:	e8 59 6f ff ff       	call   801005f7 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010969e:	83 ec 04             	sub    $0x4,%esp
801096a1:	6a 00                	push   $0x0
801096a3:	68 00 00 00 80       	push   $0x80000000
801096a8:	ff 75 08             	pushl  0x8(%ebp)
801096ab:	e8 18 ff ff ff       	call   801095c8 <deallocuvm>
801096b0:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801096b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801096ba:	eb 4f                	jmp    8010970b <freevm+0x86>
    if(pgdir[i] & PTE_P){
801096bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801096c6:	8b 45 08             	mov    0x8(%ebp),%eax
801096c9:	01 d0                	add    %edx,%eax
801096cb:	8b 00                	mov    (%eax),%eax
801096cd:	83 e0 01             	and    $0x1,%eax
801096d0:	85 c0                	test   %eax,%eax
801096d2:	74 33                	je     80109707 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801096d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801096de:	8b 45 08             	mov    0x8(%ebp),%eax
801096e1:	01 d0                	add    %edx,%eax
801096e3:	8b 00                	mov    (%eax),%eax
801096e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801096ea:	83 ec 0c             	sub    $0xc,%esp
801096ed:	50                   	push   %eax
801096ee:	e8 b3 f4 ff ff       	call   80108ba6 <p2v>
801096f3:	83 c4 10             	add    $0x10,%esp
801096f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801096f9:	83 ec 0c             	sub    $0xc,%esp
801096fc:	ff 75 f0             	pushl  -0x10(%ebp)
801096ff:	e8 1e 97 ff ff       	call   80102e22 <kfree>
80109704:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109707:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010970b:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80109712:	76 a8                	jbe    801096bc <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80109714:	83 ec 0c             	sub    $0xc,%esp
80109717:	ff 75 08             	pushl  0x8(%ebp)
8010971a:	e8 03 97 ff ff       	call   80102e22 <kfree>
8010971f:	83 c4 10             	add    $0x10,%esp
}
80109722:	90                   	nop
80109723:	c9                   	leave  
80109724:	c3                   	ret    

80109725 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109725:	55                   	push   %ebp
80109726:	89 e5                	mov    %esp,%ebp
80109728:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010972b:	83 ec 04             	sub    $0x4,%esp
8010972e:	6a 00                	push   $0x0
80109730:	ff 75 0c             	pushl  0xc(%ebp)
80109733:	ff 75 08             	pushl  0x8(%ebp)
80109736:	e8 ed f8 ff ff       	call   80109028 <walkpgdir>
8010973b:	83 c4 10             	add    $0x10,%esp
8010973e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80109741:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109745:	75 0d                	jne    80109754 <clearpteu+0x2f>
    panic("clearpteu");
80109747:	83 ec 0c             	sub    $0xc,%esp
8010974a:	68 2c a2 10 80       	push   $0x8010a22c
8010974f:	e8 a3 6e ff ff       	call   801005f7 <panic>
  *pte &= ~PTE_U;
80109754:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109757:	8b 00                	mov    (%eax),%eax
80109759:	83 e0 fb             	and    $0xfffffffb,%eax
8010975c:	89 c2                	mov    %eax,%edx
8010975e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109761:	89 10                	mov    %edx,(%eax)
}
80109763:	90                   	nop
80109764:	c9                   	leave  
80109765:	c3                   	ret    

80109766 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109766:	55                   	push   %ebp
80109767:	89 e5                	mov    %esp,%ebp
80109769:	53                   	push   %ebx
8010976a:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010976d:	e8 e6 f9 ff ff       	call   80109158 <setupkvm>
80109772:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109775:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109779:	75 0a                	jne    80109785 <copyuvm+0x1f>
    return 0;
8010977b:	b8 00 00 00 00       	mov    $0x0,%eax
80109780:	e9 f8 00 00 00       	jmp    8010987d <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80109785:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010978c:	e9 c4 00 00 00       	jmp    80109855 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109791:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109794:	83 ec 04             	sub    $0x4,%esp
80109797:	6a 00                	push   $0x0
80109799:	50                   	push   %eax
8010979a:	ff 75 08             	pushl  0x8(%ebp)
8010979d:	e8 86 f8 ff ff       	call   80109028 <walkpgdir>
801097a2:	83 c4 10             	add    $0x10,%esp
801097a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
801097a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801097ac:	75 0d                	jne    801097bb <copyuvm+0x55>
      panic("copyuvm: pte should exist");
801097ae:	83 ec 0c             	sub    $0xc,%esp
801097b1:	68 36 a2 10 80       	push   $0x8010a236
801097b6:	e8 3c 6e ff ff       	call   801005f7 <panic>
    if(!(*pte & PTE_P))
801097bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801097be:	8b 00                	mov    (%eax),%eax
801097c0:	83 e0 01             	and    $0x1,%eax
801097c3:	85 c0                	test   %eax,%eax
801097c5:	75 0d                	jne    801097d4 <copyuvm+0x6e>
      panic("copyuvm: page not present");
801097c7:	83 ec 0c             	sub    $0xc,%esp
801097ca:	68 50 a2 10 80       	push   $0x8010a250
801097cf:	e8 23 6e ff ff       	call   801005f7 <panic>
    pa = PTE_ADDR(*pte);
801097d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801097d7:	8b 00                	mov    (%eax),%eax
801097d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801097de:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801097e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801097e4:	8b 00                	mov    (%eax),%eax
801097e6:	25 ff 0f 00 00       	and    $0xfff,%eax
801097eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801097ee:	e8 cc 96 ff ff       	call   80102ebf <kalloc>
801097f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801097f6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801097fa:	74 6a                	je     80109866 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
801097fc:	83 ec 0c             	sub    $0xc,%esp
801097ff:	ff 75 e8             	pushl  -0x18(%ebp)
80109802:	e8 9f f3 ff ff       	call   80108ba6 <p2v>
80109807:	83 c4 10             	add    $0x10,%esp
8010980a:	83 ec 04             	sub    $0x4,%esp
8010980d:	68 00 10 00 00       	push   $0x1000
80109812:	50                   	push   %eax
80109813:	ff 75 e0             	pushl  -0x20(%ebp)
80109816:	e8 00 ce ff ff       	call   8010661b <memmove>
8010981b:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
8010981e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80109821:	83 ec 0c             	sub    $0xc,%esp
80109824:	ff 75 e0             	pushl  -0x20(%ebp)
80109827:	e8 6d f3 ff ff       	call   80108b99 <v2p>
8010982c:	83 c4 10             	add    $0x10,%esp
8010982f:	89 c2                	mov    %eax,%edx
80109831:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109834:	83 ec 0c             	sub    $0xc,%esp
80109837:	53                   	push   %ebx
80109838:	52                   	push   %edx
80109839:	68 00 10 00 00       	push   $0x1000
8010983e:	50                   	push   %eax
8010983f:	ff 75 f0             	pushl  -0x10(%ebp)
80109842:	e8 81 f8 ff ff       	call   801090c8 <mappages>
80109847:	83 c4 20             	add    $0x20,%esp
8010984a:	85 c0                	test   %eax,%eax
8010984c:	78 1b                	js     80109869 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010984e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109855:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109858:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010985b:	0f 82 30 ff ff ff    	jb     80109791 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80109861:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109864:	eb 17                	jmp    8010987d <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80109866:	90                   	nop
80109867:	eb 01                	jmp    8010986a <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80109869:	90                   	nop
  }
  return d;

bad:
  freevm(d);
8010986a:	83 ec 0c             	sub    $0xc,%esp
8010986d:	ff 75 f0             	pushl  -0x10(%ebp)
80109870:	e8 10 fe ff ff       	call   80109685 <freevm>
80109875:	83 c4 10             	add    $0x10,%esp
  return 0;
80109878:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010987d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109880:	c9                   	leave  
80109881:	c3                   	ret    

80109882 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80109882:	55                   	push   %ebp
80109883:	89 e5                	mov    %esp,%ebp
80109885:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109888:	83 ec 04             	sub    $0x4,%esp
8010988b:	6a 00                	push   $0x0
8010988d:	ff 75 0c             	pushl  0xc(%ebp)
80109890:	ff 75 08             	pushl  0x8(%ebp)
80109893:	e8 90 f7 ff ff       	call   80109028 <walkpgdir>
80109898:	83 c4 10             	add    $0x10,%esp
8010989b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010989e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098a1:	8b 00                	mov    (%eax),%eax
801098a3:	83 e0 01             	and    $0x1,%eax
801098a6:	85 c0                	test   %eax,%eax
801098a8:	75 07                	jne    801098b1 <uva2ka+0x2f>
    return 0;
801098aa:	b8 00 00 00 00       	mov    $0x0,%eax
801098af:	eb 29                	jmp    801098da <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
801098b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098b4:	8b 00                	mov    (%eax),%eax
801098b6:	83 e0 04             	and    $0x4,%eax
801098b9:	85 c0                	test   %eax,%eax
801098bb:	75 07                	jne    801098c4 <uva2ka+0x42>
    return 0;
801098bd:	b8 00 00 00 00       	mov    $0x0,%eax
801098c2:	eb 16                	jmp    801098da <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
801098c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098c7:	8b 00                	mov    (%eax),%eax
801098c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801098ce:	83 ec 0c             	sub    $0xc,%esp
801098d1:	50                   	push   %eax
801098d2:	e8 cf f2 ff ff       	call   80108ba6 <p2v>
801098d7:	83 c4 10             	add    $0x10,%esp
}
801098da:	c9                   	leave  
801098db:	c3                   	ret    

801098dc <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801098dc:	55                   	push   %ebp
801098dd:	89 e5                	mov    %esp,%ebp
801098df:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801098e2:	8b 45 10             	mov    0x10(%ebp),%eax
801098e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801098e8:	eb 7f                	jmp    80109969 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
801098ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801098ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801098f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801098f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801098f8:	83 ec 08             	sub    $0x8,%esp
801098fb:	50                   	push   %eax
801098fc:	ff 75 08             	pushl  0x8(%ebp)
801098ff:	e8 7e ff ff ff       	call   80109882 <uva2ka>
80109904:	83 c4 10             	add    $0x10,%esp
80109907:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010990a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010990e:	75 07                	jne    80109917 <copyout+0x3b>
      return -1;
80109910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109915:	eb 61                	jmp    80109978 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80109917:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010991a:	2b 45 0c             	sub    0xc(%ebp),%eax
8010991d:	05 00 10 00 00       	add    $0x1000,%eax
80109922:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80109925:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109928:	3b 45 14             	cmp    0x14(%ebp),%eax
8010992b:	76 06                	jbe    80109933 <copyout+0x57>
      n = len;
8010992d:	8b 45 14             	mov    0x14(%ebp),%eax
80109930:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80109933:	8b 45 0c             	mov    0xc(%ebp),%eax
80109936:	2b 45 ec             	sub    -0x14(%ebp),%eax
80109939:	89 c2                	mov    %eax,%edx
8010993b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010993e:	01 d0                	add    %edx,%eax
80109940:	83 ec 04             	sub    $0x4,%esp
80109943:	ff 75 f0             	pushl  -0x10(%ebp)
80109946:	ff 75 f4             	pushl  -0xc(%ebp)
80109949:	50                   	push   %eax
8010994a:	e8 cc cc ff ff       	call   8010661b <memmove>
8010994f:	83 c4 10             	add    $0x10,%esp
    len -= n;
80109952:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109955:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80109958:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010995b:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
8010995e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109961:	05 00 10 00 00       	add    $0x1000,%eax
80109966:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80109969:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010996d:	0f 85 77 ff ff ff    	jne    801098ea <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80109973:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109978:	c9                   	leave  
80109979:	c3                   	ret    
