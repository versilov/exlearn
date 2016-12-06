#include "../../../native/include/neural_network/presentation_closure.h"
#include "../../../native/include/matrix.h"

static void test_presentation_closure_call() {
  PresentationClosure *closure = presentation_closure_determine(0, 0);
  Matrix               matrix  = matrix_new(1, 1);
  int32_t              result;

  matrix[2] = 1;
  result    = presentation_closure_call(closure, matrix);

  assert(result == 0); /* LCOV_EXCL_BR_LINE */

  presentation_closure_free(&closure);
}

static void test_presentation_closure_free() {
  PresentationClosure *closure = presentation_closure_new(NULL, 1, 0);

  presentation_closure_free(&closure);

  assert(closure == NULL); /* LCOV_EXCL_BR_LINE */
}

static void test_presentation_closure_inspect_callback() {
  PresentationClosure *presentation_closure = presentation_closure_determine(0, 1);

  presentation_closure_inspect(presentation_closure);

  presentation_closure_free(&presentation_closure);
}

static void test_presentation_closure_inspect() {
  char *result   = capture_stdout(test_presentation_closure_inspect_callback);
  char *expected = "<#PresentationClosure function: F, function_id: 0, alpha: 1>\n";

  int32_t result_length   = strlen(result  );
  int32_t expected_length = strlen(expected);

  assert(result_length == expected_length); /* LCOV_EXCL_BR_LINE */

  for(int32_t index = 0; index <= result_length; index += 1) {
    assert(result[index] == expected[index]); /* LCOV_EXCL_BR_LINE */
  }
}

static void test_presentation_closure_inspect_internal_callback() {
  PresentationClosure *presentation_closure = presentation_closure_determine(0, 1);

  presentation_closure_inspect_internal(presentation_closure, 3);

  presentation_closure_free(&presentation_closure);
}

static void test_presentation_closure_inspect_internal() {
  char *result   = capture_stdout(test_presentation_closure_inspect_internal_callback);
  char *expected = "<#PresentationClosure function: F, function_id: 0, alpha: 1>";

  int32_t result_length   = strlen(result  );
  int32_t expected_length = strlen(expected);

  assert(result_length == expected_length); /* LCOV_EXCL_BR_LINE */

  for(int32_t index = 0; index <= result_length; index += 1) {
    assert(result[index] == expected[index]); /* LCOV_EXCL_BR_LINE */
  }
}

static void test_presentation_closure_new() {
  PresentationClosure *closure = presentation_closure_new(NULL, 1, 0);

  assert(closure->function    == NULL); /* LCOV_EXCL_BR_LINE */
  assert(closure->function_id == 1   ); /* LCOV_EXCL_BR_LINE */
  assert(closure->alpha       == 0   ); /* LCOV_EXCL_BR_LINE */

  presentation_closure_free(&closure);
}

static void test_an_unknown_function() {
  PresentationClosure *closure = presentation_closure_determine(-1, 0);

  assert(closure == NULL); /* LCOV_EXCL_BR_LINE */

  Matrix  matrix  = matrix_new(1, 1);
  int32_t result;

  matrix[2] = 1;
  result    = presentation_closure_call(closure, matrix);

  assert(result == 0); /* LCOV_EXCL_BR_LINE */

  presentation_closure_free(&closure);
}

static void test_the_argmax_function() {
  PresentationClosure *closure = presentation_closure_determine(0, 1);
  Matrix               matrix  = matrix_new(1, 3);
  int32_t              result;

  matrix[2] = 1;
  matrix[3] = 2;
  matrix[4] = 3;
  result    = presentation_closure_call(closure, matrix);

  assert(result == 3); /* LCOV_EXCL_BR_LINE */

  presentation_closure_free(&closure);
}

static void test_the_floor_first_function() {
  PresentationClosure *closure = presentation_closure_determine(1, 1);
  Matrix               matrix  = matrix_new(1, 3);
  int32_t              result;

  matrix[2] = 1.1;
  matrix[3] = 2;
  matrix[4] = 3;
  result    = presentation_closure_call(closure, matrix);

  assert(result == 2); /* LCOV_EXCL_BR_LINE */

  presentation_closure_free(&closure);
}

static void test_the_round_first_function() {
  PresentationClosure *closure = presentation_closure_determine(2, 1);
  Matrix               matrix  = matrix_new(1, 3);
  int32_t              result;

  matrix[2] = 1.4;
  matrix[3] = 2;
  matrix[4] = 3;

  result = presentation_closure_call(closure, matrix);
  assert(result == 2); /* LCOV_EXCL_BR_LINE */

  matrix[2] = 1.6;

  result = presentation_closure_call(closure, matrix);
  assert(result == 3); /* LCOV_EXCL_BR_LINE */

  presentation_closure_free(&closure);
}

static void test_the_ceil_first_function() {
  PresentationClosure *closure = presentation_closure_determine(3, 1);
  Matrix               matrix  = matrix_new(1, 3);
  int32_t              result;

  matrix[2] = 1.1;
  matrix[3] = 2;
  matrix[4] = 3;
  result    = presentation_closure_call(closure, matrix);

  assert(result == 3); /* LCOV_EXCL_BR_LINE */

  presentation_closure_free(&closure);
}
