#ifndef INCLUDE_DATA_FIXTURES_C
#define INCLUDE_DATA_FIXTURES_C

static Matrix
data_sample_basic() {
  Matrix sample = new_matrix(1, 3);

  sample[2] = 1;
  sample[3] = 2;
  sample[4] = 3;

  return sample;
}

#endif
