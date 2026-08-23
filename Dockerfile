FROM eclipse-temurin:21-jre-jammy

LABEL org.opencontainers.image.title="Universal Minecraft Server"
LABEL org.opencontainers.image.description="Custom Minecraft server container with automatic MCJars download"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates jq tzdata \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /minecraft

COPY start.sh /usr/local/bin/start-minecraft
RUN chmod +x /usr/local/bin/start-minecraft

VOLUME ["/minecraft"]

EXPOSE 25565/tcp

ENTRYPOINT ["/usr/local/bin/start-minecraft"]
