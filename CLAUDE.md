# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the Claude DevContainer Master Template repository.

## Project Overview

This is the master template repository for creating Claude Code DevContainer projects. It provides:
- Cross-platform initialization scripts (Bash, PowerShell, Batch)
- DevContainer configuration with Node.js 20 and MCP servers
- Comprehensive VS Code settings and extensions
- CI/CD workflows for template validation and automated releases
- Update mechanism for existing projects

## High-Level Architecture

### Template System Design
1. **Initialization Scripts** (`scripts/init-project.*`):
   - Create complete project structure from template
   - Support GitHub repository creation
   - Generate environment files, documentation, and test files
   - Platform-specific implementations maintain feature parity

2. **DevContainer Configuration**:
   - Ubuntu-based container with Node.js 20
   - Network capabilities (NET_ADMIN, NET_RAW) for MCP servers
   - Persistent volumes for history and Claude configuration
   - Pre-configured VS Code extensions and settings

3. **Update Mechanism** (`scripts/update-project.ps1`):
   - Selective component updates
   - Backup creation before modifications
   - Dry-run capability for change preview

4. **CI/CD Pipeline** (`.github/workflows/test-template.yml`):
   - File validation (JSON, Markdown, permissions)
   - Container build testing
   - Cross-platform script testing
   - Automated release creation

## Common Development Commands

```bash
# Create new project from template
./scripts/init-project.sh -p /path/to/projects test-project

# Create project with GitHub repo (requires GH_TOKEN)
./scripts/init-project.sh -p /workspace -g my-project

# Windows: Create project
.\scripts\init-project.ps1 -ProjectName test-project -ProjectPath C:\Projects

# Windows: Update existing project
.\scripts\update-project.ps1 -ProjectPath C:\Projects\my-project -Components devcontainer,vscode

# Install development dependencies (currently only linting tools)
npm install

# Validate JSON files (manual command used in CI)
for file in $(find . -name "*.json" -o -name "*.jsonc"); do
  python -m json.tool "$file" > /dev/null || echo "Invalid JSON: $file"
done

# Check script permissions
test -x scripts/init-project.sh || echo "init-project.sh not executable"
```

## Key Files and Locations

### Configuration Templates
- `.devcontainer/devcontainer.json` - Container configuration with MCP servers
- `.devcontainer/Dockerfile` - Ubuntu base with development tools
- `config/vscode-settings.json` - 290-line comprehensive VS Code configuration
- `.env.example` - Environment variables template (GitHub token, integrations)

### Scripts
- `scripts/init-project.sh` - 548-line Bash initialization script
- `scripts/init-project.ps1` - PowerShell equivalent with same features
- `scripts/update-project.ps1` - Project update utility with component selection

### Documentation
- `docs/WINDOWS_SETUP.md` - Windows-specific setup and PATH configuration
- `docs/TEMPLATE_UPDATES.md` - Update procedures and best practices
- `docs/TROUBLESHOOTING.md` - Common issues and solutions
- `docs/EXAMPLE_WORKFLOW.md` - Multi-project development examples

## Development Guidelines

### Template Development
1. Test all changes by creating new projects on target platforms
2. Maintain feature parity across Bash and PowerShell scripts
3. Update VERSION file and CHANGELOG.md for releases
4. Ensure GitHub Actions tests pass before merging

### Code Style
- Shell scripts: POSIX-compliant where possible
- PowerShell: Standard conventions with approved verbs
- JSON files: Valid syntax (validated in CI)
- Markdown: Follows markdownlint rules

### Testing Approach
- Local: Create test projects using init scripts
- CI: Automated validation across Ubuntu, Windows, macOS
- Container: Build verification with tool availability checks
- Updates: Test update script with dry-run first

## Release Process

1. Update VERSION file with new version number
2. Update CHANGELOG.md with changes
3. Commit changes: `git commit -m "Release v1.x.x"`
4. Create git tag: `git tag v1.x.x`
5. Push to GitHub with tags: `git push origin main --tags`
6. GitHub Actions will automatically create release with ZIP archive

## Important Notes

- This is a TEMPLATE repository - avoid project-specific code
- All features must work on Windows, macOS, and Linux
- MCP server configuration requires proper network setup in container
- Update scripts preserve user modifications when possible