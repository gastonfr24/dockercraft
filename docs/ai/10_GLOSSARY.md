# 📖 Glosario - DockerCraft

> **Última actualización:** 2025-10-24

Términos técnicos y definiciones usadas en este proyecto.

---

## 🎮 Términos de Minecraft

### **Bukkit**
Plugin API para servidores Minecraft. Base para Spigot y Paper.

### **Creative Mode**
Modo de juego con recursos ilimitados y vuelo. Ideal para construcción.

### **Difficulty**
Nivel de dificultad del juego:
- `peaceful` - Sin mobs hostiles
- `easy` - Mobs débiles
- `normal` - Balance estándar
- `hard` - Mobs más fuertes

### **EULA**
End User License Agreement de Mojang. Debe ser aceptado para correr servidor.

### **Forge**
Plataforma para mods de Minecraft. Permite modificaciones profundas del juego.

### **Fabric**
Alternativa moderna a Forge. Más ligero y modular.

### **Gamemode**
Modo de juego por defecto:
- `survival` - Supervivencia clásica
- `creative` - Creativo con recursos ilimitados
- `adventure` - Supervivencia con restricciones
- `spectator` - Observador sin interacción

### **Hardcore**
Modo survival con muerte permanente y difficulty locked en hard.

### **Mods**
Modificaciones del juego que cambian mecánicas o agregan contenido. Requieren Forge/Fabric.

### **MOTD (Message of the Day)**
Mensaje mostrado en la lista de servidores del cliente Minecraft.

### **Op (Operator)**
Jugador con permisos administrativos en el servidor.

### **Paper**
Fork optimizado de Spigot. Mejor rendimiento y más configuraciones.

### **Plugins**
Extensiones del servidor que agregan funcionalidades. Compatible con Bukkit/Spigot/Paper.

### **PVP (Player vs Player)**
Combate entre jugadores. Puede habilitarse o deshabilitarse.

### **RCON (Remote Console)**
Protocolo para ejecutar comandos remotamente en el servidor.

### **Seed**
Número que genera un mundo específico. Mismo seed = mismo mundo.

### **Simulation Distance**
Distancia en chunks donde se actualizan mobs y redstone.

### **Spawn Protection**
Radio alrededor del spawn donde solo ops pueden modificar bloques.

### **Spigot**
Fork de Bukkit con optimizaciones. Base para Paper.

### **TPS (Ticks Per Second)**
Velocidad de procesamiento del servidor. Óptimo: 20 TPS = 1 tick cada 50ms.

### **Vanilla**
Servidor oficial de Mojang sin modificaciones.

### **View Distance**
Distancia en chunks que los jugadores pueden ver.

### **Whitelist**
Lista de jugadores permitidos. Servidor en modo privado.

### **World**
El mundo/mapa del servidor. Se guarda en `/data/world/`.

---

## 🐳 Términos de Docker

### **Container (Contenedor)**
Instancia ejecutable de una imagen. Proceso aislado con su propio filesystem.

### **Image (Imagen)**
Template read-only para crear contenedores. Se build desde Dockerfile.

### **Dockerfile**
Archivo de texto con instrucciones para construir una imagen Docker.

### **Volume (Volumen)**
Almacenamiento persistente fuera del contenedor. Datos sobreviven al contenedor.

### **Named Volume**
Volumen con nombre específico gestionado por Docker. Ej: `mc-data`

### **Bind Mount**
Mapeo directo de directorio del host al contenedor. Ej: `./data:/data`

### **Port Mapping**
Mapeo de puerto del host al contenedor. Ej: `25565:25565`

### **Docker Compose**
Herramienta para definir y ejecutar aplicaciones Docker multi-contenedor.

### **docker-compose.yml**
Archivo YAML que define servicios, networks, volumes para Docker Compose.

### **Environment Variables (ENV)**
Variables de configuración pasadas al contenedor.

### **Health Check**
Script que verifica si el contenedor está funcionando correctamente.

### **Restart Policy**
Política de reinicio automático del contenedor.
- `no` - No reiniciar
- `always` - Siempre reiniciar
- `unless-stopped` - Reiniciar excepto si fue detenido manualmente
- `on-failure` - Solo si falla

### **Docker Network**
Red virtual para comunicación entre contenedores.

### **Docker Registry**
Repositorio de imágenes Docker. Docker Hub es el registry público por defecto.

### **Multi-stage Build**
Dockerfile con múltiples FROM. Permite optimizar tamaño final de imagen.

### **Docker API**
API HTTP para controlar Docker programáticamente.

### **Dockerode**
Cliente de Docker API para Node.js.

---

## 🏗️ Términos del Proyecto

### **Template / Base**
Este proyecto. Imagen Docker base para crear múltiples instancias de servidores.

