#ifndef INCLUDED_MATRIX_C
#define INCLUDED_MATRIX_C

#include <cblas.h>

static inline void
matrix_add(const float *first, const float *second, float *result) {
  int data_size = (int) (first[0] * first[1] + 2);

  result[0] = first[0];
  result[1] = first[1];

  for (int index = 2; index < data_size; index += 1) {
    result[index] = first[index] + second[index];
  }
}

static inline int
matrix_argmax(const float *matrix) {
  int data_size = (int) (matrix[0] * matrix[1] + 2);
  int argmax    = 2;

  for (int index = 3; index < data_size; index += 1) {
    if (matrix[argmax] < matrix[index]) {
      argmax = index;
    }
  }

  return argmax - 2;
}

static inline void
matrix_divide(const float *first, const float *second, float *result) {
  int data_size = (int) (first[0] * first[1] + 2);

  result[0] = first[0];
  result[1] = first[1];

  for (int index = 2; index < data_size; index += 1) {
    result[index] = first[index] / second[index];
  }
}

static inline void
matrix_dot(const float *first, const float *second, float *result) {
  result[0] = first[0];
  result[1] = second[1];

  cblas_sgemm(
    CblasRowMajor,
    CblasNoTrans,
    CblasNoTrans,
    first[0],
    second[1],
    first[1],
    1.0,
    first + 2,
    first[1],
    second + 2,
    second[1],
    0.0,
    result + 2,
    result[1]
  );
}

static inline void
matrix_dot_and_add(
  const float *first, const float *second, const float *third, float *result
) {
  int data_size = (int) (first[0] * first[1] + 2);

  result[0] = first[0];
  result[1] = second[1];

  cblas_sgemm(
    CblasRowMajor,
    CblasNoTrans,
    CblasNoTrans,
    first[0],
    second[1],
    first[1],
    1.0,
    first + 2,
    first[1],
    second + 2,
    second[1],
    0.0,
    result + 2,
    result[1]
  );

  for(int index = 2; index < data_size; index += 1) {
    result[index] += third[index];
  }
}

static inline void
matrix_dot_nt(const float *first, const float *second, float *result) {
  result[0] = first[0];
  result[1] = second[0];

  cblas_sgemm(
    CblasRowMajor,
    CblasNoTrans,
    CblasTrans,
    first[0],
    second[0],
    first[1],
    1.0,
    first + 2,
    first[1],
    second + 2,
    second[1],
    0.0,
    result + 2,
    result[1]
  );
}

static inline void
matrix_dot_tn(const float *first, const float *second, float *result) {
  result[0] = first[1];
  result[1] = second[1];

  cblas_sgemm(
    CblasRowMajor,
    CblasTrans,
    CblasNoTrans,
    first[1],
    second[1],
    first[0],
    1.0,
    first + 2,
    first[1],
    second + 2,
    second[1],
    0.0,
    result + 2,
    result[1]
  );
}

static inline float
matrix_max(const float *matrix) {
  int   data_size = (int) (matrix[0] * matrix[1] + 2);
  float max       = matrix[2];

  for (int index = 3; index < data_size; index += 1) {
    if (max < matrix[index]) {
      max = matrix[index];
    }
  }

  return max;
}

static inline void
matrix_multiply(const float *first, const float *second, float *result) {
  int data_size = (int) (first[0] * first[1] + 2);

  result[0] = first[0];
  result[1] = first[1];

  for (int index = 2; index < data_size; index += 1) {
    result[index] = first[index] * second[index];
  }
}

static inline void
matrix_multiply_with_scalar(
  const float *matrix, const float scalar, float *result
) {
  int data_size = (int) (matrix[0] * matrix[1] + 2);

  result[0] = matrix[0];
  result[1] = matrix[1];

  for (int index = 2; index < data_size; index += 1) {
    result[index] = matrix[index] * scalar;
  }
}

static inline void
matrix_substract(const float *first, const float *second, float *result) {
  int data_size = (int) (first[0] * first[1] + 2);

  result[0] = first[0];
  result[1] = first[1];

  for (int index = 2; index < data_size; index += 1) {
    result[index] = first[index] - second[index];
  }
}

static inline float
matrix_sum(const float *matrix) {
  int   data_size = matrix[0] * matrix[1] + 2;
  float sum       = 0;

  for (int index = 2; index < data_size; index += 1) {
    sum += matrix[index];
  }

  return sum;
}

static inline void
matrix_transpose(const float *matrix, float *result) {
  result[0] = matrix[1];
  result[1] = matrix[0];

  for (int row = 0; row < matrix[0]; row += 1) {
    for (int column = 0; column < matrix[1]; column += 1) {
      int result_index = column * result[1] + row    + 2;
      int matrix_index = row *    matrix[1] + column + 2;

      result[result_index] = matrix[matrix_index];
    }
  }
}

#endif
