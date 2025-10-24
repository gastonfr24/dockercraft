# 🔄 Workflows y Procedimientos - DockerCraft

> **Última actualización:** 2025-10-24  
> **Versión:** v0.1.0-alpha

Este documento describe los flujos de trabajo y procedimientos para trabajar con este proyecto.

---

## 🚀 Workflow: Uso Local (Testing)

### **Escenario: Probar servidor standalone**

```bash
# 1. Clonar repositorio
git clone <repo-url>
cd dockercraft

# 2. Copiar variables de entorno
cp .env.example .env

# 3. (Opcional) Ajustar configuración en .env
nano .env

# 4. Levantar servidor
docker-compose up -d

# 5. Ver logs
docker-compose logs -f

# 6. Conectarse desde Minecraft cliente
# Server address: localhost:25565

# 7. Detener servidor
docker-compose down

# 8. Detener Y eliminar volúmenes (CUIDADO: borra mundos)
docker-compose down -v
```

---

## 🏗️ Workflow: API Externa Crea Instancia

### **Escenario: API crea nuevo servidor desde este template**

```bash
# La API externa ejecutaría algo similar a:

# 1. Build de la imagen (una vez, o usar pre-built)
docker build -t dockercraft-mc:latest .

# 2. Crear volumen para datos
docker volume create mc-server-{id}-data

# 3. Crear contenedor con config específica
docker run -d \
  --name mc-server-{id} \
  -p {dynamic-port}:25565 \
  -e VERSION=1.21.1 \
  -e TYPE=PAPER \
  -e MEMORY=4G \
  -e MAX_PLAYERS=20 \
  -e DIFFICULTY=normal \
  -e GAMEMODE=survival \
  -e PVP=true \
  -e MOTD="Mi Servidor Custom" \
  -e EULA=TRUE \
  -e ENABLE_AUTOPAUSE=TRUE \
  -v mc-server-{id}-data:/data \
  --restart unless-stopped \
  dockercraft-mc:latest

# 4. Verificar estado
docker ps | grep mc-server-{id}

# 5. Ver logs
docker logs -f mc-server-{id}

# 6. Detener servidor
docker stop mc-server-{id}

# 7. Iniciar servidor
docker start mc-server-{id}

# 8. Eliminar servidor (y opcionalmente volumen)
docker rm mc-server-{id}
docker volume rm mc-server-{id}-data  # Si se quiere eliminar datos
```

---

## 🔧 Workflow: Desarrollo y Testing

### **Escenario: Hacer cambios en Dockerfile**

```bash
# 1. Hacer cambios en Dockerfile
nano Dockerfile

# 2. Rebuild imagen
docker build -t dockercraft-mc:dev .

# 3. Detener contenedor anterior (si existe)
docker-compose down

# 4. Actualizar docker-compose.yml para usar imagen :dev
# O build directamente:
docker-compose up --build -d

# 5. Probar cambios
docker-compose logs -f

# 6. Si funciona, commit cambios
git add Dockerfile
git commit -m "feat: mejora en Dockerfile"
git push
```

---

### **Escenario: Probar múltiples servidores simultáneamente**

```bash
# 1. Usar docker-compose.multi.yml (ejemplo con 3 servidores)
docker-compose -f docker-compose.multi.yml up -d

# 2. Ver todos los servidores
docker-compose -f docker-compose.multi.yml ps

# 3. Ver logs de servidor específico
docker-compose -f docker-compose.multi.yml logs -f mc-server-1

# 4. Detener todos
docker-compose -f docker-compose.multi.yml down
```

---

## 🩺 Workflow: Health Check y Diagnóstico

### **Verificar estado del contenedor**

```bash
# Estado general
docker ps -a

# Health check status
docker inspect --format='{{.State.Health.Status}}' mc-server-1

# Logs del health check
docker inspect --format='{{range .State.Health.Log}}{{.Output}}{{end}}' mc-server-1

# Stats en tiempo real
docker stats mc-server-1

# Uso de recursos
docker exec mc-server-1 ps aux
docker exec mc-server-1 free -h
```

---

### **Acceder al servidor para debugging**

