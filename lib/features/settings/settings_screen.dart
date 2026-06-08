import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../state/auth.dart';
import '../../state/locale.dart';
import '../../state/theme_mode.dart';

/// Lightweight settings screen: theme, language, account, about.
///
/// Kept stateless and inline (no separate child screens) because each
/// setting fits cleanly in a single tap. Persisted via the corresponding
/// provider (themeMode, locale).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);

    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final user = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          _SectionHeader(label: l.settingsAppearance),
          _ThemeTile(current: themeMode),
          const Divider(height: 32),

          _SectionHeader(label: l.settingsLanguage),
          _LanguageTile(current: locale),
          const Divider(height: 32),

          _SectionHeader(label: l.settingsAccount),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(
              user != null
                  ? l.settingsAccountSignedInAs(
                      user.displayName ?? user.email ?? '-',
                    )
                  : l.settingsAccountGuest,
            ),
            subtitle: user?.email != null ? Text(user!.email!) : null,
            trailing: user == null
                ? FilledButton.tonal(
                    onPressed: () => context.go('/sign-in'),
                    child: Text(l.authSignIn),
                  )
                : TextButton(
                    onPressed: () async {
                      await ref
                          .read(authControllerProvider.notifier)
                          .signOut();
                    },
                    child: Text(l.authSignOut),
                  ),
          ),
          const Divider(height: 32),

          _SectionHeader(label: l.settingsAbout),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              l.settingsAboutBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              l.settingsVersion('0.3.0'),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          letterSpacing: 1.2,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _ThemeTile extends ConsumerWidget {
  const _ThemeTile({required this.current});
  final ThemeMode current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final notifier = ref.read(themeModeProvider.notifier);

    Widget chip(ThemeMode mode, IconData icon, String label) {
      final selected = current == mode;
      return ChoiceChip(
        avatar: Icon(icon, size: 18),
        label: Text(label),
        selected: selected,
        onSelected: (_) => notifier.set(mode),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          chip(ThemeMode.system, Icons.brightness_auto, l.settingsThemeSystem),
          chip(ThemeMode.light, Icons.light_mode, l.settingsThemeLight),
          chip(ThemeMode.dark, Icons.dark_mode, l.settingsThemeDark),
        ],
      ),
    );
  }
}

class _LanguageTile extends ConsumerWidget {
  const _LanguageTile({required this.current});
  final Locale current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final notifier = ref.read(localeProvider.notifier);

    final entries = <(Locale, String)>[
      (const Locale('en'), l.languageEnglish),
      (const Locale('zh'), l.languageChinese),
      (const Locale('th'), l.languageThai),
      (const Locale('ja'), l.languageJapanese),
      (const Locale('ko'), l.languageKorean),
      (const Locale('vi'), l.languageVietnamese),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final (loc, label) in entries)
            ChoiceChip(
              label: Text(label),
              selected: current.languageCode == loc.languageCode,
              onSelected: (_) => notifier.set(loc),
            ),
        ],
      ),
    );
  }
}
