# Use Python Debian base (has apt, Python, pip)
FROM python:3.11-slim

# Install Node.js and npm
RUN apt-get update && apt-get install -y curl gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install n8n globally
RUN npm install -g n8n@2.2.5

# Create the 'node' user
RUN useradd -m -u 1000 node

# Set the path n8n's internal task runner expects
ENV N8N_PYTHON_VENV_PATH=/usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv

# Force the legacy Python runner (no task runner)
ENV N8N_RUNNERS_ENABLED=false
ENV N8N_RUNNERS_MODE=external

# Create the virtual environment and install required Python packages
RUN python3 -m venv $N8N_PYTHON_VENV_PATH \
    && $N8N_PYTHON_VENV_PATH/bin/pip install --no-cache-dir \
        requests \
        pandas \
        numpy \
        sqlalchemy \
        psycopg2-binary \
        pymongo \
        python-dotenv \
        openpyxl

# Ensure the entire n8n installation directory is owned by node
RUN chown -R node:node /usr/local/lib/node_modules/n8n

# Switch to the non-root user
USER node

EXPOSE 5678
CMD ["n8n", "start"]