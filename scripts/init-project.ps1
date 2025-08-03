# Claude DevContainer Project Initialization Script for Windows
# PowerShell version

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$ProjectName,
    
    [Parameter(Mandatory=$false)]
    [string]$ProjectPath = (Get-Location).Path,
    
    [Parameter(Mandatory=$false)]
    [switch]$CreateGitHub,
    
    [Parameter(Mandatory=$false)]
    [switch]$PublicRepo,
    
    [Parameter(Mandatory=$false)]
    [string]$GitHubRepo = $ProjectName,
    
    [Parameter(Mandatory=$false)]
    [switch]$Help
)

# Script configuration
$TemplateDir = Split-Path -Parent $PSScriptRoot
$FullProjectPath = Join-Path $ProjectPath $ProjectName

# Color functions
function Write-Color {
    param($Text, $Color = "White")
    Write-Host $Text -ForegroundColor $Color
}

function Show-Usage {
    Write-Color "`nClaude DevContainer Project Initialization Script" "Cyan"
    Write-Color "=================================================" "Cyan"
    Write-Host @"

Usage: init-project.ps1 [-ProjectName] <string> [OPTIONS]

Initialize a new Claude DevContainer project from the master template.

Parameters:
    -ProjectName <string>    Name of the project to create (required)
    -ProjectPath <string>    Path where to create the project (default: current directory)
    -CreateGitHub           Create and push to GitHub repository
    -PublicRepo             Make GitHub repository public (default: private)
    -GitHubRepo <string>    GitHub repository name (default: project name)
    -Help                   Show this help message

Examples:
    .\init-project.ps1 my-project
    .\init-project.ps1 -ProjectPath D:\Projects -CreateGitHub my-awesome-app
    .\init-project.ps1 -ProjectPath C:\Source -CreateGitHub -PublicRepo my-open-source-tool

"@
}

# Show help if requested
if ($Help) {
    Show-Usage
    exit 0
}

# Validate project name
if ([string]::IsNullOrWhiteSpace($ProjectName)) {
    Write-Color "Error: Project name is required" "Red"
    Show-Usage
    exit 1
}

# Check if project already exists
if (Test-Path $FullProjectPath) {
    Write-Color "Error: Project directory already exists: $FullProjectPath" "Red"
    exit 1
}

Write-Color "`n🚀 Creating Claude DevContainer project: $ProjectName" "Blue"
Write-Color "📁 Location: $FullProjectPath" "Blue"

# Create project directory
Write-Color "`n📋 Creating project structure..." "Yellow"
New-Item -ItemType Directory -Path $FullProjectPath -Force | Out-Null

# Copy template files
Write-Color "📋 Copying template files..." "Yellow"

# Copy DevContainer configuration
Copy-Item -Path "$TemplateDir\.devcontainer" -Destination $FullProjectPath -Recurse

# Copy scripts directory
Copy-Item -Path "$TemplateDir\scripts" -Destination $FullProjectPath -Recurse

# Copy config directory
Copy-Item -Path "$TemplateDir\config" -Destination $FullProjectPath -Recurse

# Copy documentation templates
if (Test-Path "$TemplateDir\docs") {
    Copy-Item -Path "$TemplateDir\docs" -Destination $FullProjectPath -Recurse
}

# Create project-specific directories
New-Item -ItemType Directory -Path "$FullProjectPath\src" -Force | Out-Null
New-Item -ItemType Directory -Path "$FullProjectPath\tests" -Force | Out-Null
New-Item -ItemType Directory -Path "$FullProjectPath\docs" -Force | Out-Null

# Create VS Code workspace settings
New-Item -ItemType Directory -Path "$FullProjectPath\.vscode" -Force | Out-Null
Copy-Item -Path "$TemplateDir\config\vscode-settings.json" -Destination "$FullProjectPath\.vscode\settings.json"

# Create .gitignore
@'
# Environment files
.env
.env.local
.env.*.local
*.env

# Claude settings (keep local settings private)
.claude/settings.local.json

# OS files
.DS_Store
Thumbs.db
desktop.ini

# IDE files
.idea/
*.swp
*.swo
*~

# VS Code
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json
*.code-workspace

# Dependencies
node_modules/
bower_components/
vendor/

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
.venv
pip-log.txt
pip-delete-this-directory.txt
.pytest_cache/
.coverage
htmlcov/
.tox/
*.egg-info/
dist/
build/

# JavaScript/TypeScript
npm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*
.npm
.yarn-integrity
*.tsbuildinfo
.cache/
.parcel-cache/

# Build outputs
dist/
build/
out/
target/
*.out

# Logs
logs/
*.log

# Temporary files
tmp/
temp/
*.tmp
*.temp

# Database files
*.db
*.sqlite
*.sqlite3

# Secrets and credentials
*.pem
*.key
*.cert
*.crt
*.p12
*.pfx
secrets/
credentials/
'@ | Out-File -FilePath "$FullProjectPath\.gitignore" -Encoding UTF8

