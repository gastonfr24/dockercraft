# 🗺️ Roadmap de Implementación - DockerCraft

> **Última actualización:** 2025-10-24  
> **Versión:** v0.1.0-alpha

Este documento define el plan de implementación del proyecto, organizado en sprints y fases.

---

## 🎯 Visión del Producto

**Versión 1.0** (6-8 meses):  
Sistema completo para gestionar múltiples servidores Minecraft con API REST, dashboard web, sistema de backups automáticos, monitoreo en tiempo real, y proxy multi-servidor.

**Versión 2.0** (12 meses):  
Plataforma de hosting con billing, marketplace de plugins, auto-scaling, multi-región, y cliente CLI.

---

## 📋 Fases del Proyecto

```
┌──────────────────────────────────────────────────────────────────┐
│                       ROADMAP TIMELINE                           │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Sprint 0  │  Sprint 1  │  Sprint 2  │  Sprint 3  │  Sprint 4  │
│  Planning  │  Base MC   │  API Core  │  Advanced  │  Polish    │
│   (1 sem)  │  (2 sem)   │  (2 sem)   │  (2 sem)   │  (1 sem)   │
│     ▼      │     ▼      │     ▼      │     ▼      │     ▼      │
│    Docs    │  Dockerfile│   REST     │  Backups   │  Testing   │
│    Stack   │  Compose   │   CRUD     │  Monitor   │  Optimize  │
│            │  Test MC   │   Docker   │  Auth      │  Deploy    │
│            │            │   API      │  WebSocket │  Docs      │
│            │            │            │            │            │
│            │◄── MVP 0.1 ────────────►│            │            │
│            │                         │            │            │
│            │                         │◄─ v0.5 ───►│◄─ v1.0 ───►│
│                                                                  │
│  ├─────────────────── Fase 1: Foundation ──────────────────────┤│
│                                                                  │
│  └──────────────────────────────────────────────────────────────┘
│
│  Fase 2: Enhancement (4-6 meses)
│    ├── Dashboard Web (React)
│    ├── Proxy Multi-servidor (BungeeCord)
│    ├── Sistema de Roles y Permisos
│    ├── Métricas Avanzadas (Prometheus/Grafana)
│    └── Cloud Storage para Backups
│
│  Fase 3: Scale (6-12 meses)
│    ├── Migración a Kubernetes
│    ├── Auto-scaling Dinámico
│    ├── Multi-región
│    ├── Sistema de Billing
│    └── Marketplace de Plugins
```

---

## 🏃 Sprint 0: Planificación (Actual)

**Duración:** 1 semana  
**Objetivo:** Definir arquitectura, stack tecnológico y crear documentación base.  
**Estado:** 🚧 En progreso (60%)

### **Tareas**

- [x] Investigar arquitecturas modernas para servidores Minecraft
- [x] Definir stack tecnológico (Docker, Paper, Node.js, PostgreSQL)
- [x] Crear ADRs (Architecture Decision Records)
- [x] Diseñar estructura de base de datos
- [ ] Completar documentación para IA (`docs/ai/`)
- [ ] Crear estructura de carpetas del proyecto
- [ ] Configurar Git (.gitignore, README inicial)
- [ ] Definir convenciones de código

### **Entregables**

- [x] `docs/ai/01_CONTEXT.md`
- [x] `docs/ai/02_ARCHITECTURE.md`
- [x] `docs/ai/03_DECISIONS.md`
- [x] `docs/ai/04_MEMORY.md`
- [ ] `docs/ai/05_ROADMAP.md` (este archivo)
- [ ] `docs/ai/06_API_SPECS.md`
- [ ] `docs/ai/07_WORKFLOWS.md`
- [ ] `docs/ai/08_QUICK_START.md`
- [ ] `docs/ai/09_CHANGELOG.md`
- [ ] `docs/ai/10_GLOSSARY.md`
- [ ] Estructura de carpetas completa

