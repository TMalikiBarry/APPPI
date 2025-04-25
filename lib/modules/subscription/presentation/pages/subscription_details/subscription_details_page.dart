import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/di.dart';
import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/models/uemoa_countries.dart';
import '../../../../../shared/widgets/frequence_select_widget.dart';
import '../../../../../shared/widgets/loading_page.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../transactions/presentation/pages/transaction_details/transaction_details_page_detail.dart';
import '../../../domain/models/subscription.dart';
import '../../bloc/subscription_details/subscription_details_bloc.dart';
import '../../bloc/subscription_details/subscription_details_event.dart';
import '../../bloc/subscription_details/subscription_details_state.dart';
import 'subscription_details_page_actions.dart';
import 'subscription_details_page_categorie.dart';
import 'subscription_details_page_header.dart';
import 'subscription_details_page_note_sheet.dart';

class SubscriptionDetailsPage extends StatefulWidget {
  ///
  const SubscriptionDetailsPage({
    super.key,
    required this.subscription,
    required this.detailsBackRoute,
  });

  final Subscription subscription;
  // Route de redirection
  final String detailsBackRoute;

  ///
  @override
  State<SubscriptionDetailsPage> createState() =>
      _SubscriptionDetailsPageState();
}

class _SubscriptionDetailsPageState extends State<SubscriptionDetailsPage> {
  late SubscriptionDetailsBloc subscriptionDetailsBloc;

  @override
  void initState() {
    super.initState();
    subscriptionDetailsBloc = SubscriptionDetailsBloc(
      Di.getTransactionInputPort(),
      Di.getSubscriptionInputPort(),
      widget.subscription,
    );
  }

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;
    final DateFormat formatter = DateFormat('d MMM yyyy');

    //
    return BlocProvider<SubscriptionDetailsBloc>(
      create: (_) => subscriptionDetailsBloc,
      child: BlocConsumer<SubscriptionDetailsBloc, SubscriptionDetailsState>(
        listenWhen: (previous, current) =>
            (previous is SubscriptionDetailsInitialState &&
                current is SubscriptionDetailsLoadingState) ||
            (previous is SubscriptionDetailsLoadingState &&
                current is SubscriptionDetailsInitialState) ||
            (previous is SubscriptionDetailsLoadingState &&
                current is SubscriptionDetailsDeletedState),
        listener: (context, state) async {
          // Process en cours
          if (state is SubscriptionDetailsLoadingState) {
            CustomLoadingDialog.show(context);
          }
          // Après activation ou desactivation
          else if (state is SubscriptionDetailsInitialState) {
            CustomLoadingDialog.hide(context);
          }
          // Après suppression
          else if (state is SubscriptionDetailsDeletedState) {
            CustomLoadingDialog.hide(context);
            AppRouter.pushReplacement(
              context,
              widget.detailsBackRoute,
              params: 1,
            );
          }
        },
        builder: (context, state) {
          Subscription subscription = state.subscription;
          return MyPageContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BackButton(
                      onPressed: () {
                        AppRouter.pushReplacement(
                          context,
                          widget.detailsBackRoute,
                          params: 1,
                        );
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
                        SubscriptionDetailsPageHeader(
                          subscription: subscription,
                        ),

                        const SizedBox(height: 16),

                        // Buttons actions
                        SubscriptionDetailsPageActions(
                          subscription: subscription,
                        ),

                        const SizedBox(height: 10),

                        // Frequence
                        Card(
                          child: Column(
                            children: [
                              TransactionDetailsPageDetail(
                                label: traductions
                                    .transactionFormScheduleFrequenceLabel,
                                description: subscription.frequence == null
                                    ? traductions
                                        .transactionFormScheduleFrequenceUnefois
                                    : FrequenceSelectWidget.frequenceText(
                                        subscription.frequence!, traductions),
                              ),
                              // Date de début ou date d'exécution
                              TransactionDetailsPageDetail(
                                label: subscription.frequence == null
                                    ? traductions
                                        .subscriptionDateScheduledForTitle
                                    : traductions.subscriptionStartDate,
                                description:
                                    formatter.format(subscription.dateDebut!),
                              ),
                              // Prochain paiement
                              if (subscription.frequence != null &&
                                  subscription.nextPaymentDate != null)
                                TransactionDetailsPageDetail(
                                  label: traductions
                                      .subscriptionDateNextPaymentTitle,
                                  description: formatter.format(
                                    subscription.nextPaymentDate!,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Details client
                        Card(
                          child: Column(
                            children: [
                              //  Nom du client
                              TransactionDetailsPageDetail(
                                label: traductions.subscriptionPaymentTo,
                                description: subscription.clientNom,
                              ),

                              // Pays du client
                              TransactionDetailsPageDetail(
                                label: traductions.transactionDetailsPays,
                                description:
                                    UEMOACountry.get(subscription.clientPays)!
                                        .name,
                              ),

                              // Alias ou compte
                              if (subscription.clientAlias != null)
                                TransactionDetailsPageDetail(
                                  label: traductions.transactionDetailsAlias,
                                  description: subscription.clientAlias,
                                ),

                              if (subscription.clientAlias == null) ...[
                                // Compte
                                TransactionDetailsPageDetail(
                                  label: traductions.transactionDetailsCompte,
                                  description: subscription.clientCompte,
                                ),
                              ]
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Note
                        TransactionDetailsPageDetail(
                          label: subscription.motif ??
                              traductions.transactionFormMotifLabel,
                          actionIcon: const Icon(Icons.edit),
                          actionText: subscription.motif != null 
                            ? traductions.subscriptionEditNoteBtn
                            : traductions.transactionFormMotifHint,
                          actionFunction: () => showModalBottomSheet<String?>(
                            context: context,
                            builder: (BuildContext context) {
                              return SubscriptionDetailsPageNoteSheet(
                                note: subscription.motif,
                              );
                            },
                            isScrollControlled: true,
                          ).then((String? value) {
                            if (value != null) {
                              subscriptionDetailsBloc.add(
                                  SubscriptionDetailsNoteUpdateEvent(value));
                            }
                          }),
                        ),

                        const SizedBox(height: 10),

                        // Catégorie
                        SubscriptionDetailsPageCategorie(
                          traductions: traductions,
                          subscription: subscription,
                          detailsBloc: subscriptionDetailsBloc,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
