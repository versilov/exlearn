#include "../../../native/lib/neural_network/forwarder.c"

static void test_forward_for_output() {
  int layers = 3;

  NetworkStructure *structure    = new_network_structure(layers);
  NetworkState     *state        = new_network_state(layers);
  int               batch_number = 0;
  Matrix            sample       = new_matrix(1, 2);

  Matrix result = forward_for_output(structure, state, batch_number, sample);

  assert(result == sample);
}
