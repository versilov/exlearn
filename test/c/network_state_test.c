#include "../../native/include/network_state.h"

//-----------------------------------------------------------------------------
// Tests
//-----------------------------------------------------------------------------

static void test_network_state_free() {
  NetworkState *state = network_state_new(3);

  network_state_free(&state);

  assert(state == NULL); /* LCOV_EXCL_BR_LINE */
}

static void test_network_state_new() {
  NetworkState *state = network_state_new(3);

  network_state_free(&state);
}
