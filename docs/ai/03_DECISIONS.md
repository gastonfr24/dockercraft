# 📋 Registro de Decisiones Técnicas (ADR - Architecture Decision Records)

> **Última actualización:** 2025-10-24  
> **Versión:** v0.1.0-alpha

Este documento registra todas las decisiones técnicas importantes del proyecto siguiendo el formato ADR (Architecture Decision Record).

## 📖 Formato de ADR

Cada decisión sigue esta estructura:

```
## ADR-XXX: [Título de la Decisión]

**Estado:** [Propuesto / Aceptado / Rechazado / Obsoleto / Supersedido]
**Fecha:** YYYY-MM-DD
**Decidido por:** [Equipo / Nombre]
**Contexto:** ¿Por qué necesitamos decidir esto?
**Decisión:** ¿Qué se decidió?
**Consecuencias:** ¿Qué implica esta decisión?
**Alternativas Consideradas:** ¿Qué otras opciones se evaluaron?
```

---

## ADR-001: Uso de Docker para Containerización

**Estado:** ✅ Aceptado  
**Fecha:** 2025-10-24  
**Contexto:**

Necesitamos una forma de ejecutar múltiples servidores Minecraft de manera aislada, reproducible y escalable. Las opciones incluyen:
- Bare metal (instalación directa en servidor)
- Máquinas virtuales (VM)
- Contenedores (Docker)
- Kubernetes desde el inicio

**Decisión:**

Usar **Docker** como plataforma de containerización para todos los servidores Minecraft.

**Consecuencias:**

**Positivas:**
- ✅ Aislamiento completo entre servidores
- ✅ Portabilidad entre diferentes hosts
- ✅ Gestión simplificada mediante Docker API
- ✅ Versionado de imágenes
- ✅ Resource limits nativos (CPU, RAM)
- ✅ Rápida replicación de servidores
- ✅ Ecosistema maduro con buenas herramientas

**Negativas:**
- ❌ Overhead mínimo de virtualización
- ❌ Requiere conocimientos de Docker
- ❌ Necesita Docker instalado en host

**Alternativas Consideradas:**

1. **Bare Metal**
   - ❌ No hay aislamiento
   - ❌ Difícil gestionar múltiples versiones de Java
   - ❌ Conflictos de puertos y recursos
   - ✅ Sin overhead de virtualización

2. **Máquinas Virtuales (VirtualBox, VMware)**
   - ❌ Mayor overhead de recursos
   - ❌ Más lento para crear/destruir instancias
   - ✅ Aislamiento completo a nivel de kernel

3. **Kubernetes desde el inicio**
   - ❌ Complejidad innecesaria para MVP
   - ❌ Requiere cluster (mínimo 3 nodos)
   - ✅ Auto-scaling nativo
   - ✅ Orquestación avanzada
   - 💡 Considerado para fase futura

**Decisión Final:** Docker es el balance óptimo entre simplicidad y funcionalidad para este proyecto.

---

## ADR-002: Imagen Base itzg/minecraft-server

**Estado:** ✅ Aceptado  
**Fecha:** 2025-10-24  
**Contexto:**

Necesitamos una imagen Docker base para los servidores Minecraft. Podemos:
- Crear imagen custom desde cero
- Usar imagen pre-existente de la comunidad

**Decisión:**

Usar la imagen **`itzg/minecraft-server`** como base para todos los servidores.

**Consecuencias:**

**Positivas:**
- ✅ Mantenida activamente por la comunidad
- ✅ Soporta todas las variantes (Vanilla, Paper, Forge, Fabric, etc.)
- ✅ Documentación extensa
- ✅ Variables de entorno bien diseñadas
- ✅ Features avanzadas (auto-pause, auto-update, mods/plugins auto-download)
- ✅ Health checks integrados
- ✅ Multi-arch (AMD64, ARM64)

**Negativas:**
- ❌ Dependencia de tercero
- ❌ Imagen base grande (~1GB)
- ❌ Posible discontinuación (riesgo bajo)

**Alternativas Consideradas:**

1. **Imagen Custom**
   - ✅ Control total
   - ❌ Mantenimiento propio
   - ❌ Reinventar la rueda
   - ❌ Más tiempo de desarrollo

