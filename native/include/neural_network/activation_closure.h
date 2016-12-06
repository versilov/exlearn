#ifndef INCLUDED_ACTIVATION_CLOSURE_H
#define INCLUDED_ACTIVATION_CLOSURE_H

#include <math.h>
#include <stdint.h>
#include <stdlib.h>

#include "../matrix.h"

typedef void (*ActivationFunction)(Matrix, float);

typedef struct ActivationClosure {
  ActivationFunction function;
  float              alpha;
} ActivationClosure;

void
call_activation_closure(ActivationClosure *, Matrix);

void
free_activation_closure(ActivationClosure *);

ActivationClosure *
new_activation_closure(ActivationFunction, float);

ActivationClosure *
activation_determine_function(int32_t, float);

ActivationClosure *
activation_determine_derivative(int32_t, float);

#endif
