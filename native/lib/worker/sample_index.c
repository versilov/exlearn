#ifndef INCLUDED_SAMPLE_INDEX_C
#define INCLUDED_SAMPLE_INDEX_C

typedef struct SampleIndex {
  int bundle;
  int index;
} SampleIndex;

static SampleIndex *
sample_index_new(int bundle, int index) {
  SampleIndex *sample_index = malloc(sizeof(SampleIndex));

  sample_index->bundle = bundle;
  sample_index->index  = index;

  return sample_index;
}

static void
sample_index_free(SampleIndex **index_address) {
  SampleIndex *index = *index_address;

  free(index);

  *index_address = NULL;
}

#endif
