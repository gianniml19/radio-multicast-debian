FROM debian:stable-slim

# Prevent interactive install prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install ffmpeg and required tools
# --no-install-recommends keeps the image minimal
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        bash \   
        ca-certificates \
        sed \              
        curl \            
        procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy startup script into the image
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Working directory where playlist and optional audio files will be located
WORKDIR /data

# Default entrypoint: run the stream launcher script
ENTRYPOINT ["/usr/local/bin/start.sh"]
