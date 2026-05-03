# waitwhat

An Android app that listens to WhatsApp messages and helps you turn them into todos using AI.

## Features

- **WhatsApp listener** — captures incoming messages from monitored contacts in the background
- **AI-assisted todos** — uses Groq to decide if a message needs a todo, and suggests a due date and priority
- **Auto-create** — optionally create todos automatically without manual intervention
- **Push notifications** — notified when a todo is created; optional daily reminder for pending todos
- **Home screen widget** — glanceable list of your pending todos
- **Feedback form** — report bugs or request features directly from the app

## Requirements

- Android device with WhatsApp installed
- [Groq API key](https://console.groq.com) (free tier available)

## Installation

Download the latest APK from [GitHub Releases](https://github.com/specialdoom/waitwhat/releases) and install it on your device.

> Enable "Install from unknown sources" in your Android settings if prompted.

After installing:

1. Open the app and go to **Settings**
2. Grant **Notification Access** when prompted
3. Enter your **Groq API key**
4. Add the WhatsApp contacts you want to monitor under **Monitored Contacts**

## Development

### Prerequisites

- Flutter SDK (stable channel)
- Android SDK / Android Studio
- A `lib/config.dart` file (see below)

### Config

Create `lib/config.dart` (gitignored):

```dart
const String kGroqApiKey = 'gsk_...';
const String kGithubToken = ''; // PAT with issues:write, for the feedback form
const String kGithubOwner = 'specialdoom';
const String kGithubRepo  = 'waitwhat';
```

### Run

```bash
flutter pub get
flutter run
```

### Test

```bash
flutter test
```

## Contributing

### Commit messages

All commits follow the [Conventional Commits](https://www.conventionalcommits.org) format. PR titles are validated by CI.

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

### Issue labels

| Label | Description |
|---|---|
| `bug` | Something isn't working |
| `enhancement` | New feature or request |
| `performance` | Performance optimisation |
| `memory` | Memory leak or excessive usage |
| `network` | Network / API issue |
| `architecture` | Code structure or correctness |
| `android` | Android-specific issue |
| `feedback` | Submitted via in-app feedback form or by a user |
| `documentation` | Improvements or additions to documentation |
| `ci` | CI/CD workflow changes |

## Releasing

See [RELEASING.md](RELEASING.md).
