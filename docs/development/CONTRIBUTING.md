# 🤝 Contributing to DockerCraft

Thank you for your interest in contributing to DockerCraft! This document provides guidelines for contributing.

---

## 📋 Code of Conduct

Be respectful, inclusive, and professional. We follow the [Contributor Covenant](https://www.contributor-covenant.org/).

---

## 🚀 Getting Started

### 1. Fork and Clone

```bash
# Fork on GitHub, then clone
git clone https://github.com/YOUR_USERNAME/dockercraft.git
cd dockercraft
```

### 2. Setup Development Environment

```bash
# Run automated setup
./scripts/setup.sh --env dev

# Install pre-commit hooks
pip install pre-commit
pre-commit install
```

### 3. Create Branch

```bash
# Follow naming convention
git checkout -b task/usXX-feature-name

# Examples:
# - task/us19-monitoring-script
# - fix/docker-compose-syntax
# - docs/update-readme
```

---

## 🔧 Development Workflow

### 1. Make Changes

```bash
# Edit files
vim scripts/monitor.sh

# Test locally
./scripts/test-server.sh
```

### 2. Run Pre-commit Hooks

```bash
# Manual run
pre-commit run --all-files

# Hooks run automatically on commit
git commit -m "feat: add monitoring script"
```

### 3. Push and Create PR

```bash
# Push branch
git push origin task/usXX-feature-name

# Create PR via GitHub CLI
gh pr create --base dev --head task/usXX-feature-name
```

---

## 📝 Commit Message Guidelines

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `test`: Tests
- `refactor`: Code refactoring
- `style`: Formatting
- `chore`: Maintenance
- `ci`: CI/CD changes

### Examples

```bash
feat(monitoring): add Discord webhook integration

fix(docker): correct port mapping in compose file

docs(readme): update installation instructions

test(integration): add docker-compose tests
```

---

## 🧪 Testing

### Run Tests

```bash
# All tests
./tests/integration/test-docker-compose.sh

# Specific compose file
./tests/integration/test-docker-compose.sh -f docker-compose.yml

# Quick mode
./tests/integration/test-docker-compose.sh --quick
```

### Linting

```bash
# Dockerfile
hadolint Dockerfile

# Shell scripts
shellcheck scripts/*.sh

# YAML
yamllint .

# Markdown
markdownlint docs/
```

---

## 📦 Pull Request Process

### 1. PR Checklist

- [ ] Code follows project style
- [ ] Tests pass locally
- [ ] Documentation updated
- [ ] Commit messages follow convention
- [ ] PR description is complete
- [ ] Issue is linked with `Closes #XX`

### 2. PR Template

PRs should include:

```markdown
Closes #XX

## Description
Brief description of changes

## Changes
- Change 1
- Change 2

## Testing
How to test these changes

## Checklist
- [x] Tests pass
- [x] Documentation updated
- [x] Issue linked
```

### 3. Review Process

- PRs require 1 approval for `dev`
- PRs require owner approval for `main`
- Address review comments
- Keep PR focused and small

---

## 🏗️ Project Structure

```
dockercraft/
├── .github/           # GitHub workflows and templates
├── docs/              # Documentation
├── scripts/           # Utility scripts
├── tests/             # Test suites
├── docker-compose*.yml # Compose configurations
├── Dockerfile         # Container definition
└── README.md          # Project overview
```

---

## 📚 Documentation

### Writing Guidelines

- Use clear, concise language
- Include code examples
- Add troubleshooting sections
- Link to related docs

### Documentation Structure

```markdown
# Title

Brief intro

## Section 1
Content

## Section 2
Content

## Examples

## Troubleshooting

## Related Resources
```

---

## 🐛 Reporting Issues

### Bug Reports

Include:
- Description of the bug
- Steps to reproduce
- Expected vs actual behavior
- Environment details
- Relevant logs

### Feature Requests

Include:
- Use case description
- Proposed solution
- Alternative solutions considered
- Additional context

---

## 🔐 Security

Found a security vulnerability?

**DO NOT** open a public issue.

Email: security@example.com

---

## 💡 Development Tips

### Debugging

```bash
# Container logs
docker logs minecraft-server -f

# Shell access
docker exec -it minecraft-server bash

# Monitoring
./scripts/monitor.sh -v
```

### Testing Compose Files

```bash
# Validate syntax
docker compose -f docker-compose.yml config

# Test startup
docker compose up -d
docker compose ps
docker compose logs

# Cleanup
docker compose down -v
```

---

## 🏷️ Labeling System

- `bug`: Something isn't working
- `enhancement`: New feature or request
- `documentation`: Documentation improvements
- `good first issue`: Good for newcomers
- `help wanted`: Extra attention needed
- `priority-high`: High priority
- `sprint-X`: Part of Sprint X

---

## 📈 Performance Guidelines

- Keep scripts efficient
- Use caching where possible
- Minimize Docker layers
- Test with production-like data

---

## 🎨 Style Guidelines

### Shell Scripts

```bash
#!/bin/bash
set -eo pipefail

# Use functions
function main() {
    echo "Hello"
}

# Call main
main "$@"
```

### Docker Compose

```yaml
# Use version 3.8+
version: '3.8'

services:
  minecraft:
    # Alphabetically sorted keys
    image: itzg/minecraft-server
    ports:
      - "25565:25565"
```

---

## 🤔 Questions?

- Open a [Discussion](https://github.com/gastonfr24/dockercraft/discussions)
- Check [FAQ](docs/FAQ.md)
- Review existing [Issues](https://github.com/gastonfr24/dockercraft/issues)

---

## 📜 License

By contributing, you agree that your contributions will be licensed under the project's license.

---

**Thank you for contributing! 🎉**

