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
