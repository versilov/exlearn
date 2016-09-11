#include "../../../native/lib/worker/worker_data.c"

//-----------------------------------------------------------------------------
// Test Helpers
//-----------------------------------------------------------------------------

void create_temp_file(char *path) {
  FILE  *file       = fopen(path, "wb");
  float  buffer[11] = {1, 1, 3, 3, 1, 1, 1, 2, 1, 1, 4};

  fwrite(buffer, sizeof(float), 11, file);

  fclose(file);
}

char * write_worker_data_in_file() {
  char *path = temp_file_path();

  create_temp_file(path);

  return path;
}

//-----------------------------------------------------------------------------
// Tests
//-----------------------------------------------------------------------------

static void test_free_worker_data() {
  WorkerData *data = new_worker_data();

  free_worker_data(data);
}

static void test_new_worker_data() {
  WorkerData *data = new_worker_data();

  assert(data->count         == 0   );
  assert(data->first_length  == 0   );
  assert(data->second_length == 0   );
  assert(data->step          == 0   );
  assert(data->first         == NULL);
  assert(data->second        == NULL);

  free_worker_data(data);
}

static void test_read_worker_data() {
  WorkerData *data = new_worker_data();

  char *file = write_worker_data_in_file();
  read_worker_data(file, data);

  assert(data->count         == 1);
  assert(data->first_length  == 3);
  assert(data->second_length == 3);
  assert(data->step          == 1);

  assert(data->first[0][0] == 1);
  assert(data->first[0][1] == 1);
  assert(data->first[0][2] == 2);

  assert(data->second[0][0] == 1);
  assert(data->second[0][1] == 1);
  assert(data->second[0][2] == 4);

  free(file);
  free_worker_data(data);
}
