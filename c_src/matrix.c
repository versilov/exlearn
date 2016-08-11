#include "erl_nif.h"

typedef struct Matrix {
  unsigned int  rows;
  unsigned int  columns;
  double       *data;
} Matrix;

//-----------------------------------------------------------------------------
// Matrix API
//-----------------------------------------------------------------------------

static void
matrix_add(Matrix *first, Matrix *second) {
  for (int index = 0; index < first->rows * first->columns; index += 1) {
    first->data[index] += second->data[index];
  }
}

static Matrix *
matrix_dot(Matrix *first, Matrix *second) {
  double  sum;
  Matrix *result  = malloc(sizeof(Matrix));
  result->rows    = first->rows;
  result->columns = second->columns;
  result->data    = malloc(sizeof(double) * result->rows * result->columns);

  for (int first_row = 0; first_row < first->rows; first_row += 1) {
    for (int second_column = 0; second_column < second->columns; second_column += 1) {
      sum = 0.0;

      for (int common = 0; common < first->columns; common += 1) {
        int first_index  = first_row *  first->columns + common;
        int second_index = common    * second->columns + second_column;

        double product = first->data[first_index] * second->data[second_index];
        sum += product;
      }

      int index = first_row * result->columns + second_column;
      result->data[index] = sum;
    }
  }

  return result;
}

static Matrix *
matrix_dot_and_add(Matrix *first, Matrix *second, Matrix *third) {
  double  sum;
  Matrix *result  = malloc(sizeof(Matrix));
  result->rows    = first->rows;
  result->columns = second->columns;
  result->data    = malloc(sizeof(double) * result->rows * result->columns);

  for (int first_row = 0; first_row < first->rows; first_row += 1) {
    for (int second_column = 0; second_column < second->columns; second_column += 1) {
      sum = 0.0;

      for (int common = 0; common < first->columns; common += 1) {
        int first_index  = first_row *  first->columns + common;
        int second_index = common    * second->columns + second_column;

        double product = first->data[first_index] * second->data[second_index];
        sum += product;
      }

      int index = first_row * result->columns + second_column;
      result->data[index] = sum + third->data[index];
    }
  }

  return result;
}

static Matrix *
matrix_dot_nt(Matrix *first, Matrix *second) {
  double  sum;
  Matrix *result  = malloc(sizeof(Matrix));
  result->rows    = first->rows;
  result->columns = second->rows;
  result->data    = malloc(sizeof(double) * result->rows * result->columns);

  for (int first_row = 0; first_row < first->rows; first_row += 1) {
    for (int second_row = 0; second_row < second->rows; second_row += 1) {
      sum = 0.0;

      for (int common = 0; common < first->columns; common += 1) {
        int first_index  = first_row  *  first->columns + common;
        int second_index = second_row * second->columns + common;

        double product = first->data[first_index] * second->data[second_index];
        sum += product;
      }

      int index = first_row * result->columns + second_row;
      result->data[index] = sum;
    }
  }

  return result;
}

static Matrix *
matrix_dot_tn(Matrix *first, Matrix *second) {
  double  sum;
  Matrix *result  = malloc(sizeof(Matrix));
  result->rows    = first->columns;
  result->columns = second->columns;
  result->data    = malloc(sizeof(double) * result->rows * result->columns);

  for (int first_column = 0; first_column < first->columns; first_column += 1) {
    for (int second_column = 0; second_column < second->columns; second_column += 1) {
      sum = 0.0;

      for (int common = 0; common < first->rows; common += 1) {
        int first_index  = common *  first->columns + first_column;
        int second_index = common * second->columns + second_column;

        double product = first->data[first_index] * second->data[second_index];
        sum += product;
      }

      int index = first_column * result->columns + second_column;
      result->data[index] = sum;
    }
  }

  return result;
}

static void
matrix_multiply(Matrix *first, Matrix *second) {
  for (int index = 0; index < first->rows * first->columns; index += 1) {
    first->data[index] *= second->data[index];
  }
}

