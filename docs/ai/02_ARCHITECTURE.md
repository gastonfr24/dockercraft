# 🏗️ Arquitectura Técnica - DockerCraft

> **Última actualización:** 2025-10-24  
> **Versión:** v0.1.0-alpha

## 📐 Visión General de la Arquitectura

DockerCraft sigue una arquitectura **microservicios containerizada** donde cada componente es independiente y se comunica mediante APIs bien definidas.

```
┌─────────────────────────────────────────────────────────────────┐
│                        CAPA DE CLIENTE                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │  Dashboard   │  │ CLI Tool     │  │  API Client  │         │
│  │  Web (React) │  │  (Python)    │  │  (SDK)       │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
└────────────────┬────────────────────────────────────────────────┘
                 │ HTTPS/REST
┌────────────────┴────────────────────────────────────────────────┐
│                    CAPA DE APLICACIÓN                           │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              API Gateway (Nginx/Traefik)                 │   │
│  │  - Reverse Proxy                                         │   │
│  │  - SSL/TLS Termination                                   │   │
│  │  - Rate Limiting                                         │   │
│  │  - Load Balancing                                        │   │
│  └─────────────────────────────────────────────────────────┘   │
│                            │                                    │
│  ┌─────────────────────────┴────────────────────────────────┐  │
│  │           API REST Service (Node.js/FastAPI)             │  │
│  │  - Gestión de Servidores (CRUD)                          │  │
│  │  - Control de Contenedores Docker                        │  │
│  │  - Autenticación y Autorización (JWT)                    │  │
│  │  - WebSocket para logs en tiempo real                    │  │
│  │  - Validación y Business Logic                           │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────┬──────────────────┬──────────────────────────────┘
                 │                  │
    ┌────────────┴─────┐   ┌────────┴─────────┐
    │                  │   │                  │
┌───┴────────────────┐ │   │ ┌────────────────┴───────────────────┐
│  DOCKER ENGINE     │ │   │ │    CAPA DE PERSISTENCIA            │
│                    │ │   │ │                                    │
│ ┌────────────────┐ │ │   │ │  ┌──────────────────────────────┐ │
│ │ MC Server 1    │ │ │   │ │  │ PostgreSQL Database          │ │
│ │ Paper 1.21     │ │ │   │ │  │  - servers                   │ │
│ │ Port: 25565    │ │ │   │ │  │  - server_configs            │ │
│ │ RAM: 4GB       │ │ │   │ │  │  - users                     │ │
│ └────────────────┘ │ │   │ │  │  - logs                      │ │
│                    │ │   │ │  │  - backups                   │ │
│ ┌────────────────┐ │ │   │ │  └──────────────────────────────┘ │
│ │ MC Server 2    │ │ │   │ │                                    │
│ │ Paper 1.21     │ │ │   │ │  ┌──────────────────────────────┐ │
│ │ Port: 25566    │ │ │   │ │  │ Redis Cache (Opcional)       │ │
│ │ RAM: 4GB       │ │ │   │ │  │  - Session storage           │ │
│ └────────────────┘ │ │   │ │  │  - Server states             │ │
│                    │ │   │ │  │  - Rate limiting             │ │
│ ┌────────────────┐ │ │   │ │  └──────────────────────────────┘ │
│ │ MC Server N    │ │ │   │ │                                    │
│ │ Paper 1.21     │ │ │   │ │  ┌──────────────────────────────┐ │
│ │ Port: 2556N    │ │ │   │ │  │ Volume Storage               │ │
│ │ RAM: 4GB       │ │ │   │ │  │  - mc-server-1-data          │ │
│ └────────────────┘ │ │   │ │  │  - mc-server-2-data          │ │
│                    │ │   │ │  │  - backups/                  │ │
│ ┌────────────────┐ │ │   │ │  │  - logs/                     │ │
│ │ BungeeCord     │◄┼─┼───┘ │  └──────────────────────────────┘ │
│ │ Proxy          │ │ │     └────────────────────────────────────┘
│ │ Port: 25577    │ │ │
│ └────────────────┘ │ │     ┌────────────────────────────────────┐
│                    │ │     │  CAPA DE MONITOREO (Futuro)        │
└────────────────────┘ │     │                                    │
                       │     │  ┌──────────────────────────────┐ │
                       │     │  │ Prometheus                   │ │
                       │     │  │  - Métricas de contenedores  │ │
                       │     │  │  - Métricas de servidores    │ │
                       │     │  └──────────────────────────────┘ │
                       │     │                                    │
                       │     │  ┌──────────────────────────────┐ │
                       └─────┼──│ Grafana                      │ │
                             │  │  - Dashboards                │ │
                             │  │  - Alertas                   │ │
                             │  └──────────────────────────────┘ │
                             └────────────────────────────────────┘
```

