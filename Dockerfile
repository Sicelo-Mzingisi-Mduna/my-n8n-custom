# Use the Debian-based n8n image (includes apt-get)
FROM n8nio/n8n:debian

# Switch to root to install packages
USER root

# Install Python, pip, and venv support
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Ensure the directory n8n uses for Python virtual environments exists and is writable
RUN mkdir -p /usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv \
    && chown -R node:node /usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv

# Switch back to the non-root 'node' user
USER node