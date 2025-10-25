# Sprint 7 - Issues to Create

Lista de issues a crear en GitHub para Sprint 7

---

## 📝 Issues Template

### US-35: Cloudflare Tunnel Logs (13 pts)

**Tareas:**

#### Issue #1: `task/us35-tunnel-logs-format`
```bash
gh issue create \
  --title "feat(us35): Improve Cloudflare Tunnel logs format" \
  --label "enhancement,us-35,sprint-7" \
  --body "## User Story
US-35: Cloudflare Tunnel Logs Mejorados

## Task
Mejorar formato de logs del Cloudflare Tunnel para mostrar URL claramente

## Acceptance Criteria
- [ ] URL mostrada prominentemente en logs
- [ ] Estados del tunnel claros (connecting, connected, failed)
- [ ] Formato con colores y estructura
- [ ] Métricas de conexión incluidas
- [ ] Datos sensibles ofuscados

## Technical Details
- Modificar scripts en scripts/tunnel/
- Actualizar docker-compose logs
- Agregar wrappers para cloudflared

## Estimated Time
3 días"
```

#### Issue #2: `task/us35-tunnel-url-extraction`
```bash
gh issue create \
  --title "feat(us35): Add script to extract tunnel URL automatically" \
  --label "enhancement,us-35,sprint-7" \
  --body "## User Story
US-35: Cloudflare Tunnel Logs Mejorados

## Task
Crear script para extraer URL del tunnel automáticamente de los logs

## Acceptance Criteria
- [ ] Script scripts/tunnel/get-tunnel-url.sh creado
- [ ] Extrae URL de docker logs
- [ ] Funciona con Quick Tunnel y Persistent Tunnel
- [ ] Output limpio y usable en scripts

## Technical Details
- Parsear docker logs cloudflared
- Regex para encontrar URL
- Manejo de errores

## Estimated Time
1 día"
```

---

### US-36: Startup Timing (8 pts)

#### Issue #3: `task/us36-startup-timer`
```bash
gh issue create \
  --title "feat(us36): Add startup timing logs" \
  --label "enhancement,us-36,sprint-7" \
  --body "## User Story
US-36: Tiempos de Carga del Servidor

## Task
Implementar timer para cada fase de inicialización del servidor

## Acceptance Criteria
- [ ] Timer en cada fase de startup
- [ ] Logs de tiempo por fase
- [ ] Resumen al final con tiempo total
- [ ] Comparación con startup anterior

## Technical Details
- Modificar entrypoint script
- Agregar timestamps
- Calcular deltas

## Estimated Time
2 días"
```

#### Issue #4: `task/us36-progress-indicators`
```bash
gh issue create \
  --title "feat(us36): Add visual progress indicators during startup" \
  --label "enhancement,us-36,sprint-7" \
  --body "## User Story
US-36: Tiempos de Carga del Servidor

## Task
Agregar progress bars visuales durante la carga del servidor

## Acceptance Criteria
- [ ] Progress bar durante carga
- [ ] Porcentaje visible
- [ ] Logs de plugins/mods con tiempos
- [ ] Warning si fase tarda mucho

## Technical Details
- Usar caracteres Unicode para progress bar
- Calcular % basado en fases
- Logs bonitos y legibles

## Estimated Time
2 días"
```

---

### US-37: Structured Logging (8 pts)

#### Issue #5: `task/us37-json-logging`
```bash
gh issue create \
  --title "feat(us37): Implement JSON structured logging" \
  --label "enhancement,us-37,sprint-7" \
  --body "## User Story
US-37: Sistema de Logs Estructurados

## Task
Implementar sistema de logs en formato JSON

## Acceptance Criteria
- [ ] Logs en formato JSON opcional
- [ ] Niveles de log (DEBUG, INFO, WARN, ERROR)
- [ ] Metadata completa (timestamp, source, level)
- [ ] Variable de entorno para activar JSON mode

## Technical Details
- Configuración en .env
- Transform de logs existentes
- Mantener compatibilidad con formato texto

## Estimated Time
2 días"
```

#### Issue #6: `task/us37-log-rotation`
```bash
gh issue create \
  --title "feat(us37): Configure log rotation and sensitive data filtering" \
  --label "enhancement,us-37,sprint-7,security" \
  --body "## User Story
US-37: Sistema de Logs Estructurados

## Task
Configurar rotación de logs y filtrado de datos sensibles

## Acceptance Criteria
- [ ] Log rotation configurado
- [ ] Filtro de tokens automático
- [ ] Filtro de passwords automático
- [ ] Filtro de IPs privadas
- [ ] Documentación de qué NO loguear

## Technical Details
- Configurar logrotate
- Script de filtrado
- Regex patterns para datos sensibles

## Estimated Time
2 días"
```

