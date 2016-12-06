#include "../../include/neural_network/activation_closure.h"

//-----------------------------------------------------------------------------
// Activation function pairs
//-----------------------------------------------------------------------------

static void arctan_function(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;

  for (int32_t index = 2; index < length; index += 1) {
    matrix[index] = atan(matrix[index]);
  }
}

static void arctan_derivative(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;
  float   element;

  for (int32_t index = 2; index < length; index += 1) {
    element = matrix[index];

    matrix[index] = 1.0 / (element * element + 1.0);
  }
}

static void bent_identity_function(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;
  float   element;

  for (int32_t index = 2; index < length; index += 1) {
    element = matrix[index];

    matrix[index] = (sqrt(element * element + 1.0) - 1.0) / 2.0 + element;
  }
}

static void bent_identity_derivative(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;
  float   element;

  for (int32_t index = 2; index < length; index += 1) {
    element = matrix[index];

    matrix[index] = element / (2.0 * sqrt(element * element + 1.0)) + 1.0;
  }
}

static void gaussian_function(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;
  float   element;

  for (int32_t index = 2; index < length; index += 1) {
    element = matrix[index];

    matrix[index] = exp(-element * element);
  }
}

static void gaussian_derivative(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;
  float   element;

  for (int32_t index = 2; index < length; index += 1) {
    element = matrix[index];

    matrix[index] = -2.0 * element * exp(-element * element);
  }
}

static void identity_function(Matrix _matrix, float _alpha) {
  (void)(_matrix);
  (void)(_alpha );

  // Nothing to do here :)
}

static void identity_derivative(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;

  for (int32_t index = 2; index < length; index += 1) {
    matrix[index] = 1.0;
  }
}

static void logistic_function(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;

  for (int32_t index = 2; index < length; index += 1) {
    if      (matrix[index] >  709) matrix[index] = 1.0;
    else if (matrix[index] < -709) matrix[index] = 0.0;
    else                           matrix[index] = 1.0 / (1.0 + exp(-matrix[index]));
  }
}

static void logistic_derivative(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;
  float   element;

  for (int32_t index = 2; index < length; index += 1) {
    if      (matrix[index] >  709) element = 1.0;
    else if (matrix[index] < -709) element = 0.0;
    else                           element = 1.0 / (1.0 + exp(matrix[index]));

    matrix[index] = element * (1.0 - element);
  }
}

static void relu_function(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;

  for (int32_t index = 2; index < length; index += 1) {
    if (matrix[index] <  0) matrix[index] = 0.0;
  }
}

static void relu_derivative(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;

  for (int32_t index = 2; index < length; index += 1) {
    if (matrix[index] <  0) matrix[index] = 0.0;
    else                    matrix[index] = 1.0;
  }
}

static void sinc_function(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;
  float   element;

  for (int32_t index = 2; index < length; index += 1) {
    element = matrix[index];

    if (element == 0.0) matrix[index] = 1.0;
    else                matrix[index] = sin(element) / element;
  }
}

static void sinc_derivative(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;
  float   element;

  for (int32_t index = 2; index < length; index += 1) {
    element = matrix[index];

    if (element != 0.0)
      matrix[index] = cos(element) / element - sin(element) / (element * element);
  }
}

static void sinusoid_function(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;

  for (int32_t index = 2; index < length; index += 1) {
    matrix[index] = sin(matrix[index]);
  }
}

static void sinusoid_derivative(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;

  for (int32_t index = 2; index < length; index += 1) {
    matrix[index] = cos(matrix[index]);
  }
}

static void softmax_function(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length     = matrix[0] * matrix[1] + 2;
  float   maximum    = matrix_max(matrix);
  float   normalizer = 0.0;

  for (int32_t index = 2; index < length; index += 1) {
    normalizer += exp(matrix[index] - maximum);
  }

  for (int32_t index = 2; index < length; index += 1) {
    matrix[index] = exp(matrix[index] - maximum) / normalizer;
  }
}

static void softmax_derivative(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;
  Matrix  temp   = malloc(sizeof(float) * length);
  float   sum;

  for (int32_t first_index = 2; first_index < length; first_index += 1) {
    sum = 0.0;

    for (int32_t second_index = 2; second_index < length; second_index += 1) {
      if (first_index == second_index)
        sum += matrix[first_index] * (1.0 - matrix[second_index]);
      else
        sum += -matrix[first_index] * matrix[second_index];
    }

    temp[first_index] = sum;
  }

  for (int32_t index = 2; index < length; index += 1) {
    matrix[index] = temp[index];
  }

  free(temp);
}

static void softplus_function(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;

  for (int32_t index = 2; index < length; index += 1) {
    matrix[index] = log(1.0 + exp(matrix[index]));
  }
}

static void softplus_derivative(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;

  for (int32_t index = 2; index < length; index += 1) {
    matrix[index] = 1.0 / (1.0 + exp(-matrix[index]));
  }
}

static void softsign_function(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;
  float   element;

  for (int32_t index = 2; index < length; index += 1) {
    element = matrix[index];

    matrix[index] = element / (1.0 + abs(element));
  }
}

static void softsign_derivative(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;
  float   element;

  for (int32_t index = 2; index < length; index += 1) {
    element = 1.0 + abs(matrix[index]);

    matrix[index] = 1.0 / (element * element);
  }
}

static void tanh_function(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;

  for (int32_t index = 2; index < length; index += 1) {
    matrix[index] = tanh(matrix[index]);
  }
}

