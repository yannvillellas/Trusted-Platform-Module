# TPM Simulator Project

A custom TPM (Trusted Platform Module) simulator designed to interface with QEMU, implementing core TPM functionality with a focus on cryptographic key management.

## Project Overview

This project implements a TPM simulator that provides:

- TPM Command Chain Implementation
- Cryptographic Key Management functionality
- Socket-based Communication Interface
<!-- - Integration with QEMU using swtpm -->
- VM testing environment with Ubuntu Cloud Image

## Directory Structure

- `/src/tpm_simulator/` - Main source code for the TPM simulator
- `/include/` - Header files
- `/tests/` - Test suite for verifying TPM functionality
- `/docs/` - Documentation (see below)
- `/qemu_integration/` - Scripts and files for QEMU/TPM integration

## Documentation

- [Getting Started Guide](docs/getting-started.md) – Complete setup, build, test, and usage instructions for Linux, Windows, and QEMU integration

## Building and Running

For all build, test, and QEMU integration instructions, see the [Getting Started Guide](docs/getting-started.md).

## Requirements

- C/C++ compiler (GCC, MinGW, or Visual Studio)
- QEMU (version 4.0 or later)
- swtpm (Software TPM Emulator)
- cloud-image-utils (for cloud-init image creation)
- OpenSSL or similar cryptography library

## Team Members

- **Yann Villellas** - [GitHub Profile](https://github.com/yannvillellas)
- **Louise Tiger** - [GitHub Profile](https://github.com/LouiseT2)
- **Josselin Haquette** - [GitHub Profile](https://github.com/Rosselinno)
- **Louis Bousquet** - [GitHub Profile](https://github.com/lioloup)
