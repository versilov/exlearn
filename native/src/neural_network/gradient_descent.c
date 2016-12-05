#include "../../include/neural_network/gradient_descent.h"

Correction *
gradient_descent(
  WorkerData   *worker_data,
  BatchData    *batch_data,
  NetworkState *network_state,
  int32_t       current_batch
) {
  (void)(worker_data  );
  (void)(network_state);

  SampleIndex      *sample_index;
  WorkerDataBundle *bundle;
  Matrix            input, expected;
  Activation       *activity;
  Correction       *correction, *result;

  int32_t length    = batch_data->batch_length;
  int32_t remaining = batch_data->data_length - length * current_batch;

  if (remaining < length) length = remaining;

  correction = NULL;
  result     = NULL;

  for (int32_t index = 0; index < length; index += 1) {
    sample_index = batch_data_get_sample_index(batch_data, current_batch, index);
    bundle       = worker_data->bundle[sample_index->bundle];
    input        = bundle->first[index];
    expected     = bundle->second[index];

    activity   = forward_for_activity(network_state, input);
    correction = back_propagate(network_state, activity, expected);

    if (result == NULL) result = correction;
    else {
      correction_accumulate(result, correction);
      correction_free(&correction);
    }
  }

  return result;
}
