#include "erl_nif.h"

static ERL_NIF_TERM
create_worker_data(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  (void)(env);
  (void)(argc);
  (void)(argv);

  return 0;
}

static ErlNifFunc nif_functions[] = {
  {"create_worker_data", 1, create_worker_data, 0}
};

ERL_NIF_INIT(Elixir.ExLearn.NeuralNetwork.Worker, nif_functions, NULL, NULL, NULL, NULL) /* LCOV_EXCL_LINE */
