#ifndef INCLUDE_WORKER_DATA_C
#define INCLUDE_WORKER_DATA_C

#include <stdio.h>
#include <stdlib.h>

typedef struct WorkerData {
  int     count;
  int     first_length, second_length;
  int     step;
  float **first, **second;
} WorkerData;

static void
free_worker_data(WorkerData *data) {
  int index;

  for(index = 0; index < data->count; index += 1) {
    free(data->first[index] );
    free(data->second[index]);
  }

  free(data->first);
  free(data->second);

  free(data);
}

static WorkerData *
new_worker_data() {
  WorkerData *data = malloc(sizeof(WorkerData));

  data->count         = 0;
  data->first_length  = 0;
  data->second_length = 0;
  data->step          = 0;
  data->first         = NULL;
  data->second        = NULL;

  return data;
}

// File format:
//   one           :: float-little-32
//   version       :: float-little-32
//   count         :: float-little-32
//   first_length  :: float-little-32
//   second_length :: float-little-32
//   maximum_step  :: float-little-32
//   step_type     :: float-little-32
//   data          :: binary
//
// Description:
//   one           :: The value one used for determining endianess.
//   version       :: The format version of the file. Currently it is version 1.
//   count         :: The number of sample pairs in the file.
//   first_length  :: The length of the first sample.
//   second_length :: The length of the second sample.
//   maximum_step  :: The maximum allowed jump between sequences of samples.
//   jump          :: [0|1]
//                     0: Do not discard samples.
//                     1: Discard first (maximum_step - step) samples.
//     Example:
//       Starting with the following hypothetical samples:
//       [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
//
//       Split them in 3 files with a maximum step of 5:
//       [ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9]
//       [ 6,  7,  8,  9, 10, 11, 12, 13, 14, 15]
//       [12, 13, 14, 15, 16, 17, 18, 19, 20]
//
//       To get sequesnces of 3 samples we ignore the first (5-3) = 2 elements
//       from the second and third file.
//
//       First file remains intact:
//       [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
//       And has the following sequences:
//       [0, 1, 2], [1, 2, 3], [2, 3, 4], [3, 4, 5], [4, 5, 6], [5, 6, 7],
//       [6, 7, 8], [7, 8 9]
//
//       Second file loses 6 and 7:
//       [8, 9, 10, 11, 12, 13, 14, 15]
//       And has the following sequesnces:
//       [ 8,  9, 10], [9, 10, 11], [10, 11, 12], [11, 12, 13], [12, 13, 14],
//       [13, 14, 15]
//
//       Third file loses 12 and 13:
//       [14, 15, 16, 17, 18, 19, 20]
//       And has the following sequesnces:
//       [14, 15, 16], [15, 16, 17], [16, 17, 18], [17, 18, 19], [18, 19, 20]
//
//   data :: A list of samples. A sample is composed of two binaries.
//     For Training:
//       The first binary represents the input matrix.
//       The second binary represents the expected output matrix.
//     For Prediction:
//       The first binary represents an identifier for the input matrix.
//       The second binary represents the input matrix.
static void
read_worker_data(const char *path, WorkerData *data) {
  float  float_buffer;
  float *first_buffer, *second_buffer;
  FILE  *file;

  file = fopen(path, "rb");

  fread(&float_buffer, sizeof(float), 1, file);

  fread(&float_buffer, sizeof(float), 1, file);
  data->count = (int) float_buffer;

  fread(&float_buffer, sizeof(float), 1, file);
  data->first_length = (int) float_buffer;

  fread(&float_buffer, sizeof(float), 1, file);
  data->second_length = (int) float_buffer;

  fread(&float_buffer, sizeof(float), 1, file);
  data->step = (int) float_buffer;

  data->first  = malloc(sizeof(float *) * data->count);
  data->second = malloc(sizeof(float *) * data->count);

  for(int index = 0; index < data->count; index += 1) {
    first_buffer = malloc(sizeof(float) * data->first_length);
    fread(first_buffer, sizeof(float), data->first_length, file);
    data->first[index] = first_buffer;

    second_buffer = malloc(sizeof(float) * data->second_length);
    fread(second_buffer, sizeof(float), data->second_length, file);
    data->second[index] = second_buffer;
  }

  fclose(file);
}

#endif
