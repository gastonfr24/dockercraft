# Reglas de Aprobación - DockerCraft

Documento que define claramente quién puede aprobar qué en el proyecto.

---

## 👤 Roles y Permisos

### Owner / Maintainer
- **Usuario:** @gastonfr24
- **Permisos:** TODOS

### Desarrolladores
- **Permisos:** Limitados según branch

---

## 🔐 Matriz de Aprobaciones

| Acción | Branch Origen | Branch Destino | Quién Aprueba | Auto-merge | Notas |
|--------|---------------|----------------|---------------|------------|-------|
| **PR task → sprint** | `task/*` | `sprint/X` | Cualquier dev | ✅ Sí | Sin aprobación requerida |
| **PR feature → dev** | `feature/*` | `dev` | Cualquier dev | ✅ Sí | Sin aprobación requerida |
| **PR bugfix → dev** | `bugfix/*` | `dev` | Cualquier dev | ✅ Sí | Sin aprobación requerida |
| **PR sprint → dev** | `sprint/X` | `dev` | Cualquier dev | ✅ Sí | Sin aprobación requerida |
| **PR dev → main** | `dev` | `main` | **SOLO @gastonfr24** | ❌ NO | **APROBACIÓN OBLIGATORIA** |
| **PR release → main** | `release/*` | `main` | **SOLO @gastonfr24** | ❌ NO | **APROBACIÓN OBLIGATORIA** |
| **PR hotfix → main** | `hotfix/*` | `main` | **SOLO @gastonfr24** | ❌ NO | Emergencias únicamente |

---

## 🚨 Regla Crítica: PRs a Main

### ⚠️ SOLO EL OWNER PUEDE APROBAR

**Todos los PRs hacia `main` REQUIEREN:**
1. ✅ Aprobación manual de @gastonfr24
2. ✅ CI/CD passing al 100%
3. ✅ Code review completo
4. ❌ Auto-merge PROHIBIDO

**Proceso:**
```
1. Dev crea PR: dev → main
2. CI/CD ejecuta automáticamente
3. PR entra en "waiting for review"
4. @gastonfr24 revisa:
   - Código
   - Tests
   - Documentación
   - CHANGELOG
5. @gastonfr24 aprueba o solicita cambios
6. @gastonfr24 hace merge (manual o approve + auto)
7. Tag y release
```

---

## ✅ PRs a Dev (Sin Aprobación)

### Cualquier Desarrollador Puede Mergear

**PRs hacia `dev` desde:**
- `task/*`
- `feature/*`
- `bugfix/*`
- `hotfix/*`
- `sprint/*`

**NO requieren aprobación** si:
- ✅ CI/CD pasa
- ✅ Linter pasa
- ✅ Issue vinculado (recomendado)
- ✅ Tests pasan

**Auto-merge permitido:**
```bash
gh pr merge --auto --merge
```

---

## 📋 Checklist por Tipo de PR

### PR a Dev (Desarrollo)

**Requerimientos:**
- [ ] CI/CD passing
- [ ] Linter passing
- [ ] Issue vinculado (recomendado)
- [ ] Conventional commits
- [ ] Tests pasan (si aplica)

**Aprobación:** No requerida  
**Auto-merge:** Permitido

---

### PR a Main (Release)

**Requerimientos OBLIGATORIOS:**
- [ ] CI/CD passing al 100%
- [ ] Linter passing
- [ ] Tests passing al 100%
- [ ] Issue vinculado
- [ ] CHANGELOG.md actualizado
- [ ] Versión bumpeada
- [ ] Documentación actualizada
- [ ] No breaking changes sin documentar
- [ ] Sprint completo
- [ ] Code review por @gastonfr24

**Aprobación:** **OBLIGATORIA** por @gastonfr24  
**Auto-merge:** **PROHIBIDO**

---

## 🚫 Validaciones Automáticas

### GitHub Actions

El workflow `enforce-workflow.yml` valida automáticamente:

**PRs a main:**
```javascript
if (base === 'main') {
  // Solo dev o release/* permitidos
  if (head !== 'dev' && !head.startsWith('release/')) {
    REJECT
  }
  
  // Require approval
  requireApproval: true
  autoMerge: false
  
  // Must have Closes #X
  if (!body.includes('Closes #')) {
    WARNING
  }
}
```

**PRs a dev:**
```javascript
if (base === 'dev') {
  // task/*, feature/*, bugfix/*, hotfix/*, sprint/* permitidos
  if (!allowedPrefix) {
    REJECT
  }
  
  // No require approval
  requireApproval: false
  autoMerge: true
}
```

---

