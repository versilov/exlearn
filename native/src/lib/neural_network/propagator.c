#include "../../../include/neural_network/propagator.h"

Correction *
back_propagate(
  NetworkStructure *structure,
  NetworkState     *state,
  Activity         *activity,
  Matrix            expected
) {
  int         layers     = structure->layers;
  int         last_layer = layers - 1;
  Correction *correction = new_correction(layers);
  Matrix      error, weight_correction, input_gradient, output_gradient;

  error = structure->error(
    expected,
    activity->output[last_layer],
    activity->input[last_layer],
    structure->derivative[last_layer]
  );

  correction->biases[last_layer] = error;

  weight_correction = new_matrix(
    state->weights[last_layer][0], state->weights[last_layer][1]
  );
  matrix_dot_tn(activity->output[last_layer - 1], error, weight_correction);

  correction->weights[last_layer] = weight_correction;

  for (int layer = layers - 2; layer > 0; layer -= 1) {
    output_gradient = new_matrix(error[0], state->weights[layer + 1][0]);
    matrix_dot_nt(error, state->weights[layer + 1], output_gradient);

    input_gradient = new_matrix(activity->input[layer][0], activity->input[layer][1]);
    clone_matrix(input_gradient, activity->input[layer]);
    call_activity_closure(structure->derivative[layer], input_gradient);

    error = new_matrix(state->biases[layer][0], state->biases[layer][1]);
    matrix_multiply(output_gradient, input_gradient, error);

    if (activity->mask[layer] != NULL) {
      matrix_multiply(error, activity->mask[layer], error);
    }

    correction->biases[layer] = error;

    weight_correction = new_matrix(
      state->weights[layer][0], state->weights[layer][1]
    );
    matrix_dot_tn(activity->output[layer - 1], error, weight_correction);

    correction->weights[layer] = weight_correction;
  }

  return correction;
}
