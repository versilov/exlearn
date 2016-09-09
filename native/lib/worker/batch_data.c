#ifndef INCLUDE_BATCH_DATA_C
#define INCLUDE_BATCH_DATA_C

#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include <stdlib.h>
#include <time.h>

typedef struct BatchData {
  int  data_length;
  int  batch_length;
  int *indices;
} BatchData;

static void
free_batch_data(BatchData *data) {
  free(data->indices);
  free(data);
}

static BatchData *
new_batch_data(int data_length, int batch_length) {
  BatchData *data = malloc(sizeof(BatchData));

  data->data_length  = data_length;
  data->batch_length = batch_length;

  data->indices = malloc(sizeof(int) * data_length);

  for (int index = 0; index < data_length; index += 1) {
    data->indices[index] = index;
  }

  return data;
}

static void
shuffle_batch_data_indices(BatchData *data) {
  gsl_rng *rng;

  gsl_rng_env_setup();
  rng = gsl_rng_alloc(gsl_rng_default);
  gsl_rng_set(rng, time(NULL));

  gsl_ran_shuffle(rng, data->indices, data->data_length, sizeof(int));
}

#endif
