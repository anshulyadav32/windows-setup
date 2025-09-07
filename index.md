<script>
// Add copy buttons to all code blocks
document.addEventListener('DOMContentLoaded', function() {
   document.querySelectorAll('pre > code').forEach(function(codeBlock) {
      var button = document.createElement('button');
      button.className = 'copy-btn';
      button.textContent = 'Copy';
      button.style = 'float:right; margin:4px; font-size:0.9em;';
      button.onclick = function() {
         navigator.clipboard.writeText(codeBlock.textContent);
         button.textContent = 'Copied!';
         setTimeout(function(){ button.textContent = 'Copy'; }, 1200);
      };
      codeBlock.parentNode.insertBefore(button, codeBlock);
   });
});
</script>
---
layout: home
title: win.r-u.live
---
<link rel="stylesheet" href="/assets/css/mobile.css">
<style>
   .container {
      max-width: 600px;
      margin: auto;
      padding: 1rem;
      background: #fff;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
   }
   @media (max-width: 700px) {
      .container {
         max-width: 98vw;
         padding: 0.5rem;
      }
      h1 {
         font-size: 2em;
      }
      pre, code {
         font-size: 0.95em;
      }
      .button {
         width: 100%;
         margin: 0.5em 0;
         font-size: 1em;
      }
   }
    .copy-btn {
       float: right;
       margin: 4px;
       font-size: 0.9em;
       background: #0078d7;
       color: #fff;
       border: none;
       border-radius: 4px;
       padding: 0.3em 0.8em;
       cursor: pointer;
       transition: background 0.2s;
    }
    .copy-btn:hover {
       background: #005fa3;
    }
</style>
<script>
document.addEventListener('DOMContentLoaded', function() {
   document.querySelectorAll('pre > code').forEach(function(codeBlock) {
      var button = document.createElement('button');
      button.className = 'copy-btn';
      button.textContent = 'Copy';
      button.onclick = function() {
         navigator.clipboard.writeText(codeBlock.textContent);
         button.textContent = 'Copied!';
         setTimeout(function(){ button.textContent = 'Copy'; }, 1200);
      };
      codeBlock.parentNode.insertBefore(button, codeBlock);
   });
});
</script>
layout: home
title: win.r-u.live
<link rel="stylesheet" href="/assets/css/mobile.css">

<div class="container">
   <header style="text-align:center; margin-bottom:2em;">
      <h1>win.r-u.live</h1>
      <p>A modern Windows & WSL dev environment installer</p>
      <div style="margin:1em 0;">
         <a class="button" href="https://github.com/anshulyadav32/win.r-u.live">View on GitHub</a>
         <a class="button" href="https://raw.githubusercontent.com/anshulyadav32/win.r-u.live/master/setup.ps1">Download setup.ps1</a>
         <a class="button" href="https://raw.githubusercontent.com/anshulyadav32/win.r-u.live/master/wsl.ps1">Download wsl.ps1</a>
      </div>
   </header>

   <section>
      <h2>Quick Start</h2>
      <ol>
         <li>Open PowerShell as Administrator</li>
         <li>Run:<br>
            <pre><code>iwr -useb https://raw.githubusercontent.com/anshulyadav32/win.r-u.live/master/setup.ps1 | iex</code></pre>
            <span style="font-size:0.95em;">Or:</span>
            <pre><code>Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/anshulyadav32/win.r-u.live/master/setup.ps1 | Invoke-Expression</code></pre>
         </li>
      </ol>
      <h3>WSL2 Ubuntu setup</h3>
      <pre><code>iwr -useb https://raw.githubusercontent.com/anshulyadav32/win.r-u.live/master/wsl.ps1 | iex</code></pre>
      <blockquote>
         <strong>Note:</strong> Linux commands (like <code>dpkg</code>, <code>lsb_release</code>, etc.) must run inside Ubuntu, not in Windows PowerShell. The script will handle this automatically if you run it as shown above.
      </blockquote>
   </section>

   <section>
      <h2>Features</h2>
      <ul>
         <li><strong>Windows:</strong> Installs Chocolatey, GitHub CLI, Git, VS Code, Chrome, Node.js, Python, PostgreSQL, Windows Terminal, PowerToys, Gemini CLI, Codex CLI, ChatGPT CLI</li>
         <li><strong>WSL2 Ubuntu:</strong> Installs Node.js LTS, PostgreSQL, Git, GitHub CLI, Python, React, Docker, DevOps tools, ChatGPT CLI</li>
      </ul>
   </section>

   <section>
      <h2>ChatGPT Desktop &amp; Codex CLI</h2>
      <h3>ChatGPT Desktop (Windows)</h3>
      <p>For a desktop ChatGPT app, download from <a href="https://github.com/lencx/ChatGPT/releases" target="_blank">lencx/ChatGPT</a> and install.</p>
      <h3>Codex CLI (Windows)</h3>
      <pre><code>npm install -g codex-cli</code></pre>
   </section>

   <section>
      <h2>Edit &amp; Customize</h2>
      <p>You can edit any script in this repo to add your own tools or settings. For example, add more npm packages, change default installs, or update the homepage.</p>
   </section>

   <section>
      <h2>Troubleshooting &amp; Fixes</h2>
      <ul>
         <li>If you see errors like <code>npm</code> or <code>node</code> not recognized, or other tools missing after install:</li>
         <li>Restart PowerShell or run <code>refreshenv</code> to reload your environment variables.</li>
         <li>Check Node.js and npm are installed:<br>
            <pre><code>node -v
   <section>
         </li>
         <li>If these commands fail, install Node.js manually or check your PATH.</li>
         <li>Re-run the setup script after confirming tools are available.</li>
      </ul>
      <p>For more help, visit <a href="https://win.r-u.live">win.r-u.live</a> or the <a href="https://github.com/anshulyadav32/win.r-u.live">GitHub repo</a> for issues and solutions.</p>
   </section>

   <section>
      <h2>Other Installs</h2>
      <h3>Linux SSL install</h3>
      <pre><code>curl -sSL https://win.r-u.live/modules/ssl/install.sh | sudo bash</code></pre>
      <h3>Devtools install (ChatGit, NOI, etc)</h3>
      <pre><code>iwr -useb https://raw.githubusercontent.com/anshulyadav32/win.r-u.live/master/modules/devtools/install.ps1 | iex</code></pre>
   </section>
</div>
      <h2>Other Installs</h2>
      <h3>Linux SSL install</h3>
      <pre><code>curl -sSL https://win.r-u.live/modules/ssl/install.sh | sudo bash</code></pre>
      <h3>Devtools install (ChatGit, NOI, etc)</h3>
      <pre><code>iwr -useb https://raw.githubusercontent.com/anshulyadav32/win.r-u.live/master/modules/devtools/install.ps1 | iex</code></pre>
   </section>
</main>
For Linux SSL install:
```sh
curl -sSL https://win.r-u.live/modules/ssl/install.sh | sudo bash
```

For devtools install (ChatGit, NOI, etc):
```powershell
iwr -useb https://raw.githubusercontent.com/anshulyadav32/win.r-u.live/master/modules/devtools/install.ps1 | iex
```

</div>
