#ifndef INCLUDED_PRESENTATION_H
#define INCLUDED_PRESENTATION_H

#include <math.h>

// #include "../matrix.c"

int
call_presentation_closure(PresentationClosure *closure, Matrix matrix);

void
free_presentation_closure(PresentationClosure *closure);

PresentationClosure *
new_presentation_closure(PresentationFunction function, int alpha);

PresentationClosure *
presentation_determine(int function_id, int alpha);

#endif
