#!/bin/bash
# Script to start the custom TPM simulator as a socket server for QEMU

TPM_PATH="$PWD/qemu_integration/tpm_state"
SOCKET_PATH="$TPM_PATH/tpm_simulator.sock"
SIM_BIN="$PWD/build/bin/tpm_simulator"

# Create TPM state directory if it doesn't exist
mkdir -p "$TPM_PATH"

# Kill any existing tpm_simulator processes
pkill -f tpm_simulator || true

# Remove old socket if it exists
rm -f "$SOCKET_PATH"

echo "Starting TPM simulator: $SIM_BIN"

# Start the simulator in the background and save its PID
"$SIM_BIN" &
TPM_PID=$!

# Check if the process started successfully
if ! ps -p $TPM_PID > /dev/null; then
    echo "Failed to start TPM simulator"
    exit 1
fi

echo "TPM simulator started with PID $TPM_PID"
echo "Waiting for socket creation..."

# Wait for socket to be created (max 10 seconds)
TIMEOUT=10
for i in $(seq 1 $TIMEOUT); do
    if [ -S "$SOCKET_PATH" ]; then
        echo "TPM socket created at $SOCKET_PATH"
        chmod 666 "$SOCKET_PATH"
        echo "Socket permissions set to allow QEMU access"
        break
    fi
    
    if [ $i -eq $TIMEOUT ]; then
        echo "Socket not created after $TIMEOUT seconds, killing TPM simulator"
        kill $TPM_PID
        exit 1
    fi
    
    echo "Waiting for socket... ($i/$TIMEOUT)"
    sleep 1
done

echo "TPM simulator ready for QEMU connections"
exit 0
