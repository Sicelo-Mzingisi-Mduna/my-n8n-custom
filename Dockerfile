# Use the official n8n image as base
FROM n8nio/n8n:latest

# Switch to root to install packages
USER root

# Install Python, pip, and any system dependencies you might need
RUN apk update && apk add --no-cache python3 py3-pip

# Ensure the directory n8n uses for Python virtual environments exists and is writable
RUN mkdir -p /usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv \
    && chown -R node:node /usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv

# Switch back to the non-root 'node' user (as recommended by n8n)
USER node