### **Criterios de Aceptación**

- ✅ Documentación completa en `docs/ai/`
- ✅ Stack tecnológico definido y documentado
- ✅ Decisiones arquitectónicas registradas (ADRs)
- ⏳ Estructura de proyecto creada
- ⏳ README.md inicial

---

## 🏃 Sprint 1: Servidor Base de Minecraft

**Duración:** 2 semanas  
**Objetivo:** Crear un servidor Minecraft funcional en Docker con persistencia.  
**Estado:** ⏳ Pendiente

### **User Stories**

1. **Como desarrollador, quiero un Dockerfile optimizado para Minecraft**
   - Basado en `itzg/minecraft-server`
   - Configuración via variables de entorno
   - Health check implementado
   - Auto-pause habilitado

2. **Como desarrollador, quiero Docker Compose para levantar servicios**
   - Servidor Minecraft
   - PostgreSQL
   - Volúmenes para persistencia
   - Networks configuradas

3. **Como jugador, quiero conectarme al servidor**
   - Servidor accesible en `localhost:25565`
   - Mundo persiste entre reinicios
   - Configuración básica funcional

### **Tareas Técnicas**

#### 1.1 Crear Dockerfile Base
```dockerfile
# minecraft-base/Dockerfile
- Imagen base: itzg/minecraft-server:java21
- Variables de entorno configurables
- Health check script
- VOLUME /data
```

#### 1.2 Configuración de Servidor
```properties
# minecraft-base/server.properties
- max-players=20
- difficulty=normal
- gamemode=survival
- view-distance=10
- pvp=true
```

#### 1.3 Docker Compose Base
```yaml
# docker-compose.yml
services:
  minecraft-base:
    build: ./minecraft-base
    ports: ["25565:25565"]
    volumes: [mc-data:/data]
    environment: [VERSION, MEMORY, etc.]
  
  postgres:
    image: postgres:16
    volumes: [pg-data:/var/lib/postgresql/data]
    environment: [POSTGRES_DB, POSTGRES_USER, etc.]
```

#### 1.4 Scripts de Utilidad
```bash
# scripts/start.sh - Iniciar servicios
# scripts/stop.sh - Detener servicios
# scripts/logs.sh - Ver logs
# scripts/console.sh - Acceder a consola MC
```

#### 1.5 Testing Manual
- Levantar servicios
- Conectarse desde cliente Minecraft
- Crear algo en el mundo
- Reiniciar contenedor
- Verificar persistencia

### **Entregables**

- [ ] `minecraft-base/Dockerfile`
- [ ] `minecraft-base/server.properties`
- [ ] `docker-compose.yml`
- [ ] `.env.example`
- [ ] `scripts/start.sh`
- [ ] `scripts/stop.sh`
- [ ] `scripts/logs.sh`
- [ ] Servidor funcional y accesible

### **Criterios de Aceptación**

- ✅ Servidor Minecraft inicia correctamente
- ✅ Jugadores pueden conectarse
- ✅ Datos persisten entre reinicios
- ✅ Health check funciona
- ✅ Auto-pause activado
- ✅ Logs visibles y configurables
- ✅ Documentación de setup en README

### **Métricas de Éxito**

- Tiempo de inicio: < 2 minutos
- Uso de RAM: ~4GB
- Persistencia: 100% de datos guardados

---

## 🏃 Sprint 2: API REST Core

**Duración:** 2 semanas  
**Objetivo:** Implementar API REST con endpoints básicos CRUD para servidores.  
**Estado:** ⏳ Pendiente

### **User Stories**

1. **Como admin, quiero crear un servidor via API**
   - POST `/api/servers` con configuración
   - API crea contenedor Docker
   - Retorna ID y status del servidor

2. **Como admin, quiero listar mis servidores**
   - GET `/api/servers`
   - Retorna lista con estado actual

