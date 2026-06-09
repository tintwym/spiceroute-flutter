import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savor_global/l10n/generated/app_localizations.dart';
import 'package:savor_global/shared/theme.dart';

/// Wraps a widget under test in the minimum scaffolding it needs to build:
/// a [ProviderScope] (with optional overrides), the same theme + l10n setup
/// `main.dart` uses, and a [MaterialApp] so `Navigator.of(context)` works.
///
/// The aim is to keep test files focused on assertions instead of dragging
/// the same boilerplate around — every widget test in this project should
/// go through this helper unless it specifically needs a custom shell.
Widget wrapWithApp({
  required Widget child,
  List<Override> overrides = const <Override>[],
  Locale? locale,
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: buildTheme(Brightness.light),
      locale: locale,
      localizationsDelegates: const [
        ...AppL10n.localizationsDelegates,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppL10n.supportedLocales,
      // Scaffold gives the child a Material ancestor + a default
      // ScaffoldMessenger so SnackBar-style calls don't blow up.
      home: Scaffold(body: child),
    ),
  );
}
