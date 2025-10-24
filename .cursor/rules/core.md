# Cursor Rules — DockerCraft (Docker + Shell + Minecraft)

## 🎯 Propósito

Definir reglas claras y ejecutables para que los cambios generados por agentes IA o colaboradores humanos:
- Sean **productivos, probados, seguros y mantenibles**
- No introduzcan código basura, dependencias innecesarias o cambios de formato arbitrarios
- Mantengan historial claro en `docs/ai/09_CHANGELOG.md` y `docs/ai/04_MEMORY.md`
- Sigan arquitectura definida en `docs/ai/02_ARCHITECTURE.md`
- Respeten decisiones técnicas (ADRs) en `docs/ai/03_DECISIONS.md`

---

## 🏗️ Arquitectura y Estructura del Proyecto

### Alcance de Este Proyecto
Este repositorio contiene **SOLO** el template base de Docker para servidores Minecraft:
- ✅ Dockerfile optimizado
- ✅ Configuración base (server.properties, etc.)
- ✅ Docker Compose de ejemplo
- ✅ Scripts de utilidad (health-check, optimizaciones)
- ✅ Documentación completa

**NO incluye:**
- ❌ API REST (va en proyecto separado)
- ❌ Base de datos
- ❌ Sistema de autenticación
- ❌ Dashboard web

### Principios Arquitectónicos OBLIGATORIOS

1. **Separación de Responsabilidades**
   - Este proyecto es SOLO el template Docker
   - No agregar lógica de API, gestión o bases de datos aquí
   - Si algo no es "configuración del servidor Minecraft", NO va aquí

2. **Configurabilidad Total**
   - TODA configuración debe ser via variables de entorno
   - NO hardcodear valores (versiones, puertos, memoria, etc.)
   - Usar `.env.example` para documentar todas las variables

3. **Inmutabilidad de Imagen**
   - La imagen Docker debe ser reproducible
   - NO ejecutar comandos de instalación en runtime
   - Toda instalación en build time

4. **Diseño Stateless**
   - El contenedor no debe guardar estado interno
   - TODO dato persistente va en volúmenes Docker
   - Contenedor debe poder destruirse y recrearse sin pérdida

---

## 📁 Convenciones de Estructura

```
dockercraft/
├── docs/ai/              # Documentación para IA (CRÍTICO mantener actualizado)
├── config/               # Configuraciones base (bukkit.yml, paper.yml, etc.)
├── scripts/              # Scripts de utilidad (shell)
├── plugins/              # Plugins pre-instalados (opcional)
├── Dockerfile            # ÚNICO Dockerfile del proyecto
├── docker-compose.yml    # Ejemplo standalone
├── docker-compose.multi.yml  # Ejemplo multi-servidor
├── .env.example          # Todas las ENV vars documentadas
├── server.properties     # Configuración base de Minecraft
└── README.md             # Documentación principal
```

**PROHIBIDO:**
- ❌ Múltiples Dockerfiles sin justificación
- ❌ Carpetas `src/`, `api/`, `database/` (van en otro proyecto)
- ❌ Scripts Python/Node.js (solo Shell/Bash)
- ❌ Archivos de config personales (.vscode, .idea, etc.)

---

## 🎨 Formato y Convenciones Globales

### Uso de Emojis

**REGLA ESTRICTA:**
- ❌ **NO usar emojis en CÓDIGO**:
  - Scripts Shell (`.sh`)
  - Dockerfile
  - docker-compose.yml
  - Variables, funciones, constantes
  - Comentarios dentro del código
  - Mensajes de log en scripts
  
