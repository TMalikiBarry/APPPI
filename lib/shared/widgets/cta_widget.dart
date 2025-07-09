import 'package:flutter/material.dart';

import '../../core/theme.dart';

class CtaWidget extends StatelessWidget {
  const CtaWidget({
    super.key,
    required this.label,
    required this.action,
    this.icon,
    this.image,
    this.disabled = false,
  });

  final String label;
  final Function()? action;
  final Icon? icon;
  final String? image;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    const Color bg = Themer.primaryLighter;
    final shadow = BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
    );

    return GestureDetector(
      onTap: () {
        if (disabled) {
          // Affiche une alerte ou SnackBar quand le bouton est désactivé
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(
                'Bientôt disponible',
                style: Theme.of(context).textTheme.titleSmall!.copyWith( color: Themer.brownColor),
            )),
          );
        } else {
          action?.call();
        }
      },
      child: Opacity(
        // Opacité réduite si disabled
        opacity: disabled ? 0.4 : 1.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
                boxShadow: [shadow],
              ),
              child: Center(
                child: icon ??
                    ImageIcon(
                      AssetImage(image!, package: 'common_dependencies'),
                      size: 28,
                      color: const Color(0xFF282C5D),
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: const Color(0xFF282C5D), fontSize: 14.5),
            ),
          ],
        ),
      ),
    );
  }
}
