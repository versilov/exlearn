#include "../../../native/lib/neural_network/propagator.c"
#include "../fixtures/network_structure_fixtures.c"
#include "../fixtures/network_state_fixtures.c"
#include "../fixtures/data_fixtures.c"

static void test_back_propagate() {
  NetworkStructure *structure = network_structure_basic();
  NetworkState     *state     = network_state_basic();
  Matrix            sample    = data_sample_basic();

  Activity   *activity   = forward_for_activity(structure, state, sample);
  Correction *correction = back_propagate(structure, state, activity);

  assert(correction != NULL);
}
