#include "../../include/neural_network/dropout.h"

Matrix
create_dropout_mask(int32_t rows, int32_t columns, float probability) {
  Matrix   mask   = matrix_new(rows, columns);
  int32_t  length = rows * columns + 2;
  double   random_number;
  gsl_rng *rng;

  gsl_rng_env_setup();
  rng = gsl_rng_alloc(gsl_rng_default);
  gsl_rng_set(rng, time(NULL));

  for (int32_t index = 2; index < length; index += 1) {
    random_number = gsl_ran_flat(rng, 0.0, 1.0);

    if (random_number < probability) mask[index] = 0;
    else                             mask[index] = 1 / (1 - probability);
  }

  return mask;
}
