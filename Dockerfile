# Use a full Node image so we have access to apt-get
FROM node:20-bookworm-slim

USER root

# 1. Install Python, Pip, and the critical VENV package
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    tini \
    && rm -rf /var/lib/apt/lists/*

# 2. Install n8n globally
RUN npm install -g n8n@latest

# 3. PRE-CREATE the virtual environment where n8n expects it
# This prevents the "Virtual environment is missing" error
RUN python3 -m venv /usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv

# 4. Set permissions so the 'node' user can use it
RUN chown -R node:node /usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv

WORKDIR /home/node
USER node

ENV NODE_ENV=production
EXPOSE 5678

ENTRYPOINT ["tini", "--"]
CMD ["n8n", "start"]