# Sprint 6 - Public Deployment & Authorization

**Fecha Inicio:** 2025-10-25  
**Estado:** Planning  
**Story Points:** 55  
**Duración:** 3 semanas

---

## 🎯 Objetivo del Sprint

Hacer el servidor de Minecraft accesible desde internet de forma segura, implementando sistema de autorización (whitelist) y monitoreo de producción.

---

## 📊 Métricas

- **Story Points Total:** 55
- **User Stories:** 5
- **Tareas Estimadas:** 20+
- **Duración Estimada:** 3 semanas

---

## 📝 User Stories

### US-26: Configuración de Producción

**Story Points:** 8  
**Prioridad:** Crítica  
**Issue:** TBD

**Como** administrador  
**Quiero** una configuración optimizada para producción  
**Para** que el servidor sea estable y seguro en ambiente público

**Acceptance Criteria:**
- [ ] `.env.production` con configuración segura
- [ ] `docker-compose.prod.yml` optimizado
- [ ] Script de deployment automatizado
- [ ] Recursos adecuados asignados (RAM, CPU)
- [ ] Logging configurado para producción
- [ ] Health checks funcionando

**Tareas:**
1. `prod-config` - Crear .env.production
2. `prod-compose` - Crear docker-compose.prod.yml
3. `deploy-script` - Script deploy-production.sh

---

### US-27: Networking y Firewall

**Story Points:** 13  
**Prioridad:** Crítica  
**Issue:** TBD

**Como** administrador  
**Quiero** exponer el servidor a internet de forma segura  
**Para** que jugadores autorizados puedan conectarse

**Acceptance Criteria:**
- [ ] IP pública o dominio configurado
- [ ] Port forwarding activo en router
- [ ] UFW configurado y activo
- [ ] Fail2Ban instalado y configurado
- [ ] Rate limiting activo
- [ ] Conectividad pública verificada
- [ ] Solo puerto 25565 expuesto
- [ ] RCON solo accesible desde localhost

**Tareas:**
1. `network-setup` - Configurar IP/dominio
2. `port-forwarding` - Configurar router
3. `firewall-config` - Configurar UFW
4. `fail2ban-setup` - Instalar Fail2Ban
5. `test-connectivity` - Testing de conectividad pública

---

### US-28: Sistema de Autorización (Whitelist)

**Story Points:** 13  
**Prioridad:** Alta  
**Issue:** TBD

**Como** administrador  
**Quiero** controlar quién puede conectarse al servidor  
**Para** mantener una comunidad privada y segura

**Acceptance Criteria:**
- [ ] Whitelist habilitado en servidor
- [ ] Scripts para agregar/remover jugadores
- [ ] Web form para solicitar acceso (opcional)
- [ ] Bot de Discord para gestión (opcional)
- [ ] Documentación para jugadores
- [ ] Sistema de roles configurado (opcional)
- [ ] Online mode activado (verificación Mojang)

**Tareas:**
1. `whitelist-enable` - Habilitar whitelist
2. `whitelist-scripts` - Scripts de gestión
3. `web-form` - Formulario web (opcional)
4. `discord-bot` - Bot de Discord (opcional)
5. `player-docs` - Documentación para jugadores

---

### US-29: Seguridad Avanzada

**Story Points:** 13  
**Prioridad:** Alta  
**Issue:** TBD

**Como** administrador  
**Quiero** seguridad robusta en producción  
**Para** proteger el servidor de ataques y abusos

**Acceptance Criteria:**
- [ ] Security hardening aplicado
- [ ] Backups automáticos a la nube
- [ ] IDS instalado y monitoreando
- [ ] Log monitoring con alertas
- [ ] SSL/TLS configurado (si aplica web panel)
- [ ] Anti-cheat plugins instalados (opcional)
- [ ] DDoS protection básico activo

**Tareas:**
1. `apply-hardening` - Aplicar security-hardening.sh
2. `cloud-backups` - Configurar backups a la nube
3. `ids-setup` - Instalar AIDE
4. `log-monitoring` - Script de monitoreo de logs
5. `ssl-setup` - Configurar SSL/TLS (si aplica)

---

### US-30: Monitoring de Producción

**Story Points:** 8  
**Prioridad:** Media  
**Issue:** TBD

**Como** administrador  
**Quiero** monitoreo continuo del servidor público  
**Para** detectar y resolver problemas rápidamente

