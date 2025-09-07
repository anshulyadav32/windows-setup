---
layout: home
title: win.r-u.live
---

# Welcome to win.r-u.live

This site provides a Windows PowerShell installer for a modern dev environment.

- [View on GitHub](https://github.com/anshulyadav32/win.r-u.live)
- [Download setup.ps1](https://raw.githubusercontent.com/anshulyadav32/win.r-u.live/master/setup.ps1)

## Quick Start

1. Open PowerShell as Administrator
2. Run:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   iwr -useb https://win.r-u.live/setup.ps1 | iex
   ```

## Features
- Installs Chocolatey, GitHub CLI, Git, VS Code, Chrome, Node.js, Python, PostgreSQL, Windows Terminal, Gemini CLI, Codex CLI

---

For Linux SSL install:
```sh
curl -sSL https://win.r-u.live/modules/ssl/install.sh | sudo bash
```
