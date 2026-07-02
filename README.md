# SpiceRoute App

Flutter client for **SpiceRoute** — a multilingual recipe explorer with AI-generated recipes, a streaming AI chef chat, a Firestore-backed community photo board, and per-recipe cook logs with photo galleries. One codebase targets **iOS, Android, and the web**.

The client talks to two backends:

- **[spiceroute-backend](https://github.com/TintWaiYanMin/spiceroute-backend)** — FastAPI + Postgres for the recipe catalog and AI endpoints (Groq's Llama 3.1 by default; any OpenAI-compatible provider works).
- **Firebase Auth + Firestore** — sign-in / sign-up and user-generated content (saved-recipe sync, community photos, cook-log entries).

Firestore security rules and their emulator-backed test suite live at the **repo root** (`firestore.rules`, `firestore-rules-test/`), shared with the React companion project.

## Features

### Browse & discover

- **5-language UI** — English, 中文, 日本語, 한국어, Tiếng Việt — via flag pills in the top nav (desktop/tablet) or a compact globe menu on phone.
- **31 cuisines** grouped by geographic region — two-tier region → cuisine filter with animated pill UI.
- **Filter bar** — course and dietary/lifestyle filters with searchable accordion dropdowns on tablet+; a combined bottom sheet on phone.
- **93 curated premium recipes** in the catalog, with difficulty (Easy / Medium / Hard), calories, prep/cook time, and rich card metadata.
- **Full recipe translation** — when the UI locale differs from a recipe's source language, titles, descriptions, ingredients, and steps are served translated via the backend `translate_to` parameter (LLM-backed, stored in Postgres).
- **Infinite scroll** on Explore and paginated **My Recipes** with retry footers when a page fetch fails.
- **Responsive layout** — phone uses bottom navigation + AppBar search; tablet and desktop use a sticky top nav, in-page tabs, and a 2- or 4-column recipe grid depending on width.
- **Light / dark / system theme** — olive-tinted dark palette tuned for nav, pills, and surfaces.

### AI

- **AI Recipe Generator** — pick a cuisine, type an idea, get a structured recipe (optional save). Rotating localized cooking-quote loading state.
- **AI Chef Companion** — streaming chat (SSE) against `/ai/chat/stream`, with cuisine-aware "Active Focus" and a typing indicator.

### Auth & personal content (Firebase)

- **Firebase Auth** — email/password + Google Sign-In; modal sign-in and register with inline success banners.
- **Saved recipes** — bookmark on every card, dedicated Saved screen, mirrored to Firestore (`users/{uid}.savedRecipeIds`).
- **My Recipes** — auth-gated list of recipes the user created or saved via AI, with pagination.

### User-generated content (Firestore)

- **Community Culinary Board** — live feed of community-shared photos with cuisine, caption, and uploader. Client-side image compression before base64 embed (stays under Firestore's 1 MB doc cap).
- **Community Gallery & Reviews** — per-recipe cook log: optional star rating, comment, and photo upload; lightbox viewer; live rating summary from Firestore.
- **Cross-Cultural Stories** — editorial card on Explore when a cuisine is selected.

### Polish

- Bundled **Playfair Display** (display) and **Inter** (UI) — no runtime `google_fonts` dependency.
- Tap-to-complete ingredient and instruction checklists on recipe detail.
- Recipe detail modal with two-column layout on tablet+ (image/meta left, ingredients/steps right).
- Sign-in prompt for anonymous users hitting auth-gated actions.

## Prerequisites

- Flutter SDK ≥ **3.11.5**
- Xcode (iOS) and/or Android Studio + emulator (Android)
- A running [spiceroute-backend](https://github.com/TintWaiYanMin/spiceroute-backend) — local Docker or deployed.
- A Firebase project for full auth + Firestore. The repo ships with the original project config so the app boots with live data; replace `lib/shared/firebase_options.dart` for a project you own.

## Setup

```bash
flutter pub get

# Generate freezed / json_serializable code
dart run build_runner build --delete-conflicting-outputs

# Generate AppL10n from ARB files (en, zh, ja, ko, vi)
flutter gen-l10n
```

Re-run `flutter gen-l10n` after editing any `app_*.arb` file.

### Firebase configuration

`lib/shared/firebase_options.dart` targets a **named Firestore database** (not `(default)`). The `firestoreDatabaseId` constant is passed to `FirebaseFirestore.instanceFor(databaseId: …)` everywhere — without it, the Flutter app and the React companion would write to different databases.

To use your own project:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Then set `firestoreDatabaseId` to your database ID, or clear it for `(default)`.

Deploy rules from the repo root:

```bash
firebase deploy --only firestore:rules
```

## Run

### Web (Chrome)

```bash
flutter run -d chrome
```

Defaults to `http://localhost:8000` for the API.

### iOS simulator

```bash
flutter run -d "iPhone 17 Pro" \
  --dart-define=API_BASE_URL=https://spiceroute-backend-ggu5.onrender.com
```

(`-d ios` often fails to match when only one simulator is booted — use the device name or UUID from `flutter devices`.)

### Android emulator

```bash
flutter run -d android
```

Defaults to `http://10.0.2.2:8000` (emulator alias for the host).

### Pointing at a deployed backend

```bash
flutter run --dart-define=API_BASE_URL=https://spiceroute-backend-ggu5.onrender.com -d chrome
flutter build web --release --dart-define=API_BASE_URL=https://spiceroute-backend-ggu5.onrender.com
flutter build apk --release --dart-define=API_BASE_URL=https://spiceroute-backend-ggu5.onrender.com
flutter build ios --release --dart-define=API_BASE_URL=https://spiceroute-backend-ggu5.onrender.com
```

See `lib/shared/config.dart` for resolution order.

## Build

```bash
flutter build web --release
flutter build apk --release
flutter build ios --release   # requires Xcode + Apple Developer signing
```

## Deployment

### Web → Vercel

The repo includes `vercel.json` and `build.sh`:

- **Root Directory** in Vercel: `spiceroute-flutter`
- **Required env:** `API_BASE_URL` → your backend HTTPS URL (e.g. `https://spiceroute-backend-ggu5.onrender.com`)
- **Optional env:** `FLUTTER_VERSION` (defaults to `stable`)

`build.sh` installs Flutter in CI, runs `flutter pub get`, then `flutter build web --release --no-tree-shake-icons --dart-define=API_BASE_URL=…`. `--no-tree-shake-icons` is required because navigation stores `IconData` dynamically.

Also configure:

1. **Backend CORS** — add your Vercel domain(s) to `CORS_ORIGINS` on the API.
2. **Firebase Auth authorized domains** — add your Vercel hostname in the Firebase console.
3. **Firestore rules** — deploy from repo root.

Local dry-run:

```bash
cd spiceroute-flutter
API_BASE_URL=https://spiceroute-backend-ggu5.onrender.com bash build.sh
cd build/web && python3 -m http.server 8080
```

### Mobile

Use `flutter build apk` / `flutter build ios` with `--dart-define=API_BASE_URL=…`. Ship via Play Console or TestFlight.

## App icons

Source: `assets/icon/icon.png` (1024×1024). After replacing it:

```bash
dart run flutter_launcher_icons
```

## Tests

```bash
flutter analyze
flutter test
```

**142 tests** — widget tests for filters, region bar, recipe cards, cook log, auth banners, AI screens, pagination state, and Firestore schema parsing. Mocks: `fake_cloud_firestore`, `network_image_mock`.

### Firestore security rules

```bash
cd ../firestore-rules-test
npm install
npm test
```

Runs the emulator on `localhost:8085` against `../firestore.rules`.

## Tech stack

| Area | Choice |
|---|---|
| State | `flutter_riverpod` |
| Routing | `go_router` 14 |
| HTTP | `dio` → FastAPI (`/spice_routes`, `/ai/…`) |
| Auth | `firebase_auth` + `google_sign_in` |
| Realtime | `cloud_firestore` (named database) |
| Secure storage | `flutter_secure_storage` |
| Codegen | `freezed`, `json_serializable` |
| Images | `image_picker`, `flutter_image_compress`, `cached_network_image` |
| i18n | `flutter_localizations`, `intl`, `flutter gen-l10n` |

## License

[MIT](./LICENSE)
