# Start with a clean Ubuntu base image
FROM ubuntu:latest

# Set environment variables for non-interactive commands
ENV DEBIAN_FRONTEND=noninteractive

# Update the package lists and install your desired applications
RUN apt-get update && \
    apt-get install -y \
    curl \
    openssh-client \
    nano \
    # Clean up to keep the image small
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the default command when the container runs
CMD ["/bin/bash"]
