.PHONY: all clean compile test
.DEFAULT_GLOBAL := all

ERL_INCLUDE_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)

all: clean compile

clean:
	rm -f priv/matrix_nifs.so

compile:
	mkdir -p priv
	$(CC) -fPIC -I$(ERL_INCLUDE_PATH) -o priv/matrix_nifs.so -O3 -shared -std=c11 -Wall native/matrix_nifs.c -lblas

test:
	find test/c/temp/ ! -name '.keep' -type f -exec rm -f {} +
	$(CC) -g -o test/c/temp/matrix_test -O0 -std=c11 -Wall --coverage test/c/matrix_test.c -lblas
	./test/c/temp/matrix_test
	$(CC) -g -o test/c/temp/worker_data -O0 -std=c11 -Wall --coverage test/c/worker/worker_data_test.c
	./test/c/temp/worker_data
	$(CC) -g -o test/c/temp/batch_data -O0 -std=c11 -Wall --coverage test/c/worker/batch_data_test.c -lgsl -lgslcblas -lm
	./test/c/temp/batch_data
	for i in *.gcda; do gcov $$i > test/c/temp/$$i.coverage; done
	grep -h -A1 "File 'native" test/c/temp/*.coverage
	grep -C3 '#####' *.c.gcov | cat
	rm -f *.gcov *.gcda *.gcno
