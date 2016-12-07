#ifndef INCLUDE_WORKER_RESOURCE_FIXTURES_C
#define INCLUDE_WORKER_RESOURCE_FIXTURES_C

#include "./batch_data_fixtures.c"
#include "./network_state_fixtures.c"
#include "./worker_data_fixtures.c"

static WorkerResource *
worker_resource_simple() {
  WorkerResource *worker_resource = worker_resource_new();

  worker_resource->batch_data    = batch_data_simple();
  worker_resource->network_state = network_state_simple();
  worker_resource->worker_data   = worker_data_basic();

  return worker_resource;
}

#endif
