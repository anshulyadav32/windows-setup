# WSL Installation Guide

This document provides detailed steps for installing and troubleshooting WSL (Windows Subsystem for Linux).

## Installation Steps

1. **Install WSL component**
   ```powershell
   wsl.exe --install --no-distribution
   ```

2. **Restart your computer**
   This step is mandatory for the WSL component to be fully activated.

3. **After restart, set WSL 2 as default**
   ```powershell
   wsl --set-default-version 2
   ```

4. **Install Ubuntu distribution**
   ```powershell
   wsl --install -d Ubuntu
   ```

5. **Complete Ubuntu setup**
   Follow the prompts to create a username and password for your Ubuntu installation.

## Troubleshooting

### Error: WSL_E_WSL_OPTIONAL_COMPONENT_REQUIRED

This error occurs when the WSL component isn't fully installed. Follow these steps:

1. Run the installation command:
   ```powershell
   wsl.exe --install --no-distribution
   ```

2. **Important: Restart your computer**
   This step is mandatory - the WSL component cannot be fully activated without a system restart.

3. After restart, continue with the installation:
   ```powershell
   wsl --set-default-version 2
   wsl --install -d Ubuntu
   ```

### Error: WslRegisterDistribution failed

If you see this error after installing the WSL component, it usually means:
- You need to restart your computer
- There might be virtualization issues in your BIOS

Ensure virtualization is enabled in your BIOS settings and try again after restarting.
