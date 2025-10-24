# 🧠 Memoria del Proyecto - DockerCraft

> **Última actualización:** 2025-10-24  
> **Versión:** v0.1.0-alpha

Este documento actúa como memoria del proyecto, dividida en:
- **Memoria de Corto Plazo:** Decisiones y cambios recientes (última sesión/sprint)
- **Memoria de Largo Plazo:** Historial acumulativo de decisiones importantes

---

## ⚡ Memoria de Corto Plazo

> **Período:** 2025-10-24 (Sesión Inicial)  
> **Sprint:** Sprint 0 - Planificación

### **Contexto de Esta Sesión**

**Objetivo Principal:**  
Crear la estructura base y documentación del proyecto DockerCraft, un sistema para gestionar servidores Minecraft dinámicamente mediante Docker y API REST.

### **Decisiones Tomadas Hoy**

1. ✅ **Arquitectura basada en microservicios**
   - Docker para containerización
   - API REST como capa de gestión
   - PostgreSQL para persistencia
   - BungeeCord opcional para futuro

2. ✅ **Stack Tecnológico Inicial**
   - Imagen base: `itzg/minecraft-server`
   - Servidor tipo: Paper (por defecto)
   - Backend API: Node.js (propuesto, pendiente confirmación)
   - Base de datos: PostgreSQL
   - Orquestación: Docker Compose

3. ✅ **Estructura de Documentación para IA**
   - Creada carpeta `docs/ai/`
   - 10 archivos de documentación estructurada
   - Formato ADR para decisiones técnicas
   - Sistema de memoria de corto/largo plazo

4. ✅ **Enfoque de Implementación**
   - MVP primero: servidor base funcional + API básica
   - Iteraciones incrementales
   - Documentación continua

### **Cambios en el Código**

```
Sprint 1 - Implementación Base COMPLETADA (2025-10-24):

Archivos Core del Proyecto:
├── Dockerfile                    # Imagen optimizada itzg/minecraft-server:java21
├── .dockerignore                 # Optimización de build
├── .env.example                  # Variables de entorno documentadas
├── .gitignore                    # Git ignore rules
├── server.properties             # Configuración base del servidor
├── docker-compose.yml            # Ejemplo standalone
├── docker-compose.multi.yml      # Ejemplo multi-servidor (3 servers)
└── scripts/
    └── health-check.sh           # Health check customizado con logging

Archivos de Documentación:
├── docs/ai/00_README_AI.md       # Guía para leer documentación
├── docs/ai/01_CONTEXT.md         # Contexto del proyecto
├── docs/ai/02_ARCHITECTURE.md    # Arquitectura técnica
├── docs/ai/03_DECISIONS.md       # Decisiones técnicas (ADRs)
├── docs/ai/04_MEMORY.md          # Este archivo
├── docs/ai/05_ROADMAP.md         # Roadmap de implementación
├── docs/ai/07_WORKFLOWS.md       # Procedimientos y workflows
├── docs/ai/08_QUICK_START.md     # Guía de inicio rápido
├── docs/ai/09_CHANGELOG.md       # Registro de cambios
└── docs/ai/10_GLOSSARY.md        # Glosario de términos

Cursor Rules Modulares:
├── .cursorrules                  # Entry point
└── .cursor/rules/
    ├── README.md                 # Índice de reglas
    ├── core.md                   # Principios y metodología Scrum
    ├── docker.md                 # Reglas específicas de Docker
    ├── shell.md                  # Reglas de scripting Shell
    ├── git.md                    # Workflow de Git
    ├── documentation.md          # Reglas de documentación
    └── testing.md                # Testing y QA

Configuración Implementada:
- Auto-pause para ahorro de recursos (ENABLE_AUTOPAUSE=TRUE)
- Health checks nativos (mc-health)
- RCON habilitado por defecto
- Variables de entorno con defaults sensibles
- Resource limits configurables (CPU/Memory)
- Aikar flags para optimización JVM
- Logging con timestamps y timezone
- Multi-server ready (ejemplos con 3 servidores)
```

### **Problemas Encontrados**

- ⚠️ **Ninguno todavía** - En fase de planificación

### **Aprendizajes de Esta Sesión**

1. **itzg/minecraft-server es muy feature-rich**
   - Auto-pause para ahorro de recursos
   - Soporte multi-versión y multi-tipo
   - Health checks integrados
   - Bien documentado

2. **Paper es mejor que Vanilla/Spigot**
   - Mejor rendimiento
   - Compatible con plugins
   - Mantenido activamente

3. **Asignación dinámica de puertos es crítica**
   - Necesitamos PortManager en la API
   - Rango sugerido: 25565-25665 (100 servidores)

### **Bloqueadores Actuales**

- ❓ **Confirmar lenguaje de API:** Node.js vs Python
- ❓ **Confirmar si usar TypeScript**
- ❓ **Definir versión de Minecraft por defecto**

### **Próximos Pasos Inmediatos**

