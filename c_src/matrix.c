#include <cblas.h>
#include "erl_nif.h"

//-----------------------------------------------------------------------------
// Exported nifs
//-----------------------------------------------------------------------------

static ERL_NIF_TERM
add(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ErlNifBinary  first, second;
  ERL_NIF_TERM  result;
  float        *first_data, *second_data, *result_data;
  int           data_size;
  size_t        result_size;

  if (!enif_inspect_binary(env, argv[0], &first )) return enif_make_badarg(env);
  if (!enif_inspect_binary(env, argv[1], &second)) return enif_make_badarg(env);

  first_data  = (float *) first.data;
  second_data = (float *) second.data;
  data_size   = (int) (first_data[0] * first_data[1] + 2);

  result_size = sizeof(float) * data_size;
  result_data = (float *) enif_make_new_binary(env, result_size, &result);

  result_data[0] = first_data[0];
  result_data[1] = first_data[1];

  for (int index = 2; index < data_size; index += 1) {
    result_data[index] = first_data[index] + second_data[index];
  }

  return result;
}

static ERL_NIF_TERM
divide(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ErlNifBinary  first, second;
  ERL_NIF_TERM  result;
  float        *first_data, *second_data, *result_data;
  int           data_size;
  size_t        result_size;

  if (!enif_inspect_binary(env, argv[0], &first )) return enif_make_badarg(env);
  if (!enif_inspect_binary(env, argv[1], &second)) return enif_make_badarg(env);

  first_data  = (float *) first.data;
  second_data = (float *) second.data;
  data_size   = (int) (first_data[0] * first_data[1] + 2);

  result_size = sizeof(float) * data_size;
  result_data = (float *) enif_make_new_binary(env, result_size, &result);

  result_data[0] = first_data[0];
  result_data[1] = first_data[1];

  for (int index = 2; index < data_size; index += 1) {
    result_data[index] = first_data[index] / second_data[index];
  }

  return result;
}

static ERL_NIF_TERM
dot(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ErlNifBinary  first, second;
  ERL_NIF_TERM  result;
  float        *first_data, *second_data, *result_data;
  int           data_size;
  size_t        result_size;

  if (!enif_inspect_binary(env, argv[0], &first )) return enif_make_badarg(env);
  if (!enif_inspect_binary(env, argv[1], &second)) return enif_make_badarg(env);

  first_data  = (float *) first.data;
  second_data = (float *) second.data;
  data_size   = (int) (first_data[0] * second_data[1] + 2);

  result_size = sizeof(float) * data_size;
  result_data = (float *) enif_make_new_binary(env, result_size, &result);

  result_data[0] = first_data[0];
  result_data[1] = second_data[1];

  cblas_sgemm(
    CblasRowMajor,
    CblasNoTrans,
    CblasNoTrans,
    first_data[0],
    second_data[1],
    first_data[1],
    1.0,
    first_data + 2,
    first_data[1],
    second_data + 2,
    second_data[1],
    0.0,
    result_data + 2,
    result_data[1]
  );

  return result;
}

static ERL_NIF_TERM
dot_and_add(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ErlNifBinary  first, second, third;
  ERL_NIF_TERM  result;
  float        *first_data, *second_data, *third_data, *result_data;
  int           data_size;
  size_t        result_size;

  if (!enif_inspect_binary(env, argv[0], &first )) return enif_make_badarg(env);
  if (!enif_inspect_binary(env, argv[1], &second)) return enif_make_badarg(env);
  if (!enif_inspect_binary(env, argv[2], &third )) return enif_make_badarg(env);

  first_data  = (float *) first.data;
  second_data = (float *) second.data;
  third_data  = (float *) third.data;
  data_size   = (int) (first_data[0] * second_data[1] + 2);

  result_size = sizeof(float) * data_size;
  result_data = (float *) enif_make_new_binary(env, result_size, &result);

  result_data[0] = first_data[0];
  result_data[1] = second_data[1];

  cblas_sgemm(
    CblasRowMajor,
    CblasNoTrans,
    CblasNoTrans,
    first_data[0],
    second_data[1],
    first_data[1],
    1.0,
    first_data + 2,
    first_data[1],
    second_data + 2,
    second_data[1],
    0.0,
    result_data + 2,
    result_data[1]
  );

  for(int index = 2; index < data_size; index += 1) {
    result_data[index] += third_data[index];
  }

  return result;
}

static ERL_NIF_TERM
dot_nt(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ErlNifBinary  first, second;
  ERL_NIF_TERM  result;
  float        *first_data, *second_data, *result_data;
  int           data_size;
  size_t        result_size;

  if (!enif_inspect_binary(env, argv[0], &first )) return enif_make_badarg(env);
  if (!enif_inspect_binary(env, argv[1], &second)) return enif_make_badarg(env);

  first_data  = (float *) first.data;
  second_data = (float *) second.data;
  data_size   = (int) (first_data[0] * second_data[0] + 2);

  result_size = sizeof(float) * data_size;
  result_data = (float *) enif_make_new_binary(env, result_size, &result);

  result_data[0] = first_data[0];
  result_data[1] = second_data[0];

  cblas_sgemm(
    CblasRowMajor,
    CblasNoTrans,
    CblasTrans,
    first_data[0],
    second_data[0],
    first_data[1],
    1.0,
    first_data + 2,
    first_data[1],
    second_data + 2,
    second_data[1],
    0.0,
    result_data + 2,
    result_data[1]
  );

  return result;
}

