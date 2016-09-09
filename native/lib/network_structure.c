#ifndef INCLUDE_NETWORK_STRUCTURE_C
#define INCLUDE_NETWORK_STRUCTURE_C

#include <stdlib.h>

#include "structs.c"

static void
free_network_structure(NetworkStructure *structure) {
  free(structure->rows    );
  free(structure->columns );
  free(structure->dropout );
  free(structure->activity);

  free(structure);
}

static NetworkStructure *
new_network_structure(int layers) {
  NetworkStructure *structure = malloc(sizeof(NetworkStructure));

  structure->layers   = layers;
  structure->rows     = malloc(sizeof(int)   * layers);
  structure->columns  = malloc(sizeof(int)   * layers);
  structure->dropout  = malloc(sizeof(float) * layers);
  structure->activity = malloc(sizeof(ActivityClosure *) * layers);

  return structure;
}

#endif
