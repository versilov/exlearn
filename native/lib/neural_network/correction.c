#ifndef INCLUDE_CORRECTION_C
#define INCLUDE_CORRECTION_C

#include "../matrix.c"

static void
free_correction(Correction *correction) {
  for (int layer = 0; layer < correction->layers; layer += 1) {
    free_matrix(correction->biases[layer]);
    free_matrix(correction->weights[layer]);
  }

  free(correction->biases);
  free(correction->weights);

  free(correction);
}

static Correction *
new_correction(int layers) {
  Correction *correction = malloc(sizeof(Correction));

  correction->layers  = layers;
  correction->biases  = malloc(sizeof(Matrix) * layers);
  correction->weights = malloc(sizeof(Matrix) * layers);

  for (int layer = 0; layer < correction->layers; layer += 1) {
    correction->biases[layer]  = NULL;
    correction->weights[layer] = NULL;
  }

  return correction;
}

#endif
