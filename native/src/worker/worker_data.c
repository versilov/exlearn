#include "../../include/worker/worker_data.h"

void
worker_data_free(WorkerData **data_address) {
  WorkerData *data = *data_address;

  if(data != NULL) {
    for (int index = 0; index < data->count; index += 1) {
      if (data->bundle[index] != NULL) free_worker_data_bundle(data->bundle[index]);
    }

    free(data->bundle);
    free(data);

    *data_address = NULL;
  }
}

WorkerData *
worker_data_new(int count) {
  WorkerData *data = malloc(sizeof(WorkerData));

  data->count  = count;
  data->bundle = malloc(sizeof(WorkerData) * count);

  for (int index = 0; index < data->count; index += 1) {
    data->bundle[index] = NULL;
  }

  return data;
}

void
worker_data_read(BundlePaths *paths, WorkerData *data) {
  for (int index = 0; index < paths->count; index += 1) {
    WorkerDataBundle *bundle = new_worker_data_bundle();

    read_worker_data_bundle(paths->path[index], bundle);

    data->bundle[index] = bundle;
  }
}