#include "../../../include/neural_network/gradient_descent.h"

Correction *
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

  SampleIndex      *sample_index;
  WorkerDataBundle *bundle;
  Matrix            input, expected;
  Activity         *activity;
  Correction       *correction;

  int length    = batch_data->batch_length;
  int remaining = batch_data->data_length - length * current_batch;

  if (remaining < length) length = remaining;

  for (int index = 0; index < length; index += 1) {
    // Process each sample.
    sample_index = batch_data_get_sample_index(batch_data, current_batch, index);
    bundle       = worker_data->bundle[sample_index->bundle];
    input        = bundle->first[index];
    expected     = bundle->second[index];

    activity   = forward_for_activity(network_structure, network_state, input);
    correction = back_propagate(network_structure, network_state, activity, expected);
  }

  return correction;
}
