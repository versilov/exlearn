#include "../../include/worker/sample_index.h"

SampleIndex *
sample_index_new(int32_t bundle, int32_t index) {
  SampleIndex *sample_index = malloc(sizeof(SampleIndex));

  sample_index->bundle = bundle;
  sample_index->index  = index;

  return sample_index;
}

void
sample_index_free(SampleIndex **index_address) {
  SampleIndex *index = *index_address;

  free(index);

  *index_address = NULL;
}