## 🔧 Componentes Principales

### **1. API REST Service**

**Responsabilidades:**
- Gestionar ciclo de vida de servidores Minecraft (crear, iniciar, detener, eliminar)
- Intermediario entre clientes y Docker Engine
- Autenticación y autorización de usuarios
- Validación de datos y business logic
- Streaming de logs en tiempo real (WebSocket)
- Gestión de backups

**Tecnología:**
- **Lenguaje:** Node.js 20+ (o Python 3.11+)
- **Framework:** Express.js (o FastAPI)
- **Cliente Docker:** Dockerode (o Docker SDK for Python)
- **Autenticación:** JSON Web Tokens (JWT)
- **Validación:** Joi/Yup (o Pydantic)
- **WebSocket:** Socket.io (o WebSockets nativo)

**Estructura Interna:**
```
api/
├── src/
│   ├── controllers/        # Lógica de endpoints
│   │   ├── serverController.js
│   │   ├── userController.js
│   │   └── backupController.js
│   ├── services/           # Lógica de negocio
│   │   ├── dockerService.js
│   │   ├── databaseService.js
│   │   └── backupService.js
│   ├── routes/             # Definición de rutas
│   │   ├── serverRoutes.js
│   │   ├── userRoutes.js
│   │   └── healthRoutes.js
│   ├── models/             # Modelos de datos
│   │   ├── Server.js
│   │   ├── User.js
│   │   └── Backup.js
│   ├── middleware/         # Middleware
│   │   ├── auth.js
│   │   ├── validation.js
│   │   ├── rateLimit.js
│   │   └── errorHandler.js
│   ├── utils/              # Utilidades
│   │   ├── logger.js
│   │   ├── portManager.js
│   │   └── helpers.js
│   ├── config/             # Configuración
│   │   ├── database.js
│   │   ├── docker.js
│   │   └── app.js
│   └── index.js            # Entry point
├── tests/
├── Dockerfile
└── package.json
```

### **2. Minecraft Server Container**

**Características:**
- Basado en imagen `itzg/minecraft-server`
- Tipo: Paper Server (optimizado)
- Java: OpenJDK 21
- Configuración mediante variables de entorno
- Health checks integrados
- Auto-pause cuando no hay jugadores (ahorro recursos)

**Configuración:**
```dockerfile
FROM itzg/minecraft-server:java21

ENV TYPE=PAPER \
    VERSION=1.21.1 \
    EULA=TRUE \
    MEMORY=4G \
    MAX_PLAYERS=20 \
    DIFFICULTY=normal \
    GAMEMODE=survival \
    PVP=true \
    VIEW_DISTANCE=10 \
    ENABLE_AUTOPAUSE=TRUE \
    AUTOPAUSE_TIMEOUT_EST=300 \
    AUTOPAUSE_TIMEOUT_KN=120

VOLUME /data
EXPOSE 25565
```

**Volúmenes:**
- `/data` - Mundo, configuraciones, plugins, logs

**Puertos:**
- `25565` - Puerto base (dinámico: 25565, 25566, 25567...)

### **3. PostgreSQL Database**

**Schema Principal:**

