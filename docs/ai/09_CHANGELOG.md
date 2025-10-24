# 📝 Changelog - DockerCraft

> Registro de cambios del proyecto siguiendo [Keep a Changelog](https://keepachangelog.com/)

## [Unreleased]

### En Desarrollo
- Testing local de configuraciones
- README.md completo con guías de uso
- Validación con hadolint y shellcheck

---

## [0.2.0-alpha] - 2025-10-24

### Added - Sprint 1 Completado
- `Dockerfile` - Imagen base optimizada con itzg/minecraft-server:java21
- `.dockerignore` - Optimización de contexto de build
- `.env.example` - Documentación completa de variables de entorno
- `.gitignore` - Reglas de Git para el proyecto
- `server.properties` - Configuración base del servidor Minecraft
- `docker-compose.yml` - Ejemplo standalone para servidor único
- `docker-compose.multi.yml` - Ejemplo multi-servidor (survival, creative, minigames)
- `scripts/health-check.sh` - Script customizado de health check
- `.cursor/rules/` - Reglas modulares de Cursor (core, docker, shell, git, documentation, testing)

### Features Implemented
- Auto-pause cuando no hay jugadores (ahorro de recursos)
- Health checks nativos de Docker
- RCON habilitado para administración remota
- Configuración via variables de entorno
- Resource limits configurables (CPU/Memory)
- Aikar flags para optimización JVM
- Logging con timestamps y timezone configurable

### Technical
- Multi-stage build ready
- Volume persistence para worlds y configs
- Network bridge para comunicación entre servidores
- Restart policies configuradas
- Stdin/tty para acceso a consola

### Decisions
- Usar health check nativo `mc-health` de itzg
- Defaults sensibles para todas las variables
- Separación de ejemplos: standalone vs multi-servidor
- Scripts en bash con strict mode (set -euo pipefail)

### Notes
- Proyecto listo para testing local
- Falta README.md con guías de uso completas
- Falta testing e2e con servidor real

---

## [0.1.0-alpha] - 2025-10-24

### Added
- Estructura inicial del proyecto
- Documentación completa para IA en `docs/ai/`
- Plan de implementación detallado
- Definición de arquitectura
- ADRs (Architecture Decision Records)
- Cursor Rules modulares

### Decisions
- Usar `itzg/minecraft-server` como imagen base
- Paper como tipo de servidor por defecto
- Docker Compose para ejemplos de uso
- Variables de entorno para configuración

### Notes
- Proyecto en fase de planificación
- Este es SOLO el template Docker, API va en proyecto separado

---

## Formato

Tipos de cambios:
- `Added` - Nuevas funcionalidades
- `Changed` - Cambios en funcionalidades existentes
- `Deprecated` - Funcionalidades que serán removidas
- `Removed` - Funcionalidades removidas
- `Fixed` - Bug fixes
- `Security` - Vulnerabilidades de seguridad

---

**Última actualización:** 2025-10-24