**Acceptance Criteria:**
- [ ] Uptime monitoring activo
- [ ] Alertas de downtime configuradas
- [ ] Performance monitoring continuo
- [ ] Dashboard de métricas (opcional)
- [ ] Mantenimiento programado configurado
- [ ] Procedimientos de recovery documentados
- [ ] Troubleshooting guide para jugadores

**Tareas:**
1. `uptime-monitor` - Script de uptime monitoring
2. `alerts-setup` - Configurar alertas
3. `performance-monitor` - Monitoring de performance
4. `maintenance-schedule` - Configurar mantenimiento
5. `player-troubleshooting` - Guía de troubleshooting

---

## 📦 Entregables del Sprint

### Configuración

- [ ] `.env.production` - Configuración de producción
- [ ] `docker-compose.prod.yml` - Compose para producción
- [ ] `whitelist.json` - Whitelist inicial

### Scripts

- [ ] `scripts/deploy-production.sh` - Deployment automatizado
- [ ] `scripts/configure-firewall-prod.sh` - Config de firewall
- [ ] `scripts/install-fail2ban.sh` - Instalación Fail2Ban
- [ ] `scripts/whitelist-add.sh` - Agregar a whitelist
- [ ] `scripts/whitelist-remove.sh` - Remover de whitelist
- [ ] `scripts/backup-to-cloud.sh` - Backup a la nube
- [ ] `scripts/uptime-monitor.sh` - Monitoreo de uptime
- [ ] `scripts/performance-report.sh` - Reporte de performance
- [ ] `scripts/maintenance-window.sh` - Mantenimiento programado
- [ ] `scripts/test-public-access.sh` - Testing de acceso público

### Documentación

- [ ] `docs/PUBLIC_DEPLOYMENT.md` - Guía completa de deployment
- [ ] `docs/PUBLIC_TROUBLESHOOTING.md` - Troubleshooting para jugadores
- [ ] `docs/WHITELIST_GUIDE.md` - Guía de whitelist
- [ ] `docs/PRODUCTION_CHECKLIST.md` - Checklist de producción
- [ ] `docs/MAINTENANCE.md` - Guía de mantenimiento

### Opcional (si hay tiempo)

- [ ] `auth-panel/` - Web panel para solicitudes
- [ ] `discord-bot/` - Bot de Discord
- [ ] Grafana + Prometheus - Dashboard de métricas
- [ ] DNS dinámico - Auto-update de IP

---

## 📝 Plan de Trabajo Detallado

### Semana 1: Preparación y Networking (Días 1-7)

#### Día 1-2: Configuración de Producción (US-26)

**Branch:** `sprint/6`

**Tareas:**
1. Crear `.env.production` con config segura
2. Crear `docker-compose.prod.yml` optimizado
3. Crear `scripts/deploy-production.sh`
4. Testing local de configuración

**Deliverables:**
- Config de producción funcional
- Script de deployment testeado

---

#### Día 3-4: Networking Básico (US-27 - Parte 1)

**Branch:** `task/us27-networking-setup`

**Tareas:**
1. Obtener IP pública
2. Configurar DuckDNS o dominio
3. Configurar port forwarding en router
4. Crear script `scripts/get-local-ip.sh`
5. Crear script `scripts/test-public-access.sh`
6. Testing de conectividad básica

**Deliverables:**
- IP/dominio accesible
- Port forwarding funcionando
- Scripts de testing

---

#### Día 5-7: Firewall y Seguridad de Red (US-27 - Parte 2)

**Branch:** `task/us27-firewall-config`

**Tareas:**
1. Crear `scripts/configure-firewall-prod.sh`
2. Configurar UFW con rate limiting
3. Crear `scripts/install-fail2ban.sh`
4. Configurar Fail2Ban para Minecraft
5. Testing de reglas de firewall
6. Verificar acceso público seguro

**Deliverables:**
- UFW configurado
- Fail2Ban funcionando
- Firewall testeado

---

### Semana 2: Autorización y Seguridad (Días 8-14)

#### Día 8-10: Sistema de Whitelist (US-28)

**Branch:** `task/us28-whitelist-system`

**Tareas:**
1. Habilitar whitelist en `.env.production`
2. Crear `scripts/whitelist-add.sh`
3. Crear `scripts/whitelist-remove.sh`
4. Crear `scripts/whitelist-list.sh`
5. Crear `whitelist.json` inicial
6. Documentar proceso en `docs/WHITELIST_GUIDE.md`
7. Testing de whitelist

