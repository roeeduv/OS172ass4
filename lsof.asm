
_lsof:     file format elf32-i386


Disassembly of section .text:

00000000 <strncpy>:
#include "stat.h"


char*
strncpy(char *s, const char *t, int n)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
   6:	8b 45 08             	mov    0x8(%ebp),%eax
   9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
   c:	90                   	nop
   d:	8b 45 10             	mov    0x10(%ebp),%eax
  10:	8d 50 ff             	lea    -0x1(%eax),%edx
  13:	89 55 10             	mov    %edx,0x10(%ebp)
  16:	85 c0                	test   %eax,%eax
  18:	7e 2c                	jle    46 <strncpy+0x46>
  1a:	8b 45 08             	mov    0x8(%ebp),%eax
  1d:	8d 50 01             	lea    0x1(%eax),%edx
  20:	89 55 08             	mov    %edx,0x8(%ebp)
  23:	8b 55 0c             	mov    0xc(%ebp),%edx
  26:	8d 4a 01             	lea    0x1(%edx),%ecx
  29:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  2c:	0f b6 12             	movzbl (%edx),%edx
  2f:	88 10                	mov    %dl,(%eax)
  31:	0f b6 00             	movzbl (%eax),%eax
  34:	84 c0                	test   %al,%al
  36:	75 d5                	jne    d <strncpy+0xd>
    ;
  while(n-- > 0)
  38:	eb 0c                	jmp    46 <strncpy+0x46>
    *s++ = 0;
  3a:	8b 45 08             	mov    0x8(%ebp),%eax
  3d:	8d 50 01             	lea    0x1(%eax),%edx
  40:	89 55 08             	mov    %edx,0x8(%ebp)
  43:	c6 00 00             	movb   $0x0,(%eax)
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  46:	8b 45 10             	mov    0x10(%ebp),%eax
  49:	8d 50 ff             	lea    -0x1(%eax),%edx
  4c:	89 55 10             	mov    %edx,0x10(%ebp)
  4f:	85 c0                	test   %eax,%eax
  51:	7f e7                	jg     3a <strncpy+0x3a>
    *s++ = 0;
  return os;
  53:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  56:	c9                   	leave  
  57:	c3                   	ret    

00000058 <itoa>:



