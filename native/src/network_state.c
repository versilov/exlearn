#include "../include/network_state.h"

void
network_state_free(NetworkState **state_address) {
  NetworkState *state = *state_address;

  for (int32_t layer = 0; layer < state->layers; layer += 1) {
    matrix_free(&state->biases[layer] );
    matrix_free(&state->weights[layer]);
  }

  free(state->biases );
  free(state->weights);

  free(state);

  *state_address = NULL;
}

NetworkState *
network_state_new(int32_t layers) {
  NetworkState *state = malloc(sizeof(NetworkState));

  state->layers  = layers;
  state->biases  = malloc(sizeof(Matrix) * layers);
  state->weights = malloc(sizeof(Matrix) * layers);

  for (int32_t layer = 0; layer < layers; layer += 1) {
    state->biases[layer]  = NULL;
    state->weights[layer] = NULL;
  }

  return state;
}
