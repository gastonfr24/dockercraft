#!/bin/bash
# Startup Timing Logger for Minecraft Server
# Tracks and logs timing for each initialization phase

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

# Timing file
TIMING_FILE="/data/startup-times.log"
LAST_STARTUP_FILE="/data/last-startup-time.txt"

# Start time
START_TIME=$(date +%s%N)
PHASE_START=$START_TIME

log_phase() {
    local phase_name="$1"
    local current_time=$(date +%s%N)
    local phase_duration=$(( (current_time - PHASE_START) / 1000000 ))
    local total_duration=$(( (current_time - START_TIME) / 1000000 ))
    
    # Calculate percentage (approximate)
    local percentage=$((total_duration * 100 / 5000)) # Assuming ~5s total
    if [ $percentage -gt 100 ]; then percentage=100; fi
    
    # Progress bar
    local filled=$((percentage / 5))
    local empty=$((20 - filled))
    local bar=$(printf '%*s' "$filled" | tr ' ' '█')
    local space=$(printf '%*s' "$empty" | tr ' ' '░')
    
    echo -e "${CYAN}[Minecraft]${NC} [${bar}${space}] ${percentage}% ${phase_name}... ${BOLD}(${phase_duration}ms)${NC}"
    
    # Log to file
    echo "$(date -Iseconds) | $phase_name | ${phase_duration}ms | ${total_duration}ms" >> "$TIMING_FILE"
    
    PHASE_START=$current_time
}

# Mostrar header
echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║         🎮 Minecraft Server - Startup Timeline            ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}⏱️  Initialization Timeline:${NC}"
echo ""

# Exportar funciones para que las use el servidor
export -f log_phase
export START_TIME
export PHASE_START
export TIMING_FILE
export GREEN YELLOW CYAN RED BOLD NC

# Al finalizar, mostrar resumen
show_summary() {
    local end_time=$(date +%s%N)
    local total_ms=$(( (end_time - START_TIME) / 1000000 ))
    local total_s=$(echo "scale=1; $total_ms / 1000" | bc)
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              ✅ SERVER STARTED SUCCESSFULLY                ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}⏱️  Total startup time: ${BOLD}${total_s}s${NC}"
    
    # Comparar con startup anterior si existe
    if [ -f "$LAST_STARTUP_FILE" ]; then
        local last_time=$(cat "$LAST_STARTUP_FILE")
        local diff=$(echo "scale=1; $total_s - $last_time" | bc)
        
        if (( $(echo "$diff < 0" | bc -l) )); then
            echo -e "${GREEN}📊 Comparison: ${BOLD}${diff#-}s faster${NC} ${GREEN}than last startup ⚡${NC}"
        elif (( $(echo "$diff > 0" | bc -l) )); then
            echo -e "${YELLOW}📊 Comparison: ${BOLD}${diff}s slower${NC} ${YELLOW}than last startup 🐢${NC}"
        else
            echo -e "${CYAN}📊 Comparison: Same as last startup${NC}"
        fi
    fi
    
    # Guardar tiempo actual
    echo "$total_s" > "$LAST_STARTUP_FILE"
    
    echo ""
}

trap show_summary EXIT

# Simular fases (esto se integrará con el servidor real)
log_phase "Loading server properties"
log_phase "Initializing server engine"
log_phase "Loading plugins"
log_phase "Preparing spawn area"
log_phase "Server ready"

echo ""
echo -e "${GREEN}✅ Server is ready!${NC}"
echo ""

