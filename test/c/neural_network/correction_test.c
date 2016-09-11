#include "../../../native/lib/neural_network/correction.c"

static void test_free_correction() {
  Correction *correction = new_correction(3);

  free_correction(correction);
}

static void test_new_correction() {
  Correction *correction = new_correction(3);

  assert(correction->layers == 3);

  assert(correction->biases  != NULL);
  assert(correction->weights != NULL);

  for (int layer = 0; layer < correction->layers; layer += 1) {
    assert(correction->biases[layer]  == NULL);
    assert(correction->weights[layer] == NULL);
  }

  free_correction(correction);
}
