# modules/devtools/install.ps1
# Additional Developer Tools Installation Script
# This script installs supplementary AI and development tools

# =========================================
# ENCODING SELF-CHECK
# =========================================
$scriptPath = $MyInvocation.MyCommand.Path
$bytes = Get-Content -Path $scriptPath -Encoding Byte -TotalCount 3
if (($bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) -or
    ($bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE) -or
    ($bytes[0] -eq 0xFE -and $bytes[1] -eq 0xFF)) {

    Write-Host "[WARNING] Script is saved with BOM/UTF-16 encoding. Fixing to UTF-8 without BOM..." -ForegroundColor Yellow
    
    # Convert to UTF-8 no BOM
    $fixedPath = "$scriptPath.fixed"
    Get-Content $scriptPath | Set-Content -Encoding UTF8 $fixedPath
    Write-Host "[SUCCESS] Saved clean version: $fixedPath" -ForegroundColor Green

    # Auto-relaunch the fixed script
    Write-Host "[INFO] Auto-relaunching the fixed script..." -ForegroundColor Cyan
    $fixedFileName = [System.IO.Path]::GetFileName($fixedPath)
    $currentDir = Split-Path -Parent $scriptPath
    
    # Construct and execute the command to run the fixed script
    $command = "cd '$currentDir'; & '.\\$fixedFileName' $args"
    Write-Host "Executing: $command" -ForegroundColor DarkGray
    
    # Start a new PowerShell process with the fixed script
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command $command"
    exit 0
}

Write-Host "[OK] DevTools install script started with correct encoding (UTF-8 no BOM)." -ForegroundColor Cyan
Write-Host "=== Starting Additional Developer Tools Installation ===" -ForegroundColor Cyan

# Install ChatGit CLI (if available)
if (-Not (Get-Command chatgit -ErrorAction SilentlyContinue)) {
    Write-Host "Installing ChatGit CLI..." -ForegroundColor Yellow
    npm install -g chatgit
    if (Get-Command chatgit -ErrorAction SilentlyContinue) {
        Write-Host "ChatGit CLI installed successfully." -ForegroundColor Green
    } else {
        Write-Host "ChatGit CLI installation may need verification." -ForegroundColor Yellow
    }
} else {
    Write-Host "ChatGit CLI already installed." -ForegroundColor Green
}
Write-Host "[Checkpoint] ChatGit installation step complete." -ForegroundColor Magenta

# Install NOI CLI (if available)
if (-Not (Get-Command noi -ErrorAction SilentlyContinue)) {
    Write-Host "Installing NOI CLI..." -ForegroundColor Yellow
    npm install -g noi
    if (Get-Command noi -ErrorAction SilentlyContinue) {
        Write-Host "NOI CLI installed successfully." -ForegroundColor Green
    } else {
        Write-Host "NOI CLI installation may need verification." -ForegroundColor Yellow
    }
} else {
    Write-Host "NOI CLI already installed." -ForegroundColor Green
}
Write-Host "[Checkpoint] NOI CLI installation step complete." -ForegroundColor Magenta

# Install ChatGPT CLI (if available)
if (-Not (Get-Command chatgpt -ErrorAction SilentlyContinue)) {
    Write-Host "Installing ChatGPT CLI..." -ForegroundColor Yellow
    npm install -g chatgpt-cli
    if (Get-Command chatgpt -ErrorAction SilentlyContinue) {
        Write-Host "ChatGPT CLI installed successfully." -ForegroundColor Green
    } else {
        Write-Host "ChatGPT CLI installation may need verification." -ForegroundColor Yellow
    }
} else {
    Write-Host "ChatGPT CLI already installed." -ForegroundColor Green
}
Write-Host "[Checkpoint] ChatGPT CLI installation step complete." -ForegroundColor Magenta

# Note: WinGet and PowerToys are now handled by the main install.ps1 script

Write-Host "=== Additional Developer Tools Installation Complete ===" -ForegroundColor Cyan