---

### US-38: Log Dashboard (5 pts) - OPCIONAL

#### Issue #7: `task/us38-log-dashboard`
```bash
gh issue create \
  --title "feat(us38): Create simple log dashboard" \
  --label "enhancement,us-38,sprint-7,optional" \
  --body "## User Story
US-38: Dashboard de Logs en Tiempo Real

## Task
Crear dashboard web simple para ver logs en tiempo real

## Acceptance Criteria
- [ ] Dashboard HTML/CSS/JS vanilla
- [ ] Filtros por nivel y fuente
- [ ] Auto-refresh
- [ ] Búsqueda en logs
- [ ] Exportación de logs

## Technical Details
- Sin dependencias pesadas
- API simple para exponer logs
- WebSocket para real-time (opcional)

## Estimated Time
3 días

## Note
OPCIONAL - Puede moverse a Sprint 8 si falta tiempo"
```

---

## 🚀 Comandos para Crear Issues

```bash
# Actualizar PATH para gh
$env:Path = "C:\Program Files\GitHub CLI\bin;" + $env:Path

# Crear labels primero
gh label create "us-35" --color "0E8A16" --description "US35: Cloudflare Tunnel Logs"
gh label create "us-36" --color "0E8A16" --description "US36: Startup Timing"
gh label create "us-37" --color "0E8A16" --description "US37: Structured Logging"
gh label create "us-38" --color "0E8A16" --description "US38: Log Dashboard"
gh label create "sprint-7" --color "ededed" --description "Sprint 7 tasks"

# Crear issues (copiar comandos de arriba)
```

---

## 📋 Task Branches to Create

Después de crear los issues, crear estas ramas:

```bash
# US-35
git checkout sprint/7
git checkout -b task/us35-tunnel-logs-format
git push origin task/us35-tunnel-logs-format

git checkout sprint/7
git checkout -b task/us35-tunnel-url-extraction
git push origin task/us35-tunnel-url-extraction

# US-36
git checkout sprint/7
git checkout -b task/us36-startup-timer
git push origin task/us36-startup-timer

git checkout sprint/7
git checkout -b task/us36-progress-indicators
git push origin task/us36-progress-indicators

# US-37
git checkout sprint/7
git checkout -b task/us37-json-logging
git push origin task/us37-json-logging

git checkout sprint/7
git checkout -b task/us37-log-rotation
git push origin task/us37-log-rotation

# US-38 (opcional)
git checkout sprint/7
git checkout -b task/us38-log-dashboard
git push origin task/us38-log-dashboard
```

---

## 🔄 Workflow per Task

Para cada tarea:

1. **Checkout a task branch**
```bash
git checkout task/usXX-name
```

2. **Desarrollar**
```bash
# Hacer cambios
git commit -m "feat(usXX): description"
git push
```

3. **Crear PR a sprint/7**
```bash
gh pr create \
  --base sprint/7 \
  --head task/usXX-name \
  --title "feat(usXX): description" \
  --body "Closes #<issue_number>

Changes:
- ...

Testing:
- ..."
```

4. **Aprobar y merge** (auto-merge permitido a sprint/7)

5. **Repetir para siguiente tarea**

---

## 📊 Progress Tracking

| Task | Issue | Branch | PR | Status |
|------|-------|--------|----|----|
| Tunnel logs format | #TBD | `task/us35-tunnel-logs-format` | #TBD | ⏳ Pending |
| Tunnel URL extraction | #TBD | `task/us35-tunnel-url-extraction` | #TBD | ⏳ Pending |
| Startup timer | #TBD | `task/us36-startup-timer` | #TBD | ⏳ Pending |
| Progress indicators | #TBD | `task/us36-progress-indicators` | #TBD | ⏳ Pending |
| JSON logging | #TBD | `task/us37-json-logging` | #TBD | ⏳ Pending |
| Log rotation | #TBD | `task/us37-log-rotation` | #TBD | ⏳ Pending |
| Log dashboard | #TBD | `task/us38-log-dashboard` | #TBD | ⏳ Pending (optional) |

---

**Created:** 2025-10-25  
**Sprint:** 7  
**Status:** Ready to create issues

