#ifndef INCLUDED_NETWORK_STRUCTURE_H
#define INCLUDED_NETWORK_STRUCTURE_H

#include <stdlib.h>

#include "./neural_network/activity.h"
#include "./neural_network/objective.h"
#include "./neural_network/presentation.h"

typedef struct NetworkStructure {
  int                   layers;
  int                  *rows;
  int                  *columns;
  float                *dropout;
  ActivityClosure     **function;
  ActivityClosure     **derivative;
  PresentationClosure  *presentation;
  ObjectiveFunction     objective;
  ObjectiveError        error;
} NetworkStructure;

void
free_network_structure(NetworkStructure *structure);

NetworkStructure *
new_network_structure(int layers);

#endif
