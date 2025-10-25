#!/bin/bash
################################################################################
# DockerCraft - Automated Setup Script
#
# Description:
#   Automated setup for DockerCraft development and production environments.
#   Checks dependencies, configures environment, and validates setup.
#
# Usage:
#   ./scripts/setup.sh [OPTIONS]
#
# Options:
#   -e, --env ENV          Environment: dev, prod (default: dev)
#   -s, --skip-checks      Skip dependency checks
#   -y, --yes              Assume yes to all prompts
#   -h, --help             Show this help message
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
ENVIRONMENT="dev"
SKIP_CHECKS=false
ASSUME_YES=false
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[OK]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }

prompt_yes_no() {
    if [ "$ASSUME_YES" = true ]; then
        return 0
    fi
    
    local prompt="$1"
    read -p "$prompt (y/n): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

check_command() {
    local cmd="$1"
    local name="${2:-$cmd}"
    
    if command -v "$cmd" &> /dev/null; then
        local version
        version=$($cmd --version 2>&1 | head -n1 || echo "unknown")
        log_success "$name is installed: $version"
        return 0
    else
        log_error "$name is not installed"
        return 1
    fi
}

install_docker() {
    log_info "Docker installation instructions:"
    echo ""
    echo "  Ubuntu/Debian:"
    echo "    curl -fsSL https://get.docker.com | sh"
    echo "    sudo usermod -aG docker \$USER"
    echo ""
    echo "  macOS:"
    echo "    brew install --cask docker"
    echo ""
    echo "  Visit: https://docs.docker.com/get-docker/"
}

check_dependencies() {
    log_info "Checking dependencies..."
    echo ""
    
    local missing=false
    
    # Docker
    if ! check_command "docker" "Docker"; then
        install_docker
        missing=true
    fi
    
    # Docker Compose
    if ! docker compose version &> /dev/null 2>&1 && ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose is not installed"
        echo "  Install: https://docs.docker.com/compose/install/"
        missing=true
    else
        log_success "Docker Compose is installed"
    fi
    
    # Git
    if ! check_command "git" "Git"; then
        missing=true
    fi
    
    # Optional but recommended
    check_command "jq" "jq (optional)" || log_warn "jq is recommended for JSON parsing"
    check_command "curl" "curl (optional)" || log_warn "curl is recommended for API calls"
    
    echo ""
    
    if [ "$missing" = true ]; then
        log_error "Missing required dependencies"
        return 1
    fi
    
    log_success "All required dependencies are installed"
    return 0
}

setup_environment() {
    log_info "Setting up $ENVIRONMENT environment..."
    
    cd "$PROJECT_ROOT"
    
    # Create .env if it doesn't exist
    if [ ! -f ".env" ]; then
        if [ -f ".env.example" ]; then
            log_info "Creating .env from .env.example"
            cp .env.example .env
            log_success ".env created"
        else
            log_warn ".env.example not found, skipping .env creation"
        fi
    else
        log_info ".env already exists"
    fi
    
    # Create logs directory
    mkdir -p logs
    log_success "logs/ directory created"
    
    # Create data directory for volumes
    mkdir -p data
    log_success "data/ directory created"
    
    # Set permissions
    if [ "$ENVIRONMENT" = "prod" ]; then
        chmod 600 .env 2>/dev/null || true
        log_info "Set restrictive permissions on .env"
    fi
    
    log_success "Environment setup complete"
}

validate_setup() {
    log_info "Validating setup..."
    
    cd "$PROJECT_ROOT"
    
    # Check docker-compose files
    local compose_files
    compose_files=$(find . -maxdepth 1 -name "docker-compose*.yml" -type f)
    
    if [ -z "$compose_files" ]; then
        log_error "No docker-compose files found"
        return 1
    fi
    
    log_info "Found docker-compose files:"
    echo "$compose_files" | while read -r file; do
        echo "  - $file"
    done
    echo ""
    
    # Validate main docker-compose.yml
    if [ -f "docker-compose.yml" ]; then
        log_info "Validating docker-compose.yml..."
        if docker compose -f docker-compose.yml config &> /dev/null; then
            log_success "docker-compose.yml is valid"
        else
            log_error "docker-compose.yml has syntax errors"
            return 1
        fi
    fi
    
    log_success "Setup validation complete"
}

main() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  DockerCraft - Automated Setup"
    echo "  Environment: $ENVIRONMENT"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    if [ "$SKIP_CHECKS" = false ]; then
        check_dependencies || {
            log_error "Dependency check failed"
            echo ""
            echo "Fix the issues above and run setup again."
            exit 1
        }
        echo ""
    fi
    
    setup_environment
    echo ""
    
    validate_setup || {
        log_error "Setup validation failed"
        exit 1
    }
    echo ""
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Setup Complete! 🎉"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Next steps:"
    echo "  1. Edit .env with your configuration"
    echo "  2. Start server: docker compose up -d"
    echo "  3. Check logs: docker compose logs -f"
    echo ""
    echo "For more information, see README.md"
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--env) ENVIRONMENT="$2"; shift 2 ;;
        -s|--skip-checks) SKIP_CHECKS=true; shift ;;
        -y|--yes) ASSUME_YES=true; shift ;;
        -h|--help)
            grep '^#' "$0" | grep -v '#!/bin/bash' | sed 's/^# //' | sed 's/^#//'
            exit 0
            ;;
        *) echo "Unknown option: $1"; exit 2 ;;
    esac
done

main

