# SpiceRoute App

Flutter client for **SpiceRoute** — a recipe management app. Single codebase targets **iOS, Android, and the web**.

The backing FastAPI server lives at **[spiceroute-backend](https://github.com/TintWaiYanMin/spiceroute-backend)**.

## What's in here

```
.
├── lib/
│   ├── api/                Dio HTTP client + token store + auth-refresh interceptor
│   ├── features/
│   │   ├── auth/           Login + register screens
│   │   ├── spice_routes/   List, detail, edit screens (CRUD UI)
│   │   └── favorites/      Favorites listing
│   ├── models/             Freezed data classes (SpiceRoute, Ingredient, Step, Tag, User, auth)
│   ├── shared/             Config (API_BASE_URL), router, theme, reusable widgets
│   ├── state/              Riverpod providers + StateNotifiers
│   └── main.dart           App entrypoint
├── android/                Android shell (namespace com.spiceroute.spice_route_app)
├── ios/                    iOS shell (bundle id com.spiceroute.spiceRouteApp)
├── web/                    Web shell (PWA manifest, favicon)
├── assets/icon/icon.png    Source 1024×1024 app icon
├── test/                   Widget tests
└── pubspec.yaml
```

## Features

- Email/password auth with JWT auto-refresh on 401
- Browse / create / edit / delete SpiceRoutes with structured ingredients & steps
- Public/private flag, photo upload, tag autocomplete
- Search across title/description/ingredients
- Filter by tag, max total time, mine-only, favorites-only
- Heart-to-favorite, dedicated favorites screen
- **Client-side servings scaling** — bump servings up/down and ingredient quantities recalculate live; SpiceRoute data is never mutated

## Prerequisites

- Flutter SDK ≥ 3.11
- Xcode (iOS builds) and/or Android Studio + emulator (Android builds)
- A running [`spiceroute-backend`](https://github.com/TintWaiYanMin/spiceroute-backend) instance (local Docker or deployed)

## Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

The `build_runner` step generates freezed + json_serializable code (`*.freezed.dart`, `*.g.dart`).

## Run

### Web (Chrome)

```bash
flutter run -d chrome
```

Defaults to `http://localhost:8000` for the API.

### iOS simulator

```bash
flutter run -d ios
```

Defaults to `http://localhost:8000` (the simulator shares the host loopback).

### Android emulator

```bash
flutter run -d android
```

Defaults to `http://10.0.2.2:8000` (Android emulator's alias for the host).

### Pointing at a deployed backend

Pass `API_BASE_URL` at build time:

```bash
flutter run --dart-define=API_BASE_URL=https://api.example.com -d chrome
flutter build web --release --dart-define=API_BASE_URL=https://api.example.com
flutter build apk --release --dart-define=API_BASE_URL=https://api.example.com
flutter build ios --release --dart-define=API_BASE_URL=https://api.example.com
```

See [`lib/shared/config.dart`](./lib/shared/config.dart) for the resolution order.

## Build

```bash
# Web (output: build/web/)
flutter build web --release

# Android APK (output: build/app/outputs/flutter-apk/)
flutter build apk --release

# iOS (requires Xcode + Apple Developer account for signing)
flutter build ios --release
```

## App icons

Icons are generated from `assets/icon/icon.png` (1024×1024 source). After replacing the source, regenerate platform-specific assets with:

```bash
dart run flutter_launcher_icons
```

## Tests

```bash
flutter analyze
flutter test
```

## Tech stack

- **State**: `flutter_riverpod` + `StateNotifier`
- **Routing**: `go_router` (path-based, plays nice with web URLs)
- **HTTP**: `dio` with custom auth-refresh interceptor
- **Secure storage**: `flutter_secure_storage` (web uses IndexedDB, mobile uses Keychain/EncryptedSharedPreferences)
- **Codegen**: `freezed` + `json_serializable`
- **Image picker**: `image_picker`
- **Image caching**: `cached_network_image`

## License

[MIT](./LICENSE)
