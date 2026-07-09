import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../state/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom sheet opened from the center [+] on the phone tab bar (and the
/// tablet header create button).
Future<void> showShellCreateSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => const _ShellCreateSheet(),
  );
}

class _ShellCreateSheet extends ConsumerWidget {
  const _ShellCreateSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final user = ref.watch(authControllerProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l.createSheetTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            _CreateOption(
              icon: Icons.auto_awesome_outlined,
              title: l.createSheetAiTitle,
              subtitle: l.createSheetAiSubtitle,
              onTap: () {
                Navigator.pop(context);
                context.go('/ai/creator');
              },
            ),
            const SizedBox(height: 8),
            _CreateOption(
              icon: Icons.restaurant_outlined,
              title: l.createSheetMyRecipesTitle,
              subtitle: l.createSheetMyRecipesSubtitle,
              onTap: () {
                Navigator.pop(context);
                if (user == null) {
                  context.push(
                    '/sign-in?next=${Uri.encodeComponent('/my-recipes')}',
                  );
                } else {
                  context.go('/my-recipes');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateOption extends StatelessWidget {
  const _CreateOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: cs.primary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact create trigger for the tablet top nav.
class ShellCreateButton extends StatelessWidget {
  const ShellCreateButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return IconButton(
      tooltip: l.createSheetTitle,
      onPressed: () => showShellCreateSheet(context),
      icon: const Icon(Icons.add_circle_outline),
    );
  }
}
