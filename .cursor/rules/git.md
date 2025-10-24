# Git Workflow y Versionado - DockerCraft

**Última actualización:** 2025-10-24

---

## Tabla de Contenidos

1. [Estrategia de Ramas](#estrategia-de-ramas)
2. [Conventional Commits](#conventional-commits)
3. [Versionado Semántico](#versionado-semántico)
4. [Pull Requests](#pull-requests)
5. [Issues](#issues)
6. [Release Process](#release-process)
7. [Ejemplos Prácticos](#ejemplos-prácticos)

---

## Estrategia de Ramas

### Modelo: Git Flow Adaptado

Usamos un modelo basado en Git Flow con `dev` como rama de integración:

```
main (production)
  |
  └─── dev (integration)
        |
        |-- feature/add-backup-script
        |-- fix/health-check-timeout
        |-- docs/update-readme
        |-- refactor/optimize-dockerfile
        └-- release/v0.3.0
```

### Ramas Principales

#### `main` (PRODUCCIÓN)

- **Rama de producción PROTEGIDA**
- Contiene SOLO código probado y estable
- Representa el estado actual en producción
- **Requiere PR review + testing antes de merge**
- **NO se permite push directo**
- **NO se permite force push**
- Tagged con versiones (v0.1.0, v0.2.0, etc.)
- Solo recibe merges desde `dev` o `hotfix/`

**Reglas estrictas:**
- ❌ NO hacer feature branches desde main
- ❌ NO mergear sin testing completo
- ❌ NO mergear sin code review
- ✅ Solo código 100% funcional

#### `dev` (DESARROLLO)

- **Rama de integración para desarrollo**
- Rama base para todas las features
- Aquí se integran y testean las features
- Puede tener bugs temporalmente
- Se mergea a `main` cuando hay una release
- **Protegida** (requiere PR)

**Flujo:**
1. Features se crean desde `dev`
2. Features se mergean a `dev`
3. Testing en `dev`
4. Release: `dev` → `main`

### Ramas de Trabajo

Formato: `<tipo>/<descripcion-corta>`

**Tipos permitidos:**

- `feature/` - Nueva funcionalidad
- `fix/` - Bug fix
- `hotfix/` - Fix urgente para producción
- `docs/` - Cambios de documentación
- `refactor/` - Refactoring sin cambios funcionales
- `test/` - Añadir o modificar tests
- `chore/` - Tareas de mantenimiento
- `release/` - Preparar nueva release

**Ejemplos:**

```bash
feature/auto-backup
fix/rcon-connection-timeout
hotfix/critical-memory-leak
docs/api-integration-guide
refactor/dockerfile-multistage
test/add-integration-tests
chore/update-dependencies
release/v0.3.0
```

### Reglas de Nombrado

- Usar kebab-case (minúsculas con guiones)
- Máximo 50 caracteres
- Descriptivo pero conciso
- NO usar emojis
- NO usar espacios

**Correcto:**

```
feature/add-plugin-support
fix/server-crash-on-startup
docs/update-quick-start
```

**Incorrecto:**

```
feature/ADD_PLUGIN_SUPPORT      # No MAYUSCULAS
fix/bug                          # Muy vago
feature/add plugin support       # No espacios
feature/add-plugin-support-for-bukkit-spigot-paper-and-purpur  # Muy largo
```

---

## Conventional Commits

### Formato

```
<tipo>(<scope>): <descripción>

[cuerpo opcional]

[footer opcional]
```

### Tipos de Commit

| Tipo | Descripción | Cuándo Usar |
|------|-------------|-------------|
| `feat` | Nueva funcionalidad | Añadir auto-pause, nuevo script |
| `fix` | Bug fix | Corregir health check, memoria leak |
| `docs` | Documentación | Actualizar README, añadir guías |
| `style` | Formato | Indentación, espacios (NO cambia lógica) |
| `refactor` | Refactoring | Mejorar código sin cambiar funcionalidad |
| `perf` | Performance | Optimizaciones de rendimiento |
| `test` | Tests | Añadir o modificar tests |
| `chore` | Mantenimiento | Actualizar deps, configs |
| `ci` | CI/CD | GitHub Actions, workflows |
| `build` | Build system | Dockerfile, docker-compose changes |
| `revert` | Revertir | Revertir commit anterior |

### Scopes (Opcional)

Indica qué parte del proyecto afecta:

- `docker` - Dockerfile, docker-compose
- `scripts` - Scripts en /scripts
- `docs` - Documentación
- `config` - Archivos de configuración
- `ci` - CI/CD

### Ejemplos de Commits

**Correcto:**

```
feat(docker): add multi-stage build for smaller image size
fix(scripts): correct health check timeout handling
docs(readme): add troubleshooting section
refactor(dockerfile): optimize layer caching
perf(config): reduce memory allocation for small servers
chore(deps): update base image to java21-alpine
```

**Incorrecto:**

```
Added new feature                # No tipo, no scope, muy vago
FIX: bug in script               # Tipo en mayúsculas
feat: added cool stuff           # Muy vago
fix(docker): fixed the thing that was broken  # Redundante "fixed"
feat(docker): Add auto-pause     # Capitalizado (debe ser minúscula)
```

### Breaking Changes

Si un commit rompe compatibilidad:

```
feat(docker)!: change default server type to Paper

BREAKING CHANGE: Default TYPE changed from VANILLA to PAPER.
Update your .env file or set TYPE=VANILLA explicitly.
```

O en el footer:

```
feat(config): redesign environment variables

BREAKING CHANGE: Renamed ENV vars for consistency:
- MINECRAFT_VERSION -> VERSION
- MINECRAFT_MEMORY -> MEMORY
```

### Reglas Estrictas

1. **NO emojis en commits**
2. Primera línea máximo 72 caracteres
3. Usar imperativo presente ("add" no "added")
4. Minúsculas en descripción (después del tipo)
5. NO punto final en descripción
6. Cuerpo opcional, separado por línea en blanco

---

## Versionado Semántico

Seguimos [SemVer 2.0.0](https://semver.org/)

### Formato: `v<MAJOR>.<MINOR>.<PATCH>[-<PRERELEASE>]`

```
v0.1.0        # Primera versión alpha
v0.2.0-alpha  # Pre-release alpha
v0.2.0-beta   # Pre-release beta
v0.2.0-rc.1   # Release candidate
v1.0.0        # Primera versión estable
v1.0.1        # Patch (bug fix)
v1.1.0        # Minor (nueva feature compatible)
v2.0.0        # Major (breaking change)
```

### Cuándo Incrementar

**MAJOR (v1.0.0 → v2.0.0):**
- Breaking changes
- Incompatibilidad con versión anterior
- Cambios en API pública

**MINOR (v1.0.0 → v1.1.0):**
- Nueva funcionalidad compatible
- Deprecaciones
- Mejoras sin romper compatibilidad

**PATCH (v1.0.0 → v1.0.1):**
- Bug fixes
- Parches de seguridad
- Optimizaciones menores

### Pre-releases

- `alpha` - Desarrollo temprano, puede tener bugs
- `beta` - Feature completo, en testing
- `rc` - Release candidate, casi listo

### Ejemplos

```bash
# Proyecto nuevo
v0.1.0-alpha   # Primera versión

# Añadir feature
v0.2.0-alpha   # Auto-pause implementado

# Bug fixes
v0.2.1-alpha   # Fix health check

# Release candidate
v1.0.0-rc.1    # Listo para testing final

# Primera versión estable
v1.0.0         # Production ready

# Patch
v1.0.1         # Fix critical bug

# Nueva feature
v1.1.0         # Add backup scripts

# Breaking change
v2.0.0         # Complete API redesign
```

---

## Pull Requests

### Workflow

```bash
# 1. Crear rama desde main
git checkout main
git pull origin main
git checkout -b feature/add-backup-script

# 2. Hacer cambios y commits
git add scripts/backup.sh
git commit -m "feat(scripts): add automated backup script"

# 3. Push rama
git push origin feature/add-backup-script

# 4. Crear PR en GitHub
# Title: feat(scripts): add automated backup script
# Description: Ver template abajo

# 5. Review y merge
# - CI debe pasar (si existe)
# - Al menos 1 approval (si hay equipo)
# - Squash merge a main
```

### Template de PR

```markdown
## Descripción

Implementa script de backup automatizado que guarda el mundo cada X horas.

## Tipo de Cambio

- [ ] Bug fix (non-breaking)
- [x] Nueva feature (non-breaking)
- [ ] Breaking change
- [ ] Documentación

## Checklist

- [x] Código sigue las cursor rules
- [x] Self-review completado
- [x] Comentarios en código complejo
- [x] Documentación actualizada
- [x] Tests añadidos (si aplica)
- [x] CHANGELOG.md actualizado
- [x] MEMORY.md actualizado

## Testing

```bash
# Comandos para probar
docker-compose up -d
bash scripts/backup.sh
ls -la backups/
```

## Screenshots (si aplica)

N/A

## Notas Adicionales

Script usa tar.gz para compresión.
Retención configurable via ENV var.
```

### Reglas de PR

1. **Título** debe seguir conventional commits
2. **Descripción** clara y detallada
3. **NO** merge tu propio PR (si hay equipo)
4. **Squash merge** preferido para mantener historia limpia
5. **Delete branch** después de merge
6. **Reference issues** si aplica (#123)

### Review Checklist

Reviewer debe verificar:

- [ ] Código sigue cursor rules
- [ ] Tests pasan
- [ ] Documentación actualizada
- [ ] NO hay secrets hardcodeados
- [ ] Variables de entorno documentadas
- [ ] Dockerfile sigue best practices
- [ ] Shell scripts con error handling
- [ ] NO emojis en código

---

## Issues

### Template de Bug Report

```markdown
## Descripción del Bug

Descripción clara del problema.

## Reproducir

Pasos para reproducir:
1. Ejecutar `docker-compose up -d`
2. Esperar 5 minutos
3. Ver logs `docker-compose logs`
4. Error aparece

## Comportamiento Esperado

El servidor debería iniciar correctamente.

## Comportamiento Actual

El servidor se detiene con error de memoria.

## Entorno

- OS: Ubuntu 22.04
- Docker: 24.0.5
- Docker Compose: 2.20.2
- Versión DockerCraft: v0.2.0

## Logs

```bash
[ERROR] Out of memory
...
```

## Configuración

```bash
MEMORY=2G
MAX_PLAYERS=20
TYPE=PAPER
VERSION=1.21.1
```

## Capturas (opcional)

N/A

## Posible Solución

Incrementar MEMORY a 4G
```

### Template de Feature Request

```markdown
## Feature Request

Descripción clara de la feature.

## Motivación

Por qué es necesario?

## Solución Propuesta

Cómo se implementaría?

## Alternativas Consideradas

Otras formas de resolver esto?

## Contexto Adicional

Screenshots, ejemplos, referencias.

## Prioridad

- [ ] Crítico
- [x] Alta
- [ ] Media
- [ ] Baja
```

### Labels

- `bug` - Algo no funciona
- `enhancement` - Nueva feature
- `documentation` - Mejoras de docs
- `good first issue` - Bueno para nuevos
- `help wanted` - Necesita ayuda
- `priority: high` - Alta prioridad
- `priority: low` - Baja prioridad
- `wontfix` - No se implementará
- `duplicate` - Issue duplicado
- `sprint-1`, `sprint-2`, etc. - Sprint asociado

---

## Issues y PRs: Workflow Completo

### OBLIGATORIO: Crear Issues al Iniciar Sprint

**⚠️ ANTES de escribir código, crear TODOS los Issues del sprint en GitHub.**

#### Proceso de Inicio de Sprint

```bash
# 1. Sprint Planning completado
# - docs/sprints/SPRINT_XX.md creado
# - User Stories definidas con story points

# 2. Ir a GitHub Issues
# https://github.com/gastonfr24/dockercraft/issues/new

# 3. Crear UN Issue por cada User Story
# Usar template de Feature Request para nuevas features
# Usar template de Bug Report para fixes
```

#### Template de Issue desde User Story

**Para cada US en el sprint, crear Issue con:**

```markdown
Title: [US-XX] Nombre de la User Story

## User Story
Como [ROL]
Quiero [FEATURE]
Para [BENEFIT]

## Acceptance Criteria
- [ ] Criterio 1
- [ ] Criterio 2
- [ ] Criterio 3

## Tasks
- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

## Story Points
Estimación: X pts

## Sprint
Sprint X

## Definition of Done
- [ ] Código implementado y testeado
- [ ] Tests pasando
- [ ] Documentación actualizada
- [ ] Code review aprobado
- [ ] Merged a dev

## Labels
- enhancement (o bug)
- sprint-X
- priority-high/medium/low

## Assigned
@gastonfr24
```

#### Ejemplo Real: Sprint 2

Al iniciar Sprint 2, crear estos Issues:

```
✅ Issue #1: [US-08] Testing Local del Servidor
   Labels: enhancement, sprint-2, priority-high
   Story Points: 5

✅ Issue #2: [US-09] Automated Backup Script
   Labels: enhancement, sprint-2, priority-high
   Story Points: 8

✅ Issue #3: [US-10] CI/CD con GitHub Actions
   Labels: enhancement, sprint-2, priority-medium
   Story Points: 8

✅ Issue #4: [US-11] Script de Restore
   Labels: enhancement, sprint-2, priority-medium
   Story Points: 3

✅ Issue #5: [US-12] Performance Optimization
   Labels: enhancement, sprint-2, priority-low
   Story Points: 5

✅ Issue #6: [US-13] Troubleshooting Guide
   Labels: documentation, sprint-2, priority-low
   Story Points: 3
```

**Orden de creación:**

OPCIÓN A - AUTOMÁTICA (Recomendado):
```bash
# Crear rama de sprint
git checkout dev
git checkout -b sprint/3

# Push rama - esto triggerea automáticamente el workflow
git push origin sprint/3

# GitHub Actions creará automáticamente los 5 Issues
# Esperar 10 segundos y verificar en pestaña Issues
```

OPCIÓN B - MANUAL:
1. Ir a GitHub Issues
2. Click "New Issue"
3. Elegir template
4. Llenar TODOS los campos
5. Añadir labels
6. Asignar a persona
7. Create Issue
8. Repetir para CADA User Story

**⚠️ NO empezar a codear hasta que TODOS los Issues estén creados.**

### Vincular Issues en Sprint Doc

Después de crear los Issues, actualizar `docs/sprints/SPRINT_XX.md`:

```markdown
#### US-09: Automated Backup Script
**Issue:** #2
**Como** administrador
**Quiero** backups automáticos
**Para** no perder datos

**Prioridad:** Alta
**Estimación:** 8 puntos
**Rama:** `feature/backup-automation`
**Estado:** 🚧 In Progress
```

2. **Formato del Issue**:
   ```markdown
   Title: [US-XX] Nombre de la User Story
   
   ## User Story
   Como [ROL]
   Quiero [FEATURE]
   Para [BENEFIT]
   
   ## Acceptance Criteria
   - [ ] Criterio 1
   - [ ] Criterio 2
   
   ## Tasks
   - [ ] Task 1
   - [ ] Task 2
   
   ## Story Points
   Estimación: X pts
   
   ## Sprint
   Sprint 2
   
   ## Definition of Done
   - [ ] Código implementado
   - [ ] Tests pasando
   - [ ] Docs actualizadas
   - [ ] Code review aprobado
   ```

### Vincular PRs con Issues

**OBLIGATORIO**: Todo PR debe estar vinculado a un Issue.

**Métodos de vinculación:**

1. **En el título del PR**:
   ```
   feat(backup): implement automated backup script [#8]
   ```

2. **En la descripción del PR**:
   ```markdown
   ## Related Issues
   Closes #8
   Fixes #12
   Relates to #15
   ```

3. **En commits**:
   ```bash
   git commit -m "feat(backup): add backup script

   Implements automated backup with compression.
   
   Closes #8"
   ```

**Keywords que cierran issues automáticamente:**
- `Closes #X`
- `Fixes #X`
- `Resolves #X`
- `Closes: #X`

### Workflow: Issue → Branch → PR → Merge

```bash
# 1. Issue creado en GitHub: #8

# 2. Crear branch desde dev
git checkout dev
git pull origin dev
git checkout -b feature/backup-automation

# 3. Implementar y commit
git add .
git commit -m "feat(backup): implement backup script

Closes #8"

# 4. Push y crear PR
git push origin feature/backup-automation
# En GitHub: Create PR
# - Title: "feat(backup): implement automated backup [#8]"
# - Description: "Closes #8"
# - Base: dev (NO main)
# - Reviewers: asignar
# - Labels: enhancement, sprint-2

# 5. Code review y merge a dev
# PR aprobado → Merge to dev
# Issue #8 se cierra automáticamente

# 6. Testing en dev
# Validar que funciona

# 7. Release: dev → main
# Solo cuando sprint completo
```

### Reglas de Vinculación

1. **NUNCA** crear feature branch desde `main`
2. **SIEMPRE** crear desde `dev`
3. **SIEMPRE** vincular PR con Issue
4. **SIEMPRE** testear en `dev` antes de `main`
5. **NUNCA** mergear a `main` sin testing

### Checklist antes de crear PR

- [ ] Issue existe y está asignado
- [ ] Branch creada desde `dev`
- [ ] Commits siguen conventional commits
- [ ] Tests locales pasando
- [ ] PR title referencia el issue
- [ ] PR description tiene "Closes #X"
- [ ] Base branch es `dev` (NO main)
- [ ] Documentación actualizada

### Ejemplo Completo

**Issue #8:**
```
Title: [US-09] Automated Backup Script
Labels: enhancement, sprint-2, priority-high
Assigned: gastonfr24
```

**Branch:**
```bash
feature/backup-automation
```

**Commits:**
```
feat(backup): add backup.sh with compression

Implements automated backup system with configurable retention.

Relates to #8

feat(backup): add restore functionality

Adds ability to restore from backups.

Relates to #8

docs(backup): update README with backup instructions

Closes #8
```

**PR:**
```
Title: feat(backup): implement automated backup system [#8]
Base: dev ← feature/backup-automation
Description: 
Implements US-09 automated backup script.

Closes #8

Changes:
- Added backup.sh
- Added restore.sh
- Updated README
- Added tests
```

**Resultado:**
- PR merged to `dev` ✅
- Issue #8 closed automáticamente ✅
- Branch eliminada ✅
- Sprint tracking actualizado ✅

---

## Release Process

### Paso a Paso: dev → main

```bash
# 1. Asegurar que dev está listo
git checkout dev
git pull origin dev

# 2. TESTING COMPLETO EN DEV
# - Ejecutar test-server.sh
# - Validar todas las features del sprint
# - Verificar que no hay regresiones
bash scripts/test-server.sh all

# 3. Crear release branch desde dev
git checkout -b release/v0.3.0

# 4. Actualizar versión en archivos
# - docs/ai/09_CHANGELOG.md
# - docs/ai/04_MEMORY.md
# - README.md (badges, version)
# - docs/sprints/SPRINT_XX.md (marcar completado)

# 5. Commit de release
git add .
git commit -m "chore(release): prepare v0.3.0

Sprint 2 completed:
- Feature A
- Feature B
- Feature C"

# 6. Push release branch
git push origin release/v0.3.0

# 7. Crear PR: release/v0.3.0 → main
# En GitHub:
# - Title: "Release v0.3.0 - Sprint 2"
# - Base: main ← release/v0.3.0
# - Description: Copy from CHANGELOG
# - Reviewers: Revisar cambios
# - TESTING FINAL antes de aprobar

# 8. Merge a main
# Una vez aprobado
# GitHub: Merge PR (squash o merge commit)

# 9. Tag en main
git checkout main
git pull origin main
git tag -a v0.3.0 -m "Release v0.3.0 - Sprint 2 Complete

Features:
- Automated backup
- CI/CD pipeline
- Performance improvements"
git push origin v0.3.0

# 10. Merge back to dev (important!)
git checkout dev
git merge main
git push origin dev

# 11. GitHub Release
# - Ir a GitHub → Releases → Draft new release
# - Choose tag: v0.3.0
# - Title: DockerCraft v0.3.0 - Sprint 2
# - Description: Copy from CHANGELOG
# - Publish release

# 12. Cleanup
git branch -d release/v0.3.0
git push origin --delete release/v0.3.0
```

### Pre-Release Checklist

**ANTES de crear release branch:**

- [ ] Todas las user stories del sprint completadas
- [ ] Todos los PRs merged a `dev`
- [ ] Testing completo en `dev`
- [ ] No hay bugs críticos
- [ ] Documentación actualizada
- [ ] CHANGELOG actualizado
- [ ] Tests automatizados pasando

**ANTES de merge a main:**

- [ ] Code review completo
- [ ] Testing en `dev` exitoso
- [ ] No hay conflictos
- [ ] Version numbers actualizados
- [ ] Release notes preparadas

### Hotfix Process (Urgente en Producción)

```bash
# 1. Hotfix desde main
git checkout main
git pull origin main
git checkout -b hotfix/critical-bug

# 2. Fix el problema
git add .
git commit -m "fix(critical): resolve memory leak

Fixes #X"

# 3. Testing rápido
# Validar que el fix funciona

# 4. PR a main
git push origin hotfix/critical-bug
# GitHub PR: hotfix/critical-bug → main

# 5. Merge a main
# Merge PR

# 6. Tag patch version
git checkout main
git pull
git tag -a v0.3.1 -m "Hotfix v0.3.1 - Critical bug fix"
git push origin v0.3.1

# 7. Merge a dev también!
git checkout dev
git merge main
git push origin dev

# 8. Cleanup
git branch -d hotfix/critical-bug
git push origin --delete hotfix/critical-bug
```

### Actualizar CHANGELOG

Formato:

```markdown
## [0.3.0] - 2025-10-25

### Added
- feat(scripts): automated backup system
- feat(docker): multi-stage build

### Changed
- refactor(dockerfile): optimize layer caching

### Fixed
- fix(scripts): health check timeout handling
- fix(docker): RCON connection issues

### Security
- chore(deps): update base image (security patches)
```

### GitHub Release Notes

```markdown
# DockerCraft v0.3.0

## Highlights

- Automated backup system
- Multi-stage Docker build (50% smaller image)
- Improved health checks
- Performance optimizations

## Added

- Automated backup script with configurable retention
- Multi-stage Dockerfile for smaller images
- New environment variables: BACKUP_ENABLED, BACKUP_INTERVAL

## Changed

- Refactored health check for better reliability
- Optimized Dockerfile layer caching

## Fixed

- Fixed RCON connection timeout issues
- Fixed health check false positives

## Security

- Updated base image to java21 (includes security patches)

## Breaking Changes

None

## Migration Guide

No migration needed. Update your image:

```bash
docker-compose pull
docker-compose up -d
```

## Full Changelog

See [CHANGELOG.md](docs/ai/09_CHANGELOG.md)

## Docker Image

```bash
docker pull ghcr.io/gastonfr24/dockercraft:v0.3.0
docker pull ghcr.io/gastonfr24/dockercraft:latest
```
```

---

## Ejemplos Prácticos

### Caso 1: Nueva Feature

```bash
# 1. Crear rama
git checkout main
git pull
git checkout -b feature/add-whitelist-support

# 2. Implementar feature
vim Dockerfile
vim docker-compose.yml
vim .env.example

# 3. Commits atómicos
git add Dockerfile
git commit -m "feat(docker): add whitelist environment variables"

git add docker-compose.yml
git commit -m "feat(docker): add whitelist example in compose"

git add .env.example
git commit -m "docs(config): document whitelist variables"

# 4. Push y PR
git push origin feature/add-whitelist-support
# Crear PR en GitHub

# 5. Después de merge
git checkout main
git pull
git branch -d feature/add-whitelist-support
```

### Caso 2: Bug Fix Urgente

```bash
# 1. Hotfix branch
git checkout main
git pull
git checkout -b hotfix/memory-leak

# 2. Fix
vim Dockerfile
git add Dockerfile
git commit -m "fix(docker): resolve memory leak in auto-pause"

# 3. Update docs
vim docs/ai/09_CHANGELOG.md
git add docs/ai/09_CHANGELOG.md
git commit -m "docs(changelog): add memory leak fix"

# 4. Push y PR urgente
git push origin hotfix/memory-leak
# Crear PR con label "priority: high"

# 5. Fast-track merge y tag
# Merge PR
git checkout main
git pull
git tag -a v0.2.1 -m "Hotfix: memory leak"
git push origin v0.2.1
```

### Caso 3: Update de Documentación

```bash
# 1. Docs branch
git checkout main
git pull
git checkout -b docs/improve-quick-start

# 2. Update docs
vim README.md
vim docs/ai/08_QUICK_START.md

# 3. Commit
git add README.md docs/ai/08_QUICK_START.md
git commit -m "docs(readme): improve quick start guide with examples"

# 4. Push y PR
git push origin docs/improve-quick-start
# PR simple, no requiere extensive review
```

---

## Comandos Útiles

```bash
# Ver ramas
git branch -a

# Limpiar ramas locales borradas en remote
git fetch --prune
git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -D

# Ver commits desde última tag
git log $(git describe --tags --abbrev=0)..HEAD --oneline

# Generar CHANGELOG automático
git log v0.2.0..HEAD --pretty=format:"- %s" --no-merges

# Ver tags
git tag -l

# Delete tag (si te equivocaste)
git tag -d v0.2.0
git push origin :refs/tags/v0.2.0

# Revert commit (crear nuevo commit que revierte)
git revert <commit-hash>

# Ver quién modificó una línea
git blame Dockerfile

# Ver historia de un archivo
git log --follow -- Dockerfile
```

---

## Reglas PROHIBIDAS

### NUNCA Hacer Esto

```bash
# Force push a main
git push --force origin main           # PROHIBIDO

# Push directo a main
git push origin main                   # PROHIBIDO (usar PR)

# Skip hooks
git commit --no-verify                 # PROHIBIDO

# Commits sin mensaje
git commit -m "fix"                    # PROHIBIDO (muy vago)

# Reescribir historia pública
git rebase -i HEAD~5                   # PELIGROSO en ramas compartidas
git push --force                       # PROHIBIDO

# Delete branches sin merge
git branch -D feature/important        # Verificar primero

# Commit secrets
git add .env                           # PROHIBIDO (usar .env.example)
```

### Permitido SOLO con Precaución

```bash
# Force push en TU rama de feature (no compartida)
git push --force origin feature/my-branch  # OK si es SOLO tuya

# Rebase de tu rama local
git rebase main                        # OK antes de merge

# Amend último commit (solo si NO pusheaste)
git commit --amend                     # OK si NO está en remote
```

---

## Configuración Git Recomendada

```bash
# Usuario (YA CONFIGURADO)
git config user.name "gastonfr24"
git config user.email "gastonfr24@gmail.com"

# Editor
git config core.editor "code --wait"

# Default branch
git config init.defaultBranch main

# Auto-fetch
git config fetch.prune true

# Pretty logs
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Ver log bonito
git lg
```

---

## Referencias

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [GitHub Flow](https://guides.github.com/introduction/flow/)
- [GitFlow](https://nvie.com/posts/a-successful-git-branching-model/)
- [Keep a Changelog](https://keepachangelog.com/)

---

**Versión:** 1.0.0  
**Última actualización:** 2025-10-24  
**Mantenedor:** gastonfr24

