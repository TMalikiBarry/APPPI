import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/di.dart';
import '../../../../../core/router.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/models/frequence_command.dart';
import '../../../../../shared/models/uemoa_countries.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../../shared/widgets/custom_loading_widget.dart';
import '../../../../../shared/widgets/notification_dialog.dart';
import '../../../domain/models/transaction.dart';
import '../../bloc/transaction_rtp/transaction_rtp_bloc.dart';
import '../../bloc/transaction_rtp/transaction_rtp_event.dart';
import '../../bloc/transaction_rtp/transaction_rtp_state.dart';
import '../transaction_details/transaction_details_page_error.dart';
import '../transaction_list_item_widget.dart';
import '../transaction_send/transaction_send_page_succes.dart';
import 'transaction_rtp_page_actions.dart';
import 'transaction_rtp_page_header.dart';


class TransactionRtpPage extends StatefulWidget {
  ///
  const TransactionRtpPage({super.key, required this.tx});

  final Transaction tx;

  @override
    State<TransactionRtpPage> createState() => _TransactionRtpPageState();
  }

class _TransactionRtpPageState extends State<TransactionRtpPage> {

  late TransactionRtpBloc transactionRtpBloc;

  @override
  void initState() {
    super.initState();
    print("tx : ${widget.tx.sens}");
    transactionRtpBloc = TransactionRtpBloc(
      Di.getTransactionInputPort(),
      Di.getPermissionInputPort(),
      widget.tx.endToEndId,
    );
    transactionRtpBloc.add(TransactionRtpFetchEvent(widget.tx));
  }

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    //
    return BlocProvider.value(
      value: transactionRtpBloc,
      child: BlocConsumer<TransactionRtpBloc, TransactionRtpState>(
        listenWhen: (previous, current) =>
            current is TransactionRtpLoadingState ||
            current is TransactionRtpReponseState,
        listener: (context, state) async {
          if (state is TransactionRtpLoadingState) {
            //CustomLoadingDialog.show(context);
          }
          if (state is TransactionRtpReponseState) {
            CustomLoadingDialog.hide(context);
            // Afficher le message de suuccès ou d'erreur
            _showMessage(context, state, traductions);
          }
        },
        builder: (context, state) {
          if (state is TransactionRtpDetailsState ||
              state is TransactionRtpLoadingState ||
              state is TransactionRtpReponseState) {
            if (state is TransactionRtpLoadingState) {
              return Scaffold(
                body: LoadingPage(),
              );
            }
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
                          TransactionRtpPageHeader(tx: tx),
                          const SizedBox(height: 20),

                          // Pays et Alias
                          _clientPaye(context, traductions, tx),
                          const SizedBox(height: 16),

                          // Statut et date d'echéance
                          _statutEcheance(context, traductions, tx),

                          // Facture remittance
                          if (tx.facture != null) ...[
                            const SizedBox(height: 16),
                            _facture(context, traductions, tx),
                          ],

                          // Remise
                          if (tx.remise != null) ...[
                            const SizedBox(height: 16),
                            _remise(context, traductions, tx),
                          ],

                          // Retrait
                          if (tx.retraitMontant != null) ...[
                            const SizedBox(height: 16),
                            _retrait(context, traductions, tx),
                          ],

                          // Debit différé
                          if (tx.differe != null && tx.differe!) ...[
                            const SizedBox(height: 16),
                            _differe(
                                context, traductions, tx, transactionRtpBloc),
                          ],

                          // Note
                          if (tx.motif != null) ...[
                            const SizedBox(height: 16),
                            // Afficher motif Paiement partagé
                            if (tx.motif!.startsWith("@SPLIT")) ...[
                              _paiementPartage(context, traductions, tx),
                            ] // Afficher motif texte
                            else ...[
                              _motif(context, traductions, tx),
                            ]
                          ]
                        ],
                      ),
                    ),
                  ),
                  // Actions
                  if (tx.sens == TransactionSens.debit &&
                      (tx.statut == null ||
                          tx.statut == TransactionStatut.initie))
                    TransactionRtpPageActions(tx: tx, bloc: transactionRtpBloc),
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

