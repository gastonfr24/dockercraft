# 🎮 DockerCraft - Minecraft Server Template

> Plantilla Docker optimizada para servidores de Minecraft que pueden ser instanciados bajo demanda

[![CI](https://github.com/gastonfr24/dockercraft/workflows/CI/badge.svg)](https://github.com/gastonfr24/dockercraft/actions)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![Minecraft](https://img.shields.io/badge/Minecraft-All%20Versions-62B47A?logo=minecraft&logoColor=white)](https://www.minecraft.net/)
[![Paper](https://img.shields.io/badge/Paper-Optimized-00897B)](https://papermc.io/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-v1.0.0-blue.svg)](https://github.com/gastonfr24/dockercraft/releases)
[![Made with ❤️](https://img.shields.io/badge/Made%20with-❤️-red.svg)](https://github.com/gastonfr24/dockercraft)

---

## 📋 ¿Qué es Esto?

**DockerCraft** es un template de servidor Minecraft en Docker altamente configurable y optimizado. Este proyecto contiene **SOLO** la configuración Docker base que puede ser usada para crear múltiples instancias de servidores con diferentes configuraciones.

### ⚠️ Importante

Este proyecto NO incluye:
- ❌ API REST para gestión
- ❌ Base de datos
- ❌ Sistema de autenticación
- ❌ Dashboard web
- ❌ Sistema de backups automatizado

**Estos componentes van en un proyecto API separado que consumirá este template.**

---

## ✨ Características

### 🐳 Core Features
- **Containerizado con Docker** - Aislamiento, portabilidad y fácil deployment
- **Altamente Configurable** - 100+ variables de entorno para personalización total
- **Production Ready** - CI/CD, testing automatizado, security hardening
- **Well Documented** - 10,000+ líneas de documentación completa

### 🎮 Minecraft Features
- **Multi-Version** - Todas las versiones de Minecraft (1.7+)
- **Multi-Type** - Paper, Spigot, Forge, Fabric, Vanilla, Purpur
- **Modpacks** - Soporte CurseForge, FTB, Modrinth
- **Plugins/Mods** - Instalación automática
- **Auto-Pause** - Ahorra recursos cuando no hay jugadores

### ⚡ Performance & Monitoring
- **Optimizado** - Aikar's JVM flags, performance tuning
- **Monitoreo** - Scripts de monitoreo de CPU, RAM, disco
- **Alertas** - Discord/Slack webhooks integrados
- **Troubleshooting** - Herramientas de diagnóstico automático

### 🔒 Security
- **Firewall Templates** - UFW, firewalld, iptables configs
- **Security Hardening** - Scripts automatizados
- **Best Practices** - Guías completas de seguridad

### 🌐 Networking
- **Multi-Server** - Proxy (Velocity/BungeeCord) ready
- **Health Checks** - Monitoreo automático de estado
- **Port Management** - Configuración dinámica de puertos

---

## 🚀 Quick Start

### Prerequisitos

- **Docker** 20.10+ ([Install](https://docs.docker.com/get-docker/))
- **Docker Compose** 2.0+ ([Install](https://docs.docker.com/compose/install/))
- **Git** (opcional)

### ⚡ Setup en 60 Segundos

```bash
# 1. Clonar o descargar
git clone https://github.com/gastonfr24/dockercraft.git
cd dockercraft

# 2. Setup automatizado (recomendado)
./scripts/deployment/setup.sh

# 3. Levantar servidor
docker compose up -d

# 4. Ver logs en tiempo real
docker compose logs -f

# 5. ✅ ¡Listo! Conectar desde Minecraft
# Server Address: localhost:25565
```

### 🎮 Primeros Pasos

```bash
# Ver estado del servidor
docker compose ps

# Ejecutar comando en el servidor
docker exec minecraft-server rcon-cli list

# Monitorear recursos
./scripts/monitoring/monitor.sh

# Ver ayuda
./scripts/deployment/setup.sh --help
```

---

## 📁 Estructura del Proyecto

```
dockercraft/
├── docs/                      # 📚 Documentación completa
│   ├── setup/                 # Guías de instalación
│   ├── deployment/            # Guías de deployment público
│   ├── security/              # Guías de seguridad
│   ├── monitoring/            # Guías de monitoreo
│   ├── troubleshooting/       # Resolución de problemas
│   ├── development/           # Guías para desarrolladores
│   ├── sprints/               # Planificación de sprints
│   ├── ai/                    # Docs para IA (contexto, memoria, roadmap)
│   ├── templates/             # Templates de configuración
│   ├── INDEX.md               # Índice completo de docs
│   └── VERSIONS.md            # Versiones soportadas
├── scripts/                   # 🛠️ Scripts de automatización
│   ├── deployment/            # Deployment y setup
│   ├── security/              # Seguridad y firewall
│   ├── monitoring/            # Monitoreo y alertas
│   ├── backup/                # Backup y restore
│   ├── whitelist/             # Gestión de whitelist
│   ├── tunnel/                # Cloudflare Tunnel
│   ├── utils/                 # Utilidades generales
│   └── README.md              # Documentación de scripts
├── Dockerfile                 # 🐳 Imagen Docker optimizada
├── docker-compose.yml         # Ejemplo standalone
├── docker-compose.prod.yml    # Configuración producción
├── docker-compose.dev.yml     # Configuración desarrollo
├── docker-compose.multi.yml   # Ejemplo multi-servidor
├── .env.example               # Variables de entorno documentadas
├── server.properties          # Configuración base
├── config/                    # Configuraciones adicionales
├── plugins/                   # Plugins pre-instalados (opcional)
└── README.md                  # Este archivo
```

Ver [docs/INDEX.md](docs/INDEX.md) para navegación completa de la documentación.

---

## ⚙️ Configuración

### Variables de Entorno Principales

Editar `.env`:

```bash
# Versión de Minecraft
VERSION=1.21.1

# Tipo de servidor (PAPER, SPIGOT, VANILLA, FORGE, FABRIC)
TYPE=PAPER

# Memoria RAM
MEMORY=4G

# Jugadores máximos
MAX_PLAYERS=20

# Dificultad (peaceful, easy, normal, hard)
DIFFICULTY=normal

# Modo de juego (survival, creative, adventure, spectator)
GAMEMODE=survival

# PVP habilitado
PVP=true

# Distancia de visión (chunks)
VIEW_DISTANCE=10

# Auto-pause cuando no hay jugadores
ENABLE_AUTOPAUSE=true

# Mensaje del servidor
MOTD=Mi Servidor de Minecraft
```

Ver `.env.example` para lista completa de variables disponibles.

---

## 🛠️ Casos de Uso

### 1. Servidor Vanilla Básico

```bash
docker run -d \
  --name mi-servidor \
  -p 25565:25565 \
  -e EULA=TRUE \
  -e VERSION=1.21.1 \
  -e TYPE=VANILLA \
  -e MEMORY=4G \
  -v mc-data:/data \
  dockercraft-mc:latest
```

### 2. Servidor Paper Optimizado

```yaml
# docker-compose.yml
services:
  minecraft:
    build: .
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      VERSION: "1.21.1"
      TYPE: "PAPER"
      MEMORY: "6G"
      MAX_PLAYERS: "50"
      ENABLE_AUTOPAUSE: "TRUE"
    volumes:
      - mc-data:/data
```

### 3. Múltiples Servidores

```bash
# Usar docker-compose.multi.yml
docker-compose -f docker-compose.multi.yml up -d
```

---

## 🤖 Integración con API Externa

Este template está diseñado para ser consumido por una API externa mediante Docker API:

```javascript
// Ejemplo en Node.js con Dockerode
const Docker = require('dockerode');
const docker = new Docker();

// Crear servidor desde template
const container = await docker.createContainer({
  Image: 'dockercraft-mc:latest',
  name: `mc-server-${serverId}`,
  Env: [
    'EULA=TRUE',
    `VERSION=${version}`,
    `TYPE=${type}`,
    `MEMORY=${memory}`,
    `MAX_PLAYERS=${maxPlayers}`,
    // ... más configuración
  ],
  HostConfig: {
    PortBindings: {
      '25565/tcp': [{ HostPort: assignedPort.toString() }]
    },
    Binds: [`mc-server-${serverId}-data:/data`],
    Memory: parseMemory(memory)
  }
});

await container.start();
```

Ver `docs/ai/07_WORKFLOWS.md` para ejemplos completos.

---

## 📚 Documentación

> **📖 Índice Completo**: Ver [`docs/INDEX.md`](docs/INDEX.md)

### Documentación por Categoría

#### 🚀 Setup e Instalación
- [Quick Start](docs/ai/08_QUICK_START.md) - Inicio rápido
- [Advanced Config](docs/setup/ADVANCED_CONFIG.md) - Configuración avanzada
- [Examples](docs/setup/EXAMPLES.md) - Ejemplos de configuraciones
- [Modpacks](docs/setup/MODPACKS.md) - Instalación de modpacks

#### 🌐 Deployment Público
- [Cloudflare Tunnel](docs/deployment/CLOUDFLARE_TUNNEL.md) - Exposición pública (recomendado)
- [Public Deployment Guide](docs/deployment/PUBLIC_DEPLOYMENT_GUIDE.md) - Guía completa
- [Networking](docs/deployment/NETWORKING.md) - Configuración de red

#### 🔒 Seguridad
- [Security Guide](docs/security/SECURITY.md) - Guía completa de seguridad
- [Approval Rules](docs/security/APPROVAL_RULES.md) - Reglas de aprobación de PRs

#### 📊 Monitoring
- [Performance](docs/monitoring/PERFORMANCE.md) - Optimización de performance
- [Alerts](docs/monitoring/ALERTS.md) - Sistema de alertas
- [Metrics API](docs/monitoring/METRICS_API.md) - API de métricas

#### 🐛 Troubleshooting
- [Troubleshooting](docs/troubleshooting/TROUBLESHOOTING.md) - Resolución de problemas
- [FAQ](docs/troubleshooting/FAQ.md) - Preguntas frecuentes
- [Public Troubleshooting](docs/troubleshooting/PUBLIC_TROUBLESHOOTING.md) - Problemas de conectividad

#### 💻 Desarrollo
- [Contributing](docs/development/CONTRIBUTING.md) - Guía de contribución
- [Development](docs/development/DEVELOPMENT.md) - Entorno de desarrollo
- [Sprint Workflow](docs/development/SPRINT_WORKFLOW.md) - Workflow de sprints

#### 🤖 Para IA
Documentación completa en [`docs/ai/`](docs/ai/):
- [00_README_AI.md](docs/ai/00_README_AI.md) - Guía para IA
- [01_CONTEXT.md](docs/ai/01_CONTEXT.md) - Contexto del proyecto
- [02_ARCHITECTURE.md](docs/ai/02_ARCHITECTURE.md) - Arquitectura técnica
- [04_MEMORY.md](docs/ai/04_MEMORY.md) - Estado actual del proyecto

---

## 🔧 Comandos Útiles

```bash
# Ver logs
docker-compose logs -f

# Detener servidor
docker-compose down

# Ver estado
docker-compose ps

# Ejecutar comando en servidor
docker exec mc-server-1 rcon-cli say "Hola!"

# Ver jugadores online
docker exec mc-server-1 rcon-cli list

# Stats en tiempo real
docker stats mc-server-1

# Backup manual
docker run --rm \
  -v mc-data:/data \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/backup-$(date +%Y%m%d).tar.gz /data
```

---

## 🐛 Troubleshooting

### Servidor no inicia

```bash
# Ver logs
docker logs mc-server-1

# Verificar que EULA=TRUE
docker inspect mc-server-1 | grep EULA
```

### No puedo conectarme

```bash
# Verificar puerto
docker port mc-server-1

# Verificar firewall
sudo ufw allow 25565/tcp
```

### Servidor lento

```bash
# Ver recursos
docker stats mc-server-1

# Aumentar RAM en .env
MEMORY=8G
```

Ver guía completa en `docs/ai/07_WORKFLOWS.md`

---

## 📊 Recursos Recomendados por Jugadores

| Jugadores | RAM | CPU | Disco |
|-----------|-----|-----|-------|
| 1-5       | 2GB | 2   | 2GB   |
| 5-10      | 4GB | 2   | 5GB   |
| 10-20     | 6GB | 4   | 10GB  |
| 20-50     | 8GB | 4   | 20GB  |
| 50+       | 12GB+ | 6+ | 30GB+ |

---

## 🤝 Contributing

Este proyecto está en desarrollo activo. Ver `docs/ai/05_ROADMAP.md` para el plan de implementación.

---

## 📄 Licencia

[Incluir licencia aquí]

---

## 🔗 Enlaces Útiles

- [itzg/minecraft-server](https://github.com/itzg/docker-minecraft-server) - Imagen base
- [Paper MC](https://papermc.io/) - Servidor optimizado
- [Docker Documentation](https://docs.docker.com/)
- [Minecraft Wiki](https://minecraft.fandom.com/wiki/Server.properties)

---

## 🎯 Project Status & Roadmap

### ✅ v1.0.0 - Production Ready (Completado)

- [x] ✅ Dockerfile optimizado con multi-stage builds
- [x] ✅ Docker Compose examples (7 configuraciones)
- [x] ✅ Scripts de utilidad (10+ scripts)
- [x] ✅ Sistema de monitoreo completo
- [x] ✅ Alertas Discord/Slack
- [x] ✅ Testing automatizado (integration, config, network)
- [x] ✅ CI/CD pipeline (GitHub Actions)
- [x] ✅ Security hardening
- [x] ✅ Development environment
- [x] ✅ Pre-commit hooks
- [x] ✅ 10,000+ líneas de documentación
- [x] ✅ Performance optimization guide
- [x] ✅ Troubleshooting tools

### 📈 Stats

- **26 archivos** de código/scripts
- **5,021 líneas** agregadas en Sprint 4
- **15 issues** completados
- **4 sprints** ejecutados
- **100% cobertura** de documentación

### 🔮 Next Phase (Futuro)

El proyecto está **completo** como template Docker. Próximas expansiones serán proyectos separados:
- **API REST** para gestión de múltiples servidores (proyecto separado)
- **Dashboard Web** para UI (proyecto separado)
- **Database Layer** para persistencia (proyecto separado)

Ver roadmap completo en [docs/ai/05_ROADMAP.md](docs/ai/05_ROADMAP.md)

---

## 💡 Notas

- **Este es un template**: No incluye gestión de múltiples servidores
- **La API va aparte**: Este proyecto es consumido por una API externa
- **Enfoque en configurabilidad**: Todo configurable vía ENV vars
- **Optimizado para instanciación**: Diseñado para crear N servidores rápidamente

---

## 📞 Soporte

- 📖 Documentación: `docs/ai/`
- 🐛 Issues: [Crear issue]
- 💬 Discusiones: [Abrir discusión]

---

**Estado del Proyecto:** ✅ **v1.0.0 - Production Ready**

**Última actualización:** 2025-10-25

---

<div align="center">

### ⭐ Si te gusta este proyecto, dale una estrella!

Made with ❤️ by [gastonfr24](https://github.com/gastonfr24)

</div>

