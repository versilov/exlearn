#include "../../include/worker/worker_resource.h"

void
worker_resource_free(WorkerResource **worker_resource_address) {
  WorkerResource *worker_resource = *worker_resource_address;

  free(worker_resource);

  *worker_resource_address = NULL;
}

void
worker_resource_inspect(WorkerResource *worker_resource) {
  printf("<#WorkerResource\n");

  printf("  batch_data:    ");
  if (worker_resource->batch_data == NULL)
    printf("NULL");
  else
    batch_data_inspect_internal(worker_resource->batch_data, 17);
  printf("\n");

  printf("  network_state: ");
  if (worker_resource->network_state == NULL)
    printf("NULL");
  else
    network_state_inspect_internal(worker_resource->network_state, 17);
  printf("\n");

  printf("  worker_data:   ");
  if (worker_resource->worker_data == NULL)
    printf("NULL");
  else
    worker_data_inspect_internal(worker_resource->worker_data, 17);
  printf(">\n");
}

void
worker_resource_inspect_internal(
  WorkerResource *worker_resource,
  int32_t         indentation
) {
  printf("<#WorkerResource\n");

  print_spaces(indentation);
  printf("  batch_data:    ");
  if (worker_resource->batch_data == NULL)
    printf("NULL");
  else
    batch_data_inspect_internal(worker_resource->batch_data, indentation + 17);
  printf("\n");

  print_spaces(indentation);
  printf("  network_state: ");
  if (worker_resource->network_state == NULL)
    printf("NULL");
  else
    network_state_inspect_internal(worker_resource->network_state, indentation + 17);
  printf("\n");

  print_spaces(indentation);
  printf("  worker_data:   ");
  if (worker_resource->worker_data == NULL)
    printf("NULL");
  else
    worker_data_inspect_internal(worker_resource->worker_data, indentation + 17);
  printf(">");
}

WorkerResource *
worker_resource_new() {
  WorkerResource *worker_resource = malloc(sizeof(WorkerResource));

  worker_resource->batch_data    = NULL;
  worker_resource->network_state = NULL;
  worker_resource->worker_data   = NULL;

  return worker_resource;
}
