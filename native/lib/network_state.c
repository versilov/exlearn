#ifndef INCLUDE_NETWORK_STATE_C
#define INCLUDE_NETWORK_STATE_C

#include <stdlib.h>

#include "matrix.c"

static void
free_network_state(NetworkState *state) {
  free(state->biases );
  free(state->weights);

  free(state);
}

static NetworkState *
new_network_state(int layers) {
  NetworkState *state = malloc(sizeof(NetworkState));

  state->layers  = layers;
  state->biases  = malloc(sizeof(Matrix) * layers);
  state->weights = malloc(sizeof(Matrix) * layers);

  return state;
}

#endif
