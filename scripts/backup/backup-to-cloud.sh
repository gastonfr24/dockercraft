#!/bin/bash
# Script para backup automático a la nube (Google Drive, Dropbox, AWS S3, etc)
#
# Requiere rclone configurado: rclone config
#
# Uso: ./scripts/backup-to-cloud.sh [container_name]

# Configuración
CONTAINER_NAME="${1:-mc-server-prod}"
BACKUP_DIR="./backups"
RCLONE_REMOTE="${RCLONE_REMOTE:-gdrive}"
RCLONE_REMOTE_DIR="${RCLONE_REMOTE_DIR:-minecraft-backups}"
RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-7}"

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "☁️  Backup a la nube - DockerCraft"
echo "====================================="
echo ""

# Verificar rclone
if ! command -v rclone &> /dev/null; then
    echo -e "${RED}❌ rclone no está instalado${NC}"
    echo ""
    echo "Instalar rclone:"
    echo "  sudo apt install rclone"
    echo "  o visita: https://rclone.org/install/"
    echo ""
    echo "Luego configurar:"
    echo "  rclone config"
    exit 1
fi

# Crear backup local
echo -e "${YELLOW}1. Creando backup local...${NC}"
if [ -f "./scripts/backup.sh" ]; then
    ./scripts/backup.sh "$CONTAINER_NAME"
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Backup local falló${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ scripts/backup.sh no encontrado${NC}"
    exit 1
fi

# Obtener el último backup
LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/*.tar.gz 2>/dev/null | head -1)

if [ -z "$LATEST_BACKUP" ]; then
    echo -e "${RED}❌ No se encontró backup para subir${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Backup local creado: $(basename "$LATEST_BACKUP")${NC}"
echo ""

# Upload a la nube
echo -e "${YELLOW}2. Subiendo a la nube...${NC}"
echo "  Remote: $RCLONE_REMOTE:$RCLONE_REMOTE_DIR"

rclone copy "$LATEST_BACKUP" "$RCLONE_REMOTE:$RCLONE_REMOTE_DIR" --progress

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Backup subido exitosamente${NC}"
else
    echo -e "${RED}❌ Falló el upload a la nube${NC}"
    exit 1
fi

echo ""

# Limpiar backups viejos locales
echo -e "${YELLOW}3. Limpiando backups viejos locales (>${RETENTION_DAYS} días)...${NC}"
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +${RETENTION_DAYS} -delete
echo -e "${GREEN}✅ Limpieza local completada${NC}"

echo ""

# Limpiar backups viejos en la nube (opcional)
echo -e "${YELLOW}4. Limpiando backups viejos en la nube (>${RETENTION_DAYS} días)...${NC}"
rclone delete "$RCLONE_REMOTE:$RCLONE_REMOTE_DIR" --min-age ${RETENTION_DAYS}d --rmdirs

echo ""
echo "====================================="
echo -e "${GREEN}✅ Backup a la nube completado${NC}"
echo "====================================="
echo ""
echo "Para ver backups en la nube:"
echo "  rclone ls $RCLONE_REMOTE:$RCLONE_REMOTE_DIR"
echo ""
echo "Para restaurar desde la nube:"
echo "  rclone copy $RCLONE_REMOTE:$RCLONE_REMOTE_DIR/backup-YYYYMMDD-HHMMSS.tar.gz ./backups/"
echo "  ./scripts/restore.sh ./backups/backup-YYYYMMDD-HHMMSS.tar.gz"

