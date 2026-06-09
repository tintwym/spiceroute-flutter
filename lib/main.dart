import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'l10n/generated/app_localizations.dart';
import 'shared/firebase_options.dart';
import 'shared/router.dart';
import 'shared/theme.dart';
import 'state/locale.dart';
import 'state/theme_mode.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load symbol data for every locale we ship. Without this,
  // `DateFormat.yMMMd('zh').format(...)` (and equivalents for ja, ko,
  // vi, my) silently falls back to en_US, so review timestamps render
  // English month names in the middle of fully-localized copy. The
  // call is cheap — symbol tables are small constants.
  await initializeDateFormatting();
  if (firebaseConfigured) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e, st) {
      // Don't take the whole app down because Firebase init failed (network,
      // wrong values, etc.) — auth-gated UI will surface a clear error and
      // browse / AI Companion / AI Creator continue to work.
      debugPrint('Firebase init failed: $e\n$st');
    }
  }
  runApp(const ProviderScope(child: SavorApp()));
}

class SavorApp extends ConsumerWidget {
  const SavorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      onGenerateTitle: (ctx) => AppL10n.of(ctx).appTitle,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: supportedLocales,
    );
  }
}
