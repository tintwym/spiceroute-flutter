import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/api/api_client.dart';
import 'package:spiceroute/models/spice_route.dart';

/// Stand-in [ApiClient] for SavedRecipesController tests that don't
/// exercise the network. Any call throws — the tests should never
/// reach the API surface, so a throw is louder than returning a
/// default and lets the test fail with a clear stack instead of a
/// confused "why did the controller publish empty state?" question.
class NoNetworkApi implements ApiClient {
  @override
  Future<SpiceRouteDetail> getRecipe(String id, {String? translateTo}) {
    throw StateError(
      'NoNetworkApi.getRecipe($id) was called — the test under test '
      "shouldn't be reaching the API.",
    );
  }

  @override
  noSuchMethod(Invocation invocation) {
    throw StateError(
      'NoNetworkApi.${invocation.memberName.toString()} was called — '
      "the test under test shouldn't be reaching the API.",
    );
  }
}

/// Installs an in-memory mock for `flutter_secure_storage` so
/// SavedRecipesController._bootstrap doesn't throw
/// MissingPluginException on read/write/delete. We don't need to
/// persist anything across tests — every read just returns null and
/// every write/delete is a no-op.
///
/// Call from `setUpAll` (or per-test `setUp`) in any test that
/// instantiates SavedRecipesController.
void mockSecureStorage() {
  const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  TestDefaultBinaryMessengerBinding
      .instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async {
    // Every flutter_secure_storage method we exercise -- read, write,
    // delete -- is happy with null/empty responses. The plugin treats
    // null as "no value stored" which is exactly what we want.
    return null;
  });
}