- ✅ **SÍ usar emojis en DOCUMENTACIÓN**:
  - Archivos Markdown (`.md`)
  - README.md
  - docs/ai/*.md
  - CHANGELOG.md
  
- ❌ **NO usar emojis en:**
  - Commits messages
  - PR descriptions
  - Issue descriptions
  - Code comments

**Ejemplos:**

```bash
# ❌ MALO - NO emojis en código:
log_info "🚀 Starting server..."
readonly SERVER_NAME="⚡ Fast Server"

# ✅ BUENO - Sin emojis en código:
log_info "Starting server..."
readonly SERVER_NAME="fast-server"
```

```markdown
<!-- ✅ BUENO - Emojis OK en Markdown -->
# 🚀 Quick Start Guide

## ✅ Installation
```

```bash
# ❌ MALO - NO emojis en commits:
git commit -m "🐛 fix: correct health check"

# ✅ BUENO - Sin emojis en commits:
git commit -m "fix: correct health check timeout"
```

### Mantener Forma de Código
- Respetar el formateador del repo
- NO introducir cambios de estilo innecesarios
- NO reformatear archivos no relacionados con la tarea

### Idiomas

**REGLA ESTRICTA:**
- ✅ **Código en INGLÉS**:
  - Nombres de funciones
  - Nombres de variables
  - Nombres de constantes
  - Comentarios dentro del código
  - Mensajes de log
  - Commits y PRs
  - Issues
  
- ✅ **Documentación en ESPAÑOL**:
  - Archivos Markdown (*.md)
  - README.md
  - docs/ai/*.md
  - CHANGELOG.md
  - Comentarios de documentación (docstrings equivalentes)

**Ejemplos:**

```bash
# ✅ BUENO - Código en inglés
function check_server_status() {
  local container_name="$1"
  # Check if container is running
  if docker ps | grep -q "$container_name"; then
    log_info "Server is running"
    return 0
  fi
  log_error "Server is not running"
  return 1
}

# ❌ MALO - Código en español
function verificar_estado_servidor() {
  local nombre_contenedor="$1"
  # Verificar si el contenedor está corriendo
  if docker ps | grep -q "$nombre_contenedor"; then
    log_info "El servidor está corriendo"
    return 0
  fi
  return 1
}
```

```dockerfile
# ✅ BUENO - Comentarios en inglés
# Install dependencies for health check
RUN apt-get update && apt-get install -y curl

# Set default memory allocation
ENV MEMORY=${MEMORY:-4G}

# ❌ MALO - Comentarios en español
# Instalar dependencias para verificación de salud
RUN apt-get update && apt-get install -y curl
```

```markdown
<!-- ✅ BUENO - Documentación en español -->
# Guía de Inicio Rápido

## Instalación

Este proyecto requiere Docker 20.10+

## Uso

Para levantar el servidor...
```

```bash
# ✅ BUENO - Commits en inglés
git commit -m "feat: add health check script"
git commit -m "fix: correct port allocation logic"

# ❌ MALO - Commits en español
git commit -m "feat: agregar script de health check"
```

---

## 🔤 Nomenclatura y Convenciones

### Archivos
- **Dockerfile**: Singular, PascalCase
- **Scripts**: `kebab-case.sh` (ej: `health-check.sh`, `optimize-jvm.sh`)
- **Configs**: Nombres originales de Minecraft (ej: `server.properties`, `bukkit.yml`)
- **Docs**: `SCREAMING_SNAKE_CASE.md` o `01_PascalCase.md` (para ordenamiento)

### Variables de Entorno
```bash
# SCREAMING_SNAKE_CASE
VERSION=1.21.1
MAX_PLAYERS=20
ENABLE_AUTOPAUSE=true

# NO usar camelCase ni lowercase
```

### Contenedores y Volúmenes
```bash
# Patrón: mc-server-{identifier}
mc-server-1
mc-server-survival-main
mc-server-creative

# Volúmenes: {container-name}-data
mc-server-1-data
```

### Variables en Scripts
```bash
# snake_case para variables locales
local server_name="survival"
local port_number=25565

# SCREAMING_SNAKE_CASE para constantes
readonly BASE_PORT=25565
readonly MAX_SERVERS=100
```

### Funciones en Scripts
```bash
# snake_case con verbo descriptivo
check_docker_installed() { ... }
create_backup() { ... }
restore_from_backup() { ... }
```

---

## 🐳 Docker: Reglas ESTRICTAS

### Dockerfile

1. **Base Image**
   - SOLO `itzg/minecraft-server:java21` (ver ADR-002)
   - NUNCA cambiar imagen base sin ADR nuevo
   - Pinear versión específica en producción

2. **Multi-Stage NO es necesario aquí**
   - La imagen base ya está optimizada
   - NO crear stages innecesarios

3. **Variables de Entorno**
   ```dockerfile
   # TODAS las vars deben tener default razonable
   ENV VERSION=${VERSION:-LATEST}
   ENV MEMORY=${MEMORY:-4G}
   
   # NO hardcodear valores
   # ❌ MALO:
   ENV VERSION=1.21.1
   
   # ✅ BUENO:
   ENV VERSION=${VERSION:-1.21.1}
   ```

4. **Health Check OBLIGATORIO**
   ```dockerfile
   HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
     CMD mc-health || exit 1
   ```

5. **Usuario No-Root**
   - La imagen itzg ya maneja esto
   - NO agregar `USER root` innecesariamente

6. **Layers Optimization**
   - Combinar comandos RUN cuando sea posible
   - Limpiar caches en el mismo layer
   ```dockerfile
   # ✅ BUENO:
   RUN apt-get update && \
       apt-get install -y package && \
       apt-get clean && \
       rm -rf /var/lib/apt/lists/*
   
   # ❌ MALO:
   RUN apt-get update
   RUN apt-get install -y package
   RUN apt-get clean
   ```

### docker-compose.yml

1. **Versionado**
   ```yaml
   version: '3.8'  # Especificar versión
   ```

2. **Named Volumes SIEMPRE**
   ```yaml
   volumes:
     - mc-data:/data  # ✅ Named volume
   # NO:
     - /data  # ❌ Anonymous volume
   ```

3. **Environment Variables**
   ```yaml
   environment:
     - EULA=TRUE
     - VERSION=${VERSION:-1.21.1}
   # Usar .env file
   env_file:
     - .env
   ```

4. **Resource Limits**
   ```yaml
   deploy:
     resources:
       limits:
         cpus: '2'
         memory: 4G
       reservations:
         memory: 2G
   ```

5. **Restart Policy**
   ```yaml
   restart: unless-stopped  # NO "always"
   ```

6. **Networking**
   ```yaml
   networks:
     - minecraft-net
   
   networks:
     minecraft-net:
       driver: bridge
   ```

---

## 📜 Scripts Shell: Reglas ESTRICTAS

### Headers Obligatorios

```bash
#!/usr/bin/env bash
set -euo pipefail  # OBLIGATORIO
IFS=$'\n\t'

# Script: health-check.sh
# Purpose: Check Minecraft server health
# Usage: ./health-check.sh <container_name>
# Author: [name]
# Date: YYYY-MM-DD
```

### Prácticas Obligatorias

1. **Validación de Argumentos**
   ```bash
   if [ $# -ne 1 ]; then
     echo "Usage: $0 <container_name>" >&2
     exit 1
   fi
   ```

2. **Verificar Dependencias**
   ```bash
   command -v docker >/dev/null 2>&1 || {
     echo "Error: docker is required but not installed." >&2
     exit 1
   }
   ```

3. **Variables con Defaults**
   ```bash
   readonly TIMEOUT=${TIMEOUT:-30}
   readonly RETRY_COUNT=${RETRY_COUNT:-3}
   ```

4. **Error Handling**
   ```bash
   trap 'echo "Error on line $LINENO" >&2' ERR
   trap cleanup EXIT
   
   cleanup() {
     # Limpiar recursos temporales
     rm -f /tmp/temp_file
   }
   ```

5. **Funciones con Documentación**
   ```bash
   # Check if container is running
   # Args:
   #   $1 - container name
   # Returns:
   #   0 if running, 1 otherwise
   is_container_running() {
     local container_name="$1"
     docker ps --filter "name=${container_name}" --format "{{.Names}}" | grep -q "^${container_name}$"
   }
   ```

6. **Logging Estructurado**
   ```bash
   log_info() {
     echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $*"
   }
   
   log_error() {
     echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
   }
   ```

### Prohibido en Scripts

- ❌ NO usar `cd` sin verificar éxito
- ❌ NO usar `rm -rf` sin validación
- ❌ NO ejecutar comandos con `sudo`
- ❌ NO hardcodear rutas absolutas
- ❌ NO usar `eval` (riesgo de seguridad)
- ❌ NO ignorar exit codes importantes

---

## ✅ Testing y Calidad

### Testing Obligatorio

1. **Dockerfile**
   ```bash
   # Verificar que build funciona
   docker build -t dockercraft-mc:test .
   
   # Verificar que arranca
   docker run --rm -d --name test-mc \
     -e EULA=TRUE \
     dockercraft-mc:test
   
   # Wait y verificar health
   sleep 30
   docker inspect --format='{{.State.Health.Status}}' test-mc
   
   # Cleanup
   docker stop test-mc
   ```

2. **docker-compose.yml**
   ```bash
   # Validar sintaxis
   docker-compose config
   
   # Levantar y verificar
   docker-compose up -d
   docker-compose ps
   docker-compose logs
   docker-compose down
   ```

3. **Scripts Shell**
   ```bash
   # Verificar sintaxis
   shellcheck scripts/*.sh
   
   # Ejecutar con set -x para debug
   bash -x scripts/health-check.sh test-container
   ```

### Linters Obligatorios

```bash
# Dockerfile
hadolint Dockerfile

# Shell scripts
shellcheck scripts/*.sh

# YAML files
yamllint docker-compose.yml
```

### Security Scanning

```bash
# Escanear imagen
trivy image dockercraft-mc:latest

# Verificar secretos
git-secrets --scan

# Verificar Dockerfile
docker scan dockercraft-mc:latest
```

---

## 📊 Metodología: Scrum con Sprints

### Sprint Planning

**Duración de Sprint:** 1 semana (adaptable según complejidad)

**Estructura de Sprint:**
```
Sprint N (YYYY-MM-DD a YYYY-MM-DD)
├── Planning (Lunes)
├── Daily Standups (Martes-Viernes, 15min)
├── Development (Lunes-Jueves)
├── Testing (Viernes mañana)
├── Review (Viernes tarde)
└── Retrospective (Viernes tarde)
```

### Definition of Done (DoD)

Una tarea está COMPLETA solo cuando:

- [ ] Código implementado y funcional
- [ ] Tests escritos y pasando
- [ ] Linters pasando (hadolint, shellcheck, yamllint)
- [ ] Security scan sin vulnerabilidades críticas
- [ ] Documentación actualizada:
  - [ ] `docs/ai/04_MEMORY.md` actualizado
  - [ ] `docs/ai/09_CHANGELOG.md` actualizado
  - [ ] README.md actualizado (si aplica)
- [ ] Probado localmente (docker build, docker-compose up)
- [ ] Code review completado
- [ ] Merged a `main`

### Sprint Backlog Format

```markdown
## Sprint 1: Servidor Base (2025-10-24 a 2025-10-31)

### User Stories

**US-001: Dockerfile Base**
- **Como** desarrollador
- **Quiero** un Dockerfile optimizado
- **Para** crear servidores Minecraft reproducibles

**Acceptance Criteria:**
- [ ] Build exitoso
- [ ] Health check funciona
- [ ] Auto-pause configurado
- [ ] Variables de entorno documentadas

**Tasks:**
- [ ] Crear Dockerfile base
- [ ] Configurar health check
- [ ] Probar con Paper 1.21.1
- [ ] Documentar en README

**Story Points:** 5
**Priority:** P0 (Crítico)
```

### Daily Standup Template

```markdown
## Daily Standup - YYYY-MM-DD

**Yesterday:**
- Completé US-001: Dockerfile base
- Inicié US-002: Docker Compose

**Today:**
- Terminar US-002
- Iniciar testing local
- Actualizar docs/ai/

**Blockers:**
- Ninguno
```

### Sprint Review Checklist

- [ ] Demo de funcionalidades completadas
- [ ] Validar contra Definition of Done
- [ ] Actualizar `docs/ai/05_ROADMAP.md` con progreso
- [ ] Mover tareas incompletas a siguiente sprint

### Sprint Retrospective

**3 Preguntas:**
1. ¿Qué salió bien?
2. ¿Qué salió mal?
3. ¿Qué mejoraremos en próximo sprint?

**Actualizar:**
- `docs/ai/04_MEMORY.md` > "Lecciones Aprendidas"

---

## 🔄 Workflow: Git y Commits

### Branch Strategy

```
main (protected)
  ├── feature/dockerfile-base
  ├── feature/docker-compose
  ├── fix/health-check
  └── docs/update-architecture
```

### Conventional Commits OBLIGATORIO (EN INGLÉS)

**⚠️ IMPORTANTE: Commits SIEMPRE en inglés**

```bash
# Format:
<type>(<scope>): <description in English>

[optional body in English]

[optional footer]

# Valid types:
feat:     New feature
fix:      Bug fix
docs:     Documentation only
style:    Formatting (no logic change)
refactor: Code refactoring
test:     Add/modify tests
chore:    Maintenance (deps, configs)
perf:     Performance improvement
ci:       CI/CD changes
```

### Ejemplos de Commits

```bash
# ✅ GOOD: English, no emojis, descriptive
feat(docker): add multi-stage build for optimization
fix(health-check): correct RCON connection timeout
docs(readme): update quick start guide
chore(deps): bump itzg/minecraft-server to java21
refactor(scripts): improve error handling in backup script

# ❌ BAD: Various reasons
"Fixed stuff"                              # Not descriptive
"Update"                                   # Too vague
"WIP"                                      # Work in progress, don't commit
"asdf"                                     # Meaningless
"🐛 fix: bug"                              # No emojis
"🚀 feat: new feature"                     # No emojis
"feat(docker): agregar multi-stage build"  # Spanish (use English)
"fix(health): corregir timeout"            # Spanish (use English)
```

### Pre-Commit Checklist

Antes de cada commit, verificar:

```bash
# 1. Linters
hadolint Dockerfile
shellcheck scripts/*.sh
yamllint *.yml

# 2. Tests
./scripts/test-docker-build.sh
./scripts/test-docker-compose.sh

# 3. Docs actualizadas
git diff docs/ai/04_MEMORY.md
git diff docs/ai/09_CHANGELOG.md

# 4. No hay secretos
git secrets --scan

# 5. Commit message válido
# (usar commitlint si está configurado)
```

---

## 📝 Documentación: Reglas ESTRICTAS

### Actualización Obligatoria

Cada cambio funcional DEBE actualizar:

1. **`docs/ai/04_MEMORY.md`**
   - Sección "Memoria de Corto Plazo"
   - Agregar decisión tomada
   - Actualizar "Próximos Pasos"

2. **`docs/ai/09_CHANGELOG.md`**
   ```markdown
   ## [Unreleased]
   
   ### Added
   - feat(docker): Multi-stage build for 30% size reduction
   
   ### Fixed
   - fix(health-check): Timeout now configurable via ENV
   ```

3. **`README.md` (si cambia interfaz pública)**
   - Actualizar ejemplos si cambian ENV vars
   - Actualizar comandos si cambia uso

### ADR (Architecture Decision Record)

Cuando tomes decisión arquitectónica importante, crear ADR en `docs/ai/03_DECISIONS.md`:

```markdown
## ADR-XXX: [Título]

**Estado:** ✅ Aceptado
**Fecha:** YYYY-MM-DD

**Contexto:**
¿Por qué necesitamos decidir esto?

**Decisión:**
¿Qué decidimos?

**Consecuencias:**
**Positivas:**
- ...

**Negativas:**
- ...

**Alternativas Consideradas:**
1. Opción A - Rechazada porque...
```

### Comentarios en Código

**Dockerfile:**
```dockerfile
# Install dependencies for health check
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean

# Configure auto-pause (see ADR-010)
ENV ENABLE_AUTOPAUSE=${ENABLE_AUTOPAUSE:-TRUE}
```

**Scripts:**
```bash
# Check if port is available before assigning
# See: docs/ai/02_ARCHITECTURE.md#port-assignment
check_port_available() {
  # ...
}
```

**NO documentar obviedades:**
```bash
# ❌ MALO:
# Set variable x to 10
x=10

# ✅ BUENO (solo si no es obvio):
# Wait 30s for server to initialize health endpoint
sleep 30
```

---

## 🚫 Patrones PROHIBIDOS

### Dockerfile
```dockerfile
# ❌ PROHIBIDO:
# 🚀 Starting build...      # NO emojis en comentarios
USER root                    # No ejecutar como root
RUN apt-get upgrade -y       # No hacer upgrade masivo
ENV SECRET_KEY=abc123        # No hardcodear secretos
COPY . .                     # No copiar todo sin .dockerignore
RUN sudo apt-get install     # No usar sudo
```

### Shell Scripts
```bash
# ❌ PROHIBIDO:
echo "🚀 Starting..."        # NO emojis en logs
readonly NAME="⚡ Server"    # NO emojis en variables
rm -rf /                     # Obvio
eval "$user_input"           # Inyección de código
cd /some/path                # Sin verificar que existe
$(cat file)                  # Command substitution inseguro
```

### docker-compose.yml
```yaml
# ❌ PROHIBIDO:
# 🚀 Main service...         # NO emojis en comentarios
environment:
  - DB_PASSWORD=secret123    # No hardcodear secrets
volumes:
  - /:/host                  # No montar root del host
privileged: true             # No privileged sin razón
network_mode: host           # No usar host network
```

### Git
```bash
# ❌ PROHIBIDO:
git commit -m "🐛 fix bug"   # NO emojis en commits
git commit -m "WIP"          # Commit message inútil
git push --force origin main # Force push a main
git commit --no-verify       # Skip hooks
git add .                    # Sin revisar qué se agrega
```

---

## 🤖 Reglas para IA (Cursor, Copilot, etc.)

### Antes de Proponer Cambios

El agente IA DEBE:

1. **Leer Documentación Obligatoria:**
   - `docs/ai/01_CONTEXT.md` - Entender el proyecto
   - `docs/ai/02_ARCHITECTURE.md` - Respetar arquitectura
   - `docs/ai/03_DECISIONS.md` - Seguir ADRs
   - `docs/ai/04_MEMORY.md` - Ver estado actual

2. **Verificar Alcance:**
   - ¿Este cambio pertenece a este proyecto?
   - ¿O debería ir en la API externa?

3. **Simular Verificaciones:**
   ```bash
   # Antes de proponer, simular:
   hadolint Dockerfile
   shellcheck scripts/*.sh
   docker build -t test .
   docker-compose config
   ```

4. **Preparar Entregables:**
   - Código modificado
   - Tests (si aplica)
   - Entrada para CHANGELOG.md
   - Actualización para MEMORY.md
   - Comandos de verificación

### Output Requerido del Agente

Cada respuesta con cambios de código debe incluir:

```markdown
## 📦 Cambios Propuestos

### Archivos Modificados
- `Dockerfile` - Agregado health check mejorado
- `scripts/health-check.sh` - Nuevo script
- `docs/ai/04_MEMORY.md` - Actualizado
- `docs/ai/09_CHANGELOG.md` - Actualizado

### Entrada para CHANGELOG.md
```
## [Unreleased]

### Added
- feat(health): Advanced health check with RCON validation
```

### Comandos de Verificación
```bash
# Lint
hadolint Dockerfile
shellcheck scripts/health-check.sh

# Build y Test
docker build -t dockercraft-mc:test .
docker run --rm -d --name test-mc -e EULA=TRUE dockercraft-mc:test
sleep 30
docker exec test-mc ./scripts/health-check.sh
docker stop test-mc

# Compose
docker-compose config
docker-compose up -d
docker-compose ps
docker-compose down
```

### Resultados Esperados
- `hadolint`: ✅ No issues
- `shellcheck`: ✅ No warnings
- `docker build`: ✅ Success
- `health-check`: ✅ Server healthy
- `docker-compose`: ✅ All services up

### Sprint Context
- **Sprint:** Sprint 1
- **User Story:** US-003
- **Story Points:** 3
- **Status:** Ready for review
```

### Cuando NO Proponer Cambios

El agente NO debe proponer cambios si:

- ❌ No leyó la documentación en `docs/ai/`
- ❌ El cambio pertenece a la API externa (otro proyecto)
- ❌ No puede verificar que los linters pasarían
- ❌ No actualizó `docs/ai/04_MEMORY.md`
- ❌ No agregó entrada a `docs/ai/09_CHANGELOG.md`
- ❌ Modifica archivos no relacionados con la tarea
- ❌ Introduce cambios de formato sin razón funcional

---

## 🎯 Checklist Final: Pull Request

Antes de abrir PR, verificar:

### Código
- [ ] Linters pasando (hadolint, shellcheck, yamllint)
- [ ] Security scan sin críticos (trivy, git-secrets)
- [ ] Build de Docker exitoso
- [ ] docker-compose up funciona
- [ ] Tests manuales completados

### Documentación
- [ ] `docs/ai/04_MEMORY.md` actualizado
- [ ] `docs/ai/09_CHANGELOG.md` actualizado
- [ ] README.md actualizado (si cambió interfaz)
- [ ] Comentarios en código donde necesario
- [ ] ADR creado (si decisión arquitectónica)

### Git
- [ ] Conventional commit messages
- [ ] No commits de "WIP" o "test"
- [ ] No archivos temporales (.swp, .tmp, etc.)
- [ ] .gitignore actualizado si necesario

### Sprint
- [ ] User Story asociada
- [ ] Definition of Done cumplida
- [ ] Tasks actualizadas en backlog

---

## 🚫 Regla Anti-Hardcodeo y Placeholders

### Filosofía

**NUNCA generar código con valores placeholder o hardcodeados que no sean reales.**

Si falta información, DETENER y PREGUNTAR al usuario antes de continuar.

### Placeholders PROHIBIDOS

NUNCA usar estos términos en código o documentación:

```
YOUR_USERNAME          TU_USUARIO
YOUR_NAME             TU_NOMBRE
YOUR_EMAIL            TU_EMAIL
YOUR_REPO             TU_REPO
YOUR_API_KEY          TU_API_KEY
CHANGE_THIS           CAMBIAR_ESTO
REPLACE_THIS          REEMPLAZAR_ESTO
TODO: add value       TODO: añadir valor
[COMPLETAR]           [TO_FILL]
[YOUR_VALUE]          [TU_VALOR]
XXXXX                 YYYYY
example.com           test@test.com (si es placeholder)
```

### Qué Hacer en su Lugar

#### 1. Si son Datos del Usuario/Proyecto

**DETENER y PREGUNTAR:**

```
ANTES DE GENERAR CÓDIGO:
"Necesito la siguiente información para continuar:
- URL del repositorio GitHub
- Nombre de la organización (si aplica)
- Container registry (ghcr.io, docker.io, etc.)
- ¿Qué valor debería usar para X?"
```

#### 2. Si son Configuraciones Variables

**Usar variables de entorno:**

```bash
# Incorrecto
export API_KEY="CHANGE_THIS"
docker run -e RCON_PASSWORD="YOUR_PASSWORD" ...

# Correcto
export API_KEY="${RCON_PASSWORD}"  # Documentado en .env.example
docker run -e RCON_PASSWORD="${RCON_PASSWORD}" ...
```

#### 3. Si son Ejemplos en Documentación

**Usar datos ficticios pero CLARAMENTE marcados:**

```markdown
# Incorrecto
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git

# Correcto (con nota clara)
# Example: Replace with your actual repository
git clone https://github.com/gastonfr24/dockercraft.git
```

### Datos Reales del Proyecto

**Usar SIEMPRE estos valores reales:**

```bash
# Usuario GitHub
GITHUB_USER="gastonfr24"
GITHUB_EMAIL="gastonfr24@gmail.com"

# Repositorio
REPO_NAME="dockercraft"
REPO_URL="https://github.com/gastonfr24/dockercraft"

# Container Registry (cuando se defina)
# CONTAINER_REGISTRY="ghcr.io/gastonfr24/dockercraft"

# Proyecto
PROJECT_NAME="DockerCraft"
PROJECT_SCOPE="Docker template for Minecraft servers"
```

### Ejemplos de Implementación

#### Correcto - CONTRIBUTING.md

```bash
# Clone your fork
git clone https://github.com/gastonfr24/dockercraft.git
cd dockercraft

# Configure Git (use YOUR credentials)
git config user.name "gastonfr24"
git config user.email "gastonfr24@gmail.com"
```

#### Correcto - Scripts

```bash
#!/usr/bin/env bash
# Use environment variables for configuration
BACKUP_DIR="${BACKUP_DIR:-/data/backups}"
RETENTION_DAYS="${RETENTION_DAYS:-7}"
```

#### Correcto - Documentación

```markdown
## Installation

Clone the repository:
```bash
git clone https://github.com/gastonfr24/dockercraft.git
```

Note: If forking, replace `gastonfr24` with your username.
```

### Validación Pre-Commit

Antes de commit, verificar:

```bash
# Buscar placeholders prohibidos
grep -r "YOUR_" . --exclude-dir=.git
grep -r "CHANGE_THIS" . --exclude-dir=.git
grep -r "TODO.*add.*value" . --exclude-dir=.git
grep -r "\[COMPLETAR\]" . --exclude-dir=.git
```

Si encuentra algo, CORREGIR antes de commitear.

### Excepciones

**Único caso permitido:** Templates de configuración CLARAMENTE marcados

```bash
# .env.example - CORRECTO
# This is a template - copy to .env and configure
RCON_PASSWORD=minecraft  # Change in production

# .github/ISSUE_TEMPLATE - CORRECTO (son templates de GitHub)
# Estos archivos son templates oficiales y está OK
```

### Enforcement

**Esta regla es CRÍTICA.**

Violaciones resultan en:
1. PR automáticamente rechazado
2. Commit revertido
3. Revisión obligatoria de TODO el código

**No hay excepciones sin aprobación explícita.**

---

## 📚 Referencias

- **Documentación del Proyecto:** `docs/ai/`
- **Imagen Base:** [itzg/minecraft-server](https://github.com/itzg/docker-minecraft-server)
- **Docker Best Practices:** [Docker Docs](https://docs.docker.com/develop/dev-best-practices/)
- **Shell Style Guide:** [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- **Conventional Commits:** [conventionalcommits.org](https://www.conventionalcommits.org/)
- **Scrum Guide:** [scrumguides.org](https://scrumguides.org/)

---

## ⚠️ Enforcement

**Estas reglas son OBLIGATORIAS, no sugerencias.**

Violaciones resultarán en:
1. PR rechazado
2. Commits revertidos
3. Revisión obligatoria de documentación

**En caso de duda, leer `docs/ai/00_README_AI.md` primero.**

---

**Última actualización:** 2025-10-24
**Versión:** 1.0.0

