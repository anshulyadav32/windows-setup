# wsl.ps1
# This script sets up WSL2 with Ubuntu, and installs Node.js LTS, PostgreSQL, Git, GitHub CLI, Python, and React (via npx create-react-app)

# Enable WSL feature
wsl --install -d Ubuntu

# Wait for Ubuntu to finish installing
Write-Host "Please complete Ubuntu setup in the new window, then re-run this script."

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
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
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

# Run commands in Ubuntu
wsl -d Ubuntu bash -c "$ubuntuCommands"

Write-Host "WSL2 Ubuntu setup complete with Node.js LTS, PostgreSQL, Git, GitHub CLI, Python, React, Docker, DevOps tools, and ChatGPT CLI."

# PowerToys is now installed via the main Windows tools script (install.ps1)
Write-Host "PowerToys installation is handled by the main Windows setup script."