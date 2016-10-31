#ifndef INCLUDED_PROPAGATOR_H
#define INCLUDED_PROPAGATOR_H

// #include "../structs.c"
// #include "correction.c"

Correction *
back_propagate(
  NetworkStructure *structure,
  NetworkState     *state,
  Activity         *activity,
  Matrix            expected
);

#endif
