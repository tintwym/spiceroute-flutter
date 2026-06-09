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
    final cancel = CancelToken();
    _cancel = cancel;
    try {
      final stream = _api.chatStream(
        messages: history.sublist(0, history.length - 1),
        language: language,
        cancelToken: cancel,
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
      // Tapping "Stop" cancels the CancelToken mid-stream, which
      // surfaces as a DioException(type: cancel) → ApiException(0,
      // "Request cancelled."). That's a USER-initiated abort, not
      // a backend failure — showing it in the red error banner
      // confuses people ("Why is it telling me something failed? I
      // pressed the stop button"). Silently land in the "stopped"
      // state instead; the partial reply already in `messages` is
      // what the user wanted to keep.
      if (cancel.isCancelled) {
        state = state.copyWith(streaming: false);
      } else {
        state = state.copyWith(
          streaming: false,
          error: e.message,
          rateLimited: e.isRateLimited,
        );
      }
    } catch (e) {
      if (cancel.isCancelled) {
        state = state.copyWith(streaming: false);
      } else {
        state = state.copyWith(streaming: false, error: e.toString());
      }
    } finally {
      if (identical(_cancel, cancel)) _cancel = null;
    }
  }

  void cancel() {
    if (!state.streaming) return;
    _cancel?.cancel();
    _cancel = null;
    // Flip streaming to false IMMEDIATELY so the UI's spinner/stop
    // button reacts to the tap without waiting for the SSE stream to
    // observe the cancellation (which can lag by a chunk). The
    // catch branch in `send()` is cancel-aware, so it won't
    // double-flip into the error state when the cancellation
    // propagates through.
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
