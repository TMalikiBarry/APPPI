import 'package:flutter/material.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/theme.dart';

class HideAmountIllustrationSheet extends StatelessWidget {
  //
  const HideAmountIllustrationSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    return SizedBox(
      height: 320,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                traductions.profileSecuriteMontantPopupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              //
              const SizedBox(
                height: 10,
              ),
              //
              Text(
                traductions.profileSecuriteMontantPopupSubTitle,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: Themer.neural03Color),
              ),
              //
              const SizedBox(
                height: 40,
              ),
              //
              Center(
                child: Image.asset(
                  Images.imagesEyeOffIllustration,
                  width: 200,
                  //height: 180,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
