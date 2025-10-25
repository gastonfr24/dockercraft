# Índice de Documentación - DockerCraft

**Versión:** v1.0.0  
**Última actualización:** 2025-10-25

---

## 📋 Guía de Navegación

Esta documentación está organizada por categorías para facilitar la búsqueda de información.

---

## 🚀 Setup e Instalación

Guías para configurar y personalizar el servidor.

| Documento | Descripción |
|-----------|-------------|
| [ADVANCED_CONFIG.md](setup/ADVANCED_CONFIG.md) | Configuración avanzada del servidor |
| [EXAMPLES.md](setup/EXAMPLES.md) | Ejemplos de configuraciones |
| [MODPACKS.md](setup/MODPACKS.md) | Instalación de modpacks |

**Inicio rápido:** Ver [`ai/08_QUICK_START.md`](ai/08_QUICK_START.md)

---

## 🌐 Deployment

Guías para hacer el servidor accesible públicamente.

| Documento | Descripción |
|-----------|-------------|
| [PUBLIC_DEPLOYMENT_GUIDE.md](deployment/PUBLIC_DEPLOYMENT_GUIDE.md) | Guía completa de deployment público |
| [CLOUDFLARE_TUNNEL.md](deployment/CLOUDFLARE_TUNNEL.md) | Exposición vía Cloudflare Tunnel |
| [NETWORKING.md](deployment/NETWORKING.md) | Configuración de red y puertos |

**Recomendado:** Usa Cloudflare Tunnel para evitar port forwarding.

---

## 🔒 Seguridad

Guías para mantener el servidor seguro.

| Documento | Descripción |
|-----------|-------------|
| [SECURITY.md](security/SECURITY.md) | Guía completa de seguridad |
| [APPROVAL_RULES.md](security/APPROVAL_RULES.md) | Reglas de aprobación de PRs |

**Scripts relacionados:** [`scripts/security/`](../scripts/security/)

---

## 📊 Monitoring y Performance

Guías para monitorear y optimizar el servidor.

| Documento | Descripción |
|-----------|-------------|
| [PERFORMANCE.md](monitoring/PERFORMANCE.md) | Optimización de performance |
| [ALERTS.md](monitoring/ALERTS.md) | Sistema de alertas |
| [METRICS_API.md](monitoring/METRICS_API.md) | API de métricas para frontend |

**Scripts relacionados:** [`scripts/monitoring/`](../scripts/monitoring/)

---

## 🐛 Troubleshooting

Resolución de problemas comunes.

| Documento | Descripción |
|-----------|-------------|
| [TROUBLESHOOTING.md](troubleshooting/TROUBLESHOOTING.md) | Troubleshooting general |
| [PUBLIC_TROUBLESHOOTING.md](troubleshooting/PUBLIC_TROUBLESHOOTING.md) | Problemas de conectividad pública |
| [FAQ.md](troubleshooting/FAQ.md) | Preguntas frecuentes |

**Tip:** Usa `Ctrl+F` para buscar tu problema específico.

---

## 💻 Desarrollo

Guías para contribuir al proyecto.

| Documento | Descripción |
|-----------|-------------|
| [CONTRIBUTING.md](development/CONTRIBUTING.md) | Guía de contribución |
| [DEVELOPMENT.md](development/DEVELOPMENT.md) | Entorno de desarrollo |
| [SPRINT_WORKFLOW.md](development/SPRINT_WORKFLOW.md) | Workflow de sprints |
| [API_INTEGRATION.md](development/API_INTEGRATION.md) | Integración con API externa |

**Workflow Git:** Ver [`.cursor/rules/workflow-strict.md`](../.cursor/rules/workflow-strict.md)

---

## 📅 Sprints y Planificación

Documentación de sprints y roadmap.

| Documento | Descripción |
|-----------|-------------|
| [sprints/README.md](sprints/README.md) | Índice de sprints |
| [sprints/SPRINT_01.md](sprints/SPRINT_01.md) | Sprint 1 - Fundamentos |
| [sprints/SPRINT_02.md](sprints/SPRINT_02.md) | Sprint 2 - Configuración Avanzada |
| [sprints/SPRINT_03.md](sprints/SPRINT_03.md) | Sprint 3 - Optimización y Backup |
| [sprints/SPRINT_04.md](sprints/SPRINT_04.md) | Sprint 4 - Monitoring y Testing |
| [sprints/SPRINT_05.md](sprints/SPRINT_05.md) | Sprint 5 - Final Polish |
| [sprints/SPRINT_06.md](sprints/SPRINT_06.md) | Sprint 6 - Public Deployment |

**Estado actual:** Ver [`ai/04_MEMORY.md`](ai/04_MEMORY.md)

---

## 🤖 Documentación para IA

Contexto y estado del proyecto para asistentes de IA.

