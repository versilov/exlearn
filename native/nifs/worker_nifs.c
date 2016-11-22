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

static void batch_data_destructor(ErlNifEnv *_env, void *batch_data) {
  (void)(_env);

  batch_data_free((BatchData **)(batch_data));
}

ErlNifResourceType *WORKER_DATA;

static void worker_data_destructor(ErlNifEnv *_env, void *worker_data) {
  (void)(_env);

  worker_data_free((WorkerData **)(&worker_data));
}

//------------------------------------------------------------------------------
// NIF API
//------------------------------------------------------------------------------

static ERL_NIF_TERM
create_batch_data(ErlNifEnv *env, int32_t argc, const ERL_NIF_TERM *argv) {
  BatchData    *batch_data, *batch_data_resource;
  WorkerData   *worker_data;
  ERL_NIF_TERM  result;
  int64_t       batch_length;

  (void)(argc);

  if (!enif_get_resource(env, argv[0], WORKER_DATA, (void **)(&worker_data)))
    return enif_make_badarg(env);
  if (!enif_get_int64(env, argv[1], &batch_length))
    return enif_make_badarg(env);

  batch_data = batch_data_new(worker_data, batch_length);
  shuffle_batch_data_indices(batch_data);

  batch_data_resource = enif_alloc_resource(BATCH_DATA, sizeof(BatchData));
  memcpy(batch_data_resource, batch_data, sizeof(BatchData));
  free(batch_data);

  result = enif_make_resource(env, batch_data_resource);
  enif_release_resource(&batch_data_resource);

  return result;
}

static ERL_NIF_TERM
create_worker_data(ErlNifEnv *env, int32_t argc, const ERL_NIF_TERM *argv) {
  BundlePaths  *bundle_paths;
  ErlNifBinary  path;
  ERL_NIF_TERM  list, head, tail, result;
  unsigned int  index, length;
  char         *new_path;
  WorkerData   *worker_data, *worker_data_resource;

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

  worker_data = worker_data_new(length);
  worker_data_read(bundle_paths, worker_data);

  worker_data_resource = enif_alloc_resource(WORKER_DATA, sizeof(WorkerData));
  memcpy(worker_data_resource, worker_data, sizeof(WorkerData));
  free(worker_data);

  result = enif_make_resource(env, worker_data_resource);
  enif_release_resource(&worker_data_resource);

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
