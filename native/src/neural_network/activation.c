#include "../../include/neural_network/activation.h"

void
activation_free(Activation **activity_address) {
  Activation * activity = *activity_address;

  for (int32_t layer = 0; layer < activity->layers; layer += 1) {
    if (activity->input[layer]  != NULL) free(activity->input[layer] );
    if (activity->mask[layer]   != NULL) free(activity->mask[layer]  );
    if (activity->output[layer] != NULL) free(activity->output[layer]);
  }

  free(activity->input );
  free(activity->output);
  free(activity->mask  );

  free(activity);

  *activity_address = NULL;
}

Activation *
activation_new(int32_t layers) {
  Activation *activity = malloc(sizeof(Activation));

  activity->layers = layers;
  activity->input  = malloc(sizeof(Matrix) * layers);
  activity->output = malloc(sizeof(Matrix) * layers);
  activity->mask   = malloc(sizeof(Matrix) * layers);

  for (int32_t layer = 0; layer < layers; layer += 1) {
    activity->input[layer]  = NULL;
    activity->mask[layer]   = NULL;
    activity->output[layer] = NULL;
  }

  return activity;
}