| Documento | Descripción |
|-----------|-------------|
| [ai/00_README_AI.md](ai/00_README_AI.md) | Guía para IA |
| [ai/01_CONTEXT.md](ai/01_CONTEXT.md) | Contexto del proyecto |
| [ai/02_ARCHITECTURE.md](ai/02_ARCHITECTURE.md) | Arquitectura técnica |
| [ai/03_DECISIONS.md](ai/03_DECISIONS.md) | Decisiones técnicas |
| [ai/04_MEMORY.md](ai/04_MEMORY.md) | Estado actual del proyecto |
| [ai/05_ROADMAP.md](ai/05_ROADMAP.md) | Roadmap futuro |
| [ai/07_WORKFLOWS.md](ai/07_WORKFLOWS.md) | Workflows de GitHub |
| [ai/08_QUICK_START.md](ai/08_QUICK_START.md) | Inicio rápido |
| [ai/09_CHANGELOG.md](ai/09_CHANGELOG.md) | Changelog detallado |
| [ai/10_GLOSSARY.md](ai/10_GLOSSARY.md) | Glosario de términos |

---

## 📝 Otros Documentos

| Documento | Descripción |
|-----------|-------------|
| [VERSIONS.md](VERSIONS.md) | Versiones soportadas de Minecraft |
| [templates/env.production.template](templates/env.production.template) | Template de configuración producción |

---

## 🔍 Búsqueda Rápida

### Por Tarea

| Tarea | Documentos |
|-------|------------|
| **Instalar el servidor** | [ai/08_QUICK_START.md](ai/08_QUICK_START.md) |
| **Hacer público el servidor** | [deployment/CLOUDFLARE_TUNNEL.md](deployment/CLOUDFLARE_TUNNEL.md), [deployment/PUBLIC_DEPLOYMENT_GUIDE.md](deployment/PUBLIC_DEPLOYMENT_GUIDE.md) |
| **Configurar whitelist** | [sprints/SPRINT_06.md](sprints/SPRINT_06.md) (US-28) |
| **Optimizar performance** | [monitoring/PERFORMANCE.md](monitoring/PERFORMANCE.md) |
| **Configurar alertas** | [monitoring/ALERTS.md](monitoring/ALERTS.md) |
| **Resolver problemas** | [troubleshooting/TROUBLESHOOTING.md](troubleshooting/TROUBLESHOOTING.md), [troubleshooting/FAQ.md](troubleshooting/FAQ.md) |
| **Contribuir al proyecto** | [development/CONTRIBUTING.md](development/CONTRIBUTING.md) |

### Por Rol

| Rol | Documentos Relevantes |
|-----|----------------------|
| **Usuario/Jugador** | [troubleshooting/PUBLIC_TROUBLESHOOTING.md](troubleshooting/PUBLIC_TROUBLESHOOTING.md), [troubleshooting/FAQ.md](troubleshooting/FAQ.md) |
| **Administrador** | [deployment/](deployment/), [security/](security/), [monitoring/](monitoring/) |
| **Desarrollador** | [development/](development/), [ai/](ai/), [sprints/](sprints/) |

---

## 📚 Recursos Externos

### Documentación Oficial

- **Paper:** https://docs.papermc.io/
- **Docker:** https://docs.docker.com/
- **Cloudflare:** https://developers.cloudflare.com/
- **Minecraft Wiki:** https://minecraft.fandom.com/wiki/

### Comunidades

- **r/admincraft** - https://reddit.com/r/admincraft
- **Paper Discord** - https://discord.gg/papermc
- **Minecraft Server Forum** - https://www.minecraftforum.net/forums/servers-java-edition

### Herramientas

- **mcsrvstat.us** - Verificar status del servidor
- **mcstatus.io** - Monitoring de uptime
- **DuckDNS** - DNS dinámico gratuito
- **rclone** - Backup a la nube

---

## 🆘 ¿Necesitas Ayuda?

1. **Busca en FAQ:** [troubleshooting/FAQ.md](troubleshooting/FAQ.md)
2. **Revisa Troubleshooting:** [troubleshooting/TROUBLESHOOTING.md](troubleshooting/TROUBLESHOOTING.md)
3. **Consulta documentación específica** usando este índice
4. **Abre un Issue:** https://github.com/gastonfr24/dockercraft/issues

---

## 🔄 Actualizaciones

Este índice se actualiza con cada cambio en la documentación.

**Última reorganización:** 2025-10-25 (Sprint 6)

---

## 📋 Checklist de Lectura

Para nuevos usuarios/administradores:

- [ ] [ai/08_QUICK_START.md](ai/08_QUICK_START.md) - Inicio rápido
- [ ] [security/SECURITY.md](security/SECURITY.md) - Seguridad básica
- [ ] [deployment/CLOUDFLARE_TUNNEL.md](deployment/CLOUDFLARE_TUNNEL.md) - Exposición pública
- [ ] [troubleshooting/TROUBLESHOOTING.md](troubleshooting/TROUBLESHOOTING.md) - Resolución de problemas

Para desarrolladores:

- [ ] [ai/01_CONTEXT.md](ai/01_CONTEXT.md) - Contexto del proyecto
- [ ] [ai/02_ARCHITECTURE.md](ai/02_ARCHITECTURE.md) - Arquitectura
- [ ] [development/CONTRIBUTING.md](development/CONTRIBUTING.md) - Guía de contribución
- [ ] [development/SPRINT_WORKFLOW.md](development/SPRINT_WORKFLOW.md) - Workflow

---

**¡Bienvenido a DockerCraft! 🎮⚙️**

