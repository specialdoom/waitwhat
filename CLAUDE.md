# Claude Code Guidelines

## Branching

Always commit new work (features, bug fixes, refactors, etc.) to the `develop` branch.
The `main` branch is only updated via PRs from `develop` when cutting a release.

## Commit messages

All commits must follow the [Conventional Commits](https://www.conventionalcommits.org) format:

```
<type>: <short description>
```

Allowed types:

| Type | When to use |
|---|---|
| `feat` | New feature |
| `fix` | Bug fix |
| `perf` | Performance improvement |
| `refactor` | Code change that is not a feature or fix |
| `test` | Adding or updating tests |
| `docs` | Documentation only |
| `chore` | Dependency updates, config, tooling |
| `ci` | CI/CD changes |
| `revert` | Reverting a previous commit |

PR titles must follow the same format — this is enforced automatically by CI.
