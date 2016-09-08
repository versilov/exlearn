static void
free_network_state(NetworkState *state) {
  free(state->biases );
  free(state->weights);

  free(state);
}

static NetworkState *
new_network_state(int layers) {
  NetworkState *state = malloc(sizeof(NetworkState));

  state->layers  = layers;
  state->biases  = malloc(sizeof(int) * layers);
  state->weights = malloc(sizeof(int) * layers);

  return state;
}
