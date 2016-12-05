#ifndef INCLUDE_WORKER_DATA_BUNDLE_FIXTURES_C
#define INCLUDE_WORKER_DATA_BUNDLE_FIXTURES_C

static WorkerDataBundle *
worker_data_bundle_basic() {
  WorkerDataBundle *worker_data_bundle = worker_data_bundle_new();

  worker_data_bundle->count         = 2;
  worker_data_bundle->first_length  = 4;
  worker_data_bundle->second_length = 5;
  worker_data_bundle->maximum_step  = 1;
  worker_data_bundle->discard       = 0;

  worker_data_bundle->first = malloc(sizeof(float *) * 2);

  worker_data_bundle->first[0] = malloc(sizeof(float) * 4);
  worker_data_bundle->first[1] = malloc(sizeof(float) * 4);

  worker_data_bundle->first[0][0] = 1;
  worker_data_bundle->first[0][1] = 2;
  worker_data_bundle->first[0][2] = 0;
  worker_data_bundle->first[0][3] = 1;
  worker_data_bundle->first[1][0] = 1;
  worker_data_bundle->first[1][1] = 2;
  worker_data_bundle->first[1][2] = 1;
  worker_data_bundle->first[1][3] = 2;

  worker_data_bundle->second = malloc(sizeof(float *) * 2);

  worker_data_bundle->second[0] = malloc(sizeof(float) * 5);
  worker_data_bundle->second[1] = malloc(sizeof(float) * 5);

  worker_data_bundle->second[0][0] = 1;
  worker_data_bundle->second[0][1] = 3;
  worker_data_bundle->second[0][2] = 0;
  worker_data_bundle->second[0][3] = 1;
  worker_data_bundle->second[0][4] = 2;
  worker_data_bundle->second[1][0] = 1;
  worker_data_bundle->second[1][1] = 3;
  worker_data_bundle->second[1][2] = 1;
  worker_data_bundle->second[1][3] = 2;
  worker_data_bundle->second[1][4] = 3;

  return worker_data_bundle;
}
#endif
