# Workflow Estricto - DockerCraft

## 🔒 REGLAS OBLIGATORIAS - NO NEGOCIABLES

Este documento define el workflow **ESTRICTO** que DEBE seguirse en todo momento.

---

## 📋 Flujo Completo del Sprint

### Fase 1: Inicio de Sprint

#### 1.1 Planificación (Manual)

Antes de iniciar el sprint, definir:
- User Stories del sprint
- Tareas por cada User Story
- Story points
- Prioridades

**Formato requerido:**
```json
[
  {
    "id": "US-19",
    "tasks": ["dockerfile", "compose", "docs", "tests"]
  },
  {
    "id": "US-20",
    "tasks": ["api-integration", "docs"]
  }
]
```

#### 1.2 Inicialización Automática

**Comando:**
```bash
# Via GitHub Actions (Manual Workflow Dispatch)
# En GitHub: Actions → Sprint Initialization → Run workflow
# Input: Sprint number (e.g., 4)
# Input: User Stories JSON
```

**Resultado Automático:**
1. ✅ Crea rama `sprint/X`
2. ✅ Crea ramas `task/usXX-nombre` para cada tarea
3. ✅ Push de todas las ramas → Triggers auto-create de Issues

**PROHIBIDO:** Crear ramas manualmente para tareas de sprint

---

### Fase 2: Desarrollo de Tareas

#### 2.1 Trabajar en Tarea

```bash
# Checkout a rama de tarea (ya existe)
git checkout task/us19-dockerfile

# Hacer cambios
vim Dockerfile

# Commits frecuentes con Conventional Commits
git commit -m "feat(us19): add VERSION variable support"

# Push (triggerea validaciones automáticas)
git push origin task/us19-dockerfile
```

**REGLAS:**
- ✅ SOLO trabajar en ramas `task/*`
- ✅ Commits DEBEN seguir Conventional Commits
- ✅ Push frecuente (al menos 1 vez al día)
- ❌ NO hacer cambios directamente en `sprint/X`

#### 2.2 Crear Pull Request a Sprint

```bash
# Opción A: Via script automatizado
.\scripts\create-prs.ps1

# Opción B: Manual
gh pr create \
  --base sprint/4 \
  --head task/us19-dockerfile \
  --title "feat(us19): add VERSION variable support" \
  --body "Closes #42

Implements Dockerfile support for VERSION variable.

## Changes
- Added VERSION arg
- Updated documentation

## Testing
- Tested with 1.20.4, LATEST"
```

**REGLAS OBLIGATORIAS:**
- ✅ Base DEBE ser `sprint/X` (NO `dev`, NO `main`)
- ✅ DEBE incluir `Closes #X` en body
- ✅ Título DEBE seguir Conventional Commits
- ❌ NO crear PR sin Issue vinculado

#### 2.3 Code Review y Merge

**Proceso:**
1. CI/CD ejecuta (linting, tests)
2. Validaciones automáticas pasan
3. Code review (si es necesario)
4. **Auto-merge permitido** a `sprint/X`
5. Issue se cierra automáticamente

**PROHIBIDO:**
- ❌ Mergear sin CI passing
- ❌ Mergear con merge conflicts
- ❌ Skip CI checks

---

### Fase 3: Finalización de Sprint

#### 3.1 Merge Sprint → Dev

**Cuando:**
- ✅ Todas las tareas completadas
- ✅ Todos los Issues cerrados
- ✅ Testing de integración pasado

**Comando:**
```bash
git checkout dev
git merge sprint/4 --no-ff -m "Merge Sprint 4: [descripción]"
git push origin dev
```

**REGLAS:**
- ✅ DEBE usar `--no-ff` (merge commit obligatorio)
- ✅ Mensaje descriptivo del sprint
- ❌ NO squash commits
- ❌ NO rebase (preservar historia)

#### 3.2 Testing en Dev

**OBLIGATORIO:**
- Ejecutar suite completa de tests
- Validar funcionalidad end-to-end
- Revisar documentación actualizada

---

### Fase 4: Release a Producción

#### 4.1 Crear Release Branch

```bash
git checkout dev
git checkout -b release/vX.Y.0
```

**En esta rama:**
- Actualizar `CHANGELOG.md`
- Bump version numbers
- Final QA

#### 4.2 Pull Request Dev → Main

**ESTE ES EL PASO MÁS CRÍTICO**

```bash
gh pr create \
  --base main \
  --head dev \
  --title "Release vX.Y.0 - Sprint X" \
  --body "Closes #[sprint-issue]

## Sprint X Summary

**Story Points:** XX/XX completed

**User Stories:**
- US-XX: Description (Xpts)
- US-YY: Description (Xpts)

**Breaking Changes:** None

**Migration:** None required"
```

**REGLAS ESTRICTAS:**
- ✅ SOLO `dev` o `release/*` pueden hacer PR a `main`
- ✅ DEBE vincular Issue de sprint
- ✅ DEBE tener aprobación manual del owner
- ✅ CI/CD DEBE pasar al 100%
- ❌ Auto-merge PROHIBIDO en main
- ❌ Direct push a main PROHIBIDO

#### 4.3 Aprobación y Merge

