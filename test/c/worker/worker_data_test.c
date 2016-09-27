#include "../../../native/lib/worker/worker_data.c"

static void test_worker_data_free() {
  WorkerData *data = worker_data_new(4);

  assert(data->count   == 4   );
  assert(data->paths   != NULL);
  assert(data->bundles != NULL);

  for (int index = 0; index < data->count; index += 1) {
    assert(data->paths[index]   == NULL);
    assert(data->bundles[index] == NULL);
  }

  worker_data_free(&data);
}

static void test_worker_data_new() {
  WorkerData *data = worker_data_new(4);

  worker_data_free(&data);

  assert(data == NULL);
}
