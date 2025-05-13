# Getting Started with TPM Simulator Project

This guide will help you set up and start working on the TPM Simulator project on both Linux and Windows systems.

## Prerequisites

Before you begin, make sure you have the following installed:

- **Git**: For version control
- **C Compiler**: GCC on Linux or MinGW/Visual Studio on Windows
- **Make**: For building the project (or nmake on Windows with Visual Studio)
- **QEMU**: For testing the TPM simulator integration (will be needed later)

## Project Setup

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yannvillellas/Trusted-Platform-Module.git
   cd Trusted-Platform-Module
   ```

2. **Building the Project**

   **On Linux:**

   ```bash
   make
   ```

   **On Windows:**

   ```bash
   # Using MinGW
   mingw32-make

   # Using Visual Studio Command Prompt
   nmake win_all
   ```

3. **Running the Tests**

   **On Linux:**

   ```bash
   make test
   ```

   **On Windows:**

   ```bash
   # Using MinGW
   mingw32-make test

   # Using Visual Studio Command Prompt
   nmake win_test
   ```

## Project Structure

- **`src/`**: Main source code
  - **`main.c`**: Entry point for the TPM simulator
  - **`tpm_simulator/`**: TPM simulation code
- **`include/`**: Header files
- **`tests/`**: Test files
- **`docs/`**: Documentation
- **`qemu_patch/`**: Files for QEMU integration

## Development Workflow

1. Create a new branch for your feature:

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes to the codebase

3. Build and test your changes:

   ```bash
   make clean && make && make test
   ```

4. Commit your changes with descriptive messages:

   ```bash
   git add .
   git commit -m "feat: implement XYZ functionality"
   ```

5. Push your changes and create a pull request:

   ```bash
   git push origin feature/your-feature-name
   ```

## Next Steps

1. Familiarize yourself with the [TPM 2.0 Library Specification](https://trustedcomputinggroup.org/wp-content/uploads/Trusted-Platform-Module-2.0-Library-Part-3-Version-184_pub.pdf)
2. Explore the existing code to understand the basic structure
3. Look at the open issues to find tasks to work on

## Common Issues and Solutions

### Windows-Specific Issues

- **Path Length Limitations**: Windows has a maximum path length of 260 characters. Keep your file paths short.
- **Line Endings**: Git may convert line endings between Windows (CRLF) and Unix (LF). Configure git with:

  ```bash
  git config --global core.autocrlf input  # On Linux/macOS
  git config --global core.autocrlf true   # On Windows
  ```

### Linux-Specific Issues

- **Package Installation**: You may need to install development packages:

  ```bash
  # Fedora
  sudo dnf install gcc make glibc-devel

  # Ubuntu/Debian
  sudo apt-get install build-essential
  ```

## Getting Help

If you encounter any issues, please:

1. Check the documentation
2. Review existing issues on GitHub
3. Ask team members for help
4. Create a new issue with detailed information about the problem
