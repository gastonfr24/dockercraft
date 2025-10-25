# Scripts - DockerCraft

Esta carpeta contiene todos los scripts de automatización del proyecto, organizados por categoría.

---

## 📂 Estructura

```
scripts/
├── deployment/       # Scripts de deployment y setup
├── security/         # Scripts de seguridad y firewall
├── monitoring/       # Scripts de monitoreo y alertas
├── backup/          # Scripts de backup y restore
├── whitelist/       # Scripts de gestión de whitelist
├── tunnel/          # Scripts de Cloudflare Tunnel
└── utils/           # Scripts de utilidades generales
```

---

## 📋 Categorías

### 🚀 Deployment (`deployment/`)

Scripts para deployment y configuración inicial del servidor.

| Script | Descripción |
|--------|-------------|
| `deploy-production.sh` | Deployment automatizado a producción |
| `setup.sh` | Setup inicial del proyecto |

**Uso típico:**
```bash
# Primer uso
./scripts/deployment/setup.sh

# Deployment a producción
./scripts/deployment/deploy-production.sh
```

---

### 🔒 Security (`security/`)

Scripts relacionados con seguridad, firewall y hardening.

| Script | Descripción |
|--------|-------------|
| `configure-firewall-prod.sh` | Configurar UFW para producción |
| `install-fail2ban.sh` | Instalar y configurar Fail2Ban |
| `security-hardening.sh` | Aplicar hardening de seguridad |

**Uso típico:**
```bash
# Configurar seguridad completa
sudo ./scripts/security/configure-firewall-prod.sh
sudo ./scripts/security/install-fail2ban.sh
sudo ./scripts/security/security-hardening.sh
```

---

### 📊 Monitoring (`monitoring/`)

Scripts para monitoreo, alertas y optimización.

| Script | Descripción |
|--------|-------------|
| `health-check.sh` | Health check del servidor |
| `monitor.sh` | Monitoreo básico de recursos |
| `monitor-with-alerts.sh` | Monitoreo con alertas automáticas |
| `optimize-recommendations.sh` | Recomendaciones de optimización |
| `send-alert.sh` | Enviar alertas a Discord/Slack |
| `uptime-monitor.sh` | Monitoreo de uptime |

**Uso típico:**
```bash
# Monitoreo básico
./scripts/monitoring/monitor.sh

# Monitoreo con alertas
./scripts/monitoring/monitor-with-alerts.sh

# Health check
./scripts/monitoring/health-check.sh
```

---

### 💾 Backup (`backup/`)

Scripts para backup y restauración de datos.

| Script | Descripción |
|--------|-------------|
| `backup.sh` | Backup local |
| `backup-to-cloud.sh` | Backup a la nube (rclone) |
| `restore.sh` | Restaurar desde backup |

**Uso típico:**
```bash
# Backup local
./scripts/backup/backup.sh

# Backup a la nube
./scripts/backup/backup-to-cloud.sh

# Restaurar
./scripts/backup/restore.sh <nombre-backup>
```

---

### 👥 Whitelist (`whitelist/`)

Scripts para gestionar la whitelist del servidor.

| Script | Descripción |
|--------|-------------|
| `whitelist-add.sh` | Agregar jugador a whitelist |
| `whitelist-remove.sh` | Remover jugador de whitelist |
| `whitelist-list.sh` | Listar jugadores en whitelist |

**Uso típico:**
```bash
# Agregar jugador
./scripts/whitelist/whitelist-add.sh NombreJugador

# Listar whitelist
./scripts/whitelist/whitelist-list.sh

# Remover jugador
./scripts/whitelist/whitelist-remove.sh NombreJugador
```

---

### 🌐 Tunnel (`tunnel/`)

Scripts para Cloudflare Tunnel (exposición pública del servidor).

| Script | Descripción |
|--------|-------------|
| `install-cloudflared.ps1` | Instalar cloudflared |
| `setup-cloudflare-tunnel.ps1` | Configurar tunnel inicial |
| `start-cloudflare-tunnel.ps1` | Iniciar tunnel |
| `stop-cloudflare-tunnel.ps1` | Detener tunnel |

