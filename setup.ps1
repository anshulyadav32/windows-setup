# setup.ps1
# Windows Development Environment Setup Script
# Run this script in PowerShell as Administrator

Write-Host "=== Starting Windows Dev Setup ===" -ForegroundColor Cyan

# Ensure script is run as Administrator
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Please run this script as Administrator!"
    Exit 1
}

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
    "microsoft-windows-terminal" # Windows Terminal
)

foreach ($pkg in $packages) {
    Write-Host "Installing $pkg ..." -ForegroundColor Yellow
    choco install $pkg -y --force
    
    # Wait for installation to complete
    Start-Sleep -Seconds 2
    
    # Check specific commands for each package
    $success = $false
    switch ($pkg) {
        "git" { $success = (Get-Command git -ErrorAction SilentlyContinue) -ne $null }
        "gh" { $success = (Get-Command gh -ErrorAction SilentlyContinue) -ne $null }
        "vscode" { $success = (Get-Command code -ErrorAction SilentlyContinue) -ne $null }
        "googlechrome" { $success = Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe" }
        "nodejs-lts" { $success = (Get-Command node -ErrorAction SilentlyContinue) -ne $null }
        "python" { $success = (Get-Command python -ErrorAction SilentlyContinue) -ne $null }
        "postgresql" { $success = (Get-Command psql -ErrorAction SilentlyContinue) -ne $null }
        "microsoft-windows-terminal" { $success = (Get-Command wt -ErrorAction SilentlyContinue) -ne $null }
        default { $success = (Get-Command $pkg -ErrorAction SilentlyContinue) -ne $null }
    }
    
    if ($success) {
        Write-Host "[Checkpoint] $pkg installed successfully." -ForegroundColor Magenta
    } else {
        Write-Host "[Checkpoint] $pkg installation may need verification." -ForegroundColor Yellow
    }
}
Write-Host "[Checkpoint] All main packages installation step complete." -ForegroundColor Magenta

# Install Gemini CLI (Google AI)
if (-Not (Get-Command gemini -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Gemini CLI..." -ForegroundColor Yellow
    npm install -g @google/generative-ai-cli
    if (Get-Command gemini -ErrorAction SilentlyContinue) {
        Write-Host "[Checkpoint] Gemini CLI installed successfully." -ForegroundColor Magenta
    } else {
        Write-Host "[Checkpoint] Gemini CLI installation failed or not found." -ForegroundColor Red
    }
}

# Install Codex CLI (OpenAI or custom CLI)
if (-Not (Get-Command codex -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Codex CLI..." -ForegroundColor Yellow
    npm install -g codex-cli
    if (Get-Command codex -ErrorAction SilentlyContinue) {
        Write-Host "[Checkpoint] Codex CLI installed successfully." -ForegroundColor Magenta
    } else {
        Write-Host "[Checkpoint] Codex CLI installation failed or not found." -ForegroundColor Red
    }
}

Write-Host "=== Installation Complete ===" -ForegroundColor Green
Write-Host "[Checkpoint] Main CLI tools installation step complete." -ForegroundColor Magenta
Write-Host "Restart PowerShell or run 'refreshenv' for changes to take effect." -ForegroundColor Cyan

# Install ChatGit CLI (if available)
if (-Not (Get-Command chatgit -ErrorAction SilentlyContinue)) {
    Write-Host "Installing ChatGit CLI..." -ForegroundColor Yellow
    npm install -g chatgit
    if (Get-Command chatgit -ErrorAction SilentlyContinue) {
        Write-Host "[Checkpoint] ChatGit CLI installed successfully." -ForegroundColor Magenta
    } else {
        Write-Host "[Checkpoint] ChatGit CLI installation failed or not found." -ForegroundColor Red
    }
}

# Install NOI CLI (if available)
if (-Not (Get-Command noi -ErrorAction SilentlyContinue)) {
    Write-Host "Installing NOI CLI..." -ForegroundColor Yellow
    npm install -g noi
    if (Get-Command noi -ErrorAction SilentlyContinue) {
        Write-Host "[Checkpoint] NOI CLI installed successfully." -ForegroundColor Magenta
    } else {
        Write-Host "[Checkpoint] NOI CLI installation failed or not found." -ForegroundColor Red
    }
}

# Final test summary
Write-Host "`n=== Test Summary ===" -ForegroundColor Cyan
$testTools = @(
    @{Name='choco'; Command='choco'},
    @{Name='git'; Command='git'},
    @{Name='gh'; Command='gh'},
    @{Name='vscode'; Command='code'},
    @{Name='chrome'; Path='C:\Program Files\Google\Chrome\Application\chrome.exe'},
    @{Name='node'; Command='node'},
    @{Name='python'; Command='python'},
    @{Name='psql'; Command='psql'},
    @{Name='windows-terminal'; Command='wt'},
    @{Name='gemini'; Command='gemini'},
    @{Name='codex'; Command='codex'},
    @{Name='chatgit'; Command='chatgit'},
    @{Name='noi'; Command='noi'}
)

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
