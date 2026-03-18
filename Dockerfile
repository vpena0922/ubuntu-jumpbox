FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    curl \
    nano \
    # Starship often looks for a patched font, but in a headless 
    # SSH container, your LOCAL terminal handles the icons.
    git \ 
    openssh-server && \
    # Install Starship
    curl -sS https://starship.rs/install.sh | sh -s -- -y && \
    # Add the hook to the bashrc so it starts on login
    echo 'eval "$(starship init bash)"' >> /root/.bashrc && \
    mkdir -p /var/run/sshd && \
    # Standard hardening
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#KbdInteractiveAuthentication no/KbdInteractiveAuthentication no/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
