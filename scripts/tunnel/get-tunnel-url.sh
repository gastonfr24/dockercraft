#!/bin/bash
# Script para extraer URL del Cloudflare Tunnel de los logs de Docker
# DockerCraft - Get Tunnel URL

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Nombre del contenedor (puede pasarse como argumento)
CONTAINER_NAME="${1:-cloudflared-quick}"

echo -e "${YELLOW}🔍 Buscando URL del tunnel...${NC}"
echo ""

# Verificar que el contenedor existe
if ! docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo -e "${RED}❌ Error: Contenedor '${CONTAINER_NAME}' no encontrado${NC}"
    echo ""
    echo "Contenedores disponibles:"
    docker ps --format 'table {{.Names}}\t{{.Status}}'
    exit 1
fi

# Verificar que el contenedor está corriendo
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo -e "${RED}❌ Error: Contenedor '${CONTAINER_NAME}' no está corriendo${NC}"
    exit 1
fi

# Extraer URL de los logs
echo "Analizando logs del contenedor..."

# Intentar varias veces (el tunnel puede tardar en iniciar)
MAX_ATTEMPTS=30
ATTEMPT=0
URL=""

while [ $ATTEMPT -lt $MAX_ATTEMPTS ] && [ -z "$URL" ]; do
    # Buscar URL en logs
    URL=$(docker logs "$CONTAINER_NAME" 2>&1 | grep -oP 'https://[a-zA-Z0-9\-]+\.trycloudflare\.com' | head -1)
    
    if [ -z "$URL" ]; then
        ((ATTEMPT++))
        if [ $((ATTEMPT % 5)) -eq 0 ]; then
            echo -e "${YELLOW}⏳ Esperando... (${ATTEMPT}/${MAX_ATTEMPTS})${NC}"
        fi
        sleep 1
    fi
done

if [ -n "$URL" ]; then
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              ✅ URL DEL TUNNEL ENCONTRADA                  ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}🌐 URL Pública:${NC}"
    echo -e "${GREEN}   $URL${NC}"
    echo ""
    echo -e "📋 Comparte esta URL con tus amigos"
    echo -e "🎮 Conéctate desde Minecraft: ${YELLOW}Direct Connect${NC}"
    echo ""
    
    # Output limpio para scripts
    if [ "$2" = "--plain" ]; then
        echo "$URL"
    fi
    
    exit 0
else
    echo ""
    echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                  ❌ URL NO ENCONTRADA                      ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Posibles causas:${NC}"
    echo "  • El tunnel aún está iniciando"
    echo "  • El contenedor no tiene un tunnel activo"
    echo "  • Error en la conexión de Cloudflare"
    echo ""
    echo -e "${YELLOW}Comandos útiles:${NC}"
    echo "  • Ver logs: docker logs $CONTAINER_NAME"
    echo "  • Verificar estado: docker ps"
    echo ""
    exit 1
fi

