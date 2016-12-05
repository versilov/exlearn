#include "../../../native/include/worker/worker_data.h"

#include "../fixtures/file_fixtures.c"
#include "../fixtures/worker_data_bundle_fixtures.c"
#include "../fixtures/worker_data_fixtures.c"

static void test_worker_data_free() {
  WorkerData *data = worker_data_new(4);

  worker_data_free(&data);

  assert(data == NULL); /* LCOV_EXCL_BR_LINE */
}

static void test_worker_data_inspect_callback() {
  WorkerData *worker_data = worker_data_basic();

  worker_data_inspect(worker_data);

  worker_data_free(&worker_data);
}

static void test_worker_data_inspect() {
  char *result = capture_stdout(test_worker_data_inspect_callback);
  char *expected =
    "<#WorkerData\n"
    "  count: 2\n"
    "  bundle:\n"
    "    0: <#WorkerDataBundle\n"
    "         count:         2\n"
    "         first_length:  4\n"
    "         second_length: 5\n"
    "         maximum_step:  1\n"
    "         discard:       0\n"
    "         first:\n"
    "           0: 1.000000 2.000000 0.000000 1.000000\n"
    "           1: 1.000000 2.000000 1.000000 2.000000\n"
    "         second:\n"
    "           0: 1.000000 3.000000 0.000000 1.000000 2.000000\n"
    "           1: 1.000000 3.000000 1.000000 2.000000 3.000000>\n"
    "    1: <#WorkerDataBundle\n"
    "         count:         2\n"
    "         first_length:  4\n"
    "         second_length: 5\n"
    "         maximum_step:  1\n"
    "         discard:       0\n"
    "         first:\n"
    "           0: 1.000000 2.000000 1.000000 2.000000\n"
    "           1: 1.000000 2.000000 2.000000 3.000000\n"
    "         second:\n"
    "           0: 1.000000 3.000000 1.000000 2.000000 3.000000\n"
    "           1: 1.000000 3.000000 2.000000 3.000000 4.000000>>\n";

  int32_t result_length   = strlen(result  );
  int32_t expected_length = strlen(expected);

  assert(result_length == expected_length); /* LCOV_EXCL_BR_LINE */

  for(int32_t index = 0; index <= result_length; index += 1) {
    assert(result[index] == expected[index]); /* LCOV_EXCL_BR_LINE */
  }
}

static void test_worker_data_inspect_internal_callback() {
  WorkerData *worker_data = worker_data_basic();

  worker_data_inspect_internal(worker_data, 3);

  worker_data_free(&worker_data);
}

static void test_worker_data_inspect_internal() {
  char *result = capture_stdout(test_worker_data_inspect_internal_callback);
  char *expected =
    "<#WorkerData\n"
    "     count: 2\n"
    "     bundle:\n"
    "       0: <#WorkerDataBundle\n"
    "            count:         2\n"
    "            first_length:  4\n"
    "            second_length: 5\n"
    "            maximum_step:  1\n"
    "            discard:       0\n"
    "            first:\n"
    "              0: 1.000000 2.000000 0.000000 1.000000\n"
    "              1: 1.000000 2.000000 1.000000 2.000000\n"
    "            second:\n"
    "              0: 1.000000 3.000000 0.000000 1.000000 2.000000\n"
    "              1: 1.000000 3.000000 1.000000 2.000000 3.000000>\n"
    "       1: <#WorkerDataBundle\n"
    "            count:         2\n"
    "            first_length:  4\n"
    "            second_length: 5\n"
    "            maximum_step:  1\n"
    "            discard:       0\n"
    "            first:\n"
    "              0: 1.000000 2.000000 1.000000 2.000000\n"
    "              1: 1.000000 2.000000 2.000000 3.000000\n"
    "            second:\n"
    "              0: 1.000000 3.000000 1.000000 2.000000 3.000000\n"
    "              1: 1.000000 3.000000 2.000000 3.000000 4.000000>>";

  int32_t result_length   = strlen(result  );
  int32_t expected_length = strlen(expected);

  assert(result_length == expected_length); /* LCOV_EXCL_BR_LINE */

  for(int32_t index = 0; index <= result_length; index += 1) {
    assert(result[index] == expected[index]); /* LCOV_EXCL_BR_LINE */
  }
}

static void test_worker_data_new() {
  WorkerData *data = worker_data_new(4);

  assert(data->count  == 4   ); /* LCOV_EXCL_BR_LINE */
  assert(data->bundle != NULL); /* LCOV_EXCL_BR_LINE */

  for (int32_t index = 0; index < data->count; index += 1) {
    assert(data->bundle[index] == NULL); /* LCOV_EXCL_BR_LINE */
  }

  worker_data_free(&data);
}

static void test_worker_data_initialize() {
  WorkerData *data = malloc(sizeof(WorkerData));
  worker_data_initialize(data, 4);

  assert(data->count  == 4   ); /* LCOV_EXCL_BR_LINE */
  assert(data->bundle != NULL); /* LCOV_EXCL_BR_LINE */

  for (int32_t index = 0; index < data->count; index += 1) {
    assert(data->bundle[index] == NULL); /* LCOV_EXCL_BR_LINE */
  }

  worker_data_free(&data);
}

static void test_worker_data_read() {
  BundlePaths      *paths = bundle_paths_new(2);
  WorkerData       *data  = worker_data_new(2);
  WorkerDataBundle *bundle;

  paths->paths[0] = create_first_data_bundle_file();
  paths->paths[1] = create_second_data_bundle_file();

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
