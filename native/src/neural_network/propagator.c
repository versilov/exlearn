#include "../../include/neural_network/propagator.h"

Correction *
back_propagate(
  NetworkStructure *structure,
  NetworkState     *state,
  Activity         *activity,
  Matrix            expected
) {
  int32_t     layers     = structure->layers;
  int32_t     last_layer = layers - 1;
  Correction *correction = correction_new(layers);
  Matrix      error, weight_correction, input_gradient, output_gradient;

  error = structure->error(
    expected,
    activity->output[last_layer],
    activity->input[last_layer],
    structure->derivative[last_layer]
  );

  correction->biases[last_layer] = error;

  weight_correction = matrix_new(
    state->weights[last_layer][0], state->weights[last_layer][1]
  );
  matrix_dot_tn(activity->output[last_layer - 1], error, weight_correction);

  correction->weights[last_layer] = weight_correction;

  for (int32_t layer = layers - 2; layer > 0; layer -= 1) {
    output_gradient = matrix_new(error[0], state->weights[layer + 1][0]);
    matrix_dot_nt(error, state->weights[layer + 1], output_gradient);

    input_gradient = matrix_new(activity->input[layer][0], activity->input[layer][1]);
    matrix_clone(input_gradient, activity->input[layer]);
    call_activity_closure(structure->derivative[layer], input_gradient);

    error = matrix_new(state->biases[layer][0], state->biases[layer][1]);
    matrix_multiply(output_gradient, input_gradient, error);

    if (activity->mask[layer] != NULL) {
      matrix_multiply(error, activity->mask[layer], error);
    }

    correction->biases[layer] = error;

    weight_correction = matrix_new(
      state->weights[layer][0], state->weights[layer][1]
    );
    matrix_dot_tn(activity->output[layer - 1], error, weight_correction);

    correction->weights[layer] = weight_correction;
  }

  return correction;
}
