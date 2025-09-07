# setup.ps1
# Windows Development Environment Setup Script
# Run this script in PowerShell as Administrator

Write-Host "=== Starting Windows Dev Setup ===" -ForegroundColor Cyan

# Ensure script is run as Administrator
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Please run this script as Administrator!"
    Exit 1
}

# Install Chocolatey
if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey already installed." -ForegroundColor Green
}

# Refresh environment
refreshenv

# Install packages via choco
$packages = @(
    "git",
    "gh",                 # GitHub CLI
    "vscode",             # Visual Studio Code
    "googlechrome",       # Chrome
    "nodejs-lts",         # Node.js (LTS version)
    "python",             # Python
    "postgresql",         # PostgreSQL (includes psql)
    "microsoft-windows-terminal" # Windows Terminal
)

foreach ($pkg in $packages) {
    Write-Host "Installing $pkg ..." -ForegroundColor Yellow
    choco install $pkg -y --force
}

# Install Gemini CLI (Google AI)
if (-Not (Get-Command gemini -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Gemini CLI..." -ForegroundColor Yellow
    npm install -g @google/generative-ai-cli
}

# Install Codex CLI (OpenAI or custom CLI)
if (-Not (Get-Command codex -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Codex CLI..." -ForegroundColor Yellow
    npm install -g codex-cli
}

Write-Host "=== Installation Complete ===" -ForegroundColor Green
Write-Host "Restart PowerShell or run 'refreshenv' for changes to take effect." -ForegroundColor Cyan
