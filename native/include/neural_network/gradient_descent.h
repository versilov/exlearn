#ifndef INCLUDED_GRADIENT_DESCENT_H
#define INCLUDED_GRADIENT_DESCENT_H

#include <stdint.h>

#include "../worker/batch_data.h"
#include "../worker/worker_data.h"
#include "./correction.h"
#include "./forwarder.h"
#include "./propagator.h"

Correction *
gradient_descent(
  WorkerData   *worker_data,
  BatchData    *batch_data,
  NetworkState *network_state,
  int32_t       current_batch
);

#endif
