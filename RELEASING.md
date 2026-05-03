# Release Process

## Prerequisites

GitHub Secrets must be configured (one-time setup):

| Secret | Description |
|---|---|
| `KEYSTORE_BASE64` | Release keystore encoded as base64 |
| `STORE_PASSWORD` | Keystore store password |
| `KEY_ALIAS` | Key alias (e.g. `waitwhat`) |
| `KEY_PASSWORD` | Key password |
| `GROQ_API_KEY` | Groq API key (`gsk_...`) |
| `FEEDBACK_TOKEN` | GitHub PAT with `issues:write` scope |
| `REPO_OWNER` | GitHub username |
| `REPO_NAME` | Repository name |

## Steps

1. **Merge to main** — open a PR from `develop` to `main` and merge it.

2. **Pull main locally**
   ```bash
   git checkout main
   git pull
   ```

3. **Tag the release**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

4. **Done** — GitHub Actions builds the signed APK and publishes it to GitHub Releases automatically.

> Tagging any branch other than `main` will fail the workflow.

## Versioning

Version is defined in `pubspec.yaml`:
```
version: 1.0.0+1
         ^^^^^  ^ build number (versionCode)
         |
         version name (versionName)
```

Bump both before tagging a release.
