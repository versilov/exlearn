#include <stdint.h>

#include "../../../native/include/neural_network/correction.h"

#include "../fixtures/correction_fixtures.c"
#include "../fixtures/network_state_fixtures.c"

static void test_correction_free() {
  Correction *correction = correction_new(3);

  correction_free(&correction);

  assert(correction == NULL); /* LCOV_EXCL_BR_LINE */
}

static void test_correction_new() {
  Correction *correction = correction_new(3);

  assert(correction->layers == 3); /* LCOV_EXCL_BR_LINE */

  assert(correction->biases  != NULL); /* LCOV_EXCL_BR_LINE */
  assert(correction->weights != NULL); /* LCOV_EXCL_BR_LINE */

  for (int32_t layer = 0; layer < correction->layers; layer += 1) {
    assert(correction->biases[layer]  == NULL); /* LCOV_EXCL_BR_LINE */
    assert(correction->weights[layer] == NULL); /* LCOV_EXCL_BR_LINE */
  }

  correction_free(&correction);
}

static void test_correction_accumulate() {
  Correction *first, *second;

  first  = correction_new(4);
  second = correction_new(4);

  for (int32_t index = 0; index < 4; index += 1) {
    first->biases[index]  = matrix_new(1,         index + 1);
    first->weights[index] = matrix_new(index + 1, index + 2);

    matrix_fill(first->biases[index],  1);
    matrix_fill(first->weights[index], 1);

    second->biases[index]  = matrix_new(1,         index + 1);
    second->weights[index] = matrix_new(index + 1, index + 2);

    matrix_fill(second->biases[index],  2);
    matrix_fill(second->weights[index], 2);
  }

  correction_accumulate(first, second);

  for (int32_t index = 0; index < 4; index += 1) {
    int32_t length;

    assert(first->biases[index] != NULL);
    length = first->biases[index][0] * first->biases[index][1];

    for (int32_t bias_index = 2; bias_index < length + 2; bias_index += 1) {
      assert(first->biases[index][bias_index] == 3); /* LCOV_EXCL_BR_LINE */
    }

    assert(first->weights[index] != NULL);
    length = first->weights[index][0] * first->weights[index][1];

    for (int32_t weight_index = 2; weight_index < length + 2; weight_index += 1) {
      assert(first->weights[index][weight_index] == 3); /* LCOV_EXCL_BR_LINE */
    }
  }
}

static void test_correction_apply() {
  Correction   *correction    = correction_simple();
  NetworkState *network_state = network_state_simple();

  correction_apply(network_state, correction);

  assert(network_state->biases[0]  == NULL); /* LCOV_EXCL_BR_LINE */
  assert(network_state->weights[0] == NULL); /* LCOV_EXCL_BR_LINE */

  assert(network_state->biases[1][0]  == 1); /* LCOV_EXCL_BR_LINE */
  assert(network_state->biases[1][1]  == 2); /* LCOV_EXCL_BR_LINE */
  assert(network_state->biases[1][2]  == 1); /* LCOV_EXCL_BR_LINE */
  assert(network_state->biases[1][3]  == 3); /* LCOV_EXCL_BR_LINE */
  assert(network_state->weights[1][0] == 2); /* LCOV_EXCL_BR_LINE */
  assert(network_state->weights[1][1] == 2); /* LCOV_EXCL_BR_LINE */
  assert(network_state->weights[1][2] == 1); /* LCOV_EXCL_BR_LINE */
  assert(network_state->weights[1][3] == 3); /* LCOV_EXCL_BR_LINE */
  assert(network_state->weights[1][4] == 5); /* LCOV_EXCL_BR_LINE */
  assert(network_state->weights[1][5] == 7); /* LCOV_EXCL_BR_LINE */
}

static void test_correction_char_size() {
  Correction *correction = correction_simple();
  int32_t     size;

  size = correction_char_size(correction);

  assert(size == 44);
}

static void test_correction_from_char_array() {
  Correction    *correction, *result;
  unsigned char *char_array;
  int32_t        length, width, height;

  correction = correction_simple();
  char_array = correction_char_array_simple();
  result     = correction_from_char_array(char_array);

  assert(correction->layers == result->layers); /* LCOV_EXCL_BR_LINE */

  for (int32_t index = 0; index < correction->layers; index += 1) {
    width  = correction->biases[index][0];
    height = correction->biases[index][1];
    length = width * height + 2;

    for (int32_t bias_index = 2; bias_index < length; bias_index += 1) {
      assert(correction->biases[index][bias_index] == result->biases[index][bias_index]); /* LCOV_EXCL_BR_LINE */
    }

    for (int32_t weight_index = 2; weight_index < length; weight_index += 1) {
      assert(correction->weights[index][weight_index] == result->weights[index][weight_index]); /* LCOV_EXCL_BR_LINE */
    }
  }

  correction_free(&correction);
  free(char_array);
  free(result);
}

static void test_correction_to_char_array() {
  Correction    *correction;
  unsigned char *char_array, *result;

  correction = correction_simple();
  char_array = correction_char_array_simple();
  result     = malloc(sizeof(char) * 44);

  correction_to_char_array(correction, result);

  for (int index = 0; index < 44; index += 1) {
    assert(char_array[index] == result[index]); /* LCOV_EXCL_BR_LINE */
  }

  correction_free(&correction);
  free(char_array);
  free(result);
}

static void test_correction_initialize() {
  NetworkState *network_state = network_state_basic();
  Correction   *correction    = correction_new(4);

  correction_initialize(network_state, correction);

  assert(correction->layers == 4);

  for (int32_t index = 0; index < 4; index += 1) {
    int32_t length;

    assert(correction->biases[index] != NULL);
    length = correction->biases[index][0] * correction->biases[index][1];

    for (int32_t bias_index = 2; bias_index < length + 2; bias_index += 1) {
      assert(correction->biases[index][bias_index] == 0); /* LCOV_EXCL_BR_LINE */
    }

    assert(correction->weights[index] != NULL);
    length = correction->weights[index][0] * correction->weights[index][1];

    for (int32_t weight_index = 2; weight_index < length + 2; weight_index += 1) {
      assert(correction->weights[index][weight_index] == 0); /* LCOV_EXCL_BR_LINE */
    }
  }
}
