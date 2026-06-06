import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import 'auth.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  // The token provider closes over `ref` rather than the controller object so
  // the same client instance keeps producing fresh tokens after sign-in /
  // sign-out without needing to be re-created.
  return ApiClient(
    tokenProvider: ({bool forceRefresh = false}) {
      final ctrl = ref.read(authControllerProvider.notifier);
      return ctrl.getIdToken(forceRefresh: forceRefresh);
    },
  );
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
