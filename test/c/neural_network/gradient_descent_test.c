#include "../../../native/include/neural_network/gradient_descent.h"
#include "../../../native/include/worker/batch_data.h"

#include "../fixtures/network_state_fixtures.c"
#include "../fixtures/data_fixtures.c"
#include "../fixtures/file_fixtures.c"

static void test_gradient_descent() {
  BatchData    *batch_data;
  Correction   *correction, *expected;
  NetworkState *network_state;
  BundlePaths  *paths       = bundle_paths_new(1);
  WorkerData   *worker_data = worker_data_new(1);

  paths->path[0] = create_basic_data_bundle_file();

  worker_data_read(paths, worker_data);

  batch_data    = batch_data_new(worker_data, 2);
  network_state = network_state_basic();
  expected      = correction_expected_basic_bundle_file();

  correction = gradient_descent(
    worker_data,
    batch_data,
    network_state,
    0
  );

  assert(correction != NULL); /* LCOV_EXCL_BR_LINE */

  assert(correction->layers == 3); /* LCOV_EXCL_BR_LINE */

  for (int32_t layer = 0; layer < correction->layers; layer += 1) {
    assert(matrix_equal(correction->biases[layer],  expected->biases[layer])); /* LCOV_EXCL_BR_LINE */
    assert(matrix_equal(correction->weights[layer], expected->weights[layer])); /* LCOV_EXCL_BR_LINE */
  }

  batch_data_free(&batch_data);
  correction_free(&correction);
  network_state_free(&network_state);
  bundle_paths_free(&paths);
  worker_data_free(&worker_data);
}
