# Use a full Node image
FROM node:20-bookworm-slim

USER root

# 1. Install Python and venv
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    tini \
    && rm -rf /var/lib/apt/lists/*

# 2. Install n8n
RUN npm install -g n8n@latest

# 3. Create the venv in a fixed, simple location
RUN python3 -m venv /opt/n8n_venv

# 4. Set permissions
RUN chown -R node:node /opt/n8n_venv

WORKDIR /home/node
USER node

ENV NODE_ENV=production
EXPOSE 5678

ENTRYPOINT ["tini", "--"]
CMD ["n8n", "start"]