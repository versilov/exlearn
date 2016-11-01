#include "../../../native/include/worker/worker_data_bundle.h"

#include "../fixtures/file_fixtures.c"

static void test_free_worker_data_bundle() {
  WorkerDataBundle *data = new_worker_data_bundle();

  free_worker_data_bundle(data);
}

static void test_new_worker_data_bundle() {
  WorkerDataBundle *data = new_worker_data_bundle();

  assert(data->count         == 0   ); /* LCOV_EXCL_BR_LINE */
  assert(data->first_length  == 0   ); /* LCOV_EXCL_BR_LINE */
  assert(data->second_length == 0   ); /* LCOV_EXCL_BR_LINE */
  assert(data->maximum_step  == 0   ); /* LCOV_EXCL_BR_LINE */
  assert(data->discard       == 0   ); /* LCOV_EXCL_BR_LINE */
  assert(data->first         == NULL); /* LCOV_EXCL_BR_LINE */
  assert(data->second        == NULL); /* LCOV_EXCL_BR_LINE */

  free_worker_data_bundle(data);
}

static void test_read_worker_data_bundle() {
  WorkerDataBundle *data = new_worker_data_bundle();

  char *file = create_first_data_bundle_file();
  read_worker_data_bundle(file, data);

  assert(data->count         == 1); /* LCOV_EXCL_BR_LINE */
  assert(data->first_length  == 3); /* LCOV_EXCL_BR_LINE */
  assert(data->second_length == 3); /* LCOV_EXCL_BR_LINE */
  assert(data->maximum_step  == 1); /* LCOV_EXCL_BR_LINE */
  assert(data->discard       == 0); /* LCOV_EXCL_BR_LINE */

  assert(data->first[0][0] == 1); /* LCOV_EXCL_BR_LINE */
  assert(data->first[0][1] == 2); /* LCOV_EXCL_BR_LINE */
  assert(data->first[0][2] == 3); /* LCOV_EXCL_BR_LINE */

  assert(data->second[0][0] == 4); /* LCOV_EXCL_BR_LINE */
  assert(data->second[0][1] == 5); /* LCOV_EXCL_BR_LINE */
  assert(data->second[0][2] == 6); /* LCOV_EXCL_BR_LINE */

  free(file);
  free_worker_data_bundle(data);
}
