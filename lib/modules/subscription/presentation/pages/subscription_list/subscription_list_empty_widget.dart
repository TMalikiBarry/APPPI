import 'package:flutter/material.dart';
import 'package:pi_mobile_app/core/theme.dart';

import '../../../../../../core/assets.dart';
import '../../../../../l10n/app_localizations.dart';
import '../subscription_menu_widget.dart';

class SubscriptionListEmptyWidget extends StatelessWidget {
  //
  const SubscriptionListEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 220,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color: Themer.backgroundPiProgramme,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Titre
                    Text(
                      traductions.subscriptionEmptyTitle,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 18, color: Themer.primaryColor,
                      ),
                    ),

                    // Sous titre
                    Text(
                      traductions.subscriptionEmptySubTitle,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),

                    SizedBox(
                      width: 120,
                      height: 40,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        onPressed: () => showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return const SubscriptionMenuWidget();
                          },
                          isScrollControlled: true,
                        ),
                        child: Text(traductions.subscriptionEmptyBtnCreate),
                      ),
                    ),
                  ],
                ),
              ),
              // Image Illustration
              const Align(
                alignment: Alignment.centerRight,
                child: Image(
                  image: AssetImage(Images.subscriptionCalendar,package: 'common_dependencies'),
                  width: 132,
                  height: 132,
                ),
              ),
            ],
          ),
        ),
        // Card Bouton Nouveau
        /*
        Container(
          height: 92,
          width: MediaQuery.of(context).size.width,
          decoration: ShapeDecoration(
            color: Theme.of(context).cardColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            children: [
              // Sous titre
              Expanded(
                child: Text(
                  traductions.subscriptionEmptySubTitle,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              // Bouton nouveau
              SizedBox(
                width: 120,
                height: 40,
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return const SubscriptionMenuWidget();
                    },
                    isScrollControlled: true,
                  ),
                  child: Text(traductions.subscriptionEmptyBtnCreate),
                ),
              ),
            ],
          ),
        ),
        */
      ],
    );
  }
}
