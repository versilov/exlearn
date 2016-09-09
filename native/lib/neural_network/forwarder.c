#ifndef INCLUDE_FORWARDER_C
#define INCLUDE_FORWARDER_C

#include "../matrix.c"
#include "../network_state.c"
#include "../network_structure.c"

static Matrix
forward_for_output(
  NetworkStructure *structure,
  NetworkState     *state,
  Matrix            sample
) {
  int    layers = structure->layers;
  Matrix output;

  for (int layer = 1; layer < layers; layer += 1) {

  }

  return sample;
}

#endif
