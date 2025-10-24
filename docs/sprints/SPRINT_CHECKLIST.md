# Sprint Checklist - DockerCraft

Checklist obligatorio para cada sprint.

---

## 📋 Al INICIAR Sprint

### 1. Sprint Planning

- [ ] Sprint goal definido
- [ ] User Stories seleccionadas del backlog
- [ ] Story points estimados
- [ ] Prioridades asignadas
- [ ] Definition of Done revisada

### 2. Crear Documento de Sprint

- [ ] Copiar `SPRINT_TEMPLATE.md` a `SPRINT_XX.md`
- [ ] Llenar toda la información:
  - [ ] Duración y objetivo
  - [ ] User Stories con detalles
  - [ ] Acceptance criteria
  - [ ] Tasks por US
  - [ ] Story points totales
- [ ] Commit y push del documento

### 3. ⚠️ CREAR TODOS LOS ISSUES EN GITHUB

**ANTES de escribir código:**

```bash
# Para CADA User Story del sprint:

1. Ir a: https://github.com/gastonfr24/dockercraft/issues/new
2. Elegir template (Feature Request o Bug Report)
3. Llenar Issue:
   - Title: [US-XX] Nombre
   - User Story completa
   - Acceptance Criteria
   - Tasks
   - Story Points
   - Sprint number
   - Definition of Done
4. Añadir Labels:
   - enhancement / bug / documentation
   - sprint-X
   - priority-high / medium / low
5. Asignar a persona responsable
6. Create Issue
7. Anotar número de Issue (#X)
```

**Checklist de Issues creados:**

