import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/theme.dart';

class EmojiSelectWidget extends StatefulWidget {
  const EmojiSelectWidget({
    super.key,
    this.icon,
    this.color,
    required this.onChanged,
  });

  final String? icon;
  final int? color;
  final ValueChanged<Map<String, dynamic>> onChanged;

  @override
  EmojiSelectWidgetState createState() => EmojiSelectWidgetState();
}

class EmojiSelectWidgetState extends State<EmojiSelectWidget> {
  List<int> colors = [
    0xFFEDB37E,
    0xFFC08507,
    0xFF007AFF,
    0xFFF9EBC2,
    0xFF8B887E,
    0xFFFFD573,
    0xFFFA5A25,
    0xFF46A93D,
    0xFFA1A5AC,
    0xFF43474e
  ];
  // Emoji
  late String selectedEmoji;
  // Color
  late int selectedColor;
  //
  RegExp imageRegex = RegExp(r'\.(jpeg|jpg|png|gif)$', caseSensitive: false);

  @override
  void initState() {
    super.initState();
    _initValue();
  }

  void _initValue() {
    setState(() {
      selectedColor = widget.color ?? 0xFFF9EBC2;
    });
    if (widget.icon == null) {
      setState(() {
        selectedEmoji = "🤩";
      });
    } else if (!imageRegex.hasMatch(widget.icon!)) {
      setState(() {
        selectedEmoji = "🤩";
      });
    } else {
      setState(() {
        selectedEmoji = widget.icon!;
      });
    }
    widget.onChanged({'icon': selectedEmoji, 'color': selectedColor});
  }

  @override
  Widget build(BuildContext context) {
    
    //
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Selected Emoji or default
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: Color(selectedColor),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Text(
              selectedEmoji,
              style: const TextStyle(fontSize: 48),
            ),
          ),
        ),
        // bgColor
        SizedBox(
          height: 72,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 4,
            ),
            child: ListView.builder(
              itemCount: colors.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (colors[index] == selectedColor) {
                  return Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Themer.whiteColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                      ),
                    ),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Color(colors[index]),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                } else {
                  return InkWell(
                    child: Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Color(colors[index]),
                        shape: BoxShape.circle,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedColor = colors[index];
                      });
                      widget.onChanged(
                          {'icon': selectedEmoji, 'color': selectedColor});
                    },
                  );
                }
              },
            ),
          ),
        ),
        // keyboard Emoji List
        EmojiPicker(
          textEditingController: TextEditingController(),
          scrollController: ScrollController(),
          onEmojiSelected: (Category? category, Emoji? emoji) {
            setState(() {
              selectedEmoji = emoji!.emoji;
            });
            widget.onChanged({'icon': selectedEmoji, 'color': selectedColor});
          },
          config: Config(
            locale: Localizations.localeOf(context),
            height: MediaQuery.sizeOf(context).height * 0.4,
            emojiViewConfig: EmojiViewConfig(
              emojiSizeMax: 25,
            ),
            categoryViewConfig: CategoryViewConfig(
              indicatorColor: Theme.of(context).primaryColor,
              iconColorSelected: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).cardColor,
            ),
            // bottomActionBarConfig: BottomActionBarConfig(
            //   backgroundColor: Theme.of(context).cardColor,
            //   buttonColor: Theme.of(context).colorScheme.tertiary,
            //   buttonIconColor: Theme.of(context).appBarTheme.foregroundColor!,
            // ),
            // searchViewConfig: SearchViewConfig(
            //   hintText: traductions.textRechercher,
            // ),
          ),
        ),
      ],
    );
  }
}
