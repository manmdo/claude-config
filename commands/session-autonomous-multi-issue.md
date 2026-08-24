# SESSION AUTONOMOUS MULTI-ISSUE

Start an autonomous coding session to work through multiple GitHub issues systematically.

**Usage:** `/session-autonomous-multi-issue [filter]`

**Filter Options:**
- `label:label-name` - Work on all issues with specific label
- `milestone:milestone-name` - Work on all issues in milestone
- `epic:issue-number` - Work on all issues linked to an epic
- `project:project-number` - Work on issues from project column
- `issue-list:1,2,3` - Work on specific issue numbers

**Examples:**
```bash
/session-autonomous-multi-issue label:bank-api
/session-autonomous-multi-issue milestone:v2.0
/session-autonomous-multi-issue epic:100
/session-autonomous-multi-issue issue-list:45,46,47
```

## Instructions

### 1. Initialize Multi-Issue Session

1. **Parse Filter Arguments**
   - Extract filter type and value from arguments
   - If no filter provided, show options and recent issues

2. **Fetch Issues from GitHub**
   ```bash
   # By label
   gh issue list --label "label-name" --json number,title,body,labels,state

   # By milestone
   gh issue list --milestone "milestone-name" --json number,title,body,labels,state

   # By epic (issues that reference epic number)
   gh issue list --search "milestone epic-name" --json number,title,body,labels,state

   # Specific issues
   gh issue view 1,2,3 --json number,title,body,labels,state
   ```

3. **Create Master Session File**
   - File: `.claude/sessions/YYYY-MM-DD-HHMM-multi-issue-[filter].md`
   - Track overall progress across all issues

```markdown
# Multi-Issue Session: [Filter Description]

## Session Info
- **Started**: [DATE TIME]
- **Filter**: [filter type and value]
- **Total Issues**: [count]
- **Completed**: 0
- **In Progress**: 0
- **Failed**: 0

## Issues in Queue
- [ ] #1 - Issue Title 1
- [ ] #2 - Issue Title 2
- [ ] #3 - Issue Title 3

## Execution Log
[Will be updated as issues are processed]
```

4. **Confirm with User**
   - Display list of issues to be processed
   - Show estimated order of execution
   - Ask for confirmation to proceed
   - Allow user to reorder or exclude issues

### 2. Process Each Issue (Autonomous Loop)

For each issue in the queue, execute this workflow:

#### Step 1: Start Issue Session
```bash
# Start session for issue
/session-start [issue-number]
```

This will:
- Create feature branch: `[type]/[number]-[description]`
- Create session file
- Move issue to "In Progress"
- Load acceptance criteria

#### Step 2: Analyze and Plan
1. **Read issue details carefully**
   - Title, description, acceptance criteria
   - Labels, linked PRs, comments

2. **Use appropriate agent for analysis**
   ```
   If issue type is:
   - feature → use business-analysts or software-engineer
   - bug → use researcher or debugging-specialist
   - refactor → use code-refactoring-specialist
   - security → use security-auditor
   - performance → use performance-engineer
   - documentation → use technical-writer
   ```

3. **Create implementation plan**
   - Use task breakdown tools to decompose work
   - Consider dependencies and risks
   - Estimate complexity
   - Identify project-specific build/test requirements from README or documentation

#### Step 3: Implement Solution
1. **Delegate to specialized agents**
   - Use the appropriate internal agents for the implementation
   - Follow project-specific coding standards from CLAUDE.md or README
   - Ensure adherence to DRY and KISS principles

2. **Track progress**
   ```bash
   /session-update [progress notes]
   ```
   - Update after major milestones
   - Document blockers immediately

3. **Write and run tests**
   - Detect project test framework from package.json, requirements.txt, etc.
   - Create tests appropriate to the language/framework
   - Run tests using project-specific commands

