#include "../../include/neural_network/presentation.h"

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

int
presentation_closure_call(PresentationClosure *closure, Matrix matrix) {
  if (closure != NULL)
    return closure->function(matrix, closure->alpha);
  else
    return 0;
}

void
presentation_closure_free(PresentationClosure **closure_address) {
  PresentationClosure *closure = *closure_address;

  if (closure != NULL) free(closure);

  *closure_address = NULL;
}

PresentationClosure *
presentation_closure_new(PresentationFunction function, int alpha) {
  PresentationClosure *closure = malloc(sizeof(PresentationClosure));

  closure->function = function;
  closure->alpha    = alpha;

  return closure;
}

PresentationClosure *
presentation_determine(int function_id, int alpha) {
  switch (function_id) {
    case 0:  return presentation_closure_new(argmax_function,      alpha);
    case 1:  return presentation_closure_new(floor_first_function, alpha);
    case 2:  return presentation_closure_new(round_first_function, alpha);
    case 3:  return presentation_closure_new(ceil_first_function,  alpha);
    default: return NULL;
  }
}
