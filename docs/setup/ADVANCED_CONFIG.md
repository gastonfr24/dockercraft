# Advanced Configuration Guide - DockerCraft

Complete reference for advanced server configuration using environment variables.

---

## 🎛️ Advanced Environment Variables

### Auto-Install Plugins

#### Spiget Resources (SpigotMC)

```env
# Install plugins by Spiget ID (comma-separated)
SPIGET_RESOURCES=28140,1997,19254

# IDs from SpigotMC URLs:
# https://www.spigotmc.org/resources/essentialsx.9089/
#                                        ^^^^ - use this ID
```

**Popular Plugin IDs:**
- EssentialsX: `9089`
- Vault: `34315`
- LuckPerms: `28140`
- WorldEdit: `13932`
- WorldGuard: `13261`
- CoreProtect: `8631`

#### Direct URLs

```env
# Install plugins from direct URLs
PLUGINS=https://example.com/plugin1.jar,https://example.com/plugin2.jar

# Or multiline
PLUGINS: |
  https://example.com/plugin1.jar
  https://example.com/plugin2.jar
  https://example.com/plugin3.jar
```

---

### Auto-Install Mods

#### Modrinth (Fabric/Forge)

```env
# Install mods by project slug
MODRINTH_PROJECTS=sodium,lithium,starlight

# Or multiline
MODRINTH_PROJECTS: |
  sodium
  lithium
  starlight
  ferritecore
```

**Popular Mods:**
- Sodium: `sodium`
- Lithium: `lithium`
- Starlight: `starlight`
- FerriteCore: `ferritecore`
- LazyDFU: `lazydfu`

#### Direct URLs

```env
# Install mods from URLs
MODS=https://example.com/mod1.jar,https://example.com/mod2.jar
```

---

### Whitelist Management

#### Enable Whitelist

```env
# Enable whitelist
ENABLE_WHITELIST=TRUE

# Add players (comma-separated)
WHITELIST=player1,player2,player3

# Enforce whitelist (kick non-whitelisted players)
ENFORCE_WHITELIST=TRUE
```

#### Dynamic Whitelist

```yaml
services:
  minecraft:
    environment:
      ENABLE_WHITELIST: "TRUE"
      WHITELIST: "${WHITELIST_PLAYERS}"  # From external source
```

---

### Server Operators

```env
# Add operators (comma-separated)
OPS=admin1,admin2,admin3

# Operators have full permissions
```

**Note:** Operators can:
- Execute any command
- Bypass whitelist
- Manage server settings

---

### World Generation

#### Custom Seed

```env
# Set world seed
SEED=-1234567890

# Or use a text seed
SEED=MyCustomSeed123
```

#### Level Type

```env
# World type options:
LEVEL_TYPE=default      # Normal world
LEVEL_TYPE=flat         # Superflat
LEVEL_TYPE=largeBiomes  # Large biomes
LEVEL_TYPE=amplified    # Extreme hills
LEVEL_TYPE=buffet       # Single biome
```

#### Generator Settings (Flat Worlds)

```env
LEVEL_TYPE=flat
GENERATOR_SETTINGS='{"layers":[{"block":"bedrock","height":1},{"block":"stone","height":10},{"block":"dirt","height":3},{"block":"grass_block","height":1}],"biome":"plains"}'
```

#### Custom World Name

```env
# Default is "world"
LEVEL=MyCustomWorld
```

---

### Gameplay Rules

#### PvP Settings

```env
PVP=true              # Enable PvP
PVP=false             # Disable PvP
```

#### Difficulty

```env
DIFFICULTY=peaceful   # No monsters
DIFFICULTY=easy       # Easy monsters
DIFFICULTY=normal     # Normal difficulty
DIFFICULTY=hard       # Hard difficulty
```

#### Game Mode

```env
MODE=survival        # Survival mode
MODE=creative        # Creative mode
MODE=adventure       # Adventure mode
MODE=spectator       # Spectator mode
```

#### Force Game Mode

```env
# Force players to gamemode on join
FORCE_GAMEMODE=true
```

---

### Spawn Control

#### Mob Spawning

```env
SPAWN_ANIMALS=true    # Animals (cows, pigs, etc.)
SPAWN_MONSTERS=true   # Monsters (zombies, skeletons)
SPAWN_NPCS=true       # Villagers
```

#### Spawn Protection

```env
# Radius around spawn where only OPs can build
SPAWN_PROTECTION=16   # 16 blocks radius
SPAWN_PROTECTION=0    # Disable protection
```

---

### View Distance

```env
# Render distance (3-32 chunks)
VIEW_DISTANCE=10

# Simulation distance (3-32 chunks)
SIMULATION_DISTANCE=8
```

**Recommendations:**
- **Low-end:** VIEW_DISTANCE=6, SIMULATION_DISTANCE=4
- **Medium:** VIEW_DISTANCE=10, SIMULATION_DISTANCE=8
- **High-end:** VIEW_DISTANCE=16, SIMULATION_DISTANCE=10

---

### Command Blocks

```env
# Enable command blocks
ENABLE_COMMAND_BLOCK=true
```

---

### Max Players

```env
MAX_PLAYERS=20    # Default
MAX_PLAYERS=100   # Large server
MAX_PLAYERS=5     # Small private server
```

---

## 🎨 Configuration Examples

### Vanilla+ Performance Server

