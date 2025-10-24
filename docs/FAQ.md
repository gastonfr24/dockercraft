# Frequently Asked Questions (FAQ) - DockerCraft

Common questions and answers about DockerCraft.

---

## 📦 General Questions

### What is DockerCraft?

Docker

Craft is a **Docker template** for running Minecraft servers. It provides:
- Pre-configured Docker images
- Multiple server type support (Paper, Forge, Fabric, etc.)
- Easy configuration via environment variables
- Production-ready setup

**Note:** This is ONLY the Docker template. API management is a separate project.

### What versions of Minecraft are supported?

All Java Edition versions:
- Latest release
- Specific versions (1.20.4, 1.19.4, 1.18.2, etc.)
- Snapshots
- Legacy versions (1.12.2, 1.16.5)

### What server types are supported?

- **Paper** (recommended) - High performance
- **Spigot** - Plugin support
- **Forge** - Heavy mods
- **Fabric** - Lightweight mods
- **Vanilla** - Official server
- **Purpur** - Enhanced Paper
- **Folia** - Multi-threaded (experimental)

---

## 🚀 Getting Started

### How do I start a server?

```bash
# 1. Clone repository
git clone https://github.com/gastonfr24/dockercraft.git
cd dockercraft

# 2. Copy env example (if exists)
cp .env.example .env

# 3. Edit .env
# Set EULA=TRUE and configure as needed

# 4. Start server
docker-compose up -d
```

### Do I need to accept the Minecraft EULA?

**Yes.** Set `EULA=TRUE` in your environment variables.

By doing so, you agree to Minecraft's EULA:
https://www.minecraft.net/en-us/eula

### How long does it take to start?

- **Vanilla/Paper:** 1-2 minutes
- **Modded (light):** 3-5 minutes
- **Modded (heavy):** 5-15 minutes

First start takes longer due to initial setup.

---

## ⚙️ Configuration

### How do I change the Minecraft version?

```env
VERSION=1.20.4    # Specific version
VERSION=LATEST    # Latest release
VERSION=SNAPSHOT  # Latest snapshot
```

### How do I add plugins?

```env
# Option 1: Spiget IDs
SPIGET_RESOURCES=9089,28140,8631

# Option 2: Direct URLs
PLUGINS=https://example.com/plugin.jar
```

### How do I install a modpack?

```env
# CurseForge
CURSEFORGE_FILES=https://www.curseforge.com/minecraft/modpacks/all-the-mods-9

# FTB
FTB_MODPACK_ID=ftbpresentsintegrationstoneblockedition

# Direct URL
GENERIC_PACK=https://example.com/modpack.zip
```

### How much RAM should I allocate?

| Server Type | Recommended RAM |
|-------------|----------------|
| Vanilla/Paper | 4GB |
| Light Mods | 4-6GB |
| Medium Mods | 6-8GB |
| Heavy Mods | 8-12GB |
| Extreme Mods | 12-16GB+ |

```env
MEMORY=4G    # For vanilla
MEMORY=10G   # For heavy modpacks
```

---

## 🔧 Management

### How do I stop the server?

```bash
# Graceful stop
docker-compose down

# Force stop
docker-compose kill
```

### How do I restart the server?

```bash
docker-compose restart
```

### How do I view logs?

```bash
# Real-time logs
docker logs -f mc-server-1

# Last 100 lines
docker logs mc-server-1 --tail 100
```

### How do I execute commands?

```bash
# Via RCON
docker exec mc-server-1 rcon-cli list
docker exec mc-server-1 rcon-cli give @a diamond 64

# Attach to console (not recommended)
docker attach mc-server-1
# Exit: Ctrl+P, Ctrl+Q (NOT Ctrl+C!)
```

### How do I backup my server?

```bash
# Manual backup
bash scripts/backup.sh mc-server-1 /backups

# Restore backup
bash scripts/restore.sh /backups/backup-file.tar.gz mc-server-1
```

---

## 🌐 Networking

### How do I connect to my server?

**Local:** `localhost:25565`

**Public:** 
1. Forward port 25565 in your router
2. Connect to your public IP

### Can I change the port?

```yaml
ports:
  - "25566:25565"  # External:Internal
```

Connect to `localhost:25566`

### How do I set up multiple servers?

See `docker-compose.multi.yml` or `docker-compose.proxy.yml`

```bash
docker-compose -f docker-compose.multi.yml up -d
```

---

