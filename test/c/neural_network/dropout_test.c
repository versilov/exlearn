#include "../../../native/lib/neural_network/dropout.c"
#include "../../../native/lib/matrix.c"

#include <stdio.h>
static void test_create_dropout_mask() {
  Matrix matrix = create_dropout_mask(1, 10, 0.5);

  assert(matrix[0] == 1);
  assert(matrix[1] == 10);

  for (int index = 2; index < 12; index += 1) {
    assert(matrix[index] == 0.0 || matrix[index] == 2.0);
  }
}
