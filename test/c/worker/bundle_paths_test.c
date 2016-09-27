#include "../../../native/lib/worker/bundle_paths.c"

static void test_bundle_paths_free() {
  BundlePaths *paths = bundle_paths_new(4);

  bundle_paths_free(&paths);

  assert(paths == NULL);
}

static void test_bundle_paths_new() {
  BundlePaths *paths = bundle_paths_new(4);

  assert(paths->count == 4);

  for (int index = 0; index < 4; index += 1) {
    assert(paths->path[index] == NULL);
  }

  bundle_paths_free(&paths);
}
