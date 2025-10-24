# Sprint 3 - Advanced Features & Documentation

**Duración:** 2025-10-24 - 2025-11-07 (2 semanas)
**Objetivo:** Soporte multi-version, modpacks, networking avanzado y documentación completa
**Estado:** 📝 Planificado

---

## 🎯 Sprint Goal

Expandir capacidades del Docker template para soportar diferentes versiones de Minecraft, modpacks, configuración avanzada de networking, y documentación completa para facilitar adopción y uso del proyecto.

---

## 📋 Backlog del Sprint

### User Stories

#### US-14: Soporte Multi-Version de Minecraft
**Issue:** (Pending creation)
**Como** administrador
**Quiero** poder elegir diferentes versiones de Minecraft
**Para** soportar diferentes necesidades de jugadores

**Prioridad:** Alta
**Estimación:** 5 puntos
**Rama:** `feature/multi-version-support`
**Estado:** 📝 To Do

**Acceptance Criteria:**
- [ ] Variable VERSION soporta versiones específicas (1.20.1, 1.19.4, etc)
- [ ] Variable TYPE soporta PAPER, SPIGOT, FORGE, FABRIC
- [ ] Documentación de versiones compatibles
- [ ] Ejemplos en docker-compose para diferentes versiones
- [ ] Testing de al menos 3 versiones diferentes

**Tasks:**
- [ ] Actualizar .env.example con opciones de VERSION
- [ ] Documentar tipos de servidor compatibles
- [ ] Crear docker-compose.versions.yml con ejemplos
- [ ] Añadir testing para diferentes versiones
- [ ] Actualizar README con guía de versiones

---

#### US-15: Soporte para Modpacks
**Issue:** (Pending creation)
**Como** administrador
**Quiero** poder instalar modpacks automáticamente
**Para** facilitar la configuración de servidores modded

**Prioridad:** Alta
**Estimación:** 8 puntos
**Rama:** `feature/modpack-support`
**Estado:** 📝 To Do

**Acceptance Criteria:**
- [ ] Soporte para CurseForge modpacks
- [ ] Soporte para FTB modpacks
- [ ] Variable MODPACK_URL o CURSEFORGE_FILE
- [ ] Documentación de instalación de modpacks
- [ ] Ejemplo funcional con modpack popular

**Tasks:**
- [ ] Investigar itzg/minecraft-server modpack support
- [ ] Añadir variables para modpacks en .env.example
- [ ] Crear docker-compose.modded.yml
- [ ] Documentar proceso de instalación
- [ ] Testing con modpack popular (ej: All The Mods 9)
- [ ] Añadir troubleshooting para mods

---

#### US-16: Networking Multi-Servidor
**Issue:** (Pending creation)
**Como** desarrollador de API
**Quiero** que los servidores puedan comunicarse entre sí
**Para** preparar integración con proxy (BungeeCord/Velocity)

**Prioridad:** Media
**Estimación:** 5 puntos
**Rama:** `feature/advanced-networking`
**Estado:** 📝 To Do

**Acceptance Criteria:**
- [ ] Docker network configurado correctamente
- [ ] Variables para configurar proxy mode
- [ ] Documentación de networking
- [ ] Ejemplo con 3 servidores + proxy
- [ ] Guía de integración para API externa

**Tasks:**
- [ ] Crear docker-compose.proxy.yml con Velocity/BungeeCord
- [ ] Configurar variables para proxy mode
- [ ] Documentar networking entre servidores
- [ ] Crear guía para desarrolladores de API
- [ ] Testing de conectividad entre servidores

---

#### US-17: Variables de Entorno Avanzadas
**Issue:** (Pending creation)
**Como** administrador
**Quiero** más control sobre la configuración del servidor
**Para** optimizar para casos de uso específicos

**Prioridad:** Media
**Estimación:** 3 puntos
**Rama:** `feature/advanced-env-vars`
**Estado:** 📝 To Do

**Acceptance Criteria:**
- [ ] Nuevas variables documentadas en .env.example
- [ ] Soporte para PLUGINS automáticos
- [ ] Soporte para MODS automáticos
- [ ] Configuración de whitelist via variable
- [ ] OPS automáticos via variable

