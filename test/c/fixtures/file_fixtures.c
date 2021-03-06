#ifndef INCLUDED_FILE_FIXTURES_C
#define INCLUDED_FILE_FIXTURES_C

#include <stdint.h>
#include <stdio.h>

char * create_basic_data_bundle_file() {
  char    *path          = temp_file_path();
  FILE    *file          = fopen(path, "wb");
  int32_t  int_buffer[7] = {
    1, // one
    1, // version
    2, // count
    5, // first_length
    4, // second_length
    1, // maximum_step
    0  // discard
  };
  float float_buffer[18] = {
    1, 3, 1, 2, 3, // sample one: first
    1, 2, 4, 5,    // sample one: second
    1, 3, 2, 3, 4, // sample two: first
    1, 2, 5, 6,    // sample two: second
  };

  // Metadata
  for (int32_t index = 0; index < 7; index += 1)
    fwrite(int_buffer + index, sizeof(int), 1, file);

  // First sample
  for (int32_t index = 0; index < 18; index += 1)
    fwrite(float_buffer + index, sizeof(float), 1, file);

  fclose(file);

  return path;
}

char * create_first_data_bundle_file() {
  char    *path          = temp_file_path();
  FILE    *file          = fopen(path, "wb");
  int32_t  int_buffer[7] = {
    1, // one
    1, // version
    1, // count
    3, // first_length
    3, // second_length
    1, // maximum_step
    0  // discard
  };
  float float_buffer[6] = {
    1, 2, 3, // sample one: first
    4, 5, 6  // sample one: second
  };

  // Metadata
  fwrite(int_buffer + 0, sizeof(int), 1, file);
  fwrite(int_buffer + 1, sizeof(int), 1, file);
  fwrite(int_buffer + 2, sizeof(int), 1, file);
  fwrite(int_buffer + 3, sizeof(int), 1, file);
  fwrite(int_buffer + 4, sizeof(int), 1, file);
  fwrite(int_buffer + 5, sizeof(int), 1, file);
  fwrite(int_buffer + 6, sizeof(int), 1, file);

  // First sample
  fwrite(float_buffer + 0, sizeof(float), 1, file);
  fwrite(float_buffer + 1, sizeof(float), 1, file);
  fwrite(float_buffer + 2, sizeof(float), 1, file);
  fwrite(float_buffer + 3, sizeof(float), 1, file);
  fwrite(float_buffer + 4, sizeof(float), 1, file);
  fwrite(float_buffer + 5, sizeof(float), 1, file);

  fclose(file);

  return path;
}

char * create_second_data_bundle_file() {
  char    *path          = temp_file_path();
  FILE    *file          = fopen(path, "wb");
  int32_t  int_buffer[7] = {
    1, // one
    1, // version
    2, // count
    4, // first_length
    2, // second_length
    1, // maximum_step
    0  // discard
  };
  float float_buffer[12] = {
    1, 2, 3, 4,  // sample one: first
    5, 6,        // sample one: second
    7, 8, 9, 10, // sample two: first
    11, 12,      // sample two: second
  };

  // Metadata
  fwrite(int_buffer + 0, sizeof(int), 1, file);
  fwrite(int_buffer + 1, sizeof(int), 1, file);
  fwrite(int_buffer + 2, sizeof(int), 1, file);
  fwrite(int_buffer + 3, sizeof(int), 1, file);
  fwrite(int_buffer + 4, sizeof(int), 1, file);
  fwrite(int_buffer + 5, sizeof(int), 1, file);
  fwrite(int_buffer + 6, sizeof(int), 1, file);

  // First sample
  fwrite(float_buffer + 0, sizeof(float), 1, file);
  fwrite(float_buffer + 1, sizeof(float), 1, file);
  fwrite(float_buffer + 2, sizeof(float), 1, file);
  fwrite(float_buffer + 3, sizeof(float), 1, file);
  fwrite(float_buffer + 4, sizeof(float), 1, file);
  fwrite(float_buffer + 5, sizeof(float), 1, file);

  // Second sample
  fwrite(float_buffer +  6, sizeof(float), 1, file);
  fwrite(float_buffer +  7, sizeof(float), 1, file);
  fwrite(float_buffer +  8, sizeof(float), 1, file);
  fwrite(float_buffer +  9, sizeof(float), 1, file);
  fwrite(float_buffer + 10, sizeof(float), 1, file);
  fwrite(float_buffer + 11, sizeof(float), 1, file);

  fclose(file);

  return path;
}

#endif
