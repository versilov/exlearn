#include "../../../native/include/neural_network/activation_closure.h"

static void test_activation_closure_free() {
  ActivationClosure *closure = activation_closure_new(NULL, 1, 0);

  activation_closure_free(&closure);
}
static void test_activation_closure_new() {
  ActivationClosure *closure = activation_closure_new(NULL, 1, 0);

  assert(closure->function    == NULL); /* LCOV_EXCL_BR_LINE */
  assert(closure->function_id == 1   ); /* LCOV_EXCL_BR_LINE */
  assert(closure->alpha       == 0   ); /* LCOV_EXCL_BR_LINE */

  activation_closure_free(&closure);
}

static void test_an_unknown_pair() {
  int32_t function_id = -1;

  ActivationClosure *function   = activation_determine_function(function_id, 0);
  ActivationClosure *derivative = activation_determine_derivative(function_id, 0);

  assert(function   == NULL); /* LCOV_EXCL_BR_LINE */
  assert(derivative == NULL); /* LCOV_EXCL_BR_LINE */
}

static void test_the_arctan_pair() {
  int32_t function_id = 0;

  ActivationClosure *function   = activation_determine_function(function_id, 0);
  ActivationClosure *derivative = activation_determine_derivative(function_id, 0);

  float function_input[]   = {1, 1, 10};
  float derivative_input[] = {1, 1, 10};

  float expected_from_function[]   = {1, 1, 1.4711276743037347  };
  float expected_from_derivative[] = {1, 1, 0.009900990099009901};

  activation_closure_call(function,   function_input  );
  activation_closure_call(derivative, derivative_input);

  for (int32_t index = 0; index < 3; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  ); /* LCOV_EXCL_BR_LINE */
    assert(derivative_input[index] == expected_from_derivative[index]); /* LCOV_EXCL_BR_LINE */
  }

  activation_closure_free(&function);
  activation_closure_free(&derivative);
}

static void test_the_bent_identity_pair() {
  int32_t function_id = 1;

  ActivationClosure *function   = activation_determine_function(function_id, 0);
  ActivationClosure *derivative = activation_determine_derivative(function_id, 0);

  float function_input[]   = {1, 1, 10};
  float derivative_input[] = {1, 1, 10};

  float expected_from_function[]   = {1, 1, 14.524937810560445};
  float expected_from_derivative[] = {1, 1, 1.4975185951049945};

  activation_closure_call(function,   function_input  );
  activation_closure_call(derivative, derivative_input);

  for (int32_t index = 0; index < 3; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  ); /* LCOV_EXCL_BR_LINE */
    assert(derivative_input[index] == expected_from_derivative[index]); /* LCOV_EXCL_BR_LINE */
  }

  activation_closure_free(&function);
  activation_closure_free(&derivative);
}

static void test_the_gaussian_pair() {
  int32_t function_id = 2;

  ActivationClosure *function   = activation_determine_function(function_id, 0);
  ActivationClosure *derivative = activation_determine_derivative(function_id, 0);

  float function_input[]   = {1, 1, 10};
  float derivative_input[] = {1, 1, 10};

  float expected_from_function[]   = {1, 1,  3.720075976020836e-44};
  float expected_from_derivative[] = {1, 1, -7.440151952041672e-43};

  activation_closure_call(function,   function_input  );
  activation_closure_call(derivative, derivative_input);

  for (int32_t index = 0; index < 3; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  ); /* LCOV_EXCL_BR_LINE */
    assert(derivative_input[index] == expected_from_derivative[index]); /* LCOV_EXCL_BR_LINE */
  }

  activation_closure_free(&function);
  activation_closure_free(&derivative);
}

static void test_the_identity_pair() {
  int32_t function_id = 3;

  ActivationClosure *function   = activation_determine_function(function_id, 0);
  ActivationClosure *derivative = activation_determine_derivative(function_id, 0);

  float function_input[]   = {1, 1, 10};
  float derivative_input[] = {1, 1, 10};

  float expected_from_function[]   = {1, 1, 10};
  float expected_from_derivative[] = {1, 1, 1 };

  activation_closure_call(function,   function_input  );
  activation_closure_call(derivative, derivative_input);

  for (int32_t index = 0; index < 3; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  ); /* LCOV_EXCL_BR_LINE */
    assert(derivative_input[index] == expected_from_derivative[index]); /* LCOV_EXCL_BR_LINE */
  }

  activation_closure_free(&function);
  activation_closure_free(&derivative);
}

