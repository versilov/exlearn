#include "../../include/neural_network/correction.h"

void
correction_free(Correction **correction_address) {
  Correction *correction = *correction_address;

  for (int32_t layer = 0; layer < correction->layers; layer += 1) {
    matrix_free(&correction->biases[layer]);
    matrix_free(&correction->weights[layer]);
  }

  free(correction->biases);
  free(correction->weights);

  free(correction);

  *correction_address = NULL;
}

Correction *
correction_new(int32_t layers) {
  Correction *correction = malloc(sizeof(Correction));

  correction->layers  = layers;
  correction->biases  = malloc(sizeof(Matrix) * layers);
  correction->weights = malloc(sizeof(Matrix) * layers);

  for (int32_t layer = 0; layer < correction->layers; layer += 1) {
    correction->biases[layer]  = NULL;
    correction->weights[layer] = NULL;
  }

  return correction;
}

void
correction_accumulate(Correction *total, Correction *correction){
  for (int32_t index = 0; index < total->layers; index += 1) {
    int32_t length;

    length = correction->biases[index][0] * correction->biases[index][1];

    for (int32_t bias_index = 2; bias_index < length + 2; bias_index += 1) {
      total->biases[index][bias_index] += correction->biases[index][bias_index];
    }

    length = correction->weights[index][0] * correction->weights[index][1];

    for (int32_t weight_index = 2; weight_index < length + 2; weight_index += 1) {
      total->weights[index][weight_index] += correction->weights[index][weight_index];
    }
  }
}

void
correction_apply(NetworkState *network_state, Correction *correction) {
  Matrix state_matrix, correction_matrix;

  for (int32_t layer = 0; layer < correction->layers; layer += 1) {
    state_matrix      = network_state->biases[layer + 1];
    correction_matrix = correction->biases[layer];

    matrix_add(state_matrix, correction_matrix, state_matrix);

    state_matrix      = network_state->weights[layer + 1];
    correction_matrix = correction->weights[layer];

    matrix_add(state_matrix, correction_matrix, state_matrix);
  }
}

int32_t
correction_char_size(Correction *correction) {
  int32_t size = 4;

  for (int32_t index = 0; index < correction->layers; index += 1) {
    int32_t length;

    size += 16;

    length = correction->biases[index][0] * correction->biases[index][1];
    for (int32_t bias_index = 2; bias_index < length + 2; bias_index += 1) {
      size += 4;
    }

    length = correction->weights[index][0] * correction->weights[index][1];
    for (int32_t weight_index = 2; weight_index < length + 2; weight_index += 1) {
      size += 4;
    }
  }

  return size;
}

Correction *
correction_from_char_array(unsigned char *char_array) {
  Correction *correction;
  int32_t     layers, length, width, height;
  int32_t     current_location;
  int32_t    *int_location;
  float      *float_location;

  current_location = 0;

  int_location = (int32_t *)(&char_array[current_location]);
  layers       = *int_location;

  correction = correction_new(layers);

  for (int index = 0; index < layers; index += 1) {
    current_location += 4;
    int_location      = (int32_t *)(&char_array[current_location]);
    width             = *int_location;

    current_location += 4;
    int_location      = (int32_t *)(&char_array[current_location]);
    height            = *int_location;

    correction->biases[index] = matrix_new(width, height);

    length = width * height + 2;

    for (int32_t bias_index = 2; bias_index < length; bias_index += 1) {
      current_location += 4;
      float_location    = (float *)(&char_array[current_location]);
      correction->biases[index][bias_index] = *float_location;
    }

    current_location += 4;
    int_location      = (int32_t *)(&char_array[current_location]);
    width             = *int_location;

    current_location += 4;
    int_location      = (int32_t *)(&char_array[current_location]);
    height            = *int_location;

    correction->weights[index] = matrix_new(width, height);

    length = width * height + 2;

    for (int32_t weight_index = 2; weight_index < length; weight_index += 1) {
      current_location += 4;
      float_location    = (float *)(&char_array[current_location]);
      correction->weights[index][weight_index] = *float_location;
    }
  }

  return correction;
}

void
correction_to_char_array(Correction *correction, unsigned char * char_array) {
  int32_t  length, width, height;
  int32_t  current_location;
  int32_t *int_location;
  float   *float_location;

  current_location = 0;

  int_location  = (int32_t *)(&char_array[current_location]);
  *int_location = correction->layers;

  for (int32_t index = 0; index < correction->layers; index += 1) {
    width  = correction->biases[index][0];
    height = correction->biases[index][1];
    length = width * height + 2;

    current_location += 4;
    int_location      = (int32_t *)(&char_array[current_location]);
    *int_location     = width;

    current_location += 4;
    int_location      = (int32_t *)(&char_array[current_location]);
    *int_location     = height;

    for (int32_t bias_index = 2; bias_index < length; bias_index += 1) {
      current_location += 4;
      float_location    = (float *)(&char_array[current_location]);
      *float_location   = correction->biases[index][bias_index];
    }

    width  = correction->weights[index][0];
    height = correction->weights[index][1];
    length = width * height + 2;

    current_location += 4;
    int_location      = (int32_t *)(&char_array[current_location]);
    *int_location     = width;

    current_location += 4;
    int_location      = (int32_t *)(&char_array[current_location]);
    *int_location     = height;

    for (int32_t weight_index = 2; weight_index < length; weight_index += 1) {
      current_location += 4;
      float_location    = (float *)(&char_array[current_location]);
      *float_location   = correction->weights[index][weight_index];
    }
  }
}

void
correction_initialize(NetworkState *network_state, Correction *correction) {
  int32_t rows, columns;
  Matrix  matrix;

  for (int32_t index = 0; index < correction->layers; index += 1) {
    rows    = network_state->rows[index];
    columns = network_state->columns[index];

    matrix = matrix_new(1, columns);
    matrix_fill(matrix, 0);
    correction->biases[index] = matrix;

    matrix = matrix_new(rows, columns);
    matrix_fill(matrix, 0);
    correction->weights[index] = matrix;
  }
}
