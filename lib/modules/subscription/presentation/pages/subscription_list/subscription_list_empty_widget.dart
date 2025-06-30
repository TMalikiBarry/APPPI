import 'package:flutter/material.dart';

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
          height: 260,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: ShapeDecoration(
            color: Theme.of(context).secondaryHeaderColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Illustration
              Expanded(
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Image(
                    image: AssetImage(Images.subscriptionCalendar,package: 'common_dependencies'),
                    width: 142,
                    height: 142,
                  ),
                ),
              ),
              // Titre
              SizedBox(
                child: Text(
                  traductions.subscriptionEmptyTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ),
        // Card Bouton Nouveau
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
      ],
    );
  }
}