1. [x] Completar archivos de documentación restantes
2. [x] Crear estructura de carpetas del proyecto
3. [x] Crear Dockerfile base para Minecraft
4. [x] Crear docker-compose.yml (standalone + multi-servidor)
5. [x] Crear .env.example con variables documentadas
6. [x] Crear scripts de utilidad (health-check.sh)
7. [x] Configurar reglas modulares de Cursor (.cursor/rules/)
8. [ ] Testing local (docker-compose up y verificar que funciona)
9. [ ] Crear README.md completo con guías de uso
10. [ ] Validar con linters (hadolint, shellcheck, yamllint)

### **Preguntas para la Siguiente Sesión**

1. ¿Preferencia por Node.js o Python para la API?
2. ¿Usar TypeScript?
3. ¿Versión de Minecraft objetivo? (Recomiendo: 1.21.1)
4. ¿Necesitamos autenticación en MVP o dejarla para después?
5. ¿Deploy target? (Local, VPS, Cloud)

---

## 📚 Memoria de Largo Plazo

> Historial acumulativo de decisiones y evolución del proyecto

### **Fase 0: Inception (2025-10-24)**

#### **Origen del Proyecto**

- **Fecha de Inicio:** 2025-10-24
- **Motivación:** Crear un sistema moderno para gestionar múltiples servidores Minecraft dinámicamente, inspirado en servicios como Pterodactyl pero más simple y específico.
- **Problema a Resolver:** Gestión manual de servidores es compleja, propensa a errores y no escalable.

#### **Decisiones Arquitectónicas Clave**

| Decisión | Razón | ADR |
|----------|-------|-----|
| Docker como base | Aislamiento, portabilidad, escalabilidad | ADR-001 |
| itzg/minecraft-server | Imagen madura y feature-rich | ADR-002 |
| Paper por defecto | Mejor rendimiento que Vanilla/Spigot | ADR-003 |
| Node.js para API | Async I/O, Dockerode, rápido desarrollo | ADR-004 |
| PostgreSQL | Datos estructurados, ACID, relaciones | ADR-005 |
| JWT para auth | Stateless, escalable, estándar | ADR-006 |
| Docker Compose | Simple para MVP, migrar a K8s después | ADR-007 |
| Puertos dinámicos | Automatización, escalabilidad | ADR-008 |
| Named volumes | Gestión de Docker, mejor rendimiento | ADR-009 |
| Auto-pause | Ahorro de recursos sin sacrificar UX | ADR-010 |
| Backups locales MVP | Simple, sin costos, cloud en roadmap | ADR-011 |

#### **Tecnologías Evaluadas y Descartadas**

- ❌ **Kubernetes inicial:** Complejidad innecesaria para MVP
- ❌ **Bare metal:** Sin aislamiento, difícil gestionar
- ❌ **VMs:** Mayor overhead que Docker
- ❌ **Vanilla Minecraft:** Menos rendimiento que Paper
- ❌ **MongoDB:** Preferimos relaciones fuertes de SQL
- ❌ **Session-based auth:** JWT es más escalable

#### **Hitos del Proyecto**

| Fecha | Hito | Estado |
|-------|------|--------|
| 2025-10-24 | Investigación de arquitecturas | ✅ Completado |
| 2025-10-24 | Definición de stack tecnológico | ✅ Completado |
| 2025-10-24 | Creación de documentación para IA | 🚧 En progreso |
| TBD | Dockerfile base funcional | ⏳ Pendiente |
| TBD | Docker Compose básico | ⏳ Pendiente |
| TBD | API REST MVP | ⏳ Pendiente |
| TBD | Primer servidor funcional | ⏳ Pendiente |

---

## 🔄 Changelog de Decisiones Importantes

> Registro cronológico de cambios en decisiones

### 2025-10-24

**Decisiones Iniciales:**
- ✅ Proyecto iniciado con arquitectura microservicios
- ✅ Docker elegido como plataforma de containerización
- ✅ itzg/minecraft-server como imagen base
- ✅ Paper como tipo de servidor
- ✅ PostgreSQL como base de datos
- ✅ JWT para autenticación
- ✅ Auto-pause habilitado por defecto

**Pendientes de Confirmar:**
- ⏳ Node.js vs Python para API (propuesto: Node.js)
- ⏳ JavaScript vs TypeScript (propuesto: TypeScript)
- ⏳ Versión de Minecraft (propuesto: 1.21.1)

---

## 📝 Lecciones Aprendidas

> Conocimiento acumulado que debe persistir

### **Lección 1: Planificación Antes de Código**

**Fecha:** 2025-10-24  
**Contexto:** Inicio del proyecto

**Lección:**  
Invertir tiempo en planificación y documentación al inicio evita retrabajos. Definir arquitectura, decisiones técnicas y roadmap claramente antes de escribir código es una inversión que se paga.

**Aplicación Futura:**  
Siempre crear documentación de contexto antes de implementar features grandes.

---

### **Lección 2: Documentación para IA es Diferente**

**Fecha:** 2025-10-24  
**Contexto:** Crear docs/ai/

