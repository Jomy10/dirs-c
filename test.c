#include "target/dirs.h"
#include <stdio.h>
#if defined(_WIN32) || defined(WIN32)
#include <io.h>
#include <sys/types.h>
#include <sys/stat.h>
#else
#include <dirent.h>
#include <errno.h>
#endif

int main() {
  char dir[256];
  DirResult res = home_dir(dir, 256);
  if (res.bytes_total == 0) {
    fprintf(stderr, "Home directory does not exist for currrent platform\n");
    exit(1);
  }
  if (res.bytes_total != res.bytes_written) {
    fprintf(stderr, "Directory path is larger than 256 bytes\n");
    exit(1);
  }

  printf("Dir: %s\n", dir);

  #if defined(_WIN32) || defined(WIN32)
  if (_access(dir, 0) == 0) {
    struct stat status;
    stat(dir, &status);
    if ((status.st_mode & S_IFDIR) == 0) {
      fprintf(stderr, "no exist\n");
      exit(1);
    } else {
      return 0;
    }
  }
  fprintf(stderr, "no exist\n");
  exit(1);
  #else
  DIR* odir = opendir(dir);
  if (odir) {
    closedir(odir);
  } else if (ENOENT == errno) {
    fprintf(stderr, "Directory does not exist\n");
    exit(1);
  } else {
    fprintf(stderr, "failed\n") ;
    exit(1);
  }
  #endif

  return 0;
}

