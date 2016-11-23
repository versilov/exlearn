#include "../../../native/include/neural_network/gradient_descent.h"
#include "../../../native/include/worker/batch_data.h"

#include "../fixtures/network_state_fixtures.c"
#include "../fixtures/data_fixtures.c"
#include "../fixtures/file_fixtures.c"

static void test_gradient_descent() {
  BatchData   *batch_data;
  Correction  *correction;
  BundlePaths *paths        = bundle_paths_new(2);
  WorkerData  *worker_data  = worker_data_new(2);

  paths->path[0] = create_first_data_bundle_file();
  paths->path[1] = create_second_data_bundle_file();

  worker_data_read(paths, worker_data);

  batch_data = batch_data_new(worker_data, 1);

  NetworkState *network_state = network_state_basic();

  correction = gradient_descent(
    worker_data,
    batch_data,
    network_state,
    1
  );

  assert(correction != NULL); /* LCOV_EXCL_BR_LINE */

  assert(correction->layers == 3); /* LCOV_EXCL_BR_LINE */
  for (int32_t layer = 0; layer < correction->layers; layer += 1) {
    int32_t length;

    printf("Layer: %d\n", layer);

    printf("Biases:");
    length = correction->biases[layer][0] + correction->biases[layer][1] + 2;
    for (int index = 0; index < length; index += 1)
      printf(" %f", correction->biases[layer][index]);
    printf("\n");

    printf("Weights:");
    length = correction->weights[layer][0] + correction->weights[layer][1] + 2;
    for (int index = 0; index < length; index += 1)
      printf(" %f", correction->weights[layer][index]);
    printf("\n");
  }
}
