#ifndef INCLUDE_DATA_FIXTURES_C
#define INCLUDE_DATA_FIXTURES_C

static Matrix
data_sample_basic() {
  Matrix sample = matrix_new(1, 3);

  sample[2] = 1;
  sample[3] = 2;
  sample[4] = 3;

  return sample;
}

static Matrix
data_expected_basic() {
  Matrix sample = matrix_new(1, 2);

  sample[2] = 1800;
  sample[3] = 2700;

  return sample;
}

#endif
