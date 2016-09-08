#include "../../native/lib/network_structure.c"

//-----------------------------------------------------------------------------
// Tests
//-----------------------------------------------------------------------------

static void test_free_network_structure() {
  NetworkStructure *structure = new_network_structure(3);

  free_network_structure(structure);
}

static void test_new_network_structure() {
  NetworkStructure *structure = new_network_structure(3);

  free_network_structure(structure);
}
