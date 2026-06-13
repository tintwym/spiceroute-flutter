import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// User-controlled override on top of the OS theme.
///
/// Persists to secure storage so the choice survives reloads on web and
/// app restarts on mobile. Defaults to [ThemeMode.system] which simply
/// follows the OS preference.
///
/// LEGACY storage-key names — see `lib/state/auth.dart::_kDevUserKey`
/// for why these `savor_*` prefixes must NOT be renamed without a
/// migration. Renaming would silently reset every user's theme
/// preference on the next deploy.
const _themeKey = 'savor_theme_mode';
const _storage = FlutterSecureStorage(
  webOptions: WebOptions(dbName: 'savor_settings'),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _bootstrap();
  }

  /// One-way latch: true once the user has explicitly chosen a
  /// theme. Suppresses the bootstrap's stored-value restore so a
  /// slow disk read can't clobber a user tap that landed before
  /// the read resolved. See `LocaleNotifier._userSet` for the full
  /// race trace.
  bool _userSet = false;

  /// Serializes disk writes so two rapid `set()` calls can't land
  /// on disk in the wrong order. State updates synchronously; the
  /// persisted side chains off this Future. See
  /// `LocaleNotifier._writeLock` for the rationale.
  Future<void> _writeLock = Future<void>.value();

  Future<void> _bootstrap() async {
    try {
      final raw = await _storage.read(key: _themeKey);
      if (_userSet) return;
      final next = _decode(raw);
      if (next != state) state = next;
    } catch (_) {
      // Best-effort: secure_storage occasionally fails on first web run.
    }
  }

  Future<void> set(ThemeMode mode) async {
    _userSet = true;
    if (mode == state) return;
    state = mode;
    final next = _writeLock.then((_) async {
      try {
        await _storage.write(key: _themeKey, value: _encode(mode));
      } catch (_) {
        // best-effort; in-memory state is the live source of truth
      }
    });
    _writeLock = next;
    return next;
  }

  static String _encode(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };

  static ThemeMode _decode(String? raw) => switch (raw) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (_) => ThemeModeNotifier(),
);
