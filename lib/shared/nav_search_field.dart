import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../state/explore.dart';

/// Compact pill-style search field designed to live inside the top nav
/// bar (tablet+) or the phone AppBar (replacing the brand title).
///
/// Behavior:
///   * Bound to [exploreProvider]. Typing updates the global Explore
///     query — same data path the old in-body search bar used, so the
///     debounced refresh + result rendering all keep working unchanged.
///   * On submit (Enter / search key), routes to "/" so a user searching
///     from AI Creator / Companion / Saved / Mine lands on the result
///     grid. If already on Explore, just blurs the keyboard.
///   * The text controller's lifecycle mirrors the widget's so the
///     keyboard stays sane across rebuilds.
class NavSearchField extends ConsumerStatefulWidget {
  const NavSearchField({super.key, this.maxWidth = 480, this.dense = false});

  /// Hard cap on field width inside its parent. Pinning a max stops the
  /// field from spanning a 1920px desktop bar and looking like a runway.
  final double maxWidth;

  /// `true` shrinks vertical padding for the phone AppBar slot.
  final bool dense;

  @override
  ConsumerState<NavSearchField> createState() => _NavSearchFieldState();
}

class _NavSearchFieldState extends ConsumerState<NavSearchField> {
  late final TextEditingController _ctl;

  @override
  void initState() {
    super.initState();
    _ctl = TextEditingController(text: ref.read(exploreProvider).q);
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  void _onSubmitted(BuildContext context, String value) {
    final controller = ref.read(exploreProvider.notifier);
    controller.setQuery(value);
    // If the user is browsing somewhere else (AI Creator, Saved, etc.),
    // jumping to the results grid is the only sensible outcome of a
    // submit. If they're already on Explore, GoRouter no-ops on a
    // duplicate go() so this is safe.
    final loc = GoRouterState.of(context).matchedLocation;
    if (loc != '/') {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final q = ref.watch(exploreProvider.select((s) => s.q));

    // Keep the visible text in sync with EXTERNAL resets (e.g. the user
    // navigates back to Explore and the query was cleared elsewhere).
    //
    // We use `ref.listen` instead of mutating the controller inline
    // during `build`. Direct `_ctl.value = ...` inside build worked,
    // but it's a Flutter anti-pattern: it triggers another rebuild on
    // the same frame (the TextField listens to the controller), which
    // burns frames and can cause a feedback loop if any other widget
    // also watches `state.q`. `ref.listen` fires only on actual state
    // changes — safer and cheaper.
    ref.listen<String>(exploreProvider.select((s) => s.q), (_, next) {
      if (_ctl.text == next) return;
      _ctl.value = TextEditingValue(
        text: next,
        selection: TextSelection.collapsed(offset: next.length),
      );
    });

    final controller = ref.read(exploreProvider.notifier);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.maxWidth),
      child: TextField(
        controller: _ctl,
        onChanged: controller.setQuery,
        textInputAction: TextInputAction.search,
        onSubmitted: (v) => _onSubmitted(context, v),
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          isDense: true,
          // Filled pill so the search visually pops out of the bar's
          // surface (it sits on the same color, so a fill is needed).
          filled: true,
          fillColor: cs.surfaceContainerHighest,
          hintText: l.exploreSearchHint,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant,
          ),
          prefixIcon: Icon(Icons.search, size: 20, color: cs.onSurfaceVariant),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 36,
          ),
          suffixIcon: q.isEmpty
              ? null
              : IconButton(
                  iconSize: 18,
                  splashRadius: 18,
                  tooltip: l.commonCancel,
                  icon: Icon(Icons.close, color: cs.onSurfaceVariant),
                  onPressed: () {
                    _ctl.clear();
                    controller.setQuery('');
                  },
                ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: widget.dense ? 8 : 12,
          ),
          // Fully-rounded pill on all states so the focus ring doesn't
          // jump to a different shape.
          border: _pillBorder(cs.outlineVariant),
          enabledBorder: _pillBorder(cs.outlineVariant.withValues(alpha: 0.6)),
          focusedBorder: _pillBorder(
            cs.primary.withValues(alpha: 0.7),
            width: 1.4,
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _pillBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
