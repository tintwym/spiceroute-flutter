import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';

/// The auth modal box used by Sign In and Register.
///
/// Renders as a floating card over a transparent [Scaffold] so the route
/// driving it can be configured as a `CustomTransitionPage(opaque: false)`
/// — the underlying page (Explore / Settings / wherever the user opened
/// auth from) stays visible behind a dimmed scrim that the router
/// supplies.
///
/// Composition:
///   * tap-anywhere-outside the card → dismiss
///   * close (×) button pinned inside the card → dismiss
///   * logo hero, title, subtitle, caller-supplied body + footer
///   * scrollable inner column so the card works on short phones
class AuthCard extends StatelessWidget {
  const AuthCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.footer,
    this.bottomNote,
  });

  final String title;
  final String subtitle;
  final Widget body;
  final Widget footer;
  final Widget? bottomNote;

  void _close(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      GoRouter.of(context).go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppL10n.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Tap-catcher behind the card — taps that miss the modal
          // dismiss it (the router barrier handles the same thing, but
          // adding it inside the Scaffold means the gesture still works
          // even if the outer barrier was overridden).
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _close(context),
              child: const SizedBox.expand(),
            ),
          ),
          // Centered card. Wrapped in SafeArea so it doesn't slip under
          // notches; padding gives the dimmed scrim some room to breathe.
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  // Inner GestureDetector swallows taps so the form
                  // doesn't propagate up and trigger the outer dismiss.
                  child: GestureDetector(
                    onTap: () {},
                    child: Material(
                      color: theme.colorScheme.surface,
                      elevation: 18,
                      shadowColor: Colors.black.withValues(alpha: 0.30),
                      borderRadius: BorderRadius.circular(28),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const _LogoHero(),
                                const SizedBox(height: 20),
                                Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  subtitle,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                    // Subtle italic gives the subtitle the
                                    // editorial-magazine voice that pairs
                                    // with the serif title above.
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                body,
                                const SizedBox(height: 24),
                                footer,
                                if (bottomNote != null) ...[
                                  const SizedBox(height: 16),
                                  bottomNote!,
                                ],
                              ],
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: IconButton(
                              tooltip: l.commonClose,
                              icon: const Icon(Icons.close),
                              onPressed: () => _close(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// SpiceRoute brandmark inside a soft-bordered circular badge. Replaced
/// the generic `Icons.auto_awesome` sparkle so the auth card carries the
/// app's identity — the same steaming-bowl glyph shown in the top nav,
/// favicon, and PWA install banner.
///
/// The logo image (`assets/icon/icon.png`) has its own red background,
/// so we clip it into a circle and let it fully fill the badge. The
/// outline border is kept for visual continuity with other circular
/// chrome elements in the card (avatar slots, social-sign-in buttons).
class _LogoHero extends StatelessWidget {
  const _LogoHero();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/icon/icon.png',
            fit: BoxFit.cover,
            // Tiny semantic label so screen readers announce the brand
            // mark instead of "image" — matches the top nav's logo
            // treatment.
            semanticLabel: 'SpiceRoute',
          ),
        ),
      ),
    );
  }
}

/// Uppercase, tracked label that sits above each input.
class AuthLabel extends StatelessWidget {
  const AuthLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

/// Input field styled to match the screenshots: prefix icon, soft border,
/// trailing optional widget (used for the password eye toggle).
class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.controller,
    required this.icon,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.autofillHints,
    this.suffix,
    this.validator,
    this.textInputAction,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      validator: validator,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
          child: Icon(
            icon,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            size: 20,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 4),
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
      ),
    );
  }
}

/// Tall, full-width filled button used as the primary action.
class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: FilledButton(
        onPressed: busy ? null : onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        child: busy
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(label.toUpperCase()),
      ),
    );
  }
}

/// Tall, white-with-border outlined button used for "Continue with Google".
class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: BorderSide(color: theme.colorScheme.outlineVariant),
          backgroundColor: theme.colorScheme.surface,
          foregroundColor: theme.colorScheme.onSurface,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const GoogleLogo(size: 22),
            const SizedBox(width: 12),
            Text(label.toUpperCase()),
          ],
        ),
      ),
    );
  }
}

/// Official Google "G" logo, rendered from the four canonical SVG paths
/// inlined as a string (no asset file needed).
class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key, this.size = 24});
  final double size;

  static const _svg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
  <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
  <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
  <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22.81-.63z"/>
  <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.52 6.16-4.52z"/>
</svg>''';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(_svg, width: size, height: size);
  }
}
