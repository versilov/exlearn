#ifndef INCLUDED_PRESENTATION_CLOSURE_H
#define INCLUDED_PRESENTATION_CLOSURE_H

#include <math.h>
#include <stdint.h>

#include "../matrix.h"

typedef int32_t (*PresentationFunction)(Matrix, int32_t);

typedef struct PresentationClosure {
  PresentationFunction function;
  int32_t              function_id;
  int32_t              alpha;
} PresentationClosure;

int32_t
presentation_closure_call(PresentationClosure *presentation_closure, Matrix matrix);

void
presentation_closure_free(PresentationClosure **presentation_closure);

void
presentation_closure_inspect(PresentationClosure *presentation_closure);

void
presentation_closure_inspect_internal(
  PresentationClosure *presentation_closure,
  int32_t              indentation
);

PresentationClosure *
presentation_closure_new(
  PresentationFunction function,
  int32_t              function_id,
  int32_t              alpha
);

PresentationClosure *
presentation_closure_determine(int32_t function_id, int32_t alpha);

#endif
