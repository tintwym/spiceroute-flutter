import 'package:flutter/material.dart';

import 'theme.dart';

/// Polished full-width trigger used for the paired mobile filter rows on
/// Explore — region chooser + course/diet sheet opener.
///
/// Shared chrome keeps both controls visually matched: cream card surface,
/// emoji in a tinted icon well, hierarchy between hint vs active labels,
/// and a chevron in a soft circular affordance.
class MobileFilterTriggerPill extends StatelessWidget {
  const MobileFilterTriggerPill({
    super.key,
    required this.emoji,
    required this.label,
    required this.onTap,
    this.secondaryEmoji,
    this.isActive = false,
    this.expanded = false,
    this.embedded = false,
    this.semanticsExpanded,
  });

  final String emoji;

  /// Optional second glyph rendered beside [emoji] in the icon well
  /// (e.g. course + dietary sentinels on the cleared mobile filter).
  final String? secondaryEmoji;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final bool expanded;

  /// When true, renders as a borderless row inside a parent card (no
  /// shadow or outer border). Used for the region header inside the
  /// phone unified region + cuisine block.
  final bool embedded;

  /// When set, forwarded to [Semantics.expanded] (region accordion).
  final bool? semanticsExpanded;

  static const double _radius = 18;
  static const double _minHeight = 52;

  static BoxDecoration _outerDecoration(
    BuildContext context, {
    required bool isActive,
  }) {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: cs.surface,
      borderRadius: BorderRadius.circular(_radius),
      border: Border.all(
        color: isActive
            ? SpiceRoutePalette.naturalOchre.withValues(alpha: 0.45)
            : SpiceRoutePalette.naturalBorder,
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: SpiceRoutePalette.naturalCharcoal.withValues(
            alpha: isActive ? 0.08 : 0.05,
          ),
          blurRadius: isActive ? 14 : 10,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final labelColor = isActive
        ? SpiceRoutePalette.naturalCharcoal
        : cs.onSurfaceVariant;
    final labelWeight = isActive ? FontWeight.w600 : FontWeight.w500;

    final row = Row(
      children: [
        _EmojiWell(
          emoji: emoji,
          secondaryEmoji: secondaryEmoji,
          isActive: isActive,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ExcludeSemantics(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: labelColor,
                fontWeight: labelWeight,
                letterSpacing: isActive ? 0.1 : 0,
                height: 1.25,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: 8),
        _ChevronAffordance(expanded: expanded),
      ],
    );

    return Semantics(
      button: true,
      expanded: semanticsExpanded,
      label: label,
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_radius),
          splashColor: SpiceRoutePalette.naturalOchre.withValues(alpha: 0.12),
          highlightColor: SpiceRoutePalette.naturalOchre.withValues(
            alpha: 0.06,
          ),
          child: embedded
              ? ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: _minHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: row,
                  ),
                )
              : Ink(
                  decoration: _outerDecoration(context, isActive: isActive),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: _minHeight),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: row,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

/// Half-width trigger for the paired region + preferences row on phone
/// Explore (Option A). Parent [MobileRefineCombinedCard] supplies the
/// outer border/shadow — this half is borderless inside the card.
class MobileFilterTriggerHalf extends StatelessWidget {
  const MobileFilterTriggerHalf({
    super.key,
    required this.emoji,
    required this.label,
    required this.onTap,
    this.secondaryEmoji,
    this.isActive = false,
    this.expanded = false,
    this.semanticsExpanded,
  });

  final String emoji;
  final String? secondaryEmoji;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final bool expanded;
  final bool? semanticsExpanded;

  static const double _minHeight = 52;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final labelColor = isActive
        ? SpiceRoutePalette.naturalCharcoal
        : cs.onSurfaceVariant;
    final labelWeight = isActive ? FontWeight.w600 : FontWeight.w500;

    final row = Row(
      children: [
        _EmojiWell(
          emoji: emoji,
          secondaryEmoji: secondaryEmoji,
          isActive: isActive,
          compact: true,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ExcludeSemantics(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: labelColor,
                fontWeight: labelWeight,
                letterSpacing: isActive ? 0.1 : 0,
                height: 1.25,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: 4),
        _ChevronAffordance(expanded: expanded, compact: true),
      ],
    );

    return Semantics(
      button: true,
      expanded: semanticsExpanded,
      label: label,
      child: Material(
        color: isActive
            ? SpiceRoutePalette.naturalOchre.withValues(alpha: 0.08)
            : Colors.transparent,
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          splashColor: SpiceRoutePalette.naturalOchre.withValues(alpha: 0.12),
          highlightColor: SpiceRoutePalette.naturalOchre.withValues(
            alpha: 0.06,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _minHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: row,
            ),
          ),
        ),
      ),
    );
  }
}

/// Single card wrapping the region + preferences halves on phone Explore.
class MobileRefineCombinedCard extends StatelessWidget {
  const MobileRefineCombinedCard({
    super.key,
    required this.left,
    required this.right,
    this.isActive = false,
  });

  final Widget left;
  final Widget right;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: MobileFilterTriggerPill._outerDecoration(
        context,
        isActive: isActive,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: left),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: cs.outlineVariant.withValues(alpha: 0.7),
            ),
            Expanded(child: right),
          ],
        ),
      ),
    );
  }
}

class _EmojiWell extends StatelessWidget {
  const _EmojiWell({
    required this.emoji,
    required this.isActive,
    this.secondaryEmoji,
    this.compact = false,
  });

  final String emoji;
  final String? secondaryEmoji;
  final bool isActive;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dual = secondaryEmoji != null && secondaryEmoji!.isNotEmpty;
    final wellSize = compact ? 32.0 : 40.0;
    return Container(
      width: dual ? (compact ? 44.0 : 52.0) : wellSize,
      height: wellSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive
            ? SpiceRoutePalette.naturalOchre.withValues(alpha: 0.16)
            : cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? SpiceRoutePalette.naturalOchre.withValues(alpha: 0.35)
              : SpiceRoutePalette.naturalBorder,
        ),
      ),
      child: dual
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: emojiTextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                Text(
                  secondaryEmoji!,
                  style: emojiTextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : Text(
              emoji,
              style: emojiTextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
    );
  }
}

class _ChevronAffordance extends StatelessWidget {
  const _ChevronAffordance({required this.expanded, this.compact = false});

  final bool expanded;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = compact ? 26.0 : 30.0;
    return AnimatedRotation(
      turns: expanded ? 0.5 : 0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          shape: BoxShape.circle,
          border: Border.all(color: SpiceRoutePalette.naturalBorder),
        ),
        child: Icon(Icons.expand_more, size: 20, color: cs.secondary),
      ),
    );
  }
}
