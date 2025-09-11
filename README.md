# Windows Development Environment Setup

[![Deploy static website](https://github.com/anshulyadav32/windows-setup/actions/workflows/pages.yml/badge.svg)](https://github.com/anshulyadav32/windows-setup/actions/workflows/pages.yml)

**🌐 Website: [https://win.r-u.live](https://win.r-u.live)** 

This repository provides PowerShell scripts to quickly set up a modern Windows or WSL development environment.

## Quick Start

### Prerequisites
- Run all scripts in **PowerShell as Administrator** for best results.
- Ensure your system is up to date.

### Windows Dev Tools Setup
1. Run in PowerShell:
   ```powershell
   iwr -useb https://win.r-u.live/ps/setup.ps1 | iex
   ```

   Or download and run locally:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   .\install.ps1
   ```
2. The script will install Scoop, WinGet, and other tools as needed.

### WSL Setup
1. Run `wsl.ps1` to install and configure WSL2 and Ubuntu.
2. Follow the prompts in the Ubuntu window to complete setup.
3. Re-run `wsl.ps1` if instructed for additional configuration.

### Additional Modules
- See the `modules/devtools/install.ps1` for extra dev tool installations.

## Features
- Windows: Installs Scoop, WinGet, Chocolatey, PowerToys, GitHub CLI (`gh`), Git, Visual Studio Code, Google Chrome, Node.js (LTS), Python, PostgreSQL (`psql`), Windows Terminal, Gemini CLI, ChatGPT CLI, Codex CLI
- WSL2 Ubuntu: Installs Node.js LTS, PostgreSQL, Git, GitHub CLI, Python, React, Docker, DevOps tools, ChatGPT CLI

## Usage

## Troubleshooting
- If you encounter admin or permission issues, ensure PowerShell is running as Administrator.
- For Scoop issues, check [Scoop documentation](https://scoop.sh/).

## Repository Structure
- `install.ps1` - Main Windows setup script
- `wsl.ps1` - WSL and Ubuntu setup script
- `modules/devtools/install.ps1` - Additional dev tools
- `website/` - Documentation and web assets

## License
MIT

### Option 2: Individual Components
If you prefer to install specific components directly:

For Windows tools only:
```powershell
iwr -useb https://win.r-u.live/ps/install.ps1 | iex
```

Or with the full URL:
```powershell
iwr -useb https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/install.ps1 | iex
```

For WSL2 Ubuntu setup only:
```powershell
iwr -useb https://win.r-u.live/ps/wsl.ps1 | iex
```

Or with the full URL:
```powershell
iwr -useb https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/wsl.ps1 | iex
```

**Note:** WSL installation REQUIRES a system restart after the initial installation. The script will:
1. Install the WSL optional component
2. Set WSL 2 as the default version
### Kali Linux Kex Desktop (WSL)

To install and launch the Kali Linux desktop environment (Kex) in WSL:

```powershell
iwr -useb https://win.r-u.live/ps/wsl-kal-kex.ps1 | iex
```
Or with the full URL:
```powershell
iwr -useb https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/wsl-kal-kex.ps1 | iex
```

Or run locally:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
./wsl-kal-kex.ps1
```

**Note:** The script will automatically relaunch itself as Administrator if needed. You can run it from any PowerShell window.

The script will:
- Install WSL if missing
- Enable required Windows features
- Install Kali Linux if missing
- Update Kali and install `kali-win-kex`
- Prompt to launch Kex immediately or show the command to launch later
- Prompt for restart or first launch if required
3. Prompt you to restart your computer
4. After restart, run the script again to complete Ubuntu installation

For devtools only (ChatGPT, NOI, ChatGit, etc):
```powershell
iwr -useb https://win.r-u.live/ps/modules/devtools/install.ps1 | iex
```

Or with the full URL:
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
