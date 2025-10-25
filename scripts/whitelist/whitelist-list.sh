#!/bin/bash
# Script para listar jugadores en la whitelist

CONTAINER_NAME="${1:-mc-server-prod}"

echo "📋 Jugadores en la whitelist:"
echo ""

# Listar via RCON
docker exec "$CONTAINER_NAME" rcon-cli whitelist list

echo ""
echo "Para agregar jugador:"
echo "  ./scripts/whitelist-add.sh $CONTAINER_NAME <nombre>"
echo ""
echo "Para remover jugador:"
echo "  ./scripts/whitelist-remove.sh $CONTAINER_NAME <nombre>"