**Lección:**  
La documentación orientada a IA debe ser:
- Estructurada y jerárquica
- Explícita (no asumir contexto implícito)
- Separar memoria de corto y largo plazo
- Incluir "por qué" no solo "qué"
- Mantener actualizaciones frecuentes

**Aplicación Futura:**  
Actualizar docs/ai/ al finalizar cada sesión de trabajo.

---

## 🎯 Métricas y Estado del Proyecto

### **Estado Actual**

- **Fase:** Planificación (Sprint 0)
- **Progreso Global:** 5% (documentación inicial)
- **Líneas de Código:** 0 (solo docs por ahora)
- **Tests:** 0
- **Documentación:** 40% (docs/ai en progreso)

### **Velocidad del Equipo**

- **Sprints Completados:** 0
- **Story Points (estimado por sprint):** TBD
- **Velocity Promedio:** N/A (primer sprint)

### **Deuda Técnica**

- **Actual:** 0 (proyecto recién iniciado)
- **Target:** Mantener < 10% del código

---

## 🤖 Instrucciones para IA

### **Al Iniciar Nueva Sesión:**

1. **Leer esta sección primero** ("Memoria de Corto Plazo")
2. Identificar "Próximos Pasos Inmediatos"
3. Verificar "Bloqueadores Actuales"
4. Revisar "Preguntas para la Siguiente Sesión"

### **Al Finalizar Sesión:**

1. **Actualizar Memoria de Corto Plazo:**
   - Fecha y objetivo de la sesión
   - Decisiones tomadas
   - Cambios en el código
   - Problemas encontrados
   - Próximos pasos

2. **Si hubo decisión arquitectónica importante:**
   - Agregar a Memoria de Largo Plazo
   - Crear ADR en 03_DECISIONS.md
   - Actualizar 09_CHANGELOG.md

3. **Si se completó hito:**
   - Actualizar tabla de Hitos
   - Actualizar métricas de progreso

### **Formato de Actualización:**

```markdown
### **Contexto de Esta Sesión**

**Objetivo Principal:**  
[Describir qué se intentó lograr]

### **Decisiones Tomadas Hoy**

1. [Decisión 1]
2. [Decisión 2]

### **Cambios en el Código**

Archivos Creados:
- path/to/file.ext

Archivos Modificados:
- path/to/file.ext (cambio: descripción)

### **Problemas Encontrados**

- [Problema y solución o workaround]

### **Próximos Pasos Inmediatos**

1. [ ] Tarea 1
2. [ ] Tarea 2
```

---

## 📊 Dashboard de Estado

```
┌─────────────────────────────────────────────┐
│         DOCKERCRAFT STATUS DASHBOARD        │
├─────────────────────────────────────────────┤
│ Fase Actual:        Planning (Sprint 0)    │
│ Progreso Global:    █░░░░░░░░░ 5%          │
│ Último Commit:      2025-10-24             │
│ Archivos Docs:      4/10 completados       │
│ Código Escrito:     0 líneas               │
│ Tests Passing:      N/A                    │
│ Deuda Técnica:      0%                     │
└─────────────────────────────────────────────┘

Estado de Componentes:
  ┌─────────────────┬──────────┐
  │ Componente      │ Estado   │
  ├─────────────────┼──────────┤
  │ Docs/AI         │ 🚧 40%   │
  │ Minecraft Base  │ ⏳ 0%    │
  │ API REST        │ ⏳ 0%    │
  │ Database        │ ⏳ 0%    │
  │ Docker Compose  │ ⏳ 0%    │
  │ Scripts         │ ⏳ 0%    │
  │ Monitoring      │ ⏳ 0%    │
  └─────────────────┴──────────┘

Leyenda:
  ✅ Completado  🚧 En progreso  ⏳ Pendiente  ❌ Bloqueado
```

---

## 🔮 Contexto para Futuras Sesiones

### **Si necesitas implementar el servidor base:**
- Leer ADR-002 (imagen itzg)
- Leer ADR-003 (Paper)
- Leer ADR-009 (volumes)
- Consultar 05_ROADMAP.md > Sprint 1

### **Si necesitas implementar la API:**
- Leer ADR-004 (Node.js)
- Leer ADR-006 (JWT)
- Leer 06_API_SPECS.md
- Consultar 02_ARCHITECTURE.md > Sección API

### **Si hay un problema de rendimiento:**
- Verificar ADR-010 (auto-pause)
- Revisar ADR-003 (Paper optimizations)
- Consultar 07_WORKFLOWS.md > Troubleshooting

### **Si necesitas agregar nueva funcionalidad:**
- Revisar 05_ROADMAP.md para prioridad
- Crear ADR si es decisión arquitectónica
- Actualizar 06_API_SPECS.md si afecta API
- Actualizar este archivo (MEMORY.md)

---

**Última actualización:** 2025-10-24 23:30 UTC  
**Próxima revisión:** Al finalizar Sprint 1  
**Mantenido por:** Sistema de IA + Desarrolladores

