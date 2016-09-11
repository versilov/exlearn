#include "../../../native/lib/neural_network/objective.c"
#include "../../../native/lib/matrix.c"

static void test_an_unknown_objective_function() {
  ObjectiveFunction function = objective_determine_function(-1);

  assert(function == NULL);
}

static void test_the_cross_entropy_objective_function() {
  float first[5]  = {1, 3, 0.2, 0.2, 0.6};
  float second[5] = {1, 3, 0.4, 0.5, 0.6};

  ObjectiveFunction function = objective_determine_function(0);

  assert(function(first, second) == 1.9580775499343872);
}

static void test_the_negative_log_likelihood_objective_function() {
  float first[5]  = {1, 3, 1,   0,   0  };
  float second[5] = {1, 3, 0.6, 0.3, 0.1};

  ObjectiveFunction function = objective_determine_function(1);

  assert(function(first, second) == 0.5108255743980408);
}

static void test_the_quadratic_objective_function() {
  float first[5]  = {1, 3, 1, 2, 3};
  float second[5] = {1, 3, 1, 2, 7};

  ObjectiveFunction function = objective_determine_function(2);

  assert(function(first, second) == 8);
}

static void test_an_unknown_objective_error_simple() {
  ObjectiveError function = objective_determine_error_simple(-1);

  assert(function == NULL);
}

static void test_the_cross_entropy_objective_error_simple() {
  float            expected[5]   = {1, 3, 0.2, 0.2, 0.6};
  float            actual[5]     = {1, 3, 0.4, 0.5, 0.3};
  float            last_input[5] = {1, 3, 1,   2,   3  };
  ActivityClosure *derivative    = activity_determine_derivative(3, 0);
  ObjectiveError   error         = objective_determine_error_simple(0);
  Matrix           result;

  result = error(expected, actual, last_input, derivative);

  assert(result[0] ==  1);
  assert(result[1] ==  3);
  assert(result[2] ==  0.83333337306976318);
  assert(result[3] ==  1.20000004768371582);
  assert(result[4] == -1.42857146263122558);

  free_activity_closure(derivative);
}

static void test_the_negative_log_likelihood_objective_error_simple() {
  float            expected[5]   = {1, 3, 1,   0,   0  };
  float            actual[5]     = {1, 3, 0.6, 0.3, 0.1};
  float            last_input[5] = {1, 3, 2,   3,   4  };
  ActivityClosure *derivative    = activity_determine_derivative(3, 0);
  ObjectiveError   error         = objective_determine_error_simple(1);
  Matrix           result;

  result = error(expected, actual, last_input, derivative);

  assert(result[0] ==  1);
  assert(result[1] ==  3);
  assert(result[2] == -0.3999999761581421 );
  assert(result[3] ==  0.30000001192092896);
  assert(result[4] ==  0.10000000149011612);

  free_activity_closure(derivative);
}

static void test_an_unknown_objective_error_optimised() {
  ObjectiveError function = objective_determine_error_optimised(-1);

  assert(function == NULL);
}

static void test_the_cross_entropy_objective_error_optimised() {
  float            expected[5]   = {1, 3, 1,   0,   0  };
  float            actual[5]     = {1, 3, 0.6, 0.3, 0.1};
  float            last_input[5] = {1, 3, 2,   3,   4  };
  ActivityClosure *derivative    = activity_determine_derivative(3, 0);
  ObjectiveError   error         = objective_determine_error_optimised(1);
  Matrix           result;

  result = error(expected, actual, last_input, derivative);

  assert(result[0] ==  1);
  assert(result[1] ==  3);
  assert(result[2] == -0.3999999761581421 );
  assert(result[3] ==  0.30000001192092896);
  assert(result[4] ==  0.10000000149011612);

  free_activity_closure(derivative);
}

static void test_the_negative_log_likelihood_objective_error_optimised() {
  float            expected[5]   = {1, 3, 1,   0,   0  };
  float            actual[5]     = {1, 3, 0.6, 0.3, 0.1};
  float            last_input[5] = {1, 3, 2,   3,   4  };
  ActivityClosure *derivative    = activity_determine_derivative(3, 0);
  ObjectiveError   error         = objective_determine_error_optimised(1);
  Matrix           result;

  result = error(expected, actual, last_input, derivative);

  assert(result[0] ==  1);
  assert(result[1] ==  3);
  assert(result[2] == -0.3999999761581421 );
  assert(result[3] ==  0.30000001192092896);
  assert(result[4] ==  0.10000000149011612);

  free_activity_closure(derivative);
}

static void test_the_quadratic_objective_error() {
  float            expected[5]   = {1, 3, 1, 2, 3};
  float            actual[5]     = {1, 3, 1, 2, 7};
  float            last_input[5] = {1, 3, 2, 3, 4};
  ActivityClosure *derivative    = activity_determine_derivative(3, 0);
  Matrix           result;
  ObjectiveError   error;

  error  = objective_determine_error_simple(2);
  result = error(expected, actual, last_input, derivative);

  assert(result[0] == 1);
  assert(result[1] == 3);
  assert(result[2] == 0);
  assert(result[3] == 0);
  assert(result[4] == 4);

  error  = objective_determine_error_optimised(2);
  result = error(expected, actual, last_input, derivative);

  assert(result[0] == 1);
  assert(result[1] == 3);
  assert(result[2] == 0);
  assert(result[3] == 0);
  assert(result[4] == 4);

  free_activity_closure(derivative);
}
