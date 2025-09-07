# installps.ps1
# PowerShell modules installation script

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

Write-Host "[OK] PowerShell module installation script started with correct encoding (UTF-8 no BOM)." -ForegroundColor Cyan
Write-Host "=== Starting PowerShell Module Installation ===" -ForegroundColor Cyan

# Install useful PowerShell modules
Write-Host "Installing PowerShell modules..." -ForegroundColor Yellow

# List of modules to install
$modules = @(
    "PSReadLine", 
    "posh-git",
    "Terminal-Icons"
)

foreach ($module in $modules) {
    if (!(Get-Module -ListAvailable -Name $module)) {
        Write-Host "Installing $module module..." -ForegroundColor Cyan
        Install-Module -Name $module -Force -Scope CurrentUser
        Write-Host "$module installed!" -ForegroundColor Green
    } else {
        Write-Host "$module is already installed." -ForegroundColor Green
    }
}
