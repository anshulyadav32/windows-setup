# Windows Development Environment Setup

[![Deploy static website](https://github.com/anshulyadav32/windows-setup/actions/workflows/pages.yml/badge.svg)](https://github.com/anshulyadav32/windows-setup/actions/workflows/pages.yml)

**🌐 Website: [https://win.r-u.live](https://win.r-u.live)** 

This repository provides PowerShell scripts to quickly set up a modern Windows or WSL development environment.

## Features
- Windows: Installs Scoop, WinGet, Chocolatey, PowerToys, GitHub CLI (`gh`), Git, Visual Studio Code, Google Chrome, Node.js (LTS), Python, PostgreSQL (`psql`), Windows Terminal, Gemini CLI, ChatGPT CLI, Codex CLI
- WSL2 Ubuntu: Installs Node.js LTS, PostgreSQL, Git, GitHub CLI, Python, React, Docker, DevOps tools, ChatGPT CLI

## Usage

### Quick Setup (Automatic Installation)
Open PowerShell as Administrator and run:
```powershell
iwr -useb https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/setup.ps1 | iex
```

Or full command:
```powershell
Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/setup.ps1 | Invoke-Expression
```

This will automatically install all components:
- Windows Developer Tools (VS Code, Git, Node.js, Python, Docker, etc.)
- WSL2 with Ubuntu + Developer Tools 
- Additional Dev Tools (ChatGPT, NOI CLI, ChatGit, etc.)

### WSL Installation Note

⚠️ **Important**: Installing WSL requires a system restart. The script will:
1. Install the WSL component
2. Prompt you to restart your computer
3. After restart, you'll need to run the script again to complete the installation

See the [WSL Installation Guide](docs/wsl-guide.md) for detailed instructions or troubleshooting.

Note: The script will automatically request administrator privileges if needed.

### Option 2: Individual Components
If you prefer to install specific components directly:

For Windows tools only:
```powershell
iwr -useb https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/install.ps1 | iex
```

For WSL2 Ubuntu setup only:
```powershell
iwr -useb https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/wsl.ps1 | iex
```

**Note:** WSL installation REQUIRES a system restart after the initial installation. The script will:
1. Install the WSL optional component
2. Set WSL 2 as the default version
3. Prompt you to restart your computer
4. After restart, run the script again to complete Ubuntu installation

For devtools only (ChatGPT, NOI, ChatGit, etc):
```powershell
iwr -useb https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/modules/devtools/install.ps1 | iex
```

### Option 3: Download and run locally
1. **Download or clone this repository.**
2. **Open PowerShell as Administrator.**
3. Run:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   .\setup.ps1
   ```

## Optional

## GitHub Pages
This repo's homepage: [win.r-u.live](https://win.r-u.live)


**Note:** Always run as Administrator for full installation.
