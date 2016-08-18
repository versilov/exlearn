.PHONY: all clean compile mkpriv
.DEFAULT_GLOBAL := all

ERL_INCLUDE_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)

all: clean mkpriv compile

clean:
	rm -f priv/matrix.so

compile:
	$(CC) -fPIC -I$(ERL_INCLUDE_PATH) -o priv/matrix.so -O3 -shared -std=c11 -Wall c_src/matrix.c -lblas

mkpriv:
	mkdir -p priv
