#include "../../../native/lib/worker/bundle_paths.c"
#include "../../../native/lib/worker/worker_data.c"

#include "../fixtures/file_fixtures.c"

static void test_worker_data_free() {
  WorkerData *data = worker_data_new(4);

  assert(data->count  == 4   );
  assert(data->bundle != NULL);

  for (int index = 0; index < data->count; index += 1) {
    assert(data->bundle[index] == NULL);
  }

  worker_data_free(&data);
}

static void test_worker_data_read() {
  BundlePaths *paths = bundle_paths_new(2);
  WorkerData  *data  = worker_data_new(2);

  paths->path[0] = create_first_data_bundle_file();
  paths->path[1] = create_second_data_bundle_file();

  worker_data_read(paths, data);

  bundle_paths_free(&paths);
  worker_data_free(&data);
}

static void test_worker_data_new() {
  WorkerData *data = worker_data_new(4);

  worker_data_free(&data);

  assert(data == NULL);
}
