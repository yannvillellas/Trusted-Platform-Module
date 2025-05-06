#ifndef TPM_SIMULATOR_H
#define TPM_SIMULATOR_H

#include <stdint.h>
#include <stdbool.h>

/*
 * TPM Simulator - Main Interface
 * Based on TPM 2.0 Library Specification
 */

/*
 * TPM Command Structure as defined in TPM 2.0 Library Spec
 */
typedef struct
{
    uint16_t tag;         // Indicates whether the command is using authorization
    uint32_t commandSize; // Size of the command buffer
    uint32_t commandCode; // The command being sent
    // Command parameters follow, but they are command-specific
} TPM_COMMAND_HEADER;

/*
 * TPM Response Structure as defined in TPM 2.0 Library Spec
 */
typedef struct
{
    uint16_t tag;          // Same as in the command
    uint32_t responseSize; // Size of the response buffer
    uint32_t responseCode; // Return code
    // Response parameters follow, but they are command-specific
} TPM_RESPONSE_HEADER;

/*
 * TPM Simulator initialization
 */
bool tpm_simulator_init(void);

/*
 * TPM Simulator shutdown
 */
void tpm_simulator_shutdown(void);

/*
 * Process a TPM command
 *
 * @param command Pointer to the command buffer
 * @param commandSize Size of the command buffer
 * @param response Pointer to the response buffer
 * @param responseSize Pointer to the size of the response buffer
 * @return true if successful, false otherwise
 */
bool tpm_simulator_process_command(
    const uint8_t *command,
    uint32_t commandSize,
    uint8_t *response,
    uint32_t *responseSize);

/*
 * TPM response codes
 */
#define TPM_SUCCESS 0x00000000
#define TPM_RC_FAILURE 0x00000001
#define TPM_RC_BAD_TAG 0x0000001E
#define TPM_RC_INSUFFICIENT 0x0000009A
#define TPM_RC_COMMAND_SIZE 0x00000142
#define TPM_RC_COMMAND_CODE 0x00000143
#define TPM_RC_NOT_IMPLEMENTED 0x00000180

#endif /* TPM_SIMULATOR_H */