#include <stdio.h>

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

void
bundle_paths_inspect(BundlePaths *bundle_paths) {
  printf("<#BundlePaths\n");

  printf("  count: %d\n", bundle_paths->count);

  printf("  paths:\n");
  for(int32_t index = 0; index < bundle_paths->count; index += 1) {
    printf("    %d: %s", index, bundle_paths->paths[index]);

    if (index < bundle_paths->count - 1) printf("\n");
  }

  printf(">\n");
}

void
bundle_paths_inspect_internal(BundlePaths *bundle_paths, int32_t indentation) {
  printf("<#BundlePaths\n");

  print_spaces(indentation);
  printf("  count: %d\n", bundle_paths->count);

  print_spaces(indentation);
  printf("  paths:\n");
  for(int32_t index = 0; index < bundle_paths->count; index += 1) {
    print_spaces(indentation);
    printf("    %d: %s", index, bundle_paths->paths[index]);

    if (index < bundle_paths->count - 1) printf("\n");
  }
  printf(">");
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
