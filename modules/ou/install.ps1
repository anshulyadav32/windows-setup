# install.ps1
# This script installs Node.js LTS and npm, then installs Gemini CLI and Codex CLI globally

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

Write-Host "[OK] OU install script started with correct encoding (UTF-8 no BOM)." -ForegroundColor Cyan

choco install nodejs-lts -y
$env:Path += ";$($env:ProgramFiles)\nodejs"

npm install -g @google/generative-ai-cli
npm install -g codex-cli

Write-Host "Node.js, npm, Gemini CLI, and Codex CLI installed successfully."
