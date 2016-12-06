#include "../../../native/include/neural_network/activation.h"

//-----------------------------------------------------------------------------
// Tests
//-----------------------------------------------------------------------------

static void test_activation_free() {
  Activation *activation = activation_new(3);

  activation_free(&activation);

  assert(activation == NULL); /* LCOV_EXCL_BR_LINE */
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
