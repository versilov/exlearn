#ifndef INCLUDED_WORKER_DATA_H
#define INCLUDED_WORKER_DATA_H

#include <stdlib.h>

// TODO: replace thses with appropriate header files.
// #include "bundle_paths.c"
// #include "worker_data_bundle.c"

typedef struct WorkerData {
  int                count;
  WorkerDataBundle **bundle;
} WorkerData;

void
worker_data_free(WorkerData **data_address);

WorkerData *
worker_data_new(int count);

void
worker_data_read(BundlePaths *paths, WorkerData *data);

#endif