### **Instance (Instancia)**
Un contenedor específico corriendo el servidor Minecraft desde el template.

### **API Externa**
Proyecto separado (no incluido aquí) que gestiona múltiples instancias usando este template.

### **Dynamic Port Assignment**
Asignación automática de puertos disponibles para cada instancia.

### **On-Demand Server**
Servidor creado bajo demanda cuando se necesita, no pre-existente.

### **Auto-Pause**
Feature de itzg que pausa el servidor cuando no hay jugadores, ahorrando recursos.

### **JVM Flags**
Parámetros de Java Virtual Machine para optimizar rendimiento.

### **Resource Limits**
Límites de CPU y RAM asignados al contenedor.

---

## 📊 Términos de Performance

### **CPU Usage**
Porcentaje de CPU usado por el contenedor.

### **RAM Usage**
Memoria RAM usada vs asignada al servidor.

### **Memory Leak**
Problema donde la RAM usada crece constantemente hasta llenar toda la memoria.

### **Lag**
Retraso o lentitud en el juego causado por TPS bajo.

### **Watchdog**
Sistema que detiene el servidor si deja de responder por X tiempo.

### **Chunk Loading**
Proceso de cargar/descargar chunks del mundo según jugadores.

### **Garbage Collection (GC)**
Proceso de Java para liberar memoria no usada. Puede causar lag momentáneo.

---

## 🔒 Términos de Seguridad

### **Online Mode**
Validación de cuentas con servidores de Mojang. Previene cuentas piratas.

### **Offline Mode**
Permite jugadores sin validar cuenta. Menos seguro.

### **Port Exposure**
Puertos expuestos públicamente en el host.

### **Firewall**
Sistema que controla tráfico de red entrante/saliente.

### **DDoS**
Distributed Denial of Service. Ataque de sobrecarga de requests.

### **Griefing**
Destrucción maliciosa del mundo por jugadores.

---

## 📦 Términos de Versiones

### **Latest**
Última versión estable disponible.

### **Snapshot**
Versión de desarrollo/testing de Minecraft. Inestable.

### **Release**
Versión estable oficial.

### **Semantic Versioning**
Sistema de versionado: MAJOR.MINOR.PATCH (ej: 1.21.1)

### **Breaking Change**
Cambio que rompe compatibilidad con versiones anteriores.

---

## 🛠️ Acrónimos

- **ADR** - Architecture Decision Record
- **API** - Application Programming Interface
- **CPU** - Central Processing Unit
- **CRUD** - Create, Read, Update, Delete
- **CLI** - Command Line Interface
- **ENV** - Environment (Variables)
- **GC** - Garbage Collection
- **GB** - Gigabyte
- **HTTP** - Hypertext Transfer Protocol
- **I/O** - Input/Output
- **JVM** - Java Virtual Machine
- **MB** - Megabyte
- **MVP** - Minimum Viable Product
- **RAM** - Random Access Memory
- **REST** - Representational State Transfer
- **RCON** - Remote Console
- **SDK** - Software Development Kit
- **SQL** - Structured Query Language
- **SSL/TLS** - Secure Sockets Layer / Transport Layer Security
- **TPS** - Ticks Per Second
- **UI** - User Interface
- **URL** - Uniform Resource Locator
- **UUID** - Universally Unique Identifier
- **VPS** - Virtual Private Server
- **YAML** - YAML Ain't Markup Language

---

## 📏 Unidades y Medidas

### **Memoria**
- 1 GB = 1024 MB
- 1 MB = 1024 KB
- Notación en ENV: `2G`, `4096M`, `4G`

### **Tiempo**
- TPS: Ticks Per Second (ideal: 20 TPS)
- 1 tick = 50 milisegundos (ms)
- 20 TPS = juego corriendo a velocidad normal

### **Distancia**
- Chunk: 16x16x384 bloques
- View Distance: Medida en chunks (10 chunks = 160 bloques)
- Simulation Distance: Medida en chunks

---

## 🔗 Convenciones de Nomenclatura

### **Contenedores**
- Formato: `mc-server-{id}` o `mc-server-{name}`
- Ejemplos: `mc-server-1`, `mc-server-survival-main`

### **Volúmenes**
- Formato: `mc-server-{id}-data`
- Ejemplos: `mc-server-1-data`, `mc-server-uuid-data`

### **Imágenes**
- Formato: `dockercraft-mc:{tag}`
- Ejemplos: `dockercraft-mc:latest`, `dockercraft-mc:v1.0`

### **Puertos**
- Minecraft: 25565-25665 (rango recomendado)
- RCON: 25575 (interno)

---

**Nota:** Este glosario será actualizado conforme el proyecto evoluciona.

