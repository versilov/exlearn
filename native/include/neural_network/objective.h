#ifndef INCLUDED_OBJECTIVE_H
#define INCLUDED_OBJECTIVE_H

#include <math.h>

#include "../matrix.h"
#include "./activity.h"

typedef float  (*ObjectiveFunction)(Matrix, Matrix);

typedef Matrix (*ObjectiveError)(Matrix, Matrix, Matrix, ActivityClosure *);

ObjectiveFunction
objective_determine_function(int function_id);

ObjectiveError
objective_determine_error_simple(int function_id);

ObjectiveError
objective_determine_error_optimised(int function_id);

#endif
