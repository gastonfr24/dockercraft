#!/bin/bash
# Script para remover jugadores de la whitelist

CONTAINER_NAME="${1:-mc-server-prod}"
PLAYER_NAME="$2"

if [ -z "$PLAYER_NAME" ]; then
  echo "Uso: $0 [container_name] <nombre_jugador>"
  echo "Ejemplo: $0 mc-server-prod Steve"
  exit 1
fi

echo "Removiendo $PLAYER_NAME de la whitelist..."

# Remover via RCON
docker exec "$CONTAINER_NAME" rcon-cli whitelist remove "$PLAYER_NAME"

# Backup del whitelist
docker cp "$CONTAINER_NAME":/data/whitelist.json ./whitelist.json 2>/dev/null

echo "✅ $PLAYER_NAME removido exitosamente"
echo ""
echo "Para verificar:"
echo "  docker exec $CONTAINER_NAME rcon-cli whitelist list"