3. **Como admin, quiero controlar servidores**
   - POST `/api/servers/:id/start`
   - POST `/api/servers/:id/stop`
   - POST `/api/servers/:id/restart`
   - DELETE `/api/servers/:id`

4. **Como admin, quiero ver estado de un servidor**
   - GET `/api/servers/:id`
   - Retorna métricas (CPU, RAM, players online)

### **Tareas Técnicas**

#### 2.1 Setup del Proyecto API

```bash
api/
├── src/
│   ├── index.js              # Entry point
│   ├── config/
│   │   ├── database.js       # PostgreSQL connection
│   │   ├── docker.js         # Docker client config
│   │   └── app.js            # Express config
│   ├── routes/
│   │   ├── index.js
│   │   └── serverRoutes.js   # /api/servers/*
│   ├── controllers/
│   │   └── serverController.js
│   ├── services/
│   │   ├── dockerService.js  # Docker API wrapper
│   │   ├── dbService.js      # Database queries
│   │   └── portManager.js    # Port allocation
│   ├── models/
│   │   └── Server.js         # Server model
│   ├── middleware/
│   │   ├── errorHandler.js
│   │   └── validator.js
│   └── utils/
│       └── logger.js
├── package.json
├── Dockerfile
└── .env.example
```

#### 2.2 Implementar Docker Service

```javascript
class DockerService {
  async createMinecraftServer(config) {
    // Crear contenedor
    // Configurar volumes, ports, env vars
    // Iniciar contenedor
    // Retornar container info
  }
  
  async getServerStats(containerId) {
    // Obtener stats de Docker
    // CPU, RAM, Network
  }
  
  async stopServer(containerId) { }
  async startServer(containerId) { }
  async deleteServer(containerId) { }
}
```

#### 2.3 Implementar Port Manager

```javascript
class PortManager {
  constructor() {
    this.basePort = 25565;
    this.maxPort = 25665;
  }
  
  async getNextAvailablePort() {
    // Query DB for used ports
    // Find first available port
    // Return port or throw error
  }
  
  async releasePort(port) {
    // Mark port as available
  }
}
```

#### 2.4 Database Schema

```sql
-- Ver 02_ARCHITECTURE.md para schema completo
CREATE TABLE servers (
  id UUID PRIMARY KEY,
  name VARCHAR(255) UNIQUE,
  container_id VARCHAR(255),
  port INTEGER,
  status VARCHAR(50),
  ...
);
```

#### 2.5 API Endpoints

```javascript
// POST /api/servers - Crear servidor
// GET /api/servers - Listar servidores
// GET /api/servers/:id - Obtener servidor
// PUT /api/servers/:id - Actualizar config
// DELETE /api/servers/:id - Eliminar servidor
// POST /api/servers/:id/start - Iniciar
// POST /api/servers/:id/stop - Detener
// POST /api/servers/:id/restart - Reiniciar
// GET /api/servers/:id/stats - Métricas
```

### **Entregables**

- [ ] API REST funcional
- [ ] Dockerfile de API
- [ ] Docker Compose actualizado (incluir API)
- [ ] Database migrations
- [ ] Documentación de API (básica)
- [ ] Tests unitarios (opcional para MVP)

### **Criterios de Aceptación**

- ✅ Todos los endpoints CRUD funcionan
- ✅ API puede crear servidor en < 30 segundos
- ✅ API puede iniciar/detener servidores
- ✅ API puede obtener métricas de servidores
- ✅ Manejo de errores apropiado
- ✅ Logs configurados
- ✅ Validación de input
- ✅ PostgreSQL integrado correctamente

### **Métricas de Éxito**

- Tiempo de respuesta API: < 200ms (excepto crear servidor)
- Tiempo de creación de servidor: < 30 segundos
- Uptime de API: 99%+

---

## 🏃 Sprint 3: Advanced Features & Documentation

**Duración:** 2 semanas  
**Objetivo:** Soporte multi-version, modpacks, networking avanzado y documentación completa  
**Estado:** 📝 Planificado

