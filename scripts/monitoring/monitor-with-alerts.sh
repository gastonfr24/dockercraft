#!/bin/bash
################################################################################
# DockerCraft - Monitoring with Alerts Integration
#
# Description:
#   Wrapper script that runs monitoring and sends alerts when thresholds
#   are exceeded. This script combines monitor.sh and send-alert.sh.
#
# Usage:
#   1. Configure .env.alerts with webhook URLs
#   2. Run: ./scripts/monitor-with-alerts.sh
#
# Environment:
#   Reads configuration from .env.alerts if present
#
# Exit Codes:
#   Same as monitor.sh (0 = OK, 1 = Warning, 2 = Error)
#
################################################################################

set -eo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Load alert configuration if available
if [ -f "$PROJECT_ROOT/.env.alerts" ]; then
    # shellcheck disable=SC1091
    source "$PROJECT_ROOT/.env.alerts"
fi

# Default thresholds (can be overridden by .env.alerts)
ALERT_THRESHOLD_CPU="${ALERT_THRESHOLD_CPU:-80}"
ALERT_THRESHOLD_MEMORY="${ALERT_THRESHOLD_MEMORY:-80}"
ALERT_THRESHOLD_DISK="${ALERT_THRESHOLD_DISK:-85}"

# Temporary file for JSON output
MONITOR_OUTPUT=$(mktemp)
trap 'rm -f "$MONITOR_OUTPUT"' EXIT

################################################################################
# Run Monitoring
################################################################################

echo "Running DockerCraft monitoring..."
echo ""

# Run monitor script with JSON output
"$SCRIPT_DIR/monitor.sh" \
    -w "$ALERT_THRESHOLD_CPU" \
    -W "$ALERT_THRESHOLD_MEMORY" \
    -d "$ALERT_THRESHOLD_DISK" \
    --json > "$MONITOR_OUTPUT" 2>&1

MONITOR_EXIT_CODE=$?

# If monitoring returned warning (exit code 1), send alerts
if [ $MONITOR_EXIT_CODE -eq 1 ]; then
    echo ""
    echo "⚠️ Warning: Resource thresholds exceeded"
    echo ""
    
    # Check if send-alert.sh exists
    if [ ! -x "$SCRIPT_DIR/send-alert.sh" ]; then
        echo "ERROR: send-alert.sh not found or not executable"
        exit 2
    fi
    
    # Check if webhook URLs are configured
    if [ -z "$DISCORD_WEBHOOK_URL" ] && [ -z "$SLACK_WEBHOOK_URL" ]; then
        echo "WARNING: No webhook URLs configured in .env.alerts"
        echo "Skipping alert notifications"
        echo ""
        echo "To enable alerts:"
        echo "  1. cp .env.alerts.example .env.alerts"
        echo "  2. Edit .env.alerts with your webhook URLs"
        exit $MONITOR_EXIT_CODE
    fi
    
    # Parse JSON output and extract metrics
    if command -v jq &> /dev/null; then
        CONTAINER=$(echo "$MONITOR_OUTPUT" | jq -r '.container // "unknown"')
        CPU=$(echo "$MONITOR_OUTPUT" | jq -r '.cpu_percent // ""')
        MEMORY=$(echo "$MONITOR_OUTPUT" | jq -r '.memory.percent // ""')
        DISK=$(echo "$MONITOR_OUTPUT" | jq -r '.disk.percent // "" | gsub("%"; "")')
        
        # Build alert message
        ALERT_MESSAGE="Resource threshold exceeded for container '$CONTAINER'"
        
        # Send alert
        "$SCRIPT_DIR/send-alert.sh" \
            -c "$CONTAINER" \
            -m "$ALERT_MESSAGE" \
            --cpu "$CPU" \
            --memory "$MEMORY" \
            ${DISK:+--disk "$DISK"} \
            -l warning
        
        ALERT_EXIT_CODE=$?
        
        if [ $ALERT_EXIT_CODE -eq 0 ]; then
            echo "✓ Alert notifications sent successfully"
        elif [ $ALERT_EXIT_CODE -eq 1 ]; then
            echo "⚠️ Some alert notifications failed"
        else
            echo "✗ Alert notifications failed"
        fi
    else
        echo "WARNING: jq not installed, cannot parse monitoring data"
        echo "Install jq to enable automatic alerts"
        echo ""
        echo "  Ubuntu/Debian: sudo apt install jq"
        echo "  CentOS/RHEL:   sudo yum install jq"
        echo "  macOS:         brew install jq"
    fi
    
    echo ""
fi

# Exit with monitoring script's exit code
exit $MONITOR_EXIT_CODE

