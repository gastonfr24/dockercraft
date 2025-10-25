# 🌐 Guía de Deployment Público - DockerCraft

> Guía paso a paso para hacer tu servidor de Minecraft accesible desde internet

**Última actualización:** 2025-10-25  
**Versión:** v1.1  
**Tiempo estimado:** 2-3 horas

---

## 📋 Prerequisitos

Antes de comenzar, necesitas:

- ✅ Servidor corriendo localmente (ver Quick Start en README.md)
- ✅ Acceso a tu router para configurar port forwarding
- ✅ PC/servidor que pueda estar encendido 24/7
- ✅ Conexión a internet estable
- ✅ Ubuntu/Debian (para scripts de firewall)

**Opcional pero recomendado:**
- 📧 Cuenta de Discord para alertas
- ☁️ Cuenta de Google Drive/Dropbox para backups
- 🌐 Dominio o DuckDNS configurado

---

## 🚀 Paso 1: Configuración de Producción

### 1.1 Crear Configuración de Producción

```bash
# Copiar template
cp docs/templates/env.production.template .env.production

# Editar configuración
nano .env.production
```

**Variables críticas a cambiar:**

```bash
# ⚠️ CAMBIAR ESTOS VALORES

# Password RCON (generar uno seguro)
RCON_PASSWORD=tu_password_super_seguro_aqui

# Tu zona horaria
TZ=America/Argentina/Buenos_Aires

# Dominio o IP pública (agregar después)
SERVER_DOMAIN=mi-servidor.duckdns.org

# Webhook de Discord para alertas (opcional)
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/...
```

### 1.2 Crear Whitelist Inicial

```bash
# Copiar ejemplo
cp whitelist.json.example whitelist.json

# Editar y agregar tus jugadores
nano whitelist.json
```

**Formato:**
```json
[
  {
    "uuid": "UUID-del-jugador",
    "name": "nombre_jugador"
  }
]
```

> **Tip:** Obtener UUID en https://mcuuid.net/

### 1.3 Testing Local

```bash
# Probar configuración
docker compose --env-file .env.production config

# Levantar en modo prueba
docker compose --env-file .env.production -f docker-compose.prod.yml up

# Verificar logs
# Si todo está bien, Ctrl+C y continuar
```

---

## 🌐 Paso 2: Networking

### 2.1 Obtener IP Pública

```bash
./scripts/get-public-ip.sh
```

**Resultado esperado:**
```
🌐 Obteniendo IP pública...
✅ Tu IP pública es: 123.456.789.012
```

**Anota esta IP**, la necesitarás para:
- Port forwarding
- Testing de conectividad
- Compartir con jugadores

### 2.2 Configurar Port Forwarding en Router

**Pasos generales** (varía según tu router):

1. **Acceder al router**
   ```
   http://192.168.1.1
   o
   http://192.168.0.1
   ```
   Usuario/contraseña (check etiqueta del router o manual)

2. **Encontrar sección**
   - "Port Forwarding"
   - "Virtual Server"
   - "NAT"
   - "Applications"

3. **Crear nueva regla:**
   ```
   Service Name: Minecraft
   External Port: 25565
   Internal Port: 25565
   Internal IP: [IP de tu PC] (ej: 192.168.1.100)
   Protocol: TCP/UDP o Both
   ```

4. **Guardar y aplicar**

**Para encontrar tu IP local:**
```bash
# Linux/Mac
hostname -I | awk '{print $1}'

# Windows PowerShell
(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "*Loopback*"}).IPAddress
```

### 2.3 Configurar DuckDNS (Opcional)

Si tu IP es dinámica, usa DuckDNS:

1. **Registrarse:** https://www.duckdns.org/
2. **Elegir subdominio:** `mi-servidor.duckdns.org`
3. **Obtener token**
4. **Instalar script de actualización:**

```bash
# Crear script
cat > scripts/update-duckdns.sh <<'EOF'
#!/bin/bash
DOMAIN="mi-servidor"
TOKEN="tu-token-aqui"
curl "https://www.duckdns.org/update?domains=${DOMAIN}&token=${TOKEN}&ip="
EOF

chmod +x scripts/update-duckdns.sh

# Agregar a crontab (actualizar cada 5 min)
crontab -e
# Agregar: */5 * * * * /path/to/scripts/update-duckdns.sh
```

---

## 🛡️ Paso 3: Seguridad

### 3.1 Configurar Firewall (UFW)

```bash
# Ejecutar script (requiere sudo)
sudo ./scripts/configure-firewall-prod.sh
```

**Resultado esperado:**
```
🛡️  Configurando firewall para producción...
✅ UFW instalado
✅ Políticas por defecto configuradas
✅ Puerto SSH permitido
✅ Puerto Minecraft permitido con rate limiting
✅ UFW habilitado
```

**Verificar:**
```bash
sudo ufw status verbose
```

### 3.2 Instalar Fail2Ban

```bash
# Ejecutar script (requiere sudo)
sudo ./scripts/install-fail2ban.sh
```

