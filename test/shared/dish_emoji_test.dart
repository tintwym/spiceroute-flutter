import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/models/spice_route.dart';
import 'package:spiceroute/shared/dish_emoji.dart';

void main() {
  SpiceRouteSummary make({
    String title = 'Untitled',
    String? description,
    Cuisine? cuisine,
    List<Tag> tags = const [],
  }) =>
      SpiceRouteSummary(
        id: 'r1',
        title: title,
        description: description,
        cuisine: cuisine,
        tags: tags,
      );

  group('dishEmojiFor — title keyword (the user-reported screenshot)', () {
    // These three dishes used to render the same croissant emoji
    // because all three are French. The whole point of the resolver
    // is that they now diverge.
    test('Quiche Lorraine → pie slice', () {
      expect(
        dishEmojiFor(make(title: 'Quiche Lorraine', cuisine: Cuisine.french)),
        '🥧',
      );
    });

    test('Ratatouille → eggplant', () {
      expect(
        dishEmojiFor(make(title: 'Ratatouille', cuisine: Cuisine.french)),
        '🍆',
      );
    });

    test('Coq au Vin → poultry leg', () {
      expect(
        dishEmojiFor(make(title: 'Coq au Vin', cuisine: Cuisine.french)),
        '🍗',
      );
    });

    test('three French dishes resolve to three distinct emojis', () {
      final emojis = {
        dishEmojiFor(make(title: 'Quiche Lorraine', cuisine: Cuisine.french)),
        dishEmojiFor(make(title: 'Ratatouille', cuisine: Cuisine.french)),
        dishEmojiFor(make(title: 'Coq au Vin', cuisine: Cuisine.french)),
      };
      expect(
        emojis.length,
        3,
        reason: 'each French dish on Explore must wear its own icon, '
            'not all share the cuisine-default croissant',
      );
    });
  });

  group('dishEmojiFor — title keyword (cross-cuisine)', () {
    test('Spaghetti Carbonara → noodles', () {
      expect(
        dishEmojiFor(
            make(title: 'Spaghetti Carbonara', cuisine: Cuisine.italian)),
        '🍝',
      );
    });

    test('Salmon Sushi Platter → sushi (more specific than salmon)', () {
      expect(
        dishEmojiFor(
            make(title: 'Salmon Sushi Platter', cuisine: Cuisine.japanese)),
        '🍣',
      );
    });

    test('Pad Thai → pasta/noodle bowl', () {
      expect(
        dishEmojiFor(make(title: 'Pad Thai', cuisine: Cuisine.thai)),
        '🍝',
      );
    });

    test('Korean Bibimbap → rice bowl', () {
      expect(
        dishEmojiFor(make(title: 'Bibimbap', cuisine: Cuisine.korean)),
        '🍚',
      );
    });

    test('case-insensitive match', () {
      expect(
        dishEmojiFor(
            make(title: 'PIZZA MARGHERITA', cuisine: Cuisine.italian)),
        '🍕',
      );
    });
  });

  group('dishEmojiFor — keyword ordering (longer wins over shorter)', () {
    test('"Chinese Fried Rice" matches `fried rice` (🍚) not generic rice', () {
      // Both `fried rice` and `rice` are in the table; the multi-word
      // entry must be checked first. Both currently map to 🍚 so the
      // visual outcome is identical, but the assertion guards the
      // ordering contract — future divergence would surface here.
      expect(dishEmojiFor(make(title: 'Chinese Fried Rice')), '🍚');
    });

    test('"Chicken Curry" → 🍛 (multi-word) not 🍗 (chicken catch-all)', () {
      expect(dishEmojiFor(make(title: 'Chicken Curry')), '🍛');
    });

    test('"Hot Chocolate" → ☕ not 🍫', () {
      // `hot chocolate` is in the multi-word block and must win over
      // the generic `chocolate` catch-all.
      expect(dishEmojiFor(make(title: 'Hot Chocolate')), '☕');
    });

    test('"Eggplant Parmesan" → 🍆 not 🍳', () {
      expect(dishEmojiFor(make(title: 'Eggplant Parmesan')), '🍆');
    });

    test('"Cheesecake" → 🍰 not 🧀', () {
      expect(dishEmojiFor(make(title: 'New York Cheesecake')), '🍰');
    });
  });

  group('dishEmojiFor — description fallback', () {
    test('Proper-noun title falls through to description keyword', () {
      expect(
        dishEmojiFor(make(
          title: "Babette's Feast",
          description: 'A classic French ratatouille with summer vegetables.',
          cuisine: Cuisine.french,
        )),
        '🍆',
      );
    });

    test('word-boundary scan: "classic" must NOT match `lassi`', () {
      // Regression for the naive `String.contains(keyword)` bug:
      // `lassi` was a substring of c-LASSI-c which short-circuited
      // the description scan and shipped 🥤 for any recipe whose
      // description began with "a classic …". The padded
      // word-boundary scan stops this entire class.
      expect(
        dishEmojiFor(make(
          title: "Untitled",
          description: 'A classic French ratatouille with summer vegetables.',
        )),
        '🍆',
      );
    });

    test('word-boundary scan: "steak" must NOT match `tea`', () {
      // Same family of bug — `tea` is a substring of s-TEA-k.
      expect(
        dishEmojiFor(make(title: 'Ribeye Steak')),
        '🥩',
      );
    });

    test('word-boundary scan: "piece" must NOT match `pie`', () {
      // And `pie` is a substring of PIE-ce. Without padding the
      // catch-all `pie` → 🥧 would win for any title mentioning a
      // "piece of …".
      expect(
        dishEmojiFor(make(
          title: 'Untitled',
          description: 'Each piece of cheese is hand-cut.',
        )),
        // No dish keyword in the title; description has `piece` (no
        // match under word boundaries) and `cheese` → 🧀.
        '🧀',
      );
    });

    test('Empty description does not short-circuit the cuisine fallback', () {
      // Title doesn't match anything in the table; description is
      // empty; cuisine present — should hit tier 3 (cuisine).
      expect(
        dishEmojiFor(make(
          title: 'Grandma\'s Favorite',
          description: '',
          cuisine: Cuisine.italian,
        )),
        '🍝',
      );
    });
  });

  group('dishEmojiFor — cuisine fallback', () {
    test('Unrecognised title → cuisine emoji (French → 🥐)', () {
      expect(
        dishEmojiFor(
            make(title: 'A novel dish', cuisine: Cuisine.french)),
        '🥐',
      );
    });

    test('Unrecognised title → cuisine emoji (Italian → 🍝)', () {
      expect(
        dishEmojiFor(
            make(title: 'A novel dish', cuisine: Cuisine.italian)),
        '🍝',
      );
    });
  });

  group('dishEmojiFor — final generic fallback', () {
    test('no title match + no cuisine → generic plate', () {
      expect(dishEmojiFor(make(title: 'Mystery meal')), '🍽️');
    });
  });
}
