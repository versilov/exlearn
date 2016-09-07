typedef float* (*ActivityFunction)(float *);

typedef struct NetworkStructure {
  int               layers;
  int              *rows;
  int              *columns;
  float            *dropout;
  ActivityFunction *activity;

} NetworkStructure;

static void
free_network_structure(NetworkStructure *structure) {
  free(structure->rows    );
  free(structure->columns );
  free(structure->dropout );
  free(structure->activity);

  free(structure);
}

static NetworkStructure *
new_network_structure(int layers) {
  NetworkStructure *structure = malloc(sizeof(NetworkStructure));

  structure->layers   = layers;
  structure->rows     = malloc(sizeof(int)   * layers);
  structure->columns  = malloc(sizeof(int)   * layers);
  structure->dropout  = malloc(sizeof(float) * layers);
  structure->activity = malloc(sizeof(ActivityFunction) * layers);

  return structure;
}
