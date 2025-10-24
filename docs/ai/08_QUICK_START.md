# ⚡ Quick Start Guide - DockerCraft

> **Última actualización:** 2025-10-24  
> **Versión:** v0.1.0-alpha

Guía rápida para empezar a usar este proyecto.

---

## 🎯 ¿Qué es Este Proyecto?

Este es un **template de servidor Minecraft en Docker** optimizado y altamente configurable. NO incluye API ni gestión - solo el servidor base que puede ser instanciado múltiples veces.

---

## ⚡ Inicio Rápido (5 minutos)

### **Prerequisitos**

```bash
# Verificar que tienes Docker instalado
docker --version
# Docker version 20.10+ requerido

# Verificar Docker Compose
docker-compose --version
# Docker Compose version 2.0+ requerido
```

### **Levantar Servidor de Prueba**

```bash
# 1. Clonar (o copiar archivos)
cd dockercraft

# 2. Copiar variables de entorno
cp .env.example .env

# 3. Levantar servidor
docker-compose up -d

# 4. Ver logs
docker-compose logs -f

# 5. Esperar mensaje "Done! For help, type "help""
# Servidor listo cuando veas: "[Server thread/INFO]: Done"

# 6. Conectar desde Minecraft
# Server Address: localhost:25565
```

### **Detener Servidor**

```bash
# Detener (datos persisten)
docker-compose down

# Detener Y eliminar datos (CUIDADO)
docker-compose down -v
```

---

## 🔧 Configuración Básica

### **Variables de Entorno Principales**

Editar `.env`:

```bash
# Versión de Minecraft
VERSION=1.21.1

# Tipo de servidor
TYPE=PAPER          # PAPER, SPIGOT, VANILLA, FORGE, FABRIC

# Memoria RAM
MEMORY=4G           # 2G, 4G, 8G, etc.

# Jugadores máximos
MAX_PLAYERS=20

# Dificultad
DIFFICULTY=normal   # peaceful, easy, normal, hard

# Modo de juego por defecto
GAMEMODE=survival   # survival, creative, adventure, spectator

# PVP habilitado
PVP=true

# Distancia de visión (chunks)
VIEW_DISTANCE=10

# MOTD (mensaje del servidor)
MOTD=Mi Servidor de Minecraft
```

### **Ejemplo: Servidor Creativo con 10 jugadores**

```bash
# .env
VERSION=1.21.1
TYPE=PAPER
MEMORY=2G
MAX_PLAYERS=10
DIFFICULTY=peaceful
GAMEMODE=creative
PVP=false
VIEW_DISTANCE=8
MOTD=Servidor Creativo
```

---

## 🚀 Uso Avanzado

### **Múltiples Servidores Simultáneos**

Usar `docker-compose.multi.yml`:

```bash
# Levantar 3 servidores
docker-compose -f docker-compose.multi.yml up -d

# Servidor 1: localhost:25565 (Survival)
# Servidor 2: localhost:25566 (Creative)
# Servidor 3: localhost:25567 (Hardcore)

# Ver logs de servidor específico
docker-compose -f docker-compose.multi.yml logs -f mc-server-1

# Detener todos
docker-compose -f docker-compose.multi.yml down
```

### **Crear Servidor desde Docker CLI**

```bash
# Build imagen
docker build -t dockercraft-mc:latest .

# Crear volumen
docker volume create my-mc-data

# Run servidor
docker run -d \
  --name my-mc-server \
  -p 25565:25565 \
  -e VERSION=1.21.1 \
  -e TYPE=PAPER \
  -e MEMORY=4G \
  -e MAX_PLAYERS=20 \
  -e EULA=TRUE \
  -v my-mc-data:/data \
  dockercraft-mc:latest

# Ver logs
docker logs -f my-mc-server

# Detener
docker stop my-mc-server

# Eliminar
docker rm my-mc-server
```

---

## 🛠️ Comandos Útiles

### **Gestión del Servidor**

