#include "../../../native/lib/worker/batch_data.c"

#include "../fixtures/file_fixtures.c"

//-----------------------------------------------------------------------------
// Tests
//-----------------------------------------------------------------------------

static void test_free_batch_data() {
  BatchData   *batch;
  BundlePaths *paths = bundle_paths_new(2);
  WorkerData  *data  = worker_data_new(2);

  paths->path[0] = create_first_data_bundle_file();
  paths->path[1] = create_second_data_bundle_file();

  worker_data_read(paths, data);

  batch = new_batch_data(data, 1);

  free_batch_data(batch);
}

static void test_new_batch_data() {
  BatchData   *batch;
  BundlePaths *paths = bundle_paths_new(2);
  WorkerData  *data  = worker_data_new(2);

  paths->path[0] = create_first_data_bundle_file();
  paths->path[1] = create_second_data_bundle_file();

  worker_data_read(paths, data);

  batch = new_batch_data(data, 1);

  assert(batch->data_length  == 3); /* LCOV_EXCL_BR_LINE */
  assert(batch->batch_length == 1); /* LCOV_EXCL_BR_LINE */

  assert(batch->sample_index[0]->bundle == 0); /* LCOV_EXCL_BR_LINE */
  assert(batch->sample_index[0]->index  == 0); /* LCOV_EXCL_BR_LINE */
  assert(batch->sample_index[1]->bundle == 1); /* LCOV_EXCL_BR_LINE */
  assert(batch->sample_index[1]->index  == 0); /* LCOV_EXCL_BR_LINE */
  assert(batch->sample_index[2]->bundle == 1); /* LCOV_EXCL_BR_LINE */
  assert(batch->sample_index[2]->index  == 1); /* LCOV_EXCL_BR_LINE */

  free_batch_data(batch);
}

static void test_shuffle_batch_data_indices() {
  BatchData   *batch;
  BundlePaths *paths = bundle_paths_new(2);
  WorkerData  *data  = worker_data_new(2);

  paths->path[0] = create_first_data_bundle_file();
  paths->path[1] = create_second_data_bundle_file();

  worker_data_read(paths, data);

  batch = new_batch_data(data, 1);

  shuffle_batch_data_indices(batch);

  for (int index = 0; index < batch->data_length; index += 1) {
    assert(batch->sample_index[index]->bundle == 0 || batch->sample_index[index]->bundle == 1); /* LCOV_EXCL_BR_LINE */
    assert(batch->sample_index[index]->index == 0 || batch->sample_index[index]->index == 1); /* LCOV_EXCL_BR_LINE */
  }

  free_batch_data(batch);
}

static void test_batch_data_get_sample_index() {
  BatchData   *batch_data;
  BundlePaths *bundle_paths = bundle_paths_new(2);
  WorkerData  *worker_data  = worker_data_new(2);
  SampleIndex *sample_index;

  bundle_paths->path[0] = create_first_data_bundle_file();
  bundle_paths->path[1] = create_second_data_bundle_file();

  worker_data_read(bundle_paths, worker_data);

  batch_data = new_batch_data(worker_data, 1);

  sample_index = batch_data_get_sample_index(batch_data, 0, 0);
  assert(sample_index->bundle == 0); /* LCOV_EXCL_BR_LINE */
  assert(sample_index->index  == 0); /* LCOV_EXCL_BR_LINE */

  sample_index = batch_data_get_sample_index(batch_data, 1, 0);
  assert(sample_index->bundle == 1); /* LCOV_EXCL_BR_LINE */
  assert(sample_index->index  == 0); /* LCOV_EXCL_BR_LINE */

  sample_index = batch_data_get_sample_index(batch_data, 1, 1);
  assert(sample_index->bundle == 1); /* LCOV_EXCL_BR_LINE */
  assert(sample_index->index  == 1); /* LCOV_EXCL_BR_LINE */
}
