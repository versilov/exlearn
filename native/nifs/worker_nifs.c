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
// NIF API
//------------------------------------------------------------------------------

static ERL_NIF_TERM
create_worker_resource(ErlNifEnv *env, int32_t argc, const ERL_NIF_TERM *argv) {
  ERL_NIF_TERM    result;
  WorkerResource *worker_resource;

  (void)(argc);
  (void)(argv);

  worker_resource = enif_alloc_resource(WORKER_RESOURCE, sizeof(WorkerResource));

  result = enif_make_resource(env, worker_resource);
  enif_release_resource(&worker_resource);

  return result;
}

//------------------------------------------------------------------------------
// Initialization
//------------------------------------------------------------------------------

static ErlNifFunc nif_functions[] = {
  {"create_worker_resource", 0, create_worker_resource, 0}
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
