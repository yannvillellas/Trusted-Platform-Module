CC=gcc
CFLAGS=-Wall -Wextra -Werror -g -I./include
LDFLAGS=

# Source directories
SRC_DIR=src
TPM_SIM_DIR=$(SRC_DIR)/tpm_simulator
TESTS_DIR=tests

# Output directories
BUILD_DIR=build
BIN_DIR=$(BUILD_DIR)/bin
TESTS_BUILD_DIR=$(BUILD_DIR)/tests

# Source files
TPM_SIM_SRC=$(wildcard $(TPM_SIM_DIR)/*.c)
MAIN_SRC=$(SRC_DIR)/main.c
TESTS_SRC=$(wildcard $(TESTS_DIR)/*.c)

# Object files
TPM_SIM_OBJ=$(TPM_SIM_SRC:%.c=$(BUILD_DIR)/%.o)
MAIN_OBJ=$(BUILD_DIR)/$(MAIN_SRC:.c=.o)
TESTS_OBJ=$(TESTS_SRC:$(TESTS_DIR)/%.c=$(TESTS_BUILD_DIR)/%.o)

# Binary outputs
TARGET=$(BIN_DIR)/tpm_simulator
TESTS_TARGETS=$(TESTS_SRC:$(TESTS_DIR)/%.c=$(BIN_DIR)/%)

.PHONY: all clean test

all: $(TARGET)

test: $(TESTS_TARGETS)
	@echo "Running tests..."
	@for test in $(TESTS_TARGETS); do \
		echo "Running $$test"; \
		$$test; \
	done

# Create build directories
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/$(SRC_DIR)
	mkdir -p $(BUILD_DIR)/$(TPM_SIM_DIR)
	mkdir -p $(BIN_DIR)

$(TESTS_BUILD_DIR):
	mkdir -p $(TESTS_BUILD_DIR)

# Compile main program
$(BUILD_DIR)/$(SRC_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Compile TPM simulator source files
$(BUILD_DIR)/$(TPM_SIM_DIR)/%.o: $(TPM_SIM_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Compile test files
$(TESTS_BUILD_DIR)/%.o: $(TESTS_DIR)/%.c | $(TESTS_BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Link the main binary
$(TARGET): $(TPM_SIM_OBJ) $(MAIN_OBJ)
	$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $@

# Link test binaries
$(BIN_DIR)/%: $(TESTS_BUILD_DIR)/%.o $(TPM_SIM_OBJ)
	$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $@

clean:
	rm -rf $(BUILD_DIR)

# For Windows compatibility (using NMake)
win_all:
	-mkdir build
	-mkdir build\bin
	-mkdir build\src
	-mkdir build\src\tpm_simulator
	$(CC) $(CFLAGS) -c $(SRC_DIR)/main.c -o $(BUILD_DIR)/src/main.o
	$(CC) $(CFLAGS) -c $(TPM_SIM_DIR)/tpm_simulator.c -o $(BUILD_DIR)/src/tpm_simulator/tpm_simulator.o
	$(CC) $(CFLAGS) $(BUILD_DIR)/src/main.o $(BUILD_DIR)/src/tpm_simulator/tpm_simulator.o $(LDFLAGS) -o $(BIN_DIR)/tpm_simulator.exe

win_test:
	-mkdir build\tests
	$(CC) $(CFLAGS) -c $(TESTS_DIR)/test_tpm_basic.c -o $(BUILD_DIR)/tests/test_tpm_basic.o
	$(CC) $(CFLAGS) $(BUILD_DIR)/tests/test_tpm_basic.o $(BUILD_DIR)/src/tpm_simulator/tpm_simulator.o $(LDFLAGS) -o $(BIN_DIR)/test_tpm_basic.exe
	$(BIN_DIR)/test_tpm_basic.exe

win_clean:
	-rmdir /s /q build