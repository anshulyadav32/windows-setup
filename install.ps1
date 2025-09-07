# install.ps1
# Windows Development Environment Setup Script
# Run this script in PowerShell as Administrator
#
# Quick install command:
# iwr -useb https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/install.ps1 | iex
# OR
# Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/install.ps1 | Invoke-Expression

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
        Write-Host "[OK] Windows install script started with correct encoding (UTF-8 no BOM)." -ForegroundColor Cyan
    }
    catch {
        Write-Host "[NOTE] Skipping encoding check (unable to read file bytes)." -ForegroundColor Yellow
    }
}
else {
    Write-Host "[NOTE] Skipping encoding check (script not running from file)." -ForegroundColor Yellow
}
Write-Host "\n--- Checking installed packages ---" -ForegroundColor Cyan
$packages = @(
    "scoop",              # Scoop package manager
    "winget",             # WinGet package manager
    "git",                # Git
    "gh",                 # GitHub CLI
    "chatgpt",            # ChatGPT CLI
    "noi",                # NOI CLI
    "vscode",             # Visual Studio Code
    "googlechrome",       # Chrome
    "nodejs-lts",         # Node.js (LTS version)
    "python",             # Python
    "postgresql",         # PostgreSQL (includes psql)
    "microsoft-windows-terminal", # Windows Terminal
    "docker-desktop",     # Docker Desktop
    "powertoys"           # PowerToys
)
foreach ($pkg in $packages) {
    $isInstalled = $false
    switch ($pkg) {
        "scoop" { $isInstalled = (Get-Command scoop -ErrorAction SilentlyContinue) -ne $null }
        "winget" { $isInstalled = (Get-Command winget -ErrorAction SilentlyContinue) -ne $null }
        "git" { $isInstalled = (Get-Command git -ErrorAction SilentlyContinue) -ne $null }
        "gh" { $isInstalled = (Get-Command gh -ErrorAction SilentlyContinue) -ne $null }
        "chatgpt" { $isInstalled = (Get-Command chatgpt -ErrorAction SilentlyContinue) -ne $null }
        "noi" { $isInstalled = (Get-Command noi -ErrorAction SilentlyContinue) -ne $null }
        "vscode" { $isInstalled = (Get-Command code -ErrorAction SilentlyContinue) -ne $null }
        "googlechrome" { $isInstalled = Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe" }
        "nodejs-lts" { $isInstalled = (Get-Command node -ErrorAction SilentlyContinue) -ne $null }
        "python" { $isInstalled = (Get-Command python -ErrorAction SilentlyContinue) -ne $null }
        "postgresql" { $isInstalled = (Get-Command psql -ErrorAction SilentlyContinue) -ne $null }
        "microsoft-windows-terminal" { $isInstalled = (Get-Command wt -ErrorAction SilentlyContinue) -ne $null }
        "docker-desktop" { $isInstalled = (Get-Command docker -ErrorAction SilentlyContinue) -ne $null }
        "powertoys" { $isInstalled = Test-Path "$env:LOCALAPPDATA\Microsoft\PowerToys\PowerToys.exe" }
        default { $isInstalled = (Get-Command $pkg -ErrorAction SilentlyContinue) -ne $null }
    }
    if ($isInstalled) {
        Write-Host "${pkg}: Installed" -ForegroundColor Green
    } else {
        Write-Host "${pkg}: Not installed" -ForegroundColor Yellow
    }
}
Write-Host "--- Package check complete ---\n" -ForegroundColor Cyan
if (-Not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Scoop not found. Installing Scoop..." -ForegroundColor Yellow
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
    Write-Host "Scoop installation attempted." -ForegroundColor Magenta
}
if (-Not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "WinGet not found. Installing WinGet via Scoop..." -ForegroundColor Yellow
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        scoop bucket add extras
        scoop install extras/winget-cli
        Write-Host "WinGet installation attempted via Scoop." -ForegroundColor Magenta
    } else {
        Write-Host "Scoop not available. Please install WinGet manually from Microsoft Store." -ForegroundColor Red
    }
}
Write-Host "=== Starting Windows Dev Setup ===" -ForegroundColor Cyan

