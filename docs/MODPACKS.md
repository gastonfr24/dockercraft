# Modpack Installation Guide - DockerCraft

Complete guide for installing and running modpacks on your Minecraft server.

---

## 🎮 Supported Modpack Sources

### CurseForge Modpacks
The largest repository of Minecraft modpacks.

```env
TYPE=FORGE  # or FABRIC
VERSION=1.20.1
CURSEFORGE_FILES=https://www.curseforge.com/minecraft/modpacks/all-the-mods-9
```

**Supported formats:**
- Full CurseForge URL
- Project slug
- File ID

### FTB (Feed The Beast) Modpacks
Official FTB modpack support.

```env
TYPE=FORGE
VERSION=1.18.2
FTB_MODPACK_ID=ftbpresentsintegrationstoneblockedition
FTB_MODPACK_VERSION_ID=latest
```

### Modrinth Modpacks
Modern alternative to CurseForge.

```env
TYPE=FABRIC
VERSION=1.20.1
MODRINTH_MODPACK=modpack-slug
```

### Generic ZIP Modpacks
Direct URL to modpack ZIP file.

```env
TYPE=FORGE
VERSION=1.16.5
GENERIC_PACK=https://example.com/modpack.zip
```

---

## 🚀 Quick Start

### Method 1: CurseForge (Easiest)

1. Find your modpack on CurseForge
2. Copy the URL
3. Configure `.env`:

```env
EULA=TRUE
TYPE=FORGE
VERSION=1.20.1
MEMORY=10G
CURSEFORGE_FILES=https://www.curseforge.com/minecraft/modpacks/all-the-mods-9
```

4. Start server:
```bash
docker-compose up -d
```

### Method 2: Using Pre-configured Examples

```bash
# Start All The Mods 9
docker-compose -f docker-compose.modded.yml up atm9 -d

# Start FTB StoneBlock 3
docker-compose -f docker-compose.modded.yml up ftb-stoneblock3 -d

# Start RLCraft
docker-compose -f docker-compose.modded.yml up rlcraft -d
```

---

## 📦 Popular Modpacks

### All The Mods 9 (ATM9)
- **Version:** 1.20.1
- **Type:** Forge
- **Memory:** 10GB minimum
- **Description:** Kitchen sink modpack with 300+ mods

```yaml
services:
  atm9:
    environment:
      TYPE: "FORGE"
      VERSION: "1.20.1"
      MEMORY: "10G"
      CURSEFORGE_FILES: "https://www.curseforge.com/minecraft/modpacks/all-the-mods-9"
```

### FTB StoneBlock 3
- **Version:** 1.18.2
- **Type:** Forge
- **Memory:** 8GB minimum
- **Description:** Skyblock in stone

```yaml
services:
  ftb-stoneblock3:
    environment:
      TYPE: "FORGE"
      VERSION: "1.18.2"
      MEMORY: "8G"
      FTB_MODPACK_ID: "ftbpresentsintegrationstoneblockedition"
```

### RLCraft
- **Version:** 1.12.2
- **Type:** Forge
- **Memory:** 6GB minimum
- **Description:** Hardcore survival

```yaml
services:
  rlcraft:
    environment:
      TYPE: "FORGE"
      VERSION: "1.12.2"
      MEMORY: "6G"
      CF_SERVER_MOD: "https://www.curseforge.com/minecraft/modpacks/rlcraft"
```

### Fabric Performance Pack
- **Version:** 1.20.1
- **Type:** Fabric
- **Memory:** 4GB minimum
- **Description:** Vanilla+ with performance mods

```yaml
services:
  fabric-performance:
    environment:
      TYPE: "FABRIC"
      VERSION: "1.20.1"
      MEMORY: "4G"
      MODRINTH_PROJECTS: |
        sodium
        lithium
        starlight
```

---

## ⚙️ Memory Recommendations

| Modpack Size | Recommended Memory | Player Count |
|--------------|-------------------|--------------|
| **Light** (< 50 mods) | 4-6 GB | 5-10 players |
| **Medium** (50-150 mods) | 6-8 GB | 3-8 players |
| **Heavy** (150-250 mods) | 8-10 GB | 2-6 players |
| **Extreme** (250+ mods) | 10-16 GB | 2-4 players |

**Formula:**
```
Base RAM = 4GB
Per Mod = ~20MB
Players = 500MB each
```

---

## 🔧 Advanced Configuration

### Specify Modpack Version

```env
# CurseForge with specific version
CURSEFORGE_FILES=https://www.curseforge.com/minecraft/modpacks/all-the-mods-9
CF_FILE_ID=4567890  # Specific file ID

# FTB with version
FTB_MODPACK_ID=ftbpresentsintegrationstoneblockedition
FTB_MODPACK_VERSION_ID=12345
```

### Add Extra Mods

```env
# Base modpack
CURSEFORGE_FILES=https://www.curseforge.com/minecraft/modpacks/all-the-mods-9

# Additional mods
MODS=https://example.com/extra-mod1.jar,https://example.com/extra-mod2.jar
```

### Override Modpack Settings