**Tasks:**
- [ ] Añadir variables PLUGINS, MODS, WHITELIST, OPS
- [ ] Documentar cada variable en .env.example
- [ ] Crear ejemplos de uso
- [ ] Testing de configuración automática
- [ ] Actualizar README

---

#### US-18: Documentación Avanzada
**Issue:** (Pending creation)
**Como** nuevo usuario
**Quiero** documentación completa y clara
**Para** poder usar el proyecto sin problemas

**Prioridad:** Baja
**Estimación:** 5 puntos
**Rama:** `feature/advanced-docs`
**Estado:** 📝 To Do

**Acceptance Criteria:**
- [ ] README.md completo con todos los casos de uso
- [ ] Guía de troubleshooting expandida
- [ ] Ejemplos de configuraciones comunes
- [ ] FAQ section
- [ ] Video tutorial (opcional)

**Tasks:**
- [ ] Expandir README.md con casos de uso reales
- [ ] Crear docs/EXAMPLES.md con configuraciones comunes
- [ ] Crear docs/FAQ.md
- [ ] Mejorar TROUBLESHOOTING.md
- [ ] Añadir badges al README
- [ ] Crear docs/INTEGRATION.md para API developers

---

## 📊 Métricas del Sprint

- **Total Story Points:** 26
- **Velocidad esperada:** 20-25 puntos
- **User Stories:** 5
- **Duración:** 2 semanas

---

## 🎯 Definition of Done

Para cada User Story:

- [ ] Código implementado y testeado
- [ ] Tests pasando (automated o manual)
- [ ] Documentación actualizada
- [ ] Code review aprobado (self-review si solo)
- [ ] Sin linter errors
- [ ] Merged a dev
- [ ] Issue cerrado automáticamente

Para el Sprint:

- [ ] Todas las US completadas o movidas a backlog
- [ ] Testing completo en dev
- [ ] Release notes preparadas
- [ ] Tag de versión creado (v0.4.0)
- [ ] Sprint retrospective completada

---

## 📝 Daily Progress

### Day 1 (Pending)
- [ ] Issues creados en GitHub
- [ ] Sprint doc actualizado con Issue numbers
- [ ] US-14 iniciada

### Day 2-3 (Pending)
- [ ] US-14 completada
- [ ] US-15 iniciada

### Day 4-6 (Pending)
- [ ] US-15 completada
- [ ] US-16 iniciada

### Day 7-8 (Pending)
- [ ] US-16 completada
- [ ] US-17 iniciada

### Day 9-10 (Pending)
- [ ] US-17 completada
- [ ] US-18 iniciada

### Day 11-12 (Pending)
- [ ] US-18 completada
- [ ] Testing completo
- [ ] Sprint review

### Day 13-14 (Pending)
- [ ] Sprint retrospective
- [ ] Release v0.4.0
- [ ] Sprint 4 planning

---

## 🚀 Deployment Plan

1. **Testing en Dev**
   - Validar todas las features
   - Testing de regresión
   - Performance testing

2. **Release Branch**
   ```bash
   git checkout dev
   git checkout -b release/v0.4.0
   # Update versions
   git commit -m "chore(release): prepare v0.4.0"
   ```

3. **Merge to Main**
   ```bash
   git checkout main
   git merge release/v0.4.0 --no-ff
   git tag -a v0.4.0 -m "Release v0.4.0"
   git push origin main --tags
   ```

4. **Merge Back to Dev**
   ```bash
   git checkout dev
   git merge main
   git push origin dev
   ```

---

## 🤔 Sprint Retrospective (Al finalizar)

### What went well
(Completar al final)

### What could be improved
(Completar al final)

### Action items for next sprint
(Completar al final)

---

## 📋 Notes

- Este sprint enfoca en features avanzadas pero mantiene simplicidad
- Priorizar documentación para facilitar adopción
- Networking es preparación para API futura (proyecto separado)
- Modpacks pueden ser complejos - estimar tiempo extra