## 💾 Data & Storage

### Where is my world data stored?

Docker volume: `mc-server-1-data`

```bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect mc-server-1-data
```

### How do I access world files?

```bash
# Copy from container
docker cp mc-server-1:/data/world ./world-backup

# Copy to container
docker cp ./world-backup mc-server-1:/data/world
```

### Will I lose data if I restart?

**No.** Data is persistent in Docker volumes.

Only deleted if you use:
```bash
docker-compose down -v  # -v deletes volumes!
```

---

## 🐛 Troubleshooting

### Server won't start

**Check logs:**
```bash
docker logs mc-server-1 --tail 50
```

**Common issues:**
- `EULA=FALSE` - Set to TRUE
- Out of memory - Increase MEMORY
- Wrong version - Check VERSION setting

### "Can't keep up! Did the system time change?"

Server is overloaded.

**Solutions:**
- Reduce VIEW_DISTANCE
- Reduce SIMULATION_DISTANCE
- Increase MEMORY
- Use USE_AIKAR_FLAGS=true

### Players can't connect

**Check:**
1. Server is running: `docker ps`
2. Port is correct: 25565
3. Firewall allows connections
4. ONLINE_MODE matches (true for public, false for proxy)

### Modpack won't download

**Solutions:**
- Check internet connection
- Verify modpack URL is correct
- Try FORCE_REDOWNLOAD=true
- Check Docker has enough disk space

---

## 🔒 Security

### Is my server secure?

**Out of box:** Basic security

**Recommendations:**
1. Change RCON_PASSWORD
2. Use whitelist for private servers
3. Keep server updated
4. Use firewall rules
5. Don't expose RCON port publicly

### Should I use whitelist?

**Yes, if:**
- Private server for friends
- You want to control who joins

**No, if:**
- Public server open to all

```env
ENABLE_WHITELIST=TRUE
WHITELIST=player1,player2,player3
```

---

## ⚡ Performance

### How do I optimize performance?

```env
# Enable Aikar flags
USE_AIKAR_FLAGS=true

# Reduce view distance
VIEW_DISTANCE=8
SIMULATION_DISTANCE=6

# Allocate more memory
MEMORY=6G
```

### What are Aikar flags?

Optimized JVM flags for Minecraft servers.

Automatically enabled with:
```env
USE_AIKAR_FLAGS=true
```

### How many players can my server handle?

Depends on resources:
- **2GB RAM:** 5-10 players
- **4GB RAM:** 10-20 players
- **8GB RAM:** 20-50 players
- **16GB RAM:** 50-100+ players

Also depends on:
- View distance
- Plugins/mods
- World complexity

---

## 🔄 Updates

### How do I update Minecraft version?

```env
# Change version
VERSION=1.20.5

# Restart server
docker-compose down
docker-compose up -d
```

**⚠️ Warning:** Backup first! Version changes can break worlds.

### How do I update plugins?

```bash
# Re-download plugins
docker-compose down
docker-compose up -d --force-recreate
```

Or manually replace in `/data/plugins/`

---

## 💻 System Requirements

### What are the minimum requirements?

- **CPU:** 2 cores
- **RAM:** 4GB (host machine)
- **Storage:** 10GB free
- **OS:** Linux, Windows, macOS with Docker

### What are recommended requirements?

- **CPU:** 4+ cores
- **RAM:** 8GB+ (host machine)
- **Storage:** 50GB+ SSD
- **Network:** 100Mbps+ upload

---

## 🆘 Getting Help

### Where can I get help?

1. **Check documentation:**
   - README.md
   - docs/TROUBLESHOOTING.md
   - docs/EXAMPLES.md

2. **Create an issue:**
   https://github.com/gastonfr24/dockercraft/issues

3. **Check logs:**
   ```bash
   docker logs mc-server-1 --tail 200
   ```

### How do I report a bug?

1. Go to: https://github.com/gastonfr24/dockercraft/issues/new
2. Choose "Bug Report" template
3. Fill in all sections
4. Include logs and configuration

---

## 📚 Additional Resources

- **Minecraft Wiki:** https://minecraft.wiki/
- **Paper Docs:** https://docs.papermc.io/
- **Docker Docs:** https://docs.docker.com/
- **itzg/minecraft-server:** https://github.com/itzg/docker-minecraft-server

---

**Last Updated:** 2025-10-24
**DockerCraft Version:** v0.4.0 (Sprint 3)

