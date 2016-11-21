#include "../../../native/include/neural_network/gradient_descent.h"
#include "../../../native/include/worker/batch_data.h"

#include "../fixtures/network_structure_fixtures.c"
#include "../fixtures/network_state_fixtures.c"
#include "../fixtures/data_fixtures.c"
#include "../fixtures/file_fixtures.c"

static void test_gradient_descent() {
  BatchData   *batch_data;
  Correction  *correction   = NULL;
  BundlePaths *paths        = bundle_paths_new(2);
  WorkerData  *worker_data  = worker_data_new(2);

  paths->path[0] = create_first_data_bundle_file();
  paths->path[1] = create_second_data_bundle_file();

  worker_data_read(paths, worker_data);

  batch_data = batch_data_new(worker_data, 1);

  NetworkStructure *structure = network_structure_basic();
  NetworkState     *state     = network_state_basic();

  correction = gradient_descent(
    worker_data,
    batch_data,
    state,
    structure,
    1
  );

  assert(correction != NULL); /* LCOV_EXCL_BR_LINE */
}
