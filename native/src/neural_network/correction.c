#include "../../include/neural_network/correction.h"

void
free_correction(Correction *correction) {
  for (int layer = 0; layer < correction->layers; layer += 1) {
    free_matrix(correction->biases[layer]);
    free_matrix(correction->weights[layer]);
  }

  free(correction->biases);
  free(correction->weights);

  free(correction);
}

Correction *
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

void
correction_initialize(NetworkStructure *network_structure, Correction *correction) {
  int    rows, columns;
  Matrix matrix;

  return;
  for (int index = 0; index < correction->layers; index += 1) {
    rows    = network_structure->rows[index];
    columns = network_structure->columns[index];

    matrix = new_matrix(1, columns);
    matrix_fill(matrix, 0);
    correction->biases[index] = matrix;

    matrix = new_matrix(rows, columns);
    matrix_fill(matrix, 0);
    correction->weights[index] = matrix;
  }

  return;
}
