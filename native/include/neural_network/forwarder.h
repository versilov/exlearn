#ifndef INCLUDED_FORWARDER_H
#define INCLUDED_FORWARDER_H

#include "../matrix.h"
#include "../network_state.h"
#include "../network_structure.h"

#include "./activity.h"
#include "./dropout.h"

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
