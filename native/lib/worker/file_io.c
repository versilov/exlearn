#include <stdio.h>
#include <stdlib.h>

typedef struct WorkerData {
  int     count;
  int     first_length, second_length;
  int     step;
  float **first, **second;
} WorkerData;

static void read_worker_data(const char *path, WorkerData *data) {
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
