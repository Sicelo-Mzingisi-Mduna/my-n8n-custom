# Use Python Alpine as base (includes apk, Python, pip)
FROM python:3.11-alpine

# Install Node.js and npm
RUN apk add --no-cache nodejs npm

# Install n8n globally (use a specific version if you want, e.g., n8n@2.2.5)
RUN npm install -g n8n@2.2.5

# Set the same environment variable paths as before
ENV N8N_PYTHON_VENV_PATH=/usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv

# Create the 'node' user (if it doesn't already exist)
RUN adduser -D -u 1000 node

# Create the virtual environment directory and set ownership to the node user
RUN mkdir -p $N8N_PYTHON_VENV_PATH && chown -R node:node $N8N_PYTHON_VENV_PATH

# Switch to the non-root 'node' user
USER node

# Expose n8n port
EXPOSE 5678

# Start n8n
CMD ["n8n", "start"]