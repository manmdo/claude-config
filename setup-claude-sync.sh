#!/bin/zsh
# =============================================================================
# setup-claude-sync.sh
# =============================================================================
# Sets up Claude Code config sync on a new computer via OneDrive symlinks.
#
# What this script does:
#   - Claude config directory (macOS): ~/.claude/
#   - Symlinks ~/.claude/agents, ~/.claude/commands, ~/.claude/settings.json
#     to the shared OneDrive location so config stays in sync across computers
#   - Copies settings.local.json from the OneDrive template if none exists
#     (settings.local.json is machine-specific and NOT synced)
#
# Windows 11 equivalent: setup-claude-sync.ps1 (config dir: %APPDATA%\Claude\)
#   Requires Developer Mode or PowerShell as Administrator for symlink creation
#
# Prerequisites:
#   - OneDrive signed in and synced
#   - Run once per computer; safe to re-run (skips existing symlinks)
#
# Full new computer setup (run in order):
#   1. Clone all repos
#   gh repo clone manmdo/Man_Dev ~/GitHub/Man_Dev
#   gh repo clone manmdo/MD_RDE_Bootcamp ~/GitHub/MD_RDE_Bootcamp
#   gh repo clone manmdo/StockTracker ~/GitHub/StockTracker
#   gh repo clone manmdo/zds-design ~/GitHub/zds-design
#   gh repo clone manmdo/Daily_Agent ~/GitHub/Daily_Agent
#   gh repo clone manmdo/avideo-docs ~/GitHub/avideo-docs
#   gh repo clone manmdo/Udaplay ~/GitHub/Udaplay
#   gh repo clone manmdo/udacity_multiagent ~/GitHub/udacity_multiagent
#   gh repo clone manmdo/udacity_multiagent1 ~/GitHub/udacity_multiagent1
#   gh repo clone manmdo/udacity_workspace ~/GitHub/udacity_workspace
#   gh repo clone manmdo/udacity_workspace1 ~/GitHub/udacity_workspace1
#   gh repo clone manmdo/udacity_build_project ~/GitHub/udacity_build_project
#   gh repo clone manmdo/POC ~/GitHub/POC
#   gh repo clone manmdo/media-scripts ~/GitHub/media-scripts
#   gh repo clone manmdo/dotfiles ~/GitHub/dotfiles
#   gh repo clone manmdo/claude-config ~/GitHub/claude-config
#   gh repo clone manmdo/cheatsheet-python-A4 ~/GitHub/cheatsheet-python-A4
#   gh repo clone manmdo/Learning ~/GitHub/Learning
#   gh repo clone accenture-rde-lab/capstone-pod-4-northwind ~/GitHub/capstone-pod-4-northwind
#   gh repo clone accenture-rde-lab/rde-pod-4-demo ~/GitHub/rde-pod-4-demo
#
#   2. Copy global CLAUDE.md
#   cp ~/GitHub/Man_Dev/home-CLAUDE.md ~/CLAUDE.md
#
#   3. Run this script (Claude Code config sync)
#   chmod +x ~/Library/CloudStorage/OneDrive-Accenture/Dev_Repository/claude-config/setup-claude-sync.sh
#   ~/Library/CloudStorage/OneDrive-Accenture/Dev_Repository/claude-config/setup-claude-sync.sh
#
#   4. Apply dotfiles (shell config)
#   cp ~/GitHub/dotfiles/.zprofile ~/.zprofile
#   cp ~/GitHub/dotfiles/.zshrc ~/.zshrc
#
#   5. Restore Homebrew packages
#   brew bundle install --file ~/GitHub/dotfiles/Brewfile

set -e

ONEDRIVE_CLAUDE="$HOME/Library/CloudStorage/OneDrive-Accenture/Dev_Repository/claude-config"

if [[ ! -d "$ONEDRIVE_CLAUDE" ]]; then
  echo "ERROR: OneDrive claude-config not found at $ONEDRIVE_CLAUDE"
  echo "Make sure OneDrive is signed in and synced first."
  exit 1
fi

echo "Setting up Claude Code config sync..."

# Helper: back up and symlink a path
link_config() {
  local target="$1"
  local source="$2"

  if [[ -L "$target" ]]; then
    echo "  $target already a symlink, skipping"
    return
  fi

  if [[ -e "$target" ]]; then
    echo "  Backing up existing $target -> ${target}.bak"
    mv "$target" "${target}.bak"
  fi

  ln -s "$source" "$target"
  echo "  Linked: $target -> $source"
}

link_config "$HOME/.claude/agents"       "$ONEDRIVE_CLAUDE/agents"
link_config "$HOME/.claude/commands"     "$ONEDRIVE_CLAUDE/commands"
link_config "$HOME/.claude/settings.json" "$ONEDRIVE_CLAUDE/settings.json"

# settings.local.json is machine-specific — copy the template if none exists
if [[ ! -f "$HOME/.claude/settings.local.json" ]]; then
  cp "$ONEDRIVE_CLAUDE/settings.local.json.template" "$HOME/.claude/settings.local.json"
  echo "  Created settings.local.json from template (review and adjust as needed)"
else
  echo "  settings.local.json already exists, not overwriting"
fi

echo ""
echo "Done. Verify with: ls -la ~/.claude/agents ~/.claude/commands ~/.claude/settings.json"
