import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import 'breakpoints.dart';
import 'top_nav_bar.dart' show BrandLogo;
import 'widgets.dart';

/// Page footer: brand blurb, quick navigation, and a newsletter signup —
/// the reference design's closing band. Collapses from three columns to a
/// stack on narrow viewports.
class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final dc = deviceClassOf(context);

    final brand = _BrandColumn();
    final nav = _NavColumn();
    final connect = const _ConnectColumn();

    final columns = dc.isAtLeastTablet
        ? IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: brand),
                const SizedBox(width: 32),
                Expanded(flex: 3, child: nav),
                const SizedBox(width: 32),
                Expanded(flex: 4, child: connect),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              brand,
              const SizedBox(height: 28),
              nav,
              const SizedBox(height: 28),
              connect,
            ],
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: cs.outlineVariant, height: 1),
        const SizedBox(height: 28),
        columns,
        const SizedBox(height: 24),
        Divider(color: cs.outlineVariant, height: 1),
        const SizedBox(height: 16),
        _BottomBar(),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _BrandColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const BrandLogo(size: 30),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                l.heroTitle,
                style: theme.textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Text(
            l.footerBlurb,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

class _NavColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ColumnHeader(l.footerQuickNav),
        const SizedBox(height: 14),
        _FooterLink(label: l.footerLinkExplore, onTap: () => context.go('/')),
        _FooterLink(
          label: l.footerLinkCreator,
          onTap: () => context.go('/ai/creator'),
        ),
        _FooterLink(
          label: l.footerLinkCompanion,
          onTap: () => context.go('/ai/companion'),
        ),
        _FooterLink(
          label: l.footerLinkSaved,
          onTap: () => context.go('/saved'),
        ),
      ],
    );
  }
}

class _ConnectColumn extends StatefulWidget {
  const _ConnectColumn();

  @override
  State<_ConnectColumn> createState() => _ConnectColumnState();
}

class _ConnectColumnState extends State<_ConnectColumn> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _join() {
    final l = AppL10n.of(context);
    if (_email.text.trim().isEmpty) return;
    _email.clear();
    FocusScope.of(context).unfocus();
    showAppSnack(context, l.footerJoinedToast);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ColumnHeader(l.footerConnect),
        const SizedBox(height: 14),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _join(),
          decoration: InputDecoration(
            hintText: l.footerEmailHint,
            prefixIcon: const Icon(Icons.mail_outline, size: 18),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: _join, child: Text(l.footerJoin)),
        ),
      ],
    );
  }
}

class _ColumnHeader extends StatelessWidget {
  const _ColumnHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: cs.onSurfaceVariant,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          // Matches the copyright holder in `LICENSE` at the project root,
          // so the visible footer and the legal MIT notice always agree.
          l.footerCopyright(DateTime.now().year, 'TintWaiYanMin'),
          style: muted,
        ),
        const SizedBox(height: 4),
        Text(l.footerLicense, style: muted),
      ],
    );
  }
}
