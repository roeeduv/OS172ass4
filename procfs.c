#include "types.h"
#include "stat.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"


#define DIRENTSZ sizeof(struct dirent)
#define BUFFSIZE (2 + NPROC) * DIRENTSZ

uint currentInode = -1;
extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

int initProc(char *buf,struct inode *ip) {
  int index;
  struct dirent de;
  struct proc *p;
  // insert "."
  de.inum = ip->inum;
  strncpy(de.name, ".\0", DIRSIZ);
  memmove(buf, (char *)&de, DIRENTSZ);
  // insert ".."
  de.inum = ROOTINO;
  strncpy(de.name, "..\0", DIRSIZ);
  memmove(buf + DIRENTSZ, (char *)&de, DIRENTSZ);
  // insert "blockstat"
  de.inum = 660;
  strncpy(de.name, "blockstat\0", DIRSIZ);
  memmove(buf + DIRENTSZ * 2, (char *)&de, DIRENTSZ);
  // insert "inodestat"
  de.inum = 670;
  strncpy(de.name, "inodestat\0", DIRSIZ);
  memmove(buf + DIRENTSZ * 3, (char *)&de, DIRENTSZ);
  index = 4;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED )
    continue;
    else {
      de.inum = 700 *  p->pid;
      itoa(p->pid, de.name);
      memmove(buf + (DIRENTSZ * index), (char *)&de, DIRENTSZ);
      index++;
    }
  }
  release(&ptable.lock);

  return index * DIRENTSZ;
}

int initPID(int inum, char *buf) {
  struct proc *p;
  struct dirent de;

  de.inum = inum;
  strncpy(de.name, ".\0", DIRSIZ);
  memmove(buf, (char *)&de, DIRENTSZ);

  de.inum = currentInode;
  strncpy(de.name, "..\0", DIRSIZ);
  memmove(buf + DIRENTSZ, (char *)&de, DIRENTSZ);

  p = getProcByPID(inum / 700);

  de.inum = 10 + inum;
  strncpy(de.name, "status\0", DIRSIZ);
  memmove(buf + DIRENTSZ * 2, (char *)&de, DIRENTSZ);

  de.inum = 20 + inum;
  strncpy(de.name, "fdinfo\0", DIRSIZ);
  memmove(buf + DIRENTSZ * 3, (char *)&de, DIRENTSZ);

  if (p->cwd) {
    de.inum = p->cwd->inum;
    strncpy(de.name, "cwd", DIRSIZ);
    memmove(buf + DIRENTSZ * 4, (char *)&de, DIRENTSZ);
  }

  return DIRENTSZ * 5;
}

int status(char *buf,int pid){
  char sz[20];

  struct proc *p=getProc(pid/700);
  char* procstat = getProcState(p);
  itoa(p->sz, sz);
  strncpy(buf, "Status: ", strlen("Status:  "));
  strncpy(buf + strlen(buf),procstat, strlen(procstat)+1);
  strncpy(buf + strlen(buf), " Size: ", strlen(" Size:  "));
  strncpy(buf + strlen(buf), sz, strlen(sz)+1);
  strncpy(buf + strlen(buf), "\n", strlen("\n "));
  return strlen(buf);
}

int fdinfo(char *buf,int pid){
  struct proc *p;
  struct dirent de;

  int index=2;
  de.inum = pid;
  strncpy(de.name, ".\0", DIRSIZ);
  memmove(buf, (char *)&de, DIRENTSZ);
  de.inum = pid -20;
  strncpy(de.name, "..\0", DIRSIZ);
  memmove(buf + DIRENTSZ, (char *)&de, DIRENTSZ);
  p=getProc(pid/700);
  for (int i=0;i<NOFILE;i++){
    if (p->ofile[i]== 0){
      continue;
    }
    de.inum=pid+i+1;
    itoa(i, de.name);
    memmove(buf + DIRENTSZ * index, (char *)&de, DIRENTSZ);
    index++;
  }
  return index* DIRENTSZ;
}

