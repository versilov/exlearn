#ifndef INCLUDED_SAMPLE_INDEX_H
#define INCLUDED_SAMPLE_INDEX_H

#include <stdint.h>
#include <stdlib.h>

typedef struct SampleIndex {
  int32_t bundle;
  int32_t index;
} SampleIndex;

void
sample_index_free(SampleIndex **sample_index_address);

SampleIndex *
sample_index_new(int32_t bundle, int32_t index);

#endif
