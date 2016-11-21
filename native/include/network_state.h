#ifndef INCLUDED_NETWORK_STATE_H
#define INCLUDED_NETWORK_STATE_H

#include <stdlib.h>

#include "../include/matrix.h"

typedef struct NetworkState {
  int     layers;
  Matrix *biases;
  Matrix *weights;
} NetworkState;

void
network_state_free(NetworkState **state);

NetworkState *
network_state_new(int layers);

#endif
