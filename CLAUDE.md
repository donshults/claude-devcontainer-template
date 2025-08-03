# CLAUDE.md

This file provides guidance to Claude Code when working with the Claude DevContainer Master Template repository.

## Project Overview

This is the master template repository for creating Claude Code DevContainer projects. It contains:
- DevContainer configuration templates
- Initialization scripts for Windows, macOS, and Linux
- Documentation and best practices
- CI/CD workflows for template validation

## Development Guidelines

### Template Development

When modifying the template:
1. Test all changes by creating a new project using the init scripts
2. Ensure compatibility across Windows, macOS, and Linux
3. Update VERSION file and CHANGELOG.md for releases
4. Document any breaking changes

### Code Style
- Use consistent formatting across all scripts
- Shell scripts should be POSIX-compliant where possible
- PowerShell scripts should follow standard conventions
- JSON files must be valid and properly formatted

### Testing
- Run `./scripts/init-project.sh test-project` to test template
- Verify all MCP servers work correctly
- Test on fresh environments

### Important Files
- `VERSION` - Current template version
- `CHANGELOG.md` - Version history and changes
- `scripts/init-project.*` - Project creation scripts
- `template-dev.devcontainer.json` - DevContainer for template development

## Common Commands

```bash
# Test template by creating a project
./scripts/init-project.sh -p /workspace test-project

# Install development dependencies
npm install -D prettier markdownlint-cli

# Format all files
npm run format

# Validate template files
npm run validate
```

## Environment Variables

When developing the template:
- `TEMPLATE_DEV=true` - Indicates template development mode

## Release Process

1. Update VERSION file
2. Update CHANGELOG.md
3. Create git tag: `git tag v1.x.x`
4. Push to GitHub with tags
5. GitHub Actions will create release

## Important Notes

- This is a TEMPLATE repository - don't add project-specific code
- Keep the template minimal and extensible
- Document all features in the README
- Test across different environments before releasing