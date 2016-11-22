#ifndef INCLUDED_NETWORK_STRUCTURE_H
#define INCLUDED_NETWORK_STRUCTURE_H

#include <stdint.h>
#include <stdlib.h>

#include "./neural_network/activity.h"
#include "./neural_network/objective.h"
#include "./neural_network/presentation.h"

typedef struct NetworkStructure {
  int32_t               layers;
  int32_t              *rows;
  int32_t              *columns;
  float                *dropout;
  ActivityClosure     **function;
  ActivityClosure     **derivative;
  PresentationClosure  *presentation;
  ObjectiveFunction     objective;
  ObjectiveError        error;
} NetworkStructure;

void
network_structure_free(NetworkStructure **structure);

NetworkStructure *
network_structure_new(int32_t layers);

#endif
