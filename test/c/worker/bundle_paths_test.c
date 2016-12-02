#include "../../../native/include/worker/bundle_paths.h"

static void test_bundle_paths_free() {
  BundlePaths *paths = bundle_paths_new(4);

  bundle_paths_free(&paths);

  assert(paths == NULL); /* LCOV_EXCL_BR_LINE */
}

static void test_bundle_paths_new() {
  BundlePaths *paths = bundle_paths_new(4);

  assert(paths->count == 4); /* LCOV_EXCL_BR_LINE */

  for (int32_t index = 0; index < 4; index += 1) {
    assert(paths->paths[index] == NULL); /* LCOV_EXCL_BR_LINE */
  }

  bundle_paths_free(&paths);
}
