# Changelog

All notable changes to the Claude DevContainer Master Template will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2024-08-03

### Added
- Initial release of Claude DevContainer Master Template
- Complete DevContainer configuration with Dockerfile
- MCP server integration (filesystem, memory, GitHub)
- Optional MCP servers (Airtable, PostgreSQL, n8n, Slack)
- Windows PowerShell initialization script
- Windows batch file wrapper
- Comprehensive VS Code settings and extensions
- Project initialization scripts for multiple platforms
- Documentation for Windows setup and troubleshooting
- Example workflow for multi-project development

### Features
- Non-root user setup (developer with UID/GID 1000)
- Persistent storage for command history and configurations
- Pre-installed development tools (Node.js 20, Python 3, Git)
- Claude Code CLI integration
- GitHub CLI for repository management
- Automated project structure creation
- Git repository initialization
- Environment variable management via .env files

### Security
- Secure defaults with minimal container capabilities
- Separate .env.example for safe template sharing
- Git ignore rules for sensitive files

---

## Version History

- **1.0.0** (2024-08-03): Initial stable release