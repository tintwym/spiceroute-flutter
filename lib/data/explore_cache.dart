import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/spice_route.dart';

/// Session-ish cache for the Explore recipe grid so a full page reload
/// can paint the last-known results immediately (stale-while-revalidate)
/// instead of waiting on a cold network round-trip.
///
/// Stored in the same secure-storage bucket as locale prefs. On web this
/// is IndexedDB — fast enough for ~30–90 summary rows and survives
/// hard refresh within the same browser profile until cleared.
const _cacheKey = 'savor_explore_cache';
const _cacheVersion = 1;

/// Cap persisted rows so a long infinite-scroll session doesn't bloat
/// storage or slow reads on web.
const int exploreCacheMaxItems = 90;

const _storage = FlutterSecureStorage(
  webOptions: WebOptions(dbName: 'savor_settings'),
);

@immutable
class ExploreCacheSnapshot {
  const ExploreCacheSnapshot({
    required this.locale,
    required this.q,
    required this.cuisineWire,
    required this.items,
    required this.total,
  });

  final String locale;
  final String q;
  final String? cuisineWire;
  final List<SpiceRouteSummary> items;
  final int total;

  bool matches({
    required String locale,
    required String q,
    Cuisine? cuisine,
  }) {
    return this.locale == locale &&
        this.q == q &&
        cuisineWire == cuisine?.wire;
  }
}

/// In-memory override used by widget/unit tests only.
@visibleForTesting
Map<String, String>? exploreCacheMemoryStore;

class ExploreCache {
  ExploreCache._();

  static Future<ExploreCacheSnapshot?> read() async {
    try {
      final raw = await _readRaw(_cacheKey);
      if (raw == null || raw.isEmpty) return null;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      if (map['version'] != _cacheVersion) return null;

      final itemsJson = (map['items'] as List?) ?? const [];
      final items = itemsJson
          .map((e) => SpiceRouteSummary.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);

      return ExploreCacheSnapshot(
        locale: map['locale'] as String? ?? 'en',
        q: map['q'] as String? ?? '',
        cuisineWire: map['cuisine'] as String?,
        items: items,
        total: (map['total'] as int?) ?? items.length,
      );
    } catch (e, st) {
      debugPrint('ExploreCache.read failed: $e\n$st');
      return null;
    }
  }

  static Future<void> write({
    required String locale,
    required String q,
    Cuisine? cuisine,
    required List<SpiceRouteSummary> items,
    required int total,
  }) async {
    if (items.isEmpty) return;
    try {
      final capped = items.length > exploreCacheMaxItems
          ? items.sublist(0, exploreCacheMaxItems)
          : items;
      final payload = jsonEncode({
        'version': _cacheVersion,
        'locale': locale,
        'q': q,
        'cuisine': cuisine?.wire,
        'total': total,
        'items': [for (final r in capped) _summaryToJson(r)],
      });
      await _writeRaw(_cacheKey, payload);
    } catch (e, st) {
      debugPrint('ExploreCache.write failed: $e\n$st');
    }
  }

  static Future<void> clear() => _deleteRaw(_cacheKey);

  static Future<String?> _readRaw(String key) async {
    if (exploreCacheMemoryStore != null) {
      return exploreCacheMemoryStore![key];
    }
    return _storage.read(key: key);
  }

  static Future<void> _writeRaw(String key, String value) async {
    if (exploreCacheMemoryStore != null) {
      exploreCacheMemoryStore![key] = value;
      return;
    }
    await _storage.write(key: key, value: value);
  }

  static Future<void> _deleteRaw(String key) async {
    if (exploreCacheMemoryStore != null) {
      exploreCacheMemoryStore!.remove(key);
      return;
    }
    await _storage.delete(key: key);
  }
}

Map<String, dynamic> _summaryToJson(SpiceRouteSummary r) => {
  'id': r.id,
  'title': r.title,
  'description': r.description,
  'prep_minutes': r.prepMinutes,
  'cook_minutes': r.cookMinutes,
  'servings': r.servings,
  'image_url': r.imageUrl,
  'is_public': r.isPublic,
  'cuisine': r.cuisineWire,
  'language': r.language,
  'spice_level': r.spiceLevel,
  'is_premium': r.isPremium,
  'calories_per_serving': r.caloriesPerServing,
  'difficulty': r.difficulty.wire,
  if (r.owner != null)
    'owner': {
      'id': r.owner!.id,
      'display_name': r.owner!.displayName,
    },
  'tags': [
    for (final t in r.tags) {'id': t.id, 'name': t.name},
  ],
};
