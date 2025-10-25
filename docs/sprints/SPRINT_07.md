# Sprint 7 - Logging & Observability

**Fecha Inicio:** 2025-10-25  
**Estado:** Planning  
**Story Points:** 34  
**Duración:** 2 semanas

---

## 🎯 Objetivo del Sprint

Mejorar significativamente el sistema de logging del proyecto para proporcionar información clara, útil y visualmente atractiva sin exponer datos sensibles. Enfoque especial en logs del tunnel de Cloudflare y tiempos de carga.

---

## 📊 Métricas

- **Story Points Total:** 34
- **User Stories:** 4
- **Tareas Estimadas:** 15+
- **Duración Estimada:** 2 semanas

---

## 📝 User Stories

### US-35: Logs Mejorados de Cloudflare Tunnel

**Story Points:** 13  
**Prioridad:** Alta  
**Issue:** TBD

**Como** administrador  
**Quiero** ver logs claros y útiles del Cloudflare Tunnel  
**Para** saber exactamente dónde está corriendo mi servidor y diagnosticar problemas fácilmente

**Acceptance Criteria:**
- [ ] URL del tunnel mostrada claramente en logs al iniciar
- [ ] Formato de logs mejorado (colores, estructura)
- [ ] Estados del tunnel claramente indicados (connecting, connected, failed)
- [ ] Información sensible ofuscada (tokens, IPs privadas)
- [ ] Logs de métricas de conexión (latencia, throughput)
- [ ] Integración con docker-compose logs
- [ ] Script para extraer URL del tunnel automáticamente

**Tareas:**
1. `tunnel-logs-format` - Mejorar formato de logs del tunnel
2. `tunnel-url-extraction` - Script para extraer URL automáticamente
3. `tunnel-status-display` - Display de estado del tunnel
4. `tunnel-logs-testing` - Testing de logs

**Ejemplo de Output Esperado:**
```
[Cloudflare Tunnel] 🚀 Starting tunnel...
[Cloudflare Tunnel] 📡 Connecting to Cloudflare network...
[Cloudflare Tunnel] ✅ Tunnel established successfully!
[Cloudflare Tunnel] 
[Cloudflare Tunnel] ════════════════════════════════════════
[Cloudflare Tunnel] 🌐 SERVER IS LIVE!
[Cloudflare Tunnel] 
[Cloudflare Tunnel] Public URL: amazing-server-123.trycloudflare.com
[Cloudflare Tunnel] 
[Cloudflare Tunnel] Share this address with your players
[Cloudflare Tunnel] ════════════════════════════════════════
[Cloudflare Tunnel] 
[Cloudflare Tunnel] 📊 Connection Stats:
[Cloudflare Tunnel]   - Latency: 45ms
[Cloudflare Tunnel]   - Status: HEALTHY
[Cloudflare Tunnel]   - Uptime: 00:00:05
```

---

### US-36: Logs de Tiempos de Carga del Servidor

**Story Points:** 8  
**Prioridad:** Alta  
**Issue:** TBD

**Como** administrador  
**Quiero** ver tiempos de carga detallados de cada fase del servidor  
**Para** identificar cuellos de botella y optimizar el startup

**Acceptance Criteria:**
- [ ] Timer de cada fase de inicialización
- [ ] Progreso visual durante la carga (progress bar/spinner)
- [ ] Logs de carga de plugins/mods con tiempos individuales
- [ ] Logs de carga de chunks del mundo
- [ ] Warning si alguna fase tarda demasiado
- [ ] Resumen al final con tiempo total
- [ ] Comparación con startups anteriores

**Tareas:**
1. `startup-timer` - Implementar timer de startup
2. `plugin-load-timing` - Logs de tiempos de plugins
3. `world-load-timing` - Logs de tiempos de mundo
4. `startup-summary` - Resumen de startup
5. `startup-comparison` - Comparar con startups previos

**Ejemplo de Output Esperado:**
```
[Minecraft] 🎮 Starting Minecraft Server...
[Minecraft] 
[Minecraft] ⏱️  Initialization Timeline:
[Minecraft] 
[Minecraft] [████████░░░░░░░░░░░░] 40% Loading server properties... (0.5s)
[Minecraft] [████████████░░░░░░░░] 60% Loading plugins (12 found)... (1.2s)
[Minecraft]   ├─ EssentialsX... ✅ (0.3s)
[Minecraft]   ├─ WorldEdit... ✅ (0.4s)
[Minecraft]   └─ Vault... ✅ (0.2s)
[Minecraft] [████████████████░░░░] 80% Preparing spawn area... (2.1s)
[Minecraft] [████████████████████] 100% Server ready! (3.8s total)
[Minecraft] 
[Minecraft] ✅ Server started in 3.8 seconds
[Minecraft] 📊 Comparison: 0.5s faster than last startup
```

---

### US-37: Sistema de Logs Estructurados

**Story Points:** 8  
**Prioridad:** Media  
**Issue:** TBD

