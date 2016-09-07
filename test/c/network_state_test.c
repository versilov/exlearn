#include <assert.h>
#include <stdlib.h>

#include "../../native/lib/network_state.c"

//-----------------------------------------------------------------------------
// Tests
//-----------------------------------------------------------------------------

static void test_free_network_state() {
  NetworkState *state = new_network_state(3);

  free_network_state(state);
}

static void test_new_network_state() {
  NetworkState *state = new_network_state(3);

  free_network_state(state);
}

//-----------------------------------------------------------------------------
// Run Tests
//-----------------------------------------------------------------------------

int main() {
  test_free_network_state();
  test_new_network_state();

  return 0;
}
