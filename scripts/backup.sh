#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Script: backup.sh
# Purpose: Automated backup for Minecraft server worlds
# Usage: ./backup.sh [container_name] [backup_dir]
# Author: DockerCraft
# Date: 2024-10-24

# Constants
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DEFAULT_CONTAINER="mc-server-1"
readonly DEFAULT_BACKUP_DIR="/backups"
readonly RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-7}"
readonly COMPRESSION_LEVEL="${BACKUP_COMPRESSION_LEVEL:-6}"

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Logging functions
log_info() {
  echo -e "${BLUE}[INFO]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $*"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $*"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

# Check if container exists
container_exists() {
  local container_name="$1"
  
  if docker ps -a --format "{{.Names}}" | grep -q "^${container_name}$"; then
    return 0
  else
    return 1
  fi
}

# Check if container is running
is_container_running() {
  local container_name="$1"
  
  if docker ps --format "{{.Names}}" | grep -q "^${container_name}$"; then
    return 0
  else
    return 1
  fi
}

# Disable auto-save
disable_autosave() {
  local container_name="$1"
  
  log_info "Disabling auto-save..."
  
  if docker exec "$container_name" rcon-cli save-off >/dev/null 2>&1; then
    log_success "Auto-save disabled"
    return 0
  else
    log_warn "Could not disable auto-save (RCON may not be enabled)"
    return 1
  fi
}

# Force save
force_save() {
  local container_name="$1"
  
  log_info "Forcing save..."
  
  if docker exec "$container_name" rcon-cli save-all flush >/dev/null 2>&1; then
    log_success "Save completed"
    return 0
  else
    log_warn "Could not force save (RCON may not be enabled)"
    return 1
  fi
}

# Enable auto-save
enable_autosave() {
  local container_name="$1"
  
  log_info "Enabling auto-save..."
  
  if docker exec "$container_name" rcon-cli save-on >/dev/null 2>&1; then
    log_success "Auto-save enabled"
    return 0
  else
    log_warn "Could not enable auto-save (RCON may not be enabled)"
    return 1
  fi
}

# Create backup
create_backup() {
  local container_name="$1"
  local backup_dir="$2"
  local timestamp
  timestamp=$(date '+%Y%m%d_%H%M%S')
  local backup_filename="minecraft_backup_${timestamp}.tar.gz"
  local backup_path="${backup_dir}/${backup_filename}"
  
  log_info "Creating backup: ${backup_filename}"
  
  # Ensure backup directory exists
  mkdir -p "$backup_dir"
  
  # Get container's data directory
  local data_volume
  data_volume=$(docker inspect "$container_name" --format='{{range .Mounts}}{{if eq .Destination "/data"}}{{.Source}}{{end}}{{end}}')
  
  if [ -z "$data_volume" ]; then
    log_error "Could not find data volume for container $container_name"
    return 1
  fi
  
  log_info "Data volume: ${data_volume}"
  log_info "Compressing (level ${COMPRESSION_LEVEL})..."
  
  # Create compressed backup
  if tar -czf "$backup_path" -C "$(dirname "$data_volume")" "$(basename "$data_volume")" 2>/dev/null; then
    local backup_size
    backup_size=$(du -h "$backup_path" | cut -f1)
    log_success "Backup created: ${backup_filename} (${backup_size})"
    echo "$backup_path"
    return 0
  else
    log_error "Failed to create backup"
    return 1
  fi
}

# Cleanup old backups
cleanup_old_backups() {
  local backup_dir="$1"
  local retention_days="$2"
  
  log_info "Cleaning up backups older than ${retention_days} days..."
  
  local count=0
  while IFS= read -r -d '' file; do
    log_info "Deleting old backup: $(basename "$file")"
    rm -f "$file"
    count=$((count + 1))
  done < <(find "$backup_dir" -name "minecraft_backup_*.tar.gz" -type f -mtime +"$retention_days" -print0 2>/dev/null)
  
  if [ $count -gt 0 ]; then
    log_success "Deleted $count old backup(s)"
  else
    log_info "No old backups to delete"
  fi
}

# List backups
list_backups() {
  local backup_dir="$1"
  
  log_info "Available backups in ${backup_dir}:"
  echo ""
  
  if [ ! -d "$backup_dir" ] || [ -z "$(ls -A "$backup_dir"/minecraft_backup_*.tar.gz 2>/dev/null)" ]; then
    echo "No backups found"
    return 0
  fi
  
  local count=0
  while IFS= read -r file; do
    local size
    local date
    size=$(du -h "$file" | cut -f1)
    date=$(stat -c %y "$file" 2>/dev/null | cut -d'.' -f1)
    
    if [ -z "$date" ]; then
      # macOS/BSD stat
      date=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$file" 2>/dev/null)
    fi
    
    printf "  %s  %6s  %s\n" "$date" "$size" "$(basename "$file")"
    count=$((count + 1))
  done < <(find "$backup_dir" -name "minecraft_backup_*.tar.gz" -type f 2>/dev/null | sort -r)
  
  echo ""
  log_info "Total backups: $count"
}

# Main backup function
perform_backup() {
  local container_name="$1"
  local backup_dir="$2"
  
  log_info "Starting backup for container: ${container_name}"
  log_info "Backup directory: ${backup_dir}"
  log_info "Retention: ${RETENTION_DAYS} days"
  echo ""
  
  # Check if container exists
  if ! container_exists "$container_name"; then
    log_error "Container ${container_name} does not exist"
    return 1
  fi
  
  # Check if container is running
  if ! is_container_running "$container_name"; then
    log_error "Container ${container_name} is not running"
    return 1
  fi
  
  # Perform backup with RCON commands
  local autosave_disabled=false
  
  if disable_autosave "$container_name"; then
    autosave_disabled=true
    sleep 1
  fi
  
  force_save "$container_name"
  sleep 2
  
  # Create backup
  local backup_path
  if backup_path=$(create_backup "$container_name" "$backup_dir"); then
    log_success "Backup completed successfully"
    echo ""
    
    # Re-enable auto-save
    if [ "$autosave_disabled" = true ]; then
      enable_autosave "$container_name"
    fi
    
    # Cleanup old backups
    cleanup_old_backups "$backup_dir" "$RETENTION_DAYS"
    
    echo ""
    log_success "Backup process finished"
    return 0
  else
    log_error "Backup failed"
    
    # Re-enable auto-save even on failure
    if [ "$autosave_disabled" = true ]; then
      enable_autosave "$container_name"
    fi
    
    return 1
  fi
}

# Show usage
show_usage() {
  cat << EOF
Usage: $0 [OPTIONS] [CONTAINER_NAME] [BACKUP_DIR]

Automated backup for Minecraft server worlds.

Arguments:
  CONTAINER_NAME    Name of the container (default: ${DEFAULT_CONTAINER})
  BACKUP_DIR        Backup directory path (default: ${DEFAULT_BACKUP_DIR})

Options:
  -l, --list        List available backups
  -h, --help        Show this help message

Environment Variables:
  BACKUP_RETENTION_DAYS      Days to keep backups (default: 7)
  BACKUP_COMPRESSION_LEVEL   Compression level 1-9 (default: 6)

Examples:
  $0                                    # Backup default container
  $0 mc-server-1 /backups               # Backup specific container
  $0 -l                                 # List backups
  BACKUP_RETENTION_DAYS=14 $0           # Keep backups for 14 days

EOF
}

# Main execution
main() {
  local container_name="${DEFAULT_CONTAINER}"
  local backup_dir="${DEFAULT_BACKUP_DIR}"
  local list_mode=false
  
  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help)
        show_usage
        exit 0
        ;;
      -l|--list)
        list_mode=true
        shift
        ;;
      *)
        if [ -z "${container_name}" ] || [ "${container_name}" = "${DEFAULT_CONTAINER}" ]; then
          container_name="$1"
        elif [ -z "${backup_dir}" ] || [ "${backup_dir}" = "${DEFAULT_BACKUP_DIR}" ]; then
          backup_dir="$1"
        fi
        shift
        ;;
    esac
  done
  
  # Check if Docker is available
  if ! command -v docker >/dev/null 2>&1; then
    log_error "Docker is not installed or not in PATH"
    exit 1
  fi
  
  if ! docker info >/dev/null 2>&1; then
    log_error "Docker daemon is not running"
    exit 1
  fi
  
  echo "========================================" 
  echo "   Minecraft Server Backup"
  echo "========================================"
  echo ""
  
  if [ "$list_mode" = true ]; then
    list_backups "$backup_dir"
    exit 0
  fi
  
  perform_backup "$container_name" "$backup_dir"
}

main "$@"

