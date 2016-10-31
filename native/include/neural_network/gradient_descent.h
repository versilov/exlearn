#ifndef INCLUDED_GRADIENT_DESCENT_C
#define INCLUDED_GRADIENT_DESCENT_C

// #include "../../../native/lib/neural_network/forwarder.c"
// #include "../../../native/lib/neural_network/propagator.c"
//
// #include "../worker/batch_data.c"
// #include "../worker/worker_data.c"

Correction *
gradient_descent(
  WorkerData       *worker_data,
  BatchData        *batch_data,
  NetworkState     *network_state,
  NetworkStructure *network_structure,
  int               current_batch
);

#endif