```bash
# Ver estado
docker ps

# Ver logs en tiempo real
docker logs -f mc-server-1

# Ver últimas 50 líneas
docker logs --tail 50 mc-server-1

# Ejecutar comando en el servidor
docker exec mc-server-1 rcon-cli say "Hola a todos!"

# Ver jugadores online
docker exec mc-server-1 rcon-cli list

# Detener servidor gracefully
docker exec mc-server-1 rcon-cli stop

# Acceder a shell del contenedor
docker exec -it mc-server-1 bash

# Ver archivos del servidor
docker exec mc-server-1 ls -la /data
```

### **Monitoreo**

```bash
# Stats en tiempo real
docker stats mc-server-1

# Verificar health
docker inspect --format='{{.State.Health.Status}}' mc-server-1

# Ver TPS (debe ser ~20)
docker exec mc-server-1 rcon-cli tps
```

### **Backup Manual**

```bash
# Backup de volumen
docker run --rm \
  -v mc-data:/data \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/backup-$(date +%Y%m%d-%H%M%S).tar.gz /data

# Restaurar backup
docker run --rm \
  -v mc-data:/data \
  -v $(pwd)/backups:/backup \
  alpine sh -c "cd /data && tar xzf /backup/backup-20251024-100000.tar.gz --strip 1"
```

---

## 📊 Variables de Entorno Completas

### **Core Settings**

| Variable | Default | Descripción |
|----------|---------|-------------|
| `EULA` | - | **Requerido** - Debe ser `TRUE` |
| `VERSION` | `LATEST` | Versión de Minecraft (1.21.1, 1.20.4, etc.) |
| `TYPE` | `VANILLA` | PAPER, SPIGOT, VANILLA, FORGE, FABRIC |
| `MEMORY` | `1G` | RAM asignada (2G, 4G, 8G, 16G) |

### **Server Properties**

| Variable | Default | Descripción |
|----------|---------|-------------|
| `MAX_PLAYERS` | `20` | Jugadores máximos |
| `DIFFICULTY` | `easy` | peaceful, easy, normal, hard |
| `GAMEMODE` | `survival` | survival, creative, adventure, spectator |
| `PVP` | `true` | PVP habilitado |
| `VIEW_DISTANCE` | `10` | Distancia de visión en chunks |
| `SIMULATION_DISTANCE` | `10` | Distancia de simulación |
| `MOTD` | `A Minecraft Server` | Mensaje del servidor |
| `LEVEL_NAME` | `world` | Nombre del mundo |
| `LEVEL_SEED` | - | Seed del mundo |
| `LEVEL_TYPE` | `minecraft\:normal` | Tipo de mundo |
| `SPAWN_PROTECTION` | `16` | Radio de spawn protection |

### **Optimizaciones**

| Variable | Default | Descripción |
|----------|---------|-------------|
| `ENABLE_AUTOPAUSE` | `false` | Auto-pausar sin jugadores |
| `AUTOPAUSE_TIMEOUT_EST` | `3600` | Segundos para entrar en pause |
| `AUTOPAUSE_TIMEOUT_KN` | `120` | Segundos después de confirmar |
| `MAX_TICK_TIME` | `60000` | Watchdog timeout |

### **Networking**

| Variable | Default | Descripción |
|----------|---------|-------------|
| `SERVER_PORT` | `25565` | Puerto interno (no cambiar) |
| `ONLINE_MODE` | `true` | Validar cuentas Mojang |
| `ENABLE_RCON` | `true` | Habilitar RCON |
| `RCON_PASSWORD` | (generado) | Password RCON |
| `RCON_PORT` | `25575` | Puerto RCON |

### **Plugins/Mods**

| Variable | Ejemplo | Descripción |
|----------|---------|-------------|
| `PLUGINS` | - | URLs de plugins separados por coma |
| `MODS` | - | URLs de mods separados por coma |
| `SPIGET_RESOURCES` | - | IDs de Spigot resources |

---

## 🎮 Casos de Uso Comunes

### **1. Servidor Vanilla Básico**

```yaml
# docker-compose.yml
services:
  minecraft:
    image: dockercraft-mc:latest
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      VERSION: "1.21.1"
      TYPE: "VANILLA"
      MEMORY: "4G"
    volumes:
      - mc-data:/data
```

