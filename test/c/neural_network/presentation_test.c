#include "../../../native/lib/neural_network/presentation.c"
#include "../../../native/lib/matrix.c"

static void test_free_presentation_closure() {
  PresentationClosure *closure = new_presentation_closure(0, 0);

  free_presentation_closure(closure);
}

static void test_new_presentation_closure() {
  PresentationClosure *closure = new_presentation_closure(0, 0);

  free_presentation_closure(closure);
}

static void test_call_presentation_closure() {
  PresentationClosure *closure = presentation_determine(0, 0);
  Matrix               matrix  = new_matrix(1, 1);
  int                  result;

  matrix[2] = 1;
  result    = call_presentation_closure(closure, matrix);

  assert(result == 0);

  free_presentation_closure(closure);
}

static void test_an_unknown_function() {
  PresentationClosure *closure = presentation_determine(-1, 0);
  assert(closure == NULL);

  Matrix matrix  = new_matrix(1, 1);
  int    result;

  matrix[2] = 1;
  result    = call_presentation_closure(closure, matrix);

  assert(result == 0);

  free_presentation_closure(closure);
}

static void test_the_argmax_function() {
  PresentationClosure *closure = presentation_determine(0, 1);
  Matrix               matrix  = new_matrix(1, 3);
  int                  result;

  matrix[2] = 1;
  matrix[3] = 2;
  matrix[4] = 3;
  result    = call_presentation_closure(closure, matrix);

  assert(result == 3);

  free_presentation_closure(closure);
}

static void test_the_floor_first_function() {
  PresentationClosure *closure = presentation_determine(1, 1);
  Matrix               matrix  = new_matrix(1, 3);
  int                  result;

  matrix[2] = 1.1;
  matrix[3] = 2;
  matrix[4] = 3;
  result    = call_presentation_closure(closure, matrix);

  assert(result == 2);

  free_presentation_closure(closure);
}

static void test_the_round_first_function() {
  PresentationClosure *closure = presentation_determine(2, 1);
  Matrix               matrix  = new_matrix(1, 3);
  int                  result;

  matrix[2] = 1.4;
  matrix[3] = 2;
  matrix[4] = 3;

  result = call_presentation_closure(closure, matrix);
  assert(result == 2);

  matrix[2] = 1.6;

  result = call_presentation_closure(closure, matrix);
  assert(result == 3);


  free_presentation_closure(closure);
}

static void test_the_ceil_first_function() {
  PresentationClosure *closure = presentation_determine(3, 1);
  Matrix               matrix  = new_matrix(1, 3);
  int                  result;

  matrix[2] = 1.1;
  matrix[3] = 2;
  matrix[4] = 3;
  result    = call_presentation_closure(closure, matrix);

  assert(result == 3);

  free_presentation_closure(closure);
}
