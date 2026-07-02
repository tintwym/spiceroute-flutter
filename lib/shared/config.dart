import 'package:flutter/foundation.dart';

class AppConfig {
  static const String _envBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// Production backend used when a release web build ships without
  /// `--dart-define=API_BASE_URL=…` (a common Vercel misconfig that
  /// otherwise falls back to localhost and silently drops translations).
  static const String productionApiBaseUrl =
      'https://spiceroute-backend-ggu5.onrender.com';

  static String get apiBaseUrl {
    if (_envBaseUrl.isNotEmpty) return _envBaseUrl;
    if (kIsWeb && kReleaseMode) return productionApiBaseUrl;
    if (kIsWeb) return 'http://localhost:8000';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }
    return 'http://localhost:8000';
  }
}
