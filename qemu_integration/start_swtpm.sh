#!/bin/bash
# Script to start swtpm as a socket server for QEMU

TPM_PATH="$PWD/qemu_integration/tpm_state"
SOCKET_PATH="$TPM_PATH/swtpm.sock"

# Create TPM state directory if it doesn't exist
mkdir -p "$TPM_PATH"

# Kill any existing swtpm processes using this socket
pkill -f "swtpm.*$SOCKET_PATH" || true

# Remove old socket if it exists
rm -f "$SOCKET_PATH"

# Start swtpm in the foreground (no --daemon)
swtpm socket --tpm2 --ctrl type=unixio,path="$SOCKET_PATH" --tpmstate dir="$TPM_PATH" &
SWTPM_PID=$!

# Wait for socket to be created (max 10 seconds)
TIMEOUT=10
for i in $(seq 1 $TIMEOUT); do
    if [ -S "$SOCKET_PATH" ]; then
        echo "swtpm socket created at $SOCKET_PATH"
        chmod 666 "$SOCKET_PATH"
        echo "Socket permissions set to allow QEMU access"
        break
    fi
    if [ $i -eq $TIMEOUT ]; then
        echo "Socket not created after $TIMEOUT seconds, killing swtpm"
        kill $SWTPM_PID
        exit 1
    fi
    echo "Waiting for swtpm socket... ($i/$TIMEOUT)"
    sleep 1
done

echo "swtpm ready for QEMU connections (PID $SWTPM_PID)"
wait $SWTPM_PID
exit 0
