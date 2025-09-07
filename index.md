layout: home
title: win.r-u.live
<link rel="stylesheet" href="/assets/css/mobile.css">

<div class="container">



# Welcome to win.r-u.live

This site provides a Windows PowerShell installer for a modern dev environment.

<a class="button" href="https://github.com/anshulyadav32/win.r-u.live">View on GitHub</a>
<a class="button" href="https://raw.githubusercontent.com/anshulyadav32/win.r-u.live/master/setup.ps1">Download setup.ps1</a>

## Quick Start

1. Open PowerShell as Administrator
2. Run:
   ```powershell
   iwr -useb https://raw.githubusercontent.com/anshulyadav32/win.r-u.live/master/setup.ps1 | iex
   ```
   
   Or full command:
   ```powershell
   Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/anshulyadav32/win.r-u.live/master/setup.ps1 | Invoke-Expression
   ```

## Features
- Installs Chocolatey, GitHub CLI, Git, VS Code, Chrome, Node.js, Python, PostgreSQL, Windows Terminal, Gemini CLI, Codex CLI

---

For Linux SSL install:
```sh
curl -sSL https://win.r-u.live/modules/ssl/install.sh | sudo bash
```

</div>
