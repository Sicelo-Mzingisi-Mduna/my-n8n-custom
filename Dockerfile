# Use the latest Debian-based n8n image
FROM n8nio/n8n:latest

# Switch to root to install system software
USER root

# Update the package list and install Python 3 and Pip
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# If you need to install python libraries (like requests or pandas),
# Debian now requires the '--break-system-packages' flag inside Docker:
# RUN pip3 install requests pandas --break-system-packages

# Switch back to the 'node' user for security
USER node