#ifndef INCLUDED_PRESENTATION_H
#define INCLUDED_PRESENTATION_H

#include <math.h>

#include "../matrix.h"

typedef int (*PresentationFunction)(Matrix, int);

typedef struct PresentationClosure {
  PresentationFunction function;
  int                  alpha;
} PresentationClosure;

int
presentation_closure_call(PresentationClosure *closure, Matrix matrix);

void
presentation_closure_free(PresentationClosure **closure);

PresentationClosure *
presentation_closure_new(PresentationFunction function, int alpha);

PresentationClosure *
presentation_determine(int function_id, int alpha);

#endif
