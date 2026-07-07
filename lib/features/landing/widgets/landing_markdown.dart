import 'package:flutter/material.dart';

import '../landing_palette.dart';

/// Lightweight markdown renderer matching React ChefCompanion `formatMarkdown`.
class LandingMarkdownBody extends StatelessWidget {
  const LandingMarkdownBody({
    super.key,
    required this.text,
    this.baseStyle,
    this.chef = true,
  });

  final String text;
  final TextStyle? baseStyle;
  final bool chef;

  @override
  Widget build(BuildContext context) {
    final base =
        baseStyle ??
        LandingPalette.sans(
          context,
          size: chef ? 13 : 14,
          color: LandingPalette.charcoal.withValues(alpha: chef ? 0.8 : 1),
        ).copyWith(height: 1.55);

    final children = <Widget>[];
    for (final raw in text.split('\n')) {
      final line = raw.trimRight();
      if (line.isEmpty) {
        children.add(const SizedBox(height: 6));
        continue;
      }
      if (line.startsWith('### ')) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Text(
              line.substring(4),
              style: LandingPalette.serif(
                context,
                size: 16,
                color: LandingPalette.red,
              ),
            ),
          ),
        );
        continue;
      }
      if (line.startsWith('## ')) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 6),
            child: Text(
              line.substring(3),
              style: LandingPalette.serif(context, size: 18),
            ),
          ),
        );
        continue;
      }
      if (line.startsWith('- ') || line.startsWith('* ')) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: base),
                Expanded(child: _inlineSpans(context, line.substring(2), base)),
              ],
            ),
          ),
        );
        continue;
      }
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: _inlineSpans(context, line, base),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _inlineSpans(BuildContext context, String line, TextStyle base) {
    final spans = <InlineSpan>[];
    final re = RegExp(r'\*\*(.*?)\*\*');
    var start = 0;
    for (final m in re.allMatches(line)) {
      if (m.start > start) {
        spans.add(TextSpan(text: line.substring(start, m.start), style: base));
      }
      spans.add(
        TextSpan(
          text: m.group(1),
          style: base.copyWith(fontWeight: FontWeight.w700, color: LandingPalette.charcoal),
        ),
      );
      start = m.end;
    }
    if (start < line.length) {
      spans.add(TextSpan(text: line.substring(start), style: base));
    }
    return Text.rich(TextSpan(children: spans));
  }
}
