#!/usr/bin/env bash
set -euo pipefail

cd /minecraft

SERVER_NAME="${SERVER_NAME:-Minecraft Server}"
SERVER_TYPE="${SERVER_TYPE:-paper}"
SERVER_VERSION="${SERVER_VERSION:-latest}"
SERVER_RAM="${SERVER_RAM:-2048}"
SERVER_PORT="${SERVER_PORT:-25565}"
EULA="${EULA:-TRUE}"

log() {
    echo "[Minecraft] $*"
}

log "========================================="
log "Server Name : ${SERVER_NAME}"
log "Server Type : ${SERVER_TYPE}"
log "Version     : ${SERVER_VERSION}"
log "RAM         : ${SERVER_RAM} MB"
log "Port        : ${SERVER_PORT}"
log "========================================="

case "${EULA^^}" in
    TRUE|YES|1)
        EULA_VALUE=true
        ;;
    *)
        EULA_VALUE=false
        ;;
esac

echo "eula=${EULA_VALUE}" > eula.txt

if [[ ! -f server.jar ]]; then
    API_TYPE=""
    API_VARIANT=""

    case "${SERVER_TYPE,,}" in
        vanilla)
            API_TYPE="vanilla"
            API_VARIANT="release"
            ;;
        paper|purpur|folia|leafmc)
            API_TYPE="servers"
            API_VARIANT="${SERVER_TYPE,,}"
            ;;
        fabric|forge|neoforge|quilt)
            API_TYPE="modded"
            API_VARIANT="${SERVER_TYPE,,}"
            ;;
        velocity|waterfall|bungeecord)
            API_TYPE="proxies"
            API_VARIANT="${SERVER_TYPE,,}"
            ;;
        *)
            log "Unsupported server type: ${SERVER_TYPE}"
            exit 1
            ;;
    esac

    if [[ "${SERVER_VERSION}" == "latest" ]]; then
        URL="https://mcjarfiles.com/api/get-latest-jar/${API_TYPE}/${API_VARIANT}"
    else
        URL="https://mcjarfiles.com/api/get-jar/${API_TYPE}/${API_VARIANT}/${SERVER_VERSION}"
    fi

    log "Downloading server JAR"
    log "${URL}"
    curl --fail --location --show-error --retry 3 --retry-delay 2 \
        "${URL}" -o server.jar
fi

if [[ ! -f server.properties ]]; then
    cat > server.properties <<EOF
motd=${SERVER_NAME}
server-port=${SERVER_PORT}
enable-query=true
EOF
else
    sed -i "s/^motd=.*/motd=${SERVER_NAME}/" server.properties || true
    if grep -q '^server-port=' server.properties; then
        sed -i "s/^server-port=.*/server-port=${SERVER_PORT}/" server.properties
    else
        echo "server-port=${SERVER_PORT}" >> server.properties
    fi
fi

log "Starting Minecraft server..."

exec java \
    -Xms${SERVER_RAM}M \
    -Xmx${SERVER_RAM}M \
    -jar server.jar nogui
