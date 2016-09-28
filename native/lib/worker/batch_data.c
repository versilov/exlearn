#ifndef INCLUDE_BATCH_DATA_C
#define INCLUDE_BATCH_DATA_C

#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include <stdlib.h>
#include <time.h>

#include "sample_index.c"
#include "worker_data.c"

typedef struct BatchData {
  int           batch_length;
  int           data_length;
  SampleIndex **sample_index;
} BatchData;

static void
free_batch_data(BatchData *data) {
  if (data != NULL) {
    for (int index = 0; index < data->data_length; index += 1) {
      sample_index_free(&(data->sample_index[index]));
    }

    free(data->sample_index);
    free(data);
  }
}

static BatchData *
new_batch_data(WorkerData *data, int batch_length) {
  int               data_length, data_index;
  BatchData        *batch;
  WorkerDataBundle *bundle;

  batch       = malloc(sizeof(BatchData));
  data_length = 0;

  for (int index = 0; index < data->count; index += 1) {
    data_length += data->bundle[index]->count;
  }

  batch->batch_length = batch_length;
  batch->data_length  = data_length;

  batch->sample_index = malloc(sizeof(SampleIndex *) * data_length);

  data_index = 0;
  for (int bundle_index = 0; bundle_index < data->count; bundle_index += 1) {
    bundle = data->bundle[bundle_index];

    for (int sample_index = 0; sample_index < bundle->count; sample_index += 1) {
      batch->sample_index[data_index] = sample_index_new(bundle_index, sample_index);

      data_index += 1;
    }
  }

  return batch;
}

static void
shuffle_batch_data_indices(BatchData *data) {
  gsl_rng *rng;

  gsl_rng_env_setup();
  rng = gsl_rng_alloc(gsl_rng_default);
  gsl_rng_set(rng, time(NULL));

  gsl_ran_shuffle(rng, data->sample_index, data->data_length, sizeof(SampleIndex));
}

#endif
