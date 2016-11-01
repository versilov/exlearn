#include "../include/network_state.h"

void
free_network_state(NetworkState *state) {
  for (int layer = 0; layer < state->layers; layer += 1) {
    free_matrix(state->biases[layer] );
    free_matrix(state->weights[layer]);
  }

  free(state->biases );
  free(state->weights);

  free(state);

  state = NULL;
}

NetworkState *
new_network_state(int layers) {
  NetworkState *state = malloc(sizeof(NetworkState));

  state->layers  = layers;
  state->biases  = malloc(sizeof(Matrix) * layers);
  state->weights = malloc(sizeof(Matrix) * layers);

  for (int layer = 0; layer < layers; layer += 1) {
    state->biases[layer]  = NULL;
    state->weights[layer] = NULL;
  }

  return state;
}