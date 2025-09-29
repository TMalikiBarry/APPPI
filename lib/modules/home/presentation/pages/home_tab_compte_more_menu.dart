import 'package:flutter/material.dart';
import 'package:pi_mobile_app/core/router.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';
import 'package:pi_mobile_app/shared/widgets/menu_actions_widget.dart';

import '../../../../../core/assets.dart';

/// Le participant peut personnaliser ce menu
/// pour y ajouter des fonctionnalités propres à son système
/// Il peut ajouter des options personnalisées ou supprimer
class HomeTabCompteMoreMenu extends StatelessWidget {
  const HomeTabCompteMoreMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MenuActionsWiget(
                    items: [
                      // Programmer un paiement
                      MenuActionItem(
                        Images.homeFooterTransfer,
                        traductions.homeActionMoreSheetProgrammerTitle,
                        traductions.homeActionMoreSheetProgrammerSubTitle,
                        () => AppRouter.push(
                          context,
                          AppRouter.subscriptionSchedule,
                        ),
                        iconSize: 20,
                      ),
                      // Trouver un abonnement
                      /*MenuActionItem(
                        Images.homeMoreFindSubscription,
                        traductions.homeActionMoreSheetAbonnementTitle,
                        traductions.homeActionMoreSheetAbonnementSubTitle,
                        () => "",
                        iconSize: 20,
                      ),
                      // Partager dépenses
                      MenuActionItem(
                        Images.homeMoreSplitPayments,
                        traductions.homeActionMoreSheetPartagerTitle,
                        traductions.homeActionMoreSheetPartagerSubTitle,
                        () => "",
                        iconSize: 20,
                      ),
                      // Nouvelle tirelire
                      MenuActionItem(
                        Images.homeMoreSavingBox,
                        traductions.homeActionMoreSheetTirelireTitle,
                        traductions.homeActionMoreSheetTirelireSubTitle,
                        () => "",
                        iconSize: 20,
                      ),
                      // Nouvelle tirelire
                      MenuActionItem(
                        Images.homeMoreSetBudgets,
                        traductions.homeActionMoreSheetBudgetTitle,
                        traductions.homeActionMoreSheetBudgetSubTitle,
                        () => "",
                        iconSize: 20,
                      ),
                      // Ajouter un widget
                      MenuActionItem(
                        Images.homeMoreAddWidget,
                        traductions.homeActionMoreSheetWidgetTitle,
                        traductions.homeActionMoreSheetAWidgetSubTitle,
                        () => "",
                        iconSize: 20,
                      ),*/
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
