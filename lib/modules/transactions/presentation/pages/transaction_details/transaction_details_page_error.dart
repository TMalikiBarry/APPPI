import 'package:flutter/material.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/notification_dialog.dart';
import '../../../domain/models/transaction_error.dart';

class TransactionDetailsPageError extends StatelessWidget {
  ///
  const TransactionDetailsPageError({super.key, required this.error});

  final TransactionError error;

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations localisation = AppLocalizations.of(context)!;
    //
    return NotificationDialog(
      type: NotificationType.error,
      title: localisation.transactionsSendErrorTitle,
      description: _getDescription(localisation),
      btnText: localisation.btnTextContinue,
      btnAction: () => {AppRouter.pop(context)},
      btnColor: Theme.of(context).colorScheme.tertiary,
    );
  }

  String? _getDescription(AppLocalizations traductions) {
    if (error == TransactionError.soldeInsuffisant) {
      return traductions.transactionErrorSoldeInsuffisant;
    }
    //
    else if (error == TransactionError.dejaRetourne) {
      return traductions.transactionErrorDejaRetourne;
    }
    //
    else if (error == TransactionError.delaiDepasse) {
      return traductions.transactionErrorDelaiDepasse;
    }
    //
    else if (error == TransactionError.destinataireIndisponible) {
      return traductions.transactionErrorDestinataireIndisponible;
    }
    //
    else {
      return traductions.transactionErrorUnknow;
    }
  }
}
