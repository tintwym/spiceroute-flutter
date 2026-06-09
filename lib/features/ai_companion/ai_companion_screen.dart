import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/chat.dart';
import '../../shared/breakpoints.dart';
import '../../shared/studio_page.dart';
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
    final cs = theme.colorScheme;
    final state = ref.watch(chatProvider);
    final dc = deviceClassOf(context);

    ref.listen(chatProvider, (_, _) => _scrollToBottom());

    final isEmpty = state.messages.isEmpty;
    final double chatHeight = switch (dc) {
      DeviceClass.phone => 320,
      DeviceClass.tablet => 360,
      DeviceClass.desktop => 400,
      DeviceClass.wide => 440,
    };

    final card = Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _CardHeader(
            showClear: !isEmpty,
            onClear: state.streaming
                ? null
                : () => ref.read(chatProvider.notifier).clear(),
          ),
          Divider(height: 1, color: cs.outlineVariant),
          SizedBox(
            height: chatHeight,
            child: isEmpty
                ? _GreetingView(scrollController: _scrollCtl)
                : ListView.builder(
                    controller: _scrollCtl,
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                    itemCount: state.messages.length,
                    itemBuilder: (_, i) =>
                        _MessageBubble(message: state.messages[i]),
                  ),
          ),
          if (isEmpty) _Suggestions(onPick: _send),
          if (state.error != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.errorContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                state.rateLimited ? l.aiCompanionRateLimited : state.error!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onErrorContainer,
                ),
              ),
            ),
          Divider(height: 1, color: cs.outlineVariant),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _Composer(
              controller: _inputCtl,
              streaming: state.streaming,
              onSend: _send,
              onStop: () => ref.read(chatProvider.notifier).cancel(),
            ),
          ),
        ],
      ),
    );

    return StudioPage(child: card);
  }
}

/// Card title bar: chef avatar + "AI Kitchen Companion" + active focus, with
/// a reset button on the right once a conversation has started.
class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.showClear, required this.onClear});
  final bool showClear;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
      child: Row(
        children: [
          _ChefAvatar(online: true),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.aiCompanionTitle, style: theme.textTheme.titleLarge),
                const SizedBox(height: 2),
                Text(
                  l.aiCompanionActiveFocus,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
          if (showClear)
            IconButton(
              tooltip: l.aiCompanionClear,
              onPressed: onClear,
              icon: Icon(Icons.restart_alt, color: cs.onSurfaceVariant),
            ),
        ],
      ),
    );
  }
}

class _ChefAvatar extends StatelessWidget {
  const _ChefAvatar({this.online = false, this.radius = 18});
  final bool online;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: cs.surfaceContainerHighest,
          child: Icon(Icons.soup_kitchen_outlined,
              size: radius, color: cs.onSurface),
        ),
        if (online)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: const Color(0xFF3FA35A),
                shape: BoxShape.circle,
                border: Border.all(color: cs.surface, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}

/// Shown before the first message: the assistant's greeting bubble.
class _GreetingView extends StatelessWidget {
  const _GreetingView({required this.scrollController});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      children: [
        _AssistantRow(text: l.aiCompanionGreeting),
      ],
    );
  }
}

/// Assistant message with the chef avatar to its left (used for the
/// greeting). Regular turns use the lighter [_MessageBubble].
class _AssistantRow extends StatelessWidget {
  const _AssistantRow({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ChefAvatar(radius: 14),
        const SizedBox(width: 10),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          ),
        ),
      ],
    );
  }
}

/// "GOURMET SUGGESTIONS" chips shown in the initial state.
class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.onPick});
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final suggestions = [
      l.aiCompanionSuggestion1,
      l.aiCompanionSuggestion2,
      l.aiCompanionSuggestion3,
      l.aiCompanionSuggestion4,
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.aiCompanionSuggestionsLabel.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in suggestions)
                ActionChip(label: Text(s), onPressed: () => onPick(s)),
            ],
          ),
        ],
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
    final cs = Theme.of(context).colorScheme;
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
        const SizedBox(width: 10),
        // Circular send / stop button, matching the reference design.
        SizedBox(
          width: 48,
          height: 48,
          child: streaming
              ? Material(
                  color: cs.surfaceContainerHighest,
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: l.aiCompanionStop,
                    onPressed: onStop,
                    icon: Icon(Icons.stop, color: cs.onSurface),
                  ),
                )
              : Material(
                  color: cs.primary,
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: l.aiCompanionSend,
                    onPressed: () => onSend(controller.text),
                    icon: Icon(Icons.send, color: cs.onPrimary, size: 20),
                  ),
                ),
        ),
      ],
    );
  }
}