### **2. Servidor Paper con Plugins**

```yaml
services:
  minecraft:
    image: dockercraft-mc:latest
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      VERSION: "1.21.1"
      TYPE: "PAPER"
      MEMORY: "6G"
      MAX_PLAYERS: "50"
      SPIGET_RESOURCES: "28140,6245"  # Essentials, WorldEdit
    volumes:
      - mc-data:/data
```

### **3. Servidor Creativo para Building**

```yaml
services:
  minecraft:
    image: dockercraft-mc:latest
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      VERSION: "1.21.1"
      TYPE: "PAPER"
      MEMORY: "4G"
      MAX_PLAYERS: "20"
      GAMEMODE: "creative"
      DIFFICULTY: "peaceful"
      PVP: "false"
      VIEW_DISTANCE: "16"
      MOTD: "Servidor de Construcción"
    volumes:
      - mc-creative-data:/data
```

### **4. Servidor con Auto-Pause (ahorro de recursos)**

```yaml
services:
  minecraft:
    image: dockercraft-mc:latest
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      MEMORY: "4G"
      ENABLE_AUTOPAUSE: "TRUE"
      AUTOPAUSE_TIMEOUT_EST: "300"    # 5 minutos
      AUTOPAUSE_TIMEOUT_KN: "120"     # 2 minutos
    volumes:
      - mc-data:/data
```

---

## 🐛 Troubleshooting Rápido

### **Servidor no inicia**

```bash
# Ver logs
docker logs mc-server-1

# Error común: EULA not accepted
# Solución: Agregar EULA=TRUE en environment
```

### **No puedo conectarme**

```bash
# Verificar que está corriendo
docker ps

# Verificar puerto
docker port mc-server-1

# Verificar firewall (Linux)
sudo ufw allow 25565/tcp
```

### **Servidor muy lento**

```bash
# Verificar RAM
docker stats mc-server-1

# Solución: Aumentar MEMORY en .env
MEMORY=8G  # De 4G a 8G
```

### **Datos desaparecen al reiniciar**

```bash
# Verificar volumen
docker volume ls

# Usar named volume, NO anónimo
volumes:
  - mc-data:/data  # ✅ Correcto
  
# NO usar:
volumes:
  - /data  # ❌ Volumen anónimo
```

---

## 📚 Recursos Adicionales

- **Documentación completa:** Ver archivos en `docs/ai/`
- **Variables completas:** `.env.example`
- **Imagen base:** [itzg/minecraft-server](https://github.com/itzg/docker-minecraft-server)
- **Paper MC:** [papermc.io](https://papermc.io/)

---

## 🤝 Integración con API

Si estás desarrollando una API que usa este template:

```javascript
// Ejemplo de creación
const container = await docker.createContainer({
  Image: 'dockercraft-mc:latest',
  name: `mc-server-${serverId}`,
  Env: [
    'EULA=TRUE',
    `VERSION=${config.version}`,
    `TYPE=${config.type}`,
    `MEMORY=${config.memory}`,
    `MAX_PLAYERS=${config.maxPlayers}`,
    // ... más variables
  ],
  HostConfig: {
    PortBindings: {
      '25565/tcp': [{ HostPort: assignedPort }]
    },
    Binds: [`mc-server-${serverId}-data:/data`]
  }
});

await container.start();
```

---

## ✅ Checklist de Primera Vez

- [ ] Docker y Docker Compose instalados
- [ ] Clonar/copiar archivos del proyecto
- [ ] Copiar `.env.example` a `.env`
- [ ] Ajustar variables en `.env` (al menos `EULA=TRUE`)
- [ ] Ejecutar `docker-compose up -d`
- [ ] Esperar ~2 minutos para que inicie
- [ ] Conectarse desde cliente Minecraft a `localhost:25565`
- [ ] ¡Disfrutar! 🎮

---

**¿Problemas?** Consultar `07_WORKFLOWS.md` para troubleshooting detallado.

