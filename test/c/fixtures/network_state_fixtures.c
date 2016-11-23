#ifndef INCLUDE_NETWORK_STATE_FIXTURES_C
#define INCLUDE_NETWORK_STATE_FIXTURES_C

#include "../../../native/include/matrix.h"

static NetworkState *
network_state_simple() {
  NetworkState *network_state = network_state_new(2);
  Matrix        temp;

  // Input layer
  network_state->biases[0]  = NULL;
  network_state->weights[0] = NULL;

  // Output Layer
  temp = matrix_new(1, 2);
  temp[2] = 1;
  temp[3] = 2;
  network_state->biases[1] = temp;

  temp = matrix_new(2, 2);
  temp[2] = 1;
  temp[3] = 2;
  temp[4] = 3;
  temp[5] = 4;
  network_state->weights[1] = temp;

  return network_state;
}

static NetworkState *
network_state_basic() {
  NetworkState *state = network_state_new(4);
  Matrix        temp;

  // Input layer
  state->biases[0]  = NULL;
  state->weights[0] = NULL;

  // First Hidden Layer
  temp = matrix_new(1, 3);
  temp[2] = 1;
  temp[3] = 2;
  temp[4] = 3;
  state->biases[1] = temp;

  temp = matrix_new(3, 3);
  temp[ 2] = 1;
  temp[ 3] = 2;
  temp[ 4] = 3;
  temp[ 5] = 4;
  temp[ 6] = 5;
  temp[ 7] = 6;
  temp[ 8] = 7;
  temp[ 9] = 8;
  temp[10] = 9;
  state->weights[1] = temp;

  // Second Hidden Layer
  temp = matrix_new(1, 2);
  temp[2] = 1;
  temp[3] = 2;
  state->biases[2] = temp;

  temp = matrix_new(3, 2);
  temp[2] = 1;
  temp[3] = 2;
  temp[4] = 3;
  temp[5] = 4;
  temp[6] = 5;
  temp[7] = 6;
  state->weights[2] = temp;

  // Output Layer
  temp = matrix_new(1, 2);
  temp[2] = 1;
  temp[3] = 2;
  state->biases[3] = temp;

  temp = matrix_new(2, 2);
  temp[2] = 1;
  temp[3] = 2;
  temp[4] = 3;
  temp[5] = 4;
  state->weights[3] = temp;

  return state;
}

#endif