2. **Otras imágenes comunitarias**
   - `minecraft-server` (Alpine-based)
   - `nimmis/minecraft-server`
   - ❌ Menos features que itzg
   - ❌ Menos mantenimiento

**Decisión Final:** `itzg/minecraft-server` es la opción más madura y feature-rich.

**Referencias:**
- [GitHub itzg/minecraft-server](https://github.com/itzg/docker-minecraft-server)

---

## ADR-003: Paper como Tipo de Servidor por Defecto

**Estado:** ✅ Aceptado  
**Fecha:** 2025-10-24  
**Contexto:**

Debemos elegir qué tipo de servidor Minecraft usar por defecto:
- Vanilla (oficial de Mojang)
- Spigot (fork con API de plugins)
- Paper (fork optimizado de Spigot)
- Forge (para mods)
- Fabric (para mods, más moderno)

**Decisión:**

Usar **Paper** como tipo de servidor por defecto.

**Consecuencias:**

**Positivas:**
- ✅ Mejor rendimiento que Vanilla y Spigot
- ✅ Compatible con plugins Bukkit/Spigot
- ✅ Anti-cheat mejorado
- ✅ Configuración avanzada (paper.yml)
- ✅ Optimizaciones de redstone y chunks
- ✅ Mantenido activamente
- ✅ Updates rápidos para nuevas versiones

**Negativas:**
- ❌ No 100% vanilla (mínimas diferencias)
- ❌ No soporta mods (solo plugins)

**Alternativas Consideradas:**

1. **Vanilla**
   - ✅ 100% oficial
   - ❌ Sin soporte de plugins
   - ❌ Peor rendimiento

2. **Spigot**
   - ✅ Soporte de plugins
   - ❌ Peor rendimiento que Paper
   - ❌ Menos features

3. **Forge/Fabric**
   - ✅ Soporte de mods
   - ❌ Incompatible con plugins
   - ❌ Más complejo configurar
   - ❌ Mayor uso de recursos
   - 💡 Ofrecer como opción futura

**Decisión Final:** Paper ofrece el mejor balance rendimiento/features para mayoría de casos de uso.

---

## ADR-004: Node.js para API Backend

**Estado:** ⚠️ Propuesto (Pendiente confirmación)  
**Fecha:** 2025-10-24  
**Contexto:**

Necesitamos elegir lenguaje y framework para la API REST. Opciones principales:
- Node.js + Express
- Python + FastAPI
- Go
- Rust

**Decisión Propuesta:**

Usar **Node.js con Express.js** para la API backend.

**Consecuencias:**

**Positivas:**
- ✅ Ecosistema npm amplio
- ✅ Async/await nativo (ideal para I/O)
- ✅ Dockerode (excelente cliente Docker)
- ✅ WebSocket nativo con Socket.io
- ✅ Rápido desarrollo
- ✅ JSON nativo
- ✅ Gran comunidad

**Negativas:**
- ❌ Sin tipado estático nativo (solucionable con TypeScript)
- ❌ Single-threaded (no crítico para I/O bound)
- ❌ NPM dependencies pueden ser pesadas

**Alternativas Consideradas:**

1. **Python + FastAPI**
   - ✅ Tipado estático con Pydantic
   - ✅ Auto-documentación (OpenAPI)
   - ✅ Docker SDK oficial
   - ✅ Async nativo
   - ❌ Más lento que Node.js para I/O
   - ❌ Menos maduro WebSocket support
   - 💡 Excelente alternativa

2. **Go**
   - ✅ Alto rendimiento
   - ✅ Concurrencia nativa (goroutines)
   - ✅ Tipado estático
   - ❌ Mayor complejidad
   - ❌ Desarrollo más lento
   - ❌ Ecosistema más pequeño

3. **Rust**
   - ✅ Máximo rendimiento
   - ✅ Memory safety
   - ❌ Curva de aprendizaje empinada
   - ❌ Desarrollo muy lento
   - ❌ Overkill para este caso de uso

**Decisión Final:** Node.js es el balance óptimo velocidad de desarrollo vs rendimiento.

**Nota:** Si se prefiere tipado estático fuerte, considerar **TypeScript** o cambiar a **Python + FastAPI**.

---

## ADR-005: PostgreSQL como Base de Datos Principal

**Estado:** ✅ Aceptado  
**Fecha:** 2025-10-24  
**Contexto:**

Necesitamos persistir datos de servidores, usuarios, configuraciones, logs. Opciones:
- SQL: PostgreSQL, MySQL, SQLite
- NoSQL: MongoDB, CouchDB
- NewSQL: CockroachDB

**Decisión:**

Usar **PostgreSQL** como base de datos principal.

**Consecuencias:**

**Positivas:**
- ✅ ACID compliance (consistencia garantizada)
- ✅ Relaciones complejas (Foreign Keys)
- ✅ JSON support (jsonb) para configs flexibles
- ✅ Índices potentes
- ✅ Triggers y funciones
- ✅ Maduro y estable
- ✅ Excelente rendimiento

**Negativas:**
- ❌ Requiere schema rígido
- ❌ Migraciones necesarias para cambios
- ❌ Más complejo que NoSQL para datos no estructurados

**Alternativas Consideradas:**

1. **MongoDB**
   - ✅ Schema flexible
   - ✅ JSON nativo
   - ❌ Sin relaciones fuertes
   - ❌ No ACID por defecto
   - ❌ Queries más complejas

2. **MySQL**
   - ✅ Popular
   - ✅ Buen rendimiento
   - ❌ Menos features que PostgreSQL
   - ❌ JSON support inferior

3. **SQLite**
   - ✅ Sin servidor necesario
   - ✅ Simple
   - ❌ No concurrency para escrituras
   - ❌ No apto para producción multi-usuario

**Decisión Final:** PostgreSQL ofrece robustez, features avanzadas y flexibilidad con jsonb.

---

## ADR-006: JWT para Autenticación

**Estado:** ✅ Aceptado  
**Fecha:** 2025-10-24  
**Contexto:**

La API necesita autenticación y autorización. Opciones:
- Session-based (cookies)
- Token-based (JWT)
- OAuth 2.0

**Decisión:**

Usar **JSON Web Tokens (JWT)** para autenticación.

**Consecuencias:**

**Positivas:**
- ✅ Stateless (no requiere storage de sesiones)
- ✅ Escalable horizontalmente
- ✅ Compatible con microservicios
- ✅ Payload customizable (roles, permissions)
- ✅ Estándar de la industria
- ✅ Cross-domain friendly

**Negativas:**
- ❌ No se puede "revocar" token fácilmente (hasta expiración)
- ❌ Payload visible (base64, no encriptado)
- ❌ Tamaño mayor que session ID

**Alternativas Consideradas:**

1. **Session-based (cookies)**
   - ✅ Fácil revocación
   - ✅ Más seguro (no expone datos)
   - ❌ Requiere storage (Redis/DB)
   - ❌ No escalable sin sticky sessions

2. **OAuth 2.0**
   - ✅ Estándar para delegación
   - ✅ Social login (Google, GitHub)
   - ❌ Complejidad innecesaria para MVP
   - 💡 Considerar para futuro

**Decisión Final:** JWT es el estándar moderno para APIs stateless.

**Implementación:**
- Access Token: 15 minutos de vida
- Refresh Token: 7 días de vida
- Almacenar Refresh Token en DB para revocación

---

## ADR-007: Docker Compose para Orquestación Local

**Estado:** ✅ Aceptado  
**Fecha:** 2025-10-24  
**Contexto:**

Necesitamos orquestar múltiples servicios (API, DB, servidores MC). Opciones:
- Docker Compose
- Docker Swarm
- Kubernetes
- Scripts manuales

**Decisión:**

Usar **Docker Compose** para desarrollo y deployments iniciales.

**Consecuencias:**

**Positivas:**
- ✅ Simple y declarativo (YAML)
- ✅ Ideal para desarrollo local
- ✅ Gestión de networks y volumes
- ✅ Variables de entorno (.env)
- ✅ Fácil setup (docker-compose up)

**Negativas:**
- ❌ No es cluster-aware (single host)
- ❌ Sin auto-scaling
- ❌ Sin auto-healing robusto
- ❌ No apto para producción a gran escala

**Alternativas Consideradas:**

1. **Kubernetes**
   - ✅ Auto-scaling
   - ✅ Self-healing
   - ✅ Multi-nodo
   - ❌ Complejidad alta
   - ❌ Overkill para MVP
   - 💡 Migration path futuro

2. **Docker Swarm**
   - ✅ Orquestación simple
   - ✅ Multi-nodo
   - ❌ Menos features que K8s
   - ❌ Comunidad más pequeña

**Decisión Final:** Docker Compose para MVP, migrar a K8s cuando se necesite escalar.

---

## ADR-008: Asignación Dinámica de Puertos

**Estado:** ✅ Aceptado  
**Fecha:** 2025-10-24  
**Contexto:**

Cada servidor Minecraft necesita un puerto único. Opciones:
- Asignación manual
- Asignación dinámica (API gestiona pool)
- Proxy con puerto único (BungeeCord)

**Decisión:**

Usar **asignación dinámica de puertos** gestionada por la API.

**Consecuencias:**

**Positivas:**
- ✅ Automatizado
- ✅ Sin conflictos
- ✅ Escalable
- ✅ Tracking en base de datos

**Negativas:**
- ❌ Requiere firewall configurado para rango de puertos
- ❌ Jugadores necesitan saber puerto específico

**Alternativas Consideradas:**

1. **Asignación Manual**
   - ❌ Propenso a errores
   - ❌ No escalable

2. **Proxy Único (BungeeCord)**
   - ✅ Un solo puerto para todos
   - ✅ Experiencia unificada
   - ❌ Complejidad adicional
   - ❌ Single point of failure
   - 💡 Implementar en fase 2

**Decisión Final:** Asignación dinámica para MVP, agregar proxy como feature opcional.

**Implementación:**
```javascript
// PortManager - Gestiona pool de puertos 25565-25665
const BASE_PORT = 25565;
const MAX_SERVERS = 100;
```

---

## ADR-009: Volúmenes Docker para Persistencia

**Estado:** ✅ Aceptado  
**Fecha:** 2025-10-24  
**Contexto:**

Los mundos de Minecraft deben persistir entre reinicios de contenedores. Opciones:
- Named volumes de Docker
- Bind mounts a host filesystem
- Volúmenes efímeros (no persisten)

**Decisión:**

Usar **Docker Named Volumes** para persistencia de datos de servidores.

**Consecuencias:**

**Positivas:**
- ✅ Gestionados por Docker
- ✅ Mejor rendimiento que bind mounts
- ✅ Portables entre hosts (con backups)
- ✅ Isolación de filesystem
- ✅ Fácil backup (docker cp o plugins de backup)

**Negativas:**
- ❌ Menos accesibles directamente desde host
- ❌ Requiere comandos Docker para acceder

**Alternativas Consideradas:**

1. **Bind Mounts**
   - ✅ Acceso directo desde host
   - ✅ Fácil edición manual
   - ❌ Peor rendimiento (especialmente Windows/Mac)
   - ❌ Problemas de permisos

2. **Volúmenes Efímeros**
   - ✅ Rápido
   - ❌ Se pierden al eliminar contenedor
   - ❌ No apto para producción

**Decisión Final:** Named volumes son el estándar de Docker para datos persistentes.

**Naming Convention:**
```
mc-server-{name}-data
mc-server-{name}-logs
```

---

## ADR-010: Auto-Pause para Servidores Inactivos

**Estado:** ✅ Aceptado  
**Fecha:** 2025-10-24  
**Contexto:**

Servidores sin jugadores consumen recursos innecesariamente. Opciones:
- Mantener siempre running
- Stop manual
- Auto-pause (feature de itzg/minecraft-server)
- Auto-stop completo

**Decisión:**

Habilitar **AUTO-PAUSE** por defecto en todos los servidores.

**Consecuencias:**

**Positivas:**
- ✅ Ahorro significativo de CPU (casi 0% cuando paused)
- ✅ Ahorro de RAM
- ✅ Servidor responde automáticamente al conectar jugador
- ✅ Experiencia transparente para usuarios
- ✅ Feature nativa de la imagen

**Negativas:**
- ❌ Delay de 1-3 segundos al conectar primer jugador
- ❌ No funciona con algunos plugins que hacen background tasks

**Alternativas Consideradas:**

1. **Siempre Running**
   - ❌ Desperdicio de recursos
   - ❌ No escalable

2. **Auto-Stop Completo**
   - ✅ Máximo ahorro
   - ❌ Requiere acción manual para reiniciar
   - ❌ Mala UX

**Decisión Final:** Auto-pause es el balance perfecto ahorro/UX.

**Configuración:**
```dockerfile
ENV ENABLE_AUTOPAUSE=TRUE
ENV AUTOPAUSE_TIMEOUT_EST=300  # 5 min para detectar sin jugadores
ENV AUTOPAUSE_TIMEOUT_KN=120   # 2 min después de confirmado
```

---

## ADR-011: Backups en Local Storage (MVP)

**Estado:** ✅ Aceptado  
**Fecha:** 2025-10-24  
**Contexto:**

Necesitamos sistema de backups. Opciones storage:
- Local filesystem
- Cloud storage (S3, GCS, Azure Blob)
- Network attached storage (NAS)

**Decisión:**

Usar **local filesystem** para backups en MVP, con migración a cloud en roadmap.

**Consecuencias:**

**Positivas:**
- ✅ Simple implementación
- ✅ Sin costos de cloud storage
- ✅ Rápido para backup/restore
- ✅ Sin dependencias externas

**Negativas:**
- ❌ Limitado por disco del host
- ❌ Sin redundancia geográfica
- ❌ Vulnerable a fallo de hardware

**Alternativas Consideradas:**

1. **AWS S3 / Google Cloud Storage**
   - ✅ Ilimitado (prácticamente)
   - ✅ Durabilidad 99.999999999%
   - ✅ Geo-replicación
   - ❌ Costo por GB/mes
   - ❌ Requiere configuración de credenciales
   - 💡 Implementar en Fase 2

2. **NAS**
   - ✅ Centralizado
   - ❌ Requiere hardware adicional
   - ❌ Single point of failure

**Decisión Final:** Local para MVP, cloud como feature premium futuro.

**Path:** `/var/dockercraft/backups/{server_name}/`

---

## 🚧 Decisiones Pendientes

Estas decisiones requieren input antes de implementación:

### ⏳ PD-001: TypeScript vs JavaScript

**Contexto:** Si usamos Node.js, ¿usamos TypeScript para tipado estático?

**Pros TypeScript:**
- ✅ Type safety
- ✅ Mejor IDE support
- ✅ Menos bugs

**Cons TypeScript:**
- ❌ Setup adicional
- ❌ Compile step
- ❌ Curva de aprendizaje

**Recomendación:** TypeScript para proyectos medianos/grandes

---

### ⏳ PD-002: ORM vs Query Builder vs Raw SQL

**Contexto:** ¿Cómo interactuamos con PostgreSQL?

**Opciones:**
1. **Sequelize / TypeORM** (ORM)
   - ✅ Abstracción
   - ❌ Magic oculto
   
2. **Knex.js** (Query Builder)
   - ✅ Balance abstracción/control
   - ✅ Migrations integradas
   
3. **pg (node-postgres)** (Raw SQL)
   - ✅ Máximo control
   - ❌ Más verbose

**Recomendación:** Knex.js

---

### ⏳ PD-003: Monorepo vs Multi-repo

**Contexto:** ¿Un repositorio para todo o separar API, frontend, docs?

**Recomendación:** Monorepo para MVP (más simple), considerar split para escala

---

## 📚 Referencias

- [ADR GitHub Organization](https://adr.github.io/)
- [Documenting Architecture Decisions](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)
- [Architecture Decision Records (ThoughtWorks)](https://www.thoughtworks.com/radar/techniques/lightweight-architecture-decision-records)

---

**Nota para IA:** Al tomar nuevas decisiones técnicas, agregar un nuevo ADR siguiendo el formato establecido. Mantener este documento actualizado es crítico para contexto histórico.

