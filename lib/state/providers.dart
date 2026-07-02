import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import 'auth.dart';
import 'locale.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(
    tokenProvider: ({bool forceRefresh = false}) {
      final ctrl = ref.read(authControllerProvider.notifier);
      return ctrl.getIdToken(forceRefresh: forceRefresh);
    },
    uiLocaleCode: () => ref.read(localeProvider).languageCode,
  );
  ref.listen<Locale>(localeProvider, (prev, next) {
    if (prev?.languageCode != next.languageCode) {
      client.setUiLocaleCodeProvider(() => next.languageCode);
    }
  });
  return client;
});

/// The local DB user id (UUID) for the currently signed-in Firebase user.
///
/// Useful for ownership checks on recipes (which carry a `SpiceRouteOwner.id`
/// that is the local UUID, not the Firebase uid). Auto-refetches when the
/// Firebase user changes.
final meProvider = FutureProvider<String?>((ref) async {
  final user = ref.watch(authControllerProvider);
  if (user == null) return null;
  try {
    final api = ref.read(apiClientProvider);
    final me = await api.me();
    return me['id'] as String?;
  } on ApiException {
    return null;
  }
});
