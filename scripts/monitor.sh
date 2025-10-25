#!/bin/bash
################################################################################
# DockerCraft - Server Monitoring Script
#
# Description:
#   Monitors Docker container resources (CPU, RAM, Disk) for Minecraft servers.
#   Can be run manually or as a cron job for continuous monitoring.
#
# Usage:
#   ./monitor.sh [OPTIONS]
#
# Options:
#   -c, --container NAME    Monitor specific container (default: all minecraft containers)
#   -w, --warn-cpu NUM      CPU warning threshold in % (default: 80)
#   -W, --warn-mem NUM      Memory warning threshold in % (default: 80)
#   -d, --warn-disk NUM     Disk warning threshold in % (default: 85)
#   -l, --log-file PATH     Log file path (default: ./logs/monitor.log)
#   -j, --json              Output in JSON format
#   -q, --quiet             Quiet mode (only warnings/errors)
#   -h, --help              Show this help message
#
# Exit Codes:
#   0 - All resources within thresholds
#   1 - Warning threshold exceeded
#   2 - Critical error (container not running, etc)
#
# Examples:
#   ./monitor.sh                                    # Monitor all containers
#   ./monitor.sh -c minecraft-server                # Monitor specific container
#   ./monitor.sh -w 70 -W 75                       # Custom thresholds
#   ./monitor.sh --json > metrics.json             # JSON output
#
################################################################################

set -eo pipefail

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default configuration
CONTAINER_NAME=""
WARN_CPU=80
WARN_MEM=80
WARN_DISK=85
LOG_FILE="./logs/monitor.log"
JSON_OUTPUT=false
QUIET_MODE=false
EXIT_CODE=0

# Ensure logs directory exists
mkdir -p "$(dirname "$LOG_FILE")"

################################################################################
# Helper Functions
################################################################################

log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    
    if [ "$QUIET_MODE" = false ]; then
        case "$level" in
            ERROR)
                echo -e "${RED}[ERROR]${NC} $message" >&2
                ;;
            WARN)
                echo -e "${YELLOW}[WARN]${NC} $message" >&2
                ;;
            INFO)
                echo -e "${BLUE}[INFO]${NC} $message"
                ;;
            OK)
                echo -e "${GREEN}[OK]${NC} $message"
                ;;
        esac
    fi
}

usage() {
    grep '^#' "$0" | grep -v '#!/bin/bash' | sed 's/^# //' | sed 's/^#//'
    exit 0
}

check_dependencies() {
    local deps=("docker" "awk" "bc")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            log ERROR "Required dependency '$dep' not found"
            exit 2
        fi
    done
}

################################################################################
# Monitoring Functions
################################################################################

get_container_ids() {
    local container_filter="$1"
    
    if [ -n "$container_filter" ]; then
        # Get specific container
        docker ps -q -f "name=$container_filter" 2>/dev/null || true
    else
        # Get all containers with minecraft in the name or using minecraft image
        docker ps -q -f "name=minecraft" 2>/dev/null || \
        docker ps -q -f "ancestor=itzg/minecraft-server" 2>/dev/null || true
    fi
}

get_container_stats() {
    local container_id="$1"
    
    # Get container name
    local name
    name=$(docker inspect --format '{{.Name}}' "$container_id" | sed 's/^\///')
    
    # Get stats (no-stream for single reading)
    local stats
    stats=$(docker stats "$container_id" --no-stream --format \
        "{{.Name}}|{{.CPUPerc}}|{{.MemUsage}}|{{.MemPerc}}|{{.NetIO}}|{{.BlockIO}}" 2>/dev/null)
    
    if [ -z "$stats" ]; then
        log ERROR "Failed to get stats for container $name"
        return 1
    fi
    
    echo "$stats"
}

parse_stats() {
    local stats="$1"
    
    # Split by pipe
    IFS='|' read -r name cpu mem mem_perc net block <<< "$stats"
    
    # Clean percentages (remove % sign)
    cpu=$(echo "$cpu" | tr -d '%')
    mem_perc=$(echo "$mem_perc" | tr -d '%')
    
    # Parse memory usage (format: "1.5GiB / 4GiB")
    local mem_used mem_total
    mem_used=$(echo "$mem" | awk '{print $1}')
    mem_total=$(echo "$mem" | awk '{print $3}')
    
    # Return as array
    echo "$name|$cpu|$mem_used|$mem_total|$mem_perc|$net|$block"
}

get_disk_usage() {
    local container_id="$1"
    
    # Get container's data mount point
    local mount_point
    mount_point=$(docker inspect --format '{{range .Mounts}}{{if eq .Destination "/data"}}{{.Source}}{{end}}{{end}}' "$container_id")
    
    if [ -z "$mount_point" ]; then
        echo "N/A|0"
        return
    fi
    
    # Get disk usage of mount point
    local disk_usage
    disk_usage=$(df -h "$mount_point" 2>/dev/null | awk 'NR==2 {print $5"|"$3"/"$2}' || echo "N/A|0")
    
    echo "$disk_usage"
}

