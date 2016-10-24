#include "../../../native/lib/neural_network/gradient_descent.c"

#include "../../../native/lib/worker/batch_data.c"

#include "../fixtures/network_structure_fixtures.c"
#include "../fixtures/network_state_fixtures.c"
#include "../fixtures/data_fixtures.c"
#include "../fixtures/file_fixtures.c"

static void test_gradient_descent() {
  BatchData   *batch_data;
  BundlePaths *paths        = bundle_paths_new(2);
  WorkerData  *worker_data  = worker_data_new(2);

  paths->path[0] = create_first_data_bundle_file();
  paths->path[1] = create_second_data_bundle_file();

  worker_data_read(paths, worker_data);

  batch_data = new_batch_data(worker_data, 1);

  NetworkStructure *structure = network_structure_basic();
  NetworkState     *state     = network_state_basic();

  gradient_descent(
    worker_data,
    batch_data,
    state,
    structure,
    1
  );
}
