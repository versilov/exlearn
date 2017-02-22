#include "../../include/neural_network/activation.h"

void
activation_free(Activation **activation_address) {
  Activation * activation = *activation_address;

  for (int32_t layer = 0; layer < activation->layers; layer += 1) {
    if (activation->input[layer]  != NULL) free(activation->input[layer] );
    if (activation->mask[layer]   != NULL) free(activation->mask[layer]  );
    if (activation->output[layer] != NULL) free(activation->output[layer]);
  }

  free(activation->input );
  free(activation->output);
  free(activation->mask  );

  free(activation);

  *activation_address = NULL;
}

void
activation_inspect(Activation *activation) {
  printf("<#Activation\n");
  printf("  layers: %d\n", activation->layers);

  printf("  input:\n");
  for(int32_t index = 0; index < activation->layers; index += 1) {
    printf("    %d: ", index);

    if (activation->input[index] == NULL)
      printf("NULL");
    else
      matrix_inspect_internal(activation->input[index], 7);

    printf("\n");
  }

  printf("  output:\n");
  for(int32_t index = 0; index < activation->layers; index += 1) {
    printf("    %d: ", index);

    if (activation->output[index] == NULL)
      printf("NULL");
    else
      matrix_inspect_internal(activation->output[index], 7);

    printf("\n");
  }

  printf("  mask:\n");
  for(int32_t index = 0; index < activation->layers; index += 1) {
    printf("    %d: ", index);

    if (activation->mask[index] == NULL)
      printf("NULL");
    else
      matrix_inspect_internal(activation->mask[index], 7);

    if (index < activation->layers - 1) printf("\n");
  }

  printf(">\n");
}

void
activation_inspect_internal(Activation *activation, int32_t indentation) {
  printf("<#Activation\n");

  print_spaces(indentation);
  printf("  layers: %d\n", activation->layers);

  print_spaces(indentation);
  printf("  input:\n");
  for(int32_t index = 0; index < activation->layers; index += 1) {
    print_spaces(indentation);
    printf("    %d: ", index);

    if (activation->input[index] == NULL)
      printf("NULL");
    else
      matrix_inspect_internal(activation->input[index], indentation + 7);

    printf("\n");
  }

  print_spaces(indentation);
  printf("  output:\n");
  for(int32_t index = 0; index < activation->layers; index += 1) {
    print_spaces(indentation);
    printf("    %d: ", index);

    if (activation->output[index] == NULL)
      printf("NULL");
    else
      matrix_inspect_internal(activation->output[index], indentation + 7);

    printf("\n");
  }

  print_spaces(indentation);
  printf("  mask:\n");
  for(int32_t index = 0; index < activation->layers; index += 1) {
    print_spaces(indentation);
    printf("    %d: ", index);

    if (activation->mask[index] == NULL)
      printf("NULL");
    else
      matrix_inspect_internal(activation->mask[index], indentation + 7);

    if (index < activation->layers - 1) printf("\n");
  }

  printf(">");
}

Activation *
activation_new(int32_t layers) {
  Activation *activation = malloc(sizeof(Activation));

  activation->layers = layers;
  activation->input  = malloc(sizeof(Matrix) * layers);
  activation->output = malloc(sizeof(Matrix) * layers);
  activation->mask   = malloc(sizeof(Matrix) * layers);

  for (int32_t layer = 0; layer < layers; layer += 1) {
    activation->input[layer]  = NULL;
    activation->mask[layer]   = NULL;
    activation->output[layer] = NULL;
  }

  return activation;
}
