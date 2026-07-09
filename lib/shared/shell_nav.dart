import 'responsive_scaffold.dart';

/// Center slot in the 5-item phone bottom bar (Explore · Chat · + · Saved · Me).
const int kPhoneShellPlusBarIndex = 2;

/// Maps a shell destination index (0..3) to the phone bar index (0..4).
int phoneBarIndexForDestIndex(int destIndex) =>
    destIndex < 2 ? destIndex : destIndex + 1;

/// Maps a phone bar index to a shell destination index, or `-1` for [+].
int phoneDestIndexForBarIndex(int barIndex) {
  if (barIndex < 2) return barIndex;
  if (barIndex == kPhoneShellPlusBarIndex) return -1;
  return barIndex - 1;
}

/// Whether [location] is an auxiliary shell route that should not update the
/// stored tab highlight (e.g. AI Creator opened from the + sheet).
bool isAuxiliaryShellPath(String location) => location == '/ai/creator';

/// Whether navigating to [location] should refresh [shellHighlightPathProvider].
bool shouldUpdateShellHighlightPath(String location) =>
    !isAuxiliaryShellPath(location) && location != '/settings';

/// Resolves which path the phone bottom bar should treat as selected.
///
/// AI Creator keeps the last primary tab; My Recipes and legacy Settings
/// highlight Me; everything else tracks the current route.
String phoneBarHighlightPath(String location, String storedHighlight) {
  if (location == '/ai/creator') return storedHighlight;
  if (location == '/my-recipes' || location == '/settings') return '/me';
  return location;
}

/// Resolves which phone bar slot should appear selected for [location].
int phoneBarIndexForPath(List<ShellDestination> dests, String location) {
  if (location == '/me' ||
      location == '/settings' ||
      location == '/my-recipes') {
    return phoneBarIndexForDestIndex(3);
  }
  for (var i = 0; i < dests.length; i++) {
    final path = dests[i].path;
    if (location == path) return phoneBarIndexForDestIndex(i);
    if (path != '/' && location.startsWith(path)) {
      return phoneBarIndexForDestIndex(i);
    }
  }
  if (location.startsWith('/recipes/')) {
    return phoneBarIndexForDestIndex(0);
  }
  return phoneBarIndexForDestIndex(0);
}
