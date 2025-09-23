import 'package:flutter/material.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';
import '../../core/theme.dart';

class CtaWidget extends StatelessWidget {
  const CtaWidget({
    super.key,
    required this.label,
    required this.action,
    this.icon,
    this.image,
    this.disabled = false,
    this.message,
  });

  final String label;
  final Function()? action;
  final Icon? icon;
  final String? image;
  final bool disabled;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final traductions = AppLocalizations.of(context)!;
    const Color bg = Themer.backgroundPiProgramme;
    final shadow = BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
    );

    return GestureDetector(
      onTap: () {
        if (!disabled) {
          action?.call();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message ?? traductions.coming_soon, style: const TextStyle(color: Themer.whiteColor),),
              backgroundColor: Themer.primaryColor,
            ),
          );
        }
      },
      child: Opacity(
        // Opacité réduite si disabled
        opacity: disabled ? 0.28 : 1.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Themer.backgroundPiProgramme,
                shape: BoxShape.circle,
                //boxShadow: [shadow],
                /*border: !disabled ? Border.all(
                  color: const Color(0xFF646FEF), // couleur #646FEF
                  width: 2, // fine bordure
                ) : null,*/
              ),
              child: Center(
                child: icon ??
                  Image(
                    image: AssetImage(image!, package: 'common_dependencies'),
                    height: 28,
                    width: 28,
                    //size: 28,
                    //color: const Color(0xFF282C5D),
                  ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Themer.primaryColor, fontSize: 13.5),
            ),
          ],
        ),
      ),
    );
  }
}
