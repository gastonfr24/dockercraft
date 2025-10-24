# Multi-Server Networking Guide - DockerCraft

Guide for setting up multi-server networks with BungeeCord/Velocity proxy.

---

## 🌐 Network Architecture

```
                    ┌─────────────────┐
                    │   Players       │
                    │  connect here   │
                    │   :25565        │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │  Velocity Proxy │
                    │   (Lobby/Hub)   │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
   ┌────▼─────┐       ┌─────▼────┐       ┌──────▼────┐
   │ Survival │       │ Creative │       │ Minigames │
   │  Server  │       │  Server  │       │  Server   │
   └──────────┘       └──────────┘       └───────────┘
```

---

## 🚀 Quick Start

### Start Multi-Server Setup

```bash
# Start all servers with proxy
docker-compose -f docker-compose.proxy.yml up -d

# Check all services running
docker-compose -f docker-compose.proxy.yml ps
```

### Connect

1. Connect to: `localhost:25565`
2. You'll spawn in the Hub server
3. Use `/server survival` to switch servers

---

## 🔧 Proxy Types

### Velocity (Recommended)
- **Modern:** Latest proxy software
- **Performance:** Better than BungeeCord
- **Security:** Modern forwarding mode
- **Version:** 1.7.2 - Latest

```yaml
proxy:
  environment:
    TYPE: "VELOCITY"
    VELOCITY_SECRET: "your-secret-key"
```

### BungeeCord (Legacy)
- **Compatible:** Wide plugin support
- **Stable:** Battle-tested
- **Version:** 1.8 - Latest

```yaml
proxy:
  environment:
    TYPE: "BUNGEECORD"
```

---

## ⚙️ Backend Server Configuration

### Required Settings

All backend servers MUST have:

```env
# Proxy mode (VELOCITY or BUNGEECORD)
PROXY_MODE=VELOCITY

# Secret key (must match proxy)
VELOCITY_SECRET=your-secret-key

# Disable online mode (proxy handles authentication)
ONLINE_MODE=FALSE
```

### Velocity Configuration

```yaml
services:
  backend-server:
    environment:
      PROXY_MODE: "VELOCITY"
      VELOCITY_SECRET: "your-secret-key"
      ONLINE_MODE: "FALSE"
```

### BungeeCord Configuration

```yaml
services:
  backend-server:
    environment:
      PROXY_MODE: "BUNGEECORD"
      ONLINE_MODE: "FALSE"
```

---

## 🏗️ Network Configuration

### Docker Network

All servers must be on the same Docker network:

```yaml
networks:
  minecraft-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
```

### Server-to-Server Communication

Servers communicate using container names:

```
proxy → hub (mc-hub:25565)
proxy → survival (mc-survival:25565)
proxy → creative (mc-creative:25565)
```

---

## 🎮 Server Switching

### In-Game Commands

```
/server hub        - Go to hub
/server survival   - Go to survival
/server creative   - Go to creative
/server minigames  - Go to minigames
```

### Velocity Configuration

Proxy automatically registers servers on network.

To manually configure, edit `velocity.toml`:

```toml
[servers]
hub = "mc-hub:25565"
survival = "mc-survival:25565"
creative = "mc-creative:25565"
minigames = "mc-minigames:25565"

try = [
    "hub"
]
```

---

## 🔒 Security

### Forwarding Modes

**Velocity Modern (Recommended):**
```yaml
proxy:
  environment:
    PLAYER_INFO_FORWARDING_MODE: "modern"

backend:
  environment:
    PROXY_MODE: "VELOCITY"
    VELOCITY_SECRET: "CHANGE_THIS_SECRET_KEY"
```

**BungeeCord:**
```yaml
proxy:
  environment:
    TYPE: "BUNGEECORD"

backend:
  environment:
    PROXY_MODE: "BUNGEECORD"
    ONLINE_MODE: "FALSE"
```

### Secret Key

**⚠️ IMPORTANT:** Change the secret key in production!

```env
VELOCITY_SECRET=your-super-secret-key-here-change-me
```

Generate a secure key:
```bash
openssl rand -base64 32
```

---

## 📊 Resource Allocation

### Proxy Server
- **Memory:** 512MB - 1GB
- **CPU:** 0.5 - 1 core
- **Purpose:** Routing only

### Hub/Lobby Server
- **Memory:** 2-3GB
- **CPU:** 1 core
- **Purpose:** Player spawn, lightweight