static void test_the_logistic_pair() {
  int32_t function_id = 4;

  ActivationClosure *function   = activation_determine_function(function_id, 0);
  ActivationClosure *derivative = activation_determine_derivative(function_id, 0);

  float function_input[]   = {1, 3, 10, 710, -710};
  float derivative_input[] = {1, 1, 10};

  float expected_from_function[]   = {1, 3, 0.9999546021312976, 1.0, 0.0};
  float expected_from_derivative[] = {1, 1, 4.5395805e-5};

  activation_closure_call(function,   function_input  );
  activation_closure_call(derivative, derivative_input);

  for (int32_t index = 0; index < 5; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  ); /* LCOV_EXCL_BR_LINE */
  }

  for (int32_t index = 0; index < 3; index += 1) {
    assert(derivative_input[index] == expected_from_derivative[index]); /* LCOV_EXCL_BR_LINE */
  }

  activation_closure_free(&function);
  activation_closure_free(&derivative);
}

static void test_the_relu_pair() {
  int32_t function_id = 5;

  ActivationClosure *function   = activation_determine_function(function_id, 0);
  ActivationClosure *derivative = activation_determine_derivative(function_id, 0);

  float function_input[]   = {1, 3, -2, 0, 2};
  float derivative_input[] = {1, 3, -2, 0, 2};

  float expected_from_function[]   = {1, 3, 0, 0, 2};
  float expected_from_derivative[] = {1, 3, 0, 1, 1};

  activation_closure_call(function,   function_input  );
  activation_closure_call(derivative, derivative_input);

  for (int32_t index = 0; index < 5; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  ); /* LCOV_EXCL_BR_LINE */
    assert(derivative_input[index] == expected_from_derivative[index]); /* LCOV_EXCL_BR_LINE */
  }

  activation_closure_free(&function);
  activation_closure_free(&derivative);
}

static void test_the_sinc_pair() {
  int32_t function_id = 6;

  ActivationClosure *function   = activation_determine_function(function_id, 0);
  ActivationClosure *derivative = activation_determine_derivative(function_id, 0);

  float function_input[]   = {1, 2, 0, 1};
  float derivative_input[] = {1, 2, 0, 1};

  float expected_from_function[]   = {1, 2, 1,  0.8414709848078965 };
  float expected_from_derivative[] = {1, 2, 0, -0.30116867893975674};

  activation_closure_call(function,   function_input  );
  activation_closure_call(derivative, derivative_input);

  for (int32_t index = 0; index < 4; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  ); /* LCOV_EXCL_BR_LINE */
    assert(derivative_input[index] == expected_from_derivative[index]); /* LCOV_EXCL_BR_LINE */
  }

  activation_closure_free(&function);
  activation_closure_free(&derivative);
}

static void test_the_sinusoid_pair() {
  int32_t function_id = 7;

  ActivationClosure *function   = activation_determine_function(function_id, 0);
  ActivationClosure *derivative = activation_determine_derivative(function_id, 0);

  float function_input[]   = {1, 1, 0};
  float derivative_input[] = {1, 1, 0};

  float expected_from_function[]   = {1, 1, 0};
  float expected_from_derivative[] = {1, 1, 1};

  activation_closure_call(function,   function_input  );
  activation_closure_call(derivative, derivative_input);

  for (int32_t index = 0; index < 3; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  ); /* LCOV_EXCL_BR_LINE */
    assert(derivative_input[index] == expected_from_derivative[index]); /* LCOV_EXCL_BR_LINE */
  }

  activation_closure_free(&function);
  activation_closure_free(&derivative);
}

static void test_the_softmax_pair() {
  int32_t function_id = 8;

  ActivationClosure *function   = activation_determine_function(function_id, 0);
  ActivationClosure *derivative = activation_determine_derivative(function_id, 0);

  float function_input[]   = {1, 4, -1.5, 0.2, 0.3, 3};
  float derivative_input[] = {1, 4, -1.5, 0.2, 0.3, 3};

  float expected_from_function[] = {1, 4,
    0.00975222233682, 0.0533831529319, 0.0589975044131, 0.8778670674060531
  };
  float expected_from_derivative[] = {1, 4,
    1.5, -0.20000001788139343, -0.30000001192092896, -3.0
  };

  activation_closure_call(function,   function_input  );
  activation_closure_call(derivative, derivative_input);

  for (int32_t index = 0; index < 6; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  ); /* LCOV_EXCL_BR_LINE */
    assert(derivative_input[index] == expected_from_derivative[index]); /* LCOV_EXCL_BR_LINE */
  }

  activation_closure_free(&function);
  activation_closure_free(&derivative);
}