**Deliverables:**
- Whitelist funcional
- Scripts de gestión
- Documentación completa

---

#### Día 11-12: Web Form y Discord Bot (US-28 - Opcional)

**Branch:** `task/us28-auth-automation`

**Tareas:**
1. Crear `auth-panel/index.html` (form simple)
2. Configurar Discord webhook
3. Crear `discord-bot/whitelist-bot.js` (básico)
4. Testing de automatización

**Deliverables:**
- Form de solicitud funcional
- Bot de Discord (MVP)

**Nota:** Si falta tiempo, esta tarea puede saltarse o simplificarse.

---

#### Día 13-14: Seguridad Avanzada (US-29)

**Branch:** `task/us29-advanced-security`

**Tareas:**
1. Aplicar `scripts/security-hardening.sh`
2. Crear `scripts/backup-to-cloud.sh`
3. Configurar rclone para Google Drive/Dropbox
4. Crear `scripts/install-aide.sh`
5. Crear `scripts/monitor-security-logs.sh`
6. Configurar backups automáticos (cron)
7. Testing de seguridad

**Deliverables:**
- Security hardening aplicado
- Backups automáticos funcionando
- Log monitoring activo

---

### Semana 3: Monitoring y Finalización (Días 15-21)

#### Día 15-17: Monitoring de Producción (US-30)

**Branch:** `task/us30-production-monitoring`

**Tareas:**
1. Crear `scripts/uptime-monitor.sh`
2. Configurar alertas de Discord/Slack
3. Crear `scripts/performance-report.sh`
4. Crear `scripts/maintenance-window.sh`
5. Configurar cron jobs para monitoring
6. Documentar en `docs/MAINTENANCE.md`

**Deliverables:**
- Uptime monitoring activo
- Alertas configuradas
- Mantenimiento programado

---

#### Día 18-19: Documentación y Troubleshooting (US-30)

**Branch:** `task/us30-documentation`

**Tareas:**
1. Crear `docs/PUBLIC_DEPLOYMENT.md`
2. Crear `docs/PUBLIC_TROUBLESHOOTING.md`
3. Crear `docs/PRODUCTION_CHECKLIST.md`
4. Actualizar README con info de servidor público
5. Crear guía de conexión para jugadores

**Deliverables:**
- Documentación completa
- Guías para jugadores
- Checklist de producción

---

#### Día 20-21: Testing Final y Deployment

**Branch:** `sprint/6` (merge final)

**Tareas:**
1. Testing completo end-to-end
2. Verificar checklist de producción
3. Deployment a producción
4. Monitoreo post-deployment (24h)
5. Ajustes finales
6. Sprint retrospective

**Deliverables:**
- Servidor público funcionando
- Checklist completado
- Retrospective documentado

---

## 🗓️ Timeline Visual

```
Semana 1: Preparación y Networking
├── Día 1-2: Config de Producción (US-26)
├── Día 3-4: Networking Setup (US-27)
└── Día 5-7: Firewall Config (US-27)

Semana 2: Autorización y Seguridad
├── Día 8-10: Whitelist System (US-28)
├── Día 11-12: Auth Automation (US-28 - Opcional)
└── Día 13-14: Advanced Security (US-29)

Semana 3: Monitoring y Finalización
├── Día 15-17: Production Monitoring (US-30)
├── Día 18-19: Documentation (US-30)
└── Día 20-21: Testing & Deployment
```

---

## ✅ Definition of Done

Para considerar el sprint completo:

- [ ] Servidor accesible desde internet
- [ ] Whitelist funcionando correctamente
- [ ] Firewall configurado y activo
- [ ] Backups automáticos funcionando
- [ ] Monitoring y alertas activas
- [ ] Documentación completa
- [ ] Testing end-to-end passing
- [ ] Checklist de producción completado
- [ ] Al menos 3 jugadores testearon conexión exitosamente

---

## 🎯 Checklist de Producción

Antes de considerar el deployment completo:

### Seguridad ✅
- [ ] UFW activo y configurado
- [ ] Fail2Ban instalado y funcionando
- [ ] Whitelist activado
- [ ] ONLINE_MODE=true
- [ ] RCON password seguro (no default)
- [ ] Security hardening aplicado
- [ ] Backups automáticos configurados
- [ ] Logs monitoreados

