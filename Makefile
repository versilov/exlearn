.PHONY: ci clean build test
.DEFAULT_GLOBAL := build

ERL_INCLUDE_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)

CFLAGS  = -fPIC -I$(ERL_INCLUDE_PATH) -O3 -shared -std=c11 -Wall -Wextra
LDFLAGS = -lblas -lgsl -lgslcblas -lm

SRC_DIRECTORY = ./native/src
OBJ_DIRECTORY = ./native/obj

NIFS_DIRECTORY = ./native/nifs
PRIV_DIRECTORY = ./priv

SOURCES := $(shell find $(SRC_DIRECTORY) -name *.c)
OBJECTS := $(SOURCES:$(SRC_DIRECTORY)/%.c=$(OBJ_DIRECTORY)/%.o)

NIFS_SOURCES := $(shell find $(NIFS_DIRECTORY) -name *.c)
NIFS_OBJECTS := $(NIFS_SOURCES:$(NIFS_DIRECTORY)/%.c=$(PRIV_DIRECTORY)/%.so)

SOURCES_DIRECTORIES := $(shell find $(SRC_DIRECTORY) -type d)
OBJECTS_DIRECTORIES := $(subst $(SRC_DIRECTORY),$(OBJ_DIRECTORY),$(SOURCES_DIRECTORIES))

build: $(OBJECTS_DIRECTORIES) $(OBJECTS) $(PRIV_DIRECTORY) $(NIFS_OBJECTS)

$(OBJECTS): $(OBJ_DIRECTORY)/%.o : $(SRC_DIRECTORY)/%.c
	@echo 'Compiling: '$<
	@$(CC) $(CFLAGS) -c $< -o $@

$(OBJECTS_DIRECTORIES):
	@mkdir -p $(OBJECTS_DIRECTORIES)

$(NIFS_OBJECTS): $(PRIV_DIRECTORY)/%.so : $(NIFS_DIRECTORY)/%.c
	@echo 'Creating nif: '$@
	@$(CC) $(CFLAGS) $(OBJECTS) -o $@ $< $(LDFLAGS)

$(PRIV_DIRECTORY):
	@mkdir -p $(PRIV_DIRECTORY)

TEST_CFLAGS  = -g -O0 -std=c11 -Wall -Wextra --coverage
TEST_LDFLAGS = -lgcov

TEST_OBJ_DIRECTORY = ./test/c/obj

TEST_OBJECTS := $(SOURCES:$(SRC_DIRECTORY)/%.c=$(TEST_OBJ_DIRECTORY)/%.o)

TEST_OBJECTS_DIRECTORIES := $(subst $(SRC_DIRECTORY),$(TEST_OBJ_DIRECTORY),$(SOURCES_DIRECTORIES))

$(TEST_OBJECTS_DIRECTORIES):
	@mkdir -p $(TEST_OBJECTS_DIRECTORIES)

$(TEST_OBJECTS): $(TEST_OBJ_DIRECTORY)/%.o : $(SRC_DIRECTORY)/%.c
	@echo 'Compiling: '$<
	@$(CC) $(TEST_CFLAGS) -c $< -o $@

test: $(TEST_OBJECTS_DIRECTORIES) $(TEST_OBJECTS)
	@find test/c/temp/ ! -name '.keep' -type f -exec rm -f {} +
	@lcov --directory . -z --rc lcov_branch_coverage=1
	$(CC) $(TEST_CFLAGS) $(TEST_OBJECTS) -o test/c/temp/test test/test_helper.c $(LDFLAGS) $(TEST_LDFLAGS)
	./test/c/temp/test
	@lcov --directory . -c -o cover/lcov.info-file --rc lcov_branch_coverage=1
	lcov --list cover/lcov.info-file --rc lcov_branch_coverage=1
	@genhtml --branch-coverage -o cover cover/lcov.info-file > /dev/null

clean:
	@$(RM) -rf $(OBJ_DIRECTORY) $(PRIV_DIRECTORY) $(TEST_OBJ_DIRECTORY)

ci:
	@mix deps.get
	@mix dialyzer.plt
	@make
	@make test
	@mix coveralls.travis
	@mix dialyzer --halt-exit-status