#### Step 4: Quality Checks
1. **Run all checks** (auto-detect from project configuration)
   ```bash
   # Python projects
   pytest tests/
   black --check .
   flake8 .
   mypy .

   # Node.js projects
   npm test
   npm run lint
   npm run type-check

   # Go projects
   go test ./...
   go vet ./...
   gofmt -d .

   # Rust projects
   cargo test
   cargo clippy
   cargo fmt --check

   # Java projects
   mvn test
   mvn checkstyle:check

   # Security audit (language-specific)
   # Python: safety check, bandit
   # Node.js: npm audit
   # Go: gosec
   # Use security-auditor agent for complex reviews
   ```

2. **Review with code-quality-reviewer agent**
   - Code quality review
   - Architecture validation
   - Best practices check
   - Language-specific idiom compliance

#### Step 5: Push and Create PR
```bash
# Push code
/code-push "Complete implementation for issue #[number]"

# End session (will create PR if complete)
/session-end
```

This will:
- Review acceptance criteria
- Run pre-PR checks
- Create pull request
- Move issue to "In Review"
- Update master session file

#### Step 6: Review and Fix (If Needed)
1. **Check for CI failures**
   ```bash
   # Monitor PR checks
   gh pr checks
   ```

2. **If failures exist:**
   ```bash
   # Fix issues
   # Make changes

   # Update PR
   /pr-update "fix: address CI failures"
   ```

3. **Self-review PR**
   - Use code-quality-reviewer agent for review
   - Check diff for unintended changes
   - Verify all acceptance criteria met
   - Ensure no linting errors or warnings
   - Check for security vulnerabilities

#### Step 7: Merge PR
```bash
# Check PR status
gh pr view [PR-number] --json mergeable,reviews

# If ready to merge
gh pr merge [PR-number] --squash --delete-branch

# Or wait for review if configured
```

Issue moves to "Done" automatically when merged.

#### Step 8: Update Master Session
Append to master session file:
```markdown
### Issue #[number] - [TITLE] - ✓ COMPLETED

**Time**: [start] - [end] ([duration])
**Branch**: [branch-name]
**PR**: #[pr-number]
**Status**: Merged

**Acceptance Criteria**: [X/Y] complete
**Commits**: [count]
**Files Changed**: [count]

**Summary**: [what was accomplished]
**Challenges**: [any issues encountered]
**Lessons**: [insights gained]
```

### 3. Handle Blockers and Failures

If an issue cannot be completed:

1. **Document the blocker**
   ```bash
   /session-update "BLOCKED: [reason]"
   ```

2. **Update master session**
   ```markdown
   ### Issue #[number] - [TITLE] - ❌ BLOCKED

   **Blocker**: [description]
   **Actions Needed**: [what needs to happen]
   **Skip for now**: Yes/No
   ```

3. **Ask user for guidance**
   - Skip and continue to next issue?
   - Stop session and wait for resolution?
   - Create dependent issue?

4. **Options:**
   - **Skip**: Move to next issue, keep current in "In Progress"
   - **Stop**: End multi-issue session, preserve state
   - **Partial**: Commit WIP, create PR as draft, move on

### 4. Complete Multi-Issue Session

After processing all issues:

1. **Generate Session Summary**
```markdown
## Multi-Issue Session Summary

**Duration**: [total time]
**Filter**: [filter used]

### Statistics
- **Total Issues**: [count]
- **Completed**: [count] ([percentage]%)
- **Blocked**: [count]
- **Failed**: [count]

### Completed Issues
- ✓ #1 - Title ([PR #X]) - [duration]
- ✓ #2 - Title ([PR #Y]) - [duration]

### Blocked Issues
- ❌ #3 - Title - [blocker reason]

### Overall Metrics
- **Total PRs Created**: [count]
- **Total PRs Merged**: [count]
- **Total Commits**: [count]
- **Total Files Changed**: [count]
- **Lines Added**: [count]
- **Lines Removed**: [count]

### Key Accomplishments
- [Major achievements]

### Patterns Observed
- [Recurring themes or issues]

### Technical Debt Created
- [Any shortcuts or TODOs]

### Recommendations
- [Suggestions for future work]

### Next Steps
- [What should happen next]
```

