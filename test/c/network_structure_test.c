#include "../../native/include/network_structure.h"

//-----------------------------------------------------------------------------
// Tests
//-----------------------------------------------------------------------------

static void test_network_structure_free() {
  NetworkStructure *structure = network_structure_new(3);

  network_structure_free(&structure);

  assert(structure == NULL); /* LCOV_EXCL_BR_LINE */
}

static void test_network_structure_new() {
  NetworkStructure *structure = network_structure_new(3);

  network_structure_free(&structure);
}
