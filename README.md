# 🎮 DockerCraft - Minecraft Server Template

> Plantilla Docker optimizada para servidores de Minecraft que pueden ser instanciados bajo demanda

[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![Minecraft](https://img.shields.io/badge/Minecraft-1.21.1-62B47A?logo=minecraft&logoColor=white)](https://www.minecraft.net/)
[![Paper](https://img.shields.io/badge/Paper-Optimized-00897B)](https://papermc.io/)

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

- 🐳 **Containerizado con Docker** - Aislamiento y portabilidad
- ⚙️ **Altamente Configurable** - Variables de entorno para todo
- 📦 **Basado en itzg/minecraft-server** - Imagen madura y mantenida
- 🚀 **Optimizado** - Paper server con JVM flags optimizados
- 💾 **Persistente** - Volúmenes Docker para datos
- 🔄 **Auto-Pause** - Ahorra recursos cuando no hay jugadores
- 🏥 **Health Checks** - Monitoreo automático de estado
- 📖 **Bien Documentado** - Guías completas y ejemplos

---

## 🚀 Quick Start

### Prerequisitos

- Docker 20.10+
- Docker Compose 2.0+

### Levantar Servidor de Prueba

```bash
# 1. Clonar repositorio
git clone <repo-url>
cd dockercraft

# 2. Copiar variables de entorno
cp .env.example .env

# 3. Editar configuración (opcional)
nano .env

# 4. Levantar servidor
docker-compose up -d

# 5. Ver logs
docker-compose logs -f

# 6. Conectar desde Minecraft
# Server Address: localhost:25565
```

---

## 📁 Estructura del Proyecto

```
dockercraft/
├── docs/                  # Documentación completa
│   └── ai/                # Docs específicas para contexto de IA
├── Dockerfile             # Imagen Docker optimizada
├── docker-compose.yml     # Ejemplo standalone
├── docker-compose.multi.yml  # Ejemplo multi-servidor
├── .env.example           # Variables de entorno documentadas
├── server.properties      # Configuración base
├── config/                # Configuraciones adicionales
├── plugins/               # Plugins pre-instalados (opcional)
├── scripts/               # Scripts de utilidad
└── README.md              # Este archivo
```

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

### Para Usuarios

- 📖 **Quick Start**: Ver sección anterior
- 🔧 **Configuración**: Ver `.env.example`
- 🐛 **Troubleshooting**: Ver `docs/ai/07_WORKFLOWS.md`
- 📝 **Variables de Entorno**: Ver `docs/ai/08_QUICK_START.md`

### Para Desarrolladores/IA

Documentación completa en `docs/ai/`:

1. **`01_CONTEXT.md`** - Contexto del proyecto
2. **`02_ARCHITECTURE.md`** - Arquitectura técnica
3. **`03_DECISIONS.md`** - Decisiones técnicas (ADRs)
4. **`04_MEMORY.md`** - Memoria del proyecto
5. **`05_ROADMAP.md`** - Plan de implementación
6. **`07_WORKFLOWS.md`** - Procedimientos y workflows
7. **`08_QUICK_START.md`** - Guía rápida detallada
8. **`09_CHANGELOG.md`** - Historial de cambios
9. **`10_GLOSSARY.md`** - Glosario de términos

**Inicio recomendado para IA:** Leer `docs/ai/00_README_AI.md`

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

## 🎯 Roadmap

- [x] Documentación completa
- [ ] Dockerfile optimizado
- [ ] Docker Compose examples
- [ ] Scripts de utilidad
- [ ] Testing y validación
- [ ] CI/CD pipeline
- [ ] Imágenes pre-built en Docker Hub

Ver roadmap completo en `docs/ai/05_ROADMAP.md`

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

**Estado del Proyecto:** 🚧 En desarrollo activo - Fase de planificación completa

**Última actualización:** 2025-10-24

