#ifndef INCLUDE_CORRECTION_C
#define INCLUDE_CORRECTION_C

#include <stdint.h>

#include "../../include/matrix.h"
#include "../../include/network_structure.h"

typedef struct Correction {
  int32_t  layers;
  Matrix  *biases;
  Matrix  *weights;
} Correction;

void
correction_free(Correction **correction);

Correction *
correction_new(int32_t layers);

void
correction_accumulate(Correction *total, Correction *correction);

void
correction_initialize(NetworkStructure *network_structure, Correction *correction);

#endif