**Resultado esperado:**
```
🚫 Instalación de Fail2Ban (Anti-DDoS)
✅ Fail2Ban instalado
✅ Jail de Minecraft creado
✅ Filtros creados
```

**Verificar:**
```bash
sudo fail2ban-client status
sudo fail2ban-client status minecraft-auth
```

### 3.3 Security Hardening (Opcional pero recomendado)

```bash
sudo ./scripts/security-hardening.sh
```

---

## 🚀 Paso 4: Deployment

### 4.1 Deployment Automatizado

```bash
# Ejecutar script de deployment
sudo ./scripts/deploy-production.sh
```

**El script hará:**
1. ✅ Verificar prerrequisitos
2. ✅ Crear backup (si hay datos existentes)
3. ✅ Aplicar security hardening (opcional)
4. ✅ Configurar firewall (opcional)
5. ✅ Build de imagen Docker
6. ✅ Levantar servicios
7. ✅ Verificar health checks

**Tiempo estimado:** 3-5 minutos

### 4.2 Verificar Deployment

```bash
# Ver estado
docker compose -f docker-compose.prod.yml ps

# Ver logs
docker compose -f docker-compose.prod.yml logs --tail=50

# Verificar health
docker inspect --format='{{.State.Health.Status}}' mc-server-prod
```

---

## 🧪 Paso 5: Testing de Acceso Público

### 5.1 Test Automático

```bash
./scripts/test-public-access.sh
```

**Resultado esperado:**
```
🔍 Testing acceso público al servidor...
🌐 IP pública: 123.456.789.012
📡 Test 1: Verificando puerto 25565...
  ✅ Puerto 25565 está abierto
🌍 Test 2: Query via mcsrvstat.us...
  ✅ Servidor ONLINE y accesible desde internet
```

### 5.2 Test Manual desde Minecraft

1. Abrir Minecraft Java Edition
2. Multijugador → Agregar Servidor
3. Dirección: `tu-ip-publica:25565` o `tu-dominio.duckdns.org:25565`
4. Conectar

**Si no puedes conectar, ver sección Troubleshooting abajo.**

---

## 👥 Paso 6: Gestión de Whitelist

### 6.1 Agregar Jugadores

```bash
# Agregar jugador
./scripts/whitelist-add.sh mc-server-prod NombreJugador

# Listar jugadores
./scripts/whitelist-list.sh mc-server-prod

# Remover jugador
./scripts/whitelist-remove.sh mc-server-prod NombreJugador
```

### 6.2 Gestión via RCON

```bash
# Conectar a RCON
docker exec -it mc-server-prod rcon-cli

# Comandos útiles:
whitelist add <jugador>
whitelist remove <jugador>
whitelist list
list
say Mensaje a todos
```

---

## 📊 Paso 7: Monitoring y Mantenimiento

### 7.1 Configurar Monitoring de Uptime

```bash
# Editar crontab
crontab -e

# Agregar (verificar cada 5 minutos):
*/5 * * * * /path/to/dockercraft/scripts/uptime-monitor.sh
```

### 7.2 Configurar Backups Automáticos

```bash
# Instalar rclone
sudo apt install rclone

# Configurar remoto
rclone config
# Seguir wizard para Google Drive/Dropbox/etc

# Editar .env.production
RCLONE_REMOTE=gdrive
RCLONE_REMOTE_DIR=minecraft-backups

# Agregar a crontab (backup diario a las 3 AM):
0 3 * * * /path/to/dockercraft/scripts/backup-to-cloud.sh
```

### 7.3 Configurar Mantenimiento Semanal

```bash
# Agregar a crontab (domingos 4 AM):
0 4 * * 0 /path/to/dockercraft/scripts/maintenance-window.sh
```

---

## ❓ Troubleshooting

### No puedo conectarme al servidor

**Checklist:**

1. **Verificar servidor corriendo:**
   ```bash
   docker compose -f docker-compose.prod.yml ps
   ```

2. **Verificar puerto abierto:**
   ```bash
   sudo ufw status | grep 25565
   ```

3. **Verificar port forwarding:**
   - Re-check configuración en router
   - Confirmar IP local correcta

4. **Testing desde diferentes ubicaciones:**
   ```bash
   # Test local
   nc -zv localhost 25565
   
   # Test público
   nc -zv tu-ip-publica 25565
   ```

5. **Verificar whitelist:**
   ```bash
   ./scripts/whitelist-list.sh
   # Asegúrate de estar en la lista
   ```

### Error: "Server outdated" o "Client outdated"

- Verificar que estás usando la versión correcta de Minecraft
- Versión del servidor: ver `.env.production` → `VERSION`

### Lag o alta latencia

- Verificar recursos del servidor:
  ```bash
  docker stats mc-server-prod
  ```
- Verificar TPS:
  ```bash
  docker exec mc-server-prod rcon-cli tps
  ```
- Considerar reducir `VIEW_DISTANCE` en `.env.production`

### Servidor caído

- Ver logs:
  ```bash
  docker compose -f docker-compose.prod.yml logs --tail=100
  ```
