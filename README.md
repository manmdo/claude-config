# Claude Code Config Sync

GitHub: https://github.com/manmdo/claude-config

This directory contains Claude Code configuration shared across computers via OneDrive and version-controlled on GitHub.

**Claude config directory:** `~/.claude/` on macOS · `%USERPROFILE%\.claude\` on Windows 11

## What's synced

| Item | Description |
|---|---|
| `agents/` | Custom agent definitions (13 agents) |
| `commands/` | Slash commands (19 commands) |
| `settings.json` | Global permissions and enabled plugins |
| `settings.local.json.template` | Template for machine-specific overrides |

**Not synced (machine-specific):**
- `settings.local.json` — local permission overrides; copy from template and adjust per machine
  - macOS: `~/.claude/settings.local.json`
  - Windows 11: `%USERPROFILE%\.claude\settings.local.json`
- Sessions, history, cache — runtime data, never synced

Skills live in the `Man_Dev` GitHub repo (`Man_Dev/.claude/skills/`), not here.

## Related

- [dotfiles](https://github.com/manmdo/dotfiles) — macOS shell config, Homebrew packages, and personal scripts

---

## New Computer Setup — macOS

Prerequisites: OneDrive signed in and synced, Homebrew installed, `gh` CLI authenticated.

```sh
# 1. Clone all repos
gh repo clone manmdo/Man_Dev ~/GitHub/Man_Dev
gh repo clone manmdo/MD_RDE_Bootcamp ~/GitHub/MD_RDE_Bootcamp
gh repo clone manmdo/StockTracker ~/GitHub/StockTracker
gh repo clone manmdo/zds-design ~/GitHub/zds-design
gh repo clone manmdo/Daily_Agent ~/GitHub/Daily_Agent
gh repo clone manmdo/avideo-docs ~/GitHub/avideo-docs
gh repo clone manmdo/Udaplay ~/GitHub/Udaplay
gh repo clone manmdo/udacity_multiagent ~/GitHub/udacity_multiagent
gh repo clone manmdo/udacity_multiagent1 ~/GitHub/udacity_multiagent1
gh repo clone manmdo/udacity_workspace ~/GitHub/udacity_workspace
gh repo clone manmdo/udacity_workspace1 ~/GitHub/udacity_workspace1
gh repo clone manmdo/udacity_build_project ~/GitHub/udacity_build_project
gh repo clone manmdo/POC ~/GitHub/POC
gh repo clone manmdo/media-scripts ~/GitHub/media-scripts
gh repo clone manmdo/dotfiles ~/GitHub/dotfiles
gh repo clone manmdo/cheatsheet-python-A4 ~/GitHub/cheatsheet-python-A4
gh repo clone manmdo/Learning ~/GitHub/Learning
gh repo clone accenture-rde-lab/capstone-pod-4-northwind ~/GitHub/capstone-pod-4-northwind
gh repo clone accenture-rde-lab/rde-pod-4-demo ~/GitHub/rde-pod-4-demo

# 2. Copy global CLAUDE.md
cp ~/GitHub/Man_Dev/home-CLAUDE.md ~/CLAUDE.md

# 3. Run the sync script (creates symlinks, copies settings template)
chmod +x ~/Library/CloudStorage/OneDrive-Accenture/Dev_Repository/claude-config/setup-claude-sync.sh
~/Library/CloudStorage/OneDrive-Accenture/Dev_Repository/claude-config/setup-claude-sync.sh

# 4. Apply dotfiles (shell config)
cp ~/GitHub/dotfiles/.zprofile ~/.zprofile
cp ~/GitHub/dotfiles/.zshrc ~/.zshrc

# 5. Restore Homebrew packages
brew bundle install --file ~/GitHub/dotfiles/Brewfile
```

---

## New Computer Setup — Windows 11

Prerequisites: OneDrive signed in and synced, Git for Windows installed, `gh` CLI authenticated, PowerShell 5.1+.

> **Note:** Creating symlinks on Windows requires either **Developer Mode** enabled
> (`Settings > System > For Developers > Developer Mode = On`) or running PowerShell
> as Administrator.

```powershell
# 1. Clone all repos
gh repo clone manmdo/Man_Dev "$env:USERPROFILE\GitHub\Man_Dev"
gh repo clone manmdo/MD_RDE_Bootcamp "$env:USERPROFILE\GitHub\MD_RDE_Bootcamp"
gh repo clone manmdo/StockTracker "$env:USERPROFILE\GitHub\StockTracker"
gh repo clone manmdo/zds-design "$env:USERPROFILE\GitHub\zds-design"
gh repo clone manmdo/Daily_Agent "$env:USERPROFILE\GitHub\Daily_Agent"
gh repo clone manmdo/avideo-docs "$env:USERPROFILE\GitHub\avideo-docs"
gh repo clone manmdo/Udaplay "$env:USERPROFILE\GitHub\Udaplay"
gh repo clone manmdo/udacity_multiagent "$env:USERPROFILE\GitHub\udacity_multiagent"
gh repo clone manmdo/udacity_multiagent1 "$env:USERPROFILE\GitHub\udacity_multiagent1"
gh repo clone manmdo/udacity_workspace "$env:USERPROFILE\GitHub\udacity_workspace"
gh repo clone manmdo/udacity_workspace1 "$env:USERPROFILE\GitHub\udacity_workspace1"
gh repo clone manmdo/udacity_build_project "$env:USERPROFILE\GitHub\udacity_build_project"
gh repo clone manmdo/POC "$env:USERPROFILE\GitHub\POC"
gh repo clone manmdo/media-scripts "$env:USERPROFILE\GitHub\media-scripts"
gh repo clone manmdo/dotfiles "$env:USERPROFILE\GitHub\dotfiles"
gh repo clone manmdo/cheatsheet-python-A4 "$env:USERPROFILE\GitHub\cheatsheet-python-A4"
gh repo clone manmdo/Learning "$env:USERPROFILE\GitHub\Learning"
gh repo clone accenture-rde-lab/capstone-pod-4-northwind "$env:USERPROFILE\GitHub\capstone-pod-4-northwind"
gh repo clone accenture-rde-lab/rde-pod-4-demo "$env:USERPROFILE\GitHub\rde-pod-4-demo"

# 2. Copy global CLAUDE.md
Copy-Item "$env:USERPROFILE\GitHub\Man_Dev\home-CLAUDE.md" "$env:USERPROFILE\CLAUDE.md"

# 3. Run the sync script (creates symlinks, copies settings template)
& "$env:OneDriveCommercial\Dev_Repository\claude-config\setup-claude-sync.ps1"
```

---

## Updating settings

After changing `~/.claude/settings.json` or `~/.claude/settings.local.json` on any computer,
copy the updated template back to OneDrive so other computers pick it up:

```sh
# macOS — update template after changing settings.local.json
cp ~/.claude/settings.local.json ~/Library/CloudStorage/OneDrive-Accenture/Dev_Repository/claude-config/settings.local.json.template
```

```powershell
# Windows — update template after changing settings.local.json
Copy-Item "$env:USERPROFILE\.claude\settings.local.json" "$env:OneDriveCommercial\Dev_Repository\claude-config\settings.local.json.template"
```

`settings.json` is symlinked on both macOS and Windows — changes are live on both, no manual copy needed.
