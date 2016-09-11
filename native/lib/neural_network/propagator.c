#ifndef INCLUDE_PROPAGATOR_C
#define INCLUDE_PROPAGATOR_C

#include "../structs.c"
#include "correction.c"

static Correction *
back_propagate(
  NetworkStructure *structure,
  NetworkState     *state,
  Activity         *activity
) {
  return new_correction(structure->layers);
}

#endif
