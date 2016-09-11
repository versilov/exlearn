#ifndef INCLUDED_MATRIX_C
  #define INCLUDED_MATRIX_C

  #include "../../native/lib/matrix.c"
#endif

static void test_clone_matrix() {
  Matrix source      = new_matrix(1, 3);
  Matrix destination = new_matrix(1, 3);

  source[2] = 1;
  source[3] = 2;
  source[4] = 3;

  destination[2] = 10;
  destination[3] = 20;
  destination[4] = 30;

  clone_matrix(destination, source);

  for(int index = 0; index < 5; index += 1) {
    assert(destination[index] == source[index]);
  }
}

static void test_free_matrix() {
  Matrix matrix = new_matrix(1, 2);

  free_matrix(matrix);
}

static void test_new_matrix() {
  Matrix matrix = new_matrix(1, 2);

  assert(matrix[0] == 1);
  assert(matrix[1] == 2);
}

static void test_matrix_add() {
  float first[8]    = {2, 3, 1, 2, 3, 4, 5, 6 };
  float second[8]   = {2, 3, 5, 2, 1, 3, 4, 6 };
  float expected[8] = {2, 3, 6, 4, 4, 7, 9, 12};
  float result[8];

  matrix_add(first, second, result);

  for(int index = 0; index < 8; index += 1) {
    assert(expected[index] == result[index]);
  }
}

static void test_matrix_argmax() {
  float first[8]  = {2, 3, 1, 2, 3, 4, 5, 6};
  float second[8] = {2, 3, 8, 3, 4, 5, 6, 7};
  float third[8]  = {2, 3, 8, 3, 4, 9, 6, 7};

  assert(matrix_argmax(first)  == 5);
  assert(matrix_argmax(second) == 0);
  assert(matrix_argmax(third)  == 3);
}

static void test_matrix_divide() {
  float first[8]    = {2, 3, 1,   2, 6, 9, 10, 18};
  float second[8]   = {2, 3, 2,   2, 3, 3, 5,  6 };
  float expected[8] = {2, 3, 0.5, 1, 2, 3, 2,  3 };
  float result[8];

  matrix_divide(first, second, result);

  for(int index = 0; index < 8; index += 1) {
    assert(expected[index] == result[index]);
  }
}

static void test_matrix_dot() {
  float first[8]    = {2, 3, 1, 2, 3, 4, 5, 6};
  float second[8]   = {3, 2, 1, 2, 3, 4, 5, 6};
  float expected[8] = {2, 2, 22, 28, 49, 64};
  float result[8];

  matrix_dot(first, second, result);

  for(int index = 0; index < 6; index += 1) {
    assert(expected[index] == result[index]);
  }
}

static void test_matrix_dot_and_add() {
  float first[8]    = {2, 3, 1, 2, 3, 4, 5, 6};
  float second[8]   = {3, 2, 1, 2, 3, 4, 5, 6};
  float third[8]    = {2, 2, 1, 2, 3, 4};
  float expected[8] = {2, 2, 23, 30, 52, 68};
  float result[8];

  matrix_dot_and_add(first, second, third, result);

  for(int index = 0; index < 6; index += 1) {
    assert(expected[index] == result[index]);
  }
}

static void test_matrix_dot_nt() {
  float first[8]    = {2, 3, 1, 2, 3, 4, 5, 6};
  float second[8]   = {2, 3, 1, 3, 5, 2, 4, 6};
  float expected[8] = {2, 2, 22, 28, 49, 64};
  float result[8];

  matrix_dot_nt(first, second, result);

  for(int index = 0; index < 6; index += 1) {
    assert(expected[index] == result[index]);
  }
}

static void test_matrix_dot_tn() {
  float first[8]    = {3, 2, 1, 4, 2, 5, 3, 6};
  float second[8]   = {3, 2, 1, 2, 3, 4, 5, 6};
  float expected[8] = {2, 2, 22, 28, 49, 64};
  float result[8];

  matrix_dot_tn(first, second, result);

  for(int index = 0; index < 6; index += 1) {
    assert(expected[index] == result[index]);
  }
}

static void test_matrix_first() {
  float matrix[8] = {2, 3, 1, 4, 2, 5, 3, 6};

  assert(matrix_first(matrix) == 1);
}

static void test_matrix_max() {
  float matrix[8] = {2, 3, 1, 4, 2, 5, 3, 6};

  assert(matrix_max(matrix) == 6);
}

static void test_matrix_multiply() {
  float first[8]    = {2, 3, 1, 2, 3, 4,  5,  6 };
  float second[8]   = {2, 3, 5, 2, 1, 3,  4,  6 };
  float expected[8] = {2, 3, 5, 4, 3, 12, 20, 36};
  float result[8];

  matrix_multiply(first, second, result);

  for(int index = 0; index < 8; index += 1) {
    assert(expected[index] == result[index]);
  }
}

static void test_matrix_multiply_with_scalar() {
  float matrix[8]   = {2, 3, 1, 2, 3, 4, 5, 6};
  float scalar      = 2;
  float expected[8] = {2, 3, 2, 4, 6, 8, 10, 12};
  float result[8];

  matrix_multiply_with_scalar(matrix, scalar, result);

  for(int index = 0; index < 8; index += 1) {
    assert(expected[index] == result[index]);
  }
}

static void test_matrix_substract() {
  float first[8]    = {2, 3,  1, 2, 3, 4, 5, 6};
  float second[8]   = {2, 3,  5, 2, 1, 3, 4, 6};
  float expected[8] = {2, 3, -4, 0, 2, 1, 1, 0};
  float result[8];

  matrix_substract(first, second, result);

  for(int index = 0; index < 8; index += 1) {
    assert(expected[index] == result[index]);
  }
}

static void test_matrix_sum() {
  float matrix[8] = {2, 3, 1, 4, 2, 5, 3, 6};

  assert(matrix_sum(matrix) == 21);
}

static void test_matrix_transpose() {
  float matrix[8]   = {2, 3, 1, 2, 3, 4, 5, 6};
  float expected[8] = {3, 2, 1, 4, 2, 5, 3, 6};
  float result[8];

  matrix_transpose(matrix, result);

  for(int index = 0; index < 8; index += 1) {
    assert(expected[index] == result[index]);
  }
}
