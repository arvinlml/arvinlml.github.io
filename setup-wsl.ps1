# WSL Integration Script for VS Code
# This script helps you connect VS Code to WSL

# Function to check if WSL is installed
function Check-WSL {
    try {
        $wslInfo = wsl --list -v
        Write-Host "✓ WSL is installed" -ForegroundColor Green
        Write-Host $wslInfo
        return $true
    }
    catch {
        Write-Host "✗ WSL is not installed" -ForegroundColor Red
        Write-Host "Please install WSL first: https://learn.microsoft.com/en-us/windows/wsl/install"
        return $false
    }
}

# Function to install WSL Remote extension
function Install-WSLExtension {
    Write-Host "`nInstalling Remote - WSL extension..." -ForegroundColor Cyan
    code --install-extension ms-vscode-remote.remote-wsl
    Write-Host "✓ Extension installed" -ForegroundColor Green
}

# Function to open workspace in WSL
function Open-InWSL {
    Write-Host "`nOpening workspace in WSL..." -ForegroundColor Cyan
    code --remote wsl+Ubuntu .
    Write-Host "✓ VS Code should now be connected to WSL" -ForegroundColor Green
}

# Function to open WSL terminal
function Open-WSLTerminal {
    Write-Host "`nOpening WSL terminal..." -ForegroundColor Cyan
    wsl
}

# Main menu
Write-Host "`n=== WSL Integration Setup ===" -ForegroundColor Magenta
Write-Host "1. Check WSL Installation"
Write-Host "2. Install Remote - WSL Extension"
Write-Host "3. Open Workspace in WSL"
Write-Host "4. Open WSL Terminal"
Write-Host "5. Run All Setup Steps"
Write-Host "6. Exit"

$choice = Read-Host "`nEnter your choice (1-6)"

switch ($choice) {
    "1" { Check-WSL }
    "2" { Install-WSLExtension }
    "3" { Open-InWSL }
    "4" { Open-WSLTerminal }
    "5" {
        if (Check-WSL) {
            Install-WSLExtension
            Open-InWSL
        }
    }
    "6" { Write-Host "Exiting..." -ForegroundColor Yellow }
    default { Write-Host "Invalid choice" -ForegroundColor Red }
}

Write-Host "`n=== Setup Complete ===" -ForegroundColor Green
