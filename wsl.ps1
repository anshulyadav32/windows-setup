# wsl.ps1
# This script sets up WSL2 with Ubuntu, and installs Node.js LTS, PostgreSQL, Git, GitHub CLI, Python, and React (via npx create-react-app)

# Function to check if WSL is enabled
function Test-WSLEnabled {
    $wslCheck = wsl --status 2>&1
    return !($wslCheck -match "not recognized" -or $wslCheck -match "WSL_E_WSL_OPTIONAL_COMPONENT_REQUIRED")
}

# Function to check if Ubuntu is installed
function Test-UbuntuInstalled {
    $distros = wsl --list 2>&1
    return ($distros -match "Ubuntu")
}

# Step 1: Check and install WSL if needed
if (-Not (Test-WSLEnabled)) {
    Write-Host "Windows Subsystem for Linux is not fully installed. Installing WSL..." -ForegroundColor Yellow
    Write-Host "This may require a system restart. After restart, please run this script again." -ForegroundColor Cyan
    
    # Enable WSL feature
    try {
        # Run the install command
        Write-Host "Installing the Windows Subsystem for Linux (WSL)..." -ForegroundColor Yellow
        $result = wsl --install --no-distribution 2>&1
        
        # Always set WSL 2 as default
        Write-Host "Setting WSL 2 as the default version..." -ForegroundColor Yellow
        wsl --set-default-version 2
        
        # Check if a restart is needed
        Write-Host "`n⚠️ IMPORTANT: Your computer needs to be restarted to complete the WSL installation." -ForegroundColor Cyan
        Write-Host "After restarting, run this script again to continue with the installation." -ForegroundColor Cyan
        
        # Ask if user wants to restart now
        $restart = Read-Host "`nDo you want to restart your computer now? (y/n)"
        if ($restart -eq 'y' -or $restart -eq 'Y') {
            Write-Host "`nRestarting your computer in 10 seconds. Please run this script again after restart." -ForegroundColor Yellow
            Start-Sleep -Seconds 10
            Restart-Computer -Force
        } else {
            Write-Host "`nPlease restart your computer manually and run this script again." -ForegroundColor Yellow
        }
        exit 0
    }
    catch {
        Write-Host "Error installing WSL: $_" -ForegroundColor Red
        exit 1
    }
}

# Step 2: WSL is enabled, now install Ubuntu if not installed
if (-Not (Test-UbuntuInstalled)) {
    Write-Host "WSL is enabled. Now installing Ubuntu distribution..." -ForegroundColor Yellow
    
    try {
        wsl --install -d Ubuntu
        Write-Host "Ubuntu is being installed. Please set up your Ubuntu username and password in the new window that appears." -ForegroundColor Yellow
        Write-Host "After completing the Ubuntu setup, close that window and run this script again to continue." -ForegroundColor Cyan
        exit 0
    }
    catch {
        Write-Host "Error installing Ubuntu: $_" -ForegroundColor Red
        exit 1
    }
}

# Step 3: WSL and Ubuntu are installed, now run setup commands
Write-Host "WSL and Ubuntu are properly installed. Setting up development environment..." -ForegroundColor Green

# The following commands will be run inside Ubuntu
$ubuntuCommands = @"
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git python3 python3-pip postgresql postgresql-contrib apt-transport-https ca-certificates gnupg lsb-release
# Node.js
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

npm install -g npx
sudo apt install -y gh
# Install create-react-app globally (optional)
npm install -g create-react-app
# Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
UBUNTU_CODENAME=$(lsb_release -cs)
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
# DevOps tools
sudo apt install -y ansible terraform kubectl
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt install -y git-lfs
sudo apt install -y make
npm install -g chatgpt-cli
"@

# Run commands in Ubuntu - wrap in try/catch block
try {
    Write-Host "Running setup commands in Ubuntu. This may take several minutes..." -ForegroundColor Yellow
    wsl -d Ubuntu bash -c "$ubuntuCommands"
    
    # Verify installation of key components
    $nodeCheck = wsl -d Ubuntu -- which node 2>&1
    $pythonCheck = wsl -d Ubuntu -- which python3 2>&1
    $dockerCheck = wsl -d Ubuntu -- which docker 2>&1
    $gitCheck = wsl -d Ubuntu -- which git 2>&1
    
    # Report status
    Write-Host "`nInstallation results:" -ForegroundColor Cyan
    Write-Host "Node.js: $( if ($nodeCheck -notmatch "which") { "Installed ✓" } else { "Failed ✗" } )" -ForegroundColor $(if ($nodeCheck -notmatch "which") { "Green" } else { "Red" })
    Write-Host "Python: $( if ($pythonCheck -notmatch "which") { "Installed ✓" } else { "Failed ✗" } )" -ForegroundColor $(if ($pythonCheck -notmatch "which") { "Green" } else { "Red" })
    Write-Host "Docker: $( if ($dockerCheck -notmatch "which") { "Installed ✓" } else { "Failed ✗" } )" -ForegroundColor $(if ($dockerCheck -notmatch "which") { "Green" } else { "Red" })
    Write-Host "Git: $( if ($gitCheck -notmatch "which") { "Installed ✓" } else { "Failed ✗" } )" -ForegroundColor $(if ($gitCheck -notmatch "which") { "Green" } else { "Red" })
    
    Write-Host "`nWSL2 Ubuntu setup complete with Node.js LTS, PostgreSQL, Git, GitHub CLI, Python, React, Docker, DevOps tools, and ChatGPT CLI." -ForegroundColor Green
}
catch {
    Write-Host "Error during Ubuntu setup: $_" -ForegroundColor Red
    Write-Host "Try running the Ubuntu setup commands manually inside WSL." -ForegroundColor Yellow
}

# Note about PowerToys
Write-Host "PowerToys installation is handled by the main Windows setup script." -ForegroundColor Cyan