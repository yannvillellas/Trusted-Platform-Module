#include "../include/tpm_simulator.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

// Test TPM initialization and shutdown
void test_init_shutdown()
{
    printf("Testing TPM initialization and shutdown...\n");

    // First initialization should succeed
    assert(tpm_simulator_init() == true);

    // Second initialization should fail (already initialized)
    assert(tpm_simulator_init() == false);

    // Shutdown should succeed
    tpm_simulator_shutdown();

    // After shutdown, initialization should succeed again
    assert(tpm_simulator_init() == true);

    // Clean up
    tpm_simulator_shutdown();

    printf("PASSED: TPM initialization and shutdown test\n");
}

// Test TPM command processing with invalid parameters
void test_command_processing_invalid_params()
{
    printf("Testing TPM command processing with invalid parameters...\n");

    uint8_t command[10] = {0};
    uint8_t response[10] = {0};
    uint32_t responseSize = 0;

    // Initialize TPM
    assert(tpm_simulator_init() == true);

    // Test with NULL command
    assert(tpm_simulator_process_command(NULL, 10, response, &responseSize) == false);

    // Test with NULL response
    assert(tpm_simulator_process_command(command, 10, NULL, &responseSize) == false);

    // Test with NULL responseSize
    assert(tpm_simulator_process_command(command, 10, response, NULL) == false);

    // Clean up
    tpm_simulator_shutdown();

    printf("PASSED: TPM command processing with invalid parameters test\n");
}

// Test TPM command processing with invalid command size
void test_command_processing_invalid_size()
{
    printf("Testing TPM command processing with invalid command size...\n");

    // Command with invalid size (too small)
    uint8_t command[8] = {0x80, 0x01, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00};
    uint8_t response[10] = {0};
    uint32_t responseSize = 0;

    // Initialize TPM
    assert(tpm_simulator_init() == true);

    // Process command (should succeed with error response)
    assert(tpm_simulator_process_command(command, 8, response, &responseSize) == true);

    // Response size should be the size of a TPM response header
    assert(responseSize == sizeof(TPM_RESPONSE_HEADER));

    // Clean up
    tpm_simulator_shutdown();

    printf("PASSED: TPM command processing with invalid command size test\n");
}

int main()
{
    printf("TPM Simulator Basic Tests\n");
    printf("========================\n\n");

    // Run tests
    test_init_shutdown();
    test_command_processing_invalid_params();
    test_command_processing_invalid_size();

    printf("\nAll tests passed!\n");
    return 0;
}