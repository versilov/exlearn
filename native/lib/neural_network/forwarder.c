#ifndef INCLUDE_FORWARDER_C
#define INCLUDE_FORWARDER_C

#include "../matrix.c"
#include "../network_state.c"
#include "../network_structure.c"

static Matrix
forward_for_output(
  NetworkStructure *structure,
  NetworkState     *state,
  int               batch_number,
  Matrix            sample
) {
  return sample;
}

#endif
