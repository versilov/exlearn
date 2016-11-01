#ifndef INCLUDE_BATCH_DATA_C
#define INCLUDE_BATCH_DATA_C

#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>

#include <stdlib.h>
#include <time.h>

#include "./sample_index.h"
#include "./worker_data.h"

typedef struct BatchData {
  int           batch_length;
  int           data_length;
  SampleIndex **sample_index;
} BatchData;

void
free_batch_data(BatchData *data);

BatchData *
new_batch_data(WorkerData *data, int batch_length);

void
shuffle_batch_data_indices(BatchData *data);

SampleIndex *
batch_data_get_sample_index(BatchData *batch_data, int batch_number, int offset);

#endif
