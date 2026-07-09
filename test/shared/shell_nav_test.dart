import 'package:flutter/material.dart' show Icons;
import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/shared/responsive_scaffold.dart';
import 'package:spiceroute/shared/shell_nav.dart';

const _dests = [
  ShellDestination(
    label: 'Explore',
    icon: Icons.explore_outlined,
    selectedIcon: Icons.explore,
    path: '/',
  ),
  ShellDestination(
    label: 'Chat',
    icon: Icons.forum_outlined,
    selectedIcon: Icons.forum,
    path: '/ai/companion',
  ),
  ShellDestination(
    label: 'Saved',
    icon: Icons.bookmark_border,
    selectedIcon: Icons.bookmark,
    path: '/saved',
  ),
  ShellDestination(
    label: 'Me',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    path: '/me',
  ),
];

void main() {
  group('phoneBarHighlightPath', () {
    test('AI Creator preserves stored highlight', () {
      expect(phoneBarHighlightPath('/ai/creator', '/saved'), '/saved');
    });

    test('My Recipes highlights Me', () {
      expect(phoneBarHighlightPath('/my-recipes', '/'), '/me');
    });

    test('Settings redirect path highlights Me', () {
      expect(phoneBarHighlightPath('/settings', '/'), '/me');
    });

    test('primary routes use current location', () {
      expect(phoneBarHighlightPath('/saved', '/'), '/saved');
    });
  });

  group('phoneBarIndexForPath', () {
    test('My Recipes selects Me bar slot', () {
      expect(phoneBarIndexForPath(_dests, '/my-recipes'), 4);
    });

    test('stored Explore + My Recipes highlight resolves to Me', () {
      final highlight = phoneBarHighlightPath('/my-recipes', '/');
      expect(phoneBarIndexForPath(_dests, highlight), 4);
    });

    test('AI Creator with stored Chat highlights Chat', () {
      final highlight = phoneBarHighlightPath('/ai/creator', '/ai/companion');
      expect(phoneBarIndexForPath(_dests, highlight), 1);
    });

    test('plus slot is never selected', () {
      for (final path in ['/', '/ai/companion', '/saved', '/me', '/my-recipes']) {
        expect(phoneBarIndexForPath(_dests, path), isNot(kPhoneShellPlusBarIndex));
      }
    });
  });

  group('isAuxiliaryShellPath', () {
    test('only AI Creator is auxiliary', () {
      expect(isAuxiliaryShellPath('/ai/creator'), isTrue);
      expect(isAuxiliaryShellPath('/my-recipes'), isFalse);
    });
  });
}
