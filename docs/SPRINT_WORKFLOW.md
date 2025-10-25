# Sprint Workflow Guide - DockerCraft

Guía completa del workflow de Sprint automatizado.

---

## 🚀 Inicio de Sprint (Automatizado)

### Paso 1: Planificar Sprint

Antes de iniciar, definir:

**Ejemplo Sprint 4:**
```json
[
  {
    "id": "US-19",
    "name": "WebSocket Real-time Updates",
    "points": 8,
    "tasks": ["server-setup", "client-integration", "docs", "tests"]
  },
  {
    "id": "US-20",
    "name": "Metrics Dashboard",
    "points": 5,
    "tasks": ["metrics-collection", "dashboard-ui", "docs"]
  }
]
```

### Paso 2: Ejecutar Sprint Initialization

**Opción A: GitHub UI (Recomendado)**
1. Ir a: https://github.com/gastonfr24/dockercraft/actions
2. Click en "Sprint Initialization"
3. Click en "Run workflow"
4. Ingresar:
   - Sprint number: `4`
   - User Stories JSON: (copiar JSON de arriba)
5. Click "Run workflow"

**Opción B: GitHub CLI**
```bash
gh workflow run sprint-init.yml \
  -f sprint_number=4 \
  -f user_stories='[{"id":"US-19","tasks":["server-setup","client-integration","docs","tests"]},{"id":"US-20","tasks":["metrics-collection","dashboard-ui","docs"]}]'
```

### Paso 3: Resultado Automático

El workflow crea automáticamente:

```
✅ sprint/4                           (rama principal del sprint)
✅ task/us19-server-setup             → Issue #X auto-creado
✅ task/us19-client-integration       → Issue #Y auto-creado
✅ task/us19-docs                     → Issue #Z auto-creado
✅ task/us19-tests                    → Issue #W auto-creado
✅ task/us20-metrics-collection       → Issue #A auto-creado
✅ task/us20-dashboard-ui             → Issue #B auto-creado
✅ task/us20-docs                     → Issue #C auto-creado
```

**Total:** 1 rama de sprint + 7 ramas de tareas + 7 Issues

---

## 💻 Desarrollo de Tareas

### Ciclo por Tarea

#### 1. Checkout a Tarea
```bash
git fetch origin
git checkout task/us19-server-setup
```

#### 2. Desarrollar
```bash
# Hacer cambios
vim server.js

# Commit (Conventional Commits)
git commit -m "feat(us19): implement WebSocket server"

# Push
git push origin task/us19-server-setup
```

#### 3. Crear Pull Request

**Automático (Recomendado):**
```bash
.\scripts\create-prs.ps1
```

**Manual:**
```bash
gh pr create \
  --base sprint/4 \
  --head task/us19-server-setup \
  --title "feat(us19): implement WebSocket server setup" \
  --body "Closes #X

Implements WebSocket server for real-time updates.

## Changes
- Added socket.io server
- Configured connection handling
- Added error handling

## Testing
- Manual testing with client
- Unit tests for handlers"
```

#### 4. Merge (Automático)

Una vez:
- ✅ CI/CD pasa
- ✅ Review aprobado (si requerido)

GitHub auto-mergea a `sprint/4` y cierra Issue automáticamente.

---

## 🔄 Repetir para Cada Tarea

Continuar con siguiente tarea:
```bash
git checkout task/us19-client-integration
# Desarrollar...
# PR...
# Merge...
```

---

## ✅ Finalización de Sprint

### Cuando Todas las Tareas Completas

```bash
# Verificar todas las tareas mergeadas
git checkout sprint/4
git pull origin sprint/4

# Ver log para verificar
git log --oneline --graph

# Merge a dev
git checkout dev
git pull origin dev
git merge sprint/4 --no-ff -m "Merge Sprint 4: WebSocket & Metrics

Completed User Stories:
- US-19: WebSocket Real-time Updates (8pts)
- US-20: Metrics Dashboard (5pts)

Total: 13 story points

All tasks completed and tested."

git push origin dev
```

---

## 🚀 Release a Producción

### 1. Testing en Dev

```bash
git checkout dev

# Ejecutar tests completos
npm test  # o equivalente

# Testing manual
docker-compose up -d
# Probar funcionalidad...
```

### 2. Crear Release Branch

```bash
git checkout -b release/v0.5.0

# Actualizar changelog
vim docs/ai/09_CHANGELOG.md

# Bump version
vim package.json  # o archivo de versión

git commit -m "chore(release): prepare v0.5.0"
git push origin release/v0.5.0
```

### 3. Pull Request Dev → Main

