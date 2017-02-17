#include "../../native/include/nif_error.h"


//-----------------------------------------------------------------------------
// Tests
//-----------------------------------------------------------------------------

static void test_nif_error_free() {
  NIFError *nif_error = nif_error_new("Big Bad ERROR!");

  nif_error_free(&nif_error);

  assert(nif_error == NULL); /* LCOV_EXCL_BR_LINE */
}

static void test_nif_error_new() {
  char     *message   = "Big Bad ERROR!";
  NIFError *nif_error = nif_error_new(message);

  assert(nif_error != NULL); /* LCOV_EXCL_BR_LINE */
  assert(nif_error->message != NULL); /* LCOV_EXCL_BR_LINE */

  for (int32_t index = 0; index < 15; index += 1) {
    assert(nif_error->message[index] == message[index]); /* LCOV_EXCL_BR_LINE */
  }
}
