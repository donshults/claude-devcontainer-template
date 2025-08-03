#!/bin/bash

# Claude DevContainer Project Initialization Script
# This script helps create new projects from the master template

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_NAME=""
PROJECT_PATH=""
GITHUB_REPO=""
CREATE_GITHUB="false"
GITHUB_PRIVATE="true"

# Function to print colored output
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to print usage
usage() {
    cat << EOF
Usage: $0 [OPTIONS] PROJECT_NAME

Initialize a new Claude DevContainer project from the master template.

Options:
    -p, --path PATH          Path where to create the project (default: current directory)
    -g, --github             Create and push to GitHub repository
    -P, --public             Make GitHub repository public (default: private)
    -r, --repo REPO_NAME     GitHub repository name (default: project name)
    -h, --help               Show this help message

Examples:
    $0 my-project
    $0 -p ~/projects -g my-awesome-app
    $0 --path /workspace --github --public my-open-source-tool

EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--path)
            PROJECT_PATH="$2"
            shift 2
            ;;
        -g|--github)
            CREATE_GITHUB="true"
            shift
            ;;
        -P|--public)
            GITHUB_PRIVATE="false"
            shift
            ;;
        -r|--repo)
            GITHUB_REPO="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            PROJECT_NAME="$1"
            shift
            ;;
    esac
done

# Validate project name
if [ -z "$PROJECT_NAME" ]; then
    print_color $RED "Error: Project name is required"
    usage
    exit 1
fi

