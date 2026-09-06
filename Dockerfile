# Use Debian-based Python image for better package compatibility
FROM python:3.11-slim

# Install system dependencies: Node.js, npm, and any required build tools
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install n8n globally (keep the same version you had)
RUN npm install -g n8n@2.2.5

# Set the virtual environment path (same as your Render env var)
ENV N8N_PYTHON_VENV_PATH=/usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv

# Create the 'node' user
RUN useradd -m -u 1000 node

# Create the Python virtual environment and install common libraries
RUN python3 -m venv $N8N_PYTHON_VENV_PATH \
    && $N8N_PYTHON_VENV_PATH/bin/pip install --no-cache-dir \
        requests \
        pandas \
        numpy \
        sqlalchemy \
        psycopg2-binary \
        pymongo \
        python-dotenv \
        openpyxl \
    && chown -R node:node $N8N_PYTHON_VENV_PATH

# Switch to the non-root 'node' user
USER node

# Expose n8n port
EXPOSE 5678

# Start n8n
CMD ["n8n", "start"]