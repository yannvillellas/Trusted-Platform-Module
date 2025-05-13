#!/bin/bash
# Script to start a QEMU VM with swtpm (software TPM) support

TPM_PATH="$PWD/qemu_integration/tpm_state"
SOCKET_PATH="$TPM_PATH/swtpm.sock"
VM_IMAGE="$PWD/qemu_integration/images/ubuntu-25.04-cloud.img"

# Check if the VM image exists, create it if it doesn't
if [ ! -f "$VM_IMAGE" ]; then
    echo "Creating VM disk image..."
    qemu-img create -f qcow2 "$VM_IMAGE" 8G
    echo "VM disk image created: $VM_IMAGE"
fi

# Check if the swtpm socket exists, prompt user to start swtpm if not
if [ ! -S "$SOCKET_PATH" ]; then
    echo "swtpm socket not found at $SOCKET_PATH."
    echo "Please run: make swtpm_start in another terminal."
    exit 1
fi

echo "Starting QEMU with swtpm TPM support..."

qemu-system-x86_64 \
    -m 2G \
    -smp 2 \
    -drive file="$VM_IMAGE",format=qcow2 \
    -drive file="$PWD/qemu_integration/seed.img",format=raw \
    -chardev socket,id=chrtpm,path="$SOCKET_PATH" \
    -tpmdev emulator,id=tpm0,chardev=chrtpm \
    -device tpm-tis,tpmdev=tpm0 \
    -netdev user,id=net0 \
    -device e1000,netdev=net0 \
    -display gtk \
    -serial stdio
