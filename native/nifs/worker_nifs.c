#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "erl_nif.h"

#include "../include/worker/batch_data.h"
#include "../include/worker/bundle_paths.h"
#include "../include/worker/worker_data.h"

//------------------------------------------------------------------------------
// Resource definition
//------------------------------------------------------------------------------

ErlNifResourceType *BATCH_DATA;
ErlNifResourceType *WORKER_DATA;

static void batch_data_destructor(ErlNifEnv *_env, void *resource_content) {
  (void)(_env);

  BatchData *batch_data = (BatchData *)(resource_content);

  batch_data_free(&batch_data);
}

static void worker_data_destructor(ErlNifEnv *_env, void *resource_content) {
  (void)(_env);

  WorkerData *worker_data = (WorkerData *)(resource_content);

  worker_data_free(&worker_data);
}

//------------------------------------------------------------------------------
// NIF API
//------------------------------------------------------------------------------

static ERL_NIF_TERM
create_batch_data(ErlNifEnv *env, int32_t argc, const ERL_NIF_TERM *argv) {
  BatchData    *batch_data;
  WorkerData   *worker_data;
  ERL_NIF_TERM  result;
  int64_t       batch_length;

  (void)(argc);

  if (!enif_get_resource(env, argv[0], WORKER_DATA, (void **)(&worker_data)))
    return enif_make_badarg(env);
  if (!enif_get_int64(env, argv[1], &batch_length))
    return enif_make_badarg(env);

  batch_data = enif_alloc_resource(BATCH_DATA, sizeof(BatchData));
  batch_data_initialize(batch_data, worker_data, batch_length);
  shuffle_batch_data_indices(batch_data);

  result = enif_make_resource(env, batch_data);
  enif_release_resource(&batch_data);

  return result;
}

static ERL_NIF_TERM
create_worker_data(ErlNifEnv *env, int32_t argc, const ERL_NIF_TERM *argv) {
  BundlePaths  *bundle_paths;
  ERL_NIF_TERM  list, head, tail, result;
  unsigned int  index, length, string_length;
  char         *new_path;
  WorkerData   *worker_data;

  (void)(argc);

  list = argv[0];
  if (!enif_is_list(env, list)) return enif_make_badarg(env);

  enif_get_list_length(env, list, &length);
  bundle_paths = bundle_paths_new(length);

  index = 0;
  tail  = list;
  while (enif_get_list_cell(env, tail, &head, &tail)) {
    if (!enif_is_list(env, head)) return enif_make_badarg(env);

    enif_get_list_length(env, head, &string_length);
    new_path = malloc(sizeof(char) * string_length + 1);

    if (!enif_get_string(env, head, new_path, string_length + 1, ERL_NIF_LATIN1))
      return enif_make_badarg(env);

    bundle_paths->paths[index] = new_path;

    index += 1;
  }

  worker_data = enif_alloc_resource(WORKER_DATA, sizeof(WorkerData));
  worker_data_initialize(worker_data, length);
  worker_data_read(bundle_paths, worker_data);

  result = enif_make_resource(env, worker_data);
  enif_release_resource(&worker_data);

  bundle_paths_free(&bundle_paths);

  return result;
}

//------------------------------------------------------------------------------
// Initialization
//------------------------------------------------------------------------------

static ErlNifFunc nif_functions[] = {
  {"create_batch_data",  2, create_batch_data,  0},
  {"create_worker_data", 1, create_worker_data, 0}
};

static int32_t load(ErlNifEnv *env, void **_priv_data, ERL_NIF_TERM _load_info) {
  (void)(_priv_data);
  (void)(_load_info);

  int32_t flags = ERL_NIF_RT_CREATE | ERL_NIF_RT_TAKEOVER;

  BATCH_DATA = enif_open_resource_type(
    env, NULL, "BatchData", batch_data_destructor, flags, NULL
  );

  WORKER_DATA = enif_open_resource_type(
    env, NULL, "WorkerData", worker_data_destructor, flags, NULL
  );

  return 0;
}

static int32_t upgrade(
  ErlNifEnv     *_env,
  void         **_priv_data,
  void         **_old_priv_data,
  ERL_NIF_TERM   _load_info
) {
  (void)(_env          );
  (void)(_priv_data    );
  (void)(_old_priv_data);
  (void)(_load_info    );

  return 0;
}

ERL_NIF_INIT(
  Elixir.ExLearn.NeuralNetwork.Worker,
  nif_functions,
  load, NULL, upgrade, NULL
)
