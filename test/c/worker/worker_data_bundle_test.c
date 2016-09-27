#include "../../../native/lib/worker/worker_data_bundle.c"

#include "../fixtures/file_fixtures.c"

static void test_free_worker_data_bundle() {
  WorkerDataBundle *data = new_worker_data_bundle();

  free_worker_data_bundle(data);
}

static void test_new_worker_data_bundle() {
  WorkerDataBundle *data = new_worker_data_bundle();

  assert(data->count         == 0   );
  assert(data->first_length  == 0   );
  assert(data->second_length == 0   );
  assert(data->maximum_step  == 0   );
  assert(data->discard       == 0   );
  assert(data->first         == NULL);
  assert(data->second        == NULL);

  free_worker_data_bundle(data);
}

static void test_read_worker_data_bundle() {
  WorkerDataBundle *data = new_worker_data_bundle();

  char *file = create_first_data_bundle_file();
  read_worker_data_bundle(file, data);

  assert(data->count         == 1);
  assert(data->first_length  == 3);
  assert(data->second_length == 3);
  assert(data->maximum_step  == 1);
  assert(data->discard       == 0);

  assert(data->first[0][0] == 1);
  assert(data->first[0][1] == 2);
  assert(data->first[0][2] == 3);

  assert(data->second[0][0] == 4);
  assert(data->second[0][1] == 5);
  assert(data->second[0][2] == 6);

  free(file);
  free_worker_data_bundle(data);
}