static ERL_NIF_TERM
dot_tn(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ErlNifBinary  first, second;
  ERL_NIF_TERM  result;
  float        *first_data, *second_data, *result_data;
  int           data_size;
  size_t        result_size;

  if (!enif_inspect_binary(env, argv[0], &first )) return enif_make_badarg(env);
  if (!enif_inspect_binary(env, argv[1], &second)) return enif_make_badarg(env);

  first_data  = (float *) first.data;
  second_data = (float *) second.data;
  data_size   = (int) (first_data[1] * second_data[1] + 2);

  result_size = sizeof(float) * data_size;
  result_data = (float *) enif_make_new_binary(env, result_size, &result);

  result_data[0] = first_data[1];
  result_data[1] = second_data[1];

  cblas_sgemm(
    CblasRowMajor,
    CblasTrans,
    CblasNoTrans,
    first_data[1],
    second_data[1],
    first_data[0],
    1.0,
    first_data + 2,
    first_data[1],
    second_data + 2,
    second_data[1],
    0.0,
    result_data + 2,
    result_data[1]
  );

  return result;
}

static ERL_NIF_TERM
multiply(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ErlNifBinary  first, second;
  ERL_NIF_TERM  result;
  float        *first_data, *second_data, *result_data;
  int           data_size;
  size_t        result_size;

  if (!enif_inspect_binary(env, argv[0], &first )) return enif_make_badarg(env);
  if (!enif_inspect_binary(env, argv[1], &second)) return enif_make_badarg(env);

  first_data  = (float *) first.data;
  second_data = (float *) second.data;
  data_size   = (int) (first_data[0] * first_data[1] + 2);

  result_size = sizeof(float) * data_size;
  result_data = (float *) enif_make_new_binary(env, result_size, &result);

  result_data[0] = first_data[0];
  result_data[1] = first_data[1];

  for (int index = 2; index < data_size; index += 1) {
    result_data[index] = first_data[index] * second_data[index];
  }

  return result;
}

static ERL_NIF_TERM
multiply_with_scalar(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ErlNifBinary  matrix;
  ERL_NIF_TERM  result;
  double        large_scalar;
  float         scalar;
  float        *matrix_data, *result_data;
  int           data_size;
  size_t        result_size;

  if (!enif_inspect_binary(env, argv[0], &matrix)) return enif_make_badarg(env);
  if (enif_get_double(env, argv[1], &large_scalar) == 0) {
    long long_element;
    enif_get_int64(env, argv[1], &long_element);

    large_scalar = (double) long_element;
  }
  scalar = (float) large_scalar;

  matrix_data = (float *) matrix.data;
  data_size   = (int) (matrix_data[0] * matrix_data[1] + 2);

  result_size = sizeof(float) * data_size;
  result_data = (float *) enif_make_new_binary(env, result_size, &result);

  result_data[0] = matrix_data[0];
  result_data[1] = matrix_data[1];

  for (int index = 2; index < data_size; index += 1) {
    result_data[index] = matrix_data[index] * scalar;
  }

  return result;
}

static ERL_NIF_TERM
transpose(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ErlNifBinary  matrix;
  ERL_NIF_TERM  result;
  float        *matrix_data, *result_data;
  int           data_size;
  size_t        result_size;

  if (!enif_inspect_binary(env, argv[0], &matrix)) return enif_make_badarg(env);

  matrix_data = (float *) matrix.data;
  data_size   = (int) (matrix_data[0] * matrix_data[1] + 2);

  result_size = sizeof(float) * data_size;
  result_data = (float *) enif_make_new_binary(env, result_size, &result);

  result_data[0] = matrix_data[1];
  result_data[1] = matrix_data[0];

  for (int row = 0; row < matrix_data[0]; row += 1) {
    for (int column = 0; column < matrix_data[1]; column += 1) {
      int result_index = column * result_data[1] + row    + 2;
      int matrix_index = row *    matrix_data[1] + column + 2;

      result_data[result_index] = matrix_data[matrix_index];
    }
  }

  return result;
}

static ERL_NIF_TERM
substract(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ErlNifBinary  first, second;
  ERL_NIF_TERM  result;
  float        *first_data, *second_data, *result_data;
  int           data_size;
  size_t        result_size;

  if (!enif_inspect_binary(env, argv[0], &first )) return enif_make_badarg(env);
  if (!enif_inspect_binary(env, argv[1], &second)) return enif_make_badarg(env);

  first_data  = (float *) first.data;
  second_data = (float *) second.data;
  data_size   = (int) (first_data[0] * first_data[1] + 2);

  result_size = sizeof(float) * data_size;
  result_data = (float *) enif_make_new_binary(env, result_size, &result);

  result_data[0] = first_data[0];
  result_data[1] = first_data[1];

  for (int index = 2; index < data_size; index += 1) {
    result_data[index] = first_data[index] - second_data[index];
  }

  return result;
}

static ERL_NIF_TERM
sum(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ErlNifBinary  matrix;
  float         sum;
  float        *matrix_data;
  int           data_size;

  if (!enif_inspect_binary(env, argv[0], &matrix)) return enif_make_badarg(env);

  matrix_data = (float *) matrix.data;
  data_size   = matrix_data[0] * matrix_data[1] + 2;
  sum         = 0;

  for (int index = 2; index < data_size; index += 1) {
    sum += matrix_data[index];
  }

  return enif_make_double(env, sum);
}

static ErlNifFunc nif_functions[] = {
  {"add",                  2, add                 },
  {"divide",               2, divide              },
  {"dot",                  2, dot                 },
  {"dot_and_add",          3, dot_and_add         },
  {"dot_nt",               2, dot_nt              },
  {"dot_tn",               2, dot_tn              },
  {"multiply",             2, multiply            },
  {"multiply_with_scalar", 2, multiply_with_scalar},
  {"transpose",            1, transpose           },
  {"substract",            2, substract           },
  {"sum",                  1, sum                 }
};

ERL_NIF_INIT(Elixir.ExLearn.Matrix, nif_functions, NULL, NULL, NULL, NULL)
