#ifndef INCLUDE_ACTIVITY_FIXTURES_C
#define INCLUDE_ACTIVITY_FIXTURES_C

#include "../../../native/lib/neural_network/activity.c"

static Activity *
activity_expected_basic() {
  Activity *activity = new_activity(4);

  float layer_1_input[5] = {1, 3, 31, 38, 45};
  float layer_2_input[4] = {1, 2, 371, 486};
  float layer_3_input[4] = {1, 2, 1830, 2688};

  activity->input[1] = new_matrix(1, 3);
  activity->input[2] = new_matrix(1, 2);
  activity->input[3] = new_matrix(1, 2);

  clone_matrix(activity->input[1], layer_1_input);
  clone_matrix(activity->input[2], layer_2_input);
  clone_matrix(activity->input[3], layer_3_input);

  float layer_0_output[5] = {1, 3, 1, 2, 3};
  float layer_1_output[5] = {1, 3, 31, 38, 45};
  float layer_2_output[4] = {1, 2, 371, 486};
  float layer_3_output[4] = {1, 2, 1830, 2688};

  activity->output[0] = new_matrix(1, 3);
  activity->output[1] = new_matrix(1, 3);
  activity->output[2] = new_matrix(1, 2);
  activity->output[3] = new_matrix(1, 2);

  clone_matrix(activity->output[0], layer_0_output);
  clone_matrix(activity->output[1], layer_1_output);
  clone_matrix(activity->output[2], layer_2_output);
  clone_matrix(activity->output[3], layer_3_output);

  return activity;
}

static Activity *
activity_expected_with_dropout() {
  Activity *activity = activity_expected_basic();

  float layer_0_mask[5] = {1, 3, 0, 2, 2};
  float layer_1_mask[5] = {1, 3, 2, 2, 0};
  float layer_2_mask[4] = {1, 2, 0, 2};

  activity->mask[0] = new_matrix(1, 3);
  activity->mask[1] = new_matrix(1, 3);
  activity->mask[2] = new_matrix(1, 2);

  clone_matrix(activity->mask[0], layer_0_mask);
  clone_matrix(activity->mask[1], layer_1_mask);
  clone_matrix(activity->mask[2], layer_2_mask);

  return activity;
}

#endif
