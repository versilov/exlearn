#include "../../../native/lib/matrix.c"

static NetworkState *
network_state_basic() {
  NetworkState *state = new_network_state(4);
  Matrix temp;

  state->biases[0]  = NULL;
  state->weights[0] = NULL;

  temp = new_matrix(1, 3);
  temp[2] = 1;
  temp[3] = 2;
  temp[4] = 3;
  state->biases[1] = temp;

  temp = new_matrix(3, 3);
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

  temp = new_matrix(1, 2);
  temp[2] = 1;
  temp[3] = 2;
  state->biases[2] = temp;

  temp = new_matrix(3, 2);
  temp[2] = 1;
  temp[3] = 2;
  temp[4] = 3;
  temp[5] = 4;
  temp[6] = 5;
  temp[7] = 6;
  state->weights[2] = temp;

  temp = new_matrix(1, 2);
  temp[2] = 1;
  temp[3] = 2;
  state->biases[3] = temp;

  temp = new_matrix(2, 2);
  temp[2] = 1;
  temp[3] = 2;
  temp[4] = 3;
  temp[5] = 4;
  state->weights[3] = temp;

  return state;
}
