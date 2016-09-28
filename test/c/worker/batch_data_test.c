#include "../../../native/lib/worker/batch_data.c"

#include "../fixtures/file_fixtures.c"

//-----------------------------------------------------------------------------
// Tests
//-----------------------------------------------------------------------------

static void test_free_batch_data() {
  BatchData        *batch;
  BundlePaths      *paths = bundle_paths_new(2);
  WorkerData       *data  = worker_data_new(2);

  paths->path[0] = create_first_data_bundle_file();
  paths->path[1] = create_second_data_bundle_file();

  worker_data_read(paths, data);

  batch = new_batch_data(data, 1);

  free_batch_data(batch);
}

static void test_new_batch_data() {
  BatchData        *batch;
  BundlePaths      *paths = bundle_paths_new(2);
  WorkerData       *data  = worker_data_new(2);

  paths->path[0] = create_first_data_bundle_file();
  paths->path[1] = create_second_data_bundle_file();

  worker_data_read(paths, data);

  batch = new_batch_data(data, 1);

  assert(batch->data_length  == 3);
  assert(batch->batch_length == 1);

  for (int index = 0; index < 3; index += 1) {
    // TODO: assert values within range;
  }

  free_batch_data(batch);
}

static void test_shuffle_batch_data_indices() {
  BatchData        *batch;
  BundlePaths      *paths = bundle_paths_new(2);
  WorkerData       *data  = worker_data_new(2);

  paths->path[0] = create_first_data_bundle_file();
  paths->path[1] = create_second_data_bundle_file();

  worker_data_read(paths, data);

  batch = new_batch_data(data, 1);

  shuffle_batch_data_indices(batch);

  for (int index = 0; index < 3; index += 1) {
    // TODO: assert values within range;
  }

  free_batch_data(batch);
}
