#!/bin/bash
# DockerCraft - Fail2Ban Installation and Configuration
#
# Instala y configura Fail2Ban para protección anti-DDoS básica
#
# IMPORTANTE: Ejecutar con sudo

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar que se ejecuta como root
if [[ $EUID -ne 0 ]]; then
   log_error "Este script debe ejecutarse con sudo"
   exit 1
fi

echo "========================================="
echo "🚫 Instalación de Fail2Ban (Anti-DDoS)"
echo "========================================="
echo ""

# 1. Instalar Fail2Ban
log_info "Instalando Fail2Ban..."
apt update
apt install -y fail2ban
log_success "Fail2Ban instalado"

echo ""

# 2. Crear configuración para Minecraft
log_info "Configurando Fail2Ban para Minecraft..."

# Jail de Minecraft
cat > /etc/fail2ban/jail.d/minecraft.conf <<'EOF'
#
# Fail2Ban configuration for Minecraft Server
#

[minecraft-auth]
enabled = true
port = 25565
filter = minecraft-auth
logpath = /var/lib/docker/volumes/mc-data-prod/_data/logs/latest.log
maxretry = 5
bantime = 3600
findtime = 600
action = iptables-allports[name=minecraft-auth]

[minecraft-rcon]
enabled = true
port = 25575
filter = minecraft-rcon
logpath = /var/lib/docker/volumes/mc-data-prod/_data/logs/latest.log
maxretry = 3
bantime = 7200
findtime = 300
action = iptables-allports[name=minecraft-rcon]
EOF

log_success "Jail de Minecraft creado"

echo ""

# 3. Crear filtros personalizados
log_info "Creando filtros personalizados..."

# Filtro para auth failures
cat > /etc/fail2ban/filter.d/minecraft-auth.conf <<'EOF'
#
# Fail2Ban filter for Minecraft authentication failures
#

[Definition]
failregex = <HOST>.*lost connection
            <HOST>.*disconnected
            com.mojang.authlib.GameProfile.*<HOST>.*lost connection
ignoreregex =
EOF

# Filtro para RCON
cat > /etc/fail2ban/filter.d/minecraft-rcon.conf <<'EOF'
#
# Fail2Ban filter for Minecraft RCON
#

[Definition]
failregex = Rcon connection from <HOST>
            RCON.*<HOST>.*authentication failed
ignoreregex =
EOF

log_success "Filtros creados"

echo ""

# 4. Configuración global de Fail2Ban
log_info "Configurando parámetros globales..."

cat > /etc/fail2ban/jail.local <<'EOF'
[DEFAULT]
# Ban por 1 hora por defecto
bantime = 3600

# Ventana de tiempo de 10 minutos
findtime = 600

# 5 intentos máximos
maxretry = 5

# Backend
backend = auto

# Email alerts (configurar si se desea)
# destemail = admin@example.com
# sendername = Fail2Ban
# action = %(action_mwl)s
EOF

log_success "Configuración global aplicada"

echo ""

# 5. Reiniciar Fail2Ban
log_info "Reiniciando Fail2Ban..."
systemctl restart fail2ban
systemctl enable fail2ban
log_success "Fail2Ban iniciado y habilitado"

echo ""

# 6. Verificar status
log_info "Verificando status de Fail2Ban..."
systemctl status fail2ban --no-pager | head -10

echo ""

# 7. Verificar jails activos
log_info "Jails activos:"
fail2ban-client status

echo ""

log_success "========================================="
log_success "✅ Fail2Ban configurado correctamente"
log_success "========================================="
echo ""

log_info "📋 Configuración aplicada:"
echo "  - Jail: minecraft-auth (puerto 25565)"
echo "  - Jail: minecraft-rcon (puerto 25575)"
echo "  - Ban time: 1 hora (3600s)"
echo "  - Max retry: 5 intentos"
echo "  - Find time: 10 minutos (600s)"
echo ""

log_info "🔍 Comandos útiles:"
echo "  # Ver status general"
echo "  sudo fail2ban-client status"
echo ""
echo "  # Ver jail específico"
echo "  sudo fail2ban-client status minecraft-auth"
echo ""
echo "  # Ver IPs baneadas"
echo "  sudo fail2ban-client status minecraft-auth | grep 'Banned IP'"
echo ""
echo "  # Desbanear IP"
echo "  sudo fail2ban-client set minecraft-auth unbanip <IP>"
echo ""
echo "  # Ver logs de Fail2Ban"
echo "  sudo tail -f /var/log/fail2ban.log"
echo ""

log_warning "⚠️  NOTA:"
echo "  - Fail2Ban monitoreará los logs de Docker"
echo "  - Asegúrate de que el volumen mc-data-prod existe"
echo "  - Las IPs se banean automáticamente después de múltiples intentos fallidos"
echo ""

log_success "¡Protección anti-DDoS activada! 🛡️"

