#include "../../../native/lib/worker/worker_data_bundle.c"

//-----------------------------------------------------------------------------
// Test Helpers
//-----------------------------------------------------------------------------

void create_temp_file(char *path) {
  FILE  *file       = fopen(path, "wb");
  int    int_buffer[7] = {
    1, // one
    1, // version
    1, // count
    3, // first_length
    3, // second_length
    1, // maximum_step
    0  // discard
  };
  float  float_buffer[6] = {
    1, 1, 2, // sample one: first
    1, 1, 4  // sample one: second
  };

  fwrite(int_buffer + 0, sizeof(int), 1, file);
  fwrite(int_buffer + 1, sizeof(int), 1, file);
  fwrite(int_buffer + 2, sizeof(int), 1, file);
  fwrite(int_buffer + 3, sizeof(int), 1, file);
  fwrite(int_buffer + 4, sizeof(int), 1, file);
  fwrite(int_buffer + 5, sizeof(int), 1, file);
  fwrite(int_buffer + 6, sizeof(int), 1, file);

  fwrite(float_buffer + 0, sizeof(float), 1, file);
  fwrite(float_buffer + 1, sizeof(float), 1, file);
  fwrite(float_buffer + 2, sizeof(float), 1, file);
  fwrite(float_buffer + 3, sizeof(float), 1, file);
  fwrite(float_buffer + 4, sizeof(float), 1, file);
  fwrite(float_buffer + 5, sizeof(float), 1, file);

  fclose(file);
}

char * write_worker_data_bundle_in_file() {
  char *path = temp_file_path();

  create_temp_file(path);

  return path;
}

//-----------------------------------------------------------------------------
// Tests
//-----------------------------------------------------------------------------

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

  char *file = write_worker_data_bundle_in_file();
  read_worker_data_bundle(file, data);

  assert(data->count         == 1);
  assert(data->first_length  == 3);
  assert(data->second_length == 3);
  assert(data->maximum_step  == 1);
  assert(data->discard       == 0);

  assert(data->first[0][0] == 1);
  assert(data->first[0][1] == 1);
  assert(data->first[0][2] == 2);

  assert(data->second[0][0] == 1);
  assert(data->second[0][1] == 1);
  assert(data->second[0][2] == 4);

  free(file);
  free_worker_data_bundle(data);
}
