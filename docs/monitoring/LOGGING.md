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

## 🚀 Próximas Mejoras

- [ ] JSON structured logging (US-37)
- [ ] Log rotation automático
- [ ] Filtros de datos sensibles
- [ ] Dashboard web de logs (US-38 - opcional)
- [ ] Integración con ELK/Grafana

---

**Documentation Status:** ✅ Complete  
**Last Updated:** 2025-10-25  
**Sprint:** 7

