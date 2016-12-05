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

void
worker_data_inspect(WorkerData *worker_data) {
  printf("<#WorkerData\n");
  printf("  count: %d\n", worker_data->count);

  printf("  bundle:\n");
  for (int32_t index = 0; index < worker_data->count; index += 1) {
    printf("    %d: ", index);

    worker_data_bundle_inspect_internal(worker_data->bundle[index], 7);

    if (index < worker_data->count - 1) printf("\n");
  }

  printf(">\n");
}

void
worker_data_inspect_internal(WorkerData *worker_data, int32_t indentation) {
  printf("<#WorkerData\n");
  print_spaces(indentation);
  printf("  count: %d\n", worker_data->count);

  print_spaces(indentation);
  printf("  bundle:\n");
  for (int32_t index = 0; index < worker_data->count; index += 1) {
    print_spaces(indentation);
    printf("    %d: ", index);

    worker_data_bundle_inspect_internal(worker_data->bundle[index], indentation + 7);

    if (index < worker_data->count - 1) printf("\n");
  }

  printf(">");
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

    read_worker_data_bundle(paths->paths[index], bundle);

    data->bundle[index] = bundle;
  }
}
