#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "erl_nif.h"

#include "../include/worker/worker_resource.h"

//------------------------------------------------------------------------------
// Destructor
//------------------------------------------------------------------------------

ErlNifResourceType *WORKER_RESOURCE;

static void worker_resource_destructor(ErlNifEnv *_env, void *resource_content) {
  (void)(_env);

  WorkerResource *worker_resource = (WorkerResource *)(resource_content);

  worker_resource_free(&worker_resource);
}

//------------------------------------------------------------------------------
// BatchData NIF API
//------------------------------------------------------------------------------

static ERL_NIF_TERM
generate_batch_data(ErlNifEnv *env, int32_t argc, const ERL_NIF_TERM *argv) {
  int64_t         batch_length;
  BatchData      *batch_data;
  WorkerData     *worker_data;
  WorkerResource *worker_resource;

  (void)(argc);

  worker_resource = NULL;
  if (!enif_get_resource(env, argv[0], WORKER_RESOURCE, (void **) &worker_resource))
    return enif_make_badarg(env);

  if (!enif_get_int64(env, argv[1], &batch_length))
    return enif_make_badarg(env);

  worker_data = worker_resource->worker_data;
  batch_data  = batch_data_new(worker_data, batch_length);

  worker_resource->batch_data = batch_data;

  return argv[0];
}

static ERL_NIF_TERM
shuffle_batch_data(ErlNifEnv *env, int32_t argc, const ERL_NIF_TERM *argv) {
  BatchData      *batch_data;
  WorkerResource *worker_resource;

  (void)(argc);

  worker_resource = NULL;
  if (!enif_get_resource(env, argv[0], WORKER_RESOURCE, (void **) &worker_resource))
    return enif_make_badarg(env);

  batch_data = worker_resource->batch_data;
  shuffle_batch_data_indices(batch_data);

  return argv[0];
}

//------------------------------------------------------------------------------
// NetworkState NIF API
//------------------------------------------------------------------------------

#include "./helpers/network_state_helper.c"

static ERL_NIF_TERM
create_network_state(ErlNifEnv *env, int32_t argc, const ERL_NIF_TERM *argv) {
  WorkerResource *worker_resource;

  (void)(argc);

  worker_resource = NULL;
  if (!enif_get_resource(env, argv[0], WORKER_RESOURCE, (void **) &worker_resource))
    return enif_make_badarg(env);

  if (!enif_is_map(env, argv[1])) return enif_make_badarg(env);

  create_network_state_from_definition(env, worker_resource, argv[1]);

  worker_resource_inspect(worker_resource);

  return argv[0];
}

//------------------------------------------------------------------------------
// WorkerData NIF API
//------------------------------------------------------------------------------

static ERL_NIF_TERM
read_worker_data(ErlNifEnv *env, int32_t argc, const ERL_NIF_TERM *argv) {
  BundlePaths    *bundle_paths;
  ERL_NIF_TERM    list, head, tail;
  unsigned int    index, length, string_length;
  char           *new_path;
  WorkerData     *worker_data;
  WorkerResource *worker_resource;

  (void)(argc);

  worker_resource = NULL;
  if (!enif_get_resource(env, argv[0], WORKER_RESOURCE, (void **) &worker_resource))
    return enif_make_badarg(env);

  list = argv[1];
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

  worker_data = worker_data_new(length);
  worker_data_read(bundle_paths, worker_data);

  bundle_paths_free(&bundle_paths);

  worker_resource->worker_data = worker_data;

  return argv[0];
}

//------------------------------------------------------------------------------
// WorkerResource NIF API
//------------------------------------------------------------------------------

static ERL_NIF_TERM
create_worker_resource(ErlNifEnv *env, int32_t argc, const ERL_NIF_TERM *argv) {
  ERL_NIF_TERM    result;
  WorkerResource *worker_resource;

  (void)(argc);
  (void)(argv);

  worker_resource = enif_alloc_resource(WORKER_RESOURCE, sizeof(WorkerResource));

  worker_resource_initialize(worker_resource);

  result = enif_make_resource(env, worker_resource);
  enif_release_resource(&worker_resource);

  return result;
}

//------------------------------------------------------------------------------
// Initialization
//------------------------------------------------------------------------------

static ErlNifFunc nif_functions[] = {
  {"create_network_state",   2, create_network_state,   0},
  {"create_worker_resource", 0, create_worker_resource, 0},
  {"generate_batch_data",    2, generate_batch_data,    0},
  {"read_worker_data",       2, read_worker_data,       0},
  {"shuffle_batch_data",     1, shuffle_batch_data,     0}
};

static int32_t load(ErlNifEnv *env, void **_priv_data, ERL_NIF_TERM _load_info) {
  (void)(_priv_data);
  (void)(_load_info);

  int32_t flags = ERL_NIF_RT_CREATE | ERL_NIF_RT_TAKEOVER;

  WORKER_RESOURCE = enif_open_resource_type(
    env, NULL, "WorkerResource", worker_resource_destructor, flags, NULL
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
