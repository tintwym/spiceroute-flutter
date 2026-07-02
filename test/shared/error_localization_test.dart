import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/api/api_client.dart';
import 'package:spiceroute/l10n/generated/app_localizations.dart';
import 'package:spiceroute/shared/error_localization.dart';
import 'package:spiceroute/state/explore.dart' show kUnknownErrorSentinel;

/// Contract tests for the sentinel-aware error-message helper. The
/// bug being pinned: `ApiClient._toApiException` used to return
/// hardcoded English strings ("Request timed out. Check your
/// connection and try again.") on every transport-level Dio failure,
/// which leaked into the error UI for every non-English user. The
/// fix replaces those literals with `kApiErrorNetworkSentinel`, and
/// THIS helper is what swaps them back into the active locale at
/// the render site.
///
/// If any future refactor drops a sentinel branch from
/// `localizeApiErrorMessage`, these tests fail loudly instead of
/// silently leaking the raw `__api_network_error__` marker into the
/// UI (which is what a user would actually see).
void main() {
  Future<String> pumpAndLookup(
    WidgetTester tester, {
    required Locale locale,
    required String sentinel,
  }) async {
    late String resolved;
    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        localizationsDelegates: AppL10n.localizationsDelegates,
        supportedLocales: AppL10n.supportedLocales,
        home: Builder(
          builder: (ctx) {
            resolved = localizeApiErrorMessage(ctx, sentinel);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    return resolved;
  }

  testWidgets('network sentinel resolves to English copy', (tester) async {
    final s = await pumpAndLookup(
      tester,
      locale: const Locale('en'),
      sentinel: kApiErrorNetworkSentinel,
    );
    expect(s, contains('connection'));
    expect(s, isNot(contains('__api')));
  });

  testWidgets('network sentinel resolves to Vietnamese copy', (tester) async {
    final s = await pumpAndLookup(
      tester,
      locale: const Locale('vi'),
      sentinel: kApiErrorNetworkSentinel,
    );
    // Vietnamese rendering must not be the English literal AND must
    // not leak the sentinel marker. Soft assertion on a known
    // anchor word ("kết nối" / "máy chủ") would be over-fitted to
    // the current copy; instead we just guarantee the leak fences.
    expect(s, isNot(contains('__api')));
    expect(s, isNot(equals(kApiErrorNetworkSentinel)));
    expect(
      s,
      isNot(contains('connection')),
      reason:
          'Vietnamese copy must not be the English literal — '
          'that would mean the ARB entry is missing for vi',
    );
  });

  testWidgets('unknown-error sentinel resolves to commonError', (tester) async {
    final s = await pumpAndLookup(
      tester,
      locale: const Locale('en'),
      sentinel: kUnknownErrorSentinel,
    );
    expect(s, equals('Something went wrong'));
  });

  testWidgets('non-sentinel server messages pass through unchanged', (
    tester,
  ) async {
    const serverMessage = 'Recipe not found';
    final s = await pumpAndLookup(
      tester,
      locale: const Locale('en'),
      sentinel: serverMessage,
    );
    expect(s, equals(serverMessage));
  });
}
