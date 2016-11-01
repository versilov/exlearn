#include "../include/network_structure.h"

void
free_network_structure(NetworkStructure *structure) {
  for (int layer = 0; layer < structure->layers; layer += 1) {
    free_activity_closure(structure->function[layer]  );
    free_activity_closure(structure->derivative[layer]);
  }

  free(structure->rows      );
  free(structure->columns   );
  free(structure->dropout   );
  free(structure->function  );
  free(structure->derivative);

  free_presentation_closure(structure->presentation);

  free(structure);
}

NetworkStructure *
new_network_structure(int layers) {
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

  for (int layer = 0; layer < layers; layer += 1) {
    structure->function[layer]   = NULL;
    structure->derivative[layer] = NULL;
  }

  return structure;
}
