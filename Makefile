.PHONY: compile clean
.DEFAULT_GLOBAL := compile

ERL_INCLUDE_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)

compile:
	mkdir -p priv && \
	cc -fPIC -I$(ERL_INCLUDE_PATH) -o priv/matrix.so -O3 -shared -std=c11 c_src/matrix.c

clean:
	rm -f priv/matrix.so
