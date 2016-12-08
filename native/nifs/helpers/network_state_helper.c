static void
create_network_state_from_definition(
  ErlNifEnv      *env,
  WorkerResource *worker_resource,
  NetworkState   *network_state
) {
  create_network_state_layers(env, worker_resource, network_definition);
  create_network_state_objective(env, worker_resource, network_definition);
  create_network_state_presentation(env, worker_resource, network_definition);
}