### **User Stories**

#### US-14: Soporte Multi-Version de Minecraft
**Como** administrador  
**Quiero** poder elegir diferentes versiones de Minecraft  
**Para** soportar diferentes necesidades de jugadores

**Acceptance Criteria:**
- [ ] Variable VERSION soporta versiones específicas (1.20.1, 1.19.4, etc)
- [ ] Variable TYPE soporta PAPER, SPIGOT, FORGE, FABRIC
- [ ] Documentación de versiones compatibles
- [ ] Ejemplos en docker-compose para diferentes versiones
- [ ] Testing de al menos 3 versiones diferentes

**Story Points:** 5

#### US-15: Soporte para Modpacks
**Como** administrador  
**Quiero** poder instalar modpacks automáticamente  
**Para** facilitar la configuración de servidores modded

**Acceptance Criteria:**
- [ ] Soporte para CurseForge modpacks
- [ ] Soporte para FTB modpacks
- [ ] Variable MODPACK_URL o CURSEFORGE_FILE
- [ ] Documentación de instalación de modpacks
- [ ] Ejemplo funcional con modpack popular

**Story Points:** 8

#### US-16: Networking Multi-Servidor
**Como** desarrollador de API  
**Quiero** que los servidores puedan comunicarse entre sí  
**Para** preparar integración con proxy (BungeeCord/Velocity)

**Acceptance Criteria:**
- [ ] Docker network configurado correctamente
- [ ] Variables para configurar proxy mode
- [ ] Documentación de networking
- [ ] Ejemplo con 3 servidores + proxy
- [ ] Guía de integración para API externa

**Story Points:** 5

#### US-17: Variables de Entorno Avanzadas
**Como** administrador  
**Quiero** más control sobre la configuración del servidor  
**Para** optimizar para casos de uso específicos

**Acceptance Criteria:**
- [ ] Nuevas variables documentadas en .env.example
- [ ] Soporte para PLUGINS automáticos
- [ ] Soporte para MODS automáticos
- [ ] Configuración de whitelist via variable
- [ ] OPS automáticos via variable

**Story Points:** 3

#### US-18: Documentación Avanzada
**Como** nuevo usuario  
**Quiero** documentación completa y clara  
**Para** poder usar el proyecto sin problemas

**Acceptance Criteria:**
- [ ] README.md completo con todos los casos de uso
- [ ] Guía de troubleshooting expandida
- [ ] Ejemplos de configuraciones comunes
- [ ] FAQ section
- [ ] Video tutorial (opcional)

**Story Points:** 5

### **Tareas Técnicas**

#### 3.1 Sistema de Autenticación

```javascript
// JWT implementation
POST /api/auth/register  // Crear usuario
POST /api/auth/login     // Obtener tokens
POST /api/auth/refresh   // Refresh access token
POST /api/auth/logout    // Invalidar refresh token

// Middleware
authMiddleware.js - Verificar JWT
roleMiddleware.js - Verificar permisos
```

#### 3.2 Sistema de Backups

```javascript
class BackupService {
  async createBackup(serverId) {
    // 1. Pausar writes (RCON: save-off)
    // 2. Flush data (RCON: save-all)
    // 3. Docker cp /data
    // 4. Comprimir (tar.gz)
    // 5. Guardar en /backups o S3
    // 6. Registrar en DB
    // 7. Reactivar writes (RCON: save-on)
  }
  
  async restoreBackup(serverId, backupId) {
    // 1. Detener servidor
    // 2. Descomprimir backup
    // 3. Docker cp to volume
    // 4. Reiniciar servidor
  }
  
  async listBackups(serverId) { }
  async deleteBackup(backupId) { }
}
```

#### 3.3 WebSocket para Logs

```javascript
// Socket.io implementation
io.of('/ws/servers/:id/logs').on('connection', (socket) => {
  // Stream Docker logs
  // Enviar línea por línea
  // Permitir enviar comandos RCON
});
```

