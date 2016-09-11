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