int filesContent(char *buf,int pid){
  struct proc *p = getProc(pid/700);
  int fd = ((pid %700)-20) % NOFILE;
  //cprintf("in files content   pid= %d  proc pid = %d  fd =%d \n",pid,p->pid,fd);
  strncpy(buf,"TYPE: ", strlen("TYPE:  "));
  char* type = fileType(p->ofile[fd-1]);
  strncpy(buf+strlen(buf), type, strlen(type)+1);
  strncpy(buf + strlen(buf), "\nPOSITION: ", strlen("\nPOSITION:  "));
  itoa(p->ofile[fd-1]->off, buf + strlen(buf));
  strncpy(buf + strlen(buf), "\nflags: ", strlen("\nflags:  "));
  if(p->ofile[fd-1]->readable == 1 && p->ofile[fd-1]->writable == 1)
  strncpy(buf + strlen(buf), "RDWR", strlen("RDWR "));
  else if(p->ofile[fd-1]->readable == 0 && p->ofile[fd-1]->writable == 1)
  strncpy(buf + strlen(buf), "RDONLY", strlen("RDONLY "));
  else if(p->ofile[fd-1]->readable == 1 && p->ofile[fd-1]->writable == 0)
  strncpy(buf + strlen(buf), "WRONLY", strlen("WRONLY "));
  else
  strncpy(buf + strlen(buf), "no flags , sad so sad", strlen("no flags , sad so sad "));
  if (p->ofile[fd-1]->type == FD_INODE){
    strncpy(buf + strlen(buf), "\nINODE NUMBER: ", strlen("\nINODE NUMBER:  "));
    itoa(p->ofile[fd-1]->ip->inum, buf + strlen(buf));
  }
  strncpy(buf + strlen(buf), "\nREFERENCE COUNT: ", strlen("\nREFERENCE COUNT:  "));
  itoa(p->ofile[fd-1]->ip->ref, buf + strlen(buf));
  strncpy(buf + strlen(buf), "\n", strlen(" \n "));
  return strlen(buf);
}

// int cwd(char *buf,int pid, int off, int n ){
// struct proc *p;
//   cprintf("helllllllllllllllllo  in cwd\n");
//  p = getProcByPID(pid/700);
//  ilock(p->cwd);
//  int bytes = readi(p->cwd, buf, off, n);
//      iunlock(p->cwd);
// return bytes;
// }

int blockstat(char* buf){
  strncpy(buf, "Free blocks: ", strlen("Free blocks:  "));
  itoa(get_free_block_number(), buf + strlen(buf));
  strncpy(buf + strlen(buf),"\nTotal blocks: ", strlen("\nTotal blocks:  "));
  itoa(get_total_block_number(), buf + strlen(buf));
  strncpy(buf + strlen(buf), "\nHits ratio: ", strlen("\nHits ratio:  "));
  itoa(get_number_of_hits(), buf + strlen(buf));
  strncpy(buf + strlen(buf), "/", strlen("/ "));
  itoa(get_number_of_block_acsses(), buf + strlen(buf));
  strncpy(buf + strlen(buf), "\n", strlen(" \n "));
  return strlen(buf);
}

int inodestat(char* buf){
  strncpy(buf, "Free inodes: ", strlen("Free inodes:  "));
  itoa(get_number_of_free_inode(), buf + strlen(buf));
  strncpy(buf + strlen(buf),"\nValid inode: ", strlen("\nValid inode:  "));
  itoa(number_of_valid_inode(), buf + strlen(buf));
  strncpy(buf + strlen(buf), "\nRefs per inode: ", strlen("\nRefs per inode:  "));
  itoa(get_number_of_ref(), buf + strlen(buf));
  strncpy(buf + strlen(buf), "/", strlen("/ "));
  itoa(get_number_of_active_inode(), buf + strlen(buf));
  strncpy(buf + strlen(buf), "\n", strlen(" \n "));
  return strlen(buf);
}

int procfsisdir(struct inode *ip) {
  //proc minor is never initilized , all other inodes are initlitzed
  return (ip->minor == 0  || ip->minor == T_DIR );
}

void
procfsiread(struct inode* dp, struct inode *ip) {
  ip->type = T_DEV;
  ip->major = PROCFS;
  ip->size = 0;
  ip->nlink = 1;
  ip->flags = I_VALID;
  ip->ref = 1 ;

  if ( (ip->inum == 19) || (ip->inum%700 == 0) || (ip->inum%700 == 20))
  ip->minor = T_DIR;
  else
  ip->minor = T_FILE;
}

int procfsread(struct inode *ip, char *dst, int off, int n) {
  int size = 0;
  int nr;

  int command=ip->inum%700;
  char buf[BUFFSIZE];
  if (command >= 21 && command <= 36)
  command = 21;

  switch(command){
    case 19:
    // proc
    currentInode = ip->inum;
    size = initProc(buf,ip);
    break;
    case 0:
    // case /proc/pid
    size = initPID(ip->inum, buf);
    break;
    case 10:
    size = status(buf,ip->inum);
    break;
    case 20:
    size = fdinfo(buf,ip->inum);
    break;
    case 660:
    size = blockstat(buf);
    break;
    case 670:
    size =inodestat(buf);
    break;
    case 21:
    size= filesContent(buf,ip->inum);
    break;
    // default:
    //
    // size= cwd(buf,ip->inum,off,n);
    // break;

  }
  if (off < size) {
    nr = size - off;
    if(n < nr) {
      nr = n;
    }
    memmove(dst, buf + off, nr);
    return nr;
  }
  return 0;
}

int
procfswrite(struct inode *ip, char *buf, int n)
{
  return 0;
}

void
procfsinit(void)
{
  devsw[PROCFS].isdir = procfsisdir;
  devsw[PROCFS].iread = procfsiread;
  devsw[PROCFS].write = procfswrite;
  devsw[PROCFS].read = procfsread;
}
