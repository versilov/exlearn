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
free_network_state(NetworkState *state);

NetworkState *
new_network_state(int layers);

#endif
