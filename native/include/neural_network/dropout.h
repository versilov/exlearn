#ifndef INCLUDED_DROPOUT_H
#define INCLUDED_DROPOUT_H

#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>

#include <math.h>
#include <time.h>

#include "../matrix.h"

Matrix
create_dropout_mask(int rows, int columns, float probability);

#endif
