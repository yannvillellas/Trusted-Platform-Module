#include "../include/tpm_simulator.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// For demonstration, we'll create a simple TPM_Startup command
// TPM_Startup is one of the first commands that would be sent to a TPM

// TPM Command Tags
#define TPM_ST_NO_SESSIONS 0x8001
#define TPM_ST_SESSIONS 0x8002

// TPM Command Codes
#define TPM_CC_STARTUP 0x00000144

// TPM_SU (Startup Type)
#define TPM_SU_CLEAR 0x0000
#define TPM_SU_STATE 0x0001

// Helper function to create a TPM_Startup command
static void create_tpm_startup_command(uint8_t *buffer, uint32_t *size, uint16_t startupType)
{
    // Command Header
    uint16_t tag = TPM_ST_NO_SESSIONS;
    uint32_t commandSize = 12; // Header (10) + startup type (2)
    uint32_t commandCode = TPM_CC_STARTUP;

    // Construct the command buffer
    buffer[0] = (tag >> 8) & 0xFF;
    buffer[1] = tag & 0xFF;

    buffer[2] = (commandSize >> 24) & 0xFF;
    buffer[3] = (commandSize >> 16) & 0xFF;
    buffer[4] = (commandSize >> 8) & 0xFF;
    buffer[5] = commandSize & 0xFF;

    buffer[6] = (commandCode >> 24) & 0xFF;
    buffer[7] = (commandCode >> 16) & 0xFF;
    buffer[8] = (commandCode >> 8) & 0xFF;
    buffer[9] = commandCode & 0xFF;

    // Startup Type (TPM_SU)
    buffer[10] = (startupType >> 8) & 0xFF;
    buffer[11] = startupType & 0xFF;

    *size = commandSize;
}

// Helper function to print buffer contents for debugging
static void print_buffer(const uint8_t *buffer, uint32_t size)
{
    printf("Buffer [%u bytes]:\n", size);
    for (uint32_t i = 0; i < size; i++)
    {
        printf("%02X ", buffer[i]);
        if ((i + 1) % 16 == 0)
        {
            printf("\n");
        }
    }
    printf("\n");
}

int main()
{
    printf("TPM Simulator Demo\n");
    printf("==================\n\n");

    // Initialize the TPM simulator
    if (!tpm_simulator_init())
    {
        printf("Failed to initialize TPM simulator\n");
        return 1;
    }

    // Create a TPM_Startup command
    uint8_t command[64] = {0}; // Buffer for command
    uint32_t commandSize = 0;
    create_tpm_startup_command(command, &commandSize, TPM_SU_CLEAR);

    printf("Sending TPM_Startup command:\n");
    print_buffer(command, commandSize);

    // Response buffer
    uint8_t response[64] = {0};
    uint32_t responseSize = 0;

    // Process the command
    if (!tpm_simulator_process_command(command, commandSize, response, &responseSize))
    {
        printf("Failed to process TPM command\n");
        tpm_simulator_shutdown();
        return 1;
    }

    printf("Received TPM response:\n");
    print_buffer(response, responseSize);

    // Extract response code
    uint32_t responseCode = 0;
    if (responseSize >= 10)
    {
        responseCode = (response[6] << 24) | (response[7] << 16) |
                       (response[8] << 8) | response[9];
    }

    if (responseCode == TPM_SUCCESS)
    {
        printf("TPM command succeeded\n");
    }
    else if (responseCode == TPM_RC_NOT_IMPLEMENTED)
    {
        printf("TPM command not implemented yet\n");
    }
    else
    {
        printf("TPM command failed with response code: 0x%08X\n", responseCode);
    }

    // Shutdown the TPM simulator
    tpm_simulator_shutdown();

    return 0;
}