# Install ChatGit CLI (if available)
if (-Not (Get-Command chatgit -ErrorAction SilentlyContinue)) {
    Write-Host "Installing ChatGit CLI..." -ForegroundColor Yellow
    npm install -g chatgit
}

# Install NOI CLI (if available)
if (-Not (Get-Command noi -ErrorAction SilentlyContinue)) {
    Write-Host "Installing NOI CLI..." -ForegroundColor Yellow
    npm install -g noi
}

# Install ChatGPT CLI (if available)
if (-Not (Get-Command chatgpt -ErrorAction SilentlyContinue)) {
    Write-Host "Installing ChatGPT CLI..." -ForegroundColor Yellow
    npm install -g chatgpt-cli
}

# Install WinGit extras via Scoop
if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "Installing WinGit extras via Scoop..." -ForegroundColor Yellow
    scoop bucket add extras
    scoop install extras/winget-cli
    
    # Install common tools via winget
    Write-Host "Installing common developer tools via winget..." -ForegroundColor Yellow
    winget install -e --id Microsoft.PowerToys
    winget install -e --id 7zip.7zip
}
