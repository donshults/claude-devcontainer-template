# Troubleshooting Guide

## Common Dev Container Issues

### Container Build Failures

#### Error: "Exit code 1" when opening in VS Code

**Symptoms:**
- Container fails to build with exit code 1
- Error mentions devContainersSpecCLI.js

**Solutions:**

1. **Simplify the configuration** (Already done in this template):
   - Reduced Docker capabilities
   - Simplified volume mounts
   - Made MCP servers optional
   - Fixed UID/GID to 1000 (standard)

2. **Check Docker Desktop**:
   ```bash
   # Ensure Docker is running
   docker version
   
   # Clear Docker cache
   docker system prune -a
   ```

3. **Rebuild without cache**:
   - VS Code: F1 → "Dev Containers: Rebuild Container Without Cache"

4. **Check your .env file**:
   - Ensure no syntax errors
   - No spaces around = signs
   - No trailing spaces

### Platform-Specific Issues

#### Windows

1. **Line ending issues**:
   - Ensure Git is configured for LF line endings:
   ```bash
   git config --global core.autocrlf input
   ```

2. **Path issues**:
   - Use forward slashes in paths
   - Avoid spaces in project paths if possible

3. **Docker Desktop settings**:
   - Ensure WSL2 backend is enabled
   - Check resource limits (memory/CPU)

#### macOS

1. **File sharing**:
   - Docker Desktop → Preferences → Resources → File Sharing
   - Ensure your project directory is shared

2. **Performance**:
   - Use `:cached` mount consistency (already configured)

### MCP Server Issues

#### Servers not starting

1. **Check environment variables**:
   ```bash
   # Inside container
   echo $GITHUB_PERSONAL_ACCESS_TOKEN
   ```

2. **Verify MCP installation**:
   ```bash
   # Inside container
   claude mcp list
   ```

3. **Enable only needed servers**:
   - Comment out unused servers in devcontainer.json
   - Start with just filesystem and memory servers

### Permission Issues

#### Files created as root

**Solution**: The template uses a non-root user (developer) with UID/GID 1000.

If you still have issues:
```bash
# On host machine
echo "USER_UID=$(id -u)" >> .env
echo "USER_GID=$(id -g)" >> .env
```

Then update devcontainer.json:
```json
"USER_UID": "${localEnv:USER_UID:1000}",
"USER_GID": "${localEnv:USER_GID:1000}"
```

### Network Issues

#### Cannot connect to external services

1. **Firewall/Proxy**:
   - Check corporate firewall settings
   - Configure proxy in Docker Desktop

2. **DNS issues**:
   ```bash
   # Inside container
   nslookup github.com
   ```

### Quick Fixes

1. **Complete reset**:
   ```bash
   # Remove all containers and volumes
   docker system prune -a --volumes
   
   # Remove VS Code server
   rm -rf ~/.vscode-server
   ```

2. **Minimal configuration test**:
   Create a minimal devcontainer.json:
   ```json
   {
     "name": "Test",
     "image": "mcr.microsoft.com/devcontainers/base:ubuntu"
   }
   ```

3. **Check logs**:
   ```bash
   # VS Code Output panel → "Dev Containers"
   # Docker Desktop → Containers → Logs
   ```

## Getting Help

1. **VS Code Dev Containers Documentation**:
   https://code.visualstudio.com/docs/devcontainers/containers

2. **Claude Code Documentation**:
   https://docs.anthropic.com/en/docs/claude-code

3. **Report Issues**:
   - Template issues: Create issue in template repository
   - Claude Code issues: https://github.com/anthropics/claude-code/issues

## Validation Script

Run this script to check your environment:

```bash
python3 tests/test_setup.py
```

This will verify:
- Required tools are installed
- Environment variables are set
- Container is properly configured