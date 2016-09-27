#ifndef INCLUDED_WORKER_DATA_C
#define INCLUDED_WORKER_DATA_C

typedef struct WorkerData {
  int                count;
  char             **paths;
  WorkerDataBundle **bundles;
} WorkerData;

static void
worker_data_free(WorkerData **data_address) {
  WorkerData *data = *data_address;

  if(data != NULL) {
    for (int index = 0; index < data->count; index += 1) {
      if (data->paths[index]   != NULL) free(data->paths[index]  );
      if (data->bundles[index] != NULL) free(data->bundles[index]);
    }

    free(data->paths  );
    free(data->bundles);

    free(data);

    *data_address = NULL;
  }
}

static WorkerData *
worker_data_new(int count) {
  WorkerData *data = malloc(sizeof(WorkerData));

  data->count   = count;

  data->paths   = malloc(sizeof(char *)     * count);
  data->bundles = malloc(sizeof(WorkerData) * count);

  for (int index = 0; index < data->count; index += 1) {
    data->paths[index]   = NULL;
    data->bundles[index] = NULL;
  }

  return data;
}

#endif
