#include "../../../native/include/worker/worker_resource.h"

#include "../fixtures/worker_resource_fixtures.c"

static void test_worker_resource_free() {
  WorkerResource *worker_resource = worker_resource_new();

  worker_resource_free(&worker_resource);

  assert(worker_resource == NULL); /* LCOV_EXCL_BR_LINE */
}

//--------------------------------------------------------------------------------
// Inspect
//--------------------------------------------------------------------------------

static void test_worker_resource_inspect_empty_callback() {
  WorkerResource *worker_resource = worker_resource_new();

  worker_resource_inspect(worker_resource);

  worker_resource_free(&worker_resource);
}

static void test_worker_resource_inspect_empty() {
  char *result   = capture_stdout(test_worker_resource_inspect_empty_callback);
  char *expected =
    "<#WorkerResource\n"
    "  batch_data:    NULL\n"
    "  network_state: NULL\n"
    "  worker_data:   NULL>\n";

  int32_t result_length   = strlen(result  );
  int32_t expected_length = strlen(expected);

  assert(result_length == expected_length); /* LCOV_EXCL_BR_LINE */

  for(int32_t index = 0; index <= result_length; index += 1) {
    assert(result[index] == expected[index]); /* LCOV_EXCL_BR_LINE */
  }
}

static void test_worker_resource_inspect_with_data_callback() {
  WorkerResource *worker_resource = worker_resource_simple();

  worker_resource_inspect(worker_resource);

  worker_resource_free(&worker_resource);
}

static void test_worker_resource_inspect_with_data() {
  char *result   = capture_stdout(test_worker_resource_inspect_with_data_callback);
  char *expected =
    "<#WorkerResource\n"
    "  batch_data:    <#BatchData\n"
    "                   batch_length: 1\n"
    "                   data_length:  1\n"
    "                   sample_index:\n"
    "                     0: <#SampleIndex bundle: 1 index: 1>>\n"
    "  network_state: <#NetworkState\n"
    "                   layers:  2\n"
    "                   rows:    0 0\n"
    "                   columns: 0 0\n"
    "                   biases:\n"
    "                     0: NULL\n"
    "                     1: <#Matrix\n"
    "                          rows:    1.000000\n"
    "                          columns: 2.000000\n"
    "                          values:  1.000000 2.000000>\n"
    "                   weights:\n"
    "                     0: NULL\n"
    "                     1: <#Matrix\n"
    "                          rows:    2.000000\n"
    "                          columns: 2.000000\n"
    "                          values:  1.000000 2.000000 3.000000 4.000000>\n"
    "                   dropout: 0.000000 0.000000\n"
    "                   function:\n"
    "                     0: NULL\n"
    "                     1: NULL\n"
    "                   derivative:\n"
    "                     0: NULL\n"
    "                     1: NULL\n"
    "                   presentation: NULL\n"
    "                   objective: F\n"
    "                   error:     F>\n"
    "  worker_data:   <#WorkerData\n"
    "                   count: 2\n"
    "                   bundle:\n"
    "                     0: <#WorkerDataBundle\n"
    "                          count:         2\n"
    "                          first_length:  4\n"
    "                          second_length: 5\n"
    "                          maximum_step:  1\n"
    "                          discard:       0\n"
    "                          first:\n"
    "                            0: 1.000000 2.000000 0.000000 1.000000\n"
    "                            1: 1.000000 2.000000 1.000000 2.000000\n"
    "                          second:\n"
    "                            0: 1.000000 3.000000 0.000000 1.000000 2.000000\n"
    "                            1: 1.000000 3.000000 1.000000 2.000000 3.000000>\n"
    "                     1: <#WorkerDataBundle\n"
    "                          count:         2\n"
    "                          first_length:  4\n"
    "                          second_length: 5\n"
    "                          maximum_step:  1\n"
    "                          discard:       0\n"
    "                          first:\n"
    "                            0: 1.000000 2.000000 1.000000 2.000000\n"
    "                            1: 1.000000 2.000000 2.000000 3.000000\n"
    "                          second:\n"
    "                            0: 1.000000 3.000000 1.000000 2.000000 3.000000\n"
    "                            1: 1.000000 3.000000 2.000000 3.000000 4.000000>>>\n";

  int32_t result_length   = strlen(result  );
  int32_t expected_length = strlen(expected);

  assert(result_length == expected_length); /* LCOV_EXCL_BR_LINE */

  for(int32_t index = 0; index <= result_length; index += 1) {
    assert(result[index] == expected[index]); /* LCOV_EXCL_BR_LINE */
  }
}

static void test_worker_resource_inspect() {
  test_worker_resource_inspect_empty();
  test_worker_resource_inspect_with_data();
}