```bash
# Shell interactivo
docker exec -it mc-server-1 bash

# Ver archivos de configuración
docker exec mc-server-1 cat /data/server.properties

# Ver logs de Minecraft
docker exec mc-server-1 tail -f /data/logs/latest.log

# Ejecutar comando RCON (si está habilitado)
docker exec mc-server-1 rcon-cli say "Hello from terminal!"

# Ver jugadores online
docker exec mc-server-1 rcon-cli list
```

---

## 🐛 Troubleshooting Común

### **Problema: Servidor no inicia**

**Síntomas:**
- Contenedor se detiene inmediatamente
- Status: Exited

**Diagnóstico:**
```bash
# Ver logs completos
docker logs mc-server-1

# Verificar que EULA=TRUE
docker inspect mc-server-1 | grep EULA

# Verificar permisos del volumen
docker exec mc-server-1 ls -la /data
```

**Soluciones:**
1. Asegurar `EULA=TRUE` en variables de entorno
2. Verificar que hay suficiente RAM en el host
3. Revisar logs para errores específicos

---

### **Problema: No puedo conectarme al servidor**

**Síntomas:**
- Servidor corriendo pero no responde
- "Connection refused" en cliente Minecraft

**Diagnóstico:**
```bash
# Verificar que el puerto está mapeado
docker port mc-server-1

# Verificar firewall
sudo ufw status | grep 25565

# Verificar que el servidor acepte conexiones
docker exec mc-server-1 netstat -tulpn | grep 25565

# Ping al servidor
ping localhost
```

**Soluciones:**
1. Verificar mapeo de puertos en docker run o docker-compose
2. Abrir puerto en firewall: `sudo ufw allow 25565/tcp`
3. Verificar que `online-mode` está correctamente configurado
4. Esperar a que el servidor termine de iniciar (ver logs)

---

### **Problema: Servidor muy lento / Lag**

**Síntomas:**
- TPS < 20
- Jugadores experimentan lag

**Diagnóstico:**
```bash
# Ver uso de recursos
docker stats mc-server-1

# Ver TPS en el servidor
docker exec mc-server-1 rcon-cli tps
```

**Soluciones:**
1. Aumentar RAM asignada (env `MEMORY`)
2. Reducir `view-distance` en server.properties
3. Reducir `max-players`
4. Verificar que el host tiene recursos disponibles
5. Revisar JVM flags en scripts/optimize-jvm.sh

---

### **Problema: Datos no persisten**

**Síntomas:**
- Al reiniciar contenedor, el mundo desaparece
- Configuraciones se resetean

**Diagnóstico:**
```bash
# Verificar que el volumen existe
docker volume ls | grep mc-server

# Verificar punto de montaje
docker inspect mc-server-1 | grep -A 5 Mounts
```

**Soluciones:**
1. Asegurar que se usa volumen named: `-v mc-data:/data`
2. NO usar volúmenes anónimos
3. NO eliminar volúmenes al detener: usar `docker-compose down` sin `-v`

---

### **Problema: Error "Cannot assign requested address"**

**Síntomas:**
- Servidor no puede bindearse al puerto
- Error en logs

**Diagnóstico:**
```bash
# Ver si el puerto ya está en uso
sudo lsof -i :25565
# o
sudo netstat -tulpn | grep 25565
```

**Soluciones:**
1. Detener otro proceso usando el puerto
2. Cambiar puerto en docker run: `-p 25566:25565`
3. En docker-compose, cambiar `"25565:25565"` a `"25566:25565"`

---

## 📋 Checklist de Pre-deployment

Antes de usar este template en producción, verificar:

### **Dockerfile y Configuración**
- [ ] EULA aceptado (env EULA=TRUE)
- [ ] Versión de Minecraft especificada
- [ ] Tipo de servidor correcto (PAPER/SPIGOT/etc)
- [ ] RAM apropiada para carga esperada
- [ ] Health check funciona correctamente
- [ ] Auto-pause configurado si se necesita

### **Networking**
- [ ] Puertos mapeados correctamente
- [ ] Firewall configurado
- [ ] Puerto no conflictúa con otros servicios

### **Persistencia**
- [ ] Volumen named para /data
- [ ] Volumen NO se elimina con contenedor
- [ ] Backups configurados (externa a este proyecto)

### **Seguridad**
- [ ] No exponer más puertos de los necesarios
- [ ] online-mode=true (validación de cuentas Mojang)
- [ ] whitelist activado si es privado
- [ ] Op permissions configurados