### Game Servers
- **Memory:** 4-8GB each
- **CPU:** 2-3 cores each
- **Purpose:** Main gameplay

### Example Resource Configuration

```yaml
proxy:
  deploy:
    resources:
      limits:
        memory: 1G
        cpus: '1'

hub:
  deploy:
    resources:
      limits:
        memory: 3G
        cpus: '1'

survival:
  deploy:
    resources:
      limits:
        memory: 6G
        cpus: '2'
```

---

## 🔍 Troubleshooting

### Can't Connect to Proxy

**Symptom:** Connection refused

**Solutions:**
1. Check proxy is running:
```bash
docker ps | grep mc-proxy
```

2. Check proxy logs:
```bash
docker logs mc-proxy
```

3. Verify port mapping:
```bash
docker port mc-proxy
```

### Backend Server Not Showing

**Symptom:** `/server survival` says "Server not found"

**Solutions:**
1. Check backend is running:
```bash
docker ps | grep mc-survival
```

2. Verify network connectivity:
```bash
docker exec mc-proxy ping mc-survival
```

3. Check PROXY_MODE is set:
```bash
docker exec mc-survival env | grep PROXY
```

### Players Can't See Each Other

**Symptom:** Players on different servers can't see cross-server

**Solution:** This is expected. Proxy doesn't sync player visibility across servers.

For cross-server chat/visibility, install plugins:
- **Velocity:** LuckPerms, TAB
- **BungeeCord:** BungeeChat, BungeeTabListPlus

### Authentication Errors

**Symptom:** "If you wish to use IP forwarding, please enable it in your BungeeCord config as well!"

**Solutions:**
1. Verify PROXY_MODE is set on backend:
```env
PROXY_MODE=VELOCITY  # or BUNGEECORD
```

2. Check secret matches:
```bash
# Proxy
VELOCITY_SECRET=your-secret

# Backend
VELOCITY_SECRET=your-secret  # Must match!
```

3. Verify ONLINE_MODE=FALSE on backends:
```env
ONLINE_MODE=FALSE
```

---

## 🚀 Scaling Up

### Add More Servers

1. **Copy server definition:**
```yaml
new-server:
  build: .
  container_name: mc-new-server
  environment:
    EULA: "TRUE"
    TYPE: "PAPER"
    PROXY_MODE: "VELOCITY"
    VELOCITY_SECRET: "your-secret"
    ONLINE_MODE: "FALSE"
  networks:
    - minecraft-network
```

2. **Start server:**
```bash
docker-compose -f docker-compose.proxy.yml up -d new-server
```

3. **Connect:**
```
/server new-server
```

---

## 🔌 API Integration

### For External APIs

When building an API to manage servers:

1. **Create servers on minecraft-network:**
```python
import docker

client = docker.from_env()
container = client.containers.run(
    image="dockercraft:latest",
    name="mc-server-dynamic-1",
    environment={
        "EULA": "TRUE",
        "PROXY_MODE": "VELOCITY",
        "VELOCITY_SECRET": "your-secret",
        "ONLINE_MODE": "FALSE"
    },
    network="minecraft-network",
    detach=True
)
```

2. **Register with proxy:**
Velocity auto-discovers servers on the network.

For manual registration, update `velocity.toml` via volume mount.

---

## 📚 Plugin Recommendations

### Velocity Plugins

- **LuckPerms:** Cross-server permissions
- **TAB:** Custom tab list
- **Maintenance:** Maintenance mode
- **SignedVelocity:** Signed messages

### Backend Plugins

- **Multiverse-Core:** Multiple worlds
- **WorldGuard:** Region protection
- **Essentials:** Basic commands
- **Vault:** Economy API

---

## 🎯 Production Checklist

Before going live:

- [ ] Change VELOCITY_SECRET from default
- [ ] Set ONLINE_MODE=FALSE on all backends
- [ ] Verify PROXY_MODE matches proxy type
- [ ] Test server switching works
- [ ] Configure resource limits
- [ ] Set up backups for each server
- [ ] Install essential plugins
- [ ] Test authentication
- [ ] Configure firewall (only proxy port public)

---

## 📖 Additional Resources

- **Velocity Docs:** https://docs.papermc.io/velocity
- **BungeeCord Wiki:** https://www.spigotmc.org/wiki/bungeecord/
- **itzg Proxy Docs:** https://docker-minecraft-server.readthedocs.io/en/latest/types-and-platforms/bungeecord/

---

**Last Updated:** 2025-10-24
**DockerCraft Version:** v0.4.0 (Sprint 3)

