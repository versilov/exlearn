#ifndef INCLUDED_GRADIENT_DESCENT_C
#define INCLUDED_GRADIENT_DESCENT_C

#include "../worker/batch_data.c"
#include "../worker/worker_data.c"

static void
gradient_descent(
  WorkerData *worker_data,
  BatchData  *batch_data,
  int         current_batch
) {
  (void)(worker_data);
  (void)(batch_data);
  (void)(current_batch);

  return;
}

#endif