# Ensure script is run as Administrator
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Please run this script as Administrator!"
    Exit 1
}

# Install Scoop
if (-Not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Scoop..." -ForegroundColor Yellow
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
    
    # Install Git for Scoop
    Write-Host "Installing Git for Scoop..." -ForegroundColor Yellow
    scoop install git
} else {
    Write-Host "Scoop already installed." -ForegroundColor Green
}
Write-Host "[Checkpoint] Scoop installation step complete." -ForegroundColor Magenta

# Install WinGet if not already installed
if (-Not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Setting up WinGet..." -ForegroundColor Yellow
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        scoop bucket add extras
        scoop install extras/winget-cli
    } else {
        Write-Host "WinGet setup skipped - please install manually from Microsoft Store." -ForegroundColor Yellow
    }
} else {
    Write-Host "WinGet already installed." -ForegroundColor Green
}
Write-Host "[Checkpoint] WinGet installation step complete." -ForegroundColor Magenta

# Install Chocolatey
if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey already installed." -ForegroundColor Green
}
Write-Host "[Checkpoint] Chocolatey installation step complete." -ForegroundColor Magenta

# Refresh environment
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
Write-Host "[Checkpoint] Environment refreshed." -ForegroundColor Magenta

# Install packages via choco
$packages = @(
    "git",
    "gh",                 # GitHub CLI
    "vscode",             # Visual Studio Code
    "googlechrome",       # Chrome
    "nodejs-lts",         # Node.js (LTS version)
    "python",             # Python
    "postgresql",         # PostgreSQL (includes psql)
    "microsoft-windows-terminal", # Windows Terminal
    "docker-desktop"      # Docker Desktop
)

