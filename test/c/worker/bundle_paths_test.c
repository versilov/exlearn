#include "../../../native/include/worker/bundle_paths.h"

#include "../fixtures/bundle_paths_fixtures.c"

static void test_bundle_paths_free() {
  BundlePaths *paths = bundle_paths_new(4);

  bundle_paths_free(&paths);

  assert(paths == NULL); /* LCOV_EXCL_BR_LINE */
}

static void test_bundle_paths_inspect_callback() {
  BundlePaths *bundle_paths = bundle_paths_basic();

  bundle_paths_inspect(bundle_paths);

  bundle_paths_free(&bundle_paths);
}

static void test_bundle_paths_inspect() {
  char *result   = capture_stdout(test_bundle_paths_inspect_callback);
  char *expected =
    "<#BundlePaths\n"
    "  count: 2\n"
    "  paths:\n"
    "    0: /stairway/to/heaven\n"
    "    1: /highway/to/hell>\n";

  for (int32_t index = 0; index < 86; index += 1) {
    assert(result[index] == expected[index]);
  }
}

static void test_bundle_paths_inspect_internal_callback() {
  BundlePaths *bundle_paths = bundle_paths_basic();

  bundle_paths_inspect_internal(bundle_paths, 3);

  bundle_paths_free(&bundle_paths);
}

static void test_bundle_paths_inspect_internal() {
  char *result   = capture_stdout(test_bundle_paths_inspect_internal_callback);
  char *expected =
    "<#BundlePaths\n"
    "     count: 2\n"
    "     paths:\n"
    "       0: /stairway/to/heaven\n"
    "       1: /highway/to/hell>";

  for (int32_t index = 0; index < 98; index += 1) {
    assert(result[index] == expected[index]);
  }
}

static void test_bundle_paths_new() {
  BundlePaths *paths = bundle_paths_new(4);

  assert(paths->count == 4); /* LCOV_EXCL_BR_LINE */

  for (int32_t index = 0; index < 4; index += 1) {
    assert(paths->paths[index] == NULL); /* LCOV_EXCL_BR_LINE */
  }

  bundle_paths_free(&paths);
}
