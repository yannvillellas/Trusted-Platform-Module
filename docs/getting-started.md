# Getting Started with TPM Simulator Project

This guide will help you set up, build, test, and use the TPM Simulator project on both Linux and Windows (including WSL) systems.

---

## Quick Start (Linux & WSL)

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yannvillellas/Trusted-Platform-Module.git
   cd Trusted-Platform-Module
   ```

2. **Install Dependencies**

   - **Ubuntu/Debian:**

     ```bash
     sudo apt update
     sudo apt install gcc make qemu-system-x86
     ```

   - **Fedora/RHEL:**

     ```bash
     sudo dnf install gcc make qemu
     ```

3. **Automated Setup**

   ```bash
   make setup
   # This builds the project, creates directories, downloads the Ubuntu image, and makes scripts executable.
   ```

4. **Start the TPM Emulator and VM**

   ```bash
   make tpm_start
   # Starts the TPM emulator in the background.

   make vm_start
   # Starts the QEMU VM with TPM support.
   ```

5. **Get Help**

   ```bash
   make help
   # Lists all available Makefile targets and what they do.
   ```

---

## Main Makefile Targets

- `make` or `make all`: Build the TPM simulator
- `make test`: Build and run the test suite
- `make clean`: Remove all build artifacts
- `make setup`: Build, create directories, download Ubuntu image, set scripts executable
- `make tpm_start`: Start the TPM simulator (your implementation)
- `make vm_start`: Start the QEMU VM with TPM support

---

## Windows Setup (Native or WSL)

### Option 1: Windows Subsystem for Linux (WSL) [Recommended]

- Follow the Linux instructions above inside your WSL terminal.

### Option 2: Native Windows (MSYS2/MinGW)

1. Install [MSYS2](https://www.msys2.org/) and required packages:

   ```bash
   pacman -Syu
   pacman -S mingw-w64-x86_64-gcc mingw-w64-x86_64-make
   ```

2. Install QEMU for Windows: [QEMU Windows builds](https://qemu.weilnetz.de/w64/)

3. Build the TPM Simulator:

   ```bash
   mingw32-make win_all
   ```

4. Run the TPM Simulator:

   ```bash
   ./build/bin/tpm_simulator.exe
   ```

5. (Optional) Create a batch script to launch QEMU with TPM support. See the QEMU Integration section for details on using the Ubuntu cloud image and `seed.img`.

---

## Project Structure

- `src/` – Main source code
- `include/` – Header files
- `tests/` – Test suite
- `docs/` – Documentation (this file)
- `qemu_integration/` – QEMU/TPM integration scripts, images, and state

---

## Troubleshooting

### TPM Device Permission Issues

If you see `Permission denied` or `Could not open TCTI device file /dev/tpm0` in the VM:

```bash
sudo usermod -aG tss $USER
newgrp tss
```

Or run TPM commands with `sudo`.

### QEMU/TPM Socket Issues

- Ensure the TPM emulator is running before starting the VM (automated by `make tpm_start` and `make vm_start`).
- Check for the socket file in `qemu_integration/tpm_state/`.

### Windows-Specific Issues

- Use WSL for best compatibility.
- Use double backslashes `\\` or forward slashes `/` in file paths.
- If using native Windows, you may need to adjust socket paths and batch scripts.

---

## If You Encounter Errors

If you run into issues or errors during setup or usage, check the `Makefile` in the project root. It lists all available commands and targets, with comments describing what each one does. You can also run:

```bash
make help
```

to see a summary of available commands. This can help you troubleshoot and find the correct command for your workflow.

---

## Next Steps

- Familiarize yourself with the [TPM 2.0 Library Specification](https://trustedcomputinggroup.org/wp-content/uploads/Trusted-Platform-Module-2.0-Library-Part-3-Version-184_pub.pdf)
- Explore the codebase
- Look at open issues to find tasks to work on

---

## Architecture Overview

- **TPM Simulator**: Custom implementation of a TPM that processes TPM commands
- **Socket Interface**: Unix socket interface for communication
- **QEMU**: Virtual machine that connects to the TPM interface

**Data flow:**

```text
VM Guest OS → QEMU TPM Device → tpm_simulator.sock → Your TPM Simulator
```

---

## Customization

- Edit `start_vm.sh` to change VM resources (memory, CPU)
- Edit `start_tpm.sh` for TPM options
- Back up or reset TPM state in `qemu_integration/tpm_state/`
- Modify cloud-init config by editing `user-data` and `meta-data` and regenerating `seed.img` if needed

---