**Checklist antes de aprobar:**
- [ ] Todas las User Stories completadas
- [ ] CI/CD passing
- [ ] Documentación actualizada
- [ ] CHANGELOG.md actualizado
- [ ] Tests passing
- [ ] No breaking changes no documentados

**Merge:**
```bash
# Después de aprobación manual
git checkout main
git merge dev --no-ff -m "Release vX.Y.0"
git tag -a vX.Y.0 -m "Release vX.Y.0"
git push origin main
git push origin vX.Y.0
```

#### 4.4 Merge Back

```bash
git checkout dev
git merge main --no-ff -m "Merge back main to dev after vX.Y.0"
git push origin dev
```

---

## 🚫 Prohibiciones Absolutas

### Nunca, Jamás, Bajo Ninguna Circunstancia:

1. ❌ **Push directo a `main`** sin PR
2. ❌ **Skip CI checks** (--no-verify)
3. ❌ **Force push a `main` o `dev`**
4. ❌ **Delete tags** de releases
5. ❌ **Modificar historia** en `main` (rebase, rewrite)
6. ❌ **Crear PR a `main`** desde `feature/*` o `task/*`
7. ❌ **Merge sin Issue vinculado** (excepto hotfixes críticos)
8. ❌ **Auto-merge a `main`** (requiere aprobación humana)

---

## ✅ Validaciones Automáticas

### Al Crear Branch `task/*`:
- ✅ Issue se crea automáticamente
- ✅ Labels se asignan
- ✅ Assignee se configura

### Al Crear PR:
- ✅ Verifica base branch correcto
- ✅ Verifica `Closes #X` presente
- ✅ Verifica Conventional Commits
- ✅ Copia labels de Issue
- ✅ CI/CD ejecuta

### Al Mergear PR a `sprint/X`:
- ✅ Issue se cierra automáticamente
- ✅ Branch se puede borrar (opcional)

### Al Crear PR `dev → main`:
- ✅ Verifica source es `dev` o `release/*`
- ✅ Verifica Issue vinculado
- ✅ Requiere aprobación manual
- ✅ CI/CD debe pasar
- ❌ Auto-merge bloqueado

---

## 📊 Estructura de Ramas

```
main (producción)
  ↑
  └─ dev (integración)
      ↑
      ├─ sprint/4
      │   ↑
      │   ├─ task/us19-dockerfile
      │   ├─ task/us19-compose
      │   ├─ task/us19-docs
      │   ├─ task/us20-api-integration
      │   └─ task/us20-docs
      │
      ├─ feature/large-feature (excepciones)
      ├─ bugfix/fix-something
      └─ hotfix/critical-fix
```

**Reglas:**
- `main`: Solo releases, protegido
- `dev`: Integración, semi-protegido
- `sprint/X`: Trabajo de sprint
- `task/*`: Tareas individuales
- `feature/*`: Features grandes (raras)
- `bugfix/*`: Bug fixes
- `hotfix/*`: Hotfixes urgentes a main

---

## 🔧 Configuración Requerida

### Branch Protection Rules (GitHub)

#### Main:
- ✅ Require pull request before merging
- ✅ Require approvals: 1
- ✅ Require status checks to pass
- ✅ Require branches to be up to date
- ✅ Do not allow bypassing
- ❌ Allow force pushes: NO
- ❌ Allow deletions: NO

#### Dev:
- ✅ Require pull request before merging
- ✅ Require status checks to pass
- ⚠️ Require approvals: 0 (opcional)
- ❌ Allow force pushes: NO

---

## 📚 Comandos Rápidos

### Iniciar Sprint
```bash
# Via GitHub Actions UI
# Actions → Sprint Initialization → Run workflow
```

### Trabajar en Tarea
```bash
git checkout task/usXX-nombre
git commit -m "feat(usXX): description"
git push
```

### Crear PRs
```bash
.\scripts\create-prs.ps1
```

### Finalizar Sprint
```bash
git checkout dev
git merge sprint/X --no-ff
git push origin dev
```

### Release
```bash
# Crear PR dev → main (requiere aprobación)
gh pr create --base main --head dev --title "Release vX.Y.0"
# Esperar aprobación y CI
# Merge manual después de aprobación
```

---

## 🆘 Emergencias y Excepciones

### Hotfix Crítico a Main

**Único caso permitido para PR directo a main sin pasar por dev:**

```bash
git checkout main
git checkout -b hotfix/critical-security-fix
# Fix crítico
git commit -m "fix(security): patch vulnerability"
git push origin hotfix/critical-security-fix

# PR a main (requiere aprobación inmediata)
gh pr create --base main --head hotfix/critical-security-fix

# Después de merge a main, también a dev
git checkout dev
git cherry-pick <commit-hash>
git push origin dev
```

---

## 📖 Referencias

- **Conventional Commits:** https://www.conventionalcommits.org/
- **Git Flow:** https://nvie.com/posts/a-successful-git-branching-model/
- **GitHub Flow:** https://docs.github.com/en/get-started/quickstart/github-flow

---

**ESTA ES LA LEY. NO HAY NEGOCIACIÓN.**

Cualquier violación de estas reglas debe ser justificada por escrito y aprobada por el owner del proyecto.

---

**Última actualización:** 2025-10-24  
**Versión:** 3.0 (Estricto)  
**Estado:** OBLIGATORIO