**Como** desarrollador  
**Quiero** logs estructurados en formato JSON  
**Para** poder analizarlos programáticamente y crear dashboards

**Acceptance Criteria:**
- [ ] Logs en formato JSON opcional
- [ ] Niveles de log configurables (DEBUG, INFO, WARN, ERROR)
- [ ] Metadata útil en cada log (timestamp, source, level)
- [ ] Rotación de logs configurada
- [ ] Logs sensibles filtrados automáticamente
- [ ] Integración con herramientas de análisis (ELK, Grafana Loki)
- [ ] Script de conversión de logs legacy a JSON

**Tareas:**
1. `json-logging` - Implementar logs en JSON
2. `log-levels` - Sistema de niveles de log
3. `log-rotation` - Configurar rotación de logs
4. `sensitive-filter` - Filtro de datos sensibles
5. `log-analytics` - Integración con herramientas

**Ejemplo de Output JSON:**
```json
{
  "timestamp": "2025-10-25T01:45:23.123Z",
  "level": "INFO",
  "source": "cloudflare-tunnel",
  "message": "Tunnel established successfully",
  "metadata": {
    "tunnel_id": "abc-123-***",
    "url": "amazing-server-123.trycloudflare.com",
    "latency_ms": 45,
    "status": "healthy"
  }
}
```

---

### US-38: Dashboard de Logs en Tiempo Real

**Story Points:** 5  
**Prioridad:** Baja  
**Issue:** TBD

**Como** administrador  
**Quiero** ver logs en tiempo real en un dashboard web  
**Para** monitorear el servidor sin usar la terminal

**Acceptance Criteria:**
- [ ] Dashboard web simple para ver logs
- [ ] Filtros por nivel (INFO, WARN, ERROR)
- [ ] Filtros por fuente (Minecraft, Tunnel, System)
- [ ] Búsqueda en logs
- [ ] Auto-refresh de logs
- [ ] Exportación de logs
- [ ] Sin dependencias pesadas (HTML/CSS/JS vanilla)

**Tareas:**
1. `log-dashboard-ui` - Crear interfaz web
2. `log-api` - API para exponer logs
3. `log-filters` - Implementar filtros
4. `log-search` - Búsqueda en logs
5. `log-export` - Exportación de logs

**Nota:** Este US es opcional y puede moverse a un sprint futuro si no hay tiempo.

---

## 📦 Entregables del Sprint

### Scripts

- [ ] `scripts/tunnel/get-tunnel-url.sh` - Extraer URL del tunnel
- [ ] `scripts/monitoring/log-analyzer.sh` - Analizar logs
- [ ] `scripts/utils/format-logs.sh` - Formatear logs legacy
- [ ] `scripts/utils/filter-sensitive-data.sh` - Filtrar datos sensibles

### Configuración

- [ ] `config/logging.yml` - Configuración de logging
- [ ] `config/logrotate.conf` - Rotación de logs
- [ ] `.env` - Variables de logging

### Docker

- [ ] Actualizar `docker/compose/tunnel/docker-compose.tunnel*.yml` con mejor logging
- [ ] Actualizar `docker/Dockerfile` con configuración de logs

### Documentación

- [ ] `docs/monitoring/LOGGING.md` - Guía completa de logging
- [ ] `docs/troubleshooting/LOG_ANALYSIS.md` - Análisis de logs
- [ ] Actualizar `docs/deployment/CLOUDFLARE_TUNNEL.md` con info de logs

### Opcional (Dashboard)

- [ ] `dashboard/logs/index.html` - Dashboard de logs
- [ ] `dashboard/logs/api.js` - API de logs

---

## 📋 Plan de Trabajo Detallado

### Semana 1: Mejora de Logs Core (Días 1-7)

#### Día 1-3: Cloudflare Tunnel Logs (US-35)

**Branch:** `task/us35-tunnel-logs`

**Tareas:**
1. Modificar scripts de tunnel para mejor output
2. Crear wrapper para cloudflared con logs mejorados
3. Script para extraer URL automáticamente
4. Testing de diferentes escenarios

**Deliverables:**
- Logs mejorados del tunnel
- Script `get-tunnel-url.sh`
- Documentación actualizada

---

#### Día 4-5: Tiempos de Carga (US-36)

**Branch:** `task/us36-startup-timing`

**Tareas:**
1. Implementar timer de startup
2. Agregar logs de timing a cada fase
3. Progress indicators
4. Resumen de startup
5. Testing

**Deliverables:**
- Logs con tiempos de carga
- Progress bars durante startup
- Resumen de performance

---

#### Día 6-7: Logs Estructurados (US-37 - Parte 1)

**Branch:** `task/us37-structured-logging`

**Tareas:**
1. Implementar logging en JSON
2. Sistema de niveles de log
3. Configuración de logging
4. Testing básico

**Deliverables:**
- Logs en formato JSON
- Configuración de niveles

