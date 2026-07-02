import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/l10n/generated/app_localizations.dart';
import 'package:spiceroute/shared/theme.dart';

void main() {
  testWidgets('theme + l10n builds without errors', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(Brightness.light),
        localizationsDelegates: const [
          ...AppL10n.localizationsDelegates,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppL10n.supportedLocales,
        home: Builder(
          builder: (ctx) =>
              Scaffold(body: Center(child: Text(AppL10n.of(ctx).appTitle))),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
