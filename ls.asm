
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	83 ec 0c             	sub    $0xc,%esp
   a:	ff 75 08             	pushl  0x8(%ebp)
   d:	e8 cf 03 00 00       	call   3e1 <strlen>
  12:	83 c4 10             	add    $0x10,%esp
  15:	89 c2                	mov    %eax,%edx
  17:	8b 45 08             	mov    0x8(%ebp),%eax
  1a:	01 d0                	add    %edx,%eax
  1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1f:	eb 04                	jmp    25 <fmtname+0x25>
  21:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28:	3b 45 08             	cmp    0x8(%ebp),%eax
  2b:	72 0a                	jb     37 <fmtname+0x37>
  2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  30:	0f b6 00             	movzbl (%eax),%eax
  33:	3c 2f                	cmp    $0x2f,%al
  35:	75 ea                	jne    21 <fmtname+0x21>
    ;
  p++;
  37:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3b:	83 ec 0c             	sub    $0xc,%esp
  3e:	ff 75 f4             	pushl  -0xc(%ebp)
  41:	e8 9b 03 00 00       	call   3e1 <strlen>
  46:	83 c4 10             	add    $0x10,%esp
  49:	83 f8 0d             	cmp    $0xd,%eax
  4c:	76 05                	jbe    53 <fmtname+0x53>
    return p;
  4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  51:	eb 60                	jmp    b3 <fmtname+0xb3>
  memmove(buf, p, strlen(p));
  53:	83 ec 0c             	sub    $0xc,%esp
  56:	ff 75 f4             	pushl  -0xc(%ebp)
  59:	e8 83 03 00 00       	call   3e1 <strlen>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	83 ec 04             	sub    $0x4,%esp
  64:	50                   	push   %eax
  65:	ff 75 f4             	pushl  -0xc(%ebp)
  68:	68 d8 0d 00 00       	push   $0xdd8
  6d:	e8 ec 04 00 00       	call   55e <memmove>
  72:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  75:	83 ec 0c             	sub    $0xc,%esp
  78:	ff 75 f4             	pushl  -0xc(%ebp)
  7b:	e8 61 03 00 00       	call   3e1 <strlen>
  80:	83 c4 10             	add    $0x10,%esp
  83:	ba 0e 00 00 00       	mov    $0xe,%edx
  88:	89 d3                	mov    %edx,%ebx
  8a:	29 c3                	sub    %eax,%ebx
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	ff 75 f4             	pushl  -0xc(%ebp)
  92:	e8 4a 03 00 00       	call   3e1 <strlen>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	05 d8 0d 00 00       	add    $0xdd8,%eax
  9f:	83 ec 04             	sub    $0x4,%esp
  a2:	53                   	push   %ebx
  a3:	6a 20                	push   $0x20
  a5:	50                   	push   %eax
  a6:	e8 5d 03 00 00       	call   408 <memset>
  ab:	83 c4 10             	add    $0x10,%esp
  return buf;
  ae:	b8 d8 0d 00 00       	mov    $0xdd8,%eax
}
  b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b6:	c9                   	leave  
  b7:	c3                   	ret    

000000b8 <ls>:

