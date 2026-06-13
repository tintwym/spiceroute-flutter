import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/models/spice_route.dart';
import 'package:spiceroute/state/explore.dart';

/// Small helper to build a `SpiceRouteSummary` with just the tags
/// populated — that's the only field `_matchesDietary` actually
/// inspects, but the constructor needs the required ones too.
SpiceRouteSummary _summaryWithTags(List<String> tagNames) {
  return SpiceRouteSummary(
    id: 't',
    title: 'T',
    tags: [
      for (var i = 0; i < tagNames.length; i++)
        Tag(id: 'tag-$i', name: tagNames[i]),
    ],
  );
}

/// Drives `ExploreState.visibleItems` with one summary at a time
/// and reports back whether the dietary filter matched it. Keeps
/// the assertion sites focused on the input/output relationship.
bool matchesUnder(Dietary filter, List<String> tagNames) {
  final state = ExploreState(
    dietary: filter,
    items: [_summaryWithTags(tagNames)],
  );
  return state.visibleItems.isNotEmpty;
}

void main() {
  group('Dietary filter tag matching', () {
    test('every Dietary value has a non-empty, lowercase tagName', () {
      // Defensive: prevents a future contributor adding a Dietary
      // with an empty or upper-cased tagName, which the matcher
      // would silently never hit (it lowercases the needle but
      // doesn't trim, so e.g. ' gluten-free ' with a leading space
      // would silently never match either).
      for (final d in Dietary.values) {
        expect(d.tagName, isNotEmpty,
            reason: '${d.name} has empty tagName');
        expect(d.tagName, equals(d.tagName.toLowerCase()),
            reason: '${d.name} tagName is not lowercase');
        expect(d.tagName.trim(), equals(d.tagName),
            reason: '${d.name} tagName has leading/trailing whitespace');
      }
    });

    test(
        'allergen-free filters use hyphenated tags matching the seed convention',
        () {
      // Regression: the matcher does case-insensitive EXACT string
      // match, no normalisation. We had a bug where Dietary.glutenFree
      // was declared with tagName 'gluten free' (space) while the
      // seed already attached 'gluten-free' (hyphen) to a dozen+
      // recipes — the filter silently returned zero results. Pin the
      // contract so a future "let's normalize it to spaces" refactor
      // has to update either the seed OR the matcher first.
      expect(Dietary.glutenFree.tagName, equals('gluten-free'));
      expect(Dietary.dairyFree.tagName, equals('dairy-free'));
      expect(Dietary.nutFree.tagName, equals('nut-free'));
      expect(Dietary.eggFree.tagName, equals('egg-free'));
    });

    test('matches a recipe carrying the exact tag', () {
      expect(matchesUnder(Dietary.glutenFree, ['gluten-free']), isTrue);
      expect(matchesUnder(Dietary.dairyFree, ['dairy-free', 'vegan']), isTrue);
      expect(matchesUnder(Dietary.vegan, ['vegan']), isTrue);
    });

    test('matching is case-insensitive on the recipe-tag side', () {
      // The seed always writes lowercase, but user-authored recipes
      // come through `/spice_routes` POST without mandatory case
      // normalisation — defensive that 'Gluten-Free' from a future
      // writer still hits the filter.
      expect(matchesUnder(Dietary.glutenFree, ['Gluten-Free']), isTrue);
      expect(matchesUnder(Dietary.vegan, ['VEGAN']), isTrue);
    });

    test('does NOT match the wrong separator (hyphen vs space)', () {
      // Pin the strict-match contract: if a buggy writer ever
      // attaches `gluten free` (space) instead of `gluten-free`
      // (hyphen), the filter will miss it — and we want a test
      // that documents that fact rather than letting it lurk as
      // an off-by-one space the next time someone normalises tags.
      expect(matchesUnder(Dietary.glutenFree, ['gluten free']), isFalse);
    });

    test('does not false-positive on substring matches', () {
      // 'vegetarian' must NOT match a Dietary.vegan filter even
      // though the v-e-g substring overlaps. The matcher uses ==,
      // not contains — pin that.
      expect(matchesUnder(Dietary.vegan, ['vegetarian']), isFalse);
    });
  });
}
