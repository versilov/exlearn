#include "../../../native/lib/activity.c"

static NetworkStructure *
network_structure_basic() {
  NetworkStructure *structure = new_network_structure(4);

  structure->rows[0]       = 1;
  structure->columns[0]    = 3;
  structure->dropout[0]    = 0;
  structure->function[0]   = NULL;
  structure->derivative[0] = NULL;

  structure->rows[1]       = 3;
  structure->columns[1]    = 3;
  structure->dropout[1]    = 0;
  structure->function[1]   = activity_determine_function(3, 0);
  structure->derivative[1] = activity_determine_derivative(3, 0);

  structure->rows[2]       = 3;
  structure->columns[2]    = 2;
  structure->dropout[2]    = 0;
  structure->function[2]   = activity_determine_function(3, 0);
  structure->derivative[2] = activity_determine_derivative(3, 0);

  structure->rows[3]       = 2;
  structure->columns[3]    = 2;
  structure->dropout[3]    = 0;
  structure->function[3]   = activity_determine_function(3, 0);
  structure->derivative[3] = activity_determine_derivative(3, 0);

  return structure;
}
