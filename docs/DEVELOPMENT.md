# 🛠️ DockerCraft - Development Guide

Complete guide for setting up and developing DockerCraft locally.

---

## 🚀 Quick Start

```bash
# 1. Clone repository
git clone https://github.com/gastonfr24/dockercraft.git
cd dockercraft

# 2. Run setup script
./scripts/setup.sh --env dev

# 3. Copy development environment
cp .env.dev.example .env.dev
source .env.dev

# 4. Start development server
docker compose -f docker-compose.dev.yml up -d

# 5. Watch logs
docker logs -f dockercraft-dev
```

---

## 📦 Prerequisites

- **Docker** 20.10+
- **Docker Compose** v2.0+
- **Git** 2.30+
- **Bash** 4.0+

### Optional Tools

- **pre-commit**: Code quality
- **jq**: JSON processing
- **shellcheck**: Shell script linting
- **hadolint**: Dockerfile linting

---

## 🔧 Development Setup

### Install Development Tools

```bash
# Pre-commit hooks
pip install pre-commit
pre-commit install

# Linting tools
# Ubuntu/Debian
sudo apt install shellcheck jq

# macOS
brew install shellcheck jq hadolint
```

### Configure IDE

#### VS Code

Install extensions:
- Docker
- YAML
- ShellCheck
- EditorConfig

Settings (`.vscode/settings.json`):
```json
{
  "editor.formatOnSave": true,
  "files.eol": "\n",
  "files.insertFinalNewline": true
}
```

---

## 🐳 Development Containers

### Start Development Server

```bash
# Start in foreground
docker compose -f docker-compose.dev.yml up

# Start in background
docker compose -f docker-compose.dev.yml up -d

# View logs
docker compose -f docker-compose.dev.yml logs -f
```

### Hot Reload

Changes to these directories hot-reload:
- `plugins/`: Server plugins
- `mods/`: Server mods
- `config/`: Configuration files

```bash
# Add a plugin
cp MyPlugin.jar plugins/

# Reload plugins (in RCON or console)
/reload confirm
```

---

## 🧪 Testing

### Run All Tests

```bash
# Integration tests
./tests/integration/test-docker-compose.sh

# Specific compose file
./tests/integration/test-docker-compose.sh -f docker-compose.dev.yml

# Quick mode (faster)
./tests/integration/test-docker-compose.sh --quick
```

### Manual Testing

```bash
# Connect with Minecraft client
# Server: localhost:25565
# Offline mode enabled for development

# RCON access
docker exec -it dockercraft-dev rcon-cli
> list
> tps
```

---

## 📝 Code Standards

### Shell Scripts

```bash
#!/bin/bash
set -eo pipefail

# Use functions
function main() {
    echo "Hello World"
}

# Proper error handling
if ! command -v docker &> /dev/null; then
    echo "Docker not found" >&2
    exit 1
fi

main "$@"
```

### Linting

```bash
# Shell scripts
shellcheck scripts/*.sh

# Dockerfile
hadolint Dockerfile

# YAML
yamllint .

# Run all pre-commit hooks
pre-commit run --all-files
```

---

## 🔍 Debugging

### Container Debugging

```bash
# Shell access
docker exec -it dockercraft-dev bash

# View logs
docker logs dockercraft-dev --tail 100 -f

# Inspect container
docker inspect dockercraft-dev

# Check resource usage
docker stats dockercraft-dev
```

### Java Debugging

Connect IDE debugger to port 5005:

**IntelliJ IDEA:**
1. Run → Edit Configurations
2. Add → Remote JVM Debug
3. Host: localhost, Port: 5005
4. Start debugging

**VS Code:**
`.vscode/launch.json`:
```json
{
  "type": "java",
  "request": "attach",
  "name": "Docker Debug",
  "hostName": "localhost",
  "port": 5005
}
```

---

## 🌐 Local Development Workflow

### 1. Create Feature Branch

```bash
git checkout -b task/usXX-feature-name
```

### 2. Make Changes

Edit files, then test:

```bash
# Restart container
docker compose -f docker-compose.dev.yml restart

# Or rebuild if Dockerfile changed
docker compose -f docker-compose.dev.yml up -d --build
```

### 3. Run Tests

```bash
./tests/integration/test-docker-compose.sh -f docker-compose.dev.yml
```

### 4. Commit Changes

```bash
# Pre-commit hooks run automatically
git add .
git commit -m "feat(scope): description"
```

### 5. Push and Create PR

```bash
git push origin task/usXX-feature-name
gh pr create --base dev
```

---

## 📊 Performance Profiling

### Spark Profiler

```bash
# Install Spark plugin
docker exec dockercraft-dev curl -o plugins/spark.jar \
  https://ci.lucko.me/job/spark/lastSuccessfulBuild/artifact/spark-bukkit/build/libs/spark-bukkit.jar

# Restart server
docker restart dockercraft-dev

# Start profiling
/spark profiler start

# View results
/spark profiler info
```

### Timings Report

```bash
# Enable timings
/timings on

# Generate report after 5-10 minutes
/timings paste
```

---

## 🐛 Common Issues

### Port Already in Use

```bash
# Find process using port
lsof -i :25565

# Or on Windows
netstat -ano | findstr :25565

# Stop conflicting container
docker stop $(docker ps -q -f "publish=25565")
```

### Container Won't Start

```bash
# Check logs
docker logs dockercraft-dev

# Remove and recreate
docker compose -f docker-compose.dev.yml down -v
docker compose -f docker-compose.dev.yml up -d
```

### Permission Issues

```bash
# Fix volume permissions
docker exec -u root dockercraft-dev chown -R minecraft:minecraft /data

# Or recreate volume
docker volume rm dockercraft_minecraft_data_dev
docker compose -f docker-compose.dev.yml up -d
```

---

## 🔄 Development Cycle

```
1. Make changes
2. Test locally
3. Run linters
4. Commit (pre-commit hooks run)
5. Push
6. Create PR
7. CI/CD runs tests
8. Review
9. Merge
```

---

## 📚 Related Documentation

- [Contributing Guide](CONTRIBUTING.md)
- [Testing Guide](TESTING.md)
- [Security Guide](SECURITY.md)
- [Performance Guide](PERFORMANCE.md)

---

**Happy Coding! 🚀**

