#include "../../../native/include/neural_network/propagator.h"

#include "../fixtures/activity_fixtures.c"
#include "../fixtures/correction_fixtures.c"
#include "../fixtures/data_fixtures.c"
#include "../fixtures/network_state_fixtures.c"

static void test_back_propagate() {
  NetworkState *network_state       = network_state_basic();
  Matrix        expected_output     = data_expected_basic();
  Activity     *activity            = activity_expected_basic();
  Correction   *expected_correction = correction_expected_basic();

  Correction *result = back_propagate(network_state, activity, expected_output);

  assert(result->layers == expected_correction->layers); /* LCOV_EXCL_BR_LINE */

  for (int32_t layer = 0; layer < result->layers; layer += 1) {
    assert(matrix_equal(result->biases[layer],  expected_correction->biases[layer])); /* LCOV_EXCL_BR_LINE */
    assert(matrix_equal(result->weights[layer], expected_correction->weights[layer])); /* LCOV_EXCL_BR_LINE */
  }

  correction_free(&result);
  correction_free(&expected_correction);
  activity_free(&activity);
  matrix_free(&expected_output);
  network_state_free(&network_state);
}

static void test_back_propagate_with_dropout() {
  NetworkState *network_state       = network_state_with_dropout();
  Matrix        expected_output     = data_expected_basic();
  Activity     *activity            = activity_expected_with_dropout();
  Correction   *expected_correction = correction_expected_with_dropout();

  Correction *result = back_propagate(network_state, activity, expected_output);

  assert(result->layers == expected_correction->layers); /* LCOV_EXCL_BR_LINE */

  for (int32_t layer = 0; layer < result->layers; layer += 1) {
    assert(matrix_equal(result->biases[layer],  expected_correction->biases[layer])); /* LCOV_EXCL_BR_LINE */
    assert(matrix_equal(result->weights[layer], expected_correction->weights[layer])); /* LCOV_EXCL_BR_LINE */
  }

  correction_free(&result);
  correction_free(&expected_correction);
  activity_free(&activity);
  matrix_free(&expected_output);
  network_state_free(&network_state);
}
