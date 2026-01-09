# Use a full Node image
FROM node:20-bookworm-slim

USER root

# Install Python and venv tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    tini \
    && rm -rf /var/lib/apt/lists/*

# Install n8n globally
RUN npm install -g n8n@latest

# Create the venv in the exact path n8n expects
RUN python3 -m venv /usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv

# Upgrade pip and install any packages you need for Code nodes
RUN /usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv/bin/python3 -m pip install --upgrade pip
# Example: install requests if your Python code uses it
RUN /usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv/bin/python3 -m pip install requests

# Fix ownership so n8n (node user) can execute the venv
RUN chown -R node:node /usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv

WORKDIR /home/node
USER node

ENV NODE_ENV=production
EXPOSE 5678

# ... earlier Dockerfile content (install, venv creation, etc.)

# Copy the entrypoint script and set ownership
COPY --chown=node:node entrypoint.sh /home/node/entrypoint.sh
RUN chmod +x /home/node/entrypoint.sh

WORKDIR /home/node
USER node

ENV NODE_ENV=production
EXPOSE 5678

ENTRYPOINT ["/home/node/entrypoint.sh"]

