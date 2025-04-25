import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/input_text.dart';
import '../../../../../shared/widgets/loading_page.dart';
import '../../../../security/presentation/bloc/identification/identification_bloc.dart';
import '../../../../security/presentation/bloc/identification/identification_event.dart';
import '../../../../security/presentation/bloc/identification/identification_state.dart';
import '../../../domain/models/transaction.dart';
import '../../bloc/transaction_details/transaction_details_bloc.dart';
import '../../bloc/transaction_details/transaction_details_event.dart';

class TransactionDetailsPageActionsReturn extends StatelessWidget {
  //
  const TransactionDetailsPageActionsReturn({super.key});

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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Titre
                Center(
                  child: Text(
                    traductions.transactionDetailsReturnTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const SizedBox(height: 20),

                // EndtToEndToId
                CustomTextInput(
                  labelText: traductions.transactionDetailsReference,
                  controller: TextEditingController()..text = tx.endToEndId,
                  readOnly: true,
                ),
                const SizedBox(height: 20),

                // Nom du payeur
                CustomTextInput(
                  labelText: traductions.transactionDetailsPayeurLabel,
                  controller: TextEditingController()..text = tx.clientNom,
                  readOnly: true,
                ),
                const SizedBox(height: 20),

                // Montant
                CustomTextInput(
                  labelText: traductions.transactionFormAmountHint,
                  controller: TextEditingController()
                    ..text = tx.montant.toString(),
                  readOnly: true,
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Non je ne retourne pas
                      Expanded(
                        child: FilledButton.tonal(
                          onPressed: () => AppRouter.pop(context),
                          child: Text(traductions.btnTextNo),
                        ),
                      ),
                      // Séparateur
                      const SizedBox(width: 16),
                      // Oui je  retourne les fonds
                      Expanded(
                          child: _btnConfirm(
                        context,
                        traductions,
                        transactionDetailsBloc,
                        tx,
                      )),
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

  Widget _btnConfirm(
    BuildContext context,
    AppLocalizations traductions,
    TransactionDetailsBloc transactionDetailsBloc,
    Transaction tx,
  ) {
    return BlocListener<IdentificationBloc, IdentificationState>(
      listener: (context, state) async {
        // Pour afficher page code pin form
        if (state is IdentificationRequiredState) {
          await AppRouter.push(context, AppRouter.identificationCheck);
        }
        // Pour envoyer la transaction après confirmation
        if (state is IdentificationSuccessState) {
          transactionDetailsBloc.add(
            TransactionReturnSendEvent(tx),
          );
          if (context.mounted) {
            CustomLoadingDialog.show(context);
          }
        }
      },
      listenWhen: (previous, current) =>
          previous is IdentificationSuccessState ||
          current is IdentificationSuccessState,
      child: ElevatedButton(
        onPressed: () {
          context
              .read<IdentificationBloc>() //
              .add(const AskIdentificationBeforeActionEvent());
        },
        child: Text(traductions.btnTextYes),
      ),
    );
  }
}
