FROM golang:1.16.2-alpine3.13 as builder
WORKDIR /app
COPY . ./
# This is where one could build the application code as well.

FROM ubuntu:22.04
RUN apt-get update && \
    apt-get install -y ca-certificates && \
    apt-get install -y bash && \
    apt-get install -y wget && \
    apt-get install -y systemctl && \
    apt-get install -y curl && \
    apt-get install -y unzip&& \
    rm -rf /var/lib/apt/lists/*

RUN curl -L -o easytier-core.zip https://github.com/EasyTier/EasyTier/releases/download/v2.3.2/easytier-linux-x86_64-v2.3.2.zip \
    && unzip -j -d /easytier easytier-core.zip \
    && rm -f easytier-core.zip \
    && chmod +x /easytier/easytier-cli \
    && chmod +x /easytier/easytier-web \
    && chmod +x /easytier/easytier-core

# Copy binary to production image.
COPY --from=builder /app/start.sh /app/start.sh

# Change start.sh to be executable
RUN chmod +x /app/start.sh

# Run on container startup.
CMD ["/app/start.sh"]
