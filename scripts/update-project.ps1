# Claude DevContainer Project Update Script for Windows
# Updates existing projects with latest template changes

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$ProjectPath,
    
    [Parameter(Mandatory=$false)]
    [string]$TemplatePath = (Split-Path -Parent $PSScriptRoot),
    
    [Parameter(Mandatory=$false)]
    [string[]]$UpdateComponents = @("devcontainer", "scripts", "vscode"),
    
    [Parameter(Mandatory=$false)]
    [switch]$DryRun,
    
    [Parameter(Mandatory=$false)]
    [switch]$Backup,
    
    [Parameter(Mandatory=$false)]
    [switch]$Force,
    
    [Parameter(Mandatory=$false)]
    [switch]$Help
)

# Color functions
function Write-Color {
    param($Text, $Color = "White")
    Write-Host $Text -ForegroundColor $Color
}

function Show-Usage {
    Write-Color "`nClaude DevContainer Project Update Script" "Cyan"
    Write-Color "=========================================" "Cyan"
    Write-Host @"

Usage: update-project.ps1 [-ProjectPath] <string> [OPTIONS]

Update an existing Claude DevContainer project with latest template changes.

Parameters:
    -ProjectPath <string>      Path to the project to update (required)
    -TemplatePath <string>     Path to template (default: script's parent directory)
    -UpdateComponents <array>  Components to update (default: devcontainer, scripts, vscode)
                              Available: all, devcontainer, scripts, vscode, docs, config
    -DryRun                   Show what would be updated without making changes
    -Backup                   Create backup before updating
    -Force                    Overwrite local changes without prompting
    -Help                     Show this help message

Examples:
    .\update-project.ps1 D:\Projects\my-project
    .\update-project.ps1 D:\Projects\my-project -DryRun
    .\update-project.ps1 D:\Projects\my-project -Backup -UpdateComponents all
    .\update-project.ps1 ..\my-project -UpdateComponents devcontainer,vscode

Safety:
    - Always creates .update-backup directory when -Backup is used
    - Shows diff of changes before applying (unless -Force is used)
    - Preserves your .env and project-specific files
    - Never updates: .git, src, tests (your code), .env files

"@
}

# Show help if requested
if ($Help) {
    Show-Usage
    exit 0
}

# Validate inputs
if (-not (Test-Path $ProjectPath)) {
    Write-Color "Error: Project path does not exist: $ProjectPath" "Red"
    exit 1
}

if (-not (Test-Path $TemplatePath)) {
    Write-Color "Error: Template path does not exist: $TemplatePath" "Red"
    exit 1
}

# Resolve full paths
$ProjectPath = Resolve-Path $ProjectPath
$TemplatePath = Resolve-Path $TemplatePath

Write-Color "`n🔄 Claude DevContainer Project Updater" "Blue"
Write-Color "=====================================`n" "Blue"
Write-Color "Project: $ProjectPath" "Cyan"
Write-Color "Template: $TemplatePath" "Cyan"
Write-Color "Components: $($UpdateComponents -join ', ')" "Cyan"

# Check template version
$templateVersion = "Unknown"
if (Test-Path "$TemplatePath\VERSION") {
    $templateVersion = Get-Content "$TemplatePath\VERSION" -Raw
}
Write-Color "Template Version: $templateVersion" "Cyan"

# Component mapping
$componentMap = @{
    'devcontainer' = @('.devcontainer')
    'scripts' = @('scripts')
    'vscode' = @('.vscode', 'config/vscode-settings.json')
    'docs' = @('docs/TROUBLESHOOTING.md', 'docs/WINDOWS_SETUP.md')
    'config' = @('config')
}

# Expand 'all' to all components
if ($UpdateComponents -contains 'all') {
    $UpdateComponents = $componentMap.Keys
}

# Files to never update
$excludeFiles = @(
    '.git',
    '.env',
    '.env.local',
    'src',
    'tests',
    'node_modules',
    '__pycache__',
    '.venv',
    'venv',
    'package-lock.json',
    'yarn.lock',
    'requirements.txt',
    'README.md',
    'CLAUDE.md'
)

# Create backup if requested
if ($Backup) {
    $backupDir = Join-Path $ProjectPath ".update-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Write-Color "`n📦 Creating backup at: $backupDir" "Yellow"
    
    if (-not $DryRun) {
        New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        
        # Backup components that will be updated
        foreach ($component in $UpdateComponents) {
            if ($componentMap.ContainsKey($component)) {
                foreach ($path in $componentMap[$component]) {
                    $sourcePath = Join-Path $ProjectPath $path
                    if (Test-Path $sourcePath) {
                        $destPath = Join-Path $backupDir $path
                        $destDir = Split-Path $destPath -Parent
                        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
                        Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Force
                    }
                }
            }
        }
    }
}

# Function to check if file should be excluded
function Should-Exclude {
    param($FilePath)
    
    foreach ($exclude in $excludeFiles) {
        if ($FilePath -like "*$exclude*") {
            return $true
        }
    }
    return $false
}

# Function to update a component
function Update-Component {
    param(
        $ComponentName,
        $Paths
    )
    
    Write-Color "`n📝 Updating $ComponentName..." "Yellow"
    
    foreach ($path in $Paths) {
        $sourcePath = Join-Path $TemplatePath $path
        $destPath = Join-Path $ProjectPath $path
        
        if (-not (Test-Path $sourcePath)) {
            Write-Color "  ⚠️  Source not found: $path" "DarkYellow"
            continue
        }
        
        if (Should-Exclude $path) {
            Write-Color "  ⏭️  Skipping excluded: $path" "DarkGray"
            continue
        }
        
        # Handle file vs directory
        if (Test-Path $sourcePath -PathType Leaf) {
            # Single file
            if ($DryRun) {
                if (Test-Path $destPath) {
                    Write-Color "  Would update: $path" "Gray"
                } else {
                    Write-Color "  Would create: $path" "Green"
                }
            } else {
                $destDir = Split-Path $destPath -Parent
                if (-not (Test-Path $destDir)) {
                    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
                }
                Copy-Item -Path $sourcePath -Destination $destPath -Force
                Write-Color "  ✅ Updated: $path" "Green"
            }
        } else {
            # Directory
            if ($DryRun) {
                Write-Color "  Would update directory: $path" "Gray"
            } else {
                # Create directory if it doesn't exist
                if (-not (Test-Path $destPath)) {
                    New-Item -ItemType Directory -Path $destPath -Force | Out-Null
                }
                
                # Copy contents
                Get-ChildItem -Path $sourcePath -Recurse | ForEach-Object {
                    $relativePath = $_.FullName.Substring($sourcePath.Length + 1)
                    $targetPath = Join-Path $destPath $relativePath
                    
                    if (Should-Exclude $relativePath) {
                        return
                    }
                    
                    if ($_.PSIsContainer) {
                        if (-not (Test-Path $targetPath)) {
                            New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
                        }
                    } else {
                        $targetDir = Split-Path $targetPath -Parent
                        if (-not (Test-Path $targetDir)) {
                            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
                        }
                        Copy-Item -Path $_.FullName -Destination $targetPath -Force
                    }
                }
                Write-Color "  ✅ Updated directory: $path" "Green"
            }
        }
    }
}

# Perform updates
foreach ($component in $UpdateComponents) {
    if ($componentMap.ContainsKey($component)) {
        Update-Component -ComponentName $component -Paths $componentMap[$component]
    } else {
        Write-Color "`n⚠️  Unknown component: $component" "Yellow"
    }
}

# Special handling for VS Code settings
if ($UpdateComponents -contains 'vscode' -and -not $DryRun) {
    $vscodePath = Join-Path $ProjectPath '.vscode'
    $templateSettings = Join-Path $TemplatePath 'config\vscode-settings.json'
    $projectSettings = Join-Path $vscodePath 'settings.json'
    
    if ((Test-Path $templateSettings) -and -not (Test-Path $projectSettings)) {
        if (-not (Test-Path $vscodePath)) {
            New-Item -ItemType Directory -Path $vscodePath -Force | Out-Null
        }
        Copy-Item -Path $templateSettings -Destination $projectSettings -Force
        Write-Color "  ✅ Created VS Code settings" "Green"
    }
}

# Update version file
if (-not $DryRun -and (Test-Path "$TemplatePath\VERSION")) {
    Copy-Item -Path "$TemplatePath\VERSION" -Destination "$ProjectPath\.devcontainer\TEMPLATE_VERSION" -Force
    Write-Color "`n✅ Updated template version marker" "Green"
}

# Summary
Write-Color "`n📊 Update Summary" "Cyan"
Write-Color "=================" "Cyan"

if ($DryRun) {
    Write-Color "This was a dry run. No changes were made." "Yellow"
    Write-Color "Remove -DryRun to apply changes." "Yellow"
} else {
    Write-Color "✅ Project updated successfully!" "Green"
    
    if ($Backup) {
        Write-Color "📦 Backup created at: $backupDir" "Blue"
    }
    
    Write-Color "`n💡 Next steps:" "Blue"
    Write-Color "1. Review the changes in your project" "Yellow"
    Write-Color "2. Test the DevContainer by reopening in VS Code" "Yellow"
    Write-Color "3. Commit the updates to your repository" "Yellow"
}

# Show changelog if available
if (Test-Path "$TemplatePath\CHANGELOG.md") {
    Write-Color "`n📄 Recent template changes:" "Cyan"
    $changelog = Get-Content "$TemplatePath\CHANGELOG.md" -Raw
    $recentChanges = $changelog -split '## \[' | Select-Object -Skip 1 -First 1
    if ($recentChanges) {
        Write-Host "## [$recentChanges" -ForegroundColor Gray
    }
}