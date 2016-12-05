#ifndef INCLUDED_PROPAGATOR_H
#define INCLUDED_PROPAGATOR_H

#include "../../include/neural_network/activation.h"
#include "../../include/neural_network/correction.h"
#include "../../include/network_state.h"

Correction *
back_propagate(
  NetworkState *network_state,
  Activation   *activity,
  Matrix        expected
);

#endif
