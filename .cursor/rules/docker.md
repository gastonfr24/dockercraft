# 🐳 Docker: Reglas Específicas

## Principios Fundamentales

1. **Imagen Base Única**
   - SOLO `itzg/minecraft-server:java21`
   - NO cambiar sin ADR documentado
   - Pinear versión en producción

2. **Variables de Entorno**
   - TODA configuración vía ENV vars
   - Siempre con defaults razonables
   - NO hardcodear valores

3. **Stateless Design**
   - Sin estado interno
   - TODO persistente en volúmenes
   - Contenedor destruible sin pérdida

---

## Dockerfile

### Estructura Obligatoria

```dockerfile
FROM itzg/minecraft-server:java21

# Variables con defaults
ENV VERSION=${VERSION:-1.21.1}
ENV TYPE=${TYPE:-PAPER}
ENV MEMORY=${MEMORY:-4G}
ENV MAX_PLAYERS=${MAX_PLAYERS:-20}

# Health check OBLIGATORIO
HEALTHCHECK --interval=30s \
            --timeout=10s \
            --start-period=60s \
            --retries=3 \
  CMD mc-health || exit 1

VOLUME /data
EXPOSE 25565
```

### ✅ Buenas Prácticas

```dockerfile
# ✅ Comments in English
# Install dependencies for health check
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set default memory allocation
ENV MEMORY=${MEMORY:-4G}

# Configure data volume for persistence
VOLUME /data

# ❌ BAD: Comments in Spanish
# Instalar dependencias para verificación
# Configurar volumen de datos
```

### ❌ Prohibido

```dockerfile
# ❌ Hardcodear valores
ENV VERSION=1.21.1

# ❌ No usar root
USER root

# ❌ No upgrade masivo
RUN apt-get upgrade -y

# ❌ No secretos
ENV API_KEY=abc123

# ❌ No COPY sin .dockerignore
COPY . .
```

---

## docker-compose.yml

### Template Recomendado

```yaml
version: '3.8'

services:
  minecraft:
    build: .
    container_name: mc-server-1
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      VERSION: ${VERSION:-1.21.1}
      TYPE: ${TYPE:-PAPER}
      MEMORY: ${MEMORY:-4G}
      MAX_PLAYERS: ${MAX_PLAYERS:-20}
    volumes:
      - mc-data:/data
    networks:
      - minecraft-net
    restart: unless-stopped
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G
        reservations:
          memory: 2G

volumes:
  mc-data:
    name: mc-server-1-data

networks:
  minecraft-net:
    driver: bridge
```

### ✅ Obligatorio

- Version especificada (`3.8`)
- Named volumes SIEMPRE
- Resource limits configurados
- Restart policy: `unless-stopped`
- Environment con defaults
- Networks definidas

### ❌ Prohibido

```yaml
# ❌ Volumen anónimo
volumes:
  - /data

# ❌ Secrets hardcodeados
environment:
  - DB_PASSWORD=secret123

# ❌ Mount root del host
volumes:
  - /:/host

# ❌ Privileged mode sin razón
privileged: true

# ❌ Host network
network_mode: host

# ❌ Restart always
restart: always
```

---

## Testing Docker

### Verificación de Dockerfile

```bash
# 1. Lint
hadolint Dockerfile

# 2. Build
docker build -t dockercraft-mc:test .

# 3. Verificar que arranca
docker run --rm -d --name test-mc \
  -e EULA=TRUE \
  dockercraft-mc:test

# 4. Esperar inicio
sleep 30

# 5. Verificar health
docker inspect --format='{{.State.Health.Status}}' test-mc

# 6. Verificar logs
docker logs test-mc | grep "Done"

# 7. Cleanup
docker stop test-mc
docker rmi dockercraft-mc:test
```

### Verificación de docker-compose

```bash
# 1. Validar sintaxis
docker-compose config

# 2. Verificar que arranca
docker-compose up -d

# 3. Verificar estado
docker-compose ps

# 4. Verificar logs
docker-compose logs

# 5. Verificar health
docker inspect --format='{{.State.Health.Status}}' mc-server-1

# 6. Cleanup
docker-compose down
```

---

## Security Scanning

```bash
# Trivy (vulnerabilidades)
trivy image dockercraft-mc:latest

# Docker scan
docker scan dockercraft-mc:latest

# Hadolint (best practices)
hadolint Dockerfile

# Git secrets
git-secrets --scan
```

---

## Optimizaciones

### Layer Caching

```dockerfile
# ✅ BUENO: Copiar requirements primero
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .

# ❌ MALO: Copiar todo y luego instalar
COPY . .
RUN pip install -r requirements.txt
```

### Multi-Stage (si aplica futuro)

```dockerfile
# Stage 1: Build
FROM base AS builder
RUN make build

# Stage 2: Runtime
FROM base AS runtime
COPY --from=builder /app/binary /usr/local/bin/
```

### Tamaño de Imagen

```bash
# Ver tamaño
docker images dockercraft-mc

# Optimizar
- Usar imagen base slim
- Limpiar caches en mismo layer
- Combinar RUN commands
- Usar .dockerignore
```

---

## .dockerignore

```
# Git
.git
.gitignore
.gitattributes

# Documentation
*.md
docs/
LICENSE

# IDE
.vscode/
.idea/
*.swp
*.swo

# Cursor
.cursor/

# Logs
*.log
logs/

# Test files
tests/
*.test.sh

# Build artifacts
*.tar.gz
*.zip

# OS
.DS_Store
Thumbs.db

# Env files (usar solo .env.example)
.env
.env.local
```

---

## Troubleshooting Docker

### Contenedor no inicia

```bash
# Ver logs
docker logs <container>

# Verificar health
docker inspect --format='{{.State.Health}}' <container>

# Verificar EULA
docker inspect <container> | grep EULA

# Verificar recursos
docker stats <container>
```

### Puerto en uso

```bash
# Ver qué usa el puerto
sudo lsof -i :25565
# o
sudo netstat -tulpn | grep 25565

# Cambiar puerto
docker run -p 25566:25565 ...
```

### Volumen no persiste

```bash
# Verificar volúmenes
docker volume ls

# Inspeccionar volumen
docker volume inspect mc-data

# Verificar mounts
docker inspect --format='{{.Mounts}}' <container>
```

---

## Comandos Útiles

```bash
# Ver contenedores
docker ps -a

# Ver imágenes
docker images

# Ver volúmenes
docker volume ls

# Limpiar sistema
docker system prune -a --volumes

# Stats en tiempo real
docker stats

# Logs con follow
docker logs -f <container>

# Ejecutar comando en contenedor
docker exec <container> <command>

# Shell interactivo
docker exec -it <container> bash

# Copiar archivos
docker cp <container>:/path /local/path

# Inspeccionar
docker inspect <container>
```

---

## Referencias

- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Compose File Reference](https://docs.docker.com/compose/compose-file/)
- [itzg/minecraft-server](https://github.com/itzg/docker-minecraft-server)
- [Hadolint](https://github.com/hadolint/hadolint)

---

**Última actualización:** 2025-10-24

