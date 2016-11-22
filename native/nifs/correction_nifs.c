#include "erl_nif.h"

#include "../include/neural_network/correction.h"
#include "../include/matrix.h"

//-----------------------------------------------------------------------------
// Exported nifs
//-----------------------------------------------------------------------------

static ERL_NIF_TERM
from_c(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  (void)(env );
  (void)(argc);

  Correction   *correction = correction_new(1);

  correction->biases[0]  = matrix_new(1, 1);
  correction->weights[0] = matrix_new(1, 1);

  matrix_fill(correction->biases[0],  1);
  matrix_fill(correction->weights[0], 1);

  return argv[0];
}

static ErlNifFunc nif_functions[] = {
  {"from_c", 0, from_c, 0}
};

ERL_NIF_INIT(
  Elixir.ExLearn.NeuralNetwork.Correction,
  nif_functions,
  NULL, NULL, NULL, NULL
)
