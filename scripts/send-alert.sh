#!/bin/bash
################################################################################
# DockerCraft - Alert Notification Script
#
# Description:
#   Sends alert notifications to Discord and/or Slack webhooks when server
#   resources exceed configured thresholds.
#
# Usage:
#   ./send-alert.sh [OPTIONS]
#
# Options:
#   -t, --type TYPE         Alert type: discord, slack, or both (default: both)
#   -l, --level LEVEL       Alert level: info, warning, error (default: warning)
#   -c, --container NAME    Container name
#   -m, --message TEXT      Alert message
#   --cpu NUM               CPU usage percentage
#   --memory NUM            Memory usage percentage
#   --disk NUM              Disk usage percentage
#   -d, --discord-url URL   Discord webhook URL (or env: DISCORD_WEBHOOK_URL)
#   -s, --slack-url URL     Slack webhook URL (or env: SLACK_WEBHOOK_URL)
#   -q, --quiet             Quiet mode (no console output)
#   -h, --help              Show this help message
#
# Environment Variables:
#   DISCORD_WEBHOOK_URL     Discord webhook URL
#   SLACK_WEBHOOK_URL       Slack webhook URL
#
# Exit Codes:
#   0 - Alert sent successfully
#   1 - Partial failure (some webhooks failed)
#   2 - Critical error (no webhooks configured or all failed)
#
# Examples:
#   ./send-alert.sh -c minecraft-server -m "High CPU usage" --cpu 85
#   ./send-alert.sh -t discord -l error -m "Server down"
#   ./send-alert.sh --cpu 90 --memory 85 --disk 92
#
################################################################################

set -eo pipefail

# Default configuration
ALERT_TYPE="both"
ALERT_LEVEL="warning"
CONTAINER_NAME=""
MESSAGE=""
CPU_USAGE=""
MEMORY_USAGE=""
DISK_USAGE=""
DISCORD_URL="${DISCORD_WEBHOOK_URL:-}"
SLACK_URL="${SLACK_WEBHOOK_URL:-}"
QUIET_MODE=false
EXIT_CODE=0

################################################################################
# Helper Functions
################################################################################

log() {
    if [ "$QUIET_MODE" = false ]; then
        echo "$@" >&2
    fi
}

usage() {
    grep '^#' "$0" | grep -v '#!/bin/bash' | sed 's/^# //' | sed 's/^#//'
    exit 0
}

get_color_code() {
    local level="$1"
    case "$level" in
        info)
            echo "3447003"  # Blue
            ;;
        warning)
            echo "16776960" # Yellow
            ;;
        error)
            echo "15158332" # Red
            ;;
        *)
            echo "3447003"  # Default: Blue
            ;;
    esac
}

get_emoji() {
    local level="$1"
    case "$level" in
        info)
            echo "ℹ️"
            ;;
        warning)
            echo "⚠️"
            ;;
        error)
            echo "🚨"
            ;;
        *)
            echo "📊"
            ;;
    esac
}

################################################################################
# Discord Functions
################################################################################

send_discord_webhook() {
    local webhook_url="$1"
    
    if [ -z "$webhook_url" ]; then
        log "Discord webhook URL not configured"
        return 1
    fi
    
    local color_code
    color_code=$(get_color_code "$ALERT_LEVEL")
    
    local emoji
    emoji=$(get_emoji "$ALERT_LEVEL")
    
    local timestamp
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date -u +"%Y-%m-%dT%H:%M:%S.000Z")
    
    # Build fields array
    local fields="[]"
    
    if [ -n "$CONTAINER_NAME" ]; then
        fields=$(echo "$fields" | jq --arg name "$CONTAINER_NAME" '. += [{"name": "Container", "value": $name, "inline": true}]')
    fi
    
    if [ -n "$CPU_USAGE" ]; then
        fields=$(echo "$fields" | jq --arg cpu "$CPU_USAGE%" '. += [{"name": "CPU Usage", "value": $cpu, "inline": true}]')
    fi
    
    if [ -n "$MEMORY_USAGE" ]; then
        fields=$(echo "$fields" | jq --arg mem "$MEMORY_USAGE%" '. += [{"name": "Memory Usage", "value": $mem, "inline": true}]')
    fi
    
    if [ -n "$DISK_USAGE" ]; then
        fields=$(echo "$fields" | jq --arg disk "$DISK_USAGE%" '. += [{"name": "Disk Usage", "value": $disk, "inline": true}]')
    fi
    
    # Build embed
    local embed
    embed=$(jq -n \
        --arg title "$emoji DockerCraft Alert" \
        --arg desc "$MESSAGE" \
        --arg color "$color_code" \
        --arg timestamp "$timestamp" \
        --arg level "$(echo "$ALERT_LEVEL" | tr '[:lower:]' '[:upper:]')" \
        --argjson fields "$fields" \
        '{
            embeds: [{
                title: $title,
                description: $desc,
                color: ($color | tonumber),
                timestamp: $timestamp,
                fields: $fields,
                footer: {
                    text: ("Alert Level: " + $level)
                }
            }]
        }')
    
    # Send webhook
    local response
    response=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "Content-Type: application/json" \
        -d "$embed" \
        "$webhook_url")
    
    if [ "$response" = "204" ] || [ "$response" = "200" ]; then
        log "✓ Discord alert sent successfully"
        return 0
    else
        log "✗ Discord alert failed (HTTP $response)"
        return 1
    fi
}

