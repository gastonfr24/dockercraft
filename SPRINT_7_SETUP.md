# Sprint 7 - Setup Manual de Issues

Como el workflow auto-create no se ejecutó (requiere estar en main), crea estos issues manualmente:

## 📝 Issues a Crear en GitHub

Ve a: https://github.com/gastonfr24/dockercraft/issues/new

---

### Issue 1: US35 - Tunnel Logs Format

**Title:** `feat(us35): Improve Cloudflare Tunnel logs format`

**Labels:** `enhancement`, `us-35`, `sprint-7`, `task`

**Assignee:** gastonfr24

**Body:**
```markdown
## User Story
US-35: Cloudflare Tunnel Logs Mejorados

## Task
Mejorar formato de logs del Cloudflare Tunnel para mostrar URL claramente

## Acceptance Criteria
- [ ] URL mostrada prominentemente en logs
- [ ] Estados del tunnel claros (connecting, connected, failed)  
- [ ] Formato con colores y estructura
- [ ] Métricas de conexión incluidas
- [ ] Datos sensibles ofuscados

## Branch
`task/us35-tunnel-logs-format`

## Estimated Time
3 días
```

---

### Issue 2: US35 - Tunnel URL Extraction

**Title:** `feat(us35): Add script to extract tunnel URL automatically`

**Labels:** `enhancement`, `us-35`, `sprint-7`, `task`

**Assignee:** gastonfr24

**Body:**
```markdown
## User Story
US-35: Cloudflare Tunnel Logs Mejorados

## Task
Crear script para extraer URL del tunnel automáticamente de los logs

## Acceptance Criteria
- [ ] Script scripts/tunnel/get-tunnel-url.sh creado
- [ ] Extrae URL de docker logs
- [ ] Funciona con Quick Tunnel y Persistent Tunnel
- [ ] Output limpio y usable en scripts

## Branch
`task/us35-tunnel-url-extraction`

## Estimated Time
1 día
```

---

### Issue 3: US36 - Startup Timer

**Title:** `feat(us36): Add startup timing logs`

**Labels:** `enhancement`, `us-36`, `sprint-7`, `task`

**Assignee:** gastonfr24

**Body:**
```markdown
## User Story
US-36: Tiempos de Carga del Servidor

## Task
Implementar timer para cada fase de inicialización del servidor

## Acceptance Criteria
- [ ] Timer en cada fase de startup
- [ ] Logs de tiempo por fase
- [ ] Resumen al final con tiempo total
- [ ] Comparación con startup anterior

## Branch
`task/us36-startup-timer`

## Estimated Time
2 días
```

---

### Issue 4: US36 - Progress Indicators

**Title:** `feat(us36): Add visual progress indicators during startup`

**Labels:** `enhancement`, `us-36`, `sprint-7`, `task`

**Assignee:** gastonfr24

**Body:**
```markdown
## User Story
US-36: Tiempos de Carga del Servidor

## Task
Agregar progress bars visuales durante la carga del servidor

## Acceptance Criteria
- [ ] Progress bar durante carga
- [ ] Porcentaje visible
- [ ] Logs de plugins/mods con tiempos
- [ ] Warning si fase tarda mucho

## Branch
`task/us36-progress-indicators`

## Estimated Time
2 días
```

---

### Issue 5: US37 - JSON Logging

**Title:** `feat(us37): Implement JSON structured logging`

**Labels:** `enhancement`, `us-37`, `sprint-7`, `task`

**Assignee:** gastonfr24

**Body:**
```markdown
## User Story
US-37: Sistema de Logs Estructurados

## Task
Implementar sistema de logs en formato JSON

## Acceptance Criteria
- [ ] Logs en formato JSON opcional
- [ ] Niveles de log (DEBUG, INFO, WARN, ERROR)
- [ ] Metadata completa (timestamp, source, level)
- [ ] Variable de entorno para activar JSON mode

## Branch
`task/us37-json-logging`

## Estimated Time
2 días
```

---

### Issue 6: US37 - Log Rotation

**Title:** `feat(us37): Configure log rotation and sensitive data filtering`

**Labels:** `enhancement`, `us-37`, `sprint-7`, `task`, `security`

**Assignee:** gastonfr24

**Body:**
```markdown
## User Story
US-37: Sistema de Logs Estructurados

## Task
Configurar rotación de logs y filtrado de datos sensibles

## Acceptance Criteria
- [ ] Log rotation configurado
- [ ] Filtro de tokens automático
- [ ] Filtro de passwords automático
- [ ] Filtro de IPs privadas
- [ ] Documentación de qué NO loguear

## Branch
`task/us37-log-rotation`

## Estimated Time
2 días
```

---

### Issue 7: US38 - Log Dashboard (OPCIONAL)

**Title:** `feat(us38): Create simple log dashboard`

**Labels:** `enhancement`, `us-38`, `sprint-7`, `task`, `optional`

**Assignee:** gastonfr24

**Body:**
```markdown
## User Story
US-38: Dashboard de Logs en Tiempo Real

## Task
Crear dashboard web simple para ver logs en tiempo real

## Acceptance Criteria
- [ ] Dashboard HTML/CSS/JS vanilla
- [ ] Filtros por nivel y fuente
- [ ] Auto-refresh
- [ ] Búsqueda en logs
- [ ] Exportación de logs

## Branch
`task/us38-log-dashboard`

## Estimated Time
3 días

## Note
**OPCIONAL** - Puede moverse a Sprint 8 si falta tiempo
```

---

## 🚀 Después de Crear los Issues

Una vez tengas los números de issue (ej: #45, #46, etc.), dímelos y:

1. Comenzaré con el desarrollo de US-35
2. Haré commit y push
3. Crearé PR a sprint/7 con `Closes #XX`
4. Tú aprobarás el PR
5. Mergearé y pasaré a la siguiente tarea

---

**Alternativa:** Si quieres, puedo comenzar el desarrollo ahora y crear los PRs sin el `Closes #XX`, y tú los vinculas manualmente después.

¿Qué prefieres?

