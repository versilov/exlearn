#include "../../include/neural_network/forwarder.h"

Activation *
forward_for_activity(NetworkState *network_state, Matrix sample) {
  int32_t     layers   = network_state->layers;
  Activation *activity = activation_new(layers);
  Matrix      input, output, mask, biases, weights;

  input = matrix_new(sample[0], sample[1]);
  matrix_clone(input, sample);

  if (network_state->dropout[0]) {
    mask = create_dropout_mask(input[0], input[1], network_state->dropout[0]);

    matrix_multiply(input, mask, input);

    activity->mask[0] = mask;
  }

  output = input;

  activity->output[0] = output;

  for (int32_t layer = 1; layer < layers; layer += 1) {
    biases  = network_state->biases[layer];
    weights = network_state->weights[layer];

    input = matrix_new(output[0], weights[1]);
    matrix_dot_and_add(output, weights, biases, input);

    activity->input[layer] = input;

    if (network_state->dropout[layer]) {
      mask = create_dropout_mask(input[0], input[1], network_state->dropout[layer]);
    }
    else {
      mask = NULL;
    }

    activity->mask[layer] = mask;

    output = matrix_new(input[0], input[1]);
    matrix_clone(output, input);

    activation_closure_call(network_state->function[layer], output);

    if (mask != NULL) matrix_multiply(output, mask, output);

    activity->output[layer] = output;
  }

  return activity;
}

Matrix
forward_for_output(NetworkState *network_state, Matrix sample) {
  int32_t layers = network_state->layers;
  Matrix  input, output;

  output = matrix_new(network_state->rows[1], network_state->columns[1]);
  matrix_dot_and_add(
    sample, network_state->weights[1], network_state->biases[1], output
  );
  activation_closure_call(network_state->function[1], output);
  input = output;

  for (int32_t layer = 1; layer < layers; layer += 1) {
    output = matrix_new(network_state->rows[layer], network_state->columns[layer]);
    matrix_dot_and_add(
      input, network_state->weights[layer], network_state->biases[layer], output
    );
    activation_closure_call(network_state->function[1], output);

    matrix_free(&input);
    input = output;
  }

  return output;
}