```sql
-- Tabla de servidores
CREATE TABLE servers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL UNIQUE,
    container_id VARCHAR(255) UNIQUE,
    container_name VARCHAR(255) UNIQUE,
    port INTEGER NOT NULL,
    minecraft_version VARCHAR(50) NOT NULL,
    server_type VARCHAR(50) NOT NULL DEFAULT 'paper',
    memory_mb INTEGER NOT NULL DEFAULT 4096,
    max_players INTEGER NOT NULL DEFAULT 20,
    difficulty VARCHAR(50) DEFAULT 'normal',
    gamemode VARCHAR(50) DEFAULT 'survival',
    pvp BOOLEAN DEFAULT true,
    status VARCHAR(50) NOT NULL DEFAULT 'stopped',
    owner_id UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tabla de configuraciones personalizadas
CREATE TABLE server_configs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    server_id UUID REFERENCES servers(id) ON DELETE CASCADE,
    config_key VARCHAR(255) NOT NULL,
    config_value TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(server_id, config_key)
);

-- Tabla de usuarios
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT NOW(),
    last_login TIMESTAMP
);

-- Tabla de logs de servidores
CREATE TABLE server_logs (
    id BIGSERIAL PRIMARY KEY,
    server_id UUID REFERENCES servers(id) ON DELETE CASCADE,
    log_level VARCHAR(50),
    message TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT NOW()
);

-- Índices para mejorar consultas
CREATE INDEX idx_servers_status ON servers(status);
CREATE INDEX idx_servers_owner ON servers(owner_id);
CREATE INDEX idx_logs_server ON server_logs(server_id, timestamp DESC);

-- Tabla de backups
CREATE TABLE backups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    server_id UUID REFERENCES servers(id) ON DELETE CASCADE,
    filename VARCHAR(255) NOT NULL,
    size_bytes BIGINT,
    storage_path TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
```

### **4. Redis Cache (Opcional)**

**Uso:**
- Almacenamiento de sesiones JWT
- Cache de estados de servidores
- Rate limiting counters
- Lock distribuido para operaciones concurrentes

**Estructura de Datos:**
```
# Estados de servidores (cache)
server:{server_id}:status -> "running" | "stopped" | "starting" | "error"
server:{server_id}:players -> Integer (jugadores online)
server:{server_id}:metrics -> JSON {cpu, ram, tps}

# Rate limiting
ratelimit:{user_id}:{endpoint} -> Counter with TTL

# Locks
lock:server:{server_id}:operation -> 1 (con TTL de 30s)
```

### **5. BungeeCord Proxy (Opcional - Futuro)**

**Función:**
- Conectar múltiples servidores Minecraft
- Punto de entrada único para jugadores
- Balanceo de carga entre servidores
- Comandos para moverse entre servidores (/server lobby)

**Configuración:**
```yaml
# config.yml
listeners:
  - host: 0.0.0.0:25577
    max_players: 100
    force_default_server: true

servers:
  lobby:
    address: mc-server-lobby:25565
    restricted: false
  survival:
    address: mc-server-survival:25565
  creative:
    address: mc-server-creative:25565
```

### **6. Nginx Reverse Proxy**

**Función:**
- SSL/TLS termination
- Reverse proxy para API
- Static file serving (dashboard web futuro)
- WebSocket proxy

**Configuración:**
```nginx
upstream api_backend {
    server api:3000;
}

server {
    listen 80;
    server_name dockercraft.example.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name dockercraft.example.com;

    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;

    location /api/ {
        proxy_pass http://api_backend/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /ws/ {
        proxy_pass http://api_backend/ws/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

## 🌐 Networking

### **Docker Networks**

```yaml
networks:
  frontend:
    driver: bridge
    # Para servicios expuestos públicamente
    
  backend:
    driver: bridge
    internal: true
    # Para comunicación entre servicios internos
    
  minecraft:
    driver: bridge
    # Para servidores Minecraft y proxy
```

### **Asignación de Puertos**

```
Host Machine:
├── 80/443    → Nginx (HTTPS/API)
├── 25565     → MC Server 1 (o Proxy)
├── 25566     → MC Server 2
├── 25567     → MC Server 3
├── 2556N     → MC Server N
└── 5432      → PostgreSQL (solo interno)

Interna (Docker):
├── api:3000
├── postgres:5432
├── redis:6379
└── prometheus:9090
```

### **Gestión Dinámica de Puertos**

La API mantiene un registro de puertos disponibles:

```javascript
class PortManager {
  constructor() {
    this.basePort = 25565;
    this.maxPort = 25665; // Máximo 100 servidores
    this.usedPorts = new Set();
  }
  
  async getNextAvailablePort() {
    const usedPorts = await this.getUsedPortsFromDB();
    for (let port = this.basePort; port <= this.maxPort; port++) {
      if (!usedPorts.has(port)) {
        return port;
      }
    }
    throw new Error('No available ports');
  }
}
```

## 🔄 Flujos de Datos

### **Flujo 1: Creación de Servidor**

```
1. Cliente → API POST /api/servers
   {
     "name": "survival-1",
     "version": "1.21.1",
     "memory": "4G",
     "maxPlayers": 20
   }

