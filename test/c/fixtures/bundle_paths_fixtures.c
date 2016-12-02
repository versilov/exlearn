#ifndef INCLUDE_BUNDLE_PATHS_FIXTURES_C
#define INCLUDE_BUNDLE_PATHS_FIXTURES_C

#include "../../../native/include/worker/bundle_paths.h"

static BundlePaths *
bundle_paths_basic() {
  BundlePaths *bundle_paths = bundle_paths_new(2);

  char *first  = "/stairway/to/heaven";
  char *second = "/highway/to/hell";

  bundle_paths->paths[0] = malloc(sizeof(char) * 20);
  bundle_paths->paths[1] = malloc(sizeof(char) * 17);

  for (int index = 0; index < 19; index += 1)
    bundle_paths->paths[0][index] = first[index];
  bundle_paths->paths[0][19] = '\0';

  for (int index = 0; index < 16; index += 1)
    bundle_paths->paths[1][index] = second[index];
  bundle_paths->paths[1][16] = '\0';

  return bundle_paths;
}

#endif
