# Claude DevContainer Master Template

🚀 A professional, reusable DevContainer template for Claude Code projects with Windows support, MCP servers, and comprehensive tooling.

[![Template Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/YOUR_USERNAME/claude-devcontainer-template/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 🎯 Purpose

This repository maintains the master template for creating Claude Code DevContainer projects. It provides:

- Consistent development environments across all projects
- Pre-configured MCP servers for Claude integration
- Windows-optimized initialization scripts
- Comprehensive VS Code settings and extensions
- Built-in update mechanism for existing projects

## 📁 Repository Structure

```
claude-devcontainer-template/
├── .devcontainer/              # DevContainer configuration files
│   ├── devcontainer.json      # Main container configuration
│   └── Dockerfile             # Container image definition
├── .github/                   # GitHub specific files
│   └── workflows/            # CI/CD workflows
├── config/                    # Shared configuration files
│   └── vscode-settings.json  # Default VS Code settings
├── docs/                      # Documentation
│   ├── WINDOWS_SETUP.md      # Windows-specific guide
│   ├── TEMPLATE_UPDATES.md   # Update procedures
│   ├── TROUBLESHOOTING.md    # Common issues and solutions
│   └── EXAMPLE_WORKFLOW.md   # Multi-project examples
├── scripts/                   # Initialization and utility scripts
│   ├── init-project.ps1      # PowerShell project creator
│   ├── init-project.bat      # Windows batch wrapper
│   ├── init-project.sh       # Bash project creator
│   └── update-project.ps1    # Update existing projects
├── .env.example              # Environment variables template
├── .gitignore                # Git ignore rules
├── CHANGELOG.md              # Version history
├── VERSION                   # Current template version
└── README.md                 # This file
```

## 🚀 Quick Start

### For Template Users

1. **Download the template**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/claude-devcontainer-template.git
   cd claude-devcontainer-template
   ```

2. **Create a new project**:
   ```powershell
   # Windows PowerShell
   .\scripts\init-project.ps1 -ProjectName my-awesome-project
   
   # Or with GitHub integration
   .\scripts\init-project.ps1 -ProjectName my-project -CreateGitHub
   ```

3. **Set up your project**:
   ```powershell
   cd my-awesome-project
   copy .env.example .env
   # Edit .env with your API keys
   code .
   ```

### For Template Developers

1. **Clone this repository**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/claude-devcontainer-template.git
   cd claude-devcontainer-template
   ```

2. **Open in VS Code**:
   ```bash
   code .
   ```

3. **Reopen in Container** using the template development container:
   - Copy `template-dev.devcontainer.json` to `.devcontainer/devcontainer.json`
   - Reopen in container

## 🛠️ Development Workflow

### Making Template Changes

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/add-new-tool
   ```

2. **Make your changes**:
   - Edit Dockerfile for new tools
   - Update devcontainer.json for new extensions
   - Add documentation

3. **Update version**:
   ```bash
   # Bump version appropriately
   echo "1.1.0" > VERSION
   ```

4. **Update CHANGELOG.md**:
   ```markdown
   ## [1.1.0] - 2024-08-10
   ### Added
   - New tool XYZ
   ```

5. **Test changes**:
   ```powershell
   # Create test project
   .\scripts\init-project.ps1 -ProjectName test-v1.1.0
   ```

6. **Commit and tag**:
   ```bash
   git add .
   git commit -m "feat: Add new tool XYZ"
   git tag v1.1.0
   ```

### Testing Template Changes

The template includes GitHub Actions for automated testing:

- **Template validation**: Ensures all files are valid
- **Container build test**: Verifies Dockerfile builds successfully
- **Script execution test**: Tests initialization scripts

## 📦 Included Features

### Development Tools
- **Languages**: Node.js 20, Python 3, Git
- **Package Managers**: npm, pip
- **Shell**: Zsh with Oh My Zsh
- **CLI Tools**: Claude Code CLI, GitHub CLI

### MCP Servers
- **filesystem**: File system access
- **memory**: Persistent memory
- **github**: GitHub integration
- **Optional**: Airtable, PostgreSQL, n8n, Slack

### VS Code Extensions
- Code formatting (Prettier, Black)
- Git management (GitLens)
- Language support (Python, JS/TS)
- Productivity tools (Todo Tree, Better Comments)

## 🔄 Updating Existing Projects

Projects created from this template can be updated:

```powershell
# See what would change
.\scripts\update-project.ps1 -ProjectPath D:\Projects\my-project -DryRun

# Update with backup
.\scripts\update-project.ps1 -ProjectPath D:\Projects\my-project -Backup
```

## 📚 Documentation

- **[Windows Setup Guide](docs/WINDOWS_SETUP.md)** - Complete Windows installation and usage
- **[Template Updates](docs/TEMPLATE_UPDATES.md)** - How to update the template and projects
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Common issues and solutions
- **[Example Workflow](docs/EXAMPLE_WORKFLOW.md)** - Multi-project development examples

## 🤝 Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Update documentation
6. Submit a pull request

### Development Guidelines

- Follow existing code style
- Update CHANGELOG.md
- Test on Windows, macOS, and Linux
- Ensure backward compatibility
- Document breaking changes

## 📋 Roadmap

- [ ] Add more MCP server templates
- [ ] Create project type templates (web, API, CLI)
- [ ] Add automated testing suite
- [ ] Create VS Code extension
- [ ] Multi-language support

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built for [Claude Code](https://claude.ai/code)
- Uses [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)
- Implements [Model Context Protocol](https://modelcontextprotocol.io)

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/YOUR_USERNAME/claude-devcontainer-template/issues)
- **Discussions**: [GitHub Discussions](https://github.com/YOUR_USERNAME/claude-devcontainer-template/discussions)
- **Template Updates**: Watch this repo for notifications

---

Made with ❤️ for the Claude Code community