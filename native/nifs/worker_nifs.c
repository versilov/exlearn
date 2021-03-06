#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "erl_nif.h"

#include "../include/worker/worker_resource.h"
#include "../include/neural_network/gradient_descent.h"
#include "../include/neural_network/forwarder.h"

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

#include "./helpers/create_network_state_helper.c"

static ERL_NIF_TERM
create_network_state(ErlNifEnv *env, int32_t argc, const ERL_NIF_TERM *argv) {
  WorkerResource *worker_resource;

  (void)(argc);

  worker_resource = NULL;
  if (!enif_get_resource(env, argv[0], WORKER_RESOURCE, (void **) &worker_resource))
    return enif_make_badarg(env);

  if (!enif_is_map(env, argv[1])) return enif_make_badarg(env);

  create_network_state_from_definition(env, worker_resource, argv[1]);

  return argv[0];
}

#include "./helpers/initialize_network_state_helper.c"

static ERL_NIF_TERM
initialize_network_state(ErlNifEnv *env, int32_t argc, const ERL_NIF_TERM *argv) {
  WorkerResource *worker_resource;

  (void)(argc);

  worker_resource = NULL;
  if (!enif_get_resource(env, argv[0], WORKER_RESOURCE, (void **) &worker_resource))
    return enif_make_badarg(env);

  if (!enif_is_map(env, argv[1])) return enif_make_badarg(env);

  initialize_network_state_from_parameters(env, worker_resource, argv[1]);

  return argv[0];
}

//----------------------------------------------------------------------------
// Neural Network NIF API
//----------------------------------------------------------------------------

static ERL_NIF_TERM
neural_network_predict(ErlNifEnv *env, int32_t argc, const ERL_NIF_TERM *argv) {
  (void)(argc);

  ERL_NIF_TERM result_list;
  ERL_NIF_TERM output_binary;

  WorkerResource   *worker_resource;
  WorkerData       *worker_data;
  WorkerDataBundle *bundle;
  NetworkState     *network_state;

  Matrix  sample, output;
  int32_t output_size;

  worker_resource = NULL;
  if (!enif_get_resource(env, argv[0], WORKER_RESOURCE, (void **) &worker_resource))
    return enif_make_badarg(env);

  worker_data   = worker_resource->worker_data;
  network_state = worker_resource->network_state;

  result_list = enif_make_list(env, 0);

  for (int data_index = 0; data_index < worker_data->count; data_index += 1) {
    bundle = worker_data->bundle[data_index];

    for(int bundle_index = 0; bundle_index < bundle->count; bundle_index += 1) {
      sample = bundle->second[bundle_index];

      output = forward_for_output(network_state, sample);
      output_size = sizeof(float) * (int32_t) (output[0] * output[1] + 2);

      enif_make_new_binary(env, output_size, &output_binary);
      result_list = enif_make_list_cell(env, output_binary, result_list);
    }
  }

  return result_list;
}

static ERL_NIF_TERM
neural_network_test(ErlNifEnv *env, int32_t argc, const ERL_NIF_TERM *argv) {
  (void)(argc);

  ERL_NIF_TERM error_double;
  ERL_NIF_TERM match_int;
  ERL_NIF_TERM result_tuple;

  WorkerResource *worker_resource;
  WorkerData     *worker_data;
  NetworkState   *network_state;

  float   error = 0.0;
  int64_t match = 0;

  worker_resource = NULL;
  if (!enif_get_resource(env, argv[0], WORKER_RESOURCE, (void **) &worker_resource))
    return enif_make_badarg(env);

  worker_data   = worker_resource->worker_data;
  network_state = worker_resource->network_state;

  forward_for_test(worker_data, network_state, &error, &match);

  error_double = enif_make_double(env, error);
  match_int = enif_make_int64(env, match);
  result_tuple = enif_make_tuple2(env, error_double, match_int);

  return result_tuple;
}

static ERL_NIF_TERM
neural_network_train(ErlNifEnv *env, int32_t argc, const ERL_NIF_TERM *argv) {
  (void)(argc);

  WorkerResource *worker_resource;
  WorkerData     *worker_data;
  BatchData      *batch_data;
  NetworkState   *network_state;

  Correction    *correction;
  int32_t        correction_size;
  unsigned char *char_array;
  ERL_NIF_TERM   result;

  int64_t current_batch;

  worker_resource = NULL;
  if (!enif_get_resource(env, argv[0], WORKER_RESOURCE, (void **) &worker_resource))
    return enif_make_badarg(env);

  if (!enif_get_int64(env, argv[1], &current_batch))
    return enif_make_badarg(env);

  worker_data   = worker_resource->worker_data;
  batch_data    = worker_resource->batch_data;
  network_state = worker_resource->network_state;

  correction = gradient_descent(
    worker_data, batch_data, network_state, current_batch);

  correction_size = correction_char_size(correction);
  char_array = enif_make_new_binary(env, correction_size, &result);
  correction_to_char_array(correction, char_array);
  correction_free(&correction);

  return result;
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
  {"create_network_state",     2, create_network_state,     0},
  {"initialize_network_state", 2, initialize_network_state, 0},
  {"create_worker_resource",   0, create_worker_resource,   0},
  {"generate_batch_data",      2, generate_batch_data,      0},
  {"neural_network_predict",   2, neural_network_predict,   0},
  {"neural_network_test",      2, neural_network_test,      0},
  {"neural_network_train",     2, neural_network_train,     0},
  {"read_worker_data",         2, read_worker_data,         0},
  {"shuffle_batch_data",       1, shuffle_batch_data,       0}
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
