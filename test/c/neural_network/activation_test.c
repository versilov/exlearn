#include "../../../native/include/neural_network/activation.h"

#include "../fixtures/activation_fixtures.c"

//-----------------------------------------------------------------------------
// Tests
//-----------------------------------------------------------------------------

static void test_activation_free() {
  Activation *activation = activation_new(3);

  activation_free(&activation);

  assert(activation == NULL); /* LCOV_EXCL_BR_LINE */
}

static void test_activation_inspect_callback() {
  Activation *activation = activation_simple();

  activation_inspect(activation);

  activation_free(&activation);
}

static void test_activation_inspect() {
  char *result   = capture_stdout(test_activation_inspect_callback);
  char *expected =
    "<#Activation\n"
    "  layers: 2\n"
    "  input:\n"
    "    0: NULL\n"
    "    1: <#Matrix\n"
    "         rows:    1.000000\n"
    "         columns: 3.000000\n"
    "         values:  0.000000 1.000000 2.000000>\n"
    "  output:\n"
    "    0: NULL\n"
    "    1: <#Matrix\n"
    "         rows:    1.000000\n"
    "         columns: 3.000000\n"
    "         values:  0.000000 1.000000 2.000000>\n"
    "  mask:\n"
    "    0: NULL\n"
    "    1: <#Matrix\n"
    "         rows:    1.000000\n"
    "         columns: 3.000000\n"
    "         values:  0.000000 1.000000 2.000000>>\n";

  int32_t result_length   = strlen(result  );
  int32_t expected_length = strlen(expected);

  assert(result_length == expected_length); /* LCOV_EXCL_BR_LINE */

  for(int32_t index = 0; index <= result_length; index += 1) {
    assert(result[index] == expected[index]); /* LCOV_EXCL_BR_LINE */
  }
}

static void test_activation_inspect_internal_callback() {
  Activation *activation = activation_simple();

  activation_inspect_internal(activation, 3);

  activation_free(&activation);
}

static void test_activation_inspect_internal() {
  char *result   = capture_stdout(test_activation_inspect_internal_callback);
  char *expected =
    "<#Activation\n"
    "     layers: 2\n"
    "     input:\n"
    "       0: NULL\n"
    "       1: <#Matrix\n"
    "            rows:    1.000000\n"
    "            columns: 3.000000\n"
    "            values:  0.000000 1.000000 2.000000>\n"
    "     output:\n"
    "       0: NULL\n"
    "       1: <#Matrix\n"
    "            rows:    1.000000\n"
    "            columns: 3.000000\n"
    "            values:  0.000000 1.000000 2.000000>\n"
    "     mask:\n"
    "       0: NULL\n"
    "       1: <#Matrix\n"
    "            rows:    1.000000\n"
    "            columns: 3.000000\n"
    "            values:  0.000000 1.000000 2.000000>>";

  int32_t result_length   = strlen(result  );
  int32_t expected_length = strlen(expected);

  assert(result_length == expected_length); /* LCOV_EXCL_BR_LINE */

  for(int32_t index = 0; index <= result_length; index += 1) {
    assert(result[index] == expected[index]); /* LCOV_EXCL_BR_LINE */
  }
}

static void test_activation_new() {
  Activation *activation = activation_new(3);

  assert(activation->layers == 3); /* LCOV_EXCL_BR_LINE */

  for (int32_t layer = 0; layer < activation->layers; layer += 1) {
    assert(activation->input[layer]  == NULL); /* LCOV_EXCL_BR_LINE */
    assert(activation->mask[layer]   == NULL); /* LCOV_EXCL_BR_LINE */
    assert(activation->output[layer] == NULL); /* LCOV_EXCL_BR_LINE */
  }

  activation_free(&activation);
}
