#ifndef INCLUDED_WORKER_DATA_BUNDLE_H
#define INCLUDED_WORKER_DATA_BUNDLE_H

#include <stdio.h>
#include <stdlib.h>

typedef struct WorkerDataBundle {
  int     count;
  int     first_length, second_length;
  int     maximum_step;
  int     discard;
  float **first;
  float **second;
} WorkerDataBundle;

void
free_worker_data_bundle(WorkerDataBundle *data);

WorkerDataBundle *
new_worker_data_bundle();

void
read_worker_data_bundle(const char *path, WorkerDataBundle *data);

#endif
