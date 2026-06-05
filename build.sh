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

BUILD_ARGS=(--release)
if [ -n "${API_BASE_URL:-}" ]; then
  echo "Building with API_BASE_URL=$API_BASE_URL"
  BUILD_ARGS+=(--dart-define=API_BASE_URL="$API_BASE_URL")
else
  echo "WARNING: API_BASE_URL is not set. The app will fall back to" \
       "http://localhost:8000 which won't work in production." >&2
fi

flutter build web "${BUILD_ARGS[@]}"
echo "Build complete -> build/web"
