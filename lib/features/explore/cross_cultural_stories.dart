import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/cross_cultural_stories.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/spice_route.dart';
import '../../shared/cuisine_chrome.dart';
import '../../shared/theme.dart';
import '../../state/explore.dart';
import '../../state/locale.dart';

/// "Cuisine Culinary Heritage & Connections" card. Renders only when a
/// specific cuisine is selected on Explore — for the "All cuisines" view
/// the card collapses to nothing.
///
/// Each panel describes one traditional course (breakfast → drinks) of the
/// selected cuisine, with editorial copy ported from the React reference.
/// Tapping a panel toggles the matching [Course] filter on the recipe
/// grid — same affordance the React app has.
class CrossCulturalStoriesCard extends ConsumerWidget {
  const CrossCulturalStoriesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final cuisine = ref.watch(exploreProvider.select((s) => s.cuisine));
    final activeCourse =
        ref.watch(exploreProvider.select((s) => s.course));
    final lang = ref.watch(localeProvider).languageCode;

    if (cuisine == null || !hasStoriesFor(cuisine)) {
      return const SizedBox.shrink();
    }

    final name = cuisineLabel(l, cuisine);
    final byCourse = crossCulturalStories[cuisine]!;
    // Sort courses by their declared enum order so the cards always read
    // breakfast → lunch → … → drinks regardless of map iteration order.
    final entries = byCourse.entries.toList()
      ..sort((a, b) => a.key.index.compareTo(b.key.index));

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2, right: 12),
                child: Text('🌍', style: TextStyle(fontSize: 22)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.storiesHeading(name),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontFamily: 'PlayfairDisplay',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l.storiesSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              // Responsive grid: 1 col under 560, 2 cols up to 900, 3 cols
              // above. Each tile is uniformly sized via flex.
              final w = constraints.maxWidth;
              final cols = w < 560 ? 1 : (w < 900 ? 2 : 3);
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final e in entries)
                    SizedBox(
                      width: (w - (cols - 1) * 12) / cols,
                      child: _StoryTile(
                        course: e.key,
                        text: e.value[lang] ?? e.value['en'] ?? '',
                        active: activeCourse == e.key,
                        onTap: () {
                          final ctl = ref.read(exploreProvider.notifier);
                          ctl.setCourse(activeCourse == e.key ? null : e.key);
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

}

class _StoryTile extends StatelessWidget {
  const _StoryTile({
    required this.course,
    required this.text,
    required this.active,
    required this.onTap,
  });

  final Course course;
  final String text;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l = AppL10n.of(context);

    // Subtle peach accent inherited from the warm-orange filter chips;
    // mirrors the React reference's `#D4A373` highlight when a course is
    // pinned.
    const accent = Color(0xFFD4A373);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: active
                ? accent.withValues(alpha: 0.08)
                : cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: active ? accent : cs.outlineVariant,
              width: active ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(_courseEmoji(course), style: emojiTextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _courseLabel(l, course).toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: active ? const Color(0xFF8C6B4A) : cs.onSurface,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  if (active)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        l.storiesActiveBadge,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                text,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _courseEmoji(Course c) {
    switch (c) {
      case Course.breakfast:
        return '🍳';
      case Course.highTea:
        return '🫖';
      case Course.lunch:
        return '🥗';
      case Course.soupsSaladsBowls:
        return '🥣';
      case Course.appetizer:
        return '🍢';
      case Course.sharingBoards:
        return '🧀';
      case Course.mainCourse:
        return '🍽️';
      case Course.sideDish:
        return '🥢';
      case Course.dessert:
        return '🍰';
      case Course.snack:
        return '🍿';
      case Course.drinks:
        return '🍸';
      case Course.zeroProofDrinks:
        return '🥤';
    }
  }

  static String _courseLabel(AppL10n l, Course c) {
    switch (c) {
      case Course.breakfast:
        return l.courseBreakfast;
      case Course.highTea:
        return l.courseHighTea;
      case Course.lunch:
        return l.courseLunch;
      case Course.soupsSaladsBowls:
        return l.courseSoupsSaladsBowls;
      case Course.appetizer:
        return l.courseAppetizer;
      case Course.sharingBoards:
        return l.courseSharingBoards;
      case Course.mainCourse:
        return l.courseMainCourse;
      case Course.sideDish:
        return l.courseSideDish;
      case Course.dessert:
        return l.courseDessert;
      case Course.snack:
        return l.courseSnack;
      case Course.drinks:
        return l.courseAlcoholicDrinks;
      case Course.zeroProofDrinks:
        return l.courseZeroProofDrinks;
    }
  }
}