static void test_worker_resource_inspect_internal_empty_callback() {
  WorkerResource *worker_resource = worker_resource_new();

  worker_resource_inspect_internal(worker_resource, 3);

  worker_resource_free(&worker_resource);
}

static void test_worker_resource_inspect_internal_empty() {
  char *result   = capture_stdout(test_worker_resource_inspect_internal_empty_callback);
  char *expected =
    "<#WorkerResource\n"
    "     batch_data:    NULL\n"
    "     network_state: NULL\n"
    "     worker_data:   NULL>";

  int32_t result_length   = strlen(result  );
  int32_t expected_length = strlen(expected);

  assert(result_length == expected_length); /* LCOV_EXCL_BR_LINE */

  for(int32_t index = 0; index <= result_length; index += 1) {
    assert(result[index] == expected[index]); /* LCOV_EXCL_BR_LINE */
  }
}

static void test_worker_resource_inspect_internal_with_data_callback() {
  WorkerResource *worker_resource = worker_resource_simple();

  worker_resource_inspect_internal(worker_resource, 3);

  worker_resource_free(&worker_resource);
}

static void test_worker_resource_inspect_internal_with_data() {
  char *result   = capture_stdout(test_worker_resource_inspect_internal_with_data_callback);
  char *expected =
    "<#WorkerResource\n"
    "     batch_data:    <#BatchData\n"
    "                      batch_length: 1\n"
    "                      data_length:  1\n"
    "                      sample_index:\n"
    "                        0: <#SampleIndex bundle: 1 index: 1>>\n"
    "     network_state: <#NetworkState\n"
    "                      layers:  2\n"
    "                      rows:    0 0\n"
    "                      columns: 0 0\n"
    "                      biases:\n"
    "                        0: NULL\n"
    "                        1: <#Matrix\n"
    "                             rows:    1.000000\n"
    "                             columns: 2.000000\n"
    "                             values:  1.000000 2.000000>\n"
    "                      weights:\n"
    "                        0: NULL\n"
    "                        1: <#Matrix\n"
    "                             rows:    2.000000\n"
    "                             columns: 2.000000\n"
    "                             values:  1.000000 2.000000 3.000000 4.000000>\n"
    "                      dropout: 0.000000 0.000000\n"
    "                      function:\n"
    "                        0: NULL\n"
    "                        1: NULL\n"
    "                      derivative:\n"
    "                        0: NULL\n"
    "                        1: NULL\n"
    "                      presentation: NULL\n"
    "                      objective: F\n"
    "                      error:     F>\n"
    "     worker_data:   <#WorkerData\n"
    "                      count: 2\n"
    "                      bundle:\n"
    "                        0: <#WorkerDataBundle\n"
    "                             count:         2\n"
    "                             first_length:  4\n"
    "                             second_length: 5\n"
    "                             maximum_step:  1\n"
    "                             discard:       0\n"
    "                             first:\n"
    "                               0: 1.000000 2.000000 0.000000 1.000000\n"
    "                               1: 1.000000 2.000000 1.000000 2.000000\n"
    "                             second:\n"
    "                               0: 1.000000 3.000000 0.000000 1.000000 2.000000\n"
    "                               1: 1.000000 3.000000 1.000000 2.000000 3.000000>\n"
    "                        1: <#WorkerDataBundle\n"
    "                             count:         2\n"
    "                             first_length:  4\n"
    "                             second_length: 5\n"
    "                             maximum_step:  1\n"
    "                             discard:       0\n"
    "                             first:\n"
    "                               0: 1.000000 2.000000 1.000000 2.000000\n"
    "                               1: 1.000000 2.000000 2.000000 3.000000\n"
    "                             second:\n"
    "                               0: 1.000000 3.000000 1.000000 2.000000 3.000000\n"
    "                               1: 1.000000 3.000000 2.000000 3.000000 4.000000>>>";

  int32_t result_length   = strlen(result  );
  int32_t expected_length = strlen(expected);

  assert(result_length == expected_length); /* LCOV_EXCL_BR_LINE */

  for(int32_t index = 0; index <= result_length; index += 1) {
    assert(result[index] == expected[index]); /* LCOV_EXCL_BR_LINE */
  }
}

static void test_worker_resource_inspect_internal() {
  test_worker_resource_inspect_internal_empty();
  test_worker_resource_inspect_internal_with_data();
}

//--------------------------------------------------------------------------------

static void test_worker_resource_new() {
  WorkerResource *worker_resource = worker_resource_new();

  assert(worker_resource->batch_data    == NULL); /* LCOV_EXCL_BR_LINE */
  assert(worker_resource->network_state == NULL); /* LCOV_EXCL_BR_LINE */
  assert(worker_resource->worker_data   == NULL); /* LCOV_EXCL_BR_LINE */

  worker_resource_free(&worker_resource);
}
