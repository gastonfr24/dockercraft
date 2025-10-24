# 📌 Contexto del Proyecto - DockerCraft

> **Última actualización:** 2025-10-24  
> **Versión:** v0.1.0-alpha  
> **Estado:** 🚧 Planificación inicial

## 🎯 Resumen Ejecutivo

**DockerCraft** es el **servidor base de Minecraft containerizado** que sirve como plantilla/template para crear múltiples instancias de servidores bajo demanda. Este proyecto contiene SOLO la configuración Docker optimizada que será consumida por una API externa (proyecto separado) para crear N servidores con diferentes configuraciones.

### **Problema que Resuelve**

- ❌ Configuración manual de cada servidor Minecraft
- ❌ Inconsistencias entre servidores
- ❌ Difícil replicar configuración optimizada
- ❌ No hay template reutilizable

### **Solución que Ofrece Este Proyecto**

- ✅ Imagen Docker base optimizada y configurable
- ✅ Configuración mediante variables de entorno
- ✅ Template reutilizable para crear N instancias
- ✅ Persistencia de datos con volúmenes
- ✅ Auto-pause para ahorro de recursos
- ✅ Health checks integrados

## 🏗️ Arquitectura - Este Proyecto

```
┌──────────────────────────────────────────────────┐
│         API EXTERNA (Proyecto Separado)          │
│  - Gestiona creación de servidores               │
│  - Controla ciclo de vida                        │
│  - Base de datos de configuraciones              │
└────────────────┬─────────────────────────────────┘
                 │
                 │ Consume este proyecto
                 │ via Docker API
                 ▼
┌──────────────────────────────────────────────────┐
│      ESTE PROYECTO: dockercraft/                 │
│                                                   │
│  ┌────────────────────────────────────────────┐ │
│  │   Dockerfile Base (Template)               │ │
│  │   - Imagen itzg/minecraft-server           │ │
│  │   - Variables de entorno                   │ │
│  │   - Optimizaciones                         │ │
│  │   - Health checks                          │ │
│  └────────────────────────────────────────────┘ │
│                                                   │
│  ┌────────────────────────────────────────────┐ │
│  │   Configuración Base                       │ │
│  │   - server.properties                      │ │
│  │   - JVM flags optimizados                  │ │
│  │   - Plugins base (opcional)                │ │
│  └────────────────────────────────────────────┘ │
│                                                   │
│  ┌────────────────────────────────────────────┐ │
│  │   Docker Compose (Ejemplo de Uso)          │ │
│  │   - Cómo levantar servidor standalone      │ │
│  │   - Testing local                          │ │
│  └────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────┘
                 │
                 │ API crea instancias
                 ▼
┌──────────────────────────────────────────────────┐
│         Docker Engine (Host)                     │
│                                                   │
│  ┌─────────────┐  ┌─────────────┐  ┌──────────┐│
│  │ Instance 1  │  │ Instance 2  │  │Instance N││
│  │ (Port 25565)│  │ (Port 25566)│  │(Port...)  ││
│  └─────────────┘  └─────────────┘  └──────────┘│
│                                                   │
│  Cada instancia usa la imagen/config base       │
│  pero con variables de entorno diferentes        │
└──────────────────────────────────────────────────┘
```

## 📍 Estado Actual del Proyecto

### **Fase:** Planificación inicial (Sprint 0)

### **Completado:**
- [x] Investigación de arquitecturas modernas
- [x] Definición de stack tecnológico
- [x] Plan de implementación detallado
- [x] Estructura de documentación para IA

### **En Progreso:**
- [ ] Creación de estructura de carpetas
- [ ] Configuración del entorno de desarrollo

### **Próximo Paso:**
1. Crear Dockerfile base para Minecraft
2. Configurar Docker Compose inicial
3. Implementar primer servidor funcional

## 🎯 Objetivos de ESTE Proyecto

### **Objetivo Principal**

Crear un **servidor base de Minecraft en Docker altamente configurable** que pueda ser usado como template para crear múltiples instancias con diferentes configuraciones mediante una API externa.

### **Objetivos Específicos**

1. **Dockerfile Optimizado**
   - Basado en `itzg/minecraft-server`
   - Configuración vía variables de entorno
   - Health checks robustos
   - Auto-pause habilitado
   - Optimizaciones de JVM