  /// pays et alias du client payé ou le demandeur
  Widget _clientPaye(
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
            // Pays
            _detail(
              context,
              title: traductions.transactionDetailsPays,
              subtitle: UEMOACountry.get(tx.clientPays)!.name,
            ),
            const SizedBox(height: 10),
            // Alias
            _detail(
              context,
              title: traductions.transactionDetailsAlias,
              subtitle: tx.clientAlias!,
            ),
          ],
        ),
      ),
    );
  }

  /// Statut et échéance de la demande
  Widget _statutEcheance(
    BuildContext context,
    AppLocalizations traductions,
    Transaction tx,
  ) {
    String statut = traductions.statutInitie;
    if (tx.statut == TransactionStatut.irrevocable) {
      statut = traductions.statutAccepte;
    }
    if (tx.statut == TransactionStatut.rejete) {
      statut = traductions.statutRejete;
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: Column(
          children: [
            // date d'échéance
            /*if (tx.canSchedule()) ...[
              _detail(
                context,
                title: traductions.transactionRtpDetailsEcheanceDate,
                subtitle: DateFormat('d MMM, HH:mm').format(tx.dateExpiration!),
              ),
              const SizedBox(height: 10),
            ],*/

            // date demande
            _detail(
              context,
              title: traductions.aliasClaimDetailsDateDemande,
              subtitle: DateFormat('d MMM, HH:mm').format(tx.dateOperation!),
            ),
            const SizedBox(height: 10),

            // statut
            _detail(
              context,
              title: traductions.statutLabel,
              subtitle: statut,
            ),
          ],
        ),
      ),
    );
  }

  /// Motif Texte
  Widget _motif(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              traductions.transactionFormMotifLabel,
              style: Theme.of(context).inputDecorationTheme.labelStyle,
            ),
            const SizedBox(height: 3),
            Text(
              tx.motif!,
              style: Theme.of(context).textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  /// Facture reference
  Widget _facture(
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
        child: _detail(
          context,
          title: traductions.transactionFormFactureLabel,
          subtitle: tx.facture!,
        ),
      ),
    );
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

  /// Details sur la remise
  Widget _remise(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Remise
            _detail(
              context,
              title: traductions.transactionRtpDetailsRemiseLabel,
              subtitle: _amt(context, tx.remise!),
            ),
            const SizedBox(height: 3),
            // Remise valable jusqu'au
            Text(
              traductions.transactionRtpDetailsRemiseHint(
                DateFormat('d MMM yyyy à HH:mm:ss').format(tx.dateReponse!),
              ),
              style: Theme.of(context).inputDecorationTheme.floatingLabelStyle,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  /// Debit différé
  Widget _differe(
    BuildContext context,
    AppLocalizations traductions,
    Transaction tx,
    TransactionRtpBloc bloc,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre
        Text(
          traductions.transactionRtpDetailsDiffereTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),

        // Paiements
        // Acheter maintenant Payer plus tard
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  traductions.transactionRtpDetailsDiffereSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.left,
                ),
                Text(
                  traductions.transactionRtpDetailsDiffereDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),

        // Payer en plusieurs transches
        if (tx.differeFrequence != null) ...[
          const SizedBox(height: 10),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Frequence des paiements
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: Text(
                    traductions.transactionRtpDetailsDifferePayFrequence(
                      tx.differeOccurence!,
                      _differeFrequence(
                        context,
                        traductions,
                        tx.differeFrequence!,
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.left,
                  ),
                ),
                // Montant a payer à chaque fois
                ListTile(
                  title: Text(
                    traductions.transactionRtpDetailsDifferePayAmt(
                      _amt(context, tx.differeMontant!),
                      _differeFrequence(
                        context,
                        traductions,
                        tx.differeFrequence!,
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: Switch(
                    value: tx.frequence != null,
                    onChanged: (value) {
                      print("changed $value");
                      bloc.add(TransactionRtpFrequenceEvent(tx, value));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _differeFrequence(
    BuildContext context,
    AppLocalizations traductions,
    Frequence freq,
  ) {
    if (freq == Frequence.quotidienne) {
      return traductions.transactionDetailsFrequenceJour;
    } else if (freq == Frequence.mensuelle) {
      return traductions.transactionDetailsFrequenceMois;
    } else {
      return "";
    }
  }

  /// Details sur le retrait
  Widget _retrait(
    BuildContext context,
    AppLocalizations traductions,
    Transaction tx,
  ) {
    // Afficher la transaction payée par le demandeur et le destinataire
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre
        Text(
          tx.isPICO()
              ? traductions.transactionRtpDetailsPICOTitle
              : traductions.transactionRtpDetailsPICASHTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        // Transfert d'origine
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Column(
              children: [
                // Montant Achat
                if (tx.isPICO()) ...[
                  _detail(
                    context,
                    title: traductions.transactionRtpDetailsAmtAchatTitle,
                    subtitle: _amt(context, tx.retraitAchat!),
                  ),
                  const SizedBox(height: 10),
                ],
                // Montant Retrait
                _detail(
                  context,
                  title: traductions.transactionRtpDetailsAmtRetraitTitle,
                  subtitle: _amt(context, tx.retraitMontant!),
                ),
                const SizedBox(height: 10),
                // Montant frais
                _detail(
                  context,
                  title: traductions.transactionRtpDetailsAmtFraisTitle,
                  subtitle: tx.retraitFrais == 0
                      ? traductions.noFees
                      : _amt(context, tx.retraitFrais!),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// Affiche un detail
  Widget _detail(
    BuildContext context, {
    required String title,
    required String? subtitle,
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
        if (subtitle != null)
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

  String _amt(BuildContext context, double montant) {
    return NumberFormat.currency(
      locale: Localizations.localeOf(context).toString(),
      symbol: '',
      decimalDigits: 0,
    ).format(montant);
  }

  /// Affiche le success ou error message apres acceptation ou rejet
  void _showMessage(
    BuildContext context,
    TransactionRtpReponseState state,
    AppLocalizations traductions,
  ) {
    bool isBottomSheetClosed = false;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return state.error != null
            ? TransactionDetailsPageError(error: state.error!)
            : state.transaction.statut == TransactionStatut.rejete
                ? NotificationDialog(
                    type: NotificationType.success,
                    message: traductions.transactionRtpRejectMessage,
                    btnText: traductions.btnTextContinue,
                    btnAction: () {
                      isBottomSheetClosed = true;
                      AppRouter.pop(context);
                      AppRouter.go(context, AppRouter.home);
                    },
                    btnColor: Theme.of(context).colorScheme.tertiary,
                  )
                : TransactionSendPageSuccess(
                    transaction: state.transaction,
                    onClose: () {
                      isBottomSheetClosed = true;
                    },
                  );
      },
      isScrollControlled: true,
    );
    // Fermer le bottom sheet après 3 secondes
    if (state.error == null) {
      Future.delayed(const Duration(seconds: 3), () {
        if (context.mounted && !isBottomSheetClosed) {
          AppRouter.pop(context);
          AppRouter.go(context, AppRouter.notifications);
        }
      });
    }
  }
}
