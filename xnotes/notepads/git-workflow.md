---
Notepad Name: git
---

# Git Workflow Standards

## Context

- Applied when making any code changes
- Applied when creating new features or fixes
- Applied when managing branches and commits

## Requirements

### Branch Strategy

- `main` - Production branch, protected
- `develop` - Development branch, protected
- Feature branches: `feature/epic-{n}-story-{m}-{feature-name}`
- Bug fixes: `fix/epic-{n}-story-{m}-{bug-description}`
- Releases: `release/v{version}`

### Branch Creation

- Create feature branches from `develop`
- Name branches according to type, epic/story, and description
- Delete branches after merging

### Commit Standards

- Use conventional commits format with story reference:
  - `feat(epic-{n}/story-{m}):` for new features
  - `fix(epic-{n}/story-{m}):` for bug fixes
  - `docs(epic-{n}/story-{m}):` for documentation
  - `test(epic-{n}/story-{m}):` for test additions/modifications
  - `refactor(epic-{n}/story-{m}):` for code refactoring
  - `style(epic-{n}/story-{m}):` for formatting changes
  - `chore(epic-{n}/story-{m}):` for maintenance tasks

### Workflow Steps

1. Create branch from `develop` using proper naming convention
2. Make changes following commit standards with story references
3. Push changes regularly
4. Create PR against `develop` with reference to story
5. Merge only when approved and all tests pass
6. Delete branch after merge
7. Update story status in `.ai/epic-{n}/story-{m}.story.md`

<critical>
  - ALWAYS create appropriate branch before starting work
  - NEVER commit directly to protected branches
  - ALWAYS use conventional commit messages with story references
  - ALWAYS ensure tests pass before creating PR
</critical>

## Examples

<example>
# Good branch names
feature/epic-1-story-2-chessboard-ui
fix/epic-2-story-3-login-validation
release/v1.2.0

# Good commit messages

feat(epic-1/story-2): implement chessboard grid layout
fix(epic-2/story-3): correct email validation regex
docs(epic-1/story-4): update API documentation
test(epic-3/story-1): add unit tests for auth module
</example>

<example type="invalid">
# Bad branch names
new-feature
bugfix
my-branch

# Bad commit messages

added stuff
fixed bug
updated code
WIP
</example>
