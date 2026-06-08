import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/generated/app_localizations.dart';
import '../state/locale.dart';

/// Top-bar action that lets the user switch the entire UI language.
class LanguagePickerButton extends ConsumerWidget {
  const LanguagePickerButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeProvider);
    return PopupMenuButton<Locale>(
      tooltip: AppL10n.of(context).settingsLanguage,
      icon: const Icon(Icons.language),
      onSelected: (l) => ref.read(localeProvider.notifier).set(l),
      itemBuilder: (ctx) {
        final l = AppL10n.of(ctx);
        PopupMenuEntry<Locale> item(Locale locale, String label) {
          final isSelected = current.languageCode == locale.languageCode;
          return PopupMenuItem<Locale>(
            value: locale,
            child: Row(
              children: [
                Expanded(child: Text(label)),
                if (isSelected)
                  Icon(Icons.check, color: Theme.of(ctx).colorScheme.primary),
              ],
            ),
          );
        }

        return <PopupMenuEntry<Locale>>[
          item(const Locale('en'), l.languageEnglish),
          item(const Locale('zh'), l.languageChinese),
          item(const Locale('th'), l.languageThai),
          item(const Locale('ja'), l.languageJapanese),
          item(const Locale('ko'), l.languageKorean),
          item(const Locale('vi'), l.languageVietnamese),
        ];
      },
    );
  }
}
