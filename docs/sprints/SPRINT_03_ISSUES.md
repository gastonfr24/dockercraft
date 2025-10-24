# Sprint 3 - GitHub Issues Creation Guide

**⚠️ IMPORTANTE:** Crear TODOS estos Issues en GitHub ANTES de empezar a codear.

---

## 📝 Proceso de Creación

### Paso 1: Ir a GitHub Issues
```
https://github.com/gastonfr24/dockercraft/issues/new
```

### Paso 2: Crear UN Issue por cada User Story

Usa el template de **Feature Request** para cada uno.

---

## 🎫 Issue #1: Multi-Version Support

**Template:** Feature Request

```markdown
**Title:** [US-14] Multi-Version Minecraft Support

**Is your feature request related to a problem?**
Currently, the Docker template only supports the latest Minecraft version by default. Users need the ability to specify different versions (1.20.1, 1.19.4, etc.) and server types (PAPER, SPIGOT, FORGE, FABRIC) to meet different player requirements.

**Describe the solution you'd like**
Add comprehensive support for multiple Minecraft versions and server types through environment variables.

**User Story**
Como administrador
Quiero poder elegir diferentes versiones de Minecraft
Para soportar diferentes necesidades de jugadores

**Acceptance Criteria**
- [ ] Variable VERSION soporta versiones específicas (1.20.1, 1.19.4, etc)
- [ ] Variable TYPE soporta PAPER, SPIGOT, FORGE, FABRIC
- [ ] Documentación de versiones compatibles
- [ ] Ejemplos en docker-compose para diferentes versiones
- [ ] Testing de al menos 3 versiones diferentes

**Tasks**
- [ ] Actualizar .env.example con opciones de VERSION
- [ ] Documentar tipos de servidor compatibles
- [ ] Crear docker-compose.versions.yml con ejemplos
- [ ] Añadir testing para diferentes versiones
- [ ] Actualizar README con guía de versiones

**Story Points:** 5
**Sprint:** Sprint 3
**Priority:** High

**Additional context**
Esto permitirá a los usuarios del template crear servidores con la versión exacta que necesitan, facilitando la compatibilidad con mods y plugins específicos.
```

**Labels:** `enhancement`, `sprint-3`, `priority-high`
**Assignee:** gastonfr24

---

## 🎫 Issue #2: Modpack Support

**Template:** Feature Request

```markdown
**Title:** [US-15] Automated Modpack Installation Support

**Is your feature request related to a problem?**
Installing modpacks manually is complex and error-prone. Users need an automated way to install modpacks from CurseForge and FTB.

**Describe the solution you'd like**
Add support for automatic modpack installation through environment variables, leveraging itzg/minecraft-server's built-in modpack support.

**User Story**
Como administrador
Quiero poder instalar modpacks automáticamente
Para facilitar la configuración de servidores modded

**Acceptance Criteria**
- [ ] Soporte para CurseForge modpacks
- [ ] Soporte para FTB modpacks
- [ ] Variable MODPACK_URL o CURSEFORGE_FILE
- [ ] Documentación de instalación de modpacks
- [ ] Ejemplo funcional con modpack popular

**Tasks**
- [ ] Investigar itzg/minecraft-server modpack support
- [ ] Añadir variables para modpacks en .env.example
- [ ] Crear docker-compose.modded.yml
- [ ] Documentar proceso de instalación
- [ ] Testing con modpack popular (ej: All The Mods 9)
- [ ] Añadir troubleshooting para mods

**Story Points:** 8
**Sprint:** Sprint 3
**Priority:** High

**Additional context**
Popular modpacks: All The Mods 9, FTB StoneBlock 3, RLCraft, etc.
```

**Labels:** `enhancement`, `sprint-3`, `priority-high`
**Assignee:** gastonfr24

---

## 🎫 Issue #3: Advanced Networking

**Template:** Feature Request

```markdown
**Title:** [US-16] Multi-Server Networking & Proxy Preparation

**Is your feature request related to a problem?**
For a future API to manage multiple servers, proper networking setup is needed, including proxy support for connecting multiple servers together.

**Describe the solution you'd like**
Configure Docker networking to support multi-server setups with BungeeCord/Velocity proxy, preparing the template for external API integration.

**User Story**
Como desarrollador de API
Quiero que los servidores puedan comunicarse entre sí
Para preparar integración con proxy (BungeeCord/Velocity)

**Acceptance Criteria**
- [ ] Docker network configurado correctamente
- [ ] Variables para configurar proxy mode
- [ ] Documentación de networking
- [ ] Ejemplo con 3 servidores + proxy
- [ ] Guía de integración para API externa

**Tasks**
- [ ] Crear docker-compose.proxy.yml con Velocity/BungeeCord
- [ ] Configurar variables para proxy mode
- [ ] Documentar networking entre servidores
- [ ] Crear guía para desarrolladores de API
- [ ] Testing de conectividad entre servidores

**Story Points:** 5
**Sprint:** Sprint 3
**Priority:** Medium

**Additional context**
This prepares the Docker template for integration with an external API (separate project) that will manage server lifecycle.
```

