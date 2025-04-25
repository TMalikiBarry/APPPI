import 'package:flutter/material.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/router.dart';
import '../../../../../shared/widgets/menu_actions_widget.dart';
import '../../../../l10n/app_localizations.dart';

class SubscriptionMenuWidget extends StatelessWidget {
  const SubscriptionMenuWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    final screenHeight = MediaQuery.of(context).size.height;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.4, // Set max height as 40% of screen height
      ),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  traductions.subscriptionEmptyBtnCreate,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                //
                const SizedBox(height: 20),
                //
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MenuActionsWiget(
                        items: [
                          // Programmer
                          MenuActionItem(
                            Images.homeFooterTransfer,
                            traductions.subscriptionMenuScheduleTitle,
                            traductions.subscriptionMenuScheduleSubtitle,
                            () => AppRouter.push(
                              context,
                              AppRouter.subscriptionSchedule,
                            ),
                            iconSize: 20,
                          ),
                          // Souscrire à un abonneent
                          MenuActionItem(
                            Images.iconRepeat,
                            traductions.subscriptionMenuSubscribeTitle,
                            traductions.subscriptionMenuSubscribeSubtitle,
                            () => AppRouter.push(
                              context,
                              AppRouter.subscriptionSubscribe,
                            ),
                            iconSize: 20,
                          ),
                        ],
                      ),
                    ],
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
