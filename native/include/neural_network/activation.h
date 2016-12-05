#ifndef INCLUDED_ACTIVATION_H
#define INCLUDED_ACTIVATION_H

#include <math.h>
#include <stdint.h>
#include <stdlib.h>

#include "../matrix.h"

typedef struct Activation {
  int32_t  layers;
  Matrix  *input;
  Matrix  *output;
  Matrix  *mask;
} Activation;

typedef void (*ActivationFunction)(Matrix, float);

typedef struct ActivationClosure {
  ActivationFunction function;
  float              alpha;
} ActivationClosure;

void
activation_free(Activation **);

Activation *
activation_new(int);

void
call_activation_closure(ActivationClosure *, Matrix);

void
free_activation_closure(ActivationClosure *);

ActivationClosure *
new_activation_closure(ActivationFunction, float);

ActivationClosure *
activation_determine_function(int, float);

ActivationClosure *
activation_determine_derivative(int, float);

#endif
