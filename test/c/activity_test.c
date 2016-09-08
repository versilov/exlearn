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

//-----------------------------------------------------------------------------
// Run Tests
//-----------------------------------------------------------------------------

int main() {
  test_an_unknown_pair();
  test_the_arctan_pair();
  test_the_bent_identity_pair();
  test_the_gaussian_pair();
  test_the_identity_pair();

  return 0;
}
