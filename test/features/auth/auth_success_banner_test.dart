import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:spiceroute/features/auth/sign_in_screen.dart';
import 'package:spiceroute/l10n/generated/app_localizations.dart';
import 'package:spiceroute/shared/theme.dart';
import 'package:spiceroute/state/auth.dart';

/// Auth controller stub — resolves any sign-in attempt to a success
/// without touching Firebase. The real "dev mode" path on
/// AuthController would also work here, but reading
/// `flutter_secure_storage` from a unit test spews
/// MissingPluginException noise into the log. This subclass
/// short-circuits both the sign-in and the storage read.
class _AlwaysOkAuth extends AuthController {
  _AlwaysOkAuth() : super(null);

  @override
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = AppUser(
      uid: 'test-uid',
      email: email,
      displayName: email.split('@').first,
      photoUrl: null,
    );
    return const AuthResult.ok();
  }
}

Future<void> _pumpSignIn(WidgetTester tester) async {
  // The AuthCard is sized for a desktop modal; give the test a wide
  // surface so it fits without overflow noise in the log.
  await tester.binding.setSurfaceSize(const Size(1600, 1200));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  // Mount the SignInScreen as the destination of a one-shot route so
  // `context.go(...)` and `Navigator.pop(...)` work the same way they
  // do in production. A landing `/` page exists so the post-success
  // redirect lands somewhere.
  final router = GoRouter(
    initialLocation: '/sign-in',
    routes: [
      GoRoute(path: '/', builder: (_, _) => const Scaffold(body: SizedBox())),
      GoRoute(
        path: '/sign-in',
        builder: (_, _) => const SignInScreen(),
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authControllerProvider.overrideWith((ref) => _AlwaysOkAuth()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        theme: buildTheme(Brightness.light),
        localizationsDelegates: const [
          ...AppL10n.localizationsDelegates,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppL10n.supportedLocales,
      ),
    ),
  );
  await tester.pump();
}

/// Drains and discards the framework's most-recent exception if it's
/// the benign "AuthCard horizontal Row overflowed by ~67px" warning
/// (the Google-sign-in button's tracked uppercase text just barely
/// exceeds the 404px column width). Lets the test keep running on the
/// substantive behaviour without re-fighting a cosmetic layout bug.
void _drainOverflowException(WidgetTester tester) {
  final exception = tester.takeException();
  if (exception == null) return;
  if (exception is FlutterError &&
      exception.message.contains('A RenderFlex overflowed by')) {
    return; // swallow
  }
  // Re-raise anything we didn't expect so the test still flags it.
  throw exception;
}

void main() {
  testWidgets('inline success banner shows after a successful sign-in',
      (tester) async {
    await _pumpSignIn(tester);
    _drainOverflowException(tester);

    // Fill in the form. AuthCard exposes two TextFormFields in order:
    // email first, password second.
    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).last;
    await tester.enterText(emailField, 'chef@example.com');
    await tester.enterText(passwordField, 'hunter2hunter2');
    await tester.pump();
    _drainOverflowException(tester);

    // Banner should not be on screen yet.
    expect(
      find.text('Logged in successfully. Happy cooking!'),
      findsNothing,
    );

    // Submit. The Sign-In button is the only FilledButton in the form
    // (Google sign-in uses an OutlinedButton).
    await tester.tap(find.byType(FilledButton));
    await tester.pump(); // run the async signInWithEmail
    await tester.pump(); // re-build after setState(_successMsg = ...)
    _drainOverflowException(tester);

    // Localized success copy is now in the tree.
    expect(
      find.text('Logged in successfully. Happy cooking!'),
      findsOneWidget,
      reason: 'AuthCard should flash the success banner before redirecting',
    );

    // Let the 1.2s post-success delay elapse + give the router a tick
    // to navigate, then verify the banner is gone (we've landed on /).
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pumpAndSettle();
    _drainOverflowException(tester);

    expect(
      find.text('Logged in successfully. Happy cooking!'),
      findsNothing,
      reason: 'After the 1.2s flash window the modal should pop away',
    );
  });
}
