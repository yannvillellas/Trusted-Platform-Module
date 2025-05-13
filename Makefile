CC=gcc
CFLAGS=-Wall -Wextra -Werror -g -I./include
LDFLAGS=-lpthread

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

.PHONY: all clean test win_all win_test win_clean win_test_% win_create_test_dirs win_tpm_sim_obj win_create_dirs swtpm_start

all: $(TARGET)

test: $(TESTS_TARGETS)
	@echo "Running tests..."
	@for test in $(TESTS_TARGETS); do \
		echo "Running $$test"; \
		$$test; \
	done

help:
	@echo "Available targets:"
	@echo "  make            - Build the TPM simulator (default)"
	@echo "  make test       - Build and run the test suite"
	@echo "  make clean      - Remove all build artifacts"
	@echo "  make setup      - Build, create directories, download Ubuntu image, and set scripts executable"
	@echo "  make qemu_setup - Create directories for QEMU integration"
	@echo "  make download_ubuntu - Download Ubuntu cloud image for VM"
	@echo "  make tpm_start       - Start the TPM simulator (your implementation)"
	@echo "  make vm_start        - Start the QEMU VM with TPM support"
	@echo "  make swtpm_start     - Start the swtpm TPM emulator"
	@echo "  make vm_swtpm_start  - Start the QEMU VM with swtpm TPM support"

setup: all qemu_setup download_ubuntu
	chmod +x qemu_integration/*.sh
	@echo "Setup complete. You can now run the VM and TPM emulator."

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

# QEMU integration targets
qemu_setup:
	mkdir -p qemu_integration/images
	mkdir -p qemu_integration/tpm_state
	@echo "Creating directories for QEMU integration"
	@echo "Note: You need to download a cloud image - the seed.img is already included"

# This target is kept for users who want to regenerate the seed.img with custom settings
cloud_init_custom:
	@echo "Regenerating cloud-init seed image with custom settings"
	@echo "Warning: This will overwrite the provided seed.img"
	cloud-localds qemu_integration/seed.img qemu_integration/user-data qemu_integration/meta-data

download_ubuntu:
	@if [ -f qemu_integration/images/ubuntu-25.04-cloud.img ]; then \
		echo "Ubuntu cloud image already exists. Skipping download."; \
	else \
		echo "Downloading Ubuntu cloud image"; \
		wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img -O qemu_integration/images/ubuntu-25.04-cloud.img; \
	fi

vm_start:
	@echo "Starting VM with TPM support"
	./qemu_integration/start_vm.sh

tpm_start:
	@echo "Starting TPM emulator"
	./qemu_integration/start_tpm.sh

swtpm_start:
	@echo "Starting swtpm TPM emulator"
	./qemu_integration/start_swtpm.sh

vm_swtpm_start:
	@echo "Starting VM with swtpm TPM support"
	./qemu_integration/vm_swtpm.sh

# For Windows compatibility (using NMake)
.PHONY: win_all win_test win_clean

# Main Windows target
win_all:
	-mkdir build
	-mkdir build\bin
	-mkdir build\src
	-mkdir build\src\tpm_simulator
	@echo Compiling main program...
	$(CC) $(CFLAGS) -c $(SRC_DIR)/main.c -o $(BUILD_DIR)/src/main.o
	@echo Compiling TPM Simulator core...
	$(CC) $(CFLAGS) -c $(TPM_SIM_DIR)/tpm_simulator.c -o $(BUILD_DIR)/src/tpm_simulator/tpm_simulator.o
	@echo Linking main program...
	$(CC) $(CFLAGS) $(BUILD_DIR)/src/main.o $(BUILD_DIR)/src/tpm_simulator/tpm_simulator.o $(LDFLAGS) -o $(BIN_DIR)/tpm_simulator.exe
	@echo Build completed for Windows.

# Windows test targets
win_test: win_create_test_dirs $(TESTS_SRC:$(TESTS_DIR)/%.c=win_test_%)
	@echo Running all tests in Windows...

win_test_%: $(TESTS_BUILD_DIR)/%.o $(TPM_SIM_OBJ)
	@echo Building test $*...
	$(CC) $(CFLAGS) $< $(TPM_SIM_OBJ) $(LDFLAGS) -o $(BIN_DIR)/$*.exe
	@echo Running test $*...
	$(BIN_DIR)/$*.exe

win_create_test_dirs:
	-mkdir build\tests
	-mkdir build\bin

# Windows clean
win_clean:
	-rmdir /s /q build

# Gather TPM simulator object files for Windows
win_tpm_sim_obj: win_create_dirs
	@echo Building TPM simulator objects for Windows...
	for %%f in ($(TPM_SIM_DIR)/*.c) do $(CC) $(CFLAGS) -c %%f -o $(BUILD_DIR)/%%f.o

win_create_dirs:
	-mkdir build
	-mkdir build\bin
	-mkdir build\src
	-mkdir build\src\tpm_simulator
	-mkdir build\tests