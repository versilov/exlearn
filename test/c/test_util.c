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
