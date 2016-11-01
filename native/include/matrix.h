#ifndef INCLUDED_MATRIX_H
#define INCLUDED_MATRIX_H

#include <cblas.h>
#include <stdlib.h>

typedef float* Matrix;

void
clone_matrix(Matrix destination, Matrix source);

void
free_matrix(Matrix matrix);

Matrix
new_matrix(int rows, int columns);

void
matrix_fill(Matrix matrix, int value);

int
matrix_equal(Matrix first, Matrix second);

void
matrix_add(const Matrix first, const Matrix second, Matrix result);

int
matrix_argmax(const Matrix matrix);

void
matrix_divide(const Matrix first, const Matrix second, Matrix result);

void
matrix_dot(const Matrix first, const Matrix second, Matrix result);

void
matrix_dot_and_add(
  const Matrix first, const Matrix second, const Matrix third, Matrix result
);

void
matrix_dot_nt(const Matrix first, const Matrix second, Matrix result);

void
matrix_dot_tn(const Matrix first, const Matrix second, Matrix result);

float
matrix_first(const Matrix matrix);

float
matrix_max(const Matrix matrix);

void
matrix_multiply(const Matrix first, const Matrix second, Matrix result);

void
matrix_multiply_with_scalar(
  const Matrix matrix, const float scalar, Matrix result
);

void
matrix_substract(const Matrix first, const Matrix second, Matrix result);

float
matrix_sum(const Matrix matrix);

void
matrix_transpose(const Matrix matrix, Matrix result);
#endif
