#include "../../../native/lib/neural_network/forwarder.c"
#include "../fixtures/network_structure_fixtures.c"
#include "../fixtures/network_state_fixtures.c"
#include "../fixtures/data_fixtures.c"

#include <stdio.h>
static void test_forward_for_output() {
  NetworkStructure *structure = network_structure_basic();
  NetworkState     *state     = network_state_basic();
  Matrix            sample    = data_sample_basic();

  int result = forward_for_output(structure, state, sample);

  assert(result == 1);
}
