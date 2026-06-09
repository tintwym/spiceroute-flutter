# SpiceRoute App

Flutter client for **SpiceRoute** — a multilingual recipe explorer with AI-generated recipes, a streaming AI chef chat, a Firestore-backed community photo board, and per-recipe reviews & photo galleries. Single codebase targets **iOS, Android, and the web**.

The client talks to two backends:

- **[spiceroute-backend](https://github.com/TintWaiYanMin/spiceroute-backend)** — FastAPI + Postgres for the recipe catalog and the AI endpoints (Gemini).
- **Firebase Auth + Firestore** — for sign-in / sign-up and all user-generated content (saved-recipe sync, community photos, reviews).

## What's in here

```
.
├── lib/
│   ├── api/                Dio HTTP client for the FastAPI backend
│   ├── data/               Static editorial content (cross-cultural stories)
│   ├── features/
│   │   ├── auth/           Sign-in / register / sign-in-prompt modals (Firebase)
│   │   ├── explore/        Home page: hero + cuisine pills + recipe grid
│   │   │                   + Community Board + Cross-Cultural Stories
│   │   ├── ai_creator/     AI Recipe Generator (cuisine + idea → recipe)
│   │   ├── ai_companion/   AI Chef chat (SSE-streamed Gemini deltas)
│   │   ├── recipes/        Recipe detail modal + reviews & photo gallery
│   │   ├── saved/          Saved recipes screen (mirrored to Firestore)
│   │   ├── my_recipes/     Auth-gated "my AI-generated recipes" screen
│   │   └── settings/       Theme + locale picker
│   ├── l10n/               ARB files for en / zh / my / ja / ko / vi (+ generated)
│   ├── models/             Freezed data classes (SpiceRoute, Chat)
│   ├── shared/             TopNavBar, PageHero, PageTabs, SiteFooter, StudioPage,
│   │                       CuisinePillBar, FilterBar, FirebaseOptions, router,
│   │                       theme, reusable widgets (RecipeCard, etc.)
│   └── state/              Riverpod providers / StateNotifiers / StreamProviders
├── assets/
│   ├── icon/icon.png       Source 1024×1024 app icon
│   └── fonts/              Bundled Playfair Display (variable + bold weights)
├── android/                Android shell (com.spiceroute.spice_route_app)
├── ios/                    iOS shell (com.spiceroute.spiceRouteApp)
├── web/                    Web shell (PWA manifest, favicon)
├── test/                   Flutter unit + widget tests
├── l10n.yaml               Codegen config for flutter_localizations
└── pubspec.yaml
```

> The Firestore security rules and rule-tests live at the **repo root** (`../firestore.rules`, `../firestore-rules-test/`), shared with the React companion project.

## Features

### Browse & discover
- **6-language UI** — English, 中文, မြန်မာ, 日本語, 한국어, Tiếng Việt — switched via flag pills in the top nav.
- **11 cuisines** with native-flag pills and full-color cuisine chrome.
- **Filter bar** — course, dietary, max minutes — composed under the cuisine pills.
- **Editorial layout** — `PageHero` + `PageTabs` + `SiteFooter` shared across all screens, themed light + dark.
- **Recipe grid** with `RecipeCard` (AI-generated badge, cached network image with emoji-gradient fallback).

### AI
- **AI Recipe Generator** — pick a cuisine, type an idea, get a fully structured recipe back (with optional save). Rotating localized "cooking quotes" loading state.
- **AI Chef Companion** — streaming chat (Server-Sent Events) wired to the backend's `/ai/chat/stream`. Bouncing-dots typing indicator, cuisine-aware "Active Focus" label.

### Auth & personal content (Firebase)
- **Firebase Auth** — email / password + Google Sign-In, modal sign-in / register screens with inline success banners.
- **Saved recipes** — bookmark icon on every card, dedicated Saved screen, mirrored to Firestore (`users/{uid}.savedRecipeIds`) with a "synced" badge.
- **My Recipes** — auth-gated screen for AI-generated recipes the user persisted.

### User-generated content (Firestore)
- **Community Culinary Board** — live Firestore feed of community-shared photos with cuisine + caption + uploader. Real `image_picker` photo upload, client-side compression via `flutter_image_compress` so a phone-sized HEIC drops under Firestore's 1 MB doc cap before being base64-embedded.
- **Reviews & photo gallery** — per-recipe ratings (1–5), comments, photo uploads. Lightbox viewer with `InteractiveViewer`. Rating summary aggregates live from the `reviews/{id}` collection.
- **Cross-Cultural Stories** — editorial card on the Explore page.

### Polish
- Dark mode toggle (`ThemeModeController`)
- Locally bundled **Playfair Display** font (no `google_fonts` network dependency)
- Sign-in prompt modal for anonymous users hitting auth-gated CTAs
- Tap-to-complete instruction checklist on recipe details

## Prerequisites

- Flutter SDK ≥ **3.11.5**
- Xcode (iOS builds) and/or Android Studio + emulator (Android builds)
- A running [`spiceroute-backend`](https://github.com/TintWaiYanMin/spiceroute-backend) — local Docker or deployed.
- A Firebase project for full auth + Firestore features. The repo ships with the original AI-Studio project config so the app boots and the live data works out of the box; replace `lib/shared/firebase_options.dart` to point at a project you fully own.

## Setup

```bash
flutter pub get

# 1. Generate freezed / json_serializable code
dart run build_runner build --delete-conflicting-outputs

# 2. Generate AppL10n from the 6 ARB files (en, zh, my, ja, ko, vi)
flutter gen-l10n
```

> `flutter gen-l10n` is configured by [`l10n.yaml`](./l10n.yaml) and writes to `lib/l10n/generated/`. Re-run after editing any `app_*.arb`.

### Firebase configuration

`lib/shared/firebase_options.dart` ships with the original AI-Studio Firebase project values. **Important:** that project uses a **named Firestore database**, not the conventional `(default)` one. The file exports a `firestoreDatabaseId` constant that's passed to `FirebaseFirestore.instanceFor(databaseId: …)` everywhere — without it the Flutter app and the React companion would write to different databases.

To swap to your own project:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

then either keep `(default)` and clear `firestoreDatabaseId = ''` in `firebase_options.dart`, or set it to whatever database ID `gcloud firestore databases list` reports.

The Firestore security rules in **`../firestore.rules`** (repo root) are the source of truth — deploy them with `firebase deploy --only firestore:rules` from the repo root.

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
flutter build web --release
flutter build apk --release
flutter build ios --release   # requires Xcode + Apple Developer signing
```

## App icons

Icons are generated from `assets/icon/icon.png` (1024×1024 source). After replacing the source, regenerate platform-specific assets with:

```bash
dart run flutter_launcher_icons
```

## Tests

### Flutter

```bash
flutter analyze
flutter test
```

Covers:

- `test/state/recipe_reviews_test.dart` — `RecipeReview.fromDoc` schema parsing + base64 photo decoding.
- `test/shared/widgets_test.dart` — `RecipeCard` AI badge + image-fallback gradient.
- `test/features/recipes/recipe_reviews_test.dart` — empty state, rating average, photo gallery thumbnails (via `network_image_mock` + `fake_cloud_firestore`).
- `test/features/ai_creator/ai_creator_loading_test.dart` — rotating cooking-quote panel.
- `test/features/ai_companion/ai_companion_chat_test.dart` — Active Focus header + bouncing-dots typing indicator.
- `test/features/auth/auth_success_banner_test.dart` — inline post-login banner + delayed modal dismiss.
- `test/widget_test.dart` — bootstrap smoke test.

Mocks: `fake_cloud_firestore` for Firestore reads/writes, `network_image_mock` for cached image loads in widget tests.

### Firestore security rules

Rules live one level up at `../firestore.rules` and have a dedicated emulator-backed test suite:

```bash
cd ../firestore-rules-test
npm install
npm test
```

Boots the Firestore emulator on `localhost:8085`, points it at `../firestore.rules`, and runs the Mocha suite covering `users/{uid}`, `community_photos/{id}`, and `reviews/{id}` (owner-only access, schema bounds, anti-replay via `createdAt == request.time`, etc.).

## Tech stack

- **State**: `flutter_riverpod` (`StateNotifier`, `FutureProvider`, `StreamProvider`)
- **Routing**: `go_router` 14 — modal recipe detail + auth screens via `CustomTransitionPage`
- **HTTP**: `dio` against the FastAPI backend (`/spice_routes`, `/ai/...`)
- **Auth**: `firebase_auth` + `google_sign_in`
- **Realtime data**: `cloud_firestore` (named DB — see [Firebase configuration](#firebase-configuration))
- **Secure storage**: `flutter_secure_storage` (web → IndexedDB, mobile → Keychain / EncryptedSharedPreferences)
- **Codegen**: `freezed` + `json_serializable`
- **Image picking**: `image_picker`
- **Image compression**: `flutter_image_compress` (HEIC → JPEG ≤ 800 KB before base64)
- **Image caching**: `cached_network_image`
- **SVG**: `flutter_svg`
- **i18n**: `flutter_localizations` + `intl` + `flutter gen-l10n`
- **Test mocks**: `fake_cloud_firestore`, `network_image_mock`

## License

[MIT](./LICENSE)
