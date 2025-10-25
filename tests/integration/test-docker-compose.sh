#!/bin/bash
################################################################################
# DockerCraft - Docker Compose Integration Tests
#
# Description:
#   Tests all docker-compose configurations to ensure they can start, run,
#   and stop correctly without errors.
#
# Usage:
#   ./test-docker-compose.sh [OPTIONS]
#
# Options:
#   -f, --file FILE         Test specific compose file
#   -q, --quick             Quick test (shorter wait times)
#   -v, --verbose           Verbose output
#   -h, --help              Show this help message
#
# Exit Codes:
#   0 - All tests passed
#   1 - Some tests failed
#   2 - Critical error (Docker not available, etc)
#
################################################################################

set -eo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
QUICK_MODE=false
VERBOSE=false
SPECIFIC_FILE=""
TESTS_PASSED=0
TESTS_FAILED=0
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

################################################################################
# Helper Functions
################################################################################

log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[PASS]${NC} $*"
    ((TESTS_PASSED++))
}

log_error() {
    echo -e "${RED}[FAIL]${NC} $*" >&2
    ((TESTS_FAILED++))
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

verbose() {
    if [ "$VERBOSE" = true ]; then
        echo "$@"
    fi
}

usage() {
    grep '^#' "$0" | grep -v '#!/bin/bash' | sed 's/^# //' | sed 's/^#//'
    exit 0
}

check_dependencies() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed or not in PATH"
        exit 2
    fi
    
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        log_error "Docker Compose is not installed"
        exit 2
    fi
    
    if ! docker info &> /dev/null; then
        log_error "Docker daemon is not running"
        exit 2
    fi
}

get_compose_cmd() {
    if docker compose version &> /dev/null 2>&1; then
        echo "docker compose"
    else
        echo "docker-compose"
    fi
}

################################################################################
# Test Functions
################################################################################

test_compose_file() {
    local compose_file="$1"
    local test_name="$(basename "$compose_file" .yml)"
    
    log_info "Testing: $compose_file"
    
    local compose_cmd
    compose_cmd=$(get_compose_cmd)
    
    # Generate unique project name
    local project_name="dockercraft-test-${test_name}-$$"
    
    # Test 1: Validate syntax
    verbose "  Validating syntax..."
    if ! $compose_cmd -f "$compose_file" -p "$project_name" config &> /dev/null; then
        log_error "$test_name: Invalid syntax"
        return 1
    fi
    verbose "  ✓ Syntax valid"
    
    # Test 2: Pull images
    verbose "  Pulling images..."
    if ! $compose_cmd -f "$compose_file" -p "$project_name" pull --quiet 2>&1 | grep -v "Pulling"; then
        log_warn "$test_name: Failed to pull some images (might be using local builds)"
    fi
    verbose "  ✓ Images pulled"
    
    # Test 3: Start services
    verbose "  Starting services..."
    if ! $compose_cmd -f "$compose_file" -p "$project_name" up -d 2>&1 | verbose; then
        log_error "$test_name: Failed to start services"
        cleanup_project "$project_name" "$compose_file"
        return 1
    fi
    verbose "  ✓ Services started"
    
    # Test 4: Wait for services to be healthy
    local wait_time=30
    if [ "$QUICK_MODE" = true ]; then
        wait_time=10
    fi
    
    verbose "  Waiting ${wait_time}s for services to stabilize..."
    sleep "$wait_time"
    
    # Test 5: Check if containers are running
    verbose "  Checking container status..."
    local running_count
    running_count=$($compose_cmd -f "$compose_file" -p "$project_name" ps -q | wc -l)
    
    if [ "$running_count" -eq 0 ]; then
        log_error "$test_name: No containers running"
        $compose_cmd -f "$compose_file" -p "$project_name" logs --tail=50 | verbose
        cleanup_project "$project_name" "$compose_file"
        return 1
    fi
    verbose "  ✓ $running_count container(s) running"
    
    # Test 6: Check for restart loops
    verbose "  Checking for restart loops..."
    local restart_count
    restart_count=$($compose_cmd -f "$compose_file" -p "$project_name" ps --format json 2>/dev/null | grep -o '"Status":"[^"]*"' | grep -c "Restarting" || true)
    
    if [ "$restart_count" -gt 0 ]; then
        log_error "$test_name: $restart_count container(s) in restart loop"
        $compose_cmd -f "$compose_file" -p "$project_name" logs --tail=50 | verbose
        cleanup_project "$project_name" "$compose_file"
        return 1
    fi
    verbose "  ✓ No restart loops detected"
    
    # Test 7: Check container health (if health checks defined)
    verbose "  Checking container health..."
    local unhealthy_count
    unhealthy_count=$($compose_cmd -f "$compose_file" -p "$project_name" ps --format json 2>/dev/null | grep -o '"Health":"[^"]*"' | grep -c "unhealthy" || true)
    
    if [ "$unhealthy_count" -gt 0 ]; then
        log_warn "$test_name: $unhealthy_count container(s) unhealthy"
        # This is a warning, not a failure
    else
        verbose "  ✓ All containers healthy or no health checks defined"
    fi
    
    # Test 8: Stop services
    verbose "  Stopping services..."
    if ! $compose_cmd -f "$compose_file" -p "$project_name" down -v --timeout 10 2>&1 | verbose; then
        log_error "$test_name: Failed to stop services cleanly"
        cleanup_project "$project_name" "$compose_file"
        return 1
    fi
    verbose "  ✓ Services stopped"
    
    log_success "$test_name: All tests passed"
    return 0
}

