#!/bin/bash
# Script para testear acceso público al servidor Minecraft

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔍 Testing acceso público al servidor..."
echo ""

# Obtener IP pública
PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null || echo "")

if [ -z "$PUBLIC_IP" ]; then
    echo -e "${RED}❌ No se pudo obtener IP pública${NC}"
    exit 1
fi

echo -e "🌐 IP pública: ${GREEN}$PUBLIC_IP${NC}"
echo ""

# Test 1: Verificar puerto abierto con netcat
echo "📡 Test 1: Verificando puerto 25565..."
if command -v nc &> /dev/null; then
    if timeout 5 nc -zv "$PUBLIC_IP" 25565 2>&1 | grep -q "succeeded\|open"; then
        echo -e "  ${GREEN}✅ Puerto 25565 está abierto${NC}"
    else
        echo -e "  ${RED}❌ Puerto 25565 cerrado o inaccesible${NC}"
        echo "  Verifica:"
        echo "    - Port forwarding en router"
        echo "    - Firewall UFW"
        echo "    - Servidor corriendo"
    fi
else
    echo -e "  ${YELLOW}⚠️  netcat no instalado, saltando test${NC}"
fi

echo ""

# Test 2: Query mediante API externa
echo "🌍 Test 2: Query via mcsrvstat.us..."
RESPONSE=$(curl -s "https://api.mcsrvstat.us/2/$PUBLIC_IP:25565")

if echo "$RESPONSE" | jq -e '.online' &> /dev/null; then
    ONLINE=$(echo "$RESPONSE" | jq -r '.online')
    
    if [ "$ONLINE" = "true" ]; then
        echo -e "  ${GREEN}✅ Servidor ONLINE y accesible desde internet${NC}"
        
        PLAYERS=$(echo "$RESPONSE" | jq -r '.players.online // 0')
        MAX_PLAYERS=$(echo "$RESPONSE" | jq -r '.players.max // 0')
        VERSION=$(echo "$RESPONSE" | jq -r '.version // "unknown"')
        MOTD=$(echo "$RESPONSE" | jq -r '.motd.clean[0] // "N/A"')
        
        echo ""
        echo "  📊 Info del servidor:"
        echo "    Players: $PLAYERS/$MAX_PLAYERS"
        echo "    Version: $VERSION"
        echo "    MOTD: $MOTD"
    else
        echo -e "  ${RED}❌ Servidor OFFLINE o inaccesible${NC}"
    fi
else
    echo -e "  ${YELLOW}⚠️  No se pudo consultar API (jq no instalado?)${NC}"
fi

echo ""
echo "═══════════════════════════════════════"
echo "Para conectarte desde Minecraft:"
echo "  $PUBLIC_IP:25565"
echo "═══════════════════════════════════════"

