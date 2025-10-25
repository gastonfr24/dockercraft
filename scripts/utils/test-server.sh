#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Script: test-server.sh
# Purpose: Comprehensive testing of DockerCraft Minecraft servers
# Usage: ./test-server.sh [standalone|multi|all]
# Author: DockerCraft
# Date: 2024-10-24

# Constants
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly TEST_MODE="${1:-all}"
readonly TIMEOUT=180
readonly HEALTH_CHECK_INTERVAL=10

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Test results
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_TOTAL=0

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

# Test utilities
test_start() {
  local test_name="$1"
  TESTS_TOTAL=$((TESTS_TOTAL + 1))
  log_info "Test ${TESTS_TOTAL}: ${test_name}"
}

test_pass() {
  TESTS_PASSED=$((TESTS_PASSED + 1))
  log_success "PASSED"
  echo ""
}

test_fail() {
  local reason="$1"
  TESTS_FAILED=$((TESTS_FAILED + 1))
  log_error "FAILED: ${reason}"
  echo ""
}

# Cleanup function
cleanup() {
  log_info "Cleaning up test environment..."
  
  if docker-compose ps -q >/dev/null 2>&1; then
    docker-compose down -v >/dev/null 2>&1 || true
  fi
  
  if docker-compose -f docker-compose.multi.yml ps -q >/dev/null 2>&1; then
    docker-compose -f docker-compose.multi.yml down -v >/dev/null 2>&1 || true
  fi
  
  log_success "Cleanup complete"
}

# Trap cleanup
trap cleanup EXIT

# Wait for container to be healthy
wait_for_healthy() {
  local container_name="$1"
  local timeout="${2:-$TIMEOUT}"
  local elapsed=0
  
  log_info "Waiting for ${container_name} to be healthy (timeout: ${timeout}s)..."
  
  while [ $elapsed -lt $timeout ]; do
    local health_status
    health_status=$(docker inspect --format='{{.State.Health.Status}}' "$container_name" 2>/dev/null || echo "none")
    
    if [ "$health_status" = "healthy" ]; then
      log_success "${container_name} is healthy after ${elapsed}s"
      return 0
    elif [ "$health_status" = "unhealthy" ]; then
      log_error "${container_name} is unhealthy"
      return 1
    fi
    
    sleep $HEALTH_CHECK_INTERVAL
    elapsed=$((elapsed + HEALTH_CHECK_INTERVAL))
    echo -n "."
  done
  
  echo ""
  log_error "${container_name} did not become healthy within ${timeout}s"
  return 1
}

# Test docker and docker-compose are available
test_prerequisites() {
  test_start "Check prerequisites"
  
  if ! command -v docker >/dev/null 2>&1; then
    test_fail "Docker not installed"
    return 1
  fi
  
  if ! command -v docker-compose >/dev/null 2>&1; then
    test_fail "Docker Compose not installed"
    return 1
  fi
  
  if ! docker info >/dev/null 2>&1; then
    test_fail "Docker daemon not running"
    return 1
  fi
  
  test_pass
}

# Test .env.example exists
test_env_example() {
  test_start "Check .env.example exists"
  
  if [ ! -f "$PROJECT_ROOT/.env.example" ]; then
    test_fail ".env.example not found"
    return 1
  fi
  
  test_pass
}

# Test .env file
test_env_file() {
  test_start "Check .env file"
  
  if [ ! -f "$PROJECT_ROOT/.env" ]; then
    log_warn ".env not found, creating from .env.example"
    cp "$PROJECT_ROOT/.env.example" "$PROJECT_ROOT/.env"
  fi
  
  if grep -q "EULA=TRUE" "$PROJECT_ROOT/.env"; then
    test_pass
  else
    test_fail "EULA not set to TRUE in .env"
    return 1
  fi
}

# Test Dockerfile exists and is valid
test_dockerfile() {
  test_start "Validate Dockerfile"
  
  if [ ! -f "$PROJECT_ROOT/Dockerfile" ]; then
    test_fail "Dockerfile not found"
    return 1
  fi
  
  if ! docker build -t dockercraft-test "$PROJECT_ROOT" >/dev/null 2>&1; then
    test_fail "Docker build failed"
    return 1
  fi
  
  test_pass
}

