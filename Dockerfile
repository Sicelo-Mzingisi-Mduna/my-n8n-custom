FROM python:3.11-slim

# Install Node.js and npm
RUN apt-get update && apt-get install -y curl gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install n8n
RUN npm install -g n8n@2.2.5

# Create venv
ENV N8N_PYTHON_VENV_PATH=/usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv
RUN python3 -m venv $N8N_PYTHON_VENV_PATH \
    && $N8N_PYTHON_VENV_PATH/bin/pip install --no-cache-dir \
        requests pandas numpy sqlalchemy psycopg2-binary pymongo python-dotenv openpyxl

# Create node user and set ownership
RUN useradd -m -u 1000 node && chown -R node:node $N8N_PYTHON_VENV_PATH

USER node

EXPOSE 5678
CMD ["n8n", "start"]