2. **Configuración Flexible**
   - Todas las propiedades configurables vía ENV vars
   - Soporte para múltiples versiones de Minecraft
   - Soporte para múltiples tipos (Paper, Spigot, Vanilla, Forge, Fabric)
   - Plugins/mods pre-configurables

3. **Persistencia de Datos**
   - Volúmenes Docker para mundos
   - Configuraciones persistentes
   - Logs accesibles

4. **Documentación Clara**
   - Cómo usar este template
   - Variables de entorno disponibles
   - Cómo integrar con API externa
   - Ejemplos de uso

### **Objetivos Secundarios**

4. **Testing y Ejemplos**
   - Docker Compose con ejemplos de uso
   - Ejemplo de servidor único
   - Ejemplo de múltiples servidores
   - Scripts de testing

5. **Optimizaciones de Rendimiento**
   - JVM flags optimizados por uso de RAM
   - Configuraciones de Paper optimizadas
   - Resource limits recomendados

6. **Extensibilidad**
   - Fácil agregar plugins base
   - Fácil agregar mods
   - Hooks para customización

### **NO es Objetivo de Este Proyecto**

❌ Implementar API REST (va en proyecto separado)  
❌ Sistema de autenticación  
❌ Base de datos para gestión  
❌ Dashboard web  
❌ Sistema de backups automatizado  
❌ Monitoreo avanzado  
❌ Proxy BungeeCord  
❌ Billing o pagos  

**Estos features irán en el proyecto de la API externa que consumirá este template.**

## 🎮 Casos de Uso Principales

### **Caso de Uso 1: Hosting de Servidores**
**Actor:** Proveedor de hosting de Minecraft  
**Objetivo:** Ofrecer servidores Minecraft gestionados a clientes

**Flujo:**
1. Cliente solicita servidor vía API
2. Sistema crea contenedor con configuración base
3. Cliente recibe IP:Puerto y credenciales
4. Sistema monitorea recursos y cobra según uso

### **Caso de Uso 2: Comunidad de Minecraft**
**Actor:** Administrador de comunidad  
**Objetivo:** Gestionar múltiples servidores temáticos

**Flujo:**
1. Admin crea servidor "Survival" vía dashboard
2. Admin crea servidor "Creative" con diferente config
3. Proxy conecta ambos servidores
4. Jugadores se mueven entre servidores sin desconectar

### **Caso de Uso 3: Servidor Temporal para Evento**
**Actor:** Organizador de evento  
**Objetivo:** Levantar servidor rápido para torneo

**Flujo:**
1. Crear servidor vía API con config específica
2. Servidor disponible en < 2 minutos
3. Al finalizar evento, eliminar servidor
4. Backup automático antes de eliminación

## 🛠️ Stack Tecnológico Elegido

### **Containerización**
- **Docker** - Containerización de servidores
- **Docker Compose** - Orquestación de servicios

### **Servidor Minecraft**
- **Imagen Base:** `itzg/minecraft-server` (mantenida, feature-rich)
- **Tipo de Servidor:** Paper (optimizado, compatible con plugins)
- **Java:** OpenJDK 21

### **API Backend**
- **Lenguaje:** Node.js (decisión pendiente vs Python)
- **Framework:** Express.js o FastAPI
- **Cliente Docker:** Dockerode (Node.js) o Docker SDK (Python)

### **Base de Datos**
- **Principal:** PostgreSQL (datos estructurados, ACID)
- **Cache:** Redis (opcional, para estados temporales)

### **Proxy (Opcional)**
- **BungeeCord** o **Velocity** para multi-servidor

### **Monitoreo (Futuro)**
- **Prometheus** - Recolección de métricas
- **Grafana** - Visualización

### **Reverse Proxy**
- **Nginx** o **Traefik** - Para API y futura interfaz web

## 📂 Estructura del Repositorio (ESTE PROYECTO)

