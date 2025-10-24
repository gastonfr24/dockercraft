# Sprint 2 - Testing & Automation

**Duración:** 2025-10-24 (1 día)
**Objetivo:** Validar funcionalidad del servidor y automatizar procesos clave  
**Estado:** ✅ Completado

---

## 🎯 Sprint Goal

Asegurar que el servidor Docker funciona correctamente mediante testing exhaustivo, implementar scripts de backup automático, y configurar CI/CD para validación continua.

---

## 📋 Backlog del Sprint

### User Stories

#### US-08: Testing Local del Servidor
**Como** desarrollador  
**Quiero** validar que el servidor funciona correctamente  
**Para** asegurar que los usuarios pueden usarlo sin problemas

**Prioridad:** Alta  
**Estimación:** 5 puntos  
**Rama:** `feature/testing-local`  
**Estado:** 📝 To Do

**Acceptance Criteria:**
- [ ] Servidor standalone levanta correctamente
- [ ] Servidor multi-servidor levanta los 3 servidores
- [ ] Health checks funcionan
- [ ] RCON responde correctamente
- [ ] Persistencia de datos verificada
- [ ] Resource limits se respetan

**Tasks:**
- [ ] Crear script de testing automatizado
- [ ] Test servidor standalone
- [ ] Test multi-servidor
- [ ] Test health checks
- [ ] Test RCON
- [ ] Test persistencia
- [ ] Documentar resultados

**Definition of Done:**
- [ ] Servidor funciona end-to-end
- [ ] Script de testing creado
- [ ] Documentación actualizada
- [ ] Issues encontrados documentados

---

#### US-09: Scripts de Backup Automático
**Como** administrador de servidor  
**Quiero** backups automáticos del mundo  
**Para** no perder datos en caso de fallo

**Prioridad:** Alta  
**Estimación:** 8 puntos  
**Rama:** `feature/backup-automation`  
**Estado:** 📝 To Do

**Acceptance Criteria:**
- [ ] Script backup.sh creado
- [ ] Compresión con tar.gz
- [ ] Rotación de backups (retención configurable)
- [ ] Variables de entorno para configuración
- [ ] Logging de operaciones
- [ ] Error handling robusto

**Tasks:**
- [ ] Crear scripts/backup.sh
- [ ] Implementar compresión
- [ ] Implementar rotación
- [ ] Añadir variables ENV
- [ ] Testing del script
- [ ] Documentar uso en README

**Definition of Done:**
- [ ] Script funciona correctamente
- [ ] Shellcheck pasa sin errores
- [ ] Documentado en README
- [ ] Ejemplo en docker-compose

---

#### US-10: CI/CD con GitHub Actions
**Como** desarrollador  
**Quiero** validación automática en cada PR  
**Para** mantener calidad del código

**Prioridad:** Media  
**Estimación:** 8 puntos  
**Rama:** `feature/github-actions-ci`  
**Estado:** 📝 To Do

**Acceptance Criteria:**
- [ ] Workflow de CI configurado
- [ ] Linting: hadolint (Dockerfile)
- [ ] Linting: shellcheck (scripts)
- [ ] Linting: yamllint (docker-compose)
- [ ] Security: trivy scan
- [ ] Docker build exitoso
- [ ] Runs en cada PR y push a main

**Tasks:**
- [ ] Crear .github/workflows/ci.yml
- [ ] Configurar hadolint
- [ ] Configurar shellcheck
- [ ] Configurar yamllint
- [ ] Configurar trivy
- [ ] Test workflow
- [ ] Documentar badges en README

**Definition of Done:**
- [ ] CI funciona en GitHub
- [ ] Todos los linters configurados
- [ ] Badges en README
- [ ] Documentación actualizada

---

#### US-11: Script de Restore
**Como** administrador  
**Quiero** restaurar backups fácilmente  
**Para** recuperar datos cuando sea necesario

**Prioridad:** Media  
**Estimación:** 3 puntos  
**Rama:** `feature/backup-restore`  
**Estado:** 📝 To Do