# Set default values
PROJECT_PATH="${PROJECT_PATH:-$(pwd)}"
GITHUB_REPO="${GITHUB_REPO:-$PROJECT_NAME}"
# If PROJECT_PATH is not absolute, use /workspace as default
if [[ "$PROJECT_PATH" != /* ]]; then
    PROJECT_PATH="/workspace"
fi
FULL_PROJECT_PATH="$PROJECT_PATH/$PROJECT_NAME"

# Check if project already exists
if [ -d "$FULL_PROJECT_PATH" ]; then
    print_color $RED "Error: Project directory already exists: $FULL_PROJECT_PATH"
    exit 1
fi

print_color $BLUE "🚀 Creating Claude DevContainer project: $PROJECT_NAME"
print_color $BLUE "📁 Location: $FULL_PROJECT_PATH"

# Create project directory
mkdir -p "$FULL_PROJECT_PATH"

# Copy template files
print_color $YELLOW "📋 Copying template files..."

# Copy DevContainer configuration
cp -r "$TEMPLATE_DIR/.devcontainer" "$FULL_PROJECT_PATH/"

# Copy scripts directory
cp -r "$TEMPLATE_DIR/scripts" "$FULL_PROJECT_PATH/"

# Copy config directory
cp -r "$TEMPLATE_DIR/config" "$FULL_PROJECT_PATH/"

# Copy documentation templates
if [ -d "$TEMPLATE_DIR/docs" ]; then
    cp -r "$TEMPLATE_DIR/docs" "$FULL_PROJECT_PATH/"
fi

# Create project-specific directories
mkdir -p "$FULL_PROJECT_PATH"/{src,tests,docs}

# Create VS Code workspace settings
mkdir -p "$FULL_PROJECT_PATH/.vscode"
cp "$TEMPLATE_DIR/config/vscode-settings.json" "$FULL_PROJECT_PATH/.vscode/settings.json"

# Create .gitignore
cat > "$FULL_PROJECT_PATH/.gitignore" << 'EOF'
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
EOF

# Create README.md
cat > "$FULL_PROJECT_PATH/README.md" << EOF
# $PROJECT_NAME

A Claude Code DevContainer project.

## Getting Started

### Prerequisites

- VS Code with Dev Containers extension
- Docker Desktop
- Git

### Setup

1. Clone this repository
2. Copy \`.env.example\` to \`.env\` and fill in your API keys
3. Open in VS Code
4. When prompted, click "Reopen in Container"

### Environment Variables

See \`.env.example\` for required environment variables.

### MCP Servers

This project is configured with the following MCP servers:
- Filesystem - File system access
- Memory - Persistent memory across sessions
- GitHub - GitHub API integration
- Additional servers as configured

## Development

### Project Structure

\`\`\`
$PROJECT_NAME/
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
\`\`\`

### Common Commands

- \`npm test\` - Run tests
- \`npm run dev\` - Start development server
- \`python scripts/validate-setup.py\` - Validate environment

## License

[Your License Here]
EOF

# Create CLAUDE.md
cat > "$FULL_PROJECT_PATH/CLAUDE.md" << 'EOF'
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
EOF

# Create .env.example
cat > "$FULL_PROJECT_PATH/.env.example" << 'EOF'
# Copy this file to .env and fill in your values
# NEVER commit .env files to version control

# GitHub Integration
GITHUB_PERSONAL_ACCESS_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx

# Airtable Integration (optional)
# AIRTABLE_API_KEY=patxxxxxxxxxxxxx

# PostgreSQL Database (optional)
# DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# n8n Automation (optional)
# N8N_API_KEY=your_n8n_api_key
# N8N_BASE_URL=https://your-n8n-instance.com

# Slack Integration (optional)
# SLACK_BOT_TOKEN=xoxb-xxxxxxxxxxxx
# SLACK_TEAM_ID=TXXXXXXXXX

# Timezone
TZ=America/Los_Angeles

# User ID settings (usually auto-detected)
# USER_UID=1000
# USER_GID=1000
EOF

# Create sample test file
cat > "$FULL_PROJECT_PATH/tests/test_setup.py" << 'EOF'
#!/usr/bin/env python3
"""Test to verify the development environment is properly configured."""

import subprocess
import sys
import os


def test_command(cmd, description):
    """Test if a command executes successfully."""
    try:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        if result.returncode == 0:
            print(f"✅ {description}")
            return True
        else:
            print(f"❌ {description}")
            print(f"   Error: {result.stderr}")
            return False
    except Exception as e:
        print(f"❌ {description}")
        print(f"   Exception: {str(e)}")
        return False


def main():
    """Run all environment tests."""
    print("🔧 Development Environment Test")
    print("=" * 50)
    
    tests = [
        ("node --version", "Node.js installed"),
        ("npm --version", "npm installed"),
        ("python3 --version", "Python installed"),
        ("git --version", "Git installed"),
        ("claude --version", "Claude Code CLI installed"),
        ("docker --version", "Docker available"),
    ]
    
    results = []
    for cmd, desc in tests:
        results.append(test_command(cmd, desc))
    
    # Check environment variables
    print("\n📋 Environment Variables:")
    env_vars = ["GITHUB_PERSONAL_ACCESS_TOKEN", "TZ"]
    for var in env_vars:
        if os.environ.get(var):
            print(f"✅ {var}: Set")
        else:
            print(f"⚠️  {var}: Not set")
    
    # Summary
    print("\n" + "=" * 50)
    if all(results):
        print("✅ All tests passed!")
        return 0
    else:
        print("❌ Some tests failed.")
        return 1


if __name__ == "__main__":
    sys.exit(main())
EOF

chmod +x "$FULL_PROJECT_PATH/tests/test_setup.py"

# Create post-create script
cat > "$FULL_PROJECT_PATH/scripts/post-create.sh" << 'EOF'
#!/bin/bash
# Post-create script - runs after container is created

echo "🚀 Running post-create setup..."

# Create .claude directory if it doesn't exist
mkdir -p ~/.claude

# Install any project-specific dependencies
if [ -f "requirements.txt" ]; then
    echo "📦 Installing Python dependencies..."
    pip install -r requirements.txt
fi

if [ -f "package.json" ]; then
    echo "📦 Installing Node.js dependencies..."
    npm install
fi

echo "✅ Post-create setup complete!"
EOF

chmod +x "$FULL_PROJECT_PATH/scripts/post-create.sh"

# Create post-attach script
cat > "$FULL_PROJECT_PATH/scripts/post-attach.sh" << 'EOF'
#!/bin/bash
# Post-attach script - runs when you attach to the container

# Welcome message
echo "🎉 Welcome to $PROJECT_NAME DevContainer!"
echo ""
echo "📋 Quick commands:"
echo "  - claude --help         # Claude Code CLI help"
echo "  - npm run dev          # Start development server"
echo "  - python tests/test_setup.py  # Test environment"
echo ""
echo "💡 Tip: Check CLAUDE.md for project-specific guidance"
EOF

chmod +x "$FULL_PROJECT_PATH/scripts/post-attach.sh"

# Update post-attach script with project name
sed -i "s/\$PROJECT_NAME/$PROJECT_NAME/g" "$FULL_PROJECT_PATH/scripts/post-attach.sh"

# Initialize git repository with main branch
cd "$FULL_PROJECT_PATH"
git init -b main
git add .
git commit -m "Initial commit - Claude DevContainer project setup"

print_color $GREEN "✅ Project created successfully!"

# Create GitHub repository if requested
if [ "$CREATE_GITHUB" = "true" ]; then
    print_color $YELLOW "📦 Creating GitHub repository..."
    
    # Check if gh is installed
    if ! command -v gh &> /dev/null; then
        print_color $RED "Error: GitHub CLI (gh) is not installed"
        print_color $YELLOW "Install it from: https://cli.github.com/"
        exit 1
    fi
    
    # Check if authenticated
    if ! gh auth status &> /dev/null; then
        print_color $YELLOW "Please authenticate with GitHub:"
        gh auth login
    fi
    
    # Create repository
    VISIBILITY=$([ "$GITHUB_PRIVATE" = "true" ] && echo "private" || echo "public")
    
    if gh repo create "$GITHUB_REPO" --$VISIBILITY --source=. --remote=origin --push; then
        print_color $GREEN "✅ GitHub repository created and code pushed!"
        print_color $BLUE "🔗 Repository URL: https://github.com/$(gh api user -q .login)/$GITHUB_REPO"
    else
        print_color $RED "❌ Failed to create GitHub repository"
    fi
fi

# Final instructions
print_color $BLUE "\n📝 Next steps:"
print_color $YELLOW "1. cd $FULL_PROJECT_PATH"
print_color $YELLOW "2. Copy .env.example to .env and add your API keys"
print_color $YELLOW "3. Open in VS Code: code ."
print_color $YELLOW "4. Reopen in Container when prompted"

print_color $GREEN "\n🎉 Happy coding with Claude!"