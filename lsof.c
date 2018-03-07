#include "types.h"
#include "user.h"
#include "stat.h"


char*
strncpy(char *s, const char *t, int n)
{
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}



void itoa(int x, char *buf) {
  static char digits[] = "0123456789";
  int i = 0;
  char tmp;

  do{
    buf[i++] = digits[x % 10];
  }while((x /= 10) != 0);
  buf[i] = '\0';

  for (i = 0; i < strlen(buf) / 2; i++) {
    tmp = buf[i];
    buf[i] = buf[strlen(buf) - i - 1];
    buf[strlen(buf) - i - 1] = tmp;
  }
}


int
main(int argc, char *argv[]){
  char path[100];
  char buffer[200];
  struct stat stat_s;
  int fd;
  for(int i = 1 ; i<=64 ; i++){
    for(int j = 0 ; j <= 15 ; j++){
      strncpy(path, "/proc/", strlen("/proc/ "));
      itoa(i, path + strlen(path));
      strncpy(path + strlen(path),"/fdinfo/", strlen("/fdinfo/ "));
      itoa(j, path + strlen(path));
      strncpy(path + strlen(path),"\0", strlen("\0 "));
      printf(1, "the path is: %s\n", path);
      if(stat(path, &stat_s) == 0){// enter if the file exist
        if((fd = open(path, 0)) < 0){
          printf(1, "error!\n");
          exit();
        }
        read(fd, buffer , 200);
        printf(1, "%s\n", buffer);
        close(fd);
      }
    }
  }

  exit();
}
