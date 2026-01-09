# Use a full Node image
FROM node:20-bookworm-slim

USER root

# Install system packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    tini \
    && rm -rf /var/lib/apt/lists/*

# Install n8n, create both candidate venvs, install runner + packages, set ownership/permissions
RUN npm install -g n8n@latest \
 && python3 -m venv /usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv \
 && /usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv/bin/python3 -m pip install --upgrade pip requests n8n-python-runner \
 && python3 -m venv /usr/local/lib/node_modules/n8n-nodes-base/nodes/Code/python_venv \
 && /usr/local/lib/node_modules/n8n-nodes-base/nodes/Code/python_venv/bin/python3 -m pip install --upgrade pip requests n8n-python-runner \
 && chown -R node:node /usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv \
 && chown -R node:node /usr/local/lib/node_modules/n8n-nodes-base/nodes/Code/python_venv \
 && chmod -R a+rx /usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv/bin \
 && chmod -R a+rx /usr/local/lib/node_modules/n8n-nodes-base/nodes/Code/python_venv/bin

# Copy entrypoint diagnostics script and make executable
COPY --chown=node:node entrypoint.sh /home/node/entrypoint.sh
RUN chmod +x /home/node/entrypoint.sh

WORKDIR /home/node
USER node

ENV NODE_ENV=production
EXPOSE 5678

ENTRYPOINT ["/home/node/entrypoint.sh"]
