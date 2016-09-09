#ifndef INCLUDE_ACTIVITY_C
#define INCLUDE_ACTIVITY_C

#include <math.h>
#include <stdlib.h>

#include "matrix.c"
#include "structs.c"

//-----------------------------------------------------------------------------
// Activity function pairs
//-----------------------------------------------------------------------------

static void arctan_function(Matrix matrix, float _alpha) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    matrix[index] = atan(matrix[index]);
  }
}

static void arctan_derivative(Matrix matrix, float _alpha) {
  int   length = matrix[0] * matrix[1] + 2;
  float element;

  for (int index = 2; index < length; index += 1) {
    element = matrix[index];

    matrix[index] = 1.0 / (element * element + 1.0);
  }
}

static void bent_identity_function(Matrix matrix, float _alpha) {
  int   length = matrix[0] * matrix[1] + 2;
  float element;

  for (int index = 2; index < length; index += 1) {
    element = matrix[index];

    matrix[index] = (sqrt(element * element + 1.0) - 1.0) / 2.0 + element;
  }
}

static void bent_identity_derivative(Matrix matrix, float _alpha) {
  int   length = matrix[0] * matrix[1] + 2;
  float element;

  for (int index = 2; index < length; index += 1) {
    element = matrix[index];

    matrix[index] = element / (2.0 * sqrt(element * element + 1.0)) + 1.0;
  }
}

static void gaussian_function(Matrix matrix, float _alpha) {
  int   length = matrix[0] * matrix[1] + 2;
  float element;

  for (int index = 2; index < length; index += 1) {
    element = matrix[index];

    matrix[index] = exp(-element * element);
  }
}

static void gaussian_derivative(Matrix matrix, float _alpha) {
  int   length = matrix[0] * matrix[1] + 2;
  float element;

  for (int index = 2; index < length; index += 1) {
    element = matrix[index];

    matrix[index] = -2.0 * element * exp(-element * element);
  }
}

static void identity_function(Matrix matrix, float _alpha) {
  // Nothing to do here :)
}

static void identity_derivative(Matrix matrix, float _alpha) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    matrix[index] = 1.0;
  }
}

static void logistic_function(Matrix matrix, float _alpha) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    if      (matrix[index] >  709) matrix[index] = 1.0;
    else if (matrix[index] < -709) matrix[index] = 0.0;
    else                           matrix[index] = 1.0 / (1.0 + exp(-matrix[index]));
  }
}

static void logistic_derivative(Matrix matrix, float _alpha) {
  int   length = matrix[0] * matrix[1] + 2;
  float element;

  for (int index = 2; index < length; index += 1) {
    if      (matrix[index] >  709) element = 1.0;
    else if (matrix[index] < -709) element = 0.0;
    else                           element = 1.0 / (1.0 + exp(matrix[index]));

    matrix[index] = element * (1.0 - element);
  }
}

static void relu_function(Matrix matrix, float _alpha) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    if (matrix[index] <  0) matrix[index] = 0.0;
  }
}

static void relu_derivative(Matrix matrix, float _alpha) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    if (matrix[index] <  0) matrix[index] = 0.0;
    else                    matrix[index] = 1.0;
  }
}

static void sinc_function(Matrix matrix, float _alpha) {
  int   length = matrix[0] * matrix[1] + 2;
  float element;

  for (int index = 2; index < length; index += 1) {
    element = matrix[index];

    if (element == 0.0) matrix[index] = 1.0;
    else                matrix[index] = sin(element) / element;
  }
}

static void sinc_derivative(Matrix matrix, float _alpha) {
  int   length = matrix[0] * matrix[1] + 2;
  float element;

  for (int index = 2; index < length; index += 1) {
    element = matrix[index];

    if (element != 0.0)
      matrix[index] = cos(element) / element - sin(element) / (element * element);
  }
}

static void sinusoid_function(Matrix matrix, float _alpha) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    matrix[index] = sin(matrix[index]);
  }
}

static void sinusoid_derivative(Matrix matrix, float _alpha) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    matrix[index] = cos(matrix[index]);
  }
}

static void softmax_function(Matrix matrix, float _alpha) {
  int   length     = matrix[0] * matrix[1] + 2;
  float maximum    = matrix_max(matrix);
  float normalizer = 0.0;

  for (int index = 2; index < length; index += 1) {
    normalizer += exp(matrix[index] - maximum);
  }

  for (int index = 2; index < length; index += 1) {
    matrix[index] = exp(matrix[index] - maximum) / normalizer;
  }
}

static void softmax_derivative(Matrix matrix, float _alpha) {
  int    length = matrix[0] * matrix[1] + 2;
  Matrix temp   = malloc(sizeof(float) * length);
  float  sum;

  for (int first_index = 2; first_index < length; first_index += 1) {
    sum = 0.0;

    for (int second_index = 2; second_index < length; second_index += 1) {
      if (first_index == second_index)
        sum += matrix[first_index] * (1.0 - matrix[second_index]);
      else
        sum += -matrix[first_index] * matrix[second_index];
    }

    temp[first_index] = sum;
  }

  for (int index = 2; index < length; index += 1) {
    matrix[index] = temp[index];
  }

  free(temp);
}

