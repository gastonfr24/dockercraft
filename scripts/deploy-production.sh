#!/bin/bash
# DockerCraft - Production Deployment Script
#
# Este script automatiza el deployment del servidor a producción
#
# Uso: sudo ./scripts/deploy-production.sh

set -e  # Exit on error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funciones de logging
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

# Banner
echo "=================================="
echo "🚀 DockerCraft Production Deployment"
echo "=================================="
echo ""

# 1. Verificar prerrequisitos
log_info "Verificando prerrequisitos..."

# Verificar Docker
if ! command -v docker &> /dev/null; then
    log_error "Docker no está instalado"
    echo "Instalar: https://docs.docker.com/get-docker/"
    exit 1
fi
log_success "Docker instalado: $(docker --version)"

# Verificar Docker Compose
if ! command -v docker compose &> /dev/null; then
    log_error "Docker Compose no está instalado"
    echo "Instalar: https://docs.docker.com/compose/install/"
    exit 1
fi
log_success "Docker Compose instalado: $(docker compose version)"

# Verificar que .env.production existe
if [ ! -f ".env.production" ]; then
    log_error ".env.production no encontrado"
    echo ""
    echo "Por favor:"
    echo "  1. cp docs/templates/env.production.template .env.production"
    echo "  2. Editar .env.production con tu configuración"
    echo "  3. Ejecutar este script nuevamente"
    exit 1
fi
log_success ".env.production encontrado"

# Verificar que whitelist.json existe
if [ ! -f "whitelist.json" ]; then
    log_warning "whitelist.json no encontrado, creando uno vacío..."
    echo "[]" > whitelist.json
fi
log_success "whitelist.json listo"

# Crear directorio de backups
if [ ! -d "backups" ]; then
    log_info "Creando directorio de backups..."
    mkdir -p backups
fi
log_success "Directorio de backups listo"

echo ""

# 2. Backup de datos existentes (si existen)
log_info "Verificando si hay datos existentes para backup..."
if docker volume inspect mc-data-prod &> /dev/null; then
    log_warning "Datos existentes detectados"
    read -p "¿Crear backup antes de continuar? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -f "./scripts/backup.sh" ]; then
            log_info "Creando backup..."
            ./scripts/backup.sh mc-server-prod || log_warning "Backup falló, pero continuando..."
        else
            log_warning "Script de backup no encontrado, saltando..."
        fi
    fi
fi

echo ""

# 3. Aplicar Security Hardening (opcional pero recomendado)
log_info "¿Aplicar security hardening? (Recomendado para primera vez)"
read -p "Aplicar security hardening? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f "./scripts/security-hardening.sh" ]; then
        log_info "Aplicando security hardening..."
        sudo ./scripts/security-hardening.sh || log_warning "Security hardening falló, pero continuando..."
    else
        log_warning "Security hardening script no encontrado"
    fi
fi

echo ""

# 4. Configurar Firewall (opcional pero MUY recomendado)
log_info "¿Configurar firewall? (Recomendado para primera vez)"
read -p "Configurar firewall UFW? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f "./scripts/configure-firewall-prod.sh" ]; then
        log_info "Configurando firewall..."
        sudo ./scripts/configure-firewall-prod.sh || log_warning "Firewall config falló, pero continuando..."
    else
        log_warning "Firewall script no encontrado"
    fi
fi

echo ""

# 5. Build de la imagen Docker
log_info "Construyendo imagen Docker..."
docker compose -f docker-compose.prod.yml build
log_success "Imagen construida exitosamente"

echo ""

# 6. Detener contenedor existente (si existe)
if docker ps -a --format '{{.Names}}' | grep -q "^mc-server-prod$"; then
    log_info "Deteniendo contenedor existente..."
    docker compose -f docker-compose.prod.yml down
    log_success "Contenedor existente detenido"
fi

echo ""

# 7. Levantar servicios en producción
log_info "Iniciando servicios en producción..."
docker compose --env-file .env.production -f docker-compose.prod.yml up -d
log_success "Servicios iniciados"

echo ""

# 8. Esperar a que el servidor esté listo
log_info "Esperando a que el servidor esté listo..."
echo "Esto puede tomar 1-2 minutos..."

# Esperar 30 segundos inicial
sleep 30

# Verificar health check (máximo 5 intentos)
for i in {1..5}; do
    HEALTH=$(docker inspect --format='{{.State.Health.Status}}' mc-server-prod 2>/dev/null || echo "none")
    if [ "$HEALTH" = "healthy" ]; then
        log_success "Servidor está saludable!"
        break
    else
        log_info "Intento $i/5: Servidor aún iniciando (health: $HEALTH)..."
        sleep 20
    fi
done

echo ""

# 9. Verificar estado
log_info "Estado de los servicios:"
docker compose -f docker-compose.prod.yml ps

echo ""

# 10. Mostrar logs recientes
log_info "Logs recientes del servidor:"
docker compose -f docker-compose.prod.yml logs --tail=30

echo ""

# 11. Información de conectividad
log_success "=================================="
log_success "✅ Deployment completado!"
log_success "=================================="
echo ""
echo "📊 Información del servidor:"
echo ""

# Obtener IP pública
PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null || echo "No se pudo obtener")
echo "  🌐 IP Pública: $PUBLIC_IP"
echo "  🔌 Puerto: 25565"
echo ""

echo "🎮 Para conectarte desde Minecraft:"
echo "  Dirección: $PUBLIC_IP:25565"
echo "  (O usar tu dominio si configuraste uno)"
echo ""

echo "📜 Comandos útiles:"
echo ""
echo "  # Ver logs en tiempo real"
echo "  docker compose -f docker-compose.prod.yml logs -f"
echo ""
echo "  # Ver estado"
echo "  docker compose -f docker-compose.prod.yml ps"
echo ""
echo "  # Ejecutar comando RCON"
echo "  docker exec mc-server-prod rcon-cli list"
echo ""
echo "  # Detener servidor"
echo "  docker compose -f docker-compose.prod.yml stop"
echo ""
echo "  # Reiniciar servidor"
echo "  docker compose -f docker-compose.prod.yml restart"
echo ""

log_warning "⚠️  IMPORTANTE:"
echo "  - Configura port forwarding en tu router (puerto 25565)"
echo "  - Verifica que el firewall permite el puerto 25565"
echo "  - Agrega jugadores a la whitelist con:"
echo "    docker exec mc-server-prod rcon-cli whitelist add <jugador>"
echo ""

log_info "🔍 Para verificar acceso público:"
echo "  curl -s https://api.mcsrvstat.us/2/$PUBLIC_IP:25565 | jq ."
echo ""

log_success "¡Deployment completado! 🎊"

