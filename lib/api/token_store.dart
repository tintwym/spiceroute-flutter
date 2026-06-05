import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStore {
  static const _access = 'spice_route_access_token';
  static const _refresh = 'spice_route_refresh_token';

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    webOptions: WebOptions(dbName: 'spice_route_app_tokens'),
  );

  Future<String?> readAccess() => _storage.read(key: _access);
  Future<String?> readRefresh() => _storage.read(key: _refresh);

  Future<void> write({required String access, required String refresh}) async {
    await _storage.write(key: _access, value: access);
    await _storage.write(key: _refresh, value: refresh);
  }

  Future<void> clear() async {
    await _storage.delete(key: _access);
    await _storage.delete(key: _refresh);
  }
}
