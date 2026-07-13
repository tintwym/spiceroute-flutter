import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../state/auth.dart';
import 'auth_card.dart';
import 'auth_helpers.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key, this.redirectTo});

  /// Route to navigate to once sign-in succeeds. Defaults to `/`.
  final String? redirectTo;

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _showPassword = false;

  /// Localized success message shown inline for ~1.2s before [_goNext]
  /// closes the modal. Mirrors the React modal which flashes "Logged in
  /// successfully" before dismissing.
  String? _successMsg;

  @override
  void initState() {
    super.initState();
    // Used to be handled by a top-level GoRouter redirect, but that
    // redirect would collapse the route stack (destroying any modal
    // we were pushed on top of) when it fired in response to the
    // sign-in success rebuild. Now each auth screen handles the
    // already-signed-in case itself with a post-frame bounce, which
    // uses pop-preferred navigation in `_goNext`.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (ref.read(authControllerProvider) != null) {
        _goNext();
      }
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    // Re-entrancy guard. `_signIn` fires from BOTH the password
    // field's `onSubmitted` (hardware Enter / IME "done") AND the
    // primary button — without this guard, a user mashing Enter
    // twice (or tapping the button while Enter is still in flight)
    // would issue two parallel `signInWithEmail` calls. The second
    // typically dies with `INVALID_LOGIN_CREDENTIALS` because Firebase
    // has rate-limit-style protection on rapid duplicate attempts,
    // and the user sees that as the snack message even though their
    // FIRST call succeeded and they're now signed in. Drop dupes on
    // the floor.
    if (_busy) return;
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    // try/finally guarantees `_busy` is reset even if the controller
    // throws an UNCAUGHT exception (network blip, plugin error, etc.).
    // Without it, the button stays disabled forever and the user is
    // wedged with no way to retry.
    try {
      final result = await ref
          .read(authControllerProvider.notifier)
          .signInWithEmail(email: _email.text, password: _password.text);
      if (!mounted) return;
      if (result.ok) {
        _flashThenGo(AppL10n.of(context).authSuccessSignIn);
      } else {
        showSnack(
          context,
          localizeAuthError(AppL10n.of(context), result.error),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _google() async {
    // Same double-submit guard as `_signIn`. Belt-and-braces against
    // rapid taps on the Google button before `_busy` propagates to
    // disable it.
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final result = await ref
          .read(authControllerProvider.notifier)
          .signInWithGoogle();
      if (!mounted) return;
      if (result.ok) {
        _flashThenGo(AppL10n.of(context).authSuccessGoogle);
      } else if (result.error != 'cancelled') {
        showSnack(
          context,
          localizeAuthError(AppL10n.of(context), result.error),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Show the inline success banner for 1.2s, then navigate. Short enough
  /// that the user isn't blocked, long enough that the affordance reads
  /// as a confirmation rather than a glitch.
  ///
  /// The mounted guard inside the callback is mandatory: the user can
  /// close the modal (or the route can be popped externally by a deep
  /// link) during the 1.2 s window. Without it, `_goNext` would touch
  /// `context.go` / `Navigator.of(context)` on a disposed `State`,
  /// throwing `Looking up a deactivated widget's ancestor is unsafe`.
  void _flashThenGo(String message) {
    setState(() => _successMsg = message);
    Future<void>.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      _goNext();
    });
  }

  Future<void> _forgotPassword() async {
    final l = AppL10n.of(context);
    final email = _email.text.trim();
    if (validateEmail(email) != null) {
      showSnack(context, l.authErrorInvalid);
      return;
    }
    final result = await ref
        .read(authControllerProvider.notifier)
        .sendPasswordReset(email);
    if (!mounted) return;
    showSnack(
      context,
      result.ok ? l.authResetSent : localizeAuthError(l, result.error),
    );
  }

  void _goNext() {
    // Prefer an explicit `next` destination (e.g. + sheet → My Recipes).
    // When auth was pushed as a modal ON TOP of the destination itself
    // (recipe detail, AI Creator), pop so we keep local state instead of
    // remounting via `go`.
    final next = widget.redirectTo;
    final navigator = Navigator.of(context);
    if (next != null && next.isNotEmpty) {
      if (navigator.canPop() && _shouldPopToPreserve(next)) {
        navigator.pop();
        return;
      }
      context.go(next);
      return;
    }
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }
    context.go('/');
  }

  /// Destinations that launched sign-in as an overlay on themselves —
  /// remounting with `go` would wipe draft / checklist / idea state.
  static bool _shouldPopToPreserve(String next) =>
      next.startsWith('/recipes/') || next == '/ai/creator';

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final devMode = ref.watch(authControllerProvider.notifier).devMode;

    return AuthCard(
      title: l.authWelcomeTitle,
      subtitle: l.authWelcomeSubtitle,
      bottomNote: devMode ? _BottomNote(text: l.authDevModeBanner) : null,
      body: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_successMsg != null) ...[
              _SuccessBanner(message: _successMsg!),
              const SizedBox(height: 18),
            ],
            AuthLabel(l.authEmail),
            AuthField(
              controller: _email,
              icon: Icons.mail_outline,
              hint: l.authEmailHint,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              validator: validateEmail,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 18),
            AuthLabel(l.authPassword),
            AuthField(
              controller: _password,
              icon: Icons.lock_outline,
              hint: '••••••',
              obscureText: !_showPassword,
              autofillHints: const [AutofillHints.password],
              validator: validatePassword,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _signIn(),
              suffix: IconButton(
                icon: Icon(
                  _showPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                ),
                onPressed: () => setState(() => _showPassword = !_showPassword),
              ),
            ),
            if (!devMode)
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: _busy ? null : _forgotPassword,
                  child: Text(l.authForgotPassword),
                ),
              ),
            const SizedBox(height: 12),
            AuthPrimaryButton(
              label: l.authPrimarySignIn,
              busy: _busy,
              onPressed: _signIn,
            ),
            if (!devMode) ...[
              const SizedBox(height: 22),
              _OrDivider(label: l.authOrDivider),
              const SizedBox(height: 18),
              GoogleSignInButton(
                label: l.authContinueWithGoogle,
                onPressed: _busy ? null : _google,
              ),
            ],
          ],
        ),
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(l.authNoAccountYet),
          TextButton(
            onPressed: _busy
                ? null
                // Replace the current modal route with /register so
                // flipping between sign-in / register stays inside the
                // same modal layer (one Back / one close).
                : () => context.pushReplacement(
                    '/register',
                    extra: widget.redirectTo,
                  ),
            child: Text(l.authSignUpHere),
          ),
        ],
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.outlineVariant;
    return Row(
      children: [
        Expanded(child: Divider(color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 1.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
        Expanded(child: Divider(color: color)),
      ],
    );
  }
}

class _BottomNote extends StatelessWidget {
  const _BottomNote({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      textAlign: TextAlign.center,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
        height: 1.4,
        // Italic "fine-print" voice — matches the editorial subtitle
        // above and tells the reader this is supporting info, not action.
        fontStyle: FontStyle.italic,
      ),
    );
  }
}

/// Inline confirmation banner shown immediately after a successful sign-in
/// or registration, just before the modal dismisses itself. Soft green to
/// echo the editorial accent and match the community-board success state.
class _SuccessBanner extends StatelessWidget {
  const _SuccessBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF3FA35A).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF3FA35A).withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: Color(0xFF2E7D43)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF2E7D43),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
