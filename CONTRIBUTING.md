# Contributing to DockerCraft

Thank you for your interest in contributing to DockerCraft!

## Table of Contents

- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Code Standards](#code-standards)
- [Issue Reporting](#issue-reporting)

---

## Getting Started

### Prerequisites

- Docker 20.10+
- Docker Compose 2.0+
- Git 2.30+
- Basic knowledge of Docker and Minecraft servers

### Setup

```bash
# 1. Fork the repository on GitHub
# Go to: https://github.com/gastonfr24/dockercraft
# Click "Fork" button

# 2. Clone YOUR fork (replace YOUR_GITHUB_USERNAME with your actual username)
git clone https://github.com/YOUR_GITHUB_USERNAME/dockercraft.git
cd dockercraft

# 3. Configure Git with YOUR credentials
git config user.name "Your GitHub Username"
git config user.email "your.github@email.com"

# 4. Add upstream remote (original repo)
git remote add upstream https://github.com/gastonfr24/dockercraft.git

# 5. Create .env file
cp .env.example .env
# Edit .env: set EULA=TRUE

# 6. Test the setup
docker-compose build
docker-compose up -d
docker-compose logs -f
```

---

## Development Workflow

### Branching Strategy

We use **GitHub Flow**:

1. `main` - Production-ready code
2. Feature branches - Your work

### Creating a Branch

```bash
# Update main
git checkout main
git pull upstream main

# Create feature branch
git checkout -b feature/your-feature-name
```

Branch naming:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation
- `refactor/` - Code refactoring
- `test/` - Tests

### Making Changes

```bash
# Make changes
vim Dockerfile

# Test changes
docker-compose build
docker-compose up -d

# Add changes
git add Dockerfile

# Commit (see Commit Guidelines below)
git commit -m "feat(docker): add new feature"

# Push
git push origin feature/your-feature-name
```

---

## Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/).

### Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types

- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation only
- `style` - Formatting (no code change)
- `refactor` - Code refactoring
- `perf` - Performance improvement
- `test` - Adding tests
- `chore` - Maintenance
- `ci` - CI/CD changes
- `build` - Build system changes

### Examples

```bash
feat(docker): add multi-stage build
fix(scripts): correct health check timeout
docs(readme): improve quick start guide
refactor(dockerfile): optimize layer caching
```

### Rules

- Use lowercase for description
- No period at the end
- Use imperative mood ("add" not "added")
- Max 72 characters for first line
- NO emojis

---

## Pull Request Process

### Before Creating PR

1. **Update your branch**
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Test locally**
   ```bash
   docker-compose build
   docker-compose up -d
   bash scripts/health-check.sh mc-server-1
   ```

3. **Update documentation**
   - Update `docs/ai/09_CHANGELOG.md`
   - Update `docs/ai/04_MEMORY.md`
   - Update `.env.example` if adding new vars
   - Update `README.md` if needed

### Creating PR

1. Push your branch
   ```bash
   git push origin feature/your-feature-name
   ```

2. Go to GitHub and create Pull Request

3. Use the PR template (auto-fills)

4. Fill in:
   - Clear description
   - Type of change
   - Testing done
   - Checklist (mark all applicable)

5. Link related issues

### PR Review

- Be responsive to feedback
- Make requested changes promptly
- Keep discussions professional
- One approval required before merge

### After Merge

```bash
# Delete local branch
git checkout main
git branch -d feature/your-feature-name

# Delete remote branch
git push origin --delete feature/your-feature-name

# Update main
git pull upstream main
```

---

## Code Standards

### Cursor Rules

Read before contributing:

1. `.cursor/rules/core.md` - Core principles
2. `.cursor/rules/git.md` - Git workflow
3. `.cursor/rules/docker.md` - Docker best practices
4. `.cursor/rules/shell.md` - Shell scripting rules

### Docker

- Follow official best practices
- Use multi-stage builds when appropriate
- Minimize layers
- Use `.dockerignore`
- No secrets in images
- Document ENV variables in `.env.example`

### Shell Scripts

- Use `#!/usr/bin/env bash`
- Include `set -euo pipefail`
- Add error handling
- Add logging
- Make scripts executable: `chmod +x script.sh`
- Test with `shellcheck`

### Documentation

- Write in English or Spanish (be consistent)
- Use clear, concise language
- Include code examples
- Update when making changes
- No emojis in code, OK in docs

### No Emojis in Code

- NO emojis in:
  - Code files
  - Commits
  - PRs
  - Issues
  - Configuration files

- Emojis OK in:
  - Documentation files (*.md)
  - Comments explaining concepts

---

## Issue Reporting

### Before Creating Issue

1. Search existing issues
2. Check documentation
3. Try troubleshooting

### Bug Reports

Use the bug report template:

- Clear description
- Steps to reproduce
- Expected vs actual behavior
- Environment details
- Logs
- Configuration

### Feature Requests

Use the feature request template:

- Clear description
- Motivation (why needed)
- Proposed solution
- Alternatives considered
- Priority

---

## Testing

### Local Testing

```bash
# Build image
docker-compose build

# Start server
docker-compose up -d

# Check logs
docker-compose logs -f minecraft

# Health check
bash scripts/health-check.sh mc-server-1

# Connect to server
# Minecraft -> Multiplayer -> localhost:25565

# RCON test
docker exec mc-server-1 rcon-cli list

# Stop server
docker-compose down
```

### Multi-Server Testing

```bash
docker-compose -f docker-compose.multi.yml up -d
docker-compose -f docker-compose.multi.yml logs -f
# Connect to ports: 25565, 25566, 25567
docker-compose -f docker-compose.multi.yml down
```

---

## Questions?

- Read documentation in `docs/ai/`
- Check `README.md`
- Ask in issues or discussions

---

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on the code, not the person
- Help others learn

---

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

**Thank you for contributing to DockerCraft!**

