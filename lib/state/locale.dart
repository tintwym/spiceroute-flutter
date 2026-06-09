import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const supportedLocales = <Locale>[
  Locale('en'),
  Locale('zh'),
  Locale('my'),
  Locale('ja'),
  Locale('ko'),
  Locale('vi'),
];

const _localeKey = 'savor_locale';
const _storage = FlutterSecureStorage(
  webOptions: WebOptions(dbName: 'savor_settings'),
);

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(_inferDefault()) {
    _bootstrap();
  }

  static Locale _inferDefault() {
    final platform = PlatformDispatcher.instance.locale;
    final code = platform.languageCode.toLowerCase();
    return supportedLocales.firstWhere(
      (l) => l.languageCode == code,
      orElse: () => const Locale('en'),
    );
  }

  Future<void> _bootstrap() async {
    try {
      final stored = await _storage.read(key: _localeKey);
      if (stored == null || stored.isEmpty) return;
      final match = supportedLocales.firstWhere(
        (l) => l.languageCode == stored,
        orElse: () => const Locale('en'),
      );
      if (match != state) state = match;
    } catch (_) {
      // Secure storage can fail on first web run; fall back to inferred locale.
    }
  }

  Future<void> set(Locale locale) async {
    if (!supportedLocales.any((l) => l.languageCode == locale.languageCode)) {
      return;
    }
    state = locale;
    try {
      await _storage.write(key: _localeKey, value: locale.languageCode);
    } catch (_) {
      // ignore: persistence is best-effort
    }
  }
}

final localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale>((_) => LocaleNotifier());