#### 3.4 Monitoreo Básico

```javascript
// Endpoint para métricas
GET /api/servers/:id/metrics
{
  "cpu_percent": 45.2,
  "memory_mb": 3200,
  "memory_percent": 80,
  "players_online": 5,
  "tps": 19.8,
  "uptime_seconds": 3600
}
```

### **Entregables**

- [ ] Sistema de autenticación (JWT)
- [ ] Endpoints de backups
- [ ] WebSocket para logs
- [ ] Monitoreo básico de métricas
- [ ] Scripts de backup automático
- [ ] Tests de integración

### **Criterios de Aceptación**

- ✅ Autenticación JWT funcional
- ✅ Backups se crean correctamente
- ✅ Restauración funciona sin pérdida de datos
- ✅ WebSocket transmite logs en tiempo real
- ✅ Métricas de servidores precisas
- ✅ Rate limiting implementado

### **Métricas de Éxito**

- Tiempo de backup: < 1 minuto para mundo de 1GB
- Tiempo de restore: < 2 minutos
- Latencia de WebSocket: < 100ms

---

## 🏃 Sprint 4: Polish y Deployment

**Duración:** 1 semana  
**Objetivo:** Testing completo, optimización, documentación y preparar para producción.  
**Estado:** ⏳ Pendiente

### **Tareas**

#### 4.1 Testing

- [ ] Unit tests (80% coverage)
- [ ] Integration tests
- [ ] Pruebas de carga (simular 10 servidores)
- [ ] Pruebas de stress
- [ ] Validación de backups

#### 4.2 Optimización

- [ ] Optimizar queries de DB
- [ ] Implementar caching (Redis)
- [ ] Optimizar tamaño de imágenes Docker
- [ ] Configurar log rotation
- [ ] Tuning de JVM flags

#### 4.3 Seguridad

- [ ] Nginx como reverse proxy
- [ ] SSL/TLS con Let's Encrypt
- [ ] Security headers
- [ ] Rate limiting avanzado
- [ ] Input sanitization

#### 4.4 Documentación

- [ ] README completo
- [ ] API documentation (Swagger/OpenAPI)
- [ ] Guía de deployment
- [ ] Troubleshooting guide
- [ ] Contribution guidelines

#### 4.5 CI/CD

- [ ] GitHub Actions setup
- [ ] Automated testing
- [ ] Docker image builds
- [ ] Automated deployment (opcional)

### **Entregables**

- [ ] Test suite completo
- [ ] Nginx configurado
- [ ] SSL/TLS activo
- [ ] Documentación completa
- [ ] CI/CD pipeline
- [ ] Deploy en servidor de prueba

### **Criterios de Aceptación**

- ✅ Tests passing al 100%
- ✅ Coverage > 80%
- ✅ Documentación completa
- ✅ HTTPS funcionando
- ✅ Sistema productionready

---

## 🎉 Versión 1.0 - MVP Completo

**Fecha Target:** 2-3 meses desde inicio  
**Features Incluidas:**

✅ Servidor Minecraft base optimizado (Paper)  
✅ API REST completa (CRUD + Control)  
✅ Sistema de autenticación (JWT)  
✅ Base de datos PostgreSQL  
✅ Sistema de backups y restauración  
✅ Monitoreo básico de métricas  
✅ WebSocket para logs en tiempo real  
✅ Docker Compose para orquestación  
✅ Auto-pause para ahorro de recursos  
✅ Documentación completa  
✅ Tests y CI/CD  

**No Incluido en MVP:**
- Dashboard web (frontend)
- Proxy multi-servidor (BungeeCord)
- Prometheus/Grafana
- Auto-scaling
- Cloud storage
- Billing

---

## 🚀 Fase 2: Enhancement (Meses 3-6)

### **Sprint 5-6: Dashboard Web**

**Objetivo:** Crear interfaz web para gestión de servidores.

