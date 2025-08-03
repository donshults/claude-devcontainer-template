@echo off
REM Claude DevContainer Project Initialization Script for Windows
REM Batch file wrapper for PowerShell script

REM Check if project name was provided
if "%~1"=="" (
    echo Error: Project name is required
    echo.
    echo Usage: init-project.bat PROJECT_NAME [OPTIONS]
    echo.
    echo Examples:
    echo   init-project.bat my-project
    echo   init-project.bat my-project -CreateGitHub
    echo   init-project.bat my-project -ProjectPath D:\Projects
    echo.
    echo For more options, run: powershell -File "%~dp0init-project.ps1" -Help
    exit /b 1
)

REM Run the PowerShell script with all arguments
powershell -ExecutionPolicy Bypass -File "%~dp0init-project.ps1" %*