#include <assert.h>

#include "../../../native/lib/worker/batch_data.c"


//-----------------------------------------------------------------------------
// Tests
//-----------------------------------------------------------------------------

static void test_free_batch_data() {
  BatchData *data = new_batch_data(3, 1);

  free_batch_data(data);
}

static void test_new_batch_data() {
  BatchData *data = new_batch_data(3, 1);

  assert(data->data_length  == 3);
  assert(data->batch_length == 1);

  for (int index = 0; index < 3; index += 1) {
    assert(data->indices[index] == index);
  }

  free_batch_data(data);
}

static void test_shuffle_batch_data_indices() {
  BatchData *data = new_batch_data(3, 1);

  shuffle_batch_data_indices(data);

  for (int index = 0; index < 3; index += 1) {
    assert(data->indices[index] >= 0);
    assert(data->indices[index] <= 2);
  }

  free_batch_data(data);
}

//-----------------------------------------------------------------------------
// Run Tests
//-----------------------------------------------------------------------------

int main() {
  test_free_batch_data();
  test_new_batch_data();
  test_shuffle_batch_data_indices();

  return 0;
}
