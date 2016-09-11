#ifndef INCLUDE_OBJECTIVE_C
#define INCLUDE_OBJECTIVE_C

#include <math.h>

#include "../matrix.c"
#include "../structs.c"

//-----------------------------------------------------------------------------
// Objective functions
//-----------------------------------------------------------------------------

static float
cross_entropy_function(Matrix expected, Matrix actual) {
  int   length = expected[0] * expected[1] + 2;
  float sum    = 0;
  float first, second, normalised;

  for (int index = 2; index < length; index += 1) {
    first  = expected[index];
    second = actual[index];

    if      (second == 0.0) normalised = 0.0000000000001;
    else if (second == 1.0) normalised = 0.9999999999999;
    else                    normalised = second;

    sum += first * log(normalised) + (1 - first) * log(1 - normalised);
  }

  return -sum;
}

static float
negative_log_likelihood_function(Matrix expected, Matrix actual) {
  float length = expected[0] * expected[1] + 2;
  float sum = 0;

  for (int index = 2; index < length; index += 1) {
    sum += expected[index] * log(actual[index]);
  }

  return -sum;
}

static float
quadratic_function(Matrix expected, Matrix actual) {
  float length = expected[0] * expected[1] + 2;
  float sum    = 0;
  float difference;

  for (int index = 2; index < length; index += 1) {
    difference = expected[index] - actual[index];

    sum += difference * difference;
  }

  return 0.5 * sum;
}

//-----------------------------------------------------------------------------
// API
//-----------------------------------------------------------------------------

static ObjectiveFunction
objective_determine_function(int function_id) {
  switch (function_id) {
    case  0: return cross_entropy_function;
    case  1: return negative_log_likelihood_function;
    case  2: return quadratic_function;
    default: return NULL;
  }
}

// static ObjectiveError
// objective_determine_error_simple(int function_id) {
//   switch (function_id) {
//     case  0: return cross_entropy_error_simple;
//     case  1: return negative_log_likelihood_error_simple;
//     case  2: return quadratic_error_simple;
//     default: return NULL;
//   }
// }

// static ObjectiveError
// objective_determine_error_optimised(int function_id) {
//   switch (function_id) {
//     case  0: return cross_entropy_error_optimised;
//     case  1: return negative_log_likelihood_error_optimised;
//     case  2: return quadratic_error_optimised;
//     default: return NULL;
//   }
// }
#endif
