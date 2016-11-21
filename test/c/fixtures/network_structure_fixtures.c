#ifndef INCLUDE_NETWORK_STRUCTURE_FIXTURES_C
#define INCLUDE_NETWORK_STRUCTURE_FIXTURES_C

#include "../../../native/include/neural_network/activity.h"
#include "../../../native/include/neural_network/objective.h"
#include "../../../native/include/neural_network/presentation.h"

static NetworkStructure *
network_structure_basic() {
  NetworkStructure *structure = network_structure_new(4);

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

  structure->presentation = presentation_determine(0, 0);
  structure->objective    = objective_determine_function(2);
  structure->error        = objective_determine_error_simple(2);

  return structure;
}

static NetworkStructure *
network_structure_with_dropout() {
  NetworkStructure *structure = network_structure_new(4);

  structure->rows[0]       = 1;
  structure->columns[0]    = 3;
  structure->dropout[0]    = 0.5;
  structure->function[0]   = NULL;
  structure->derivative[0] = NULL;

  structure->rows[1]       = 3;
  structure->columns[1]    = 3;
  structure->dropout[1]    = 0.5;
  structure->function[1]   = activity_determine_function(3, 0);
  structure->derivative[1] = activity_determine_derivative(3, 0);

  structure->rows[2]       = 3;
  structure->columns[2]    = 2;
  structure->dropout[2]    = 0.5;
  structure->function[2]   = activity_determine_function(3, 0);
  structure->derivative[2] = activity_determine_derivative(3, 0);

  structure->rows[3]       = 2;
  structure->columns[3]    = 2;
  structure->dropout[3]    = 0.5;
  structure->function[3]   = activity_determine_function(3, 0);
  structure->derivative[3] = activity_determine_derivative(3, 0);

  structure->presentation = presentation_determine(0, 0);
  structure->objective    = objective_determine_function(2);
  structure->error        = objective_determine_error_simple(2);

  return structure;
}

#endif
