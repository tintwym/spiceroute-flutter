import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/features/auth/sign_out_confirm.dart';

import '../../helpers/test_harness.dart';

void main() {
  testWidgets('showSignOutConfirm returns false when cancelled', (
    tester,
  ) async {
    bool? result;

    await tester.pumpWidget(
      wrapWithApp(
        child: Builder(
          builder: (context) => FilledButton(
            onPressed: () async {
              result = await showSignOutConfirm(context);
            },
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Sign out?'), findsOneWidget);
    expect(
      find.text(
        "You'll need to sign in again to access your saved recipes and AI features.",
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(result, isFalse);
    expect(find.text('Sign out?'), findsNothing);
  });
}
