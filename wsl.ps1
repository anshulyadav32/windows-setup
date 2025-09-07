# wsl.ps1
# This script sets up WSL2 with Ubuntu, and installs Node.js LTS, PostgreSQL, Git, GitHub CLI, Python, and React (via npx create-react-app)

# Enable WSL feature
wsl --install -d Ubuntu

# Wait for Ubuntu to finish installing
Write-Host "Please complete Ubuntu setup in the new window, then re-run this script."

# The following commands will be run inside Ubuntu
$ubuntuCommands = @"
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git python3 python3-pip postgresql postgresql-contrib
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
npm install -g npx
sudo apt install -y gh
# Install create-react-app globally (optional)
npm install -g create-react-app
"@

# Run commands in Ubuntu
wsl -d Ubuntu bash -c "$ubuntuCommands"

Write-Host "WSL2 Ubuntu setup complete with Node.js LTS, PostgreSQL, Git, GitHub CLI, Python, and React."
