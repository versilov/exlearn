#include "erl_nif.h"

typedef struct Matrix {
  int     rows;
  int     columns;
  double *data;
} Matrix;

static Matrix *
list_of_lists_to_matrix(ErlNifEnv *env, ERL_NIF_TERM list_of_lists) {
  int           row    = 0;
  int           column = 0;
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
      enif_get_double(env, row_head, &element);
      matrix->data[row * matrix->rows + column] = element;

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
      result = enif_make_list(env, row, result);
      row    = enif_make_list(env, 0);
    }
  }

  return result;
}

static Matrix *
matrix_dot(Matrix *first, Matrix *second) {
  double  sum;
  Matrix *result  = malloc(sizeof(Matrix));
  result->rows    = first->rows;
  result->columns = second->columns;
  result->data    = malloc(sizeof(double) * result->rows * result->columns);

  for (int first_row = 0; first_row < first->rows; first += 1) {
    for (int second_column = 0; second_column < second->columns; second += 1) {
      sum = 0.0;

      for (int common = 0; common < first->columns; common += 1) {
        int first_index  = first_row *  first->rows + common;
        int second_index = common    * second->rows + second_column;

        sum += first->data[first_index] * second->data[second_index];
      }

      result->data[first_row * result->rows + second_column] = sum;
    }
  }
}

static ERL_NIF_TERM
dot(ErlNifEnv *env, int argc, const ERL_NIF_TERM *argv) {
  Matrix *first, *second, *result;

  first  = list_of_lists_to_matrix(env, argv[0]);
  second = list_of_lists_to_matrix(env, argv[1]);

  result = matrix_dot(first, second);

  return matrix_to_list_of_lists(env, result);
}

static ErlNifFunc nif_functions[] = {
  {"dot2", 2, dot}
};

ERL_NIF_INIT(Elixir.ExLearn.Matrix, nif_functions, NULL, NULL, NULL, NULL)
