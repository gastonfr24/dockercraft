# Cursor Rules - Estructura Modular

Esta carpeta contiene las reglas de desarrollo del proyecto organizadas de forma modular para facilitar mantenimiento y extensión.

## Estructura

```
.cursor/rules/
├── README.md           # Este archivo
├── core.md             # Reglas principales y metodología
├── docker.md           # Reglas específicas de Docker
├── shell.md            # Reglas específicas de Shell/Bash
├── git.md              # Workflow de Git, branches, PRs, issues
├── documentation.md    # Reglas de documentación
└── testing.md          # Reglas de testing y QA
```

## Archivos Modulares

- **`core.md`** - Principios fundamentales, metodología Scrum, nomenclatura
- **`docker.md`** - Reglas específicas de Docker y Dockerfile
- **`shell.md`** - Scripting Bash/Shell con error handling
- **`git.md`** - Git workflow, branching, versionado, PRs, issues
- **`documentation.md`** - Estándares de documentación
- **`testing.md`** - Testing y QA

## Orden de Lectura Recomendado

### Para IA (Primera Vez)

1. **`core.md`** - Empieza aquí para entender filosofía y metodología
2. **`git.md`** - IMPORTANTE: Workflow de ramas, commits, PRs
3. **`docker.md`** - Si trabajas en Dockerfile o docker-compose
4. **`shell.md`** - Si escribes scripts
5. **`documentation.md`** - Antes de actualizar docs
6. **`testing.md`** - Antes de escribir tests

### Para Desarrolladores

1. `core.md` - Overview y metodología Scrum
2. `git.md` - Workflow de Git (LEER ANTES DE COMMIT)
3. Consultar archivo específico según tarea

## Cómo Agregar Nuevas Reglas

1. Si es regla general → `core.md`
2. Si es sobre Git/versionado → `git.md`
3. Si es específica de Docker → `docker.md`
4. Si es específica de Shell → `shell.md`
5. Si no encaja en ninguno → Crear nuevo archivo

## Mantenimiento

- Mantener consistencia entre archivos
- Evitar duplicación de reglas
- Actualizar este README al agregar nuevos archivos
- Versionar cambios en `docs/ai/09_CHANGELOG.md`

---

**Última actualización:** 2025-10-24
