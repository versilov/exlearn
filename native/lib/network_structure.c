#ifndef INCLUDE_NETWORK_STRUCTURE_C
#define INCLUDE_NETWORK_STRUCTURE_C

#include <stdlib.h>

#include "neural_network/presentation.c"
#include "structs.c"

static void
free_network_structure(NetworkStructure *structure) {
  free(structure->rows      );
  free(structure->columns   );
  free(structure->dropout   );
  free(structure->function  );
  free(structure->derivative);

  free_presentation_closure(structure->presentation);

  free(structure);
}

static NetworkStructure *
new_network_structure(int layers) {
  NetworkStructure *structure = malloc(sizeof(NetworkStructure));

  structure->layers       = layers;
  structure->rows         = malloc(sizeof(int)   * layers);
  structure->columns      = malloc(sizeof(int)   * layers);
  structure->dropout      = malloc(sizeof(float) * layers);
  structure->function     = malloc(sizeof(ActivityClosure *) * layers);
  structure->derivative   = malloc(sizeof(ActivityClosure *) * layers);
  structure->presentation = NULL;

  return structure;
}

#endif
