#ifndef INCLUDED_BUNDLE_PATHS_H
#define INCLUDED_BUNDLE_PATHS_H

#include <stdint.h>
#include <stdlib.h>

typedef struct BundlePaths {
  int32_t   count;
  char    **path;
} BundlePaths;

void
bundle_paths_free(BundlePaths **paths_address);

BundlePaths *
bundle_paths_new(int32_t count);

#endif
