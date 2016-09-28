#include "../../../native/lib/worker/sample_index.c"

static void test_sample_index_free() {
  SampleIndex *sample_index = sample_index_new(1, 2);

  sample_index_free(&sample_index);

  assert(sample_index == NULL); /* LCOV_EXCL_BR_LINE */
}

static void test_sample_index_new() {
  SampleIndex *sample_index = sample_index_new(1, 2);

  assert(sample_index->bundle = 1); /* LCOV_EXCL_BR_LINE */
  assert(sample_index->index  = 2); /* LCOV_EXCL_BR_LINE */

  sample_index_free(&sample_index);
}
