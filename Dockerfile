FROM hairyhenderson/gomplate:v4.3.3-alpine

# Install git for repository operations
RUN apk add --no-cache git bash

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
