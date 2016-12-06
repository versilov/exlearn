#ifndef INCLUDED_ACTIVATION_H
#define INCLUDED_ACTIVATION_H

#include <stdint.h>
#include <stdlib.h>

#include "../matrix.h"
#include "../utils.h"

typedef struct Activation {
  int32_t  layers;
  Matrix  *input;
  Matrix  *output;
  Matrix  *mask;
} Activation;

void
activation_free(Activation **activation_address);

void
activation_inspect(Activation *activation);

void
activation_inspect_internal(Activation *activation, int32_t indentation);

Activation *
activation_new(int layers);

#endif
