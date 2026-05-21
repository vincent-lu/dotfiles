---
name: brewfile-audit
description: Reconcile Brewfile against what's actually installed on the system — find gaps in both directions, research installability, and walk through decisions interactively.
user_invoked: true
---

# /brewfile-audit

Reconcile the Brewfile against the actual state of the system. The goal is to eliminate drift between what's installed and what the Brewfile declares.

## 1. Gather current state

Run in parallel:

- `brew bundle check --verbose` — what's in the Brewfile but not installed
- `brew leaves | sort` — installed formulae (top-level only)
- `brew list --cask | sort` — installed casks
- `mas list | sort` — installed App Store apps
- `ls /Applications/ | sort` — all apps in the Applications folder

## 2. Detect Brewfile issues

Scan the Brewfile for problems independent of install state:

- **Duplicates:** same entry appearing more than once
- **Detection quirks:** entries that `brew bundle check` flags as missing but `mas list` confirms are present (common with MAS apps — note but don't act)

Report any issues found.

## 3. Diff: installed but not in Brewfile

Compare installed formulae, casks, and /Applications against the Brewfile entries:

### Homebrew-managed (formulae + casks)
Items in `brew leaves` or `brew list --cask` that have no corresponding Brewfile entry. These are already brew-managed — adding them to the Brewfile is straightforward.

### Apps in /Applications not managed by Homebrew or MAS
For each unmanaged app:

1. **Check if it's an iOS/iPad app** (Apple Silicon). These have a `Wrapper/` directory structure instead of `Contents/Info.plist`. iOS apps cannot be managed via Brewfile — categorize them as unmanageable.

2. **Search for a brew cask:** `brew search --cask <name>`. If a candidate is found, verify with `brew info --cask <candidate>` to confirm it's the right app.

3. **Search the App Store:** For apps that might be MAS-distributed, use `mas search "<name>"`. Be aware that `mas search` is fuzzy and often returns unrelated results — cross-reference the app's bundle identifier (from `Info.plist`) against search results when possible.

4. **Get the bundle identifier** for verification:
   - macOS apps: `/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "/Applications/<name>.app/Contents/Info.plist"`
   - iOS apps: find the `Info.plist` inside the `Wrapper/` directory

### System apps
Ignore: Safari, Utilities, and any OS-bundled apps.

## 4. Present findings

Organize results into clear categories:

| Category | Description |
|---|---|
| **Brewfile issues** | Duplicates, detection quirks |
| **Installed via brew, not in Brewfile** | Easy adds — already brew-managed |
| **In /Applications, available as cask** | Can be added to Brewfile |
| **In /Applications, available via MAS** | Can be added to Brewfile with `mas` entry |
| **iOS/iPad apps** | Cannot be managed via Brewfile |
| **No brew/MAS option found** | Must be installed manually |
| **Skipped by choice** | User decided not to track these |

## 5. Walk through decisions interactively

Go category by category, asking the user what to do with each gap:

- **Add to Brewfile** — add the entry to the correct section
- **Remove from system** — note for user to run uninstall (don't run destructive commands without explicit permission)
- **Skip** — leave as-is

Use `AskUserQuestion` with multi-select where appropriate to batch decisions within a category.

## 6. Apply changes to Brewfile

When adding or removing entries:

- **Maintain alphabetical sort order** within each section (Binaries, GUI Applications, App Store Apps)
- **Preserve the three-section structure** with existing comment headers
- Remove any duplicates found in step 2

## 7. Summary

After all changes are applied, show:

- What was added to the Brewfile
- What was removed from the Brewfile
- What remains unmanaged and why (iOS apps, user skips, no brew/MAS option)
- Prompt for staging and committing (do not auto-commit)
