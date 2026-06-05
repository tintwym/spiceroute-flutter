import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/spice_route.dart';
import 'providers.dart';

@immutable
class SpiceRouteListState {
  const SpiceRouteListState({
    this.loading = false,
    this.items = const [],
    this.error,
    this.q = '',
    this.tag,
    this.maxMinutes,
    this.mineOnly = false,
    this.favoritesOnly = false,
  });

  final bool loading;
  final List<SpiceRouteSummary> items;
  final String? error;
  final String q;
  final String? tag;
  final int? maxMinutes;
  final bool mineOnly;
  final bool favoritesOnly;

  SpiceRouteListState copyWith({
    bool? loading,
    List<SpiceRouteSummary>? items,
    String? error,
    bool clearError = false,
    String? q,
    String? tag,
    bool clearTag = false,
    int? maxMinutes,
    bool clearMaxMinutes = false,
    bool? mineOnly,
    bool? favoritesOnly,
  }) {
    return SpiceRouteListState(
      loading: loading ?? this.loading,
      items: items ?? this.items,
      error: clearError ? null : (error ?? this.error),
      q: q ?? this.q,
      tag: clearTag ? null : (tag ?? this.tag),
      maxMinutes: clearMaxMinutes ? null : (maxMinutes ?? this.maxMinutes),
      mineOnly: mineOnly ?? this.mineOnly,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
    );
  }
}

class SpiceRouteListController extends StateNotifier<SpiceRouteListState> {
  SpiceRouteListController(this._ref) : super(const SpiceRouteListState()) {
    refresh();
  }

  final Ref _ref;

  Future<void> refresh() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final res = await _ref.read(apiClientProvider).listSpiceRoutes(
            q: state.q,
            tag: state.tag,
            maxMinutes: state.maxMinutes,
            mineOnly: state.mineOnly,
            favoritesOnly: state.favoritesOnly,
            limit: 50,
          );
      state = state.copyWith(loading: false, items: res.items);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void setQuery(String q) {
    state = state.copyWith(q: q);
    refresh();
  }

  void setTag(String? tag) {
    state = tag == null
        ? state.copyWith(clearTag: true)
        : state.copyWith(tag: tag);
    refresh();
  }

  void setMaxMinutes(int? m) {
    state = m == null
        ? state.copyWith(clearMaxMinutes: true)
        : state.copyWith(maxMinutes: m);
    refresh();
  }

  void setMineOnly(bool v) {
    state = state.copyWith(mineOnly: v);
    refresh();
  }

  void setFavoritesOnly(bool v) {
    state = state.copyWith(favoritesOnly: v);
    refresh();
  }

  Future<void> toggleFavoriteLocal(String spiceRouteId) async {
    final api = _ref.read(apiClientProvider);
    final favorited = await api.toggleFavorite(spiceRouteId);
    state = state.copyWith(
      items: [
        for (final r in state.items)
          if (r.id == spiceRouteId) r.copyWith(isFavorite: favorited) else r,
      ],
    );
  }
}

final spiceRouteListControllerProvider =
    StateNotifierProvider<SpiceRouteListController, SpiceRouteListState>(
        (ref) => SpiceRouteListController(ref));

final tagsProvider = FutureProvider<List<Tag>>((ref) async {
  return ref.read(apiClientProvider).listTags();
});

final spiceRouteDetailProvider =
    FutureProvider.family<SpiceRouteDetail, String>((ref, id) async {
  return ref.read(apiClientProvider).getSpiceRoute(id);
});
