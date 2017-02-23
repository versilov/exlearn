static void
extract_size_from_layers(
  ErlNifEnv    *env,
  NetworkState *network_state,
  ERL_NIF_TERM  input_map,
  ERL_NIF_TERM  hidden_list,
  ERL_NIF_TERM  output_map
) {
  ERL_NIF_TERM size_atom;
  ERL_NIF_TERM columns_int;
  ERL_NIF_TERM hidden_map;
  int32_t      columns, rows, hidden_length;

  size_atom = enif_make_atom(env, "size");

  enif_get_map_value(env, input_map, size_atom, &columns_int);
  enif_get_int(env, columns_int, &columns);
  network_state->rows[0]    = 1;
  network_state->columns[0] = columns;
  rows = columns;

  hidden_length = network_state->layers - 2;
  for (int32_t index = 0; index < hidden_length; index += 1) {
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
extract_activation_from_layers(
  ErlNifEnv    *env,
  NetworkState *network_state,
  ERL_NIF_TERM  input_map,
  ERL_NIF_TERM  hidden_list,
  ERL_NIF_TERM  output_map
) {
  (void)(input_map);

  ERL_NIF_TERM activation_atom;
  ERL_NIF_TERM activation_int;
  ERL_NIF_TERM hidden_map;
  int32_t      activation_id, hidden_length;

  activation_atom = enif_make_atom(env, "activation");

  hidden_length = network_state->layers - 2;
  for (int32_t index = 0; index < hidden_length; index += 1) {
    enif_get_list_cell(env, hidden_list, &hidden_map, &hidden_list);

    enif_get_map_value(env, hidden_map, activation_atom, &activation_int);
    enif_get_int(env, activation_int, &activation_id);

    // TODO: Extract alpha and use it in the closure.
    network_state->function[index + 1]   = activation_determine_function(activation_id, 0);
    network_state->derivative[index + 1] = activation_determine_derivative(activation_id, 0);
  }

  enif_get_map_value(env, output_map, activation_atom, &activation_int);
  enif_get_int(env, activation_int, &activation_id);

  // TODO: Extract alpha and use it in the closure.
  network_state->function[hidden_length + 1]   = activation_determine_function(activation_id, 0);
  network_state->derivative[hidden_length + 1] = activation_determine_derivative(activation_id, 0);
}

static void
extract_dropout_from_layers(
  ErlNifEnv    *env,
  NetworkState *network_state,
  ERL_NIF_TERM  input_map,
  ERL_NIF_TERM  hidden_list,
  ERL_NIF_TERM  output_map
) {
  (void)(output_map);

  ERL_NIF_TERM dropout_atom;
  ERL_NIF_TERM dropout_double;
  ERL_NIF_TERM hidden_map;
  double       dropout;
  int32_t      hidden_length;

  dropout_atom = enif_make_atom(env, "dropout");

  enif_get_map_value(env, input_map, dropout_atom, &dropout_double);
  enif_get_double(env, dropout_double, &dropout);
  network_state->dropout[0] = dropout;

  hidden_length = network_state->layers - 2;
  for (int32_t index = 0; index < hidden_length; index += 1) {
    enif_get_list_cell(env, hidden_list, &hidden_map, &hidden_list);

    enif_get_map_value(env, hidden_map, dropout_atom, &dropout_double);
    enif_get_double(env, dropout_double, &dropout);
    network_state->dropout[index + 1] = dropout;
  }
}

static void
extract_name_from_layers(
  ErlNifEnv    *env,
  NetworkState *network_state,
  ERL_NIF_TERM  input_map,
  ERL_NIF_TERM  hidden_list,
  ERL_NIF_TERM  output_map
) {
  (void)(env);
  (void)(network_state);
  (void)(input_map);
  (void)(hidden_list);
  (void)(output_map);

  // TODO: Implement this when `network_state` will have the name field defined.

  // name_atom = enif_make_atom(env, "name");
}

static void
create_network_state_from_layers(
  ErlNifEnv      *env,
  WorkerResource *worker_resource,
  ERL_NIF_TERM    network_definition
) {
  ERL_NIF_TERM  layers_atom, input_atom, hidden_atom, output_atom;
  ERL_NIF_TERM  hidden_list;
  ERL_NIF_TERM  layers_map, input_map, output_map;
  NetworkState *network_state;
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

  extract_size_from_layers(env, network_state, input_map, hidden_list, output_map);
  extract_activation_from_layers(env, network_state, input_map, hidden_list, output_map);
  extract_dropout_from_layers(env, network_state, input_map, hidden_list, output_map);
  extract_name_from_layers(env, network_state, input_map, hidden_list, output_map);
}

static void
create_network_state_objective(
  ErlNifEnv    *env,
  NetworkState *network_state,
  ERL_NIF_TERM  network_definition
) {
  ERL_NIF_TERM objective_atom;
  ERL_NIF_TERM objective_int;
  int          objective_id;

  objective_atom = enif_make_atom(env, "objective");
  enif_get_map_value(env, network_definition, objective_atom, &objective_int);
  enif_get_int(env, objective_int, &objective_id);

  network_state->objective_id = objective_id;
  network_state->objective    = objective_determine_function(objective_id);

  // TODO: Implement logic for optimised version of error.
  network_state->error_id = objective_id;
  network_state->error    = objective_determine_error_simple(objective_id);
}

static void
create_network_state_presentation(
  ErlNifEnv    *env,
  NetworkState *network_state,
  ERL_NIF_TERM  network_definition
) {
  ERL_NIF_TERM presentation_atom;
  ERL_NIF_TERM presentation_int;
  int          presentation_id;

  presentation_atom = enif_make_atom(env, "presentation");
  enif_get_map_value(env, network_definition, presentation_atom, &presentation_int);
  enif_get_int(env, presentation_int, &presentation_id);

  // TODO: Extract alpha and use it in the closure.
  network_state->presentation = presentation_closure_determine(presentation_id, 0);
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
  network_state = worker_resource->network_state;

  create_network_state_objective(env, network_state, network_definition);
  create_network_state_presentation(env, network_state, network_definition);
}
