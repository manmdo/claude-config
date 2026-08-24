Manage work sessions with full traceability. Each session tracks goals, activities, documentation changes, and git commits in a structured log stored at `~/.claude/worksessions/`.

Arguments: $ARGUMENTS

---

## Sub-commands

Parse the first word of `$ARGUMENTS` as the sub-command. If no arguments are given, run the **Interactive Wizard**.

---

### `start [goal text]`

1. Check whether `~/.claude/worksessions/current.md` already exists.
   - If it does, read it and ask: "A session is already active (goal: [goal]). Close it first, or continue with it?"
   - If continuing, stop here. If closing, run the `end` flow first, then proceed.

2. Detect context:
   - Run `pwd` to get the current directory.
   - Run `git rev-parse --show-toplevel 2>/dev/null` to detect if inside a git repo.
   - If in a git repo, run `git branch --show-current` and `git log -1 --oneline`.

3. Determine the goal:
   - Use everything after `start` in `$ARGUMENTS` as the goal.
   - If no goal text was given, ask: "What is the goal for this session?"

4. Generate a session ID: `YYYY-MM-DD-HHmm` from the current timestamp.

5. Write `~/.claude/worksessions/current.md` with this exact structure:

```
# Work Session: [SESSION_ID]

| Field       | Value                        |
|-------------|------------------------------|
| Date        | [YYYY-MM-DD]                 |
| Start Time  | [HH:MM]                      |
| End Time    |                              |
| Duration    |                              |
| Project Dir | [cwd]                        |
| Git Repo    | [repo root or N/A]           |
| Git Branch  | [branch or N/A]              |
| Git HEAD    | [hash + message or N/A]      |

## Goal
[goal text]

## Activities
<!-- Timestamped log of what was done -->

## Documentation Changes
<!-- Files updated with descriptions -->

## Code Changes
<!-- Summary of code modifications -->

## Git Commits
<!-- Commits made during this session -->

## Notes
<!-- Free-form observations -->

## Summary
<!-- Filled in when session ends -->
```

6. Confirm: "Session started. Goal: [goal]. Log at ~/.claude/worksessions/current.md"
   Show a tip: "Use `/session log <activity>`, `/session doc <file> <desc>`, `/session commit`, or `/session end`."

---

### `log [activity description]`

1. Read `~/.claude/worksessions/current.md`. If missing, say "No active session — use `/session start` first."
2. Get current time (HH:MM).
3. Append under `## Activities` (preserve existing entries):
   ```
   - **[HH:MM]** [activity description]
   ```
4. Write the updated file.
5. Confirm: "Logged: [activity]"

---

### `doc [file path] [description]`

1. Read `~/.claude/worksessions/current.md`. If missing, say "No active session."
2. Get current time (HH:MM).
3. Append under `## Documentation Changes`:
   ```
   - **[HH:MM]** `[file path]` — [description]
   ```
4. Write the updated file.
5. Confirm: "Documentation change recorded."

---

### `code [description]`

1. Read `~/.claude/worksessions/current.md`. If missing, say "No active session."
2. Get current time (HH:MM).
3. Optionally run `git diff --stat HEAD` to get a summary of changed files.
4. Append under `## Code Changes`:
   ```
   - **[HH:MM]** [description]
     [git diff --stat output if available]
   ```
5. Write the updated file.
6. Confirm: "Code change recorded."

---

### `commit [optional message]`

1. Read `~/.claude/worksessions/current.md`. If missing, say "No active session."
2. Run `git status` and `git diff --stat` — show the user what will be committed.
3. If no changes exist, say "Nothing to commit."
4. Determine the commit message:
   - Use everything after `commit` in `$ARGUMENTS` if provided.
   - Otherwise ask: "Commit message?"
5. Run `git add -A` and `git commit -m "[message]"`.
6. Capture the commit hash from output.
7. Get current time (HH:MM).
8. Append under `## Git Commits` in `current.md`:
   ```
   - **[HH:MM]** `[short hash]` — [message]
   ```
9. Also append to `## Activities`:
   ```
   - **[HH:MM]** Git commit: [message] ([short hash])
   ```
10. Write the updated file.
11. Confirm: "Committed: [hash] — [message]"

---

### `note [text]`

1. Read `~/.claude/worksessions/current.md`. If missing, say "No active session."
2. Get current time (HH:MM).
3. Append under `## Notes`:
   ```
   - **[HH:MM]** [text]
   ```
4. Write the updated file.
5. Confirm: "Note added."

---

### `end`

1. Read `~/.claude/worksessions/current.md`. If missing, say "No active session to close."
2. Run `git status --short` — if there are uncommitted changes, show them and ask:
   "You have uncommitted changes. Commit before closing? [Y/n]"
   - If yes, run the `commit` flow.
