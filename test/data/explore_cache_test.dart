import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/data/explore_cache.dart';
import 'package:spiceroute/models/spice_route.dart';

void main() {
  setUp(() {
    exploreCacheMemoryStore = {};
  });

  tearDown(() {
    exploreCacheMemoryStore = null;
  });

  test('round-trips explore summaries through cache storage', () async {
    final recipe = SpiceRouteSummary(
      id: 'r-1',
      title: 'Pho Bo',
      description: 'Beef noodle soup.',
      prepMinutes: 20,
      cookMinutes: 180,
      servings: 4,
      cuisine: Cuisine.vietnamese,
      cuisineWire: 'vietnamese',
      caloriesPerServing: 520,
      difficulty: Difficulty.medium,
    );

    await ExploreCache.write(
      locale: 'en',
      q: '',
      cuisine: null,
      items: [recipe],
      total: 42,
    );

    final snapshot = await ExploreCache.read();
    expect(snapshot, isNotNull);
    expect(snapshot!.locale, 'en');
    expect(snapshot.total, 42);
    expect(snapshot.items.single.id, 'r-1');
    expect(snapshot.items.single.title, 'Pho Bo');
    expect(snapshot.matches(locale: 'en', q: '', cuisine: null), isTrue);
    expect(
      snapshot.matches(locale: 'vi', q: '', cuisine: null),
      isFalse,
    );
  });

  test('cache ignores mismatched filter keys on hydrate check', () async {
    await ExploreCache.write(
      locale: 'en',
      q: 'pho',
      cuisine: Cuisine.vietnamese,
      items: [SpiceRouteSummary(id: 'r-1', title: 'Pho')],
      total: 1,
    );

    final snapshot = await ExploreCache.read();
    expect(snapshot!.matches(locale: 'en', q: '', cuisine: null), isFalse);
    expect(
      snapshot.matches(locale: 'en', q: 'pho', cuisine: Cuisine.vietnamese),
      isTrue,
    );
  });

  test('corrupt cache payload returns null', () async {
    exploreCacheMemoryStore!['savor_explore_cache'] = 'not-json';
    expect(await ExploreCache.read(), isNull);
  });
}