void
ls(char *path)
{
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	57                   	push   %edi
  bc:	56                   	push   %esi
  bd:	53                   	push   %ebx
  be:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  c4:	83 ec 08             	sub    $0x8,%esp
  c7:	6a 00                	push   $0x0
  c9:	ff 75 08             	pushl  0x8(%ebp)
  cc:	e8 12 05 00 00       	call   5e3 <open>
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  db:	79 1a                	jns    f7 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
  dd:	83 ec 04             	sub    $0x4,%esp
  e0:	ff 75 08             	pushl  0x8(%ebp)
  e3:	68 d0 0a 00 00       	push   $0xad0
  e8:	6a 02                	push   $0x2
  ea:	e8 2b 06 00 00       	call   71a <printf>
  ef:	83 c4 10             	add    $0x10,%esp
    return;
  f2:	e9 e9 01 00 00       	jmp    2e0 <ls+0x228>
  }
  
  if(fstat(fd, &st) < 0){
  f7:	83 ec 08             	sub    $0x8,%esp
  fa:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 100:	50                   	push   %eax
 101:	ff 75 e4             	pushl  -0x1c(%ebp)
 104:	e8 f2 04 00 00       	call   5fb <fstat>
 109:	83 c4 10             	add    $0x10,%esp
 10c:	85 c0                	test   %eax,%eax
 10e:	79 28                	jns    138 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 110:	83 ec 04             	sub    $0x4,%esp
 113:	ff 75 08             	pushl  0x8(%ebp)
 116:	68 e4 0a 00 00       	push   $0xae4
 11b:	6a 02                	push   $0x2
 11d:	e8 f8 05 00 00       	call   71a <printf>
 122:	83 c4 10             	add    $0x10,%esp
    close(fd);
 125:	83 ec 0c             	sub    $0xc,%esp
 128:	ff 75 e4             	pushl  -0x1c(%ebp)
 12b:	e8 9b 04 00 00       	call   5cb <close>
 130:	83 c4 10             	add    $0x10,%esp
    return;
 133:	e9 a8 01 00 00       	jmp    2e0 <ls+0x228>
  }
  
  switch(st.type){
 138:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 13f:	98                   	cwtl   
 140:	83 f8 02             	cmp    $0x2,%eax
 143:	74 0f                	je     154 <ls+0x9c>
 145:	83 f8 03             	cmp    $0x3,%eax
 148:	74 49                	je     193 <ls+0xdb>
 14a:	83 f8 01             	cmp    $0x1,%eax
 14d:	74 44                	je     193 <ls+0xdb>
 14f:	e9 7e 01 00 00       	jmp    2d2 <ls+0x21a>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 154:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 15a:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 160:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 167:	0f bf d8             	movswl %ax,%ebx
 16a:	83 ec 0c             	sub    $0xc,%esp
 16d:	ff 75 08             	pushl  0x8(%ebp)
 170:	e8 8b fe ff ff       	call   0 <fmtname>
 175:	83 c4 10             	add    $0x10,%esp
 178:	83 ec 08             	sub    $0x8,%esp
 17b:	57                   	push   %edi
 17c:	56                   	push   %esi
 17d:	53                   	push   %ebx
 17e:	50                   	push   %eax
 17f:	68 f8 0a 00 00       	push   $0xaf8
 184:	6a 01                	push   $0x1
 186:	e8 8f 05 00 00       	call   71a <printf>
 18b:	83 c4 20             	add    $0x20,%esp
    break;
 18e:	e9 3f 01 00 00       	jmp    2d2 <ls+0x21a>

  case T_DEV:
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 193:	83 ec 0c             	sub    $0xc,%esp
 196:	ff 75 08             	pushl  0x8(%ebp)
 199:	e8 43 02 00 00       	call   3e1 <strlen>
 19e:	83 c4 10             	add    $0x10,%esp
 1a1:	83 c0 10             	add    $0x10,%eax
 1a4:	3d 00 02 00 00       	cmp    $0x200,%eax
 1a9:	76 17                	jbe    1c2 <ls+0x10a>
      printf(1, "ls: path too long\n");
 1ab:	83 ec 08             	sub    $0x8,%esp
 1ae:	68 05 0b 00 00       	push   $0xb05
 1b3:	6a 01                	push   $0x1
 1b5:	e8 60 05 00 00       	call   71a <printf>
 1ba:	83 c4 10             	add    $0x10,%esp
      break;
 1bd:	e9 10 01 00 00       	jmp    2d2 <ls+0x21a>
    }
    strcpy(buf, path);
 1c2:	83 ec 08             	sub    $0x8,%esp
 1c5:	ff 75 08             	pushl  0x8(%ebp)
 1c8:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1ce:	50                   	push   %eax
 1cf:	e8 9e 01 00 00       	call   372 <strcpy>
 1d4:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1d7:	83 ec 0c             	sub    $0xc,%esp
 1da:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1e0:	50                   	push   %eax
 1e1:	e8 fb 01 00 00       	call   3e1 <strlen>
 1e6:	83 c4 10             	add    $0x10,%esp
 1e9:	89 c2                	mov    %eax,%edx
 1eb:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1f1:	01 d0                	add    %edx,%eax
 1f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1f9:	8d 50 01             	lea    0x1(%eax),%edx
 1fc:	89 55 e0             	mov    %edx,-0x20(%ebp)
 1ff:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 202:	e9 aa 00 00 00       	jmp    2b1 <ls+0x1f9>
      if(de.inum == 0)
 207:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 20e:	66 85 c0             	test   %ax,%ax
 211:	75 05                	jne    218 <ls+0x160>
        continue;
 213:	e9 99 00 00 00       	jmp    2b1 <ls+0x1f9>
      memmove(p, de.name, DIRSIZ);
 218:	83 ec 04             	sub    $0x4,%esp
 21b:	6a 0e                	push   $0xe
 21d:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 223:	83 c0 02             	add    $0x2,%eax
 226:	50                   	push   %eax
 227:	ff 75 e0             	pushl  -0x20(%ebp)
 22a:	e8 2f 03 00 00       	call   55e <memmove>
 22f:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 232:	8b 45 e0             	mov    -0x20(%ebp),%eax
 235:	83 c0 0e             	add    $0xe,%eax
 238:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 23b:	83 ec 08             	sub    $0x8,%esp
 23e:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 244:	50                   	push   %eax
 245:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 24b:	50                   	push   %eax
 24c:	e8 73 02 00 00       	call   4c4 <stat>
 251:	83 c4 10             	add    $0x10,%esp
 254:	85 c0                	test   %eax,%eax
 256:	79 1b                	jns    273 <ls+0x1bb>
        printf(1, "ls: cannot stat %s\n", buf);
 258:	83 ec 04             	sub    $0x4,%esp
 25b:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 261:	50                   	push   %eax
 262:	68 e4 0a 00 00       	push   $0xae4
 267:	6a 01                	push   $0x1
 269:	e8 ac 04 00 00       	call   71a <printf>
 26e:	83 c4 10             	add    $0x10,%esp
        continue;
 271:	eb 3e                	jmp    2b1 <ls+0x1f9>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 273:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 279:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 27f:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 286:	0f bf d8             	movswl %ax,%ebx
 289:	83 ec 0c             	sub    $0xc,%esp
 28c:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 292:	50                   	push   %eax
 293:	e8 68 fd ff ff       	call   0 <fmtname>
 298:	83 c4 10             	add    $0x10,%esp
 29b:	83 ec 08             	sub    $0x8,%esp
 29e:	57                   	push   %edi
 29f:	56                   	push   %esi
 2a0:	53                   	push   %ebx
 2a1:	50                   	push   %eax
 2a2:	68 f8 0a 00 00       	push   $0xaf8
 2a7:	6a 01                	push   $0x1
 2a9:	e8 6c 04 00 00       	call   71a <printf>
 2ae:	83 c4 20             	add    $0x20,%esp
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2b1:	83 ec 04             	sub    $0x4,%esp
 2b4:	6a 10                	push   $0x10
 2b6:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2bc:	50                   	push   %eax
 2bd:	ff 75 e4             	pushl  -0x1c(%ebp)
 2c0:	e8 f6 02 00 00       	call   5bb <read>
 2c5:	83 c4 10             	add    $0x10,%esp
 2c8:	83 f8 10             	cmp    $0x10,%eax
 2cb:	0f 84 36 ff ff ff    	je     207 <ls+0x14f>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
 2d1:	90                   	nop
  }
  close(fd);
 2d2:	83 ec 0c             	sub    $0xc,%esp
 2d5:	ff 75 e4             	pushl  -0x1c(%ebp)
 2d8:	e8 ee 02 00 00       	call   5cb <close>
 2dd:	83 c4 10             	add    $0x10,%esp
}
 2e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2e3:	5b                   	pop    %ebx
 2e4:	5e                   	pop    %esi
 2e5:	5f                   	pop    %edi
 2e6:	5d                   	pop    %ebp
 2e7:	c3                   	ret    

