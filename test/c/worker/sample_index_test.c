#include "../../../native/include/worker/sample_index.h"

static void test_sample_index_free() {
  SampleIndex *sample_index = sample_index_new(1, 2);

  sample_index_free(&sample_index);

  assert(sample_index == NULL); /* LCOV_EXCL_BR_LINE */
}

static void test_sample_index_inspect_callback() {
  SampleIndex *sample_index = sample_index_new(1, 2);

  sample_index_inspect(sample_index);

  sample_index_free(&sample_index);
}

static void test_sample_index_inspect() {
  char *result   = capture_stdout(test_sample_index_inspect_callback);
  char *expected = "<#SampleIndex bundle: 1 index: 2>\n";

  for(int32_t index = 0; index < 34; index += 1) {
    assert(result[index] == expected[index]); /* LCOV_EXCL_BR_LINE */
  }
}

static void test_sample_index_inspect_internal_callback() {
  SampleIndex *sample_index = sample_index_new(1, 2);

  sample_index_inspect_internal(sample_index, 3);

  sample_index_free(&sample_index);
}

static void test_sample_index_inspect_internal() {
  char *result   = capture_stdout(test_sample_index_inspect_internal_callback);
  char *expected = "<#SampleIndex bundle: 1 index: 2>";

  for(int32_t index = 0; index < 33; index += 1) {
    assert(result[index] == expected[index]); /* LCOV_EXCL_BR_LINE */
  }
}

static void test_sample_index_new() {
  SampleIndex *sample_index = sample_index_new(1, 2);

  assert(sample_index->bundle = 1); /* LCOV_EXCL_BR_LINE */
  assert(sample_index->index  = 2); /* LCOV_EXCL_BR_LINE */

  sample_index_free(&sample_index);
}