2. API valida datos y autenticación

3. API obtiene puerto disponible (PortManager)

4. API llama a Docker API para crear contenedor
   docker.createContainer({
     Image: 'itzg/minecraft-server:java21',
     Env: ['VERSION=1.21.1', 'MEMORY=4G', ...],
     HostConfig: {
       PortBindings: { '25565/tcp': [{ HostPort: '25566' }] },
       Memory: 4 * 1024 * 1024 * 1024
     }
   })

5. Docker Engine crea y arranca contenedor

6. API guarda registro en PostgreSQL
   INSERT INTO servers (name, container_id, port, ...)

7. API devuelve respuesta al cliente
   {
     "id": "uuid",
     "name": "survival-1",
     "status": "starting",
     "connection": "server.com:25566"
   }

8. (Async) API monitorea salud del contenedor
```

### **Flujo 2: Obtener Estado de Servidor**

```
1. Cliente → API GET /api/servers/:id

2. API busca servidor en DB
   SELECT * FROM servers WHERE id = :id

3. API consulta Docker API por estado del contenedor
   docker.getContainer(container_id).inspect()

4. API obtiene métricas en tiempo real
   - CPU usage
   - RAM usage
   - Players online (via RCON/Query)

5. API devuelve datos consolidados
   {
     "id": "uuid",
     "name": "survival-1",
     "status": "running",
     "metrics": {
       "cpu": 45.2,
       "ram": 3200,
       "players": 5
     }
   }
```

### **Flujo 3: Backup de Servidor**

```
1. Cliente → API POST /api/servers/:id/backup

2. API detiene escrituras (envía comando 'save-off' via RCON)

3. API ejecuta 'save-all' para flush de datos

4. Docker API copia archivos del volumen
   docker cp container:/data ./backups/survival-1-2025-10-24.tar.gz

5. Compresión de archivos (tar + gzip)

6. Upload a storage (local o cloud S3/GCS)

7. Registro en DB
   INSERT INTO backups (server_id, filename, size_bytes, ...)

8. API reactiva escrituras ('save-on' via RCON)

9. Respuesta al cliente con URL del backup
```

## 🔐 Seguridad

### **Capa 1: Red**
- Firewall configurado (solo puertos necesarios)
- Redes Docker internas para servicios backend
- No exponer Docker socket directamente

### **Capa 2: Aplicación**
- JWT para autenticación
- RBAC (Role-Based Access Control)
- Rate limiting (1000 req/15min por user)
- Input validation (Joi/Pydantic)
- SQL injection prevention (prepared statements)

### **Capa 3: Contenedores**
- Contenedores ejecutan como usuario no-root
- Resource limits (CPU, RAM) para evitar DoS
- Read-only filesystem donde sea posible
- Security scanning de imágenes (Trivy)

### **Capa 4: Datos**
- Passwords hasheados (bcrypt, cost=12)
- Secrets en variables de entorno (no hardcoded)
- TLS/SSL para comunicación externa
- Backups encriptados

## 📊 Escalabilidad

### **Vertical Scaling**
- Aumentar recursos del host (más CPU, RAM)
- Configurar límites por contenedor según demanda

### **Horizontal Scaling (Futuro)**
- Múltiples nodos Docker Swarm o Kubernetes
- Load balancer para distribución de servidores
- Base de datos replicada
- Almacenamiento distribuido (S3/GCS)

### **Optimizaciones**
- Auto-pause de servidores sin jugadores
- Cache en Redis para queries frecuentes
- Connection pooling para DB
- Compresión de respuestas API (gzip)

## 🛠️ Decisiones Técnicas Clave

### ✅ Docker sobre VM/Bare Metal
**Razón:** Mejor aislamiento, portabilidad y gestión de recursos

### ✅ Paper sobre Vanilla
**Razón:** Mejor rendimiento, compatible con plugins, más configurable

### ✅ PostgreSQL sobre MongoDB
**Razón:** Datos estructurados, relaciones complejas, ACID compliance

### ✅ itzg/minecraft-server sobre custom image
**Razón:** Mantenida, feature-rich, soporte multi-versión

### ✅ JWT sobre sesiones tradicionales
**Razón:** Stateless, escalable, compatible con microservicios

---

**Próximo:** Leer `03_DECISIONS.md` para profundizar en decisiones de diseño

