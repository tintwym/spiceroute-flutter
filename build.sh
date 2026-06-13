#!/usr/bin/env bash
# Vercel build script for Flutter web.
#
# Vercel's build container doesn't ship a Flutter toolchain, so we clone a
# pinned stable channel of the SDK on every build. The clone is shallow
# (~150 MB → ~30s) so cold builds stay reasonable.
#
# Environment variables (configure in the Vercel project dashboard):
#   FLUTTER_VERSION   Flutter channel/tag to clone. Defaults to "stable".
#                     Pin to a specific tag (e.g. 3.41.7) for reproducible builds.
#   API_BASE_URL      Base URL of the SpiceRoute backend (e.g. https://api.example.com).
#                     Required for the deployed app to talk to your API.

set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-stable}"
FLUTTER_DIR="${FLUTTER_DIR:-flutter-sdk}"

if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  echo "Cloning Flutter SDK (branch=$FLUTTER_VERSION)..."
  rm -rf "$FLUTTER_DIR"
  git clone --depth 1 --branch "$FLUTTER_VERSION" \
    https://github.com/flutter/flutter.git "$FLUTTER_DIR"
fi

export PATH="$PWD/$FLUTTER_DIR/bin:$PATH"

flutter --version
flutter config --enable-web
flutter pub get

# --no-tree-shake-icons: Flutter's release builds aggressively tree-shake
# Material Icons, keeping only glyphs the analyzer can statically prove
# are used. Codebases that route icons through a field (e.g.
# `ShellDestination.icon` on the top/bottom nav) defeat the analyzer
# and end up with blank boxes in production. Disabling tree-shaking
# adds ~50 KB to the final bundle but guarantees every icon renders.
#
# --pwa-strategy=none: Do not ship the default `flutter_service_worker.js`.
# The default `offline-first` strategy is the #1 source of "I deployed
# but Safari still shows the old build" reports — iOS Safari caches the
# service worker very aggressively, and once a SW is registered it
# intercepts every navigation and serves a stale `main.dart.js` for
# hours/days after a deploy regardless of CDN cache headers.
#
# This app needs the backend for everything (no real offline mode), so
# the SW buys us nothing functional and costs us deploy reliability.
# The Vercel cache headers in `vercel.json` (max-age=0, must-revalidate
# on entry-point files; long max-age on hashed asset directories) are
# now the only caching layer, which is exactly the right setup for a
# fast-iteration web client.
#
# Existing visitors who already have the old SW registered get a
# one-time un-registration shim from `web/index.html` so they don't
# stay stuck on a stale bundle indefinitely.
BUILD_ARGS=(--release --no-tree-shake-icons --pwa-strategy=none)
if [ -n "${API_BASE_URL:-}" ]; then
  echo "Building with API_BASE_URL=$API_BASE_URL"
  BUILD_ARGS+=(--dart-define=API_BASE_URL="$API_BASE_URL")
else
  echo "WARNING: API_BASE_URL is not set. The app will fall back to" \
       "http://localhost:8000 which won't work in production." >&2
fi

flutter build web "${BUILD_ARGS[@]}"
echo "Build complete -> build/web"
