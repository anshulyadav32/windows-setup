# setup.ps1
# Windows & WSL Development Environment Combined Setup Script
# This script will automatically elevate to admin permissions if needed
#
# Quick install command:
# iwr -useb https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/setup.ps1 | iex
# OR
# Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/setup.ps1 | Invoke-Expression
#
# This script automatically installs all components without prompts:
# - Windows Developer Tools (VS Code, Git, Node.js, Python, Docker, etc.)
# - WSL2 with Ubuntu + Developer Tools
# - Additional Dev Tools (ChatGPT, PowerToys, WinGet, Scoop, etc.)

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
        Write-Host "[OK] Setup script started with correct encoding (UTF-8 no BOM)." -ForegroundColor Cyan
    }
    catch {
        Write-Host "[NOTE] Skipping encoding check (unable to read file bytes)." -ForegroundColor Yellow
    }
}
else {
    Write-Host "[NOTE] Skipping encoding check (script not running from file)." -ForegroundColor Yellow
}

# No parameters needed anymore as the script runs automatically

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
    
    # Get the current script path
    $scriptPath = $MyInvocation.MyCommand.Definition
    
    # Restart script with admin rights
    try {
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
        # Exit the current non-elevated script
        exit
    }
    catch {
        Write-Error "Failed to elevate script. Please run this script as Administrator!"
        pause
        exit 1
    }
}

# This script now runs automatically without a menu

# Function to test if a command exists
function Test-CommandExists {
function Ensure-ToolPath {
    param (
        [string]$Command,
        [string]$ConfigScript = $null
    )
    $exists = Test-CommandExists -Command $Command
    if (-not $exists) {
        Write-Host "[INFO] $Command not found in PATH. Attempting to configure..." -ForegroundColor Yellow
        if ($ConfigScript -and (Test-Path $ConfigScript)) {
            Write-Host "Running configuration script: $ConfigScript" -ForegroundColor Cyan
            & $ConfigScript
        } else {
            Write-Host "No configuration script provided for $Command. Please configure manually if needed." -ForegroundColor Red
        }
    } else {
        Write-Host "[OK] $Command found in PATH." -ForegroundColor Green
    }
}
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
        Write-Host "[OK] CHECKPOINT: $Message" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] CHECKPOINT: $Message" -ForegroundColor Red
    }
}

# Function to run the Windows setup script
function Install-WindowsTools {
    Write-Host "`n=== Starting Windows Developer Tools Installation ===" -ForegroundColor Cyan
    # Check if script file exists
    $scriptPath = Join-Path -Path $PSScriptRoot -ChildPath "install.ps1"
    if (Test-Path $scriptPath) {
        Show-Checkpoint "Found Windows tools installation script at: $scriptPath"
        try {
            & "$scriptPath"
            # Check and configure paths for each tool
            Ensure-ToolPath -Command "git"
            Ensure-ToolPath -Command "node"
            Ensure-ToolPath -Command "python"
            Ensure-ToolPath -Command "code"
            Ensure-ToolPath -Command "choco"
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
Write-Host "`n=== Starting Automatic Installation (Windows + WSL + Additional Tools) ===" -ForegroundColor Cyan
Write-Host "Installing all components automatically..." -ForegroundColor Yellow


# Install Windows Developer Tools
Install-WindowsTools

# Check if WSL is supported before running WSL install
$wslSupported = $false
try {
    $osVersion = (Get-CimInstance Win32_OperatingSystem).Version
    $majorVersion = $osVersion.Split('.')[0]
    $minorVersion = $osVersion.Split('.')[1]
    # Windows 10 (10.x) or Windows 11 (10.0.22000+)
    if ($majorVersion -eq '10') {
        # Check if WSL feature is available
        $wslFeature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -ErrorAction SilentlyContinue
        if ($wslFeature.State -eq 'Enabled' -or $wslFeature.State -eq 'Disabled') {
            $wslSupported = $true
        }
    }
} catch {
    $wslSupported = $false
}

if ($wslSupported) {
    Write-Host "WSL is supported on this system. Proceeding with WSL installation..." -ForegroundColor Cyan
    Install-WSLUbuntu
} else {
    Write-Host "WSL is not supported on this system. Skipping WSL installation." -ForegroundColor Yellow
}

# Install Additional Developer Tools
Install-AdditionalTools

Write-Host "`n=== Complete Installation Finished! ===" -ForegroundColor Cyan

# Function to test all installations and show summary
function Test-AllInstallations {
    Write-Host "`n=== Testing All Installations ===" -ForegroundColor Cyan
    
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
        
    $status = if ($installed) { "OK" } else { "FAIL" }
    Write-Host "[$status] $($tool.Name)" -ForegroundColor $(if ($installed) { "Green" } else { "Red" })
    }
    
    # Display summary
    Write-Host "`n=== Installation Summary ===" -ForegroundColor Yellow
    foreach ($category in $results.Keys) {
        $installed = $results[$category].Installed
        $total = $results[$category].Total
        $percentage = [math]::Round(($installed / $total) * 100)
        
        $output = $category + ' : ' + $installed + '/' + $total + ' installed (' + $percentage + ' percent)'
        $color = if ($percentage -eq 100) { "Green" } elseif ($percentage -ge 50) { "Yellow" } else { "Red" }
        Write-Host $output -ForegroundColor $color
    }
    
    # Overall status
    $totalInstalled = ($allTools | Where-Object { (Test-CommandExists -Command $_.Command) }).Count
    $totalTools = $allTools.Count
    $overallPercentage = [math]::Round(($totalInstalled / $totalTools) * 100)
    
    $overallOutput = "`n=== Overall Installation Status: " + $totalInstalled + '/' + $totalTools + ' (' + $overallPercentage + ' percent) ==='
    if ($overallPercentage -eq 100) {
        $overallColor = 'Green'
    } elseif ($overallPercentage -ge 70) {
        $overallColor = 'Yellow'
    } else {
        $overallColor = 'Red'
    }
    Write-Host $overallOutput -ForegroundColor $overallColor
}

# Run final test
Test-AllInstallations

# Final instructions
Write-Host ""
Write-Host "Setup complete! Here's what to do next:" -ForegroundColor Yellow
Write-Host "- Restart your computer to ensure all changes take effect" -ForegroundColor White
Write-Host "- Check out the website at https://win.r-u.live for more information" -ForegroundColor White
Write-Host "- Visit our GitHub repository at https://github.com/anshulyadav32/windows-setup for updates" -ForegroundColor White
Write-Host ""
Write-Host "Happy coding!" -ForegroundColor Cyan
