# Minecraft Versions & Server Types - DockerCraft

Complete guide for configuring different Minecraft versions and server types.

---

## 📦 Supported Server Types

### PAPER (Recommended)
- **Best for:** Survival servers, plugins, performance
- **Features:** High performance, plugin support, frequent updates
- **Memory:** 4GB minimum recommended
- **Plugins:** Spigot/Paper plugins compatible

```env
TYPE=PAPER
VERSION=LATEST  # or specific version like 1.20.4
```

### SPIGOT
- **Best for:** Classic plugin servers
- **Features:** Original plugin-based server, wide plugin compatibility
- **Memory:** 3GB minimum recommended
- **Plugins:** Spigot plugins

```env
TYPE=SPIGOT
VERSION=1.19.4
```

### FORGE
- **Best for:** Heavy modpacks, mod-focused servers
- **Features:** Extensive mod support, large modpacks
- **Memory:** 8GB+ recommended (modpack dependent)
- **Mods:** Forge mods only

```env
TYPE=FORGE
VERSION=1.20.1
MEMORY=8G
```

### FABRIC
- **Best for:** Lightweight mod servers, performance mods
- **Features:** Lightweight mod loader, faster than Forge
- **Memory:** 4-6GB recommended
- **Mods:** Fabric mods only (Sodium, Lithium, etc.)

```env
TYPE=FABRIC
VERSION=1.20.1
```

### VANILLA
- **Best for:** Pure Minecraft experience, testing
- **Features:** Official Minecraft server, no modifications
- **Memory:** 2GB minimum
- **Plugins/Mods:** None

```env
TYPE=VANILLA
VERSION=LATEST
```

### PURPUR
- **Best for:** High-performance servers with extra features
- **Features:** Paper fork with additional optimizations
- **Memory:** 4GB recommended
- **Plugins:** Paper plugins compatible

```env
TYPE=PURPUR
VERSION=LATEST
```

### FOLIA
- **Best for:** Massive servers, multi-threading
- **Features:** Experimental multi-threaded Paper fork
- **Memory:** 8GB+ recommended
- **Plugins:** Limited Folia-compatible plugins only

```env
TYPE=FOLIA
VERSION=LATEST
```

---

## 🔢 Version Formats

### Latest Release
```env
VERSION=LATEST
```
Always uses the newest stable release.

### Specific Version
```env
VERSION=1.20.4
VERSION=1.19.4
VERSION=1.18.2
VERSION=1.12.2
```

### Snapshot (Development)
```env
VERSION=SNAPSHOT
```
Latest development snapshot (may be unstable).

### Specific Snapshot
```env
VERSION=24w10a
```

---

## 🎮 Version Compatibility

### Modern Versions (1.18+)
- **1.20.x:** Latest features, best performance
  - Recommended: `1.20.4` (stable)
- **1.19.x:** Stable, widely supported
  - Recommended: `1.19.4`
- **1.18.x:** Long-term support
  - Recommended: `1.18.2`

### Legacy Versions
- **1.12.2:** Popular for modpacks (Feed The Beast, etc.)
- **1.16.5:** Good balance of mods and features
- **1.17.1:** Cave & Cliffs Part I

---

## 🚀 Quick Start Examples

### Latest Paper Server
```yaml
services:
  minecraft:
    build: .
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "LATEST"
      MEMORY: "4G"
    ports:
      - "25565:25565"
```

### Specific Version (1.19.4)
```yaml
services:
  minecraft:
    build: .
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "1.19.4"
      MEMORY: "4G"
    ports:
      - "25565:25565"
```

### Forge Modded Server
```yaml
services:
  minecraft:
    build: .
    environment:
      EULA: "TRUE"
      TYPE: "FORGE"
      VERSION: "1.20.1"
      MEMORY: "8G"
    ports:
      - "25565:25565"
```

---

## 🧪 Testing Different Versions

Use `docker-compose.versions.yml` to run multiple versions simultaneously:

