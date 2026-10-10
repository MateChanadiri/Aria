# Aria — iOS music app starter

This repository contains an XcodeGen project for the Aria SwiftUI starter app.

## Build with GitHub Actions
1. Create a GitHub repository named `aria`.
2. Upload the contents of this ZIP so that `project.yml`, `Aria/`, and `.github/` are at the repository root.
3. Open **Actions** and run **Build Unsigned IPA** (or push to `main`/`master`).
4. Download the `Aria-Unsigned-IPA` artifact from the workflow run.

## Important limitations
- This is a starter/demo app, not a finished streaming service.
- Demo tracks have no audio files, so playback uses simulated progress until you add local audio-file importing and real library support.
- Lyrics, server streaming, equalizer, crossfade, and word-by-word lyric timing are not implemented yet.
- An unsigned IPA is not directly installable on a normal iPhone without a compatible signing/sideloading method.
- The GitHub workflow assumes a macOS runner with a compatible Xcode installation. If `macos-26` or Xcode 26 is unavailable to your GitHub account, change the runner to a currently available macOS image and select its installed Xcode.
