#include "../../../native/include/neural_network/correction.h"

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

  for (int layer = 0; layer < correction->layers; layer += 1) {
    assert(correction->biases[layer]  == NULL); /* LCOV_EXCL_BR_LINE */
    assert(correction->weights[layer] == NULL); /* LCOV_EXCL_BR_LINE */
  }

  correction_free(&correction);
}

static void test_correction_initialize() {
  correction_initialize(NULL, NULL);

}
