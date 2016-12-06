#include "../../../native/include/neural_network/activation.h"

//-----------------------------------------------------------------------------
// Tests
//-----------------------------------------------------------------------------

static void test_activation_free() {
  Activation *activity = activation_new(3);

  activation_free(&activity);

  assert(activity == NULL); /* LCOV_EXCL_BR_LINE */
}

static void test_activation_new() {
  Activation *activity = activation_new(3);

  assert(activity->layers == 3); /* LCOV_EXCL_BR_LINE */

  activation_free(&activity);
}
