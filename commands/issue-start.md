# Start Work on Issue

Begin working on a GitHub issue by creating a branch and moving it to "In Progress".

**Usage:** `/issue-start [issue-number]`

## Instructions

1. Parse the issue number from arguments
2. If not provided, list recent issues from the project backlog or "Ready" status
3. Fetch issue details from GitHub
4. Verify the issue is in "Backlog" or "Ready" status
5. Create a feature branch following naming convention
6. Move issue status to "In Progress" in the project
7. Display issue details and next steps

## Branch Naming Convention

Format: `[type]/[issue-number]-[short-description]`

Examples:
- `feature/123-add-user-authentication`
- `bugfix/456-fix-order-total-calculation`
- `task/789-setup-database-migrations`
- `docs/101-update-api-documentation`

## Execution

```bash
# Get issue details
gh issue view $ISSUE_NUMBER --json title,body,labels,state

# Determine branch type from labels
# enhancement/feature -> feature/
# bug -> bugfix/
# task -> task/
# documentation -> docs/

# Create branch name from issue title (lowercase, replace spaces with hyphens)
BRANCH_NAME="feature/$ISSUE_NUMBER-$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-' | head -c 50)"

# Ensure we're on main and up to date
git checkout main
git pull origin main

# Create and checkout new branch
git checkout -b $BRANCH_NAME

# Update project item status to "In Progress"
gh project item-edit --project-id <project-id> --id <item-id> --field-id <status-field-id> --single-select-option-id <in-progress-option-id>

# Display summary
echo "Started work on issue #$ISSUE_NUMBER"
echo "Branch: $BRANCH_NAME"
echo ""
echo "Next steps:"
echo "1. Make your changes"
echo "2. Use /code-push to push changes"
echo "3. Use /pr-create to create a pull request"
```

## Pre-flight Checks

Before starting:
- [ ] Working directory is clean (no uncommitted changes)
- [ ] Issue exists and is assigned (or unassigned)
- [ ] Issue is in "Backlog" or "Ready" status
- [ ] You're authenticated with gh CLI

## Notes

- Always start work from an issue - this ensures proper tracking
- The branch will be created from the latest `main`
- Use `/session-start` to track your coding session alongside this
