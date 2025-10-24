# Troubleshooting Guide - DockerCraft

Soluciones a problemas comunes.

---

## 🚨 Problemas Comunes

### 1. Servidor no inicia

**Síntoma:** Container se detiene inmediatamente después de iniciar

**Solución:**
```bash
# Ver logs
docker logs mc-server-1

# Causa común: EULA no aceptada
# Fix: Editar .env
EULA=TRUE

# Reiniciar
docker-compose down
docker-compose up -d
```

---

### 2. Out of Memory

**Síntoma:** Server crashes con error de memoria

**Solución:**
```bash
# Incrementar memoria en .env
MEMORY=4G  # o más según necesites

# Reiniciar
docker-compose restart
```

---

### 3. RCON no responde

**Síntoma:** Scripts de backup fallan, rcon-cli no conecta

**Solución:**
```bash
# Verificar RCON está habilitado
docker exec mc-server-1 env | grep RCON

# Si no está, añadir a .env:
ENABLE_RCON=true
RCON_PASSWORD=tu-password

# Reiniciar
docker-compose restart
```

---

### 4. Health check falla

**Síntoma:** Container marcado como "unhealthy"

**Solución:**
```bash
# Ver estado
docker ps

# Verificar logs
docker logs mc-server-1 --tail 50

# Health check manual
bash scripts/health-check.sh mc-server-1
```

---

### 5. Backup falla

**Síntoma:** backup.sh retorna error

**Diagnóstico:**
```bash
# Ver logs del script
bash scripts/backup.sh mc-server-1 /backups

# Verificar permisos
ls -la /backups

# Verificar espacio en disco
df -h
```

**Solución:**
- Crear directorio de backups
- Verificar permisos de escritura
- Liberar espacio en disco

---

## 🔍 Comandos de Diagnóstico

```bash
# Estado del container
docker ps -a

# Logs en tiempo real
docker logs -f mc-server-1

# Uso de recursos
docker stats mc-server-1

# Inspeccionar container
docker inspect mc-server-1

# Verificar volúmenes
docker volume ls
docker volume inspect mc-server-1-data

# Verificar redes
docker network ls
docker network inspect minecraft-network

# Health check
docker inspect --format='{{.State.Health.Status}}' mc-server-1
```

---

## 📊 Logs y Debugging

```bash
# Últimas 50 líneas
docker logs mc-server-1 --tail 50

# Logs desde hace 10 minutos
docker logs mc-server-1 --since 10m

# Buscar errores
docker logs mc-server-1 2>&1 | grep -i error

# Consola del servidor (attach)
docker attach mc-server-1
# Salir: Ctrl+P, Ctrl+Q (NO Ctrl+C)
```

---

## 🐛 Performance Issues

### Servidor lento/lag

**Diagnóstico:**
```bash
# Ver TPS
docker exec mc-server-1 rcon-cli tps

# Ver uso de CPU/RAM
docker stats mc-server-1
```

**Soluciones:**
1. Incrementar memoria (MEMORY)
2. Reducir view distance (VIEW_DISTANCE)
3. Reducir simulation distance (SIMULATION_DISTANCE)
4. Optimizar con Aikar flags (USE_AIKAR_FLAGS=true)

---

## 🔒 Security Issues

### Container comprometido

```bash
# Ver procesos
docker top mc-server-1

# Ejecutar security scan
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image dockercraft:latest
```

---

## 💾 Problemas de Persistencia

### Datos se pierden al reiniciar

**Causa:** Volumen no configurado correctamente

**Solución:**
```bash
# Verificar volumen
docker volume inspect mc-server-1-data

# Si no existe, recrear con docker-compose
docker-compose down -v  # CUIDADO: borra datos!
docker-compose up -d
```

---

## 🌐 Problemas de Red

### No puedo conectarme al servidor

**Diagnóstico:**
```bash
# Verificar puerto abierto
netstat -tulpn | grep 25565

# En Windows:
netstat -an | findstr 25565

# Verificar firewall
sudo ufw status
```

**Soluciones:**
1. Abrir puerto 25565 en firewall
2. Verificar port mapping en docker-compose.yml
3. Usar IP correcta (localhost vs IP pública)

---

## 📞 Soporte

Si el problema persiste:

1. Recolectar información:
```bash
# Guardar logs
docker logs mc-server-1 > server-logs.txt

# Info del sistema
docker version > system-info.txt
docker info >> system-info.txt

# Configuración
cat .env >> system-info.txt
```

2. Crear Issue en GitHub:
   - https://github.com/gastonfr24/dockercraft/issues/new
   - Usar template de Bug Report
   - Adjuntar logs e info del sistema

---

**Última actualización:** 2025-10-24

