#include "../../include/worker/bundle_paths.h"

void
bundle_paths_free(BundlePaths **bundle_paths_address) {
  BundlePaths *bundle_paths = *bundle_paths_address;

  for (int32_t index = 0; index < bundle_paths->count; index += 1) {
    if (bundle_paths->paths[index] != NULL) free(bundle_paths->paths[index]);
  }

  free(bundle_paths->paths);
  free(bundle_paths      );

  *bundle_paths_address = NULL;
}

BundlePaths *
bundle_paths_new(int32_t count) {
  BundlePaths *bundle_paths = malloc(sizeof(BundlePaths));

  bundle_paths->count = count;
  bundle_paths->paths = malloc(sizeof(char *) * count);

  for (int32_t index = 0; index < count; index += 1) {
    bundle_paths->paths[index] = NULL;
  }

  return bundle_paths;
}
