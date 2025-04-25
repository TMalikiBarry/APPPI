import 'package:flutter/material.dart';

import '../../../../core/router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/emoji_select_widget.dart';

class CategorieEditIconEmoji extends StatefulWidget {
  const CategorieEditIconEmoji({
    super.key,
    required this.icon,
    required this.color,
  });

  final String icon;
  final int color;

  @override
  CategorieEditIconEmojiState createState() => CategorieEditIconEmojiState();
}

class CategorieEditIconEmojiState extends State<CategorieEditIconEmoji> {
  // Emoji
  late String selectedEmoji;
  // Color
  late int selectedColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Selection Emoji and color
                EmojiSelectWidget(
                  icon: widget.icon,
                  color: widget.color,
                  onChanged: (value) {
                    selectedEmoji = value['icon'] as String;
                    selectedColor = value['color'] as int;
                  },
                ),
                // Save Btn
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 4,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      AppRouter.pop(context, value: {
                        "emoji": selectedEmoji,
                        "color": selectedColor,
                      });
                    },
                    child: Text(traductions.categorieFormSaveBtn),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
