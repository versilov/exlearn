#ifndef INCLUDED_NETWORK_STATE_H
#define INCLUDED_NETWORK_STATE_H

#include <stdint.h>
#include <stdlib.h>

#include "./matrix.h"
#include "./neural_network/activation.h"
#include "./neural_network/objective.h"
#include "./neural_network/presentation_closure.h"

typedef struct NetworkState {
  int32_t               layers;
  int32_t              *rows;
  int32_t              *columns;
  Matrix               *biases;
  Matrix               *weights;
  float                *dropout;
  ActivationClosure   **function;
  ActivationClosure   **derivative;
  PresentationClosure  *presentation;
  ObjectiveFunction     objective;
  int32_t               objective_id;
  ObjectiveError        error;
  int32_t               error_id;
} NetworkState;

void
network_state_free(NetworkState **state);

void
network_state_inspect(NetworkState *network_state);

void
network_state_inspect_internal(NetworkState *network_state, int32_t indentation);

NetworkState *
network_state_new(int32_t layers);

#endif
