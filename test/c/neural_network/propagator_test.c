#include "../../../native/lib/neural_network/propagator.c"

#include "../fixtures/activity_fixtures.c"
#include "../fixtures/data_fixtures.c"
#include "../fixtures/network_structure_fixtures.c"
#include "../fixtures/network_state_fixtures.c"

static void test_back_propagate() {
  NetworkStructure *structure = network_structure_basic();
  NetworkState     *state     = network_state_basic();
  Matrix            expected  = data_expected_basic();
  Activity         *activity  = activity_expected_basic();

  Correction *correction = back_propagate(structure, state, activity, expected);

  assert(correction != NULL);
}

static void test_back_propagate_with_dropout() {
  NetworkStructure *structure = network_structure_with_dropout();
  NetworkState     *state     = network_state_basic();
  Matrix            expected  = data_expected_basic();
  Activity         *activity  = activity_expected_with_dropout();

  Correction *correction = back_propagate(structure, state, activity, expected);

  assert(correction != NULL);
}
