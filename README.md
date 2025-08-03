# Claude DevContainer Master Template

🚀 A reusable master template for creating Claude Code projects with DevContainers, providing a consistent development environment across all your projects.

## Features

- **Complete Development Environment**: Pre-configured with Node.js, Python, Git, Docker-in-Docker, and essential development tools
- **MCP Server Integration**: All major MCP servers pre-configured (GitHub, Airtable, PostgreSQL, n8n, Slack, etc.)
- **VS Code Optimized**: Comprehensive VS Code settings and extensions for maximum productivity
- **Persistent Storage**: Command history, configurations, and package caches persist across container rebuilds
- **Project Initialization Script**: Quick setup for new projects from this template
- **Security First**: Non-root user, proper permissions, and secure defaults

## Quick Start

### Method 1: Using the Initialization Script

```bash
# Clone this template
git clone https://github.com/YOUR_USERNAME/claude-devcontainer-master-template.git

# Run the initialization script
./claude-devcontainer-master-template/scripts/init-project.sh my-new-project

# Navigate to your new project
cd my-new-project

# Open in VS Code
code .
```

### Method 2: Manual Setup

```bash
# Create your project directory
mkdir my-new-project
cd my-new-project

# Copy the template files
cp -r /path/to/claude-devcontainer-master-template/.devcontainer .
cp -r /path/to/claude-devcontainer-master-template/scripts .
cp -r /path/to/claude-devcontainer-master-template/config .

# Create .env from example
cp .env.example .env
# Edit .env with your API keys

# Open in VS Code
code .
```

## Project Initialization Options

The `init-project.sh` script supports several options:

```bash
# Basic usage
./scripts/init-project.sh my-project

# Specify custom path
./scripts/init-project.sh -p ~/projects my-project

# Create with GitHub repository
./scripts/init-project.sh -g my-project

# Create public GitHub repository
./scripts/init-project.sh -g -P my-project

# All options
./scripts/init-project.sh -p ~/projects -g -P -r custom-repo-name my-project
```

## Environment Configuration

### Required Environment Variables

Create a `.env` file in your project root:

```bash
# GitHub Integration (required for GitHub MCP server)
GITHUB_PERSONAL_ACCESS_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx

# Timezone
TZ=America/Los_Angeles
```

### Optional Environment Variables

```bash
# Airtable Integration
AIRTABLE_API_KEY=patxxxxxxxxxxxxx

# PostgreSQL Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# n8n Automation
N8N_API_KEY=your_n8n_api_key
N8N_BASE_URL=https://your-n8n-instance.com

# Slack Integration
SLACK_BOT_TOKEN=xoxb-xxxxxxxxxxxx
SLACK_TEAM_ID=TXXXXXXXXX

# User ID (auto-detected on Linux/macOS)
USER_UID=1000
USER_GID=1000
```

## MCP Servers

### Always Enabled
- **filesystem**: File system access within the container
- **memory**: Persistent memory across Claude sessions
- **github**: GitHub API integration (requires GITHUB_PERSONAL_ACCESS_TOKEN)
- **context7**: Documentation retrieval for any library

### Conditionally Enabled
These servers are enabled when their required environment variables are set:
- **airtable**: Requires AIRTABLE_API_KEY
- **postgres**: Requires DATABASE_URL
- **n8n**: Requires N8N_API_KEY and N8N_BASE_URL
- **slack**: Requires SLACK_BOT_TOKEN and SLACK_TEAM_ID

## Included Tools

### Languages & Runtimes
- Node.js 20 with npm
- Python 3 with pip
- Zsh with Oh My Zsh

### Development Tools
- Claude Code CLI
- Git with delta diff viewer
- GitHub CLI
- Docker CLI (Docker-in-Docker)
- VS Code Server

### Node.js Global Packages
- prettier, eslint, typescript
- nodemon, concurrently
- http-server, json-server

### Python Packages
- requests, python-dotenv
- pytest, black, flake8, pylint
- httpie, ipython

### System Utilities
- ripgrep, fd-find, bat
- tmux, htop, tree
- jq, curl, wget

## VS Code Extensions

The template includes a curated set of VS Code extensions:

### Core Development
- Prettier, ESLint, GitLens
- GitHub Copilot

### Language Support
- Python, Pylance, Black Formatter
- TypeScript, JavaScript

### Utilities
- Live Server, Docker
- Markdown All in One
- Todo Tree, Better Comments

## Persistent Storage

The following data persists across container rebuilds:
- Command history (bash and zsh)
- Claude configuration
- VS Code extensions
- npm cache
- Python packages

## Customization

### Adding New MCP Servers

Edit `.devcontainer/devcontainer.json`:

```json
"mcpServers": {
  "your-server": {
    "command": "npx",
    "args": ["-y", "@your-org/mcp-server"],
    "env": {
      "YOUR_API_KEY": "${localEnv:YOUR_API_KEY}"
    }
  }
}
```

### Modifying VS Code Settings

Edit `config/vscode-settings.json` to change default VS Code settings for all projects.

### Adding Global Tools

Edit `.devcontainer/Dockerfile` to add system packages or global tools.

## Troubleshooting

### Container Build Issues
```bash
# Clear Docker cache
docker system prune -a

# Rebuild without cache
code . # Open in VS Code
# F1 -> "Dev Containers: Rebuild Container Without Cache"
```

### MCP Server Issues
```bash
# Inside container, check MCP servers
claude mcp list

# Check logs
docker logs <container-id>
```

### Permission Issues
```bash
# Ensure correct UID/GID
echo "USER_UID=$(id -u)" >> .env
echo "USER_GID=$(id -g)" >> .env
```

## Best Practices

1. **Never commit `.env` files** - Use `.env.example` as a template
2. **Update regularly** - Pull latest template changes
3. **Project-specific changes** - Make them in your project, not the template
4. **Use CLAUDE.md** - Document project-specific instructions for Claude

## Contributing

1. Fork this repository
2. Create a feature branch
3. Make your improvements
4. Submit a pull request

## License

MIT License - See LICENSE file for details

---

Built with ❤️ for the Claude Code community