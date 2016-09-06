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
	rm -f test/c/temp/matrix_test
	$(CC) -o test/c/temp/matrix_test -O3 -std=c11 -Wall test/c/matrix_test.c -lblas
	./test/c/temp/matrix_test
	rm -f test/c/temp/worker_file_io
	$(CC) -o test/c/temp/worker_file_io -O3 -std=c11 -Wall test/c/worker/file_io_test.c
	./test/c/temp/worker_file_io
