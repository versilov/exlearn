#-------------------------------------------------------------------------------
# DEPENDENCIES
#-------------------------------------------------------------------------------

# The location of the header file for the erlang runtime system.
#
# Example:
#
#   /usr/lib/erlang/erts-8.2/include
#
ERL_INCLUDE_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)


#-------------------------------------------------------------------------------
# FLAGS
#-------------------------------------------------------------------------------

# For compiling and linking the final NIF shared objects.
CFLAGS  = -fPIC -I$(ERL_INCLUDE_PATH) -O3 -shared -std=gnu11 -Wall -Wextra
LDFLAGS = -lblas -lgsl -lgslcblas -lm

# For compiling and linking the test runner.
TEST_CFLAGS  = -g -O0 -std=gnu11 -Wall -Wextra --coverage
TEST_LDFLAGS = -lgcov


#-------------------------------------------------------------------------------
# C FILES
#-------------------------------------------------------------------------------

# Lists of all the C source files and directories.
SOURCES := $(shell find $(SRC_DIRECTORY) -name *.c)

# List of all the object files and their directories created from compiling the
# C files.
OBJECTS := $(SOURCES:$(SRC_DIRECTORY)/%.c=$(OBJ_DIRECTORY)/%.o)

# A list of all C files that correspond to a nif.
NIFS_SOURCES := $(wildcard $(NIFS_DIRECTORY)/*.c)

# A list of all the helpers used by the nif C files.
NIFS_HELPERS := $(shell find $(NIFS_DIRECTORY) -name *_helper.c)

# A list of all the object files corresponding to the nif C files.
NIFS_OBJECTS := $(NIFS_SOURCES:$(NIFS_DIRECTORY)/%.c=$(PRIV_DIRECTORY)/%.so)

#-------------------------------------------------------------------------------
# DIRECTORIES
#-------------------------------------------------------------------------------

SRC_DIRECTORY = ./native/src
OBJ_DIRECTORY = ./native/obj

NIFS_DIRECTORY = ./native/nifs
PRIV_DIRECTORY = ./priv

SOURCES_DIRECTORIES := $(shell find $(SRC_DIRECTORY) -type d)
OBJECTS_DIRECTORIES := $(subst $(SRC_DIRECTORY),$(OBJ_DIRECTORY),$(SOURCES_DIRECTORIES))


#-------------------------------------------------------------------------------
# TARGETS
#-------------------------------------------------------------------------------

# Use the `build` target when executing make without arguments
.DEFAULT_GLOBAL := build

# Targets that do not depend on files
.PHONY: build ci clean test

# Compiles and links the C nifs.
build: $(OBJECTS_DIRECTORIES) $(OBJECTS) $(PRIV_DIRECTORY) $(NIFS_OBJECTS)

$(OBJECTS): $(OBJ_DIRECTORY)/%.o : $(SRC_DIRECTORY)/%.c
	@echo 'Compiling: '$<
	@$(CC) $(CFLAGS) -c $< -o $@

$(OBJECTS_DIRECTORIES):
	@mkdir -p $(OBJECTS_DIRECTORIES)

$(NIFS_OBJECTS): $(PRIV_DIRECTORY)/%.so : $(NIFS_DIRECTORY)/%.c $(OBJECTS) $(NIFS_HELPERS)
	@echo 'Creating nif: '$@
	@$(CC) $(CFLAGS) $(OBJECTS) -o $@ $< $(LDFLAGS)

$(PRIV_DIRECTORY):
	@mkdir -p $(PRIV_DIRECTORY)


TEST_OBJ_DIRECTORY = ./test/c/obj

TEST_OBJECTS := $(SOURCES:$(SRC_DIRECTORY)/%.c=$(TEST_OBJ_DIRECTORY)/%.o)

# Creates a directory structure for test object files that mirrors the one for
# the source files.
TEST_OBJECTS_DIRECTORIES := $(subst $(SRC_DIRECTORY),$(TEST_OBJ_DIRECTORY),$(SOURCES_DIRECTORIES))

$(TEST_OBJECTS_DIRECTORIES):
	@mkdir -p $(TEST_OBJECTS_DIRECTORIES)

$(TEST_OBJECTS): $(TEST_OBJ_DIRECTORY)/%.o : $(SRC_DIRECTORY)/%.c
	@echo 'Compiling: '$<
	@$(CC) $(TEST_CFLAGS) -c $< -o $@

# Builds the C code with debugging and testing flags and runs the tests.
#
# Example:
#
#   ```bash
#   make test
#   ```
#
test: $(TEST_OBJECTS_DIRECTORIES) $(TEST_OBJECTS)
	@find test/c/temp/ ! -name '.keep' -type f -exec rm -f {} +
	@lcov --directory . -z --rc lcov_branch_coverage=1
	$(CC) $(TEST_CFLAGS) $(TEST_OBJECTS) -o test/c/temp/test test/test_helper.c $(LDFLAGS) $(TEST_LDFLAGS)
	./test/c/temp/test
	@lcov --directory . -c -o cover/lcov.info-file --rc lcov_branch_coverage=1
	lcov --list cover/lcov.info-file --rc lcov_branch_coverage=1
	@genhtml --branch-coverage -o cover cover/lcov.info-file > /dev/null
	@rm -rf *.gcda *.gcno

# Remove build artifacts.
# Run this when you want to ensure you run a fresh build.
#
# Example:
#
#   To remove all artifacts:
#   ```bash
#   make clean
#   ```
#
#   To create a fresh build:
#   ```
#   make clean build
#   ```
#
clean:
	@$(RM) -rf $(OBJ_DIRECTORY) $(PRIV_DIRECTORY) $(TEST_OBJ_DIRECTORY)

# Run the complete suite of tests and checks.
#
# Example:
#
#   ```bash
#   make ci
#   ```
#
ci:
	@mix deps.get
	@mix dialyzer.plt
	@make
	@make test
	@mix coveralls.travis
	@mix dialyzer --halt-exit-status
