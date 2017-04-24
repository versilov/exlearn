#ifndef INCLUDED_FORWARDER_H
#define INCLUDED_FORWARDER_H

#include "../matrix.h"
#include "../worker/worker_data.h"
#include "../network_state.h"

#include "./activation.h"
#include "./dropout.h"

Activation *
forward_for_activity(
  NetworkState *network_state,
  Matrix        sample
);

Matrix
forward_for_output(
  NetworkState *network_state,
  Matrix        sample
);

#endif
