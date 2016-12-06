#ifndef INCLUDED_ACTIVATION_CLOSURE_H
#define INCLUDED_ACTIVATION_CLOSURE_H

#include <math.h>
#include <stdint.h>
#include <stdlib.h>

#include "../matrix.h"

typedef void (*ActivationFunction)(Matrix, float);

typedef struct ActivationClosure {
  ActivationFunction function;
  int32_t            function_id;
  float              alpha;
} ActivationClosure;

void
activation_closure_call(ActivationClosure *, Matrix);

void
activation_closure_free(ActivationClosure *);

ActivationClosure *
activation_closure_new(ActivationFunction, int32_t, float);

ActivationClosure *
activation_determine_function(int32_t, float);

ActivationClosure *
activation_determine_derivative(int32_t, float);

#endif
