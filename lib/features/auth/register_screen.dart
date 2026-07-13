import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../state/auth.dart';
import 'auth_card.dart';
import 'auth_helpers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key, this.redirectTo});
  final String? redirectTo;

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _showPassword = false;

  /// Same inline-confirmation pattern as [SignInScreen] — flash a short
  /// success banner before dismissing so the user knows the action
  /// completed instead of having the modal just blink out.
  String? _successMsg;

  @override
  void initState() {
    super.initState();
    // See `sign_in_screen.dart` for the rationale behind the
    // post-frame bounce: the top-level GoRouter redirect would
    // collapse the route stack on auth success, so each auth screen
    // self-handles the "already signed in" case.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (ref.read(authControllerProvider) != null) {
        _goNext();
      }
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // Re-entrancy guard. The "Register" button itself disables when
    // `_busy` is true via [AuthPrimaryButton], but `_register` can
    // also fire from the password field's `onSubmitted` (Enter on a
    // hardware keyboard, IME "done" on mobile). A user mashing Enter
    // twice — or hitting Enter then tapping the button before the
    // first call finished — used to fire TWO concurrent
    // `registerWithEmail` calls: the first succeeds and creates the
    // account, the second comes back with `email-already-in-use`,
    // and the second's error is what the user sees in the snack.
    // Net effect: account is created, but the user is told it
    // wasn't. Drop the second call on the floor.
    if (_busy) return;
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    // try/finally so `_busy` always resets — even if the controller
    // throws uncaught (e.g. plugin/network error). See sign_in_screen
    // for the full rationale.
    try {
      final result = await ref
          .read(authControllerProvider.notifier)
          .registerWithEmail(
            email: _email.text,
            password: _password.text,
            displayName: _name.text,
          );
      if (!mounted) return;
      if (result.ok) {
        _flashThenGo(AppL10n.of(context).authSuccessRegister);
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
    // Same double-submit guard as `_register`. The Google button is
    // disabled while `_busy`, but `_busy` is only `true` AFTER this
    // method's setState is applied. Two rapid taps (especially on
    // tablets where the touch target is large and the OS may
    // collapse a long-press into a double-tap) could otherwise fire
    // two `signInWithGoogle()` calls. The second's popup typically
    // dies with `cancelled-popup-request`, which we now skip — but
    // belt-and-braces here so the second call never starts.
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

  /// See `sign_in_screen.dart` for the rationale behind the mounted
  /// guard — same modal-can-be-closed-during-delay use-after-dispose
  /// race applies here.
  void _flashThenGo(String message) {
    setState(() => _successMsg = message);
    Future<void>.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      _goNext();
    });
  }

  /// Same modal-aware navigation as [SignInScreen]: honor `redirectTo`
  /// when set; pop for overlay destinations that must keep local state
  /// (recipe detail, AI Creator); otherwise `go(next)` / `/`.
  void _goNext() {
    final next = widget.redirectTo;
    final navigator = Navigator.of(context);
    if (next != null && next.isNotEmpty) {
      if (navigator.canPop() &&
          (next.startsWith('/recipes/') || next == '/ai/creator')) {
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

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final devMode = ref.watch(authControllerProvider.notifier).devMode;

    return AuthCard(
      title: l.authRegisterTitle,
      subtitle: l.authRegisterSubtitle,
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
            AuthLabel(l.authNameLabel),
            AuthField(
              controller: _name,
              icon: Icons.person_outline,
              hint: l.authNameHint,
              autofillHints: const [AutofillHints.name],
              textInputAction: TextInputAction.next,
              validator: (v) => (v == null || v.trim().isEmpty) ? '' : null,
            ),
            const SizedBox(height: 18),
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
              autofillHints: const [AutofillHints.newPassword],
              validator: validatePassword,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _register(),
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
            const SizedBox(height: 24),
            AuthPrimaryButton(
              label: l.authPrimaryRegister,
              busy: _busy,
              onPressed: _register,
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
          Text(l.authHasAccount),
          TextButton(
            onPressed: _busy
                ? null
                // pushReplacement keeps both auth modes inside a single
                // modal layer — flipping back to sign-in doesn't stack a
                // second card on top of the first.
                : () => context.pushReplacement(
                    '/sign-in',
                    extra: widget.redirectTo,
                  ),
            child: Text(l.authSignInHere),
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
        fontStyle: FontStyle.italic,
      ),
    );
  }
}

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
