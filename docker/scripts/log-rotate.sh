#!/bin/bash
# Log Rotation Script
# Automatically rotates logs to prevent disk space issues

set -e

# Configuration
LOG_DIR="${LOG_DIR:-/data/logs}"
MAX_SIZE="${MAX_SIZE:-100M}"        # Max size before rotation
RETENTION_DAYS="${RETENTION_DAYS:-7}"  # Days to keep old logs
COMPRESS="${COMPRESS:-true}"        # Compress old logs

# Create log directory if doesn't exist
mkdir -p "$LOG_DIR"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Rotate a single log file
rotate_log() {
    local logfile="$1"
    local basename=$(basename "$logfile")
    local timestamp=$(date +'%Y%m%d-%H%M%S')
    local rotated="${LOG_DIR}/${basename}.${timestamp}"
    
    if [ ! -f "$logfile" ]; then
        return
    fi
    
    # Check size
    local size=$(stat -f%z "$logfile" 2>/dev/null || stat -c%s "$logfile" 2>/dev/null || echo 0)
    local max_bytes=$(numfmt --from=iec "$MAX_SIZE" 2>/dev/null || echo 104857600)
    
    if [ "$size" -gt "$max_bytes" ]; then
        log "Rotating $logfile (size: $(numfmt --to=iec $size 2>/dev/null || echo ${size}B))"
        
        # Move current log
        mv "$logfile" "$rotated"
        
        # Create new empty log
        touch "$logfile"
        
        # Compress if enabled
        if [ "$COMPRESS" = "true" ]; then
            log "Compressing $rotated"
            gzip "$rotated" &
        fi
    fi
}

# Clean old logs
cleanup_old_logs() {
    log "Cleaning logs older than $RETENTION_DAYS days..."
    
    # Find and delete old logs
    find "$LOG_DIR" -name "*.log.*" -mtime "+$RETENTION_DAYS" -exec rm -f {} \;
    find "$LOG_DIR" -name "*.gz" -mtime "+$RETENTION_DAYS" -exec rm -f {} \;
    
    log "Cleanup completed"
}

# Main rotation logic
main() {
    log "Starting log rotation..."
    
    # Rotate all .log files in LOG_DIR
    for logfile in "$LOG_DIR"/*.log; do
        [ -f "$logfile" ] && rotate_log "$logfile"
    done
    
    # Also check common locations
    [ -f "/data/startup-times.log" ] && rotate_log "/data/startup-times.log"
    [ -f "/data/latest.log" ] && rotate_log "/data/latest.log"
    
    # Cleanup old files
    cleanup_old_logs
    
    log "Log rotation completed successfully"
}

# Run if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main
fi

