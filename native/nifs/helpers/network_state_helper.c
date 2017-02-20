static void
create_network_state_from_layers(
  ErlNifEnv      *env,
  WorkerResource *worker_resource,
  ERL_NIF_TERM    network_definition
) {
  (void)(env);
  (void)(worker_resource);
  (void)(network_definition);

  ERL_NIF_TERM layers_atom, input_atom, hidden_atom, output_atom,
               size_atom, activation_atom, dropout_atom, name_atom;
  ERL_NIF_TERM layers_map, input_map, hidden_list, hidden_map, output_map;
  uint32_t     hidden_length;

  layers_atom = enif_make_atom(env, "layers");
  enif_get_map_value(env, network_definition, layers_atom, &layers_map);

  input_atom  = enif_make_atom(env, "input" );
  hidden_atom = enif_make_atom(env, "hidden");
  output_atom = enif_make_atom(env, "output");

  enif_get_map_value(env, layers_map, input_atom,  &input_map  );
  enif_get_map_value(env, layers_map, hidden_atom, &hidden_list);
  enif_get_map_value(env, layers_map, output_atom, &output_map );

  enif_get_list_length(env, hidden_list, &hidden_length);
  worker_resource->network_state = network_state_new(hidden_length + 2);

  size_atom       = enif_make_atom(env, "size"      );
  activation_atom = enif_make_atom(env, "activation");
  dropout_atom    = enif_make_atom(env, "dropout"   );
  name_atom       = enif_make_atom(env, "name"      );

  for (int index = 0; index < hidden_length; index += 1) {
    enif_get_list_cell(env, hidden_list, &hidden_map, &hidden_list);
  }
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

  if (network_state != NULL) network_state_free(&network_state);

  create_network_state_from_layers(env, worker_resource, network_definition);
  create_network_state_objective(env, worker_resource, network_definition);
  create_network_state_presentation(env, worker_resource, network_definition);
}
