# Use Python Debian base (has apt, Python, pip)
FROM python:3.11-slim

# Install Node.js and npm
RUN apt-get update && apt-get install -y curl gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install n8n globally
RUN npm install -g n8n@2.2.5

# Create the 'node' user (if not already)
RUN useradd -m -u 1000 node

# Set environment variables inside the image
ENV N8N_PYTHON_VENV_PATH=/home/node/.n8n-python-venv
ENV N8N_RUNNERS_ENABLED=false
ENV N8N_NATIVE_PYTHON_RUNNER=true

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

# Ensure the entire home directory is owned by node
RUN chown -R node:node /home/node

# Switch to the non-root user
USER node

EXPOSE 5678
CMD ["n8n", "start"]