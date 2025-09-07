# deploy.ps1
# Deployment script for win.r-u.live

# =========================================
# ENCODING SELF-CHECK
# =========================================
# Check if script is run from a file (not via Invoke-Expression)
$scriptPath = $MyInvocation.MyCommand.Path
if ($scriptPath) {
    try {
        $bytes = Get-Content -Path $scriptPath -Encoding Byte -TotalCount 3 -ErrorAction Stop
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
        Write-Host "[OK] Deploy script started with correct encoding (UTF-8 no BOM)." -ForegroundColor Cyan
    }
    catch {
        Write-Host "[NOTE] Skipping encoding check (unable to read file bytes)." -ForegroundColor Yellow
    }
}
else {
    Write-Host "[NOTE] Skipping encoding check (script not running from file)." -ForegroundColor Yellow
}
Write-Host "=== Starting Deployment Process ===" -ForegroundColor Cyan

# Deployment logic will go here
Write-Host "Deployment placeholder - implementation pending" -ForegroundColor Yellow
