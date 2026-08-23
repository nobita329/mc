# Minecraft Docker Server

Universal Minecraft server image with automatic JAR download and startup configuration.

## Features

- Vanilla, Paper, Purpur, Folia, LeafMC
- Fabric, Forge, NeoForge, Quilt
- Velocity, Waterfall, BungeeCord
- Automatic server JAR download from MCJarFiles endpoints
- Configurable server name, type, version, RAM, port and EULA
- Persistent `/minecraft` data volume
- Docker Compose support
- GitHub Actions multi-architecture builds
- Automatic publish to GHCR

## Configuration

Set these environment variables:

```env
SERVER_NAME=My SMP
SERVER_TYPE=paper
SERVER_VERSION=latest
SERVER_RAM=4096
SERVER_PORT=25565
EULA=TRUE
```

## Docker Compose

```bash
docker compose up -d --build
```

The Compose file uses `./data:/minecraft` so worlds and server files persist outside the container.

## Docker

```bash
docker run -d \
  --name minecraft \
  -p 25565:25565 \
  -v mc-data:/minecraft \
  -e SERVER_NAME="My SMP" \
  -e SERVER_TYPE=paper \
  -e SERVER_VERSION=latest \
  -e SERVER_RAM=4096 \
  -e SERVER_PORT=25565 \
  -e EULA=TRUE \
  ghcr.io/nobita329/mc:latest
```

## Build locally

```bash
docker build -t mc-server .
docker run -d --name minecraft -p 25565:25565 -v mc-data:/minecraft -e EULA=TRUE mc-server
a```

## Important

The server JAR is downloaded when `server.jar` does not already exist. Existing data is reused on later starts.

Do not place GitHub tokens, API keys, or other secrets in the Docker image or repository.
