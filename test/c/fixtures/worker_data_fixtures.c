#ifndef INCLUDE_WORKER_DATA_FIXTURES_C
#define INCLUDE_WORKER_DATA_FIXTURES_C

static WorkerData *
worker_data_basic() {
  WorkerData *worker_data = worker_data_new(2);

  worker_data->bundle[0] = worker_data_bundle_basic();
  worker_data->bundle[1] = worker_data_bundle_basic_2();

  return worker_data;
}

#endif
