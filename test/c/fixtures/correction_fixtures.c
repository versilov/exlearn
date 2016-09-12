#ifndef INCLUDE_CORRECTION_FIXTURES_C
#define INCLUDE_CORRECTION_FIXTURES_C

#include "../../../native/lib/neural_network/correction.c"

static Correction *
correction_expected_basic() {
  Correction *correction = new_correction(4);

  // First Hidden Layer Correction
  float layer_1_biases_correction[5]   = {1, 3, 90, 186, 282};
  float layer_1_weights_correction[11] = {3, 3,
    90, 186, 282, 180, 372, 564, 270, 558, 846
  };

  correction->biases[1]  = new_matrix(1, 3);
  correction->weights[1] = new_matrix(3, 3);

  clone_matrix(correction->biases[1],  layer_1_biases_correction );
  clone_matrix(correction->weights[1], layer_1_weights_correction);

  // Second Hidden Layer Correction
  float layer_2_biases_correction[4]  = {1, 2, 6, 42};
  float layer_2_weights_correction[8] = {3, 2, 186, 1302, 228, 1596, 270, 1890};

  correction->biases[2]  = new_matrix(1, 2);
  correction->weights[2] = new_matrix(3, 2);

  clone_matrix(correction->biases[2],  layer_2_biases_correction );
  clone_matrix(correction->weights[2], layer_2_weights_correction);

  // Output Layer Correction
  float layer_3_biases_correction[4]  = {1, 2, 30, -12};
  float layer_3_weights_correction[6] = {2, 2, 11130, -4452, 14580, -5832};

  correction->biases[3]  = new_matrix(1, 2);
  correction->weights[3] = new_matrix(2, 2);

  clone_matrix(correction->biases[3],  layer_3_biases_correction );
  clone_matrix(correction->weights[3], layer_3_weights_correction);

  return correction;
}

#endif
