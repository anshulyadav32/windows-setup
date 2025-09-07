# Windows Development Environment Setup

[![Deploy static website](https://github.com/anshulyadav32/windows-setup/actions/workflows/pages.yml/badge.svg)](https://github.com/anshulyadav32/windows-setup/actions/workflows/pages.yml)

This repository provides PowerShell scripts to quickly set up a modern Windows or WSL development environment.

## Features
- Windows: Installs Chocolatey, GitHub CLI (`gh`), Git, Visual Studio Code, Google Chrome, Node.js (LTS), Python, PostgreSQL (`psql`), Windows Terminal, Gemini CLI, Codex CLI
- WSL2 Ubuntu: Installs Node.js LTS, PostgreSQL, Git, GitHub CLI, Python, React

## Usage

### Option 1: One-liner (Recommended)
Open PowerShell as Administrator and run:
```powershell
iwr -useb https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/setup.ps1 | iex
```

Or full command:
```powershell
Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/setup.ps1 | Invoke-Expression
```

For WSL2 Ubuntu setup:
```powershell
iwr -useb https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/wsl.ps1 | iex
```

For devtools install (ChatGit, NOI, etc):
```powershell
iwr -useb https://raw.githubusercontent.com/anshulyadav32/windows-setup/main/modules/devtools/install.ps1 | iex
```

### Option 2: Download and run locally
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