```bash
# Start Paper 1.20.4
docker-compose -f docker-compose.versions.yml up paper-1-20-4 -d

# Start Forge 1.20.1
docker-compose -f docker-compose.versions.yml up forge-1-20-1 -d

# Start all versions
docker-compose -f docker-compose.versions.yml up -d
```

Each server runs on a different port:
- Latest Paper: `25565`
- Paper 1.20.4: `25566`
- Spigot 1.19.4: `25567`
- Fabric 1.20.1: `25568`
- Forge 1.20.1: `25569`
- Paper 1.18.2: `25570`
- Vanilla: `25571`
- Purpur: `25572`
- Snapshot: `25573`

---

## 📊 Performance Comparison

| Type | Performance | Plugin Support | Mod Support | Memory Usage |
|------|------------|----------------|-------------|--------------|
| **Paper** | ⭐⭐⭐⭐⭐ | ✅ Excellent | ❌ No | Medium |
| **Purpur** | ⭐⭐⭐⭐⭐ | ✅ Excellent | ❌ No | Medium |
| **Spigot** | ⭐⭐⭐⭐ | ✅ Good | ❌ No | Medium |
| **Fabric** | ⭐⭐⭐⭐ | ❌ No | ✅ Good | Low-Medium |
| **Forge** | ⭐⭐⭐ | ❌ No | ✅ Excellent | High |
| **Vanilla** | ⭐⭐⭐ | ❌ No | ❌ No | Low |
| **Folia** | ⭐⭐⭐⭐⭐ | ⚠️ Limited | ❌ No | High |

---

## 🔍 Finding Compatible Plugins/Mods

### Paper/Spigot Plugins
- **SpigotMC:** https://www.spigotmc.org/resources/
- **Hangar (Paper):** https://hangar.papermc.io/
- **Bukkit:** https://dev.bukkit.org/bukkit-plugins

### Forge Mods
- **CurseForge:** https://www.curseforge.com/minecraft/mc-mods
- **Modrinth:** https://modrinth.com/mods?g=categories:%27forge%27

### Fabric Mods
- **Modrinth:** https://modrinth.com/mods?g=categories:%27fabric%27
- **CurseForge:** Filter by Fabric

---

## ⚙️ Recommended Configurations

### Vanilla Survival (No Mods/Plugins)
```env
TYPE=PAPER
VERSION=LATEST
MEMORY=4G
DIFFICULTY=normal
PVP=true
```

### Creative Build Server
```env
TYPE=PAPER
VERSION=LATEST
MEMORY=2G
MODE=creative
DIFFICULTY=peaceful
PVP=false
```

### Modded Adventure (Forge)
```env
TYPE=FORGE
VERSION=1.20.1
MEMORY=10G
DIFFICULTY=hard
```

### Performance-Optimized (Fabric)
```env
TYPE=FABRIC
VERSION=1.20.1
MEMORY=6G
# Add performance mods: Sodium, Lithium, Starlight
MODRINTH_PROJECTS=sodium,lithium,starlight
```

---

## 🐛 Troubleshooting

### Server Won't Start
1. Check Minecraft version is valid
2. Ensure TYPE and VERSION are compatible
3. Verify EULA=TRUE
4. Check memory allocation is sufficient

### Version Download Fails
```bash
# Force redownload
docker-compose down
docker-compose up -d --force-recreate
```

Or use environment variable:
```env
FORCE_REDOWNLOAD=true
```

### Wrong Version Loaded
```bash
# Remove container and volume
docker-compose down -v
docker-compose up -d
```

---

## 📚 Additional Resources

- **itzg/minecraft-server Documentation:** https://docker-minecraft-server.readthedocs.io/
- **Minecraft Wiki:** https://minecraft.wiki/w/Java_Edition_version_history
- **Paper Documentation:** https://docs.papermc.io/
- **Fabric Wiki:** https://fabricmc.net/wiki/
- **Forge Documentation:** https://docs.minecraftforge.net/

---

**Last Updated:** 2025-10-24
**DockerCraft Version:** v0.4.0 (Sprint 3)

