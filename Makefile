.PHONY: all clean compile
.DEFAULT_GLOBAL := all

ERL_INCLUDE_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
LDFLAGS = Wl, -rpath /usr/lib

all: clean compile

clean:
	rm -f priv/matrix.so

compile:
	mkdir -p priv && \
	$(CC) -fPIC -I/usr/include -I$(ERL_INCLUDE_PATH) -L/usr/include -L/usr/lib -lblas -o priv/matrix.so -O3 -shared -std=c11 -Wall c_src/matrix.c
