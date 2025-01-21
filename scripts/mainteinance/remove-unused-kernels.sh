#!/bin/bash

# Get the current kernel version
current_kernel=$(uname -r)
echo "Current kernel: $current_kernel"

# List all installed kernels
installed_kernels=$(dpkg --list | grep linux-image | grep -E '^ii' | awk '{print $2}')
echo "Installed kernels:"
echo "$installed_kernels"

# Iterate through the installed kernels
echo "Removing old kernels..."
for kernel in $installed_kernels; do
    if [[ "$kernel" != *"$current_kernel"* ]]; then
        echo "Removing: $kernel"
        sudo apt-get remove --purge -y "$kernel"
    else
        echo "Skipping current kernel: $kernel"
    fi
done

# Clean up residual dependencies
echo "Running autoremove to clean up..."
sudo apt autoremove -y

echo "Done! All unused kernels have been removed."
