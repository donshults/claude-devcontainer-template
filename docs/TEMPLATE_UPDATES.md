# Template Update Guide

This guide explains how to maintain and update the Claude DevContainer Master Template and apply updates to existing projects.

## Template Versioning

The template uses [Semantic Versioning](https://semver.org/):
- **MAJOR.MINOR.PATCH** (e.g., 1.2.3)
- **MAJOR**: Breaking changes (rare)
- **MINOR**: New features, backwards compatible
- **PATCH**: Bug fixes and minor improvements

Current version is tracked in the `VERSION` file.

## Making Template Updates

### 1. Set Up Template Repository (Recommended)

```powershell
# Navigate to template directory
cd C:\DevContainerTemplates\claude-master-template

# Initialize Git repository
git init
git add .
git commit -m "Initial template version 1.0.0"

# Optional: Push to GitHub
git remote add origin https://github.com/YOUR_USERNAME/claude-devcontainer-template.git
git push -u origin main
```

### 2. Template Directory Structure

```
C:\DevContainerTemplates\claude-master-template\
├── .devcontainer/          # Core DevContainer files
├── scripts/                # Initialization and update scripts
├── config/                 # Shared configurations
├── docs/                   # Documentation
├── VERSION                 # Current template version
├── CHANGELOG.md           # Version history
└── README.md              # Template documentation
```

### 3. Making Changes

#### Update Process:

1. **Edit template files**:
   ```powershell
   cd C:\DevContainerTemplates\claude-master-template
   # Make your changes
   ```

2. **Update version**:
   ```powershell
   # For bug fixes (1.0.0 -> 1.0.1)
   echo "1.0.1" > VERSION
   
   # For new features (1.0.1 -> 1.1.0)
   echo "1.1.0" > VERSION
   
   # For breaking changes (1.1.0 -> 2.0.0)
   echo "2.0.0" > VERSION
   ```

3. **Update CHANGELOG.md**:
   ```markdown
   ## [1.1.0] - 2024-08-10
   
   ### Added
   - New PostgreSQL MCP server configuration
   - Python 3.11 support
   
   ### Changed
   - Updated Node.js to version 20.10
   - Improved Windows path handling
   
   ### Fixed
   - Fixed volume mount issues on Windows
   ```

4. **Test changes**:
   ```powershell
   # Create test project
   .\scripts\init-project.ps1 -ProjectName test-update -ProjectPath D:\temp
   
   # Open and verify
   cd D:\temp\test-update
   code .
   ```

5. **Commit changes**:
   ```powershell
   git add .
   git commit -m "feat: Add PostgreSQL support and update Node.js"
   git tag v1.1.0
   ```

## Updating Existing Projects

### Method 1: Update Script (Recommended)

```powershell
# Dry run first (see what would change)
C:\DevContainerTemplates\claude-master-template\scripts\update-project.ps1 `
    -ProjectPath D:\ClaudeProjects\my-project `
    -DryRun

# Update with backup
C:\DevContainerTemplates\claude-master-template\scripts\update-project.ps1 `
    -ProjectPath D:\ClaudeProjects\my-project `
    -Backup

# Update specific components only
C:\DevContainerTemplates\claude-master-template\scripts\update-project.ps1 `
    -ProjectPath D:\ClaudeProjects\my-project `
    -UpdateComponents devcontainer,vscode
```

### Method 2: Manual Update

For selective updates:

1. **DevContainer files**:
   ```powershell
   copy C:\DevContainerTemplates\claude-master-template\.devcontainer\* `
        D:\ClaudeProjects\my-project\.devcontainer\
   ```

2. **Scripts**:
   ```powershell
   copy C:\DevContainerTemplates\claude-master-template\scripts\* `
        D:\ClaudeProjects\my-project\scripts\
   ```

3. **VS Code settings**:
   ```powershell
   copy C:\DevContainerTemplates\claude-master-template\config\vscode-settings.json `
        D:\ClaudeProjects\my-project\.vscode\settings.json
   ```

### Method 3: Git-based Updates

If template is in Git:

```powershell
# Add template as remote
cd D:\ClaudeProjects\my-project
git remote add template https://github.com/YOUR_USERNAME/claude-devcontainer-template.git

# Fetch and merge specific files
git fetch template
git checkout template/main -- .devcontainer
git checkout template/main -- scripts
```

## Update Strategies

### Conservative (Safest)
- Only update when experiencing issues
- Update one component at a time
- Always backup first
- Test thoroughly

### Balanced (Recommended)
- Update monthly or when new features needed
- Use update script with backup
- Test in development project first
- Apply to production projects after verification

### Aggressive (Latest Features)
- Update whenever template changes
- Use CI/CD to automate updates
- Maintain staging projects for testing

## What Gets Updated

### ✅ Safe to Update
- `.devcontainer/` - DevContainer configuration
- `scripts/` - Utility scripts (except project-specific)
- `.vscode/settings.json` - VS Code settings
- `docs/TROUBLESHOOTING.md` - Documentation

### ⚠️ Review Before Updating
- `config/` - May have project customizations
- `.gitignore` - May have project-specific rules
- MCP server configurations - Check for API key changes

### ❌ Never Auto-Update
- `.env` files - Contains secrets
- `src/`, `tests/` - Your code
- `README.md`, `CLAUDE.md` - Project-specific docs
- `package.json`, `requirements.txt` - Dependencies
- `.git/` - Version control

## Tracking Updates

### In Each Project

After updating, the template version is stored in:
```
.devcontainer/TEMPLATE_VERSION
```

Check current template version:
```powershell
cat D:\ClaudeProjects\my-project\.devcontainer\TEMPLATE_VERSION
```

### Update Log

Keep track of updates:
```powershell
# Create update log
echo "$(Get-Date -Format 'yyyy-MM-dd'): Updated to template v1.1.0" >> .devcontainer\UPDATE_LOG.txt
```

## Rollback Process

If an update causes issues:

### From Backup
```powershell
# If you used -Backup flag
cd D:\ClaudeProjects\my-project
$latestBackup = Get-ChildItem -Directory ".update-backup-*" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Restore from backup
Copy-Item -Path "$latestBackup\*" -Destination . -Recurse -Force
```

### From Git
```powershell
# If you committed before updating
git log --oneline
git revert HEAD  # or specific commit
```

## Best Practices

### 1. Version Control Everything
```powershell
# Template repository
cd C:\DevContainerTemplates\claude-master-template
git add . && git commit -m "Description of changes"
git tag v1.1.0

# Project repositories  
cd D:\ClaudeProjects\my-project
git add . && git commit -m "Update DevContainer to template v1.1.0"
```

### 2. Test Update Process
Create a test project to verify updates:
```powershell
# Create test project
.\scripts\init-project.ps1 test-project -ProjectPath D:\temp

# Apply updates
.\scripts\update-project.ps1 -ProjectPath D:\temp\test-project -DryRun

# Verify in VS Code
code D:\temp\test-project
```

### 3. Document Customizations
If you customize the template for specific projects:
```markdown
# .devcontainer/CUSTOMIZATIONS.md

## Project-Specific Customizations

1. Added Redis to Docker Compose
2. Increased Node memory to 8GB
3. Custom MCP server for internal API
```

### 4. Automate Common Updates

Create `update-all-projects.ps1`:
```powershell
# Update all projects in a directory
$projectsPath = "D:\ClaudeProjects"
$templatePath = "C:\DevContainerTemplates\claude-master-template"

Get-ChildItem -Path $projectsPath -Directory | ForEach-Object {
    Write-Host "Updating $($_.Name)..." -ForegroundColor Cyan
    & "$templatePath\scripts\update-project.ps1" -ProjectPath $_.FullName -Backup
}
```

## Troubleshooting Updates

### Update Script Fails
- Check PowerShell execution policy
- Ensure paths are correct
- Run as Administrator if permission issues

### Container Won't Start After Update
1. Clear Docker cache
2. Check for syntax errors in JSON files
3. Restore from backup
4. Rebuild without cache

### Lost Customizations
- Always use `-Backup` flag
- Check `.update-backup-*` directories
- Use Git to track changes

## FAQ

**Q: How often should I update?**
A: Monthly for active projects, or when you need new features.

**Q: Can I skip versions?**
A: Yes, updates are cumulative. You can go from 1.0.0 to 1.5.0 directly.

**Q: What if I've customized my DevContainer?**
A: Use selective updates (`-UpdateComponents`) to preserve customizations.

**Q: How do I know what changed?**
A: Check CHANGELOG.md and use `-DryRun` to preview changes.

**Q: Can I automate updates?**
A: Yes, use the update script in CI/CD or scheduled tasks.

---

Remember: The goal is consistency across projects while maintaining flexibility for project-specific needs!