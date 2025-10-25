# Configuration Examples - DockerCraft

Real-world configuration examples for common server setups.

---

## 🎮 Common Server Types

### 1. Vanilla Survival Server

**Use Case:** Classic Minecraft experience for friends

```yaml
services:
  vanilla-survival:
    build: .
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "4G"
      SERVER_NAME: "Vanilla Survival"
      
      # Survival settings
      MODE: "survival"
      DIFFICULTY: "normal"
      PVP: "true"
      MAX_PLAYERS: "10"
      
      # Optimizations
      USE_AIKAR_FLAGS: "true"
      VIEW_DISTANCE: "10"
      SIMULATION_DISTANCE: "8"
    volumes:
      - survival-data:/data
```

**Connect:** `localhost:25565`

---

### 2. Modded Server (All The Mods 9)

**Use Case:** Heavy modded gameplay

```yaml
services:
  atm9:
    build: .
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      TYPE: "FORGE"
      VERSION: "1.20.1"
      MEMORY: "10G"
      SERVER_NAME: "ATM9 Server"
      
      # Modpack
      CURSEFORGE_FILES: "https://www.curseforge.com/minecraft/modpacks/all-the-mods-9"
      
      # Performance
      USE_AIKAR_FLAGS: "true"
      MAX_TICK_TIME: "-1"
    volumes:
      - atm9-data:/data
    deploy:
      resources:
        limits:
          memory: 12G
          cpus: '4'
```

**Requirements:** 12GB RAM, 4 CPU cores

---

### 3. Whitelisted Private Server

**Use Case:** Private server for specific players

```yaml
services:
  private:
    build: .
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "6G"
      SERVER_NAME: "Private Server"
      
      # Whitelist
      ENABLE_WHITELIST: "TRUE"
      WHITELIST: "player1,player2,player3,player4"
      OPS: "player1"
      
      # Gameplay
      MODE: "survival"
      DIFFICULTY: "hard"
      
      # Plugins
      SPIGET_RESOURCES: "9089,28140,8631"  # Essentials, LuckPerms, CoreProtect
    volumes:
      - private-data:/data
```

---

### 4. Creative Building Server

**Use Case:** Creative builds and planning

```yaml
services:
  creative:
    build: .
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "3G"
      SERVER_NAME: "Creative Builder"
      
      # Creative mode
      MODE: "creative"
      DIFFICULTY: "peaceful"
      PVP: "false"
      
      # No mobs
      SPAWN_ANIMALS: "false"
      SPAWN_MONSTERS: "false"
      
      # Building tools
      SPIGET_RESOURCES: "13932,13261,18494"  # WorldEdit, WorldGuard, VoxelSniper
    volumes:
      - creative-data:/data
```

---

### 5. Multi-Server Network

**Use Case:** Multiple servers with proxy (hub + games)

```yaml
services:
  proxy:
    image: itzg/bungeecord:java17
    ports:
      - "25565:25577"
    environment:
      TYPE: "VELOCITY"
      MEMORY: "512M"
      VELOCITY_SECRET: "my-secret-key"
    networks:
      - minecraft-network

  hub:
    build: .
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "2G"
      SERVER_NAME: "Hub"
      PROXY_MODE: "VELOCITY"
      VELOCITY_SECRET: "my-secret-key"
      ONLINE_MODE: "FALSE"
      MODE: "adventure"
      SPAWN_MONSTERS: "false"
    networks:
      - minecraft-network

  survival:
    build: .
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "4G"
      SERVER_NAME: "Survival"
      PROXY_MODE: "VELOCITY"
      VELOCITY_SECRET: "my-secret-key"
      ONLINE_MODE: "FALSE"
      MODE: "survival"
    networks:
      - minecraft-network

networks:
  minecraft-network:
```

**Connect:** `localhost:25565` → Hub → `/server survival`

---

## 🏗️ Specialized Servers

### Skyblock Server

```yaml
services:
  skyblock:
    build: .
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "4G"
      SERVER_NAME: "Skyblock"
      
      # Void world
      LEVEL_TYPE: "flat"
      GENERATOR_SETTINGS: '{"layers":[{"block":"air","height":1}]}'
      
      # Skyblock plugin
      SPIGET_RESOURCES: "42724"  # BentoBox
      
      MODE: "survival"
      DIFFICULTY: "normal"
    volumes:
      - skyblock-data:/data
```

### Hardcore Server