**Features:**
- Dashboard con lista de servidores
- Crear/Editar/Eliminar servidores via UI
- Ver métricas en tiempo real
- Consola web para logs
- Gestión de usuarios y permisos

**Stack:**
- React + TypeScript
- Material-UI o Tailwind CSS
- Chart.js para gráficos
- Socket.io client para WebSocket

### **Sprint 7-8: Proxy Multi-Servidor**

**Objetivo:** Implementar BungeeCord/Velocity para conectar múltiples servidores.

**Features:**
- BungeeCord container
- Configuración dinámica via API
- Comando `/server` para moverse entre servidores
- Balanceo de carga

### **Sprint 9-10: Monitoreo Avanzado**

**Objetivo:** Implementar Prometheus y Grafana.

**Features:**
- Prometheus para recolección de métricas
- Grafana dashboards
- Alertas configurables
- Historial de métricas

### **Sprint 11-12: Cloud Storage**

**Objetivo:** Migrar backups a cloud (S3/GCS).

**Features:**
- Integración con AWS S3 o Google Cloud Storage
- Backups automáticos programados
- Retención configurable
- Restauración desde cloud

---

## 🌟 Fase 3: Scale (Meses 7-12)

### **Kubernetes Migration**

- Migrar de Docker Compose a Kubernetes
- Helm charts para deployment
- Auto-scaling de servidores
- Load balancing

### **Multi-Región**

- Deploy en múltiples regiones (AWS, GCP, Azure)
- Geo-routing de jugadores
- Replicación de datos

### **Billing System**

- Integración con Stripe
- Planes y pricing
- Facturación automática
- Métricas de uso

### **Marketplace de Plugins**

- Repositorio curado de plugins
- Instalación con un click
- Gestión de versiones
- Reviews y ratings

---

## 📊 Backlog Priorizado

| Prioridad | Feature | Esfuerzo | Valor | Sprint |
|-----------|---------|----------|-------|--------|
| P0 | Servidor MC base | M | Alto | 1 |
| P0 | API REST CRUD | L | Alto | 2 |
| P0 | Docker integration | M | Alto | 2 |
| P1 | Autenticación JWT | M | Alto | 3 |
| P1 | Sistema de backups | L | Alto | 3 |
| P1 | WebSocket logs | M | Medio | 3 |
| P1 | Monitoreo básico | S | Medio | 3 |
| P2 | Dashboard web | XL | Alto | 5-6 |
| P2 | Proxy multi-servidor | L | Medio | 7-8 |
| P2 | Prometheus/Grafana | M | Medio | 9-10 |
| P3 | Cloud storage | M | Bajo | 11-12 |
| P3 | Kubernetes | XL | Medio | Fase 3 |
| P4 | Billing | XL | Bajo | Fase 3 |

**Leyenda:**
- S (Small): < 1 semana
- M (Medium): 1-2 semanas
- L (Large): 2-4 semanas
- XL (Extra Large): > 4 semanas

---

## 🎯 Definición de "Done"

Para considerar una feature completa:

- [ ] Código implementado y funcional
- [ ] Tests escritos y passing
- [ ] Documentación actualizada
- [ ] Code review completado
- [ ] Sin linter errors
- [ ] Integrado con sistema existente
- [ ] Probado manualmente
- [ ] Performance aceptable
- [ ] Security review (para features críticas)
- [ ] Actualizado CHANGELOG.md

---

## 🔮 Visión a Largo Plazo (2+ años)

- **SaaS Multi-tenant:** Plataforma de hosting pública
- **Minecraft Education:** Soporte para Education Edition
- **Modpacks Curados:** Marketplace de modpacks
- **IA para Moderation:** Auto-moderación con ML
- **Mobile App:** App móvil para gestión
- **Discord Bot:** Control via Discord commands
- **White Label:** Permitir rebrand para revendedores

---

**Próximo:** Leer `06_API_SPECS.md` para especificaciones detalladas de la API

