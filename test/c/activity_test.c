#include <assert.h>
#include <stdio.h>

#include "../../native/lib/activity.c"

//-----------------------------------------------------------------------------
// Tests
//-----------------------------------------------------------------------------

static void test_an_unknown_pair() {
  int function_id = -1;

  ActivityFunction function   = activity_determine_function(function_id, 0);
  ActivityFunction derivative = activity_determine_derivative(function_id, 0);

  assert(function   == NULL);
  assert(derivative == NULL);
}

static void test_the_arctan_pair() {
  int function_id = 0;

  ActivityFunction function   = activity_determine_function(function_id, 0);
  ActivityFunction derivative = activity_determine_derivative(function_id, 0);

  float function_input[]   = {1, 1, 10};
  float derivative_input[] = {1, 1, 10};

  float expected_from_function[]   = {1, 1, 1.4711276743037347  };
  float expected_from_derivative[] = {1, 1, 0.009900990099009901};

  function(function_input);
  derivative(derivative_input);

  for (int index = 0; index < 3; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  );
    assert(derivative_input[index] == expected_from_derivative[index]);
  }
}

static void test_the_bent_identity_pair() {
  int function_id = 1;

  ActivityFunction function   = activity_determine_function(function_id, 0);
  ActivityFunction derivative = activity_determine_derivative(function_id, 0);

  float function_input[]   = {1, 1, 10};
  float derivative_input[] = {1, 1, 10};

  float expected_from_function[]   = {1, 1, 14.524937810560445};
  float expected_from_derivative[] = {1, 1, 1.4975185951049945};

  function(function_input);
  derivative(derivative_input);

  for (int index = 0; index < 3; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  );
    assert(derivative_input[index] == expected_from_derivative[index]);
  }
}

static void test_the_gaussian_pair() {
  int function_id = 2;

  ActivityFunction function   = activity_determine_function(function_id, 0);
  ActivityFunction derivative = activity_determine_derivative(function_id, 0);

  float function_input[]   = {1, 1, 10};
  float derivative_input[] = {1, 1, 10};

  float expected_from_function[]   = {1, 1,  3.720075976020836e-44};
  float expected_from_derivative[] = {1, 1, -7.440151952041672e-43};

  function(function_input);
  derivative(derivative_input);

  for (int index = 0; index < 3; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  );
    assert(derivative_input[index] == expected_from_derivative[index]);
  }
}

static void test_the_identity_pair() {
  int function_id = 3;

  ActivityFunction function   = activity_determine_function(function_id, 0);
  ActivityFunction derivative = activity_determine_derivative(function_id, 0);

  float function_input[]   = {1, 1, 10};
  float derivative_input[] = {1, 1, 10};

  float expected_from_function[]   = {1, 1, 10};
  float expected_from_derivative[] = {1, 1, 1 };

  function(function_input);
  derivative(derivative_input);

  for (int index = 0; index < 3; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  );
    assert(derivative_input[index] == expected_from_derivative[index]);
  }
}

static void test_the_logistic_pair() {
  int function_id = 4;

  ActivityFunction function   = activity_determine_function(function_id, 0);
  ActivityFunction derivative = activity_determine_derivative(function_id, 0);

  float function_input[]   = {1, 3, 10, 710, -710};
  float derivative_input[] = {1, 1, 10};

  float expected_from_function[]   = {1, 3, 0.9999546021312976, 1.0, 0.0};
  float expected_from_derivative[] = {1, 1, 4.5395805e-5};

  function(function_input);
  derivative(derivative_input);

  for (int index = 0; index < 5; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  );
  }

  for (int index = 0; index < 3; index += 1) {
    assert(derivative_input[index] == expected_from_derivative[index]);
  }
}

static void test_the_relu_pair() {
  int function_id = 5;

  ActivityFunction function   = activity_determine_function(function_id, 0);
  ActivityFunction derivative = activity_determine_derivative(function_id, 0);

  float function_input[]   = {1, 3, -2, 0, 2};
  float derivative_input[] = {1, 3, -2, 0, 2};

  float expected_from_function[]   = {1, 3, 0, 0, 2};
  float expected_from_derivative[] = {1, 3, 0, 1, 1};

  function(function_input);
  derivative(derivative_input);

  for (int index = 0; index < 5; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  );
    assert(derivative_input[index] == expected_from_derivative[index]);
  }
}

static void test_the_sinc_pair() {
  int function_id = 6;

  ActivityFunction function   = activity_determine_function(function_id, 0);
  ActivityFunction derivative = activity_determine_derivative(function_id, 0);

  float function_input[]   = {1, 2, 0, 1};
  float derivative_input[] = {1, 2, 0, 1};

  float expected_from_function[]   = {1, 2, 1,  0.8414709848078965 };
  float expected_from_derivative[] = {1, 2, 0, -0.30116867893975674};

  function(function_input);
  derivative(derivative_input);

  for (int index = 0; index < 4; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  );
    assert(derivative_input[index] == expected_from_derivative[index]);
  }
}

static void test_the_sinusoid_pair() {
  int function_id = 7;

  ActivityFunction function   = activity_determine_function(function_id, 0);
  ActivityFunction derivative = activity_determine_derivative(function_id, 0);

  float function_input[]   = {1, 1, 0};
  float derivative_input[] = {1, 1, 0};

  float expected_from_function[]   = {1, 1, 0};
  float expected_from_derivative[] = {1, 1, 1};

  function(function_input);
  derivative(derivative_input);

  for (int index = 0; index < 3; index += 1) {
    assert(function_input[index]   == expected_from_function[index]  );
    assert(derivative_input[index] == expected_from_derivative[index]);
  }
}

//-----------------------------------------------------------------------------
// Run Tests
//-----------------------------------------------------------------------------

int main() {
  test_an_unknown_pair();
  test_the_arctan_pair();
  test_the_bent_identity_pair();
  test_the_gaussian_pair();
  test_the_identity_pair();
  test_the_logistic_pair();
  test_the_relu_pair();
  test_the_sinc_pair();
  test_the_sinusoid_pair();

  return 0;
}
