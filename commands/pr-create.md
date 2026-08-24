# Create Pull Request

Create a pull request for the current branch and move the linked issue to "In Review".

**Usage:** `/pr-create`

## Instructions

1. Get current branch name and extract issue number
2. Ensure all changes are committed and pushed
3. Run pre-PR checks (typecheck, lint, tests)
4. Gather commit history since branching from main
5. Create PR with proper template linking to the issue
6. Move issue status to "In Review" in the project
7. Display PR URL and review checklist

## Pre-PR Checks

Before creating PR, verify:
- [ ] All changes committed
- [ ] Branch pushed to remote
- [ ] TypeScript compiles: `pnpm typecheck`
- [ ] Linter passes: `pnpm lint`
- [ ] Tests pass: `pnpm test`

## PR Template

```markdown
## Summary

[Brief description of changes]

Closes #[ISSUE_NUMBER]

## Changes

- Change 1
- Change 2

## Test Plan

- [ ] Unit tests added/updated
- [ ] Manual testing completed
- [ ] E2E tests pass

## Screenshots (if applicable)

## Checklist

- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated (if needed)
- [ ] No console.logs or debug code left

---
🤖 Generated with [Claude Code](https://claude.ai/code)
```

## Execution

```bash
# Get current branch
BRANCH=$(git branch --show-current)

# Extract issue number from branch name (e.g., feature/123-description -> 123)
ISSUE_NUMBER=$(echo $BRANCH | grep -oE '[0-9]+' | head -1)

# Verify branch is pushed
git push -u origin $BRANCH

# Run checks
echo "Running pre-PR checks..."
pnpm typecheck && pnpm lint && pnpm test

# Get commits for this branch
COMMITS=$(git log main..$BRANCH --oneline)

# Create PR
gh pr create \
  --title "[#$ISSUE_NUMBER] PR Title" \
  --body "$(cat <<'EOF'
## Summary

[Description]

Closes #$ISSUE_NUMBER

## Changes

$COMMITS

## Test Plan

- [ ] Tests added/updated
- [ ] Manual testing completed

---
🤖 Generated with [Claude Code](https://claude.ai/code)
EOF
)"

# Get PR number
PR_NUMBER=$(gh pr view --json number -q .number)

# Update project item status to "In Review"
gh project item-edit --project-id <project-id> --id <item-id> --field-id <status-field-id> --single-select-option-id <in-review-option-id>

# Display result
echo ""
echo "Pull Request created: https://github.com/TpISENT/Global-Solar-Mini-ERP/pull/$PR_NUMBER"
echo "Issue #$ISSUE_NUMBER moved to 'In Review'"
echo ""
echo "Next steps:"
echo "1. Request review from team members"
echo "2. Address review feedback with /pr-update"
echo "3. Merge when approved"
```

## Notes

- PR title should be descriptive and include issue number
- Use "Closes #123" to auto-close issue when PR merges
- Issue automatically moves to "Done" when PR is merged (configure in project settings)
- Always run checks before creating PR to avoid failed CI
