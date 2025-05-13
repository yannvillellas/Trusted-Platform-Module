#!/bin/bash
# Script to start a QEMU VM with TPM support

# Path to TPM state and VM image
TPM_PATH="$PWD/qemu_integration/tpm_state"
VM_IMAGE="$PWD/qemu_integration/images/ubuntu-25.04-cloud.img"
ISO_PATH=""

# Check if the VM image exists, create it if it doesn't
if [ ! -f "$VM_IMAGE" ]; then
    echo "Creating VM disk image..."
    qemu-img create -f qcow2 "$VM_IMAGE" 8G
    echo "VM disk image created: $VM_IMAGE"
fi

# Check if the TPM socket exists, start TPM if it doesn't
if [ ! -S "$TPM_PATH/tpm_simulator.sock" ]; then
    echo "Starting TPM emulator..."
    ./qemu_integration/start_tpm.sh &
    sleep 2
fi

echo "Starting QEMU with TPM support..."

# Start QEMU with TPM support and Ubuntu cloud image with cloud-init
qemu-system-x86_64 \
    -m 2G \
    -smp 2 \
    -drive file="$VM_IMAGE",format=qcow2 \
    -drive file="$PWD/qemu_integration/seed.img",format=raw \
    -chardev socket,id=chrtpm,path="$TPM_PATH/tpm_simulator.sock" \
    -tpmdev emulator,id=tpm0,chardev=chrtpm \
    -device tpm-tis,tpmdev=tpm0 \
    -netdev user,id=net0 \
    -device e1000,netdev=net0 \
    -display gtk \
    -serial stdio