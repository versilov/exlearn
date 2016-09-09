#include <assert.h>

#include "c/neural_network/forwarder_test.c"
#include "c/neural_network/presentation_test.c"
#include "c/worker/batch_data_test.c"
#include "c/worker/worker_data_test.c"
#include "c/activity_test.c"
#include "c/matrix_test.c"
#include "c/network_state_test.c"
#include "c/network_structure_test.c"
#include "c/random_test.c"

int main() {
  // Tests for: c/neural_network/forwarder_test.c
  test_forward_for_output();

  // Tests for: c/neural_network/presentation_test.c
  test_free_presentation_closure();
  test_new_presentation_closure();
  test_call_presentation_closure();
  test_an_unknown_function();
  test_the_argmax_function();
  test_the_floor_first_function();
  test_the_round_first_function();
  test_the_ceil_first_function();

  // Tests for: c/worker/batch_data_test.c
  test_free_batch_data();
  test_new_batch_data();
  test_shuffle_batch_data_indices();

  // Tests for: c/worker/worker_data_test.c
  test_free_worker_data();
  test_new_worker_data();
  test_read_worker_data();

  // Tests for: c/activity_test.c
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

  // Tests for: c/matrix_test.c
  test_free_matrix();
  test_new_matrix();
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
  test_free_network_state();
  test_new_network_state();

  // Tests for: c/network_structure_test.c
  test_free_network_structure();
  test_new_network_structure();

  // Tests for: c/random_test.c
}
