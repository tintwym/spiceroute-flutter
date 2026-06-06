import 'package:flutter/foundation.dart';

enum ChatRole { user, model }

@immutable
class ChatMessage {
  const ChatMessage({required this.role, required this.content});
  final ChatRole role;
  final String content;

  ChatMessage append(String more) =>
      ChatMessage(role: role, content: content + more);

  Map<String, dynamic> toJson() => {
        'role': role == ChatRole.user ? 'user' : 'model',
        'content': content,
      };
}
