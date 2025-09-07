# setup.ps1
# Windows & WSL Development Environment Combined Setup Script
# This script will automatically elevate to admin permissions if needed
#
# Quick install command:
# iwr -useb https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/setup.ps1 | iex
# OR
# Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/setup.ps1 | Invoke-Expression
#
# To install all components without prompts:
# iwr -useb https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/setup.ps1 | iex -InstallAll
# OR
# powershell -ExecutionPolicy Bypass -Command "& {iwr -useb https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/setup.ps1 | iex} -InstallAll"

param (
    [switch]$InstallAll = $false
)

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

# Check if script is running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

# If not running as admin, elevate the script
if (-NOT $isAdmin) {
    Write-Host "This script requires administrator privileges. Attempting to elevate..." -ForegroundColor Yellow
    
    # Build the arguments to pass to the elevated process
    $scriptPath = $MyInvocation.MyCommand.Definition
    $arguments = ""
    if ($InstallAll) {
        $arguments = "-InstallAll"
    }
    
    # Restart script with admin rights
    try {
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`" $arguments" -Verb RunAs
        # Exit the current non-elevated script
        exit
    }
    catch {
        Write-Error "Failed to elevate script. Please run this script as Administrator!"
        pause
        exit 1
    }
}

# Function to show menu and get selection
function Show-Menu {
    Write-Host "`n📦 Installation Options:" -ForegroundColor Yellow
    Write-Host "1) 💻 Windows Developer Tools (VS Code, Git, Node.js, Python, Docker, etc.)" -ForegroundColor Green
    Write-Host "2) 🐧 WSL2 with Ubuntu + Developer Tools" -ForegroundColor Green
    Write-Host "3) 🔧 Additional Dev Tools (ChatGPT, ChatGit, NOI CLI, WinGit, Scoop, etc.)" -ForegroundColor Green
    Write-Host "4) ⭐ Install Everything (Complete Setup)" -ForegroundColor Cyan
    Write-Host "5) ❌ Exit" -ForegroundColor Red
    
    $selection = Read-Host "`nEnter your choice (1-5)"
    return $selection
}

# Function to test if a command exists
function Test-CommandExists {
    param (
        [string]$Command
    )
    
    $exists = $false
    try {
        if (Get-Command $Command -ErrorAction Stop) {
            $exists = $true
        }
    } catch {
        $exists = $false
    }
    
    return $exists
}

# Function to show checkpoint message
function Show-Checkpoint {
    param (
        [string]$Message,
        [bool]$Success = $true
    )
    
    if ($Success) {
        Write-Host "[✓] CHECKPOINT: $Message" -ForegroundColor Green
    } else {
        Write-Host "[✗] CHECKPOINT: $Message" -ForegroundColor Red
    }
}

# Function to run the Windows setup script
function Install-WindowsTools {
    Write-Host "`n=== Starting Windows Developer Tools Installation ===" -ForegroundColor Cyan
    
    # Check if script file exists
    $scriptPath = Join-Path -Path $PSScriptRoot -ChildPath "installps.ps1"
    
    if (Test-Path $scriptPath) {
        Show-Checkpoint "Found Windows tools installation script at: $scriptPath"
        
        try {
            # Run the Windows setup script using direct invocation
            & "$scriptPath"
            
            # Test if key tools were installed
            $testsResults = @(
                @{Name="Git"; Success=(Test-CommandExists -Command "git")}
                @{Name="Node.js"; Success=(Test-CommandExists -Command "node")}
                @{Name="Python"; Success=(Test-CommandExists -Command "python")}
                @{Name="VS Code"; Success=(Test-CommandExists -Command "code")}
                @{Name="Chocolatey"; Success=(Test-CommandExists -Command "choco")}
            )
            
            # Display results
            foreach ($test in $testsResults) {
                Show-Checkpoint "$($test.Name) installation" -Success $test.Success
            }
        }
        catch {
            Write-Host "Error running Windows installation script: $_" -ForegroundColor Red
            Show-Checkpoint "Windows tools installation failed" -Success $false
        }
    } else {
        Write-Host "Windows tools installation script not found at: $scriptPath" -ForegroundColor Red
        Show-Checkpoint "Windows tools script not found" -Success $false
    }
    
    Write-Host "=== Windows Developer Tools Installation Complete ===" -ForegroundColor Cyan
}

# Function to run the WSL setup script
function Install-WSLUbuntu {
    Write-Host "`n=== Starting WSL2 with Ubuntu Installation ===" -ForegroundColor Cyan
    
    # Check if script file exists
    $scriptPath = Join-Path -Path $PSScriptRoot -ChildPath "wsl.ps1"
    
    if (Test-Path $scriptPath) {
        Show-Checkpoint "Found WSL installation script at: $scriptPath"
        
        try {
            # Run the WSL setup script using direct invocation
            & "$scriptPath"
            
            # Test if WSL is installed
            $wslInstalled = $false
            try {
                $wslOutput = wsl --status 2>&1
                $wslInstalled = ($wslOutput -notmatch "not found")
            } catch {
                $wslInstalled = $false
            }
            
            Show-Checkpoint "WSL installation" -Success $wslInstalled
            
            # Check if Ubuntu is installed in WSL
            $ubuntuInstalled = $false
            if ($wslInstalled) {
                try {
                    $distros = (wsl -l) -join " "
                    $ubuntuInstalled = $distros -match "Ubuntu"
                } catch {
                    $ubuntuInstalled = $false
                }
            }
            
            Show-Checkpoint "Ubuntu installation in WSL" -Success $ubuntuInstalled
        }
        catch {
            Write-Host "Error running WSL installation script: $_" -ForegroundColor Red
            Show-Checkpoint "WSL installation failed" -Success $false
        }
    } else {
        Write-Host "WSL installation script not found at: $scriptPath" -ForegroundColor Red
        Show-Checkpoint "WSL script not found" -Success $false
    }
    
    Write-Host "=== WSL2 with Ubuntu Installation Complete ===" -ForegroundColor Cyan
}

# Function to run the additional dev tools script
function Install-AdditionalTools {
    Write-Host "`n=== Installing Additional Developer Tools ===" -ForegroundColor Cyan
    
    # Check if script file exists
    $scriptPath = Join-Path -Path $PSScriptRoot -ChildPath "modules\devtools\install.ps1"
    
    if (Test-Path $scriptPath) {
        Show-Checkpoint "Found additional tools installation script at: $scriptPath"
        
        try {
            # Run the dev tools script using direct invocation
            & "$scriptPath"
            
            # Test if key additional tools were installed
            $testsResults = @(
                @{Name="ChatGPT CLI"; Success=(Test-CommandExists -Command "chatgpt")}
                @{Name="NOI CLI"; Success=(Test-CommandExists -Command "noi")}
                @{Name="ChatGit"; Success=(Test-CommandExists -Command "chatgit")}
                @{Name="Scoop"; Success=(Test-CommandExists -Command "scoop")}
                @{Name="WinGet"; Success=(Test-CommandExists -Command "winget")}
            )
            
            # Display results
            foreach ($test in $testsResults) {
                Show-Checkpoint "$($test.Name) installation" -Success $test.Success
            }
        }
        catch {
            Write-Host "Error running additional tools installation script: $_" -ForegroundColor Red
            Show-Checkpoint "Additional tools installation failed" -Success $false
        }
    } else {
        Write-Host "Additional tools installation script not found at: $scriptPath" -ForegroundColor Red
        Show-Checkpoint "Additional tools script not found" -Success $false
    }
    
    Write-Host "=== Additional Developer Tools Installation Complete ===" -ForegroundColor Cyan
}
# Main execution
if ($InstallAll) {
    # If -InstallAll parameter is provided, install everything without prompting
    Write-Host "`n=== Starting Complete Installation (Windows + WSL + Additional Tools) ===" -ForegroundColor Cyan
    Write-Host "Installing all components automatically..." -ForegroundColor Yellow
    Install-WindowsTools
    Install-WSLUbuntu
    Install-AdditionalTools
    Write-Host "`n=== Complete Installation Finished! ===" -ForegroundColor Cyan
} 
else {
    # Show interactive menu if no parameters provided
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
}

# Function to test all installations and show summary
function Test-AllInstallations {
    Write-Host "`n=== 🔍 Testing All Installations ===" -ForegroundColor Cyan
    
    $allTools = @(
        # Dev essentials
        @{Category="Essential"; Name="Git"; Command="git"}
        @{Category="Essential"; Name="Node.js"; Command="node"}
        @{Category="Essential"; Name="npm"; Command="npm"}
        @{Category="Essential"; Name="Python"; Command="python"}
        @{Category="Essential"; Name="VS Code"; Command="code"}
        
        # Package managers
        @{Category="Package Managers"; Name="Chocolatey"; Command="choco"}
        @{Category="Package Managers"; Name="Scoop"; Command="scoop"}
        @{Category="Package Managers"; Name="WinGet"; Command="winget"}
        
        # AI Tools
        @{Category="AI Tools"; Name="ChatGPT CLI"; Command="chatgpt"}
        @{Category="AI Tools"; Name="NOI CLI"; Command="noi"}
        @{Category="AI Tools"; Name="ChatGit"; Command="chatgit"}
        @{Category="AI Tools"; Name="Gemini CLI"; Command="gemini"}
        
        # Containers
        @{Category="Containers"; Name="Docker"; Command="docker"}
        
        # WSL
        @{Category="WSL"; Name="WSL"; Command="wsl"}
    )
    
    $results = @{
        "Essential" = @{Total=0; Installed=0}
        "Package Managers" = @{Total=0; Installed=0}
        "AI Tools" = @{Total=0; Installed=0}
        "Containers" = @{Total=0; Installed=0}
        "WSL" = @{Total=0; Installed=0}
    }
    
    foreach ($tool in $allTools) {
        $category = $tool.Category
        $results[$category].Total++
        
        $installed = Test-CommandExists -Command $tool.Command
        if ($installed) {
            $results[$category].Installed++
        }
        
        $status = if ($installed) { "✓" } else { "✗" }
        Write-Host "[$status] $($tool.Name)" -ForegroundColor $(if ($installed) { "Green" } else { "Red" })
    }
    
    # Display summary
    Write-Host "`n=== 📊 Installation Summary ===" -ForegroundColor Yellow
    foreach ($category in $results.Keys) {
        $installed = $results[$category].Installed
        $total = $results[$category].Total
        $percentage = [math]::Round(($installed / $total) * 100)
        
        Write-Host "$category : $installed/$total installed ($percentage%)" -ForegroundColor $(
            if ($percentage -eq 100) { "Green" } 
            elseif ($percentage -ge 50) { "Yellow" } 
            else { "Red" }
        )
    }
    
    # Overall status
    $totalInstalled = ($allTools | Where-Object { (Test-CommandExists -Command $_.Command) }).Count
    $totalTools = $allTools.Count
    $overallPercentage = [math]::Round(($totalInstalled / $totalTools) * 100)
    
    Write-Host "`n=== 🏁 Overall Installation Status: $totalInstalled/$totalTools ($overallPercentage%) ===" -ForegroundColor $(
        if ($overallPercentage -eq 100) { "Green" } 
        elseif ($overallPercentage -ge 70) { "Yellow" } 
        else { "Red" }
    )
}

# Run final test
Test-AllInstallations

# Final instructions
Write-Host "`n📋 Setup complete! Here's what to do next:" -ForegroundColor Yellow
Write-Host "• Restart your computer to ensure all changes take effect" -ForegroundColor White
Write-Host "• Check out the website at https://win.r-u.live for more information" -ForegroundColor White
Write-Host "• Visit our GitHub repository at https://github.com/anshulyadav32/windows-setup for updates" -ForegroundColor White
Write-Host "`n🎉 Happy coding!" -ForegroundColor Cyan
