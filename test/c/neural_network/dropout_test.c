#include "../../../native/include/neural_network/dropout.h"
#include "../../../native/include/matrix.h"

static void test_create_dropout_mask() {
  Matrix matrix = create_dropout_mask(1, 10, 0.5);

  assert(matrix[0] ==  1); /* LCOV_EXCL_BR_LINE */
  assert(matrix[1] == 10); /* LCOV_EXCL_BR_LINE */

  for (int index = 2; index < 12; index += 1) {
    assert(matrix[index] == 0.0 || matrix[index] == 2.0); /* LCOV_EXCL_BR_LINE */
  }

  matrix_free(&matrix);
}