static void tanh_derivative(Matrix matrix, float _alpha) {
  (void)(_alpha);

  int32_t length = matrix[0] * matrix[1] + 2;
  float   element;

  for (int32_t index = 2; index < length; index += 1) {
    element = tanh(matrix[index]);

    matrix[index] = 1.0 - (element * element);
  }
}

static void elu_function(Matrix matrix, float alpha) {
  int32_t length = matrix[0] * matrix[1] + 2;

  for (int32_t index = 2; index < length; index += 1) {
    if (matrix[index] < 0.0)
      matrix[index] = alpha * (exp(matrix[index]) - 1.0);
  }
}

static void elu_derivative(Matrix matrix, float alpha) {
  int32_t length = matrix[0] * matrix[1] + 2;

  for (int32_t index = 2; index < length; index += 1) {
    if (matrix[index] < 0.0)
      matrix[index] = alpha * exp(matrix[index]);
    else
      matrix[index] = 1.0;
  }
}

static void prelu_function(Matrix matrix, float alpha) {
  int32_t length = matrix[0] * matrix[1] + 2;

  for (int32_t index = 2; index < length; index += 1) {
    if (matrix[index] < 0.0)
      matrix[index] = alpha * matrix[index];
  }
}

static void prelu_derivative(Matrix matrix, float alpha) {
  int32_t length = matrix[0] * matrix[1] + 2;

  for (int32_t index = 2; index < length; index += 1) {
    if (matrix[index] < 0.0)
      matrix[index] = alpha;
    else
      matrix[index] = 1.0;
  }
}

//-----------------------------------------------------------------------------
// API
//-----------------------------------------------------------------------------

void
activation_closure_call(ActivationClosure *closure, Matrix matrix) {
  if (closure != NULL)
    closure->function(matrix, closure->alpha);
}

void
activation_closure_free(ActivationClosure **activity_closure_address) {
  ActivationClosure *activity_closure = *activity_closure_address;

  free(activity_closure);

  *activity_closure_address = NULL;
}

void
activation_closure_inspect(ActivationClosure *activation_closure) {
  printf(
    "<#ActivationClosure function: F, function_id: %d, alpha: %f>\n",
    activation_closure->function_id,
    activation_closure->alpha
  );
}

void
activation_closure_inspect_internal(
  ActivationClosure *activation_closure,
  int32_t            _indentation
) {
  (void)(_indentation);

  printf(
    "<#ActivationClosure function: F, function_id: %d, alpha: %f>",
    activation_closure->function_id,
    activation_closure->alpha
  );
}

ActivationClosure *
activation_closure_new(
  ActivationFunction function,
  int32_t            function_id,
  float              alpha
) {
  ActivationClosure *closure = malloc(sizeof(ActivationClosure));

  closure->function    = function;
  closure->function_id = function_id;
  closure->alpha       = alpha;

  return closure;
}

ActivationClosure *
activation_determine_function(int32_t function_id, float alpha) {
  switch (function_id) {
    case  0:
      return activation_closure_new(arctan_function,        function_id, 0    );
    case  1:
      return activation_closure_new(bent_identity_function, function_id, 0    );
    case  2:
      return activation_closure_new(gaussian_function,      function_id, 0    );
    case  3:
      return activation_closure_new(identity_function,      function_id, 0    );
    case  4:
      return activation_closure_new(logistic_function,      function_id, 0    );
    case  5:
      return activation_closure_new(relu_function,          function_id, 0    );
    case  6:
      return activation_closure_new(sinc_function,          function_id, 0    );
    case  7:
      return activation_closure_new(sinusoid_function,      function_id, 0    );
    case  8:
      return activation_closure_new(softmax_function,       function_id, 0    );
    case  9:
      return activation_closure_new(softplus_function,      function_id, 0    );
    case 10:
      return activation_closure_new(softsign_function,      function_id, 0    );
    case 11:
      return activation_closure_new(tanh_function,          function_id, 0    );
    case 12:
      return activation_closure_new(elu_function,           function_id, alpha);
    case 13:
      return activation_closure_new(prelu_function,         function_id, alpha);
    default:
      return NULL;
  }
}

ActivationClosure *
activation_determine_derivative(int32_t function_id, float alpha) {
  switch (function_id) {
    case  0:
      return activation_closure_new(arctan_derivative,        function_id, 0    );
    case  1:
      return activation_closure_new(bent_identity_derivative, function_id, 0    );
    case  2:
      return activation_closure_new(gaussian_derivative,      function_id, 0    );
    case  3:
      return activation_closure_new(identity_derivative,      function_id, 0    );
    case  4:
      return activation_closure_new(logistic_derivative,      function_id, 0    );
    case  5:
      return activation_closure_new(relu_derivative,          function_id, 0    );
    case  6:
      return activation_closure_new(sinc_derivative,          function_id, 0    );
    case  7:
      return activation_closure_new(sinusoid_derivative,      function_id, 0    );
    case  8:
      return activation_closure_new(softmax_derivative,       function_id, 0    );
    case  9:
      return activation_closure_new(softplus_derivative,      function_id, 0    );
    case 10:
      return activation_closure_new(softsign_derivative,      function_id, 0    );
    case 11:
      return activation_closure_new(tanh_derivative,          function_id, 0    );
    case 12:
      return activation_closure_new(elu_derivative,           function_id, alpha);
    case 13:
      return activation_closure_new(prelu_derivative,         function_id, alpha);
    default:
      return NULL;
  }
}
