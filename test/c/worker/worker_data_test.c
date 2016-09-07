#include <assert.h>

#include "../../../native/lib/worker/worker_data.c"

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

  read_worker_data("samples/mnist-digits/data/test_data-0.eld", data);

  free_worker_data(data);
}

//-----------------------------------------------------------------------------
// Test Helpers
//-----------------------------------------------------------------------------

void write_worker_data_file(char *path) {
}

//-----------------------------------------------------------------------------
// Run Tests
//-----------------------------------------------------------------------------

int main() {
  test_free_worker_data();
  test_new_worker_data();
  test_read_worker_data();

  return 0;
}
