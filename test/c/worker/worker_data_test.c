#include "../../../native/include/worker/bundle_paths.h"
#include "../../../native/include/worker/worker_data.h"

#include "../fixtures/file_fixtures.c"

static void test_worker_data_free() {
  WorkerData *data = worker_data_new(4);

  assert(data->count  == 4   ); /* LCOV_EXCL_BR_LINE */
  assert(data->bundle != NULL); /* LCOV_EXCL_BR_LINE */

  for (int index = 0; index < data->count; index += 1) {
    assert(data->bundle[index] == NULL); /* LCOV_EXCL_BR_LINE */
  }

  worker_data_free(&data);
}

static void test_worker_data_new() {
  WorkerData *data = worker_data_new(4);

  worker_data_free(&data);

  assert(data == NULL); /* LCOV_EXCL_BR_LINE */
}

static void test_worker_data_read() {
  BundlePaths      *paths = bundle_paths_new(2);
  WorkerData       *data  = worker_data_new(2);
  WorkerDataBundle *bundle;

  paths->path[0] = create_first_data_bundle_file();
  paths->path[1] = create_second_data_bundle_file();

  worker_data_read(paths, data);

  assert(data->count == 2); /* LCOV_EXCL_BR_LINE */

  bundle = data->bundle[0];
  assert(bundle->count         == 1); /* LCOV_EXCL_BR_LINE */
  assert(bundle->first_length  == 3); /* LCOV_EXCL_BR_LINE */
  assert(bundle->second_length == 3); /* LCOV_EXCL_BR_LINE */
  assert(bundle->maximum_step  == 1); /* LCOV_EXCL_BR_LINE */
  assert(bundle->discard       == 0); /* LCOV_EXCL_BR_LINE */
  assert(bundle->first[0][0]   == 1); /* LCOV_EXCL_BR_LINE */
  assert(bundle->first[0][1]   == 2); /* LCOV_EXCL_BR_LINE */
  assert(bundle->first[0][2]   == 3); /* LCOV_EXCL_BR_LINE */
  assert(bundle->second[0][0]  == 4); /* LCOV_EXCL_BR_LINE */
  assert(bundle->second[0][1]  == 5); /* LCOV_EXCL_BR_LINE */
  assert(bundle->second[0][2]  == 6); /* LCOV_EXCL_BR_LINE */

  bundle = data->bundle[1];
  assert(bundle->count         ==  2); /* LCOV_EXCL_BR_LINE */
  assert(bundle->first_length  ==  4); /* LCOV_EXCL_BR_LINE */
  assert(bundle->second_length ==  2); /* LCOV_EXCL_BR_LINE */
  assert(bundle->maximum_step  ==  1); /* LCOV_EXCL_BR_LINE */
  assert(bundle->discard       ==  0); /* LCOV_EXCL_BR_LINE */
  assert(bundle->first[0][0]   ==  1); /* LCOV_EXCL_BR_LINE */
  assert(bundle->first[0][1]   ==  2); /* LCOV_EXCL_BR_LINE */
  assert(bundle->first[0][2]   ==  3); /* LCOV_EXCL_BR_LINE */
  assert(bundle->first[0][3]   ==  4); /* LCOV_EXCL_BR_LINE */
  assert(bundle->second[0][0]  ==  5); /* LCOV_EXCL_BR_LINE */
  assert(bundle->second[0][1]  ==  6); /* LCOV_EXCL_BR_LINE */
  assert(bundle->first[1][0]   ==  7); /* LCOV_EXCL_BR_LINE */
  assert(bundle->first[1][1]   ==  8); /* LCOV_EXCL_BR_LINE */
  assert(bundle->first[1][2]   ==  9); /* LCOV_EXCL_BR_LINE */
  assert(bundle->first[1][3]   == 10); /* LCOV_EXCL_BR_LINE */
  assert(bundle->second[1][0]  == 11); /* LCOV_EXCL_BR_LINE */
  assert(bundle->second[1][1]  == 12); /* LCOV_EXCL_BR_LINE */

  bundle_paths_free(&paths);
  worker_data_free(&data);
}
