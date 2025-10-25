#!/bin/bash
# JSON Structured Logger for Minecraft Server
# Provides machine-readable JSON logs for monitoring/alerting systems

set -e

# Log levels
LEVEL_DEBUG=10
LEVEL_INFO=20
LEVEL_WARN=30
LEVEL_ERROR=40
LEVEL_FATAL=50

# Default log level (can be overridden by env)
LOG_LEVEL=${LOG_LEVEL:-INFO}

# Convert log level name to number
get_level_number() {
    case "$1" in
        DEBUG) echo $LEVEL_DEBUG ;;
        INFO) echo $LEVEL_INFO ;;
        WARN) echo $LEVEL_WARN ;;
        ERROR) echo $LEVEL_ERROR ;;
        FATAL) echo $LEVEL_FATAL ;;
        *) echo $LEVEL_INFO ;;
    esac
}

CURRENT_LEVEL=$(get_level_number "$LOG_LEVEL")

# JSON log function
log_json() {
    local level="$1"
    local message="$2"
    local component="${3:-minecraft}"
    local extra="${4:-{}}"
    
    local level_num=$(get_level_number "$level")
    
    # Skip if below log level
    if [ $level_num -lt $CURRENT_LEVEL ]; then
        return
    fi
    
    # Get timestamp ISO8601
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")
    
    # Filter sensitive data
    message=$(echo "$message" | sed -E 's/(password|token|secret)=[^ ]*/\1=***REDACTED***/gi')
    
    # Build JSON
    local json=$(cat <<EOF
{
  "timestamp": "$timestamp",
  "level": "$level",
  "component": "$component",
  "message": "$message",
  "hostname": "$HOSTNAME",
  "pid": $$,
  "extra": $extra
}
EOF
)
    
    echo "$json"
}

# Convenience functions
log_debug() { log_json "DEBUG" "$1" "${2:-minecraft}" "${3:-{}}"; }
log_info() { log_json "INFO" "$1" "${2:-minecraft}" "${3:-{}}"; }
log_warn() { log_json "WARN" "$1" "${2:-minecraft}" "${3:-{}}"; }
log_error() { log_json "ERROR" "$1" "${2:-minecraft}" "${3:-{}}"; }
log_fatal() { log_json "FATAL" "$1" "${2:-minecraft}" "${3:-{}}"; exit 1; }

# Export functions
export -f log_json log_debug log_info log_warn log_error log_fatal

# Example usage (commented out)
# log_info "Server starting" "minecraft" '{"port": 25565}'
# log_error "Failed to bind port" "network" '{"port": 25565, "error": "address already in use"}'

