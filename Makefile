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
	$(CC) -g -o test/c/temp/tests_with_coverage -O0 -std=c11 -Wall -Wextra --coverage test/test_helper.c -lblas -lgsl -lgslcblas -lm
	./test/c/temp/tests_with_coverage
	$(CC) -o test/c/temp/tests_optimised -O3 -std=c11 -Wall -Wextra test/test_helper.c -lblas -lgsl -lgslcblas -lm
	./test/c/temp/tests_optimised
	for i in *.gcda; do gcov $$i > test/c/temp/$$i.coverage; done
	grep -h -A1 "File 'native" test/c/temp/*.coverage
	grep -C3 '#####' *.c.gcov | cat
	rm -f *.gcov *.gcda *.gcno
