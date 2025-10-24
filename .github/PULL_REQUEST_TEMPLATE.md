# Pull Request

## Description

Provide a clear description of what this PR does.

## Type of Change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Refactoring (no functional changes)
- [ ] Performance improvement
- [ ] Dependency update

## Related Issues

Closes #(issue number)
Relates to #(issue number)

## Changes Made

List the main changes:

- Added X
- Modified Y
- Removed Z

## Testing

Describe how you tested this:

```bash
# Commands used to test
docker-compose build
docker-compose up -d
docker-compose logs -f
```

## Checklist

### Code Quality

- [ ] Code follows the project's cursor rules
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] No console.log/debug statements left
- [ ] No hardcoded secrets or credentials
- [ ] Variables are properly named and documented

### Docker Specific (if applicable)

- [ ] Dockerfile follows best practices
- [ ] .dockerignore is updated
- [ ] No unnecessary layers
- [ ] Environment variables documented in .env.example
- [ ] Health checks working correctly
- [ ] Resource limits are appropriate

### Shell Scripts (if applicable)

- [ ] Scripts have proper error handling (set -euo pipefail)
- [ ] Scripts have proper logging
- [ ] Scripts are executable (chmod +x)
- [ ] Shellcheck passes (no errors)

### Documentation

- [ ] README.md updated (if needed)
- [ ] .env.example updated (if new vars added)
- [ ] docs/ai/04_MEMORY.md updated
- [ ] docs/ai/09_CHANGELOG.md updated
- [ ] Comments explain WHY not WHAT

### Testing

- [ ] Tested locally
- [ ] Docker build succeeds
- [ ] Docker compose up works
- [ ] Health checks pass
- [ ] No regression (existing features still work)

### Git

- [ ] Commits follow conventional commits format
- [ ] No emojis in commits
- [ ] Branch name follows conventions
- [ ] No merge conflicts

## Screenshots (if applicable)

Add screenshots or logs if relevant.

## Breaking Changes

If this PR includes breaking changes, describe:

1. What breaks
2. Why it was necessary
3. How to migrate

## Additional Notes

Any additional information for reviewers.

## Reviewer Notes

Areas that need special attention:

- [ ] Performance implications
- [ ] Security considerations
- [ ] Backward compatibility

---

**By submitting this PR, I confirm that:**

- [ ] I have read and followed the project's contribution guidelines
- [ ] My code follows the cursor rules defined in `.cursor/rules/`
- [ ] I have tested my changes thoroughly
- [ ] I am ready to address review feedback

