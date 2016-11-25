#include "../../include/worker/worker_data.h"

void
worker_data_free(WorkerData **data_address) {
  WorkerData *data = *data_address;

  if(data != NULL) {
    for (int32_t index = 0; index < data->count; index += 1) {
      if (data->bundle[index] != NULL)
        worker_data_bundle_free(&data->bundle[index]);
    }

    free(data->bundle);
    free(data);

    *data_address = NULL;
  }
}

WorkerData *
worker_data_new(int32_t count) {
  WorkerData *data = malloc(sizeof(WorkerData));

  worker_data_initialize(data, count);

  return data;
}

void
worker_data_initialize(WorkerData *worker_data, int32_t count) {
  worker_data->count  = count;
  worker_data->bundle = malloc(sizeof(WorkerDataBundle) * count);

  for (int32_t index = 0; index < worker_data->count; index += 1) {
    worker_data->bundle[index] = NULL;
  }
}

void
worker_data_read(BundlePaths *paths, WorkerData *data) {
  for (int32_t index = 0; index < paths->count; index += 1) {
    WorkerDataBundle *bundle = worker_data_bundle_new();

    read_worker_data_bundle(paths->path[index], bundle);

    data->bundle[index] = bundle;
  }
}