- Reiniciar:
  ```bash
  docker compose -f docker-compose.prod.yml restart
  ```
- Restaurar desde backup:
  ```bash
  ./scripts/restore.sh ./backups/backup-YYYYMMDD-HHMMSS.tar.gz
  ```

---

## 📝 Comandos Útiles

### Gestión del Servidor

```bash
# Ver logs en tiempo real
docker compose -f docker-compose.prod.yml logs -f

# Ver estado
docker compose -f docker-compose.prod.yml ps

# Reiniciar
docker compose -f docker-compose.prod.yml restart

# Detener
docker compose -f docker-compose.prod.yml stop

# Iniciar
docker compose -f docker-compose.prod.yml start

# Ver recursos (CPU, RAM)
docker stats mc-server-prod

# Ejecutar comandos RCON
docker exec mc-server-prod rcon-cli <comando>
```

### Backups

```bash
# Backup manual
./scripts/backup.sh mc-server-prod

# Backup a la nube
./scripts/backup-to-cloud.sh mc-server-prod

# Listar backups
ls -lh backups/

# Restaurar
./scripts/restore.sh backups/backup-YYYYMMDD-HHMMSS.tar.gz
```

### Monitoring

```bash
# Ver jugadores online
docker exec mc-server-prod rcon-cli list

# Ver TPS
docker exec mc-server-prod rcon-cli tps

# Test de conectividad
./scripts/test-public-access.sh

# Monitoring manual
./scripts/monitor.sh mc-server-prod
```

---

## 🔒 Best Practices de Seguridad

1. ✅ **Cambiar RCON password** - No usar el default
2. ✅ **Whitelist activado** - Solo jugadores autorizados
3. ✅ **ONLINE_MODE=true** - Verificación con Mojang
4. ✅ **Firewall activo** - UFW configurado
5. ✅ **Fail2Ban running** - Anti-DDoS básico
6. ✅ **Backups automáticos** - Mínimo diarios
7. ✅ **Monitoring activo** - Alertas configuradas
8. ✅ **Logs monitoreados** - Revisar regularmente
9. ✅ **SSH key-based** - No password auth
10. ✅ **Updates regulares** - Sistema y Docker

---

## 💰 Costos Estimados

### Hosting desde PC

| Item | Costo |
|------|-------|
| Electricidad (24/7) | ~$10-20/mes |
| Dominio DuckDNS | Gratis |
| **Total** | **$10-20/mes** |

**Pros:**
- ✅ Control total
- ✅ Sin límites de recursos
- ✅ Barato

**Contras:**
- ❌ PC debe estar encendida 24/7
- ❌ IP doméstica
- ❌ Upload speed limitado

### VPS (Alternativa)

| Proveedor | RAM | Precio/mes |
|-----------|-----|------------|
| DigitalOcean | 4GB | $24 |
| Hetzner | 4GB | ~$6 |
| OVH | 4GB | ~$10 |

**Pros:**
- ✅ Uptime garantizado
- ✅ IP estática
- ✅ Ancho de banda alto

**Contras:**
- ❌ Más caro
- ❌ Límites de recursos

---

## 📚 Recursos Adicionales

### Herramientas

- **mcsrvstat.us** - Check status del servidor
- **mcstatus.io** - Monitoring de uptime
- **UptimeRobot** - Alertas gratis (50 monitors)

### Comunidades

- **r/admincraft** - Reddit para admins
- **Discord de Paper** - Soporte técnico
- **SpigotMC Forums** - Plugins y ayuda

### Documentación

- Paper: https://docs.papermc.io/
- Docker: https://docs.docker.com/
- UFW: https://help.ubuntu.com/community/UFW

---

## ✅ Checklist Final

Antes de considerar el deployment completo:

### Seguridad
- [ ] UFW activo y configurado
- [ ] Fail2Ban instalado
- [ ] Whitelist activado
- [ ] ONLINE_MODE=true
- [ ] RCON password cambiado
- [ ] Backups automáticos configurados

### Networking
- [ ] IP pública conocida
- [ ] Port forwarding activo
- [ ] DNS configurado (si aplica)
- [ ] Conectividad verificada desde internet

### Monitoring
- [ ] Uptime monitor configurado
- [ ] Alertas de Discord/Slack funcionando
- [ ] Backups automáticos testeados

### Documentación
- [ ] Jugadores saben cómo conectarse
- [ ] Reglas del servidor publicadas
- [ ] Contacto de soporte definido

---

## 🆘 Soporte

Si tienes problemas:

1. **Revisar logs:** `docker compose logs`
2. **Consultar troubleshooting** en esta guía
3. **Revisar issues:** https://github.com/gastonfr24/dockercraft/issues
4. **Preguntar en Discord/comunidad**

---

**¡Tu servidor está listo para recibir jugadores! 🎮🌐**

Para compartir con jugadores:
```
Servidor: tu-ip-o-dominio.duckdns.org:25565
Versión: 1.21.1 (Paper)
Whitelist: Contactar al admin para acceso
```

