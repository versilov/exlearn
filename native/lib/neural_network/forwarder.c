#ifndef INCLUDE_FORWARDER_C
#define INCLUDE_FORWARDER_C

#include "../matrix.c"
#include "../network_state.c"
#include "../network_structure.c"
#include "activity.c"

static Activity *
forward_for_activity(
  NetworkStructure *structure,
  NetworkState     *state,
  Matrix            sample
) {
  int       layers   = structure->layers;
  Activity *activity = new_activity(layers);
  Matrix    input, output, mask, biases, weights;

  input = new_matrix(sample[0], sample[1]);
  clone_matrix(input, sample);

  if (structure->dropout[0]) {
    mask = create_dropout_mask(input[0], input[1], structure->dropout[0]);

    matrix_multiply(input, mask, input);

    activity->mask[0] = mask;
  }

  output = input;

  activity->output[0] = output;

  for (int layer = 1; layer < layers; layer += 1) {
    biases  = state->biases[layer];
    weights = state->weights[layer];

    input = new_matrix(output[0], weights[1]);
    matrix_dot_and_add(output, weights, biases, input);

    activity->input[layer] = input;

    if (structure->dropout[layer]) {
      mask = create_dropout_mask(input[0], input[1], structure->dropout[layer]);
    }
    else {
      mask = NULL;
    }

    activity->mask[layer] = mask;

    output = new_matrix(input[0], input[1]);
    clone_matrix(output, input);

    call_activity_closure(structure->function[layer], output);

    if (mask != NULL) matrix_multiply(output, mask, output);

    activity->output[layer] = output;
  }

  return activity;
}

static Matrix
forward_for_output(
  NetworkStructure *structure,
  NetworkState     *state,
  Matrix            sample
) {
  int    layers = structure->layers;
  Matrix input, output;

  output = new_matrix(structure->rows[1], structure->columns[1]);
  matrix_dot_and_add(
    sample, state->weights[1], state->biases[1], output
  );
  call_activity_closure(structure->function[1], output);
  input = output;

  for (int layer = 1; layer < layers; layer += 1) {
    output = new_matrix(structure->rows[layer], structure->columns[layer]);
    matrix_dot_and_add(
      input, state->weights[layer], state->biases[layer], output
    );
    call_activity_closure(structure->function[1], output);

    free_matrix(input);
    input = output;
  }

  return output;
}

#endif