foreach ($pkg in $packages) {
    Write-Host "Installing ${pkg} ..." -ForegroundColor Yellow
    $installSuccess = $false
    $wingetMap = @{
    "git" = "Git.Git"
    "gh" = "GitHub.cli"
    "vscode" = "Microsoft.VisualStudioCode"
    "googlechrome" = "Google.Chrome"
    "nodejs-lts" = "OpenJS.NodeJS.LTS"
    "python" = "Python.Python.3"
    "postgresql" = "PostgreSQL.PostgreSQL"
    "microsoft-windows-terminal" = "Microsoft.WindowsTerminal"
    "docker-desktop" = "Docker.DockerDesktop"
    "powertoys" = "Microsoft.PowerToys"
    }
    if ($pkg -eq "scoop" -or $pkg -eq "winget") {
        # Already handled above
        $installSuccess = $true
    } else {
        choco install $pkg -y --force
        Start-Sleep -Seconds 2
        switch ($pkg) {
            "git" { $installSuccess = (Get-Command git -ErrorAction SilentlyContinue) -ne $null }
            "gh" { $installSuccess = (Get-Command gh -ErrorAction SilentlyContinue) -ne $null }
            "vscode" { $installSuccess = (Get-Command code -ErrorAction SilentlyContinue) -ne $null }
            "googlechrome" { $installSuccess = Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe" }
            "nodejs-lts" { $installSuccess = (Get-Command node -ErrorAction SilentlyContinue) -ne $null }
            "python" { $installSuccess = (Get-Command python -ErrorAction SilentlyContinue) -ne $null }
            "postgresql" { $installSuccess = (Get-Command psql -ErrorAction SilentlyContinue) -ne $null }
            "microsoft-windows-terminal" { $installSuccess = (Get-Command wt -ErrorAction SilentlyContinue) -ne $null }
            "docker-desktop" { $installSuccess = (Get-Command docker -ErrorAction SilentlyContinue) -ne $null }
            "powertoys" { $installSuccess = Test-Path "$env:LOCALAPPDATA\Microsoft\PowerToys\PowerToys.exe" }
            default { $installSuccess = (Get-Command $pkg -ErrorAction SilentlyContinue) -ne $null }
        }
        if (-not $installSuccess -and (Get-Command winget -ErrorAction SilentlyContinue)) {
            if ($wingetMap.ContainsKey($pkg)) {
                Write-Host "[Warning] ${pkg} install failed with Chocolatey. Trying WinGet..." -ForegroundColor Yellow
                winget install $wingetMap[$pkg] --accept-source-agreements --accept-package-agreements
                Start-Sleep -Seconds 2
                switch ($pkg) {
                    "git" { $installSuccess = (Get-Command git -ErrorAction SilentlyContinue) -ne $null }
                    "gh" { $installSuccess = (Get-Command gh -ErrorAction SilentlyContinue) -ne $null }
                    "vscode" { $installSuccess = (Get-Command code -ErrorAction SilentlyContinue) -ne $null }
                    "googlechrome" { $installSuccess = Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe" }
                    "nodejs-lts" { $installSuccess = (Get-Command node -ErrorAction SilentlyContinue) -ne $null }
                    "python" { $installSuccess = (Get-Command python -ErrorAction SilentlyContinue) -ne $null }
                    "postgresql" { $installSuccess = (Get-Command psql -ErrorAction SilentlyContinue) -ne $null }
                    "microsoft-windows-terminal" { $installSuccess = (Get-Command wt -ErrorAction SilentlyContinue) -ne $null }
                    "docker-desktop" { $installSuccess = (Get-Command docker -ErrorAction SilentlyContinue) -ne $null }
                    "powertoys" { $installSuccess = Test-Path "$env:LOCALAPPDATA\Microsoft\PowerToys\PowerToys.exe" }
                    default { $installSuccess = (Get-Command $pkg -ErrorAction SilentlyContinue) -ne $null }
                }
            }
        }
    }
    if ($installSuccess) {
        Write-Host "[Checkpoint] ${pkg} installed successfully." -ForegroundColor Magenta
    } else {
        Write-Host "[Checkpoint] ${pkg} installation failed or may need manual verification." -ForegroundColor Red
    }
}
Write-Host "[Checkpoint] All main packages installation step complete." -ForegroundColor Magenta

# Install ChatGPT Desktop (if available)
Write-Host "Installing ChatGPT Desktop..." -ForegroundColor Yellow
if (-Not (Get-Command chatgpt-desktop -ErrorAction SilentlyContinue)) {
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install lencx.ChatGPT --accept-source-agreements --accept-package-agreements
        if (Get-Command chatgpt-desktop -ErrorAction SilentlyContinue) {
            Write-Host "ChatGPT Desktop installed successfully." -ForegroundColor Green
        } else {
            Write-Host "ChatGPT Desktop installation may need verification." -ForegroundColor Yellow
        }
    } else {
        Write-Host "WinGet not found. Please install ChatGPT Desktop manually from https://github.com/lencx/ChatGPT/releases" -ForegroundColor Red
    }
} else {
    Write-Host "ChatGPT Desktop already installed." -ForegroundColor Green
}
Write-Host "[Checkpoint] ChatGPT Desktop installation step complete." -ForegroundColor Magenta

# Install PowerToys
if (-Not (Test-Path "$env:LOCALAPPDATA\Microsoft\PowerToys\PowerToys.exe")) {
    Write-Host "Installing PowerToys..." -ForegroundColor Yellow
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install Microsoft.PowerToys --accept-source-agreements --accept-package-agreements
    } else {
        choco install powertoys -y
    }
} else {
    Write-Host "PowerToys already installed." -ForegroundColor Green
}
Write-Host "[Checkpoint] PowerToys installation step complete." -ForegroundColor Magenta