000002e8 <main>:

int
main(int argc, char *argv[])
{
 2e8:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 2ec:	83 e4 f0             	and    $0xfffffff0,%esp
 2ef:	ff 71 fc             	pushl  -0x4(%ecx)
 2f2:	55                   	push   %ebp
 2f3:	89 e5                	mov    %esp,%ebp
 2f5:	53                   	push   %ebx
 2f6:	51                   	push   %ecx
 2f7:	83 ec 10             	sub    $0x10,%esp
 2fa:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
 2fc:	83 3b 01             	cmpl   $0x1,(%ebx)
 2ff:	7f 15                	jg     316 <main+0x2e>
    ls(".");
 301:	83 ec 0c             	sub    $0xc,%esp
 304:	68 18 0b 00 00       	push   $0xb18
 309:	e8 aa fd ff ff       	call   b8 <ls>
 30e:	83 c4 10             	add    $0x10,%esp
    exit();
 311:	e8 8d 02 00 00       	call   5a3 <exit>
  }
  for(i=1; i<argc; i++)
 316:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 31d:	eb 21                	jmp    340 <main+0x58>
    ls(argv[i]);
 31f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 322:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 329:	8b 43 04             	mov    0x4(%ebx),%eax
 32c:	01 d0                	add    %edx,%eax
 32e:	8b 00                	mov    (%eax),%eax
 330:	83 ec 0c             	sub    $0xc,%esp
 333:	50                   	push   %eax
 334:	e8 7f fd ff ff       	call   b8 <ls>
 339:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 33c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 340:	8b 45 f4             	mov    -0xc(%ebp),%eax
 343:	3b 03                	cmp    (%ebx),%eax
 345:	7c d8                	jl     31f <main+0x37>
    ls(argv[i]);
  exit();
 347:	e8 57 02 00 00       	call   5a3 <exit>

0000034c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 34c:	55                   	push   %ebp
 34d:	89 e5                	mov    %esp,%ebp
 34f:	57                   	push   %edi
 350:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 351:	8b 4d 08             	mov    0x8(%ebp),%ecx
 354:	8b 55 10             	mov    0x10(%ebp),%edx
 357:	8b 45 0c             	mov    0xc(%ebp),%eax
 35a:	89 cb                	mov    %ecx,%ebx
 35c:	89 df                	mov    %ebx,%edi
 35e:	89 d1                	mov    %edx,%ecx
 360:	fc                   	cld    
 361:	f3 aa                	rep stos %al,%es:(%edi)
 363:	89 ca                	mov    %ecx,%edx
 365:	89 fb                	mov    %edi,%ebx
 367:	89 5d 08             	mov    %ebx,0x8(%ebp)
 36a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 36d:	90                   	nop
 36e:	5b                   	pop    %ebx
 36f:	5f                   	pop    %edi
 370:	5d                   	pop    %ebp
 371:	c3                   	ret    

00000372 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 372:	55                   	push   %ebp
 373:	89 e5                	mov    %esp,%ebp
 375:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 378:	8b 45 08             	mov    0x8(%ebp),%eax
 37b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 37e:	90                   	nop
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
 382:	8d 50 01             	lea    0x1(%eax),%edx
 385:	89 55 08             	mov    %edx,0x8(%ebp)
 388:	8b 55 0c             	mov    0xc(%ebp),%edx
 38b:	8d 4a 01             	lea    0x1(%edx),%ecx
 38e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 391:	0f b6 12             	movzbl (%edx),%edx
 394:	88 10                	mov    %dl,(%eax)
 396:	0f b6 00             	movzbl (%eax),%eax
 399:	84 c0                	test   %al,%al
 39b:	75 e2                	jne    37f <strcpy+0xd>
    ;
  return os;
 39d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3a0:	c9                   	leave  
 3a1:	c3                   	ret    

000003a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3a2:	55                   	push   %ebp
 3a3:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3a5:	eb 08                	jmp    3af <strcmp+0xd>
    p++, q++;
 3a7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3ab:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3af:	8b 45 08             	mov    0x8(%ebp),%eax
 3b2:	0f b6 00             	movzbl (%eax),%eax
 3b5:	84 c0                	test   %al,%al
 3b7:	74 10                	je     3c9 <strcmp+0x27>
 3b9:	8b 45 08             	mov    0x8(%ebp),%eax
 3bc:	0f b6 10             	movzbl (%eax),%edx
 3bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c2:	0f b6 00             	movzbl (%eax),%eax
 3c5:	38 c2                	cmp    %al,%dl
 3c7:	74 de                	je     3a7 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
 3cc:	0f b6 00             	movzbl (%eax),%eax
 3cf:	0f b6 d0             	movzbl %al,%edx
 3d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d5:	0f b6 00             	movzbl (%eax),%eax
 3d8:	0f b6 c0             	movzbl %al,%eax
 3db:	29 c2                	sub    %eax,%edx
 3dd:	89 d0                	mov    %edx,%eax
}
 3df:	5d                   	pop    %ebp
 3e0:	c3                   	ret    

