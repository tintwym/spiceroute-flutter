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

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    final result = await ref
        .read(authControllerProvider.notifier)
        .signInWithEmail(email: _email.text, password: _password.text);
    if (!mounted) return;
    setState(() => _busy = false);
    if (result.ok) {
      _goNext();
    } else {
      showSnack(context, localizeAuthError(AppL10n.of(context), result.error));
    }
  }

  Future<void> _google() async {
    setState(() => _busy = true);
    final result =
        await ref.read(authControllerProvider.notifier).signInWithGoogle();
    if (!mounted) return;
    setState(() => _busy = false);
    if (result.ok) {
      _goNext();
    } else if (result.error != 'cancelled') {
      showSnack(context, localizeAuthError(AppL10n.of(context), result.error));
    }
  }

  Future<void> _forgotPassword() async {
    final l = AppL10n.of(context);
    final email = _email.text.trim();
    if (validateEmail(email) != null) {
      showSnack(context, l.authErrorInvalid);
      return;
    }
    final result =
        await ref.read(authControllerProvider.notifier).sendPasswordReset(email);
    if (!mounted) return;
    showSnack(
      context,
      result.ok ? l.authResetSent : localizeAuthError(l, result.error),
    );
  }

  void _goNext() {
    final dest = widget.redirectTo ?? '/';
    context.go(dest);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final devMode = ref.watch(authControllerProvider.notifier).devMode;

    return AuthCard(
      title: l.authWelcomeTitle,
      subtitle: l.authWelcomeSubtitle,
      bottomNote: _BottomNote(text: devMode ? l.authDevModeBanner : l.authFirebaseNote),
      body: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                onPressed: () =>
                    setState(() => _showPassword = !_showPassword),
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
                : () => context.go('/register', extra: widget.redirectTo),
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
      ),
    );
  }
}
