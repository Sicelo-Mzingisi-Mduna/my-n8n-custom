# Use the latest version of n8n (v2.x is recommended as of 2026)
FROM n8nio/n8n:latest

# Switch to root to install system-level software
USER root

# Install Python 3 and the pip package manager
RUN apk add --update --no-cache python3 py3-pip

# (Optional) If you need specific libraries like 'requests' or 'pandas', 
# uncomment the line below:
# RUN pip install --no-cache-dir --break-system-packages requests pandas

# Switch back to the 'node' user for safety
USER node