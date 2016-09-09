#ifndef INCLUDE_PRESENTATION_C
#define INCLUDE_PRESENTATION_C

#include <math.h>

#include "../matrix.c"

static int argmax_function(Matrix matrix, int alpha) {
  int argmax = matrix_argmax(matrix);

  return argmax + alpha;
}

static int floor_first_function(Matrix matrix, int alpha) {
  int result = floorf(matrix_first(matrix));

  return result + alpha;
}

static int round_first_function(Matrix matrix, int alpha) {
  int result = roundf(matrix_first(matrix));

  return result + alpha;
}

static int ceil_first_function(Matrix matrix, int alpha) {
  int result = ceilf(matrix_first(matrix));

  return result + alpha;
}

static int
call_presentation_closure(PresentationClosure *closure, Matrix matrix) {
  if (closure != NULL)
    return closure->function(matrix, closure->alpha);
  else
    return 0;
}

static void
free_presentation_closure(PresentationClosure *closure) {
  if (closure != NULL) free(closure);
}

static PresentationClosure *
new_presentation_closure(PresentationFunction function, int alpha) {
  PresentationClosure *closure = malloc(sizeof(PresentationClosure));

  closure->function = function;
  closure->alpha    = alpha;

  return closure;
}

static PresentationClosure *
presentation_determine(int function_id, int alpha) {
  switch (function_id) {
    case 0:  return new_presentation_closure(argmax_function,      alpha);
    case 1:  return new_presentation_closure(floor_first_function, alpha);
    case 2:  return new_presentation_closure(round_first_function, alpha);
    case 3:  return new_presentation_closure(ceil_first_function,  alpha);
    default: return NULL;
  }
}

#endif
