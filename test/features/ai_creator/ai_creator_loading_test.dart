import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:savor_global/features/ai_creator/ai_creator_screen.dart';
import 'package:savor_global/l10n/generated/app_localizations.dart';
import 'package:savor_global/shared/theme.dart';
import 'package:savor_global/state/ai_recipe.dart';

/// AiRecipeController stub whose state is forced into the "generating"
/// branch from the moment Riverpod constructs it — lets the widget tree
/// under test observe the loading panel without firing a real API call.
class _LoadingAiRecipeController extends AiRecipeController {
  _LoadingAiRecipeController(super.ref) {
    state = const AiRecipeState(loading: true);
  }
}

/// Same stub, but for the "idle" branch — lets us assert that no quote
/// appears when the controller hasn't been kicked off yet.
class _IdleAiRecipeController extends AiRecipeController {
  _IdleAiRecipeController(super.ref);
}

/// Pumps the AI Creator screen mounted under a real (single-route)
/// GoRouter, since `StudioPage` calls `GoRouterState.of(context)`
/// internally to highlight the active tab. Without this wrapping we'd
/// get "no GoRouterState above the current context" at build time.
Future<void> _pumpScreen(
  WidgetTester tester, {
  required AiRecipeController Function(Ref) controllerBuilder,
}) async {
  // The real router wraps every Studio route in an `AppShell` (which
  // provides Material + Scaffold). Tests skip that wrapper, so we slot
  // in a bare Scaffold here — without it ChoiceChip / TextField inside
  // the creator card throw "No Material widget found".
  final router = GoRouter(
    initialLocation: '/ai/creator',
    routes: [
      GoRoute(
        path: '/ai/creator',
        builder: (_, _) => const Scaffold(body: AiCreatorScreen()),
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        aiRecipeProvider.overrideWith(controllerBuilder),
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

void main() {
  testWidgets('shows rotating cooking quote while AI is generating',
      (tester) async {
    await _pumpScreen(
      tester,
      controllerBuilder: (ref) => _LoadingAiRecipeController(ref),
    );

    // The first quote in the EN .arb file. If this string changes,
    // either update the test or refactor _LoadingPanel to expose its
    // quote list publicly so tests can read it directly.
    expect(
      find.text('Sharpening the knives and chopping scallions…'),
      findsOneWidget,
    );

    // The cycler advances every 3.5s — wait one cycle + the 320ms
    // cross-fade and confirm a *different* localized quote is on
    // screen. We assert positively on quote #2 rather than negatively
    // on quote #1 to avoid a flaky window where the AnimatedSwitcher
    // is mid-crossfade and both strings are simultaneously mounted.
    await tester.pump(const Duration(milliseconds: 4000));
    expect(
      find.text('Roasting raw spices to unlock golden aromas…'),
      findsOneWidget,
      reason: 'After 3.5s the rotator should land on quote #2',
    );

    // Tear the widget tree down so the _LoadingPanel's periodic timer
    // is cancelled in dispose() — leaving it running would fail the
    // post-test "no pending timers" guard.
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('hides the loading panel when not generating', (tester) async {
    await _pumpScreen(
      tester,
      controllerBuilder: (ref) => _IdleAiRecipeController(ref),
    );

    // No quote text in the rendered tree when state.loading == false.
    expect(
      find.text('Sharpening the knives and chopping scallions…'),
      findsNothing,
    );
  });
}
