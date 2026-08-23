# mc

Universal Minecraft server Docker image with automatic server JAR download and startup configuration.

## Features

- Vanilla, Paper, Purpur, Folia, LeafMC
- Fabric, Forge, NeoForge, Quilt
- Velocity, Waterfall, BungeeCord
- Automatic JAR download from MCJarFiles endpoints
- Configurable server name, type, version, RAM, port and EULA
- Persistent `/minecraft` data volume
- Docker Compose support
- Automatic multi-architecture image builds and GHCR publishing

## Quick start

```bash
docker compose up -d --build
```

Create `.env` from `.env.example` and edit it:

```env
SERVER_NAME=My SMP
SERVER_TYPE=paper
SERVER_VERSION=latest
SERVER_RAM=4096
SERVER_PORT=25565
EULA=TRUE
```

The published image is available at:

```text
ghcr.io/nobita329/mc:latest
```

## Docker run

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

## Notes

The container downloads `server.jar` on first startup. Server files and world data are kept in `/minecraft`, so use a persistent volume.

Do not put GitHub tokens, API keys, or other secrets in the image or repository.
