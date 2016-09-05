#include <assert.h>

#include "../../c_src/lib/matrix.c"

static void test_matrix_add() {
  float first[5]    = {1, 3, 1, 2, 3};
  float second[5]   = {1, 3, 2, 3, 4};
  float expected[5] = {1, 3, 3, 5, 7};
  float result[5];

  matrix_add(first, second, result);

  for(int index = 2; index < 5; index += 1) {
    assert(expected[index] == result[index]);
  }
}

int main() {
  test_matrix_add();

  return 0;
}