000003e1 <strlen>:

uint
strlen(char *s)
{
 3e1:	55                   	push   %ebp
 3e2:	89 e5                	mov    %esp,%ebp
 3e4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3ee:	eb 04                	jmp    3f4 <strlen+0x13>
 3f0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f7:	8b 45 08             	mov    0x8(%ebp),%eax
 3fa:	01 d0                	add    %edx,%eax
 3fc:	0f b6 00             	movzbl (%eax),%eax
 3ff:	84 c0                	test   %al,%al
 401:	75 ed                	jne    3f0 <strlen+0xf>
    ;
  return n;
 403:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 406:	c9                   	leave  
 407:	c3                   	ret    

00000408 <memset>:

void*
memset(void *dst, int c, uint n)
{
 408:	55                   	push   %ebp
 409:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 40b:	8b 45 10             	mov    0x10(%ebp),%eax
 40e:	50                   	push   %eax
 40f:	ff 75 0c             	pushl  0xc(%ebp)
 412:	ff 75 08             	pushl  0x8(%ebp)
 415:	e8 32 ff ff ff       	call   34c <stosb>
 41a:	83 c4 0c             	add    $0xc,%esp
  return dst;
 41d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 420:	c9                   	leave  
 421:	c3                   	ret    

00000422 <strchr>:

char*
strchr(const char *s, char c)
{
 422:	55                   	push   %ebp
 423:	89 e5                	mov    %esp,%ebp
 425:	83 ec 04             	sub    $0x4,%esp
 428:	8b 45 0c             	mov    0xc(%ebp),%eax
 42b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 42e:	eb 14                	jmp    444 <strchr+0x22>
    if(*s == c)
 430:	8b 45 08             	mov    0x8(%ebp),%eax
 433:	0f b6 00             	movzbl (%eax),%eax
 436:	3a 45 fc             	cmp    -0x4(%ebp),%al
 439:	75 05                	jne    440 <strchr+0x1e>
      return (char*)s;
 43b:	8b 45 08             	mov    0x8(%ebp),%eax
 43e:	eb 13                	jmp    453 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 440:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 444:	8b 45 08             	mov    0x8(%ebp),%eax
 447:	0f b6 00             	movzbl (%eax),%eax
 44a:	84 c0                	test   %al,%al
 44c:	75 e2                	jne    430 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 44e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 453:	c9                   	leave  
 454:	c3                   	ret    

00000455 <gets>:

char*
gets(char *buf, int max)
{
 455:	55                   	push   %ebp
 456:	89 e5                	mov    %esp,%ebp
 458:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 45b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 462:	eb 42                	jmp    4a6 <gets+0x51>
    cc = read(0, &c, 1);
 464:	83 ec 04             	sub    $0x4,%esp
 467:	6a 01                	push   $0x1
 469:	8d 45 ef             	lea    -0x11(%ebp),%eax
 46c:	50                   	push   %eax
 46d:	6a 00                	push   $0x0
 46f:	e8 47 01 00 00       	call   5bb <read>
 474:	83 c4 10             	add    $0x10,%esp
 477:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 47a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 47e:	7e 33                	jle    4b3 <gets+0x5e>
      break;
    buf[i++] = c;
 480:	8b 45 f4             	mov    -0xc(%ebp),%eax
 483:	8d 50 01             	lea    0x1(%eax),%edx
 486:	89 55 f4             	mov    %edx,-0xc(%ebp)
 489:	89 c2                	mov    %eax,%edx
 48b:	8b 45 08             	mov    0x8(%ebp),%eax
 48e:	01 c2                	add    %eax,%edx
 490:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 494:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 496:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 49a:	3c 0a                	cmp    $0xa,%al
 49c:	74 16                	je     4b4 <gets+0x5f>
 49e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4a2:	3c 0d                	cmp    $0xd,%al
 4a4:	74 0e                	je     4b4 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a9:	83 c0 01             	add    $0x1,%eax
 4ac:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4af:	7c b3                	jl     464 <gets+0xf>
 4b1:	eb 01                	jmp    4b4 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4b3:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4b7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ba:	01 d0                	add    %edx,%eax
 4bc:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4c2:	c9                   	leave  
 4c3:	c3                   	ret    

000004c4 <stat>:

int
stat(char *n, struct stat *st)
{
 4c4:	55                   	push   %ebp
 4c5:	89 e5                	mov    %esp,%ebp
 4c7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4ca:	83 ec 08             	sub    $0x8,%esp
 4cd:	6a 00                	push   $0x0
 4cf:	ff 75 08             	pushl  0x8(%ebp)
 4d2:	e8 0c 01 00 00       	call   5e3 <open>
 4d7:	83 c4 10             	add    $0x10,%esp
 4da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e1:	79 07                	jns    4ea <stat+0x26>
    return -1;
 4e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4e8:	eb 25                	jmp    50f <stat+0x4b>
  r = fstat(fd, st);
 4ea:	83 ec 08             	sub    $0x8,%esp
 4ed:	ff 75 0c             	pushl  0xc(%ebp)
 4f0:	ff 75 f4             	pushl  -0xc(%ebp)
 4f3:	e8 03 01 00 00       	call   5fb <fstat>
 4f8:	83 c4 10             	add    $0x10,%esp
 4fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4fe:	83 ec 0c             	sub    $0xc,%esp
 501:	ff 75 f4             	pushl  -0xc(%ebp)
 504:	e8 c2 00 00 00       	call   5cb <close>
 509:	83 c4 10             	add    $0x10,%esp
  return r;
 50c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 50f:	c9                   	leave  
 510:	c3                   	ret    

00000511 <atoi>:

int
atoi(const char *s)
{
 511:	55                   	push   %ebp
 512:	89 e5                	mov    %esp,%ebp
 514:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 517:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 51e:	eb 25                	jmp    545 <atoi+0x34>
    n = n*10 + *s++ - '0';
 520:	8b 55 fc             	mov    -0x4(%ebp),%edx
 523:	89 d0                	mov    %edx,%eax
 525:	c1 e0 02             	shl    $0x2,%eax
 528:	01 d0                	add    %edx,%eax
 52a:	01 c0                	add    %eax,%eax
 52c:	89 c1                	mov    %eax,%ecx
 52e:	8b 45 08             	mov    0x8(%ebp),%eax
 531:	8d 50 01             	lea    0x1(%eax),%edx
 534:	89 55 08             	mov    %edx,0x8(%ebp)
 537:	0f b6 00             	movzbl (%eax),%eax
 53a:	0f be c0             	movsbl %al,%eax
 53d:	01 c8                	add    %ecx,%eax
 53f:	83 e8 30             	sub    $0x30,%eax
 542:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 545:	8b 45 08             	mov    0x8(%ebp),%eax
 548:	0f b6 00             	movzbl (%eax),%eax
 54b:	3c 2f                	cmp    $0x2f,%al
 54d:	7e 0a                	jle    559 <atoi+0x48>
 54f:	8b 45 08             	mov    0x8(%ebp),%eax
 552:	0f b6 00             	movzbl (%eax),%eax
 555:	3c 39                	cmp    $0x39,%al
 557:	7e c7                	jle    520 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 559:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 55c:	c9                   	leave  
 55d:	c3                   	ret    

0000055e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 55e:	55                   	push   %ebp
 55f:	89 e5                	mov    %esp,%ebp
 561:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 564:	8b 45 08             	mov    0x8(%ebp),%eax
 567:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 56a:	8b 45 0c             	mov    0xc(%ebp),%eax
 56d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 570:	eb 17                	jmp    589 <memmove+0x2b>
    *dst++ = *src++;
 572:	8b 45 fc             	mov    -0x4(%ebp),%eax
 575:	8d 50 01             	lea    0x1(%eax),%edx
 578:	89 55 fc             	mov    %edx,-0x4(%ebp)
 57b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 57e:	8d 4a 01             	lea    0x1(%edx),%ecx
 581:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 584:	0f b6 12             	movzbl (%edx),%edx
 587:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 589:	8b 45 10             	mov    0x10(%ebp),%eax
 58c:	8d 50 ff             	lea    -0x1(%eax),%edx
 58f:	89 55 10             	mov    %edx,0x10(%ebp)
 592:	85 c0                	test   %eax,%eax
 594:	7f dc                	jg     572 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 596:	8b 45 08             	mov    0x8(%ebp),%eax
}
 599:	c9                   	leave  
 59a:	c3                   	ret    

0000059b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 59b:	b8 01 00 00 00       	mov    $0x1,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <exit>:
SYSCALL(exit)
 5a3:	b8 02 00 00 00       	mov    $0x2,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <wait>:
SYSCALL(wait)
 5ab:	b8 03 00 00 00       	mov    $0x3,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <pipe>:
SYSCALL(pipe)
 5b3:	b8 04 00 00 00       	mov    $0x4,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <read>:
SYSCALL(read)
 5bb:	b8 05 00 00 00       	mov    $0x5,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <write>:
SYSCALL(write)
 5c3:	b8 10 00 00 00       	mov    $0x10,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <close>:
SYSCALL(close)
 5cb:	b8 15 00 00 00       	mov    $0x15,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <kill>:
SYSCALL(kill)
 5d3:	b8 06 00 00 00       	mov    $0x6,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <exec>:
SYSCALL(exec)
 5db:	b8 07 00 00 00       	mov    $0x7,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <open>:
SYSCALL(open)
 5e3:	b8 0f 00 00 00       	mov    $0xf,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <mknod>:
SYSCALL(mknod)
 5eb:	b8 11 00 00 00       	mov    $0x11,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <unlink>:
SYSCALL(unlink)
 5f3:	b8 12 00 00 00       	mov    $0x12,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <fstat>:
SYSCALL(fstat)
 5fb:	b8 08 00 00 00       	mov    $0x8,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <link>:
SYSCALL(link)
 603:	b8 13 00 00 00       	mov    $0x13,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <mkdir>:
SYSCALL(mkdir)
 60b:	b8 14 00 00 00       	mov    $0x14,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <chdir>:
SYSCALL(chdir)
 613:	b8 09 00 00 00       	mov    $0x9,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <dup>:
SYSCALL(dup)
 61b:	b8 0a 00 00 00       	mov    $0xa,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <getpid>:
SYSCALL(getpid)
 623:	b8 0b 00 00 00       	mov    $0xb,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <sbrk>:
SYSCALL(sbrk)
 62b:	b8 0c 00 00 00       	mov    $0xc,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <sleep>:
SYSCALL(sleep)
 633:	b8 0d 00 00 00       	mov    $0xd,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <uptime>:
SYSCALL(uptime)
 63b:	b8 0e 00 00 00       	mov    $0xe,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 643:	55                   	push   %ebp
 644:	89 e5                	mov    %esp,%ebp
 646:	83 ec 18             	sub    $0x18,%esp
 649:	8b 45 0c             	mov    0xc(%ebp),%eax
 64c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 64f:	83 ec 04             	sub    $0x4,%esp
 652:	6a 01                	push   $0x1
 654:	8d 45 f4             	lea    -0xc(%ebp),%eax
 657:	50                   	push   %eax
 658:	ff 75 08             	pushl  0x8(%ebp)
 65b:	e8 63 ff ff ff       	call   5c3 <write>
 660:	83 c4 10             	add    $0x10,%esp
}
 663:	90                   	nop
 664:	c9                   	leave  
 665:	c3                   	ret    

00000666 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 666:	55                   	push   %ebp
 667:	89 e5                	mov    %esp,%ebp
 669:	53                   	push   %ebx
 66a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 66d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 674:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 678:	74 17                	je     691 <printint+0x2b>
 67a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 67e:	79 11                	jns    691 <printint+0x2b>
    neg = 1;
 680:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 687:	8b 45 0c             	mov    0xc(%ebp),%eax
 68a:	f7 d8                	neg    %eax
 68c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 68f:	eb 06                	jmp    697 <printint+0x31>
  } else {
    x = xx;
 691:	8b 45 0c             	mov    0xc(%ebp),%eax
 694:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 697:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 69e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6a1:	8d 41 01             	lea    0x1(%ecx),%eax
 6a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6ad:	ba 00 00 00 00       	mov    $0x0,%edx
 6b2:	f7 f3                	div    %ebx
 6b4:	89 d0                	mov    %edx,%eax
 6b6:	0f b6 80 c4 0d 00 00 	movzbl 0xdc4(%eax),%eax
 6bd:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6c7:	ba 00 00 00 00       	mov    $0x0,%edx
 6cc:	f7 f3                	div    %ebx
 6ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6d5:	75 c7                	jne    69e <printint+0x38>
  if(neg)
 6d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6db:	74 2d                	je     70a <printint+0xa4>
    buf[i++] = '-';
 6dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e0:	8d 50 01             	lea    0x1(%eax),%edx
 6e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6e6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6eb:	eb 1d                	jmp    70a <printint+0xa4>
    putc(fd, buf[i]);
 6ed:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f3:	01 d0                	add    %edx,%eax
 6f5:	0f b6 00             	movzbl (%eax),%eax
 6f8:	0f be c0             	movsbl %al,%eax
 6fb:	83 ec 08             	sub    $0x8,%esp
 6fe:	50                   	push   %eax
 6ff:	ff 75 08             	pushl  0x8(%ebp)
 702:	e8 3c ff ff ff       	call   643 <putc>
 707:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 70a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 70e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 712:	79 d9                	jns    6ed <printint+0x87>
    putc(fd, buf[i]);
}
 714:	90                   	nop
 715:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 718:	c9                   	leave  
 719:	c3                   	ret    

0000071a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 71a:	55                   	push   %ebp
 71b:	89 e5                	mov    %esp,%ebp
 71d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 720:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 727:	8d 45 0c             	lea    0xc(%ebp),%eax
 72a:	83 c0 04             	add    $0x4,%eax
 72d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 730:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 737:	e9 59 01 00 00       	jmp    895 <printf+0x17b>
    c = fmt[i] & 0xff;
 73c:	8b 55 0c             	mov    0xc(%ebp),%edx
 73f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 742:	01 d0                	add    %edx,%eax
 744:	0f b6 00             	movzbl (%eax),%eax
 747:	0f be c0             	movsbl %al,%eax
 74a:	25 ff 00 00 00       	and    $0xff,%eax
 74f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 752:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 756:	75 2c                	jne    784 <printf+0x6a>
      if(c == '%'){
 758:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 75c:	75 0c                	jne    76a <printf+0x50>
        state = '%';
 75e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 765:	e9 27 01 00 00       	jmp    891 <printf+0x177>
      } else {
        putc(fd, c);
 76a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 76d:	0f be c0             	movsbl %al,%eax
 770:	83 ec 08             	sub    $0x8,%esp
 773:	50                   	push   %eax
 774:	ff 75 08             	pushl  0x8(%ebp)
 777:	e8 c7 fe ff ff       	call   643 <putc>
 77c:	83 c4 10             	add    $0x10,%esp
 77f:	e9 0d 01 00 00       	jmp    891 <printf+0x177>
      }
    } else if(state == '%'){
 784:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 788:	0f 85 03 01 00 00    	jne    891 <printf+0x177>
      if(c == 'd'){
 78e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 792:	75 1e                	jne    7b2 <printf+0x98>
        printint(fd, *ap, 10, 1);
 794:	8b 45 e8             	mov    -0x18(%ebp),%eax
 797:	8b 00                	mov    (%eax),%eax
 799:	6a 01                	push   $0x1
 79b:	6a 0a                	push   $0xa
 79d:	50                   	push   %eax
 79e:	ff 75 08             	pushl  0x8(%ebp)
 7a1:	e8 c0 fe ff ff       	call   666 <printint>
 7a6:	83 c4 10             	add    $0x10,%esp
        ap++;
 7a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7ad:	e9 d8 00 00 00       	jmp    88a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7b2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7b6:	74 06                	je     7be <printf+0xa4>
 7b8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7bc:	75 1e                	jne    7dc <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7be:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c1:	8b 00                	mov    (%eax),%eax
 7c3:	6a 00                	push   $0x0
 7c5:	6a 10                	push   $0x10
 7c7:	50                   	push   %eax
 7c8:	ff 75 08             	pushl  0x8(%ebp)
 7cb:	e8 96 fe ff ff       	call   666 <printint>
 7d0:	83 c4 10             	add    $0x10,%esp
        ap++;
 7d3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d7:	e9 ae 00 00 00       	jmp    88a <printf+0x170>
      } else if(c == 's'){
 7dc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7e0:	75 43                	jne    825 <printf+0x10b>
        s = (char*)*ap;
 7e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e5:	8b 00                	mov    (%eax),%eax
 7e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7ea:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f2:	75 25                	jne    819 <printf+0xff>
          s = "(null)";
 7f4:	c7 45 f4 1a 0b 00 00 	movl   $0xb1a,-0xc(%ebp)
        while(*s != 0){
 7fb:	eb 1c                	jmp    819 <printf+0xff>
          putc(fd, *s);
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	0f b6 00             	movzbl (%eax),%eax
 803:	0f be c0             	movsbl %al,%eax
 806:	83 ec 08             	sub    $0x8,%esp
 809:	50                   	push   %eax
 80a:	ff 75 08             	pushl  0x8(%ebp)
 80d:	e8 31 fe ff ff       	call   643 <putc>
 812:	83 c4 10             	add    $0x10,%esp
          s++;
 815:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 819:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81c:	0f b6 00             	movzbl (%eax),%eax
 81f:	84 c0                	test   %al,%al
 821:	75 da                	jne    7fd <printf+0xe3>
 823:	eb 65                	jmp    88a <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 825:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 829:	75 1d                	jne    848 <printf+0x12e>
        putc(fd, *ap);
 82b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 82e:	8b 00                	mov    (%eax),%eax
 830:	0f be c0             	movsbl %al,%eax
 833:	83 ec 08             	sub    $0x8,%esp
 836:	50                   	push   %eax
 837:	ff 75 08             	pushl  0x8(%ebp)
 83a:	e8 04 fe ff ff       	call   643 <putc>
 83f:	83 c4 10             	add    $0x10,%esp
        ap++;
 842:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 846:	eb 42                	jmp    88a <printf+0x170>
      } else if(c == '%'){
 848:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 84c:	75 17                	jne    865 <printf+0x14b>
        putc(fd, c);
 84e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 851:	0f be c0             	movsbl %al,%eax
 854:	83 ec 08             	sub    $0x8,%esp
 857:	50                   	push   %eax
 858:	ff 75 08             	pushl  0x8(%ebp)
 85b:	e8 e3 fd ff ff       	call   643 <putc>
 860:	83 c4 10             	add    $0x10,%esp
 863:	eb 25                	jmp    88a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 865:	83 ec 08             	sub    $0x8,%esp
 868:	6a 25                	push   $0x25
 86a:	ff 75 08             	pushl  0x8(%ebp)
 86d:	e8 d1 fd ff ff       	call   643 <putc>
 872:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 875:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 878:	0f be c0             	movsbl %al,%eax
 87b:	83 ec 08             	sub    $0x8,%esp
 87e:	50                   	push   %eax
 87f:	ff 75 08             	pushl  0x8(%ebp)
 882:	e8 bc fd ff ff       	call   643 <putc>
 887:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 88a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 891:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 895:	8b 55 0c             	mov    0xc(%ebp),%edx
 898:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89b:	01 d0                	add    %edx,%eax
 89d:	0f b6 00             	movzbl (%eax),%eax
 8a0:	84 c0                	test   %al,%al
 8a2:	0f 85 94 fe ff ff    	jne    73c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8a8:	90                   	nop
 8a9:	c9                   	leave  
 8aa:	c3                   	ret    

000008ab <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8ab:	55                   	push   %ebp
 8ac:	89 e5                	mov    %esp,%ebp
 8ae:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8b1:	8b 45 08             	mov    0x8(%ebp),%eax
 8b4:	83 e8 08             	sub    $0x8,%eax
 8b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ba:	a1 f0 0d 00 00       	mov    0xdf0,%eax
 8bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8c2:	eb 24                	jmp    8e8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c7:	8b 00                	mov    (%eax),%eax
 8c9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8cc:	77 12                	ja     8e0 <free+0x35>
 8ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8d4:	77 24                	ja     8fa <free+0x4f>
 8d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d9:	8b 00                	mov    (%eax),%eax
 8db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8de:	77 1a                	ja     8fa <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e3:	8b 00                	mov    (%eax),%eax
 8e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8eb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ee:	76 d4                	jbe    8c4 <free+0x19>
 8f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f3:	8b 00                	mov    (%eax),%eax
 8f5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8f8:	76 ca                	jbe    8c4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fd:	8b 40 04             	mov    0x4(%eax),%eax
 900:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 907:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90a:	01 c2                	add    %eax,%edx
 90c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90f:	8b 00                	mov    (%eax),%eax
 911:	39 c2                	cmp    %eax,%edx
 913:	75 24                	jne    939 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 915:	8b 45 f8             	mov    -0x8(%ebp),%eax
 918:	8b 50 04             	mov    0x4(%eax),%edx
 91b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91e:	8b 00                	mov    (%eax),%eax
 920:	8b 40 04             	mov    0x4(%eax),%eax
 923:	01 c2                	add    %eax,%edx
 925:	8b 45 f8             	mov    -0x8(%ebp),%eax
 928:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 92b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92e:	8b 00                	mov    (%eax),%eax
 930:	8b 10                	mov    (%eax),%edx
 932:	8b 45 f8             	mov    -0x8(%ebp),%eax
 935:	89 10                	mov    %edx,(%eax)
 937:	eb 0a                	jmp    943 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 939:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93c:	8b 10                	mov    (%eax),%edx
 93e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 941:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 943:	8b 45 fc             	mov    -0x4(%ebp),%eax
 946:	8b 40 04             	mov    0x4(%eax),%eax
 949:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 950:	8b 45 fc             	mov    -0x4(%ebp),%eax
 953:	01 d0                	add    %edx,%eax
 955:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 958:	75 20                	jne    97a <free+0xcf>
    p->s.size += bp->s.size;
 95a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95d:	8b 50 04             	mov    0x4(%eax),%edx
 960:	8b 45 f8             	mov    -0x8(%ebp),%eax
 963:	8b 40 04             	mov    0x4(%eax),%eax
 966:	01 c2                	add    %eax,%edx
 968:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 96e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 971:	8b 10                	mov    (%eax),%edx
 973:	8b 45 fc             	mov    -0x4(%ebp),%eax
 976:	89 10                	mov    %edx,(%eax)
 978:	eb 08                	jmp    982 <free+0xd7>
  } else
    p->s.ptr = bp;
 97a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 980:	89 10                	mov    %edx,(%eax)
  freep = p;
 982:	8b 45 fc             	mov    -0x4(%ebp),%eax
 985:	a3 f0 0d 00 00       	mov    %eax,0xdf0
}
 98a:	90                   	nop
 98b:	c9                   	leave  
 98c:	c3                   	ret    

0000098d <morecore>:

static Header*
morecore(uint nu)
{
 98d:	55                   	push   %ebp
 98e:	89 e5                	mov    %esp,%ebp
 990:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 993:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 99a:	77 07                	ja     9a3 <morecore+0x16>
    nu = 4096;
 99c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9a3:	8b 45 08             	mov    0x8(%ebp),%eax
 9a6:	c1 e0 03             	shl    $0x3,%eax
 9a9:	83 ec 0c             	sub    $0xc,%esp
 9ac:	50                   	push   %eax
 9ad:	e8 79 fc ff ff       	call   62b <sbrk>
 9b2:	83 c4 10             	add    $0x10,%esp
 9b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9b8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9bc:	75 07                	jne    9c5 <morecore+0x38>
    return 0;
 9be:	b8 00 00 00 00       	mov    $0x0,%eax
 9c3:	eb 26                	jmp    9eb <morecore+0x5e>
  hp = (Header*)p;
 9c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ce:	8b 55 08             	mov    0x8(%ebp),%edx
 9d1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d7:	83 c0 08             	add    $0x8,%eax
 9da:	83 ec 0c             	sub    $0xc,%esp
 9dd:	50                   	push   %eax
 9de:	e8 c8 fe ff ff       	call   8ab <free>
 9e3:	83 c4 10             	add    $0x10,%esp
  return freep;
 9e6:	a1 f0 0d 00 00       	mov    0xdf0,%eax
}
 9eb:	c9                   	leave  
 9ec:	c3                   	ret    

000009ed <malloc>:

void*
malloc(uint nbytes)
{
 9ed:	55                   	push   %ebp
 9ee:	89 e5                	mov    %esp,%ebp
 9f0:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f3:	8b 45 08             	mov    0x8(%ebp),%eax
 9f6:	83 c0 07             	add    $0x7,%eax
 9f9:	c1 e8 03             	shr    $0x3,%eax
 9fc:	83 c0 01             	add    $0x1,%eax
 9ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a02:	a1 f0 0d 00 00       	mov    0xdf0,%eax
 a07:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a0e:	75 23                	jne    a33 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a10:	c7 45 f0 e8 0d 00 00 	movl   $0xde8,-0x10(%ebp)
 a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a1a:	a3 f0 0d 00 00       	mov    %eax,0xdf0
 a1f:	a1 f0 0d 00 00       	mov    0xdf0,%eax
 a24:	a3 e8 0d 00 00       	mov    %eax,0xde8
    base.s.size = 0;
 a29:	c7 05 ec 0d 00 00 00 	movl   $0x0,0xdec
 a30:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a36:	8b 00                	mov    (%eax),%eax
 a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3e:	8b 40 04             	mov    0x4(%eax),%eax
 a41:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a44:	72 4d                	jb     a93 <malloc+0xa6>
      if(p->s.size == nunits)
 a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a49:	8b 40 04             	mov    0x4(%eax),%eax
 a4c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a4f:	75 0c                	jne    a5d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a54:	8b 10                	mov    (%eax),%edx
 a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a59:	89 10                	mov    %edx,(%eax)
 a5b:	eb 26                	jmp    a83 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a60:	8b 40 04             	mov    0x4(%eax),%eax
 a63:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a66:	89 c2                	mov    %eax,%edx
 a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a71:	8b 40 04             	mov    0x4(%eax),%eax
 a74:	c1 e0 03             	shl    $0x3,%eax
 a77:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a80:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a86:	a3 f0 0d 00 00       	mov    %eax,0xdf0
      return (void*)(p + 1);
 a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8e:	83 c0 08             	add    $0x8,%eax
 a91:	eb 3b                	jmp    ace <malloc+0xe1>
    }
    if(p == freep)
 a93:	a1 f0 0d 00 00       	mov    0xdf0,%eax
 a98:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a9b:	75 1e                	jne    abb <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a9d:	83 ec 0c             	sub    $0xc,%esp
 aa0:	ff 75 ec             	pushl  -0x14(%ebp)
 aa3:	e8 e5 fe ff ff       	call   98d <morecore>
 aa8:	83 c4 10             	add    $0x10,%esp
 aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ab2:	75 07                	jne    abb <malloc+0xce>
        return 0;
 ab4:	b8 00 00 00 00       	mov    $0x0,%eax
 ab9:	eb 13                	jmp    ace <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abe:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac4:	8b 00                	mov    (%eax),%eax
 ac6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ac9:	e9 6d ff ff ff       	jmp    a3b <malloc+0x4e>
}
 ace:	c9                   	leave  
 acf:	c3                   	ret    