cleanup_project() {
    local project_name="$1"
    local compose_file="$2"
    local compose_cmd
    compose_cmd=$(get_compose_cmd)
    
    log_info "Cleaning up project: $project_name"
    $compose_cmd -f "$compose_file" -p "$project_name" down -v --timeout 5 2>&1 | verbose || true
    
    # Force remove containers if still running
    docker ps -a --filter "name=${project_name}" -q | xargs -r docker rm -f 2>&1 | verbose || true
    
    # Remove networks
    docker network ls --filter "name=${project_name}" -q | xargs -r docker network rm 2>&1 | verbose || true
    
    # Remove volumes
    docker volume ls --filter "name=${project_name}" -q | xargs -r docker volume rm 2>&1 | verbose || true
}

################################################################################
# Main Function
################################################################################

main() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  DockerCraft - Docker Compose Integration Tests"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    check_dependencies
    
    cd "$PROJECT_ROOT"
    
    # Get list of compose files to test
    local compose_files=()
    
    if [ -n "$SPECIFIC_FILE" ]; then
        if [ ! -f "$SPECIFIC_FILE" ]; then
            log_error "File not found: $SPECIFIC_FILE"
            exit 2
        fi
        compose_files=("$SPECIFIC_FILE")
    else
        # Find all docker-compose files
        while IFS= read -r file; do
            compose_files+=("$file")
        done < <(find . -maxdepth 1 -name "docker-compose*.yml" -type f | sort)
    fi
    
    if [ ${#compose_files[@]} -eq 0 ]; then
        log_error "No docker-compose files found"
        exit 2
    fi
    
    log_info "Found ${#compose_files[@]} compose file(s) to test"
    echo ""
    
    # Run tests
    for compose_file in "${compose_files[@]}"; do
        test_compose_file "$compose_file" || true
        echo ""
    done
    
    # Summary
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Test Summary"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "  ${GREEN}Passed:${NC} $TESTS_PASSED"
    echo -e "  ${RED}Failed:${NC} $TESTS_FAILED"
    echo -e "  ${BLUE}Total:${NC}  $((TESTS_PASSED + TESTS_FAILED))"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if [ $TESTS_FAILED -gt 0 ]; then
        exit 1
    fi
    
    exit 0
}

################################################################################
# Parse Arguments
################################################################################

while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--file)
            SPECIFIC_FILE="$2"
            shift 2
            ;;
        -q|--quick)
            QUICK_MODE=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 2
            ;;
    esac
done

# Run main
main

