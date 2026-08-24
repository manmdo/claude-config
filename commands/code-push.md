# Push Code to Remote

Commit and push code changes to the remote repository.

**Usage:** `/code-push [message]`

- `message`: Commit message (will prompt if not provided)

## Instructions

1. Verify we're not on main branch (protect main)
2. Check for uncommitted changes
3. Run pre-push checks (typecheck, lint)
4. Stage and commit changes with proper message
5. Push to remote with tracking
6. Display push summary

## Execution

```bash
# Get current branch
BRANCH=$(git branch --show-current)

# Protect main branch
if [ "$BRANCH" = "main" ]; then
  echo "ERROR: Direct pushes to main are not allowed"
  echo "Create a feature branch with /issue-start first"
  exit 1
fi

# Check for changes
if [ -z "$(git status --porcelain)" ]; then
  echo "No changes to commit"
  git status
  exit 0
fi

# Run pre-push checks
echo "Running pre-push checks..."
pnpm typecheck
if [ $? -ne 0 ]; then
  echo "ERROR: TypeScript check failed. Fix errors before pushing."
  exit 1
fi

pnpm lint
if [ $? -ne 0 ]; then
  echo "ERROR: Lint check failed. Fix errors before pushing."
  exit 1
fi

# Show changes
echo ""
echo "Changes to be committed:"
git status --short
echo ""

# Stage all changes
git add -A

# Commit
git commit -m "$MESSAGE"

# Push with tracking
git push -u origin $BRANCH

# Display summary
echo ""
echo "Code pushed successfully!"
echo "Branch: $BRANCH"
echo "Remote: origin/$BRANCH"
echo ""

# Check if PR exists
PR_NUMBER=$(gh pr view --json number -q .number 2>/dev/null)
if [ -n "$PR_NUMBER" ]; then
  echo "PR #$PR_NUMBER will be updated automatically"
  echo "View: https://github.com/TpISENT/Global-Solar-Mini-ERP/pull/$PR_NUMBER"
else
  echo "No PR exists for this branch yet"
  echo "Use /pr-create when ready for review"
fi
```

## Commit Message Format

Use conventional commits:

```
type(scope): description

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring
- `test`: Adding tests
- `docs`: Documentation
- `style`: Formatting
- `chore`: Maintenance

**Examples:**
- `feat(auth): add login form validation`
- `fix(orders): correct total calculation with discounts`
- `refactor(services): extract payment logic to service`
- `test(invoice): add unit tests for PDF generation`

## Pre-Push Checklist

- [ ] TypeScript compiles without errors
- [ ] ESLint passes
- [ ] Code follows project conventions
- [ ] No console.logs or debug code
- [ ] No secrets or credentials committed

## Notes

- Always work on feature branches, never directly on main
- Push frequently to avoid large, hard-to-review commits
- Use meaningful commit messages for better git history
- Run `/pr-create` when feature is complete and ready for review
