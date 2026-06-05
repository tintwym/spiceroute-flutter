import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spice_route_app/shared/theme.dart';

void main() {
  testWidgets('theme builds without errors', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(Brightness.light),
        home: const Scaffold(body: Text('hello')),
      ),
    );
    expect(find.text('hello'), findsOneWidget);
  });
}
