#include "../../include/worker/batch_data.h"

void
batch_data_free(BatchData **data_address) {
  BatchData *data = *data_address;

  if (data != NULL) {
    for (int32_t index = 0; index < data->data_length; index += 1) {
      sample_index_free(&(data->sample_index[index]));
    }

    free(data->sample_index);
    free(data);
  }

  *data_address = NULL;
}

BatchData *
batch_data_new(WorkerData *data, int32_t batch_length) {
  BatchData *batch_data = malloc(sizeof(BatchData));

  batch_data_initialize(batch_data, data, batch_length);

  return batch_data;
}

void
batch_data_initialize(BatchData *batch_data, WorkerData *data, int32_t batch_length) {
  int32_t           data_length, data_index;
  WorkerDataBundle *bundle;

  data_length = 0;

  for (int32_t index = 0; index < data->count; index += 1) {
    data_length += data->bundle[index]->count;
  }

  batch_data->batch_length = batch_length;
  batch_data->data_length  = data_length;

  batch_data->sample_index = malloc(sizeof(SampleIndex *) * data_length);

  data_index = 0;
  for (int32_t bundle_index = 0; bundle_index < data->count; bundle_index += 1) {
    bundle = data->bundle[bundle_index];

    for (int32_t sample_index = 0; sample_index < bundle->count; sample_index += 1) {
      batch_data->sample_index[data_index] = sample_index_new(bundle_index, sample_index);

      data_index += 1;
    }
  }
}

void
batch_data_inspect(BatchData *batch_data) {
  printf("<#BatchData\n");

  printf("  batch_length: %d\n", batch_data->batch_length);
  printf("  data_length:  %d\n", batch_data->data_length );
  printf("  sample_index:\n");

  for(int index = 0; index < batch_data->data_length; index =+ 1) {
    printf("    %d: ", index);

    sample_index_inspect_internal(batch_data->sample_index[index], 0);

    if (index < batch_data->data_length - 1) printf("\n");
  }
  printf(">\n");
}

void
batch_data_inspect_internal(BatchData *batch_data, int32_t indentation) {
  printf("<#BatchData\n");

  print_spaces(indentation);
  printf("  batch_length: %d\n", batch_data->batch_length);

  print_spaces(indentation);
  printf("  data_length:  %d\n", batch_data->data_length );

  print_spaces(indentation);
  printf("  sample_index:\n");

  for(int index = 0; index < batch_data->data_length; index =+ 1) {
    print_spaces(indentation);
    printf("    %d: ", index);

    sample_index_inspect_internal(batch_data->sample_index[index], 0);

    if (index < batch_data->data_length - 1) printf("\n");
  }
  printf(">");
}

void
shuffle_batch_data_indices(BatchData *data) {
  gsl_rng *rng;

  gsl_rng_env_setup();
  rng = gsl_rng_alloc(gsl_rng_default);
  gsl_rng_set(rng, time(NULL));

  gsl_ran_shuffle(rng, data->sample_index, data->data_length, sizeof(SampleIndex));
}

SampleIndex *
batch_data_get_sample_index(BatchData *batch_data, int32_t batch_number, int32_t offset) {
  int32_t index = batch_data->batch_length * batch_number + offset;

  return batch_data->sample_index[index];
}
