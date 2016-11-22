#include "../include/network_structure.h"

void
network_structure_free(NetworkStructure **structure_address) {
  NetworkStructure *structure = *structure_address;

  for (int32_t layer = 0; layer < structure->layers; layer += 1) {
    free_activity_closure(structure->function[layer]  );
    free_activity_closure(structure->derivative[layer]);
  }

  free(structure->rows      );
  free(structure->columns   );
  free(structure->dropout   );
  free(structure->function  );
  free(structure->derivative);

  presentation_closure_free(&structure->presentation);

  free(structure);

  *structure_address = NULL;
}

NetworkStructure *
network_structure_new(int32_t layers) {
  NetworkStructure *structure = malloc(sizeof(NetworkStructure));

  structure->layers       = layers;
  structure->rows         = malloc(sizeof(int)   * layers);
  structure->columns      = malloc(sizeof(int)   * layers);
  structure->dropout      = malloc(sizeof(float) * layers);
  structure->function     = malloc(sizeof(ActivityClosure *) * layers);
  structure->derivative   = malloc(sizeof(ActivityClosure *) * layers);
  structure->presentation = NULL;
  structure->objective    = NULL;
  structure->error        = NULL;

  for (int32_t layer = 0; layer < layers; layer += 1) {
    structure->function[layer]   = NULL;
    structure->derivative[layer] = NULL;
  }

  return structure;
}
