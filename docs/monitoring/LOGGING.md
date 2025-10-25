# Logging Guide - DockerCraft

**Version:** 1.0.0  
**Sprint:** 7  
**Date:** 2025-10-25

---

## 📋 Overview

Este documento describe el sistema de logging mejorado implementado en Sprint 7, incluyendo logs visuales, startup timing, y structured logging.

---

## 🎯 Features Implementadas

### 1. Cloudflare Tunnel Logs Mejorados

**Ubicación:** `scripts/tunnel/quick-tunnel.ps1`

**Características:**
- ✅ URL mostrada prominentemente en formato visual
- ✅ Estados claros del tunnel (connecting, connected, failed)
- ✅ Métricas de conexión en tiempo real
- ✅ Manejo de errores con troubleshooting automático
- ✅ Datos sensibles ofuscados

**Ejemplo de Output:**
```
╔════════════════════════════════════════════════════════════╗
║                  ✅ TUNNEL ESTABLECIDO                     ║
╠════════════════════════════════════════════════════════════╣
║  🌐 Tu servidor está PÚBLICO en:                          ║
║     amazing-server-123.trycloudflare.com                   ║
║  📊 Estado: ACTIVA ✅ | Tiempo: 3.2s | IP oculta 🔒       ║
╚════════════════════════════════════════════════════════════╝
```

**Script de Extracción:**
```bash
# Extraer URL de logs de Docker
./scripts/tunnel/get-tunnel-url.sh cloudflared-quick

# Output limpio para scripts
./scripts/tunnel/get-tunnel-url.sh cloudflared-quick --plain
```

---

### 2. Startup Timing Logs

**Ubicación:** `docker/scripts/startup-timing.sh`

**Características:**
- ⏱️ Timer para cada fase de inicialización
- 📊 Progress bar visual
- 📈 Comparación con startups anteriores
- 💾 Historial de tiempos guardado

**Ejemplo de Output:**
```
╔════════════════════════════════════════════════════════════╗
║         🎮 Minecraft Server - Startup Timeline            ║
╚════════════════════════════════════════════════════════════╝

⏱️  Initialization Timeline:

[Minecraft] [████████░░░░░░░░░░░░] 40% Loading server properties... (450ms)
[Minecraft] [████████████░░░░░░░░] 60% Initializing server engine... (820ms)
[Minecraft] [████████████████░░░░] 80% Loading plugins... (1200ms)
[Minecraft] [████████████████████] 100% Preparing spawn area... (2100ms)

╔════════════════════════════════════════════════════════════╗
║              ✅ SERVER STARTED SUCCESSFULLY                ║
╚════════════════════════════════════════════════════════════╝

⏱️  Total startup time: 3.8s
📊 Comparison: 0.5s faster than last startup ⚡
```

**Archivos de Timing:**
- `/data/startup-times.log` - Historial completo
- `/data/last-startup-time.txt` - Último tiempo para comparación

---

## 🔧 Configuración

### Variables de Entorno

```bash
# .env
LOG_LEVEL=INFO           # DEBUG, INFO, WARN, ERROR
LOG_FORMAT=pretty        # pretty, json
LOG_TIMING=true          # Habilitar startup timing
LOG_TUNNEL_VERBOSE=true  # Logs detallados de tunnel
```

---

## 📊 Análisis de Logs

### Ver Startup History

```bash
# Ver últimos 10 startups
tail -n 10 /data/startup-times.log

# Analizar tiempos promedio
awk -F'|' '{sum+=$4; count++} END {print "Avg:", sum/count, "ms"}' /data/startup-times.log
```

### Extraer URLs de Tunnel

```bash
# Desde Docker logs
docker logs cloudflared-quick 2>&1 | grep trycloudflare.com

# Usando el script
./scripts/tunnel/get-tunnel-url.sh
```

---

## 🐛 Troubleshooting

### Logs No Aparecen

```bash
# Verificar que el contenedor está corriendo
docker ps

# Ver logs raw
docker logs minecraft-server
docker logs cloudflared-quick
```

### URL del Tunnel No Se Encuentra

