#!/bin/bash
# Log Filter - Removes sensitive data from logs
# Filters passwords, tokens, IPs, and other sensitive information

set -e

# Patterns to filter (case insensitive)
SENSITIVE_PATTERNS=(
    # Auth tokens
    's/(password|passwd|pwd)=[^ ]*/\1=***REDACTED***/gi'
    's/(token|api_key|apikey)=[^ ]*/\1=***REDACTED***/gi'
    's/(secret|auth)=[^ ]*/\1=***REDACTED***/gi'
    
    # IP addresses (solo IPs privadas, mantener públicas para debugging)
    's/\b(192\.168\.[0-9]{1,3}\.[0-9]{1,3})\b/**PRIVATE_IP**/g'
    's/\b(10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})\b/**PRIVATE_IP**/g'
    's/\b(172\.(1[6-9]|2[0-9]|3[0-1])\.[0-9]{1,3}\.[0-9]{1,3})\b/**PRIVATE_IP**/g'
    
    # Email addresses (mantener dominio, ocultar usuario)
    's/\b[a-zA-Z0-9._%+-]+(@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})\b/***\1/g'
    
    # UUIDs (parcialmente - mantener primeros 8 chars para debugging)
    's/\b([0-9a-f]{8})-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\b/\1-****-****-****-************/gi'
)

# Read from stdin and filter
filter_logs() {
    local line
    while IFS= read -r line; do
        # Apply all filters
        for pattern in "${SENSITIVE_PATTERNS[@]}"; do
            line=$(echo "$line" | sed -E "$pattern")
        done
        echo "$line"
    done
}

# If called directly, filter stdin
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    filter_logs
fi

# Export function for sourcing
export -f filter_logs

