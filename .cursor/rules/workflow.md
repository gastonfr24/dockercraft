# Workflow Automatizado - DockerCraft

## 🔄 Proceso Completo con Automatización

### 1. Crear Rama de Tarea

```bash
# Para tareas específicas de User Story
git checkout -b task/us14-dockerfile-versions

# Para features completas
git checkout -b feature/multi-version-support

# Push para trigger automatización
git push origin task/us14-dockerfile-versions
```

**✨ Automático:** GitHub Actions crea Issue automáticamente

### 2. Trabajar en la Tarea

```bash
# Hacer cambios
vim Dockerfile

# Commit
git add .
git commit -m "feat(us14): add VERSION variable support"

# Push
git push origin task/us14-dockerfile-versions
```

### 3. Crear Pull Request

```bash
# Desde GitHub UI o CLI
gh pr create --title "feat(us14): add VERSION variable support" \
  --body "Closes #X

Implements VERSION variable support for Dockerfile.

## Changes
- Added VERSION arg
- Updated documentation

## Testing
- Tested with versions 1.20.4, 1.19.4, LATEST"
```

**✨ Automático:** 
- PR se vincula al Issue
- Labels se copian del Issue al PR
- Bot verifica que tiene "Closes #X"

### 4. Merge Pull Request

Al hacer merge:
**✨ Automático:** Issue se cierra automáticamente

---

## 📋 Naming Conventions

### Ramas

```
task/us[XX]-[descripcion-corta]
feature/[descripcion-feature]
bugfix/[descripcion-bug]
hotfix/[descripcion-urgente]
```

**Ejemplos:**
- `task/us14-dockerfile-versions`
- `task/us14-compose-examples`
- `task/us14-docs-versions`
- `feature/multi-version-support`
- `bugfix/fix-memory-limit`

### Commits

Seguir [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**
- `feat`: Nueva feature
- `fix`: Bug fix
- `docs`: Solo documentación
- `style`: Formato, punto y coma, etc
- `refactor`: Refactoring de código
- `test`: Añadir tests
- `chore`: Mantenimiento

**Ejemplos:**
```
feat(us14): add multi-version support
docs(us14): add VERSIONS.md guide
fix(docker): correct memory allocation
chore(deps): update base image
```

### Pull Requests

**Título:**
```
<type>(<scope>): <description>
```

**Body DEBE incluir:**
```markdown
Closes #[issue-number]

## Description
[Descripción detallada]

## Changes
- Change 1
- Change 2

## Testing
- How to test
```

---

## 🤖 Automatizaciones Activas

### 1. Auto-Create Issue from Branch

**Trigger:** Push de nueva rama `task/*` o `feature/*`

**Acción:**
- Crea Issue automáticamente
- Extrae información del nombre de rama
- Añade labels apropiados
- Asigna al creador de la rama

### 2. PR Auto-Link to Issue

**Trigger:** PR opened/edited/reopened

**Acción:**
- Verifica que tiene "Closes #X"
- Si falta, comenta recordatorio
- Copia labels del Issue al PR
- Valida vinculación correcta

### 3. Auto-Close Issue on PR Merge

**Trigger:** PR merged

**Acción:** (GitHub nativo)
- Cierra Issues vinculados con "Closes #X"

---

## 📊 Ejemplo Completo: Sprint 3

### User Story: US-14 (Multi-Version Support)

**Tareas:**
1. Dockerfile con VERSION variable
2. docker-compose.versions.yml
3. Documentación VERSIONS.md

**Workflow:**

```bash
# Tarea 1: Dockerfile
git checkout sprint/3
git checkout -b task/us14-dockerfile-versions
# → Issue #10 creado automáticamente

# Hacer cambios...
git commit -m "feat(us14): add VERSION variable to Dockerfile"
git push origin task/us14-dockerfile-versions

# Crear PR con "Closes #10"
gh pr create
# → PR #11 creado, vinculado a #10

# Después de review y merge
# → Issue #10 se cierra automáticamente


# Tarea 2: Compose examples
git checkout sprint/3
git checkout -b task/us14-compose-examples
# → Issue #12 creado automáticamente

# Hacer cambios...
git commit -m "feat(us14): add docker-compose.versions.yml"
git push origin task/us14-compose-examples

# Crear PR con "Closes #12"
# → Al mergear, Issue #12 se cierra


# Tarea 3: Documentación
git checkout sprint/3
git checkout -b task/us14-docs-versions
# → Issue #13 creado automáticamente

# Hacer cambios...
git commit -m "docs(us14): add VERSIONS.md guide"
git push origin task/us14-docs-versions

# Crear PR con "Closes #13"
# → Al mergear, Issue #13 se cierra
```

**Resultado:**
- 3 Issues creados automáticamente
- 3 PRs vinculados correctamente
- 3 Issues cerrados automáticamente al merge
- Historial completo y trazable

---

## ✅ Checklist por Tarea

### Antes de Crear Rama
- [ ] Verificar que estás en `sprint/X` o `dev`
- [ ] Pull latest changes
- [ ] Definir nombre descriptivo de rama

### Durante Desarrollo
- [ ] Commits pequeños y frecuentes
- [ ] Mensajes de commit descriptivos
- [ ] Seguir conventional commits

### Antes de PR
- [ ] Tests pasan (si aplica)
- [ ] Linters pasan
- [ ] Documentación actualizada
- [ ] Changelog actualizado (features)

### En PR
- [ ] Título descriptivo
- [ ] "Closes #X" en body
- [ ] Descripción completa
- [ ] Screenshots si aplica
- [ ] Reviewers asignados

### Después de Merge
- [ ] Verificar Issue cerrado
- [ ] Borrar rama remota (opcional)
- [ ] Verificar en sprint/X o dev

---

## 🔍 Troubleshooting

### Issue no se creó automáticamente

**Causa:** Nombre de rama no sigue convención

**Solución:**
```bash
# Renombrar rama
git branch -m task/us14-descripcion

# Push con nuevo nombre
git push origin task/us14-descripcion
```

### Issue no se cierra al mergear PR

**Causa:** Falta "Closes #X" en PR body

**Solución:**
1. Editar PR description
2. Añadir "Closes #123"
3. Issue se cerrará en próximo merge

O cerrar manualmente:
```bash
gh issue close 123 --comment "Closed by PR #456"
```

### PR no se vincula a Issue

**Causa:** Formato incorrecto

**Solución:**
Usar exactamente:
- `Closes #123`
- `Fixes #123`
- `Resolves #123`

(Case insensitive, pero usar capital)

---

## 📚 Referencias

- [GitHub Linking Issues](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHub Actions](https://docs.github.com/en/actions)

---

**Última actualización:** 2025-10-24
**Versión:** 2.0 (Automatizado)