# Test standalone server
test_standalone_server() {
  test_start "Start standalone server"
  
  cd "$PROJECT_ROOT"
  
  if ! docker-compose up -d; then
    test_fail "Failed to start server"
    return 1
  fi
  
  test_pass
  
  # Wait for healthy
  test_start "Wait for server to be healthy"
  if wait_for_healthy "mc-server-1" 300; then
    test_pass
  else
    docker-compose logs --tail=50
    test_fail "Server did not become healthy"
    return 1
  fi
  
  # Test RCON
  test_start "Test RCON connectivity"
  if docker exec mc-server-1 rcon-cli list >/dev/null 2>&1; then
    test_pass
  else
    test_fail "RCON not responding"
    return 1
  fi
  
  # Test logs
  test_start "Check server logs"
  local logs
  logs=$(docker-compose logs --tail=20 2>&1)
  if echo "$logs" | grep -q "Done"; then
    test_pass
  else
    test_fail "Server not fully started"
    return 1
  fi
}

# Test multi-server setup
test_multi_server() {
  test_start "Start multi-server setup"
  
  cd "$PROJECT_ROOT"
  
  if ! docker-compose -f docker-compose.multi.yml up -d; then
    test_fail "Failed to start multi-server"
    return 1
  fi
  
  test_pass
  
  # Wait for all servers
  local servers=("mc-server-survival" "mc-server-creative" "mc-server-minigames")
  
  for server in "${servers[@]}"; do
    test_start "Wait for ${server} to be healthy"
    if wait_for_healthy "$server" 300; then
      test_pass
    else
      docker-compose -f docker-compose.multi.yml logs --tail=50 "$server"
      test_fail "${server} did not become healthy"
      return 1
    fi
  done
  
  # Test RCON on all servers
  for server in "${servers[@]}"; do
    test_start "Test RCON on ${server}"
    if docker exec "$server" rcon-cli list >/dev/null 2>&1; then
      test_pass
    else
      test_fail "RCON not responding on ${server}"
      return 1
    fi
  done
}

# Test persistence
test_persistence() {
  test_start "Test data persistence"
  
  cd "$PROJECT_ROOT"
  
  log_info "Starting server..."
  docker-compose up -d >/dev/null 2>&1
  wait_for_healthy "mc-server-1" 300 >/dev/null 2>&1
  
  log_info "Creating test file in volume..."
  docker exec mc-server-1 sh -c "echo 'test-persistence' > /data/test-persistence.txt"
  
  log_info "Restarting container..."
  docker-compose restart >/dev/null 2>&1
  wait_for_healthy "mc-server-1" 300 >/dev/null 2>&1
  
  log_info "Checking if test file persists..."
  if docker exec mc-server-1 cat /data/test-persistence.txt 2>/dev/null | grep -q "test-persistence"; then
    test_pass
  else
    test_fail "Data did not persist across restart"
    return 1
  fi
  
  docker exec mc-server-1 rm -f /data/test-persistence.txt 2>/dev/null || true
}

# Test resource limits
test_resource_limits() {
  test_start "Check resource limits"
  
  cd "$PROJECT_ROOT"
  docker-compose up -d >/dev/null 2>&1
  
  local mem_limit
  mem_limit=$(docker inspect mc-server-1 --format='{{.HostConfig.Memory}}' 2>/dev/null || echo "0")
  
  if [ "$mem_limit" != "0" ] && [ "$mem_limit" != "" ]; then
    log_info "Memory limit: $((mem_limit / 1024 / 1024))MB"
    test_pass
  else
    test_fail "No memory limit set"
    return 1
  fi
}

# Show test summary
show_summary() {
  echo ""
  echo "========================================"
  echo "          TEST SUMMARY"
  echo "========================================"
  echo ""
  echo "Total Tests:  ${TESTS_TOTAL}"
  echo -e "Passed:       ${GREEN}${TESTS_PASSED}${NC}"
  echo -e "Failed:       ${RED}${TESTS_FAILED}${NC}"
  echo ""
  
  if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}ALL TESTS PASSED!${NC}"
    echo ""
    return 0
  else
    echo -e "${RED}SOME TESTS FAILED!${NC}"
    echo ""
    return 1
  fi
}

# Main execution
main() {
  cd "$PROJECT_ROOT"
  
  echo "========================================"
  echo "   DockerCraft Server Testing Suite"
  echo "========================================"
  echo ""
  log_info "Test mode: ${TEST_MODE}"
  log_info "Project root: ${PROJECT_ROOT}"
  echo ""
  
  # Prerequisites
  test_prerequisites || exit 1
  test_env_example || exit 1
  test_env_file || exit 1
  test_dockerfile || exit 1
  
  case "$TEST_MODE" in
    standalone)
      test_standalone_server
      test_persistence
      test_resource_limits
      ;;
    multi)
      test_multi_server
      ;;
    all)
      test_standalone_server
      test_persistence
      test_resource_limits
      cleanup
      test_multi_server
      ;;
    *)
      log_error "Invalid test mode: ${TEST_MODE}"
      log_info "Usage: $0 [standalone|multi|all]"
      exit 1
      ;;
  esac
  
  show_summary
}

main "$@"