3. Run `git diff HEAD~1..HEAD --stat 2>/dev/null` to capture a final code change summary and append to `## Code Changes` if not already captured.
4. Ask: "Brief summary of this session? (or press Enter to auto-generate from activities)"
   - If the user provides text, use it.
   - If the user presses Enter, synthesize a 2–4 sentence summary from the Activities list.
5. Fill in the `## Summary` section with the summary text.
6. Calculate end time and duration (start time is in the header).
7. Fill in `End Time` and `Duration` in the header table.
8. Generate an archive filename:
   - Read the session ID from the header (e.g., `2026-04-23-1430`).
   - Archive path: `~/.claude/worksessions/[SESSION_ID].md`
9. Write the completed document to the archive path.
10. Delete `~/.claude/worksessions/current.md`.
11. Append a one-line entry to `~/.claude/worksessions/index.md` (create if missing):
    ```
    | [date] | [HH:MM]–[HH:MM] | [project dir basename] | [goal — truncated to 60 chars] | [SESSION_ID].md |
    ```
    If the file was just created, prepend this header first:
    ```
    # Session Index
    
    | Date | Time | Project | Goal | File |
    |------|------|---------|------|------|
    ```
12. Confirm: "Session closed. Archive: ~/.claude/worksessions/[SESSION_ID].md"
    Show the summary.

---

### `status`

1. Check if `~/.claude/worksessions/current.md` exists.
   - If not: "No active session. Use `/session start [goal]` to begin one."
2. Read the file and display:
   - Goal
   - Start time and elapsed time
   - Number of activity entries
   - Last 3 activity entries
   - Number of git commits this session
   - Current `git status --short` output (if in a git repo)

---

### `list`

1. Read `~/.claude/worksessions/index.md`.
   - If missing: "No sessions recorded yet."
2. Display the last 15 sessions as a formatted table.
3. Offer: "View a session in detail? Enter session ID or filename."
   - If the user responds with a session ID, read and display that session file.

---

### `view [session ID or filename]`

1. Resolve the path: `~/.claude/worksessions/[argument].md`
   - If not found, try `~/.claude/worksessions/[argument]`
   - If still not found, list available sessions from the index.
2. Read and display the full session document.

---

### Interactive Wizard (no arguments)

Present a menu:
```
Work Session Manager
────────────────────
1. Start a new session
2. Log an activity
3. Record a documentation change
4. Record a code change
5. Commit to git
6. Add a note
7. View session status
8. Close current session
9. List recent sessions
```
Ask: "Choose an option (1–9):" and run the corresponding sub-command flow.
If there is no active session, only options 1, 8 (shows "no active session"), and 9 are relevant — note this to the user.

---

## Session Document Example

```markdown
# Work Session: 2026-04-23-1430

| Field       | Value                                    |
|-------------|------------------------------------------|
| Date        | 2026-04-23                               |
| Start Time  | 14:30                                    |
| End Time    | 16:15                                    |
| Duration    | 1h 45m                                   |
| Project Dir | ~/Development/GitHub/rde-pod-4-demo      |
| Git Repo    | ~/Development/GitHub/rde-pod-4-demo      |
| Git Branch  | feature/pipeline-scaffold                |
| Git HEAD    | a3f91bc feat: initial project structure  |

## Goal
Scaffold the 6-module pipeline for rde-pod-4-demo with stub implementations

## Activities
- **14:30** Session started
- **14:45** Created solution/pipeline/ directory structure with 6 module stubs
- **15:10** Implemented Module 1: artifact loader with file I/O
- **15:40** Implemented Module 2: LLM synthesizer stub with Anthropic SDK
- **16:00** Git commit: pipeline scaffold (a3f91bc)
- **16:10** Updated CLAUDE.md with new module structure

## Documentation Changes
- **16:10** `CLAUDE.md` — Added pipeline module descriptions and entry points
- **16:12** `solution/README.md` — Created with setup and run instructions

## Code Changes
- **16:00** Initial pipeline scaffold
  solution/pipeline/module1_loader.py    | 45 ++++
  solution/pipeline/module2_synth.py     | 38 +++
  solution/pipeline/__init__.py          |  3 +

## Git Commits
- **16:00** `a3f91bc` — feat: scaffold 6-module pipeline with stubs

## Notes
- Module 3 (conflict detection) needs the three hard rules from CLAUDE.md
- Azure OpenAI keys still need env var setup

## Summary
Scaffolded the full 6-module pipeline structure for rde-pod-4-demo. Implemented
Modules 1 and 2 with working stubs. Updated documentation to reflect new
structure. Module 3 (conflict detection) is next — logic defined in CLAUDE.md.
```
