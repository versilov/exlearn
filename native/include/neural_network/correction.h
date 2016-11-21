#ifndef INCLUDE_CORRECTION_C
#define INCLUDE_CORRECTION_C

#include "../../include/matrix.h"
#include "../../include/network_structure.h"

typedef struct Correction {
  int     layers;
  Matrix *biases;
  Matrix *weights;
} Correction;

void
correction_free(Correction **correction);

Correction *
correction_new(int layers);

void
correction_initialize(NetworkStructure *network_structure, Correction *correction);

#endif
