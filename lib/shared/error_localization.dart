import 'package:flutter/widgets.dart';

import '../api/api_client.dart';
import '../l10n/generated/app_localizations.dart';
import '../state/explore.dart' show kUnknownErrorSentinel;

/// Swaps any locale-agnostic sentinel string raised from the data
/// layer for its translated equivalent in the active [AppL10n].
/// Server-supplied `detail` strings and HTTP status-line text pass
/// through unchanged — they're either already localized by the
/// backend (recipe detail messages) or are spec'd English (HTTP
/// reason phrases).
///
/// Why a helper instead of a context-aware exception class: the
/// data layer can't reach [BuildContext] and shouldn't have to
/// know what [AppL10n] is. The sentinel pattern keeps the
/// boundary clean — `ApiClient` and state notifiers stamp a known
/// marker, the widget swaps in the live locale's string. Tested
/// indirectly via every error-state widget test that pumps a real
/// l10n delegate.
String localizeApiErrorMessage(BuildContext context, String message) {
  final l = AppL10n.of(context);
  return switch (message) {
    kApiErrorNetworkSentinel => l.errorNetwork,
    kUnknownErrorSentinel => l.commonError,
    _ => message,
  };
}