# Ensure npm is properly set up
if (-Not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "npm not found. Please restart PowerShell or run 'refreshenv' and try again." -ForegroundColor Red
} else {
    # Install global npm packages
    $npmPackages = @(
        "typescript",
        "nodemon",
        "serve",
        "npm-check-updates",
        "yarn"
    )
    
    foreach ($pkg in $npmPackages) {
        Write-Host "Installing npm package $pkg..." -ForegroundColor Yellow
        npm install -g $pkg
        
        if (Get-Command $pkg -ErrorAction SilentlyContinue) {
            Write-Host "[Checkpoint] npm package $pkg installed successfully." -ForegroundColor Magenta
        } else {
            Write-Host "[Checkpoint] npm package $pkg installation may need verification." -ForegroundColor Yellow
        }
    }
    Write-Host "[Checkpoint] All npm packages installation step complete." -ForegroundColor Magenta

# Additional Developer Tools Installation
Write-Host "=== Starting Additional Developer Tools Installation ===" -ForegroundColor Cyan

# Install ChatGPT Desktop (if available)
Write-Host "Installing ChatGPT Desktop..." -ForegroundColor Yellow
if (-Not (Get-Command chatgpt-desktop -ErrorAction SilentlyContinue)) {
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install lencx.ChatGPT --accept-source-agreements --accept-package-agreements
        if (Get-Command chatgpt-desktop -ErrorAction SilentlyContinue) {
            Write-Host "ChatGPT Desktop installed successfully." -ForegroundColor Green
        } else {
            Write-Host "ChatGPT Desktop installation may need verification." -ForegroundColor Yellow
        }
    } else {
        Write-Host "WinGet not found. Please install ChatGPT Desktop manually from https://github.com/lencx/ChatGPT/releases" -ForegroundColor Red
    }
} else {
    Write-Host "ChatGPT Desktop already installed." -ForegroundColor Green
}
Write-Host "[Checkpoint] ChatGPT Desktop installation step complete." -ForegroundColor Magenta

# Install ChatGPT CLI (if available)
if (-Not (Get-Command chatgpt -ErrorAction SilentlyContinue)) {
    Write-Host "Installing ChatGPT CLI..." -ForegroundColor Yellow
    npm install -g chatgpt-cli
    if (Get-Command chatgpt -ErrorAction SilentlyContinue) {
        Write-Host "ChatGPT CLI installed successfully." -ForegroundColor Green
    } else {
        Write-Host "ChatGPT CLI installation may need verification." -ForegroundColor Yellow
    }
} else {
    Write-Host "ChatGPT CLI already installed." -ForegroundColor Green
}
Write-Host "[Checkpoint] ChatGPT CLI installation step complete." -ForegroundColor Magenta

Write-Host "=== Additional Developer Tools Installation Complete ===" -ForegroundColor Cyan
}

# Install Gemini CLI (Google AI)


# Install Codex CLI (OpenAI or custom CLI)
if (-Not (Get-Command codex -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Codex CLI..." -ForegroundColor Yellow
    Write-Host "[WARNING] Codex CLI is deprecated. Consider using an alternative tool." -ForegroundColor Yellow
    if ((Get-Command npm -ErrorAction SilentlyContinue) -and (Get-Command node -ErrorAction SilentlyContinue)) {
        npm install -g codex-cli
        if (Get-Command codex -ErrorAction SilentlyContinue) {
            Write-Host "[Checkpoint] Codex CLI installed successfully." -ForegroundColor Magenta
        } else {
            Write-Host "[Checkpoint] Codex CLI installation failed or not found." -ForegroundColor Red
        }
    } else {
        Write-Host "npm or node not found. Please restart PowerShell or run 'refreshenv' and try again." -ForegroundColor Red
    }
}

# Install ChatGPT CLI

    # Manual instructions for PostgreSQL and Docker Desktop if install fails
    if ($pkg -eq "postgresql" -and -not $installSuccess) {
        Write-Host "[MANUAL ACTION] PostgreSQL could not be installed automatically. Please download and install from https://www.postgresql.org/download/windows/" -ForegroundColor Yellow
    }
    if ($pkg -eq "docker-desktop" -and -not $installSuccess) {
        Write-Host "[MANUAL ACTION] Docker Desktop could not be installed automatically. Please close all Docker-related processes and try again, or download from https://www.docker.com/products/docker-desktop/" -ForegroundColor Yellow
    }

Write-Host "=== Windows Dev Setup Complete ===" -ForegroundColor Cyan
Write-Host "Please restart your terminal or system for all changes to take effect." -ForegroundColor Yellow
