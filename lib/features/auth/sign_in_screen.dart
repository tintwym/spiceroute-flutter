import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../shared/breakpoints.dart';
import '../../state/auth.dart';
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

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    final result = await ref.read(authControllerProvider.notifier).signInWithEmail(
          email: _email.text,
          password: _password.text,
        );
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
    final theme = Theme.of(context);
    final maxW = contentMaxWidth(context).clamp(0, 440);
    final devMode =
        ref.watch(authControllerProvider.notifier).devMode;

    return Scaffold(
      appBar: AppBar(title: Text(l.authSignIn)),
      body: Center(
        child: SingleChildScrollView(
          padding: pagePadding(context),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW.toDouble()),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l.appTitle, style: theme.textTheme.headlineSmall),
                  if (devMode) ...[
                    const SizedBox(height: 16),
                    _DevModeBanner(text: l.authDevModeBanner),
                  ],
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    decoration: InputDecoration(labelText: l.authEmail),
                    validator: validateEmail,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    autofillHints: const [AutofillHints.password],
                    decoration: InputDecoration(labelText: l.authPassword),
                    validator: validatePassword,
                    onFieldSubmitted: (_) => _signIn(),
                  ),
                  if (!devMode)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _busy ? null : _forgotPassword,
                        child: Text(l.authForgotPassword),
                      ),
                    ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: _busy ? null : _signIn,
                    child: _busy
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l.authSignIn),
                  ),
                  const SizedBox(height: 16),
                  if (!devMode) ...[
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(l.authOrDivider),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (!devMode)
                    OutlinedButton.icon(
                      onPressed: _busy ? null : _google,
                      icon: const Icon(Icons.g_mobiledata, size: 28),
                      label: Text(l.authContinueWithGoogle),
                    ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l.authNoAccountYet),
                      TextButton(
                        onPressed: _busy
                            ? null
                            : () => context.go(
                                  '/register',
                                  extra: widget.redirectTo,
                                ),
                        child: Text(l.authSignUpHere),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DevModeBanner extends StatelessWidget {
  const _DevModeBanner({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
