# 🤖 Documentación para IA - DockerCraft

> **Propósito:** Este directorio contiene documentación estructurada para que sistemas de IA puedan comprender y continuar el desarrollo del proyecto sin pérdida de contexto.

## 📂 Guía de Archivos

### **Archivos de Lectura Obligatoria (en orden)**

1. **`01_CONTEXT.md`** ⭐ - **LEER PRIMERO**
   - Contexto general del proyecto
   - Estado actual y objetivos
   - Resumen ejecutivo

2. **`02_ARCHITECTURE.md`**
   - Arquitectura técnica completa
   - Stack tecnológico
   - Diagramas de sistema

3. **`03_DECISIONS.md`**
   - Decisiones técnicas (ADRs)
   - Por qué se eligió cada tecnología
   - Trade-offs y alternativas consideradas

4. **`04_MEMORY.md`** 🧠
   - Memoria de corto plazo (sesión actual)
   - Memoria de largo plazo (historial del proyecto)
   - Decisiones importantes y cambios

### **Archivos de Referencia**

5. **`05_ROADMAP.md`**
   - Plan de implementación detallado
   - Sprints y fases
   - Próximas características

6. **`07_WORKFLOWS.md`**
   - Flujos de trabajo del desarrollo
   - Procedimientos operativos
   - Guías de troubleshooting

7. **`08_QUICK_START.md`**
   - Guía rápida para comenzar
   - Comandos esenciales
   - Setup del entorno

8. **`09_CHANGELOG.md`**
   - Historial de cambios
   - Versiones y releases
   - Breaking changes

9. **`10_GLOSSARY.md`**
   - Glosario de términos
   - Acrónimos y definiciones
   - Convenciones de nomenclatura

## 🎯 Cómo Usar Esta Documentación (Para IA)

### **Escenario 1: Primera vez en el proyecto**
```
1. Leer 01_CONTEXT.md para entender el proyecto
2. Leer 02_ARCHITECTURE.md para la arquitectura técnica
3. Leer 04_MEMORY.md para decisiones recientes
4. Revisar 05_ROADMAP.md para saber qué sigue
```

### **Escenario 2: Continuar trabajo existente**
```
1. Leer 04_MEMORY.md > Sección "Memoria de Corto Plazo"
2. Revisar 09_CHANGELOG.md para cambios recientes
3. Consultar 05_ROADMAP.md para próximas tareas
```

### **Escenario 3: Implementar nueva funcionalidad**
```
1. Revisar 03_DECISIONS.md para patrones establecidos
2. Consultar 07_WORKFLOWS.md para seguir procesos
3. Leer 08_QUICK_START.md para ejemplos
```

### **Escenario 4: Debugging o troubleshooting**
```
1. Consultar 07_WORKFLOWS.md > Sección "Troubleshooting"
2. Revisar 09_CHANGELOG.md para cambios recientes que puedan afectar
3. Verificar 02_ARCHITECTURE.md para entender componentes
```

## 🔄 Mantenimiento de Esta Documentación

### **Actualizar al finalizar cada sesión:**
- [ ] `04_MEMORY.md` - Agregar decisiones de la sesión actual
- [ ] `09_CHANGELOG.md` - Registrar cambios implementados
- [ ] `05_ROADMAP.md` - Actualizar tareas completadas

### **Actualizar al cambiar arquitectura:**
- [ ] `02_ARCHITECTURE.md` - Reflejar nuevos componentes
- [ ] `03_DECISIONS.md` - Documentar razones del cambio
- [ ] `06_API_SPECS.md` - Actualizar contratos si aplica

### **Actualizar al agregar features:**
- [ ] `05_ROADMAP.md` - Marcar como completado, agregar nuevas
- [ ] `06_API_SPECS.md` - Documentar nuevos endpoints
- [ ] `09_CHANGELOG.md` - Registrar la nueva funcionalidad

## 📊 Estructura de Versionado

```
YYYY-MM-DD - Fecha de última actualización en cada archivo
v0.1.0 - Versión del proyecto (seguir semantic versioning)
```

## 🚨 Información Crítica

### **Nunca Modificar Sin Revisar:**
- Archivos de configuración de Docker
- Variables de entorno de producción
- Configuraciones de red y puertos

### **Siempre Documentar:**
- Decisiones arquitectónicas
- Cambios en APIs públicas
- Breaking changes
- Nuevas dependencias

### **Consultar Antes de:**
- Cambiar stack tecnológico principal
- Modificar schema de base de datos
- Cambiar flujo de autenticación
- Eliminar funcionalidades existentes

## 🔗 Enlaces a Documentación Externa

- [Docker Documentation](https://docs.docker.com/)
- [Minecraft Server Properties](https://minecraft.fandom.com/wiki/Server.properties)
- [itzg/minecraft-server Image](https://github.com/itzg/docker-minecraft-server)
- [Docker Compose](https://docs.docker.com/compose/)

## 📝 Convenciones de Esta Documentación

- **✅ Decisión confirmada**
- **⚠️ Requiere atención**
- **🚧 En desarrollo**
- **📌 Importante**
- **💡 Sugerencia**
- **🔒 No modificar**

---

**Última actualización:** 2025-10-24  
**Versión del proyecto:** v0.1.0-alpha  
**Estado:** Fase de planificación inicial

