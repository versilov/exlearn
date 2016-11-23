#include <stdint.h>

#include "erl_nif.h"

#include "../include/neural_network/correction.h"
#include "../include/matrix.h"

//-----------------------------------------------------------------------------
// Exported nifs
//-----------------------------------------------------------------------------

static ERL_NIF_TERM
from_c(ErlNifEnv *env, int32_t argc, const ERL_NIF_TERM *argv) {
  (void)(env );
  (void)(argc);
  (void)(argv);

  Correction    *correction;
  int32_t        correction_size;
  unsigned char *char_array;
  ERL_NIF_TERM   result;

  correction = correction_new(1);
  correction->biases[0]  = matrix_new(1, 2);
  correction->weights[0] = matrix_new(2, 2);

  correction->biases[0][2] = 0.0;
  correction->biases[0][3] = 1.0;

  correction->weights[0][2] = 0.0;
  correction->weights[0][3] = 1.0;
  correction->weights[0][4] = 2.0;
  correction->weights[0][5] = 3.0;

  correction_size = correction_char_size(correction);

  char_array = enif_make_new_binary(env, correction_size, &result);

  correction_to_char_array(correction, char_array);

  correction_free(&correction);

  return result;
}

static ErlNifFunc nif_functions[] = {
  {"from_c", 0, from_c, 0}
};

ERL_NIF_INIT(
  Elixir.ExLearn.NeuralNetwork.Correction,
  nif_functions,
  NULL, NULL, NULL, NULL
)
