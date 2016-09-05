#include <assert.h>

#include "../../c_src/lib/matrix.c"

static void test_matrix_add() {
  float first[8]    = {2, 3, 1, 2, 3, 4, 5, 6 };
  float second[8]   = {2, 3, 5, 2, 1, 3, 4, 6 };
  float expected[8] = {2, 3, 6, 4, 4, 7, 9, 12};
  float result[8];

  matrix_add(first, second, result);

  for(int index = 2; index < 5; index += 1) {
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

int main() {
  test_matrix_add();
  test_matrix_argmax();

  return 0;
}
