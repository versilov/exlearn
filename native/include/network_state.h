#ifndef INCLUDED_NETWORK_STATE_H
#define INCLUDED_NETWORK_STATE_H

#include <stdint.h>
#include <stdlib.h>

#include "./matrix.h"
#include "./neural_network/activity.h"
#include "./neural_network/objective.h"
#include "./neural_network/presentation.h"


typedef struct NetworkState {
  int32_t               layers;
  int32_t              *rows;
  int32_t              *columns;
  Matrix               *biases;
  Matrix               *weights;
  float                *dropout;
  ActivityClosure     **function;
  ActivityClosure     **derivative;
  PresentationClosure  *presentation;
  ObjectiveFunction     objective;
  ObjectiveError        error;
} NetworkState;

void
network_state_free(NetworkState **state);

NetworkState *
network_state_new(int32_t layers);

#endif