```env
# Install modpack
CURSEFORGE_FILES=https://www.curseforge.com/minecraft/modpacks/vault-hunters

# Override settings
MAX_PLAYERS=10
DIFFICULTY=hard
VIEW_DISTANCE=8
SPAWN_PROTECTION=0
```

---

## 🐛 Troubleshooting

### Modpack Won't Download

**Symptom:** Server stuck on "Downloading modpack..."

**Solutions:**
1. Check modpack URL is correct
2. Verify internet connection
3. Try force redownload:
```env
FORCE_REDOWNLOAD=true
```

### Server Crashes on Startup

**Symptom:** Container restarts repeatedly

**Solutions:**
1. **Increase memory:**
```env
MEMORY=12G
MEM_LIMIT=14G
```

2. **Check logs:**
```bash
docker logs mc-server-1 --tail 100
```

3. **Common issues:**
   - Out of memory → Increase MEMORY
   - Missing dependency → Check modpack requirements
   - Incompatible mods → Verify mod versions

### Modpack Loads But No Mods Active

**Symptom:** Server starts but plays like vanilla

**Solutions:**
1. Check TYPE matches modpack:
   - Forge modpacks → `TYPE=FORGE`
   - Fabric modpacks → `TYPE=FABRIC`

2. Verify mods are in `/data/mods`:
```bash
docker exec mc-server-1 ls -la /data/mods
```

### Slow Modpack Loading

**Symptom:** Takes 10+ minutes to start

**Solutions:**
1. **Increase CPU allocation:**
```yaml
deploy:
  resources:
    limits:
      cpus: '4'
```

2. **Use Aikar flags:**
```env
USE_AIKAR_FLAGS=true
```

3. **Disable watchdog:**
```env
MAX_TICK_TIME=-1
```

---

## 📊 Performance Optimization

### JVM Flags for Modpacks

```env
# Enable Aikar's flags (recommended)
USE_AIKAR_FLAGS=true

# Custom JVM args (advanced)
JVM_OPTS=-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200
```

### Modpack-Specific Optimizations

#### Forge Heavy Modpacks
```env
MEMORY=12G
USE_AIKAR_FLAGS=true
MAX_TICK_TIME=-1
VIEW_DISTANCE=8
SIMULATION_DISTANCE=8
```

#### Fabric Performance Modpacks
```env
MEMORY=6G
USE_AIKAR_FLAGS=true
# Add performance mods via Modrinth
MODRINTH_PROJECTS=sodium,lithium,starlight,ferritecore
```

---

## 🔍 Finding Modpacks

### CurseForge
1. Go to https://www.curseforge.com/minecraft/modpacks
2. Filter by version and mod loader
3. Copy modpack URL
4. Paste in `CURSEFORGE_FILES`

### FTB
1. Go to https://www.feed-the-beast.com/modpacks
2. Find modpack ID (in URL)
3. Use in `FTB_MODPACK_ID`

### Modrinth
1. Go to https://modrinth.com/modpacks
2. Find modpack slug (in URL)
3. Use in `MODRINTH_MODPACK`

---

## 📝 Example Configurations

### ATM9 Production Server
```yaml
services:
  atm9-server:
    build: .
    environment:
      EULA: "TRUE"
      TYPE: "FORGE"
      VERSION: "1.20.1"
      MEMORY: "12G"
      CURSEFORGE_FILES: "https://www.curseforge.com/minecraft/modpacks/all-the-mods-9"
      MAX_PLAYERS: 10
      VIEW_DISTANCE: 10
      USE_AIKAR_FLAGS: "true"
      ENABLE_RCON: "true"
      RCON_PASSWORD: "CHANGE_ME"
    volumes:
      - atm9-data:/data
      - ./backups:/backups
    deploy:
      resources:
        limits:
          memory: 14G
          cpus: '4'
```

### Fabric Vanilla+ Server
```yaml
services:
  fabric-vanilla-plus:
    build: .
    environment:
      EULA: "TRUE"
      TYPE: "FABRIC"
      VERSION: "1.20.1"
      MEMORY: "4G"
      MODRINTH_PROJECTS: |
        sodium
        lithium
        starlight
        ferritecore
      MAX_PLAYERS: 20
      USE_AIKAR_FLAGS: "true"
```

---

## 🆘 Support

If you encounter issues:

1. **Check logs:**
```bash
docker logs mc-server-1 --tail 200
```

2. **Verify configuration:**
```bash
docker exec mc-server-1 env | grep -E "TYPE|VERSION|MEMORY|CURSEFORGE|FTB|MODRINTH"
```

3. **Create Issue:**
https://github.com/gastonfr24/dockercraft/issues

---

## 📚 Additional Resources

- **CurseForge:** https://www.curseforge.com/minecraft/modpacks
- **FTB:** https://www.feed-the-beast.com/
- **Modrinth:** https://modrinth.com/modpacks
- **itzg Modpack Docs:** https://docker-minecraft-server.readthedocs.io/en/latest/mods-and-plugins/modpacks/

---

**Last Updated:** 2025-10-24
**DockerCraft Version:** v0.4.0 (Sprint 3)

