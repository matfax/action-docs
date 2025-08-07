FROM hairyhenderson/gomplate:v4.3.3-alpine

# Install git for repository operations
RUN apk add --no-cache git bash

# Copy the entrypoint script and default template
COPY entrypoint.sh /entrypoint.sh
COPY default.tpl /default.tpl
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]