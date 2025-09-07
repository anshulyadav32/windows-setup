# install.ps1
# This script installs Node.js LTS and npm, then installs Gemini CLI and Codex CLI globally

choco install nodejs-lts -y
$env:Path += ";$($env:ProgramFiles)\nodejs"

npm install -g @google/generative-ai-cli
npm install -g codex-cli

Write-Host "Node.js, npm, Gemini CLI, and Codex CLI installed successfully."
