#ifndef INCLUDED_WORKER_DATA_BUNDLE_H
#define INCLUDED_WORKER_DATA_BUNDLE_H

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct WorkerDataBundle {
  int32_t   count;
  int32_t   first_length, second_length;
  int32_t   maximum_step;
  int32_t   discard;
  float   **first;
  float   **second;
} WorkerDataBundle;

void
worker_data_bundle_free(WorkerDataBundle **data);

WorkerDataBundle *
worker_data_bundle_new();

void
read_worker_data_bundle(const char *path, WorkerDataBundle *data);

#endif
