import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/router.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_reject_reason.dart';
import '../../bloc/transaction_rtp/transaction_rtp_bloc.dart';
import '../../bloc/transaction_rtp/transaction_rtp_event.dart';

class TransactionRtpPageActionsReject extends StatefulWidget {
  const TransactionRtpPageActionsReject({super.key});

  @override
  State<TransactionRtpPageActionsReject> createState() =>
      _TransactionRtpPageActionsRejectState();
}

class _TransactionRtpPageActionsRejectState
    extends State<TransactionRtpPageActionsReject> {
  TransactionRejectReason? reason;

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;

    // Recuperer la transaction
    TransactionRtpBloc bloc = context.read<TransactionRtpBloc>();
    Transaction tx = (bloc.state as dynamic).transaction;

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
                  traductions.transactionRtpRejectTitle(tx.clientNom),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 12),

                if(tx.montant != null)...[
                  // SubTitle
                  Text(
                    traductions.transactionRtpRejectSubtitle(
                        NumberFormat.currency(
                          locale: Localizations.localeOf(context).toString(),
                          symbol: '',
                          decimalDigits: 0,
                        ).format(tx.montant),
                        tx.clientNom),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                ],
                // Raisons du rejet
                /*Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: TransactionRejectReason.values
                      .where((motif) => motif != TransactionRejectReason.autre)
                      .map((motif) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ActionChip(
                        label: Text(
                          _raison(motif, traductions),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        avatar: reason != null && reason == motif
                            ? Icon(Icons.check)
                            : null,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        onPressed: () {
                          setState(() {
                            reason = motif;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),

                 */

                Wrap(
                  spacing: 8, // espace horizontal entre les chips
                  runSpacing: 8, // espace vertical entre les lignes
                  children: TransactionRejectReason.values
                      .where((motif) => motif != TransactionRejectReason.autre)
                      .map((motif) {
                    return ActionChip(
                      label: Text(
                        _raison(motif, traductions),
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


                // Bouton
                const SizedBox(height: 10),
                SizedBox(
                  height: 56,
                  child: Expanded(
                    child: ElevatedButton(
                      onPressed: reason != null
                          ? () {
                              AppRouter.pop(context);
                              bloc.add(
                                TransactionRtpRejectEvent(tx, reason!, true),
                              );
                            }
                          : null,
                      child: Text(traductions.btnTextReject),
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

  /// Textes des raisons de rejet
  static String _raison(
    TransactionRejectReason motif,
    AppLocalizations traductions,
  ) {
    switch (motif) {
      case TransactionRejectReason.erreurDestinataire:
        return traductions.transactionRtpRejectRsnDemandeur;
      case TransactionRejectReason.erreurMontant:
        return traductions.transactionRtpRejectRsnMontant;
      case TransactionRejectReason.fraude:
        return traductions.transactionDetailsCancelRsnFraud;
      case TransactionRejectReason.dejaPaye:
        return traductions.transactionDetailsCancelRsnDuplicate;
      case TransactionRejectReason.facture:
        return traductions.transactionRtpRejectRsnRemittance;
      case TransactionRejectReason.autre:
        return "";
    }
  }
}
