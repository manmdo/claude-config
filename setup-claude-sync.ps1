# =============================================================================
# setup-claude-sync.ps1
# =============================================================================
# Sets up Claude Code config sync on a new Windows computer via OneDrive symlinks.
#
# What this script does:
#   - Claude config directory (Windows 11): %APPDATA%\Claude\
#   - Symlinks %APPDATA%\Claude\agents, commands, settings.json
#     to the shared OneDrive location so config stays in sync across computers
#   - Copies settings.local.json from the OneDrive template if none exists
#     (settings.local.json is machine-specific and NOT synced)
#   - OneDrive path (Accenture): $env:OneDriveCommercial (falls back to $env:OneDrive)
#
# macOS equivalent: setup-claude-sync.sh (config dir: ~/.claude/)
#
# Prerequisites:
#   - OneDrive signed in and synced
#   - Developer Mode enabled (Settings > System > For Developers > Developer Mode)
#     OR run this script as Administrator
#   - Run once per computer; safe to re-run (skips existing symlinks)
#
# Full new computer setup (run in order):
#   1. Clone all repos
#   gh repo clone manmdo/Man_Dev $env:USERPROFILE\GitHub\Man_Dev
#   gh repo clone manmdo/MD_RDE_Bootcamp $env:USERPROFILE\GitHub\MD_RDE_Bootcamp
#   gh repo clone manmdo/StockTracker $env:USERPROFILE\GitHub\StockTracker
#   gh repo clone manmdo/zds-design $env:USERPROFILE\GitHub\zds-design
#   gh repo clone manmdo/Daily_Agent $env:USERPROFILE\GitHub\Daily_Agent
#   gh repo clone manmdo/avideo-docs $env:USERPROFILE\GitHub\avideo-docs
#   gh repo clone manmdo/Udaplay $env:USERPROFILE\GitHub\Udaplay
#   gh repo clone manmdo/udacity_multiagent $env:USERPROFILE\GitHub\udacity_multiagent
#   gh repo clone manmdo/udacity_multiagent1 $env:USERPROFILE\GitHub\udacity_multiagent1
#   gh repo clone manmdo/udacity_workspace $env:USERPROFILE\GitHub\udacity_workspace
#   gh repo clone manmdo/udacity_workspace1 $env:USERPROFILE\GitHub\udacity_workspace1
#   gh repo clone manmdo/udacity_build_project $env:USERPROFILE\GitHub\udacity_build_project
#   gh repo clone manmdo/POC $env:USERPROFILE\GitHub\POC
#   gh repo clone manmdo/media-scripts $env:USERPROFILE\GitHub\media-scripts
#   gh repo clone manmdo/dotfiles $env:USERPROFILE\GitHub\dotfiles
#   gh repo clone manmdo/claude-config $env:USERPROFILE\GitHub\claude-config
#   gh repo clone manmdo/cheatsheet-python-A4 $env:USERPROFILE\GitHub\cheatsheet-python-A4
#   gh repo clone manmdo/Learning $env:USERPROFILE\GitHub\Learning
#   gh repo clone accenture-rde-lab/capstone-pod-4-northwind $env:USERPROFILE\GitHub\capstone-pod-4-northwind
#   gh repo clone accenture-rde-lab/rde-pod-4-demo $env:USERPROFILE\GitHub\rde-pod-4-demo
#
#   2. Copy global CLAUDE.md
#   Copy-Item $env:USERPROFILE\GitHub\Man_Dev\home-CLAUDE.md $env:USERPROFILE\CLAUDE.md
#
#   3. Run this script (Claude Code config sync)
#   & "$env:OneDriveCommercial\Dev_Repository\claude-config\setup-claude-sync.ps1"
#
#   Note: dotfiles shell config (.zprofile, .zshrc) and Homebrew (Brewfile) are macOS-only.
# =============================================================================

$ErrorActionPreference = "Stop"

# Resolve OneDrive path — try commercial (Accenture) first, fall back to personal
$OneDriveClaudeDir = $null
foreach ($candidate in @($env:OneDriveCommercial, $env:OneDrive)) {
    if ($candidate -and (Test-Path "$candidate\Dev_Repository\claude-config")) {
        $OneDriveClaudeDir = "$candidate\Dev_Repository\claude-config"
        break
    }
}

if (-not $OneDriveClaudeDir) {
    Write-Error "ERROR: OneDrive claude-config not found. Make sure OneDrive is signed in and synced first."
    exit 1
}

$ClaudeDir = "$env:USERPROFILE\.claude"

if (-not (Test-Path $ClaudeDir)) {
    Write-Error "ERROR: Claude config directory not found at $ClaudeDir. Install Claude Code first."
    exit 1
}

Write-Host "Setting up Claude Code config sync..."
Write-Host "  OneDrive source: $OneDriveClaudeDir"
Write-Host "  Claude config:   $ClaudeDir"
Write-Host ""

# Helper: back up and create a symlink
function Link-Config {
    param(
        [string]$Target,
        [string]$Source,
        [string]$Type  # "Directory" or "SymbolicLink" (for files)
    )

    if (Test-Path $Target) {
        $item = Get-Item $Target -Force
        if ($item.LinkType -eq "SymbolicLink") {
            Write-Host "  $Target already a symlink, skipping"
            return
        }
        $backup = "${Target}.bak"
        Write-Host "  Backing up existing $Target -> $backup"
        Move-Item $Target $backup -Force
    }

    New-Item -ItemType SymbolicLink -Path $Target -Target $Source | Out-Null
    Write-Host "  Linked: $Target -> $Source"
}

Link-Config "$ClaudeDir\agents"       "$OneDriveClaudeDir\agents"
Link-Config "$ClaudeDir\commands"     "$OneDriveClaudeDir\commands"
Link-Config "$ClaudeDir\settings.json" "$OneDriveClaudeDir\settings.json"

# settings.local.json is machine-specific — copy the template if none exists
$LocalSettings = "$ClaudeDir\settings.local.json"
$Template = "$OneDriveClaudeDir\settings.local.json.template"

if (-not (Test-Path $LocalSettings)) {
    Copy-Item $Template $LocalSettings
    Write-Host "  Created settings.local.json from template (review and adjust as needed)"
} else {
    Write-Host "  settings.local.json already exists, not overwriting"
}

Write-Host ""
Write-Host "Done. Verify with:"
Write-Host "  Get-Item $ClaudeDir\agents, $ClaudeDir\commands, $ClaudeDir\settings.json | Select Name, LinkType, Target"
