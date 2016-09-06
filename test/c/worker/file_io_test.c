#include <assert.h>

#include "../../../native/lib/worker/file_io.c"

int main() {
  WorkerData data;

  read_worker_data("samples/mnist-digits/data/test_data-0.eld", &data);

  return 0;
}
