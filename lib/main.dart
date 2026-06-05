import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared/router.dart';
import 'shared/theme.dart';

void main() {
  runApp(const ProviderScope(child: SpiceRouteApp()));
}

class SpiceRouteApp extends ConsumerWidget {
  const SpiceRouteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'SpiceRoute',
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
