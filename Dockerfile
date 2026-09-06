# Use the Alpine-based n8n image version you originally had
FROM n8nio/n8n:2.2.5

# Switch to root to install packages
USER root

# Install Python, pip, and venv support
RUN apk update && apk add --no-cache \
    python3 \
    py3-pip \
    && rm -rf /var/cache/apk/*

# Ensure the directory n8n uses for Python virtual environments exists and is writable
RUN mkdir -p /usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv \
    && chown -R node:node /usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv

# Switch back to the non-root 'node' user
USER node