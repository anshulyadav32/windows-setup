# Ensure running as Administrator
function Test-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Admin)) {
    Write-Host "Script is not running as Administrator. Relaunching with elevation..." -ForegroundColor Yellow
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = 'powershell.exe'
    $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    $psi.Verb = 'runas'
    try {
        [System.Diagnostics.Process]::Start($psi) | Out-Null
    } catch {
        Write-Error "Failed to relaunch as administrator. Please run this script as Administrator."
    }
    exit
}

# wsl-kal-kex.ps1
# One-command WSL, Kali, and Kex installer for Windows
# Usage:
#   iwr -useb https://win.r-u.live/ps/wsl-kal-kex.ps1 | iex

Write-Host "[WSL-Kali-Kex] Starting full setup..." -ForegroundColor Cyan

# 1. Install WSL if missing
if (-not (Get-Command wsl.exe -ErrorAction SilentlyContinue)) {
    Write-Host "WSL not found. Installing WSL..." -ForegroundColor Yellow
    wsl --install
    Write-Host "WSL installed. Please restart your computer and re-run this script." -ForegroundColor Green
    exit 0
}

# 2. Enable WSL2 and Virtual Machine Platform if needed
$wslFeature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
$vmFeature = Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
if ($wslFeature.State -ne 'Enabled') {
    Write-Host "Enabling WSL feature..." -ForegroundColor Yellow
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
}
if ($vmFeature.State -ne 'Enabled') {
    Write-Host "Enabling Virtual Machine Platform feature..." -ForegroundColor Yellow
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
}

# 3. Install Kali Linux if missing
$kaliInstalled = wsl.exe -l -q | Select-String -Pattern "kali-linux"
if (-not $kaliInstalled) {
    Write-Host "Kali Linux not found. Installing Kali Linux..." -ForegroundColor Yellow
    wsl --install -d kali-linux
    Write-Host "Kali Linux installed. Please launch Kali from the Start Menu once to finish setup, then re-run this script." -ForegroundColor Green
    exit 0
}

# 4. Install Kex in Kali
Write-Host "Updating Kali and installing Kex..." -ForegroundColor Cyan
wsl.exe -d kali-linux -- bash -c "sudo apt update && sudo apt upgrade -y && sudo apt install -y kali-win-kex"

Write-Host "Kex installed! You can launch the Kali desktop with:" -ForegroundColor Green
Write-Host "wsl.exe -d kali-linux -- kex" -ForegroundColor Magenta

# 5. Optionally launch Kex now
$launch = Read-Host "Do you want to launch Kex now? (y/n)"
if ($launch -eq "y") {
    wsl.exe -d kali-linux -- kex
} else {
    Write-Host "You can launch Kex later with: wsl.exe -d kali-linux -- kex" -ForegroundColor Cyan
}
