import 'package:flutter/material.dart';
import 'package:pi_mobile_app/core/theme.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/notification_dialog.dart';
import '../../../domain/models/transaction_send/transaction_send_command_alias.dart';

class TransactionSendPageError extends StatelessWidget {
  ///
  const TransactionSendPageError({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations localisation = AppLocalizations.of(context)!;
    //
    return NotificationDialog(
      type: NotificationType.error,
      title: _getTitle(localisation),
      description: _getDescription(localisation),
      btnColor: Themer.error,
      btns: _getBtns(localisation, context),
    );
  }

  String? _getTitle(AppLocalizations localisation) {
    // Alias introuvable apres recherche d'alias
    if (error == TransactionSendCommandAliasError.notFound.code) {
      return localisation.transactionsSendErrorALias; // TODO translate
    }
    // Toute autre erreur
    else {
      return localisation.transactionsSendErrorTitle;
    }
  }

  String? _getDescription(AppLocalizations localisation) {
    // Alias introuvable apres recherche d'alias
    if (error == TransactionSendCommandAliasError.notFound.code) {
      return null;
    }
    // Toute autre erreur
    else {
      return localisation.transactionsSendErrorDescription;
    }
  }

  List<NotificationBtn> _getBtns(
    AppLocalizations localisation,
    BuildContext context,
  ) {
    // Alias introuvable apres recherche d'alias
    if (error == TransactionSendCommandAliasError.notFound.code) {
      return [];
    }
    // Toute autre erreur
    else {
      return [
        NotificationBtn(
          btnText: localisation.transactionsSendErrorBtn,
          btnAction: () => {AppRouter.go(context, AppRouter.home)},
          btnColor: Theme.of(context).colorScheme.tertiary,
        ),
      ];
    }
  }
}