check_thresholds() {
    local name="$1"
    local cpu="$2"
    local mem_perc="$3"
    local disk_perc="$4"
    
    local warnings=()
    
    # Check CPU
    if (( $(echo "$cpu >= $WARN_CPU" | bc -l) )); then
        warnings+=("CPU: ${cpu}% (threshold: ${WARN_CPU}%)")
    fi
    
    # Check Memory
    if (( $(echo "$mem_perc >= $WARN_MEM" | bc -l) )); then
        warnings+=("Memory: ${mem_perc}% (threshold: ${WARN_MEM}%)")
    fi
    
    # Check Disk (remove % sign if present)
    disk_perc=$(echo "$disk_perc" | tr -d '%')
    if [ "$disk_perc" != "N/A" ] && (( $(echo "$disk_perc >= $WARN_DISK" | bc -l) )); then
        warnings+=("Disk: ${disk_perc}% (threshold: ${WARN_DISK}%)")
    fi
    
    if [ ${#warnings[@]} -gt 0 ]; then
        log WARN "Container '$name' resource warning:"
        for warning in "${warnings[@]}"; do
            log WARN "  - $warning"
        done
        EXIT_CODE=1
    else
        log OK "Container '$name' resources within thresholds"
    fi
}

monitor_container() {
    local container_id="$1"
    
    # Get container stats
    local stats
    stats=$(get_container_stats "$container_id")
    
    if [ $? -ne 0 ]; then
        return 1
    fi
    
    # Parse stats
    local parsed
    parsed=$(parse_stats "$stats")
    IFS='|' read -r name cpu mem_used mem_total mem_perc net block <<< "$parsed"
    
    # Get disk usage
    local disk_info
    disk_info=$(get_disk_usage "$container_id")
    IFS='|' read -r disk_perc disk_usage <<< "$disk_info"
    
    # Get container uptime
    local uptime
    uptime=$(docker inspect --format '{{.State.StartedAt}}' "$container_id" | xargs -I {} date -d {} +%s 2>/dev/null || echo "N/A")
    if [ "$uptime" != "N/A" ]; then
        local now
        now=$(date +%s)
        uptime=$((now - uptime))
        # Convert to human readable
        local days=$((uptime / 86400))
        local hours=$(((uptime % 86400) / 3600))
        local minutes=$(((uptime % 3600) / 60))
        uptime="${days}d ${hours}h ${minutes}m"
    fi
    
    # Output results
    if [ "$JSON_OUTPUT" = true ]; then
        cat <<EOF
{
  "container": "$name",
  "timestamp": "$(date -Iseconds)",
  "cpu_percent": $cpu,
  "memory": {
    "used": "$mem_used",
    "total": "$mem_total",
    "percent": $mem_perc
  },
  "disk": {
    "percent": "$disk_perc",
    "usage": "$disk_usage"
  },
  "network_io": "$net",
  "block_io": "$block",
  "uptime": "$uptime",
  "thresholds": {
    "cpu_warn": $WARN_CPU,
    "mem_warn": $WARN_MEM,
    "disk_warn": $WARN_DISK
  }
}
EOF
    else
        if [ "$QUIET_MODE" = false ]; then
            echo ""
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "Container: $name"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "  Timestamp:    $(date '+%Y-%m-%d %H:%M:%S')"
            echo "  Uptime:       $uptime"
            echo "  CPU:          ${cpu}% (warn: ${WARN_CPU}%)"
            echo "  Memory:       ${mem_used} / ${mem_total} (${mem_perc}%, warn: ${WARN_MEM}%)"
            echo "  Disk:         ${disk_usage} (${disk_perc}, warn: ${WARN_DISK}%)"
            echo "  Network I/O:  $net"
            echo "  Block I/O:    $block"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        fi
    fi
    
    # Check thresholds
    check_thresholds "$name" "$cpu" "$mem_perc" "$disk_perc"
}

################################################################################
# Main Function
################################################################################

main() {
    log INFO "Starting DockerCraft monitoring"
    
    # Check dependencies
    check_dependencies
    
    # Get containers to monitor
    local containers
    containers=$(get_container_ids "$CONTAINER_NAME")
    
    if [ -z "$containers" ]; then
        if [ -n "$CONTAINER_NAME" ]; then
            log ERROR "Container '$CONTAINER_NAME' not found or not running"
        else
            log ERROR "No Minecraft containers found running"
        fi
        exit 2
    fi
    
    # Monitor each container
    local count=0
    while IFS= read -r container_id; do
        monitor_container "$container_id"
        ((count++))
    done <<< "$containers"
    
    log INFO "Monitoring completed for $count container(s)"
    
    if [ $EXIT_CODE -eq 1 ]; then
        log WARN "Some resources exceeded warning thresholds"
    fi
    
    exit $EXIT_CODE
}

################################################################################
# Parse Arguments
################################################################################

while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--container)
            CONTAINER_NAME="$2"
            shift 2
            ;;
        -w|--warn-cpu)
            WARN_CPU="$2"
            shift 2
            ;;
        -W|--warn-mem)
            WARN_MEM="$2"
            shift 2
            ;;
        -d|--warn-disk)
            WARN_DISK="$2"
            shift 2
            ;;
        -l|--log-file)
            LOG_FILE="$2"
            shift 2
            ;;
        -j|--json)
            JSON_OUTPUT=true
            shift
            ;;
        -q|--quiet)
            QUIET_MODE=true
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

# Run main function
main

