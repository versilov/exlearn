#ifndef INCLUDED_STRUCTS_C
#define INCLUDED_STRUCTS_C

typedef struct ActivityClosure {
  void  (*function)(struct ActivityClosure *, float *);
  float alpha;
} ActivityClosure;

typedef void (*ActivityFunction)(ActivityClosure *, float *);

typedef struct NetworkState {
  int  layers;
  int *biases;
  int *weights;
} NetworkState;

typedef struct NetworkStructure {
  int               layers;
  int              *rows;
  int              *columns;
  float            *dropout;
  ActivityClosure **activity;
} NetworkStructure;

#endif
