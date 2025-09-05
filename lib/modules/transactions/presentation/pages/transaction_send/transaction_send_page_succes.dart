import 'package:common_dependencies/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/notification_dialog.dart';
import '../../../domain/models/transaction.dart';

class TransactionSendPageSuccess extends StatelessWidget {
  ///
  const TransactionSendPageSuccess({
    super.key,
    required this.transaction,
    this.onClose,
  });

  final Transaction transaction;
  final Function? onClose;

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations localisation = AppLocalizations.of(context)!;
    //
    return NotificationDialog(
      type: NotificationType.success,
      message: _message(context, localisation),
      btnText: _btnText(context, localisation),
      btnAction: () {
        AppRouter.pop(context);
        if (onClose != null) {
          onClose!();
        }
        AppRouter.go(context, AppRouter.home);
        /*
        // RTP
        if (transaction.isRTP() &&
            transaction.statut == TransactionStatut.initie) {
          if (!transaction.isSplit()) {
            //AppRouter.pushReplacement(
            //  context,
            //  "/transaction/receive_now/${transaction.endToEndId}",
            //);
            AppRouter.go(
              context,
              "/transaction/receive_now/${transaction.endToEndId}",
            );
          } else {
            //AppRouter.pushReplacement(context, AppRouter.home);
            AppRouter.go(context, AppRouter.home);
          }
        }
        // Transaction now
        else if (!transaction.isRTP() && transaction.dateDebut == null) {
          AppRouter.go(
            context,
            AppRouter.transactionSendDetails,
            params: {
              "tx": transaction,
              "route": AppRouter.home,
            },
          );
        }
        // Transaction scheduled
        else if (!transaction.isRTP() && transaction.dateDebut != null) {
          AppRouter.go(
            context,
            AppRouter.transactionSendDetails,
            params: {
              "tx": transaction,
              "route": AppRouter.home,
            },
          );
        }
        // Other
        else {
          AppRouter.go(
            context,
            AppRouter.transactionSendDetails,
            params: {
              "tx": transaction,
              "route": AppRouter.home,
            },
          );
        }
        */
      },
      btnColor: Theme.of(context).colorScheme.tertiary,
    );
  }

  String _btnText(BuildContext context, AppLocalizations localisation) {
    // Requested
    if (transaction.isRTP() && transaction.statut == TransactionStatut.initie) {
      if (transaction.isSplit()) {
        return localisation.btnTextContinue;
      }
      //return localisation.transactionsRtpSuccessBtnVoir;
      return localisation.btnTextContinue;
    } else {
      //return localisation.transactionsSendSuccessBtnVoir;
      return localisation.btnTextContinue;
    }
  }

  String _message(BuildContext context, AppLocalizations localisation) {
    // Requested
    if (transaction.isRTP() && transaction.statut == TransactionStatut.initie) {
      if (transaction.isSplit()) {
        return localisation.transactionSplitRepartitionSuccessMessage;
      }
      return localisation.transactionsRtpSuccessBtnTitle(transaction.clientNom);
    }
    // Scheduled
    else if (transaction.dateDebut != null) {
      return localisation.transactionFormScheduleSuccessMessage(
        NumberFormat.currency(
          locale: Localizations.localeOf(context).toString(),
          symbol: '',
          decimalDigits: 0,
        ).format(transaction.montant),
        transaction.clientNom,
      );
    }
    // Sent
    else {
      return localisation
          .transactionsSendSuccessBtnTitle(transaction.clientNom);
    }
  }
}
