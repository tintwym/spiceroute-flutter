import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../features/cook/cook_scaling.dart';

/// Persistent user preferences specific to the Cook Mode experience.
///
/// Today this is just the unit-system toggle (original / metric /
/// imperial). Lives in its own provider so the cook flow can
/// `ref.watch` it without rebuilding on unrelated theme / locale
/// changes, and so future cook-mode prefs (timer sounds, keep-screen-
/// on default, default servings multiplier) can stack here without
/// growing [ThemeModeNotifier].
///
/// Storage uses the same `savor_*` namespace as the other prefs (see
/// `state/theme_mode.dart`'s warning about renaming keys). The key
/// prefix is intentionally distinct from the cuisine/locale prefs so
/// future migrations can target just this slice.
const _unitsKey = 'savor_cook_units';
const _storage = FlutterSecureStorage(
  webOptions: WebOptions(dbName: 'savor_settings'),
);

class CookPrefsNotifier extends StateNotifier<UnitSystem> {
  CookPrefsNotifier() : super(UnitSystem.original) {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final raw = await _storage.read(key: _unitsKey);
      final next = _decode(raw);
      if (next != state) state = next;
    } catch (_) {
      // secure_storage occasionally throws on first web run; default is fine.
    }
  }

  Future<void> setUnits(UnitSystem next) async {
    if (next == state) return;
    state = next;
    try {
      await _storage.write(key: _unitsKey, value: _encode(next));
    } catch (_) {
      // persistence is best-effort.
    }
  }

  static String _encode(UnitSystem u) => switch (u) {
        UnitSystem.original => 'original',
        UnitSystem.metric => 'metric',
        UnitSystem.imperial => 'imperial',
      };

  static UnitSystem _decode(String? raw) => switch (raw) {
        'metric' => UnitSystem.metric,
        'imperial' => UnitSystem.imperial,
        _ => UnitSystem.original,
      };
}

final cookUnitsProvider =
    StateNotifierProvider<CookPrefsNotifier, UnitSystem>(
  (_) => CookPrefsNotifier(),
);
