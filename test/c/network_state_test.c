#include "../../native/include/network_state.h"

//-----------------------------------------------------------------------------
// Tests
//-----------------------------------------------------------------------------

static void test_network_state_free() {
  NetworkState *state = network_state_new(3);

  network_state_free(&state);

  assert(state == NULL); /* LCOV_EXCL_BR_LINE */
}

static void test_network_state_inspect_callback() {
  NetworkState *network_state = network_state_with_dropout();

  network_state_inspect(network_state);

  network_state_free(&network_state);
}

static void test_network_state_inspect() {
  char *result   = capture_stdout(test_network_state_inspect_callback);
  char *expected =
    "<#NetworkState\n"
    "  layers:  4\n"
    "  rows:    1 3 3 2\n"
    "  columns: 3 3 2 2\n"
    "  biases:\n"
    "    0: NULL\n"
    "    1: <#Matrix\n"
    "         rows:    1.000000\n"
    "         columns: 3.000000\n"
    "         values:  1.000000 2.000000 3.000000>\n"
    "    2: <#Matrix\n"
    "         rows:    1.000000\n"
    "         columns: 2.000000\n"
    "         values:  1.000000 2.000000>\n"
    "    3: <#Matrix\n"
    "         rows:    1.000000\n"
    "         columns: 2.000000\n"
    "         values:  1.000000 2.000000>\n"
    "  weights:\n"
    "    0: NULL\n"
    "    1: <#Matrix\n"
    "         rows:    3.000000\n"
    "         columns: 3.000000\n"
    "         values:  1.000000 2.000000 3.000000 4.000000 5.000000 6.000000 7.000000 8.000000 9.000000>\n"
    "    2: <#Matrix\n"
    "         rows:    3.000000\n"
    "         columns: 2.000000\n"
    "         values:  1.000000 2.000000 3.000000 4.000000 5.000000 6.000000>\n"
    "    3: <#Matrix\n"
    "         rows:    2.000000\n"
    "         columns: 2.000000\n"
    "         values:  1.000000 2.000000 3.000000 4.000000>\n"
    "  dropout: 0.500000 0.500000 0.500000 0.500000\n"
    "  function:\n"
    "    0: NULL\n"
    "    1: <#ActivationClosure function: F, function_id: 3, alpha: 0.000000>\n"
    "    2: <#ActivationClosure function: F, function_id: 3, alpha: 0.000000>\n"
    "    3: <#ActivationClosure function: F, function_id: 3, alpha: 0.000000>\n"
    "  derivative:\n"
    "    0: NULL\n"
    "    1: <#ActivationClosure function: F, function_id: 3, alpha: 0.000000>\n"
    "    2: <#ActivationClosure function: F, function_id: 3, alpha: 0.000000>\n"
    "    3: <#ActivationClosure function: F, function_id: 3, alpha: 0.000000>\n"
    "  presentation: <#PresentationClosure function: F, function_id: 0, alpha: 0>\n"
    "  objective:    F\n"
    "  objective_id: 2\n"
    "  error:        F\n"
    "  error_id:     2>\n";

  int32_t result_length   = strlen(result  );
  int32_t expected_length = strlen(expected);

  assert(result_length == expected_length); /* LCOV_EXCL_BR_LINE */

  for(int32_t index = 0; index <= result_length; index += 1) {
    assert(result[index] == expected[index]); /* LCOV_EXCL_BR_LINE */
  }
}

static void test_network_state_inspect_internal_callback() {
  NetworkState *network_state = network_state_with_dropout();

  network_state_inspect_internal(network_state, 3);

  network_state_free(&network_state);
}

static void test_network_state_inspect_internal() {
  char *result   = capture_stdout(test_network_state_inspect_internal_callback);
  char *expected =
    "<#NetworkState\n"
    "     layers:  4\n"
    "     rows:    1 3 3 2\n"
    "     columns: 3 3 2 2\n"
    "     biases:\n"
    "       0: NULL\n"
    "       1: <#Matrix\n"
    "            rows:    1.000000\n"
    "            columns: 3.000000\n"
    "            values:  1.000000 2.000000 3.000000>\n"
    "       2: <#Matrix\n"
    "            rows:    1.000000\n"
    "            columns: 2.000000\n"
    "            values:  1.000000 2.000000>\n"
    "       3: <#Matrix\n"
    "            rows:    1.000000\n"
    "            columns: 2.000000\n"
    "            values:  1.000000 2.000000>\n"
    "     weights:\n"
    "       0: NULL\n"
    "       1: <#Matrix\n"
    "            rows:    3.000000\n"
    "            columns: 3.000000\n"
    "            values:  1.000000 2.000000 3.000000 4.000000 5.000000 6.000000 7.000000 8.000000 9.000000>\n"
    "       2: <#Matrix\n"
    "            rows:    3.000000\n"
    "            columns: 2.000000\n"
    "            values:  1.000000 2.000000 3.000000 4.000000 5.000000 6.000000>\n"
    "       3: <#Matrix\n"
    "            rows:    2.000000\n"
    "            columns: 2.000000\n"
    "            values:  1.000000 2.000000 3.000000 4.000000>\n"
    "     dropout: 0.500000 0.500000 0.500000 0.500000\n"
    "     function:\n"
    "       0: NULL\n"
    "       1: <#ActivationClosure function: F, function_id: 3, alpha: 0.000000>\n"
    "       2: <#ActivationClosure function: F, function_id: 3, alpha: 0.000000>\n"
    "       3: <#ActivationClosure function: F, function_id: 3, alpha: 0.000000>\n"
    "     derivative:\n"
    "       0: NULL\n"
    "       1: <#ActivationClosure function: F, function_id: 3, alpha: 0.000000>\n"
    "       2: <#ActivationClosure function: F, function_id: 3, alpha: 0.000000>\n"
    "       3: <#ActivationClosure function: F, function_id: 3, alpha: 0.000000>\n"
    "     presentation: <#PresentationClosure function: F, function_id: 0, alpha: 0>\n"
    "     objective:    F\n"
    "     objective_id: 2\n"
    "     error:        F\n"
    "     error_id:     2>";

  int32_t result_length   = strlen(result  );
  int32_t expected_length = strlen(expected);

  assert(result_length == expected_length); /* LCOV_EXCL_BR_LINE */

  for(int32_t index = 0; index <= result_length; index += 1) {
    assert(result[index] == expected[index]); /* LCOV_EXCL_BR_LINE */
  }
}

static void test_network_state_new() {
  NetworkState *state = network_state_new(3);

  network_state_free(&state);
}