# Create README.md
@"
# $ProjectName

A Claude Code DevContainer project.

## Getting Started

### Prerequisites

- VS Code with Dev Containers extension
- Docker Desktop
- Git

### Setup

1. Clone this repository
2. Copy ``.env.example`` to ``.env`` and fill in your API keys
3. Open in VS Code
4. When prompted, click "Reopen in Container"

### Environment Variables

See ``.env.example`` for required environment variables.

### MCP Servers

This project is configured with the following MCP servers:
- Filesystem - File system access
- Memory - Persistent memory across sessions
- GitHub - GitHub API integration
- Additional servers as configured

## Development

### Project Structure

```
$ProjectName/
├── .devcontainer/     # Dev Container configuration
├── .vscode/           # VS Code settings
├── docs/              # Documentation
├── scripts/           # Utility scripts
├── src/               # Source code
├── tests/             # Test files
├── .env.example       # Environment variables template
├── .gitignore         # Git ignore rules
├── README.md          # This file
└── CLAUDE.md          # Claude Code guidelines
```

### Common Commands

- ``npm test`` - Run tests
- ``npm run dev`` - Start development server
- ``python scripts/validate-setup.py`` - Validate environment

## License

[Your License Here]
"@ | Out-File -FilePath "$FullProjectPath\README.md" -Encoding UTF8

# Create CLAUDE.md
@'
# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project Overview

[Add your project description here]

## Project Structure

- `/src` - Main source code
- `/tests` - Test files
- `/docs` - Documentation
- `/scripts` - Utility scripts

## Development Guidelines

### Code Style
- Use consistent formatting (Prettier for JS/TS, Black for Python)
- Follow existing patterns in the codebase
- Write clear, self-documenting code

### Testing
- Write tests for new features
- Run tests before committing
- Maintain test coverage

### Git Workflow
- Use meaningful commit messages
- Create feature branches for new work
- Keep commits focused and atomic

## Common Commands

```bash
# Development
npm run dev
npm test
npm run build

# Python
python -m pytest
python scripts/validate-setup.py

# Docker
docker compose up
docker compose down
```

## Environment Variables

Key environment variables:
- `GITHUB_PERSONAL_ACCESS_TOKEN` - For GitHub integration
- `AIRTABLE_API_KEY` - For Airtable integration (if used)
- See `.env.example` for complete list

## Important Notes

[Add any project-specific notes or warnings here]
'@ | Out-File -FilePath "$FullProjectPath\CLAUDE.md" -Encoding UTF8

# Copy .env.example
Copy-Item -Path "$TemplateDir\.env.example" -Destination $FullProjectPath

# Update post-attach.sh with project name
$postAttachPath = "$FullProjectPath\scripts\post-attach.sh"
if (Test-Path $postAttachPath) {
    $content = Get-Content $postAttachPath -Raw
    $content = $content -replace '\$PROJECT_NAME', $ProjectName
    Set-Content -Path $postAttachPath -Value $content -NoNewline
}

# Initialize git repository
Write-Color "`n📋 Initializing Git repository..." "Yellow"
Push-Location $FullProjectPath
git init
git add .
git commit -m "Initial commit - Claude DevContainer project setup"
Pop-Location

Write-Color "`n✅ Project created successfully!" "Green"

# Create GitHub repository if requested
if ($CreateGitHub) {
    Write-Color "`n📦 Creating GitHub repository..." "Yellow"
    
    # Check if gh is installed
    try {
        gh --version | Out-Null
    } catch {
        Write-Color "Error: GitHub CLI (gh) is not installed" "Red"
        Write-Color "Install it from: https://cli.github.com/" "Yellow"
        exit 1
    }
    
    # Check if authenticated
    try {
        gh auth status 2>&1 | Out-Null
    } catch {
        Write-Color "Please authenticate with GitHub:" "Yellow"
        gh auth login
    }
    
    # Create repository
    Push-Location $FullProjectPath
    $visibility = if ($PublicRepo) { "public" } else { "private" }
    
    try {
        gh repo create $GitHubRepo --$visibility --source=. --remote=origin --push
        $username = gh api user -q .login
        Write-Color "✅ GitHub repository created and code pushed!" "Green"
        Write-Color "🔗 Repository URL: https://github.com/$username/$GitHubRepo" "Blue"
    } catch {
        Write-Color "❌ Failed to create GitHub repository" "Red"
    }
    Pop-Location
}

# Final instructions
Write-Color "`n📝 Next steps:" "Blue"
Write-Color "1. cd $FullProjectPath" "Yellow"
Write-Color "2. Copy .env.example to .env and add your API keys" "Yellow"
Write-Color "3. Open in VS Code: code ." "Yellow"
Write-Color "4. Reopen in Container when prompted" "Yellow"

Write-Color "`n🎉 Happy coding with Claude!" "Green"