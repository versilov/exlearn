#ifndef INCLUDED_ACTIVATION_H
#define INCLUDED_ACTIVATION_H

#include <stdint.h>
#include <stdlib.h>

#include "../matrix.h"

typedef struct Activation {
  int32_t  layers;
  Matrix  *input;
  Matrix  *output;
  Matrix  *mask;
} Activation;

void
activation_free(Activation **);

Activation *
activation_new(int);

#endif
