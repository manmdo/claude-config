# Create GitHub Issue

Create a new GitHub issue and add it to the project backlog.

**Usage:** `/issue-create [type] [title]`

- `type`: "feature", "bug", "task", or "docs"
- `title`: Brief description of the issue

## Instructions

1. Parse the arguments to get issue type and title
2. If arguments are missing, ask the user for:
   - Issue type (feature/bug/task/docs)
   - Issue title
   - Issue description
3. Create the issue with appropriate labels
4. Add the issue to the GitHub Project (https://github.com/orgs/TpISENT/projects/6)
5. Set the issue status to "Backlog"
6. Display the created issue URL

## Issue Templates

### Feature
```markdown
## Description
[Describe the feature]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Technical Notes
[Any technical considerations]

## Related Documentation
- See `tech-docs/` for specifications
```

### Bug
```markdown
## Description
[Describe the bug]

## Steps to Reproduce
1. Step 1
2. Step 2

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- Browser/OS:
- Node version:
```

### Task
```markdown
## Description
[Describe the task]

## Tasks
- [ ] Task 1
- [ ] Task 2

## Definition of Done
[What needs to be completed]
```

## Execution

```bash
# Get repository info
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)

# Create the issue (gh will prompt for details if not provided)
# Labels based on type: feature -> enhancement, bug -> bug, task -> task, docs -> documentation

# After creating issue, add to project
gh project item-add 6 --owner TpISENT --url <issue-url>

# Set status to Backlog
gh project item-edit --project-id <project-id> --id <item-id> --field-id <status-field-id> --single-select-option-id <backlog-option-id>
```

## Project Configuration

- **Project URL**: https://github.com/orgs/TpISENT/projects/6
- **Status Field Values**: Backlog → Ready → In Progress → In Review → Done

## Notes

- All coding work MUST start with an issue
- Issues must be in the project backlog before work begins
- Use `/issue-start` to begin working on an issue (moves to In Progress)