- [ ] Issue para US-1 (#X)
- [ ] Issue para US-2 (#X)
- [ ] Issue para US-3 (#X)
- [ ] Issue para US-4 (#X)
- [ ] Issue para US-5 (#X)
- [ ] Issue para US-6 (#X)

### 4. Actualizar Sprint Doc con Issue Numbers

En `docs/sprints/SPRINT_XX.md`, añadir número de Issue a cada US:

```markdown
#### US-09: Automated Backup Script
**Issue:** #2  👈 AÑADIR ESTO
**Como** administrador
...
```

- [ ] Todos los US tienen Issue# vinculado
- [ ] Commit y push actualización

### 5. Verificar Estado Inicial

- [ ] Todos los Issues abiertos en GitHub
- [ ] Sprint doc actualizado con Issue#
- [ ] Branch `dev` está actualizada
- [ ] Ready to start coding

---

## 💻 Durante el Sprint

### Para CADA User Story:

#### Crear Feature Branch

```bash
git checkout dev
git pull origin dev
git checkout -b feature/nombre
```

- [ ] Branch creada desde `dev`
- [ ] Nombre descriptivo

#### Desarrollo

- [ ] Implementar código
- [ ] Commits frecuentes
- [ ] Mensajes conventional commits
- [ ] Vincular con Issue: "Relates to #X"

#### Testing Local

- [ ] Código funciona localmente
- [ ] Tests manuales realizados
- [ ] No hay errores obvios

#### Push y PR

```bash
git push origin feature/nombre
```

En GitHub:
- [ ] Create Pull Request
- [ ] Title: `feat(scope): description [#X]`
- [ ] Base: `dev` (NO main)
- [ ] Description: `Closes #X`
- [ ] Labels: enhancement, sprint-X
- [ ] Reviewers asignados (si hay equipo)

#### Code Review

- [ ] Self-review completado
- [ ] Code review por otro (si hay equipo)
- [ ] CI pasando (cuando esté implementado)
- [ ] Comentarios resueltos

#### Merge

- [ ] Merge to `dev`
- [ ] Issue se cierra automáticamente
- [ ] Branch eliminada (local y remota)

---

## 🧪 Al FINALIZAR Sprint (ANTES de Release)

### 1. Verificar Completitud

- [ ] Todas las US completadas
- [ ] Todos los Issues cerrados
- [ ] Todos los PRs merged a `dev`
- [ ] No hay branches colgadas

### 2. Testing Completo en Dev

```bash
git checkout dev
git pull origin dev

# Testing exhaustivo
bash scripts/test-server.sh all

# Validar todas las features
# - Feature A funciona
# - Feature B funciona
# - Feature C funciona

# Verificar no hay regresiones
# - Features antiguas siguen funcionando
```

- [ ] `test-server.sh` pasa todos los tests
- [ ] Testing manual de nuevas features
- [ ] Testing de regresión
- [ ] No hay bugs críticos
- [ ] Performance aceptable

### 3. Actualizar Documentación

- [ ] `docs/ai/09_CHANGELOG.md` actualizado
- [ ] `docs/ai/04_MEMORY.md` actualizado
- [ ] `README.md` actualizado (si cambió interfaz)
- [ ] `docs/sprints/SPRINT_XX.md` marcado como completado

### 4. Preparar Release

- [ ] Version number decidido (semver)
- [ ] Release notes preparadas
- [ ] Breaking changes documentados
- [ ] Migration guide (si aplica)

---

## 🚀 Release a Producción

### 1. Crear Release Branch

```bash
git checkout dev
git pull origin dev
git checkout -b release/vX.X.X
```

- [ ] Release branch creada desde `dev`

### 2. Actualizar Versiones

Archivos a actualizar:
- [ ] `docs/ai/09_CHANGELOG.md` - Mover de Unreleased a version
- [ ] `docs/ai/04_MEMORY.md` - Añadir sprint completado
- [ ] `docs/sprints/SPRINT_XX.md` - Marcar como completado
- [ ] `README.md` - Actualizar badges/version (si aplica)

### 3. Commit de Release

```bash
git add .
git commit -m "chore(release): prepare vX.X.X

Sprint X completed:
- Feature A
- Feature B  
- Feature C"
```

- [ ] Commit de release creado

### 4. Push y PR a Main

```bash
git push origin release/vX.X.X
```

En GitHub:
- [ ] Create Pull Request
- [ ] Title: `Release vX.X.X - Sprint X`
- [ ] Base: `main` ← release/vX.X.X
- [ ] Description: Copy from CHANGELOG
- [ ] Label: release

### 5. Testing Final

**⚠️ CRÍTICO: Testing en rama release antes de merge**

- [ ] Checkout release branch localmente
- [ ] Testing completo nuevamente
- [ ] Verificar versiones actualizadas
- [ ] No hay typos en docs

### 6. Merge a Main

- [ ] PR reviewed
- [ ] Merge PR to `main`
- [ ] Verify merge successful

### 7. Tag Version

```bash
git checkout main
git pull origin main
git tag -a vX.X.X -m "Release vX.X.X - Sprint X Complete

Features:
- Feature A
- Feature B
- Feature C"
git push origin vX.X.X
```

- [ ] Tag creado
- [ ] Tag pushed

### 8. Merge Back to Dev

```bash
git checkout dev
git merge main
git push origin dev
```

- [ ] Changes merged back to dev
- [ ] Dev está sincronizada con main

### 9. GitHub Release

En GitHub → Releases:
- [ ] Draft new release
- [ ] Choose tag: vX.X.X
- [ ] Title: DockerCraft vX.X.X - Sprint X
- [ ] Description: Copy from CHANGELOG
- [ ] Publish release

### 10. Cleanup

```bash
git branch -d release/vX.X.X
git push origin --delete release/vX.X.X
```

- [ ] Release branch eliminada
- [ ] Workspace limpio

---

## 🎉 Post-Release

### 1. Sprint Review

- [ ] Demo de features completadas
- [ ] Feedback recolectado
- [ ] Documentar en sprint doc

### 2. Sprint Retrospective

En `docs/sprints/SPRINT_XX.md`:

- [ ] What went well
- [ ] What could improve
- [ ] Action items para siguiente sprint

### 3. Planificar Siguiente Sprint

- [ ] Backlog grooming
- [ ] Seleccionar User Stories
- [ ] Estimar story points
- [ ] Crear `SPRINT_XX+1.md`
- [ ] **CREAR TODOS LOS ISSUES** 👈 IMPORTANTE

---

## ⚠️ Errores Comunes a Evitar

### ❌ NO HACER:

1. ❌ Empezar a codear sin crear Issues
2. ❌ Crear branches desde `main` en vez de `dev`
3. ❌ Mergear a `main` sin testing en `dev`
4. ❌ PRs sin vincular con Issues
5. ❌ Olvidar actualizar documentación
6. ❌ Release sin testing completo
7. ❌ Olvidar merge back de main a dev
8. ❌ Force push a ramas protegidas

### ✅ SIEMPRE:

1. ✅ Crear Issues ANTES de codear
2. ✅ Features desde `dev`
3. ✅ Testing en `dev` antes de `main`
4. ✅ PRs vinculados con Issues
5. ✅ Documentación actualizada
6. ✅ Testing completo antes de release
7. ✅ Merge back después de release
8. ✅ Conventional commits

---

**Última actualización:** 2025-10-24

