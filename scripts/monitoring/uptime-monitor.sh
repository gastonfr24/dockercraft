#!/bin/bash
# Script de monitoreo de uptime para servidor Minecraft
#
# Verifica que el servidor esté respondiendo y envía alertas si está caído
#
# Uso: ./scripts/uptime-monitor.sh
# Cron: */5 * * * * /path/to/scripts/uptime-monitor.sh

# Configuración
SERVER_IP="${SERVER_PUBLIC_IP:-$(curl -s ifconfig.me)}"
SERVER_PORT="${SERVER_PORT:-25565}"
DISCORD_WEBHOOK="${DISCORD_WEBHOOK_URL}"
MAX_RETRIES=3
RETRY_DELAY=10

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Función para enviar alerta a Discord
send_discord_alert() {
    local message="$1"
    local level="$2"
    
    if [ -z "$DISCORD_WEBHOOK" ]; then
        return
    fi
    
    local color=""
    local icon=""
    
    case "$level" in
        "error")
            color="15158332"  # Rojo
            icon="🚨"
            ;;
        "warning")
            color="16776960"  # Amarillo
            icon="⚠️"
            ;;
        "success")
            color="3066993"   # Verde
            icon="✅"
            ;;
        *)
            color="3447003"   # Azul
            icon="ℹ️"
            ;;
    esac
    
    local json_payload=$(cat <<EOF
{
  "embeds": [
    {
      "title": "$icon DockerCraft - Servidor Minecraft",
      "description": "$message",
      "color": $color,
      "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%S.000Z)"
    }
  ]
}
EOF
    )
    
    curl -H "Content-Type: application/json" \
         -X POST \
         -d "$json_payload" \
         "$DISCORD_WEBHOOK" \
         --silent \
         --output /dev/null
}

# Función para verificar servidor
check_server() {
    # Intentar con netcat
    if command -v nc &> /dev/null; then
        nc -z -w5 "$SERVER_IP" "$SERVER_PORT" &>/dev/null
        return $?
    fi
    
    # Fallback: verificar con API
    if command -v curl &> /dev/null && command -v jq &> /dev/null; then
        RESPONSE=$(curl -s "https://api.mcsrvstat.us/2/${SERVER_IP}:${SERVER_PORT}" | jq -r '.online')
        if [ "$RESPONSE" = "true" ]; then
            return 0
        fi
    fi
    
    return 1
}

# Main
echo "🔍 Verificando servidor Minecraft..."
echo "  Servidor: $SERVER_IP:$SERVER_PORT"
echo ""

retries=0
while [ $retries -lt $MAX_RETRIES ]; do
    if check_server; then
        echo -e "${GREEN}✅ Servidor ONLINE${NC}"
        
        # Si está online, salir exitosamente
        exit 0
    fi
    
    retries=$((retries + 1))
    
    if [ $retries -lt $MAX_RETRIES ]; then
        echo -e "${YELLOW}⚠️  Intento $retries/$MAX_RETRIES fallido, reintentando en ${RETRY_DELAY}s...${NC}"
        sleep $RETRY_DELAY
    fi
done

# Si llegamos aquí, el servidor está DOWN
echo -e "${RED}❌ SERVIDOR CAÍDO${NC}"
echo "  No responde después de $MAX_RETRIES intentos"
echo ""

# Enviar alerta
MESSAGE="🚨 **SERVIDOR CAÍDO**\n\nEl servidor no responde en \`${SERVER_IP}:${SERVER_PORT}\`\n\nVerificar:\n- Container corriendo\n- Port forwarding\n- Firewall\n- Red"
send_discord_alert "$MESSAGE" "error"

echo "Alerta enviada (si webhook configurado)"
exit 1

