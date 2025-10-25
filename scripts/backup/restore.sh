#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Script: restore.sh
# Purpose: Restore Minecraft server from backup
# Usage: ./restore.sh [backup_file] [container_name]
# Author: DockerCraft
# Date: 2024-10-24

# Constants
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DEFAULT_CONTAINER="mc-server-1"
readonly DRY_RUN="${DRY_RUN:-false}"

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

# Validate backup file
validate_backup() {
  local backup_file="$1"
  
  log_info "Validating backup file..."
  
  if [ ! -f "$backup_file" ]; then
    log_error "Backup file not found: $backup_file"
    return 1
  fi
  
  if [[ ! "$backup_file" =~ \.tar\.gz$ ]]; then
    log_error "Backup file must be a .tar.gz file"
    return 1
  fi
  
  if ! tar -tzf "$backup_file" >/dev/null 2>&1; then
    log_error "Backup file is corrupted or invalid"
    return 1
  fi
  
  log_success "Backup file is valid"
  return 0
}

# Stop container
stop_container() {
  local container_name="$1"
  
  log_info "Stopping container: ${container_name}..."
  
  if docker stop "$container_name" >/dev/null 2>&1; then
    log_success "Container stopped"
    return 0
  else
    log_error "Failed to stop container"
    return 1
  fi
}

# Start container
start_container() {
  local container_name="$1"
  
  log_info "Starting container: ${container_name}..."
  
  if docker start "$container_name" >/dev/null 2>&1; then
    log_success "Container started"
    return 0
  else
    log_error "Failed to start container"
    return 1
  fi
}

# Backup current data
backup_current_data() {
  local container_name="$1"
  local timestamp
  timestamp=$(date '+%Y%m%d_%H%M%S')
  local safety_backup="/tmp/minecraft_safety_backup_${timestamp}.tar.gz"
  
  log_info "Creating safety backup of current data..."
  
  # Get container's data volume
  local data_volume
  data_volume=$(docker inspect "$container_name" --format='{{range .Mounts}}{{if eq .Destination "/data"}}{{.Source}}{{end}}{{end}}')
  
  if [ -z "$data_volume" ]; then
    log_error "Could not find data volume"
    return 1
  fi
  
  if tar -czf "$safety_backup" -C "$(dirname "$data_volume")" "$(basename "$data_volume")" 2>/dev/null; then
    log_success "Safety backup created: ${safety_backup}"
    echo "$safety_backup"
    return 0
  else
    log_error "Failed to create safety backup"
    return 1
  fi
}

# Restore backup
restore_backup() {
  local backup_file="$1"
  local container_name="$2"
  
  log_info "Restoring backup..."
  
  # Get container's data volume
  local data_volume
  data_volume=$(docker inspect "$container_name" --format='{{range .Mounts}}{{if eq .Destination "/data"}}{{.Source}}{{end}}{{end}}')
  
  if [ -z "$data_volume" ]; then
    log_error "Could not find data volume"
    return 1
  fi
  
  local volume_parent
  volume_parent=$(dirname "$data_volume")
  
  log_info "Extracting backup to: ${data_volume}"
  
  if tar -xzf "$backup_file" -C "$volume_parent" 2>/dev/null; then
    log_success "Backup restored successfully"
    return 0
  else
    log_error "Failed to restore backup"
    return 1
  fi
}

# Show usage
show_usage() {
  cat << EOF
Usage: $0 [OPTIONS] <BACKUP_FILE> [CONTAINER_NAME]

Restore Minecraft server from backup.

Arguments:
  BACKUP_FILE       Path to backup file (.tar.gz)
  CONTAINER_NAME    Name of the container (default: ${DEFAULT_CONTAINER})

Options:
  --dry-run         Show what would be done without making changes
  -h, --help        Show this help message

Environment Variables:
  DRY_RUN          Set to 'true' for dry run mode

Examples:
  $0 /backups/minecraft_backup_20241024_120000.tar.gz
  $0 /backups/minecraft_backup_20241024_120000.tar.gz mc-server-1
  DRY_RUN=true $0 /backups/minecraft_backup_20241024_120000.tar.gz

EOF
}

# Confirm action
confirm_action() {
  local backup_file="$1"
  
  echo ""
  log_warn "WARNING: This will REPLACE current server data!"
  log_warn "Backup file: $(basename "$backup_file")"
  echo ""
  
  read -p "Are you sure you want to continue? (yes/no): " -r
  echo
  
  if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    log_info "Restore cancelled by user"
    exit 0
  fi
}

# Main execution
main() {
  local backup_file=""
  local container_name="${DEFAULT_CONTAINER}"
  local dry_run="${DRY_RUN}"
  
  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help)
        show_usage
        exit 0
        ;;
      --dry-run)
        dry_run=true
        shift
        ;;
      *)
        if [ -z "$backup_file" ]; then
          backup_file="$1"
        else
          container_name="$1"
        fi
        shift
        ;;
    esac
  done
  
  # Check arguments
  if [ -z "$backup_file" ]; then
    log_error "Backup file is required"
    echo ""
    show_usage
    exit 1
  fi
  
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
  echo "   Minecraft Server Restore"
  echo "========================================"
  echo ""
  
  # Check if container exists
  if ! docker ps -a --format "{{.Names}}" | grep -q "^${container_name}$"; then
    log_error "Container ${container_name} does not exist"
    exit 1
  fi
  
  # Validate backup
  if ! validate_backup "$backup_file"; then
    exit 1
  fi
  
  log_info "Container: ${container_name}"
  log_info "Backup: $(basename "$backup_file")"
  log_info "Size: $(du -h "$backup_file" | cut -f1)"
  
  if [ "$dry_run" = "true" ]; then
    echo ""
    log_info "DRY RUN MODE - No changes will be made"
    log_info "Would perform:"
    log_info "  1. Stop container ${container_name}"
    log_info "  2. Create safety backup"
    log_info "  3. Restore from ${backup_file}"
    log_info "  4. Start container ${container_name}"
    echo ""
    log_success "Dry run complete"
    exit 0
  fi
  
  # Confirm with user
  confirm_action "$backup_file"
  
  echo ""
  log_info "Starting restore process..."
  echo ""
  
  # Stop container
  if ! stop_container "$container_name"; then
    exit 1
  fi
  
  # Create safety backup
  local safety_backup
  if safety_backup=$(backup_current_data "$container_name"); then
    log_info "Safety backup location: ${safety_backup}"
  else
    log_warn "Could not create safety backup, continuing anyway..."
  fi
  
  echo ""
  
  # Restore backup
  if restore_backup "$backup_file" "$container_name"; then
    echo ""
    log_success "Restore completed successfully"
    
    # Start container
    if start_container "$container_name"; then
      echo ""
      log_success "Server is starting up"
      log_info "Check logs: docker logs -f ${container_name}"
      
      if [ -n "${safety_backup:-}" ]; then
        echo ""
        log_info "Safety backup can be deleted after verifying restore:"
        log_info "  rm ${safety_backup}"
      fi
      
      exit 0
    else
      log_error "Failed to start container"
      log_info "You may need to start it manually: docker start ${container_name}"
      exit 1
    fi
  else
    log_error "Restore failed"
    
    if [ -n "${safety_backup:-}" ]; then
      log_info "Original data is backed up at: ${safety_backup}"
      log_info "You can restore it manually if needed"
    fi
    
    exit 1
  fi
}

main "$@"

