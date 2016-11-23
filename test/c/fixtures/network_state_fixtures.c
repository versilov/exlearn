#ifndef INCLUDE_NETWORK_STATE_FIXTURES_C
#define INCLUDE_NETWORK_STATE_FIXTURES_C

#include "../../../native/include/neural_network/activity.h"
#include "../../../native/include/neural_network/objective.h"
#include "../../../native/include/neural_network/presentation.h"
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
  NetworkState *network_state = network_state_new(4);
  Matrix        temp;

  // Input layer
  network_state->biases[0]  = NULL;
  network_state->weights[0] = NULL;

  // First Hidden Layer
  temp = matrix_new(1, 3);
  temp[2] = 1;
  temp[3] = 2;
  temp[4] = 3;
  network_state->biases[1] = temp;

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
  network_state->weights[1] = temp;

  // Second Hidden Layer
  temp = matrix_new(1, 2);
  temp[2] = 1;
  temp[3] = 2;
  network_state->biases[2] = temp;

  temp = matrix_new(3, 2);
  temp[2] = 1;
  temp[3] = 2;
  temp[4] = 3;
  temp[5] = 4;
  temp[6] = 5;
  temp[7] = 6;
  network_state->weights[2] = temp;

  // Output Layer
  temp = matrix_new(1, 2);
  temp[2] = 1;
  temp[3] = 2;
  network_state->biases[3] = temp;

  temp = matrix_new(2, 2);
  temp[2] = 1;
  temp[3] = 2;
  temp[4] = 3;
  temp[5] = 4;
  network_state->weights[3] = temp;

  network_state->rows[0]       = 1;
  network_state->columns[0]    = 3;
  network_state->dropout[0]    = 0;
  network_state->function[0]   = NULL;
  network_state->derivative[0] = NULL;

  network_state->rows[1]       = 3;
  network_state->columns[1]    = 3;
  network_state->dropout[1]    = 0;
  network_state->function[1]   = activity_determine_function(3, 0);
  network_state->derivative[1] = activity_determine_derivative(3, 0);

  network_state->rows[2]       = 3;
  network_state->columns[2]    = 2;
  network_state->dropout[2]    = 0;
  network_state->function[2]   = activity_determine_function(3, 0);
  network_state->derivative[2] = activity_determine_derivative(3, 0);

  network_state->rows[3]       = 2;
  network_state->columns[3]    = 2;
  network_state->dropout[3]    = 0;
  network_state->function[3]   = activity_determine_function(3, 0);
  network_state->derivative[3] = activity_determine_derivative(3, 0);

  network_state->presentation = presentation_determine(0, 0);
  network_state->objective    = objective_determine_function(2);
  network_state->error        = objective_determine_error_simple(2);

  return network_state;
}

static NetworkState *
network_state_with_dropout() {
  NetworkState *network_state = network_state_new(4);
  Matrix        temp;

  // Input layer
  network_state->biases[0]  = NULL;
  network_state->weights[0] = NULL;

  // First Hidden Layer
  temp = matrix_new(1, 3);
  temp[2] = 1;
  temp[3] = 2;
  temp[4] = 3;
  network_state->biases[1] = temp;

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
  network_state->weights[1] = temp;

  // Second Hidden Layer
  temp = matrix_new(1, 2);
  temp[2] = 1;
  temp[3] = 2;
  network_state->biases[2] = temp;

  temp = matrix_new(3, 2);
  temp[2] = 1;
  temp[3] = 2;
  temp[4] = 3;
  temp[5] = 4;
  temp[6] = 5;
  temp[7] = 6;
  network_state->weights[2] = temp;

  // Output Layer
  temp = matrix_new(1, 2);
  temp[2] = 1;
  temp[3] = 2;
  network_state->biases[3] = temp;

  temp = matrix_new(2, 2);
  temp[2] = 1;
  temp[3] = 2;
  temp[4] = 3;
  temp[5] = 4;
  network_state->weights[3] = temp;

  network_state->rows[0]       = 1;
  network_state->columns[0]    = 3;
  network_state->dropout[0]    = 0.5;
  network_state->function[0]   = NULL;
  network_state->derivative[0] = NULL;

  network_state->rows[1]       = 3;
  network_state->columns[1]    = 3;
  network_state->dropout[1]    = 0.5;
  network_state->function[1]   = activity_determine_function(3, 0);
  network_state->derivative[1] = activity_determine_derivative(3, 0);

  network_state->rows[2]       = 3;
  network_state->columns[2]    = 2;
  network_state->dropout[2]    = 0.5;
  network_state->function[2]   = activity_determine_function(3, 0);
  network_state->derivative[2] = activity_determine_derivative(3, 0);

  network_state->rows[3]       = 2;
  network_state->columns[3]    = 2;
  network_state->dropout[3]    = 0.5;
  network_state->function[3]   = activity_determine_function(3, 0);
  network_state->derivative[3] = activity_determine_derivative(3, 0);

  network_state->presentation = presentation_determine(0, 0);
  network_state->objective    = objective_determine_function(2);
  network_state->error        = objective_determine_error_simple(2);

  return network_state;
}

#endif
