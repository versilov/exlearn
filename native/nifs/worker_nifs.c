#include <stdio.h>
#include <string.h>

#include "erl_nif.h"

#include "../lib/worker/bundle_paths.c"

static ERL_NIF_TERM
create_worker_data(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  BundlePaths  *bundle_paths;
  ErlNifBinary  path;
  ERL_NIF_TERM  list, head, tail;
  unsigned int  index, length;
  char         *new_path;

  (void)(argc);

  list = argv[0];
  if (!enif_is_list(env, list)) return enif_make_badarg(env);

  enif_get_list_length(env, list, &length);
  bundle_paths = bundle_paths_new(length);

  index = 0;
  tail  = list;
  while (enif_get_list_cell(env, tail, &head, &tail)) {
    if (!enif_inspect_binary(env, head, &path)) return enif_make_badarg(env);

    new_path = malloc(sizeof(char) * path.size);
    memcpy(new_path, path.data, path.size);

    bundle_paths->path[index] = new_path;

    index += 1;
  }

  bundle_paths_free(&bundle_paths);

  return argv[0];
}

static ErlNifFunc nif_functions[] = {
  {"create_worker_data", 1, create_worker_data, 0}
};

ERL_NIF_INIT(Elixir.ExLearn.NeuralNetwork.Worker, nif_functions, NULL, NULL, NULL, NULL)
