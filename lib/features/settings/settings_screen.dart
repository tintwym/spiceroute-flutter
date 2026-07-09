import '../profile/profile_screen.dart';

/// Legacy route — redirects to [ProfileScreen] via router. Kept so any
/// deep links to `/settings` still resolve.
typedef SettingsScreen = ProfileScreen;
