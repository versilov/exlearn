#ifndef INCLUDE_FORWARDER_C
#define INCLUDE_FORWARDER_C

#include "../matrix.c"
#include "../network_state.c"
#include "../network_structure.c"
#include "activity.c"

Activity *
forward_for_activity(
  NetworkStructure *structure,
  NetworkState     *state,
  Matrix            sample
);

Matrix
forward_for_output(
  NetworkStructure *structure,
  NetworkState     *state,
  Matrix            sample
);

#endif
