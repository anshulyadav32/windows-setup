# wsl-kal-kex.ps1
# This script installs and launches Kex (Kali Linux desktop environment) in WSL

# Check if WSL is installed
if (-not (Get-Command wsl.exe -ErrorAction SilentlyContinue)) {
    Write-Error "WSL is not installed. Please install WSL first."
    exit 1
}

# Check if Kali is installed
$kaliInstalled = wsl.exe -l -q | Select-String -Pattern "kali-linux"
if (-not $kaliInstalled) {
    Write-Error "Kali Linux is not installed in WSL. Please install it from the Microsoft Store or with 'wsl --install -d kali-linux'."
    exit 1
}

Write-Host "Updating Kali and installing kex..."
# Update Kali and install kex
wsl.exe -d kali-linux -- bash -c "sudo apt update && sudo apt upgrade -y && sudo apt install -y kali-win-kex"

Write-Host "Kex installed. To launch Kex, run the following command:"
Write-Host "wsl.exe -d kali-linux -- kex"

# Optionally, launch Kex automatically
$launch = Read-Host "Do you want to launch Kex now? (y/n)"
if ($launch -eq "y") {
    wsl.exe -d kali-linux -- kex
} else {
    Write-Host "You can launch Kex later with: wsl.exe -d kali-linux -- kex"
}