---

### Semana 2: Observability y Pulido (Días 8-14)

#### Día 8-10: Logs Estructurados Avanzado (US-37 - Parte 2)

**Branch:** `task/us37-structured-logging` (continuación)

**Tareas:**
1. Rotación de logs
2. Filtro de datos sensibles
3. Integración con herramientas
4. Testing avanzado

**Deliverables:**
- Log rotation configurado
- Filtros de seguridad
- Documentación de integración

---

#### Día 11-12: Dashboard de Logs (US-38 - Opcional)

**Branch:** `task/us38-log-dashboard`

**Tareas:**
1. Dashboard web simple
2. API de logs
3. Filtros y búsqueda
4. Testing

**Deliverables:**
- Dashboard funcional
- API documentada

**Nota:** Si falta tiempo, este US puede saltarse.

---

#### Día 13-14: Testing Final y Documentación

**Branch:** `sprint/7` (merge final)

**Tareas:**
1. Testing end-to-end de todos los logs
2. Documentación completa
3. Guía de troubleshooting basada en logs
4. Ejemplos de uso
5. Sprint retrospective

**Deliverables:**
- Testing completo
- Documentación final
- Sprint completado

---

## ✅ Definition of Done

Para considerar el sprint completo:

- [ ] Logs del tunnel muestran URL claramente
- [ ] Tiempos de carga visibles y útiles
- [ ] Logs estructurados implementados
- [ ] Datos sensibles filtrados
- [ ] Documentación completa
- [ ] Testing passing
- [ ] No degradación de performance
- [ ] Logs legibles tanto para humanos como para máquinas

---

## 🎯 Checklist de Implementación

### Logs del Tunnel ✅
- [ ] URL mostrada prominentemente
- [ ] Estados claros (connecting, connected, failed)
- [ ] Métricas de conexión
- [ ] Script de extracción de URL
- [ ] Integración con docker logs

### Tiempos de Carga ✅
- [ ] Timer en cada fase
- [ ] Progress indicators
- [ ] Logs de plugins/mods
- [ ] Resumen de startup
- [ ] Warnings de lentitud

### Logs Estructurados ✅
- [ ] Formato JSON implementado
- [ ] Niveles de log (DEBUG, INFO, WARN, ERROR)
- [ ] Rotación configurada
- [ ] Filtro de datos sensibles
- [ ] Metadata completa

### Seguridad en Logs ✅
- [ ] Tokens ofuscados
- [ ] IPs privadas filtradas
- [ ] Passwords nunca logueados
- [ ] Variables de entorno sensibles protegidas
- [ ] Documentación de qué NO loguear

---

## 📊 Priorización

### Must Have (Crítico)
- ✅ US-35: Logs de Cloudflare Tunnel
- ✅ US-36: Tiempos de carga

### Should Have (Importante)
- ✅ US-37: Logs estructurados

### Could Have (Opcional)
- ⚠️ US-38: Dashboard de logs (puede moverse a Sprint 8)

---

## 🚧 Riesgos y Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| Logs muy verbosos afectan performance | Media | Medio | Niveles de log configurables, modo producción menos verboso |
| Datos sensibles accidentalmente logueados | Baja | Alto | Filtros automáticos, code review estricto |
| Formato de logs rompe herramientas existentes | Baja | Medio | Mantener compatibilidad con formato anterior |
| Dashboard consume muchos recursos | Media | Bajo | Hacer opcional, optimizar queries |

---

## 🔗 Recursos y Referencias

### Mejores Prácticas de Logging

- **12 Factor App - Logs:** https://12factor.net/logs
- **Structured Logging:** https://www.honeycomb.io/blog/structured-logging-and-your-team
- **Log Levels Best Practices:** https://stackoverflow.com/questions/2031163/when-to-use-the-different-log-levels

### Herramientas

- **Logrotate:** https://linux.die.net/man/8/logrotate
- **jq:** https://stedolan.github.io/jq/ (para analizar JSON logs)
- **Grafana Loki:** https://grafana.com/oss/loki/
- **ELK Stack:** https://www.elastic.co/elk-stack

---

## 🎓 Lecciones Aprendidas (Post-Sprint)

*A completar después del sprint*

### ¿Qué funcionó bien?
- TBD

### ¿Qué podría mejorar?
- TBD

### ¿Qué aprendimos?
- TBD

---

## 🚀 Próximos Pasos (Post-Sprint 7)

Después de completar logging:

1. **Sprint 8: Testing & QA**
   - Testing automatizado completo
   - Integration tests
   - Load testing

2. **Sprint 9: API Integration**
   - API REST para gestión
   - Webhooks
   - Integración con servicios externos

3. **Sprint 10: Advanced Features**
   - Sistema de plugins dinámicos
   - Multi-tenancy
   - Auto-scaling

---

**Created:** 2025-10-25  
**Version:** v1.2.0 (Planning)

**¡A mejorar los logs! 📊🔍**

