#ifndef INCLUDED_ACTIVITY_H
#define INCLUDED_ACTIVITY_H

#include <math.h>
#include <stdlib.h>

#include "../matrix.h"

typedef struct Activity {
  int     layers;
  Matrix *input;
  Matrix *output;
  Matrix *mask;
} Activity;

typedef void (*ActivityFunction)(Matrix, float);

typedef struct ActivityClosure {
  ActivityFunction function;
  float            alpha;
} ActivityClosure;

void              free_activity(Activity *);
Activity *        new_activity(int);
void              call_activity_closure(ActivityClosure *, Matrix);
void              free_activity_closure(ActivityClosure *);
ActivityClosure * new_activity_closure(ActivityFunction, float);
ActivityClosure * activity_determine_function(int, float);
ActivityClosure * activity_determine_derivative(int, float);

#endif