**Labels:** `enhancement`, `sprint-3`, `priority-medium`
**Assignee:** gastonfr24

---

## 🎫 Issue #4: Advanced Environment Variables

**Template:** Feature Request

```markdown
**Title:** [US-17] Advanced Environment Variables Configuration

**Is your feature request related to a problem?**
Users need more granular control over server configuration through environment variables (plugins, mods, whitelist, ops).

**Describe the solution you'd like**
Expand environment variable support to cover common configuration needs like automatic plugin installation, whitelist management, and operator assignment.

**User Story**
Como administrador
Quiero más control sobre la configuración del servidor
Para optimizar para casos de uso específicos

**Acceptance Criteria**
- [ ] Nuevas variables documentadas en .env.example
- [ ] Soporte para PLUGINS automáticos
- [ ] Soporte para MODS automáticos
- [ ] Configuración de whitelist via variable
- [ ] OPS automáticos via variable

**Tasks**
- [ ] Añadir variables PLUGINS, MODS, WHITELIST, OPS
- [ ] Documentar cada variable en .env.example
- [ ] Crear ejemplos de uso
- [ ] Testing de configuración automática
- [ ] Actualizar README

**Story Points:** 3
**Sprint:** Sprint 3
**Priority:** Medium

**Additional context**
Examples:
- PLUGINS="EssentialsX,Vault,LuckPerms"
- OPS="player1,player2"
- WHITELIST="player1,player2,player3"
```

**Labels:** `enhancement`, `sprint-3`, `priority-medium`
**Assignee:** gastonfr24

---

## 🎫 Issue #5: Advanced Documentation

**Template:** Feature Request

```markdown
**Title:** [US-18] Complete Advanced Documentation

**Is your feature request related to a problem?**
New users struggle to understand all capabilities and configuration options. Documentation needs to be comprehensive and beginner-friendly.

**Describe the solution you'd like**
Create comprehensive documentation covering all use cases, examples, FAQ, and integration guides.

**User Story**
Como nuevo usuario
Quiero documentación completa y clara
Para poder usar el proyecto sin problemas

**Acceptance Criteria**
- [ ] README.md completo con todos los casos de uso
- [ ] Guía de troubleshooting expandida
- [ ] Ejemplos de configuraciones comunes
- [ ] FAQ section
- [ ] Video tutorial (opcional)

**Tasks**
- [ ] Expandir README.md con casos de uso reales
- [ ] Crear docs/EXAMPLES.md con configuraciones comunes
- [ ] Crear docs/FAQ.md
- [ ] Mejorar TROUBLESHOOTING.md
- [ ] Añadir badges al README
- [ ] Crear docs/INTEGRATION.md para API developers

**Story Points:** 5
**Sprint:** Sprint 3
**Priority:** Low

**Additional context**
Good documentation is critical for project adoption. Focus on clarity and real-world examples.
```

**Labels:** `documentation`, `sprint-3`, `priority-low`
**Assignee:** gastonfr24

---

## ✅ Post-Creation Checklist

Después de crear TODOS los Issues:

1. **Anotar números de Issue**
   - Issue #1: US-14 Multi-Version → #___
   - Issue #2: US-15 Modpacks → #___
   - Issue #3: US-16 Networking → #___
   - Issue #4: US-17 Env Vars → #___
   - Issue #5: US-18 Docs → #___

2. **Actualizar SPRINT_03.md**
   ```markdown
   #### US-14: Soporte Multi-Version de Minecraft
   **Issue:** #___ 👈 AÑADIR AQUÍ
   ```

3. **Commit cambios**
   ```bash
   git add docs/sprints/SPRINT_03.md
   git commit -m "docs(sprint3): add Issue numbers to sprint doc"
   git push origin dev
   ```

4. **SOLO ENTONCES empezar a codear**

---

## 📞 Comandos de Referencia

Si instalas GitHub CLI en el futuro, podrías automatizar:

```bash
# Instalar GitHub CLI
# Windows: winget install GitHub.cli
# O descarga desde: https://cli.github.com/

# Login
gh auth login

# Crear Issue desde template
gh issue create --title "[US-14] Multi-Version Support" --body "..." --label "enhancement,sprint-3,priority-high"
```

---

**Última actualización:** 2025-10-24

