#include "../include/network_state.h"

void
network_state_free(NetworkState **network_state_address) {
  NetworkState *network_state = *network_state_address;

  for (int32_t layer = 0; layer < network_state->layers; layer += 1) {
    matrix_free(&network_state->biases[layer] );
    matrix_free(&network_state->weights[layer]);

    free_activity_closure(network_state->function[layer]  );
    free_activity_closure(network_state->derivative[layer]);
  }

  free(network_state->rows       );
  free(network_state->columns    );
  free(network_state->biases     );
  free(network_state->weights    );
  free(network_state->dropout    );
  free(network_state->function   );
  free(network_state->derivative );

  presentation_closure_free(&network_state->presentation);

  free(network_state);

  *network_state_address = NULL;
}

NetworkState *
network_state_new(int32_t layers) {
  NetworkState *network_state = malloc(sizeof(NetworkState));

  network_state->layers       = layers;
  network_state->rows         = malloc(sizeof(int)    * layers);
  network_state->columns      = malloc(sizeof(int)    * layers);
  network_state->biases       = malloc(sizeof(Matrix) * layers);
  network_state->weights      = malloc(sizeof(Matrix) * layers);
  network_state->dropout      = malloc(sizeof(float)  * layers);
  network_state->function     = malloc(sizeof(ActivityClosure *) * layers);
  network_state->derivative   = malloc(sizeof(ActivityClosure *) * layers);
  network_state->presentation = NULL;
  network_state->objective    = NULL;
  network_state->error        = NULL;

  for (int32_t layer = 0; layer < layers; layer += 1) {
    network_state->biases[layer]     = NULL;
    network_state->weights[layer]    = NULL;
    network_state->function[layer]   = NULL;
    network_state->derivative[layer] = NULL;
  }

  return network_state;
}
