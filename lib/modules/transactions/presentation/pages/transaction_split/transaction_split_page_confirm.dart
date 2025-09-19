import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/loading_page.dart';
import '../../../../contacts/domain/contact_pi.dart';
import '../../../../security/presentation/bloc/identification/identification_bloc.dart';
import '../../../../security/presentation/bloc/identification/identification_event.dart';
import '../../../../security/presentation/bloc/identification/identification_state.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_canal.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../../domain/models/transaction_send/transaction_send_command_alias.dart';
import '../../../domain/models/transaction_send/transaction_send_command_amount.dart';
import '../../../domain/models/transaction_send/transaction_send_command_motif.dart';
import '../../../domain/models/transaction_send/transaction_send_method.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';
import '../../bloc/transaction_send/transaction_send_state.dart';
import '../transaction_send/transaction_send_page_error.dart';
import '../transaction_send/transaction_send_page_succes.dart';

class TransactionSplitPageConfirm extends StatelessWidget {
  //
  const TransactionSplitPageConfirm({
    super.key,
    required this.transaction,
    required this.selectedItems,
    required this.repartition,
  });

  final Transaction transaction;
  final List<ContactPI>? selectedItems;
  final Map<String, TextEditingController> repartition;

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return BlocListener<IdentificationBloc, IdentificationState>(
      listenWhen: (previous, current) =>
          current is IdentificationRequiredState ||
          current is IdentificationSuccessState,
      listener: (context, state) async {
        // Pour envoyer la transaction après confirmation
        if (state is IdentificationSuccessState) {
          // Motif"@SPLIT_100000_SN_Business Services_2024-08-18T14:15:22.999Z@"
          TransactionSendCommandMotif motif = TransactionSendCommandMotif(
              value: "@SPLIT_${transaction.montant}_"
                  "${transaction.clientPays}_"
                  "${transaction.clientNom}_"
                  "${transaction.dateOperation!.toIso8601String()}@");
          // Créer les commandes
          List<TransactionSendCommand> commands = [];
          for (var contact in selectedItems!) {
            if (contact.alias == "SELF") {
              continue;
            }
            commands.add(
              TransactionSendCommand(
                action: TransactionSendCommand.actionReceiveNow,
                method: TransactionSendMethod.alias,
                compte: transaction.compte,
                canal: TransactionCanal.transfertParRequestToPay.code,
                alias: TransactionSendCommandAlias(value: contact.alias!),
                amount: TransactionSendCommandAmount(
                  value:
                      double.tryParse(repartition[contact.alias!]!.text) ?? 0,
                ),
                motif: motif,
              ),
            );
          }
          context
              .read<TransactionSendBloc>() //
              .add(TransactionSendSplitSendEvent(
                commands,
                state.method.toString(),
              ));
        }
        // Pour afficher page code pin form
        if (state is IdentificationRequiredState) {
          await AppRouter.push(context, AppRouter.identificationCheck);
        }
      },
      child: BlocListener<TransactionSendBloc, TransactionSendState>(
        listenWhen: (previous, current) =>
            current is TransactionSendFormVerificationLoadingState ||
            current is TransactionSendFormSuccessState ||
            current is TransactionSendFormErrorState ||
            current is TransactionSendInitialState,
        listener: (context, state) async {
          if (state is TransactionSendFormVerificationLoadingState) {
            CustomLoadingDialog.show(context);
          } else {
            CustomLoadingDialog.hide(context);
          }

          // Show success popup
          if (state is TransactionSendFormSuccessState) {
            CustomLoadingDialog.hide(context);
            bool isBottomSheetClosed = false;
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return TransactionSendPageSuccess(
                  transaction: state.transaction,
                  onClose: () => isBottomSheetClosed = true,
                );
              },
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
            );
            // Fermer le bottom sheet après 3 secondes
            Future.delayed(const Duration(seconds: 3), () {
              if (context.mounted && !isBottomSheetClosed) {
                AppRouter.pop(context);
                AppRouter.pushReplacement(context, AppRouter.home);
              }
            });
          }

          // Show Error popup
          if (state is TransactionSendFormErrorState) {
            CustomLoadingDialog.hide(context);
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return TransactionSendPageError(error: state.error);
              },
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
            );
          }
        },
        child: ElevatedButton(
          onPressed: _isRepartitionValid()
              ? () async {
                  context
                      .read<IdentificationBloc>() //
                      .add(const AskIdentificationBeforeActionEvent());
                }
              : null,
          child: Text(traductions.transactionSplitRepartitionTitle),
        ),
      ),
    );
  }

  bool _isRepartitionValid() {
    double total = 0;
    for (var contact in repartition.values) {
      total += double.tryParse(contact.text) ?? 0;
    }
    return total == transaction.montant;
  }
}
