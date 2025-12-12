FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# Install utilities and the SSH server package
RUN apt-get update && \
    apt-get install -y \
    curl \
    nano \
    openssh-server \
    # Ensure the SSH server directory exists
    && mkdir -p /var/run/sshd \
    \
    # 💡 1. SET PermitRootLogin to prohibit-password (uncommented)
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config \
    \
    # 💡 2. DISABLE Password Authentication (uncommented and set to 'no')
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config \
    \
    # 💡 3. DISABLE KbdInteractiveAuthentication (uncommented and set to 'no')
    #    This is necessary to override PAM's behavior
    && sed -i 's/#KbdInteractiveAuthentication no/KbdInteractiveAuthentication no/' /etc/ssh/sshd_config \
    \
    # 4. Disable TTY Check (needed for container environments)
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    \
    # Clean up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Expose the default SSH port (Documentation only)
EXPOSE 22

# Start the SSH server process in the foreground
CMD ["/usr/sbin/sshd", "-D"]
