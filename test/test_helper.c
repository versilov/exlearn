#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#include "c/test_util.c"
#include "c/neural_network/activity_test.c"
#include "c/neural_network/correction_test.c"
#include "c/neural_network/dropout_test.c"
#include "c/neural_network/forwarder_test.c"
#include "c/neural_network/gradient_descent_test.c"
#include "c/neural_network/objective_test.c"
#include "c/neural_network/presentation_test.c"
#include "c/neural_network/propagator_test.c"
#include "c/worker/batch_data_test.c"
#include "c/worker/bundle_paths_test.c"
#include "c/worker/sample_index_test.c"
#include "c/worker/worker_data_bundle_test.c"
#include "c/worker/worker_data_test.c"
#include "c/matrix_test.c"
#include "c/network_state_test.c"

int main() {
  // Test for: c/neural_network/activity_test.c
  test_activity_free();
  test_activity_new();
  test_an_unknown_pair();
  test_the_arctan_pair();
  test_the_bent_identity_pair();
  test_the_gaussian_pair();
  test_the_identity_pair();
  test_the_logistic_pair();
  test_the_relu_pair();
  test_the_sinc_pair();
  test_the_sinusoid_pair();
  test_the_softmax_pair();
  test_the_softplus_pair();
  test_the_softsign_pair();
  test_the_tanh_pair();
  test_the_elu_pair();
  test_the_prelu_pair();

  // Tests for: c/neural_network/correction_test.c
  test_correction_free();
  test_correction_new();
  test_correction_accumulate();
  test_correction_apply();
  test_correction_char_size();
  test_correction_from_char_array();
  test_correction_to_char_array();
  test_correction_initialize();

  // Tests for: c/neural_network/dropout_test.c
  test_create_dropout_mask();

  // Tests for: c/neural_network/forwarder_test.c
  test_forward_for_activity();
  test_forward_for_activity_with_dropout();
  test_forward_for_output();

  // Tests for: c/neural_network/gradient_descent.c
  test_gradient_descent();

  // Tests for: c/neural_network/objective_test.c
  test_an_unknown_objective_function();
  test_the_cross_entropy_objective_function();
  test_the_negative_log_likelihood_objective_function();
  test_the_quadratic_objective_function();

  test_an_unknown_objective_error_simple();
  test_the_cross_entropy_objective_error_simple();
  test_the_negative_log_likelihood_objective_error_simple();

  test_an_unknown_objective_error_optimised();
  test_the_cross_entropy_objective_error_optimised();
  test_the_negative_log_likelihood_objective_error_optimised();

  test_the_quadratic_objective_error();

  // Tests for: c/neural_network/presentation_test.c
  test_presentation_closure_free();
  test_presentation_closure_new();
  test_presentation_closure_call();
  test_an_unknown_function();
  test_the_argmax_function();
  test_the_floor_first_function();
  test_the_round_first_function();
  test_the_ceil_first_function();

  // Tests for: c/neural_network/propagator_test.c
  test_back_propagate();
  test_back_propagate_with_dropout();

  // Tests for: c/worker/batch_data_test.c
  test_batch_data_free();
  test_batch_data_new();
  test_batch_data_initialize();
  test_shuffle_batch_data_indices();
  test_batch_data_get_sample_index();

  // Tests for: c/worker/bundle_paths_test.c
  test_bundle_paths_free();
  test_bundle_paths_new();

  // Tests for: c/worker/sample_index_test.c
  test_sample_index_free();
  test_sample_index_new();

  // Tests for: c/worker/worker_data_bundle_test.c
  test_worker_data_bundle_free();
  test_worker_data_bundle_new();
  test_read_worker_data_bundle();

  // Tests for: c/worker/worker_data_test.c
  test_worker_data_free();
  test_worker_data_new();
  test_worker_data_initialize();
  test_worker_data_read();

  // Tests for: c/matrix_test.c
  test_matrix_clone();
  test_matrix_free();
  test_matrix_new();
  test_matrix_fill();
  test_matrix_equal();
  test_matrix_add();
  test_matrix_argmax();
  test_matrix_divide();
  test_matrix_dot();
  test_matrix_dot_and_add();
  test_matrix_dot_nt();
  test_matrix_dot_tn();
  test_matrix_first();
  test_matrix_max();
  test_matrix_multiply();
  test_matrix_multiply_with_scalar();
  test_matrix_substract();
  test_matrix_sum();
  test_matrix_transpose();

  // Tests for: c/network_state_test.c
  test_network_state_free();
  test_network_state_new();
}
