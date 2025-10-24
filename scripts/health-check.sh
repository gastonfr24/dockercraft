#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Script: health-check.sh
# Purpose: Custom health check for Minecraft server containers
# Usage: ./health-check.sh [container_name]
# Author: DockerCraft
# Date: 2024-10-24

# Constants
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly TIMEOUT=${TIMEOUT:-10}
readonly RCON_PORT=${RCON_PORT:-25575}

# Colors for output (optional, works in most terminals)
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
  echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $*"
}

log_warn() {
  echo "[WARN] $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

log_error() {
  echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $*"
}

# Check if Docker is installed
check_docker_installed() {
  if ! command -v docker >/dev/null 2>&1; then
    log_error "Docker is not installed or not in PATH"
    return 1
  fi
  return 0
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

# Check container health status
check_container_health() {
  local container_name="$1"
  local health_status
  
  health_status=$(docker inspect --format='{{.State.Health.Status}}' "$container_name" 2>/dev/null || echo "none")
  
  case "$health_status" in
    healthy)
      log_success "Container $container_name is healthy"
      return 0
      ;;
    starting)
      log_warn "Container $container_name is still starting"
      return 1
      ;;
    unhealthy)
      log_error "Container $container_name is unhealthy"
      return 1
      ;;
    none)
      log_warn "Container $container_name has no health check configured"
      return 2
      ;;
    *)
      log_warn "Container $container_name has unknown health status: $health_status"
      return 2
      ;;
  esac
}

# Check server via RCON
check_server_rcon() {
  local container_name="$1"
  
  # Try to execute a simple command via RCON
  if docker exec "$container_name" rcon-cli list >/dev/null 2>&1; then
    log_success "Server is responding to RCON commands"
    return 0
  else
    log_error "Server is not responding to RCON commands"
    return 1
  fi
}

# Get player count
get_player_count() {
  local container_name="$1"
  local output
  
  output=$(docker exec "$container_name" rcon-cli list 2>/dev/null || echo "")
  
  if [[ -n "$output" ]]; then
    log_info "Players online: $output"
  fi
}

# Get server stats
get_server_stats() {
  local container_name="$1"
  
  log_info "Server statistics for $container_name:"
  
  # CPU and Memory usage
  docker stats "$container_name" --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" | tail -n 1
  
  # TPS (if available)
  local tps
  tps=$(docker exec "$container_name" rcon-cli tps 2>/dev/null || echo "N/A")
  if [[ "$tps" != "N/A" ]]; then
    log_info "TPS: $tps"
  fi
}

# Main health check function
main() {
  local container_name="${1:-mc-server-1}"
  local exit_code=0
  
  log_info "Starting health check for container: $container_name"
  
  # Check if Docker is available
  if ! check_docker_installed; then
    exit 1
  fi
  
  # Check if container exists
  if ! container_exists "$container_name"; then
    log_error "Container $container_name does not exist"
    exit 1
  fi
  
  # Check if container is running
  if ! is_container_running "$container_name"; then
    log_error "Container $container_name is not running"
    exit 1
  fi
  
  # Check container health
  if ! check_container_health "$container_name"; then
    exit_code=1
  fi
  
  # Check RCON connectivity
  if check_server_rcon "$container_name"; then
    get_player_count "$container_name"
  else
    exit_code=1
  fi
  
  # Display server stats
  get_server_stats "$container_name"
  
  if [ $exit_code -eq 0 ]; then
    log_success "Health check passed for $container_name"
  else
    log_error "Health check failed for $container_name"
  fi
  
  exit $exit_code
}

# Run main function
main "$@"

