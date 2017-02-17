#ifndef INCLUDE_NIF_ERROR_H
#define INCLUDE_NIF_ERROR_H

#include <stdint.h>
#include <string.h>

typedef struct NIFError {
  char *message;
} NIFError;

void
nif_error_free(NIFError **nif_error);

NIFError *
nif_error_new(char *message);

#endif
