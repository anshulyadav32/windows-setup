# wsl.ps1
# Setup WSL2 with Ubuntu and install Node.js, PostgreSQL, Docker, GitHub CLI, Python, React, DevOps tools, and Visual Studio Code server.

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
        Write-Host "[OK] WSL Setup script started with correct encoding (UTF-8 no BOM)." -ForegroundColor Cyan
    }
    catch {
        Write-Host "[NOTE] Skipping encoding check (unable to read file bytes)." -ForegroundColor Yellow
    }
}
else {
    Write-Host "[NOTE] Skipping encoding check (script not running from file)." -ForegroundColor Yellow
}

# =========================================
# FUNCTIONS
# =========================================
function Enable-WSL2Features {
    Write-Host "Enabling required Windows features (WSL + Virtual Machine Platform)..." -ForegroundColor Yellow
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    Write-Host "`n[WARNING] Restart is required to finish enabling WSL features." -ForegroundColor Cyan
    $restart = Read-Host "Do you want to restart now? (y/n)"
    if ($restart -match '^[Yy]$') {
        Write-Host "Restarting in 10 seconds..." -ForegroundColor Yellow
        Start-Sleep -Seconds 10
        Restart-Computer -Force
    } else {
        Write-Host "Please restart manually and run this script again after reboot." -ForegroundColor Yellow
    }
    exit 0
}

function Test-WSLEnabled {
    try {
        wsl --status > $null 2>&1
        return ($LASTEXITCODE -eq 0)
    } catch { return $false }
}

function Test-VirtPlatform {
    $feature = Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
    return ($feature.State -eq "Enabled")
}

function Test-Virtualization {
    # Try multiple methods to detect virtualization
    try {
        # Method 1: systeminfo
        $sysInfo = systeminfo
        $virtFirmware = $sysInfo | Select-String "Virtualization Enabled In Firmware"
        $virtHyperV = $sysInfo | Select-String "Hyper-V Requirements"
        
        if ($virtFirmware -match "Yes") {
            return $true
        }
        
        # Method 2: Check for Hyper-V capability
        if ($virtHyperV -match "A hypervisor has been detected") {
            return $true
        }
        
        # Method 3: PowerShell direct check (Windows 10/11)
        $processor = Get-CimInstance -ClassName Win32_Processor
        if ($processor.VirtualizationFirmwareEnabled) {
            return $true
        }
        
        # If we get here, virtualization is likely not enabled
        return $false
    }
    catch {
        Write-Host "[WARNING] Couldn't determine virtualization status: $_" -ForegroundColor Yellow
        return $false
    }
}

function Test-UbuntuInstalled {
    $distros = wsl --list --verbose 2>&1
    return ($distros -match "Ubuntu")
}

# =========================================
# MAIN EXECUTION
# =========================================

if (-Not (Test-WSLEnabled)) {
    Enable-WSL2Features
}

if (-Not (Test-VirtPlatform)) {
    Write-Host "[WARNING] Virtual Machine Platform is not enabled. Enabling..." -ForegroundColor Yellow
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    Write-Host "Please restart your computer and run this script again." -ForegroundColor Cyan
    exit 0
}

if (-Not (Test-Virtualization)) {
    Write-Host "`n[ERROR] CPU virtualization is disabled in BIOS/UEFI." -ForegroundColor Red
    Write-Host "`n[ACTION REQUIRED] Follow these steps:" -ForegroundColor Yellow
    Write-Host "  1. Save any open work and restart your computer" -ForegroundColor Yellow
    Write-Host "  2. During boot, press the BIOS/UEFI key (usually F2, Del, F10, or Esc)" -ForegroundColor Yellow
    Write-Host "  3. Navigate to one of these sections:" -ForegroundColor Yellow
    Write-Host "     - Advanced > CPU Configuration" -ForegroundColor Cyan
    Write-Host "     - Advanced > Processor" -ForegroundColor Cyan 
    Write-Host "     - Security" -ForegroundColor Cyan
    Write-Host "  4. Look for and ENABLE one of these settings:" -ForegroundColor Yellow
    Write-Host "     - Virtualization Technology (VT-x)" -ForegroundColor Cyan
    Write-Host "     - AMD-V / SVM Mode" -ForegroundColor Cyan
    Write-Host "     - Intel Virtualization Technology" -ForegroundColor Cyan
    Write-Host "  5. Save changes and exit BIOS/UEFI" -ForegroundColor Yellow
    Write-Host "  6. After restart, run this script again" -ForegroundColor Yellow
    Write-Host "`nWSL2 cannot be installed without CPU virtualization enabled." -ForegroundColor Red
    exit 1
}

Write-Host "Setting WSL 2 as the default version..." -ForegroundColor Yellow
wsl --set-default-version 2

if (-Not (Test-UbuntuInstalled)) {
    Write-Host "`n[INFO] Installing Ubuntu under WSL2..." -ForegroundColor Yellow
    try {
        # Try to install Ubuntu
        $result = wsl --install -d Ubuntu 2>&1
        
        # Check if installation started successfully
        if ($result -match "Installing, this may take a few minutes") {
            Write-Host "`n[SUCCESS] Ubuntu installation has started." -ForegroundColor Green
            Write-Host "[IMPORTANT] Complete username/password setup in the opened window." -ForegroundColor Cyan
            Write-Host "[NEXT STEP] After finishing setup, re-run this script to continue." -ForegroundColor Cyan
        } else {
            Write-Host "`n[INFO] Ubuntu is being installed. Please follow the prompts in the new window." -ForegroundColor Yellow
            Write-Host "[NEXT STEP] After completing the Ubuntu setup, re-run this script." -ForegroundColor Cyan
        }
        exit 0
    } catch {
        Write-Host "`n[ERROR] Failed to install Ubuntu: $_" -ForegroundColor Red
        Write-Host "[TIP] Try installing Ubuntu manually using 'wsl --install -d Ubuntu'" -ForegroundColor Yellow
        exit 1
    }
}

$ubuntuInfo = wsl --list --verbose | Select-String "Ubuntu"
if ($ubuntuInfo -match "1") {
    Write-Host "Upgrading Ubuntu instance to WSL2..." -ForegroundColor Yellow
    wsl --set-version Ubuntu 2
    Write-Host "Ubuntu successfully converted to WSL2." -ForegroundColor Green
}

Write-Host "Ubuntu is ready on WSL2. Installing development environment..." -ForegroundColor Green

$ubuntuCommands = @"
set -e
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git python3 python3-pip postgresql postgresql-contrib apt-transport-https ca-certificates gnupg lsb-release make
# Node.js
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
npm install -g npx create-react-app chatgpt-cli
# GitHub CLI
sudo apt install -y gh
# Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
UBUNTU_CODENAME=\$(lsb_release -cs)
echo "deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \$UBUNTU_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker \$USER
# DevOps tools
sudo apt install -y ansible terraform kubectl git-lfs
# VS Code server for remote WSL dev
wget -qO- https://aka.ms/install-vscode-server/setup.sh | sh
"@

try {
    wsl -d Ubuntu bash -c "$ubuntuCommands"
    Write-Host "`n[SUCCESS] WSL2 Ubuntu setup complete with Node.js, PostgreSQL, Git, GitHub CLI, Python, React, Docker, DevOps tools, and VS Code server." -ForegroundColor Green
} catch {
    Write-Host "[ERROR] During Ubuntu setup: $_" -ForegroundColor Red
    Write-Host "[TIP] Try running the commands manually inside WSL." -ForegroundColor Yellow
}
