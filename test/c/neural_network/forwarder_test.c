#include "../../../native/lib/neural_network/forwarder.c"
#include "../fixtures/network_structure_fixtures.c"
#include "../fixtures/network_state_fixtures.c"
#include "../fixtures/data_fixtures.c"

static void test_forward_for_activity() {
  NetworkStructure *structure = network_structure_basic();
  NetworkState     *state     = network_state_basic();
  Matrix            sample    = data_sample_basic();

  Activity *activity = forward_for_activity(structure, state, sample);

  assert(activity->layers == structure->layers);

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

  assert(result == 1);

  free_matrix(output);
  free_matrix(sample);
  free_network_state(state);
  free_network_structure(structure);
}
