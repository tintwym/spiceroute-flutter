import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../shared/breakpoints.dart';
import '../../state/auth.dart';
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

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    final result = await ref.read(authControllerProvider.notifier).registerWithEmail(
          email: _email.text,
          password: _password.text,
          displayName: _name.text,
        );
    if (!mounted) return;
    setState(() => _busy = false);
    if (result.ok) {
      context.go(widget.redirectTo ?? '/');
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
      context.go(widget.redirectTo ?? '/');
    } else if (result.error != 'cancelled') {
      showSnack(context, localizeAuthError(AppL10n.of(context), result.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final maxW = contentMaxWidth(context).clamp(0, 440);
    final devMode = ref.watch(authControllerProvider.notifier).devMode;

    return Scaffold(
      appBar: AppBar(title: Text(l.authRegister)),
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
                    _RegisterDevModeBanner(text: l.authDevModeBanner),
                  ],
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _name,
                    decoration: InputDecoration(labelText: l.authDisplayName),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? '' : null,
                  ),
                  const SizedBox(height: 12),
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
                    autofillHints: const [AutofillHints.newPassword],
                    decoration: InputDecoration(labelText: l.authPassword),
                    validator: validatePassword,
                    onFieldSubmitted: (_) => _register(),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _busy ? null : _register,
                    child: _busy
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l.authRegister),
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
                    OutlinedButton.icon(
                      onPressed: _busy ? null : _google,
                      icon: const Icon(Icons.g_mobiledata, size: 28),
                      label: Text(l.authContinueWithGoogle),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l.authHasAccount),
                      TextButton(
                        onPressed: _busy
                            ? null
                            : () => context.go(
                                  '/sign-in',
                                  extra: widget.redirectTo,
                                ),
                        child: Text(l.authSignInHere),
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

class _RegisterDevModeBanner extends StatelessWidget {
  const _RegisterDevModeBanner({required this.text});
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
            child: Text(text, style: theme.textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
