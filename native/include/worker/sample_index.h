#ifndef INCLUDED_SAMPLE_INDEX_H
#define INCLUDED_SAMPLE_INDEX_H

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "../utils.h"

typedef struct SampleIndex {
  int32_t bundle;
  int32_t index;
} SampleIndex;

void
sample_index_free(SampleIndex **sample_index_address);

void
sample_index_inspect(SampleIndex *sample_index);

void
sample_index_inspect_internal(SampleIndex *sample_index, int32_t indentation);

SampleIndex *
sample_index_new(int32_t bundle, int32_t index);

#endif
