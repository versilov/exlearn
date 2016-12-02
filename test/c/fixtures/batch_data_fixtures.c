#ifndef INCLUDE_BATCH_DATA_FIXTURES_C
#define INCLUDE_BATCH_DATA_FIXTURES_C

static BatchData *
batch_data_simple() {
  BatchData *batch_data = malloc(sizeof(BatchData));

  batch_data->batch_length = 1;
  batch_data->data_length  = 1;

  batch_data->sample_index = malloc(sizeof(SampleIndex *));

  batch_data->sample_index[0] = sample_index_new(1, 1);

  return batch_data;
}

#endif
