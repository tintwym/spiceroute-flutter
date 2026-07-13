import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/chat.dart';
import '../../shared/breakpoints.dart';
import '../../shared/cuisine_pill_bar.dart';
import '../../shared/error_localization.dart';
import '../../shared/studio_page.dart';
import '../../state/chat.dart';
import '../../state/explore.dart';
import '../../state/locale.dart';

class AiCompanionScreen extends ConsumerStatefulWidget {
  const AiCompanionScreen({super.key});

  @override
  ConsumerState<AiCompanionScreen> createState() => _AiCompanionScreenState();
}

class _AiCompanionScreenState extends ConsumerState<AiCompanionScreen> {
  final _inputCtl = TextEditingController();
  final _scrollCtl = ScrollController();
  // Hoisted FocusNode so we can scroll to the bottom when the user
  // taps into the composer — without this, the user opens the
  // keyboard, the visible viewport shrinks by ~270 dp, and the
  // bottom of the chat history is now obscured ABOVE the keyboard
  // with no signal that more messages exist. The focus listener
  // (registered in initState) re-pins the latest message to the
  // visible floor whenever focus arrives.
  final _inputFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _inputFocus.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_inputFocus.hasFocus) {
      // Wait two frames: one for the keyboard to start animating in
      // (Flutter updates viewInsets between frames), one for the
      // ListView to settle at its new maxScrollExtent. Without the
      // delay the jumpTo lands on the OLD extent and the latest
      // message stays just below the visible floor.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom(animate: false);
        });
      });
    }
  }

  @override
  void dispose() {
    _inputFocus.removeListener(_handleFocusChange);
    _inputFocus.dispose();
    _inputCtl.dispose();
    _scrollCtl.dispose();
    super.dispose();
  }

  /// Snap the viewport to the new bottom.
  ///
  /// While the assistant is streaming, we [jumpTo] instead of
  /// [animateTo] — the previous animation would re-arm on every
  /// streamed chunk (one chunk every ~30ms), restarting the easing
  /// curve mid-flight and producing a "syrupy chase" where new tokens
  /// always sit just below the visible edge. A plain jump tracks the
  /// floor cleanly, then the post-stream settle re-engages the
  /// animation for the final scroll.
  void _scrollToBottom({bool animate = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtl.hasClients) return;
      final target = _scrollCtl.position.maxScrollExtent;
      if (animate) {
        _scrollCtl.animateTo(
          target,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      } else {
        _scrollCtl.jumpTo(target);
      }
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

    // Only scroll when the conversation's *content* changed — either a
    // new message was appended or the last message grew (streaming
    // chunk). Skips no-op rebuilds (error toggles, streaming flag
    // flips) which would otherwise re-arm the scroll animation
    // mid-flight. Uses jumpTo while streaming so the viewport tracks
    // the floor instead of chasing it.
    ref.listen<ChatState>(chatProvider, (prev, next) {
      final prevLen = prev?.messages.length ?? 0;
      final nextLen = next.messages.length;
      final prevLast = (prev?.messages.isNotEmpty ?? false)
          ? prev!.messages.last.content.length
          : 0;
      final nextLast = next.messages.isNotEmpty
          ? next.messages.last.content.length
          : 0;
      if (nextLen != prevLen || nextLast != prevLast) {
        _scrollToBottom(animate: !next.streaming);
      }
    });

    final isEmpty = state.messages.isEmpty;
    // Base chat region height per device class. Keyboard-aware: when
    // the soft keyboard is open we steal back its height from the
    // chat region so the composer + send button stay visible above
    // the keyboard. Floor at 160 dp so the chat doesn't collapse to
    // nothing on a 568-tall iPhone SE with a tall keyboard. The
    // bracketed `max(...)` mirrors what `MediaQuery.viewInsetsOf`
    // would clamp to anyway, but is cheaper to reason about than a
    // ternary that has to special-case "keyboard absent".
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final baseChatHeight = switch (dc) {
      DeviceClass.phone => 320.0,
      DeviceClass.tablet => 360.0,
      DeviceClass.desktop => 400.0,
      DeviceClass.wide => 440.0,
    };
    final chatHeight = (baseChatHeight - keyboardInset).clamp(
      160.0,
      baseChatHeight,
    );

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
                    itemBuilder: (_, i) => _MessageBubble(
                      message: state.messages[i],
                      streaming: state.streaming,
                    ),
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
                state.rateLimited
                    ? l.aiCompanionRateLimited
                    : localizeApiErrorMessage(context, state.error!),
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
              focusNode: _inputFocus,
              streaming: state.streaming,
              onSend: _send,
              onStop: () => ref.read(chatProvider.notifier).cancel(),
            ),
          ),
        ],
      ),
    );

    return StudioPage(
      heroTitle: l.aiCompanionTitle,
      heroSubtitle: l.aiCompanionGreeting,
      child: card,
    );
  }
}

/// Card title bar: chef avatar + "AI Kitchen Companion" + active focus, with
/// a reset button on the right once a conversation has started.
///
/// "Active Focus" pulls the currently-selected cuisine from
/// [exploreProvider] so the chat reflects what the user is browsing.
/// Falls back to the generic "Global" label when "All cuisines" is
/// selected, matching the React companion behaviour.
class _CardHeader extends ConsumerWidget {
  const _CardHeader({required this.showClear, required this.onClear});
  final bool showClear;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final cuisine = ref.watch(exploreProvider.select((s) => s.cuisine));
    final focusLabel = cuisine == null
        ? l.aiCompanionActiveFocus
        : l.aiCompanionActiveFocusCuisine(CuisinePillBar.labelFor(l, cuisine));
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
                  focusLabel,
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
          child: Icon(
            Icons.soup_kitchen_outlined,
            size: radius,
            color: cs.onSurface,
          ),
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
      children: [_AssistantRow(text: l.aiCompanionGreeting)],
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
  const _MessageBubble({required this.message, required this.streaming});
  final ChatMessage message;
  final bool streaming;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.role == ChatRole.user;
    // Only show typing dots while a stream is in flight. An empty model
    // bubble left after an error / stop must not animate forever.
    final isPlaceholder =
        !isUser && message.content.isEmpty && streaming;
    if (!isUser && message.content.isEmpty && !streaming) {
      return const SizedBox.shrink();
    }
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
          // When the assistant has been asked but hasn't streamed any text
          // yet, render an animated 3-dot indicator so the bubble feels
          // alive instead of an empty italic "typing…" string.
          child: isPlaceholder
              ? const _TypingDots()
              : SelectableText(
                  message.content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isUser
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                  ),
                ),
        ),
      ),
    );
  }
}

/// Three bouncing dots used in place of an empty assistant bubble while
/// the model is still composing its reply. Each dot's animation is
/// phase-shifted by 1/3 of the period so the row reads as a wave.
class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++) ...[
          if (i > 0) const SizedBox(width: 5),
          AnimatedBuilder(
            animation: _ctl,
            builder: (_, _) {
              final phase = (_ctl.value + i / 3) % 1.0;
              // Bell-curve-shaped opacity: dim at the edges of the cycle,
              // bright in the middle. Avoids the jarring linear bounce.
              final t = 1 - (phase - 0.5).abs() * 2;
              return Opacity(
                opacity: 0.35 + 0.65 * t,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: cs.onSurface,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.focusNode,
    required this.streaming,
    required this.onSend,
    required this.onStop,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
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
            focusNode: focusNode,
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