################################################################################
# Slack Functions
################################################################################

send_slack_webhook() {
    local webhook_url="$1"
    
    if [ -z "$webhook_url" ]; then
        log "Slack webhook URL not configured"
        return 1
    fi
    
    local emoji
    emoji=$(get_emoji "$ALERT_LEVEL")
    
    local color
    case "$ALERT_LEVEL" in
        info)
            color="#3AA3E3"
            ;;
        warning)
            color="#FFD500"
            ;;
        error)
            color="#E74C3C"
            ;;
        *)
            color="#3AA3E3"
            ;;
    esac
    
    # Build fields array
    local fields="[]"
    
    if [ -n "$CONTAINER_NAME" ]; then
        fields=$(echo "$fields" | jq --arg name "$CONTAINER_NAME" '. += [{"title": "Container", "value": $name, "short": true}]')
    fi
    
    if [ -n "$CPU_USAGE" ]; then
        fields=$(echo "$fields" | jq --arg cpu "$CPU_USAGE%" '. += [{"title": "CPU Usage", "value": $cpu, "short": true}]')
    fi
    
    if [ -n "$MEMORY_USAGE" ]; then
        fields=$(echo "$fields" | jq --arg mem "$MEMORY_USAGE%" '. += [{"title": "Memory Usage", "value": $mem, "short": true}]')
    fi
    
    if [ -n "$DISK_USAGE" ]; then
        fields=$(echo "$fields" | jq --arg disk "$DISK_USAGE%" '. += [{"title": "Disk Usage", "value": $disk, "short": true}]')
    fi
    
    # Build attachment
    local attachment
    attachment=$(jq -n \
        --arg fallback "$emoji DockerCraft Alert: $MESSAGE" \
        --arg color "$color" \
        --arg title "$emoji DockerCraft Alert" \
        --arg text "$MESSAGE" \
        --arg level "$(echo "$ALERT_LEVEL" | tr '[:lower:]' '[:upper:]')" \
        --arg timestamp "$(date +%s)" \
        --argjson fields "$fields" \
        '{
            attachments: [{
                fallback: $fallback,
                color: $color,
                title: $title,
                text: $text,
                fields: $fields,
                footer: ("Alert Level: " + $level),
                ts: ($timestamp | tonumber)
            }]
        }')
    
    # Send webhook
    local response
    response=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "Content-Type: application/json" \
        -d "$attachment" \
        "$webhook_url")
    
    if [ "$response" = "200" ]; then
        log "✓ Slack alert sent successfully"
        return 0
    else
        log "✗ Slack alert failed (HTTP $response)"
        return 1
    fi
}

################################################################################
# Main Function
################################################################################

main() {
    # Check for required tools
    if ! command -v curl &> /dev/null; then
        log "ERROR: curl is required but not installed"
        exit 2
    fi
    
    if ! command -v jq &> /dev/null; then
        log "ERROR: jq is required but not installed"
        exit 2
    fi
    
    # Validate configuration
    if [ -z "$MESSAGE" ]; then
        log "ERROR: Alert message is required (-m, --message)"
        exit 2
    fi
    
    # Determine which webhooks to send
    local send_discord=false
    local send_slack=false
    
    case "$ALERT_TYPE" in
        discord)
            send_discord=true
            ;;
        slack)
            send_slack=true
            ;;
        both)
            send_discord=true
            send_slack=true
            ;;
        *)
            log "ERROR: Invalid alert type: $ALERT_TYPE"
            exit 2
            ;;
    esac
    
    # Send alerts
    local discord_result=0
    local slack_result=0
    
    if [ "$send_discord" = true ]; then
        if [ -n "$DISCORD_URL" ]; then
            send_discord_webhook "$DISCORD_URL" || discord_result=$?
        else
            log "WARNING: Discord alert requested but webhook URL not configured"
            discord_result=1
        fi
    fi
    
    if [ "$send_slack" = true ]; then
        if [ -n "$SLACK_URL" ]; then
            send_slack_webhook "$SLACK_URL" || slack_result=$?
        else
            log "WARNING: Slack alert requested but webhook URL not configured"
            slack_result=1
        fi
    fi
    
    # Determine exit code
    if [ "$discord_result" -ne 0 ] && [ "$slack_result" -ne 0 ]; then
        log "ERROR: All alert notifications failed"
        exit 2
    elif [ "$discord_result" -ne 0 ] || [ "$slack_result" -ne 0 ]; then
        log "WARNING: Some alert notifications failed"
        exit 1
    else
        log "SUCCESS: All alert notifications sent"
        exit 0
    fi
}

################################################################################
# Parse Arguments
################################################################################

while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--type)
            ALERT_TYPE="$2"
            shift 2
            ;;
        -l|--level)
            ALERT_LEVEL="$2"
            shift 2
            ;;
        -c|--container)
            CONTAINER_NAME="$2"
            shift 2
            ;;
        -m|--message)
            MESSAGE="$2"
            shift 2
            ;;
        --cpu)
            CPU_USAGE="$2"
            shift 2
            ;;
        --memory)
            MEMORY_USAGE="$2"
            shift 2
            ;;
        --disk)
            DISK_USAGE="$2"
            shift 2
            ;;
        -d|--discord-url)
            DISCORD_URL="$2"
            shift 2
            ;;
        -s|--slack-url)
            SLACK_URL="$2"
            shift 2
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

