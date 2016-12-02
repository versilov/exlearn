#ifndef INCLUDED_BUNDLE_PATHS_H
#define INCLUDED_BUNDLE_PATHS_H

#include <stdint.h>
#include <stdlib.h>

typedef struct BundlePaths {
  int32_t   count;
  char    **paths;
} BundlePaths;

void
bundle_paths_free(BundlePaths **bundle_paths_address);

void
bundle_paths_inspect(BundlePaths *bundle_paths);

void
bundle_paths_inspect_internal(BundlePaths *bundle_paths, int32_t indentation);

BundlePaths *
bundle_paths_new(int32_t count);

#endif
