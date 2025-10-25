#!/bin/bash
# DockerCraft - Production Firewall Configuration
#
# Configura UFW (Uncomplicated Firewall) para servidor público de Minecraft
#
# IMPORTANTE: Este script debe ejecutarse con sudo

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

echo "==============================="
echo "🛡️  Configuración de Firewall"
echo "==============================="
echo ""

# 1. Instalar UFW si no está instalado
log_info "Verificando UFW..."
if ! command -v ufw &> /dev/null; then
    log_warning "UFW no está instalado, instalando..."
    apt update
    apt install -y ufw
    log_success "UFW instalado"
else
    log_success "UFW ya está instalado"
fi

echo ""

# 2. Reset UFW (limpiar reglas anteriores)
log_warning "⚠️  Se resetearán las reglas existentes"
read -p "¿Continuar? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "Operación cancelada"
    exit 0
fi

log_info "Reseteando UFW..."
ufw --force reset
log_success "UFW reseteado"

echo ""

# 3. Configurar políticas por defecto
log_info "Configurando políticas por defecto..."
ufw default deny incoming
ufw default allow outgoing
log_success "Políticas por defecto: DENY incoming, ALLOW outgoing"

echo ""

# 4. Permitir SSH (¡IMPORTANTE! - No te bloquees)
log_warning "⚠️  CRÍTICO: Permitiendo SSH"
SSH_PORT=$(ss -tlnp | grep sshd | grep -oP ':\K[0-9]+' | head -1 || echo "22")
ufw allow "${SSH_PORT}/tcp" comment 'SSH'
log_success "Puerto SSH ($SSH_PORT) permitido"

echo ""

# 5. Permitir Minecraft
log_info "Permitiendo puerto de Minecraft..."
ufw allow 25565/tcp comment 'Minecraft Server TCP'
ufw allow 25565/udp comment 'Minecraft Server UDP'
log_success "Puerto 25565 (TCP/UDP) permitido"

echo ""

# 6. Rate limiting para Minecraft (Anti-DDoS básico)
log_info "Configurando rate limiting para anti-DDoS..."
ufw limit 25565/tcp
log_success "Rate limiting activado en puerto 25565"

echo ""

# 7. Permitir Docker (redes internas)
log_info "Permitiendo redes Docker internas..."
ufw allow from 172.16.0.0/12 to any comment 'Docker networks'
log_success "Redes Docker permitidas"

echo ""

# 8. RCON - Verificar que NO está expuesto
log_info "Verificando que RCON (25575) NO está expuesto..."
if ss -tlnp | grep -q ":25575.*0.0.0.0"; then
    log_warning "⚠️  RCON parece estar expuesto en 0.0.0.0!"
    log_warning "Verifica docker-compose.prod.yml y asegúrate de usar:"
    log_warning "  - \"127.0.0.1:25575:25575\""
fi
log_info "RCON no se expondrá públicamente (bloqueado por firewall)"

echo ""

# 9. Habilitar UFW
log_info "Habilitando UFW..."
ufw --force enable
log_success "UFW habilitado"

echo ""

# 10. Mostrar estado
log_info "Estado final del firewall:"
ufw status verbose

echo ""

# 11. Mostrar reglas numeradas
log_info "Reglas configuradas:"
ufw status numbered

echo ""

log_success "==============================="
log_success "✅ Firewall configurado correctamente"
log_success "==============================="
echo ""

log_info "📋 Resumen de puertos:"
echo "  ✅ SSH ($SSH_PORT) - ABIERTO"
echo "  ✅ Minecraft (25565) - ABIERTO con rate limiting"
echo "  ❌ RCON (25575) - CERRADO (solo localhost)"
echo "  ❌ Todo lo demás - CERRADO"
echo ""

log_warning "⚠️  IMPORTANTE:"
echo "  - Asegúrate de que puedes conectarte via SSH antes de cerrar esta sesión"
echo "  - El puerto 25565 tiene rate limiting para prevenir DDoS básicos"
echo "  - Si necesitas abrir más puertos, usa:"
echo "    sudo ufw allow <puerto>/tcp comment 'Descripción'"
echo ""

log_info "Para modificar reglas:"
echo "  Ver estado: sudo ufw status numbered"
echo "  Eliminar regla: sudo ufw delete <número>"
echo "  Deshabilitar: sudo ufw disable"
echo ""

log_success "¡Configuración completada! 🛡️"