### **Recursos**
- [ ] RAM suficiente en host
- [ ] CPU cores disponibles
- [ ] Disk space para mundos (mínimo 5GB libre)
- [ ] Resource limits configurados (--memory, --cpus)

---

## 🔄 Workflow: Actualización de Versión de Minecraft

```bash
# 1. Detener servidor
docker stop mc-server-1

# 2. Backup del volumen (IMPORTANTE)
docker run --rm \
  -v mc-server-1-data:/data \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/mc-backup-$(date +%Y%m%d).tar.gz /data

# 3. Actualizar VERSION en env o docker-compose
nano docker-compose.yml  # Cambiar VERSION=1.21.1 a VERSION=1.21.2

# 4. Rebuild/pull nueva versión
docker-compose pull  # Si usa imagen pre-built
# o
docker-compose up --build  # Si build local

# 5. Iniciar servidor
docker-compose up -d

# 6. Monitorear logs para errores
docker-compose logs -f

# 7. Verificar que todo funciona
# Conectarse y probar

# 8. Si hay problemas, rollback:
docker-compose down
# Restaurar VERSION anterior
# Restaurar backup si es necesario
docker-compose up -d
```

---

## 📊 Workflow: Monitoreo de Recursos

### **Métricas a monitorear**

```bash
# CPU y RAM en tiempo real
watch docker stats mc-server-1

# Jugadores online
watch 'docker exec mc-server-1 rcon-cli list'

# TPS (ticks per second, debe ser ~20)
watch 'docker exec mc-server-1 rcon-cli tps'

# Tamaño del mundo
du -sh /var/lib/docker/volumes/mc-server-1-data/_data/world

# Logs en tiempo real
docker logs -f --tail 100 mc-server-1
```

---

## 🤖 Integración con API Externa

### **Cómo la API debe usar este proyecto**

1. **Build de imagen (una vez o en CI/CD)**
   ```bash
   docker build -t dockercraft-mc:v1.0 .
   docker tag dockercraft-mc:v1.0 dockercraft-mc:latest
   ```

2. **API crea nuevo servidor**
   ```javascript
   // Pseudo-código de la API
   const Docker = require('dockerode');
   const docker = new Docker();
   
   async function createMinecraftServer(config) {
     // 1. Obtener puerto disponible
     const port = await getAvailablePort();
     
     // 2. Crear volumen
     await docker.createVolume({
       Name: `mc-server-${config.id}-data`
     });
     
     // 3. Crear contenedor
     const container = await docker.createContainer({
       Image: 'dockercraft-mc:latest',
       name: `mc-server-${config.id}`,
       Env: [
         `VERSION=${config.version}`,
         `TYPE=${config.type}`,
         `MEMORY=${config.memory}`,
         `MAX_PLAYERS=${config.maxPlayers}`,
         `DIFFICULTY=${config.difficulty}`,
         `GAMEMODE=${config.gamemode}`,
         `PVP=${config.pvp}`,
         `MOTD=${config.motd}`,
         'EULA=TRUE',
         'ENABLE_AUTOPAUSE=TRUE'
       ],
       ExposedPorts: {
         '25565/tcp': {}
       },
       HostConfig: {
         PortBindings: {
           '25565/tcp': [{ HostPort: port.toString() }]
         },
         Binds: [`mc-server-${config.id}-data:/data`],
         Memory: parseMemory(config.memory),
         RestartPolicy: { Name: 'unless-stopped' }
       }
     });
     
     // 4. Iniciar contenedor
     await container.start();
     
     // 5. Retornar info
     return {
       id: config.id,
       containerId: container.id,
       port: port,
       status: 'starting'
     };
   }
   ```

3. **API controla servidor**
   ```javascript
   // Detener
   await container.stop();
   
   // Iniciar
   await container.start();
   
   // Reiniciar
   await container.restart();
   
   // Eliminar
   await container.remove();
   await docker.getVolume(`mc-server-${id}-data`).remove();
   ```

---

## 📝 Notas Finales

- Este proyecto es el **template base**, la lógica de orquestación va en la API
- Documentar cualquier cambio en variables de entorno en `.env.example`
- Mantener el Dockerfile lo más genérico posible
- Optimizaciones específicas deben ser configurables via ENV vars

---

**Próximo:** Leer `08_QUICK_START.md` para guía rápida de inicio

