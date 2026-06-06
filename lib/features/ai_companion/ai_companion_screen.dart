import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/chat.dart';
import '../../shared/breakpoints.dart';
import '../../state/chat.dart';
import '../../state/locale.dart';

class AiCompanionScreen extends ConsumerStatefulWidget {
  const AiCompanionScreen({super.key});

  @override
  ConsumerState<AiCompanionScreen> createState() => _AiCompanionScreenState();
}

class _AiCompanionScreenState extends ConsumerState<AiCompanionScreen> {
  final _inputCtl = TextEditingController();
  final _scrollCtl = ScrollController();

  @override
  void dispose() {
    _inputCtl.dispose();
    _scrollCtl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtl.hasClients) return;
      _scrollCtl.animateTo(
        _scrollCtl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    _inputCtl.clear();
    final lang = ref.read(localeProvider).languageCode;
    ref.read(chatProvider.notifier).send(text, language: lang);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(chatProvider);

    ref.listen(chatProvider, (_, _) => _scrollToBottom());

    return Padding(
      padding: pagePadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: contentMaxWidth(context)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(l.aiCompanionTitle,
                          style: theme.textTheme.headlineLarge),
                    ),
                    if (state.messages.isNotEmpty)
                      TextButton.icon(
                        onPressed: state.streaming
                            ? null
                            : () => ref.read(chatProvider.notifier).clear(),
                        icon: const Icon(Icons.delete_sweep_outlined),
                        label: Text(l.aiCompanionClear),
                      ),
                  ],
                ),
              ),
              if (state.messages.isEmpty)
                Expanded(child: _EmptyState(onPick: _send))
              else
                Expanded(
                  child: ListView.builder(
                    controller: _scrollCtl,
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: state.messages.length,
                    itemBuilder: (_, i) =>
                        _MessageBubble(message: state.messages[i]),
                  ),
                ),
              if (state.error != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    state.rateLimited
                        ? l.aiCompanionRateLimited
                        : state.error!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              _Composer(
                controller: _inputCtl,
                streaming: state.streaming,
                onSend: _send,
                onStop: () => ref.read(chatProvider.notifier).cancel(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends ConsumerWidget {
  const _EmptyState({required this.onPick});
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final suggestions = [
      l.aiCompanionSuggestion1,
      l.aiCompanionSuggestion2,
      l.aiCompanionSuggestion3,
      l.aiCompanionSuggestion4,
    ];
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.forum_outlined,
                size: 56, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(l.aiCompanionEmptyTitle,
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(l.aiCompanionEmptySubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final s in suggestions)
                  ActionChip(
                    label: Text(s),
                    onPressed: () => onPick(s),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.role == ChatRole.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.8,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isUser
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(isUser ? 18 : 4),
              bottomRight: Radius.circular(isUser ? 4 : 18),
            ),
          ),
          child: SelectableText(
            message.content.isEmpty
                ? AppL10n.of(context).aiCompanionTyping
                : message.content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isUser
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
              fontStyle: message.content.isEmpty
                  ? FontStyle.italic
                  : FontStyle.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.streaming,
    required this.onSend,
    required this.onStop,
  });

  final TextEditingController controller;
  final bool streaming;
  final ValueChanged<String> onSend;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            minLines: 1,
            maxLines: 5,
            textInputAction: TextInputAction.send,
            onSubmitted: streaming ? null : onSend,
            decoration: InputDecoration(hintText: l.aiCompanionInputHint),
          ),
        ),
        const SizedBox(width: 12),
        if (streaming)
          OutlinedButton.icon(
            onPressed: onStop,
            icon: const Icon(Icons.stop),
            label: Text(l.aiCompanionStop),
          )
        else
          FilledButton.icon(
            onPressed: () => onSend(controller.text),
            icon: const Icon(Icons.send),
            label: Text(l.aiCompanionSend),
          ),
      ],
    );
  }
}