static void
matrix_multiply_with_scalar(Matrix *matrix, double scalar) {
  for (int index = 0; index < matrix->rows * matrix->columns; index += 1) {
    matrix->data[index] *= scalar;
  }
}

static Matrix *
matrix_transpose(Matrix *matrix) {
  Matrix *result  = malloc(sizeof(Matrix));
  result->rows    = matrix->columns;
  result->columns = matrix->rows;
  result->data    = malloc(sizeof(double) * result->rows * result->columns);

  for (int row = 0; row < matrix->rows; row += 1) {
    for (int column = 0; column < matrix->columns; column += 1) {
      result->data[column * result->columns + row] = matrix->data[row * matrix->columns + column];
    }
  }

  return result;
}

static void
matrix_substract(Matrix *first, Matrix *second) {
  for (int index = 0; index < first->rows * first->columns; index += 1) {
    first->data[index] -= second->data[index];
  }
}

//-----------------------------------------------------------------------------
// Utilities
//-----------------------------------------------------------------------------

static Matrix *
list_of_lists_to_matrix(ErlNifEnv *env, ERL_NIF_TERM list_of_lists) {
  unsigned int  row    = 0;
  unsigned int  column = 0;
  double        element;
  Matrix       *matrix = malloc(sizeof(Matrix));
  ERL_NIF_TERM  head, tail, row_head, row_tail;

  enif_get_list_cell(env, list_of_lists, &head, &tail);

  enif_get_list_length(env, list_of_lists, &matrix->rows   );
  enif_get_list_length(env, head,          &matrix->columns);

  matrix->data = malloc(sizeof(double) * matrix->rows * matrix->columns);

  while(1) {
    enif_get_list_cell(env, head, &row_head, &row_tail);

    while(1) {
      if (enif_get_double(env, row_head, &element) == 0) {
        long long_element;
        enif_get_int64(env, row_head, &long_element);

        element = (double) long_element;
      }

      int index = row * matrix->columns + column;
      matrix->data[index] = element;

      if (enif_is_empty_list(env, row_tail) == 1) { break; }
      enif_get_list_cell(env, row_tail, &row_head, &row_tail);

      column += 1;
    }

    if (enif_is_empty_list(env, tail) == 1) { break; }
    enif_get_list_cell(env, tail, &head, &tail);

    row    += 1;
    column  = 0;
  }

  return matrix;
}

static ERL_NIF_TERM
matrix_to_list_of_lists(ErlNifEnv *env, Matrix *matrix) {
  int          column, size;
  ERL_NIF_TERM element, result, row;

  column = 0;
  size   = matrix->rows * matrix->columns;
  result = enif_make_list(env, 0);
  row    = enif_make_list(env, 0);

  for (int index = size - 1; index >= 0; index -= 1) {
    element = enif_make_double(env, matrix->data[index]);
    column += 1;

    row = enif_make_list_cell(env, element, row);

    if (column == matrix->columns) {
      column = 0;
      result = enif_make_list_cell(env, row, result);
      row    = enif_make_list(env, 0);
    }
  }

  return result;
}

static void
free_matrix(Matrix *matrix) {
  free(matrix->data);
  free(matrix);
}

//-----------------------------------------------------------------------------
// Exported nifs
//-----------------------------------------------------------------------------

static ERL_NIF_TERM
add(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ERL_NIF_TERM  result;
  Matrix       *first, *second;

  first  = list_of_lists_to_matrix(env, argv[0]);
  second = list_of_lists_to_matrix(env, argv[1]);

  matrix_add(first, second);

  result = matrix_to_list_of_lists(env, first);

  free_matrix(first);
  free_matrix(second);

  return result;
}

static ERL_NIF_TERM
dot(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ERL_NIF_TERM  result;
  Matrix       *first, *second, *dot_product;

  first       = list_of_lists_to_matrix(env, argv[0]);
  second      = list_of_lists_to_matrix(env, argv[1]);
  dot_product = matrix_dot(first, second);
  result      = matrix_to_list_of_lists(env, dot_product);

  free_matrix(first);
  free_matrix(second);
  free_matrix(dot_product);

  return result;
}

