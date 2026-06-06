import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../models/chat.dart';
import 'providers.dart';

@immutable
class ChatState {
  const ChatState({
    this.messages = const [],
    this.streaming = false,
    this.error,
    this.rateLimited = false,
  });

  final List<ChatMessage> messages;
  final bool streaming;
  final String? error;
  final bool rateLimited;

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? streaming,
    String? error,
    bool clearError = false,
    bool? rateLimited,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      streaming: streaming ?? this.streaming,
      error: clearError ? null : (error ?? this.error),
      rateLimited: rateLimited ?? this.rateLimited,
    );
  }
}

class ChatController extends StateNotifier<ChatState> {
  ChatController(this._api) : super(const ChatState());

  final ApiClient _api;
  CancelToken? _cancel;

  Future<void> send(String content, {required String language}) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty || state.streaming) return;
    final history = [
      ...state.messages,
      ChatMessage(role: ChatRole.user, content: trimmed),
      const ChatMessage(role: ChatRole.model, content: ''),
    ];
    state = state.copyWith(
      messages: history,
      streaming: true,
      clearError: true,
      rateLimited: false,
    );
    _cancel = CancelToken();
    try {
      final stream = _api.chatStream(
        messages: history.sublist(0, history.length - 1),
        language: language,
        cancelToken: _cancel,
      );
      await for (final chunk in stream) {
        final list = state.messages;
        if (list.isEmpty) break;
        final last = list.last;
        final updated = [
          ...list.sublist(0, list.length - 1),
          last.append(chunk),
        ];
        state = state.copyWith(messages: updated);
      }
      state = state.copyWith(streaming: false);
    } on ApiException catch (e) {
      state = state.copyWith(
        streaming: false,
        error: e.message,
        rateLimited: e.isRateLimited,
      );
    } catch (e) {
      state = state.copyWith(streaming: false, error: e.toString());
    } finally {
      _cancel = null;
    }
  }

  void cancel() {
    if (!state.streaming) return;
    _cancel?.cancel();
    _cancel = null;
    state = state.copyWith(streaming: false);
  }

  void clear() {
    _cancel?.cancel();
    _cancel = null;
    state = const ChatState();
  }
}

final chatProvider =
    StateNotifierProvider<ChatController, ChatState>((ref) {
  return ChatController(ref.watch(apiClientProvider));
});
