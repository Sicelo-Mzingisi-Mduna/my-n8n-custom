# Use the official n8n Alpine image (includes Python venv and task runner setup)
FROM n8nio/n8n:2.2.5-alpine

# Switch to root to install additional packages
USER root

# Install any extra system packages if needed (not strictly required)
RUN apk add --no-cache python3 py3-pip

# The Python venv already exists at the path below.
# Install the additional Python libraries you'll use.
RUN /usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv/bin/pip install --no-cache-dir \
    requests \
    pandas \
    numpy \
    sqlalchemy \
    psycopg2-binary \
    pymongo \
    python-dotenv \
    openpyxl

# Ensure the venv remains owned by the 'node' user
RUN chown -R node:node /usr/local/lib/node_modules/n8n/node_modules/n8n-nodes-base/nodes/Code/python_venv

# Switch back to the non-root user
USER node