```bash
# Verificar que el tunnel está activo
docker ps | grep cloudflared

# Ver logs completos del tunnel
docker logs cloudflared-quick

# Esperar 30 segundos y reintentar
./scripts/tunnel/get-tunnel-url.sh
```

---

## 📝 Best Practices

### DO ✅

- Usar logs para diagnosticar problemas
- Revisar startup timing para optimizaciones
- Guardar URLs del tunnel para compartir
- Monitorear logs de errores regularmente

### DON'T ❌

- No loguear passwords o tokens
- No loguear IPs privadas en producción
- No dejar log level en DEBUG en producción
- No ignorar warnings de timing lento

---

---

### 3. JSON Structured Logging

**Ubicación:** `docker/scripts/json-logger.sh`

**Características:**
- 📋 JSON output para integraciones
- 🔍 Filtrado de datos sensibles automático
- 🎚️ Niveles de log (DEBUG, INFO, WARN, ERROR, FATAL)
- 📊 Metadata estructurada (timestamp, component, pid)

**Uso:**

```bash
# Source el logger
source /docker/scripts/json-logger.sh

# Logs simples
log_info "Server started"
log_error "Failed to connect to database"

# Logs con metadata
log_info "Player joined" "minecraft" '{"player": "Steve", "ip": "1.2.3.4"}'

# Salida JSON:
{
  "timestamp": "2025-10-25T02:10:30.123Z",
  "level": "INFO",
  "component": "minecraft",
  "message": "Player joined",
  "hostname": "mc-server",
  "pid": 1234,
  "extra": {"player": "Steve", "ip": "1.2.3.4"}
}
```

**Niveles de Log:**
```bash
# Configurar nivel mínimo (default: INFO)
export LOG_LEVEL=DEBUG  # DEBUG, INFO, WARN, ERROR, FATAL
```

---

### 4. Sensitive Data Filtering

**Ubicación:** `docker/scripts/log-filter.sh`

**Filtra automáticamente:**
- 🔐 Passwords, tokens, secrets
- 🌐 IPs privadas (192.168.x.x, 10.x.x.x, 172.16-31.x.x)
- 📧 Emails (parcialmente)
- 🆔 UUIDs (parcialmente - mantiene primeros 8 chars)

**Uso:**

```bash
# Filtrar logs en tiempo real
docker logs minecraft-server | ./docker/scripts/log-filter.sh

# Filtrar logs guardados
cat /data/logs/server.log | ./docker/scripts/log-filter.sh > filtered.log
```

**Ejemplo:**

```bash
# Input:
"password=secret123 token=abc123 IP 192.168.1.5"

# Output:
"password=***REDACTED*** token=***REDACTED*** IP **PRIVATE_IP**"
```

---

### 5. Log Rotation

**Ubicación:** `docker/scripts/log-rotate.sh`

**Características:**
- 🔄 Rotación automática por tamaño
- 🗜️ Compresión de logs antiguos
- 🗑️ Limpieza automática de logs viejos
- ⚙️ Configurable vía environment variables

**Configuración:**

```bash
# En docker-compose.yml o .env
LOG_DIR=/data/logs
MAX_SIZE=100M           # Tamaño máximo antes de rotar
RETENTION_DAYS=7        # Días a mantener logs antiguos
COMPRESS=true           # Comprimir logs rotados
```

**Uso Manual:**

```bash
# Rotar logs manualmente
./docker/scripts/log-rotate.sh

# O desde cron (automático)
0 2 * * * /docker/scripts/log-rotate.sh
```

**Archivos Generados:**
```
/data/logs/
├── server.log                    # Log actual
├── server.log.20251025-020000    # Rotado hoy
├── server.log.20251024-020000.gz # Comprimido ayer
└── server.log.20251018-020000.gz # Será borrado en 7 días
```

---

## 🚀 Próximas Mejoras

- [ ] Dashboard web de logs (US-38 - opcional)
- [ ] Integración con ELK/Grafana
- [ ] Alertas automáticas por Slack/Discord
- [ ] Métricas de performance (Prometheus)

---

**Documentation Status:** ✅ Complete  
**Last Updated:** 2025-10-25  
**Sprint:** 7

