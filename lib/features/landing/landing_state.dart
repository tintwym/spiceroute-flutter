import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'landing_data.dart';
import 'landing_models.dart';

const _kPremiumKey = 'spiceroute_premium_subscribed';
const _kPostsKey = 'spice_route_community_posts';
const _kLandingCompletedKey = 'spiceroute_landing_completed';

const _storage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
  webOptions: WebOptions(dbName: 'savor_settings'),
);

/// Whether the user has completed the first-run marketing landing.
enum LandingGatePhase {
  /// Reading persisted flag — show a brief splash, no route flash.
  loading,

  /// First open (or flag missing) — skip the marketing landing and go straight
  /// to the app.
  firstVisit,

  /// Returning user — skip landing, go straight to the app.
  returning,
}

final landingGateProvider =
    StateNotifierProvider<LandingGateNotifier, LandingGatePhase>((ref) {
      return LandingGateNotifier();
    });

class LandingGateNotifier extends StateNotifier<LandingGatePhase> {
  LandingGateNotifier() : super(LandingGatePhase.loading) {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final raw = await _storage.read(key: _kLandingCompletedKey);
      state = raw == 'true'
          ? LandingGatePhase.returning
          : LandingGatePhase.firstVisit;
    } catch (e, st) {
      debugPrint('LandingGateNotifier._bootstrap failed: $e\n$st');
      state = LandingGatePhase.firstVisit;
    }
  }

  /// Call when the user leaves the marketing landing for the main app.
  Future<void> completeOnboarding() async {
    if (state == LandingGatePhase.returning) return;
    state = LandingGatePhase.returning;
    try {
      await _storage.write(key: _kLandingCompletedKey, value: 'true');
    } catch (e, st) {
      debugPrint('LandingGateNotifier.completeOnboarding failed: $e\n$st');
    }
  }
}

final landingPremiumProvider =
    StateNotifierProvider<LandingPremiumNotifier, bool>((ref) {
      return LandingPremiumNotifier();
    });

class LandingPremiumNotifier extends StateNotifier<bool> {
  LandingPremiumNotifier() : super(false) {
    _load();
  }

  Future<void> _load() async {
    try {
      final v = await _storage.read(key: _kPremiumKey);
      if (v == 'true') state = true;
    } catch (e, st) {
      debugPrint('LandingPremiumNotifier._load failed: $e\n$st');
    }
  }

  Future<void> setSubscribed(bool value) async {
    state = value;
    try {
      await _storage.write(key: _kPremiumKey, value: value.toString());
    } catch (e, st) {
      debugPrint('LandingPremiumNotifier.setSubscribed failed: $e\n$st');
    }
  }
}

final landingCommunityProvider =
    StateNotifierProvider<LandingCommunityNotifier, List<LandingCommunityPost>>(
      (ref) => LandingCommunityNotifier(),
    );

class LandingCommunityNotifier
    extends StateNotifier<List<LandingCommunityPost>> {
  LandingCommunityNotifier() : super(const []) {
    _load();
  }

  Future<void> _load() async {
    try {
      final raw = await _storage.read(key: _kPostsKey);
      if (raw != null) {
        final list = (jsonDecode(raw) as List<dynamic>)
            .map(
              (e) => LandingCommunityPost.fromJson(e as Map<String, dynamic>),
            )
            .where(_keepPost)
            .toList();
        state = list;
        return;
      }
    } catch (e, st) {
      debugPrint('LandingCommunityNotifier._load failed: $e\n$st');
    }
    state = landingInitialCommunityPosts.where(_keepPost).toList();
  }

  bool _keepPost(LandingCommunityPost p) {
    final user = p.username.toLowerCase();
    final dish = p.dishName.toLowerCase();
    final region = p.regionName.toLowerCase();
    final caption = p.caption.toLowerCase().trim();
    if (user.contains('dumpling') || dish.contains('dumpling')) return false;
    if (dish == 'sichuan mapo tofu' && region == 'europe') return false;
    if (caption == 'good' || caption == '"good"') return false;
    return true;
  }

  Future<void> _persist(List<LandingCommunityPost> posts) async {
    state = posts;
    try {
      final encoded = jsonEncode(posts.map((p) => p.toJson()).toList());
      // Web secure storage is small — skip persisting huge base64 payloads.
      if (encoded.length > 45000) {
        final trimmed = posts
            .map(
              (p) => p.imageUrl.startsWith('data:')
                  ? p.copyWith(imageUrl: '')
                  : p,
            )
            .toList();
        await _storage.write(
          key: _kPostsKey,
          value: jsonEncode(trimmed.map((p) => p.toJson()).toList()),
        );
        return;
      }
      await _storage.write(key: _kPostsKey, value: encoded);
    } catch (e, st) {
      debugPrint('LandingCommunityNotifier._persist failed: $e\n$st');
    }
  }

  void like(String id) {
    _persist([
      for (final p in state)
        if (p.id == id) p.copyWith(likes: p.likes + 1) else p,
    ]);
  }

  void deletePost(String id) {
    _persist(state.where((p) => p.id != id).toList());
  }

  void addPost(LandingCommunityPost post) {
    _persist([post, ...state]);
  }
}

/// Scroll targets for in-page navigation.
class LandingSectionKeys {
  LandingSectionKeys()
    : tasteMap = GlobalKey(),
      chefToolkit = GlobalKey(),
      globalTerminal = GlobalKey(),
      pricing = GlobalKey(),
      boardingCall = GlobalKey();

  final GlobalKey tasteMap;
  final GlobalKey chefToolkit;
  final GlobalKey globalTerminal;
  final GlobalKey pricing;
  final GlobalKey boardingCall;

  void scrollTo(GlobalKey key, ScrollController controller) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }
}
