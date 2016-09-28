#include "../../../native/lib/neural_network/forwarder.c"
#include "../fixtures/network_structure_fixtures.c"
#include "../fixtures/network_state_fixtures.c"
#include "../fixtures/data_fixtures.c"

static void test_forward_for_activity() {
  NetworkStructure *structure = network_structure_basic();
  NetworkState     *state     = network_state_basic();
  Matrix            sample    = data_sample_basic();
  Activity *activity = forward_for_activity(structure, state, sample);

  assert(activity->layers == structure->layers); /* LCOV_EXCL_BR_LINE */

  float layer_1_input[5] = {1, 3, 31, 38, 45};
  float layer_2_input[4] = {1, 2, 371, 486};
  float layer_3_input[4] = {1, 2, 1830, 2688};

  assert(activity->input[0] == NULL); /* LCOV_EXCL_BR_LINE */
  assert(matrix_equal(activity->input[1], layer_1_input)); /* LCOV_EXCL_BR_LINE */
  assert(matrix_equal(activity->input[2], layer_2_input)); /* LCOV_EXCL_BR_LINE */
  assert(matrix_equal(activity->input[3], layer_3_input)); /* LCOV_EXCL_BR_LINE */

  float layer_0_output[5] = {1, 3, 1, 2, 3};
  float layer_1_output[5] = {1, 3, 31, 38, 45};
  float layer_2_output[4] = {1, 2, 371, 486};
  float layer_3_output[4] = {1, 2, 1830, 2688};

  assert(matrix_equal(activity->output[0], layer_0_output)); /* LCOV_EXCL_BR_LINE */
  assert(matrix_equal(activity->output[1], layer_1_output)); /* LCOV_EXCL_BR_LINE */
  assert(matrix_equal(activity->output[2], layer_2_output)); /* LCOV_EXCL_BR_LINE */
  assert(matrix_equal(activity->output[3], layer_3_output)); /* LCOV_EXCL_BR_LINE */

  assert(activity->mask[0] == NULL); /* LCOV_EXCL_BR_LINE */
  assert(activity->mask[1] == NULL); /* LCOV_EXCL_BR_LINE */
  assert(activity->mask[2] == NULL); /* LCOV_EXCL_BR_LINE */
  assert(activity->mask[3] == NULL); /* LCOV_EXCL_BR_LINE */

  free_activity(activity);
  free_matrix(sample);
  free_network_state(state);
  free_network_structure(structure);
}

static void test_forward_for_activity_with_dropout() {
  NetworkStructure *structure = network_structure_with_dropout();
  NetworkState     *state     = network_state_basic();
  Matrix            sample    = data_sample_basic();
  Activity *activity = forward_for_activity(structure, state, sample);

  assert(activity->layers == structure->layers); /* LCOV_EXCL_BR_LINE */

  assert(activity->mask[0] != NULL); /* LCOV_EXCL_BR_LINE */
  assert(activity->mask[1] != NULL); /* LCOV_EXCL_BR_LINE */
  assert(activity->mask[2] != NULL); /* LCOV_EXCL_BR_LINE */
  assert(activity->mask[3] != NULL); /* LCOV_EXCL_BR_LINE */

  free_activity(activity);
  free_matrix(sample);
  free_network_state(state);
  free_network_structure(structure);
}

static void test_forward_for_output() {
  NetworkStructure *structure = network_structure_basic();
  NetworkState     *state     = network_state_basic();
  Matrix            sample    = data_sample_basic();
  int               result;

  Matrix output = forward_for_output(structure, state, sample);
  result        = call_presentation_closure(structure->presentation, output);

  assert(result == 1); /* LCOV_EXCL_BR_LINE */

  free_matrix(output);
  free_matrix(sample);
  free_network_state(state);
  free_network_structure(structure);
}
