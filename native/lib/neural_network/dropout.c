#ifndef INCLUDE_DROPOUT_C
#define INCLUDE_DROPOUT_C

#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include <math.h>
#include <time.h>

#include "../matrix.c"

static Matrix
create_dropout_mask(int rows, int columns, float probability) {
  Matrix   mask   = new_matrix(rows, columns);
  int      length = rows * columns + 2;
  double   random_number;
  gsl_rng *rng;

  gsl_rng_env_setup();
  rng = gsl_rng_alloc(gsl_rng_default);
  gsl_rng_set(rng, time(NULL));

  for (int index = 2; index < length; index += 1) {
    random_number = gsl_ran_flat(rng, 0.0, 1.0);

    if (random_number < probability) mask[index] = 0;
    else                             mask[index] = 1 / (1 - probability);
  }

  return mask;
}

#endif
