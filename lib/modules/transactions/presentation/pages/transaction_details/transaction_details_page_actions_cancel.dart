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
                Text(
                  traductions.transactionDetailsCancelTitle,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 20),

                // SubTitle
                Text(
                  traductions.transactionDetailsCancelSubTitle,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 10),

                // Raisons de la demande d'annulation
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: TransactionCancelReason.values.map((motif) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ActionChip(
                        label: Text(
                          TransactionCancelReasonText.label(motif, traductions),
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Themer.primaryColor),
                        ),
                        avatar: reason != null && reason == motif
                            ? const Icon(Icons.check)
                            : null,
                        backgroundColor: Themer.primaryLight,
                        onPressed: () {
                          setState(() {
                            reason = motif;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),

                // Bouton Demander l'annulation
                const SizedBox(height: 10),
                SizedBox(
                  height: 56,
                  child: Expanded(
                    child: ElevatedButton(
                      onPressed: reason != null
                          ? () {
                              CustomLoadingDialog.show(context);
                              transactionDetailsBloc.add(
                                TransactionCancelSendEvent(tx, reason!),
                              );
                            }
                          : null,
                      child: Text(traductions.transactionDetailsCancelBtnSend),
                    ),
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
