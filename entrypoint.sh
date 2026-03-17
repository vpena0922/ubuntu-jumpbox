#!/bin/bash
set -e

# Check if the SSH_PUBLIC_KEY variable is set
if [ -z "$SSH_PUBLIC_KEY" ]; then
  echo "ERROR: SSH_PUBLIC_KEY environment variable is not set."
  exit 1
fi

# Ensure the .ssh directory exists for the root user
mkdir -p /root/.ssh
chmod 700 /root/.ssh

# Write the key to authorized_keys
echo "$SSH_PUBLIC_KEY" > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

echo "SSH Key injected successfully."

# Start the SSH daemon in the foreground
exec /usr/sbin/sshd -D
