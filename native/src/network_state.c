#include "../include/network_state.h"

void
network_state_free(NetworkState **network_state_address) {
  NetworkState *network_state = *network_state_address;

  for (int32_t layer = 0; layer < network_state->layers; layer += 1) {
    matrix_free(&network_state->biases[layer] );
    matrix_free(&network_state->weights[layer]);

    activation_closure_free(&network_state->function[layer]  );
    activation_closure_free(&network_state->derivative[layer]);
  }

  free(network_state->rows      );
  free(network_state->columns   );
  free(network_state->biases    );
  free(network_state->weights   );
  free(network_state->dropout   );
  free(network_state->function  );
  free(network_state->derivative);

  presentation_closure_free(&network_state->presentation);

  free(network_state);

  *network_state_address = NULL;
}

void
network_state_inspect(NetworkState *network_state) {
  printf("<#NetworkState\n");

  printf("  layers:  %d\n", network_state->layers);

  printf("  rows:   ");
  for(int32_t index = 0; index < network_state->layers; index += 1) {
    printf(" %d", network_state->rows[index]);
  }
  printf("\n");

  printf("  columns:");
  for(int32_t index = 0; index < network_state->layers; index += 1) {
    printf(" %d", network_state->columns[index]);
  }
  printf("\n");

  printf("  biases:\n");
  for(int32_t index = 0; index < network_state->layers; index += 1) {
    printf("    %d: ", index);

    if (network_state->biases[index] == NULL)
      printf("NULL");
    else
      matrix_inspect_internal(network_state->biases[index], 7);

    printf("\n");
  }

  printf("  weights:\n");
  for(int32_t index = 0; index < network_state->layers; index += 1) {
    printf("    %d: ", index);

    if (network_state->weights[index] == NULL)
      printf("NULL");
    else
      matrix_inspect_internal(network_state->weights[index], 7);

    printf("\n");
  }

  printf("  dropout:");
  for(int32_t index = 0; index < network_state->layers; index += 1) {
    printf(" %f", network_state->dropout[index]);
  }
  printf("\n");

  printf("  function:\n");
  for(int32_t index = 0; index < network_state->layers; index += 1) {
    printf("    %d: ", index);

    if (network_state->function[index] == NULL)
      printf("NULL");
    else
      activation_closure_inspect_internal(network_state->function[index], 7);

    printf("\n");
  }

  printf("  derivative:\n");
  for(int32_t index = 0; index < network_state->layers; index += 1) {
    printf("    %d: ", index);

    if (network_state->derivative[index] == NULL)
      printf("NULL");
    else
      activation_closure_inspect_internal(network_state->derivative[index], 7);

    printf("\n");
  }

  printf("  presentation: ");
  presentation_closure_inspect_internal(network_state->presentation, 7);
  printf("\n");

  printf("  objective: F\n");

  printf("  error:     F>\n");
}

void
network_state_inspect_internal(NetworkState *network_state, int32_t indentation) {
  printf("<#NetworkState\n");

  print_spaces(indentation);
  printf("  layers:  %d\n", network_state->layers);

  print_spaces(indentation);
  printf("  rows:   ");
  for(int32_t index = 0; index < network_state->layers; index += 1) {
    printf(" %d", network_state->rows[index]);
  }
  printf("\n");

  print_spaces(indentation);
  printf("  columns:");
  for(int32_t index = 0; index < network_state->layers; index += 1) {
    printf(" %d", network_state->columns[index]);
  }
  printf("\n");

  print_spaces(indentation);
  printf("  biases:\n");
  for(int32_t index = 0; index < network_state->layers; index += 1) {
    print_spaces(indentation);
    printf("    %d: ", index);

    if (network_state->biases[index] == NULL)
      printf("NULL");
    else
      matrix_inspect_internal(network_state->biases[index], indentation + 7);

    printf("\n");
  }

  print_spaces(indentation);
  printf("  weights:\n");
  for(int32_t index = 0; index < network_state->layers; index += 1) {
    print_spaces(indentation);
    printf("    %d: ", index);

    if (network_state->weights[index] == NULL)
      printf("NULL");
    else
      matrix_inspect_internal(network_state->weights[index], indentation + 7);

    printf("\n");
  }

  print_spaces(indentation);
  printf("  dropout:");
  for(int32_t index = 0; index < network_state->layers; index += 1) {
    printf(" %f", network_state->dropout[index]);
  }
  printf("\n");

  print_spaces(indentation);
  printf("  function:\n");
  for(int32_t index = 0; index < network_state->layers; index += 1) {
    print_spaces(indentation);
    printf("    %d: ", index);

    if (network_state->function[index] == NULL)
      printf("NULL");
    else
      activation_closure_inspect_internal(
        network_state->function[index],
        indentation + 7
      );

    printf("\n");
  }

  print_spaces(indentation);
  printf("  derivative:\n");
  for(int32_t index = 0; index < network_state->layers; index += 1) {
    print_spaces(indentation);
    printf("    %d: ", index);

    if (network_state->derivative[index] == NULL)
      printf("NULL");
    else
      activation_closure_inspect_internal(
        network_state->derivative[index],
        indentation + 7
      );

    printf("\n");
  }

  print_spaces(indentation);
  printf("  presentation: ");
  presentation_closure_inspect_internal(
    network_state->presentation,
    indentation + 7
  );
  printf("\n");

  print_spaces(indentation);
  printf("  objective: F\n");

  print_spaces(indentation);
  printf("  error:     F>");
}

NetworkState *
network_state_new(int32_t layers) {
  NetworkState *network_state = malloc(sizeof(NetworkState));

  network_state->layers       = layers;
  network_state->rows         = malloc(sizeof(int)    * layers);
  network_state->columns      = malloc(sizeof(int)    * layers);
  network_state->biases       = malloc(sizeof(Matrix) * layers);
  network_state->weights      = malloc(sizeof(Matrix) * layers);
  network_state->dropout      = malloc(sizeof(float)  * layers);
  network_state->function     = malloc(sizeof(ActivationClosure *) * layers);
  network_state->derivative   = malloc(sizeof(ActivationClosure *) * layers);
  network_state->presentation = NULL;
  network_state->objective    = NULL;
  network_state->error        = NULL;

  for (int32_t layer = 0; layer < layers; layer += 1) {
    network_state->biases[layer]     = NULL;
    network_state->weights[layer]    = NULL;
    network_state->function[layer]   = NULL;
    network_state->derivative[layer] = NULL;
  }

  return network_state;
}
