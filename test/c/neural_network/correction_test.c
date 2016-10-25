#include "../../../native/lib/neural_network/correction.c"

static void test_free_correction() {
  Correction *correction = new_correction(3);

  free_correction(correction);
}

static void test_new_correction() {
  Correction *correction = new_correction(3);

  assert(correction->layers == 3); /* LCOV_EXCL_BR_LINE */

  assert(correction->biases  != NULL); /* LCOV_EXCL_BR_LINE */
  assert(correction->weights != NULL); /* LCOV_EXCL_BR_LINE */

  for (int layer = 0; layer < correction->layers; layer += 1) {
    assert(correction->biases[layer]  == NULL); /* LCOV_EXCL_BR_LINE */
    assert(correction->weights[layer] == NULL); /* LCOV_EXCL_BR_LINE */
  }

  free_correction(correction);
}

static void test_correction_initialize() {
  correction_initialize(NULL, NULL);

}
