# setup.ps1
# Windows & WSL Development Environment Combined Setup Script
# Run this script in PowerShell as Administrator
#
# Quick install command:
# iwr -useb https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/setup.ps1 | iex
# OR
# Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/setup.ps1 | Invoke-Expression

# Clear console for better UX
Clear-Host

# ASCII Art Banner
$banner = @"
 __        ___           _                   ____       _               
 \ \      / (_)_ __   __| | _____      _____/ ___|  ___| |_ _   _ _ __  
  \ \ /\ / /| | '_ \ / _` |/ _ \ \ /\ / / __\___ \ / _ \ __| | | | '_ \ 
   \ V  V / | | | | | (_| | (_) \ V  V /\__ \___) |  __/ |_| |_| | |_) |
    \_/\_/  |_|_| |_|\__,_|\___/ \_/\_/ |___/____/ \___|\__|\__,_| .__/ 
                                                                 |_|    
    Developer Environment Setup Tool - https://win.r-u.live
"@

Write-Host $banner -ForegroundColor Cyan

# Ensure script is run as Administrator
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Please run this script as Administrator!"
    Exit 1
}

# Function to show menu and get selection
function Show-Menu {
    Write-Host "`n📦 Installation Options:" -ForegroundColor Yellow
    Write-Host "1) 💻 Windows Developer Tools (VS Code, Git, Node.js, etc.)" -ForegroundColor Green
    Write-Host "2) 🐧 WSL2 with Ubuntu + Developer Tools" -ForegroundColor Green
    Write-Host "3) 🔧 Additional Dev Tools (ChatGit, NOI CLI, etc.)" -ForegroundColor Green
    Write-Host "4) ⭐ Install Everything (Complete Setup)" -ForegroundColor Cyan
    Write-Host "5) ❌ Exit" -ForegroundColor Red
    
    $selection = Read-Host "`nEnter your choice (1-5)"
    return $selection
}

# Function to run the Windows setup script
function Install-WindowsTools {
    Write-Host "`n=== Starting Windows Developer Tools Installation ===" -ForegroundColor Cyan
    
    try {
        # Run the Windows setup script using direct invocation
        & "$PSScriptRoot\installps.ps1"
    }
    catch {
        Write-Host "Error running Windows installation script: $_" -ForegroundColor Red
    }
    
    Write-Host "=== Windows Developer Tools Installation Complete ===" -ForegroundColor Cyan
}

# Function to run the WSL setup script
function Install-WSLUbuntu {
    Write-Host "`n=== Starting WSL2 with Ubuntu Installation ===" -ForegroundColor Cyan
    
    try {
        # Run the WSL setup script using direct invocation
        & "$PSScriptRoot\wsl.ps1"
    }
    catch {
        Write-Host "Error running WSL installation script: $_" -ForegroundColor Red
    }
    
    Write-Host "=== WSL2 with Ubuntu Installation Complete ===" -ForegroundColor Cyan
}

# Function to run the additional dev tools script
function Install-AdditionalTools {
    Write-Host "`n=== Installing Additional Developer Tools ===" -ForegroundColor Cyan
    
    try {
        # Run the dev tools script using direct invocation
        & "$PSScriptRoot\modules\devtools\install.ps1"
    }
    catch {
        Write-Host "Error running additional tools installation script: $_" -ForegroundColor Red
    }
    
    Write-Host "=== Additional Developer Tools Installation Complete ===" -ForegroundColor Cyan
}
# Main execution
$choice = Show-Menu

switch ($choice) {
    "1" {
        Install-WindowsTools
    }
    "2" {
        Install-WSLUbuntu
    }
    "3" {
        Install-AdditionalTools
    }
    "4" {
        Write-Host "`n=== Starting Complete Installation (Windows + WSL + Additional Tools) ===" -ForegroundColor Cyan
        Install-WindowsTools
        Install-WSLUbuntu
        Install-AdditionalTools
        Write-Host "`n=== Complete Installation Finished! ===" -ForegroundColor Cyan
    }
    "5" {
        Write-Host "`nExiting setup. No changes were made." -ForegroundColor Yellow
        Exit 0
    }
    default {
        Write-Host "`nInvalid selection. Please run the script again and select a valid option." -ForegroundColor Red
        Exit 1
    }
}

# Final instructions
Write-Host "`n📋 Setup complete! Here's what to do next:" -ForegroundColor Yellow
Write-Host "• Restart your computer to ensure all changes take effect" -ForegroundColor White
Write-Host "• Check out the website at https://win.r-u.live for more information" -ForegroundColor White
Write-Host "• Visit our GitHub repository at https://github.com/anshulyadav32/windows-setup for updates" -ForegroundColor White
Write-Host "`n🎉 Happy coding!" -ForegroundColor Cyan

foreach ($tool in $testTools) {
    $found = $false
    if ($tool.Command) {
        $found = (Get-Command $tool.Command -ErrorAction SilentlyContinue) -ne $null
    } elseif ($tool.Path) {
        $found = Test-Path $tool.Path
    }
    
    if ($found) {
        Write-Host "$($tool.Name): OK" -ForegroundColor Green
    } else {
        Write-Host "$($tool.Name): NOT FOUND" -ForegroundColor Red
    }
}