**Uso típico (PowerShell en Windows):**
```powershell
# Setup inicial (una sola vez)
.\scripts\tunnel\install-cloudflared.ps1
.\scripts\tunnel\setup-cloudflare-tunnel.ps1

# Uso diario
.\scripts\tunnel\start-cloudflare-tunnel.ps1
.\scripts\tunnel\stop-cloudflare-tunnel.ps1
```

**Ver documentación completa:** [`docs/CLOUDFLARE_TUNNEL.md`](../docs/CLOUDFLARE_TUNNEL.md)

---

### 🛠️ Utils (`utils/`)

Scripts de utilidades generales y testing.

| Script | Descripción |
|--------|-------------|
| `get-public-ip.sh` | Obtener IP pública del servidor |
| `test-public-access.sh` | Testear acceso público al servidor |
| `test-server.sh` | Testing general del servidor |

**Uso típico:**
```bash
# Obtener IP pública
./scripts/utils/get-public-ip.sh

# Testear conectividad
./scripts/utils/test-public-access.sh

# Testing general
./scripts/utils/test-server.sh
```

---

## 🔧 Requisitos

### Para scripts `.sh` (Bash)

- Linux/macOS/WSL
- Bash 4.0+
- Docker y Docker Compose
- Permisos de ejecución: `chmod +x scripts/**/*.sh`

### Para scripts `.ps1` (PowerShell)

- Windows 10/11
- PowerShell 5.1+ o PowerShell Core 7+
- Docker Desktop para Windows

---

## 📝 Convenciones

### Permisos de Ejecución

Los scripts `.sh` deben tener permisos de ejecución:

```bash
# Dar permisos a un script
chmod +x scripts/category/script.sh

# Dar permisos a todos los scripts
find scripts -name "*.sh" -exec chmod +x {} \;
```

### Variables de Entorno

Muchos scripts usan variables de entorno. Configúralas en:

- `.env` - Configuración general
- `.env.production` - Configuración de producción
- `.env.alerts` - Webhooks para alertas

### Salida de Scripts

Los scripts siguen estas convenciones:

- **Exit code 0:** Éxito
- **Exit code 1:** Error general
- **Exit code 2:** Argumentos inválidos

### Logs

Los scripts de monitoreo y deployment generan logs en:

```
logs/
├── backup/
├── deployment/
├── monitoring/
└── security/
```

---

## 🚨 Seguridad

### Scripts con sudo

Algunos scripts requieren permisos de root:

- `security/configure-firewall-prod.sh`
- `security/install-fail2ban.sh`
- `security/security-hardening.sh`

**Siempre revisa el contenido antes de ejecutar con sudo.**

### Credenciales

Los scripts NO deben contener credenciales hardcoded. Usa:

- Variables de entorno
- Archivos `.env` (no commiteados)
- Secretos de GitHub Actions

---

## 📚 Documentación Relacionada

- **[CLOUDFLARE_TUNNEL.md](../docs/CLOUDFLARE_TUNNEL.md)** - Guía de Cloudflare Tunnel
- **[PUBLIC_DEPLOYMENT_GUIDE.md](../docs/PUBLIC_DEPLOYMENT_GUIDE.md)** - Guía de deployment público
- **[SECURITY.md](../docs/SECURITY.md)** - Guía de seguridad
- **[ALERTS.md](../docs/ALERTS.md)** - Configuración de alertas
- **[DEVELOPMENT.md](../docs/DEVELOPMENT.md)** - Guía de desarrollo

---

## 🆘 Troubleshooting

### Error: "Permission denied"

```bash
chmod +x scripts/category/script.sh
./scripts/category/script.sh
```

### Error: "Command not found" (scripts .sh en Windows)

Usa WSL o Git Bash, o convierte el script a PowerShell.

### Error: "Docker daemon not running"

```bash
# Linux
sudo systemctl start docker

# Windows/Mac
# Inicia Docker Desktop
```

---

**Última actualización:** 2025-10-25  
**Versión:** 2.0.0 (Reorganizada)

