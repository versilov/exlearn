#include "../../../native/include/worker/worker_resource.h"

static void test_worker_resource_free() {
  WorkerResource *worker_resource = worker_resource_new();

  worker_resource_free(&worker_resource);

  assert(worker_resource == NULL); /* LCOV_EXCL_BR_LINE */
}

static void test_worker_resource_new() {
  WorkerResource *worker_resource = worker_resource_new();

  assert(worker_resource->batch_data    == NULL); /* LCOV_EXCL_BR_LINE */
  assert(worker_resource->network_state == NULL); /* LCOV_EXCL_BR_LINE */
  assert(worker_resource->worker_data   == NULL); /* LCOV_EXCL_BR_LINE */

  worker_resource_free(&worker_resource);
}
