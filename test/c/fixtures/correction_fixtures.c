#ifndef INCLUDE_CORRECTION_FIXTURES_C
#define INCLUDE_CORRECTION_FIXTURES_C

#include <stdint.h>

#include "../../../native/include/neural_network/correction.h"
#include "../../../native/include/matrix.h"

static Correction *
correction_expected_basic() {
  Correction *correction = correction_new(3);

  // First Hidden Layer Correction
  float layer_1_biases_correction[5]   = {1, 3, 90, 186, 282};
  float layer_1_weights_correction[11] = {3, 3,
    90, 186, 282, 180, 372, 564, 270, 558, 846
  };

  correction->biases[0]  = matrix_new(1, 3);
  correction->weights[0] = matrix_new(3, 3);

  matrix_clone(correction->biases[0],  layer_1_biases_correction );
  matrix_clone(correction->weights[0], layer_1_weights_correction);

  // Second Hidden Layer Correction
  float layer_2_biases_correction[4]  = {1, 2, 6, 42};
  float layer_2_weights_correction[8] = {3, 2, 186, 1302, 228, 1596, 270, 1890};

  correction->biases[1]  = matrix_new(1, 2);
  correction->weights[1] = matrix_new(3, 2);

  matrix_clone(correction->biases[1],  layer_2_biases_correction );
  matrix_clone(correction->weights[1], layer_2_weights_correction);

  // Output Layer Correction
  float layer_3_biases_correction[4]  = {1, 2, 30, -12};
  float layer_3_weights_correction[6] = {2, 2, 11130, -4452, 14580, -5832};

  correction->biases[2]  = matrix_new(1, 2);
  correction->weights[2] = matrix_new(2, 2);

  matrix_clone(correction->biases[2],  layer_3_biases_correction );
  matrix_clone(correction->weights[2], layer_3_weights_correction);

  return correction;
}

static Correction *
correction_expected_with_dropout() {
  Correction *correction = correction_new(3);

  // First Hidden Layer Correction
  float layer_1_biases_correction[5]   = {1, 3, 336, 672, 0};
  float layer_1_weights_correction[11] = {3, 3,
    336, 672, 0, 672, 1344, 0, 1008, 2016, 0
  };

  correction->biases[0]  = matrix_new(1, 3);
  correction->weights[0] = matrix_new(3, 3);

  matrix_clone(correction->biases[0],  layer_1_biases_correction );
  matrix_clone(correction->weights[0], layer_1_weights_correction);

  // Second Hidden Layer Correction
  float layer_2_biases_correction[4]  = {1, 2, 0, 84};
  float layer_2_weights_correction[8] = {3, 2, 0, 2604, 0, 3192, 0, 3780};

  correction->biases[1]  = matrix_new(1, 2);
  correction->weights[1] = matrix_new(3, 2);

  matrix_clone(correction->biases[1],  layer_2_biases_correction );
  matrix_clone(correction->weights[1], layer_2_weights_correction);

  // Output Layer Correction
  float layer_3_biases_correction[4]  = {1, 2, 30, -12};
  float layer_3_weights_correction[6] = {2, 2, 11130, -4452, 14580, -5832};

  correction->biases[2]  = matrix_new(1, 2);
  correction->weights[2] = matrix_new(2, 2);

  matrix_clone(correction->biases[2],  layer_3_biases_correction );
  matrix_clone(correction->weights[2], layer_3_weights_correction);

  return correction;
}

static unsigned char *
correction_char_array_simple() {
  unsigned char *char_array = malloc(sizeof(char) * 44);
  int32_t       *int_location;
  float         *float_location;

  // Layers
  int_location  = (int32_t *)(&char_array[0]);
  *int_location = 1;

  // Biases
  int_location  = (int32_t *)(&char_array[4]);
  *int_location = 1;

  int_location  = (int32_t *)(&char_array[8]);
  *int_location = 2;

  float_location  = (float *)(&char_array[12]);
  *float_location = 0.0;

  float_location  = (float *)(&char_array[16]);
  *float_location = 1.0;

  // Weights
  int_location  = (int32_t *)(&char_array[20]);
  *int_location = 2;

  int_location  = (int32_t *)(&char_array[24]);
  *int_location = 2;

  float_location  = (float *)(&char_array[28]);
  *float_location = 0.0;

  float_location  = (float *)(&char_array[32]);
  *float_location = 1.0;

  float_location  = (float *)(&char_array[36]);
  *float_location = 2.0;

  float_location  = (float *)(&char_array[40]);
  *float_location = 3.0;

  return char_array;
}

static Correction *
correction_simple() {
  Correction *correction = correction_new(1);
  int32_t     length;

  correction->biases[0]  = matrix_new(1, 2);
  correction->weights[0] = matrix_new(2, 2);

  length = correction->biases[0][0] * correction->biases[0][1] + 2;

  for (int32_t bias_index = 2; bias_index < length; bias_index += 1) {
    correction->biases[0][bias_index] = bias_index - 2;
  }

  length = correction->weights[0][0] * correction->weights[0][1] + 2;

  for (int32_t weight_index = 2; weight_index < length; weight_index += 1) {
    correction->weights[0][weight_index] = weight_index - 2;
  }

  return correction;
}

#endif
