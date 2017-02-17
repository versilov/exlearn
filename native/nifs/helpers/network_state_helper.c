static void
create_network_state_layers(
  ErlNifEnv      *env,
  WorkerResource *worker_resource,
  ERL_NIF_TERM    network_definition
) {
  (void)(env);
  (void)(worker_resource);
  (void)(network_definition);
}

static void
create_network_state_objective(
  ErlNifEnv      *env,
  WorkerResource *worker_resource,
  ERL_NIF_TERM    network_definition
) {
  (void)(env);
  (void)(worker_resource);
  (void)(network_definition);
}

static void
create_network_state_presentation(
  ErlNifEnv      *env,
  WorkerResource *worker_resource,
  ERL_NIF_TERM    network_definition
) {
  (void)(env);
  (void)(worker_resource);
  (void)(network_definition);
}

static void
create_network_state_from_definition(
  ErlNifEnv      *env,
  WorkerResource *worker_resource,
  ERL_NIF_TERM    network_definition
) {
  NetworkState *network_state = worker_resource->network_state;

  if (network_state != NULL) free_network_state(network_state);

  create_network_state_layers(env, worker_resource, network_definition);
  create_network_state_objective(env, worker_resource, network_definition);
  create_network_state_presentation(env, worker_resource, network_definition);
}
