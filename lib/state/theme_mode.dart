import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// User-controlled override on top of the OS theme.
///
/// Persists to secure storage so the choice survives reloads on web and
/// app restarts on mobile. Defaults to [ThemeMode.system] which simply
/// follows the OS preference.
const _themeKey = 'savor_theme_mode';
const _storage = FlutterSecureStorage(
  webOptions: WebOptions(dbName: 'savor_settings'),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final raw = await _storage.read(key: _themeKey);
      final next = _decode(raw);
      if (next != state) state = next;
    } catch (_) {
      // Best-effort: secure_storage occasionally fails on first web run.
    }
  }

  Future<void> set(ThemeMode mode) async {
    if (mode == state) return;
    state = mode;
    try {
      await _storage.write(key: _themeKey, value: _encode(mode));
    } catch (_) {
      // ignore: persistence is best-effort.
    }
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