void itoa(int x, char *buf) {
  58:	55                   	push   %ebp
  59:	89 e5                	mov    %esp,%ebp
  5b:	53                   	push   %ebx
  5c:	83 ec 14             	sub    $0x14,%esp
  static char digits[] = "0123456789";
  int i = 0;
  5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char tmp;

  do{
    buf[i++] = digits[x % 10];
  66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  69:	8d 50 01             	lea    0x1(%eax),%edx
  6c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  6f:	89 c2                	mov    %eax,%edx
  71:	8b 45 0c             	mov    0xc(%ebp),%eax
  74:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7a:	ba 67 66 66 66       	mov    $0x66666667,%edx
  7f:	89 c8                	mov    %ecx,%eax
  81:	f7 ea                	imul   %edx
  83:	c1 fa 02             	sar    $0x2,%edx
  86:	89 c8                	mov    %ecx,%eax
  88:	c1 f8 1f             	sar    $0x1f,%eax
  8b:	29 c2                	sub    %eax,%edx
  8d:	89 d0                	mov    %edx,%eax
  8f:	c1 e0 02             	shl    $0x2,%eax
  92:	01 d0                	add    %edx,%eax
  94:	01 c0                	add    %eax,%eax
  96:	29 c1                	sub    %eax,%ecx
  98:	89 ca                	mov    %ecx,%edx
  9a:	0f b6 82 90 0d 00 00 	movzbl 0xd90(%edx),%eax
  a1:	88 03                	mov    %al,(%ebx)
  }while((x /= 10) != 0);
  a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  a6:	ba 67 66 66 66       	mov    $0x66666667,%edx
  ab:	89 c8                	mov    %ecx,%eax
  ad:	f7 ea                	imul   %edx
  af:	c1 fa 02             	sar    $0x2,%edx
  b2:	89 c8                	mov    %ecx,%eax
  b4:	c1 f8 1f             	sar    $0x1f,%eax
  b7:	29 c2                	sub    %eax,%edx
  b9:	89 d0                	mov    %edx,%eax
  bb:	89 45 08             	mov    %eax,0x8(%ebp)
  be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  c2:	75 a2                	jne    66 <itoa+0xe>
  buf[i] = '\0';
  c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ca:	01 d0                	add    %edx,%eax
  cc:	c6 00 00             	movb   $0x0,(%eax)

  for (i = 0; i < strlen(buf) / 2; i++) {
  cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  d6:	eb 64                	jmp    13c <itoa+0xe4>
    tmp = buf[i];
  d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  db:	8b 45 0c             	mov    0xc(%ebp),%eax
  de:	01 d0                	add    %edx,%eax
  e0:	0f b6 00             	movzbl (%eax),%eax
  e3:	88 45 f3             	mov    %al,-0xd(%ebp)
    buf[i] = buf[strlen(buf) - i - 1];
  e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  ec:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  ef:	83 ec 0c             	sub    $0xc,%esp
  f2:	ff 75 0c             	pushl  0xc(%ebp)
  f5:	e8 c9 02 00 00       	call   3c3 <strlen>
  fa:	83 c4 10             	add    $0x10,%esp
  fd:	89 c2                	mov    %eax,%edx
  ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 102:	29 c2                	sub    %eax,%edx
 104:	89 d0                	mov    %edx,%eax
 106:	8d 50 ff             	lea    -0x1(%eax),%edx
 109:	8b 45 0c             	mov    0xc(%ebp),%eax
 10c:	01 d0                	add    %edx,%eax
 10e:	0f b6 00             	movzbl (%eax),%eax
 111:	88 03                	mov    %al,(%ebx)
    buf[strlen(buf) - i - 1] = tmp;
 113:	83 ec 0c             	sub    $0xc,%esp
 116:	ff 75 0c             	pushl  0xc(%ebp)
 119:	e8 a5 02 00 00       	call   3c3 <strlen>
 11e:	83 c4 10             	add    $0x10,%esp
 121:	89 c2                	mov    %eax,%edx
 123:	8b 45 f4             	mov    -0xc(%ebp),%eax
 126:	29 c2                	sub    %eax,%edx
 128:	89 d0                	mov    %edx,%eax
 12a:	8d 50 ff             	lea    -0x1(%eax),%edx
 12d:	8b 45 0c             	mov    0xc(%ebp),%eax
 130:	01 c2                	add    %eax,%edx
 132:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 136:	88 02                	mov    %al,(%edx)
  do{
    buf[i++] = digits[x % 10];
  }while((x /= 10) != 0);
  buf[i] = '\0';

  for (i = 0; i < strlen(buf) / 2; i++) {
 138:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 13c:	83 ec 0c             	sub    $0xc,%esp
 13f:	ff 75 0c             	pushl  0xc(%ebp)
 142:	e8 7c 02 00 00       	call   3c3 <strlen>
 147:	83 c4 10             	add    $0x10,%esp
 14a:	d1 e8                	shr    %eax
 14c:	89 c2                	mov    %eax,%edx
 14e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 151:	39 c2                	cmp    %eax,%edx
 153:	77 83                	ja     d8 <itoa+0x80>
    tmp = buf[i];
    buf[i] = buf[strlen(buf) - i - 1];
    buf[strlen(buf) - i - 1] = tmp;
  }
}
 155:	90                   	nop
 156:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 159:	c9                   	leave  
 15a:	c3                   	ret    

0000015b <main>:


int
main(int argc, char *argv[]){
 15b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 15f:	83 e4 f0             	and    $0xfffffff0,%esp
 162:	ff 71 fc             	pushl  -0x4(%ecx)
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
 168:	53                   	push   %ebx
 169:	51                   	push   %ecx
 16a:	81 ec 50 01 00 00    	sub    $0x150,%esp
  char path[100];
  char buffer[200];
  struct stat stat_s;
  int fd;
  for(int i = 1 ; i<=64 ; i++){
 170:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 177:	e9 a3 01 00 00       	jmp    31f <main+0x1c4>
    for(int j = 0 ; j <= 15 ; j++){
 17c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 183:	e9 89 01 00 00       	jmp    311 <main+0x1b6>
      strncpy(path, "/proc/", strlen("/proc/ "));
 188:	83 ec 0c             	sub    $0xc,%esp
 18b:	68 b2 0a 00 00       	push   $0xab2
 190:	e8 2e 02 00 00       	call   3c3 <strlen>
 195:	83 c4 10             	add    $0x10,%esp
 198:	83 ec 04             	sub    $0x4,%esp
 19b:	50                   	push   %eax
 19c:	68 ba 0a 00 00       	push   $0xaba
 1a1:	8d 45 88             	lea    -0x78(%ebp),%eax
 1a4:	50                   	push   %eax
 1a5:	e8 56 fe ff ff       	call   0 <strncpy>
 1aa:	83 c4 10             	add    $0x10,%esp
      itoa(i, path + strlen(path));
 1ad:	83 ec 0c             	sub    $0xc,%esp
 1b0:	8d 45 88             	lea    -0x78(%ebp),%eax
 1b3:	50                   	push   %eax
 1b4:	e8 0a 02 00 00       	call   3c3 <strlen>
 1b9:	83 c4 10             	add    $0x10,%esp
 1bc:	89 c2                	mov    %eax,%edx
 1be:	8d 45 88             	lea    -0x78(%ebp),%eax
 1c1:	01 d0                	add    %edx,%eax
 1c3:	83 ec 08             	sub    $0x8,%esp
 1c6:	50                   	push   %eax
 1c7:	ff 75 f4             	pushl  -0xc(%ebp)
 1ca:	e8 89 fe ff ff       	call   58 <itoa>
 1cf:	83 c4 10             	add    $0x10,%esp
      strncpy(path + strlen(path),"/fdinfo/", strlen("/fdinfo/ "));
 1d2:	83 ec 0c             	sub    $0xc,%esp
 1d5:	68 c1 0a 00 00       	push   $0xac1
 1da:	e8 e4 01 00 00       	call   3c3 <strlen>
 1df:	83 c4 10             	add    $0x10,%esp
 1e2:	89 c3                	mov    %eax,%ebx
 1e4:	83 ec 0c             	sub    $0xc,%esp
 1e7:	8d 45 88             	lea    -0x78(%ebp),%eax
 1ea:	50                   	push   %eax
 1eb:	e8 d3 01 00 00       	call   3c3 <strlen>
 1f0:	83 c4 10             	add    $0x10,%esp
 1f3:	89 c2                	mov    %eax,%edx
 1f5:	8d 45 88             	lea    -0x78(%ebp),%eax
 1f8:	01 d0                	add    %edx,%eax
 1fa:	83 ec 04             	sub    $0x4,%esp
 1fd:	53                   	push   %ebx
 1fe:	68 cb 0a 00 00       	push   $0xacb
 203:	50                   	push   %eax
 204:	e8 f7 fd ff ff       	call   0 <strncpy>
 209:	83 c4 10             	add    $0x10,%esp
      itoa(j, path + strlen(path));
 20c:	83 ec 0c             	sub    $0xc,%esp
 20f:	8d 45 88             	lea    -0x78(%ebp),%eax
 212:	50                   	push   %eax
 213:	e8 ab 01 00 00       	call   3c3 <strlen>
 218:	83 c4 10             	add    $0x10,%esp
 21b:	89 c2                	mov    %eax,%edx
 21d:	8d 45 88             	lea    -0x78(%ebp),%eax
 220:	01 d0                	add    %edx,%eax
 222:	83 ec 08             	sub    $0x8,%esp
 225:	50                   	push   %eax
 226:	ff 75 f0             	pushl  -0x10(%ebp)
 229:	e8 2a fe ff ff       	call   58 <itoa>
 22e:	83 c4 10             	add    $0x10,%esp
      strncpy(path + strlen(path),"\0", strlen("\0 "));
 231:	83 ec 0c             	sub    $0xc,%esp
 234:	68 d4 0a 00 00       	push   $0xad4
 239:	e8 85 01 00 00       	call   3c3 <strlen>
 23e:	83 c4 10             	add    $0x10,%esp
 241:	89 c3                	mov    %eax,%ebx
 243:	83 ec 0c             	sub    $0xc,%esp
 246:	8d 45 88             	lea    -0x78(%ebp),%eax
 249:	50                   	push   %eax
 24a:	e8 74 01 00 00       	call   3c3 <strlen>
 24f:	83 c4 10             	add    $0x10,%esp
 252:	89 c2                	mov    %eax,%edx
 254:	8d 45 88             	lea    -0x78(%ebp),%eax
 257:	01 d0                	add    %edx,%eax
 259:	83 ec 04             	sub    $0x4,%esp
 25c:	53                   	push   %ebx
 25d:	68 d7 0a 00 00       	push   $0xad7
 262:	50                   	push   %eax
 263:	e8 98 fd ff ff       	call   0 <strncpy>
 268:	83 c4 10             	add    $0x10,%esp
      printf(1, "the path is: %s\n", path);
 26b:	83 ec 04             	sub    $0x4,%esp
 26e:	8d 45 88             	lea    -0x78(%ebp),%eax
 271:	50                   	push   %eax
 272:	68 d9 0a 00 00       	push   $0xad9
 277:	6a 01                	push   $0x1
 279:	e8 7e 04 00 00       	call   6fc <printf>
 27e:	83 c4 10             	add    $0x10,%esp
      if(stat(path, &stat_s) == 0){// enter if the file exist
 281:	83 ec 08             	sub    $0x8,%esp
 284:	8d 85 ac fe ff ff    	lea    -0x154(%ebp),%eax
 28a:	50                   	push   %eax
 28b:	8d 45 88             	lea    -0x78(%ebp),%eax
 28e:	50                   	push   %eax
 28f:	e8 12 02 00 00       	call   4a6 <stat>
 294:	83 c4 10             	add    $0x10,%esp
 297:	85 c0                	test   %eax,%eax
 299:	75 72                	jne    30d <main+0x1b2>
        if((fd = open(path, 0)) < 0){
 29b:	83 ec 08             	sub    $0x8,%esp
 29e:	6a 00                	push   $0x0
 2a0:	8d 45 88             	lea    -0x78(%ebp),%eax
 2a3:	50                   	push   %eax
 2a4:	e8 1c 03 00 00       	call   5c5 <open>
 2a9:	83 c4 10             	add    $0x10,%esp
 2ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
 2af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 2b3:	79 17                	jns    2cc <main+0x171>
          printf(1, "error!\n");
 2b5:	83 ec 08             	sub    $0x8,%esp
 2b8:	68 ea 0a 00 00       	push   $0xaea
 2bd:	6a 01                	push   $0x1
 2bf:	e8 38 04 00 00       	call   6fc <printf>
 2c4:	83 c4 10             	add    $0x10,%esp
          exit();
 2c7:	e8 b9 02 00 00       	call   585 <exit>
        }
        read(fd, buffer , 200);
 2cc:	83 ec 04             	sub    $0x4,%esp
 2cf:	68 c8 00 00 00       	push   $0xc8
 2d4:	8d 85 c0 fe ff ff    	lea    -0x140(%ebp),%eax
 2da:	50                   	push   %eax
 2db:	ff 75 ec             	pushl  -0x14(%ebp)
 2de:	e8 ba 02 00 00       	call   59d <read>
 2e3:	83 c4 10             	add    $0x10,%esp
        printf(1, "%s\n", buffer);
 2e6:	83 ec 04             	sub    $0x4,%esp
 2e9:	8d 85 c0 fe ff ff    	lea    -0x140(%ebp),%eax
 2ef:	50                   	push   %eax
 2f0:	68 f2 0a 00 00       	push   $0xaf2
 2f5:	6a 01                	push   $0x1
 2f7:	e8 00 04 00 00       	call   6fc <printf>
 2fc:	83 c4 10             	add    $0x10,%esp
        close(fd);
 2ff:	83 ec 0c             	sub    $0xc,%esp
 302:	ff 75 ec             	pushl  -0x14(%ebp)
 305:	e8 a3 02 00 00       	call   5ad <close>
 30a:	83 c4 10             	add    $0x10,%esp
  char path[100];
  char buffer[200];
  struct stat stat_s;
  int fd;
  for(int i = 1 ; i<=64 ; i++){
    for(int j = 0 ; j <= 15 ; j++){
 30d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 311:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
 315:	0f 8e 6d fe ff ff    	jle    188 <main+0x2d>
main(int argc, char *argv[]){
  char path[100];
  char buffer[200];
  struct stat stat_s;
  int fd;
  for(int i = 1 ; i<=64 ; i++){
 31b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 31f:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
 323:	0f 8e 53 fe ff ff    	jle    17c <main+0x21>
        close(fd);
      }
    }
  }

  exit();
 329:	e8 57 02 00 00       	call   585 <exit>

0000032e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 32e:	55                   	push   %ebp
 32f:	89 e5                	mov    %esp,%ebp
 331:	57                   	push   %edi
 332:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 333:	8b 4d 08             	mov    0x8(%ebp),%ecx
 336:	8b 55 10             	mov    0x10(%ebp),%edx
 339:	8b 45 0c             	mov    0xc(%ebp),%eax
 33c:	89 cb                	mov    %ecx,%ebx
 33e:	89 df                	mov    %ebx,%edi
 340:	89 d1                	mov    %edx,%ecx
 342:	fc                   	cld    
 343:	f3 aa                	rep stos %al,%es:(%edi)
 345:	89 ca                	mov    %ecx,%edx
 347:	89 fb                	mov    %edi,%ebx
 349:	89 5d 08             	mov    %ebx,0x8(%ebp)
 34c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 34f:	90                   	nop
 350:	5b                   	pop    %ebx
 351:	5f                   	pop    %edi
 352:	5d                   	pop    %ebp
 353:	c3                   	ret    

00000354 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 35a:	8b 45 08             	mov    0x8(%ebp),%eax
 35d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 360:	90                   	nop
 361:	8b 45 08             	mov    0x8(%ebp),%eax
 364:	8d 50 01             	lea    0x1(%eax),%edx
 367:	89 55 08             	mov    %edx,0x8(%ebp)
 36a:	8b 55 0c             	mov    0xc(%ebp),%edx
 36d:	8d 4a 01             	lea    0x1(%edx),%ecx
 370:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 373:	0f b6 12             	movzbl (%edx),%edx
 376:	88 10                	mov    %dl,(%eax)
 378:	0f b6 00             	movzbl (%eax),%eax
 37b:	84 c0                	test   %al,%al
 37d:	75 e2                	jne    361 <strcpy+0xd>
    ;
  return os;
 37f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 382:	c9                   	leave  
 383:	c3                   	ret    

00000384 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 384:	55                   	push   %ebp
 385:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 387:	eb 08                	jmp    391 <strcmp+0xd>
    p++, q++;
 389:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 38d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 391:	8b 45 08             	mov    0x8(%ebp),%eax
 394:	0f b6 00             	movzbl (%eax),%eax
 397:	84 c0                	test   %al,%al
 399:	74 10                	je     3ab <strcmp+0x27>
 39b:	8b 45 08             	mov    0x8(%ebp),%eax
 39e:	0f b6 10             	movzbl (%eax),%edx
 3a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a4:	0f b6 00             	movzbl (%eax),%eax
 3a7:	38 c2                	cmp    %al,%dl
 3a9:	74 de                	je     389 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3ab:	8b 45 08             	mov    0x8(%ebp),%eax
 3ae:	0f b6 00             	movzbl (%eax),%eax
 3b1:	0f b6 d0             	movzbl %al,%edx
 3b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b7:	0f b6 00             	movzbl (%eax),%eax
 3ba:	0f b6 c0             	movzbl %al,%eax
 3bd:	29 c2                	sub    %eax,%edx
 3bf:	89 d0                	mov    %edx,%eax
}
 3c1:	5d                   	pop    %ebp
 3c2:	c3                   	ret    

000003c3 <strlen>:

uint
strlen(char *s)
{
 3c3:	55                   	push   %ebp
 3c4:	89 e5                	mov    %esp,%ebp
 3c6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3d0:	eb 04                	jmp    3d6 <strlen+0x13>
 3d2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d9:	8b 45 08             	mov    0x8(%ebp),%eax
 3dc:	01 d0                	add    %edx,%eax
 3de:	0f b6 00             	movzbl (%eax),%eax
 3e1:	84 c0                	test   %al,%al
 3e3:	75 ed                	jne    3d2 <strlen+0xf>
    ;
  return n;
 3e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e8:	c9                   	leave  
 3e9:	c3                   	ret    

000003ea <memset>:

void*
memset(void *dst, int c, uint n)
{
 3ea:	55                   	push   %ebp
 3eb:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3ed:	8b 45 10             	mov    0x10(%ebp),%eax
 3f0:	50                   	push   %eax
 3f1:	ff 75 0c             	pushl  0xc(%ebp)
 3f4:	ff 75 08             	pushl  0x8(%ebp)
 3f7:	e8 32 ff ff ff       	call   32e <stosb>
 3fc:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3ff:	8b 45 08             	mov    0x8(%ebp),%eax
}
 402:	c9                   	leave  
 403:	c3                   	ret    

00000404 <strchr>:

char*
strchr(const char *s, char c)
{
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	83 ec 04             	sub    $0x4,%esp
 40a:	8b 45 0c             	mov    0xc(%ebp),%eax
 40d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 410:	eb 14                	jmp    426 <strchr+0x22>
    if(*s == c)
 412:	8b 45 08             	mov    0x8(%ebp),%eax
 415:	0f b6 00             	movzbl (%eax),%eax
 418:	3a 45 fc             	cmp    -0x4(%ebp),%al
 41b:	75 05                	jne    422 <strchr+0x1e>
      return (char*)s;
 41d:	8b 45 08             	mov    0x8(%ebp),%eax
 420:	eb 13                	jmp    435 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 422:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 426:	8b 45 08             	mov    0x8(%ebp),%eax
 429:	0f b6 00             	movzbl (%eax),%eax
 42c:	84 c0                	test   %al,%al
 42e:	75 e2                	jne    412 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 430:	b8 00 00 00 00       	mov    $0x0,%eax
}
 435:	c9                   	leave  
 436:	c3                   	ret    

00000437 <gets>:

char*
gets(char *buf, int max)
{
 437:	55                   	push   %ebp
 438:	89 e5                	mov    %esp,%ebp
 43a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 43d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 444:	eb 42                	jmp    488 <gets+0x51>
    cc = read(0, &c, 1);
 446:	83 ec 04             	sub    $0x4,%esp
 449:	6a 01                	push   $0x1
 44b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 44e:	50                   	push   %eax
 44f:	6a 00                	push   $0x0
 451:	e8 47 01 00 00       	call   59d <read>
 456:	83 c4 10             	add    $0x10,%esp
 459:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 45c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 460:	7e 33                	jle    495 <gets+0x5e>
      break;
    buf[i++] = c;
 462:	8b 45 f4             	mov    -0xc(%ebp),%eax
 465:	8d 50 01             	lea    0x1(%eax),%edx
 468:	89 55 f4             	mov    %edx,-0xc(%ebp)
 46b:	89 c2                	mov    %eax,%edx
 46d:	8b 45 08             	mov    0x8(%ebp),%eax
 470:	01 c2                	add    %eax,%edx
 472:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 476:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 478:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 47c:	3c 0a                	cmp    $0xa,%al
 47e:	74 16                	je     496 <gets+0x5f>
 480:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 484:	3c 0d                	cmp    $0xd,%al
 486:	74 0e                	je     496 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 488:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48b:	83 c0 01             	add    $0x1,%eax
 48e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 491:	7c b3                	jl     446 <gets+0xf>
 493:	eb 01                	jmp    496 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 495:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 496:	8b 55 f4             	mov    -0xc(%ebp),%edx
 499:	8b 45 08             	mov    0x8(%ebp),%eax
 49c:	01 d0                	add    %edx,%eax
 49e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4a4:	c9                   	leave  
 4a5:	c3                   	ret    

000004a6 <stat>:

int
stat(char *n, struct stat *st)
{
 4a6:	55                   	push   %ebp
 4a7:	89 e5                	mov    %esp,%ebp
 4a9:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4ac:	83 ec 08             	sub    $0x8,%esp
 4af:	6a 00                	push   $0x0
 4b1:	ff 75 08             	pushl  0x8(%ebp)
 4b4:	e8 0c 01 00 00       	call   5c5 <open>
 4b9:	83 c4 10             	add    $0x10,%esp
 4bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4c3:	79 07                	jns    4cc <stat+0x26>
    return -1;
 4c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4ca:	eb 25                	jmp    4f1 <stat+0x4b>
  r = fstat(fd, st);
 4cc:	83 ec 08             	sub    $0x8,%esp
 4cf:	ff 75 0c             	pushl  0xc(%ebp)
 4d2:	ff 75 f4             	pushl  -0xc(%ebp)
 4d5:	e8 03 01 00 00       	call   5dd <fstat>
 4da:	83 c4 10             	add    $0x10,%esp
 4dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4e0:	83 ec 0c             	sub    $0xc,%esp
 4e3:	ff 75 f4             	pushl  -0xc(%ebp)
 4e6:	e8 c2 00 00 00       	call   5ad <close>
 4eb:	83 c4 10             	add    $0x10,%esp
  return r;
 4ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4f1:	c9                   	leave  
 4f2:	c3                   	ret    

000004f3 <atoi>:

int
atoi(const char *s)
{
 4f3:	55                   	push   %ebp
 4f4:	89 e5                	mov    %esp,%ebp
 4f6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 500:	eb 25                	jmp    527 <atoi+0x34>
    n = n*10 + *s++ - '0';
 502:	8b 55 fc             	mov    -0x4(%ebp),%edx
 505:	89 d0                	mov    %edx,%eax
 507:	c1 e0 02             	shl    $0x2,%eax
 50a:	01 d0                	add    %edx,%eax
 50c:	01 c0                	add    %eax,%eax
 50e:	89 c1                	mov    %eax,%ecx
 510:	8b 45 08             	mov    0x8(%ebp),%eax
 513:	8d 50 01             	lea    0x1(%eax),%edx
 516:	89 55 08             	mov    %edx,0x8(%ebp)
 519:	0f b6 00             	movzbl (%eax),%eax
 51c:	0f be c0             	movsbl %al,%eax
 51f:	01 c8                	add    %ecx,%eax
 521:	83 e8 30             	sub    $0x30,%eax
 524:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 527:	8b 45 08             	mov    0x8(%ebp),%eax
 52a:	0f b6 00             	movzbl (%eax),%eax
 52d:	3c 2f                	cmp    $0x2f,%al
 52f:	7e 0a                	jle    53b <atoi+0x48>
 531:	8b 45 08             	mov    0x8(%ebp),%eax
 534:	0f b6 00             	movzbl (%eax),%eax
 537:	3c 39                	cmp    $0x39,%al
 539:	7e c7                	jle    502 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 53b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 53e:	c9                   	leave  
 53f:	c3                   	ret    

00000540 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 546:	8b 45 08             	mov    0x8(%ebp),%eax
 549:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 54c:	8b 45 0c             	mov    0xc(%ebp),%eax
 54f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 552:	eb 17                	jmp    56b <memmove+0x2b>
    *dst++ = *src++;
 554:	8b 45 fc             	mov    -0x4(%ebp),%eax
 557:	8d 50 01             	lea    0x1(%eax),%edx
 55a:	89 55 fc             	mov    %edx,-0x4(%ebp)
 55d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 560:	8d 4a 01             	lea    0x1(%edx),%ecx
 563:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 566:	0f b6 12             	movzbl (%edx),%edx
 569:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 56b:	8b 45 10             	mov    0x10(%ebp),%eax
 56e:	8d 50 ff             	lea    -0x1(%eax),%edx
 571:	89 55 10             	mov    %edx,0x10(%ebp)
 574:	85 c0                	test   %eax,%eax
 576:	7f dc                	jg     554 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 578:	8b 45 08             	mov    0x8(%ebp),%eax
}
 57b:	c9                   	leave  
 57c:	c3                   	ret    

0000057d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 57d:	b8 01 00 00 00       	mov    $0x1,%eax
 582:	cd 40                	int    $0x40
 584:	c3                   	ret    

00000585 <exit>:
SYSCALL(exit)
 585:	b8 02 00 00 00       	mov    $0x2,%eax
 58a:	cd 40                	int    $0x40
 58c:	c3                   	ret    

0000058d <wait>:
SYSCALL(wait)
 58d:	b8 03 00 00 00       	mov    $0x3,%eax
 592:	cd 40                	int    $0x40
 594:	c3                   	ret    

00000595 <pipe>:
SYSCALL(pipe)
 595:	b8 04 00 00 00       	mov    $0x4,%eax
 59a:	cd 40                	int    $0x40
 59c:	c3                   	ret    

0000059d <read>:
SYSCALL(read)
 59d:	b8 05 00 00 00       	mov    $0x5,%eax
 5a2:	cd 40                	int    $0x40
 5a4:	c3                   	ret    

000005a5 <write>:
SYSCALL(write)
 5a5:	b8 10 00 00 00       	mov    $0x10,%eax
 5aa:	cd 40                	int    $0x40
 5ac:	c3                   	ret    

000005ad <close>:
SYSCALL(close)
 5ad:	b8 15 00 00 00       	mov    $0x15,%eax
 5b2:	cd 40                	int    $0x40
 5b4:	c3                   	ret    

000005b5 <kill>:
SYSCALL(kill)
 5b5:	b8 06 00 00 00       	mov    $0x6,%eax
 5ba:	cd 40                	int    $0x40
 5bc:	c3                   	ret    

000005bd <exec>:
SYSCALL(exec)
 5bd:	b8 07 00 00 00       	mov    $0x7,%eax
 5c2:	cd 40                	int    $0x40
 5c4:	c3                   	ret    

000005c5 <open>:
SYSCALL(open)
 5c5:	b8 0f 00 00 00       	mov    $0xf,%eax
 5ca:	cd 40                	int    $0x40
 5cc:	c3                   	ret    

000005cd <mknod>:
SYSCALL(mknod)
 5cd:	b8 11 00 00 00       	mov    $0x11,%eax
 5d2:	cd 40                	int    $0x40
 5d4:	c3                   	ret    

000005d5 <unlink>:
SYSCALL(unlink)
 5d5:	b8 12 00 00 00       	mov    $0x12,%eax
 5da:	cd 40                	int    $0x40
 5dc:	c3                   	ret    

000005dd <fstat>:
SYSCALL(fstat)
 5dd:	b8 08 00 00 00       	mov    $0x8,%eax
 5e2:	cd 40                	int    $0x40
 5e4:	c3                   	ret    

000005e5 <link>:
SYSCALL(link)
 5e5:	b8 13 00 00 00       	mov    $0x13,%eax
 5ea:	cd 40                	int    $0x40
 5ec:	c3                   	ret    

000005ed <mkdir>:
SYSCALL(mkdir)
 5ed:	b8 14 00 00 00       	mov    $0x14,%eax
 5f2:	cd 40                	int    $0x40
 5f4:	c3                   	ret    

000005f5 <chdir>:
SYSCALL(chdir)
 5f5:	b8 09 00 00 00       	mov    $0x9,%eax
 5fa:	cd 40                	int    $0x40
 5fc:	c3                   	ret    

000005fd <dup>:
SYSCALL(dup)
 5fd:	b8 0a 00 00 00       	mov    $0xa,%eax
 602:	cd 40                	int    $0x40
 604:	c3                   	ret    

00000605 <getpid>:
SYSCALL(getpid)
 605:	b8 0b 00 00 00       	mov    $0xb,%eax
 60a:	cd 40                	int    $0x40
 60c:	c3                   	ret    

0000060d <sbrk>:
SYSCALL(sbrk)
 60d:	b8 0c 00 00 00       	mov    $0xc,%eax
 612:	cd 40                	int    $0x40
 614:	c3                   	ret    

00000615 <sleep>:
SYSCALL(sleep)
 615:	b8 0d 00 00 00       	mov    $0xd,%eax
 61a:	cd 40                	int    $0x40
 61c:	c3                   	ret    

0000061d <uptime>:
SYSCALL(uptime)
 61d:	b8 0e 00 00 00       	mov    $0xe,%eax
 622:	cd 40                	int    $0x40
 624:	c3                   	ret    

00000625 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 625:	55                   	push   %ebp
 626:	89 e5                	mov    %esp,%ebp
 628:	83 ec 18             	sub    $0x18,%esp
 62b:	8b 45 0c             	mov    0xc(%ebp),%eax
 62e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 631:	83 ec 04             	sub    $0x4,%esp
 634:	6a 01                	push   $0x1
 636:	8d 45 f4             	lea    -0xc(%ebp),%eax
 639:	50                   	push   %eax
 63a:	ff 75 08             	pushl  0x8(%ebp)
 63d:	e8 63 ff ff ff       	call   5a5 <write>
 642:	83 c4 10             	add    $0x10,%esp
}
 645:	90                   	nop
 646:	c9                   	leave  
 647:	c3                   	ret    

00000648 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 648:	55                   	push   %ebp
 649:	89 e5                	mov    %esp,%ebp
 64b:	53                   	push   %ebx
 64c:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 64f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 656:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 65a:	74 17                	je     673 <printint+0x2b>
 65c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 660:	79 11                	jns    673 <printint+0x2b>
    neg = 1;
 662:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 669:	8b 45 0c             	mov    0xc(%ebp),%eax
 66c:	f7 d8                	neg    %eax
 66e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 671:	eb 06                	jmp    679 <printint+0x31>
  } else {
    x = xx;
 673:	8b 45 0c             	mov    0xc(%ebp),%eax
 676:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 679:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 680:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 683:	8d 41 01             	lea    0x1(%ecx),%eax
 686:	89 45 f4             	mov    %eax,-0xc(%ebp)
 689:	8b 5d 10             	mov    0x10(%ebp),%ebx
 68c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 68f:	ba 00 00 00 00       	mov    $0x0,%edx
 694:	f7 f3                	div    %ebx
 696:	89 d0                	mov    %edx,%eax
 698:	0f b6 80 9c 0d 00 00 	movzbl 0xd9c(%eax),%eax
 69f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6a9:	ba 00 00 00 00       	mov    $0x0,%edx
 6ae:	f7 f3                	div    %ebx
 6b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6b7:	75 c7                	jne    680 <printint+0x38>
  if(neg)
 6b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6bd:	74 2d                	je     6ec <printint+0xa4>
    buf[i++] = '-';
 6bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c2:	8d 50 01             	lea    0x1(%eax),%edx
 6c5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6c8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6cd:	eb 1d                	jmp    6ec <printint+0xa4>
    putc(fd, buf[i]);
 6cf:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d5:	01 d0                	add    %edx,%eax
 6d7:	0f b6 00             	movzbl (%eax),%eax
 6da:	0f be c0             	movsbl %al,%eax
 6dd:	83 ec 08             	sub    $0x8,%esp
 6e0:	50                   	push   %eax
 6e1:	ff 75 08             	pushl  0x8(%ebp)
 6e4:	e8 3c ff ff ff       	call   625 <putc>
 6e9:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6ec:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6f4:	79 d9                	jns    6cf <printint+0x87>
    putc(fd, buf[i]);
}
 6f6:	90                   	nop
 6f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6fa:	c9                   	leave  
 6fb:	c3                   	ret    

000006fc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6fc:	55                   	push   %ebp
 6fd:	89 e5                	mov    %esp,%ebp
 6ff:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 702:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 709:	8d 45 0c             	lea    0xc(%ebp),%eax
 70c:	83 c0 04             	add    $0x4,%eax
 70f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 712:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 719:	e9 59 01 00 00       	jmp    877 <printf+0x17b>
    c = fmt[i] & 0xff;
 71e:	8b 55 0c             	mov    0xc(%ebp),%edx
 721:	8b 45 f0             	mov    -0x10(%ebp),%eax
 724:	01 d0                	add    %edx,%eax
 726:	0f b6 00             	movzbl (%eax),%eax
 729:	0f be c0             	movsbl %al,%eax
 72c:	25 ff 00 00 00       	and    $0xff,%eax
 731:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 734:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 738:	75 2c                	jne    766 <printf+0x6a>
      if(c == '%'){
 73a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 73e:	75 0c                	jne    74c <printf+0x50>
        state = '%';
 740:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 747:	e9 27 01 00 00       	jmp    873 <printf+0x177>
      } else {
        putc(fd, c);
 74c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 74f:	0f be c0             	movsbl %al,%eax
 752:	83 ec 08             	sub    $0x8,%esp
 755:	50                   	push   %eax
 756:	ff 75 08             	pushl  0x8(%ebp)
 759:	e8 c7 fe ff ff       	call   625 <putc>
 75e:	83 c4 10             	add    $0x10,%esp
 761:	e9 0d 01 00 00       	jmp    873 <printf+0x177>
      }
    } else if(state == '%'){
 766:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 76a:	0f 85 03 01 00 00    	jne    873 <printf+0x177>
      if(c == 'd'){
 770:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 774:	75 1e                	jne    794 <printf+0x98>
        printint(fd, *ap, 10, 1);
 776:	8b 45 e8             	mov    -0x18(%ebp),%eax
 779:	8b 00                	mov    (%eax),%eax
 77b:	6a 01                	push   $0x1
 77d:	6a 0a                	push   $0xa
 77f:	50                   	push   %eax
 780:	ff 75 08             	pushl  0x8(%ebp)
 783:	e8 c0 fe ff ff       	call   648 <printint>
 788:	83 c4 10             	add    $0x10,%esp
        ap++;
 78b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 78f:	e9 d8 00 00 00       	jmp    86c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 794:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 798:	74 06                	je     7a0 <printf+0xa4>
 79a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 79e:	75 1e                	jne    7be <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a3:	8b 00                	mov    (%eax),%eax
 7a5:	6a 00                	push   $0x0
 7a7:	6a 10                	push   $0x10
 7a9:	50                   	push   %eax
 7aa:	ff 75 08             	pushl  0x8(%ebp)
 7ad:	e8 96 fe ff ff       	call   648 <printint>
 7b2:	83 c4 10             	add    $0x10,%esp
        ap++;
 7b5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7b9:	e9 ae 00 00 00       	jmp    86c <printf+0x170>
      } else if(c == 's'){
 7be:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7c2:	75 43                	jne    807 <printf+0x10b>
        s = (char*)*ap;
 7c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c7:	8b 00                	mov    (%eax),%eax
 7c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7cc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d4:	75 25                	jne    7fb <printf+0xff>
          s = "(null)";
 7d6:	c7 45 f4 f6 0a 00 00 	movl   $0xaf6,-0xc(%ebp)
        while(*s != 0){
 7dd:	eb 1c                	jmp    7fb <printf+0xff>
          putc(fd, *s);
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	0f b6 00             	movzbl (%eax),%eax
 7e5:	0f be c0             	movsbl %al,%eax
 7e8:	83 ec 08             	sub    $0x8,%esp
 7eb:	50                   	push   %eax
 7ec:	ff 75 08             	pushl  0x8(%ebp)
 7ef:	e8 31 fe ff ff       	call   625 <putc>
 7f4:	83 c4 10             	add    $0x10,%esp
          s++;
 7f7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fe:	0f b6 00             	movzbl (%eax),%eax
 801:	84 c0                	test   %al,%al
 803:	75 da                	jne    7df <printf+0xe3>
 805:	eb 65                	jmp    86c <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 807:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 80b:	75 1d                	jne    82a <printf+0x12e>
        putc(fd, *ap);
 80d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 810:	8b 00                	mov    (%eax),%eax
 812:	0f be c0             	movsbl %al,%eax
 815:	83 ec 08             	sub    $0x8,%esp
 818:	50                   	push   %eax
 819:	ff 75 08             	pushl  0x8(%ebp)
 81c:	e8 04 fe ff ff       	call   625 <putc>
 821:	83 c4 10             	add    $0x10,%esp
        ap++;
 824:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 828:	eb 42                	jmp    86c <printf+0x170>
      } else if(c == '%'){
 82a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 82e:	75 17                	jne    847 <printf+0x14b>
        putc(fd, c);
 830:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 833:	0f be c0             	movsbl %al,%eax
 836:	83 ec 08             	sub    $0x8,%esp
 839:	50                   	push   %eax
 83a:	ff 75 08             	pushl  0x8(%ebp)
 83d:	e8 e3 fd ff ff       	call   625 <putc>
 842:	83 c4 10             	add    $0x10,%esp
 845:	eb 25                	jmp    86c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 847:	83 ec 08             	sub    $0x8,%esp
 84a:	6a 25                	push   $0x25
 84c:	ff 75 08             	pushl  0x8(%ebp)
 84f:	e8 d1 fd ff ff       	call   625 <putc>
 854:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 857:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 85a:	0f be c0             	movsbl %al,%eax
 85d:	83 ec 08             	sub    $0x8,%esp
 860:	50                   	push   %eax
 861:	ff 75 08             	pushl  0x8(%ebp)
 864:	e8 bc fd ff ff       	call   625 <putc>
 869:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 86c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 873:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 877:	8b 55 0c             	mov    0xc(%ebp),%edx
 87a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87d:	01 d0                	add    %edx,%eax
 87f:	0f b6 00             	movzbl (%eax),%eax
 882:	84 c0                	test   %al,%al
 884:	0f 85 94 fe ff ff    	jne    71e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 88a:	90                   	nop
 88b:	c9                   	leave  
 88c:	c3                   	ret    

0000088d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 88d:	55                   	push   %ebp
 88e:	89 e5                	mov    %esp,%ebp
 890:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 893:	8b 45 08             	mov    0x8(%ebp),%eax
 896:	83 e8 08             	sub    $0x8,%eax
 899:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89c:	a1 b8 0d 00 00       	mov    0xdb8,%eax
 8a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8a4:	eb 24                	jmp    8ca <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a9:	8b 00                	mov    (%eax),%eax
 8ab:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ae:	77 12                	ja     8c2 <free+0x35>
 8b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8b6:	77 24                	ja     8dc <free+0x4f>
 8b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bb:	8b 00                	mov    (%eax),%eax
 8bd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8c0:	77 1a                	ja     8dc <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c5:	8b 00                	mov    (%eax),%eax
 8c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8d0:	76 d4                	jbe    8a6 <free+0x19>
 8d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d5:	8b 00                	mov    (%eax),%eax
 8d7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8da:	76 ca                	jbe    8a6 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8df:	8b 40 04             	mov    0x4(%eax),%eax
 8e2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ec:	01 c2                	add    %eax,%edx
 8ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f1:	8b 00                	mov    (%eax),%eax
 8f3:	39 c2                	cmp    %eax,%edx
 8f5:	75 24                	jne    91b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fa:	8b 50 04             	mov    0x4(%eax),%edx
 8fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 900:	8b 00                	mov    (%eax),%eax
 902:	8b 40 04             	mov    0x4(%eax),%eax
 905:	01 c2                	add    %eax,%edx
 907:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 90d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 910:	8b 00                	mov    (%eax),%eax
 912:	8b 10                	mov    (%eax),%edx
 914:	8b 45 f8             	mov    -0x8(%ebp),%eax
 917:	89 10                	mov    %edx,(%eax)
 919:	eb 0a                	jmp    925 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 91b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91e:	8b 10                	mov    (%eax),%edx
 920:	8b 45 f8             	mov    -0x8(%ebp),%eax
 923:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 925:	8b 45 fc             	mov    -0x4(%ebp),%eax
 928:	8b 40 04             	mov    0x4(%eax),%eax
 92b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 932:	8b 45 fc             	mov    -0x4(%ebp),%eax
 935:	01 d0                	add    %edx,%eax
 937:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 93a:	75 20                	jne    95c <free+0xcf>
    p->s.size += bp->s.size;
 93c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93f:	8b 50 04             	mov    0x4(%eax),%edx
 942:	8b 45 f8             	mov    -0x8(%ebp),%eax
 945:	8b 40 04             	mov    0x4(%eax),%eax
 948:	01 c2                	add    %eax,%edx
 94a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 950:	8b 45 f8             	mov    -0x8(%ebp),%eax
 953:	8b 10                	mov    (%eax),%edx
 955:	8b 45 fc             	mov    -0x4(%ebp),%eax
 958:	89 10                	mov    %edx,(%eax)
 95a:	eb 08                	jmp    964 <free+0xd7>
  } else
    p->s.ptr = bp;
 95c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 962:	89 10                	mov    %edx,(%eax)
  freep = p;
 964:	8b 45 fc             	mov    -0x4(%ebp),%eax
 967:	a3 b8 0d 00 00       	mov    %eax,0xdb8
}
 96c:	90                   	nop
 96d:	c9                   	leave  
 96e:	c3                   	ret    

0000096f <morecore>:

static Header*
morecore(uint nu)
{
 96f:	55                   	push   %ebp
 970:	89 e5                	mov    %esp,%ebp
 972:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 975:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 97c:	77 07                	ja     985 <morecore+0x16>
    nu = 4096;
 97e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 985:	8b 45 08             	mov    0x8(%ebp),%eax
 988:	c1 e0 03             	shl    $0x3,%eax
 98b:	83 ec 0c             	sub    $0xc,%esp
 98e:	50                   	push   %eax
 98f:	e8 79 fc ff ff       	call   60d <sbrk>
 994:	83 c4 10             	add    $0x10,%esp
 997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 99a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 99e:	75 07                	jne    9a7 <morecore+0x38>
    return 0;
 9a0:	b8 00 00 00 00       	mov    $0x0,%eax
 9a5:	eb 26                	jmp    9cd <morecore+0x5e>
  hp = (Header*)p;
 9a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b0:	8b 55 08             	mov    0x8(%ebp),%edx
 9b3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b9:	83 c0 08             	add    $0x8,%eax
 9bc:	83 ec 0c             	sub    $0xc,%esp
 9bf:	50                   	push   %eax
 9c0:	e8 c8 fe ff ff       	call   88d <free>
 9c5:	83 c4 10             	add    $0x10,%esp
  return freep;
 9c8:	a1 b8 0d 00 00       	mov    0xdb8,%eax
}
 9cd:	c9                   	leave  
 9ce:	c3                   	ret    

000009cf <malloc>:

void*
malloc(uint nbytes)
{
 9cf:	55                   	push   %ebp
 9d0:	89 e5                	mov    %esp,%ebp
 9d2:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d5:	8b 45 08             	mov    0x8(%ebp),%eax
 9d8:	83 c0 07             	add    $0x7,%eax
 9db:	c1 e8 03             	shr    $0x3,%eax
 9de:	83 c0 01             	add    $0x1,%eax
 9e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9e4:	a1 b8 0d 00 00       	mov    0xdb8,%eax
 9e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9f0:	75 23                	jne    a15 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9f2:	c7 45 f0 b0 0d 00 00 	movl   $0xdb0,-0x10(%ebp)
 9f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fc:	a3 b8 0d 00 00       	mov    %eax,0xdb8
 a01:	a1 b8 0d 00 00       	mov    0xdb8,%eax
 a06:	a3 b0 0d 00 00       	mov    %eax,0xdb0
    base.s.size = 0;
 a0b:	c7 05 b4 0d 00 00 00 	movl   $0x0,0xdb4
 a12:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a18:	8b 00                	mov    (%eax),%eax
 a1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a20:	8b 40 04             	mov    0x4(%eax),%eax
 a23:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a26:	72 4d                	jb     a75 <malloc+0xa6>
      if(p->s.size == nunits)
 a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2b:	8b 40 04             	mov    0x4(%eax),%eax
 a2e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a31:	75 0c                	jne    a3f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a36:	8b 10                	mov    (%eax),%edx
 a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3b:	89 10                	mov    %edx,(%eax)
 a3d:	eb 26                	jmp    a65 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a42:	8b 40 04             	mov    0x4(%eax),%eax
 a45:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a48:	89 c2                	mov    %eax,%edx
 a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a53:	8b 40 04             	mov    0x4(%eax),%eax
 a56:	c1 e0 03             	shl    $0x3,%eax
 a59:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a62:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a68:	a3 b8 0d 00 00       	mov    %eax,0xdb8
      return (void*)(p + 1);
 a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a70:	83 c0 08             	add    $0x8,%eax
 a73:	eb 3b                	jmp    ab0 <malloc+0xe1>
    }
    if(p == freep)
 a75:	a1 b8 0d 00 00       	mov    0xdb8,%eax
 a7a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a7d:	75 1e                	jne    a9d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a7f:	83 ec 0c             	sub    $0xc,%esp
 a82:	ff 75 ec             	pushl  -0x14(%ebp)
 a85:	e8 e5 fe ff ff       	call   96f <morecore>
 a8a:	83 c4 10             	add    $0x10,%esp
 a8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a94:	75 07                	jne    a9d <malloc+0xce>
        return 0;
 a96:	b8 00 00 00 00       	mov    $0x0,%eax
 a9b:	eb 13                	jmp    ab0 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa6:	8b 00                	mov    (%eax),%eax
 aa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 aab:	e9 6d ff ff ff       	jmp    a1d <malloc+0x4e>
}
 ab0:	c9                   	leave  
 ab1:	c3                   	ret    
