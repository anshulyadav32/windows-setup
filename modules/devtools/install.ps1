# modules/devtools/install.ps1
# Additional Developer Tools Installation Script
# This script installs supplementary AI and development tools

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
