layout: home
title: win.r-u.live
<link rel="stylesheet" href="/assets/css/mobile.css">

<div class="container">



# Welcome to win.r-u.live

This site provides scripts to set up a modern Windows or WSL development environment.

<a class="button" href="https://github.com/anshulyadav32/win.r-u.live">View on GitHub</a>
<a class="button" href="https://raw.githubusercontent.com/anshulyadav32/win.r-u.live/master/setup.ps1">Download setup.ps1</a>
<a class="button" href="https://raw.githubusercontent.com/anshulyadav32/win.r-u.live/master/wsl.ps1">Download wsl.ps1</a>

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

For WSL2 Ubuntu setup:
```powershell
iwr -useb https://raw.githubusercontent.com/anshulyadav32/win.r-u.live/master/wsl.ps1 | iex
```

## Features

## ChatGPT CLI Install (Windows)
To install ChatGPT CLI on Windows:
```powershell
npm install -g chatgpt-cli
```

## Edit & Customize
You can edit any script in this repo to add your own tools or settings. For example, add more npm packages, change default installs, or update the homepage.



For Linux SSL install:
```sh
curl -sSL https://win.r-u.live/modules/ssl/install.sh | sudo bash
```

For devtools install (ChatGit, NOI, etc):
```powershell
iwr -useb https://raw.githubusercontent.com/anshulyadav32/win.r-u.live/master/modules/devtools/install.ps1 | iex
```

</div>
