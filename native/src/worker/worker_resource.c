#include "../../include/worker/worker_resource.h"

void
worker_resource_free(WorkerResource **worker_resource_address) {
  WorkerResource *worker_resource = *worker_resource_address;

  free(worker_resource);

  *worker_resource_address = NULL;
}

WorkerResource *
worker_resource_new() {
  WorkerResource *worker_resource = malloc(sizeof(WorkerResource));

  worker_resource->batch_data    = NULL;
  worker_resource->network_state = NULL;
  worker_resource->worker_data   = NULL;

  return worker_resource;
}
