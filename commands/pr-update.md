# Update Pull Request

Push new changes to an existing pull request and optionally update PR description.

**Usage:** `/pr-update [message]`

- `message`: Optional commit message for the changes (will prompt if not provided)

## Instructions

1. Verify we're on a feature branch with an open PR
2. Check for uncommitted changes
3. Run pre-push checks (typecheck, lint, tests)
4. Commit and push changes
5. Optionally update PR description with new changes
6. Display updated PR status

## Execution

```bash
# Get current branch and verify it's not main
BRANCH=$(git branch --show-current)
if [ "$BRANCH" = "main" ]; then
  echo "ERROR: Cannot update PR from main branch"
  exit 1
fi

# Check for open PR
PR_NUMBER=$(gh pr view --json number -q .number 2>/dev/null)
if [ -z "$PR_NUMBER" ]; then
  echo "ERROR: No open PR found for branch $BRANCH"
  echo "Use /pr-create to create a new PR"
  exit 1
fi

# Check for changes
if [ -z "$(git status --porcelain)" ]; then
  echo "No changes to commit"
  exit 0
fi

# Run checks
echo "Running pre-push checks..."
pnpm typecheck && pnpm lint && pnpm test

# Stage all changes
git add -A

# Show what will be committed
echo "Changes to be committed:"
git status --short

# Commit with message
git commit -m "$MESSAGE"

# Push to remote
git push origin $BRANCH

# Get new commits
NEW_COMMITS=$(git log origin/main..$BRANCH --oneline | head -5)

# Display result
echo ""
echo "PR #$PR_NUMBER updated successfully"
echo "Branch: $BRANCH"
echo ""
echo "Recent commits:"
echo "$NEW_COMMITS"
echo ""
echo "View PR: https://github.com/TpISENT/Global-Solar-Mini-ERP/pull/$PR_NUMBER"
```

## Commit Message Guidelines

Follow conventional commits format:

- `feat: add user authentication`
- `fix: correct order total calculation`
- `refactor: simplify payment service`
- `test: add unit tests for invoice service`
- `docs: update API documentation`
- `chore: update dependencies`

Include issue reference when relevant:
- `feat: add login form (#123)`
- `fix: resolve credit limit bug (fixes #456)`

## Handling Review Feedback

When addressing review comments:

1. Read all review comments carefully
2. Make requested changes
3. Use `/pr-update` to push changes
4. Reply to review comments explaining changes
5. Request re-review if needed

## Notes

- Always run checks before pushing to avoid CI failures
- Keep commits focused and atomic
- Squash commits if requested by reviewer
- Use `git commit --amend` for small fixes to previous commit
