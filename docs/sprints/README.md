# Sprints - DockerCraft

Este directorio contiene la planificación y seguimiento de sprints del proyecto.

## Estructura

```
sprints/
├── README.md           # Este archivo
├── SPRINT_TEMPLATE.md  # Template para nuevos sprints
├── SPRINT_01.md        # Sprint 1 - Base Implementation ✅
├── SPRINT_02.md        # Sprint 2 - Testing & Automation (próximo)
└── ...
```

## Metodología

Usamos **Scrum** con sprints de 1-2 semanas.

### Ciclo de Sprint

```
1. Sprint Planning
   ├── Definir objetivo
   ├── Seleccionar User Stories del backlog
   ├── Estimar story points
   └── Crear rama de sprint (opcional)

2. Daily Standup (informal para proyecto personal)
   ├── ¿Qué hice ayer?
   ├── ¿Qué haré hoy?
   └── ¿Hay bloqueadores?

3. Development
   ├── Implementar features
   ├── Code review
   └── Testing

4. Sprint Review
   ├── Demo de features
   └── Feedback

5. Sprint Retrospective
   ├── What went well
   ├── What could improve
   └── Action items
```

## Workflow de Ramas

### Opción A: GitHub Flow (Simple)

Para sprints pequeños o 1 persona:

```
main
 ├── feature/user-auth
 ├── fix/docker-memory
 └── docs/api-guide
```

**Proceso:**
1. Crear feature branch desde `main`
2. Implementar y commitear
3. PR a `main`
4. Merge y delete branch

### Opción B: Sprint Branches (Complejo)

Para sprints grandes o múltiples personas:

```
main
 └── sprint/02-testing-automation
      ├── feature/backup-script
      ├── feature/ci-github-actions
      └── fix/health-check-timeout
```

**Proceso:**
1. Crear sprint branch desde `main`
2. Crear feature branches desde sprint branch
3. PRs a sprint branch
4. Al final: PR de sprint branch a `main`

## Estado Actual

### Sprint 1 ✅ Completado
- **Duración:** 2025-10-24 - 2025-10-24
- **Velocity:** 34 story points
- **Features:** 7 user stories completadas
- **Tag:** v0.2.0-alpha

### Sprint 2 📝 Planificado
- **Duración:** TBD
- **Objetivo:** Testing & Automation
- **Features:** Backup scripts, CI/CD, testing

## User Story Template

```markdown
#### US-[NUMBER]: [TITLE]
**Como** [ROLE]
**Quiero** [FEATURE]
**Para** [BENEFIT]

**Prioridad:** Alta / Media / Baja
**Estimación:** [STORY_POINTS]
**Rama:** `feature/[branch-name]`
**Estado:** 📝 To Do / 🚧 In Progress / ✅ Done

**Acceptance Criteria:**
- [ ] Criterio 1
- [ ] Criterio 2

**Tasks:**
- [ ] Task 1
- [ ] Task 2

**Definition of Done:**
- [ ] Código implementado
- [ ] Tests pasando
- [ ] Documentación actualizada
- [ ] Code review
- [ ] Merge a main
```

## Story Points

Estimación de esfuerzo:

- **1 pt** - Muy simple (< 1 hora)
- **2 pts** - Simple (1-2 horas)
- **3 pts** - Mediano (2-4 horas)
- **5 pts** - Complejo (1 día)
- **8 pts** - Muy complejo (2 días)
- **13 pts** - Épico (dividir en stories más pequeñas)

## Comandos Útiles

### Crear Nueva Rama de Feature

```bash
# Desde main
git checkout main
git pull origin main
git checkout -b feature/backup-script

# Trabajo...
git add .
git commit -m "feat(scripts): add backup script"
git push origin feature/backup-script

# Crear PR en GitHub
```

### Crear Sprint Branch (Opcional)

```bash
# Desde main
git checkout main
git pull origin main
git checkout -b sprint/02-testing-automation

# Push sprint branch
git push -u origin sprint/02-testing-automation

# Feature branches desde sprint
git checkout sprint/02-testing-automation
git checkout -b feature/backup-script
```

### Finalizar Sprint

```bash
# Si usaste sprint branch
git checkout main
git pull origin main
git merge --no-ff sprint/02-testing-automation
git tag -a v0.3.0 -m "Sprint 2 complete"
git push origin main --tags

# Delete sprint branch
git branch -d sprint/02-testing-automation
git push origin --delete sprint/02-testing-automation
```

## Referencias

- Template: `SPRINT_TEMPLATE.md`
- Scrum Guide: https://scrumguides.org/
- Git Workflow: `.cursor/rules/git.md`
- Core Rules: `.cursor/rules/core.md`

---

**Última actualización:** 2025-10-24