## 🔧 Configuración en GitHub

### Branch Protection Rules

**Configurar en:** Settings → Branches → Add rule

#### Main Branch
```yaml
Branch name pattern: main

Require pull request before merging: ✅
  Required approvals: 1
  Dismiss stale reviews: ✅
  Require review from Code Owners: ❌ (solo 1 owner)

Require status checks to pass: ✅
  Require branches to be up to date: ✅
  Status checks:
    - ci / build
    - ci / lint
    - ci / test

Require conversation resolution: ✅
Do not allow bypassing: ✅
Restrict who can push: ✅
  - @gastonfr24 only

Allow force pushes: ❌
Allow deletions: ❌
```

#### Dev Branch
```yaml
Branch name pattern: dev

Require pull request before merging: ✅
  Required approvals: 0

Require status checks to pass: ✅
  Status checks:
    - ci / build
    - ci / lint

Allow force pushes: ❌
Allow deletions: ❌
```

---

## 🎯 Ejemplos Prácticos

### Ejemplo 1: Feature Normal

```bash
# Dev trabaja en feature
git checkout -b feature/new-thing
# ... commits ...
git push origin feature/new-thing

# Crea PR a dev
gh pr create --base dev --head feature/new-thing

# CI pasa → Dev hace auto-merge
gh pr merge --auto --merge

# ✅ NO requiere aprobación de owner
```

---

### Ejemplo 2: Release a Main

```bash
# Sprint completo, merge a dev
git checkout dev
git merge sprint/4 --no-ff
git push origin dev

# Dev crea PR a main
gh pr create --base main --head dev --title "Release v0.5.0"

# ⚠️ AQUÍ PARA
# Esperar a que @gastonfr24:
# 1. Revise el PR
# 2. Verifique CI/CD
# 3. Apruebe manualmente
# 4. Haga merge

# Solo después del merge por owner:
git checkout main
git pull origin main
git tag -a v0.5.0 -m "Release v0.5.0"
git push origin v0.5.0
```

---

### Ejemplo 3: Hotfix Crítico

```bash
# Hotfix urgente
git checkout -b hotfix/security-patch
# ... fix ...
git push origin hotfix/security-patch

# PR directo a main (excepción)
gh pr create --base main --head hotfix/security-patch

# ⚠️ REQUIERE aprobación de @gastonfr24
# Owner revisa urgentemente y aprueba

# Después: aplicar también a dev
git checkout dev
git cherry-pick <commit>
git push origin dev
```

---

## 📊 Flujo Visual

```
┌─────────────────────────────────────────────┐
│  Desarrollo (task/*, feature/*)            │
│  Auto-merge: ✅ Sí                         │
│  Aprobación: ❌ No requerida               │
└────────────────┬────────────────────────────┘
                 │
                 ▼
         ┌───────────────┐
         │      dev      │
         │  (Integración)│
         └───────┬───────┘
                 │
                 │ PR dev → main
                 │
                 ▼
         ┌───────────────────────────────────┐
         │  ⚠️  CHECKPOINT ⚠️                │
         │                                   │
         │  Requiere aprobación de:          │
         │  @gastonfr24 (OWNER)              │
         │                                   │
         │  Auto-merge: ❌ NO                │
         │  Manual review: ✅ SÍ             │
         └───────┬───────────────────────────┘
                 │
                 │ (después de aprobación)
                 │
                 ▼
         ┌───────────────┐
         │     main      │
         │  (Producción) │
         └───────────────┘
```

---

## 🆘 FAQs

### ¿Por qué no puedo mergear mi PR a main?

**R:** Solo el owner (@gastonfr24) puede aprobar PRs a `main`. Es una medida de seguridad para proteger producción.

### ¿Puedo hacer auto-merge a dev?

**R:** Sí, siempre que CI/CD pase y tu branch tenga un prefijo válido (`task/*`, `feature/*`, etc.).

### ¿Qué pasa si necesito un hotfix urgente?

**R:** Crear PR de `hotfix/*` a `main`, pero igual requiere aprobación del owner. Para emergencias críticas, contactar directamente a @gastonfr24.

### ¿Cómo sé si mi PR está esperando aprobación?

**R:** GitHub mostrará "Review required" en el PR. Si es a `main`, debes esperar a @gastonfr24.

---

## 📚 Referencias

- **Workflow Estricto:** `.cursor/rules/workflow-strict.md`
- **Sprint Workflow:** `docs/SPRINT_WORKFLOW.md`
- **GitHub Docs:** https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests

---

**Última actualización:** 2025-10-24  
**Versión:** 1.0  
**Estado:** OBLIGATORIO

