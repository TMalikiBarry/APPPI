import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/notification_dialog.dart';
import '../bloc/alias_state.dart';

class AliasPageSuccess extends StatelessWidget {
  //
  const AliasPageSuccess({super.key, required this.aliasState});

  final AliasState aliasState;

  @override
  Widget build(BuildContext context) {
    AppLocalizations localisation = AppLocalizations.of(context)!;

    String title = "Alias";
    String? subtitle;
    String? description;
    String? action;

    if (aliasState is AliasExistState) {
      // Alias créé avec succès
      title = localisation.aliaSuccessPageTitle;
      subtitle = localisation.aliaSuccessPageSubTitle;
      description = localisation.aliaSuccessPageDescription;
      action = localisation.aliaSuccessPageBtnText;
    } //
    else if (aliasState is AliasClaimAskingSuccessState) {
      // AliasClaimAskingSuccessState: Revendication initiée avec succès
      title = localisation.aliaSuccessClaimPageTitle;
    } //
    else if (aliasState is AliasClaimHandlingSuccessState) {
      // AliasClaimHandlingSuccessState: Revendication acceptée avec succès
      var claim = (aliasState as AliasClaimHandlingSuccessState).claim;
      if (claim.shid != null) {
        // revendication acceptée
        title = localisation.aliasClaimAcceptSuccessTitle;
        description =
            localisation.aliasClaimAcceptSuccessDescription(claim.alias);
      } else {
        // revendication refusée
        title = localisation.aliasClaimRejectSuccessTitle;
        description =
            localisation.aliasClaimRejectSuccessDescription(claim.alias);
      }
      action = localisation.aliaSuccessPageBtnText;
    }

    return NotificationDialog(
      type: NotificationType.success,
      title: title,
      subtitle: subtitle,
      description: description,
      btnText: action,
    );
  }
}