```yaml
services:
  hardcore:
    build: .
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "6G"
      SERVER_NAME: "Hardcore Challenge"
      
      # Hardcore mode
      HARDCORE: "true"
      DIFFICULTY: "hard"
      MODE: "survival"
      
      # Restricted
      ENABLE_WHITELIST: "TRUE"
      WHITELIST: "hardcore_player1,hardcore_player2"
      
      USE_AIKAR_FLAGS: "true"
    volumes:
      - hardcore-data:/data
```

### PvP Arena

```yaml
services:
  pvp:
    build: .
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "4G"
      SERVER_NAME: "PvP Arena"
      
      # PvP settings
      MODE: "adventure"
      PVP: "true"
      DIFFICULTY: "hard"
      
      # No natural spawning
      SPAWN_ANIMALS: "false"
      SPAWN_MONSTERS: "false"
      
      # PvP plugins
      SPIGET_RESOURCES: "9089,28140"
    volumes:
      - pvp-data:/data
```

---

## 🌍 International Servers

### European Server

```yaml
services:
  eu-server:
    build: .
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "6G"
      SERVER_NAME: "EU Server"
      
      # Timezone
      TZ: "Europe/London"
      
      MODE: "survival"
      MAX_PLAYERS: "50"
      USE_AIKAR_FLAGS: "true"
    volumes:
      - eu-data:/data
```

### Asian Server

```yaml
services:
  asia-server:
    build: .
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "6G"
      SERVER_NAME: "Asia Server"
      
      # Timezone
      TZ: "Asia/Tokyo"
      
      MODE: "survival"
      MAX_PLAYERS: "50"
      USE_AIKAR_FLAGS: "true"
    volumes:
      - asia-data:/data
```

---

## 🔧 Performance Configurations

### Low-End Server (2GB RAM)

```yaml
services:
  low-end:
    build: .
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "2G"
      SERVER_NAME: "Budget Server"
      
      # Reduced settings
      VIEW_DISTANCE: "6"
      SIMULATION_DISTANCE: "4"
      MAX_PLAYERS: "5"
      
      USE_AIKAR_FLAGS: "true"
    volumes:
      - low-end-data:/data
    deploy:
      resources:
        limits:
          memory: 2.5G
```

### High-Performance Server (16GB RAM)

```yaml
services:
  high-perf:
    build: .
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "14G"
      SERVER_NAME: "Performance Server"
      
      # Maximum settings
      VIEW_DISTANCE: "16"
      SIMULATION_DISTANCE: "12"
      MAX_PLAYERS: "100"
      
      USE_AIKAR_FLAGS: "true"
    volumes:
      - high-perf-data:/data
    deploy:
      resources:
        limits:
          memory: 16G
          cpus: '8'
```

---

## 🎓 Educational Servers

### School Server

```yaml
services:
  school:
    build: .
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "4G"
      SERVER_NAME: "School Server"
      
      # Safe environment
      MODE: "creative"
      DIFFICULTY: "peaceful"
      PVP: "false"
      SPAWN_MONSTERS: "false"
      
      # Whitelist students
      ENABLE_WHITELIST: "TRUE"
      OPS: "teacher1,teacher2"
      
      # Educational plugins
      SPIGET_RESOURCES: "13932"  # WorldEdit
    volumes:
      - school-data:/data
```

---

## 📊 Production Configurations

### Production Server with Backups

```yaml
services:
  production:
    build: .
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "8G"
      SERVER_NAME: "Production Server"
      
      # Production settings
      MODE: "survival"
      DIFFICULTY: "normal"
      MAX_PLAYERS: "50"
      
      # RCON for management
      ENABLE_RCON: "true"
      RCON_PASSWORD: "${RCON_PASSWORD}"  # From environment
      
      USE_AIKAR_FLAGS: "true"
    volumes:
      - production-data:/data
      - ./backups:/backups
    deploy:
      resources:
        limits:
          memory: 10G
          cpus: '4'
      restart_policy:
        condition: unless-stopped
```

**Backup script:**
```bash
#!/bin/bash
docker exec production bash /scripts/backup.sh production /backups
```

---

## 🆘 Quick Reference

| Server Type | Memory | CPU | Max Players | Type |
|-------------|--------|-----|-------------|------|
| Vanilla Survival | 4GB | 2 | 10-20 | PAPER |
| Heavy Modpack | 10-16GB | 4 | 4-10 | FORGE |
| Creative | 3GB | 1 | 10-20 | PAPER |
| PvP Arena | 4GB | 2 | 20-50 | PAPER |
| Proxy Network | 1GB | 2 | 100+ | VELOCITY |

---

**Last Updated:** 2025-10-24
**DockerCraft Version:** v0.4.0 (Sprint 3)

