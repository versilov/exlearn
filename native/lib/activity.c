#include <math.h>
#include <stdlib.h>

typedef void (*ActivityFunction)(float *);

//-----------------------------------------------------------------------------
// Activity function pairs
//-----------------------------------------------------------------------------

static void arctan_function(float *matrix) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    matrix[index] = atan(matrix[index]);
  }
}

static void arctan_derivative(float *matrix) {
  int   length = matrix[0] * matrix[1] + 2;
  float element;

  for (int index = 2; index < length; index += 1) {
    element = matrix[index];

    matrix[index] = 1.0 / (element * element + 1.0);
  }
}

static void bent_identity_function(float *matrix) {
  int   length = matrix[0] * matrix[1] + 2;
  float element;

  for (int index = 2; index < length; index += 1) {
    element = matrix[index];

    matrix[index] = (sqrt(element * element + 1.0) - 1.0) / 2.0 + element;
  }
}

static void bent_identity_derivative(float *matrix) {
  int   length = matrix[0] * matrix[1] + 2;
  float element;

  for (int index = 2; index < length; index += 1) {
    element = matrix[index];

    matrix[index] = element / (2.0 * sqrt(element * element + 1.0)) + 1.0;
  }
}

static void gaussian_function(float *matrix) {
  int   length = matrix[0] * matrix[1] + 2;
  float element;

  for (int index = 2; index < length; index += 1) {
    element = matrix[index];

    matrix[index] = exp(-element * element);
  }
}

static void gaussian_derivative(float *matrix) {
  int   length = matrix[0] * matrix[1] + 2;
  float element;

  for (int index = 2; index < length; index += 1) {
    element = matrix[index];

    matrix[index] = -2.0 * element * exp(-element * element);
  }
}

static void identity_function(float *matrix) {
  // Nothing to do here :)
}

static void identity_derivative(float *matrix) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    matrix[index] = 1.0;
  }
}

static void logistic_function(float *matrix) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    if      (matrix[index] >  709) matrix[index] = 1.0;
    else if (matrix[index] < -709) matrix[index] = 0.0;
    else                           matrix[index] = 1.0 / (1.0 + exp(-matrix[index]));
  }
}

static void logistic_derivative(float *matrix) {
  int   length = matrix[0] * matrix[1] + 2;
  float element;

  for (int index = 2; index < length; index += 1) {
    if      (matrix[index] >  709) element = 1.0;
    else if (matrix[index] < -709) element = 0.0;
    else                           element = 1.0 / (1.0 + exp(matrix[index]));

    matrix[index] = element * (1.0 - element);
  }
}

static void relu_function(float *matrix) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    if (matrix[index] <  0) matrix[index] = 0.0;
  }
}

static void relu_derivative(float *matrix) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    if (matrix[index] <  0) matrix[index] = 0.0;
    else                    matrix[index] = 1.0;
  }
}

static void sinc_function(float *matrix) {
  int   length = matrix[0] * matrix[1] + 2;
  float element;

  for (int index = 2; index < length; index += 1) {
    element = matrix[index];

    if (element == 0.0) matrix[index] = 1.0;
    else                matrix[index] = sin(element) / element;
  }
}

static void sinc_derivative(float *matrix) {
  int   length = matrix[0] * matrix[1] + 2;
  float element;

  for (int index = 2; index < length; index += 1) {
    element = matrix[index];

    if (element != 0.0)
      matrix[index] = cos(element) / element - sin(element) / (element * element);
  }
}

static void sinusoid_function(float *matrix) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    matrix[index] = sin(matrix[index]);
  }
}

static void sinusoid_derivative(float *matrix) {
  int length = matrix[0] * matrix[1] + 2;

  for (int index = 2; index < length; index += 1) {
    matrix[index] = cos(matrix[index]);
  }
}

//-----------------------------------------------------------------------------
// Public API
//-----------------------------------------------------------------------------

static ActivityFunction
activity_determine_function(int function_id, float alpha) {
  switch (function_id) {
    case  0: return arctan_function;
    case  1: return bent_identity_function;
    case  2: return gaussian_function;
    case  3: return identity_function;
    case  4: return logistic_function;
    case  5: return relu_function;
    case  6: return sinc_function;
    case  7: return sinusoid_function;
    // case  8: return softmax_function;
    // case  9: return softplus_function;
    // case 10: return softsign_function;
    // case 11: return tanh_function;
    // case 12: return elu_function(alpha);
    // case 13: return prelu_function(alpha);
    default: return NULL;
  }
}

static ActivityFunction
activity_determine_derivative(int function_id, float alpha) {
  switch (function_id) {
    case  0: return arctan_derivative;
    case  1: return bent_identity_derivative;
    case  2: return gaussian_derivative;
    case  3: return identity_derivative;
    case  4: return logistic_derivative;
    case  5: return relu_derivative;
    case  6: return sinc_derivative;
    case  7: return sinusoid_derivative;
    // case  8: return softmax_derivative;
    // case  9: return softplus_derivative;
    // case 10: return softsign_derivative;
    // case 11: return tanh_derivative;
    // case 12: return elu_derivative(alpha);
    // case 13: return prelu_derivative(alpha);
    default: return NULL;
  }
}
