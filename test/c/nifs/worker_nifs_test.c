#include "../../../native/nifs/worker_nifs.c"

static void test_create_worker_data() {
  ErlNifEnv    *env;
  int           argc;
  ERL_NIF_TERM *argv;
  ERL_NIF_TERM result;

  env  = NULL;
  argc = 0;
  argv = NULL;

  result = create_worker_data(env, argc, argv);

  assert(result == 0); /* LCOV_EXCL_BR_LINE */
}
