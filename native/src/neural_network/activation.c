#include "../../include/neural_network/activation.h"

void
activation_free(Activation **activation_address) {
  Activation * activation = *activation_address;

  for (int32_t layer = 0; layer < activation->layers; layer += 1) {
    if (activation->input[layer]  != NULL) free(activation->input[layer] );
    if (activation->mask[layer]   != NULL) free(activation->mask[layer]  );
    if (activation->output[layer] != NULL) free(activation->output[layer]);
  }

  free(activation->input );
  free(activation->output);
  free(activation->mask  );

  free(activation);

  *activation_address = NULL;
}

Activation *
activation_new(int32_t layers) {
  Activation *activation = malloc(sizeof(Activation));

  activation->layers = layers;
  activation->input  = malloc(sizeof(Matrix) * layers);
  activation->output = malloc(sizeof(Matrix) * layers);
  activation->mask   = malloc(sizeof(Matrix) * layers);

  for (int32_t layer = 0; layer < layers; layer += 1) {
    activation->input[layer]  = NULL;
    activation->mask[layer]   = NULL;
    activation->output[layer] = NULL;
  }

  return activation;
}
