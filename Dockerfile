FROM eclipse-temurin:21-jre-jammy

LABEL org.opencontainers.image.title="Universal Minecraft Server"
LABEL org.opencontainers.image.description="Custom Minecraft server container with automatic MCJarFiles download"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates bash tzdata \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /minecraft

COPY start.sh /usr/local/bin/start-minecraft
COPY HEALTHCHECK.sh /usr/local/bin/minecraft-healthcheck

RUN chmod +x /usr/local/bin/start-minecraft /usr/local/bin/minecraft-healthcheck

VOLUME ["/minecraft"]

EXPOSE 25565/tcp

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
    CMD ["/usr/local/bin/minecraft-healthcheck"]

ENTRYPOINT ["/usr/local/bin/start-minecraft"]
