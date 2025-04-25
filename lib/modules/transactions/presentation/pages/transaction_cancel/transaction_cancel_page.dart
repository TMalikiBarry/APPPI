import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/di.dart';
import '../../../../../core/router.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/models/uemoa_countries.dart';
import '../../../../../shared/widgets/loading_page.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../../shared/widgets/notification_dialog.dart';
import '../../../../security/presentation/bloc/identification/identification_bloc.dart';
import '../../../../security/presentation/bloc/identification/identification_event.dart';
import '../../../../security/presentation/bloc/identification/identification_state.dart';
import '../../../domain/models/transaction.dart';
import '../../bloc/transaction_cancel/transaction_cancel_bloc.dart';
import '../../bloc/transaction_cancel/transaction_cancel_event.dart';
import '../../bloc/transaction_cancel/transaction_cancel_state.dart';
import '../transaction_details/transaction_details_page_error.dart';
import 'transaction_cancel_reason_text.dart';

class TransactionCancelPage extends StatelessWidget {
  ///
  const TransactionCancelPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    TransactionCancelBloc transactionCancelBloc = TransactionCancelBloc(
      Di.getTransactionInputPort(),
      id,
    );
    transactionCancelBloc.add(TransactionCancelFetchEvent(id));
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    //
    return BlocProvider<TransactionCancelBloc>(
      create: (_) => transactionCancelBloc,
      child: BlocConsumer<TransactionCancelBloc, TransactionCancelState>(
        listenWhen: (previous, current) =>
            current is TransactionCancelLoadingState ||
            current is TransactionCancelReponseState,
        listener: (context, state) {
          if (state is TransactionCancelLoadingState) {
            CustomLoadingDialog.show(context);
          }
          if (state is TransactionCancelReponseState) {
            CustomLoadingDialog.hide(context);
            var successMessage =
                state.transaction.annulationStatut == TransactionStatut.rejete
                    ? traductions.transactionDetailsCancelRejectMessage
                    : traductions.transactionDetailsReturnSuccessMessage;
            showModalBottomSheet<void>(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return state.error != null
                    ? TransactionDetailsPageError(error: state.error!)
                    : NotificationDialog(
                        type: NotificationType.success,
                        message: successMessage,
                        btnText: traductions.btnTextContinue,
                        btnAction: () => {AppRouter.pop(context)},
                        btnColor: Theme.of(context).colorScheme.tertiary,
                      );
              },
              isScrollControlled: true,
            );
          }
        },
        builder: (context, state) {
          if (state is TransactionCancelDetailsState ||
              state is TransactionCancelLoadingState ||
              state is TransactionCancelReponseState) {
            Transaction tx = (state as dynamic).transaction;
            return MyPageContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BackButton(
                        onPressed: () {
                          AppRouter.pop(context);
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ListView(
                        children: [
                          // Header: title and phone number
                          _header(context, traductions, tx),
                          const SizedBox(height: 20),

                          // Infos sur le transfert
                          _detailsTransfert(context, traductions, tx),

                          const SizedBox(height: 10),

                          // Infos sur la Demande d'annulation
                          _detailsDemande(context, traductions, tx),
                        ],
                      ),
                    ),
                  ),
                  // Actions
                  if (tx.annulationStatut == TransactionStatut.initie &&
                      (tx.retourStatut == null ||
                          tx.retourStatut != TransactionStatut.irrevocable))
                    _actions(context, traductions, tx, transactionCancelBloc),
                ],
              ),
            );
          } else {
            return const LoadingPage();
          }
        },
      ),
    );
  }

  Widget _header(
    BuildContext context,
    AppLocalizations traductions,
    Transaction tx,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de la page
          Text(
            NumberFormat.currency(
              locale: Localizations.localeOf(context).toString(),
              symbol: '',
              decimalDigits: 0,
            ).format(tx.montant),
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          // Sous titre Transfert reçu montant
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              traductions.transactionDetailsCancelTitle,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Reference du transfert
          Text(
            id,
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ],
      ),
    );
  }

  /// Details sur le transfert
  Widget _detailsTransfert(
    BuildContext context,
    AppLocalizations traductions,
    Transaction tx,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: Column(
          children: [
            // Recu de
            _detail(
              context,
              title: traductions.transactionDetailsDateLabel,
              subtitle: DateFormat('d MMM, HH:mm').format(tx.dateOperation!),
            ),
            const SizedBox(height: 10),

            // Recu de
            _detail(
              context,
              title: traductions.transactionDetailsPayeurLabel,
              subtitle: tx.clientNom,
            ),
            const SizedBox(height: 10),

            // Pays
            _detail(
              context,
              title: traductions.transactionDetailsPays,
              subtitle: UEMOACountry.get(tx.clientPays)!.name,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// Details sur la demande d'annulation
  Widget _detailsDemande(
    BuildContext context,
    AppLocalizations traductions,
    Transaction tx,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: Column(
          children: [
            // date demande
            _detail(
              context,
              title: traductions.aliasClaimDetailsDateDemande,
              subtitle: DateFormat('d MMM, HH:mm').format(tx.annulationDate!),
            ),

            const SizedBox(height: 10),

            // Raison de la demande
            _detail(
              context,
              title: traductions.transactionDetailsCancelReasonLabel,
              subtitle: TransactionCancelReasonText.label(
                tx.annulationRaison!,
                traductions,
              ),
            ),
            const SizedBox(height: 10),

            // statut
            _detail(
              context,
              title: traductions.statutLabel,
              subtitle: _statut(
                tx.annulationStatut!,
                traductions,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// Affiche les boutons Accepter et rejeter
  Widget _actions(
    BuildContext context,
    AppLocalizations traductions,
    Transaction tx,
    TransactionCancelBloc transactionCancelBloc,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Rejeter
          Expanded(
            child: FilledButton.tonal(
              onPressed: () {
                transactionCancelBloc.add(
                  TransactionCancelRejectEvent(tx),
                );
              },
              child: Text(traductions.btnTextReject),
            ),
          ),
          //
          const SizedBox(width: 16),
          // Confirmer
          Expanded(
            child: BlocListener<IdentificationBloc, IdentificationState>(
              listener: (context, state) async {
                // Pour afficher page code pin form
                if (state is IdentificationRequiredState) {
                  await AppRouter.push(context, AppRouter.identificationCheck);
                }
                // Pour envoyer la transaction après confirmation
                if (state is IdentificationSuccessState) {
                  transactionCancelBloc.add(
                    TransactionCancelAcceptEvent(id, tx),
                  );
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
                child: Text(traductions.btnTextAccept),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Affiche un detail
  Widget _detail(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
        ),
        Expanded(
          child: Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Themer.neural03Color),
          ),
        ),
      ],
    );
  }

  /// Statut de la transaction
  String _statut(TransactionStatut statut, AppLocalizations traductions) {
    if (statut == TransactionStatut.irrevocable) {
      return traductions.statutAccepte;
    } else if (statut == TransactionStatut.rejete) {
      return traductions.statutRejete;
    } else {
      return traductions.statutInitie;
    }
  }
}
