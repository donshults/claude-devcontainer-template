# Windows Setup Guide for Claude DevContainer Template

This guide explains how to set up and use the Claude DevContainer master template on Windows.

## Initial Setup

### 1. Download and Extract Template

1. Download `claude-devcontainer-master-template.tar.gz` from this container
2. Extract to a permanent location on your PC:
   ```powershell
   # Example location
   C:\DevContainerTemplates\claude-master-template\
   ```

### 2. Set Up Environment

#### Required Software
- **VS Code** with Dev Containers extension
- **Docker Desktop** (with WSL2 backend enabled)
- **Git for Windows**
- **GitHub CLI** (optional, for GitHub integration)

#### Configure Git for Line Endings
```bash
git config --global core.autocrlf input
```

### 3. Add Template to PATH (Optional)

To use the init scripts from anywhere:

1. Add the scripts directory to your PATH:
   - Windows Settings → System → About → Advanced system settings
   - Environment Variables → Path → Edit
   - Add: `C:\DevContainerTemplates\claude-master-template\scripts`

2. Or create an alias in PowerShell profile:
   ```powershell
   # Add to $PROFILE
   function New-ClaudeProject {
       param($ProjectName, $ProjectPath = (Get-Location))
       & "C:\DevContainerTemplates\claude-master-template\scripts\init-project.ps1" -ProjectName $ProjectName -ProjectPath $ProjectPath @args
   }
   ```

## Creating New Projects

### Method 1: Using PowerShell Script

```powershell
# Navigate to where you want to create projects
cd D:\ClaudeProjects

# Basic usage
C:\DevContainerTemplates\claude-master-template\scripts\init-project.ps1 my-new-project

# With GitHub repository
C:\DevContainerTemplates\claude-master-template\scripts\init-project.ps1 -CreateGitHub my-project

# Specify different path
C:\DevContainerTemplates\claude-master-template\scripts\init-project.ps1 -ProjectPath D:\Projects my-project
```

### Method 2: Using Batch File

```cmd
# From Command Prompt or Windows Explorer
cd D:\ClaudeProjects

# Run the batch file
C:\DevContainerTemplates\claude-master-template\scripts\init-project.bat my-new-project
```

### Method 3: Using the Alias (if configured)

```powershell
cd D:\ClaudeProjects
New-ClaudeProject my-awesome-app -CreateGitHub
```

## Project Workflow

### 1. Create Project
```powershell
cd D:\ClaudeProjects
C:\DevContainerTemplates\claude-master-template\scripts\init-project.ps1 trading-bot
```

### 2. Set Up Environment
```powershell
cd trading-bot
copy .env.example .env
# Edit .env with your API keys
notepad .env
```

### 3. Open in VS Code
```powershell
code .
```

### 4. Start Dev Container
- VS Code will prompt: "Folder contains a Dev Container configuration file..."
- Click "Reopen in Container"
- Wait for container to build (first time takes longer)

### 5. Verify Setup
Inside the container terminal:
```bash
# Check Claude CLI
claude --version

# List MCP servers
claude mcp list

# Run validation
python tests/test_setup.py
```

## Directory Structure

Your Windows filesystem should look like:

```
C:\DevContainerTemplates\
└── claude-master-template\        # Master template (never modify directly)
    ├── .devcontainer\
    ├── scripts\
    ├── config\
    └── docs\

D:\ClaudeProjects\                 # Your projects
├── project-1\                     # Each project is independent
│   ├── .devcontainer\            # Copied from template
│   ├── .env                      # Your API keys (not in Git)
│   ├── src\                      # Your code
│   └── README.md
├── project-2\
│   ├── .devcontainer\
│   ├── .env
│   ├── src\
│   └── README.md
└── trading-bot\
    ├── .devcontainer\
    ├── .env
    ├── src\
    └── README.md
```

## Important Notes

### Each Project is Independent
- Has its own Dev Container
- Has its own Git repository
- Has its own dependencies
- Shares the same base configuration (from template)

### The Template is Reusable
- Keep the master template clean
- Make project-specific changes in each project
- Update the template for improvements that benefit all projects

### Environment Variables
- Each project has its own `.env` file
- Never commit `.env` files
- Use `.env.example` as a reference

## Common Issues

### "Exit code 1" when opening container

1. **Check Docker Desktop is running**
2. **Try simpler configuration first**:
   - Comment out optional MCP servers
   - Remove Docker-in-Docker feature
3. **Rebuild without cache**:
   - F1 → "Dev Containers: Rebuild Container Without Cache"

### Permission Issues

- The template uses UID/GID 1000 by default
- This works for most Windows WSL2 setups
- If you have issues, check the troubleshooting guide

### Can't find files in container

- Your project files are mounted at `/workspace`
- Use absolute paths in configurations
- Check mount succeeded: `ls /workspace`

## Best Practices

1. **Keep Projects Organized**
   ```
   D:\ClaudeProjects\
   ├── web-apps\
   │   ├── blog-platform\
   │   └── e-commerce\
   ├── automation\
   │   ├── trading-bot\
   │   └── data-pipeline\
   └── experiments\
       └── test-project\
   ```

2. **Use Descriptive Names**
   - `trading-strategy-bot` not `project1`
   - `customer-portal-api` not `api`

3. **Regular Template Updates**
   - Pull template improvements
   - Test in a sample project first
   - Apply to existing projects carefully

4. **Backup Your Work**
   - Use Git for all projects
   - Push to GitHub regularly
   - Keep `.env` files backed up separately

## Next Steps

1. Create your first project
2. Customize the template for your needs
3. Share improvements back to the template
4. Build amazing things with consistent environments!

Remember: The power of Dev Containers is having a consistent, reproducible development environment for each project while keeping your projects organized on your Windows filesystem.