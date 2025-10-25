#!/bin/bash
################################################################################
# DockerCraft - Security Hardening Script
#
# Description:
#   Automated security hardening for DockerCraft deployment.
#   Applies security best practices to host and containers.
#
# Usage:
#   sudo ./scripts/security-hardening.sh [OPTIONS]
#
# Options:
#   --docker-only       Only harden Docker configuration
#   --host-only         Only harden host system
#   --dry-run           Show what would be done without applying
#   -y, --yes           Assume yes to all prompts
#   -h, --help          Show this help message
#
# Exit Codes:
#   0 - Success
#   1 - Partial failure
#   2 - Critical error
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
DOCKER_ONLY=false
HOST_ONLY=false
DRY_RUN=false
ASSUME_YES=false
CHANGES_MADE=0
FAILURES=0

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[OK]${NC} $*"; ((CHANGES_MADE++)); }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; ((FAILURES++)); }
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

apply_change() {
    local description="$1"
    shift
    local command="$*"
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Would execute: $command"
        return 0
    fi
    
    if eval "$command" &> /dev/null; then
        log_success "$description"
        return 0
    else
        log_error "Failed: $description"
        return 1
    fi
}

################################################################################
# Docker Security Hardening
################################################################################

harden_docker() {
    log_info "Applying Docker security hardening..."
    echo ""
    
    # 1. Enable Docker Content Trust
    log_info "Enabling Docker Content Trust..."
    if ! grep -q "DOCKER_CONTENT_TRUST=1" /etc/environment 2>/dev/null; then
        apply_change "Enable Docker Content Trust" \
            "echo 'DOCKER_CONTENT_TRUST=1' >> /etc/environment"
    fi
    
    # 2. Configure daemon.json for security
    log_info "Hardening Docker daemon configuration..."
    local daemon_config="/etc/docker/daemon.json"
    
    if [ ! -f "$daemon_config" ]; then
        if [ "$DRY_RUN" = false ]; then
            cat > "$daemon_config" <<EOF
{
  "icc": false,
  "live-restore": true,
  "userland-proxy": false,
  "no-new-privileges": true,
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF
            log_success "Created secure daemon.json"
        else
            log_info "[DRY-RUN] Would create secure daemon.json"
        fi
    fi
    
    # 3. Set restrictive permissions on Docker files
    apply_change "Secure Docker socket permissions" \
        "chmod 660 /var/run/docker.sock"
    
    apply_change "Secure Docker directory" \
        "chmod 700 /var/lib/docker"
    
    # 4. Enable audit for Docker
    if command -v auditctl &> /dev/null; then
        apply_change "Enable Docker audit logging" \
            "auditctl -w /var/lib/docker -k docker"
        apply_change "Enable daemon.json audit" \
            "auditctl -w /etc/docker/daemon.json -k docker"
    fi
    
    # 5. Restart Docker to apply changes
    if [ "$DRY_RUN" = false ] && [ $CHANGES_MADE -gt 0 ]; then
        if prompt_yes_no "Restart Docker daemon to apply changes?"; then
            systemctl restart docker
            log_success "Docker daemon restarted"
        fi
    fi
    
    echo ""
}

################################################################################
# Host System Hardening
################################################################################

harden_host() {
    log_info "Applying host system hardening..."
    echo ""
    
    # 1. Update system
    log_info "Checking for system updates..."
    if command -v apt &> /dev/null; then
        apply_change "Update package lists" "apt update -qq"
    elif command -v yum &> /dev/null; then
        apply_change "Update package lists" "yum check-update || true"
    fi
    
    # 2. Install security tools
    log_info "Installing security tools..."
    if command -v apt &> /dev/null; then
        apply_change "Install fail2ban" "apt install -y -qq fail2ban"
        apply_change "Install ufw" "apt install -y -qq ufw"
    elif command -v yum &> /dev/null; then
        apply_change "Install fail2ban" "yum install -y -q fail2ban"
        apply_change "Install firewalld" "yum install -y -q firewalld"
    fi
    
    # 3. Configure SSH hardening
    log_info "Hardening SSH configuration..."
    local ssh_config="/etc/ssh/sshd_config"
    
    if [ -f "$ssh_config" ]; then
        # Backup original
        if [ ! -f "${ssh_config}.backup" ]; then
            cp "$ssh_config" "${ssh_config}.backup"
        fi
        
        # Apply SSH hardening
        apply_change "Disable root login" \
            "sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' $ssh_config"
        
        apply_change "Disable password authentication" \
            "sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' $ssh_config"
        
        apply_change "Enable key-based auth" \
            "sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' $ssh_config"
        
        # Restart SSH
        if [ "$DRY_RUN" = false ] && [ $CHANGES_MADE -gt 0 ]; then
            if prompt_yes_no "Restart SSH to apply changes?"; then
                systemctl restart sshd || systemctl restart ssh
                log_success "SSH daemon restarted"
            fi
        fi
    fi
    
    # 4. Set up automatic security updates
    log_info "Configuring automatic security updates..."
    if command -v apt &> /dev/null; then
        apply_change "Install unattended-upgrades" \
            "apt install -y -qq unattended-upgrades"
        apply_change "Enable unattended-upgrades" \
            "dpkg-reconfigure -plow unattended-upgrades"
    fi
    
    # 5. Disable unnecessary services
    log_info "Checking for unnecessary services..."
    local unnecessary_services=("telnet" "rsh" "rlogin")
    
    for service in "${unnecessary_services[@]}"; do
        if systemctl is-active --quiet "$service" 2>/dev/null; then
            apply_change "Disable $service" \
                "systemctl disable --now $service"
        fi
    done
    
    # 6. Set secure file permissions
    log_info "Setting secure file permissions..."
    apply_change "Secure /etc/passwd" "chmod 644 /etc/passwd"
    apply_change "Secure /etc/shadow" "chmod 600 /etc/shadow"
    apply_change "Secure /etc/group" "chmod 644 /etc/group"
    
    # 7. Configure kernel security parameters
    log_info "Hardening kernel parameters..."
    local sysctl_conf="/etc/sysctl.conf"
    
    if [ "$DRY_RUN" = false ]; then
        cat >> "$sysctl_conf" <<EOF

# DockerCraft Security Hardening
# IP forwarding (required for Docker)
net.ipv4.ip_forward = 1

# SYN flood protection
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_max_syn_backlog = 4096

# Disable IP source routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0

# Disable ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Enable reverse path filtering
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Log martian packets
net.ipv4.conf.all.log_martians = 1

# Ignore ICMP ping requests
net.ipv4.icmp_echo_ignore_all = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Protect against time-wait assassination
net.ipv4.tcp_rfc1337 = 1
EOF
        sysctl -p &> /dev/null || true
        log_success "Kernel parameters hardened"
    else
        log_info "[DRY-RUN] Would harden kernel parameters"
    fi
    
    echo ""
}

################################################################################
# Security Verification
################################################################################

verify_security() {
    log_info "Verifying security configuration..."
    echo ""
    
    local issues=0
    
    # Check Docker
    if [ -f /var/run/docker.sock ]; then
        local socket_perms
        socket_perms=$(stat -c %a /var/run/docker.sock)
        if [ "$socket_perms" != "660" ]; then
            log_warn "Docker socket permissions: $socket_perms (should be 660)"
            ((issues++))
        fi
    fi
    
    # Check SSH
    if [ -f /etc/ssh/sshd_config ]; then
        if grep -q "^PermitRootLogin yes" /etc/ssh/sshd_config; then
            log_warn "SSH: Root login is enabled"
            ((issues++))
        fi
    fi
    
    # Check firewall
    if command -v ufw &> /dev/null; then
        if ! ufw status | grep -q "Status: active"; then
            log_warn "UFW firewall is not active"
            ((issues++))
        fi
    fi
    
    echo ""
    if [ $issues -eq 0 ]; then
        log_success "No security issues detected"
    else
        log_warn "Found $issues potential security issues"
    fi
}

################################################################################
# Main Function
################################################################################

main() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  DockerCraft - Security Hardening"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    # Check root
    if [ "$EUID" -ne 0 ] && [ "$DRY_RUN" = false ]; then
        log_error "This script must be run as root"
        echo "Try: sudo $0"
        exit 2
    fi
    
    # Apply hardening
    if [ "$HOST_ONLY" = false ]; then
        harden_docker
    fi
    
    if [ "$DOCKER_ONLY" = false ]; then
        harden_host
    fi
    
    # Verify
    verify_security
    
    # Summary
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Hardening Summary"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "  ${GREEN}Changes Applied:${NC} $CHANGES_MADE"
    echo -e "  ${RED}Failures:${NC}       $FAILURES"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    if [ "$DRY_RUN" = false ]; then
        log_info "Hardening complete! Review changes and restart if needed."
        echo ""
        echo "Recommended next steps:"
        echo "  1. Configure firewall: ./templates/firewall/ufw.rules"
        echo "  2. Review logs: journalctl -xe"
        echo "  3. Test services: docker ps && systemctl status sshd"
    else
        log_info "Dry run complete. Run without --dry-run to apply changes."
    fi
    
    if [ $FAILURES -gt 0 ]; then
        exit 1
    fi
    
    exit 0
}

################################################################################
# Parse Arguments
################################################################################

while [[ $# -gt 0 ]]; do
    case $1 in
        --docker-only) DOCKER_ONLY=true; shift ;;
        --host-only) HOST_ONLY=true; shift ;;
        --dry-run) DRY_RUN=true; shift ;;
        -y|--yes) ASSUME_YES=true; shift ;;
        -h|--help)
            grep '^#' "$0" | grep -v '#!/bin/bash' | sed 's/^# //' | sed 's/^#//'
            exit 0
            ;;
        *) echo "Unknown option: $1"; exit 2 ;;
    esac
done

# Run main
main

