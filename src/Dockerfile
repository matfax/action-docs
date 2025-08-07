FROM hairyhenderson/gomplate:v4.3.3-alpine

# Install git for repository operations
RUN apk add --no-cache git bash

WORKDIR /app

# Copy the entrypoint script and default template
COPY entrypoint.sh /app/entrypoint.sh
COPY default.tpl /app/default.tpl
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
