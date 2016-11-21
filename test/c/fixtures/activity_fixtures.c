#ifndef INCLUDE_ACTIVITY_FIXTURES_C
#define INCLUDE_ACTIVITY_FIXTURES_C

#include "../../../native/include/neural_network/activity.h"

static Activity *
activity_expected_basic() {
  Activity *activity = activity_new(4);

  float layer_1_input[5] = {1, 3, 31, 38, 45};
  float layer_2_input[4] = {1, 2, 371, 486};
  float layer_3_input[4] = {1, 2, 1830, 2688};

  activity->input[1] = matrix_new(1, 3);
  activity->input[2] = matrix_new(1, 2);
  activity->input[3] = matrix_new(1, 2);

  matrix_clone(activity->input[1], layer_1_input);
  matrix_clone(activity->input[2], layer_2_input);
  matrix_clone(activity->input[3], layer_3_input);

  float layer_0_output[5] = {1, 3, 1, 2, 3};
  float layer_1_output[5] = {1, 3, 31, 38, 45};
  float layer_2_output[4] = {1, 2, 371, 486};
  float layer_3_output[4] = {1, 2, 1830, 2688};

  activity->output[0] = matrix_new(1, 3);
  activity->output[1] = matrix_new(1, 3);
  activity->output[2] = matrix_new(1, 2);
  activity->output[3] = matrix_new(1, 2);

  matrix_clone(activity->output[0], layer_0_output);
  matrix_clone(activity->output[1], layer_1_output);
  matrix_clone(activity->output[2], layer_2_output);
  matrix_clone(activity->output[3], layer_3_output);

  return activity;
}

static Activity *
activity_expected_with_dropout() {
  Activity *activity = activity_expected_basic();

  float layer_0_mask[5] = {1, 3, 0, 2, 2};
  float layer_1_mask[5] = {1, 3, 2, 2, 0};
  float layer_2_mask[4] = {1, 2, 0, 2};

  activity->mask[0] = matrix_new(1, 3);
  activity->mask[1] = matrix_new(1, 3);
  activity->mask[2] = matrix_new(1, 2);

  matrix_clone(activity->mask[0], layer_0_mask);
  matrix_clone(activity->mask[1], layer_1_mask);
  matrix_clone(activity->mask[2], layer_2_mask);

  return activity;
}

#endif
