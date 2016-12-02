#ifndef INCLUDE_CORRECTION_C
#define INCLUDE_CORRECTION_C

#include <stdint.h>

#include "../../include/matrix.h"
#include "../../include/network_state.h"

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
correction_apply(NetworkState *network_state, Correction *correction);

int32_t
correction_char_size(Correction *correction);

Correction *
correction_from_char_array(unsigned char *char_array);

void
correction_inspect(const Correction *correction);

void
correction_inspect_indented(const Correction *correction, int32_t indentation);

void
correction_to_char_array(Correction *correction, unsigned char *char_array);

void
correction_initialize(NetworkState *network_state, Correction *correction);

#endif
