import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:spiceroute/features/ai_companion/ai_companion_screen.dart';
import 'package:spiceroute/l10n/generated/app_localizations.dart';
import 'package:spiceroute/models/chat.dart';
import 'package:spiceroute/models/spice_route.dart';
import 'package:spiceroute/shared/theme.dart';
import 'package:spiceroute/state/chat.dart';
import 'package:spiceroute/api/api_client.dart';
import 'package:spiceroute/state/explore.dart';

/// Chat controller stub — lets each test pre-seed `state.messages` and
/// `state.streaming` without going through the real `send()` path
/// (which would try to hit the API).
///
/// The parent takes an ApiClient; we hand it a real-but-untouched one
/// since these tests never call send(). `ApiClient()` doesn't make any
/// network calls at construction, so this is safe.
class _StubChat extends ChatController {
  _StubChat({List<ChatMessage>? messages, bool streaming = false})
    : super(ApiClient()) {
    state = state.copyWith(
      messages: messages ?? const <ChatMessage>[],
      streaming: streaming,
    );
  }
}

/// Explore controller stub — pins `state.cuisine` to a known value
/// without hitting the network. We override `refresh()` to a no-op
/// because the parent constructor *calls* refresh() (virtually) and
/// Dio's connect-timeout timer would otherwise linger past the test
/// (tripping the framework's "pending timer" guard).
///
/// Takes a Ref because the real controller subscribes to
/// localeProvider in its constructor; we forward whatever Ref the
/// override callback hands us so the subscription is wired against
/// the test's ProviderScope (no test ever switches locale, so the
/// listener just sits idle).
class _StubExplore extends ExploreController {
  _StubExplore({required Ref ref, Cuisine? cuisine}) : super(ApiClient(), ref) {
    if (cuisine != null) {
      state = state.copyWith(cuisine: cuisine);
    } else {
      state = state.copyWith(clearCuisine: true);
    }
  }

  @override
  Future<void> refresh({bool localeChanged = false}) async {
    // Intentionally empty — see class comment.
  }
}

Future<void> _pumpCompanion(
  WidgetTester tester, {
  required ChatController chatStub,
  Cuisine? exploreCuisine,
}) async {
  // Wrap in a single-route GoRouter for the same reason as the AI
  // Creator test: StudioPage queries GoRouterState to render PageTabs.
  final router = GoRouter(
    initialLocation: '/ai/companion',
    routes: [
      GoRoute(
        path: '/ai/companion',
        builder: (_, _) => const Scaffold(body: AiCompanionScreen()),
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        chatProvider.overrideWith((ref) => chatStub),
        // _StubExplore needs a Ref to satisfy the production
        // constructor's localeProvider subscription, so build it
        // INSIDE the override where `ref` is in scope.
        exploreProvider.overrideWith(
          (ref) => _StubExplore(ref: ref, cuisine: exploreCuisine),
        ),
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
  testWidgets('Active Focus reads "Global" when no cuisine is selected', (
    tester,
  ) async {
    await _pumpCompanion(tester, chatStub: _StubChat(), exploreCuisine: null);
    // EN copy for `aiCompanionActiveFocus` is "Active Focus: Global".
    expect(find.text('Active Focus: Global'), findsOneWidget);
  });

  testWidgets('Active Focus reflects the currently-selected cuisine', (
    tester,
  ) async {
    await _pumpCompanion(
      tester,
      chatStub: _StubChat(),
      exploreCuisine: Cuisine.korean,
    );
    // The interpolated copy is "Active Focus: Korean" (`{cuisine}` is
    // the localized cuisine label from `CuisinePillBar.labelFor`).
    expect(find.text('Active Focus: Korean'), findsOneWidget);
  });

  testWidgets('empty assistant placeholder shows bouncing typing dots', (
    tester,
  ) async {
    // The chat controller seeds an empty model message just after the
    // user's turn — that's how the UI distinguishes "still waiting on
    // first token" from "model fully replied". With one such message
    // in `state.messages`, _MessageBubble should render _TypingDots
    // (an animated row with 3 sibling Containers) instead of a
    // SelectableText.
    final messages = [
      const ChatMessage(role: ChatRole.user, content: 'Hi chef'),
      const ChatMessage(role: ChatRole.model, content: ''),
    ];
    await _pumpCompanion(
      tester,
      chatStub: _StubChat(messages: messages, streaming: true),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // SelectableText would render once for the user message but the
    // empty-content assistant bubble swaps to _TypingDots instead, so
    // we only see one SelectableText total.
    expect(find.byType(SelectableText), findsOneWidget);

    // Tear down so the typing dots' AnimationController is disposed.
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('non-empty assistant message renders text, not typing dots', (
    tester,
  ) async {
    final messages = [
      const ChatMessage(role: ChatRole.user, content: 'Hi chef'),
      const ChatMessage(role: ChatRole.model, content: 'Hello back!'),
    ];
    await _pumpCompanion(tester, chatStub: _StubChat(messages: messages));

    // Both bubbles render their content as SelectableText.
    expect(find.text('Hi chef'), findsOneWidget);
    expect(find.text('Hello back!'), findsOneWidget);
    expect(find.byType(SelectableText), findsNWidgets(2));
  });
}
