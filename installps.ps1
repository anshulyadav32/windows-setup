# installps.ps1
# Windows Development Environment Setup Script
# Run this script in PowerShell as Administrator
#
# Quick install command:
# iwr -useb https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/installps.ps1 | iex
# OR
# Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/installps.ps1 | Invoke-Expression

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
Write-Host "[Checkpoint] Chocolatey installation step complete." -ForegroundColor Magenta

# Refresh environment
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
Write-Host "[Checkpoint] Environment refreshed." -ForegroundColor Magenta

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
    
    # Wait for installation to complete
    Start-Sleep -Seconds 2
    
    # Check specific commands for each package
    $success = $false
    switch ($pkg) {
        "git" { $success = (Get-Command git -ErrorAction SilentlyContinue) -ne $null }
        "gh" { $success = (Get-Command gh -ErrorAction SilentlyContinue) -ne $null }
        "vscode" { $success = (Get-Command code -ErrorAction SilentlyContinue) -ne $null }
        "googlechrome" { $success = Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe" }
        "nodejs-lts" { $success = (Get-Command node -ErrorAction SilentlyContinue) -ne $null }
        "python" { $success = (Get-Command python -ErrorAction SilentlyContinue) -ne $null }
        "postgresql" { $success = (Get-Command psql -ErrorAction SilentlyContinue) -ne $null }
        "microsoft-windows-terminal" { $success = (Get-Command wt -ErrorAction SilentlyContinue) -ne $null }
        default { $success = (Get-Command $pkg -ErrorAction SilentlyContinue) -ne $null }
    }
    
    if ($success) {
        Write-Host "[Checkpoint] $pkg installed successfully." -ForegroundColor Magenta
    } else {
        Write-Host "[Checkpoint] $pkg installation may need verification." -ForegroundColor Yellow
    }
}
Write-Host "[Checkpoint] All main packages installation step complete." -ForegroundColor Magenta

# Install Gemini CLI (Google AI)
if (-Not (Get-Command gemini -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Gemini CLI..." -ForegroundColor Yellow
    if ((Get-Command npm -ErrorAction SilentlyContinue) -and (Get-Command node -ErrorAction SilentlyContinue)) {
        npm install -g @google/generative-ai-cli
        if (Get-Command gemini -ErrorAction SilentlyContinue) {
            Write-Host "[Checkpoint] Gemini CLI installed successfully." -ForegroundColor Magenta
        } else {
            Write-Host "[Checkpoint] Gemini CLI installation failed or not found." -ForegroundColor Red
        }
    } else {
        Write-Host "npm or node not found. Please restart PowerShell or run 'refreshenv' and try again." -ForegroundColor Red
    }
}

# Install Codex CLI (OpenAI or custom CLI)
if (-Not (Get-Command codex -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Codex CLI..." -ForegroundColor Yellow
    if ((Get-Command npm -ErrorAction SilentlyContinue) -and (Get-Command node -ErrorAction SilentlyContinue)) {
        npm install -g codex-cli
        if (Get-Command codex -ErrorAction SilentlyContinue) {
            Write-Host "[Checkpoint] Codex CLI installed successfully." -ForegroundColor Magenta
        } else {
            Write-Host "[Checkpoint] Codex CLI installation failed or not found." -ForegroundColor Red
        }
    } else {
        Write-Host "npm or node not found. Please restart PowerShell or run 'refreshenv' and try again." -ForegroundColor Red
    }
}

Write-Host "=== Windows Dev Setup Complete ===" -ForegroundColor Cyan
Write-Host "Please restart your terminal or system for all changes to take effect." -ForegroundColor Yellow
