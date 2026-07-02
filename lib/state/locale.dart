import 'dart:async';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const supportedLocales = <Locale>[
  Locale('en'),
  Locale('zh'),
  Locale('ja'),
  Locale('ko'),
  Locale('vi'),
];

// LEGACY storage-key names — see `lib/state/auth.dart::_kDevUserKey`
// for why these `savor_*` prefixes must NOT be renamed without a
// migration. Renaming would silently reset every user's selected
// language on the next deploy.
const _localeKey = 'savor_locale';
const _storage = FlutterSecureStorage(
  webOptions: WebOptions(dbName: 'savor_settings'),
);

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(_inferDefault()) {
    final done = Completer<void>();
    ready = done.future;
    _bootstrap(done);
  }

  /// Completes once the persisted locale has been read (or skipped).
  /// Explore waits on this so the first recipe fetch uses the stored
  /// language instead of racing ahead with the platform default.
  late final Future<void> ready;

  /// True once the user has explicitly picked a locale via `set()`
  /// during the lifetime of this notifier. Used as a one-way latch
  /// to suppress the bootstrap's stored-value restore — if the user
  /// has already made an explicit choice (typically by tapping a
  /// language chip while the disk read was still in flight), we MUST
  /// NOT overwrite it with whatever was on disk from the previous
  /// session.
  ///
  /// Race scenario this guards (real, observed in practice on slow
  /// web first-loads where the secure-storage IndexedDB call can
  /// take 100ms+):
  ///   t=0   constructor sets state = inferDefault() (= 'en')
  ///   t=1   _bootstrap fires, kicks off `_storage.read(...)`
  ///   t=2   user taps "Vietnamese" chip → set(vi) → state = vi,
  ///         persists vi to storage
  ///   t=3   _storage.read resolves with previous-session 'ja'
  ///   t=4   bootstrap: `match = ja`, `state != ja` → state = ja
  ///         (silently overwrites the user's t=2 selection)
  bool _userSet = false;

  /// Serializes persistence writes so two rapid `set()` calls can't
  /// race each other on disk. The state field gets updated
  /// synchronously (so the UI reflects the latest tap immediately),
  /// but the storage writes chain off this Future so they land in
  /// call order — without this, write A could finish AFTER write B
  /// and leave the disk with the wrong value despite the in-memory
  /// state being correct.
  Future<void> _writeLock = Future<void>.value();

  static Locale _inferDefault() {
    final platform = PlatformDispatcher.instance.locale;
    final code = platform.languageCode.toLowerCase();
    return supportedLocales.firstWhere(
      (l) => l.languageCode == code,
      orElse: () => const Locale('en'),
    );
  }

  Future<void> _bootstrap(Completer<void> done) async {
    try {
      final stored = await _storage.read(key: _localeKey);
      if (_userSet) return;
      if (stored == null || stored.isEmpty) return;
      final match = supportedLocales.firstWhere(
        (l) => l.languageCode == stored,
        orElse: () => const Locale('en'),
      );
      if (match != state) state = match;
    } catch (_) {
      // Secure storage can fail on first web run; fall back to inferred locale.
    } finally {
      if (!done.isCompleted) done.complete();
    }
  }

  Future<void> set(Locale locale) async {
    if (!supportedLocales.any((l) => l.languageCode == locale.languageCode)) {
      return;
    }
    _userSet = true;
    state = locale;
    // Chain the disk write so concurrent set() calls land in
    // call-order and don't race each other on flush. We swap the
    // lock Future BEFORE awaiting so the next caller sees the new
    // tail of the chain.
    final next = _writeLock.then((_) async {
      try {
        await _storage.write(key: _localeKey, value: locale.languageCode);
      } catch (_) {
        // best-effort; in-memory state is the live source of truth
      }
    });
    _writeLock = next;
    return next;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (_) => LocaleNotifier(),
);
