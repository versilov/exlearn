static void
initialize_network_state_using_normal_distribution(
  NetworkState *network_state,
  double        deviation,
  double        mean
) {
  Matrix   matrix;
  gsl_rng *rng;
  float    sample;
  int32_t  rows, columns;

  gsl_rng_env_setup();
  rng = gsl_rng_alloc(gsl_rng_default);
  gsl_rng_set(rng, time(NULL));

  for (int32_t index = 1; index < network_state->layers; index += 1) {
    rows    = network_state->rows[index];
    columns = network_state->columns[index];

    matrix = matrix_new(1, columns);
    for(int32_t matrix_index = 2; matrix_index < columns + 2; matrix_index += 1) {
      sample = (float) gsl_ran_ugaussian(rng) * deviation + mean;

      matrix[matrix_index] = sample;
    }

    network_state->biases[index] = matrix;

    matrix = matrix_new(rows, columns);
    for(int32_t matrix_index = 2; matrix_index < rows * columns + 2; matrix_index += 1) {
      sample = (float) gsl_ran_ugaussian(rng) * deviation + mean;

      matrix[matrix_index] = sample;
    }

    network_state->weights[index] = matrix;
  }
}

static void
initialize_network_state_using_uniform_distribution(
  NetworkState *network_state,
  double        minimum,
  double        maximum
) {
  Matrix   matrix;
  gsl_rng *rng;
  float    sample;
  int32_t  rows, columns;

  gsl_rng_env_setup();
  rng = gsl_rng_alloc(gsl_rng_default);
  gsl_rng_set(rng, time(NULL));

  for (int32_t index = 1; index < network_state->layers; index += 1) {
    rows    = network_state->rows[index];
    columns = network_state->columns[index];

    matrix = matrix_new(1, columns);
    for(int32_t matrix_index = 2; matrix_index < columns + 2; matrix_index += 1) {
      sample = (float) gsl_ran_flat(rng, minimum, maximum);

      matrix[matrix_index] = sample;
    }

    network_state->biases[index] = matrix;

    matrix = matrix_new(rows, columns);
    for(int32_t matrix_index = 2; matrix_index < rows * columns + 2; matrix_index += 1) {
      sample = (float) gsl_ran_flat(rng, minimum, maximum);

      matrix[matrix_index] = sample;
    }

    network_state->weights[index] = matrix;
  }
}

static void
initialize_network_state_from_parameters(
  ErlNifEnv      *env,
  WorkerResource *worker_resource,
  ERL_NIF_TERM   initialization_parameters
) {
  ERL_NIF_TERM  deviation_atom, distribution_atom, maximum_atom, mean_atom,
                minimum_atom, normal_atom, uniform_atom;
  ERL_NIF_TERM  deviation_double, maximum_double, mean_double, minimum_double;
  ERL_NIF_TERM  distribution;
  NetworkState *network_state;
  double        deviation, maximum, mean, minimum;

  network_state = worker_resource->network_state;

  distribution_atom = enif_make_atom(env, "distribution");
  normal_atom       = enif_make_atom(env, "normal"      );
  uniform_atom      = enif_make_atom(env, "uniform"     );
  enif_get_map_value(env, initialization_parameters, distribution_atom, &distribution);

  if (distribution == normal_atom) {
    deviation_atom = enif_make_atom(env, "deviation");
    mean_atom      = enif_make_atom(env, "mean"     );

    enif_get_map_value(env, initialization_parameters, deviation_atom, &deviation_double);
    enif_get_double(env, deviation_double, &deviation);

    enif_get_map_value(env, initialization_parameters, mean_atom, &mean_double);
    enif_get_double(env, mean_double, &mean);

    initialize_network_state_using_normal_distribution(network_state, deviation, mean);
  }
  else if (distribution == uniform_atom) {
    maximum_atom = enif_make_atom(env, "maximum");
    minimum_atom = enif_make_atom(env, "minimum");

    enif_get_map_value(env, initialization_parameters, maximum_atom, &maximum_double);
    enif_get_double(env, maximum_double, &maximum);

    enif_get_map_value(env, initialization_parameters, minimum_atom, &minimum_double);
    enif_get_double(env, minimum_double, &minimum);

    initialize_network_state_using_uniform_distribution(network_state, minimum, maximum);
  }
}