```yaml
services:
  vanilla-plus:
    environment:
      TYPE: "FABRIC"
      VERSION: "1.20.1"
      MEMORY: "4G"
      
      # Performance mods
      MODRINTH_PROJECTS: |
        sodium
        lithium
        starlight
        ferritecore
      
      # Optimized settings
      VIEW_DISTANCE: "10"
      SIMULATION_DISTANCE: "8"
      USE_AIKAR_FLAGS: "true"
```

### Whitelist Survival Server

```yaml
services:
  survival:
    environment:
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "6G"
      
      # Whitelist
      ENABLE_WHITELIST: "TRUE"
      WHITELIST: "player1,player2,player3"
      OPS: "admin"
      
      # Survival settings
      MODE: "survival"
      DIFFICULTY: "normal"
      PVP: "true"
      
      # Essential plugins
      SPIGET_RESOURCES: "9089,28140,8631"
```

### Creative Build Server

```yaml
services:
  creative:
    environment:
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "3G"
      
      # Creative mode
      MODE: "creative"
      DIFFICULTY: "peaceful"
      PVP: "false"
      
      # No mobs
      SPAWN_ANIMALS: "false"
      SPAWN_MONSTERS: "false"
      
      # Building plugins
      SPIGET_RESOURCES: "13932,13261"  # WorldEdit, WorldGuard
```

### Skyblock Server

```yaml
services:
  skyblock:
    environment:
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "4G"
      
      # Void world
      LEVEL_TYPE: "flat"
      GENERATOR_SETTINGS: '{"layers":[{"block":"air","height":1}]}'
      
      # Skyblock plugins
      SPIGET_RESOURCES: "9089,42724"  # EssentialsX, BentoBox
      
      MODE: "survival"
      DIFFICULTY: "normal"
```

### Hardcore Challenge

```yaml
services:
  hardcore:
    environment:
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "6G"
      
      # Hardcore mode
      HARDCORE: "true"
      DIFFICULTY: "hard"
      MODE: "survival"
      
      # Restricted access
      ENABLE_WHITELIST: "TRUE"
      WHITELIST: "hardcore_player1,hardcore_player2"
      
      # Extra challenge
      SPAWN_MONSTERS: "true"
      PVP: "true"
```

---

## 🔧 Dynamic Configuration

### Using External Variables

```yaml
services:
  minecraft:
    environment:
      WHITELIST: "${WHITELIST_PLAYERS}"
      OPS: "${ADMIN_PLAYERS}"
      MAX_PLAYERS: "${MAX_PLAYERS}"
      DIFFICULTY: "${DIFFICULTY}"
```

```bash
# .env file or environment
export WHITELIST_PLAYERS="player1,player2"
export ADMIN_PLAYERS="admin"
export MAX_PLAYERS="20"
export DIFFICULTY="normal"
```

### Configuration via API

```python
# Update server configuration
container = client.containers.get("mc-server-1")

# Update environment
container.exec_run("rcon-cli whitelist add player4")
container.exec_run("rcon-cli op admin2")
container.exec_run("rcon-cli difficulty hard")
```

---

## 📊 Configuration Presets

### Preset: Casual Survival

```env
TYPE=PAPER
VERSION=LATEST
MEMORY=4G
MODE=survival
DIFFICULTY=easy
PVP=false
VIEW_DISTANCE=10
MAX_PLAYERS=10
SPIGET_RESOURCES=9089,28140
```

### Preset: Competitive PvP

```env
TYPE=PAPER
VERSION=LATEST
MEMORY=6G
MODE=adventure
DIFFICULTY=hard
PVP=true
SPAWN_MONSTERS=false
VIEW_DISTANCE=8
MAX_PLAYERS=50
SPIGET_RESOURCES=9089,28140,13261
```

### Preset: Modded Adventure

```env
TYPE=FORGE
VERSION=1.20.1
MEMORY=10G
MODE=survival
DIFFICULTY=normal
PVP=true
VIEW_DISTANCE=10
CURSEFORGE_FILES=https://www.curseforge.com/minecraft/modpacks/all-the-mods-9
```

---

## 🐛 Troubleshooting

### Plugins Not Loading

**Symptom:** Plugins don't appear in `/plugins`

**Solutions:**
1. Check plugin IDs are correct
2. Verify server type supports plugins (PAPER/SPIGOT)
3. Check logs for errors:
```bash
docker logs mc-server-1 | grep -i "plugin"
```

### Whitelist Not Working

**Symptom:** Non-whitelisted players can join

**Solutions:**
1. Verify `ENABLE_WHITELIST=TRUE`
2. Check whitelist file:
```bash
docker exec mc-server-1 cat /data/whitelist.json
```
3. Reload whitelist:
```bash
docker exec mc-server-1 rcon-cli whitelist reload
```

### World Not Generating Correctly

**Symptom:** Wrong world type

**Solutions:**
1. Delete existing world:
```bash
docker-compose down
docker volume rm <volume-name>
docker-compose up -d
```
2. Verify LEVEL_TYPE is set before first start

---

## 📚 Additional Resources

- **itzg Environment Variables:** https://docker-minecraft-server.readthedocs.io/en/latest/variables/
- **Spiget API:** https://spiget.org/
- **Modrinth:** https://modrinth.com/
- **Minecraft Wiki:** https://minecraft.wiki/

---

**Last Updated:** 2025-10-24
**DockerCraft Version:** v0.4.0 (Sprint 3)

