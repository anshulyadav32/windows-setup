# Windows Development Environment Setup

This repository provides a PowerShell script (`setup.ps1`) to quickly set up a modern Windows development environment.

## Features
- Installs Chocolatey (Windows package manager)
- Installs:
  - GitHub CLI (`gh`)
  - Git
  - Visual Studio Code
  - Google Chrome
  - Node.js (LTS)
  - Python
  - PostgreSQL (includes `psql`)
  - Windows Terminal
  - Gemini CLI (Google AI)
  - Codex CLI (OpenAI/custom)

## Usage
1. **Download or clone this repository.**
2. **Open PowerShell as Administrator.**
3. Run:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   .\setup.ps1
   ```

## Optional
- You can request a `.bat` wrapper for double-click installation.

## GitHub Pages
This repo's homepage: [win.r-u.live](https://win.r-u.live)

---

**Note:** Always run as Administrator for full installation.
