
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  mknod("proc", 2, 0);
  11:	83 ec 04             	sub    $0x4,%esp
  14:	6a 00                	push   $0x0
  16:	6a 02                	push   $0x2
  18:	68 9c 08 00 00       	push   $0x89c
  1d:	e8 92 03 00 00       	call   3b4 <mknod>
  22:	83 c4 10             	add    $0x10,%esp

  if(open("console", O_RDWR) < 0){
  25:	83 ec 08             	sub    $0x8,%esp
  28:	6a 02                	push   $0x2
  2a:	68 a1 08 00 00       	push   $0x8a1
  2f:	e8 78 03 00 00       	call   3ac <open>
  34:	83 c4 10             	add    $0x10,%esp
  37:	85 c0                	test   %eax,%eax
  39:	79 26                	jns    61 <main+0x61>
    mknod("console", 1, 1);
  3b:	83 ec 04             	sub    $0x4,%esp
  3e:	6a 01                	push   $0x1
  40:	6a 01                	push   $0x1
  42:	68 a1 08 00 00       	push   $0x8a1
  47:	e8 68 03 00 00       	call   3b4 <mknod>
  4c:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  4f:	83 ec 08             	sub    $0x8,%esp
  52:	6a 02                	push   $0x2
  54:	68 a1 08 00 00       	push   $0x8a1
  59:	e8 4e 03 00 00       	call   3ac <open>
  5e:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  61:	83 ec 0c             	sub    $0xc,%esp
  64:	6a 00                	push   $0x0
  66:	e8 79 03 00 00       	call   3e4 <dup>
  6b:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  6e:	83 ec 0c             	sub    $0xc,%esp
  71:	6a 00                	push   $0x0
  73:	e8 6c 03 00 00       	call   3e4 <dup>
  78:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  7b:	83 ec 08             	sub    $0x8,%esp
  7e:	68 a9 08 00 00       	push   $0x8a9
  83:	6a 01                	push   $0x1
  85:	e8 59 04 00 00       	call   4e3 <printf>
  8a:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  8d:	e8 d2 02 00 00       	call   364 <fork>
  92:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  99:	79 17                	jns    b2 <main+0xb2>
      printf(1, "init: fork failed\n");
  9b:	83 ec 08             	sub    $0x8,%esp
  9e:	68 bc 08 00 00       	push   $0x8bc
  a3:	6a 01                	push   $0x1
  a5:	e8 39 04 00 00       	call   4e3 <printf>
  aa:	83 c4 10             	add    $0x10,%esp
      exit();
  ad:	e8 ba 02 00 00       	call   36c <exit>
    }
    if(pid == 0){
  b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  b6:	75 3e                	jne    f6 <main+0xf6>
      exec("sh", argv);
  b8:	83 ec 08             	sub    $0x8,%esp
  bb:	68 40 0b 00 00       	push   $0xb40
  c0:	68 99 08 00 00       	push   $0x899
  c5:	e8 da 02 00 00       	call   3a4 <exec>
  ca:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	68 cf 08 00 00       	push   $0x8cf
  d5:	6a 01                	push   $0x1
  d7:	e8 07 04 00 00       	call   4e3 <printf>
  dc:	83 c4 10             	add    $0x10,%esp
      exit();
  df:	e8 88 02 00 00       	call   36c <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  e4:	83 ec 08             	sub    $0x8,%esp
  e7:	68 e5 08 00 00       	push   $0x8e5
  ec:	6a 01                	push   $0x1
  ee:	e8 f0 03 00 00       	call   4e3 <printf>
  f3:	83 c4 10             	add    $0x10,%esp
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  f6:	e8 79 02 00 00       	call   374 <wait>
  fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 102:	0f 88 73 ff ff ff    	js     7b <main+0x7b>
 108:	8b 45 f0             	mov    -0x10(%ebp),%eax
 10b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 10e:	75 d4                	jne    e4 <main+0xe4>
      printf(1, "zombie!\n");
  }
 110:	e9 66 ff ff ff       	jmp    7b <main+0x7b>

