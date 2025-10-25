# 🔧 Troubleshooting - Guía para Jugadores

> Soluciones a problemas comunes al conectarse al servidor

**Última actualización:** 2025-10-25

---

## 🎮 Información del Servidor

**Dirección:** `[INSERTAR_AQUI]`  
**Versión:** 1.21.1 (Paper)  
**Tipo:** Survival, Whitelist

---

## ❌ No puedo conectarme

### Error: "Connection Refused"

**Causa:** El servidor no está accesible.

**Soluciones:**

1. **Verificar dirección del servidor**
   - ✅ Asegúrate de usar la dirección correcta
   - ✅ Incluir el puerto si no es 25565
   - Ejemplo: `servidor.com:25565`

2. **Verificar que el servidor esté online**
   - Contactar al administrador
   - Verificar en: https://mcsrvstat.us/

3. **Verificar tu firewall**
   ```
   Windows: Firewall → Permitir app → Minecraft
   Mac: System Preferences → Security → Firewall → Options
   ```

4. **Reiniciar Minecraft**
   - Cerrar completamente Minecraft
   - Volver a abrir

### Error: "io.netty.channel.AbstractChannel$AnnotatedConnectException"

**Causa:** Problema de red o firewall bloqueando la conexión.

**Soluciones:**

1. **Desactivar VPN temporalmente**
   - Las VPNs pueden causar problemas de conexión

2. **Verificar antivirus/firewall**
   - Agregar excepción para Minecraft
   - Temporalmente desactivar para probar

3. **Probar desde otra red**
   - Usar datos móviles
   - Conectar desde otra ubicación

### Error: "Failed to verify username"

**Causa:** Problema con autenticación de Mojang/Microsoft.

**Soluciones:**

1. **Reiniciar sesión**
   - Salir de Minecraft
   - Volver a iniciar sesión

2. **Verificar cuenta**
   - Asegúrate de tener cuenta original de Minecraft
   - Versión pirata NO funcionará (ONLINE_MODE=true)

---

## 🚫 No estoy en la Whitelist

### Error: "You are not whitelisted on this server"

**Causa:** Tu usuario no está en la whitelist del servidor.

**Solución:**

1. **Solicitar acceso**
   - Contactar al administrador
   - Proporcionar tu **username exacto** de Minecraft
   - Esperar aprobación

2. **Verificar username**
   - Asegúrate de usar el nombre correcto
   - Case-sensitive (mayúsculas/minúsculas importan)

---

## 🐌 Lag o Alta Latencia

### Síntomas: Bloques que reaparecen, movimiento lento, retraso al romper bloques

**Causas Comunes:**

1. **Conexión a internet lenta**
   
   **Verificar:**
   ```
   Hacer ping al servidor:
   ping servidor.com
   ```
   
   **Latencia aceptable:**
   - < 50ms: Excelente
   - 50-100ms: Bueno
   - 100-200ms: Jugable
   - > 200ms: Lag notorio

2. **Servidor con muchos jugadores**
   - Esperar a que haya menos gente online
   - El servidor puede estar sobrecargado

3. **Chunks cargando lentamente**
   - Reducir `Render Distance` en:
     - Opciones → Video Settings → Render Distance
     - Recomendado: 8-12 chunks

4. **Mods/Shaders consumiendo recursos**
   - Desactivar temporalmente
   - Verificar si mejora

**Soluciones:**

- ✅ Cerrar aplicaciones que usen internet (torrent, streaming)
- ✅ Conectar por cable ethernet en vez de WiFi
- ✅ Reiniciar tu router
- ✅ Reducir configuraciones gráficas en Minecraft

---

## 📦 Error: "Outdated Server" o "Outdated Client"

### Error: "Server is running an older version"

**Causa:** Tu cliente de Minecraft es más nuevo que el servidor.

**Solución:**

1. **Cambiar versión de Minecraft**
   - Launcher → Installations → New Installation
   - Version: **1.21.1** (o la versión del servidor)
   - Launch

### Error: "Client is outdated"

**Causa:** Tu cliente es más viejo que el servidor.

**Solución:**

1. **Actualizar Minecraft**
   - Launcher → Installations
   - Seleccionar versión correcta

---

## 🔌 Desconexiones Frecuentes

### Error: "Disconnected" o "Timed out"

**Causas:**

1. **Conexión inestable**
   - Verificar tu internet
   - Probar: speedtest.net

2. **Auto-pause del servidor**
   - El servidor puede pausarse cuando no hay jugadores
   - Esperar 5-10 segundos y reconectar

3. **Reinicio/mantenimiento del servidor**
   - Consultar horarios de mantenimiento

**Soluciones:**

- ✅ Usar conexión por cable
- ✅ Cerrar otras apps que usen internet
- ✅ Reiniciar tu router

---

## 🎒 Problemas con Inventario/Items

### "Perdí mis items al desconectarme"

**Qué hacer:**

1. **No entrar en pánico**
   - Los items pueden estar en el suelo donde moriste
   - El servidor guarda todo

