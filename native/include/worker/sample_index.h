#ifndef INCLUDED_SAMPLE_INDEX_H
#define INCLUDED_SAMPLE_INDEX_H

#include <stdlib.h>

typedef struct SampleIndex {
  int bundle;
  int index;
} SampleIndex;

SampleIndex *
sample_index_new(int bundle, int index);

void
sample_index_free(SampleIndex **index_address);

#endif
