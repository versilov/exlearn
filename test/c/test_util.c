#include <stdio.h>
#include <unistd.h>

typedef void (*CapturedIOFunction)();

char * temp_file_path() {
  char           *buffer;
  long long int   timestamp_usec;
  struct timeval  timer_usec;

  gettimeofday(&timer_usec, NULL);

  timestamp_usec = ((long long int) timer_usec.tv_sec) * 1000000ll + (long long int) timer_usec.tv_usec;
  buffer         = malloc(sizeof(char) * 190);

  sprintf(buffer, "test/c/temp/%lld", timestamp_usec);

  return buffer;
}

char * capture_stdout(CapturedIOFunction test_case) {
  fflush(stdout);

  int   saved_stdout = dup(STDOUT_FILENO);
  char *path         = temp_file_path();
  FILE *file         = fopen(path, "w+");

  dup2(fileno(file), STDOUT_FILENO);

  test_case();

  fflush(stdout);
  dup2(saved_stdout, STDOUT_FILENO);
  close(saved_stdout);
  fclose(file);

  return path;
}
