# Use a standard Debian-based Node image (allows apt-get)
FROM node:20-bookworm-slim

# Switch to root to install system packages
USER root

# Install Python, Pip, and Tini (required for n8n to handle processes correctly)
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    tini \
    && rm -rf /var/lib/apt/lists/*

# Install n8n globally via npm
RUN npm install -g n8n@latest

# Set up the environment
ENV NODE_ENV=production
WORKDIR /home/node
EXPOSE 5678

# Run as the 'node' user for security
USER node

# Use tini to manage the n8n process
ENTRYPOINT ["tini", "--"]
CMD ["n8n", "start"]