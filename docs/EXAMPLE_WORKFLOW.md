# Example Workflow: Creating Multiple Projects

This guide demonstrates how to create and manage multiple Claude DevContainer projects using the master template.

## Scenario: Building a Trading Platform

Let's create three related projects:
1. Trading Strategy Bot
2. Market Data API
3. Web Dashboard

## Step 1: Set Up Master Template

```powershell
# Extract template to permanent location
cd C:\DevContainerTemplates
# Extract claude-devcontainer-master-template.tar.gz here
```

## Step 2: Create Project Structure

```powershell
# Create main projects directory
cd D:\
mkdir ClaudeProjects\TradingPlatform
cd ClaudeProjects\TradingPlatform
```

## Step 3: Create Trading Bot Project

```powershell
# Create the project
C:\DevContainerTemplates\claude-master-template\scripts\init-project.ps1 `
    -ProjectName trading-bot `
    -CreateGitHub

# Navigate to project
cd trading-bot

# Set up environment
copy .env.example .env
notepad .env  # Add your API keys

# Open in VS Code
code .
```

When VS Code opens:
1. Click "Reopen in Container" when prompted
2. Wait for container to build
3. In the container terminal:
   ```bash
   # Verify setup
   claude --version
   python tests/test_setup.py
   
   # Start developing
   mkdir src/strategies
   touch src/strategies/momentum.py
   ```

## Step 4: Create Market Data API Project

```powershell
# Go back to platform directory
cd ..

# Create API project
C:\DevContainerTemplates\claude-master-template\scripts\init-project.ps1 `
    -ProjectName market-data-api `
    -CreateGitHub

# Set up
cd market-data-api
copy .env.example .env
notepad .env

# Add API-specific dependencies to .env
# POLYGON_API_KEY=your_key_here
# ALPHA_VANTAGE_KEY=your_key_here

# Open in VS Code (new window)
code .
```

## Step 5: Create Web Dashboard Project

```powershell
# Go back to platform directory
cd ..

# Create dashboard project
C:\DevContainerTemplates\claude-master-template\scripts\init-project.ps1 `
    -ProjectName trading-dashboard `
    -CreateGitHub `
    -PublicRepo  # Make this one public

# Set up
cd trading-dashboard
copy .env.example .env
notepad .env

# Open in VS Code (new window)
code .
```

## Step 6: Working Across Projects

Now you have three VS Code windows, each with its own Dev Container:

### Window 1: Trading Bot
```bash
# In container terminal
cd /workspace
npm init -y
npm install axios dotenv
python -m venv venv
source venv/bin/activate
pip install pandas numpy requests
```

### Window 2: Market Data API
```bash
# In container terminal
cd /workspace
npm init -y
npm install express cors dotenv
npm install -D nodemon
# Update package.json scripts
```

### Window 3: Trading Dashboard
```bash
# In container terminal
cd /workspace
npx create-react-app . --template typescript
npm install axios recharts
npm start
```

## Step 7: Shared Configuration

Each project can have its own MCP servers. For example:

### Trading Bot (.devcontainer/devcontainer.json)
```json
"mcpServers": {
  "filesystem": { ... },
  "memory": { ... },
  "github": { ... },
  "airtable": {
    "command": "npx",
    "args": ["-y", "airtable-mcp-server"],
    "env": {
      "AIRTABLE_API_KEY": "${localEnv:AIRTABLE_API_KEY}"
    }
  }
}
```

### Market Data API (.devcontainer/devcontainer.json)
```json
"mcpServers": {
  "filesystem": { ... },
  "memory": { ... },
  "github": { ... },
  "postgres": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-postgres", "${localEnv:DATABASE_URL}"]
  }
}
```

## Step 8: Cross-Project Communication

Since each container is isolated, use these methods to communicate:

1. **Shared Database**: Point both to same PostgreSQL instance
2. **API Calls**: Dashboard calls Market Data API
3. **Message Queue**: Use Redis or RabbitMQ
4. **Shared Volume**: Mount same directory in multiple containers

## Directory Structure After Setup

```
D:\ClaudeProjects\TradingPlatform\
├── trading-bot\
│   ├── .devcontainer\
│   ├── .git\
│   ├── src\
│   │   ├── strategies\
│   │   │   ├── momentum.py
│   │   │   └── mean_reversion.py
│   │   └── utils\
│   ├── tests\
│   ├── .env
│   └── README.md
│
├── market-data-api\
│   ├── .devcontainer\
│   ├── .git\
│   ├── src\
│   │   ├── routes\
│   │   ├── services\
│   │   └── index.js
│   ├── tests\
│   ├── .env
│   └── package.json
│
└── trading-dashboard\
    ├── .devcontainer\
    ├── .git\
    ├── public\
    ├── src\
    │   ├── components\
    │   ├── pages\
    │   └── App.tsx
    ├── .env
    └── package.json
```

## Tips for Multi-Project Development

### 1. Use Workspace Files
Create `TradingPlatform.code-workspace`:
```json
{
  "folders": [
    { "path": "trading-bot" },
    { "path": "market-data-api" },
    { "path": "trading-dashboard" }
  ],
  "settings": {
    "editor.formatOnSave": true
  }
}
```

### 2. Shared Scripts
Create a shared scripts repository:
```powershell
C:\DevContainerTemplates\claude-master-template\scripts\init-project.ps1 `
    -ProjectName shared-scripts `
    -CreateGitHub
```

### 3. Environment Management
Keep a secure backup of all `.env` files:
```
D:\ClaudeProjects\env-backups\
├── trading-bot.env
├── market-data-api.env
└── trading-dashboard.env
```

### 4. Regular Updates
```powershell
# Update all projects
Get-ChildItem -Directory | ForEach-Object {
    Push-Location $_
    git pull
    Pop-Location
}
```

## Advantages of This Approach

1. **Isolation**: Each project has its own dependencies
2. **Consistency**: All use the same base environment
3. **Flexibility**: Different MCP servers per project
4. **Scalability**: Easy to add new projects
5. **Maintainability**: Update template once, apply everywhere

## Next Steps

1. Customize each project's Dev Container as needed
2. Set up CI/CD for each repository
3. Create docker-compose for local integration testing
4. Document inter-project dependencies
5. Build something amazing!

This workflow gives you the flexibility of separate projects with the consistency of a shared template!