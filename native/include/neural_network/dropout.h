#ifndef INCLUDED_DROPOUT_H
#define INCLUDED_DROPOUT_H

#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>

#include <math.h>
#include <stdint.h>
#include <time.h>

#include "../matrix.h"

Matrix
create_dropout_mask(int32_t rows, int32_t columns, float probability);

#endif