2. **Reconectar**
   - Cerrar y abrir Minecraft
   - Volver a entrar al servidor

3. **Si siguen faltando:**
   - Contactar al administrador inmediatamente
   - Proporcionar:
     - Tu username
     - Hora aproximada
     - Qué items faltaban
     - Qué estabas haciendo

---

## 🏠 No puedo romper/colocar bloques

### Error: "Can't break blocks"

**Causas:**

1. **Spawn Protection**
   - Estás muy cerca del spawn
   - Aléjate ~20 bloques

2. **Protección de región**
   - Puede haber plugins de protección
   - Pregunta al admin por permisos

3. **Modo Espectador/Aventura**
   - Verificar tu gamemode
   - Pedir al admin que te cambie a Survival

---

## 🗣️ Chat no funciona

### No puedo enviar mensajes

**Verificar:**

1. **Tecla correcta**
   - Por defecto: `T` para abrir chat
   - O `/` para comandos

2. **Baneado del chat**
   - Contactar al admin si crees que es error

3. **Cliente con problemas**
   - Reiniciar Minecraft

---

## 🎨 Texturas/Recursos no cargan

### Mundo se ve extraño

**Soluciones:**

1. **Recargar recursos**
   - F3 + T (recargar texturas)
   - F3 + A (recargar chunks)

2. **Resource Packs**
   - Opciones → Resource Packs
   - Desactivar/reactivar

3. **Reinstalar Minecraft** (último recurso)

---

## ⚡ Crash al Conectar

### Minecraft se cierra al entrar

**Soluciones:**

1. **Actualizar Java**
   - Descargar: https://www.java.com/

2. **Asignar más RAM a Minecraft**
   - Launcher → Installations → Edit
   - More Options → JVM Arguments
   - Cambiar `-Xmx2G` a `-Xmx4G` (si tienes 8GB+ RAM)

3. **Verificar mods**
   - Si usas mods, pueden ser incompatibles
   - Probar sin mods

4. **Logs**
   - Launcher → Latest Log
   - Copiar y enviar al admin

---

## 📞 Obtener Ayuda

### Antes de reportar un problema:

1. ✅ Verificar que leíste esta guía
2. ✅ Intentar las soluciones sugeridas
3. ✅ Reiniciar Minecraft y tu PC
4. ✅ Verificar tu conexión a internet

### Información útil al reportar:

- 🔹 Tu username de Minecraft
- 🔹 Versión de Minecraft que usas
- 🔹 Descripción del problema
- 🔹 Cuándo ocurrió
- 🔹 Pasos para reproducir
- 🔹 Screenshots si es posible
- 🔹 Logs de Minecraft (si hay crash)

### Contacto:

- **Discord:** [INSERTAR_LINK]
- **Email:** [INSERTAR_EMAIL]
- **GitHub Issues:** https://github.com/gastonfr24/dockercraft/issues

---

## 💡 Tips para Mejor Experiencia

### Performance

- ✅ Reducir Render Distance (8-10 chunks)
- ✅ Desactivar Smooth Lighting
- ✅ Graphics: Fast
- ✅ Clouds: Off
- ✅ Particles: Minimal
- ✅ Usar Optifine (mejora FPS)

### Conectividad

- ✅ Usar ethernet en vez de WiFi
- ✅ Cerrar apps en segundo plano
- ✅ No descargar/streamear mientras juegas
- ✅ Ping bajo = mejor experiencia

### General

- ✅ Leer las reglas del servidor
- ✅ Ser respetuoso con otros jugadores
- ✅ Reportar bugs al admin
- ✅ Hacer backups de tus construcciones importantes

---

## 🔍 Verificar Status del Servidor

### Herramientas Online

- **https://mcsrvstat.us/** - Enter server address
- **https://mcstatus.io/** - Check server status

### Desde Terminal

```bash
# Linux/Mac
ping servidor.com

# Check si puerto está abierto
nc -zv servidor.com 25565
```

---

## ❓ FAQ

### ¿Cuál es la dirección del servidor?
Consultar con el administrador o en el canal de Discord.

### ¿Qué versión de Minecraft necesito?
**1.21.1** (Java Edition)

### ¿Funciona con Bedrock Edition (Windows 10, consolas, móvil)?
No, solo Java Edition.

### ¿Puedo usar mods?
Depende del servidor. Consultar al admin.

### ¿Cuántos jugadores hay online?
Ver con herramientas como mcsrvstat.us

### ¿Cuándo hay mantenimiento?
[INSERTAR_HORARIO] - Generalmente se anuncia con anticipación

### ¿Cómo solicito acceso a la whitelist?
[INSERTAR_PROCEDIMIENTO]

---

## 🎮 ¡Disfruta el juego!

Si después de revisar esta guía sigues teniendo problemas, no dudes en contactar al administrador.

**¡Nos vemos en el servidor!** ⛏️

---

**Última actualización:** 2025-10-25  
**Versión:** 1.0