static void test_the_softplus_pair() {
  int32_t function_id = 9;

  ActivationClosure *function   = activation_determine_function(function_id, 0);
  ActivationClosure *derivative = activation_determine_derivative(function_id, 0);

  float function_input[]   = {1, 1, 10};
  float derivative_input[] = {1, 1, 10};

  float expected_from_function[]   = {1, 1, 10.000045398899218};
  float expected_from_derivative[] = {1, 1, 0.9999546021312976};

  activation_closure_call(function,   function_input  );
  activation_closure_call(derivative, derivative_input);

  for (int32_t index = 0; index < 3; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  ); /* LCOV_EXCL_BR_LINE */
    assert(derivative_input[index] == expected_from_derivative[index]); /* LCOV_EXCL_BR_LINE */
  }

  activation_closure_free(&function);
  activation_closure_free(&derivative);
}

static void test_the_softsign_pair() {
  int32_t function_id = 10;

  ActivationClosure *function   = activation_determine_function(function_id, 0);
  ActivationClosure *derivative = activation_determine_derivative(function_id, 0);

  float function_input[]   = {1, 1, 10};
  float derivative_input[] = {1, 1, 10};

  float expected_from_function[]   = {1, 1, 0.9090909361};
  float expected_from_derivative[] = {1, 1, 0.0082644628};

  activation_closure_call(function,   function_input  );
  activation_closure_call(derivative, derivative_input);

  for (int32_t index = 0; index < 3; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  ); /* LCOV_EXCL_BR_LINE */
    assert(derivative_input[index] == expected_from_derivative[index]); /* LCOV_EXCL_BR_LINE */
  }

  activation_closure_free(&function);
  activation_closure_free(&derivative);
}

static void test_the_tanh_pair() {
  int32_t function_id = 11;

  ActivationClosure *function   = activation_determine_function(function_id, 0);
  ActivationClosure *derivative = activation_determine_derivative(function_id, 0);

  float function_input[]   = {1, 1, 10};
  float derivative_input[] = {1, 1, 10};

  float expected_from_function[]   = {1, 1, 0.99999999};
  float expected_from_derivative[] = {1, 1, 0};

  activation_closure_call(function,   function_input  );
  activation_closure_call(derivative, derivative_input);

  for (int32_t index = 0; index < 3; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  ); /* LCOV_EXCL_BR_LINE */
    assert(derivative_input[index] == expected_from_derivative[index]); /* LCOV_EXCL_BR_LINE */
  }

  activation_closure_free(&function);
  activation_closure_free(&derivative);
}

static void test_the_elu_pair() {
  int32_t function_id = 12;
  int32_t alpha       = 10;

  ActivationClosure *function   = activation_determine_function(function_id, alpha);
  ActivationClosure *derivative = activation_determine_derivative(function_id, alpha);

  float function_input[]   = {1, 3, -2, 0, 2};
  float derivative_input[] = {1, 3, -2, 0, 2};

  float expected_from_function[]   = {1, 3, -8.6466471676, 0, 2};
  float expected_from_derivative[] = {1, 3,  1.3533528323, 1, 1};

  activation_closure_call(function,   function_input  );
  activation_closure_call(derivative, derivative_input);

  for (int32_t index = 0; index < 5; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  ); /* LCOV_EXCL_BR_LINE */
    assert(derivative_input[index] == expected_from_derivative[index]); /* LCOV_EXCL_BR_LINE */
  }

  activation_closure_free(&function);
  activation_closure_free(&derivative);
}

static void test_the_prelu_pair() {
  int32_t function_id = 13;
  int32_t alpha       = 10;

  ActivationClosure *function   = activation_determine_function(function_id, alpha);
  ActivationClosure *derivative = activation_determine_derivative(function_id, alpha);

  float function_input[]   = {1, 3, -2, 0, 2};
  float derivative_input[] = {1, 3, -2, 0, 2};

  float expected_from_function[]   = {1, 3, -20, 0, 2};
  float expected_from_derivative[] = {1, 3,  10, 1, 1};

  activation_closure_call(function,   function_input  );
  activation_closure_call(derivative, derivative_input);

  for (int32_t index = 0; index < 5; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  ); /* LCOV_EXCL_BR_LINE */
    assert(derivative_input[index] == expected_from_derivative[index]); /* LCOV_EXCL_BR_LINE */
  }

  activation_closure_free(&function);
  activation_closure_free(&derivative);
}