**Acceptance Criteria:**
- [ ] Script restore.sh creado
- [ ] Validación de backup antes de restaurar
- [ ] Backup del mundo actual antes de restaurar
- [ ] Logging de operaciones
- [ ] Modo dry-run para testing

**Tasks:**
- [ ] Crear scripts/restore.sh
- [ ] Implementar validación
- [ ] Añadir safety checks
- [ ] Testing del script
- [ ] Documentar en README

**Definition of Done:**
- [ ] Script funciona
- [ ] Shellcheck pasa
- [ ] Documentado
- [ ] Testeado con backup real

---

#### US-12: Optimizaciones de Performance
**Como** administrador  
**Quiero** servidor optimizado  
**Para** mejor rendimiento con menos recursos

**Prioridad:** Baja  
**Estimación:** 5 puntos  
**Rama:** `feature/performance-optimization`  
**Estado:** 📝 To Do

**Acceptance Criteria:**
- [ ] JVM flags optimizados según RAM
- [ ] Docker image size reducido
- [ ] Layer caching optimizado
- [ ] Documentación de best practices

**Tasks:**
- [ ] Investigar JVM flags óptimos
- [ ] Implementar script optimize-jvm.sh
- [ ] Optimizar Dockerfile layers
- [ ] Documentar configuraciones
- [ ] Benchmarking (opcional)

**Definition of Done:**
- [ ] Optimizaciones implementadas
- [ ] Documentadas en README
- [ ] Sin regresiones

---

#### US-13: Documentación de Troubleshooting
**Como** usuario  
**Quiero** guía de troubleshooting  
**Para** resolver problemas comunes

**Prioridad:** Baja  
**Estimación:** 3 puntos  
**Rama:** `feature/troubleshooting-guide`  
**Estado:** 📝 To Do

**Acceptance Criteria:**
- [ ] Sección troubleshooting en README
- [ ] Problemas comunes documentados
- [ ] Soluciones paso a paso
- [ ] Comandos de diagnóstico

**Tasks:**
- [ ] Identificar problemas comunes
- [ ] Escribir soluciones
- [ ] Añadir comandos útiles
- [ ] Actualizar README

**Definition of Done:**
- [ ] Sección completa
- [ ] Al menos 5 problemas comunes
- [ ] Revisado

---

## 📊 Métricas

- **Velocity estimado:** 32 story points
- **Sprint capacity:** 2 semanas
- **Completed Stories:** 0 / 7
- **Blocked Items:** 0

**Story Points por US:**
- US-08: 5 pts (Testing Local) - Prioridad Alta
- US-09: 8 pts (Backup) - Prioridad Alta
- US-10: 8 pts (CI/CD) - Prioridad Media
- US-11: 3 pts (Restore) - Prioridad Media
- US-12: 5 pts (Performance) - Prioridad Baja
- US-13: 3 pts (Troubleshooting) - Prioridad Baja

**Total:** 32 story points

---

## 🔄 Daily Standup Notes

### 2025-10-24 - Sprint Planning
- **Done:** Sprint 1 completado exitosamente
- **Today:** Iniciar Sprint 2 con testing local
- **Blockers:** Ninguno

---

## 📝 Sprint Review

_Se completará al final del sprint_

---

## 🔍 Sprint Retrospective

_Se completará al final del sprint_

---

## 🎯 Sprint Workflow

### Estrategia de Ramas: GitHub Flow

```
main (protected)
 ├── feature/testing-local          [US-08]
 ├── feature/backup-automation      [US-09]
 ├── feature/github-actions-ci      [US-10]
 ├── feature/backup-restore         [US-11]
 ├── feature/performance-optimization [US-12]
 └── feature/troubleshooting-guide  [US-13]
```

### Orden de Implementación

1. **US-08** (Testing) - Base para validar todo
2. **US-09** (Backup) - Feature crítica
3. **US-11** (Restore) - Complementa backup
4. **US-10** (CI/CD) - Automatización
5. **US-12** (Performance) - Optimizaciones
6. **US-13** (Docs) - Documentación final

---

**Última actualización:** 2025-10-24  
**Version:** v0.2.0-alpha → v0.3.0

