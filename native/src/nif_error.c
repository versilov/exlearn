#include "../include/nif_error.h"

void
nif_error_free(NIFError **nif_error_address) {
  NIFError *nif_error = *nif_error_address;

  free(nif_error->message);
  free(nif_error);

  *nif_error_address = NULL;
}

NIFError *
nif_error_new(char *message) {
  NIFError *nif_error = malloc(sizeof(NIFError));

  int32_t length = strlen(message);
  nif_error->message = malloc(sizeof(char) * length + 1);

  strcpy(nif_error->message, message);

  return nif_error;
}
