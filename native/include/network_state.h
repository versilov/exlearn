#ifndef INCLUDED_NETWORK_STATE_H
#define INCLUDED_NETWORK_STATE_H

#include <stdint.h>
#include <stdlib.h>

#include "../include/matrix.h"

typedef struct NetworkState {
  int32_t  layers;
  Matrix  *biases;
  Matrix  *weights;
} NetworkState;

void
network_state_free(NetworkState **state);

NetworkState *
network_state_new(int32_t layers);

#endif
