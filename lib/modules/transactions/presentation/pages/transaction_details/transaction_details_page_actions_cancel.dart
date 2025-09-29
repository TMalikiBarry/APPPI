import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/loading_page.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_cancel_reason.dart';
import '../../bloc/transaction_details/transaction_details_bloc.dart';
import '../../bloc/transaction_details/transaction_details_event.dart';
import '../transaction_cancel/transaction_cancel_reason_text.dart';

class TransactionDetailsPageActionsCancel extends StatefulWidget {
  const TransactionDetailsPageActionsCancel({super.key});

  @override
  State<TransactionDetailsPageActionsCancel> createState() =>
      _TransactionDetailsPageActionsCancelState();
}

class _TransactionDetailsPageActionsCancelState
    extends State<TransactionDetailsPageActionsCancel> {
  TransactionCancelReason? reason;

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;

    // Recuperer la transaction
    TransactionDetailsBloc transactionDetailsBloc =
        context.read<TransactionDetailsBloc>();
    Transaction tx = transactionDetailsBloc.state.transaction;

    return ConstrainedBox(
      // Pour rendre la taille dynamique en fonction du / contenu
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          minWidth: MediaQuery.of(context).size.width),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// Title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async{
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 28,
                        color: Themer.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      traductions.transactionDetailsCancelTitle,
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Themer.primaryColor, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // SubTitle
                Text(
                  traductions.transactionDetailsCancelSubTitle,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Themer.disabledColor),
                ),
                const SizedBox(height: 10),

                // Raisons de la demande d'annulation
                Wrap(
                  spacing: 8, // espace horizontal entre les chips
                  runSpacing: 8, // espace vertical entre les lignes
                  children: TransactionCancelReason.values.map((motif) {
                    return ActionChip(
                      label: Text(
                        TransactionCancelReasonText.label(motif, traductions),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Themer.primaryColor,
                        ),
                      ),
                      avatar: reason != null && reason == motif
                          ? const Icon(Icons.check)
                          : null,
                      backgroundColor: Themer.backgroundPrimaryColor,
                      onPressed: () {
                        setState(() {
                          reason = motif;
                        });
                      },
                    );
                  }).toList(),
                ),

                // Bouton Demander l'annulation
                const SizedBox(height: 50),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: reason != null
                        ? () {
                            // CustomLoadingDialog.show(context);
                            transactionDetailsBloc.add(
                              TransactionCancelSendEvent(tx, reason!),
                            );
                          }
                        : null,
                    child: Text(traductions.transactionDetailsCancelBtnSend),
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