static ERL_NIF_TERM
dot_and_add(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ERL_NIF_TERM  result;
  Matrix       *first, *second, *third, *dot_product;

  first       = list_of_lists_to_matrix(env, argv[0]);
  second      = list_of_lists_to_matrix(env, argv[1]);
  third       = list_of_lists_to_matrix(env, argv[2]);
  dot_product = matrix_dot_and_add(first, second, third);
  result      = matrix_to_list_of_lists(env, dot_product);

  free_matrix(first);
  free_matrix(second);
  free_matrix(third);
  free_matrix(dot_product);

  return result;
}

static ERL_NIF_TERM
dot_nt(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ERL_NIF_TERM  result;
  Matrix       *first, *second, *dot_product;

  first       = list_of_lists_to_matrix(env, argv[0]);
  second      = list_of_lists_to_matrix(env, argv[1]);
  dot_product = matrix_dot_nt(first, second);
  result      = matrix_to_list_of_lists(env, dot_product);

  free_matrix(first);
  free_matrix(second);
  free_matrix(dot_product);

  return result;
}

static ERL_NIF_TERM
dot_tn(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ERL_NIF_TERM  result;
  Matrix       *first, *second, *dot_product;

  first       = list_of_lists_to_matrix(env, argv[0]);
  second      = list_of_lists_to_matrix(env, argv[1]);
  dot_product = matrix_dot_tn(first, second);
  result      = matrix_to_list_of_lists(env, dot_product);

  free_matrix(first);
  free_matrix(second);
  free_matrix(dot_product);

  return result;
}

static ERL_NIF_TERM
multiply(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ERL_NIF_TERM  result;
  Matrix       *first, *second;

  first   = list_of_lists_to_matrix(env, argv[0]);
  second  = list_of_lists_to_matrix(env, argv[1]);

  matrix_multiply(first, second);

  result  = matrix_to_list_of_lists(env, first);

  free_matrix(first);
  free_matrix(second);

  return result;
}

static ERL_NIF_TERM
multiply_with_scalar(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ERL_NIF_TERM  result;
  Matrix       *matrix;
  double        scalar;

  matrix = list_of_lists_to_matrix(env, argv[0]);

  if (enif_get_double(env, argv[1], &scalar) == 0) {
    long long_element;
    enif_get_int64(env, argv[1], &long_element);

    scalar = (double) long_element;
  }

  matrix_multiply_with_scalar(matrix, scalar);
  result = matrix_to_list_of_lists(env, matrix);
  free_matrix(matrix);

  return result;
}

static ERL_NIF_TERM
transpose(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ERL_NIF_TERM  result;
  Matrix       *matrix, *transposed;

  matrix = list_of_lists_to_matrix(env, argv[0]);
  transposed = matrix_transpose(matrix);
  result = matrix_to_list_of_lists(env, transposed);

  free_matrix(matrix);
  free_matrix(transposed);

  return result;
}

static ERL_NIF_TERM
substract(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  ERL_NIF_TERM  result;
  Matrix       *first, *second;

  first  = list_of_lists_to_matrix(env, argv[0]);
  second = list_of_lists_to_matrix(env, argv[1]);

  matrix_substract(first, second);

  result = matrix_to_list_of_lists(env, first);

  free_matrix(first);
  free_matrix(second);

  return result;
}

static ErlNifFunc nif_functions[] = {
  {"add",                  2, add                 },
  {"dot",                  2, dot                 },
  {"dot_and_add",          3, dot_and_add         },
  {"dot_nt",               2, dot_nt              },
  {"dot_tn",               2, dot_tn              },
  {"multiply",             2, multiply            },
  {"multiply_with_scalar", 2, multiply_with_scalar},
  {"transpose",            1, transpose           },
  {"substract",            2, substract           }
};

ERL_NIF_INIT(Elixir.ExLearn.Matrix, nif_functions, NULL, NULL, NULL, NULL)