```bash
gh pr create \
  --base main \
  --head dev \
  --title "Release v0.5.0 - Sprint 4: WebSocket & Metrics" \
  --body "Closes #[sprint-tracking-issue]

## Sprint 4 Summary

**Story Points:** 13/13 completed (100%)

**User Stories Completed:**
- US-19: WebSocket Real-time Updates (8pts)
- US-20: Metrics Dashboard (5pts)

**Highlights:**
- Real-time server updates via WebSocket
- Comprehensive metrics dashboard
- Full test coverage
- Updated documentation

**Breaking Changes:** None

**Migration Required:** None

## Testing
- [x] All automated tests passing
- [x] Manual testing completed
- [x] Documentation reviewed
- [x] Performance validated

## Checklist
- [x] CHANGELOG.md updated
- [x] Version bumped
- [x] All Issues closed
- [x] Documentation complete
- [x] CI/CD passing"
```

### 4. Esperar Aprobación

**CRÍTICO:** Este PR requiere aprobación manual del owner.

El owner debe verificar:
- [ ] CI/CD passing
- [ ] Todos los Issues cerrados
- [ ] Documentación actualizada
- [ ] No hay breaking changes no documentados
- [ ] Tests completos

### 5. Merge Manual

**Después de aprobación:**

```bash
git checkout main
git pull origin main
git merge dev --no-ff -m "Release v0.5.0 - Sprint 4"
git tag -a v0.5.0 -m "Release v0.5.0 - Sprint 4: WebSocket & Metrics"
git push origin main
git push origin v0.5.0
```

### 6. Merge Back a Dev

```bash
git checkout dev
git merge main --no-ff -m "Merge back main to dev after v0.5.0"
git push origin dev
```

---

## 📊 Diagrama de Flujo

```
┌─────────────────────────────────────────────────────────┐
│ INICIO: Sprint Planning                                 │
│ - Definir User Stories                                  │
│ - Definir Tareas por US                                 │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│ AUTOMATICO: GitHub Actions Sprint Init                  │
│ - Crea sprint/X                                         │
│ - Crea task/usXX-nombre (todas las tareas)             │
│ - Issues auto-creados                                   │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│ DESARROLLO: Para cada tarea                             │
│ 1. git checkout task/usXX-nombre                        │
│ 2. Desarrollar y commit                                 │
│ 3. git push                                             │
│ 4. Crear PR a sprint/X                                  │
│ 5. Auto-merge → Issue cierra                            │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│ FINALIZACION: Todas tareas completas                    │
│ - git merge sprint/X --no-ff → dev                      │
│ - Testing en dev                                        │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│ RELEASE: PR dev → main                                  │
│ - Crear PR                                              │
│ - CI/CD ejecuta                                         │
│ - ESPERAR APROBACION MANUAL ⚠️                          │
│ - Merge manual                                          │
│ - Tag version                                           │
│ - Merge back a dev                                      │
└─────────────────────────────────────────────────────────┘
```

---

## 🔒 Restricciones y Validaciones

### Automáticas (GitHub Actions)

✅ **Al crear PR a `main`:**
- Verifica source es `dev` o `release/*`
- Verifica Issue vinculado
- Bloquea auto-merge
- Requiere CI/CD passing

✅ **Al crear PR a `dev`:**
- Verifica source es `task/*`, `feature/*`, `bugfix/*`, `hotfix/*`, o `sprint/*`
- Recomienda Issue vinculado
- Permite auto-merge

✅ **Al crear task branch:**
- Issue se crea automáticamente
- Labels se asignan
- Assignee se configura

### Manuales (GitHub Settings)

Configurar en GitHub → Settings → Branches:

**main:**
- Require pull request: ✅
- Require approvals: 1
- Require status checks: ✅
- Do not allow force push: ✅
- Do not allow deletions: ✅

**dev:**
- Require pull request: ✅
- Require status checks: ✅
- Allow force push: ❌

---

## 🆘 Troubleshooting

### Problema: Issues no se crearon

**Causa:** Workflow auto-issue-from-branch.yml no se ejecutó

**Solución:**
```bash
# Verificar que el workflow existe
ls .github/workflows/auto-issue-from-branch.yml

# Forzar creación manual
gh issue create \
  --title "[Task] US-19 server setup" \
  --body "Auto-created for task/us19-server-setup" \
  --label "us-19,sprint-4,task"
```

### Problema: No puedo hacer PR a main

**Causa:** Solo `dev` o `release/*` permitidos

**Solución:** 
1. Merge tu branch a `dev` primero
2. Luego crear PR de `dev` a `main`

### Problema: PR bloqueado, requiere aprobación

**Esperado:** PRs a `main` SIEMPRE requieren aprobación manual

**Acción:** Contactar al owner para review y aprobación

---

## 📚 Scripts Útiles

### Crear todos los PRs de un Sprint
```bash
.\scripts\create-prs.ps1
```

### Ver estado del Sprint
```bash
gh issue list --label "sprint-4" --state all
```

### Ver PRs pendientes
```bash
gh pr list --base sprint/4
```

---

## 📖 Referencias

- **Workflow Estricto:** `.cursor/rules/workflow-strict.md`
- **Git Rules:** `.cursor/rules/git.md`
- **Cursor Workflow:** `.cursor/rules/workflow.md`

---

**Última actualización:** 2025-10-24  
**Versión:** 3.0

