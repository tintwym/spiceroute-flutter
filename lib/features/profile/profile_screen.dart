import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/sign_out_confirm.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../state/auth.dart';
import '../../state/locale.dart';
import '../../state/theme_mode.dart';
import '../../shared/breakpoints.dart';
import '../../shared/page_tabs.dart';
import '../../shared/site_footer.dart';

/// Profile / Me tab — identity, My Recipes, preferences, and about.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final user = ref.watch(authControllerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final pad = pagePadding(context);
    final maxW = contentMaxWidth(context);
    final showTabs = !deviceClassOf(context).isPhone;

    Widget framed(Widget child) => Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: child,
      ),
    );

    return ListView(
      padding: EdgeInsets.only(
        top: showTabs ? 0 : 8,
        bottom: 24,
      ),
      children: [
        if (showTabs)
          Padding(
            padding: pad.copyWith(top: 24, bottom: 0),
            child: framed(const PageTabs()),
          ),
        Padding(
          padding: pad.copyWith(top: showTabs ? 24 : 16),
          child: framed(
            _ProfileHeader(user: user, l: l, theme: theme, cs: cs),
          ),
        ),
        Padding(
          padding: pad.copyWith(top: 24),
          child: framed(
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SectionHeader(label: l.profileYourKitchen),
                ListTile(
                  leading: const Icon(Icons.restaurant_outlined),
                  title: Text(l.navMyRecipes),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    if (user == null) {
                      context.push(
                        '/sign-in?next=${Uri.encodeComponent('/my-recipes')}',
                      );
                    } else {
                      context.go('/my-recipes');
                    }
                  },
                ),
                const Divider(height: 32),
                _SectionHeader(label: l.settingsAppearance),
                _ThemeTile(current: themeMode),
                const Divider(height: 32),
                _SectionHeader(label: l.settingsLanguage),
                _LanguageTile(current: locale),
                const Divider(height: 32),
                _SectionHeader(label: l.settingsAbout),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    l.settingsAboutBody,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    l.settingsVersion('0.3.0'),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.outline,
                    ),
                  ),
                ),
                if (user != null) ...[
                  const Divider(height: 16),
                  ListTile(
                    leading: Icon(Icons.logout, color: cs.error),
                    title: Text(
                      l.authSignOut,
                      style: TextStyle(color: cs.error),
                    ),
                    onTap: () => confirmAndSignOut(context, ref, navigateHome: true),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (showTabs)
          Padding(
            padding: pad.copyWith(top: 48, bottom: 28),
            child: framed(const SiteFooter()),
          ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.user,
    required this.l,
    required this.theme,
    required this.cs,
  });

  final AppUser? user;
  final AppL10n l;
  final ThemeData theme;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: cs.surfaceContainerHighest,
            child: Icon(Icons.person_outline, size: 36, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Text(
            l.profileWelcome,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            l.profileWelcomeSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => context.push(
              '/sign-in?next=${Uri.encodeComponent('/me')}',
            ),
            child: Text(l.authSignIn),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.push('/register?next=${Uri.encodeComponent('/me')}'),
            child: Text(l.authRegister),
          ),
        ],
      );
    }

    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: cs.primaryContainer,
          backgroundImage:
              user!.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
          child: user!.photoUrl == null
              ? Text(
                  user!.initial,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: cs.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user!.displayName ?? user!.email ?? l.settingsAccountGuest,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (user!.email != null) ...[
                const SizedBox(height: 4),
                Text(
                  user!.email!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
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
      return ChoiceChip(
        avatar: Icon(icon, size: 18),
        label: Text(label),
        selected: current == mode,
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