```
dockercraft/                 # ⭐ SOLO servidor base Docker
│
├── docs/                    # Documentación
│   └── ai/                  # Docs para contexto de IA
│
├── Dockerfile               # ⭐ Imagen base optimizada
├── server.properties        # Configuración base del servidor
├── server-icon.png          # (Opcional) Ícono del servidor
│
├── config/                  # Configuraciones opcionales
│   ├── bukkit.yml           # (Si usa plugins)
│   ├── spigot.yml
│   └── paper.yml
│
├── plugins/                 # Plugins pre-instalados (opcional)
│   └── .gitkeep
│
├── mods/                    # Mods pre-instalados (opcional)
│   └── .gitkeep
│
├── scripts/                 # Scripts de utilidad
│   ├── health-check.sh      # Health check customizado
│   └── optimize-jvm.sh      # Optimizaciones JVM
│
├── docker-compose.yml       # ⭐ Ejemplo de uso (testing)
├── docker-compose.multi.yml # Ejemplo: múltiples servidores
│
├── .env.example             # Variables de entorno disponibles
├── .dockerignore
├── .gitignore
└── README.md                # Documentación de uso

NOTA: La API estará en otro proyecto/repositorio separado
```

## 🎓 Conocimiento Necesario

### **Para continuar este proyecto, una IA debe entender:**

- **Docker:** Containers, images, volumes, networks, Dockerfile, Docker Compose
- **Minecraft Server:** server.properties, plugins, mods, EULA, RCON
- **APIs REST:** HTTP methods, endpoints, JSON, authentication
- **Bases de datos:** Schema design, queries, migrations
- **Networking:** Ports, firewalls, reverse proxy, DNS
- **Linux:** Basic commands, file permissions, processes

## 🚧 Limitaciones Conocidas

1. **Puertos:** Cada servidor necesita puerto único (25565, 25566, etc.)
2. **Recursos:** Cada servidor Minecraft consume ~2-4GB RAM mínimo
3. **Persistencia:** Volúmenes Docker pueden crecer considerablemente
4. **EULA:** Usuarios deben aceptar EULA de Minecraft
5. **Licencias:** Respetar términos de Mojang/Microsoft

## 🔗 Referencias Clave

- [itzg/minecraft-server GitHub](https://github.com/itzg/docker-minecraft-server)
- [Paper MC](https://papermc.io/) - Servidor optimizado
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [Minecraft Server Properties](https://minecraft.fandom.com/wiki/Server.properties)

## 📞 Preguntas Pendientes de Definir

Estas decisiones deben tomarse antes de continuar:

1. ❓ **¿Versión de Minecraft por defecto?** (Recomendado: 1.21.1 - última stable)
2. ❓ **¿Java o Bedrock?** (Recomendado: Java - más flexible)
3. ❓ **¿Node.js o Python para API?** (Recomendado: Node.js - mejor async)
4. ❓ **¿Incluir proxy desde el inicio?** (Recomendado: No, post-MVP)
5. ❓ **¿RAM por defecto por servidor?** (Recomendado: 4GB para 20 jugadores)
6. ❓ **¿Plugins esenciales?** (Ej: LuckPerms, Essentials)
7. ❓ **¿Target de deployment?** (Local, VPS, Cloud)

## 🎯 Métricas de Éxito

### **MVP será exitoso cuando:**
- [x] Servidor Minecraft funcional en Docker
- [ ] API puede crear nuevo servidor en < 30 segundos
- [ ] API puede listar/iniciar/detener servidores
- [ ] Persistencia de datos funciona correctamente
- [ ] Documentación completa para deployment

### **Producto completo será exitoso cuando:**
- [ ] Puede gestionar 10+ servidores concurrentes
- [ ] Dashboard web intuitivo
- [ ] Sistema de backups automático
- [ ] Monitoreo en tiempo real
- [ ] Documentación pública para usuarios finales

---

## 🤖 Instrucciones para IA

**Si eres una IA leyendo esto por primera vez:**

1. **Contexto Adquirido:** Ahora entiendes que este proyecto crea servidores Minecraft dinámicos con Docker
2. **Próximo Paso:** Leer `02_ARCHITECTURE.md` para detalles técnicos
3. **Luego:** Revisar `04_MEMORY.md` para decisiones recientes
4. **Finalmente:** Consultar `05_ROADMAP.md` para saber qué implementar

**Pregunta clave para validar comprensión:**  
*¿Cuál es el propósito principal de la carpeta `minecraft-base/`?*

**Respuesta esperada:** Es la plantilla/configuración base del servidor Minecraft que se usará para crear instancias dinámicamente mediante la API.

---

**Documento vivo - Actualizar al cambiar objetivos o dirección del proyecto**

