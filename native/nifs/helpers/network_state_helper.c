static void
create_network_state_from_layers(
  ErlNifEnv      *env,
  WorkerResource *worker_resource,
  ERL_NIF_TERM    network_definition
) {
  (void)(env);
  (void)(worker_resource);
  (void)(network_definition);

  ERL_NIF_TERM  layers_atom, input_atom, hidden_atom, output_atom,
                size_atom, activation_atom, dropout_atom, name_atom;
  ERL_NIF_TERM  columns_int, rows_int;
  ERL_NIF_TERM  hidden_list;
  ERL_NIF_TERM  layers_map, input_map, hidden_map, output_map;
  NetworkState *network_state;
  int32_t       columns, rows;
  uint32_t      hidden_length;

  layers_atom = enif_make_atom(env, "layers");
  enif_get_map_value(env, network_definition, layers_atom, &layers_map);

  input_atom  = enif_make_atom(env, "input" );
  hidden_atom = enif_make_atom(env, "hidden");
  output_atom = enif_make_atom(env, "output");

  enif_get_map_value(env, layers_map, input_atom,  &input_map  );
  enif_get_map_value(env, layers_map, hidden_atom, &hidden_list);
  enif_get_map_value(env, layers_map, output_atom, &output_map );

  enif_get_list_length(env, hidden_list, &hidden_length);

  network_state = network_state_new(hidden_length + 2);
  worker_resource->network_state = network_state;

  size_atom       = enif_make_atom(env, "size"      );
  activation_atom = enif_make_atom(env, "activation");
  dropout_atom    = enif_make_atom(env, "dropout"   );
  name_atom       = enif_make_atom(env, "name"      );

  enif_get_map_value(env, input_map, size_atom, &columns_int);
  enif_get_int(env, columns_int, &columns);
  network_state->rows[0]    = 1;
  network_state->columns[0] = columns;
  rows = columns;

  for (uint32_t index = 0; index < hidden_length; index += 1) {
    enif_get_list_cell(env, hidden_list, &hidden_map, &hidden_list);

    enif_get_map_value(env, hidden_map, size_atom, &columns_int);
    enif_get_int(env, columns_int, &columns);
    network_state->rows[index + 1]    = rows;
    network_state->columns[index + 1] = columns;
    rows = columns;
  }

  enif_get_map_value(env, output_map, size_atom, &columns_int);
  enif_get_int(env, columns_int, &columns);
  network_state->rows[hidden_length + 1]    = rows;
  network_state->columns[hidden_length + 1] = columns;
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
