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
    # 1. 💡 REVERT PERMIT ROOT LOGIN TO PROHIBIT-PASSWORD
    #    This ensures key-based login is allowed, but passwords are not.
    && sed -i 's/PermitRootLogin yes/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config \
    # 2. 💡 REMOVE THE TEMPORARY PASSWORD LINE
    #    (This line is unnecessary if you are using keys)
    # 3. DISABLE TTY CHECK (REQUIRED FOR NON-INTERACTIVE DOCKER ENVIRONMENTS)
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    # Clean up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Expose the default SSH port (Documentation only)
EXPOSE 22

# Start the SSH server process in the foreground
CMD ["/usr/sbin/sshd", "-D"]