00000115 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 115:	55                   	push   %ebp
 116:	89 e5                	mov    %esp,%ebp
 118:	57                   	push   %edi
 119:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 11a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11d:	8b 55 10             	mov    0x10(%ebp),%edx
 120:	8b 45 0c             	mov    0xc(%ebp),%eax
 123:	89 cb                	mov    %ecx,%ebx
 125:	89 df                	mov    %ebx,%edi
 127:	89 d1                	mov    %edx,%ecx
 129:	fc                   	cld    
 12a:	f3 aa                	rep stos %al,%es:(%edi)
 12c:	89 ca                	mov    %ecx,%edx
 12e:	89 fb                	mov    %edi,%ebx
 130:	89 5d 08             	mov    %ebx,0x8(%ebp)
 133:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 136:	90                   	nop
 137:	5b                   	pop    %ebx
 138:	5f                   	pop    %edi
 139:	5d                   	pop    %ebp
 13a:	c3                   	ret    

0000013b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 141:	8b 45 08             	mov    0x8(%ebp),%eax
 144:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 147:	90                   	nop
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	8d 50 01             	lea    0x1(%eax),%edx
 14e:	89 55 08             	mov    %edx,0x8(%ebp)
 151:	8b 55 0c             	mov    0xc(%ebp),%edx
 154:	8d 4a 01             	lea    0x1(%edx),%ecx
 157:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 15a:	0f b6 12             	movzbl (%edx),%edx
 15d:	88 10                	mov    %dl,(%eax)
 15f:	0f b6 00             	movzbl (%eax),%eax
 162:	84 c0                	test   %al,%al
 164:	75 e2                	jne    148 <strcpy+0xd>
    ;
  return os;
 166:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 169:	c9                   	leave  
 16a:	c3                   	ret    

0000016b <strcmp>:

int
strcmp(const char *p, const char *q)
{
 16b:	55                   	push   %ebp
 16c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 16e:	eb 08                	jmp    178 <strcmp+0xd>
    p++, q++;
 170:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 174:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 178:	8b 45 08             	mov    0x8(%ebp),%eax
 17b:	0f b6 00             	movzbl (%eax),%eax
 17e:	84 c0                	test   %al,%al
 180:	74 10                	je     192 <strcmp+0x27>
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	0f b6 10             	movzbl (%eax),%edx
 188:	8b 45 0c             	mov    0xc(%ebp),%eax
 18b:	0f b6 00             	movzbl (%eax),%eax
 18e:	38 c2                	cmp    %al,%dl
 190:	74 de                	je     170 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 192:	8b 45 08             	mov    0x8(%ebp),%eax
 195:	0f b6 00             	movzbl (%eax),%eax
 198:	0f b6 d0             	movzbl %al,%edx
 19b:	8b 45 0c             	mov    0xc(%ebp),%eax
 19e:	0f b6 00             	movzbl (%eax),%eax
 1a1:	0f b6 c0             	movzbl %al,%eax
 1a4:	29 c2                	sub    %eax,%edx
 1a6:	89 d0                	mov    %edx,%eax
}
 1a8:	5d                   	pop    %ebp
 1a9:	c3                   	ret    

000001aa <strlen>:

uint
strlen(char *s)
{
 1aa:	55                   	push   %ebp
 1ab:	89 e5                	mov    %esp,%ebp
 1ad:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b7:	eb 04                	jmp    1bd <strlen+0x13>
 1b9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1c0:	8b 45 08             	mov    0x8(%ebp),%eax
 1c3:	01 d0                	add    %edx,%eax
 1c5:	0f b6 00             	movzbl (%eax),%eax
 1c8:	84 c0                	test   %al,%al
 1ca:	75 ed                	jne    1b9 <strlen+0xf>
    ;
  return n;
 1cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1cf:	c9                   	leave  
 1d0:	c3                   	ret    

000001d1 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d1:	55                   	push   %ebp
 1d2:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1d4:	8b 45 10             	mov    0x10(%ebp),%eax
 1d7:	50                   	push   %eax
 1d8:	ff 75 0c             	pushl  0xc(%ebp)
 1db:	ff 75 08             	pushl  0x8(%ebp)
 1de:	e8 32 ff ff ff       	call   115 <stosb>
 1e3:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e9:	c9                   	leave  
 1ea:	c3                   	ret    

000001eb <strchr>:

char*
strchr(const char *s, char c)
{
 1eb:	55                   	push   %ebp
 1ec:	89 e5                	mov    %esp,%ebp
 1ee:	83 ec 04             	sub    $0x4,%esp
 1f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f4:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f7:	eb 14                	jmp    20d <strchr+0x22>
    if(*s == c)
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	0f b6 00             	movzbl (%eax),%eax
 1ff:	3a 45 fc             	cmp    -0x4(%ebp),%al
 202:	75 05                	jne    209 <strchr+0x1e>
      return (char*)s;
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	eb 13                	jmp    21c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 209:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 20d:	8b 45 08             	mov    0x8(%ebp),%eax
 210:	0f b6 00             	movzbl (%eax),%eax
 213:	84 c0                	test   %al,%al
 215:	75 e2                	jne    1f9 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 217:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21c:	c9                   	leave  
 21d:	c3                   	ret    

0000021e <gets>:

char*
gets(char *buf, int max)
{
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
 221:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 224:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 22b:	eb 42                	jmp    26f <gets+0x51>
    cc = read(0, &c, 1);
 22d:	83 ec 04             	sub    $0x4,%esp
 230:	6a 01                	push   $0x1
 232:	8d 45 ef             	lea    -0x11(%ebp),%eax
 235:	50                   	push   %eax
 236:	6a 00                	push   $0x0
 238:	e8 47 01 00 00       	call   384 <read>
 23d:	83 c4 10             	add    $0x10,%esp
 240:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 243:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 247:	7e 33                	jle    27c <gets+0x5e>
      break;
    buf[i++] = c;
 249:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24c:	8d 50 01             	lea    0x1(%eax),%edx
 24f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 252:	89 c2                	mov    %eax,%edx
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	01 c2                	add    %eax,%edx
 259:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 25f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 263:	3c 0a                	cmp    $0xa,%al
 265:	74 16                	je     27d <gets+0x5f>
 267:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26b:	3c 0d                	cmp    $0xd,%al
 26d:	74 0e                	je     27d <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 272:	83 c0 01             	add    $0x1,%eax
 275:	3b 45 0c             	cmp    0xc(%ebp),%eax
 278:	7c b3                	jl     22d <gets+0xf>
 27a:	eb 01                	jmp    27d <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 27c:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 27d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 280:	8b 45 08             	mov    0x8(%ebp),%eax
 283:	01 d0                	add    %edx,%eax
 285:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 288:	8b 45 08             	mov    0x8(%ebp),%eax
}
 28b:	c9                   	leave  
 28c:	c3                   	ret    

0000028d <stat>:

int
stat(char *n, struct stat *st)
{
 28d:	55                   	push   %ebp
 28e:	89 e5                	mov    %esp,%ebp
 290:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 293:	83 ec 08             	sub    $0x8,%esp
 296:	6a 00                	push   $0x0
 298:	ff 75 08             	pushl  0x8(%ebp)
 29b:	e8 0c 01 00 00       	call   3ac <open>
 2a0:	83 c4 10             	add    $0x10,%esp
 2a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2aa:	79 07                	jns    2b3 <stat+0x26>
    return -1;
 2ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b1:	eb 25                	jmp    2d8 <stat+0x4b>
  r = fstat(fd, st);
 2b3:	83 ec 08             	sub    $0x8,%esp
 2b6:	ff 75 0c             	pushl  0xc(%ebp)
 2b9:	ff 75 f4             	pushl  -0xc(%ebp)
 2bc:	e8 03 01 00 00       	call   3c4 <fstat>
 2c1:	83 c4 10             	add    $0x10,%esp
 2c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c7:	83 ec 0c             	sub    $0xc,%esp
 2ca:	ff 75 f4             	pushl  -0xc(%ebp)
 2cd:	e8 c2 00 00 00       	call   394 <close>
 2d2:	83 c4 10             	add    $0x10,%esp
  return r;
 2d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d8:	c9                   	leave  
 2d9:	c3                   	ret    

000002da <atoi>:

int
atoi(const char *s)
{
 2da:	55                   	push   %ebp
 2db:	89 e5                	mov    %esp,%ebp
 2dd:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e7:	eb 25                	jmp    30e <atoi+0x34>
    n = n*10 + *s++ - '0';
 2e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ec:	89 d0                	mov    %edx,%eax
 2ee:	c1 e0 02             	shl    $0x2,%eax
 2f1:	01 d0                	add    %edx,%eax
 2f3:	01 c0                	add    %eax,%eax
 2f5:	89 c1                	mov    %eax,%ecx
 2f7:	8b 45 08             	mov    0x8(%ebp),%eax
 2fa:	8d 50 01             	lea    0x1(%eax),%edx
 2fd:	89 55 08             	mov    %edx,0x8(%ebp)
 300:	0f b6 00             	movzbl (%eax),%eax
 303:	0f be c0             	movsbl %al,%eax
 306:	01 c8                	add    %ecx,%eax
 308:	83 e8 30             	sub    $0x30,%eax
 30b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 30e:	8b 45 08             	mov    0x8(%ebp),%eax
 311:	0f b6 00             	movzbl (%eax),%eax
 314:	3c 2f                	cmp    $0x2f,%al
 316:	7e 0a                	jle    322 <atoi+0x48>
 318:	8b 45 08             	mov    0x8(%ebp),%eax
 31b:	0f b6 00             	movzbl (%eax),%eax
 31e:	3c 39                	cmp    $0x39,%al
 320:	7e c7                	jle    2e9 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 322:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 325:	c9                   	leave  
 326:	c3                   	ret    

00000327 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 327:	55                   	push   %ebp
 328:	89 e5                	mov    %esp,%ebp
 32a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
 330:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 333:	8b 45 0c             	mov    0xc(%ebp),%eax
 336:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 339:	eb 17                	jmp    352 <memmove+0x2b>
    *dst++ = *src++;
 33b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 33e:	8d 50 01             	lea    0x1(%eax),%edx
 341:	89 55 fc             	mov    %edx,-0x4(%ebp)
 344:	8b 55 f8             	mov    -0x8(%ebp),%edx
 347:	8d 4a 01             	lea    0x1(%edx),%ecx
 34a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 34d:	0f b6 12             	movzbl (%edx),%edx
 350:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 352:	8b 45 10             	mov    0x10(%ebp),%eax
 355:	8d 50 ff             	lea    -0x1(%eax),%edx
 358:	89 55 10             	mov    %edx,0x10(%ebp)
 35b:	85 c0                	test   %eax,%eax
 35d:	7f dc                	jg     33b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 35f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 362:	c9                   	leave  
 363:	c3                   	ret    

00000364 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 364:	b8 01 00 00 00       	mov    $0x1,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <exit>:
SYSCALL(exit)
 36c:	b8 02 00 00 00       	mov    $0x2,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <wait>:
SYSCALL(wait)
 374:	b8 03 00 00 00       	mov    $0x3,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <pipe>:
SYSCALL(pipe)
 37c:	b8 04 00 00 00       	mov    $0x4,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <read>:
SYSCALL(read)
 384:	b8 05 00 00 00       	mov    $0x5,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <write>:
SYSCALL(write)
 38c:	b8 10 00 00 00       	mov    $0x10,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <close>:
SYSCALL(close)
 394:	b8 15 00 00 00       	mov    $0x15,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <kill>:
SYSCALL(kill)
 39c:	b8 06 00 00 00       	mov    $0x6,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <exec>:
SYSCALL(exec)
 3a4:	b8 07 00 00 00       	mov    $0x7,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <open>:
SYSCALL(open)
 3ac:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <mknod>:
SYSCALL(mknod)
 3b4:	b8 11 00 00 00       	mov    $0x11,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <unlink>:
SYSCALL(unlink)
 3bc:	b8 12 00 00 00       	mov    $0x12,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <fstat>:
SYSCALL(fstat)
 3c4:	b8 08 00 00 00       	mov    $0x8,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <link>:
SYSCALL(link)
 3cc:	b8 13 00 00 00       	mov    $0x13,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <mkdir>:
SYSCALL(mkdir)
 3d4:	b8 14 00 00 00       	mov    $0x14,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <chdir>:
SYSCALL(chdir)
 3dc:	b8 09 00 00 00       	mov    $0x9,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <dup>:
SYSCALL(dup)
 3e4:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <getpid>:
SYSCALL(getpid)
 3ec:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <sbrk>:
SYSCALL(sbrk)
 3f4:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <sleep>:
SYSCALL(sleep)
 3fc:	b8 0d 00 00 00       	mov    $0xd,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <uptime>:
SYSCALL(uptime)
 404:	b8 0e 00 00 00       	mov    $0xe,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 40c:	55                   	push   %ebp
 40d:	89 e5                	mov    %esp,%ebp
 40f:	83 ec 18             	sub    $0x18,%esp
 412:	8b 45 0c             	mov    0xc(%ebp),%eax
 415:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 418:	83 ec 04             	sub    $0x4,%esp
 41b:	6a 01                	push   $0x1
 41d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 420:	50                   	push   %eax
 421:	ff 75 08             	pushl  0x8(%ebp)
 424:	e8 63 ff ff ff       	call   38c <write>
 429:	83 c4 10             	add    $0x10,%esp
}
 42c:	90                   	nop
 42d:	c9                   	leave  
 42e:	c3                   	ret    

0000042f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42f:	55                   	push   %ebp
 430:	89 e5                	mov    %esp,%ebp
 432:	53                   	push   %ebx
 433:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 436:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 43d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 441:	74 17                	je     45a <printint+0x2b>
 443:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 447:	79 11                	jns    45a <printint+0x2b>
    neg = 1;
 449:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 450:	8b 45 0c             	mov    0xc(%ebp),%eax
 453:	f7 d8                	neg    %eax
 455:	89 45 ec             	mov    %eax,-0x14(%ebp)
 458:	eb 06                	jmp    460 <printint+0x31>
  } else {
    x = xx;
 45a:	8b 45 0c             	mov    0xc(%ebp),%eax
 45d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 460:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 467:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 46a:	8d 41 01             	lea    0x1(%ecx),%eax
 46d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 470:	8b 5d 10             	mov    0x10(%ebp),%ebx
 473:	8b 45 ec             	mov    -0x14(%ebp),%eax
 476:	ba 00 00 00 00       	mov    $0x0,%edx
 47b:	f7 f3                	div    %ebx
 47d:	89 d0                	mov    %edx,%eax
 47f:	0f b6 80 48 0b 00 00 	movzbl 0xb48(%eax),%eax
 486:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 48a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 48d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 490:	ba 00 00 00 00       	mov    $0x0,%edx
 495:	f7 f3                	div    %ebx
 497:	89 45 ec             	mov    %eax,-0x14(%ebp)
 49a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49e:	75 c7                	jne    467 <printint+0x38>
  if(neg)
 4a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a4:	74 2d                	je     4d3 <printint+0xa4>
    buf[i++] = '-';
 4a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a9:	8d 50 01             	lea    0x1(%eax),%edx
 4ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4af:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4b4:	eb 1d                	jmp    4d3 <printint+0xa4>
    putc(fd, buf[i]);
 4b6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bc:	01 d0                	add    %edx,%eax
 4be:	0f b6 00             	movzbl (%eax),%eax
 4c1:	0f be c0             	movsbl %al,%eax
 4c4:	83 ec 08             	sub    $0x8,%esp
 4c7:	50                   	push   %eax
 4c8:	ff 75 08             	pushl  0x8(%ebp)
 4cb:	e8 3c ff ff ff       	call   40c <putc>
 4d0:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4d3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4db:	79 d9                	jns    4b6 <printint+0x87>
    putc(fd, buf[i]);
}
 4dd:	90                   	nop
 4de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4e1:	c9                   	leave  
 4e2:	c3                   	ret    

000004e3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4e3:	55                   	push   %ebp
 4e4:	89 e5                	mov    %esp,%ebp
 4e6:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4f0:	8d 45 0c             	lea    0xc(%ebp),%eax
 4f3:	83 c0 04             	add    $0x4,%eax
 4f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 500:	e9 59 01 00 00       	jmp    65e <printf+0x17b>
    c = fmt[i] & 0xff;
 505:	8b 55 0c             	mov    0xc(%ebp),%edx
 508:	8b 45 f0             	mov    -0x10(%ebp),%eax
 50b:	01 d0                	add    %edx,%eax
 50d:	0f b6 00             	movzbl (%eax),%eax
 510:	0f be c0             	movsbl %al,%eax
 513:	25 ff 00 00 00       	and    $0xff,%eax
 518:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 51b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 51f:	75 2c                	jne    54d <printf+0x6a>
      if(c == '%'){
 521:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 525:	75 0c                	jne    533 <printf+0x50>
        state = '%';
 527:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 52e:	e9 27 01 00 00       	jmp    65a <printf+0x177>
      } else {
        putc(fd, c);
 533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 536:	0f be c0             	movsbl %al,%eax
 539:	83 ec 08             	sub    $0x8,%esp
 53c:	50                   	push   %eax
 53d:	ff 75 08             	pushl  0x8(%ebp)
 540:	e8 c7 fe ff ff       	call   40c <putc>
 545:	83 c4 10             	add    $0x10,%esp
 548:	e9 0d 01 00 00       	jmp    65a <printf+0x177>
      }
    } else if(state == '%'){
 54d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 551:	0f 85 03 01 00 00    	jne    65a <printf+0x177>
      if(c == 'd'){
 557:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 55b:	75 1e                	jne    57b <printf+0x98>
        printint(fd, *ap, 10, 1);
 55d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 560:	8b 00                	mov    (%eax),%eax
 562:	6a 01                	push   $0x1
 564:	6a 0a                	push   $0xa
 566:	50                   	push   %eax
 567:	ff 75 08             	pushl  0x8(%ebp)
 56a:	e8 c0 fe ff ff       	call   42f <printint>
 56f:	83 c4 10             	add    $0x10,%esp
        ap++;
 572:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 576:	e9 d8 00 00 00       	jmp    653 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 57b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 57f:	74 06                	je     587 <printf+0xa4>
 581:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 585:	75 1e                	jne    5a5 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 587:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58a:	8b 00                	mov    (%eax),%eax
 58c:	6a 00                	push   $0x0
 58e:	6a 10                	push   $0x10
 590:	50                   	push   %eax
 591:	ff 75 08             	pushl  0x8(%ebp)
 594:	e8 96 fe ff ff       	call   42f <printint>
 599:	83 c4 10             	add    $0x10,%esp
        ap++;
 59c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a0:	e9 ae 00 00 00       	jmp    653 <printf+0x170>
      } else if(c == 's'){
 5a5:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5a9:	75 43                	jne    5ee <printf+0x10b>
        s = (char*)*ap;
 5ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ae:	8b 00                	mov    (%eax),%eax
 5b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5bb:	75 25                	jne    5e2 <printf+0xff>
          s = "(null)";
 5bd:	c7 45 f4 ee 08 00 00 	movl   $0x8ee,-0xc(%ebp)
        while(*s != 0){
 5c4:	eb 1c                	jmp    5e2 <printf+0xff>
          putc(fd, *s);
 5c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c9:	0f b6 00             	movzbl (%eax),%eax
 5cc:	0f be c0             	movsbl %al,%eax
 5cf:	83 ec 08             	sub    $0x8,%esp
 5d2:	50                   	push   %eax
 5d3:	ff 75 08             	pushl  0x8(%ebp)
 5d6:	e8 31 fe ff ff       	call   40c <putc>
 5db:	83 c4 10             	add    $0x10,%esp
          s++;
 5de:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e5:	0f b6 00             	movzbl (%eax),%eax
 5e8:	84 c0                	test   %al,%al
 5ea:	75 da                	jne    5c6 <printf+0xe3>
 5ec:	eb 65                	jmp    653 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ee:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5f2:	75 1d                	jne    611 <printf+0x12e>
        putc(fd, *ap);
 5f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f7:	8b 00                	mov    (%eax),%eax
 5f9:	0f be c0             	movsbl %al,%eax
 5fc:	83 ec 08             	sub    $0x8,%esp
 5ff:	50                   	push   %eax
 600:	ff 75 08             	pushl  0x8(%ebp)
 603:	e8 04 fe ff ff       	call   40c <putc>
 608:	83 c4 10             	add    $0x10,%esp
        ap++;
 60b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60f:	eb 42                	jmp    653 <printf+0x170>
      } else if(c == '%'){
 611:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 615:	75 17                	jne    62e <printf+0x14b>
        putc(fd, c);
 617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61a:	0f be c0             	movsbl %al,%eax
 61d:	83 ec 08             	sub    $0x8,%esp
 620:	50                   	push   %eax
 621:	ff 75 08             	pushl  0x8(%ebp)
 624:	e8 e3 fd ff ff       	call   40c <putc>
 629:	83 c4 10             	add    $0x10,%esp
 62c:	eb 25                	jmp    653 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 62e:	83 ec 08             	sub    $0x8,%esp
 631:	6a 25                	push   $0x25
 633:	ff 75 08             	pushl  0x8(%ebp)
 636:	e8 d1 fd ff ff       	call   40c <putc>
 63b:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 63e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 641:	0f be c0             	movsbl %al,%eax
 644:	83 ec 08             	sub    $0x8,%esp
 647:	50                   	push   %eax
 648:	ff 75 08             	pushl  0x8(%ebp)
 64b:	e8 bc fd ff ff       	call   40c <putc>
 650:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 653:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 65a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 65e:	8b 55 0c             	mov    0xc(%ebp),%edx
 661:	8b 45 f0             	mov    -0x10(%ebp),%eax
 664:	01 d0                	add    %edx,%eax
 666:	0f b6 00             	movzbl (%eax),%eax
 669:	84 c0                	test   %al,%al
 66b:	0f 85 94 fe ff ff    	jne    505 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 671:	90                   	nop
 672:	c9                   	leave  
 673:	c3                   	ret    

00000674 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 674:	55                   	push   %ebp
 675:	89 e5                	mov    %esp,%ebp
 677:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 67a:	8b 45 08             	mov    0x8(%ebp),%eax
 67d:	83 e8 08             	sub    $0x8,%eax
 680:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 683:	a1 64 0b 00 00       	mov    0xb64,%eax
 688:	89 45 fc             	mov    %eax,-0x4(%ebp)
 68b:	eb 24                	jmp    6b1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	8b 00                	mov    (%eax),%eax
 692:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 695:	77 12                	ja     6a9 <free+0x35>
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69d:	77 24                	ja     6c3 <free+0x4f>
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	8b 00                	mov    (%eax),%eax
 6a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a7:	77 1a                	ja     6c3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	8b 00                	mov    (%eax),%eax
 6ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b7:	76 d4                	jbe    68d <free+0x19>
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	8b 00                	mov    (%eax),%eax
 6be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c1:	76 ca                	jbe    68d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c6:	8b 40 04             	mov    0x4(%eax),%eax
 6c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d3:	01 c2                	add    %eax,%edx
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 00                	mov    (%eax),%eax
 6da:	39 c2                	cmp    %eax,%edx
 6dc:	75 24                	jne    702 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e1:	8b 50 04             	mov    0x4(%eax),%edx
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	8b 00                	mov    (%eax),%eax
 6e9:	8b 40 04             	mov    0x4(%eax),%eax
 6ec:	01 c2                	add    %eax,%edx
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	8b 00                	mov    (%eax),%eax
 6f9:	8b 10                	mov    (%eax),%edx
 6fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fe:	89 10                	mov    %edx,(%eax)
 700:	eb 0a                	jmp    70c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	8b 10                	mov    (%eax),%edx
 707:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	8b 40 04             	mov    0x4(%eax),%eax
 712:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 719:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71c:	01 d0                	add    %edx,%eax
 71e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 721:	75 20                	jne    743 <free+0xcf>
    p->s.size += bp->s.size;
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	8b 50 04             	mov    0x4(%eax),%edx
 729:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72c:	8b 40 04             	mov    0x4(%eax),%eax
 72f:	01 c2                	add    %eax,%edx
 731:	8b 45 fc             	mov    -0x4(%ebp),%eax
 734:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 737:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73a:	8b 10                	mov    (%eax),%edx
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	89 10                	mov    %edx,(%eax)
 741:	eb 08                	jmp    74b <free+0xd7>
  } else
    p->s.ptr = bp;
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	8b 55 f8             	mov    -0x8(%ebp),%edx
 749:	89 10                	mov    %edx,(%eax)
  freep = p;
 74b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74e:	a3 64 0b 00 00       	mov    %eax,0xb64
}
 753:	90                   	nop
 754:	c9                   	leave  
 755:	c3                   	ret    

00000756 <morecore>:

static Header*
morecore(uint nu)
{
 756:	55                   	push   %ebp
 757:	89 e5                	mov    %esp,%ebp
 759:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 75c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 763:	77 07                	ja     76c <morecore+0x16>
    nu = 4096;
 765:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 76c:	8b 45 08             	mov    0x8(%ebp),%eax
 76f:	c1 e0 03             	shl    $0x3,%eax
 772:	83 ec 0c             	sub    $0xc,%esp
 775:	50                   	push   %eax
 776:	e8 79 fc ff ff       	call   3f4 <sbrk>
 77b:	83 c4 10             	add    $0x10,%esp
 77e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 781:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 785:	75 07                	jne    78e <morecore+0x38>
    return 0;
 787:	b8 00 00 00 00       	mov    $0x0,%eax
 78c:	eb 26                	jmp    7b4 <morecore+0x5e>
  hp = (Header*)p;
 78e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 791:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 794:	8b 45 f0             	mov    -0x10(%ebp),%eax
 797:	8b 55 08             	mov    0x8(%ebp),%edx
 79a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 79d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a0:	83 c0 08             	add    $0x8,%eax
 7a3:	83 ec 0c             	sub    $0xc,%esp
 7a6:	50                   	push   %eax
 7a7:	e8 c8 fe ff ff       	call   674 <free>
 7ac:	83 c4 10             	add    $0x10,%esp
  return freep;
 7af:	a1 64 0b 00 00       	mov    0xb64,%eax
}
 7b4:	c9                   	leave  
 7b5:	c3                   	ret    

000007b6 <malloc>:

void*
malloc(uint nbytes)
{
 7b6:	55                   	push   %ebp
 7b7:	89 e5                	mov    %esp,%ebp
 7b9:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7bc:	8b 45 08             	mov    0x8(%ebp),%eax
 7bf:	83 c0 07             	add    $0x7,%eax
 7c2:	c1 e8 03             	shr    $0x3,%eax
 7c5:	83 c0 01             	add    $0x1,%eax
 7c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7cb:	a1 64 0b 00 00       	mov    0xb64,%eax
 7d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7d7:	75 23                	jne    7fc <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7d9:	c7 45 f0 5c 0b 00 00 	movl   $0xb5c,-0x10(%ebp)
 7e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e3:	a3 64 0b 00 00       	mov    %eax,0xb64
 7e8:	a1 64 0b 00 00       	mov    0xb64,%eax
 7ed:	a3 5c 0b 00 00       	mov    %eax,0xb5c
    base.s.size = 0;
 7f2:	c7 05 60 0b 00 00 00 	movl   $0x0,0xb60
 7f9:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ff:	8b 00                	mov    (%eax),%eax
 801:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 804:	8b 45 f4             	mov    -0xc(%ebp),%eax
 807:	8b 40 04             	mov    0x4(%eax),%eax
 80a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 80d:	72 4d                	jb     85c <malloc+0xa6>
      if(p->s.size == nunits)
 80f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 812:	8b 40 04             	mov    0x4(%eax),%eax
 815:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 818:	75 0c                	jne    826 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 81a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81d:	8b 10                	mov    (%eax),%edx
 81f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 822:	89 10                	mov    %edx,(%eax)
 824:	eb 26                	jmp    84c <malloc+0x96>
      else {
        p->s.size -= nunits;
 826:	8b 45 f4             	mov    -0xc(%ebp),%eax
 829:	8b 40 04             	mov    0x4(%eax),%eax
 82c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 82f:	89 c2                	mov    %eax,%edx
 831:	8b 45 f4             	mov    -0xc(%ebp),%eax
 834:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 837:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83a:	8b 40 04             	mov    0x4(%eax),%eax
 83d:	c1 e0 03             	shl    $0x3,%eax
 840:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	8b 55 ec             	mov    -0x14(%ebp),%edx
 849:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 84c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84f:	a3 64 0b 00 00       	mov    %eax,0xb64
      return (void*)(p + 1);
 854:	8b 45 f4             	mov    -0xc(%ebp),%eax
 857:	83 c0 08             	add    $0x8,%eax
 85a:	eb 3b                	jmp    897 <malloc+0xe1>
    }
    if(p == freep)
 85c:	a1 64 0b 00 00       	mov    0xb64,%eax
 861:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 864:	75 1e                	jne    884 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 866:	83 ec 0c             	sub    $0xc,%esp
 869:	ff 75 ec             	pushl  -0x14(%ebp)
 86c:	e8 e5 fe ff ff       	call   756 <morecore>
 871:	83 c4 10             	add    $0x10,%esp
 874:	89 45 f4             	mov    %eax,-0xc(%ebp)
 877:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 87b:	75 07                	jne    884 <malloc+0xce>
        return 0;
 87d:	b8 00 00 00 00       	mov    $0x0,%eax
 882:	eb 13                	jmp    897 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 884:	8b 45 f4             	mov    -0xc(%ebp),%eax
 887:	89 45 f0             	mov    %eax,-0x10(%ebp)
 88a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88d:	8b 00                	mov    (%eax),%eax
 88f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 892:	e9 6d ff ff ff       	jmp    804 <malloc+0x4e>
}
 897:	c9                   	leave  
 898:	c3                   	ret    