### Networking ✅
- [ ] IP pública o dominio configurado
- [ ] Port forwarding activo
- [ ] DNS configurado (si aplica)
- [ ] Conectividad pública verificada
- [ ] Solo puerto 25565 expuesto
- [ ] RCON NO expuesto públicamente

### Performance ✅
- [ ] RAM adecuada (mínimo 4GB, recomendado 8GB)
- [ ] CPU suficiente (mínimo 2 cores)
- [ ] Auto-pause configurado
- [ ] Aikar's flags activos
- [ ] Rate limiting configurado
- [ ] MAX_TICK_TIME configurado correctamente

### Monitoring ✅
- [ ] Alertas de uptime configuradas
- [ ] Performance monitoring activo
- [ ] Logs centralizados
- [ ] Webhook de alertas funcionando

### Mantenimiento ✅
- [ ] Backup automático diario
- [ ] Backup remoto configurado
- [ ] Mantenimiento programado (semanal)
- [ ] Procedimientos de recovery documentados

### Documentación ✅
- [ ] Guía de conexión para jugadores
- [ ] Guía de troubleshooting
- [ ] Contactos de soporte definidos
- [ ] Reglas del servidor publicadas
- [ ] Whitelist process documentado

---

## 📊 Métricas de Éxito

| Métrica | Target | Medición |
|---------|--------|----------|
| **Uptime** | > 99% | Monitoring continuo |
| **Latencia promedio** | < 100ms | Ping test |
| **TPS** | > 19 | RCON commands |
| **Players simultáneos** | 10-20 | Server status |
| **Tiempo de respuesta a issues** | < 24h | Tickets/Discord |
| **Satisfacción de jugadores** | > 80% | Survey |

---

## 🚧 Riesgos y Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| IP dinámica cambia | Alta | Medio | Usar DuckDNS con auto-update |
| DDoS básico | Media | Alto | Fail2Ban + rate limiting + auto-pause |
| Fallo de hardware/PC | Media | Alto | Backups automáticos + recovery docs |
| Firewall mal configurado | Baja | Alto | Testing exhaustivo antes de producción |
| Whitelist bypass | Baja | Medio | ONLINE_MODE=true + verificación Mojang |
| Recursos insuficientes | Media | Medio | Monitoring y alertas tempranas |

---

## 🔗 Recursos y Referencias

### Herramientas Necesarias

- **DuckDNS** - https://www.duckdns.org/
- **UFW** - Firewall de Ubuntu
- **Fail2Ban** - Anti-DDoS básico
- **rclone** - Backup a la nube
- **mcsrvstat.us** - Verificar status del servidor

### Documentación de Referencia

- Documentación de Paper: https://docs.papermc.io/
- Admin guide: r/admincraft
- Port forwarding guide: portforward.com
- Security best practices: `docs/SECURITY.md`

### Servicios Opcionales

- **UptimeRobot** - Monitoring gratis (50 monitors)
- **Pingdom** - Alertas de uptime
- **DigitalOcean** - VPS alternativo ($6/mes)
- **Cloudflare** - DDoS protection (plan gratis)

---

## 🎓 Lecciones Aprendidas (Post-Sprint)

*A completar después del sprint*

### ¿Qué funcionó bien?
- TBD

### ¿Qué podría mejorar?
- TBD

### ¿Qué aprendimos?
- TBD

### Acciones para próximo sprint
- TBD

---

## 🚀 Próximos Pasos (Post-Sprint 6)

Después de completar el deployment público:

1. **Invitar jugadores**
   - Crear anuncio en Discord/redes
   - Compartir IP/dominio
   - Explicar proceso de whitelist

2. **Monitorear primeras 48h**
   - Vigilar logs de cerca
   - Responder issues rápidamente
   - Ajustar recursos si es necesario

3. **Feedback y mejoras**
   - Recolectar feedback de jugadores
   - Ajustar reglas si es necesario
   - Optimizar performance

4. **Considerar expansión**
   - Más plugins
   - Eventos regulares
   - Migrar a VPS si crece

---

**Created:** 2025-10-25  
**Last Updated:** 2025-10-25  
**Version:** v1.0 → v1.1 (Public)

**¡A hacer público el servidor! 🌐🎮**

