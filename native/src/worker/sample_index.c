#include "../../include/worker/sample_index.h"

void
sample_index_free(SampleIndex **sample_index_address) {
  SampleIndex *sample_index = *sample_index_address;

  free(sample_index);

  *sample_index_address = NULL;
}

void
sample_index_inspect(SampleIndex *sample_index) {
  printf(
    "<#SampleIndex bundle: %d index: %d>\n",
    sample_index->bundle,
    sample_index->index
  );
}

void
sample_index_inspect_internal(SampleIndex *sample_index, int32_t _indentation) {
  (void)(_indentation);

  printf(
    "<#SampleIndex bundle: %d index: %d>",
    sample_index->bundle,
    sample_index->index
  );
}

SampleIndex *
sample_index_new(int32_t bundle, int32_t index) {
  SampleIndex *sample_index = malloc(sizeof(SampleIndex));

  sample_index->bundle = bundle;
  sample_index->index  = index;

  return sample_index;
}
