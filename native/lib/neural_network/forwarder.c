#ifndef INCLUDE_FORWARDER_C
#define INCLUDE_FORWARDER_C

#include "../activity.c"
#include "../matrix.c"
#include "../network_state.c"
#include "../network_structure.c"

static int
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

  return call_presentation_closure(structure->presentation, output);
}

#endif