static void softplus_function(Matrix matrix, float _alpha) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    matrix[index] = log(1.0 + exp(matrix[index]));
  }
}

static void softplus_derivative(Matrix matrix, float _alpha) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    matrix[index] = 1.0 / (1.0 + exp(-matrix[index]));
  }
}

static void softsign_function(Matrix matrix, float _alpha) {
  int   length = matrix[0] * matrix[1] + 2;
  float element;

  for (int index = 2; index < length; index += 1) {
    element = matrix[index];

    matrix[index] = element / (1.0 + abs(element));
  }
}

static void softsign_derivative(Matrix matrix, float _alpha) {
  int   length = matrix[0] * matrix[1] + 2;
  float element;

  for (int index = 2; index < length; index += 1) {
    element = 1.0 + abs(matrix[index]);

    matrix[index] = 1.0 / (element * element);
  }
}

static void tanh_function(Matrix matrix, float _alpha) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    matrix[index] = tanh(matrix[index]);
  }
}

static void tanh_derivative(Matrix matrix, float _alpha) {
  int   length = matrix[0] * matrix[1] + 2;
  float element;

  for (int index = 2; index < length; index += 1) {
    element = tanh(matrix[index]);

    matrix[index] = 1.0 - (element * element);
  }
}

static void elu_function(Matrix matrix, float alpha) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    if (matrix[index] < 0.0)
      matrix[index] = alpha * (exp(matrix[index]) - 1.0);
  }
}

static void elu_derivative(Matrix matrix, float alpha) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    if (matrix[index] < 0.0)
      matrix[index] = alpha * exp(matrix[index]);
    else
      matrix[index] = 1.0;
  }
}

static void prelu_function(Matrix matrix, float alpha) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    if (matrix[index] < 0.0)
      matrix[index] = alpha * matrix[index];
  }
}

static void prelu_derivative(Matrix matrix, float alpha) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    if (matrix[index] < 0.0)
      matrix[index] = alpha;
    else
      matrix[index] = 1.0;
  }
}

//-----------------------------------------------------------------------------
// Public API
//-----------------------------------------------------------------------------

static void
call_activity_closure(ActivityClosure *closure, Matrix matrix) {
  if (closure != NULL)
    closure->function(matrix, closure->alpha);
}

static void
free_activity_closure(ActivityClosure *closure) {
  free(closure);
}

static ActivityClosure *
new_activity_closure(ActivityFunction function, float alpha) {
  ActivityClosure *closure = malloc(sizeof(ActivityClosure));

  closure->function = function;
  closure->alpha    = alpha;

  return closure;
}

static ActivityClosure *
activity_determine_function(int function_id, float alpha) {
  switch (function_id) {
    case  0: return new_activity_closure(arctan_function,        0    );
    case  1: return new_activity_closure(bent_identity_function, 0    );
    case  2: return new_activity_closure(gaussian_function,      0    );
    case  3: return new_activity_closure(identity_function,      0    );
    case  4: return new_activity_closure(logistic_function,      0    );
    case  5: return new_activity_closure(relu_function,          0    );
    case  6: return new_activity_closure(sinc_function,          0    );
    case  7: return new_activity_closure(sinusoid_function,      0    );
    case  8: return new_activity_closure(softmax_function,       0    );
    case  9: return new_activity_closure(softplus_function,      0    );
    case 10: return new_activity_closure(softsign_function,      0    );
    case 11: return new_activity_closure(tanh_function,          0    );
    case 12: return new_activity_closure(elu_function,           alpha);
    case 13: return new_activity_closure(prelu_function,         alpha);
    default: return NULL;
  }
}

static ActivityClosure *
activity_determine_derivative(int function_id, float alpha) {
  switch (function_id) {
    case  0: return new_activity_closure(arctan_derivative,        0    );
    case  1: return new_activity_closure(bent_identity_derivative, 0    );
    case  2: return new_activity_closure(gaussian_derivative,      0    );
    case  3: return new_activity_closure(identity_derivative,      0    );
    case  4: return new_activity_closure(logistic_derivative,      0    );
    case  5: return new_activity_closure(relu_derivative,          0    );
    case  6: return new_activity_closure(sinc_derivative,          0    );
    case  7: return new_activity_closure(sinusoid_derivative,      0    );
    case  8: return new_activity_closure(softmax_derivative,       0    );
    case  9: return new_activity_closure(softplus_derivative,      0    );
    case 10: return new_activity_closure(softsign_derivative,      0    );
    case 11: return new_activity_closure(tanh_derivative,          0    );
    case 12: return new_activity_closure(elu_derivative,           alpha);
    case 13: return new_activity_closure(prelu_derivative,         alpha);
    default: return NULL;
  }
}

#endif
