# DockerCraft - Minecraft Server Base Template
# Based on itzg/minecraft-server with optimized configuration
# See: https://github.com/itzg/docker-minecraft-server

FROM itzg/minecraft-server:java21

LABEL maintainer="dockercraft"
LABEL description="Optimized Minecraft server template for dynamic instance creation"
LABEL version="0.1.0-alpha"

# Server configuration with sensible defaults
ENV VERSION=${VERSION:-LATEST} \
    TYPE=${TYPE:-PAPER} \
    EULA=${EULA:-FALSE} \
    MEMORY=${MEMORY:-4G} \
    MAX_PLAYERS=${MAX_PLAYERS:-20} \
    DIFFICULTY=${DIFFICULTY:-normal} \
    GAMEMODE=${GAMEMODE:-survival} \
    PVP=${PVP:-true} \
    VIEW_DISTANCE=${VIEW_DISTANCE:-10} \
    SIMULATION_DISTANCE=${SIMULATION_DISTANCE:-10} \
    LEVEL_NAME=${LEVEL_NAME:-world} \
    MOTD="${MOTD:-A Minecraft Server}" \
    SPAWN_PROTECTION=${SPAWN_PROTECTION:-16}

# Auto-pause configuration for resource optimization
ENV ENABLE_AUTOPAUSE=${ENABLE_AUTOPAUSE:-TRUE} \
    AUTOPAUSE_TIMEOUT_EST=${AUTOPAUSE_TIMEOUT_EST:-300} \
    AUTOPAUSE_TIMEOUT_INIT=${AUTOPAUSE_TIMEOUT_INIT:-600} \
    AUTOPAUSE_TIMEOUT_KN=${AUTOPAUSE_TIMEOUT_KN:-120} \
    AUTOPAUSE_PERIOD=${AUTOPAUSE_PERIOD:-10}

# RCON configuration for remote control
ENV ENABLE_RCON=${ENABLE_RCON:-true} \
    RCON_PORT=${RCON_PORT:-25575} \
    RCON_PASSWORD=${RCON_PASSWORD:-minecraft}

# Server optimization flags
ENV USE_AIKAR_FLAGS=${USE_AIKAR_FLAGS:-true} \
    INIT_MEMORY=${INIT_MEMORY:-1G} \
    MAX_MEMORY=${MAX_MEMORY:-${MEMORY}}

# Server properties
ENV SERVER_PORT=${SERVER_PORT:-25565} \
    ONLINE_MODE=${ONLINE_MODE:-true} \
    ALLOW_FLIGHT=${ALLOW_FLIGHT:-false} \
    MAX_TICK_TIME=${MAX_TICK_TIME:-60000} \
    ENABLE_COMMAND_BLOCK=${ENABLE_COMMAND_BLOCK:-false} \
    SPAWN_ANIMALS=${SPAWN_ANIMALS:-true} \
    SPAWN_MONSTERS=${SPAWN_MONSTERS:-true} \
    SPAWN_NPCS=${SPAWN_NPCS:-true}

# Logging configuration
ENV LOG_TIMESTAMP=${LOG_TIMESTAMP:-true} \
    GUI=${GUI:-FALSE} \
    TZ=${TZ:-America/New_York}

# Health check to monitor server status
# Checks if server is responsive via mc-health utility
HEALTHCHECK --interval=30s \
            --timeout=10s \
            --start-period=120s \
            --retries=3 \
  CMD mc-health || exit 1

# Volume for persistent data
# All world data, configs, plugins, and logs stored here
VOLUME /data

# Expose Minecraft server port
EXPOSE ${SERVER_PORT:-25565}

# Expose RCON port for remote administration
EXPOSE ${RCON_PORT:-25575}