2. **Generate Summary Report**
   ```bash
   # Create summary markdown
   # Include links to all PRs
   # Include metrics and insights
   ```

3. **Clean up**
   - Ensure on main branch
   - Pull latest changes
   - Clear .current-session

## Autonomous Decision Making

The agent should make these decisions autonomously:

### When to Skip
- Issue is already in progress by another user
- Issue has unresolved dependencies
- Issue requires external input/clarification
- Issue is blocked by failed CI on dependency

### When to Stop Completely
- Critical failure in development environment
- Multiple consecutive failures (3+)
- User intervention explicitly required
- Major architectural decision needed

### When to Request Help
- Acceptance criteria unclear
- Multiple valid implementation approaches
- Security concerns identified
- Breaking changes required

## Parallelization Strategy

For independent issues:
- Analyze all issues upfront
- Identify dependencies
- Work on independent issues in parallel using multiple agents
- Merge in dependency order

## Progress Monitoring

Display real-time progress:
```
Multi-Issue Session Progress:
[████████░░] 4/5 issues (80%)

✓ #45 - Add validation (PR #101) - Merged
✓ #46 - Fix calculation (PR #102) - Merged
✓ #47 - Update docs (PR #103) - Merged
→ #48 - Refactor service (In Progress)
  #49 - Add tests (Queued)

Current: Implementing service refactoring (60% complete)
Time Elapsed: 2h 15m
Estimated Remaining: 45m
```

## Error Recovery

If session is interrupted:
1. Master session file preserves state
2. Can resume with same command
3. Skips completed issues
4. Continues from last in-progress or next queued

## Configuration Options

Allow user to configure:
- Auto-merge if all checks pass (default: false)
- Skip issues on blocker (default: false)
- Max parallel issues (default: 1)
- Request review before merge (default: true)
- Stop on first failure (default: false)

## Example Usage

```bash
# Work through all backend-api issues
/session-autonomous-multi-issue label:backend-api

# Work through frontend issues
/session-autonomous-multi-issue label:frontend

# Work through all issues in current sprint
/session-autonomous-multi-issue milestone:v1.0

# Output example:
# Found 5 issues with label 'backend-api':
# 1. #45 - Add input validation
# 2. #46 - Fix calculation logic
# 3. #47 - Update API documentation
# 4. #48 - Refactor service layer
# 5. #49 - Add integration tests
#
# Detected project type: Python FastAPI
# Estimated time: 3-4 hours
# Proceed? (y/n)
```

## Auto-Detection Features

**Project Type Detection:**
- Python: Look for requirements.txt, setup.py, pyproject.toml
- Node.js: Look for package.json
- Go: Look for go.mod
- Rust: Look for Cargo.toml
- Java: Look for pom.xml, build.gradle
- .NET: Look for *.csproj, *.sln

**Test Framework Detection:**
- Python: pytest, unittest, tox
- Node.js: jest, mocha, cypress
- Go: built-in testing
- Rust: built-in testing
- Java: JUnit, TestNG

**Linting/Formatting Detection:**
- Python: black, flake8, mypy, isort
- Node.js: eslint, prettier, typescript
- Go: gofmt, golint, vet
- Rust: rustfmt, clippy
- Java: checkstyle, spotbugs

## Notes

- Each issue gets its own feature branch and session file
- Master session file tracks overall progress
- Can pause and resume at any time
- Failed issues don't block the queue
- All standard code quality checks apply (language-specific)
- Uses specialized agents based on programming language
- Maintains full audit trail for all changes
- Follows project-specific conventions from CLAUDE.md/README
- Automatically detects and uses appropriate build/test commands
