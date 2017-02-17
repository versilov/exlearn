#ifndef INCLUDED_WORKER_RESOURCE_H
#define INCLUDED_WORKER_RESOURCE_H

#include "../utils.h"

#include "../network_state.h"
#include "./batch_data.h"
#include "./worker_data.h"

typedef struct WorkerResource {
  BatchData    *batch_data;
  NetworkState *network_state;
  WorkerData   *worker_data;
} WorkerResource;

void
worker_resource_free(WorkerResource **worker_resource_address);

void
worker_resource_initialize(WorkerResource *worker_resource);

void
worker_resource_inspect(WorkerResource *worker_resource);

void
worker_resource_inspect_internal(
  WorkerResource *worker_resource,
  int32_t         indentation
);

WorkerResource *
worker_resource_new();

#endif
