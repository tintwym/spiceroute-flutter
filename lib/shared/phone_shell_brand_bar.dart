import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import 'top_nav_bar.dart';

/// Olive sage brand strip for the phone shell — logo + wordmark live in
/// the status-bar / app-bar band (not in the scrolling page body).
class PhoneShellBrandBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PhoneShellBrandBar({super.key});

  static const double toolbarHeight = 52;

  @override
  Size get preferredSize => const Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final onPrimary = cs.onPrimary;

    return AppBar(
      backgroundColor: cs.primary,
      foregroundColor: onPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      toolbarHeight: toolbarHeight,
      titleSpacing: 16,
      title: InkWell(
        onTap: () => context.go('/'),
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandLogo(size: 28),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                l.heroTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: onPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  height: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
