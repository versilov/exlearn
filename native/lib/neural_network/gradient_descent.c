#ifndef INCLUDED_GRADIENT_DESCENT_C
#define INCLUDED_GRADIENT_DESCENT_C

#include "../worker/batch_data.c"
#include "../worker/worker_data.c"

static void
gradient_descent(
  WorkerData       *worker_data,
  BatchData        *batch_data,
  NetworkState     *network_state,
  NetworkStructure *network_structure,
  int               current_batch
) {
  (void)(worker_data      );
  (void)(network_state    );
  (void)(network_structure);
  (void)(current_batch    );

  for (int index = 0; index < batch_data->batch_length; index += 1) {
    // Process each sample.
  }

  return;
}

#endif
