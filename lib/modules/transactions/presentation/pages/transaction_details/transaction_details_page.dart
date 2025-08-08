import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/di.dart';
import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/models/uemoa_countries.dart';
import '../../../../../shared/widgets/loading_page.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../../shared/widgets/notification_dialog.dart';
import '../../../domain/models/transaction.dart';
import '../../bloc/transaction_details/transaction_details_bloc.dart';
import '../../bloc/transaction_details/transaction_details_event.dart';
import '../../bloc/transaction_details/transaction_details_state.dart';
import '../transaction_list_item_widget.dart';
import 'transaction_details_page_actions.dart';
import 'transaction_details_page_categorie.dart';
import 'transaction_details_page_detail.dart';
import 'transaction_details_page_error.dart';
import 'transaction_details_page_header.dart';
import 'transaction_details_page_recu.dart';
import 'transaction_details_page_ticket.dart';

class TransactionDetailsPage extends StatelessWidget {
  ///
  const TransactionDetailsPage({
    super.key,
    required this.transaction,
    this.detailsBackRoute,
  });

  final Transaction transaction;
  // Route de redirection
  final String? detailsBackRoute;

  @override
  Widget build(BuildContext context) {
    TransactionDetailsBloc transactionDetailsBloc = TransactionDetailsBloc(
      Di.getTransactionInputPort(),
      transaction,
    )..add(TransactionDetailsFetchEvent(transaction));
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    //
    return BlocProvider<TransactionDetailsBloc>(
      create: (_) => transactionDetailsBloc,
      child: BlocConsumer<TransactionDetailsBloc, TransactionDetailsState>(
        listenWhen: (previous, current) =>
            current is TransactionDetailsReturnState ||
            current is TransactionDetailsCancelLoadingState ||
            current is TransactionDetailsCancelState,
        listener: (context, state) {
          if (state is! TransactionDetailsCancelLoadingState){
            CustomLoadingDialog.hide(context);
          }
          AppRouter.pop(context); //close form
          // Retour de fonds
          if (state is TransactionDetailsReturnState) {
            showModalBottomSheet<void>(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return state.error != null
                    ? TransactionDetailsPageError(error: state.error!)
                    : NotificationDialog(
                        type: NotificationType.success,
                        message:
                            traductions.transactionDetailsReturnSuccessMessage,
                        btnText: traductions.btnTextContinue,
                        btnAction: () => {AppRouter.pop(context)},
                        btnColor: Theme.of(context).colorScheme.tertiary,
                      );
              },
              isScrollControlled: true,
            );
          }
          // Demande d'annulation
          if (state is TransactionDetailsCancelState) {
            showModalBottomSheet<void>(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return state.error != null
                    ? TransactionDetailsPageError(error: state.error!)
                    : NotificationDialog(
                        type: NotificationType.success,
                        title:
                            traductions.transactionDetailsCancelSuccessMessage,
                        description: traductions
                            .transactionDetailsCancelSuccessDescription,
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
          // if (state is TransactionDetailsSuccessState) {
          //   imgFilePath = state.transaction.ticketDeCaisse;
          // } else if (state is LoadTicketSuccessState) {
          //   imgFilePath = state.imagePath;
          // } else if (state is AddCategorieSuccessState) {
          //   transactionLocal.categorie = state.categorie;
          // }
          Transaction transaction = state.transaction;
          if (state is TransactionDetailsCancelLoadingState) {
            return const LoadingPage();
          } else {
          return MyPageContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BackButton(
                      onPressed: () {
                        if (detailsBackRoute != null) {
                          AppRouter.pushReplacement(context, detailsBackRoute!);
                        } else {
                          AppRouter.pop(context);
                        }
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ListView(
                      children: [
                        // Header: client details
                        TransactionDetailsPageHeader(
                          transaction: transaction,
                        ),

                        const SizedBox(height: 16),

                        // Buttons actions
                        TransactionDetailsPageActions(transaction: transaction),

                        const SizedBox(height: 10),

                        // Informations sur la demande d'annulation
                        if (transaction.annulationDate != null) ...[
                          TransactionDetailsPageDetail(
                            label: traductions.transactionDetailsCancelTitle,
                            description: DateFormat('d MMM yyyy, HH:mm')
                                .format(transaction.annulationDate!),
                          ),
                          const SizedBox(height: 10),
                        ],

                        // Informations sur le retour de fonds
                        if (transaction.retourDate != null) ...[
                          TransactionDetailsPageDetail(
                            label:
                                traductions.transactionDetailsRetourDateLabel,
                            description: DateFormat('d MMM yyyy, HH:mm')
                                .format(transaction.retourDate!),
                          ),
                          const SizedBox(height: 10),
                        ],

                        // Note
                        if (transaction.motif != null &&
                            transaction.motif!.startsWith("@SPLIT")) ...[
                          _paiementPartage(context, traductions, transaction),
                        ] else ...[
                          TransactionDetailsPageDetail(
                            label: _motif(
                              transaction,
                              traductions,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],

                        // facture
                        if (transaction.facture != null) ...[
                          TransactionDetailsPageDetail(
                            label: traductions.transactionFormFactureLabel,
                            description: transaction.facture!,
                          ),
                          const SizedBox(height: 10),
                        ],

                        // Reçu du paiement
                        TransactionDetailsPageDetail(
                          label: traductions.transactionDetailsRecuPaiement,
                          actionIcon: const Icon(Icons.file_download_outlined),
                          actionText: traductions.transactionDetailsTelecharger,
                          actionFunction: () => showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              // Page reçu de paiement
                              return TransactionDetailsPageRecu(
                                transaction: transaction,
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Details client
                        Card(
                          child: Column(
                            children: [
                              //  Nom du client
                              TransactionDetailsPageDetail(
                                label: transaction.sens == TransactionSens.debit
                                    ? traductions.transactionDetailsPayeLabel
                                    : traductions.transactionDetailsPayeurLabel,
                                description:transaction.sens ==  TransactionSens.debit ?
                                  transaction.acquirerAccountLabel : transaction.clientNom,
                              ),

                              // Pays du client
                              TransactionDetailsPageDetail(
                                label: traductions.transactionDetailsPays,
                                description:
                                    UEMOACountry.get(transaction.clientPays)!
                                        .name,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),
                        // End 2 End Id
                        TransactionDetailsPageDetail(
                          label: traductions.transactionDetailsReference,
                          description: transaction.endToEndId,
                        ),

                        const SizedBox(height: 10),

                        // Autres
                        Card(
                          child: Column(
                            children: [
                              // Catégorie
                              TransactionDetailsPageCategorie(
                                traductions: traductions,
                                transaction: transaction,
                                transactionDetailsBloc: transactionDetailsBloc,
                              ),

                              // Ticket de caisse
                              _ticketCaisse(context, traductions, transaction),

                              // Exclure de l'analytique
                              TransactionDetailsPageDetail(
                                label: traductions.transactionDetailsAnalytique,
                                action: Switch(
                                  value: false,
                                  onChanged: (value) => "",
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Poser une question
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
          }
        },
      ),
    );
  }

  String _motif(Transaction transaction, AppLocalizations traductions) {
    if (transaction.motif != null) {
      return transaction.motif!;
    } //
    else {
      if (transaction.sens == TransactionSens.credit) {
        return traductions.transactionDetailsMotifCredit;
      } else {
        return traductions.transactionDetailsMotifDebit;
      }
    }
  }

  /// Details sur le Paiement partagé
  Widget _paiementPartage(
    BuildContext context,
    AppLocalizations traductions,
    Transaction transaction,
  ) {
    // Format "@SPLIT_100000_SN_Business Services_2024-08-18T14:15:22.999Z@"
    // 1+5+1+7+1+2+1+50+1+24+1 =
    var parts = transaction.motif!.split("_");
    // Transaction payé par le demandeur
    Transaction origine = Transaction(
      compte: transaction.compte,
      montant: double.parse(parts[1]),
      sens: TransactionSens.debit,
      clientNom: parts[3],
      clientPays: parts[2],
      endToEndId: transaction.endToEndId,
      dateOperation: DateTime.parse(parts[4].replaceAll('@', '')),
      acquirerPhoneNumber: transaction.acquirerPhoneNumber,
      acquirerAccountLabel: transaction.acquirerAccountLabel,
    );
    // Afficher la transaction payée par le demandeur et le destinataire
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          traductions.transactionRtpDetailsSplitPaymentTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        // Transfert d'origine
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 3,
              horizontal: 15,
            ),
            child: TransactionListItemWidget(
              transaction: origine,
              detailsBackRoute: AppRouter.home,
              noLink: true,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _ticketCaisse(BuildContext context, AppLocalizations traductions,
      Transaction transaction) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // label
            Text(
              traductions.transactionDetailsTicket,
              style: Theme.of(context).textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),

            // Action
            TransactionDetailsPageTicket(
              transaction: transaction,
            ),
          ],
        ),
      ),
    );
  }
}
