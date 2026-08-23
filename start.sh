#!/usr/bin/env bash
set -Eeuo pipefail

cd /minecraft

SERVER_NAME="${SERVER_NAME:-Minecraft Server}"
SERVER_TYPE="${SERVER_TYPE:-paper}"
SERVER_VERSION="${SERVER_VERSION:-latest}"
SERVER_RAM="${SERVER_RAM:-2048}"
SERVER_PORT="${SERVER_PORT:-25565}"
EULA="${EULA:-TRUE}"
JAVA_OPTS="${JAVA_OPTS:-}"

log() { echo "[Minecraft] $*"; }

case "${EULA^^}" in
  TRUE|YES|1) EULA_VALUE=true ;;
  *) EULA_VALUE=false ;;
esac

echo "eula=${EULA_VALUE}" > eula.txt

if [[ ! -f server.jar ]]; then
  API_TYPE=""
  API_VARIANT=""

  case "${SERVER_TYPE,,}" in
    vanilla) API_TYPE="vanilla"; API_VARIANT="release" ;;
    paper|purpur|folia|leafmc) API_TYPE="servers"; API_VARIANT="${SERVER_TYPE,,}" ;;
    fabric|forge|neoforge|quilt) API_TYPE="modded"; API_VARIANT="${SERVER_TYPE,,}" ;;
    velocity|waterfall|bungeecord) API_TYPE="proxies"; API_VARIANT="${SERVER_TYPE,,}" ;;
    *) log "Unsupported server type: ${SERVER_TYPE}"; exit 1 ;;
  esac

  if [[ "${SERVER_VERSION}" == "latest" ]]; then
    URL="https://mcjarfiles.com/api/get-latest-jar/${API_TYPE}/${API_VARIANT}"
  else
    URL="https://mcjarfiles.com/api/get-jar/${API_TYPE}/${API_VARIANT}/${SERVER_VERSION}"
  fi

  log "Downloading ${SERVER_TYPE} ${SERVER_VERSION}"
  curl --fail --location --show-error --retry 5 --retry-delay 2 --retry-all-errors \
    "${URL}" -o server.jar.tmp
  test -s server.jar.tmp
  mv server.jar.tmp server.jar
fi

# Keep the requested port/name in server.properties without deleting user settings.
touch server.properties
if grep -q '^motd=' server.properties; then
  sed -i "s#^motd=.*#motd=${SERVER_NAME//\/\\/}#" server.properties
else
  printf 'motd=%s\n' "$SERVER_NAME" >> server.properties
fi
if grep -q '^server-port=' server.properties; then
  sed -i "s/^server-port=.*/server-port=${SERVER_PORT}/" server.properties
else
  printf 'server-port=%s\n' "$SERVER_PORT" >> server.properties
fi

log "========================================="
log "Server Name : ${SERVER_NAME}"
log "Server Type : ${SERVER_TYPE}"
log "Version     : ${SERVER_VERSION}"
log "RAM         : ${SERVER_RAM} MB"
log "Port        : ${SERVER_PORT}"
log "========================================="

exec java ${JAVA_OPTS} \
  -Xms${SERVER_RAM}M \
  -Xmx${SERVER_RAM}M \
  -jar server.jar nogui
