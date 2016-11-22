#ifndef INCLUDED_OBJECTIVE_H
#define INCLUDED_OBJECTIVE_H

#include <math.h>
#include <stdint.h>

#include "../matrix.h"
#include "./activity.h"

typedef float  (*ObjectiveFunction)(Matrix, Matrix);

typedef Matrix (*ObjectiveError)(Matrix, Matrix, Matrix, ActivityClosure *);

ObjectiveFunction
objective_determine_function(int32_t function_id);

ObjectiveError
objective_determine_error_simple(int32_t function_id);

ObjectiveError
objective_determine_error_optimised(int32_t function_id);

#endif
